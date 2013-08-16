//-----------------------------------------------------------
//
//-----------------------------------------------------------
class PlasmonCap expands DeusExPickup;

defaultproperties
{
     maxCopies=20
     bCanHaveMultipleCopies=True
     bActivatable=True
     ItemName="Plasmonic Capacitor"
     ItemArticle="an"
     PlayerViewOffset=(X=24.000000,Z=-6.000000)
     PlayerViewMesh=LodMesh'DeusExItems.Flare'
     PickupViewMesh=LodMesh'DeusExItems.Flare'
     PickupViewScale=3.000000
     ThirdPersonMesh=LodMesh'DeusExItems.Flare'
     Icon=Texture'DXModUI.UI.PlasmonCapIcon'
     largeIcon=Texture'DXModUI.UI.PlasmonCapIcon'
     largeIconWidth=50
     largeIconHeight=50
     Description="The plasmonic capacitor consists of octahedronic 3D-graphene latticed with quantum wires, all sealed within an exotic vaccuum.  These capacitors utilize subwavelength properties of metamaterials to provide charge capacities and discharge rates a hundred times that of ultracapacitors of comparable size.  |n|nCan be used in EMP weapons."
     beltDescription="plasmon"
     Mesh=LodMesh'DeusExItems.Flare'
     DrawScale=3.000000
     ScaleGlow=5.000000
     MultiSkins(0)=Texture'DXModItems.Skins.PlasmonCapTex'
     MultiSkins(1)=Texture'DXModItems.Skins.PlasmonCapTex'
     MultiSkins(2)=Texture'DXModItems.Skins.PlasmonCapTex'
     MultiSkins(3)=Texture'DXModItems.Skins.PlasmonCapTex'
     CollisionRadius=20.000000
     CollisionHeight=3.980000
}
