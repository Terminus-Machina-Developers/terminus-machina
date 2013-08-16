//-----------------------------------------------------------
//
//-----------------------------------------------------------
class ModAugmentation extends Augmentation;


var() float CalorieRate;	   //How fast this aug consumes calories (food)
var localized String CalorieRateLabel;
var Class<ModAugCannister> InventoryItem;
var bool bCanUninstall;
var bool bUsesEnergy;
var bool bBiohack;
var bool bElectrohack;

// ----------------------------------------------------------------------
// UsingMedBot()
// ----------------------------------------------------------------------

function UsingMedBot(bool bNewUsingMedbot)
{
	bUsingMedbot = bNewUsingMedbot;
}

// ----------------------------------------------------------------------
// UpdateInfo()
// ----------------------------------------------------------------------

simulated function bool UpdateInfo(Object winObject)
{
	local PersonaInfoWindow winInfo;
	local String strOut;

	winInfo = PersonaInfoWindow(winObject);
	if (winInfo == None)
		return False;

	winInfo.Clear();
	winInfo.SetTitle(AugmentationName);

	if (bUsingMedbot)
	{
		winInfo.SetText(Sprintf(OccupiesSlotLabel, AugLocsText[AugmentationLocation]));
		winInfo.AppendText(winInfo.CR() $ winInfo.CR() $ Description);
	}
	else
	{
		winInfo.SetText(Description);
	}

	// Energy Rate
	winInfo.AppendText(winInfo.CR() $ winInfo.CR() $ Sprintf(EnergyRateLabel, Int(EnergyRate)));

 	// Calorie Rate
	winInfo.AppendText(winInfo.CR() $ winInfo.CR() $ Sprintf(CalorieRateLabel, Int(CalorieRate)));

	// Current Level
	strOut = Sprintf(CurrentLevelLabel, CurrentLevel + 1);

	// Can Upgrade / Is Active labels
	if (CanBeUpgraded())
		strOut = strOut @ CanUpgradeLabel;
	else if (CurrentLevel == MaxLevel )
		strOut = strOut @ MaximumLabel;

	winInfo.AppendText(winInfo.CR() $ winInfo.CR() $ strOut);

	// Always Active?
	if (bAlwaysActive)
		winInfo.AppendText(winInfo.CR() $ winInfo.CR() $ AlwaysActiveLabel);

	return True;
}

// ----------------------------------------------------------------------
// CanBeUpgraded()
//
// Checks to see if the player has an Upgrade cannister for this
// augmentation, as well as making sure the augmentation isn't already
// at full strength.
// ----------------------------------------------------------------------

simulated function bool CanBeUpgraded()
{
	local bool bCanUpgrade;
	local Augmentation anAug;
	local AugmentationUpgradeCannister augCan;
	local ModUpgradeCan modcan;
	local ModAugmentation modaug;
	local bioUpgrade biocan;
	local electroUpgrade electrocan;
	local mechUpgrade mechCan;

	bCanUpgrade = False;

	// Check to see if this augmentation is already at
	// the maximum level
	if ( CurrentLevel < MaxLevel )
	{
        if(bBiohack)
        {
	        biocan = BioUpgrade(player.FindInventoryType(Class'BioUpgrade'));
            if(bioCan == none)
            {
                player.ClientMessage("You need a BIOHACK upgrade!");
            }
            augCan = biocan;
        }
        else if(bElectrohack)
        {
            electrocan = ElectroUpgrade(player.FindInventoryType(Class'ElectroUpgrade'));
            if(electroCan == none)
            {
                player.ClientMessage("You need a ELECTRONIC HACK upgrade!");
            }
            augCan = electroCan;
        }
        else
        {
            mechCan = MechUpgrade(player.FindInventoryType(Class'MechUpgrade'));
            if(mechCan == none)
            {
                player.ClientMessage("You need a MECHANICAL HACK upgrade!");
            }
            augCan = mechCan;
        }
		// Now check to see if the player has a cannister that can
		// be used to upgrade this Augmentation
		//augCan = AugmentationUpgradeCannister(player.FindInventoryType(Class'AugmentationUpgradeCannister'));

		if (augCan != None)
			bCanUpgrade = True;
	}

	return bCanUpgrade;
}



// ----------------------------------------------------------------------
// GetCalorieRate()
//
// Allows the individual augs to override their Calorie use
// ----------------------------------------------------------------------

simulated function float GetCalorieRate()
{
	return CalorieRate;
}

defaultproperties
{
     CalorieRateLabel="Calorie Rate: %d Centicalories/Minute"
     bUsesEnergy=True
}
