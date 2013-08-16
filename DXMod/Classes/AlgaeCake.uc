//-----------------------------------------------------------
//
//-----------------------------------------------------------
class AlgaeCake extends Food;

//catmeat
#exec mesh IMPORT MESH=ALgaeCake ANIVFILE=MODELS\ALgaeCake_a.3d DATAFILE=MODELS\ALgaeCake_d.3d X=0 Y=0 Z=0
#exec mesh ORIGIN MESH=ALgaeCake X=0 Y=0 Z=0

#exec mesh SEQUENCE MESH=ALgaeCake SEQ=All STARTFRAME=0 NUMFRAMES=30

#exec MESHMAP new MESHMAP=ALgaeCake MESH=ALgaeCake
#exec MESHMAP scale MESHMAP=ALgaeCake X=0.1 Y=0.1 Z=0.2

#exec texture IMPORT NAME=AlgaeTex FILE=Textures\AlgaeTex.pcx GROUP=Skins PALETTE=AlgaeTex
#exec MESHMAP SETTEXTURE MESHMAP=ALgaeCake NUM=1 TEXTURE=AlgaeTex
#exec MESHMAP SETTEXTURE MESHMAP=ALgaeCake NUM=2 TEXTURE=AlgaeTex
#exec MESHMAP SETTEXTURE MESHMAP=ALgaeCake NUM=3 TEXTURE=AlgaeTex
#exec MESHMAP SETTEXTURE MESHMAP=ALgaeCake NUM=4 TEXTURE=AlgaeTex
#exec MESHMAP SETTEXTURE MESHMAP=ALgaeCake NUM=5 TEXTURE=AlgaeTex
#exec MESHMAP SETTEXTURE MESHMAP=ALgaeCake NUM=6 TEXTURE=AlgaeTex
#exec MESHMAP SETTEXTURE MESHMAP=ALgaeCake NUM=7 TEXTURE=AlgaeTex

#exec texture IMPORT NAME=AlgaeCake FILE=Textures\AlgaeCake.pcx GROUP=WEAPONS FLAGS=2

defaultproperties
{
     maxCopies=10
     bCanHaveMultipleCopies=True
     bActivatable=True
     ItemName="Algae Cake"
     PlayerViewOffset=(X=30.000000,Z=-12.000000)
     PlayerViewMesh=LodMesh'DXMod.AlgaeCake'
     PickupViewMesh=LodMesh'DXMod.AlgaeCake'
     ThirdPersonMesh=LodMesh'DXMod.AlgaeCake'
     Icon=Texture'DXMod.Weapons.AlgaeCake'
     largeIcon=Texture'DXMod.Weapons.AlgaeCake'
     largeIconWidth=42
     largeIconHeight=46
     Description="A piece of algae cake."
     beltDescription="Algae Cake"
     Mesh=LodMesh'DXMod.catmeat'
     CollisionRadius=8.000000
     CollisionHeight=0.980000
     Mass=3.000000
     Buoyancy=4.000000
}
