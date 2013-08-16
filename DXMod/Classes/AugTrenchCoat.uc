//-----------------------------------------------------------
//
//-----------------------------------------------------------
class AugTrenchCoat extends ModAugmentation;

#exec texture IMPORT NAME=AugIconTrenchCoat FILE=Images\AugIconCoat.pcx GROUP=UserInterface MIPS=OFF
#exec texture IMPORT NAME=AugIconCoatSmall FILE=Images\AugIconCoatSmall.pcx GROUP=UserInterface MIPS=OFF


var float mpAugValue;
var float mpEnergyDrain;

state Active
{
Begin:
    //ModMale(Player).ToggleNohface(true);
}

function Deactivate()
{
	Super.Deactivate();
	//ModMale(Player).ToggleNohface(false);
}

function float GetEnergyRate()
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
      AugmentationLocation = LOC_Torso;
	}
}

defaultproperties
{
     mpAugValue=0.500000
     mpEnergyDrain=30.000000
     InventoryItem=Class'DXMod.TrenchCoat'
     bCanUninstall=True
     bUsesEnergy=False
     EnergyRate=0.000000
     MaxLevel=0
     Icon=Texture'DXMod.UserInterface.AugIconTrenchCoat'
     smallIcon=Texture'DXMod.UserInterface.AugIconTrenchCoat'
     bAlwaysActive=True
     AugmentationName="Weathered Trench Coat"
     Description="**Install in AUG menu** |n|nA webwork of East Asian plastileather and brown decay.  This coat's original hue has long been erased by the sandpaper of acid rain and thick hydrocarbons.  It has endured more nights in mulch-filled dumpsters than you care to remember.  Provides a modicum of bodily protection."
     MPInfo="When active, you are invisible to electronic devices such as cameras, turrets, and proximity mines.  Energy Drain: Very Low"
     LevelValues(0)=0.950000
     LevelValues(1)=0.800000
     LevelValues(2)=0.500000
     LevelValues(3)=0.100000
     AugmentationLocation=LOC_Torso
     MPConflictSlot=2
     LoopSound=None
}
