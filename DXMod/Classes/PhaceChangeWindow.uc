//-----------------------------------------------------------
//
//-----------------------------------------------------------
class PhaceChangeWindow extends Crosshair;

var texture NewPhace;
var float timeDisplayed;
var float timetoDisplay;
var float displayLength;
var ViewportWindow winDrone;
var Spydrone selfcam;
var bool bDroneReferenced;
var float margin;
var float corner;
var float winDroneX;
var float winDroneY;


// ----------------------------------------------------------------------
//
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	SetBackground(none);

}

function ShowPhaceChange( bool bShow )
{
	local DeusExPlayer player;
    local DeusExRootWindow rootWindow;

    SetSize(800, 600);

    player = DeusExPlayer(GetPlayerPawn());

    if (player != None)
        rootWindow = DeusExRootWindow(player.RootWindow);
    rootWindow.ClientMessage("ShowPhace " $ bShow);

	Show(bShow);


	if(bShow){
	    bTickEnabled = true;
    	timeToDisplay = 1.5;
    	timeDisplayed = 0;
	}
}

function SetPhace( PhaceBookFace _newPhace )
{
    NewPhace = _newPhace.imageTextures[0];
    //SetBackground(NewPhace);
}

// ----------------------------------------------------------------------
// DrawWindow()
// ----------------------------------------------------------------------

event DrawWindow(GC gc)
{

	gc.SetAlignments(HALIGN_Right, VALIGN_Top);
    gc.SetStyle(DSTY_Masked);
    gc.SetTileColorRGB(255, 255, 255);
	//gc.DrawTexture(0, 300, 255, 255, 0, 0, NewPhace);

    Super.DrawWindow(gc);
    //gc.SetStyle(DSTY_Masked);
	// Draw the current phace
 	// Draw the text

	gc.SetFont(Font'FontMenuExtraLarge');
	gc.SetAlignments(HALIGN_Right, VALIGN_Top);
	gc.EnableWordWrap(false);
    gc.DrawText(50, winDroneY + 200, 200, 100, "Current Face:");



}

// ----------------------------------------------------------------------
// ConfigurationChanged()
// ----------------------------------------------------------------------

function ConfigurationChanged()
{
	local float x, y, w, h, cx, cy;

	if (winDrone != None)
	{
		w = width/4;
		h = height/4;
		cx = width/8 + margin;
		cy = height/2;
		x = cx - w/2;
		y = cy - h/2;

		winDroneX = x;
		winDroneY = y;

		if (winDrone != None)
			winDrone.ConfigureChild(x, y, w, h);
	}
}

// ----------------------------------------------------------------------
// ChildRequestedReconfiguration()
// ----------------------------------------------------------------------

function bool ChildRequestedReconfiguration(Window childWin)
{
	ConfigurationChanged();

	return True;
}

// ----------------------------------------------------------------------
// Tick()
// ----------------------------------------------------------------------

event Tick(float deltaSeconds)
{
    local DeusExPlayer Player;
	local Vector loc;
	local rotator rot;
    Player = DeusExPlayer(GetPlayerPawn());


	timeDisplayed += deltaSeconds;
 	if (timeDisplayed > timeToDisplay)
	{
		if (winDrone != None)
		{
			winDrone.Destroy();
			winDrone = None;
		}
		if (selfcam != None)
		{
			RemoveActorRef(selfcam);
			bDroneReferenced = false;
			selfcam.Destroy();
			selfcam = none;
		}
		bTickEnabled = False;
		Show(false);
        return;
	}

	if (selfcam == None && Player != none )
	{
	    selfcam = Player.Spawn(class'SpyDrone', Player,, Player.location, Player.ViewRotation);
        selfcam.mesh = none;
        selfcam.ambientsound = none;
    }

	// check for the drone ViewportWindow being constructed
	if (winDrone == None  && Player != none)
	{
		winDrone = ViewportWindow(NewChild(class'ViewportWindow'));
		if (winDrone != None)
		{

			winDrone.AskParentForReconfigure();
			winDrone.Lower();
			winDrone.SetViewportActor(selfcam);
		    winDrone.EnableViewport(True);
		    windrone.SetFOVAngle(30);
			winDrone.Show(true);
		}
	}

	if ( !bDroneReferenced )
	{
		if ( selfcam != None )
		{
			bDroneReferenced = true;
			AddActorRef( selfcam );
		}
	}
	if(selfcam != none && Player != none )
	{
	    loc = (28.0 * Vector(Player.ViewRotation));
	    loc.Z = Player.BaseEyeHeight;
	    loc += Player.Location;

        selfcam.SetLocation( loc );

        rot = Player.Rotation;
        rot.Yaw += 32768;
        selfcam.SetRotation(rot);
		//winCamera.SetDefaultTexture(None);
		//winDrone.Lower();

	}


}

defaultproperties
{
     margin=4.000000
     corner=9.000000
}
