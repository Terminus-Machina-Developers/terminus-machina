//-----------------------------------------------------------
//
//-----------------------------------------------------------
class LockpickSchem expands Schematic;

defaultproperties
{
     imageTexture=Texture'DXModUI.UI.MagnetronTex'
     imageDescription="Lockpick"
     longDesc="A lockpick for breaking and entering."
     product=Class'DeusEx.Lockpick'
     components(0)=Class'DXMod.Wiper'
     components(1)=Class'DXMod.Screwdriver'
}
