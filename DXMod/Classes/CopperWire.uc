//-----------------------------------------------------------
//
//-----------------------------------------------------------
class CopperWire extends DeusExPickup;

#exec obj load file=DXModUI

defaultproperties
{
     maxCopies=20
     bCanHaveMultipleCopies=True
     bActivatable=True
     ItemName="Copper Wire"
     ItemArticle="some"
     PlayerViewMesh=LodMesh'DXModUI.CopWireMesh'
     PickupViewMesh=LodMesh'DXModUI.CopWireMesh'
     ThirdPersonMesh=LodMesh'DXModUI.CopWireMesh'
     Icon=Texture'DXModUI.UI.IconWire'
     largeIcon=Texture'DXModUI.UI.IconWire'
     largeIconWidth=42
     largeIconHeight=46
     Description="A bunch of stripped copper wire.  High ductility and electrical/thermal conductivity make this metal a vital commodity for electrical devices."
     beltDescription="wire"
     Mesh=LodMesh'DXModUI.CopWireMesh'
     CollisionRadius=12.000000
     CollisionHeight=1.980000
}
