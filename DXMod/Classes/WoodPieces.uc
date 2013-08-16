//-----------------------------------------------------------
//
//-----------------------------------------------------------
class WoodPieces expands DeusExPickup;

#exec obj load file=DXModitems

defaultproperties
{
     maxCopies=30
     bCanHaveMultipleCopies=True
     bActivatable=True
     ItemName="Wood Shafts"
     ItemArticle="some"
     PlayerViewMesh=LodMesh'DXModItems.FlatItem'
     PickupViewMesh=LodMesh'DXModItems.FlatItem'
     ThirdPersonMesh=LodMesh'DXModItems.FlatItem'
     Icon=Texture'DXModUI.UI.WoodIcon'
     largeIcon=Texture'DXModUI.UI.WoodIcon'
     largeIconWidth=50
     largeIconHeight=50
     Description="Lengths of broken hardwood, probably from discarded furniture.  Most of the pieces are approximately cylindrical."
     beltDescription="wood"
     Mesh=LodMesh'DXModItems.FlatItem'
     DrawScale=2.000000
     MultiSkins(0)=Texture'DXModUI.UI.WoodIcon'
     MultiSkins(1)=Texture'DXModUI.UI.WoodIcon'
     MultiSkins(2)=Texture'DXModUI.UI.WoodIcon'
     MultiSkins(3)=Texture'DXModUI.UI.WoodIcon'
     CollisionRadius=24.000000
     CollisionHeight=2.000000
}
