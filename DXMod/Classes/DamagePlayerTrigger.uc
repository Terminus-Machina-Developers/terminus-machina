//-----------------------------------------------------------
//
//-----------------------------------------------------------
class DamagePlayerTrigger expands Triggers;

var() float damageAmount;
var() name damageType;

function Trigger( actor Other, pawn EventInstigator )
{
    local float X, Y, Z;
    local vector vec;
    local PlayerPawn player;
    player = GetPlayerPawn();
    vec.X = RandRange(-64000,64000);
    vec.Y = RandRange(-64000,64000);
    vec.Z = RandRange(-64000,64000);                //GetPlayerPawn().Location
    //(damageAmount, Self, player.Location, vect(0,0,0), 'Radiation');
	player.TakeDamage(damageAmount, none, vec, vect(0,-100,0), damageType);
}

defaultproperties
{
     DamageAmount=5.000000
     DamageType=Burned
}
