//-----------------------------------------------------------
//
//-----------------------------------------------------------
class ModDoberman expands Doberman;

// ----------------------------------------------------------------------
// SpawnCarcass()
// ----------------------------------------------------------------------

function Carcass SpawnCarcass()
{
	local DeusExCarcass carc;
	local vector loc;
	local Inventory item, nextItem;
	local FleshFragment chunk;
	local int i;
	local float size;

	// if we really got blown up good, gib us and don't display a carcass
	if ((Health < -100) && !IsA('Robot'))
	{
		size = (CollisionRadius + CollisionHeight) / 2;
		if (size > 10.0)
		{
			for (i=0; i<size/4.0; i++)
			{
				loc.X = (1-2*FRand()) * CollisionRadius;
				loc.Y = (1-2*FRand()) * CollisionRadius;
				loc.Z = (1-2*FRand()) * CollisionHeight;
				loc += Location;
				chunk = spawn(class'FleshFragment', None,, loc);
				if (chunk != None)
				{
					chunk.DrawScale = size / 25;
					chunk.SetCollisionSize(chunk.CollisionRadius / chunk.DrawScale, chunk.CollisionHeight / chunk.DrawScale);
					chunk.bFixedRotationDir = True;
					chunk.RotationRate = RotRand(False);
				}
			}
		}

		return None;
	}

	// spawn the carcass
	carc = DeusExCarcass(Spawn(CarcassType));

	if ( carc != None )
	{
		if (bStunned)
			carc.bNotDead = True;

		carc.Initfor(self);

		// move it down to the floor
		loc = Location;
		loc.z -= Default.CollisionHeight;
		loc.z += carc.Default.CollisionHeight;
		carc.SetLocation(loc);
		carc.Velocity = Velocity;
		carc.Acceleration = Acceleration;

		// give the carcass the pawn's inventory if we aren't an animal or robot
	//	if (!IsA('Animal') && !IsA('Robot'))
		//{
			if (Inventory != None)
			{
				do
				{
					item = Inventory;
					nextItem = item.Inventory;
					DeleteInventory(item);
					if ((DeusExWeapon(item) != None) && (DeusExWeapon(item).bNativeAttack))
						item.Destroy();
					else
						carc.AddInventory(item);
					item = nextItem;
				}
				until (item == None);
			}
	//	}
	}

	return carc;
}

function PlayAttack()
{
	PlayAnimPivot('Attack',2.0);
}

defaultproperties
{
     CarcassType=Class'DXMod.ModDobermanCarcass'
     InitialInventory(0)=(Inventory=Class'DXMod.ModDogBite')
     InitialInventory(1)=(Inventory=Class'DXMod.DogMeat')
     InitialInventory(2)=(Inventory=Class'DXMod.DogBlood')
     GroundSpeed=300.000000
}
