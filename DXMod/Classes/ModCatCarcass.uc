//-----------------------------------------------------------
//
//-----------------------------------------------------------
class ModCatCarcass extends ModAnimalCarcass;

// ----------------------------------------------------------------------
// Frob()
//
// search the body for inventory items and give them to the frobber
// ----------------------------------------------------------------------
/*
function Frob(Actor Frobber, Inventory frobWith)
{
    local Meat catMeat;
    super.Frob(Frobber, frobWith);
    catMeat = Spawn(class'Meat');
	if (Level.Game.LocalLog != None)
		Level.Game.LocalLog.LogPickup(catMeat, Pawn(Frobber));
	if (Level.Game.WorldLog != None)
		Level.Game.WorldLog.LogPickup(catMeat, Pawn(Frobber));
//			if (bActivatable && Pawn(Other).SelectedItem==None)
//				Pawn(Other).SelectedItem=Copy;

    Pawn(Frobber).ClientMessage("You found some animal meat");
    catMeat.GiveTo(Pawn(Frobber));
}  */

defaultproperties
{
     meatclass=Class'DXMod.Meat'
     Mesh2=LodMesh'DeusExCharacters.CatCarcass'
     Mesh3=LodMesh'DeusExCharacters.CatCarcass'
     bAnimalCarcass=True
     Mesh=LodMesh'DeusExCharacters.CatCarcass'
     CollisionRadius=17.000000
     CollisionHeight=3.600000
}
