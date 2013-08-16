//-----------------------------------------------------------
//
//-----------------------------------------------------------
class ModInterpolateTrigger extends InterpolateTrigger;

function bool SendActorOnPath()
{
	local ModInterpolationPoint I;
	local Actor A;

	// find the target actors to start on the path
	foreach AllActors (class'Actor', A, Event)
		if ((A != None) && !A.IsA('ModInterpolationPoint'))
		{
			foreach AllActors (class'ModInterpolationPoint', I, A.Event)
			{
				if (I.Position == 1)		// start at 1 instead of 0 - put 0 at the object's initial position
				{
					A.SetCollision(False, False, False);
					A.bCollideWorld = False;
					A.Target = I;
					A.SetPhysics(PHYS_Interpolating);
					A.PhysRate = 1.0;
					A.PhysAlpha = 0.0;
					A.bInterpolating = True;
					A.bStasis = False;
					A.GotoState('Interpolating');
					break;
				}
			}
		}

	return True;
}

defaultproperties
{
}
