//-----------------------------------------------------------
//
//-----------------------------------------------------------
class OilSplat expands BloodSplat;

function BeginPlay()
{
	local Rotator rot;
	local float rnd;

	Super.BeginPlay();

	rnd = FRand();
	if (rnd < 0.25)
		Texture = Texture'DXModItems.Skins.OilFXTex3';
	else if (rnd < 0.5)
		Texture = Texture'DXModItems.Skins.OilFXTex5';
	else if (rnd < 0.75)
		Texture = Texture'DXModItems.Skins.OilFXTex6';

	DrawScale += FRand() * 0.2;
}

defaultproperties
{
     Texture=Texture'DXModItems.Skins.OilFXTex2'
}
