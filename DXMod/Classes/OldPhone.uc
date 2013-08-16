//-----------------------------------------------------------
//
//-----------------------------------------------------------
class OldPhone extends ScrappableItem;

#exec obj load file=DXModUI2
#exec obj load file=DXModitems

defaultproperties
{
     ScrapList(0)=Class'DXMod.CopperWire'
     ScrapList(1)=Class'DXMod.CopperWire'
     ScrapList(2)=Class'DXMod.Ultracapacitor'
     ScrapList(3)=Class'DXMod.PhoneChassis'
     maxCopies=20
     bCanHaveMultipleCopies=True
     bActivatable=True
     ItemName="Broken Smartphone"
     PlayerViewOffset=(X=18.000000,Z=-6.000000)
     PlayerViewMesh=LodMesh'DXModItems.OldPhone'
     PickupViewMesh=LodMesh'DXModItems.OldPhone'
     PickupViewScale=3.000000
     ThirdPersonMesh=LodMesh'DXModItems.OldPhone'
     Icon=Texture'DXModUI2.UI.OldPhoneIcon'
     largeIcon=Texture'DXModUI2.UI.OldPhoneIcon'
     largeIconWidth=60
     largeIconHeight=97
     invSlotsY=2
     Description="A last-gen, bricked smartphone.  It's marketing has been erased by a million random scratches and traumas."
     beltDescription="smartphone"
     Mesh=LodMesh'DXModItems.OldPhone'
     DrawScale=4.000000
     ScaleGlow=5.000000
     CollisionRadius=20.000000
     CollisionHeight=1.980000
}
