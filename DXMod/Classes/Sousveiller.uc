//=============================================================================
// Sousveiller
//=============================================================================
class Sousveiller extends DeusExWeapon;

//
// mesh / Textures
//

//Correct Sousveiller code

#exec mesh IMPORT MESH=Sousveiller ANIVFILE=Models\Sousveiller3_a.3d DATAFILE=Models\Sousveiller3_d.3d ZEROTEX=1
#exec MESHMAP scale MESHMAP=Sousveiller X=.15 Y=.15 Z=.15//X=0.00390625 Y=0.00390625 Z=0.00390625
#exec mesh ORIGIN MESH=Sousveiller X=0 Y=0 Z=0
#exec mesh SEQUENCE MESH=Sousveiller SEQ=All		STARTFRAME=0	NUMFRAMES=1
#exec mesh SEQUENCE MESH=Sousveiller SEQ=Still	STARTFRAME=0	NUMFRAMES=1

#exec texture IMPORT NAME=SousveillerTex1 FILE=Textures\Sousveilgood.pcx GROUP="Skins"
#exec MESHMAP SETTEXTURE MESHMAP=Sousveiller NUM=0 TEXTURE=SousveillerTex1
// Icon textures
#exec texture IMPORT NAME=LargeIconSousveiller FILE=Textures\LargeIconSousveiller2.pcx GROUP=WEAPONS FLAGS=2
#exec texture IMPORT NAME=BeltIconSousveiller FILE=Textures\Sousbelt.pcx GROUP=WEAPONS FLAGS=2


/*
//Boxtest - testing a Milkshape model
#exec MESH IMPORT MESH=Boxtest ANIVFILE=MODELS\Boxtest_a.3d DATAFILE=MODELS\Boxtest_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=Boxtest X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=Boxtest SEQ=All STARTFRAME=0 NUMFRAMES=30
//#exec MESH SEQUENCE MESH=Boxtest SEQ=??? STARTFRAME=0 NUMFRAMES=30

#exec MESHMAP NEW MESHMAP=Boxtest MESH=Boxtest
#exec MESHMAP scale MESHMAP=Boxtest X=0.1 Y=0.1 Z=0.2

#exec texture IMPORT NAME=Jtex1 FILE=Textures\SousveillerTex1.pcx GROUP=Skins FLAGS=2
#exec texture IMPORT NAME=Jtex1 FILE=Textures\SousveillerTex1.pcx GROUP=Skins PALETTE=Jtex1
#exec MESHMAP SETTEXTURE MESHMAP=Boxtest NUM=1 TEXTURE=Jtex1
*/

var float	mpNoScopeMult;
var float                 FlashTime;
var float                 FlashTimer;

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	// If this is a netgame, then override defaults
	if ( Level.NetMode != NM_StandAlone )
	{
		HitDamage = mpHitDamage;
		BaseAccuracy = mpBaseAccuracy;
		ReloadTime = mpReloadTime;
		AccurateRange = mpAccurateRange;
		MaxRange = mpMaxRange;
		ReloadCount = mpReloadCount;
      bHasMuzzleFlash = True;
      ReloadCount = 1;
      ReloadTime = ShotTime;
	}


}


function TraceFire( float Accuracy )
{
	local vector HitLocation, HitNormal, StartTrace, EndTrace, X,Y,Z;
	local actor Other, A;
	local Pawn PawnOwner;
	local color crossColor;
	local float dotp;
    local vector HitVec, HitVec2D;
    local rotator OtherRotation   ;
    local PhaceBookFace faceItem;
 	local DataVaultImage image;
	local float HeadOffsetZ;
	local float HeadOffsetY;
	local float ArmOffset;
	local vector Offset;
	local float AimErrorMult;


	PawnOwner = Pawn(Owner);
    if(!bZoomed)
    {
           //AimErrorMult=10000000;
       PlaySound(CockingSound, SLOT_None);
       PawnOwner.ClientMessage("Camera must be zoomed-in ('c' key by default) ");
       return;
    }
    else
    {
         AimErrorMult=2;

    }
	Owner.MakeNoise(PawnOwner.SoundDampening);
	GetAxes(PawnOwner.ViewRotation,X,Y,Z);
	StartTrace = Owner.Location + CalcDrawOffset() + FireOffset.X * X + FireOffset.Y * Y + FireOffset.Z * Z;
	AdjustedAim = PawnOwner.AdjustAim(1000000, StartTrace, AimErrorMult*AimError, False, False);
	EndTrace = StartTrace + Accuracy * (FRand() - 0.5 )* Y * 1000
		+ Accuracy * (FRand() - 0.5 ) * Z * 1000;
		//	EndTrace = StartTrace + (Accuracy + 1) * (FRand() - 0.5 )* Y * 1000
		//+ (Accuracy + 1) * (FRand() - 0.5 ) * Z * 1000;
		//Fucks with accuracy
	X = vector(AdjustedAim);
	EndTrace += (10000 * X);
	Other = PawnOwner.TraceShot(HitLocation,HitNormal,EndTrace,StartTrace);



	if ( Pawn(Other) != None ) {

    	offset = (HitLocation - Other.Location) << Other.Rotation;

    	// calculate our hit extents
    	headOffsetZ = Other.CollisionHeight * 0.58;
    	headOffsetY = Other.CollisionRadius * 0.35;
    	armOffset = Other.CollisionRadius * 0.35;

    	if (offset.z > headOffsetZ )
    	{
    	    PawnOwner.ClientMessage("offset.z " $ offset.z $ " headoffsetz " $ headOffsetZ);
    	    /*
    		// narrow the head region
    		if ((Abs(offset.x) < headOffsetY) || (Abs(offset.y) < headOffsetY))
    		{
    			// Headshot, return 1;

    		}
    		else
    		{
                PlaySound(CockingSound, SLOT_None);
                PawnOwner.ClientMessage("Need headshot to capture profile!");
                return;
    		}           */
    	}
    	else
    	{
            PlaySound(CockingSound, SLOT_None);
            PawnOwner.ClientMessage("Need headshot to capture profile!");
            return;
    	}

    	GetAxes(Pawn(Other).Rotation,X,Y,Z);
	    //PawnOwner.ClientMessage(X.X $ " " $ X.Y $ " " $ X.Z);
    	//X.Z = 0;
    	HitVec = Normal(PawnOwner.Location - Pawn(Other).Location );
    	HitVec2D= HitVec;
    	//HitVec2D.Z = 0;
    	dotp = HitVec2D dot X;

    /*	//first check for head hit
    	if ( HitLoc.Z - Location.Z > 0.5 * CollisionHeight )
    	{
    		if (dotp > 0)
    			PlayHeadHit(tweentime);
    		else
    			PlayGutHit(tweentime);
    		return;
    	}*/
         if(Other.IsA('ModRobot') || Other.IsA('Robot'))
        {
             PawnOwner.ClientMessage("Non-humanoid entity - cannot complete capture.");
        }
        else
        {

            //must hit in front (face) to count
        	if (dotp > 0.1) {//then hit in front
        	    //Face Captured
                PawnOwner.ClientMessage("Facial Biometrics Captured");
                PlaySound(FireSound, SLOT_None);
                crossColor.R = 255; crossColor.G = 0; crossColor.B = 0;
                ModHUD(ModRootWindow(DeusExPlayer(Owner).rootWindow).hud).recCross.SetCrossType(1);
                ModHUD(ModRootWindow(DeusExPlayer(Owner).rootWindow).hud).recCross.SetCrosshair(true);
                FlashTimer=0;


           //if(ModScriptedPawn(Other).PhaceTextures[0] != none) {
                faceItem=spawn(class'PhaceBookFace');//(ModScriptedPawn(Other).CharPhace);
                if(ModScriptedPawn(Other) != none && ModScriptedPawn(Other).PhaceTextures[0] != none)
                {
                    faceItem.imageTextures[0] = ModScriptedPawn(Other).PhaceTextures[0];
                    faceItem.imageTextures[1] = ModScriptedPawn(Other).PhaceTextures[1];
                    faceItem.imageTextures[2] = ModScriptedPawn(Other).PhaceTextures[2];
                    faceItem.imageTextures[3] = ModScriptedPawn(Other).PhaceTextures[3];
                }
                else
                {
                    //Buff guys face is not tex 0
                    if(Other.Mesh == LodMesh'DeusExCharacters.GM_DressShirt_B')
                        faceItem.imageTextures[0] = Other.MultiSkins[2];
                    else
                        faceItem.imageTextures[0] = Other.MultiSkins[0];
                }
                //Buff guys face is not tex 0
                if(Other.Mesh == LodMesh'DeusExCharacters.GM_DressShirt_B')
                      faceItem.faceSkin = ScriptedPawn(Other).MultiSkins[2];
                else
                    faceItem.faceSkin = ScriptedPawn(Other).MultiSkins[0];

                faceItem.Alliance = ScriptedPawn(Other).Alliance;
                faceItem.imageDescription = Pawn(Other).FamiliarName;

            	// First make sure the player doesn't already have this image!!
            	image = ModMale(Owner).FirstPhace;
            	while(image != None)
            	{
            		if (faceItem.imageDescription == image.imageDescription){
            			faceItem.Destroy();
            			faceItem=none;
           			}

            		image = image.NextImage;
            	}
            	if( faceItem != none ){
                    ModMale(Owner).AddPhace(faceItem);
        			foreach AllActors(class 'Actor', A, 'facecaptured')
        			{
        				A.Trigger(Owner, Pawn(Owner));
                    }
                    //faceItem.BecomeItem();
                    //faceItem.bHidden=true;
                    //faceItem.GotoState('Idle2');
                }
            //}
			//faceItem.Destroy();
			//faceItem = None;


            }
        //	else if (dotp < -0.71) // then hit in back
        	else{
        	    PawnOwner.ClientMessage("No face detected -- need frontal view");
        	    PlaySound(CockingSound, SLOT_None);
        	}
    	}

    } else  {
        PlaySound(CockingSound, SLOT_None);
    }
	//ProcessTraceHit(Other, HitLocation, HitNormal, X,Y,Z);


}



function Fire( float Value )
{
	//if (AmmoType.UseAmmo(0))
	//{




		GotoState('NormalFire');
		if ( PlayerPawn(Owner) != None )
			PlayerPawn(Owner).ShakeView(ShakeTime, ShakeMag, ShakeVert);
		bPointing=True;
		PlayFiring();
		if ( !bRapidFire && (FiringSpeed > 0) )
			Pawn(Owner).PlayRecoil(FiringSpeed);
		if ( bInstantHit )
			TraceFire(0.0);
		else
			ProjectileFire(ProjectileClass, ProjectileSpeed, bWarnTarget);
		if ( Owner.bHidden )
			CheckVisibility();
	//}
}

//
// scope, laser, and targetting updates are done here
//
simulated function Tick(float deltaTime)
{
    super.Tick(deltaTime);
    if(FlashTimer < FlashTime){
        FlashTimer+=deltaTime;
        if(DeusExPlayer(Owner)!=none && DeusExPlayer(Owner).rootWindow != none && ModHUD(ModRootWindow(DeusExPlayer(Owner).rootWindow).hud) != none)
        {
            if(FlashTimer>=FlashTime){
                ModHUD(ModRootWindow(DeusExPlayer(Owner).rootWindow).hud).recCross.SetCrosshair(false);
            } else if(FlashTimer>=FlashTime-1.4){
                ModHUD(ModRootWindow(DeusExPlayer(Owner).rootWindow).hud).recCross.SetCrossType(3);
            }  else if(FlashTimer>=FlashTime-1.7){
                ModHUD(ModRootWindow(DeusExPlayer(Owner).rootWindow).hud).recCross.SetCrossType(2);
            }
        }
    }
}

defaultproperties
{
     mpNoScopeMult=0.350000
     FlashTime=2.000000
     LowAmmoWaterMark=6
     GoverningSkill=Class'DeusEx.SkillWeaponPistol'
     NoiseLevel=0.000000
     EnviroEffective=ENVEFF_Air
     ShotTime=1.500000
     reloadTime=2.000000
     HitDamage=0
     maxRange=4800800
     AccurateRange=1000800
     bCanHaveScope=True
     bHasScope=True
     bCanHaveLaser=True
     bCanHaveSilencer=True
     bCanTrack=True
     bHasMuzzleFlash=False
     bUseWhileCrouched=False
     mpReloadTime=2.000000
     mpAccurateRange=28800
     mpMaxRange=28800
     mpReloadCount=6
     bCanHaveModBaseAccuracy=True
     bCanHaveModReloadCount=True
     bCanHaveModAccurateRange=True
     bCanHaveModReloadTime=True
     bCanHaveModRecoilStrength=True
     AmmoName=Class'DeusEx.AmmoNone'
     ReloadCount=6
     PickupAmmoCount=6
     bInstantHit=True
     FireOffset=(X=-20.000000,Z=10.000000)
     shakemag=50.000000
     FireSound=Sound'DeusExSounds.Weapons.GEPGunLock'
     AltFireSound=Sound'DeusExSounds.Weapons.RifleReloadEnd'
     CockingSound=Sound'DeusExSounds.Weapons.RifleReload'
     SelectSound=Sound'DeusExSounds.Weapons.RifleSelect'
     InventoryGroup=5
     ItemName="Sousveiller"
     PlayerViewOffset=(X=20.000000,Z=-10.000000)
     PlayerViewMesh=LodMesh'DXMod.Sousveiller'
     PickupViewMesh=LodMesh'DXMod.Sousveiller'
     ThirdPersonMesh=LodMesh'DXMod.Sousveiller'
     LandSound=Sound'DeusExSounds.Generic.DropMediumWeapon'
     Icon=Texture'DXMod.Weapons.BeltIconSousveiller'
     largeIcon=Texture'DXMod.Weapons.LargeIconSousveiller'
     largeIconWidth=100
     largeIconHeight=100
     invSlotsX=2
     invSlotsY=2
     Description="A hi-spec 3D camera.  Used to capture facial recognition profiles for identity masking."
     beltDescription="SOUS"
     Mesh=LodMesh'DXMod.Sousveiller'
     CollisionRadius=26.000000
     CollisionHeight=2.000000
     Mass=30.000000
}
