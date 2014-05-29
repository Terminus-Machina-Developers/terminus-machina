//-----------------------------------------------------------
//
//-----------------------------------------------------------
class SearcherDestroyer extends BlackHelicopter;

//Hide us when not in use
var bool bAttacking;
var float FireTimer;
var float FinishTimer;
var vector OldLocation;
var string FlightAxis;
var float flightZ;
var float RunwayWidth;
var float RunwayLength;
var bool bReverseDir;
 /*
function Trigger(Actor Other, Pawn Instigator)
{
    if(!IsInState('PreSearching') && !IsInState('Searching') && !IsInState('Destroying'))
        GotoState('Searching');
}   */


function PostBeginPlay()
{
    //local int l;
    super.PostBeginPlay();
    //for (l=0; l<8; l++)
    //{
    //    MultiSkins[0]. .Diffuse=138;
    //}

    GotoState('Waiting');
}

auto state Flying
{

	function BeginState()
	{
		Super.BeginState();
		AmbientSound=Sound'DXModSounds.Misc.SearcherDestroyer'; //Sound'Ambient.Ambient.Helicopter2';
		LoopAnim('Fly');
		//GetPlayerPawn().ClientMessage("Entering Flying State");
		if(!bAttacking)
		    GotoState('Waiting');
	}
}

state Waiting extends Active
{
	function BeginState()
	{
	    //GetPlayerPawn().ClientMessage("Entering Waiting State");
	    bHidden=true;
	    AmbientSound=none;
	    //GotoState('Searching');
		//bCollideWorld=false;
	    //SetCollision(Default.bCollideActors, Default.bBlockActors, Default.bBlockPlayers);
    }


}

//Waiting for a random time to start searching
state PreSearching extends Active
{

Begin:
    //GetPlayerPawn().ClientMessage("Entering Pre-searching State");
    //Sleep(Rand(30));
    GoToState('Searching');
}

//Looking for target to destroy - usually player
state Searching extends Active
{
    function BeginState()
    {
  		//GetPlayerPawn().ClientMessage("Entering Searching State");

    }
    function Tick(float deltaTime)
    {
        local PlayerPawn PP;
        local vector HitLoc, HitNorm, Start, End, RunwayStart, RunwayEnd;
        local bool bRunX, bRunY;

        bRunX=true;
        bRunY=true;
        PP = GetPlayerPawn();
        Start = PP.Location;
        Start.Z+=100;
        End = Start;
        End.Z+= 1000;
        //GetPlayerPawn().ClientMessage("Searching");
        Trace(HitLoc,HitNorm,End,Start);
        if(HitLoc.Z ==0){ //== End.Z) {
            //check there's enough space above player to fit chopper
            RunwayStart = End;
            RunwayStart.Y -= RunwayWidth;
            RunwayStart.X -= RunwayLength;
            RunwayEnd = End;
            RunwayEnd.Y -= RunwayWidth;
            RunwayEnd.X += RunwayLength;
            Trace(HitLoc,HitNorm,RunwayEnd,RunwayStart);
            if( HitLoc.Z != 0 )
            {
                //PP.ClientMessage("Not Enough Space for chopper");

                bRunX = false;
            }
            RunwayStart.Y += RunwayWidth*2;
            RunwayEnd.Y += RunwayWidth*2;
            Trace(HitLoc,HitNorm,RunwayEnd,RunwayStart);
            if( HitLoc.Z != 0 )
            {
                //PP.ClientMessage("Not Enough Space for chopper");
                bRunX = false;
            }

            if( bRunX )
            {
                FlightAxis="X";
                RunwayStart.Y -= RunwayWidth;
                //PP.ClientMessage("RunwayClear X");
                //RunwayStart.Z+=2000;
                SetLocation(RunwayStart);
                GotoState('Destroying');
                return;
            }
            RunwayStart = End;
            RunwayStart.X -= RunwayWidth;
            RunwayStart.Y -= RunwayLength;
            RunwayEnd = End;
            RunwayEnd.X -= RunwayWidth;
            RunwayEnd.Y += RunwayLength;
            Trace(HitLoc,HitNorm,RunwayEnd,RunwayStart);
            if( HitLoc.Z != 0 )
            {
                //PP.ClientMessage("Not Enough Space for chopper");
                bRunY = false;
            }

            RunwayStart.X += RunwayWidth*2;
            RunwayEnd.X += RunwayWidth*2;
            Trace(HitLoc,HitNorm,RunwayEnd,RunwayStart);
            if( HitLoc.Z != 0 )
            {
                //PP.ClientMessage("Not Enough Space for chopper");
                bRunY = false;
            }

            if(bRunY)
            {
                FlightAxis="Y";
                //PP.ClientMessage("RunwayClear X");
                //RunwayStart.Z+=2000;
                RunwayEnd.X -= RunwayWidth;
                SetLocation(RunwayEnd);
                GotoState('Destroying');
                return;
            }
/*
            RunwayStart.Y -= 200;
            RunwayStart = End;
            RunwayStart.Y -= 200;
            RunwayEnd = End;
            RunwayEnd.Y += 200;
            Trace(HitLoc,HitNorm,RunwayEnd,RunwayStart);
            if( HitLoc.Z != 0 )
            {
                //PP.ClientMessage("Not Enough Space for chopper");
                return;
            }
            //Check the Runway
            RunwayStart = End;
            RunwayStart.X -= 4000;
            RunwayEnd = End;
            RunwayEnd.X += 4000;
            Trace(HitLoc,HitNorm,RunwayEnd,RunwayStart);
            if( HitLoc.Z == 0 )
            {
                FlightAxis="X";
                //PP.ClientMessage("RunwayClear X");
                //RunwayStart.Z+=2000;
                SetLocation(RunwayStart);
                GotoState('Destroying');
            }
            else
            {
                RunwayStart = End;
                RunwayStart.Y -= 4000;
                RunwayEnd = End;
                RunwayEnd.Y += 4000;
                Trace(HitLoc,HitNorm,RunwayEnd,RunwayStart);
                if( HitLoc.Z == 0 )
                {
                    FlightAxis="Y";
                    //PP.ClientMessage("RunwayClear Y");
                    //RunwayEnd.Z+=2000;
                    SetLocation(RunwayEnd);
                    GotoState('Destroying');
                }
            }
            */
            //GotoState('Destroying');
        }
        else
        {
            //PP.ClientMessage("Player Obscured" $ end.Z $ " " $ HitLoc.Z);
        }

    }
}

//TIME TO DIE FUCKA
state Destroying extends Active
{
	function BeginState()
	{
        local PlayerPawn PP;
        local rotator newrot;
        local vector newVec;

        PP = GetPlayerPawn();
        if(ModMale(PP).bJammedDrones)
        {
			PP.ClientMessage("Searcher-Destroyer drone jammed");
            GotoState('Jammed');
        } else
		{
	    PP.ClientMessage("Searcher-Destroyer drone inbound!!!");
	    PP.PlaySound(Sound'DeusExSounds.UserInterface.Menu_Incoming',,,true );
	    bHidden=false;
		bCollideWorld=false;
	    SetCollision(Default.bCollideActors, Default.bBlockActors, Default.bBlockPlayers); //I had to set these this way for it to be hit by weapons fire
	    SetPhysics(PHYS_None);
 		AmbientSound=Sound'DXModSounds.Misc.SearcherDestroyer';//Sound'Ambient.Ambient.Helicopter2';
 		if(RandRange(0,1) < 0.5){
 		    bReverseDir = true;
        }
        else{
            bReverseDir = false;
        }
			newrot = rot(0,0,0);
			if(FlightAxis == "Y")
				newrot.Yaw=-16384;

			newVec = Location;
			//Make a 180 and come down from the opposite direction randomly
			if(bReverseDir)
			{
				if(FlightAxis == "X")
					newVec.X += 8000;
				else
					newVec.Y -= 8000;

				newrot.Yaw += 32768;

				SetLocation( newVec);

			}
			SetRotation(newrot);
			LoopAnim('Fly');
			//FireMissilesAt('Player');
			//MoveSmooth(vect(50,0,0));
			SetTimer(6,false);
			FlightZ=0;
			FireTimer=2.0;
		}
    }

    function Tick(float deltaTime)
    {


        local float Xpos;

        local vector newVec;
        //if(OldLocation != Location)
        //{
        newVec = Location; //vect(0,0,0);
        if(FlightAxis == "X")
        {
            //Move backwards if reversing direction
            if(bReverseDir)
                newVec.X = Location.X - 1000*deltaTime;
            else
                newVec.X = Location.X + 1000*deltaTime;
        }
        else
            if(bReverseDir)
                newVec.Y = Location.Y + 1000*deltaTime;
            else
                newVec.Y = Location.Y - 1000*deltaTime;

        newVec.Z+=FlightZ*deltaTime;

        SetLocation(newVec);

        //GetPlayerPawn().ClientMessage("DestroyTick");
        if(FireTimer > 0)
            FireTimer-=deltaTime;
        else if(FireTimer > -10)
        {
            FireMissilesAt('Player');
            FireTimer = -20;
            FinishTimer = 8;
        }
        else
        {
            FinishTimer -= deltaTime;
            //Finish the flight then go into hiding
            if(FinishTimer <= 0)
                GotoState('Waiting');
        }

    }

    function Timer()
    {
        FlightZ = 600;
        //FireMissilesAt('Player');
    }


 //Blow some shit up
function FireMissilesAt(name targetTag)
{
	local int i;
	local Vector loc;
	local SearcherDestroyer chopper;
	//local RocketLAW rocket;
	local RocketDrone rocket;
	local Actor A, Target;
    /*
    if(targetTag == 'Player')
        Target = self;
    else{
    	foreach AllActors(class'Actor', A, targetTag)
    		Target = A;
	}  */
    Target = GetPlayerPawn();
    if(ModMale(Target) != none)
    {
        if( ModMale(Target).AugmentationSystem.GetAugLevelValue(class'AugSilverCoat') > 0)
        {
            GetPlayerPawn().ClientMessage("Searcher Destroyer unable to lock-on due to Silver Coat!");
            GetPlayerPawn().PlaySound(Sound'DXModSounds.Misc.DroneThwart',,,true );
            return;
        }
    }
    chopper = self;
	// fire missiles from the helicopter
	//foreach AllActors(class'BlackHelicopter', chopper, 'chopper')
	//{
	    //ClientMessage("Making Rocket");
 	/*
		for (i=-1; i<=1; i+=2)
		{

			loc = (i*chopper.CollisionRadius * vect(0,0.15,0)) >> chopper.Rotation;
            loc += chopper.Location;
			rocket = Spawn(class'RocketDrone', none,, loc, chopper.Rotation);
            if (rocket != None)
			{
			    //ClientMessage("RocketMade");
				rocket.bTracking = True;
				rocket.Target = Target;
				rocket.PlaySound(sound'RocketIgnite', SLOT_None, 2.0,, 2048);
			}
		}
	*/
		for (i=-1; i<=1; i+=2)
		{
			loc = (i*chopper.CollisionRadius * vect(0,0.15,0)) >> chopper.Rotation;
			loc += chopper.Location;
			//loc.X += 400;
			rocket = Spawn(class'RocketDrone', chopper,, loc, chopper.Rotation);
			if (rocket != None)
			{
				rocket.bTracking = True;
				rocket.Target = Target;
				rocket.PlaySound(sound'RocketIgnite', SLOT_None, 2.0,, 2048);
			}
		}

	//}
}

}

state Jammed extends Destroying
{
	function BeginState()
	{
        local PlayerPawn PP;
        local rotator newrot;
        local vector newVec;
		local Actor P;
		local ScriptedPawn enemyTarget;

        PP = GetPlayerPawn();
        
	    bHidden=false;
		bCollideWorld=false;
	    SetCollision(Default.bCollideActors, Default.bBlockActors, Default.bBlockPlayers); //I had to set these this way for it to be hit by weapons fire
	    SetPhysics(PHYS_None);
 		AmbientSound=Sound'DXModSounds.Misc.SearcherDestroyer';//Sound'Ambient.Ambient.Helicopter2';
 		if(RandRange(0,1) < 0.5){
 		    bReverseDir = true;
        }
        else{
            bReverseDir = false;
        }
		newrot = rot(0,0,0);
		if(FlightAxis == "Y")
			newrot.Yaw=-16384;

		//todo: maybe make it fly over the enemy target, rather than player
		newVec = Location;
		//Make a 180 and come down from the opposite direction randomly
		if(bReverseDir)
		{
			if(FlightAxis == "X")
				newVec.X += 8000;
			else
				newVec.Y -= 8000;

			newrot.Yaw += 32768;

			SetLocation( newVec);

		}
		SetRotation(newrot);
		LoopAnim('Fly');
		//FireMissilesAt('Player');
		//MoveSmooth(vect(50,0,0));
		SetTimer(6,false);
		FlightZ=0;
		FireTimer=2.0;
    }

    function Tick(float deltaTime)
    {


        local float Xpos;
		local ScriptedPawn enemyTarget;
		local ScriptedPawn P;
		local PlayerPawn PP;

        local vector newVec;
        //if(OldLocation != Location)
        //{
        newVec = Location; //vect(0,0,0);
        if(FlightAxis == "X")
        {
            //Move backwards if reversing direction
            if(bReverseDir)
                newVec.X = Location.X - 1000*deltaTime;
            else
                newVec.X = Location.X + 1000*deltaTime;
        }
        else
            if(bReverseDir)
                newVec.Y = Location.Y + 1000*deltaTime;
            else
                newVec.Y = Location.Y - 1000*deltaTime;

        newVec.Z+=FlightZ*deltaTime;

        SetLocation(newVec);

        //GetPlayerPawn().ClientMessage("DestroyTick");
        if(FireTimer > 0)
            FireTimer-=deltaTime;
        else if(FireTimer > -10)
        {
			//find a nearby enemy for the drone to target
			PP = GetPlayerPawn();
			foreach PP.AllActors(class'ScriptedPawn', P){
				//if the scripted pawn is hostile
				//try targetting only cybersec for now
				if ((P.Alliance=='CyberSec' && P.LineOfSightTo(PP, true))||(P.GetAllianceType(PP.alliance) == ALLIANCE_Hostile))
				{
					if (enemyTarget == None || P.DistanceFromPlayer < enemyTarget.DistanceFromPlayer)
					{
						enemyTarget = P;
					} 
				}
			}
			
			//enemyTarget = AquireTarget();
			if (enemyTarget != None)
			{
			GetPlayerPawn().ClientMessage("Drone has acquired enemy target");
			FireMissilesAtEnemy(enemyTarget);
			}
            FireTimer = -20;
            FinishTimer = 8;
        }
        else
        {
            FinishTimer -= deltaTime;
            //Finish the flight then go into hiding
            if(FinishTimer <= 0)
                GotoState('Waiting');
        }

    }

    function Timer()
    {
        FlightZ = 600;
        //FireMissilesAt('Player');
    }
	
 //Blow some shit up
function FireMissilesAtEnemy(ScriptedPawn targetTag)
{
	local int i;
	local Vector loc;
	local SearcherDestroyer chopper;
	//local RocketLAW rocket;
	local RocketDrone rocket;
	local Actor A, Target;
    
	Target = targetTag;
    //foreach AllActors(class'Actor', A, targetTag)
    //	Target = A;
    //Target = GetPlayerPawn();
    /*if(ModMale(Target) != none)
    {
        if( ModMale(Target).AugmentationSystem.GetAugLevelValue(class'AugSilverCoat') > 0)
        {
            GetPlayerPawn().ClientMessage("Searcher Destroyer unable to lock-on due to Silver Coat!");
            GetPlayerPawn().PlaySound(Sound'DXModSounds.Misc.DroneThwart',,,true );
            return;
        }
    }*/
    chopper = self;
	// fire missiles from the helicopter
	//foreach AllActors(class'BlackHelicopter', chopper, 'chopper')
	//{
	    //ClientMessage("Making Rocket");
 	/*
		for (i=-1; i<=1; i+=2)
		{

			loc = (i*chopper.CollisionRadius * vect(0,0.15,0)) >> chopper.Rotation;
            loc += chopper.Location;
			rocket = Spawn(class'RocketDrone', none,, loc, chopper.Rotation);
            if (rocket != None)
			{
			    //ClientMessage("RocketMade");
				rocket.bTracking = True;
				rocket.Target = Target;
				rocket.PlaySound(sound'RocketIgnite', SLOT_None, 2.0,, 2048);
			}
		}
	*/
		for (i=-1; i<=1; i+=2)
		{
			loc = (i*chopper.CollisionRadius * vect(0,0.15,0)) >> chopper.Rotation;
			loc += chopper.Location;
			//loc.X += 400;
			rocket = Spawn(class'RocketDrone', chopper,, loc, chopper.Rotation);
			if (rocket != None)
			{
				rocket.bTracking = True;
				rocket.Target = Target;
				rocket.PlaySound(sound'RocketIgnite', SLOT_None, 2.0,, 2048);
			}
		}

	//}
}

}

defaultproperties
{
	 ItemName="Search/Destroyer Drone"
     FlightAxis="X"
     RunwayWidth=150.000000
     RunwayLength=4000.000000
     bStasis=False
     Mesh=LodMesh'DXModCharacters.SearcherDestroyer'
     DrawScale=100.000000
     ScaleGlow=0.300000
     SoundRadius=136
     SoundVolume=0
     AmbientSound=None
	 bInvincible=False
	 HitPoints=100
	 minDamageThreshold=100
	 bExplosive=True
}
