//-----------------------------------------------------------
//
//-----------------------------------------------------------
class PhaceBookFace extends DataVaultImage;

//#exec texture IMPORT NAME=WilliamGibsonFace FILE=Textures\GibsonFace.pcx GROUP=Skins

var travel Texture imageTex[4];
var travel texture faceSkin;
var travel string faceName;
var travel name Alliance;
var travel bool bWanted;  //if true, this identity will be on the enemy's wanted list.

//
// Give this inventory item to a pawn.
//

function GiveTo( pawn Other )
{
    PickupMessage=ImageDescription $ "Face added to Datavault";
	Instigator = Other;
	if ( ModMale(Other) != None )
	{
		bHidden = True;
		ModMale(Other).AddPhace(Self);
	}
	//BecomeItem();
	//Other.AddInventory( Self );
	//GotoState('Idle2');
	//Destroy();
}

// ----------------------------------------------------------------------
// Frob()
// ----------------------------------------------------------------------
/*
auto state Pickup
{
	function Frob(Actor Other, Inventory frobWith)
	{
		if ( ModMale(Other) != None )
		{
			bHidden = True;
			ModMale(Other).AddPhace(Self);
		}
		//Super.Frob(Other, frobWith);
	}

}      */

defaultproperties
{
     Alliance='
     imageDescription="No Desc"
     colNoteTextNormal=(R=50,G=50)
     colNoteTextFocus=(R=0,G=0)
     colNoteBackground=(R=32,G=32)
}
