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
*	vehicle module: deletion.pwn
*
*/

CMD:deletevehicle(playerid, params[]) {

	if(Player[playerid][epd_Admin] < 3) {

		return SendTaggedMessageToPlayer(playerid, TYPE_ERROR, "You may not use this command.");
	}

	new
		_vehicleid;

	if(IsPlayerInAnyVehicle(playerid)) {

		_vehicleid = Vehicle_GetID(GetPlayerVehicleID(playerid));
		Vehicle_Delete(_vehicleid, _:BitFlag_Get(VehicleFlags[Vehicle_ReturnActualID(_vehicleid)], evf_Exists));
	}
	else {

		if(sscanf(params, "i", _vehicleid)) {

			return SendTaggedMessageToPlayer(playerid, TYPE_SYNTAX, "/deletevehicle <vehicleid (when in a vehicle)>");
		}
		if(Vehicle_Exists(Vehicle_ReturnActualID(_vehicleid))) {

			return SendTaggedMessageToPlayer(playerid, TYPE_ERROR, "The vehicle you specified is invalid.");
		}
		Vehicle_Delete(Vehicle_ReturnActualID(_vehicleid), _:BitFlag_Get(VehicleFlags[Vehicle_ReturnActualID(_vehicleid)], evf_Exists));
	}
	return true;
}

Vehicle_Delete(vehicle_id, temporary = false) {

	VehicleFlags[vehicle_id] = E_VEHICLE_FLAGS:0;

	if(!temporary) {
	
		new
			query[38];

		mysql_format(handle_id, query, sizeof(query), "DELETE FROM vehicles WHERE ID = %d", Vehicle[vehicle_id][evd_ID]);
		mysql_tquery(handle_id, query, "", "");
	}
	DestroyVehicle(Vehicle[vehicle_id][evd_SessionID]);

	// This does not allow to set specific values
	Vehicle[vehicle_id] = ResetVehicle;
}

Vehicle_GetID(vehicle_id) {

	for(new i = 0, j = MAX_VEHICLES; i < j; i++) if(BitFlag_Get(VehicleFlags[i], evf_Exists)) {

		if(Vehicle[i][evd_SessionID] == vehicle_id) {

			return i;
		}
	}
	return INVALID_VEHICLE_ID;
}

Vehicle_ReturnActualID(vehicle_id) {

	return vehicle_id--;
}

Vehicle_ReturnReadableID(vehicle_id) {

	/*
	*
	*	Players who don't know why we start counting from 0 in many cases, may not understand having a vehicle with ID 0
	*	This basically increments whatever vehicle_id is and therefor it can never be 0 
	*	Unless vehicle_id is -1, which is unlikely to happen since INVALID_VEHICLE_ID is defined as 65535
	*
	*/
	return Vehicle[vehicle_id][evd_SessionID];
}

Vehicle_Exists(vehicle_id) {

	return _:BitFlag_Get(VehicleFlags[vehicle_id], evf_Exists);
}