//-----------------------------------------------------------
//
//-----------------------------------------------------------
class ModHumanThug expands ModScriptedPawn;

function PostBeginPlay()
{
	Super.PostBeginPlay();

	// change the sounds for chicks
	if (bIsFemale)
	{
		HitSound1 = Sound'FemalePainMedium';
		HitSound2 = Sound'FemalePainLarge';
		Die = Sound'FemaleDeath';
	}
}

function bool WillTakeStompDamage(actor stomper)
{
	// This blows chunks!
	if (stomper.IsA('PlayerPawn') && (GetPawnAllianceType(Pawn(stomper)) != ALLIANCE_Hostile))
		return false;
	else
		return true;
}

defaultproperties
{
     BaseAccuracy=0.010000
     maxRange=700.000000
     CarcassType=Class'DeusEx.JoJoFineCarcass'
     WalkingSpeed=0.296000
     bPlayIdle=True
     bAvoidAim=False
     bCanCrouch=True
     bSprint=True
     CrouchRate=0.200000
     SprintRate=1.000000
     bReactAlarm=True
     EnemyTimeout=3.500000
     bCanTurnHead=True
     InitialInventory(0)=(Inventory=Class'DeusEx.WeaponStealthPistol')
     InitialInventory(1)=(Inventory=Class'DeusEx.Ammo10mm',Count=12)
     InitialInventory(2)=(Inventory=Class'DeusEx.WeaponCrowbar')
     walkAnimMult=0.750000
     GroundSpeed=200.000000
     WaterSpeed=80.000000
     AirSpeed=160.000000
     AccelRate=500.000000
     BaseEyeHeight=40.000000
     UnderWaterTime=20.000000
     AttitudeToPlayer=ATTITUDE_Ignore
     HitSound1=Sound'DeusExSounds.Player.MalePainSmall'
     HitSound2=Sound'DeusExSounds.Player.MalePainMedium'
     Die=Sound'DeusExSounds.Player.MaleDeath'
     HealthHead=150
     VisibilityThreshold=0.010000
     DrawType=DT_Mesh
     Mesh=LodMesh'DeusExCharacters.GM_DressShirt'
     MultiSkins(0)=Texture'DeusExCharacters.Skins.JoJoFineTex0'
     MultiSkins(1)=Texture'DeusExItems.Skins.PinkMaskTex'
     MultiSkins(2)=Texture'DeusExItems.Skins.PinkMaskTex'
     MultiSkins(3)=Texture'DeusExCharacters.Skins.JoJoFineTex2'
     MultiSkins(4)=Texture'DeusExCharacters.Skins.JoJoFineTex0'
     MultiSkins(5)=Texture'DeusExCharacters.Skins.JoJoFineTex1'
     MultiSkins(6)=Texture'DeusExItems.Skins.GrayMaskTex'
     MultiSkins(7)=Texture'DeusExItems.Skins.BlackMaskTex'
     CollisionRadius=20.000000
     CollisionHeight=47.500000
     Mass=150.000000
     Buoyancy=155.000000
     BindName="JoJoFine"
     FamiliarName="JoJo Fine"
     UnfamiliarName="JoJo Fine"
}
