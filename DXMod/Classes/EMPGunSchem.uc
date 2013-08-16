//-----------------------------------------------------------
//
//-----------------------------------------------------------
class EMPGunSchem extends Schematic;

defaultproperties
{
     imageTexture=Texture'DXModUI.UI.EMPGunIcon'
     imageDescription="EMP Rifle"
     elecNeeded=1
     longDesc="A DIY EMP rifle.  Emits high-energy microwaves directed by a parabolic reflector capable of disrupting electronics and de-programming computer circuits at low voltages, and causing catastrophic damage at higher settings.  (AKA: HERF gun)"
     product=Class'DXMod.WeaponEMPGun'
     components(0)=Class'DXMod.Magnetron'
     components(1)=Class'DXMod.CopperWire'
     components(2)=Class'DXMod.PlasmonCap'
}
