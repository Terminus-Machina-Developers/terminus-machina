//-----------------------------------------------------------
//
//-----------------------------------------------------------
class PoisonPlant expands DeusExPickup;

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

		Super.BeginState();

		player = ModMale(Owner);
		if (player != None)
		{
            Player.TakeDamage(5,Player,vect(0,0,0),vect(0,0,0),'Poison' );
            Player.ClientMessage("You don't feel so good!");

	        //player.PlaySound(Sound'DXModSounds.Misc.Crunch', SLOT_Interact);
            //PlaySound(EatSound, SLOT_None);
			//player.EatFood(FoodAmount);
			//heal = Healpoints + (HealPoints * Player.SkillSystem.GetSkillLevel(Class'DeusEx.SkillWeaponRifle'));
			//player.HealPlayer(heal, False);
         }
		UseOnce();
	}
Begin:
}

defaultproperties
{
     DescFamiliar="Zea Maculatum.  AKA 'Poison Corn' or 'Hemlock Corn'.  A mutation of a transgenic terminator strain of corn spliced with hemlock, the toxic herb which Socrates was forced to drink after the Greek government condemned him to death for 'corrupting youth with skepticism'.  The strain was initially developed by major ag/biotech corporation Aggritech as a biopharmaceutical crop grown en-masse for medical use as anaesthetic.  It was later uncovered by investigative journalists working for rogue e-publication Darkleaks that US re-education camps for activists, political dissidents, and hacktivist groups were adding zea maculatum to prisoners food, resulting in untimely deaths of 'patients'.  A year later the supposedly non-reproducing seeds somehow spread and mingled with farms growing common supermarket corn, resulting in thousands of deaths and a mass recall on all corn products, in turn resulting in food price spikes and rioting.  A deluge of lawsuits against Aggritech were suspiciously thrown out by the Supreme 
     maxCopies=20
     bCanHaveMultipleCopies=True
     bActivatable=True
     ItemName="Hemlock Corn"
     ItemArticle="some"
     PlayerViewOffset=(X=30.000000,Z=-12.000000)
     PlayerViewMesh=LodMesh'DXModItems.FlatItem'
     PickupViewMesh=LodMesh'DXModItems.FlatItem'
     ThirdPersonMesh=LodMesh'DXModItems.FlatItem'
     Icon=Texture'DXModUI.UI.PoisonPlantIcon'
     largeIcon=Texture'DXModUI.UI.PoisonPlantIcon'
     largeIconWidth=50
     largeIconHeight=50
     Description="This plant has a fuschia spotted stem with parsley-like leaves, flowers in umbels, and corn-like fruits.  Most likely a transgenic GMO hybrid of some kind.  Perhaps if you had better NATUREPUNK skills you could find a use for it..."
     beltDescription="hemcorn"
     Mesh=LodMesh'DXModItems.FlatItem'
     MultiSkins(0)=Texture'DXModUI.UI.PoisonPlantIcon'
     MultiSkins(1)=Texture'DXModUI.UI.PoisonPlantIcon'
     MultiSkins(2)=Texture'DXModUI.UI.PoisonPlantIcon'
     MultiSkins(3)=Texture'DXModUI.UI.PoisonPlantIcon'
     CollisionRadius=8.000000
     CollisionHeight=0.980000
     Mass=3.000000
     Buoyancy=4.000000
}
