//-----------------------------------------------------------
//
//-----------------------------------------------------------
class RemedySchem expands Schematic;

defaultproperties
{
     imageTexture=Texture'DXModUI.UI.MagnetronTex'
     imageDescription="Herbal Remedy"
     natureNeeded=1
     longDesc="An herbal remedy concocted from a pestled mix of aloe and comfrey.  Accelerated detoxification properties of Aloe Extremus combined with the cell regenerating nature of comfrey make a potent mix capable of quickly repairing damaged tissues."
     product=Class'DXMod.HerbalRemedy'
     components(0)=Class'DXMod.AloePlant'
     components(1)=Class'DXMod.ComfreyPlant'
}
