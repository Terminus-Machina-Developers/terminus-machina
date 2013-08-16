//-----------------------------------------------------------
//
//-----------------------------------------------------------
class ModScriptedPawn extends ScriptedPawn;

var class<PhaceBookFace> CharPhace;
var(ModScriptedPawn) texture PhaceTextures[4];
var(ModScriptedPawn) float fReactionTime;
var(ModScriptedPawn) bool bElectronic;   //can be hit by EMP
var(ModScriptedPawn) bool bMaskedSkin;   //need to force drawstyle to masked
                                         //Some humanoid enemies are androids
var float fMeleeTimer;                   //melee attack takes to long to hit
                                         //this forces melee attack to happen faster
var float StunLength;
var(ModScriptedPawn) float AttackSpeedMult;               //for sprinting attackers

var name OrigOrders;
var name OrigOrdersTag;
var bool bConverging;


// ----------------------------------------------------------------------
// UpdatePoison()
// ----------------------------------------------------------------------

function UpdatePoison(float deltaTime)
{
	if ((Health <= 0) || bDeleteMe)  // no more pain -- you're already dead!
		return;

	if (poisonCounter > 0)
	{
		poisonTimer += deltaTime;
		if (poisonTimer >= 0.5)  // pain every two seconds
		{
			poisonTimer = 0;
			poisonCounter--;
			TakeDamage(poisonDamage, Poisoner, Location, vect(0,0,0), 'PoisonEffect');
		}
		if ((poisonCounter <= 0) || (Health <= 0) || bDeleteMe)
			StopPoison();
	}
}

// ----------------------------------------------------------------------
// TravelPostAccept()
// ----------------------------------------------------------------------

function TravelPostAccept()
{
    //Masked Character textures
    if(bMaskedSkin)
        SetSkinStyle(STY_Masked);
}

// ----------------------------------------------------------------------
// PostPostBeginPlay()
// ----------------------------------------------------------------------

function PostPostBeginPlay()
{
	Super.PostPostBeginPlay();

    //Masked Character textures
    if(bMaskedSkin)
        SetSkinStyle(STY_Masked);
}

// ----------------------------------------------------------------------
// StartPoison()
// ----------------------------------------------------------------------

function StartPoison(int Damage, Pawn newPoisoner)
{
	if ((Health <= 0) || bDeleteMe)  // no more pain -- you're already dead!
		return;

	poisonCounter = 4;    // take damage no more than eight times (over 16 seconds)
	poisonTimer   = 0;    // reset pain timer
	Poisoner      = newPoisoner;
	if (poisonDamage < Damage)  // set damage amount
		poisonDamage = Damage * 2;
}

// ----------------------------------------------------------------------
// ReactToInjury()
// ----------------------------------------------------------------------

/*function ReactToInjury(Pawn instigatedBy, Name damageType, EHitLocation hitPos)
{
	    local ModMale plyr;
	        ClientMessage("Change alliance");
    super.ReactToInjury(instigatedBy, damageType, hitPos );



    plyr = ModMale(instigatedBy);
    if(plyr != none)
    {
        ClientMessage("Change alliance");
        ChangeAlly(plyr.Alliance, -1);
    }
}     */


// ----------------------------------------------------------------------
// HandToHandAttack()   Called from the mesh's animation
// ----------------------------------------------------------------------

//Changing this because HandToHandAttack is called with the fMeleeTimer

function HandToHandAttack()
{
}

function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, name damageType)
{
local ModMale plyr;

    super.TakeDamage(Damage, instigatedBy, hitlocation, momentum, damageType );
    //instigatedBy.ClientMessage("Change alliance");

   // plyr = ModMale(instigatedBy);
   // if(plyr != none)
   // {
        //instigatedBy.ClientMessage("Changing alliance");
        //Turn hostile to player when attacked
        if(ModMale(instigatedBy) != none)
        {
            //ModMale(instigatedBy).SetAlliance('Player');
            //ModMale(instigatedBy).SetPhaceWanted(true);
        }
        ChangeAlly(instigatedBy.Alliance, -1);
        //instigatedBy.ClientMessage("Changing alliance " $ instigatedBy.Alliance);
   // }
}

// ----------------------------------------------------------------------
// ModifyDamage()
// ----------------------------------------------------------------------

function float ModifyDamage(int Damage, Pawn instigatedBy, Vector hitLocation,
                            Vector offset, Name damageType)
{
	local int   actualDamage;
	local float headOffsetZ, headOffsetY, armOffset;

	actualDamage = Damage;

	// calculate our hit extents
	headOffsetZ = CollisionHeight * 0.7;
	headOffsetY = CollisionRadius * 0.3;
	armOffset   = CollisionRadius * 0.35;

	// if the pawn is stunned, damage is 4X
	if (bStunned)
		actualDamage *= 4;


	// if the pawn is hit from behind at point-blank range, he is killed instantly
	// doesn't work on bots
	else if (offset.x < 0 && (!bElectronic || (bElectronic && (instigatedBy.Weapon.AmmoName == class'DeusEx.AmmoBattery'))))
		if ((instigatedBy != None) && (VSize(instigatedBy.Location - Location) < 64))
			actualDamage  *= 10;

    if(bElectronic )
    {
        if( damageType == 'Stunned')
        {
            actualDamage *= 0.5;     //tasers not as strong
        }
        if( damageType == 'Shot')
        {
            //droids take half damage from bullets
            actualDamage *= 0.5;
        }
        if(( damageType == 'TearGas') || (damageType == 'PoisonGas') || (damageType == 'HalonGas') ||
			(damageType == 'Radiation') || (damageType == 'Poison'))
        {
            actualDamage = 0;
        }

    }
    //Quadruped mode = higher damage
    /*
    if(ModMale(InstigatedBy) != none)
    {
        if(ModMale(InstigatedBy).AugmentationSystem.GetAugLevelValue(class'AugQuadruped') > 0)
            actualDamage *= 6;
    } */

	actualDamage = Level.Game.ReduceDamage(actualDamage, DamageType, self, instigatedBy);

	if (ReducedDamageType == 'All') //God mode
		actualDamage = 0;
	else if (Inventory != None) //then check if carrying armor
		actualDamage = Inventory.ReduceDamage(actualDamage, DamageType, HitLocation);

	// gas, EMP and nanovirus do no damage
	if (damageType == 'TearGas' || damageType == 'EMP' || damageType == 'NanoVirus')
		actualDamage = 0;

	return actualDamage;

}

// ----------------------------------------------------------------------
// CheckCycle() [internal use only]
// ----------------------------------------------------------------------

function Pawn CheckCycle()
{
	local float attackPeriod;
	local float maxAttackPeriod;
	local float sustainPeriod;
	local float decayPeriod;
	local float minCutoff;
	local Pawn  cycleEnemy;
	local float combatdiff;

	attackPeriod    = 0.5;
	maxAttackPeriod = 4.5;
	sustainPeriod   = 3.0;
	decayPeriod     = 4.0;

	minCutoff = attackPeriod/maxAttackPeriod;

	cycleEnemy = None;

	if (CycleCumulative <= 0)  // no enemies seen during this cycle
	{
		CycleTimer -= CyclePeriod;
		if (CycleTimer <= 0)
		{
			CycleTimer = 0;
			EnemyReadiness -= CyclePeriod/decayPeriod;
			if (EnemyReadiness < 0)
				EnemyReadiness = 0;
		}
	}
	else  // I saw somebody!
	{
		CycleTimer = sustainPeriod;
		CycleCumulative *= 2;  // hack
		if (CycleCumulative < minCutoff)
			CycleCumulative = minCutoff;
		else if (CycleCumulative > 1.0)
			CycleCumulative = 1.0;
		//Added CyclePeriod * 10 to speed up AI reaction
		if(GetPlayerPawn() != none)
		    combatdiff = DeusExPlayer(GetPlayerPawn()).CombatDifficulty;
        else
            combatdiff = 1;
        EnemyReadiness += CycleCumulative*CyclePeriod*fReactionTime/attackPeriod;
		if (EnemyReadiness >= 1.0)
		{
			EnemyReadiness = 1.0;
			if (IsValidEnemy(CycleCandidate))
				cycleEnemy = CycleCandidate;
		}
		else if (EnemyReadiness >= SightPercentage)
			if (IsValidEnemy(CycleCandidate))
				HandleSighting(CycleCandidate);
	}
	CycleCumulative = 0;
	CyclePeriod     = 0;
	CycleCandidate  = None;
	CycleDistance   = 0;

	return (cycleEnemy);

}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
// CALLBACKS AND OVERRIDDEN FUNCTIONS
// ----------------------------------------------------------------------

// ----------------------------------------------------------------------
// Tick()
// ----------------------------------------------------------------------

function Tick(float deltaTime)
{
	local float        dropPeriod;
	local float        adjustedRate;
	local DeusExPlayer player;
	local name         stateName;
	local vector       loc;
	local bool         bDoLowPriority;
	local bool         bCheckOther;
	local bool         bCheckPlayer;

	player = DeusExPlayer(GetPlayerPawn());

	bDoLowPriority = true;
	bCheckPlayer   = true;
	bCheckOther    = true;
	if (bTickVisibleOnly)
	{
		if (DistanceFromPlayer > 1200)
			bDoLowPriority = false;
		if (DistanceFromPlayer > 2500)
			bCheckPlayer = false;
		if ((DistanceFromPlayer > 600) && (LastRendered() >= 5.0))
			bCheckOther = false;
        //If player gets too close even with Nohface on, NPC will get suspicious
	/*	else if (DistanceFromPlayer < 200 && GetAllianceType('Player') == ALLIANCE_Hostile){
            if(AICanSee(player, ComputeActorVisibility(player), true, true, true, true) > 0)
            {
                if(GetAllianceType(	player.Alliance) == ALLIANCE_Friendly)
                    ChangeAlly(	player.Alliance, -1);
            }
        }    */
	}

	if (bStandInterpolation)
		UpdateStanding(deltaTime);

	// this is UGLY!
	if (bOnFire && (health > 0))
	{
		stateName = GetStateName();
		if ((stateName != 'Burning') && (stateName != 'TakingHit') && (stateName != 'RubbingEyes'))
			GotoState('Burning');
	}
	else
	{
		if (bDoLowPriority)
		{
			// Don't allow radius-based convos to interupt other conversations!
			if ((player != None) && (GetStateName() != 'Conversation') && (GetStateName() != 'FirstPersonConversation'))
				player.StartConversation(Self, IM_Radius);
		}

		if (CheckEnemyPresence(deltaTime, bCheckPlayer, bCheckOther))
			HandleEnemy();
		else
		{
			CheckBeamPresence(deltaTime);
			if (bDoLowPriority || LastRendered() < 5.0)
				CheckCarcassPresence(deltaTime);  // hacky -- may change state!
		}
	}

	// Randomly spawn an air bubble every 0.2 seconds if we're underwater
	if (HeadRegion.Zone.bWaterZone && bSpawnBubbles && bDoLowPriority)
	{
		swimBubbleTimer += deltaTime;
		if (swimBubbleTimer >= 0.2)
		{
			swimBubbleTimer = 0;
			if (FRand() < 0.4)
			{
				loc = Location + VRand() * 4;
				loc.Z += CollisionHeight * 0.9;
				Spawn(class'AirBubble', Self,, loc);
			}
		}
	}

	// Handle poison damage
	UpdatePoison(deltaTime);
}

// ----------------------------------------------------------------------
// state Attacking
//
// Kill!  Kill!  Kill!  Kill!
// ----------------------------------------------------------------------

State Attacking
{
	function Tick(float deltaSeconds)
	{
		local bool   bCanSee;
		local float  yaw;
		local vector lastLocation;
		local Pawn   lastEnemy;
		local float  surpriseTime;

		Global.Tick(deltaSeconds);
		if (CrouchTimer > 0)
		{
			CrouchTimer -= deltaSeconds;
			if (CrouchTimer < 0)
				CrouchTimer = 0;
		}
        //Speed up if sprinter attacker
        GroundSpeed = default.GroundSpeed * attackspeedmult;
		EnemyTimer += deltaSeconds;
		UpdateActorVisibility(Enemy, deltaSeconds, 1.0, false);
		//Player phace becomes wanted if seen by hostile enemy
		if (Enemy != none){
            if(Enemy.IsA('DeusExPlayer'))
        	{
                ModMale(Enemy).SetPhaceWanted(true);
                ChangeAlly(	Enemy.Alliance, -1);

                //ModMale(Enemy).ClientMessage("Phace Now Wanted" $ ModMale(Enemy).Alliance);
        	}

        	if(fMeleeTimer < 0){
   	            Weapon.TraceFire(0.0);
   	            fMeleeTimer = 0;
        	}
        	else if(fMeleeTimer != 0){
                fMeleeTimer -= deltaSeconds;
            }
		}
		if ((Enemy != None) && HasEnemyTimedOut())
		{
			lastLocation = Enemy.Location;
			lastEnemy    = Enemy;
			FindBestEnemy(true);
			if (Enemy == None)
			{
				SetSeekLocation(lastEnemy, lastLocation, SEEKTYPE_Guess, true);
				GotoState('Seeking');
			}
		}
		else if (bCanFire && (Enemy != None))
		{
			ViewRotation = Rotator(Enemy.Location-Location);
			if (bFacingTarget)
				FireIfClearShot();
			else if (!bMustFaceTarget)
			{
				yaw = (ViewRotation.Yaw-Rotation.Yaw) & 0xFFFF;
				if (yaw >= 32768)
					yaw -= 65536;
				yaw = Abs(yaw)*360/32768;  // 0-180 x 2
				if (yaw <= FireAngle)
					FireIfClearShot();
			}
		}
		//UpdateReactionLevel(true, deltaSeconds);
	}

	function EndState()
	{
	    if (IsHandToHand()){
	        DeusExWeapon(Weapon).maxRange=DeusExWeapon(Weapon).default.maxRange;
            DeusExWeapon(Weapon).AccurateRange=DeusExWeapon(Weapon).default.AccurateRange;
	    }
	    GroundSpeed = default.GroundSpeed;
		EnableCheckDestLoc(false);
		bCanFire      = false;
		bFacingTarget = false;

		ResetReactions();
		bCanConverse = True;
		bAttacking = False;
		bStasis = True;
		bReadyToReload = false;

		EndCrouch();
	}

Begin:
    //Speed up if sprinter attacker
    GroundSpeed = default.GroundSpeed * attackspeedmult;
	if (Enemy == None)
		GotoState('Seeking');
	//EnemyLastSeen = 0;
	CheckAttack(false);

Surprise:
	if ((1.0-ReactionLevel)*SurprisePeriod < 0.25)
		Goto('BeginAttack');
	Acceleration=vect(0,0,0);
	PlaySurpriseSound();
	PlayWaiting();
	while (ReactionLevel < 1.0)
	{
		TurnToward(Enemy);
		Sleep(0);
	}

BeginAttack:
	EnemyReadiness = 1.0;
	ReactionLevel  = 1.0;
	if (PlayerAgitationTimer > 0)
		PlayAllianceHostileSound();
	else
		PlayTargetAcquiredSound();
	if (PlayBeginAttack())
	{
		Acceleration = vect(0,0,0);
		TurnToward(enemy);
		FinishAnim();
	}

RunToRange:
	bCanFire       = false;
	bFacingTarget  = false;
	bReadyToReload = false;
	EndCrouch();
	if (Physics == PHYS_Falling)
		TweenToRunning(0.05);
	WaitForLanding();
	if (!IsWeaponReloading() || bCrouching)
	{
		if (ShouldPlayTurn(Enemy.Location))
			PlayTurning();
		TurnToward(enemy);
	}
	else
		Sleep(0);
	bCanFire = true;
	while (PickDestination() == DEST_NewLocation)
	{
		if (bCanStrafe && ShouldStrafe())
		{
			PlayRunningAndFiring();
			if (destPoint != None)
				StrafeFacing(destPoint.Location, enemy);
			else
				StrafeFacing(destLoc, enemy);
			bFacingTarget = true;
		}
		else
		{
			bFacingTarget = false;
			PlayRunning();
			if (destPoint != None)
				MoveToward(destPoint, MaxDesiredSpeed);
			else
				MoveTo(destLoc, MaxDesiredSpeed);
		}
		CheckAttack(true);
	}

Fire:
	bCanFire      = false;
	bFacingTarget = false;
	Acceleration = vect(0, 0, 0);

	SwitchToBestWeapon();
	if (FRand() > 0.5)
		bUseSecondaryAttack = true;
	else
		bUseSecondaryAttack = false;
	if (IsHandToHand()){
	//HACK TO MAKE MELEE ACTUALLY A CHALLENGE
	     if(DeusExWeapon(Weapon).maxRange<100)
	     {
	         DeusExWeapon(Weapon).maxRange=100;
             DeusExWeapon(Weapon).AccurateRange=100;
         }
        fMeleeTimer = 0.3;
		TweenToAttack(0.0);
	}
	else if (ShouldCrouch() && (FRand() < CrouchRate))
	{
		TweenToCrouchShoot(0.15);
		FinishAnim();
		StartCrouch();
	}
	else
		TweenToShoot(0.15);
	if (!IsWeaponReloading() || bCrouching)
		TurnToward(enemy);
	FinishAnim();
	bReadyToReload = true;

ContinueFire:
	while (!ReadyForWeapon())
	{
		if (PickDestination() != DEST_SameLocation)
			Goto('RunToRange');
		CheckAttack(true);
		if (!IsWeaponReloading() || bCrouching)
			TurnToward(enemy);
		else
			Sleep(0);
	}
	CheckAttack(true);
	if (!FireIfClearShot())
		Goto('ContinueAttack');
	bReadyToReload = false;
	if (bCrouching)
		PlayCrouchShoot();
	else if (IsHandToHand()){

		PlayAttack();
	}
	else
		PlayShoot();
	FinishAnim();
	if (FRand() > 0.5)
		bUseSecondaryAttack = true;
	else
		bUseSecondaryAttack = false;
	bReadyToReload = true;
	if (!IsHandToHand())
	{
		if (bCrouching)
			TweenToCrouchShoot(0);
		else
			TweenToShoot(0);
	}
	CheckAttack(true);
	if (PickDestination() != DEST_NewLocation)
	{
		if (!IsWeaponReloading() || bCrouching)
			TurnToward(enemy);
		else
			Sleep(0);
		Goto('ContinueFire');
	}
	Goto('RunToRange');

ContinueAttack:
ContinueFromDoor:
	CheckAttack(true);
	if (PickDestination() != DEST_NewLocation)
		Goto('Fire');
	else
		Goto('RunToRange');



}

// ----------------------------------------------------------------------
// PlayAttack()
// ----------------------------------------------------------------------
/*
function PlayAttack()
{
	if (Region.Zone.bWaterZone)
		PlayAnimPivot('Tread',,,GetSwimPivot());
	else
	{
		if (bUseSecondaryAttack)
			PlayAnimPivot('AttackSide');
		else
			PlayAnimPivot('Attack',10);
	}
}     */

// ----------------------------------------------------------------------
// state Stunned
//
// React to being stunned.
// ----------------------------------------------------------------------

state Stunned
{
	ignores seeplayer, hearnoise, bump, hitwall;

	function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation,
						Vector momentum, name damageType)
	{
		TakeDamageBase(Damage, instigatedBy, hitlocation, momentum, damageType, false);
	}

	function ReactToInjury(Pawn instigatedBy, Name damageType, EHitLocation hitPos)
	{
		if ((damageType != 'TearGas') && (damageType != 'HalonGas') && (damageType != 'Stunned'))
			Global.ReactToInjury(instigatedBy, damageType, hitPos);
	}

	function SetFall()
	{
		StartFalling(NextState, NextLabel);
	}

	function AnimEnd()
	{
		PlayWaiting();
	}

	function BeginState()
	{
		StandUp();
		Disable('AnimEnd');
		bInterruptState = false;
		BlockReactions();
		bCanConverse = False;
		bStasis = False;
		SetupWeapon(false);
		SetDistress(true);
		bStunned = True;
		bInTransientState = true;
		EnableCheckDestLoc(false);
	}

	function EndState()
	{
		EnableCheckDestLoc(false);
		bInterruptState = true;
		ResetReactions();
		bCanConverse = True;
		bStasis = True;

		// if we're dead, don't reset the flag
		if (Health > 0)
			bStunned = False;
		bInTransientState = false;
	}

Begin:
	Acceleration = vect(0, 0, 0);
	PlayStunned();
	if(StunLength != 15){
	    Sleep(StunLength);
	    StunLength = 15;
    }
    else
	    Sleep(15);

	if (HasNextState())
		GotoNextState();
	else
		GotoState('Wandering');
}


function StunFor(int duration)
{
    PlaySound(Sound'DXModSounds.Misc.EMPgun',,,,2000);
    StunLength = duration;
    GotoState('Stunned');
}

// ----------------------------------------------------------------------
// GotoDisabledState()
// ----------------------------------------------------------------------

function GotoDisabledState(name damageType, EHitLocation hitPos)
{
	if (!bCollideActors && !bBlockActors && !bBlockPlayers)
		return;
	else if ((damageType == 'TearGas') || (damageType == 'HalonGas'))
		GotoState('RubbingEyes');
	else if (damageType == 'Stunned')
	{
	    if(StunLength <= 0)
	        StunLength = 15;
		GotoState('Stunned');
	}
    else if (CanShowPain())
		TakeHit(hitPos);
	else
		GotoNextState();
}

function InitConverging()
{
    bConverging = true;
    if(Orders != 'RunningTo')
    {
        OrigOrders = Orders;
        OrigOrdersTag = OrderTag;
    }
}

//
// SpawnBlood
//

function SpawnOil(Vector HitLocation, Vector HitNormal)
{
	spawn(class'DXMod.OilDrop',,,HitLocation+HitNormal);
	if (FRand() < 0.5)
		spawn(class'DXMod.OilDrop',,,HitLocation+HitNormal);
}

// ----------------------------------------------------------------------
// state RunningTo
//
// Move to an actor really fast.
// ----------------------------------------------------------------------

state RunningTo
{
Done:

	if (orderActor.IsA('PatrolPoint'))
		TurnTo(Location + PatrolPoint(orderActor).lookdir);
    if(bConverging)
    {
        bConverging = false;
        SetOrders(OrigOrders,OrigOrdersTag,true);
    }
    else
    {
	    GotoState('Standing');
    }
}

defaultproperties
{
     fReactionTime=1.000000
     StunLength=30.000000
     AttackSpeedMult=1.000000
}
