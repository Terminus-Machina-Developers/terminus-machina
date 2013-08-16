//-----------------------------------------------------------
//
//-----------------------------------------------------------
class Fasfood expands VialCrack;

state Activated
{
	function Activate()
	{
		// can't turn it off
	}

	function BeginState()
	{
		local DeusExPlayer player;

		Super.BeginState();

		player = ModMale(Owner);
		if (player != None)
		{
			player.drugEffectTimer += 60.0;
			player.HealPlayer(10, False);
			ModMale(player).BurnCalories(-50);
			ModMale(player).FasFoodTimer+=5;
		}

		UseOnce();
	}
Begin:
}

defaultproperties
{
     ItemName="Fasfood Vial"
     PickupViewScale=3.000000
     Icon=Texture'DXModUI.UI.FasfoodIconTex'
     largeIcon=Texture'DXModUI.UI.FasfoodIconLargeTex'
     Description="A vial of Fasfood, a bio-opiate narcotic consisting of a genehacked spirochete bacteria, injected straight through the roof of the mouth into the brainstem.  Produces feelings of euphoria and temporary alleviation of hunger."
     beltDescription="Fasfood"
     MultiSkins(0)=Texture'DXModItems.Skins.Fasfood'
     CollisionHeight=2.410000
}
