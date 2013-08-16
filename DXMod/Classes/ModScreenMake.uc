//-----------------------------------------------------------
//
//-----------------------------------------------------------
class ModScreenMake extends PersonaScreenInventory;

#exec OBJ LOAD FILE=DXModSounds
#exec OBJ LOAD FILE=DXModWeapons

var localized String SchemTitleText;

var PersonaScrollAreaWindow   winScroll;

var PersonaListWindow         lstSchems;

var float MenuFlashTime;
var bool bMenuFlash;
var string OrigTheme;
var string FlashTheme;

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
// CreateControls()
// ----------------------------------------------------------------------

function CreateControls()
{
	CreateNavBarWindow();
	CreateClientBorderWindow();
	CreateClientWindow();

	CreateTitleWindow(9, 5, InventoryTitleText);
	CreateInfoWindow();
	CreateCreditsWindow();
	//CreateObjectBelt();
	CreateButtons();
	CreateItemsWindow();
	//CreateNanoKeyRingWindow();
	//CreateAmmoWindow();
	CreateInventoryButtons();
	CreateStatusWindow();
	CreateSchematicsLabel();
	CreateSchematicsList();
	PopulateSchemsList();
	SetFocusWindow(lstSchems);
}

// ----------------------------------------------------------------------
// CreateButtons()
// ----------------------------------------------------------------------

function CreateButtons()
{
	local PersonaButtonBarWindow winActionButtons;

	winActionButtons = PersonaButtonBarWindow(winClient.NewChild(Class'PersonaButtonBarWindow'));
	winActionButtons.SetPos(9, 339);
	winActionButtons.SetWidth(267);

	btnDrop = PersonaActionButtonWindow(winActionButtons.NewChild(Class'PersonaActionButtonWindow'));
	btnDrop.SetButtonText(DropButtonLabel);

	btnChangeAmmo = PersonaActionButtonWindow(winActionButtons.NewChild(Class'PersonaActionButtonWindow'));
	btnChangeAmmo.SetButtonText(ChangeAmmoButtonLabel);

	btnUse = PersonaActionButtonWindow(winActionButtons.NewChild(Class'PersonaActionButtonWindow'));
	btnUse.SetButtonText(UseButtonLabel);

	btnEquip = PersonaActionButtonWindow(winActionButtons.NewChild(Class'PersonaActionButtonWindow'));
	btnEquip.SetButtonText(EquipButtonLabel);
}


// ----------------------------------------------------------------------
// CreateSchematicsList()
// ----------------------------------------------------------------------

function CreateSchematicsList()
{
	winScroll = CreateScrollAreaWindow(winClient);
	winScroll.SetPos(336, 300);
	winScroll.SetSize(238, 100);

	//winScroll.SetPos(417, 21);
	//winScroll.SetSize(184, 398);

	lstSchems = PersonaListWindow(winScroll.clipWindow.NewChild(Class'PersonaListWindow'));
	lstSchems.EnableMultiSelect(False);
	lstSchems.EnableAutoExpandColumns(True);
	lstSchems.SetNumColumns(3);
	lstSchems.HideColumn(2, True);
	lstSchems.SetSortColumn(0, True);
	lstSchems.EnableAutoSort(False);
	lstSchems.SetColumnWidth(0, 150);
	lstSchems.SetColumnWidth(1, 34);
	lstSchems.SetColumnType(2, COLTYPE_Float);
	lstSchems.SetColumnFont(1, Font'FontHUDWingDings');
}

// ----------------------------------------------------------------------
// PopulateSchemsList()
// ----------------------------------------------------------------------

function PopulateSchemsList()
{
	local DataVaultImage image;
	local int rowId;

    local SchematicManager schemMan;
    local Schematic schem;
	local int i;

	// First clear the list
	lstSchems.DeleteAllRows();

	// Loop through all the notes the player currently has in
	// his possession

    schemMan = ModMale(Player).SchematicSystem;
    if(schemMan == none)  {
         Player.ClientMessage("No Schematic System!");
         return;
    }
    schem = schemMan.FirstSchematic;
    while(schem != none)   {
        if(schem.bAcquired)
        {
            rowId = lstSchems.AddRow(schem.imageDescription);
            lstSchems.SetRowClientObject(rowId, schem);
        }
        schem = schem.next;
    }

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
// CreateSchematicsLabel()
// ----------------------------------------------------------------------

function CreateSchematicsLabel()
{
	CreatePersonaHeaderText(349, 285, SchemTitleText, winClient);
}

// ----------------------------------------------------------------------
// CreateNanoKeyRingWindow()
// ----------------------------------------------------------------------

function CreateNanoKeyRingWindow()
{

	winNanoKeyRing = PersonaItemDetailWindow(winClient.NewChild(Class'PersonaItemDetailWindow'));
	winNanoKeyRing.SetPos(335, 285);
	winNanoKeyRing.SetWidth(121);
	winNanoKeyRing.SetIcon(Class'NanoKeyRing'.Default.LargeIcon);
	winNanoKeyRing.SetItem(player.KeyRing);
	winNanoKeyRing.SetText(NanoKeyRingInfoText);
	winNanoKeyRing.SetTextAlignments(HALIGN_Center, VALIGN_Center);
	winNanoKeyRing.SetCountLabel(NanoKeyRingLabel);
	winNanoKeyRing.SetCount(player.KeyRing.GetKeyCount());
	winNanoKeyRing.SetIconSensitivity(True);
}

// ----------------------------------------------------------------------
// ListSelectionChanged()
// ----------------------------------------------------------------------

event bool ListSelectionChanged(window list, int numSelections, int focusRowId)
{
    Schematic(lstSchems.GetRowClientObject(focusRowId)).UpdateInfo(winInfo);
	//SetImage(DataVaultImage(lstImages.GetRowClientObject(focusRowId)));

	// Set a flag to later clear the "*New*" in the second column
	//lstImages.SetFieldValue(focusRowId, 2, 1);

	return True;
}

//Allow selection of multiple items for new item creation
function SelectInventory(PersonaItemButton buttonPressed)
{
	local Inventory anItem;

	// Don't do extra work.
	if (buttonPressed != None)
	{
		if (!buttonPressed.bSelected)
		{
			// Deselect current button
			//if (selectedItem != None)
			//	selectedItem.SelectButton(False);


			selectedItem = buttonPressed;



			//ClearSpecialHighlights();
			HighlightSpecial(Inventory(selectedItem.GetClientObject()));
			SelectObjectBeltItem(Inventory(selectedItem.GetClientObject()), True);

			selectedItem.SelectButton(True);

			anItem = Inventory(selectedItem.GetClientObject());

			if (anItem != None)
				anItem.UpdateInfo(winInfo);

			EnableButtons();
		}

		else
		{
             buttonPressed.SelectButton(False);
		}
	}
	else
	{
	    ClearSpecialHighlights();
		if (selectedItem != None)
			PersonaInventoryItemButton(selectedItem).SelectButton(False);

		if (selectedSlot != None)
			selectedSlot.SetToggle(False);

		selectedItem = None;
	}
}

// ----------------------------------------------------------------------
// Using UseSelectedItem for "Invent" function
// ----------------------------------------------------------------------

function UseSelectedItem()
{
     InventWithItems();
}


function InventWithItems()
{
	local Window itemWindow;
	local PersonaInventoryItemButton itemButton;
	local Inventory anItem;
    local int i;
    local SchematicManager schemMan;
    local Schematic schem;
    local bool bDiscover;
	local Inventory inv;
	local bool bHasComponent;
	local int numItems;


    bDiscover = false;

	inv = Inventory(selectedItem.GetClientObject());
     //Player.ClientMessage("Inventing with " $ inv.ItemName $ ".");

    schemMan = ModMale(Player).SchematicSystem;
    if(schemMan == none)  {
         Player.ClientMessage("No Schematic System!");
         return;
    }



    schem = schemMan.FirstSchematic;
    //check to see if this combination of items matches a schematic
    while(schem != none)   {
        bDiscover = true;
        for( i=0; schem.components[i] != none; i++){
            bHasComponent = false;

       	    // Loop through all our children and if selected, check the components
        	itemWindow = winItems.GetTopChild();
        	numItems = 0; //need to make sure we have the exact number of components for recipe
        	while( itemWindow != none )
        	{
        		itemButton = PersonaInventoryItemButton(itemWindow);
        		if (itemButton != None){
        			if(itemButton.bSelected){
        			    numItems++;
        			    if(itemButton.GetClientObject().IsA( schem.components[i].Name )){
        			        bHasComponent = true;
        			    }
        			}
        		}
        		itemWindow = itemWindow.GetLowerSibling();
        	}
        	if(!bHasComponent){
        	    bDiscover = false;
        	}
        }
        //make sure exact number of components needed for invention are selected
        if(i == numItems){
            if(bDiscover){
                break;
            }
        }
        else{
            bDiscover = false;
        }

        schem = schem.next;
    }
    if(bDiscover){
        if(!schem.bMakeable)
        {
            //Player.ClientMessage("Schem not Makeable");
            //schem can't be made, only scrapped
        }
        //Make sure the player meets skill reqs
        else if(schem.natureNeeded > Player.SkillSystem.GetSkillLevel(class'SkillWeaponRifle')) {
            Player.ClientMessage( "You have an idea but need better NATUREPUNK skills." );
        }
        //else if(schem.elecNeeded > Player.SkillSystem.GetSkillLevel(class'SkillTech'))
        //    Player.ClientMessage( "You have an idea but need better ELECTRONICS skills." );
       // else if(schem.mechNeeded > Player.SkillSystem.GetSkillLevel(Class'SkillLockpicking'))
       //     Player.ClientMessage( "You have an idea but need better MECHANICS skills." );
       // else if(schem.iedNeeded > Player.SkillSystem.GetSkillLevel(class'SkillDemolition'))
       //     Player.ClientMessage( "You have an idea but need better EXPLOSIVES skills." );
       // else if(schem.bioNeeded > Player.SkillSystem.GetSkillLevel(class'SkillMedicine'))
       //     Player.ClientMessage( "You have an idea but need better BIOHACKING skills." );
       // else if(schem.bAcquired){
       //     Player.ClientMessage( "You've already invented the " $ schem.ImageDescription );
       // }
        else{
       	    PlaySound(Sound'LogSkillPoints', 0.25);
       	    MenuFlash(0.5, "Starlight");

            Player.ClientMessage( "Device Invented! " $ schem.ImageDescription );
            schem.bAcquired = true;
            PopulateSchemsList();
            SetFocusWindow(lstSchems);
        }
    } else{
        PlaySound(Sound'Spark2', 0.25);
    	// couldn't think of anything
    	switch( Rand(2) )
    	{
    		case 0:
    		    Player.ClientMessage( "No dice.");
                break;

    		case 1:
    		    Player.ClientMessage( "Nothing comes to mind.");
                break;

    		case 1:
    		    Player.ClientMessage( "Not happening.");
                break;
        }
    }

}

function MenuFlash( float _time, string HUDTheme )   {

    FlashTheme = HUDTheme;
    OrigTheme = Player.HUDThemeName;
    Player.ThemeManager.SetHUDThemeByName(FlashTheme);
    bMenuFlash=true;
    MenuFlashTime = _time;
    bTickEnabled = true;
}
// ----------------------------------------------------------------------
// Using Equip Button for "Scrap" function
// ----------------------------------------------------------------------

function EquipSelectedItem()
{
    ScrapSelectedItem();
}

function ScrapSelectedItem()
{
	local Inventory inv;
	local Inventory giveItem;
	local string invName;
	local class<Inventory> components[25];
	local int i;
    local SchematicManager schemMan;
    local Schematic schem;
    local ScrappableItem scrappy;

    schemMan = ModMale(Player).SchematicSystem;

	// If the object's in-hand, then unequip
	// it.  Otherwise put this object in-hand.

	inv = Inventory(selectedItem.GetClientObject());
	invName = inv.ItemName;
	if(inv != none){
        schem = schemMan.GetSchemByProduct(inv.Class);
        //if(schem == none)
        //{
            if(ScrappableItem(inv) != none)
            {
                PersonaScreenBaseWindow(winNavBar.GetParent()).SaveSettings();

        	    // Now Destroy the scrapped item
             	//player.DeleteInventory(inv);

             	DeusExPickup(inv).NumCopies--;

               	if (!inv.IsA('SkilledTool'))
                		inv.GotoState('DeActivated');

                if (DeusExPickup(inv).NumCopies <= 0)
                {
                	if (player.inHand == inv)
                		player.PutInHand(None);
                	player.DeleteInventory(inv);
                    //Destroy();
                }
                else
                {
                	DeusExPickup(inv).UpdateBeltText();
                }

                scrappy = ScrappableItem(inv);
                for(i=0; scrappy.ScrapList[i] != none; i++){
                    giveItem = Player.spawn(scrappy.ScrapList[i],,, Player.Location);
                      //If Player has item, add duplicate
                    if(PickUp(giveItem) != none && PickUp(giveItem).bCanHaveMultipleCopies){
                        Player.FrobTarget = giveItem;
                        Player.ParseRightClick();
                    }
                    else{
                        if(Player.FindInventoryType(giveItem.Class) != none){
                            //giveItem.SpawnCopy(Player);
                            Player.FrobTarget = giveItem;
                            Player.ParseRightClick();
                        }
                        else{
                            Player.FrobTarget = giveItem;
                            Player.ParseRightClick();
                        }
                    }
                }
                RefreshInventoryItemButtons();
                root.InvokeUIScreen(Class'ModScreenMake');
                Player.ClientMessage("Scrapping " $ invName $ " for parts");
                MenuFlash(0.1,"PaleGreen");
           	    PlaySound(Sound'DXModSounds.Misc.Scrap', 0.89);
           	    return;
            }


        //}
    }
	if ( schem != None  && schem.bScrappable )
	{
	    //FIXME: just a test.  Should dissect an item into its components and add
	    //to player inventory

        PersonaScreenBaseWindow(winNavBar.GetParent()).SaveSettings();

	    // Now Destroy the scrapped item
     	player.DeleteInventory(inv);

        //give player the components
        for(i=0; schem.components[i] != none; i++){
            giveItem = Player.spawn(schem.components[i],,, Player.Location);
              //If Player has item, add duplicate
            if(PickUp(giveItem) != none && PickUp(giveItem).bCanHaveMultipleCopies){
                Player.FrobTarget = giveItem;
                Player.ParseRightClick();
            }
            else{
                if(Player.FindInventoryType(giveItem.Class) != none){
                    //giveItem.SpawnCopy(Player);
                    Player.FrobTarget = giveItem;
                    Player.ParseRightClick();
                }
                else{
                    Player.FrobTarget = giveItem;
                    Player.ParseRightClick();
                }
            }
        }

        RefreshInventoryItemButtons();
        root.InvokeUIScreen(Class'ModScreenMake');
        Player.ClientMessage("Scrapping " $ invName $ " for parts");
        MenuFlash(0.1,"PaleGreen");
   	    PlaySound(Sound'DXModSounds.Misc.Scrap', 0.89);
    }
    else{
        Player.ClientMessage("Can't scrap " $ inv.ItemName $ "!");
    }
}

// WeaponChangeAmmo() Used for "Assemble"

function WeaponChangeAmmo()
{
    Assemble();
}

// ----------------------------------------------------------------------
// Assemble - make a device from selected items
// ----------------------------------------------------------------------

function Assemble()
{
	local Window itemWindow;
	local PersonaInventoryItemButton itemButton;
	local Inventory anItem;
    local int i;
    local int numToMake;
    local SchematicManager schemMan;
    local Schematic schem;
    local bool bDiscover;
	local Inventory inv;
	local bool bHasComponent;
	local int numItems;
	local Inventory giveItem;
	local string invName;
	local vector vec;


    bDiscover = false;

    schemMan = ModMale(Player).SchematicSystem;
    if(schemMan == none)  {
         Player.ClientMessage("No Schematic System!");
         return;
    }

    schem = schemMan.FirstSchematic;
    //check to see if this combination of items matches a schematic
    while(schem != none)   {
        bDiscover = true;
        for( i=0; schem.components[i] != none; i++){
            bHasComponent = false;

       	    // Loop through all our children and if selected, check the components
        	itemWindow = winItems.GetTopChild();
        	numItems = 0; //need to make sure we have the exact number of components for recipe
        	while( itemWindow != none )
        	{
        		itemButton = PersonaInventoryItemButton(itemWindow);
        		if (itemButton != None){
        			if(itemButton.bSelected){
        			    numItems++;
        			    if(itemButton.GetClientObject().IsA( schem.components[i].Name )){
        			        bHasComponent = true;
        			    }
        			}
        		}
        		itemWindow = itemWindow.GetLowerSibling();
        	}
        	if(!bHasComponent){
        	    bDiscover = false;
        	}
        }
        //make sure exact number of components needed for invention are selected
        if(i == numItems){
            if(bDiscover){
                break;
            }
        }
        else{
            bDiscover = false;
        }

        schem = schem.next;
        //Player.ClientMessage("Schem = " $ schem $ ".");
    }
    //Player.ClientMessage("Image desc = " $ schem.imageDescription $ ".");
    if(bDiscover){
        vec.X = RandRange(-0.5,0.5);
        vec.Y = RandRange(-0.5,0.5);
        vec.Z = RandRange(-0.5,0.5);
        if(!schem.bMakeable)
        {
            return;
        }
        if(schem.natureNeeded > Player.SkillSystem.GetSkillLevel(class'SkillWeaponRifle'))
        {
            Player.ClientMessage( "Making failed!  Upgrade NATUREPUNK skill." );
            return;
        }
        if(schem.elecNeeded > Player.SkillSystem.GetSkillLevel(class'SkillTech'))
        {
            if(Rand(10) <7 )
            {
                Player.ClientMessage( "You electrocuted yourself and construction failed!  Upgrade CIRCUIT BREAKING skill to ensure proper assembly." );
                Player.TakeDamage(10,Player,vect(0,0,0),vect(0,0,0),'Shocked');
                return;
            }
        }
        if(schem.mechNeeded > Player.SkillSystem.GetSkillLevel(Class'SkillLockpicking'))
        {

            if( Player.Energy > 5 )
            {
                Player.Energy -= 5;
                Player.ClientMessage( "You messed up assembly several times, using electricity.  Upgrade MECHANICS skill for proper assembly." );
            }
            else
            {
                Player.ClientMessage( "You'll need more electricity to build this.  Or you could upgrade MECHANICS skill for proper assembly." );
                return;
            }
        }
        if(schem.iedNeeded > Player.SkillSystem.GetSkillLevel(class'SkillDemolition'))
        {
            if(Rand(10) <7 )
            {
                Player.ClientMessage( "Construction failed!  Upgrade EXPOSIVES skill to ensure proper assembly." );
                Player.TakeDamage(10,Player,vect(0,0,0),vect(0,0,0),'Shot');
                return;
            }
        }
        if(schem.bioNeeded > Player.SkillSystem.GetSkillLevel(class'SkillMedicine'))
        {
            Player.ClientMessage( "You need better BIOHACKING skills." );
            return;
        }
        //Remove components from player inventory
        for( i=0; schem.components[i] != none; i++){
   	        // Loop through inventory, deleting the component
        	itemWindow = winItems.GetTopChild();
        	while( itemWindow != none )
        	{
        		itemButton = PersonaInventoryItemButton(itemWindow);
        		if (itemButton != None){
    			    if(itemButton.GetClientObject().IsA( schem.components[i].Name )){
    			        if(schem.SaveComponents[i] != 1)
    			        {
                            //delete one
    			            UseOneItem(Inventory(itemButton.GetClientObject()));
    			        }
    			    }
        		}
        		itemWindow = itemWindow.GetLowerSibling();
        	}
        }
        if(schem.GoverningSkill == none)
        {
            numToMake = 1;
        }
        else
        {
            numToMake = schem.numProduct[Player.SkillSystem.GetSkillLevel(schem.GoverningSkill)];
        }
        for(i=0; schem.ExtraSpawn[i] != none; i++)
        {
            //Make Item
            giveItem = Player.spawn(schem.ExtraSpawn[i],,, Player.Location);
            invName = giveItem.ItemName;
              //If Player has item, add duplicate
            if(PickUp(giveItem) != none && PickUp(giveItem).bCanHaveMultipleCopies){
                Player.FrobTarget = giveItem;
                Player.ParseRightClick();
            }
            else{
                if(Player.FindInventoryType(giveItem.Class) != none){
                    //giveItem.SpawnCopy(Player);
                    Player.FrobTarget = giveItem;
                    Player.ParseRightClick();
                }
                else{
                    Player.FrobTarget = giveItem;
                    Player.ParseRightClick();
                }
            }
        }
        for(i=0; i < numToMake; i++)
        {
            //Make Item
            giveItem = Player.spawn(schem.product,,, Player.Location);
            invName = giveItem.ItemName;
              //If Player has item, add duplicate
            if(PickUp(giveItem) != none && PickUp(giveItem).bCanHaveMultipleCopies){
                Player.FrobTarget = giveItem;
                Player.ParseRightClick();
            }
            else{
                if(Player.FindInventoryType(giveItem.Class) != none){
                    //giveItem.SpawnCopy(Player);
                    Player.FrobTarget = giveItem;
                    Player.ParseRightClick();
                }
                else{
                    Player.FrobTarget = giveItem;
                    Player.ParseRightClick();
                }
            }
        }
        RefreshInventoryItemButtons();
        root.InvokeUIScreen(Class'ModScreenMake');
        Player.ClientMessage("Assembling " $ invName $ ".");
        MenuFlash(0.2,"SoylentGreen");
        SelectInventoryItem(giveItem);
        PlaySound(Sound'DropMediumWeapon', 0.25);
    } else {
        Player.ClientMessage("It didn't work.");
        PlaySound(Sound'Spark2', 0.25);
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

// ----------------------------------------------------------------------
// CreateInventoryButtons()
//
// Loop through all the Inventory items and draw them in our Inventory
// grid as buttons
//
// As we're doing this, we're going to regenerate the inventory grid
// stored in the player, since it sometimes (very rarely) gets corrupted
// and this is a nice hack to make sure it stays clean should that
// occur.  Ooooooooooo did I say "nice hack"?
// ----------------------------------------------------------------------

function CreateInventoryButtons()
{
	local Inventory anItem;
	local PersonaInventoryItemButton newButton;

	// First, clear the player's inventory grid.
    // DEUS_EX AMSD Due to not being able to guarantee order of delivery for functions,
    // do NOT clear inventory in multiplayer, else we risk clearing AFTER a lot of the sets
    // below.
    if (player.Level.NetMode == NM_Standalone)
        player.ClearInventorySlots();

	// Iterate through the inventory items, creating a unique button for each
	anItem = player.Inventory;

	while(anItem != None)
	{
		if (anItem.bDisplayableInv)
		{
			// Create another button
			newButton = PersonaInventoryItemButton(winItems.NewChild(Class'PersonaInventoryItemButton'));
			newButton.SetClientObject(anItem);
			newButton.SetInventoryWindow(Self);

			// If the item has a large icon, use it.  Otherwise just use the
			// smaller icon that's also shared by the object belt

			if ( anItem.largeIcon != None )
			{
				newButton.SetIcon(anItem.largeIcon);
				newButton.SetIconSize(anItem.largeIconWidth, anItem.largeIconHeight);
			}
			else
			{
				newButton.SetIcon(anItem.icon);
				newButton.SetIconSize(smallInvWidth, smallInvHeight);
			}

			newButton.SetSize(
				(invButtonWidth  * anItem.invSlotsX) + 1,
				(invButtonHeight * anItem.invSlotsY) + 1);

			// Okeydokey, update the player's inventory grid with this item.
			player.SetInvSlots(anItem, 1);

            //DONT DO THIS
			// If this item is currently equipped, notify the button
			//if ( anItem == player.inHand )
			//	newButton.SetEquipped( true );

			// If this inventory item already has a position, use it.
			if (( anItem.invPosX != -1 ) && ( anItem.invPosY != -1 ))
			{
				SetItemButtonPos(newButton, anItem.invPosX, anItem.invPosY);
			}
			else
			{
				// Find a place for it.
				if (player.FindInventorySlot(anItem))
					SetItemButtonPos(newButton, anItem.invPosX, anItem.invPosY);
				else
					newButton.Destroy();		// Shit!
			}
		}

		anItem = anItem.Inventory;
	}
}

// ----------------------------------------------------------------------
// EnableButtons()
// ----------------------------------------------------------------------

function EnableButtons()
{
	local Inventory inv;

	// Make sure all the buttons exist!
	if ((btnChangeAmmo == None) || (btnDrop == None) || (btnEquip == None) || (btnUse == None))
		return;

	if ( selectedItem == None )
	{
		btnChangeAmmo.DisableWindow();
		btnDrop.DisableWindow();
		btnEquip.DisableWindow();
		btnUse.DisableWindow();
	}
	else
	{
		btnChangeAmmo.EnableWindow();
		btnEquip.EnableWindow();
		btnUse.EnableWindow();
		btnDrop.EnableWindow();

		inv = Inventory(selectedItem.GetClientObject());

		if (inv != None)
		{
			// Anything can be dropped, except the NanoKeyRing
			btnDrop.EnableWindow();

			if (inv.IsA('NanoKeyRing'))
			{
				btnChangeAmmo.DisableWindow();
				btnDrop.DisableWindow();
				btnEquip.DisableWindow();
				btnUse.DisableWindow();
			}
			else
			{
				//btnChangeAmmo.DisableWindow();
			}
		}
		else
		{
			btnChangeAmmo.DisableWindow();
			btnDrop.DisableWindow();
			btnEquip.DisableWindow();
			btnUse.DisableWindow();
		}
	}
}

function Tick(float deltaTime)
{
	if (destroyWindow != none && !bMenuFlash)
	{
		destroyWindow.Destroy();
		bTickEnabled = False;
	}
    if(bMenuFlash){
         MenuFlashTime -= deltaTime;
         if((MenuFlashTime * 100) % 2 < 1)  {
         //if(Player.ThemeManager.GetCurrentHUDColorTheme() == self.StringToName(OrigTheme) ) {
             Player.ThemeManager.SetHUDThemeByName(FlashTheme);
             //Player.NextHUDColorTheme();
             //Player.NextHUDColorTheme();
             DeusExRootWindow(Player.rootWindow).ChangeStyle();
         }
         else{
             Player.ThemeManager.SetHUDThemeByName(OrigTheme);
             DeusExRootWindow(Player.rootWindow).ChangeStyle();
         }
         if(MenuFlashTime <= 0){
                  Player.ThemeManager.SetHUDThemeByName(OrigTheme);
                  bMenuFlash = false;
                  bTickEnabled = False;
                  DeusExRootWindow(Player.rootWindow).ChangeStyle();
         }
    }
}

// ----------------------------------------------------------------------
// RefreshWindow()
// ----------------------------------------------------------------------

function RefreshWindow(float DeltaTime)
{
    TimeSinceLastUpdate = TimeSinceLastUpdate + DeltaTime;

    if (TimeSinceLastUpdate >= 0.25)
    {
        TimeSinceLastUpdate = 0;
        if (!bDragging)
        {
            RefreshInventoryItemButtons();
            CleanBelt();
        }
    }

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

defaultproperties
{
     SchemTitleText="Schematics"
     MenuFlashTime=-100.000000
     InventoryTitleText="Make"
     EquipButtonLabel="Scrap"
     UnequipButtonLabel="Unequip"
     UseButtonLabel="Invent"
     ChangeAmmoButtonLabel="Assemble"
     ClientWidth=617
     ClientHeight=439
     clientTextures(4)=Texture'DXModUI.UserInterface.MakeBackground_5'
     clientTextures(5)=Texture'DXModUI.UserInterface.MakeBackground_6'
     clientBorderTextures(4)=Texture'DXModUI.UserInterface.MakeBorder_5'
     clientBorderTextures(5)=Texture'DXModUI.UserInterface.MakeBorder_6'
}
