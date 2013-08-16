//-----------------------------------------------------------
//
//-----------------------------------------------------------
class Slugs10mmSchem expands Schematic;

defaultproperties
{
     imageTexture=Texture'DXModUI.UI.EMPGunIcon'
     imageDescription="10mm Slugs"
     longDesc="A handful of 10 millimeter bullet slugs.  Handcast from a mashup of upcycled soft metals, the bullets are not major factory grade nor are they legal since the repealment of the 2nd Ammendment, but they could potentially be used as ammunition if fitted with a proper charge."
     product=Class'DXMod.Slugs10mm'
     components(0)=Class'DXMod.Lighter'
     components(1)=Class'DXMod.ScrapMetal'
     SaveComponents(0)=1
     bScrappable=False
}
