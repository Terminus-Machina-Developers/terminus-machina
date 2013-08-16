//-----------------------------------------------------------
//
//-----------------------------------------------------------
class ComfreyPlant expands DeusExPickup;

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
     DescFamiliar="A trimming of Symphytum Franciscum, or San Francisco comfrey.  Used traditionally a medicinal herb, comfrey contains high levels of allantoin, which stimulates cell growth and repair while simultaneously depressing inflammation.  This strain of comfrey is native to the Bay Area, surviving hard conditions through fast, rampant growth and infraphotosynthetic chloroplasts which allow it to survive on infrared light in skies constantly blotted out by atmospheric pollution, fires, factory smoke, and hot class-war battles."
     maxCopies=20
     bCanHaveMultipleCopies=True
     ItemName="Comfrey"
     ItemArticle="some"
     PlayerViewOffset=(X=30.000000,Z=-12.000000)
     PlayerViewMesh=LodMesh'DXModItems.FlatItem'
     PickupViewMesh=LodMesh'DXModItems.FlatItem'
     ThirdPersonMesh=LodMesh'DXModItems.FlatItem'
     Icon=Texture'DXModUI.UI.ComfreyPlantIcon'
     largeIcon=Texture'DXModUI.UI.ComfreyPlantIcon'
     largeIconWidth=50
     largeIconHeight=50
     Description="Some kind of perennial herb with purple bell-shaped flowers.  Perhaps if you had better NATUREPUNK skills you could find a use for it..."
     beltDescription="comfrey"
     Mesh=LodMesh'DXModItems.FlatItem'
     MultiSkins(0)=Texture'DXModUI.UI.ComfreyPlantIcon'
     MultiSkins(1)=Texture'DXModUI.UI.ComfreyPlantIcon'
     MultiSkins(2)=Texture'DXModUI.UI.ComfreyPlantIcon'
     MultiSkins(3)=Texture'DXModUI.UI.ComfreyPlantIcon'
     CollisionRadius=8.000000
     CollisionHeight=0.980000
     Mass=3.000000
     Buoyancy=4.000000
}
