//-----------------------------------------------------------
//
//-----------------------------------------------------------
class IED expands DeusExPickup;

var bool bCanDetonate;

function Explode()
{
    local LAM lamprox;
    lamprox = Spawn(Class'DeusEx.LAM');
    lamprox.blastRadius=500.000000;
    lamprox.Damage=600.000000;
    lamprox.Explode(lamprox.Location, vect(0,0,1));
    Destroy();
}


function Trigger( actor Other, pawn EventInstigator )
{
    Explode();
}

//
// Toss this item out.
//
function DropFrom(vector StartLocation)
{
    if(DeusExPlayer(Owner) != none)
    {
        DeusExPlayer(Owner).ClientMessage("Use a working cell phone to detonate the IED.");
    }
	if ( !SetLocation(StartLocation) )
		return;
	RespawnTime = 0.0; //don't respawn
	SetPhysics(PHYS_Falling);
	RemoteRole = ROLE_DumbProxy;
	BecomePickup();
	NetPriority = 2.5;
	bCollideWorld = true;
    bCanDetonate = true;


	if ( Pawn(Owner) != None )
		Pawn(Owner).DeleteInventory(self);
	Inventory = None;
	GotoState('PickUp', 'Dropped');
}

auto state Pickup
{
	// changed from Touch to Frob - DEUS_EX CNN
	function Frob(Actor Other, Inventory frobWith)
//	function Touch( actor Other )
	{
		local Inventory Copy;
		if ( ValidTouch(Other) )
		{
			Copy = SpawnCopy(Pawn(Other));
			if (Level.Game.LocalLog != None)
				Level.Game.LocalLog.LogPickup(Self, Pawn(Other));
			if (Level.Game.WorldLog != None)
				Level.Game.WorldLog.LogPickup(Self, Pawn(Other));
//			if (bActivatable && Pawn(Other).SelectedItem==None)
//				Pawn(Other).SelectedItem=Copy;
			if (bActivatable && bAutoActivate && Pawn(Other).bAutoActivate) Copy.Activate();
			if ( PickupMessageClass == None )
				// DEUS_EX CNN - use the itemArticle and itemName
//				Pawn(Other).ClientMessage(PickupMessage, 'Pickup');
				Pawn(Other).ClientMessage(PickupMessage @ itemArticle @ itemName, 'Pickup');
			else
				Pawn(Other).ReceiveLocalizedMessage( PickupMessageClass, 0, None, None, Self.Class );
			PlaySound (PickupSound,,2.0);
			IED(Copy).bCanDetonate = false;
			Pickup(Copy).PickupFunction(Pawn(Other));
		}
	}
}

defaultproperties
{
     maxCopies=20
     bCanHaveMultipleCopies=True
     ItemName="Improvised Explosive Device (IED)"
     PlayerViewOffset=(X=18.000000,Z=-6.000000)
     PlayerViewMesh=LodMesh'DXModItems.IED2Mesh'
     PickupViewMesh=LodMesh'DXModItems.IED2Mesh'
     PickupViewScale=0.500000
     ThirdPersonMesh=LodMesh'DXModItems.IED2Mesh'
     Icon=Texture'DXModUI.UI.IEDIcon'
     largeIcon=Texture'DXModUI.UI.IEDIconLarge'
     largeIconWidth=50
     largeIconHeight=50
     Description="This lo-tek ammonium nitrate bomb is the bane of occupying militaries and police state legbreakers everywhere.  Cooked up from household chemicals and pirated copies of the Anarchist's Cookbook, jerryrigged with a discarded smartphone as a triggering device.  Use a cell phone for remote detonation.  Its exposive yield of 6.3 megajoules will take out humanoid drones and lightly armored mechs.|n|n *Hacktivists are advised to use a jailbroken cell phone for remote detonation, since all major-carrier calls may be monitored for your inconvenience and may result in capture and interrogation by TMT.  (Transcranial Magnetic Torture device)"
     beltDescription="IED"
     Mesh=LodMesh'DXModItems.IED2Mesh'
     DrawScale=0.500000
     MultiSkins(0)=Texture'DXModItems.Skins.IED2Tex'
     MultiSkins(1)=Texture'DXModItems.Skins.IED2Tex'
     MultiSkins(2)=Texture'DXModItems.Skins.IED2Tex'
     MultiSkins(3)=Texture'DXModItems.Skins.IED2Tex'
     CollisionRadius=20.000000
     CollisionHeight=1.500000
}
