//-----------------------------------------------------------
//
//-----------------------------------------------------------
class Voltear extends Multitool;

#exec obj load file=DXModUI

//
// Multitool
//
#exec mesh IMPORT MESH=Voltear ANIVFILE=Models\Multitool3rd_a.3d DATAFILE=Models\Multitool3rd_d.3d ZEROTEX=1
#exec MESHMAP scale MESHMAP=Voltear X=1 Y=1 Z=1//X=0.00390625 Y=0.00390625 Z=0.00390625
#exec mesh SEQUENCE MESH=Voltear SEQ=All		STARTFRAME=0	NUMFRAMES=1
#exec mesh SEQUENCE MESH=Voltear SEQ=Still	STARTFRAME=0	NUMFRAMES=1
#exec mesh SEQUENCE MESH=Voltear SEQ=Select	STARTFRAME=0	NUMFRAMES=1
#exec mesh SEQUENCE MESH=Voltear SEQ=Idle1	STARTFRAME=0	NUMFRAMES=1
#exec mesh SEQUENCE MESH=Voltear SEQ=Idle2	STARTFRAME=0	NUMFRAMES=1
#exec mesh SEQUENCE MESH=Voltear SEQ=Idle3	STARTFRAME=0	NUMFRAMES=1

#exec texture IMPORT NAME=VoltearTex FILE=Textures\VoltearTex.pcx GROUP="Skins"
#exec MESHMAP SETTEXTURE MESHMAP=Voltear NUM=0 TEXTURE=VoltearTex

//
// Multitool3rd
//
#exec mesh IMPORT MESH=Voltear3rd ANIVFILE=Models\Multitool3rd_a.3d DATAFILE=Models\Multitool3rd_d.3d ZEROTEX=1
#exec mesh ORIGIN MESH=Voltear3rd X=0 Y=0 Z=0 PITCH=32
#exec MESHMAP scale MESHMAP=Voltear3rd X=0.00390625 Y=0.00390625 Z=0.00390625
#exec mesh SEQUENCE MESH=Voltear3rd SEQ=All		STARTFRAME=0	NUMFRAMES=1
#exec mesh SEQUENCE MESH=Voltear3rd SEQ=Still		STARTFRAME=0	NUMFRAMES=1
#exec mesh SEQUENCE MESH=Voltear3rd SEQ=Select	STARTFRAME=0	NUMFRAMES=1
#exec mesh SEQUENCE MESH=Voltear3rd SEQ=Idle1		STARTFRAME=0	NUMFRAMES=1
#exec mesh SEQUENCE MESH=Voltear3rd SEQ=Idle2		STARTFRAME=0	NUMFRAMES=1
#exec mesh SEQUENCE MESH=Voltear3rd SEQ=Idle3		STARTFRAME=0	NUMFRAMES=1

#exec MESHMAP SETTEXTURE MESHMAP=Voltear3rd NUM=0 TEXTURE=VoltearTex

#exec AUDIO IMPORT FILE="Sounds\Voltear.wav" NAME="VoltearUse" GROUP="Weapons"

#exec texture IMPORT NAME=VoltearPOVTex1 FILE=Textures\VoltearPOVTex.pcx GROUP="Skins" FLAGS=2

/*
//
// MultitoolPOV
//
#exec OBJ LOAD FILE=DeusExItems

#exec mesh IMPORT MESH=VoltearPOV ANIVFILE=Models\MultitoolPOV_a.3d DATAFILE=DeusExItems\Models\MultitoolPOV_d.3d
#exec mesh ORIGIN MESH=VoltearPOV X=0 Y=0 Z=0 YAW=-64
#exec MESHMAP scale MESHMAP=VoltearPOV X=0.00390625 Y=0.00390625 Z=0.00390625
#exec mesh SEQUENCE MESH=VoltearPOV SEQ=All		STARTFRAME=0	NUMFRAMES=61
#exec mesh SEQUENCE MESH=VoltearPOV SEQ=Still		STARTFRAME=0	NUMFRAMES=1
#exec mesh SEQUENCE MESH=VoltearPOV SEQ=Select	STARTFRAME=1	NUMFRAMES=7		RATE=18
#exec mesh SEQUENCE MESH=VoltearPOV SEQ=UseBegin	STARTFRAME=8	NUMFRAMES=3		RATE=14
#exec mesh SEQUENCE MESH=VoltearPOV SEQ=UseLoop	STARTFRAME=11	NUMFRAMES=18	RATE=6
#exec mesh SEQUENCE MESH=VoltearPOV SEQ=UseEnd	STARTFRAME=29	NUMFRAMES=3		RATE=14
#exec mesh SEQUENCE MESH=VoltearPOV SEQ=Down		STARTFRAME=32	NUMFRAMES=5		RATE=18
#exec mesh SEQUENCE MESH=VoltearPOV SEQ=Idle1		STARTFRAME=37	NUMFRAMES=8		RATE=3
#exec mesh SEQUENCE MESH=VoltearPOV SEQ=Idle2		STARTFRAME=45	NUMFRAMES=8		RATE=3
#exec mesh SEQUENCE MESH=VoltearPOV SEQ=Idle3		STARTFRAME=53	NUMFRAMES=8		RATE=3

#exec texture IMPORT NAME=VoltearPOVTex1 FILE=Textures\VoltearPOVTex.pcx GROUP="Skins" FLAGS=2
//#exec texture IMPORT NAME=WeaponHandsTex FILE=Textures\WeaponHandsTex.pcx GROUP="Skins"
#exec MESHMAP SETTEXTURE MESHMAP=VoltearPOV NUM=0 TEXTURE=VoltearPOVTex1
#exec MESHMAP SETTEXTURE MESHMAP=VoltearPOV NUM=1 TEXTURE=WeaponHandsTex
#exec MESHMAP SETTEXTURE MESHMAP=VoltearPOV NUM=2 TEXTURE=VoltearPOVTex1
#exec MESHMAP SETTEXTURE MESHMAP=VoltearPOV NUM=3 TEXTURE=VoltearPOVTex1
#exec MESHMAP SETTEXTURE MESHMAP=VoltearPOV NUM=4 TEXTURE=VoltearPOVTex1
#exec MESHMAP SETTEXTURE MESHMAP=VoltearPOV NUM=5 TEXTURE=WeaponHandsTex    */


// ----------------------------------------------------------------------
// UseOnce()
//
// Subtract a use, then destroy if out of uses
// ----------------------------------------------------------------------

function UseOnce()
{
	local DeusExPlayer player;

	player = DeusExPlayer(Owner);
	NumCopies--;

	if (!IsA('SkilledTool'))
		GotoState('DeActivated');

	if (NumCopies <= 0)
	{
		if (player.inHand == Self)
			player.PutInHand(None);
		Destroy();
	}
	else
	{
		UpdateBeltText();
	}
}

function giveOwnerEnergy(HackableDevices giver)
{
    local DeusExPlayer DXPlayer;
    DXPlayer = DeusExPlayer(Owner);
    if(DXPlayer == none)
        return;
    DXPlayer.Energy += 1 + DXPlayer.SkillSystem.GetSkillLevel(Class'SkillTech') * 0.2;
    FClamp(DXPlayer.Energy,0,DXPlayer.EnergyMax);
     //giver.hackStrength -= 0.01;
    // TicksSinceLastHack = TicksSinceLastHack - TicksPerHack;
     giver.hackStrength = FClamp(giver.hackStrength, 0.0, 1.0);
     giver.hackPlayer.Energy += 1;
    //Alarm will sound on occasion
     if( self.RandRange(0,200+(50 * DXPlayer.SkillSystem.GetSkillLevel(Class'SkillTech'))) < 10)
     {
         if(DXPlayer.SkillSystem.GetSkillLevel(Class'SkillTech') < 3)
             giver.Trigger(self,DXPlayer);
     }

}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
state UseIt
{
	function PutDown()
	{

	}

Begin:
	if (( Level.NetMode != NM_Standalone ) && ( Owner != None ))
		SetLocation( Owner.Location );
	AmbientSound = useSound;
	PlayAnim('UseBegin',, 0.1);
	FinishAnim();
	LoopAnim('UseLoop',, 0.1);
}

defaultproperties
{
     UseSound=Sound'DXMod.Weapons.VoltearUse'
     ItemName="Power Sink"
     Icon=Texture'DXModUI.UI.VoltearIcon'
     largeIcon=Texture'DXModUI.UI.VoltearIcon'
     largeIconWidth=50
     largeIconHeight=50
     Description="If you can't steal fire from the gods, steal electricity with this tool.  By using a pure sinusoid DSP inverter and max-power-point regulators, the user can siphon electricity from most electronic devices, energy grid access points, and at higher levels, even short circuiting wires."
     beltDescription="P-Sink"
     MultiSkins(0)=Texture'DXMod.Skins.VoltearPOVTex1'
     MultiSkins(2)=Texture'DXMod.Skins.VoltearPOVTex1'
     MultiSkins(3)=Texture'DXMod.Skins.VoltearPOVTex1'
     MultiSkins(4)=Texture'DXMod.Skins.VoltearPOVTex1'
}
