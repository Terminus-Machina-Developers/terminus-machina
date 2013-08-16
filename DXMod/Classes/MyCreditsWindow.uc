//=============================================================================
// MyCreditsWindow
//=============================================================================
class MyCreditsWindow extends CreditsWindow;

#exec OBJ LOAD FILE=DXOgg

var string textPackage;

// ----------------------------------------------------------------------
// ProcessText()
// ----------------------------------------------------------------------

function ProcessText()
{
    local DeusExTextParser parser;

    PrintPicture(CreditsBannerTextures, 2, 1, 505, 75);
    PrintLn();

    // First check to see if we have a name
    if (textName != '')
    {
        // Create the text parser
        parser = new(None) Class'DeusExTextParser';

        // Attempt to find the text object
        if (parser.OpenText(textName,textPackage))
        {
            while(parser.ProcessText())
                ProcessTextTag(parser);

            parser.CloseText();
        }

    CriticalDelete(parser);
    }

    ProcessFinished();
}

// ----------------------------------------------------------------------
// StartMusic()
// ----------------------------------------------------------------------

function StartMusic()
{
	local Music CreditsMusic;
	local DXOggMusicManager OMM;

	foreach player.AllActors(class'DXOggMusicManager', OMM)
	{
	    OMM.SetCurrentOgg(ScrollMusicString, ScrollMusicString, 0.0, MTran_Instant);
	}


}

// ----------------------------------------------------------------------
// StopMusic()
// ----------------------------------------------------------------------

function StopMusic()
{
	local DXOggMusicManager OMM;

	foreach player.AllActors(class'DXOggMusicManager', OMM)
	{
	    OMM.SetCurrentOgg("", "", 0.0, MTran_Instant);
	}
}

defaultproperties
{
     TextPackage="DXModText"
     CreditsBannerTextures(0)=Texture'DXModUI.UI.CreditsBanner_1'
     CreditsBannerTextures(1)=Texture'DXModUI.UI.CreditsBanner_2'
     TeamPhotoTextures(0)=Texture'DXModUI.UI.CreditsBanner_1'
     TeamPhotoTextures(1)=Texture'DXModUI.UI.CreditsBanner_2'
     TeamPhotoTextures(2)=None
     ScrollMusicString="TerminusCredits.ogg"
     textName=MyCredits
}
