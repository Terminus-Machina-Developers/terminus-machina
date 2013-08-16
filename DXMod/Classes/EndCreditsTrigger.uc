//-----------------------------------------------------------
//
//-----------------------------------------------------------
class EndCreditsTrigger expands Trigger;

function Trigger(Actor Other, Pawn Instigator)
{
	local DeusExGoal goal;
	local DeusExPlayer player;

	Super.Trigger(Other, Instigator);

	player = DeusExPlayer(GetPlayerPawn());

	if (player != None)
	{
        player.ShowCredits(True);
	}
}

function Touch(Actor Other)
{
	local DeusExGoal goal;
	local DeusExPlayer player;

	Super.Touch(Other);

	if (IsRelevant(Other))
	{
		player = DeusExPlayer(GetPlayerPawn());

    	if (player != None)
    	{
            player.ShowCredits(True);
    	}
	}
}

defaultproperties
{
}
