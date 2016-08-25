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

CMD:gacceptinvite(playerid) {

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

CMD:gdeclineinvite(playerid) {

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
			Player[playerid][epd_AdjustingGangID] = gang_id;
		}
	}
	if(BitFlag_Get(PlayerFlags[playerid], epf_GangLeader)) {

		Player[playerid][epd_AdjustingGangID] = INVALID_GANG_ID;
	}
	Gang_AdjustMenu(playerid, Player[playerid][epd_AdjustingGangID]);
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


			}
			case 2: { // ONLY FOR GANG MODERATORS: Change gang name


			}
		}
	}
	return true;
}

Dialog:dia_ChangeMaxRanks(playerid, response, listitem, inputtext[]) {

	if(!response) {

		Gang_AdjustMenu(playerid, Player[playerid][epd_AdjustingGangID]);
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

	if(BitFlag_Get(PlayerFlags[playerid], epf_GangLeader) && gang_id == INVALID_GANG_ID) {

		Player[playerid][epd_GangRank] = _ranks;
	}
	else {

		foreach(new i : Player) {

			if(Player[i][epd_GangMember] == gang_id && Player[i][epd_GangRank] == Gang[gang_id][egd_Ranks]) {

				Player[i][epd_GangRank] = _ranks;

				mysql_format(handle_id, query, sizeof(query), "UPDATE players SET GangRank = %d WHERE ID = %d", _ranks, Player[i][epd_ID]);
				mysql_tquery(handle_id, query, "", "");
				break;
			}
		}
	}
	Gang[gang_id][egd_Ranks] = _ranks;

	mysql_format(handle_id, query, sizeof(query), "UPDATE gangs SET Ranks = %d WHERE ID = %d", _ranks, Gang[gang_id][egd_ID]);
	mysql_tquery(handle_id, query, "", "");

	SendTaggedMessageToPlayer(playerid, TYPE_INFO, "You have successfully changed the maximum amount of ranks to %d", _ranks);
	Gang_AdjustMenu(playerid, Player[playerid][epd_AdjustingGangID]);
	return true;
}

Gang_AdjustMenu(playerid, gangid = INVALID_GANG_ID) {

	if(gangid == INVALID_GANG_ID) {

		return Dialog_Show(playerid, dia_AdjustGang, DIALOG_STYLE_LIST, SERVER_NAME" - Adjust your gang", "Change maximum ranks\nChange rank name\n", "Select", "Quit");
	}
	Dialog_Show(playerid, dia_AdjustGang, DIALOG_STYLE_LIST, SERVER_NAME" - Adjust a gang", "Change maximum ranks\nChange rank name\nChange gang name", "Select", "Quit");
}
