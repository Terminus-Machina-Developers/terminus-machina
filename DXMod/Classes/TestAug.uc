//-----------------------------------------------------------
//
//-----------------------------------------------------------
class TestAug extends ModAugCannister;

#exec obj load file=DXModUI

defaultproperties
{
     PlayerViewMesh=LodMesh'DXModUI.SolarMesh'
     PickupViewMesh=LodMesh'DXModUI.SolarMesh'
     ThirdPersonMesh=LodMesh'DXModUI.SolarMesh'
     Icon=Texture'DXModUI.UI.SolarTex'
     largeIcon=Texture'DXModUI.UI.SolarTex'
     largeIconWidth=42
     largeIconHeight=46
     beltDescription="solar"
     Mesh=None
}
