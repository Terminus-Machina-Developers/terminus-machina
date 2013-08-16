//-----------------------------------------------------------
//
//-----------------------------------------------------------
class SilverCoat expands ModAugCannister;

#exec OBJ LOAD FILE=DXModUI

defaultproperties
{
     AddAugs(0)=AugSilverCoat
     ItemName="Silver Coat"
     ItemArticle="a"
     PlayerViewMesh=LodMesh'DXModItems.FlatItem'
     PickupViewMesh=LodMesh'DXModItems.FlatItem'
     ThirdPersonMesh=LodMesh'DXModItems.FlatItem'
     Icon=Texture'DXModUI.UI.SilverCoatIcon'
     largeIcon=Texture'DXModUI.UI.SilverCoatIcon'
     largeIconWidth=140
     largeIconHeight=150
     invSlotsX=3
     invSlotsY=3
     Description="This trenchcoat of standard synthcotton fabric metallized with .999 fine silver interferes with the wearer's thermal signature, effectively making them invisible to airborne drones, including the SDX7 Searcher Destroyer.  |n|nWhile aluminum 'tin foil hats' have gathered a patina of infamy in the countercultural community, serious renegades and activists concerned about being on the President's 'drone kill list' looking to evade the all-seeing, all-killing eye of the surveillance state opt for the argent metal as silver is proven to have the highest infrared reflectance over an extended wavelength range of any known material.  'The anti-drone duster', the silver double-breasted coat was even adopted as the standard uniform of the Silver Liberation Army during Austerity uprisings in Greece, Spain, and the UK. |n|n'In the case that the banking cartels inflate your life savings away again, the silver coat is style AND substance; clothing that doubles as currency.' -Rex Kaizer, alternative news pundit."
     beltDescription="S-COAT"
     MultiSkins(0)=Texture'DXModUI.UI.SilverCoatIcon'
     MultiSkins(1)=Texture'DXModUI.UI.SilverCoatIcon'
     MultiSkins(2)=Texture'DXModUI.UI.SilverCoatIcon'
     MultiSkins(3)=Texture'DXModUI.UI.SilverCoatIcon'
     CollisionRadius=10.310000
}
