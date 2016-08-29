/*
*
*		Natives
*
*/

native IsValidVehicle(vehicleid);

/*
*
*		Utilities
*
*/

new const g_arrVehicleNames[][] = {

	{!"Landstalker"		},	{!"Bravura"          }, {!"Buffalo"          }, {!"Linerunner"       },
	{!"Perrenial"        }, {!"Sentinel"         }, {!"Dumper"           }, {!"Firetruck"        },
	{!"Trashmaster"      }, {!"Stretch"          }, {!"Manana"           }, {!"Infernus"         },
	{!"Voodoo"           }, {!"Pony"             }, {!"Mule"             }, {!"Cheetah"          },
	{!"Ambulance"        }, {!"Leviathan"        }, {!"Moonbeam"         }, {!"Esperanto"        },
	{!"Taxi"             }, {!"Washington"       }, {!"Bobcat"           }, {!"Mr Whoopee"       },
	{!"BF Injection"     }, {!"Hunter"           }, {!"Premier"          }, {!"Enforcer"         },
	{!"Securicar"        }, {!"Banshee"          }, {!"Predator"         }, {!"Bus"              },
	{!"Rhino"            }, {!"Barracks"         }, {!"Hotknife"         }, {!"Trailer 1"        },
	{!"Previon"          }, {!"Coach"            }, {!"Cabbie"           }, {!"Stallion"         },
	{!"Rumpo"            }, {!"RC Bandit"        }, {!"Romero"           }, {!"Packer"           },
	{!"Monster"          }, {!"Admiral"          }, {!"Squalo"           }, {!"Seasparrow"       },
	{!"Pizzaboy"         }, {!"Tram"             }, {!"Trailer 2"        }, {!"Turismo"          },
	{!"Speeder"          }, {!"Reefer"           }, {!"Tropic"           }, {!"Flatbed"          },
	{!"Yankee"           }, {!"Caddy"            }, {!"Solair"           }, {!"Berkley's RC Van" },
	{!"Skimmer"          }, {!"PCJ-600"          }, {!"Faggio"           }, {!"Freeway"          },
	{!"RC Baron"         }, {!"RC Raider"        }, {!"Glendale"         }, {!"Oceanic"          },
	{!"Sanchez"          }, {!"Sparrow"          }, {!"Patriot"          }, {!"Quad"             },
	{!"Coastguard"       }, {!"Dinghy"           }, {!"Hermes"           }, {!"Sabre"            },
	{!"Rustler"          }, {!"ZR-350"           }, {!"Walton"           }, {!"Regina"           },
	{!"Comet"            }, {!"BMX"              }, {!"Burrito"          }, {!"Camper"           },
	{!"Marquis"          }, {!"Baggage"          }, {!"Dozer"            }, {!"Maverick"         },
	{!"News Chopper"     }, {!"Rancher"          }, {!"FBI Rancher"      }, {!"Virgo"            },
	{!"Greenwood"        }, {!"Jetmax"           }, {!"Hotring"          }, {!"Sandking"         },
	{!"Blista Compact"   }, {!"Police Maverick"  }, {!"Boxville"         }, {!"Benson"           },
	{!"Mesa"             }, {!"RC Goblin"        }, {!"Hotring Racer A"  }, {!"Hotring Racer B"  },
	{!"Bloodring Banger" }, {!"Rancher"          }, {!"Super GT"         }, {!"Elegant"          },
	{!"Journey"          }, {!"Bike"             }, {!"Mountain Bike"    }, {!"Beagle"           },
	{!"Cropdust"         }, {!"Stunt"            }, {!"Tanker"           }, {!"Roadtrain"        },
	{!"Nebula"           }, {!"Majestic"         }, {!"Buccaneer"        }, {!"Shamal"           },
	{!"Hydra"            }, {!"FCR-900"          }, {!"NRG-500"          }, {!"HPV1000"          },
	{!"Cement Truck"     }, {!"Tow Truck"        }, {!"Fortune"          }, {!"Cadrona"          },
	{!"FBI Truck"        }, {!"Willard"          }, {!"Forklift"         }, {!"Tractor"          },
	{!"Combine"          }, {!"Feltzer"          }, {!"Remington"        }, {!"Slamvan"          },
	{!"Blade"            }, {!"Freight"          }, {!"Streak"           }, {!"Vortex"           },
	{!"Vincent"          }, {!"Bullet"           }, {!"Clover"           }, {!"Sadler"           },
	{!"Firetruck LA"     }, {!"Hustler"          }, {!"Intruder"         }, {!"Primo"            },
	{!"Cargobob"         }, {!"Tampa"            }, {!"Sunrise"          }, {!"Merit"            },
	{!"Utility"          }, {!"Nevada"           }, {!"Yosemite"         }, {!"Windsor"          },
	{!"Monster A"        }, {!"Monster B"        }, {!"Uranus"           }, {!"Jester"           },
	{!"Sultan"           }, {!"Stratum"          }, {!"Elegy"            }, {!"Raindance"        },
	{!"RC Tiger"         }, {!"Flash"            }, {!"Tahoma"           }, {!"Savanna"          },
	{!"Bandito"          }, {!"Freight Flat"     }, {!"Streak Carriage"  }, {!"Kart"             },
	{!"Mower"            }, {!"Duneride"         }, {!"Sweeper"          }, {!"Broadway"         },
	{!"Tornado"          }, {!"AT-400"           }, {!"DFT-30"           }, {!"Huntley"          },
	{!"Stafford"         }, {!"BF-400"           }, {!"Newsvan"          }, {!"Tug"              },
	{!"Trailer 3"        }, {!"Emperor"          }, {!"Wayfarer"         }, {!"Euros"            },
	{!"Hotdog"           }, {!"Club"             }, {!"Freight Carriage" }, {!"Trailer 3"        },
	{!"Andromada"        }, {!"Dodo"             }, {!"RC Cam"           }, {!"Launch"           },
	{!"Police Car (LSPD)"}, {!"Police Car (SFPD)"}, {!"Police Car (LVPD)"}, {!"Police Ranger"    },
	{!"Picador"          }, {!"S.W.A.T. Van"     }, {!"Alpha"            }, {!"Phoenix"          },
	{!"Glendale"         }, {!"Sadler"           }, {!"Luggage Trailer A"}, {!"Luggage Trailer B"},
	{!"Stair Trailer"    }, {!"Boxville"         }, {!"Farm Plow"        }, {!"Utility Trailer"  }
};

GetVehicleModelID(vehiclename[]) {

	for(new i = 211; --i >= 0;) {

		if(strfind(aVehicleNames[i], vehiclename, true) != -1) {

			return i + 400;
		}
	}
	return -1;
}

GetVehicleModelByName(const name[]) {

	if(IsNumeric(name) && (strval(name) >= 400 && strval(name) <= 611)) {

		return strval(name);
	}

	for(new i = 0; i < sizeof(g_arrVehicleNames); i ++) {

		if(strfind(g_arrVehicleNames[i], name, true) != -1) {

			return i + 400;
		}
	}
	return 0;
}

GetVehicleNameByModelID(modelid) {

	new
		vehicleName[24];

	strunpack(vehicleName, g_arrVehicleNames[modelid - 400], sizeof(vehicleName));
	return vehicleName;
}

IsWindowedVehicle(vehicleid) {

	static const g_aWindowStatus[] = {

		1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
		1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1,
		1, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 1, 0, 1, 1,
		1, 0, 0, 0, 0, 0, 1, 1, 0, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1,
		1, 0, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1,
		1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1,
		1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 1, 0, 1, 1, 0, 0, 0, 0,
		1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
		1, 1, 1, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 0, 1, 1, 1, 1,
		1, 0, 1, 1, 0, 1, 0, 1, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 1, 1,
		1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 0, 0
	};
	new modelid = GetVehicleModel(vehicleid);

	if(modelid < 400 || modelid > 611) {

		return false;
	}
	return (g_aWindowStatus[modelid - 400]);
}

VehicleHasEngine(vehicleid) {

	static const g_aEngineStatus[] = {

		1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
		1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1,
		1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1,
		1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
		1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
		1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1,
		1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1,
		1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
		1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1,
		1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 0, 1, 1, 0, 1, 1, 1, 1, 1,
		1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 0, 0
	};
	new modelid = GetVehicleModel(vehicleid);

	if(modelid < 400 || modelid > 611) {

		return false;
	}
	return (g_aEngineStatus[modelid - 400]);
}

Vehicle_GetMetalAmount(modelid) {

	static const g_aMetalAmount[] = {

		30,				30,					50,					100,
		30,				30,					100,				100,
		100,			80,					30,					50,
		30,				60,					80,					50,
		80,				150,				60,					50,
		30,				30,					60,					80,
		20,				150,				30,					100,
		100,			50,					100,				100,
		500,			100,				50,					0,
		30,				100,				30,					30,
		60,				5,					50,					100,
		100,			30,					100,				150,
		15,				0,					0,					50,
		100,			100,				100,				100,
		100,			20,					30,					60,
		150,			20,					15,					20,
		5,				5,					30,					30,
		20,				150,				50,					20,
		100,			100,				30,					30,
		100,			50,					30,					30,
		30,				10,					60,					60,
		100,			20,					100,				150,
		150,			50,					50,					30,
		30,				100,				50,					50,
		30,				150,				100,				100,
		30,				5,					30,					30,
		30,				50,					50,					30,
		100,			10,					10,					150,
		150,			150,				100,				100,
		30,				30,					30,					150,
		150,			20,					20,					20,
		100,			30,					30,					30,
		50,				30,					20,					20,
		100,			30,					30,					30,
		30,				100,				100,				20,
		30,				50,					30,					30,
		100,			30,					30,					30,
		150,			30,					30,					30,
		60,				150,				30,					30,
		100,			100,				50,					50,
		50,				30,					50,					150,
		5,				30,					30,					30,
		30,				100,				100,				10,
		20,				100,				20,					30,
		30,				150,				100,				50,
		50,				20,					60,					20,
		0,				30,					20,					50,
		80,				30,					100,				0,
		150,			150,				5,					100,
		30,				30,					30,					50,
		30,				100,				50,					50,
		30,				30,					0,					0,
		0,				80,					100,				0
	};
	return g_aMetalAmount[modelid - 400];
}

IsDoorVehicle(vehicleid) {

	switch(GetVehicleModel(vehicleid)) {

		case 400..424, 426..429, 431..440, 442..445, 451, 455, 456, 458, 459, 466, 467, 470, 474, 475: {

			return 1;
		}

		case 477..480, 482, 483, 486, 489, 490..492, 494..496, 498..500, 502..508, 514..518, 524..529, 533..536: {

			return 1;
		}

		case 540..547, 549..552, 554..562, 565..568, 573, 575, 576, 578..580, 582, 585, 587..589, 596..605, 609: {

			return 1;
		}
	}
	return 0;
}

IsPlayerNearBoot(playerid, vehicleid) {

	static
		Float:fX,
		Float:fY,
		Float:fZ;

	GetVehicleBoot(vehicleid, fX, fY, fZ);

	return (GetPlayerVirtualWorld(playerid) == GetVehicleVirtualWorld(vehicleid)) && IsPlayerInRangeOfPoint(playerid, 3.5, fX, fY, fZ);
}

IsPlayerNearHood(playerid, vehicleid) {

	static
		Float:fX,
		Float:fY,
		Float:fZ;

	GetVehicleHood(vehicleid, fX, fY, fZ);

	return (GetPlayerVirtualWorld(playerid) == GetVehicleVirtualWorld(vehicleid)) && IsPlayerInRangeOfPoint(playerid, 3.0, fX, fY, fZ);
}

GetVehicleBoot(vehicleid, &Float:x, &Float:y, &Float:z) {

	if (!GetVehicleModel(vehicleid) || vehicleid == INVALID_VEHICLE_ID)
		return (x = 0.0, y = 0.0, z = 0.0), 0;

	static
		Float:pos[7]
	;
	GetVehicleModelInfo(GetVehicleModel(vehicleid), VEHICLE_MODEL_INFO_SIZE, pos[0], pos[1], pos[2]);
	GetVehiclePos(vehicleid, pos[3], pos[4], pos[5]);
	GetVehicleZAngle(vehicleid, pos[6]);

	x = pos[3] - (floatsqroot(pos[1] + pos[1]) * floatsin(-pos[6], degrees));
	y = pos[4] - (floatsqroot(pos[1] + pos[1]) * floatcos(-pos[6], degrees));
	z = pos[5];

	return 1;
}

GetVehicleHood(vehicleid, &Float:x, &Float:y, &Float:z) {

	if (!GetVehicleModel(vehicleid) || vehicleid == INVALID_VEHICLE_ID)
		return (x = 0.0, y = 0.0, z = 0.0), 0;

	static
		Float:pos[7]
	;
	GetVehicleModelInfo(GetVehicleModel(vehicleid), VEHICLE_MODEL_INFO_SIZE, pos[0], pos[1], pos[2]);
	GetVehiclePos(vehicleid, pos[3], pos[4], pos[5]);
	GetVehicleZAngle(vehicleid, pos[6]);

	x = pos[3] + (floatsqroot(pos[1] + pos[1]) * floatsin(-pos[6], degrees));
	y = pos[4] + (floatsqroot(pos[1] + pos[1]) * floatcos(-pos[6], degrees));
	z = pos[5];

	return 1;
}

IsABoat(vehicleid) {

	switch(GetVehicleModel(vehicleid)) {

		case 430, 446, 452, 453, 454, 472, 473, 484, 493, 595: {

			return true;
		}
	}
	return 0;
}

IsABicycle(vehicleid) {

	switch(GetVehicleModel(vehicleid)) {

		case 481, 509, 510: {

			return true;
		}
	}
	return false;
}

IsABike(vehicleid) {

	switch(GetVehicleModel(vehicleid)) {

		case 448, 461..463, 468, 521..523, 581, 586: {

			return true;
		}
	}
	return false;
}

IsAPlane(vehicleid) {

	switch(GetVehicleModel(vehicleid)) {

		case 460, 464, 476, 511, 512, 513, 519, 520, 553, 577, 592, 593: {

			return true;
		}
	}
	return false;
}

IsAHelicopter(vehicleid) {

	switch(GetVehicleModel(vehicleid)) {

		case 417, 425, 447, 465, 469, 487, 488, 497, 501, 548, 563: {

			return true;
		}
	}
	return false;
}

IsATruck(vehicleid) {

	switch(GetVehicleModel(vehicleid)) {

		case 403, 514, 515: {

			return true;
		}
	}
	return false;
}

/*
//Panels
decode_panels(panels, &front_left_panel, &front_right_panel, &rear_left_panel, &rear_right_panel, &windshield, &front_bumper, &rear_bumper)
{
    front_left_panel = panels & 15;
    front_right_panel = panels >> 4 & 15;
    rear_left_panel = panels >> 8 & 15;
    rear_right_panel = panels >> 12 & 15;
    windshield = panels >> 16 & 15;
    front_bumper = panels >> 20 & 15;
    rear_bumper = panels >> 24 & 15;
}
encode_panels(front_left_panel, front_right_panel, rear_left_panel, rear_right_panel, windshield, front_bumper, rear_bumper)
{
    return front_left_panel | (front_right_panel << 4) | (rear_left_panel << 8) | (rear_right_panel << 12) | (windshield << 16) | (front_bumper << 20) | (rear_bumper << 24);
}
 
//Doors
decode_doors(doors, &bonnet, &boot, &driver_door, &passenger_door)
{
    bonnet = doors & 7;
    boot = doors >> 8 & 7;
    driver_door = doors >> 16 & 7;
    passenger_door = doors >> 24 & 7;
}
encode_doors(bonnet, boot, driver_door, passenger_door)
{
    return bonnet | (boot << 8) | (driver_door << 16) | (passenger_door << 24);
}
 
//Lights
decode_lights(lights, &front_left_light, &front_right_light, &back_lights)
{
    front_left_light = lights & 1;
    front_right_light = lights >> 2 & 1;
    back_lights = lights >> 6 & 1;
}
encode_lights(front_left_light, front_right_light, back_lights)
{
    return front_left_light | (front_right_light << 2) | (back_lights << 6);
}
 
//Tires
decode_tires(tires, &rear_right_tire, &front_right_tire, &rear_left_tire, &front_left_tire)
{
    rear_right_tire = tires & 1;
    front_right_tire = tires >> 1 & 1;
    rear_left_tire = tires >> 2 & 1;
    front_left_tire = tires >> 3 & 1;
}
encode_tires(rear_right_tire, front_right_tire, rear_left_tire, front_left_tire)
{
	return rear_right_tire | (front_right_tire << 1) | (rear_left_tire << 2) | (front_left_tire << 3);
}
*/