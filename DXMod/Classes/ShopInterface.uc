//=============================================================================
// ShopInterface.
//=============================================================================
class ShopInterface expands DeusExBaseWindow;

#exec OBJ LOAD FILE=EOTPPLAYER

// item info display window
var TextWindow info;
var int infolen, infotime, fwidth;

// player who instigated this shop screen
var DeusExPlayer player;

// shop actor used for info and stock limits
var ShopTrigger shop;

// diplay textures
var Texture infoLeft, inforight;
var Texture ItemListTop, ItemListBottom;
var Texture ItemListMiddle, ItemListbutton, buttontex;
var Texture costbox,stockbox,actorbox, itemicon;
var Texture TitleL,titleR,titleM;
var Texture costblack, stockblack, actorblack;
var Texture itemTopBlack, itemMidBlack, itemBotBlack;
var Texture infoLB, infoRB;
var sound snd;
var string ShopTitle;
var TextWindow infotitle;

// button vars (uses special buttons)
var ShopButton btnMainList[7],btnSecondList[8],
		btnThirdList, btnBuy;

var TextWindow infoDisplay, infocost, infostock, infocredits;

// shoule we display such and such?
var bool bShowPistols, bShowRifles, bShowMelee, bShowHeavy,
		bShowDemo, bshowAmmo, bshowEquipment;

// Border and Background Translucency
var bool bBorderTranslucent;
var bool bBackgroundTranslucent;
var bool bDrawBorder;

// Default Colors
var Color colBackground;
var Color colBorder;
var Color colHeaderText;
var Color red, black;

// item selction bools
var int bSecondaryshow[8], infocount;
var bool bShowFinal;
var class<Inventory> CurItem;
var int curList; // used for determining second list contents
var string infostr;
var int cost,stock, titlelen, titletime;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	local int i;
	Super.InitWindow();

	// set the defaults (god damn I'm lazy)
	infoLeft=Texture'EotPPlayerTex.UserInterface.iteminfoLeft';
	infoRight=Texture'EotpPlayerTex.UserInterface.iteminforight';
	ItemListTop=Texture'EotpPlayerTex.UserInterface.ItemSelectBoxTo';
	ItemListBottom=Texture'EotpPlayerTex.UserInterface.ItemSelectBoxBo';
	ItemListMiddle=Texture'EotpPlayerTex.UserInterface.ItemSelectBoxVe';
	costbox=Texture'EotpPlayerTex.UserInterface.CostBox';
	stockbox=Texture'EotpPlayerTex.UserInterface.StockLeftBox';
	actorbox=Texture'EotpPlayerTex.UserInterface.ActorDisplayWin';
	buttontex=Texture'EotPPlayerTex.UserInterface.itemSelectButto';
	titleL=Texture'EotPPlayerTex.UserInterface.TitleLeft';
	titleR=Texture'EotPPlayerTex.UserInterface.Titleright';
	titleM=Texture'EotPPlayerTex.UserInterface.TitleMiddle';
	costblack=Texture'EotPPlayerTex.UserInterface.CostBoxBlack';
	stockblack=Texture'EotPPlayerTex.UserInterface.StockBlack';
	actorblack=Texture'EotPPlayerTex.UserInterface.ActDispBlack';
	itemTopBlack=Texture'EotPPlayerTex.UserInterface.ItemSelTopBlack';
	itemMidBlack=Texture'EotPPlayerTex.UserInterface.ItemSelMidBlack';
	itemBotBlack=Texture'EotPPlayerTex.UserInterface.ItemSelBotBlack';
	infoLB=Texture'EotPPlayerTex.UserInterface.ItemInfoLB';
	infoRB=Texture'EotPPlayerTex.UserInterface.ItemInfoRB';

	player = DeusExPlayer(root.parentPawn);

	// do the rest

	SetWindowAlignments(HALIGN_Center, VALIGN_Center);
	SetSize(640, 480);
	SetMouseFocusMode(MFocus_EnterLeave);

	// Create the buttons
	StyleChanged();
	shop=ModMale(player).shop;
	Shoptitle=shop.Shoptitle;
	CreateButtons();

	bTickEnabled = False;

 	sortlists();
 	showinfo();

 	titlelen=0;
 	titletime=0;
 	red.R=255;
 	red.G=0;
 	red.B=0;
 	black.R=0;
 	black.G=0;
 	black.B=0;
}

// ----------------------------------------------------------------------
// InitData()
//
// Do the post-InitWindow stuff
// ----------------------------------------------------------------------

function InitData()
{
	// do we need this one?  could use it to gain info
	// from the shop actor about items left?


	//winText.SetTextColor(colHeaderText);
	//winText.SetText(msgEnterCode);
}

// ----------------------------------------------------------------------
// DrawWindow()
//
// DrawWindow event (called every frame)
// ----------------------------------------------------------------------

event DrawWindow(GC gc)
{
	// First draw the background then the border
	DrawBlackStuff(gc);
	DrawBackground(gc);

	Super.DrawWindow(gc);
}

// ----------------------------------------------------------------------
// DrawBlackStuff()
// ----------------------------------------------------------------------
function DrawBlackStuff(GC gc)
{
	local int i, pos;
	gc.SetStyle(DSTY_Normal);
	gc.SetTileColor(black);

	gc.DrawTexture(40,340,width,height,0,0,infoLB);
	gc.DrawTexture(296,340,width,height,0,0,infoRB);
	gc.DrawTexture(0,48,width,height,0,0,itemTopBlack);
	gc.DrawTexture(128,48,width,height,0,0,itemTopBlack);
	gc.DrawTexture(256,48,width,height,0,0,itemTopBlack);
	gc.DrawTexture(256,48+48,width,height,0,0,itemBotBlack);
	gc.DrawTexture(256,64,width,height,0,0,itemMidBlack);
	gc.DrawTexture(512,32,width,height,0,0,costBlack);
	gc.DrawTexture(640-145,160,width,height,0,0,stockBlack);
	gc.DrawTexture(640-(256)-64,112+32,width,height,0,0,actorBlack);
	gc.DrawTexture(640-128-32,340-32,width,height,0,0,itemTopBlack);
	gc.DrawTexture(640-128-32,340-16,width,height,0,0,itemBotBlack);
	pos=64;
	for (i=0; i<GetAyeFirst(); i++)
		{
		gc.DrawTexture(0,pos,width,height,0,0,itemMidBlack);
		pos+=32;
		}
	gc.DrawTexture(0,pos,width,height,0,0,itemBotBlack);
	pos=64;
	for (i=0; i<GetAyeSecond(); i++)
		{
		gc.DrawTexture(128,pos,width,height,0,0,itemMidBlack);
		pos+=32;
		}
	gc.DrawTexture(128,pos,width,height,0,0,itemBotBlack);

}


// ----------------------------------------------------------------------
// DrawBackground()
// ----------------------------------------------------------------------

function DrawBackground(GC gc)
{
	local int i, pos;
	// let's do some pretty text stuff :)
	PrettyTestStuff();

	if (bBackgroundTranslucent)
		gc.SetStyle(DSTY_Translucent);
	else
		gc.SetStyle(DSTY_Masked);

	gc.SetTileColor(colBackground);

	//gc.DrawTexture(0, 0, width, height, 0, 0, texBackground);
	// draw the title
	gc.DrawTexture((640/2)-(fwidth/2)-16,0,width,height,0,0,titleL);
	pos=(640/2)-(fwidth/2);
	for (i=0; i<fwidth/16; i++)
		{
		gc.DrawTexture(pos,0,width,height,0,0,titleM);
		pos+=16;
		}
	gc.DrawTexture(pos,0,width,height,0,0,titleR);
	// and the rest
	gc.DrawTexture(40,340,width,height,0,0,infoLeft);
	gc.DrawTexture(296,340,width,height,0,0,infoRight);
	gc.DrawTexture(0,48,width,height,0,0,itemListTop);
	gc.DrawTexture(128,48,width,height,0,0,itemListTop);
	gc.DrawTexture(256,48,width,height,0,0,itemListTop);
	gc.DrawTexture(256,48+48,width,height,0,0,itemListBottom);
	gc.DrawTexture(256,64,width,height,0,0,itemListMiddle);
	gc.DrawTexture(512,32,width,height,0,0,costBox);
	gc.DrawTexture(640-145,160,width,height,0,0,stockBox);
	gc.DrawTexture(640-(256)-64,112+32,width,height,0,0,actorBox);
	gc.DrawTexture(640-128-32,340-32,width,height,0,0,itemListTop);
	gc.DrawTexture(640-128-32,340-16,width,height,0,0,itemListBottom);
	pos=64;
	for (i=0; i<GetAyeFirst(); i++)
		{
		gc.DrawTexture(0,pos,width,height,0,0,itemListMiddle);
		pos+=32;
		}
	gc.DrawTexture(0,pos,width,height,0,0,itemListBottom);
	pos=64;
	for (i=0; i<GetAyeSecond(); i++)
		{
		gc.DrawTexture(128,pos,width,height,0,0,itemListMiddle);
		pos+=32;
		}
	gc.DrawTexture(128,pos,width,height,0,0,itemListBottom);
	gc.SetStyle(DSTY_Masked);
	gc.DrawTexture(640-(256)-88+64,112+48+32,width,height,0,0,itemicon);

}

// ----------------------------------------------------------------------
// CreateButtons()
// ----------------------------------------------------------------------

function CreateButtons()
{
local int i;
// in here we should create the shop interface buttons
infodisplay=TextWindow(NewChild(Class'TextWindow'));
infodisplay.SetSize(512-32,128);
infodisplay.setPos(64,356);
infodisplay.setWordWrap(True);
infodisplay.setTextAlignments(HAlign_Left,VAlign_Top);
infoDisplay.SetFont(Font'DeusExUI.FontMenuSmall');
infoDisplay.SetTextColor(colHeaderText);
// now the cost box
infocost=TextWindow(NewChild(Class'TextWindow'));
infocost.SetSize(96,32);
infocost.setPos(528,64+32);
infocost.setWordWrap(False);
infocost.setTextAlignments(HAlign_Center,VAlign_Center);
infocost.SetTextColor(colHeaderText);
infocost.SetFont(font'DeusExUI.FontMenuExtraLarge');
// and finally the stock box
infostock=TextWindow(NewChild(Class'TextWindow'));
infostock.SetSize(80,32);
infostock.setPos(648-145+32,192+32);
infostock.setWordWrap(False);
infostock.setTextAlignments(HAlign_Center,VAlign_Center);
infostock.SetTextColor(colHeaderText);
infostock.SetFont(font'DeusExUI.FontMenuExtraLarge');
// wot about the credits you ask?
infocredits=TextWindow(NewChild(Class'TextWindow'));
infocredits.SetSize(96,24);
infocredits.setPos(640-128-16,340-32+5);
infocredits.setWordWrap(False);
infocredits.setTextAlignments(HAlign_Center,VAlign_Center);
infocredits.SetTextColor(colHeaderText);
infocredits.SetFont(font'DeusExUI.FontMenuSmall');
// and the title bar too!
fwidth=(Len(Shoptitle)*6)+32;
infotitle=TextWindow(NewChild(Class'TextWindow'));
infotitle.SetSize(fwidth,32);
infotitle.setPos((640/2)-(fwidth/2),0);
infotitle.setWordWrap(False);
infotitle.setTextAlignments(HAlign_Center,VAlign_Center);
infotitle.SetTextColor(colHeaderText);
infotitle.SetFont(font'DeusExUI.FontMenuHeaders_DS');
infotitle.SetText("");
// purchase/exit buttons
btnBuy=ShopButton(NewChild(Class'ShopButton'));
btnBuy.SetPos(320,244+32);
btnBuy.SetText("Purchase Item");
btnBuy.buttonofftex=btnBuy.buttontex;
// check to see what bits NEED to be created and call the function
// first create the main left side display
for (i=0; i<7; i++)
	btnMainList[i]=ShopButton(NewChild(Class'ShopButton'));
for (i=0; i<7; i++)
		{
		btnMainList[i].SetPos(0,(i*16)+64);
		}
btnMainList[0].SetText("Melee");
btnMainList[1].SetText("Pistol");
btnMainList[2].SetText("Rifle");
btnMainList[3].SetText("Demolition");
btnMainList[4].SetText("Heavy");
btnMainList[5].SetText("Ammo");
btnMainList[6].SetText("Equipment");
// now the second bit
for (i=0; i<8; i++)
		btnSecondList[i]=ShopButton(NewChild(Class'ShopButton'));
for (i=0; i<8; i++)
		{
		btnSecondList[i].SetPos(128,(i*32)+64);
		btnSecondList[i].SetText(" ");
		}
// and then the third part
		btnThirdList=ShopButton(NewChild(Class'ShopButton'));
		btnThirdList.SetPos(256,64);
		btnThirdList.SetText("debug");
	showinfo(); // need to show credits left :)
}


// ----------------------------------------------------------------------
// ButtonActivated()
// ----------------------------------------------------------------------

function bool ButtonActivated( Window buttonPressed )
{
// let's see what happens if we clikc here or there...
	local bool bHandled;
	local int i, list;

	bHandled = False;

	if (buttonPressed==btnThirdList)
		{
		return True;
		}

	// want a check in here to deal with the two lists
	list=-1;
	for (i=0; i<7 && list==-1; i++)
		if (buttonPressed==btnMainList[i])
			list=0;
	for (i=0; i<8 && list==-1; i++)
		if (buttonPressed==btnSecondList[i] && btnSecondList[i].GetText()!=" ")
			list=1;

	if (list==-1)
		{
		// must be one of the other two buttons then...
		if (buttonPressed==btnBuy)
			BuyItem();
		}

	// let's give the handlng over to someone else...
	if (list==0)
		{
		DealWithMainList(buttonPressed);
		bHandled=true;
		}
	else if (list==1)
		{
		DealWithSecondList(buttonPressed);
		bHandled=true;
		}

	if (!bHandled)
		bHandled = Super.ButtonActivated(buttonPressed);

	return bHandled;
}

// ----------------------------------------------------------------------
// VirtualKeyPressed()
//
// Called when a key is pressed; provides a virtual key value
// ----------------------------------------------------------------------

event bool VirtualKeyPressed(EInputKey key, bool bRepeat)
{
	if (key!=IK_Escape)
		return true;
	return Super.VirtualKeyPressed(key, bRepeat);
}


// ----------------------------------------------------------------------
// StyleChanged()
// ----------------------------------------------------------------------

event StyleChanged()
{
	local ColorTheme theme;

	theme = player.ThemeManager.GetCurrentHUDColorTheme();

	colBackground = theme.GetColorFromName('HUDColor_Background');
	colBorder     = theme.GetColorFromName('HUDColor_Borders');
	colHeaderText = theme.GetColorFromName('HUDColor_HeaderText');

	bBorderTranslucent     = player.GetHUDBorderTranslucency();
	bBackgroundTranslucent = player.GetHUDBackgroundTranslucency();
	bDrawBorder            = player.GetHUDBordersVisible();
}


function DealWithMainList(Window buttonPressed)
 {
 local int i;
 curList=-1;
 for (i=0; i<7; i++)
 	if (btnMainList[i]==buttonPressed)
 		{
 		btnMainList[i].bSelected=True;
 		curList=i;
 		}
 	else
 		btnMainList[i].bSelected=False;
 PlaySound(Sound'Menu_Activate', 1);
 for (i=0; i<9; i++)
 	btnSecondList[i].bSelected=False;
 curitem=none; // remove selected item from display
 itemicon=none;
 btnBuy.SetText("");
 infoStock.SetText("");
 infocost.SetText("");
 sortlists();
 infolen=0;
 infodisplay.SetText("");
 }

function DealWithSecondList(Window buttonPressed)
 {
 local int i, index1,index2;
  PlaySound(Sound'Menu_Activate', 1);
 for (i=0; i<8; i++)
 	if (btnSecondList[i]==buttonPressed)
 		btnSecondList[i].bSelected=True;
 	else
 		btnSecondList[i].bSelected=False;
 // now then, what have we selected, hmm?
  for (i=0; i<8; i++)
 	if (btnSecondList[i].bSelected)
 		index2=i;
 switch(curlist)
 	{
 	case(0):
		curItem=shop.Melee.Items[index2].item;
		btnThirdList.SetText(curitem.Default.itemname);
		cost=shop.Melee.Items[index2].cost;
		stock=shop.Melee.Items[index2].stock;
		break;
	case(1):
		curItem=shop.Pistols.Items[index2].item;
		btnThirdList.SetText(curitem.Default.itemname);
		cost=shop.Pistols.Items[index2].cost;
		stock=shop.Pistols.Items[index2].stock;
		break;
	case(2):
		curItem=shop.rifles.Items[index2].item;
		btnThirdList.SetText(curitem.Default.itemname);
		cost=shop.Rifles.Items[index2].cost;
		stock=shop.Rifles.Items[index2].stock;
		break;
	case(3):
		curItem=shop.Demolition.Items[index2].item;
		btnThirdList.SetText(curitem.Default.itemname);
		cost=shop.Demolition.Items[index2].cost;
		stock=shop.Demolition.Items[index2].stock;
		break;
	case(4):
		curItem=shop.Heavy.Items[index2].item;
		btnThirdList.SetText(curitem.Default.itemname);
		cost=shop.Heavy.Items[index2].cost;
		stock=shop.Heavy.Items[index2].stock;
		break;
	case(5):
		curItem=shop.Ammo.Items[index2].item;
		btnThirdList.SetText(curitem.Default.itemname);
		cost=shop.Ammo.Items[index2].cost;
		stock=shop.Ammo.Items[index2].stock;
		break;
	case(6):
		curItem=shop.Equipment.Items[index2].item;
		btnThirdList.SetText(curitem.Default.itemname);
		cost=shop.Equipment.Items[index2].cost;
		stock=shop.Equipment.Items[index2].stock;
		break;
	}
 //SOCIAL ENG MOD
 player = DeusExPlayer(root.parentPawn);
 //player.ClientMessage("Social Eng Level = " $ player.SkillSystem.GetSkillLevel(Class'DeusEx.SkillWeaponHeavy'));
 if(player.SkillSystem.GetSkillLevel(Class'DeusEx.SkillWeaponHeavy') == 1)
     cost = cost - (cost * 0.2);
 else if(player.SkillSystem.GetSkillLevel(Class'DeusEx.SkillWeaponHeavy') == 2)
     cost = cost - (cost * 0.3);
 else if(player.SkillSystem.GetSkillLevel(Class'DeusEx.SkillWeaponHeavy') == 3)
     cost = cost - (cost * 0.4);
 else if(player.SkillSystem.GetSkillLevel(Class'DeusEx.SkillWeaponHeavy') == 4){
     cost = cost - (cost * 0.5);
}
 infoStock.SetText("");
 infocost.SetText("");
 itemicon=curitem.default.icon;
 showinfo();
 infolen=0;
 }


function int GetAyeFirst()
 {
 local int r;
 r=0;
 if (bShowMelee) r++;
 if (bShowPistols) r++;
 if (bShowRifles) r++;
 if (bShowHeavy) r++;
 if (bShowDemo) r++;
 if (bShowAmmo) r++;
 if (bShowEquipment) r++;
 return r;
 }

function int GetAyeSecond()
 {
 local int r,i;
 r=0;
 for (i=0; i<9; i++)
	r+=bSecondaryShow[i];
 return r;
 }


function showinfo()
 {
 if (curitem!=none)
 	{
 	infostr=curitem.default.itemname@"|n|n"@curitem.default.description;
    infocost.SetText(cost);
    infoStock.SetText(stock);
    if (player.credits>=cost && stock>0)
    	{
	    btnBuy.SetText("Purchase Item");
	    infoCost.SetTextColor(colHeaderText);
	    }
	else
		{
		infoCost.SetTextColor(red);
		btnBuy.SetText("");
		}
 	}
 else
 	{
 	infostr="Item Description Display";
 	infocost.SetText("");
 	infoStock.SetText("");
 	btnBuy.SetText("");
 	}

 //infoDisplay.SetText(infostr);

 infocredits.SetText("Silvers: "@player.credits@"");
 itemicon=curitem.default.icon;
 }

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

/*
some heacy duty info for the click and select panels......

panel 1 (main selection)

Melee
Pistols
Rifles
Heavy
Demolition
Ammo
Equipment

panel 2 (secondary selections)
Create eight buttons (max eight items per category)

panel 3 (final selection)
Create four buttons (max four items per sub-category

*/


function sortLists()
 {
 local int i,n,a, pos1,pos2;
 // first we reset the display vars
 bShowPistols=False;
 bShowRifles=False;
 bShowMelee=False;
 bShowHeavy=False;
 bShowDemo=False;
 bshowAmmo=False;
 bshowEquipment=False;
 for (i=0; i<8; i++)
 		bSecondaryShow[i]=0;
 // stage one:  sort through main list
 	// order: melee, pist, rifl, heavy, demo, ammo, equip
 for (i=0; i<8; i++)
	 	if (shop.Melee.Items[i].item!=none && shop.Melee.Items[i].stock>0)
	 		{
	 		bShowMelee=True;
	 		break;
	 		}
  for (i=0; i<8; i++)
	 	if (shop.Pistols.Items[i].item!=none && shop.Pistols.Items[i].stock>0)
	 		{
	 		bShowPistols=True;
	 		break;
	 		}
  for (i=0; i<8; i++)
	 	if (shop.Rifles.Items[i].item!=none && shop.Rifles.Items[i].stock>0)
	 		{
	 		bShowRifles=True;
	 		break;
	 		}
  for (i=0; i<8; i++)
	 	if (shop.Heavy.Items[i].item!=none && shop.Heavy.Items[i].stock>0)
	 		{
	 		bShowHeavy=True;
	 		break;
	 		}
  for (i=0; i<8; i++)
	 	if (shop.Demolition.Items[i].item!=none && shop.Demolition.Items[i].stock>0)
	 		{
	 		bShowDemo=True;
	 		break;
	 		}
  for (i=0; i<8; i++)
	 	if (shop.Ammo.Items[i].item!=none && shop.Ammo.Items[i].stock>0)
	 		{
	 		bShowAmmo=True;
	 		break;
	 		}
  for (i=0; i<8; i++)
	 	if (shop.Equipment.Items[i].item!=none && shop.Equipment.Items[i].stock>0)
	 		{
	 		bShowEquipment=True;
	 		break;
	 		}
 // stage two:  sort through secondary list
 switch (curList)
 	{
 	case (0):  // melee
 		for (i=0; i<8; i++)
 			if (shop.Melee.Items[i].item!=none && shop.Melee.Items[i].stock>0)
 				{
 				bSecondaryShow[i]=1;
 				btnSecondList[i].SetText(shop.Melee.Items[i].item.default.itemname);
 				}
 			else
 				bSecondaryshow[i]=0;
 		break;
 	case (1):  // pistols
 		for (i=0; i<8; i++)
 			if (shop.Pistols.Items[i].item!=none && shop.Pistols.Items[i].stock>0)
 				{
 				bSecondaryShow[i]=1;
 				btnSecondList[i].SetText(shop.Pistols.Items[i].item.default.itemname);
 				}
 			else
 				bSecondaryshow[i]=0;
 		break;
 	case (2):  // rifles
		for (i=0; i<8; i++)
 			if (shop.Rifles.Items[i].item!=none && shop.Rifles.Items[i].stock>0)
 				{
 				bSecondaryShow[i]=1;
 				btnSecondList[i].SetText(shop.Rifles.Items[i].item.default.itemname);
 				}
 			else
 				bSecondaryshow[i]=0;
 		break;
 	case (3):  // heavy
 		for (i=0; i<8; i++)
 			if (shop.Demolition.Items[i].item!=none && shop.Demolition.Items[i].stock>0)
 				{
 				bSecondaryShow[i]=1;
 				btnSecondList[i].SetText(shop.Demolition.Items[i].item.default.itemname);
 				}
 			else
 				bSecondaryshow[i]=0;
 		break;
 	case (4):  // demo
 		for (i=0; i<8; i++)
 			if (shop.Heavy.Items[i].item!=none && shop.Heavy.Items[i].stock>0)
 				{
 				bSecondaryShow[i]=1;
 				btnSecondList[i].SetText(shop.Heavy.Items[i].item.default.itemname);
 				}
 			else
 				bSecondaryshow[i]=0;
 		break;
 	case (5):  // ammo
 		for (i=0; i<8; i++)
 			if (shop.Ammo.Items[i].item!=none && shop.Ammo.Items[i].stock>0)
 				{
 				bSecondaryShow[i]=1;
 				btnSecondList[i].SetText(shop.Ammo.Items[i].item.default.itemname);
 				}
 			else
 				bSecondaryshow[i]=0;
 		break;
  	case (6):  // equipment
  		for (i=0; i<8; i++)
 			if (shop.Equipment.Items[i].item!=none && shop.Equipment.Items[i].stock>0)
 				{
 				bSecondaryShow[i]=1;
 				btnSecondList[i].SetText(shop.Equipment.Items[i].item.default.itemname);
 				}
 			else
 				bSecondaryshow[i]=0;
 		break;

 	}

 // stage three: position buttons according to option availability
 if (curItem==none)
 	btnThirdList.SetText(" ");
 else
 	btnThirdList.SetText(curitem.default.itemname);
 pos1=64;
 for (i=0; i<9; i++)
 	btnMainList[i].SetPos(0,640);
 if (bShowMelee)
 	{
 	btnMainList[0].SetPos(0,pos1);
 	btnMainList[0].Show();
 	pos1+=32;
 	}
  if (bShowPistols)
 	{
 	btnMainList[1].SetPos(0,pos1);
 	btnMainList[1].Show();
 	pos1+=32;
 	}
  if (bShowRifles)
 	{
 	btnMainList[2].SetPos(0,pos1);
 	btnMainList[2].Show();
 	pos1+=32;
 	}
  if (bShowDemo)
 	{
 	btnMainList[3].SetPos(0,pos1);
 	btnMainList[3].Show();
 	pos1+=32;
 	}
  if (bShowHeavy)
 	{
 	btnMainList[4].SetPos(0,pos1);
 	btnMainList[4].Show();
 	pos1+=32;
 	}
  if (bShowAmmo)
 	{
 	btnMainList[5].SetPos(0,pos1);
 	btnMainList[5].Show();
 	pos1+=32;
 	}
  if (bShowEquipment)
 	{
 	btnMainList[6].SetPos(0,pos1);
 	btnMainList[6].Show();
 	pos1+=32;
 	}
 // now for list 2....
 for (i=0; i<8; i++)
 	btnSecondList[i].SetPos(128,-512);
 pos2=64;
 for (i=0; i<8; i++)
 	{
 	if (bSecondaryShow[i]==1)
 		{
 		btnSecondList[i].SetPos(128,pos2);
 		pos2+=32;
 		}
 	}
 }


function BuyItem()
{

local int i;
local Inventory GiveItem;
local string InvName;

// check for available funds
if (player.credits<cost || curitem==none)
	{
	if (player.credits<cost)
		{
		infodisplay.setText("|n|n                      YOU DON'T HAVE ENOUGH MONEY!");
		infolen=Len(infodisplay.GetText());
		turnOffTwo();
		}
	PlaySound(Sound'DeusExSounds.Generic.Buzz1',2);
	}
else
	{
	// purchase item
	//JCDenton2(player).GetItem(curitem);

        //Make Item
        giveItem = Player.spawn(curitem,,, Player.Location);
        invName = giveItem.ItemName;
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

/*	if (ModMale(player).GetItem(curitem)==False)
	{
		infodisplay.SetText("|n|n           YOU DON'T HAVE ENOUGH ROOM IN YOUR INVENTORY!");
		infolen=Len(infodisplay.GetText());

		turnOffTwo();
		PlaySound(Sound'DeusExSounds.Generic.Buzz1',2);
		return;
	}    */
	player.credits-=cost;
	// now remove the stock - fun huh
	switch(curList)
		{
		case(0):
			for (i=0; i<9; i++)
				if (shop.Melee.Items[i].item==curitem)
					shop.Melee.Items[i].stock--;
			break;
		case(1):
			for (i=0; i<9; i++)
				if (shop.Pistols.Items[i].item==curitem)
					shop.Pistols.Items[i].stock--;
			break;
		case(2):
			for (i=0; i<9; i++)
				if (shop.Rifles.Items[i].item==curitem)
					shop.Rifles.Items[i].stock--;
			break;
		case(3):
			for (i=0; i<9; i++)
				if (shop.Demolition.Items[i].item==curitem)
					shop.Demolition.Items[i].stock--;
			break;
		case(4):
			for (i=0; i<9; i++)
				if (shop.Heavy.Items[i].item==curitem)
					shop.Heavy.Items[i].stock--;
			break;
		case(5):
			for (i=0; i<9; i++)
				if (shop.Ammo.Items[i].item==curitem)
					shop.Ammo.Items[i].stock--;
			break;
		case(6):
			for (i=0; i<9; i++)
				if (shop.Equipment.Items[i].item==curitem)
					shop.Equipment.Items[i].stock--;
			break;
		}
	stock--;
	if (stock<=0)
		{
		for (i=0; i<9; i++)
			{
			btnSecondList[i].bSelected=False;
			curitem=none;
			cost=0;
			stock=0;
			}
		}
	sortlists();
	showinfo();
	PlaySound(Sound'Menu_Activate', 1);
	infolen=0;
	}
}

function PrettyTestStuff()
 {
 local string s;
  if (titlelen<(Len(shoptitle)-1))
	 titletime++;
 if (titletime>2)
 	{
 	titletime=0;
 	if (titlelen<(Len(shoptitle)-1))
 		{
 		titlelen++;
 		s=Left(shoptitle,titlelen);
 		}
 	else
 		s=shoptitle;
	infotitle.SetText(s);
 	}
 if (curitem==none)
 	return; // make sure we should be here :)
 if (infolen<(Len(infostr)-1))
	 infotime++;
 if (infotime>2)
 	{
 	infotime=0;
 	if (infolen<(Len(infostr)-1))
 		{
 		infolen++;
 		s=Left(infostr,infolen);
 		}
 	else
 		s=infostr;
	infodisplay.SetText(s);
 	}
 }

function TurnOffTwo()
 {
 local int i;
 for (i=0; i<9; i++)
 	{
 	btnSecondList[i].bSelected=False;
 	curitem=none;
 	}
 }

defaultproperties
{
}
