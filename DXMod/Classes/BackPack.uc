//-----------------------------------------------------------
//
//-----------------------------------------------------------
class BackPack expands DeusExPickup;

#exec obj load file=DXModUI
#exec obj load file=DXModItems

var travel string InvListNames[10];
var class<Inventory> InvList[10];
var travel int InvCounts[10];


function UpdateInvNames()
{
    local int i;
    for(i=0; i < ArrayCount(InvList); i++)
    {
        InvListNames[i] = string(InvList[i]);
       //GetPlayerPawn().ClientMessage(InvListNames[i]);
    }
}

event TravelPostAccept()
{
    local int i;
	Super.TravelPostAccept();
    for(i=0; i < ArrayCount(InvList); i++)
    {
        InvList[i] = class<Inventory>( DynamicLoadObject( InvListNames[i], class'Class' ) );
        //GetPlayerPawn().ClientMessage(InvListNames[i]);
    }
}

function bool AddItem( Inventory Inv)
{

    local int i;
    local Pickup pick;
    local Ammo newammo;
    // returns true if the item successfully added

    if( Inv.invSlotsX + Inv.invSlotsY > 3)
    {
        GetPlayerPawn().ClientMessage("Couldn't Fit Item (too big)");
        return false;
    }

    //check if item is in array
    for(i=0; i < ArrayCount(InvList); i++)
    {
        if(InvList[i] == Inv.Class)
        {
            pick = Pickup(Inv);
            if(Inv.IsA('WeaponGasGrenade') || Inv.IsA('WeaponEMPGrenade')
            || Inv.IsA('WeaponLAM'))
            {

                InvCounts[i] += Ammo(GetPlayerPawn().FindInventoryType(DeusExWeapon(Inv).AmmoName)).AmmoAmount;
                Ammo(GetPlayerPawn().FindInventoryType(DeusExWeapon(Inv).AmmoName)).AmmoAmount = 0;
                GetPlayerPawn().ClientMessage("Geenade Ammo = " $ InvCounts[i]);

            }
            else if(pick != none && pick.bCanHaveMultipleCopies )
            {
                InvCounts[i] += pick.NumCopies;
            }
            else
            {
                InvCounts[i] += 1;
            }
            ModMale(GetPlayerPawn()).RemoveInventoryType(Inv.Class);
            GetPlayerPawn().ClientMessage("Added " $ Inv.Class.default.ItemName $ " (" $ InvCounts[i] $ ")");
            UpdateInvNames();
            return true;
        }
    }

    //if not in the array see if there's space
    for(i=0; i < ArrayCount(InvList); i++)
    {
        if(InvList[i] == none)
        {
            InvList[i] = Inv.Class;
            pick = Pickup(Inv);
            if(Inv.IsA('WeaponGasGrenade') || Inv.IsA('WeaponEMPGrenade')
            || Inv.IsA('WeaponLAM'))
            {

                InvCounts[i] += Ammo(GetPlayerPawn().FindInventoryType(DeusExWeapon(Inv).AmmoName)).AmmoAmount;
                Ammo(GetPlayerPawn().FindInventoryType(DeusExWeapon(Inv).AmmoName)).AmmoAmount = 0;
                GetPlayerPawn().ClientMessage("Geenade Ammo = " $ InvCounts[i]);

            }
            else if(pick != none && pick.bCanHaveMultipleCopies )
            {
                InvCounts[i] += pick.NumCopies;
            }
            else
            {
                InvCounts[i] += 1;
            }
            ModMale(GetPlayerPawn()).RemoveInventoryType(Inv.Class);
            GetPlayerPawn().ClientMessage("Added " $ Inv.Class.default.ItemName $ " (" $ InvCounts[i] $ ")");
            UpdateInvNames();
            return true;
        }
    }
    GetPlayerPawn().ClientMessage("Couldn't Fit Item");
    return false;
}

function bool UnpackItem( int Index )
{
	local Inventory giveItem;
	local DeusExPlayer Player;
	local int i;
	Player = DeusExPlayer(Owner);
	if(Player == none)
	{
	    GetPlayerPawn().ClientMessage("Player not found!");
	    return false;
    }
    if( InvList[Index] != none )
    {
        for(i=0; i < InvCounts[Index]; i++)
        {

            //Make Item
            giveItem = Player.spawn(InvList[Index]);//,,, Player.Location);
            //invName = giveItem.ItemName;
              //If Player has item, add duplicate
            if(PickUp(giveItem) != none && PickUp(giveItem).bCanHaveMultipleCopies){
                Player.FrobTarget = giveItem;
                Player.ParseRightClick();
            }
            else{
                if(Player.FindInventoryType(giveItem.Class) != none){
                    //giveItem.SpawnCopy(Player);
                    Player.FrobTarget = giveItem;
                    Player.ParseRightClick();
                }
                else{
                    Player.FrobTarget = giveItem;
                    Player.ParseRightClick();
                }
            }


        }
        //Remove item from InvList
        InvList[Index] = none;
        InvCounts[Index] = 0;
        UpdateInvNames();
    }
    else
    {
            Player.ClientMessage("No Item found at index " $ Index);
    }
}

// ----------------------------------------------------------------------
// UpdateInfo(()
//
// Updates the InformationWindow when an item is selected in the
// inventory screen
//
// DEUS_EX AJY
// ----------------------------------------------------------------------

function bool UpdateInfo(Object winObject)
{
	local PersonaInfoWindow winInfo;
	local string str;
    local int i;
    local AlignWindow winAmmo;
    local BackpackButton btnBack;
    local bool bHasItems;
	winInfo = PersonaInfoWindow(winObject);

	winInfo.Clear();

	winInfo.SetTitle("BackPack");
    for(i=0; i < ArrayCount(InvList); i++)
    {
        if(InvList[i] != none)
        {
                bHasItems = true;
                winAmmo = AlignWindow(winInfo.winTile.NewChild(Class'AlignWindow'));
		        winAmmo.SetChildVAlignment(VALIGN_Top);
		        winAmmo.SetChildSpacing(4);
				//winInfo.AddAmmoInfoWindow(ammo, player.bShowAmmoDescriptions);
				//ammoCount++;
		//add sell button
	            btnBack = BackpackButton(winAmmo.NewChild(Class'BackpackButton'));
	            btnBack.SetButtonText(InvList[i].default.ItemName $ "(" $ InvCounts[i] $ ")");
	            btnBack.InvIndex = i;
	            btnBack.Backp = self;
                btnBack.EnableWindow();
        }
    }
    if(!bHasItems){
        winInfo.SetTitle("BackPack (drag items to icon)");
    }

	return False;
}

defaultproperties
{
     ItemName="Tote Bag"
     PlayerViewOffset=(X=30.000000,Z=-12.000000)
     PlayerViewMesh=LodMesh'DeusExItems.MedKit'
     PickupViewMesh=LodMesh'DeusExItems.MedKit'
     PickupViewScale=2.000000
     ThirdPersonMesh=LodMesh'DeusExItems.MedKit'
     LandSound=Sound'DeusExSounds.Generic.PlasticHit1'
     Icon=Texture'DXModUI.UI.ToteIcon'
     largeIcon=Texture'DXModUI.UI.ToteIcon'
     largeIconWidth=100
     largeIconHeight=50
     invSlotsX=2
     Description="A tote bag for storing items.  Drag-and-drop to use. |n|nThis tote bag has been disembowled by multiple lacerations but holds together now with fishing line stitches and hope.  Probably a laid off VP marketing rep's trendy briefcase, showed up in D10 and got eaten by the dire wolves of the rest of the mass-unemployed.  The fashion looks like a crossover between post-apoc-chic and haute-couture: sleek-cut leather with military-style black zippers and tactical fastenings.  A stainless steel label reads: 'Armagucci: designer accessories for surviving the zombie apocalypse in style.' |n"
     beltDescription="PACK"
     Mesh=LodMesh'DeusExItems.MedKit'
     MultiSkins(0)=Texture'DXModItems.Skins.ToteTex'
     MultiSkins(1)=Texture'DXModItems.Skins.ToteTex'
     MultiSkins(2)=Texture'DXModItems.Skins.ToteTex'
     MultiSkins(3)=Texture'DXModItems.Skins.ToteTex'
     CollisionRadius=4.310000
     CollisionHeight=10.240000
     Mass=10.000000
     Buoyancy=12.000000
}
