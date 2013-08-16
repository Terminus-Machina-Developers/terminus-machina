//-----------------------------------------------------------
//
//-----------------------------------------------------------
class WeaponEMPGun extends ModWeapon;

#exec OBJ LOAD FILE=DXModSounds
#exec OBJ LOAD FILE=DXModItems
//#exec MESHMAP SETTEXTURE MESHMAP=DeusExItems.SniperRifle NUM=1 TEXTURE=DXModItems.Skins.EMPGunTex1

function renderoverlays(canvas canvas)
{
    multiskins[0]=Texture'DXModItems.Skins.EMPGunTex1';
    multiskins[1]=Texture'DXModItems.Skins.EMPGunTex1';
    multiskins[2]=Texture'DXModItems.Skins.EMPGunTex1';
    multiskins[3]=Texture'DXModItems.Skins.EMPGunTex1';
    multiskins[4]=Texture'DXModItems.Skins.EMPGunTex1';
    multiskins[5]=Texture'DXModItems.Skins.EMPGunTex1';
    multiskins[6]=Texture'DXModItems.Skins.EMPGunTex1';
    multiskins[7]=Texture'DXModItems.Skins.EMPGunTex1';

    super.renderoverlays(canvas);

    multiskins[0]=Texture'DXModItems.Skins.EMPGunTex3rd';
    multiskins[1]=Texture'DXModItems.Skins.EMPGunTex3rd';
    multiskins[2]=Texture'DXModItems.Skins.EMPGunTex3rd';
    multiskins[3]=Texture'DXModItems.Skins.EMPGunTex3rd';
}

//
// from Weapon.uc - modified so we can have the accuracy in TraceFire
//
function Fire(float Value)
{
    if(Owner.IsA('DeusExPlayer') && (ClipCount < ReloadCount))
    {
        ModMale(Owner).bEMPFX = true;
        DeusExPlayer(Owner).drugEffectTimer = 0.25;
    }
    super.Fire(Value);
}

defaultproperties
{
     bEMP=True
     bRechargeable=True
     StunLength=10.000000
     LowAmmoWaterMark=6
     GoverningSkill=Class'DeusEx.SkillWeaponPistol'
     NoiseLevel=0.000000
     EnviroEffective=ENVEFF_Air
     ShotTime=1.500000
     reloadTime=2.000000
     HitDamage=25
     maxRange=2000
     AccurateRange=2000
     BaseAccuracy=0.100000
     bCanHaveScope=True
     bCanHaveLaser=True
     bCanHaveSilencer=True
     bHasMuzzleFlash=False
     bUseWhileCrouched=False
     mpReloadTime=2.000000
     mpHitDamage=25
     mpAccurateRange=9000
     mpMaxRange=9000
     mpReloadCount=6
     bCanHaveModBaseAccuracy=True
     bCanHaveModReloadCount=True
     bCanHaveModAccurateRange=True
     bCanHaveModReloadTime=True
     bCanHaveModRecoilStrength=True
     AmmoName=Class'DeusEx.AmmoBattery'
     ReloadCount=6
     PickupAmmoCount=6
     bInstantHit=True
     FireOffset=(X=-20.000000,Y=2.000000,Z=30.000000)
     shakemag=50.000000
     FireSound=Sound'DXModSounds.Misc.EMPgun'
     AltFireSound=Sound'DeusExSounds.Weapons.ProdReloadEnd'
     CockingSound=Sound'DeusExSounds.Weapons.RifleReload'
     SelectSound=Sound'DeusExSounds.Weapons.RifleSelect'
     InventoryGroup=25
     ItemName="EMP Gun"
     PlayerViewOffset=(X=20.000000,Y=-2.000000,Z=-30.000000)
     PlayerViewMesh=LodMesh'DeusExItems.SniperRifle'
     PickupViewMesh=LodMesh'DeusExItems.SniperRiflePickup'
     ThirdPersonMesh=LodMesh'DeusExItems.SniperRifle3rd'
     LandSound=Sound'DeusExSounds.Generic.DropMediumWeapon'
     Icon=Texture'DXModUI.UI.EMPGunIconSmall'
     largeIcon=Texture'DXModUI.UI.EMPGunIcon'
     largeIconWidth=159
     largeIconHeight=47
     invSlotsX=4
     Description="A DIY EMP rifle.  Emits high-energy microwaves directed by a parabolic reflector capable of disrupting electronics and de-programming computer circuits at low voltages, and causing catastrophic damage at higher settings.  (AKA: HERF gun)"
     beltDescription="EMPgun"
     Mesh=LodMesh'DeusExItems.SniperRiflePickup'
     MultiSkins(0)=Texture'DXModItems.Skins.EMPGunTex3rd'
     MultiSkins(1)=Texture'DXModItems.Skins.EMPGunTex3rd'
     MultiSkins(2)=Texture'DXModItems.Skins.EMPGunTex3rd'
     MultiSkins(3)=Texture'DXModItems.Skins.EMPGunTex3rd'
     MultiSkins(4)=Texture'DXModItems.Skins.EMPGunTex3rd'
     MultiSkins(5)=Texture'DXModItems.Skins.EMPGunTex3rd'
     MultiSkins(6)=Texture'DXModItems.Skins.EMPGunTex3rd'
     CollisionRadius=26.000000
     CollisionHeight=2.000000
     Mass=30.000000
}
