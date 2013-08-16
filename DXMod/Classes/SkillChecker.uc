//-----------------------------------------------------------
//
//-----------------------------------------------------------
class SkillChecker expands Trigger;

var() Class<Skill> skillClass;
var() int skillLevel;
var() bool bLessThan;
var() name flagname;
var() bool flagvalue;

function Trigger( actor Other, pawn EventInstigator )
{
    local DeusExPlayer Player;
    Player = DeusExPlayer(GetPlayerPawn());
    if(Player == none)
        return;

    if(bLessThan)
    {
        if(Player.SkillSystem.GetSkillLevel(skillClass) < skillLevel)
            player.flagBase.SetBool(flagname, flagvalue);
    }
    else
    {
        //Player.ClientMessage("skill level = " $
        //Player.SkillSystem.GetSkillLevel(skillClass));
        if(Player.SkillSystem.GetSkillLevel(skillClass) >= skillLevel)
            player.flagBase.SetBool(flagname, flagvalue);

        //Player.ClientMessage("Flag = " $ player.flagBase.CheckFlag(flagname, FLAG_int));
    }
}

defaultproperties
{
     skillClass=Class'DeusEx.SkillTech'
     skillLevel=1
     flagValue=True
}
