if (!isNil "shFunctions_loaded") exitWith {};
diag_log "shFunctions loading ...";

#include "macro.h"


sh_isSaveableVehicle = {
  ARGVX4(0,_obj,objNull,false);

  init(_result, false);
  {
    if (_obj isKindOf _x) exitWith {
      _result = true;
    };
  } forEach A3W_saveable_vehicles_list;

  (_result)
};

sh_strToSide = {
  def(_result);
  _result = switch (toUpper _this) do {
    case "WEST":  { BLUFOR };
    case "EAST":  { OPFOR };
    case "GUER":  { INDEPENDENT };
    case "CIV":   { CIVILIAN };
    case "LOGIC": { sideLogic };
    default       { sideUnknown };
  };
  (_result)
};


sh_restoreVariables = {
  ARGVX3(0,_obj,objNull);
  ARGVX3(1,_variables,[]);

  def(_name);
  def(_value);

  {
    _name = _x select 0;
    _value = _x select 1;

    if (!isNil "_value") then {
      switch (_name) do {
        case "side": { _value = _value call sh_strToSide};
        case "R3F_Side": { _value = _value call sh_strToSide };
        case "ownerName": {
          switch (typeName _value) do {
            case "ARRAY": { _value = toString _value };
            case "STRING": { /* do nothing, it's already a string */ };
            default { _value = "[Unknown]" };
          };
        };
      };
    };

    _obj setVariable [_name, OR(_value,nil), true];
  } forEach _variables;
};

sh_isStaticWeapon = {
  ARGVX4(0,_obj,objNull,false);
  init(_class,typeOf _obj);
  (_class isKindOf "StaticWeapon")
};

sh_isBeacon = {
  ARGVX4(0,_obj,objNull,false);
  (_obj getVariable ["a3w_spawnBeacon", false])
};

sh_isCamera = {
  ARGVX4(0,_obj,objNull,false);
  (_obj getVariable ["a3w_cctv_camera", false])
};

sh_isBoomerang = {
  ARGVX4(0,_obj,objNull,false);
  (_obj getVariable ["has_boomerang", false])
};

sh_isBox = {
  ARGVX4(0,_obj,objNull,false);
  init(_class,typeOf _obj);
  (_class isKindOf "ReammoBox_F")
};

sh_isWarchest = {
  ARGVX4(0,_obj,objNull,false);
  (
    _obj getVariable ["a3w_warchest", false] && {
    (_obj getVariable ["side", sideUnknown]) in [WEST,EAST]}
  )
};

sh_mineAmmo2Vehicle = {
  ARGVX3(0,_class,"");

  _class = (([_class, "_"] call BIS_fnc_splitString) select 0);

  //hopefully after splitting, and taking the first part, we have the actual vehicle class name
  (_class)
};



sh_isSaveableMine ={
  ARGVX2(0,_arg);

  def(_class);
  if (isOBJECT(_arg)) then {
    _class = typeOf _arg;
  }
  else { if(isSTRING(_arg)) then {
    _class = _arg;
  };};

  (!(isNil "_class") && {_class in A3W_saveable_mines_list})
};




/**
 * KillzoneKid's way for creating Charges, and Claymores ... very hacky
 */
sh_placeCharge = {
  ARGVX3(0,_charge,"");
  ARGVX3(1,_position,[]);
  ARGV2(2,_vectors_or_dir);

  def(_unit);
  def(_group);
  _group = createGroup sideLogic;
  _unit = _group createUnit ["B_Soldier_F", _position,[], 0, "CAN_COLLIDE"];
  _unit hideObjectGlobal true;
  if (isARRAY(_vectors_or_dir)) then {
    _unit setVectorDirAndUp _vectors;
  }
  else { if (isSCALAR(_vectors_or_dir)) then {
    _unit setDir _vectors;
  };};

  def(_muzzle);
  def(_mag);
  _mag = format["%1_Remote_Mag", _charge];
  _muzzle = if (["directional", _charge, true] call BIS_fnc_inString) then {"DirectionalMineRemoteMuzzle"} else {"DemoChargeMuzzle"};

  _unit playActionNow "PutDown";
  _unit addMagazine format["%1_Remote_Mag", _charge];
  _unit selectWeapon _muzzle;
  _unit fire [_muzzle, _muzzle, _mag];
  _unit setWeaponReloadingTime [_unit, _muzzle, 0];


  [_unit,_group] spawn {
    sleep 3;
	  deleteVehicle (_this select 0);
    deleteGroup (_this select 1);
  };
};

sh_isCharge = {
  ARGVX2(0,_arg);

  def(_class);
  if (isOBJECT(_arg)) then {
    _class = typeOf _arg;
  }
  else { if(isSTRING(_arg)) then {
    _class = _arg;
  };};

 ((["charge", _class, true] call BIS_fnc_inString) || {(["claymore", _class, true] call BIS_fnc_inString)})
};

sh_isMine = {
  ARGVX2(0,_arg);

  def(_class);
  if (isOBJECT(_arg)) then {
    _class = typeOf _arg;
  }
  else { if(isSTRING(_arg)) then {
    _class = _arg;
  };};

  if (isNil "_class") exitWith {false};

  _class = [_class] call sh_mineAmmo2Vehicle;

  (_class isKindOf "MineBase")
};

sh_isAMissionVehicle = {
  ARGVX4(0,_obj,objNull,false);
  def(_mission);
  _mission = _obj getVariable "A3W_missionVehicle";
  (isBOOLEAN(_mission) && {_mission})
};


sh_isAPurchasedVehicle = {
  ARGVX4(0,_obj,objNull,false);
  def(_purchased);
  _purchased = _obj getVariable "A3W_purchasedVehicle";
  (isBOOLEAN(_purchased) && {_purchased})
};

sh_isUAV_UGV = {
  ARGVX4(0,_obj,objNull,false);
  (getNumber(configFile >> "CfgVehicles" >> typeOf _obj >> "isUav") > 0)
};

sh_isUAV = {
  ARGV2(0,_arg);

  def(_class);
  if (isOBJECT(_arg)) then {
    _class = typeOf _arg;
  }
  else { if (isSTRING(_arg)) then {
    _class = _arg;
  }};

  if (isNil "_class") exitWith {false};

  (_class isKindOf "UAV_02_base_F" || {_class isKindOf "UAV_01_base_F"})
};


sh_getVehicleTurrets = {
  def(_default);
  _default = [nil,nil,nil];
  ARGVX4(0,_veh,objNull,_default);

  def(_all_turrets);
  _all_turrets = [magazinesAmmo _veh, [], []];

  def(_class);
  _class = typeOf _veh;

  def(_turretMags);
  def(_turretMags2);
  def(_turretMags3);

  _turretMags = _all_turrets select 0;
  _turretMags2 = _all_turrets select 1;
  _turretMags3 = _all_turrets select 2;

  def(_hasDoorGuns);
  _hasDoorGuns = isClass (configFile >> "CfgVehicles" >> _class >> "Turrets" >> "RightDoorGun");

  def(_turrets);
  _turrets = allTurrets [_veh, false];

  if !(_class isKindOf "B_Heli_Transport_03_unarmed_F") then {
    _turrets = [[-1]] + _turrets; // only add driver turret if not unarmed Huron, otherwise flares get saved twice
  };

  if (_hasDoorGuns) then {
    // remove left door turret, because its mags are already returned by magazinesAmmo
    {
      if (_x isEqualTo [1]) exitWith {
        _turrets set [_forEachIndex, 1];
      };
    } forEach _turrets;

    _turrets = _turrets - [1];
  };


  {if (true) then {
    _path = _x;
    if (str(_path) == "[0]") exitWith {}; //don't look at the mags from the first turret again

    {
      if (([_turretMags, _x, -1] call fn_getFromPairs == -1) || {_hasDoorGuns}) then {
        if (_veh currentMagazineTurret _path == _x && {count _turretMags3 == 0}) then {
          _turretMags3 pushBack [_x, _path, [_veh currentMagazineDetailTurret _path] call getMagazineDetailAmmo];
        }
        else {
          _turretMags2 pushBack [_x, _path];
        };
      };
    } forEach (_veh magazinesTurret _path);
  }} forEach _turrets;

  (_all_turrets)
};


sh_restoreVehicleTurrets = {
  ARGVX3(0,_veh,objNull);
  ARGV3(1,_turret0,[]);
  ARGV3(2,_turret1,[]);
  ARGV3(3,_turret2,[]);

  //legacy data did not contain turret information, in that case, don't attempt to restore them
  if (isNil "_turret0" && {isNil "_turret1" && {isNil "_turret3"}}) exitWith {};

	if (!isNil "_turret0" && !isNil "_turret2" && {_turret0 isEqualTo [] && _turret2 isEqualTo []}) then
	{
		// for vehicles saved from A3 v1.56 and onwards, remove all default mags because empty ones are saved
		{ _veh removeMagazineTurret [_x select 0, _x select 1] } forEach magazinesAllTurrets _veh;
	}
	else
	{
		// for older vehicle saves, mark all default mags as empty so it can still be resupplied to its default ammo capacity
		_veh setVehicleAmmo 0;
	}; 

	// Remove all turret weapons to ensure they are reloaded properly
	_turretWeapons = _veh call fn_removeTurretWeapons;

  if (!isNil "_turret2") then {
    {
      _veh addMagazineTurret [_x select 0, _x select 1];
      _veh setVehicleAmmo (_x select 2);
    } forEach _turret2;
  };

  if (!isNil "_turret0") then {
    { _veh addMagazine _x } forEach _turret0;
  };

  if (!isNil "_turret1") then {
    { _veh addMagazineTurret _x } forEach _turret1;
  };

	// Re-add all turret weapons to ensure they are reloaded properly
	{ _veh addWeaponTurret _x } forEach _turretWeapons;
	_veh hideObjectGlobal false;
};

sh_calcualte_vectors = {
  ARGVX3(0,_data,[]);
  private["_direction","_angle","_pitch"];

  _direction = _data select 0;
  _angle = _data select 1;
  _pitch = _data select 2;

  _vecdx = sin(_direction) * cos(_angle);
  _vecdy = cos(_direction) * cos(_angle);
  _vecdz = sin(_angle);

  _vecux = cos(_direction) * cos(_angle) * sin(_pitch);
  _vecuy = sin(_direction) * cos(_angle) * sin(_pitch);
  _vecuz = cos(_angle) * cos(_pitch);

  private["_dir_vector"];
  private["_up_vector"];
  _dir_vector = [_vecdx,_vecdy,_vecdz];
  _up_vector = [_vecux,_vecuy,_vecuz];

  ([_dir_vector,_up_vector])
};

sh_set_heading = {
  ARGVX3(0,_object,objNull);
  ARGVX3(1,_data,[]);

  if (typeName (_data select 0) == typeName []) exitWith {
    _object setVectorDirAndUp _data;
  };

  def(_vectors);
  _vectors = [_data] call sh_calcualte_vectors;
  _object setVectorDirAndUp _vectors;
};

sh_fake_attach = {
  ARGVX3(0,_source,objNull);
  ARGVX3(1,_target,objNull);
  ARGVX3(2,_offset,[]);
  ARGV3(3,_heading,[]);
  ARGV4(4,_attached,false,false);

  if (isNil "_heading") then {
    _heading = [0,0,0];
  };

  _source attachTo [_target, _offset];

  [_source, _heading] call sh_set_heading;

  if (not(_attached)) then {
    //hack to have the objects not being attached
    _source attachTo [_source,[0,0,0]];
    detach _source;
  };
};

sh_create_setPos_reference = {
  if (!isNil "setPos_reference") exitWith {};
  setPos_reference = "Sign_Sphere10cm_F" createVehicleLocal [0,0,0];
  setPos_reference setPos [0,0,0];

  [setPos_reference,[0,0,0]] call sh_set_heading;
};

[] call sh_create_setPos_reference;

sh_fake_setPos = {
  //player groupChat format["camera_fake_setPos %1",_this];
  ARGVX3(0,_object,objNull);
  ARGVX3(1,_position,[]);
  ARGV3(2,_heading,[]);

  [_object,setPos_reference, (setPos_reference worldToModel _position),OR(_heading,nil)] call object_fake_attach;
};

sh_getValueFromPairs = {
  ARGVX3(0,_object_data,[]);
  ARGVX3(1,_searchForKey,"");

  def(_result);
  def(_key);
  def(_value);

  {
    _key = _x select 0;
    _value = _x select 1;
    if (_key == _searchForKey) exitWith {
      _result = OR(_value,nil)
    };
  } forEach _object_data;
  
  if (isNil "_result") exitWith {
    //diag_log format ["Error: %1 does not have %2!", _x, _searchForKey];
    nil
  };


  (_result);
};

sh_fillMagazineData = {
  ARGVX3(0,_container,objNull);
  ARGVX3(1,_full_mags,[]);
  ARGVX3(2,_partial_mags,[]);

  def(_mag);
  def(_ammo);

  {if (true) then {
    _mag = _x select 0;
    _ammo = _x select 1;

    if (_ammo == getNumber (configFile >> "CfgMagazines" >> _mag >> "count")) exitWith {
      [_full_mags, _mag, 1] call fn_addToPairs;
    };

    if (_ammo > 0) exitWith {
      _partial_mags pushBack [_mag, _ammo];
    };
  }} forEach (magazinesAmmoCargo _container);
};


sh_fsm_invoke = {
  //diag_log format["%1 call sh_fsm_invoke", _this];
  ARGV2(0,_left);
  ARGVX2(1,_right);
  ARGV4(2,_async,false,false);

  if (!isCODE(_right)) exitWith {};
  if (isNil "_left") then {
    _left = [];
  };


  def(_var_name);
  _var_name = format["var_%1",ceil(random 10000)];

  def(_fsm);
  _fsm = [_var_name, _left, _right] execFSM "persistence\sock\call3.fsm";

  //if async, return the name of the variable that will hold the results
  if (_async) exitWith {_var_name};

  waitUntil {completedFSM _fsm};

  def(_result);
  _result = (missionNamespace getVariable _var_name);
  missionNamespace setVariable [_var_name, nil];
  OR(_result,nil)
};

sh_isFlying = {
  ARGV2(0,_arg);

  init(_flying_height,20);

  if (isOBJECT(_arg)) exitWith {
    (!isTouchingGround _arg && (getPos _arg) select 2 > _flying_height)
  };

  if (isPOS(_arg)) exitWith {
   (_arg select 2 > _flying_height)
  };

  false
};

sh_drop_player_inventory = {
  //Taken from onKilled. Drop player items and money.
  private["_player", "_money"];
  _player = _this;
  _money = _player getVariable ["cmoney", 0];
  _player setVariable ["cmoney", 0, true];

  // wait until corpse stops moving before dropping stuff
  waitUntil {(getPos _player) select 2 < 1 && vectorMagnitude velocity _player < 1};

  // Drop money
  private["_m"];
  if (_money > 0) then
  {
    _m = createVehicle ["Land_Money_F", getPosATL _player, [], 0.5, "CAN_COLLIDE"];
    _m setDir random 360;
    _m setVariable ["cmoney", _money, true];
    _m setVariable ["owner", "world", true];
  };

  // Drop items
  private["_inventory", "_id", "_qty",  "_type", "_object"];
  _inventory = _player getVariable ["inventory",[]];
  {   
    _id = _x select 0;
    _qty = _x select 1;
    _type = _x select 4;
    for "_i" from 1 to _qty do {
    _obj = createVehicle [_type, getPosATL _player, [], 0.5, "CAN_COLLIDE"];
    _obj setDir getDir _player;
    _obj setVariable ["mf_item_id", _id, true];
    };
  } forEach _inventory;
};

sh_hc_ready = {
  (!isNil "HeadlessClient" && {
   !isNull HeadlessClient && {
   HeadlessClient getVariable ["hc_ready",false]}})
};


sh_sync_request_handler = {
  if (!isServer) exitWith {};
  ARGVX3(1,_this,[]);
  ARGVX3(0,_client,objNull);
  ARGVX3(1,_var,"");
  ARGVX3(2,_flag,"");

  init(_id,owner _client);
  diag_log format["Syncing %1 to client (_id = %2)" ,_var, _id];
  _id publicVariableClient _var;

  //set flag to indicate result is ready
  missionNamespace setVariable [_flag, true];
  _id publicVariableClient _flag;
  missionNamespace setVariable [_flag, nil];
};

if (isServer) then {
  "sh_sync_request" addPublicVariableEventHandler { _this spawn sh_sync_request_handler;};
};

if (not(hasInterface || isDedicated)) then {
  sh_sync = {
    if (isServer) exitWith {};
    ARGVX3(0,_var);

    def(_flag);
    _flag = format["sync_flag_%1_%2", ceil(random 1000), ceil(random 1000)];
    sh_sync_request = [player,_var,_flag];
    publicVariableServer "sh_sync_request";

    init(_timed_out,false);
    init(_end_time,diag_tickTime + 10);
    waitUntil {
      if (not(isNil{missionNamespace getVariable _flag})) exitWith {true};
      if (diag_tickTime > _end_time) exitWith {
        _timed_out = true;
        true
      };
      uiSleep 0.5;
    };

    if (_timed_out) exitWith {
      diag_log format["WARNING: Timeout occurred while waiting for value of variable %2", _var];
      false
    };
  };
};

sh_hc_forward = {
  //diag_log format["%1 call sh_hc_forward", _this];
  ARGVX3(0,_var,"");
  ARGV2(1,_val);
  if (not(hasInterface || isDedicated)) exitWith {};
  if (not(call sh_hc_ready)) exitWith {};
  init(_id, owner HeadlessClient);

  if (!isNil "_val") then {
    missionNamespace setVariable [_var, _val];
  };

  //diag_log format["Forwarding %1 to headless client (_id = %2)", _var, _id];
  _id publicVariableClient _var;
};

shFunctions_loaded = true;
diag_log "shFunctions loading complete";