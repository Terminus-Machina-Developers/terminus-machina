//-----------------------------------------------------------
//
//-----------------------------------------------------------
class WilliamGibson expands ModHumanCivilian;


//#exec texture IMPORT NAME=GibsonPhace_2 FILE=Images\GibsonPhace_2.pcx GROUP=UserInterface MIPS=OFF
//#exec texture IMPORT NAME=GibsonPhace_3 FILE=Images\GibsonPhace_3.pcx GROUP=UserInterface MIPS=OFF
//#exec texture IMPORT NAME=GibsonPhace_4 FILE=Images\GibsonPhace_4.pcx GROUP=UserInterface MIPS=OFF

defaultproperties
{
     PhaceTextures(0)=Texture'DXModCharacters.UserInterface.GibsonPhace_1'
     CarcassType=Class'DeusEx.AlexJacobsonCarcass'
     WalkingSpeed=0.296000
     bImportant=True
     bInvincible=True
     walkAnimMult=0.750000
     runAnimMult=0.700000
     GroundSpeed=200.000000
     Alliance=Civillian
     Mesh=LodMesh'DeusExCharacters.GM_DressShirt_S'
     MultiSkins(0)=Texture'DXModCharacters.Skins.WilliamGibsonFace'
     MultiSkins(1)=Texture'DeusExItems.Skins.PinkMaskTex'
     MultiSkins(2)=Texture'DeusExItems.Skins.PinkMaskTex'
     MultiSkins(3)=Texture'DeusExCharacters.Skins.AlexJacobsonTex2'
     MultiSkins(4)=Texture'DeusExCharacters.Skins.AlexJacobsonTex0'
     MultiSkins(5)=Texture'DeusExCharacters.Skins.AlexJacobsonTex1'
     MultiSkins(6)=Texture'DeusExItems.Skins.GrayMaskTex'
     MultiSkins(7)=Texture'DeusExItems.Skins.BlackMaskTex'
     CollisionRadius=20.000000
     CollisionHeight=47.500000
     BindName="WilliamGibson"
     FamiliarName="William Gibson"
     UnfamiliarName="William Gibson"
}
