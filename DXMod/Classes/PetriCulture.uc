//-----------------------------------------------------------
//
//-----------------------------------------------------------
class PetriCulture expands DeusExPickup;

defaultproperties
{
     maxCopies=20
     bCanHaveMultipleCopies=True
     bActivatable=True
     ItemName="Bacterial Culture"
     PlayerViewOffset=(X=30.000000,Z=-12.000000)
     PlayerViewMesh=LodMesh'DXMod.Seeds'
     PickupViewMesh=LodMesh'DXMod.Seeds'
     ThirdPersonMesh=LodMesh'DXMod.Seeds'
     Icon=Texture'DXModUI.UI.PetriIcon'
     largeIcon=Texture'DXModUI.UI.PetriIcon'
     largeIconWidth=42
     largeIconHeight=46
     Description="A petri culture for growing bacteria.  A film of Trypticase Polyorganic Agar (TPA) applied to the dish surface is the ideal environment for cultivating specific gene-mod strains of bacteria, which can then be isolated using archaeo-variant antibiotics.  The agar can be made from any food as the enzymatic digesters will adapt.  Each batch produces enough for two cultures.|n|n*Combine with Biolab and bacteria to grow more bacteria."
     beltDescription="Petri"
     Mesh=LodMesh'DXMod.Seeds'
     MultiSkins(0)=Texture'DXModUI.UI.PetriIcon'
     MultiSkins(1)=Texture'DXModUI.UI.PetriIcon'
     MultiSkins(2)=Texture'DXModUI.UI.PetriIcon'
     MultiSkins(3)=Texture'DXModUI.UI.PetriIcon'
     CollisionRadius=8.000000
     CollisionHeight=0.980000
     Mass=3.000000
     Buoyancy=4.000000
}
