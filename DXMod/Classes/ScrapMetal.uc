//-----------------------------------------------------------
//
//-----------------------------------------------------------
class ScrapMetal expands DeusExPickup;

defaultproperties
{
     maxCopies=30
     bCanHaveMultipleCopies=True
     bActivatable=True
     ItemName="Scrap metal"
     ItemArticle="some"
     PlayerViewMesh=LodMesh'DXModItems.FlatItem'
     PickupViewMesh=LodMesh'DXModItems.FlatItem'
     ThirdPersonMesh=LodMesh'DXModItems.FlatItem'
     Icon=Texture'DXModUI.UI.MetalIcon'
     largeIcon=Texture'DXModUI.UI.MetalIcon'
     largeIconWidth=50
     largeIconHeight=50
     Description="A dozen loose screws, smartphone fragments, roofing nails, stray smartbomb shrapnel, twisted shards of steel girder, and other fractured bones gathered from the carcass of a metropolis."
     beltDescription="metal"
     Mesh=LodMesh'DXModItems.FlatItem'
     DrawScale=2.000000
     ScaleGlow=5.000000
     MultiSkins(0)=Texture'DXModUI.UI.MetalIcon'
     MultiSkins(1)=Texture'DXModUI.UI.MetalIcon'
     MultiSkins(2)=Texture'DXModUI.UI.MetalIcon'
     MultiSkins(3)=Texture'DXModUI.UI.MetalIcon'
     CollisionRadius=24.000000
     CollisionHeight=2.000000
}
