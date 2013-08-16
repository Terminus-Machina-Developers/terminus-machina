//-----------------------------------------------------------
//
//-----------------------------------------------------------
class GiveImageTrigger expands Trigger;

var() class<Schematic> Schematics[10];
var() String Images[10];
var() class<PhaceBookFace> Phaces[10];

// if we are triggered, turn us on
function Trigger(Actor Other, Pawn Instigator)
{
     local ModMale ModM;
     local int i;
      ModM = ModMale(GetPlayerPawn());
	if(ModM != none)
	{
	    i = 0;
	    While(Schematics[i] != none)
	    {
            ModM.GetSchem(Schematics[i]);
            i++;
        }
	    i = 0;
	    While(Phaces[i] != none)
	    {
            ModM.AddPhace(spawn(Phaces[i]));
            i++;
        }
	}

}


singular function Touch(Actor Other)
{
	if (!IsRelevant(Other))
		return;

    Trigger(Other,none);
	Super.Touch(Other);
	//FadeView();
}

defaultproperties
{
}
