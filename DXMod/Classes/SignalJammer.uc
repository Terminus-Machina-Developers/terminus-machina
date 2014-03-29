//-----------------------------------------------------------
//
//-----------------------------------------------------------
class SignalJammer expands DeusExPickup;

// ----------------------------------------------------------------------
// state Activated
// ----------------------------------------------------------------------

state Activated
{
	function Tick(float deltaTime)
	{
		local DeusExPlayer player;
		Super.Tick(deltaTime);
		player = DeusExPlayer(Owner);

		if (player.Energy > 0)
		{
		    player.Energy -= (1.0 * deltaTime);
		}
	}
	function Activate()
	{
		local DeusExPlayer player;

		Super.Activate();

		player = DeusExPlayer(Owner);
	}

	function BeginState()
	{
		local DeusExPlayer player;
	
		Super.BeginState();

		player = DeusExPlayer(Owner);
	}
Begin:
}

defaultproperties
{
	 RechargeRate = 1.0
     bActivatable=True
     maxCopies=20
     bCanHaveMultipleCopies=True
     ItemName="Signal Jammer"
     PlayerViewOffset=(X=18.000000,Z=-6.000000)
     PlayerViewMesh=LodMesh'DXModItems.IED2Mesh'
     PickupViewMesh=LodMesh'DXModItems.IED2Mesh'
     PickupViewScale=0.500000
     ThirdPersonMesh=LodMesh'DXModItems.IED2Mesh'
     Icon=Texture'DXModUI.UI.IEDIcon'
     largeIcon=Texture'DXModUI.UI.IEDIconLarge'
     largeIconWidth=50
     largeIconHeight=50
     Description="Signal jammer can be used to block any cell-based tracking systems which use your GPS to track and record your location and movements. Can also be used to interfere with enemy network communication."
     beltDescription="Jammer"
     Mesh=LodMesh'DXModItems.IED2Mesh'
     DrawScale=0.500000
     MultiSkins(0)=Texture'DXModItems.Skins.IED2Tex'
     MultiSkins(1)=Texture'DXModItems.Skins.IED2Tex'
     MultiSkins(2)=Texture'DXModItems.Skins.IED2Tex'
     MultiSkins(3)=Texture'DXModItems.Skins.IED2Tex'
     CollisionRadius=20.000000
     CollisionHeight=1.500000
}
