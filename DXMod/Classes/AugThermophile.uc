//-----------------------------------------------------------
//
//-----------------------------------------------------------
class AugThermophile expands ModAugmentation;

defaultproperties
{
     CalorieRate=30.000000
     bUsesEnergy=False
     bBiohack=True
     EnergyRate=0.000000
     Icon=Texture'DXModUI.UI.AugIconFire'
     smallIcon=Texture'DXModUI.UI.AugIconFireSmall'
     AugmentationName="Thermophile"
     Description="**Install in AUG menu** |n|nA biohack that adds fire retardance.  Utilizing the genetic code of a mutant strain of hyperthermophile archeo bacteria known as 'Strain 451', this biohack will alter the biochemistry of the user's cells, allowing alternate high-temperature metabolization mechanisms utilizing iron and sulfur oxides.  The biohacked individual can thus withstand extreme temperatures while suffering minimal tissue damage. |n|nTECH ONE: Fire Resistance is increased slightly |n|nTECH TWO: Fire resistance is increased moderately.|n|nTECH THREE: A hacktivist is nearly invulnerable to fire damage.|n|nTECH FOUR: A hacktivist eats magma for breakfast."
     LevelValues(0)=0.400000
     LevelValues(1)=0.250000
     LevelValues(2)=0.100000
     AugmentationLocation=LOC_Torso
     MPConflictSlot=3
}
