//-----------------------------------------------------------
//
//-----------------------------------------------------------
class AugMask expands Augmentation;

var float mpAugValue;
var float mpEnergyDrain;

state Active
{
Begin:
	if ((Player.inHand != None) && (Player.inHand.IsA('DeusExWeapon')))
	//	Player.ServerConditionalNotifyMsg( Player.MPMSG_NoCloakWeapon );
	Player.PlaySound(Sound'CloakUp', SLOT_Interact, 0.85, ,768,1.0);
}

function Deactivate()
{
	Player.PlaySound(Sound'CloakDown', SLOT_Interact, 0.85, ,768,1.0);
	Super.Deactivate();
}

simulated function float GetEnergyRate()
{
	return energyRate * LevelValues[CurrentLevel];
}

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	// If this is a netgame, then override defaults
	if ( Level.NetMode != NM_StandAlone )
	{
		LevelValues[3] = mpAugValue;
		EnergyRate = mpEnergyDrain;
      AugmentationLocation = LOC_Eye;
	}
}

defaultproperties
{
     mpAugValue=1.000000
     mpEnergyDrain=40.000000
     Icon=Texture'DeusExUI.UserInterface.AugIconCloak'
     smallIcon=Texture'DeusExUI.UserInterface.AugIconCloak_Small'
     AugmentationName="Facial Derecognition"
     Description="Smart graphene mounted with micro LED arrays are adhered to the skin, turning the face into a projection "
     MPInfo="When active, you are invisible to enemy players.  Electronic devices and players with the vision augmentation can still detect you.  Cannot be used with a weapon.  Energy Drain: Moderate"
     LevelValues(0)=1.000000
     LevelValues(1)=0.830000
     LevelValues(2)=0.660000
     LevelValues(3)=0.500000
     AugmentationLocation=LOC_Subdermal
     MPConflictSlot=6
}
