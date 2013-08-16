//-----------------------------------------------------------
//
//-----------------------------------------------------------
class AugBiolux expands ModAugmentation;

#exec OBJ LOAD FILE=DXModCharacters

var Beam b1, b2;

function PreTravel()
{
	// make sure we destroy the light before we travel
	if (b1 != None)
		b1.Destroy();
	if (b2 != None)
		b2.Destroy();
	b1 = None;
	b2 = None;
}

function SetBeamLocation()
{
	local float dist, size, radius, brightness;
	local Vector HitNormal, HitLocation, StartTrace, EndTrace;

	if (b1 != None)
	{
		StartTrace = Player.Location;
		StartTrace.Z += Player.BaseEyeHeight;
		EndTrace = StartTrace + 1024 * Vector(Player.ViewRotation);

		Trace(HitLocation, HitNormal, EndTrace, StartTrace, True);
		if (HitLocation == vect(0,0,0))
			HitLocation = EndTrace;

		dist       = VSize(HitLocation - StartTrace);
		size       = fclamp(dist/1024, 0, 1);
		radius     = size*5.12 + 4.0;
		brightness = fclamp(size-0.5, 0, 1)*2*-192 + 192;
		b1.SetLocation(HitLocation-vector(Player.ViewRotation)*64);
		b1.LightRadius     = byte(radius);
		//b1.LightBrightness = byte(brightness);  // someday we should put this back in again
		b1.LightType       = LT_Steady;
		//Player.ClientMessage("Setting beam loc");
	}
}

function vector SetGlowLocation()
{
	local vector pos;

	if (b2 != None)
	{
		pos = Player.Location + vect(0,0,1)*Player.BaseEyeHeight +
		      vect(1,1,0)*vector(Player.Rotation)*Player.CollisionRadius*1.5;
		b2.SetLocation(pos);
	}
}

state Active
{
	function Tick (float deltaTime)
	{
		SetBeamLocation();
		SetGlowLocation();
	}

	function BeginState()
	{
		Super.BeginState();

		b1 = Spawn(class'Beam', Player, '', Player.Location);
		if (b1 != None)
		{
			AIStartEvent('Beam', EAITYPE_Visual);
			b1.LightHue = 128;
			b1.LightRadius = 4;
			b1.LightSaturation = 0;
			b1.LightBrightness = 202; //192
			SetBeamLocation();
		}
		b2 = Spawn(class'Beam', Player, '', Player.Location);
		if (b2 != None)
		{
			b2.LightHue = 128;
			b2.LightRadius = 4;
			b2.LightSaturation = 0;
			b2.LightBrightness = 230;    //220
			SetGlowLocation();
		}
		//Player.ScaleGlow=4;
		Player.MultiSkins[0]=Texture'DXModCharacters.Skins.TMGlowTex';
		Player.MultiSkins[3]=Texture'DXModCharacters.Skins.TMGlowTex';
	}

Begin:
}

function Deactivate()
{
	Super.Deactivate();
	if (b1 != None)
		b1.Destroy();
	if (b2 != None)
		b2.Destroy();
	b1 = None;
	b2 = None;
		Player.MultiSkins[0]=Player.default.Multiskins[0];
		Player.MultiSkins[3]=Player.default.Multiskins[0];
	//Player.ScaleGlow=0.0;
}

defaultproperties
{
     CalorieRate=1.000000
     bUsesEnergy=False
     bBiohack=True
     EnergyRate=0.000000
     Icon=Texture'DXModUI.UI.AugIconBiolux'
     smallIcon=Texture'DXModUI.UI.AugIconBioluxSmall'
     AugmentationName="Biolux"
     Description="**Install in AUG menu** |n|nA syringe of biolux DIY genetic modification serum.  Upon injection, retroviral vectors deliver nucleotide alterations to the DNA of the human epidermis.  Initiated via psychosomatic trigger, the cells begin to produce luciferin and luciferase catalyst, allowing the subject to emit biolumiscent light from his/her skin at will.  |n|nWARNING: Extended use may deplete glucose and lipid stores, resulting in exhaustion and/or extreme hunger.  WARNING: Unskilled genetic modification may result in immuno-rejection, artificial cancer mutation, or death. |n|nLEVEL ONE: Bioluminescent flashlight. |n|nLEVEL TWO: Fire while empty-handed to generate a blinding bioluminescence flashbang.|n|nLEVEL THREE: Biolux Flashbang radius increased |n|nLEVEL Four: Biolux Flashbang radius greatly increased"
     LevelValues(0)=1024.000000
     LevelValues(1)=2.000000
     LevelValues(2)=4.500000
     LevelValues(3)=8.000000
     AugmentationLocation=LOC_Subdermal
     MPConflictSlot=3
}
