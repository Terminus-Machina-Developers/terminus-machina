//-----------------------------------------------------------
//
//-----------------------------------------------------------
class Meat extends Food;

//catmeat
#exec mesh IMPORT MESH=catmeat ANIVFILE=MODELS\catmeat_a.3d DATAFILE=MODELS\catmeat_d.3d X=0 Y=0 Z=0
#exec mesh ORIGIN MESH=catmeat X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=catmeat SEQ=All STARTFRAME=0 NUMFRAMES=30
//#exec mesh SEQUENCE MESH=catmeat SEQ=??? STARTFRAME=0 NUMFRAMES=30

#exec MESHMAP NEW MESHMAP=catmeat MESH=catmeat
#exec MESHMAP scale MESHMAP=catmeat X=0.16 Y=0.16 Z=0.32

#exec texture IMPORT NAME=CatMeatTex FILE=Textures/CatMeat.pcx GROUP=Skins FLAGS=2
#exec MESHMAP SETTEXTURE MESHMAP=catmeat NUM=1 TEXTURE=CatMeatTex
#exec MESHMAP SETTEXTURE MESHMAP=catmeat NUM=2 TEXTURE=CatMeatTex
#exec MESHMAP SETTEXTURE MESHMAP=catmeat NUM=3 TEXTURE=CatMeatTex

#exec texture IMPORT NAME=CatMeat2 FILE=Textures\CatMeat2.pcx GROUP=WEAPONS FLAGS=2

var bool bMasterMeat;

defaultproperties
{
     bMasterMeat=True
     maxCopies=20
     bCanHaveMultipleCopies=True
     bActivatable=True
     ItemName="Cat Meat"
     PlayerViewOffset=(X=30.000000,Z=-12.000000)
     PlayerViewMesh=LodMesh'DXMod.catmeat'
     PickupViewMesh=LodMesh'DXMod.catmeat'
     ThirdPersonMesh=LodMesh'DXMod.catmeat'
     Icon=Texture'DXMod.Weapons.CatMeat2'
     largeIcon=Texture'DXMod.Weapons.CatMeat2'
     largeIconWidth=42
     largeIconHeight=46
     Description="A hunk of meat carved up from a cat carcass."
     beltDescription="MEAT"
     Mesh=LodMesh'DXMod.catmeat'
     CollisionRadius=8.000000
     CollisionHeight=0.980000
     Mass=3.000000
     Buoyancy=4.000000
}
