//-----------------------------------------------------------
//
//-----------------------------------------------------------
class PetriSchem expands Schematic;

defaultproperties
{
     imageTexture=Texture'DXModUI.UI.EMPGunIcon'
     imageDescription="Bacterial Culture"
     bioNeeded=1
     longDesc="A petri culture for growing bacteria.  A film of Trypticase Polyorganic Agar (TPA) applied to the dish surface is the ideal environment for cultivating specific gene-mod strains of bacteria, which can then be isolated using archaeo-variant antibiotics.|n|n** Combine with Biolab and bacteria to grow more bacteria."
     product=Class'DXMod.PetriCulture'
     components(0)=Class'DXMod.SuitcaseBiolab'
     components(1)=Class'DXMod.Food'
     SaveComponents(0)=1
     numProduct(1)=2
     numProduct(2)=3
     numProduct(3)=4
     GoverningSkill=Class'DeusEx.SkillMedicine'
     bScrappable=False
}
