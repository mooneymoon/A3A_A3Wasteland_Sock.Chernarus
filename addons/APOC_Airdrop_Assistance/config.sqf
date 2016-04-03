//Configuration for Airdrop Assistance
//Author: Apoc

APOC_AA_coolDownTime = 360; //Expressed in sec

APOC_AA_VehOptions =
[ // ["Menu Text",		ItemClassname,		Price,	"Drop Type"]
["Quadbike",    "C_Quadbike_01_F", 			1500, 	"vehicle"],
["Strider", 		"I_MRAP_03_F", 			    10000, 	"vehicle"]
];

APOC_AA_SupOptions =
[// ["stringItemName", 	"Crate Type for fn_refillBox 	,Price," drop type"]
//["Launchers", 			"mission_USLaunchers", 			35000, "supply"],
//["Assault Rifle", 		"mission_USSpecial", 			35000, "supply"],
//["Sniper Rifles", 		"airdrop_Snipers", 				50000, "supply"],
//["DLC Rifles", 			"airdrop_DLC_Rifles", 			45000, "supply"],
//["DLC LMGs", 			"airdrop_DLC_LMGs", 			45000, "supply"],

//"Menu Text",			"Crate Type", 			"Cost", "drop type"
["Food",				"Land_Sacks_goods_F",	3000, 	"picnic"],
["Water",				"Land_BarrelWater_F",	3000, 	"picnic"]
//["Base Building","Land_Pod_Heli_Transport_04_box_F",7500,"base"]
];
