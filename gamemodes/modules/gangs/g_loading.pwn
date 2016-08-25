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
*	gang module: loading.pwn
*
*/

hook OnGameModeInit() {
	mysql_tquery(handle_id, "SELECT * FROM gangs", "Gang_RetrieveInitRowData", "");
}

forward Gang_RetrieveInitRowData();
public Gang_RetrieveInitRowData() {

	new
		_active;

	for(new i = 0, j = cache_get_row_count(); i < j; i++) {

		if(BitFlag_Get(GangFlags[i], egf_Active))

		_active = cache_get_row_int(i, 7);
		if(_active) {

			BitFlag_On(GangFlags[i], egf_Active);
		}
		else {

			BitFlag_Off(GangFlags[i], egf_Active);
		}

		if(_active) {

			BitFlag_On(GangFlags[i], egf_Exists);

			Gang[i][egd_ID] = cache_get_row_int(i, 0);
			Gang[i][egd_LeaderID] = cache_get_row_int(i, 1);
			cache_get_row(i, 2, Gang[i][egd_Name], handle_id, MAX_GANG_NAME);
			Gang[i][egd_Members] = cache_get_row_int(i, 3);
			Gang[i][egd_HQX] = cache_get_row_float(i, 4);
			Gang[i][egd_HQY] = cache_get_row_float(i, 5);
			Gang[i][egd_HQZ] = cache_get_row_float(i, 6);
		}
	}
	return true;
}
