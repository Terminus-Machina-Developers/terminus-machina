//-----------------------------------------------------------
//
//-----------------------------------------------------------
class ScopeSchem expands Schematic;

defaultproperties
{
     imageTexture=Texture'DXModUI.UI.MagnetronTex'
     imageDescription="Scope Mod"
     mechNeeded=1
     longDesc="A telescopic scope attachment provides zoom capability and increases accuracy against distant targets."
     product=Class'DeusEx.WeaponModScope'
     components(0)=Class'DXMod.BrokenTelescope'
     components(1)=Class'DXMod.CameraLens'
     components(2)=Class'DXMod.ScrapMetal'
}
