//-----------------------------------------------------------
//
//-----------------------------------------------------------
class ModSpecialOptions expands ComputerScreenSpecialOptions;

var  MenuUIChoiceButton MalwareButton;

// ----------------------------------------------------------------------
// CreateOptionButtons()
// ----------------------------------------------------------------------

function CreateOptionButtons()
{
	local int specialIndex;
	local int numOptions;
	local MenuUIChoiceButton winButton;
	//local MenuUIChoiceButton MalwareButton;

	// Figure out how many special options we have

	numOptions = 0;
	for (specialIndex=0; specialIndex<ArrayCount(Computers(compOwner).specialOptions); specialIndex++)
	{
		if ((Computers(compOwner).specialOptions[specialIndex].userName == "") || (Caps(Computers(compOwner).specialOptions[specialIndex].userName) == winTerm.GetUserName()))
		{
			if (Computers(compOwner).specialOptions[specialIndex].Text != "")
			{
				// Create the button
				winButton = MenuUIChoiceButton(winClient.NewChild(Class'MenuUIChoiceButton'));
				winButton.SetPos(buttonLeftMargin, firstButtonPosY + (numOptions * MiddleTextureHeight));
				winButton.SetButtonText(Computers(compOwner).specialOptions[specialIndex].Text);
				winButton.SetSensitivity(!Computers(compOwner).specialOptions[specialIndex].bAlreadyTriggered);
				winButton.SetWidth(273);

				optionButtons[numOptions].specialIndex = specialIndex;
				optionButtons[numOptions].btnSpecial   = winButton;

                if(Computers(compOwner).specialOptions[specialIndex].Text == "Upload Malware")
			    {
			         MalwareButton = winButton;
			         //winButton.SetText("Malware");
			         //winButton.DisableWindow();
			         winButton.SetSensitivity(false);
                     //GetPlayerPawn().ClientMessage("Malware requires advanced computer hacking skills.");
                }

				numOptions++;
            }
		}
	}

	ComputerUIScaleClientWindow(winClient).SetNumMiddleTextures(numOptions);

	// Update the location of the Special Info window and the Status window
	winSpecialInfo.SetPos(10, specialOffsetY + TopTextureHeight + (MiddleTextureHeight * numOptions));
	statusPosY = statusPosYOffset + TopTextureHeight + (MiddleTextureHeight * numOptions);
	AskParentForReconfigure();

     SetMalware();
}

// ----------------------------------------------------------------------
// UpdateOptionsButtons()
// ----------------------------------------------------------------------

function UpdateOptionsButtons()
{
     SetMalware();
}

function SetMalware()
{
    local DeusExPlayer Player;
    Player = DeusExPlayer(GetPlayerPawn());
    if(MalwareButton != none)
    {
         if(Player.SkillSystem.GetSkillLevel(class'SkillComputer') < 2)
         {
             MalwareButton.SetButtonText("Upload Malware: lvl 2 hacking required");
             //MalwareButton.DisableWindow();
             MalwareButton.SetSensitivity(false);
             //GetPlayerPawn().ClientMessage("Malware requires advanced computer hacking skills.");
         }
         else
         {
             MalwareButton.SetSensitivity(true);
         }
    }
}

// ----------------------------------------------------------------------
// CreateControls()
// ----------------------------------------------------------------------

function CreateControls()
{
	Super.CreateControls();
    SetMalware();

}

defaultproperties
{
}
