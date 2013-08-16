//-----------------------------------------------------------
//
//-----------------------------------------------------------
class Detergent expands DeusExPickup;

defaultproperties
{
     maxCopies=20
     NumCopies=2
     bCanHaveMultipleCopies=True
     bActivatable=True
     ItemName="Laundry Detergent"
     ItemArticle="some"
     PlayerViewOffset=(X=24.000000,Z=-6.000000)
     PlayerViewMesh=LodMesh'DeusExItems.Liquor40oz'
     PickupViewMesh=LodMesh'DeusExItems.Liquor40oz'
     ThirdPersonMesh=LodMesh'DeusExItems.Liquor40oz'
     Icon=Texture'DXModUI.UI.DetergentIcon'
     largeIcon=Texture'DXModUI.UI.DetergentIcon'
     largeIconWidth=42
     largeIconHeight=52
     Description="A container of liquid laundry detergent."
     beltDescription="detergent"
     Mesh=LodMesh'DeusExItems.Liquor40oz'
     DrawScale=2.000000
     MultiSkins(0)=Texture'DXModItems.Skins.DetergentTex'
     MultiSkins(1)=Texture'DXModItems.Skins.DetergentTex'
     MultiSkins(2)=Texture'DXModItems.Skins.DetergentTex'
     MultiSkins(3)=Texture'DXModItems.Skins.DetergentTex'
     CollisionRadius=20.000000
     CollisionHeight=10.980000
}
