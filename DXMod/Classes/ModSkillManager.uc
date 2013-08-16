//-----------------------------------------------------------
//
//-----------------------------------------------------------
class ModSkillManager extends SkillManager;

//var Class<Skill> skillClasses[30];

//Insert all skill modifications during creation.
//Easier than having to modify all code relating skills
// ----------------------------------------------------------------------
// CreateSkills()
// ----------------------------------------------------------------------
var() localized string		MechanicsDesc;
var() localized string		CircuitBreakingDesc;
var() localized string		Hand2HandDesc;
var() localized string		BiohackingDesc;
var() localized string		SocialEngDesc;
var() localized string		LockpickingDesc;
var() localized string		IEDDesc;
var() localized string		ProjectileDesc;
var() localized string		NaturepunkDesc;
var() localized string		ComputersDesc;
var() localized string		EnviroDesc;

var travel bool bUpgradedPistol;

function CreateSkills(DeusExPlayer newPlayer)
{
	local int skillIndex;
	local Skill aSkill;
	local Skill lastSkill;

	FirstSkill = None;
	LastSkill  = None;

	player = newPlayer;

	for(skillIndex=0; skillIndex<arrayCount(skillClasses); skillIndex++)
	{
		if (skillClasses[skillIndex] != None)
		{
			aSkill = Spawn(skillClasses[skillIndex], Self);
			aSkill.Player = player;

			// Manage our linked list
			if (aSkill != None)
			{
			    if(aSkill.IsA('SkillWeaponPistol'))
			    {
			        aSkill.CurrentLevel = 0;
			    }
				if (FirstSkill == None)
				{
					FirstSkill = aSkill;
				}
				else
				{
					LastSkill.next = aSkill;
				}

				LastSkill  = aSkill;
			}
		}
	}
     SetSkillNames();


}

// ----------------------------------------------------------------------
// AddSkill()
// ----------------------------------------------------------------------

function AddSkill(Skill aNewSkill)
{
	if (aNewSkill.IncLevel())
		Player.ClientMessage(Sprintf(YourSkillLevelAt, aNewSkill.SkillName, aNewSkill.CurrentLevel));

    ModMale(Player).UpdateWeaponAccuracy();
}

event TravelPostAccept()
{
     Super.TravelPostAccept();
     SetSkillNames();
     if(!bUpgradedPistol)
     {
         GetSkillFromClass(class'SkillWeaponPistol').CurrentLevel = 0;

     }
}

//Skill modifications (Yeah, hacky).
function SetSkillNames()
{
	local Skill aSkill;
//Mechanical Tinkering (Lockpicking Originally)
     aSkill = GetSkillFromClass(Class'DeusEx.SkillLockpicking');
     aSkill.SkillName="Mechanical Tinkering";
     aSkill.Description=MechanicsDesc;
     aSkill.cost[0]=1500;
     aSkill.cost[1]=1800;
     aSkill.cost[2]=3000;

//Circuit Breaking (Electronics Originally)
     aSkill = GetSkillFromClass(Class'DeusEx.SkillTech');
     aSkill.SkillName="Circuit Breaking";
     aSkill.Description=CircuitBreakingDesc;
     aSkill.cost[0]=1500;
     aSkill.cost[1]=1800;
     aSkill.cost[2]=3000;

//Hand2Hand (LowTech Originally)
     aSkill = GetSkillFromClass(Class'DeusEx.SkillWeaponLowTech');
     aSkill.SkillName="Weapons: Hand2Hand";
     aSkill.Description=Hand2HandDesc;
     aSkill.cost[0]=1500;
     aSkill.cost[1]=1800;
     aSkill.cost[2]=3000;

//Biohacking (Medicine Originally)
     aSkill = GetSkillFromClass(Class'DeusEx.SkillMedicine');
     aSkill.SkillName="Biohacking";
     aSkill.Description=BiohackingDesc;
     aSkill.cost[0]=1800;
     aSkill.cost[1]=1800;
     aSkill.cost[2]=3000;

//SocialEngineering (WeaponHeavy Originally)
     aSkill = GetSkillFromClass(Class'DeusEx.SkillWeaponHeavy');
     aSkill.SkillName="Social Engineering";
     aSkill.Description=SocialEngDesc;
     aSkill.cost[0]=1500;
     aSkill.cost[1]=1800;
     aSkill.cost[2]=3000;

//Breaking And Entering (Lockpicking Originally)
//     aSkill = GetSkillFromClass(Class'DeusEx.SkillLockpicking');
//     aSkill.SkillName="Breaking And Entering";
//     aSkill.Description=LockpickingDesc;

//Improvised Explosive Devices (Demolition Originally)
     aSkill = GetSkillFromClass(Class'DeusEx.SkillDemolition');
     aSkill.SkillName="Improvised Explosive Devices";
     aSkill.Description=IEDDesc;
     aSkill.cost[0]=1500;
     aSkill.cost[1]=1800;
     aSkill.cost[2]=3000;

//Computer Hacking (Computer Originally)
     aSkill = GetSkillFromClass(Class'DeusEx.SkillComputer');
     aSkill.SkillName="Computer Hacking";
     aSkill.Description=ComputersDesc;
     aSkill.cost[0]=1500;
     aSkill.cost[1]=1800;
     aSkill.cost[2]=3000;

//Naturepunk (WeaponRifle Originally)
     aSkill = GetSkillFromClass(Class'DeusEx.SkillWeaponRifle');
     aSkill.SkillName="Naturepunk";
     aSkill.Description=NaturepunkDesc;
     aSkill.SkillIcon=Texture'DXModUI.UI.NaturepunkIcon';
     aSkill.cost[0]=1500;
     aSkill.cost[1]=1800;
     aSkill.cost[2]=3000;

//Projectiles (WeaponPistol Originally)
     aSkill = GetSkillFromClass(Class'DeusEx.SkillWeaponPistol');
     aSkill.SkillName="Weapons: Projectile";
     aSkill.Description=ProjectileDesc;
     aSkill.cost[0]=1500;
     aSkill.cost[1]=1800;
     aSkill.cost[2]=3000;
     aSkill.LevelValues[0]=0.0500000;
     aSkill.LevelValues[1]=-0.100000;
     aSkill.LevelValues[2]=-0.250000;
     aSkill.LevelValues[3]=-0.500000;

//Enviro
     aSkill = GetSkillFromClass(Class'DeusEx.SkillEnviro');
     aSkill.Description=EnviroDesc;
     aSkill.cost[0]=1000;
     aSkill.cost[1]=1200;
     aSkill.cost[2]=1500;

}

defaultproperties
{
     MechanicsDesc="Dissecting, inventing, repairing and reverse-engineering mechanical devices.|n|nUNTRAINED: A hacktivist breaks any mechanism they attempt to fix. |n|nTRAINED: A hacktivist can take apart and repair radios and simple weapons such as handguns.|n|nADVANCED: A hacktivist can fix cars and build moderately advanced devices (such as EMP rifles) using schematics |n|nMASTER: A hacktivist invents flying, cold-fusion powered cars in his/her sleep."
     CircuitBreakingDesc="Skill with wiring and manipulating electronics.  Increases electricity siphoning speed and decreases likelihood of dangerous accidents.  Reduces the number of Multitools required. |n|nUNTRAINED: An agent can bypass security systems.|n|nTRAINED: The efficiency with which an agent bypasses security increases slightly.|n|nADVANCED: The efficiency with which an agent bypasses security increases moderately.|n|nMASTER: An agent encounters almost no security systems of any challenge."
     Hand2HandDesc="Without this, melee weapons will break and drop often. Increases weapon damage, accuracy, and reduces reloading time. |n|nUNTRAINED: A hacktivist knife fights like a paraplegic Quaker.  Weapons are dropped often. |n|nTRAINED: A hacktivist can shank and slug ok, but is no Batman. |n|nADVANCED: A hacktivist can dispatch most riot cops with a good whack.  |n|nMASTER: You're Chuck Norris."
     BiohackingDesc="Ability to physiologically modify oneself and others using gene-splicing, synthetic biology, and surgical insertions.  Also increases medkit effectiveness.  |n|nUNTRAINED: A hacktivist can install pre-developed biohacks but may botch the procedure resulting in rejection issues.  |n|nTRAINED: A hacktivist can develop basic biohacks and install them with reasonable proficiency.  Medkit healing slightly increased.  |n|nADVANCED: A hacktivist can invent and install advanced biohacks.  Medkit healing moderately increased.  |n|nMASTER: A hacktivist is on the bleeding-edge of black clinic biotech and can perform a quadruple bypass in his/her sleep."
     SocialEngDesc="Your ability to pursuade others into doing what you want, to lie, and to impersonate others.  Affects facial identity masking, social engineering hacks, and item prices. |n|nUNTRAINED: Lieing, impersonating, haggling will usually result in failure. |n|nTRAINED: Hacktivist is moderate at persuasion, can use facial identity masks against security cameras. |n|nADVANCED: You're adept at manipulation, can fool humans with facial masking, and can bargain well. |n|nMASTER: You're a corporate thinktank-grade liar and manipulator."
     LockpickingDesc="Reduces the number of lockpicks required when Lockpicking and ability to crack safes."
     IEDDesc="Building and using IEDs from household chemicals and undetonated munitions.  Also affects launched explosives such as RPGs, and other heavy weaponry. |n|nUNTRAINED: You can light matches. |n|nTRAINED: A hacktivist can build basic IEDs and detonate them. |n|nADVANCED: The explosive yield of your IEDs is greatly increased. |n|nMASTER: You're MacGuyver but with a better haircut."
     ProjectileDesc="Increases weapon damage, accuracy, and reduces reloading time of pistols and rifles. |n|nUNTRAINED: An agent can use pistols and rifles.|n|nTRAINED: Accuracy and damage increases slightly, while reloading is faster. |n|nADVANCED: Accuracy and damage increases moderately, while reloading is even more rapid. |n|nMASTER: An agent is lethally precise with projectile weapons."
     NaturepunkDesc="Your knowledge and expertise with plants and animals.  Natural remedies, growing of food, and ability to work with animals.  Increases the amount of health regained by eating food. |n|nUNTRAINED: A hacktivist mostly eats GMOs and probably has multiple artificial plagues. |n|nTRAINED: You can harvest twice the meat from animals and have basic understanding of plants.  |n|nADVANCED: You know how to grow your own food using microponics systems.  |n|nMASTER: You're fully self-sustaining island of green-ness."
     ComputersDesc="The deciphering of codes, breaking of passwords, intrusion into secure systems. |n|nUNTRAINED: A hacktivist can access computers and wireless networks. |n|nTRAINED: A hacktivist can sniff Wi-Fi and perform basic cryptographic analysis |n|nADVANCED: A hacktivist can develop malware to upload to enemy systems and disrupt cloud intranets. |n|nMASTER: A hacktivist can usurp entire enemy armies with a paper clip, a weenie whistle, and a 14.4 KBPS connection."
     EnviroDesc="Experience with using enviro-equipment and affects efficacy of wearable mods including trenchcoat and solarcoat. |n|nUNTRAINED: A hacktivist can use wearable environmental equipment. |n|nTRAINED: Armor, suits, camo, and rebreathers can be used slightly longer and more efficiently.|n|nADVANCED: Armor, suits, camo, and rebreathers can be used moderately longer and more efficiently.|n|nMASTER: A hacktivist wears suits and armor like a second skin."
}
