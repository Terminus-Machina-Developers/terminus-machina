//-----------------------------------------------------------
//
//-----------------------------------------------------------
class Ammo10mmSchem expands Schematic;

defaultproperties
{
     imageTexture=Texture'DXModUI.UI.EMPGunIcon'
     imageDescription="10mm Ammo"
     longDesc="10mm bullets hand-cast and packed with shimmy milled gunpowder.  You just hope your pistol doesn't explode firing the first round."
     product=Class'DeusEx.Ammo10mm'
     components(0)=Class'DXMod.Gunpowder'
     components(1)=Class'DXMod.Slugs10mm'
     bScrappable=False
}
