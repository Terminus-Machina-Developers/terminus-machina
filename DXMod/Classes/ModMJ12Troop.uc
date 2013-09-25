//-----------------------------------------------------------
//
//-----------------------------------------------------------
class ModMJ12Troop extends ModHumanMilitary;

#exec texture IMPORT NAME=TyrTex1 FILE=Textures\TyrTex2.pcx GROUP=Skins
#exec texture IMPORT NAME=TyrPhace_1 FILE=Images\TyrPhace.pcx GROUP=UserInterface MIPS=OFF
#exec OBJ LOAD FILE=DXModItems

// ----------------------------------------------------------------------
// SpurtBlood()
// ----------------------------------------------------------------------

function SpurtBlood()
{
	local vector bloodVector;
	local BloodDrop bd;

	bloodVector = vect(0,0,1)*CollisionHeight*0.5;  // so folks don't bleed from the crotch
	bd = spawn(Class'OilDrop',,,bloodVector+Location);

}

defaultproperties
{
	 PhaceTextures(0)=Texture'DXMod.UserInterface.TyrPhace_1'
     bElectronic=True
     CarcassType=Class'DXMod.ModMJ12Carcass'
     WalkingSpeed=0.296000
     InitialInventory(0)=(Inventory=Class'DeusEx.WeaponAssaultGun')
     InitialInventory(1)=(Inventory=Class'DeusEx.Ammo762mm',Count=12)
     InitialInventory(2)=(Inventory=Class'DeusEx.WeaponCombatKnife')
     walkAnimMult=0.780000
     GroundSpeed=200.000000
     HitSound1=Sound'DXModSounds.Misc.DroidPain1'
     HitSound2=Sound'DXModSounds.Misc.DroidPain2'
     Die=Sound'DXModSounds.Misc.SysFailDroid'
     Texture=Texture'DeusExItems.Skins.PinkMaskTex'
     Mesh=LodMesh'DeusExCharacters.GM_Jumpsuit'
     MultiSkins(0)=Texture'DXMod.Skins.TyrTex1'
     MultiSkins(1)=Texture'DeusExCharacters.Skins.MJ12TroopTex1'
     MultiSkins(2)=Texture'DeusExCharacters.Skins.MJ12TroopTex2'
     MultiSkins(3)=Texture'DXMod.Skins.TyrTex1'
     MultiSkins(4)=Texture'DeusExItems.Skins.PinkMaskTex'
     MultiSkins(5)=Texture'DeusExItems.Skins.PinkMaskTex'
     MultiSkins(6)=Texture'DeusExItems.Skins.PinkMaskTex'
     MultiSkins(7)=Texture'DeusExItems.Skins.PinkMaskTex'
     CollisionRadius=20.000000
     CollisionHeight=47.500000
     BindName="TyrX2"
     FamiliarName="Counter-Insurgency Robosoldier"
     UnfamiliarName="Counter-Insurgency Robosoldier"
}
