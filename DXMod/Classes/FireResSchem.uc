//-----------------------------------------------------------
//
//-----------------------------------------------------------
class FireResSchem expands Schematic;

defaultproperties
{
     imageTexture=Texture'DXModUI.UI.EMPGunIcon'
     imageDescription="Thermophile Biohack"
     bioNeeded=1
     longDesc="A biohack that adds fire retardance.  Utilizing the genetic code of a mutant strain of hyperthermophile archeo bacteria known as 'Strain 451', this biohack will alter the biochemistry of the user's cells, allowing alternate high-temperature metabolization mechanisms utilizing iron and sulfur oxides.  The biohacked individual can thus withstand extreme temperatures while suffering minimal tissue damage."
     product=Class'DXMod.FireHack'
     components(0)=Class'DXMod.SuitcaseBiolab'
     components(1)=Class'DXMod.LavaMoss'
     SaveComponents(0)=1
     bScrappable=False
}
