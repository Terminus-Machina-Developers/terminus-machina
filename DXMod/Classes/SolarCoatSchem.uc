//-----------------------------------------------------------
//
//-----------------------------------------------------------
class SolarCoatSchem extends Schematic;

defaultproperties
{
     imageTexture=Texture'DXMod.UserInterface.SolarCoat'
     imageDescription="Solar Coat"
     elecNeeded=1
     longDesc="Monocrystalline photovoltaics are stitched into your coat on the fly to allow constant replenishment of electricity reserves beneath sunlight, or the million-watt glare of a nuclear flash."
     product=Class'DXMod.SolarCoat'
     components(0)=Class'DXMod.SolarPanel'
     components(1)=Class'DXMod.CopperWire'
     components(2)=Class'DXMod.TrenchCoat'
}
