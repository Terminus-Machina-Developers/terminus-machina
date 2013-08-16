//-----------------------------------------------------------
//
//-----------------------------------------------------------
class Schematic extends Actor;

var texture         imageTexture;
var int				sizeX;
var int				sizeY;
var travel localized String			imageDescription;
//mechanics skill requirements
var int mechNeeded;
var int elecNeeded;
var int iedNeeded;
var int bioNeeded;
var int natureNeeded;
var localized String			longDesc;
var class<Inventory> product;
var Class<Inventory> components[10];
var int SaveComponents[10];                       //Don't delete these items if true
var int numComponents[10];
var Class<Inventory> ExtraSpawn[10];                       //Additional Items to Spawn
var int numProduct[4];                               //How many to give the player
var Class<Skill> GoverningSkill;                   //if more copies are given at higher levels
// Pointer to next schematic
var travel Schematic next;
var DeusExPlayer player;
var bool bScrappable;                 //Item can be scrapped
var bool bMakeable;                   //Item can be crafted
var travel bool bAcquired;          //whether the player has this schematic
//var bool bIncludeSubclasses;        //Can be made with subclasses of the primary components



//UpdateInfo
function bool UpdateInfo(Object winObject)
{
	local PersonaInfoWindow winInfo;
	local int i;

	winInfo = PersonaInfoWindow(winObject);
	if (winInfo == None)
		return False;

	winInfo.Clear();
	winInfo.SetTitle(imageDescription);

	winInfo.SetText( longDesc);

	winInfo.AppendText(winInfo.CR() $ winInfo.CR() $ Sprintf("Components Required: " ));
	for( i=0; components[i] != none; i++)
	{
	    winInfo.AppendText(winInfo.CR() $ Sprintf( "* " $ components[i].default.ItemName ));
	}
	winInfo.AppendText(winInfo.CR());
	if( mechNeeded > 0)
	{
	    winInfo.AppendText(winInfo.CR() $ Sprintf("Mechanics Needed: " $ mechNeeded));
	    if( ModMale(Player).SkillSystem.GetSkillLevel(Class'SkillLockpicking') < mechNeeded)
	    {
 	        winInfo.AppendText(winInfo.CR() $ Sprintf("WARNING: insufficient mechanic skill.  Construction may result in item damage, injury, or death!"));
	    }
    }
	if( elecNeeded > 0)
	{
        winInfo.AppendText(winInfo.CR() $ Sprintf("Circuit Breaking Needed: " $ elecNeeded));
        if( ModMale(Player).SkillSystem.GetSkillLevel(Class'SkillTech') < elecNeeded)
	    {
 	        winInfo.AppendText(winInfo.CR() $ Sprintf("WARNING: insufficient circuit breaking skill.  Construction may result in item damage, injury, or death!"));
	    }
    }
     if( iedNeeded > 0)
     {
        winInfo.AppendText(winInfo.CR() $ Sprintf("Explosives Needed: " $ iedNeeded));
         if( ModMale(Player).SkillSystem.GetSkillLevel(Class'SkillDemolition') < iedNeeded)
	    {
 	        winInfo.AppendText(winInfo.CR() $ Sprintf("WARNING: insufficient IED skill.  Construction may result in item damage, injury, or death!"));
	    }
    }
 	if( bioNeeded > 0)
 	{
        winInfo.AppendText(winInfo.CR() $ Sprintf("Biohacking Needed: " $ bioNeeded));
        if( ModMale(Player).SkillSystem.GetSkillLevel(Class'SkillMedicine') < bioNeeded)
	    {
 	        winInfo.AppendText(winInfo.CR() $ Sprintf("WARNING: insufficient biohacking skill.  Construction may result in item damage, injury, or death!"));
	    }
    }
}

//IsComponent    - checks to see if an item is one of the components
function bool IsComponent(class<Inventory> comp)
{
    local int i;
    for(i=0; components[i] != none; i++)
    {
        if(comp == components[i])
            return true;
    }
    return false;
}

defaultproperties
{
     imageDescription="Schematic"
     longDesc="Some details about this schematic should be showing up here."
     components(0)=Class'DXMod.Seeds'
     numComponents(0)=1
     numProduct(0)=1
     numProduct(1)=1
     numProduct(2)=1
     numProduct(3)=1
     bScrappable=True
     bMakeable=True
     bHidden=True
     bTravel=True
     NetUpdateFrequency=5.000000
}
