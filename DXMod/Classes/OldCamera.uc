//-----------------------------------------------------------
//
//-----------------------------------------------------------
class OldCamera expands DeusExPickup;

defaultproperties
{
     maxCopies=20
     bCanHaveMultipleCopies=True
     bActivatable=True
     ItemName="Old Camera"
     ItemArticle="an"
     PlayerViewMesh=LodMesh'DeusExItems.Cigarettes'
     PickupViewMesh=LodMesh'DeusExItems.Cigarettes'
     PickupViewScale=2.000000
     ThirdPersonMesh=LodMesh'DeusExItems.Cigarettes'
     Icon=Texture'DXModUI.UI.CameraIcon'
     largeIcon=Texture'DXModUI.UI.CameraIcon'
     largeIconWidth=50
     largeIconHeight=50
     Description="An old digital camera.  It won't turn on, but the lens is still in good condition."
     beltDescription="cam"
     Mesh=LodMesh'DeusExItems.Cigarettes'
     DrawScale=2.000000
     ScaleGlow=5.000000
     MultiSkins(0)=Texture'DXModItems.Skins.CameraTex'
     MultiSkins(1)=Texture'DXModItems.Skins.CameraTex'
     MultiSkins(2)=Texture'DXModItems.Skins.CameraTex'
     MultiSkins(3)=Texture'DXModItems.Skins.CameraTex'
     CollisionRadius=15.000000
     CollisionHeight=4.000000
}
