//-----------------------------------------------------------
//
//-----------------------------------------------------------
class ModScreenInventory extends PersonaScreenInventory;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

    //Inventory screen is getting disabled because of this?
	PersonaNavBarWindow(winNavBar).btnInventory.SetSensitivity(True);

	EnableButtons();
    //Force an update
    SignalRefresh();

}

// ----------------------------------------------------------------------
// SelectInventory()
// ----------------------------------------------------------------------

function SelectInventory(PersonaItemButton buttonPressed)
{
	local Inventory anItem;

	// Don't do extra work.
	if (buttonPressed != None)
	{
		if (selectedItem != buttonPressed)
		{
			// Deselect current button
			if (selectedItem != None)
				selectedItem.SelectButton(False);

			selectedItem = buttonPressed;

			ClearSpecialHighlights();
			HighlightSpecial(Inventory(selectedItem.GetClientObject()));
			SelectObjectBeltItem(Inventory(selectedItem.GetClientObject()), True);

			selectedItem.SelectButton(True);

			anItem = Inventory(selectedItem.GetClientObject());





			if (anItem != None)
				anItem.UpdateInfo(winInfo);

			EnableButtons();
		}
			//Rechargable weapons
		if( ModWeapon(anItem) != none || (Weapon(anItem) != none
        && Weapon(anItem).AmmoName == class'DeusEx.AmmoBattery'))
		{
		    if( ModWeapon(anItem).bRechargeable || Weapon(anItem).AmmoName == class'DeusEx.AmmoBattery')
		    {
		        btnUse.SetButtonText("RECHARGE");
		        btnUse.EnableWindow();
		    }
		    else
		    {
		        btnUse.SetButtonText(UseButtonLabel);
		    }
		}
	   			     //btnUse.SetButtonText("RECHARGE");
		      //  btnUse.EnableWindow();
	}
	else
	{
		if (selectedItem != None)
			PersonaInventoryItemButton(selectedItem).SelectButton(False);

		if (selectedSlot != None)
			selectedSlot.SetToggle(False);

		selectedItem = None;
	}
}


// ----------------------------------------------------------------------
// UseSelectedItem()
// ----------------------------------------------------------------------

function UseSelectedItem()
{
	local Inventory inv;
	local int numCopies;
	local int clipSize;	//size of weapon's clip for purposes of recharging from bioelectic

	inv = Inventory(selectedItem.GetClientObject());

	if (inv != None)
	{
		// If this item was equipped in the inventory screen,
		// make sure we set inHandPending to None so it's not
		// drawn when we exit the Inventory screen

   		if (inv.IsA('ModWeapon') || Weapon(inv).AmmoName == class'DeusEx.AmmoBattery')
		{
            if ((ModWeapon(inv).bRechargeable || Weapon(inv).AmmoName == class'DeusEx.AmmoBattery')&& ModWeapon(inv).RechargeCost <= Player.Energy)
		    {
				clipSize=Weapon(inv).ReloadCount;
		        Weapon(inv).AmmoType.UseAmmo(-1 * clipSize);
		        //ModWeapon(inv).ReloadCount = 6;
		        Player.Energy -= ModWeapon(inv).RechargeCost;
		        Player.PlaySound(Sound'DeusExSounds.Weapons.ProdReloadEnd');
		        Player.ClientMessage("Weapon Recharged");
		        return;
		    }
		    else
		    {
		        Player.ClientMessage("Not Enough Electricity To Recharge");
		        return;
		    }
		}

		if (player.inHandPending == inv)
			player.SetInHandPending(None);


		// If this is a binoculars, then it needs to be equipped
		// before it can be activated
		if (inv.IsA('Binoculars'))
			player.PutInHand(inv);

		inv.Activate();

		// Check to see if this is a stackable item, and keep track of
		// the count
		if ((inv.IsA('DeusExPickup')) && (DeusExPickup(inv).bCanHaveMultipleCopies))
			numCopies = DeusExPickup(inv).NumCopies - 1;
		else
			numCopies = 0;

		// Update the object belt
		invBelt.UpdateBeltText(inv);

		// Refresh the info!
		if (numCopies > 0)
			UpdateWinInfo(inv);
	}
}

// ----------------------------------------------------------------------
// UpdateDragMouse()
// ----------------------------------------------------------------------

function UpdateDragMouse(float newX, float newY)
{
	local Window findWin;
	local Float relX, relY;
	local Int slotX, slotY;
	local PersonaInventoryItemButton invButton;
	local HUDObjectSlot objSlot;
	local Bool bValidDrop;
	local Bool bOverrideButtonColor;

	findWin = FindWindow(newX, newY, relX, relY);

	// If we're dragging an inventory button, behave one way, if we're
	// dragging a hotkey button, behave another

	if (dragButton.IsA('PersonaInventoryItemButton'))
	{
		invButton = PersonaInventoryItemButton(dragButton);

		// If we're over the Inventory Items window, check to see
		// if there's enough space to deposit this item here.

		bValidDrop = False;
		bOverrideButtonColor = False;

		if ((findWin == winItems) || (findWin == dragButton ))
		{
			if ( findWin == dragButton )
				ConvertCoordinates(Self, newX, newY, winItems, relX, relY);

			bValidDrop = CalculateItemPosition(
				Inventory(dragButton.GetClientObject()),
				relX, relY,
				slotX, slotY);

			// If the mouse is still in the window, don't actually hide the
			// button just yet.

			if (bValidDrop && (player.IsEmptyItemSlot(Inventory(invButton.GetClientObject()), slotX, slotY)))
				SetItemButtonPos(invButton, slotX, slotY);
		}

		// Check to see if we're over the Object Belt
		else if (HUDObjectSlot(findWin) != None)
		{
			bValidDrop = True;

			if (HUDObjectSlot(findWin).item != None)
				if (HUDObjectSlot(findWin).item.IsA('NanoKeyRing'))
					bValidDrop = False;

			HUDObjectSlot(findWin).SetDropFill(bValidDrop);
		}

		// Check to see if we're over another inventory item
		else if (PersonaInventoryItemButton(findWin) != None)
		{
			// If we're dragging a weapon mod and we're over a weapon, check to
			// see if the mod can be dropped here.
			//
			// Otherwise this is a bad drop location

			PersonaInventoryItemButton(findWin).SetDropFill(False);

            //Check for items dragged to backpack
            if(findWin.GetClientObject().IsA('BackPack'))
            {
            		bValidDrop = True;
					PersonaInventoryItemButton(findWin).SetDropFill(True);
					invButton.bValidSlot = False;
					invButton.bDimIcon   = False;
					bOverrideButtonColor = True;

					invButton.ResetFill();
            }

			// Check for weapon mods being dragged over weapons
			else if ((dragButton.GetClientObject().IsA('WeaponMod')) && (findWin.GetClientObject().IsA('DeusExWeapon')))
			{
				if (WeaponMod(invButton.GetClientObject()).CanUpgradeWeapon(DeusExWeapon(findWin.GetClientObject())))
				{
					bValidDrop = True;
					PersonaInventoryItemButton(findWin).SetDropFill(True);
					invButton.bValidSlot = False;
					invButton.bDimIcon   = False;
					bOverrideButtonColor = True;

					invButton.ResetFill();
				}
			}

			// Check for ammo being dragged over weapons
			else if ((dragButton.GetClientObject().IsA('DeusExAmmo')) && (findWin.GetClientObject().IsA('DeusExWeapon')))
			{
				if (DeusExWeapon(findWin.GetClientObject()).CanLoadAmmoType(DeusExAmmo(dragButton.GetClientObject())))
				{
					bValidDrop = True;
					PersonaInventoryItemButton(findWin).SetDropFill(True);
					invButton.bValidSlot = False;
					invButton.bDimIcon   = False;
					bOverrideButtonColor = True;

					invButton.ResetFill();
				}
			}
		}

		if (!bOverrideButtonColor)
		{
			invButton.SetDropFill(bValidDrop);
			invButton.bDimIcon = !bValidDrop;

			if (HUDObjectSlot(findWin) != None)
				invButton.bValidSlot = False;
			else
				invButton.bValidSlot = bValidDrop;
		}
	}
	else
	{
		// This is an Object Belt item we're dragging

		objSlot = HUDObjectSlot(dragButton);
		bValidDrop = False;

		// Can only be dragged over another object slot
		if (findWin.IsA('HUDObjectSlot'))
		{
			if (HUDObjectSlot(findWin).item != None)
			{
				if (!HUDObjectSlot(findWin).item.IsA('NanoKeyRing'))
				{
					bValidDrop = True;
				}
			}
			else
			{
				bValidDrop = True;
			}

			HUDObjectSlot(findWin).SetDropFill(bValidDrop);
		}

		objSlot.bDimIcon = !bValidDrop;
	}

	// Unhighlight the previous window we were over
	if ((lastDragOverButton != None) && (lastDragOverButton != findWin))
	{
		if (lastDragOverButton.IsA('HUDObjectSlot'))
		{
			HUDObjectSlot(lastDragOverButton).ResetFill();
		}
		else if (lastDragOverButton.IsA('PersonaInventoryItemButton'))
		{
			PersonaInventoryItemButton(lastDragOverButton).ResetFill();
		}
	}

	// Keep track of the last button window we were over
	lastDragOverButton = ButtonWindow(findWin);
	lastDragOverWindow = findWin;
}

// ----------------------------------------------------------------------
// FinishButtonDrag()
// ----------------------------------------------------------------------

function FinishButtonDrag()
{
	local int beltSlot;
	local Inventory dragInv;
	local PersonaInventoryItemButton dragTarget;
	local HUDObjectSlot itemSlot;

	// Take a look at the last window we were over to determine
	// what to do now.  If we were over the Inventory Items window,
	// then move the item to a new slot.  If we were over the Object belt,
	// then assign this item to the appropriate key

	if (dragButton == None)
	{
		EndDragMode();
		return;
	}

	if (dragButton.IsA('PersonaInventoryItemButton'))
	{
		dragInv    = Inventory(dragButton.GetClientObject());
		dragTarget = PersonaInventoryItemButton(lastDragOverButton);

		//Check if dragging to a backpack
		if( (dragTarget != None) && dragTarget.GetClientObject().IsA('BackPack')
        && dragTarget.GetClientObject() != dragInv
        && BackPack(dragTarget.GetClientObject()).AddItem(dragInv))
		{
            Player.RemoveObjectFromBelt(dragInv);
            //invBelt.objBelt.RemoveObjectFromBelt(dragInv);

				// Send status message
				//winStatus.AddText(Sprintf(WeaponUpgradedLabel, DeusExWeapon(dragTarget.GetClientObject()).itemName));

            //DEUS_EX AMSD done here for multiplayer propagation.
            draginv.Destroy();
				//player.DeleteInventory(dragInv);

            dragButton = None;
            SelectInventory(dragTarget);
		}

		// Check if this is a weapon mod and we landed on a weapon
		else if ( (dragInv.IsA('WeaponMod')) && (dragTarget != None) && (dragTarget.GetClientObject().IsA('DeusExWeapon')) )
		{
			if (WeaponMod(dragInv).CanUpgradeWeapon(DeusExWeapon(dragTarget.GetClientObject())))
			{
				// 0.  Unhighlight highlighted weapons
				// 1.  Apply the weapon upgrade
				// 2.  Remove from Object Belt
				// 3.  Destroy the upgrade (will cause button to be destroyed)
				// 4.  Highlight the weapon.

				WeaponMod(dragInv).ApplyMod(DeusExWeapon(dragTarget.GetClientObject()));

            Player.RemoveObjectFromBelt(dragInv);
            //invBelt.objBelt.RemoveObjectFromBelt(dragInv);

				// Send status message
				winStatus.AddText(Sprintf(WeaponUpgradedLabel, DeusExWeapon(dragTarget.GetClientObject()).itemName));

            //DEUS_EX AMSD done here for multiplayer propagation.
            WeaponMod(draginv).DestroyMod();
				//player.DeleteInventory(dragInv);

				dragButton = None;
				SelectInventory(none);
			}
			else
			{
				// move back to original spot
				ReturnButton(PersonaInventoryItemButton(dragButton));
			}
		}

		// Check if this is ammo and we landed on a weapon
		else if ((dragInv.IsA('DeusExAmmo')) && (dragTarget != None) && (dragTarget.GetClientObject().IsA('DeusExWeapon')) )
		{
			if (DeusExWeapon(dragTarget.GetClientObject()).CanLoadAmmoType(DeusExAmmo(dragInv)))
			{
				// Load this ammo into the weapon
				DeusExWeapon(dragTarget.GetClientObject()).LoadAmmoType(DeusExAmmo(dragInv));

				// Send status message
				winStatus.AddText(Sprintf(AmmoLoadedLabel, DeusExAmmo(dragInv).itemName));

				// move back to original spot
				ReturnButton(PersonaInventoryItemButton(dragButton));
			}
		}
		else
		{
			if (dragTarget == dragButton)
			{
				MoveItemButton(PersonaInventoryItemButton(dragButton), PersonaInventoryItemButton(dragButton).dragPosX, PersonaInventoryItemButton(dragButton).dragPosY );
			}
			else if ( HUDObjectSlot(lastDragOverButton) != None )
			{
				beltSlot = HUDObjectSlot(lastDragOverButton).objectNum;

				// Don't allow to be moved over NanoKeyRing
				if (beltSlot > 0)
				{
					invBelt.AddObject(dragInv, beltSlot);
				}

				// Restore item to original slot
				ReturnButton(PersonaInventoryItemButton(dragButton));
			}
			else if (lastDragOverButton != dragButton)
			{
				// move back to original spot
				ReturnButton(PersonaInventoryItemButton(dragButton));
			}
		}
	}
	else		// 'ObjectSlot'
	{
		// Check to see if this is a valid drop location (which are only
		// other object slots).
		//
		// Swap the two items and select the one that was dragged
		// but make sure the target isn't the NanoKeyRing

		itemSlot = HUDObjectSlot(lastDragOverButton);

		if (itemSlot != None)
		{
			if (((itemSlot.Item != None) && (!itemSlot.Item.IsA('NanoKeyRing'))) || (itemSlot.Item == None))
			{
				invBelt.SwapObjects(HUDObjectSlot(dragButton), itemSlot);
				itemSlot.SetToggle(True);
			}
		}
		else
		{
			// If the player drags the item outside the object belt,
			// then remove it.

			ClearSlotItem(HUDObjectSlot(dragButton).item);
		}
	}

    EndDragMode();
}



// ----------------------------------------------------------------------
// CreateNavBarWindow()
// ----------------------------------------------------------------------

function CreateNavBarWindow()
{
	winNavBar = PersonaNavBarBaseWindow(NewChild(Class'ModNavBarWindow'));
	winNavBar.SetPos(0, 0);
}

// ----------------------------------------------------------------------
// CreateCreditsWindow()
// ----------------------------------------------------------------------

function CreateCreditsWindow()
{
	winCredits = ModInventoryCreditsWindow(winClient.NewChild(Class'ModInventoryCreditsWindow'));
	winCredits.SetPos(165, 3);
	winCredits.SetWidth(108);
	winCredits.SetCredits(Player.Credits);
}

// ----------------------------------------------------------------------
// ButtonActivated()
// ----------------------------------------------------------------------

function bool ButtonActivated( Window buttonPressed )
{
	local bool bHandled;
	local Class<DeusExAmmo> ammoClass;

	local BackpackButton btnBack;
	local DeusExammo amm;

	bHandled = True;

    //Check to see if this is a Backpack button

    if(buttonPressed.IsA('BackpackButton'))
    {
        if(BackpackButton(buttonPressed).Backp != none)
        {
            btnBack = BackpackButton(buttonPressed);
            if(btnBack.Backp.UnpackItem(btnBack.InvIndex))
            {
                btnBack.DestroyAllChildren();
                btnBack.Destroy();
            }
            if (!bDragging)
            {
                RefreshInventoryItemButtons();
                //CleanBelt();
            }
        }
        else
        {
            Player.ClientMessage("Couldn't find backpack");
        }
        EnableButtons();
        btnBack.Backp.UpdateInfo(winInfo);

    }

	// First check to see if this is an Ammo button
	else if (buttonPressed.IsA('PersonaAmmoDetailButton'))
	{
		if (DeusExWeapon(selectedItem.GetClientObject()) != None)
		{
			// Before doing anything, check to see if this button is already
			// selected.

			if (!PersonaAmmoDetailButton(buttonPressed).bSelected)
			{
				winInfo.SelectAmmoButton(PersonaAmmoDetailButton(buttonPressed));
				ammoClass = LoadAmmo();
				DeusExWeapon(selectedItem.GetClientObject()).UpdateAmmoInfo(winInfo, ammoClass);
				EnableButtons();
			}
		}
	}
	// Check to see if this is the Ammo button
	else if ((buttonPressed.IsA('PersonaItemDetailButton')) &&
	         (PersonaItemDetailButton(buttonPressed).icon == Class'AmmoShell'.Default.LargeIcon))
	{
		SelectInventory(PersonaItemButton(buttonPressed));
		UpdateAmmoDisplay();
	}
	// Now check to see if it's an Inventory button
	else if (buttonPressed.IsA('PersonaItemButton'))
	{
		winStatus.ClearText();
		SelectInventory(PersonaItemButton(buttonPressed));
	}
	// Otherwise must be one of our action buttons
	else
	{
		switch( buttonPressed )
		{
			case btnChangeAmmo:
				WeaponChangeAmmo();
				break;

			case btnEquip:
				EquipSelectedItem();
				break;

			case btnUse:
				UseSelectedItem();
				break;

			case btnDrop:
				DropSelectedItem();
				break;

			default:
				bHandled = False;
				break;
		}
	}

	if ( !bHandled )
		bHandled = Super.ButtonActivated(buttonPressed);

	return bHandled;
}

defaultproperties
{
}
