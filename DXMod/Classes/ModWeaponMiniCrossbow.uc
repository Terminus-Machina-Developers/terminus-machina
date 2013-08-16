//-----------------------------------------------------------
//
//-----------------------------------------------------------
class ModWeaponMiniCrossbow expands WeaponMiniCrossbow;

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

defaultproperties
{
     bMultiCopiesAllowed=True
     PickupAmmoCount=0
}
