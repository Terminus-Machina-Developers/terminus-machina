//-----------------------------------------------------------
// Messes up all enemies of a certain type within a vicinity
//-----------------------------------------------------------
class AIDisruptor extends Trigger;

var(AIDisruptor) float DisruptRadius;
var(AIDisruptor) string DisruptAlliance;
var(AIDisruptor) float StunDuration;

// if we are triggered, turn us on
function Trigger(Actor Other, Pawn Instigator)
{
     local DeusExPlayer Player;
     local ScriptedPawn P;
     Player = DeusExPlayer(GetPlayerPawn());
     foreach Player.RadiusActors(class'ScriptedPawn',P,DisruptRadius)
     {
         if(string(P.Alliance) == DisruptAlliance)
         {
             if(P.IsA('ModRobot'))
             {
                 //P.TakeDamage(1000,Player,Location,vect(0,0,0),'EMP');
                 ModScriptedPawn(P).StunFor(StunDuration);
             }
             else if(P.IsA('ModScriptedPawn'))
             {
                 ModScriptedPawn(P).StunFor(StunDuration); //GotoState('stunned');
             }
         }
     }

}

defaultproperties
{
     DisruptRadius=4000.000000
     StunDuration=5.000000
     CollisionRadius=0.000000
     CollisionHeight=0.000000
     bCollideActors=False
}
