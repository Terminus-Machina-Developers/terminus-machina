//-----------------------------------------------------------
//
//-----------------------------------------------------------
class Detonator expands ScrappableItem;

#exec obj load file=DXModUI
#exec obj load file=DXModitems

state Activated
{
	function Activate()
	{
		// can't turn it off
	}

	function BeginState()
	{
		local IED bomb;

		Super.BeginState();
        foreach AllActors(class'IED', bomb)
        {
            if(bomb.bCanDetonate)
                bomb.Explode();
        }
        GotoState('');
	}
Begin:
}

defaultproperties
{
     ScrapList(0)=Class'DXMod.CopperWire'
     ScrapList(1)=Class'DXMod.OldPhone'
     maxCopies=20
     bCanHaveMultipleCopies=True
     bActivatable=True
     ItemName="Cell Phone"
     PlayerViewOffset=(X=18.000000,Z=-6.000000)
     PlayerViewMesh=LodMesh'DXModItems.OldPhone'
     PickupViewMesh=LodMesh'DXModItems.OldPhone'
     PickupViewScale=3.000000
     ThirdPersonMesh=LodMesh'DXModItems.OldPhone'
     Icon=Texture'DXModUI.UI.HexPhoneIcon'
     largeIcon=Texture'DXModUI.UI.HexPhoneIcon'
     largeIconWidth=55
     largeIconHeight=104
     invSlotsY=2
     Description="A working cell phone.  Can be hotwired for use as a remote detonation device for IEDs."
     beltDescription="cell"
     Mesh=LodMesh'DXModItems.OldPhone'
     DrawScale=4.000000
     MultiSkins(0)=Texture'DXModItems.Skins.HexPhoneTex'
     MultiSkins(1)=Texture'DXModItems.Skins.HexPhoneTex'
     MultiSkins(2)=Texture'DXModItems.Skins.HexPhoneTex'
     MultiSkins(3)=Texture'DXModItems.Skins.HexPhoneTex'
     CollisionRadius=20.000000
     CollisionHeight=1.980000
}
