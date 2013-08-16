//-----------------------------------------------------------
//
//-----------------------------------------------------------
class SoundTrigger expands Trigger;

var() sound      Sound;          // For PlaySoundEffect state.
var() float     Volume;          // For PlaySoundEffect state.
var() float      Radius;          // For PlaySoundEffect state.

//-----------------------------------------------------------------------------
// Functions.

function Trigger( actor Other, pawn EventInstigator )
{
    PlaySound(Sound,,volume,,radius);
}

defaultproperties
{
     Volume=128.000000
     Radius=128.000000
}
