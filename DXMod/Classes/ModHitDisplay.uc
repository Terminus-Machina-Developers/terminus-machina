//-----------------------------------------------------------
//
//-----------------------------------------------------------
class ModHitDisplay expands HUDHitDisplay;

// Energy bar
var ProgressBarWindow winCalories;
var float	caloriesPercent;
var localized string CaloriesText;

event InitWindow()
{

	Super.InitWindow();

	winCalories = CreateProgressBar(61, 20);
}

event DrawWindow(GC gc)
{
	Super.DrawWindow(gc);

	// Draw calories bar
	gc.SetFont(Font'FontTiny');
	gc.SetTextColor(winCalories.GetBarColor());
	gc.DrawText(61, 74, 8, 8, CaloriesText);
	//gc.DrawText(61, 74, 8, 8, O2Text);
}

// ----------------------------------------------------------------------
// Tick()
//
// Update the Energy and Breath displays
// ----------------------------------------------------------------------

event Tick(float deltaSeconds)
{
   // DEUS_EX AMSD Server doesn't need to do this.
   if ((player.Level.NetMode != NM_Standalone)  && (!Player.PlayerIsClient()))
   {
      Hide();
      return;
   }
	if ((player != None) && ( bVisible ))
	{
		SetHitColor(head,     deltaSeconds, false, player.HealthHead);
		SetHitColor(torso,    deltaSeconds, false, player.HealthTorso);
		SetHitColor(armLeft,  deltaSeconds, false, player.HealthArmLeft);
		SetHitColor(armRight, deltaSeconds, false, player.HealthArmRight);
		SetHitColor(legLeft,  deltaSeconds, false, player.HealthLegLeft);
		SetHitColor(legRight, deltaSeconds, false, player.HealthLegRight);

		// Calculate the energy bar percentage
		energyPercent = 100.0 * (player.Energy / player.EnergyMax);
		winEnergy.SetCurrentValue(energyPercent);

		// Calculate the calorie bar percentage
		caloriesPercent = ModMale(player).Calories; //100.0 * (ModMale(player).Calories / 100);
		winCalories.SetCurrentValue(caloriesPercent);

		// If we're underwater, draw the breath bar
		if (bUnderwater)
		{
			// if we are already underwater
			if (player.HeadRegion.Zone.bWaterZone)
			{
				// if we are still underwater
				breathPercent = 100.0 * player.swimTimer / player.swimDuration;
				breathPercent = FClamp(breathPercent, 0.0, 100.0);
			}
			else
			{
				// if we are getting out of the water
				bUnderwater = False;
				breathPercent = 100;
			}
		}
		else if (player.HeadRegion.Zone.bWaterZone)
		{
			// if we just went underwater
			bUnderwater = True;
			breathPercent = 100;
		}

		// Now show or hide the breath meter
		if (bUnderwater)
		{
			if (!winBreath.IsVisible())
				winBreath.Show();

			winBreath.SetCurrentValue(breathPercent);
		}
		else
		{
			if (winBreath.IsVisible())
				winBreath.Hide();
		}

		Show();
	}
	else
		Hide();
}

defaultproperties
{
     CaloriesText="Cal"
}
