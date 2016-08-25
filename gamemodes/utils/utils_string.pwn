#include <YSI\y_va>

// Credits go to Southclaw - https://github.com/Southclaw/ScavengeSurvive/blob/master/gamemodes/SS/utils/message.pwn
// Rewritten by Andy Sedeyn - for-loop optimization and extra functions for the gamemode that it is used for

/*
*
*		Utils: string manipulation
*
*/

static stock
	formatex_string[256];

stock va_formatex(output[], size = sizeof(output), const fmat[], va_:STATIC_ARGS)
{
	new
		num_args,
		arg_start,
		arg_end;

	// Get the pointer to the number of arguments to the last function.
	#emit LOAD.S.pri 0
	#emit ADD.C 8
	#emit MOVE.alt
	// Get the number of arguments.
	#emit LOAD.I
	#emit STOR.S.pri num_args
	// Get the variable arguments (end).
	#emit ADD
	#emit STOR.S.pri arg_end
	// Get the variable arguments (start).
	#emit LOAD.S.pri STATIC_ARGS
	#emit SMUL.C 4
	#emit ADD
	#emit STOR.S.pri arg_start
	// Using an assembly loop here screwed the code up as the labels added some
	// odd stack/frame manipulation code...
	while (arg_end != arg_start)
	{
		#emit MOVE.pri
		#emit LOAD.I
		#emit PUSH.pri
		#emit CONST.pri 4
		#emit SUB.alt
		#emit STOR.S.pri arg_end
	}
	// Push the additional parameters.
	#emit PUSH.S fmat
	#emit PUSH.S size
	#emit PUSH.S output
	// Push the argument count.
	#emit LOAD.S.pri num_args
	#emit ADD.C 12
	#emit LOAD.S.alt STATIC_ARGS
	#emit XCHG
	#emit SMUL.C 4
	#emit SUB.alt
	#emit PUSH.pri
	#emit MOVE.alt
	// Push the return address.
	#emit LCTRL 6
	#emit ADD.C 28
	#emit PUSH.pri
	// Call formatex
	#emit CONST.pri formatex
	#emit SCTRL 6
}

/*

	These functions split strings when their size reaches 114 characters.

*/


SendMessageToPlayer(playerid, colour, string[]) {

	if(strlen(string) > 114) {

		new
			sstring[144];

		format(sstring, sizeof(sstring), "%.114s ...", string);
		SendClientMessage(playerid, colour, sstring);
		format(sstring, sizeof(sstring), "... %s", string[114]);
		SendClientMessage(playerid, colour, sstring);
	}
	else {

		SendClientMessage(playerid, colour, string);
	}
	return true;
}

SendMessageToAll(colour, string[]) {

	if(strlen(string) > 114) {

		new
			sstring[144];

		format(sstring, sizeof(sstring), "%.114s ...", string);
		SendClientMessageToAll(colour, sstring);
		format(sstring, sizeof(sstring), "... %s", string[114]);
		SendClientMessageToAll(colour, sstring);
	}
	else {

		SendClientMessageToAll(colour, string);
	}
	return true;
}

SendFormattedMessageToPlayer(playerid, colour, fmat[], va_args<>) {

	va_formatex(formatex_string, sizeof(formatex_string), fmat, va_start<3>);
	SendMessageToPlayer(playerid, colour, formatex_string);
	return true;
}

SendFormattedMessageToAll(colour, fmat[], va_args<>) {

	va_formatex(formatex_string, sizeof(formatex_string), fmat, va_start<2>);
	SendMessageToAll(colour, formatex_string);
	return true;
}

SendFormattedMessageToAdmin(level, colour, fmat[], va_args<>) {

	va_formatex(formatex_string, sizeof(formatex_string), fmat, va_start<3>);
	foreach(new i : Player) {

		if(Player[i][AdminLevel] >= level) {

			SendMessageToPlayer(i, colour, formatex_string);
		}
	}
	return true;
}

SendNearbyMessage(playerid, Float:radius, colour, fmat[], va_args<>) {

	va_formatex(formatex_string, sizeof(formatex_string), fmat, va_start<4>);
	foreach(new i : Player) {

		if(IsPlayerNearPlayer(i, playerid, radius)) {

			SendMessageToPlayer(i, colour, formatex_string);
		}
	}
	return true;
}

stock SendVehicleMessage(vehicleid, colour, fmat[], va_args<>) {

	va_formatex(formatex_string, sizeof(formatex_string), fmat, va_start<3>);
	foreach(new i : Player) if(GetPlayerVehicleID(i) == vehicleid) {

		SendMessageToPlayer(i, colour, formatex_string);
	}
	return true;
}

stock SendPoliceRadioMessage(factionid, colour, fmat[], va_args<>) {

	va_formatex(formatex_string, sizeof(formatex_string), fmat, va_start<3>);
	foreach(new i : Player) if(Player[i][Member] == factionid) {

		SendMessageToPlayer(i, colour, formatex_string);
	}
	return true;
}

// This function sends the radio message to other departments
stock SendPoliceRadioMessageToPolice(colour, fmat[], va_args<>) {

	// Send a police radio message to other police factions
	va_formatex(formatex_string, sizeof(formatex_string), fmat, va_start<3>);
	foreach(new i : Player) if(IsAPoliceOfficer(i)) {

		SendMessageToPlayer(i, colour, formatex_string);
	}
	return true;
}

#define TYPE_ERROR      0
#define TYPE_SYNTAX     1
#define TYPE_SERVER     2
#define TYPE_INFO       3
#define TYPE_ADMIN      4
#define TYPE_ALERT      5
#define TYPE_ACHAT      6

SendTaggedMessageToPlayer(playerid, msg_type, fmat[], va_args<>) {

	va_formatex(formatex_string, sizeof(formatex_string), fmat, va_start<3>);
	switch(msg_type) {

		case TYPE_ERROR: {

			SendFormattedMessageToPlayer(playerid, COLOR_WHITE, "* %CError: %C%s", COLOR_GREY, COLOR_WHITE, formatex_string);
		}
		case TYPE_SYNTAX: {

			SendFormattedMessageToPlayer(playerid, COLOR_WHITE, "* %CUsage: %C%s", COLOR_BLUE, COLOR_WHITE, formatex_string);
		}
		case TYPE_SERVER: {

			SendFormattedMessageToPlayer(playerid, COLOR_WHITE, "* %CServer: %C%s", COLOR_ORANGE, COLOR_WHITE, formatex_string);
		}
		case TYPE_INFO: {

			SendFormattedMessageToPlayer(playerid, COLOR_WHITE, "* %CInfo: %C%s", COLOR_GREEN, COLOR_WHITE, formatex_string);
		}
		case TYPE_ADMIN: {

			SendFormattedMessageToPlayer(playerid, COLOR_WHITE, "* %CAdmin: %C%s", COLOR_RED, COLOR_WHITE, formatex_string);
		}
		case TYPE_ALERT: {

			SendFormattedMessageToPlayer(playerid, COLOR_WHITE, "* %C[!]: %C%s", COLOR_RED, COLOR_WHITE, formatex_string);
		}
		case TYPE_ACHAT: {

			SendFormattedMessageToPlayer(playerid, COLOR_G_ACHAT, "* [Admin Chat]: %s", formatex_string);
		}
	}
	return true;
}

SendTaggedMessageToAll(msg_type, fmat[], va_args<>) {

	va_formatex(formatex_string, sizeof(formatex_string), fmat, va_start<2>);
	switch(msg_type) {

		case TYPE_ERROR: {

			SendFormattedMessageToAll(COLOR_WHITE, "* %CError: %C%s", COLOR_GREY, COLOR_WHITE, formatex_string);
		}
		case TYPE_SYNTAX: {

			SendFormattedMessageToAll(COLOR_WHITE, "* %CUsage: %C%s", COLOR_BLUE, COLOR_WHITE, formatex_string);
		}
		case TYPE_SERVER: {

			SendFormattedMessageToAll(COLOR_WHITE, "* %CServer: %C%s", COLOR_ORANGE, COLOR_WHITE, formatex_string);
		}
		case TYPE_INFO: {

			SendFormattedMessageToAll(COLOR_WHITE, "* %CInfo: %C%s", COLOR_GREEN, COLOR_WHITE, formatex_string);
		}
		case TYPE_ADMIN: {

			SendFormattedMessageToAll(COLOR_WHITE, "* %CAdmin: %C%s", COLOR_RED, COLOR_WHITE, formatex_string);
		}
		case TYPE_ALERT: {

			SendFormattedMessageToAll(COLOR_WHITE, "* %C[!]: %C%s", COLOR_RED, COLOR_WHITE, formatex_string);
		}
	}
	return true;
}

stock SendTaggedMessageToAdmins(level, msg_type, fmat[], va_args<>) {

	va_formatex(formatex_string, sizeof(formatex_string), fmat, va_start<3>);
	switch(msg_type) {

		case TYPE_ERROR: {

			SendFormattedMessageToAdmin(level, COLOR_WHITE, "* %CError: %C%s", COLOR_GREY, COLOR_WHITE, formatex_string);
		}
		case TYPE_SYNTAX: {

			SendFormattedMessageToAdmin(level, COLOR_WHITE, "* %CUsage: %C%s", COLOR_BLUE, COLOR_WHITE, formatex_string);
		}
		case TYPE_SERVER: {

			SendFormattedMessageToAdmin(level, COLOR_WHITE, "* %CServer: %C%s", COLOR_ORANGE, COLOR_WHITE, formatex_string);
		}
		case TYPE_INFO: {

			SendFormattedMessageToAdmin(level, COLOR_WHITE, "* %CInfo: %C%s", COLOR_GREEN, COLOR_WHITE, formatex_string);
		}
		case TYPE_ADMIN: {

			SendFormattedMessageToAdmin(level, COLOR_WHITE, "* %CAdmin: %C%s", COLOR_RED, COLOR_WHITE, formatex_string);
		}
		case TYPE_ALERT: {

			SendFormattedMessageToAdmin(level, COLOR_WHITE, "* %C[!]: %C%s", COLOR_RED, COLOR_WHITE, formatex_string);
		}
		case TYPE_ACHAT: {

			SendFormattedMessageToAdmin(level, COLOR_G_ACHAT, "* [Admin Chat]: %s", formatex_string);
		}
	}
	return true;
}

stock IsNumeric(const str[]) {

	for(new i = 0, l = strlen(str); i != l; i ++) {

		if(str[i] >= '0' || str[i] <= '9') {

			return true;
		}
	}
	return false;
}

IsCompletelyNumeric(const str[]) {

	new
		count;

	for(new i = 0, l = strlen(str); i != l; i++) {

		if(str[i] >= '0' || str[i] <= '9') {

			count++;
		}
	}
	if(count > (strlen(str) / 2)) {

		return true;
	}
	return false;
}

IsValidPassword(const password[]) {

	for(new i = strlen(password); --i >= 0 && password[i] != EOS;) {

		switch(password[i]) {

			case '0'..'9', 'A'..'Z', 'a'..'z', '!', '?', ')', '(', '*': continue;
			default: return false;
		}
	}
	return true;
}

randomEx(minnum = cellmin, maxnum = cellmax) {

	return random(maxnum - minnum + 1) + minnum;
}