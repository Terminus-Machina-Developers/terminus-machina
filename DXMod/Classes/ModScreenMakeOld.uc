//-----------------------------------------------------------
//
//-----------------------------------------------------------
class ModScreenMakeOld extends PersonaScreenImages;


// Attempting to use this as the "recipe" list
// ----------------------------------------------------------------------
// CreateNanoKeyRingWindow()
// ----------------------------------------------------------------------

#exec obj load file=DXModUI

var texture					MakeIcon;
var PersonaItemDetailWindow       winNanoKeyRing;
var PersonaInfoWindow					winInfo;

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

function CreateControls()
{
    Super.CreateControls();

 //Schematic info window
	winInfo = PersonaInfoWindow(winClient.NewChild(Class'PersonaInfoWindow'));
	winInfo.SetPos(50, 270);
	winInfo.SetSize(238, 210);
    winInfo.SetTitle("");
    winInfo.SetText("");
    winInfo.Clear();
}

// ----------------------------------------------------------------------
// CreateNavBarWindow()
// ----------------------------------------------------------------------

function CreateNavBarWindow()
{
	winNavBar = PersonaNavBarBaseWindow(NewChild(Class'ModNavBarWindow'));
	winNavBar.SetPos(0, 0);
}

//images are used for schematics
function PopulateImagesList()
{
	local DataVaultImage image;
	local int rowId;

	// First clear the list
	lstImages.DeleteAllRows();

	// Loop through all the notes the player currently has in
	// his possession

	image = ModMale(Player).FirstSchem;
	while(image != None)
	{
		rowId = lstImages.AddRow(image.imageDescription);

		// Check to see if we need to display *New* in the second column
		if (image.bPlayerViewedImage == False)
			lstImages.SetField(rowId, 1, "C");

		// Save the image away
		lstImages.SetRowClientObject(rowId, image);

		image = image.NextImage;
	}
}
 /*
function SetImage(DataVaultImage newImage)
{
     local string compString;
     local int i;
     local Schematic schem;
     schem = Schematic(newImage);

    Super.SetImage(newImage);
	winImage.SetImage(newImage);

	compString = "";
	for(i=0; schem.components[i] != None; i++)
	{
	    compString = compString $ schem.components[i].default.ItemName @ "( " $ schem.numComponents[i] $ " ) ";
    }
	if ( newImage == None ){
		winImageTitle.SetText("");
		winInfo.Clear();
  }
	else{
		winImageTitle.SetText(newImage.imageDescription);
		winInfo.Clear();
        winInfo.SetText("MECHANICAL SKILL REQUIRED: "
        $ schem.mechNeeded $ chr(13)$chr(10)
        $ "COMPONENTS NEEDED: " $ compString $ chr(13)$chr(10)$chr(13)$chr(10)
        $ schem.longDesc  ) ;
    }
	EnableButtons();
}   */

defaultproperties
{
     MakeIcon=Texture'DXModUI.UI.IconMake'
     ImagesTitleText="Make"
}
