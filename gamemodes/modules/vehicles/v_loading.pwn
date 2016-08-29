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
*	gang module: loading.pwn
*
*/

#include <YSI\y_hooks>

hook OnGameModeInit() {

	mysql_tquery(handle_id, "SELECT * FROM vehicles", "Vehicle_RetrieveInitRowData", "");
}

forward Vehicle_RetrieveInitRowData();
public Vehicle_RetrieveInitRowData() {

	new
		query[55];

	for(new i = 0, j = cache_get_row_count(); i < j; i ++) {

		BitFlag_On(VehicleFlags[i], evf_Exists);

		Vehicle[i][evd_ID] = cache_get_row_int(i, 0);
		Vehicle[i][evd_OwnerID] = cache_get_row_int(i, 1);
		Vehicle[i][evd_GangID] = cache_get_row_int(i, 4);

		Vehicle[i][evd_Health] = cache_get_row_float(i, 5);

		Vehicle[i][SessionID] = i;

		mysql_format(handle_id, query, sizeof(query), "SELECT * FROM vehicles_positions WHERE ID = %d", Vehicle[i][evd_ID]);
		mysql_tquery(handle_id, query, "Vehicle_LoadPosition", "i", i);

		mysql_format(handle_id, query, sizeof(query), "SELECT * FROM vehicles_colors WHERE ID = %d", Vehicle[i][evd_ID]);
		mysql_tquery(handle_id, query, "Vehicle_LoadColors", "i", i);

		mysql_format(handle_id, query, sizeof(query), "SELECT * FROM vehicles_parameters WHERE ID = %d", Vehicle[i][evd_ID]);
		mysql_tquery(handle_id, query, "Vehicle_LoadParamaters", "i", i);

		mysql_format(handle_id, query, sizeof(query), "SELECT * FROM vehicles_damage WHERE ID = %d", Vehicle[i][evd_ID]);
		mysql_tquery(handle_id, query, "Vehicle_LoadDamage", "i", i);
	}
	return true;
}

forward Vehicle_LoadPosition(vehicle_id); 
public Vehicle_LoadPosition(vehicle_id) {

	for(new i = 0, j = cache_get_row_count(); i < j; i ++) {

		Vehicle[vehicle_id][evd_PositionX] = cache_get_row_float(i, 1);
		Vehicle[vehicle_id][evd_PositionY] = cache_get_row_float(i, 2);
		Vehicle[vehicle_id][evd_PositionZ] = cache_get_row_float(i, 3);
		Vehicle[vehicle_id][evd_PositionA] = cache_get_row_float(i, 4);

		Vehicle[vehicle_id][evd_Interior] = cache_get_row_int(i, 5);
		Vehicle[vehicle_id][evd_VirtualWorld] = cache_get_row_int(i, 6);
	}
	return true;
}

forward Vehicle_LoadColors(vehicle_id); 
public Vehicle_LoadColors(vehicle_id) {

	for(new i = 0, j = cache_get_row_count(); i < j; i ++) {

		Vehicle[vehicle_id][evd_Color1] = cache_get_row_int(i, 1);
		Vehicle[vehicle_id][evd_Color2] = cache_get_row_int(i, 2);
	}
	return true;
}

forward Vehicle_LoadParameters(vehicle_id); 
public Vehicle_LoadParameters(vehicle_id) {

	for(new i = 0, j = cache_get_row_count(); i < j; i ++) {

		BitFlag_Set(VehicleFlags[vehicle_id], evf_Engine, cache_get_row_int(i, 1));
		BitFlag_Set(VehicleFlags[vehicle_id], evf_Lights, cache_get_row_int(i, 2));
		BitFlag_Set(VehicleFlags[vehicle_id], evf_Alarm, cache_get_row_int(i, 3));
		BitFlag_Set(VehicleFlags[vehicle_id], evf_Lock, cache_get_row_int(i, 4));
		BitFlag_Set(VehicleFlags[vehicle_id], evf_Hood, cache_get_row_int(i, 5));
		BitFlag_Set(VehicleFlags[vehicle_id], evf_Trunk, cache_get_row_int(i, 6));
		BitFlag_Set(VehicleFlags[vehicle_id], evf_Objective, cache_get_row_int(i, 7));
	}
	return true;
}

forward Vehicle_LoadDamage(vehicle_id); 
public Vehicle_LoadDamage(vehicle_id) {

	for(new i = 0, j = cache_get_row_count(); i < j; i ++) {

		Vehicle[vehicle_id][evd_DamagePanels] = cache_get_row_int(i, 1);
		Vehicle[vehicle_id][evd_DamageDoors] = cache_get_row_int(i, 2);
		Vehicle[vehicle_id][evd_DamageLights] = cache_get_row_int(i, 3);
		Vehicle[vehicle_id][evd_DamageTires] = cache_get_row_int(i, 4);
	}
	return true;
}

/*ConvertIntToBinary(intValue) {

	// Code
}

from pythonds.basic.stack import Stack

def divideBy2(decNumber):
    remstack = Stack()

    while decNumber > 0:
        rem = decNumber % 2
        remstack.push(rem)
        decNumber = decNumber // 2

    binString = ""
    while not remstack.isEmpty():
        binString = binString + str(remstack.pop())

    return binString

print(divideBy2(2))*/


