//-----------------------------------------------------------
//
//-----------------------------------------------------------
class GunpowderSchem expands Schematic;

defaultproperties
{
     imageTexture=Texture'DXModUI.UI.EMPGunIcon'
     imageDescription="Gunpowder"
     longDesc="Handmade low-explosive consisting of KN03 oxidizer and charcoal fuel.  Used as a propellant for projectile weapon ammunition."
     product=Class'DXMod.Gunpowder'
     components(0)=Class'DXMod.Charcoal'
     components(1)=Class'DXMod.Fertilizer'
     bScrappable=False
}
