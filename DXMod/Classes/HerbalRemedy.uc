//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HerbalRemedy expands MedKit;

#exec obj load file=DXModUI

defaultproperties
{
     ItemName="Herbal Remedy"
     PlayerViewMesh=LodMesh'DXModItems.FlatItem'
     PickupViewMesh=LodMesh'DXModItems.FlatItem'
     ThirdPersonMesh=LodMesh'DXModItems.FlatItem'
     Icon=Texture'DXModUI.UI.SalveIcon'
     largeIcon=Texture'DXModUI.UI.SalveIcon'
     largeIconWidth=50
     largeIconHeight=50
     Description="An herbal remedy concocted from a pestled mix of aloe and comfrey.  Accelerated detoxification properties of Aloe Extremus combined with the cell regenerating nature of comfrey make a potent mix capable of quickly repairing damaged tissues."
     beltDescription="salve"
     Mesh=LodMesh'DXModItems.FlatItem'
     MultiSkins(0)=Texture'DXModUI.UI.SalveIcon'
     MultiSkins(1)=Texture'DXModUI.UI.SalveIcon'
     MultiSkins(2)=Texture'DXModUI.UI.SalveIcon'
     MultiSkins(3)=Texture'DXModUI.UI.SalveIcon'
}
