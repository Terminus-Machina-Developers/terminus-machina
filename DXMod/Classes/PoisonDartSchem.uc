//-----------------------------------------------------------
//
//-----------------------------------------------------------
class PoisonDartSchem expands Schematic;

defaultproperties
{
     imageTexture=Texture'DXModUI.UI.MagnetronTex'
     imageDescription="Tranquilizer Darts (Ammo)"
     natureNeeded=1
     longDesc="A mini-crossbow dart tipped with hemlock-based pyridine alkaloids that causes complete skeletal muscle relaxation, effectively incapacitating a target in a non-lethal manner."
     product=Class'DeusEx.AmmoDartPoison'
     components(0)=Class'DXMod.PoisonPlant'
     components(1)=Class'DXMod.WoodPieces'
     components(2)=Class'DXMod.Nails'
     numProduct(0)=2
     numProduct(1)=2
     numProduct(2)=2
     numProduct(3)=2
     GoverningSkill=Class'DeusEx.SkillWeaponHeavy'
}
