//-----------------------------------------------------------
//
//-----------------------------------------------------------
class BackpackRip expands DeusExPickup;

#exec obj load file=DXModUI
#exec obj load file=DXModItems

defaultproperties
{
     ItemName="Ripped Tote Bag"
     PlayerViewOffset=(X=30.000000,Z=-12.000000)
     PlayerViewMesh=LodMesh'DeusExItems.MedKit'
     PickupViewMesh=LodMesh'DeusExItems.MedKit'
     PickupViewScale=2.000000
     ThirdPersonMesh=LodMesh'DeusExItems.MedKit'
     LandSound=Sound'DeusExSounds.Generic.PlasticHit1'
     Icon=Texture'DXModUI.UI.RipToteIcon'
     largeIcon=Texture'DXModUI.UI.RipToteIcon'
     largeIconWidth=100
     largeIconHeight=50
     invSlotsX=2
     Description="Would make a handy carrying case for your miscellania, if it wasn't ripped up.  |n|nThis tote bag has been disembowled by multiple lacerations and its seams flail in the wind.  Probably a laid off VP marketing rep's trendy briefcase, showed up in D10 and got eaten by the dire wolves of the rest of the mass-unemployed.  The fashion looks like a crossover between post-apoc-chic and haute-couture: sleek-cut leather with military-style black zippers and tactical fastenings.  A stainless steel label reads: 'Armagucci: designer accessories for surviving the zombie apocalypse in style.'"
     beltDescription="PACK"
     Mesh=LodMesh'DeusExItems.MedKit'
     MultiSkins(0)=Texture'DXModItems.Skins.RipToteTex'
     CollisionRadius=10.310000
     CollisionHeight=4.240000
     Mass=10.000000
     Buoyancy=12.000000
}
