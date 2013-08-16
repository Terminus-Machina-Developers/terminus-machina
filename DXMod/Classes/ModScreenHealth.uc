//-----------------------------------------------------------
//
//-----------------------------------------------------------
class ModScreenHealth extends PersonaScreenHealth;

function CreateNavBarWindow()
{
	winNavBar = PersonaNavBarBaseWindow(NewChild(Class'ModNavBarWindow'));
	winNavBar.SetPos(0, 0);
}

defaultproperties
{
}
