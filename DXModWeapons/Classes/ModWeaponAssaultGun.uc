//-----------------------------------------------------------
//
//-----------------------------------------------------------
class ModWeaponAssaultGun expands WeaponAssaultGun;

#exec OBJ LOAD FILE=DXModItems


var bool bMultiCopiesAllowed;

function bool HandlePickupQuery(Inventory Item)
{
  local DeusExWeapon W;
  local Pawn PawnOwner;
  local DeusExPlayer player;
  local bool bResult;
  local class<Ammo> defAmmoClass;
  local Ammo defAmmo;
  local int OldAmmo;

  // make sure that if you pick up a modded weapon that you
  // already have, you get the mods
  W = DeusExWeapon(Item);
  if ((W != None) && (W.Class == Class))
  {
      // Borrowed from the Shifter MOD //== We should be able to use multiple copies of single-use weapons
    if(bMultiCopiesAllowed)
    {
      return false; //== Returning false makes it so it'll search for another slot to store a second copy of the weapon
    }

    if (W.ModBaseAccuracy > ModBaseAccuracy)
      ModBaseAccuracy = W.ModBaseAccuracy;
    if (W.ModReloadCount > ModReloadCount)
      ModReloadCount = W.ModReloadCount;
    if (W.ModAccurateRange > ModAccurateRange)
      ModAccurateRange = W.ModAccurateRange;

    // these are negative
    if (W.ModReloadTime < ModReloadTime)
      ModReloadTime = W.ModReloadTime;
    if (W.ModRecoilStrength < ModRecoilStrength)
      ModRecoilStrength = W.ModRecoilStrength;

    if (W.bHasLaser)
      bHasLaser = True;
    if (W.bHasSilencer)
      bHasSilencer = True;
    if (W.bHasScope)
      bHasScope = True;

    // copy the actual stats as well
    if (W.ReloadCount > ReloadCount)
      ReloadCount = W.ReloadCount;
    if (W.AccurateRange > AccurateRange)
      AccurateRange = W.AccurateRange;

    // these are negative
    if (W.BaseAccuracy < BaseAccuracy)
      BaseAccuracy = W.BaseAccuracy;
    if (W.ReloadTime < ReloadTime)
      ReloadTime = W.ReloadTime;
    if (W.RecoilStrength < RecoilStrength)
      RecoilStrength = W.RecoilStrength;
  }
  player = DeusExPlayer(Owner);
        PawnOwner = Pawn(Owner);

  if (Item.Class == Class)
  {
    if ( Weapon(item).bWeaponStay && (!Weapon(item).bHeldItem || Weapon(item).bTossedOut) )
      return true;

    // Only add ammo of the default type
    // There was an easy way to get 32 20mm shells, buy picking up another assault rifle with 20mm ammo selected
    if ( AmmoType != None )
    {
      OldAmmo = AmmoType.AmmoAmount;

      if ( AmmoNames[0] == None )
        defAmmoClass = AmmoName;
      else
        defAmmoClass = AmmoNames[0];

      defAmmo = Ammo(PawnOwner.FindInventoryType(defAmmoClass));
      defAmmo.AddAmmo( Weapon(Item).PickupAmmoCount );
    }
    if (Level.Game.LocalLog != None)
      Level.Game.LocalLog.LogPickup(Item, Pawn(Owner));
    if (Level.Game.WorldLog != None)
      Level.Game.WorldLog.LogPickup(Item, Pawn(Owner));
    if (Item.PickupMessageClass == None)
      PawnOwner.ClientMessage(Item.PickupMessage @ Item.itemArticle @ Item.itemName, 'Pickup');
    else
      PawnOwner.ReceiveLocalizedMessage( Item.PickupMessageClass, 0, None, None, item.Class );
    Item.PlaySound(Item.PickupSound);
    Item.SetRespawn();
    return true;
  }

  // Notify the object belt of the new ammo
  if (player != None)
    player.UpdateBeltText(Self);

  if ( Inventory == None )
    return false;

  return Inventory.HandlePickupQuery(Item);
}

simulated function ProcessTraceHit(Actor Other, Vector HitLocation, Vector HitNormal, Vector X, Vector Y, Vector Z)
{
	local float        mult;
	local name         damageType;
	local DeusExPlayer dxPlayer;

	if (Other != None)
	{
		// AugCombat increases our damage if hand to hand
		mult = 1.0;
		if (bHandToHand && (DeusExPlayer(Owner) != None))
		{
			mult = DeusExPlayer(Owner).AugmentationSystem.GetAugLevelValue(class'AugCombat');
			if (mult == -1.0)
				mult = 1.0;
		}

		// skill also affects our damage
		// GetWeaponSkill returns 0.0 to -0.7 (max skill/aug)
		mult += -2.0 * GetWeaponSkill();

		// Determine damage type
		damageType = WeaponDamageType();

		if (Other != None)
		{
			if (Other.bOwned)
			{
				dxPlayer = DeusExPlayer(Owner);
				if (dxPlayer != None)
					dxPlayer.AISendEvent('Futz', EAITYPE_Visual);
			}
		}
		if ((Other == Level) || (Other.IsA('Mover')))
		{
			if ( Role == ROLE_Authority )
				Other.TakeDamage(HitDamage * mult, Pawn(Owner), HitLocation, 1000.0*X, damageType);

			SelectiveSpawnEffects( HitLocation, HitNormal, Other, HitDamage * mult);
		}
		else if ((Other != self) && (Other != Owner))
		{
			if ( Role == ROLE_Authority )
				Other.TakeDamage(HitDamage * mult, Pawn(Owner), HitLocation, 1000.0*X, damageType);
			if (bHandToHand)
				SelectiveSpawnEffects( HitLocation, HitNormal, Other, HitDamage * mult);

			if (bPenetrating && Other.IsA('Pawn') && !Other.IsA('Robot'))
			{
			    if(Other.IsA('ModScriptedPawn') && ModScriptedPawn(Other).bElectronic)
			    {
			        SpawnOil(HitLocation, HitNormal);
			       ModScriptedPawn(Other).SpawnOil(HitLocation, HitNormal);
			    }
				else
				{
                    SpawnBlood(HitLocation, HitNormal);
                }
			}
		}
	}
   if (DeusExMPGame(Level.Game) != None)
   {
      if (DeusExPlayer(Other) != None)
         DeusExMPGame(Level.Game).TrackWeapon(self,HitDamage * mult);
      else
         DeusExMPGame(Level.Game).TrackWeapon(self,0);
   }
}

//
// SpawnBlood
//

function SpawnOil(Vector HitLocation, Vector HitNormal)
{
    local BloodSpurt BS;
   if ((DeusExMPGame(Level.Game) != None) && (!DeusExMPGame(Level.Game).bSpawnEffects))
      return;

   BS = spawn(class'BloodSpurt',,,HitLocation+HitNormal);
   BS.Style = STY_Normal;
   BS.MultiSkins[0] = Texture'DXModItems.Skins.CharcoalTex';
   BS.MultiSkins[1] = Texture'DXModItems.Skins.CharcoalTex';
   BS.MultiSkins[2] = Texture'DXModItems.Skins.CharcoalTex';
   BS.MultiSkins[3] = Texture'DXModItems.Skins.CharcoalTex';
   BS.MultiSkins[4] = Texture'DXModItems.Skins.CharcoalTex';
   BS.MultiSkins[5] = Texture'DXModItems.Skins.CharcoalTex';
   BS.MultiSkins[6] = Texture'DXModItems.Skins.CharcoalTex';
   BS.MultiSkins[7] = Texture'DXModItems.Skins.CharcoalTex';
//	spawn(class'DXMod.OilDrop',,,HitLocation+HitNormal);
//	if (FRand() < 0.5)
//		spawn(class'DXMod.OilDrop',,,HitLocation+HitNormal);
}

defaultproperties
{
     bMultiCopiesAllowed=True
}
