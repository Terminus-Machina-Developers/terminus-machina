//-----------------------------------------------------------
//
//-----------------------------------------------------------
class ModScreenSell expands ModScreenInventory;

//SUPER HACKY!!!!!!  Item list and prices.

var class<Inventory> Items[99];
var int Prices[99];

// ----------------------------------------------------------------------
// EquipSelectedItem() = Sell Item
// ----------------------------------------------------------------------

function EquipSelectedItem()
{
	local Inventory inv;
	local int i;
	local bool bItemFound;
	bItemFound=false;

	// If the object's in-hand, then unequip
	// it.  Otherwise put this object in-hand.

	inv = Inventory(selectedItem.GetClientObject());



	if ( inv != None )
	{
        for( i=0; i < ArrayCount(Items)-1; i++)
        {
            if(inv.IsA(Items[i].name))
            {
                Player.ClientMessage( "You received " $ GetActualPrice(i) $ " silvers." );
                player.Credits += GetActualPrice(i);
                //delete one
                UseOneItem(Inventory(selectedItem.GetClientObject()));
                bItemFound = true;
            }
        }
        if(!bItemFound)
        {
            Player.ClientMessage( "They won't buy it." );
        }
       /*
		// Make sure the Binoculars aren't activated.
		if ((player.inHand != None) && (player.inHand.IsA('Binoculars')))
			Binoculars(player.inHand).Activate();
		else if ((player.inHandPending != None) && (player.inHandPending.IsA('Binoculars')))
			Binoculars(player.inHandPending).Activate();

		if ((inv == player.inHand) || (inv == player.inHandPending))
		{
			UnequipItemInHand();
		}
		else
		{
			player.PutInHand(inv);
			PersonaInventoryItemButton(selectedItem).SetEquipped(True);
		}*/
		winCredits.SetCredits(Player.Credits);
        RefreshInventoryItemButtons();
		EnableButtons();
	}
}

function UseOneItem(Inventory inv)
{
    if(inv.IsA('DeusExPickup'))
        DeusExPickup(inv).UseOnce();
    else if(inv.IsA('Ammo'))
        Ammo(inv).UseAmmo(1);
    else{
        player.DeleteInventory(inv);
    }

}

function int GetActualPrice(int i)
{
     //SOCIAL ENG MOD
     //player.ClientMessage("Social Eng Level = " $ player.SkillSystem.GetSkillLevel(Class'DeusEx.SkillWeaponHeavy'));
     if(player.SkillSystem.GetSkillLevel(Class'DeusEx.SkillWeaponHeavy') == 0)
         return Prices[i] * 1;
     else if(player.SkillSystem.GetSkillLevel(Class'DeusEx.SkillWeaponHeavy') == 1)
         return Prices[i] * 1.3;
     else if(player.SkillSystem.GetSkillLevel(Class'DeusEx.SkillWeaponHeavy') == 2)
         return Prices[i] * 1.5;
     else if(player.SkillSystem.GetSkillLevel(Class'DeusEx.SkillWeaponHeavy') == 3){
         return Prices[i] * 1.7;
    }
}

// ----------------------------------------------------------------------
// SelectInventory()
// ----------------------------------------------------------------------

function SelectInventory(PersonaItemButton buttonPressed)
{
	local Inventory anItem;
	local int i;
	local bool bItemFound;

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
			{
				anItem.UpdateInfo(winInfo);
                for( i=0; i < ArrayCount(Items)-1; i++)
                {
                    if(anItem.IsA(Items[i].name))
                    {
                        Player.ClientMessage( "I'll buy it for " $ GetActualPrice(i) $ " silvers." );
                        bItemFound = true;
                        break;
                    }
                }
                if(!bItemFound)
                {
                    Player.ClientMessage( "I don't need that shit." );
                }
            }

			EnableButtons();
		}
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
// UpdateAmmoDisplay()
//
// Displays a list of ammo inside the info window (when the user clicks
// on the Ammo button)
// ----------------------------------------------------------------------

function UpdateAmmoDisplay()
{
	local Inventory inv;
	local DeusExAmmo ammo;
	local int ammoCount;
	local SellAmmoButton btnSellAmmo;
	//local AmmoInfoWindow winammo;
	local int i;
	local AlignWindow winAmmo;
	local PersonaNormalTextWindow winText;
	local Window winIcon;




	if (!bUpdatingAmmoDisplay)
	{
		bUpdatingAmmoDisplay = True;

		winInfo.Clear();

		winInfo.SetTitle(AmmoTitleLabel);
		winInfo.AddAmmoCheckbox(player.bShowAmmoDescriptions);
		winInfo.AddLine();

		inv = Player.Inventory;
		i=0;
		while(inv != None)
		{
			ammo = DeusExAmmo(inv);

			if ((ammo != None) && (ammo.bShowInfo))
			{
 		        winAmmo = AlignWindow(winInfo.winTile.NewChild(Class'AlignWindow'));
		        winAmmo.SetChildVAlignment(VALIGN_Top);
		        winAmmo.SetChildSpacing(4);
				//winInfo.AddAmmoInfoWindow(ammo, player.bShowAmmoDescriptions);
				ammoCount++;
		//add sell button
	            btnSellAmmo = SellAmmoButton(winAmmo.NewChild(Class'SellAmmoButton'));
	            btnSellAmmo.SetButtonText("Sell " $ ammo.class $ "(" $ ammo.AmmoAmount $ ")");
	            btnSellAmmo.AmmoClass = ammo.class;
                btnSellAmmo.EnableWindow();
                //btnSellAmmo.SetPos(000,i+20);
               // i += 20;
			}

			inv = inv.Inventory;
		}

		if (ammoCount == 0)
		{
			winInfo.Clear();
			winInfo.SetTitle(AmmoTitleLabel);
			winInfo.SetText(NoAmmoLabel);
		}

		bUpdatingAmmoDisplay = False;
        winCredits.SetCredits(Player.Credits);
	}
}

// ----------------------------------------------------------------------
// ButtonActivated()
// ----------------------------------------------------------------------

function bool ButtonActivated( Window buttonPressed )
{
	local bool bHandled;
	local Class<DeusExAmmo> ammoClass;
	local SellAmmoButton sammo;
	local DeusExammo amm;

	bHandled = True;

    //Check to see if this is a sell ammo button

    if(buttonPressed.IsA('SellAmmoButton'))
    {
        sammo = SellAmmoButton(buttonPressed);
        amm = DeusExammo(ModMale(GetPlayerPawn()).FindInventoryType(sammo.AmmoClass));
        if(amm.UseAmmo( 3 ))
        {
            ModMale(GetPlayerPawn()).Credits += 1;
            GetPlayerPawn().ClientMessage("Sold Ammo for 1 silver (" $ amm.AmmoAmount $ " remaining)");
        }
        else
        {
            GetPlayerPawn().ClientMessage("Not Enough Ammo Left");
        }
        sammo.SetButtonText("Sell " $ amm.class $ "(" $ amm.AmmoAmount $ ")");
        winCredits.SetCredits(Player.Credits);
        EnableButtons();

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
     Items(0)=Class'DXMod.Food'
     Items(1)=Class'DXMod.Fasfood'
     Items(2)=Class'DXMod.Sousveiller'
     Items(3)=Class'DeusEx.WeaponPistol'
     Items(4)=Class'DeusEx.WeaponSawedOffShotgun'
     Items(5)=Class'DeusEx.WeaponAssaultGun'
     Items(6)=Class'DeusEx.WeaponAssaultShotgun'
     Items(7)=Class'DeusEx.WeaponProd'
     Items(8)=Class'DXMod.WeaponEMPGun'
     Items(9)=Class'DeusEx.WeaponCombatKnife'
     Items(10)=Class'DeusEx.WeaponEMPGrenade'
     Items(11)=Class'DeusEx.WeaponLAM'
     Items(12)=Class'DeusEx.WeaponGasGrenade'
     Items(13)=Class'DeusEx.WeaponMiniCrossbow'
     Items(14)=Class'DeusEx.WeaponBaton'
     Items(15)=Class'DeusEx.Lockpick'
     Items(16)=Class'DeusEx.MedKit'
     Items(17)=Class'DeusEx.Binoculars'
     Items(18)=Class'DeusEx.BioelectricCell'
     Items(19)=Class'DeusEx.Multitool'
     Items(20)=Class'DXMod.SolarCoat'
     Items(21)=Class'DXMod.TrenchCoat'
     Items(22)=Class'DXMod.Voltear'
     Items(23)=Class'DXMod.IED'
     Items(24)=Class'DXMod.SilverCoat'
     Items(25)=Class'DeusEx.WeaponRifle'
     Items(26)=Class'DeusEx.WeaponSword'
     Items(27)=Class'DXMod.Detonator'
     Items(28)=Class'DeusEx.AugmentationCannister'
     Items(29)=Class'DeusEx.AugmentationUpgradeCannister'
     Items(30)=Class'DeusEx.WeaponFlamethrower'
     Prices(0)=5
     Prices(1)=10
     Prices(2)=8
     Prices(3)=7
     Prices(4)=7
     Prices(5)=15
     Prices(6)=15
     Prices(7)=7
     Prices(8)=10
     Prices(9)=2
     Prices(10)=5
     Prices(11)=5
     Prices(12)=5
     Prices(13)=3
     Prices(14)=1
     Prices(15)=2
     Prices(16)=5
     Prices(17)=2
     Prices(18)=5
     Prices(19)=2
     Prices(20)=8
     Prices(21)=3
     Prices(22)=10
     Prices(23)=10
     Prices(24)=10
     Prices(25)=10
     Prices(26)=2
     Prices(27)=1
     Prices(28)=10
     Prices(29)=8
     Prices(30)=10
     InventoryTitleText="Sell"
     EquipButtonLabel="|&Sell Item"
}
