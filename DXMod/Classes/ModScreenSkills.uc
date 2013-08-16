//-----------------------------------------------------------
//
//-----------------------------------------------------------
class ModScreenSkills extends PersonaScreenSkills;


function CreateNavBarWindow()
{
	winNavBar = PersonaNavBarBaseWindow(NewChild(Class'ModNavBarWindow'));
	winNavBar.SetPos(0, 0);
}

// ----------------------------------------------------------------------
// UpgradeSkill()
// ----------------------------------------------------------------------

function UpgradeSkill()
{
	// First make sure we have a skill selected
	if ( selectedSkill == None )
		return;

	selectedSkill.IncLevel();
	if(selectedSkill.IsA('SkillWeaponPistol'))
	{
        ModSkillManager(player.SkillSystem).bUpgradedPistol = true;
	}
    selectedSkillButton.RefreshSkillInfo();

	// Send status message
	winStatus.AddText(Sprintf(SkillUpgradedLevelLabel, selectedSkill.SkillName));

	winSkillPoints.SetText(player.SkillPointsAvail);

	EnableButtons();
}

defaultproperties
{
}
