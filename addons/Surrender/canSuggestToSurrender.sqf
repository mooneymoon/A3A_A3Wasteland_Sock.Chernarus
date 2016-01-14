//@file Version: 0.9
//@file Name: surrender.sqf
//@file Author: BadVolt
//@file Created: 20/12/2014
//@file Description: Checks if your current target can surrender

private ["_target"];

_target = _this select 0; //cursorTarget
_result=false;

switch (true) do {
	case (!isPlayer _target): {}; // Not a player
	case (!alive _target): {}; // Target is dead
	case (_target getVariable ["sur_isSurrendering",false]): {}; // Player is surrendering
	case ((side player == side _target) && ((side player in [BLUFOR,OPFOR]))): {}; // Is in the same team and it's not INDI
	case (side _target in [CIVILIAN]): {}; //Is not in CIV
	case (player distance _target > 350): {}; // It more then 350m
	case (_target getVariable ["sur_isSurrendering",false]): {}; // Target is surrendering
	case (_target getVariable ["sur_gotSuggestion",false]): {}; // Target is suggested to surrender already
	default {_result=true};
};
(_result);