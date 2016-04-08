// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2015 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_voiceChatControl.sqf
//	@file Author: AgentRev

#define SWITCH_DIRECT if (currentChannel == 0) then { setCurrentChannel 5 }
#define SWITCH_ADMIN_DIRECT if (currentChannel == 0 && !((getPlayerUID player) call isAdmin)) then { setCurrentChannel 5 }
#define SWITCH_SIDE_DIRECT if (currentChannel == 1 && !(playerSide in [BLUFOR,OPFOR])) then { setCurrentChannel 5 }
#define SWITCH_ALLSIDE_DIRECT if (currentChannel == 1) then { setCurrentChannel 5 }

private "_waitSpeak";
_waitSpeak = _this select 0;

switch (["A3W_disableGlobalVoice", 1] call getPublicVar) do
{
	case 1:
	{
		if (_waitSpeak) then
		{
			["A3W_voiceChatControl_global", "onEachFrame",
			{
				if (!isNull findDisplay 55) then
				{
					SWITCH_DIRECT;
					["A3W_voiceChatControl_global", "onEachFrame"] call BIS_fnc_removeStackedEventHandler;
				};
			}] call BIS_fnc_addStackedEventHandler;
		}
		else
		{
			if (!isNull findDisplay 55) then
			{
				SWITCH_DIRECT;
			};
		};
	};
	case 2:
	{
		if (_waitSpeak) then
		{
			["A3W_voiceChatControl_global", "onEachFrame",
			{
				if (!isNull findDisplay 55) then
				{
					SWITCH_ADMIN_DIRECT;
					["A3W_voiceChatControl_global", "onEachFrame"] call BIS_fnc_removeStackedEventHandler;
				};
			}] call BIS_fnc_addStackedEventHandler;
		}
		else
		{
			if (!isNull findDisplay 55) then
			{
				SWITCH_ADMIN_DIRECT;
			};
		};
	};
};

switch (["A3W_disableSideVoice", 1] call getPublicVar) do
{
	case 1:
	{
		if (_waitSpeak) then
		{
			["A3W_voiceChatControl_side", "onEachFrame",
			{
				if (!isNull findDisplay 55) then
				{
					SWITCH_SIDE_DIRECT;
					["A3W_voiceChatControl_side", "onEachFrame"] call BIS_fnc_removeStackedEventHandler;
				};
			}] call BIS_fnc_addStackedEventHandler;
		}
		else
		{
			if (!isNull findDisplay 55) then
			{
				SWITCH_SIDE_DIRECT;
			};
		};
	};
	case 2:
	{
		if (_waitSpeak) then
		{
			["A3W_voiceChatControl_side", "onEachFrame",
			{
				if (!isNull findDisplay 55) then
				{
					SWITCH_ALLSIDE_DIRECT;
					["A3W_voiceChatControl_side", "onEachFrame"] call BIS_fnc_removeStackedEventHandler;
				};
			}] call BIS_fnc_addStackedEventHandler;
		}
		else
		{
			if (!isNull findDisplay 55) then
			{
				SWITCH_ALLSIDE_DIRECT;
			};
		};
	};
};
