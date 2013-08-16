//-----------------------------------------------------------
//
//-----------------------------------------------------------
class PlayerWantedTrigger expands Trigger;

var() bool  bWanted;

function Trigger(Actor Other, Pawn Instigator)
{
	local ModMale P;
	if (!bWanted)
	{
		foreach AllActors (class'ModMale', P)
		{
			P.Alliance = 'Civilian';
            P.bNohface = true;
            P.bNoDroneStrike = true;
        }
        GetPlayerPawn().ClientMessage("Setting Player Unwanted");
	}
	else
	{
		foreach AllActors (class'ModMale', P)
		{
			P.Alliance = 'Player';
            P.bNohface = false;
            P.bNoDroneStrike = false;
        }
        GetPlayerPawn().ClientMessage("Setting Player Wanted");
	}
}

defaultproperties
{
}
