//-----------------------------------------------------------
//
//-----------------------------------------------------------
class SousveillerSchem expands Schematic;

defaultproperties
{
     imageTexture=Texture'DXModUI.UI.MagnetronTex'
     imageDescription="Sousveiller"
     longDesc="A hi-spec 3D camera.  Used to capture facial recognition profiles for identity masking."
     product=Class'DXMod.Sousveiller'
     components(0)=Class'DXMod.CameraLens'
     components(1)=Class'DXMod.CopperWire'
     components(2)=Class'DXMod.ScrapMetal'
}
