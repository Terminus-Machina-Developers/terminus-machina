//-----------------------------------------------------------
//
//-----------------------------------------------------------
class GlowingMoss expands DeusExPickup;


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
     ItemName="Glowing Moss"
     ItemArticle="some"
     PlayerViewOffset=(X=30.000000,Z=-12.000000)
     PlayerViewMesh=LodMesh'DXMod.Seeds'
     PickupViewMesh=LodMesh'DXMod.Seeds'
     ThirdPersonMesh=LodMesh'DXMod.Seeds'
     Icon=Texture'DXModUI.UI.MossGlowIcon'
     largeIcon=Texture'DXModUI.UI.MossGlowIcon'
     largeIconWidth=42
     largeIconHeight=46
     Description="This moss appears to have undergone extreme mutation due to ecological pollution and habitat toxicity from industrial waste dumping, and it glows with a radiation-green bioluminscence.  Despite the TV trope, the moss is probably not actually radioactive.  Probably."
     beltDescription="Moss"
     Mesh=LodMesh'DXMod.Seeds'
     MultiSkins(0)=Texture'DXModUI.UI.MossGlowIcon'
     MultiSkins(1)=Texture'DXModUI.UI.MossGlowIcon'
     MultiSkins(2)=Texture'DXModUI.UI.MossGlowIcon'
     MultiSkins(3)=Texture'DXModUI.UI.MossGlowIcon'
     CollisionRadius=8.000000
     CollisionHeight=0.980000
     Mass=3.000000
     Buoyancy=4.000000
}
