//-----------------------------------------------------------
//
//-----------------------------------------------------------
class ModCrosshair extends Crosshair;

#exec texture IMPORT NAME=FaceRecTex FILE=Textures\FaceRecFace.pcx//Textures\RecSquare.pcx

var texture RecTex;

event InitWindow()
{
	local Color col;

	//Super.InitWindow();

	SetBackgroundStyle(DSTY_Masked);
	SetBackground(Texture'CrossSquare');
	//SetBackground(RecTex);
	col.R = 255;
	col.G = 255;
	col.B = 255;
	SetCrosshairColor(col);
}

defaultproperties
{
     RecTex=Texture'DXMod.FaceRecTex'
}
