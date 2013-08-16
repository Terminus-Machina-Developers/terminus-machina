//-----------------------------------------------------------
//
//-----------------------------------------------------------
class ModScreenAugmentations extends HUDMedBotAddAugsScreen;

#exec obj load file=DXModUI


var PersonaActionButtonWindow btnUninstall;
var localized String UninstallButtonLabel;
//#exec texture IMPORT NAME=AugsBackground_1 FILE=Images\AugsBackground_1.pcx GROUP=UI FLAGS=2


// ----------------------------------------------------------------------
// CreateControls()
// ----------------------------------------------------------------------

function CreateControls()
{
	CreateNavBarWindow();
	CreateClientBorderWindow();
	CreateClientWindow();

	CreateTitleWindow(9, 5, AugmentationsTitleText);
	CreateInfoWindow();
	CreateButtons();
	CreateAugmentationLabels();
	CreateAugmentationHighlights();
	CreateAugmentationButtons();
	CreateOverlaysWindow();
	CreateBodyWindow();
	CreateAugsLabel();
	CreateAugCanList();
	CreateMedbotLabel();
	//CreateAugCanWindow();
}
// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

/*event InitWindow()
{
	Super.InitWindow();

	//Log("ModScreenAugmentations Init");
	//Level.Game.ClientMessage("TEST");
}   */

// ----------------------------------------------------------------------
// CreateMedbotLabel()
// ----------------------------------------------------------------------

function CreateMedbotLabel()
{
     /*
	local PersonaHeaderTextWindow txtLabel;

	txtLabel = PersonaHeaderTextWindow(NewChild(Class'PersonaHeaderTextWindow'));
	txtLabel.SetPos(305, 9);
	txtLabel.SetSize(250, 16);
	txtLabel.SetTextAlignments(HALIGN_Right, VALIGN_Center);
	txtLabel.SetText(MedbotInterfaceText);
	*/
}

function CreateNavBarWindow()
{
	winNavBar = PersonaNavBarBaseWindow(NewChild(Class'ModNavBarWindow'));
	winNavBar.SetPos(0, 0);
}


function CreateButtons()
{
	local PersonaButtonBarWindow winActionButtons;

	winActionButtons = PersonaButtonBarWindow(winClient.NewChild(Class'PersonaButtonBarWindow'));
	winActionButtons.SetPos(346, 371);
	winActionButtons.SetWidth(240);
	winActionButtons.FillAllSpace(true);

	btnUpgrade = PersonaActionButtonWindow(winActionButtons.NewChild(Class'PersonaActionButtonWindow'));
	btnUpgrade.SetButtonText(UpgradeButtonLabel);

	//winActionButtons = PersonaButtonBarWindow(winClient.NewChild(Class'PersonaButtonBarWindow'));
	//winActionButtons.SetPos(446, 371);
	//winActionButtons.SetWidth(96);
	//winActionButtons.FillAllSpace(true);

    btnUninstall = PersonaActionButtonWindow(winActionButtons.NewChild(Class'PersonaActionButtonWindow'));
	btnUninstall.SetButtonText(UninstallButtonLabel);

	btnInstall = PersonaActionButtonWindow(winActionButtons.NewChild(Class'PersonaActionButtonWindow'));
	btnInstall.SetButtonText(InstallButtonLabel);


}


// ----------------------------------------------------------------------
// InstallAugmentation()
// ----------------------------------------------------------------------

function InstallAugmentation()
{
	local AugmentationCannister augCan;
	local Augmentation aug;
	local vector vec;
	vec.X = RandRange(-1,1);
    vec.Y = RandRange(-1,1);
    vec.Z = RandRange(-1,1);
	if (HUDMedBotAugItemButton(selectedAugButton) == None)
		return;

	// Get pointers to the AugmentationCannister and the
	// Augmentation Class

	augCan = HUDMedBotAugItemButton(selectedAugButton).GetAugCan();
	aug    = HUDMedBotAugItemButton(selectedAugButton).GetAugmentation();

	// Add this augmentation (if we can get this far, then the augmentation
	// to be added is a valid one, as the checks to see if we already have
	// the augmentation and that there's enough space were done when the
	// AugmentationAddButtons were created)

	player.AugmentationSystem.GivePlayerAugmentation(aug.class);

    if (ModAugmentation(aug).bBiohack)
    {
        Player.PlaySound(sound'BioElectricHiss', SLOT_None,,, 256);
    }
    //Damage the player if they don't have Biohacking skill
    if (ModAugmentation(aug).bBiohack && Player.SkillSystem.GetSkillLevel(Class'DeusEx.SkillMedicine') < 1)
    {
        Player.TakeDamage(5,Player,vec,vect(0,0,0),'Poison' );
        Player.ClientMessage("The biohack was crude and is causing immuno-rejection damage!  Maybe you should become more skilled in biohacking before you genemod yourself again!");
    }

    //Change player appearance if aug affects appearance
    if(aug.IsA('AugSilverCoat'))
    {
        Player.MultiSkins[1] = Texture'DXModCharacters.Skins.SilverTrenchTex';
        Player.MultiSkins[5] = Texture'DXModCharacters.Skins.SilverTrenchTex';
        Player.MultiSkins[6] = Texture'DXModCharacters.Skins.SilverFramesTex';
        Player.MultiSkins[7] = Texture'DeusExCharacters.Skins.LensesTex5';
    }

	// play a cool animation
	medBot.PlayAnim('Scan');

	// Now Destroy the Augmentation cannister
	player.DeleteInventory(augCan);

	// Now remove the cannister from our list
	selectedAugButton.GetParent().Destroy();
	selectedAugButton = None;
	selectedAug       = None;

	// Update the Installed Augmentation Icons
	DestroyAugmentationButtons();
	CreateAugmentationButtons();

	// Need to update the aug list
	PopulateAugCanList();
}

// ----------------------------------------------------------------------
// UpgradeAugmentation()
// ----------------------------------------------------------------------

function UpgradeAugmentation()
{
	local AugmentationUpgradeCannister augCan;
	local ModUpgradeCan modcan;
	local ModAugmentation modaug;
	local bioUpgrade biocan;
	local electroUpgrade electrocan;
	local mechUpgrade mechCan;

	// First make sure we have a selected Augmentation
	if (selectedAug == None)
		return;

    modaug = ModAugmentation(selectedAug);
    //Only upgrade biohacks with bioupgrade and mechs with mechupgrade
    if (modaug != none)
    {
        if(modaug.bBiohack)
        {
	        biocan = BioUpgrade(player.FindInventoryType(Class'BioUpgrade'));
            if(bioCan == none)
            {
                player.ClientMessage("You need a BIOHACK upgrade!");
            }
            augCan = biocan;
        }
        else if(modaug.bElectrohack)
        {
            electrocan = ElectroUpgrade(player.FindInventoryType(Class'ElectroUpgrade'));
            if(electroCan == none)
            {
                player.ClientMessage("You need an ELECTRONIC HACK upgrade!");
            }
            augCan = electroCan;
        }
        else
        {
            player.ClientMessage("You can't upgrade this augmentation.");
        }
        /*
        else
        {
            mechCan = MechUpgrade(player.FindInventoryType(Class'MechUpgrade'));
            if(mechCan == none)
            {
                player.ClientMessage("You need a MECHANICAL HACK upgrade!");
            }
            augCan = mechCan;
        }     */
    }
    else
    {
	    // Now check to see if we have an upgrade cannister
	    augCan = AugmentationUpgradeCannister(player.FindInventoryType(Class'AugmentationUpgradeCannister'));
    }

	if (augCan != None)
	{
		// Increment the level and remove the aug cannister from
		// the player's inventory

		selectedAug.IncLevel();
		selectedAug.UpdateInfo(winInfo);

		augCan.UseOnce();

		// Update the level icons
		if (selectedAugButton != None)
			PersonaAugmentationItemButton(selectedAugButton).SetLevel(selectedAug.GetCurrentLevel());
	}

	UpdateAugCans();
	EnableButtons();
}


// ----------------------------------------------------------------------
// ButtonActivated()
// ----------------------------------------------------------------------

function bool ButtonActivated(Window buttonPressed)
{
	local bool bHandled;

	bHandled   = True;

	switch(buttonPressed)
	{
		case btnUpgrade:
			UpgradeAugmentation();
			break;

		case btnUninstall:
			UninstallAugmentation();
			break;

		default:
			bHandled = False;
			break;
	}

	if (bHandled)
		return true;
	else
		return Super.ButtonActivated(buttonPressed);

	return bHandled;
}

// ----------------------------------------------------------------------
// UninstallAugmentation()
// ----------------------------------------------------------------------

function UninstallAugmentation()
{
    if(selectedAug != none && ModAugmentation(selectedAug).bCanUninstall)
    {
        ModAugManager(player.AugmentationSystem).RemovePlayerAugmentation(selectedAug.class);
        player.ClientMessage("Removing Aug");
        //Change player appearance if aug affects appearance
        if(selectedAug.IsA('AugSilverCoat'))
        {
            Player.MultiSkins[1] = Player.default.MultiSkins[1]; //Texture'DXModCharacters.Skins.SilverTrenchTex';
            Player.MultiSkins[5] = Player.default.MultiSkins[5]; //Texture'DXModCharacters.Skins.SilverTrenchTex';
            Player.MultiSkins[6] = Player.default.MultiSkins[6]; //Texture'DXModCharacters.Skins.SilverFramesTex';
            Player.MultiSkins[7] = Player.default.MultiSkins[7]; //Texture'DeusExCharacters.Skins.LensesTex5';
        }
    }
    else

    {
         player.ClientMessage("Remove Failed");
    }

    root.InvokeUIScreen(class'ModScreenAugmentations');
   	//selectedAugButton = None;
	//selectedAug       = None;

	// Update the Installed Augmentation Icons
	//DestroyAugmentationButtons();
	//CreateAugmentationButtons();

	// Need to update the aug list
	//PopulateAugCanList();
}

// ----------------------------------------------------------------------
// EnableButtons()
// ----------------------------------------------------------------------

function EnableButtons()
{


	// Only enable the Install button if the player has an
	// Augmentation Cannister aug button selected

	if (HUDMedBotAugItemButton(selectedAugButton) != None)
	{
		btnInstall.EnableWindow(True);
	}
	else
	{
		btnInstall.EnableWindow(False);
	}

	if (selectedAug != none && HUDMedBotAugItemButton(selectedAugButton) == None)
	{
		btnUninstall.EnableWindow(True);
	}
	else
	{
		btnUninstall.EnableWindow(False);
	}

	if (selectedAug != none && HUDMedBotAugItemButton(selectedAugButton) == None)
	{
		btnUpgrade.EnableWindow(True);
	}
	else
	{
		btnUpgrade.EnableWindow(False);
	}

}

defaultproperties
{
     UninstallButtonLabel="|&Uninstall"
     NoCansAvailableText="No Augmentations Available!"
     clientTextures(4)=Texture'DXModUI.UI.ModAugBackground_5'
     clientTextures(5)=Texture'DXModUI.UI.ModAugBackground_6'
}
