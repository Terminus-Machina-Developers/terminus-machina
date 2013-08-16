//-----------------------------------------------------------
//
//-----------------------------------------------------------
class Tomagranite expands Food;

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

state Activated
{
	function Activate()
	{
		// can't turn it off
	}

	function BeginState()
	{
		local ModMale player;
		local int heal;

		//Super.BeginState();

		player = ModMale(Owner);
		if (player != None)
		{
		    if(Player.SkillSystem.GetSkillLevel(Class'DeusEx.SkillWeaponRifle') < 1)
		    {
		        Player.ClientMessage("You're not sure what to do with this plant.  Maybe if you had more naturepunk skills...");
	        	GoToState('DeActivated');
            }
		    else
		    {
	            player.PlaySound(EatSound, SLOT_Interact);
                //PlaySound(EatSound, SLOT_None);
			    player.EatFood(FoodAmount);
			    heal = Healpoints + (HealPoints * Player.SkillSystem.GetSkillLevel(Class'DeusEx.SkillWeaponRifle'));
			    player.HealPlayer(heal, False);
	    		UseOnce();
			}
         }

	}
Begin:
}

defaultproperties
{
     DescFamiliar="A tomagranite.  A genespliced variant of a cherry tomato and a pomagranite, highly resistant to hydra rust, edible if properly prepared.  This plant is also a copyrighted strain, owned by Demetric.  Highly illegal unless you pay the monthly thousand dollar rent to Big Aggro to lawfully grow this blended-species foodcrop, lest you want to be taken in by CyberSec for agricultural piracy."
     maxCopies=20
     bCanHaveMultipleCopies=True
     bActivatable=True
     ItemName="Reddish Fruit"
     PlayerViewOffset=(X=30.000000,Z=-12.000000)
     PlayerViewMesh=LodMesh'DXModItems.FlatItem'
     PickupViewMesh=LodMesh'DXModItems.FlatItem'
     ThirdPersonMesh=LodMesh'DXModItems.FlatItem'
     Icon=Texture'DXModUI.UI.TomaIcon'
     largeIcon=Texture'DXModUI.UI.TomaIcon'
     largeIconWidth=50
     largeIconHeight=50
     Description="A round red fruit of some kind.  Larger than a cherry tomato but smaller than a pomagranite."
     beltDescription="fruit"
     Mesh=LodMesh'DXModItems.FlatItem'
     MultiSkins(0)=Texture'DXModUI.UI.TomaIcon'
     MultiSkins(1)=Texture'DXModUI.UI.TomaIcon'
     MultiSkins(2)=Texture'DXModUI.UI.TomaIcon'
     MultiSkins(3)=Texture'DXModUI.UI.TomaIcon'
     CollisionRadius=8.000000
     CollisionHeight=0.980000
     Mass=3.000000
     Buoyancy=4.000000
}
