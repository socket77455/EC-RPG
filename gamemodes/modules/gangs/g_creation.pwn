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

CMD:creategang(playerid) {

	if(!BitFlag_Get(PlayerFlags[playerid], epf_GangModerator) && Player[playerid][epd_Admin] < 5) {
		return SendTaggedMessageToPlayer(playerid, TYPE_ERROR, "You may not use this command.");
	}
	Dialog_Show(playerid, dia_GangCreation, DIALOG_STYLE_INPUT, SERVER_NAME" - Gang creation", "Enter your desired gang name:", "Create", "Quit");
	return true;
}

Dialog:dia_GangCreation(playerid, response, listitem, inputtext[]) {

	if(response) {
		
		if(!strlen(inputtext)) {
			SendTaggedMessageToPlayer(playerid, TYPE_ERROR, "You have to enter a gang name.");
			return Dialog_Show(playerid, dia_GangCreation, DIALOG_STYLE_INPUT, SERVER_NAME" - Gang creation", "Enter your desired gang name:", "Create", "Quit");
		}
		if(IsCompletelyNumeric(inputtext)) {

			SendTaggedMessageToPlayer(playerid, TYPE_ERROR, "The gang name should not have more digits than letters.");
			return Dialog_Show(playerid, dia_GangCreation, DIALOG_STYLE_INPUT, SERVER_NAME" - Gang creation", "Enter your desired gang name:", "Create", "Quit");
		}

		new gangid = Gang_GetFreeID();

		if(gangid == -1) {

			return SendTaggedMessageToPlayer(playerid, TYPE_ERROR, "The server has reached the maximum available gangs.");
		}
		format(Gang[gangid][egd_Name], MAX_GANG_NAME, "%s", inputtext);

		new
			query[89];

		mysql_format(handle_id, query, sizeof(query), "INSERT INTO gangs (`Name`) VALUES ('%e')", inputtext);
		mysql_tquery(handle_id, query, "Gang_FinishedCreation", "i", gangid);

		SendTaggedMessageToPlayer(playerid, TYPE_INFO, "You have successfully created gang ID: %d (%s)", gangid, Gang[gangid][egd_Name]);
	}	
	return true;
}

Gang_GetFreeID() {

	for(new i = 0, j = MAX_GANGS; i < j; i++) if(!BitFlag_Get(GangFlags[i], egf_Exists)) {

		return i;
	}
	return -1;
}

forward Gang_FinishedCreation(gangid);
public Gang_FinishedCreation(gangid) {

	Gang[gangid][egd_ID] = cache_insert_id();
	Gang[gangid][egd_LeaderID] = 1;
	Gang[gangid][egd_Members] = 0;

	Gang[gangid][egd_HQX] =
	Gang[gangid][egd_HQY] =
	Gang[gangid][egd_HQZ] = 0.0;

	BitFlag_On(GangFlags[gangid], egf_Active);
	return true;
}
