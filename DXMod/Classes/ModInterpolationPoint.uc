//-----------------------------------------------------------
//
//-----------------------------------------------------------
class ModInterpolationPoint extends InterpolationPoint;

// not sure what's wrong with this but pawns keep falling through the level at end
//
function InterpolateEnd( actor Other )
{
	if( bEndOfPath )
	{
		if( Pawn(Other)!=None )//&& Pawn(Other).bIsPlayer )
		{
			Other.bCollideWorld = True;
			Other.bInterpolating = false;
			if ( Pawn(Other).Health > 0 )
			{
				Other.SetCollision(true,true,true);
				Other.SetPhysics(PHYS_Falling);
				Other.AmbientSound = None;
				// DEUS_EX CNN - removed by CNN - don't change the player state
				// the player will handle that itself

			}
		}
		else if (Other != None)
		{
			// DEUS_EX - added by CNN - lets non players interpolate also
			Other.bInterpolating = False;
			Other.SetPhysics(PHYS_Falling);
		}
	}
}

defaultproperties
{
}
