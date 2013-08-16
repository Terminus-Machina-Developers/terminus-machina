//-----------------------------------------------------------
//
//-----------------------------------------------------------
class PhoneChassis expands DeusExPickup;

#exec obj load file=DXModUI
#exec obj load file=DXModitems

defaultproperties
{
     maxCopies=20
     bCanHaveMultipleCopies=True
     bActivatable=True
     ItemName="Smartphone Chassis"
     PlayerViewOffset=(X=18.000000,Z=-6.000000)
     PlayerViewMesh=LodMesh'DXModItems.OldPhone'
     PickupViewMesh=LodMesh'DXModItems.OldPhone'
     PickupViewScale=3.000000
     ThirdPersonMesh=LodMesh'DXModItems.OldPhone'
     Icon=Texture'DXModUI.UI.PhoneChassisIcon'
     largeIcon=Texture'DXModUI.UI.PhoneChassisIcon'
     largeIconWidth=55
     largeIconHeight=104
     invSlotsY=2
     Description="The empty petroplastic casing of a cell phone."
     beltDescription="chassis"
     Mesh=LodMesh'DXModItems.OldPhone'
     DrawScale=4.000000
     MultiSkins(0)=Texture'DXModUI.UI.PhoneChassisIcon'
     MultiSkins(1)=Texture'DXModUI.UI.PhoneChassisIcon'
     MultiSkins(2)=Texture'DXModUI.UI.PhoneChassisIcon'
     MultiSkins(3)=Texture'DXModUI.UI.PhoneChassisIcon'
     CollisionRadius=20.000000
     CollisionHeight=1.980000
}
