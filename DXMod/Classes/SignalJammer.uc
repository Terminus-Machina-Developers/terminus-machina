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
		local float ConsumptionRate;
		local DeusExPlayer player;
		local PlayerPawn PP;
		Super.Tick(deltaTime);
		ConsumptionRate = 1.0; //60% bioelectric consumed per minute
		player = DeusExPlayer(Owner);
		PP = GetPlayerPawn();

		if (player.Energy > 0)
		{
			ModMale(PP).bNoDroneStrike = true;
		    player.Energy -= (ConsumptionRate * deltaTime);
		} else 
		{
			PP.ClientMessage("Energy Depleted: jammer shutdown");
			GotoState('DeActivated');
		}
	}
	function Activate()
	{
		local DeusExPlayer player;
		//if (player.Energy <= 0)
		//{
		//	GotoState('DeActivated');
		//}
		Super.Activate();

		player = DeusExPlayer(Owner);
	}

	function BeginState()
	{
		local DeusExPlayer player;
		//if (player.Energy <= 0)
		//{
		//	GotoState('DeActivated');
		//}
		Super.BeginState();

		player = DeusExPlayer(Owner);
	}
Begin:
}

// ----------------------------------------------------------------------
// state DeActivated
// ----------------------------------------------------------------------

state DeActivated
{
	function BeginState()
	{
		local DeusExPlayer player;
		local PlayerPawn PP;
		
		Super.BeginState();

		player = DeusExPlayer(Owner);
		PP = GetPlayerPawn();
		ModMale(PP).bNoDroneStrike = false;
	}
}

defaultproperties
{
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
