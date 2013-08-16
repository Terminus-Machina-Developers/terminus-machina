//-----------------------------------------------------------
//   SearcherDestroyer for cutscenes.
//-----------------------------------------------------------
class SDProp expands SearcherDestroyer;

var() name MissileTarget;

state Waiting
{
	function BeginState()
	{
	    //GetPlayerPawn().ClientMessage("Entering Waiting State");
	    bHidden=false;
	    AmbientSound=Sound'DXModSounds.Misc.SearcherDestroyer';
	    //GotoState('Searching');
    }

}

function Trigger(Actor Other, Pawn Instigator)
{
    FireMissilesAt(MissileTarget);

}

//Blow some shit up
function FireMissilesAt(name targetTag)
{
	local int i;
	local Vector loc;
	local SearcherDestroyer chopper;
	//local RocketLAW rocket;
	local RocketDrone rocket;
	local Actor A, Target;



	foreach AllActors(class'Actor', A, targetTag)
		Target = A;

    if(Target == none)
    {
         GetPlayerPawn().ClientMessage("Searcher Destroyer can't find target");
         return;
    }
    chopper = self;
	// fire missiles from the helicopter
	//foreach AllActors(class'BlackHelicopter', chopper, 'chopper')
	//{
	    //ClientMessage("Making Rocket");
 	/*
		for (i=-1; i<=1; i+=2)
		{

			loc = (i*chopper.CollisionRadius * vect(0,0.15,0)) >> chopper.Rotation;
            loc += chopper.Location;
			rocket = Spawn(class'RocketDrone', none,, loc, chopper.Rotation);
            if (rocket != None)
			{
			    //ClientMessage("RocketMade");
				rocket.bTracking = True;
				rocket.Target = Target;
				rocket.PlaySound(sound'RocketIgnite', SLOT_None, 2.0,, 2048);
			}
		}
	*/
		for (i=-1; i<=1; i+=2)
		{
			loc = (i*chopper.CollisionRadius * vect(0,0.15,0)) >> chopper.Rotation;
			loc += chopper.Location;
			//loc.X += 400;
			rocket = Spawn(class'RocketDrone', chopper,, loc, chopper.Rotation);
			if (rocket != None)
			{
				rocket.bTracking = True;
				rocket.Target = Target;
				rocket.PlaySound(sound'RocketIgnite', SLOT_None, 2.0,, 2048);
			}
		}

	//}
}

defaultproperties
{
}
