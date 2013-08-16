//-----------------------------------------------------------
//
//-----------------------------------------------------------
class TrenchCoat extends ModAugCannister;


//#exec texture IMPORT NAME=SolarCoat FILE=Images\SolarCoat.pcx GROUP=UserInterface MIPS=OFF
//#exec texture IMPORT NAME=SolarCoatIcon FILE=Images\SolarCoatIcon.pcx GROUP=UserInterface MIPS=OFF
//#exec texture IMPORT NAME=SolarCoatTex FILE=Images\SolarPanel.pcx GROUP=UserInterface MIPS=OFF

#exec texture IMPORT NAME=NormCoatSmall FILE=Images\AugIconCoatSmall.pcx GROUP=UserInterface MIPS=OFF
#exec texture IMPORT NAME=NormCoat FILE=Images\normcoatsmall.pcx GROUP=UserInterface MIPS=OFF
#exec texture IMPORT NAME=NormCoatIcon FILE=Images\normcoatsmall.pcx GROUP=UserInterface MIPS=OFF
#exec texture IMPORT NAME=NormCoatTex FILE=Images\normcoatsmall.pcx GROUP=UserInterface MIPS=OFF


#exec mesh IMPORT MESH=NormCoatMesh ANIVFILE=Models\Seeds_a.3d DATAFILE=MODELS\Seeds_d.3d X=0 Y=0 Z=0
#exec mesh ORIGIN MESH=NormCoatMesh X=0 Y=0 Z=10

#exec mesh SEQUENCE MESH=NormCoatMesh SEQ=All STARTFRAME=0 NUMFRAMES=30
//#exec MESH SEQUENCE MESH=Seeds SEQ=??? STARTFRAME=0 NUMFRAMES=30

#exec MESHMAP new MESHMAP=NormCoatMesh MESH=NormCoatMesh
#exec MESHMAP scale MESHMAP=NormCoatMesh X=1 Y=1 Z=1

//#exec texture IMPORT NAME=SeedsTex FILE=Images\SolarCoat.pcx GROUP=Skins //FLAGS=2
//#exec texture IMPORT NAME=SeedsTex1 FILE=SeedsTex.pcx GROUP=Skins PALETTE=Jtex1
#exec MESHMAP SETTEXTURE MESHMAP=NormCoatMesh NUM=1 TEXTURE=NormCoatTex

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
     AddAugs(0)=AugTrenchCoat
     ItemName="Trench Coat"
     ItemArticle="a"
     PlayerViewMesh=LodMesh'DXMod.SolarCoatMesh'
     PickupViewMesh=LodMesh'DXMod.SolarCoatMesh'
     ThirdPersonMesh=LodMesh'DXMod.SolarCoatMesh'
     Icon=Texture'DXMod.UserInterface.NormCoatIcon'
     largeIcon=Texture'DXMod.UserInterface.NormCoat'
     largeIconWidth=140
     largeIconHeight=140
     invSlotsX=3
     invSlotsY=3
     Description="A webwork of East Asian plastileather and brown decay.  This coat's original hue has long been erased by the sandpaper of acid rain and thick hydrocarbons.  It has endured more nights in mulch-filled dumpsters than you care to remember."
     beltDescription="Coat"
     CollisionRadius=10.310000
}
