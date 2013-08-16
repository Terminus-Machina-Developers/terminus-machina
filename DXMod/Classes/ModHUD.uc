//-----------------------------------------------------------
//
//-----------------------------------------------------------
class ModHUD extends DeusExHUD;

var FaceRecCross						recCross;
var PhaceChangeWindow					phaceWindow;
var HUDMapDisplay						mapDisplay;

event InitWindow()
{
	local DeusExRootWindow root;
	local DeusExPlayer player;

	//Super.InitWindow();

	// Get a pointer to the root window
	root = DeusExRootWindow(GetRootWindow());

	// Get a pointer to the player
	player = DeusExPlayer(root.parentPawn);

	SetFont(Font'TechMedium');
	SetSensitivity(false);

	ammo			= HUDAmmoDisplay(NewChild(Class'HUDAmmoDisplay'));
	hit				= ModHitDisplay(NewChild(Class'ModHitDisplay'));//HUDHitDisplay(NewChild(Class'HUDHitDisplay'));
	cross			= ModCrosshair(NewChild(Class'ModCrosshair'));
	recCross		= FaceRecCross(NewChild(Class'FaceRecCross'));
	phaceWindow     = PhaceChangeWindow(NewChild(Class'PhaceChangeWindow'));
	belt			= HUDObjectBelt(NewChild(Class'HUDObjectBelt'));
	activeItems		= HUDActiveItemsDisplay(NewChild(Class'HUDActiveItemsDisplay'));
	damageDisplay	= DamageHUDDisplay(NewChild(Class'DamageHUDDisplay'));
	mapDisplay   	= HUDMapDisplay(NewChild(Class'HUDMapDisplay'));
	compass     	= HUDCompassDisplay(NewChild(Class'HUDCompassDisplay'));
	hms				= HUDMultiSkills(NewChild(Class'HUDMultiSkills'));

	// Create the InformationWindow
	info = HUDInformationDisplay(NewChild(Class'HUDInformationDisplay', False));

	// Create the log window
	msgLog	= HUDLogDisplay(NewChild(Class'HUDLogDisplay', False));
	msgLog.SetLogTimeout(player.GetLogTimeout());

	frobDisplay = FrobDisplayWindow(NewChild(Class'FrobDisplayWindow'));
	frobDisplay.SetWindowAlignments(HALIGN_Full, VALIGN_Full);

	augDisplay	= AugmentationDisplayWindow(NewChild(Class'AugmentationDisplayWindow'));
	augDisplay.SetWindowAlignments(HALIGN_Full, VALIGN_Full);

	startDisplay = HUDMissionStartTextDisplay(NewChild(Class'HUDMissionStartTextDisplay', False));
//	startDisplay.SetWindowAlignments(HALIGN_Full, VALIGN_Full);

	// Bark display
	barkDisplay = HUDBarkDisplay(NewChild(Class'HUDBarkDisplay', False));

	// Received Items Display
	receivedItems = HUDReceivedDisplay(NewChild(Class'HUDReceivedDisplay', False));

	//hide phaceWindow
    phaceWindow.ShowPhaceChange(false);
}

// ----------------------------------------------------------------------
// DescendantRemoved()
// ----------------------------------------------------------------------

event DescendantRemoved(Window descendant)
{
	if      (descendant == ammo)
		ammo  = None;
	else if (descendant == hit)
		hit   = None;
	else if (descendant == cross)
		cross = None;
	else if (descendant == recCross)
		recCross = None;
	else if (descendant == phaceWindow)
		phaceWindow = None;
	else if (descendant == belt)
		belt  = None;
	else if (descendant == activeItems)
		activeItems = None;
	else if (descendant == damageDisplay)
		damageDisplay = None;
	else if (descendant == mapDisplay)
		mapDisplay = None;
	else if (descendant == infolink)
		infolink = None;
	else if (descendant == timer)
		timer = None;
	else if (descendant == msgLog)
		msgLog = None;
	else if (descendant == info)
		info = None;
	else if (descendant == conWindow)
		conWindow = None;
	else if (descendant == frobDisplay)
		frobDisplay = None;
	else if (descendant == augDisplay)
		augDisplay = None;
	else if (descendant == compass)
		compass = None;
	else if (descendant == startDisplay)
		startDisplay = None;
	else if (descendant == barkDisplay)
		barkDisplay = None;
	else if (descendant == receivedItems)
		receivedItems = None;
	else if ( descendant == hms )
		hms = None;
}

function SetMap()
{
    if(mapDisplay != none)
    {
        //GetPlayerPawn().ClientMessage("Setting Map");
        mapDisplay.SetMap();
    }
}

// ----------------------------------------------------------------------
// ConfigurationChanged()
// ----------------------------------------------------------------------

function ConfigurationChanged()
{
	local float qWidth, qHeight;
	local float compassWidth, compassHeight;
	local float mapWidth, mapHeight;
	local float beltWidth, beltHeight;
	local float ammoWidth, ammoHeight;
	local float hitWidth, hitHeight;
	local float infoX, infoY, infoTop, infoBottom;
	local float infoWidth, infoHeight, maxInfoWidth, maxInfoHeight;
	local float itemsWidth, itemsHeight;
	local float damageWidth, damageHeight;
	local float conHeight;
	local float barkWidth, barkHeight;
	local float recWidth, recHeight, recPosY;
	local float logTop;

	if (ammo != None)
	{
		if (ammo.IsVisible())
		{
			ammo.QueryPreferredSize(ammoWidth, ammoHeight);
			ammo.ConfigureChild(0, height-ammoHeight, ammoWidth, ammoHeight);
		}
		else
		{
			ammoWidth  = 0;
			ammoHeight = 0;
		}
	}

	if (hit != None)
	{
		if (hit.IsVisible())
		{
			hit.QueryPreferredSize(hitWidth, hitHeight);
			hit.ConfigureChild(0, 0, hitWidth, hitHeight);
		}
	}

	// Stick the Compass directly under the Hit display
	if (compass != None)
	{
		compass.QueryPreferredSize(compassWidth, compassHeight);
		compass.ConfigureChild(0, hitHeight + 4, compassWidth, compassHeight);

		if (hitWidth == 0)
			hitWidth = compassWidth;
	}

	// Stick the Map under compass
	if (mapDisplay != None)
	{
		mapWidth = 400;
		mapHeight = 400;

        //mapDisplay.QueryPreferredSize(mapWidth, mapHeight);
		mapDisplay.ConfigureChild(0, hitHeight + compassHeight + 4, mapWidth, mapHeight);

		//if (hitWidth == 0)
		//	hitWidth = mapWidth;
	}

	if (cross != None)
	{
		cross.QueryPreferredSize(qWidth, qHeight);
		cross.ConfigureChild((width-qWidth)*0.5+0.5, (height-qHeight)*0.5+0.5, qWidth, qHeight);
	}
	if (recCross != None)
	{
		recCross.QueryPreferredSize(qWidth, qHeight);
		recCross.ConfigureChild((width-qWidth)*0.5+0.5, (height-qHeight)*0.5+0.5, qWidth, qHeight);
	}
	if (phaceWindow != None)
	{
		phaceWindow.QueryPreferredSize(qWidth, qHeight);
		phaceWindow.ConfigureChild((width-qWidth)*0.5+0.5, (height-qHeight)*0.7+0.5, qWidth, qHeight);
	   // phaceWindow.ShowPhaceChange(false);
    }
	if (belt != None)
	{
		belt.QueryPreferredSize(beltWidth, beltHeight);
		belt.ConfigureChild(width - beltWidth, height - beltHeight, beltWidth, beltHeight);

		infoBottom = height - beltHeight;
	}
	else
	{
		infoBottom = height;
	}

	// Damage display
	//
	// Left side, under the compass

	if (damageDisplay != None)
	{
		// Doesn't check to see if it might bump into the Hit Display
		damageDisplay.QueryPreferredSize(damageWidth, damageHeight);
		damageDisplay.ConfigureChild(0, hitHeight + compassHeight + 4, damageWidth, damageHeight);
	}

	// Active Items, includes Augmentations and various charged Items
	//
	// Upper right corner

	if (activeItems != None)
	{
		itemsWidth = activeItems.QueryPreferredWidth(height - beltHeight);
		activeItems.ConfigureChild(width - itemsWidth, 0, itemsWidth, height - beltHeight);
	}

	// Display the Log in the upper-left corner, to the right of
	// the hit display.

	if (msgLog != None)
	{
		qHeight = msgLog.QueryPreferredHeight(width - hitWidth - itemsWidth - 40);
		msgLog.ConfigureChild(hitWidth + 20, 10, width - hitWidth - itemsWidth - 40, qHeight);

		if (msgLog.IsVisible())
			logTop = max(infoTop, 10 + qHeight);
	}

	// Display the infolink to the right of the hit display
	// and underneath the Log window if it's visible.

	if (infolink != None)
	{
		infolink.QueryPreferredSize(qWidth, qHeight);

		if ((msgLog != None) && (msgLog.IsVisible()))
			infolink.ConfigureChild(hitWidth + 20, msgLog.Height + 20, qWidth, qHeight);
		else
			infolink.ConfigureChild(hitWidth + 20, 0, qWidth, qHeight);

		if (infolink.IsVisible())
			infoTop = max(infoTop, 10 + qHeight);
	}

	// First-person conversation window

	if (conWindow != None)
	{
		qWidth  = Min(width - 100, 800);
		conHeight = conWindow.QueryPreferredHeight(qWidth);

		// Stick it above the belt
		conWindow.ConfigureChild(
			(width / 2) - (qwidth / 2), (infoBottom - conHeight) - 20,
			qWidth, conHeight);
	}

	// Bark Display.  Position where first-person convo window would
	// go, or above it if the first-person convo is visible
	if (barkDisplay != None)
	{
		qWidth = Min(width - 100, 800);
		barkHeight = barkDisplay.QueryPreferredHeight(qWidth);

		barkDisplay.ConfigureChild(
			(width / 2) - (qwidth / 2), (infoBottom - barkHeight - conHeight) - 20,
			qWidth, barkHeight);
	}

	// Received Items display
	//
	// Stick below the crosshair, but above any bark/convo windows that might
	// be visible.

	if (receivedItems != None)
	{
		receivedItems.QueryPreferredSize(recWidth, recHeight);

		recPosY = (height / 2) + 20;

		if ((barkDisplay != None) && (barkDisplay.IsVisible()))
			recPosY -= barkHeight;
		if ((conWindow != None) && (conWindow.IsVisible()))
			recPosY -= conHeight;

		receivedItems.ConfigureChild(
			(width / 2) - (recWidth / 2), recPosY,
			recWidth, recHeight);
	}

	// Display the timer above the object belt if it's visible

	if (timer != None)
	{
		timer.QueryPreferredSize(qWidth, qHeight);

		if ((belt != None) && (belt.IsVisible()))
			timer.ConfigureChild(width-qWidth, height-qHeight-beltHeight-10, qWidth, qHeight);
		else
			timer.ConfigureChild(width-qWidth, height-qHeight, qWidth, qHeight);
	}

	// Mission Start Text
	if (startDisplay != None)
	{
		// Stick this baby right in the middle of the screen.
		startDisplay.QueryPreferredSize(qWidth, qHeight);
		startDisplay.ConfigureChild(
			(width / 2) - (qWidth / 2), (height / 2) - (qHeight / 2) - 75,
			qWidth, qHeight);
	}

	// Display the Info Window sandwiched between all the other windows.  :)

	if ((info != None) && (info.IsVisible(False)))
	{
		// Must redo these formulas
		maxInfoWidth  = Min(width - 170, 800);
		maxInfoHeight = (infoBottom - infoTop) - 20;

		info.QueryPreferredSize(infoWidth, infoHeight);

		if (infoWidth > maxInfoWidth)
		{
			infoHeight = info.QueryPreferredHeight(maxInfoWidth);
			infoWidth  = maxInfoWidth;
		}

		infoX = (width / 2) - (infoWidth / 2);
		infoY = infoTop + (((infoBottom - infoTop) / 2) - (infoHeight / 2)) + 10;

		info.ConfigureChild(infoX, infoY, infoWidth, infoHeight);
	}
}

// ----------------------------------------------------------------------
// UpdateSettings()
//
// Show/Hide these items as dictated by settings in DeusExPlayer (until
// DeusExHUD can be serialized)
// ----------------------------------------------------------------------

function UpdateSettings( DeusExPlayer player )
{
    local WirelessOverlay WC;
	belt.SetVisibility(player.bObjectBeltVisible);
	hit.SetVisibility(player.bAugDisplayVisible);
	//hit.SetVisibility(ModMale(player).bWirelessVisible);
	//damageDisplay.SetVisibility(player.bHitDisplayVisible);
	foreach player.AllActors(class'WirelessOverlay', WC)
	{
	    WC.AugRealityOn(player.bHitDisplayVisible);
	}
	ammo.SetVisibility(player.bAmmoDisplayVisible);
	activeItems.SetVisibility(player.bAugDisplayVisible);


	compass.SetVisibility(player.bCompassVisible);
	mapDisplay.SetVisibility(player.bCompassVisible);
	cross.SetCrosshair(player.bCrosshairVisible);
	recCross.SetCrosshair(false);

}

defaultproperties
{
}
