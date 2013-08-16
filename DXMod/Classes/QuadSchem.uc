//-----------------------------------------------------------
//
//-----------------------------------------------------------
class QuadSchem expands Schematic;

defaultproperties
{
     imageTexture=Texture'DXModUI.UI.EMPGunIcon'
     imageDescription="Quadruped Biohack"
     bioNeeded=1
     longDesc="A quadruped DIY genetic modification kit, developed using the DNA of canines.  Through epigenetic manipulation of the epiphysial plates in the arms and hands, subtle musculoskeletal modification can be achieved allowing the biohacked individual to run and leap on all fours similar to a wolf or cheetah.  This accelerated quadrupedal locomotion works only while the biohacked individual is crouched.  |n|nWARNING: Extended use may deplete glucose and lipid stores, resulting in exhaustion and/or extreme hunger.  WARNING: Unskilled genetic modification may result in immuno-rejection, artificial cancer mutation, or death."
     product=Class'DXMod.QuadHack'
     components(0)=Class'DXMod.SuitcaseBiolab'
     components(1)=Class'DXMod.DogBlood'
     SaveComponents(0)=1
     bScrappable=False
}
