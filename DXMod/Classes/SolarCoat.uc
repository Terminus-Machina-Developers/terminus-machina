//-----------------------------------------------------------
//
//-----------------------------------------------------------
class SolarCoat extends ModAugCannister;

//#exec texture IMPORT NAME=SolarCoat FILE=Images\SolarCoat.pcx GROUP=UserInterface MIPS=OFF
//#exec texture IMPORT NAME=SolarCoatIcon FILE=Images\SolarCoatIcon.pcx GROUP=UserInterface MIPS=OFF
//#exec texture IMPORT NAME=SolarCoatTex FILE=Images\SolarPanel.pcx GROUP=UserInterface MIPS=OFF

#exec texture IMPORT NAME=SolarCoat FILE=Images\solarcoatsmall.pcx GROUP=UserInterface MIPS=OFF
#exec texture IMPORT NAME=SolarCoatIcon FILE=Images\SolarCoatIcon.pcx GROUP=UserInterface MIPS=OFF
#exec texture IMPORT NAME=SolarCoatTex FILE=Images\SolarPanel.pcx GROUP=UserInterface MIPS=OFF


#exec mesh IMPORT MESH=SolarCoatMesh ANIVFILE=Models\Seeds_a.3d DATAFILE=MODELS\Seeds_d.3d X=0 Y=0 Z=0
#exec mesh ORIGIN MESH=SolarCoatMesh X=0 Y=0 Z=10

#exec mesh SEQUENCE MESH=SolarCoatMesh SEQ=All STARTFRAME=0 NUMFRAMES=30
//#exec MESH SEQUENCE MESH=Seeds SEQ=??? STARTFRAME=0 NUMFRAMES=30

#exec MESHMAP new MESHMAP=SolarCoatMesh MESH=SolarCoatMesh
#exec MESHMAP scale MESHMAP=SolarCoatMesh X=1 Y=1 Z=1

//#exec texture IMPORT NAME=SeedsTex FILE=Images\SolarCoat.pcx GROUP=Skins //FLAGS=2
//#exec texture IMPORT NAME=SeedsTex1 FILE=SeedsTex.pcx GROUP=Skins PALETTE=Jtex1
#exec MESHMAP SETTEXTURE MESHMAP=SolarCoatMesh NUM=1 TEXTURE=SolarCoatTex

auto state Pickup
{
// ----------------------------------------------------------------------
// function Frob()
// For autoinstalling in deathmatch, we need to overload frob here
// ----------------------------------------------------------------------
   /*function Frob(Actor Other, Inventory frobWith)
   {
      local Inventory Copy;
      local int AugZeroPriority;
      local int AugOnePriority;
      local Augmentation AugZero;
      local Augmentation AugOne;

      if ( ValidTouch(Other) )
      {
         if (Level.Game.LocalLog != None)
            Level.Game.LocalLog.LogPickup(Self, Pawn(Other));
         if (Level.Game.WorldLog != None)
            Level.Game.WorldLog.LogPickup(Self, Pawn(Other));

         SetOwner(DeusExPlayer(Other));

         AugZero = GetAugmentation(0);
         AugOne = GetAugmentation(1);

            Pawn(Other).ClientMessage("Autoinstalling Augmentation "$AugZero.AugmentationName$".");
            DeusExPlayer(Other).AugmentationSystem.GivePlayerAugmentation(AugZero.Class);


         SetOwner(None);
      }

   }
    */
}
// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     components(0)=Class'DXMod.SolarPanel'
     components(1)=Class'DXMod.CopperWire'
     AddAugs(0)=AugSolarCoat
     ItemName="Skorched Urth Solar Coat"
     ItemArticle="a"
     PlayerViewMesh=LodMesh'DXMod.SolarCoatMesh'
     PickupViewMesh=LodMesh'DXMod.SolarCoatMesh'
     ThirdPersonMesh=LodMesh'DXMod.SolarCoatMesh'
     Icon=Texture'DXMod.UserInterface.SolarCoatIcon'
     largeIcon=Texture'DXMod.UserInterface.SolarCoat'
     largeIconWidth=140
     largeIconHeight=160
     invSlotsX=3
     invSlotsY=3
     Description="Monocrystalline photovoltaics are stitched into your coat on the fly to allow constant replenishment of electricity reserves beneath sunlight, or the million-watt glare of a nuclear flash."
     beltDescription="SolCoat"
     Mesh=LodMesh'DXMod.SolarCoatMesh'
     CollisionRadius=10.310000
}
