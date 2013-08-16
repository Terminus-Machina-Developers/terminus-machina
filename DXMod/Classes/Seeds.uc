//-----------------------------------------------------------
//
//-----------------------------------------------------------
class Seeds extends DeusExPickup;

#exec mesh IMPORT MESH=Seeds ANIVFILE=Models\Seeds_a.3d DATAFILE=MODELS\Seeds_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=Seeds X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=Seeds SEQ=All STARTFRAME=0 NUMFRAMES=30
//#exec MESH SEQUENCE MESH=Seeds SEQ=??? STARTFRAME=0 NUMFRAMES=30

#exec MESHMAP NEW MESHMAP=Seeds MESH=Seeds
#exec MESHMAP scale MESHMAP=Seeds X=0.5 Y=0.5 Z=1

#exec texture IMPORT NAME=SeedsTex FILE=Textures\SeedsTex.pcx GROUP=Skins //FLAGS=2
//#exec texture IMPORT NAME=SeedsTex1 FILE=SeedsTex.pcx GROUP=Skins PALETTE=Jtex1
#exec MESHMAP SETTEXTURE MESHMAP=Seeds NUM=1 TEXTURE=SeedsTex



/*
state Activated
{
	function Activate()
	{
		// can't turn it off
	}

	function BeginState()
	{
		local DeusExPlayer player;

		Super.BeginState();

		player = DeusExPlayer(Owner);
		if (player != None)
			player.HealPlayer(5, False);

		UseOnce();
	}
Begin:
}   */

defaultproperties
{
     maxCopies=10
     bCanHaveMultipleCopies=True
     bActivatable=True
     ItemName="Seeds"
     ItemArticle="some"
     PlayerViewOffset=(X=30.000000,Z=-12.000000)
     PlayerViewMesh=LodMesh'DXMod.Seeds'
     PickupViewMesh=LodMesh'DXMod.Seeds'
     ThirdPersonMesh=LodMesh'DXMod.Seeds'
     Icon=Texture'DXModUI.UI.SeedsIcon'
     largeIcon=Texture'DXModUI.UI.SeedsIcon'
     largeIconWidth=42
     largeIconHeight=46
     Description="A label is scrawled in permanent marker: choi sum cabbage, generipped strain CI-7.  Resistant to genetically modified superlocusts."
     beltDescription="Seeds"
     Mesh=LodMesh'DXMod.Seeds'
     CollisionRadius=8.000000
     CollisionHeight=0.980000
     Mass=3.000000
     Buoyancy=4.000000
}
