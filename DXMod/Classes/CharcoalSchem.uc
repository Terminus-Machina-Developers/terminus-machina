//-----------------------------------------------------------
//
//-----------------------------------------------------------
class CharcoalSchem expands Schematic;

defaultproperties
{
     imageTexture=Texture'DXModUI.UI.EMPGunIcon'
     imageDescription="Charcoal"
     longDesc="Pyrolized wood consisting of carbon and ash after water and other volatile constituents have been removed.  Produces intense heat when lit."
     product=Class'DXMod.Charcoal'
     components(0)=Class'DXMod.Lighter'
     components(1)=Class'DXMod.WoodPieces'
     SaveComponents(0)=1
     bScrappable=False
}
