class DifficultyFixTrigger extends Trigger;

var() float difficultyMod; //1.0=easy, 1.5=normal, 2.0=hard, 4.0=realistic

function Touch(actor instigator)
{
    local deusexplayer P;

    super.Touch(instigator);

    P = deusexplayer(getplayerpawn());
    if(P != none)
         P.combatdifficulty = difficultymod;
    Log("Difficulty Changed: " $difficultyMod);
}

defaultproperties
{
}
