//-----------------------------------------------------------
//
//-----------------------------------------------------------
class ModMenuSelectDiff expands MenuSelectDifficulty;

function ProcessCustomMenuButton(string key)
{
    local float CombatDiff;
	switch(key)
	{
		case "EASY":
		    CombatDiff = 1.0;
			//InvokeNewGameScreen(1.0);
			break;

		case "MEDIUM":
	    	CombatDiff = 1.5;
			//InvokeNewGameScreen(1.5);
			break;

		case "HARD":
		    CombatDiff = 2.0;
			//InvokeNewGameScreen(2.0);
			break;

		case "REALISTIC":
		    CombatDiff = 4.0;
			//InvokeNewGameScreen(4.0);
			break;
	}
	player.CombatDifficulty = CombatDiff;
	//player.StartNewGame("50_t");
	Player.ShowIntro(True);
}

defaultproperties
{
}
