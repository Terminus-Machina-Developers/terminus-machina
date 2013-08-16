//=============================================================================
// ShopButton.
//=============================================================================
class ShopButton expands ButtonWindow;

#exec OBJ LOAD FILE=EOTPPLAYER

var DeusExPlayer player;

var bool bSelected;

// Border and Background Translucency
var bool bBorderTranslucent;
var bool bBackgroundTranslucent;
//var bool bDrawBorder;

// Default Colors
var Color colBackground, Nofocus, HasFocus;
//var Color colBorder;
//var Color colHeaderText;

var string title;

var Texture buttonTex, buttonOffTex;

// ----------------------------------------------------------------------
// InitWindow()
//
// Responsible for creating the various and sundry sub-windows for
// the keypad popup.
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	buttonTex=Texture'EotPPlayerTex.UserInterface.ItemSelectButto';
	buttonOffTex=Texture'EotPPlayerTex.UserInterface.ItemSelButOff';

	SetSize(128, 32);

	// Get a pointer to the player
	player = DeusExPlayer(GetRootWindow().parentPawn);

	StyleChanged();

	NoFocus.R=223;
	NoFocus.G=223;
	NoFocus.B=0;
	HasFocus.R=223;
	HasFocus.G=223;
	HasFocus.B=223;
}

// ----------------------------------------------------------------------
// DrawWindow()
// ----------------------------------------------------------------------

event DrawWindow(GC gc)
{
	if (!bIsVisible)
		return;
	// Draw the button graphic
	gc.SetTileColor(colBackground);

	if (bBackgroundTranslucent)
		gc.SetStyle(DSTY_Translucent);
	else
		gc.SetStyle(DSTY_Masked);

	// draw the button
	if (bSelected)
		gc.DrawTexture(0, 0, width, height, 0, 0, buttonTex);
	else
		gc.DrawTexture(0, 0, width, height, 0, 0, buttonOffTex);
	// If the button is currently being depressed, then draw the
	// graphic down and to the right one.
	gc.SetFont(Font'DeusExUI.FontMenuTitle');
	gc.SetAlignments(HALIGN_Center, VALIGN_Center);
	gc.EnableTranslucentText(True);
	if (bSelected)
		gc.SetTextColor(NoFocus);
	else
		gc.SetTextColor(HasFocus);

	if (bSelected)
		gc.DrawText(1, 3, width, height, title);
	else
		gc.DrawText(0, 2, width, height, title);
}

// ----------------------------------------------------------------------
// StyleChanged()
// ----------------------------------------------------------------------

event StyleChanged()
{
	local ColorTheme theme;

	theme = player.ThemeManager.GetCurrentHUDColorTheme();

	colBackground = theme.GetColorFromName('HUDColor_Background');

	bBorderTranslucent     = player.GetHUDBorderTranslucency();
	bBackgroundTranslucent = player.GetHUDBackgroundTranslucency();
	//bDrawBorder            = player.GetHUDBordersVisible();
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
}
