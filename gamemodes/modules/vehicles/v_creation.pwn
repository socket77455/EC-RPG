/*
*		East Coast RPG
*
*			Copyright (C) 2016 Andy Sedeyn
*
*			This program is free software: you can redistribute it and/or modify it
*			under the terms of the GNU General Public License as published by the
*			Free Software Foundation, either version 3 of the License, or (at your
*			option) any later version.
*
*			This program is distributed in the hope that it will be useful, but
*			WITHOUT ANY WARRANTY; without even the implied warranty of
*			MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*			See the GNU General Public License for more details.
*
*			You should have received a copy of the GNU General Public License along
*			with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

/*
*
*	vehicle module: creation.pwn
*
*/

// Permanent vehicle
CMD:createvehicle(playerid, params[]) {

	if(Player[playerid][epd_Admin] < 3) {

		return SendTaggedMessageToPlayer(playerid, TYPE_ERROR, "You may not use this command.");
	}

	new
		_model[32],
		_color1,
		_color2;

	if(sscanf(params, "s[32]I(0)I(0)", _model, _color1, _color2)) {

		return SendTaggedMessageToPlayer(playerid, TYPE_SYNTAX, "/createvehicle <vehicleid/partofname> <optional: color1> <optional: color2>");
	}
	if((_model[0] = GetVehicleModelByName(_model)) == 0) {

		return SendTaggedMessageToPlayer(playerid, TYPE_ERROR, "The vehicle you specified is invalid.");
	}

	new
		Float:pX,
		Float:pY,
		Float:pZ,
		Float:pA;

	GetPlayerPos(playerid, pX, pY, pZ);
	GetPlayerFacingAngle(playerid, pA);

	new 
		vehicle_id = CreateDynamicVehicle(playerid, _model[0], _color1, _color2, pX, pY, pZ, pA, false);

	if(vehicle_id == INVALID_VEHICLE_ID) {

		return SendTaggedMessageToPlayer(playerid, TYPE_ERROR, "The server has reached its maximum capacity for vehicles.");
	}
	
	SetPlayerPos(playerid, pX, pY, (pZ + 2));
	SendTaggedMessageToPlayer(playerid, TYPE_INFO, "You have successfully spawned vehicle ID: %d", Vehicle_ReturnReadableID(vehicle_id));
	return true;
}

CreateDynamicVehicle(playerid, model, color1, color2, Float:X, Float:Y, Float:Z, Float:A, temporary) {

	if(color1 == -1) {

		color1 = 0;
	}
	if(color2 == -1) {

		color1 = 0;
	}

	for(new i = 0; i < MAX_VEHICLES; i++) if(!BitFlag_Get(VehicleFlags[i], evf_Exists)) {

		BitFlag_On(VehicleFlags[i], evf_Exists);

		Vehicle[i][evd_OwnerID] = 1; // Database ID of the placeholder account
		Vehicle[i][evd_GangID] = 0;
		
		Vehicle[i][evd_PositionX] = X;
		Vehicle[i][evd_PositionY] = Y;
		Vehicle[i][evd_PositionZ] = Z;
		Vehicle[i][evd_PositionA] = A;
		Vehicle[i][evd_Interior] = GetPlayerInterior(playerid);
		Vehicle[i][evd_VirtualWorld] = GetPlayerVirtualWorld(playerid);

		Vehicle[i][evd_Color1] = color1;
		Vehicle[i][evd_Color2] = color2;

		Vehicle[i][evd_DamagePanels] = 0;
		Vehicle[i][evd_DamageDoors] = 0;
		Vehicle[i][evd_DamageLights] = 0;
		Vehicle[i][evd_DamageTires] = 0;

		Vehicle[i][evd_SessionID] = CreateVehicle(model, X, Y, Z, A, color1, color2, -1);

		if(temporary) {

			BitFlag_On(VehicleFlags[i], evf_Temporary);
		}
		else {

			BitFlag_Off(VehicleFlags[i], evf_Temporary);
			mysql_tquery(handle_id, "INSERT INTO vehicles (Models) VALUES (411)", "Vehicle_InsertData", "i", i);
		}
		return i;
	}
	return INVALID_VEHICLE_ID;
}

// Temporary vehicle
CMD:tempvehicle(playerid, params[]) {

	if(Player[playerid][epd_Admin] < 3) {

		return SendTaggedMessageToPlayer(playerid, TYPE_ERROR, "You may not use this command.");
	}

	new
		_model[32],
		_color1,
		_color2;

	if(sscanf(params, "s[32]I(0)I(0)", _model, _color1, _color2)) {

		return SendTaggedMessageToPlayer(playerid, TYPE_SYNTAX, "/createvehicle <vehicleid/partofname> <optional: color1> <optional: color2>");
	}
	if((_model[0] = GetVehicleModelByName(_model)) == 0) {

		return SendTaggedMessageToPlayer(playerid, TYPE_ERROR, "The vehicle you specified is invalid.");
	}

	new
		Float:pX,
		Float:pY,
		Float:pZ,
		Float:pA;

	GetPlayerPos(playerid, pX, pY, pZ);
	GetPlayerFacingAngle(playerid, pA);

	new 
		vehicle_id = CreateDynamicVehicle(playerid, _model[0], _color1, _color2, pX, pY, pZ, pA, true);

	if(vehicle_id == INVALID_VEHICLE_ID) {

		return SendTaggedMessageToPlayer(playerid, TYPE_ERROR, "The server has reached its maximum capacity for vehicles.");
	}
	
	SetPlayerPos(playerid, pX, pY, (pZ + 2));
	SendTaggedMessageToPlayer(playerid, TYPE_INFO, "You have successfully spawned vehicle ID: %d", Vehicle_ReturnReadableID(vehicle_id));
	return true;
}

