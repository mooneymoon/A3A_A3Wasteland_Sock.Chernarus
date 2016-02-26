//@file Version: 1.0
//@file Name: SimpleWeatherScript.sqf
//@file Author: Gigatek, originally by Distrikt41.de - Dscha
//@file Created: 24/2/2016
//@file Description: Simple Weather Script

	private ["_fnc_SWS_Weather"];

	SWS_Fog = [0,0,0];
	SWS_Waves = 1;
	SWS_Overcast = 0.3;
	SWS_Wind = [1, 1, true];
	SWS_Rain = 0;
	SWS_RainCounter = 1;

	_fnc_SWS_Weather =
	{
		if (isDedicated) then
			{
				SWS_ChanceN = round(random 100);
				if(SWS_ChanceN <= 4) then
				{
					SWS_RainCounter = 1;
					SWS_WMod = round(random 9);
					if(SWS_WMod == 0) then {SWS_Fog = [1, 0.1,10];   SWS_Overcast = 0.4; SWS_Wind = [0, 2, true]; SWS_Rain = 0; SWS_Waves = 0;};
					if(SWS_WMod == 1) then {SWS_Fog = [1, 0.2,10];   SWS_Overcast = 0.3; SWS_Wind = [0, 2, true]; SWS_Rain = 0; SWS_Waves = 0;};
					if(SWS_WMod == 2) then {SWS_Fog = [1, 0.3,10];   SWS_Overcast = 0.3; SWS_Wind = [0, 2, true]; SWS_Rain = 0; SWS_Waves = 0;};
					if(SWS_WMod == 3) then {SWS_Fog = [0.9, 0.1,15]; SWS_Overcast = 0.3; SWS_Wind = [0, 2, true]; SWS_Rain = 0; SWS_Waves = 0;};
					if(SWS_WMod == 4) then {SWS_Fog = [0.8, 0.1,15]; SWS_Overcast = 0.4; SWS_Wind = [0, 2, true]; SWS_Rain = 0; SWS_Waves = 0;};
					if(SWS_WMod == 5) then {SWS_Fog = [0.7, 0.1,15]; SWS_Overcast = 0.3; SWS_Wind = [0, 2, true]; SWS_Rain = 0; SWS_Waves = 0;};
					if(SWS_WMod == 6) then {SWS_Fog = [0.6, 0.1,30]; SWS_Overcast = 0.3; SWS_Wind = [0, 2, true]; SWS_Rain = 0; SWS_Waves = 0;};
					if(SWS_WMod == 7) then {SWS_Fog = [0.5, 0.1,30]; SWS_Overcast = 0.4; SWS_Wind = [0, 2, true]; SWS_Rain = 0; SWS_Waves = 0;};
					if(SWS_WMod == 8) then {SWS_Fog = [0.4, 0.1,30]; SWS_Overcast = 0.3; SWS_Wind = [0, 2, true]; SWS_Rain = 0; SWS_Waves = 0;};
					if(SWS_WMod == 9) then {SWS_Fog = [0.1, 0.1,50]; SWS_Overcast = 0.5; SWS_Wind = [2, 1, true]; SWS_Rain = 0.1; SWS_Waves = 1;};
				};

				if(SWS_ChanceN >=5 && SWS_ChanceN <= 13) then
				{
					if(SWS_RainCounter == 1) then 
					{
						SWS_RainCounter = 0;
						SWS_WMod = round(random 9);
						if(SWS_WMod == 0) then {SWS_Fog = [0.1,0,0]; SWS_Overcast = 1;   SWS_Wind = [4, 4, true]; SWS_Rain = 0.6; SWS_Waves = 1;};
						if(SWS_WMod == 1) then {SWS_Fog = [0.3,0,0]; SWS_Overcast = 1;   SWS_Wind = [4, 4, true]; SWS_Rain = 0.6; SWS_Waves = 1;};
						if(SWS_WMod == 2) then {SWS_Fog = [0.1,0,0]; SWS_Overcast = 0.9; SWS_Wind = [4, 4, true]; SWS_Rain = 0.5; SWS_Waves = 1;};
						if(SWS_WMod == 3) then {SWS_Fog = [0.2,0,0]; SWS_Overcast = 0.8; SWS_Wind = [0, 5, true]; SWS_Rain = 0.5; SWS_Waves = 1;};
						if(SWS_WMod == 4) then {SWS_Fog = [0.1,0,0]; SWS_Overcast = 0.7; SWS_Wind = [5, 0, true]; SWS_Rain = 0.3; SWS_Waves = 1;};
						if(SWS_WMod == 5) then {SWS_Fog = [0,0,0];   SWS_Overcast = 0.7; SWS_Wind = [0, 6, true]; SWS_Rain = 0.3; SWS_Waves = 1;};
						if(SWS_WMod == 6) then {SWS_Fog = [0.1,0,0]; SWS_Overcast = 0.6; SWS_Wind = [5, 0, true]; SWS_Rain = 0.2; SWS_Waves = 1;};
						if(SWS_WMod == 7) then {SWS_Fog = [0,0,0];   SWS_Overcast = 0.6; SWS_Wind = [2, 4, true]; SWS_Rain = 0.2; SWS_Waves = 1;};
						if(SWS_WMod == 8) then {SWS_Fog = [0,0,0];   SWS_Overcast = 0.5; SWS_Wind = [3, 2, true]; SWS_Rain = 0.2; SWS_Waves = 1;};
						if(SWS_WMod == 9) then {SWS_Fog = [0,0,0];   SWS_Overcast = 0.5; SWS_Wind = [2, 1, true]; SWS_Rain = 0.1; SWS_Waves = 1;};					
					}
					else {SWS_ChanceN = 24};
				};

				if(SWS_ChanceN >=14 && SWS_ChanceN <= 70) then
				{
					SWS_RainCounter = 1;
					SWS_WMod = round(random 9);
					if(SWS_WMod == 0) then {SWS_Fog = [0,0,0]; SWS_Overcast = 0.4; SWS_Wind = [3, 0, true]; SWS_Rain = 0; SWS_Waves = 1;};
					if(SWS_WMod == 1) then {SWS_Fog = [0,0,0]; SWS_Overcast = 0.4; SWS_Wind = [0, 3, true]; SWS_Rain = 0; SWS_Waves = 1;};
					if(SWS_WMod == 2) then {SWS_Fog = [0,0,0]; SWS_Overcast = 0.4; SWS_Wind = [2, 3, true]; SWS_Rain = 0; SWS_Waves = 1;};
					if(SWS_WMod == 3) then {SWS_Fog = [0,0,0]; SWS_Overcast = 0.3; SWS_Wind = [3, 2, true]; SWS_Rain = 0; SWS_Waves = 1;};
					if(SWS_WMod == 4) then {SWS_Fog = [0,0,0]; SWS_Overcast = 0.3; SWS_Wind = [0, 3, true]; SWS_Rain = 0; SWS_Waves = 1;};
					if(SWS_WMod == 5) then {SWS_Fog = [0,0,0]; SWS_Overcast = 0.3; SWS_Wind = [2, 0, true]; SWS_Rain = 0; SWS_Waves = 0;};
					if(SWS_WMod == 6) then {SWS_Fog = [0,0,0]; SWS_Overcast = 0.3; SWS_Wind = [2, 2, true]; SWS_Rain = 0; SWS_Waves = 1;};
					if(SWS_WMod == 7) then {SWS_Fog = [0,0,0]; SWS_Overcast = 0.2; SWS_Wind = [2, 0, true]; SWS_Rain = 0; SWS_Waves = 0;};
					if(SWS_WMod == 8) then {SWS_Fog = [0,0,0]; SWS_Overcast = 0.2; SWS_Wind = [0, 2, true]; SWS_Rain = 0; SWS_Waves = 0;};
					if(SWS_WMod == 9) then {SWS_Fog = [0,0,0]; SWS_Overcast = 0.2; SWS_Wind = [1, 1, true]; SWS_Rain = 0; SWS_Waves = 0;};
				};

				if(SWS_ChanceN >=71 && SWS_ChanceN <= 100) then
				{
					SWS_RainCounter = 1;
					SWS_WMod = round(random 2);
					if(SWS_WMod == 0) then {SWS_Fog = [0,0,0]; SWS_Overcast = 0.2; SWS_Wind = [2, 0, true]; SWS_Rain = 0; SWS_Waves = 0;};
					if(SWS_WMod == 1) then {SWS_Fog = [0,0,0]; SWS_Overcast = 0.1; SWS_Wind = [0, 2, true]; SWS_Rain = 0; SWS_Waves = 0;};
					if(SWS_WMod == 2) then {SWS_Fog = [0,0,0]; SWS_Overcast = 0;   SWS_Wind = [0, 0, true]; SWS_Rain = 0; SWS_Waves = 0;};					
				};
				Diag_log format ["::::::: Simple Weather Script ::::::: SWS_ChanceN = %1 ::: SWS_WMod = %2",SWS_ChanceN, SWS_WMod];
				publicVariable "SWS_Fog";
				publicVariable "SWS_Waves";
				publicVariable "SWS_Overcast";
				publicVariable "SWS_Wind";
				publicVariable "SWS_Rain";
			};
	};

	if(isDedicated)then
	{
		while{true}do
		{
			[] call _fnc_SWS_Weather;
			60 setfog (SWS_Fog);
			15 setOvercast (SWS_Overcast);
			setWind (SWS_Wind);
			60 setWaves (SWS_Waves);
			60 setRain (SWS_Rain);			

			sleep 1800;
		};
	};

	if (!isDedicated) then
	{
		while{true}do
		{
			60 setfog (SWS_Fog);
			15 setOvercast (SWS_Overcast);
			setWind (SWS_Wind);
			60 setWaves (SWS_Waves);
			60 setRain (SWS_Rain);		
			//hint format ["::::::: Simple Weather Script ::::::: SWS_ChanceN = %1 ::: SWS_WMod = %2",SWS_ChanceN, SWS_WMod];
			uiSleep 120;
		};
	};