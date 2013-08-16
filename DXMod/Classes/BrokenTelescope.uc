//-----------------------------------------------------------
//
//-----------------------------------------------------------
class BrokenTelescope expands DeusExPickup;

defaultproperties
{
     maxCopies=20
     bCanHaveMultipleCopies=True
     bActivatable=True
     ItemName="Broken Telescope"
     PlayerViewOffset=(X=24.000000,Z=-6.000000)
     PlayerViewMesh=LodMesh'DeusExItems.Flare'
     PickupViewMesh=LodMesh'DeusExItems.Flare'
     PickupViewScale=4.000000
     ThirdPersonMesh=LodMesh'DeusExItems.Flare'
     Icon=Texture'DXModUI.UI.TelescopeIcon'
     largeIcon=Texture'DXModUI.UI.TelescopeIcon'
     largeIconWidth=150
     largeIconHeight=47
     invSlotsX=3
     Description="A hyperchrome aplanatic 70mm telescope, with magnification up to 4,000x is powerful enough for a hobbyist to discern what brand of footwear Neil Armstrong imprinted the lunar surface with.  Unfortunately, the posterior lens is shattered, so you won't be reaching for the stars any time soon."
     beltDescription="telesc"
     Mesh=LodMesh'DeusExItems.Flare'
     DrawScale=4.000000
     ScaleGlow=5.000000
     MultiSkins(0)=Texture'DXModItems.Skins.TelescopeTex'
     MultiSkins(1)=Texture'DXModItems.Skins.TelescopeTex'
     MultiSkins(2)=Texture'DXModItems.Skins.TelescopeTex'
     MultiSkins(3)=Texture'DXModItems.Skins.TelescopeTex'
     CollisionRadius=40.000000
     CollisionHeight=6.980000
}
