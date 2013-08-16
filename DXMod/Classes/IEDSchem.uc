//-----------------------------------------------------------
//
//-----------------------------------------------------------
class IEDSchem expands Schematic;

defaultproperties
{
     imageTexture=Texture'DXMod.UserInterface.SolarCoat'
     imageDescription="Improvised Explosive Device"
     iedNeeded=1
     longDesc="This lo-tek ammonium nitrate bomb is the bane of roadside police state legbreakers everywhere.  Cooked up from household chemicals and pirated copies of the Anarchist's Cookbook, jerryrigged with a discarded smartphone for use as a remote detonator."
     product=Class'DXMod.IED'
     components(0)=Class'DXMod.Detergent'
     components(1)=Class'DXMod.Fertilizer'
     components(2)=Class'DXMod.OldPhone'
     ExtraSpawn(0)=Class'DXMod.CopperWire'
     numProduct(3)=2
     GoverningSkill=Class'DeusEx.SkillDemolition'
     bScrappable=False
}
