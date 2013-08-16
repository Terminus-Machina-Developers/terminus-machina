//=============================================================================
// ShopTrigger.
//=============================================================================
class ShopTrigger expands Trigger;

#exec OBJ LOAD FILE=EOTPPLAYER

var DeusExPlayer player;

struct SubStruct
	{
	var() class<Inventory> Item;
	var() int stock, cost;
	};

struct Sub
	{
	var() SubStruct Items[8];
	};

var() Sub Melee;
var() Sub Pistols;
var() Sub Rifles;
var() Sub Heavy;
var() Sub Demolition;
var() Sub Ammo;
var() Sub Equipment;

var() string ShopTitle;

function Trigger(Actor Other, Pawn Instigator)
{
    local FlagBase flags;
	player = DeusExPlayer(GetPlayerPawn());
	// it would be a bit silly if we were to shop while...
	if (!player.IsInState('Dying') && !player.IsInState('Parayzed') &&
		!player.IsInState('Jumping') && !player.IsInState('Conversation') &&
		!player.IsInState('Interpolating') && !player.IsInState('PlayerSwimming'))
		{

            flags = player.FlagBase;
    		if (flags != None)
    		{
    			// Don't delete expired flags if we just loaded
    			// a savegame
    			//Player.ClientMessage("SELL FLAG = " $ flags.GetBool('Sell'));
    			if (flags.GetBool('Sell')) {
    			    ModMale(player).SellInterface();
    			    //Player.ClientMessage("SELL FLAG TRUE");
    			    return;
    			}
    			else
    			{
    			    //Player.ClientMessage("SELL FLAG FALSE");
    			    ModMale(player).ShowShop(Self);
    			    return;
    			}


    		}
    		else
    		{
    	         ModMale(player).ShowShop(Self);
    		}
  		}
}

defaultproperties
{
     bCollideActors=False
}
