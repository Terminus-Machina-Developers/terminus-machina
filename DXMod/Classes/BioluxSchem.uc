//-----------------------------------------------------------
//
//-----------------------------------------------------------
class BioluxSchem expands Schematic;

defaultproperties
{
     imageTexture=Texture'DXModUI.UI.EMPGunIcon'
     imageDescription="Biolux Biohack"
     bioNeeded=1
     longDesc="A biohack.  Upon injection, retroviral vectors deliver nucleotide alterations to the DNA of the human epidermis.  Initiated via psychosomatic trigger, the cells begin to produce luciferin and luciferase catalyst, allowing the subject to emit biolumiscent light from his/her skin at will.  WARNING: Extended use may deplete glucose and lipid stores, resulting in exhaustion and/or extreme hunger.  WARNING: Unskilled genetic modification may result in immuno-rejection, artificial cancer mutation, or death."
     product=Class'DXMod.Biohack'
     components(0)=Class'DXMod.SuitcaseBiolab'
     components(1)=Class'DXMod.GlowingMoss'
     SaveComponents(0)=1
     bScrappable=False
}
