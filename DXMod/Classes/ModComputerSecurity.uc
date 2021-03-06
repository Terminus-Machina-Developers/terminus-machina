//-----------------------------------------------------------
//
//-----------------------------------------------------------
class ModComputerSecurity extends ComputerSecurity;

#exec OBJ LOAD FILE=DXModUI

var(ModComputerSecurity) string CompNode;
var sNodeInfo CompNodes[20];
// ----------------------------------------------------------------------
// Frob()
// ----------------------------------------------------------------------

function Frob(Actor Frobber, Inventory frobWith)
{
    /*local DeusExPlayer DXP;

    DXP = DeusExPlayer(Frobber);

    if(DXP != none){
           DXP.InvokeComputerScreen(self, lastHackTime, Level.TimeSeconds);
    }  */


	local DeusExPlayer player;
	local float elapsed, delay;

   // Don't allow someone else to use the computer when already in use.
   if (curFrobber != None)
   {
      if (DeusExPlayer(Frobber) != None)
         DeusExPlayer(Frobber).ClientMessage(Sprintf(CompInUseMsg,curFrobber.PlayerReplicationInfo.PlayerName));
      return;
   }

   // DEUS_EX AMSD get player from frobber, not from getplayerpawn
	player = DeusExPlayer(Frobber);
	if (player != None)
	{
		if (bLockedOut)
		{
			// computer skill shortens the lockout duration
			delay = lockoutDelay / player.SkillSystem.GetSkillLevelValue(class'SkillComputer');

			elapsed = Level.TimeSeconds - lockoutTime;
			if (elapsed < delay)
				player.ClientMessage(Sprintf(msgLockedOut, Int(delay - elapsed)));
			else
				bLockedOut = False;
		}
		if (!bAnimating && !bLockedOut)
      {

         //bOn=false;
         curFrobber = player;
			GotoState('On');
		 TryInvoke();
      }
	}
}

// ----------------------------------------------------------------------
// state On
// ----------------------------------------------------------------------

state On
{
	function Tick(float deltaTime)
	{
		Global.Tick(deltaTime);

		if (bOn)
		{
			if ((termwindow == None) && (Level.NetMode == NM_Standalone))
         {
				GotoState('Off');
         }
         if (curFrobber == None)
         {
            GotoState('Off');
         }
         //Don't switch off computer because player might be wirelessly connected
         /*
         else if (VSize(curFrobber.Location - Location) > 1500)
         {
            log("Disabling computer "$Self$" because user "$curFrobber$" was too far away");
			//Probably should be "GotoState('Off')" instead, but no good way to test, so I'll leave it alone.
            curFrobber = None;
         }
         */
		}
	}

Begin:
	if (!bOn)
	{
      AdditionalActivation(curFrobber);
		bAnimating = True;
		PlayAnim('Activate');
		FinishAnim();
		bOn = True;
		bAnimating = False;
		ChangePlayerVisibility(False);
      TryInvoke();
	}

}

auto state Off
{
Begin:
	if (bOn)
	{
      AdditionalDeactivation(curFrobber);
		ChangePlayerVisibility(True);
		bAnimating = True;
		PlayAnim('Deactivate');
		FinishAnim();
		bOn = False;
		bAnimating = False;
		if (bLockedOut)
			BeginAlarm();

		// Resume any datalinks that may have started while we were
		// in the computers (don't want them to start until we pop back out)
		ResumeDataLinks();
      curFrobber = None;
	}
}

// ----------------------------------------------------------------------
// CloseOut()
// ----------------------------------------------------------------------

function CloseOut()
{
   if (curFrobber != None)
   {
      curFrobber = None;
      GotoState('Off');
   }
}

function int GetNodeInt(String node)
{
    if(CompNode=="CYBERSEC")
        return 0;
    else if(CompNode=="STORMCLOUD")
        return 1;
    else if(CompNode=="GNOSSIS")
        return 2;
    else if(CompNode=="NUKILAS")
        return 3;
}

// ----------------------------------------------------------------------
// GetNodeName()
// ----------------------------------------------------------------------

function String GetNodeName()
{
        return CompNodes[GetNodeInt(CompNode)].nodeName;
}

// ----------------------------------------------------------------------
// GetNodeDesc()
// ----------------------------------------------------------------------

function String GetNodeDesc()
{
    return CompNodes[GetNodeInt(CompNode)].nodeDesc;
	//return nodeInfo[Int(ComputerNode)].nodeDesc;
}

// ----------------------------------------------------------------------
// GetNodeAddress()
// ----------------------------------------------------------------------

function String GetNodeAddress()
{
    return CompNodes[GetNodeInt(CompNode)].nodeAddress;
//	return nodeInfo[Int(ComputerNode)].nodeAddress;
}

// ----------------------------------------------------------------------
// GetNodeName()
// ----------------------------------------------------------------------

function String GetNodeNameString(String S)
{
        return CompNodes[GetNodeInt(S)].nodeName;
}

// ----------------------------------------------------------------------
// GetNodeDesc()
// ----------------------------------------------------------------------

function String GetNodeDescString(String S)
{
    return CompNodes[GetNodeInt(S)].nodeDesc;
	//return nodeInfo[Int(ComputerNode)].nodeDesc;
}

// ----------------------------------------------------------------------
// GetNodeAddress()
// ----------------------------------------------------------------------

function String GetNodeAddressString(String S)
{
    return CompNodes[GetNodeInt(S)].nodeAddress;
//	return nodeInfo[Int(ComputerNode)].nodeAddress;
}

defaultproperties
{
     CompNodes(0)=(nodeName="CYBERSEC",nodeAddress="AMERIBANK//CYBERSEC//RESTRICTED//943.138.4490",nodeTexture=Texture'DXModUI.UserInterface.LogoCyberSecBig')
     CompNodes(1)=(nodeName="STORM CLOUD",nodeAddress="P2PX//***.***.*.*//H4CK.T3H.G1B50N",nodeTexture=Texture'DXModUI.UserInterface.LogoHexGenBig')
     CompNodes(2)=(nodeName="GNOSSIS",nodeAddress="GNOSSIS//KAIROPLEX//841.475.8130",nodeTexture=Texture'DeusExUI.UserInterface.ComputerLogonLogoMJ12')
     CompNodes(3)=(nodeName="NUKILAS",nodeAddress="MYNETWORK//NUKILANET//THUGLIFE//943.138.4490",nodeTexture=Texture'DXModUI.UserInterface.LogoNukilasBig')
     terminalType=Class'DXMod.ModTerminalSecurity'
}
