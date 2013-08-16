//-----------------------------------------------------------
//
//-----------------------------------------------------------
class AloePlant expands DeusExPickup;

#exec obj load file=DXModUI

var() localized String DescFamiliar;

// ----------------------------------------------------------------------
// UpdateInfo()
// ----------------------------------------------------------------------

simulated function bool UpdateInfo(Object winObject)
{
	local PersonaInfoWindow winInfo;
	local string str;

	winInfo = PersonaInfoWindow(winObject);
	if (winInfo == None)
		return False;

	winInfo.SetTitle(itemName);
    if( DeusExPlayer(GetPlayerPawn()).SkillSystem.GetSkillLevel(Class'SkillWeaponRifle') < 1 )
    {
	    winInfo.SetText(Description $ winInfo.CR() $ winInfo.CR());
    }
    else
    {
        winInfo.SetText(DescFamiliar $ winInfo.CR() $ winInfo.CR());
    }

	if (bCanHaveMultipleCopies)
	{
		// Print the number of copies
		str = CountLabel @ String(NumCopies);
		winInfo.AppendText(str);
	}

	return True;
}

defaultproperties
{
     DescFamiliar="A trimming of Extremus Aloe, a variant of the medicinal plant used to treat burns, wounds, and other ailments for centuries.  It features a rosette of thick, fleshy leaves which secrete a clear gel.  Extremus Aloe is a subspecies of the Aloe genus evolved in the past half-century, an extremophile adapted to survival in the highly toxic environment of urban megasprawl full of industrial waste and genetically engineered plagues.  This is one of the few stalwart 'gladiator' plants which has survived the massive degredation of the global ecology without human genesplicing intervention, and is thus prized by members of organic and 'Green' movements as one of the last surviving non-GMO organisms still growing in the wild.  One of the few terrestrial extremophiles, Aloe Extremus has in fact evolved enzymes which thrive on tar and acid, breaking down even the rampant copper sulfide spills from powerplants into usable nutrients.  It is this advanced ability to detoxify that makes Aloe Extremus many times more potent 
     maxCopies=20
     bCanHaveMultipleCopies=True
     ItemName="Aloe"
     ItemArticle="some"
     PlayerViewOffset=(X=30.000000,Z=-12.000000)
     PlayerViewMesh=LodMesh'DXModItems.FlatItem'
     PickupViewMesh=LodMesh'DXModItems.FlatItem'
     ThirdPersonMesh=LodMesh'DXModItems.FlatItem'
     Icon=Texture'DXModUI.UI.AloePlantIcon'
     largeIcon=Texture'DXModUI.UI.AloePlantIcon'
     largeIconWidth=50
     largeIconHeight=50
     Description="A trimming of a cactus-like, thorned plant.  It features a rosette of thick, fleshy leaves which secrete a clear gel.  Perhaps if you had better NATUREPUNK skills you could find a use for it..."
     beltDescription="aloe"
     Mesh=LodMesh'DXModItems.FlatItem'
     MultiSkins(0)=Texture'DXModUI.UI.AloePlantIcon'
     MultiSkins(1)=Texture'DXModUI.UI.AloePlantIcon'
     MultiSkins(2)=Texture'DXModUI.UI.AloePlantIcon'
     MultiSkins(3)=Texture'DXModUI.UI.AloePlantIcon'
     CollisionRadius=8.000000
     CollisionHeight=0.980000
     Mass=3.000000
     Buoyancy=4.000000
}
