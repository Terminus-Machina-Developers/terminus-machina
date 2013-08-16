//-----------------------------------------------------------
//
//-----------------------------------------------------------
class AugQuadruped expands ModAugmentation;

#exec OBJ LOAD FILE=DXModUI

state Active
{
Begin:
	Player.GroundSpeed *= LevelValues[CurrentLevel];
	//Player.JumpZ *= LevelValues[CurrentLevel];
	if ( Level.NetMode != NM_Standalone )
	{
		if ( Human(Player) != None )
			Human(Player).UpdateAnimRate( 300 );
	}
	//Player.RunSilentValue = 3;//Player.AugmentationSystem.GetAugLevelValue(class'AugStealth');
	//if ( Player.RunSilentValue == -1.0 )
	//	Player.RunSilentValue = 1.0;
}

function Deactivate()
{
	//Player.RunSilentValue = 1.0;
	Super.Deactivate();

	if (( Level.NetMode != NM_Standalone ) && Player.IsA('Human') )
		Player.GroundSpeed = Human(Player).Default.mpGroundSpeed;
	else
		Player.GroundSpeed = Player.Default.GroundSpeed;

	Player.JumpZ = Player.Default.JumpZ;
	if ( Level.NetMode != NM_Standalone )
	{
		if ( Human(Player) != None )
			Human(Player).UpdateAnimRate( -1.0 );
	}
}

defaultproperties
{
     CalorieRate=10.000000
     bUsesEnergy=False
     bBiohack=True
     EnergyRate=0.000000
     Icon=Texture'DXModUI.UI.AugQuadIcon'
     smallIcon=Texture'DXModUI.UI.AugQuadIconSmall'
     AugmentationName="Quadruped"
     Description="**Install in AUG menu** |n|nA quadruped DIY genetic modification kit, developed using the DNA of canines.  Through epigenetic manipulation of the epiphysial plates in the arms and hands, subtle musculoskeletal modification can be achieved allowing the biohacked individual to run and leap on all fours similar to a wolf or cheetah.  This accelerated quadrupedal locomotion works only while the biohacked individual is crouched.  |n|nWARNING: Extended use may deplete glucose and lipid stores, resulting in exhaustion and/or extreme hunger.  WARNING: Unskilled genetic modification may result in immuno-rejection, artificial cancer mutation, or death."
     LevelValues(0)=1.300000
     LevelValues(1)=1.500000
     LevelValues(2)=1.750000
     LevelValues(3)=2.000000
     AugmentationLocation=LOC_Leg
     MPConflictSlot=5
     LoopSound=None
}
