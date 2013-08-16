//-----------------------------------------------------------
//
//-----------------------------------------------------------
class FasfoodCultSchem expands Schematic;

defaultproperties
{
     imageTexture=Texture'DXModUI.UI.EMPGunIcon'
     imageDescription="Fasfood Bio-Narcotic (Cultured)"
     bioNeeded=1
     longDesc="A vial of Fasfood, a bio-opiate narcotic consisting of a genehacked spirochete bacteria, injected straight through the roof of the mouth into the brainstem.  Produces feelings of euphoria and temporary alleviation of hunger."
     product=Class'DXMod.Fasfood'
     components(0)=Class'DXMod.SuitcaseBiolab'
     components(1)=Class'DXMod.Fasfood'
     components(2)=Class'DXMod.PetriCulture'
     SaveComponents(0)=1
     SaveComponents(1)=1
     bScrappable=False
}
