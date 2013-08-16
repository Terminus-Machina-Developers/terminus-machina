//-----------------------------------------------------------
//
//-----------------------------------------------------------
class InventoryTrigger expands Trigger;

var() Class<Inventory> CheckType;

// if we are triggered, check inventory then trigger if have object
function Trigger(Actor Other, Pawn Instigator)
{
    local bool bHasObject;
    local DeusExPlayer Player;
    local Actor A;

    Player = DeusExPlayer(GetPlayerPawn());

    if(Player != none)
    {
        bHasObject = (player.FindInventoryType(CheckType) != None);
        if(bHasObject)
        {
			foreach AllActors( class 'Actor', A, event )
				A.Trigger( Other, Instigator );
        }

    }

}

function Touch(Actor Other)
{
	local actor A;
	local bool  restoreGroup, bHasObject;  // DEUS_EX CNN
	local DeusExPlayer Player;

	if( IsRelevant( Other ) )
	{
		if ( ReTriggerDelay > 0 )
		{
			if ( Level.TimeSeconds - TriggerTime < ReTriggerDelay )
				return;
			TriggerTime = Level.TimeSeconds;
		}
        Player = DeusExPlayer(GetPlayerPawn());

        if(Player != none)
        {
            bHasObject = (player.FindInventoryType(CheckType) != None);
        }
		// Broadcast the Trigger message to all matching actors.
		if( Event != '' && bHasObject)
			foreach AllActors( class 'Actor', A, Event )
			{
				// DEUS_EX CNN
				// If the triggering actor doesn't have a group, then
				// we copy the trigger's group into the group of the triggerer
				// This will make LogicTriggers work correctly and won't
				// affect anything else
				if (Other.Group == '')
				{
					Other.Group = Group;
					restoreGroup = True;
				}
				else
					restoreGroup = False;

				A.Trigger( Other, Other.Instigator );

				// DEUS_EX CNN
				if (restoreGroup)
					Other.Group = '';
			}

		if ( Other.IsA('Pawn') && (Pawn(Other).SpecialGoal == self) )
			Pawn(Other).SpecialGoal = None;

		if( Message != "" )
			// Send a string message to the toucher.
			Other.Instigator.ClientMessage( Message );

		if( bTriggerOnceOnly )
			// Ignore future touches.
			SetCollision(False);
		else if ( RepeatTriggerTime > 0 )
			SetTimer(RepeatTriggerTime, false);
	}
}

defaultproperties
{
}
