//-----------------------------------------------------------
//The HUD-based map
//-----------------------------------------------------------
class HUDMapDisplay extends HUDCompassDisplay;

// ----------------------------------------------------------------------
// InitWindow()
// ----------------------------------------------------------------------

//var Class<WirelessOverlay> WirelessOverlays[20];
var float MapTopX;
var float MapTopY;
var float MapWidth;
var float MapHeight;

var texture texWireless;
var texture texLocation;
var texture texSniffer[3];
var int CurSniffTex;
var int SniffYMod;
var int SniffXMod;
var float LastSniffUpdate;
var float LastPacketTime;
var float AlertTime;
var float KillTimer;
var SolarCoat PlayerGPS;

event InitWindow()
{
	Super.InitWindow();

	Hide();

	player = DeusExPlayer(DeusExRootWindow(GetRootWindow()).parentPawn);

    //changed to 200 200
	//SetSize(256, 256);
	SetSize(500, 400);

	clipWidthHalf = clipWidth / 2;

	GetMapTrueNorth();
	CreateCompassWindow();
	CurSniffTex=0;
    ResetPacketTime();
}

function Tick(float deltaSeconds)
{
    //testint += 1;
    LastSniffUpdate += deltaSeconds;
    LastPacketTime += deltaSeconds;
    if(LastSniffUpdate > 0.1)
    {
        LastSniffUpdate=0;
        AlertTime += 0.1;
        CurSniffTex++;
        if(CurSniffTex>2)
        {
            CurSniffTex=0;
        }

    }
}

// ----------------------------------------------------------------------
// CreateCompassWindow()
// ----------------------------------------------------------------------

function CreateCompassWindow()
{

}

// ----------------------------------------------------------------------
// CreateTickWindow()
// ----------------------------------------------------------------------

function Window CreateTickWindow(Window winParent)
{
	return none;
}

function SetMap()
{
	//level 1
    if(player == none || player.GetLevelInfo() == none)
              return;
	if(player.GetLevelInfo().MapName == "50_t"){
        texBackground=Texture'DXModUI.UserInterface.D10Map';
        MapTopX=-19167;
        MapTopY=-7691;
        MapWidth=-75.7;
        MapHeight=-75.9;
    }
    else
    {
        texBackground=none;
        player.ClientMessage("This Level Has No Map!");
    }
    //player.ClientMessage("Setting Map");

}

//Have nearby soldier drones close in on the player's position
function DroidsCloseIn()
{
    local ScriptedPawn enem;
    local int EnemsGoing;      //Don't send everyone

    if( PlayerGPS == none)
    {
        PlayerGPS = Player.Spawn( class'SolarCoat',none,'PlayerGPS');
        PlayerGPS.SoundVolume = 0;
        PlayerGPS.PickupViewScale = 0;
        PlayerGPS.DrawScale = 0;
        PlayerGPS.Tag = 'PlayerGPS';
        PlayerGPS.bHidden = true;
        PlayerGPS.LandSound = none;
        PlayerGPS.SetCollision(false,false,false);

    }
    PlayerGPS.Tag = 'PlayerGPS';
    PlayerGPS.SetBase(none);
    PlayerGPS.SetOwner(none);
    PlayerGPS.SetLocation(Player.Location);

	foreach Player.RadiusActors(Class'ScriptedPawn', enem, 4000)
	{

	    if(enem.IsA('ModMJ12Troop') && enem.Orders == 'Patrolling' && EnemsGoing < 2)
	    {
    	    //Player.ClientMessage("Seeking Time");
    	    //enem.Enemy = Player;
    	    ModScriptedPawn(enem).InitConverging();
    	    enem.SetOrders('RunningTo', PlayerGPS.Tag, true);
    	    //enem.GotoState('Seeking');
    	    //enem.destLoc = Player.Location;
    	    EnemsGoing ++;
	    }
    }

}

// ----------------------------------------------------------------------
// PostDrawBackground()
// ----------------------------------------------------------------------

function DrawBackground(GC gc)
{
	gc.SetStyle(backgroundDrawStyle);
	gc.SetTileColorRGB(255,255,255);
	//gc.SetTileColor(colBackground);
	//gc.DrawTexture(11, 6, 60, 19, 0, 0, texBackground);

	//if you have the map downloaded, you get to see it.
	gc.DrawTexture(0, 0, 256, 256, 0, 0, texBackground);
}

// ----------------------------------------------------------------------
// VisibilityChanged()
// ----------------------------------------------------------------------

function VisibilityChanged(bool bNewVisibility)
{
    super.VisibilityChanged(bNewVisibility);
    //SetMap();
}

// ----------------------------------------------------------------------
// PostDrawBackground()
// ----------------------------------------------------------------------

function PostDrawBackground(GC gc)
{
    /*
    local float mapX, mapY;
    //figure out where to draw the player's position on the map
    mapX = -19167 - player.Location.X;
    mapY = -7691 - player.Location.Y;
    mapX = mapX / 74.7;
    mapY = mapY / 74.5;

	// Draw the tick box
	gc.SetTileColor(colBackground);
	gc.SetStyle(DSTY_Masked);
	gc.DrawTexture(mapX, mapY, 20, 20, 0, 0, texTickBox);    */

	//Test
    //gc.DrawText(200, 200, 100, 40, testint);
}

function ResetPacketTime()
{
    LastPacketTime = RandRange(0,2);
}

function ResetAlertTime()
{
    AlertTime = 0;
}

// ----------------------------------------------------------------------
// PostDrawBorder()
// ----------------------------------------------------------------------

function DrawBorder(GC gc)
{
    local float mapX, mapY;
    local MapLocation M;
    local WirelessOverlay W;
    local ScriptedPawn P;
    local SearcherDestroyer SD;
    //Player.ClientMessage("MapDisplay DrawBorder");
    //figure out where to draw the player's position on the map
    mapX = mapTopX - player.Location.X;
    mapY = mapTopY - player.Location.Y;
    mapX = mapX / MapWidth;
    mapY = mapY / MapHeight;

	// Draw the player blip
	gc.SetTileColorRGB(255,255,0);
	gc.SetStyle(DSTY_Masked);
	gc.DrawTexture(mapX-4, mapY-4, 10, 10, 0, 0, texBorder);

    //Draw map locations
    gc.SetTileColorRGB(65,255,227);
    gc.SetTextColorRGB(65,255,227);
	foreach player.AllActors(class'MapLocation', M)
	{
       //if(VSize(W.Location-Player.Location) < 950)
       //     W.bHidden=false;
       // else
       //     W.bHidden=true;

        if(M.bBroadcasting) {

            mapX = mapTopX - M.Location.X;
            mapY = mapTopY - M.Location.Y;
            mapX = mapX / MapWidth;
            mapY = mapY / MapHeight;
           	gc.DrawTexture(mapX-12, mapY-14, 16, 16, 0, 0, texLocation);
           	gc.DrawText(mapX, mapY-2, 100, 40, M.LocationName);
        }
    }

    //Draw wireless overlays
    gc.SetTileColorRGB(0,255,0);
    gc.SetTextColorRGB(0,255,0);
	foreach player.AllActors(class'WirelessOverlay', W)
	{
       //if(VSize(W.Location-Player.Location) < 950)
       //     W.bHidden=false;
       // else
       //     W.bHidden=true;

        if(!W.bHideMe && W.bBroadcasting) {

            mapX = mapTopX - W.Location.X;
            mapY = mapTopY - W.Location.Y;
            mapX = mapX / MapWidth;
            mapY = mapY / MapHeight;
            if( W.bAlerted )
                gc.SetTileColorRGB(255,0,0);
           	gc.DrawTexture(mapX-6, mapY-14, 16, 16, 0, 0, texWireless);
           	gc.DrawText(mapX+4, mapY, 100, 40, W.NetworkName);
           	if(W.bSniffing)
           	{
       	        if(LastPacketTime > 6-Player.SkillSystem.GetSkillLevel(class'SkillComputer') )
                {
                    ResetPacketTime();
                    //if(Rand(20) < 2 * (Player.SkillSystem.GetSkillLevel(class'SkillComputer')+1) )
                    //{
                        W.AddPacket();
                    //}
                   // if(Rand(1+Player.SkillSystem.GetSkillLevel(class'SkillComputer')*3) < 2  )
                   // {
                   //     if(W.Toughness > 0)
                   //         W.Alert(true, Player);
                   // }
                }
                if(AlertTime > 0.5 && Player.SkillSystem.GetSkillLevel(class'SkillComputer') < 3){
                    if(W.bAlerted)
                    {
                        KillTimer -= 0.5;
                        if(KillTimer <= 0)
                        {
                            DroidsCloseIn();
                            //YOU DIE NOW FOOL  - bring the drones
                            foreach Player.AllActors(class'SearcherDestroyer',SD)
                            {
                                if(!SD.IsInState('PreSearching') && !SD.IsInState('Searching') && !SD.IsInState('Destroying'))
                                    break;
                            }
                            //Player.ClientMessage("YOU DIE NOW BITCH");
                            if(!SD.IsInState('PreSearching') && !SD.IsInState('Searching') && !SD.IsInState('Destroying'))
                                SD.GotoState('PreSearching');
                        }
                    }
                    if(W.PacketsSniffed>1 &&
                    Rand(70) < 8-(2*Player.SkillSystem.GetSkillLevel(class'SkillComputer')))
                        if(W.Toughness > 0)
                        {
                            if(Rand(10)<5)
                            {
                                if(Rand(10)<5)
                                {
                                    if(!SD.IsInState('PreSearching') && !SD.IsInState('Searching') && !SD.IsInState('Destroying'))
                                        SD.GotoState('PreSearching');
                                }
                                else
                                {
                                     DroidsCloseIn();
                                }
                            }
                            W.Alert(true, Player);
                            if(KillTimer <= 0)
                                KillTimer=2+Rand(2);         //You gonna die soon
                        }
                    AlertTime=0;
                }
                gc.DrawText(mapX-50, mapY+75, 200, 40, "Sniffing " $ W.NetworkName $ " Wireless with DreamCacher...");

                if(W.bAlerted)
                {
                    gc.SetTextColorRGB(255,0,0);
                    gc.DrawText(mapX-50+SniffXMod, mapY+180+SniffYMod, 250, 40, "TARGET ALERTED - CEASE IMMEDIATELY!!!");

                }
                if(W.MaxedPackets())
                    gc.DrawText(mapX-50+SniffXMod, mapY+170+SniffYMod, 150, 40, W.PacketsSniffed $ " packets captured");
                else
                    gc.DrawText(mapX-50+SniffXMod, mapY+170+SniffYMod, 150, 40, W.PacketsSniffed $ " packets captured (MAX)");

                if(CurSniffTex==0)
                    gc.DrawText(mapX-50+SniffXMod, mapY+105+SniffYMod, 120, 60, "ad 14 97 9f a7 39 d4 1e b8 7d 30 77 bd fe 5f 40 5c 08 ac e7 9f 09 60 d2 58 5f f6 7a 93 4d 06 e6 a9 ee f3");
                else if(CurSniffTex==1)
                    gc.DrawText(mapX-50+SniffXMod, mapY+105+SniffYMod, 120, 60, "6f cb 84 a0 6e 9a f4 73 01 6a 4b 36 76 6b 83 9b 71 75 01 0e 5e 26 41 e2 da 1c 97 a0 5b 77 e8 5d 5f f6 7a");
                else
                    gc.DrawText(mapX-50+SniffXMod, mapY+105+SniffYMod, 120, 60, "88 b1 b8 0a 22 bf af e4 c9 37 89 6e 8a 7b 6f 76 64 26 9a 6d f0 90 fe f7 a5 3a a3 2f ba 49 08 79 1c 97 a0");

                gc.SetTileColorRGB(255,255,255);
                gc.SetStyle(DSTY_Translucent);
               	gc.DrawTexture(mapX, mapY, 64, 64, 0, 0, texSniffer[CurSniffTex]);
               	gc.DrawTexture(mapX+64, mapY, 64, 64, 0, 0, texSniffer[CurSniffTex]);
               	gc.DrawTexture(mapX-64, mapY, 64, 64, 0, 0, texSniffer[CurSniffTex]);



           	}

           	gc.SetTileColorRGB(0,255,0);
        }
    }

    //Draw pawns
    gc.SetTileColorRGB(255,255,255);
    foreach player.RadiusActors(Class'ScriptedPawn', P, 4000)
    {
            if(!P.IsA('Animal') && Player.AICanSee(P, 1.0, false, false, true, true) > 0.0){
                mapX = mapTopX - P.Location.X;
                mapY = mapTopY - P.Location.Y;
                mapX = mapX / MapWidth;
                mapY = mapY / MapHeight;
               	gc.DrawTexture(mapX-4, mapY-4, 10, 10, 0, 0, texBorder);
           	}
    }


}

defaultproperties
{
     texWireless=Texture'DXModUI.UserInterface.wirelessBlip'
     texLocation=Texture'DXModUI.UserInterface.locationBlip'
     texSniffer(0)=Texture'DXModUI.UserInterface.Sniff1'
     texSniffer(1)=Texture'DXModUI.UserInterface.Sniff2'
     texSniffer(2)=Texture'DXModUI.UserInterface.Sniff3'
     SniffYMod=-178
     SniffXMod=120
     texBackground=None
     texBorder=Texture'DXModUI.UserInterface.playerBlip'
}
