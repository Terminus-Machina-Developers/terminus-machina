//-----------------------------------------------------------
//
//-----------------------------------------------------------
class OldCameraSchem expands Schematic;

defaultproperties
{
     imageTexture=Texture'DXModUI.UI.EMPGunIcon'
     imageDescription="Old Camera"
     bioNeeded=1
     longDesc="An old digital camera.  It won't turn on, but the lens is still in good condition."
     product=Class'DXMod.OldCamera'
     components(0)=Class'DXMod.ScrapMetal'
     components(1)=Class'DXMod.CameraLens'
     components(2)=Class'DXMod.HydroBattery'
     bMakeable=False
}
