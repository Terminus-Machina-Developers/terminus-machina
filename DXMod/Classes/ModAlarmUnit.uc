//-----------------------------------------------------------
//
//-----------------------------------------------------------
class ModAlarmUnit extends AlarmUnit;

//
// Called every 0.1 seconds while the multitool is actually hacking
//
//Need to add code for power siphoning (uses hacking code)
function Timer()
{
	if (bHacking)
	{
		curTool.PlayUseAnim();

	  TicksSinceLastHack += (Level.TimeSeconds - LastTickTime) * 10;
	  LastTickTime = Level.TimeSeconds;
      //TicksSinceLastHack = TicksSinceLastHack + 1;
      if(curTool.IsA('Voltear'))
      {
          //hackPlayer.ClientMessage("Hacking with Voltear");
          while (TicksSinceLastHack > TicksPerHack)
          {
             numHacks--;
             //hackStrength -= 0.01;
             TicksSinceLastHack = TicksSinceLastHack - TicksPerHack;
             //hackStrength = FClamp(hackStrength, 0.0, 1.0);
             //hackPlayer.Energy += 1;
             Voltear(curTool).giveOwnerEnergy(self);

          }

    		// did we hack it?
    		if (hackStrength ~= 0.0)
    		{
    			hackStrength = 0.0;
    			hackPlayer.ClientMessage(msgMultitoolSuccess);
             // Start reset counter from the time you finish hacking it.
             TimeSinceReset = 0;
    			StopHacking();
    			HackAction(hackPlayer, True);
    		}

    		// are we done with this tool?
    		else if (numHacks <= 0)
    			StopHacking();

    		// check to see if we've moved too far away from the device to continue
    		else if (hackPlayer.frobTarget != Self)
    			StopHacking();

    		// check to see if we've put the multitool away
    		else if (hackPlayer.inHand != curTool)
    			StopHacking();
      }
      while (TicksSinceLastHack > TicksPerHack)
      {
         numHacks--;
         hackStrength -= 0.01;
         TicksSinceLastHack = TicksSinceLastHack - TicksPerHack;
         hackStrength = FClamp(hackStrength, 0.0, 1.0);
      }

		// did we hack it?
		if (hackStrength ~= 0.0)
		{
			hackStrength = 0.0;
			hackPlayer.ClientMessage(msgMultitoolSuccess);
         // Start reset counter from the time you finish hacking it.
         TimeSinceReset = 0;
			StopHacking();
			HackAction(hackPlayer, True);
		}

		// are we done with this tool?
		else if (numHacks <= 0)
			StopHacking();

		// check to see if we've moved too far away from the device to continue
		else if (hackPlayer.frobTarget != Self)
			StopHacking();

		// check to see if we've put the multitool away
		else if (hackPlayer.inHand != curTool)
			StopHacking();
	}
}

defaultproperties
{
}
