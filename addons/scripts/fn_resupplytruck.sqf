//  @file Version: 1.1
//  @file Name: fn_resupplyTruck.sqf
//  @file Author: Wiking, AgentRev, micovery
//  @file Created: 13/07/2014 21:58

#define RESUPPLY_TRUCK_DISTANCE 20
#define REARM_TIME_SLICE 10
#define REPAIR_TIME_SLICE 1
#define REFUEL_TIME_SLICE 1
#define PRICE_RELATIONSHIP 4

private["_vehicle"];

// Check if mutex lock is active.
if (mutexScriptInProgress) exitWith {
  titleText ["You are already performing another action.", "PLAIN DOWN", 0.5];
};

mutexScriptInProgress = true;
doCancelAction = false;

if (!isNil "_this" && {typeName _this == typeName objNull}) then {
  _vehicle = _this;
}
else {
  _vehicle = vehicle player;
};



private["_checkExit"];
_checkExit = {
  if (doCancelAction) exitWith {
    doCancelAction = false;
    mutexScriptInProgress = false;
    titleText ["Vehicle resupply cancelled", "PLAIN DOWN", 0.5];
    true;
  };
  false
};

if (isNil "_vehicle") exitWith {};

private["_is_uav", "_is_static"];
_is_uav = (_vehicle isKindOf "UAV_01_base_F" || {_vehicle isKindOf "UAV_02_base_F" || {_vehicle isKindOf "UGV_01_base_F"}});
_is_static = (_vehicle isKindOf "StaticWeapon");

//check if caller is in vehicle
if (_vehicle == player) exitWith {};

private["_vehClass", "_price"];
//set up prices
_vehClass = typeOf _vehicle;
_price = 1000; // price = 1000 for vehicles not found in vehicle store. (e.g. Static Weapons)

{
  if (_vehClass == _x select 1) then {
    _price = _x select 2;
    _price = round (_price / PRICE_RELATIONSHIP);
  };
} forEach (call allVehStoreVehicles + call staticGunsArray);

private["_service_cancelled"];
_service_cancelled = false;

if (_is_static) then {
  _text = format ["Resupply sequence initiated for this static weapon. Make sure to get out of the weapon."];
  titleText [_text, "PLAIN DOWN", 0.5];
  sleep 10;
}
else {
  _text = format ["Resupply sequence initiated for this vehicle. Make sure the engine is stopped.", _price];
  titleText [_text, "PLAIN DOWN", 0.5];

  private["_eng"];
  sleep 10;
  _eng = isEngineOn _vehicle;
  if (_eng) exitWith {
    titleText ["Engine still running. Service cancelled.", "PLAIN DOWN", 0.5];
    mutexScriptInProgress = false;
    _service_cancelled = true;
  };
};

if (_service_cancelled || {call _checkExit}) exitWith {};

if ((!isNull (gunner _vehicle)) && !(_is_uav)) then {
  _vehicle vehicleChat format ["Gunner must be out of seat for service. Get gunner out in 20s."];
  sleep 10;
  if (call _checkExit) exitWith {_service_cancelled = true;};
  _vehicle vehicleChat format ["Gunner must be out of seat for service. Get gunner out in 10s."];
  sleep 10;
  if (call _checkExit) exitWith {_service_cancelled = true;};
  if (!isNull (gunner _vehicle)) exitWith {
    _vehicle vehicleChat format ["Gunner still inside. Service cancelled."];
    mutexScriptInProgress = false;
    _service_cancelled = true;
  };
};

if (_service_cancelled || {call _checkExit}) exitWith {};

_resupplyThread = [_vehicle, _is_uav, _is_static] spawn {
   private["_vehicle", "_vehClass", "_vehicleCfg","_is_uav"];
  _vehicle = _this select 0;
  _is_uav = _this select 1;
  _is_static = _this select 2;
  _vehClass = typeOf _vehicle;
  _vehicleCfg = configFile >> "CfgVehicles" >> _vehClass;
  _vehName = getText (_vehicleCfg >> "displayName");


  scopeName "fn_resupplyTruck";

  private["_price"];
  _price = 1000; // price = 1000 for vehicles not found in vehicle store (e.g. static weapons)
  {
    if (_vehClass == _x select 1) then {
      _price = _x select 2;
      _price = round (_price / PRICE_RELATIONSHIP);
    };
  } forEach (call allVehStoreVehicles + call staticGunsArray);

  private["_titleText"];
  _titleText = {
      titleText [_this, "PLAIN DOWN", ((REARM_TIME_SLICE max 1) / 10) max 1];
  };

  private["_checkAbortConditions"];
  _checkAbortConditions = {
    if (doCancelAction) then {
      doCancelAction = false;
      mutexScriptInProgress = false;
      titleText ["Vehicle resupply cancelled", "PLAIN DOWN", 0.5];
      breakOut "fn_resupplyTruck";
    };

    // Abort everything if vehicle is no longer local, otherwise commands won't do anything
    if (!local _vehicle && {!(_is_uav || _is_static)}) then {
      _crew = crew _vehicle;
      _text = format ["Vehicle resupply aborted by %1", if (count _crew > 0) then { name (_crew select 0) } else { "another player" }];
      titleText [_text, "PLAIN DOWN", 0.5];
      mutexScriptInProgress = false;
      breakOut "fn_resupplyTruck";
    };

    // Abort everything if no Tempest Device in proximity
    if ({alive _x} count (_vehicle nearEntities [["O_Heli_Transport_04_ammo_F", "I_Truck_02_ammo_F", "O_Truck_03_ammo_F", "B_Truck_01_ammo_F"], RESUPPLY_TRUCK_DISTANCE]) == 0) then {
      if (_started) then { titleText ["Vehicle resupply aborted.", "PLAIN DOWN", 0.5] };
      mutexScriptInProgress = false;
      breakOut "fn_resupplyTruck";
    };
    // Abort everything if player gets out of vehicle
    if (vehicle player != _vehicle && {!(_is_uav || _is_static)}) then {
      if (_started) then { titleText ["Vehicle resupply aborted.", "PLAIN DOWN", 0.5] };
      mutexScriptInProgress = false;
      breakOut "fn_resupplyTruck";
    };

    // Abort if player gets in the gunner seat

    if (_is_static && {!isNull (gunner _vehicle)}) then {
      if (_started) then { titleText ["Vehicle resupply aborted. Someone is using the weapon.", "PLAIN DOWN", 0.5] };
      mutexScriptInProgress = false;
      breakOut "fn_resupplyTruck";
    };

  };

  private["_started"];
  _started = false;
  call _checkAbortConditions;
  _started = true;

  private["_playerMoney"];
  //Add cost for resupply
  _playerMoney = player getVariable "cmoney";

  private["_text"];
  if (_playerMoney < _price) then {
    _text = format ["Not enough money. You need $%1 to resupply %2. Service cancelled.",_price,_vehName];
    [_text, 10] call mf_notify_client;
    mutexScriptInProgress = false;
    breakOut "fn_resupplyTruck";
  }
  else  {
    private["_msg"];
    _msg = format["It will cost you $%1 to resupply the %2. Do you want to proceed?", _price, getText ((configFile >> "CfgVehicles" >> (typeOf _vehicle)) >> "displayName")];
    if (not([_msg, "Vehicle Resupply", true,true] call BIS_fnc_guiMessage)) then {
      mutexScriptInProgress = false;
      breakOut "fn_resupplyTruck";
    };

    //start resupply here
    player setVariable["cmoney",(player getVariable "cmoney")-_price,true];
    _text = format ["You paid $%1 to resupply %2.\nPlease stand by ...",_price,_vehName];
    [_text, 10] call mf_notify_client;
    [] call fn_savePlayerData;
  };

	if (not(_is_uav) && {!isNull (gunner(_vehicle))}) then {
	  gunner(_vehicle) action ["getOut", _vehicle];
	};

  private["_turretCfg", "_turretsArray"];
  _turretsArray = [[_vehicleCfg, [-1]]];
  _turretsCfg = configFile >> "CfgVehicles" >> _vehClass >> "Turrets";

  if (isClass _turretsCfg) then {
    _nbTurrets = count _turretsCfg;
    _turretPath = 0;
    for "_i" from 0 to (_nbTurrets - 1) do {
      _turretCfg = _turretsCfg select _i;
      if (isClass _turretCfg && {getNumber (_turretCfg >> "hasGunner") > 0}) then {
        _turretsArray set [count _turretsArray, [_turretCfg, [_turretPath]]];
        _subTurretsCfg = _turretCfg >> "Turrets";
        if (isClass _subTurretsCfg) then {
          _nbSubTurrets = count _subTurretsCfg;
          _subTurretPath = 0;
          for "_j" from 0 to (_nbSubTurrets - 1) do {
            _subTurretCfg = _subTurretsCfg select _j;
            if (isClass _subTurretCfg && {getNumber (_subTurretCfg >> "hasGunner") > 0}) then {
              _turretsArray set [count _turretsArray, [_subTurretCfg, [_turretPath, _subTurretPath]]];
              _subTurretPath = _subTurretPath + 1;
            };
          };
        };
        _turretPath = _turretPath + 1;
      };
    };
  };

  sleep (REARM_TIME_SLICE / 2);
  call _checkAbortConditions;

  _engineOn = false;

  if !(_vehicle isKindOf "Air") then {
    _engineOn = isEngineOn _vehicle;
    player action ["EngineOff", _vehicle];
  };

  _vehicle setFuel 0;

  {
    private["_turretCfg", "_turretPath", "_turretMags", "_turretMagPairs"];
    _turretCfg = _x select 0;
    _turretPath = _x select 1;
    _turretMags = getArray (_turretCfg >> "magazines");
    _turretMagPairs = [];

    { [_turretMagPairs, _x, 1] call BIS_fnc_addToPairs } forEach _turretMags;

    {
      private["_mag", "_ammo"];
      _mag = _x select 0;
      _ammo = _x select 1;

      if (_ammo >= getNumber (configFile >> "CfgMagazines" >> _mag >> "count")) then {
        {
          if (_x select 0 == _mag) exitWith {
            _count = if (count _x > 2) then { _x select 2 } else { 0 };
            _x set [2, _count + 1];
          };
        } forEach _turretMagPairs;
      };
    } forEach magazinesAmmo _vehicle;

    {
      private["_mag", "_qty", "_fullQty"];
      _mag = _x select 0;
      _qty = _x select 1;
      _fullQty = if (count _x > 2) then { _x select 2 } else { 0 };

      if (_fullQty < _qty) then {
        //_vehicle removeMagazinesTurret [_mag, _turretPath];
        [[_vehicle, [_mag, _turretPath]], "A3W_fnc_removeMagazinesTurret", _vehicle, false] call BIS_fnc_MP;

        for "_i" from 1 to _qty do {
          private["_magName"];
          _magName = getText (configFile >> "CfgMagazines" >> _mag >> "displayName");

          if (_magName == "") then {
            {
              _weaponCfg = configFile >> "CfgWeapons" >> _x;
              if ({_mag == _x} count getArray (_weaponCfg >> "magazines") > 0) exitWith {
                _magName = getText (_weaponCfg >> "displayName");
              };
            } forEach getArray (_turretCfg >> "weapons");
          };
          
          if ({_vehicle isKindOf _x} count ["B_Mortar_01_F", "O_Mortar_01_F", "I_Mortar_01_F"] > 0) then {
            private["_text"];
            _text = format ["Reloading %1...", if (_magName != "") then { _magName } else { _vehName }];
            _text call _titleText;

            sleep (REARM_TIME_SLICE / 2);
            call _checkAbortConditions;

            [[_vehicle, [_mag, _turretPath]], "A3W_fnc_addMagazineTurretMortar", _vehicle, false] call BIS_fnc_MP;
            
            sleep (REARM_TIME_SLICE / 2);
            call _checkAbortConditions;
          };
          
          if (_vehicle isKindOf "B_Plane_CAS_01_F") then {
            private["_text"];
            _text = format ["Reloading %1...", _vehName];
            _text call _titleText;

            sleep (REARM_TIME_SLICE / 2);
            call _checkAbortConditions;

            [[_vehicle, [_mag, _turretPath]], "A3W_fnc_addMagazineTurretBcas", _vehicle, false] call BIS_fnc_MP;

            sleep (REARM_TIME_SLICE / 2);
            call _checkAbortConditions;
          };

          if (_vehicle isKindOf "O_Plane_CAS_02_F") then {
            private["_text"];
            _text = format ["Reloading %1...", _vehName];
            _text call _titleText;

            sleep (REARM_TIME_SLICE / 2);
            call _checkAbortConditions;

            [[_vehicle, [_mag, _turretPath]], "A3W_fnc_addMagazineTurretOcas", _vehicle, false] call BIS_fnc_MP;

            sleep (REARM_TIME_SLICE / 2);
            call _checkAbortConditions;
          };

          if (_vehicle isKindOf "I_Plane_Fighter_03_CAS_F") then {
            private["_text"];
            _text = format ["Reloading %1...", _vehName];
            _text call _titleText;

            sleep (REARM_TIME_SLICE / 2);
            call _checkAbortConditions;

            [[_vehicle, [_mag, _turretPath]], "A3W_fnc_addMagazineTurretIcas", _vehicle, false] call BIS_fnc_MP;

            sleep (REARM_TIME_SLICE / 2);
            call _checkAbortConditions;
          };		  

          if (_vehicle isKindOf "O_Heli_Light_02_F") then {
            private["_text"];
            _text = format ["Reloading %1...", _vehName];
            _text call _titleText;

            sleep (REARM_TIME_SLICE / 2);
            call _checkAbortConditions;

            [[_vehicle, [_mag, _turretPath]], "A3W_fnc_addMagazineTurretHorca", _vehicle, false] call BIS_fnc_MP;

            sleep (REARM_TIME_SLICE / 2);
            call _checkAbortConditions;
          };
		  
          if (_vehicle isKindOf "B_Heli_Attack_01_F") then {
            private["_text"];
            _text = format ["Reloading %1...", if (_magName != "") then { _magName } else { _vehName }];
            _text call _titleText;

            sleep (REARM_TIME_SLICE / 2);
            call _checkAbortConditions;

            [[_vehicle, [_mag, _turretPath]], "A3W_fnc_addMagazineTurretBaheli", _vehicle, false] call BIS_fnc_MP;

            sleep (REARM_TIME_SLICE / 2);
            call _checkAbortConditions;
          };

          if ({_vehicle isKindOf _x} count ["O_Heli_Attack_02_F", "O_Heli_Attack_02_black_F"] > 0) then {
            private["_text"];
            _text = format ["Reloading %1...", if (_magName != "") then { _magName } else { _vehName }];
            _text call _titleText;

            sleep (REARM_TIME_SLICE / 2);
            call _checkAbortConditions;

            [[_vehicle, [_mag, _turretPath]], "A3W_fnc_addMagazineTurretOaheli", _vehicle, false] call BIS_fnc_MP;
            
            sleep (REARM_TIME_SLICE / 2);
            call _checkAbortConditions;
          };

          if ({_vehicle isKindOf _x} count ["B_UAV_02_F", "O_UAV_02_F", "I_UAV_02_F"] > 0) then {
            private["_text"];
            _text = format ["Reloading %1...", if (_magName != "") then { _magName } else { _vehName }];
            _text call _titleText;

            sleep (REARM_TIME_SLICE / 2);
            call _checkAbortConditions;

            [[_vehicle, [_mag, _turretPath]], "A3W_fnc_addMagazineTurretUav2", _vehicle, false] call BIS_fnc_MP;

            sleep (REARM_TIME_SLICE / 2);
            call _checkAbortConditions;
          };
		  
          if !({_vehicle isKindOf _x} count ["B_UAV_02_F", "O_UAV_02_F", "I_UAV_02_F", "B_Plane_CAS_01_F", "O_Plane_CAS_02_F", "B_Mortar_01_F", "O_Mortar_01_F", "I_Mortar_01_F", "O_Heli_Light_02_F", "I_Plane_Fighter_03_CAS_F", "O_Heli_Attack_02_F", "O_Heli_Attack_02_black_F", "B_Heli_Attack_01_F"] > 0) then {
            private["_text"];
            _text = format ["Reloading %1...", if (_magName != "") then { _magName } else { _vehName }];
            _text call _titleText;

            sleep (REARM_TIME_SLICE / 2);
            call _checkAbortConditions;

            [[_vehicle, [_mag, _turretPath]], "A3W_fnc_addMagazineTurret", _vehicle, false] call BIS_fnc_MP;

            sleep (REARM_TIME_SLICE / 2);
            call _checkAbortConditions;
          };
        };
      };
    } forEach _turretMagPairs;
  } forEach _turretsArray;

  if !({_vehicle isKindOf _x} count ["B_UAV_02_F", "O_UAV_02_F", "I_UAV_02_F", "B_Plane_CAS_01_F", "O_Plane_CAS_02_F", "B_Mortar_01_F", "O_Mortar_01_F", "I_Mortar_01_F", "O_Heli_Light_02_F", "I_Plane_Fighter_03_CAS_F", "O_Heli_Attack_02_F", "O_Heli_Attack_02_black_F", "B_Heli_Attack_01_F"] > 0) then {
    [[_vehicle,1],"A3W_fnc_setVehicleAmmoDef",_vehicle,false] call BIS_fnc_MP; // Full ammo reset just to be sure
  };
  
  if ({_vehicle isKindOf _x} count ["B_Heli_Light_01_F", "B_Heli_Light_01_armed_F", "C_Heli_Light_01_civil_F"] > 0) then {
    // Add flares to those poor helis
    [[_vehicle, [_mag, _turretPath]], "A3W_fnc_addMagazineTurretLheli", _vehicle, false] call BIS_fnc_MP;
  };  
  
  if (damage _vehicle > 0.001) then {
    call _checkAbortConditions;
    while {damage _vehicle > 0.001} do {
      "Repairing..." call _titleText;
      sleep 1;
      call _checkAbortConditions;
      _vehicle setDamage ((damage _vehicle) - 0.1);
    };
    sleep 3;
  };

  if (fuel _vehicle < 0.999) then {
    call _checkAbortConditions;

    while {fuel _vehicle < 0.999} do {
      "Refueling..." call _titleText;
       sleep REFUEL_TIME_SLICE;
       call _checkAbortConditions;
       _vehicle setFuel ((fuel _vehicle) + 0.1);
    };
    sleep 2;
  };

  if !(_vehicle isKindOf "Air") then {
    _vehicle removeEventHandler ["Engine", _vehicle getVariable ["truckResupplyEngineEH", -1]];
    _vehicle engineOn _engineOn;
  };

  titleText ["Your vehicle is ready.", "PLAIN DOWN", 0.5];
  mutexScriptInProgress = false;
};

if !(_vehicle isKindOf "Air") then {
  _vehicle setVariable ["truckResupplyThread", _resupplyThread];
  _vehicle setVariable ["truckResupplyEngineEH", _vehicle addEventHandler ["Engine",
  {
    private["_vehicle", "_started", "_resupplyThread"];
    _vehicle = _this select 0;
    _started = _this select 1;
    _resupplyThread = _vehicle getVariable "truckResupplyThread";
    if (!isNil "_resupplyThread" && {!scriptDone _resupplyThread}) then {
      player action ["EngineOff", _vehicle];
    };
  }]];
};
