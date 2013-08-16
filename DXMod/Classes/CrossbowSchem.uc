//-----------------------------------------------------------
//
//-----------------------------------------------------------
class CrossbowSchem expands Schematic;

#exec OBJ LOAD FILE=DXModWeapons

defaultproperties
{
     imageTexture=Texture'DXModUI.UI.EMPGunIcon'
     imageDescription="Mini Crossbow"
     mechNeeded=1
     longDesc="A minicrossbow with body consisting of old hardwood, strung with fullerene-laced nylon and machining patched together from metal scrap.  Quiet and versatile, this crossbow can fire a variety of shafted objects."
     product=Class'DXMod.ModWeaponMiniCrossbow'
     components(0)=Class'DXMod.WoodPieces'
     components(1)=Class'DXMod.ScrapMetal'
     components(2)=Class'DXMod.NylonString'
}
