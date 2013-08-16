//-----------------------------------------------------------
//
//-----------------------------------------------------------
class Wiper expands DeusExPickup;

defaultproperties
{
     maxCopies=20
     bCanHaveMultipleCopies=True
     bActivatable=True
     ItemName="Windshield Wipers"
     ItemArticle="some"
     PlayerViewMesh=LodMesh'DXModItems.FlatItem'
     PickupViewMesh=LodMesh'DXModItems.FlatItem'
     ThirdPersonMesh=LodMesh'DXModItems.FlatItem'
     Icon=Texture'DXModUI.UI.WiperIconSmall'
     largeIcon=Texture'DXModUI.UI.WiperIcon'
     largeIconWidth=96
     largeIconHeight=46
     invSlotsX=2
     Description="Windshield wipers stripped from a car.  They look like they've seen their days but the metal's still good.."
     beltDescription="wiper"
     Mesh=LodMesh'DXModItems.FlatItem'
     DrawScale=3.000000
     ScaleGlow=4.000000
     MultiSkins(0)=Texture'DXModUI.UI.WiperIcon'
     MultiSkins(1)=Texture'DXModUI.UI.WiperIcon'
     MultiSkins(2)=Texture'DXModUI.UI.WiperIcon'
     MultiSkins(3)=Texture'DXModUI.UI.WiperIcon'
     CollisionRadius=24.000000
     CollisionHeight=4.000000
}
