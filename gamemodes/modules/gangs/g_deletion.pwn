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
*	gang module: deletion.pwn
*
*/

CMD:deletegang(playerid) {

	if(!BitFlag_Get(PlayerFlags[playerid], epf_GangModerator) && Player[playerid][epd_Admin] < 5) {
		
		return SendTaggedMessageToPlayer(playerid, TYPE_ERROR, "You may not use this command.");
	}
	Dialog_Show(playerid, dia_GangDeletion, DIALOG_STYLE_INPUT, SERVER_NAME" - Gang deletion", "Enter gang ID:", "Delete", "Quit");
	return true;
}

Dialog:dia_GangDeletion(playerid, response, listitem, inputtext[]) {

	if(response) {

		if(!strlen(inputtext)) {

			SendTaggedMessageToPlayer(playerid, TYPE_ERROR, "You have to enter a valid gang ID.");
			return Dialog_Show(playerid, dia_GangDeletion, DIALOG_STYLE_INPUT, SERVER_NAME" - Gang deletion", "Enter gang ID:", "Delete", "Quit");
		}
		if(!IsCompletelyNumeric(inputtext)) {

			SendTaggedMessageToPlayer(playerid, TYPE_ERROR, "You have to enter a valid gang ID.");
			return Dialog_Show(playerid, dia_GangDeletion, DIALOG_STYLE_INPUT, SERVER_NAME" - Gang deletion", "Enter gang ID:", "Delete", "Quit");
		}
		if(!Gang_Exists(strval(inputtext))) {

			SendTaggedMessageToPlayer(playerid, TYPE_ERROR, "The gang ID you entered is invalid.");
			return Dialog_Show(playerid, dia_GangDeletion, DIALOG_STYLE_INPUT, SERVER_NAME" - Gang deletion", "Enter gang ID:", "Delete", "Quit");
		}
		
		// Make it so that the player returns to this dialog when cancelling the confirmation.

		Dialog_Show(playerid, dia_DeleteGangConfirm, DIALOG_STYLE_MSGBOX, SERVER_NAME" - Gang deletion", "Are you sure you want to remove gang ID: %d (%s)?", "Delete", "Cancel");
	}
	return true;
}

Gang_Exists(gang_id) {

	return _:BitFlag_Get(GangFlags[gang_id], egf_Exists);
}
