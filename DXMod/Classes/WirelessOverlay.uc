//-----------------------------------------------------------
//  Visualizations of wireless nodes
//-----------------------------------------------------------
class WirelessOverlay extends Actor;//DeusExDecoration;

var mesh BigMesh;
var bool bHideMe;              //Hide and unhide when player switches on.
var bool bARon;                //if player's Augmented Reality is on
var bool bSniffing;            //Player is sniffing this node
var bool bCracked;             //Player decrypted
var(WirelessOverlay) bool bBroadcasting;        //whether this Wireless Node is active
var(WirelessOverlay) bool bOpenMap;        //force open player map (if important signal)
var(WirelessOverlay) string NetworkName;  //Name to show
var(WirelessOverlay) string NetworkAddress;  //Address to show
var(WirelessOverlay) string CompName;    //associated computer for logging in
var(WirelessOverlay) texture Logo;
var(WirelessOverlay) string Protocol;  //Protocol type of the network
var(WirelessOverlay) string Security;  //Security type of the network
var(WirelessOverlay) string Packets[20];         //Packets to displayvar(WirelessOverlay) string Packets[20];         //Packets to display
var(WirelessOverlay) int Alg;             //The decryption algorithm to crack
var(WirelessOverlay) int Table;           //The decryption table to crack
var(WirelessOverlay) int CurAlg;          //Current Alg player using
var(WirelessOverlay) int CurTable;        //Current table player using
var int PacketsSniffed;        //How many packets the player captured
var bool bAlerted;             //Owner is alerted to intrusion
var float CoolDuration;
var float CoolTimer;
var(WirelessOverlay) int Toughness;           //how hard it is to hack this network
var bool bEntered;

#exec OBJ LOAD FILE=DXModSounds
#exec mesh IMPORT MESH=WirelessOverlay ANIVFILE=MODELS\WirelessOverlay_a.3d DATAFILE=MODELS\WirelessOverlay_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=WirelessOverlay X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=WirelessOverlay SEQ=All STARTFRAME=0 NUMFRAMES=30
//#exec MESH SEQUENCE MESH=WirelessOverlay SEQ=??? STARTFRAME=0 NUMFRAMES=30

#exec MESHMAP NEW MESHMAP=WirelessOverlay MESH=WirelessOverlay
#exec MESHMAP scale MESHMAP=WirelessOverlay X=50 Y=50 Z=100

#exec texture IMPORT NAME=GreenSquare FILE=Textures\GreenSquare.pcx GROUP=Skins FLAGS=256
#exec texture IMPORT NAME=GreenSquare FILE=Textures\GreenSquare.pcx GROUP=Skins PALETTE=GreenSquare
#exec MESHMAP SETTEXTURE MESHMAP=WirelessOverlay NUM=1 TEXTURE=GreenSquare
#exec MESHMAP SETTEXTURE MESHMAP=WirelessOverlay NUM=2 TEXTURE=GreenSquare


#exec mesh IMPORT MESH=WirelessOverlaySmall ANIVFILE=MODELS\WirelessOverlay_a.3d DATAFILE=MODELS\WirelessOverlay_d.3d X=0 Y=0 Z=0
#exec mesh ORIGIN MESH=WirelessOverlaySmall X=0 Y=0 Z=0

#exec mesh SEQUENCE MESH=WirelessOverlaySmall SEQ=All STARTFRAME=0 NUMFRAMES=30
//#exec MESH SEQUENCE MESH=WirelessOverlay SEQ=??? STARTFRAME=0 NUMFRAMES=30

#exec MESHMAP new MESHMAP=WirelessOverlaySmall MESH=WirelessOverlaySmall
#exec MESHMAP scale MESHMAP=WirelessOverlaySmall X=0.5 Y=0.5 Z=1

#exec texture IMPORT NAME=GreenSquareDark FILE=Textures\GreenSquareDark.pcx GROUP=Skins FLAGS=256
#exec texture IMPORT NAME=GreenSquareDark FILE=Textures\GreenSquareDark.pcx GROUP=Skins PALETTE=GreenSquare

#exec MESHMAP SETTEXTURE MESHMAP=WirelessOverlaySmall NUM=1 TEXTURE=GreenSquareDark
#exec MESHMAP SETTEXTURE MESHMAP=WirelessOverlaySmall NUM=2 TEXTURE=GreenSquareDark

/*
function TravelPostAccept()
{
    Super.TravelPostAccept();
    Alg = 1 + Rand(10);
    if(Alg < 3)
        Table = 5 + Rand(6);
    else
        Table = 1 + Rand(10);
}    */

function RandomAlgTable()
{
    Alg = 1 + Rand(10);
    if(Alg < 3)
        Table = 5 + Rand(6);
    else
        Table = 1 + Rand(10);
}

function PostBeginPlay()
{
    Style = STY_Translucent;
    Mesh=BigMesh;
    DrawScale=1;//CollisionRadius/940;
    SetCollision(false,false,false);

}

event Tick(float deltaTime)
{
    super.Tick(deltaTime);
    if(DistanceFromPlayer <= self.CollisionRadius)
    {
        if(!bEntered)
            DoEnter();
    } else
    {
        if(bEntered)
            DoLeave();
    }
}

function DoEnter()
{
    local Computers C;
    bEntered=true;
    //ModHUD(ModRootWindow(ModMale(Other).rootWindow).hud).mapDisplay.AddWireless(self);
    bHideMe=false;
    if(bARon && bBroadcasting)
    {
        bHidden=false;
    }
    if(bBroadcasting) {
        GetPlayerPawn().PlaySound(Sound'DXModSounds.Misc.wireless', SLOT_None);
        GetPlayerPawn().ClientMessage("Entered Wireless Signal");
    }

    //ConnectToNetwork(Other);

}

function DoLeave()
{

    local Computers C;
    GetPlayerPawn().ClientMessage("Untouched Wireless");
    bHideMe=true;
    bHidden=true;
    bEntered=false;
    if(bBroadcasting){
        GetPlayerPawn().PlaySound(Sound'DXModSounds.Misc.wireless2', SLOT_None);
        GetPlayerPawn().ClientMessage("Exited Wireless Signal");
    }
    //ModHUD(ModRootWindow(ModMale(Other).rootWindow).hud).mapDisplay.RemoveWireless(self);

    //Temp accessing computers remotely test
    foreach GetPlayerPawn().AllActors(class'Computers', C)
    {
        if( string(C.Name) == CompName )
            break;
    }
    if(string(C.Name) == CompName )
    {
        //C.curFrobber = DeusExPlayer(Other);
        C.CloseOut();
        GetPlayerPawn().ClientMessage("Exiting Computer");
    }
    else
    {
        GetPlayerPawn().ClientMessage("Couldn't find associated Comp");
    }
    StopSniffing(DeusExPlayer(GetPlayerPawn()));
}
/*
event Touch( Actor Other )
{
    local Computers C;
    if(Other.IsA('DeusExPlayer')){
        //ModHUD(ModRootWindow(ModMale(Other).rootWindow).hud).mapDisplay.AddWireless(self);
        bHideMe=false;
        if(bARon && bBroadcasting)
        {
            bHidden=false;
        }
        if(bBroadcasting) {
            Other.PlaySound(Sound'DXModSounds.Misc.wireless', SLOT_None);
            DeusExPlayer(Other).ClientMessage("Entered Wireless Signal");
        }

        //ConnectToNetwork(Other);
    }

}

event UnTouch( Actor Other )
{
    local Computers C;
    GetPlayerPawn().ClientMessage("Untouched Wireless");
    if(Other.IsA('DeusExPlayer')){
        bHideMe=true;
        bHidden=true;
        if(bBroadcasting){
            Other.PlaySound(Sound'DXModSounds.Misc.wireless2', SLOT_None);
            DeusExPlayer(Other).ClientMessage("Exited Wireless Signal");
        }
        //ModHUD(ModRootWindow(ModMale(Other).rootWindow).hud).mapDisplay.RemoveWireless(self);

        //Temp accessing computers remotely test
        foreach Other.AllActors(class'Computers', C)
        {
            if( string(C.Name) == CompName )
                break;
        }
        if(string(C.Name) == CompName )
        {
            //C.curFrobber = DeusExPlayer(Other);
            C.CloseOut();
            DeusExPlayer(Other).ClientMessage("Exiting Computer");
        }
        else
        {
            DeusExPlayer(Other).ClientMessage("Couldn't find associated Comp");
        }
        StopSniffing(DeusExPlayer(Other));
    }
}       */

function ConnectToNetwork(Actor Other)
{
    local Computers C;
    //if(CompName != "" )
    //{
        //Temp accessing computers remotely test
        foreach Other.AllActors(class'Computers', C)
        {
            if( string(C.Name) == CompName )
                break;
        }
        if(string(C.Name) == CompName )
        {
            //C.curFrobber = DeusExPlayer(Other);
            ModMale(Other).bWirelessConnection = true;
            C.Frob(Other, DeusExPlayer(Other).Inventory);
            DeusExPlayer(Other).ClientMessage("Frobbing Computer");
        }
        else
        {
            DeusExPlayer(Other).ClientMessage("Couldn't find associated Comp");
        }
    //}
}

function AugRealityOn(bool bOn)
{
    local DeusExPlayer DXP;
    bARon=bOn;
    if(bARon && bBroadcasting)
    {
        if(!bHideMe)
        {
            bHidden=false;
        }
    }
    else
    {
        bHidden=true;
    }
}

function Broadcast(bool bOn)
{
    local DeusExPlayer DXP;
    DXP = DeusExPlayer(GetPlayerPawn());
    bBroadcasting=bOn;
    if(bARon && bBroadcasting)
    {
        if(!bHideMe)
        {
            bHidden=false;
            if(DXP != none)
            {
                DXP.ClientMessage("Entered Wireless Signal");
                DXP.PlaySound(Sound'DXModSounds.Misc.wireless', SLOT_None);

            }

        }
    }
    else
    {
        GetPlayerPawn().ClientMessage("Exited Wireless Signal");
        bHidden=true;
    }
}

// ----------------------------------------------------------------------
// Trigger()
//
// if we are triggered then toggle our broadcasting on or off
// ----------------------------------------------------------------------

function Trigger(Actor Other, Pawn Instigator)
{
    local DeusExPlayer DXP;
    DXP = DeusExPlayer(GetPlayerPawn());
    bBroadcasting = !bBroadcasting;
    Broadcast(bBroadcasting);

    if(bBroadcasting && bOpenMap){
       if(!DXP.bCompassVisible)   {
           DXP.ToggleCompass();
           //DXP.bCompassVisible=true;
       }
    }

    //Super.Trigger(Other, Instigator);

}


//BeginSniffing - when player starts sniffing this wireless node for passwords
function BeginSniffing(DeusExPlayer Player)
{
    bSniffing=true;
    Player.AmbientSound=sound'DXModSounds.Sniffer';
    //Player.SoundVolume=100;
    //Player.PlaySound( sound'DXModSounds.Sniffer',,100,true);
}

function StopSniffing(DeusExPlayer Player)
{
    bSniffing=false;
    Player.AmbientSound = class'ModMale'.default.AmbientSound;

}

function AddPacket()
{
    local int i;
    for(i=0; i < PacketsSniffed && i < arrayCount(Packets); i++)
    {
        if(Packets[i] == "" || i == arrayCount(Packets))
        {
            return;
        }
    }
    if(PacketsSniffed < arrayCount(Packets) && Packets[i] != "")
    {
        PacketsSniffed++;
    }
}

function bool MaxedPackets()
{
    if(PacketsSniffed == arrayCount(Packets) || Packets[PacketsSniffed] != "")
        return true;
    else
        return false;
}

function Alert(bool doAlert, DeusExPlayer Player)
{
    if(doAlert) {
        bAlerted = true;
        SetTimer(CoolDuration, false);
        //CoolTimer=0;
        //GoToState('CoolingDown');
        Player.PlaySound(Sound'DXModSounds.Misc.SnifferAlert',,0.6);
    }
    else
    {
        bAlerted = false;
    }
}

function Timer()
{
    bAlerted=false;
}


/*
// Trigger is always active.
state() NormalTrigger
{
    event Tick(float DeltaTime)
    {
    }
}

state() CoolingDown
{
    event Tick(float DeltaTime)
    {
        CoolTimer += DeltaTime;
        GetPlayerPawn().ClientMessage("COOLING");
        if(CoolTimer >= CoolDuration)
        {
             GoToState('NormalTrigger');
        }
    }
} */

defaultproperties
{
     BigMesh=LodMesh'DXMod.WirelessOverlay'
     bHideMe=True
     bBroadcasting=True
     bOpenMap=True
     NetworkName="6G Network"
     Protocol="6G LTE"
     Security="WPA7"
     Packets(0)="CYBERSECHUB_DTEN  query dossiers.gnossis.com xdatamine? missentropy"
     Packets(1)="GNOSSIS_88584732   response profile=missentropy hash=7jd61bdz"
     Packets(2)="CYBERSECHUB_DTEN  recset justicenet.net missentropy -wanted -GPSunknown"
     Packets(3)="JUSTICENET_PRIME    courtorder cybersec.net missentropy -liquidate"
     Packets(4)="CYBERSEC_TROUB07  auth cybersec.net username=jdarius&password=machiavelli"
     Packets(5)="CYBERSECHUB_DTEN  conf troubleshooter07 authentication_successful"
     Packets(6)="CYBERSEC_TROUB07   query cybersec.net/sf/d10/maintenance -whitepanther -d"
     Alg=3
     Table=5
     CurAlg=1
     CurTable=1
     CoolDuration=20.000000
     Toughness=1
     bHidden=True
     AnimSequence=Dead
     AnimFrame=0.900000
     DrawType=DT_Mesh
     Style=STY_Translucent
     Texture=Texture'Engine.S_Corpse'
     Mesh=LodMesh'DXMod.WirelessOverlaySmall'
     ScaleGlow=0.500000
     bAlwaysRelevant=True
     bGameRelevant=True
     CollisionRadius=950.000000
     CollisionHeight=950.000000
     Mass=180.000000
     Buoyancy=105.000000
}
