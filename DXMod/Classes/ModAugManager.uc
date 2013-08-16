//-----------------------------------------------------------
//
//-----------------------------------------------------------
class ModAugManager extends AugmentationManager;

var Class<Augmentation> modDefaultAugs[3];
var Class<Augmentation> modAugClasses[50];

// ----------------------------------------------------------------------
// CreateAugmentations()
// ----------------------------------------------------------------------

function CreateAugmentations(DeusExPlayer newPlayer)
{
	local int augIndex;
	local Augmentation anAug;
	local Augmentation lastAug;

	FirstAug = None;
	LastAug  = None;

	player = newPlayer;

	for(augIndex=0; augIndex<arrayCount(augClasses); augIndex++)
	{
		if (augClasses[augIndex] != None)
		{
			anAug = Spawn(augClasses[augIndex], Self);
			anAug.Player = player;

			// Manage our linked list
			if (anAug != None)
			{
				if (FirstAug == None)
				{
					FirstAug = anAug;
				}
				else
				{
					LastAug.next = anAug;
				}

				LastAug  = anAug;
			}
		}
	}

	for(augIndex=0; augIndex<arrayCount(modaugClasses); augIndex++)
	{
		if (modaugClasses[augIndex] != None)
		{
			anAug = Spawn(modaugClasses[augIndex], Self);
			anAug.Player = player;

			// Manage our linked list
			if (anAug != None)
			{
				if (FirstAug == None)
				{
					FirstAug = anAug;
				}
				else
				{
					LastAug.next = anAug;
				}

				LastAug  = anAug;
			}
		}
	}
}

// ----------------------------------------------------------------------
// AddAllAugs()
// ----------------------------------------------------------------------

function AddAllAugs()
{
	local int augIndex;

	// Loop through all the augmentation classes and create
	// any augs that don't exist.  Then set them all to the
	// maximum level.

	for(augIndex=0; augIndex<arrayCount(augClasses); augIndex++)
	{
		if (augClasses[augIndex] != None)
			GivePlayerAugmentation(augClasses[augIndex]);
	}

	for(augIndex=0; augIndex<arrayCount(modaugClasses); augIndex++)
	{
		if (modaugClasses[augIndex] != None)
			GivePlayerAugmentation(modaugClasses[augIndex]);
	}
}

// ----------------------------------------------------------------------
// AddDefaultAugmentations()
// ----------------------------------------------------------------------

//Need to add more augs than the DX initial so added modDefaultAugs
function AddDefaultAugmentations()
{
	local int augIndex;
	for(augIndex=0; augIndex<arrayCount(modDefaultAugs); augIndex++)
	{
		if (modDefaultAugs[augIndex] != None)
			GivePlayerAugmentation(modDefaultAugs[augIndex]);
	}

	for(augIndex=0; augIndex<arrayCount(defaultAugs); augIndex++)
	{
		if (defaultAugs[augIndex] != None)
			GivePlayerAugmentation(defaultAugs[augIndex]);
	}





}

// ----------------------------------------------------------------------
// DeactivateElectric()
//
// Loops through all the Augmentations, deactivating ELECTRIC augs.
// ----------------------------------------------------------------------

function DeactivateElectric()
{
	local Augmentation anAug;

	anAug = FirstAug;
	while(anAug != None)
	{
		if (anAug.bIsActive && ModAugmentation(anAug) != none && ModAugmentation(anAug).bUsesEnergy)
			anAug.Deactivate();
		anAug = anAug.next;
	}
}

// ----------------------------------------------------------------------
// GetAugByKey
// ----------------------------------------------------------------------

function Augmentation GetAugByKey(int keyNum)
{
	local Augmentation anAug;
	local bool bActivated;

	bActivated = False;

	if ((keyNum < 0) || (keyNum > 9))
		return none;

	anAug = FirstAug;
	while(anAug != None)
	{
		if ((anAug.HotKeyNum - 3 == keyNum) && (anAug.bHasIt))
			break;

		anAug = anAug.next;
	}

	if (anAug == None)
	{
		//player.ClientMessage(NoAugInSlot);
	}
	else
	{
        return anAug;
	}

	return none;
}

// ----------------------------------------------------------------------
// GivePlayerAugmentation()
// ----------------------------------------------------------------------

function Augmentation GivePlayerAugmentation(Class<Augmentation> giveClass)
{
	local Augmentation anAug;

	// Checks to see if the player already has it.  If so, we want to
	// increase the level
	anAug = FindAugmentation(giveClass);

	if (anAug == None)
		return None;		// shouldn't happen, but you never know!

	if (anAug.bHasIt)
	{
		anAug.IncLevel();
		return anAug;
	}

	if (AreSlotsFull(anAug))
	{
		Player.ClientMessage(AugLocationFull);
		return anAug;
	}


	anAug.bHasIt = True;

	if (anAug.bAlwaysActive)
	{
		anAug.bIsActive = True;
		anAug.GotoState('Active');
	}
	else
	{
		anAug.bIsActive = False;
	}


	if ( Player.Level.Netmode == NM_Standalone )
		Player.ClientMessage(Sprintf(anAug.AugNowHaveAtLevel, anAug.AugmentationName, anAug.CurrentLevel + 1));

	// Manage our AugLocs[] array
	AugLocs[anAug.AugmentationLocation].augCount++;

	// Assign hot key to new aug
	// (must be after before augCount is incremented!)
   if (Level.NetMode == NM_Standalone)
      anAug.HotKeyNum = AugLocs[anAug.AugmentationLocation].augCount + AugLocs[anAug.AugmentationLocation].KeyBase;
   else
      anAug.HotKeyNum = anAug.MPConflictSlot + 2;

	if ((!anAug.bAlwaysActive) && (Player.bHUDShowAllAugs))
	    Player.AddAugmentationDisplay(anAug);

	return anAug;
}

// ----------------------------------------------------------------------
// GivePlayerAugmentation()
// ----------------------------------------------------------------------

function RemovePlayerAugmentation(Class<Augmentation> giveClass)
{
	local Augmentation anAug;

	// Checks to see if the player already has it.  If so, we want to
	// increase the level
	anAug = FindAugmentation(giveClass);

	//if (anAug == None)
	//	return None;		// shouldn't happen, but you never know!


    anAug.CurrentLevel = 0;

    anAug.bIsActive = False;
	anAug.bHasIt = False;
    anAug.GotoState('Inactive');

    if(ModAugmentation(anAug).InventoryItem != none)
    {
        Player.FrobTarget = Spawn(ModAugmentation(anAug).InventoryItem,,, Player.Location);
        Player.ParseRightClick();
        //Player.AddInventory(Spawn(ModAugmentation(anAug).InventoryItem,,, Player.Location));

    }
    Player.ClientMessage(Sprintf(anAug.AugNowHaveAtLevel, anAug.AugmentationName, anAug.CurrentLevel + 1));

	// Manage our AugLocs[] array
	AugLocs[anAug.AugmentationLocation].augCount--;

	// Assign hot key to new aug
	// (must be after before augCount is incremented!)
   //if (Level.NetMode == NM_Standalone)
  //    anAug.HotKeyNum = AugLocs[anAug.AugmentationLocation].augCount + AugLocs[anAug.AugmentationLocation].KeyBase;
  // else
  //    anAug.HotKeyNum = anAug.MPConflictSlot + 2;

	if ((!anAug.bAlwaysActive) && (Player.bHUDShowAllAugs))
	    Player.RemoveAugmentationDisplay(anAug);

	//anAug.Destroy();
	//return none;
}

// ----------------------------------------------------------------------
// CalcCalorieUse()
//
// Calculates calorie use for all active augmentations
// ----------------------------------------------------------------------

simulated function Float CalcCalorieUse(float deltaTime)
{
	local float energyUse, energyMult;
	local Augmentation anAug;
   local Augmentation PowerAug;

	energyUse = 0;
	energyMult = 1.0;

	anAug = FirstAug;
	while(anAug != None)
	{
		if (anAug.bHasIt && anAug.bIsActive && ModAugmentation(anAug) != none)
		{
			energyUse += ((ModAugmentation(anAug).GetCalorieRate()/60) * deltaTime);
		}
		anAug = anAug.next;
	}
	return energyUse;
}

defaultproperties
{
     modDefaultAugs(1)=Class'DXMod.AugTrenchCoat'
     modAugClasses(0)=Class'DXMod.AugBiolux'
     modAugClasses(1)=Class'DXMod.AugQuadruped'
     modAugClasses(2)=Class'DXMod.AugSilverCoat'
     modAugClasses(3)=Class'DXMod.AugThermophile'
     augClasses(21)=Class'DXMod.AugSolarCoat'
     augClasses(22)=Class'DXMod.AugNohface'
     augClasses(23)=Class'DXMod.AugTrenchCoat'
     augClasses(24)=Class'DXMod.AugHexSlate'
     defaultAugs(0)=None
     defaultAugs(1)=None
     defaultAugs(2)=None
}
