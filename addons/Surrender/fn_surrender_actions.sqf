//@file Version: 0.9
//@file Name: surrender.sqf
//@file Author: BadVolt
//@file Created: 20/12/2014
//@file Description: add extort action event

_target = cursorTarget;
_action = _this select 3 select 1;

switch (_action) do {
	case ("extort"): {player action ["Gear", _target]};
	case ("money"): {player groupChat format ["%1 has %2$ in pockets.", name _target, _target getVariable ["cmoney",0]]};
	case ("release"): {
		_target setVariable ["sur_isSurrendering",false,true];
		_target setVariable ["sur_gotSuggestion",false,true];
		_target setVariable ["sur_suggestorObj",nil,true];
		_target setVariable ["sur_suggestorTimeout",0,true];	
		[_target, ""] call switchMoveGlobal;
	};
};