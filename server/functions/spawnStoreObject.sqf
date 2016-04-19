// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: spawnStoreObject.sqf
//	@file Author: AgentRev
//	@file Created: 11/10/2013 22:17
//	@file Args:

if (!isServer) exitWith {};

scopeName "spawnStoreObject";
private ["_player", "_class", "_marker", "_key", "_isGenStore", "_isGunStore", "_isVehStore", "_timeoutKey", "_objectID", "_playerSide", "_objectsArray", "_itemEntry", "_itemPrice", "_safePos", "_object"];

_player = param [0, objNull, [objNull]];
_class = param [1, "", [""]];
_marker = param [2, "", [""]];
_key = param [3, "", [""]];

_isGenStore = ["GenStore", _marker] call fn_startsWith;
_isGunStore = ["GunStore", _marker] call fn_startsWith;
_isVehStore = ["VehStore", _marker] call fn_startsWith;

if (_key != "" && isPlayer _player && {_isGenStore || _isGunStore || _isVehStore}) then
{
	_timeoutKey = _key + "_timeout";
	_objectID = "";
	_playerSide = side group _player;

	if (_isGenStore || _isGunStore) then
	{
		_marker = _marker + "_objSpawn";

		switch (true) do
		{
			case _isGenStore: { _objectsArray = genObjectsArray };
			case _isGunStore: { _objectsArray = staticGunsArray };
		};

		if (!isNil "_objectsArray") then
		{
			{
				if (_class == _x select 1) exitWith
				{
					_itemEntry = _x;
				};
			} forEach (call _objectsArray);
		};
	};

	if (_isVehStore) then
	{
		// LAND VEHICLES
		{
			{
				if (_class == _x select 1) exitWith
				{
					_itemEntry = _x;
					_marker = _marker + "_landSpawn";
				};
			} forEach (call _x);
		} forEach [landArray, armoredArray, tanksArray];

		// SEA VEHICLES
		if (isNil "_itemEntry") then
		{
			{
				if (_class == _x select 1) exitWith
				{
					_itemEntry = _x;
					_marker = _marker + "_seaSpawn";
				};
			} forEach (call boatsArray);
		};

		// HELICOPTERS
		if (isNil "_itemEntry") then
		{
			{
				if (_class == _x select 1) exitWith
				{
					_itemEntry = _x;
					_marker = _marker + "_heliSpawn";
				};
			} forEach (call helicoptersArray);
		};

		// AIRPLANES
		if (isNil "_itemEntry") then
		{
			{
				if (_class == _x select 1) exitWith
				{
					_itemEntry = _x;
					_marker = _marker + "_planeSpawn";
				};
			} forEach (call planesArray);
		};
	};

	if (!isNil "_itemEntry" && {{_x == _marker} count allMapMarkers > 0}) then
	{
		_itemPrice = _itemEntry select 2;

		/*if (_class isKindOf "Box_NATO_Ammo_F") then
		{
			switch (side _player) do
			{
				case OPFOR:       { _class = "Box_East_Ammo_F" };
				case INDEPENDENT: { _class = "Box_IND_Ammo_F" };
			};
		};*/

		if (_player getVariable ["cmoney", 0] >= _itemPrice) then
		{
			_safePos = (markerPos _marker) findEmptyPosition [0, 50, _class];
			if (count _safePos == 0) then { _safePos = markerPos _marker };

			if (_player getVariable [_timeoutKey, true]) then { breakOut "spawnStoreObject" }; // Timeout

			_object = createVehicle [_class, _safePos, [], 0, "None"];

			if (_player getVariable [_timeoutKey, true]) then // Timeout
			{
				deleteVehicle _object;
				breakOut "spawnStoreObject";
			};

			_objectID = netId _object;
			_object setVariable ["A3W_purchasedStoreObject", true];
			//_object setVariable ["ownerUID", getPlayerUID _player, true];

			[_object] call v_trackVehicle;

			if (getNumber (configFile >> "CfgVehicles" >> _class >> "isUav") > 0) then
			{
				//assign AI to the vehicle so it can actually be used
				createVehicleCrew _object;

				[_object, _playerSide] spawn
				{
					_veh = _this select 0;
					_side = _this select 1;

					waitUntil {!isNull driver _veh};

					//assign AI to player's side to allow terminal connection
					(crew _veh) joinSilent createGroup _side;

					{
						[[_x, ["AI","",""]], "A3W_fnc_setName", true] call A3W_fnc_MP;
					} forEach crew _veh;
				};
			};

			if (isPlayer _player && !(_player getVariable [_timeoutKey, true])) then
			{
				_player setVariable [_key, _objectID, true];
			}
			else // Timeout
			{
				if (!isNil "_object") then { deleteVehicle _object };
				breakOut "spawnStoreObject";
			};

			if (_object isKindOf "AllVehicles" && !(_object isKindOf "StaticWeapon")) then
			{
				_object setPosATL [_safePos select 0, _safePos select 1, 0.05];
				_object setVelocity [0,0,0.01];
				//_object spawn cleanVehicleWreck;
				//_object setVariable ["A3W_purchasedVehicle", true, true];

				if ({_object isKindOf _x} count ["UAV_02_base_F", "UGV_01_base_F"] > 0) then {
					_object setVariable ["A3W_purchasedVehicle", true];
					_object setVariable ["A3W_missionVehicle", false];
					_object setVariable ["ownerUID", getPlayerUID _player, true];
					_object setVariable ["ownerN", name _player, true];
				};

				if ({_object isKindOf _x} count A3W_autosave_vehicles_list > 0) then {
					[[netId _object, 2], "A3W_fnc_setLockState", _object] call A3W_fnc_MP; // Lock
					_object setVariable ["objectLocked", true, true];
					_object setVariable ["R3F_LOG_disabled", true, true];
					_object setVariable ["A3W_purchasedVehicle", true];
					_object setVariable ["A3W_missionVehicle", false];
					_object setVariable ["ownerUID", getPlayerUID _player, true];
					_object setVariable ["ownerN", name _player, true];
				};
			};

			_object setDir (if (_object isKindOf "Plane") then { markerDir _marker } else { random 360 });

			//_isDamageable = !(_object isKindOf "ReammoBox_F"); // ({_object isKindOf _x} count ["AllVehicles", "Lamps_base_F", "Cargo_Patrol_base_F", "Cargo_Tower_base_F"] > 0);

			[_object] call vehicleSetup;
			//_object allowDamage _isDamageable;
			//_object setVariable ["allowDamage", _isDamageable];

			clearBackpackCargoGlobal _object;

			switch (true) do
			{
				case ({_object isKindOf _x} count ["Box_NATO_AmmoVeh_F", "Box_East_AmmoVeh_F", "Box_IND_AmmoVeh_F"] > 0):
				{
					_object setAmmoCargo 0;
				};

				case (_object isKindOf "O_Heli_Transport_04_ammo_F"):
				{
					_object setAmmoCargo 0;
				};

				case ({_object isKindOf _x} count ["B_Truck_01_ammo_F", "O_Truck_02_Ammo_F", "O_Truck_03_ammo_F", "I_Truck_02_ammo_F"] > 0):
				{
					_object setAmmoCargo 0;
				};

				case ({_object isKindOf _x} count ["C_Van_01_fuel_F", "I_G_Van_01_fuel_F", "O_Heli_Transport_04_fuel_F"] > 0):
				{
					_object setFuelCargo 10;
				};

				case ({_object isKindOf _x} count ["B_Truck_01_fuel_F", "O_Truck_02_fuel_F", "O_Truck_03_fuel_F", "I_Truck_02_fuel_F"] > 0):
				{
					_object setFuelCargo 25;
				};

				case (_object isKindOf "Offroad_01_repair_base_F"):
				{
					_object setRepairCargo 5;
				};

				case (_object isKindOf "O_Heli_Transport_04_repair_F"):
				{
					_object setRepairCargo 10;
				};

				case ({_object isKindOf _x} count ["B_Truck_01_Repair_F", "O_Truck_02_box_F", "O_Truck_03_repair_F", "I_Truck_02_box_F"] > 0):
				{
					_object setRepairCargo 25;
				};

				case ({_object isKindOf _x} count ["B_UAV_02_F", "O_UAV_02_F", "I_UAV_02_F"] > 0):
				{
					_object setVehicleAmmo 0;
					_object setVehicleAmmoDef 0;
					_object call fn_removeTurretWeapons;
					_object addMagazineTurret ["120Rnd_CMFlare_Chaff_Magazine",[-1]];
					_object addMagazineTurret ["Laserbatteries",[0]];
					_object addMagazineTurret ["2Rnd_LG_scalpel",[0]];
					_object addWeaponTurret ["CMFlareLauncher", [-1]];
 					_object addWeaponTurret ["Laserdesignator_mounted", [0]];
					_object addWeaponTurret ["missiles_SCALPEL", [0]];
				};

				case (_object isKindOf "B_Plane_CAS_01_F"):
				{
					_object setVehicleAmmo 0;
					_object setVehicleAmmoDef 0;
					_object call fn_removeTurretWeapons;
					_object addMagazineTurret ["1000Rnd_Gatling_30mm_Plane_CAS_01_F",[-1]];
					_object addMagazineTurret ["2Rnd_Missile_AA_04_F",[-1]];
					_object addMagazineTurret ["4Rnd_Bomb_04_F",[-1]];
					_object addMagazineTurret ["240Rnd_CMFlare_Chaff_Magazine",[-1]];
					_object addWeaponTurret ["Gatling_30mm_Plane_CAS_01_F",[-1]];
					_object addWeaponTurret ["Missile_AA_04_Plane_CAS_01_F",[-1]];
					_object addWeaponTurret ["Bomb_04_Plane_CAS_01_F", [-1]];
					_object addWeaponTurret ["CMFlareLauncher", [-1]];
				};

				case (_object isKindOf "O_Plane_CAS_02_F"):
				{
					_object setVehicleAmmo 0;
					_object setVehicleAmmoDef 0;
					_object call fn_removeTurretWeapons;
					_object addMagazineTurret ["500Rnd_Cannon_30mm_Plane_CAS_02_F",[-1]];
					_object addMagazineTurret ["20Rnd_Rocket_03_HE_F",[-1]];
					_object addMagazineTurret ["2Rnd_Missile_AA_03_F",[-1]];
					_object addMagazineTurret ["2Rnd_Bomb_03_F",[-1]];
					_object addMagazineTurret ["240Rnd_CMFlare_Chaff_Magazine",[-1]];
					_object addWeaponTurret ["Cannon_30mm_Plane_CAS_02_F",[-1]];
					_object addWeaponTurret ["Missile_AA_03_Plane_CAS_02_F",[-1]];
					_object addWeaponTurret ["Rocket_03_HE_Plane_CAS_02_F",[-1]];
					_object addWeaponTurret ["Bomb_03_Plane_CAS_02_F", [-1]];
					_object addWeaponTurret ["CMFlareLauncher", [-1]];
				};

				case (_object isKindOf "I_Plane_Fighter_03_CAS_F"):
				{
					_object setVehicleAmmo 0;
					_object setVehicleAmmoDef 0;
					_object call fn_removeTurretWeapons;
					_object addMagazineTurret ["300Rnd_20mm_shells",[-1]];
					_object addMagazineTurret ["300Rnd_20mm_shells",[-1]];
					_object addMagazineTurret ["2Rnd_AAA_missiles",[-1]];
					_object addMagazineTurret ["2Rnd_GBU12_LGB_MI10",[-1]];
					_object addMagazineTurret ["240Rnd_CMFlare_Chaff_Magazine",[-1]];
					_object addWeaponTurret ["Twin_Cannon_20mm",[-1]];
					_object addWeaponTurret ["missiles_ASRAAM",[-1]];
					_object addWeaponTurret ["GBU12BombLauncher",[-1]];
					_object addWeaponTurret ["CMFlareLauncher", [-1]];
				};

				case (_object isKindOf "O_Heli_Light_02_F"):
				{
					_object setVehicleAmmo 0;
					_object setVehicleAmmoDef 0;
					_object call fn_removeTurretWeapons;
					_object addMagazineTurret ["2000Rnd_65x39_Belt_Tracer_Green_Splash",[-1]];
					_object addMagazineTurret ["12Rnd_missiles",[-1]];
					_object addMagazineTurret ["168Rnd_CMFlare_Chaff_Magazine",[-1]];
					_object addWeaponTurret ["LMG_Minigun_heli", [-1]];
					_object addWeaponTurret ["missiles_DAR",[-1]];
					_object addWeaponTurret ["CMFlareLauncher", [-1]];
				};

				case (_object isKindOf "B_Heli_Attack_01_F"):
				{
					_object setVehicleAmmo 0;
					_object setVehicleAmmoDef 0;
					_object call fn_removeTurretWeapons;
					_object addMagazineTurret ["240Rnd_CMFlare_Chaff_Magazine",[-1]];
					_object addMagazineTurret ["1000Rnd_20mm_shells",[0]];
					_object addMagazineTurret ["12Rnd_PG_missiles",[0]];
					_object addMagazineTurret ["4Rnd_AAA_missiles",[0]];
					_object addWeaponTurret ["CMFlareLauncher",[-1]];
					_object addWeaponTurret ["gatling_20mm",[0]];
					_object addWeaponTurret ["missiles_DAGR",[0]];
					_object addWeaponTurret ["missiles_ASRAAM",[0]];
				};

				case ({_object isKindOf _x} count ["O_Heli_Attack_02_F", "O_Heli_Attack_02_black_F"] > 0):
				{
					_object setVehicleAmmo 0;
					_object setVehicleAmmoDef 0;
					_object call fn_removeTurretWeapons;
					_object addMagazineTurret ["192Rnd_CMFlare_Chaff_Magazine",[-1]];
					_object addMagazineTurret ["250Rnd_30mm_HE_shells",[0]];
					_object addMagazineTurret ["250Rnd_30mm_APDS_shells",[0]];
					_object addMagazineTurret ["6Rnd_LG_scalpel",[0]];
					_object addMagazineTurret ["14Rnd_80mm_rockets",[0]];
					_object addWeaponTurret ["CMFlareLauncher",[-1]];
					_object addWeaponTurret ["gatling_30mm",[0]];
					_object addWeaponTurret ["missiles_SCALPEL",[0]];
					_object addWeaponTurret ["rockets_Skyfire",[0]];
				};

				case ({_object isKindOf _x} count ["B_Mortar_01_F", "O_Mortar_01_F", "I_Mortar_01_F"] > 0):
				{
					_object setVehicleAmmo 0;
					_object setVehicleAmmoDef 0;
					_object call fn_removeTurretWeapons;
					_object addMagazineTurret ["8Rnd_82mm_Mo_shells",[0]];
					_object addMagazineTurret ["8Rnd_82mm_Mo_Flare_white",[0]];
					_object addMagazineTurret ["8Rnd_82mm_Mo_LG",[0]];
					_object addWeaponTurret ["FakeWeapon",[0]];
					_object addWeaponTurret ["mortar_82mm",[0]];
				};

				case (_object isKindOf "Box_NATO_Ammo_F"):
				{
					_object allowDamage false;
				};
			};
			
			_object hideObjectGlobal false;

			if (needReload _object == 1) then {reload _object};

			if (_object getVariable ["A3W_purchasedVehicle", false] && !isNil "fn_manualVehicleSave") then
			{
				_object call fn_manualVehicleSave;
			};
		};
	};
};
