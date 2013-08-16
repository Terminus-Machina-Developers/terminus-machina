//-----------------------------------------------------------
//
//-----------------------------------------------------------
class ModNavBarWindow extends PersonaNavBarWindow;

var PersonaNavButtonWindow btnMake;
var PersonaNavButtonWindow btnHack;

var localized String MakeButtonLabel;
var localized String HackButtonLabel;

function CreateButtons()
{

	Super.CreateButtons();
 	btnMake    = CreateNavButton(winNavButtons, MakeButtonLabel);
 	btnHack    = CreateNavButton(winNavButtons, HackButtonLabel);

}

// ----------------------------------------------------------------------
// ButtonActivated()
// ----------------------------------------------------------------------

function bool ButtonActivated( Window buttonPressed )
{
	local bool bHandled;
	local Class<PersonaScreenBaseWindow> winClass;

	bHandled = True;

	switch(buttonPressed)
	{
		case btnInventory:
			winClass = Class'ModScreenInventory';
			break;

		case btnHealth:
			winClass = Class'ModScreenHealth';
			break;

		case btnAugs:
			winClass = Class'ModScreenAugmentations';
			break;

		case btnSkills:
			winClass = Class'ModScreenSkills';
			break;

		case btnGoals:
			winClass = Class'ModScreenGoals';
			break;

		case btnCons:
			winClass = Class'ModScreenConversations';
			break;

		case btnImages:
			winClass = Class'ModScreenImages';
			break;

		case btnLogs:
			winClass = Class'ModScreenLogs';
			break;

		case btnMake:
			winClass = Class'ModScreenMake';
			break;

		case btnHack:
			winClass = Class'ModScreenHack';
			break;

		default:
			bHandled = False;
			break;
	}

	if (bHandled)
	{
		PersonaScreenBaseWindow(GetParent()).SaveSettings();
		root.InvokeUIScreen(winClass);
		return bHandled;
	}
	else
	{
		return Super.ButtonActivated(buttonPressed);
	}
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     MakeButtonLabel="Make"
     HackButtonLabel="Hack"
     InventoryButtonLabel="|&Inv"
     GoalsButtonLabel="|&Goals"
     ConsButtonLabel="|&Conv"
     ImagesButtonLabel="Faces"
}
