//-----------------------------------------------------------
//
//-----------------------------------------------------------
class Veggie extends DeusExPickup;
  /*
#exec MESH IMPORT MESH=carrot ANIVFILE=MODELS\carrot_a.3d DATAFILE=MODELS\carrot_d.3d X=0 Y=0 Z=0
#exec mesh ORIGIN MESH=carrot X=0 Y=0 Z=0

#exec mesh SEQUENCE MESH=carrot SEQ=All STARTFRAME=0 NUMFRAMES=30
#exec mesh SEQUENCE MESH=carrot SEQ=??? STARTFRAME=0 NUMFRAMES=30

#exec MESHMAP new MESHMAP=carrot MESH=carrot
#exec MESHMAP scale MESHMAP=carrot X=0.1 Y=0.1 Z=0.2

#exec texture IMPORT NAME=carrottex FILE=Textures\carrottex.pcx GROUP=Skins FLAGS=2
#exec texture IMPORT NAME=carrottex FILE=Textures\carrottex.pcx GROUP=Skins PALETTE=carrottex
#exec MESHMAP SETTEXTURE MESHMAP=carrot NUM=1 TEXTURE=carrottex
                           */

defaultproperties
{
     maxCopies=10
     bCanHaveMultipleCopies=True
     bActivatable=True
     ItemName="Carrot"
     PlayerViewOffset=(X=30.000000,Z=-12.000000)
     Icon=Texture'DeusExUI.Icons.BeltIconSoyFood'
     largeIcon=Texture'DeusExUI.Icons.LargeIconSoyFood'
     largeIconWidth=42
     largeIconHeight=46
     Description="A label is scrawled in permanent marker: choi sum cabbage, resistant to genetically modified superlocusts"
     beltDescription="carrot"
     CollisionRadius=8.000000
     CollisionHeight=0.980000
     Mass=3.000000
     Buoyancy=4.000000
}
