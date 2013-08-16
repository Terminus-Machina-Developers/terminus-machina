//-----------------------------------------------------------
//
//-----------------------------------------------------------
class FlashViewTrigger expands Trigger;

var() float flashTime;
var() vector flashColor;

// if we are triggered, turn us on
function Trigger(Actor Other, Pawn Instigator)
{
     local DeusExPlayer DXP;
     DXP = DeusExPlayer(GetPlayerPawn());
	//DXP.ClientMessage("FlashView");
	if(DXP != none)
	{
	    DXP.ClientFlash( flashTime, flashColor);
    //ClientFlash(6, vect(5000,5000,5000));
	}

}


singular function Touch(Actor Other)
{
	if (!IsRelevant(Other))
		return;

	Super.Touch(Other);
	//FadeView();
}

defaultproperties
{
     FlashTime=5.000000
}
