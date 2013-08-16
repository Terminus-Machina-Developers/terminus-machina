//-----------------------------------------------------------
//
//-----------------------------------------------------------
class SpliceGirl expands ModHumanCivilian;

var WeaponEMPGun tail;
/*
function PostPostBeginPlay()
{
    Super.PostPostBeginPlay();
    tail = Spawn(class'WeaponEMPGun', Self,, Location); //, rot(16384,0,0));
		if (tail != None)
		{
			tail.attachTag = Name;
			tail.SetBase(Self);
			tail.SetPhysics(PHYS_Trailer);
			tail.bTrailerSameRotation=true;
			//tail.LifeSpan = 30;
        }
}  */

defaultproperties
{
     CarcassType=Class'DeusEx.Hooker2Carcass'
     WalkingSpeed=0.320000
     BaseAssHeight=-18.000000
     bIsFemale=True
     GroundSpeed=120.000000
     BaseEyeHeight=38.000000
     Mesh=LodMesh'DeusExCharacters.GFM_Dress'
     MultiSkins(0)=Texture'DXModCharacters.Skins.SpliceTex0'
     MultiSkins(1)=Texture'DXModCharacters.Skins.SpliceTex1'
     MultiSkins(2)=Texture'DeusExCharacters.Skins.Hooker2Tex2'
     MultiSkins(3)=Texture'DXModCharacters.Skins.SpliceTex3'
     MultiSkins(4)=Texture'DeusExItems.Skins.PinkMaskTex'
     MultiSkins(5)=Texture'DeusExItems.Skins.PinkMaskTex'
     MultiSkins(6)=Texture'DeusExItems.Skins.PinkMaskTex'
     MultiSkins(7)=Texture'DXModCharacters.Skins.SpliceTex0'
     CollisionRadius=20.000000
     CollisionHeight=43.000000
     BindName="Genesplice"
     FamiliarName="Jezebel"
     UnfamiliarName="Genesplice Stripper"
}
