//-----------------------------------------------------------
//
//-----------------------------------------------------------
class ModGameInfo expands DeusExGameInfo;

#exec CONVERSATION IMPORT FILE="Conversations\Mission50.Con"

function bool ApproveClass( class<playerpawn> SpawnClass)
{
    return true;
}

defaultproperties
{
}
