//-----------------------------------------------------------
//
//-----------------------------------------------------------
class GoalAddTrigger extends Trigger;


// Sets a goal as completed when touched or triggered
// Set bCollideActors to false to make it triggered

var() string goalText;
var() name goalName;
var() bool bPrimaryGoal;

function Trigger(Actor Other, Pawn Instigator)
{
	local DeusExGoal goal;
	local DeusExPlayer player;

	Super.Trigger(Other, Instigator);

	player = DeusExPlayer(GetPlayerPawn());

	if (player != None)
	{
		// First check to see if this goal exists
		goal = player.FindGoal(goalName);

		if (goal == None)
			goal = player.AddGoal(goalName, bPrimaryGoal);
			goal.text = goalText;
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
    		// First check to see if this goal exists
    		goal = player.FindGoal(goalName);

    		if (goal == none)
    			goal =player.AddGoal(goalName, bPrimaryGoal);
    			 //player.ClientMessage("Goal Trigger Touched " $ goalName);
    			goal.text = goalText;
    	}
	}
}

defaultproperties
{
     bPrimaryGoal=True
     bTriggerOnceOnly=True
}
