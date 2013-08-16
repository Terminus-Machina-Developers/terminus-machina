//-----------------------------------------------------------
//
//-----------------------------------------------------------
class AmmoShellSchem expands Schematic;

defaultproperties
{
     imageTexture=Texture'DXModUI.UI.EMPGunIcon'
     imageDescription="Scrapmetal Shotgun Shells"
     longDesc="DIY shotgun shells packed with random metal fragments, fired with gunpowder.  The ammunition of choice of shoestring-budget insurgents everywhere."
     product=Class'DXMod.ModAmmoShell'
     components(0)=Class'DXMod.Gunpowder'
     components(1)=Class'DXMod.ScrapMetal'
     bScrappable=False
}
