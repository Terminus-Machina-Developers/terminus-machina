//-----------------------------------------------------------
//
//-----------------------------------------------------------
class AugNohface extends ModAugmentation;

#exec texture IMPORT NAME=AugIconNohface FILE=Images\AugIconNohface.pcx GROUP=UserInterface MIPS=OFF
#exec texture IMPORT NAME=AugIconNohface_Small FILE=Images\AugIconNohface_Small.pcx GROUP=UserInterface MIPS=OFF

var float mpAugValue;
var float mpEnergyDrain;

state Active
{
Begin:
    ModMale(Player).ToggleNohface(true);
}

function Deactivate()
{
	Super.Deactivate();
	ModMale(Player).ToggleNohface(false);
}

function float GetEnergyRate()
{
    if (self.Player.IsInState('Conversation')) {
       return 0;
    }
	return energyRate * LevelValues[CurrentLevel];
}

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	// If this is a netgame, then override defaults
	if ( Level.NetMode != NM_StandAlone )
	{
		LevelValues[3] = mpAugValue;
		EnergyRate = mpEnergyDrain;
      AugmentationLocation = LOC_Torso;
	}
}

defaultproperties
{
     mpAugValue=0.500000
     mpEnergyDrain=30.000000
     bElectrohack=True
     EnergyRate=80.000000
     Icon=Texture'DXMod.UserInterface.AugIconNohface'
     smallIcon=Texture'DXMod.UserInterface.AugIconNohface_Small'
     AugmentationName="Nohface"
     Description="The wearer will not trigger security cameras while aug is active.  Mask can also be used for impersonation. |n|nSmart graphene arrayed with a gigapixel micro-LED mask transforms the face into a screen from which hi-res visages of other individuals can be projected, allowing the user to masquerade as another and evade facial biometric detection systems.  In the age of omnipresent CCTV and drone surveillance capable of facial recognition, the Nohface is the 21st century resistance movement war paint, standard issue Hex-Gen equipment. |n|nTECH ONE: Power drain is normal.|n|nTECH TWO: Power drain is reduced slightly.|n|nTECH THREE: Power drain is reduced moderately.|n|nTECH FOUR: Power drain is reduced significantly."
     MPInfo="When active, you are invisible to electronic devices such as cameras, turrets, and proximity mines.  Energy Drain: Very Low"
     LevelValues(0)=1.000000
     LevelValues(1)=0.830000
     LevelValues(2)=0.660000
     LevelValues(3)=0.500000
     AugmentationLocation=LOC_Subdermal
     MPConflictSlot=2
}
