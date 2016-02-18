// disableThermal.sqf
// by CRE4MPIE
// ver 0.3
// 2015-04-29 11:44pm
// contributions from BIStudio Forums, edited by CRE4MPIE, optimized by AgentRev

#define LAYER 85125

while {true} do
{
    waitUntil {sleep 0.1; currentVisionMode player == 2}; // check for TI Mode

    if (alive getConnectedUAV player && {getConnectedUAV player isKindOf "UAV_01_base_F"}) then
    {
        LAYER cutText ["Thermal Imaging OFFLINE", "BLACK", -1];
        playSound "FD_CP_Not_Clear_F";
        waitUntil {sleep 0.1; currentVisionMode player != 2};
        LAYER cutText ["", "PLAIN"];
    };
};