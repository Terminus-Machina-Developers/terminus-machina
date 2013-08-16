//-----------------------------------------------------------
//
//-----------------------------------------------------------
class AmmoDartSchem expands Schematic;

defaultproperties
{
     imageTexture=Texture'DXModUI.UI.EMPGunIcon'
     imageDescription="Nail Darts (Ammo)"
     longDesc="Shafts made of wooden cylinders tipped with casing nails, these bolts can be fired from a mini-crossbow as well as store-bought bolts, but at 1/100th the price and are made with 100% reused garbage.  Killing people doesn't have to kill the environment, too."
     product=Class'DeusEx.AmmoDart'
     components(0)=Class'DXMod.WoodPieces'
     components(1)=Class'DXMod.Nails'
     numProduct(0)=2
     numProduct(1)=2
     numProduct(2)=2
     numProduct(3)=2
     GoverningSkill=Class'DeusEx.SkillWeaponHeavy'
     bScrappable=False
}
