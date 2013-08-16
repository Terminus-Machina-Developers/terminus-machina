//-----------------------------------------------------------
//
//-----------------------------------------------------------
class VoltearSchem extends Schematic;

function PostBeginPlay()
{
    longDesc = product.default.Description;
	Super.PostBeginPlay();
}

defaultproperties
{
     imageTexture=Texture'DXMod.UserInterface.SolarCoat'
     imageDescription="Power Sink"
     elecNeeded=1
     longDesc="If you can't steal fire from the gods, steal electricity with this tool.  By using a pure sinusoid DSP inverter and max-power-point regulators, the user can siphon electricity from most electronic devices, energy grid access points, and at higher levels, even short circuiting wires."
     product=Class'DXMod.Voltear'
     components(0)=Class'DeusEx.Multitool'
     components(1)=Class'DXMod.CopperWire'
}
