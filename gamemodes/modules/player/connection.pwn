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

#include <YSI\y_hooks>

/*
*
*	player module: connection.pwn
*
*/

hook OnPlayerConnect(playerid) {

	// Resetting all player variables is vital to avoid data corruption
	Player_ResetVariables(playerid);
	Player_ResetBitFlags(playerid);

	Player_Init(playerid);
	return true;
}

Player_ResetVariables(playerid) {

	Player[playerid] = ResetPlayer;

	GetPlayerName(playerid, Player[playerid][epd_Username], MAX_PLAYER_NAME);
	GetPlayerIp(playerid, Player[playerid][epd_IP], MAX_PLAYER_IP);
}

Player_ResetBitFlags(playerid) {

	PlayerFlags[playerid] = E_PLAYER_FLAGS:0;
}

Player_Init(playerid) {

	TogglePlayerSpectating(playerid, true);
	Player_RetrieveInitRow(playerid);
}

Player_RetrieveInitRow(playerid) {

	new
		query[128];
	mysql_format(handle_id, query, sizeof(query), "SELECT ID, Password FROM players WHERE Username = '%e' LIMIT 1", Player[playerid][epd_Username]);
	mysql_tquery(handle_id, query, "Player_RetrieveInitRowData");
}

forward Player_RetrieveInitRowData(playerid);
public Player_RetrieveInitRowData(playerid) {

	if(cache_get_row_count() > 0) {

		Player[playerid][epd_ID] = cache_get_row_int(0, 0);
		cache_get_row(0, 1, Player[playerid][epd_Password], handle_id, MAX_PLAYER_PASSWORD);
		cache_get_row(0, 2, Player[playerid][epd_Salt], handle_id, MAX_PLAYER_SALT);

		BitFlag_Off(PlayerFlags[playerid], epf_Registered);
		SendTaggedMessageToPlayer(playerid, TYPE_INFO, "Use /login to authenticate this account.");
		// Dialog_Show(playerid, dia_Login, DIALOG_STYLE_PASSWORD, SERVER_NAME" - Login", "Fill in your password below to log in:", "Login", "Quit");
	} 
	else {

		BitFlag_On(PlayerFlags[playerid], epf_Registered);
		SendTaggedMessageToPlayer(playerid, TYPE_INFO, "Use /register to create an account.");
		// Dialog_Show(playerid, dia_Register, DIALOG_STYLE_PASSWORD, SERVER_NAME" - Register", "Fill in your desired password to register:", "Login", "Quit");
	}
	return true;
}

CMD:login(playerid, params[]) {

	if(BitFlag_Get(PlayerFlags[playerid], epf_LoggedIn)) {
		return SendTaggedMessageToPlayer(playerid, TYPE_ERROR, "You are already logged in.");
	}
	if(!BitFlag_Get(PlayerFlags[playerid], epf_Registered)) {
		return SendTaggedMessageToPlayer(playerid, TYPE_ERROR, "You are not registered. Use /register to create an account.");
	}
	
	new
		_password[MAX_PLAYER_PASSWORD];

	if(sscanf(params, "s[65]", _password)) {

		return SendTaggedMessageToPlayer(playerid, TYPE_SYNTAX, "/login <password>");
	}

	new
		hashedPassword[MAX_PLAYER_PASSWORD];

	SHA256_PassHash(_password, Player[playerid][epd_Salt], hashedPassword, sizeof(hashedPassword));

	if(!strcmp(hashedPassword, Player[playerid][epd_Password])) {
		
		new
			query[37];

		mysql_format(handle_id, query, sizeof(query), "SELECT * FROM users WHERE ID = %d", Player[playerid][epd_ID]);
		mysql_tquery(handle_id, query, "Player_LoadAllData", "i", playerid);
	}
	else {

		switch(++Player[playerid][LoginAttempts]) {

			case MAX_LOGIN_ATTEMPTS: {

				KickEx(playerid, "exceeded login attempts");
			}
			default: {

				SendTaggedMessageToPlayer(playerid, TYPE_ERROR, "You have entered an incorrect password (%i/%i).", Player[playerid][LoginAttempts], MAX_LOGIN_ATTEMPTS);
			}
		}
	}
	return true;
}


forward Player_LoadAllData(playerid);
public Player_LoadAllData(playerid) {

	if(cache_get_row_count() > 0) {

		Player[playerid][epd_Admin] = cache_get_row_int(0, 4);

		// Send player to class selection
		BitFlag_On(PlayerFlags[playerid], epf_LoggedIn);

		TogglePlayerSpectating(playerid, false);
		Class_ReturnToSelection(playerid);
	}
	return true;
}

CMD:register(playerid, params[]) {

	if(BitFlag_Get(PlayerFlags[playerid], epf_LoggedIn)) {

		return SendTaggedMessageToPlayer(playerid, TYPE_ERROR, "You are already logged in.");
	}
	if(BitFlag_Get(PlayerFlags[playerid], epf_Registered)) {

		return SendTaggedMessageToPlayer(playerid, TYPE_ERROR, "You are already registered. Use /login to log in.");
	}

	new
		_password[MAX_PLAYER_PASSWORD];

	if(sscanf(params, "s[65]", _password)) {
		
		return SendTaggedMessageToPlayer(playerid, TYPE_SYNTAX, "/register <password>");
	}

	if(!IsValidPassword(_password)) {

		return SendTaggedMessageToPlayer(playerid, TYPE_ERROR, "The password you entered is invalid.");
	}


	new salt[MAX_PLAYER_PASSWORD];
	for(new i; i < MAX_PLAYER_PASSWORD; i++)
	{
		salt[i] = random(79) + 47;
	}

	new
		hashedPassword[MAX_PLAYER_PASSWORD];

	SHA256_PassHash(_password, salt, hashedPassword, sizeof(hashedPassword));

	new
		query[213];

	mysql_format(handle_id, query, sizeof(query), "INSERT INTO players (`IP`, `Password`, `Salt`) VALUES ('%e', '%e', '%e')", Player[playerid][epd_IP], hashedPassword, salt);
	mysql_tquery(handle_id, query, "Player_FinishedRegister", "i", playerid);

	return true;
}

forward Player_FinishedRegister(playerid);
public Player_FinishedRegister(playerid) {

	Player[playerid][epd_ID] = cache_insert_id();

	// Send player to class selection
	BitFlag_On(PlayerFlags[playerid], epf_LoggedIn);

	TogglePlayerSpectating(playerid, false);
	Class_ReturnToSelection(playerid);
	return true;
}

/*
*
*	This should get moved to another module
*
*/

KickEx(playerid, const reason[], kickerid = INVALID_PLAYER_ID) {

	SendTaggedMessageToPlayer(playerid, TYPE_ADMIN, "%p has been kicked by the server by %s, reason: %s", playerid, ((kickerid == INVALID_PLAYER_ID) ? (Server[esd_AutomatedName]) : (Player[kickerid][epd_Username])), reason);
	defer KickPlayer(playerid);
}

timer KickPlayer[200](playerid) {

	Kick(playerid);
}
