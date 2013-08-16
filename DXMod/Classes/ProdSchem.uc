//-----------------------------------------------------------
//
//-----------------------------------------------------------
class ProdSchem expands Schematic;

defaultproperties
{
     imageTexture=Texture'DXModUI.UI.MagnetronTex'
     imageDescription="Electric Prod"
     mechNeeded=1
     longDesc="This home-cooked electric prod can be used to temporarily stun biological enemies through disruption of action potentials within the nervous system."
     product=Class'DXMod.ModWeaponProd'
     components(0)=Class'DXMod.HydroBattery'
     components(1)=Class'DXMod.CopperWire'
     components(2)=Class'DXMod.Ultracapacitor'
}
