//-----------------------------------------------------------
//
//-----------------------------------------------------------
class MapLocation extends Trigger;

//-----------------------------------------------------------
//  Locations within the in-HUD map
//-----------------------------------------------------------


var bool bHideMe;              //Hide and unhide when player switches on.
var bool bARon;                //if player's Augmented Reality is on
var(MapLocation) bool bBroadcasting;        //whether this Wireless Node is active
var(MapLocation) bool bOpenMap;        //force open player map (if important signal)
var(MapLocation) string LocationName;
var(MapLocation) bool bToggleBroadcast;

event Touch( Actor Other )
{
    if(Other.IsA('DeusExPlayer')){
        //ModHUD(ModRootWindow(ModMale(Other).rootWindow).hud).mapDisplay.AddWireless(self);

        if(!bBroadcasting) {
            bBroadcasting=true;
            Other.PlaySound(Sound'DXModSounds.Misc.wireless', SLOT_None);
            DeusExPlayer(Other).ClientMessage("New Location: " $ LocationName $ " Added to GPS Map");
        }
    }
}
/*
event UnTouch( Actor Other )
{
    if(Other.IsA('DeusExPlayer')){
        bHideMe=true;
        bHidden=true;
        if(bBroadcasting){
            Other.PlaySound(Sound'DXModSounds.Misc.wireless2', SLOT_None);
            DeusExPlayer(Other).ClientMessage("Exited Wireless Signal");
        }
        //ModHUD(ModRootWindow(ModMale(Other).rootWindow).hud).mapDisplay.RemoveWireless(self);

    }
}   */

function AugRealityOn(bool bOn)
{
    local DeusExPlayer DXP;
    bARon=bOn;
}

function Broadcast(bool bOn)
{
    local DeusExPlayer DXP;
    DXP = DeusExPlayer(GetPlayerPawn());
    bBroadcasting=bOn;
    if(bBroadcasting)
    {
        DXP.ClientMessage("New Location: " $ LocationName $ " Added to GPS Map");
        DXP.PlaySound(Sound'DXModSounds.Misc.wireless', SLOT_None);

    }
    else
    {

    }
}

// ----------------------------------------------------------------------
// Trigger()
//
// if we are discovered, switch us on
// ----------------------------------------------------------------------

function Trigger(Actor Other, Pawn Instigator)
{
    local DeusExPlayer DXP;
    DXP = DeusExPlayer(GetPlayerPawn());
    if(!bBroadcasting)
    {
        if(bOpenMap){
           if(!DXP.bCompassVisible)   {
               DXP.ToggleCompass();
               DXP.bCompassVisible = true;
           }
        }
        bBroadcasting = true;
        Broadcast(bBroadcasting);
    }
    else if(bToggleBroadcast)
    {
        bBroadcasting = false;
    }

    //Super.Trigger(Other, Instigator);

}

defaultproperties
{
     bBroadcasting=True
     bOpenMap=True
     LocationName="Tartarus"
     CollisionRadius=2000.000000
     CollisionHeight=950.000000
}
