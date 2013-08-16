//-----------------------------------------------------------
//
//-----------------------------------------------------------
class SolarPanel extends DeusExPickup;

#exec obj load file=DXModUI

defaultproperties
{
     maxCopies=20
     bCanHaveMultipleCopies=True
     bActivatable=True
     ItemName="Solar Panels"
     ItemArticle="some"
     PlayerViewMesh=LodMesh'DXModUI.SolarMesh'
     PickupViewMesh=LodMesh'DXModUI.SolarMesh'
     ThirdPersonMesh=LodMesh'DXModUI.SolarMesh'
     Icon=Texture'DXModUI.UI.SolarTex'
     largeIcon=Texture'DXModUI.UI.SolarTex'
     largeIconWidth=42
     largeIconHeight=46
     Description="An array of monocrystaline solar panels"
     beltDescription="solar"
     Mesh=LodMesh'DXModUI.SolarMesh'
     CollisionRadius=20.000000
     CollisionHeight=1.980000
}
