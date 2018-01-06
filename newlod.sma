#define CS_MAPZONE_BUY 			(1<<0)
#define CS_MAPZONE_BOMBTARGET 		(1<<1)
#define CS_MAPZONE_HOSTAGE_RESCUE 	(1<<2)
#define CS_MAPZONE_ESCAPE		(1<<3)
#define CS_MAPZONE_VIP_SAFETY 		(1<<4)

#define XPBOOSTMONEY 1000
#define VIPPROMONEY 1000
#define STEAMMONEY 1000
new tutOn = true;
new Float:g_Delay[33]
new g_FuelTank[33]
//new popularnosc[33]=0
new resy =0
new rounds=0
new Float:prorasa = 250.0
new isevent_team = 0;
new target_plant = 0
new target_def = 0
new clEvent = 0;
new clEvent1 = 0;
new clEvent2 = 0;
new ducking_t[33] = 0
new was_ducking[33]=0 
#include <amxmodx>
#include <amxmisc>
#include <engine>
#include <fakemeta> 
#include <cstrike>
#include <fun>
#include <fakemeta_util>
#include <hamsandwich>
#include <sqlx>
#include <csx> 
#include <chr_engine>
#include <tutor>
new player_timestamp[33][64];
new player_ran[33] = 0 
new player_mute[33] = 0;
new date_long[33][64]; 
new seria[33] = 0
new player_samelvl[33] = 0;

#define SEC_IP "83.1.164.120"


#define PLUGIN "Lod"
#define VERSION "1.0"
#define AUTHOR "Kajt"
// ----------------------STALE---------------------------------------------------------------------

#define RESTORETIME 30.0	 //How long from server start can players still get their item trasferred (s)
#define MAX 33			 //Max number of valid player entities

//#define CHEAT 1		 //Cheat for testing purposes
#define CS_PLAYER_HEIGHT 72.0
#define GLOBAL_COOLDOWN 0.5
#define TASK_GREET 240
#define TASK_HUD 120
#define TASK_HOOK 360
#define MAX_PLAYERS 32
#define BASE_SPEED 	245.0
#define GLUTON 95841
#define TASK_SAM 54554
#define TASK_SPIDER 54354

//new weapon, clip, ammo
#define x 0
#define y 1
#define z 2

#define TASK_CHARGE 100
#define TASK_NAME 48424
#define TASK_FLASH_LIGHT 81184

#define TASKID_LUSTRO 	1138
#define TASKID_REVIVE 	1237
#define TASKID_RESPAWN 	1338
#define TASKID_MAKEZOMBIE 	2338
#define TASKID_CHECKRE 	13491
#define TASKID_CHECKST 	13310
#define TASKID_ORIGIN 	13211
#define TASKID_SETUSER 	13112

#define pev_zorigin	pev_fuser4
#define seconds(%1) ((1<<12) * (%1))

#define OFFSET_CAN_LONGJUMP    356

#define MAX_FLASH 15		//pojemnosc barejii maga (sekund)
#define IsPlayer(%1) (1 <= %1 <= MAX && is_user_connected(%1))
new g_iZemsta[MAX+1];
new bool:g_bAsysta[MAX+1][MAX+1];
new CsTeams:round_won_by[99]=CS_TEAM_UNASSIGNED;
new CT_mnoznik_expa = 100;
new TT_mnoznik_expa = 100;

new lvl_dif_xp_mnoznik[MAX][MAX]

public recalc_lvl_dif_xp_mnoznik(id){
	if(id>-1 && id<MAX){
		for(new i=0; i<MAX; i++)
		{
			new wylicz = calc_exp_perc(id, i);
			lvl_dif_xp_mnoznik[id][i] = wylicz
		}
		for(new i=0; i<MAX; i++)
		{
			new wylicz = calc_exp_perc(i, id);
			lvl_dif_xp_mnoznik[i][id] = wylicz
		}
	}
}
// ----------------------ZMIENNE-------------------------------------------------------------------
new nazwa_itemu[128]
new Basepath[128]	//Path from Cstrike base directory
new Float:agi=BASE_SPEED
new lastspeed[33] = 0
new highlvl[33] = 0
new zal[33] = 0
new create_used[33] = 0
new round_status
new DemageTake[33]
new DemageTake1[33]
new isevent = 0
new player_diablo[33] =0
new player_she[33] =0
new player_drag[33]=0
new graczy = 0
new adminow = 0
new ended
new SOUND_START[] 	= "items/medshot4.wav"
new SOUND_FINISHED[] 	= "items/smallmedkit2.wav"
new SOUND_FAILED[] 	= "items/medshotno1.wav"
new SOUND_EQUIP[]	= "items/ammopickup2.wav"

new SOUND_kill1[] 	= "frags/dominating.mp3"
new SOUND_kill2[] 	= "frags/ownage.mp3"
new SOUND_kill3[] 	= "frags/headhunter.mp3"
new SOUND_kill4[] 	= "frags/looser.mp3"

enum
{
ICON_HIDE = 0,
ICON_SHOW,
ICON_FLASH
}

new avg_lvl =0 
new avg_lvlTT =0 
new avg_lvlCT =0 
new sum_lvlTT =0 
new sum_lvlCT =0 

new czas = 0
new mierzy = 0
new g_haskit[MAX+1]
new Float:g_revive_delay[MAX+1]
new Float:g_body_origin[MAX+1][3]
new bool:g_wasducking[MAX+1]
new player_b_szarza_time[33] = 1	

new g_msg_bartime
new g_msg_screenfade
new g_msg_statusicon
new g_msg_clcorpse

new cvar_revival_time
new cvar_revival_dis


new attacker
new attacker1
new flashlight[33]
new flashbattery[33]
new flashlight_r
new flashlight_g
new flashlight_b

new planter
new defuser

new map_end = 0

// max clip
stock const maxClip[31] = { -1, 13, -1, 10,  1,  7,  1,  30, 30,  1,  30,  20,  25, 30, 35, 25,  12,  20,
10,  30, 100,  8, 30,  30, 20,  2,  7, 30, 30, -1,  50 };

// max bpammo
stock const maxAmmo[31] = { -1, 52, -1, 90, -1, 32, -1, 100, 90, -1, 120, 100, 100, 90, 90, 90, 100, 100,
30, 120, 200, 32, 90, 120, 60, -1, 35, 90, 90, -1, 100 };
new gmsgDeathMsg
new gmsgStatusText
new gmsgBartimer
new gmsgScoreInfo
new gmsgHealth


new bool:freeze_ended
new gonTimer[33] = 0
new c4state[33]
new c4bombc[33][3] 
new c4fake[33]
new fired[33]
new player_awp_hs[33] = 0
new bool:ghost_check[33] 
new ghosttime[33]
new ghoststate[33]
new respawned[33] 
new czas_regeneracji[33] = 0
new sprite_blood_drop = 0
new ofiara_zabojca[2];
new Float:delay_deathmsg;
new sprite_blood_spray = 0
new sprite_gibs = 0
new sprite_white = 0
new sprite_fire = 0
new sprite_fire2 = 0
new sprite_beam = 0
new sprite_boom = 0
new sprite_line = 0
new sprite_lgt = 0
new sprite_laser = 0
new sprite_ignite = 0
new sprite_ignite2 = 0
new sprite_smoke = 0
new player_b_nieust[33] = 0
new player_b_nieust2[33] = 0
new player_xp[33] = 0		//Holds players experience
new player_lvl[33] = 1			//Holds players level
new player_point[33] = 0		//Holds players level points
new player_item_id[33] = 0	//Items id
new player_item_name[33][128]   //The items name
new player_intelligence[33]
new player_strength[33]
new player_agility[33]
new Float:player_damreduction[33]
new player_dextery[33]
new player_class[33]		
new Float:player_huddelay[33]
new player_vip[33] = 0
new player_sid_pass[33][64]
new player_pass_pass[33][64]
new player_podany_pass_pass[33][34]
new pr_pass_pass[33]
new player_dziewica[33]=0
new player_dziewica_using[33]=0
new player_odpornosc_fire[33]=0
new player_bats[33]=0
new player_udr[33]=0
new player_jonowa[33] = 0


new player_pierscien_plagi[33]=0

new Float:player_timed_speed[33] = 0.0
new Float:player_timed_inv[33] = 0.0
new Float:player_timed_speed_aim[33] = 0.0
new Float:player_timed_mr[33] = 0.0
new Float:player_timed_shield[33] = 0.0

//Item attributes
new ispro[33] = 0	
new player_ruch[33] = 0	
new player_naladowany2[33] = 0	
new player_naladowany[33] = 0	//czy gracz naladowany (wilkolak)
new player_b_skill[33] = 3	//Czy uzyto Skilla
new player_b_vampire[33] = 0	//Vampyric damage
new player_b_damage[33] = 0	//Bonus damage
new player_b_money[33] = 0	//Money bonus
new player_b_gravity[33] = 0 	//Gravity bonus : 1 = best
new player_b_inv[33] = 0 	//Invisibility bonus
new player_b_grenade[33] = 0	//Grenade bonus = 1/chance to kill
new player_b_reduceH[33] = 0	//Reduces player health each round start
new player_b_theif[33] = 0	//Amount of money to steal
new player_b_respawn[33] = 0	//Chance to respawn upon death
new player_b_explode[33] = 0	//Radius to explode upon death
new player_b_heal[33] = 0	//Ammount of hp to heal each 5 second
new player_b_gamble[33] = 0	//Random skill each round : value = vararity
new player_b_blind[33] = 0	//Chance 1/Value to blind the enemy
new player_b_fireshield[33] =0	//Protects against explode and grenade bonus 
new player_b_meekstone[33] = 0	//Ability to lay a fake c4 and detonate 
new player_b_teamheal[33] = 0	//How many hp to heal when shooting a teammate 
new player_b_redirect[33] = 0	//How much damage will the player redirect 
new player_b_fireball[33] = 0	//Ability to shot off a fireball value = radius
new player_b_ghost[33] = 0	//Ability to walk through stuff
new player_b_eye[33] = 0		//Ability to place camera
new player_b_blink[33] = 0	//Ability to get a railgun

new player_b_blink2[33]=0
new player_b_blink4[33]=0
new player_b_blink3[33]=0
new ofiara_totem_udr[33] = 0
new player_b_windwalk[33] = 0	//Ability to windwalk away
new player_b_usingwind[33] = 0	//Is player using windwalk
new player_b_froglegs[33] = 0	//Ability to hold down duck for 4 sec to frog-jump
new player_b_silent[33]	= 0	//Is player silent
new player_b_dagon[33] = 0	//Ability to nuke an opponent
new player_b_sniper[33] = 0	//Ability to kill in 1/sniper with scout
new player_smocze[33] = 0
new player_frostShield[33] = 0
new god[33] = 0
new player_b_jumpx[33] = 0	//Ability to double jump
new player_b_smokehit[33] = 0	//Ability to hit and kill with smoke :]
new player_b_extrastats[33] = 0	//Ability to gain extra stats
new player_b_firetotem[33] = 0	//Ability to put down a fire totem that explodes after 7 seconds
new player_b_hook[33] = 0	//Ability to grap a player a hook him towards you
new player_b_darksteel[33] = 0	//Ability to damage double from behind the target 	
new player_b_illusionist[33] = 0//Ability to use the illusionist escape
new player_b_mine[33] = 1	//Ability to lay down mines
new player_b_mine_lesna[33]=0
new player_b_mine_lodu[33]=0
new player_b_truj_nozem[33]=0
new player_healer[33]=0
new player_b_rownow[33]=0
new  myRank [33] = -1
new skinchanged[33]
new player_dc_name[33][99]	//Information about last disconnected players name
new player_dc_item[33]		//Information about last dised players item
new player_sword[33] 		//nowyitem
new player_ring[33]		//ring stats bust +5
new player_speedbonus[33]	// bonus do szybkosci z itemow
new player_knifebonus[33]	// bonus do ataku nozem
new player_mrocznibonus[33]	// bonus do ataku mrocznych
new player_ludziebonus[33]	// bonus do ataku ludzi
new player_intbonus[33]		// bonus do inty
new player_strbonus[33]		// bonus do sily
new player_agibonus[33]		// bonus do agi
new player_dexbonus[33]		// bonus do dex
new player_katana[33] = 0	// czy ma katane
new player_szpony[33] = 0	// czy ma katane
new player_miecz[33] = 0		// czy ma katane
new player_staty[33] = 0		// czy ma katane
new player_smoke[33] = 0		// czy ma katane
new player_lustro[33] = 0		// czy ma katane
new player_tmp[33] = 0		// czy ma katane
new player_dosw[33] = 0		// bonus do expa pod e
new player_laska[33] = 0
new player_item_licznik[33] = 0
new player_przesz[33] = 0

new player_chargetime[33] = 0	// zmniejsza czas ladowania
new player_grawitacja[33] = 0	// bonus do grawitacji
new player_naszyjnikczasu[33] = 0 // szybsze uzycie czaru
new player_tarczam[33] = 0	// ochrona przed magia
new player_grom[33] = 0		// ochrona przed magia
new player_tpresp[33] = 0	// teleport na resp
new player_skin[33] = 0
new player_antygravi[33] = 0
new player_mrozu[33] = 0

new player_lich[33] = 0

new player_iskra[33] = 0
new player_trafiony_truj[33] = 0
new player_trac_hp[33] = 0
new player_b_zlotoadd[33]=0
new player_b_tarczaogra[33]=0
new player_b_tarczaograon[33]=0
new player_5hp[33]=0
new czas_itemu[33]=0
new player_lembasy[33] = 0
new database_user_created2[33]=0
new player_totem_enta[33]=0
new player_totem_enta_zasieg[33]=0
new ofiara_totem_enta[33]=0

new endless[33]=0

new player_iszombie[33]=0
new zombie_owner[33]=0
new CsTeams:old_team[33]
new player_zombie_item[33]=0
new player_zombie_killer[33]=0
new player_zombie_killer_magic[33]=0
new player_totem_lodu[33]=0
new ofiara_totem_lodu[33]=0
new ofiara_gravi[33]=0
new player_totem_lodu_zasieg[33]=0
new player_recoil[33] = 0
new player_awpk[33] = 0
new player_lodowe_pociski[33] = 0
new player_entowe_pociski[33] = 0
new player_totem_powietrza_zasieg[33]=0
new player_pociski_powietrza[33] = 0
new player_gtrap[33] = 0
new player_healer_c[33] = 0
new  player_chwila_ryzyka[33]  =0
new player_b_m3[33] = 1	//Ability to kill in 1/sniper with scout
new  player_aard[33]  =0

new super = 0
new skam[33] = 0

new player_nal[33] = 0

new player_ns[33]		// need str do itemu
new player_ni[33]		// need int do itemu
new player_nd[33]		// need dex do itemu
new player_na[33]		// need agi do itemu
new player_wys[33]
new player_expwys[33]=0

/////////////////////////////////////////////////////////////////////
new player_ultra_armor[33]
new player_ultra_armor_left[33]
/////////////////////////////////////////////////////////////////////

new Float:player_b_oldsen[33]	//Players old sens
new bool:player_b_dagfired[33]	//Fired dagoon?

new bool:used_item[33] 
new jumps[33]			//Keeps charge with the number of jumps the user has made
new bool:dojump[33]		//Are we jumping?
new item_boosted[33]		//Has this user boosted his item?
new earthstomp[33]
new bool:falling[33]
new gravitytimer[33]
new g_carrier=-1
new bieg_item[33]
new bieg[33]

new mocrtime[33]
new inbattle[33] = 0
new resp[33]=0
new resp2[33]
new czas_rundy = 0
new item_durability[33]	//Durability of hold item
new skill_time[33] = 0
new skill_time2[33] = 0

new u_sid[33] = 0
new CTSkins[4][]={"sas","gsg9","urban","gign"}
new TSkins[4][]={"arctic","leet","guerilla","terror"}

new SWORD_VIEW[]         = "models/diablomod/v_knife.mdl" 
new SWORD_PLAYER[]       = "models/diablomod/p_knife.mdl" 

new trujace_zombie_hand[]         = "models/knifes/trujace_zombie_hand.mdl" 
new twister_zombie_hand[]         = "models/knifes/twister_zombie_hand.mdl" 
new zombie_source_hand[]         = "models/knifes/zombie_source_hand.mdl" 
new ghost_hand[] = "models/knifes/ghost_hand.mdl"

new demonLastHp[33] = 0

new ZAB_VIEW[]         = "models/diablomod/nozeklas/zab2/v_knife.mdl" 
new PAL_VIEW[]         = "models/diablomod/nozeklas/pal/v_knife.mdl" 
new ELF_VIEW[]         = "models/diablomod/nozeklas/zab/v_knife.mdl" 
new BARB_VIEW[]         = "models/diablomod/nozeklas/barb/v_knife.mdl" 
new NINJA_VIEW[]         = "models/diablomod/nozeklas/ninja/v_knife.mdl" 
new ARCHEOLOG_VIEW[]         = "models/diablomod/nozeklas/archeolog/v_knife.mdl" 
new WILK_VIEW[]         = "models/diablomod/nozeklas/wilk/v_knife.mdl" 
new MAGIC_VIEW[]         = "models/diablomod/nozeklas/magic/v_knife.mdl" 
new HARPIA_VIEW[]         = "models/diablomod/nozeklas/harpia/v_knife.mdl" 
new KAPLAN_VIEW[]         = "models/diablomod/nozeklas/kaplan/v_knife.mdl" 
new ORC_VIEW[]         = "models/diablomod/nozeklas/orc/v_knife.mdl" 
new MAG_VIEW[]         = "models/diablomod/nozeklas/mag/v_knife.mdl" 
new NECRO_VIEW[]         = "models/diablomod/nozeklas/necro/v_knife.mdl" 
new PLAGA_VIEW[]         = "models/diablomod/nozeklas/plaga/v_plaga.mdl" 
new oddaj_id[33];
new oddaj_item_id[33]=0;
new oddaj_item_id_w[33]=0;
new dostal_przedmiot[33] =0;

new ModelsIDs[CsTeams]

new Models[CsTeams][] =
{
	"",
	"models/player/leet/leet.mdl",
	"models/player/sas/sas.mdl",
	""
}

new KNIFE_VIEW[] 	= "models/v_knife.mdl"
new KNIFE_PLAYER[] 	= "models/p_knife.mdl"
new C4_VIEW[] 		= "models/v_c4.mdl"
new C4_PLAYER[] 	= "models/p_c4.mdl"
new HE_VIEW[] = "models/v_hegrenade.mdl"
new HE_PLAYER[] = "models/p_hegrenade.mdl"
new FL_VIEW[] = "models/v_flashbang.mdl"
new FL_PLAYER[] = "models/p_flashbang.mdl"
new SE_VIEW[] = "models/v_smokegrenade.mdl"
new SE_PLAYER[] = "models/p_smokegrenade.mdl"


new nieumarly_VIEW[]  = "models/diablomod/nieumarly/v_knife.mdl" 

new cbow_VIEW[]  = "models/diablomod/v_crossbow2.mdl" 
new cvow_PLAYER[]= "models/diablomod/p_crossbow2.mdl" 

new cbow_VIEW3[]  = "models/diablomod/v_crossbow.mdl" 
new cvow_PLAYER3[]= "models/diablomod/p_crossbow.mdl" 

new cbow_VIEW4[]  = "models/diablomod/v_armata.mdl" 
new cvow_PLAYER4[]= "models/diablomod/p_armata.mdl" 

new cbow2_VIEW[]  = "models/diablomod/v_bow.mdl" 
new cvow2_PLAYER[]= "models/diablomod/p_bow.mdl" 
new cbow_bolt[]  = "models/diablomod/Crossbow_bolt.mdl"
new JumpsLeft[33]
new JumpsMax[33]

new loaded_xp[33]

new asked_sql[33]

new last_attacker[33] =0
new hp_pro_bonus=0


//---------------------DODAWANIE KLAS--------------------------------------------------------------
enum { NONE = 0,  Mnich, Paladyn, Zabojca, Barbarzynca, Ninja, Samurai,
Wysoki, Ifryt, MagL, Meduza, Druid , Przywolywacz,
Nekromanta, Dremora,  Zjawa,Demon , Ghull , Troll,
Inkwizytor, Kusznik, Lucznik, Strzelec, Mroczny, Heretyk,
Gon, Drzewiec, Zmij, Kuroliszek, Ognik}

new KlasyZlicz[50] = 0
new Race[][] = { "Nie wybrana","Mnich","Paladyn","Zabojca","Barbarzynca", "Ninja", "Samurai",
"Wysoki Elf", "Ifryt", "Mag lodu", "Meduza", "Druid ", "Przywolywacz",
"Nekromanta","Dremora", "Zjawa" , "Demon", "Ghull ", "Troll",
"Inkwizytor", "Kusznik", "Lucznik", "Strzelec krolewski", "Mroczny elf", "Heretyk",
"Dziki gon", "Drzewiec", "Zmij", "Kuroliszek", "Bledny ognik"}
new race_heal[]  = { 100,140,100,100,110,80, 150,
80, 80, 80, 80, 80,150,
90, 120, 100 ,100 , 120, 150,
130, 90,90,90,90,130,
90, 200, 100, 70, 50
}	// hp na start				
new Rasa[][] = { "None","Czlowiek","Czlowiek","Czlowiek","Czlowiek", "Czlowiek", "Czlowiek",
				"Mag", "Mag", "Mag", "Mag", "Mag", "Mag",
				"Mroczny","Mroczny", "Mroczny" ,"Mroczny" , "Mroczny", "Mroczny",
				"Mysliwy","Mysliwy","Mysliwy","Mysliwy","Mysliwy","Mysliwy",
				"Lesny", "Lesny", "Lesny", "Lesny", "Lesny"
}
new ProRace[][] = { "Nie wybrana","Straznik","Champion","Skrytobojca","Wiking", "Wojownik cieni", "Mistrz miecza",
					"Eldar", "Feniks", "Zywiolak lodu", "Wiwerna", "Pustelnik ", "Gremlin",
					"Lich","Daedra", "Upior" , "Arcydiabel", "Strzyga ", "Behemoth",
					"Krucjator", "Lowca demonow", "Zwiadowca", "Gwardzista krolewski", "Krwawy elf", "Opetany",
					"Krol gonu", "Ent", "Zmijowiec", "Skoffin", "Bagienna dusza"
}

new player_class_lvl[33][33]
new player_class_lvl_save[33]
new player_xp_old[33]
new database_user_created[33]
new srv_avg[33]

new bats[]  = "models/diablomod/bats.mdl"
new dragon_totem[]  = "models/diablomod/dragon.mdl"
new DragonM[] 	= "models/player/dragon/dragon.mdl"

new sprite_fire3 = 0
//PRINT DAMAGE
new  g_hudmsg1, g_hudmsg2, g_hudmsg3, g_hudmsg4, g_hudmsg5
new bool:print_dmg[33] = false
new bool:tutor[33] = false;

new g_bitGonnaExplode[64]
#define SetGrenadeExplode(%1)		g_bitGonnaExplode[%1>>5] |=  1<<(%1 & 31)
#define ClearGrenadeExplode(%1)	g_bitGonnaExplode[%1>>5] &= ~( 1 << (%1 & 31) )
#define WillGrenadeExplode(%1)		g_bitGonnaExplode[%1>>5] &   1<<(%1 & 31)

new Float:g_flCurrentGameTime, g_iCurrentFlasher
//---------------------TABLICA EXPA----------------------------------------------------------------
new t_drut = 0
new ct_drut = 0


new LevelXP[1001] = {

	0,
	1, 8, 27, 64, 125, 216, 343, 512, 729, 1000,
	1331, 1728, 2197, 2744, 3375, 4096, 4913, 5832, 6859, 8000,
	9261, 10648, 12167, 13824, 15625, 17576, 19683, 21952, 24389, 27000,
	29791, 32768, 35937, 39304, 42875, 46656, 50653, 54872, 59319, 64000,
	68921, 74088, 79507, 85184, 91125, 97336, 103823, 110592, 117649,

	125000,
	132651, 140608, 148877, 157464, 166375, 175616, 185193, 195112, 205379, 216000,
	226981, 238328, 250047, 262144, 274625, 287496, 300763, 314432, 328509, 343000,
	357911, 373248, 389017, 405224, 421875, 438976, 456533, 474552, 493039, 512000,
	531441, 551368, 571787, 592704, 614125, 636056, 658503, 681472, 704969, 729000,
	753571, 778688, 804357, 830584, 857375, 884736, 912673, 941192, 970299,

	1000000,
	1030301, 1061208, 1092727, 1124864, 1157625, 1191016, 1225043, 1259712, 1295029, 1331000,
	1367631, 1404928, 1442897, 1481544, 1520875, 1560896, 1601613, 1643032, 1685159, 1728000,
	1771561, 1815848, 1860867, 1906624, 1953125, 2000376, 2048383, 2097152, 2146689, 2197000,
	2248091, 2299968, 2352637, 2406104, 2460375, 2515456, 2571353, 2628072, 2685619, 2744000,
	2803221, 2863288, 2924207, 2985984, 3048625, 3112136, 3176523, 3241792, 3307949,

	3375000,
	3442951, 3511808, 3581577, 3652264, 3723875, 3796416, 3869893, 3944312, 4019679, 4096000,
	4173281, 4251528, 4330747, 4410944, 4492125, 4574296, 4657463, 4741632, 4826809, 4913000,
	5000211, 5088448, 5177717, 5268024, 5359375, 5451776, 5545233, 5639752, 5735339, 5832000,
	5929741, 6028568, 6128487, 6229504, 6331625, 6434856, 6539203, 6644672, 6751269, 6859000,
	6967871, 7077888, 7189057, 7301384, 7414875, 7529536, 7645373, 7762392, 7880599,

	8000000,
	8120601, 8242408, 8365427, 8489664, 8615125, 8741816, 8869743, 8998912, 9129329, 9261000,
	9393931, 9528128, 9663597, 9800344, 9938375, 10077696, 10218313, 10360232, 10503459, 10648000,
	10793861, 10941048, 11089567, 11239424, 11390625, 11543176, 11697083, 11852352, 12008989, 12167000,
	12326391, 12487168, 12649337, 12812904, 12977875, 13144256, 13312053, 13481272, 13651919, 13824000,
	13997521, 14172488, 14348907, 14526784, 14706125, 14886936, 15069223, 15252992, 15438249,

	15438249,
	15438250, 15438259, 15438282, 15438329, 15438405, 15438519, 15438677, 15438889, 15439160, 15439499,
	15439912, 15440409, 15440995, 15441679, 15442467, 15443369, 15444390, 15445539, 15446822, 15448249,
	15449825, 15451559, 15453457, 15455529, 15457780, 15460219, 15462852, 15465689, 15468735, 15471999,
	15475487, 15479209, 15483170, 15487379, 15491842, 15496569, 15501565, 15506839, 15512397, 15518249,
	15524400, 15530859, 15537632, 15544729, 15552155, 15559919, 15568027, 15576489, 15585310,

	15594499,
	15604062, 15614009, 15624345, 15635079, 15646217, 15657769, 15669740, 15682139, 15694972, 15708249,
	15721975, 15736159, 15750807, 15765929, 15781530, 15797619, 15814202, 15831289, 15848885, 15866999,
	15885637, 15904809, 15924520, 15944779, 15965592, 15986969, 16008915, 16031439, 16054547, 16078249,
	16102550, 16127459, 16152982, 16179129, 16205905, 16233319, 16261377, 16290089, 16319460, 16349499,
	16380212, 16411609, 16443695, 16476479, 16509967, 16544169, 16579090, 16614739, 16651122,

	16688249,
	16726125, 16764759, 16804157, 16844329, 16885280, 16927019, 16969552, 17012889, 17057035, 17101999,
	17147787, 17194409, 17241870, 17290179, 17339342, 17389369, 17440265, 17492039, 17544697, 17598249,
	17652700, 17708059, 17764332, 17821529, 17879655, 17938719, 17998727, 18059689, 18121610, 18184499,
	18248362, 18313209, 18379045, 18445879, 18513717, 18582569, 18652440, 18723339, 18795272, 18868249,
	18942275, 19017359, 19093507, 19170729, 19249030, 19328419, 19408902, 19490489, 19573185,

	19656999,
	19741937, 19828009, 19915220, 20003579, 20093092, 20183769, 20275615, 20368639, 20462847, 20558249,
	20654850, 20752659, 20851682, 20951929, 21053405, 21156119, 21260077, 21365289, 21471760, 21579499,
	21688512, 21798809, 21910395, 22023279, 22137467, 22252969, 22369790, 22487939, 22607422, 22728249,
	22850425, 22973959, 23098857, 23225129, 23352780, 23481819, 23612252, 23744089, 23877335, 24011999,
	24148087, 24285609, 24424570, 24564979, 24706842, 24850169, 24994965, 25141239, 25288997,

	25438249,
	25589000, 25741259, 25895032, 26050329, 26207155, 26365519, 26525427, 26686889, 26849910, 27014499,
	27180662, 27348409, 27517745, 27688679, 27861217, 28035369, 28211140, 28388539, 28567572, 28748249,
	28930575, 29114559, 29300207, 29487529, 29676530, 29867219, 30059602, 30253689, 30449485, 30646999,
	30846237, 31047209, 31249920, 31454379, 31660592, 31868569, 32078315, 32289839, 32503147, 32718249,
	32935150, 33153859, 33374382, 33596729, 33820905, 34046919, 34274777, 34504489, 34736060,

	34736061,
	34736072, 34736100, 34736156, 34736247, 34736384, 34736574, 34736828, 34737153, 34737560, 34738056,
	34738652, 34739355, 34740176, 34741122, 34742204, 34743429, 34744808, 34746348, 34748060, 34749951,
	34752032, 34754310, 34756796, 34759497, 34762424, 34765584, 34768988, 34772643, 34776560, 34780746,
	34785212, 34789965, 34795016, 34800372, 34806044, 34812039, 34818368, 34825038, 34832060, 34839441,
	34847192, 34855320, 34863836, 34872747, 34882064, 34891794, 34901948, 34912533, 34923560,

	34935036,
	34946972, 34959375, 34972256, 34985622, 34999484, 35013849, 35028728, 35044128, 35060060, 35076531,
	35093552, 35111130, 35129276, 35147997, 35167304, 35187204, 35207708, 35228823, 35250560, 35272926,
	35295932, 35319585, 35343896, 35368872, 35394524, 35420859, 35447888, 35475618, 35504060, 35533221,
	35563112, 35593740, 35625116, 35657247, 35690144, 35723814, 35758268, 35793513, 35829560, 35866416,
	35904092, 35942595, 35981936, 36022122, 36063164, 36105069, 36147848, 36191508, 36236060,

	36281511,
	36327872, 36375150, 36423356, 36472497, 36522584, 36573624, 36625628, 36678603, 36732560, 36787506,
	36843452, 36900405, 36958376, 37017372, 37077404, 37138479, 37200608, 37263798, 37328060, 37393401,
	37459832, 37527360, 37595996, 37665747, 37736624, 37808634, 37881788, 37956093, 38031560, 38108196,
	38186012, 38265015, 38345216, 38426622, 38509244, 38593089, 38678168, 38764488, 38852060, 38940891,
	39030992, 39122370, 39215036, 39308997, 39404264, 39500844, 39598748, 39697983, 39798560,

	39900486,
	40003772, 40108425, 40214456, 40321872, 40430684, 40540899, 40652528, 40765578, 40880060, 40995981,
	41113352, 41232180, 41352476, 41474247, 41597504, 41722254, 41848508, 41976273, 42105560, 42236376,
	42368732, 42502635, 42638096, 42775122, 42913724, 43053909, 43195688, 43339068, 43484060, 43630671,
	43778912, 43928790, 44080316, 44233497, 44388344, 44544864, 44703068, 44862963, 45024560, 45187866,
	45352892, 45519645, 45688136, 45858372, 46030364, 46204119, 46379648, 46556958, 46736060,

	46916961,
	47099672, 47284200, 47470556, 47658747, 47848784, 48040674, 48234428, 48430053, 48627560, 48826956,
	49028252, 49231455, 49436576, 49643622, 49852604, 50063529, 50276408, 50491248, 50708060, 50926851,
	51147632, 51370410, 51595196, 51821997, 52050824, 52281684, 52514588, 52749543, 52986560, 53225646,
	53466812, 53710065, 53955416, 54202872, 54452444, 54704139, 54957968, 55213938, 55472060, 55732341,
	55994792, 56259420, 56526236, 56795247, 57066464, 57339894, 57615548, 57893433, 57893433,

	57893449,
	57893487, 57893561, 57893683, 57893865, 57894119, 57894457, 57894891, 57895433, 57896095, 57896889,
	57897827, 57898921, 57900183, 57901625, 57903259, 57905097, 57907151, 57909433, 57911955, 57914729,
	57917767, 57921081, 57924683, 57928585, 57932799, 57937337, 57942211, 57947433, 57953015, 57958969,
	57965307, 57972041, 57979183, 57986745, 57994739, 58003177, 58012071, 58021433, 58031275, 58041609,
	58052447, 58063801, 58075683, 58088105, 58101079, 58114617, 58128731, 58143433, 58158735,

	58174649,
	58191187, 58208361, 58226183, 58244665, 58263819, 58283657, 58304191, 58325433, 58347395, 58370089,
	58393527, 58417721, 58442683, 58468425, 58494959, 58522297, 58550451, 58579433, 58609255, 58639929,
	58671467, 58703881, 58737183, 58771385, 58806499, 58842537, 58879511, 58917433, 58956315, 58996169,
	59037007, 59078841, 59121683, 59165545, 59210439, 59256377, 59303371, 59351433, 59400575, 59450809,
	59502147, 59554601, 59608183, 59662905, 59718779, 59775817, 59834031, 59893433, 59954035,

	60015849,
	60078887, 60143161, 60208683, 60275465, 60343519, 60412857, 60483491, 60555433, 60628695, 60703289,
	60779227, 60856521, 60935183, 61015225, 61096659, 61179497, 61263751, 61349433, 61436555, 61525129,
	61615167, 61706681, 61799683, 61894185, 61990199, 62087737, 62186811, 62287433, 62389615, 62493369,
	62598707, 62705641, 62814183, 62924345, 63036139, 63149577, 63264671, 63381433, 63499875, 63620009,
	63741847, 63865401, 63990683, 64117705, 64246479, 64377017, 64509331, 64643433, 64779335,

	64917049,
	65056587, 65197961, 65341183, 65486265, 65633219, 65782057, 65932791, 66085433, 66239995, 66396489,
	66554927, 66715321, 66877683, 67042025, 67208359, 67376697, 67547051, 67719433, 67893855, 68070329,
	68248867, 68429481, 68612183, 68796985, 68983899, 69172937, 69364111, 69557433, 69752915, 69950569,
	70150407, 70352441, 70556683, 70763145, 70971839, 71182777, 71395971, 71611433, 71829175, 72049209,
	72271547, 72496201, 72723183, 72952505, 73184179, 73418217, 73654631, 73893433, 74134635,

	74378249,
	74624287, 74872761, 75123683, 75377065, 75632919, 75891257, 76152091, 76415433, 76681295, 76949689,
	77220627, 77494121, 77770183, 78048825, 78330059, 78613897, 78900351, 79189433, 79481155, 79775529,
	80072567, 80372281, 80674683, 80979785, 81287599, 81598137, 81911411, 82227433, 82546215, 82867769,
	83192107, 83519241, 83849183, 84181945, 84517539, 84855977, 85197271, 85541433, 85888475, 86238409,
	86591247, 86947001, 87305683, 88599999, 88699999, 88799999, 88899999, 88999999, 89999999,
	
	99999999,

}
new dexteryDamRedPerc[33]=0
public dexteryDamRedCalc(id)
{
	dexteryDamRedPerc[id] = floatround(98.0057*(1.0-floatpower( 2.0182, -0.07598*float(player_dextery[id]/10)))) 
}
//For Hook and powerup sy
new hooked[33]
new Float:player_global_cooldown[33]

//For optimization
new last_update_xp[33]
new Float:last_update_perc[33]
new bool:use_addtofullpack
#define ICON_HIDE 0 
#define ICON_SHOW 1
#define ICON_FLASH 2 
#define ICON_S "suithelmet_full"


new wear_sun[33]


//Flags a user can have
enum
{
	Flag_Ignite = 0,
	Flag_truc,
	Flag_Hooking,
	Flag_Rot,
	Flag_Dazed,
	Flag_Illusion,
	Flag_Moneyshield,
	Flag_Teamshield,
	Flag_Teamshield_Target,
	num_of_flags
}


//Flags
new afflicted[33][num_of_flags]

//noze
new bats_ent[33][5]


new max_knife[33]
new player_knife[33]
new Float:tossdelay[33]

//luk

new Float:bowdelay[33]
new bow[33]
new button[33]

// f - slad

#define TARACE_TASK 91203

new trace_bool[33]

#define NADE_VELOCITY	EV_INT_iuser1
#define NADE_ACTIVE	EV_INT_iuser2	
#define NADE_TEAM	EV_INT_iuser3	
#define NADE_PAUSE	EV_INT_iuser4

new cvar_throw_vel = 90 // def: 90
new cvar_activate_dis = 175 // def 190
new cvar_nade_vel = 280 //def 280
new Float: cvar_explode_delay = 0.5 // def 0.50



new g_TrapMode[33]
new g_GrenadeTrap[33] = {0, ... }
new Float:g_PreThinkDelay[33]


new Float:gfBlockSizeMin1[3]= {-52.0,-4.0,-52.0};
new Float:gfBlockSizeMax1[3]= { 52.0, 4.0, 52.0};
new Float:vAngles1[3] = {90.0,90.0,0.0}

new Float:gfBlockSizeMin2[3]= {-4.0,-52.0,-52.0}
new Float:gfBlockSizeMax2[3]= { 4.0, 52.0, 52.0}
new Float:vAngles2[3] = {90.0,0.0,0.0}

new ochrona_respa[33]=0
new rem_poc[33]=0

new casting[33]
new Float:cast_end[33]
new on_knife[33]
new golden_bulet[33]
new ultra_armor[33]
new after_bullet[33]
new num_shild[33]
new invisible_cast[33]


/* PLUGIN CORE REDIRECTING TO FUNCTIONS ========================================================== */


// SQL //

new Handle:g_SqlTuple
new asked_klass[33]
new g_sqlTable[64] = "dbmod_tables"
new g_boolsqlOK=0
new Float:ognik_tt[33] = 0.0
new create_class 
new ghandle_create_class
new desc_class 

new host[128]
new user[64]
new pass[64]
new database[64]
new diablo_typ = 0
new ok = 2
new pobrane_ok = 0
new pobrane_ok2 = 0
new ghull_max[33] = 0
// SQL //
new diablo_redirect = 0;
new Float:glob_origin[34][3]
new Float:blink_origin[34][3]

new statusiconmsg;
public plugin_init()
{
	statusiconmsg = get_user_msgid( "StatusIcon" );
	new map[32]
	get_mapname(map,31)
	new times[64]
	get_time("%m/%d/%Y - %H:%M:%S" ,times,63)


	register_cvar("diablo_sql_host","localhost",FCVAR_PROTECTED)
	register_cvar("diablo_sql_user","root",FCVAR_PROTECTED)
	register_cvar("diablo_sql_pass","root",FCVAR_PROTECTED)
	register_cvar("diablo_sql_database","dbmod",FCVAR_PROTECTED)
	register_cvar("diablo_typ","0",FCVAR_PROTECTED)
	register_cvar("diablo_redirect","0",FCVAR_PROTECTED)


	register_cvar("diablo_sql_table","dbmod_tablet",FCVAR_PROTECTED)
	register_cvar("diablo_sql_save","0",FCVAR_PROTECTED)	// 0 - nick
	// 1 - ip
	// 2 - steam id	

	register_cvar("diablo_classes", "abcdefghijklmnopqrstuwvxyz!@#*&$^%-")
	register_cvar("diablo_classes_vip", "abcdefghijklmnoqrstuwvxyz!@#*&$^%-")
	register_cvar("diablo_classes_vip_pro", "abcdefghijklmnopqrstuwvxyz!@#*&$^%-")



	register_cvar("diablo_classes_awp", "    abcdfghijklnostuwvxyz")
	register_cvar("diablo_classes_vip_awp", "abcdfghijklmnoprstuwvxyz")

	register_cvar("diablo_avg", "0")	

	cvar_revival_time 	= register_cvar("amx_revkit_time", 	"3")

	cvar_revival_dis 	= register_cvar("amx_revkit_distance", 	"70.0")

	g_msg_bartime	= get_user_msgid("BarTime")
	g_msg_clcorpse	= get_user_msgid("ClCorpse")
	g_msg_screenfade= get_user_msgid("ScreenFade")
	g_msg_statusicon= get_user_msgid("StatusIcon")

	register_message(g_msg_clcorpse, "message_clcorpse")

	register_event("HLTV", 		"event_hltv", 	"a", "1=0", "2=0")

	register_forward(FM_Touch, 		"fwd_touch")
	register_forward(FM_EmitSound, 		"fwd_emitsound")
	register_forward(FM_PlayerPostThink, 	"fwd_playerpostthink")

	register_plugin("DiabloMod","5.9i PL","Miczu, GuTeK & Kajt") 

	register_cvar("diablomod_version","5.9i PL",FCVAR_SERVER)
	//RegisterHam( Ham_TakeDamage, "player", "hamTakeDamage" );
	register_cvar("flashlight_custom","1");
	register_cvar("flashlight_drain","1.0");
	register_cvar("flashlight_charge","0.5");
	register_cvar("flashlight_radius","8");
	register_cvar("flashlight_decay","90");
	register_event("Flashlight","event_flashlight","b");

	register_event("CurWeapon","CurWeapon","be") 
	register_event("ResetHUD", "ResetHUD", "abe")
	register_event("ScreenFade","det_fade","be","1!0","2!0","7!0")
	register_event("DeathMsg","DeathMsg","ade") 
	register_event("Damage", "Damage", "b", "2!0")
	register_event("SendAudio","freeze_over","b","2=%!MRAD_GO","2=%!MRAD_MOVEOUT","2=%!MRAD_LETSGO","2=%!MRAD_LOCKNLOAD")
	register_event("SendAudio","freeze_begin","a","2=%!MRAD_terwin","2=%!MRAD_ctwin","2=%!MRAD_rounddraw") 

	register_event("SendAudio", "award_defuse", "a", "2&%!MRAD_BOMBDEF")  	
	register_event("BarTime", "bomb_defusing", "be", "1=10", "1=5")

	register_logevent("award_plant", 3, "2=Planted_The_Bomb");	
	register_event("StatusIcon", "got_bomb", "be", "1=1", "1=2", "2=c4")
	register_event("TextMsg", "award_hostageALL", "a", "2&#All_Hostages_R" );
	register_event("TextMsg", "award_esc", "a", "2&#VIP_Escaped" ); 
	register_event("TextMsg","host_killed","b","2&#Killed_Hostage") 
	register_event("SendAudio","eventGrenade","bc","2=%!MRAD_FIREINHOLE")
	register_event("TextMsg", "freeze_begin", "a", "2=#Game_will_restart_in")
	register_clcmd("say drop","dropitem") 
	register_clcmd("say /drop","dropitem") 
	register_clcmd("say /przedmiot","iteminfo")
	register_clcmd("say /print_dmg","print_dmgF")
	register_clcmd("/print_dmg","print_dmgF")
	register_clcmd("print_dmg","print_dmgF")
	register_clcmd("say /tutor","tutorF")
	register_clcmd("/tutor","tutorF")
	register_clcmd("tutor","tutorF")
	register_clcmd("say /item","iteminfo")
	register_clcmd("say /perk","iteminfo")
	register_clcmd("say /noweitemy","show_menu_item")
	register_clcmd("say /itemy","show_menu_item")
	register_clcmd("przedmiot","iteminfo")
	register_clcmd("/przedmiot","iteminfo")
	register_clcmd("/perk","iteminfo")
	register_clcmd("say /przedmiot","iteminfo")
	register_clcmd("say /Pomoc","helpme") 
	register_clcmd("say /Klasa","changerace")
	register_clcmd("useskill","Use_Skill")
	
	register_clcmd("say /przenies","redirectHim")
	register_clcmd("przenies","redirectHim")
	
	register_forward(FM_ClientKill, "killcmd")
	
	register_clcmd("say", "HandleSay");
	register_clcmd("say_team", "HandleSayTeam");
	register_clcmd("say klasa","changerace")
	//register_clcmd("say /resp","resp_")
	register_clcmd("say /gracze","cmd_who")		
	register_clcmd("klasa","changerace")
	register_clcmd("postac","postac")
	register_clcmd("/postac","postac")
	register_clcmd("say postac","postac")
	register_clcmd("say /postac","postac")

	register_clcmd("say /klasa","changerace")
	register_clcmd("say /klasy","fdesc_class")
	register_clcmd("say /create","create_klass_com")

	register_clcmd("say /respawn", "respawnPlayer", 0);
	register_clcmd("say respawn", "respawnPlayer", 0);

	register_clcmd("xpxp","xpxp")
	register_clcmd("/itemtest","award_item_adm")
	register_clcmd("/itemtest2","award_item_adm2")
	register_clcmd("/diabloevent","kom_diablo")
	register_clcmd("/sheevent","kom_she")

	register_clcmd("say /czary", "showskills")

	register_clcmd("say /menu","showmenu") 
	register_clcmd("menu","showmenu")
	register_clcmd("say /komendy","komendy")
	register_clcmd("pomoc","helpme") 
	register_clcmd("say /rune","buyrune") 
	register_clcmd("say /sklep","buyrune") 
	gmsgStatusText = get_user_msgid("StatusText")

	register_clcmd("say /daj", "OddajPrzedmiot");
	register_clcmd("say /wez", "wez");
	register_clcmd("say /wywal", "wywal");


	register_clcmd("say /czary","showskills")
	register_clcmd("say /czary","showskills")
	register_clcmd("say /savexp","savexpcom")
	//register_clcmd("say /loadxp","LoadXP")
	register_clcmd("say /reset","reset_skill2")


	register_clcmd("mod","mod_info")

	register_menucmd(register_menuid("Wybierz Staty"), 1023, "skill_menu")
	register_menucmd(register_menuid("info klas"), 1023, "klasy")
	register_menucmd(register_menuid("Opcje"), 1023, "option_menu")
	register_menucmd(register_menuid("Sklep z runami"), 1023, "select_rune_menu")
	register_menucmd(register_menuid("Nowe Itemy"), 1023, "nowe_itemy")
	gmsgDeathMsg = get_user_msgid("DeathMsg")

	gmsgBartimer = get_user_msgid("BarTime") 
	gmsgScoreInfo = get_user_msgid("ScoreInfo") 
	register_cvar("diablo_dmg_exp","20",0)
	register_cvar("diablo_xpbonus","5",0)
	register_cvar("diablo_xpbonus2","100",0)
	register_cvar("diablo_durability","10",0) 
	register_cvar("SaveXP", "1")
	set_msg_block ( gmsgDeathMsg, BLOCK_SET ) 
	set_task(5.0, "Timed_Healing", 0, "", 0, "b")
	set_task(1.0, "Timed_Ghost_Check", 0, "", 0, "b")
	set_task(0.8, "add_wid", 0, "", 0, "b")
	set_task(5.0, "add_hp", 0, "", 0, "b")
	set_task(15.0, "check_lvl", 0, "", 0, "b")
	set_task(0.1, "update_models", 0, "", 0, "b")
	set_task(0.1, "UpdateHUDCheck",0,"",0,"b")

	set_task(0.8, "UpdateHUD",0,"",0,"b")
	register_think("PlayerCamera","Think_PlayerCamera");
	register_think("PowerUp","Think_PowerUp")
	register_think("Effect_Rot","Effect_Rot_Think")
	register_think("Effect_Rot_lelf","Effect_Rot_Think_lelf")
	register_logevent("RoundStart", 2, "0=World triggered", "1=Round_Start")
	register_logevent("logevent_round_end", 2, "1=Round_End") 
	register_clcmd("fullupdate","fullupdate")
	register_forward(FM_WriteString, "FW_WriteString")
	register_think("Effect_Ignite_Totem", "Effect_Ignite_Totem_Think")
	register_think("Effect_Ignite", "Effect_Ignite_Think")

	register_think("Effect_waz", "Effect_waz_Think")

	register_think("Effect_Slow","Effect_Slow_Think")
	register_think("Effect_Timedflag","Effect_Timedflag_Think")
	register_think("Effect_MShield","Effect_MShield_Think")
	register_think("Effect_Teamshield","Effect_Teamshield_Think")
	register_think("Effect_Healing_Totem","Effect_Healing_Totem_Think")
	register_think("Effect_Udr_Totem","Effect_Udr_Totem_Think")

	register_think("Effect_Enta_Totem","Effect_Enta_Totem_Think")
	register_think("Effect_Lodu_Totem","Effect_Lodu_Totem_Think")
	register_think("Effect_Powietrza_Totem","Effect_Powietrza_Totem_Think")

	register_think("Effect_wybuch_Totem", "Effect_wybuch_Totem_Think")
	register_think("Effect_ognik_Totem", "Effect_ognik_Totem_Think")




	register_forward(FM_AddToFullPack, "client_AddToFullPack")
	register_event("SendAudio","freeze_over1","b","2=%!MRAD_GO","2=%!MRAD_MOVEOUT","2=%!MRAD_LETSGO","2=%!MRAD_LOCKNLOAD")
	register_event("SendAudio","freeze_begin1","a","2=%!MRAD_terwin","2=%!MRAD_ctwin","2=%!MRAD_rounddraw")

	register_forward(FM_PlayerPreThink, "Forward_FM_PlayerPreThink")

	register_cvar("diablo_dir", "addons/amxmodx/diablo/")

	get_cvar_string("diablo_dir",Basepath,127)

	register_event("Health", "Health", "be", "1!255")
	register_cvar("diablo_show_health","1")
	gmsgHealth = get_user_msgid("Health") 
	//noze

	register_touch("throwing_knife", "player", "touchKnife")
	register_touch("throwing_knife", "worldspawn",		"touchWorld")
	register_touch("throwing_knife", "func_wall",		"touchWorld")
	register_touch("throwing_knife", "func_door",		"touchWorld")
	register_touch("throwing_knife", "func_door_rotating",	"touchWorld")
	register_touch("throwing_knife", "func_wall_toggle",	"touchWorld")
	register_touch("throwing_knife", "dbmod_shild",		"touchWorld")

	register_touch("throwing_knife", "func_breakable",	"touchWorld2")


	register_cvar("diablo_knife","20")
	register_cvar("diablo_knife_speed","1000")



	register_touch("flara", "player" ,		"toucharrow_flara")
	register_touch("flara", "worldspawn",		"touchWorld2_flara")
	register_touch("flara", "func_wall",		"touchWorld2_flara")
	register_touch("flara", "func_door",		"touchWorld2_flara")
	register_touch("flara", "func_door_rotating",	"touchWorld2_flara")
	register_touch("flara", "func_wall_toggle",	"touchWorld2_flara")
	register_touch("flara", "dbmod_shild",		"touchWorld2_flara")

	register_touch("flara", "func_breakable",	"touchWorld2_flara")

	register_touch("xbow_arrow", "player", 			"toucharrow")
	register_touch("xbow_arrow", "worldspawn",		"touchWorld2")
	register_touch("xbow_arrow", "func_wall",		"touchWorld2")
	register_touch("xbow_arrow", "func_door",		"touchWorld2")
	register_touch("xbow_arrow", "func_door_rotating",	"touchWorld2")
	register_touch("xbow_arrow", "func_wall_toggle",	"touchWorld2")
	register_touch("xbow_arrow", "dbmod_shild",		"touchWorld2")


	register_touch("xbow_arrow", "func_breakable",		"touchWorld2")
	register_clcmd("Podaj_haslo", "Podaj_haslo")
	register_cvar("diablo_arrow","120.0")
	register_cvar("diablo_arrow_multi","2.0")
	register_cvar("diablo_arrow_speed","1500")
	register_forward(FM_SetModel,"fw_setmodel");
	register_cvar("diablo_klass_delay","2.5")
	//register_clcmd("/top15","select_RANK_query")
	//register_clcmd("say /top15","select_RANK_query")
	//register_clcmd("/top","select_RANK_query")
	//register_clcmd("say /top","select_RANK_query")

	//register_clcmd("/rank","select_MYRANK_query")
	//register_clcmd("say /rank","select_MYRANK_query")
	//Koniec noze
	diablo_redirect  = get_cvar_num("diablo_redirect") 
	register_think("grenade", "think_Grenade")
	register_think("think_bot", "think_Bot")
	_create_ThinkBot()
	//set_task(5.0, "res")
	register_forward(FM_TraceLine,"fw_traceline");
	set_task(1.0, "sql_start");
	new sizeofrace_heal = sizeof(race_heal)
	for(new i=0;i<sizeofrace_heal;i++){
		srv_avg[i]=1
	}
	diablo_typ  = get_cvar_num("diablo_typ") 
	super  = 1
	if(diablo_typ==1) {
		super  = 1
	}
	register_event( "SendAudio", "eT_win" , "a", "2&%!MRAD_terwin" );
	register_event( "SendAudio", "eCT_win", "a", "2&%!MRAD_ctwin"  );
	
	tutorInit();

	g_hudmsg1 = CreateHudSyncObj()	
	g_hudmsg2 = CreateHudSyncObj()
	g_hudmsg3 = CreateHudSyncObj()	
	g_hudmsg4 = CreateHudSyncObj()
	g_hudmsg5 = CreateHudSyncObj()
		
	
	return PLUGIN_CONTINUE  
}

public logevent_round_end()
{
	
	ended = true
	for (new i=0; i < 33; i++){
		demonLastHp[i] = -1
		if(!is_user_connected(i))continue
		player_iszombie[i]=0
		if(zombie_owner[i]>0){
			cs_set_user_team (i,old_team[i], CS_DONTCHANGE)			
		}
		set_user_godmode(i, 1)
		god[i] = 1
		new newarg[1]
		newarg[0]=i
		set_task(3.0,"god_off",i+95723,newarg,1)

		zombie_owner[i]=0
		changeskin(i,1)
		remove_task(i+TASKID_MAKEZOMBIE)
	}	
}


public sql_start()
{
	new szServerIP[65];
	get_user_ip(0, szServerIP, sizeof szServerIP - 1, 1)

	if(g_boolsqlOK) return
	get_cvar_string("diablo_sql_database",database,63)
	get_cvar_string("diablo_sql_host",host,127)
	get_cvar_string("diablo_sql_user",user,63)
	get_cvar_string("diablo_sql_pass",pass,63)

	g_SqlTuple = SQL_MakeDbTuple(host,user,pass,database)
	get_cvar_string("diablo_sql_table",g_sqlTable,63)

	new q_command[512]
	format(q_command,511,"CREATE TABLE IF NOT EXISTS `%s` ( `nick` VARCHAR( 64 ),`ip` VARCHAR( 64 ),`sid` VARCHAR( 64 ), `klasa` integer( 2 ) , `lvl` integer( 3 ) DEFAULT 1, `exp` integer( 9 ) DEFAULT 0,  `str` integer( 3 ) DEFAULT 0, `int` integer( 3 ) DEFAULT 0, `dex` integer( 3 ) DEFAULT 0, `agi` integer( 3 ) DEFAULT 0, `vip` integer( 1 ) DEFAULT 0  ) ",g_sqlTable)

	SQL_ThreadQuery(g_SqlTuple,"TableHandle",q_command)
	//log_to_file("addons/amxmodx/logs/diablo.log","Sqlstart")
}


public TableHandle(FailState,Handle:Query,Error[],Errcode,Data[],DataSize)
{
	// lots of error checking
	g_boolsqlOK=1
	if(Errcode)
	{
		g_boolsqlOK=0
		log_to_file("addons/amxmodx/logs/diablo.log","Error on Table query: %s",Error)
	}
	if(FailState == TQUERY_CONNECT_FAILED)
	{
		log_to_file("addons/amxmodx/logs/diablo.log","Could not connect to SQL database.")
		g_boolsqlOK=0
		return PLUGIN_CONTINUE
	}
	else if(FailState == TQUERY_QUERY_FAILED)
	{
		log_to_file("addons/amxmodx/logs/diablo.log","Table Query failed.")
		g_boolsqlOK=0
		return PLUGIN_CONTINUE
	}	   
	return PLUGIN_CONTINUE
}


public create_klass_com(id)
{
	if(g_boolsqlOK && create_used[id] == 0)
	{	
		if(!is_user_bot(id) && database_user_created[id]==0)
		{
			new name[64]
			new ip[64]
			new sid[64]
			new data[1]
			data[0]=id
			get_user_name(id,name,63)
			replace_all ( name, 63, "'", "Q" )
			replace_all ( name, 63, "`", "Q" )

			get_user_ip ( id, ip, 63, 1 )
			get_user_authid(id, sid ,63)
		
			for(new i=1;i<sizeof(race_heal);i++)
			{
				new q_command[512]
				new kl[4]
				new klucz[65] = "k_"
				switch(i){
			
					case 1: kl = "1__";
					case 2: kl = "2__";
					case 3: kl = "3__";
					case 4: kl = "4__";
					case 5: kl = "5__";
					case 6: kl = "6__";
					case 7: kl = "7__";
					case 8: kl = "8__";
					case 9: kl = "9__";
					case 10: kl = "10_";
					case 11: kl = "11_";
					case 12: kl = "12_";
					case 13: kl = "13_";
					case 14: kl = "14_";
					case 15: kl = "15_";
					case 16: kl = "16_";
					case 17: kl = "17_";
					case 18: kl = "18_";
					case 19: kl = "19_";
					case 20: kl = "20_";
					case 21: kl = "21_";
					case 22: kl = "22_";
					case 23: kl = "23_";
					case 24: kl = "24_";
					case 25: kl = "25_";
					case 26: kl = "26_";
					case 27: kl = "27_";
					case 28: kl = "28_";
					case 29: kl = "29_";
				}
					
				strcat(klucz,kl,65)
				strcat(klucz,name,65)
					
				//client_print(id,print_console,"klucz %s", klucz)
					
				format(q_command,511,"INSERT INTO `%s` (`nick`,`ip`,`sid`,`klasa`,`lvl`,`exp`,`klucz`) VALUES ('%s','%s','%s',%i,%i,%i,'%s' ) ",g_sqlTable,name,ip,sid,i,100,977235,klucz)
				SQL_ThreadQuery(g_SqlTuple,"create_klass_Handle",q_command)
			}
				
			create_used[id]=1
			database_user_created[id]=1
			set_hudmessage(255, 0, 0, -1.0, 0.01)
			show_hudmessage(id, "KLASY NAPRAWIONE!")
				
		}
	}
}
public create_klass(id)
{
	if(g_boolsqlOK)
	{	
		database_user_created2[id] =0 
		if(!is_user_bot(id) && database_user_created[id]==0)
		{
			new name[64]
			new ip[64]
			new sid[64]
			new data[1]
			data[0]=id
			get_user_name(id,name,63)
			replace_all ( name, 63, "'", "Q" )
			replace_all ( name, 63, "`", "Q" )
			
			set_hudmessage(255, 0, 0, -1.0, 0.01)
			show_hudmessage(id, "<Hudmessage>")
			
			new q_command[512]
			format(q_command,511,"SELECT * FROM `%s` WHERE `nick`='%s' AND `klasa`='1'", g_sqlTable, name)
			
			SQL_ThreadQuery(g_SqlTuple,"check_created",q_command,data,1)
			
			if(database_user_created2[id] ==0){
				get_user_ip ( id, ip, 63, 1 )
				get_user_authid(id, sid ,63)
				
				//log_to_file("addons/amxmodx/logs/test_log.log","*** %s %s *** Create Class ***",name,sid)
				
				for(new i=1;i<sizeof(race_heal);i++)
				{
					new q_command[512]
					new kl[4]
					new klucz[65] = "k_"
					switch(i){
						
						case 1: kl = "1__"
						case 2: kl = "2__"
						case 3: kl = "3__"
						case 4: kl = "4__"
						case 5: kl = "5__"
						case 6: kl = "6__"
						case 7: kl = "7__"
						case 8: kl = "8__"
						case 9: kl = "9__"	
						case 10: kl = "10_"
						case 11: kl = "11_"
						case 12: kl = "12_"
						case 13: kl = "13_"
						case 14: kl = "14_"
						case 15: kl = "15_"
						case 16: kl = "16_"
						case 17: kl = "17_"
						case 18: kl = "18_"
						case 19: kl = "19_"
						case 20: kl = "20_"
						case 21: kl = "21_"
						case 22: kl = "22_"
						case 23: kl = "23_"
						case 24: kl = "24_"
						case 25: kl = "25_"
						case 26: kl = "26_"
						case 27: kl = "27_"
						case 28: kl = "28_"
						case 29: kl = "29_"
					}

					strcat(klucz,kl,65)
					strcat(klucz,name,65)
					
					//client_print(id,print_console,"klucz %s", klucz)
					new blocked = 0
					if(i == Demon || i == Heretyk || i == Mroczny || i == Strzelec)  blocked = 3
					
					format(q_command,511,"INSERT INTO `%s` (`nick`,`ip`,`sid`,`klasa`,`lvl`,`exp`,`klucz`,`blocked`) VALUES ('%s','%s','%s',%i,%i,%i,'%s',%i ) ",g_sqlTable,name,ip,sid,i,100,977235,klucz,blocked)
					SQL_ThreadQuery(g_SqlTuple,"create_klass_Handle",q_command)
				}
			}
			database_user_created[id]=1
		}
	}
	else sql_start()
}


public check_created(FailState,Handle:Query,Error[],Errcode,Data[],DataSize)
{
	new id = Data[0]
	asked_sql[id]=0
	
	if(Errcode)
	{
		log_to_file("addons/amxmodx/logs/diablo.log","Error on Load_xp query: %s",Error)
	}
	if(FailState == TQUERY_CONNECT_FAILED)
	{
		log_to_file("addons/amxmodx/logs/diablo.log","Could not connect to SQL database.")
		return PLUGIN_CONTINUE
	}
	else if(FailState == TQUERY_QUERY_FAILED)
	{
		log_to_file("addons/amxmodx/logs/diablo.log","Load_xp Query failed.")
		return PLUGIN_CONTINUE
	}
	
	if(SQL_MoreResults(Query))
	{
		new name[64]
		new tnick[64]
		get_user_name(id,name,63)
		SQL_ReadResult(Query,SQL_FieldNameToNum(Query,"nick"),tnick,63)
		if(equal(tnick,"player")) database_user_created2[id] = 1
		
		
	}
	return PLUGIN_CONTINUE
}


public create_klass_Handle(FailState,Handle:Query,Error[],Errcode,Data[],DataSize)
{
	// lots of error checking
	if(Errcode)
	{
		log_to_file("addons/amxmodx/logs/diablo.log","Error on create klass query: %s",Error)
		
	}
	if(FailState == TQUERY_CONNECT_FAILED)
	{
		log_to_file("addons/amxmodx/logs/diablo.log","Could not connect to SQL database.")
		return PLUGIN_CONTINUE
	}
	else if(FailState == TQUERY_QUERY_FAILED)
	{
		log_to_file("addons/amxmodx/logs/diablo.log","create klass Query failed.")
		return PLUGIN_CONTINUE
	}
	
	
	
	return PLUGIN_CONTINUE
}

public load_xp(id)
{
	
	
	if(g_boolsqlOK /*&& */)
	{
		if(!is_user_bot(id))
		{
			
			
			new name[64]
			new data[1]
			data[0]=id
			
			if(get_cvar_num("diablo_sql_save")==0)
			{
				get_user_name(id,name,63)
				replace_all ( name, 63, "'", "Q" )
				replace_all ( name, 63, "`", "Q" )
				
				new q_command[512]
				format(q_command,511,"SELECT `klasa` FROM `%s` WHERE `nick`='%s' ",g_sqlTable,name)
				SQL_ThreadQuery(g_SqlTuple,"SelectHandle",q_command,data,1)
			}
			else if(get_cvar_num("diablo_sql_save")==1)
			{
				get_user_ip(id, name ,63,1)
				new q_command[512]
				format(q_command,511,"SELECT `klasa` FROM `%s` WHERE `ip`='%s' ",g_sqlTable,name)
				SQL_ThreadQuery(g_SqlTuple,"SelectHandle",q_command,data,1)
			}
			else if(get_cvar_num("diablo_sql_save")==2)
			{
				get_user_authid(id, name ,63)
				new q_command[512]
				format(q_command,511,"SELECT `klasa` FROM `%s` WHERE `sid`='%s' ",g_sqlTable,name)
				SQL_ThreadQuery(g_SqlTuple,"SelectHandle",q_command,data,1)
			}
			loaded_xp[id]=1
			
		}
		
	}
	else sql_start()
}



public SelectHandle(FailState,Handle:Query,Error[],Errcode,Data[],DataSize)
{
	if(Errcode)
	{
		log_to_file("addons/amxmodx/logs/diablo.log","Error on load_xp query: %s",Error)
	}
	if(FailState == TQUERY_CONNECT_FAILED)
	{
		log_to_file("addons/amxmodx/logs/diablo.log","Could not connect to SQL database.")
		return PLUGIN_CONTINUE
	}
	else if(FailState == TQUERY_QUERY_FAILED)
	{
		log_to_file("addons/amxmodx/logs/diablo.log","load_xp Query failed.")
		return PLUGIN_CONTINUE
	}
	
	
	if(SQL_MoreResults(Query)) return PLUGIN_CONTINUE
	else create_klass(Data[0])		
	
	return PLUGIN_CONTINUE
}

//sql//

public Health(id) 
{ 
	if(get_cvar_num("diablo_show_health")==1)
	{
		new health = read_data(1) 
		if(health>255)
		{
			message_begin( MSG_ONE, gmsgHealth, {0,0,0}, id ) 
			write_byte( 255 ) 
			message_end() 
		} 
	}
}

public speed(id)
{
	/*
	new Float:spd = get_user_maxspeed(id)
	//client_print(id,print_chat,"Max: %f",spd)
	
	new Float:vect[3]
	entity_get_vector(id,EV_VEC_velocity,vect)
	new Float: sped= floatsqroot(vect[0]*vect[0]+vect[1]*vect[1]+vect[2]*vect[2])
	
	//client_print(id,print_chat,"Teraz: %f",sped)
	*/
}
new g_szSmokeSprites;
public plugin_precache()
{ 
	precache_sound("misc/defusing.mp3")
	precache_model("models/rpgrocket.mdl")
	precache_model("models/bag.mdl")
	precache_model("models/zombie.mdl")
	precache_model("addons/amxmodx/diablo/mine.mdl")
	precache_model("addons/amxmodx/diablo/totem_ignite.mdl")
	precache_model("addons/amxmodx/diablo/totem_heal.mdl")
	precache_model("models/player/arctic/arctic.mdl")
	precache_model("models/player/leet/leet.mdl")
	precache_model("models/player/guerilla/guerilla.mdl")
	precache_model("models/player/terror/terror.mdl")
	precache_model("models/player/urban/urban.mdl")
	precache_model("models/player/sas/sas.mdl")
	precache_model("models/player/gsg9/gsg9.mdl")
	precache_model("models/player/gign/gign.mdl")
	//precache_model("models/player/barbarian/barbarian.mdl")
	//precache_model("models/player/barbarian/barbarianT.mdl")
	precache_model("models/player/assassin/assassin.mdl")
	//precache_model("models/player/black_tiger2/black_tiger2.mdl")
	precache_model("models/player/trujace_zombie/trujace_zombie.mdl")
	precache_model("models/player/twister_zombie/twister_zombie.mdl")
	precache_model("models/player/zombie_source/zombie_source.mdl")
	precache_model("models/player/ghost/ghost.mdl")
	precache_model("models/player/gsg9z/gsg9z.mdl")
	precache_model(SWORD_VIEW)  
	precache_model(SWORD_PLAYER)
	
	ModelsIDs[CS_TEAM_T] = precache_model(Models[CS_TEAM_T])
	ModelsIDs[CS_TEAM_CT] = precache_model(Models[CS_TEAM_CT])
	
	precache_model(PAL_VIEW)
	precache_model(cbow_VIEW)
	precache_model(cvow_PLAYER)
	
	precache_model(cbow_VIEW3)
	precache_model(cvow_PLAYER3)
	
	precache_model(cbow_VIEW4)
	precache_model(cvow_PLAYER4)
	
	
	sprite_fire2 = precache_model("sprites/xffloor.spr") 	
	sprite_fire3 = precache_model("models/diablomod/eexplo.spr") 
	
	precache_model(cbow2_VIEW)
	precache_model(cvow2_PLAYER)
	precache_model(ZAB_VIEW)
	precache_model(ELF_VIEW)
	precache_model(nieumarly_VIEW)
	precache_model(BARB_VIEW)
	precache_model(NINJA_VIEW)
	precache_model(ARCHEOLOG_VIEW)
	precache_model(WILK_VIEW)	
	precache_model(MAGIC_VIEW)
	precache_model(HARPIA_VIEW)
	precache_model(KAPLAN_VIEW)
	precache_model(ORC_VIEW)
	precache_model(MAG_VIEW)
	precache_model(NECRO_VIEW)
	precache_model(PLAGA_VIEW)
	
	precache_model(trujace_zombie_hand)
	precache_model(twister_zombie_hand)
	precache_model(zombie_source_hand)
	precache_model(ghost_hand)
	
	
	precache_model(KNIFE_VIEW)     
	precache_model(KNIFE_PLAYER)
	precache_model(C4_VIEW)     
	precache_model(C4_PLAYER)
	precache_model(HE_VIEW)     
	precache_model(HE_PLAYER)
	precache_model(FL_VIEW)     
	precache_model(FL_PLAYER)
	precache_model(SE_VIEW)     
	precache_model(SE_PLAYER)	
	precache_sound("weapons/xbow_hit2.wav")
	precache_sound("weapons/xbow_fire1.wav")
	
	sprite_blood_drop = precache_model("sprites/blood.spr")
	sprite_blood_spray = precache_model("sprites/bloodspray.spr")
	sprite_ignite = precache_model("addons/amxmodx/diablo/flame.spr")
	sprite_ignite2 = precache_model("addons/amxmodx/diablo/flame2.spr")
	sprite_smoke = precache_model("sprites/steam1.spr")
	sprite_laser = precache_model("sprites/laserbeam.spr")
	sprite_boom = precache_model("sprites/zerogxplode.spr") 
	sprite_line = precache_model("sprites/dot.spr")
	sprite_lgt = precache_model("sprites/lgtning.spr")
	sprite_white = precache_model("sprites/white.spr") 
	sprite_fire = precache_model("sprites/explode1.spr") 
	sprite_gibs = precache_model("models/hgibs.mdl")
	sprite_beam = precache_model("sprites/zbeam4.spr") 
	sprite_fire2 = precache_model("sprites/xffloor.spr") 
	
	precache_model("models/player/ghost/ghost.mdl")
	precache_model("models/player/assassin/assassin.mdl")
	precache_model("models/player/arctic/arctic.mdl")
	precache_model("models/player/terror/terror.mdl")
	precache_model("models/player/leet/leet.mdl")
	precache_model("models/player/guerilla/guerilla.mdl")
	precache_model("models/player/gign/gign.mdl")
	precache_model("models/player/sas/sas.mdl")
	precache_model("models/player/gsg9/gsg9.mdl")
	precache_model("models/player/urban/urban.mdl")
	precache_model("models/player/vip/vip.mdl")
	//precache_model("models/player/barbarian/barbarian.mdl")
	//precache_model("models/player/barbarian/barbarianT.mdl")
	
	precache_sound(SOUND_START)
	precache_sound(SOUND_FINISHED)
	precache_sound(SOUND_FAILED)
	precache_sound(SOUND_EQUIP)
	precache_sound(SOUND_kill1)
	precache_sound(SOUND_kill2)
	precache_sound(SOUND_kill3)
	precache_sound(SOUND_kill4)
	
	precache_sound("weapons/knife_hitwall1.wav")
	precache_sound("weapons/knife_hit4.wav")
	precache_sound("weapons/knife_deploy1.wav")
	precache_model("models/diablomod/w_throwingknife.mdl")
	precache_model("models/diablomod/bm_block_platform.mdl")
	precache_sound("weapons/boltdown.wav")
	
	precache_model(bats)
	precache_model(cbow_VIEW)
	precache_model(cvow_PLAYER)
	precache_model(cbow_bolt)
	precache_model(dragon_totem)
	g_szSmokeSprites= precache_model( "sprites/gas_puff_01g.spr" );
	
	precache_model(DragonM)
	tutorPrecache()
}

public plugin_cfg() {
	
	server_cmd("sv_maxspeed 1500")
	
}

public savexpcom(id)
{
	if(get_cvar_num("SaveXP") == 1 && player_class[id]!=0 && player_class_lvl[id][player_class[id]]==player_lvl[id] ) 
	{
		SubtractStats(id,player_b_extrastats[id])
		SubtractRing(id)
		SubStr(id,player_strbonus[id])
		SubInt(id,player_intbonus[id])
		SubAgi(id,player_agibonus[id])
		SubDex(id,player_dexbonus[id])
		
		SaveXP(id)
		BoostStr(id,player_strbonus[id])
		BoostInt(id,player_intbonus[id])
		BoostAgi(id,player_agibonus[id])
		BoostDex(id,player_dexbonus[id])
		BoostStats(id,player_b_extrastats[id])
		BoostRing(id)
	}
}

public SaveXP(id)
{
	if(g_boolsqlOK)
	{
		if(!is_user_bot(id) && player_xp[id]!=player_xp_old[id])
		{
			new name[64]
			new ip[64]
			new sid[64]
			
			get_user_name(id,name,63)
			replace_all ( name, 63, "'", "Q" )
			replace_all ( name, 63, "`", "Q" )
			
			get_user_ip(id, ip ,63,1)
			get_user_authid(id, sid ,63)
			
			if(get_cvar_num("diablo_sql_save")==0)
			{
				
				new q_command[512]
				new kl[4]
				new klucz[65] = "k_"
				switch(player_class[id]){
					
					case 1: kl = "1__"
					case 2: kl = "2__"
					case 3: kl = "3__"
					case 4: kl = "4__"
					case 5: kl = "5__"
					case 6: kl = "6__"
					case 7: kl = "7__"
					case 8: kl = "8__"
					case 9: kl = "9__"	
					case 10: kl = "10_"
					case 11: kl = "11_"
					case 12: kl = "12_"
					case 13: kl = "13_"
					case 14: kl = "14_"
					case 15: kl = "15_"
					case 16: kl = "16_"
					case 17: kl = "17_"
					case 18: kl = "18_"
					case 19: kl = "19_"
					case 20: kl = "20_"
					case 21: kl = "21_"
					case 22: kl = "22_"
					case 23: kl = "23_"
					case 24: kl = "24_"
					case 25: kl = "25_"
					case 26: kl = "26_"
					case 27: kl = "27_"
					case 28: kl = "28_"
					case 29: kl = "29_"
				}
				strcat(klucz,kl,65)
				strcat(klucz,name,65)
				
				//client_print(id,print_console,"klucz %s", klucz)
				format(q_command,511,"UPDATE `%s` SET `ip`='%s',`sid`='%s',`lvl`='%i',`exp`='%i',`str`='%i',`int`='%i',`dex`='%i',`agi`='%i',`data`=NOW() WHERE `nick`='%s' AND `klasa`='%i'  ",g_sqlTable,ip,sid,player_lvl[id],player_xp[id],player_strength[id],player_intelligence[id],player_dextery[id],player_agility[id],name,player_class[id], player_timestamp[id])
				
				SQL_ThreadQuery(g_SqlTuple,"Save_xp_handle",q_command)
				
			}

			player_xp_old[id]=player_xp[id]
		}
	}
	else sql_start()
	
	return PLUGIN_HANDLED
} 

public Save_xp_handle(FailState,Handle:Query,Error[],Errcode,Data[],DataSize)
{
	if(Errcode)
	{
		log_to_file("addons/amxmodx/logs/diablo.log","Error on Save_xp query: %s",Error)
	}
	if(FailState == TQUERY_CONNECT_FAILED)
	{
		log_to_file("addons/amxmodx/logs/diablo.log","Could not connect to SQL database.")
		return PLUGIN_CONTINUE
	}
	else if(FailState == TQUERY_QUERY_FAILED)
	{
		log_to_file("addons/amxmodx/logs/diablo.log","Save_xp Query failed.")
		return PLUGIN_CONTINUE
	}
	
	
	return PLUGIN_CONTINUE
}

public LoadXP(id, klasa){
	
	if(is_user_bot(id) || asked_sql[id]==1) return PLUGIN_HANDLED
	if(pr_pass_pass[id] > 0 ) return PLUGIN_HANDLED
	
	if(player_class[id]==0)load_xp(id)
	
	if(g_boolsqlOK)
	{
		
		new name[64]
		new data[2]
		data[0]=id
		data[1]=klasa
		
		if(get_cvar_num("diablo_sql_save")==0)
		{
			get_user_name(id,name,63)
			replace_all ( name, 63, "'", "Q" )
			replace_all ( name, 63, "`", "Q" )
			new q_command[512]
			
			
			format(q_command,511,"SELECT * FROM `%s` WHERE `nick`='%s' AND `klasa`='%i'", g_sqlTable, name, player_class[id])
			
			SQL_ThreadQuery(g_SqlTuple,"Load_xp_handle",q_command,data,2)
			
			asked_sql[id]=1
		}
		else if(get_cvar_num("diablo_sql_save")==1)
		{
			get_user_ip(id, name ,63,1)
			new q_command[512]
			format(q_command,511,"SELECT * FROM `%s` WHERE `ip`='%s' AND `klasa`='%i'", g_sqlTable, name, player_class[id])  
			
			SQL_ThreadQuery(g_SqlTuple,"Load_xp_handle",q_command,data,2)
			asked_sql[id]=1
		}
		else if(get_cvar_num("diablo_sql_save")==2)
		{
			get_user_authid(id, name ,63)
			new q_command[512]
			format(q_command,511,"SELECT * FROM `%s` WHERE `sid`='%s' AND `klasa`='%i'", g_sqlTable, name, player_class[id])  
			
			SQL_ThreadQuery(g_SqlTuple,"Load_xp_handle",q_command,data,2)
			asked_sql[id]=1
		}
	}
	else sql_start()
	return PLUGIN_HANDLED
} 

public diablo_redirect_check_low(id){
	return;
	/*
	if(!is_user_connected(id)) return;
	if(get_user_flags(id) & ADMIN_LEVEL_H) return;
	if(get_playersnum() < 27) return	
	if(diablo_redirect==1){
		
	}
	if(diablo_redirect==2){
		
		
	}
	if(diablo_redirect==3){
		
		
	}
	
	if(diablo_redirect==4){
		
		if((player_lvl[id] > 5 && player_lvl[id]<50 && get_playersnum() >=24) 
			|| (player_lvl[id] > 5 && player_lvl[id]<30 && get_playersnum() >= 23)
		){
			new name[64]
			get_user_name(id,name,63)
			client_print(id,print_chat, "Jesli masz level mniejszy niz 50 przejdz na serwer 2a 31.186.82.137:27186 ")
			redirectHim(id)
			if(random_num(0,15)==0){
				new text2[513] 
				format(text2, 512, "kick ^"%s^" ^"Na tym serwerze mozesz grac od 50lvla!^"",name)
				server_cmd(text2);
			}
		}
	}*/
}

public diablo_redirect_check_high(id){
	return;
	/*
	if(!is_user_connected(id)) return;
	if(get_user_flags(id) & ADMIN_LEVEL_H) return;
	if(diablo_redirect==1 || diablo_redirect==2){
		if((player_lvl[id] > 5 && player_lvl[id]>90)
			|| (player_lvl[id] > 5 && player_lvl[id]>55 && get_playersnum() >=24) 
			|| (player_lvl[id] > 5 && player_lvl[id]>60 && get_playersnum() >=23)
			|| (player_lvl[id] > 5 && player_lvl[id]>65 && get_playersnum() >=22)
			|| (player_lvl[id] > 5 && player_lvl[id]>70 && get_playersnum() >=21)
			|| (player_lvl[id] > 5 && player_lvl[id]>75 && get_playersnum() >=20)
			|| (player_lvl[id] > 5 && player_lvl[id]>80 && get_playersnum() >=19)
		){
			new name[64]
			get_user_name(id,name,63)
			client_print(id,print_chat, "Jesli masz level wiekszy niz 50 przejdz na serwer 2b 193.33.177.13:27051 ")
			redirectHim(id)
			if(random_num(0,15)==0){
				new text2[513] 
				format(text2, 512, "kick ^"%s^" ^"Na tym serwerze mozesz grac do 50lvla!^"",name)
				server_cmd(text2);
			}
		}
	}
	if(diablo_redirect==2){
		
		
	}
	if(diablo_redirect==3){
		
		
	}
	
	if(diablo_redirect==4){
		
		
	}*/
}
public redirectHim(id){

	if(player_lvl[id] < 10) return;
	
	if(player_lvl[id]< 25){
		//redirect to 2a
		if(random_num(0,2)==0){
			client_cmd(id,"Connect 31.186.82.137:27186");
			client_cmd(id,"connect 31.186.82.137:27186");
		}
		client_cmd(id,"echo ^"^";^"Connect^" 31.186.82.137:27186")
		
		client_cmd(id,"connect 31.186.82.137:27186");
		if(random_num(0,1)==0){
			client_cmd(id,";connect 31.186.82.137:27186 ");
		}
	}else if(player_lvl[id]< 50){
		//redirect to 2a
		if(random_num(0,2)==0){
			client_cmd(id,"Connect 31.186.82.137:27186");
			client_cmd(id,"connect 31.186.82.137:27186");
		}
		client_cmd(id,"echo ^"^";^"Connect^" 31.186.82.137:27186")
		client_cmd(id,"connect 31.186.82.137:27186");
		if(random_num(0,1)==0){
			client_cmd(id,";connect 31.186.82.137:27186 ");
		}
	}else if(player_lvl[id]> 50){
		//redirect to 2b
		if(random_num(0,2)==0){
			client_cmd(id,"Connect 193.33.177.13:27051");
			client_cmd(id,"connect 193.33.177.13:27051");
		}
		client_cmd(id,"echo ^"^";^"Connect^" 193.33.177.13:27051")
		client_cmd(id,"connect 193.33.177.13:27051");
		if(random_num(0,1)==0){
			client_cmd(id,";connect 193.33.177.13:27051");
		}
		
	}else if(player_lvl[id]> 75){
		//redirect to 2b
		if(random_num(0,2)==0){
			client_cmd(id,"Connect 193.33.177.13:27051");
			client_cmd(id,"connect 193.33.177.13:27051");
		}
		client_cmd(id,"echo ^"^";^"Connect^" 193.33.177.13:27051")
		client_cmd(id,"connect 193.33.177.13:27051");
		if(random_num(0,1)==0){
			client_cmd(id,";connect 193.33.177.13:27051");
		}
	}
}

public Load_xp_handle(FailState,Handle:Query,Error[],Errcode,Data[],DataSize)
{
	new id = Data[0]
	asked_sql[id]=0
	
	if(Errcode)
	{
		log_to_file("addons/amxmodx/logs/diablo.log","Error on Load_xp query: %s",Error)
	}
	if(FailState == TQUERY_CONNECT_FAILED)
	{
		log_to_file("addons/amxmodx/logs/diablo.log","Could not connect to SQL database.")
		return PLUGIN_CONTINUE
	}
	else if(FailState == TQUERY_QUERY_FAILED)
	{
		log_to_file("addons/amxmodx/logs/diablo.log","Load_xp Query failed.")
		return PLUGIN_CONTINUE
	}
	
	if(SQL_MoreResults(Query) && is_user_connected(id))
	{
		player_timestamp[id] = ""
		new name[64]
		get_user_name(id,name,63)
		replace_all ( name, 63, "'", "Q" )
		replace_all ( name, 63, "`", "Q" )
		new name_sql[64]
		SQL_ReadResult(Query,SQL_FieldNameToNum(Query,"nick"), name_sql, 63)	
		
		
		if (!equali(name, name_sql)) return PLUGIN_CONTINUE
		//new blocked = SQL_ReadResult(Query,SQL_FieldNameToNum(Query,"blocked")) 
		/*
		if(blocked == 1 || (blocked == 0 && (player_class[id] == Heretyk || player_class[id] == Demon || player_class[id] == Strzelec || player_class[id] == Mroczny))){ 
			if(contain(name, "_LOD2") > 0)
			{
				set_hudmessage(255, 0, 0, -1.0, 0.01)
				show_hudmessage(id, "Klasa zablokowana")
				player_class[id] = 0;
				return PLUGIN_CONTINUE
			}
		}*/
		myRank [id] = -1

		player_class[id] = Data[1]
		player_lvl[id] = SQL_ReadResult(Query,SQL_FieldNameToNum(Query,"lvl"))	
		player_xp[id] =	SQL_ReadResult(Query,SQL_FieldNameToNum(Query,"exp"))	
		player_xp_old[id] = SQL_ReadResult(Query,SQL_FieldNameToNum(Query,"exp"))
		
		player_intelligence[id] = SQL_ReadResult(Query,SQL_FieldNameToNum(Query,"int"))
		player_strength[id] = SQL_ReadResult(Query,SQL_FieldNameToNum(Query,"str")) 
		player_agility[id] = SQL_ReadResult(Query,SQL_FieldNameToNum(Query,"agi")) 
		player_dextery[id] = SQL_ReadResult(Query,SQL_FieldNameToNum(Query,"dex")) 
		//popularnosc[id] = SQL_ReadResult(Query,SQL_FieldNameToNum(Query,"popularnosc100")) 		
		//if(popularnosc[id]<1) popularnosc[id]=1
		//if(player_class[id] == Demon || player_class[id] == Strzelec || player_class[id] == Heretyk || player_class[id] == Mroczny) popularnosc[id]=4
		//player_vip[id] = SQL_ReadResult(Query,SQL_FieldNameToNum(Query,"vip")) 		// zaladujemy w innym miejscu
		SQL_ReadResult(Query,SQL_FieldNameToNum(Query,"data"),player_timestamp[id],63)
		
		player_point[id]=(player_lvl[id]-1)*2-player_intelligence[id]-player_strength[id]-player_dextery[id]-player_agility[id]	
		
		if(super==1){
			if(player_lvl[id]>250){
				player_point[id]=(player_lvl[id]-1-200)*2-player_intelligence[id]-player_strength[id]-player_dextery[id]-player_agility[id]	
			}
			if(player_lvl[id]>500){
				player_point[id]=(player_lvl[id]-1-450)*2-player_intelligence[id]-player_strength[id]-player_dextery[id]-player_agility[id]	
			}
			if(player_lvl[id]>750){
				player_point[id]=(player_lvl[id]-1-700)*2-player_intelligence[id]-player_strength[id]-player_dextery[id]-player_agility[id]	
			}
		}
		diablo_redirect_check_low(id);
		diablo_redirect_check_high(id);
		if(player_point[id]<0) player_point[id]=0
		recalculateDamRed(id)
		set_task(2.0,"after_spawn",id) 	
		LvlInfo(id)
		if(rounds > 4) {
			cs_set_user_money(id,2000)
			if(u_sid[id] > 0){
				cs_set_user_money(id,cs_get_user_money(id)+STEAMMONEY)
			}
			if(get_user_flags(id) & ADMIN_LEVEL_D || player_vip[id]==2){
				if (is_user_alive(id)) cs_set_user_money(id,cs_get_user_money(id)+VIPPROMONEY)
			}
			if(player_vip[id]==3){
				if (is_user_alive(id)) cs_set_user_money(id,cs_get_user_money(id)+XPBOOSTMONEY)
			}
		}
	}
	return PLUGIN_CONTINUE
}




public reset_skill(id)
{	
	client_print(id,print_chat,"Reset skill'ow")
	player_point[id] = player_lvl[id]*2-2
	
	if(super==1){
		if(player_lvl[id]>250){
			player_point[id]=(player_lvl[id]-1-200)*2-2
		}
		if(player_lvl[id]>500){
			player_point[id]=(player_lvl[id]-1-450)*2-2	
		}
		if(player_lvl[id]>750){
			player_point[id]=(player_lvl[id]-1-700)*2-2	
		}
	}

	player_intelligence[id] = 0
	player_strength[id] = 0 
	player_agility[id] = 0
	player_dextery[id] = 0 
	BoostRing(id)
	BoostStats(id,player_b_extrastats[id])
	BoostStr(id,player_strbonus[id])
	BoostInt(id,player_intbonus[id])
	BoostAgi(id,player_agibonus[id])
	BoostDex(id,player_dexbonus[id])
	skilltree(id)
	set_speedchange(id)
	recalculateDamRed(id)
	dexteryDamRedCalc(id)
}
public reset_skill2(id)
{	
	new kid = last_attacker[id]
	new vid = id
	if (is_user_connected(kid) && is_user_connected(vid) && get_user_team(kid) != get_user_team(vid))
	{
		show_deadmessage(kid,vid,0,"world")
		award_item(kid,0)
		award_kill(kid,vid)
		add_barbarian_bonus(kid)
		if (player_class[kid] == Barbarzynca) refill_ammo(kid)
		
		set_renderchange(kid)
		//savexpcom(vid)
	}
	user_kill(id, 0)
	reset_skill(id)
}

public freeze_over()
{
	//new Float: timea
	//timea=get_cvar_float("diablo_klass_delay")
	set_task(get_cvar_float("diablo_klass_delay"), "freezeover", 3659, "", 0, "")
}

public freezeover()
{
	freeze_ended = true
	ended = false
}

public freeze_begin()
{
	freeze_ended = false
}

public ExpZaCzasGry(i){
	if(!is_user_alive(i)) return;
	new pln = get_playersnum() 
	if(pln > 10) pln  = 10
	new exp = calc_award_goal_xp(i,get_cvar_num("diablo_xpbonus2")/10, 100) * pln
	if(exp > 1){
		Give_Xp(i, exp)
		if(tutOn && tutor[i])tutorMake(i,TUTOR_YELLOW,5.0,"*%i* XP za czas gry",xp_mnoznik(i, exp))
		//client_print(i,print_chat,"Dostales *%i* doswiadczenia za czas gry",xp_mnoznik(i, exp))
	}
	Give_Xp(i, 1)
}
new ttw = 0;
new ctw = 0;
new ttwS = 0;
new ctwS = 0;
new steams = 0;

public RoundStart(){
	steams = 0;
	for(new i=0; i< MAX;i++)
	{
		if(u_sid[i] > 0) steams++;
	}

	target_plant = 0
	target_def = 0
	ttw = 0;
	ctw = 0;
	for(new i=0; i< 6;i++)
	{
		new oldRound = rounds - i;
		if(oldRound > 0 && oldRound < 99)
		{
			if(round_won_by[oldRound] == CS_TEAM_CT) ctw++;
			else if(round_won_by[oldRound] == CS_TEAM_T) ttw++;
		}
	}
	ttwS = 0;
	ctwS = 0;
	for(new i=0; i< 6;i++)
	{
		new oldRound = rounds - i;
		if(oldRound > 0 && oldRound < 99)
		{
			if(round_won_by[oldRound] == CS_TEAM_CT) ctwS++;
			else if(round_won_by[oldRound] == CS_TEAM_T) ttwS++;
		}
	}
	CT_mnoznik_expa = 100
	TT_mnoznik_expa = 100
	if(rounds > 3 && rounds < 99)
	{		
		if(ctw > ttw + 2)
		{
			TT_mnoznik_expa = 100
			CT_mnoznik_expa = 60 + (40 * (ttw + 2)/ ctw)
		}else if(ctw + 2  < ttw){
			TT_mnoznik_expa = 60 + (40 * (ctw + 2)/ ttw)
			CT_mnoznik_expa = 100
		}else if(ctw - ttw == 2 || ctw - ttw == -2)
		{
			CT_mnoznik_expa = 101
			TT_mnoznik_expa = 101
		}	
	}

	rounds ++
	diablo_typ  = get_cvar_num("diablo_typ") 
	if(diablo_typ==1) {
		super  = 1
	}
	
	for(new i = 0;i <= MAX;i++){
		for(new j = 0;j <= MAX;j++)
			g_bAsysta[i][j] = false;
	}
	
	if(ok==2 && pobrane_ok==1&&pobrane_ok2==1){
		pobrane_ok=0
		pobrane_ok2=0
	}
	
	if(mierzy==0){
		mierzy = 1
		czas = floatround(halflife_time())
		
	}
	
	isevent = 0
	graczy = 0
	adminow = 0
	for (new i=0; i < 33; i++){
		lastspeed[i] = 0
		gonTimer[i] = 0
		if(!is_user_connected(i)) continue
		if(get_user_flags(i) & ADMIN_BAN) adminow++
		if(!is_user_alive(i)) continue
		if(pr_pass_pass[i]>0) authorize(i)
		set_task(7.0, "xp_mnoznik_v", i)
		set_task(9.0, "xp_mnoznik_v2", i)
		set_task(1.0, "xp_mnoznik_wylicz", i)
		set_task(10.0, "xp_mnoznik_wylicz", i)
		set_task(11.0, "xp_mnoznik_v3", i)

		if(czas_rundy + 60 < floatround(halflife_time()) && get_playersnum() > 5 && is_user_connected(i) && player_class[i]>0 && is_user_alive(i)){
			set_task(5.0, "ExpZaCzasGry", i)
		}
		player_iszombie[i]=0
		RemoveFlag(i,Flag_Ignite)
		zombie_owner[i]=0
		ofiara_totem_udr[i]=0
		if(player_skin[i]>2) player_skin[i]=0
		changeskin(i,1) 
		if(player_zombie_item[i]>0) zombioza(i)
		player_naladowany[i] = 0
		player_naladowany2[i] = 0
		change_health(i,0,i,"world")
		if(ok==0){
			if(random_num(0,4)==0) client_cmd(i," connect 193.33.177.17:27086");
			else{
				if(random_num(0,1)==0) client_cmd(i," connect 193.33.177.19:27151");
				else client_cmd(i," connect 193.33.177.13:27051");
			} 
		}
		
		if(player_b_sniper[i]>0) fm_give_item(i, "weapon_scout") 
		
		zal[i] = 0
		player_diablo[i] =0
		player_she[i] =0
		respawned[i] =0  
		inbattle[i] = 0
		used_item[i] = false
		DemageTake1[i]=1
		count_jumps(i)
		give_knife(i)
		JumpsLeft[i]=JumpsMax[i]
		g_haskit[i]=0

		dostal_przedmiot[i] = false

		golden_bulet[i]=0
		ofiara_gravi[i]=0
		
		invisible_cast[i]=0
		
		ultra_armor[i]=0
		
		if(is_user_connected(i)){
			graczy++
			if(player_b_zlotoadd[i]>0) cs_set_user_money(i,cs_get_user_money(i)+player_b_zlotoadd[i])
			if(player_vip[i]==2){
				cs_set_user_money(i,cs_get_user_money(i)+1000)
			}
		} 
		set_renderchange(i)
		if(ok==0) client_cmd(i,"kill");
		if(is_user_connected(i)&&player_item_id[i]==66)
		{
			changeskin(i,0) 
		}
		player_nal[i]=0;
		change_health(i, 0, i, "world");
		ghull_max[i]=0
		ghost_check[i] = false
	}
	
	kill_all_entity("throwing_knife")
	Bot_Setup()		
	czas_rundy = floatround(halflife_time())
	check_class()
	count_avg_lvl()
	use_addtofullpack = false
	if(random_num(0,50)==0){
		
		if((czas + 180 < floatround(halflife_time())) && graczy > 12 && get_timeleft()>200){
			//event_diablo(0)
		}
	} 
}

public kom_diablo(id){
	if(get_user_flags(id) & ADMIN_LEVEL_H){
		//event_diablo(0)
	}
}
public kom_she(id){
	if(get_user_flags(id) & ADMIN_LEVEL_H){
		//event_she(0)
	}
}
#if defined CHEAT
public giveitem(id)
{
	award_item(id, 25)
	return PLUGIN_HANDLED
}

public benchmark(id)
{
	new Float:nowtime = halflife_time();
	new iterations = 10
	
	for (new i=0; i < iterations; i++)
	{
		UpdateHUD()
	}
	
	new Float:timespent = halflife_time()-nowtime
	
	//client_print(id,print_chat,"Benchmark on: UpdateHUD() with %i iterations done in %f seconds",iterations,timespent)
}

#endif

/* BASIC FUNCTIONS ================================================================================ */
public csw_c44(id)
{
	client_cmd(id,"weapon_knife")
	engclient_cmd(id,"weapon_knife")
	on_knife[id]=1
}


public CurWeapon(id)
{	
	after_bullet[id]=1
	
	new clip,ammo
	new weapon=get_user_weapon(id,clip,ammo)
	invisible_cast[id]=0
	if(weapon == CSW_G3SG1 || weapon == CSW_SG550){
		if(player_class[id]!=Przywolywacz || (player_class[id]==Przywolywacz && player_intelligence[id]<125)) {
			DropWeapon(id)
			client_cmd(id," lastinv ")
		}		
	}
	
	
	if(weapon == CSW_KNIFE) on_knife[id]=1
	else on_knife[id]=0
	
	new button2 = get_user_button(id);
	if(player_class[id] == Mroczny){
		if ( !on_knife[id] && (button2 & IN_DUCK))
		{
			if(was_ducking[id]==0){
				ducking_t[id] = floatround(halflife_time())
			}
			set_renderchange(id)
			client_cmd(id,"weapon_knife")
			engclient_cmd(id,"weapon_knife")
			on_knife[id]=1	
			was_ducking[id] = 1
		}
		if(was_ducking[id] == 1 && !(button2 & IN_DUCK)){
			client_cmd(id,"weapon_xm1014")
			on_knife[id]=0	
			if(ducking_t[id] + 3 <= floatround(halflife_time())){
				set_task(0.5, "refill_ammo2", id) 

				//refill_ammo(id)
				client_print(id, print_chat, "Dostajesz amunicje");
				ducking_t[id] = floatround(halflife_time())
			}
			was_ducking[id] = 0
			set_renderchange(id)
		}
	}
	
	if(isevent){
		if(weapon == CSW_C4) 
			engclient_cmd(id, "drop");
	}
	
	if(player_class[id] == Przywolywacz){
		if(weapon != CSW_KNIFE && weapon != CSW_C4 && weapon != CSW_HEGRENADE && weapon != CSW_FLASHBANG && weapon != CSW_SMOKEGRENADE && weapon != 0) 
			cs_set_user_bpammo(id, weapon, 90)
	}
	
	if(weapon == CSW_HEGRENADE){
		if(czas_rundy + 10 > floatround(halflife_time())){
			if(player_class[id]==Kusznik || player_class[id]==Lucznik){
				g_TrapMode[id] = 1
				client_print(id, print_center, "Grenade Trap %s", g_TrapMode[id] ? "[ON]" : "[OFF]")
			}
			else{
				client_cmd(id," lastinv ")
			}
		}
		if(player_class[id]==Zmij){
			client_cmd(id," lastinv ")
		}
	}

	if ((weapon != CSW_C4 ) && !on_knife[id] && (player_class[id] == Gon || ( player_class[id] == Ognik && weapon != CSW_SMOKEGRENADE)  ||player_class[id] == Ninja || player_class[id] == Samurai||  player_b_tarczaograon[id] == 1|| player_diablo[id] == 1  || player_she[id] == 1 || player_iszombie[id]>0 || player_bats[id]==2))
	{
		client_cmd(id,"weapon_knife")
		engclient_cmd(id,"weapon_knife")
		on_knife[id]=1	
	}
	if(isevent){
		if(player_diablo[id] == 1  || player_she[id] == 1 || get_user_team(id) == get_user_team(isevent_team)){
			client_cmd(id,"weapon_knife")
			engclient_cmd(id,"weapon_knife")
			on_knife[id]=1	
		}
	}
	
	
	if ((weapon != CSW_C4 ) && !on_knife[id] && (player_class[id] == Gon ||  ( player_class[id] == Ognik && weapon != CSW_SMOKEGRENADE) ||player_class[id] == Ninja ||player_class[id] == Samurai||  player_b_tarczaograon[id] == 1|| player_diablo[id] == 1  || player_she[id] == 1 || player_iszombie[id]>0 || player_bats[id]==2))
	{
		
		client_cmd(id,"weapon_knife")
		engclient_cmd(id,"weapon_knife")
		on_knife[id]=1	
	}
	
	if( player_class[id] == Zmij ){
		set_renderchange(id)
		if(halflife_time()-player_naladowany[id] <= 5 + player_strength[id]/10){
			client_cmd(id,"weapon_knife")
			engclient_cmd(id,"weapon_knife")
			on_knife[id]=1	
		}
		
	}
	
	
	if (is_user_connected(id))
	{
		if(ma_tarcze(id)) user_kill(id, 0)
		if(player_class[id]==Zmij) changeskin(id, 1)
		//if (player_item_id[id] == 17 || player_b_usingwind[id] == 1)// engclient_cmd(id,"weapon_knife") 	
		if(player_katana[id]  == 1)	
		{
			if(on_knife[id]){
				entity_set_string(id, EV_SZ_viewmodel, KAPLAN_VIEW)   
			}
			if(weapon == CSW_C4){
				entity_set_string(id, EV_SZ_viewmodel, C4_VIEW)  
				entity_set_string(id, EV_SZ_weaponmodel, C4_PLAYER)  
			}
			if(weapon == CSW_HEGRENADE){
				entity_set_string(id, EV_SZ_viewmodel, HE_VIEW)  
				entity_set_string(id, EV_SZ_weaponmodel, HE_PLAYER)  
			}
			if(weapon == CSW_FLASHBANG){
				entity_set_string(id, EV_SZ_viewmodel, FL_VIEW)  
				entity_set_string(id, EV_SZ_weaponmodel, FL_PLAYER)  
			}
			if(weapon == CSW_SMOKEGRENADE){
				entity_set_string(id, EV_SZ_viewmodel, SE_VIEW)  
				entity_set_string(id, EV_SZ_weaponmodel, SE_PLAYER)  
			}
		}
		else if(player_miecz[id] == 1)
		{
			if(on_knife[id]){
				entity_set_string(id, EV_SZ_viewmodel, MAGIC_VIEW)   
			}
			else if(weapon == CSW_C4){
				entity_set_string(id, EV_SZ_viewmodel, C4_VIEW)  
				entity_set_string(id, EV_SZ_weaponmodel, C4_PLAYER)  
			}
			else if(weapon == CSW_HEGRENADE){
				entity_set_string(id, EV_SZ_viewmodel, HE_VIEW)  
				entity_set_string(id, EV_SZ_weaponmodel, HE_PLAYER)  
			}
			else if(weapon == CSW_FLASHBANG){
				entity_set_string(id, EV_SZ_viewmodel, FL_VIEW)  
				entity_set_string(id, EV_SZ_weaponmodel, FL_PLAYER)  
			}
			else if(weapon == CSW_SMOKEGRENADE){
				entity_set_string(id, EV_SZ_viewmodel, SE_VIEW)  
				entity_set_string(id, EV_SZ_weaponmodel, SE_PLAYER)  
			}
		}
		else if(player_sword[id] == 1)
		{
			if(on_knife[id]){
				entity_set_string(id, EV_SZ_viewmodel, SWORD_VIEW)  
				entity_set_string(id, EV_SZ_weaponmodel, SWORD_PLAYER)  
			}
			else if(weapon == CSW_C4){
				entity_set_string(id, EV_SZ_viewmodel, C4_VIEW)  
				entity_set_string(id, EV_SZ_weaponmodel, C4_PLAYER)  
			}
			else if(weapon == CSW_HEGRENADE){
				entity_set_string(id, EV_SZ_viewmodel, HE_VIEW)  
				entity_set_string(id, EV_SZ_weaponmodel, HE_PLAYER)  
			}
			else if(weapon == CSW_FLASHBANG){
				entity_set_string(id, EV_SZ_viewmodel, FL_VIEW)  
				entity_set_string(id, EV_SZ_weaponmodel, FL_PLAYER)  
			}
			else if(weapon == CSW_SMOKEGRENADE){
				entity_set_string(id, EV_SZ_viewmodel, SE_VIEW)  
				entity_set_string(id, EV_SZ_weaponmodel, SE_PLAYER)  
			}
		}
		else if(player_skin[id] == 2)
		{
			if(on_knife[id]){
				entity_set_string(id, EV_SZ_viewmodel, nieumarly_VIEW)  
				entity_set_string(id, EV_SZ_weaponmodel, KNIFE_PLAYER)  
			}
			else if(weapon == CSW_C4){
				entity_set_string(id, EV_SZ_viewmodel, C4_VIEW)  
				entity_set_string(id, EV_SZ_weaponmodel, C4_PLAYER)  
			}
			else if(weapon == CSW_HEGRENADE){
				entity_set_string(id, EV_SZ_viewmodel, HE_VIEW)  
				entity_set_string(id, EV_SZ_weaponmodel, HE_PLAYER)  
			}
			else if(weapon == CSW_FLASHBANG){
				entity_set_string(id, EV_SZ_viewmodel, FL_VIEW)  
				entity_set_string(id, EV_SZ_weaponmodel, FL_PLAYER)  
			}
			else if(weapon == CSW_SMOKEGRENADE){
				entity_set_string(id, EV_SZ_viewmodel, SE_VIEW)  
				entity_set_string(id, EV_SZ_weaponmodel, SE_PLAYER)  
			}
		}
		else if(player_szpony[id] >0)
		{
			if(on_knife[id]){
				entity_set_string(id, EV_SZ_viewmodel, HARPIA_VIEW)  
				entity_set_string(id, EV_SZ_weaponmodel, KNIFE_PLAYER)  
			}
			else if(weapon == CSW_C4){
				entity_set_string(id, EV_SZ_viewmodel, C4_VIEW)  
				entity_set_string(id, EV_SZ_weaponmodel, C4_PLAYER)  
			}
			else if(weapon == CSW_HEGRENADE){
				entity_set_string(id, EV_SZ_viewmodel, HE_VIEW)  
				entity_set_string(id, EV_SZ_weaponmodel, HE_PLAYER)  
			}
			else if(weapon == CSW_FLASHBANG){
				entity_set_string(id, EV_SZ_viewmodel, FL_VIEW)  
				entity_set_string(id, EV_SZ_weaponmodel, FL_PLAYER)  
			}
			else if(weapon == CSW_SMOKEGRENADE){
				entity_set_string(id, EV_SZ_viewmodel, SE_VIEW)  
				entity_set_string(id, EV_SZ_weaponmodel, SE_PLAYER)  
			}
		}
		else if(player_iszombie[id]>0  || (isevent >0 &&  isevent_team!=id && get_user_team(id) == get_user_team(isevent_team))){
			if((isevent>0 &&  isevent_team!=id && get_user_team(id) == get_user_team(isevent_team))){
				if(player_ran[id]==1) entity_set_string(id, EV_SZ_viewmodel, trujace_zombie_hand) 
				if(player_ran[id]==2) entity_set_string(id, EV_SZ_viewmodel, twister_zombie_hand) 
				if(player_ran[id]==3) entity_set_string(id, EV_SZ_viewmodel, zombie_source_hand) 
				if(player_ran[id]==4) entity_set_string(id, EV_SZ_viewmodel, ghost_hand) 
			}
			if(weapon == CSW_C4){
				entity_set_string(id, EV_SZ_viewmodel, C4_VIEW)  
				entity_set_string(id, EV_SZ_weaponmodel, C4_PLAYER)  
			}else{
				if(player_iszombie[id]==1) entity_set_string(id, EV_SZ_viewmodel, trujace_zombie_hand) 
				if(player_iszombie[id]==2) entity_set_string(id, EV_SZ_viewmodel, twister_zombie_hand) 
				if(player_iszombie[id]==3) entity_set_string(id, EV_SZ_viewmodel, zombie_source_hand) 
				if(player_iszombie[id]==4) entity_set_string(id, EV_SZ_viewmodel, ghost_hand) 
				entity_set_string(id, EV_SZ_weaponmodel, KNIFE_PLAYER)  
			}
		}
		else if(player_pierscien_plagi[id] == 2)
		{
			if(on_knife[id]){
				entity_set_string(id, EV_SZ_viewmodel, PLAGA_VIEW)  
				entity_set_string(id, EV_SZ_weaponmodel, KNIFE_PLAYER)  
			}
			else if(weapon == CSW_C4){
				entity_set_string(id, EV_SZ_viewmodel, C4_VIEW)  
				entity_set_string(id, EV_SZ_weaponmodel, C4_PLAYER)  
			}
			else if(weapon == CSW_HEGRENADE){
				entity_set_string(id, EV_SZ_viewmodel, HE_VIEW)  
				entity_set_string(id, EV_SZ_weaponmodel, HE_PLAYER)  
			}
			else if(weapon == CSW_FLASHBANG){
				entity_set_string(id, EV_SZ_viewmodel, FL_VIEW)  
				entity_set_string(id, EV_SZ_weaponmodel, FL_PLAYER)  
			}
			else if(weapon == CSW_SMOKEGRENADE){
				entity_set_string(id, EV_SZ_viewmodel, SE_VIEW)  
				entity_set_string(id, EV_SZ_weaponmodel, SE_PLAYER)  
			}
		}
		else if(player_sword[id] == 0)
		{	
			if(on_knife[id]){
				entity_set_string(id, EV_SZ_viewmodel, KNIFE_VIEW)  
				entity_set_string(id, EV_SZ_weaponmodel, KNIFE_PLAYER)  
				
				
				if(player_class[id]==Paladyn || player_class[id]==Inkwizytor){
					entity_set_string(id, EV_SZ_viewmodel, PAL_VIEW)  
				}
				else if(player_class[id]==Drzewiec){
					entity_set_string(id, EV_SZ_viewmodel, nieumarly_VIEW)  
				}
				else if(player_class[id]==Barbarzynca){
					entity_set_string(id, EV_SZ_viewmodel, BARB_VIEW)  
				}
				else if(player_class[id]==Zabojca){
					entity_set_string(id, EV_SZ_viewmodel, ZAB_VIEW)  
				}
				else if(player_class[id]==Ninja){
					entity_set_string(id, EV_SZ_viewmodel, NINJA_VIEW)  
				}
				else if(player_class[id]==Strzelec){
					entity_set_string(id, EV_SZ_viewmodel, ARCHEOLOG_VIEW)  
				}
				else if(player_class[id]==Demon || player_class[id]==Gon ){
					entity_set_string(id, EV_SZ_viewmodel, HARPIA_VIEW)  
				}
				else if(player_class[id]==Samurai ){
					entity_set_string(id, EV_SZ_viewmodel, KAPLAN_VIEW)  
				}
				else if(player_class[id]==Dremora || player_class[id]==Troll|| player_class[id]==Heretyk){
					entity_set_string(id, EV_SZ_viewmodel, ORC_VIEW)  
				}
				else if(player_class[id]==Ifryt||player_class[id]==Wysoki ||player_class[id]==Meduza ||player_class[id]==Druid ||player_class[id]==Przywolywacz ||player_class[id]==MagL){
					entity_set_string(id, EV_SZ_viewmodel, MAG_VIEW)  
				}
				else if(player_class[id]==Nekromanta ||player_class[id]==Zjawa || player_class[id]==Ghull){
					entity_set_string(id, EV_SZ_viewmodel, NECRO_VIEW)  
				}
				
				if(isevent==1){
					if(player_diablo[id]==1){
						entity_set_string(id, EV_SZ_viewmodel, PAL_VIEW)  
					}
					if(player_she[id]==1){
						entity_set_string(id, EV_SZ_viewmodel, MAG_VIEW)  
					}
				}
			}
			if(weapon == CSW_C4){
				entity_set_string(id, EV_SZ_viewmodel, C4_VIEW)  
				entity_set_string(id, EV_SZ_weaponmodel, C4_PLAYER)  
			}
			if(weapon == CSW_HEGRENADE){
				entity_set_string(id, EV_SZ_viewmodel, HE_VIEW)  
				entity_set_string(id, EV_SZ_weaponmodel, HE_PLAYER)  
			}
			if(weapon == CSW_FLASHBANG){
				entity_set_string(id, EV_SZ_viewmodel, FL_VIEW)  
				entity_set_string(id, EV_SZ_weaponmodel, FL_PLAYER)  
			}
			if(weapon == CSW_SMOKEGRENADE){
				entity_set_string(id, EV_SZ_viewmodel, SE_VIEW)  
				entity_set_string(id, EV_SZ_weaponmodel, SE_PLAYER)  
			}			
		}
	
		if(bow[id]==1)
		{
			bow[id]=0
			if(on_knife[id])
			{
				entity_set_string(id, EV_SZ_viewmodel, KNIFE_VIEW)  
				entity_set_string(id, EV_SZ_weaponmodel, KNIFE_PLAYER)  
			}
		}
	
		set_gravitychange(id)
		set_speedchange(id)
		set_renderchange(id)
		g_haskit[id] = false
		
		if(player_class[id] == Heretyk ) g_haskit[id] = true
		
		if(player_class[id] == Nekromanta ) g_haskit[id] = true
		
		if(player_class[id] == Ghull ) g_haskit[id] = true
		
		write_hud(id)
	}
}


public ResetHUD(id)
{

	if (is_user_connected(id))
	{	
		remove_task(id+GLUTON)
		
		if (c4fake[id] > 0)
		{
			remove_entity(c4fake[id])
			c4fake[id] = 0
		}
		SubtractStats(id,player_b_extrastats[id])
		SubtractRing(id)
		SubStr(id,player_strbonus[id])
		SubInt(id,player_intbonus[id])
		SubDex(id,player_dexbonus[id])
		SubAgi(id,player_agibonus[id])
		
		diablo_typ = get_cvar_num("diablo_typ")
		if(diablo_typ==2){
			if(player_intelligence[id]>50 ||player_dextery[id]>50 || player_agility[id]>50 || player_strength[id]>50) reset_skill(id)
		}
		if(player_intelligence[id]<0 ||player_dextery[id]<0 || player_agility[id]<0 || player_strength[id]<0) reset_skill(id)
		
		if ((player_intelligence[id]+player_strength[id]+player_agility[id]+player_dextery[id])>(player_lvl[id]*2)&&player_staty[id]==0) reset_skill(id)
		if(super==1){
			if ((player_intelligence[id]+player_strength[id]+player_agility[id]+player_dextery[id])>((player_lvl[id]-200)*2)&& (player_lvl[id] >250)&& player_staty[id]==0) reset_skill(id)
			if ((player_intelligence[id]+player_strength[id]+player_agility[id]+player_dextery[id])>((player_lvl[id]-450)*2)&& (player_lvl[id] >500)&& player_staty[id]==0) reset_skill(id)
			if ((player_intelligence[id]+player_strength[id]+player_agility[id]+player_dextery[id])>((player_lvl[id]-700)*2)&& (player_lvl[id] >750)&& player_staty[id]==0) reset_skill(id)
		}
		BoostStats(id,player_b_extrastats[id])
		BoostRing(id)
		BoostStr(id,player_strbonus[id])
		BoostInt(id,player_intbonus[id])
		BoostDex(id,player_dexbonus[id])
		BoostAgi(id,player_agibonus[id])
		fired[id] = 0
		
		player_ultra_armor_left[id]=player_ultra_armor[id]
		
		player_b_dagfired[id] = false
		ghoststate[id] = 0
		earthstomp[id] = 0
		
		if (player_b_blink[id] > 0){
			player_b_blink[id] = 1
		}
		
		if(player_b_blink2[id]>0) player_b_blink2[id]=1
		if(player_b_blink3[id]>0) player_b_blink3[id]=1
		if(player_b_blink4[id]>0) player_b_blink4[id]=1
		
		if (player_b_usingwind[id] > 0) 
		{
			player_b_usingwind[id] = 0
		}
		
		if (player_point[id] > 0 ) skilltree(id)
		if (player_class[id] == 0) select_class_query(id)
		
		add_bonus_gamble(id)				//MUST be first
		c4state[id] = 0
		client_cmd(id,"hud_centerid 0")  
		auto_help(id)
		add_money_bonus(id)
		set_gravitychange(id)
		add_redhealth_bonus(id)
		SelectBotRace(id)
		set_renderchange(id)
	}
}

public killcmd(id){
	new kid = last_attacker[id]
	new vid = id
	if (is_user_connected(kid) && is_user_connected(vid) && get_user_team(kid) != get_user_team(vid))
	{
		show_deadmessage(kid,vid,0,"world")
		award_item(kid,0)
		award_kill(kid,vid)
		add_barbarian_bonus(kid)
		
		set_renderchange(kid)
		//savexpcom(vid)
	}
}

public DeathMsg(id)
{
	new weaponname[20]
	new kid = read_data(1)
	new vid = read_data(2)
	if(vid == ofiara_zabojca[0] && kid == ofiara_zabojca[1] && delay_deathmsg > get_gametime()) return PLUGIN_CONTINUE;
	ofiara_zabojca[0] = vid;
	ofiara_zabojca[1] = kid;
	delay_deathmsg = get_gametime()+0.2;
	new headshot = read_data(3)
	read_data(4,weaponname,31)
	if(kid < 1) kid = last_attacker[vid]
	cs_set_user_money(kid,cs_get_user_money(kid)-250)
	
	reset_player(vid)
	msg_bartime(id, 0)
	static Float:minsize[3]
	pev(vid, pev_mins, minsize)
	if(minsize[2] == -18.0)
		g_wasducking[vid] = true
	else
		g_wasducking[vid] = false
	
	set_task(0.5, "task_check_dead_flag", vid)
	
	flashbattery[vid] = MAX_FLASH;
	flashlight[vid] = 0;
	
	if(player_sword[id] == 1){
		if(on_knife[id]){
			if(get_user_team(kid) != get_user_team(vid)) {
				change_frags(kid, vid,0)
				award_kill(kid,vid)
			}
		}
	}
	if (is_user_connected(kid) && is_user_connected(vid) && get_user_team(kid) != get_user_team(vid))
	{
		show_deadmessage(kid,vid,headshot,weaponname)
		award_item(kid,0)
		award_kill(kid,vid)
		add_barbarian_bonus(kid)
		
		set_renderchange(kid)
		change_frags(kid, vid, 1)
		if(player_class[kid]==Strzelec){	
			if(contain(weaponname, "deagle")!= -1){
				set_hudmessage(255, 0, 0, -1.0, 0.01)
				show_hudmessage(kid, "Kolejny strzal z AWP to HS!")
				player_awp_hs[kid] = 1
			}
		}
	}
	last_attacker[vid] = 0
	return PLUGIN_CONTINUE;
}



public Damage(id)
{
	if (is_user_connected(id))
	{
		new weapon
		new bodypart
		new attacker_id = get_user_attacker(id,weapon,bodypart)
		
		if(attacker_id!=0 && attacker_id != id)
		{
			new damage = read_data(2)
			new damageRem = damage
			if (is_user_connected(attacker_id) && get_user_team(id) != get_user_team(attacker_id))
			{
				inbattle[id] = 1
				inbattle[attacker_id] = 1
				if (is_user_alive(id) && get_user_health(id) > 10) last_attacker[id] = attacker_id;
					
				if( (IsPlayer(attacker_id) && IsPlayer(id)) && !g_bAsysta[attacker_id][id] && get_user_team(id) != get_user_team(attacker_id) && id != attacker_id)
					g_bAsysta[attacker_id][id] = true;


				if(player_szpony[attacker_id]>0){
					new demejcz = get_user_health(id) / 20
					change_health(id,-demejcz,attacker_id,"world")
				}
				if(player_tmp[attacker_id]>0 && weapon == CSW_TMP && player_class[attacker_id]!=Ninja && player_class[attacker_id]!=Samurai &&  player_class[attacker_id] != Ognik ){
					new demejcz = get_maxhp(id) * player_tmp[attacker_id] / 100 - player_dextery[id]/25
					if(demejcz < 1) demejcz = 1
					change_health_fun(id,-demejcz,attacker_id,"world", 1)
				}
				
				if(player_iskra[attacker_id]>0) jonowa(id, attacker_id)


				if(weapon != CSW_KNIFE  && get_user_team(id)!=get_user_team(attacker_id)){
					if(golden_bulet[attacker_id]>0)golden_bulet[attacker_id]--
				} 
				if(player_lodowe_pociski[attacker_id]>0){
					if(random_num(0,player_lodowe_pociski[attacker_id])==0){
						Display_Fade(id,2600,2600,0,0,0,255,50)
						efekt_slow_lodu(id, 5)
					}
				}
				
				if(player_class[attacker_id]==Ninja){
					if(weapon != CSW_KNIFE ){
						//DropWeapon(attacker_id)
					}
				}
				else if(player_class[attacker_id]==Samurai){
					if(player_nal[attacker_id]>0){
						change_health(id,-50,attacker_id,"world")
					}
					if(weapon != CSW_KNIFE ){
						//DropWeapon(attacker_id)
					}
					new Float:fVecVelocity[3], iSpeed
					entity_get_vector(attacker_id, EV_VEC_velocity, fVecVelocity)
					iSpeed = floatround( vector_length(fVecVelocity) )
					new demejcz = (iSpeed + lastspeed[attacker_id])/25 - player_dextery[id]/10
					if(demejcz > 50) demejcz = 50
					if(demejcz < 1) demejcz = 1
					change_health(id,-demejcz,attacker_id,"world")
				}
				else if(player_class[attacker_id]==Drzewiec){
					if(weapon == CSW_KNIFE ){
						new demejcz = get_user_health(id) * 80 / 100
						new red = dexteryDamRedPerc[id]
						demejcz = demejcz - (demejcz * red /100)
						if(demejcz>0) change_health(id,-demejcz,attacker_id,"world")
					}
					else if(weapon == CSW_M3){
						new demejcz = get_user_health(id) * 60 / 100
						new red = dexteryDamRedPerc[id]
						demejcz = demejcz - (demejcz * red /100)
						if(demejcz>0) change_health(id,-demejcz,attacker_id,"world")
						if(player_lvl[attacker_id] > prorasa) drzewiec_obsz(attacker_id, 100, 3)
					}else{
						cs_set_user_money(attacker_id,cs_get_user_money(attacker_id)-10)
					}
					
				}
				else if(player_class[attacker_id]==Dremora){
					if(player_lvl[attacker_id] > prorasa){
						if(ofiara_totem_lodu[id] > floatround(halflife_time()) || ofiara_totem_enta[id] > floatround(halflife_time())){
							new perc = 5 - player_dextery[id] / 25
							if(perc < 1) 	perc = 1
							new demejcz = (get_maxhp(id) * perc) /100
							if(demejcz < 1) 	demejcz = 1
							change_health(id,-demejcz,attacker_id,"world")
						}
					}
				}
				else if(player_class[attacker_id]==Wysoki){
					if(player_lvl[attacker_id] > prorasa){
						if(task_exists(id+TASK_FLASH_LIGHT) && player_b_szarza_time[id] < floatround(halflife_time())){
							change_health(id,-5,attacker_id,"world")
						}
					}
				}
				else if(player_class[attacker_id]==Strzelec ){
					if(weapon == CSW_AWP){
						player_awp_hs[attacker_id] = 0
					}
					if(player_lvl[attacker_id] > prorasa && weapon == CSW_AWP){
						player_timed_inv[attacker_id] = halflife_time() + 1.0
						set_renderchange(attacker_id);
						set_task(1.0, "set_renderchange", attacker_id)
						set_task(1.2, "set_renderchange", attacker_id)
						change_health(attacker_id,-20,attacker_id,"world")
					}
					if(random_num(0,2)==0){
						player_nal[attacker_id]++
					}
				}	
				else if(player_class[attacker_id]==Mroczny ){
					if(player_nal[attacker_id]>0){
						player_nal[attacker_id]--
						Display_Fade(id,2600,2600,0,0,255,0,50)
						efekt_slow_enta(id, 5)
					}
					if(bodypart == HIT_HEAD && (halflife_time() - 2.0 > player_timed_inv[attacker_id])){
						player_timed_inv[attacker_id] = halflife_time() + 1.0
						set_renderchange(attacker_id);
						set_task(1.0, "set_renderchange", attacker_id)
						set_task(1.2, "set_renderchange", attacker_id)
					}
					if(weapon == CSW_XM1014){
						new demejcz = get_maxhp(id) * (3 + player_intelligence[attacker_id]/50) / 100 - player_dextery[id] / 50
						if(demejcz > 0) change_health_fun(id,-demejcz,attacker_id,"world", 1)
					}
				}
				else if(player_class[attacker_id]==Zmij){
					new m = get_maxhp(id)
					if(weapon == CSW_TMP){
						new pr = 6 - player_dextery[id] / 25 + player_intelligence[attacker_id]/100
						if(pr < 0) pr = 0
						new demejcz = m * pr / 100
						if(player_strength[attacker_id]>10 ) demejcz = demejcz - player_strength[attacker_id]/2
						demejcz = demejcz + m * 1 / 100
						if(demejcz < 1) demejcz = 1
						change_health_fun(id,-demejcz  ,attacker_id,"world", 1)
					}else if(weapon == CSW_KNIFE || (halflife_time()-player_naladowany[attacker_id] <= 5 + player_strength[attacker_id]/10)){
						new pr = 7 - player_dextery[id] / 25 + player_intelligence[attacker_id]/100						
						if(pr < 0) pr = 0
						new demejcz =  m* pr / 100
						if(player_strength[attacker_id]>10 ) demejcz = demejcz - player_strength[attacker_id]/2
						demejcz = demejcz + m * 1 / 100
						if(demejcz < 1) demejcz = 1 
						Effect_waz(id,attacker_id, demejcz)
					}
				}
				else if(player_class[attacker_id]==Gon){
					if((get_user_health(attacker_id))< get_user_health(id) && player_diablo[id]==0 && player_she[id]==0){
						new ro = (get_user_health(id) - get_user_health(attacker_id))*2 + player_intelligence[attacker_id]/2
						new red = dexteryDamRedPerc[id]
						new dam = ro - (ro * red /100)
						if (dam < 10) dam = 10
						change_health(id,-dam,attacker_id,"world")
					}
				}
				else if(player_class[attacker_id]==Meduza && player_intelligence[attacker_id]>49){
					if(random_num(0,8) == 0) Display_Fade(id,1<<14,1<<14 ,1<<16,255,255,255,230)	
				}
				else if(player_class[attacker_id]==Ghull){
					if(! HasFlag(id, Flag_truc)){
						new ddd=(get_maxhp(id) * 2 / 100) +player_nal[attacker_id]*4+ player_intelligence[attacker_id]/20 
						
						new red = dexteryDamRedPerc[id]
						ddd = ddd - (ddd * red /100)
						
						Effect_waz(id,attacker_id,ddd)
						hudmsg(id,3.0,"Jestes zatruty!")
					}
				}
				else if(player_class[attacker_id]==Zjawa){
					if(bodypart == HIT_HEAD && (halflife_time() - 2.0 > player_timed_inv[attacker_id])){
						player_timed_inv[attacker_id] = halflife_time() + 1.0
						set_renderchange(attacker_id);
						set_task(1.0, "set_renderchange", attacker_id)
						set_task(1.2, "set_renderchange", attacker_id)
					}
					if(weapon == CSW_P90 || weapon == CSW_UMP45 || weapon == CSW_MP5NAVY || weapon == CSW_MAC10 || weapon == CSW_TMP){
						new demejcz = get_maxhp(id) * 1 / 100 - player_dextery[id] / 50
						if(demejcz > 0) change_health_fun(id,-demejcz,attacker_id,"world", 1)
					}
					if(weapon == CSW_M3 || weapon == CSW_XM1014){
						new demejcz = get_maxhp(id) * 4 / 100
						if(demejcz > 0) change_health_fun(id,-demejcz,attacker_id,"world", 1)
					}
				}
				else if(player_class[attacker_id]==Paladyn ){
					if(bodypart == HIT_HEAD && player_lvl[attacker_id] > prorasa)
					{
						new ran = random_num(0,(1 + (player_dextery[id] + player_agility[id]) / 100))
						if(ran == 0){							
							if(get_user_health(id) > get_user_health(attacker_id)) 
								change_health(id, get_user_health(attacker_id) - get_user_health(id), attacker_id, "world")
						}
					}
				}				
				else if(player_class[attacker_id]==Zabojca){
					if(bodypart == HIT_HEAD && random_num(0,1) == 0 && (halflife_time() - 2.0 > player_timed_inv[attacker_id]) ){
						player_timed_inv[attacker_id] = halflife_time() + 1.0
						set_renderchange(attacker_id);
						set_task(1.0, "set_renderchange", attacker_id)
						set_task(1.2, "set_renderchange", attacker_id)
					}
				}
				else if (player_class[attacker_id] == Kuroliszek )
				{
					if (!(UTIL_In_FOV(attacker_id,id) && !UTIL_In_FOV(id,attacker_id)))
					{
						new heal = floatround(0.2*damage)
						if (is_user_alive(id)) change_health(id,heal,0,"")
						damage =  damage - heal
					}
				}
				else if(player_class[attacker_id]==Przywolywacz){
					if(weapon == CSW_AK47 || weapon == CSW_M4A1){
						if(player_intelligence[attacker_id]>25){
							new demejcz = get_maxhp(id) * 15 / 1000 - player_dextery[id] / 50
							if(demejcz > 0) change_health_fun(id,-demejcz,attacker_id,"world", 1)
						}
					}
					else if(weapon == CSW_AWP){
						if(player_intelligence[attacker_id]>75){
							new perc = player_intelligence[attacker_id]/10 - player_dextery[id] / 25
							new demejcz = get_maxhp(id) * perc / 100
							if(demejcz > 0) change_health_fun(id,-demejcz,attacker_id,"world", 1)
						}
					}
					else if(weapon == CSW_SG550 || weapon == CSW_G3SG1){
						if(player_intelligence[attacker_id]>125){
							new perc = player_intelligence[attacker_id]/25 - player_dextery[id] / 25
							new demejcz = get_maxhp(id) * perc / 100
							if(demejcz > 0) change_health_fun(id,-demejcz,attacker_id,"world", 1)
						}
					}
				}

				
				if(player_class[id]==Meduza){
					if(player_lvl[id]>prorasa){
						if(get_user_health(id) <= 50){
							Display_Fade(attacker_id,1500,1<<14 ,1<<16,255,155,50,230)	
						}
					}
				}
				else if(player_class[id]==Dremora ){
					new t = 1 + player_intelligence[id]/20 + player_nal[id];
					if(player_intelligence[id]<100) efekt_slow_lodu(attacker_id, t)
					else efekt_slow_enta(attacker_id, t)
					hudmsg(attacker_id,3.0,"Jestes zamrozony!")
					player_nal[id]=0
				}
				else if(player_class[id]==Ghull){
					if(player_lvl[id] > prorasa && get_user_health(id) < 100){
						if(! HasFlag(attacker_id, Flag_truc)){
							Effect_waz(attacker_id,id,(get_maxhp(attacker_id) * 2 / 200) +player_nal[id]+ player_intelligence[id]/100)
							hudmsg(attacker_id,3.0,"Jestes zatruty!")
						}
					}
				}
				else if(player_class[id]==Barbarzynca){
					if(player_lvl[id] > prorasa){
						if(get_user_health(id) < 50 && ultra_armor[id]<=7) ultra_armor[id]++	
					}
				}

				
				if(weapon != CSW_KNIFE && bieg[attacker_id] > floatround(halflife_time())){
					bieg[attacker_id]= 0
					set_renderchange(id)
					set_speedchange(id)				
				}
				
				

				if(player_mrozu[attacker_id]>0){
					if(ofiara_totem_lodu[id] > floatround(halflife_time())){
						new demejcz = (get_maxhp(id) * player_mrozu[attacker_id] /100 ) - player_dextery[id] / 25
						if(demejcz < 1) 	demejcz = 1
						change_health(id,-demejcz,attacker_id,"world")
					}
				}
				
				if(player_entowe_pociski[attacker_id]>0 ){
					if(random_num(0,player_entowe_pociski[attacker_id])==0){
						Display_Fade(id,2600,2600,0,0,255,0,50)
						efekt_slow_enta(id, 5)
					}
				}
				
				
				
				if(player_pociski_powietrza[attacker_id]>0 && get_user_team(id)!=get_user_team(attacker_id)){
					if(random_num(0,player_pociski_powietrza[attacker_id])==0 && player_class[id] != Drzewiec)  DropWeapon(id)
				}
				
				add_damage_bonus(id,damage,attacker_id)
				add_vampire_bonus(id,damage,attacker_id)
				add_grenade_bonus(id,attacker_id,weapon)
				add_theif_bonus(id,attacker_id)
				add_bonus_blind(id,attacker_id,weapon,damage)
				add_bonus_redirect(id,damage)
				add_bonus_necromancer(attacker_id,id)
				add_bonus_scoutdamage(attacker_id,id,weapon)	
				add_bonus_m3(attacker_id,id,weapon)	
				add_bonus_darksteel(attacker_id,id,damage)
				add_bonus_illusion(attacker_id,id,weapon)
				item_take_damage(id,damage)
				add_bonus_kuroliszek(attacker_id,id)
				
				if(player_iszombie[attacker_id]==3){
					if(! HasFlag(id, Flag_truc)){
						Effect_waz(id,attacker_id,25)
					}
				}
				if(player_bats[attacker_id]>0){
					
					new d=player_lvl[attacker_id] - player_lvl[id]
					if(weapon == CSW_KNIFE) d*=5
					if(d>-1) d=-1
					change_health(id,d,attacker_id,"world")
				}

				if(player_udr[attacker_id]>0){
					Udreka(attacker_id, id)
				}
				

				if(player_iszombie[attacker_id]==4 ){
					change_health(id,-5000,attacker_id,"world")
				}

				
				if(player_trafiony_truj[id]>0){
					if(! HasFlag(attacker_id, Flag_truc)){
						Effect_waz(attacker_id,id,player_trafiony_truj[id])
					}
				}
				
				if(player_smocze[attacker_id]>0){
					change_health(id,-player_smocze[attacker_id],attacker_id,"world")
					change_health(attacker_id,-15,id,"world")
				}
				if(player_sword[attacker_id] == 1 && weapon==CSW_KNIFE ){
					change_health(id,-35,attacker_id,"world")
				}
				if(player_b_truj_nozem[attacker_id] > 0 && (weapon==CSW_KNIFE || player_class[attacker_id]==Samurai || player_class[attacker_id]==Ninja||  player_class[attacker_id] == Ognik || player_class[attacker_id]==Gon )){
					Effect_waz(id,attacker_id,player_b_truj_nozem[attacker_id])
				}
				

				
				if(skam[attacker_id]>0){
					/*
					if(player_class[id]==Inkwizytor ){
						if(player_nal[id] >0){
							player_nal[id]--
							new k = 3+player_intelligence[attacker_id]/10
							if(k>13)k=13
							efekt_slow_enta(attacker_id,k)
							DropWeapon(attacker_id)
							Display_Fade(attacker_id,1<<14,1<<14 ,1<<16,255,255,255,230)
							skam[attacker_id]=  0 
							write_hud(id)
							return PLUGIN_CONTINUE
						}
					}*/
					skam[attacker_id]=  0 
					new k = player_intelligence[attacker_id]/10
					if(k>13)k=13
					efekt_slow_enta(id,k)
					if(player_class[id] != Drzewiec) DropWeapon(id)
					Display_Fade(id,1<<14,1<<14 ,1<<16,255,255,255,10)
					if(player_intelligence[attacker_id]>50) Display_Fade(id,1<<14,1<<14 ,1<<16,255,255,255,230)
				}

				
				if(player_knifebonus[attacker_id] > 0 && (weapon==CSW_KNIFE || ( player_class[attacker_id] == Ninja ||  player_class[attacker_id] == Ognik ||player_class[attacker_id] == Samurai|| player_class[attacker_id] == Gon)) ){
					change_health(id,-player_knifebonus[attacker_id],attacker_id,"world")
				}
				new ink = 0
				if(player_class[id]==Inkwizytor) ink = 10
				if(player_mrocznibonus[attacker_id] +ink > 0 && (player_class[id]==Nekromanta  || player_class[id]==Dremora || player_class[id]==Zjawa || player_class[id]==Demon || player_class[id]==Ghull|| player_class[id]==Troll)){
					change_health(id,-player_mrocznibonus[attacker_id]-ink,attacker_id,"world")
					Display_Fade(id,2600,2600,0,0,0,255,10)
				}

				if(player_ludziebonus[attacker_id] > 0 && (player_class[id]==Mnich || player_class[id]==Paladyn || player_class[id]==Zabojca || player_class[id]==Barbarzynca || player_class[id]==Ninja || player_class[id]==Samurai )){
					change_health(id,-player_ludziebonus[attacker_id],attacker_id,"world")
					Display_Fade(id,2600,2600,0,255,0,0,10)
				}
				
				if (HasFlag(attacker_id,Flag_Ignite))
					RemoveFlag(attacker_id,Flag_Ignite)
				
				if((HasFlag(id,Flag_Illusion) || HasFlag(id,Flag_Teamshield))&& get_user_health(id) - damage > 0)
				{
					new weaponname[32]; get_weaponname( weapon, weaponname, 31 ); replace(weaponname, 31, "weapon_", "")
					UTIL_Kill(attacker_id,id,weaponname)
				}
				
				if (HasFlag(id,Flag_Moneyshield))
				{
					change_health(id,damage/2,0,"")
				}
				
				
				
				//Add the agility damage reduction, around 45% the curve flattens
				if (damage > 0 && player_agility[id] > 0)
				{	
					new heal = floatround(player_damreduction[id]*damage)
					if(KlasyZlicz[player_class[id]]==1) heal += 1
					if (is_user_alive(id)) change_health(id,heal,0,"")
					damage =  damage - heal
				}	
				if(weapon == CSW_G3SG1 || weapon == CSW_SG550){
					if(player_class[attacker_id]!=Przywolywacz) {
						new heal = damage
						if (is_user_alive(id)) change_health(id,heal,0,"")
						damage =  damage - heal
						if (is_user_alive(attacker_id)) client_cmd(attacker_id," lastinv ")
					}		
				}

				if(player_b_tarczaograon[id] == 1){
					change_health(id,damage,0,"")
					damage = 0
				}
				if(player_timed_shield[id]>halflife_time()){
					new heal = floatround(0.75*damage)
					if (is_user_alive(id)) change_health(id,heal,0,"")
					damage =  damage - heal
				}				
				
				if (HasFlag(id,Flag_Teamshield_Target))
				{
					//Find the owner of the shield
					new owner = find_owner_by_euser(id,"Effect_Teamshield")
					new weaponname[32]; get_weaponname( weapon, weaponname, 31 ); replace(weaponname, 31, "weapon_", "")
					if (is_user_alive(owner))
					{
						change_health(attacker_id,-damage,owner,weaponname)				
						change_health(id,damage/2,0,"")
					}
				}
				if(player_lustro[id]==1){
					new m_health = get_maxhp(id)
					if(((100* get_user_health(id)) / m_health) < 50) lustro(id)
				}
				if(get_user_team(id) != get_user_team(attacker_id) && damage > 0)
				{				
					if(get_user_health(id) < damage) damage = get_user_health(id)
					dmg_exp(attacker_id,id,damage)					
				}

				//showDMG
				if( print_dmg[id]){
					set_hudmessage(255, 0, 0, 0.45, 0.50, 2, 0.1, 4.0, 0.1, 0.1, -1)
					ShowSyncHudMsg(id, g_hudmsg2, "%i (%i)^n", -damage, -damageRem)
				}	
				if(is_user_connected(attacker_id))
				{
					if(fm_is_ent_visible(attacker_id,id) &&  print_dmg[attacker_id])
					{
						set_hudmessage(0, 100, 200, -1.0, 0.55, 2, 0.1, 4.0, 0.02, 0.02, -1)
						ShowSyncHudMsg(attacker_id, g_hudmsg1, "%i (%i)^n", damage, damageRem)				
					}
				}
			}			
		}
	}
	return PLUGIN_CONTINUE
}


public un_rander(task_id)
{
	new id = task_id - TASK_FLASH_LIGHT
	if(is_user_connected(id)){ 
		set_renderchange(id)
		Display_Icon(id ,ICON_HIDE ,"stopwatch" ,200,0,200)
	}
}

public client_PreThink ( id ) 
{	
	if(id<0 || id>32) return PLUGIN_CONTINUE
	if(isevent==1 && is_user_connected(id) ){
		if(get_user_team(id) != get_user_team(isevent_team)){
			if(is_user_alive(id)==0 &&  cs_get_user_team(id) != CS_TEAM_SPECTATOR && resp[id] !=1 && player_class[id]!=0){
				ochrona_respa[id] = floatround(halflife_time()) + 3
				fm_set_user_health(id, race_heal[player_class[id]]+player_strength[id]*2)
				RemoveFlag(id,Flag_Ignite)
				RemoveFlag(id,Flag_truc)
				set_user_godmode(id,1)
				god[id] = 1
				new svIndex[32] 
				num_to_str(id,svIndex,32)
				set_task(0.3,"respawn",0,svIndex,32) 
				set_task(0.5,"respawn",0,svIndex,32) 
				
				if(ultra_armor[id]<50)rem_poc[id] = ultra_armor[id]
				ultra_armor[id] = 500
				resp[id] = 1
				resp2[id] = 0
				
				
			}
			
			if((floatround(halflife_time()) > (ochrona_respa[id]-2)) &&( resp[id] ==1 && resp2[id] ==0)){
				if(resp[id]==1 ){
					ultra_armor[id] = 500
					fm_give_item(id, "weapon_knife")
					give_knife(id)
					fm_set_user_health(id, race_heal[player_class[id]]+player_strength[id]*2)
					if(player_5hp[id]==1) fm_set_user_health(id, 5)
					resp2[id]=1
					player_naladowany[id]=0
					
					set_user_godmode(id,1)
					god[id] = 1				

					
				}
			}
			
			if(floatround(halflife_time()) > ochrona_respa[id] ){
				if(resp[id]==1 ){
					ultra_armor[id] = rem_poc[id]
					fm_set_user_health(id, race_heal[player_class[id]]+player_strength[id]*2)
					if(player_5hp[id]==1) fm_set_user_health(id, 5)
					resp[id]=0
					resp2[id]=0
					set_user_godmode(id,0)
					god[id] = 0
				}
			}
			
		}
	}
	
	
	if (!freeze_ended)
		return PLUGIN_CONTINUE
	
	if(is_user_bot(id) || is_user_alive(id)==0 || !is_user_connected(id)) return PLUGIN_CONTINUE
	new clip,ammo
	new weapon = get_user_weapon(id,clip,ammo)
	
	new button2 = get_user_button(id);
	if (player_class[id] == Mroczny){
		if((button2 & IN_DUCK)){
			if(was_ducking[id]==0){
				ducking_t[id] = floatround(halflife_time())
			}
			was_ducking[id] = 1
		} 
	}
	
	if(player_recoil[id]>0 && random_num(0,player_recoil[id])==0){
		new Float:g_angle[3] = {0.0,0.0,0.0}
		set_pev(id,pev_punchangle,g_angle)
	}

	if(( player_class[id]==Samurai || (player_class[id]==Paladyn  && weapon == CSW_KNIFE )) && freeze_ended) 
	{ 
		if((button2 & IN_DUCK) && (button2 & IN_JUMP)) 
		{ 
			if(ofiara_totem_enta[id] > floatround(halflife_time())){
				set_hudmessage(255, 0, 0, -1.0, 0.01)
				show_hudmessage(id, "Jestes uziemiony")
			}else if(JumpsLeft[id]>0) 
			{ 
				new flags = pev(id,pev_flags) 
				if(flags & FL_ONGROUND) 
				{ 
					set_pev ( id, pev_flags, flags-FL_ONGROUND ) 
					if(czas_rundy + 10 > floatround(halflife_time())){
						set_hudmessage(255, 0, 0, -1.0, 0.01)
						show_hudmessage(id, "Skilla mozesz uzywac 10 sek po starcie rundy")						
						return PLUGIN_HANDLED
					}
					
					JumpsLeft[id]-- 
					jumps[id] = 0
					
					new Float:va[3],Float:v[3] 
					entity_get_vector(id,EV_VEC_v_angle,va) 
					v[0]=floatcos(va[1]/180.0*M_PI)*560.0 
					v[1]=floatsin(va[1]/180.0*M_PI)*560.0 
					v[2]=300.0 
					entity_set_vector(id,EV_VEC_velocity,v) 
					write_hud(id)
				} 
			} 
		} 
	}
	if(( (player_class[id]==Demon  && weapon == CSW_KNIFE )) && freeze_ended) 
	{ 
		if((button2 & IN_DUCK) && (button2 & IN_JUMP)) 
		{ 
			if(ofiara_totem_enta[id] > floatround(halflife_time())){
				set_hudmessage(255, 0, 0, -1.0, 0.01)
				show_hudmessage(id, "Jestes uziemiony")
			}else 
			{ 
				new flags = pev(id,pev_flags) 
				if(flags & FL_ONGROUND) 
				{ 
					set_pev ( id, pev_flags, flags-FL_ONGROUND ) 
					if(czas_rundy + 10 > floatround(halflife_time())){
						set_hudmessage(255, 0, 0, -1.0, 0.01)
						show_hudmessage(id, "Skilla mozesz uzywac 10 sek po starcie rundy")						
						return PLUGIN_HANDLED
					}
					
					jumps[id] = 0
					
					new Float:va[3],Float:v[3] 
					entity_get_vector(id,EV_VEC_v_angle,va) 
					v[0]=floatcos(va[1]/180.0*M_PI)*500.0 
					v[1]=floatsin(va[1]/180.0*M_PI)*500.0 
					v[2]=250.0 
					entity_set_vector(id,EV_VEC_velocity,v) 
					write_hud(id)
				} 
			} 
		} 
	}


	if(flashlight[id] && flashbattery[id] && (get_cvar_num("flashlight_custom")) && (player_class[id] ==  Wysoki || player_class[id] == Ifryt  || player_class[id] == MagL || player_class[id] == Meduza || player_class[id] ==Druid || player_class[id] ==Przywolywacz)) {
		new num1, num2, num3
		num1=random_num(0,2)
		num2=random_num(-1,1)
		num3=random_num(-1,1)
		flashlight_r+=1+num1
		if (flashlight_r>250) flashlight_r-=245
		flashlight_g+=1+num2
		if (flashlight_g>250) flashlight_g-=245
		flashlight_b+=-1+num3
		if (flashlight_b<5) flashlight_b+=240		
		new origin[3];
		get_user_origin(id,origin,3);
		message_begin(MSG_BROADCAST,SVC_TEMPENTITY);
		write_byte(27); // TE_DLIGHT
		write_coord(origin[0]); // X
		write_coord(origin[1]); // Y
		write_coord(origin[2]); // Z
		write_byte(get_cvar_num("flashlight_radius")); // radius
		write_byte(flashlight_r); // R
		write_byte(flashlight_g); // G
		write_byte(flashlight_b); // B
		write_byte(1); // life
		write_byte(get_cvar_num("flashlight_decay")); // decay rate
		message_end();
		
		new index1, bodypart1
		get_user_aiming(id,index1,bodypart1) 
		if(index1>0 && index1<=32){
			if ((get_user_team(id)!=get_user_team(index1)) && (index1!=0) && player_class[index1]!=Ognik)
			{
				if(player_b_szarza_time[index1] > floatround(halflife_time())){}
				else if ((index1!=54) && (is_user_connected(index1))){
					set_user_rendering(index1,kRenderFxGlowShell,flashlight_r,flashlight_g,flashlight_b,kRenderNormal,4)	
					remove_task(TASK_FLASH_LIGHT+index1);
					set_task(7.5, "un_rander",TASK_FLASH_LIGHT+index1)
					Display_Icon(index1 ,ICON_SHOW ,"stopwatch" ,200,0,200)
				}
			}
		}
	}
	
	//Before freeze_ended check
	if (((player_b_silent[id] > 0) || (player_class[id] == Zabojca) ) && is_user_alive(id)) 
		entity_set_int(id, EV_INT_flTimeStepSound, 300)
	
	new Float:vect[3]
	entity_get_vector(id,EV_VEC_velocity,vect)
	new Float: sped= floatsqroot(vect[0]*vect[0]+vect[1]*vect[1]+vect[2]*vect[2])
	if(is_user_alive(id)){
		if((get_user_maxspeed(id)*5)>(sped*9))
			entity_set_int(id, EV_INT_flTimeStepSound, 300)
	}
	
	
	
	if(respawned[id]==1){
		fm_set_user_health(id,5) 
		respawned[id] = 0
	}
	
	if ((!(button2 & IN_RELOAD)) && on_knife[id] && button[id]==1) button[id]=0
	
	
	if (!freeze_ended)
		return PLUGIN_CONTINUE	
	
	if (earthstomp[id] != 0)
	{
		static Float:fallVelocity;
		pev(id,pev_flFallVelocity,fallVelocity);
		if(fallVelocity) falling[id] = true
		else falling[id] = false;
	}
	
	
	if (player_b_jumpx[id] > 0 || player_class[id]==Samurai) Prethink_Doublejump(id)	
	if (player_b_blink2[id] > 0 || player_class[id]==Gon  || player_class[id]==Zmij) Prethink_Blink2(id)	
	if (player_b_usingwind[id] == 1) Prethink_usingwind(id)
	if (player_b_oldsen[id] > 0) Prethink_confuseme(id)
	if (player_b_froglegs[id] > 0) Prethink_froglegs(id)
	
	//USE Button actives USEMAGIC	
	if (get_entity_flags(id) & FL_ONGROUND && 
		(!(button2 & (IN_FORWARD+IN_BACK+IN_MOVELEFT+IN_MOVERIGHT))) &&
		!bow[id] && (on_knife[id] || (player_class[id] == MagL && player_b_fireball[id])) &&
		player_class[id]!=NONE && player_class[id]!=Troll && player_class[id]!=Demon&& player_class[id]!=Heretyk && player_class[id]!=Ghull &&
		player_class[id]!=Nekromanta && invisible_cast[id]==0 && !( player_class[id]==Gon && floatround(halflife_time()) < gonTimer[id]))
	{
		new policz = 0
		
		if(diablo_typ==3) policz = 5
		for (new g=0; g < 33; g++){
			if(policz >= 2) break
			if(is_user_alive(g) && get_user_team(g)==get_user_team(id)){
				policz++
			}
		}
		
		if(graczy < 4) policz =3
		if(  ofiara_totem_enta[id] > floatround(halflife_time())) policz = 0
		if(policz >= 2 && player_iszombie[id]==0){
			if(casting[id]==1 && halflife_time()>cast_end[id])
			{
				message_begin( MSG_ONE, gmsgBartimer, {0,0,0}, id ) 
				write_byte( 0 ) 
				write_byte( 0 ) 
				message_end() 
				casting[id]=0
				call_cast(id)
			}
			else if(casting[id]==0)
			{
				new Float: time_delay = 6.0-(player_intelligence[id]/25.0)-player_chargetime[id]/10.0
				if(time_delay < 0.1) time_delay = 0.1
				if(player_class[id] == Ninja )time_delay*=2.0-(player_intelligence[id]/100.0)-player_chargetime[id]/10.0
				else if(player_class[id] == Ghull )time_delay*=1.5-(player_intelligence[id]/100.0)-player_chargetime[id]/10.0				
				else if(player_class[id] == Wysoki || player_class[id] == Gon)
				{
					time_delay=time_delay = 4.0-(player_intelligence[id]/25.0)-player_chargetime[id]/10.0
				}
				else if(  player_class[id] == Zabojca) time_delay*=1.9-(player_intelligence[id]/75.0)-player_chargetime[id]/10.0
					
				else if(player_class[id] == Samurai){ 
					time_delay=20.0-(player_intelligence[id]/5.0)-player_chargetime[id]/10.0
					if(time_delay < 5.0 - player_chargetime[id]/10.0) time_delay=5.0- player_chargetime[id]/10.0
				}
				else if(player_class[id] == Mnich) time_delay=2.0-(player_intelligence[id]/100.0)-player_chargetime[id]/10.0
				else if(player_class[id] == Drzewiec) time_delay*=2.0-(player_intelligence[id]/50.0)-player_chargetime[id]/10.0
				else if(player_class[id] == Barbarzynca) time_delay*=1.7-(player_intelligence[id]/50.0)-player_chargetime[id]/10.0
					
				else if(player_class[id] == Paladyn ) time_delay*=3.0 -(player_intelligence[id]/100.0)-player_chargetime[id]/10.0 + (golden_bulet[id] * 2)
					
				else if(player_class[id] == Meduza) time_delay*=3.0 -(player_intelligence[id]/50.0)-player_chargetime[id]/10.0
				else if(player_class[id] == MagL) time_delay*=3.0 -(player_intelligence[id]/50.0)-player_chargetime[id]/10.0
				else if(player_class[id] == Zjawa) time_delay*=1.0 -(player_intelligence[id]/50.0)-player_chargetime[id]/10.0
					
				else if(player_class[id] == Strzelec) time_delay*=1.5 - player_chargetime[id]/10.0 - player_intelligence[id]/50.0
					
				else if(player_class[id] == Inkwizytor) time_delay*=1.5 - player_chargetime[id]/10.0 - player_intelligence[id]/50.0
					else if(player_class[id] == Ognik){
					time_delay=10.0 - player_chargetime[id]/10.0 - player_intelligence[id]/25.0
					if(time_delay < 5.0 - player_chargetime[id]/10.0)time_delay = 5.0 - player_chargetime[id]/10.0
				} 
				
				if(time_delay<2.0 - player_chargetime[id]/20.0 && (player_class[id] == Wysoki )) time_delay = 2.0 - player_chargetime[id]/20.0
				if(time_delay<1.1 - player_chargetime[id]/20.0 && (player_class[id] == Drzewiec )) time_delay = 1.1 - player_chargetime[id]/20.0
				if(time_delay<5.0 - player_chargetime[id]/10.0 && (player_class[id] == MagL || player_class[id] == Meduza)) time_delay = 5.0 - player_chargetime[id]/10.0
				
				if(time_delay<0.9) time_delay = 0.9
				cast_end[id]=halflife_time()+time_delay
				
				new bar_delay = floatround(time_delay,floatround_ceil)
				
				casting[id]=1
				
				message_begin( MSG_ONE, gmsgBartimer, {0,0,0}, id ) 
				write_byte( bar_delay ) 
				write_byte( 0 ) 
				message_end() 
			}
		}		
	}
	else 
	{	
		if(casting[id]==1)
		{
			message_begin( MSG_ONE, gmsgBartimer, {0,0,0}, id ) 
			write_byte( 0 ) 
			write_byte( 0 ) 
			message_end() 	
		}
		casting[id]=0			
	}
	
	if (pev(id,pev_button) & IN_RELOAD&& on_knife[id] )		
		Use_Skill(id)

	if(isevent==1){
		if((player_diablo[id]==1 || player_she[id] == 1 )&& player_naladowany2[id]==0){
			fm_set_user_health(id, 18000) 
			player_naladowany2[id]=1
		}
		if(player_diablo[id]==1 && random_num(1,20)==10){
			set_rendering (id, kRenderFxGlowShell, 255,0,0, kRenderFxNone, 10 )
			if(random_num(1,4)==1)efekt_devil(id)
		}
		if(player_she[id]==1 && random_num(1,20)==10){
			
			set_rendering ( id, kRenderFxGlowShell, 255,255,255, kRenderFxNone, 10 )
			if(random_num(1,3)==1) efekt_she(id)
		} 
		if(player_diablo[id]==1 && random_num(1,800)==10){
			
			for(new i=0;i<80;i++){
				new origin[3]
				get_user_origin(id,origin)
				
				message_begin( MSG_BROADCAST,SVC_TEMPENTITY)
				write_byte( TE_SMOKE ) // 5
				write_coord(origin[0]+random_num(-100,100))
				write_coord(origin[1]+random_num(-100,100))
				write_coord(origin[2]+random_num(-100,100))
				write_short( sprite_smoke )
				write_byte( 22 )  // 10
				write_byte( 10 )  // 10
				message_end()
			}
			
		} 
		if (player_she[id]==1 && (halflife_time()-bowdelay[id] > 4) && (pev(id,pev_button) & IN_RELOAD&& on_knife[id] )) event_she_skill(id)
	}
	
	
	
	if(player_diablo[id]> 0)
	{
		if(get_user_button(id) & IN_ATTACK2 && g_FuelTank[id] > 0){
			if((g_Delay[id] + 0.2) < get_gametime())
			{
				g_FuelTank[id] -= 1
				g_Delay[id] = get_gametime()
			}
			new Float:fOrigin[3], Float:fVelocity[3]
			entity_get_vector(id,EV_VEC_origin, fOrigin)
			VelocityByAim(id, 35, fVelocity)
				
			new Float:fTemp[3], iFireOrigin[3]
			xs_vec_add(fOrigin, fVelocity, fTemp)
			FVecIVec(fTemp, iFireOrigin)
				
			new Float:fFireVelocity[3], iFireVelocity[3]
			VelocityByAim(id, 80, fFireVelocity)
			FVecIVec(fFireVelocity, iFireVelocity)
			
			create_flames_n_sounds(id, iFireOrigin, iFireVelocity)
			new doDamage
			
			direct_damage(id, doDamage)
			indirect_damage(id, doDamage)
			show_fuel_percentage(id)
		}
	}
	
	if(player_dziewica[id]>0 ){
		if( player_dziewica_using[id]==1){
			if(random_num(0,5)==0) Effect_Bleed(id,248)
			if(czas_itemu[id]< floatround(halflife_time())){
				czas_itemu[id]= floatround(halflife_time())+2
				cs_set_user_money(id,cs_get_user_money(id)-500)
				Effect_Bleed(id,248)
			}
			if(cs_get_user_money(id) <= 500) player_dziewica_using[id]=0
		}
		else{
			if(random_num(0,200)==0) Effect_Bleed(id,248)
		}
	}
	
	
	
	if (pev(id,pev_button) & IN_USE && !casting[id])
		Use_Spell(id)
	
	
	if(player_class[id]==Ninja || player_class[id]==Zabojca ){
		if((player_class[id]==Ninja) && (pev(id,pev_button) & IN_RELOAD)) command_knife(id) 
		else if (pev(id,pev_button) & IN_RELOAD && on_knife[id] && max_knife[id]>0) command_knife(id) 
	}
	else if( player_class[id]==MagL)
	{	
		if(button2 & IN_ATTACK && on_knife[id] && player_naladowany[id] == 0){
			///////////////////// Fire slash /////////////////////////
			new Float:bonus = float(player_intelligence[id]/5)
			if(bonus > 7.0) bonus = 7.0
			if((bowdelay[id] + 12 - bonus)< get_gametime())
			{
				fired[id]=0
				player_naladowany[id] = 1
				item_fireball(id)
				bowdelay[id] = get_gametime()
				write_hud(id)
			}
		}
	}	
	else if(player_class[id]==Kusznik || player_class[id]==Lucznik || player_class[id]==Heretyk){
		if(player_class[id]==Heretyk){
			if(button2 & IN_ATTACK && on_knife[id]){
				heretyk_skill(id)
			}
		}
		///////////////////// BOW /////////////////////////
		if (button2 & IN_RELOAD && on_knife[id] && button[id]==0 && player_diablo[id]==0 && player_she[id]==0){
			bow[id]++
			button[id] = 1;
			command_bow(id)
		}
		
		new Float:czas = 10.0;
		if(player_class[id]==Kusznik){
			czas = bowdelay[id] + 3.75 - float(player_intelligence[id]/50)
			if(czas<( bowdelay[id] + 1.6)) czas = bowdelay[id] + 1.6
		}
		if(player_class[id]==Lucznik){
			czas = bowdelay[id] + 3.25 - float(player_intelligence[id]/40)
			if(czas<( bowdelay[id] + 0.9)) czas = bowdelay[id] + 0.9
		}

		if(player_class[id]==Heretyk){
			czas = bowdelay[id] + 10.0  - float(player_intelligence[id]/50)
			if(czas<( bowdelay[id] + 4.0)) czas = bowdelay[id] + 4.0
		}
		if(bow[id] == 1)
		{
			
			if(czas<( bowdelay[id] + 0.7)) czas = bowdelay[id] + 0.7
			if(czas< get_gametime() && button2 & IN_ATTACK)
			{
				bowdelay[id] = get_gametime()
				command_arrow(id) 
			}
			entity_set_int(id, EV_INT_button, (button2 & ~IN_ATTACK) & ~IN_ATTACK2)
		}
	}
	if(player_class[id]==Kusznik || player_class[id]==Lucznik){
		// nade
		new clip,ammo
		new weapon = get_user_weapon(id,clip,ammo)	
		if(g_GrenadeTrap[id] && button2 & IN_ATTACK2)
		{
			switch(weapon)
			{
				case CSW_HEGRENADE, CSW_FLASHBANG, CSW_SMOKEGRENADE:
				{
					if((g_PreThinkDelay[id] + 0.28) < get_gametime())
					{
						switch(g_TrapMode[id])
						{
							case 0: g_TrapMode[id] = 1
								case 1: g_TrapMode[id] = 0
							}
						if(czas_rundy + 10 > floatround(halflife_time())){
							g_TrapMode[id] = 1
						}
						client_print(id, print_center, "Grenade Trap %s", g_TrapMode[id] ? "[ON]" : "[OFF]")
						g_PreThinkDelay[id] = get_gametime()
					}
				}
				default: g_TrapMode[id] = 0
			}
		}
		
		
	}
	if(player_gtrap[id]>0){
		
		// nade
		if(button2 & IN_ATTACK2)
		{
			switch(weapon)
			{
				case CSW_HEGRENADE, CSW_FLASHBANG, CSW_SMOKEGRENADE:
				{
					if((g_PreThinkDelay[id] + 0.28) < get_gametime())
					{
						switch(g_TrapMode[id])
						{
							case 0: g_TrapMode[id] = 1
								case 1: g_TrapMode[id] = 0
							}
						if(czas_rundy + 10 > floatround(halflife_time())){
							g_TrapMode[id] = 1
						}
						client_print(id, print_center, "Grenade Trap %s", g_TrapMode[id] ? "[ON]" : "[OFF]")
						g_PreThinkDelay[id] = get_gametime()
					}
				}
				default: g_TrapMode[id] = 0
			}
		}
		
		
	}
	
	
	return PLUGIN_CONTINUE		
}
public UpdateHUDCheck()
{
	//Update HUD for each player
	for (new id=0; id < 33; id++)
	{	
		//If user is not connected, don't do anything
		if (!is_user_connected(id)) continue;				
		if((cs_get_user_team(id) != CS_TEAM_T && cs_get_user_team(id) != CS_TEAM_CT) || is_user_alive(id) == 0)
		{
			user_kill(id,1)	
		}
		
		if (!is_user_alive(id)) continue;
		
		if(player_b_tarczaograon[id]==1 ){
			if(random_num(0,2)==1){
				if(czas_itemu[id]<floatround(halflife_time())){
					player_b_tarczaograon[id] = 0
					set_renderchange(id)
					set_speedchange(id)
				}
			}
		}
		
		if(player_class[id]==Zjawa){
			if(skill_time[id] < floatround(halflife_time())){
				player_naladowany[id] = 0
				ghoststate[id] = 0
				write_hud(id)
			}
		}
		else if(player_class[id]==Druid || player_class[id]==Meduza || player_class[id]==Wysoki || player_class[id]==Ifryt || player_class[id]==Heretyk){
			if(skill_time[id] < floatround(halflife_time())){
				player_naladowany[id] = 0
				write_hud(id)
			}
		}
		else if( player_class[id]==MagL)
		{	
			if(player_naladowany[id] == 1){
				new Float:bonus = float(player_intelligence[id]/5)
				if(bonus > 7.0) bonus = 7.0	
				if((bowdelay[id] + 12 - bonus)< get_gametime()){
					player_naladowany[id] = 0
					write_hud(id)
				}				
			}
		}
	}

}


public client_PostThink( id )
{
	if (player_b_jumpx[id] > 0 || player_class[id]==Samurai) Postthink_Doubeljump(id)
	if (earthstomp[id] != 0 && is_user_alive(id))
	{
		if (!falling[id]) add_bonus_stomp(id)
		else set_pev(id,pev_watertype,-3)
	}
	//update_models_body(id)
}

public client_AddToFullPack(ent_state,e,edict_t_ent,edict_t_host,hostflags,player,pSet) 
{
	//No players need this rather cpu consuming function - dont run
	if (!use_addtofullpack)
		return FMRES_HANDLED
	
	if (!pev_valid(e)|| !pev_valid(edict_t_ent) || !pev_valid(edict_t_host))
		return FMRES_HANDLED
	
	new classname[32]
	pev(e,pev_classname,classname,31)
	
	new hostclassname[32]
	pev(edict_t_host,pev_classname,hostclassname,31)
	
	
	if (equal(classname,"player") && equal(hostclassname,"player") && player)
	{
		// only take effect if both players are alive & and not somthing else like a ladder
		if (is_user_alive(e) && is_user_alive(edict_t_host) && e != edict_t_host) 
		{
			//host looks at e
			if (HasFlag(e,Flag_Illusion))
				return FMRES_SUPERCEDE
			
			//E Is looking at t and t has the flag
			if (HasFlag(edict_t_host,Flag_Illusion))
				return FMRES_SUPERCEDE			
		}
		
	}
	
	return FMRES_HANDLED
	
}

/* FUNCTIONS ====================================================================================== */


// DODAWANIE STATÓW

public skilltree(id)
{
	new text[513] 
	new keys = (1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<4)|(1<<5)|(1<<6)|(1<<7)
	
	
	formatex(text, 512, "\yWybierz Staty- \rPunkty: %i^n^n\w1. Inteligencja [%i] [Wieksze obrazenia czarami]^n\w2. Sila [%i] [Wiecej zycia]^n\w3. Zrecznosc [%i] [Bronie zadaja ci mniejsze obrazenia]^n\w4. Zwinnosc [%i] [Szybciej biegasz i magia zadaje ci mniejsze obrazenia]^n\w5. 25 w Inteligencje ^n\w6. 25 w Sile ^n\w7. 25 w Zrecznosc ^n\w8. 25 w Zwinosc",player_point[id],player_intelligence[id],player_strength[id],player_agility[id],player_dextery[id]) 
	
	keys = (1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<4)|(1<<5)|(1<<6)|(1<<7)
	show_menu(id, keys, text) 
	return PLUGIN_HANDLED  
} 


public skill_menu(id, key) 
{ 
	new max_skill= 30000
	diablo_typ = get_cvar_num("diablo_typ")
	if(diablo_typ==2) max_skill = 50
	switch(key) 
	{ 	
		case 0: 
		{	
			if (player_intelligence[id]<max_skill){
				player_point[id]-=1
				player_intelligence[id]+=1
			}
			else client_print(id,print_center,"Maxymalny poziom inteligencji osiagniety")
			
		}
		case 1: 
		{	
			if (player_strength[id]<max_skill){
				player_point[id]-=1	
				player_strength[id]+=1
			}
			else client_print(id,print_center,"Maxymalny poziom sily osiagniety")
		}
		case 2: 
		{	
			if (player_agility[id]<max_skill){
				player_point[id]-=1
				player_agility[id]+=1
				recalculateDamRed(id)
			}
			else client_print(id,print_center,"Maxymalny poziom zrecznosci osiagniety")
			
		}
		case 3: 
		{	
			if (player_dextery[id]<max_skill){
				player_point[id]-=1
				player_dextery[id]+=1
				set_speedchange(id)
				dexteryDamRedCalc(id)
			}
			else client_print(id,print_center,"Maxymalny poziom zwinnosci osiagniety")
		}
		case 4: 
		{	
			if(diablo_typ==2){
				if(	player_point[id]>=25){
					if(player_intelligence[id] + 25 < max_skill){
						player_intelligence[id]+=25
						player_point[id]-=25
					}
					else{
						client_print(id,print_center,"Nie mozesz dodac wiecej!")
					}
					
				}
				else{
					if(player_intelligence[id] + player_point[id] < max_skill){
						player_intelligence[id]+=player_point[id]
						player_point[id] = 0
					}
					else{
						client_print(id,print_center,"Nie mozesz dodac wiecej!")
					}
					
				}
			}
			if(diablo_typ==1 || diablo_typ==3){
				if(	player_point[id]>=25){
					player_intelligence[id]+=25
					player_point[id]-=25
				}
				else{
					player_intelligence[id]+=player_point[id]
					player_point[id] = 0
				}
			}
			
		}
		case 5: 
		{	
			if(diablo_typ==2){
				if(	player_point[id]>=25){
					if(player_strength[id] + 25 < max_skill){
						player_strength[id]+=25
						player_point[id]-=25
					}
					else{
						client_print(id,print_center,"Nie mozesz dodac wiecej!")
					}
					
				}
				else{
					if(player_strength[id] + player_point[id] < max_skill){
						player_strength[id]+=player_point[id]
						player_point[id] = 0
					}
					else{
						client_print(id,print_center,"Nie mozesz dodac wiecej!")
					}
					
				}
			}
			if(diablo_typ==1 || diablo_typ==3){
				if(player_point[id]>=25){
					player_strength[id]+=25
					player_point[id]-=25
				}
				else{
					player_strength[id]+=player_point[id]
					player_point[id] = 0
				}
			}
			
			
		}
		case 6: 
		{	
			if(diablo_typ==2){
				if(	player_point[id]>=25){
					if(player_agility[id] + 25 < max_skill){
						player_agility[id]+=25
						player_point[id]-=25
					}
					else{
						client_print(id,print_center,"Nie mozesz dodac wiecej!")
					}
					
				}
				else{
					if(player_agility[id] + player_point[id] < max_skill){
						player_agility[id]+=player_point[id]
						player_point[id] = 0
					}
					else{
						client_print(id,print_center,"Nie mozesz dodac wiecej!")
					}
					
				}
			}
			if(diablo_typ==1 || diablo_typ==3){
				if(player_point[id]>=25){
					player_agility[id]+=25
					player_point[id]-=25
				}
				else{
					player_agility[id]+=player_point[id]
					player_point[id] = 0
				}
			}
			
			recalculateDamRed(id)
			
		}
		case 7: 
		{	
			if(diablo_typ==2){
				if(	player_point[id]>=25){
					if(player_dextery[id] + 25 < max_skill){
						player_dextery[id]+=25
						player_point[id]-=25
						dexteryDamRedCalc(id)
					}
					else{
						client_print(id,print_center,"Nie mozesz dodac wiecej!")
					}
					
					
				}
				else{
					if(player_dextery[id] + player_point[id] < max_skill){
						player_dextery[id]+=player_point[id]
						player_point[id] = 0
						dexteryDamRedCalc(id)
					}
					else{
						client_print(id,print_center,"Nie mozesz dodac wiecej!")
					}
					
				}
			}
			if(diablo_typ==1 || diablo_typ==3){
				if(player_point[id]>=25){
					player_dextery[id]+=25
					player_point[id]-=25
				}
				else{
					player_dextery[id]+=player_point[id]
					player_point[id] = 0
				}
			}
			
			
			set_speedchange(id)
		}
	}
	
	if (player_point[id] > 0) 
		skilltree(id)
	
	
	return PLUGIN_HANDLED
}


/* ==================================================================================================== */

public show_deadmessage(killer_id,victim_id,headshot,weaponname[])
{
	if (!(killer_id==victim_id && !headshot && equal(weaponname,"world")))
	{
		message_begin( MSG_ALL, gmsgDeathMsg,{0,0,0},0)
		write_byte(killer_id)
		write_byte(victim_id)
		write_byte(headshot)
		write_string(weaponname)
		message_end()
	}
}

/* ==================================================================================================== */

public got_bomb(id){ 
	planter = id; 
	return PLUGIN_CONTINUE 
} 

stock GetPlayersNum( CsTeams:iTeam ) {
	new iNum;
	for( new i = 1; i <= get_maxplayers( ); i++ ) {
		if( is_user_connected( i ) && cs_get_user_team( i ) == iTeam )
			iNum++;
	}
	return iNum;
}




public eT_win()
{
	if(rounds > 0 && rounds < 99)
	{
		round_won_by[rounds]=CS_TEAM_T
	}
	count_avg_lvl()
	new pln = get_playersnum() 
	if(pln > 12) pln  = 12
	new exp = get_cvar_num("diablo_xpbonus2") * pln /5
	new przenies = 0
	if((( rounds < 3 && ttw > ctwS)|| ttw > ctwS + 1) && pln > 6)
	{
		przenies++
	}
	
	for (new i=0; i<33; i++) 
	{
		new id = i
		if(!is_user_connected(id) || is_user_hltv(id)) continue;
		if(cs_get_user_team(id) == CS_TEAM_CT  || cs_get_user_team(id) == CS_TEAM_SPECTATOR || cs_get_user_team(id) == CS_TEAM_UNASSIGNED) continue;
		exp = calc_award_goal_xp(id,exp,0)
		Give_Xp(id,exp)	
		client_print(id,print_chat,"Dostales *%i* doswiadczenia za wygranie rundy",xp_mnoznik(id, exp))
		player_wys[id]=1
	}
	new maxLvlPlayer = -1;	
	for(new i=0; i < 33; i++){
		if(!is_user_connected(i)) continue;
		if(cs_get_user_team(i) == CS_TEAM_CT  || cs_get_user_team(i) == CS_TEAM_SPECTATOR || cs_get_user_team(i) == CS_TEAM_UNASSIGNED) continue;
		if(player_lvl[i] <= 5) continue;
		
		if(maxLvlPlayer == -1){
			maxLvlPlayer = i;
		}
		
		if(player_lvl[i] > player_lvl[maxLvlPlayer]) maxLvlPlayer = i
	}
	
	new minLvlPlayer = -1;	
	for(new i=0; i < 33; i++){
		if(!is_user_connected(i)) continue;
		if(cs_get_user_team(i) == CS_TEAM_T  || cs_get_user_team(i) == CS_TEAM_SPECTATOR || cs_get_user_team(i) == CS_TEAM_UNASSIGNED) continue;
		if(player_lvl[i] <= 5) continue;
		
		if(minLvlPlayer == -1){
			minLvlPlayer = i;
		}
		
		if(player_lvl[i] < player_lvl[minLvlPlayer]) minLvlPlayer = i
	}
	
	if(przenies && maxLvlPlayer > 0)
	{
		cs_set_user_team (maxLvlPlayer,CS_TEAM_CT, CS_DONTCHANGE)
		new  name[32]
		get_user_name(maxLvlPlayer, name, 31) 
		client_print(0,print_chat,"%s przeniesiony do CT",name)
		if(przenies && minLvlPlayer > 0 && GetPlayersNum(CS_TEAM_CT) > GetPlayersNum(CS_TEAM_T))
		{
			cs_set_user_team (minLvlPlayer,CS_TEAM_T, CS_DONTCHANGE)
			new  name[32]
			get_user_name(minLvlPlayer, name, 31) 
			client_print(0,print_chat,"%s przeniesiony do TT",name)
		}
	}

}


public eCT_win()
{
	if(rounds > 0 && rounds < 99)
	{
		round_won_by[rounds]=CS_TEAM_CT
	}
	count_avg_lvl()
	new pln = get_playersnum() 
	if(pln > 12) pln  = 12
	new exp = get_cvar_num("diablo_xpbonus2") * pln /3
	new przenies = 0
	if((( rounds < 3 && ctw > ttwS)|| ctw > ttwS + 1) && pln > 6)
	{
		przenies++
	}
	for (new i=0; i<33; i++) 
	{
		new id = i
		if(!is_user_connected(id) || is_user_hltv(id)) continue;
		if(cs_get_user_team(id) == CS_TEAM_T  || cs_get_user_team(id) == CS_TEAM_SPECTATOR || cs_get_user_team(id) == CS_TEAM_UNASSIGNED) continue;
		exp = calc_award_goal_xp(id,exp,0)
		Give_Xp(id,exp)	
		client_print(id,print_chat,"Dostales *%i* doswiadczenia za wygranie rundy",xp_mnoznik(id, exp))
		player_wys[id]=1
	}
	new maxLvlPlayer = -1;		
	for(new i=0; i < 33; i++){
		if(!is_user_connected(i)) continue;
		if(cs_get_user_team(i) == CS_TEAM_T  || cs_get_user_team(i) == CS_TEAM_SPECTATOR || cs_get_user_team(i) == CS_TEAM_UNASSIGNED) continue;
		if(player_lvl[i] <= 5) continue;
		
		if(maxLvlPlayer == -1){
			maxLvlPlayer = i;
		}
		
		if(player_lvl[i] > player_lvl[maxLvlPlayer]) maxLvlPlayer = i
	}
	
	new minLvlPlayer = -1;	
	for(new i=0; i < 33; i++){
		if(!is_user_connected(i)) continue;
		if(cs_get_user_team(i) == CS_TEAM_CT  || cs_get_user_team(i) == CS_TEAM_SPECTATOR || cs_get_user_team(i) == CS_TEAM_UNASSIGNED) continue;
		if(player_lvl[i] <= 5) continue;
		
		if(minLvlPlayer == -1){
			minLvlPlayer = i;
		}
		
		if(player_lvl[i] < player_lvl[minLvlPlayer]) minLvlPlayer = i
	}
	
	if(przenies && maxLvlPlayer > 0)
	{
		cs_set_user_team (maxLvlPlayer,CS_TEAM_T, CS_DONTCHANGE)
		new  name[32]
		get_user_name(maxLvlPlayer, name, 31) 
		client_print(0,print_chat,"%s przeniesiony do TT",name)
		if(przenies && minLvlPlayer > 0 && GetPlayersNum(CS_TEAM_T) > GetPlayersNum(CS_TEAM_CT))
		{
			cs_set_user_team (minLvlPlayer,CS_TEAM_CT, CS_DONTCHANGE)
			new  name[32]
			get_user_name(minLvlPlayer, name, 31) 
			client_print(0,print_chat,"%s przeniesiony do CT",name)
		}
	}
}
public award_esc()
{
	count_avg_lvl()
	new pln = get_playersnum() 
	if(pln > 12) pln  = 12
	new exp = get_cvar_num("diablo_xpbonus2") * pln  / 2
	for (new i=0; i<33; i++) 
	{
		new id = i
		if(!is_user_connected(id)) continue;
		if(!is_user_alive(id)) continue;
		if(cs_get_user_team(id) == CS_TEAM_T) continue;
		exp = calc_award_goal_xp(id,exp, 0)
		Give_Xp(id,exp)	
		client_print(id,print_chat,"Dostales *%i* doswiadczenia za ucieczke vipa",xp_mnoznik(id, exp))
		player_wys[id]=1
	}	
}
public award_plant()
{
	if( target_plant != 0){
		client_print(0,print_console,"Bomba byla juz podlozona")
		return
	} 
	target_plant = 1
	count_avg_lvl()
	g_carrier=0
	new pln = get_playersnum() 
	if(pln > 12) pln  = 12
	new exp = get_cvar_num("diablo_xpbonus2") * pln  / 2
	for (new i=0; i<33; i++) 
	{
		new id = i
		if(!is_user_connected(id)) continue;
		if(!is_user_alive(id)) continue;
		if(cs_get_user_team(id) == CS_TEAM_CT) continue;
		exp = calc_award_goal_xp(id,exp, 0)
		Give_Xp(id,exp)	
		client_print(id,print_chat,"Dostales *%i* doswiadczenia za polozenie bomby przez twoj team",xp_mnoznik(id, exp))
		player_wys[id]=1
	}	
	closeXp(planter)
}


public bomb_defusing(id){ 
	new entlist[513]
	defuser = id;
	if(!is_user_connected(id)) return PLUGIN_CONTINUE;
	new numfound = find_sphere_class(defuser,"player",1000.0,entlist,512)
	for (new i=0; i < numfound; i++)
	{		
		new pid = entlist[i]
		if(!is_user_connected(pid)) continue;
		if(!is_user_alive(pid)) continue;
		client_cmd(pid,"mp3 play sound/misc/defusing.mp3")						
	}
	return PLUGIN_CONTINUE;
} 


public award_defuse()
{
	if( target_def != 0) return
	target_def = 1
	count_avg_lvl()
	new pln = get_playersnum() 
	if(pln > 12) pln  = 12
	new exp = get_cvar_num("diablo_xpbonus2") * pln  *3/5
	for (new i=0; i<33; i++) 
	{
		new id = i
		if(!is_user_connected(id)) continue;
		if(!is_user_alive(id)) continue;
		if(cs_get_user_team(id) == CS_TEAM_T) continue;
		exp = calc_award_goal_xp(id,exp, 0)
		Give_Xp(id,exp)
		client_print(id,print_chat,"Dostales *%i* doswiadczenia za rozbrojenie bomby przez twoj team",xp_mnoznik(id, exp))
		player_wys[id]=1
	}
	closeXp(defuser)
}

public award_hostageALL(id)
{
	count_avg_lvl()
	new pln = get_playersnum() 
	if(pln > 12) pln  = 12
	new exp = get_cvar_num("diablo_xpbonus2") * pln  / 3
	for (new i=0; i<33; i++) 
	{
		new id = i
		if(!is_user_connected(id)) continue;
		if(!is_user_alive(id)) continue;
		if(cs_get_user_team(id) == CS_TEAM_T) continue;
		exp = calc_award_goal_xp(id,exp, 0)
		Give_Xp(id,exp)
		client_print(id,print_chat,"Dostales *%i* doswiadczenia za wyprowadzenie zakladnikow przez twoj team",xp_mnoznik(id, exp))
		player_wys[id]=1
	}	
}

public closeXp(id)
{
	new entlist[513]
	if(!is_valid_ent(id)) return;
	new numfound = find_sphere_class(id,"player",500.0,entlist,512)
	new pln = get_playersnum() 
	if(pln > 12) pln  = 12			
	for (new i=0; i < numfound; i++)
	{		
		new pid = entlist[i]
		
		if (!is_user_alive(pid) || get_user_team(id) != get_user_team(pid) || cs_get_user_team(pid) == CS_TEAM_SPECTATOR )
			continue
		
		
		if(pid == id){
			new exp = get_cvar_num("diablo_xpbonus2") * pln  / 3
			client_print(pid,print_chat,"Dostales *%i* doswiadczenia za cele mapy",xp_mnoznik(id, exp))
			player_wys[pid]=1
			Give_Xp(pid,exp)
			award_item(pid, 0)
		}else{
			new exp = get_cvar_num("diablo_xpbonus2") * pln   / 5
			client_print(pid,print_chat,"Dostales *%i* doswiadczenia za asyste lidera",xp_mnoznik(id, exp))
			player_wys[pid]=1
			Give_Xp(pid,exp)
		}
		
	}
}
/* ==================================================================================================== */


public award_kill(killer_id,victim_id)
{
	changeskin(victim_id,1)	
	if (!is_user_connected(killer_id) || !is_user_connected(victim_id))
		return PLUGIN_CONTINUE
		
	if(player_diablo[victim_id]==1 || player_she[victim_id]==1){
		efekt_kill(victim_id);
		dropitem(victim_id)
		Give_Xp(killer_id,1000)
		player_wys[killer_id]=1
		player_diablo[victim_id]=0
		player_she[victim_id]=0
		isevent=0
		isevent_team=0  
		for(new a=0;a<32;a++){
			if(is_user_alive(a) && get_user_team(victim_id)==get_user_team(a)) client_cmd(a,"kill") 
		}
	}
	if(player_diablo[killer_id]> 0)
	{
		g_FuelTank[killer_id] += 20
	}
	
	
	if(player_class[killer_id]==Heretyk){
		set_user_armor(killer_id,get_user_armor(killer_id)+100)
	}
	if(player_class[killer_id]==Strzelec){
		change_health(killer_id,10 + player_intelligence[killer_id]/10,0,"world")	
	}
	last_attacker[victim_id] = 0
	if(endless[victim_id]>0){
		endlessranks(victim_id)
	}
	
	if(player_class[victim_id] == Ifryt && player_lvl[victim_id] > prorasa) feniksRes(victim_id)
	
	if(player_lvl[killer_id]>prorasa && player_class[killer_id] == Ninja){
		player_b_szarza_time[killer_id] = floatround(halflife_time()) + 5
		un_rander(TASK_FLASH_LIGHT+killer_id)
		RemoveFlag(killer_id,Flag_Dazed)
		RemoveFlag(killer_id,Flag_Ignite)
		ofiara_totem_enta[killer_id] = 0
		ofiara_totem_lodu[killer_id] = 0
		new svIndex[32] 
		num_to_str(killer_id,svIndex,32)
		Display_Icon(killer_id ,ICON_SHOW ,"dmg_cold" ,0,0,255)
		set_task(0.1,"task_koniec",0,svIndex,32) 	
		Display_Icon(killer_id ,ICON_SHOW ,"dmg_cold" ,0,255,0)
		set_task(0.1,"task_koniec",0,svIndex,32) 	
		set_speedchange(killer_id)
		set_renderchange(killer_id)	
	}
	
	if(player_class[killer_id] == Kuroliszek && player_lvl[killer_id] > prorasa){
		new button2 = get_user_button(killer_id);
		if(button2 & IN_DUCK) teleporesp(killer_id)
	}
	if(player_class[victim_id] == Zmij && player_lvl[victim_id] > prorasa  && on_knife[victim_id]){
		new expl = 200	
		new origin[3] 
		get_user_origin(victim_id,origin) 
		explode(origin,victim_id,0)		
		
		for(new a = 0; a < MAX; a++) 
		{ 
			if (!is_user_connected(a) || !is_user_alive(a) || player_b_fireshield[a] != 0 ||  get_user_team(a) == get_user_team(victim_id))
				continue	
			
			new origin1[3]
			get_user_origin(a,origin1) 
			
			if(get_distance(origin,origin1) < expl)
			{
				new dam = 5-(player_dextery[a]*50)
				if(dam<1) dam = 1
				if(! HasFlag(a, Flag_truc)){
					Effect_waz(a,victim_id,dam)
					hudmsg(a,3.0,"Jestes zatruty!")
				}			
			}
		}
	}
	
	if(player_zombie_killer[killer_id]>0 && random_num(1, player_zombie_killer[killer_id])==1)my_zombie(victim_id, killer_id)
	if(player_przesz[killer_id]>0){
		Przesz(killer_id, victim_id)
	}
	if(zombie_owner[victim_id]>0 &&  endless[zombie_owner[victim_id]]==0){
		if(old_team[victim_id]==CS_TEAM_T || old_team[victim_id]==CS_TEAM_CT)cs_set_user_team (victim_id,old_team[victim_id], CS_DONTCHANGE)
		zombie_owner[victim_id]=0
	}
	
	if(player_class[killer_id]==Gon && player_lvl[killer_id] > prorasa){
		player_timed_inv[killer_id] = halflife_time() + 2.0
		set_renderchange(killer_id);
		set_task(2.0, "set_renderchange", killer_id)
		set_task(2.2, "set_renderchange", killer_id)
	}
	
	if(player_class[killer_id]==Demon){

		
		if(player_nal[killer_id] < 5){
			if(player_nal[killer_id] <= floatround(player_intelligence[killer_id]/10.0) ){
				player_nal[killer_id]++
			}
		} else{
			if(player_nal[killer_id]==5 && player_intelligence[killer_id]>= 100) player_nal[killer_id]++
			if(player_nal[killer_id]==6 && player_intelligence[killer_id]>= 150) player_nal[killer_id]++
		}
		
		if(player_nal[killer_id]>= 5 && player_lvl[killer_id] > prorasa){
			player_timed_inv[killer_id] = halflife_time() + 1.0
			set_renderchange(killer_id);
			set_task(1.0, "set_renderchange", killer_id)
			set_task(1.2, "set_renderchange", killer_id)
		}	
	}
	
	
	new xp_award = get_cvar_num("diablo_xpbonus")
	add_respawn_bonus(victim_id)
	add_bonus_explode(victim_id)
	add_barbarian_bonus(killer_id)
	RemoveFlag(victim_id,Flag_Ignite)
	RemoveFlag(victim_id,Flag_truc)
	
	new Team[32]
	get_user_team(killer_id,Team,31)
	
	if (moreLvl(victim_id, killer_id) > 25 && get_playersnum() > 6) 
		xp_award+=get_cvar_num("diablo_xpbonus")/4 + (get_cvar_num("diablo_xpbonus")/10 * moreLvl(victim_id, killer_id) / 10)
	
	if (moreLvl(victim_id, killer_id) < -25) 
		xp_award-=get_cvar_num("diablo_xpbonus")/4
	
	if (moreLvl(victim_id, killer_id) < -75) 
		xp_award-=get_cvar_num("diablo_xpbonus")/4
	
	if (moreLvl(victim_id, killer_id) < -150) 
		xp_award-=get_cvar_num("diablo_xpbonus")/4
	
	
	xp_award = xp_award * lvl_dif_xp_mnoznik[victim_id][killer_id]  / 100	
	new ser = seria[victim_id]
	seria[victim_id] = 0
	seria[killer_id] += 1
	if(ser > 0 && get_playersnum() > 8){
		if(ser>10) ser = 10
		new sName[32];
		get_user_name(victim_id, sName, sizeof sName - 1);
		new bon = (ser * 10 * xp_award / 100) + 10 * ser
		if(get_playersnum() > 10) bon = (ser * 20 * xp_award / 100)+ 20 * ser
		if(get_playersnum() > 15) bon = (ser * 25 * xp_award / 100)+ 25 * ser
		if(get_playersnum() > 20) bon = (ser * 50 * xp_award / 100)+ 50 * ser
		xp_award = xp_award + bon
		if(tutOn && ser > 3 && tutor[killer_id]) tutorMake(killer_id,TUTOR_YELLOW,2.0, "Przerywasz serie  %s + %d XP", sName, bon);
	}
	if(xp_award<1)xp_award =1 
	
	Give_Xp(killer_id,xp_award)
	player_wys[killer_id]=1
	last_attacker[victim_id] = 0
	new iKiller = killer_id;
	new iVictim = victim_id;
 
 
	if(IsPlayer(iKiller) && IsPlayer(iVictim) && iKiller != iVictim && get_playersnum() > 6){
		g_iZemsta[iVictim] = iKiller;
 		
		new sName[32];
		get_user_name(iVictim, sName, sizeof sName - 1);
 
		if(g_iZemsta[iKiller] && g_iZemsta[iKiller] == iVictim){
			new xp_award = get_cvar_num("diablo_xpbonus")
			
			if (moreLvl(iVictim, iKiller)> 25 && get_playersnum() > 6) 
				xp_award+=get_cvar_num("diablo_xpbonus")/4 + (get_cvar_num("diablo_xpbonus")/10 * moreLvl(iVictim, iKiller) / 10)
				
			if (moreLvl(iVictim, iKiller) < -25) 
				xp_award-=get_cvar_num("diablo_xpbonus")/4
				
			xp_award = xp_award * lvl_dif_xp_mnoznik[iVictim][iKiller] / 100	
			xp_award = xp_award / 7
			if(xp_award<1)xp_award =1 
			Give_Xp(iKiller,xp_award)
 
			if(tutOn && tutor[iKiller])tutorMake(iKiller,TUTOR_YELLOW,2.0, "Zemsta na %s + %d XP", sName, xp_award);
 
			g_iZemsta[iKiller] = 0;
		}
 
		for(new i = 0 ; i <= MAX; i ++){
			if(i == iKiller)	continue;
			 
			if(g_bAsysta[i][iVictim]){	
				new xp_award = get_cvar_num("diablo_xpbonus")
			
				if (moreLvl(iVictim, i)> 25 && get_playersnum() > 6) 
					xp_award+=get_cvar_num("diablo_xpbonus")/4 + (get_cvar_num("diablo_xpbonus")/10 * moreLvl(iVictim, i) / 10)
					
				if (moreLvl(iVictim, i) < -25) 
					xp_award-=get_cvar_num("diablo_xpbonus")/4
					
				xp_award = xp_award * lvl_dif_xp_mnoznik[iVictim][i] / 100	
				xp_award = xp_award / 2
				if(xp_award<1)xp_award =1 
				Give_Xp(i,xp_award)
				
				if(tutOn && tutor[i])tutorMake(i,TUTOR_YELLOW,2.0, "Asysta na %s + %d XP", sName, xp_award);
			}
 
			g_bAsysta[i][iVictim] = false;
		}
	}
	return PLUGIN_CONTINUE
}
stock valid_steam(steamid[])
{
	if (equal("4294967295", steamid)
	|| equal("STEAM_666:88:666", steamid)
	|| equal("STEAM_154:88:666", steamid)
	|| equal("unknown", steamid)
	|| equal("HLTV", steamid)
	|| equal("STEAM_ID_LAN", steamid)
	|| equal("VALVE_ID_LAN", steamid)
	|| equal("VALVE_ID_PENDING", steamid)
	|| equal("STEAM_ID_PENDING", steamid)
	|| equal("", steamid)
	|| strlen(steamid) > 19
	|| (containi(steamid, "STEAM_0:1")<0 && containi(steamid, "STEAM_0:0")<0)
	)
		return 0
	
	return 1
}


public xp_mnoznik_v(id)
{
	new itemEffect[500]
	add(itemEffect,499,"Masz")
	if(get_user_flags(id) & ADMIN_LEVEL_D || player_vip[id]==1){
		add(itemEffect,499," vip [+30 proc expa]")
	}
	else if(get_user_flags(id) & ADMIN_LEVEL_C || player_vip[id]==2){
		add(itemEffect,499," vip pro [+60 proc expa]")
	}
	else if(player_vip[id]==3){
		add(itemEffect,499," xp boost [+50 proc expa]")
	}
	if(get_user_flags(id) & ADMIN_BAN){
		add(itemEffect,499," admin [+5 proc expa]")
	}
	if(steams > 0){
		new TempSkill[11]
		add(itemEffect,499," ilosc steamow [+")
		num_to_str(steams,TempSkill,10)
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," proc expa]")
	}
	if(u_sid[id] > 0 && player_sid_pass[id][0]){
		add(itemEffect,499," steam [+80 proc expa]")
	}else if(u_sid[id] > 0){
		add(itemEffect,499," steam [+75 proc expa]")
	}else{
		client_print(id,print_chat, "Graj na steam: bonus 30 proc expa")
	}
	if(player_pass_pass[id][0]){
		add(itemEffect,499," haslo [+5 proc expa]")
	}
	if(tutOn && tutor[id] && strlen(itemEffect)>10)tutorMake(id,TUTOR_GREEN,5.0,itemEffect)

	if(player_lvl[id] >75 && !player_sid_pass[id][0] && !player_pass_pass[id][0]) {
		if(tutOn && tutor[id])tutorMake(id,TUTOR_RED,5.0,"-50 poc expa za brak darmowej rezerwacji")
	}
	//client_print(id,print_chat, itemEffect)
}


public xp_mnoznik_v2(id)
{
	if(!is_user_connected(id))return
	if(player_class[id] == 0) return
	
	new mn = 100;
	if(get_user_team(id) == 2) mn = CT_mnoznik_expa
	if(get_user_team(id) == 1) mn = TT_mnoznik_expa
	
	if(mn<100 && tutOn && tutor[id] && get_playersnum() > 5)
	{
		new g_string[64]
		formatex(g_string, 63, "-%d procent exp za gre w wygrywajacej druzynie [TT %i:%i CT]",  100 - mn, ttw,  ctw)
		tutorMake(id,TUTOR_RED,5.5,g_string)
	}
	else if(CT_mnoznik_expa == 100 && TT_mnoznik_expa == 100 && tutOn && tutor[id] && get_playersnum() > 5)
	{
		new g_string[64]
		formatex(g_string, 63, "+25 procent exp za rowne teamy [TT %i:%i CT]",  ttw,  ctw)
		tutorMake(id,TUTOR_GREEN,5.5,g_string)
	}
	
}

public xp_mnoznik_v3(id)
{
	if(!is_user_connected(id))return
	if(player_class[id] == 0) return
	

	if(player_samelvl[id]>0 && tutOn && tutor[id])
	{
		new g_string[64]
		formatex(g_string, 63, "+%i procent exp za klasy o podobnym lvlu",  player_samelvl[id]*2)
		tutorMake(id,TUTOR_GREEN,5.5,g_string)
	}
	
}

new Float:xpStandardMnoznik[33] = 1.0;
new Float:xpStandardMnoznik2[33] = 1.0;
public xp_mnoznik_wylicz(id)
{
	if(!is_user_connected(id))return
	if(player_class[id] == 0){
		xpStandardMnoznik[id] = 0.0;
		xpStandardMnoznik2[id] = 0.0;
		return
	}
	new Float:amount = 100.0;
	new Float:amount2 = 100.0;
	if(is_user_alive(id) && get_playersnum() > 5){
		new mn = 100;
		if(get_user_team(id) == 2) mn = CT_mnoznik_expa
		if(get_user_team(id) == 1) mn = TT_mnoznik_expa
		
		if(mn <100) amount = amount * mn / 100.0;
		else if(CT_mnoznik_expa == 100 && TT_mnoznik_expa == 100) amount = amount * 125.0 / 100.0;
	}
	
	if(get_user_flags(id) & ADMIN_LEVEL_D || player_vip[id]==1){
		amount = (1.3*amount)
		
	}
	else if(get_user_flags(id) & ADMIN_LEVEL_C || player_vip[id]==2){
		amount = (1.6*amount)
	}
	else if(player_vip[id]==3){
		amount = (1.5*amount)
	}
	
	if(steams > 0){
		new Float:sss = 1.0 + (steams/100.0)
		amount = (sss*amount)
	}
	if(get_user_flags(id) & ADMIN_BAN){
		amount = (1.05*amount)
	}
	
	if(player_samelvl[id]>0){
		amount = (player_samelvl[id]*2*amount)/100 + amount
	}
	if(u_sid[id] == 0){
		amount = (0.7*amount)
	}
	
	if(u_sid[id] > 0){
		amount = (1.5*amount)
	}else if(player_lvl[id]> 100){
		amount = (0.5*amount)
	}
	if(player_sid_pass[id][0]){
		amount = (1.05*amount)
	}
	if(player_pass_pass[id][0]){
		amount = (1.05*amount)
	}
	if(player_lvl[id] >100 && !player_sid_pass[id][0] && !player_pass_pass[id][0]) amount = (0.5*amount)
	
	if(player_class[id]==Mnich) amount = (2.0*amount)
	if(get_playersnum() > 25 && diablo_redirect < 4)
	{
		if(get_playersnum() > 26) amount = (1.1*amount)
		if(get_playersnum() > 27) amount = (1.2*amount)
		if(get_playersnum() > 28) amount = (1.2*amount)
		if(get_playersnum() > 29) amount = (1.2*amount)
		if(get_playersnum() > 30) amount = (1.2*amount)
		if(get_playersnum() > 31) amount = (1.2*amount)
	}
	
	if(get_playersnum()>10){
		if(clEvent == 2 && (player_class[id] == clEvent1 || player_class[id] == clEvent2)){
			amount = (1.3*amount)
		}else if(KlasyZlicz[player_class[id]]==1){
			amount = (1.3*amount)
		}else if(KlasyZlicz[player_class[id]]==2){
			amount = (1.1*amount)
		}else if(KlasyZlicz[player_class[id]]==4 || KlasyZlicz[player_class[id]]==5){
			amount = (0.7*amount)
		}else if(KlasyZlicz[player_class[id]]>=6){
			amount = (0.5*amount)	
		}
	}

	if(player_lvl[id]> 5){

		if(player_lvl[id]< 125){
			amount2 = (1.5*amount2)
		}
		if(player_lvl[id]> 150){
			amount2 = (0.9*amount2)
		}
		if(player_lvl[id]> 175){
			amount2 = (0.9*amount2)
		}
		if(player_lvl[id]> 200){
			amount2 = (0.7*amount2)
		}
		if(player_lvl[id]> 225){
			amount2 = (0.1*amount2)
		}
		if(player_lvl[id]> 250){
			amount2 = (0.9*amount2)
		}
		if(player_lvl[id]> 300){
			amount2 = (0.9*amount2)
		}
		if(player_lvl[id]> 350){
			amount2 = (0.9*amount2)
		}
		if(player_lvl[id]> 400){
			amount2 = (0.7*amount2)
		}
		if(player_lvl[id]> 450){
			amount2 = (0.9*amount2)
		}
			
			
		if(player_lvl[id]> 250){
			amount2 = (0.7*amount2)
		}
		if(player_lvl[id]> 500){
			amount2 = (0.7*amount2)
		}
		if(player_lvl[id]> 750){
			amount2 = (0.5*amount2)
		}
		
		if(diablo_redirect==2 || diablo_redirect==1 ){
			if(player_lvl[id]> 75) amount2 = (0.5*amount2)
			if(player_lvl[id]< 50) amount2 = (2.0*amount2)
		}
		if(diablo_redirect==3){
			if(player_lvl[id]> 100) amount2 = (0.5*amount2)
			if(player_lvl[id]< 75) amount2 = (1.5*amount2)
		}
		if(diablo_redirect==4){
			if(player_lvl[id]< 100) amount2 = (1.5*amount2)
		}
	}
	
	xpStandardMnoznik[id] = amount / 100.0;
	xpStandardMnoznik2[id] = amount2 / 100.0;
	new l = player_lvl[id]%250
	
	if(l>=175){ 
		xpStandardMnoznik2[id] = 0.6
	}
	if(l>=200){ 
		xpStandardMnoznik2[id] = 0.4
	}
	if(l>=225){ 
		xpStandardMnoznik2[id] = 0.2
	}
	if(l>=250){ 
		xpStandardMnoznik2[id] = 0.1
	}
}

public xp_mnoznik(id, amount){

	amount = floatround(amount * xpStandardMnoznik[id] * xpStandardMnoznik2[id]);

	if(player_iszombie[id]>0 && zombie_owner[id] >0 && player_iszombie[zombie_owner[id]]==0){ 
		Give_Xp(zombie_owner[id],amount/2)
		amount = amount/2
	}	

	return amount
	
}

public Give_Xp(id,amount)
{	
	if(player_class_lvl[id][player_class[id]]<0 ||player_lvl[id]<0){
		player_class_lvl[id][player_class[id]] = 2
		player_lvl[id] = 2 
	}
	
	amount = xp_mnoznik(id,amount)
	
	if(player_class_lvl[id][player_class[id]]==player_lvl[id])
	{
		
		if(amount >= 1){
			if(player_wys[id]==1){
				player_wys[id]=0
				player_expwys[id] +=amount
				
				set_hudmessage(255, 253, 0, -1.0, 0.01, 0, 0.2, 0.8, 0.1, 0.2, -1)
				
				
				
				show_hudmessage(id, " +%i ",player_expwys[id])
				player_expwys[id]=0
				} else {
				player_expwys[id] +=amount
			}
			
		}
		if(amount < 0){
			set_hudmessage(255, 0, 0, -1.0, 0.01)
			show_hudmessage(id, " -%i ",amount)
		}
		
		if(player_xp[id]+amount!=0 && get_playersnum()>1){
			player_xp[id]+=amount
			if (player_xp[id] > LevelXP[player_lvl[id]])
			{
				player_lvl[id]+=1
				player_point[id]+=2
				player_class_lvl[id][player_class[id]]=player_lvl[id]
				
				if(player_lvl[id] > 100){
					if(tutOn && tutor[id])tutorMake(id,TUTOR_YELLOW,5.0,"Awansowales do poziomu %i",player_lvl[id])				
					efekt_level(id)
				}
				
			}
			
			if (player_xp[id] < LevelXP[player_lvl[id]-1])
			{
				if(diablo_typ==3){
					player_lvl[id]-=9
					player_point[id]-=18
				}
				player_lvl[id]-=1
				player_point[id]-=2
				if(tutOn && tutor[id])tutorMake(id,TUTOR_RED,5.0,"Spadles do poziomu %i",player_lvl[id])
				//savexpcom(id)
				player_class_lvl[id][player_class[id]]=player_lvl[id]
			}
			write_hud(id)
		}
	}
	return PLUGIN_CONTINUE 
}

/* ==================================================================================================== */
public client_connect(id)
{
	seria[id]=0
	gonTimer[id] = 0
	//	reset_item_skills(id)  - nie tutaj bo nie loaduje poziomow O.o
	asked_sql[id]=0
	new prt[10]
	get_user_info(id,"_printdmg",prt,10)
	print_dmg[id]=true
	if(str_to_num(prt) == 1) print_dmg[id]=false
	if(str_to_num(prt) == 0) print_dmg[id]=true
	new prt2[10]
	get_user_info(id,"_tutor",prt2,10)
	tutor[id]=true
	if(str_to_num(prt2) == 1) tutor[id]=false
	if(str_to_num(prt2) == 0) tutor[id]=true
	flashbattery[id] = MAX_FLASH
	player_xp[id] = 0		
	player_lvl[id] = 1		
	player_point[id] = 0	
	player_item_id[id] = 0		
	player_dziewica[id]= 0
	player_dziewica_using[id]=0
	
	player_pierscien_plagi[id]=0
	player_lustro[id] = 0
	player_tmp[id]=0
	endless[id]=0
	player_odpornosc_fire[id]=0
	player_agility[id] = 0
	player_strength[id] = 0
	player_intelligence[id] = 0
	player_dextery[id] = 0
	dexteryDamRedCalc(id)
	player_b_oldsen[id] = 0.0
	player_class[id] = 0
	player_damreduction[id] = 0.0
	last_update_xp[id] = -1
	player_item_name[id] = "None"
	DemageTake[id]=0
	player_b_gamble[id]=0
	
	g_GrenadeTrap[id] = 0
	g_TrapMode[id] = 0
	
	player_ring[id]=0
	player_samelvl[id] = 0;
	
	reset_item_skills(id) // Juz zaladowalo xp wiec juz nic nie zepsuje <lol2>
	reset_player(id)
	
	u_sid[id] = 0
	new sid[64]
	get_user_authid(id, sid ,63)
	if (valid_steam(sid)) u_sid[id] = 1
	client_cmd(id, "cl_forwardspeed 700");
	client_cmd(id, "cl_sidespeed 700");
	client_cmd(id, "cl_backspeed 700");
	for(new j = 0;j <= MAX;j++)	g_bAsysta[id][j] = false;
	g_iZemsta[id] = 0;
	xpStandardMnoznik[id] = 1.0;
	xpStandardMnoznik2[id] = 1.0;
	for(new i=0; i<MAX; i++)
	{
		lvl_dif_xp_mnoznik[id][i] = 1
	}
	for(new i=0; i<MAX; i++)
	{
		lvl_dif_xp_mnoznik[i][id] = 1
	}
}



public client_putinserver(id)
{
	player_mute[id] = 0
	date_long[id]= "";
	loaded_xp[id]=0
	asked_klass[id] = 0;
	czas_regeneracji[id] = 0
	player_class_lvl_save[id]=0
	create_used[id]=0
	database_user_created[id]=0
	count_jumps(id)
	JumpsLeft[id]=JumpsMax[id]
	player_lvl[id]=0
	last_update_xp[id]=0
	player_xp[id]=0
	player_class_lvl_save[id]=0
	loaded_xp[id]=0
	highlvl[id]=0
	player_vip[id]= 0
	player_sid_pass[id] = ""
	player_pass_pass[id] = ""
	player_podany_pass_pass[id] = ""
	pr_pass_pass[id] = 0
	god[id] = 0
	player_awp_hs[id]  = 0
	for(new i=1; i<9; i++) player_class_lvl[id][i] = 0;
	set_task(10.0, "Greet_Player", id+TASK_GREET, "", 0, "a", 1)
}

public client_disconnect(id)
{
	//popularnosc[id]=0
	myRank [id] = -1
	player_mute[id] = 0
	date_long[id]= "";
	new ent
	new playername[40]
	get_user_name(id,playername,39)
	player_dc_name[id] = playername
	player_dc_item[id] = player_item_id[id]	
	xpStandardMnoznik[id] = 1.0;
	xpStandardMnoznik2[id] = 1.0;
	if (player_b_oldsen[id] > 0.0) client_cmd(id,"sensitivity %f",player_b_oldsen[id])
	savexpcom(id)
	
	remove_task(TASK_CHARGE+id)     
	
	while((ent = fm_find_ent_by_owner(ent, "fake_corpse", id)) != 0)
		fm_remove_entity(ent)
	player_lvl[id]=0
	last_update_xp[id]=0
	player_xp[id]=0
	player_class_lvl_save[id]=0
	loaded_xp[id]=0
	player_vip[id]= 0
	player_sid_pass[id] = ""
	player_pass_pass[id] = ""
	player_podany_pass_pass[id] = ""
	pr_pass_pass[id] = 0
	god[id] = 0
	last_attacker[id]=0
	player_dextery[id] =0
	player_intelligence[id] =0
	player_strength[id] =0
	player_agility[id] =0
	dexteryDamRedCalc(id)
	for(new a=0;a<32;a++){
		if(last_attacker[a]==id) last_attacker[a] = 0 
	}
	u_sid[id] = 0
	for(new i=0; i<MAX; i++)
	{
		lvl_dif_xp_mnoznik[id][i] = 1
	}
	for(new i=0; i<MAX; i++)
	{
		lvl_dif_xp_mnoznik[i][id] = 1
	}
}

/* ==================================================================================================== */

public write_hud(id)
{
	
	if (player_lvl[id] == 0)
		player_lvl[id] = 1
	
	new tpstring[2024] 
	
	new Float:xp_now
	new Float:xp_need
	new Float:perc
	
	if (last_update_xp[id] == player_xp[id])
	{
		perc = last_update_perc[id]
	}
	else
	{
		//Calculate percentage of xp required to level
		if (player_lvl[id] == 1)
		{
			xp_now = float(player_xp[id])
			xp_need = float(LevelXP[player_lvl[id]])
			perc = xp_now*100.0/xp_need
		}
		else
		{
			xp_now = float(player_xp[id])-float( LevelXP[player_lvl[id]-1])
			xp_need = float(LevelXP[player_lvl[id]])-float(LevelXP[player_lvl[id]-1])
			perc = xp_now*100.0/xp_need
		}
	}
	
	last_update_xp[id] = player_xp[id]
	last_update_perc[id] = perc
	
	new gotoweStr[10] = "Gotowy";
	new aktywneStr[10] = "Aktywny";
	new wyczerpanyStr[12] = "Wyczerpany";
	
	if(player_lvl[id] < 2){
		formatex(tpstring,2023,"Klasa: %s LVL: Wczytywanie HP: %i", Race[player_class[id]],
		player_lvl[id], perc,"%%",get_user_health(id))
	}else{
		if(player_class[id]==Paladyn){
			formatex(tpstring,2023,"%s [%i] LVL: %i (%0.0f%s) HP: %i Skoki: %i/%i  Pociski:%i",
			player_lvl[id] < prorasa ? Race[player_class[id]] : ProRace[player_class[id]], KlasyZlicz[player_class[id]],
			player_lvl[id], perc,"%%",get_user_health(id),
			JumpsLeft[id],JumpsMax[id], golden_bulet[id])
		}
		else if(player_class[id]==Barbarzynca){
			formatex(tpstring,2023,"%s [%i] LVL:%i (%0.0f%s) HP:%i Pancerze:%i", 
			player_lvl[id] < prorasa ? Race[player_class[id]] : ProRace[player_class[id]], KlasyZlicz[player_class[id]],
			player_lvl[id], perc,"%%",get_user_health(id),
			ultra_armor[id])
		}
		else if(player_class[id]==Ninja){
			formatex(tpstring,2023,"%s [%i] LVL:%i (%0.0f%s) HP:%i Noze:%i", 
			player_lvl[id] < prorasa ? Race[player_class[id]] : ProRace[player_class[id]], KlasyZlicz[player_class[id]],
			player_lvl[id], perc,"%%",get_user_health(id),
			player_knife[id])
		}
		else if(player_class[id]==Zabojca){
			formatex(tpstring,2023,"%s [%i] LVL:%i (%0.0f%s) HP:%i Noze:%i, Widzialny:%s", 
			player_lvl[id] < prorasa ? Race[player_class[id]] : ProRace[player_class[id]], KlasyZlicz[player_class[id]],
			player_lvl[id], perc,"%%",get_user_health(id),
			player_knife[id], (invisible_cast[id]==1) ? "Nie" : "Tak")
		}
		else if(player_class[id]==Inkwizytor){
			formatex(tpstring,2023,"%s [%i] LVL:%i (%0.0f%s) HP:%i Tarcze:%i Pancerze:%i ", 
			player_lvl[id] < prorasa ? Race[player_class[id]] : ProRace[player_class[id]], KlasyZlicz[player_class[id]],
			player_lvl[id], perc,"%%",get_user_health(id),
			player_nal[id], ultra_armor[id])
		}
		else if(player_class[id]==Zjawa){
			new render = 100 - player_intelligence[id]/2
			if(render <75) render = 75
			if(player_b_inv[id]>0 && player_b_inv[id] < render) render = player_b_inv[id]
			formatex(tpstring,2023,"%s [%i] LVL: %i (%0.0f%s) HP: %i wid:%i Czar: %s",
			player_lvl[id] < prorasa ? Race[player_class[id]] : ProRace[player_class[id]], KlasyZlicz[player_class[id]],
			player_lvl[id], perc,"%%",get_user_health(id),
			render, (player_naladowany[id]==1) ? wyczerpanyStr : gotoweStr)
		}
		else if(player_class[id]==Ifryt || player_class[id]==MagL ||  player_class[id]==Druid || player_class[id]==Wysoki){
			formatex(tpstring,2023,"%s [%i] LVL: %i (%0.0f%s) HP: %i Czar: %s",
			player_lvl[id] < prorasa ? Race[player_class[id]] : ProRace[player_class[id]], KlasyZlicz[player_class[id]],
			player_lvl[id], perc,"%%",get_user_health(id),
			(player_naladowany[id]==1) ? wyczerpanyStr : gotoweStr)
		}
		else if(player_class[id]==Meduza){
			formatex(tpstring,2023,"%s [%i] LVL: %i (%0.0f%s) HP: %i Czar: %s",
			player_lvl[id] < prorasa ? Race[player_class[id]] : ProRace[player_class[id]], KlasyZlicz[player_class[id]],
			player_lvl[id], perc,"%%",get_user_health(id),
			(skam[id] == 1) ? aktywneStr : ((player_naladowany[id]==1) ? wyczerpanyStr : gotoweStr))
		}
		else if(player_class[id]==Kuroliszek){
			formatex(tpstring,2023,"%s [%i] LVL: %i (%0.0f%s) HP: %i Czar: %s",
			player_lvl[id] < prorasa ? Race[player_class[id]] : ProRace[player_class[id]], KlasyZlicz[player_class[id]],
			player_lvl[id], perc,"%%",get_user_health(id),
			(player_naladowany[id] > floatround(halflife_time())) ? wyczerpanyStr : gotoweStr)
		}
		else if(player_class[id]==Gon || player_class[id]==Zmij){
			formatex(tpstring,2023,"%s [%i] LVL: %i (%0.0f%s) HP: %i Czar: %s",
			player_lvl[id] < prorasa ? Race[player_class[id]] : ProRace[player_class[id]], KlasyZlicz[player_class[id]],
			player_lvl[id], perc,"%%",get_user_health(id),
			(halflife_time()-player_naladowany[id] <= 20) ? wyczerpanyStr : gotoweStr)	
		}
		else if(player_class[id]==Ognik){
			new count = 0
			new ents = -1
			ents = find_ent_by_owner(ents,"MineLO",id)
			while (ents > 0)
			{
				count++
				ents = find_ent_by_owner(ents,"MineLO",id)
			}
			
			formatex(tpstring,2023,"%s [%i] LVL: %i (%0.0f%s) HP: %i Miny: %i/%i",
			player_lvl[id] < prorasa ? Race[player_class[id]] : ProRace[player_class[id]], KlasyZlicz[player_class[id]],
			player_lvl[id], perc,"%%",get_user_health(id),
			count, count + (2 - player_naladowany[id]))		
		}
		else if(player_class[id]==Samurai){
			formatex(tpstring,2023,"%s [%i] LVL: %i (%0.0f%s) HP: %i Wid: %i Skoki: %i/%i",
			player_lvl[id] < prorasa ? Race[player_class[id]] : ProRace[player_class[id]], KlasyZlicz[player_class[id]],
			player_lvl[id], perc,"%%",get_user_health(id),
			player_b_inv[id], czas_rundy + 10 > floatround(halflife_time()) ? 0 : JumpsLeft[id],JumpsMax[id])
		}
		else {
			formatex(tpstring,2023,"%s [%i] LVL: %i (%0.0f%s) HP: %i",
			player_lvl[id] < prorasa ? Race[player_class[id]] : ProRace[player_class[id]], KlasyZlicz[player_class[id]],
			player_lvl[id], perc,"%%",get_user_health(id))	
		}
	}
	
	
	
	
	message_begin(MSG_ONE,gmsgStatusText,{0,0,0}, id) 
	write_byte(0) 
	write_string(tpstring) 
	message_end() 
}

/* ==================================================================================================== */
public ItemHUD(id)
{    
	
	//If user is not connected, don't do anything
	if (!is_user_connected(id) || !is_user_alive(id))
		return
	
	//Show info about the player we're looking at
	
	new xp_teraz = player_xp[id] - LevelXP[player_lvl[id]-1]
	new xp_do = LevelXP[player_lvl[id]] - LevelXP[player_lvl[id]-1]
	
	new Msg[512]
	set_hudmessage(255, 255, 255, 0.78, 0.65, 0, 6.0, 3.0)
	new rezerw[100] = ""
	if(asked_klass[id]!=2 && player_lvl[id] <5) rezerw = "Wczytywanie"
	else if(!player_sid_pass[id][0] && !player_pass_pass[id][0]) rezerw = "Brak zabezpieczen"
	else if(player_sid_pass[id][0] && player_pass_pass[id][0]) rezerw = "Przypisany SID i Haslo"
	else if(player_sid_pass[id][0]) rezerw = "Przypisany SID"
	else if(player_pass_pass[id][0]) rezerw = "Przypisane Haslo"
	
	formatex(Msg,511," Przedmiot: %s^n Wytrzymalosc: %i^n Doswiadczenie: %i/%i ^n Mnoznik xp: %i * %i^n Rezerwacja: %s",player_item_name[id],item_durability[id], xp_teraz,xp_do, floatround(xpStandardMnoznik[id]*10), floatround(xpStandardMnoznik2[id]*10),rezerw)		
	show_hudmessage(id, Msg)
}

public UpdateHUD()
{    
	//Update HUD for each player
	for (new id=0; id < MAX; id++)
	{	
		//If user is not connected, don't do anything
		if (!is_user_connected(id))
			continue
		
		if (is_user_alive(id)){
			write_hud(id)
			ItemHUD(id)
			pev(id,pev_origin,glob_origin[id])
		} 
		else
		{
			//Show info about the player we're looking at
			new index,bodypart 
			get_user_aiming(id,index,bodypart)  
			
			if(index >= 0 && index < MAX && is_user_connected(index) && is_user_alive(index)) 
			{
				new pname[32]
				get_user_name(index,pname,31)
				
				
				new Msg[512]
				set_hudmessage(255, 255, 255, 0.78, 0.65, 0, 6.0, 3.0)
				if(player_lvl[index]<prorasa){
					formatex(Msg,511,"Nick: %s^nPoziom: %i^nKlasa: %s^nPrzedmiot: %s^nInteligencja: %i^nSila: %i^nZwinnosc: %i^nZrecznosc: %i",
					pname,player_lvl[index],Race[player_class[index]],player_item_name[index], player_intelligence[index],player_strength[index], player_dextery[index], player_agility[index])		
					} else {
					formatex(Msg,511,"Nick: %s^nPoziom: %i^nKlasa: %s^nPrzedmiot: %s^nInteligencja: %i^nSila: %i^nZwinnosc: %i^nZrecznosc: %i",
					pname,player_lvl[index],ProRace[player_class[index]],player_item_name[index], player_intelligence[index],player_strength[index], player_dextery[index], player_agility[index])		
					
				}
				
				
				show_hudmessage(id, Msg)
				
			}
		}
	}
}

/* ==================================================================================================== */



public check_magic(id)					//Redirect and check which items will be triggered
{
	if(player_iszombie[id]>0) return PLUGIN_HANDLED
	
	if (player_b_fireball[id] > 0) item_fireball(id)
	if (player_b_ghost[id] > 0) item_ghost(id)
	if (player_b_eye[id] != 0) item_eye(id)
	if (player_b_windwalk[id] > 0) item_windwalk(id)
	if (player_b_dagon[id] > 0) item_dagon(id)
	if (player_b_theif[id] > 0) item_convertmoney(id)
	if (player_b_firetotem[id] > 0) item_firetotem(id)
	if (player_b_hook[id] > 0) item_hook(id)
	if (player_b_gravity[id] > 0) item_gravitybomb(id)
	if (player_b_fireshield[id] > 0) item_rot(id)
	if (player_b_illusionist[id] > 0) item_illusion(id)
	if (player_b_money[id] > 0) item_money_shield(id)
	if (player_dziewica[id] > 0) item_dziewica(id)
	
	if (player_bats[id]>0) bats_on_jump(id)
	
	if (player_antygravi[id]>0) item_grav(id)
	if (bieg_item[id]>0)  BiegOn(id)
	
	
	if (player_b_teamheal[id] > 0) item_teamshield(id)
	if (player_b_heal[id] > 0 ) item_totemheal(id) 
	if (player_smoke[id]) daj_smoke(id)
	if (player_dosw[id] > 0) daj_expa(id)
	if (player_grom[id] > 0) item_grom(id)
	if (player_tpresp[id] > 0) item_lotrzyka(id)
	if (player_b_tarczaogra[id]>0) item_tarczaogra(id) 
	if (player_laska[id]>0) item_laska(id)
	if (player_lembasy[id]>0) item_lembasy(id)
	if (player_totem_enta[id]>0) item_totem_enta(id)
	if (player_totem_lodu[id]>0) item_totem_lodu(id)
	if (player_totem_powietrza_zasieg[id]>0) item_totem_powietrza(id)
	if (player_gtrap[id]>0) item_trapnade(id)
	if (player_chwila_ryzyka[id]>0)  item_chwila_ryzyka(id)
	if (player_lich[id]>0)  Lich(id)
	if (player_aard[id]>0) item_aard(id)
	if (player_class[id] == Heretyk ) heretyk_skill(id)
	
	if (player_healer[id]>0) item_healer(id)
	
	if ( is_user_in_bad_zone( id ) ){
		hudmsg(id,2.0,"Nie mozna uzyc w tym miejscu")
		return PLUGIN_HANDLED
		}else{
		
		if (player_b_mine[id] > 0) item_mine(id)
		if (player_b_mine_lesna[id]>0) item_mineL(id)
		if (player_b_mine_lodu[id]>0) item_mineLod(id)
		if (player_b_meekstone[id] > 0){ 
			item_c4fake(id)
			item_c4fake(id)
		}
	}
	
	
	return PLUGIN_HANDLED
}

/* ==================================================================================================== */

public dropitem(id)
{
	if (player_item_id[id] == 0)
	{
		hudmsg(id,2.0,"Nie masz przedmiotu do wyrzucenia!")
		return PLUGIN_HANDLED
	} 
	
	if (item_durability[id] <= 0) 
	{
		log_to_file("addons/amxmodx/logs/popularneItemy.log","%s", player_item_name[id])
		hudmsg(id,3.0,"Przedmiot stracil swoja wytrzymalosc!")
	}
	else 
	{
		log_to_file("addons/amxmodx/logs/wyrzucaneItemy.log","%s", player_item_name[id])
		set_hudmessage(100, 200, 55, -1.0, 0.40, 0, 3.0, 2.0, 0.2, 0.3, 5)
		show_hudmessage(id, "Przedmiot wyrzucony")
	}
	
	player_item_id[id] = 0
	player_item_name[id] = "Nic"
	player_b_gamble[id] = 0	//Because gamble uses reset skills
	
	if (player_b_extrastats[id] > 0)
	{
		SubtractStats(id,player_b_extrastats[id])
	}
	if (player_strbonus[id] > 0)
	{
		player_strength[id]-=player_strbonus[id]
	}
	if (player_intbonus[id] > 0)
	{
		player_intelligence[id]-=player_intbonus[id]
	}
	
	
	if(player_ring[id]>0) SubtractRing(id)
	player_ring[id]=0
	
	reset_item_skills(id)
	set_task(3.0,"changeskin_id_1",id)
	write_hud(id)
	ItemHUD(id)
	
	set_renderchange(id)
	set_gravitychange(id)
	set_speedchange(id)
	if (player_b_oldsen[id] > 0.0) 
	{
		client_cmd(id,"sensitivity %f",player_b_oldsen[id])
		player_b_oldsen[id] = 0.0
	}
	
	
	return PLUGIN_HANDLED
}

/* ==================================================================================================== */

public pfn_touch ( ptr, ptd )
{	

	if(!ptd)
		return PLUGIN_CONTINUE;
	
	if(!pev_valid(ptd))
		return PLUGIN_HANDLED;
	
	
	new szClassName[32], szClassNameOther[32];
	entity_get_string(ptd, EV_SZ_classname, szClassName, 31);
	
	if(pev_valid(ptd)){
		if(pev_valid(ptr)) {
			if(pev(ptr, pev_solid) == SOLID_TRIGGER)
				return PLUGIN_CONTINUE;
			entity_get_string(ptr, EV_SZ_classname, szClassNameOther, 31);
		}
	}
	else return PLUGIN_HANDLED
	
	if(equal(szClassName, "fireball"))
	{		
		new owner = pev(ptd,pev_owner)
		//Touch
		
		new Float:vec[3]
		entity_get_vector(ptd,EV_VEC_velocity,vec)
		if(vec[0]==0&&vec[1]==0&&vec[2]==0){
			if(pev_valid (ptr)) change_health(ptr,4,0,"")
			remove_entity(ptd)
			return PLUGIN_CONTINUE
		} 
		
		if (get_user_team(owner) == get_user_team(ptr)){
			new Float:origin[3]
			pev(ptd,pev_origin,origin)
			Explode_Origin(owner,origin,0,150)
			remove_entity(ptd)
		}
		if (get_user_team(owner) != get_user_team(ptr))
		{
			new Float:origin[3]
			pev(ptd,pev_origin,origin)
			if(player_class[owner]==MagL){
				new dee= player_intelligence[owner]+50				
				Explode_Origin(owner,origin,dee,150)				
			}else{
				Explode_Origin(owner,origin,55+player_intelligence[owner],150)
			}
			
			remove_entity(ptd)
		}
	}
	
	if (ptr != 0 && pev_valid(ptr))
	{
		new szClassNameOther[32]
		entity_get_string(ptr, EV_SZ_classname, szClassNameOther, 31)
		new button2 = get_user_button(ptr);	
		
		if(equal(szClassName, "PowerUp") && equal(szClassNameOther, "player"))
		{
			entity_set_int(ptd,EV_INT_iuser2,1)
		}
		
		if(equal(szClassName, "Mine") && equal(szClassNameOther, "player")  && !(button2 & IN_DUCK))
		{
			new owner = pev(ptd,pev_owner)
			//Touch
			if (get_user_team(owner) != get_user_team(ptr))
			{
				new Float:origin[3]
				pev(ptd,pev_origin,origin)
				entity_set_int(ptd, EV_INT_sequence, 7)
				set_pev(ptd,pev_framerate, 1.0 );
				set_task(1.0 , "delMine", ptd+TASK_SPIDER)
				Poison_Origin(owner,origin,10+player_intelligence[owner],150)
				
			}
		}
		if(equal(szClassName, "MineL") && equal(szClassNameOther, "player") && !(button2 & IN_DUCK) )
		{
			new owner = pev(ptd,pev_owner)
			//Touch
			if (get_user_team(owner) != get_user_team(ptr))
			{
				new Float:origin[3]
				pev(ptd,pev_origin,origin)
				Explode_Origin(owner,origin,10+player_intelligence[owner],150)
				efekt_slow_enta(ptr, 4)
				remove_entity(ptd)
			}
		}
		if(equal(szClassName, "MineLO") && equal(szClassNameOther, "player")  && !(button2 & IN_DUCK))
		{
			new owner = pev(ptd,pev_owner)
			//Touch
			if (get_user_team(owner) != get_user_team(ptr))
			{
				new Float:origin[3]
				pev(ptd,pev_origin,origin)
				Explode_OriginMine(owner,origin,10+floatround(player_intelligence[owner]*0.2),150)	
				
				new t = 1
				efekt_slow_enta(ptr, t)
				remove_entity(ptd)
			}
		}
		if(equal(szClassName, "MineLod") && equal(szClassNameOther, "player")  && !(button2 & IN_DUCK))
		{
			new owner = pev(ptd,pev_owner)
			//Touch
			if (get_user_team(owner) != get_user_team(ptr))
			{
				new Float:origin[3]
				pev(ptd,pev_origin,origin)
				Explode_Origin(owner,origin,25+player_intelligence[owner],150)
				efekt_slow_lodu(ptr, 6)
				remove_entity(ptd)
			}
		}
		if(equal(szClassName, "grenade") && equal(szClassNameOther, "player"))
		{
			new greModel[64]
			entity_get_string(ptd, EV_SZ_model, greModel, 63)
			
			if(equali(greModel, "models/w_smokegrenade.mdl" ))	
			{
				new id = entity_get_edict(ptd,EV_ENT_owner)
				
				if (is_user_connected(id) 
				&& is_user_connected(ptr) 
				&& is_user_alive(ptr) 
				&& player_b_smokehit[id] > 0
				&& get_user_team(id) != get_user_team(ptr))
				UTIL_Kill(id,ptr,"grenade")
			}
			
			
		}
		
	}

	return PLUGIN_CONTINUE
}
/* ==================================================================================================== */
public Poison_Origin(id,Float:origin[3],damage,dist)
{


new Players[32], playerCount, a
get_players(Players, playerCount, "ah") 

for (new i=0; i<playerCount; i++) 
{
	a = Players[i] 
	
	new Float:aOrigin[3]
	pev(a,pev_origin,aOrigin)
	
	
	if (get_user_team(id) != get_user_team(a) && get_distance_f(aOrigin,origin) < dist+0.0)
	{
		Effect_Bleed(a,248)
		if(! HasFlag(a, Flag_truc)){
			Effect_waz(a,id,get_maxhp(a)*5/100)
		}
		
	}
	
}
}
public Explode_OriginMine(id,Float:origin[3],damage,dist)
{
	new Players[32], playerCount, a
	get_players(Players, playerCount, "ah") 
	
	for (new i=0; i<playerCount; i++) 
	{
		a = Players[i] 
		
		new Float:aOrigin[3]
		pev(a,pev_origin,aOrigin)
		
		
		if (get_user_team(id) != get_user_team(a) && get_distance_f(aOrigin,origin) < dist+0.0)
		{
			new dam = damage-player_dextery[a]*2
			new prec = 5			
			prec  += player_intelligence[id] / 50
			if(prec>15) prec = 15
			if(player_dextery[a]>50) {
				new deks= (player_dextery[a] - 50) / 25
				prec -= deks
				if(prec<5) prec=5
			}
			Effect_Bleed(a,83)			
			Effect_Bleed(a,83)
			Effect_Bleed(a,83)
			if(dam<1) dam = 1			
			change_health(a,-dam-(get_maxhp(a)*prec/100),id,"grenade")	
		}
	}
}

public Explode_Origin(id,Float:origin[3],damage,dist)
{
	message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
	write_byte(3)
	write_coord(floatround(origin[0]))
	write_coord(floatround(origin[1]))
	write_coord(floatround(origin[2]))
	write_short(sprite_boom)
	write_byte(50)
	write_byte(15)
	write_byte(0)
	message_end()
	new Players[32], playerCount, a
	get_players(Players, playerCount, "ah") 
	for (new i=0; i<playerCount; i++) 
	{
		a = Players[i] 
		
		new Float:aOrigin[3]
		pev(a,pev_origin,aOrigin)
		
		
		if (get_user_team(id) != get_user_team(a) && get_distance_f(aOrigin,origin) < dist+0.0)
		{		
			new prec = 20
			new deks= player_dextery[a] / 25
			prec -= deks
			if(prec<5) prec=5
			
			new dam = damage + (get_maxhp(a)*prec/100)
			new red = dexteryDamRedPerc[a]
			dam = dam - (dam * red /100)
			
			if (dam < 0) Effect_Bleed(a,248)
			else {
				Effect_Bleed(a,248)
				change_health(a,-dam,id,"grenade")
			}
			
			if(player_class[id]==MagL){
				efekt_slow_lodu(a, 5)
				if(player_lvl[id]>prorasa){ 
					efekt_slow_lodu(a, 10)	
					change_health(id,5,0,"")
				}
			}

		}
	}
}

/* ==================================================================================================== */

public Timed_Healing()
{
	Find_maxmin_lvl()
	new Players[32], playerCount, a
	get_players(Players, playerCount, "ah") 
	for (new i=0; i<playerCount; i++) 
	{
		a = Players[i] 

		diablo_redirect_check_low(a)
		diablo_redirect_check_high(a)
		inbattle[a] = 0
		set_renderchange(a)
		
		if(ma_tarcze(a)) user_kill(a, 0) 
		
		if(player_class[a] == Ognik){
			if(player_naladowany[a]>0 )player_naladowany[a]--
		}
		if (player_b_heal[a] <= 0)
			continue
		if(player_b_rownow[a]>0){
			new pro = (get_user_health(a) / get_maxhp(a) ) * player_b_rownow[a]
			change_health(a,player_b_heal[a] +  player_b_heal[a]* pro,0,"")
		}else{
			change_health(a,player_b_heal[a],0,"")
		}
	}
}

ma_tarcze(id)
{

	return cs_get_user_shield(id)
}

/* ==================================================================================================== */

public reset_item_skills(id){
	player_lembasy[id] = 0
	player_aard[id]  =0
	player_antygravi[id]=0
	skam[id]=0
	player_b_nieust[id]=0
	player_b_nieust2[id]=0
	player_smocze[id] = 0
	player_skin[id]= 0
	player_frostShield[id] = 0
	player_5hp[id]= 0
	item_boosted[id] = 0
	item_durability[id] = 0
	jumps[id] = 0
	mocrtime[id] = 0		// timer mocy postaci
	gravitytimer[id] = 0		// tmier archow
	player_b_vampire[id] = 0	//Vampyric damage
	player_b_damage[id] = 0		//Bonus damage
	player_b_money[id] = 0		//Money bonus
	bieg_item[id]=0
	
	player_b_gravity[id] = 0	//Gravity bonus : 1 = best
	player_b_inv[id] = 0		//Invisibility bonus
	player_b_grenade[id] = 0	//Grenade bonus = 1/chance to kill
	player_b_reduceH[id] = 0	//Reduces player health each round start
	player_b_theif[id] = 0		//Amount of money to steal
	player_b_respawn[id] = 0	//Chance to respawn upon death
	
	player_b_heal[id] = 0		//Ammount of hp to heal each 5 second
	player_b_heal[id]= 0 
	player_b_fireshield[id] = 0	//Protects against explode and grenade bonus 
	player_b_meekstone[id] = 0	//Ability to lay a fake c4 and detonate 
	player_b_teamheal[id] = 0	//How many hp to heal when shooting a teammate 
	player_b_redirect[id] = 0	//How much damage will the player redirect 
	player_b_fireball[id] = 0	//Ability to shot off a fireball value = radius *
	player_b_ghost[id] = 0		//Ability to walk through walls
	player_b_eye[id] = 0	         //Ability to snarkattack
	if(player_class[id]!=Demon) player_b_blink[id] = 0		//Abiliy to use railgun
	if(player_class[id]!=Gon) player_b_blink4[id] = 0		//Abiliy to use railgun
	player_b_blink2[id] = 0		//Abiliy to use railgun
	player_b_blink3[id] = 0		//Abiliy to use railgun
	player_b_windwalk[id] = 0	//Ability to windwalk
	player_b_usingwind[id] = 0	//Is player using windwalk
	player_b_froglegs[id] = 0
	player_b_silent[id] = 0
	player_b_dagon[id] = 0		//Abliity to nuke opponents
	player_b_sniper[id] = 0		//Ability to kill faster with scout
	
	
	player_b_m3[id] = 0		//Ability to kill faster with scout
	
	player_b_smokehit[id] = 0
	player_b_extrastats[id] = 0
	player_b_firetotem[id] = 0
	player_b_hook[id] = 0
	player_b_darksteel[id] = 0
	player_b_illusionist[id] = 0
	player_lich[id]=0
	player_b_jumpx[id] = 0
	player_b_mine[id] = 0
	if(player_zombie_item[id]!=0) player_iszombie[id]=0
	player_zombie_item[id]=0
	player_zombie_killer[id]=0
	player_zombie_killer_magic[id]=0
	player_healer_c[id]=0
	player_przesz[id] = 0
	player_healer[id]=0
	player_b_rownow[id]=0
	player_b_mine_lesna[id] = 0
	player_odpornosc_fire[id]=0
	player_szpony[id]=0
	player_b_mine_lodu[id]=0
	player_iskra[id]=0
	player_ruch[id]=0
	player_b_truj_nozem[id]=0
	player_ludziebonus[id] = 0
	player_b_blind[id] = 0
	wear_sun[id] = 0
	player_sword[id] = 0 
	player_ultra_armor_left[id]=0
	player_ultra_armor[id]=0
	player_speedbonus[id]=0
	player_knifebonus[id]=0
	player_mrocznibonus[id]	= 0
	player_b_explode[id] = 0
	player_intbonus[id] = 0	
	player_strbonus[id] = 0	
	player_dexbonus[id] = 0	
	player_agibonus[id] = 0	
	player_katana[id] = 0		
	player_miecz[id] = 0
	player_mrozu[id]=0
	player_trac_hp[id] = 0
	player_trafiony_truj[id]=0
	player_staty[id] = 0
	player_smoke[id] = 0	
	player_dosw[id] = 0
	player_chargetime[id] = 0
	player_speedbonus[id] = 0
	player_grawitacja[id] = 0	
	player_naszyjnikczasu[id] = 0	
	player_tarczam[id] = 0	
	player_grom[id] = 0
	player_tpresp[id] =0
	player_b_zlotoadd[id] = 0
	player_b_tarczaogra[id]=0
	player_laska[id] = 0
	player_item_licznik[id] = 0
	player_dziewica[id]= 0
	player_dziewica_using[id]=0
	player_bats[id]=0
	player_drag[id]=0
	player_udr[id]=0
	endless[id]=0
	player_pierscien_plagi[id]=0
	player_lustro[id]=0
	player_tmp[id]=0
	player_totem_enta[id]=0
	player_totem_enta_zasieg[id]=0
	player_totem_lodu[id]=0
	player_totem_lodu_zasieg[id]=0
	player_recoil[id]=0
	player_awpk[id]=0
	player_lodowe_pociski[id] = 0
	player_entowe_pociski[id] = 0
	player_totem_powietrza_zasieg[id] = 0
	player_pociski_powietrza[id] = 0
	if (player_gtrap[id]>0) g_TrapMode[id] = 0
	player_gtrap[id]=0
	player_chwila_ryzyka[id] = 0  
	RemoveFlag(id,Flag_Moneyshield)
	RemoveFlag(id,Flag_Rot)
	RemoveFlag(id,Flag_Teamshield_Target)
	Display_Icon(id,0,"suithelmet_empty",255,255,255)
	
}

public changeskin_id_1(id)
{
	changeskin(id,1)
}
/* =================================================================================================== */

public show_menu_klasy(id)
{
	new text[513]
	
	formatex(text, 512, "\yinfo klas - ^n\w1. Mag^n\w2. Paladyn^n\w3. Mnich^n\w4. Barbarzynca^n^n\w0. Exit") 
	
	new keys 
	keys = (1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<4)|(1<<9)
	show_menu(id, keys, text) 
	return PLUGIN_HANDLED  
} 

public klasy(id, key) 
{ 
	switch(key) 
	{ 
		case 0: 
		{	
			mag(id)
			
		}
		case 1: 
		{	
			paladyn(id)
		}
		case 2: 
		{	
			mnich(id)
		}
		case 3:
		{
			barbarzynca(id)
		}
		
		case 9:
		{
			return PLUGIN_HANDLED
		}
	}
	
	return PLUGIN_HANDLED
}



public mag(id){
	showitem(id,"Ludzie"," "," ","<br>Tak, namieszalem :P <br><br>")
	showitem(id,"Ludzie"," "," ","<br>Tak, namieszalem :P <br><br>")
}
public paladyn(id){
	showitem(id,"Paladyn"," "," ","<br>Na start ma 125hp i moze wykonywac tzw. Long Jump.<br> <br><br>")
}
public mnich(id){
	showitem(id,"Mnich"," "," ","<br>Zdobywa szybciej doswiadczenie<br>i na start ma 140hp<br><br>")
}
public barbarzynca(id){
	showitem(id,"Barbarzynca"," "," ","<br>Zabijajac wroga dostajesz 200 armoru i<br>dostaniesz dodatkowy magazynek <br>i odzyskuje czesc hp.<br><br>")	
}
public zabojca(id){
	showitem(id,"Zabojca"," "," ","<br>Nie slychac jego krokow i jest troche szybszy od pozostalych.<br>Jak postrzelisz wroga z pistoletu wyrzuca go do gory<br><br>")
}
public nekromanta(id){
	showitem(id,"Nekromanta"," "," ","<br>Atakujac zabierasz 10hp wiecej<br>i moze wskrzeszac umarlych.<br><br>")
}
public ninja(id){
	showitem(id,"Ninja"," "," ","<br>Jest prawie niewidoczny, ma 165 hp na start<br>ale moze chodzic tylko z nozem<br><br>")
}
public Lowca(id){
	showitem(id,"Ninja"," "," ","<br>Posiada Kusze (wybierz noz a potem reload by wyjac<br>Moze zastawiac pulapki z granatow (zmiana trybow PPM)<br>Gdy postrzeli przeciwnika pistoletem, zostawia on za soba slad<br><br>")
}





/* =====================================*/
/* ==================================================================================================== */

public auto_help(id)
{
	new rnd = random_num(1,5+player_lvl[id])
	if (rnd <= 5)
		set_hudmessage(0, 180, 0, -1.0, 0.70, 0, 10.0, 5.0, 0.1, 0.5, 11) 	
	if (rnd == 1)
		show_hudmessage(id, "Mozesz upuscic przedmiot jak napiszesz /drop i zobaczyc informacje o przedmocie jak napiszesz /przedmiot")
	if (rnd == 2)
		show_hudmessage(id, "Mozesz uzywac konkretnych przedmiotow za pomoca klawisza E")
	if (rnd == 3)
		show_hudmessage(id, "Mozesz dostac wiecej pomocy jak napiszesz /pomoc lub zobaczyc wszystkie komendy jak napiszesz /komendy")
	if (rnd == 4)
		show_hudmessage(id, "Zeby bylo prosciej grac mozesz zbindowac diablo menu (bind klawisz say /menu")
	if (rnd == 5)
		show_hudmessage(id, "Niektore przedmioty moga byc ulepszone przez Runy. Napisz /rune zeby otworzyc sklep z runami")
}

/* ==================================================================================================== */

public helpme(id)
{	 
	showitem(id,"Helpmenu","Common","None","Dostajesz przedmioty i doswiadczenie za zabijanie. Mozesz dostac go tylko wtedy, gdy nie masz na sobie innego<br>Aby dowiedziec sie wiecej o swoim przedmiocie napisz /przedmiot lub /item, a jak chcesz wyrzucic napisz /drop<br>Niektore przedmoty da sie uzyc za pomoca klawisza E<br>Napisz /czary zeby zobaczyc jakie masz staty<br>Niektore umiejetnosci mozna uzyc klikajac R na nozu <br> Wyswietlanie obrazen mozesz wylaczyc za pomoca /print_dmg<br>")
}




/* ==================================================================================================== */

public komendy(id)
{
	showitem(id,"Komendy","Common","None","<br>/klasa - zmiana klasy postaci<br>/klasy - opis postaci<br>/rune - sklep z runami<br>/przedmiot - informacja o przedmiocie<br>/menu - wyswietla menu diablo mod<br>/czary - stan statystyk<br>/drop - wyrzuca aktualny przedmiot<br>/noweitemy - opis nowych itemow<br>/reset -resetuje twoje staty<br>/savexp - zapisuje lvl,exp,staty<br>/gracze - wyswietla liste graczy<br>Polska zmodyfikowana wersja diablo mod by GuTeK & Miczu<br><br>")
}

/* ==================================================================================================== */

public showitem(id,itemname[],itemvalue[],itemeffect[],Durability[])
{
	new diabloDir[64]	
	new g_ItemFile[64]
	new amxbasedir[64]
	get_basedir(amxbasedir,63)
	
	formatex(diabloDir,63,"%s/diablo",amxbasedir)
	
	if (!dir_exists(diabloDir))
	{
		new errormsg[512]
		formatex(errormsg,511,"Blad: Folder %s/diablo nie mogl byc znaleziony. Prosze skopiowac ten folder z archiwum do folderu amxmodx",amxbasedir)
		show_motd(id, errormsg, "An error has occured")	
		return PLUGIN_HANDLED
	}
	
	
	formatex(g_ItemFile,63,"%s/diablo/item.txt",amxbasedir)
	if(file_exists(g_ItemFile))
		delete_file(g_ItemFile)
	
	new Data[1024]
	
	//Header
	formatex(Data,767,"<html><head><title>Informacje o przedmiocie</title></head>")
	write_file(g_ItemFile,Data,-1)
	
	//Background
	formatex(Data,767,"<body text=^"#FFFF00^" bgcolor=^"#000000^" >",Basepath)
	write_file(g_ItemFile,Data,-1)
	
	//Table stuff
	formatex(Data,767,"<table border=^"0^" cellpadding=^"0^" cellspacing=^"0^" style=^"border-collapse: collapse^" width=^"100%s^"><tr><td width=^"0^">","^%")
	write_file(g_ItemFile,Data,-1)
	
	
	
	//item name
	formatex(Data,767,"<td width=^"0^"><p align=^"center^"><font face=^"Arial^"><font color=^"#FFCC00^"><b>Przedmiot: </b>%s</font><br>",itemname)
	write_file(g_ItemFile,Data,-1)
	
	//item value
	formatex(Data,767,"<font color=^"#FFCC00^"><b><br>Wartosc: </b>%s</font><br>",itemvalue)
	write_file(g_ItemFile,Data,-1)
	
	//Durability
	formatex(Data,767,"<font color=^"#FFCC00^"><b><br>Wytrzymalosc: </b>%s</font><br><br>",Durability)
	write_file(g_ItemFile,Data,-1)
	
	//Effects
	formatex(Data,767,"<font color=^"#FFCC00^"><b>Efekt:</b> %s</font></font></td>",itemeffect)
	write_file(g_ItemFile,Data,-1)
	
	
	//end
	formatex(Data,767,"</tr></table></body></html>")
	write_file(g_ItemFile,Data,-1)
	
	//show window with message
	show_motd(id, g_ItemFile, "Informacje Przedmiotu")
	
	return PLUGIN_HANDLED
	
}


/* ==================================================================================================== */

public iteminfo(id)
{
	new itemvalue[100]
	
	if (player_item_id[id] <= 10) itemvalue = "Common"
	if (player_item_id[id] <= 30) 
		itemvalue = "Uncommon"
	else 
		itemvalue = "Rare"
	
	if (player_item_id[id] > 42) itemvalue = "Unique"
	
	new itemEffect[500]
	
	new TempSkill[11]					//There must be a smarter way
	if (player_ns[id]>0 && player_strength[id] < player_ns[id])
	{
		add(itemEffect,499,"Musisz miec wiecej sily! Wyrzuc item, jest dla Ciebie nieprzydatny")
		add(itemEffect,499," <br>")
	}
	if (player_ni[id]>0 && player_intelligence[id] < player_ni[id])
	{
		add(itemEffect,499,"Musisz miec wiecej inteligencji! Wyrzuc item, jest dla Ciebie nieprzydatny")
		add(itemEffect,499," <br>")
	}
	if (player_nd[id]>0 && player_agility[id] < player_na[id])
	{
		add(itemEffect,499,"Musisz miec wiecej zwinnosci! Wyrzuc item, jest dla Ciebie nieprzydatny")
		add(itemEffect,499," <br>")
	}
	if (player_na[id]>0 && player_dextery[id] < player_nd[id])
	{
		add(itemEffect,499,"Musisz miec wiecej zrecznosci! Wyrzuc item, jest dla Ciebie nieprzydatny")
		add(itemEffect,499," <br>")
	}
	
	if (player_b_vampire[id] > 0) 
	{
		num_to_str(player_b_vampire[id],TempSkill,10)
		add(itemEffect,499,"Kradnie ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," hp jak uderzysz wroga<br>")
	}
	if (player_b_damage[id] > 0) 
	{
		num_to_str(player_b_damage[id],TempSkill,10)
		add(itemEffect,499,"Zadaje ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," dodatkowe obrazenia za kazdym razem jak uderzysz wroga<br>")
	}
	
	if (player_b_money[id] > 0) 
	{
		num_to_str(player_b_money[id],TempSkill,10)
		add(itemEffect,499,"Dodaje ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," zlota i w kazdej rundzie na start otrzymasz 50 zlota. Mozesz takze uzyc tego przedmiotu by zredukowac normalne obrazenia o 50%<br>")
	}
	if (player_b_gravity[id] > 0) 
	{
		num_to_str(player_b_gravity[id],TempSkill,10)
		add(itemEffect,499,"Wysoki skok jest zredukowany do ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499,". Uzyj tego przedmiotu jak bedziesz w powietrzu. Uszkodzenia zaleza od wysokosci skoku i twojej sily<br>")
	}
	if (player_b_inv[id] > 0 ) 
	{
		num_to_str(player_b_inv[id],TempSkill,10)
		add(itemEffect,499,"Twoja widocznosc jest zredukowana z 255 do ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499,"<br>")
	}
	if (player_b_grenade[id] > 0) 
	{
		num_to_str(player_b_grenade[id],TempSkill,10)
		add(itemEffect,499,"Masz 1/")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," szanse do natychmiastowego zabicia HE<br>")
	}
	if (player_b_reduceH[id] > 0) 
	{
		num_to_str(player_b_reduceH[id],TempSkill,10)
		add(itemEffect,499,"Twoje zdrowie jest zredukowane o ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," z kazdej rundy, sila nie liczy sie tu<br>")
	}
	if (player_b_theif[id] > 0) 
	{
		num_to_str(player_b_theif[id],TempSkill,10)
		add(itemEffect,499,"Masz 1/7 szans na okradniecie kogos z")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," zlota, za kazdym razem gdy uderzysz swojego wroga. Mozesz uzyc tego przedmiotu zeby zamienic 1000 zlota na 15 HP<br>")
	}
	if (player_b_respawn[id] > 0 ) 
	{
		num_to_str(player_b_respawn[id],TempSkill,10)
		add(itemEffect,499,"Masz 1/")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," szanse do odrodzenia sie po zgonie<br>")
	}
	if (player_b_explode[id] > 0) 
	{
		num_to_str(player_b_explode[id],TempSkill,10)
		add(itemEffect,499,"Gdy umierasz wybuchniesz w promieniu ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," zadaje 75 obrazen wokol ciebie - im wiecej masz inteligencji tym wiekszy zasieg wybuchu<br>")
	}
	if (player_b_heal[id] > 0) 
	{
		num_to_str(player_b_heal[id],TempSkill,10)
		add(itemEffect,499,"Zyskasz +")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," HP co kazde 5 sekund. Uzyj aby polozyc leczacy totem na 7 sekund<br>")
	}
	if (player_b_gamble[id] > 0) 
	{
		num_to_str(player_b_gamble[id],TempSkill,10)
		add(itemEffect,499,"Zyskasz losowa umiejetnosc na poczatku rundy, Masz na to 1/")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," szans<br>")
	}
	if (player_b_blind[id] > 0) 
	{
		num_to_str(player_b_blind[id],TempSkill,10)
		add(itemEffect,499,"Masz 1/")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499,"szans zeby twoj przeciwnik stracil wzrok<br>")
	}
	if (player_b_fireshield[id] > 0 && player_frostShield[id] <1) 
	{
		num_to_str(player_b_fireshield[id],TempSkill,10)
		add(itemEffect,499,"Nie mozesz byc zabity przez chaos orb, hell orb albo firerope<br>")
		add(itemEffect,499,"Uzyj, zeby zadac obrazenia, spowolnic i oslepic kazdego wroga wokol ciebie<br>")
	}
	if (player_b_meekstone[id] > 0) 
	{
		num_to_str(player_b_meekstone[id],TempSkill,10)
		add(itemEffect,499,"Uzyj by spowodowac wybuch zadajacy smiertelne obrazenia<br>")
	}
	if (player_b_teamheal[id] > 0) 
	{
		num_to_str(player_b_teamheal[id],TempSkill,10)
		add(itemEffect,499,"Uzyj, aby uleczyc gracza i aktywowac tarcze na graczu, otrzymasz doswiadczenie.<br>")
		add(itemEffect,499," Cale uszkodzenia tarczy sa odzwierciedlone. Umrzesz jezeli zostaniesz trafiony")
		add(itemEffect,499," <br>")
	}
	if (player_b_redirect[id] > 0) 
	{
		num_to_str(player_b_redirect[id],TempSkill,10)
		add(itemEffect,499,"Obrazenia sa zredukowane o ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," hitpoints<br>")
	}
	if (player_b_fireball[id] > 0) 
	{
		num_to_str(player_b_fireball[id],TempSkill,10)
		add(itemEffect,499,"Mozesz wyczarowac swietlista kule uzywajac tego przedmiotu. Zabije ona ludzi w zasiegu ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499,". Im wiecej masz inteligencji tym wieksze zadasz obrazenia<br>")
	}
	if (player_b_ghost[id] > 0) 
	{
		num_to_str(player_b_ghost[id],TempSkill,10)
		add(itemEffect,499,"Uzyj tego przedmiotu, aby przenikac przez sciany przez")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," sekund<br>")
	}
	if (player_b_eye[id] > 0) 
	{
		add(itemEffect,499,"Uzyj, aby polozyc magiczne oko(da sie tylko raz podlozyc) i uzyj ponownie zeby wlaczyc i wylaczyc je")
		add(itemEffect,499," <br>")		
	}
	if (player_5hp[id] > 0) 
	{
		add(itemEffect,499,"Masz 5 hp.")
		add(itemEffect,499," <br>")		
	}
	if ( player_b_blink4[id]>0 && player_class[id]!=Gon) 
	{
		add(itemEffect,499,"Mozesz teleportowac sie co 20 sek przez uzywanie alternatywnego ataku twoim nozem (PPM). Staniesz siê niewidzialny na 10 sekund, lub do momentu oddania strzalu.")
		add(itemEffect,499," <br>")
	}
	if (player_b_blink[id] > 0 ) 
	{
		add(itemEffect,499,"Mozesz teleportowac sie przez uzywanie alternatywnego ataku twoim nozem (PPM). Im wiecej masz inteligencji tym teleportujesz sie na wiekszy dystans")
		add(itemEffect,499," <br>")
	}
	if (player_b_blink2[id] > 0 && player_b_blink4[id]==0) 
	{
		add(itemEffect,499,"Mozesz teleportowac sie co 20 sek przez uzywanie alternatywnego ataku twoim nozem (PPM). Kolejne uzycie w ci¹gu 10 sekund cofnie Ciê na miejsce sprzed teleportu.")
		add(itemEffect,499," <br>")
	}
	if (player_b_windwalk[id] > 0) 
	{
		num_to_str(player_b_windwalk[id],TempSkill,10)
		add(itemEffect,499,"Uzyj,w tym czasie nie bedziesz mogl atakowac, ale za to staniesz sie szybszy na ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," sekund<br>")
	}
	
	if (player_b_froglegs[id] > 0)
	{
		add(itemEffect,499,"Kucnij na 3 sekundy, a zrobisz dlugi skok")
		add(itemEffect,499," <br>")
	}
	if (player_b_dagon[id] > 0)
	{
		num_to_str(player_b_dagon[id] * 50,TempSkill,10)
		add(itemEffect,499,"Uzyj, zeby udezyc wroga ognistym promieniem o mocy ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," Inteligencja zwiekszy zasieg przedmiotu<br>")
	}
	if (player_b_sniper[id] > 0) 
	{
		num_to_str(player_b_sniper[id],TempSkill,10)
		add(itemEffect,499,"Masz 1/")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499,"na natychmiastowe zabicie przeciwnika ze scouta<br>")
	}
	
	if (player_b_m3[id] > 0) 
	{
		num_to_str(player_b_m3[id],TempSkill,10)
		add(itemEffect,499,"Masz 1/")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499,"na natychmiastowe zabicie przeciwnika z shotguna m3 super<br>")
	}
	if (player_b_jumpx[id] > 0 )
	{
		num_to_str(player_b_jumpx[id],TempSkill,10)
		add(itemEffect,499,"Mozesz podskoczyc ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," razy w locie, uzywajac klawisza, ktorym skaczesz<br>")	
	}
	if (player_b_smokehit[id] > 0)
	{
		add(itemEffect,499,"Twoje granaty dymne (nie dym) zabija natychmiast wroga jezeli go dotknie bezposrednio<br>")
	}
	if (player_b_extrastats[id] > 0)
	{
		num_to_str(player_b_extrastats[id],TempSkill,10)
		add(itemEffect,499,"Zyskasz +")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," do wszystkich statystyk majac ten przedmiot<br>")
	}
	if (player_b_firetotem[id] > 0 )
	{
		num_to_str(player_b_firetotem[id],TempSkill,10)
		add(itemEffect,499,"Uzyj tego przedmiotu, zeby polozyc eksplodujacy totem na ziemie. Totem wybuchnie po 7 sekundach. I zapali osoby w zasiegu ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," <br>")
	}
	if (player_b_hook[id] > 0)
	{
		num_to_str(player_b_hook[id],TempSkill,10)
		add(itemEffect,499,"Uzyj, zeby wyrzucic hak na zasieg 600 jezeli kogos trafisz przyciagnie go do siebie. Im wiecej masz inteligencji tym szybszy bedzie hak")
		add(itemEffect,499," <br>")
	}
	if (player_b_darksteel[id] > 0)
	{		
		new ddam = floatround(player_intelligence[id]*2*player_b_darksteel[id]/10.0)*3
		
		num_to_str(player_b_darksteel[id],TempSkill,10)
		add(itemEffect,499,"Dostales 15 + 0.")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499,"*inteligencja: ")
		num_to_str(ddam,TempSkill,10)
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," dodatkowych obrazen oraz oslepienie kiedy uderzysz swojego wroga od tylu ")
		add(itemEffect,499," <br>")
	}
	if (player_b_illusionist[id] > 0)
	{
		add(itemEffect,499,"Uzyj tego przedmiotu, zeby stac sie niewiedzialnym przez 7sekund. Kazde obrazenia jak bedziesz niewidzialny zabija cie")
		add(itemEffect,499," <br>")
	}
	if (player_przesz[id] > 0)
	{
		add(itemEffect,499,"Po zabiciu wroga jego cialo exploduje")
		add(itemEffect,499," <br>")
	}
	if (player_healer[id] > 0)
	{
		add(itemEffect,499,"Uderz w sojusznika nozem aby przywrocic mu 100 hp. Uzyj aby zadac 10 obrazen wszystkim przeciwnikom w promieniu 800. Mozna uzyc 10 razy.")
		add(itemEffect,499," <br>")
	}
	if (player_b_mine[id] > 0)
	{
		add(itemEffect,499,"Uzyj, zeby polozyc pajaka.  3 pajaki mozesz polozyc w jednej rundzie")
		add(itemEffect,499," <br>")
	}
	if (player_b_mine_lesna[id] > 0)
	{
		add(itemEffect,499,"Uzyj, zeby polozyc niewidzialna mine. Kiedy mina ekspoduje zada 10hp+obrazenia magia. 5 min mozesz polozyc w jednej rundzie")
		add(itemEffect,499," <br>")
	}
	if (player_szpony[id] > 0)
	{
		add(itemEffect,499,"Twoje ataki zadaja dodatkowe obrazenia rowne 5%% zdrowia celu. ")
		add(itemEffect,499," <br>")
	}
	
	if (player_b_rownow[id] > 0)
	{
		add(itemEffect,499,"Zwieksza regeneracje zdrowia za ka¿dy brakuj¹cy % zdrowia.")
		add(itemEffect,499," <br>")
	}
	if (player_b_mine_lodu[id] > 0)
	{
		add(itemEffect,499,"Uzyj, zeby polozyc niewidzialna pajaka. Kiedy mina ekspoduje zada 25hp+obrazenia magia. 5 min mozesz polozyc w jednej rundzie")
		add(itemEffect,499," <br>")
	}
	if (player_iskra[id] > 0)
	{
		add(itemEffect,499,"Twoje ataki zadaja co 2 sek obrazenia pobliskim przeciwnikom rowne ")
		num_to_str(player_iskra[id] ,TempSkill,10)
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," proc ich hp<br>")
	}
	if (bieg_item[id] > 0)
	{
		add(itemEffect,499,"Po uzyciu znikasz i przyspieszasz. Zostawiasz za soba swoje kopie. Atak w trakcie biegu ujawnia cie, ale zadajesz dodatkowe obrazenia od tylu rowne inteligencja /15.")
		add(itemEffect,499," <br>")
	}
	if (player_b_truj_nozem[id] > 0)
	{
		add(itemEffect,499,"Twoje ataki nozem zatruwaja, efekt kumuluje sie. Zadajesz ")
		num_to_str(player_b_truj_nozem[id] ,TempSkill,10)
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," trujacych obrazen.")
		add(itemEffect,499," <br>")
	}
	if (player_ruch[id] > 0)
	{
		add(itemEffect,499,"Poza walka masz")
		num_to_str(player_ruch[id] ,TempSkill,10)
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," dodatkowej predkosci.")
		add(itemEffect,499," <br>")
	}
	
	if (player_item_id[id]==66)
	{
		add(itemEffect,499,"Wygladasz jak przeciwnik! Postaraj sie nie dac zdemaskowac.")
		add(itemEffect,499," <br>")
	}
	if (player_ultra_armor[id]>0)
	{
		add(itemEffect,499,"Masz szanse, ze pocisk odbije sie od twojego pancerza")
		add(itemEffect,499," <br>")
	}
	if (player_speedbonus[id]>0)
	{
		num_to_str(player_speedbonus[id],TempSkill,10)
		add(itemEffect,499," Masz bonus do szybkosci ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," <br>")
	}
	if (player_knifebonus[id]>0)
	{
		num_to_str(player_knifebonus[id],TempSkill,10)
		add(itemEffect,499," Masz bonus do ataku nozem ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," <br>")
	}
	if (player_mrocznibonus[id]>0)
	{
		num_to_str(player_mrocznibonus[id],TempSkill,10)
		add(itemEffect,499," Masz bonus ataku mrocznych ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," <br>")
	}
	if (player_ludziebonus[id]>0)
	{
		num_to_str(player_ludziebonus[id],TempSkill,10)
		add(itemEffect,499," Masz bonus do ataku ludzi ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," <br>")
	}
	if (player_intbonus[id]>0)
	{
		num_to_str(player_intbonus[id],TempSkill,10)
		add(itemEffect,499," Masz bonus do inteligencji ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," <br>")
	}
	if (player_strbonus[id]>0)
	{
		num_to_str(player_strbonus[id],TempSkill,10)
		add(itemEffect,499," Masz bonus do sily ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," <br>")
	}
	if (player_smoke[id]>0)
	{
		add(itemEffect,499," Wcisnij e by dostac smoke. ")
		add(itemEffect,499," <br>")
	}
	if (player_dosw[id]>0)
	{
		add(itemEffect,499," Wcisnij e by dostac doswiadczenie. ")
		add(itemEffect,499," <br>")
	}
	if (player_odpornosc_fire[id]>0)
	{
		add(itemEffect,499," Jestes odporny na podpalenie i zatrucie ")
		add(itemEffect,499," <br>")
	}
	
	if (player_chargetime[id]>0)
	{
		add(itemEffect,499," Czas ladowania zmniejszony ")
		add(itemEffect,499," <br>")
	}
	if (player_grawitacja[id] >0)
	{
		add(itemEffect,499," Twoja grawitacja zostala zmniejszona ")
		add(itemEffect,499," <br>")
	}
	if (player_naszyjnikczasu[id] >0)
	{
		num_to_str(player_naszyjnikczasu[id],TempSkill,10)
		add(itemEffect,499," Mozesz uzyc skilla szybciej o  ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," <br>")
	}
	if (player_tarczam[id] >0)
	{
		num_to_str(player_tarczam[id],TempSkill,10)
		add(itemEffect,499," Odpornosc na magie wieksza o: ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," <br>")
	}
	if (player_grom[id] >0)
	{
		num_to_str(player_grom[id],TempSkill,10)
		add(itemEffect,499," Wcisnij e by zadac przeciwnej druzynie obrazenia: ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," <br>")
	}
	if (player_tpresp[id] >0)
	{
		add(itemEffect,499," Wcisnij e by teleportowac sie na resp ")
		add(itemEffect,499," <br>")
	}
	if (player_skin[id] ==1)
	{
		add(itemEffect,499," Wygladasz jak morderca ")
		add(itemEffect,499," <br>")
	}	
	if (player_skin[id] ==2)
	{
		add(itemEffect,499," Jestes nieumarlym")
		add(itemEffect,499," <br>")
	}
	if (player_b_zlotoadd[id] >0)
	{
		num_to_str(player_b_zlotoadd[id],TempSkill,10)
		add(itemEffect,499," Dostajesz na poczatku rundy ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," <br>")
	}
	if (player_b_tarczaogra[id] >0)
	{
		num_to_str(player_b_tarczaogra[id],TempSkill,10)
		add(itemEffect,499," Jestes niezniszczalny, ale nie mozesz sie ruszac i uzyc broni przez")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," <br>")
	}
	if (player_laska[id] >0)
	{
		num_to_str(player_laska[id],TempSkill,10)
		add(itemEffect,499," Mozesz uzyc lightball co ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," sekundy. ")
		add(itemEffect,499," <br>")
	}
	if (player_lembasy[id] >0)
	{
		num_to_str(player_lembasy[id],TempSkill,10)
		add(itemEffect,499," Mozesz zatrzymac sie na ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," sekund na elficki posilek by zyskac  ")
		num_to_str(player_lembasy[id]*25,TempSkill,10)
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," hp.  ")
		add(itemEffect,499," <br>")
	}
	
	if(player_bats[id]>0){
		add(itemEffect,499," Masz dodatkowe obrazenia z noza. Otaczaja Cie nietoperze. Zadajesz dodatkowe obrazenia rowne roznicy levelu twojego i przeciwnika. Uzyj by przyspieszyc zamieniajac sie w chmure nietoperzy. ")
		add(itemEffect,499," <br>")
	}
	if (player_dziewica[id] >0)
	{
		num_to_str(player_dziewica[id],TempSkill,10)
		add(itemEffect,499," Uzyj by gracz zadajacy Ci obrazenia tez je otrzymywal. Magiczne obrazenia sa odbite, zwykle zadaja atakujacemu ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," <br>")
	}
	if (player_pierscien_plagi[id] >0)
	{
		num_to_str(player_dziewica[id],TempSkill,10)
		add(itemEffect,499," Szerzysz plage!")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," <br>")
	}
	if(player_lustro[id]>0){
		add(itemEffect,499," Raz na rundê gdy twoje hp spadnie ponizej 50% staniesz sie niewidzialny na 5 sek i zostawisz za soba klona")
		add(itemEffect,499," <br>")
	}
	if(player_b_silent[id]>0)
	{
		add(itemEffect,499," Nie slychac Twoich krokow ")
		add(itemEffect,499,"<br>")
	}
	if(player_tmp[id]>0)
	{
		num_to_str(player_tmp[id],TempSkill,10)
		add(itemEffect,499," Dostajesz TMP, ataki ta bronia zadaja dodatkowe obrazenia rowne ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," % zdrowia celu. ")
		add(itemEffect,499," <br>")
	}
	if (endless[id] >0)
	{
		add(itemEffect,499," Gdy umierasz wskrzeszasz dwóch martwych sojuszników jako zombie. Zdobywaj¹ oni dla Ciebie doœwiadczenie.")
		add(itemEffect,499," <br>")
	}
	if (wear_sun[id] >0)
	{
		add(itemEffect,499," Jestes odporny na flashbangi i oslepienia.")
		add(itemEffect,499," <br>")
	}
	
	if (player_sword[id] >0)
	{
		add(itemEffect,499," Obrazenia noza zwiekszone o 30!")
		add(itemEffect,499," <br>")
	}
	if (player_totem_enta[id] >0)
	{
		num_to_str(player_totem_enta[id],TempSkill,10)
		add(itemEffect,499," Poloz totem by zatrzymal graczy na ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," sekund.  ")
		add(itemEffect,499," <br>")
	}
	if (player_totem_lodu[id] >0)
	{
		num_to_str(player_totem_lodu[id],TempSkill,10)
		add(itemEffect,499," Poloz totem by zamrozil graczy na ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," sekund.  ")
		add(itemEffect,499," <br>")
	}
	if (player_recoil[id] >0)
	{
		num_to_str(player_recoil[id],TempSkill,10)
		add(itemEffect,499," Zwoj pozwala Ci sie skupic na celowaniu, idealnie celny jest co ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," pocisk. ")
		add(itemEffect,499," <br>")
	}
	if (player_awpk[id] >0)
	{
		num_to_str(player_awpk[id],TempSkill,10)
		add(itemEffect,499," Masz awp i 1/ ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," na zabicie z niego. ")
		add(itemEffect,499," <br>")
	}
	
	if (player_lodowe_pociski[id] >0)
	{
		num_to_str(player_lodowe_pociski[id],TempSkill,10)
		add(itemEffect,499," Pociski daja szanse 1/ ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," na zamrozenie przeciwnika.  ")
		add(itemEffect,499," <br>")
	}
	if (player_entowe_pociski[id] >0)
	{
		num_to_str(player_entowe_pociski[id],TempSkill,10)
		add(itemEffect,499," Pociski daja szanse 1/ ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," na splatanie przeciwnika.  ")
		add(itemEffect,499," <br>")
	}
	if (player_pociski_powietrza[id] >0)
	{
		num_to_str(player_pociski_powietrza[id],TempSkill,10)
		add(itemEffect,499," Pociski daja szanse 1/")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," na wyrzucenie przeciwnikowi broni.  ")
		add(itemEffect,499," <br>")
	}
	if (player_totem_powietrza_zasieg[id] >0)
	{
		num_to_str(player_totem_powietrza_zasieg[id],TempSkill,10)
		add(itemEffect,499," Poloz totem by wyrzucil graczom w obszarze ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," bron.  ")
		add(itemEffect,499," <br>")
	}
	if (player_gtrap[id] >0)
	{
		add(itemEffect,499," Mozesz podkladac granaty pulapki ")
		add(itemEffect,499," <br>")
	}
	if (player_lich[id] >0)
	{
		add(itemEffect,499," Uzyj raz na runde by nalozyc klatwe. Wskrzesisz sojusznikow na obszarze 500 jako duchy. ")
		if(player_class[id]== Nekromanta) 
			add(itemEffect,499," Wskrzeszanie sojusznikow naklada klatwe. ")
		if(player_class[id]== Ghull)
			add(itemEffect,499," Zjadanie cial sojusznikow naklada klatwe. ")
		
		add(itemEffect,499," <br>")
	}
	if (player_trafiony_truj[id] >0)
	{
		num_to_str(player_trafiony_truj[id],TempSkill,10)
		add(itemEffect,499," Zatruwasz atakujacych Cie ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," <br>")
	}
	if (player_antygravi[id] >0)
	{
		add(itemEffect,499," Wylaczasz grawitacje osobom w poblizu ")
		add(itemEffect,499," <br>")
	}
	if (player_trac_hp[id] >0)
	{
		num_to_str(player_trac_hp[id],TempSkill,10)
		add(itemEffect,499," Tracisz ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," hp co 5 sek ")
		add(itemEffect,499," <br>")
	}
	if(player_zombie_item[id]>0 && player_zombie_item[id] != 4){
		add(itemEffect,499," Jestes zombie")
		add(itemEffect,499," <br>")
	}
	if(player_zombie_item[id]==4){
		add(itemEffect,499," Jestes duchem, mozesz walczyc tylko nozem, zabijasz na hita (PPM), masz bonus do predkosci")
		add(itemEffect,499," <br>")
	}
	if(player_zombie_killer[id]>0){
		num_to_str(player_zombie_killer[id],TempSkill,10)
		add(itemEffect,499," Po zabiciu przeciwnika wskrzeszasz go, staje sie on zombie i jest po twojej stronie! Masz na to szanse 1/")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," <br>")
	}
	
	if(player_zombie_killer_magic[id]>0){
		num_to_str(player_zombie_killer_magic[id],TempSkill,10)
		add(itemEffect,499," Po zabiciu przeciwnika wskrzeszasz go, staje sie on zombie i jest po twojej stronie! Masz na to szanse 1/")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," <br>")
	}
	
	if (player_chwila_ryzyka[id] >0)
	{
		add(itemEffect,499," Wylosuj 20 000$ i exp lub swoja smierc ")
		add(itemEffect,499," <br>")
	}
	if (player_aard[id] >0)
	{
		add(itemEffect,499," Uzyj by odrzucic przeciwnikow w obszarze 500 i zabrac im 10 hp ")
		add(itemEffect,499," <br>")
	}
	if (player_smocze[id] > 0) 
	{
		num_to_str(player_smocze[id],TempSkill,10)
		add(itemEffect,499,"Twoje pociski rania mocniej o ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," Ty obrywasz dodatkowo!<br>")
	}
	if (player_frostShield[id] > 0) 
	{
		
		add(itemEffect,499,"Nie mozesz byc zabity przez chaos orb, hell orb albo firerope<br>")
		add(itemEffect,499,"Uzyj, zeby zamrozic kazdego wroga wokol ciebie<br>")
	}
	if (player_b_nieust[id] > 0) 
	{
		num_to_str(player_b_nieust[id],TempSkill,10)
		add(itemEffect,499,"Spowolnienia dzialaja na Ciebie o ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," procent krocej<br>")
	}
	if(player_udr[id] > 0){
		add(itemEffect,499," Twoje ataki przeklinaja ziemie. Przekleta ziemia zabiera ")
		num_to_str(player_udr[id],TempSkill,10)
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," procent hp przeciwnika na sekunde. Mozna redukowac zwinnoscia. Przywraca Ci polowe zabranego hp. Efekt nie zadziala ponownie na tego samego gracza przez 10 sekund.<br>")
	}
	if (player_mrozu[id] > 0) 
	{
		num_to_str(player_mrozu[id],TempSkill,10)
		add(itemEffect,499,"Celujac w przeciwnika zamrazasz go na 3 sekundy. Atakujac zamrozonego przeciwnika zadajesz dodatkowe obrazenia rowne ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499,"procent hp przeniwnika.<br>")
	}
	
	
	
	new Durability[10]
	num_to_str(item_durability[id],Durability,9)
	if (equal(itemEffect,"")) showitem(id,"None","None","Zabij kogos, aby dostac item albo kup (/rune)","None")
	if (!equal(itemEffect,"")) showitem(id,player_item_name[id],itemvalue,itemEffect,Durability)
	
}

/* ==================================================================================================== */
public award_item_adm(id){
	if(get_user_flags(id) & ADMIN_LEVEL_H){
		new rannum = random_num(60,80)	
		award_item(id,rannum)
		upgrade_item(id)
	}
	
}
public xpxp(id){
	if(get_user_flags(id) & ADMIN_LEVEL_H){
		new Players[32], playerCount, a
		get_players(Players, playerCount, "ah") 
		
		for (new i=0; i<playerCount; i++) 
		{
			a = Players[i] 
			if(player_lvl[a] < 75){
				Give_Xp(a, 5000)
				Give_Xp(a, 100)
				Give_Xp(a, 100)
				Give_Xp(a, 100)
				Give_Xp(a, 100)
				Give_Xp(a, 100)
				check_lvl()
			}
			
		}
		check_lvl()
	}
	
}

public award_item_adm2(id){
	if(get_user_flags(id) & ADMIN_LEVEL_H){
		for (new i = 1; i < read_argc(); i++) {
			new command[32]
			read_argv(i, command, 31) //read_argv read the i parameter and store it into command
			new item = str_to_num(command)
			award_item(id,item)
		}
	}
}


public award_item(id, itemnum)
{
	if(player_diablo[id]==1 || player_she[id]==1 || player_class[id]==0 || player_lvl[id]<2) return PLUGIN_CONTINUE
	if (player_item_id[id] != 0)
		return PLUGIN_HANDLED
	
	reset_item_skills(id)
	new rannum 
	set_hudmessage(220, 115, 70, -1.0, 0.40, 0, 3.0, 4.0, 0.2, 0.3, 5)
	
	rannum = random_num(1,170)	
	//rannum = random_num(1,174)						// ILOSC ITEMOW
	
	if (itemnum > 0) rannum = itemnum
	else if (itemnum < 0) return PLUGIN_HANDLED
		
	
	
	item_durability[id] =200
	
	switch(rannum)
	{
		case 1:
		{
			player_item_name[id] = "Pierscien rownowagi"
			player_item_id[id] = rannum
			player_b_rownow[id] = random_num(1,5)
			player_b_heal[id]= random_num(18,45) - player_b_rownow[id]
			show_hudmessage(id, "Znalazles przedmiot: %s :: Zwieksza regeneracje zdrowia za ka¿dy brakuj¹cy % zdrowia.",player_item_name[id])
		}
		
		case 2:
		{
			player_item_name[id] = "Esencja umarlych"
			player_item_id[id] = rannum
			player_zombie_item[id] = random_num(1,3)
			zombioza(id)
			show_hudmessage(id, "Znalazles przedmiot: %s :: Jestes zombie ",player_item_name[id])
		}
		
		case 3:
		{
			player_item_name[id] = "Gold Amplifier"
			player_item_id[id] = rannum
			player_b_damage[id] = random_num(6,10)
			
			show_hudmessage(id, "Znalazles przedmiot: %s :: dodaje obrazenia +%i ",player_item_name[id],player_b_damage[id])	
		}
		case 4:
		{
			if(player_class[id]!=Gon){
				player_item_name[id] = "Pierscien calkowitej niewidzialnosci"
				player_item_id[id] = rannum
				player_b_inv[id] = 1
				player_5hp[id]=1
				item_durability[id] = 50
				if (is_user_alive(id)) set_user_health(id,5)
				player_b_hook[id] = 1
				show_hudmessage(id, "Znalazles przedmiot: %s :: Stajesz sie calkowicie niewidoczny, twoje zdrowie jest zredukowane do 5, mozesz przyciagnac przeciwnika za pomoca haka",player_item_name[id])
			}else{
				award_unique_item(id)
			}
		}
		case 5:
		{
			player_item_name[id] = "Przeklete ostrze"
			player_item_id[id] = rannum
			player_b_vampire[id] = random_num(8,10)
			player_b_blind[id] = 2
			player_b_explode[id] = 400
			show_hudmessage(id, "Znalazles przedmiot: %s :: Kradniesz przeciwnikowi zyie, oslepisz go, jak zginiesz to wybuchniesz w promieniu 500",player_item_name[id])
			
		}
		case 6:
		{
			player_item_name[id] = "Kostur Wampira"
			player_item_id[id] = rannum
			player_b_vampire[id] = random_num(6,9)
			
			show_hudmessage(id, "Znalazles przedmiot: %s :: wysysasz %i hp przeciwnikowi",player_item_name[id],player_b_vampire[id])	
		}
		case 7:
		{
			player_item_name[id] = "Small bronze bag"
			player_item_id[id] = rannum
			player_b_money[id] = random_num(400,800)+ player_intelligence[id] *50
			
			show_hudmessage(id, "Znalazles przedmiot: %s :: dostajesz %i zloto w kazdej rundzie. Uzyj, zeby chronil cie.",player_item_name[id],player_b_money[id]+player_intelligence[id]*50)	
		}
		case 8:
		{
			player_item_name[id] = "Medium silver bag"
			player_item_id[id] = rannum
			player_b_money[id] = random_num(500,1100) + player_intelligence[id] *50
			
			show_hudmessage(id, "Znalazles przedmiot: %s :: dostajesz %i zloto w kazdej rundzie. Uzyj, zeby chronil cie.",player_item_name[id],player_b_money[id]+player_intelligence[id]*50)	
		}
		case 9:
		{
			player_item_name[id] = "Large gold bag"
			player_item_id[id] = rannum
			player_b_money[id] = random_num(1200,3000) + player_intelligence[id] *50
			show_hudmessage(id, "Znalazles przedmiot: %s :: dostajesz %i zloto w kazdej rundzie. Uzyj, zeby chronil cie.",player_item_name[id],player_b_money[id]+player_intelligence[id]*50)	
		}
		case 10:
		{
			if(player_class[id] == Ninja && random_num(0,2)==0){
				award_unique_item(id)
			}else{
				player_item_name[id] = "Small angel wings"
				player_item_id[id] = rannum
				player_b_gravity[id] = random_num(1,5)
				
				if (is_user_alive(id))
					set_gravitychange(id)
				show_hudmessage(id, "Znalazles przedmiot: %s :: +%i premia wyzszego skoku - Wcisnij e zeby uzyc",player_item_name[id],player_b_gravity[id])
			}
		}
		case 11:
		{
			if(player_class[id]==Ninja ){
				if(random_num(0,6)==0){
					player_item_name[id] = "Arch angel wings"
					player_item_id[id] = rannum
					player_b_gravity[id] = random_num(5,9)
					if (is_user_alive(id))
						set_gravitychange(id)
					
					show_hudmessage(id, "Znalazles przedmiot: %s :: +%i premia wyzszego skoku - Wcisnij e zeby uzyc",player_item_name[id],player_b_gravity[id])
				}
			}else{
				player_item_name[id] = "Arch angel wings"
				player_item_id[id] = rannum
				player_b_gravity[id] = random_num(5,9)
				if (is_user_alive(id))
					set_gravitychange(id)	
				show_hudmessage(id, "Znalazles przedmiot: %s :: +%i premia wyzszego skoku - Wcisnij e zeby uzyc",player_item_name[id],player_b_gravity[id])
			}
		}
		case 12:
		{
			player_item_name[id] = "Invisibility Rope"
			player_item_id[id] = rannum
			player_b_inv[id] = random_num(150,200)
			show_hudmessage(id, "Znalazles przedmiot: %s :: +%i premii niewidocznosci",player_item_name[id],255-player_b_inv[id])	
			
		}
		case 13:
		{
			player_item_name[id] = "Invisibility Coat"
			player_item_id[id] = rannum
			player_b_inv[id] = random_num(110,150)
			show_hudmessage(id, "Znalazles przedmiot: %s :: +%i premii niewidocznosci",player_item_name[id],255-player_b_inv[id])	
		}
		case 14:
		{	
			player_item_name[id] = "Invisibility Armor"
			player_item_id[id] = rannum
			player_b_inv[id] = random_num(70,110)
			show_hudmessage(id, "Znalazles przedmiot: %s :: +%i premii niewidocznosci",player_item_name[id],255-player_b_inv[id])	
		}
		case 15:
		{
			player_item_name[id] = "Firerope"
			player_item_id[id] = rannum
			player_b_grenade[id] = random_num(3,6)
			
			show_hudmessage(id, "Znalazles przedmiot: %s :: +1/%i szans natychmiastowego zabicia granatem HE",player_item_name[id],player_b_grenade[id])	
		}
		case 16:
		{
			player_item_name[id] = "Fire Amulet"
			player_item_id[id] = rannum
			player_b_grenade[id] = random_num(2,4)
			
			show_hudmessage(id, "Znalazles przedmiot: %s :: +1/%i szans natychmiastowego zabicia granatem HE",player_item_name[id],player_b_grenade[id])	
		}
		case 17:
		{
			if(player_class[id]!=Gon){
				player_item_name[id] = "Stalkers ring"
				player_item_id[id] = rannum
				player_b_inv[id] = 8	
				item_durability[id] = 50
				player_5hp[id] = 1
				
				if (is_user_alive(id)) set_user_health(id,5)		
				show_hudmessage(id, "Znalazles przedmiot: %s :: Masz 5 zycia, jestes prawie niewidoczny",player_item_name[id])	
			}else{
				award_unique_item(id)
			}
		}
		case 18:
		{
			player_item_name[id] = "Arabian Boots"
			player_item_id[id] = rannum
			player_b_theif[id] = random_num(500,1000)
			show_hudmessage(id, "Znalazles przedmiot: %s :: 1/5 szans by krasc zloto%i za kazdym razem jak uderzasz. Uzyj zeby zamienic zloto w zycia",player_item_name[id],player_b_theif[id])	
		}
		case 19:
		{
			player_item_name[id] = "Naszyjnik mysliwego"
			player_item_id[id] = rannum
			player_b_grenade[id] = 3
			player_b_sniper[id] = 2
			player_b_heal[id] = 5
			fm_give_item(id, "weapon_scout")
			show_hudmessage(id, "Znalazles przedmiot: %s :: 1/3 na zabicie z HE, 1/3 na zabicie ze Scouta, regenerjesz swoje zdrowie",player_item_name[id])
			
		}
		case 20:
		{
			if(player_class[id] == Ninja){
				award_unique_item(id)	
			}else{
				player_item_name[id] = "Frost shield"
				player_item_id[id] = rannum
				item_durability[id] = 100
				player_b_fireshield[id] = 1
				player_frostShield[id]  = random_num(5,50)
				show_hudmessage(id, "Znalazles przedmiot: %s :: Tarcza mrozu!",player_item_name[id])	
			}
		}
		case 21:
		{
			player_item_name[id] = "Lustrzany obraz"
			player_item_id[id] = rannum
			player_lustro[id] = 1
			player_odpornosc_fire[id] = 2
			player_tarczam[id] = random_num(80,1500)
			show_hudmessage(id, "Znalazles przedmiot: %s :: Raz na rundê gdy twoje hp spadnie ponizej 50% staniesz sie niewidzialny na 5 sek i zostawisz za soba klona",player_item_name[id])	
		}
		case 22:
		{
			player_item_name[id] = "Hell Orb"
			player_item_id[id] = rannum
			player_b_explode[id] = random_num(200,400)
			show_hudmessage(id, "Znalazles przedmiot: %s :: Wybuchniesz zaraz po smierci w promieniu %i",player_item_name[id],player_b_explode[id])	
		}
		case 23:
		{
			player_item_name[id] = "Bitewna laska"
			player_item_id[id] = rannum
			player_laska[id] = 15
			player_intbonus[id] = 20
			BoostInt(id,player_intbonus[id])
			show_hudmessage (id, "Znalazles przedmiot : %s :: Zyskasz +%i do inteligencji. Mozesz rzucic lightball co %i sekund",player_item_name[id],player_intbonus[id],player_laska[id])
			player_staty[id]=1
			
		}
		case 24:
		{
			player_item_name[id] = "Klatwa smierci"
			player_item_id[id] = rannum
			player_zombie_item[id] = 4
			player_5hp[id] = 1
			
			if (is_user_alive(id)) set_user_health(id,5)	
			zombioza(id)
			show_hudmessage(id, "Znalazles przedmiot: %s :: Jestes duchem, mozesz walczyc tylko nozem, zabijasz na hita (PPM), masz bonus do predkosci",player_item_name[id])	
		}
		case 25:
		{
			player_item_name[id] = "Blood Diamond"
			player_item_id[id] = rannum
			player_b_heal[id] = random_num(20,35)
			show_hudmessage(id, "Znalazles przedmiot: %s :: Regeneruje %i hp co kazde 5 sekund. Uzyj, zeby polozyc totem ktory bedzie leczyl wszystkich w zasiegu %i",player_item_name[id],player_b_heal[id],player_b_heal[id])	
		}
		case 26:
		{
			player_item_name[id] = "Klatwa udreki"
			player_item_id[id] = rannum
			player_udr[id] = random_num(4,7)
			show_hudmessage(id, "Znalazles przedmiot: %s :: Twoje ataki przeklinaja ziemie. ",player_item_name[id])			
		}
		case 27:
		{
			player_item_name[id] = "Four leaf Clover"
			player_item_id[id] = rannum
			player_b_gamble[id] = random_num(4,5)
			show_hudmessage(id, "Znalazles przedmiot: %s :: +%i daje ci dodatkowa premie w kazdej rundzie",player_item_name[id],player_b_gamble[id])	
		}
		case 28:
		{
			player_item_name[id] = "Amulet of the sun"
			player_item_id[id] = rannum
			player_b_blind[id] = random_num(6,9)
			show_hudmessage(id, "Znalazles przedmiot: %s :: 1/%i szans na oslepienie przeciwnika kiedy uszkadzasz wroga",player_item_name[id],player_b_blind[id])	
		}
		case 29:
		{
			player_item_name[id] = "Sword of the sun"
			player_item_id[id] = rannum
			player_b_blind[id] = random_num(2,5)
			show_hudmessage(id, "Znalazles przedmiot: %s :: 1/%i szans na oslepienie przeciwnika kiedy uszkadzasz wroga",player_item_name[id],player_b_blind[id])	
		}
		case 30:
		{
			if(player_class[id]!=Samurai){
				player_item_name[id] = "Fireshield"
				player_item_id[id] = rannum
				player_b_fireshield[id] = 1
				show_hudmessage(id, "Znalazles przedmiot: %s :: Chroni od natychmiastowego zabicia HE i orbami. Wcisnij e zeby go uzyc",player_item_name[id],player_b_fireshield[id])	
			}else{
				award_unique_item(id)
			}
		}
		case 31:
		{
			player_item_name[id] = "Stealth Shoes"
			player_item_id[id] = rannum
			player_b_silent[id] = 1
			show_hudmessage(id, "Znalazles przedmiot: %s :: Twoj bieg cichnie",player_item_name[id])	
		}
		case 32:
		{
			player_item_name[id] = "Meekstone"
			player_item_id[id] = rannum
			player_b_meekstone[id] = 1
			show_hudmessage(id, "Znalazles przedmiot: %s :: Uzyj by spowodowac wybuch zadajacy smiertelne obrazenia",player_item_name[id])	
		}
		case 33:
		{
			player_item_name[id] = "Bezdenna sakwa zlota"
			player_b_zlotoadd[id] = random_num(9,13) * 1000
			player_item_id[id] = rannum
			show_hudmessage(id, "Znalazles przedmiot: %s :: Dostajesz zloto na poczatku rundy!",player_item_name[id])
			
		}
		case 34:
		{
			player_item_name[id] = "Medicine Totem"
			player_item_id[id] = rannum
			player_b_teamheal[id] = random_num(20,30)
			show_hudmessage(id, "Znalazles przedmiot: %s :: Strzel do swojego, aby uleczyc %i hp na sek - wcisnij E, zeby uzyc, otrzymasz doswiadczenie",player_item_name[id],1 + player_b_teamheal[id]/10)	
		}
		case 35:
		{
			player_item_name[id] = "Zabojca smokow"
			player_item_id[id] = rannum
			
			player_tmp[id] = random_num(5,15)
			player_trac_hp[id] = random_num(2,7)
			show_hudmessage(id, "Znalazles przedmiot: %s :: Dostajesz TMP, ataki ta bronia zadaja dodatkowe obrazenia rowne %i %% zdrowia celu.",player_item_name[id],player_tmp[id])	
		}
		case 36:
		{
			player_item_name[id] = "Mitril Armor"
			player_item_id[id] = rannum
			player_b_redirect[id] = random_num(6,11)
			show_hudmessage(id, "Znalazles przedmiot: %s :: +%i Obniza uszkodzenia zadawane graczowi",player_item_name[id],player_b_redirect[id])	
		}
		case 37:
		{
			player_item_name[id] = "Godly Armor"
			player_item_id[id] = rannum
			player_b_redirect[id] = random_num(10,15)
			
			show_hudmessage(id, "Znalazles przedmiot: %s :: +%i Obniza uszkodzenia zadawane graczowi",player_item_name[id],player_b_redirect[id])	
		}
		case 38:
		{
			player_item_name[id] = "Lightball staff"
			player_item_id[id] = rannum
			player_b_fireball[id] = random_num(50,100)
			show_hudmessage(id, "Znalazles przedmiot: %s :: Uszkadza wszystko w promieniu %i",player_item_name[id],player_b_fireball[id])	
		}
		case 39:
		{
			player_item_name[id] = "Lightball scepter"
			player_item_id[id] = rannum
			player_b_fireball[id] = random_num(100,200)
			show_hudmessage(id, "Znalazles przedmiot: %s :: Uszkadza wszystko w promieniu %i",player_item_name[id],player_b_fireball[id])	
		}
		case 40:
		{
			if(player_class[id]!=Gon && player_class[id]!= Zjawa){
				player_item_name[id] = "Ghost Rope"
				player_item_id[id] = rannum
				player_b_ghost[id] = random_num(3,6)
				show_hudmessage(id, "Znalazles przedmiot: %s :: Mozesz przenikac przez sciany przez %i sekund",player_item_name[id],player_b_ghost[id])	
			}else{
				award_unique_item(id)
			}
		}
		case 41:
		{
			player_item_name[id] = "Krasnoludzki mlot"
			player_item_id[id] = rannum
			player_b_m3[id] = random_num(3,4)
			fm_give_item(id, "weapon_m3")
			give_item(id, "ammo_buckshot")
			give_item(id, "ammo_buckshot")
			give_item(id, "ammo_buckshot")
			show_hudmessage(id, "Znalazles przedmiot: %s :: 1/%i szans do natychmiastowego zabicia shotgunem m3",player_item_name[id],player_b_m3[id])
		}
		case 42:
		{
			player_item_name[id] = "Bezdenna sakiewka zlota"
			player_b_zlotoadd[id] = random_num(4000,9000)
			player_item_id[id] = rannum
			show_hudmessage(id, "Znalazles przedmiot: %s :: Dostajesz zloto na poczatku rundy!",player_item_name[id])
			
		}
		case 43:
		{
			if(player_class[id] == Ninja){
				award_unique_item(id)	
				}else{
				player_item_name[id] = "Straznik nocny"
				
				player_item_id[id] = rannum
				give_item(id, "weapon_awp");
				player_awpk[id]  = random_num(1,6)
				show_hudmessage(id, "Znalazles przedmiot: %s :: Masz awp i 1/%i na zabicie!",player_item_name[id], player_awpk[id])	
			}
		}
		case 44:
		{
			player_item_name[id] = "Sword"
			player_item_id[id] = rannum
			player_sword[id] = 1
			show_hudmessage(id, "Znalazles przedmiot: %s :: zadajesz wieksze obrazenia nozem",player_item_name[id])		
		}
		case 45:
		{
			player_item_name[id] = "Magic Booster"
			player_item_id[id] = rannum
			player_b_froglegs[id] = 1
			show_hudmessage(id, "Znalazles przedmiot: %s :: Kucnij na 3 sekundy, a zrobisz dlugi skok",player_item_name[id])	
		}
		case 46:
		{
			player_item_name[id] = "Dagon I"
			player_item_id[id] = rannum
			player_b_dagon[id] = random_num(1,5)
			show_hudmessage(id, "Znalazles przedmiot: %s :: Uzyj zeby uderzyc twojego przeciwnika piorunem ognia",player_item_name[id])	
		}
		case 47:
		{
			player_item_name[id] = "Zbroja Feniksa"
			player_item_id[id] = rannum
			player_b_respawn[id] = 2
			player_b_redirect[id] = 10
			show_hudmessage(id, "Znalazles przedmiot: %s :: Masz 1/2 na odrodzenie sie po zgonie, otrzymywane obrazenie sa zredukowane o 10",player_item_name[id])
		}
		case 48:
		{
			player_item_name[id] = "Scout Amplifier"
			player_item_id[id] = rannum
			player_b_sniper[id] = random_num(2,3)
			fm_give_item(id, "weapon_scout")
			show_hudmessage(id, "Znalazles przedmiot: %s :: 1/%i szans do natychmiastowego zabicia scoutem",player_item_name[id],player_b_sniper[id])	
		}
		case 49:
		{
			player_item_name[id] = "Air booster"
			player_item_id[id] = rannum
			player_b_jumpx[id] = 1
			show_hudmessage(id, "Znalazles przedmiot: %s :: Mozesz zrobic podwojny skok w powietrzu",player_item_name[id])	
		}
		case 50:
		{
			player_item_name[id] = "Wszechstronny talent"
			player_item_id[id] = rannum
			player_iskra[id] = 1
			player_przesz[id] = 1
			player_trafiony_truj[id] = 1
			player_ludziebonus[id] = random_num(1,2)
			player_pociski_powietrza[id] = random_num(30,70)
			player_b_vampire[id] = 1
			player_b_grenade[id] = 15
			player_b_respawn[id] = 15
			player_lodowe_pociski[id] = random_num(33,63)
			player_knifebonus[id] = 10
			player_entowe_pociski[id] = random_num(33,63)
			player_b_damage[id] = 1
			player_b_explode[id] = random_num(10,25)
			player_b_blind[id] = random_num(30,50)
			player_b_jumpx[id] = 1
			player_b_redirect[id] = 1
			player_tarczam[id] = random_num(8,50)
			
			show_hudmessage(id, "Znalazles przedmiot: %s :: Otrzymujesz wszechstronne uzdolnienia",player_item_name[id])			
		}
		case 51:
		{
			player_item_name[id] = "Point Booster"
			player_item_id[id] = rannum
			player_staty[id]=1
			player_b_extrastats[id] = 5 + player_lvl[id] / 20
			BoostStats(id,player_b_extrastats[id])
			show_hudmessage(id, "Znalazles przedmiot: %s :: Zyskasz +%i do wszystkich statystyk",player_item_name[id],player_b_extrastats[id])	
		}
		case 52:
		{
			player_item_name[id] = "Totem amulet"
			player_item_id[id] = rannum
			player_b_firetotem[id] = random_num(450,600)
			show_hudmessage(id, "Znalazles przedmiot: %s :: Uzyj, aby polozyc wybuchowy totem ognia",player_item_name[id])	
		}
		case 53:
		{
			player_item_name[id] = "Male lembasy"
			player_item_id[id] = rannum
			player_lembasy[id] = random_num(1,2)
			show_hudmessage (id, "Znalazles przedmiot : %s :: Mozesz zatrzymac sie na %i sekund by dostac %i hp.  ",player_item_name[id],player_lembasy[id] ,player_lembasy[id] *25)
		}
		case 54:
		{
			player_item_name[id] = "Darksteel Glove"
			player_item_id[id] = rannum
			player_b_darksteel[id] = random_num(1,5)
			show_hudmessage(id, "Znalazles przedmiot: %s :: Dodatkowe uszkodzenia, gdy trafisz kogos od tylu",player_item_name[id])	
		}
		case 55:
		{
			player_item_name[id] = "Darksteel Gaunlet"
			player_item_id[id] = rannum
			player_b_darksteel[id] = random_num(7,9)
			show_hudmessage(id, "Znalazles przedmiot: %s :: Dodatkowe uszkodzenia, gdy trafisz kogos od tylu",player_item_name[id])	
		}
		case 56:
		{
			player_item_name[id] = "Illusionists Cape"
			player_item_id[id] = rannum
			player_b_illusionist[id] = 1
			show_hudmessage(id, "Znalazles przedmiot: %s :: Uzyj, aby stac sie niewidoczny dla wszystkich",player_item_name[id])	
		}
		case 57:
		{
			player_item_name[id] = "Laska"
			player_item_id[id] = rannum
			player_laska[id] = 30
			player_intbonus[id] = 10
			BoostInt(id,player_intbonus[id])
			show_hudmessage (id, "Znalazles przedmiot : %s :: Zyskasz +%i do inteligencji. Mozesz rzucic lightball co %i sekund",player_item_name[id],player_intbonus[id],player_laska[id])
			player_staty[id]=1
			
		}
		case 58:
		{
			if(player_class[id]!=Gon && player_class[id]!= Zjawa){
				player_item_name[id] = "Amulet lotu"
				player_item_id[id] = rannum
				player_b_jumpx[id] = 5
				player_b_ghost[id] = 20
				show_hudmessage(id, "Znalazles przedmiot: %s :: Latasz!",player_item_name[id])
				}else{
				award_unique_item(id)
			}		
		}
		case 59:
		{
			player_item_name[id] = "Lembasy"
			player_item_id[id] = rannum
			player_lembasy[id] = random_num(3,4)
			show_hudmessage (id, "Znalazles przedmiot : %s :: Mozesz zatrzymac sie na %i sekund by dostac %i hp.  ",player_item_name[id],player_lembasy[id] ,player_lembasy[id] *25)
		}
		case 60:
		{
			player_item_name[id] = "Duze lembasy"
			player_item_id[id] = rannum
			player_lembasy[id] = random_num(5,7)
			show_hudmessage (id, "Znalazles przedmiot : %s :: Mozesz zatrzymac sie na %i sekund by dostac %i hp.  ",player_item_name[id],player_lembasy[id] ,player_lembasy[id] *25)
		}
		case 61:
		{
			player_item_name[id] = "Blogoslawienstwo gwiazd"
			player_item_id[id] = rannum
			player_healer_c[id]=11
			player_healer[id] = random_num(100,110)
			show_hudmessage(id, "Znalazles przedmiot: %s :: Uderz w sojusznika nozem aby przywrocic mu 100 hp. Uzyj aby zadac 10 obrazen wszystkim przeciwnikom w pramieniu 800.",player_item_name[id])
		}
		case 62:
		{
			player_item_name[id] = "Worek z lembasami"
			player_item_id[id] = rannum
			player_lembasy[id] = random_num(7,10)
			show_hudmessage (id, "Znalazles przedmiot : %s :: Mozesz zatrzymac sie na %i sekund by dostac %i hp.  ",player_item_name[id],player_lembasy[id] ,player_lembasy[id] *25)
		}
		case 63:
		{
			player_item_name[id] = "Klatwa mrozu"
			player_item_id[id] = rannum
			player_mrozu[id] = random_num(3,5)
			show_hudmessage (id, "Znalazles przedmiot : %s :: Celujac w przeciwnika zamrazasz go na 3 sekundy. Atakujac zamrozonego przeciwnika zadajesz dodatkowe obrazenia. ",player_item_name[id])
		}
		case 64:
		{
			player_item_name[id] = "Zelazna Dziewica"
			player_item_id[id] = rannum
			player_dziewica[id] = random_num(1,20)
			player_dziewica_using[id]=0
			
			show_hudmessage (id, "Znalazles przedmiot : %s :: Uzyj by gracz zadajacy Ci obrazenia tez je otrzymywal. ",player_item_name[id])
		}		
		case 65:
		{
			player_item_name[id] = "Przeszywajace pociski"
			player_item_id[id] = rannum
			player_przesz[id] = random_num(50,100)
			show_hudmessage(id, "Znalazles przedmiot: %s :: Po zabiciu wroga jego cialo exploduje.",player_item_name[id])	
		}
		case 66:
		{
			player_item_name[id] = "Chameleon"	
			player_item_id[id] = rannum	
			changeskin(id,0)  
			show_hudmessage (id, "Znalazles przedmiot : %s :: Wygladasz jak przeciwnik",player_item_name[id])
		}
		case 67:
		{
			
			player_item_name[id] = "Tarcza ogra"
			player_b_tarczaogra[id] = random_num(3,10)
			player_item_id[id] = rannum
			show_hudmessage(id, "Znalazles przedmiot: %s :: Uzyj by byc niezniszczalnym na %s sekund!",player_item_name[id],player_b_tarczaogra[id])
			
		}
		case 68:
		{
			player_item_name[id] = "Ultra Armor"	
			player_item_id[id] = rannum	
			player_ultra_armor[id]=random_num(7,11)
			player_ultra_armor_left[id]=player_ultra_armor[id]
			show_hudmessage (id, "Znalazles przedmiot : %s :: Twoj pancerz moze odbic do %i pociskow",player_item_name[id],player_ultra_armor[id])
		}
		case 69:
		{
			player_item_name[id] = "Jonowa Iskra"
			player_item_id[id] = rannum
			player_iskra[id] = random_num(10,20)
			show_hudmessage(id, "Znalazles przedmiot: %s :: Twoje ataki zadaja obrazenia pobliskim przeciwnikom.",player_item_name[id])		
		}
		case 70:
		{
			player_item_name[id] = "Totem Enta"
			player_item_id[id] = rannum
			player_totem_enta[id] = random_num(2,15)
			player_totem_enta_zasieg[id] = random_num(100,300)
			
			show_hudmessage (id, "Znalazles przedmiot : %s :: Poloz totem ktory zatrzyma przeciwnikow w promieniu %i na %i sekund. ",player_item_name[id],player_totem_enta_zasieg[id],player_totem_enta[id])
		}
		case 71:
		{
			
			if(player_strength[id] < player_dextery[id]){
				player_item_id[id] = rannum
				player_item_name[id] = "Ciezkie buty"
				player_speedbonus[id] = random_num(1,3)
				player_b_redirect[id] = random_num(2,4)
				show_hudmessage (id, "Znalazles przedmiot : %s ::Redukuje normalne obrazenia %i bonus do szybkosci %i",player_item_name[id], player_b_redirect[id],player_speedbonus[id])
			}else{
				award_unique_item(id)
			}			
		}
		case 72:
		{
			
			if(player_strength[id] < player_dextery[id]){
				player_item_name[id] = "Kolcze buty"
				player_item_id[id] = rannum
				player_speedbonus[id] = random_num(5,6)
				player_b_redirect[id] = random_num(8,9)
				show_hudmessage (id, "Znalazles przedmiot : %s :: Redukuje normalne obrazenia %i bonus do szybkosci %i",player_item_name[id],player_b_redirect[id],player_speedbonus[id])
			}else{
				award_unique_item(id)
			}			
		}
		case 73:
		{			
			
			if(player_strength[id] < player_dextery[id]){
				player_item_name[id] = "Lekkie plytowe buty"
				player_item_id[id] = rannum
				player_speedbonus[id] = random_num(30,40)
				player_b_redirect[id] = random_num(13,14)
				show_hudmessage (id, "Znalazles przedmiot : %s :: Redukuje normalne obrazenia %i bonus do szybkosci %i",player_item_name[id],player_b_redirect[id],player_speedbonus[id])
			}else{
				award_unique_item(id)
			}			
		}
		case 74:
		{
			player_item_name[id] = "Skorzane buty przyspieszenia"
			player_item_id[id] = rannum
			player_speedbonus[id] = random_num(25,35)
			show_hudmessage (id, "Znalazles przedmiot : %s :: Bonus do szybkosci %i",player_item_name[id],player_speedbonus[id])
		}
		case 75:
		{
			player_nd[id] = 60
			if(player_dextery[id] >= player_nd[id]){
				player_item_id[id] = rannum
				player_item_name[id] = "Ebonowe buty przyspieszenia"
				player_speedbonus[id] = random_num(55,65)
				
				show_hudmessage (id, "Znalazles przedmiot : %s :: Dziala jesli masz %i zwinnosci. Bonus do szybkosci %i",player_item_name[id],player_nd[id],player_speedbonus[id])
			}else{
				award_unique_item(id)
			}			
		}
		case 76:
		{
			player_item_name[id] = "Pole antygrawitacyjne"
			player_item_id[id] = rannum
			player_antygravi[id] = random_num(1,20)
			show_hudmessage (id, "Znalazles przedmiot : %s :: Wy³¹czasz grawitacjê osobom na danym obszarze",player_item_name[id],player_b_redirect[id])
		}
		case 77:
		{
			
			if(player_strength[id] < player_dextery[id]){
				player_item_name[id] = "Szyszak"
				player_item_id[id] = rannum
				player_b_redirect[id] = random_num(4,5)
				show_hudmessage (id, "Znalazles przedmiot : %s :: Redukuje normalne obrazenia %i ",player_item_name[id],player_b_redirect[id])
			}else{
				award_unique_item(id)
			}			
		}
		case 78:
		{
			
			if(player_strength[id] < player_dextery[id]){
				player_item_name[id] = "Helm"
				player_item_id[id] = rannum
				player_b_redirect[id] = random_num(8,10)
				show_hudmessage (id, "Znalazles przedmiot : %s :: Redukuje normalne obrazenia %i ",player_item_name[id],player_b_redirect[id])
			}else{
				award_unique_item(id)
			}			
		}
		case 79:
		{
			if(player_strength[id] < player_dextery[id]){
				player_item_name[id] = "Zamkniety helm"
				player_item_id[id] = rannum
				player_b_redirect[id] = random_num(9,14)
				show_hudmessage (id, "Znalazles przedmiot : %s :: Redukuje normalne obrazenia %i ",player_item_name[id],player_b_redirect[id])
			}else{
				award_unique_item(id)
			}			
		}
		case 80:
		{
			if(player_strength[id] < player_dextery[id]){
				player_item_id[id] = rannum
				player_item_name[id] = "Wielki helm"
				player_b_redirect[id] = random_num(12,16)
				show_hudmessage (id, "Znalazles przedmiot : %s :: Redukuje normalne obrazenia %i ",player_item_name[id],player_b_redirect[id])
			}
			
		}
		case 81:
		{
			
			if(player_strength[id] <player_dextery[id]){
				player_item_id[id] = rannum
				player_item_name[id] = "Kosciany helm"
				player_b_redirect[id] = 20
				
				show_hudmessage (id, "Znalazles przedmiot : %s :: Redukuje normalne obrazenia %i ",player_item_name[id],player_b_redirect[id])
			}else{
				award_unique_item(id)
			}			
		}
		case 82:
		{
			bieg_item[id]= random_num(2,10)
			player_item_id[id] = rannum
			player_item_name[id] = "bieg przez cienie "			
			show_hudmessage (id, "Znalazles przedmiot : %s :: Po uzyciu znikasz i przyspieszasz. Zostawiasz za soba swoje kopie. Atak w trakcie biegu ujawnia cie, ale zadajesz dodatkowe obrazenia od tylu rowne inteligencja /15.",player_item_name[id])
			
		}
		case 83:
		{
			if(player_strength[id] < player_dextery[id]){
				player_b_redirect[id] = 5
				player_item_id[id] = rannum
				player_item_name[id] = "Ciezka skorzana zbroja"
				show_hudmessage (id, "Znalazles przedmiot : %s :: Redukuje normalne obrazenia %i ",player_item_name[id],player_b_redirect[id])
			}else{
				award_unique_item(id)
			}			
		}
		case 84:
		{

			
			if(player_strength[id] < player_dextery[id]){
				player_b_redirect[id] = 10
				player_item_name[id] = "Cwiekowana zbroja"
				player_item_id[id] = rannum
				show_hudmessage (id, "Znalazles przedmiot : %s :: Redukuje normalne obrazenia %i ",player_item_name[id],player_b_redirect[id])
			}else{
				award_unique_item(id)
			}			
		}
		case 85:
		{			
			if(player_strength[id] < player_dextery[id]){
				player_item_id[id] = rannum
				player_item_name[id] = "Pierscieniowa zbroja"
				player_b_redirect[id] = 15
				show_hudmessage (id, "Znalazles przedmiot : %s :: Redukuje normalne obrazenia %i ",player_item_name[id],player_b_redirect[id])
			}else{
				award_unique_item(id)
			}			
		}
		case 86:
		{
			if(player_strength[id] < player_dextery[id]){
				player_item_name[id] = "Luskowa zbroja"
				player_b_redirect[id] = 18
				player_item_id[id] = rannum
				show_hudmessage (id, "Znalazles przedmiot : %s :: Redukuje normalne obrazenia %i ",player_item_name[id],player_b_redirect[id])
			}else{
				award_unique_item(id)
			}			
		}
		case 87:
		{
			if(player_strength[id] < player_dextery[id]){
				player_item_name[id] = "Napiersnik"
				player_item_id[id] = rannum
				player_b_redirect[id] = 20
				show_hudmessage (id, "Znalazles przedmiot : %s :: Redukuje normalne obrazenia %i ",player_item_name[id],player_b_redirect[id])
			}else{
				award_unique_item(id)
			}			
		}
		case 88:
		{
			if(player_strength[id] < player_dextery[id]){
				player_b_redirect[id] = 25
				player_item_name[id] = "Kolczuga"
				player_item_id[id] = rannum
				show_hudmessage (id, "Znalazles przedmiot : %s :: Redukuje normalne obrazenia %i ",player_item_name[id],player_b_redirect[id])
				}else{
				award_unique_item(id)
			}			
		}
		case 89:
		{
		
			if(player_strength[id] < player_dextery[id]){
				player_b_redirect[id] = random_num(35,45)
				player_item_name[id] = "Starozytna zbroja"
				player_item_id[id] = rannum
				show_hudmessage (id, "Znalazles przedmiot : %s :: Redukuje normalne obrazenia %i ",player_item_name[id],player_b_redirect[id])
			}else{
				award_unique_item(id)
			}			
		}
		case 90:
		{
			player_item_name[id] = "Bezdenny mieszek zlota"
			player_b_zlotoadd[id] = random_num(100,1000)
			player_item_id[id] = rannum
			show_hudmessage(id, "Znalazles przedmiot: %s :: Dostajesz zloto na poczatku rundy!",player_item_name[id])
			
		}
		case 91:
		{
			if(player_strength[id] < player_dextery[id]){
				player_item_name[id] = "Mala tarcza"
				player_item_id[id] = rannum
				player_b_redirect[id] = 4
				show_hudmessage (id, "Znalazles przedmiot : %s :: Redukuje normalne obrazenia %i ",player_item_name[id],player_b_redirect[id])
				}else{
				award_unique_item(id)
			}			
		}
		case 92:
		{
			if(player_strength[id] < player_dextery[id] ){
				player_item_name[id] = "Duza tarcza"
				player_item_id[id] = rannum
				player_b_redirect[id] = 10
				show_hudmessage (id, "Znalazles przedmiot : %s :: Redukuje normalne obrazenia %i ",player_item_name[id],player_b_redirect[id])
			}else{
				award_unique_item(id)
			}
		}
		case 93:
		{
			if(player_strength[id] < player_dextery[id]){
				player_item_name[id] = "Kolczasta tarcza"
				player_item_id[id] = rannum
				player_b_redirect[id] = 13
				show_hudmessage (id, "Znalazles przedmiot : %s :: Redukuje normalne obrazenia %i ",player_item_name[id],player_b_redirect[id])
			}else{
				award_unique_item(id)
			}
		}
		case 94:
		{
			if(player_strength[id] < player_dextery[id] ){
				player_b_redirect[id] = 18
				player_ultra_armor[id]=random_num(7,10)
				player_ultra_armor_left[id]=player_ultra_armor[id]
				player_item_name[id] = "Ciezka tarcza"
				player_item_id[id] = rannum
				show_hudmessage (id, "Znalazles przedmiot : %s :: Redukuje normalne obrazenia %i ",player_item_name[id],player_b_redirect[id])
			}else{
				award_unique_item(id)
			}
		}
		case 95:
		{
			if(player_strength[id] < player_dextery[id] ){
				player_item_id[id] = rannum
				player_item_name[id] = "Kosciana tarcza"
				player_b_redirect[id] = 20
				player_ultra_armor[id]=random_num(7,10)
				player_ultra_armor_left[id]=player_ultra_armor[id]
				
				show_hudmessage (id, "Znalazles przedmiot : %s :: Redukuje normalne obrazenia %i ",player_item_name[id],player_b_redirect[id])
			}else{
				award_unique_item(id)
			}
		}
		case 96:
		{
			player_item_name[id] = "Toksyczna substancja"
			player_item_id[id] = rannum
			player_b_truj_nozem[id] = random_num(1,10)
			if(player_class[id] != Ninja && player_class[id] != Samurai) player_b_truj_nozem[id] = random_num(10,30)
			
			show_hudmessage(id, "Znalazles przedmiot: %s :: Twoje ataki nozem zatruwaja, efekt kumuluje sie.",player_item_name[id])
		}
		case 97:
		{
			player_item_name[id] = "Kosciana rozdzka"
			player_item_id[id] = rannum
			player_b_dagon[id] = 1
			player_intbonus[id] = 20
			BoostInt(id,player_intbonus[id])
			show_hudmessage (id, "Znalazles przedmiot : %s :: Zyskasz +%i do inteligencji. Mozesz uderzyc przeciwnika piorunem.",player_item_name[id],player_intbonus[id])
			player_staty[id]=1
		}
		case 98:
		{
			player_nd[id] = 50
			
			if(player_dextery[id] >= player_nd[id] ){
				player_item_name[id] = "Dlugi miecz"
				player_item_id[id] = rannum
				player_knifebonus[id] = 100	
				player_miecz[id] = 1	
				show_hudmessage (id, "Znalazles przedmiot : %s :: Dziala jesli masz %i zwinnosci. Zwieksza obrazenia noza o %i ",player_item_name[id],player_nd[id],player_knifebonus[id])
			}else{
				award_unique_item(id)
			}
		}
		case 99:
		{
			player_nd[id] = 100
			player_ni[id] = 20
			
			if(player_dextery[id] >= player_nd[id] && player_intelligence[id] >= player_ni[id]){
				player_knifebonus[id] = 200
				player_item_name[id] = "Krysztalowy miecz"
				player_item_id[id] = rannum
				show_hudmessage (id, "Znalazles przedmiot : %s :: Dziala jesli masz %i zwinnosci i %i inteligencji. Zwieksza obrazenia noza o %i ",player_item_name[id],player_nd[id],player_ni[id],player_knifebonus[id])
			}else{
				award_unique_item(id)
			}
		}
		case 100:
		{
			player_nd[id] = 150
			player_ni[id] = 20
			if(player_dextery[id] >= player_nd[id] && player_intelligence[id] >= player_ni[id]){
				player_knifebonus[id] = 300
				player_katana[id] = 1	
				player_item_id[id] = rannum
				player_item_name[id] = "Katana"
				show_hudmessage (id, "Znalazles przedmiot : %s :: Dziala jesli masz %i zwinnosci, %i int. Zwieksza obrazenia noza o %i ",player_item_name[id],player_nd[id],player_ni[id],player_knifebonus[id])
			}else{
				award_unique_item(id)
			}
		}
		case 101:
		{
			player_nd[id] = 50
			if(player_dextery[id] >= player_nd[id]){
				player_item_id[id] = rannum
				player_item_name[id] = "Topor"
				player_b_damage[id] = 15
				show_hudmessage (id, "Znalazles przedmiot : %s :: Dziala jesli masz %i zwinnosci. Dodaje obrazenia %i ",player_item_name[id],player_nd[id],player_b_damage[id])
			}else{
				award_unique_item(id)
			}
		}
		case 102:
		{
			player_nd[id] = 250
			if(player_dextery[id] >= player_nd[id]){
				player_item_name[id] = "Topor bitewny"
				player_item_id[id] = rannum
				player_b_damage[id] = 30
				show_hudmessage (id, "Znalazles przedmiot : %s :: Dziala jesli masz %i zwinnosci.Dodaje obrazenia %i ",player_item_name[id],player_nd[id],player_b_damage[id])
			}else{
				award_unique_item(id)
			}
		}
		case 103:
		{
			player_item_name[id] = "Totem Pradawnego Enta"
			player_item_id[id] = rannum
			player_totem_enta[id] = random_num(10,18)
			player_totem_enta_zasieg[id] = random_num(400,700)
			
			show_hudmessage (id, "Znalazles przedmiot : %s :: Poloz totem ktory zatrzyma przeciwnikow w promieniu %i na %i sekund. ",player_item_name[id],player_totem_enta_zasieg[id],player_totem_enta[id])
		}	
		case 104:
		{
			player_item_name[id] = "Wielki Totem Lodu"
			player_item_id[id] = rannum
			player_totem_lodu[id] = random_num(5,20)
			player_totem_lodu_zasieg[id] = random_num(300,500)
			
			show_hudmessage (id, "Znalazles przedmiot : %s :: Poloz totem ktory zamrozi przeciwnikow w promieniu %i na %i sekund. ",player_item_name[id],player_totem_lodu_zasieg[id],player_totem_lodu[id])
		}
		case 105:
		{
			if(player_class[id] == Kusznik){
				player_intbonus[id] = 100
				player_item_name[id] = "Kusza"
				player_item_id[id] = rannum
				BoostInt(id,player_intbonus[id])
				show_hudmessage (id, "Znalazles przedmiot : %s :: Dziala tylko dla lowcy. Zyskasz +%i do inteligencji. ",player_item_name[id],player_intbonus[id])
				player_staty[id]=1
			}else{
				award_unique_item(id)
			}
		}
		case 106:
		{
			player_nd[id] = 100
			
			if(player_class[id] == Kusznik && player_dextery[id] >= player_nd[id]){
				player_intbonus[id] = 200
				player_item_id[id] = rannum
				player_item_name[id] = "Kusza bojowa"
				
				BoostInt(id,player_intbonus[id])
				show_hudmessage (id, "Znalazles przedmiot : %s :: Dziala jesli masz %i zwinnosci. Dziala tylko dla lowcy. Zyskasz +%i do inteligencji. ",player_item_name[id],player_nd[id],player_intbonus[id])
				player_staty[id]=1
			}else{
				award_unique_item(id)
			}
		}
		case 107:
		{
			player_nd[id] = 100
			if(player_class[id] == Kusznik && player_dextery[id] >= player_nd[id]){
				player_intbonus[id] = 200
				player_item_id[id] = rannum
				player_item_name[id] = "Kusza bojowa"
				BoostInt(id,player_intbonus[id])
				show_hudmessage (id, "Znalazles przedmiot : %s :: Dziala jesli masz %i zwinnosci. Dziala tylko dla lowcy. Zyskasz +%i do inteligencji. ",player_item_name[id],player_nd[id],player_intbonus[id])
				player_staty[id]=1
			}else{
				award_unique_item(id)
			}
		}
		case 108:
		{
			player_item_name[id] = "Buty ruchliwosci"
			player_item_id[id] = rannum
			player_ruch[id] = random_num(91,510)
			show_hudmessage(id, "Znalazles przedmiot: %s :: Poza walka masz dodatkowa predkosc.",player_item_name[id])
		}
		case 109:
		{
			player_item_name[id] = "Sekata laska"
			player_item_id[id] = rannum
			player_laska[id] = 15
			player_intbonus[id] = 10
			BoostInt(id,player_intbonus[id])
			show_hudmessage (id, "Znalazles przedmiot : %s :: Zyskasz +%i do inteligencji. Mozesz rzucic lightball co %i sekund",player_item_name[id],player_intbonus[id],player_laska[id])
			player_staty[id]=1
		}
		case 110:
		{
			player_item_name[id] = "Pociski z kory Enta"
			player_item_id[id] = rannum
			player_entowe_pociski[id] = random_num(3,13)
			
			show_hudmessage (id, "Znalazles przedmiot : %s :: Szansa 1/%i na splatanie przeciwnika. ",player_item_name[id],player_entowe_pociski[id])
		}
		case 111:
		{
			player_item_name[id] = "Pociski magii powietrza"
			player_item_id[id] = rannum
			player_pociski_powietrza[id] = random_num(5,20)
			
			show_hudmessage (id, "Znalazles przedmiot : %s :: Szansa 1/%i na wyrzucenie przeciwnikowi broni. ",player_item_name[id],player_pociski_powietrza[id])
		}
		case 112:
		{
			player_item_name[id] = "Totem powietrza"
			player_item_id[id] = rannum
			player_totem_powietrza_zasieg[id] = random_num(100,550)
			show_hudmessage (id, "Znalazles przedmiot : %s :: Totem: Szansa na wyrzucenie przeciwnikowi broni. ",player_item_name[id])
		}
		
		case 113:
		{
			if(player_class[id] == Ninja){
				award_unique_item(id)	
			}else{
				player_item_name[id] = "Pociski z zebow smoka"
				player_item_id[id] = rannum
				item_durability[id] = 100
				player_smocze[id]  = random_num(20,50)
				show_hudmessage(id, "Znalazles przedmiot: %s :: Twoje pociski rania mocniej ale i Ciebie!",player_item_name[id])	
			}
		}
		case 114:
		{
			player_item_name[id] = "Zwoj: Aard"
			player_item_id[id] = rannum
			player_aard[id] = random_num(1,2)
			show_hudmessage(id, "Znalazles przedmiot: %s :: Odrzucenie przeciwnikow",player_item_name[id],player_aard[id])	
		}
		case 115:
		{
			if(random_num(0,5)==1){
				player_item_name[id] = "Zwoj skupienia"
				player_item_id[id] = rannum
				player_recoil[id] = 2
				
				show_hudmessage (id, "Znalazles przedmiot : %s :: Zwoj pozwala Ci sie skupic na walce. Idealnie celny strzal co %i naboi. ",player_item_name[id],player_recoil[id])
			}else{
				award_unique_item(id)
			}
		}
		case 116:
		{
			if(random_num(0,5)==1){
				player_item_name[id] = "Potezny Zwoj skupienia"
				player_item_id[id] = rannum
				player_recoil[id] = 1
				
				show_hudmessage (id, "Znalazles przedmiot : %s :: Zwoj pozwala Ci sie skupic na walce. Idealnie celny strzal co %i naboi. ",player_item_name[id],player_recoil[id])
			}else{
				award_unique_item(id)
			}
		}
		case 117:
		{
			
			player_item_name[id] = "Lodowe pociski"
			player_item_id[id] = rannum
			player_lodowe_pociski[id] = random_num(3,13)
			show_hudmessage (id, "Znalazles przedmiot : %s :: Szansa 1/%i na zamrozenie przeciwnika. ",player_item_name[id],player_lodowe_pociski[id])
		}
		case 118:
		{
			player_item_name[id] = "Totem Lodu"
			player_item_id[id] = rannum
			player_totem_lodu[id] = random_num(1,15)
			player_totem_lodu_zasieg[id] = random_num(100,400)
			
			show_hudmessage (id, "Znalazles przedmiot : %s :: Poloz totem ktory zamrozi przeciwnikow w promieniu %i na %i sekund. ",player_item_name[id],player_totem_lodu_zasieg[id],player_totem_lodu[id])
		}
		case 119:
		{
			if(player_class[id] == Nekromanta){
				player_b_extrastats[id]  = 4
				player_b_redirect[id] = random_num(1,8)
				player_item_name[id] = "Trupia glowa"
				player_item_id[id] = rannum
				BoostStats(id,player_b_extrastats[id])
				show_hudmessage (id, "Znalazles przedmiot : %s ::  Zyskasz +%i do statystyk. Redukuje obrazenia o %i. ",player_item_name[id],player_b_extrastats[id],player_b_redirect[id] )
				player_staty[id]=1
			}else{
				award_unique_item(id)
			}
		}
		case 120:
		{
			if(player_class[id] == Nekromanta ){
				player_b_extrastats[id]  = 6
				player_b_redirect[id] = random_num(8,15)
				player_item_name[id] = "Glowa szkieleta"
				player_item_id[id] = rannum
				BoostStats(id,player_b_extrastats[id])
				show_hudmessage (id, "Znalazles przedmiot : %s ::  Zyskasz +%i do statystyk. Redukuje obrazenia o %i. ",player_item_name[id],player_b_extrastats[id],player_b_redirect[id] )
				player_staty[id]=1
			}else{
				award_unique_item(id)
			}
		}
		case 121:
		{
			if(player_class[id] == Nekromanta ){
				player_b_extrastats[id]  = 10
				player_b_redirect[id] = 20
				player_item_name[id] = "Demoniczna glowa"
				player_b_vampire[id]=10
				player_item_id[id] = rannum
				BoostStats(id,player_b_extrastats[id])
				show_hudmessage (id, "Znalazles przedmiot : %s ::  Zyskasz +%i do statystyk. Redukuje obrazenia o %i. Wysysasz %i hp wrogowi.",player_item_name[id],player_b_extrastats[id],player_b_redirect[id],player_b_vampire[id])
				player_staty[id]=1
			}else{
				award_unique_item(id)
			}
		}
		case 122:
		{
			
			player_item_name[id] = "Skrzydla z harpich pior"
			player_item_id[id] = rannum
			player_b_jumpx[id] = 50
			show_hudmessage(id, "Znalazles przedmiot : %s ::  Mozesz podskoczyc 50 razy w powietrzu",player_item_name[id])
			
		}
		case 123:
		{
			player_item_name[id] = "Buty z harpich pior"
			player_item_id[id] = rannum
			player_b_jumpx[id] = 5
			show_hudmessage(id, "Znalazles przedmiot : %s ::  Mozesz zrobic 5 skokow w powietrzu",player_item_name[id])
		}
		case 124:
		{
			player_nd[id] = 300
			if(player_dextery[id] >= player_nd[id] ){
				player_item_name[id] = "Ostrze mrozu"
				player_b_reduceH[id] = 50
				player_item_id[id] = rannum
				player_knifebonus[id] = 10000
				show_hudmessage(id, "Znalazles przedmiot : %s ::  Twoj noz zabija od razu",player_item_name[id])	
			}else{
				award_unique_item(id)
			}
		}
		case 125:
		{
			if(player_lvl[id] <= 10 ){
				player_item_name[id] = "Maly zwoj nowicjusza"
				player_item_id[id] = rannum
				player_dosw[id] = 250
				show_hudmessage(id, "Znalazles przedmiot : %s ::  Wcisnij e by dostac %i doswiadczenie!",player_item_name[id], player_dosw[id])	
			}else{
				award_unique_item(id)
			}
		}
		case 126:
		{
			if(player_lvl[id] <= 10   ){
				player_item_name[id] = "Zwoj nowicjusza"
				player_item_id[id] = rannum
				player_dosw[id] = 500
				show_hudmessage(id, "Znalazles przedmiot : %s ::  Wcisnij e by dostac %i doswiadczenie!",player_item_name[id], player_dosw[id])	
			}
		}
		case 127:
		{
			if(player_lvl[id] <= 10   ){
				player_item_name[id] = "Duzy zwoj nowicjusza"
				player_item_id[id] = rannum
				player_dosw[id] = 750
				show_hudmessage(id, "Znalazles przedmiot : %s ::  Wcisnij e by dostac %i doswiadczenie!",player_item_name[id], player_dosw[id])	
			}else{
				award_unique_item(id)
			}
		}
		case 128:
		{
			if(player_lvl[id] <= 25 ){
				player_item_name[id] = "Maly zwoj ucznia"
				player_item_id[id] = rannum
				player_dosw[id] = 200
				show_hudmessage(id, "Znalazles przedmiot : %s ::  Wcisnij e by dostac %i doswiadczenie!",player_item_name[id], player_dosw[id])	
			}else{
				award_unique_item(id)
			}
		}
		case 129:
		{
			if(player_lvl[id] <= 25  ){
				player_item_name[id] = "Zwoj ucznia"
				player_item_id[id] = rannum
				player_dosw[id] = 400
				show_hudmessage(id, "Znalazles przedmiot : %s ::  Wcisnij e by dostac %i doswiadczenie!",player_item_name[id], player_dosw[id])	
			}else{
				award_unique_item(id)
			}
		}
		case 130:
		{
			if(player_lvl[id] <= 25   ){
				player_item_name[id] = "Duzy zwoj ucznia"
				player_item_id[id] = rannum
				player_dosw[id] = 600
				show_hudmessage(id, "Znalazles przedmiot : %s ::  Wcisnij e by dostac %i doswiadczenie!",player_item_name[id], player_dosw[id])	
			}else{
				award_unique_item(id)
			}
		}
		case 131:
		{
			if(player_lvl[id] <= 50 ){
				player_item_name[id] = "Maly zwoj czeladnika"
				player_item_id[id] = rannum
				player_dosw[id] = 150
				show_hudmessage(id, "Znalazles przedmiot : %s ::  Wcisnij e by dostac %i doswiadczenie!",player_item_name[id], player_dosw[id])	
			}else{
				award_unique_item(id)
			}
		}
		case 132:
		{
			if(player_lvl[id] <= 50  ){
				player_item_name[id] = "Zwoj czeladnika"
				player_item_id[id] = rannum
				player_dosw[id] = 300
				show_hudmessage(id, "Znalazles przedmiot : %s ::  Wcisnij e by dostac %i doswiadczenie!",player_item_name[id], player_dosw[id])	
			}else{
				award_unique_item(id)
			}
		}
		case 133:
		{
			player_item_name[id] = "Duzy zwoj czeladnika"
			player_item_id[id] = rannum
			player_dosw[id] = 500
			show_hudmessage(id, "Znalazles przedmiot : %s ::  Wcisnij e by dostac %i doswiadczenie!",player_item_name[id], player_dosw[id])	
		}
		case 134:
		{
			if(player_lvl[id] <= 100 ){
				player_item_name[id] = "Maly zwoj mistrza"
				player_item_id[id] = rannum
				player_dosw[id] = 100
				show_hudmessage(id, "Znalazles przedmiot : %s ::  Wcisnij e by dostac %i doswiadczenie!",player_item_name[id], player_dosw[id])	
			}else{
				award_unique_item(id)
			}
		}
		case 135:
		{
			player_item_name[id] = "Zwoj mistrza"
			player_item_id[id] = rannum
			player_dosw[id] = 200
			show_hudmessage(id, "Znalazles przedmiot : %s ::  Wcisnij e by dostac %i doswiadczenie!",player_item_name[id], player_dosw[id])	
			
		}
		case 136:
		{
			if(player_lvl[id] <= 100 ){
				player_item_name[id] = "Duzy zwoj mistrza"
				player_item_id[id] = rannum
				player_dosw[id] = 300
				show_hudmessage(id, "Znalazles przedmiot : %s ::  Wcisnij e by dostac %i doswiadczenie!",player_item_name[id], player_dosw[id])	
			}else{
				award_unique_item(id)
			}
		}
		case 137:
		{
			player_item_name[id] = "Pierscien oswiecenia"
			player_item_id[id] = rannum
			
			player_chargetime[id] = 5
			show_hudmessage(id, "Znalazles przedmiot : %s ::  Zmniejsza czas ladowania o 0.5 sekundy!",player_item_name[id])	
		}
		case 138:
		{
			player_item_name[id] = "Srebrny pierscien oswiecenia"
			player_item_id[id] = rannum
			
			player_chargetime[id] = 10
			show_hudmessage(id, "Znalazles przedmiot : %s ::  Zmniejsza czas ladowania o 1 sekunde!",player_item_name[id])	
		}
		case 139:
		{
			player_item_name[id] = "Zloty pierscien oswiecenia"
			player_item_id[id] = rannum
			
			player_chargetime[id] = 15
			show_hudmessage(id, "Znalazles przedmiot : %s ::  Zmniejsza czas ladowania o 1.5 sekundy!",player_item_name[id])	
		}
		case 140:
		{
			player_item_name[id] = "Diamentowy pierscien oswiecenia"
			player_item_id[id] = rannum

			player_chargetime[id] = 20
			show_hudmessage(id, "Znalazles przedmiot : %s ::  Zmniejsza czas ladowania o 2 sekundy!",player_item_name[id])	
		}
		case 141:
		{
			player_item_name[id] = "Krwawe szpony"
			player_item_id[id] = rannum
			player_szpony[id] = 5
			show_hudmessage(id, "Znalazles przedmiot: %s :: Dodatkowe obrazenia rowne 5%% zdrowia celu.",player_item_name[id])
		}
		case 142:
		{
			player_item_name[id] = "Srebrny pierscien szybkosci"
			player_item_id[id] = rannum
			player_speedbonus[id] =  40
			if (is_user_alive(id))
				set_speedchange(id)
			
			show_hudmessage(id, "Znalazles przedmiot : %s ::  Bonus do szybkosci %i ",player_item_name[id],player_speedbonus[id])	
		}
		case 143:
		{
			player_item_name[id] = "Zloty pierscien szybkosci"
			player_item_id[id] = rannum
			player_speedbonus[id] = 50
			
			
			if (is_user_alive(id))
				set_speedchange(id)
			
			show_hudmessage(id, "Znalazles przedmiot : %s ::  Bonus do szybkosci %i ",player_item_name[id],player_speedbonus[id])	
		}
		case 144:
		{
			player_item_name[id] = "Diamentowy pierscien szybkosci"
			player_item_id[id] = rannum
			player_speedbonus[id] = 100
			
			
			if (is_user_alive(id))
				set_speedchange(id)
			
			show_hudmessage(id, "Znalazles przedmiot : %s ::  Bonus do szybkosci %i ",player_item_name[id],player_speedbonus[id])	
		}
		case 145:
		{
			player_nd[id] = 40
			if(player_dextery[id] >= player_nd[id]){
				player_b_damage[id] = 20
				
				player_item_id[id] = rannum
				player_item_name[id] = "Samszir"
				show_hudmessage(id, "Znalazles przedmiot: %s :: dodaje obrazenia +%i",player_item_name[id],player_b_damage[id])
			}else{
				award_unique_item(id)
			}
		}
		case 146:
		{
			player_nd[id] = 80
			if(player_dextery[id] >= player_nd[id]){
				player_b_damage[id] = 30
				
				player_item_id[id] = rannum
				player_item_name[id] = "Prastary miecz"
				show_hudmessage(id, "Znalazles przedmiot: %s :: dodaje obrazenia +%i",player_item_name[id],player_b_damage[id])
			}else{
				award_unique_item(id)
			}
		}
		case 147:
		{
			if(player_class[id] != Ninja ){
				player_grawitacja[id] = 50
				player_item_id[id] = rannum
				player_item_name[id] = "Pierscien wiatru"
				show_hudmessage(id, "Znalazles przedmiot: %s :: Grawitacja zmniejszona do 0.5",player_item_name[id])
				if (is_user_alive(id))
					set_gravitychange(id)
				}else{
				award_unique_item(id)
			}
		}
		case 148:
		{
			
			player_item_name[id] = "Sekata laska"
			player_item_id[id] = rannum
			player_laska[id] = 15
			player_intbonus[id] = 10
			BoostInt(id,player_intbonus[id])
			show_hudmessage (id, "Znalazles przedmiot : %s :: Zyskasz +%i do inteligencji. Mozesz rzucic lightball co %i sekund",player_item_name[id],player_intbonus[id],player_laska[id])
			player_staty[id]=1
			
		}
		case 149:
		{
			player_grawitacja[id] = 15
			
			player_item_id[id] = rannum
			player_item_name[id] = "Zloty pierscien wiatru"
			show_hudmessage(id, "Znalazles przedmiot: %s :: Grawitacja zmniejszona do 0.15",player_item_name[id])
			if (is_user_alive(id))
				set_gravitychange(id)
		}
		case 150:
		{
			player_naszyjnikczasu[id] = 5
			player_item_id[id] = rannum
			player_item_name[id] = "Naszyjnik czasu"
			show_hudmessage(id, "Znalazles przedmiot: %s :: Mozesz uzyc mocy postaci szybciej o %i sekund",player_item_name[id],player_naszyjnikczasu[id] )
		}
		case 151:
		{
			player_naszyjnikczasu[id] = 10	
			player_item_id[id] = rannum
			player_item_name[id] = "Starozytny naszyjnik czasu"
			show_hudmessage(id, "Znalazles przedmiot: %s :: Mozesz uzyc mocy postaci szybciej o %i sekund",player_item_name[id],player_naszyjnikczasu[id] )
		}
		case 152:
		{
			player_tarczam[id] = 20
			
			player_tarczam[id]*=2
			player_item_id[id] = rannum
			player_item_name[id] = "Mala tarcza krasnoluda"
			show_hudmessage(id, "Znalazles przedmiot: %s :: Ochrona przed magia %i",player_item_name[id],player_tarczam[id])
		}
		case 153:
		{
			player_tarczam[id] = 40
			
			player_tarczam[id]*=2
			player_item_id[id] = rannum
			player_item_name[id] = "Tarcza krasnoluda"
			show_hudmessage(id, "Znalazles przedmiot: %s :: Ochrona przed magia %i",player_item_name[id],player_tarczam[id])
		}
		case 154:
		{
			player_tarczam[id] = 80
			
			player_tarczam[id]*=2
			player_item_id[id] = rannum
			player_item_name[id] = "Starozytna krasnoludzka tarcza"
			show_hudmessage(id, "Znalazles przedmiot: %s :: Ochrona przed magia %i",player_item_name[id],player_tarczam[id])
		}
		case 155:
		{
			player_tarczam[id] = 150
			
			player_tarczam[id]*=8
			player_item_id[id] = rannum
			player_item_name[id] = "Tarcza z lusek czarnego smoka"
			show_hudmessage(id, "Znalazles przedmiot: %s :: Ochrona przed magia %i",player_item_name[id],player_tarczam[id])
		}
		case 156:
		{
			if(player_class[id] == Ninja){
				award_unique_item(id)
			}else{
				player_b_damage[id] = 25
				if(get_user_health(id) >  get_maxhp(id) && player_b_reduceH[id] > 0) set_user_health(id,get_maxhp(id))
				player_b_reduceH[id] = 50
				player_item_id[id] = rannum
				player_item_name[id] = "Slaby Spijacz Dusz"
				show_hudmessage(id, "Znalazles przedmiot: %s :: Twoje hp jest zredukowane, bonus do ataku %i",player_item_name[id],player_b_damage[id])
			}
		}
		case 157:
		{
			if(player_class[id] == Ninja){
				award_unique_item(id)
			}else{
				player_b_damage[id] = 50
				player_5hp[id] =1 
				if(get_user_health(id)>5){
					fm_set_user_health(id,5)
				} 
				player_item_id[id] = rannum
				player_item_name[id] = "Spijacz Dusz"
				show_hudmessage(id, "Znalazles przedmiot: %s :: Twoje hp jest zredukowane, bonus do ataku %i",player_item_name[id],player_b_damage[id])
			}
		}
		case 158:
		{
			if(player_class[id] == Ninja){
				award_unique_item(id)
			}else{
				player_b_damage[id] = 500
				player_5hp[id] = 1
				if(get_user_health(id)>5){
					fm_set_user_health(id,5)
				} 
				player_item_id[id] = rannum
				player_item_name[id] = "Ostry Spijacz Dusz"
				item_durability[id] = 50
				show_hudmessage(id, "Znalazles przedmiot: %s :: Twoje hp jest zredukowane, bonus do ataku %i",player_item_name[id],player_b_damage[id])
			}
		}
		case 159:
		{
			if(player_class[id] == Ninja){
				award_unique_item(id)
			}else{
				player_b_damage[id] = 100
				player_5hp[id] =1
				
				player_b_vampire[id] = 1
				if(get_user_health(id)>5){
					fm_set_user_health(id,5)
				} 
				player_item_id[id] = rannum
				player_item_name[id] = "Wampiryczny Spijacz Dusz"
				item_durability[id] = 50
				show_hudmessage(id, "Znalazles przedmiot: %s :: Twoje hp jest zredukowane, bonus do ataku %i, wysysanie hp %i",player_item_name[id],player_b_damage[id],player_b_vampire[id])
			}
		}
		case 160:
		{
			if(player_lvl[id] <= 25){
				player_grom[id]= 100
				player_item_id[id] = rannum
				player_item_name[id] = "Runa smiertelny lancuch piorunow"
				show_hudmessage(id, "Znalazles przedmiot: %s :: Wcisnij e by zadac przeciwnikom %i obrazen",player_item_name[id],player_grom[id])
			}else{
				award_unique_item(id)
			}
		}
		case 161:
		{
			if(player_lvl[id] <= 50){
				player_grom[id]= 50
				player_item_id[id] = rannum
				player_item_name[id] = "Runa lancuch piorunow"
				show_hudmessage(id, "Znalazles przedmiot: %s :: Wcisnij e by zadac przeciwnikom %i obrazen",player_item_name[id],player_grom[id])
			}else{
				award_unique_item(id)
			}
		}
		case 162:
		{
			if(player_lvl[id] <= 10){
				player_grom[id]= 500
				player_item_id[id] = rannum
				player_item_name[id] = "Runa smiertelny grom"
				show_hudmessage(id, "Znalazles przedmiot: %s :: Wcisnij e by zadac przeciwnikom %i obrazen",player_item_name[id],player_grom[id])
			}else{
				award_unique_item(id)
			}
		}
		case 163:
		{
			player_grom[id]= 20
			player_item_id[id] = rannum
			player_item_name[id] = "Runa lancuch piorunow"
			show_hudmessage(id, "Znalazles przedmiot: %s :: Wcisnij e by zadac przeciwnikom %i obrazen",player_item_name[id],player_grom[id])
		}
		case 164:
		{
			player_item_id[id] = rannum
			player_tpresp[id]=1
			player_item_name[id] = "Pierscien lotrzyka"
			show_hudmessage(id, "Znalazles przedmiot: %s :: Wcisnij e by teleportowac sie na resp",player_item_name[id])
		}
		case 165:
		{
			player_item_id[id] = rannum
			player_skin[id]=1
			player_b_damage[id] = 8
			player_b_windwalk[id] = 10
			player_speedbonus[id] = 50
			changeskin(id,0)
			player_item_name[id] = "Pierscien mordercy"
			show_hudmessage(id, "Znalazles przedmiot: %s :: Jestes morderca!",player_item_name[id])
		}
		case 166:
		{
			player_item_name[id] = "Chwila ryzyka"
			player_item_id[id] = rannum
			player_chwila_ryzyka[id] = 1
			show_hudmessage (id, "Znalazles przedmiot : %s :: Wylosuj 20 000$ i exp lub swoja smierc ",player_item_name[id])
		}
		case 167:
		{
			player_item_name[id] = "Naszyjnik lotrzyka"
			player_item_id[id] = rannum
			player_gtrap[id] = 1
			show_hudmessage (id, "Znalazles przedmiot : %s :: Mozesz podkladac granaty pulapki. ",player_item_name[id])
		}
		case 168:
		{
			player_item_id[id] = rannum
			player_b_inv[id] = random_num(50,80)
			player_b_blind[id] = random_num(1,3)
			player_b_heal[id] = random_num(20,30)
			player_item_name[id] = "Plaszcz doskonalosci"
			show_hudmessage(id, "Znalazles przedmiot: %s :: Redukuje twoja widocznosc, masz szanse, ze twoj przeciwnik straci wzrok, regeneruje twoje zdrowie i mozesz postawic totem leczacy na 7 sek",player_item_name[id])
		}
		case 169:
		{
			player_item_name[id] = "Amulet Draculi"
			player_item_id[id] = rannum
			player_b_vampire[id] = random_num(8,10)
			player_b_damage[id] = random_num(4,8)
			player_b_redirect[id] = random_num(8,10)
			show_hudmessage(id, "Znalazles przedmiot: %s :: Kradniesz wrogowi zycie, zadajesz dodatkowe obrazenia, zmniejsza otrzymywane obrazenia",player_item_name[id])
			
		}
		case 170:
		{
			if(player_class[id]!=Gon){
				player_item_name[id] = "Moc demona"
				player_item_id[id] = rannum
				player_b_inv[id] = 10
				item_durability[id] = 50
				player_5hp[id] = 1
				if (is_user_alive(id)) set_user_health(id,5)	
				player_b_grenade[id] = 3
				show_hudmessage(id, "Znalazles przedmiot: %s :: Twoja widocznosc zredukowana jest do 10, Twoje hp zredukowane jest do 5, masz 1/2 na natychmiastowe zabicie z HE",player_item_name[id])
			 }else{
				award_unique_item(id)
			}		
		}





		
		
		
		
		
		
		
		
		/*
		
		case 69:
		{
			player_item_name[id] = "Czarny Rytual"	
			player_item_id[id] = rannum
			player_lich[id] = 1
			show_hudmessage (id, "Znalazles przedmiot : %s :: Uzyj raz na runde by nalozyc klatwe. Wskrzesisz sojusznikow na obszarze 500 jako duchy.",player_item_name[id])
		}
		case 19:
		{
			player_item_name[id] = "Niekonczace sie szeregi smierci"
			player_item_id[id] = rannum
			player_b_respawn[id] = random_num(4,6)
			if(player_class[id]!=Nekromanta) player_b_respawn[id] = random_num(1,2)
			endless[id] = 2
			show_hudmessage(id, "Znalazles przedmiot: %s :: Gdy umierasz wskrzeszasz dwóch martwych sojuszników jako zombie. Zdobywaj¹ oni dla Ciebie doœwiadczenie.",player_item_name[id],player_b_respawn[id])	
		}
		case 4:
		{
			player_item_name[id] = "Sztylet nekromanty"
			player_item_id[id] = rannum
			player_zombie_killer[id] = random_num(4,6)
			if(player_class[id] == Nekromanta) player_zombie_item[id] = random_num(1,3)
			show_hudmessage(id, "Znalazles przedmiot: %s :: Po zabiciu przeciwnika wskrzeszasz go, staje sie on zombie i jest po twojej stronie, zdobywa dla ciebie doswiadczenie. ",player_item_name[id])
		}
		case 5:
		{
			player_item_name[id] = "Ksiega nekromanty"
			player_item_id[id] = rannum
			player_zombie_killer_magic[id] = random_num(1,3)
			if(player_class[id] == Nekromanta) player_zombie_killer_magic[id] = 1
			
			show_hudmessage(id, "Znalazles przedmiot: %s :: Po zabiciu przeciwnika magia wskrzeszasz go, staje sie on zombie i jest po twojej stronie, zdobywa dla ciebie doswiadczenie. ",player_item_name[id])
		}
		
		case 23:
		{
			if(player_class[id]==Gon) {
				award_unique_item(id)
			}else{
				player_item_name[id] = "Kostur czarnej rozy"
				player_item_id[id] = rannum
				player_b_blink2[id] = 1
				player_b_blink3[id] = 1
				player_odpornosc_fire[id] = 2
				show_hudmessage(id, "Znalazles przedmiot: %s :: Mozesz teleportowac sie co 20 sek przez uzywanie alternatywnego ataku twoim nozem (PPM). Kolejne uzycie w ci¹gu 10 sekund cofnie Ciê na miejsce sprzed teleportu.",player_item_name[id])	
			}
		}
		case 33:
		{
			if(player_class[id]!=Gon){
				player_item_name[id] = "Podstep blazna"
				player_item_id[id] = rannum
				player_b_blink2[id] = 1
				player_b_blink4[id] = 1
				player_odpornosc_fire[id] = 2
				show_hudmessage(id, "Znalazles przedmiot: %s :: Mozesz teleportowac sie co 20 sek przez uzywanie alternatywnego ataku twoim nozem (PPM). Staniesz siê niewidzialny na 10 sekund, lub do momentu oddania strzalu.",player_item_name[id])	
			}else{
				award_unique_item(id)
			}
		}
		case 42:
		{
			player_item_name[id] = "Knife Ruby"
			player_item_id[id] = rannum
			player_b_blink[id] = floatround(halflife_time())
			show_hudmessage(id, "Znalazles przedmiot: %s :: Twoj noz pozwala ci teleportowac sie raz na 3 sekundy",player_item_name[id])
		}
		case 58:
		{
			player_item_name[id] = "Ninja ring"
			player_item_id[id] = rannum
			player_b_blink[id] = floatround(halflife_time())
			player_b_froglegs[id] = 1
			show_hudmessage(id, "Znalazles przedmiot: %s :: Twoj noz pozwala ci teleportowac sie co 3 sekundy i zrobic dlugi skok jak kucniesz na 3 sekundy",player_item_name[id])
		}
		case 170:
		{
			if(player_class[id] == Ninja && random_num(0,2)==0) return PLUGIN_CONTINUE 
			player_item_name[id] = "Skrzydla demona"
			player_item_id[id] = rannum
			player_b_gravity[id] = random_num(8,10)
			player_b_reduceH[id] = 75
			if(get_user_health(id) >  get_maxhp(id) && player_b_reduceH[id] > 0) set_user_health(id,get_maxhp(id))
			if (is_user_alive(id))
				set_gravitychange(id)
			player_b_blink[id] = 1
			player_b_jumpx[id] = 1
			show_hudmessage(id, "Znalazles przedmiot: %s :: Premia do wysokiego skoku +%s, twoje zdrowie zredukowanie jest o 75, mozesz teleportowac sie za pomoca noza, mozesz wykonac dodatkowy skok w powietrzu",player_item_name[id],player_b_gravity[id])
		}
		case 173:
		{
			player_item_name[id] = "Pierscien Lowcy"
			player_item_id[id] = rannum
			player_b_grenade[id] = random_num(2,4)
			
			player_b_blink[id] = 1
			player_b_jumpx[id] = 1
			show_hudmessage(id, "Znalazles przedmiot: %s :: Masz szanse na natychmiastowe zabicie z HE, mozesz teleportowac sie za pomoca swojego noza, mozesz wykonac dodatkowy skok w powietrzu",player_item_name[id])
			
		}
		case 26:
		{
			if(player_class[id]!=Gon){
				player_item_name[id] = "Krwawy kostur czarnej rozy"
				player_item_id[id] = rannum
				player_b_blink2[id] = 1
				player_b_explode[id] = random_num(200,400)
				player_b_blink3[id] = 1
				show_hudmessage(id, "Znalazles przedmiot: %s :: Mozesz teleportowac sie co 20 sek przez uzywanie alternatywnego ataku twoim nozem(PPM), spowoduje to wybuch! Kolejne uzycie w ci¹gu 10 sekund cofnie Ciê na miejsce sprzed teleportu.",player_item_name[id])	
			}else{
				award_unique_item(id)
			}
		}
		
		case 50:
		{
			player_item_name[id] = "Iron Spikes"
			player_item_id[id] = rannum
			player_b_smokehit[id] = 1
			fm_give_item(id, "weapon_smokegrenade")	
			show_hudmessage(id, "Znalazles przedmiot: %s :: Jezeli uderzasz kogos granatami dymym, to on zginie",player_item_name[id])	
		}
		
		
		
		
		
		
		
		
		case 67:
		{
			player_item_name[id] = "Lesna pulapka"
			player_item_id[id] = rannum
			player_b_mine_lesna[id] = 5
			show_hudmessage(id, "Znalazles przedmiot: %s :: Uzyj, zeby polozyc niewidzialna mine, ktora unieruchomi przeciwnika",player_item_name[id])
		}
		case 90:
		{
			player_item_name[id] = "Lodowa pulapka"
			player_item_id[id] = rannum
			player_b_mine_lodu[id] = 5
			show_hudmessage(id, "Znalazles przedmiot: %s :: Uzyj, zeby polozyc niewidzialna mine, ktora zwolni przeciwnika",player_item_name[id])
		}
		case 57:
		{
			player_item_name[id] = "Pajeczy wladca"
			player_item_id[id] = rannum
			player_b_mine[id] = 3
			show_hudmessage(id, "Znalazles przedmiot: %s :: Uzyj, zeby polozyc  pajaka",player_item_name[id])
		}
		case 188:
		{
			if(player_class[id]!=Ninja ||player_class[id]!=Samurai||player_class[id]!=Demon ||player_class[id]!=Heretyk){
				player_item_name[id] = "Szata wampirzego lorda"
				player_item_id[id] = rannum
				player_bats[id] = 1
				player_trac_hp[id] = random_num(5,7)
				bats_on(id)
				show_hudmessage(id, "Znalazles przedmiot: %s :: Masz dodatkowe obrazenia z noza. Otaczaja Cie nietoperze. Zadajesz dodatkowe obrazenia rowne roznicy levelu twojego i przeciwnika. Uzyj by przyspieszyc zamieniajac sie w chmure nietoperzy.",player_item_name[id])
			}else{
				award_unique_item(id)
			}
		}
		case 189:
		{
			if(cs_get_user_team(id) == CS_TEAM_CT) {
				player_item_id[id] = rannum
				player_skin[id]=2
				player_trac_hp[id] = random_num(5,7)
				player_trafiony_truj[id] = random_num(5,10)
				player_ludziebonus[id] = random_num(10,20)
				changeskin(id,0)
				player_item_name[id] = "Pierscien nieumarlych"
				show_hudmessage(id, "Znalazles przedmiot: %s :: Jestes nieumarlym!",player_item_name[id])
			}else{
				award_unique_item(id)
			}
		}

		*/
		
	}
	if(player_item_id[id] == 0) award_unique_item(id)
	player_ns[id] = 0  
	player_ni[id] = 0
	player_na[id] = 0
	player_nd[id] = 0
	item_durability[id] += player_agility[id] * 7
	

	BoostRing(id)
	dexteryDamRedCalc(id)
	write_hud(id)
	
	return PLUGIN_CONTINUE
}

/* UNIQUE ITEMS ============================================================================================ */
//Names are generated from an array


public award_unique_item(id)
{
	new Unique_names_Suffix[10][100]
	new Unique_names_Prefix[10][100]
	
	Unique_names_Suffix[1] = "Swiety amulet "
	Unique_names_Suffix[2] = "Przeklety miecz "
	Unique_names_Suffix[3] = "Mala laska "
	Unique_names_Suffix[4] = "Zyjaca lina "
	Unique_names_Suffix[5] = "Blyszczace berlo "
	Unique_names_Suffix[6] = "Hebanowa zbroja "
	Unique_names_Suffix[7] = "Swiety miecz "
	Unique_names_Suffix[8] = "Elficki plaszcz "
	
	Unique_names_Prefix[1] = "ognia"
	Unique_names_Prefix[2] = "zycia"
	Unique_names_Prefix[3] = "zniszczenia"
	Unique_names_Prefix[4] = "ochrony"
	Unique_names_Prefix[5] = "regeneracji"
	
	Unique_names_Prefix[6] = "ognia piekielnego"
	Unique_names_Prefix[7] = "akrobaty"
	Unique_names_Prefix[8] = "nieustepliwosci"
	
	//Generate the items name
	
	new roll_1 = random_num(1,8)
	new roll_2 = random_num(1,8)
	new roll_3 = 0
	
	if(roll_1== 3 && roll_2 == 5) roll_2 = random_num(1,3)
	
	new Unique_name[100]
	add(Unique_name,99,Unique_names_Suffix[roll_1])
	add(Unique_name,99,Unique_names_Prefix[roll_2])
	
	player_item_name[id] = Unique_name
	player_item_id[id] = 100				
	
	//Generate and apply the stats
	
	if (roll_1 == 1){
		player_b_damage[id] = random_num(1,8)
	}
	if (roll_1 == 2) player_b_vampire[id] = random_num(2,5)
	if (roll_1 == 3) player_b_money[id] =  random_num(2000,4000) + player_intelligence[id] *50
	if (roll_1 == 4){ 
		player_b_reduceH[id] = random_num(10,60)
		roll_3 = random_num(1,7)
	}
	if (roll_1 == 5) player_b_blind[id] = random_num(3,5)
	if (roll_1 == 6){
		player_tarczam[id] = random_num(200,700)
	}
	if (roll_1 == 7){
		player_mrocznibonus[id] = random_num(10,20)
	}
	if (roll_1 == 8) player_b_inv[id] = random_num(90,150)
	
	
	if (roll_2 == 1 || roll_3 == 1) player_b_grenade[id] = random_num(2,5)
	if (roll_2 == 2 || roll_3 == 2) player_b_respawn[id] = random_num(3,6)
	if (roll_2 == 3 || roll_3 == 3) player_b_explode[id] = random_num(150,400)
	if (roll_2 == 4 || roll_3 == 4) player_b_redirect[id] = random_num(4,8)
	if (roll_2 == 5 || roll_3 == 5) player_b_heal[id] = random_num(5,15)
	if (roll_2 == 6 || roll_3 == 6) player_ludziebonus[id] = random_num(10,20)
	if (roll_2 == 7 || roll_3 == 7) player_b_jumpx[id] =  random_num(2,10)
	if (roll_2 == 8 || roll_3 == 8) player_b_nieust[id] =  random_num(20,50)
	
	if(get_user_health(id) >  get_maxhp(id) && player_b_reduceH[id] > 0) set_user_health(id,get_maxhp(id))
	item_durability[id] = 750
	
	set_hudmessage(220, 115, 70, -1.0, 0.40, 0, 3.0, 2.0, 0.2, 0.3, 5)
	show_hudmessage(id, "Uniqie Znalazles przedmiot: %s", Unique_name)	
}
/* EFFECTS ================================================================================================= */

public add_damage_bonus(id,damage,attacker_id)
{
	if (player_b_damage[attacker_id] > 0 && get_user_health(id)>player_b_damage[attacker_id])
	{
		change_health(id,-player_b_damage[attacker_id],attacker_id,"")
		
		if (random_num(0,2) == 1) Effect_Bleed(id,248)
	}
	else if(get_user_health(id)<player_b_damage[attacker_id] && player_b_damage[attacker_id] > 0 ){
		
		change_health(id,-get_user_health(id),attacker_id,"")
		
		if (random_num(0,2) == 1) Effect_Bleed(id,248)
	}
}

/* ==================================================================================================== */

public add_vampire_bonus(id,damage,attacker_id)
{
	if (player_b_vampire[attacker_id] > 0)
	{
		vampire(id,player_b_vampire[attacker_id],attacker_id)
		if(player_5hp[attacker_id] == 1 && player_b_vampire[attacker_id] == 1){
			fm_set_user_health(attacker_id, get_user_health(attacker_id) + player_b_vampire[attacker_id]) 
		}
	}
	if(player_class[attacker_id]== Heretyk){
		new wys = player_intelligence[attacker_id]/6;
		if(wys>30) wys = 30
		vampire(id,wys,attacker_id)
	}
	if(player_class[attacker_id]== Nekromanta){
		new wys = 5;
		vampire(id,wys,attacker_id)
		
	}
	if(player_class[attacker_id]== Demon){
		new perc = 1 + player_nal[attacker_id];
		new wys = get_maxhp(id) * perc / 100
		new red = dexteryDamRedPerc[id]
		wys = wys - (wys * red /100)
		change_health(attacker_id,wys,0,"world");
		change_health(id,-wys,attacker_id,"world");
	}
}

/* ==================================================================================================== */

public add_money_bonus(id)
{
	if (player_b_money[id] > 0)
	{
		if (cs_get_user_money(id) < 16000 - player_b_money[id]) 
		{
			cs_set_user_money(id,cs_get_user_money(id)+ player_b_money[id]) 
		} 
		
		else 
		{
			cs_set_user_money(id,16000)
		}
	}
}



/* ==================================================================================================== */

public add_grenade_bonus(id,attacker_id,weapon)
{
	if(weapon != CSW_HEGRENADE) return PLUGIN_HANDLED
	if(player_class[id]==Troll){
		change_health(id, -100, attacker_id, "world")
	}
	if(player_class[attacker_id]==Ifryt){
		change_health(id, -50, attacker_id, "world")
	}
	
	if (player_b_grenade[attacker_id] > 0 && weapon == CSW_HEGRENADE && player_b_fireshield[id] == 0)	//Fireshield check
	{
		new roll = random_num(1,player_b_grenade[attacker_id])
		if (roll == 1)
		{
			UTIL_Kill(attacker_id,id,"grenade")
			/*
			set_user_health(id, 0)
			message_begin( MSG_ALL, gmsgDeathMsg,{0,0,0},0) 
			write_byte(attacker_id) 
			write_byte(id) 
			write_byte(0) 
			write_string("grenade") 
			message_end() 
			set_user_frags(attacker_id, get_user_frags(attacker_id)+1) 
			set_user_frags(id, get_user_frags(id)+1)
			cs_set_user_money(attacker_id, cs_get_user_money(attacker_id)+150) 
			*/
		}
	}
	return PLUGIN_HANDLED
}

/* ==================================================================================================== */

public add_redhealth_bonus(id)
{
	if (player_b_reduceH[id] > 0){
		if(get_user_health(id) <= player_b_reduceH[id]) fm_set_user_health(id,1)
		else change_health(id,-player_b_reduceH[id],0,"")
	}
	if(player_5hp[id] ==1)	//stalker ring
		set_user_health(id,5)
}

/* ==================================================================================================== */

public add_theif_bonus(id,attacker_id)
{
	if (player_b_theif[attacker_id] > 0)
	{
		new roll1 = random_num(1,5)
		if (roll1 == 1)
		{
			if (cs_get_user_money(id) > player_b_theif[attacker_id])
			{
				cs_set_user_money(id,cs_get_user_money(id)-player_b_theif[attacker_id])
				if (cs_get_user_money(attacker_id) + player_b_theif[attacker_id] <= 16000)
				{
					cs_set_user_money(attacker_id,cs_get_user_money(attacker_id)+player_b_theif[attacker_id])		
				}
			}
			else
			{
				new allthatsleft = cs_get_user_money(id)
				cs_set_user_money(id,0)
				if (cs_get_user_money(attacker_id) + allthatsleft <= 16000)
				{
					cs_set_user_money(attacker_id,cs_get_user_money(attacker_id) + allthatsleft)			
				}
			}
		}
	}
}

/* ==================================================================================================== */

public add_respawn_bonus(id)
{
	new r = player_b_respawn[id]
	if(player_class[id]== Nekromanta) r = 8;
	if(player_class[id]== Heretyk) r = 5;
	if(r > player_b_respawn[id] && player_b_respawn[id] != 0) r = player_b_respawn[id]

	
	if ( r > 0)
	{
		new svIndex[32] 
		num_to_str(id,svIndex,32)
		new roll = random_num(1,r )
		if (roll == 1)
		{
			new maxpl,players[32]
			get_players(players, maxpl) 
			if (maxpl > 2)
			{
				cs_set_user_money(id,cs_get_user_money(id)+4000)
				set_task(0.5,"respawn",0,svIndex,32) 		
			}
			else
			{
				set_hudmessage(220, 115, 70, -1.0, 0.40, 0, 3.0, 2.0, 0.2, 0.3, 5)
				show_hudmessage(id, "Wiecej niz 2 graczy jest wymagane do ponownego odrodzenia sie")	
			}
			
		}
	}
}

public respawn(svIndex[]) 
{ 
	new vIndex = str_to_num(svIndex) 
	if(!is_user_connected(vIndex)) return;
	if(is_user_alive(vIndex) && planter == vIndex){
		set_task(3.5,"after_spawn_c4",vIndex) 
	}
	spawn(vIndex);
	fm_give_item(vIndex, "weapon_knife")
	fm_give_item(vIndex, "weapon_glock")
	set_task(1.5,"after_spawn",vIndex) 	
	
}
public after_spawn_c4(id)
{
	fm_give_item(id, "weapon_c4") 
	fm_set_user_plant(id, 1, 1)
}
#define OFFSET_DEFUSE_PLANT		193
#define CAN_PLANT_BOMB			(1<<8) 
#define DEFUSER_COLOUR_R		0
#define DEFUSER_COLOUR_G		160
#define DEFUSER_COLOUR_B		0
stock fm_set_user_plant(id, plant = 1, showbombicon = 1)
{
	new plantskill = get_pdata_int(id, OFFSET_DEFUSE_PLANT);
	
	if(plant)
	{
		plantskill |= CAN_PLANT_BOMB;
		set_pdata_int(id, OFFSET_DEFUSE_PLANT, plantskill);
		
		if(showbombicon)
		{
			message_begin(MSG_ONE, statusiconmsg, _, id);
			write_byte(1);
			write_string("c4");
			write_byte(DEFUSER_COLOUR_R);
			write_byte(DEFUSER_COLOUR_G);
			write_byte(DEFUSER_COLOUR_B);
			message_end();
		}
	}
}
/* ==================================================================================================== */


public add_bonus_explode(id)
{
	new expl =0
	expl = player_b_explode[id]
	if(player_class[id]==Demon){
		expl += 100 + player_intelligence[id]
	} 
	if(player_class[id] == Ifryt && player_lvl[id] > prorasa) expl += 100 + player_intelligence[id]/2
	if (expl > 10)
	{
		
		new origin[3] 
		get_user_origin(id,origin) 
		if(player_class[id] == Demon)
		{
			new origin[3] 
			get_user_origin(id,origin) 
			Effect_Bleed2(id,248)	
			
			message_begin( MSG_BROADCAST,SVC_TEMPENTITY,origin) 
			write_byte( 21 ) 
			write_coord(origin[0]) 
			write_coord(origin[1]) 
			write_coord(origin[2] + 32) 
			write_coord(origin[0]) 
			write_coord(origin[1]) 
			write_coord(origin[2] + 1000)
			write_short( sprite_white ) 
			write_byte( 0 ) 
			write_byte( 0 ) 
			write_byte( 3 ) 
			write_byte( 10 ) 
			write_byte( 0 ) 
			write_byte( 248 ) 
			write_byte( 0 ) 
			write_byte( 05 ) 
			write_byte( 255 ) 
			write_byte( 0 ) 
			message_end() 
		}
		else{
			explode(origin,id,0)
		}
		new hh = 0
		
		for(new a = 0; a < MAX; a++) 
		{ 
			if (!is_user_connected(a) || !is_user_alive(a) || player_b_fireshield[a] != 0 ||  get_user_team(a) == get_user_team(id))
				continue	
			
			new origin1[3]
			get_user_origin(a,origin1) 
			
			
			if(get_distance(origin,origin1) < expl + player_intelligence[id]*2)
			{
				new dam = 75-(player_dextery[a]*2)
				if(dam<10) dam=10
				dam += 10 * get_maxhp(a) / 100
				hh += dam;
				if(player_b_blink3[id]>0 && random_num(0,5)==0) dam=5000
				change_health(a,-dam,id,"grenade")
				Display_Fade(id,2600,2600,0,255,0,0,15)	
				if(player_class[id] == Demon)
				{
					Effect_Bleed2(a,248)	
				}
			}
		}
		if(hh > 0)
		{
			demonLastHp[id] = hh/2
			if(demonLastHp[id]> 250) demonLastHp[id] = 250
			if(demonLastHp[id] > get_maxhp(id)) demonLastHp[id] = get_maxhp(id)
			new maxpl,players[32]
			get_players(players, maxpl) 
			if (maxpl > 5 )
			{
				if(random_num(0,1)==0)
				{
					new svIndex[32] 
					num_to_str(id,svIndex,32)
					cs_set_user_money(id,cs_get_user_money(id)+4000)
					set_task(0.5,"respawn",0,svIndex,32) 	
				}
			}
			else
			{
				set_hudmessage(220, 115, 70, -1.0, 0.40, 0, 3.0, 2.0, 0.2, 0.3, 5)
				show_hudmessage(id, "Wiecej niz 2 graczy jest wymagane do ponownego odrodzenia sie")	
			}
		}
	}
}

public explode(vec1[3],playerid, trigger)
{ 
	message_begin( MSG_BROADCAST,SVC_TEMPENTITY,vec1) 
	write_byte( 21 ) 
	write_coord(vec1[0]) 
	write_coord(vec1[1]) 
	write_coord(vec1[2] + 32) 
	write_coord(vec1[0]) 
	write_coord(vec1[1]) 
	write_coord(vec1[2] + 1000)
	write_short( sprite_white ) 
	write_byte( 0 ) 
	write_byte( 0 ) 
	write_byte( 3 ) 
	write_byte( 10 ) 
	write_byte( 0 ) 
	write_byte( 188 ) 
	write_byte( 220 ) 
	write_byte( 255 ) 
	write_byte( 255 ) 
	write_byte( 0 ) 
	message_end() 
	
	message_begin( MSG_BROADCAST,SVC_TEMPENTITY) 
	write_byte( 12 ) 
	write_coord(vec1[0]) 
	write_coord(vec1[1]) 
	write_coord(vec1[2]) 
	write_byte( 188 ) 
	write_byte( 10 ) 
	message_end() 
	
	message_begin( MSG_BROADCAST,SVC_TEMPENTITY,vec1) 
	write_byte( 3 ) 
	write_coord(vec1[0]) 
	write_coord(vec1[1]) 
	write_coord(vec1[2]) 
	write_short( sprite_fire ) 
	write_byte( 65 ) 
	write_byte( 10 ) 
	write_byte( 0 ) 
	message_end() 
	
	message_begin(MSG_BROADCAST,SVC_TEMPENTITY,{0,0,0},playerid) 
	write_byte(107) 
	write_coord(vec1[0]) 
	write_coord(vec1[1]) 
	write_coord(vec1[2]) 
	write_coord(175) 
	write_short (sprite_gibs) 
	write_short (25)  
	write_byte (10) 
	message_end() 
	if (trigger == 1)
	{
		set_user_rendering(playerid,kRenderFxNone, 0,0,0, kRenderTransAdd,0) 
	}
}

/* ==================================================================================================== */

public add_bonus_gamble(id)
{	
	if (player_b_gamble[id] > 0 && is_user_alive(id))
	{
		new durba=item_durability[id]
		
		reset_item_skills(id)
		item_durability[id]=durba
		set_hudmessage(220, 115, 70, -1.0, 0.40, 0, 3.0, 2.0, 0.2, 0.3, 5)
		new roll = random_num(1,player_b_gamble[id])
		if (roll == 1)
		{
			show_hudmessage(id, "Premia rundy: +10 obrazen")
			player_b_damage[id] = 10
		}
		if (roll == 2)
		{
			show_hudmessage(id, "Premia rundy: +250 tarczy magicznej")
			player_tarczam[id] = 250
		}
		if (roll == 3)
		{
			show_hudmessage(id, "Premia rundy: +8 obrazen wampira")
			player_b_vampire[id] = 8
		}
		if (roll == 4)
		{
			show_hudmessage(id, "Premia rundy: +20 hp co kazde 5 sekund")
			player_b_heal[id] = 20
		}
		if (roll == 5)
		{
			show_hudmessage(id, "Premia rundy: 1/3 szans do natychmiastowego zabicia HE")
			player_b_grenade[id] = 3
		}
	}
}

/* ==================================================================================================== */

public add_bonus_blind(id,attacker_id,weapon,damage)
{
	if (player_b_blind[attacker_id] > 0 && weapon != 4) 
	{
		if (wear_sun[id] != 1){
			if (random_num(1,player_b_blind[attacker_id]) == 1) Display_Fade(id,1<<14,1<<14 ,1<<16,255,155,50,230)	
		}
		
	}
}

/* ==================================================================================================== */

public item_c4fake(id)
{ 
	if (c4state[id] > 1)
	{
		hudmsg(id,2.0,"Meekstone mozesz uzyc raz na runde!")
		return PLUGIN_CONTINUE 
	}
	
	if (player_b_meekstone[id] > 0 && c4state[id] == 1 && is_user_alive(id) == 1 && freeze_ended == true)
	{
		explode(c4bombc[id],id,0)
		
		for(new a = 0; a < MAX; a++) 
		{ 
			if (is_user_connected(a) && is_user_alive(a))
			{			
				new origin1[3]
				get_user_origin(a,origin1) 
				
				if(get_distance(c4bombc[id],origin1) < 300 && get_user_team(a) != get_user_team(id))
				{
					UTIL_Kill(id,a,"grenade")
				}
			}
		}
		
		c4state[id] = 2
		remove_entity(c4fake[id])
		c4fake[id] = 0 
	}
	
	if (player_b_meekstone[id] > 0 && c4state[id] == 0 && c4fake[id] == 0 && is_user_alive(id) == 1 && freeze_ended == true)
	{
		new Float:pOrigin[3]
		entity_get_vector(id,EV_VEC_origin, pOrigin)
		c4fake[id] = create_entity("info_target")
		
		entity_set_model(c4fake[id],"models/w_backpack.mdl")
		entity_set_origin(c4fake[id],pOrigin)
		entity_set_string(c4fake[id],EV_SZ_classname,"fakec4")
		entity_set_edict(c4fake[id],EV_ENT_owner,id)
		entity_set_int(c4fake[id],EV_INT_movetype,6)
		
		
		new Float:aOrigin[3]
		entity_get_vector(c4fake[id],EV_VEC_origin, aOrigin)
		c4bombc[id][0] = floatround(aOrigin[0])
		c4bombc[id][1] = floatround(aOrigin[1])
		c4bombc[id][2] = floatround(aOrigin[2])
		c4state[id] = 1
	}
	
	return PLUGIN_CONTINUE 
}

/* ==================================================================================================== */

public item_fireball(id)
{
	if (fired[id] > 0)
	{
		hudmsg(id,2.0,"Swietlistej kuli mozesz uzyc raz na runde!")
		return PLUGIN_HANDLED
	}
	
	if (fired[id] == 0 && is_user_alive(id) == 1)
	{
		fired[id] = 1
		new Float:vOrigin[3]
		new fEntity
		
		entity_get_vector(id,EV_VEC_origin, vOrigin)
		fEntity = create_entity("info_target")
		entity_set_model(fEntity, "models/rpgrocket.mdl")
		entity_set_origin(fEntity, vOrigin)
		entity_set_int(fEntity,EV_INT_effects,64)
		entity_set_string(fEntity,EV_SZ_classname,"fireball")
		entity_set_int(fEntity, EV_INT_solid, SOLID_BBOX)
		entity_set_int(fEntity,EV_INT_movetype,5)
		entity_set_edict(fEntity,EV_ENT_owner,id)
		
		
		
		//Send forward
		new Float:fl_iNewVelocity[3]
		VelocityByAim(id, 750, fl_iNewVelocity)
		entity_set_vector(fEntity, EV_VEC_velocity, fl_iNewVelocity)
		
		
		message_begin(MSG_BROADCAST, SVC_TEMPENTITY) 
		write_byte(22) 
		write_short(fEntity) 
		write_short(sprite_beam) 
		write_byte(45) 
		write_byte(4) 
		write_byte(255) 
		write_byte(0) 
		write_byte(0) 
		write_byte(25)
		message_end() 
	}	
	return PLUGIN_HANDLED
}

/* ==================================================================================================== */

public add_bonus_redirect(id, damage)
{
	new red = player_b_redirect[id]
	if(player_class[id]==Troll) red = 13 + player_b_redirect[id]
	if(player_class[id]==Dremora){
		new f = player_intelligence[id]/15
		if(f>15) f=15
		red = 3 + f + player_b_redirect[id]
	} 
	
	if (red > 0)
	{
		if (get_user_health(id)+red < get_maxhp(id))
		{
			if(red > damage) red = damage;
			change_health(id,red,0,"")			
		}
		
	}
	
}

/* ==================================================================================================== */

public item_ghost(id)
{
	if (ghoststate[id] == 0 && player_b_ghost[id] > 0 && is_user_alive(id) && !ghost_check[id])
	{
		set_user_noclip(id,1)
		ghoststate[id] = 2
		ghosttime[id] = floatround(halflife_time())
		ghost_check[id] = true
		
		message_begin( MSG_ONE, gmsgBartimer, {0,0,0}, id ) 
		write_byte( player_b_ghost[id]+1 ) 
		write_byte( 0 ) 
		message_end() 
	}
	else
	{
		hudmsg(id,3.0,"Przedmiot zostal uzyty!")
	}
}

/* ==================================================================================================== */

public add_bonus_darksteel(attacker,id,damage)
{
	if (player_b_darksteel[attacker] > 0)
	{
		if (UTIL_In_FOV(attacker,id) && !UTIL_In_FOV(id,attacker))
		{
			
			new dam = floatround (15+player_intelligence[attacker]*2*player_b_darksteel[attacker]/10.0)
			
			Effect_Bleed(id,248)
			change_health(id,-dam,attacker,"world")
			Display_Fade(id,seconds(1),seconds(1),0,255,0,0,150)
		}
	}
}

/* ==================================================================================================== */

public item_eye(id)
{
	if (player_b_eye[id] == -1)
	{
		//place camera
		new Float:playerOrigin[3]
		entity_get_vector(id,EV_VEC_origin,playerOrigin)
		new ent = create_entity("info_target") 
		entity_set_string(ent, EV_SZ_classname, "PlayerCamera") 
		entity_set_int(ent, EV_INT_movetype, MOVETYPE_NOCLIP) 
		entity_set_int(ent, EV_INT_solid, SOLID_NOT) 
		entity_set_edict(ent, EV_ENT_owner, id)
		entity_set_model(ent, "models/rpgrocket.mdl")  				//Just something
		entity_set_origin(ent,playerOrigin)
		entity_set_int(ent,EV_INT_iuser1,0)		//Viewing through this camera						
		set_rendering (ent,kRenderFxNone, 0,0,0, kRenderTransTexture,0)
		entity_set_float(ent,EV_FL_nextthink,halflife_time() + 0.01) 
		player_b_eye[id] = ent
	}
	else
	{
		//view through camera or stop viewing
		new ent = player_b_eye[id]
		if (!is_valid_ent(ent))
		{
			attach_view(id,id)
			return PLUGIN_HANDLED
		}
		new viewing = entity_get_int(ent,EV_INT_iuser1)
		
		if (viewing) 
		{	
			entity_set_int(ent,EV_INT_iuser1,0)
			attach_view(id,id)
		}	
		else 
		{
			entity_set_int(ent,EV_INT_iuser1,1)
			attach_view(id,ent)
		}
	}
	
	return PLUGIN_HANDLED
}

/* ==================================================================================================== */

//Called when PlayerCamera thinks
public Think_PlayerCamera(ent)
{
	new id = entity_get_edict(ent,EV_ENT_owner)
	
	//Check if player is still having the item and is still online
	if (!is_valid_ent(id) || player_b_eye[id] == 0 || !is_user_connected(id))
	{
		//remove entity
		if (is_valid_ent(id) && is_user_connected(id)) attach_view(id,id)
		remove_entity(ent)
	}
	else
	{
		//Dont use cpu when not alive anyway or not viewing
		if (!is_user_alive(id))
		{
			entity_set_float(ent,EV_FL_nextthink,halflife_time() + 3.0) 
			return PLUGIN_HANDLED
		}
		
		if (!entity_get_int(ent,EV_INT_iuser1))
		{
			entity_set_float(ent,EV_FL_nextthink,halflife_time() + 0.5) 
			return PLUGIN_HANDLED
		}
		
		entity_set_float(ent,EV_FL_nextthink,halflife_time() + 0.01) 
		
		//Find nearest player to camera
		new Float:pOrigin[3],Float:plOrigin[3],Float:ret[3]
		entity_get_vector(ent,EV_VEC_origin,plOrigin)
		new Float:distrec = 2000.0, winent = -1
		
		for (new i=0; i<MAX; i++) 
		{
			if (is_user_connected(i) && is_user_alive(i))
			{
				entity_get_vector(i,EV_VEC_origin,pOrigin)
				pOrigin[2]+=10.0
				if (trace_line ( 0, plOrigin, pOrigin, ret ) == i && vector_distance(pOrigin,plOrigin) < distrec)
				{
					winent = i
					distrec = vector_distance(pOrigin,plOrigin)
				}
			}	
		}
		
		//Traceline and updown is still revresed
		if (winent > -1)
		{
			new Float:toplayer[3], Float:ideal[3],Float:pOrigin[3]
			entity_get_vector(winent,EV_VEC_origin,pOrigin)
			pOrigin[2]+=10.0
			toplayer[0] = pOrigin[0]-plOrigin[0]
			toplayer[1] = pOrigin[1]-plOrigin[1]
			toplayer[2] = pOrigin[2]-plOrigin[2]
			vector_to_angle ( toplayer, ideal ) 
			ideal[0] = ideal[0]*-1
			entity_set_vector(ent,EV_VEC_angles,ideal)
		}
	}
	
	return PLUGIN_CONTINUE
}

public Create_Line(id,origin1[3],origin2[3],bool:draw)
{
	if (draw)
	{
		message_begin(MSG_ONE,SVC_TEMPENTITY,{0,0,0},id)
		write_byte(0)
		write_coord(origin1[0])	// starting pos
		write_coord(origin1[1])
		write_coord(origin1[2])
		write_coord(origin2[0])	// ending pos
		write_coord(origin2[1])
		write_coord(origin2[2])
		write_short(sprite_line)	// sprite index
		write_byte(1)		// starting frame
		write_byte(5)		// frame rate
		write_byte(2)		// life
		write_byte(3)		// line width
		write_byte(0)		// noise
		write_byte(255)	// RED
		write_byte(50)	// GREEN
		write_byte(50)	// BLUE					
		write_byte(155)		// brightness
		write_byte(5)		// scroll speed
		message_end()
	}
	
	new Float:ret[3],Float:fOrigin1[3],Float:fOrigin2[3]
	//So we dont hit ourself
	origin1[2]+=50
	IVecFVec(origin1,fOrigin1)
	IVecFVec(origin2,fOrigin2)
	new hit = trace_line ( 0, fOrigin1, fOrigin2, ret )
	return hit
	
}

/* ==================================================================================================== */

public Prethink_Blink(id)
{
	if( get_user_button(id) & IN_ATTACK2 && !(get_user_oldbutton(id) & IN_ATTACK2) && is_user_alive(id) && !(get_user_button(id) & IN_DUCK)) 
	{			
		if (on_knife[id])
		{
			if(ofiara_totem_enta[id] > floatround(halflife_time())){
				set_hudmessage(255, 0, 0, -1.0, 0.01)
				show_hudmessage(id, "Jestes uziemiony")
				return PLUGIN_HANDLED
			}
			if(czas_rundy + 5 > floatround(halflife_time())){
				set_hudmessage(255, 0, 0, -1.0, 0.01)
				show_hudmessage(id, "Teleportu mozesz uzywac 5 sek po starcie rundy")
				return PLUGIN_HANDLED
			}
			new szMapName[32]
			get_mapname(szMapName, 31)
			if (halflife_time()-player_b_blink[id] <= 3 || equal(szMapName, "awp_india") || equal(szMapName, "aim_aztec") || equal(szMapName, "awp_hunter") || equal(szMapName, "aim_knights")) return PLUGIN_HANDLED		
			player_b_blink[id] = floatround(halflife_time())	
			UTIL_Teleport(id,300+15*player_intelligence[id])			
		}
	}
	return PLUGIN_CONTINUE
}

public Prethink_Blink2(id)
{
	
	if( get_user_button(id) & IN_ATTACK2 && !(get_user_oldbutton(id) & IN_ATTACK2) && is_user_alive(id) && !(get_user_button(id) & IN_DUCK)) 
	{			
		if (on_knife[id] && player_class[id]!=Gon && player_class[id]!=Zmij)
		{
			if(ofiara_totem_enta[id] > floatround(halflife_time())){
				set_hudmessage(255, 0, 0, -1.0, 0.01)
				show_hudmessage(id, "Jestes uziemiony")
				if(halflife_time()-player_b_blink2[id] > 20){
					if(player_b_explode[id]>0 && player_b_blink2[id] >0){
						add_bonus_explode(id)
						player_b_blink2[id] = floatround(halflife_time())
						player_b_blink3[id] = 1
					}
				}
				return PLUGIN_HANDLED
			}
			new szMapName[32]
			get_mapname(szMapName, 31)
			if (halflife_time()-player_b_blink2[id] <= 20){
				if (halflife_time()-player_b_blink2[id] > 10 || player_b_blink3[id] !=2 ){
					return PLUGIN_HANDLED	
				}
				
				set_pev(id,pev_origin,blink_origin[id])
				if(player_b_blink3[id]>0)player_b_blink3[id] = 1
				return PLUGIN_CONTINUE	
			}
			player_b_blink2[id] = floatround(halflife_time())
			if(player_b_blink4[id]>0){
				player_b_blink4[id] = 2
				set_renderchange(id)
				set_task(10.0, "set_renderchange",id)
				set_task(10.2, "set_renderchange",id)
				set_task(11.0, "set_renderchange",id)
			}			
			
			if(player_b_blink3[id]>0){
				player_b_blink3[id] = 2
				pev(id,pev_origin,blink_origin[id])
			}
			
			UTIL_Teleport(id,300+15*player_intelligence[id])	
			if(player_b_explode[id]>0 && player_b_blink2[id] >0)add_bonus_explode(id)
		}
		if (on_knife[id] && player_class[id]==Zmij)
		{
			if(ofiara_totem_enta[id] > floatround(halflife_time())){
				set_hudmessage(255, 0, 0, -1.0, 0.01)
				show_hudmessage(id, "Jestes uziemiony")
				if(halflife_time()-player_naladowany[id] > 20){
					add_bonus_explode_zmij(id)
					player_naladowany[id] = floatround(halflife_time())
					player_naladowany2[id] = 1
				}
				return PLUGIN_HANDLED
			}
			new szMapName[32]
			get_mapname(szMapName, 31)
			if (halflife_time()-player_naladowany[id] <= 20){
				if (halflife_time()-player_naladowany[id] > 10 || player_naladowany2[id] !=2 ){
					return PLUGIN_HANDLED	
				}
				add_bonus_explode_zmij(id)
				set_pev(id,pev_origin,blink_origin[id])
				if(player_naladowany2[id]>0)player_naladowany2[id] = 1
				return PLUGIN_CONTINUE	
			}
			player_naladowany[id] = floatround(halflife_time())
			
			
			
			player_naladowany2[id] = 2
			pev(id,pev_origin,blink_origin[id])
			
			
			//UTIL_Teleport(id,300+15*player_intelligence[id])	
			new flags = pev(id,pev_flags) 
			if(flags & FL_ONGROUND) 
			{ 
				set_pev ( id, pev_flags, flags-FL_ONGROUND ) 
			}

			if(ofiara_totem_enta[id] > floatround(halflife_time())){
				set_hudmessage(255, 0, 0, -1.0, 0.01)
				show_hudmessage(id, "Jestes uziemiony")
			}else 
			{ 
				if(czas_rundy + 10 > floatround(halflife_time())){
					set_hudmessage(255, 0, 0, -1.0, 0.01)
					show_hudmessage(id, "Skilla mozesz uzywac 10 sek po starcie rundy")						
					return PLUGIN_HANDLED
				}
				
				jumps[id] = 0
				
				new Float:va[3],Float:v[3] 
				entity_get_vector(id,EV_VEC_v_angle,va) 
				v[0]=floatcos(va[1]/180.0*M_PI)*700.0 
				v[1]=floatsin(va[1]/180.0*M_PI)*700.0 
				v[2]=300.0 
				entity_set_vector(id,EV_VEC_velocity,v) 
				write_hud(id)
			}
			
		}
		if(player_class[id]==Gon){
			if(ofiara_totem_enta[id] > floatround(halflife_time())){
				set_hudmessage(255, 0, 0, -1.0, 0.01)
				show_hudmessage(id, "Jestes uziemiony")
				return PLUGIN_HANDLED
			}
			new szMapName[32]
			get_mapname(szMapName, 31)
			if (halflife_time()-player_naladowany[id] <= 20){
				if (halflife_time()-player_naladowany[id] > 10 ){
					return PLUGIN_HANDLED	
				}
				
				
				return PLUGIN_CONTINUE	
			}
			player_naladowany[id] = floatround(halflife_time())
			
			player_b_blink4[id] = 2
			set_renderchange(id)
			set_task(10.0, "set_renderchange",id)
			set_task(10.2, "set_renderchange",id)
			set_task(11.0, "set_renderchange",id)
			
			new flags = pev(id,pev_flags) 
			if(flags & FL_ONGROUND) 
			{ 
				set_pev ( id, pev_flags, flags-FL_ONGROUND ) 
			}
			
			if(ofiara_totem_enta[id] > floatround(halflife_time())){
				set_hudmessage(255, 0, 0, -1.0, 0.01)
				show_hudmessage(id, "Jestes uziemiony")
			}else 
			{ 
				if(czas_rundy + 10 > floatround(halflife_time())){
					set_hudmessage(255, 0, 0, -1.0, 0.01)
					show_hudmessage(id, "Skilla mozesz uzywac 10 sek po starcie rundy")						
					return PLUGIN_HANDLED
				}
				
				jumps[id] = 0
				
				new Float:va[3],Float:v[3] 
				entity_get_vector(id,EV_VEC_v_angle,va) 
				v[0]=floatcos(va[1]/180.0*M_PI)*700.0 
				v[1]=floatsin(va[1]/180.0*M_PI)*700.0 
				v[2]=300.0 
				entity_set_vector(id,EV_VEC_velocity,v) 
				write_hud(id) 
			} 
			//UTIL_Teleport(id,300+15*player_intelligence[id])	
		}
	}
	return PLUGIN_CONTINUE
}

public add_bonus_explode_zmij(id)
{
	new expl =0
	expl = 300
	
	if (expl > 10)
	{
		
		new origin[3] 
		get_user_origin(id,origin) 
		explode(origin,id,0)
		
		
		for(new a = 0; a < MAX; a++) 
		{ 
			if (!is_user_connected(a) || !is_user_alive(a) || player_b_fireshield[a] != 0 ||  get_user_team(a) == get_user_team(id))
				continue	
			
			new origin1[3]
			get_user_origin(a,origin1) 
			
			if(get_distance(origin,origin1) < expl + player_intelligence[id])
			{
				new dam = 25-(player_dextery[a]* 4) + player_strength[a]*2 + player_intelligence[id]/10
				if(dam<10) dam=10
				change_health(a,-dam,id,"grenade")
				Display_Fade(id,2600,2600,0,255,0,0,15)				
			}
		}
	}
}


/* ==================================================================================================== */

/*
Called on end or mapchange -- Save items for players
public plugin_end() 
{
	new Datafile[64], amxbasedir[64]
	//build_path(Datafile,63,"$basedir/diablo/datafile.txt") 
	
	get_basedir(amxbasedir,63)
	format(Datafile,63,"%s/diablo/datafile.txt",amxbasedir)
	
	if(file_exists(Datafile)) delete_file(Datafile)
	
	//Write name and item for each player
	for (new i=0; i < MAX; i++)
	{
		if (player_dc_item[i] > 0 && player_dc_item[i] != 100) //unique
		{
			new data[100]
			format(data,99,"%s^"%i^"",player_dc_name[i],player_dc_item[i])
			write_file(Datafile,data)
		}
	}
}
*/

/* ==================================================================================================== */

/* ==================================================================================================== */

public item_convertmoney(id)
{
	new maxhealth = race_heal[player_class[id]]+player_strength[id]*2
	
	if (cs_get_user_money(id) < 1000)
		hudmsg(id,2.0,"Nie masz wystarczajacej ilosci zlota, zeby zamienic je w zycie")
	else if (get_user_health(id) == maxhealth)
		hudmsg(id,2.0,"Masz maksymalna ilosc zycia")
	else
	{
		cs_set_user_money(id,cs_get_user_money(id)-1000)
		change_health(id,15,0,"")			
		Display_Fade(id,2600,2600,0,0,255,0,15)
	}
}

public item_windwalk(id)
{
	//First time this round
	if (player_b_usingwind[id] == 0)
	{
		new szId[10]
		num_to_str(id,szId,9)
		player_b_usingwind[id] = 1
		
		set_renderchange(id)
		
		engclient_cmd(id,"weapon_knife") 
		on_knife[id]=1
		set_user_maxspeed(id,500.0)
		
		new Float:val = player_b_windwalk[id] + 0.0
		set_task(val,"resetwindwalk",0,szId,32) 
		
		message_begin( MSG_ONE, gmsgBartimer, {0,0,0}, id ) 
		write_byte( player_b_windwalk[id]) 
		write_byte( 0 ) 
		message_end() 
	}
	
	//Disable again
	else if (player_b_usingwind[id] == 1)
	{
		player_b_usingwind[id] = 2
		
		set_renderchange(id)
		
		set_user_maxspeed(id,270.0)
		message_begin( MSG_ONE, gmsgBartimer, {0,0,0}, id ) 
		write_byte( 0) 
		write_byte( 0 ) 
		message_end() 
	}
	
	//Already used
	else if (player_b_usingwind[id] == 2)
	{
		set_hudmessage(220, 30, 30, -1.0, 0.40, 0, 3.0, 2.0, 0.2, 0.3, 5)
		show_hudmessage(id, "Ten przedmiot mozesz uzyc raz na runde!") 
	}
	
}

public resetwindwalk(szId[])
{
	new id = str_to_num(szId)
	if(!is_user_connected(id)) return
	if (id < 0 || id > MAX)
	{
		log_amx("Error in resetwindwalk, id: %i out of bounds", id)
	}
	
	if (player_b_usingwind[id] == 1 && is_user_alive(id))
	{
		player_b_usingwind[id] = 2
		
		set_renderchange(id)
		
		set_user_maxspeed(id,270.0)
		message_begin( MSG_ONE, gmsgBartimer, {0,0,0}, id ) 
		write_byte( 0) 
		write_byte( 0 ) 
		message_end() 
	}
	
}

/* ==================================================================================================== */

public Prethink_usingwind(id)
{
	
	if( get_user_button(id) & IN_ATTACK && is_user_alive(id))
	{
		new buttons = pev(id,pev_button)
		set_pev(id,pev_button,(buttons & ~IN_ATTACK));
		return FMRES_HANDLED;	
	}
	
	if( get_user_button(id) & IN_ATTACK2 && is_user_alive(id))
	{
		new buttons = pev(id,pev_button)
		set_pev(id,pev_button,(buttons & ~IN_ATTACK2));
		return FMRES_HANDLED;	
	}
	
	return PLUGIN_CONTINUE
}

/* ==================================================================================================== */

public cvar_result_func(id, const cvar[], const value[]) 
{ 
	player_b_oldsen[id] = str_to_float(value)
	new svIndex[32] 
	num_to_str(id,svIndex,32)
	set_task(2.5,"resetsens",0,svIndex,32) 		
	
	
}

public resetsens(svIndex[]) 
{ 
	new id = str_to_num(svIndex) 
	
	if (player_b_oldsen[id] > 0.0)
	{
		client_cmd(id,"sensitivity %f",player_b_oldsen[id])
		player_b_oldsen[id] = 0.0
	}
	
	message_begin( MSG_ONE, get_user_msgid("StatusIcon"), {0,0,0}, id ) 
	write_byte( 0 )     
	write_string( "dmg_chem") 
	write_byte( 100 ) // red 
	write_byte( 100 ) // green 
	write_byte( 100 ) // blue 
	message_end()  
	
	
} 


/* ==================================================================================================== */

public Prethink_confuseme(id)
{
	if (player_b_oldsen[id] > 0.0)
		client_cmd(id,"sensitivity %f", 25.0)
	
}

public Bot_Setup()
{
	for (new id=0; id < MAX; id++)
	{
		if (is_user_connected(id) && is_user_bot(id))
		{
			if (random_num(1,3) == 1 && player_item_id[id] > 0)
				client_cmd(id,"say /drop")
			
			while (player_point[id] > 0)
			{
				player_point[id]--
				switch(random_num(1,4))
				{
					case 1: {
						player_agility[id]++
					}
					case 2: {
						player_strength[id]++
					}
					case 3: {
						player_intelligence[id]++
					}
					case 4: {
						player_dextery[id]++
					}
				}
			}
		}
	}
}

/* ==================================================================================================== */

public host_killed(id)
{
	if (player_lvl[id] > 1)
	{
		hudmsg(id,2.0,"Straciles doswiadczenie za zabicie zakladnikow")
		Give_Xp(id,-floatround(3*player_lvl[id]/(1.65-player_lvl[id]/501)))
	}
	
}


/* ==================================================================================================== */
public show_menu_item(id)
{
	new text[513]
	
	formatex(text, 512, "\yNowe Itemy - ^n\w1. Mag ring^n\w2. ddyn ring^n\w3. Mnich ring^n\w4. Barbarzynca ring^n\w5. Zabojca ring^n\w6. Nekromanta ring^n\w7. Ninja ring^n\w8. Flashbang necklace^n\w9. Zamknij") 
	
	new keys 
	keys = (1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<4)|(1<<5)|(1<<6)|(1<<7)|(1<<8)
	show_menu(id, keys, text) 
	return PLUGIN_HANDLED  
} 

public nowe_itemy(id, key) 
{ 
	switch(key) 
	{ 
		case 0: 
		{	
			magring(id)
			
		}
		case 1: 
		{	
			paladynring(id)
		}
		case 2: 
		{	
			mnichring(id)
		}
		case 3:
		{
			barbarzyncaring(id)
		}
		case 4:
		{
			zabojcaring(id)
		}
		case 5:
		{
			nekromantaring(id)
		}
		case 6:
		{
			ninjaring(id)
		}
		case 7:
		{
			flashbangnecklace(id)
		}
		case 8:
		{
			return PLUGIN_HANDLED
		}
	}
	
	return PLUGIN_HANDLED
}
public magring(id)
{
	showitem(id,"Mag ring","Common","None","<br>Dostajesz +5 inteligencji.<br>Druga funcja: Mozesz wytworzyc ognista kule<br><br>")
}
public paladynring(id)
{
	showitem(id,"Paladyn ring","Common","None","<br>Redukuje normalne obrazenia i masz szanse na oslepienie gracza<br><br>")
}
public mnichring(id)
{
	showitem(id,"Mnich ring","Common","None","<br>Mozesz leczyc osoby z teamu, klasc totem ktory leczy cie i towje hp jest odnawiane co 5 sek<br><br>")
}
public barbarzyncaring(id)
{
	showitem(id,"Barbarzynca ring","Common","None","<br>Ten item dodaje ci +5 sily i jak zginiesz wybuchasz<br><br>")
}
public zabojcaring(id)
{
	showitem(id,"Zabojca ring","Common","None","<br>Dodaje ci +5 agility i mozesz zrobic podwojny skok<br><br>")
}
public nekromantaring(id)
{
	showitem(id,"Nekromanta ring","Common","None","<br>Mozesz ponownie odrodzic sie.<br>Dostajesz vampiric obraznia<br><br>")
}
public ninjaring(id)
{
	showitem(id,"Ninja ring","Common","None","<br>Mozesz teleportowac sie co 3 sekundy jesli uzyjesz prawego ataku noza.<br>Druga funkcja : kucnij aby zrobic dlugi skok<br><br>")
}
public flashbangnecklace(id)
{
	showitem(id,"Flashbang necklece","Common","None","<br>Flashbangi na ciebie nie dzialaja<br><br>")
}

/* ==================================================================================================== */


public showmenu(id)
{
	new text[513] 
	new keys = (1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<4)|(1<<5)|(1<<6)|(1<<7)|(1<<8)|(1<<9)
	
	
	formatex(text, 512, "\yOpcje - ^n\w1. Informacje o przedmiocie^n\w2. Upusc obecny przedmiot $50^n\w3. Pokaz pomoc^n\w4. Poznaj klasy^n\w5. Kup Rune^n\w6. Informacje o statystykach^n\w7. Twoja postac^n\w8. Serwery^n\w9. Kupno slota expa i konta Vip^n^n\w0. Zamknij") 
	
	show_menu(id, keys, text) 
	return PLUGIN_HANDLED  
} 


public option_menu(id, key) 
{ 
	switch(key) 
	{ 
		case 0: 
		{	
			iteminfo(id)
			
		}
		case 1: 
		{	
			dropitem(id)
			cs_set_user_money(id,cs_get_user_money(id)-50)
		}
		case 2: 
		{	
			helpme(id)
		}
		case 3:
		{
			client_cmd(id," say /klasy ");
		}
		case 4:
		{
			buyrune(id)
		}
		case 5:
		{
			showskills(id)
		}
		case 6:
		{
			postac(id)
		}
		case 7:
		{
			client_cmd(id," say /server ");
		}
		case 8:
		{
			client_cmd(id," say /kup ");
		}
		case 9:
		{
			return PLUGIN_HANDLED
		}
	}
	
	return PLUGIN_HANDLED
}

public Prethink_froglegs(id)
{
	if (get_user_button(id) & IN_DUCK)
	{
		//start holding down button here, set to halflife time
		if (player_b_froglegs[id] == 1) 
		{
			player_b_froglegs[id] = floatround(halflife_time())
		}
		else
		{
			if (floatround(halflife_time())-player_b_froglegs[id] >= 2.0)
			{
				new Float:fl_iNewVelocity[3]
				VelocityByAim(id, 1000, fl_iNewVelocity)
				fl_iNewVelocity[2] = 210.0
				entity_set_vector(id, EV_VEC_velocity, fl_iNewVelocity)
				player_b_froglegs[id] = 1
			}
		}
	}
	else
	{
		player_b_froglegs[id] = 1
	}
}


/* ==================================================================================================== */
new top15[15][64];
new top15LVL[15];
new top15_loaded = 0


public select_MYRANK_query(id)
{
	if(is_user_bot(id)) return PLUGIN_HANDLED

	if(get_timeleft() < 60) return PLUGIN_HANDLED
	if(player_class[id] == 0 || player_lvl[id]<2 ){
		client_print(id,print_chat, "Najpierw wybierz klase ")
		return PLUGIN_CONTINUE
	}
	if(myRank [id]> -1){
		client_print(id,print_chat, "Twoj ranking %s wynosi %i na 1 000 000 ", Race[player_class[id]], myRank [id])
		return PLUGIN_CONTINUE
	}
	
	if(g_boolsqlOK)
	{
		new name[64]
		new data[1]
		data[0] = id
		get_user_ip(id, name ,63,1)
		new q_command[512]
		formatex(q_command,511,"SELECT count(`nick`) as count FROM `dbmod_tablet` WHERE `lvl`> '%d' AND `klasa` = '%d'", player_lvl[id], player_class[id])
		SQL_ThreadQuery(g_SqlTuple,"select_MYRANK_handle",q_command,data,1)

	}
	else sql_start()
	return PLUGIN_HANDLED  
} 


public select_MYRANK_handle(FailState,Handle:Query,Error[],Errcode,Data[],DataSize)
{
	new id=Data[0]
	if(Errcode)
	{
		log_to_file("addons/amxmodx/logs/diablo.log","Error on select_class_handle query: %s",Error)
	}
	if(FailState == TQUERY_CONNECT_FAILED)
	{
		log_to_file("addons/amxmodx/logs/diablo.log","Could not connect to SQL database.")
		return PLUGIN_CONTINUE
	}
	else if(FailState == TQUERY_QUERY_FAILED)
	{
	
		log_to_file("addons/amxmodx/logs/diablo.log","select_class_handle Query failed.")
		return PLUGIN_CONTINUE
	}               
	if(SQL_MoreResults(Query))
	{
		myRank [id] = SQL_ReadResult(Query, SQL_FieldNameToNum(Query, "count")) + 1
		client_print(id,print_chat, "Twoj ranking %s wynosi %i na 2 000 000 ", Race[player_class[id]],  myRank [id])
	}
	return PLUGIN_CONTINUE
}



public select_RANK_query(id)
{
        if(is_user_bot(id) ) return PLUGIN_HANDLED

        if(get_timeleft() < 60) return PLUGIN_HANDLED
	if(top15_loaded == 1){
		new itemEffect[500]
		for(new j = 0 ; j<15;j++){
			new TempSkill[21]
			num_to_str(top15LVL[j],TempSkill,10)
			add(itemEffect,499,TempSkill)
			
			add(itemEffect,499," - ")
			add(itemEffect,499,top15[j])

			add(itemEffect,499," <br>")
		}
		showitem_top(id,"","",itemEffect)
		return PLUGIN_CONTINUE
	}
	
        if(g_boolsqlOK)
        {
                new name[64]
                new data[1]
                data[0] = id

                get_user_ip(id, name ,63,1)
                new q_command[512]
                formatex(q_command,511,"SELECT `nick`, sum(`lvl`) as lvl FROM `dbmod_tablet` WHERE `lvl` >25 GROUP BY `nick` ORDER BY sum(`lvl`) DESC LIMIT 15  ")
                SQL_ThreadQuery(g_SqlTuple,"select_RANK_handle",q_command,data,1)

        }
        else sql_start()
        
        return PLUGIN_HANDLED  
} 


public select_RANK_handle(FailState,Handle:Query,Error[],Errcode,Data[],DataSize)
{
	new id=Data[0]
	if(Errcode)
	{
		log_to_file("addons/amxmodx/logs/diablo.log","Error on select_class_handle query: %s",Error)
	}
	if(FailState == TQUERY_CONNECT_FAILED)
	{
		log_to_file("addons/amxmodx/logs/diablo.log","Could not connect to SQL database.")
		return PLUGIN_CONTINUE
	}
	else if(FailState == TQUERY_QUERY_FAILED)
	{
	
		log_to_file("addons/amxmodx/logs/diablo.log","select_class_handle Query failed.")
		return PLUGIN_CONTINUE
	}               
	if(SQL_MoreResults(Query))
	{
		new itemEffect[500]
		new i = 0;
		while(SQL_MoreResults(Query))
		{
			SQL_ReadResult(Query,SQL_FieldNameToNum(Query,"nick"),top15[i],63)
			top15LVL[i] = SQL_ReadResult(Query, SQL_FieldNameToNum(Query, "lvl"))
			new TempSkill[21]
			num_to_str(top15LVL[i],TempSkill,10)
			add(itemEffect,499,TempSkill)
			
			add(itemEffect,499," - ")
			add(itemEffect,499,top15[i])

			add(itemEffect,499," <br>")
			SQL_NextRow(Query)
			top15_loaded = 1
			i++;
			if(i>14) break;
		}
		showitem_top(id,"","",itemEffect)
	}
	return PLUGIN_CONTINUE
}

public showitem_top(id, klasa[],rasa[],item[])
{
	new diabloDir[64]	
	
	new g_ItemFile[64]
	new amxbasedir[64]
	get_basedir(amxbasedir,63)
	
	formatex(diabloDir,63,"%s/diablo",amxbasedir)
	
	if (!dir_exists(diabloDir))
	{
		new errormsg[512]
		formatex(errormsg,511,"Blad: Folder %s/diablo nie mogl byc znaleziony. Prosze skopiowac ten folder z archiwum do folderu amxmodx",amxbasedir)
		show_motd(id, errormsg, "An error has occured")	
		return PLUGIN_HANDLED
	}
	
	
	formatex(g_ItemFile,63,"%s/diablo/klasa.txt",amxbasedir)
	if(file_exists(g_ItemFile))
		delete_file(g_ItemFile)
	
	new Data[768]
	
	//Header
	formatex(Data,767,"<html><head>")
	write_file(g_ItemFile,Data,-1)
	
	//Background
	formatex(Data,767,"<body align=center text=^"#FFFF00^" bgcolor=^"#000000^"><center>",Basepath)
	write_file(g_ItemFile,Data,-1)
	
	//Table stuff
	formatex(Data,767,"<table align=center border=^"0^" style=^"border-collapse: collapse^" width=^"100%s^"><tr>","^%")
	write_file(g_ItemFile,Data,-1)
	

	//item name
	formatex(Data,767,"<td width=^"0^" align=center><font color=^"#FFCC00^">%s</font><br></td>",item)
	write_file(g_ItemFile,Data,-1)

	
	//end
	formatex(Data,767,"</tr></table></center></body></html>")
	write_file(g_ItemFile,Data,-1)
	
	//show window with message
	show_motd(id, g_ItemFile, "Top15")
	
	return PLUGIN_HANDLED
	
}

/* ==================================================================================================== */


public select_class_query(id)
{
	if(is_user_bot(id)) return PLUGIN_HANDLED
	if(get_timeleft() < 180) return PLUGIN_HANDLED
	
	
	if(loaded_xp[id]==0)
	{
		load_xp(id)
		return PLUGIN_HANDLED
	}
	if(g_boolsqlOK)
	{
		asked_klass[id]=1
		new name[64]
		new data[1]
		data[0] = id
		dropitem(id)
		if(player_class_lvl_save[id]==0)
		{
			if(get_cvar_num("diablo_sql_save")==0)
			{
				get_user_name(id,name,63)
				replace_all ( name, 63, "'", "Q" )
				replace_all ( name, 63, "`", "Q" )
				new q_command[512]
				format(q_command,511,"SELECT `klasa`,`lvl`,`vip`, `SID_PASS`, `PASS_PASS`, `mute` FROM `%s` WHERE `nick`='%s' ",g_sqlTable,name)
				SQL_ThreadQuery(g_SqlTuple,"select_class_handle", q_command,data,1)
			}
			else if(get_cvar_num("diablo_sql_save")==1)
			{
				get_user_ip(id, name ,63,1)
				new q_command[512]
				format(q_command,511,"SELECT `klasa`,`lvl`,`vip` FROM `%s` WHERE `ip`='%s' ",g_sqlTable,name)
				SQL_ThreadQuery(g_SqlTuple,"select_class_handle",q_command,data,1)
			}
			else if(get_cvar_num("diablo_sql_save")==2)
			{
				get_user_authid(id, name ,63)
				new q_command[512]
				format(q_command,511,"SELECT `klasa`,`lvl`,`vip` FROM `%s` WHERE `sid`='%s' ",g_sqlTable,name)
				SQL_ThreadQuery(g_SqlTuple,"select_class_handle",q_command,data,1)
			}
		}
		else
		{
			//for(new i=1;i<sizeof(race_heal);i++) lx[i]=player_class_lvl[id][i]
			select_class(id)
		}   
	}
	else sql_start()
	return PLUGIN_HANDLED  
} 

public select_class_handle(FailState,Handle:Query,Error[],Errcode,Data[],DataSize)
{
	new id=Data[0]
	if(Errcode)
	{
		log_to_file("addons/amxmodx/logs/diablo.log","Error on select_class_handle query: %s",Error)
		asked_klass[id]=0
	}
	if(FailState == TQUERY_CONNECT_FAILED)
	{
		log_to_file("addons/amxmodx/logs/diablo.log","Could not connect to SQL database.")
		asked_klass[id]=0
		return PLUGIN_CONTINUE
	}
	else if(FailState == TQUERY_QUERY_FAILED)
	{
		asked_klass[id]=0
		log_to_file("addons/amxmodx/logs/diablo.log","select_class_handle Query failed.")
		return PLUGIN_CONTINUE
	}               
	highlvl[id]=0 
	if(SQL_MoreResults(Query))
	{
		while(SQL_MoreResults(Query))
		{
			new i = SQL_ReadResult(Query, SQL_FieldNameToNum(Query, "klasa"))
			player_class_lvl[id][i] = SQL_ReadResult(Query, SQL_FieldNameToNum(Query, "lvl"))
			if(player_class_lvl[id][i]>100 ){
				highlvl[id] += 100
			}
			if(i==1){
				if(player_vip[id]==0) player_vip[id] = SQL_ReadResult(Query,SQL_FieldNameToNum(Query,"vip"))	
				SQL_ReadResult(Query, SQL_FieldNameToNum(Query,"SID_PASS"), player_sid_pass[id], 63)	
				SQL_ReadResult(Query, SQL_FieldNameToNum(Query,"PASS_PASS"), player_pass_pass[id], 63)	
				authorize(id)
				if(player_mute[id]==0){ 
					
					SQL_ReadResult(Query, SQL_FieldNameToNum(Query,"mute"), date_long[id], 63)
					if(!equal(date_long[id], "")){					
						new name[64]
						get_user_name(id,name,63)
						
						player_mute[id] = parse_time(date_long[id], "%Y/%m/%d");	
						//log_to_file("addons/amxmodx/logs/diablomute.log"," Gracz %s Data %s Timestamp %i", name, date_long[id], player_mute[id])
						
						if(player_mute[id] > get_systime()){
							player_mute[id] = 1
							server_cmd( "amx_mute ^"%s^"", name);
							client_print(id, print_chat, "Mowienie zablokowane do dnia %s, przekroczyles liczbe banow za obraze", date_long[id])
						}else{
							player_mute[id] = 0
						}
						//log_to_file("addons/amxmodx/logs/diablomute.log"," Gracz %s Czy ma mute %i", name, player_mute[id])
					}
				}
			}
			SQL_NextRow(Query)
		}
		if(asked_klass[id]==1)
		{
			asked_klass[id]=2
			select_class(id)
		}                
	}
	return PLUGIN_CONTINUE
}


public authorize(id){
	if(player_sid_pass[id][0]) {
		new sid_[64]
		new nick_[64]
		get_user_name(id,nick_,63)
		get_user_authid(id, sid_ ,63)
		if(!equal(player_sid_pass[id], sid_)){
			client_print(id,print_chat, "Do tego nicku przypisany jest SID: SID nieprawidlowy")
			client_print(id,print_chat, "Twoj %s - Konta %s", sid_, player_sid_pass[id])
			new text2[513] 
			formatex(text2, 512, "kick ^"%s^" ^"To konto ma przypisany SID %s inny niz Twoj^"",nick_, player_sid_pass[id])
			server_cmd(text2);
		}else{
			client_print(id,print_chat, "Do tego nicku przypisany jest SID: SID prawidlowy")
		}
	}
	if(player_pass_pass[id][0]) {
		new nick_[64]
		new password_[34]
		new password2_[34]
		new password3_[34]
		
		get_user_info(id,"_res",password_,34)
		get_user_info(id,"res",password3_,34)
		get_user_info(id,"_pw",password2_,34)
		
		md5(password_, password_)
		md5(password3_, password3_)
		md5(password2_, password2_)
		
		if(equal("", password_)) password_ = "_";
		if(equal("", password2_)) password2_ = "_";
		if(equal("", password3_)) password3_ = "_";
		
		get_user_name(id,nick_,63)

		if(
		!equal(player_pass_pass[id], password_) &&
		!equal(player_pass_pass[id], password2_) &&
		!equal(player_pass_pass[id], password3_) &&
		!equal(player_podany_pass_pass[id], player_pass_pass[id]) 		 
		){	
			client_print(id, print_console, "%s, %s, %s, %s, %s", player_podany_pass_pass[id], player_pass_pass[id], password_, password2_, password3_)
			pr_pass_pass[id]++
			if(pr_pass_pass[id]>3){
				new text2[513] 
				formatex(text2, 512, "kick ^"%s^" ^"Do tego nicku przypisane jest haslo: nieprawidlowe, wpisz w konsole: setinfo _res haslo^"",nick_)
				server_cmd(text2);
			}
			Display_Fade(id,seconds(120),seconds(120),0,0,0,0,255)
			server_cmd( "amx_mute %s", nick_);			
			user_kill(id,1)
			client_print(id,print_chat, "Do tego nicku przypisane jest haslo: haslo nieprawidlowe")
			client_print(id,print_chat, "Podaj haslo, lub wpisz w konsole: setinfo _res haslo")
			client_cmd(id, "messagemode ^"Podaj_haslo^"")
			
		}else{
			pr_pass_pass[id]=-1
			client_print(id,print_chat, "Do tego nicku przypisane jest haslo: haslo prawidlowe")
			Display_Fade(id,1,1,0,0,150,0,5)
			server_cmd( "amx_unmute %s", nick_);
			pr_pass_pass[id]=-1
		}
	}
}

public Podaj_haslo (id){
	read_args(player_podany_pass_pass[id],34)
	
	replace_all ( player_podany_pass_pass[id], 34, "'", "" )
	replace_all ( player_podany_pass_pass[id], 34, "`", "" )
	replace_all ( player_podany_pass_pass[id], 34, "^"", "" )
	client_print(id, print_chat, "Wpisz w konsole swoje haslo:")
	client_print(id, print_chat, "setinfo ^"_res^" ^"%s^"", player_podany_pass_pass[id])
	client_cmd(id, "setinfo ^"_res^" ^"%s^"", player_podany_pass_pass[id])
	md5(player_podany_pass_pass[id], player_podany_pass_pass[id])
	authorize(id)
}


public select_class(id){

	if(is_user_bot(id)) return
	create_class = menu_create("Wybierz Klase", "handle_create_class")
	ghandle_create_class = menu_makecallback("mcb_create_class")
	menu_setprop(create_class,1, 6 )
	
	
	for(new i=1;i<sizeof(race_heal);i++){
		new menu_txt[128]
		
		if(player_class_lvl[id][i] <prorasa){
			formatex(menu_txt,127,"%s: %s[%i], lvl: %d",Rasa[i],Race[i], KlasyZlicz[i] ,player_class_lvl[id][i])
		} else {
			formatex(menu_txt,127,"%s: %s[%i], lvl: %d",Rasa[i],ProRace[i], KlasyZlicz[i] ,player_class_lvl[id][i])			
		} 
		
		if(i<25) menu_additem(create_class, menu_txt, "", ADMIN_ALL, ghandle_create_class)
		else if(i<29) menu_additem(create_class, menu_txt, "", ADMIN_ALL, ITEM_ENABLED)
		
	}
	menu_display(id,create_class,0)
}

public mcb_create_class(id, menu, item) {
	new szMapName[32]
	get_mapname(szMapName, 31)
	
	new flags[64]
	//"abcdef ghijkl mnoqr stu yz"

	
	
	if((get_user_flags(id) & ADMIN_LEVEL_C) || player_vip[id]==1 || (get_user_flags(id) & ADMIN_LEVEL_D) || player_vip[id]==2){
		get_cvar_string("diablo_classes_vip",flags,64)				
	} 
	else {
		get_cvar_string("diablo_classes",flags,64)
	}
	
	//flags = "yz
	
	
	new keys = read_flags(flags)
	
	if(keys&(1<<item))
		return ITEM_ENABLED
	
	return ITEM_DISABLED
}
public handle_create_class(id, menu, item){
	
	g_haskit[id] = 0
	
	if(item==MENU_EXIT){
		
		//menu_destroy(create_class)
		//select_class(id)
		return PLUGIN_HANDLED
	}
	if(pr_pass_pass[id] > 0 ) return PLUGIN_HANDLED    	
	
	player_class[id]=++item
	KlasyZlicz[player_class[id]]++
	
	if(player_class[id]==Nekromanta || player_class[id]==Ghull) g_haskit[id] = 1
	
	
	if(player_class[id]==Kusznik ||player_class[id]==Lucznik ) g_GrenadeTrap[id] = 1 
	LoadXP(id, player_class[id])
	CurWeapon(id)
	
	give_knife(id)
	return PLUGIN_CONTINUE
}
public after_spawn(id)
{
	recalc_lvl_dif_xp_mnoznik(id)
	set_task(1.0, "xp_mnoznik_wylicz", id)
	set_task(10.0, "xp_mnoznik_wylicz", id)
	dexteryDamRedCalc(id)
	if(is_user_connected(id) && is_user_alive(id)){
		new i = id
		player_samelvl[id] = 0;
		for(new i=1;i<sizeof(race_heal);i++){
			if((player_lvl[id] - 25 < player_class_lvl[id][i]) && (player_lvl[id] + 25 > player_class_lvl[id][i]))
			{
				player_samelvl[id]++
			}
		}
		player_samelvl[id]= player_samelvl[id]-4
		if(player_samelvl[id] <0) player_samelvl[id] = 0
		player_b_szarza_time[i]=0
		set_user_noclip(id,0)		
		player_timed_speed[i]=halflife_time()
		player_timed_inv[i]=halflife_time()
		player_timed_speed_aim[i]=halflife_time()
		if(player_class[i] == Gon) player_b_blink4[i]=1
		if(player_class[i] == Nekromanta) g_haskit[i]=1
		if(player_class[i] == Ghull) g_haskit[i]=1
		if(player_class[i] == Heretyk) g_haskit[i]=1	
		bowdelay[i]=get_gametime()-30
		//run_models(i)
		num_shild[i]=2+floatround(player_intelligence[i]/25.0,floatround_floor)
		if(player_class[id]==Heretyk && is_user_connected(id)) {
			fm_give_item(id, "weapon_elite")
			give_item(id, "ammo_9mm")
			give_item(id, "ammo_9mm")
			give_item(id, "ammo_9mm")
		}
		if(player_class[id]==Strzelec && is_user_connected(id)) {
			fm_give_item(id, "weapon_deagle")
			fm_give_item(id, "ammo_50ae" );
			fm_give_item(id, "ammo_50ae" );
			fm_give_item(id, "ammo_50ae" ); 
		}
		if(player_class[id]==Drzewiec && is_user_connected(id)) {
			
			fm_give_item(id, "weapon_m3")
			give_item(id, "ammo_buckshot")
			give_item(id, "ammo_buckshot")
			give_item(id, "ammo_buckshot")
		}
		if(player_class[id]==Mroczny && is_user_connected(id)) {
			
			fm_give_item(id, "weapon_xm1014")
			give_item(id, "ammo_buckshot")
			give_item(id, "ammo_buckshot")
			give_item(id, "ammo_buckshot")
		}
		if(player_b_m3[id]>0){
			fm_give_item(id, "weapon_m3")
			give_item(id, "ammo_buckshot")
			give_item(id, "ammo_buckshot")
			give_item(id, "ammo_buckshot")
		}
		if(player_tmp[id]>0 || player_class[id]==Zmij){
			fm_give_item(id, "weapon_tmp")
			fm_give_item(id, "ammo_9mm" );
			fm_give_item(id, "ammo_9mm" );
			fm_give_item(id, "ammo_9mm" ); 
		}
		if( player_class[id]==Ognik){
			give_item(id, "weapon_smokegrenade");
			player_naladowany2[id]=0			
		}
		skill_time[id]=0
		if(player_lustro[id]>0) player_lustro[id]=1
		skam[id]=0
		player_timed_mr[id] = 0.0
		player_timed_shield[id] = 0.0
		if(player_awpk[id]>0 && is_user_connected(id) ) give_item(id, "weapon_awp");
		if(player_b_sniper[i]>0) fm_give_item(i, "weapon_scout") 	
		if(player_b_grenade[i]>0) fm_give_item(id, "weapon_hegrenade")
		set_user_health(id,get_maxhp(id))
		set_gravitychange(id)
		set_renderchange(id)
		set_speedchange(id)
		set_task(1.0,"set_speedchange", id)
		
		bonus_pro(id)
		
		RemoveFlag(id,Flag_truc)
		//fm_give_item(id, "weapon_knife")
		if(player_healer[id] >0 ) player_healer_c[id] = 11
		ofiara_totem_lodu[id]=0
		ofiara_totem_enta[id]=0
		last_attacker[id] = 0
		if(u_sid[id] > 0){
			cs_set_user_money(i,cs_get_user_money(i)+STEAMMONEY)
		}
		if(get_user_flags(id) & ADMIN_LEVEL_D || player_vip[id]==2){
			if (is_user_alive(id)) cs_set_user_money(id,cs_get_user_money(id)+VIPPROMONEY)
		}
		if(player_vip[id]==3){
			if (is_user_alive(id)) cs_set_user_money(id,cs_get_user_money(id)+XPBOOSTMONEY)
		}
		LvlInfo(id)
		if(KlasyZlicz[player_class[id]]==1)		
		{
			if (is_user_alive(id)) cs_set_user_money(id,cs_get_user_money(id)+100)		
		}
		if(player_class[id] == Demon && demonLastHp[id] > 0) set_user_health(id, demonLastHp[id])
	}
}

public LvlInfo(id){
		//new lvl_diff = moreLvl2(player_lvl[id],0)
		if(avg_lvl > 10){
			client_print(id, print_chat, "Aktualny sredni lvl na serwerze to: %i, TT %i [%i], CT %i [%i]", avg_lvl, avg_lvlTT, sum_lvlTT, avg_lvlCT, sum_lvlCT);
			/*
			if( diablo_redirect == 2 || diablo_redirect == 1 ){
				if(player_lvl[id] > 50  && player_lvl[id] > 10){
					client_print(id, print_chat, "Na serwerze gra sie DO 50 lvl. Twoj lvl jest wiekszy. Mozesz zostac automatycznie przeniesiony. Komenda /przenies");
				}
			}
			if( diablo_redirect == 3 ||  diablo_redirect == 4){
				if(player_lvl[id] < 50  && player_lvl[id] > 10){
					client_print(id, print_chat, "Na serwerze gra sie OD 50 lvl. Twoj lvl jest mniejszy. Mozesz zostac automatycznie przeniesiony. Komenda /przenies");
				}
			}
			*/
		}
}

/* ==================================================================================================== */
public check_class()
{
	clEvent = 0;
	clEvent1 = 0;
	clEvent2 = 0;
	new szMapName[32]
	get_mapname(szMapName, 31)
	diablo_redirect  = get_cvar_num("diablo_redirect") 
	ct_drut = 0
	t_drut = 0
	for (new kl=0; kl < 50; kl++){
		KlasyZlicz[kl] =0
	}
	for (new id=0; id < 33; id++)
	{
		ducking_t[id]=0
		was_ducking[id]=0
		if(player_class[id]!=0){
			Give_Xp(id, 1);
			Give_Xp(id, 1);
			Give_Xp(id, 1);
			Give_Xp(id, 1);
		}
		
		if(highlvl[id] > 0 || player_lvl[id] > 100 ){
			if(!player_sid_pass[id][0] && !player_pass_pass[id][0])
				client_cmd(id, "/force_srn")
		}
		/*
		if(player_lvl[id] > 175 && u_sid[id] == 0)
		{
			user_kill(id)
			set_hudmessage(220, 30, 30, -1.0, 0.40, 0, 3.0, 2.0, 0.2, 0.3, 5)
			show_hudmessage(id, "STEAM JEST OBOWIAZKOWY OD 175 LVL") 
			client_print(id,print_chat, "STEAM JEST OBOWIAZKOWY OD 175 LVL")
			
		}*/
		if(u_sid[id] == 0 && get_playersnum()>22 && !(get_user_flags(id) & ADMIN_RESERVATION))
		{
				new name[64]
				get_user_name(id,name,63)

				new text2[513] 
				format(text2, 512, "kick ^"%s^" ^"Brak slota, gracz steam ma pierwszenstwo^"",name)
				server_cmd(text2);
		}
		if(is_valid_ent(id))
		{
			pev(id,pev_origin,glob_origin[id])
			pev(id,pev_origin,blink_origin[id])
		}
		diablo_redirect_check_low(id)
		diablo_redirect_check_high(id)
		player_nal[id]=0;
		if(get_user_armor(id) >100) set_user_armor(id,100);
		player_b_skill[id] = 5
		if(player_item_id[id]==176 ) player_b_skill[id] = 1
		if((player_class[id] == Ninja || player_class[id] == Samurai) && (is_user_connected(id)))
		{
			if(is_user_alive(id)&&(equal(szMapName, "awp_india") || equal(szMapName, "aim_aztec") || equal(szMapName, "awp_hunter"))){
				client_cmd(id,"kill");
				changerace(id);
				set_hudmessage(255, 0, 0, -1.0, 0.01)
				show_hudmessage(id, "KLASA ZABRONIONA NA TEJ MAPIE")
				
			} 
			if (is_user_alive(id)) set_user_armor(id,100)
		}
		bieg[id]=0
		if(player_item_id[id]!=66 && (is_user_connected(id)) && player_diablo[id]==0 && player_she[id]==0 && player_skin[id]==0) changeskin(id,1)
		player_diablo[id] = 0
		player_she[id] = 0
		player_naladowany[id] = 0
		player_naladowany2[id] = 0
		
		player_nal[id]=0;
		set_renderchange(id)
		if(player_class[id]==Druid && is_user_connected(id)) {
			if(cs_get_user_team(id) == CS_TEAM_CT) ct_drut = 1
			if(cs_get_user_team(id) == CS_TEAM_T) t_drut = 1
		}
		
		if(player_class[id]!= Heretyk)KlasyZlicz[player_class[id]]++;
		
		if(player_class[id] == Przywolywacz && player_class[id] > prorasa) player_b_nieust2[id] = 50
		
		if(is_user_connected(id)){
			old_team[id] = cs_get_user_team(id)
			client_cmd(id, "cl_forwardspeed 700");
		} 
		set_renderchange(id)
	}
	count_avg_lvl()
	
	for (new i=1; i < 30; i++){
		if(KlasyZlicz[i]>0){
			if(clEvent > 2){
				clEvent = 100
				break;
			}
			clEvent++;
			if(clEvent1 == 0) clEvent1 = i;
			else if(clEvent2 == 0) clEvent2 = i;
		}
	}
	
	for (new id=0; id < 33; id++)
	{
		after_spawn(id)
		if(get_playersnum()>10){
			if(!is_user_connected(id)) continue
			if(player_class[id] == 0) continue
			if(clEvent == 2)
			{
				if(tutOn && tutor[id]) tutorMake(id,TUTOR_GREEN,4.5,"+40%% exp za %s vs %s", Race[clEvent1], Race[clEvent2] )
			}else{
				new itemEffect[500] = ""
				new disp = 0
				/*
				if(popularnosc[id] == 3){

				}else if(popularnosc[id] == 2){
					add(itemEffect,499,"+10%% exp ")
				}else if(popularnosc[id] == 1){
					add(itemEffect,499,"+20%% exp ")
				}
				*/
				if(KlasyZlicz[player_class[id]]==1){
					award_item(id, 0)
					add(itemEffect,499,"+item +30%% exp +inne ")
					disp = 1
				}else if(KlasyZlicz[player_class[id]]==2){
					add(itemEffect,499,"+10%% exp ")
					disp = 1
				}else if(KlasyZlicz[player_class[id]]==3){

				}else if(KlasyZlicz[player_class[id]]>=4){
					add(itemEffect,499,"-10%%hp -30%% exp +inne")
					disp = 1
				}else if(KlasyZlicz[player_class[id]]>=6){	
					add(itemEffect,499,"-25%%hp -50%% exp +inne")
					disp = 1
				}
				if(disp == 1) add(itemEffect,499,"za klase ")
				
				if(u_sid[id] == 0 && player_lvl[id]> 100){
					add(itemEffect,499," -50%% exp za NS ")
					disp = 1
				}

				if(tutOn && tutor[id] && disp == 1) tutorMake(id,TUTOR_GREEN,4.5,itemEffect)
			}
		}
	}
}


/* ==================================================================================================== */

public add_barbarian_bonus(id)
{
	if (player_class[id] == Barbarzynca)
	{	
		change_health(id,20,0,"")
		refill_ammo(id)
		player_timed_speed[id] = halflife_time() + 5.3
		set_speedchange(id)
		set_task(5.5, "set_speedchange", id)
	}
}

/* ==================================================================================================== */

public add_bonus_necromancer(attacker_id,id)
{

	
}

/* ==================================================================================================== */

//What modules are required
public plugin_modules()
{
	require_module("engine")
	require_module("cstrike")
	require_module("fun")
	require_module("fakemeta")
}

/* ==================================================================================================== */

//Find the nearest alive opponent in our view
public UTIL_FindNearestOpponent(id,maxdist)
{
	new best = 99999
	new entfound = -1
	new MyOrigin[3]
	get_user_origin(id,MyOrigin)
	
	for (new i=1; i < MAX; i++)
	{
		if (i == id || !is_user_connected(i) || !is_user_alive(i) || get_user_team(id) == get_user_team(i))
			continue
		
		new TempOrigin[3],Float:fTempOrigin[3]
		get_user_origin(i,TempOrigin)
		IVecFVec(TempOrigin,fTempOrigin)
		
		if (!UTIL_IsInView(id,i))
			continue
		
		
		new dist = get_distance ( MyOrigin,TempOrigin ) 
		
		if ( dist < maxdist && dist < best)
		{
			best = dist
			entfound = i
		}		
	}
	
	return entfound
}

/* ==================================================================================================== */

//Basicly see's if we can draw a straight line to the target without interference
public bool:UTIL_IsInView(id,target)
{
	new Float:IdOrigin[3], Float:TargetOrigin[3], Float:ret[3] 
	new iIdOrigin[3], iTargetOrigin[3]
	
	get_user_origin(id,iIdOrigin,1)
	get_user_origin(target,iTargetOrigin,1)
	
	IVecFVec(iIdOrigin,IdOrigin)
	IVecFVec(iTargetOrigin, TargetOrigin)
	
	if ( trace_line ( 1, IdOrigin, TargetOrigin, ret ) == target)
		return true
	
	if ( get_distance_f(TargetOrigin,ret) < 10.0)
		return true
	
	return false
	
}
/* ==================================================================================================== */

public strumien(id, h0, h1, h2, r, g, b){
	
	//Create Lightning
	message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
	write_byte(1) // TE_BEAMENTPOINT
	write_short(id)
	write_coord(h0)
	write_coord(h1)
	write_coord(h2)
	write_short(sprite_lgt)
	write_byte(0)
	write_byte(1)
	write_byte(3)
	write_byte(10)	//WITD
	write_byte(60)
	write_byte(r)
	write_byte(g)
	write_byte(b)
	write_byte(100)	//BRIGT
	write_byte(0)
	message_end()
	
}

public item_dagon(id)
{
	if (player_b_dagfired[id])
	{
		set_hudmessage(220, 30, 30, -1.0, 0.40, 0, 3.0, 2.0, 0.2, 0.3, 5)
		show_hudmessage(id, "Tego przedmiotu mozesz uzyc raz na runde") 
		return PLUGIN_HANDLED
	}
	//Target nearest non-friendly player
	new target = UTIL_FindNearestOpponent(id,600+player_intelligence[id]*20)
	
	if (target == -1) 
		return PLUGIN_HANDLED
	
	new DagonDamage = player_b_dagon[id]*50
	
	//Dagon damage done is reduced by the targets dextery
	DagonDamage-=player_dextery[target]*2
	
	if (DagonDamage < 0)
		DagonDamage = 0
	
	new Hit[3]
	get_user_origin(target,Hit)
	
	//Create Lightning
	
	if (player_b_dagon[id] == 1){
		strumien(id, Hit[0], Hit[1], Hit[2], 150, 0, 0)
		strumien(id, Hit[0], Hit[1], Hit[2], 150, 0, 0)
	}
	else if (player_b_dagon[id] == 2){
		strumien(id, Hit[0], Hit[1], Hit[2], 255, 0, 0)
		strumien(id, Hit[0], Hit[1], Hit[2], 255, 0, 0)
		strumien(id, Hit[0], Hit[1], Hit[2], 255, 0, 0)
	}
	else if (player_b_dagon[id] > 2){
		strumien(id, Hit[0], Hit[1], Hit[2], 255, 0, 0)
		strumien(id, Hit[0], Hit[1], Hit[2], 255, 0, 0)
		strumien(id, Hit[0], Hit[1], Hit[2], 255, 0, 0)
		strumien(id, Hit[0], Hit[1], Hit[2], 255, 255, 255)
		strumien(id, Hit[0], Hit[1], Hit[2], 255, 255, 255)
		strumien(id, Hit[0], Hit[1], Hit[2], 255, 255, 255)
	}
	player_b_dagfired[id] = true
	
	//Apply damage
	
	change_health(target,-DagonDamage,id,"world")
	Display_Fade(target,2600,2600,0,255,0,0,15)
	hudmsg(id,2.0,"Twoje ciosy dagon przyjol %i, %i", DagonDamage, player_dextery[target]*2)
	
	return PLUGIN_HANDLED
	
	
}

/* ==================================================================================================== */

/* ==================================================================================================== */

//Will return 1 if user has amount of money and then substract
public bool:UTIL_Buyformoney(id,amount)
{
	if (cs_get_user_money(id) >= amount)
	{
		cs_set_user_money(id,cs_get_user_money(id)-amount)
		return true
	}
	else
	{
		hudmsg(id,2.0,"Nie masz tyle zlota")
		return false
	}
	
	return false
}
public buyrune(id)
{
	if(diablo_typ==3){
		hudmsg(id,2.0,"Menu wylaczone")
		return PLUGIN_HANDLED  
	}
	
	new text[513] 
	
	formatex(text, 512, "\ySklep z runami - ^n\w1. Upgrade [Moze ulepszyc item] - \r$9000^n\w Uwaga nie kazdy item sie da ulepszyc ^n\Slabe itemy latwo ulepszyc ^n\w4 Mocne itemy moga ulec uszkodzeniu ^n\w5. Przedmiot [Dostajesz losowy przedmiot] \r$5000^n\w6. Exp [Dostajesz doswiadczenia] \r$14500^n^n\w0. Zamknij") 
	
	new keys = (1<<0)|(1<<4)|(1<<5)|(1<<9)
	show_menu(id, keys, text) 
	return PLUGIN_HANDLED  
} 


public select_rune_menu(id, key) 
{ 
	new name[32]
	get_user_name(id,name,31)
	switch(key) 
	{ 
		case 0: 
		{
			if (!UTIL_Buyformoney(id,9000))
				return PLUGIN_HANDLED
				
			if (player_item_id[id] == 0)
				return PLUGIN_HANDLED
			upgrade_item(id)
		}
		
		case 4: 
		{	
			if (player_item_id[id] != 0)
				return PLUGIN_HANDLED
			if (!UTIL_Buyformoney(id,5000))
				return PLUGIN_HANDLED
			award_item(id,0)
			return PLUGIN_HANDLED
		}
		case 5:
		{
			if ((zal[id]>0) || (get_playersnum(0) < 5))
				return PLUGIN_HANDLED
			if (!UTIL_Buyformoney(id,14500))
				return PLUGIN_HANDLED
			new av = 0
			count_avg_lvl()
			if(cs_get_user_team(id) == CS_TEAM_T) av = avg_lvlCT
			if(cs_get_user_team(id) == CS_TEAM_CT) av = avg_lvlTT
			new exp = get_cvar_num("diablo_xpbonus")/2 + get_cvar_num("diablo_xpbonus") * moreLvl2(player_lvl[id], av) /250
			zal[id]++;
			if(exp>500) exp =500;
			if(exp<10) exp =10;
			Give_Xp(id,exp)
			player_wys[id]=1
			client_print(id,print_center,"dostales %d expa!",xp_mnoznik(id, exp))
			return PLUGIN_HANDLED
		}
		case 9: 
		{	
			return PLUGIN_HANDLED
		}
		
		
	}
	
	return PLUGIN_HANDLED
}

public upgrade_item(id)
{
	if(player_item_id[id] == 229){
		if(item_durability[id]>0) item_durability[id] += random_num(-50,150)
		return
	}
	if(player_smocze[id]>0) player_smocze[id] += random_num(0,5)
	if(item_durability[id]>0) item_durability[id] += random_num(-50,50)
	if(player_b_nieust[id] > 0 && player_b_nieust[id] < 90) player_b_nieust[id] +=  random_num(0,5)
	if(item_durability[id]<1)
	{
		
		dropitem(id)
		return
	}
	if(player_b_jumpx[id]>0) player_b_jumpx[id] += random_num(0,1)
	if(player_mrozu[id]>0) player_mrozu[id] += random_num(1,2)
	if(player_tmp[id]>0) player_tmp[id]++
	if(player_b_vampire[id]>1)
	{
		if(player_b_vampire[id]>20) player_b_vampire[id] += random_num(-1,2)
		else if(player_b_vampire[id]>10) player_b_vampire[id] += random_num(0,2)
			else player_b_vampire[id]+= random_num(1,3)
	}
	if(player_b_damage[id]>0) player_b_damage[id] += random_num(0,3) 
	if(player_udr[id]>0) player_udr[id] += random_num(1,2) 
	if(player_b_money[id]!=0 && player_b_money[id]<15000 ) player_b_money[id]+= random_num(-100,300)	
	if(player_b_gravity[id]>0)
	{
		if(player_b_gravity[id]<3) player_b_gravity[id]+=random_num(0,2)
		else if(player_b_gravity[id]<5) player_b_gravity[id]+=random_num(1,3)
			else if(player_b_gravity[id]<8) player_b_gravity[id]+=random_num(-1,3)
			else if(player_b_gravity[id]<10) player_b_gravity[id]+=random_num(0,1)
		}
	if(player_b_inv[id]>0)
	{
		if(player_b_inv[id]>200) player_b_inv[id]-=random_num(0,50)
		else if(player_b_inv[id]>100) player_b_inv[id]-=random_num(-25,50)
			else if(player_b_inv[id]>50) player_b_inv[id]-=random_num(-10,20)
			else if(player_b_inv[id]>25) player_b_inv[id]-=random_num(-10,10)
		}
	if(player_b_grenade[id]>0)
	{
		if(player_b_grenade[id]>4) player_b_grenade[id]-=random_num(0,2)
		else if(player_b_grenade[id]>2) player_b_grenade[id]-=random_num(0,1)
			else if(player_b_grenade[id]==2) player_b_grenade[id]-=random_num(-1,1)
		}
	if(player_b_reduceH[id]>0) player_b_reduceH[id]-=random_num(0,player_b_reduceH[id])
	if(player_b_theif[id]>0) player_b_theif[id] += random_num(0,250)
	if(player_b_respawn[id]>0)
	{
		if(player_b_respawn[id]>2) player_b_respawn[id]-=random_num(0,1)
		else if(player_b_respawn[id]>1) player_b_respawn[id]-=random_num(-1,1)
		}
	
	if(player_b_heal[id]>0)
	{
		if(player_b_heal[id]>20) player_b_heal[id]+= random_num(-1,3)
		else if(player_b_heal[id]>10) player_b_heal[id]+= random_num(0,4)
			else player_b_heal[id]+= random_num(2,6)
	}
	if(player_b_blind[id]>0)
	{
		if(player_b_blind[id]>5) player_b_blind[id]-= random_num(0,2)
		else if(player_b_blind[id]>1) player_b_blind[id]-= random_num(0,1)
		}
	if(player_pociski_powietrza[id]>0)
	{
		if(player_pociski_powietrza[id]>10) player_pociski_powietrza[id]-= random_num(0,5)
		else if(player_pociski_powietrza[id]>1) player_pociski_powietrza[id]-= random_num(0,1)
		}
	if( player_totem_powietrza_zasieg[id]>0)
	{
		player_totem_powietrza_zasieg[id]+= random_num(0,55)
		
	}	
	if(player_lodowe_pociski[id]>0)
	{
		if(player_lodowe_pociski[id]>5) player_lodowe_pociski[id]-= random_num(0,2)
		else if(player_lodowe_pociski[id]>1) player_lodowe_pociski[id]-= random_num(0,1)
		}	
	if(player_entowe_pociski[id]>0)
	{
		if(player_entowe_pociski[id]>5) player_entowe_pociski[id]-= random_num(0,2)
		else if(player_entowe_pociski[id]>1) player_entowe_pociski[id]-= random_num(0,1)
		}
	
	if(player_zombie_killer[id]>0 && player_zombie_killer[id] > 1)player_zombie_killer[id]--
	if(player_zombie_killer_magic[id]>0 && player_zombie_killer_magic[id] > 1)player_zombie_killer_magic[id]--
	if(player_b_teamheal[id]>0) player_b_teamheal[id] += random_num(0,5)
	
	if(player_b_redirect[id]>0) player_b_redirect[id]+= random_num(0,2)
	if(player_b_fireball[id]>0) player_b_fireball[id]+= random_num(0,33)
	if(player_b_ghost[id]>0) player_b_ghost[id]+= random_num(0,1)
	if(player_b_windwalk[id]>0) player_b_windwalk[id] += random_num(0,1)
	
	if(player_b_dagon[id]>0) player_b_dagon[id] += random_num(0,1)
	if(player_b_sniper[id]>0)
	{
		if(player_b_sniper[id]>5) player_b_sniper[id]-=random_num(0,2)
		else if(player_b_sniper[id]>2) player_b_sniper[id]-=random_num(0,1)
		}
	if(player_b_m3[id]>0)
	{
		if(player_b_m3[id]>5) player_b_m3[id]-=random_num(0,2)
		else if(player_b_m3[id]>2) player_b_m3[id]-=random_num(0,1)
			else if(player_b_m3[id]>1) player_b_m3[id]-=random_num(-1,1)
		}
	if(player_awpk[id]>0)
	{
		if(player_awpk[id]>5) player_awpk[id]-=random_num(0,2)
		else if(player_awpk[id]>2) player_awpk[id]-=random_num(0,1)
			else if(player_awpk[id]>1) player_awpk[id]-=random_num(-1,1)
		}
	
	if(player_b_extrastats[id]>0) player_b_extrastats[id] += random_num(0,2)
	if(player_b_firetotem[id]>0) player_b_firetotem[id] += random_num(0,50)
	if(player_speedbonus[id]>0) player_speedbonus[id] += random_num(0,10)
	if(player_knifebonus[id]>0) player_knifebonus[id] += random_num(0,40)
	if(player_b_darksteel[id]>0) player_b_darksteel[id] += random_num(0,2)
	if(player_b_mine[id]>0) player_b_mine[id] += random_num(0,1)
	if(player_przesz[id]>0) player_przesz[id] += random_num(-5,30)
	if(player_healer[id]>0) player_healer[id] += random_num(-5,30)
	if(player_b_mine_lesna[id]>0) player_b_mine_lesna[id] += random_num(0,1)
	if(player_b_mine_lodu[id]>0) player_b_mine_lodu[id] += random_num(0,1)
	if(player_b_truj_nozem[id]>0) player_b_truj_nozem[id] += random_num(0,1)
	if(player_ruch[id]>0) player_ruch[id] += random_num(-10,30)
	
	if(player_sword[id]>0)
	{
		if(player_b_jumpx[id]==0 && random_num(0,10)==10) player_b_jumpx[id]=1
		if(player_b_vampire[id]==0 && random_num(0,10)==10) player_b_vampire[id]=1
		if(player_b_respawn[id]==0 && random_num(0,10)==5) player_b_respawn[id]=15
		else if(player_b_respawn[id]>2 && random_num(0,10)==5) player_b_respawn[id]+=random_num(0,1)
		if(player_b_ghost[id]==0 && random_num(0,10)==10) player_b_ghost[id]=1
		if(player_b_darksteel[id]==0 && random_num(0,10)==10) player_b_darksteel[id]=1
	}
	if(player_ultra_armor[id]>0) player_ultra_armor[id]++
	if(player_mrocznibonus[id]>0) player_mrocznibonus[id] += random_num(1,10)
	if(player_ludziebonus[id]>0) player_ludziebonus[id] += random_num(1,10)
	if(player_intbonus[id]>0) player_intbonus[id] += random_num(1,10)
	if(player_strbonus[id]>0) player_strbonus[id] += random_num(1,10)
	if(player_grom[id]>0) player_grom[id] += random_num(10,20)
	if(player_b_zlotoadd[id]>0 && player_b_zlotoadd[id]<15000) player_b_zlotoadd[id] += random_num(100,2000)
	if(player_b_tarczaogra[id]>0) player_b_tarczaogra[id] += random_num(1,5)
	if(player_lembasy[id]>0) player_lembasy[id] += random_num(1,5)
	
	if(player_intbonus[id]>0) player_intbonus[id] += random_num(1,10)
	if(player_strbonus[id]>0) player_strbonus[id] += random_num(1,10)
	if(player_agibonus[id]>0) player_agibonus[id] += random_num(1,10)
	if(player_dexbonus[id]>0) player_dexbonus[id] += random_num(1,10)
	if(player_staty[id]>0) player_staty[id] += random_num(1,10)
	if(player_dosw[id]>0) player_dosw[id] += random_num(10,100)
	
	if(player_tarczam[id]>0) player_tarczam[id] += random_num(10,50)
	if(player_grawitacja[id]>0) player_grawitacja[id] -= random_num(2,10)
	if(player_chargetime[id]>0) player_chargetime[id] += random_num(1,10)
	if(player_naszyjnikczasu[id]>0) player_naszyjnikczasu[id] += random_num(3,8)
	if(player_totem_enta[id]>0 && player_totem_enta[id] < 20) player_totem_enta[id] += random_num(1,3)
	if(player_totem_enta_zasieg[id]>0 && player_totem_enta_zasieg[id] < 4000) player_totem_enta_zasieg[id] += random_num(1,50)
	if(player_totem_lodu[id]>0 && player_totem_lodu[id] < 20) player_totem_lodu[id] += random_num(1,4)
	if(player_totem_lodu_zasieg[id]>0  && player_totem_lodu_zasieg[id] < 4000) player_totem_lodu_zasieg[id] += random_num(1,150)					
	if(player_dziewica[id]>0) player_dziewica[id] += random_num(1,20)			
	if(player_recoil[id] > 0){
		player_recoil[id] -= random_num(1,2)
		if(player_recoil[id]<1) player_recoil[id]=1
	}	 
	
}

/* ==================================================================================================== */

//Blocks fullupdate (can reset hud)
public fullupdate(id) 
{
	return PLUGIN_HANDLED
}

/* ==================================================================================================== */
public add_bonus_scoutdamage(attacker_id,id,weapon)
{
	if (player_b_sniper[attacker_id] > 0 && get_user_team(attacker_id) != get_user_team(id) && weapon == CSW_SCOUT && player_class[attacker_id]!=Gon &&   player_class[attacker_id] != Ognik && player_class[attacker_id]!=Ninja && player_class[attacker_id]!=Samurai)
	{
		
		if (!is_user_alive(id))
			return PLUGIN_HANDLED
		
		if (random_num(1,player_b_sniper[attacker_id]) == 1)
			UTIL_Kill(attacker_id,id,"world")
		
	}
	
	return PLUGIN_HANDLED
}

public add_bonus_m3(attacker_id,id,weapon)
{
	if (player_b_m3[attacker_id] > 0 && get_user_team(attacker_id) != get_user_team(id) && weapon == CSW_M3 &&  player_class[attacker_id] != Ognik && player_class[attacker_id]!=Gon && player_class[attacker_id]!=Ninja  && player_class[attacker_id]!=Samurai)
	{
		if (!is_user_alive(id))
			return PLUGIN_HANDLED
		
		if (random_num(1,player_b_m3[attacker_id]) == 1)
			UTIL_Kill(attacker_id,id,"world")
	}
	if (player_awpk[attacker_id] > 0 && get_user_team(attacker_id) != get_user_team(id) && weapon == CSW_AWP &&  player_class[attacker_id] != Ognik &&player_class[attacker_id]!=Gon && player_class[attacker_id]!=Ninja  && player_class[attacker_id]!=Samurai)
	{
		if (!is_user_alive(id))
			return PLUGIN_HANDLED
		
		if (random_num(1,player_awpk[attacker_id]) == 1)
			UTIL_Kill(attacker_id,id,"world")
	}
	
	return PLUGIN_HANDLED
}

/* ==================================================================================================== */

public add_bonus_illusion(attacker_id,id,weapon)
{
	if(HasFlag(id,Flag_Illusion))
	{
		new weaponname[32]
		get_weaponname( weapon, weaponname, 31 ) 
		replace(weaponname, 31, "weapon_", "")
		UTIL_Kill(attacker_id,id,weaponname)
	}
}

/* ==================================================================================================== */


public item_take_damage(id,damage)
{
	new itemdamage = damage/2
	if(itemdamage > 10) itemdamage = 10
	if(itemdamage < 1) itemdamage = 1
	if (player_item_id[id] > 0 && item_durability[id] >= 0 && itemdamage> 0 && damage > 5)
	{
		item_make_damage(id,itemdamage)		
	}
}
public item_make_damage(id,itemdamage)
{
	//Make item take damage
	if (item_durability[id] - itemdamage <= 0)
	{
		item_durability[id]-=itemdamage
		dropitem(id)
		cs_set_user_money(id,cs_get_user_money(id)+250)
	}
	else
	{
		item_durability[id]-=itemdamage
	}
}

/* ==================================================================================================== */

//From twistedeuphoria plugin
public Prethink_Doublejump(id)
{
	if(!is_user_alive(id)) 
		return PLUGIN_HANDLED
	new j =  player_b_jumpx[id]
	if(player_class[id]==Samurai &&  player_b_jumpx[id] < 5)   j = 10
	
	if((get_user_button(id) & IN_JUMP) && !(get_entity_flags(id) & FL_ONGROUND) && !(get_user_oldbutton(id) & IN_JUMP))
	{
		if(jumps[id] < j)
		{
			dojump[id] = true
			jumps[id]++
			return PLUGIN_HANDLED
		}
		
	}
	if((get_user_button(id) & IN_JUMP) && (get_entity_flags(id) & FL_ONGROUND))
	{
		jumps[id] = 0
		return PLUGIN_CONTINUE
	}
	
	return PLUGIN_HANDLED
}

public Postthink_Doubeljump(id)
{
	if(!is_user_alive(id)) 
		return PLUGIN_HANDLED
	
	if(dojump[id] == true)
	{
		new Float:velocity[3]	
		entity_get_vector(id,EV_VEC_velocity,velocity)
		velocity[2] = random_float(265.0,285.0)
		entity_set_vector(id,EV_VEC_velocity,velocity)
		dojump[id] = false
		return PLUGIN_CONTINUE
	}
	
	return PLUGIN_HANDLED
}


/* ==================================================================================================== */

public eventGrenade(id) 
{
	new id = read_data(1)
	if (player_b_grenade[id] > 0 || player_b_smokehit[id] > 0)
	{
		set_task(0.1, "makeGlow", id)
	}
}

public makeGlow(id) 
{
	new grenade
	new greModel[100]
	grenade = get_grenade(id) 
	
	if( grenade ) 
	{	
		entity_get_string(grenade, EV_SZ_model, greModel, 99)
		
		if(equali(greModel, "models/w_hegrenade.mdl" ) && player_b_grenade[id] > 0 )	
			set_rendering(grenade, kRenderFxGlowShell, 255,0,0, kRenderNormal, 255)
		
		if(equali(greModel, "models/w_smokegrenade.mdl" ) && player_b_smokehit[id] > 0 )	
		{
			set_rendering(grenade, kRenderFxGlowShell, 0,255,255, kRenderNormal, 255)
		}
	}
}

/* ==================================================================================================== */

public BoostStats(id,amount)
{
	player_strength[id]+=amount
	player_dextery[id]+=amount
	player_agility[id]+=amount
	player_intelligence[id]+=amount
	recalculateDamRed(id)
}
public BoostInt(id,amount)
{
	player_intelligence[id]+=amount
}
public BoostStr(id,amount)
{
	player_strength[id]+=amount
}
public BoostAgi(id,amount)
{
	player_agility[id]+=amount
	recalculateDamRed(id)
}
public BoostDex(id,amount)
{
	player_dextery[id]+=amount
}
public SubInt(id,amount)
{
	if (player_intelligence[id]-amount>=0) player_intelligence[id]-=amount
	else player_intelligence[id]=0
}
public SubStr(id,amount)
{
	if (player_strength[id]-amount>=0) player_strength[id]-=amount
	else  player_strength[id]=0
}
public SubAgi(id,amount)
{
	if (player_agility[id]-amount>=0) player_agility[id]-=amount
	else player_agility[id]=0
	
	recalculateDamRed(id)
}
public SubDex(id,amount)
{
	if (player_dextery[id]-amount>=0) player_dextery[id]-=amount
	else player_dextery[id]=0
}
public SubtractStats(id,amount)
{
	if (player_strength[id]-amount>=0) player_strength[id]-=amount
	else  player_strength[id]=0
	
	if (player_dextery[id]-amount>=0) player_dextery[id]-=amount
	else player_dextery[id]=0
	
	if (player_agility[id]-amount>=0) player_agility[id]-=amount
	else player_agility[id]=0
	
	if (player_intelligence[id]-amount>=0) player_intelligence[id]-=amount
	else player_intelligence[id]=0
	
	player_point[id]=(player_lvl[id]-1)*2-player_intelligence[id]-player_strength[id]-player_dextery[id]-player_agility[id]	
	if(super){
		if(player_lvl[id]>250){
			player_point[id]=(player_lvl[id]-1-200)*2-player_intelligence[id]-player_strength[id]-player_dextery[id]-player_agility[id]	
		}
		if(player_lvl[id]>500){
			player_point[id]=(player_lvl[id]-1-450)*2-player_intelligence[id]-player_strength[id]-player_dextery[id]-player_agility[id]	
		}
		if(player_lvl[id]>750){
			player_point[id]=(player_lvl[id]-1-700)*2-player_intelligence[id]-player_strength[id]-player_dextery[id]-player_agility[id]	
		}
	}
	
	
	if(player_point[id]<0) player_point[id]=0
	
	recalculateDamRed(id)
}

public BoostRing(id)
{
	switch(player_ring[id])
	{
		case 3: player_agility[id]+=5
		}
}

public SubtractRing(id)
{
	switch(player_ring[id])
	{
		case 1: player_intelligence[id]-=5
			case 2: player_strength[id]-=5
			case 3: player_agility[id]-=5
		}
}

/* ==================================================================================================== */

public SelectBotRace(id)
{
	if (!is_user_bot(id))
		return PLUGIN_HANDLED
	
	
	
	if (player_class[id] == 0)
	{
		player_class[id] = random_num(1,7)
		//load_xp(id)
	}
	
	return PLUGIN_CONTINUE
}

/* ==================================================================================================== */

public showskills(id)
{
	new Skillsinfo[768]
	new d =  dexteryDamRedPerc[id]
	
	formatex(Skillsinfo,767,"Masz %i sily - daje Ci to %i zycia<br><br>Masz %i zwinnosci - to redukuje sile atakow magia %i%%  i daje Ci szybsze bieganie o %i punkow <br><br>Masz %i zrecznosci - Redukuje obrazenia z normalnych atkow %0.0f%%<br><br>Masz %i inteligencji - to daje wieksza moc przedmiotom ktorych da sie uzyc<br>",
	player_strength[id],
	player_strength[id]*2,
	player_dextery[id],
	d,
	floatround(player_dextery[id]*1.2),
	player_agility[id],
	player_damreduction[id]*100,
	player_intelligence[id])
	
	showitem(id,"Skills","None","None", Skillsinfo)
}

/* ==================================================================================================== */

public UTIL_Teleport(id,distance)
{	
	if(distance > 1000) distance = 1000
	Set_Origin_Forward(id,distance)
	
	new origin[3]
	get_user_origin(id,origin)
	
	//Particle burst ie. teleport effect	
	message_begin(MSG_BROADCAST ,SVC_TEMPENTITY) //message begin
	write_byte(TE_PARTICLEBURST )
	write_coord(origin[0]) // origin
	write_coord(origin[1]) // origin
	write_coord(origin[2]) // origin
	write_short(20) // radius
	write_byte(1) // particle color
	write_byte(4) // duration * 10 will be randomized a bit
	message_end()
	
	
}

stock Set_Origin_Forward(id, distance) 
{
	new Float:origin[3]
	new Float:angles[3]
	new Float:teleport[3]
	new Float:heightplus = 10.0
	new Float:playerheight = 64.0
	new bool:recalculate = false
	new bool:foundheight = false
	pev(id,pev_origin,origin)
	pev(id,pev_angles,angles)
	
	teleport[0] = origin[0] + distance * floatcos(angles[1],degrees) * floatabs(floatcos(angles[0],degrees));
	teleport[1] = origin[1] + distance * floatsin(angles[1],degrees) * floatabs(floatcos(angles[0],degrees));
	teleport[2] = origin[2]+heightplus
	
	while (!Can_Trace_Line_Origin(origin,teleport) || Is_Point_Stuck(teleport,48.0))
	{	
		if (distance < 10)
			break;
		
		//First see if we can raise the height to MAX playerheight, if we can, it's a hill and we can teleport there	
		for (new i=1; i < playerheight+20.0; i++)
		{
			teleport[2]+=i
			if (Can_Trace_Line_Origin(origin,teleport) && !Is_Point_Stuck(teleport,48.0))
			{
				foundheight = true
				heightplus += i
				break
			}
			
			teleport[2]-=i
		}
		
		if (foundheight)
			break
		
		recalculate = true
		distance-=10
		teleport[0] = origin[0] + (distance+32) * floatcos(angles[1],degrees) * floatabs(floatcos(angles[0],degrees));
		teleport[1] = origin[1] + (distance+32) * floatsin(angles[1],degrees) * floatabs(floatcos(angles[0],degrees));
		teleport[2] = origin[2]+heightplus
	}
	
	if (!recalculate)
	{
		set_pev(id,pev_origin,teleport)
		return PLUGIN_CONTINUE
	}
	
	teleport[0] = origin[0] + distance * floatcos(angles[1],degrees) * floatabs(floatcos(angles[0],degrees));
	teleport[1] = origin[1] + distance * floatsin(angles[1],degrees) * floatabs(floatcos(angles[0],degrees));
	teleport[2] = origin[2]+heightplus
	set_pev(id,pev_origin,teleport)
	
	return PLUGIN_CONTINUE
}

stock bool:Can_Trace_Line_Origin(Float:origin1[3], Float:origin2[3])
{	
	new Float:Origin_Return[3]	
	new Float:temp1[3]
	new Float:temp2[3]
	
	temp1[x] = origin1[x]
	temp1[y] = origin1[y]
	temp1[z] = origin1[z]-30
	
	temp2[x] = origin2[x]
	temp2[y] = origin2[y]
	temp2[z] = origin2[z]-30
	
	trace_line(-1, temp1, temp2, Origin_Return) 
	
	if (get_distance_f(Origin_Return,temp2) < 1.0)
		return true
	
	return false
}

stock bool:Is_Point_Stuck(Float:Origin[3], Float:hullsize)
{
	new Float:temp[3]
	new Float:iterator = hullsize/3
	
	temp[2] = Origin[2]
	
	for (new Float:i=Origin[0]-hullsize; i < Origin[0]+hullsize; i+=iterator)
	{
		for (new Float:j=Origin[1]-hullsize; j < Origin[1]+hullsize; j+=iterator)
		{
			//72 mod 6 = 0
			for (new Float:k=Origin[2]-CS_PLAYER_HEIGHT; k < Origin[2]+CS_PLAYER_HEIGHT; k+=6) 
			{
				temp[0] = i
				temp[1] = j
				temp[2] = k
				
				if (point_contents(temp) != -1)
					return true
			}
		}
	}
	
	return false
}
stock Effect_Bleed2(id,color)
{
	Display_Fade(id,1<<14,1<<14,1<<16,255,50,50,150)
	Effect_Bleed(id,color)
	new origin[3]
	get_user_origin(id,origin)
	
	new dx, dy, dz	
	
	for(new i = 0; i < 3; i++) 
	{
		for(new j = 0; j < 25; j++) 
		{
			dx = random_num(-1,1)
			dy = random_num(-1,1)
			dz = random_num(-1,1)
			message_begin(MSG_BROADCAST,SVC_TEMPENTITY)
			write_byte(TE_BLOODSPRITE)
			write_coord(origin[0]+(dx*j))
			write_coord(origin[1]+(dy*j))
			write_coord(origin[2]+(dz*j))
			write_short(sprite_blood_spray)
			write_short(sprite_blood_drop)
			write_byte(color) // color index
			write_byte(8) // size
			message_end()
		}
	}
}


stock Effect_Bleed(id,color)
{
	new origin[3]
	get_user_origin(id,origin)
	
	new dx, dy, dz
	
	for(new i = 0; i < 3; i++) 
	{
		dx = random_num(-15,15)
		dy = random_num(-15,15)
		dz = random_num(-20,25)
		
		for(new j = 0; j < 2; j++) 
		{
			message_begin(MSG_BROADCAST,SVC_TEMPENTITY)
			write_byte(TE_BLOODSPRITE)
			write_coord(origin[0]+(dx*j))
			write_coord(origin[1]+(dy*j))
			write_coord(origin[2]+(dz*j))
			write_short(sprite_blood_spray)
			write_short(sprite_blood_drop)
			write_byte(color) // color index
			write_byte(8) // size
			message_end()
		}
	}
}

/* ==================================================================================================== */

public Use_Spell(id)
{
	if (player_global_cooldown[id] + GLOBAL_COOLDOWN >= halflife_time())
		return PLUGIN_CONTINUE
	else
		player_global_cooldown[id] = halflife_time()
	
	if (!is_user_alive(id) || !freeze_ended)
		return PLUGIN_CONTINUE
		
	
	/*See if USE button is used for anything else..
	1) Close to bomb
	2) Close to hostage
	3) Close to switch
	4) Close to door
	*/
	
	new Float:origin[3]
	pev(id, pev_origin, origin)
	
	//Func door and func door rotating
	new aimid, body
	get_user_aiming ( id, aimid, body ) 
	
	if (aimid > 0)
	{
		new classname[32]
		pev(aimid,pev_classname,classname,31)
		
		if (equal(classname,"func_door_rotating") || equal(classname,"func_door") || equal(classname,"func_button"))
		{
			new Float:doororigin[3]
			pev(aimid, pev_origin, doororigin)
			
			if (get_distance_f(origin, doororigin) < 70 && UTIL_In_FOV(id,aimid))
				return PLUGIN_CONTINUE
		}
		
	}
	
	//Bomb condition
	new bomb
	if ((bomb = find_ent_by_model(-1, "grenade", "models/w_c4.mdl"))) 
	{
		new Float:bombpos[3]
		pev(bomb, pev_origin, bombpos)
		
		//We are near the bomb and have it in FOV.
		if (get_distance_f(origin, bombpos) < 100 && UTIL_In_FOV(id,bomb))
			return PLUGIN_CONTINUE
	}
	
	
	//Hostage
	new hostage = engfunc(EngFunc_FindEntityByString, -1,"classname", "hostage_entity")
	
	while (hostage)
	{
		new Float:hospos[3]
		pev(hostage, pev_origin, hospos)
		if (get_distance_f(origin, hospos) < 70 && UTIL_In_FOV(id,hostage))
			return PLUGIN_CONTINUE
		
		hostage = engfunc(EngFunc_FindEntityByString, hostage,"classname", "hostage_entity")
	}
	
	check_magic(id)
	
	
	return PLUGIN_CONTINUE
}
public item_mineL_Ognik(id)
{
	new count = 0
	new ents = -1
	ents = find_ent_by_owner(ents,"MineLO",id)
	while (ents > 0)
	{
		count++
		ents = find_ent_by_owner(ents,"MineLO",id)
	}
	
	if (count > 4)
	{
		hudmsg(id,2.0,"Mozesz polozyc maksymalnie 5 min na runde")
		return PLUGIN_CONTINUE
	}
	
	if(player_naladowany[id] >= 2){
		hudmsg(id,2.0,"Nie masz wiecej Min")
		return PLUGIN_CONTINUE
	} 	
	
	
	new origin[3]
	pev(id,pev_origin,origin)
	player_naladowany[id] ++
	
	new ent = Spawn_Ent("info_target")
	set_pev(ent,pev_classname,"MineLO")
	set_pev(ent,pev_owner,id)
	set_pev(ent,pev_movetype,MOVETYPE_TOSS)
	set_pev(ent,pev_origin,origin)
	set_pev(ent,pev_solid,SOLID_BBOX)
	
	engfunc(EngFunc_SetModel, ent, "addons/amxmodx/diablo/mine.mdl")  
	engfunc(EngFunc_SetSize,ent,Float:{-16.0,-16.0,0.0},Float:{16.0,16.0,2.0})
	
	drop_to_floor(ent)
	
	entity_set_float(ent,EV_FL_nextthink,halflife_time() + 0.01) 
	
	set_rendering(ent,kRenderFxNone, 10,200,10, kRenderTransTexture,70)	
	
	use_addtofullpack = true
	
	return PLUGIN_CONTINUE
}

public check_Skill(id)					//Redirect and check which items will be triggered
{
	if(player_class[id]==Druid) druid_skill(id)
	if(player_class[id]==Meduza) meduza_skill(id)
	
	if ( is_user_in_bad_zone( id ) ){
		hudmsg(id,2.0,"Nie mozna uzyc w tym miejscu")
		return PLUGIN_HANDLED
		}else{
		if (player_class[id]==Ognik) item_mineL_Ognik(id)
	}
	
	if(czas_rundy + 10 > floatround(halflife_time())){
		set_hudmessage(255, 0, 0, -1.0, 0.01)
		show_hudmessage(id, "Skilla mozesz uzywac 10 sek po starcie rundy")
		
		return PLUGIN_HANDLED
	}
	
	if(player_class[id]==Wysoki) command_flara(id)	
	if(player_class[id]==Ifryt) ifryt_skill(id)
	if(player_class[id]==Zjawa) zjawa_skill(id)
	

	if(player_class[id]==Kuroliszek)
	{
		if(czas_rundy + 20 > floatround(halflife_time())){
			set_hudmessage(255, 0, 0, -1.0, 0.01)
			show_hudmessage(id, "Skilla mozesz uzywac 20 sek po starcie rundy")
			
			return PLUGIN_HANDLED
		}
		BiegOn(id)
	} 

	
	return PLUGIN_HANDLED
}
public Use_Skill(id)
{
	if (player_global_cooldown[id] + GLOBAL_COOLDOWN >= halflife_time())
		return PLUGIN_CONTINUE
	else
		player_global_cooldown[id] = halflife_time()
	
	if (!is_user_alive(id) || !freeze_ended)
		return PLUGIN_CONTINUE
	
	/*See if USE button is used for anything else..
	1) Close to bomb
	2) Close to hostage
	3) Close to switch
	4) Close to door
	*/
	
	new Float:origin[3]
	pev(id, pev_origin, origin)
	
	//Func door and func door rotating
	new aimid, body
	get_user_aiming ( id, aimid, body ) 
	
	if (aimid > 0)
	{
		new classname[32]
		pev(aimid,pev_classname,classname,31)
		
		if (equal(classname,"func_door_rotating") || equal(classname,"func_door") || equal(classname,"func_button"))
		{
			new Float:doororigin[3]
			pev(aimid, pev_origin, doororigin)
			
			if (get_distance_f(origin, doororigin) < 70 && UTIL_In_FOV(id,aimid))
				return PLUGIN_CONTINUE
		}
		
	}
	
	//Bomb condition
	new bomb
	if ((bomb = find_ent_by_model(-1, "grenade", "models/w_c4.mdl"))) 
	{
		new Float:bombpos[3]
		pev(bomb, pev_origin, bombpos)
		
		//We are near the bomb and have it in FOV.
		if (get_distance_f(origin, bombpos) < 100 && UTIL_In_FOV(id,bomb))
			return PLUGIN_CONTINUE
	}
	
	
	//Hostage
	new hostage = engfunc(EngFunc_FindEntityByString, -1,"classname", "hostage_entity")
	
	while (hostage)
	{
		new Float:hospos[3]
		pev(hostage, pev_origin, hospos)
		if (get_distance_f(origin, hospos) < 70 && UTIL_In_FOV(id,hostage))
			return PLUGIN_CONTINUE
		
		hostage = engfunc(EngFunc_FindEntityByString, hostage,"classname", "hostage_entity")
	}
	
	check_Skill(id)
	
	
	return PLUGIN_CONTINUE
}

/* ==================================================================================================== */

//Angle to all targets in fov
stock Float:Find_Angle(Core,Target,Float:dist)
{
	new Float:vec2LOS[2]
	new Float:flDot	
	new Float:CoreOrigin[3]
	new Float:TargetOrigin[3]
	new Float:CoreAngles[3]
	
	pev(Core,pev_origin,CoreOrigin)
	pev(Target,pev_origin,TargetOrigin)
	
	if (get_distance_f(CoreOrigin,TargetOrigin) > dist)
		return 0.0
	
	pev(Core,pev_angles, CoreAngles)
	
	for ( new i = 0; i < 2; i++ )
		vec2LOS[i] = TargetOrigin[i] - CoreOrigin[i]
	
	new Float:veclength = Vec2DLength(vec2LOS)
	
	//Normalize V2LOS
	if (veclength <= 0.0)
	{
		vec2LOS[x] = 0.0
		vec2LOS[y] = 0.0
	}
	else
	{
		new Float:flLen = 1.0 / veclength;
		vec2LOS[x] = vec2LOS[x]*flLen
		vec2LOS[y] = vec2LOS[y]*flLen
	}
	
	//Do a makevector to make v_forward right
	engfunc(EngFunc_MakeVectors,CoreAngles)
	
	new Float:v_forward[3]
	new Float:v_forward2D[2]
	get_global_vector(GL_v_forward, v_forward)
	
	v_forward2D[x] = v_forward[x]
	v_forward2D[y] = v_forward[y]
	
	flDot = vec2LOS[x]*v_forward2D[x]+vec2LOS[y]*v_forward2D[y]
	
	if ( flDot > 0.5 )
	{
		return flDot
	}
	
	return 0.0	
}

stock Float:Vec2DLength( Float:Vec[2] )  
{ 
	return floatsqroot(Vec[x]*Vec[x] + Vec[y]*Vec[y] )
}

stock bool:UTIL_In_FOV(id,target)
{
	if (Find_Angle(id,target,9999.9) > 0.0)
		return true
	
	return false
}

/* ==================================================================================================== */


public Greet_Player(id)
{
	id-=TASK_GREET
	new name[32]
	get_user_name(id,name,31)
	switch(random_num(1,2)){
		case 1: client_print(id,print_chat, "Witaj %s w Lord of Destruction mod www.cs-lod.com.pl napisz /komendy, zeby zobaczec liste komend /pomoc aby dowiedziec sie jak grac/ ", name)
			
		case 2: client_print(id,print_chat, "Na www.cs-lod.com.pl znajdziesz poradniki, opisy klas i itemow! Tam tez zglaszaj pomysly zmian!")
			
		
	}
	
	
}

/* ==================================================================================================== */



/* ==================================================================================================== */

public changerace(id)
{
	if(bowdelay[id] + 5 < get_gametime()){
		bowdelay[id] = get_gametime()
				
		if(freeze_ended && player_class[id]!=NONE ){
			new kid = last_attacker[id]
			new vid = id
			if (is_user_connected(kid) && is_user_connected(vid) && get_user_team(kid) != get_user_team(vid))
			{
				show_deadmessage(kid,vid,0,"world")
				award_item(kid,0)
				award_kill(kid,vid)
				add_barbarian_bonus(kid)
				set_renderchange(kid)
			}
			user_kill(id, 0)
		}
		if(player_class[id]!=NONE) savexpcom(id)
		KlasyZlicz[player_class[id]]--
		player_samelvl[id] = 0;
		if(KlasyZlicz[player_class[id]] < 0) KlasyZlicz[player_class[id]] = 0
		player_class[id]=NONE
		client_connect(id) 		
		select_class_query(id)
		myRank [id] = -1
	}
}


/* ==================================================================================================== */

//Disable autohelp messages and display our own.
public FW_WriteString(string[])
{
	if (equal(string,""))
		return FMRES_IGNORED
	
	//Disable autohelp
	if (equal(string,"#Hint_press_buy_to_purchase") || equal(string,"#Hint_press_buy_to_purchase "))
	{
		write_string( "" );
		return FMRES_SUPERCEDE
	}
	
	if (equal(string, "#Hint_spotted_a_friend") || equal(string, "#Hint_you_have_the_bomb"))
	{
		write_string( "" );
		return FMRES_SUPERCEDE
	}
	
	return FMRES_IGNORED
	
}

stock hudmsg(id,Float:display_time,const fmt[], {Float,Sql,Result,_}:...)
{	
	if (player_huddelay[id] >= 0.03*4)
		return PLUGIN_CONTINUE
	
	new buffer[512]
	vformat(buffer, 511, fmt, 4)
	
	set_hudmessage ( 255, 0, 0, -1.0, 0.4 + player_huddelay[id], 0, display_time/2, display_time, 0.1, 0.2, -1 ) 	
	show_hudmessage(id, buffer)
	
	player_huddelay[id]+=0.03
	
	remove_task(id+TASK_HUD)
	set_task(display_time, "hudmsg_clear", id+TASK_HUD, "", 0, "a", 3)

	return PLUGIN_CONTINUE
	
}

public hudmsg_clear(id)
{
	new pid = id-TASK_HUD
	player_huddelay[pid]=0.0
}

/* ==================================================================================================== */

public item_firetotem(id)
{
	if (used_item[id] &&  player_diablo[id]==0 && player_she[id]==0)
	{
		hudmsg(id,2.0,"Mozesz uzyc raz w rundzie totemu ognia")
	}
	else
	{
		used_item[id] = true
		Effect_Ignite_Totem(id,7)	
		
	}
}

stock Effect_Ignite_Totem(id,seconds)
{
	new origin[3]
	pev(id,pev_origin,origin)
	
	new ent = Spawn_Ent("info_target")
	set_pev(ent,pev_classname,"Effect_Ignite_Totem")
	set_pev(ent,pev_owner,id)
	set_pev(ent,pev_solid,SOLID_TRIGGER)
	set_pev(ent,pev_origin,origin)
	set_pev(ent,pev_ltime, halflife_time() + seconds + 0.1)
	
	engfunc(EngFunc_SetModel, ent, "addons/amxmodx/diablo/totem_ignite.mdl")  	
	set_rendering ( ent, kRenderFxGlowShell, 250,150,0, kRenderFxNone, 255 ) 	
	engfunc(EngFunc_DropToFloor,ent)
	
	set_pev(ent,pev_euser3,0)
	set_pev(ent,pev_nextthink, halflife_time() + 0.1)
}

public Effect_Ignite_Totem_Think(ent)
{
	//Safe check because effect on death
	if (!freeze_ended)
		remove_entity(ent)
	
	if (!is_valid_ent(ent))
		return PLUGIN_CONTINUE
	
	new id = pev(ent,pev_owner)
	
	//Apply and destroy
	if (pev(ent,pev_euser3) == 1)
	{
		new entlist[513]
		new numfound = find_sphere_class(ent,"player",player_b_firetotem[id]+0.0,entlist,512)
		
		for (new i=0; i < numfound; i++)
		{		
			new pid = entlist[i]
			
			//This totem can hit the caster
			
			
			if (pid == id && is_user_alive(id))
			{
				
				Effect_Ignite(pid,id,4)
				hudmsg(pid,3.0,"Palisz sie. Strzel do kogos aby przestac sie palic!")
				continue
				
			}
			
			
			if (!is_user_alive(pid) || get_user_team(id) == get_user_team(pid) ||   cs_get_user_team(pid) == CS_TEAM_SPECTATOR)
				continue
			
			
			
			
			//Dextery makes the fire damage less
			if (player_dextery[pid] > 20)
				Effect_Ignite(pid,id,1)
			else if (player_dextery[pid] > 15)
				Effect_Ignite(pid,id,2)
			else if (player_dextery[pid] > 10)
				Effect_Ignite(pid,id,3)
			else
				Effect_Ignite(pid,id,4)
			
			
			hudmsg(pid,3.0,"Palisz sie. Strzel do kogos aby przestac sie palic!")
		}
		
		remove_entity(ent)
		return PLUGIN_CONTINUE
	}
	
	
	
	//Entity should be destroyed because livetime is over
	if (pev(ent,pev_ltime) < halflife_time())
	{
		set_pev(ent,pev_euser3,1)
		
		//Show animation and die
		
		new Float:forigin[3], origin[3]
		pev(ent,pev_origin,forigin)	
		FVecIVec(forigin,origin)
		
		//Find people near and give them health
		message_begin( MSG_BROADCAST, SVC_TEMPENTITY, origin );
		write_byte( TE_BEAMCYLINDER );
		write_coord( origin[0] );
		write_coord( origin[1] );
		write_coord( origin[2] );
		write_coord( origin[0] );
		write_coord( origin[1] + player_b_firetotem[id]);
		write_coord( origin[2] + player_b_firetotem[id]);
		write_short( sprite_white );
		write_byte( 0 ); // startframe
		write_byte( 0 ); // framerate
		write_byte( 10 ); // life
		write_byte( 10 ); // width
		write_byte( 255 ); // noise
		write_byte( 150 ); // r, g, b
		write_byte( 150 ); // r, g, b
		write_byte( 0 ); // r, g, b
		write_byte( 128 ); // brightness
		write_byte( 5 ); // speed
		message_end();
		
		set_pev(ent,pev_nextthink, halflife_time() + 0.2)
		
	}
	else	
	{
		set_pev(ent,pev_nextthink, halflife_time() + 1.5)
	}
	
	return PLUGIN_CONTINUE
}

stock Spawn_Ent(const classname[]) 
{
	new ent = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, classname))
	set_pev(ent, pev_origin, {0.0, 0.0, 0.0})    
	dllfunc(DLLFunc_Spawn, ent)
	return ent
}

stock Effect_Ignite(id,attacker,damage)
{
	if(player_odpornosc_fire[id]>0) return 
	if(damage <= 0 ) damage = 1
	new ent = Spawn_Ent("info_target")
	set_pev(ent,pev_classname,"Effect_Ignite")
	set_pev(ent,pev_owner,id)
	set_pev(ent,pev_ltime, halflife_time() + 99 + 0.1)
	set_pev(ent,pev_solid,SOLID_NOT)
	set_pev(ent,pev_euser1,attacker)
	set_pev(ent,pev_euser2,damage)
	set_pev(ent,pev_nextthink, halflife_time() + 0.1)	
	
	AddFlag(id,Flag_Ignite)
}

//euser3 = destroy and apply effect
public Effect_Ignite_Think(ent)
{
	new id = pev(ent,pev_owner)
	new attacker = pev(ent,pev_euser1)
	new damage = pev(ent,pev_euser2)
	
	if (pev(ent,pev_ltime) < halflife_time() || !is_user_alive(id) || !HasFlag(id,Flag_Ignite))
	{
		RemoveFlag(id,Flag_Ignite)
		Remove_All_Tents(id)
		Display_Icon(id ,0 ,"dmg_heat" ,200,0,0)
		
		remove_entity(ent)		
		return PLUGIN_CONTINUE
	}
	
	
	//Display ignite tent and icon
	Display_Tent(id,sprite_ignite,2)
	Display_Icon(id ,1 ,"dmg_heat" ,200,0,0)
	
	new origin[3]
	get_user_origin(id,origin)
	
	//Make some burning effects
	message_begin( MSG_BROADCAST,SVC_TEMPENTITY)
	write_byte( TE_SMOKE ) // 5
	write_coord(origin[0])
	write_coord(origin[1])
	write_coord(origin[2])
	write_short( sprite_smoke )
	write_byte( 22 )  // 10
	write_byte( 10 )  // 10
	message_end()
	
	//Decals
	message_begin( MSG_BROADCAST,SVC_TEMPENTITY)
	write_byte( TE_GUNSHOTDECAL ) // decal and ricochet sound
	write_coord( origin[0] ) //pos
	write_coord( origin[1] )
	write_coord( origin[2] )
	write_short (0) // I have no idea what thats supposed to be
	write_byte (random_num(199,201)) //decal
	message_end()
	
	
	//Do the actual damage
	change_health(id,-damage,attacker,"world")
	
	set_pev(ent,pev_nextthink, halflife_time() + 1.5)
	
	
	return PLUGIN_CONTINUE
}

stock AddFlag(id,flag)
{
	afflicted[id][flag] = 1	
}

stock RemoveFlag(id,flag)
{
	afflicted[id][flag] = 0
}

stock bool:HasFlag(id,flag)
{
	if (afflicted[id][flag])
		return true
	
	return false
}

stock Display_Tent(id,sprite, seconds)
{
	message_begin(MSG_ALL,SVC_TEMPENTITY)
	write_byte(TE_PLAYERATTACHMENT)
	write_byte(id)
	write_coord(40) //Offset
	write_short(sprite)
	write_short(seconds*10)
	message_end()
}

stock Remove_All_Tents(id)
{
	message_begin(MSG_ALL ,SVC_TEMPENTITY) //message begin
	write_byte(TE_KILLPLAYERATTACHMENTS)
	write_byte(id) // entity index of player
	message_end()
}



stock Find_Best_Angle(id,Float:dist, same_team = false)
{
	new Float:bestangle = 0.0
	new winner = -1
	
	for (new i=0; i < MAX; i++)
	{
		if (!is_user_alive(i) || i == id || (get_user_team(i) == get_user_team(id) && !same_team))
			continue
		
		if (get_user_team(i) != get_user_team(id) && same_team)
			continue
		
		//User has spell immunity, don't target
		
		new Float:c_angle = Find_Angle(id,i,dist)
		
		if (c_angle > bestangle && Can_Trace_Line(id,i))
		{
			winner = i
			bestangle = c_angle
		}
		
	}
	
	return winner
}

//This is an interpolation. We make tree lines with different height as to make sure
stock bool:Can_Trace_Line(id, target)
{	
	for (new i=-35; i < 60; i+=35)
	{		
		new Float:Origin_Id[3]
		new Float:Origin_Target[3]
		new Float:Origin_Return[3]
		
		pev(id,pev_origin,Origin_Id)
		pev(target,pev_origin,Origin_Target)
		
		Origin_Id[z] = Origin_Id[z] + i
		Origin_Target[z] = Origin_Target[z] + i
		
		trace_line(-1, Origin_Id, Origin_Target, Origin_Return) 
		
		if (get_distance_f(Origin_Return,Origin_Target) < 25.0)
			return true
		
	}
	
	return false
}

public item_hook(id)
{
	if (used_item[id])
	{
		hudmsg(id,2.0,"Haku mozesz uzyc raz na runde!")
		return PLUGIN_CONTINUE	
	}
	
	new target = Find_Best_Angle(id,1000.0,false)
	
	if (!is_valid_ent(target))
	{
		hudmsg(id,2.0,"Obiekt jest poza zasiegiem.")
		return PLUGIN_CONTINUE
	}
	
	AddFlag(id,Flag_Hooking)
	
	set_user_gravity(target,0.0)
	set_task(0.1,"hook_prethink",id+TASK_HOOK,"",0,"b")
	hooked[id] = target
	hook_prethink(id+TASK_HOOK)
	emit_sound(id,CHAN_VOICE,"weapons/xbow_hit2.wav", 1.0, ATTN_NORM, 0, PITCH_NORM)
	
	used_item[id] = true	
	return PLUGIN_HANDLED
	
}

public hook_prethink(id)
{
	id -= TASK_HOOK
	if(!is_user_alive(id) || !is_user_alive(hooked[id])) 
	{
		RemoveFlag(id,Flag_Hooking)
		return PLUGIN_HANDLED
	}
	if (get_user_button(id) & ~IN_USE)
	{
		RemoveFlag(id,Flag_Hooking)
		return PLUGIN_HANDLED	
	}
	if(!HasFlag(id,Flag_Hooking))
	{
		if (is_user_alive(hooked[id]))
			set_user_gravity(id,1.0)
		remove_task(id+TASK_HOOK)
		return PLUGIN_HANDLED
	}
	
	//Get Id's origin
	static origin1[3]
	get_user_origin(id,origin1)
	
	static origin2[3]
	get_user_origin(hooked[id],origin2)
	
	//Create blue beam
	message_begin(MSG_BROADCAST,SVC_TEMPENTITY)
	write_byte(1)		//TE_BEAMENTPOINT
	write_short(id)		// start entity
	write_coord(origin2[0])
	write_coord(origin2[1])
	write_coord(origin2[2])
	write_short(sprite_line)
	write_byte(1)		// framestart
	write_byte(1)		// framerate
	write_byte(2)		// life in 0.1's
	write_byte(5)		// width
	write_byte(0)		// noise
	write_byte(0)		// red
	write_byte(0)		// green
	write_byte(255)		// blue
	write_byte(200)		// brightness
	write_byte(0)		// speed
	message_end()
	
	//Calculate Velocity
	new Float:velocity[3]
	velocity[0] = (float(origin1[0]) - float(origin2[0])) * 3.0
	velocity[1] = (float(origin1[1]) - float(origin2[1])) * 3.0
	velocity[2] = (float(origin1[2]) - float(origin2[2])) * 3.0
	
	new Float:dy
	dy = velocity[0]*velocity[0] + velocity[1]*velocity[1] + velocity[2]*velocity[2]
	
	new Float:dx
	dx = (4+player_intelligence[id]/2) * 120.0 / floatsqroot(dy)
	
	velocity[0] *= dx
	velocity[1] *= dx
	velocity[2] *= dx
	
	set_pev(hooked[id],pev_velocity,velocity)
	
	return PLUGIN_CONTINUE
}

/* ==================================================================================================== */

public archeolog_item(id)
{	
	if (player_naladowany[id] < 3 + player_intelligence[id]/25)
	{
		if(player_naladowany[id] > 5) return PLUGIN_CONTINUE
		hudmsg(id,2.0,"Wykopales item! " )		
		award_item(id,0)
		player_naladowany[id]++
		write_hud(id)
		return PLUGIN_CONTINUE
	}
	return PLUGIN_CONTINUE
	
	
	
}

public item_archyaniol(id)
{		
	if (pev(id,pev_flags) & FL_ONGROUND) 
	{
		hudmsg(id,2.0,"Musisz byc w powietrzu!")
		return PLUGIN_CONTINUE
	}
	new czas = 25 - player_intelligence[id]/20 - player_naszyjnikczasu[id] 
	if(czas<5)czas=5
	if (halflife_time()-gravitytimer[id] <= czas)
	{
		
		show_hudmessage(id, "Ten skill moze byc uzyty co kazde %i sekundy", czas)
		return PLUGIN_CONTINUE
	}
	write_hud(id)
	gravitytimer[id] = floatround(halflife_time())
	
	new origin[3]
	get_user_origin(id,origin)
	
	if (origin[2] == 0)
		earthstomp[id] = 1
	else
		earthstomp[id] = origin[2]
	set_user_gravity(id,5.0)
	falling[id] = true
	return PLUGIN_CONTINUE
}

public teleporesp(id)
{	
	
	if(player_naladowany[id] ==0){
		player_naladowany[id] = 1
		new svIndex[32] 
		num_to_str(id,svIndex,32)
		set_task(0.5,"respawn",0,svIndex,32) 	
	}
	else{
		show_hudmessage(id, "Teleportu mozesz uzyc raz na runde") 
	}
	
	
	
	return PLUGIN_CONTINUE
	
}
public item_gravitybomb(id)
{	
	if (pev(id,pev_flags) & FL_ONGROUND) 
	{
		hudmsg(id,2.0,"Musisz byc w powietrzu!")
		return PLUGIN_CONTINUE
	}
	
	
	
	if (halflife_time()-gravitytimer[id] <= 5)
	{
		
		hudmsg(id,2.0,"Ten przedmiot, moze byc uzyty co kazde 5 sekundy")
		return PLUGIN_CONTINUE
	}
	
	
	new szMapName[32]
	get_mapname(szMapName, 31)
	if (equal(szMapName, "de_sacrelige")){
		dropitem(id)
	}
	
	
	
	
	gravitytimer[id] = floatround(halflife_time())
	
	new origin[3]
	get_user_origin(id,origin)
	
	if (origin[2] == 0)
		earthstomp[id] = 1
	else
		earthstomp[id] = origin[2]
	
	set_user_gravity(id,5.0)
	falling[id] = true
	
	
	return PLUGIN_CONTINUE
	
}

public add_bonus_stomp(id)
{
	set_gravitychange(id)
	
	new origin[3]
	get_user_origin(id,origin)
	
	new dam = earthstomp[id]-origin[2]
	
	earthstomp[id] = 0
	
	//If jump is is high enough, apply some shake effect and deal damage, 300 = down from BOMB A in dust2
	if (dam < 85)
		return PLUGIN_CONTINUE
	
	dam = dam/2 + 50
	if(dam>150) dam = 150 + ((dam - 150) /5)
	
	message_begin(MSG_ONE , get_user_msgid("ScreenShake") , {0,0,0} ,id)
	write_short( 1<<14 );
	write_short( 1<<12 );
	write_short( 1<<14 );
	message_end();
	
	
	
	new inta = player_intelligence[id]
	new entlist[513]
	if(inta>200) inta = 200
	
	new numfound = find_sphere_class(id,"player",230.0+inta*2,entlist,512)
	
	
	
	
	for (new i=0; i < numfound; i++)
	{		
		new pid = entlist[i]
		
		if (pid == id || !is_user_alive(pid))
			continue
		
		if (get_user_team(id) == get_user_team(pid))
			continue
		
		if (!(pev(pid, pev_flags) & FL_ONGROUND)) continue	
		
		new Float:id_origin[3]
		new Float:pid_origin[3]
		new Float:delta_vec[3]
		
		pev(id,pev_origin,id_origin)
		pev(pid,pev_origin,pid_origin)
		
		
		delta_vec[x] = (pid_origin[x]-id_origin[x])+10
		delta_vec[y] = (pid_origin[y]-id_origin[y])+10
		delta_vec[z] = (pid_origin[z]-id_origin[z])+200
		
		set_pev(pid,pev_velocity,delta_vec)
		
		message_begin(MSG_ONE , get_user_msgid("ScreenShake") , {0,0,0} ,pid)
		write_short( 1<<14 );
		write_short( 1<<12 );
		write_short( 1<<14 );
		message_end();
		if(!fm_is_ent_visible(pid,id) && !fm_is_ent_visible(pid,id)) dam = dam/5;
		change_health(pid,-dam,id,"world")			
	}
	
	return PLUGIN_CONTINUE
}



public add_bonus_space(id)
{
	set_gravitychange(id)
	
	new origin[3]
	get_user_origin(id,origin)
	
	new dam = floatround(20 + player_intelligence[id] * 0.5)
	if(dam > 100) dam=100 
	
	earthstomp[id] = 0
	
	
	message_begin(MSG_ONE , get_user_msgid("ScreenShake") , {0,0,0} ,id)
	write_short( 1<<14 );
	write_short( 1<<12 );
	write_short( 1<<14 );
	message_end();
	
	new entlist[513]
	new numfound = find_sphere_class(id,"player",500.0+player_intelligence[id]*2,entlist,512)
	
	if (is_user_alive(id)){
		for (new i=0; i < numfound; i++)
		{		
			new pid = entlist[i]
			if (pid == id || !is_user_alive(pid))
				continue
			
			if (get_user_team(id) == get_user_team(pid))
				continue
			
			
			if (random_num(1,2) == 1 && player_class[pid] != Drzewiec)  DropWeapon(pid)
			new Float:id_origin[3]
			new Float:pid_origin[3]
			new Float:delta_vec[3]
			
			pev(id,pev_origin,id_origin)
			pev(pid,pev_origin,pid_origin)
			
			
			delta_vec[x] = (pid_origin[x]-id_origin[x])+10
			delta_vec[y] = (pid_origin[y]-id_origin[y])+10
			delta_vec[z] = (pid_origin[z]-id_origin[z])+400
			
			set_pev(pid,pev_velocity,delta_vec)
			
			message_begin(MSG_ONE , get_user_msgid("ScreenShake") , {0,0,0} ,pid)
			write_short( 1<<14 );
			write_short( 1<<12 );
			write_short( 1<<14 );
			message_end();
			
			dam -= player_tarczam[pid]
			dam -= player_dextery[pid]
			if(dam < 1) dam=1 
			change_health(pid,-dam,id,"world")
			set_gravitychange(pid)
		}
		
	}
	
	
	
	
	return PLUGIN_CONTINUE
}

public stomp_magz(id)
{		
	
	new czas = 20 - player_intelligence[id]/20 - player_naszyjnikczasu[id] 
	if(czas<5)czas=5
	if (halflife_time()-bowdelay[id] <= czas && player_diablo[id]==0 && player_she[id]==0)
	{
		
		show_hudmessage(id, "Ten skill moze byc uzyty co kazde %i sekund", czas)
		return PLUGIN_CONTINUE
	}
	player_naladowany[id] = 1
	hudmsg(id,2.0,"Moc uzyta!")
	
	bowdelay[id]  = halflife_time()
	add_stomp_magz(id)
	return PLUGIN_CONTINUE
}

public add_stomp_magz(id)
{
	new dam
	if(player_intelligence[id]<100) dam = 50 + player_intelligence[id]
	else if(player_intelligence[id]<200&&player_intelligence[id]>100) dam = 150 + (player_intelligence[id]-100)/2
		else if(player_intelligence[id]<400&&player_intelligence[id]>200) dam = 200 + (player_intelligence[id]-200)/4
		
	
	message_begin(MSG_ONE , get_user_msgid("ScreenShake") , {0,0,0} ,id)
	write_short( 1<<14 );
	write_short( 1<<12 );
	write_short( 1<<14 );
	message_end();
	
	new inta = player_intelligence[id]
	new entlist[513]
	if(inta>210) inta = 210
	
	new numfound = find_sphere_class(id,"player",230.0+inta*2.0,entlist,512)
	
	
	
	for (new i=0; i < numfound; i++)
	{		
		new pid = entlist[i]
		new n_dam = dam
		
		if (pid == id || !is_user_alive(pid) || !is_user_alive(id))
			continue
		
		if (get_user_team(id) == get_user_team(pid))
			continue
		
		if (!(pev(pid, pev_flags) & FL_ONGROUND)) continue	
		
		
		message_begin(MSG_ONE , get_user_msgid("ScreenShake") , {0,0,0} ,pid)
		write_short( 1<<14 );
		write_short( 1<<12 );
		write_short( 1<<14 );
		message_end();
		n_dam  -= player_tarczam[pid]
		n_dam  -= player_dextery[pid]
		if(n_dam  < 1) n_dam =1 
		change_health(pid,-n_dam ,id,"world")			
	}
	
	return PLUGIN_CONTINUE
}

/* ==================================================================================================== */

public item_rot(id)
{
	if (used_item[id])
	{
		RemoveFlag(id,Flag_Rot)
		used_item[id] = false
	}
	else
	{
		if (find_ent_by_owner(-1,"Effect_Rot",id) > 0)
			return PLUGIN_CONTINUE
		
		Create_Rot(id)
		used_item[id] = true
	}
	
	return PLUGIN_CONTINUE
}

public Create_Rot(id)
{		
	new ent = Spawn_Ent("info_target")
	set_pev(ent,pev_classname,"Effect_Rot")
	set_pev(ent,pev_owner,id)
	set_pev(ent,pev_solid,SOLID_NOT)
	AddFlag(id,Flag_Rot)
	set_pev(ent,pev_nextthink, halflife_time() + 0.1)	
	
}

public Effect_Rot_Think(ent)
{		
	new id = pev(ent,pev_owner)
	if (!is_user_alive(id) || !HasFlag(id,Flag_Rot) || !freeze_ended  || player_b_fireshield[id] == 0)
	{
		Display_Icon(id,0,"dmg_bio",255,255,0)
		
		set_renderchange(id)
		
		remove_entity(ent)
		return PLUGIN_CONTINUE
	}
	
	
	Display_Icon(id,1,"dmg_bio",255,150,0)
	set_renderchange(id)
	
	new entlist[513]
	new numfound = find_sphere_class(id,"player",250.0,entlist,512)
	
	for (new i=0; i < numfound; i++)
	{		
		new pid = entlist[i]
		
		if (pid == id || !is_user_alive(pid))
			continue
		
		if (get_user_team(id) == get_user_team(pid))
			continue
		
		if(player_b_fireshield[id] >0 && player_frostShield[id]< 1){
			if (random_num(1,5) == 1 ) Display_Fade(pid,1<<14,1<<14,1<<16,255,155,50,230)
			change_health(pid,-25,id,"world")
			Effect_Bleed(pid,100)
			if(player_b_szarza_time[pid] <= floatround(halflife_time())) Create_Slow(pid,3)
			
		}
		if(player_frostShield[id]>1 ){
			if(player_b_szarza_time[pid] <= floatround(halflife_time())){
				Display_Fade(pid,2600,2600,0,0,0,255,50)
				efekt_slow_lodu(pid, 5)
			}
		}
		
	}
	if(player_b_fireshield[id] >0){
		change_health(id,-1,0,"world")
	}
	set_pev(ent,pev_nextthink, halflife_time() + 0.8)
	return PLUGIN_CONTINUE
}

/* ==================================================================================================== */

//Daze player
stock Create_Slow(id,seconds)
{		
	new ent = Spawn_Ent("info_target")
	set_pev(ent,pev_classname,"Effect_Slow")
	set_pev(ent,pev_owner,id)
	set_pev(ent,pev_ltime, halflife_time() + seconds + 0.1)
	set_pev(ent,pev_solid,SOLID_NOT)
	set_pev(ent,pev_nextthink, halflife_time() + 0.1)	
	
	AddFlag(id,Flag_Dazed)
}

public Effect_Slow_Think(ent)
{
	new id = pev(ent,pev_owner)
	if (pev(ent,pev_ltime) < halflife_time() || !is_user_alive(id))
	{
		Display_Icon(id,0,"dmg_heat",255,255,0)
		RemoveFlag(id,Flag_Dazed)
		set_user_maxspeed(id,245.0+player_dextery[id])
		remove_entity(ent)
		return PLUGIN_CONTINUE
	}
	
	set_user_maxspeed(id,245.0-50.0)
	Display_Icon(id,1,"dmg_heat",255,255,0)
	set_pev(ent,pev_nextthink, halflife_time() + 1.0)
	return PLUGIN_CONTINUE
}

/* ==================================================================================================== */

stock AddTimedFlag(id,flag,seconds)
{		
	new ent = Spawn_Ent("info_target")
	set_pev(ent,pev_classname,"Effect_Timedflag")
	set_pev(ent,pev_owner,id)
	set_pev(ent,pev_ltime, halflife_time() + seconds + 0.1)
	set_pev(ent,pev_solid,SOLID_NOT)
	set_pev(ent,pev_euser3,flag)			
	AddFlag(id,flag)	
	set_pev(ent,pev_nextthink, halflife_time() + 0.1)
}

public Effect_Timedflag_Think(ent)
{
	new id = pev(ent,pev_owner)
	if (pev(ent,pev_ltime) < halflife_time() || !is_user_alive(id))
	{
		RemoveFlag(id,pev(ent,pev_euser3))
		remove_entity(ent)
		return PLUGIN_CONTINUE
	}
	
	set_pev(ent,pev_nextthink, halflife_time() + 1.0)
	return PLUGIN_CONTINUE
}

/* ==================================================================================================== */

public item_illusion(id)
{
	if (used_item[id])
	{
		hudmsg(id,2.0,"Ten przedmiot mozesz uzyc raz na runde!")
		return PLUGIN_CONTINUE
	}
	
	AddTimedFlag(id,Flag_Illusion,7)
	message_begin( MSG_ONE, gmsgBartimer, {0,0,0}, id ) 
	write_byte( 7) 
	write_byte( 0 ) 
	message_end() 
	used_item[id] = true
	use_addtofullpack = true
	return PLUGIN_CONTINUE
	
}

/* ==================================================================================================== */


public item_dziewica(id)
{
	if (player_dziewica_using[id]==1)
	{
		RemoveFlag(id,Flag_Moneyshield)
		player_dziewica_using[id]=0
	}
	else
	{
		czas_itemu[id] = floatround(halflife_time())+2
		player_dziewica_using[id]=1
	}
	
	return PLUGIN_CONTINUE
	
	
}

public item_money_shield(id)
{
	if (used_item[id])
	{
		RemoveFlag(id,Flag_Moneyshield)
		used_item[id] = false
	}
	else
	{
		if (find_ent_by_owner(-1,"Effect_MShield",id) > 0)
			return PLUGIN_CONTINUE
		
		new ent = Spawn_Ent("info_target")
		set_pev(ent,pev_classname,"Effect_MShield")
		set_pev(ent,pev_owner,id)
		set_pev(ent,pev_solid,SOLID_NOT)		
		AddFlag(id,Flag_Moneyshield)	
		set_pev(ent,pev_nextthink, halflife_time() + 0.1)
		used_item[id] = true
	}
	
	return PLUGIN_CONTINUE
}

public Effect_MShield_Think(ent)
{
	new id = pev(ent,pev_owner)
	if (!is_user_alive(id) || cs_get_user_money(id) <= 0 || !HasFlag(id,Flag_Moneyshield) || !freeze_ended || player_b_money[id] == 0)
	{
		RemoveFlag(id,Flag_Moneyshield)
		
		set_renderchange(id)
		
		Display_Icon(id,0,"suithelmet_empty",255,255,255)
		remove_entity(ent)
		return PLUGIN_CONTINUE
	}
	
	if (cs_get_user_money(id)-250 < 0)
		cs_set_user_money(id,0)
	else
		cs_set_user_money(id,cs_get_user_money(id)-250)
	
	set_renderchange(id)
	
	Display_Icon(id,1,"suithelmet_empty",255,255,255)
	
	set_pev(ent,pev_nextthink, halflife_time() + 1.0)
	return PLUGIN_CONTINUE
}

/* ==================================================================================================== */

public item_mineLod(id)
{
	new count = 0
	new ents = -1
	ents = find_ent_by_owner(ents,"MineLod",id)
	while (ents > 0)
	{
		count++
		ents = find_ent_by_owner(ents,"MineLod",id)
	}
	
	if (count > 4)
	{
		hudmsg(id,2.0,"Mozesz polozyc maksymalnie 5 min na runde")
		return PLUGIN_CONTINUE
	}
	
	
	new origin[3]
	pev(id,pev_origin,origin)
	
	new ent = Spawn_Ent("info_target")
	set_pev(ent,pev_classname,"MineLod")
	set_pev(ent,pev_owner,id)
	set_pev(ent,pev_movetype,MOVETYPE_TOSS)
	set_pev(ent,pev_origin,origin)
	set_pev(ent,pev_solid,SOLID_BBOX)
	
	engfunc(EngFunc_SetModel, ent, "addons/amxmodx/diablo/mine.mdl")  
	engfunc(EngFunc_SetSize,ent,Float:{-16.0,-16.0,0.0},Float:{16.0,16.0,2.0})
	
	drop_to_floor(ent)
	
	entity_set_float(ent,EV_FL_nextthink,halflife_time() + 0.01) 
	
	set_rendering(ent,kRenderFxNone, 10,10,50, kRenderTransTexture,70)	
	
	use_addtofullpack = true
	
	return PLUGIN_CONTINUE
}

public item_mineL(id)
{
	new count = 0
	new ents = -1
	ents = find_ent_by_owner(ents,"MineL",id)
	while (ents > 0)
	{
		count++
		ents = find_ent_by_owner(ents,"MineL",id)
	}
	
	if (count > 4)
	{
		hudmsg(id,2.0,"Mozesz polozyc maksymalnie 5 min na runde")
		return PLUGIN_CONTINUE
	}
	
	
	new origin[3]
	pev(id,pev_origin,origin)
	
	new ent = Spawn_Ent("info_target")
	set_pev(ent,pev_classname,"MineL")
	set_pev(ent,pev_owner,id)
	set_pev(ent,pev_movetype,MOVETYPE_TOSS)
	set_pev(ent,pev_origin,origin)
	set_pev(ent,pev_solid,SOLID_BBOX)
	
	engfunc(EngFunc_SetModel, ent, "addons/amxmodx/diablo/mine.mdl")  
	engfunc(EngFunc_SetSize,ent,Float:{-16.0,-16.0,0.0},Float:{16.0,16.0,2.0})
	
	drop_to_floor(ent)
	
	entity_set_float(ent,EV_FL_nextthink,halflife_time() + 0.01) 
	
	set_rendering(ent,kRenderFxNone, 10,50,10, kRenderTransTexture,70)	
	
	use_addtofullpack = true
	
	return PLUGIN_CONTINUE
}

public item_mine(id)
{
	new count = 0
	new ents = -1
	ents = find_ent_by_owner(ents,"Mine",id)
	while (ents > 0)
	{
		count++
		ents = find_ent_by_owner(ents,"Mine",id)
	}
	
	if (count > 2)
	{
		hudmsg(id,2.0,"Mozesz polozyc maksymalnie 3 miny na runde")
		return PLUGIN_CONTINUE
	}
	
	
	new origin[3]
	pev(id,pev_origin,origin)
	
	new ent = Spawn_Ent("info_target")
	set_pev(ent,pev_classname,"Mine")
	set_pev(ent,pev_owner,id)
	set_pev(ent,pev_movetype,MOVETYPE_TOSS)
	set_pev(ent,pev_origin,origin)
	set_pev(ent,pev_solid,SOLID_BBOX)
	
	engfunc(EngFunc_SetModel, ent, "addons/amxmodx/diablo/mine.mdl")  
	
	entity_set_int(ent, EV_INT_sequence, 1)
	set_pev(ent,pev_framerate, 1.0 );
	
	engfunc(EngFunc_SetSize,ent,Float:{-16.0,-16.0,0.0},Float:{16.0,16.0,2.0})
	
	drop_to_floor(ent)
	
	entity_set_float(ent,EV_FL_nextthink,halflife_time() + 0.01) 
	
	set_rendering(ent,kRenderFxNone, 0,255,0, kRenderTransTexture,250)	
	
	use_addtofullpack = true
	
	return PLUGIN_CONTINUE
}

/* ==================================================================================================== */

public item_teamshield(id)
{
	if (used_item[id])
	{
		RemoveFlag(id,Flag_Teamshield)
		used_item[id] = false
		set_renderchange(id)
	}
	else
	{
		new target = Find_Best_Angle(id,1000.0,true)
		
		if (!is_valid_ent(target))
		{
			hudmsg(id,2.0,"Zaden cel nie jest zasiegu do tarczy")
			return PLUGIN_CONTINUE
		}
		
		if (pev(target,pev_rendermode) == kRenderTransTexture || player_item_id[target] == 17 || player_class[target] == Ninja || player_class[target] == Ognik)
		{
			hudmsg(id,2.0,"Nie mozna wyczarowac tarczy na niewidzialnym graczu")
			return PLUGIN_CONTINUE
		}
		
		if (find_ent_by_owner(-1,"Effect_Teamshield",id) > 0)
			return PLUGIN_CONTINUE
	
		
		new ent = Spawn_Ent("info_target")
		set_pev(ent,pev_classname,"Effect_Teamshield")
		set_pev(ent,pev_owner,id)
		set_pev(ent,pev_solid,SOLID_NOT)
		set_pev(ent,pev_nextthink, halflife_time() + 0.1)	
		set_pev(ent,pev_euser2, target)	
		
		AddFlag(id,Flag_Teamshield)
		AddFlag(target,Flag_Teamshield_Target)
		used_item[id] = true
		
		set_renderchange(target)
	}
	
	return PLUGIN_CONTINUE
}

public Effect_Teamshield_Think(ent)
{
	new id = pev(ent,pev_owner)
	new victim = pev(ent,pev_euser2)
	
	new Float: vec1[3]
	new Float: vec2[3]
	new Float: vec3[3]
	
	entity_get_vector(id,EV_VEC_origin,vec1)
	entity_get_vector(victim ,EV_VEC_origin,vec2)
	
	new hit = trace_line ( id, vec1, vec2, vec3 )
	
	if (hit != victim || !is_user_alive(id) || !is_user_alive(victim) || !Can_Trace_Line(id,victim) || !UTIL_In_FOV(id,victim) || !HasFlag(id,Flag_Teamshield) || !freeze_ended)
	{
		RemoveFlag(id,Flag_Teamshield)
		RemoveFlag(victim,Flag_Teamshield_Target)
		remove_entity(ent)
		set_renderchange(victim)
		return PLUGIN_CONTINUE
	}
	else		
		set_pev(ent,pev_nextthink, halflife_time() + 0.3)
	
	new origin1[3]
	new origin2[3]
	
	get_user_origin(id,origin1)
	get_user_origin(victim,origin2)
	
	message_begin(MSG_BROADCAST,SVC_TEMPENTITY) 
	write_byte (TE_BEAMPOINTS)
	write_coord(origin1[0])
	write_coord(origin1[1])
	write_coord(origin1[2]+8)
	write_coord(origin2[0])
	write_coord(origin2[1])
	write_coord(origin2[2]+8)
	write_short(sprite_laser);
	write_byte(1) // framestart 
	write_byte(1) // framerate 
	write_byte(3) // life 
	write_byte(5) // width 
	write_byte(10) // noise 
	write_byte(0) // r, g, b (red)
	write_byte(255) // r, g, b (green)
	write_byte(0) // r, g, b (blue)
	write_byte(45) // brightness 
	write_byte(5) // speed 
	message_end()    
	
	if (get_user_health(victim)+player_b_teamheal[id] <= get_maxhp(victim)){
		change_health(victim,player_b_teamheal[id]/10+1,0,"")
		Give_Xp(id, get_cvar_num("diablo_xpbonus")/50+1)
	}
	
	set_renderchange(victim) 
	
	return PLUGIN_CONTINUE
}

/* ==================================================================================================== */	

//Find the owner that has target as target and the specific classname
public find_owner_by_euser(target,classname[])
{
	new ent = -1
	ent = find_ent_by_class(ent,classname)
	
	while (ent > 0)
	{
		if (pev(ent,pev_euser2) == target)
			return pev(ent,pev_owner)
		ent = find_ent_by_class(ent,classname)
	}
	
	return -1
}

/* ==================================================================================================== */


public freeze_over1() {
	round_status=1
	agi = BASE_SPEED;
	new players[32], num
	get_players(players,num,"a")	
	
	for(new i=0 ; i<num ; i++)
	{
		set_speedchange(players[i])
	}
}

public freeze_begin1() {
	round_status=0
	g_carrier=-1
	kill_all_entity("copy")
}

public funcReleaseVic(id)  {	
	DemageTake[id]=0
	remove_task(id+GLUTON)
}

public funcReleaseVic2(id)  {	
	agi = BASE_SPEED;
	if(round_status==1)
		set_speedchange(id)
}

public funcDemageVic(id,attacker)  {
	id-=GLUTON
	if(get_user_health(id)>10)
		set_task(2.0, "funcDemageVic", id+GLUTON)
	DoDamage(id, attacker1, 5);
}

public set_speedchange(id) {
	
	if(DemageTake[id]==1) {
		agi=(BASE_SPEED / 2)
		
	}
	else agi=BASE_SPEED
	if (is_user_connected(id) && freeze_ended)
	{
		new speeds
		new d = player_dextery[id] - player_strength[id]/5
		if(d>50){
			d -= 50 
			d = d/5
			d +=50
		}
		
		speeds= floatround(d*1.3)
		
		if(player_class[id] == Troll){
			speeds = 0 + floatround(d*0.6)
			agi= BASE_SPEED - BASE_SPEED /3
		} 
		else if(player_class[id] == Ninja || player_class[id] == Samurai) speeds = 40 + floatround(d*1.3) + player_nal[id]* 25
		else if(player_class[id] == Zabojca) speeds = 10 + floatround(d*1.5)
		else if(player_class[id] == Barbarzynca) speeds = -10 + floatround(d*1.3)
		else if(player_class[id] == Kusznik) speeds = -13 + floatround(d*1.3)
		else if(player_class[id] == Lucznik) speeds = -7 + floatround(d*1.3)
		else if(player_class[id] == Drzewiec){ 
			speeds = -50 + floatround(d*1.3) - player_strength[id]/2
			if(speeds < -150) speeds = -150
		}
		if(speeds<-25) speeds=-25;
			
		if(player_timed_speed_aim[id]>halflife_time()){
			speeds += 90
		}
		if(player_timed_speed[id]>halflife_time()){
			speeds += 50
		}
		if(bieg[id] > floatround(halflife_time()) || player_iszombie[id]==4){
			if(bieg[id] > floatround(halflife_time()) && player_class[id] == Kuroliszek){
				speeds += player_dextery[id]*5 + 200
			}else{
				speeds += 700
			}
		}
		if(KlasyZlicz[player_class[id]]==1) speeds += 10
		else if(KlasyZlicz[player_class[id]] >=6 && clEvent != 2) speeds -= 40
		else if(KlasyZlicz[player_class[id]] >=4 && clEvent != 2) speeds -= 20
		
		if(player_b_tarczaograon[id] == 1 ||  ofiara_totem_enta[id] > floatround(halflife_time())  ){
			agi = 1.0
			speeds = 0
		}
		if(ofiara_totem_lodu[id] > floatround(halflife_time())){
			agi = agi / 3
			if(speeds >100) speeds = 100
			speeds = (speeds/2) * 100 / (200 - (player_b_nieust[id]+player_b_nieust2[id])) 
		}
		
		if(player_iszombie[id]==1)  speeds = 0
		if(player_iszombie[id]==3)  speeds += 100
		
		
		new ss = player_speedbonus[id]
		if(player_class[id] == Troll ){
			ss = ss/2
			if(player_lvl[id] > prorasa && inbattle[id]==0) ss += 80
		}
		if(player_ruch[id]>0 && inbattle[id]==0) ss += player_ruch[id]
		
		
		new Float:razem = agi + speeds + ss
		if(player_class[id]==Ninja && razem>400.0){
			razem = 400.0
		}
		

		if(player_iszombie[id]==4 || bieg[id] > floatround(halflife_time()) ){
			if(razem > 700.0) razem = 700.0
			client_cmd(id, "cl_forwardspeed 700");
			client_cmd(id, "cl_sidespeed 700");
			client_cmd(id, "cl_backspeed 700");
		}else if(razem>500.0 || player_bats[id]==2) razem = 500.0
		set_user_maxspeed(id,razem)
	}
}

public set_renderchange(id) {
	if(is_user_connected(id) && is_user_alive(id))
	{			
		if(!task_exists(id+TASK_FLASH_LIGHT)  || player_b_szarza_time[id] > floatround(halflife_time()))
		{
			new render=255
			if (player_class[id] == Ninja)
			{
				render =3			
				if(render<0) render=5
				
				if(HasFlag(id,Flag_Moneyshield)||HasFlag(id,Flag_Rot)||HasFlag(id,Flag_Teamshield_Target)) render*=2	
				
				set_user_rendering(id, kRenderFxNone, 0, 0, 0, kRenderTransAlpha, render)
			}
			else if (player_class[id] == Ognik)
			{
				set_user_rendering(id, kRenderFxNone, 0, 0, 0, kRenderTransAlpha, 0)
			}
			else if (player_class[id] == Zjawa)
			{
				render = 100 - player_intelligence[id]/2
				if(render <75) render = 75
				if(player_b_inv[id]>0 && player_b_inv[id] < render) render = player_b_inv[id]
				set_user_rendering(id, kRenderFxNone, 0, 0, 0, kRenderTransAlpha, render)
			}
			else if (player_class[id] == Mroczny)
			{
				render = 80 - player_intelligence[id]/4
				if(render <55) render = 55
				set_user_rendering(id, kRenderFxNone, 0, 0, 0, kRenderTransAlpha, render)
			}
			else if(HasFlag(id,Flag_Moneyshield)||HasFlag(id,Flag_Rot)||HasFlag(id,Flag_Teamshield_Target))
			{
				if (player_b_usingwind[id]==1  && !(invisible_cast[id]==1)) set_user_rendering(id,kRenderFxNone, 0,0,0, kRenderTransTexture,75)
				
				if(HasFlag(id,Flag_Moneyshield)) set_user_rendering(id,kRenderFxGlowShell,0,0,0,kRenderNormal,16)  
				
				if(HasFlag(id,Flag_Teamshield_Target)) set_rendering ( id, kRenderFxGlowShell, 0,200,0, kRenderFxNone, 0 ) 
			}
			else if(invisible_cast[id]==1)
			{
				if(player_b_inv[id]>0) set_user_rendering(id, kRenderFxNone, 0, 0, 0, kRenderTransAlpha, floatround((10.0/255.0)*(255-player_b_inv[id])))
				else set_user_rendering(id, kRenderFxNone, 0, 0, 0, kRenderTransAlpha, 5)
			}				
			else
			{
				render = 255 
				if(player_b_inv[id]>0) render = player_b_inv[id]
				
				set_user_rendering(id, kRenderFxNone, 0, 0, 0, kRenderTransAlpha, render)
			}			
			
			if(player_b_blink4[id] == 2){
				if (player_b_blink2[id] + 10 < halflife_time() && player_class[id] != Gon){
					player_b_blink4[id] = 1
				}
				if (player_naladowany[id] + 10 < halflife_time() && player_class[id] == Gon){
					player_b_blink4[id] = 1
				}
				if(player_b_blink4[id] == 2) set_user_rendering(id, kRenderFxNone, 0, 0, 0, kRenderTransAlpha, 5)
			}
			
			if(player_class[id] == Zabojca || player_class[id] == Zjawa || (player_class[id] == Gon && player_lvl[id]>prorasa) ){
				if(player_timed_inv[id]>halflife_time()){
					set_user_rendering(id, kRenderFxNone, 0, 0, 0, kRenderTransAlpha, 7)
				}
				write_hud(id)
			}		
			if(player_class[id] == Mroczny){
				new button2 = get_user_button(id);
				if ( (button2 & IN_DUCK)){
					set_rendering(id,kRenderFxGlowShell,0,0,0 ,kRenderTransAlpha, 0 );
				}
				else if(player_timed_inv[id]>halflife_time()){
					set_user_rendering(id, kRenderFxNone, 0, 0, 0, kRenderTransAlpha, 7)
				}

				write_hud(id)
			}	
			
			if(player_iszombie[id]>0 || (player_class[id]==Zmij && on_knife[id])){
				set_user_rendering(id, kRenderFxNone, 0, 0, 0, kRenderTransAlpha, 255)
				if(cs_get_user_team(id) == CS_TEAM_CT) set_rendering ( id, kRenderFxGlowShell,0,0,55, kRenderFxNone, 75 )
				if(cs_get_user_team(id) == CS_TEAM_T) set_rendering ( id, kRenderFxGlowShell,55,0,0, kRenderFxNone, 75 )
				
			} 
			
			if(bieg[id] > floatround(halflife_time())){
				set_user_rendering(id, kRenderFxNone, 0, 0, 0, kRenderTransAlpha, 1)
			}
			if(player_b_tarczaograon[id]){
				set_rendering ( id, kRenderFxGlowShell,50,50,00, kRenderFxNone, 50 )
			}
			if(player_lustro[id]==2){
				set_user_rendering(id, kRenderFxNone, 0, 0, 0, kRenderTransAlpha, 1)			
			}
			
			if(ofiara_totem_enta[id] > floatround(halflife_time())  ){
				set_rendering ( id, kRenderFxGlowShell,0,255,0, kRenderFxNone, 10 )
			}
			if(ofiara_totem_lodu[id] > floatround(halflife_time())){
				set_rendering ( id, kRenderFxGlowShell, 0,150,255, kRenderFxNone, 10 )
			}
			if(player_bats[id]==2) set_user_rendering(id, kRenderFxNone, 0, 0, 0, kRenderTransAlpha, 0)
			
			
			
		}	
		else set_user_rendering(id,kRenderFxGlowShell,flashlight_r,flashlight_g,flashlight_b,kRenderNormal,4)
	}
}

public set_gravitychange(id) {
	if(is_user_alive(id) && is_user_connected(id))
	{
		if(player_class[id] == Ninja  )
		{
			if(player_b_gravity[id]>11) set_user_gravity(id, 0.05)
			if(player_b_gravity[id]>6) set_user_gravity(id, 0.17)
			else if(player_b_gravity[id]>3) set_user_gravity(id, 0.2)
			else set_user_gravity(id, 0.25)
		}
		else if(player_class[id] == Samurai  )
		{
			if(player_b_gravity[id]>6) set_user_gravity(id, 0.37)
			else if(player_b_gravity[id]>3) set_user_gravity(id, 0.45)
			else set_user_gravity(id, 0.70)
		}
		else if(player_class[id] == Demon || player_class[id]==Zmij)
		{
			set_user_gravity(id, 0.5*(1.0-player_b_gravity[id]/13.0))
		}
		else if(player_class[id] == Zabojca )
		{
			set_user_gravity(id, 0.5*(1.0-player_b_gravity[id]/13.0))
		}
		else
		{
			set_user_gravity(id,1.0*(1.0-player_b_gravity[id]/13.0))
		}
		
		if(player_iszombie[id]==1)  set_user_gravity(id, 1.0)
		if(player_iszombie[id]==2)  set_user_gravity(id, 0.9)
		if(player_iszombie[id]==3 || player_iszombie[id]==4)  set_user_gravity(id, 0.7)
		
		if(player_grawitacja[id] >0){
			set_user_gravity(id, player_grawitacja[id] /100.0)
		}
		
		if( ofiara_totem_enta[id] > floatround(halflife_time())  ){
			set_user_gravity(id, 2.0)
		}
		
		if( ofiara_gravi[id] > floatround(halflife_time())  ){
			set_user_gravity(id, 0.1)
		}
		
	}
	
}

public cmd_who(id) {
	static motd[2000],header[40],name[32],len,i
	len = 0
	new team[32]
	static players[32], numplayers
	get_players(players, numplayers)
	new playerid
	len += formatex(motd[len],sizeof motd - 1 - len,"<body bgcolor=#000000 text=#FFB000>")
	len += formatex(motd[len],sizeof motd - 1 - len,"<center><table width=700>")
	len += formatex(motd[len],sizeof motd - 1 - len,"<tr><td>Name</td><td>Klasa</td><td>Level</td><td>Team</td></tr>")
	formatex(header,sizeof header - 1,"Diablo Mod Statystyki")
        
	for (i=0; i< numplayers; i++)
	{
		playerid = players[i]
		if(!is_user_alive(playerid))continue;
		if ( get_user_team(playerid) == 1 ) team = "T"
		else if ( get_user_team(playerid) == 2 ) team = "CT"
		else team = "Spec"
		get_user_name( playerid, name, 31 )
		get_user_name( playerid, name, 31 )
		if(player_lvl[playerid] <prorasa){
			len += formatex(motd[len],sizeof motd - 1 - len,"<tr><td>%s</td><td>%s</td><td>%d</td><td>%s</td></tr>",name,Race[player_class[playerid]], player_lvl[playerid],team)
		} else {
			len += formatex(motd[len],sizeof motd - 1 - len,"<tr><td>%s</td><td>%s</td><td>%d</td><td>%s</td></tr>",name,ProRace[player_class[playerid]], player_lvl[playerid],team)
		}
		
        }
        len += formatex(motd[len],sizeof motd - 1 - len,"</table></center></font></body>")
        
        show_motd(id,motd,header)     
}


public det_fade(id) {
	if (wear_sun[id] == 1){
		Display_Icon(id ,ICON_FLASH ,ICON_S ,0,255,0)
		Display_Fade(id,1,1,1<<12,0,0,0,0)
	}
	if (wear_sun[id] == 0){
		Display_Icon(id ,ICON_HIDE ,ICON_S ,0,255,0)
	}
	new Float:flGameTime = get_gametime()
	if(	id != g_iCurrentFlasher
		&&	g_flCurrentGameTime == flGameTime
		&&	cs_get_user_team(id) == cs_get_user_team(g_iCurrentFlasher)	
		&&  is_user_connected(id)) // edit by Filip, bez tego wyskakiwa³y error logi 
	{		
		message_begin(MSG_ONE, g_msg_screenfade, {0,0,0}, id)
		write_short(1)
		write_short(1)
		write_short(1)
		write_byte(0)
		write_byte(0)
		write_byte(0)
		write_byte(255)
		message_end()
	}
}

public changeskin(id,reset){
	if(!is_user_connected(id)) return PLUGIN_CONTINUE
	if(player_skin[id]==1 ) {
		cs_set_user_model(id,"assassin") 
		return PLUGIN_CONTINUE
	}else if(player_skin[id]==2) {
		cs_set_user_model(id,"gsg9z") 
		return PLUGIN_CONTINUE
	}else if(player_skin[id]==4) {
		cs_set_user_model(id,"twister_zombie") 
		return PLUGIN_CONTINUE
	}else if(player_skin[id]==3) {
		cs_set_user_model(id,"trujace_zombie") 
		return PLUGIN_CONTINUE
	}else if(player_skin[id]==5) {
		cs_set_user_model(id,"zombie_source") 
		return PLUGIN_CONTINUE
	}else if(player_skin[id]==6) {
		cs_set_user_model(id,"ghost") 
		return PLUGIN_CONTINUE
	}else if(player_class[id]==Zmij && on_knife[id]&& is_user_alive(id)){
		cs_set_user_model(id,"dragon") 
		return PLUGIN_CONTINUE
	}else if(isevent>0){
		if(isevent_team!=id && get_user_team(id) == get_user_team(isevent_team)){
			if(player_ran[id]==1) cs_set_user_model(id,"trujace_zombie") 
			if(player_ran[id]==2) cs_set_user_model(id,"twister_zombie") 
			if(player_ran[id]==3) cs_set_user_model(id,"zombie_source") 
			if(player_ran[id]==4) cs_set_user_model(id,"ghost") 
			return PLUGIN_CONTINUE
		}
	}
		
	if (id<1 || id>32 || !is_user_connected(id) || player_she[id]==1 || player_diablo[id]==1) return PLUGIN_CONTINUE
	if (reset==1){
		cs_reset_user_model(id)
		skinchanged[id]=false
		return PLUGIN_HANDLED
		}else if (reset==2){
		//cs_set_user_model(id,"goomba")
		cs_set_user_model(id,"zombie")
		skinchanged[id]=true
		return PLUGIN_HANDLED
		}else{
		//new newSkin[32]
		new num = random_num(0,3)
		
		if (get_user_team(id)==1){
			//add(newSkin,31,CTSkins[num])
			cs_set_user_model(id,CTSkins[num])
			}else{
			//client_print(0, print_console, "CT mole, using new skin %s", TSkins[num])
			//add(newSkin,31,TSkins[num])
			cs_set_user_model(id,TSkins[num])
		}
		
		skinchanged[id]=true
	}
	
	return PLUGIN_CONTINUE
}

public refill_ammo2(id) {	
	refill_ammo(id)
}
stock refill_ammo(id) {	
	new wpnid
	if(!is_user_alive(id) || pev(id,pev_iuser1) || id <1) return;
	
	cs_set_user_armor(id,200,CS_ARMOR_VESTHELM);
	
	new wpn[32],clip,ammo
	wpnid = get_user_weapon(id, clip, ammo)
	get_weaponname(wpnid,wpn,31)
	
	new wEnt;
	
	// set clip ammo
	wpnid = get_weaponid(wpn)
	//wEnt = get_weapon_ent(id,wpnid);
	wEnt = get_weapon_ent(id,wpnid);
	cs_set_weapon_ammo(wEnt,maxClip[wpnid]);
	
}

stock get_weapon_ent(id,wpnid=0,wpnName[]="") {
	// who knows what wpnName will be
	static newName[32];
	
	// need to find the name
	if(wpnid) get_weaponname(wpnid,newName,31);
	
	// go with what we were told
	else formatex(newName,31,"%s",wpnName);
	
	// prefix it if we need to
	if(!equal(newName,"weapon_",7))
		format(newName,31,"weapon_%s",newName);
	
	new ent;
	while((ent = engfunc(EngFunc_FindEntityByString,ent,"classname",newName)) && pev(ent,pev_owner) != id) {}
	
	return ent;
}

DoDamage(iTargetID, iShooterID, iDamage/*, iDamageCause, bIsWeaponID = false, iHeadShot = 0*/) {
	
	if(is_user_connected(iTargetID)&&is_user_connected(iShooterID))
		if ( is_user_alive(iTargetID))
	{	
		new bool:bPlayerDied = false;
		new iHP = get_user_health(iTargetID);
		
		if ( ( iHP - iDamage ) <= 0 )
			bPlayerDied = true;
		
		if (bPlayerDied)
		{
			// engine.inc set_msg_block function
			//set_msg_block(g_iGameMsgDeath, BLOCK_ONCE);
			user_kill(iTargetID, 1);
		}
		else
			change_health(iTargetID,-iDamage,0,"")
		
		new sShooterName[32];
		get_user_name(iShooterID, sShooterName, 31);
		
		if (bPlayerDied)
		{
			if ( iShooterID != iTargetID )
			{
				if ( get_user_team(iShooterID) != get_user_team(iTargetID) ) change_frags(iShooterID, iTargetID,0)
				
				//LogKill(iShooterID, iTargetID, sWeaponOrMagicName);
			}
			
			//AddXP(iShooterID, BM_XP_KILL, iTargetID); // bmxphandler.inc
			award_item(iShooterID,0)
			award_kill(iShooterID,iTargetID)
		}
	}
}

public funcDemageVic3(id) {

}

public funcReleaseVic3(id) {	
	DemageTake1[id]=1
}

public event_flashlight(id) {
	if(!get_cvar_num("flashlight_custom")) {
		return;
	}
	
	if(flashlight[id]) {
		flashlight[id] = 0;
	}
	else {
		if(flashbattery[id] > 0) {
			flashlight[id] = 1;
		}
	}
	
	if(!task_exists(TASK_CHARGE+id)) {
		new parms[1];
		parms[0] = id;
		set_task((flashlight[id]) ? get_cvar_float("flashlight_drain") : get_cvar_float("flashlight_charge"),"charge",TASK_CHARGE+id,parms,1);
	}
	
	message_begin(MSG_ONE,get_user_msgid("Flashlight"),{0,0,0},id);
	write_byte(flashlight[id]);
	write_byte(flashbattery[id]);
	message_end();
	
	entity_set_int(id,EV_INT_effects,entity_get_int(id,EV_INT_effects) & ~EF_DIMLIGHT);
}

public charge(parms[]) {
	if(!get_cvar_num("flashlight_custom")) {
		return;
	}
	
	new id = parms[0];
	
	if(flashlight[id]) {
		flashbattery[id] -= 1;
	}
	else {
		flashbattery[id] += 1;
	}
	
	message_begin(MSG_ONE,get_user_msgid("FlashBat"),{0,0,0},id);
	write_byte(flashbattery[id]);
	message_end();
	
	if(flashbattery[id] <= 0) {
		flashbattery[id] = 0;
		flashlight[id] = 0;
		
		message_begin(MSG_ONE,get_user_msgid("Flashlight"),{0,0,0},id);
		write_byte(flashlight[id]);
		write_byte(flashbattery[id]);
		message_end();
		
		// don't return so we can charge it back up to full
	}
	else if(flashbattery[id] >= MAX_FLASH) 
	{
		flashbattery[id] = MAX_FLASH
		return; // return because we don't need to charge anymore
	}
	
	set_task((flashlight[id]) ? get_cvar_float("flashlight_drain") : get_cvar_float("flashlight_charge"),"charge",TASK_CHARGE+id,parms,1)
}
////////////////////////////////////////////////////////////////////////////////
//                         REVIVAL KIT - NOT ALL                              //
////////////////////////////////////////////////////////////////////////////////
public message_clcorpse()
{	
	return PLUGIN_HANDLED
}

public event_hltv()
{
	fm_remove_entity_name("fake_corpse")
	fm_remove_entity_name("Mine")
	fm_remove_entity_name("MineL")
	fm_remove_entity_name("MineLO")
	fm_remove_entity_name("MineLod")
	fm_remove_entity_name("fireball")
	fm_remove_entity_name("Effect_ognik_Totem")
	
	
	fm_remove_entity_name("Mine")
	fm_remove_entity_name("dbmod_shild")
	
	static players[32], num
	get_players(players, num, "a")
	for(new i = 0; i < num; i++)
	{
		if(is_user_connected(players[i]))
		{
			set_task(0.0, "funcReleaseVic", i)
			reset_player(players[i])
			msg_bartime(players[i], 0)
			trace_bool[players[i]] = 0
		}
	}
}

public reset_player(id)
{
	remove_task(TASKID_REVIVE + id)
	remove_task(TASKID_RESPAWN + id)
	remove_task(TASKID_CHECKRE + id)
	remove_task(TASKID_CHECKST + id)
	remove_task(TASKID_ORIGIN + id)
	remove_task(TASKID_SETUSER + id)
	remove_task(GLUTON+id)
	
	
	g_revive_delay[id] 	= 0.0
	g_wasducking[id] 	= false
	g_body_origin[id] 	= Float:{0.0, 0.0, 0.0}
	
}

public fwd_playerpostthink(id)
{
	if(!is_user_connected(id)) return FMRES_IGNORED
	
	if(g_haskit[id]>0){
		
		if(!is_user_alive(id))
		{
			Display_Icon(id ,ICON_HIDE ,"rescue" ,0,160,0)
			return FMRES_IGNORED
		}
		
		new body = find_dead_body(id)
		if(fm_is_valid_ent(body))
		{
			new lucky_bastard = pev(body, pev_owner)
			
			if(!is_user_connected(lucky_bastard))
				return FMRES_IGNORED
			
			new lb_team = get_user_team(lucky_bastard)
			if(lb_team == 1 || lb_team == 2 )
				Display_Icon(id ,ICON_FLASH ,"rescue" ,0,160,0)
		}
		else
			Display_Icon(id , ICON_SHOW,"rescue" ,0,160,0)
	}
	return FMRES_IGNORED
}

public task_check_dead_flag(id)
{
	if(!is_user_connected(id) || is_user_alive(id))
		return
	
	if(pev(id, pev_deadflag) == DEAD_DEAD)
		create_fake_corpse(id)
	else
		set_task(0.5, "task_check_dead_flag", id)
}	

public create_fake_corpse(id)
{
	set_pev(id, pev_effects, EF_NODRAW)
	
	static model[32]
	cs_get_user_model(id, model, 31)
	
	static player_model[64]
	format(player_model, 63, "models/player/%s/%s.mdl", model, model)
	
	static Float: player_origin[3]
	pev(id, pev_origin, player_origin)
	
	static Float:mins[3]
	mins[0] = -16.0
	mins[1] = -16.0
	mins[2] = -34.0
	
	static Float:maxs[3]
	maxs[0] = 16.0
	maxs[1] = 16.0
	maxs[2] = 34.0
	
	if(g_wasducking[id])
	{
		mins[2] /= 2
		maxs[2] /= 2
	}
	
	static Float:player_angles[3]
	pev(id, pev_angles, player_angles)
	player_angles[2] = 0.0
	
	new sequence = pev(id, pev_sequence)
	
	new ent = fm_create_entity("info_target")
	if(ent)
	{
		set_pev(ent, pev_classname, "fake_corpse")
		engfunc(EngFunc_SetModel, ent, player_model)
		engfunc(EngFunc_SetOrigin, ent, player_origin)
		engfunc(EngFunc_SetSize, ent, mins, maxs)
		set_pev(ent, pev_solid, SOLID_TRIGGER)
		set_pev(ent, pev_movetype, MOVETYPE_TOSS)
		set_pev(ent, pev_owner, id)
		set_pev(ent, pev_angles, player_angles)
		set_pev(ent, pev_sequence, sequence)
		set_pev(ent, pev_frame, 9999.9)
	}	
}

public fwd_emitsound(id, channel, sound[]) 
{
	if(!is_user_alive(id) || !g_haskit[id])
		return FMRES_IGNORED	
		
	if(equal(sound, "common/wpn_denyselect.wav"))
	{
		if(!casting[id])Use_Spell(id)
	}
	
	if(!equali(sound, "common/wpn_denyselect.wav"))
		return FMRES_IGNORED	
	
	if(task_exists(TASKID_REVIVE + id))
		return FMRES_IGNORED
	
	if(!(fm_get_user_button(id) & IN_USE))
		return FMRES_IGNORED
	
	new body = find_dead_body(id)
	if(!fm_is_valid_ent(body))
		return FMRES_IGNORED
	
	new lucky_bastard = pev(body, pev_owner)
	new lb_team = get_user_team(lucky_bastard)
	if(lb_team != 1 && lb_team != 2)
		return FMRES_IGNORED
	
	static name[32]
	get_user_name(lucky_bastard, name, 31)
	client_print(id, print_chat, "Reviving %s", name)
	
	new revivaltime = get_pcvar_num(cvar_revival_time)
	if(player_class[id] == Ghull) revivaltime = 1
	msg_bartime(id, revivaltime)
	
	new Float:gametime = get_gametime()
	g_revive_delay[id] = gametime + float(revivaltime) - 0.01
	
	emit_sound(id, CHAN_AUTO, SOUND_START, VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
	set_task(0.0, "task_revive", TASKID_REVIVE + id)
	
	return FMRES_SUPERCEDE
}

public task_revive(taskid)
{
	
	new id = taskid - TASKID_REVIVE
	
	if(!is_user_alive(id))
	{
		failed_revive(id)
		return FMRES_IGNORED
	}
	
	if(!(fm_get_user_button(id) & IN_USE))
	{
		failed_revive(id)
		return FMRES_IGNORED
	}
	new body = find_dead_body(id)
	
	
	if(!fm_is_valid_ent(body))
	{
		failed_revive(id)
		return FMRES_IGNORED
	}
	
	new lucky_bastard = pev(body, pev_owner)
	
	if(!is_user_connected(lucky_bastard))
	{
		failed_revive(id)
		return FMRES_IGNORED
	}
	
	new lb_team = get_user_team(lucky_bastard)
	if(lb_team != 1 && lb_team != 2)
	{
		failed_revive(id)
		return FMRES_IGNORED
	}
	
	
	static Float:velocity[3]
	pev(id, pev_velocity, velocity)
	velocity[0] = 0.0
	velocity[1] = 0.0
	set_pev(id, pev_velocity, velocity)
	
	new Float:gametime = get_gametime()
	if(g_revive_delay[id] < gametime)
	{
		if(findemptyloc(body, 10.0))
		{
			fm_remove_entity(body)
			emit_sound(id, CHAN_AUTO, SOUND_FINISHED, VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
			
			new args[2]
			args[0]=lucky_bastard
			new pln = get_playersnum() 
			if(pln > 12) pln  = 12
			if(player_class[id]==Ghull)
			{
				player_nal[id]++
				change_health(id, 20 + player_intelligence[id]/10, id, "world")
				ghull_max[id]++
				if (get_user_team(id) == get_user_team(lucky_bastard) &&player_lich[id]>0) my_zombie(lucky_bastard, id)
			}else{
				if(get_user_team(id)!=get_user_team(lucky_bastard))
				{
					change_health(id,40,0,"")
					args[1]=1
					new exp = calc_award_goal_xp(id,get_cvar_num("diablo_xpbonus2"),0) * pln /2
					Give_Xp(id,exp)	
					player_wys[id]=1
				}
				else
				{
					if(player_class[id]==Nekromanta || player_class[id]==Heretyk){
						if(ultra_armor[id] < 1 && player_class[id]==Nekromanta  && player_lvl[id] > prorasa )ultra_armor[id]++
						args[1]=id
						new exp = calc_award_goal_xp(id,get_cvar_num("diablo_xpbonus2"),0) * pln /2
						Give_Xp(id,exp)	
						player_wys[id]=1
						if(player_lich[id]>0){
							if (get_user_team(id) == get_user_team(lucky_bastard)) my_zombie(lucky_bastard, id)
						}else{
							set_task(0.1, "task_respawn", TASKID_RESPAWN + lucky_bastard,args,2)
						}
						
					}
					
				}
			}

		}
		else
			failed_revive(id)
	}
	else
		set_task(0.1, "task_revive", TASKID_REVIVE + id)
	return FMRES_IGNORED
	
	
}

public failed_revive(id)
{
	msg_bartime(id, 0)
	emit_sound(id, CHAN_AUTO, SOUND_FAILED, VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
}

public task_origin(args[])
{
	new id = args[0]
	engfunc(EngFunc_SetOrigin, id, g_body_origin[id])
	
	static  Float:origin[3]
	pev(id, pev_origin, origin)
	set_pev(id, pev_zorigin, origin[2])
	
	set_task(0.1, "task_stuck_check", TASKID_CHECKST + id,args,2)
	
}

stock find_dead_body(id)
{
	static Float:origin[3]
	pev(id, pev_origin, origin)
	
	new ent
	static classname[32]	
	while((ent = fm_find_ent_in_sphere(ent, origin, get_pcvar_float(cvar_revival_dis))) != 0) 
	{
		if(!is_valid_ent(ent)) continue;
		pev(ent, pev_classname, classname, 31)
		if(equali(classname, "fake_corpse") && fm_is_ent_visible(id, ent))
			return ent
		
	}
	return 0
}

stock msg_bartime(id, seconds) 
{
	if(is_user_bot(id)||!is_user_alive(id)||!is_user_connected(id))
		return
	
	if((fm_get_user_button(id) & IN_USE)) change_health(id,-4,id,"")
	
	message_begin(MSG_ONE, g_msg_bartime, _, id)
	write_byte(seconds)
	write_byte(0)
	message_end()
}

public task_respawn(args[]) 
{
	new id = args[0]
	
	if (!is_user_connected(id) || is_user_alive(id) || cs_get_user_team(id) == CS_TEAM_SPECTATOR) return
	
	set_pev(id, pev_deadflag, DEAD_RESPAWNABLE) 
	dllfunc(DLLFunc_Think, id) 
	dllfunc(DLLFunc_Spawn, id) 
	set_pev(id, pev_iuser1, 0)
	
	set_task(0.1, "task_check_respawn", TASKID_CHECKRE + id,args,2)
	
}

public task_check_respawn(args[])
{
	new id = args[0]
	
	if(pev(id, pev_iuser1))
		
	set_task(0.1, "task_respawn", TASKID_RESPAWN + id,args,2)
	else
		set_task(0.1, "task_origin", TASKID_ORIGIN + id,args,2)
	
}

public task_stuck_check(args[])
{
	new id = args[0]
	
	static Float:origin[3]
	pev(id, pev_origin, origin)
	
	if(origin[2] == pev(id, pev_zorigin))
		set_task(0.1, "task_respawn", TASKID_RESPAWN + id,args,2)
	else
		set_task(0.1, "task_setplayer", TASKID_SETUSER + id,args,2)
}

public task_setplayer(args[])
{
	new id = args[0]
	new nekro = args[1]
	fm_give_item(id, "weapon_knife")
	
	fm_set_user_health(id, 75)
	new nekroInt = player_intelligence[nekro]
	if(nekroInt > 200) nekroInt = 200
	nekroInt = nekroInt/2
	if(is_user_connected(id)) change_health(id, nekroInt * get_maxhp(id) / 100, nekro, "world")
		
	Display_Fade(id,seconds(2),seconds(2),0,0,0,0,255)
	
	if(player_5hp[id]==1) fm_set_user_health(id,5)
}

public god_off(args[])
{
	if(is_user_connected(args[0])){
		set_user_godmode(args[0], 0)
		god[args[0]] = 0
	} 
}

stock bool:findemptyloc(ent, Float:radius)
{
	if(!fm_is_valid_ent(ent))
		return false
	
	static Float:origin[3]
	pev(ent, pev_origin, origin)
	origin[2] += 2.0
	
	new owner = pev(ent, pev_owner)
	new num = 0, bool:found = false
	
	while(num <= 100)
	{
		if(is_hull_vacant(origin))
		{
			g_body_origin[owner][0] = origin[0]
			g_body_origin[owner][1] = origin[1]
			g_body_origin[owner][2] = origin[2]
			
			found = true
			break
		}
		else
		{
			origin[0] += random_float(-radius, radius)
			origin[1] += random_float(-radius, radius)
			origin[2] += random_float(-radius, radius)
			
			num++
		}
	}
	return found
}

stock bool:is_hull_vacant(const Float:origin[3])
{
	new tr = 0
	engfunc(EngFunc_TraceHull, origin, origin, 0, HULL_HUMAN, 0, tr)
	if(!get_tr2(tr, TR_StartSolid) && !get_tr2(tr, TR_AllSolid) && get_tr2(tr, TR_InOpen))
		return true
	
	return false
}


public count_jumps(id)
{
	if( is_user_connected(id))
	{
		if( player_class[id]== Paladyn ) JumpsMax[id]=5+floatround(player_intelligence[id]/10.0)
		else if( player_class[id]== Samurai ) JumpsMax[id]=10+floatround(player_intelligence[id]/5.0)
			else JumpsMax[id]=0
		
	}
}

////////////////////////////////////////////////////////////////////////////////
//                                  Noze                                      //
////////////////////////////////////////////////////////////////////////////////
public give_knife(id)
{
	new knifes = 0
	
	if(player_class[id] == Ninja) knifes = 5 + floatround ( player_intelligence[id]/10.0 , floatround_floor )
	else if(player_class[id] == Zabojca) knifes = 4 + floatround ( player_intelligence[id]/20.0 , floatround_floor )
		
	if(player_class[id] == Samurai) knifes = 5 + floatround ( player_intelligence[id]/10.0 , floatround_floor )
	max_knife[id] = knifes
	player_knife[id] = knifes
}

public command_knife(id) 
{
	
	if(!is_user_alive(id)) return PLUGIN_HANDLED
	
	
	if(!player_knife[id])
	{
		client_print(id,print_center,"Nie masz juz nozy do rzucania")
		return PLUGIN_HANDLED
	}
	
	if(tossdelay[id] > get_gametime() - 0.9) return PLUGIN_HANDLED
	else tossdelay[id] = get_gametime()
	
	player_knife[id]--
	
	if (player_knife[id] == 1) {
		client_print(id,print_center,"Zostal ci tylko 1 noz!")
	}
	
	new Float: Origin[3], Float: Velocity[3], Float: vAngle[3], Ent
	
	entity_get_vector(id, EV_VEC_origin , Origin)
	entity_get_vector(id, EV_VEC_v_angle, vAngle)
	
	Ent = create_entity("info_target")
	
	if (!Ent) return PLUGIN_HANDLED
	
	entity_set_string(Ent, EV_SZ_classname, "throwing_knife")
	entity_set_model(Ent, "models/diablomod/w_throwingknife.mdl")
	
	new Float:MinBox[3] = {-1.0, -7.0, -1.0}
	new Float:MaxBox[3] = {1.0, 7.0, 1.0}
	entity_set_vector(Ent, EV_VEC_mins, MinBox)
	entity_set_vector(Ent, EV_VEC_maxs, MaxBox)
	
	vAngle[0] -= 90
	
	entity_set_origin(Ent, Origin)
	entity_set_vector(Ent, EV_VEC_angles, vAngle)
	
	entity_set_int(Ent, EV_INT_effects, 2)
	entity_set_int(Ent, EV_INT_solid, 1)
	entity_set_int(Ent, EV_INT_movetype, 6)
	entity_set_edict(Ent, EV_ENT_owner, id)
	
	VelocityByAim(id, get_cvar_num("diablo_knife_speed") , Velocity)
	entity_set_vector(Ent, EV_VEC_velocity ,Velocity)
	
	return PLUGIN_HANDLED
}

public RemoveFlagWaz(id){
	RemoveFlag(id,Flag_truc)
}

public touchKnife(knife, id)
{	
	new kid = entity_get_edict(knife, EV_ENT_owner)
	
	if(is_user_alive(id)) 
	{
		new movetype = entity_get_int(knife, EV_INT_movetype)
		
		if(movetype == 0) 
		{
			if( player_knife[id] < max_knife[id] )
			{
				player_knife[id] += 1
				client_print(id,print_center,"Obecna liczba nozy: %i",player_knife[id])
			}
			emit_sound(knife, CHAN_ITEM, "weapons/knife_deploy1.wav", 1.0, ATTN_NORM, 0, PITCH_NORM)
			remove_entity(knife)
		}
		else if (movetype != 0) 
		{
			if(kid == id) return
			if(max_knife[kid] ==0 ) return
			remove_entity(knife)
			
			if(get_cvar_num("mp_friendlyfire") == 0 && get_user_team(id) == get_user_team(kid)) return
			
			if(player_class[kid]==Ninja && player_intelligence[kid] >= 50 && !HasFlag(id, Flag_truc)){
				new pr = 0 + player_intelligence[kid] / 50
				if (!(pev(kid, pev_flags) & FL_ONGROUND)) pr += 1
				pr = pr - player_dextery[id]/50
				if(pr > 5) pr = 5
				if(pr < 1) pr = 1
				
				new healDmg = get_maxhp(id) * pr / 100
				if(healDmg<1) healDmg = 1
				Effect_waz(id,kid,healDmg)
				set_task(7.0, "RemoveFlagWaz", id)
			}
			if(player_class[kid]==Zabojca && player_lvl[kid] > prorasa){
				client_cmd(id,"weapon_knife")
				engclient_cmd(id,"weapon_knife")
				on_knife[id]=1
			}
			//entity_set_float(id, EV_FL_dmg_take, get_cvar_num("diablo_knife") * 1.0)
			
			change_health(id,-get_cvar_num("diablo_knife"),kid,"knife")
			message_begin(MSG_ONE,get_user_msgid("ScreenShake"),{0,0,0},id)
			write_short(7<<14)
			write_short(1<<13)
			write_short(1<<14)
			message_end()		
			
			emit_sound(id, CHAN_ITEM, "weapons/knife_hit4.wav", 1.0, ATTN_NORM, 0, PITCH_NORM)
		}
	}
}

public touchWorld(knife, world)
{
	entity_set_int(knife, EV_INT_movetype, 0)
	emit_sound(knife, CHAN_ITEM, "weapons/knife_hitwall1.wav", 1.0, ATTN_NORM, 0, PITCH_NORM)
}

public touchbreakable(ent1, ent2)
{
	new name[32],breakable,ent
	entity_get_string(ent1,EV_SZ_classname,name,31)
	if(equali(name,"func_breakable"))
	{
		breakable=ent1
		ent=ent2
	}
	else
	{
		breakable=ent2
		ent=ent1
	}
	new Float: b_hp = entity_get_float(breakable,EV_FL_health)
	if(b_hp>80) entity_set_float(breakable,EV_FL_health,b_hp-50.0)
	else dllfunc(DLLFunc_Use,breakable,ent)
	
	entity_get_string(ent,EV_SZ_classname,name,31)
	if(equali(name,"throwing_knife"))
	{
		emit_sound(ent, CHAN_ITEM, "weapons/knife_hitwall1.wav", 1.0, ATTN_NORM, 0, PITCH_NORM)
	}
	else remove_entity(ent)
}

public kill_all_entity(classname[]) {
	new iEnt = find_ent_by_class(-1, classname)
	while(iEnt > 0) {
		remove_entity(iEnt)
		iEnt = find_ent_by_class(iEnt, classname)		
	}
}
////////////////////////////////////////////////////////////////////////////////
//                             koniec z nozami                                //
////////////////////////////////////////////////////////////////////////////////
public mod_info(id)
{
	client_print(id,print_console,"Witamy w Lord Of Destruction mod by Kajt www.cs-lod.com.pl")
	client_print(id,print_console,"")
	client_print(id,print_console,"opartym na diablomod by Miczu & GuTeK")
	
	client_print(id,print_console,"")
	return PLUGIN_HANDLED
}
////////////////////////////////////////////////////////////////////////////////
//                             Hunter part code                               //
////////////////////////////////////////////////////////////////////////////////
public command_arrow(id) 
{
	
	if(!is_user_alive(id)) return PLUGIN_HANDLED
	
	
	new Float: Origin[3], Float: Velocity[3], Float: vAngle[3], Ent, Ent2, Ent3
	
	entity_get_vector(id, EV_VEC_origin , Origin)
	entity_get_vector(id, EV_VEC_v_angle, vAngle)
	
	new Float:MinBox[3] = {-2.8, -2.8, -1.8}
	new Float:MaxBox[3] = {2.8, 2.8, 3.0}
	
	
	if(player_class[id]==Lucznik){
		
		Ent = create_entity("info_target")
		if (!Ent) return PLUGIN_HANDLED
		entity_set_string(Ent, EV_SZ_classname, "xbow_arrow")
		entity_set_model(Ent, cbow_bolt)
		

		entity_set_vector(Ent, EV_VEC_mins, MinBox)
		entity_set_vector(Ent, EV_VEC_maxs, MaxBox)
		
		vAngle[0]*= -1
		Origin[2]+=10
		
		entity_set_origin(Ent, Origin)
		entity_set_vector(Ent, EV_VEC_angles, vAngle)
		
		entity_set_int(Ent, EV_INT_effects, 2)
		entity_set_int(Ent, EV_INT_solid, 1)
		entity_set_int(Ent, EV_INT_movetype, 5)
		entity_set_edict(Ent, EV_ENT_owner, id)
		new Float:dmg = 1.0 + player_intelligence[id] /10
		entity_set_float(Ent, EV_FL_dmg,dmg)
		
		VelocityByAim(id, 1200 , Velocity)
		set_rendering (Ent,kRenderFxGlowShell, 255,0,0, kRenderNormal,56)
		if(player_naladowany[id] == 1 && player_lvl[id] > prorasa) set_rendering (Ent,kRenderFxGlowShell, 0,0,200, kRenderNormal,56)
		entity_set_vector(Ent, EV_VEC_velocity ,Velocity)
		
		
		
		Ent2 = create_entity("info_target")
		if (!Ent2) return PLUGIN_HANDLED
		entity_set_string(Ent2, EV_SZ_classname, "xbow_arrow")
		entity_set_model(Ent2, cbow_bolt)
		entity_set_vector(Ent2, EV_VEC_mins, MinBox)
		entity_set_vector(Ent2, EV_VEC_maxs, MaxBox)
		entity_set_origin(Ent2, Origin)
		entity_set_vector(Ent2, EV_VEC_angles, vAngle)
		entity_set_int(Ent2, EV_INT_effects, 2)
		entity_set_int(Ent2, EV_INT_solid, 1)
		entity_set_int(Ent2, EV_INT_movetype, 5)
		entity_set_edict(Ent2, EV_ENT_owner, id)
		entity_set_float(Ent2, EV_FL_dmg,dmg)
		VelocityByAim(id, 1200 , Velocity)
		Velocity[0] += 90
		Velocity[1] += 90
		set_rendering (Ent2,kRenderFxGlowShell, 255,0,0, kRenderNormal,56)
		if(player_naladowany[id] == 1 && player_lvl[id] > prorasa) set_rendering (Ent2,kRenderFxGlowShell, 0,0,200, kRenderNormal,56)
		entity_set_vector(Ent2, EV_VEC_velocity ,Velocity)
		
		Ent3 = create_entity("info_target")
		if (!Ent3) return PLUGIN_HANDLED
		entity_set_string(Ent3, EV_SZ_classname, "xbow_arrow")
		entity_set_model(Ent3, cbow_bolt)
		entity_set_vector(Ent3, EV_VEC_mins, MinBox)
		entity_set_vector(Ent3, EV_VEC_maxs, MaxBox)
		entity_set_origin(Ent3, Origin)
		entity_set_vector(Ent3, EV_VEC_angles, vAngle)
		entity_set_int(Ent3, EV_INT_effects, 2)
		entity_set_int(Ent3, EV_INT_solid, 1)
		entity_set_int(Ent3, EV_INT_movetype, 5)
		entity_set_edict(Ent3, EV_ENT_owner, id)
		entity_set_float(Ent3, EV_FL_dmg,dmg)
		VelocityByAim(id, 1100 , Velocity)
		Velocity[0] -= 90
		Velocity[1] -= 90
		set_rendering (Ent3,kRenderFxGlowShell, 255,0,0, kRenderNormal,56)
		if(player_naladowany[id] == 1 && player_lvl[id] > prorasa) set_rendering (Ent3,kRenderFxGlowShell, 0,0,200, kRenderNormal,56)
		entity_set_vector(Ent3, EV_VEC_velocity ,Velocity)
	}
	
	if(player_class[id]==Kusznik){
		
		Ent = create_entity("info_target")
		if (!Ent) return PLUGIN_HANDLED
		entity_set_string(Ent, EV_SZ_classname, "xbow_arrow")
		entity_set_model(Ent, cbow_bolt)
		
		entity_set_vector(Ent, EV_VEC_mins, MinBox)
		entity_set_vector(Ent, EV_VEC_maxs, MaxBox)
		
		vAngle[0]*= -1
		Origin[2]+=10
		
		entity_set_origin(Ent, Origin)
		entity_set_vector(Ent, EV_VEC_angles, vAngle)
		
		entity_set_int(Ent, EV_INT_effects, 2)
		entity_set_int(Ent, EV_INT_solid, 1)
		entity_set_int(Ent, EV_INT_movetype, 5)
		entity_set_edict(Ent, EV_ENT_owner, id)
		new Float:dmg = 1.0 + player_intelligence[id] * 1.5
		entity_set_float(Ent, EV_FL_dmg,dmg)
		
		VelocityByAim(id, 1900 , Velocity)
		set_rendering (Ent,kRenderFxGlowShell, 0,255,0, kRenderNormal,56)
		entity_set_vector(Ent, EV_VEC_velocity ,Velocity)
		
	}
	
	if(player_class[id]==Heretyk){
		new Float:odj = 0.9
		
		
		Ent = create_entity("info_target")
		if (!Ent) return PLUGIN_HANDLED
		entity_set_string(Ent, EV_SZ_classname, "xbow_arrow")
		entity_set_model(Ent, cbow_bolt)
		
		entity_set_vector(Ent, EV_VEC_mins, MinBox)
		entity_set_vector(Ent, EV_VEC_maxs, MaxBox)
		
		vAngle[0]*= -1
		Origin[2]+=10
		
		entity_set_origin(Ent, Origin)
		entity_set_vector(Ent, EV_VEC_angles, vAngle)
		
		entity_set_int(Ent, EV_INT_effects, 2)
		entity_set_int(Ent, EV_INT_solid, 1)
		entity_set_float(Ent, EV_FL_gravity, odj )
		entity_set_int(Ent, EV_INT_movetype, 6)
		entity_set_edict(Ent, EV_ENT_owner, id)
		new Float:dmg = 20.0 + player_intelligence[id] 
		entity_set_float(Ent, EV_FL_dmg,dmg)
		
		VelocityByAim(id, 1900 , Velocity)
		set_rendering (Ent,kRenderFxGlowShell, 255,0,0, kRenderNormal,100)
		entity_set_vector(Ent, EV_VEC_velocity ,Velocity)
		
	}
	return PLUGIN_HANDLED
}

public command_bow(id) 
{
	if(!is_user_alive(id) || player_iszombie[id]>0) return PLUGIN_HANDLED
	
	if(bow[id] == 1){

		if(player_class[id]==Heretyk){
			entity_set_string(id,EV_SZ_viewmodel,cbow_VIEW4)
			entity_set_string(id,EV_SZ_weaponmodel,cvow_PLAYER4)
		}
		if(player_class[id]==Kusznik){
			entity_set_string(id,EV_SZ_viewmodel,cbow_VIEW)
			entity_set_string(id,EV_SZ_weaponmodel,cvow_PLAYER)
		}
		if(player_class[id]==Lucznik){
			entity_set_string(id,EV_SZ_viewmodel,cbow2_VIEW)
			entity_set_string(id,EV_SZ_weaponmodel,cvow2_PLAYER)
		}
		
	}
	else if(player_sword[id] == 1)
	{
		entity_set_string(id, EV_SZ_viewmodel, SWORD_VIEW)  
		entity_set_string(id, EV_SZ_weaponmodel, SWORD_PLAYER)  
		bow[id]=0
	}
	else
	{
		entity_set_string(id,EV_SZ_viewmodel,KNIFE_VIEW)
		entity_set_string(id,EV_SZ_weaponmodel,KNIFE_PLAYER)
		bow[id]=0
	}
	return PLUGIN_CONTINUE
}

public toucharrow(arrow, id)
{	
	new kid = entity_get_edict(arrow, EV_ENT_owner)
	new lid = entity_get_edict(arrow, EV_ENT_enemy)
	
	if(is_user_alive(id) && player_iszombie[kid] == 0) 
	{
		if(kid == id || lid == id) return PLUGIN_CONTINUE
		if(get_cvar_num("mp_friendlyfire") == 0 && get_user_team(id) == get_user_team(kid)) return PLUGIN_CONTINUE
		
		entity_set_edict(arrow, EV_ENT_enemy,id)
		
		new Float:dmg = entity_get_float(arrow,EV_FL_dmg)
		entity_set_float(arrow,EV_FL_dmg,(dmg*3.0)/5.0)
		
		new Float:vec[3]
		entity_get_vector(arrow,EV_VEC_velocity,vec)
		if(vec[0]==0&&vec[1]==0&&vec[2]==0){
			remove_entity(arrow)
			return PLUGIN_CONTINUE
		} 
		if(dmg < 3){
			remove_entity(arrow)
			return PLUGIN_CONTINUE
		} 
		
		Effect_Bleed(id,248)
	
		if(player_class[kid]==Lucznik){
			if(player_naladowany[kid] == 0 || player_lvl[kid] < prorasa){
				
				if (player_dextery[id] > 20)
					Effect_Ignite(id,kid,1)
				else if (player_dextery[id] > 15)
					Effect_Ignite(id,id,2)
				else if (player_dextery[id] > 10)
					Effect_Ignite(id,kid,3)
				else Effect_Ignite(id,kid,4)
						
	
			}else if(player_naladowany[kid] == 1 && player_lvl[kid] > prorasa)
			{
				efekt_slow_lodu(id, 3)
			}
			if(dmg<30) remove_entity(arrow)
				
			player_timed_speed[kid]=halflife_time() + 2.0
			set_speedchange(kid)
			set_task(3.2, "set_speedchange", kid)
			set_task(4.0, "set_speedchange", kid)
			new pr = 10 - player_dextery[id]/50
			if(pr<1) pr= 1
			new dem = get_maxhp(id)*(pr+5)/100
			change_health(id,floatround(-dmg - dem),kid,"knife")
		}
		if(player_class[kid]==Kusznik){
			if(player_lvl[kid] > prorasa && golden_bulet[kid] < 1) golden_bulet[kid]++
			new t = 7 - player_dextery[id]/25
			if(t<1) t= 1
			Effect_waz(id,kid,t)
			hudmsg(id,3.0,"Jestes zatruty!")
			if(dmg<30) remove_entity(arrow)
			player_timed_speed[kid]=halflife_time() + 2.0
			set_speedchange(kid)
			set_task(3.2, "set_speedchange", kid)
			set_task(4.0, "set_speedchange", kid)
			new pr = 20 - player_dextery[id]/25
			if(pr<1) pr= 1
			new dem = get_maxhp(id)*(pr + 5)/100
			change_health(id,floatround(-dmg - dem),kid,"knife")
		}
			

			
		if(player_class[kid]==Heretyk){
				
				new Float:origin[3]
				entity_get_vector(id, EV_VEC_origin , origin)
				if(dmg<30) remove_entity(arrow)
				message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
				write_byte(3)
				write_coord(floatround(origin[0]))
				write_coord(floatround(origin[1]))
				write_coord(floatround(origin[2]))
				write_short(sprite_fire3)
				write_byte(50)
				write_byte(15)
				write_byte(0)
				message_end()
				new entlist[513]
				new numfound = find_sphere_class(id,"player",120.0,entlist,512)
				
				for (new i=0; i < numfound; i++)
				{		
					new pid = entlist[i]
					
					if (!is_user_alive(pid) || get_user_team(kid) == get_user_team(pid) ||   cs_get_user_team(pid) == CS_TEAM_SPECTATOR || pid == kid || pid == id)
						continue
					
					if (is_user_alive(pid)) {
						change_health(pid,floatround(-dmg),kid, "world")
						
					}
					
				}
				remove_entity(arrow)
				change_health(id,floatround(-dmg),kid,"knife")
				
		}
		
		
		message_begin(MSG_ONE,get_user_msgid("ScreenShake"),{0,0,0},id); 
		write_short(7<<14); 
		write_short(1<<13); 
		write_short(1<<14); 
		message_end();
		
		if(get_user_team(id) == get_user_team(kid)) 
		{
			new name[33]
			get_user_name(kid,name,32)
			client_print(0,print_chat,"%s attacked a teammate",name)
		}
		
		emit_sound(id, CHAN_ITEM, "weapons/knife_hit4.wav", 1.0, ATTN_NORM, 0, PITCH_NORM)
		
		
	}
	return PLUGIN_CONTINUE
}

public toucharrow_flara(arrow, id)
{	
	new kid = entity_get_edict(arrow, EV_ENT_owner)
	new lid = entity_get_edict(arrow, EV_ENT_enemy)
	
	if(is_user_alive(id)) 
	{
		if(kid == id || lid == id) return
		
		entity_set_edict(arrow, EV_ENT_enemy,id)
		
		new Float:dmg = entity_get_float(arrow,EV_FL_dmg) - player_dextery[id]
		entity_set_float(arrow,EV_FL_dmg,(dmg*3.0)/5.0)
		entity_set_float(arrow,EV_FL_dmg,(dmg*3.0)/5.0)
		
		new Float:vec[3]
		entity_get_vector(arrow,EV_VEC_velocity,vec)
		if(vec[0]==0&&vec[1]==0&&vec[2]==0){
			remove_entity(arrow)
			return
		} 
		
		if(get_cvar_num("mp_friendlyfire") == 0 && get_user_team(id) == get_user_team(kid)) return
		
		
		change_health(id,floatround(-dmg),kid, "world")
		new dmg2 = 1 + player_intelligence[kid]/10 - player_dextery[id]/8
		Effect_Ignite(id,kid,dmg2 )
		
		
		if(get_user_team(id) == get_user_team(kid)) 
		{
			new name[33]
			get_user_name(kid,name,32)
			client_print(0,print_chat,"%s attacked a teammate",name)
		}
		
		new Float:origin[3]
		entity_get_vector(id, EV_VEC_origin , origin)
		if(dmg<30) remove_entity(arrow)
		message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
		write_byte(3)
		write_coord(floatround(origin[0]))
		write_coord(floatround(origin[1]))
		write_coord(floatround(origin[2]))
		write_short(sprite_fire3)
		write_byte(50)
		write_byte(15)
		write_byte(0)
		message_end()
		new entlist[513]
		new numfound = find_sphere_class(id,"player",80.0,entlist,512)
		
		for (new i=0; i < numfound; i++)
		{		
			new pid = entlist[i]
			
			if (!is_user_alive(pid) || get_user_team(kid) == get_user_team(pid) ||   cs_get_user_team(pid) == CS_TEAM_SPECTATOR || pid == kid || pid == id)
				continue
			
			if (is_user_alive(pid)) {
				new dmgI = 1 + player_intelligence[kid]/10 - player_dextery[pid]/8
				Effect_Ignite(pid,kid,dmgI )
				new red = dexteryDamRedPerc[pid]
				dmg =  dmg + (get_maxhp(pid) * 20/100) *1.0
				dmg =  dmg - (dmg * red /100.0) * 1.0
				if(dmg<10) dmg = 10.0;
				change_health(pid,floatround(-dmg),kid, "world")

			}
			
		}
	}
}

public touchWorld2_flara(arrow, world)
{
	new Float:origin[3]
	entity_get_vector(arrow, EV_VEC_origin , origin)
	new Float:dmg = entity_get_float(arrow,EV_FL_dmg)
	new kid = entity_get_edict(arrow, EV_ENT_owner)
	
	
	message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
	write_byte(3)
	write_coord(floatround(origin[0]))
	write_coord(floatround(origin[1]))
	write_coord(floatround(origin[2]))
	write_short(sprite_fire3)
	write_byte(50)
	write_byte(15)
	write_byte(0)
	message_end()
	new entlist[513]
	new numfound = find_sphere_class(arrow,"player",100.0,entlist,512)
	
	for (new i=0; i < numfound; i++)
	{		
		new pid = entlist[i]
		
		if (!is_user_alive(pid) || get_user_team(kid) == get_user_team(pid) ||   cs_get_user_team(pid) == CS_TEAM_SPECTATOR || pid == kid )
			continue
		
		if (is_user_alive(pid)) {
			new red = dexteryDamRedPerc[pid]
			dmg +=   (get_maxhp(pid) * 20/100)* 1.0
			dmg = dmg - (dmg * red /100.0) * 1.0
			if(dmg<10) dmg = 10.0;
			change_health(pid,floatround(-dmg),kid, "world")
			new dmgI = 1 + player_intelligence[kid]/10 - player_dextery[pid]/8
			Effect_Ignite(pid,kid,dmgI )
		}
		
	}
	remove_entity(arrow)
}

public touchWorld2(arrow, world)
{
	new kid = entity_get_edict(arrow, EV_ENT_owner)
	if(player_class[kid]==Heretyk ){
		
		new Float:origin[3]
		entity_get_vector(arrow, EV_VEC_origin , origin)
		new Float:dmg = entity_get_float(arrow,EV_FL_dmg)
		
		
		
		message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
		write_byte(3)
		write_coord(floatround(origin[0]))
		write_coord(floatround(origin[1]))
		write_coord(floatround(origin[2]))
		write_short(sprite_fire3)
		write_byte(50)
		write_byte(15)
		write_byte(0)
		message_end()
		new entlist[513]
		new numfound = find_sphere_class(arrow,"player",100.0,entlist,512)
		
		for (new i=0; i < numfound; i++)
		{		
			new pid = entlist[i]
			
			if (!is_user_alive(pid) || get_user_team(kid) == get_user_team(pid) ||   cs_get_user_team(pid) == CS_TEAM_SPECTATOR || pid == kid )
				continue
			
			if (is_user_alive(pid)) {
				change_health(pid,floatround(-dmg),kid, "world")
				
			}			
		}		
	}
	remove_entity(arrow)
}

public hunter_Line(id,vid,end[3])
{
	if(is_user_alive(id) && is_user_alive(vid) && trace_bool[id])
	{
		new start[3]
		get_user_origin(vid,start)
		
		message_begin(MSG_ONE,SVC_TEMPENTITY,{0,0,0},id)
		write_byte(0)
		write_coord(start[0])	// starting pos
		write_coord(start[1])
		write_coord(start[2])
		write_coord(end[0])	// ending pos
		write_coord(end[1])
		write_coord(end[2])
		write_short(sprite_line)	// sprite index
		write_byte(1)		// starting frame
		write_byte(5)		// frame rate
		write_byte(100)		// life
		write_byte(1)		// line width
		write_byte(0)		// noise
		write_byte(200)	// RED
		write_byte(100)	// GREEN
		write_byte(100)	// BLUE					
		write_byte(75)		// brightness
		write_byte(5)		// scroll speed
		message_end()
		
		new parms[5];
		
		for(new i=0;i<3;i++)
		{
			parms[i] = start[i] 
		}
		parms[3]=id
		parms[4]=vid
		
		set_task(0.20,"charge_hunter",id+TARACE_TASK+vid*100,parms,5)
	}
}

public charge_hunter(parms[])
{
	new stop[3]
	
	for(new i=0;i<3;i++)
	{
		stop[i] =parms[i]
	}
	hunter_Line(parms[3],parms[4],stop)
}



public task_ActivateTrap(param[])
{
	new ent = param[0]
	if(!is_valid_ent(ent)) 
		return PLUGIN_CONTINUE
	
	entity_set_int(ent, NADE_PAUSE, 1)
	entity_set_int(ent, NADE_ACTIVE, 1)
	
	new Float:fOrigin[3]
	entity_get_vector(ent, EV_VEC_origin, fOrigin)
	fOrigin[2] -= 8.1*(1.0-floatpower( 2.7182, -0.06798*float(player_agility[entity_get_edict(ent,EV_ENT_owner)])))
	entity_set_vector(ent, EV_VEC_origin, fOrigin)
	
	return PLUGIN_CONTINUE
}

public think_Grenade(ent)
{
	new entModel[33]
	entity_get_string(ent, EV_SZ_model, entModel, 32)
	
	if(!is_valid_ent(ent) || equal(entModel, "models/w_c4.mdl"))
		return PLUGIN_CONTINUE
		
	new iEnt= ent
		
	static Float:flGameTime, Float:flDmgTime, iOwner
	flGameTime = get_gametime()
	pev(iEnt, pev_dmgtime, flDmgTime)
	const XO_GRENADE = 5
	if(	flDmgTime <= flGameTime
	// VEN's way on how to detect grenade type
	// http://forums.alliedmods.net/showthread.php?p=401189#post401189
	&&	get_pdata_int(iEnt, 114, XO_GRENADE) == 0 // has a bit when is HE or SMOKE
	&&	!(get_pdata_int(iEnt, 96, XO_GRENADE) & (1<<8)) // has this bit when is c4
	&&	IsPlayer( (iOwner = pev(iEnt, pev_owner)) )	) // if no owner (3rd 'after dmgtime' frame), grenade gonna be removed from world
	{
		if( ~WillGrenadeExplode(iEnt) ) // grenade gonna explode on next think
		{
			SetGrenadeExplode( iEnt )
		}
		else
		{
			ClearGrenadeExplode( iEnt )
			g_flCurrentGameTime = flGameTime
			g_iCurrentFlasher = iOwner
		}
	}
	
	if(entity_get_int(ent, NADE_PAUSE))
		return PLUGIN_HANDLED
	
	return PLUGIN_CONTINUE
}

public think_Bot(bot)
{
	new ent = -1
	while((ent = find_ent_by_class(ent, "grenade")))
	{
		new entModel[33]
		entity_get_string(ent, EV_SZ_model, entModel, 32)
		
		if(equal(entModel, "models/w_c4.mdl"))
			continue
		
		if(!entity_get_int(ent, NADE_ACTIVE))
			continue
		
		new Players[32], iNum
		get_players(Players, iNum, "a")
		
		for(new i = 0; i < iNum; ++i)
		{
			new id = Players[i]
			if(entity_get_int(ent, NADE_TEAM) == get_user_team(id)) 
				continue
			
			if(get_entity_distance(id, ent) > cvar_activate_dis || player_speed(id) <200.0) 
				continue
			
			if(entity_get_int(ent, NADE_VELOCITY)) continue
			
			new Float:fOrigin[3]
			entity_get_vector(ent, EV_VEC_origin, fOrigin)
			while(PointContents(fOrigin) == CONTENTS_SOLID)
				fOrigin[2] += 100.0
			
			entity_set_vector(ent, EV_VEC_origin, fOrigin)
			drop_to_floor(ent)
			
			new Float:fVelocity[3]
			entity_get_vector(ent, EV_VEC_velocity, fVelocity)
			fVelocity[2] += float(cvar_nade_vel)
			entity_set_vector(ent, EV_VEC_velocity, fVelocity)
			entity_set_int(ent, NADE_VELOCITY, 1)
			
			new param[1]
			param[0] = ent 
			//set_task(cvar_explode_delay, "task_ExplodeNade", 0, param, 1)
			entity_set_float(param[0], EV_FL_nextthink, halflife_time() + cvar_explode_delay)
			entity_set_int(param[0], NADE_PAUSE, 0)
		}
	}
	if(get_timeleft()<2 && map_end<2)
	{
		map_end=2
	}
	else if(get_timeleft()<6 && map_end<1)
	{
		new play[32],num
		
		get_players(play,num)
		
		for(new i=0;i<num;i++)
		{
			savexpcom(play[i])
		}
		map_end=1
	}
	
	entity_set_float(bot, EV_FL_nextthink, halflife_time() + 0.1)
}

stock Float:player_speed(index) 
{
	new Float:vec[3]
	
	pev(index,pev_velocity,vec)
	vec[2]=0.0
	
	return floatsqroot ( vec[0]*vec[0]+vec[1]*vec[1] )
}

public _create_ThinkBot()
{
	new think_bot = create_entity("info_target")
	if(!is_valid_ent(think_bot))
		log_amx("For some reason, the universe imploded, reload your server")
	else 
	{
		entity_set_string(think_bot, EV_SZ_classname, "think_bot")
		entity_set_float(think_bot, EV_FL_nextthink, halflife_time() + 1.0)
	}
}



////////////////////////////////////////////////////////////////////////////////
//                             Udezenie i kill                                //
////////////////////////////////////////////////////////////////////////////////
public get_maxhp(id){
	
	new m_health = race_heal[player_class[id]]+player_strength[id]*2 - player_b_reduceH[id] 
	if(player_class[id]==Demon) m_health = race_heal[player_class[id]]+player_strength[id] - player_b_reduceH[id] 
	if(player_class[id]==Ghull) m_health = race_heal[player_class[id]]+player_strength[id]*2 - player_b_reduceH[id]  + (player_nal[id]*15 + player_intelligence[id]/10)
	if(player_class[attacker] == Ognik && player_lvl[attacker] > prorasa)  m_health -= 25
	if(KlasyZlicz[player_class[id]]==1) m_health = m_health +1
	if(KlasyZlicz[player_class[id]] >=6) m_health -= 25 * m_health / 100
	if(KlasyZlicz[player_class[id]] >=4) m_health -= 10 * m_health / 100
 
	if(player_lembasy[id]>0 && used_item[id]==true)  m_health  += player_lembasy[id]*25
	
	if(ct_drut>0 && cs_get_user_team(id) == CS_TEAM_CT){
		m_health = m_health + m_health/10 
	}
	else if(t_drut>0 && cs_get_user_team(id) == CS_TEAM_T){
		m_health = m_health + m_health/10 
	}
	m_health+= hp_pro_bonus 
	if(m_health<2) m_health=2
	
	
	if(player_iszombie[id]==1) m_health = 8000
	if(player_iszombie[id]==2) m_health = 2000
	if(player_iszombie[id]==3) m_health = 500
	if(player_iszombie[id]==4) m_health = 100
	if(u_sid[id] > 0) m_health += 25
	
	if(player_diablo[id]==1 || player_she[id]==1) m_health=18000
	if( player_5hp[id]>0 ) m_health = 5
	return m_health
}

public change_health(id,hp,attacker,weapon[])
{
	change_health_fun(id,hp,attacker,weapon, 0)
}

public change_health_fun(id,hp,attacker,weapon[], przebicie)
{
	
	if(is_user_alive(id) && is_user_connected(id) && id!=0 )
	{		
		if(attacker !=0 && is_user_connected(attacker)) {
			if(cs_get_user_team(attacker) == CS_TEAM_SPECTATOR) hp = 0
		}
		if(attacker !=0 && ! is_user_connected(attacker)) hp = 0
		
		if(cs_get_user_team(id) == CS_TEAM_SPECTATOR) hp = 0
		
		if(przebicie == 0 && player_dziewica[id]>0 && player_dziewica_using[id]==1 && hp<0 && player_dziewica[attacker]==0) change_health(attacker,hp,id,"world")
		
		if(przebicie == 0 && player_class[id]==Inkwizytor && hp <0){
			if(player_nal[id] >0){
				if(hp < -1){
					if(player_lvl[id] > prorasa && golden_bulet[id] < 1) golden_bulet[id]++
					player_timed_speed[id]=halflife_time() + 5.0
					if(ultra_armor[id] < 1)ultra_armor[id]++
					show_hudmessage(id, "Chroni Cie magiczna tarcza!") 
					new pr = 50 + player_dextery[id] 
					if(pr >= 100){ 
						hp=0
						pr = 100
					}
					else{
						hp= hp *(100 -pr)/100
					}
					
					player_nal[id]--
					set_speedchange(id)
					set_task(5.2, "set_speedchange", id)
					set_task(6.0, "set_speedchange", id)
					write_hud(id)
				}
			}
			hp = hp/2			
		}
		
		if(diablo_typ==3 &&  resp[id] ==1 ){
			hp = 0
		}
		new health = get_user_health(id)
		if(hp>=0)
		{
			if(KlasyZlicz[player_class[id]] >=6 && clEvent != 2) hp = hp *80/100
			else if(KlasyZlicz[player_class[id]] >=4 && clEvent != 2) hp = hp *90/100
			if(player_b_tarczaograon[attacker] == 1) hp = 0
			new m_health = get_maxhp(id)
			if(hp>0 && print_dmg[id]) {
				set_hudmessage(0, 200, 0, 0.60, 0.50, 2, 0.1, 4.0, 0.1, 0.1, -1)
				ShowSyncHudMsg(id, g_hudmsg5, "+%i^n", hp)	
			}
			
			if((player_5hp[id]==1 ) &&hp>0)
			{
				return
			}
			else if (hp+health>m_health) set_user_health(id,m_health)
				else set_user_health(id,get_user_health(id)+hp)
		}
		else
		{
			if(KlasyZlicz[player_class[attacker]] >=6 && clEvent != 2) hp = hp *80/100
			else if(KlasyZlicz[player_class[attacker]] >=4 && clEvent != 2) hp = hp *90/100
			if(player_lvl[attacker]> prorasa && player_class[attacker] == Zjawa){
				player_timed_speed[attacker]=halflife_time() + 3.0
				set_speedchange(id)
				set_task(3.2, "set_speedchange", attacker)
				set_task(4.0, "set_speedchange", attacker)
			}
			if(player_b_tarczaograon[id] == 1) hp = 0
			if(player_b_tarczaograon[attacker] == 1) hp = 0
			if(player_timed_mr[id]>halflife_time()){
				hp = hp/4
			}
			if(player_lvl[id]>prorasa){
				if(player_class[id]==Meduza ){
					if(get_user_health(id) <= 50){
						Display_Fade(attacker,1500,1<<14 ,1<<16,255,155,50,230)
					}
				}
			}
			inbattle[id] = 1
			inbattle[attacker] = 1
			if(god[id] == 1 || get_user_godmode(id) > 0 ) return
			//if((get_user_godmode(attacker) > 0)) return
			if(player_tarczam[id] > 1000){
				hp /= 2 
			} 
			if(player_class[attacker] == Ifryt && player_lvl[attacker] > prorasa) change_health(attacker, 1 + (10*hp / 100),0,"")
			if( (IsPlayer(attacker) && IsPlayer(id)) && !g_bAsysta[attacker][id] && get_user_team(id) != get_user_team(attacker) && id != attacker)
				g_bAsysta[attacker][id] = true;
			if(get_user_team(id) != get_user_team(attacker)){
				if(player_class[attacker] == Ognik && player_lvl[attacker] > prorasa){
					efekt_slow_lodu(id, 1)
					set_task(1.0, "set_speedchange", id)
					set_task(1.1, "set_speedchange", id)
					set_speedchange(id)
				}
				item_take_damage(id,-hp/2)
				if(health+hp<1)
				{
					show_magic_dmg(id,hp,attacker)
					UTIL_Kill(attacker,id,weapon)
					hp = - health
				}
				else{
					show_magic_dmg(id,hp,attacker)
					set_user_health(id,health+hp)
					last_attacker[id] = attacker
					if(player_class[id]==Barbarzynca && player_lvl[id] > prorasa){
						if(get_user_health(id) < 50 && ultra_armor[id]<=7) ultra_armor[id]++				
					}
				}
			}
			if(player_lustro[id]==1){
				new m_health = get_maxhp(id)
				if(((100* get_user_health(id)) / m_health) < 50) lustro(id)
			}
		}
		
		if(id!=attacker && hp<0) 
		{
			dmg_exp_mag(attacker, id, -hp)
		}
		write_hud(id)
	}
	return
}

public show_magic_dmg(id,damage,attacker_id){	
	if(attacker_id > 0){
		//showDMG
		if(print_dmg[id]){
			set_hudmessage(130, 0, 255, 0.55, 0.50, 2, 0.1, 4.0, 0.1, 0.1, -1)
			ShowSyncHudMsg(id, g_hudmsg3, "%i^n", damage)	
		}
		if(is_user_connected(attacker_id))
		{
			if(fm_is_ent_visible(attacker_id,id) && print_dmg[attacker_id])
			{
				set_hudmessage(100, 255, 255, -1.0, 0.45, 2, 0.1, 4.0, 0.02, 0.02, -1)
				ShowSyncHudMsg(attacker_id, g_hudmsg4, "%i^n", -damage)				
			}
		}
	}
}

public UTIL_Kill(attacker,id,weapon[])
{
	changeskin(id,1)
	if(player_tarczam[id] > 1000 || player_diablo[id] || player_she[id]) return PLUGIN_HANDLED
	if(player_class[id]==Inkwizytor ){
		if(player_nal[id] >0 && player_dextery[id] > 49){
			player_timed_speed[id]=halflife_time() + 5.0
			player_nal[id]--
			show_hudmessage(id, "Chroni Cie magiczna tarcza!") 
			set_speedchange(id)
			set_task(5.2, "set_speedchange", id)
			set_task(6.0, "set_speedchange", id)
			write_hud(id)
			return PLUGIN_HANDLED
		}
	}
	if( is_user_alive(id) && is_user_connected(attacker) && get_user_godmode(id) == 0 ){
		
		if(get_user_team(attacker)!=get_user_team(id)) change_frags(attacker, id,0)
		
		if (cs_get_user_money(attacker) + 150 <= 16000)
			cs_set_user_money(attacker,cs_get_user_money(attacker)+50)
		else
			cs_set_user_money(attacker,16000)
		
		//cs_set_user_deaths(id, cs_get_user_deaths(id)+1)
		user_kill(id,1) 
		client_cmd(id,"_DeathMsg");
		Display_Fade(id,2600,2600,0,255,0,0,80)
		
		
		//showitem3(id)
		if(is_user_connected(attacker) && attacker!=id)
		{
			award_kill(attacker,id)
			award_item(attacker,0)
		}
		
		
		message_begin( MSG_ALL, gmsgDeathMsg,{0,0,0},0) 
		write_byte(attacker) 
		write_byte(id) 
		write_byte(0) 
		write_string(weapon) 
		message_end() 
		
		message_begin(MSG_ALL,gmsgScoreInfo) 
		write_byte(attacker) 
		write_short(get_user_frags(attacker)) 
		write_short(get_user_deaths(attacker)) 
		write_short(0) 
		write_short(get_user_team(attacker)) 
		message_end() 
		
		message_begin(MSG_ALL,gmsgScoreInfo) 
		write_byte(id) 
		write_short(get_user_frags(id)) 
		write_short(get_user_deaths(id)) 
		write_short(0) 
		write_short(get_user_team(id)) 
		message_end() 
		
		new kname[32], vname[32], kauthid[32], vauthid[32], kteam[10], vteam[10];
		
		get_user_name(attacker, kname, 31);
		get_user_team(attacker, kteam, 9);
		get_user_authid(attacker, kauthid, 31);
		
		get_user_name(id, vname, 31);
		get_user_team(id, vteam, 9);
		get_user_authid(id, vauthid, 31);
		
		log_message("^"%s<%d><%s><%s>^" killed ^"%s<%d><%s><%s>^" with ^"%s^"", 
		kname, get_user_userid(attacker), kauthid, kteam, 
		vname, get_user_userid(id), vauthid, vteam, weapon);
		
		if(player_zombie_killer_magic[attacker]>0 && random_num(1, player_zombie_killer_magic[attacker])==1) my_zombie(id, attacker)
	}
	return PLUGIN_HANDLED
}


stock Display_Fade(id,duration,holdtime,fadetype,red,green,blue,alpha)
{
	message_begin( MSG_ONE, g_msg_screenfade,{0,0,0},id )
	write_short( duration )	// Duration of fadeout
	write_short( holdtime )	// Hold time of color
	write_short( fadetype )	// Fade type
	write_byte ( red )		// Red
	write_byte ( green )		// Green
	write_byte ( blue )		// Blue
	write_byte ( alpha )	// Alpha
	message_end()
}

stock Display_Icon(id ,enable ,name[] ,red,green,blue)
{
	if (!pev_valid(id) || is_user_bot(id))
	{
		return PLUGIN_HANDLED
	}
	//	new string [8][32] = {"dmg_rad","item_longjump","dmg_shock","item_healthkit","dmg_heat","suit_full","cross","dmg_gas"}
	
	message_begin( MSG_ONE, g_msg_statusicon, {0,0,0}, id ) 
	write_byte( enable ) 	
	write_string( name ) 
	write_byte( red ) // red 
	write_byte( green ) // green 
	write_byte( blue ) // blue 
	message_end()
	
	return PLUGIN_CONTINUE
}

public createBlockAiming(id)
{
	
	new Float:vOrigin[3];
	new Float:vAngles[3]
	entity_get_vector(id,EV_VEC_v_angle,vAngles)
	entity_get_vector(id,EV_VEC_origin,vOrigin)
	new Float:offset = distance_to_floor(vOrigin)
	vOrigin[2]+=17.0-offset
	//create the block
	
	if(vAngles[1]>45.0&&vAngles[1]<135.0)
	{
		vOrigin[0]+=0.0
		vOrigin[1]+=52.0
		if(chacke_pos(vOrigin,0)==0) return
		make_shild(id,vOrigin,vAngles1,gfBlockSizeMin1,gfBlockSizeMax1)
	}
	else if(vAngles[1]<-45.0&&vAngles[1]>-135.0)
	{
		vOrigin[0]+=0.0
		vOrigin[1]+=-52.0
		if(chacke_pos(vOrigin,0)==0) return
		make_shild(id,vOrigin,vAngles1,gfBlockSizeMin1,gfBlockSizeMax1)
	}
	else if(vAngles[1]>-45.0&&vAngles[1]<45.0)
	{
		vOrigin[0]+=52.0
		vOrigin[1]+=0.0
		if(chacke_pos(vOrigin,1)==0) return
		make_shild(id,vOrigin,vAngles2,gfBlockSizeMin2,gfBlockSizeMax2)
	}
	else
	{
		vOrigin[0]+=-52.0
		vOrigin[1]+=0.0
		if(chacke_pos(vOrigin,1)==0) return
		make_shild(id,vOrigin,vAngles2,gfBlockSizeMin2,gfBlockSizeMax2)
	}
}

public make_shild(id,Float:vOrigin[3],Float:vAngles[3],Float:gfBlockSizeMin[3],Float:gfBlockSizeMax[3])
{
	new ent = create_entity("info_target")
	
	//make sure entity was created successfully
	if (is_valid_ent(ent))
	{
		//set block properties
		entity_set_string(ent, EV_SZ_classname, "dbmod_shild")
		entity_set_int(ent, EV_INT_solid, SOLID_BBOX)
		entity_set_int(ent, EV_INT_movetype, MOVETYPE_NONE)
		entity_set_float(ent,EV_FL_health,50.0+float(player_intelligence[id]*5))
		entity_set_float(ent,EV_FL_takedamage,1.0)
		
		entity_set_model(ent, "models/diablomod/bm_block_platform.mdl");
		entity_set_vector(ent, EV_VEC_angles, vAngles)
		entity_set_size(ent, gfBlockSizeMin, gfBlockSizeMax)
		
		entity_set_edict(ent,EV_ENT_euser1,id)
		entity_set_float(ent,EV_FL_scale,1.5)
		
		entity_set_origin(ent, vOrigin)
		
		num_shild[id]--
		
		return 1
	}
	return 0
}










////////////////////////////////////////////////////////////////////////////////
//                             Ladowanie sie nozem                            //
////////////////////////////////////////////////////////////////////////////////

public call_cast(id)
{
	
	set_hudmessage(60, 200, 25, -1.0, 0.25, 0, 1.0, 2.0, 0.1, 0.2, 2)
	
	switch(player_class[id])
	{
		
		case Mnich:
		{
			if(player_nal[id] > 20){
				show_hudmessage(id, "Nie mozesz sie juz ladowac",golden_bulet[id]) 
				return;
			}
			player_nal[id]++
			player_timed_mr[id] = halflife_time() + 3.0
			player_timed_shield[id] = halflife_time() + 3.0
			new m=get_maxhp(id)
			new adh = (100*(m-get_user_health(id))/m)
			if(adh<0) adh = 0
			change_health(id, 10 + adh, id, "world");
			
			if(player_lvl[id]>prorasa){
				player_b_szarza_time[id] = floatround(halflife_time()) + 5
				un_rander(TASK_FLASH_LIGHT+id)
				RemoveFlag(id,Flag_Dazed)
				RemoveFlag(id,Flag_Ignite)
				ofiara_totem_enta[id] = 0
				ofiara_totem_lodu[id] = 0
				new svIndex[32] 
				num_to_str(id,svIndex,32)
				Display_Icon(id ,ICON_SHOW ,"dmg_cold" ,0,0,255)
				set_task(0.1,"task_koniec",0,svIndex,32) 	
				Display_Icon(id ,ICON_SHOW ,"dmg_cold" ,0,255,0)
				set_task(0.1,"task_koniec",0,svIndex,32) 	
				set_speedchange(id)
				set_renderchange(id)	
			}
		}
		case Paladyn:
		{
			golden_bulet[id]++
			if(golden_bulet[id]>3)
			{
				golden_bulet[id]=3
				show_hudmessage(id, "Mozesz miec maxymalnie 3 magiczne pociskow",golden_bulet[id]) 
			}
			else if(golden_bulet[id]==1)show_hudmessage(id, "Masz 1 magiczny pocisk") 
				else if(golden_bulet[id]>1)show_hudmessage(id, "Masz %i magiczne pociski",golden_bulet[id]) 
			}
		case Zabojca:
		{
			show_hudmessage(id, "Jestes tymczasowo niewidzialyn (noz)") 
			invisible_cast[id]=1
			set_renderchange(id)
		}
		case Ninja:
		{
			show_hudmessage(id, "Zwiekszyles sobie tymczasowo predkosc") 
			player_nal[id]++
			set_speedchange(id)
		}
		case Barbarzynca:
		{
			ultra_armor[id]++
			if(ultra_armor[id]>7)
			{
				ultra_armor[id]=7
				show_hudmessage(id, "Maksymalna wartosc pancerza to 7",ultra_armor[id]) 
			}
			else show_hudmessage(id, "Magiczny pancerz wytrzyma %i strzalow",ultra_armor[id]) 
		}
		case Kusznik: {
			fm_give_item(id, "weapon_hegrenade")
			show_hudmessage(id, "Dostajesz HE grenade") 
		}
		case Lucznik: {
			fm_give_item(id, "weapon_hegrenade")
			show_hudmessage(id, "Dostajesz HE grenade") 
			if(player_lvl[id]>prorasa){
				player_naladowany[id]++
				if(player_naladowany[id] >= 2) player_naladowany[id] = 0 
			}
		}
		case Ifryt: {
			fm_give_item(id, "weapon_hegrenade")
			show_hudmessage(id, "Dostajesz HE grenade") 
		}
		case Strzelec: {
			ultra_armor[id]++
			if(ultra_armor[id]>3)
			{
				ultra_armor[id]=3
				show_hudmessage(id, "Maksymalna wartosc pancerza to 3",ultra_armor[id]) 
			}
			else show_hudmessage(id, "Magiczny pancerz wytrzyma %i strzalow",ultra_armor[id]) 
		}
		
		case Samurai: {
			show_hudmessage(id, "Przez 10 sek masz bonus 50 do ataku nozem!") 
			remove_task(id+TASK_SAM)
			set_task(10.0, "TASK_SAMF", id+TASK_SAM)
			if(player_5hp[id]==0)change_health(id, 1000, id, "")
			player_nal[id]++
			Display_Icon(id,1,"dmg_gas",255,0,0)
		}
		
		case Mroczny: {
			player_nal[id]++
			if(player_nal[id]>5) player_nal[id]=5
			show_hudmessage(id, "Twoje pociski oplataja przeciwnikow! Masz %i pociskow!", player_nal[id]) 
		}
		case Inkwizytor: {
			player_nal[id]++
			if(player_nal[id]>10) player_nal[id]=10
			show_hudmessage(id, "Max %i magicznych tarcz!", player_nal[id]) 
			write_hud(id)
		}
		case Ghull: {

			Zjadaj(id)
			show_hudmessage(id, "Pozerasz trupy!", player_nal[id]) 
		}
		case Dremora: {
			player_nal[id]++
			if(player_nal[id]>5) player_nal[id]=5
			show_hudmessage(id, "Czas zamrozenia kolejnego przeciwnika zostal zwiekszony!", player_nal[id]) 
		}
		case Zjawa: {
			if(get_user_health(id) <= get_maxhp(id)) change_health(id, 10, id, "world");
			show_hudmessage(id, "Dostajesz 10hp!") 
		}
		
		case Zmij: {
			fm_give_item(id, "weapon_tmp")
			fm_give_item(id, "ammo_9mm" );
			fm_give_item(id, "ammo_9mm" );
			fm_give_item(id, "ammo_9mm" ); 
		}
		case Ognik: {
			fm_give_item(id, "weapon_smokegrenade")	
			player_naladowany2[id]=0			
		}
		case Przywolywacz: {
			if(player_nal[id]==0){
				if(player_intelligence[id]>25)
				{
					give_item( id, "weapon_ak47" )
					give_item( id, "weapon_m4a1" )
				}
				if(player_intelligence[id]>75)
				{
					give_item( id, "weapon_awp" )
				}
				if(player_intelligence[id]>125)
				{
					give_item( id, "weapon_sg550" )
					give_item(id, "weapon_g3sg1")
				}
				give_item( id, "weapon_deagle" )
				
				set_user_armor(id,get_user_armor(id)+500)
				give_item(id, "ammo_762nato")
				give_item(id, "ammo_762nato")
				give_item(id, "ammo_762nato")
				fm_give_item(id, "ammo_50ae" );
				fm_give_item(id, "ammo_50ae" );
				fm_give_item(id, "ammo_50ae" ); 
				
				give_item(id, "ammo_556nato")
				give_item(id, "ammo_556nato")
				give_item(id, "ammo_556nato")
				give_item(id, "ammo_338magnum")
				give_item(id, "ammo_338magnum")
				give_item(id, "ammo_338magnum")
				fm_give_item(id, "weapon_hegrenade")
				fm_give_item(id, "weapon_flashbang")
				fm_give_item(id, "weapon_flashbang")
				fm_give_item(id, "weapon_smokegrenade")	
				show_hudmessage(id, "Dostajesz m4a1, ak47, awp, autokampe, granaty i armor!") 
				
				
				give_item(id,"ammo_556nato") 
				give_item(id,"ammo_556nato") 
			}
			player_nal[id]++
		}
		case MagL: {
			Mroz(id)
		}
		case Wysoki: {
			Wysoko(id)
		}
		case Meduza: {
			meduza_skill2(id)
		}
		case Druid: {
			fm_give_item(id, "weapon_hegrenade")
			fm_give_item(id, "weapon_flashbang")
			fm_give_item(id, "weapon_flashbang")
			fm_give_item(id, "weapon_smokegrenade")	
			set_user_armor(id,200)
			show_hudmessage(id, "Dostajesz granaty i armor!") 
		}
		case Drzewiec: {
			change_health(id, 10 + player_intelligence[id] / 25, id, "world");
			efekt_slow_enta(id, 1)			
			drzewiec_obsz(id, 100, 1)
		}
		case Kuroliszek: {
			set_user_gravity(id, 0.25)
		}
		case Gon: {
			if(player_diablo[id]>0 || player_she[id]>0)return
			if(floatround(halflife_time()) < gonTimer[id]) return
			gonTimer[id] = floatround(halflife_time()) + 20;
			for(new i=0;i<3;i++){
				new origin[3]
				get_user_origin(id,origin)
				
				message_begin( MSG_BROADCAST,SVC_TEMPENTITY)
				write_byte( TE_SMOKE ) // 5
				write_coord(origin[0]+random_num(-100,100))
				write_coord(origin[1]+random_num(-100,100))
				write_coord(origin[2]+random_num(-100,100))
				write_short( sprite_smoke )
				write_byte( 22 )  // 10
				write_byte( 10 )  // 10
				message_end()
			}
			player_naladowany2[id] = 1
			new svIndex[32] 
			num_to_str(id,svIndex,32)
			set_task(0.5,"respawn",0,svIndex,32) 	
			for(new i=0;i<3;i++){
				new origin[3]
				get_user_origin(id,origin)
				
				message_begin( MSG_BROADCAST,SVC_TEMPENTITY)
				write_byte( TE_SMOKE ) // 5
				write_coord(origin[0]+random_num(-100,100))
				write_coord(origin[1]+random_num(-100,100))
				write_coord(origin[2]+random_num(-100,100))
				write_short( sprite_smoke )
				write_byte( 22 )  // 10
				write_byte( 10 )  // 10
				message_end()
			}
		}
	}	
}

public drzewiec_obsz(id, totem_dist, czas)
{
	new Float:forigin[3], origin[3]
	pev(id,pev_origin,forigin)	
	FVecIVec(forigin,origin)
	
	
	//Find people near and give them health
	message_begin( MSG_BROADCAST, SVC_TEMPENTITY, origin );
	write_byte( TE_BEAMCYLINDER );
	write_coord( origin[0] );
	write_coord( origin[1] );
	write_coord( origin[2] );
	write_coord( origin[0] );
	write_coord( origin[1] + totem_dist );
	write_coord( origin[2] + totem_dist );
	write_short( sprite_white );
	write_byte( 0 ); // startframe
	write_byte( 0 ); // framerate
	write_byte( 10 ); // life
	write_byte( 10 ); // width
	write_byte( 255 ); // noise
	write_byte( 0 ); // r, g, b
	write_byte( 255 ); // r, g, b
	write_byte( 0 ); // r, g, b
	write_byte( 128 ); // brightness
	write_byte( 5 ); // speed
	message_end();
	new Float:forigin1[3]
	pev(id,pev_origin,forigin1)
	new entlist[513]
	new numfound = find_sphere_class(0,"player", totem_dist + 1.0,entlist,512,forigin1)
	for (new i=0; i < numfound; i++)
	{		
		new pid = entlist[i]
		if (get_user_team(pid) == get_user_team(id))
			continue
		
		if (is_user_alive(pid)){
			Display_Fade(id,2600,2600,0,0,255,0,50)
			efekt_slow_enta(pid,czas)
		}  		
	}
}


////////////////////////////////////////////////////////////////////////////////
//                             Costam dalej                                   //
////////////////////////////////////////////////////////////////////////////////



public chacke_pos(Float:vOrigin[3],axe)
{
	new test=0
	vOrigin[axe]-=15.0
	if(distance_to_floor(vOrigin)<31.0) test++
	vOrigin[axe]+=15.0
	if(distance_to_floor(vOrigin)<31.0) test++
	vOrigin[axe]+=15.0
	if(distance_to_floor(vOrigin)<31.0) test++
	if(test<2) return 0
	vOrigin[axe]-=15.0
	return 1
}

public fw_traceline(Float:vecStart[3],Float:vecEnd[3],ignoreM,id,trace) // pentToSkip == id, for clarity
{
	
	if(!is_user_connected(id))
		return FMRES_IGNORED;
	
	// not a player entity, or player is dead
	if(!is_user_alive(id))
		return FMRES_IGNORED;
	
	
	new hit = get_tr2(trace, TR_pHit)
	
	if(player_class[id] == Dremora ){
		if(is_valid_ent(hit))
		{
			new name[64]
			entity_get_string(hit,EV_SZ_classname,name,63)
			if(is_user_alive(hit)){
				if( get_user_team(id) != get_user_team(hit)){
					player_timed_speed_aim[id] = halflife_time() + 0.4
					set_speedchange(id)
					set_task(0.5, "set_speedchange", id)
				}
			}
		}
	}
	if(player_mrozu[id] > 0){
		if(is_valid_ent(hit))
		{
			new name[64]
			entity_get_string(hit,EV_SZ_classname,name,63)
			if(is_user_alive(hit)){
				if( get_user_team(id) != get_user_team(hit)){
					efekt_slow_lodu(hit, 3)
				}
			}
		}
	}
	// not shooting anything
	if(!(pev(id,pev_button) & IN_ATTACK))
		return FMRES_IGNORED;
	
	if(player_b_blink4[id] >1){
		player_b_blink4[id] = 1
		set_renderchange(id)
	}
	
	new h_bulet=0
	new clip,ammo
	new weapon = get_user_weapon(id,clip,ammo)	
	if(golden_bulet[id]>0) 
	{
		h_bulet=1
	}
	if(player_class[id]==Strzelec){
		if(weapon == CSW_DEAGLE && get_user_frags(hit) > get_user_deaths(hit)) 
		{
			new ag = (player_agility[hit] + player_dextery[hit]) / 50 - 1
			if(ag < 0) ag = 0
			
			if(player_intelligence[id]<50){
				if(random_num(0,3+ag)==0){
					h_bulet=1
				}
			}
			else if(player_intelligence[id]<100 && player_intelligence[id]>=50){
				if(random_num(0,2+ag)==0){
					h_bulet=1
				}
			}
			else if(player_intelligence[id]<150 && player_intelligence[id]>=100){
				if(random_num(0,1+ag)==0){
					h_bulet=1
				}
			}
			else if(player_intelligence[id]>=150){
				if(random_num(0,ag)==0)h_bulet=1
			}
			
		} 

		if(weapon == CSW_AWP && player_awp_hs[id] > 0){
			h_bulet=1
		}

	}
	
	if(is_valid_ent(hit))
	{
		new name[64]
		entity_get_string(hit,EV_SZ_classname,name,63)
		
		if(equal(name,"dbmod_shild"))
		{
			new Float: ori[3]
			entity_get_vector(hit,EV_VEC_origin,ori)
			set_tr2(trace,TR_vecEndPos,vecEnd)
			if(after_bullet[id]>0)
			{			
				new Float: health=entity_get_float(hit,EV_FL_health)
				entity_set_float(hit,EV_FL_health,health-3.0)
				if(health-1.0<0.0) remove_entity(hit)
				after_bullet[id]--
			}
			set_tr2(trace,TR_iHitgroup,8);
			set_tr2(trace,TR_flFraction,1.0);
			return FMRES_SUPERCEDE;
		}
	}	
	
	if(is_user_alive(hit))
	{
		
		if(player_healer[id]>0 &&get_user_team(id) == get_user_team(hit) && weapon == CSW_KNIFE && used_item[id]==false){
			used_item[id]=true
			change_health(hit,player_healer[id],id,"world")
		}
		if(h_bulet)
		{
			set_tr2(trace, TR_iHitgroup, HIT_HEAD) // Redirect shot to head
			
			// Variable angles doesn't really have a use here.
			static hit, Float:head_origin[3], Float:angles[3]
			
			hit = get_tr2(trace, TR_pHit) // Whomever was shot
			engfunc(EngFunc_GetBonePosition, hit, 8, head_origin, angles) // Find origin of head bone (8)
			
			set_tr2(trace, TR_vecEndPos, head_origin) // Blood now comes out of the head!
		}
		if(player_class[hit]==Kuroliszek && (bieg[hit] > floatround(halflife_time()) || random_num(0,3)==0)){
			if(get_tr2(trace, TR_iHitgroup) == HIT_HEAD){
				set_tr2(trace, TR_iHitgroup, 8)
				if(h_bulet) golden_bulet[id]--
			}
		}
		new palchance = 9
		if(player_intelligence[id]>75) palchance = 8
		if(player_intelligence[id]>125) palchance = 7
		if(player_intelligence[id]>175) palchance = 6
		if(player_class[hit]==Mnich && on_knife[hit])
		{
			new button2 = get_user_button(hit);

			if(random_num(0,2)==0 && get_entity_flags(hit) & FL_ONGROUND && !(button2 & (IN_FORWARD+IN_BACK+IN_MOVELEFT+IN_MOVERIGHT)))
			{
				if(player_class[id] != Ninja && player_class[id] != Samurai && player_class[id] != Ognik && weapon != CSW_KNIFE){
					if(after_bullet[id]>0 && get_user_team(id) != get_user_team(hit))
					{
						if(ultra_armor[hit]>0) ultra_armor[hit]--
						else if(player_ultra_armor_left[hit]>0)player_ultra_armor_left[hit]--
						after_bullet[id]--
						if(h_bulet) golden_bulet[id]--
						
					}
					set_tr2(trace, TR_iHitgroup, 8)
					item_take_damage(hit,1)
				}
			}
		}
		else if(player_class[hit]==Zmij && on_knife[hit])
		{
			new c = player_agility[hit]/10
			if(c>15) c = 15
			if(random_num(0,17-c)==0 && get_user_team(id) != get_user_team(hit)){
				if(get_tr2(trace, TR_iHitgroup) == HIT_HEAD){
					set_tr2(trace, TR_iHitgroup, 8)
					if(h_bulet) golden_bulet[id]--
				}
			}
			if(random_num(0,5)==0)
			{
				if(player_class[id] != Ninja && player_class[id] != Samurai && player_class[id] != Ognik && weapon != CSW_KNIFE){
					if(after_bullet[id]>0 && get_user_team(id) != get_user_team(hit))
					{
						if(ultra_armor[hit]>0) ultra_armor[hit]--
						else if(player_ultra_armor_left[hit]>0)player_ultra_armor_left[hit]--
						after_bullet[id]--
						if(h_bulet) golden_bulet[id]--
						
					}
					set_tr2(trace, TR_iHitgroup, 8)
					item_take_damage(hit,1)
				}
			}
		}		
		else if(((player_class[hit]==Strzelec || player_class[hit]==Inkwizytor) &&ultra_armor[hit]>0 && random_num(0,1)==0 )||(player_class[hit]!=Inkwizytor && player_class[hit]!=Strzelec &&ultra_armor[hit]>0 )|| (player_class[hit]==Paladyn && random_num(0,palchance)==1)|| random_num(0,player_ultra_armor_left[hit])==1  || (player_class[hit]==Troll && random_num(0,2)==0) )
		{
			if(player_class[id] != Ninja && player_class[id] != Samurai && player_class[id] != Ognik && weapon != CSW_KNIFE){
				if(after_bullet[id]>0 && get_user_team(id) != get_user_team(hit))
				{
					if(ultra_armor[hit]>0) ultra_armor[hit]--
					else if(player_ultra_armor_left[hit]>0)player_ultra_armor_left[hit]--
					after_bullet[id]--
					if(h_bulet) golden_bulet[id]--
					
				}
				set_tr2(trace, TR_iHitgroup, 8)
				item_take_damage(hit,1)
			}
		}
		if(player_dziewica[hit]>0 && player_dziewica_using[hit]==1){
			change_health(id,-player_dziewica[hit],hit,"world")
			
		}
		if(player_b_tarczaograon[hit]==1){
			set_tr2(trace, TR_iHitgroup, 8)
			if(czas_itemu[hit]<floatround(halflife_time())){
				player_b_tarczaograon[hit] = 0
			}
		}
		return FMRES_IGNORED
	}
	
	return FMRES_IGNORED;
}

stock Float:distance_to_floor(Float:start[3], ignoremonsters = 1) {
	new Float:dest[3], Float:end[3];
	dest[0] = start[0];
	dest[1] = start[1];
	dest[2] = -8191.0;
	
	engfunc(EngFunc_TraceLine, start, dest, ignoremonsters, 0, 0);
	get_tr2(0, TR_vecEndPos, end);
	
	//pev(index, pev_absmin, start);
	new Float:ret = start[2] - end[2];
	
	return ret > 0 ? ret : 0.0;
}

public dmg_exp(id,ofiara, dmg)
{
	if(player_class[id] == 0) return
	new exp=dmg
	exp = exp * lvl_dif_xp_mnoznik[ofiara][id] / 1000
	if(player_class[ofiara] == Druid || player_class[ofiara] == Mnich) exp = exp/20
	if((player_class[ofiara] == Druid ||player_class[ofiara] == Mnich) && get_playersnum() < 10) exp = 1
	if(exp < 1) exp = 1 
	Give_Xp(id,exp)
}

public dmg_exp_mag(id,ofiara, dmg)
{
	if(player_class[id] == 0) return
	new exp=dmg
	exp = exp * lvl_dif_xp_mnoznik[ofiara][id] / 1000
	if(player_class[ofiara] == Druid || player_class[ofiara] == Mnich) exp = exp/20
	if((player_class[ofiara] == Druid ||player_class[ofiara] == Mnich) && get_playersnum() < 10) exp = 1
	if(exp < 1) exp = 1 
	Give_Xp(id,exp)
}




public daj_smoke(id){
	fm_give_item(id, "weapon_smokegrenade")	
	show_hudmessage(id, "Dostajesz smoke grenade") 
	return PLUGIN_CONTINUE
}

public daj_expa(id){
	Give_Xp(id,player_dosw[id])
	player_wys[id]=1
	show_hudmessage(id, "Dostajesz %i doswiadczenia!", player_dosw[id]) 
	Display_Fade(id,2600,2600,0,0,255,0,20)
	player_item_id[id] = 0
	player_item_name[id] = "Nic"
	player_dosw[id] = 0
	return PLUGIN_CONTINUE	
}


public efekt_level(id){
	
	new origin[3]
	get_user_origin(id,origin)
	
	message_begin( MSG_BROADCAST, SVC_TEMPENTITY, origin );
	write_byte( TE_BEAMCYLINDER );
	write_coord( origin[0] +5);
	write_coord( origin[1] );
	write_coord( origin[2] );
	write_coord( origin[0] +5);
	write_coord( origin[1] + 30);
	write_coord( origin[2] + 30);
	write_short( sprite_white );
	write_byte( 0 ); // startframe
	write_byte( 0 ); // framerate
	write_byte( 10 ); // life
	write_byte( 10 ); // width
	write_byte( 255 ); // noise
	write_byte( 55 ); // r, g, b
	write_byte( 55 ); // r, g, b
	write_byte( 255 ); // r, g, b
	write_byte( 128 ); // brightness
	write_byte( 5 ); // speed
	message_end();
}


public efekt_arcy(id){
	for(new i=0;i<5;i++){
		new origin[3]
		get_user_origin(id,origin)
		message_begin( MSG_BROADCAST, SVC_TEMPENTITY, origin );
		write_byte( TE_BEAMCYLINDER );
		write_coord( origin[0] +3*i);
		write_coord( origin[1] );
		write_coord( origin[2] );
		write_coord( origin[0] +3*i);
		write_coord( origin[1] + 100);
		write_coord( origin[2] + 100);
		write_short( sprite_white );
		write_byte( 0 ); // startframe
		write_byte( 0 ); // framerate
		write_byte( 10 ); // life
		write_byte( 10 ); // width
		write_byte( 255 ); // noise
		write_byte( 255 ); // r, g, b
		write_byte( 255 ); // r, g, b
		write_byte( 255 ); // r, g, b
		write_byte( 128 ); // brightness
		write_byte( 5 ); // speed
		message_end();
	}
}
public efekt_magp(id){
	for(new i=0;i<1;i++){
		new origin[3]
		get_user_origin(id,origin)
		message_begin( MSG_BROADCAST, SVC_TEMPENTITY, origin );
		write_byte( TE_BEAMCYLINDER );
		write_coord( origin[0] +3*i);
		write_coord( origin[1] );
		write_coord( origin[2] );
		write_coord( origin[0] +3*i);
		write_coord( origin[1] + 100);
		write_coord( origin[2] + 100);
		write_short( sprite_white );
		write_byte( 0 ); // startframe
		write_byte( 0 ); // framerate
		write_byte( 10 ); // life
		write_byte( 10 ); // width
		write_byte( 255 ); // noise
		write_byte( 55 ); // r, g, b
		write_byte( 55 ); // r, g, b
		write_byte( 255 ); // r, g, b
		write_byte( 128 ); // brightness
		write_byte( 5 ); // speed
		message_end();
	}
}


public item_grom(id){
	new przed = id
	for (new pid=0; pid < 33; pid++)
	{
		
		if (pid == id || !is_user_alive(pid))
			continue
		
		if (get_user_team(id) == get_user_team(pid))
			continue
		
		
		change_health(pid,-player_grom[id],id,"world")
		
		item_grom_blysk(pid, przed)
		set_task(0.1,"item_grom_blysk_db",id) 
		przed = pid
		
	}
	player_item_id[id] = 0
	player_item_name[id] = "Nic"
	player_grom[id] = 0
}
public item_grom_blysk(id, przed){
	new origin[3]
	get_user_origin(przed,origin)
	strumien(id, origin[0],origin[1], origin[2], 255, 255, 255)
	strumien(id, origin[0],origin[1], origin[2], 255, 255, 255)
	strumien(id, origin[0],origin[1], origin[2], 255, 255, 255)
	strumien(id, origin[0],origin[1], origin[2], 255, 255, 255)
	strumien(id, origin[0],origin[1], origin[2], 255, 255, 255)
	strumien(id, origin[0],origin[1], origin[2], 255, 255, 255)
}	



public efekt_devil(id){
	for(new i=0;i<1;i++){
		new origin[3]
		get_user_origin(id,origin)
		message_begin( MSG_BROADCAST, SVC_TEMPENTITY, origin );
		write_byte( TE_BEAMCYLINDER );
		write_coord( origin[0] +3*i);
		write_coord( origin[1] );
		write_coord( origin[2] );
		write_coord( origin[0] +3*i);
		write_coord( origin[1] + 100);
		write_coord( origin[2] + 100);
		write_short( sprite_fire2 );
		write_byte( 10 ); // startframe
		write_byte( 10 ); // framerate
		write_byte( 100 ); // life
		write_byte( 100 ); // width
		write_byte( 255 ); // noise
		write_byte( 255 ); // r, g, b
		write_byte( 0 ); // r, g, b
		write_byte( 0 ); // r, g, b
		write_byte( 128 ); // brightness
		write_byte( 7 ); // speed
		message_end();
	}
}

public efekt_mago(id){
	for(new i=0;i<50;i++){
		new origin[3]
		get_user_origin(id,origin)
		
		message_begin( MSG_BROADCAST,SVC_TEMPENTITY)
		write_byte( TE_SMOKE ) // 5
		write_coord(origin[0]+random_num(-100,100))
		write_coord(origin[1]+random_num(-100,100))
		write_coord(origin[2]+random_num(-100,100))
		write_short( sprite_smoke )
		write_byte( 22 )  // 10
		write_byte( 10 )  // 10
		message_end()
	}
}

public item_lotrzyka(id){
	
	if(player_naladowany2[id] ==0){
		for(new i=0;i<120;i++){
			new origin[3]
			get_user_origin(id,origin)
			
			message_begin( MSG_BROADCAST,SVC_TEMPENTITY)
			write_byte( TE_SMOKE ) // 5
			write_coord(origin[0]+random_num(-100,100))
			write_coord(origin[1]+random_num(-100,100))
			write_coord(origin[2]+random_num(-100,100))
			write_short( sprite_smoke )
			write_byte( 22 )  // 10
			write_byte( 10 )  // 10
			message_end()
		}
		player_naladowany2[id] = 1
		new svIndex[32] 
		num_to_str(id,svIndex,32)
		set_task(0.5,"respawn",0,svIndex,32) 	
		for(new i=0;i<120;i++){
			new origin[3]
			get_user_origin(id,origin)
			
			message_begin( MSG_BROADCAST,SVC_TEMPENTITY)
			write_byte( TE_SMOKE ) // 5
			write_coord(origin[0]+random_num(-100,100))
			write_coord(origin[1]+random_num(-100,100))
			write_coord(origin[2]+random_num(-100,100))
			write_short( sprite_smoke )
			write_byte( 22 )  // 10
			write_byte( 10 )  // 10
			message_end()
		}
	}
	else{
		show_hudmessage(id, "Teleportu mozesz uzyc raz na runde") 
	}
	
	return PLUGIN_CONTINUE
}




public create_flames_n_sounds(id, origin[3], velocity[3])
{
	message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
	write_byte(120)
	write_coord(origin[0])
	write_coord(origin[1])
	write_coord(origin[2])
	write_coord(velocity[0])
	write_coord(velocity[1])
	write_coord(velocity[2] + 5)
	write_short(sprite_fire)
	write_byte(1)
	write_byte(10)
	write_byte(1)
	write_byte(5)
	message_end()
}
stock get_distance_to_line(Float:pos_start[3], Float:pos_end[3], Float:pos_object[3])  
{  
	new Float:vec_start_end[3], Float:vec_start_object[3], Float:vec_end_object[3], Float:vec_end_start[3]
	xs_vec_sub(pos_end, pos_start, vec_start_end) 		// vector from start to end 
	xs_vec_sub(pos_object, pos_start, vec_start_object) 	// vector from end to object 
	xs_vec_sub(pos_start, pos_end, vec_end_start) 		// vector from end to start 
	xs_vec_sub(pos_end, pos_object, vec_end_object) 		// vector object to end 
	
	new Float:len_start_object = getVecLen(vec_start_object) 
	new Float:angle_start = floatacos(xs_vec_dot(vec_start_end, vec_start_object) / (getVecLen(vec_start_end) * len_start_object), degrees)  
	new Float:angle_end = floatacos(xs_vec_dot(vec_end_start, vec_end_object) / (getVecLen(vec_end_start) * getVecLen(vec_end_object)), degrees)  
	
	if(angle_start <= 90.0 && angle_end <= 90.0) 
		return floatround(len_start_object * floatsin(angle_start, degrees)) 
	return -1  
}
stock Float:getVecLen(Float:Vec[3])
{ 
	new Float:VecNull[3] = {0.0, 0.0, 0.0}
	new Float:len = get_distance_f(Vec, VecNull)
	return len
}

public indirect_damage(id, doDamage)
{
	new Players[32], iNum
	get_players(Players, iNum, "a")
	for(new i = 0; i < iNum; ++i) if(id != Players[i])
	{
		new target = Players[i]
		
		new Float:fOrigin[3], Float:fOrigin2[3]
		entity_get_vector(id,EV_VEC_origin, fOrigin)
		entity_get_vector(target, EV_VEC_origin, fOrigin2)
		
		new temp[3], Float:fAim[3]
		get_user_origin(id, temp, 3)
		IVecFVec(temp, fAim)
		
		new Float:fDistance = 80 + 400.0
		if(get_distance_f(fOrigin, fOrigin2) > fDistance)
			continue 
			
		new iDistance = get_distance_to_line(fOrigin, fOrigin2, fAim)
		if(iDistance > 40 || iDistance < 0 || !fm_is_ent_visible(id, target))
				continue 
			
		if(!doDamage)
		{
			if(get_user_team(id) != get_user_team(target))
			{
				change_health(target,-5, id, "world")
			}
		}
		else 
		{
			change_health(target, -5/2, id, "world")
		}
	}
}
public direct_damage(id, doDamage)
{
	new ent, body
	get_user_aiming(id, ent, body, 80 + 400)
	
	if(ent > 0 && is_user_alive(ent))
	{
		if(!doDamage)
		{
			if(get_user_team(id) != get_user_team(ent)) 
			{
				change_health(ent,-5, id, "world")
			}
		}
		else
		{
			change_health(ent,-5/2, id, "world")
		}
	}
}
public show_fuel_percentage(id)
{
	set_hudmessage(255, 0, 0, -1.0, 0.01)
	show_hudmessage(id, "Piekielna moc: %d%%", get_percent(g_FuelTank[id], 50))
}
stock get_percent(value, tvalue) {       
	return floatround(floatmul(float(value) / float(tvalue) , 100.0))  
}
public event_diablo(id){
	if(id==0) id = random_num(1, get_playersnum())
	if (!is_user_alive(id)|| !pev_valid(id) || is_user_bot(id) || isevent ==1){
		return
	}
	isevent = 1
	dropitem(id)
	player_naladowany2[id]=0
	efekt_devil(id)
	player_diablo[id] =1
	isevent_team = id
	g_FuelTank[id] = 50
	
	set_rendering ( id, kRenderFxGlowShell, 255,0,0, kRenderFxNone, 10 )
	cs_set_user_model(id,"barbarian")
	client_cmd(id,"weapon_knife")
	engclient_cmd(id,"weapon_knife")
	on_knife[id]=1
	
	for(new i=0;i<200;i++){
		new origin[3]
		get_user_origin(id,origin)
		
		message_begin( MSG_BROADCAST,SVC_TEMPENTITY)
		write_byte( TE_SMOKE ) // 5
		write_coord(origin[0]+random_num(-50,50))
		write_coord(origin[1]+random_num(-200,200))
		write_coord(origin[2]+random_num(-200,200))
		write_short( sprite_smoke )
		write_byte( 22 )  // 10
		write_byte( 10 )  // 10
		message_end()
	}	
	
	for (new pid=0; pid < 33; pid++)
	{
		if (!is_user_alive(pid)) continue;
		show_hudmessage(pid, "POJAWIA SIE DIABLO") 	
		if (get_user_team(id) != get_user_team(pid)) fm_set_user_health(pid,500)
		
		
		if(is_user_alive(pid) && get_user_team(id) == get_user_team(pid) && pid != id){
			player_ran[pid] = random_num(1,4)			
		}
		if(is_user_alive(pid)) {
			changeskin(pid, 1)
			CurWeapon(pid)
		}
	}
	
	
}



public event_diablo_skill(id){
	
	player_naszyjnikczasu[id] = 20;
	bowdelay[id] = get_gametime()
	switch(random_num(1,10)){
		case 1: item_firetotem(id)
			case 2: dag_db(id)
			case 5: player_grom[id] = 20
			case 6: dag_db(id)
			case 8: dag_db(id)
			case 9: dag_db(id)
			case 10: player_b_meekstone[id] = 1
		}
	bowdelay[id] = get_gametime()
}


public event_she(id){
	
	if(id==0) id = random_num(1, get_playersnum())
	if (!is_user_alive(id)|| !pev_valid(id) || is_user_bot(id) || isevent ==1){
		return
	}
	isevent = 1
	dropitem(id)
	player_naladowany2[id]=0
	isevent_team = id
	efekt_she(id)
	player_she[id] =1
	set_rendering ( id, kRenderFxGlowShell, 255,255,255, kRenderFxNone, 10 )
	client_cmd(id,"weapon_knife")
	engclient_cmd(id,"weapon_knife")
	cs_set_user_model(id,"barbarian")
	on_knife[id]=1
	
	for (new pid=0; pid < 33; pid++)
	{
		show_hudmessage(id, "POJAWIA SIE DEADRYCZNY KSIAZE SHEOGORATH!") 	
		if (get_user_team(id) != get_user_team(pid)) fm_set_user_health(pid,500) 
	}
	
	
}



public event_she_skill(id){
	player_naszyjnikczasu[id] = 20;
	bowdelay[id] = get_gametime()
	switch(random_num(1,10)){
		case 1: add_space_she(id)
			case 2: add_space_she(id)
			case 3: add_space_she(id)
			case 5: player_grom[id] = 10
			case 6: dag_db(id)
			case 8: dag_db(id)
			case 9: add_space_she(id)
			case 10: add_space_she(id)
		}
	
}



public efekt_she(id){
	for(new i=0;i<1;i++){
		new kolor= random_num(0,255)
		new speed = random_num(1,15)
		new origin[3]
		get_user_origin(id,origin)
		message_begin( MSG_BROADCAST, SVC_TEMPENTITY, origin );
		write_byte( TE_BEAMCYLINDER );
		write_coord( origin[0] +3*i);
		write_coord( origin[1] );
		write_coord( origin[2] );
		write_coord( origin[0] +3*i);
		write_coord( origin[1] + 100);
		write_coord( origin[2] + 100);
		write_short( sprite_fire2 );
		write_byte( 10 ); // startframe
		write_byte( 10 ); // framerate
		write_byte( 100 ); // life
		write_byte( 100 ); // width
		write_byte( 255 ); // noise
		write_byte( kolor ); // r, g, b
		write_byte( kolor ); // r, g, b
		write_byte( kolor ); // r, g, b
		write_byte( 128 ); // brightness
		write_byte( speed ); // speed
		message_end();
	}
}
public efekt_kill(id){
	add_bonus_explode(id)
	for(new i=0;i<10;i++){
		new kolor= 255
		new speed = 10
		new origin[3]
		get_user_origin(id,origin)
		message_begin( MSG_BROADCAST, SVC_TEMPENTITY, origin );
		write_byte( TE_BEAMCYLINDER );
		write_coord( origin[0] +3*i);
		write_coord( origin[1] );
		write_coord( origin[2] );
		write_coord( origin[0] +3*i);
		write_coord( origin[1] + 100);
		write_coord( origin[2] + 100);
		write_short( sprite_fire2 );
		write_byte( 10 ); // startframe
		write_byte( 10 ); // framerate
		write_byte( 100 ); // life
		write_byte( 100 ); // width
		write_byte( 255 ); // noise
		write_byte( kolor ); // r, g, b
		write_byte( kolor ); // r, g, b
		write_byte( kolor ); // r, g, b
		write_byte( 128 ); // brightness
		write_byte( speed ); // speed
		message_end();
	}
}



public add_space_she(id)
{
	add_bonus_space(id)
	
	new origin[3]
	get_user_origin(id,origin)
	new dam = 10
	earthstomp[id] = 0
	
	message_begin(MSG_ONE , get_user_msgid("ScreenShake") , {0,0,0} ,id)
	write_short( 1<<14 );
	write_short( 1<<12 );
	write_short( 1<<14 );
	message_end();
	
	new entlist[513]
	new numfound = find_sphere_class(id,"player",5000.0+player_intelligence[id]*2,entlist,512)
	
	if (is_user_alive(id)){
		for (new i=0; i < numfound; i++)
		{		
			
			new pid = entlist[i]
			if (pid == id || !is_user_alive(pid))
				continue
			
			message_begin(MSG_ONE , get_user_msgid("ScreenShake") , {0,0,0} ,pid)
			write_short( 1<<14 );
			write_short( 1<<12 );
			write_short( 1<<14 );
			message_end();
			
			if (get_user_team(id) == get_user_team(pid))
				continue
			
			
			if (random_num(1,1) == 1 && player_class[pid] != Drzewiec)  DropWeapon(pid)
			new Float:id_origin[3]
			new Float:pid_origin[3]
			new Float:delta_vec[3]
			
			pev(id,pev_origin,id_origin)
			pev(pid,pev_origin,pid_origin)
			
			
			delta_vec[x] = (pid_origin[x]-id_origin[x])+10
			delta_vec[y] = (pid_origin[y]-id_origin[y])+100
			delta_vec[z] = (pid_origin[z]-id_origin[z])+2000
			
			set_pev(pid,pev_velocity,delta_vec)
			
			message_begin(MSG_ONE , get_user_msgid("ScreenShake") , {0,0,0} ,pid)
			write_short( 1<<14 );
			write_short( 1<<12 );
			write_short( 1<<14 );
			message_end();
			
			change_health(pid,-dam,id,"world")
			set_gravitychange(pid)
		}
	}	
	return PLUGIN_CONTINUE
}



public item_tarczaogra(id)
{
	if(used_item[id]){
		show_hudmessage(id, "Tego itemu mozesz uzyc tylko raz na runde")
		return
	}
	used_item[id] = true
	czas_itemu[id]=floatround(halflife_time()) + player_b_tarczaogra[id]
	player_b_tarczaograon[id] = 1
	set_speedchange(id)
	set_renderchange(id)
	client_cmd(id,"weapon_knife")
	engclient_cmd(id,"weapon_knife")
	on_knife[id]=1
}


public postac(id)
{
	
	
	new itemEffect[500]
	
	new TempSkill[21]					//There must be a smarter way
	
	if (player_xp[id] > 0)
	{
		num_to_str(player_xp[id]+50000,TempSkill,20)
		add(itemEffect,499,"Gdy kupisz 50 tys expa bedziesz mial ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," doswiadczenia i ")
		new p = 0
		for(new i=0; i<1001;i++){
			if(diablo_typ==2 && i>101){
				p=101
				break
			}
			if(player_xp[id]+50000 < LevelXP[i+1]){
				p = i+1
				break
			} 
		}
		num_to_str(p,TempSkill,20)
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," level <br>")
	}
	if (player_xp[id] > 0)
	{
		num_to_str(player_xp[id]+100000,TempSkill,20)
		add(itemEffect,499,"Gdy kupisz 100 tys expa bedziesz mial ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," doswiadczenia i ")
		new p = 0
		for(new i=0; i<1001;i++){
			if(diablo_typ==2 && i>101){
				p=101
				break
			}
			if(player_xp[id]+100000 < LevelXP[i+1]){
				p = i+1
				break
			} 
		}
		num_to_str(p,TempSkill,20)
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," level <br>")
	}
	if (player_xp[id] > 0)
	{
		num_to_str(player_xp[id]+200000,TempSkill,20)
		add(itemEffect,499,"Gdy kupisz 200 tys expa bedziesz mial ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," doswiadczenia i ")
		new p = 0
		for(new i=0; i<1001;i++){
			if(diablo_typ==2 && i>101){
				p=101
				break
			}
			if(player_xp[id]+200000 < LevelXP[i+1]){
				p = i+1
				break
			} 
		}
		num_to_str(p,TempSkill,20)
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," level <br>")
	}
	if (player_xp[id] > 0)
	{
		num_to_str(player_xp[id]+500000,TempSkill,20)
		add(itemEffect,499,"Gdy kupisz 500 tys expa bedziesz mial ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," doswiadczenia i ")
		new p = 0
		for(new i=0; i<1001;i++){
			if(diablo_typ==2 && i>101){
				p=101
				break
			}
			if(player_xp[id]+500000 < LevelXP[i+1]){
				p = i+1
				break
			} 
		}
		num_to_str(p,TempSkill,20)
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," level <br>")
	}
	new exp[21]
	num_to_str(player_xp[id],exp,20)
	new lvl[10]
	num_to_str(player_lvl[id],lvl,9)
	if(player_lvl[id] <prorasa){
		showitem2(id,Race[player_class[id]],Rasa[player_class[id]],player_item_name[id],lvl,exp,itemEffect)
	} else {
		showitem2(id,ProRace[player_class[id]],Rasa[player_class[id]],player_item_name[id],lvl,exp,itemEffect)
		showitem2(id,ProRace[player_class[id]],Rasa[player_class[id]],player_item_name[id],lvl,exp,itemEffect)
	}
	
}


public showitem2(id, klasa[],rasa[],item[],lvl[],exp[],itemeffect[])
{
	new diabloDir[64]	
	
	new g_ItemFile[64]
	new amxbasedir[64]
	get_basedir(amxbasedir,63)
	
	formatex(diabloDir,63,"%s/diablo",amxbasedir)
	
	if (!dir_exists(diabloDir))
	{
		new errormsg[512]
		formatex(errormsg,511,"Blad: Folder %s/diablo nie mogl byc znaleziony. Prosze skopiowac ten folder z archiwum do folderu amxmodx",amxbasedir)
		show_motd(id, errormsg, "An error has occured")	
		return PLUGIN_HANDLED
	}
	
	
	formatex(g_ItemFile,63,"%s/diablo/klasa.txt",amxbasedir)
	if(file_exists(g_ItemFile))
		delete_file(g_ItemFile)
	
	new Data[768]
	
	//Header
	formatex(Data,767,"<html><head><title>Twoja postac</title></head>")
	write_file(g_ItemFile,Data,-1)
	
	//Background
	formatex(Data,767,"<body text=^"#FFFF00^" bgcolor=^"#000000^" background=^"%sdrkmotr.jpg^">",Basepath)
	write_file(g_ItemFile,Data,-1)
	
	//Table stuff
	formatex(Data,767,"<table border=^"0^" cellpadding=^"0^" cellspacing=^"0^" style=^"border-collapse: collapse^" width=^"100%s^"><tr><td width=^"0^">","^%")
	write_file(g_ItemFile,Data,-1)
	
	//ss.gif image
	formatex(Data,767,"<p align=^"center^"><img border=^"0^" src=^"%sss.gif^"></td>",Basepath)
	write_file(g_ItemFile,Data,-1)
	
	//item name
	formatex(Data,767,"<td width=^"0^"><p align=^"center^"><font face=^"Arial^"><font color=^"#FFCC00^"><b>Rasa: </b>%s</font><br>",rasa)
	write_file(g_ItemFile,Data,-1)
	
	//item name
	formatex(Data,767,"<font color=^"#FFCC00^"><b>Klasa: </b>%s</font><br>",klasa)
	write_file(g_ItemFile,Data,-1)
	
	//item name
	formatex(Data,767,"<font color=^"#FFCC00^"><b>Item: </b>%s</font><br>",item)
	write_file(g_ItemFile,Data,-1)
	
	//item value
	formatex(Data,767,"<font color=^"#FFCC00^"><b><br>Poziom: </b>%s</font><br>",lvl)
	write_file(g_ItemFile,Data,-1)
	
	//item value
	formatex(Data,767,"<font color=^"#FFCC00^"><b>Doswiadczenie: </b>%s</font><br>",exp)
	write_file(g_ItemFile,Data,-1)
	
	//Effects
	formatex(Data,767,"<font color=^"#FFCC00^"><b>Kupno:<br></b> %s</font></font></td>",itemeffect)
	write_file(g_ItemFile,Data,-1)
	
	//image ss
	formatex(Data,767,"<td width=^"0^"><p align=^"center^"><img border=^"0^" src=^"%sgf.gif^"></td>", Basepath)
	write_file(g_ItemFile,Data,-1)
	
	//end
	formatex(Data,767,"</tr></table></body></html>")
	write_file(g_ItemFile,Data,-1)
	
	//show window with message
	show_motd(id, g_ItemFile, "Twoja postac")
	
	return PLUGIN_HANDLED
	
}





public item_laska(id)
{
	if(player_item_licznik[id] + player_laska[id] < floatround(halflife_time())){
		player_item_licznik[id] = floatround(halflife_time())
		show_hudmessage(id, "Wyczarowales lightball'a") 
		fired[id]=0
		item_fireball(id)
	}
}


public item_lembasy(id)
{
	if(used_item[id]){
		show_hudmessage(id, "Tego itemu mozesz uzyc tylko raz na runde")
		return
	}
	
	used_item[id] = true
	change_health(id, player_lembasy[id]*25, id, "")
	czas_itemu[id]=floatround(halflife_time()) + player_lembasy[id]
	player_b_tarczaograon[id] = 1
	set_renderchange(id)
	set_speedchange(id)
	//set_user_health(id, get_user_health(id) + player_lembasy[id]*25) 
	client_cmd(id,"weapon_knife")
	engclient_cmd(id,"weapon_knife")
	on_knife[id]=1
	
}
public OddajPrzedmiot(id)
{
	if(diablo_typ!=1) return
	if(get_user_flags(id) & ADMIN_LEVEL_H){
		new menu = menu_create("Oddaj przedmiot", "OddajPrzedmiot_Handle");
		new cb = menu_makecallback("OddajPrzedmiot_Callback");
		new numer_przedmiotu;
		for(new i=0; i<=32; i++)
		{
			if(!is_user_connected(i))
				continue;
			oddaj_id[numer_przedmiotu++] = i;
			new nazwa_gracza[64]
			get_user_name(i,nazwa_gracza,32)
			menu_additem(menu, nazwa_gracza, "0", 0, cb);
		}
		menu_display(id, menu);
	}
}




public OddajPrzedmiot_Handle(id, menu, item)
{
	if(oddaj_id[item]>32 || oddaj_id[item] <1) oddaj_id[item] = 1
	if(!is_user_connected(oddaj_id[item]))
	{
		client_print(id, print_chat, "Nie odnaleziono rzadanego gracza.");
		return PLUGIN_CONTINUE;
	}
	
	if(dostal_przedmiot[id])
	{
		client_print(id, print_chat, "Musisz poczekac 1 runde.");
		return PLUGIN_CONTINUE;
	}
	if(oddaj_item_id[oddaj_id[item]]!=0)
	{
		client_print(id, print_chat, "Gracz czeka by kupic inny item, aby wziac ten musi wpisac /wywal");
		return PLUGIN_CONTINUE;
	}
	if(player_item_id[id]==0)
	{
		client_print(id, print_chat, "Nie masz zadnego przedmiotu.");
		return PLUGIN_CONTINUE;
	}
	if(player_item_id[oddaj_id[item]])
	{
		client_print(id, print_chat, "Ten gracz ma juz przedmiot, abys mogl mu przekazac item musi wpisac /drop");
		return PLUGIN_CONTINUE;
	}
	
	oddaj_item_id[oddaj_id[item]]  = player_item_id[id]
	oddaj_item_id_w[oddaj_id[item]]  = item_durability[id]
	new nazwa_gracza[64]
	get_user_name(oddaj_id[item],nazwa_gracza,32)
	
	
	
	client_print(id, print_chat, "Przekazales %s graczowi %s.",nazwa_itemu ,nazwa_gracza);
	get_user_name(id,nazwa_gracza,32)
	client_print(oddaj_id[item], print_chat, "Dostales %s od gracza %s aby wziac go za 5000 wpisz /wez, aby pozbyc sie go wpisz /wywal", nazwa_itemu,  nazwa_gracza);
	
	dropitem(id);
	return PLUGIN_CONTINUE;
}

public OddajPrzedmiot_Callback(id, menu, item)
{
	if(oddaj_id[item] == id)
		return ITEM_DISABLED;
	return ITEM_ENABLED;
}

public wywal(id){
	oddaj_item_id[id] = 0
}

public wez(id){
	if(diablo_typ!=1) return PLUGIN_CONTINUE;
	if(oddaj_item_id[id]==0)
	{
		client_print(id, print_chat, "Nie ma itemu do wziecia.");
		return PLUGIN_CONTINUE;
	}
	if(player_item_id[id]!=0)
	{
		client_print(id, print_chat, "Masz juz inny item, aby sie go pozbyc wpisz /drop.");
		return PLUGIN_CONTINUE;
	}
	if(cs_get_user_money(id)>5000){
		dropitem(id)
		cs_set_user_money(id,cs_get_user_money(id)-5000)
		dostal_przedmiot[id] = true;
		award_item(id, oddaj_item_id[id])
		oddaj_item_id[id] = 0
		if(oddaj_item_id_w[id]>0){
			item_durability[id] = oddaj_item_id_w[id]
			oddaj_item_id_w[id] = 0
		}
	}
	else{
		client_print(id, print_chat, "Nie masz 5000$.");
	}
	
	return PLUGIN_CONTINUE;
}


public item_totem_enta(id)
{
	
	if(player_totem_enta[id]>0 && used_item[id] ==true ){
		hudmsg(id,2.0,"Totem enta mozesz uzyc raz na runde!")
		return PLUGIN_CONTINUE
	}
	used_item[id] = true
	
	new origin[3]
	pev(id,pev_origin,origin)
	
	new ent = Spawn_Ent("info_target")
	set_pev(ent,pev_classname,"Effect_Enta_Totem")
	set_pev(ent,pev_owner,id)
	set_pev(ent,pev_solid,SOLID_TRIGGER)
	set_pev(ent,pev_origin,origin)
	set_pev(ent,pev_ltime, halflife_time()  + 5 + 0.1)
	
	engfunc(EngFunc_SetModel, ent, "addons/amxmodx/diablo/totem_heal.mdl")  	
	set_rendering ( ent, kRenderFxGlowShell, 0, 255, 0, kRenderFxNone, 255 ) 	
	engfunc(EngFunc_DropToFloor,ent)
	
	set_pev(ent,pev_euser3,0)
	set_pev(ent,pev_nextthink, halflife_time()  + 4+ 0.1)
	
	return PLUGIN_CONTINUE	
}

public Effect_Enta_Totem_Think(ent)
{	
	
	if (!is_valid_ent(ent))
		return PLUGIN_CONTINUE
	
	
	new id = pev(ent,pev_owner)
	new totem_dist = player_totem_enta_zasieg[id]*2 + player_intelligence[id]
	new czas_enta = player_totem_enta[id]
	//We have emitted beam. Apply effect (this is delayed)
	
	
	//Entity should be destroyed because livetime is over
	if (pev(ent,pev_ltime) < halflife_time() || !is_user_alive(id))
	{
		remove_entity(ent)
		return PLUGIN_CONTINUE
	}
	
	//If this object is almost dead, apply some render to make it fade out
	if (pev(ent,pev_ltime)-2.0 < halflife_time()) set_rendering ( ent, kRenderFxNone, 255,255,255, kRenderTransAlpha, 100 ) 
	
	new Float:forigin[3], origin[3]
	pev(ent,pev_origin,forigin)	
	FVecIVec(forigin,origin)
	
	//Find people near and give them health
	message_begin( MSG_BROADCAST, SVC_TEMPENTITY, origin );
	write_byte( TE_BEAMCYLINDER );
	write_coord( origin[0] );
	write_coord( origin[1] );
	write_coord( origin[2] );
	write_coord( origin[0] );
	write_coord( origin[1] + totem_dist );
	write_coord( origin[2] + totem_dist );
	write_short( sprite_white );
	write_byte( 0 ); // startframe
	write_byte( 0 ); // framerate
	write_byte( 10 ); // life
	write_byte( 10 ); // width
	write_byte( 255 ); // noise
	write_byte( 0 ); // r, g, b
	write_byte( 255 ); // r, g, b
	write_byte( 0 ); // r, g, b
	write_byte( 128 ); // brightness
	write_byte( 5 ); // speed
	message_end();
	
	set_pev(ent,pev_euser2,1)
	set_pev(ent,pev_nextthink, halflife_time() + 0.5)
	
	new Float:forigin1[3], origin1[3]
	pev(ent,pev_origin,forigin1)	
	FVecIVec(forigin1,origin1)
	//Find people near and damage them
	new entlist[513]
	new numfound = find_sphere_class(0,"player",totem_dist+0.0,entlist,512,forigin1)
	for (new i=0; i < numfound; i++)
	{		
		new pid = entlist[i]
		if (get_user_team(pid) == get_user_team(id))
			continue
		
		if (is_user_alive(pid)){
			Display_Fade(id,2600,2600,0,0,255,0,50)
			efekt_slow_enta(pid,czas_enta)
		}  		
	}
	
	set_pev(ent,pev_euser2,0)
	set_pev(ent,pev_nextthink, halflife_time() + 1.5)
	
	
	
	
	remove_entity(ent)
	return PLUGIN_CONTINUE
	
}


public efekt_slow_enta(id, czas_enta){
	if(!is_user_connected(id)) return;
	if(player_b_szarza_time[id] > floatround(halflife_time()))return;
	if(ofiara_totem_enta[id] > floatround(halflife_time())) return;
	if(player_b_nieust[id] + player_b_nieust2[id] >0){
		czas_enta  =  (czas_enta *(100 - (player_b_nieust[id]+player_b_nieust2[id]) )/ 100)
	}
	ofiara_totem_enta[id] = floatround(halflife_time()) + czas_enta
	set_speedchange(id)
	hudmsg(id,2.0,"Oplataja Cie korzenie!")
	set_renderchange(id)
	set_gravitychange(id)
	new svIndex[32] 
	num_to_str(id,svIndex,32)
	Display_Icon(id ,ICON_SHOW ,"dmg_cold" ,0,255,0)
	set_task(czas_enta+0.1,"task_koniec",0,svIndex,32) 	
}


public item_totem_lodu(id)
{
	
	if(player_totem_lodu[id]>0 && used_item[id] ==true ){
		hudmsg(id,2.0,"Totem enta mozesz uzyc raz na runde!")
		return PLUGIN_CONTINUE
	}
	used_item[id] = true
	
	new origin[3]
	pev(id,pev_origin,origin)
	
	new ent = Spawn_Ent("info_target")
	set_pev(ent,pev_classname,"Effect_Lodu_Totem")
	set_pev(ent,pev_owner,id)
	set_pev(ent,pev_solid,SOLID_TRIGGER)
	set_pev(ent,pev_origin,origin)
	set_pev(ent,pev_ltime, halflife_time()  + 5 + 0.1)
	
	engfunc(EngFunc_SetModel, ent, "addons/amxmodx/diablo/totem_heal.mdl")  	
	set_rendering ( ent, kRenderFxGlowShell, 0, 0, 200, kRenderFxNone, 255 ) 	
	engfunc(EngFunc_DropToFloor,ent)
	
	set_pev(ent,pev_euser3,0)
	set_pev(ent,pev_nextthink, halflife_time()  + 4+ 0.1)
	
	return PLUGIN_CONTINUE	
}

public Effect_Lodu_Totem_Think(ent)
{	
	
	if (!is_valid_ent(ent))
		return PLUGIN_CONTINUE
	
	
	new id = pev(ent,pev_owner)
	new totem_dist = player_totem_lodu_zasieg[id]*2 + player_intelligence[id]
	new czas_enta = player_totem_lodu[id]
	//We have emitted beam. Apply effect (this is delayed)
	
	
	//Entity should be destroyed because livetime is over
	if (pev(ent,pev_ltime) < halflife_time() || !is_user_alive(id))
	{
		remove_entity(ent)
		return PLUGIN_CONTINUE
	}
	
	//If this object is almost dead, apply some render to make it fade out
	if (pev(ent,pev_ltime)-2.0 < halflife_time()) set_rendering ( ent, kRenderFxNone, 255,255,255, kRenderTransAlpha, 100 ) 
	
	new Float:forigin[3], origin[3]
	pev(ent,pev_origin,forigin)	
	FVecIVec(forigin,origin)
	
	//Find people near and give them health
	message_begin( MSG_BROADCAST, SVC_TEMPENTITY, origin );
	write_byte( TE_BEAMCYLINDER );
	write_coord( origin[0] );
	write_coord( origin[1] );
	write_coord( origin[2] );
	write_coord( origin[0] );
	write_coord( origin[1] + totem_dist );
	write_coord( origin[2] + totem_dist );
	write_short( sprite_white );
	write_byte( 0 ); // startframe
	write_byte( 0 ); // framerate
	write_byte( 10 ); // life
	write_byte( 10 ); // width
	write_byte( 255 ); // noise
	write_byte( 0 ); // r, g, b
	write_byte( 0 ); // r, g, b
	write_byte( 200 ); // r, g, b
	write_byte( 128 ); // brightness
	write_byte( 5 ); // speed
	message_end();
	
	set_pev(ent,pev_euser2,1)
	set_pev(ent,pev_nextthink, halflife_time() + 0.5)
	
	new Float:forigin1[3], origin1[3]
	pev(ent,pev_origin,forigin1)	
	FVecIVec(forigin1,origin1)
	//Find people near and damage them
	new entlist[513]
	new numfound = find_sphere_class(0,"player",totem_dist+0.0,entlist,512,forigin1)
	for (new i=0; i < numfound; i++)
	{		
		new pid = entlist[i]
		if (get_user_team(pid) == get_user_team(id))
			continue
		if (is_user_alive(pid)){
			Display_Fade(id,2600,2600,0,0,0,255,50)
			efekt_slow_lodu(pid,czas_enta)	
		}  					
		
	}
	
	set_pev(ent,pev_euser2,0)
	set_pev(ent,pev_nextthink, halflife_time() + 1.5)
	
	
	
	
	remove_entity(ent)
	return PLUGIN_CONTINUE
	
}


public efekt_slow_lodu(id, czas_enta){
	if(!is_user_connected(id)) return;
	if(ofiara_totem_lodu[id] > floatround(halflife_time())) return;
	if(player_b_szarza_time[id] > floatround(halflife_time()))return;
	if(player_b_nieust[id] >0){
		czas_enta  =  (czas_enta *(100 - (player_b_nieust[id] +player_b_nieust2[id]))/ 100)
	}
	ofiara_totem_lodu[id] = floatround(halflife_time()) + czas_enta
	set_speedchange(id)
	hudmsg(id,2.0,"Zostales zamrozony!")
	set_renderchange(id)
	new svIndex[32] 
	num_to_str(id,svIndex,32)
	Display_Icon(id ,ICON_SHOW ,"dmg_cold" ,0,0,255)
	set_task(czas_enta+0.1,"task_koniec",0,svIndex,32) 	
}



public task_koniec(svIndex[])
{
	new id = str_to_num(svIndex)
	if(!is_user_connected(id)) return;
	set_renderchange(id)
	set_speedchange(id)
	set_gravitychange(id)
	Display_Icon(id ,ICON_HIDE ,"dmg_cold" ,0,0,255)
	Display_Icon(id ,ICON_HIDE ,"dmg_cold" ,0,255,0)
}




public item_totem_powietrza(id)
{
	
	if(player_totem_powietrza_zasieg[id]>0 && used_item[id] ==true ){
		hudmsg(id,2.0,"Totem powietrza mozesz uzyc raz na runde!")
		return PLUGIN_CONTINUE
	}
	used_item[id] = true
	
	new origin[3]
	pev(id,pev_origin,origin)
	
	new ent = Spawn_Ent("info_target")
	set_pev(ent,pev_classname,"Effect_Powietrza_Totem")
	set_pev(ent,pev_owner,id)
	set_pev(ent,pev_solid,SOLID_TRIGGER)
	set_pev(ent,pev_origin,origin)
	set_pev(ent,pev_ltime, halflife_time()  + 2 + 0.1)
	
	engfunc(EngFunc_SetModel, ent, "addons/amxmodx/diablo/totem_heal.mdl")  	
	set_rendering ( ent, kRenderFxGlowShell, 0, 0, 255, kRenderFxNone, 255 ) 	
	engfunc(EngFunc_DropToFloor,ent)
	
	set_pev(ent,pev_euser3,0)
	set_pev(ent,pev_nextthink, halflife_time()  + 1 + 0.1)
	
	return PLUGIN_CONTINUE	
}

public Effect_Powietrza_Totem_Think(ent)
{	
	
	if (!is_valid_ent(ent))
		return PLUGIN_CONTINUE
	new id = pev(ent,pev_owner)
	new totem_dist = player_totem_powietrza_zasieg[id]*2 + player_intelligence[id]
	if (pev(ent,pev_ltime) < halflife_time() || !is_user_alive(id))
	{
		remove_entity(ent)
		return PLUGIN_CONTINUE
	}
	
	//If this object is almost dead, apply some render to make it fade out
	if (pev(ent,pev_ltime)-2.0 < halflife_time()) set_rendering ( ent, kRenderFxNone, 255,255,255, kRenderTransAlpha, 100 ) 
	
	new Float:forigin[3], origin[3]
	pev(ent,pev_origin,forigin)	
	FVecIVec(forigin,origin)
	
	//Find people near and give them health
	message_begin( MSG_BROADCAST, SVC_TEMPENTITY, origin );
	write_byte( TE_BEAMCYLINDER );
	write_coord( origin[0] );
	write_coord( origin[1] );
	write_coord( origin[2] );
	write_coord( origin[0] );
	write_coord( origin[1] + totem_dist );
	write_coord( origin[2] + totem_dist );
	write_short( sprite_white );
	write_byte( 0 ); // startframe
	write_byte( 0 ); // framerate
	write_byte( 10 ); // life
	write_byte( 10 ); // width
	write_byte( 255 ); // noise
	write_byte( 0 ); // r, g, b
	write_byte( 0 ); // r, g, b
	write_byte( 255 ); // r, g, b
	write_byte( 128 ); // brightness
	write_byte( 5 ); // speed
	message_end();
	
	set_pev(ent,pev_euser2,1)
	set_pev(ent,pev_nextthink, halflife_time() + 0.5)
	
	new Float:forigin1[3], origin1[3]
	pev(ent,pev_origin,forigin1)	
	FVecIVec(forigin1,origin1)
	//Find people near and damage them
	new entlist[513]
	new numfound = find_sphere_class(0,"player",totem_dist+0.0,entlist,512,forigin1)
	for (new i=0; i < numfound; i++)
	{		
		new pid = entlist[i]
		if (get_user_team(pid) == get_user_team(id))
			continue

		if (is_user_alive(pid) && player_class[pid] != Drzewiec && player_class[pid] != Zmij) DropWeapon(pid)
	}
	
	set_pev(ent,pev_euser2,0)
	set_pev(ent,pev_nextthink, halflife_time() + 1.5)
	
	remove_entity(ent)
	return PLUGIN_CONTINUE
}




public item_trapnade(id){
	
	new clip,ammo
	new weapon = get_user_weapon(id,clip,ammo)
	switch(weapon)
	{
		case CSW_HEGRENADE, CSW_FLASHBANG, CSW_SMOKEGRENADE:
		{
			if((g_PreThinkDelay[id] + 0.28) < get_gametime())
			{
				switch(g_TrapMode[id])
				{
					case 0: g_TrapMode[id] = 1
						case 1: g_TrapMode[id] = 0
					}
				if(czas_rundy + 10 > floatround(halflife_time())){
					g_TrapMode[id] = 1
				}
				client_print(id, print_center, "Grenade Trap %s", g_TrapMode[id] ? "[ON]" : "[OFF]")
				g_PreThinkDelay[id] = get_gametime()
			}
		}
		default: g_TrapMode[id] = 0
	}
	
}

public item_chwila_ryzyka(id){
	new a =  random_num(1,2)
	if(a==1) user_kill(id,1) 
	if(a==2){
		cs_set_user_money(id,cs_get_user_money(id)+20000)
		show_hudmessage(id, "Dostajesz 20 000$ !") 
		Give_Xp(id, 200);
	}
	dropitem(id)
}


public refill_a(id)
{
	set_hudmessage(255, 0, 0, -1.0, 0.01)
	show_hudmessage(id, "Uzupelnienie ammo")
	new wpnid
	if(!is_user_alive(id)) return;
	
	
	new wpn[32],clip,ammo
	wpnid = get_user_weapon(id, clip, ammo)
	get_weaponname(wpnid,wpn,31)
	
	new wEnt;
	
	// set clip ammo
	wpnid = get_weaponid(wpn)
	//wEnt = get_weapon_ent(id,wpnid);
	wEnt = get_weapon_ent(id,wpnid);
	cs_set_weapon_ammo(wEnt,maxClip[wpnid]);
} 




public bonus_pro(id)
{
	ispro[id] = 0
	hp_pro_bonus=0
	if(is_user_connected(id) && super ==1 &&   player_lvl[id] >prorasa)
	{
		ispro[id] = 1
		
		if(player_class[id] == Barbarzynca)
		{
			ultra_armor[id]=7
		}
		
	}
	
}

public add_ran_weapon(id)
{
	new weapon_id = find_ent_by_owner(-1, "weapon_ak47", id)
	if(weapon_id==0)  weapon_id = find_ent_by_owner(-1, "weapon_m4a1", id)
	if(weapon_id==0)  weapon_id = find_ent_by_owner(-1, "weapon_m249", id)
	if(weapon_id==0)  weapon_id = find_ent_by_owner(-1, "weapon_awp", id)
	
	if(weapon_id==0){
		new r = random_num(0,9)
		switch(r){
			case  0:{
				fm_give_item(id, "weapon_ak47")
			}
			case  1:{
				fm_give_item(id, "weapon_aug")
			}
			case  2:{
				fm_give_item(id, "weapon_g3sg1")
			}
			case  3:{
				fm_give_item(id, "weapon_m249")
			}
			case  4:{
				fm_give_item(id, "weapon_m4a1")
			}
			case  5:{
				fm_give_item(id, "weapon_mac10")
			}
			case  6:{
				fm_give_item(id, "weapon_mp5navy")
			}
			case  7:{
				fm_give_item(id, "weapon_scout")
			}
			case  8:{
				fm_give_item(id, "weapon_p90")
			}
			case  9:{
				fm_give_item(id, "weapon_tmp")
			}
			case  10:{
				fm_give_item(id, "weapon_xm1014")
			}	
			case  11:{
				fm_give_item(id, "weapon_ump45")
			}
		}
		
	}
	
	
}
public dag_db(id)
{
	new czas = 25 - player_intelligence[id]/5 - player_naszyjnikczasu[id] 
	
	
	
	if(czas<10)czas=10
	if (halflife_time()-bowdelay[id] <= czas && player_diablo[id]==0 && player_she[id]==0)
	{
		
		show_hudmessage(id, "Ten skill moze byc uzyty co kazde %i sekundy", czas)
		return PLUGIN_CONTINUE
	}
	
	for (new pid=0; pid < 33; pid++)
	{
		
		if (pid == id || !is_user_alive(pid))
			continue
		
		if (get_user_team(id) == get_user_team(pid))
			continue
		
		
		change_health(pid,-50,id,"world")
		item_grom_blysk_db(pid)
		set_task(0.1,"item_grom_blysk_db",id) 
		
		
	}
	return PLUGIN_CONTINUE
	
}

public item_grom_blysk_db(id){
	new origin[3]
	new r = random_num(0,255);
	new g = random_num(0,255);
	new b = random_num(0,255);
	
	if(random_num(0,2)==1){
		r = 255;
		b = 255;
		g = 255;
		
	}
	get_user_origin(id,origin)
	strumien(id, origin[0],origin[1], origin[2]+500, r, g, b)
	
	
}

public item_grav_up(pid)
{
	new Float:delta_vec[3]
	
	
	delta_vec[x] =0.0
	delta_vec[y] =0.0
	delta_vec[z] =50.0		
	set_pev(pid,pev_velocity,delta_vec)
}


public item_grav(id)
{
	
	if( used_item[id] ==true ){
		hudmsg(id,2.0,"Mozesz uzyc raz na runde!")
		return PLUGIN_CONTINUE
	}
	used_item[id] = true
	new origin[3]
	get_user_origin(id,origin)
	message_begin(MSG_ONE , get_user_msgid("ScreenShake") , {0,0,0} ,id)
	write_short( 1<<14 );
	write_short( 1<<12 );
	write_short( 1<<14 );
	message_end();
	new inta = player_intelligence[id]
	new entlist[513]
	new numfound = find_sphere_class(id,"player",800.0+inta*2,entlist,512)
	for (new i=0; i < numfound; i++)
	{		
		new pid = entlist[i]
		
		if (!is_user_alive(pid))
			continue
		
		if (get_user_team(id) == get_user_team(pid) )
			continue
		
		ofiara_gravi[pid] = floatround(halflife_time()) + player_antygravi[id] 
		set_gravitychange(pid)
		if (!(pev(pid, pev_flags) & FL_ONGROUND)) continue	
		
		new Float:id_origin[3]
		new Float:delta_vec[3]
		new Float:pid_origin[3]
		pev(id,pev_origin,id_origin)
		pev(pid,pev_origin,pid_origin)
		
		
		delta_vec[x] =0.0
		delta_vec[y] =0.0
		delta_vec[z] =400.0
		
		set_pev(pid,pev_velocity,delta_vec)
		shake(pid)	
		
		set_gravitychange(pid)	
		set_task(player_antygravi[id]+0.1, "set_gravitychange",pid)
		set_task(0.5, "item_grav_up",pid)
		set_task(1.0, "item_grav_up",pid)
		set_task(1.5, "item_grav_up",pid)
		set_task(2.0, "item_grav_up",pid)
		set_task(2.5, "item_grav_up",pid)
	}
	
	message_begin( MSG_BROADCAST, SVC_TEMPENTITY, origin );
	write_byte( TE_BEAMCYLINDER );
	write_coord( origin[0] );
	write_coord( origin[1] );
	write_coord( origin[2] );
	write_coord( origin[0] );
	write_coord( origin[1] + 500+inta*2 );
	write_coord( origin[2] + 500+inta*2 );
	write_short( sprite_white );
	write_byte( 0 ); // startframe
	write_byte( 0 ); // framerate
	write_byte( 10 ); // life
	write_byte( 10 ); // width
	write_byte( 255 ); // noise
	write_byte(250 ); // r, g, b
	write_byte( 250 ); // r, g, b
	write_byte( 250 ); // r, g, b
	write_byte( 128 ); // brightness
	write_byte( 8 ); // speed
	message_end();	
	return PLUGIN_CONTINUE
}




public item_aard(id)
{
	
	if( used_item[id] ==true ){
		hudmsg(id,2.0,"Aard mozesz uzyc raz na runde!")
		return PLUGIN_CONTINUE
	}
	used_item[id] = true
	new origin[3]
	get_user_origin(id,origin)
	message_begin(MSG_ONE , get_user_msgid("ScreenShake") , {0,0,0} ,id)
	write_short( 1<<14 );
	write_short( 1<<12 );
	write_short( 1<<14 );
	message_end();
	new inta = player_intelligence[id]
	new entlist[513]
	new numfound = find_sphere_class(id,"player",500.0+inta*2,entlist,512)
	for (new i=0; i < numfound; i++)
	{		
		new pid = entlist[i]
		
		if (pid == id || !is_user_alive(pid))
			continue
		
		if (get_user_team(id) == get_user_team(pid))
			continue
		
		if (!(pev(pid, pev_flags) & FL_ONGROUND)) continue	
		
		new Float:id_origin[3]
		new Float:pid_origin[3]
		new Float:delta_vec[3]
		
		pev(id,pev_origin,id_origin)
		pev(pid,pev_origin,pid_origin)
		
		
		delta_vec[x] = (pid_origin[x]-id_origin[x])*100.0
		delta_vec[y] = (pid_origin[y]-id_origin[y])*100.0
		delta_vec[z] = 200.0
		
		set_pev(pid,pev_velocity,delta_vec)
		shake(pid)			
		change_health(pid,-10,id,"world")	
		
		
	}
	
	message_begin( MSG_BROADCAST, SVC_TEMPENTITY, origin );
	write_byte( TE_BEAMCYLINDER );
	write_coord( origin[0] );
	write_coord( origin[1] );
	write_coord( origin[2] );
	write_coord( origin[0] );
	write_coord( origin[1] + 500+inta*2 );
	write_coord( origin[2] + 500+inta*2 );
	write_short( sprite_white );
	write_byte( 0 ); // startframe
	write_byte( 0 ); // framerate
	write_byte( 10 ); // life
	write_byte( 10 ); // width
	write_byte( 255 ); // noise
	write_byte(250 ); // r, g, b
	write_byte( 250 ); // r, g, b
	write_byte( 250 ); // r, g, b
	write_byte( 128 ); // brightness
	write_byte( 8 ); // speed
	message_end();	
	return PLUGIN_CONTINUE
}



public shake(pid)
{
	message_begin(MSG_ONE , get_user_msgid("ScreenShake") , {0,0,0} ,pid)
	write_short( 1<<14 );
	write_short( 1<<12 );
	write_short( 1<<14 );
	message_end();
}
public res(){
	if(resy<=1){
		server_cmd("sv_restart 1") 
		resy++
		set_task(5.0, "res")
	}
}



public add_wid(id)
{
	new Players[32], playerCount
	get_players(Players, playerCount, "ah") 
	
	for (new i=0; i<playerCount; i++) 
	{
		id = Players[i] 
		
		if(player_class[id]==Samurai){
			new speed = 50
			if(player_lvl[id]>prorasa){
				new Float:vect[3]
				entity_get_vector(id,EV_VEC_velocity,vect)
				speed= floatround(floatsqroot(vect[0]*vect[0]+vect[1]*vect[1]+vect[2]*vect[2]))
			}
			
			if(speed>5){
				if(player_b_inv[id] < 20){
					player_b_inv[id] += 2
				}
				else if(player_b_inv[id] < 50){
					player_b_inv[id] += 4
				}
				else{
					player_b_inv[id] += 90
				}
				
				if(player_b_inv[id] > 200){
					player_b_inv[id] =0
				}  
			}
			
			set_renderchange(id)
			write_hud(id)
		}
	}
}

public check_lvl()
{
	new Players[32], playerCount
	get_players(Players, playerCount, "ah") 
	
	for (new i=0; i<playerCount; i++) 
	{
		new id = Players[i] 
		diablo_redirect_check_low(id)
		diablo_redirect_check_high(id)
	}
}
public add_hp(id)
{
	new Players[32], playerCount
	get_players(Players, playerCount, "ah") 
	
	for (new i=0; i<playerCount; i++) 
	{
		id = Players[i] 
		if(!is_user_connected(id)) continue
		
		if(player_class[id]==Mnich && player_5hp[id]==0){
			change_health(id,10 + player_intelligence[id]/5,id,"world");
		}
		if(player_trac_hp[id]>0 ){
			change_health(id,-player_trac_hp[id],0,"world");
		}
		
		if(player_class[id]== Gon && get_user_health(id) > 5){
			change_health(id,-1,0,"world");
		}
		
	}
}
stock Effect_waz(id,attacker,damage)
{
	hudmsg( id,3.0,"Jestes zatruty!")
	Display_Fade( id,1<<14,1<<14 ,1<<16,255,255,255,30)
	new ent = Spawn_Ent("info_target")
	set_pev(ent,pev_classname,"Effect_waz")
	set_pev(ent,pev_owner,id)
	set_pev(ent,pev_ltime, halflife_time() + 99 + 0.1)
	set_pev(ent,pev_solid,SOLID_NOT)
	set_pev(ent,pev_euser1,attacker)
	set_pev(ent,pev_euser2,damage)
	set_pev(ent,pev_nextthink, halflife_time() + 0.1)	
	AddFlag(id,Flag_truc)
	
}

//euser3 = destroy and apply effect
public Effect_waz_Think(ent)
{
	new id = pev(ent,pev_owner)
	if(player_odpornosc_fire[id]>0) return PLUGIN_CONTINUE
	
	attacker = pev(ent,pev_euser1)
	new damage = pev(ent,pev_euser2)
	if (pev(ent,pev_ltime) < halflife_time() || !is_user_alive(id) || !HasFlag(id,Flag_truc))
	{
		RemoveFlag(id,Flag_truc)
		Remove_All_Tents(id)
		Display_Icon(id ,0 ,"dmg_heat" ,0,200,0)
		
		remove_entity(ent)		
		return PLUGIN_CONTINUE
	}
	
	//Display ignite tent and icon
	Display_Tent(id,sprite_ignite2,2)
	Display_Icon(id ,1 ,"dmg_heat" ,0,200,0)
	
	new origin[3]
	get_user_origin(id,origin)
	
	//Decals
	message_begin( MSG_BROADCAST,SVC_TEMPENTITY)
	write_byte( TE_GUNSHOTDECAL ) // decal and ricochet sound
	write_coord( origin[0] ) //pos
	write_coord( origin[1] )
	write_coord( origin[2] )
	write_short (0) // I have no idea what thats supposed to be
	write_byte (random_num(199,201)) //decal
	message_end()
	//Do the actual damage
	change_health(id,-damage,attacker, "world")
	set_pev(ent,pev_nextthink, halflife_time() + 1.5)
	return PLUGIN_CONTINUE
}



public Mroz(id)
{
	new entlist[513]
	new numfound = find_sphere_class(id,"player",500.0+player_intelligence[id]*2,entlist,512)
	for (new i=0; i < numfound; i++)
	{		
		new pid = entlist[i]
		
		if (pid == id || !is_user_alive(pid))
			continue
		
		if (get_user_team(id) == get_user_team(pid))
			continue
		
		if (!(pev(pid, pev_flags) & FL_ONGROUND)) continue	
		
		efekt_slow_lodu(pid,6)				
	}
	new origin[3]
	get_user_origin(id,origin)
	message_begin( MSG_BROADCAST, SVC_TEMPENTITY, origin );
	write_byte( TE_BEAMCYLINDER );
	write_coord( origin[0] );
	write_coord( origin[1] );
	write_coord( origin[2] );
	write_coord( origin[0] );
	write_coord( origin[1] + 500+player_intelligence[id]*2 );
	write_coord( origin[2] + 500+player_intelligence[id]*2 );
	write_short( sprite_white );
	write_byte( 0 ); // startframe
	write_byte( 0 ); // framerate
	write_byte( 10 ); // life
	write_byte( 10 ); // width
	write_byte( 255 ); // noise
	write_byte( 100 ); // r, g, b
	write_byte( 100 ); // r, g, b
	write_byte( 250 ); // r, g, b
	write_byte( 128 ); // brightness
	write_byte( 5 ); // speed
	message_end();		
	return PLUGIN_CONTINUE
}

public Zjadaj(id)
{	
	static Float:origin[3]
	pev(id, pev_origin, origin)
	
	new ent
	static classname[32]	
	while((ent = fm_find_ent_in_sphere(ent, origin, 3*player_intelligence[id]+1000.0 )) != 0) 
	{
		if(!is_valid_ent(ent)) continue;
		pev(ent, pev_classname, classname, 31)
		if(equali(classname, "fake_corpse") && fm_is_ent_visible(id, ent)){
			if(!fm_is_valid_ent(ent))
			{
				failed_revive(id)
				return FMRES_IGNORED
			}
			
			
			if(diablo_typ==3){
				if(random_num(0,2)==0 && ghull_max[id]<=10){
					player_nal[id]++
					change_health(id, 20, id, "world")
					ghull_max[id]++
				}
			}else{
			
				player_nal[id]++
				change_health(id, 20 + player_intelligence[id]/10, id, "world")
				ghull_max[id]++
				new lucky_bastard = pev(ent, pev_owner)
				if (get_user_team(id) == get_user_team(lucky_bastard) &&player_lich[id]>0) my_zombie(lucky_bastard, id)
			}
			fm_remove_entity(ent)
		}
	}
	new origin2[3]
	get_user_origin(id,origin2)
	message_begin( MSG_BROADCAST, SVC_TEMPENTITY, origin2 );
	write_byte( TE_BEAMCYLINDER );
	write_coord( origin2[0] );
	write_coord( origin2[1] );
	write_coord( origin2[2] );
	write_coord( origin2[0] );
	write_coord( origin2[1] + 3*player_intelligence[id]+1000 );
	write_coord( origin2[2] + 3*player_intelligence[id]+1000 );
	write_short( sprite_white );
	write_byte( 0 ); // startframe
	write_byte( 0 ); // framerate
	write_byte( 10 ); // life
	write_byte( 10 ); // width
	write_byte( 255 ); // noise
	write_byte( 250 ); // r, g, b
	write_byte( 0 ); // r, g, b
	write_byte( 0 ); // r, g, b
	write_byte( 100 ); // brightness
	write_byte( 3 ); // speed
	message_end();	
	return PLUGIN_CONTINUE
}

public zjawa_skill(id)
{
	if(skill_time[id] < floatround(halflife_time())){
		if(ghoststate[id] == 0 && is_user_alive(id) && ghost_check[id] == false){
			skill_time[id] = floatround(halflife_time())
			new bonus = 25 - player_intelligence[id] / 5 - player_naszyjnikczasu[id]
			if(bonus < 10) bonus = 10
			skill_time[id] += bonus
			player_naladowany[id] = 1
			set_user_noclip(id,1)
			ghoststate[id] = 2
			ghosttime[id] = floatround(halflife_time()) + 5
			ghost_check[id] = true
			
			message_begin( MSG_ONE, gmsgBartimer, {0,0,0}, id ) 
			write_byte( 5 ) 
			write_byte( 0 ) 
			message_end() 
		}
		else
		{
			hudmsg(id,3.0,"Moc uzyta! ")
		}
	}
}


public Timed_Ghost_Check(id)
{

	new Globaltime = floatround(halflife_time())
	
	new Players[32], playerCount, a
	get_players(Players, playerCount, "h") 
	
	for (new i=0; i<playerCount; i++) 
	{
		a = Players[i] 
		if (ghoststate[a] == 2 && Globaltime - player_b_ghost[a] > ghosttime[a] && ghost_check[a] == true)
		{
			ghoststate[a] = 3
			if(player_class[a]==Zjawa) ghoststate[a] = 0
			ghosttime[a] = 0
			set_user_noclip(a,0)
			ghost_check[a] = false
			new Float:aOrigin[3]
			entity_get_vector(a,EV_VEC_origin,aOrigin)	
			
			if (PointContents (aOrigin) != -1)
			{
				user_kill(a,1)	
			}
			else
			{
				aOrigin[2]+=10
				entity_set_vector(a,EV_VEC_origin,aOrigin)
			}
		}
		if(player_class[a] == Samurai){
			new Float:fVecVelocity[3], iSpeed
			entity_get_vector(a, EV_VEC_velocity, fVecVelocity)
			iSpeed = floatround( vector_length(fVecVelocity) )
			lastspeed[a] = iSpeed
		}
		if(player_class[a]==Mroczny){
			new button2 = get_user_button(a);			
			if ( (button2 & IN_DUCK)){
				new mh = get_maxhp(a) * 3 / 100
				change_health(a, -mh, 0,"world");
			}
		}
	}
}

public command_flara(id) 
{
	if(!is_user_alive(id)) return PLUGIN_HANDLED
	if(skill_time[id] < floatround(halflife_time())){
		skill_time[id] = floatround(halflife_time())
		new bonus = 12 - player_intelligence[id] / 10 - player_naszyjnikczasu[id]
		if(bonus < 5) bonus = 5
		skill_time[id] += bonus
		player_naladowany[id] = 1
	
		new Float: Origin[3], Float: Velocity[3], Float: vAngle[3], Ent
		
		entity_get_vector(id, EV_VEC_origin , Origin)
		entity_get_vector(id, EV_VEC_v_angle, vAngle)
		
		Ent = create_entity("info_target")
		
		if (!Ent) return PLUGIN_HANDLED
		
		entity_set_string(Ent, EV_SZ_classname, "flara")
		entity_set_model(Ent, cbow_bolt)
		
		new Float:MinBox[3] = {-2.8, -2.8, -2.8}
		new Float:MaxBox[3] = {2.8, 2.8, 2.8}
		entity_set_vector(Ent, EV_VEC_mins, MinBox)
		entity_set_vector(Ent, EV_VEC_maxs, MaxBox)
		
		vAngle[0]*= -1
		Origin[2]+=10
		entity_set_origin(Ent, Origin)
		entity_set_vector(Ent, EV_VEC_angles, vAngle)
		entity_set_int(Ent, EV_INT_effects, 2)
		entity_set_int(Ent, EV_INT_solid, 1)
		entity_set_int(Ent, EV_INT_movetype, 5)
		entity_set_edict(Ent, EV_ENT_owner, id)
		new Float:dmg = 10.0 + player_intelligence[id]*1.2
		entity_set_float(Ent, EV_FL_dmg,dmg)
		new speed = 1000
		VelocityByAim(id, speed , Velocity)
		set_rendering (Ent,kRenderFxGlowShell, 255,0,0, kRenderNormal,100)
		entity_set_vector(Ent, EV_VEC_velocity ,Velocity)
		return PLUGIN_HANDLED
	}
	return PLUGIN_HANDLED
}


public Wysoko(id)
{
	new entlist[513]
	new numfound = find_sphere_class(id,"player",500.0+player_intelligence[id]*2,entlist,512)
	for (new i=0; i < numfound; i++)
	{		
		new pid = entlist[i]
		
		if (pid == id || !is_user_alive(pid))
			continue
		
		if (get_user_team(id) == get_user_team(pid))
			continue
		
		if (!(pev(pid, pev_flags) & FL_ONGROUND)) continue	
		new index1 = pid
		if ((index1!=54) && (is_user_connected(index1))){
			if(player_b_szarza_time[index1] > floatround(halflife_time())){}
			else{
				set_user_rendering(index1,kRenderFxGlowShell,flashlight_r,flashlight_g,flashlight_b,kRenderNormal,4)	
				remove_task(TASK_FLASH_LIGHT+index1);
				set_task(7.5, "un_rander",TASK_FLASH_LIGHT+index1)
				Display_Icon(index1 ,ICON_SHOW ,"stopwatch" ,200,0,200)
			}
		}
		
	}
	new origin[3]
	get_user_origin(id,origin)
	message_begin( MSG_BROADCAST, SVC_TEMPENTITY, origin );
	write_byte( TE_BEAMCYLINDER );
	write_coord( origin[0] );
	write_coord( origin[1] );
	write_coord( origin[2] );
	write_coord( origin[0] );
	write_coord( origin[1] + 500+player_intelligence[id]*2 );
	write_coord( origin[2] + 500+player_intelligence[id]*2 );
	write_short( sprite_white );
	write_byte( 0 ); // startframe
	write_byte( 0 ); // framerate
	write_byte( 10 ); // life
	write_byte( 10 ); // width
	write_byte( 255 ); // noise
	write_byte( 250 ); // r, g, b
	write_byte( 250 ); // r, g, b
	write_byte( 250 ); // r, g, b
	write_byte( 128 ); // brightness
	write_byte( 3 ); // speed
	message_end();		
	return PLUGIN_CONTINUE
}

public item_totemheal(id)
{
	
	if (used_item[id] )
	{
		hudmsg(id,2.0,"Leczacy Totem mozesz uzyc raz na runde!")
		return PLUGIN_CONTINUE
	}
	
	if(player_item_id[id]==176 && player_b_skill[id] <= 0 ){
		hudmsg(id,2.0,"Leczacy Totem mozesz uzyc raz na runde!")
		return PLUGIN_CONTINUE
	}
	
	hudmsg(id,2.0,"Leczacy Totem!")
	
	
	new origin[3]
	pev(id,pev_origin,origin)
	
	new ent = Spawn_Ent("info_target")
	set_pev(ent,pev_classname,"Effect_Healing_Totem")
	set_pev(ent,pev_owner,id)
	set_pev(ent,pev_solid,SOLID_TRIGGER)
	set_pev(ent,pev_origin,origin)
	set_pev(ent,pev_ltime, halflife_time() + 7 + 0.1)
	
	engfunc(EngFunc_SetModel, ent, "addons/amxmodx/diablo/totem_heal.mdl")  	
	set_rendering ( ent, kRenderFxGlowShell, 255,0,0, kRenderFxNone, 255 ) 	
	engfunc(EngFunc_DropToFloor,ent)
	
	set_pev(ent,pev_nextthink, halflife_time() + 0.1)
	used_item[id] = true
	
	return PLUGIN_CONTINUE	
}

public Effect_Healing_Totem_Think(ent)
{
	new id = pev(ent,pev_owner)
	new totem_dist = 300
	new amount_healed = 0
	amount_healed = player_b_heal[id]
	if(player_class[id]==Druid){
		new in = 10 + player_intelligence[id] / 2
		if(in>110) in = 110
		amount_healed += in
	} 
	else if( player_class[id]==Heretyk){
		new in = 2 + player_intelligence[id] / 5
		amount_healed += in
		if(amount_healed>40) amount_healed=40
	} 
	
	if(amount_healed < 2) return PLUGIN_CONTINUE
	//We have emitted beam. Apply effect (this is delayed)
	if (pev(ent,pev_euser2) == 1)
	{		
		new Float:forigin[3], origin[3]
		pev(ent,pev_origin,forigin)	
		FVecIVec(forigin,origin)
		
		//Find people near and damage them
		new entlist[513]
		new numfound = find_sphere_class(0,"player",totem_dist+0.0,entlist,512,forigin)
		
		for (new i=0; i < numfound; i++)
		{		
			new pid = entlist[i]
			if (!is_user_alive(pid)) continue
			
			if (get_user_team(pid) != get_user_team(id) && player_class[id]==Druid && player_lvl[id]>prorasa){
				change_health(pid,-3,id,"world")	
				new kasa = 10 + 2*player_intelligence[id]
				if(kasa>1000) kasa = 1000 
				if(cs_get_user_money(pid)-kasa > 0){
					cs_set_user_money(pid,cs_get_user_money(pid)-kasa)
					cs_set_user_money(id,cs_get_user_money(id)+kasa)
				} else{
					kasa = cs_get_user_money(pid)
					cs_set_user_money(id,cs_get_user_money(id)+kasa)
					cs_set_user_money(pid,0)
				}				
							
			}
			
			if (get_user_team(pid) != get_user_team(id))
				continue
			
			change_health(pid,amount_healed,0,"")	
			
			if(player_class[id]==Druid)
			{
				RemoveFlag(pid,Flag_Ignite)
				RemoveFlag(pid,Flag_truc)
				RemoveFlag(id,Flag_Ignite)
				RemoveFlag(id,Flag_truc)
			}
		}
		
		set_pev(ent,pev_euser2,0)
		set_pev(ent,pev_nextthink, halflife_time() + 1.5)
		
		return PLUGIN_CONTINUE
	}
	
	//Entity should be destroyed because livetime is over
	if (pev(ent,pev_ltime) < halflife_time() || !is_user_alive(id))
	{
		remove_entity(ent)
		return PLUGIN_CONTINUE
	}
	
	//If this object is almost dead, apply some render to make it fade out
	if (pev(ent,pev_ltime)-2.0 < halflife_time())
		set_rendering ( ent, kRenderFxNone, 255,255,255, kRenderTransAlpha, 100 ) 
	
	new Float:forigin[3], origin[3]
	pev(ent,pev_origin,forigin)	
	FVecIVec(forigin,origin)
	
	//Find people near and give them health
	message_begin( MSG_BROADCAST, SVC_TEMPENTITY, origin );
	write_byte( TE_BEAMCYLINDER );
	write_coord( origin[0] );
	write_coord( origin[1] );
	write_coord( origin[2] );
	write_coord( origin[0] );
	write_coord( origin[1] + totem_dist );
	write_coord( origin[2] + totem_dist );
	write_short( sprite_white );
	write_byte( 0 ); // startframe
	write_byte( 0 ); // framerate
	write_byte( 10 ); // life
	write_byte( 10 ); // width
	write_byte( 255 ); // noise
	write_byte( 255 ); // r, g, b
	write_byte( 100 ); // r, g, b
	write_byte( 100 ); // r, g, b
	write_byte( 128 ); // brightness
	write_byte( 5 ); // speed
	message_end();
	
	set_pev(ent,pev_euser2,1)
	set_pev(ent,pev_nextthink, halflife_time() + 0.5)
	
	
	return PLUGIN_CONTINUE
	
}

public druid_skill(id){
	if(!is_user_alive(id)) return PLUGIN_HANDLED
	if(skill_time[id] < floatround(halflife_time())){
		skill_time[id] = floatround(halflife_time())
		new bonus = 20 - player_intelligence[id] / 5 - player_naszyjnikczasu[id]
		if(bonus < 8) bonus = 8
		skill_time[id] += bonus
		player_naladowany[id] = 1
		
		hudmsg(id,2.0,"Leczacy Totem!")
		
		
		new origin[3]
		pev(id,pev_origin,origin)
		
		new ent = Spawn_Ent("info_target")
		set_pev(ent,pev_classname,"Effect_Healing_Totem")
		set_pev(ent,pev_owner,id)
		set_pev(ent,pev_solid,SOLID_TRIGGER)
		set_pev(ent,pev_origin,origin)
		set_pev(ent,pev_ltime, halflife_time() + 7 + 0.1)
		
		engfunc(EngFunc_SetModel, ent, "addons/amxmodx/diablo/totem_heal.mdl")  	
		set_rendering ( ent, kRenderFxGlowShell, 255,0,0, kRenderFxNone, 255 ) 	
		engfunc(EngFunc_DropToFloor,ent)
		
		set_pev(ent,pev_nextthink, halflife_time() + 0.1)
		
		return PLUGIN_CONTINUE	
		
	}
	return PLUGIN_CONTINUE	
}
public heretyk_skill(id){
	if(!is_user_alive(id)) return PLUGIN_HANDLED
	if(skill_time2[id] < floatround(halflife_time())){
		skill_time2[id] = floatround(halflife_time())
		new bonus = 20 - player_intelligence[id] / 10 - player_naszyjnikczasu[id]
		if(bonus < 8) bonus = 8
		skill_time2[id] += bonus
		player_naladowany[id] = 1
		
		hudmsg(id,2.0,"Leczacy Totem!")
		
		
		new origin[3]
		pev(id,pev_origin,origin)
		
		new ent = Spawn_Ent("info_target")
		set_pev(ent,pev_classname,"Effect_Healing_Totem")
		set_pev(ent,pev_owner,id)
		set_pev(ent,pev_solid,SOLID_TRIGGER)
		set_pev(ent,pev_origin,origin)
		set_pev(ent,pev_ltime, halflife_time() + 7 + 0.1)
		
		engfunc(EngFunc_SetModel, ent, "addons/amxmodx/diablo/totem_heal.mdl")  	
		set_rendering ( ent, kRenderFxGlowShell, 255,0,0, kRenderFxNone, 255 ) 	
		engfunc(EngFunc_DropToFloor,ent)
		
		set_pev(ent,pev_nextthink, halflife_time() + 0.1)
		
		return PLUGIN_CONTINUE	
		
	}
	return PLUGIN_CONTINUE	
}
public meduza_skill(id){
	if(!is_user_alive(id)) return PLUGIN_HANDLED
	if(skill_time[id] < floatround(halflife_time())){
		skill_time[id] = floatround(halflife_time())
		new bonus = 40 - player_intelligence[id] / 5 - player_naszyjnikczasu[id]
		if(bonus < 20) bonus = 20
		skill_time[id] += bonus
		player_naladowany[id] = 1
		set_task(10.0, "meduza_skill_off", id)
		hudmsg(id,2.0,"Zamieniasz w kamien!")
		skam[id] = 1		
		return PLUGIN_CONTINUE	
	}
	return PLUGIN_CONTINUE	
}

public meduza_skill_off(id){
	skam[id] = 0
}

public meduza_skill2(id){
	if(!is_user_alive(id)) return PLUGIN_HANDLED
	
	new entlist[513]
	new numfound = find_sphere_class(id,"player",500.0+player_intelligence[id],entlist,512)
	for (new i=0; i < numfound; i++)
	{		
		new pid = entlist[i]
		
		if (pid == id || !is_user_alive(pid))
			continue
		
		if (get_user_team(id) == get_user_team(pid))
			continue
		
		if (!(pev(pid, pev_flags) & FL_ONGROUND)) continue
		
		
		Display_Fade(pid,1<<14,1<<14 ,1<<16,255,255,255,230)	
		
	}
	new origin[3]
	get_user_origin(id,origin)
	message_begin( MSG_BROADCAST, SVC_TEMPENTITY, origin );
	write_byte( TE_BEAMCYLINDER );
	write_coord( origin[0] );
	write_coord( origin[1] );
	write_coord( origin[2] );
	write_coord( origin[0] );
	write_coord( origin[1] + 800+player_intelligence[id]*2 );
	write_coord( origin[2] + 800+player_intelligence[id]*2 );
	write_short( sprite_white );
	write_byte( 0 ); // startframe
	write_byte( 0 ); // framerate
	write_byte( 10 ); // life
	write_byte( 10 ); // width
	write_byte( 255 ); // noise
	write_byte( 250 ); // r, g, b
	write_byte( 250 ); // r, g, b
	write_byte( 250 ); // r, g, b
	write_byte( 128 ); // brightness
	write_byte( 3 ); // speed
	message_end();		
	return PLUGIN_CONTINUE
	
}


public ifryt_skill(id)
{
	if(!is_user_alive(id)) return PLUGIN_HANDLED
	if(skill_time[id] < floatround(halflife_time())){
		skill_time[id] = floatround(halflife_time())
		new bonus = 20 - player_intelligence[id] / 10 - player_naszyjnikczasu[id]
		if(bonus < 10) bonus = 10
		skill_time[id] += bonus
		player_naladowany[id] = 1
		Effect_wybuch_Totem(id,5)
	}
	return PLUGIN_HANDLED
}




stock Effect_wybuch_Totem(id,seconds)
{
	new origin[3]
	pev(id,pev_origin,origin)
	
	new ent = Spawn_Ent("info_target")
	set_pev(ent,pev_classname,"Effect_wybuch_Totem")
	set_pev(ent,pev_owner,id)
	set_pev(ent,pev_solid,SOLID_TRIGGER)
	set_pev(ent,pev_origin,origin)
	set_pev(ent,pev_ltime, halflife_time() + seconds + 0.1)
	
	engfunc(EngFunc_SetModel, ent, "addons/amxmodx/diablo/totem_ignite.mdl")  	
	
	set_rendering ( ent, kRenderFxGlowShell, 255,0,0, kRenderFxNone, 255 ) 	
	engfunc(EngFunc_DropToFloor,ent)
	if(player_class[id]==Ifryt) engfunc(EngFunc_SetModel, ent, dragon_totem)  
	if(player_class[id]==Ifryt) set_rendering ( ent, kRenderFxGlowShell, 100,0,0, kRenderFxNone, 50 ) 	
	
	set_pev(ent,pev_euser3,0)
	set_pev(ent,pev_nextthink, halflife_time() + 0.1)
}

public Effect_wybuch_Totem_Think(ent)
{
	//Safe check because effect on death
	if (!freeze_ended)
		remove_entity(ent)
	if (!is_valid_ent(ent))
		return PLUGIN_CONTINUE
	
	new id = pev(ent,pev_owner)
	//Apply and destroy
	if (pev(ent,pev_euser3) == 1)
	{
		new entlist[513]
		new numfound = find_sphere_class(ent,"player",500.0 + player_intelligence[id] ,entlist,512)
		
		for (new i=0; i < numfound; i++)
		{		
			new pid = entlist[i]
			
			if (!is_user_alive(pid) || get_user_team(id) == get_user_team(pid) ||   cs_get_user_team(pid) == CS_TEAM_SPECTATOR || pid == id )
				continue
			
			//if (player_class[pid]==MagL)  continue
			
			if (is_user_alive(pid)) {
				
				new df = 1 + player_intelligence[id] / 25 - player_dextery[pid] / 10  + player_strength[pid] / 25 + (get_maxhp(pid)/100)
				if(df>25) df = 25
				if(!fm_is_ent_visible(pid,id) && !fm_is_ent_visible(pid,id)) df = df/5;
				Effect_Ignite(pid,id,df)
				new d_ = -20 -(25*get_maxhp(pid)/100) + player_dextery[pid] / 2
				if(d_ > -10) d_ = -10
				if(!fm_is_ent_visible(pid,id) && !fm_is_ent_visible(pid,id)) d_ = d_/5;
				change_health(pid, d_ -(10*get_maxhp(pid)/100) ,id, "world")
				
				new Float:origin2[3]
				entity_get_vector(pid, EV_VEC_origin , origin2)
				
				message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
				write_byte(3)
				write_coord(floatround(origin2[0]))
				write_coord(floatround(origin2[1]))
				write_coord(floatround(origin2[2]))
				write_short(sprite_fire3)
				write_byte(50)
				write_byte(15)
				write_byte(0)
				message_end()
			}
			
		}
		
		remove_entity(ent)
		return PLUGIN_CONTINUE
	}
	//Entity should be destroyed because livetime is over
	if (pev(ent,pev_ltime) < halflife_time())
	{
		set_pev(ent,pev_euser3,1)
		//Show animation and die
		new Float:forigin[3], origin2[3]
		
		pev(ent,pev_origin,forigin)	
		FVecIVec(forigin,origin2)
		//Find people near and give them health
		message_begin( MSG_BROADCAST, SVC_TEMPENTITY, origin2 );
		write_byte( TE_BEAMCYLINDER );
		write_coord( origin2[0] );
		write_coord( origin2[1] );
		write_coord( origin2[2] );
		write_coord( origin2[0] );
		write_coord( origin2[1] + 500 + player_intelligence[id] *2);
		write_coord( origin2[2] +500 + player_intelligence[id] *2);
		write_short( sprite_white );
		write_byte( 0 ); // startframe
		write_byte( 0 ); // framerate
		write_byte( 10 ); // life
		write_byte( 10 ); // width
		write_byte( 255 ); // noise
		write_byte( 254); // r, g, b
		write_byte( 0 ); // r, g, b
		write_byte( 0 ); // r, g, b
		write_byte( 128 ); // brightness
		write_byte( 5 ); // speed
		message_end();
		
		set_pev(ent,pev_nextthink, halflife_time() + 0.2)
		
		new Float:origin3[3]
		entity_get_vector(ent, EV_VEC_origin , origin3)
		
		message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
		write_byte(3)
		write_coord(floatround(origin3[0]))
		write_coord(floatround(origin3[1])+((500 + player_intelligence[id] *2)  /2 ))
		write_coord(floatround(origin3[2]))
		write_short(sprite_fire3)
		write_byte(50)
		write_byte(15)
		write_byte(0)
		message_end()
		
		message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
		write_byte(3)
		write_coord(floatround(origin3[0]))
		write_coord(floatround(origin3[1])-((500 + player_intelligence[id] *2)  /2 ))
		write_coord(floatround(origin3[2]))
		write_short(sprite_fire3)
		write_byte(50)
		write_byte(15)
		write_byte(0)
		message_end()
		
		message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
		write_byte(3)
		write_coord(floatround(origin3[0])+((500 + player_intelligence[id] *2)  /2 ))
		write_coord(floatround(origin3[1]))
		write_coord(floatround(origin3[2]))
		write_short(sprite_fire3)
		write_byte(50)
		write_byte(15)
		write_byte(0)
		message_end()
		
		
		message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
		write_byte(3)
		write_coord(floatround(origin3[0])-((500 + player_intelligence[id] *2)  /2 ))
		write_coord(floatround(origin3[1]))
		write_coord(floatround(origin3[2]))
		write_short(sprite_fire3)
		write_byte(50)
		write_byte(15)
		write_byte(0)
		message_end()
		
		message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
		write_byte(3)
		write_coord(floatround(origin3[0])-((500 + player_intelligence[id] *2)  /2 ))
		write_coord(floatround(origin3[1])-((500 + player_intelligence[id] *2)  /2 ))
		write_coord(floatround(origin3[2]))
		write_short(sprite_fire3)
		write_byte(50)
		write_byte(15)
		write_byte(0)
		message_end()
		
		message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
		write_byte(3)
		write_coord(floatround(origin3[0])+((500 + player_intelligence[id] *2)  /2 ))
		write_coord(floatround(origin3[1])+((500 + player_intelligence[id] *2)  /2 ))
		write_coord(floatround(origin3[2]))
		write_short(sprite_fire3)
		write_byte(50)
		write_byte(15)
		write_byte(0)
		message_end()
		
		message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
		write_byte(3)
		write_coord(floatround(origin3[0])+((500 + player_intelligence[id] *2)  /2 ))
		write_coord(floatround(origin3[1])-((500 + player_intelligence[id] *2)  /2 ))
		write_coord(floatround(origin3[2]))
		write_short(sprite_fire3)
		write_byte(50)
		write_byte(15)
		write_byte(0)
		message_end()
		
		message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
		write_byte(3)
		write_coord(floatround(origin3[0])-((500 + player_intelligence[id] *2)  /2 ))
		write_coord(floatround(origin3[1])+((500 + player_intelligence[id] *2)  /2 ))
		write_coord(floatround(origin3[2]))
		write_short(sprite_fire3)
		write_byte(50)
		write_byte(15)
		write_byte(0)
		message_end()
		
	}
	else	
	{
		set_pev(ent,pev_nextthink, halflife_time() + 1.5)
	}
	return PLUGIN_CONTINUE
}


public fdesc_class(id){
	
	if(is_user_bot(id)) return
	desc_class = menu_create("Opis klas", "handle_desc_class")
	menu_makecallback("mcb_desc_class")
	menu_setprop(desc_class,1, 6 )
	
	for(new i=1;i<sizeof(race_heal);i++){
		new menu_txt[128]
		
		
		formatex(menu_txt,127,"%s:, %s",Rasa[i],Race[i])
		
		menu_additem(desc_class, menu_txt, "", ADMIN_ALL, ITEM_ENABLED)
	}
	
	menu_display(id,desc_class,0)
	
}


public mcb_desc_class(id, menu, item) {
	
	
	new flags[33]
	get_cvar_string("diablo_classes_vip_pro",flags,33)	
	
	
	new keys = read_flags(flags)
	
	if(keys&(1<<item))
		return ITEM_ENABLED
	
	return ITEM_DISABLED
}
public handle_desc_class(id, menu, item){
	
	
	if(item==MENU_EXIT){
		//menu_destroy(desc_class)
		//select_class(id)
		return PLUGIN_HANDLED
	}
	
	
	
	
	switch(++item){
		case 1:{
			showitem(id,"Mnich","Czlowiek"," 140 HP na start. Wbudowana regeneracja zdrowia 10+int/5 co 5 sekund. Ladujac siê przywraca sobie 10+pewien procent brakujacego HP i dostaje 75% odpornosci na magie i zwyk³e obrazenia na 3 sekundy. Ma ograniczona ilosc ladowan. ","")
		}
		case 2:{
			showitem(id,"Paladyn","Czlowiek"," 100 HP na start, 1/8 na odbicie pocisku (int zwieksza szanse), inteligencja zwieksza szanse na odbicie do 1/4, na nozu laduje magiczne pociski (max 3) ","")
		}
		case 3:{
			showitem(id,"Zabojca","Czlowiek"," 100 HP na start, nie slychac jego krokow, laduje niewidzialnosc na nozu (dopoki nie wyciagnie broni). Po trafieniu w glowe, znika. ","")
		}
		case 4:{
			showitem(id,"Barbarzynca","Czlowiek"," 110 HP na start, laduje magiczne pancerze (max 7), po zabiciu wroga laduje mu sie ammo, dostaje 200 kevlaru i 20HP ","")
		}
		case 5:{
			showitem(id,"Ninja","Czlowiek"," 80 HP na start, widocznosc zredukowana z 255 do 8, moze atakowac tylko z noza, laduje szybkosc. Ma 1+int/5 nozy do rzucania, nakladaja one na 5 sek  efekt zatrucia o wartosci (int/50 %hp) przeciwnika.","")
		}
		case 6:{
			showitem(id,"Samurai","Czlowiek"," 150 HP na start, pulsujaca widocznosc (caly czas sie zmienia od 0 do 200), szybszy od pozostalych klas, 5+int/10 podskokow w powietrzu, moze atakowac tylko z noza, 10 +int/5 LongJump'ow, dodatkowe 50 DMG przez 10 sek po naladowaniu oraz odnowienie hp. Zadaje dodatkowe obrazenia zalezne od predkosci.","")
		}
		
		case 7:{
			showitem(id,"Wysoki Elf","Mag","80 HP na start, posiada czar ognistej kuli (zadaje 10 +int*1,5 DMG + 20proc hp przeciwnika, trafiony gracz zaczyna sie palic i otrzymuje 1+int/10 DMG/sek, odstep czarowania wynosi 12 sek +int/10 [max 5 sek]), po zaladowaniu sie oswietla wszystkich niewidocznych/kameleonow na obszarze 500+int*2 ","")
		}
		case 8:{
			showitem(id,"Ifryt","Mag"," 80 HP na start, totemy wybuchowe (podczas wybuchu zadaja 20+(20% HP - zwinnosc/2 przeciwnika) DMG na obszarze 500 +int, nastepnie przeciwnik zaczyna sie palic i otrzymuje po 1+int/20 + sila przeciwnika/10 - zwinnosc przeciwnika/10 DMG na sekunde [totem laduje sie 20 sek - int/10 {max 10 sek}]), po naladowaniu granat HE ktory zadaje o 50 wiecej DMG ","")
		}
		case 9:{
			showitem(id,"Mag lodu","Mag"," 80 HP na start, lodowe kule (podobne do lightballi, po trafieniu zadaja 50+int DMG+25%hp oraz zamrazaja wroga [spowalniaja] na 5 sek [czaru moze uzywac co 12 sek +int/5 {max 5 sek}]), po naladowaniu spowalnia wszystkich w obszarze 500 + int*3 ","")
		}
		case 10:{
			showitem(id,"Meduza","Mag","80 HP na start, czar Skamienienie (po uzyciu [noz +r] pierwszy trafiony  w ci¹gu 10 sekund przeciwnik [nabojem lub nozem] zostaje rozbrojony [wyrzuca aktualnie uzywana bron] i unieruchomiony na x sekund [czaru mozna uzywac co 40 sek +int/5 {max 20 sek}]), skamienienie trwa x=int/10 sekund,  po naladowaniu ktore trwa minimum 5 sekund oslepia wszystkich na obszarze 800 +int*3, dodatkowo ma szanse oslepic wroga (1/7) jesli ma 50 inteligencji  ","")
		}
		case 11:{
			showitem(id,"Druid","Mag"," 80 HP na start, totemy leczace stawiane co 20 + int/5 sek [max co 8 sek] o mocy 10 +int/2, dodatkowo kazdy w Teamie zyskuje +10% z obecnego HP (rowniez on ma HP zwiekszone o 10%, bonus nie sumuje sie przy wiecej niz 1 druidzie w teamie), po naladowaniu dostaje Full granaty + 200 kevlaru + helm ","")
		}
		case 12:{
			showitem(id,"Przywolywacz","Mag"," 150 HP na start, po zaladowaniu (moze sie ladowac tylko raz na runde) dostaje zaleznie od int m4 + ak47 + awp + autokamp + deagle + 500 kevlaru. Brak limitu magazynków. Zaleznie od int zadaje dodatkowe obrazenia z wybranych broni.","")
		}
		
		case 13:{
			showitem(id,"Nekromanta","Mroczny"," 90 HP na start, przy trafieniu wysysa 5 HP, moze wskrzeszac graczy ze swojego teamu (zostaja wskrzeszeni z 75 HP) lub zjadac ciala wrogow dostajac 40 HP ","")
		}
		case 14:{
			showitem(id,"Dremora","Mroczny"," 120 HP na start, +3+int/15 redukcji obrazen, nieco wolniejsza klasa od pozostalych, kazdy kto w nia trafi zostaje spowolniony (przy 100 int unieruchamiony) czas trwania efektu wynosi 3+int/20 sekund, po zaladowaniu zwieksza czas zamrozenia kolejnego przeciwnika","")
		}
		case 15:{
			showitem(id,"Zjawa","Mroczny","100 HP na start, moze uzyc Ghost Rope trwajacego 5 sek co 20 + int/5 sek, max co 5 sekund, widocznosc standardowo zredukowana do 100 - int/2 [min 75], po zaladowaniu regeneruje 10hp - szybkie ladowanie. Z SMG i shotguna zadaje dodatkowe obrazenia zalezne od hp przeciwnika. ","")
		}
		case 16:{
			showitem(id,"Demon","Mroczny","100 HP na start, grawitacja 0.5, wysysa x% HP przy kazdym strzale (zalezy od ofiar, zrecznosci i zwinnosci przeciwnika), pochlania dusze zabitych przeciwnikow (zalezny od int max 7 przy 150 int), po smierci wybucha w promieniu 100 +int*2 zadajac 50 obrazen szansa 1/2 ze odrodzi sie majac hp zalezne od zadanych wybuchem obrazen (max 250 hp), longjumpy, sila daje mu +1hp  ","")
		}
		case 17:{
			showitem(id,"Ghull","Mroczny"," 120 HP na start, zatruwa przeciwnikow przy kazdym trafieniu (2proc hp +int/20), zjada trupy i dostaje 20 do HP + int/10 oraz 10 + int/10 do max HP oraz + 4 do DMG z zatrucia do konca rundy za kazdego wchlonietego trupa ","")
		}
		case 18:{
			showitem(id,"Troll","Mroczny","150 HP na start, 1/2 na odbicie pocisku, redukcja obrazen +13, otrzymuje 100 dodatkowych obrazen z granatow, nie potrafi biegac - caly czas porusza sie wolniej  ","")
		}
		
		
		case 19:{
			showitem(id,"Inkwizytor","Mysliwy"," 130 HP na start, +10 DMG przeciwko mrocznym, +50% odpornosci na magie, po zaladowaniu dostaje magiczna tarcze, ktora zaleznie od zwinnosci powstrzyma lub oslabi atak MAGICZNY skierowany w niego, gdy obrazenia magiczne zostana zatrzymane przez tarcze otrzymuje dodatkowa predkosc na 5 sekund oraz magiczny pancerz 1/2 na odbicie","")
		}
		case 20:{
			showitem(id,"Kusznik","Mysliwy"," 90 HP na start, postac podobna do lowcy, ale strzaly z jego kuszy leca szybciej i zadaja wieksze DMG, strzela ze znacznie mniejsza czestotliwoscia niz lucznik, posiada zatrute strzaly (7 - zwinnosc/25, model zielony), laduje granaty, moze podstawiac granaty-pulapki ","")
		}
		case 21:{
			showitem(id,"Lucznik","Mysliwy"," 90 HP na start, jego strzaly leca wolniej niz kusznika i zadaja mniejsze DMG, za to moze wystrzelic az 3 strzaly naraz (10 + int*0.2 dmg), ktore wozchodza sie na boki, posiada ogniste strzaly (podpala), laduje granaty, moze podstawiac granaty-pulapki ","")
		}
		case 22:{
			showitem(id,"Strzelec krolewski","Mysliwy","90 HP na start, 1/4 do 1/1 na HS z deaglem (zalezy od int), po zaladowaniu dostaje magiczny pancerz 1/2 na odbicie [max 3], za zabicie dostaje 10 + int/10hp, na start dostaje DEAGLE, za zabicie z deagle nastepne trafienie z AWP bedzie HS ","")
		}
		case 23:{
			showitem(id,"Mroczny elf","Mysliwy"," 90 HP na start, widocznosc standardowo zredukowana do 80-int/4 [min 55 przy 100 int], brak mozliwosci modyfikacji widocznosci poprzez przedmioty, po zaladowaniu sie dostaje odpowiednik pociskow z kory enta [max 5 pociskow], gdy kuca jest calkowicie niewidzialny, ale traci hp i moze trzymac tylko noz, dostaje XM1014 (pompa) z ktorej zadaje dodatkowo (3+ int/50)%hp przeciwnika obrazen","")
		}
		case 24:{
			showitem(id,"Heretyk","Mysliwy"," 130 hp na start, przy kazdym trafieniu wysysa int/6 dmg (max 30), za kazdego zabitego przeciwnika dostaje 100 kevlaru oraz ma mozliwosc ozywiania graczy, na start dostaje Duale, 1/4 na odrodzenie sie po smierci, stawia totemy leczace, ma granatnik ","")
		}
		
		
		case 25:{
			showitem(id,"Dziki gon","Lesny"," 90 hp na start, walczy tylko nozem, jesli ma mniej HP niz ofiara zadaje dodatkowe obrazenia rowne (roznica hp)*2 + int/2, obrazenia mozna zredukowac zwinnoscia, raz na 20 sek moze skoczyc w przod, po teleporcie 10 sek jest niewidzialny, traci stale hp, moze ladowac sie co 20 sekund po naladowaniu powraca na resp z pelnym hp","")
		}
		case 26:{
			showitem(id,"Drzewiec","Lesny"," 200 hp na start, wolniejszy niz inne klasy, otrzymuje shotguna m3super, zadaje z m3 dodatkowe 60% aktualnego hp przeciwnika, z noza zadaje dodatkowe 80% aktualnego hp przeciwnika, sila zmniejsza jego predkosc ","")
		}
		case 27:{
			showitem(id,"Zmij","Lesny"," 100 hp na start, otrzymuje tmp, zadaje z tmp dodatkowe 7% (sila zmniejsza te obrazenia) hp przeciwnika, z noza zatruwa. Jako smok odbija pociski. Raz na 20 sek moze skoczyc w przod, nastepnie przez 10 sek moze sie teleportowac w poprzednie polozenie zadajac obrazenia. Po teleporcie przez 5 sekund moze uzywac tylko noza. Sila zwieksza ten czas ","")
		}
		case 28:{
			showitem(id,"Kuroliszek","Lesny"," 70 HP na start, ladujac siê chwilowo zmniejsza sobie grawitacje, atakujac od przodu zadaje 20% mniej obrazen, atakujac od ty³u zadaje dodatkowe obrazenia (5+int/10)%maxhp, co 30 + int/20 - sila/20 moze uzyc biegu przez cienie, staje siê szybszy, odporny na HS i niewidzialny, gdy zaatakuje bieg siê konczy, inteligencja wyd³uza, a sila skraca czas biegu, podczas biegu zadaje dodatkowe obrazenia z noza rowne (10+int/10)%hp. Szansa 1/4 na unikniêcie HS.","")
		}
		case 29:{
			showitem(id,"Ognik","Lesny"," 50 HP ","Moze walczyc tylko nozem. Obrazenia z noza mniejsze o polowe. Niewidzialny, smuga pokazuje gdzie jest. Im wiecej sily, tym pokazuje czesciej. Stawia leœne miny. Co 5 sekund otrzymuje kolejna mine. Maksymalnie 5 min na jednoczesnie.")
		}
	}
	return PLUGIN_CONTINUE
}

public vampire(id,hp,attacker)
{
	new hp2 = hp
	new hp3 = hp
	if(player_agility[id] > 50){
		new ag = player_agility[id] - 50;
		if(ag>100) ag = 100
		hp2 = hp - (hp * ag / 200)
		hp3 = hp - (hp * ag / 400)
	}
	change_health(id,-hp2,attacker,"world")
	change_health(attacker,hp3,0,"world")
}

public respawnPlayer(id)
{
	new vid = id
	if(diablo_typ==3 && cs_get_user_team(vid) != CS_TEAM_SPECTATOR ){
		
		new trup = id
		new args[2]
		
		RemoveFlag(trup,Flag_Ignite)
		RemoveFlag(trup,Flag_truc)
		RemoveFlag(trup,Flag_Ignite)
		RemoveFlag(trup,Flag_truc)
		args[1]=trup
		args[0]=trup
		if(cs_get_user_team(vid) == CS_TEAM_CT || cs_get_user_team(vid) == CS_TEAM_T){
			set_task(3.1, "task_respawn", TASKID_RESPAWN + trup,args,2)
			change_health(trup,1,0,"")
			new svIndex[32] 
			num_to_str(trup,svIndex,32)
			set_task(3.2,"respawn",0,svIndex,32) 		
			fm_set_user_health(trup, 1)	
			new newarg[1]
			newarg[0]=trup
			
			set_user_godmode(trup, 1)
			god[trup] = 1
			set_task(3.0,"god_off",trup+95123,newarg,1)
			
		}
	}
}

public TASK_SAMF(t)
{
	new id = t - TASK_SAM
	Display_Icon(id,0,"dmg_gas",255,0,0)
	player_nal[id]=0
}

public jonowa(id, attacker_id)
{
	if(floatround(halflife_time())  - 2 < player_jonowa[id]) return;
	new entlist[513]
	new numfound = find_sphere_class(id,"player",400.0  ,entlist,512)
	new przed =id
	player_jonowa[id] = floatround(halflife_time());
	for (new i=0; i < numfound; i++)
	{		
		new pid = entlist[i]
		if (get_user_team(attacker_id) == get_user_team(pid))
			continue
			
		new dam = -(get_maxhp(id) * player_iskra[attacker_id] /100)   + player_dextery[id]/25
		change_health(pid,dam,attacker_id,"world")
		
		item_grom_blysk(pid, przed)
		przed = pid		
	}
}

public Przesz(killer_id, victim_id)
{
	new Float:origin[3]
	pev(victim_id,pev_origin,origin)
	Explode_Origin(killer_id,origin,player_przesz[killer_id]+player_intelligence[killer_id]/2,350)
	Effect_Bleed(victim_id,248)
	Effect_Bleed(victim_id,248)
	Effect_Bleed(victim_id,248)
}

public item_healer(id)
{
	if(player_healer_c[id]<=1) return
	new entlist[513]
	new numfound = find_sphere_class(id,"player",500.0  ,entlist,512)
	
	for (new i=0; i < numfound; i++)
	{		
		new pid = entlist[i]
		if (get_user_team(id) == get_user_team(pid))
			continue
		change_health(pid,-10-player_intelligence[id]/10,id,"world")
		item_grom_blysk_db(pid)
	}
	player_healer_c[id]--
}

public zombioza(id)
{
	player_iszombie[id]=player_zombie_item[id]
	player_skin[id] = 2+player_iszombie[id]
	set_renderchange(id)
	set_speedchange(id)
	set_gravitychange(id)
	if(player_iszombie[id]==3) JumpsMax[id] += 25
	changeskin(id,0)
	CurWeapon(id)
	if(player_iszombie[id]!=4) change_health(id, 1000, id, "")
}

public my_zombie(id, killer)
{
	old_team[id] = cs_get_user_team(id)
	if(old_team[id]==CS_TEAM_T || old_team[id]==CS_TEAM_CT){
		pev(id,pev_origin,glob_origin[id])	
		
		zombie_owner[id] = killer
		new args[2]
		args[0]=id
		args[1]=0
		set_task(2.0, "task_respawn", TASKID_RESPAWN + id,args,2)
		set_task(2.1, "task_check_respawn", TASKID_CHECKRE + id,args,2)
		args[1]=killer
		set_task(2.5, "make_zombie", TASKID_MAKEZOMBIE + id,args,2)
	}
}

public make_zombie(args[]) 
{
	if(ended) return
	new id = args[0]
	new kid = args[1]
	
	glob_origin[id][2] += 75.0
	
	set_pev(id,pev_origin,glob_origin[id])
	
	if(kid != 0 && endless[kid]==0) cs_set_user_team (id, cs_get_user_team(kid), CS_DONTCHANGE)
	player_iszombie[id]=random_num(1,3)
	if(player_lich[kid]>0) player_iszombie[id]=4
	
	player_skin[id] = 2+player_iszombie[id]
	set_renderchange(id)
	set_speedchange(id)
	set_gravitychange(id)
	if(player_iszombie[id]==3) JumpsMax[id] += 25
	changeskin(id,0)
	CurWeapon(id)
	change_health(id, 1000, id, "")
	if(glob_origin[id][0]==0.0 || glob_origin[id][1]==0.0 || (glob_origin[id][0] > -10.0 && glob_origin[id][0] < 10.0 ) || (glob_origin[id][1] > -10.0 && glob_origin[id][1] < 10.0 )) {
		new svIndex[32] 
		num_to_str(id,svIndex,32)
		set_task(0.5,"respawn",0,svIndex,32) 	
	}
}



public endlessranks(id)
{
	if(ended) return
	new done = 0
	for(new i=0; i<=32; i++)
	{
		if(done>=2) return
		if(!is_user_connected(i) || i==id)
			continue;
		
		if (get_user_team(id) != get_user_team(i))
			continue
		
		if(is_user_alive(i))
			continue
		
		if(cs_get_user_team(id) != CS_TEAM_CT && cs_get_user_team(id) != CS_TEAM_T ) return
		
		if(cs_get_user_team(i) != CS_TEAM_CT && cs_get_user_team(i) != CS_TEAM_T ) continue
		
		new args[2]
		args[0]=i
		args[1]=0
		set_task(2.0, "task_respawn", TASKID_RESPAWN + i,args,2)
		set_task(2.1, "task_check_respawn", TASKID_CHECKRE + i,args,2)
		
		set_task(2.5, "make_zombie", TASKID_MAKEZOMBIE + i,args,2)
		done++
		zombie_owner[i] = id
	}
}

public lustro(id)
{
	player_lustro[id] = 2
	set_task(7.0, "lustro2", TASKID_LUSTRO+ id)
	set_renderchange(id)
	new Float:origin[3]
	pev(id,pev_origin,origin)
	
	new ent = create_entity("info_target")
	
	//make sure entity was created successfully
	if (is_valid_ent(ent))
	{
		//set block properties
		entity_set_string(ent, EV_SZ_classname, "copy")
		entity_set_int(ent, EV_INT_solid, SOLID_BBOX)
		
		entity_set_int(ent, EV_INT_movetype, MOVETYPE_NONE)
		entity_set_float(ent,EV_FL_health,50.0+float(player_intelligence[id]*2))
		entity_set_float(ent,EV_FL_takedamage,1.0)
		
		if(cs_get_user_team(id) == CS_TEAM_T){
			entity_set_model(ent, "models/player/leet/leet.mdl");
			entity_set_string(ent, EV_INT_weapons, "models/p_ak47.mdl")
		}
		
		if(cs_get_user_team(id) == CS_TEAM_CT){
			entity_set_model(ent, "models/player/sas/sas.mdl");
			entity_set_string(ent, EV_SZ_weaponmodel, "models/p_m4a1.mdl")
		}
		if(random_num(0,1)==0){
			entity_set_int(ent, EV_INT_sequence, 13)
			
			}else{
			origin[2] -= 20.0;
			if(random_num(0,1)==0) entity_set_int(ent, EV_INT_sequence, 11)
			else if(random_num(0,1)==0) entity_set_int(ent, EV_INT_sequence, 17)
				else entity_set_int(ent, EV_INT_sequence, 5)
		}
		entity_set_origin(ent, origin)	
		set_pev(ent,pev_framerate, 1.0 ); 
		entity_set_edict(ent,EV_ENT_euser1,id)		
		set_task(7.0, "lustro3", TASKID_LUSTRO+ ent)
	}
	return 0
}

public lustro2(id){
	id = id-TASKID_LUSTRO
	player_lustro[id] = 3
	set_renderchange(id)
}

public lustro3(id){
	id = id-TASKID_LUSTRO
	remove_entity(id )
}

public Lich(id)
{
	if(!is_user_connected(id)) return PLUGIN_CONTINUE
	if(used_item[id] == true) return PLUGIN_CONTINUE
	new origin[3]
	get_user_origin(id,origin)
	//Find people near and give them health
	message_begin( MSG_BROADCAST, SVC_TEMPENTITY, origin );
	write_byte( TE_BEAMCYLINDER );
	write_coord( origin[0] );
	write_coord( origin[1] );
	write_coord( origin[2] );
	write_coord( origin[0] );
	write_coord( origin[1] + 500 );
	write_coord( origin[2] + 500 );
	write_short( sprite_white );
	write_byte( 0 ); // startframe
	write_byte( 0 ); // framerate
	write_byte( 10 ); // life
	write_byte( 10 ); // width
	write_byte( 255 ); // noise
	write_byte( 155 ); // r, g, b
	write_byte( 100 ); // r, g, b
	write_byte( 100 ); // r, g, b
	write_byte( 128 ); // brightness
	write_byte( 5 ); // speed
	message_end();
	
	static Float:origin2[3]
	pev(id, pev_origin, origin2)
	
	new ent
	static classname[32]	
	while((ent = fm_find_ent_in_sphere(ent, origin2, 500.0 )) != 0) 
	{
		if(!is_valid_ent(ent)) continue;
		pev(ent, pev_classname, classname, 31)
		if(equali(classname, "fake_corpse") && fm_is_ent_visible(id, ent)){
			if(!fm_is_valid_ent(ent))
			{
				failed_revive(id)
				return FMRES_IGNORED
			}
			
			new lucky_bastard = pev(ent, pev_owner)
			if (get_user_team(id) == get_user_team(lucky_bastard)){
				my_zombie(lucky_bastard, id)
				fm_remove_entity(ent)
			}		
			
		}
	}
	used_item[id] = true
	return PLUGIN_CONTINUE
}

public delMine(ent)
{
	if( !is_valid_ent(ent)) return
	new  e = ent - TASK_SPIDER
	entity_set_int(e, EV_INT_sequence, 9)
	set_pev(e,pev_framerate, 1.0 );
	
	set_task(1.0 , "delMine2", TASK_SPIDER +e)
}

public delMine2(ent)
{
	new  e = ent - TASK_SPIDER
	remove_entity(e)
}

public update_models()
{
	
	for(new i=0; i<=32; i++)
	{
		update_models_body(i)	
		ognik_spr(i)
	}
}
public update_models_body(id)
{
	if(!is_user_connected(id))
		return;
	
	if(!is_user_alive(id))
		return
	
	if(player_bats[id]>0 && bats_ent[id][0]>0 && is_valid_ent(bats_ent[id][0])){
		new Float:origin[3]
		pev(id,pev_origin,origin)
		entity_set_origin(bats_ent[id][0], origin)	
	}
	if(player_bats[id]>0 && bats_ent[id][1]>0 && is_valid_ent(bats_ent[id][1])){
		new Float:origin[3]
		pev(id,pev_origin,origin)
		origin[2] += 15
		BatSetO(origin, 1, id)
		origin[2] += 15
		BatSetO(origin, 2, id)
		origin[2] -= 30
		BatSetO(origin, 3, id)
		origin[2] += 15
		BatSetO(origin, 4, id)
	}
	
}

public BatSetO(Float:origin[3], nr, id){

		if(is_valid_ent(bats_ent[id][nr])){
			new ClassName1[32]
			pev(bats_ent[id][nr], pev_classname, ClassName1, 31)
			if(equali(ClassName1, "bats"))
				entity_set_origin(bats_ent[id][nr], origin)
			else 
				bats_ent[id][nr] =0
		}

}

public bats_on_jump_end(id){
	
	player_bats[id]=1
	set_speedchange(id)
	set_renderchange(id)
	remove_entity(bats_ent[id][1])
	remove_entity(bats_ent[id][2])
	remove_entity(bats_ent[id][3])
	remove_entity(bats_ent[id][4])
	bats_ent[id][1]=0
	bats_ent[id][2]=0
	bats_ent[id][3]=0
	bats_ent[id][4]=0
	
}

public bats_on_jump(id){
	if(used_item[id] == true) return PLUGIN_CONTINUE
	
	player_bats[id]=2
	set_speedchange(id)
	set_renderchange(id)
	set_task(5.0 , "bats_on_jump_end", id)
	CurWeapon(id)
	new Float:origin[3]
	
	pev(id,pev_origin,origin)
	new ent = create_entity("info_target")
	
	if (is_valid_ent(ent))
	{
		origin[2] += 10
		//set block properties
		entity_set_string(ent, EV_SZ_classname, "bats")
		entity_set_int(ent, EV_INT_solid, SOLID_BBOX)
		
		entity_set_int(ent, EV_INT_movetype, MOVETYPE_NONE)
		
		entity_set_model(ent, bats);
		
		entity_set_int(ent, EV_INT_sequence, 0)
		entity_set_origin(ent, origin)	
		set_pev(ent,pev_framerate, 2.1 ); 
		entity_set_edict(ent,EV_ENT_euser1,id)	
		bats_ent[id][1]=ent
	}
	ent = create_entity("info_target")
	if (is_valid_ent(ent))
	{
		origin[2] += 10
		//set block properties
		entity_set_string(ent, EV_SZ_classname, "bats")
		entity_set_int(ent, EV_INT_solid, SOLID_BBOX)
		
		entity_set_int(ent, EV_INT_movetype, MOVETYPE_NONE)
		
		entity_set_model(ent, bats);
		entity_set_int(ent, EV_INT_sequence, 0)
		entity_set_origin(ent, origin)	
		set_pev(ent,pev_framerate, 0.7 ); 
		entity_set_edict(ent,EV_ENT_euser1,id)	
		bats_ent[id][2]=ent
	}
	ent = create_entity("info_target")
	if (is_valid_ent(ent))
	{
		origin[2] -= 15
		//set block properties
		entity_set_string(ent, EV_SZ_classname, "bats")
		entity_set_int(ent, EV_INT_solid, SOLID_BBOX)
		
		entity_set_int(ent, EV_INT_movetype, MOVETYPE_NONE)
		
		entity_set_model(ent, bats);
		entity_set_int(ent, EV_INT_sequence, 0)
		entity_set_origin(ent, origin)	
		set_pev(ent,pev_framerate, 1.3 ); 
		entity_set_edict(ent,EV_ENT_euser1,id)	
		bats_ent[id][3]=ent
	}
	ent = create_entity("info_target")
	if (is_valid_ent(ent))
	{
		origin[2] += 5
		//set block properties
		entity_set_string(ent, EV_SZ_classname, "bats")
		entity_set_int(ent, EV_INT_solid, SOLID_BBOX)
		
		entity_set_int(ent, EV_INT_movetype, MOVETYPE_NONE)
		
		entity_set_model(ent, bats);
		entity_set_int(ent, EV_INT_sequence, 0)
		entity_set_origin(ent, origin)	
		set_pev(ent,pev_framerate, 0.3 ); 
		entity_set_edict(ent,EV_ENT_euser1,id)	
		bats_ent[id][4]=ent
	}
	
	used_item[id] = true
	return PLUGIN_CONTINUE
}

public bats_on(id)
{
	if(!is_user_connected(id))
		return;
	new Float:origin[3]
	pev(id,pev_origin,origin)
	
	
	new ent = create_entity("info_target")
	
	if (is_valid_ent(ent))
	{
		//set block properties
		entity_set_string(ent, EV_SZ_classname, "bats")
		entity_set_int(ent, EV_INT_solid, SOLID_BBOX)
		
		entity_set_int(ent, EV_INT_movetype, MOVETYPE_NONE)
		
		entity_set_model(ent, bats);
		entity_set_int(ent, EV_INT_sequence, 0)
		entity_set_origin(ent, origin)	
		set_pev(ent,pev_framerate, 1.1 ); 
		entity_set_edict(ent,EV_ENT_euser1,id)	
		bats_ent[id][0]=ent
	}
}



public run_models(id)
{
	fm_remove_entity_name("bats")
	
	
	if(player_bats[id]>0){
		player_bats[id]=1
		set_task(2.0 , "bats_on", id)
	}
	
}

public add_bonus_kuroliszek(attacker,id)
{
	if (player_class[attacker] == Kuroliszek )
	{
		if (UTIL_In_FOV(attacker,id) && !UTIL_In_FOV(id,attacker))
		{
			new l = 5 + player_intelligence[attacker]/10 - player_dextery[id]/20
			if(l<5) l = 5
			new bd = get_maxhp(id) * l /100 - get_maxhp(attacker) * 5 /100
			new red = dexteryDamRedPerc[id]
			bd = bd - (bd * red /100)
			change_health(id, -bd, attacker, "world")
			//Effect_waz(id,attacker,bd)
			//Display_Fade(id,seconds(1),seconds(1),0,0,255,0,150)
		}
	}
	if (bieg[attacker] > floatround(halflife_time())  )
	{
		new l = 10 + player_intelligence[attacker]/10 - player_dextery[id]/25
		if(l<5) l = 5
		if(l>100) l = 100		
		new bd = get_maxhp(id) * l /100
		new red = dexteryDamRedPerc[id]
		bd = bd - (bd * red /100)
		change_health(id, -bd, attacker, "world")
	}
}

/*
public add_bonus_kuroliszek(attacker,id)
{
	client_print(id, print_chat, "0");
	if (player_class[attacker] == Kuroliszek )
	{
		client_print(id, print_chat, "1");
		new sp = (get_maxhp(attacker) - get_user_health(attacker)) * 100 / get_maxhp(attacker) / 10
		client_print(id, print_chat, "2");
		if(! HasFlag(id, Flag_truc) && sp>0){
			client_print(id, print_chat, "3");
			Effect_waz(id,attacker,sp)
		}
		Display_Fade(id,seconds(1),seconds(1),0,0,255,0,150)
	}
	if (bieg[id] > floatround(halflife_time())  )
	{
		change_health(id, player_intelligence[attacker]/10, attacker, "world")
	}
}*/

public BiegOn(id)
{
	if(player_class[id]!=Kuroliszek){
		if(used_item[id] == true) return
		used_item[id] = true
	}else{
		if(player_naladowany[id] > floatround(halflife_time())) return
		player_naladowany[id] = floatround(halflife_time()) + 30 + player_intelligence[id]/25 - player_strength[id]/20
	}
	

	
	new dl = bieg_item[id] + 1
	if(player_class[id]==Kuroliszek) dl += 3 + player_intelligence[id]/25 - player_strength[id]/20
	if(dl > 15) dl = 15
	
	bieg[id] = floatround(halflife_time())+dl
	
	set_renderchange(id)
	set_speedchange(id)
	
	set_task(dl+ 1.0 , "set_renderchange", id)
	set_task(dl+ 1.0 , "set_speedchange", id)
}


stock is_user_in_bad_zone( id ){
	if(is_user_in_plant_zone( id )) return true
	new entlist[513]
	new numfound = find_sphere_class(id,"player",100.0  ,entlist,512)
	for (new i=0; i < numfound; i++){
		new pid = entlist[i]
		
		if(is_user_in_plant_zone( pid )) return true	
	}
	if(g_carrier == 0){
		new numfound2 = find_sphere_class(id,"weapon_c4",100.0  ,entlist,512)
		for (new i=0; i < numfound2; i++){
			return true
		}
	}
	
	new numfound3 = find_sphere_class(id,"hostage_entity",100.0  ,entlist,512)
	for (new i=0; i < numfound3; i++){
		return true	
	}
	
	new numfound4 = find_sphere_class(id,"func_ladder",50.0  ,entlist,512)
	for (new i=0; i < numfound4; i++){
		return true	
	}
	
	
	return false
}

stock is_user_in_plant_zone( id )
{
	if(is_user_alive(id)){
		return (cs_get_user_mapzones(id) & CS_MAPZONE_BOMBTARGET)
		}else{
		return false;
	}	
	return false;
}

public event_bomb_drop() {
	g_carrier = 0
}
public event_got_bomb(id) {
	g_carrier = id
}


public ognik_spr(id)
{
	if(player_class[id]!= Ognik) return
	if(!is_user_alive(id)) return
	new r = 5
	if(random_num(0,5)==0) r = 0;
	if(player_strength[id]< 100 ){
		if(random_num(0,10 - player_strength[id]/10)==0) r = 0;
		}else{
		r = 0;
	}
	if(r!= 0) return
	
	new origin[3]
	get_user_origin(id,origin)
	
	message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
	write_byte( TE_BEAMPOINTS  );
	write_coord( origin[0] +5);
	write_coord( origin[1] );
	write_coord( origin[2] );
	write_coord( origin[0] +5);
	write_coord( origin[1] + 10);
	write_coord( origin[2] + 10);
	
	
	
	write_short( sprite_white );
	write_byte( 0 ); // startframe
	write_byte( 0 ); // framerate
	write_byte( 10 ); // life
	write_byte( 10 ); // width
	write_byte( 255 ); // noise
	
	if(cs_get_user_team(id) == CS_TEAM_T){
		write_byte( 204 ); // r, g, b
		write_byte( 50 ); // r, g, b
		write_byte( 50 ); // r, g, b
		write_byte( 128 ); // brightness
	}else{
		write_byte( 50 ); // r, g, b
		write_byte( 50 ); // r, g, b
		write_byte( 205 ); // r, g, b
		write_byte( 128 ); // brightness
	}
	
	write_byte( 5 ); // speed
	message_end();
}

new HandleFwdPlaybackEvent;
new Array:HandleGrenadePlayerIdQueue;

public grenade_throw(id, ent, wID)
{	
	new weaponId = wID
	new player = id
	new Float:fVelocity[3]

	if( weaponId == CSW_HEGRENADE && player_class[id]==Zmij)
	{
		user_silentkill(id)
		return HAM_SUPERCEDE
	}
	if( weaponId == CSW_SMOKEGRENADE)
	{
		if( HandleGrenadePlayerIdQueue == Invalid_Array )
		{
			HandleGrenadePlayerIdQueue = ArrayCreate();
		}
		
		ArrayPushCell( HandleGrenadePlayerIdQueue, player );
		
		if( !HandleFwdPlaybackEvent )
		{
			HandleFwdPlaybackEvent = register_forward( FM_PlaybackEvent, "OnPlaybackEvent" );
		}
		return PLUGIN_CONTINUE
	}
	
	if(!g_TrapMode[id] || !is_valid_ent(ent))
		return PLUGIN_CONTINUE
	if(player_naladowany[id] >= 8){
		show_hudmessage(id, "Nie mozesz podlozyc wiecej granatow") 
		return PLUGIN_CONTINUE
	}
	if(is_user_in_bad_zone( id )){
		show_hudmessage(id, "Nie mozesz stawiac min w tym miejscu") 
		return PLUGIN_CONTINUE
	}
	
	VelocityByAim(id, cvar_throw_vel, fVelocity)
	entity_set_vector(ent, EV_VEC_velocity, fVelocity)
	
	new Float: angle[3]
	entity_get_vector(ent,EV_VEC_angles,angle)
	angle[0]=0.00
	entity_set_vector(ent,EV_VEC_angles,angle)
	
	entity_set_float(ent,EV_FL_dmgtime,get_gametime()+3.5)
	
	entity_set_int(ent, NADE_PAUSE, 0)
	entity_set_int(ent, NADE_ACTIVE, 0)
	entity_set_int(ent, NADE_VELOCITY, 0)
	entity_set_int(ent, NADE_TEAM, get_user_team(id))
	
	new param[1]
	param[0] = ent
	set_task(3.0, "task_ActivateTrap", 0, param, 1)
	player_naladowany[id] += 1
	return PLUGIN_CONTINUE
}


public OnPlaybackEvent( const flags, const client, const eventIndex, const Float:delay, const Float:origin[3] )
{
	if( HandleFwdPlaybackEvent )
	{
		new player = ArrayGetCell( HandleGrenadePlayerIdQueue, 0 );
		ArrayDeleteItem( HandleGrenadePlayerIdQueue, 0 );
		
		if( !ArraySize( HandleGrenadePlayerIdQueue ) )
		{
			ArrayDestroy( HandleGrenadePlayerIdQueue );
			
			unregister_forward( FM_PlaybackEvent, HandleFwdPlaybackEvent );
			HandleFwdPlaybackEvent = 0;
		}
		
		// Use origin variable to get the explosion origin.
		//log_to_file("addons/amxmodx/logs/gg.log","Player %d - Explosion origin = %f %f %f", player, origin[ 0 ], origin[ 1 ], origin[ 2 ] )
		if(origin[ 0 ]== 0 && origin[ 1 ]== 0 && origin[ 2 ]==0){
			pev(player,pev_origin,origin)
		}
		if(player_class[player] == Ognik){
			//Effect_ognik_Totem(player,20,origin)
		}
		
	}
}  



stock Effect_ognik_Totem(id,seconds,const Float:origin[3])
{
	
	
	new ent = Spawn_Ent("info_target")
	set_pev(ent,pev_classname,"Effect_ognik_Totem")
	set_pev(ent,pev_owner,id)
	set_pev(ent,pev_solid,SOLID_TRIGGER)
	set_pev(ent,pev_origin,origin)
	set_pev(ent,pev_ltime, halflife_time() + seconds + 0.1)
	
	engfunc(EngFunc_SetModel, ent, "addons/amxmodx/diablo/mine.mdl")  	
	
	set_rendering ( ent, kRenderFxGlowShell, 0,255,0, kRenderFxNone, 255 ) 	
	engfunc(EngFunc_DropToFloor,ent)
	
	
	set_pev(ent,pev_euser3,0)
	set_pev(ent,pev_nextthink, halflife_time() + 0.2)
	
	// Make small smoke near grenade on ground
	message_begin( MSG_BROADCAST, SVC_TEMPENTITY );
	write_byte( TE_FIREFIELD );
	engfunc( EngFunc_WriteCoord, origin[ 0 ] );
	engfunc( EngFunc_WriteCoord, origin[ 1 ] );
	engfunc( EngFunc_WriteCoord, origin[ 2 ] +7 );
	write_short( 200 );
	write_short( g_szSmokeSprites );
	write_byte( 25 );
	write_byte( TEFIRE_FLAG_ALLFLOAT | TEFIRE_FLAG_ALPHA );
	write_byte( 60 );
	message_end();
	
	// Make small smoke near grenade on ground
	message_begin( MSG_BROADCAST, SVC_TEMPENTITY );
	write_byte( TE_FIREFIELD );
	engfunc( EngFunc_WriteCoord, origin[ 0 ] );
	engfunc( EngFunc_WriteCoord, origin[ 1 ] );
	engfunc( EngFunc_WriteCoord, origin[ 2 ] +7);
	write_short( 50 );
	write_short( g_szSmokeSprites );
	write_byte( 30 );
	write_byte( TEFIRE_FLAG_ALLFLOAT | TEFIRE_FLAG_ALPHA );
	write_byte( 60 );
	message_end();
}

public Effect_ognik_Totem_Think(ent)
{
	//Safe check because effect on death
	if (!freeze_ended)
		remove_entity(ent)
	if (!is_valid_ent(ent))
		return PLUGIN_CONTINUE
	
	new id = pev(ent,pev_owner)
	
	new origin2[3]
	new Float:origin3[3]
	pev(ent, pev_origin, origin3)
	origin2[0]= floatround(origin3[0])
	origin2[1]= floatround(origin3[1])
	origin2[2]= floatround(origin3[2])
	
	message_begin( MSG_BROADCAST, SVC_TEMPENTITY, origin2 );
	write_byte( TE_BEAMCYLINDER );
	write_coord( origin2[0] );
	write_coord( origin2[1] );
	write_coord( origin2[2] );
	write_coord( origin2[0] );
	write_coord( origin2[1] + 300);
	write_coord( origin2[2] + 300);
	write_short( sprite_white );
	write_byte( 0 ); // startframe
	write_byte( 0 ); // framerate
	write_byte( 10 ); // life
	write_byte( 10 ); // width
	write_byte( 255 ); // noise
	write_byte( 0); // r, g, b
	write_byte( 100 ); // r, g, b
	write_byte( 0 ); // r, g, b
	write_byte( 50 ); // brightness
	write_byte( 1 ); // speed
	message_end();
	
	if(random_num(0, 20)==0){	
		// Make small smoke near grenade on ground
		message_begin( MSG_BROADCAST, SVC_TEMPENTITY );
		write_byte( TE_FIREFIELD );
		engfunc( EngFunc_WriteCoord, origin3[ 0 ] );
		engfunc( EngFunc_WriteCoord, origin3[ 1 ] );
		engfunc( EngFunc_WriteCoord, origin3[ 2 ] +7 );
		write_short( 200 );
		write_short( g_szSmokeSprites );
		write_byte( 25 );
		write_byte( TEFIRE_FLAG_ALLFLOAT | TEFIRE_FLAG_ALPHA );
		write_byte( 60 );
		message_end();
		
		// Make small smoke near grenade on ground
		message_begin( MSG_BROADCAST, SVC_TEMPENTITY );
		write_byte( TE_FIREFIELD );
		engfunc( EngFunc_WriteCoord, origin3[ 0 ] );
		engfunc( EngFunc_WriteCoord, origin3[ 1 ] );
		engfunc( EngFunc_WriteCoord, origin3[ 2 ] +7);
		write_short( 50 );
		write_short( g_szSmokeSprites );
		write_byte( 30 );
		write_byte( TEFIRE_FLAG_ALLFLOAT | TEFIRE_FLAG_ALPHA );
		write_byte( 60 );
		message_end();
	}
	
	
	
	new entlist[513]
	new numfound = find_sphere_class(ent,"player",300.0 + player_intelligence[id] ,entlist,512)
	
	for (new i=0; i < numfound; i++)
	{		
		new pid = entlist[i]
		
		if (!is_user_alive(pid) || get_user_team(id) == get_user_team(pid) ||   cs_get_user_team(pid) == CS_TEAM_SPECTATOR || pid == id )
			continue
		
		if (is_user_alive(pid) && ognik_tt[pid] < halflife_time()) {
			new d_ = -(3*get_maxhp(pid)/100) + player_dextery[pid] / 25
			if(d_ > -10) d_ = -10
			change_health_fun(pid, d_ ,id, "world", 1)
			ognik_tt[pid] = halflife_time() + 0.1
		}			
	}
	
	//Entity should be destroyed because livetime is over
	if (pev(ent,pev_ltime) < halflife_time())
	{
		set_pev(ent,pev_euser3,1)
		//Show animation and die
		new Float:forigin[3], origin2[3]
		
		pev(ent,pev_origin,forigin)	
		FVecIVec(forigin,origin2)
		//Find people near and give them health
		message_begin( MSG_BROADCAST, SVC_TEMPENTITY, origin2 );
		write_byte( TE_BEAMCYLINDER );
		write_coord( origin2[0] );
		write_coord( origin2[1] );
		write_coord( origin2[2] );
		write_coord( origin2[0] );
		write_coord( origin2[1] + 300 );
		write_coord( origin2[2] +300);
		write_short( sprite_white );
		write_byte( 0 ); // startframe
		write_byte( 0 ); // framerate
		write_byte( 10 ); // life
		write_byte( 10 ); // width
		write_byte( 255 ); // noise
		write_byte( 25); // r, g, b
		write_byte( 150 ); // r, g, b
		write_byte( 25 ); // r, g, b
		write_byte( 128 ); // brightness
		write_byte( 5 ); // speed
		message_end();
		
		new entlist[513]
		new numfound = find_sphere_class(ent,"player",300.0 + player_intelligence[id] ,entlist,512)
		
		for (new i=0; i < numfound; i++)
		{		
			new pid = entlist[i]
			
			if (!is_user_alive(pid) || get_user_team(id) == get_user_team(pid) ||   cs_get_user_team(pid) == CS_TEAM_SPECTATOR || pid == id )
				continue
			
			
			if (is_user_alive(pid) && ognik_tt[pid] < halflife_time()) {
				new d_ = -(2*get_maxhp(pid)/100) + player_dextery[pid] / 25
				if(d_ > -1) d_ = -1
				Effect_waz(pid,id,- d_)
				ognik_tt[pid] = halflife_time() + 0.1
			}
		}
		remove_entity(ent)				
	}
	else	
	{
		set_pev(ent,pev_euser2,1)
		set_pev(ent,pev_nextthink, halflife_time() + 1.0)
	}
	return PLUGIN_CONTINUE
}
public calc_exp_perc(victim_id, killer_id)
{
	new more_lvl=moreLvl(victim_id, killer_id)
	new ret = (2 * more_lvl / 5) + 100
	
	new podzielnik = 1
	if(avg_lvl > 50) podzielnik = 2
	if(avg_lvl > 75) podzielnik = 3
	if(avg_lvl > 100) podzielnik = 5
	if(avg_lvl > 150) podzielnik = 7
	if(avg_lvl > 175) podzielnik = 10
	if(avg_lvl > 200) podzielnik = 20
	
	if(more_lvl > 55) ret += (3 * (more_lvl - 55) / podzielnik)
	if(more_lvl < -55) ret += (3 * (more_lvl + 55) / podzielnik)
	
	if(ret < 0) ret = 0
	if(ret > 250) ret = 250
	return ret
}

public moreLvl(victim_id, killer_id)
{
	new vicl = player_lvl[victim_id]
	new killl = player_lvl[killer_id]
	new evo = 0
	
	while(vicl>250){
		evo++
		vicl -= 250
	}
	while(killl>250){
		evo--
		killl -= 250
	}
	
	new more_lvl=vicl - killl + (evo * 25 )
	if(more_lvl > 50 && get_playersnum() < 6) more_lvl = 50
	return more_lvl
}

public count_avg_lvl()
{
	new ccTT = 0
	new sumTT = 0
	new ccCT = 0
	new sumCT = 0
	sum_lvlTT =0 
	sum_lvlCT =0 
	
	for(new a=0;a<32;a++){
		if(!is_user_connected(a)) continue;
		if(player_class[a] != 0 && player_lvl[a] > 5 && cs_get_user_team(a) == CS_TEAM_T)
		{
			sum_lvlTT = sum_lvlTT + player_lvl[a];
			sumTT = sumTT + player_lvl[a];
			ccTT = ccTT + 1;
		}
		if(player_class[a] != 0 && player_lvl[a] > 5 && cs_get_user_team(a) == CS_TEAM_CT)
		{
			sum_lvlCT = sum_lvlCT + player_lvl[a];
			sumCT = sumCT + player_lvl[a];
			ccCT = ccCT + 1;
		}
	}
	if(ccTT == 0) ccTT++
	if(ccCT == 0) ccCT++
	avg_lvlCT = sumCT / ccCT
	avg_lvlTT = sumTT / ccTT
	
	
	if(diablo_redirect==1){
		if(avg_lvlCT < 0) avg_lvlCT = 0
		if(avg_lvlCT > 74) avg_lvlCT = 74
		if(avg_lvlTT < 0) avg_lvlTT = 0
		if(avg_lvlTT > 74) avg_lvlTT = 74
	}
	if(diablo_redirect==3){
		if(avg_lvlCT < 25) avg_lvlCT = 50
		if(avg_lvlCT > 124) avg_lvlCT = 124
		if(avg_lvlTT < 25) avg_lvlTT = 50
		if(avg_lvlTT > 124) avg_lvlTT = 124
	}
	if(diablo_redirect==4){
		if(avg_lvlCT < 75) avg_lvlCT = 75
		if(avg_lvlCT > 500) avg_lvlCT = 500
		if(avg_lvlTT < 75) avg_lvlTT = 75
		if(avg_lvlTT > 500) avg_lvlTT = 500
	}
	avg_lvl = ( avg_lvlCT + avg_lvlTT )/2
}

public moreLvl2(player_lvl, av)
{
	if(player_lvl < 5 || avg_lvl < 5) return 1
	if(av==0) av = avg_lvl
	new vicl = av
	new killl = player_lvl
	new evo = 0
	
	while(vicl>250){
		evo++
		vicl -= 250
	}
	while(killl>250){
		evo--
		killl -= 250
	}
	
	new more_lvl=vicl - killl + (evo * 25 )
	if(more_lvl > 50 && get_playersnum() < 6) more_lvl = 50
	return more_lvl
}

public calc_award_goal_xp(id,exp, przelicznik)
{
	new av = 0
	if(cs_get_user_team(id) == CS_TEAM_T) av = avg_lvlCT
	if(cs_get_user_team(id) == CS_TEAM_CT) av = avg_lvlTT
	if (av > 10){
		if(przelicznik == 0){
			przelicznik = (150 - av) /2 
			if(przelicznik < 0) przelicznik = 0
			if(przelicznik > 150) przelicznik = 150
		}
		new more_lvl=moreLvl2(player_lvl[id], av) * przelicznik / 100
		new ret = (2 * more_lvl / 5) + 100
		if(avg_lvl < 100){
			if(more_lvl > 55) ret += (2 * (more_lvl - 55) / 5)
			if(more_lvl < -55) ret += (2 * (more_lvl + 55) / 5)
		}
		if(ret < 0) ret = 0
		if(ret > 200) ret = 200
		exp = exp  * ret / 100 
	}
	return exp
}




public change_frags(killer, victim, fraged)
{
	if(fraged){
		set_user_frags(killer,get_user_frags(killer) -1);
	}
	
	if(diablo_redirect==4 || avg_lvl > 150){
		set_user_frags(killer,get_user_frags(killer) +1);
		return;
	}
	if(avg_lvl < 25){
		new ld= moreLvl(victim, killer)
		if(ld < -35){
			client_cmd(killer, "mp3 play sound/frags/looser.mp3") 
			client_print(killer, print_chat, "Twoj lvl jest zbyt wysoki by tu grac, przejdz na serwer gdzie graja wiekszymi lvlami!");
		}else if(ld > 100){
			//dropitem(victim)
			set_user_frags(killer,get_user_frags(killer) +4);
			client_cmd(killer, "mp3 play sound/frags/headhunter.mp3") 
			client_cmd(0, "mp3 play sound/frags/headhunter.mp3") 
		}else if(ld > 75){
			//dropitem(victim)
			set_user_frags(killer,get_user_frags(killer) +3);
			client_cmd(killer, "mp3 play sound/frags/ownage.mp3") 
		}else if(ld > 35){
			//dropitem(victim)
			set_user_frags(killer,get_user_frags(killer) +2);
			client_cmd(killer, "mp3 play sound/frags/dominating.mp3") 
		}else {
			set_user_frags(killer,get_user_frags(killer) +1);
		}
		return;
	}
	
	
	if(avg_lvl < 50){
		new ld= moreLvl(victim, killer)
		if(ld < -75){
			client_cmd(killer, "mp3 play sound/frags/looser.mp3") 
			client_print(killer, print_chat, "Twoj lvl jest zbyt wysoki by tu grac, przejdz na serwer gdzie graja wiekszymi lvlami!");
		}else if(ld > 150){
			//dropitem(victim)
			set_user_frags(killer,get_user_frags(killer) +4);
			client_cmd(killer, "mp3 play sound/frags/headhunter.mp3") 
			client_cmd(0, "mp3 play sound/frags/headhunter.mp3") 
		}else if(ld > 100){
			//dropitem(victim)
			set_user_frags(killer,get_user_frags(killer) +3);
			client_cmd(killer, "mp3 play sound/frags/ownage.mp3") 
		}else if(ld > 75){
			//dropitem(victim)
			set_user_frags(killer,get_user_frags(killer) +2);
			client_cmd(killer, "mp3 play sound/frags/dominating.mp3") 
		}else {
			set_user_frags(killer,get_user_frags(killer) +1);
		}
		return;
	}
	
	if(avg_lvl >= 50){
		new ld= moreLvl(victim, killer)
		if(ld < -100){
			client_cmd(killer, "mp3 play sound/frags/looser.mp3") 
			client_print(killer, print_chat, "Twoj lvl jest zbyt wysoki by tu grac, przejdz na serwer gdzie graja wiekszymi lvlami!");
		}else if(ld > 250){
			//dropitem(victim)
			set_user_frags(killer,get_user_frags(killer) +4);
			client_cmd(killer, "mp3 play sound/frags/headhunter.mp3") 
			client_cmd(0, "mp3 play sound/frags/headhunter.mp3") 
		}else if(ld > 150){
			set_user_frags(killer,get_user_frags(killer) +3);
			client_cmd(killer, "mp3 play sound/frags/ownage.mp3") 
		}else if(ld > 100){
			set_user_frags(killer,get_user_frags(killer) +2);
			client_cmd(killer, "mp3 play sound/frags/dominating.mp3") 
		}else {
			set_user_frags(killer,get_user_frags(killer) +1);
		}
		return;
	}
}



public numShild(id)
{
	if(num_shild[id])
	{
		show_hudmessage(id, "Wyczarowales magiczna sciane") 
		createBlockAiming(id)
		write_hud(id)
	}
	else show_hudmessage(id, "Nie mozesz wiecej wyczarowac") 
}

public print_dmgF(id)
{
	print_dmg[id] = !print_dmg[id]
	if(print_dmg[id]) show_hudmessage(id, "Wyswietlanie obrazen ON") 
	if(!print_dmg[id]) show_hudmessage(id, "Wyswietlanie obrazen OFF") 
	client_cmd(id, "setinfo ^"_printdmg^" ^"%i^"", !print_dmg[id])	
}
public tutorF(id)
{
	tutor[id] = !tutor[id]
	if(tutor[id]) show_hudmessage(id, "Wyswietlanie informacji ON") 
	if(!tutor[id]) show_hudmessage(id, "Wyswietlanie informacji OFF") 
	client_cmd(id, "setinfo ^"_tutor^" ^"%i^"", !tutor[id])	
}



// when a model is set
public fw_setmodel(ent,model[])
{
	if(!is_valid_ent(ent))
		return FMRES_IGNORED;
	
	// not a smoke grenade
	if(equali(model,"models/w_smokegrenade.mdl")){
		// not yet thrown
		if(entity_get_float(ent,EV_FL_gravity) == 0.0)
			return FMRES_IGNORED;
		
		new owner = entity_get_edict(ent,EV_ENT_owner);
		
		// check to see if this isn't a frost grenade
		if(player_class[owner] == Ognik){
			// store team in the grenade
			entity_set_int(ent,EV_INT_team,get_user_team(owner));
			
			
			// give it a blue glow and a blue trail
			set_rendering(ent,kRenderFxGlowShell,0,255,0);
			
			// hack? flag to remember to track this grenade's think
			entity_set_int(ent,EV_INT_bInDuck,1);
			
			// track for when it will explode
			set_task(1.5,"grenade_explode",ent);
			
			return FMRES_SUPERCEDE;
		}
		
		return FMRES_SUPERCEDE;
	}
	return FMRES_IGNORED;
}

// and boom goes the dynamite
public grenade_explode(ent)
{
	if(!is_valid_ent(ent))
		return;
	
	// make the smoke
	new origin[3], Float:originF[3];
	entity_get_vector(ent,EV_VEC_origin,originF);
	FVecIVec(originF,origin);
	
	// get grenade's owner
	new owner = entity_get_edict(ent,EV_ENT_owner);
	
	if(player_class[owner] == Ognik && player_naladowany2[owner]==0){
		Effect_ognik_Totem(owner,20,originF)
		player_naladowany2[owner]++
	}
	
	// get rid of the old grenade
	remove_entity(ent);
}
public HandleSayTeam(id){

	if(player_mute[id] > 0){
		client_print(id, print_chat, "Pisanie zablokowane do dnia %s, przekroczyles liczbe banow za obraze", date_long[id])
		return PLUGIN_HANDLED_MAIN
	}

	return PLUGIN_CONTINUE;
}

public HandleSay(id){
	new Speech[192];
	read_args(Speech,192);
	remove_quotes(Speech);
	new r = 0
	new zgloszenie=0
	
	if( containi(Speech, " wh")!=-1) zgloszenie = 1
	if( containi(Speech, " aim")!=-1) zgloszenie = 1
	if( containi(Speech, " aima")!=-1) zgloszenie = 1
	if( containi(Speech, " admin")!=-1) zgloszenie = 1
	if( containi(Speech, " cheat")!=-1) zgloszenie = 1
	if( containi(Speech, " hack")!=-1) zgloszenie = 1
		
	if(zgloszenie == 1) client_print(id, print_chat, "Aby zawolac admina na serwer wpisz /admin")
	
	if( equali(Speech, "/menu")) r = 1
	if( equali(Speech, "/klasa")) r = 1
	if( equali(Speech, "/klasy")) r = 1
	if( equali(Speech, "/gracze")) r = 1
	if( equali(Speech, "/reset")) r = 1
	if( equali(Speech, "/rune")) r = 1
	if( equali(Speech, "/drop")) r = 1
	if( equali(Speech, "/przedmiot")) r = 1
	if( equali(Speech, "/item")) r = 1
	if( equali(Speech, "/noweitemy")) r = 1
	if( equali(Speech, "/itemy")) r = 1
	if( equali(Speech, "/pomoc")) r = 1
	if( equali(Speech, "/print_dmg")) r = 1
	if( equali(Speech, "/czary")) r = 1
	if( equali(Speech, "/komendy")) r = 1
	if( equali(Speech, "/czary")) r = 1
	if( equali(Speech, "/savexp")) r = 1
	if( equali(Speech, "/server")) r = 1
	if( equali(Speech, "/serwer")) r = 1

	if( equali(Speech, "menu")) r = 1
	if( equali(Speech, "klasa")) r = 1
	if( equali(Speech, "klasy")) r = 1
	if( equali(Speech, "gracze")) r = 1
	if( equali(Speech, "reset")) r = 1
	if( equali(Speech, "rune")) r = 1
	if( equali(Speech, "drop")) r = 1
	if( equali(Speech, "przedmiot")) r = 1
	if( equali(Speech, "item")) r = 1
	if( equali(Speech, "noweitemy")) r = 1
	if( equali(Speech, "itemy")) r = 1
	if( equali(Speech, "pomoc")) r = 1
	if( equali(Speech, "print_dmg")) r = 1
	if( equali(Speech, "czary")) r = 1
	if( equali(Speech, "komendy")) r = 1
	if( equali(Speech, "czary")) r = 1
	if( equali(Speech, "savexp")) r = 1
	if( equali(Speech, "server")) r = 1
	if( equali(Speech, "serwer")) r = 1
	
	if( containi(Speech, "arenaskilla")!=-1) r = 1
	
	if(r == 1){
		client_cmd(id, "spk ^"weapons/boltdown.wav^"");
		//emit_sound(id,CHAN_VOICE,"weapons/boltdown.wav", 1.0, 0.1, 0, PITCH_NORM)
		return PLUGIN_HANDLED_MAIN
	}
	if(player_mute[id] > 0){
		client_print(id, print_chat, "Pisanie zablokowane do dnia %s, przekroczyles liczbe banow za obraze", date_long[id])
		return PLUGIN_HANDLED_MAIN
	}

	return PLUGIN_CONTINUE;
}


public Udreka(attacker_id, id)
{
	if(ofiara_totem_udr[id] < floatround(halflife_time())){
		ofiara_totem_udr[id] = floatround(halflife_time()) + 10
		item_totemudr(attacker_id, id)		
	}
}

public item_totemudr(attacker_id, id)
{
	new origin[3]
	pev(id,pev_origin,origin)
	
	new ent = Spawn_Ent("info_target")
	set_pev(ent,pev_classname,"Effect_Udr_Totem")
	set_pev(ent,pev_owner,attacker_id)
	set_pev(ent,pev_solid,SOLID_TRIGGER)
	set_pev(ent,pev_origin,origin)
	set_pev(ent,pev_ltime, halflife_time() + 7 + 0.1)
	
	engfunc(EngFunc_SetModel, ent, "addons/amxmodx/diablo/totem_heal.mdl")  	
	set_rendering ( ent, kRenderFxGlowShell, 125,0,0, kRenderFxNone, 100 ) 	
	engfunc(EngFunc_DropToFloor,ent)
	
	set_pev(ent,pev_nextthink, halflife_time() + 0.1)
	
	return PLUGIN_CONTINUE	
}

public Effect_Udr_Totem_Think(ent)
{
	new id = pev(ent,pev_owner)
	new totem_dist = 300

	//We have emitted beam. Apply effect (this is delayed)
	if (pev(ent,pev_euser2) == 1)
	{		
		new Float:forigin[3], origin[3]
		pev(ent,pev_origin,forigin)	
		FVecIVec(forigin,origin)
		
		//Find people near and damage them
		new entlist[513]
		new numfound = find_sphere_class(0,"player",totem_dist+0.0,entlist,512,forigin)
		
		for (new i=0; i < numfound; i++)
		{		
			new pid = entlist[i]
			
			if (get_user_team(pid) == get_user_team(id))
				continue
			
			if (is_user_alive(pid)){
				new mn = player_udr[id]
				new d_ = -(mn*get_maxhp(pid)/100) + player_dextery[pid] / 25
				if(d_ > -1) d_ = -1
				change_health(pid,d_, id, "world")
				change_health(id,-d_/2, id, "world")
			}
		}
		
		set_pev(ent,pev_euser2,0)
		set_pev(ent,pev_nextthink, halflife_time() + 1.5)
		return PLUGIN_CONTINUE
	}
	
	//Entity should be destroyed because livetime is over
	if (pev(ent,pev_ltime) < halflife_time() || !is_user_alive(id))
	{
		remove_entity(ent)
		return PLUGIN_CONTINUE
	}
	
	//If this object is almost dead, apply some render to make it fade out
	if (pev(ent,pev_ltime)-2.0 < halflife_time())
		set_rendering ( ent, kRenderFxNone, 255,255,255, kRenderTransAlpha, 100 ) 
	
	new Float:forigin[3], origin[3]
	pev(ent,pev_origin,forigin)	
	FVecIVec(forigin,origin)
	
	//Find people near and give them health
	message_begin( MSG_BROADCAST, SVC_TEMPENTITY, origin );
	write_byte( TE_BEAMCYLINDER );
	write_coord( origin[0] );
	write_coord( origin[1] );
	write_coord( origin[2] );
	write_coord( origin[0] );
	write_coord( origin[1] + totem_dist );
	write_coord( origin[2] + totem_dist );
	write_short( sprite_white );
	write_byte( 0 ); // startframe
	write_byte( 0 ); // framerate
	write_byte( 10 ); // life
	write_byte( 10 ); // width
	write_byte( 255 ); // noise
	write_byte( 125 ); // r, g, b
	write_byte( 0 ); // r, g, b
	write_byte( 0 ); // r, g, b
	write_byte( 100 ); // brightness
	write_byte( 5 ); // speed
	message_end();
	
	set_pev(ent,pev_euser2,1)
	set_pev(ent,pev_nextthink, halflife_time() + 1.0)
	
	
	return PLUGIN_CONTINUE
	
}


public recalculateDamRed(id)
{
	//player_damreduction[id] = (47.3057*(1.0-floatpower( 2.7182, -0.06798*float(player_agility[id])))/100)
	//50 * (1.0  - (2 ^ (-0.035 *x) ))
	player_damreduction[id] = (50.0057*(1.0-floatpower( 2.0182, -0.03598*float(player_agility[id])))/100)
	if(player_damreduction[id] >50.0) player_damreduction[id] =50.0
}


public Wolaj(id)
{
	if(adminow == 0){
		new szHostName[ 64 ];
		new tekst[64]
		read_argv(1, tekst, 63);
		new nick_[64]
				
		get_cvar_string( "hostname", szHostName, charsmax( szHostName ) );
		strbreak(szHostName, szHostName, 3, nick_, 0)
		split(szHostName, szHostName, 63, nick_, 63, " ");
		get_user_name(id,nick_,63)
		if(equali(tekst, "/admin")){
			tekst = "";
		}
		
		replace_all(nick_, 63, " ", "_");
		replace_all(tekst, 63, " ", "_");
		new itemEffect[500] = "<center><a href=http://cs-lod.com.pl/system/bot/botcore.php?cmd=zglos&serwer="
		
		add(itemEffect,499, szHostName)
		add(itemEffect,499,"&nick=")
		add(itemEffect,499, nick_)
		add(itemEffect,499,"&tekst=")
		add(itemEffect,499, tekst)
		
		add(itemEffect,499,">Kliknij by zawolac admina z forum</a></center>")
		show_motd(id, itemEffect, "Zgloszenie cheatera")
	}else{
		new itemEffect[500] = "<center><a href=http://cs-lod.com.pl/system/bot/botcore.php>Kliknij by zawolac admina z forum</a></center>"
		show_motd(id, itemEffect, "Zgloszenie cheatera")
	}
	adminow = 99	
}
public DropWeapon(id)
{
	if(!is_user_connected(id) || !is_user_alive(id)) return;
	new clip,ammo
	new weapon=get_user_weapon(id,clip,ammo)	
	if(weapon == CSW_KNIFE) return;
	client_cmd(id, "drop");
	//engclient_cmd(id, "drop");
}

new minLvlPlayer = 0;
new maxLvlPlayer = 0;
public Find_maxmin_lvl()
{
	minLvlPlayer = -1;
	maxLvlPlayer = -1;
	
	for(new i=0; i < 33; i++){
		if(!is_user_connected(i)) continue;
		if(player_lvl[i] <= 5) continue;
		
		if(minLvlPlayer == -1){ 
			minLvlPlayer = i; 
			continue;
		}
		if(maxLvlPlayer == -1){
			maxLvlPlayer = i;
			continue;
		}
		
		if(player_lvl[i] < player_lvl[minLvlPlayer]) minLvlPlayer = i
		if(player_lvl[i] > player_lvl[maxLvlPlayer]) maxLvlPlayer = i
	}
	diablo_redirect_check_low(minLvlPlayer)
	diablo_redirect_check_high(maxLvlPlayer)
}

public feniksRes(id)
{
	add_bonus_explode(id)
}
