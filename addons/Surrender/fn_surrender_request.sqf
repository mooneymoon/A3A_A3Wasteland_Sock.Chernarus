//@file Version: 0.9
//@file Name: surrender.sqf
//@file Author: BadVolt
//@file Created: 20/12/2014
//@file Description: Suggest player to surrender

//Surrender suggest longs for...
#define WAITFOR 15
#define DURATION 60

_timeout=serverTime+DURATION;
_target = cursorTarget;

_target setVariable ["sur_gotSuggestion",true,true];
_target setVariable ["sur_suggestorObj",player,true];
_target setVariable ["sur_suggestorTimeout",serverTime+WAITFOR,true];

player groupChat format["You have suggested %1 to surrender. He has %2 seconds to decide.", name _target,WAITFOR];

//Disabled
/******************************************
[_timeout,_target] spawn {
	_timeout=_this select 0;
	_target =_this select 1;
	waitUntil {sleep 0.5; serverTime>_timeout};
		
	_target setVariable ["sur_isSurrendering",false,true];
	_target setVariable ["sur_gotSuggestion",false,true];
	_target setVariable ["sur_suggestorObj",nil,true];
	_target setVariable ["sur_suggestorTimeout",0,true];
};
******************************************/