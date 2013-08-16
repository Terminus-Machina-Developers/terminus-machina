//-----------------------------------------------------------
//
//-----------------------------------------------------------
class Magnetron extends DeusExPickup;

#exec obj load file=DXModUI
#exec obj load file=DXModitems

defaultproperties
{
     maxCopies=20
     bCanHaveMultipleCopies=True
     bActivatable=True
     ItemName="Magnetron"
     ItemArticle="some"
     PlayerViewMesh=LodMesh'DXModUI.CopWireMesh'
     PickupViewMesh=LodMesh'DXModUI.CopWireMesh'
     ThirdPersonMesh=LodMesh'DXModUI.CopWireMesh'
     Icon=Texture'DXModUI.UI.MagnetronTex'
     largeIcon=Texture'DXModUI.UI.MagnetronTex'
     largeIconWidth=42
     largeIconHeight=46
     Description="A magnetron.  A self-excited microwave oscillator, from a microwave oven.  When powered, microwave radiation emitted can be used for cooking food but can potentially be used to disrupt or destroy electronics."
     beltDescription="magnetron"
     Mesh=LodMesh'DXModUI.SolarMesh'
     MultiSkins(0)=Texture'DXModUI.UI.MagnetronTex'
     MultiSkins(1)=Texture'DXModUI.UI.MagnetronTex'
     MultiSkins(2)=Texture'DXModUI.UI.MagnetronTex'
     MultiSkins(3)=Texture'DXModUI.UI.MagnetronTex'
     CollisionRadius=20.000000
     CollisionHeight=1.980000
}
