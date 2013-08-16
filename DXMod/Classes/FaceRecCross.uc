//-----------------------------------------------------------
//
//-----------------------------------------------------------
class FaceRecCross extends Crosshair;

// ----------------------------------------------------------------------
// InitWindow()
// ----------------------------------------------------------------------

#exec texture IMPORT NAME=FaceRecTex FILE=Textures\FaceRecFace.pcx//Textures\RecSquare.pcx
#exec texture IMPORT NAME=FaceRecTexLo FILE=Textures\FaceRecFaceLo.pcx
#exec texture IMPORT NAME=FaceRecTexHi FILE=Textures\FaceRecFaceHi.pcx

var texture RecTex;
var texture RecTexLo;
var texture RecTexHi;

event InitWindow()
{
	local color col;

	SetBackgroundStyle(DSTY_Masked);
	SetBackground(RecTex);
	col.R = 255;
	col.G = 255;
	col.B = 255;
	SetCrosshairColor(col);
}

// ----------------------------------------------------------------------
// SetCrosshair()
// ----------------------------------------------------------------------

function SetCrosshair( bool bShow )
{
	Show(bShow);
}

// ----------------------------------------------------------------------
// SetCrosshair()
// ----------------------------------------------------------------------

function SetCrossType( int crossType )
{
    if( crossType == 1 )  {
        SetBackground(RecTexLo);
    }   else if( crossType == 2 )  {
        SetBackground(RecTex);
    } else if( crossType == 3 )    {
        SetBackground(RecTexHi);
    }

}

// ----------------------------------------------------------------------
// SetCrosshairColor()
// ----------------------------------------------------------------------

function SetCrosshairColor(color newColor)
{
	SetTileColor(newColor);
}

// Causes Timer() events every NewTimerRate seconds.
native(280) final function SetTimer( float NewTimerRate, bool bLoop );

defaultproperties
{
     RecTex=Texture'DXMod.FaceRecTex'
     RecTexLo=Texture'DXMod.FaceRecTexLo'
     RecTexHi=Texture'DXMod.FaceRecTexHi'
}
