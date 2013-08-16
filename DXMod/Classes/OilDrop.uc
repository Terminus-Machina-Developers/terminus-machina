//-----------------------------------------------------------
//
//-----------------------------------------------------------
class OilDrop expands BloodDrop;

#exec OBJ LOAD FILE=DXModItems

auto state Flying
{
	function HitWall(vector HitNormal, actor Wall)
	{
		spawn(class'OilSplat',,, Location, Rotator(HitNormal));
		Destroy();
	}
	function BeginState()
	{
		Velocity = VRand() * 100;
		DrawScale = 1.0 + FRand();
		SetRotation(Rotator(Velocity));

		// Gore check
		if (Level.Game.bLowGore || Level.Game.bVeryLowGore)
		{
			Destroy();
			return;
		}
	}
}

function Tick(float deltaTime)
{
	if (Velocity == vect(0,0,0))
	{
		spawn(class'OilSplat',,, Location, rot(16384,0,0));
		Destroy();
	}
	else
		SetRotation(Rotator(Velocity));
}

defaultproperties
{
     ScaleGlow=100.000000
     MultiSkins(0)=Texture'DXModItems.Skins.CharcoalTex'
     MultiSkins(1)=Texture'DXModItems.Skins.CharcoalTex'
     MultiSkins(2)=Texture'DXModItems.Skins.CharcoalTex'
     MultiSkins(3)=Texture'DXModItems.Skins.CharcoalTex'
     MultiSkins(4)=Texture'DXModItems.Skins.CharcoalTex'
     MultiSkins(5)=Texture'DXModItems.Skins.CharcoalTex'
     MultiSkins(6)=Texture'DXModItems.Skins.CharcoalTex'
     MultiSkins(7)=Texture'DXModItems.Skins.CharcoalTex'
}
