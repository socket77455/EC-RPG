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
*	NOTES:
*
*		- What if a gang moderator abuses his power and gives himself leadership of a certain faction and abuses it in any way?
*
*/

/*
*
*	TO-DO:
*		- Gang moderator command to create gang HQs
*		- Individual rights for gangs/factions
*		- Don't spawn vehicles when the owner hasn't been online for +-7 days
*
*/

#include <a_samp>

/*
*
*	SAMP constants redefinitions
*
*/

#undef MAX_PLAYERS
#define MAX_PLAYERS	50

/*
*
*		Guaranteed first call
*
*/

public OnGameModeInit() {

	GameMode_Initialise();

	#if defined main_OnGameModeInit
		return main_OnGameModeInit();
	#else
		return true;
	#endif
}
#if defined _ALS_OnGameModeInit
	#undef OnGameModeInit
#else
	#define _ALS_OnGameModeInit
#endif
#define OnGameModeInit main_OnGameModeInit
#if defined main_OnGameModeInit
	forward main_OnGameModeInit();
#endif

/*
*
*	Libraries
*
*/

	// YSI includes
#include <YSI\y_timers>		// By Y_Less			(http://forum.sa-mp.com/showthread.php?t=570883)
#include <YSI\y_hooks>		// By Y_Less			(http://forum.sa-mp.com/showthread.php?t=570883)
#include <YSI\y_va>			// By Y_Less			(http://forum.sa-mp.com/showthread.php?t=570883)
#include <YSI\y_iterate>	// By Y_Less			(http://forum.sa-mp.com/showthread.php?t=570883)
#include <YSI\y_bit>		// By Y_Less			()
//#include <YSI\y_commands>	// By Y_Less			(http://forum.sa-mp.com/showthread.php?t=570883)
#include <YSI\y_groups>		// By Y_Less			()		
#include <YSI\y_classes>	// By Y_Less			()

	// Standalone includes
#include <a_mysql>			// By BlueG				(http://forum.sa-mp.com/showthread.php?t=56564)
#include <zcmd>				// By Zeex				()
#include <sscanf2>			// By Y_Less			(http://forum.sa-mp.com/showthread.php?t=570927)
//#include <streamer>			// By Incognito			(http://forum.sa-mp.com/showthread.php?t=102865)
#include <formatex>			// By Slice				(http://forum.sa-mp.com/showthread.php?t=313488)
#include <easyDialog>		// By Emmet_			(http://forum.sa-mp.com/showthread.php?t=475838)
#include <extendedActors>	// By Emmet_			(http://forum.sa-mp.com/showthread.php?t=573504)

/*
*
*	Constant defines
*
*/

	// Macros
#define KEY_HOLDING(%0)				((newkeys & (%0)) == (%0))
#define KEY_RELEASED(%0)			(((newkeys & (%0)) != (%0)) && ((oldkeys & (%0)) == (%0)))
#define KEY_PRESSED(%0)				(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))

	// Max values
#define MAX_PLAYER_PASSWORD			65
#define MAX_PLAYER_SALT				MAX_PLAYER_PASSWORD
#define MAX_PLAYER_IP				16
#define MAX_LOGIN_ATTEMPTS			5
#define MAX_GANGS					10
#define MAX_GANG_NAME				50
#define MAX_GANG_RANKS				10
#define	MAX_GANG_RANK_NAME			32
#define MAX_SERVER_AUTOMATED_NAME	20

	// Invalid values
#define INVALID_GANG_ID				65535

	// Strings
#define SERVER_NAME					"EC-RPG"

	// Hex colours
#define COLOR_POLICE_BLUE 			0x0076FFFF
#define	COLOR_BLUE					0x0097FFFF
#define	COLOR_RED					0xE90002FF
#define	COLOR_GREEN					0x00DE59FF
#define COLOR_G_ACHAT				0x21DD00FF
#define	COLOR_GREY					0x8C8C8CFF
#define	COLOR_WHITE					0xFFFFFFFF
#define	COLOR_BLACK					0x000000FF
#define	COLOR_PURPLE				0x8068FFFF
#define COLOR_ROLEPLAY				0x33CCFFAA
#define COLOR_YELLOW				0xFFFF00AA
#define COLOR_CYAN					0x00FFFFAA
#define COLOR_PINK					0xFF4DFFFF
#define COLOR_ORANGE				0xFFA500FF
#define COLOR_PD_RADIO				0x0EEBEBFF
#define COLOR_GLOBAL_PD_RADIO		0x6AAFEBFF

	// Embedded colours
#define	COL_BLUE					"{0097FF}"
#define	COL_RED						"{E90002}"
#define COL_ORANGE					"{FFAF00}"
#define	COL_GREEN					"{00DE59}"
#define	COL_GREY					"{8C8C8C}"
#define	COL_WHITE					"{FFFFFF}"
#define	COL_BLACK					"{000000}"
#define	COL_PURPLE					"{8068FF}"
#define COL_CYAN					"{00FFFF}"
#define COL_YELLOW					"{FFFF00}"
#define COL_PD_RADIO				"{0EEBEB}"
#define COL_GLOBAL_PD_RADIO			"{6AAFEB}"

/*
*
*	Global variables
*
*/

new
	handle_id;

/*
*
*	Modules
*
*/


// Utility
#include "utils\util_string.pwn"
#include "utils\util_vehicles.pwn"

// Data
#include "modules\data.pwn"

// Player modules
#include "modules\player\connection.pwn"
#include "modules\player\rights.pwn"

// Gang modules
#include "modules\gangs\g_loading.pwn"
#include "modules\gangs\g_leader_commands.pwn"
#include "modules\gangs\g_deletion.pwn"
#include "modules\gangs\g_creation.pwn"

// Vehicle modules
#include "modules\vehicles\v_loading.pwn"
//#include "modules\vehicles\v_commands.pwn"
#include "modules\vehicles\v_creation.pwn"
#include "modules\vehicles\v_deletion.pwn"

GameMode_Initialise() {

	// Eventually retrieve the name from the database
	format(Server[esd_AutomatedName], MAX_SERVER_AUTOMATED_NAME, "The Server");
}
