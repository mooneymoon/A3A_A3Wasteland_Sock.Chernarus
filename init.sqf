// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.2
//	@file Name: init.sqf
//	@file Author: [404] Deadbeat, [GoT] JoSchaap, AgentRev
//	@file Description: The main init.

#include "debugFlag.hpp"

#ifdef A3W_DEBUG
#define DEBUG true
#else
#define DEBUG false
#endif

enableSaving [false, false];

// block script injection exploit
inGameUISetEventHandler ["PrevAction", ""];
inGameUISetEventHandler ["Action", ""];
inGameUISetEventHandler ["NextAction", ""];

_descExtPath = str missionConfigFile;
currMissionDir = compileFinal str (_descExtPath select [0, count _descExtPath - 15]);

X_Server = false;
X_Client = false;
X_JIP = false;

//enable weather script
[] execVM "addons\scripts\D41_wetter.sqf";

//disable TAW grass Option 'None'
tawvd_disablenone = true;

// versionName = ""; // Set in STR_WL_WelcomeToWasteland in stringtable.xml

if (isServer) then { X_Server = true };
if (!isDedicated) then { X_Client = true };
if (isNull player) then { X_JIP = true };

A3W_scriptThreads = [];

[DEBUG] call compile preprocessFileLineNumbers "globalCompile.sqf";
//[] spawn compile preprocessFileLineNumbers "addons\spawn\functions.sqf";

//init Wasteland Core
[] execVM "config.sqf";
[] execVM "storeConfig.sqf"; // Separated as its now v large
[] execVM "briefing.sqf";

if (!isDedicated) then
{
	[] spawn
	{
		if (hasInterface) then // Normal player
		{
			9999 cutText ["Welcome to A3Wasteland, please wait for your client to initialize", "BLACK", 0.01];

			waitUntil {!isNull player};
			player setVariable ["playerSpawning", true, true];
			playerSpawning = true;

			removeAllWeapons player;
			client_initEH = player addEventHandler ["Respawn", { removeAllWeapons (_this select 0) }];

			// Reset group & side
			[player] joinSilent createGroup playerSide;

			execVM "client\init.sqf";

			if ((vehicleVarName player) select [0,17] == "BIS_fnc_objectVar") then { player setVehicleVarName "" }; // undo useless crap added by BIS
		}
		else // Headless
		{
			waitUntil {!isNull player};
			if (typeOf player == "HeadlessClient_F") then
			{
				execVM "client\headless\init.sqf";
			};
		};

		player setVehicleVarName ""; // undo BIS_fnc_objectVar crap
	};
};

if (isServer) then
{
	diag_log format ["############################# %1 #############################", missionName];
	diag_log "WASTELAND SERVER - Initializing Server";
	[] execVM "server\init.sqf";
};

//init 3rd Party Scripts (not supposed to run on HC)
if (hasInterface || isServer) then
{
  [] execVM "addons\vactions\functions.sqf";
  [] execVM "addons\parking\functions.sqf";
  [] execVM "addons\storage\functions.sqf";
  [] execVM "addons\R3F_ARTY_AND_LOG\init.sqf";
  [] execVM "addons\JumpMF\init.sqf";
  [] execVM "addons\outlw_magRepack\MagRepack_init.sqf";
  [] execVM "addons\Explosives-To-Vehicle\init.sqf";
  [] execVM "addons\JTS_PM\Functions.sqf";
  [] execVM "addons\scripts\servercredits.sqf";
  [] execVM "addons\scripts\resupply_actions.sqf";
  [] execVM "addons\lsd_nvg\init.sqf";
  [] execVM "addons\vsave\vsfunctions.sqf";
};
