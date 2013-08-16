//-----------------------------------------------------------
//
//-----------------------------------------------------------
class SchematicManager extends Actor;
	//intrinsic;
#exec obj load file=DXModUI
#exec obj load file=DXModWeapons
// which player am I attached to?
var DeusExPlayer Player;
var class<Schematic> Schematics[99];
var travel Schematic FirstSchematic;		// Pointer to first Schematic

function SetPlayer(DeusExPlayer pl)
{
    Player = pl;
}

function Schematic GetSchematic(name schemClass)
{
    local Schematic schem;

    schem = FirstSchematic;

    while(schem != none)   {
        if(schem.IsA(schemClass))
        {
            break;
        }
        schem = schem.next;
    }

   if(schem == none)
       return none;
   return schem;
    //return schem;
}

function Schematic GetSchemByProduct(class<Inventory> schemClass)
{
    local Schematic schem;

    schem = FirstSchematic;

    while(schem != none)   {
        if(schem.product == schemClass)
        {
            break;
        }
        schem = schem.next;
    }

   if(schem == none)
       return none;
   return schem;
    //return schem;
}

function CreateSchematics()
{
    local int i;
    local Schematic schem;
	local Schematic lastSchem;
   	FirstSchematic = None;
	schem  = None;

    for(i=0; Schematics[i] != none; i++)
    {
        schem = Spawn(Schematics[i], Self);
        schem.player = player;
    	// Manage our linked list
    	if (schem != None)
    	{
    		if (FirstSchematic == None)
    		{
    			FirstSchematic = schem;
    		}
    		else
    		{
    			LastSchem.next = schem;
    		}

    		LastSchem  = schem;
      	}
      	//Player.ClientMessage(schem.product);
   	}
   	LastSchem.next=none;

}

defaultproperties
{
     Schematics(0)=Class'DXMod.SolarCoatSchem'
     Schematics(1)=Class'DXMod.VoltearSchem'
     Schematics(2)=Class'DXMod.EMPGunSchem'
     Schematics(3)=Class'DXMod.IEDSchem'
     Schematics(4)=Class'DXMod.CellPhoneSchem'
     Schematics(5)=Class'DXMod.LockpickSchem'
     Schematics(6)=Class'DXMod.BioluxSchem'
     Schematics(7)=Class'DXMod.FasfoodSchem'
     Schematics(8)=Class'DXMod.PetriSchem'
     Schematics(9)=Class'DXMod.FasfoodCultSchem'
     Schematics(10)=Class'DXMod.MultitoolSchem'
     Schematics(11)=Class'DXMod.GunpowderSchem'
     Schematics(12)=Class'DXMod.Slugs10mmSchem'
     Schematics(13)=Class'DXMod.Ammo10mmSchem'
     Schematics(14)=Class'DXMod.AmmoDartSchem'
     Schematics(15)=Class'DXMod.AmmoShellSchem'
     Schematics(16)=Class'DXMod.CrossbowSchem'
     Schematics(17)=Class'DXMod.OldCameraSchem'
     Schematics(18)=Class'DXMod.CharcoalSchem'
     Schematics(19)=Class'DXMod.ScopeSchem'
     Schematics(20)=Class'DXMod.PoisonDartSchem'
     Schematics(21)=Class'DXMod.RemedySchem'
     Schematics(22)=Class'DXMod.QuadSchem'
     Schematics(23)=Class'DXMod.SilverCoatSchem'
     Schematics(24)=Class'DXMod.BinocSchem'
     Schematics(25)=Class'DXMod.ProdSchem'
     Schematics(26)=Class'DXMod.FasfoodSchem'
     Schematics(27)=Class'DXMod.FireResSchem'
     Schematics(28)=Class'DXMod.NohfaceSchem'
     Schematics(29)=Class'DXMod.SabotSchem'
     Schematics(30)=Class'DXMod.BackpackSchem'
     Schematics(31)=Class'DXMod.SousveillerSchem'
     bHidden=True
     bTravel=True
}
