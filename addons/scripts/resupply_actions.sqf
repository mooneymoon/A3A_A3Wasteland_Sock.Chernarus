
A3W_fnc_setVehicleAmmoDef = {
  private["_left", "_right"];
  _left = _this select 0;
  _right  = _this select 1;
  if (isNil "_left" || { typeName _left != typeName objNull || { isNull _left}}) exitWith {};
  if (isNil "_right" || { typeName _right != typeName 0}) exitWith {};
  diag_log format["%1 call A3W_fnc_setVehicleAmmoDef--->", _this];
  _left setVehicleAmmoDef _right;
};

A3W_fnc_removeMagazinesTurret = {
  private["_left", "_right"];
  _left = _this select 0;
  _right  = _this select 1;
  if (isNil "_left" || { typeName _left != typeName objNull || { isNull _left}}) exitWith {};
  if (isNil "_right" || { typeName _right != typeName []}) exitWith {};
  _left removeMagazineTurret _right;
};

A3W_fnc_addMagazineTurret = {
  private["_left", "_right"];
  _left = _this select 0;
  _right  = _this select 1;
  if (isNil "_left" || { typeName _left != typeName objNull || { isNull _left}}) exitWith {};
  if (isNil "_right" || { typeName _right != typeName []}) exitWith {};
  _left addMagazineTurret _right;
};

A3W_fnc_addMagazineTurretMortar = {
  private["_mortar"];
  _mortar = _this select 0;
  _mortar setVehicleAmmo 0;
  _mortar setVehicleAmmoDef 0;		
  _mortar call fn_removeTurretWeapons;
  _mortar addMagazineTurret ["8Rnd_82mm_Mo_shells",[0]];
  _mortar addMagazineTurret ["8Rnd_82mm_Mo_Flare_white",[0]];
  _mortar addMagazineTurret ["8Rnd_82mm_Mo_LG",[0]];
  _mortar addWeaponTurret ["FakeWeapon",[0]]; 
  _mortar addWeaponTurret ["mortar_82mm",[0]];
  reload _mortar;
};

A3W_fnc_addMagazineTurretBcas = {
  private["_bcas"];
  _bcas = _this select 0;
  _bcas setVehicleAmmo 0;
  _bcas setVehicleAmmoDef 0;			
  _bcas call fn_removeTurretWeapons;
  _bcas addMagazineTurret ["1000Rnd_Gatling_30mm_Plane_CAS_01_F",[-1]];
  _bcas addMagazineTurret ["2Rnd_Missile_AA_04_F",[-1]];
  _bcas addMagazineTurret ["4Rnd_Bomb_04_F",[-1]];
  _bcas addMagazineTurret ["240Rnd_CMFlare_Chaff_Magazine",[-1]];
  _bcas addWeaponTurret ["Gatling_30mm_Plane_CAS_01_F",[-1]];
  _bcas addWeaponTurret ["Missile_AA_04_Plane_CAS_01_F",[-1]];
  _bcas addWeaponTurret ["Bomb_04_Plane_CAS_01_F", [-1]];
  _bcas addWeaponTurret ["CMFlareLauncher", [-1]];
  reload _bcas;
};

A3W_fnc_addMagazineTurretOcas = {
  private["_ocas"];
  _ocas = _this select 0;
  _ocas setVehicleAmmo 0;
  _ocas setVehicleAmmoDef 0;			
  _ocas call fn_removeTurretWeapons;
  _ocas addMagazineTurret ["500Rnd_Cannon_30mm_Plane_CAS_02_F",[-1]];
  _ocas addMagazineTurret ["20Rnd_Rocket_03_HE_F",[-1]];
  _ocas addMagazineTurret ["2Rnd_Missile_AA_03_F",[-1]];
  _ocas addMagazineTurret ["2Rnd_Bomb_03_F",[-1]];
  _ocas addMagazineTurret ["240Rnd_CMFlare_Chaff_Magazine",[-1]];
  _ocas addWeaponTurret ["Cannon_30mm_Plane_CAS_02_F",[-1]];
  _ocas addWeaponTurret ["Missile_AA_03_Plane_CAS_02_F",[-1]];			
  _ocas addWeaponTurret ["Rocket_03_HE_Plane_CAS_02_F",[-1]];
  _ocas addWeaponTurret ["Bomb_03_Plane_CAS_02_F", [-1]];
  _ocas addWeaponTurret ["CMFlareLauncher", [-1]];
  reload _ocas;
};

A3W_fnc_addMagazineTurretIcas = {
  private["_Icas"];
  _Icas = _this select 0;
  _Icas setVehicleAmmo 0;
  _Icas setVehicleAmmoDef 0;			
  _Icas call fn_removeTurretWeapons;
  _Icas addMagazineTurret ["300Rnd_20mm_shells",[-1]];
  _Icas addMagazineTurret ["300Rnd_20mm_shells",[-1]];
  _Icas addMagazineTurret ["2Rnd_AAA_missiles",[-1]];
  _Icas addMagazineTurret ["2Rnd_GBU12_LGB_MI10",[-1]];
  _Icas addMagazineTurret ["240Rnd_CMFlare_Chaff_Magazine",[-1]];
  _Icas addWeaponTurret ["Twin_Cannon_20mm",[-1]];
  _Icas addWeaponTurret ["missiles_ASRAAM",[-1]];					
  _Icas addWeaponTurret ["GBU12BombLauncher",[-1]];
  _Icas addWeaponTurret ["CMFlareLauncher", [-1]];
  reload _Icas;
};

A3W_fnc_addMagazineTurretHorca = {
  private["_Horca"];
  _Horca = _this select 0;
  _Horca setVehicleAmmo 0;
  _Horca setVehicleAmmoDef 0;			
  _Horca call fn_removeTurretWeapons;         
  _Horca addMagazineTurret ["2000Rnd_65x39_Belt_Tracer_Green_Splash",[-1]];
  _Horca addMagazineTurret ["12Rnd_missiles",[-1]];
  _Horca addMagazineTurret ["168Rnd_CMFlare_Chaff_Magazine",[-1]];
  _Horca addWeaponTurret ["LMG_Minigun_heli", [-1]];
  _Horca addWeaponTurret ["missiles_DAR",[-1]];
  _Horca addWeaponTurret ["CMFlareLauncher", [-1]];  
  reload _Horca;
};

A3W_fnc_addMagazineTurretUav2 = {
  private["_uav2"];
  _uav2 = _this select 0;
  _uav2 setVehicleAmmo 0;
  _uav2 setVehicleAmmoDef 0;	
  _uav2 call fn_removeTurretWeapons;     
  _uav2 addMagazineTurret ["120Rnd_CMFlare_Chaff_Magazine",[-1]];
  _uav2 addMagazineTurret ["Laserbatteries",[0]];     
  _uav2 addMagazineTurret ["2Rnd_LG_scalpel",[0]];
  _uav2 addWeaponTurret ["CMFlareLauncher", [-1]];
  _uav2 addWeaponTurret ["Laserdesignator_mounted", [0]];
  _uav2 addWeaponTurret ["missiles_SCALPEL", [0]];   	
  reload _uav2;
};

A3W_fnc_addMagazineTurretLheli = {
  private["_Lheli"];
  _Lheli = _this select 0;
  _Lheli removeMagazineTurret ["60Rnd_CMFlare_Chaff_Magazine", [-1]];
  _Lheli addWeaponTurret ["CMFlareLauncher", [-1]];
  _Lheli addMagazineTurret ["60Rnd_CMFlare_Chaff_Magazine", [-1]];
  reload _Lheli;
};

A3W_fnc_addMagazineTurretBaheli = {
  private["_Baheli"];
  _Baheli = _this select 0;
  _Baheli setVehicleAmmo 0;
  _Baheli setVehicleAmmoDef 0;		
  _Baheli call fn_removeTurretWeapons;
  _Baheli addMagazineTurret ["240Rnd_CMFlare_Chaff_Magazine",[-1]];
  _Baheli addMagazineTurret ["1000Rnd_20mm_shells",[0]];
  _Baheli addMagazineTurret ["12Rnd_PG_missiles",[0]];
  _Baheli addMagazineTurret ["4Rnd_AAA_missiles",[0]];
  _Baheli addWeaponTurret ["CMFlareLauncher",[-1]]; 
  _Baheli addWeaponTurret ["gatling_20mm",[0]];
  _Baheli addWeaponTurret ["missiles_DAGR",[0]]; 
  _Baheli addWeaponTurret ["missiles_ASRAAM",[0]]; 
  reload _Baheli;
};

A3W_fnc_addMagazineTurretOaheli = {
  private["_Oaheli"];
  _Oaheli = _this select 0;
  _Oaheli setVehicleAmmo 0;
  _Oaheli setVehicleAmmoDef 0;		
  _Oaheli call fn_removeTurretWeapons;
  _Oaheli addMagazineTurret ["192Rnd_CMFlare_Chaff_Magazine",[-1]];
  _Oaheli addMagazineTurret ["250Rnd_30mm_HE_shells",[0]];
  _Oaheli addMagazineTurret ["250Rnd_30mm_APDS_shells",[0]];
  _Oaheli addMagazineTurret ["6Rnd_LG_scalpel",[0]];
  _Oaheli addMagazineTurret ["14Rnd_80mm_rockets",[0]];
  _Oaheli addWeaponTurret ["CMFlareLauncher",[-1]]; 
  _Oaheli addWeaponTurret ["gatling_30mm",[0]];
  _Oaheli addWeaponTurret ["missiles_SCALPEL",[0]]; 
  _Oaheli addWeaponTurret ["rockets_Skyfire",[0]]; 
  reload _Oaheli;
};

if (isServer) exitWith {};

resupply_vehicles = [
  'O_Heli_Transport_04_ammo_F',
  'I_Truck_02_ammo_F',
  'O_Truck_03_ammo_F',
  'B_Truck_01_ammo_F'
];

do_resupply = {
  (_this select 3) execVM "addons\scripts\fn_resupplytruck.sqf";
};


#define VEHICLE_NAME(x) (getText ((configFile >> "CfgVehicles" >> (typeOf x)) >> "displayName"))

uav_resupply_watch = {
  diag_log format["%1 call uav_resupply_watch", _this];
  private["_uavCheck"];
  _uavCheck = {
    private["_uav", "_action_id"];
    _uav = getConnectedUAV player;
    (!(isNull _uav) && {(count(nearestObjects [getPos _uav, resupply_vehicles, 15]) > 0)})
  };

  waitUntil {
    waitUntil {sleep 3; (call _uavCheck)};
    private["_uav"];
    _uav = getConnectedUAV player;
    _action_id = _uav addAction [
      format["<img image='client\icons\repair.paa'/> Resupply %1",VEHICLE_NAME(_uav)],
      {_this call do_resupply;}, _uav, 15,false,true,"", "(isNil 'mutexScriptInProgress' || {not(mutexScriptInProgress)})"
    ];
    waitUntil {sleep 3; not(call _uavCheck)};
    _uav removeAction _action_id;
    sleep 3;
 };
};

static_weapon_resupply_watch = {
  diag_log format["%1 call static_weapon_resupply_watch", _this];
  private["_staticCheck"];
  _staticCheck = {
    private["_static"];
    _static = (vehicle player);
    if (not(isNull _static) && {
         _static isKindOf "StaticWeapon" && {
         player == gunner(_static) && {
         (count(nearestObjects [getPos _static, resupply_vehicles, 15]) > 0)}}}) exitWith {
      _static
    };
    nil
  };

  private["_static", "_action_id"];
  waitUntil {
    waitUntil { sleep 3; _static = call _staticCheck; !isNil "_static"};
    _action_id = _static addAction [
      format["<img image='client\icons\repair.paa'/> Resupply %1",VEHICLE_NAME(_static)],
      {_this call do_resupply;}, _static, 15,false,true,"", "(isNil 'mutexScriptInProgress' || {not(mutexScriptInProgress)})"
    ];
    waitUntil { sleep 3; isNil {call _staticCheck}};
    _static removeAction _action_id;
    sleep 3;
 };
};

vehicle_resupply_watch = {
  diag_log format["%1 call vehicle_resupply_watch", _this];
  private["_vehicleCheck"];
  _vehicleCheck = {
    private["_vehicle"];
    _vehicle = (vehicle player);
    if !(!isNull _vehicle && {
         player != _vehicle && {
         player == driver(_vehicle) && {
         not(_vehicle isKindOf "StaticWeapon") && {
         (count(nearestObjects [getPos _vehicle, resupply_vehicles, 15]) > 0)}}}}) exitWith {
      nil
    };
    _vehicle
  };

  private["_vehicle", "_action_id"];
  waitUntil {
    waitUntil { sleep 3; _vehicle = call _vehicleCheck; !isNil "_vehicle"};
    _action_id = _vehicle addAction [
      format["<img image='client\icons\repair.paa'/> Resupply %1",VEHICLE_NAME(_vehicle)],
      {_this call do_resupply;}, _vehicle, 15,false,true,"", "(isNil 'mutexScriptInProgress' || {not(mutexScriptInProgress)})"
    ];
    waitUntil { sleep 3; isNil {call _vehicleCheck}};
    _vehicle removeAction _action_id;
    sleep 3;
 };
};

[] spawn uav_resupply_watch;
[] spawn static_weapon_resupply_watch;
[] spawn vehicle_resupply_watch;
