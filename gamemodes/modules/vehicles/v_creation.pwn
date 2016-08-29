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
*	gang module: creation.pwn
*
*/

// Permanent vehicle
CMD:createvehicle(playerid, params[]) {

	if(Player[playerid][epd_Admin] < 3) {

		return SendTaggedMessageToPlayer(playerid, TYPE_ERROR, "You may not use this command.");
	}

	new
		_vehicleParam[32],
		_color1,
		_color2;

	if(sscanf(params, "s[32]I(0)I(0)", _vehicleParam, _color1, _color2)) {

		return SendTaggedMessageToPlayer(playerid, TYPE_SYNTAX, "/createvehicle <vehicleid/partofname> <optional: color1> <optional: color2>");
	}
	if(_vehicle[0] = GetVehicleModelByName(model) == 0) {

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
		_vehicleid = CreateDynamicVehicle(_vehicle[0], _color1, _color2, pX, pY, pZ, pA);

	if(_vehicleid == -1) {

		return SendTaggedMessageToPlayer(playerid, TYPE_ERROR, "The server has reached its maximum amount of vehicles.");
	}

	SetPlayerPos(playerid, pX, pY, (pZ + 2));
	SendTaggedMessageToPlayer(playerid, TYPE_INFO, "You have successfully spawned vehicle ID: %d", ReturnActualVehicleID(_vehicleid));
	return true;
}

// CreateDynamicVehicle

// Temporary vehicle
CMD:tempvehicle(playerid, params[]) {


	return true;
}

