//-----------------------------------------------------------
//
//-----------------------------------------------------------
class Food extends DeusExPickup;

var int HealPoints;
var int FoodAmount;
var sound EatSound;

#exec obj load file=DXModSounds
//#exec AUDIO IMPORT FILE="Sounds\apple.WAV" NAME="Crunch" GROUP="Misc"

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
	        player.PlaySound(EatSound, SLOT_Interact);
            //PlaySound(EatSound, SLOT_None);
			player.EatFood(FoodAmount);
			heal = Healpoints + (HealPoints * Player.SkillSystem.GetSkillLevel(Class'DeusEx.SkillWeaponRifle'));
			player.HealPlayer(heal, False);
         }
		UseOnce();
	}
Begin:
}

defaultproperties
{
     HealPoints=5
     FoodAmount=10
     EatSound=Sound'DXModSounds.Misc.Crunch'
     ItemName="Food"
     ItemArticle="some"
}
