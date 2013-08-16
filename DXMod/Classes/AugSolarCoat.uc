//-----------------------------------------------------------
//
//-----------------------------------------------------------
class AugSolarCoat extends ModAugmentation;



#exec texture IMPORT NAME=AugIconSolarCoat FILE=Images\SolarCoatIcon.pcx GROUP=UserInterface MIPS=OFF

var float mpAugValue;
var float mpEnergyDrain;

state Active
{
Begin:
    //ModMale(Player).ToggleNohface(true);
    if(Player.Energy < 0.001)
        Player.Energy = 0.001;
}

function Deactivate()
{
	Super.Deactivate();
	//ModMale(Player).ToggleNohface(false);
}

function float GetEnergyRate()
{
    //Player.ClientMessage(energyRate * (LevelValues[CurrentLevel] + Player.SkillSystem.GetSkillLevel(class'SkillEnviro')));
	return energyRate * (LevelValues[CurrentLevel] + Player.SkillSystem.GetSkillLevel(class'SkillEnviro'));
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
     InventoryItem=Class'DXMod.SolarCoat'
     bCanUninstall=True
     bUsesEnergy=False
     bElectrohack=True
     EnergyRate=-4.000000
     MaxLevel=0
     Icon=Texture'DXMod.UserInterface.AugIconSolarCoat'
     smallIcon=Texture'DXMod.UserInterface.AugIconSolarCoat'
     AugmentationName="AugSolarCoat"
     Description="**Install in AUG menu** |n|nMonocrystalline photovoltaics are stitched into your coat on the fly to allow constant replenishment of electricity reserves beneath sunlight, or the million-watt glare of a nuclear flash."
     MPInfo="When active, you are invisible to electronic devices such as cameras, turrets, and proximity mines.  Energy Drain: Very Low"
     LevelValues(0)=1.000000
     LevelValues(1)=1.500000
     LevelValues(2)=2.300000
     LevelValues(3)=4.000000
     AugmentationLocation=LOC_Torso
     MPConflictSlot=2
     LoopSound=None
}
