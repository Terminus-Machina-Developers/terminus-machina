//-----------------------------------------------------------
//
//-----------------------------------------------------------
class ModConPlay extends ConPlay;

// ----------------------------------------------------------------------
// SetupEventCheckObject()
//
// Checks to see if the player has the given object.  If so, then we'll
// just fall through and continue running code.  Otherwise we'll jump
// to the supplied label.
// ----------------------------------------------------------------------

function EEventAction SetupEventCheckObject( ConEventCheckObject event, out String nextLabel )
{
	local EEventAction nextAction;
	local Name keyName;
	local bool bHasObject;
 	local Inventory Inv;
    local class<Actor> aClass;
    local Actor A;

	// Okay this is some HackyHack stuff here.  We want the ability to
	// check if the player has a particular nanokey.  Sooooooo.

	if ((event.checkObject == None) && (Left(event.objectName, 3) == "NK_"))
	{
		// Look for key
		keyName    = player.rootWindow.StringToName(Right(event.ObjectName, Len(event.ObjectName) - 3));
		bHasObject = ((player.KeyRing != None) && (player.KeyRing.HasKey(keyName)));
	}
	else
	{
	    aClass = class<Actor>(DynamicLoadObject(event.ObjectName, class'Class'));
        //A = Spawn(aClass);
	    //player.ClientMessage("CheckObject = " $ aClass);
        /*
        bHasObject = false;
    	for( Inv=Inventory; Inv!=None; Inv=Inv.Inventory )   {
    		if ( Inv.class == DesiredClass )
    			bHasObject = true;
    	} */
		//bHasObject = (player.FindInventoryType(event.checkObject) != None);
		bHasObject = (player.FindInventoryType(aClass) != None);
	}

	// Now branch appropriately

	if (bHasObject)
	{
		nextAction = EA_NextEvent;
		nextLabel  = "";
	}
	else
	{
		nextAction = EA_JumpToLabel;
		nextLabel  = event.failLabel;
	}

	return nextAction;
}

// ----------------------------------------------------------------------
// SetupEventTransferObject()
//
// Gives a Pawn the specified object.  The object will be created out of
// thin air (spawned) if there's no "fromActor", otherwise it's
// transfered from one pawn to another.
//
// We now allow this to work without the From actor, which can happen
// in InfoLinks, since the FromActor may not even be on the map.
// This is useful for tranferring DataVaultImages.
// ----------------------------------------------------------------------

function EEventAction SetupEventTransferObject( ConEventTransferObject event, out String nextLabel )
{
	local EEventAction nextAction;
	local Inventory invItemFrom;
	local Inventory invItemTo;
	local ammo AmmoType;
	local bool bSpawnedItem;
	local bool bSplitItem;
	local int itemsTransferred;
    local class<Actor> aClass;
     player.ClientMessage("GiveObject = " $ event.objectName);
    aClass = class<Actor>(DynamicLoadObject(event.objectName, class'Class'));


	itemsTransferred = 1;

	if ( event.failLabel != "" )
	{
		nextAction = EA_JumpToLabel;
		nextLabel  = event.failLabel;
	}
	else
	{
		nextAction = EA_NextEvent;
		nextLabel = "";
	}

	// First verify that the receiver exists!
	if (event.toActor == None)
	{
		log("SetupEventTransferObject:  WARNING!  toActor does not exist!");
		log("  Conversation = " $ con.conName);
		return nextAction;
	}

	// First, check to see if the giver actually has the object.  If not, then we'll
	// fabricate it out of thin air.  (this is useful when we want to allow
	// repeat visits to the same NPC so the player can restock on items in some
	// scenarios).
	//
	// Also check to see if the item already exists in the recipient's inventory

	if (event.fromActor != None)
		invItemFrom = Pawn(event.fromActor).FindInventoryType(aClass);//Pawn(event.fromActor).FindInventoryType(event.giveObject);

	invItemTo   = Pawn(event.toActor).FindInventoryType(aClass);//Pawn(event.toActor).FindInventoryType(event.giveObject);

//log("  invItemFrom = " $ invItemFrom);
//log("  invItemTo   = " $ invItemTo);

	// If the player is doing the giving, make sure we remove it from
	// the object belt.

	// If the giver doesn't have the item then we must spawn a copy of it
	if (invItemFrom == None)
	{
		invItemFrom = Inventory(Spawn(aClass));//Spawn(event.giveObject);
		bSpawnedItem = True;
	}

	// If we're giving this item to the player and he does NOT yet have it,
	// then make sure there's enough room in his inventory for the
	// object!

	if ((invItemTo == None) &&
		(DeusExPlayer(event.toActor) != None) &&
	    (DeusExPlayer(event.toActor).FindInventorySlot(invItemFrom, True) == False))
	{
		// First destroy the object if we previously Spawned it
		if (bSpawnedItem)
			invItemFrom.Destroy();

		return nextAction;
	}

	// Okay, there's enough room in the player's inventory or we're not
	// transferring to the player in which case it doesn't matter.
	//
	// Now check if the recipient already has the item.  If so, we are just
	// going to give it to him, with a few special cases.  Otherwise we
	// need to spawn a new object.

	if (invItemTo != None)
	{
		// Check if this item was in the player's hand, and if so, remove it
		RemoveItemFromPlayer(invItemFrom);

		// If this is ammo, then we want to just increment the ammo count
		// instead of adding another ammo to the inventory

		if (invItemTo.IsA('Ammo'))
		{
			// If this is Ammo and the player already has it, make sure the player isn't
			// already full of this ammo type! (UGH!)
			if (!Ammo(invItemTo).AddAmmo(Ammo(invItemFrom).AmmoAmount))
			{
				invItemFrom.Destroy();
				return nextAction;
			}

			// Destroy our From item
			invItemFrom.Destroy();
		}

		// Pawn cannot have multiple weapons, but we do want to give the
		// player any ammo from the weapon
		else if ((invItemTo.IsA('Weapon')) && (DeusExPlayer(event.ToActor) != None))
		{

			AmmoType = Ammo(DeusExPlayer(event.ToActor).FindInventoryType(Weapon(invItemTo).AmmoName));

			if ( AmmoType != None )
			{
				// Special case for Grenades and LAMs.  Blah.
				if ((AmmoType.IsA('AmmoEMPGrenade')) ||
				    (AmmoType.IsA('AmmoGasGrenade')) ||
					(AmmoType.IsA('AmmoNanoVirusGrenade')) ||
					(AmmoType.IsA('AmmoLAM')))
				{
					if (!AmmoType.AddAmmo(event.TransferCount))
					{
						invItemFrom.Destroy();
						return nextAction;
					}
				}
				else
				{
					if (!AmmoType.AddAmmo(Weapon(invItemTo).PickUpAmmoCount))
					{
						invItemFrom.Destroy();
						return nextAction;
					}

					event.TransferCount = Weapon(invItemTo).PickUpAmmoCount;
					itemsTransferred = event.TransferCount;
				}

				if (event.ToActor.IsA('DeusExPlayer'))
					DeusExPlayer(event.ToActor).UpdateAmmoBeltText(AmmoType);

				// Tell the player he just received some ammo!
				invItemTo = AmmoType;
			}
			else
			{
				// Don't want to show this as being received in a convo
				invItemTo = None;
			}

			// Destroy our From item
			invItemFrom.Destroy();
			invItemFrom = None;
		}

		// Otherwise check to see if we need to transfer more than
		// one of the given item
		else
		{
			itemsTransferred = AddTransferCount(invItemFrom, invItemTo, event, Pawn(event.toActor), False);

			// If no items were transferred, then the player's inventory is full or
			// no more of these items can be stacked, so abort.
			if (itemsTransferred == 0)
				return nextAction;

			// Now destroy the originating object (which we either spawned
			// or is sitting in the giver's inventory), but check to see if this
			// item still has any copies left first

			if (((invItemFrom.IsA('DeusExPickup')) && (DeusExPickup(invItemFrom).bCanHaveMultipleCopies) && (DeusExPickup(invItemFrom).NumCopies <= 0)) ||
			   ((invItemFrom.IsA('DeusExPickup')) && (!DeusExPickup(invItemFrom).bCanHaveMultipleCopies)) ||
			   (!invItemFrom.IsA('DeusExPickup')))
			{
				invItemFrom.Destroy();
				invItemFrom = None;
			}
		}
	}

	// Okay, recipient does *NOT* have the item, so it must be give
	// to that pawn and the original destroyed
	else
	{
		// If the item being given is a stackable item and the
		// recipient isn't receiving *ALL* the copies, then we
		// need to spawn a *NEW* copy and give that to the recipient.
		// Otherwise just do a "SpawnCopy", which transfers ownership
		// of the object to the new owner.

		if ((invItemFrom.IsA('DeusExPickup')) && (DeusExPickup(invItemFrom).bCanHaveMultipleCopies) &&
		    (DeusExPickup(invItemFrom).NumCopies > event.transferCount))
		{
			itemsTransferred = event.TransferCount;
			invItemTo = Inventory(Spawn(aClass));//Spawn(event.giveObject);
			invItemTo.GiveTo(Pawn(event.toActor));
			DeusExPickup(invItemFrom).NumCopies -= event.transferCount;
			bSplitItem   = True;
			bSpawnedItem = True;
		}
		else
		{
			invItemTo = invItemFrom.SpawnCopy(Pawn(event.toActor));
		}

//log("  invItemFrom = "$  invItemFrom);
//log("  invItemTo   = " $ invItemTo);

		if (DeusExPlayer(event.toActor) != None)
			DeusExPlayer(event.toActor).FindInventorySlot(invItemTo);

		// Check if this item was in the player's hand *AND* that the player is
		// giving the item to someone else.
		if ((DeusExPlayer(event.fromActor) != None) && (!bSplitItem))
			RemoveItemFromPlayer(invItemFrom);

		// If this was a DataVaultImage, then the image needs to be
		// properly added to the datavault
		if ((invItemTo.IsA('DataVaultImage')) && (event.toActor.IsA('DeusExPlayer')))
		{
			DeusExPlayer(event.toActor).AddImage(DataVaultImage(invItemTo));

			if (conWinThird != None)
				conWinThird.ShowReceivedItem(invItemTo, 1);
			else
				DeusExRootWindow(player.rootWindow).hud.receivedItems.AddItem(invItemTo, 1);

			invItemFrom = None;
			invItemTo   = None;
		}

		// Special case for Credit Chits also
		else if ((invItemTo.IsA('Credits')) && (event.toActor.IsA('DeusExPlayer')))
		{
			if (conWinThird != None)
				conWinThird.ShowReceivedItem(invItemTo, Credits(invItemTo).numCredits);
			else
				DeusExRootWindow(player.rootWindow).hud.receivedItems.AddItem(invItemTo, Credits(invItemTo).numCredits);

			player.Credits += Credits(invItemTo).numCredits;

			invItemTo.Destroy();

			invItemFrom = None;
			invItemTo   = None;
		}

		// Now check to see if the transfer event specified transferring
		// more than one copy of the object
		else
		{
			itemsTransferred = AddTransferCount(invItemFrom, invItemTo, event, Pawn(event.toActor), True);

			// If no items were transferred, then the player's inventory is full or
			// no more of these items can be stacked, so abort.
			if (itemsTransferred == 0)
			{
				invItemTo.Destroy();
				return nextAction;
			}

			// Update the belt text
			if (invItemTo.IsA('Ammo'))
				player.UpdateAmmoBeltText(Ammo(invItemTo));
			else
				player.UpdateBeltText(invItemTo);
		}
	}

	// Show the player that he/she/it just received something!
	if ((DeusExPlayer(event.toActor) != None) && (conWinThird != None) && (invItemTo != None))
	{
		if (conWinThird != None)
			conWinThird.ShowReceivedItem(invItemTo, itemsTransferred);
		else
			DeusExRootWindow(player.rootWindow).hud.receivedItems.AddItem(invItemTo, itemsTransferred);
	}

	nextAction = EA_NextEvent;
	nextLabel = "";

	return nextAction;
}


// ----------------------------------------------------------------------
// SetupEventCheckPersona()
// ----------------------------------------------------------------------

// "Check SkillPoints" is hacked so that we check your "social engineering" skill instead.
function EEventAction SetupEventCheckPersona( ConEventCheckPersona event, out String nextLabel )
{
	local EEventAction action;
	local int personaValue;
	local bool bPass;

	// First determine which persona item we're checking
	switch(event.personaType)
	{
		case EP_Credits:
			personaValue = player.Credits;
			break;

		case EP_Health:
			player.GenerateTotalHealth();
			personaValue = player.Health;
			break;

		case EP_SkillPoints:  //Checks "Social Engineering" skill level (WeaponHeavy)
			personaValue = Player.SkillSystem.GetSkillLevel(class'SkillWeaponHeavy');
			Player.ClientMessage("Social Engineering = " $ personaValue);
            break;
	}

	// Now decide what to do baby!
	switch(event.condition)
	{
		case EC_Less:
			bPass = (personaValue < event.value);
			break;

		case EC_LessEqual:
			bPass = (personaValue <= event.value);
			break;

		case EC_Equal:
			bPass = (personaValue == event.Value);
			break;

		case EC_GreaterEqual:
			bPass = (personaValue >= event.Value);
			break;

		case EC_Greater:
			bPass = (personaValue > event.Value);
			break;
	}

	if (bPass)
	{
		nextLabel = event.jumpLabel;
		action = EA_JumpToLabel;
	}
	else
	{
		nextLabel = "";
		action = EA_NextEvent;
	}

	return action;
}

defaultproperties
{
}
