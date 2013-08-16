//-----------------------------------------------------------
//
//-----------------------------------------------------------
class CameraLens expands DeusExPickup;

defaultproperties
{
     maxCopies=20
     bCanHaveMultipleCopies=True
     bActivatable=True
     ItemName="Lens"
     PlayerViewMesh=LodMesh'DXModItems.FlatItem'
     PickupViewMesh=LodMesh'DXModItems.FlatItem'
     ThirdPersonMesh=LodMesh'DXModItems.FlatItem'
     Icon=Texture'DXModUI.UI.LensIcon'
     largeIcon=Texture'DXModUI.UI.LensIcon'
     largeIconWidth=50
     largeIconHeight=50
     Description="A 70mm gauss-style telephoto lens out of a high-end camera.  F5 maximum aperture with flare suppressant and anti-ghosting for maximum clarity."
     beltDescription="lens"
     Mesh=LodMesh'DXModItems.FlatItem'
     DrawScale=2.000000
     ScaleGlow=10.000000
     MultiSkins(0)=Texture'DXModUI.UI.LensIcon'
     MultiSkins(1)=Texture'DXModUI.UI.LensIcon'
     MultiSkins(2)=Texture'DXModUI.UI.LensIcon'
     MultiSkins(3)=Texture'DXModUI.UI.LensIcon'
     CollisionRadius=24.000000
     CollisionHeight=2.000000
}
