//-----------------------------------------------------------
//
//-----------------------------------------------------------
class ModFire expands Fire;
var() bool bSmoke;
var ProjectileGenerator projgen;
var Projectile proj;

simulated function Tick(float deltaTime)
{
	//Super.Tick(deltaTime);
   /*
   if ((Base != PrevBase) && (Base != None))
      SetOffset();

   if ((Role == ROLE_SimulatedProxy) && (Base != None))
      CorrectLocation();

	// if our owner or base is destroyed, destroy us
	if (Owner == None)
		Destroy();*/
}

simulated function PostBeginPlay()
{
	//Super.PostBeginPlay();
   /*
	SetBase(Owner);
	origBase = Owner;

   PrevBase = Base;
   if (Base != None)
      SetOffset();
  */
   if (Role == ROLE_Authority && bSmoke)
      SpawnSmokeEffects();
}

simulated function PostNetBeginPlay()
{
   //Super.PostNetBeginPlay();
    /*
   SetBase(Owner);
   origBase = Owner;

   PrevBase = Base;
   if (Base != None)
      SetOffset();
          */
   if (Role < ROLE_Authority && bSmoke)
      SpawnSmokeEffects();
}

function SpawnSmokeEffects()
{
    local vector loc;
    loc = location;
    loc.Z = loc.Z + 40;
    proj = Spawn(class'PoisonGas', Self,, loc, rot(16384,0,0));
	if (proj != None)
	{
		//bLeaking = True;
	//	projgen.ProjectileClass = class'PoisonGas';
		proj.Texture = Texture'Effects.Smoke.Gas_Tear';//  SmokePuff1';
		proj.Damage=0.000000;
		proj.LifeSpan = 60000000.0;
		proj.Speed = 0;
		proj.MaxSpeed = 0;
		proj.ScaleGlow = 0.2;
		proj.bUnlit = false;
//		projgen.frequency = 0.9;
//		projgen.checkTime = 0.5;
//		projgen.ejectSpeed = 50.0;
//		projgen.bRandomEject = True;
		proj.SetBase(Self);
	}
	/*
	projgen = Spawn(class'ProjectileGenerator', Self,, loc, rot(16384,0,0));
	if (projgen != None)
	{
		//bLeaking = True;
		projgen.ProjectileClass = class'PoisonGas';
		projgen.particleTexture = Texture'Effects.Smoke.SmokePuff1';
		projgen.ProjectileLifeSpan = 3.0;
		projgen.frequency = 0.9;
		projgen.checkTime = 0.5;
		projgen.ejectSpeed = 50.0;
		projgen.bRandomEject = True;
		projgen.SetBase(Self);
	}    */
}

defaultproperties
{
}
