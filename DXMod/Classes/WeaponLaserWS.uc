//-----------------------------------------------------------
//
//-----------------------------------------------------------
class WeaponLaserWS extends ModWeapon;

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

defaultproperties
{
     bRechargeable=True
     LowAmmoWaterMark=6
     GoverningSkill=Class'DeusEx.SkillWeaponPistol'
     NoiseLevel=0.010000
     EnviroEffective=ENVEFF_Air
     ShotTime=1.500000
     reloadTime=2.000000
     HitDamage=200
     maxRange=6000000 //assuming each DX unit is about 1.5 inches
     AccurateRange=3000000
     BaseAccuracy=0.100000
	 recoilStrength=0.0
     bCanHaveScope=True
     bCanHaveLaser=True
     bCanHaveSilencer=True
     bHasMuzzleFlash=False
     bUseWhileCrouched=False
     mpReloadTime=2.000000
     mpHitDamage=200
     mpAccurateRange=3000000
     mpMaxRange=3000000
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
     ItemName="Wingclipper"
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
     Description="High-powered laser weapon suitable for anti-material purposes. Cutting-edge adaptive optics give it excellent range (5+ kilometers) with very little energy lost in the intervening atmosphere. As a result, it is a near-silent weapon. Very high energy drain per shot. Nicknamed 'Wingclipper' due to its use against drones."
     beltDescription="Wingclipper"
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
