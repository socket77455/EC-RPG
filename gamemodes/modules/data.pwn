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

// Usage for all macros: BitFlag_X(variable, flag) - Credits to Slice (http://forum.sa-mp.com/showthread.php?t=216730)
#define BitFlag_Get(%0,%1)            ((%0) & (%1))   // Returns zero (false) if the flag isn't set.
#define BitFlag_On(%0,%1)             ((%0) |= (%1))  // Turn on a flag.
#define BitFlag_Off(%0,%1)            ((%0) &= ~(%1)) // Turn off a flag.
#define BitFlag_Toggle(%0,%1)         ((%0) ^= (%1))  // Toggle a flag (swap true/false).
#define BitFlag_Set(%1,%2,%3)		  if(%3)((%1)|=(%2));else((%1)&=~(%2))

/*
*
*	Server flags & data
*
*/

/*enum E_SERVER_FLAGS:(<<= 1) {

	esf_ChatEnabled = 1
};
new E_SERVER_FLAGS:ServerFlags;*/

enum E_SERVER_DATA {

	// Database
	esd_AutomatedName[MAX_SERVER_AUTOMATED_NAME]
};
new Server[E_SERVER_DATA];

/*
*
*	Player flags & data
*
*/

enum E_PLAYER_FLAGS:(<<= 1) {
	
	epf_LoggedIn = 1,
	epf_Spawned,
	epf_Registered,
	epf_GangModerator,
	epf_GangLeader,
	epf_InvitedToGang,
	epf_EditingOtherGang,

	// Individual rights
	epf_Invite,
	epf_Kick,
	epf_Demote,
	epf_ParkVehicle,
	epf_ChangeName,
	epf_ChangeMaxRanks,
	epf_ChangeRankName
};
new E_PLAYER_FLAGS:PlayerFlags[MAX_PLAYERS];

enum E_PLAYER_DATA {
	
	// Database

		// Essentials
	epd_ID,
	epd_Username[MAX_PLAYER_NAME],
	epd_IP[MAX_PLAYER_IP],
	epd_Password[MAX_PLAYER_PASSWORD],
	epd_Salt[MAX_PLAYER_SALT],

		// Administrative ranks
	epd_Admin,

		// Gang data
	epd_GangMember,
	epd_GangRank,

	// Session
	LoginAttempts,

		// Gang script
	epd_InvitedToGangID,
	epd_InviterOfTheGang,

		// Gang moderation
	epd_AdjustingGangID,
	epd_EditingRank
};
new Player[MAX_PLAYERS][E_PLAYER_DATA];
new ResetPlayer[E_PLAYER_DATA];

/*
*
*	Gang flags & data
*
*/

enum E_GANG_FLAGS:(<<= 1) {
	
	egf_Exists = 1,
	egf_Active
};
new E_GANG_FLAGS:GangFlags[MAX_GANGS];

enum E_GANG_DATA {

	// Database

		// Essentials
	egd_ID,
	egd_LeaderID,
	egd_Name[MAX_GANG_NAME],
	egd_Members,

		// HQ
	Float:egd_HQX,
	Float:egd_HQY,
	Float:egd_HQZ,

	egd_Ranks
};
new Gang[MAX_GANGS][E_GANG_DATA];

enum E_GANG_RANK_DATA {

	egrd_RankID,
	egrd_RankName[MAX_GANG_RANK_NAME]
};
new GangRank[MAX_GANGS][MAX_GANG_RANKS][E_GANG_RANK_DATA];

/*
*
*	Vehicle flags & data
*
*/

enum E_VEHICLE_FLAGS:(<<= 1) {

	evf_Exists = 1,
	evf_Temporary,

	// Parameters
	evf_Engine,
	evf_Lights,
	evf_Alarm,
	evf_Lock,
	evf_Hood,
	evf_Trunk,
	evf_Objective
};
new E_VEHICLE_FLAGS:VehicleFlags[MAX_VEHICLES];

enum E_VEHICLE_DATA {

	// Database

		// Essentials
	evd_ID,
	evd_Model,
	evd_OwnerID,
	// evd_BusinessID,
	evd_GangID,
	// evd_FactionID,

	Float:evd_PositionX,
	Float:evd_PositionY,
	Float:evd_PositionZ,
	Float:evd_PositionA,
	evd_Interior,
	evd_VirtualWorld,

	evd_Color1,
	evd_Color2,

	Float:evd_Health,

	evd_DamagePanels,
	evd_DamageDoors,
	evd_DamageLights,
	evd_DamageTires,

	// Session data
	evd_SessionID
};
new Vehicle[MAX_VEHICLES][E_VEHICLE_DATA];
new ResetVehicle[E_VEHICLE_DATA];

// Enums used solely to avoid ID collisions






