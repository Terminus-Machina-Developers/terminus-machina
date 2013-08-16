//-----------------------------------------------------------
//
//-----------------------------------------------------------
class ModSecurityCamera extends SecurityCamera;

var(ModSecurityCamera) float AlarmSoundRadius;
var(ModSecurityCamera) float BeepSoundRadius;
var(ModSecurityCamera) float AmbSoundRadius;
var(ModSecurityCamera) float TriggerSpeed;
var(ModSecurityCamera) float AlertRadius;
var(ModSecurityCamera) bool bCallAirstrike;
var(ModSecurityCamera) bool bInstantStrike;


function PostBeginPlay()
{
    super.PostBeginPlay();
    SoundRadius = AmbSoundRadius;
}

//need to adjust Alarm Sound Radius
function TriggerEvent(bool bTrigger)
{
	bEventTriggered = bTrigger;
	bTrackPlayer = bTrigger;
	triggerTimer = 0;

	// now, the camera sounds its own alarm
	if (bTrigger)
	{
	/*
		AmbientSound = Sound'Klaxon2';
		SoundVolume = 128;
		SoundRadius = AlarmSoundRadius;
		LightHue = 0;
		MultiSkins[2] = Texture'RedLightTex';
		AIStartEvent('Alarm', EAITYPE_Audio, SoundVolume/255.0, 25*(SoundRadius+1));

		// make sure we can't go into stasis while we're alarming
		bStasis = False;  */
		AmbientSound = Sound'Klaxon2';
		SoundVolume = 128;
		SoundRadius = 64;
		LightHue = 0;
		MultiSkins[2] = Texture'RedLightTex';
		if(AlertRadius > 0)
		    AIStartEvent('Alarm', EAITYPE_Audio, SoundVolume/255.0, AlertRadius);
        else
      		AIStartEvent('Alarm', EAITYPE_Audio, SoundVolume/255.0, 25*(SoundRadius+1));
		// make sure we can't go into stasis while we're alarming
		bStasis = False;
        AttackPlayer();
	}
	else
	{
		AmbientSound = Sound'CameraHum';
		SoundRadius = AmbSoundRadius;
		SoundVolume = 192;
		LightHue = 80;
		MultiSkins[2] = Texture'GreenLightTex';
		AIEndEvent('Alarm', EAITYPE_Audio);

		// reset our stasis info
		bStasis = Default.bStasis;
	}
}

function CheckPlayerVisibility(DeusExPlayer player)
{
	local float yaw, pitch, dist;
	local Actor hit;
	local Vector HitLocation, HitNormal;
	local Rotator rot;
	local ModMale modPlayer;

   if (player == None)
      return;
	dist = Abs(VSize(player.Location - Location));

    modPlayer = ModMale(player);
    if (modPlayer == None)
    {
      modPlayer.ClientMessage("No modPlayer");
      return;
    }
	// if the player is in range
	if (player.bDetectable && !player.bIgnore && (dist <= cameraRange))
	{
		hit = Trace(HitLocation, HitNormal, player.Location, Location, True);
		if (hit == player)
		{
			// If the player's RadarTrans aug is on, the camera can't see him
         // DEUS_EX AMSD In multiplayer, we've already done this test with
         // AcquireMultiplayerTarget
         if (Level.Netmode == NM_Standalone)
         {
            //if (player.AugmentationSystem.GetAugLevelValue(class'AugRadarTrans') != -1.0)
            //   return;
         }

         //Check if player is "wanted"

         if(modPlayer.bNohface) //modPlayer.Alliance != 'Player' )
         {
             //modPlayer.ClientMessage("modPlayer disguised");
             return;
         }


			// figure out if we can see the player
			rot = Rotator(player.Location - Location);
			rot.Roll = 0;
			yaw = (Abs(Rotation.Yaw - rot.Yaw)) % 65536;
			pitch = (Abs(Rotation.Pitch - rot.Pitch)) % 65536;

			// center the angles around zero
			if (yaw > 32767)
				yaw -= 65536;
			if (pitch > 32767)
				pitch -= 65536;

			// if we are in the camera's FOV
			if ((Abs(yaw) < cameraFOV) && (Abs(pitch) < cameraFOV))
			{
				// rotate to face the player
				if (bTrackPlayer)
					DesiredRotation = rot;

				lastSeenTimer = 0;
				bPlayerSeen = True;
				bTrackPlayer = True;
            bFoundCurPlayer = True;

                if(bInstantStrike)
                {
                    AttackPlayer();
                }

				playerLocation = player.Location - vect(0,0,1)*(player.CollisionHeight-5);

				// trigger the event if we haven't yet for this sighting
				if (!bEventTriggered && (triggerTimer >= triggerDelay*TriggerSpeed) && (Level.Netmode == NM_Standalone))
					TriggerEvent(True);

				return;
			}
		}
	}
}

function AttackPlayer()
{
		if(bCallAirstrike && ModMale(GetPlayerPawn()) != none)
		{
		    if(Rand(10) < 5)
		        ModMale(GetPlayerPawn()).GetAirstrike();
		    else
                Modhud(ModRootWindow(ModMale(GetPlayerPawn()).RootWindow).hud).mapDisplay.DroidsCloseIn();

        }
}

//Needed to adjust Sound radius (cameras can see farther now)
function Tick(float deltaTime)
{
	local float ang;
	local Rotator rot;
   local DeusExPlayer curplayer;

   Super.Tick(deltaTime);

   curTarget = None;

   // if this camera is not active, get out
	if (!bActive)
	{
      // DEUS_EX AMSD For multiplayer
      ReplicatedRotation = DesiredRotation;

		MultiSkins[2] = Texture'BlackMaskTex';
		return;
	}

	// if we've been EMP'ed, act confused
	if (bConfused)
	{
		confusionTimer += deltaTime;

		// pick a random facing at random
		if (confusionTimer % 0.25 > 0.2)
		{
			DesiredRotation.Pitch = origRot.Pitch + 0.5*swingAngle - Rand(swingAngle);
			DesiredRotation.Yaw = origRot.Yaw + 0.5*swingAngle - Rand(swingAngle);
		}

		if (confusionTimer > confusionDuration)
		{
			bConfused = False;
			confusionTimer = 0;
			confusionDuration = Default.confusionDuration;
			LightHue = 80;
			MultiSkins[2] = Texture'GreenLightTex';
			SoundPitch = 64;
			DesiredRotation = origRot;
		}

		return;
	}

	// check the player's visibility every 0.1 seconds
	if (!bNoAlarm)
	{
		playerCheckTimer += deltaTime;

		if (playerCheckTimer > 0.1)
		{
			playerCheckTimer = 0;
         if (Level.NetMode == NM_Standalone)
            CheckPlayerVisibility(DeusExPlayer(GetPlayerPawn()));
         else
         {
            curPlayer = DeusExPlayer(AcquireMultiplayerTarget());
            if (curPlayer != None)
               CheckPlayerVisibility(curPlayer);
         }
		}
	}

	// forget about the player after a set amount of time
	if (bPlayerSeen)
	{
		// if the player has been seen, but the camera hasn't triggered yet,
		// provide some feedback to the player (light and sound)
		if (!bEventTriggered)
		{
			triggerTimer += deltaTime;

			if (triggerTimer % 0.5 > 0.4)
			{
				LightHue = 0;
				MultiSkins[2] = Texture'RedLightTex';
				PlaySound(Sound'Beep6',,,, BeepSoundRadius);
			}
			else
			{
				LightHue = 80;
				MultiSkins[2] = Texture'GreenLightTex';
			}
		}

		if (lastSeenTimer < memoryTime)
			lastSeenTimer += deltaTime;
		else
		{
			lastSeenTimer = 0;
			bPlayerSeen = False;

			// untrigger the event
			TriggerEvent(False);
		}

		return;
	}

	swingTimer += deltaTime;
	MultiSkins[2] = Texture'GreenLightTex';

	// swing back and forth if all is well
	if (bSwing && !bTrackPlayer)
	{
		ang = 2 * Pi * swingTimer / swingPeriod;
		rot = origRot;
		rot.Yaw += Sin(ang) * swingAngle;
		DesiredRotation = rot;
	}

   // DEUS_EX AMSD For multiplayer
   ReplicatedRotation = DesiredRotation;
}


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
          hackPlayer.ClientMessage("Hacking with Voltear");
      }
      while (TicksSinceLastHack > TicksPerHack)
      {
         numHacks--;
         if(curTool.IsA('Voltear'))
            Voltear(curTool).giveOwnerEnergy(self);
         else
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
     AlarmSoundRadius=64.000000
     BeepSoundRadius=10000.000000
     TriggerSpeed=1.000000
     AlertRadius=2000.000000
     memoryTime=12.000000
     triggerDelay=10.000000
}
