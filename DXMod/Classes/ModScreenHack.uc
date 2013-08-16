//-----------------------------------------------------------
//
//-----------------------------------------------------------
class ModScreenHack extends PersonaScreenImages;

#exec OBJ LOAD FILE=DXModSounds

var DataVaultImage Networks[50];
var PersonaActionButtonWindow btnConnect;
var PersonaActionButtonWindow btnSniff;
var PersonaActionButtonWindow btnAlg;
var PersonaActionButtonWindow btnTable;
var PersonaActionButtonWindow btnIncAlg;
var PersonaActionButtonWindow btnDecAlg;
var PersonaActionButtonWindow btnIncTable;
var PersonaActionButtonWindow btnDecTable;
var string NetworkToConnect;
var name NameConversionHack;

var localized String ConnectButtonLabel;
var localized String SniffButtonLabel;
var localized String UnSniffButtonLabel;
var localized String AlgButtonLabel;
var localized String TableButtonLabel;
var bool bStopSniffing;

var PersonaInfoWindow					winInfo; //Hacking Data
var PersonaHeaderTextWindow              winProfTitle;
var PersonaHeaderTextWindow              winCrypTitle;
var PersonaHeaderTextWindow              winAlertTitle;
var PersonaInfoWindow					winProfile; //Basic data
var PersonaListWindow         lstCons;

var float TickTime;


// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

    //Inventory screen is getting disabled because of this?
	PersonaNavBarWindow(winNavBar).btnImages.SetSensitivity(True);

	//EnableButtons();
    //Force an update
    //SignalRefresh();



}

// ----------------------------------------------------------------------
// CreateButtons()
// ----------------------------------------------------------------------



function CreateButtons()
{
	local PersonaButtonBarWindow winActionButtons;
	local PersonaButtonBarWindow decryptButtons;

	winActionButtons = PersonaButtonBarWindow(winClient.NewChild(Class'PersonaButtonBarWindow'));
	winActionButtons.SetPos(10, 422);
	winActionButtons.SetWidth(503);
	winActionButtons.FillAllSpace(False);



	//btnAddNote = PersonaActionButtonWindow(winActionButtons.NewChild(Class'PersonaActionButtonWindow'));
	//btnAddNote.SetButtonText(AddNoteButtonLabel);

	btnDecTable = PersonaActionButtonWindow(winActionButtons.NewChild(Class'PersonaActionButtonWindow'));
	btnDecTable.SetButtonText(" - ");

	btnIncTable = PersonaActionButtonWindow(winActionButtons.NewChild(Class'PersonaActionButtonWindow'));
	btnIncTable.SetButtonText(" + ");

	btnTable = PersonaActionButtonWindow(winActionButtons.NewChild(Class'PersonaActionButtonWindow'));
	btnTable.SetButtonText(TableButtonLabel);

	btnDecAlg = PersonaActionButtonWindow(winActionButtons.NewChild(Class'PersonaActionButtonWindow'));
	btnDecAlg.SetButtonText(" - ");

	btnIncAlg = PersonaActionButtonWindow(winActionButtons.NewChild(Class'PersonaActionButtonWindow'));
	btnIncAlg.SetButtonText(" + ");

	btnAlg = PersonaActionButtonWindow(winActionButtons.NewChild(Class'PersonaActionButtonWindow'));
	btnAlg.SetButtonText(AlgButtonLabel);

	btnSniff = PersonaActionButtonWindow(winActionButtons.NewChild(Class'PersonaActionButtonWindow'));
	btnSniff.SetButtonText(SniffButtonLabel);

	btnConnect = PersonaActionButtonWindow(winActionButtons.NewChild(Class'PersonaActionButtonWindow'));
	btnConnect.SetButtonText(ConnectButtonLabel);

 	//decryptButtons = PersonaButtonBarWindow(winClient.NewChild(Class'PersonaButtonBarWindow'));
	//decryptButtons.SetPos(250, 290);
	//decryptButtons.SetWidth(150);
	//decryptButtons.FillAllSpace(False);



	//btnDeleteNote = PersonaActionButtonWindow(winActionButtons.NewChild(Class'PersonaActionButtonWindow'));
	//btnDeleteNote.SetButtonText(DeleteNoteButtonLabel);
}

function CreateControls()
{

    Super.CreateControls();

 //Sniffer Data window
	winInfo = PersonaInfoWindow(winClient.NewChild(Class'PersonaInfoWindow'));
	winInfo.SetPos(20, 310);
	winInfo.SetSize(400, 110);
    winInfo.SetTitle("Packets");
    winInfo.SetText("");
    winInfo.Clear();

	winProfTitle = PersonaHeaderTextWindow(winClient.NewChild(Class'PersonaHeaderTextWindow'));
	winProfTitle.SetPos(22, 276);
	winProfTitle.SetSize(300, 20);
    winProfTitle.SetText( "" );

	winCrypTitle = PersonaHeaderTextWindow(winClient.NewChild(Class'PersonaHeaderTextWindow'));
	winCrypTitle.SetPos(22, 310);
	winCrypTitle.SetSize(300, 20);
    winCrypTitle.SetText( "" );

 	winAlertTitle = PersonaHeaderTextWindow(winClient.NewChild(Class'PersonaHeaderTextWindow'));
	winAlertTitle.SetPos(210, 270);
	winAlertTitle.SetSize(250, 50);
    winAlertTitle.SetText( "" );
    winAlertTitle.SetTextColorRGB(255,0,0);
    //winProfile.SetText("");
 //Network Profile window
	winProfile = PersonaInfoWindow(winClient.NewChild(Class'PersonaInfoWindow'));
	winProfile.SetPos(20, 270);
	winProfile.SetSize(400, 80);
	winProfile.SetFont(boldFont);
    winProfile.SetTitle("Profile");
    winProfile.SetText("");
    winProfile.Clear();



}

// ----------------------------------------------------------------------
// CreateShowNotesCheckbox()
// ----------------------------------------------------------------------

function CreateShowNotesCheckbox()
{
	/*chkShowNotes = PersonaCheckBoxWindow(winClient.NewChild(Class'PersonaCheckBoxWindow'));

	chkShowNotes.SetWindowAlignments(HALIGN_Right, VALIGN_Top, 203, 424);
	chkShowNotes.SetText(ShowNotesLabel);
	chkShowNotes.SetToggle(True);   */
}

// ----------------------------------------------------------------------
// CreateNavBarWindow()
// ----------------------------------------------------------------------

function CreateNavBarWindow()
{
	winNavBar = PersonaNavBarBaseWindow(NewChild(Class'ModNavBarWindow'));
	winNavBar.SetPos(0, 0);
}

// ----------------------------------------------------------------------
// PopulateImagesList()
// ----------------------------------------------------------------------

function PopulateImagesList()
{
	local DataVaultImage image;
	local int rowId;
	local WirelessOverlay W;
	local int i;

	// First clear the list
	lstImages.DeleteAllRows();

	// Loop through all the notes the player currently has in
	// his possession
    i=0;
    foreach Player.AllActors(class'WirelessOverlay', W)
    {
         if(!W.bHideMe && W.bBroadcasting)
         {
             if(!W.bCracked)
             {
                 W.RandomAlgTable();
             }
             image = Player.Spawn(class'Image01_GunFireSensor');
             image.imageDescription=W.NetworkName;
             image.imageTextures[0]=W.Logo;
             image.imageTextures[1]=none;
             image.imageTextures[2]=none;
             image.imageTextures[3]=none;
             rowId = lstImages.AddRow(image.imageDescription);
    		 lstImages.SetRowClientObject(rowId, image);
    		 Networks[i]=image;
    		 i++;
		 }
    }

	/*
	image = Player.FirstImage;
	while(image != None)
	{
		rowId = lstImages.AddRow(image.imageDescription);

		// Check to see if we need to display *New* in the second column
		if (image.bPlayerViewedImage == False)
			lstImages.SetField(rowId, 1, "C");

		// Save the image away
		lstImages.SetRowClientObject(rowId, image);

		image = image.NextImage;
	}   */
}

// ----------------------------------------------------------------------
// DestroyImages()
//
// Unload texture memory used by the images
// ----------------------------------------------------------------------

function DestroyImages()
{
	local DataVaultImage image;
	local int listIndex;
	local int rowId;
	local int i;

	for(listIndex=0; listIndex<lstImages.GetNumRows(); listIndex++)
	{
		rowId = lstImages.IndexToRowId(listIndex);

		if (lstImages.GetFieldValue(rowId, 2) > 0)
		{
			image = DataVaultImage(lstImages.GetRowClientObject(rowId));

			if (image != None)
				image.UnloadTextures(player);
		}
	}

	for(i=0; Networks[i] != none; i++)
	{
	    Networks[i].Destroy();
	}
    /*
    foreach Player.AllActors(class'DataVaultImage', image)
    {
         Player.ClientMessage( image.imageDescription );

    }  */
}

// ----------------------------------------------------------------------
// ListSelectionChanged()
// ----------------------------------------------------------------------

event bool ListSelectionChanged(window list, int numSelections, int focusRowId)
{
    local WirelessOverlay W;
	SetImage(DataVaultImage(lstImages.GetRowClientObject(focusRowId)));

	// Set a flag to later clear the "*New*" in the second column
	lstImages.SetFieldValue(focusRowId, 2, 1);

    foreach Player.AllActors(class'WirelessOverlay', W)
    {
        if(winImage.image.imageDescription == W.NetworkName)
        {
            break;
        }
    }
    if(W.bSniffing)
    {
        btnSniff.SetButtonText(UnSniffButtonLabel);
        bStopSniffing=true;

    }
    else
    {
        btnSniff.SetButtonText(SniffButtonLabel);
        bStopSniffing=false;
    }

	return True;
}

function SetImage(DataVaultImage newImage)
{

    Super.SetImage(newImage);
    SetDescription(newImage);

}

function SetDescription(DataVaultImage newImage, optional bool bHashing)
{
     local string compString;
     local string tempString;
     local int i, j, diffTab, diffAlg, diff;
     local bool bPartial;
     local string deststr;
     //local Schematic schem;
     //schem = Schematic(newImage);

    local WirelessOverlay W;

    //winImage.SetImage(newImage);
    foreach Player.AllActors(class'WirelessOverlay', W)
    {
        if(winImage.image.imageDescription == W.NetworkName)
        {
            break;
        }

    }
    if(W!=none)
    {
        btnAlg.SetButtonText( "Alg" $ " " $ W.CurAlg) ;
        btnTable.SetButtonText( "Table" $ " " $ W.CurTable) ;
    }
	compString = "";

	for(i=0; i < W.PacketsSniffed && W.Packets[i] != ""; i++)
	{
	    if(bHashing)
        {
     	    tempString = Left(W.Packets[i], 18);
    	    for(j=18; j < len(W.Packets[i])-3; j=j+1)
    	    {
        	    tempString = tempString $ Chr(Rand(26)+97);
            }
        }
	    //Hash decrypted
	    else if(W.CurAlg == W.Alg && W.CurTable == W.Table)
	    {
	        tempstring = W.Packets[i];
	        if(!W.bCracked)
	        {
	            //Play sound to inform player of crack

                Player.PlaySound(Sound'LogGoalCompleted');
	        }
	        W.bCracked = true;
	        deststr = "decryptedanetwork";
            SetPropertyText("NameConversionHack", deststr);
            Player.ClientMessage(NameConversionHack);
            //Nohface fools humans only at level 2

            Player.flagBase.SetBool(NameConversionHack, true);
	    }
	    //Partial decryption
	    else
	    {
	        //calculate difference
	        if( W.CurTable <= W.Table )
	        {
	            diffTab = W.Table - W.CurTable;
	        }
	        else
	        {
	            diffTab = W.CurTable - W.Table;
	        }
	        if( diffTab > 5 )
	        {
	            diffTab = 10 - diffTab;
	        }
 	        //calculate difference
	        if( W.CurAlg <= W.Alg )
	        {
	            diffAlg = W.Alg - W.CurAlg;
	        }
	        else
	        {
	            diffAlg = W.CurAlg - W.Alg;
	        }
	        if( diffAlg > 5 )
	        {
	            diffAlg = 10 - diffAlg;
	        }
	        diff = diffTab + diffAlg;
	        //Player.ClientMessage("Alg differtial = " $ diff);
            if(diff < 4)//(W.CurAlg == W.Alg || W.CurTable == W.Table)
    	    {
    	        bPartial = true;
        	    tempString = Left(W.Packets[i], 17);
        	    for(j=17; j < len(W.Packets[i]); j=j+5)
        	    {
            	    tempString = tempString $ Mid(W.Packets[i], j, 4) $ Rand(7)+2;
                }
            }
            //else if(diff < 3)
            //{
            //}
            //No decryption
            else{
        	    tempString = Left(W.Packets[i], 17);
        	    for(j=17; j < len(W.Packets[i]) - 3; j=j+3)
        	    {
            	    tempString = tempString $ Mid(W.Packets[i], j, 1) $ Chr(Rand(26)+97) $ Rand(7)+2;
                }
            }
         }
	    compString = compString $ tempString $ chr(13)$chr(10);
    }

	if ( newImage == none ){
		winImageTitle.SetText("");
		winInfo.Clear();
		winProfile.Clear();
		winProfTitle.SetText("");
		winCrypTitle.SetText("");
		winAlertTitle.SetText("");
    }
	else{
		winImageTitle.SetText(newImage.imageDescription);

		winInfo.Clear();
        winInfo.SetText(  // chr(13)$chr(10)$chr(13)$chr(10)
        compString  ) ;

        winProfTitle.SetText("Network     Protocol     Security");
        winCrypTitle.SetText("Source                  Packet Data");
        if(W.bAlerted)
            winAlertTitle.SetText("NETWORK ALERTED!!! Continued subversion may result in fatal consequences.");
        else
            winAlertTitle.SetText("");
        // $ chr(13)$chr(10)$ chr(13)$chr(10)
        //$ chr(13)$chr(10) $ "SOURCE               PACKET DATA");

  		winProfile.Clear();
  		tempString = W.NetworkName $ "    "
        $ W.Protocol $ "       "
        $ W.Security $ chr(13)$chr(10)$ chr(13)$chr(10);


        if( Player.SkillSystem.GetSkillLevel(class'SkillComputer') < 1)
            tempString = tempString $
            "                                      (Increase hacking skill to crack networks)";
        else if(W.PacketsSniffed >= 1)
        {
            if(W != none && W.bCracked)
            {
               tempString = tempString $
               "                                      (PACKETS DECRYPTED!!!";
            }
            else if(bPartial)
            {
               tempString = tempString $
               "                                      (partial decryption - keep tweaking)";
            }
            else{
               tempString = tempString $
               "                                      (change algorithm and table to decrypt)";
            }
        }
        //no sniffs yet
        else
            tempString = tempString $
            "                                      (sniff a network for data to decrypt)";

        //if(bPartial)
            winProfile.SetTextColorRGB(150,150,255);
        //else
        //    winProfile.SetTextColor(winProfile.default.textColor);
        winProfile.SetText(tempString);


    }

	//EnableButtons();
}

// ----------------------------------------------------------------------
// AddNote()
//
// Modified to "Connect"
// ----------------------------------------------------------------------

function AddNote()
{
	// Set a variable so the next place the user clicks inside the
	// imgae window a new note is added.
	winImage.SetAddNoteMode(True);

	EnableButtons();
}

function Connect()
{
    NetworkToConnect = winImage.image.imageDescription;
	SaveSettings();
	root.PopWindow();
}

function Sniff()
{
    //NetworkToConnect = winImage.image.imageDescription;
    local WirelessOverlay W;
    local Actor A;

	foreach Player.AllActors(class 'Actor', A, 'sniffstarted')
	{
		A.Trigger(Player, Player);
    }

    if(!bStopSniffing)
    {
        foreach Player.AllActors(class'WirelessOverlay', W)
        {
            W.StopSniffing(Player);

        }
    }
    foreach Player.AllActors(class'WirelessOverlay', W)
    {
        if(winImage.image.imageDescription == W.NetworkName)
        {
            break;
        }
    }

    if(W.NetworkName == winImage.image.imageDescription)
    {
        if(W.bSniffing)
            W.StopSniffing(Player);
        else
            W.BeginSniffing(Player);
    }
	SaveSettings();
	ModHUD(root.hud).mapDisplay.ResetPacketTime();
	ModHUD(root.hud).mapDisplay.ResetAlertTime();
	root.PopWindow();
}

function Tick(float deltaTime)
{
    if( TickTime < 0.5 )
    {
        TickTime += deltaTime;
        SetDescription(winImage.image, true);
    }
    else
    {
        SetDescription(winImage.image, false);
        bTickEnabled = false;
    }
}

//number scrambly thing
function DoHash()
{
    bTickEnabled=true;
    TickTime=0;

}

function ChangeTable(int change)
{
    local WirelessOverlay W;
    foreach Player.AllActors(class'WirelessOverlay', W)
    {
        if(winImage.image.imageDescription == W.NetworkName)
        {
            break;
        }
    }
    W.CurTable += change;
    if(W.CurTable > 10)
        W.CurTable = 1;
    else if(W.CurTable < 1)
        W.CurTable = 10;
    //SetDescription(winImage.image);
    Player.PlaySound(Sound'DXModSounds.Misc.decrypt1',,0.6);
    DoHash();
}

function ChangeAlg(int change)
{
    local WirelessOverlay W;
    foreach Player.AllActors(class'WirelessOverlay', W)
    {
        if(winImage.image.imageDescription == W.NetworkName)
        {
            break;
        }
    }
    W.CurAlg += change;
    if(W.CurAlg > 10)
        W.CurAlg = 1;
    else if(W.CurAlg < 1)
        W.CurAlg = 10;

    //SetDescription(winImage.image);
    Player.PlaySound(Sound'DXModSounds.Misc.decrypt3',,0.6);
    DoHash();
}

function bool ButtonActivated( Window buttonPressed )
{
	local bool bHandled;

	bHandled = True;

	switch(buttonPressed)
	{
		case btnConnect:
			Connect();
			break;

		case btnSniff:
			Sniff();
			break;

		case btnIncAlg:
			ChangeAlg(1);
			break;

		case btnDecAlg:
			ChangeAlg(-1);
			break;

		case btnIncTable:
			ChangeTable(1);
			break;

		case btnDecTable:
			ChangeTable(-1);
			break;

		default:
			bHandled = False;
			break;
	}

	if ( !bHandled )
		bHandled = Super.ButtonActivated(buttonPressed);

	return bHandled;
}

// ----------------------------------------------------------------------
// EnableButtons()
//
// Sets the state of the Add, Delete, Up and Down buttons
// ----------------------------------------------------------------------

function EnableButtons()
{
	local DataVaultImage image;

    local WirelessOverlay W;
    foreach Player.AllActors(class'WirelessOverlay', W)
    {
        if(winImage.image.imageDescription == W.NetworkName)
        {
            break;
        }
    }

	image = winImage.GetImage();

	//btnAddNote.SetSensitivity(image != None);
	btnConnect.SetSensitivity(image != None);
	btnSniff.SetSensitivity(image != none && Player.SkillSystem.GetSkillLevel(class'SkillComputer') > 0);
	btnIncAlg.SetSensitivity(W.PacketsSniffed > 0);
	btnIncTable.SetSensitivity(W.PacketsSniffed > 0);
	btnDecAlg.SetSensitivity(W.PacketsSniffed > 0);
	btnDecTable.SetSensitivity(W.PacketsSniffed > 0);
	//btnDeleteNote.SetSensitivity(winImage.IsNoteSelected());
	chkShowNotes.SetSensitivity(image != None);
	winImage.StrNoImages=("No Networks Available");
}

defaultproperties
{
     ConnectButtonLabel="Connect"
     SniffButtonLabel="Sniff"
     UnSniffButtonLabel="Stop Sniff"
     AlgButtonLabel="Algo"
     TableButtonLabel="Table"
     ImagesTitleText="Hacking"
     clientTextures(4)=Texture'DXModUI.UserInterface.HackBackground_5'
}
