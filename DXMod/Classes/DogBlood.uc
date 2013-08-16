//-----------------------------------------------------------
//
//-----------------------------------------------------------
class DogBlood expands DeusExPickup;

defaultproperties
{
     maxCopies=10
     bCanHaveMultipleCopies=True
     bActivatable=True
     ItemName="Dog Blood Sample"
     PlayerViewOffset=(X=30.000000,Z=-12.000000)
     PlayerViewMesh=LodMesh'DXModItems.FlatItem'
     PickupViewMesh=LodMesh'DXModItems.FlatItem'
     ThirdPersonMesh=LodMesh'DXModItems.FlatItem'
     Icon=Texture'DXModUI.UI.DogBloodIcon'
     largeIcon=Texture'DXModUI.UI.DogBloodIcon'
     largeIconWidth=42
     largeIconHeight=46
     Description="10 ccs of hemoglobin collected from a canine stored in a Glasstic vial."
     beltDescription="Blood"
     Mesh=LodMesh'DXModItems.FlatItem'
     MultiSkins(0)=Texture'DXModUI.UI.DogBloodIcon'
     MultiSkins(1)=Texture'DXModUI.UI.DogBloodIcon'
     MultiSkins(2)=Texture'DXModUI.UI.DogBloodIcon'
     MultiSkins(3)=Texture'DXModUI.UI.DogBloodIcon'
     CollisionRadius=8.000000
     CollisionHeight=0.980000
     Mass=3.000000
     Buoyancy=4.000000
}
