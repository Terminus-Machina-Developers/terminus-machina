//-----------------------------------------------------------
// For having brushes give out items
//-----------------------------------------------------------
class ScrapDispenser extends DeusExDecoration;

var(ScrapDispenser) class<Inventory> GiveItems[10];
var (ScrapDispenser) Actor RealItem;
var (ScrapDispenser) bool bMakePushable;

var travel bool bScrapped;
var(ScrapDispenser) string NewItemName;
var(ScrapDispenser) bool bDontShow;

function PostBeginPlay()
{
   super.PostBeginPlay();
   //if(NewItemName != "")
   //    ItemName = NewItemName;
   if(bDontShow)
       DrawType = DT_None;
}

function Frob(actor Frobber, Inventory frobWith)
{
	local DeusExPlayer player;
	local Vector loc;
	local Pickup product;
	local int i;
	local actor A, Toucher;

	//Super.Frob(Frobber, frobWith);

	player = DeusExPlayer(Frobber);
	if (player != none && bScrapped)
	{
	    if(player != none)
	        Super.Frob(Frobber, frobWith);
	}

	if (player != none && !bScrapped)
	{
	    PlaySound(sound'DXModSounds.Misc.Scrap');
	    bScrapped=true;
	    for(i=0; GiveItems[i] != none; i++)
        {
            Player.FrobTarget = Spawn(GiveItems[i],,,Player.Location);
            Player.ParseRightClick();

	        //Spawn(GiveItems[i],,,Player.Location).Frob(Player,none);
         }
         if(NewItemName != "")
             ItemName=NewItemName;
         //self.SetCollision(false,false,false);
         if(bMakePushable)
         {
             bPushable=true;
         }
         if(RealItem != none)
         {
             RealItem.SetCollision(true,true,true);
         }
	}

	if (Event!='')
    {
		foreach AllActors( class 'Actor', A, Event )
			A.Trigger( Frobber, pawn(Frobber) );
    }
}

defaultproperties
{
     bCanBeBase=True
     ItemName="Scrap for parts"
     bPushable=False
     Physics=PHYS_None
     Mesh=LodMesh'DeusExDeco.VendingMachine'
     CollisionRadius=34.000000
     CollisionHeight=50.000000
	 Mass=50.000000
}
