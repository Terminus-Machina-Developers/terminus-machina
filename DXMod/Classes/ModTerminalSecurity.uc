//-----------------------------------------------------------
//
//-----------------------------------------------------------
class ModTerminalSecurity expands NetworkTerminalSecurity;

// ----------------------------------------------------------------------
// CloseScreen()
// ----------------------------------------------------------------------

function CloseScreen(String action)
{
    local ModSpecialOptions M;
	// First destroy the current screen
	if (winComputer != None)
	{
		winComputer.Destroy();
		winComputer = None;
	}

	// Based on the action, proceed!

	if (action == "EXIT")
	{
		if (Computers(compOwner) != None)
			player.CloseComputerScreen(Computers(compOwner));
		root.PopWindow();
		return;
	}

	// If the user is logging in and bypassing the Hack screen,
	// then destroy the Hack window

	if ((action == "LOGIN") && (winHack != None) && (!bHacked))
	{
		CloseHackWindow();
		bNoHack = True;
	}

	// Based on the action, proceed!
	if (action == "LOGOUT")
	{
		// If we're hacked into the computer, then exit completely.
		if (bHacked)
			CloseScreen("EXIT");
		else
			ShowScreen(FirstScreen);
	}
	else if (action == "LOGIN")
	{
		// Check to see if there are any "special options" the player
		// has not yet invoked, in which case we want to jump straight
		// to the special options screen (oh boy, "special" cases!)
		/*if (AreSpecialOptionsAvailable(True))
		{
			ShowScreen(Class'ComputerScreenSpecialOptions');
			foreach AllActors(class'ModSpecialOptions', M)
			{
			    M.SetMalware();
            }
		}
		else */
			ShowScreen(Class'ComputerScreenSecurity');
	}
	else if (action == "RETURN")
	{
		ShowScreen(Class'ComputerScreenSecurity');
	}
	else if (action == "SPECIAL")
	{
		ShowScreen(Class'DXMod.ModSpecialOptions');
	}
}

defaultproperties
{
}
