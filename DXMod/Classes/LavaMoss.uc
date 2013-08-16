//-----------------------------------------------------------
//
//-----------------------------------------------------------
class LavaMoss expands DeusExPickup;


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
            player.TakeDamage(3,player,vect(0,0,0),vect(0,0,0),'Poison');
            player.ClientMessage("You don't feel too good...");
         }
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
     HealPoints=3
     FoodAmount=10
     EatSound=Sound'DXModSounds.Misc.Crunch'
     maxCopies=10
     bCanHaveMultipleCopies=True
     bActivatable=True
     ItemName="Red Bacteria"
     ItemArticle="some"
     PlayerViewOffset=(X=30.000000,Z=-12.000000)
     PlayerViewMesh=LodMesh'DXModItems.FlatItem'
     PickupViewMesh=LodMesh'DXModItems.FlatItem'
     ThirdPersonMesh=LodMesh'DXModItems.FlatItem'
     Icon=Texture'DXModUI.UI.LavaMossIcon'
     largeIcon=Texture'DXModUI.UI.LavaMossIcon'
     largeIconWidth=45
     largeIconHeight=48
     Description="This anomalous growth appears to be a fungal or bacterial colony.  It seems to be a hyperthermophile, thriving in the extreme temperatures of District Ten's rampant, un-doused building fires.  It has likely evolved to survive in the toxic environment of constant immolation and destruction.  It exhibits strong fire-resistance, feeding on the sulfides and carbon isotopes in the mounds of charcoal left as the San Francisco necropolis burns down from, neglect, drone strikes, rioting, and austerity budget cuts that decimated public fire departments."
     beltDescription="RedBac"
     Mesh=LodMesh'DXModItems.FlatItem'
     MultiSkins(0)=Texture'DXModUI.UI.LavaMossIcon'
     MultiSkins(1)=Texture'DXModUI.UI.LavaMossIcon'
     MultiSkins(2)=Texture'DXModUI.UI.LavaMossIcon'
     MultiSkins(3)=Texture'DXModUI.UI.LavaMossIcon'
     CollisionRadius=8.000000
     CollisionHeight=0.980000
     Mass=3.000000
     Buoyancy=4.000000
}
