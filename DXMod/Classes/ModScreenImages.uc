//-----------------------------------------------------------
//
//-----------------------------------------------------------
class ModScreenImages extends PersonaScreenImages;

function CreateNavBarWindow()
{
	winNavBar = PersonaNavBarBaseWindow(NewChild(Class'ModNavBarWindow'));
	winNavBar.SetPos(0, 0);
}

function SetImage(DataVaultImage newImage)
{


     ModMale(root.parentPawn).SetPhace(PhaceBookFace(newImage));
    Super.SetImage(newImage);
	winImage.SetImage(newImage);

	if ( newImage == None )
		winImageTitle.SetText("");
	else
		winImageTitle.SetText(newImage.imageDescription);

	EnableButtons();
}

// ----------------------------------------------------------------------
// PopulateImagesList()
// ----------------------------------------------------------------------

function PopulateImagesList()
{
	local DataVaultImage image;
	local int rowId;

	// First clear the list
	lstImages.DeleteAllRows();

	// Loop through all the notes the player currently has in
	// his possession
    if(ModMale(Player) != none)
    {
    	image = ModMale(Player).FirstPhace;
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
	else
	{
	    Player.ClientMessage("Player Not a ModMale");

	}
}

defaultproperties
{
     ImagesTitleText="Faces"
}
