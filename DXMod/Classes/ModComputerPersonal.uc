//-----------------------------------------------------------
//
//-----------------------------------------------------------
class ModComputerPersonal expands ComputerPersonal;

var(ModComputerPersonal) string CompNode;

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
        local ModComputerSecurity MCS;
        foreach GetPlayerPawn().AllActors(class'ModComputerSecurity', MCS)
        {
             break;
        }
        if(MCS == none)
            MCS = Spawn(class'ModComputerSecurity');

        return MCS.GetNodeNameString(CompNode);

}

// ----------------------------------------------------------------------
// GetNodeDesc()
// ----------------------------------------------------------------------

function String GetNodeDesc()
{
        local ModComputerSecurity MCS;
        foreach GetPlayerPawn().AllActors(class'ModComputerSecurity', MCS)
        {
             break;
        }
        if(MCS == none)
            MCS = Spawn(class'ModComputerSecurity');

        return MCS.GetNodeDescString(CompNode);
}

// ----------------------------------------------------------------------
// GetNodeAddress()
// ----------------------------------------------------------------------

function String GetNodeAddress()
{
        local ModComputerSecurity MCS;
        foreach GetPlayerPawn().AllActors(class'ModComputerSecurity', MCS)
        {
             break;
        }
        if(MCS == none)
            MCS = Spawn(class'ModComputerSecurity');

        return MCS.GetNodeAddressString(CompNode);
}

defaultproperties
{
}
