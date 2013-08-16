//-----------------------------------------------------------
//
//-----------------------------------------------------------
class ModMaleCarcass extends DeusExCarcass;

// ----------------------------------------------------------------------
// PostPostBeginPlay()
// ----------------------------------------------------------------------
/*
function PostPostBeginPlay()
{
	local DeusExPlayer player;

	Super.PostPostBeginPlay();

	foreach AllActors(class'DeusExPlayer', player)
		break;

	SetSkin(player);
}

// ----------------------------------------------------------------------
// SetSkin()
// ----------------------------------------------------------------------

function SetSkin(DeusExPlayer player)
{
	if (player != None)
	{
		switch(player.PlayerSkin)
		{
			case 0:	MultiSkins[0] = Texture'JCDentonTex0'; break;
			case 1:	MultiSkins[0] = Texture'JCDentonTex4'; break;
			case 2:	MultiSkins[0] = Texture'JCDentonTex5'; break;
			case 3:	MultiSkins[0] = Texture'JCDentonTex6'; break;
			case 4:	MultiSkins[0] = Texture'JCDentonTex7'; break;
		}
	}
}       */

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     Mesh2=LodMesh'DeusExCharacters.GM_Trench_CarcassB'
     Mesh3=LodMesh'DeusExCharacters.GM_Trench_CarcassC'
     Mesh=LodMesh'DeusExCharacters.GM_Trench_Carcass'
     MultiSkins(0)=Texture'DXModCharacters.Skins.TMFaceTex'
     MultiSkins(1)=Texture'DXModCharacters.Skins.TMTex2'
     MultiSkins(2)=Texture'DXModCharacters.Skins.TMTex3'
     MultiSkins(3)=Texture'DXModCharacters.Skins.TMFaceTex'
     MultiSkins(4)=Texture'DXModCharacters.Skins.TMTex1'
     MultiSkins(5)=Texture'DXModCharacters.Skins.TMTex2'
     MultiSkins(6)=Texture'DeusExItems.Skins.GrayMaskTex'
     MultiSkins(7)=Texture'DeusExItems.Skins.BlackMaskTex'
     CollisionRadius=40.000000
}
