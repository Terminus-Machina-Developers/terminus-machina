//-----------------------------------------------------------
//
//-----------------------------------------------------------
class ModRootWindow extends DeusExRootWindow;

event InitWindow()
{
	//Super.InitWindow();

	// Initialize variables
	winCount = 0;

	actorDisplay = ActorDisplayWindow(NewChild(Class'ActorDisplayWindow'));
	actorDisplay.SetWindowAlignments(HALIGN_Full, VALIGN_Full);

	hud = ModHUD(NewChild(Class'ModHUD'));
	hud.UpdateSettings(DeusExPlayer(parentPawn));
	hud.SetWindowAlignments(HALIGN_Full, VALIGN_Full, 0, 0);

	scopeView = DeusExScopeView(NewChild(Class'DeusExScopeView', False));
	scopeView.SetWindowAlignments(HALIGN_Full, VALIGN_Full, 0, 0);

	SetDefaultCursor(Texture'DeusExCursor1', Texture'DeusExCursor1_Shadow');

	scopeView.Lower();

	ConditionalBindMultiplayerKeys();

}

function ShowPhaceChange()
{
    ModHUD(hud).phaceWindow.ShowPhaceChange(true);
}

function SetPhace(PhaceBookFace newFace)
{
	local DeusExPlayer Player;

	Player = DeusExPlayer(parentPawn);
    ModHUD(hud).phaceWindow.SetPhace(newFace);
}
// ----------------------------------------------------------------------
// PopWindow()
//
// Returns the new current window, after the topmost window is
// popped off the stack.  First checks to make sure there's at least
// one window on the stack.  Then it pops the topmost window off,
// destroys it, decrements the window count and then attempts to
// Show() the new Topmost window if it's hidden.
//
// Returns the new Topmost window.
// ----------------------------------------------------------------------

function SetMap()
{
    if(hud != none)
        ModHUD(hud).SetMap();
}

function DeusExBaseWindow PopWindow(
	optional bool bNoUnpause)
{
	local DeusExBaseWindow oldWindow;
	local DeusExBaseWindow newWindow;
	local DeusExPlayer Player;
	local bool bFromMain;
	local string NetworkToConnect;
	local WirelessOverlay W;

	NetworkToConnect="";

	Player = DeusExPlayer(parentPawn);
	bFromMain = ( MenuMain(GetTopWindow()) != None );

	newWindow = None;

	if ( winCount > 0 )
	{
		// First pop off the current window and destroy it.
		oldWindow = winStack[winCount-1];
		//if it was a Persona Screen, then tell player their current face
		if(oldWindow.IsA('ModScreenImages')){
		     //ClientMessage("Persona Pop");
		     //show the player's current Nohface
             ModHUD(hud).phaceWindow.SetPhace(ModMale(Player).CurrentPhace);
             ShowPhaceChange();
		}
		//if it was a Hack Screen, and they connected, connect to network
		if(oldWindow.IsA('ModScreenHack')){
		     NetworkToConnect=ModScreenHack(oldWindow).NetworkToConnect;
		}
		oldWindow.Destroy();
		winStack[winCount-1] = None;
		if(NetworkToConnect!="")
		{
		    foreach Player.AllActors(class'WirelessOverlay', W)
		    {
		        if(NetworkToConnect == W.NetworkName)
		        {
		            break;
		        }
		    }
		    if(W.NetworkName == NetworkToConnect)
		    {
		        W.ConnectToNetwork(Player);
		        UnPauseGame();
                return none;
		    }
		}
		winCount--;

		if ( winCount > 0 )
		{
			newWindow = winStack[winCount-1];

			// Now show the topmost window if it's hidden
			if (!newWindow.IsVisible())
				newWindow.Show();
		}
	}

	if ((newWindow == None) && (!bNoUnpause))
		UnPauseGame();

	// When player is dead and is coming from the main menu
	if ((Player != None) && (Player.Health <= 0) && (Player.Level.NetMode != NM_Standalone))
	{
		if (bFromMain)
			Player.Fire(0);
	}

	return newWindow;
}

defaultproperties
{
     DataVaultFunctions(0)=(winClass=Class'DXMod.ModScreenInventory')
     DataVaultFunctions(1)=(winClass=Class'DXMod.ModScreenHealth')
     DataVaultFunctions(2)=(winClass=Class'DXMod.ModScreenAugmentations')
     DataVaultFunctions(4)=(winClass=Class'DXMod.ModScreenGoals')
     DataVaultFunctions(5)=(winClass=Class'DXMod.ModScreenConversations')
     DataVaultFunctions(6)=(winClass=Class'DXMod.ModScreenImages')
}
