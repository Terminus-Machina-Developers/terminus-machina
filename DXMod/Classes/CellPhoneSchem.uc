//-----------------------------------------------------------
//
//-----------------------------------------------------------
class CellPhoneSchem expands Schematic;

defaultproperties
{
     imageTexture=Texture'DXModUI.UI.MagnetronTex'
     imageDescription="Cell Phone"
     longDesc="A working cell phone.  Can be hotwired for use as a remote detonation device for IEDs."
     product=Class'DXMod.Detonator'
     components(0)=Class'DXMod.OldPhone'
     components(1)=Class'DXMod.CopperWire'
}
