//=============================================================================
// AmmoLaserBattery.
//=============================================================================
class AmmoLaserBattery extends DeusExAmmo;

defaultproperties
{
     bShowInfo=True
     AmmoAmount=1
     MaxAmmo=40
     ItemName="Laser Battery"
     ItemArticle="a"
     PickupViewMesh=LodMesh'DeusExItems.AmmoProd'
     LandSound=Sound'DeusExSounds.Generic.PlasticHit2'
     Icon=Texture'DeusExUI.Icons.BeltIconAmmoProd'
     largeIcon=Texture'DeusExUI.Icons.LargeIconAmmoProd'
     largeIconWidth=17
     largeIconHeight=46
     Description="A portable charging unit for the Wingclipper."
     beltDescription="LASER CHARGER"
     Mesh=LodMesh'DeusExItems.AmmoProd'
     CollisionRadius=2.100000
     CollisionHeight=5.600000
     bCollideActors=True
}
