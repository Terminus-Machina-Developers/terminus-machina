//-----------------------------------------------------------
//
//-----------------------------------------------------------
class MultitoolSchem expands Schematic;

defaultproperties
{
     imageTexture=Texture'DXModUI.UI.MagnetronTex'
     imageDescription="Multitool"
     elecNeeded=1
     longDesc="A disposable electronics tool. By using electromagnetic resonance detection and frequency modulation to dynamically alter the flow of current through a circuit, skilled agents can use the multitool to manipulate code locks, cameras, autogun turrets, alarms, or other security systems."
     product=Class'DeusEx.Multitool'
     components(0)=Class'DXMod.Screwdriver'
     components(1)=Class'DXMod.PhoneChassis'
     components(2)=Class'DXMod.Ultracapacitor'
     SaveComponents(0)=1
}
