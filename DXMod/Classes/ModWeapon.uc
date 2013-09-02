//-----------------------------------------------------------
//
//-----------------------------------------------------------
class ModWeapon extends DeusExWeapon;

var bool bEMP;
var bool         bRechargeable;
var int RechargeCost;
var bool bMultiCopiesAllowed;
var float StunLength;

simulated function ProcessTraceHit(Actor Other, Vector HitLocation, Vector HitNormal, Vector X, Vector Y, Vector Z)
{
	local float        mult;
	local name         damageType;
	local DeusExPlayer dxPlayer;
	local float orighealth;
	local float HeadOffsetZ;
	local float HeadOffsetY;
	local float ArmOffset;
	local vector sOffset;


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
			if ( Role == ROLE_Authority ) {
			    if( Other.IsA('ModScriptedPawn')){
			        if( ModScriptedPawn(Other).bElectronic ){
			             if( bEMP ){
							//stun if headshot or health less than 95%
							//(it takes two shots to stun if not a headshot)
							soffset = (HitLocation - Other.Location) << Other.Rotation;

							// calculate our hit extents
							headOffsetZ = Other.CollisionHeight * 0.58;

							if (soffset.z > headOffsetZ || ModScriptedPawn(Other).Health < ModScriptedPawn(Other).default.Health)
							{
								 damageType = 'Stunned';
								 ModScriptedPawn(Other).StunLength = StunLength;
							 }
							 Other.TakeDamage(HitDamage * mult, Pawn(Owner), HitLocation, 1000.0*X, damageType);
							 //Instigator.ClientMessage(orighealth - ModScriptedPawn(Other).Health);
                         } else {
							Other.TakeDamage(HitDamage * mult, Pawn(Owner), HitLocation, 1000.0*X, damageType);
						 }
                    }
                    else{
                         if( !bEMP ){
                             Other.TakeDamage(HitDamage * mult, Pawn(Owner), HitLocation, 1000.0*X, damageType);
			             } 
                    }
			    }
			    else if(!bEMP){
				    Other.TakeDamage(HitDamage * mult, Pawn(Owner), HitLocation, 1000.0*X, damageType);
			    }
            }
            if (bHandToHand)
				SelectiveSpawnEffects( HitLocation, HitNormal, Other, HitDamage * mult);

			if (bPenetrating && Other.IsA('Pawn') && !Other.IsA('Robot') && !bEMP)
				SpawnBlood(HitLocation, HitNormal);
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
}
