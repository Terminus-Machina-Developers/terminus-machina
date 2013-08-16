//-----------------------------------------------------------
//
//-----------------------------------------------------------
class DrawWeapTrigger extends Trigger;

var() bool bDrawnWeapon; //1.0=easy, 1.5=normal, 2.0=hard, 4.0=realistic
var() name TargetPawn;

function Touch(actor instigator)
{
    local ScriptedPawn P;

    //super.Touch(instigator);
	foreach AllActors(class 'ScriptedPawn', P)
	{
		if(P.Name == TargetPawn)
            break;
	}
	if(P != none && P.Name == TargetPawn)  {
         P.bKeepWeaponDrawn = bDrawnWeapon;
         P.SetupWeapon(bDrawnWeapon, true);
    }
    GetPlayerPawn().ClientMessage("DrawWeapTriggered ");
}

function Trigger(Actor Other, Pawn Instigator)
{
    local ScriptedPawn P;

    //super.Touch(instigator);
	foreach AllActors(class 'ScriptedPawn', P)
	{
		if(P.Name == TargetPawn)
            break;
	}
	if(P != none && P.Name == TargetPawn)  {
         P.bKeepWeaponDrawn = bDrawnWeapon;
         P.SetupWeapon(bDrawnWeapon, true);
    }
    //GetPlayerPawn().ClientMessage("DrawWeapTriggered ");
}

defaultproperties
{
}
