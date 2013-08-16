//-----------------------------------------------------------
//
//-----------------------------------------------------------
class GramChip expands DeusExPickup;

var() class<Schematic> Schematics[10];
var() String Images[10];
var() String Phaces[10];

state Activated
{
	function Activate()
	{
		// can't turn it off
	}

	function BeginState()
	{
        local ModMale ModM;
        local int i;

		Super.BeginState();

        ModM = ModMale(GetPlayerPawn());

    	if(ModM != none)
    	{
            //ModM.EatFood(0.1);
    	    i = 0;
    	    While(Schematics[i] != none)
    	    {
                ModM.GetSchem(Schematics[i]);
                i++;
            }
    	}
		UseOnce();
	}
Begin:
}

function bool HandlePickupQuery( inventory Item )
{
    local GramChip C;
    local int i;

    if (item.IsA('GramChip')) C = GramChip(Item);

    if (C != None)
    if (C.Class == Self.Class)
    {
    for(i=0; i<10; i++)
    {
    if (C.Schematics[i] != Schematics[i] || C.Images[i] != Images[i] || C.Phaces[i] != Phaces[i]) return false;
    }
    }

    else
    return Super.HandlePickupQuery(Item);
}

defaultproperties
{
     maxCopies=20
     bCanHaveMultipleCopies=True
     bActivatable=True
     ItemName="gRAM Chip"
     PlayerViewMesh=LodMesh'DXModItems.FlatItem'
     PlayerViewScale=0.300000
     PickupViewMesh=LodMesh'DXModItems.FlatItem'
     PickupViewScale=0.300000
     ThirdPersonMesh=LodMesh'DXModItems.FlatItem'
     Icon=Texture'DXModUI.UI.ChipIcon'
     largeIcon=Texture'DXModUI.UI.ChipIcon'
     largeIconWidth=50
     largeIconHeight=50
     Description="Click 'use' to download data. |n|nGRAM: Glycolitic RAM chip.  A 'gram'-sized memory storage device made of biological material organofactured using digitally controlled mitosys.  Max capacity of one hundred gigabytes, the GRAM chip, made entirely from plant matter, is sustainable information.  It's also edible, at ten calories of non-soluble fiber, for added nutritional and security value."
     beltDescription="Chip"
     Mesh=LodMesh'DXModItems.FlatItem'
     DrawScale=0.300000
     ScaleGlow=10.000000
     MultiSkins(0)=Texture'DXModUI.UI.ChipIcon'
     MultiSkins(1)=Texture'DXModUI.UI.ChipIcon'
     MultiSkins(2)=Texture'DXModUI.UI.ChipIcon'
     MultiSkins(3)=Texture'DXModUI.UI.ChipIcon'
     CollisionRadius=24.000000
     CollisionHeight=2.000000
}
