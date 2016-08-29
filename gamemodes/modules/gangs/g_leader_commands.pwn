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
*	gang module: leader_commands.pwn
*
*/

CMD:ganghelp(playerid) {

	SendClientMessage(playerid, -1, "-------------| Gang commands |-------------");

	if(BitFlag_Get(PlayerFlags[playerid], epf_GangLeader)) {

		SendClientMessage(playerid, -1, "/ginvite, /gkick");
	}
	return true;
}

CMD:ginvite(playerid, params[]) {

	if(!BitFlag_Get(PlayerFlags[playerid], epf_GangLeader)) {

		return SendTaggedMessageToPlayer(playerid, TYPE_ERROR, "You may not use this command.");
	}

	new
		tID;

	if(sscanf(params, "u", tID)) {

		return SendTaggedMessageToPlayer(playerid, TYPE_SYNTAX, "/ginvite <playerid/partofname>");
	}
	if(tID == INVALID_PLAYER_ID) {

		return SendTaggedMessageToPlayer(playerid, TYPE_ERROR, "The player you specified is invalid.");
	}
	if(Player[tID][epd_GangMember] != INVALID_GANG_ID) {

		return SendTaggedMessageToPlayer(playerid, TYPE_ERROR, "The player you specified is already in a gang.");
	}

	new
		gang_id = Player[playerid][epd_GangMember];

	SendTaggedMessageToPlayer(playerid, TYPE_SERVER, "You have been invited to %s (ID: %d) by %p (ID: %d).", Gang[gang_id][egd_Name], ReturnActualGangID(gang_id), playerid, playerid);
	SendTaggedMessageToPlayer(tID, TYPE_INFO, "You have successfully invited %p (ID: %d).", tID, tID);

	Gang_InvitePlayer(tID, playerid, gang_id);
	return true;
}

ReturnActualGangID(gang_id) {
	
	return (gang_id + 1);
}

Gang_InvitePlayer(playerid, inviter, gang_id) {

	BitFlag_On(PlayerFlags[playerid], epf_InvitedToGang);
	Player[playerid][epd_InvitedToGangID] = gang_id;
	Player[playerid][epd_InviterOfTheGang] = inviter;

	SendTaggedMessageToPlayer(playerid, TYPE_INFO, "To accept the invitation, use /acceptinvite. To decline the invitation, use /declineinvite.");
}

CMD:acceptinvite(playerid) {

	if(!BitFlag_Get(PlayerFlags[playerid], epf_InvitedToGang)) {

		return SendTaggedMessageToPlayer(playerid, TYPE_ERROR, "You have not been invited.");
	}

	new
		gang_id = Player[playerid][epd_InvitedToGangID];

	Player[playerid][epd_GangMember] = gang_id;
	Player[playerid][epd_GangRank] = 1;

	new
		query[70];

	mysql_format(handle_id, query, sizeof(query), "UPDATE players SET GangID = %d, GangRank = %d WHERE ID = %d", gang_id, Player[playerid][epd_GangRank], Player[playerid][epd_ID]);
	mysql_tquery(handle_id, query, "", "");

	SendTaggedMessageToPlayer(Player[playerid][epd_InviterOfTheGang], TYPE_INFO, "%p (ID: %d) has accepted your invitation to join %s (ID: %d).", playerid, playerid, Gang[gang_id][egd_Name], ReturnActualGangID(gang_id));
	SendTaggedMessageToPlayer(playerid, TYPE_INFO, "You have successfully accepted the invitation to join %s (ID: %d).", Gang[gang_id][egd_Name], ReturnActualGangID(gang_id));
	
	BitFlag_Off(PlayerFlags[playerid], epf_InvitedToGang);
	return true;
}

CMD:declineinvite(playerid) {

	if(!BitFlag_Get(PlayerFlags[playerid], epf_InvitedToGang)) {

		return SendTaggedMessageToPlayer(playerid, TYPE_ERROR, "You have not been invited.");
	}

	new
		gang_id = Player[playerid][epd_InvitedToGangID];

	SendTaggedMessageToPlayer(Player[playerid][epd_InviterOfTheGang], TYPE_INFO, "%p (ID: %d) has declined your invitation to join %s (ID: %d).", playerid, playerid, Gang[gang_id][egd_Name], ReturnActualGangID(gang_id));
	SendTaggedMessageToPlayer(playerid, TYPE_INFO, "You have successfully declined the invitation to join %s (ID: %d).", Gang[gang_id][egd_Name], ReturnActualGangID(gang_id));

	BitFlag_Off(PlayerFlags[playerid], epf_InvitedToGang);
	return true;
}

CMD:gkick(playerid, params[]) {

	if(!BitFlag_Get(PlayerFlags[playerid], epf_GangLeader) && !BitFlag_Get(PlayerFlags[playerid], epf_GangModerator)) {

		return SendTaggedMessageToPlayer(playerid, TYPE_ERROR, "You may not use this command.");
	}

	new
		tID,
		_gangid;

	if(sscanf(params, "uI(65535)", tID, _gangid)) {

		if(BitFlag_Get(PlayerFlags[playerid], epf_GangLeader)) {

			return SendTaggedMessageToPlayer(playerid, TYPE_SYNTAX, "/gkick <playerid/partofname>");
		}
		if(BitFlag_Get(PlayerFlags[playerid], epf_GangModerator)) {

			return SendTaggedMessageToPlayer(playerid, TYPE_SYNTAX, "/gkick <playerid/partofname> <gangid>");
		}
	}
	if(tID == INVALID_PLAYER_ID) {

		return SendTaggedMessageToPlayer(playerid, TYPE_ERROR, "The player you specified is invalid.");
	}
	if(Player[tID][epd_GangMember] != Player[playerid][epd_GangMember]) {

		return SendTaggedMessageToPlayer(playerid, TYPE_ERROR, "The player you specified is not in the same gang as you.");
	}
	if(_gangid != INVALID_GANG_ID && !BitFlag_Get(PlayerFlags[playerid], epf_GangModerator)) {

		return SendTaggedMessageToPlayer(playerid, TYPE_ERROR, "You can't use this parameter.");
	}
	if(tID == playerid) {

		SendTaggedMessageToPlayer(playerid, TYPE_ERROR, "You can't kick yourself.");
		if(BitFlag_Get(PlayerFlags[playerid], epf_GangLeader)) {

			SendTaggedMessageToPlayer(playerid, TYPE_INFO, "You can use /gleave instead.");
		}
		return true;
	}

	new
		gang_id = Player[tID][epd_GangMember];

	SendTaggedMessageToPlayer(tID, TYPE_INFO, "You have been kicked by %p (ID: %d) from %s (ID: %d).", playerid, playerid, Gang[gang_id][egd_Name], ReturnActualGangID(gang_id));
	SendTaggedMessageToPlayer(playerid, TYPE_INFO, "You have successfully kicked %p (ID: %d) from %s (ID: %d).", tID, tID, Gang[gang_id][egd_Name], ReturnActualGangID(gang_id));

	Player[tID][epd_GangMember] = INVALID_GANG_ID;
	Player[tID][epd_GangRank] = 0;

	new
		query[70];

	mysql_format(handle_id, query, sizeof(query), "UPDATE players SET GangID = %d, GangRank = 0 WHERE ID = %d", INVALID_GANG_ID, Player[tID][epd_ID]);
	mysql_tquery(handle_id, query, "", "");
	return true;
}

CMD:adjustgang(playerid, params[]) {

	if(!BitFlag_Get(PlayerFlags[playerid], epf_GangLeader) && !BitFlag_Get(PlayerFlags[playerid], epf_GangModerator)) {

		return SendTaggedMessageToPlayer(playerid, TYPE_ERROR, "You may not use this command.");
	}
	BitFlag_Off(PlayerFlags[playerid], epf_EditingOtherGang);
	if(BitFlag_Get(PlayerFlags[playerid], epf_GangModerator)) {

		new
			gangid;

		if(sscanf(params, "I(65535)", gangid)) {

			return SendTaggedMessageToPlayer(playerid, TYPE_SYNTAX, "/adjustgang <gangid>");
		}

		new
			gang_id = (gangid - 1);

		if(gang_id != INVALID_GANG_ID) {

			if(!Gang_Exists(gang_id)) {

				return SendTaggedMessageToPlayer(playerid, TYPE_ERROR, "The gang you entered is invalid.");
			}
			BitFlag_On(PlayerFlags[playerid], epf_EditingOtherGang);
			Player[playerid][epd_AdjustingGangID] = gang_id;
		}
	}
	if(BitFlag_Get(PlayerFlags[playerid], epf_GangLeader)) {

		BitFlag_Off(PlayerFlags[playerid], epf_EditingOtherGang);
		Player[playerid][epd_AdjustingGangID] = Player[playerid][epd_GangMember];
	}
	Gang_AdjustMenu(playerid);
	return true;
}

Dialog:dia_AdjustGang(playerid, response, listitem, inputtext[]) {

	if(response) {

		new
			gang_id = Player[playerid][epd_AdjustingGangID];

		switch(listitem) {

			case 0: { // Change maximum ranks

				Dialog_Show(playerid, dia_ChangeMaxRanks, DIALOG_STYLE_INPUT, SERVER_NAME" - Adjust maximum ranks", "Enter how many ranks your gang should have (max: %d):", "Continue", "Back", MAX_GANG_RANKS);
			}
			case 1: { // Change rank name

				Gang_Query_LoadAllRanks(playerid, gang_id);
			}
			case 2: { // ONLY FOR GANG MODERATORS: Change gang name

				Dialog_Show(playerid, dia_ChangeGangName, DIALOG_STYLE_INPUT, SERVER_NAME" - Adjust gang name", "Enter the new gang name:", "Continue", "Back");
			}
		}
	}
	return true;
}

Dialog:dia_ChangeMaxRanks(playerid, response, listitem, inputtext[]) {

	/*
	*
	*	- If the player is a moderator and a gang leader and he is editing his own gang:
	*		* Set his rank
	*		* Save the data
	*
	*	- If the player is just a gang leader, gang_id will automatically be equal to INVALID_GANG_ID:
	*		* Set his rank
	*		* Save the data
	*
	*	- If the player is a gang moderator and he is editing someone else's gang:
	*		* If the leader is online:
	*			- Set his rank
	*			- Save his data
	*
	*		* else:
	*			- Save his data using [egd_LeaderID]
	*
	*/

	if(!response) {

		Gang_AdjustMenu(playerid);
	}
	new
		_ranks = strval(inputtext);

	if(_ranks > MAX_GANG_RANKS) {

		SendTaggedMessageToPlayer(playerid, TYPE_ERROR, "The amount of ranks you entered is out of bounds.");
		return Dialog_Show(playerid, dia_ChangeMaxRanks, DIALOG_STYLE_INPUT, SERVER_NAME" - Adjust maximum ranks", "Enter how many ranks your gang should have (max: %d):", "Continue", "Back", MAX_GANG_RANKS);
	}
	new
		gang_id = (Player[playerid][epd_AdjustingGangID] != INVALID_GANG_ID) ? (Player[playerid][epd_AdjustingGangID]) : (Player[playerid][epd_GangMember]),
		query[50];

	if(BitFlag_Get(PlayerFlags[playerid], epf_GangLeader) && !BitFlag_Get(PlayerFlags[playerid], epf_EditingOtherGang)) {

		Player[playerid][epd_GangRank] = _ranks;
		mysql_format(handle_id, query, sizeof(query), "UPDATE players SET GangRank = %d WHERE ID = %d", _ranks, Player[playerid][epd_ID]);
		mysql_tquery(handle_id, query, "", "");
	}
	else {

		new
			bool:_online = false;

		foreach(new i : Player) {

			if(Player[i][epd_GangMember] == gang_id && Player[i][epd_GangRank] == Gang[gang_id][egd_Ranks]) {

				Player[i][epd_GangRank] = _ranks;

				mysql_format(handle_id, query, sizeof(query), "UPDATE players SET GangRank = %d WHERE ID = %d", _ranks, Player[i][epd_ID]);
				mysql_tquery(handle_id, query, "", "");

				_online = true;
				break;
			}
		}
		if(!_online) {

			mysql_format(handle_id, query, sizeof(query), "UPDATE players SET GangRank = %d WHERE ID = %d", _ranks, Gang[gang_id][egd_LeaderID]);
			mysql_tquery(handle_id, query, "", "");
		}
	}
	
	if(_ranks < Gang[gang_id][egd_Ranks]) {

		mysql_format(handle_id, query, sizeof(query), "DELETE FROM gangs_ranks WHERE RankID > %d", _ranks);
		mysql_tquery(handle_id, query, "", "");
	}
	else {

		for(new i = (Gang[gang_id][egd_Ranks] + 1), j = _ranks; i <= j; i++) {

			mysql_format(handle_id, query, sizeof(query), "INSERT INTO gangs_ranks (`ID`, `RankID`, `RankName`) VALUES (%d, %d, 'placeholder_name')", Gang[gang_id][egd_ID], i);
			mysql_tquery(handle_id, query, "", "");
		}
	}
	Gang[gang_id][egd_Ranks] = _ranks;

	mysql_format(handle_id, query, sizeof(query), "UPDATE gangs SET Ranks = %d WHERE ID = %d", _ranks, Gang[gang_id][egd_ID]);
	mysql_tquery(handle_id, query, "", "");

	SendTaggedMessageToPlayer(playerid, TYPE_INFO, "You have successfully changed the maximum amount of ranks to %d", _ranks);
	Gang_AdjustMenu(playerid);
	return true;
}

Gang_Query_LoadAllRanks(playerid, gang_id) {

	new
		query[42];

	mysql_format(handle_id, query, sizeof(query), "SELECT * FROM gangs_ranks WHERE ID = %d", Gang[gang_id][egd_ID]);
	mysql_tquery(handle_id, query, "Gang_LoadAllRanks", "ii", playerid, gang_id);
	return true;
}

forward Gang_LoadAllRanks(playerid, gang_id);
public Gang_LoadAllRanks(playerid, gang_id) {

	new
		rankList[(39 * MAX_GANG_RANKS)],
		formattedString[39],
		rankid,
		rankname[MAX_GANG_RANK_NAME];

	strcat(rankList, "Rank ID\tRank Name\n");
	for(new i = 0, j = cache_get_row_count(); i < j; i ++) {

		rankid = cache_get_row_int(i, 1);
		cache_get_row(i, 2, rankname, handle_id, MAX_GANG_RANK_NAME);

		format(formattedString, sizeof(formattedString), "%d\t%s\n", rankid, rankname);
		strcat(rankList, formattedString);
	}
	return Dialog_Show(playerid, dia_ChangeRankName, DIALOG_STYLE_TABLIST_HEADERS, SERVER_NAME" - Adjust rank names", rankList, "Select", "Back");
}

Dialog:dia_ChangeRankName(playerid, response, listitem, inputtext[]) {

	if(!response) {

		return Gang_AdjustMenu(playerid);
	}
	if(!strlen(inputtext)) {
		SendTaggedMessageToPlayer(playerid, TYPE_ERROR, "You have to enter a rank name.");
		return Gang_Query_LoadAllRanks(playerid, Player[playerid][epd_AdjustingGangID]);
	}
	if(IsCompletelyNumeric(inputtext)) {

		SendTaggedMessageToPlayer(playerid, TYPE_ERROR, "The rank name should not have more digits than letters.");
		return Gang_Query_LoadAllRanks(playerid, Player[playerid][epd_AdjustingGangID]);
	}

	new
		gang_id = Player[playerid][epd_AdjustingGangID];

	// Player[playerid][epd_EditingRank] = listitem;

	format(GangRank[gang_id][listitem][egrd_RankName], MAX_GANG_RANK_NAME, "%s", inputtext);

	new
		query[110];

	mysql_format(handle_id, query, sizeof(query), "UPDATE gangs_ranks SET RankName = '%e' WHERE ID = %d", GangRank[gang_id][listitem][egrd_RankName], Gang[gang_id][egd_ID]);
	mysql_tquery(handle_id, query, "", "");

	SendTaggedMessageToPlayer(playerid, TYPE_INFO, "You have successfully changed rank ID (%d)'s name to %s.", listitem, GangRank[gang_id][listitem][egrd_RankName]);
	Gang_Query_LoadAllRanks(playerid, Player[playerid][epd_AdjustingGangID]);
	return true;
}

Dialog:dia_ChangeGangName(playerid, response, listitem, inputtext[]) {

	if(!response) {

		return Gang_AdjustMenu(playerid);
	}
	if(!strlen(inputtext)) {
		SendTaggedMessageToPlayer(playerid, TYPE_ERROR, "You have to enter a gang name.");
		return Dialog_Show(playerid, dia_ChangeGangName, DIALOG_STYLE_INPUT, SERVER_NAME" - Adjust gang name", "Enter the new gang name:", "Continue", "Back");
	}
	if(IsCompletelyNumeric(inputtext)) {

		SendTaggedMessageToPlayer(playerid, TYPE_ERROR, "The gang name should not have more digits than letters.");
		return Dialog_Show(playerid, dia_ChangeGangName, DIALOG_STYLE_INPUT, SERVER_NAME" - Adjust gang name", "Enter the new gang name:", "Continue", "Back");
	}

	new
		gang_id = Player[playerid][epd_AdjustingGangID];

	format(Gang[gang_id][egd_Name], MAX_GANG_NAME, "%s", inputtext);

	new
		query[95];

	mysql_format(handle_id, query, sizeof(query), "UPDATE gangs SET Name = '%e' WHERE ID = %d", Gang[gang_id][egd_Name], Gang[gang_id][egd_ID]);
	mysql_tquery(handle_id, query, "", "");

	SendTaggedMessageToPlayer(playerid, TYPE_INFO, "You have successfully changed the name of gang ID %d to %s.", ReturnActualGangID(gang_id), Gang[gang_id][egd_Name]);
	return true;
}

Gang_AdjustMenu(playerid) {

	if(!BitFlag_Get(PlayerFlags[playerid], epf_EditingOtherGang)) {

		return Dialog_Show(playerid, dia_AdjustGang, DIALOG_STYLE_LIST, SERVER_NAME" - Adjust your gang", "Change maximum ranks\nChange rank name\n", "Select", "Quit");
	}
	return Dialog_Show(playerid, dia_AdjustGang, DIALOG_STYLE_LIST, SERVER_NAME" - Adjust a gang", "Change maximum ranks\nChange rank name\nChange gang name", "Select", "Quit");
}
