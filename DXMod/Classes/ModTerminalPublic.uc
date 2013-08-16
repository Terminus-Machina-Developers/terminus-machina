//-----------------------------------------------------------
//
//-----------------------------------------------------------
class ModTerminalPublic expands NetworkTerminalPublic;

// ----------------------------------------------------------------------
// CloseScreen()
// ----------------------------------------------------------------------

function CloseScreen(String action)
{
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
		ShowScreen(Class'ComputerScreenBulletins');
    if (action == "SPECIAL")
	{
		ShowScreen(Class'ComputerScreenSpecialOptions');
	}
	// Based on the action, proceed!
	else if (action == "RETURN")
	{
         ShowScreen(Class'ComputerScreenBulletins');
	}
}

defaultproperties
{
     FirstScreen=Class'DXMod.ModScreenBulletins'
}
