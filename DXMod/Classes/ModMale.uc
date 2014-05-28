//-----------------------------------------------------------
//
//-----------------------------------------------------------
class ModMale expands JCDentonMale;

#exec OBJ LOAD FILE=DXModCharacters
#exec OBJ LOAD FILE=DXModWeapons

//#exec AUDIO IMPORT FILE="Sounds\Augmentation\CloakDown.wav"					NAME="CloakDown"			GROUP="Augmentation"
//#exec AUDIO IMPORT FILE="Sounds\Augmentation\CloakUp.wav"					NAME="CloakUp"			GROUP="Augmentation"

var ShopTrigger Shop;

//#exec CONVERSATION IMPORT FILE="Conversations\Mission50.Con"

var bool		bNohface;    // Outside-the-player view.
var() sound ActivateSound;
var() sound DeactivateSound;
var texture PlayerFace;      //The player's face
var PhaceBookFace PlayerPhace;
var travel PhaceBookFace CurrentPhace;
var travel texture PhaceTextures[4];
var travel string AllPhaceNames[99];           //For saving phaces during travel
var travel string AllPhaceSkins[99];           //dynamic loaded
var texture NohFaceTexture;
var travel float Calories;
var float HungerTime;
var float FasFoodTimer;
var name NameConversionHack;
var bool bMapVisible;
var bool bWirelessVisible;
var bool bEMPFX;
var bool bMultiCopiesAllowed;
var bool bWirelessConnection;
var bool bResetRunSilent;
var bool bNoDroneStrike;
var bool bJammedDrones;
var Beam b1, b2;

// Schematics
var travel DatavaultImage FirstSchem;

// Schematics
var travel DataVaultImage FirstPhace;

// Augmentation system vars
var travel SchematicManager SchematicSystem;
var float LastLeapTime;                       //Can't leap too rapidly


// ----------------------------------------------------------------------
// StartNewGame()
//
// Starts a new game given the map passed in
// ----------------------------------------------------------------------
  /*       */
exec function StartNewGame(String startMap)
{
	if (DeusExRootWindow(rootWindow) != None)
		DeusExRootWindow(rootWindow).ClearWindowStack();

	// Set a flag designating that we're traveling,
	// so MissionScript can check and not call FirstFrame() for this map.
	flagBase.SetBool('PlayerTraveling', True, True, 0);

	SkillPointsTotal = Default.SkillPointsTotal;
	SkillPointsAvail = Default.SkillPointsAvail;
	SaveSkillPoints();
	ResetPlayer();
    SkillSystem.ResetSkills();
	DeleteSaveGameFiles();

	bStartingNewGame = True;

	// Send the player to the specified map!
	if (startMap == "")
		Level.Game.SendPlayer(Self, "50_t");		// TODO: Must be stored somewhere!
	else
		Level.Game.SendPlayer(Self, startMap);
}

// ----------------------------------------------------------------------
// ShowIntro()
// ----------------------------------------------------------------------

function ShowIntro(optional bool bStartNewGame)
{
	if (DeusExRootWindow(rootWindow) != None)
		DeusExRootWindow(rootWindow).ClearWindowStack();

	bStartNewGameAfterIntro = bStartNewGame;

	// Make sure all augmentations are OFF before going into the intro
	AugmentationSystem.DeactivateAll();

	// Reset the player
	Level.Game.SendPlayer(Self, "49_tmint");
}

// ----------------------------------------------------------------------
// StartTrainingMission()
// ----------------------------------------------------------------------

function StartTrainingMission()
{
	if (DeusExRootWindow(rootWindow) != None)
		DeusExRootWindow(rootWindow).ClearWindowStack();

   // Make sure the player isn't asked to do this more than
	// once if prompted on the main menu.
	if (!bAskedToTrain)
	{
		bAskedToTrain = True;
		SaveConfig();
	}

   SkillSystem.ResetSkills();
	ResetPlayer(True);
	DeleteSaveGameFiles();
	bStartingNewGame = True;
	Level.Game.SendPlayer(Self, "50_train");
}

function PreTravel()
{
    local int i;
    local DataVaultImage tmpImage;
	// make sure we destroy the light before we travel
	if (b1 != None)
		b1.Destroy();
	if (b2 != None)
		b2.Destroy();
	b1 = None;
	b2 = None;

	//PHACE TRAVELLING

	tmpImage = FirstPhace;
	for( i=0; tmpImage != none; i++)
	{
	    if(tmpImage.IsA('PhaceBookFace'))
	    {
	        AllPhaceNames[i] = tmpImage.imageDescription;
	        AllPhaceSkins[i] = string(tmpImage.imageTextures[0]);

	        //if(tmpImage.imageTextures[0] == none)
	        //   ClientMessage("Blank Phace Texture");
	        tmpImage = tmpImage.nextImage;
	    }
	}
	Super.PreTravel();
}


function ResetPlayerToDefaults()
{
   // reset the schematic linked list
	FirstSchem = None;
	FirstPhace = None;
    Calories = self.default.Calories;
    super.ResetPlayerToDefaults();

}

function ResetPlayer(optional bool bTraining)
{
	local inventory anItem;
	local inventory nextItem;

	ResetPlayerToDefaults();

	// Reset Augmentations
	if (AugmentationSystem != None)
	{
		AugmentationSystem.ResetAugmentations();
		AugmentationSystem.Destroy();
		AugmentationSystem = None;
	}

}

// The player wants to fire.
exec function Fire( optional float F )
{
    local ScriptedPawn SP;
	bJustFired = true;
	if( bShowMenu || (Level.Pauser!="") || (Role < ROLE_Authority) )
	{
		if( (Role < ROLE_Authority) && (Weapon!=None) )
			bJustFired = Weapon.ClientFire(F);
		if ( !bShowMenu && (Level.Pauser == PlayerReplicationInfo.PlayerName)  )
			SetPause(False);
		return;
	}
	if( Weapon!=None )
	{
        UpdateWeaponAccuracy();
	    //ClientMessage("Firing Weapon");
        if( DeusExWeapon(Weapon).bHandToHand )
        {
            //Player may drop weapon if unskilled
            if(SkillSystem.GetSkillLevel(class'SkillWeaponLowTech') < 1 && FRand() < 0.1)
            {
                DropItem(none, true);
            }
        }
		Weapon.bPointing = true;
		PlayFiring();
		if (( Level.NetMode == NM_Standalone ) || ( Level.NetMode == NM_ListenServer ))	// Handled through client as an mp client
			Weapon.Fire(F);
	}

	else if(inHand == none && AugmentationSystem.GetAugLevelValue(class'AugBiolux') > 1.0)
	{
	    ClientFlash(0.001, vect(0,500,500));
	    BurnCalories(1);
	    PlaySound(sound'DXModSounds.Misc.BioFlash', SLOT_None,64000,, 10056);
	    foreach RadiusActors(class'ScriptedPawn',SP,AugmentationSystem.GetAugLevelValue(class'AugBiolux')*30,Location)
	    {
	        if(CheckFacingMe(SP))
	        {
	            SP.TakeDamage(5,self,vect(0,0,0),vect(0,0,0),'TearGas');
	        }
	    }
	}
}

function bool CheckFacingMe(Pawn P)
{
	local float dotp;
    local vector HitVec, X,Y,Z;
     	GetAxes(P.Rotation,X,Y,Z);
    	HitVec = Normal(Location - P.Location );
    	//HitVec2D.Z = 0;
    	dotp = HitVec dot X;
    	if (dotp > 0.1) {
    	    return true;
        }
        return false;
}

// ----------------------------------------------------------------------
// ParseRightClick()
// ----------------------------------------------------------------------

exec function ParseRightClick()
{
	//
	// ParseRightClick deals with things in the WORLD
	//
	// Precedence:
	// - Pickup highlighted Inventory
	// - Frob highlighted object
	// - Grab highlighted Decoration
	// - Put away (or drop if it's a deco) inHand
	//

	local AutoTurret turret;
	local int ViewIndex;
	local bool bPlayerOwnsIt;
   local Inventory oldFirstItem;
	local Inventory oldInHand;
	local Decoration oldCarriedDecoration;
	local Vector loc;
	local class<Meat> meatclass;
	local Meat temp;
	local int i;

    bWirelessConnection = false;

	if (RestrictInput())
		return;

   oldFirstItem = Inventory;
	oldInHand = inHand;
	oldCarriedDecoration = CarriedDecoration;

	if (FrobTarget != None)
		loc = FrobTarget.Location;

	if (FrobTarget != None)
	{

        if(Frobtarget.IsA('ModAnimalCarcass') && !ModAnimalCarcass(Frobtarget).bHarvested)
        {

                 for(i=0; i < SkillSystem.GetSkillLevel(Class'DeusEx.SkillWeaponRifle'); i++)
                 {
                     loc = Frobtarget.Location;
                     loc.Z+=20;
                     loc.Y+=40*i;
                     temp = Spawn( ModAnimalCarcass(Frobtarget).MeatClass,,,loc,);
                     temp.bMasterMeat=false;
                     ModAnimalCarcass(Frobtarget).bHarvested = true;
                 }

            //Meat(Frobtarget).NumCopies = Meat(Frobtarget).NumCopies + SkillSystem.GetSkillLevel(Class'DeusEx.SkillWeaponRifle');
         }
		// First check if this is a NanoKey, in which case we just
		// want to add it to the NanoKeyRing without disrupting
		// what the player is holding

		if (FrobTarget.IsA('NanoKey'))
		{
			PickupNanoKey(NanoKey(FrobTarget));
			FrobTarget.Destroy();
			FrobTarget = None;
			return;
		}
		else if (FrobTarget.IsA('Inventory'))
		{
			// If this is an item that can be stacked, check to see if
			// we already have one, in which case we don't need to
			// allocate more space in the inventory grid.
			//
			// TODO: This logic may have to get more involved if/when
			// we start allowing other types of objects to get stacked.

			if (HandleItemPickup(FrobTarget, True) == False)
				return;

			// if the frob succeeded, put it in the player's inventory
         //DEUS_EX AMSD ARGH! Because of the way respawning works, the item I pick up
         //is NOT the same as the frobtarget if I do a pickup.  So how do I tell that
         //I've successfully picked it up?  Well, if the first item in my inventory
         //changed, I picked up a new item.
			if ( ((Level.NetMode == NM_Standalone) && (Inventory(FrobTarget).Owner == Self)) ||
              ((Level.NetMode != NM_Standalone) && (oldFirstItem != Inventory)) )
			{
            if (Level.NetMode == NM_Standalone)
               FindInventorySlot(Inventory(FrobTarget));
            else
               FindInventorySlot(Inventory);
				FrobTarget = None;
			}
		}
		else if (FrobTarget.IsA('Decoration') && Decoration(FrobTarget).bPushable)
		{
			GrabDecoration();
		}
		else
		{
			if (( Level.NetMode != NM_Standalone ) && ( TeamDMGame(DXGame) != None ))
			{
				if ( FrobTarget.IsA('LAM') || FrobTarget.IsA('GasGrenade') || FrobTarget.IsA('EMPGrenade'))
				{
					if ((ThrownProjectile(FrobTarget).team == PlayerReplicationInfo.team) && ( ThrownProjectile(FrobTarget).Owner != Self ))
					{
						if ( ThrownProjectile(FrobTarget).bDisabled )		// You can re-enable a grenade for a teammate
						{
							ThrownProjectile(FrobTarget).ReEnable();
							return;
						}
						MultiplayerNotifyMsg( MPMSG_TeamLAM );
						return;
					}
				}
				if ( FrobTarget.IsA('ComputerSecurity') && (PlayerReplicationInfo.team == ComputerSecurity(FrobTarget).team) )
				{
					// Let controlling player re-hack his/her own computer
					bPlayerOwnsIt = False;
					foreach AllActors(class'AutoTurret',turret)
					{
						for (ViewIndex = 0; ViewIndex < ArrayCount(ComputerSecurity(FrobTarget).Views); ViewIndex++)
						{
							if (ComputerSecurity(FrobTarget).Views[ViewIndex].turretTag == turret.Tag)
							{
								if (( turret.safeTarget == Self ) || ( turret.savedTarget == Self ))
								{
									bPlayerOwnsIt = True;
									break;
								}
							}
						}
					}
					if ( !bPlayerOwnsIt )
					{
						MultiplayerNotifyMsg( MPMSG_TeamComputer );
						return;
					}
				}
			}
			// otherwise, just frob it
			DoFrob(Self, None);
		}
	}
	else
	{
		// if there's no FrobTarget, put away an inventory item or drop a decoration
		// or drop the corpse
		if ((inHand != None) && inHand.IsA('POVCorpse'))
			DropItem();
		else
			PutInHand(None);
	}

	if ((oldInHand == None) && (inHand != None))
		PlayPickupAnim(loc);
	else if ((oldCarriedDecoration == None) && (CarriedDecoration != None))
		PlayPickupAnim(loc);
}



// ???a?????????? ?? Shifter v1.8.3 (borrowed from Shifter v1.8.3)
function UpdateInHand()
{
  local bool bSwitch;

  //sync up clientinhandpending.
  if (inHandPending != inHand)
    ClientInHandPending = inHandPending;

   //DEUS_EX AMSD  Don't let clients do this.
   if (Role < ROLE_Authority)
      return;

  if (inHand != inHandPending)
  {
    bInHandTransition = True;
    bSwitch = False;
    if (inHand != None)
    {
      // turn it off if it is on
      if (inHand.bActive && !inHand.IsA('ChargedPickup'))
        inHand.Activate();

      if (inHand.IsA('SkilledTool'))
      {
        if (inHand.IsInState('Idle'))
        {
          SkilledTool(inHand).PutDown();
        }
        else if (inHand.IsInState('Idle2'))
        {
          bSwitch = True;
        }
      }
      else if (inHand.IsA('DeusExWeapon'))
      {
        if (inHand.IsInState('Idle') || inHand.IsInState('Reload'))
          DeusExWeapon(inHand).PutDown();
        else if (inHand.IsInState('DownWeapon') && (Weapon == None))
          bSwitch = True;
      }
      else
      {
        bSwitch = True;
      }
    }
    else
    {
      bSwitch = True;
    }

    // OK to actually switch?
    if (bSwitch)
    {
      SetInHand(inHandPending);
      SelectedItem = inHandPending;

      if (inHand != None)
      {
        if (inHand.IsA('SkilledTool'))
          SkilledTool(inHand).BringUp();
        else if (inHand.IsA('DeusExWeapon'))
        {
          if ( Weapon == None )
          {
            PendingWeapon = Weapon(inHand);
            ChangedWeapon();
          }
          else if ( Weapon != Weapon(inHand) )
          {
            PendingWeapon = Weapon(inHand);
            if ( !Weapon.PutDown() )
              PendingWeapon = None;
          }

          //== Bad, bad code.  Doesn't let us use multiple copies of the same weapon
//          SwitchWeapon(DeusExWeapon(inHand).InventoryGroup);
        }
      }
    }
  }
  else
  {
    bInHandTransition = False;

    // Added this code because it's now possible to reselect an in-hand
    // item while we're putting it down, so we need to bring it back up...

    if (inHand != None)
    {
      // if we put the item away, bring it back up
      if (inHand.IsA('SkilledTool'))
      {
        if (inHand.IsInState('Idle2'))
          SkilledTool(inHand).BringUp();
      }
      else if (inHand.IsA('DeusExWeapon'))
      {
        //Hack to make all rifles governed by pistol skill
        if( DeusExWeapon(inHand).GoverningSkill ==  Class'SkillWeaponHeavy' )
            DeusExWeapon(inHand).GoverningSkill = Class'SkillDemolition';
        if( DeusExWeapon(inHand).GoverningSkill ==  Class'SkillWeaponRifle')
        {
            DeusExWeapon(inHand).GoverningSkill = Class'SkillWeaponPistol';
            UpdateWeaponAccuracy();
            DeusExWeapon(inHand).CalculateAccuracy();
        }
        if (inHand.IsInState('DownWeapon') && (Weapon == None))
        {
          if ( Weapon == None )
          {
            PendingWeapon = Weapon(inHand);
            ChangedWeapon();
          }
          else if ( Weapon != Weapon(inHand) )
          {
            PendingWeapon = Weapon(inHand);
            if ( !Weapon.PutDown() )
              PendingWeapon = None;
          }

          //== Bad, bad code.  Doesn't let us use multiple copies of the same weapon
//          SwitchWeapon(DeusExWeapon(inHand).InventoryGroup);
        }
      }
    }

  }

  UpdateCarcassEvent();
}

// ----------------------------------------------------------------------
// HandleItemPickup()
// ----------------------------------------------------------------------

function bool HandleItemPickup(Actor FrobTarget, optional bool bSearchOnly)
{
  local bool bCanPickup;
  local bool bSlotSearchNeeded;
  local Inventory foundItem;
  local int i;
  local Meat temp, temp2;
  local class<Meat> meatclass;
  local vector loc;

  bSlotSearchNeeded = True;
  bCanPickup = True;


  // Special checks for objects that do not require phsyical inventory
  // in order to be picked up:
  //
  // - NanoKeys
  // - DataVaultImages
  // - Credits

  if ((FrobTarget.IsA('DataVaultImage')) || (FrobTarget.IsA('NanoKey')) || (FrobTarget.IsA('Credits')))
  {
    bSlotSearchNeeded = False;
  }
  else if (FrobTarget.IsA('DeusExPickup'))
  {
    // If an object of this type already exists in the player's inventory *AND*
    // the object is stackable, then we don't need to search.

    if ((FindInventoryType(FrobTarget.Class) != None) && (DeusExPickup(FrobTarget).bCanHaveMultipleCopies))
      bSlotSearchNeeded = False;
  }
  else
  {
    // If this isn't ammo or a weapon that we already have,
    // check if there's enough room in the player's inventory
    // to hold this item.

    foundItem = GetWeaponOrAmmo(Inventory(FrobTarget));

    if (foundItem != None)
    {
      bSlotSearchNeeded = False;

      // if this is an ammo, and we're full of it, abort the pickup
      if (foundItem.IsA('Ammo'))
      {
        if (Ammo(foundItem).AmmoAmount >= Ammo(foundItem).MaxAmmo)
        {
          ClientMessage(TooMuchAmmo);
          bCanPickup = False;
        }
      }

      // If this is a grenade or LAM (what a pain in the ass) then also check
      // to make sure we don't have too many grenades already
      else if ((foundItem.IsA('WeaponEMPGrenade')) ||
          (foundItem.IsA('WeaponGasGrenade')) ||
        (foundItem.IsA('WeaponNanoVirusGrenade')) ||
        (foundItem.IsA('WeaponGrenade')) ||
        (foundItem.IsA('WeaponShuriken')) ||
        (foundItem.IsA('Shuriken')) ||
        (foundItem.IsA('WeaponLAM')))
      {
        if (DeusExWeapon(foundItem).AmmoType.AmmoAmount >= DeusExWeapon(foundItem).AmmoType.MaxAmmo)
        {
          ClientMessage(TooMuchAmmo);
          bCanPickup = False;
        }
      }


      // Otherwise, if this is a single-use weapon, prevent the player
      // from picking up

      else if (foundItem.IsA('Weapon'))
      {
        // If these fields are set as checked, then this is a
        // single use weapon, and if we already have one in our
        // inventory another cannot be picked up (puke).

        bCanPickup = ! ( (Weapon(foundItem).ReloadCount == 0) &&
                         (Weapon(foundItem).PickupAmmoCount == 0) &&
                         //(Weapon(foundItem).AmmoName != None) ||
                         (Weapon(foundItem).bOwnsCrosshair));  // ??? ?????????? ?? ?????????????, ??? ??? ????? ???????????? ?? ??? ??????!
                                                                // ?? ????????? ??? FALSE, ? ?????? ?????? ?????-?? ?????? ????? ?? ????????.

        if (!bCanPickup)
          ClientMessage(Sprintf(CanCarryOnlyOne, foundItem.itemName));
        else //new stuff: we now know it's a weapon we own but isn't single shot (code by DDL)
           {
            //bCanPickup = true; //add this weapon to the inventory (for resale)
            //FindInventorySlot(founditem, false);
            //founditem.SpawnCopy(self);
            //self.AddInventory(founditem);
            founditem = Ammo(findInventoryType(weapon(frobtarget).AmmoName));
            if(founditem != none) //we have ammo, boost it (we SHOULD have ammo, since we have the weapon)
             {
                if(ammo(founditem).AmmoAmount >= Ammo(founditem).MaxAmmo) //too much!
                   ClientMessage(toomuchammo);
                else
                 {
                   ammo(founditem).AmmoAmount += weapon(frobtarget).PickUpAmmoCount; //or you can modify this to be like carcass weapon clip amounts
                   ClientMessage("You're used clip from"@frobtarget);
                   weapon(frobtarget).pickupAmmoCount = 0; //clear the ammo left in the weapon
                   if(ammo(founditem).AmmoAmount > Ammo(founditem).MaxAmmo) //whups!
                     ammo(founditem).AmmoAmount = Ammo(founditem).MaxAmmo;
                 }
                }
             }

        }
      }
  }

  if (bSlotSearchNeeded && bCanPickup)
  {
    if (FindInventorySlot(Inventory(FrobTarget), bSearchOnly) == False)
    {
      ClientMessage(Sprintf(InventoryFull, Inventory(FrobTarget).itemName));
      bCanPickup = False;
      ServerConditionalNotifyMsg( MPMSG_DropItem );
    }
  }

  if (bCanPickup)
  {
    //if (Level.Game.bDeathMatch && (FrobTarget.IsA('DeusExWeapon') || FrobTarget.IsA('DeusExAmmo')))
      //PlaySound(sound'WeaponPickup', SLOT_Interact, 0.5+FRand()*0.25, , 256, 0.95+FRand()*0.1);


    //if(Frobtarget.IsA('Meat') && Frobtarget.Owner.IsA('Carcass'))
     /*
    if(Frobtarget.IsA('Meat') && Meat(Frobtarget).bMasterMeat)
    {

             for(i=0; i < SkillSystem.GetSkillLevel(Class'DeusEx.SkillWeaponRifle'); i++)
             {
                 loc = Frobtarget.Location;
                 loc.Z+=20;
                 loc.Y+=10*i;
                 temp = Meat(Spawn(Frobtarget.class,,,loc,));
                 temp.bMasterMeat=false;
             }

        //Meat(Frobtarget).NumCopies = Meat(Frobtarget).NumCopies + SkillSystem.GetSkillLevel(Class'DeusEx.SkillWeaponRifle');
     }  */
     DoFrob(Self, inHand);

  }

  return bCanPickup;
}

function bool AddSchem(DataVaultImage newImage)
{
	local DataVaultImage image;

	if (newImage == None)
		return False;

	// First make sure the player doesn't already have this image!!
	image = FirstSchem;
	while(image != None)
	{
		if (newImage.imageDescription == image.imageDescription)
			return False;

		image = image.NextImage;
	}

	// If the player doesn't yet have an image, make this his
	// first image.

	newImage.nextImage = FirstSchem;
	newImage.prevImage = None;

	if (FirstSchem != None)
		FirstSchem.prevImage = newImage;

	FirstSchem = newImage;

	return True;
}

function bool GetSchem(class<Schematic> desc)
{
    local Schematic schem;
	// First make sure the player doesn't already have this image!!
	schem = SchematicSystem.FirstSchematic;

	while(schem != None)
	{
		if (schem.Class == desc)
		{
		    schem.bAcquired = true;
            PlaySound(Sound'LogGoalCompleted');
            ClientMessage("Got Schematic: '" $ desc.default.imageDescription $ "'. Check 'Make' menu.");
			return true;
		}

		schem = schem.Next;
	}
	ClientMessage("Could Not Find Schematic " $ desc);
	return false;
}


// ----------------------------------------------------------------------
// InitializeSubSystems()
// ----------------------------------------------------------------------

function InitializeSubSystems()
{
	// Spawn the BarkManager
	if (BarkManager == None)
		BarkManager = Spawn(class'BarkManager', Self);

	// Spawn the Color Manager
	CreateColorThemeManager();
    ThemeManager.SetOwner(self);

	// install the augmentation system if not found
	if (AugmentationSystem == None)
	{
		AugmentationSystem = Spawn(class'ModAugManager', Self);
		AugmentationSystem.CreateAugmentations(Self);
		AugmentationSystem.AddDefaultAugmentations();
        AugmentationSystem.SetOwner(Self);
	}
	else
	{
		AugmentationSystem.SetPlayer(Self);
        AugmentationSystem.SetOwner(Self);
	}

	// install the schematic system if not found
	if (SchematicSystem == None)
	{
		SchematicSystem = Spawn(class'SchematicManager', Self);
		SchematicSystem.CreateSchematics();
        SchematicSystem.SetOwner(Self);
        SchematicSystem.SetPlayer(Self);
	}
	else
	{
		//SchematicSystem.SetPlayer(Self);
        SchematicSystem.SetOwner(Self);
        SchematicSystem.SetPlayer(Self);
	}

	// install the skill system if not found
	if (SkillSystem == None)
	{
		//SkillSystem = Spawn(class'SkillManager', Self);
		SkillSystem = Spawn(class'ModSkillManager', Self);
		SkillSystem.CreateSkills(Self);
	}
	else
	{
		SkillSystem.SetPlayer(Self);
	}

   if ((Level.Netmode == NM_Standalone) || (!bBeltIsMPInventory))
   {
      // Give the player a keyring
      CreateKeyRing();
   }


}

// ----------------------------------------------------------------------
// Multiplayer computer functions
// ----------------------------------------------------------------------

//server->client (computer to frobber)
function InvokeComputerScreen(Computers computerToActivate, float CompHackTime, float ServerLevelTime)
{
   local NetworkTerminal termwindow;
   local DeusExRootWindow root;

   computerToActivate.LastHackTime = CompHackTime + (Level.TimeSeconds - ServerLevelTime);

   ActiveComputer = ComputerToActivate;

   //only allow for clients or standalone
   if ((Level.NetMode != NM_Standalone) && (!PlayerIsClient()))
   {
      ActiveComputer = None;
      CloseComputerScreen(computerToActivate);
      return;
   }

   root = DeusExRootWindow(rootWindow);
   if (root != None)
   {
      termwindow = NetworkTerminal(root.InvokeUIScreen(computerToActivate.terminalType, True));
      if (termwindow != None)
      {
			computerToActivate.termwindow = termwindow;
         termWindow.SetCompOwner(computerToActivate);
         // If multiplayer, start hacking if there are no users
         if ((Level.NetMode != NM_Standalone) && (!termWindow.bHacked) && (computerToActivate.NumUsers() == 0) &&
             (termWindow.winHack != None) && (termWindow.winHack.btnHack != None))
         {
            termWindow.winHack.StartHack();
            termWindow.winHack.btnHack.SetSensitivity(False);
            termWindow.FirstScreen=None;
         }
         termWindow.ShowFirstScreen();
         if(bWirelessConnection)
             termWindow.winHack.btnHack.SetSensitivity(False);
      }
   }

   if ((termWindow == None)  || (root == None))
   {
      CloseComputerScreen(computerToActivate);
      ActiveComputer = None;
   }
}

// ----------------------------------------------------------------------
// ToggleFace()
// ----------------------------------------------------------------------
/*
exec function ToggleFace()
{
	if ( bNohface )     {
    	ClientMessage("Nohface enabled");
    	//ClientMessage("YOU HACKED THE GIBSON!");
        //PlaySound( OT_None );
    	PlaySound(Sound'CloakDown', SLOT_None);//SLOT_Interact, 0.85, ,768,1.0);
       bNohface=false;
	}  else  {
        ClientMessage("Nohface disabled");
        PlaySound(Sound'CloakUp', SLOT_None);//SLOT_Interact, 0.85, ,768,1.0);
        bNohface=true;
    }
} */


// ----------------------------------------------------------------------
// SetPhace()
// ----------------------------------------------------------------------

function SetPhace(PhaceBookFace newPhace)
{
    local float num;
    CurrentPhace = newPhace;
    ModRootWindow(rootWindow).SetPhace(CurrentPhace);
    if(CurrentPhace.Alliance == 'Anonymous')
    {
       num = RandRange(0,4);
       if(num < 1) {
           CurrentPhace.MultiSkins[0] = Texture'DeusExCharacters.Skins.SkinTex1';
           CurrentPhace.MultiSkins[3] = Texture'DeusExCharacters.Skins.SkinTex1';
       }
       else if(num < 2) {
           CurrentPhace.MultiSkins[0] = Texture'DeusExCharacters.Skins.SkinTex2';
           CurrentPhace.MultiSkins[3] = Texture'DeusExCharacters.Skins.SkinTex2';
       }
       else if(num < 3) {
           CurrentPhace.MultiSkins[0] = Texture'DeusExCharacters.Skins.SkinTex3';
           CurrentPhace.MultiSkins[3] = Texture'DeusExCharacters.Skins.SkinTex3';
       }
       else{
           CurrentPhace.MultiSkins[0] = Texture'DeusExCharacters.Skins.SkinTex4';
           CurrentPhace.MultiSkins[3] = Texture'DeusExCharacters.Skins.SkinTex4';
       }
    }
    else{

    }
}

function SetAnonPhace()
{
   local float num;
   num = RandRange(0,4);
   if(num < 1) {
       MultiSkins[0] = Texture'DeusExCharacters.Skins.SkinTex1';
       MultiSkins[3] = Texture'DeusExCharacters.Skins.SkinTex1';
   }
   else if(num < 2) {
       MultiSkins[0] = Texture'DeusExCharacters.Skins.SkinTex2';
       MultiSkins[3] = Texture'DeusExCharacters.Skins.SkinTex2';
   }
   else if(num < 3) {
       MultiSkins[0] = Texture'DeusExCharacters.Skins.SkinTex3';
       MultiSkins[3] = Texture'DeusExCharacters.Skins.SkinTex3';
   }
   else{
       MultiSkins[0] = Texture'DeusExCharacters.Skins.SkinTex4';
       MultiSkins[3] = Texture'DeusExCharacters.Skins.SkinTex4';
   }

}


// ----------------------------------------------------------------------
// ToggleNohface
// ----------------------------------------------------------------------

function ToggleNohface(bool bOn)
{
    //local WirelessOverlay WO;
    //local name NameConversionHack;
    local string srcstr;
    local string deststr;
    local ModRobot R;

    bNohface = bOn;
    //GET RID OF ME TESTING DRONE STRIKE
    //foreach AllActors(class'ModRobot', R)
    //    break;
    //R.FireMissilesAt('Player');
	if ( bOn )     {
	    if(CurrentPhace == none )
	    {
	        CurrentPhace = GetPhace("Anonymous Face");
	    }

        if(CurrentPhace.Alliance == 'Anonymous')
        {
            SetAnonPhace();
        }
        else
        {
            MultiSkins[0] = CurrentPhace.faceSkin;
            MultiSkins[3] = CurrentPhace.faceSkin;
        }
        ModRootWindow(rootWindow).SetPhace(CurrentPhace);
	    ModRootWindow(rootWindow).ShowPhaceChange();
    	ClientMessage("Nohface enabled");
    	//ClientMessage("YOU HACKED THE GIBSON!");
        //PlaySound( OT_None );
    	PlaySound(Sound'CloakUp', SLOT_None);//SLOT_Interact, 0.85, ,768,1.0);
       //bNohface=false;
        if(CurrentPhace.bWanted){      //enemies will attack if phace is wanted
            Alliance = 'Player';
        }
        else    {
            //Nohface fools humans only at level 2
            /*if( SkillSystem.GetSkillLevelValue(class'DeusEx.SkillWeaponHeavy') > 1)
            {
                Alliance = CurrentPhace.Alliance;
            }
            else {
                Alliance = 'Player';
            }    */
        }
        //ClientMessage("Social Eng Level = " $ SkillSystem.GetSkillLevel(class'DeusEx.SkillDemolition'));
        //if(CurrentPhace.imageDescription == "Counter-Insurgency_Robosoldier") {

            //if( SkillSystem.GetSkillLevel(class'DeusEx.SkillWeaponHeavy') > 0)
            //{
                srcstr = CurrentPhace.imageDescription;
                deststr = Mid(srcstr, 0, 7);
                SetPropertyText("NameConversionHack", deststr);
                ClientMessage("Face Name = " $ NameConversionHack);
                //Nohface fools humans only at level 2

                flagBase.SetBool(NameConversionHack, true);
            //}
            //ClientMessage(NameConversionHack);
        //}

	}  else  {
       // if( SkillSystem.GetSkillLevel(class'DeusEx.SkillWeaponHeavy') > 0)
        //{
            srcstr = CurrentPhace.imageDescription;
            deststr = Mid(srcstr, 0, 7);
            SetPropertyText("NameConversionHack", deststr);
            flagBase.SetBool(NameConversionHack, false);
        //}
        //ClientMessage(NameConversionHack);
        ClientMessage("Nohface disabled");
        PlaySound(Sound'CloakDown', SLOT_None);//SLOT_Interact, 0.85, ,768,1.0);
        //bNohface=true;
        Alliance = 'Player';
	    MultiSkins[0] = default.MultiSkins[0]; //PlayerPhace.faceSkin;
	    MultiSkins[3] = default.MultiSkins[3]; //PlayerPhace.faceSkin;
    }
}




// ----------------------------------------------------------------------
// SetAlliance()
// ----------------------------------------------------------------------

function SetAlliance(Name newAlliance)
{
	Alliance = newAlliance;
}

// ----------------------------------------------------------------------
// SetPhaceWanted
// ----------------------------------------------------------------------

function SetPhaceWanted(bool bWanted)
{
    //Anonymously generated phaces cannot be wanted
    if(CurrentPhace.Alliance == 'Anonymous') {
        return;
    }
    CurrentPhace.bWanted=bWanted;
}

// ----------------------------------------------------------------------
// ShowInventoryWindow()
// ----------------------------------------------------------------------

exec function ShowInventoryWindow()
{
	if (RestrictInput())
		return;

   if ((Level.NetMode != NM_Standalone) && (bBeltIsMPInventory))
   {
      ClientMessage("Inventory screen disabled in multiplayer");
      return;
   }

	InvokeUIScreen(Class'ModScreenInventory');
}

// ----------------------------------------------------------------------
// ShowAugmentationsWindow()   --Show Modified window instead
// ----------------------------------------------------------------------

exec function ShowAugmentationsWindow()
{
	if (RestrictInput())
		return;

   if ((Level.NetMode != NM_Standalone) && (bBeltIsMPInventory))
   {
      ClientMessage("Augmentations screen disabled in multiplayer");
      return;
   }

   InvokeUIScreen(Class'ModScreenAugmentations');
}

// ----------------------------------------------------------------------
// ShowHealthWindow()
// ----------------------------------------------------------------------

exec function ShowHealthWindow()
{
	if (RestrictInput())
		return;

   if ((Level.NetMode != NM_Standalone) && (bBeltIsMPInventory))
   {
      ClientMessage("Health screen disabled in multiplayer");
      return;
   }

   InvokeUIScreen(Class'ModScreenHealth');
}

// ----------------------------------------------------------------------
// ShowImagesWindow()
// ----------------------------------------------------------------------

exec function ShowImagesWindow()
{
	if (RestrictInput())
		return;

   if ((Level.NetMode != NM_Standalone) && (bBeltIsMPInventory))
   {
      ClientMessage("Images screen disabled in multiplayer");
      return;
   }

   InvokeUIScreen(Class'ModScreenImages');
}

// ----------------------------------------------------------------------
// ShowConversationsWindow()
// ----------------------------------------------------------------------

exec function ShowConversationsWindow()
{
	if (RestrictInput())
		return;

   if ((Level.NetMode != NM_Standalone) && (bBeltIsMPInventory))
   {
      ClientMessage("Conversations screen disabled in multiplayer");
      return;
   }

   //AugmentationSystem FindAugmentation(Class'DeusEx.AugLight').
   InvokeUIScreen(Class'ModScreenConversations');
}

function MakeFaceLight()
{

		b2 = Spawn(class'Beam', self, '', self.Location);
		if (b2 != None)
		{
			b2.LightHue = 32;
			b2.LightRadius = 4;
			b2.LightSaturation = 200;//140;
			b2.LightBrightness = 80;//b2.LightBrightness = 100;//220;
			SetGlowLocation();
		}
}

function DestroyFaceLight()
{
	if (b1 != None)
		b1.Destroy();
	if (b2 != None)
		b2.Destroy();
	b1 = None;
	b2 = None;
}

function vector SetGlowLocation()
{
	local vector pos;

	if (b2 != None)
	{
		pos = self.Location + vect(0,0,1)*self.BaseEyeHeight +
		      vect(1,1,0)*vector(self.Rotation)*self.CollisionRadius*1.5;
		b2.SetLocation(pos);
	}
}

// ----------------------------------------------------------------------
// ShowGoalsWindow()
// ----------------------------------------------------------------------

exec function ShowGoalsWindow()
{
	if (RestrictInput())
		return;

   if ((Level.NetMode != NM_Standalone) && (bBeltIsMPInventory))
   {
      ClientMessage("Goals screen disabled in multiplayer");
      return;
   }

   InvokeUIScreen(Class'ModScreenGoals');
}

Exec function ToggleFlag( name flagname )
{
    if(flagBase.GetBool(flagname))
        flagBase.SetBool(flagname, false);
    else
        flagBase.SetBool(flagname, true);
}

// ----------------------------------------------------------------------
// ToggleAmmoDisplay()
// ----------------------------------------------------------------------

exec function SetDiff( int diff)
{
    local DeusExPlayer MSP;
    CombatDifficulty = diff;
    foreach AllActors(class'DeusExPlayer', MSP)
    {
        MSP.CombatDifficulty = diff;
        //if(MSP.CombatDifficulty > 4)
        //    MSP.CombatDifficulty = 1;
    }
    ClientMessage("Combat Difficulty = " $ CombatDifficulty);
}

exec function SetReact()
{
    local ModScriptedPawn MSP;
    foreach AllActors(class'ModScriptedPawn', MSP)
    {
        if(MSP != none)
            MSP.fReactionTime = 1;
    }
}

// ----------------------------------------------------------------------
// ToggleAmmoDisplay()
// ----------------------------------------------------------------------

exec function ToggleAmmoDisplay()
{
	/*local DeusExRootWindow root;

	bAmmoDisplayVisible = !bAmmoDisplayVisible;

	root = DeusExRootWindow(rootWindow);
	if (root != None)
		root.UpdateHud();
   */

	if (RestrictInput())
		return;

   if ((Level.NetMode != NM_Standalone) && (bBeltIsMPInventory))
   {
      ClientMessage("Hack screen disabled in multiplayer");
      return;
   }

   InvokeUIScreen(Class'ModScreenHack');
}

// ----------------------------------------------------------------------
// ToggleAmmoDisplay()
// ----------------------------------------------------------------------

exec function ToggleWirelessDisplay()
{
	local DeusExRootWindow root;

	bWirelessVisible = !bWirelessVisible;

	root = DeusExRootWindow(rootWindow);

}

// ----------------------------------------------------------------------
// GetCurrentGroundSpeed()
// ----------------------------------------------------------------------

function float GetCurrentGroundSpeed()
{
	local float augValue, augValue2, speed;

	// Remove this later and find who's causing this to Access None MB
	if ( AugmentationSystem == None )
		return 0;

   augValue = AugmentationSystem.GetAugLevelValue(class'AugSpeed');

	if (augValue == -1.0)
		augValue = 1.0;

   augValue2 = 1.0;



    if(AugmentationSystem.GetAugLevelValue(class'AugQuadruped') > 0)
    {
        //AugmentationSystem.GetAugLevelValue(class'AugQuadruped');
	    augValue2 = AugmentationSystem.GetAugLevelValue(class'AugQuadruped');
        AccelRate = 4048.000000;

    	if (augValue2 == -1.0)
    		augValue2 = 1.0;
    }
    else
    {
        AccelRate = default.AccelRate;
    }

	augValue = FMax(augValue, augValue2);

	if (( Level.NetMode != NM_Standalone ) && Self.IsA('Human') )
		speed = mpGroundSpeed * augValue;
	else
		speed = Default.GroundSpeed * augValue;

	return speed;
}

// ----------------------------------------------------------------------
// ShowMainMenu()  Need to go to special window for custom key bindings
// ----------------------------------------------------------------------

exec function ShowMainMenu()
{
	local DeusExRootWindow root;
	local DeusExLevelInfo info;
	local MissionEndgame Script;

	if (bIgnoreNextShowMenu)
	{
		bIgnoreNextShowMenu = False;
		return;
	}

	info = GetLevelInfo();

	// Special case baby!
	//
	// If the Intro map is loaded and we get here, that means the player
	// pressed Escape and we want to either A) start a new game
	// or B) return to the dx.dx screen.  Either way we're going to
	// abort the Intro by doing this.
	//
	// If this is one of the Endgames (which have a mission # of 99)
	// then we also want to call the Endgame's "FinishCinematic"
	// function

	// force the texture caches to flush
	ConsoleCommand("FLUSH");

	if ((info != None) && (info.MissionNumber == 98 || info.MissionNumber == 49))
	{
		bIgnoreNextShowMenu = True;
		PostIntro();
	}
	else if ((info != None) && (info.MissionNumber == 99))
	{
		foreach AllActors(class'MissionEndgame', Script)
			break;

		if (Script != None)
			Script.FinishCinematic();
	}
	else
	{
		root = DeusExRootWindow(rootWindow);
		if (root != None)
			root.InvokeMenu(Class'ModMenuMain');
	}
}

// ----------------------------------------------------------------------
// ActivateAugmentation()  Changed Solar to activatable anytime
// (deactivated when zero energy before)
// ----------------------------------------------------------------------

exec function ActivateAugmentation(int num)
{
	local Augmentation anAug;
	local ModAugManager ModAugSys;
	local int count, wantedSlot, slotIndex;
	local bool bFound;

	if (RestrictInput())
		return;

    ModAugSys = ModAugManager(AugmentationSystem);
    if(ModAugSys != none)
        anAug = ModAugSys.GetAugByKey(num);
    if(ModAugmentation(anAug) == none)
    {
        Super.ActivateAugmentation(num);
    }
    else
    {
         //Let the aug turn on if it doesn't use energy (Biolux, Solar Coat, etc)
    	if (Energy == 0 && ModAugmentation(anAug).bUsesEnergy)
    	{
    		ClientMessage(EnergyDepleted);
    		PlaySound(AugmentationSystem.FirstAug.DeactivateSound, SLOT_None);
    		return;
    	}
    	if (Energy == 0 && !ModAugmentation(anAug).bUsesEnergy)
    	{
    	   // energy=0.000001;
    	}

    	if (AugmentationSystem != None)
    		AugmentationSystem.ActivateAugByKey(num);
    }
}

// ----------------------------------------------------------------------
// MaintainEnergy()
// ----------------------------------------------------------------------

function MaintainEnergy(float deltaTime)
{
	local Float energyUse;
   local Float energyRegen;
   local Float calorieUse;
   local Float calorieRegen;

	// make sure we can't continue to go negative if we take damage
	// after we're already out of energy
	if (Energy <= 0)
	{
		Energy = 0;
		EnergyDrain = 0;
		EnergyDrainTotal = 0;
	}

   energyUse = 0;

	// Don't waste time doing this if the player is dead or paralyzed
	if ((!IsInState('Dying')) && (!IsInState('Paralyzed')))
   {
      if (Energy > 0)
      {
         // Decrement energy used for augmentations
         energyUse = AugmentationSystem.CalcEnergyUse(deltaTime);

         if(energy > 100)
             energy = 100;

         Energy -= EnergyUse;

         // Calculate the energy drain due to EMP attacks
         if (EnergyDrain > 0)
         {
            energyUse = EnergyDrainTotal * deltaTime;
            Energy -= EnergyUse;
            EnergyDrain -= EnergyUse;
            if (EnergyDrain <= 0)
            {
               EnergyDrain = 0;
               EnergyDrainTotal = 0;
            }
         }
      }

      if (Calories > 0)
      {
         // Decrement calories used for augmentations
         calorieUse = ModAugManager(AugmentationSystem).CalcCalorieUse(deltaTime);

         Calories -= calorieUse;
      }

      //Do check if energy is 0.
      // If the player's energy drops to zero, deactivate
      // all augmentations
      if (Energy <= 0)
      {
         //If we were using energy, then tell the client we're out.
         //Otherwise just make sure things are off.  If energy was
         //already 0, then energy use will still be 0, so we won't
         //spam.  DEUS_EX AMSD
         if (energyUse > 0)
            ClientMessage(EnergyDepleted);
         Energy = 0;
         EnergyDrain = 0;
         EnergyDrainTotal = 0;
         ModAugManager(AugmentationSystem).DeactivateElectric();
      }

      // If all augs are off, then start regenerating in multiplayer,
      // up to 25%.
      if ((energyUse == 0) && (Energy <= MaxRegenPoint) && (Level.NetMode != NM_Standalone))
      {
         energyRegen = RegenRate * deltaTime;
         Energy += energyRegen;
      }
	}
}

//accuracy hack
function UpdateWeaponAccuracy()
{
    if(DeusExWeapon(InHand) != none)
    {
        //accuracy hack
        /*
        if(DeusExWeapon(InHand).GoverningSkill == Class'SkillWeaponPistol')
        {
            if(SkillSystem.GetSkillLevel(Class'SkillWeaponPistol') < 1)
                DeusExWeapon(InHand).BaseAccuracy = DeusExWeapon(InHand).default.BaseAccuracy + 0.5;
            else
                DeusExWeapon(InHand).BaseAccuracy = DeusExWeapon(InHand).default.BaseAccuracy;
            DeusExWeapon(InHand).CalculateAccuracy();
        }    */
    }
}

//Don't change the player skin between levels (force modded player face)

// ----------------------------------------------------------------------
// TravelPostAccept()
// ----------------------------------------------------------------------

event TravelPostAccept()
{
	local DeusExLevelInfo info;
	local MissionScript scr;
	local bool bScriptRunning;
	local InterpolationPoint I;
	local PhaceBookFace faceItem;
	local Actor A;
	local int j;
	local DataVaultImage tmpImage;
	local texture ftex;

	Super.TravelPostAccept();




	// reset the keyboard
	ResetKeyboard();

	info = GetLevelInfo();

	if (info != None)
	{
		// hack for the DX.dx logo/splash level
		if (info.MissionNumber == -2)
		{
			foreach AllActors(class 'InterpolationPoint', I, 'IntroCam')
			{
				if (I.Position == 1)
				{
					SetCollision(False, False, False);
					bCollideWorld = False;
					Target = I;
					SetPhysics(PHYS_Interpolating);
					PhysRate = 1.0;
					PhysAlpha = 0.0;
					bInterpolating = True;
					bStasis = False;
					ShowHud(False);
					PutInHand(None);
					GotoState('Interpolating');
					break;
				}
			}
			return;
		}

		// hack for the DXOnly.dx splash level
		if (info.MissionNumber == -1)
		{
			ShowHud(False);
			GotoState('Paralyzed');
			return;
		}
	}

	// Restore colors
	if (ThemeManager != None)
	{
		ThemeManager.SetMenuThemeByName(MenuThemeName);
		ThemeManager.SetHUDThemeByName(HUDThemeName);
	}

	// Make sure any charged pickups that were active
	// before travelling are still active.
	RefreshChargedPickups();

	// Make sure the Skills and Augmentation systems
	// are properly initialized and reset.

	RestoreSkillPoints();

	if (SkillSystem != None)
	{
		SkillSystem.SetPlayer(Self);
	}

	if (AugmentationSystem != None)
	{
		// set the player correctly
		AugmentationSystem.SetPlayer(Self);
		AugmentationSystem.RefreshAugDisplay();
	}

	// Nuke any existing conversation
	if (conPlay != None)
		conPlay.TerminateConversation();

	// Make sure any objects that care abou the PlayerSkin
	// are notified
	//UpdatePlayerSkin();

	// If the player was carrying a decoration,
	// call TravelPostAccept() so it can initialize itself
	if (CarriedDecoration != None)
		CarriedDecoration.TravelPostAccept();

	// If the player was carrying a decoration, make sure
	// it's placed back in his hand (since the location
	// info won't properly travel)
	PutCarriedDecorationInHand();

	// Reset FOV
	SetFOVAngle(Default.DesiredFOV);

	// If the player had a scope view up, make sure it's
	// properly restore
	RestoreScopeView();

	// make sure the mission script has been spawned correctly
	if (info != None)
	{
		bScriptRunning = False;
		foreach AllActors(class'MissionScript', scr)
			bScriptRunning = True;

		if (!bScriptRunning)
			info.SpawnScript();
	}

	// make sure the player's eye height is correct
	BaseEyeHeight = CollisionHeight - (GetDefaultCollisionHeight() - Default.BaseEyeHeight);


   //Remove blank faces
   RemoveBlankPhaces();
    //Force player's face to modded face
    // (automatically resets to playerselect skin tone every map change)
    MultiSkins[0] = PlayerFace;
    //MultiSkins[4] = PlayerFace;

    //if(CurrentPhace == none)
    //{
        //make default Phace
        faceItem=spawn(class'PhaceBookFace');//(ModScriptedPawn(Other).CharPhace);
        faceItem.imageTextures[0] = PhaceTextures[0];
        faceItem.imageTextures[1] = PhaceTextures[1];
        faceItem.imageTextures[2] = PhaceTextures[2];
        faceItem.imageTextures[3] = PhaceTextures[3];
        faceItem.faceSkin = MultiSkins[0];
        faceItem.imageDescription = FamiliarName;
        faceItem.Alliance = 'Player';
        AddPhace(faceItem);
        if(faceItem != none)
        {

            PlayerPhace = faceItem;
        }

  /*      //make Noh Phace
        faceItem=spawn(class'PhaceBookFace');//(ModScriptedPawn(Other).CharPhace);
        faceItem.imageTextures[0] = texture'NohPhace_1';
        faceItem.imageTextures[1] = PhaceTextures[1];
        faceItem.imageTextures[2] = PhaceTextures[2];
        faceItem.imageTextures[3] = PhaceTextures[3];
        //NohFaceTexture = NohFaceTex;
        faceItem.faceSkin = texture'NohFaceTex';
        faceItem.imageDescription = "No Face";
        faceItem.Alliance = 'Player';
        AddPhace(faceItem);        */

        //make Anon Phace
        faceItem=spawn(class'PhaceBookFace');//(ModScriptedPawn(Other).CharPhace);
        faceItem.imageTextures[0] = texture'DXModCharacters.UserInterface.AnonPhace_1';
        faceItem.imageTextures[1] = PhaceTextures[1];
        faceItem.imageTextures[2] = PhaceTextures[2];
        faceItem.imageTextures[3] = PhaceTextures[3];
        //NohFaceTexture = NohFaceTex;
        faceItem.faceSkin = texture'DXModCharacters.Skins.NohFaceTex';
        faceItem.imageDescription = "Anonymous Face";
        faceItem.Alliance = 'Anonymous';
        CurrentPhace = faceItem;   //Nohface activates with an anonymous face by default
        AddPhace(faceItem);
   // }




    if( AugmentationSystem.GetAugLevelValue(class'AugSilverCoat') > 0)
    {
        MultiSkins[1] = Texture'DXModCharacters.Skins.SilverTrenchTex';
        MultiSkins[5] = Texture'DXModCharacters.Skins.SilverTrenchTex';
        MultiSkins[6] = Texture'DXModCharacters.Skins.SilverFramesTex';
        MultiSkins[7] = Texture'DeusExCharacters.Skins.LensesTex5';
    }


       //Set Level Map Display
   if( rootWindow != none)
       ModRootWindow(rootWindow).SetMap();

	foreach AllActors( class 'Actor', A, 'LevelEntered' )
	{
		// DEUS_EX CNN
		// If the triggering actor doesn't have a group, then
		// we copy the trigger's group into the group of the triggerer
		// This will make LogicTriggers work correctly and won't
		// affect anything else
		/*if (Other.Group == '')
		{
			Other.Group = Group;
			restoreGroup = True;
		}
		else
			restoreGroup = False;   */

		A.Trigger( self, self );

		// DEUS_EX CNN
		/*if (restoreGroup)
			Other.Group = '';    */
	}



    // PHACE TRAVELLING
	tmpImage = FirstPhace;
	for( j=0; AllPhaceNames[j] != ""; j++)
	{
	        //if( AllPhaceSkins[j] == none)
	            ClientMessage("AllPhaceSkins " $ AllPhaceNames[j]);

            //make Anon Phace
            faceItem=spawn(class'PhaceBookFace');//(ModScriptedPawn(Other).CharPhace);
            ftex = texture(dynamicloadobject(AllPhaceSkins[j], class'texture'));
            faceItem.imageTextures[0] = ftex;
            //faceItem.imageTextures[1] = AllPhaceSkins[j];
            //faceItem.imageTextures[2] = AllPhaceSkins[j];
            //faceItem.imageTextures[3] = AllPhaceSkins[j];
            //NohFaceTexture = NohFaceTex;
            faceItem.faceSkin = ftex;
            faceItem.imageDescription = AllPhaceNames[j];
            //faceItem.Alliance = 'Anonymous';
            //ClientMessage(self.Path MultiSkins[0].Name);
            //CurrentPhace = faceItem;   //Nohface activates with an anonymous face by default
            AddPhace(faceItem);

	}

}

function AddPhace( PhaceBookFace faceItem )
{
 	local DataVaultImage image, nextImage, previmage;
 	local int i;
	// First make sure the player doesn't already have this image!!
	image = FirstPhace;
	while(image != None)
	{
		if (faceItem.imageDescription == image.imageDescription){
			faceItem.Destroy();
			faceItem=none;
		}

		image = image.NextImage;
	}
	if( faceItem != none ){
	   // while(faceNames[i] != "")
       //     i++;

        //faceNames[i] = faceItem.imageDescription;
    	//local DataVaultImage image;

    	// If the player doesn't yet have an image, make this his
    	// first image.
    	faceItem.nextImage = FirstPhace;
    	faceItem.prevImage = None;

    	if (FirstPhace != None)
    		FirstPhace.prevImage = faceItem;

    	FirstPhace = faceItem;


       //AddImage(faceItem);
        faceItem.BecomeItem();
        faceItem.bHidden=true;
        faceItem.GotoState('Idle2');
        //ClientMessage("Face Added");
    }
}

function PhaceBookFace GetPhace( string facename )
{
 	local DataVaultImage image, nextImage, previmage;
 	local int i;
	// First make sure the player doesn't already have this image!!
	image = FirstPhace;
	while(image != None)
	{
		if (facename == image.imageDescription){
            return PhaceBookFace(image);
		}

		image = image.NextImage;
	}
	ClientMessage("Phace " $ facename $ " not found");
    return none;
}

function RemoveBlankPhaces( )
{
 	local DataVaultImage image;
 	local DataVaultImage nextImage;
 	local int i;
	// First make sure the player doesn't already have this image!!
	image = FirstPhace;
	while(image != None)
	{
		if (none == image.imageTextures[0]){
		    nextimage = image.NextImage;
		    image.PrevImage.NextImage = none;
			image.Destroy();
		}
		else
		{
		    nextimage = image.NextImage;
		}
		image = nextimage;

	}
}
// ----------------------------------------------------------------------
// state PlayerWalking
// ----------------------------------------------------------------------

state PlayerWalking
{
    event PlayerTick(float deltaTime)
	{
	    CheckHunger(deltaTime);



		Super.PlayerTick(deltaTime);
	}

	// lets us affect the player's movement
	function ProcessMove ( float DeltaTime, vector newAccel, eDodgeDir DodgeMove, rotator DeltaRot)
	{
		local int newSpeed, defSpeed;
		local name mat;
		local vector HitLocation, HitNormal, checkpoint, downcheck;
		local Actor HitActor, HitActorDown;
		local bool bCantStandUp;
		local Vector loc, traceSize;
		local float alpha, maxLeanDist;
		local float legTotal, weapSkill, leapdamage;
		local vector OldAccel;
		local ScriptedPawn enem;

		// if the spy drone augmentation is active
		if (bSpyDroneActive)
		{
			if ( aDrone != None )
			{
				// put away whatever is in our hand
				if (inHand != None)
					PutInHand(None);

				// make the drone's rotation match the player's view
				aDrone.SetRotation(ViewRotation);

				// move the drone
				loc = Normal((aUp * vect(0,0,1) + aForward * vect(1,0,0) + aStrafe * vect(0,1,0)) >> ViewRotation);

				// opportunity for client to translate movement to server
				MoveDrone( DeltaTime, loc );

				// freeze the player
				Velocity = vect(0,0,0);
			}
			return;
		}

		defSpeed = GetCurrentGroundSpeed();

        //No weapons while quadrupedal
        if(AugmentationSystem.GetAugLevelValue(class'AugQuadruped') > 0)
        {
    		if (inHand != None)
				PutInHand(None);

            //ClientMessage(VSize(Velocity));
            if(VSize(Velocity) > 350 && Physics == PHYS_Falling)
            {
    		 	foreach RadiusActors(Class'ScriptedPawn', enem, 35){
                    if ( enem != none) {
                        //ClientMessage("Hit Enemy! Enemrot = " $ Normal( enem.Rotation )$ "self rot = " $ Normal(Rotation));
                        //ClientMessage(Normal(vector(enem.Rotation)) dot Normal(vector(Rotation)) );
                        //Hit in back = instant death
                        leapdamage=20+(5*SkillSystem.GetSkillLevel(Class'SkillWeaponLowTech'));
                        if( Normal(vector(enem.Rotation)) dot Normal(vector(Rotation)) >  0.6 )
                           leapdamage *= 4;
                        enem.TakeDamage(leapdamage, self, Normal(enem.Location - Location), Velocity, 'Shot');
                        PlaySound(Sound'DXModSounds.Misc.LeapHit', SLOT_None,256);
                        Velocity = vect(0,0,0);
                    }
                }

            }
        }
        else
        {
            if( VSize(Velocity) > 200 )
            {
          		  Calories -= DeltaTime * 0.05;
	              //ClientMessage(Calories);
            }
        }
      // crouching makes you two feet tall
		if (bIsCrouching || bForceDuck || AugmentationSystem.GetAugLevelValue(class'AugQuadruped') > 0)
		{
			if ( Level.NetMode != NM_Standalone )
				SetBasedPawnSize(Default.CollisionRadius, 30.0);
			else
				SetBasedPawnSize(Default.CollisionRadius, 16);

			// check to see if we could stand up if we wanted to
			checkpoint = Location;
			// check normal standing height
			checkpoint.Z = checkpoint.Z - CollisionHeight + 2 * GetDefaultCollisionHeight();
			traceSize.X = CollisionRadius;
			traceSize.Y = CollisionRadius;
			traceSize.Z = 1;
			HitActor = Trace(HitLocation, HitNormal, checkpoint, Location, True, traceSize);
			if (HitActor == None)
				bCantStandUp = False;
			else
				bCantStandUp = True;
		}
		else
		{
         // DEUS_EX AMSD Changed this to grab defspeed, because GetCurrentGroundSpeed takes 31k cycles to run.
			GroundSpeed = defSpeed;

			// make sure the collision height is fudged for the floor problem - CNN
			if (!IsLeaning())
			{
				ResetBasedPawnSize();
			}
		}

		if (bCantStandUp)
			bForceDuck = True;
		else
			bForceDuck = False;

		// if the player's legs are damaged, then reduce our speed accordingly
		newSpeed = defSpeed;

		if ( Level.NetMode == NM_Standalone )
		{
			if (HealthLegLeft < 1)
				newSpeed -= (defSpeed/2) * 0.25;
			else if (HealthLegLeft < 34)
				newSpeed -= (defSpeed/2) * 0.15;
			else if (HealthLegLeft < 67)
				newSpeed -= (defSpeed/2) * 0.10;

			if (HealthLegRight < 1)
				newSpeed -= (defSpeed/2) * 0.25;
			else if (HealthLegRight < 34)
				newSpeed -= (defSpeed/2) * 0.15;
			else if (HealthLegRight < 67)
				newSpeed -= (defSpeed/2) * 0.10;

			if (HealthTorso < 67)
				newSpeed -= (defSpeed/2) * 0.05;
		}

		// let the player pull themselves along with their hands even if both of
		// their legs are blown off
		if ((HealthLegLeft < 1) && (HealthLegRight < 1))
		{
			newSpeed = defSpeed * 0.8;
			bIsWalking = True;
			bForceDuck = True;
		}
		// make crouch speed faster than normal
		else if (bIsCrouching || bForceDuck)
		{
//			newSpeed = defSpeed * 1.8;		// DEUS_EX CNN - uncomment to speed up crouch
			bIsWalking = True;
		}

		// CNN - Took this out because it sucks ASS!
		// if the legs are seriously damaged, increase the head bob
		// (unless the player has turned it off)
/*		if (Bob > 0.0)
		{
			legTotal = (HealthLegLeft + HealthLegRight) / 2.0;
			if (legTotal < 50)
				Bob = Default.Bob * FClamp(0.05*(70 - legTotal), 1.0, 3.0);
			else
				Bob = Default.Bob;
		}
*/
		// slow the player down if he's carrying something heavy
		// Like a DEAD BODY!  AHHHHHH!!!
		if (CarriedDecoration != None)
		{
			newSpeed -= CarriedDecoration.Mass * 2;
		}
		// don't slow the player down if he's skilled at the corresponding weapon skill
		else if ((DeusExWeapon(Weapon) != None) && (Weapon.Mass > 30) && (DeusExWeapon(Weapon).GetWeaponSkill() > -0.25) && (Level.NetMode==NM_Standalone))
		{
			bIsWalking = True;
			newSpeed = defSpeed;
		}
		else if ((inHand != None) && inHand.IsA('POVCorpse'))
		{
			newSpeed -= inHand.Mass * 3;
		}

		// Multiplayer movement adjusters
		if ( Level.NetMode != NM_Standalone )
		{
			if ( Weapon != None )
			{
				weapSkill = DeusExWeapon(Weapon).GetWeaponSkill();
				// Slow down heavy weapons in multiplayer
				if ((DeusExWeapon(Weapon) != None) && (Weapon.Mass > 30) )
				{
					newSpeed = defSpeed;
					newSpeed -= ((( Weapon.Mass - 30.0 ) / (class'WeaponGEPGun'.Default.Mass - 30.0 )) * (0.70 + weapSkill) * defSpeed );
				}
				// Slow turn rate of GEP gun in multiplayer to discourage using it as the most effective close quarters weapon
				if ((WeaponGEPGun(Weapon) != None) && (!WeaponGEPGun(Weapon).bZoomed))
					TurnRateAdjuster = FClamp( 0.20 + -(weapSkill*0.5), 0.25, 1.0 );
				else
					TurnRateAdjuster = 1.0;
			}
			else
				TurnRateAdjuster = 1.0;
		}

		// if we are moving really slow, force us to walking
		if ((newSpeed <= defSpeed / 3) && !bForceDuck)
		{
			bIsWalking = True;
			newSpeed = defSpeed;
		}

		// if we are moving backwards, we should move slower
      // DEUS_EX AMSD Turns out this wasn't working right in multiplayer, I have a fix
      // for it, but it would change all our balance.
		if ((aForward < 0) && (Level.NetMode == NM_Standalone))
			newSpeed *= 0.65;

		GroundSpeed = FMax(newSpeed, 100);

		// if we are moving or crouching, we can't lean
		// uncomment below line to disallow leaning during crouch

			if ((VSize(Velocity) < 10) && (aForward == 0))		// && !bIsCrouching && !bForceDuck)
				bCanLean = True;
			else
				bCanLean = False;

			// check leaning buttons (axis aExtra0 is used for leaning)
			maxLeanDist = 40;

			if (IsLeaning())
			{
				if ( PlayerIsClient() || (Level.NetMode == NM_Standalone) )
					ViewRotation.Roll = curLeanDist * 20;

				if (!bIsCrouching && !bForceDuck)
					SetBasedPawnSize(CollisionRadius, GetDefaultCollisionHeight() - Abs(curLeanDist) / 3.0);
			}
			if (bCanLean && (aExtra0 != 0))
			{
				// lean
				DropDecoration();		// drop the decoration that we are carrying
				if (AnimSequence != 'CrouchWalk')
					PlayCrawling();

				alpha = maxLeanDist * aExtra0 * 2.0 * DeltaTime;

				loc = vect(0,0,0);
				loc.Y = alpha;
				if (Abs(curLeanDist + alpha) < maxLeanDist)
				{
					// check to make sure the destination not blocked
					checkpoint = (loc >> Rotation) + Location;
					traceSize.X = CollisionRadius;
					traceSize.Y = CollisionRadius;
					traceSize.Z = CollisionHeight;
					HitActor = Trace(HitLocation, HitNormal, checkpoint, Location, True, traceSize);

					// check down as well to make sure there's a floor there
					downcheck = checkpoint - vect(0,0,1) * CollisionHeight;
					HitActorDown = Trace(HitLocation, HitNormal, downcheck, checkpoint, True, traceSize);
					if ((HitActor == None) && (HitActorDown != None))
					{
						if ( PlayerIsClient() || (Level.NetMode == NM_Standalone))
						{
							SetLocation(checkpoint);
							ServerUpdateLean( checkpoint );
							curLeanDist += alpha;
						}
					}
				}
				else
				{
					if ( PlayerIsClient() || (Level.NetMode == NM_Standalone) )
						curLeanDist = aExtra0 * maxLeanDist;
				}
			}
			else if (IsLeaning())	//if (!bCanLean && IsLeaning())	// uncomment this to not hold down lean
			{
				// un-lean
				if (AnimSequence == 'CrouchWalk')
					PlayRising();

				if ( PlayerIsClient() || (Level.NetMode == NM_Standalone))
				{
					prevLeanDist = curLeanDist;
					alpha = FClamp(7.0 * DeltaTime, 0.001, 0.9);
					curLeanDist *= 1.0 - alpha;
					if (Abs(curLeanDist) < 1.0)
						curLeanDist = 0;
				}

				loc = vect(0,0,0);
				loc.Y = -(prevLeanDist - curLeanDist);

				// check to make sure the destination not blocked
				checkpoint = (loc >> Rotation) + Location;
				traceSize.X = CollisionRadius;
				traceSize.Y = CollisionRadius;
				traceSize.Z = CollisionHeight;
				HitActor = Trace(HitLocation, HitNormal, checkpoint, Location, True, traceSize);

				// check down as well to make sure there's a floor there
				downcheck = checkpoint - vect(0,0,1) * CollisionHeight;
				HitActorDown = Trace(HitLocation, HitNormal, downcheck, checkpoint, True, traceSize);
				if ((HitActor == None) && (HitActorDown != None))
				{
					if ( PlayerIsClient() || (Level.NetMode == NM_Standalone))
					{
						SetLocation( checkpoint );
						ServerUpdateLean( checkpoint );
					}
				}
			}



		OldAccel = Acceleration;
		Acceleration = NewAccel;
		bIsTurning = ( Abs(DeltaRot.Yaw/DeltaTime) > 5000 );
		if ( (DodgeMove == DODGE_Active) && (Physics == PHYS_Falling) )
			DodgeDir = DODGE_Active;
		else if ( (DodgeMove != DODGE_None) && (DodgeMove < DODGE_Active) )
			Dodge(DodgeMove);

		if ( bPressedJump )
			DoJump();
		if ( (Physics == PHYS_Walking) && (GetAnimGroup(AnimSequence) != 'Dodge') )
		{
			if (!bIsCrouching)
			{
				if (bDuck != 0)
				{
					bIsCrouching = true;
					PlayDuck();
				}
			}
			else if (bDuck == 0)
			{
				OldAccel = vect(0,0,0);
				bIsCrouching = false;
				TweenToRunning(0.1);
			}

			if ( !bIsCrouching )
			{
				if ( (!bAnimTransition || (AnimFrame > 0)) && (GetAnimGroup(AnimSequence) != 'Landing') )
				{
					if ( Acceleration != vect(0,0,0) )
					{
						if ( (GetAnimGroup(AnimSequence) == 'Waiting') || (GetAnimGroup(AnimSequence) == 'Gesture') || (GetAnimGroup(AnimSequence) == 'TakeHit') )
						{
							bAnimTransition = true;
							TweenToRunning(0.1);
						}
					}
			 		else if ( (Velocity.X * Velocity.X + Velocity.Y * Velocity.Y < 1000)
						&& (GetAnimGroup(AnimSequence) != 'Gesture') )
			 		{
			 			if ( GetAnimGroup(AnimSequence) == 'Waiting' )
			 			{
							if ( bIsTurning && (AnimFrame >= 0) )
							{
								bAnimTransition = true;
								PlayTurning();
							}
						}
			 			else if ( !bIsTurning )
						{
							bAnimTransition = true;
							TweenToWaiting(0.2);
						}
					}
				}
			}
			else
			{
				if ( (OldAccel == vect(0,0,0)) && (Acceleration != vect(0,0,0)) )
					PlayCrawling();
			 	else if ( !bIsTurning && (Acceleration == vect(0,0,0)) && (AnimFrame > 0.1) )
					PlayDuck();
			}
		}
	}
}

state Interpolating
{
    event PlayerTick(float deltaTime)
	{
        CheckHunger(deltaTime);

		Super.PlayerTick(deltaTime);
	}
}

// ----------------------------------------------------------------------
// Landed()
//
// copied from Engine.PlayerPawn new landing code for Deus Ex
// zero damage if falling from 15 feet or less
// scaled damage from 15 to 60 feet
// death over 60 feet
// ----------------------------------------------------------------------

function Landed(vector HitNormal)
{
    local vector legLocation;
	local int augLevel;
	local float augReduce, dmg;

    if(bResetRunSilent)
    {
        RunSilentValue = 1.0;
        bResetRunSilent = false;
    }

	//Note - physics changes type to PHYS_Walking by default for landed pawns
	PlayLanded(Velocity.Z);
	if (Velocity.Z < -1.4 * JumpZ)
	{
		MakeNoise(-0.5 * Velocity.Z/(FMax(JumpZ, 150.0)));
		if ((Velocity.Z < -700) && (ReducedDamageType != 'All'))
			if ( Role == ROLE_Authority )
            {
				// check our jump augmentation and reduce falling damage if we have it
				// jump augmentation doesn't exist anymore - use Speed instaed
				// reduce an absolute amount of damage instead of a relative amount
				augReduce = 0;
				if (AugmentationSystem != None)
				{
					augLevel = FMax(AugmentationSystem.GetClassLevel(class'AugSpeed'),AugmentationSystem.GetClassLevel(class'AugQuadruped'));
					if (augLevel >= 0)
						augReduce = 15 * (augLevel+1);
				}

				dmg = Max((-0.16 * (Velocity.Z + 700)) - augReduce, 0);
				legLocation = Location + vect(-1,0,-1);			// damage left leg
				TakeDamage(dmg, None, legLocation, vect(0,0,0), 'fell');

				legLocation = Location + vect(1,0,-1);			// damage right leg
				TakeDamage(dmg, None, legLocation, vect(0,0,0), 'fell');

				dmg = Max((-0.06 * (Velocity.Z + 700)) - augReduce, 0);
				legLocation = Location + vect(0,0,1);			// damage torso
				TakeDamage(dmg, None, legLocation, vect(0,0,0), 'fell');
            }
	}
	else if ( (Level.Game != None) && (Level.Game.Difficulty > 1) && (Velocity.Z > 0.5 * JumpZ) )
		MakeNoise(0.1 * Level.Game.Difficulty);
	bJustLanded = true;
}


// ----------------------------------------------------------------------
// HandleWalking()
//
// subclassed from PlayerPawn so we can control run/walk defaults
// ----------------------------------------------------------------------

function HandleWalking()
{
    Super.HandleWalking();
    if(AugmentationSystem.GetAugLevelValue(class'AugQuadruped') > 0)
    {
        bIsCrouching = false;
    }

 	//GroundSpeed *= 1.8;
 	/*
	if (bToggleCrouch)
	{
    	GroundSpeed *= 1.8;
    	JumpZ *= 1.8;
    	if ( Level.NetMode != NM_Standalone )
    	{
            UpdateAnimRate( 300 );
    	}
    }
*/

}

// ----------------------------------------------------------------------
// DoJump()
//
// copied from Engine.PlayerPawn
// Modified to let you jump if you are carrying something rather light
// You can also jump if you are crouching, just at a much lower height
// ----------------------------------------------------------------------

function DoJump( optional float F )
{
	local DeusExWeapon w;
	local float scaleFactor, augLevel;

	if ((CarriedDecoration != None) && (CarriedDecoration.Mass > 20))
		return;
	else if (bForceDuck || IsLeaning())
		return;

	if (Physics == PHYS_Walking)
	{
		if ( Role == ROLE_Authority )
			PlaySound(JumpSound, SLOT_None, 1.5, true, 1200, 1.0 - 0.2*FRand() );
		if ( (Level.Game != None) && (Level.Game.Difficulty > 0) )
		{
		    //silent leap when in quadruped to sneak up
		    if(!(AugmentationSystem.GetAugLevelValue(class'AugQuadruped') > 0))
			    MakeNoise(0.1 * Level.Game.Difficulty);
		}
		PlayInAir();

        //leap
        if(AugmentationSystem.GetAugLevelValue(class'AugQuadruped') > 0)
        {
       	    if ( Level.TimeSeconds - LastLeapTime > 1.0 )
       	    {
  		        //silent leap when in quadruped to sneak up
       	        RunSilentValue=0.0;
       	        bResetRunSilent=true;
       	        //SetPhysics(PHYS_Falling);
                Velocity = Vector(ViewRotation)*(450+(AugmentationSystem.GetClassLevel(class'AugQuadruped')*150));
                Velocity.Z += 200;
                LastLeapTime = Level.TimeSeconds;
            }
		    //Velocity.Z = JumpZ;

        }
        else
        {
            Velocity.Z = JumpZ;
    		if ( Level.NetMode != NM_Standalone )
    		{
             if (AugmentationSystem == None)
                augLevel = -1.0;
             else
                augLevel = AugmentationSystem.GetAugLevelValue(class'AugSpeed');
    			w = DeusExWeapon(InHand);
    			if ((augLevel != -1.0) && ( w != None ) && ( w.Mass > 30.0))
    			{
    				scaleFactor = 1.0 - FClamp( ((w.Mass - 30.0)/55.0), 0.0, 0.5 );
    				Velocity.Z *= scaleFactor;
    			}
    		}
		}

		// reduce the jump velocity if you are crouching
//		if (bIsCrouching)
//			Velocity.Z *= 0.9;

		if ( Base != Level )
			Velocity.Z += Base.Velocity.Z;
		SetPhysics(PHYS_Falling);
		if ( bCountJumps && (Role == ROLE_Authority) )
			Inventory.OwnerJumped();
	}
}

// ----------------------------------------------------------------------
// PlayFootStep()
//
// plays footstep sounds based on the texture group
// yes, I know this looks nasty -- I'll have to figure out a cleaner
// way to do this
// ----------------------------------------------------------------------

simulated function PlayFootStep()
{
	local Sound stepSound;
	local float rnd;
	local float speedFactor, massFactor;
	local float volume, pitch, range;
	local float radius, mult;
	local float volumeMultiplier;
	local DeusExPlayer pp;
	local bool bOtherPlayer;

	// Only do this on ourself, since this takes into account aug stealth and such
	if ( Level.NetMode != NM_StandAlone )
		pp = DeusExPlayer( GetPlayerPawn() );

	if ( pp != Self )
		bOtherPlayer = True;
	else
		bOtherPlayer = False;

	rnd = FRand();

	volumeMultiplier = 1.0;
	if (IsInState('PlayerSwimming') || (Physics == PHYS_Swimming))
	{
		volumeMultiplier = 0.5;
		if (rnd < 0.5)
			stepSound = Sound'Swimming';
		else
			stepSound = Sound'Treading';
	}
	else if (FootRegion.Zone.bWaterZone)
	{
		volumeMultiplier = 1.0;
		if (rnd < 0.33)
			stepSound = Sound'WaterStep1';
		else if (rnd < 0.66)
			stepSound = Sound'WaterStep2';
		else
			stepSound = Sound'WaterStep3';
	}
	else if(AugmentationSystem.GetAugLevelValue(class'AugQuadruped') > 0)
	{
        stepSound = Sound'DXModSounds.Misc.Gallop';
        volumeMultiplier = 1.0;
	}
	else{
		switch(FloorMaterial)
		{
			case 'Textile':
			case 'Paper':
				volumeMultiplier = 0.7;
				if (rnd < 0.25)
					stepSound = Sound'CarpetStep1';
				else if (rnd < 0.5)
					stepSound = Sound'CarpetStep2';
				else if (rnd < 0.75)
					stepSound = Sound'CarpetStep3';
				else
					stepSound = Sound'CarpetStep4';
				break;

			case 'Foliage':
			case 'Earth':
				volumeMultiplier = 0.6;
				if (rnd < 0.25)
					stepSound = Sound'GrassStep1';
				else if (rnd < 0.5)
					stepSound = Sound'GrassStep2';
				else if (rnd < 0.75)
					stepSound = Sound'GrassStep3';
				else
					stepSound = Sound'GrassStep4';
				break;

			case 'Metal':
			case 'Ladder':
				volumeMultiplier = 1.0;
				if (rnd < 0.25)
					stepSound = Sound'MetalStep1';
				else if (rnd < 0.5)
					stepSound = Sound'MetalStep2';
				else if (rnd < 0.75)
					stepSound = Sound'MetalStep3';
				else
					stepSound = Sound'MetalStep4';
				break;

			case 'Ceramic':
			case 'Glass':
			case 'Tiles':
				volumeMultiplier = 0.7;
				if (rnd < 0.25)
					stepSound = Sound'TileStep1';
				else if (rnd < 0.5)
					stepSound = Sound'TileStep2';
				else if (rnd < 0.75)
					stepSound = Sound'TileStep3';
				else
					stepSound = Sound'TileStep4';
				break;

			case 'Wood':
				volumeMultiplier = 0.7;
				if (rnd < 0.25)
					stepSound = Sound'WoodStep1';
				else if (rnd < 0.5)
					stepSound = Sound'WoodStep2';
				else if (rnd < 0.75)
					stepSound = Sound'WoodStep3';
				else
					stepSound = Sound'WoodStep4';
				break;

			case 'Brick':
			case 'Concrete':
			case 'Stone':
			case 'Stucco':
			default:
				volumeMultiplier = 0.7;
				if (rnd < 0.25)
					stepSound = Sound'StoneStep1';
				else if (rnd < 0.5)
					stepSound = Sound'StoneStep2';
				else if (rnd < 0.75)
					stepSound = Sound'StoneStep3';
				else
					stepSound = Sound'StoneStep4';
				break;
		}
	}

	// compute sound volume, range and pitch, based on mass and speed
	if (IsInState('PlayerSwimming') || (Physics == PHYS_Swimming))
		speedFactor = WaterSpeed/180.0;
	else
		speedFactor = VSize(Velocity)/180.0;

	massFactor  = Mass/150.0;
	radius      = 375.0;
	volume      = (speedFactor+0.2) * massFactor;
	range       = radius * volume;
	pitch       = (volume+0.5);
	volume      = FClamp(volume, 0, 1.0) * 0.5;		// Hack to compensate for increased footstep volume.
	range       = FClamp(range, 0.01, radius*4);
	pitch       = FClamp(pitch, 1.0, 1.5);

	// AugStealth decreases our footstep volume
	volume *= RunSilentValue;

	if ( Level.NetMode == NM_Standalone )
	{
    	if(AugmentationSystem.GetAugLevelValue(class'AugQuadruped') > 0)
    	    PlaySound(stepSound, SLOT_Interact, volume, , range); //pitch);
        else
	    	PlaySound(stepSound, SLOT_Interact, volume, , range, pitch);
	}
    else	// special case for multiplayer
	{
		if ( !bIsWalking )
		{
			// Tone down player's own footsteps
			if ( !bOtherPlayer )
			{
				volume *= 0.33;
				if(AugmentationSystem.GetAugLevelValue(class'AugQuadruped') > 0)
				    PlaySound(stepSound, SLOT_Interact, volume, , range); //pitch);
                else
                    PlaySound(stepSound, SLOT_Interact, volume, , range, pitch);
			}
			else // Exagerate other players sounds (range slightly greater than distance you see with vision aug)
			{
				volume *= 2.0;
				range = (class'AugVision'.Default.mpAugValue * 1.2);
				volume = FClamp(volume, 0, 1.0);
				if(AugmentationSystem.GetAugLevelValue(class'AugQuadruped') > 0)
				    PlaySound(stepSound, SLOT_Interact, volume, , range); //pitch);
                else
			    	PlaySound(stepSound, SLOT_Interact, volume, , range, pitch);
			}
		}
	}
	AISendEvent('LoudNoise', EAITYPE_Audio, volume*volumeMultiplier, range*volumeMultiplier);
}

// ----------------------------------------------------------------------
// TakeDamage()
// ----------------------------------------------------------------------

function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, name damageType)
{
	local int actualDamage;
	local bool bAlreadyDead, bPlayAnim, bDamageGotReduced;
	local Vector offset, dst;
	local float headOffsetZ, headOffsetY, armOffset;
	local float origHealth, fdst;
	local DeusExLevelInfo info;
	local DeusExWeapon dxw;
	local String bodyString;
	local int MPHitLoc;

	if ( bNintendoImmunity )
		return;

	bodyString = "";
	origHealth = Health;

   if (Level.NetMode != NM_Standalone)
      Damage *= MPDamageMult;

	// use the hitlocation to determine where the pawn is hit
	// transform the worldspace hitlocation into objectspace
	// in objectspace, remember X is front to back
	// Y is side to side, and Z is top to bottom
	offset = (hitLocation - Location) << Rotation;

	// add a HUD icon for this damage type
	if ((damageType == 'Poison') || (damageType == 'PoisonEffect'))  // hack
		AddDamageDisplay('PoisonGas', offset);
	else
		AddDamageDisplay(damageType, offset);

	// nanovirus damage doesn't affect us
	if (damageType == 'NanoVirus')
		return;

	// handle poison
	if ((damageType == 'Poison') || ((Level.NetMode != NM_Standalone) && (damageType=='TearGas')) )
	{
		// Notify player if they're getting burned for the first time
		if ( Level.NetMode != NM_Standalone )
			ServerConditionalNotifyMsg( MPMSG_FirstPoison );

		StartPoison( instigatedBy, Damage );
	}

	// reduce our damage correctly
	if (ReducedDamageType == damageType)
		actualDamage = float(actualDamage) * (1.0 - ReducedDamagePct);

	// check for augs or inventory items
	bDamageGotReduced = DXReduceDamage(Damage, damageType, hitLocation, actualDamage, False);

   // DEUS_EX AMSD Multiplayer shield
   if (Level.NetMode != NM_Standalone)
      if (bDamageGotReduced)
      {
         ShieldStatus = SS_Strong;
         ShieldTimer = 1.0;
      }

	if (ReducedDamageType == 'All') //God mode
		actualDamage = 0;

	// Multiplayer only code
	if ( Level.NetMode != NM_Standalone )
	{
		if ( ( instigatedBy != None ) && (instigatedBy.IsA('DeusExPlayer')) )
		{
			// Special case the sniper rifle
			if ((DeusExPlayer(instigatedBy).Weapon != None) && ( DeusExPlayer(instigatedBy).Weapon.class == class'WeaponRifle' ))
			{
				dxw = DeusExWeapon(DeusExPlayer(instigatedBy).Weapon);
				if ( (dxw != None ) && ( !dxw.bZoomed ))
					actualDamage *= WeaponRifle(dxw).mpNoScopeMult; // Reduce damage if we're not using the scope
			}
			if ( (TeamDMGame(DXGame) != None) && (TeamDMGame(DXGame).ArePlayersAllied(DeusExPlayer(instigatedBy),Self)) )
			{
				// Don't notify if the player hurts themselves
				if ( DeusExPlayer(instigatedBy) != Self )
				{
					actualDamage *= TeamDMGame(DXGame).fFriendlyFireMult;
					if (( damageType != 'TearGas' ) && ( damageType != 'PoisonEffect' ))
						DeusExPlayer(instigatedBy).MultiplayerNotifyMsg( MPMSG_TeamHit );
				}
			}

		}
	}

	// EMP attacks drain BE energy
	if (damageType == 'EMP')
	{
		EnergyDrain += actualDamage;
		EnergyDrainTotal += actualDamage;
		PlayTakeHitSound(actualDamage, damageType, 1);
		return;
	}

	bPlayAnim = True;

	// if we're burning, don't play a hit anim when taking burning damage
	if (damageType == 'Burned')
		bPlayAnim = False;

	if (Physics == PHYS_None)
		SetMovementPhysics();
	if (Physics == PHYS_Walking)
		momentum.Z = 0.4 * VSize(momentum);
	if ( instigatedBy == self )
		momentum *= 0.6;
	momentum = momentum/Mass;
	//	AddVelocity( momentum ); 	// doesn't do anything anyway

	// calculate our hit extents
	headOffsetZ = CollisionHeight * 0.78;
	headOffsetY = CollisionRadius * 0.35;
	armOffset = CollisionRadius * 0.35;

	// We decided to just have 3 hit locations in multiplayer MBCODE
	if (( Level.NetMode == NM_DedicatedServer ) || ( Level.NetMode == NM_ListenServer ))
	{
		MPHitLoc = GetMPHitLocation(HitLocation);

		if (MPHitLoc == 0)
			return;
		else if (MPHitLoc == 1 )
		{
			// MP Headshot is 2x damage
			// narrow the head region
			actualDamage *= 2;
			HealthHead -= actualDamage;
			bodyString = HeadString;
			if (bPlayAnim)
				PlayAnim('HitHead', , 0.1);
		}
		else if ((MPHitLoc == 3) || (MPHitLoc == 4))	// Leg region
		{
			HealthLegRight -= actualDamage;
			HealthLegLeft -= actualDamage;

			if (MPHitLoc == 4)
			{
				if (bPlayAnim)
					PlayAnim('HitLegRight', , 0.1);
			}
			else if (MPHitLoc == 3)
			{
				if (bPlayAnim)
					PlayAnim('HitLegLeft', , 0.1);
			}
			// Since the legs are in sync only bleed up damage from one leg (otherwise it's double damage)
			if (HealthLegLeft < 0)
			{
				HealthArmRight += HealthLegLeft;
				HealthTorso += HealthLegLeft;
				HealthArmLeft += HealthLegLeft;
				bodyString = TorsoString;
				HealthLegLeft = 0;
				HealthLegRight = 0;
			}
		}
		else // arms and torso now one region
		{
			HealthArmLeft -= actualDamage;
			HealthTorso -= actualDamage;
			HealthArmRight -= actualDamage;

			bodyString = TorsoString;

			if (MPHitLoc == 6)
			{
				if (bPlayAnim)
					PlayAnim('HitArmRight', , 0.1);
			}
			else if (MPHitLoc == 5)
			{
				if (bPlayAnim)
					PlayAnim('HitArmLeft', , 0.1);
			}
			else
			{
				if (bPlayAnim)
					PlayAnim('HitTorso', , 0.1);
			}
		}
	}
	else // Normal damage code path for single player
	{
		if (offset.z > headOffsetZ)		// head
		{
			// narrow the head region
			if ((Abs(offset.x) < headOffsetY) || (Abs(offset.y) < headOffsetY))
			{
				HealthHead -= actualDamage * 2;
				if (bPlayAnim)
					PlayAnim('HitHead', , 0.1);
			}
		}
		else if (offset.z < 0.0)	// legs
		{
			if (offset.y > 0.0)
			{
				HealthLegRight -= actualDamage;
				if (bPlayAnim)
					PlayAnim('HitLegRight', , 0.1);
			}
			else
			{
				HealthLegLeft -= actualDamage;
				if (bPlayAnim)
					PlayAnim('HitLegLeft', , 0.1);
			}

 			// if this part is already dead, damage the adjacent part
			if ((HealthLegRight < 0) && (HealthLegLeft > 0))
			{
				HealthLegLeft += HealthLegRight;
				HealthLegRight = 0;
			}
			else if ((HealthLegLeft < 0) && (HealthLegRight > 0))
			{
				HealthLegRight += HealthLegLeft;
				HealthLegLeft = 0;
			}

			if (HealthLegLeft < 0)
			{
				HealthTorso += HealthLegLeft;
				HealthLegLeft = 0;
			}
			if (HealthLegRight < 0)
			{
				HealthTorso += HealthLegRight;
				HealthLegRight = 0;
			}
		}
		else						// arms and torso
		{
			if (offset.y > armOffset)
			{
				HealthArmRight -= actualDamage;
				if (bPlayAnim)
					PlayAnim('HitArmRight', , 0.1);
			}
			else if (offset.y < -armOffset)
			{
				HealthArmLeft -= actualDamage;
				if (bPlayAnim)
					PlayAnim('HitArmLeft', , 0.1);
			}
			else
			{
				HealthTorso -= actualDamage * 2;
				if (bPlayAnim)
					PlayAnim('HitTorso', , 0.1);
			}

			// if this part is already dead, damage the adjacent part
			if (HealthArmLeft < 0)
			{
				HealthTorso += HealthArmLeft;
				HealthArmLeft = 0;
			}
			if (HealthArmRight < 0)
			{
				HealthTorso += HealthArmRight;
				HealthArmRight = 0;
			}
		}
	}

	// check for a back hit and play the correct anim
	if ((offset.x < 0.0) && bPlayAnim)
	{
		if (offset.z > headOffsetZ)		// head from the back
		{
			// narrow the head region
			if ((Abs(offset.x) < headOffsetY) || (Abs(offset.y) < headOffsetY))
				PlayAnim('HitHeadBack', , 0.1);
		}
		else
			PlayAnim('HitTorsoBack', , 0.1);
	}

	// check for a water hit
	if (Region.Zone.bWaterZone)
	{
		if ((offset.x < 0.0) && bPlayAnim)
			PlayAnim('WaterHitTorsoBack',,0.1);
		else
			PlayAnim('WaterHitTorso',,0.1);
	}

	GenerateTotalHealth();

	if ((damageType != 'Stunned') && (damageType != 'TearGas') && (damageType != 'HalonGas') &&
	    (damageType != 'PoisonGas') && (damageType != 'Radiation') && (damageType != 'EMP') &&
	    (damageType != 'NanoVirus') && (damageType != 'Drowned') && (damageType != 'KnockedOut'))
		bleedRate += (origHealth-Health)/30.0;  // 30 points of damage = bleed profusely

	if (CarriedDecoration != None)
		DropDecoration();

	// don't let the player die in the training mission
	info = GetLevelInfo();
	if ((info != None) && (info.MissionNumber == 0))
	{
		if (Health <= 0)
		{
			HealthTorso = FMax(HealthTorso, 10);
			HealthHead = FMax(HealthHead, 10);
			GenerateTotalHealth();
		}
	}

	if (Health > 0)
	{
		if ((Level.NetMode != NM_Standalone) && (HealthLegLeft==0) && (HealthLegRight==0))
			ServerConditionalNotifyMsg( MPMSG_LostLegs );

		if (instigatedBy != None)
			damageAttitudeTo(instigatedBy);
        PlayDXTakeDamageHit(actualDamage, hitLocation, damageType, momentum, bDamageGotReduced);
		AISendEvent('Distress', EAITYPE_Visual);
	}
	else
	{
		NextState = '';
		PlayDeathHit(actualDamage, hitLocation, damageType, momentum);
		if ( Level.NetMode != NM_Standalone )
			CreateKillerProfile( instigatedBy, actualDamage, damageType, bodyString );
		if ( actualDamage > mass )
			Health = -1 * actualDamage;
		Enemy = instigatedBy;
		Died(instigatedBy, damageType, HitLocation);
		return;
	}
	//if(DamageType != 'PoisonEffect')
	//    MakeNoise(1.0);

	if ((DamageType == 'Flamed') && !bOnFire)
	{
		// Notify player if they're getting burned for the first time
		if ( Level.NetMode != NM_Standalone )
			ServerConditionalNotifyMsg( MPMSG_FirstBurn );

		CatchFire( instigatedBy );
	}
	myProjKiller = None;
}

//-----------------------------------------------------------------------------
// Sound functions
function PlayTakeHitSound(int Damage, name damageType, int Mult)
{
    local int soundr;

    if( damageType == 'PoisonEffect')
        soundr = 1;
    else
        soundr = Mult * 2.0;

	if ( Level.TimeSeconds - LastPainSound < 0.25 )
		return;

	if (HitSound1 == None)return;
	LastPainSound = Level.TimeSeconds;
	if (FRand() < 0.5)
		PlaySound(HitSound1, SLOT_Pain, FMax(Mult * TransientSoundVolume, soundr));
	else
		PlaySound(HitSound2, SLOT_Pain, FMax(Mult * TransientSoundVolume, soundr));
}

function CheckHunger(float deltaTime)
{
    if(FasFoodTimer > 0)
    {
       FasFoodTimer -= 1;
       if(FasFoodTimer <= 0)
       {
           FasFoodTimer = 0;
           BurnCalories(50);
           ClientMessage("FasFood Wore Off!");
       }
    }

    if(Calories < 25)
    {
        HungerTime += deltaTime;
        if(HungerTime >= 20)
        {
            if(Calories <= 0) //totally starving
                TakeDamage(15, none, Location, vect(0,0,0), 'PoisonEffect');
            else
                TakeDamage(2, none, Location, vect(0,0,0), 'PoisonEffect');
            HungerTime = 0;
            ClientMessage("You are starving - FIND FOOD!");
        }
    }

}

function EatFood(int numFood)
{
    local Actor A;
    local DeusExGoal goal;
    Calories += numFood;
    if( Calories > 100 )
    {
        Calories = 100;
        ClientMessage("You are stuffed! ( +" $ numFood*100 $ " Calories )");
    }
    else if( Calories > 25 )
    {
        ClientMessage("You are no longer hungry. ( +" $ numFood*100 $ " Calories )");
  		// HACKY completing the hunger goal in Eating code.
		goal = FindGoal('TheNakedLunch');

		if (goal != none && !goal.bCompleted){

			GoalCompleted('TheNakedLunch');
    		SkillPointsAdd(300);
    		ClientMessage("THE NAKED LUNCH Completed!");
   			// Trigger finished naked lunch
			foreach AllActors(class 'Actor', A, 'nakedlunchdone')
				A.Trigger(Self, Self);

			flagBase.SetBool('DistressStarted', true);
 		}
    }
    else
    {
        ClientMessage("You are still hungry - find more food. ( +" $ numFood*100 $ " Calories )");
    }
	foreach AllActors(class 'Actor', A, 'atefood')
		A.Trigger(Self, Self);
}

function BurnCalories(float numFood)
{
    Calories -= numFood;
    if( Calories > 100 )
    {
        Calories = 100;
    }
    else if( Calories > 25 )
    {
       // ClientMessage("You burned some calories, but you're ok.");
    }
    else
    {
       // ClientMessage("You are starving, find food!");
    }
    if( Calories < 0 )
        Calories = 0;
}

function BurnFood(int numFood)
{
    local Actor A;
    local DeusExGoal goal;
    Calories -= numFood;
    if( Calories > 100 )
    {
        Calories = 100;
        ClientMessage("You had a workout but you're fine");
    }
    else if( Calories > 25 )
    {
        ClientMessage("You burned some calories, but you're ok.");
  		// HACKY completing the hunger goal in Eating code.
	/*	goal = FindGoal('TheNakedLunch');

		if (goal != none && !goal.bCompleted){

			GoalCompleted('TheNakedLunch');
    		SkillPointsAdd(300);
    		ClientMessage("THE NAKED LUNCH Completed!");
   			// Trigger finished naked lunch
			foreach AllActors(class 'Actor', A, 'nakedlunchdone')
				A.Trigger(Self, Self);
 		}   */
    }
    else
    {
        ClientMessage("You are starving, find food!");
    }
    if( Calories < 0 )
        Calories = 0;
}

// ----------------------------------------------------------------------
// StartConversation()
//
// Checks to see if a valid conversation exists for this moment in time
// between the ScriptedPawn and the PC.  If so, then it triggers the
// conversation system and returns TRUE when finished.
// ----------------------------------------------------------------------

//Changes: spawn ModConPlay instead of ConPlay

function bool StartConversation(
	Actor invokeActor,
	EInvokeMethod invokeMethod,
	optional Conversation con,
	optional bool bAvoidState,
	optional bool bForcePlay
	)
{
	local DeusExRootWindow root;

	root = DeusExRootWindow(rootWindow);

	// First check to see the actor has any conversations or if for some
	// other reason we're unable to start a conversation (typically if
	// we're alread in a conversation or there's a UI screen visible)

	if ((!bForcePlay) && ((invokeActor.conListItems == None) || (!CanStartConversation())))
		return False;

	// Make sure the other actor can converse
	if ((!bForcePlay) && ((ScriptedPawn(invokeActor) != None) && (!ScriptedPawn(invokeActor).CanConverse())))
		return False;

	// If we have a conversation passed in, use it.  Otherwise check to see
	// if the passed in actor actually has a valid conversation that can be
	// started.

	if ( con == None )
		con = GetActiveConversation(invokeActor, invokeMethod);

	// If we have a conversation, put the actor into "Conversation Mode".
	// Otherwise just return false.
	//
	// TODO: Scan through the conversation and put *ALL* actors involved
	//       in the conversation into the "Conversation" state??

	if ( con != None )
	{
		// Check to see if this conversation is already playing.  If so,
		// then don't start it again.  This prevents a multi-bark conversation
		// from being abused.
		if ((conPlay != None) && (conPlay.con == con))
			return False;

		// Now check to see if there's a conversation playing that is owned
		// by the InvokeActor *and* the player has a speaking part *and*
		// it's a first-person convo, in which case we want to abort here.
		if (((conPlay != None) && (conPlay.invokeActor == invokeActor)) &&
		    (conPlay.con.bFirstPerson) &&
			(conPlay.con.IsSpeakingActor(Self)))
			return False;

		// Check if the person we're trying to start the conversation
		// with is a Foe and this is a Third-Person conversation.
		// If so, ABORT!
		if ((!bForcePlay) && ((!con.bFirstPerson) && (ScriptedPawn(invokeActor) != None) && (ScriptedPawn(invokeActor).GetPawnAllianceType(Self) == ALLIANCE_Hostile)))
			return False;

		// If the player is involved in this conversation, make sure the
		// scriptedpawn even WANTS to converse with the player.
		//
		// I have put a hack in here, if "con.bCanBeInterrupted"
		// (which is no longer used as intended) is set, then don't
		// call the ScriptedPawn::CanConverseWithPlayer() function

		if ((!bForcePlay) && ((con.IsSpeakingActor(Self)) && (!con.bCanBeInterrupted) && (ScriptedPawn(invokeActor) != None) && (!ScriptedPawn(invokeActor).CanConverseWithPlayer(Self))))
			return False;

		// Hack alert!  If this is a Bark conversation (as denoted by the
		// conversation name, since we don't have a field in ConEdit),
		// then force this conversation to be first-person
		if (Left(con.conName, Len(con.conOwnerName) + 5) == (con.conOwnerName $ "_Bark"))
			con.bFirstPerson = True;

		// Make sure the player isn't ducking.  If the player can't rise
		// to start a third-person conversation (blocked by geometry) then
		// immediately abort the conversation, as this can create all
		// sorts of complications (such as the player standing through
		// geometry!!)

		if ((!con.bFirstPerson) && (ResetBasedPawnSize() == False))
			return False;

		// If ConPlay exists, end the current conversation playing
		if (conPlay != None)
		{
			// If we're already playing a third-person conversation, don't interrupt with
			// another *radius* induced conversation (frobbing is okay, though).
			if ((conPlay.con != None) && (conPlay.con.bFirstPerson) && (invokeMethod == IM_Radius))
				return False;

			conPlay.InterruptConversation();
			conPlay.TerminateConversation();
		}

		// If this is a first-person conversation _and_ a DataLink is already
		// playing, then abort.  We don't want to give the user any more
		// distractions while a DL is playing, since they're pretty important.
		if ( dataLinkPlay != None )
		{
			if (con.bFirstPerson)
				return False;
			else
				dataLinkPlay.AbortAndSaveHistory();
		}

		// Found an active conversation, so start it
		conPlay = Spawn(class'ModConPlay');//Spawn(class'ConPlay');
		conPlay.SetStartActor(invokeActor);
		conPlay.SetConversation(con);
		conPlay.SetForcePlay(bForcePlay);
		conPlay.SetInitialRadius(VSize(Location - invokeActor.Location));

		// If this conversation was invoked with IM_Named, then save away
		// the current radius so we don't abort until we get outside
		// of this radius + 100.
		if ((invokeMethod == IM_Named) || (invokeMethod == IM_Frob))
		{
			conPlay.SetOriginalRadius(con.radiusDistance);
			con.radiusDistance = VSize(invokeActor.Location - Location);
		}

		// If the invoking actor is a ScriptedPawn, then force this person
		// into the conversation state
		if ((!bForcePlay) && (ScriptedPawn(invokeActor) != None ))
			ScriptedPawn(invokeActor).EnterConversationState(con.bFirstPerson, bAvoidState);

		// Do the same if this is a DeusExDecoration
		if ((!bForcePlay) && (DeusExDecoration(invokeActor) != None ))
			DeusExDecoration(invokeActor).EnterConversationState(con.bFirstPerson, bAvoidState);

		// If this is a third-person convo, we're pretty much going to
		// pause the game.  If this is a first-person convo, then just
		// keep on going..
		//
		// If this is a third-person convo *AND* 'bForcePlay' == True,
		// then use first-person mode, as we're playing an intro/endgame
		// sequence and we can't have the player in the convo state (bad bad bad!)

		if ((!con.bFirstPerson) && (!bForcePlay))
		{
			GotoState('Conversation');
		}
		else
		{
			if (!conPlay.StartConversation(Self, invokeActor, bForcePlay))
			{
				AbortConversation(True);
			}
		}

		MakeFaceLight();

		return True;
	}
	else
	{
		return False;
	}
}

// ----------------------------------------------------------------------
// EndConversation()
//
// Called by ConPlay when a conversation has finished.
// ----------------------------------------------------------------------

function EndConversation()
{
    DestroyFaceLight();
    Super.EndConversation();
}

// ----------------------------------------------------------------------
// DrugEffects()    Add EMPEffects here
// ----------------------------------------------------------------------

simulated function DrugEffects(float deltaTime)
{
	local float mult, fov;
	local Rotator rot;
	local DeusExRootWindow root;

	root = DeusExRootWindow(rootWindow);

	// random wandering and swaying when drugged
	if (drugEffectTimer > 0)
	{
	    if( bEMPFX )
	    {
     		if ((root != None) && (root.hud != None))
    		{
    			if (root.hud.background == None)
    			{
    				root.hud.SetBackground(Texture'Effects.Electricity.Wepn_Prod_FX');
    				root.hud.SetBackgroundSmoothing(True);
    				root.hud.SetBackgroundStretching(True);
    				root.hud.SetBackgroundStyle(DSTY_Translucent);//(DSTY_Modulated);
    			}
    		}
	    }
	    else
	    {
     		if ((root != None) && (root.hud != None))
    		{
    			if (root.hud.background == None)
    			{
    				root.hud.SetBackground(Texture'DrunkFX');
    				root.hud.SetBackgroundSmoothing(True);
    				root.hud.SetBackgroundStretching(True);
    				root.hud.SetBackgroundStyle(DSTY_Modulated);
    			}
    		}

    		mult = FClamp(drugEffectTimer / 10.0, 0.0, 3.0);
    		rot.Pitch = 1024.0 * Cos(Level.TimeSeconds * mult) * deltaTime * mult;
    		rot.Yaw = 1024.0 * Sin(Level.TimeSeconds * mult) * deltaTime * mult;
    		rot.Roll = 0;

    		rot.Pitch = FClamp(rot.Pitch, -4096, 4096);
    		rot.Yaw = FClamp(rot.Yaw, -4096, 4096);

    		ViewRotation += rot;

    		if ( Level.NetMode == NM_Standalone )
    		{
    			fov = Default.DesiredFOV - drugEffectTimer + Rand(2);
    			fov = FClamp(fov, 30, Default.DesiredFOV);
    			DesiredFOV = fov;
    		}
    		else
    			DesiredFOV = Default.DesiredFOV;
	    }


		drugEffectTimer -= deltaTime;
		if (drugEffectTimer < 0)
			drugEffectTimer = 0;
	}
	else
	{
		if ((root != None) && (root.hud != None))
		{
			if (root.hud.background != None)
			{
				root.hud.SetBackground(None);
				root.hud.SetBackgroundStyle(DSTY_Normal);
				if(!bEMPFX)
				    DesiredFOV = Default.DesiredFOV;
			}
		}
	}
}

// ----------------------------------------------------------------------
// InvokeUIScreen()
//
// Calls DeusExRootWindow::InvokeUIScreen(), but first make sure
// a modifier (Alt, Shift, Ctrl) key isn't being held down.
// ----------------------------------------------------------------------

function InvokeUIScreen(Class<DeusExBaseWindow> windowClass)
{
	local DeusExRootWindow root;
	root = DeusExRootWindow(rootWindow);
		//self.ClientMessage("SHOPTRIGGER");
	if (root != None)
	{
		if ( root.IsKeyDown( IK_Alt ) || root.IsKeyDown( IK_Shift ) || root.IsKeyDown( IK_Ctrl ))
			return;

		root.InvokeUIScreen(windowClass);
	}

}

function ShowShop(ShopTrigger s)
 {
 	//self.ClientMessage("SHOPTRIGGER");
    shop=s;
    InvokeUIScreen(class'DXMod.ShopInterface');
 }

 exec function nohcamtest()
 {
     self.AugmentationSystem.FindAugmentation(class'augdrone').activate();
 }

// this is a temp hack to debug the shop
exec function ShopInterface()
 {
    InvokeUIScreen(class'DXMod.ShopInterface');
 }



function bool GetItem(class<Inventory> inv)
 {
 local inventory i;
 local bool bGotIt;
 i=Spawn(inv);

             //addition
           	//if (Weapon(i) != none) {
			//	HandleItemPickup(i, True);
			//	return true;
			//}
 			if (HandleItemPickup(i, True)==False && !i.IsA('Ammo'))
 				{
 				i.Destroy();
				return false;
				}
			bGotIt=False;

			// if the frob succeeded, put it in the player's inventory
			if (FindInventorySlot(i) && !i.IsA('Ammo'))
				{
				i.Frob(Self,none);
				if (i.Owner==Self)
					bGotIt=True;
				}
			else if (i.IsA('Ammo'))
				{
				i.Frob(Self,none);
				bGotIt=True;
				i=GetWeaponOrAmmo(i);
				if (Ammo(i).AmmoAmount >= Ammo(i).MaxAmmo)
					{
					bGotIt=False;
					i.Destroy();
					}
				}
			else
				i.Destroy();

 if (!bGotIt)
 	return false;
 else
 	{
 	return true;
 	}
 }

 // Opens up the Sell Interface
exec function SellInterface()
 {
    InvokeUIScreen(class'DXMod.ModScreenSell');
 }

 // ----------------------------------------------------------------------
// DXReduceDamage()
//
// Calculates reduced damage from augmentations and from inventory items
// Also calculates a scalar damage reduction based on the mission number
// ----------------------------------------------------------------------
function bool DXReduceDamage(int Damage, name damageType, vector hitLocation, out int adjustedDamage, bool bCheckOnly)
{
	local float newDamage;
	local float augLevel, skillLevel;
	local float pct;
	local HazMatSuit suit;
	local BallisticArmor armor;
	local bool bReduced;

	bReduced = False;
	newDamage = Float(Damage);

	if ((damageType == 'TearGas') || (damageType == 'PoisonGas') || (damageType == 'Radiation') ||
		(damageType == 'HalonGas')  || (damageType == 'PoisonEffect') || (damageType == 'Poison'))
	{
		if (AugmentationSystem != None)
			augLevel = AugmentationSystem.GetAugLevelValue(class'AugEnviro');

		if (augLevel >= 0.0)
			newDamage *= augLevel;

		// get rid of poison if we're maxed out
		if (newDamage ~= 0.0)
		{
			StopPoison();
			drugEffectTimer -= 4;	// stop the drunk effect
			if (drugEffectTimer < 0)
				drugEffectTimer = 0;
		}

		// go through the actor list looking for owned HazMatSuits
		// since they aren't in the inventory anymore after they are used


      //foreach AllActors(class'HazMatSuit', suit)
//			if ((suit.Owner == Self) && suit.bActive)
      if (UsingChargedPickup(class'HazMatSuit'))
			{
				skillLevel = SkillSystem.GetSkillLevelValue(class'SkillEnviro');
				newDamage *= 0.75 * skillLevel;
			}
	}

	if ((damageType == 'Shot') || (damageType == 'Sabot') || (damageType == 'Exploded') || (damageType == 'AutoShot'))
	{
		// go through the actor list looking for owned BallisticArmor
		// since they aren't in the inventory anymore after they are used
      if (UsingChargedPickup(class'BallisticArmor'))
			{
				skillLevel = SkillSystem.GetSkillLevelValue(class'SkillEnviro');
				newDamage *= 0.5 * skillLevel;
			}
        //Trenchcoat deflect
		if (AugmentationSystem != None)
			augLevel = AugmentationSystem.GetAugLevelValue(class'AugTrenchcoat');

		if (augLevel >= 0.0)
		{
			newDamage *= augLevel - (0.1 * SkillSystem.GetSkillLevel(class'SkillEnviro'));
		}
	}

	if (damageType == 'HalonGas')
	{
		if (bOnFire && !bCheckOnly)
			ExtinguishFire();
	}

	if ((damageType == 'Shot') || (damageType == 'AutoShot'))
	{
		if (AugmentationSystem != None)
			augLevel = AugmentationSystem.GetAugLevelValue(class'AugBallistic');

		if (augLevel >= 0.0)
			newDamage *= augLevel;
	}

	if (damageType == 'EMP')
	{
		if (AugmentationSystem != None)
			augLevel = AugmentationSystem.GetAugLevelValue(class'AugEMP');

		if (augLevel >= 0.0)
			newDamage *= augLevel;
	}

	if ((damageType == 'Burned') || (damageType == 'Flamed') ||
		(damageType == 'Exploded') || (damageType == 'Shocked'))
	{
		if (AugmentationSystem != None)
			augLevel = AugmentationSystem.GetAugLevelValue(class'AugShield');

		if (augLevel >= 0.0)
			newDamage *= augLevel;
	}

	if ((damageType == 'Burned') || (damageType == 'Flamed'))
	{
		if (AugmentationSystem != None)
			augLevel = AugmentationSystem.GetAugLevelValue(class'AugThermophile');

		if (augLevel >= 0.0)
			newDamage *= augLevel;
	}

	if (newDamage < Damage)
	{
		if (!bCheckOnly)
		{
			pct = 1.0 - (newDamage / Float(Damage));
			SetDamagePercent(pct);
			ClientFlash(0.01, vect(0, 0, 50));
		}
		bReduced = True;
	}
	else
	{
		if (!bCheckOnly)
			SetDamagePercent(0.0);
	}


	//
	// Reduce or increase the damage based on the combat difficulty setting
	//
	if ((damageType == 'Shot') || (damageType == 'AutoShot'))
	{
		newDamage *= CombatDifficulty;

		// always take at least one point of damage
		if ((newDamage <= 1) && (Damage > 0))
			newDamage = 1;
	}

	adjustedDamage = Int(newDamage);

	return bReduced;
}

// ----------------------------------------------------------------------
// AllEnergy()
// ----------------------------------------------------------------------

exec function AllEnergy()
{
	if (!bCheatsEnabled)
		return;

	Energy = 100;
	Calories = 100;
}

exec function AllAugs()
{
    Super.AllAugs();

	Energy = 100;
	Calories = 100;
}

function GetAirstrike()
{
    local SearcherDestroyer SD;
    //YOU DIE NOW FOOL  - bring the drones
    foreach self.AllActors(class'SearcherDestroyer',SD)
        break;
    //Player.ClientMessage("YOU DIE NOW BITCH");
    if(!SD.IsInState('PreSearching') && !SD.IsInState('Searching') && !SD.IsInState('Destroying'))
        SD.GotoState('PreSearching');
}

// ----------------------------------------------------------------------
// ShowCredits()
// This is stuff for setting up custom end credits
// ----------------------------------------------------------------------

function ShowCredits(optional bool bLoadIntro)
{
    local DeusExRootWindow root;
    local MyCreditsWindow winCredits;

    root = DeusExRootWindow(rootWindow);

    if (root != None)
    {
        // Show the credits screen and force the game not to pause
        // if we're showing the credits after the endgame
        winCredits = MyCreditsWindow(root.InvokeMenuScreen(Class'MyCreditsWindow', bLoadIntro));
        winCredits.SetLoadIntro(bLoadIntro);
    }
}

defaultproperties
{
     ActivateSound=Sound'DeusExSounds.Augmentation.AugActivate'
     DeActivateSound=Sound'DeusExSounds.Augmentation.AugDeactivate'
     PlayerFace=Texture'DXModCharacters.Skins.TMFaceTex'
     PhaceTextures(0)=Texture'DXModCharacters.Skins.TMFaceTex'
     Calories=5.000000
     bWirelessVisible=True
     bMultiCopiesAllowed=True
     SkillPointsAvail=4000
     Credits=0
     Energy=0.000000
     strStartMap="50_t"
     CarcassType=Class'DXMod.ModMaleCarcass'
     bCheatsEnabled=True
     MultiSkins(0)=Texture'DXModCharacters.Skins.TMFaceTex'
     MultiSkins(1)=Texture'DXModCharacters.Skins.TMTex2'
     MultiSkins(2)=Texture'DXModCharacters.Skins.TMTex3'
     MultiSkins(3)=Texture'DXModCharacters.Skins.TMFaceTex'
     MultiSkins(4)=Texture'DXModCharacters.Skins.TMTex1'
     MultiSkins(5)=Texture'DXModCharacters.Skins.TMTex2'
     MultiSkins(6)=Texture'DeusExItems.Skins.GrayMaskTex'
     MultiSkins(7)=Texture'DeusExItems.Skins.BlackMaskTex'
     FamiliarName="Silver Spook"
     UnfamiliarName="Silver Spook"
}
