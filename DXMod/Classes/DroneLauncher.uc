//-----------------------------------------------------------
//
//-----------------------------------------------------------
class DroneLauncher expands Trigger;

function Trigger(actor Other, Pawn EventInstigator)
{
    local SearcherDestroyer SD;
    //YOU DIE NOW FOOL  - bring the drones
    if(ModMale(GetPlayerPawn()).bNoDroneStrike)
        return;

    foreach GetPlayerPawn().AllActors(class'SearcherDestroyer',SD)
    {
        if(!SD.IsInState('PreSearching') && !SD.IsInState('Searching') && !SD.IsInState('Destroying'))
            break;
    }
    //Player.ClientMessage("YOU DIE NOW BITCH");
    if(!SD.IsInState('PreSearching') && !SD.IsInState('Searching') && !SD.IsInState('Destroying'))
        SD.GotoState('PreSearching');
}

defaultproperties
{
     bCollideActors=False
}
