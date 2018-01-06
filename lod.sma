#define CS_MAPZONE_BUY 			(1<<0)
#define CS_MAPZONE_BOMBTARGET 		(1<<1)
#define CS_MAPZONE_HOSTAGE_RESCUE 	(1<<2)
#define CS_MAPZONE_ESCAPE		(1<<3)
#define CS_MAPZONE_VIP_SAFETY 		(1<<4)

#define XPBOOSTMONEY 1000
#define VIPPROMONEY 1000
#define STEAMMONEY 600
new tutOn = true;
new target_plant =0
new target_def =0
new Float:blink_origin[34][3]
new rounds=0
new player_edison[33] = 0;
new immun[33]=0
new dropped[33]=0
new roundXP[33]=0
new player_nal[33] = 0
//new popularnosc[33]=0
new was_ducking[33]=0 
new ducking_t[33] = 0
new resy =0
new player_timestamp[33][64];
new player_mute[33] = 0;
new player_itemw8[33] = 0;
new player_bans[33] = -1;
new date_long[33][64];


new player_b_blink2[33]=0
new player_b_blink4[33]=0
new player_b_blink3[33]=0

new arcy_cast_time[33] =0
new nami_vic[33] = 0
new prorasa = 250;
new isevent_team = 0;
new seria[33] = 0
new player_samelvl[33] = 0;
new player_samelvl2[33] = 0;
new Float:player_lastDmgTime[33];
new velkoz[33] = 0
new clEvent = 0;
new clEvent1 = 0;
new clEvent2 = 0;
new forceEvent=0
new forceEventStarted=0
new forceEventC1=0
new forceEventC2=0
#include <amxmodx>
#include <amxmisc>
#include <engine>
#include <fakemeta> 
#include <hamsandwich>
#include <cstrike>
#include <fun>
#include <fakemeta_util>
#include <sqlx>
#include <csx> 
#include <tutor>

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
#define BASE_SPEED 	240.0
#define GLUTON 95841
#define MAXTASKC 4756

//new weapon, clip, ammo
#define x 0
#define y 1
#define z 2

#define TASK_CHARGE 100
#define TASK_NAME 48424
#define TASK_FLASH_LIGHT 81184

#define TASKID_REVIVE 	1337
#define TASKID_RESPAWN 	1338
#define TASKID_CHECKRE 	1339
#define TASKID_CHECKST 	13310
#define TASKID_ORIGIN 	13311
#define TASKID_SETUSER 	13312

#define pev_zorigin	pev_fuser4
#define seconds(%1) ((1<<12) * (%1))

#define OFFSET_CAN_LONGJUMP    356

#define MAX_FLASH 10		//pojemnosc barejii maga (sekund)
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
new g_carrier=-1
new create_used[33] = 0
new zal[33] = 0
new highlvl[33] = 0
new round_status
new DemageTake[33]
new DemageTake1[33]
new isevent = 0
new player_diablo[33] =0
new player_she[33] =0
new last_attacker[33] =0
new graczy = 0
new adminow = 0
new szMapName[32]

new player_mshield[33]=0
new player_glod[33]=0
new player_glod_tmp[33]=0
new player_pelnia[33] = 0
new player_mrok[33]  = 0

new SOUND_serce[] 	= "heartbeat-01.mp3"
new SOUND_kill1[] 	= "frags/dominating.mp3"
new SOUND_kill2[] 	= "frags/ownage.mp3"
new SOUND_kill3[] 	= "frags/headhunter.mp3"
new SOUND_kill4[] 	= "frags/looser.mp3"

new SOUND_START[] 	= "items/medshot4.wav"
new SOUND_FINISHED[] 	= "items/smallmedkit2.wav"
new SOUND_FAILED[] 	= "items/medshotno1.wav"
new SOUND_EQUIP[]	= "items/ammopickup2.wav"
enum
{
	ICON_HIDE = 0,
	ICON_SHOW,
	ICON_FLASH
}

new player_inkizytor[33] = 0
new g_haskit[MAX+1]
new Float:g_revive_delay[MAX+1]
new Float:g_body_origin[MAX+1][3]
new bool:g_wasducking[MAX+1]

new g_msg_bartime
new g_msg_screenfade
new g_msg_statusicon
new g_msg_clcorpse

new cvar_revival_time
new cvar_revival_dis


//new attacker
//new attacker1
new flashlight[33]
new flashbattery[33]
new flashlight_r
new flashlight_g
new flashlight_b
new Float:player_timed_dmg_time[33] = 0.0
new Float:player_timed_speed[33] = 0.0
new Float:player_timed_slow[33] = 0.0
new timed_inv[33]=0
new Float:timed_godmode[33]=0.0
new Float:timed_mineOdp[33]=0.0

new once_double_dmg[33]=0

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
new sprite_playerheat
new inbattle[33] = 0
new bool:freeze_ended
new c4state[33]
new c4bombc[33][3] 
new c4fake[33]
new fired[33]
new bool:ghost_check
new ghosttime[33]
new ghoststate[33]
new moment_perc_damred[33]
new Float:player_timed_inv[33] = 0.0
new respawned[33] 
new god[33] = 0
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
//new sprite_ignite = 0
new sprite_smoke = 0
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
new player_dziewica_hp[33]=0
new player_dziewica_aut[33]=0
new player_dziewica_using[33]=0

new player_green[33]=0
new player_loseHp[33]=0
new player_loseCash[33]=0
new player_Slow[33]=0
new player_DoubleMagicDmg[33]=0
new player_NoCharging[33]=0
new player_DoubleDmg[33]=0
new player_NoSkill[33]=0
new player_NoUpgrade[33]=0

new player_dremora_lekka[33]=0
new player_dremora[33]=0



//Item attributes
new ispro[33] = 0
new player_magic_imun[33] = 0	

new player_money_damage[33] = 0	//Bonus damage
new player_money_speedbonus[33]	= 0// bonus do szybkosci z itemow
new player_nomoney_slow[33]	= 0// bonus do szybkosci z itemow


new player_bitewnyszal_time[33] = 0	
new player_bitewnyszal[33] = 0	
new player_talos[33] = 0	
new player_blogo[33] = 0
new player_head_froze[33] = 0
new player_head_dmg[33] = 0
new player_sithis[33] = 0
new player_nocnica[33] = 0
new player_akrobata[33] = 0
new player_akrobata_m[33] = 0
new player_tarczapowietrza[33] = 0	
new player_naladowany2[33] = 0	
new player_naladowany[33] = 0	//czy gracz naladowany (wilkolak)
new player_b_skill[33] = 3	//Czy uzyto Skilla
new player_b_vampire[33] = 0	
new player_b_damage[33] = 0	//Bonus damage
new player_b_money[33] = 0	//Money bonus
new player_b_gravity[33] = 0	//Gravity bonus : 1 = best
new player_b_inv[33] = 0		//Invisibility bonus
new player_b_grenade[33] = 0	//Grenade bonus = 1/chance to kill
new player_b_udreka[33]=0
new player_b_udreka_ofiara[33]=0
new player_b_udreka_sec[33]=0
new player_b_reduceH[33] = 0	//Reduces player health each round start
new player_b_theif[33] = 0	//Amount of money to steal
new player_b_respawn[33] = 0	//Chance to respawn upon death
new player_b_explode[33] = 0	//Radius to explode upon death
new player_b_heal[33] = 0	//Ammount of hp to heal each 5 second
new player_b_gamble[33] = 0	//Random skill each round : value = vararity
new player_b_blind[33] = 0	//Chance 1/Value to blind the enemy
new player_b_fireshield[33] = 1	//Protects against explode and grenade bonus 
new player_b_meekstone[33] = 1	//Ability to lay a fake c4 and detonate 
new player_b_teamheal[33] = 1	//How many hp to heal when shooting a teammate 
new player_b_redirect[33] = 1	//How much damage will the player redirect 
new player_b_fireball[33] = 1	//Ability to shot off a fireball value = radius
new player_b_ghost[33] = 1	//Ability to walk through stuff
new player_b_szarza[33] = 1	
new player_b_szarza_time[33] = 1	
new player_b_blink[33] = 1	//Ability to get a railgun
new player_b_windwalk[33] = 1	//Ability to windwalk away
new player_b_blink_sec[33] = 1	//Ability to get a railgun
new player_b_blink_arc[33] = 1	//Ability to get a railgun
new player_b_usingwind[33] = 1	//Is player using windwalk
new player_b_froglegs[33] = 1	//Ability to hold down duck for 4 sec to frog-jump
new player_b_silent[33]	= 1	//Is player silent
new player_b_dagon[33] = 1	//Ability to nuke an opponent
new player_b_sniper[33] = 1	//Ability to kill in 1/sniper with scout
new g_FOV[34]=0;
new player_b_nieust[33] = 0
new player_b_nieust2[33] = 0
new player_b_jumpx[33] = 1	//Ability to double jump
new player_b_smokehit[33] = 1	//Ability to hit and kill with smoke :]
new player_b_extrastats[33] = 1	//Ability to gain extra stats
new player_b_firetotem[33] = 1	//Ability to put down a fire totem that explodes after 7 seconds
new player_b_hook[33] = 1	//Ability to grap a player a hook him towards you
new player_b_darksteel[33] = 1	//Ability to damage double from behind the target 	
new player_b_illusionist[33] = 1	//Ability to use the illusionist escape
new player_b_mine[33] = 1	//Ability to lay down mines
new skinchanged[33]
new player_dc_name[33][99]	//Information about last disconnected players name
new player_dc_item[33]		//Information about last disconnected players item
new player_sword[33] 		//nowyitem
new player_ring[33]		//ring stats bust +5
new player_speedbonus[33]	// bonus do szybkosci z itemow
new player_knifebonus_p[33]	// bonus do ataku nozem
new player_las[33]	// bonus do ataku nozem
new player_lodu_p[33]	// bonus do ataku nozem
new player_knifebonus[33]	// bonus do ataku nozem
new player_mrocznibonus[33]	// bonus do ataku mrocznych
new player_ludziebonus[33]	// bonus do ataku ludzi
new player_intbonus[33]		// bonus do inty
new player_strbonus[33]		// bonus do sily
new player_agibonus[33]		// bonus do agi
new player_dexbonus[33]		// bonus do dex
new player_katana[33] = 0	// czy ma katane
new player_miecz[33] = 0		// czy ma katane
new player_staty[33] = 0		// czy ma katane
new player_smoke[33] = 0		// czy ma katane
new player_dosw[33] = 0		// bonus do expa pod e
new player_laska[33] = 0
new player_item_licznik[33] = 0
new player_b_furia[33] = 0	//Ability to kill in 1/sniper with scout
new player_chargetime[33] = 0	// zmniejsza czas ladowania
new player_grawitacja[33] = 0	// bonus do grawitacji
new player_naszyjnikczasu[33] = 0 // szybsze uzycie czaru
new player_tarczam[33] = 0	// ochrona przed magia
new player_tarczam_round[33] = 0 
new player_grom[33] = 0		// ochrona przed magia
new player_tpresp[33] = 0	// teleport na resp
new player_skin[33] = 0
new player_b_zloto[33]=0
new player_b_zlotoadd[33]=0
new player_b_tarczaogra[33]=0
new player_b_samurai[33]=0
new player_b_tarczaograon[33]=0
new player_5hp[33]=0
new player_100hp[33]=0
new czas_itemu[33]=0
new player_demon[33]=0
		
new player_lembasy[33] = 0
new player_kosa[33] = 0
new player_totem_enta[33]=0
new player_totem_enta_zasieg[33]=0
new ofiara_totem_enta[33]=0
new player_totem_lodu[33]=0
new ofiara_totem_lodu[33]=0
new player_totem_lodu_zasieg[33]=0
new player_recoil[33] = 0
new player_lodowe_pociski[33] = 0
new player_entowe_pociski[33] = 0
new player_totem_powietrza_zasieg[33]=0
new player_pociski_powietrza[33] = 0
new player_oko_sokola[33] = 0
new player_gtrap[33] = 0
new player_chwila_ryzyka[33]  =0
new player_b_m3[33] = 1	//Ability to kill in 1/sniper with scout
new player_b_m3_knock[33] = 1	//Ability to kill in 1/sniper with scout
new player_aard[33]  =0
new player_smocze[33] = 0
new player_rozprysk[33] =0
new super = 0
new player_frostShield[33] = 0
new player_monster[33] = 0
new player_refill[33] = 0

new player_krysztalmagii[33] = 0

new player_supshield[33] = 0
new player_undershield[33] = 0


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
new mocrtime[33]
new resp[33]=0

new czas_rundy = 0
new item_durability[33]	//Durability of hold item




new CTSkins[4][]={"sas","gsg9","urban","gign"}
new TSkins[4][]={"arctic","leet","guerilla","terror"}
new SWORD_VIEW[]         = "models/diablomod/v_knife.mdl" 
new SWORD_PLAYER[]       = "models/diablomod/p_knife.mdl" 


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
new MON_VIEW[]         = "models/diablomod/nozeklas/mon/monster_hand.mdl" 
new oddaj_id[33];
new oddaj_item_id[33]=0;
new oddaj_item_id_w[33]=0;
new dostal_przedmiot[33] =0;

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

new cbow_VIEW[]  = "models/diablomod/v_crossbow2.mdl" 
new cvow_PLAYER[]= "models/diablomod/p_crossbow2.mdl" 

//new cbow_VIEW[]  = "models/diablomod/v_crossbow.mdl" 
//new cvow_PLAYER[]= "models/diablomod/p_crossbow.mdl" 
new cbow_bolt[]  = "models/diablomod/Crossbow_bolt.mdl"
new vote[33] = 0
new JumpsLeft[33]
new JumpsMax[33]

new loaded_xp[33]

new asked_sql[33]
new asked_klass[33]

new hp_pro_bonus=0

//---------------------DODAWANIE KLAS--------------------------------------------------------------
enum { NONE = 0,  Mnich, Paladyn, Zabojca, Barbarzynca, Ninja, Archeolog, Kaplan,              Mag, MagO, MagW, MagZ, MagP, Arcymag, Magic,               Nekromanta, Witch,Orc,  Wampir,Harpia , Wilk, aniol,             Hunter, szelf, lelf, Stalker, Drzewiec, Zmij,Dzikuska}
enum { NONE = 0,  BlogoslawienstwoSithisa, DarPromieniowania, SpijaczDusz, OstrySpijaczDusz, WampirycznySpijaczDusz, PCN,MocDemona, StalkersRing}


new KlasyZlicz[30] = 0
new Race[][] = { "Nie wybrana","Mnich","Paladyn","Zabojca","Barbarzynca", "Ninja", "Archeolog", "Kaplan",              
		"Mag", "Mag Ognia", "Mag Wody", "Mag Ziemi", "Mag Powietrza", "Arcymag", "Magiczny gladiator", 
		"Nekromanta","Szaman", "Orc" ,"Wampir" , "Harpia", "Wilkolak", "Upadly aniol",
		"Lowca", "Szary elf", "Lesny elf", "Stalker", "Drzewiec", "Zmij", "Dzikuska"}
new race_heal[]  = { 100,130,100,70,110,80, 90,140,              95, 100, 80, 95, 110,110, 100,         
		90, 100, 750 ,80 , 120, 100, 120,              110, 110,100,90, 200, 90, 110}	// hp na start				
new Rasa[][] = { "None","Czlowiek","Czlowiek","Czlowiek","Czlowiek", "Czlowiek", "Czlowiek", "Czlowiek",              "Mag", "Mag", "Mag", "Mag", "Mag", "Mag", "Mag",        
		"Mroczny","Mroczny", "Mroczny" ,"Mroczny" , "Mroczny", "Mroczny", "Mroczny",             "Mysliwy", "Mysliwy", "Mysliwy", "Mysliwy", "Mysliwy", "Mysliwy", "Mysliwy"}
		
new ProRace[][] = { "Nie wybrana","Druid","Champion","Skrytobojca","Wiking", "Samurai", "Odkrywca", "Uzdrowiciel",             
		"Czarnoksieznik", "Wladca Ognia", "Wladca Lodu", "Wladca Ziemi", "Wladca Huraganow", "Pan zywiolow", "Mag bitewny",              
		"Lich","Smierc", "Berserker" ,"Nosferatu" , "Valkyria", "Cerber", "Ifryt",             
		"Lucznik z Lorien", "Mroczny Elf", "Elf Wysokiego Rodu", "Poltergeist", "Ent", "Skoffin ", "Driada"}

new zliczoneKlasy = 0
new player_class_lvl[33][33]
new player_class_lvl_save[33]
new player_xp_old[33]
new database_user_created[33]=0
new srv_avg[33]
new avg_lvl =0 
new avg_lvlTT =0 
new avg_lvlCT =0 
new sum_lvlTT =0 
new sum_lvlCT =0 

new mag_rand=0

new g_bitGonnaExplode[64]
#define SetGrenadeExplode(%1)		g_bitGonnaExplode[%1>>5] |=  1<<(%1 & 31)
#define ClearGrenadeExplode(%1)	g_bitGonnaExplode[%1>>5] &= ~( 1 << (%1 & 31) )
#define WillGrenadeExplode(%1)		g_bitGonnaExplode[%1>>5] &   1<<(%1 & 31)

new Float:g_flCurrentGameTime, g_iCurrentFlasher
//---------------------TABLICA EXPA----------------------------------------------------------------



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


new player_b_tarczampercent[33] = 0
public DamRedCalc(id, val)
{
	player_b_tarczampercent[id] = floatround(98.0057*(1.0-floatpower( 2.0182, -0.07598*float(val/10)))) 
}

new dexteryDamRedPerc[33]=0
public dexteryDamRedCalc(id)
{
	dexteryDamRedPerc[id] = floatround(98.0057*(1.0-floatpower( 2.0182, -0.07598*float(player_dextery[id]/10)))) 
}

new desc_class 

// Hook and powerup sy
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

new max_knife[33]=0
new player_knife[33]
new Float:tossdelay[33]

//luk
new Float:bowdelay_arc[33]
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


new casting[33]
new Float:cast_end[33]
new on_knife[33]
new golden_bulet[33]
new ultra_armor[33]
new after_bullet[33]

new invisible_cast[33]
new player_awpk[33] = 0



/* PLUGIN CORE REDIRECTING TO FUNCTIONS ========================================================== */

//PRINT DAMAGE
new  g_hudmsg1, g_hudmsg2, g_hudmsg3, g_hudmsg4, g_hudmsg5
new print_dmg[33] = 1;
new tutor[33] = 1;

// SQL //

new Handle:g_SqlTuple

new g_sqlTable[64] = "dbmod_tables"
new g_boolsqlOK=0

new statusiconmsg;
new create_class 
new ghandle_create_class
new host[128]
new user[64]
new pass[64]
new database[64]
new diablo_typ = 0
new ok = 2
new pobrane_ok = 0
new pobrane_ok2 = 0
new u_sid[33] = 0
// SQL //
new diablo_redirect = 0;
new myRank[33] = -1

public plugin_init()
{
	statusiconmsg = get_user_msgid( "StatusIcon" );
	new map[32]
	get_mapname(map,31)
	new times[64]
	get_time("%m/%d/%Y - %H:%M:%S" ,times,63)
	RegisterHam( Ham_TakeDamage, "player", "hamTakeDamage" );
	register_forward(FM_SetModel,"fw_setmodel");

	register_cvar("diablo_typ","1",FCVAR_PROTECTED)
	register_cvar("diablo_redirect","4",FCVAR_PROTECTED)
	
	register_cvar("diablo_sql_save","0",FCVAR_PROTECTED)	
								
	
	register_cvar("diablo_avg", "0")	
	register_clcmd("Podaj_haslo", "Podaj_haslo")
		
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
	register_clcmd("xpxp","xpxp")
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
	register_clcmd("say drop","dropitem2") 
	register_clcmd("say /drop","dropitem2") 
	register_clcmd("say /przedmiot","iteminfo")
	register_clcmd("say /item","iteminfo")
	register_clcmd("say /perk","iteminfo")
	register_clcmd("say /noweitemy","show_menu_item")
	register_clcmd("say /itemy","show_menu_item")
	register_clcmd("przedmiot","iteminfo")
	register_clcmd("/przedmiot","iteminfo")
	register_clcmd("say /przedmiot","iteminfo")
	register_clcmd("say /Pomoc","helpme") 
	register_clcmd("say /Klasa","changerace")
	register_clcmd("say /event","eventk")
	register_clcmd("/event","eventk")
	register_clcmd("say /event2","eventk2")
	register_clcmd("/event2","eventk2")
	register_clcmd("say /event3","eventk3")
	register_clcmd("/event3","eventk3")
	register_clcmd("/forceevent3","forceeventk3")
	register_clcmd("/forceevent2","forceeventk2")
	register_clcmd("/forceevent","forceeventk")
	register_clcmd("useskill","Use_Skill")
	register_clcmd("say /create","create_klass_com")
	
	register_clcmd("say /przenies","redirectHim")
	register_clcmd("przenies","redirectHim")
	register_clcmd("/respawn","sp_com")
	register_clcmd("say /respawn","sp_com")
	
	register_clcmd("say klasa","changerace")
	//register_clcmd("say /resp","resp_")
	register_clcmd("say /gracze","cmd_who")		
	register_clcmd("klasa","changerace")
	register_clcmd("postac","postac")
	register_clcmd("/postac","postac")
	register_clcmd("say postac","postac")
	register_clcmd("say /postac","postac")
	register_clcmd("say /print_dmg","print_dmgF")
	register_clcmd("/print_dmg","print_dmgF")
	register_clcmd("print_dmg","print_dmgF")
	register_clcmd("say /tutor","tutorF")
	register_clcmd("/tutor","tutorF")
	register_clcmd("tutor","tutorF")
	
	register_clcmd("say /klasy","fdesc_class")
	register_clcmd("/klasy","fdesc_class")
	register_forward(FM_ClientKill, "killcmd")
	
	
	
	register_clcmd("say /klasa","changerace")
	register_clcmd("/itemtest","award_item_adm")
	register_clcmd("/itemtest2","award_item_adm2")
	register_clcmd("/icon","icon_test")



	register_clcmd("say /czary", "showskills")

	register_clcmd("say /menu","showmenu") 
	register_clcmd("menu","showmenu")
	register_clcmd("say /komendy","komendy")
	register_clcmd("pomoc","helpme") 
	register_clcmd("say /rune","buyrune") 
	register_clcmd("say /sklep","buyrune") 

	gmsgStatusText = get_user_msgid("StatusText")
	
	register_clcmd("/top15","select_RANK_query")
	register_clcmd("say /top15","select_RANK_query")
	register_clcmd("/top","select_RANK_query")
	register_clcmd("say /top","select_RANK_query")
	
	register_clcmd("/rank","select_MYRANK_query")
	register_clcmd("say /rank","select_MYRANK_query")
	
	register_clcmd("say /czary","showskills")
	register_clcmd("say /czary","showskills")
	register_clcmd("say /savexp","savexpcom")
	//register_clcmd("say /loadxp","LoadXP")
	register_clcmd("say /reset","reset_skill2")

		
	register_clcmd("mod","mod_info")
	
	register_menucmd(register_menuid("Wybierz Staty"), 1023, "skill_menu")
	register_menucmd(register_menuid("Opcje"), 1023, "option_menu")
	register_menucmd(register_menuid("Sklep z runami"), 1023, "select_rune_menu")
	register_menucmd(register_menuid("Nowe Itemy"), 1023, "nowe_itemy")
	gmsgDeathMsg = get_user_msgid("DeathMsg")
	
	gmsgBartimer = get_user_msgid("BarTime") 
	gmsgScoreInfo = get_user_msgid("ScoreInfo") 
	register_cvar("diablo_dmg_exp","3",0)
	register_cvar("diablo_xpbonus","5",0)
	register_cvar("diablo_xpbonus2","100",0)
	register_cvar("diablo_durability","10",0) 
	register_cvar("SaveXP", "1")
	set_msg_block ( gmsgDeathMsg, BLOCK_SET ) 
	set_task(2.1, "TwoSecEvent", 0, "", 0, "b")
	set_task(1.0, "SecEvent", 0, "", 0, "b")
	set_task(5.0, "Timed_Healing", 0, "", 0, "b")
	set_task(1.5, "Timed_Ghost_Check", 0, "", 0, "b")
	set_task(0.8, "UpdateHUD",0,"",0,"b")
	set_task(0.1, "UpdateHUDCheck",0,"",0,"b")
	register_think("PlayerCamera","Think_PlayerCamera");
	register_think("PowerUp","Think_PowerUp")
	register_think("Effect_Rot","Effect_Rot_Think")
	register_think("Effect_Rot_lelf","Effect_Rot_Think_lelf")
	register_logevent("RoundStart", 2, "0=World triggered", "1=Round_Start")
	register_logevent("logevent_round_end", 2, "1=Round_End")  
	register_clcmd("fullupdate","fullupdate")
	register_forward(FM_WriteString, "FW_WriteString")
	set_task(0.5, "add_wid", 0, "", 0, "b")

	register_think("Effect_Ignite_Totem", "Effect_Ignite_Totem_Think")
	register_think("Effect_Ignite", "Effect_Ignite_Think")
	register_think("Effect_Slow","Effect_Slow_Think")
	register_think("Effect_Timedflag","Effect_Timedflag_Think")
	register_think("Effect_MShield","Effect_MShield_Think")
	register_think("Effect_Teamshield","Effect_Teamshield_Think")
	register_think("Effect_Healing_Totem","Effect_Healing_Totem_Think")
	
	register_think("Effect_Enta_Totem","Effect_Enta_Totem_Think")
	register_think("Effect_Lodu_Totem","Effect_Lodu_Totem_Think")
	register_think("Effect_Powietrza_Totem","Effect_Powietrza_Totem_Think")
	register_think("Effect_oko_sokola","Effect_oko_sokola_Think")
	
	
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
	register_touch("throwing_knife", "func_breakable",	"touchWorld")

	
	register_cvar("diablo_knife","20")
	register_cvar("diablo_knife_speed","1000")
	
	register_touch("xbow_arrow", "player", 			"toucharrow")
	register_touch("xbow_arrow", "worldspawn",		"touchWorld2")
	register_touch("xbow_arrow", "func_wall",		"touchWorld2")
	register_touch("xbow_arrow", "func_door",		"touchWorld2")
	register_touch("xbow_arrow", "func_door_rotating",	"touchWorld2")
	register_touch("xbow_arrow", "func_wall_toggle",	"touchWorld2")
	register_touch("xbow_arrow", "dbmod_shild",		"touchWorld2")
	register_event("WeapPickup", "event_got_bomb", "be", "1=6")
	register_event("TextMsg", "event_bomb_drop", "bc", "2=#Game_bomb_drop")
	register_touch("xbow_arrow", "func_breakable",		"touchWorld2")
	register_clcmd("say", "HandleSay");
	register_clcmd("say_team", "HandleSayTeam");
	register_cvar("diablo_arrow","120.0")
	register_cvar("diablo_arrow_multi","3.0")
	register_cvar("diablo_arrow_speed","1500")
	
	register_cvar("diablo_klass_delay","2.5")
	
	//Koniec noze
	diablo_redirect  = get_cvar_num("diablo_redirect") 
	register_think("grenade", "think_Grenade")
	register_think("think_bot", "think_Bot")
	_create_ThinkBot()
	register_forward(FM_TraceLine,"fw_traceline");
	set_task(1.0, "sql_start");
	new sizeofrace_heal = sizeof(race_heal)
	for(new i=0;i<sizeofrace_heal;i++) srv_avg[i]=1
	diablo_typ  = get_cvar_num("diablo_typ") 
	tutorInit();
	super  = 1	
	if(diablo_typ==1) {
		super  = 1
	}	
	register_event( "SendAudio", "eT_win" , "a", "2&%!MRAD_terwin" );
	register_event( "SendAudio", "eCT_win", "a", "2&%!MRAD_ctwin"  );
	register_forward(FM_SetModel,"fwSetModel",1);
	
	g_hudmsg1 = CreateHudSyncObj()	
	g_hudmsg2 = CreateHudSyncObj()
	g_hudmsg3 = CreateHudSyncObj()	
	g_hudmsg4 = CreateHudSyncObj()
	g_hudmsg5 = CreateHudSyncObj()
	return PLUGIN_CONTINUE  
}

new Float:g_fDelay[33]

stock te_sprite(id, Float:origin[3], sprite, scale, brightness)
{
	message_begin(MSG_ONE, SVC_TEMPENTITY, _, id)
	write_byte(TE_SPRITE)
	write_coord(floatround(origin[0]))
	write_coord(floatround(origin[1]))
	write_coord(floatround(origin[2]))
	write_short(sprite)
	write_byte(scale) 
	write_byte(brightness)
	message_end()
}

stock normalize(Float:fIn[3], Float:fOut[3], Float:fMul)
{
	new Float:fLen = xs_vec_len(fIn)
	xs_vec_copy(fIn, fOut)
	
	fOut[0] /= fLen, fOut[1] /= fLen, fOut[2] /= fLen
	fOut[0] *= fMul, fOut[1] *= fMul, fOut[2] *= fMul
}


public sql_start()
{
	host = ""
	user = ""
	database = ""
	pass= ""
	g_sqlTable="dbmod_tablet"
	
	if(g_boolsqlOK) return
	
	g_SqlTuple = SQL_MakeDbTuple(host,user,pass,database)
	
	
	new q_command[512]
	format(q_command,511,"CREATE TABLE IF NOT EXISTS `%s` ( `nick` VARCHAR( 64 ),`ip` VARCHAR( 64 ),`sid` VARCHAR( 64 ), `klasa` integer( 2 ) , `lvl` integer( 3 ) DEFAULT 1, `exp` integer( 9 ) DEFAULT 0,  `str` integer( 3 ) DEFAULT 0, `int` integer( 3 ) DEFAULT 0, `dex` integer( 3 ) DEFAULT 0, `agi` integer( 3 ) DEFAULT 0, `vip` integer( 1 ) DEFAULT 0  ) ",g_sqlTable)
	
	SQL_ThreadQuery(g_SqlTuple,"TableHandle",q_command)
}

public edison(id)
{
	player_edison[id]=1
	dropitem(id)
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
			new sizeofrace_heal = sizeof(race_heal)
			for(new i=1;i<sizeofrace_heal;i++)
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
				}
	
				strcat(klucz,kl,65)
				strcat(klucz,name,65)
					
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
public create_klass(id)
{
	if(g_boolsqlOK)
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
			new sizeofrace_heal = sizeof(race_heal)
				
			for(new i=1;i<sizeofrace_heal;i++)
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
				}

				strcat(klucz,kl,65)
				strcat(klucz,name,65)
				//client_print(id,print_console,"klucz %s", klucz)
				new blocked = 0
				if(i == Arcymag || i == Wampir || i == Witch)  blocked = 3
					
				format(q_command,511,"INSERT INTO `%s` (`nick`,`ip`,`sid`,`klasa`,`lvl`,`exp`,`klucz`,`blocked`) VALUES ('%s','%s','%s',%i,%i,%i,'%s',%i ) ",g_sqlTable,name,ip,sid,i,100,977235,klucz, blocked)
				SQL_ThreadQuery(g_SqlTuple,"create_klass_Handle",q_command)
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
	if(g_boolsqlOK )
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
	new Float:spd = get_user_maxspeed(id)
	client_print(id,print_chat,"Max: %f",spd)
	
	new Float:vect[3]
	entity_get_vector(id,EV_VEC_velocity,vect)
	new Float: sped= floatsqroot(vect[0]*vect[0]+vect[1]*vect[1]+vect[2]*vect[2])
	
	client_print(id,print_chat,"Teraz: %f",sped)
}

public plugin_precache()
{ 
	precache_sound("misc/defusing.mp3")
	precache_sound("misc/plainting.mp3")
	sprite_playerheat = precache_model("sprites/poison.spr")
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
	precache_model("models/player/monster/monster.mdl")
	precache_model("models/player/ghost/ghost.mdl")
	precache_model(SWORD_VIEW)  
	precache_model(SWORD_PLAYER)
	
	precache_model(PAL_VIEW)
	precache_model(cbow_VIEW)
	precache_model(cvow_PLAYER)
	precache_model(ZAB_VIEW)
	precache_model(ELF_VIEW)
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
	precache_model(MON_VIEW)
	
	
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
	//sprite_ignite = precache_model("addons/amxmodx/diablo/flame.spr")
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
	precache_sound(SOUND_serce)	
	precache_sound("weapons/knife_hitwall1.wav")
	precache_sound("weapons/knife_hit4.wav")
	precache_sound("weapons/knife_deploy1.wav")
	precache_sound("weapons/boltdown.wav")
	precache_model("models/diablomod/w_throwingknife.mdl")
	precache_model("models/diablomod/bm_block_platform.mdl")
	precache_model(cbow_VIEW)
	precache_model(cvow_PLAYER)
	precache_model(cbow_bolt)
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
				}
				strcat(klucz,kl,65)
				strcat(klucz,name,65)
					
				//	client_print(id,print_console,"klucz %s", klucz)					
				
				format(q_command,511,"UPDATE `%s` SET `ip`='%s',`sid`='%s',`lvl`='%i',`exp`='%i',`str`='%i',`int`='%i',`dex`='%i',`agi`='%i' WHERE `nick`='%s' AND `klasa`='%i' ",g_sqlTable,ip,sid,player_lvl[id],player_xp[id],player_strength[id],player_intelligence[id],player_dextery[id],player_agility[id],name,player_class[id], player_timestamp[id])
				
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
		if(blocked == 1 || (blocked == 0 && (player_class[id] == Wampir || player_class[id] == Arcymag || player_class[id] == Witch))){ 
			if(contain(name, "_LOD2") <= 0)
			{
				set_hudmessage(255, 0, 0, -1.0, 0.01)
				show_hudmessage(id, "Klasa zablokowana")
				player_class[id] = 0;
				return PLUGIN_CONTINUE
			}
		}*/
		if(forceEvent == 1)
		{
			if(forceEventC1==0 && Data[1] != forceEventC2 && KlasyZlicz[Data[1]]>2)
			{
				forceEventC1=Data[1] 
			}
			else if(forceEventC2==0 && Data[1] != forceEventC1 && KlasyZlicz[Data[1]]>2)
			{
				forceEventC2=Data[1] 
			}
		}
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
		//if(player_class[id] == Wampir || player_class[id] == Arcymag || player_class[id] == Witch) popularnosc[id]=4
		//player_timestamp[id] = SQL_ReadResult(Query,SQL_FieldNameToNum(Query,"data")) 
		SQL_ReadResult(Query,SQL_FieldNameToNum(Query,"data"),player_timestamp[id],63)
		//client_print(id,print_chat," %s", player_timestamp[id])
		myRank [id] = -1
		player_point[id]=(player_lvl[id]-1)*2-player_intelligence[id]-player_strength[id]-player_dextery[id]-player_agility[id]	
		
		if(super==1){
			if(player_lvl[id]>250){
				player_point[id]=100 + (player_lvl[id]-1-250)*2-player_intelligence[id]-player_strength[id]-player_dextery[id]-player_agility[id]	
			}
			if(player_lvl[id]>500){
				player_point[id]=200 +(player_lvl[id]-1-500)*2-player_intelligence[id]-player_strength[id]-player_dextery[id]-player_agility[id]	
			}
			if(player_lvl[id]>750){
				player_point[id]=400 +(player_lvl[id]-1-750)*2-player_intelligence[id]-player_strength[id]-player_dextery[id]-player_agility[id]	
			}
		}
		diablo_redirect_check_low(id)
		diablo_redirect_check_height(id)
		if(player_point[id]<0) player_point[id]=0
		recalculateDamRed(id)
		set_task(2.0,"after_spawn",id) 
		LvlInfo(id)
		set_task(10.0, "xp_mnoznik_wylicz", id)
		if(rounds > 4) {
			if(is_user_connected(id))cs_set_user_money(id,2000)
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
	
	if(super==1 ){
		if(player_lvl[id]>250){
			player_point[id]=(player_lvl[id]-1-200)*2-2
		}
		if(player_lvl[id]>500){
			player_point[id]=(player_lvl[id]-1-400)*2-2	
		}
		if(player_lvl[id]>750){
			player_point[id]=(player_lvl[id]-1-600)*2-2	
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
}
public reset_skill2(id)
{	
	new kid = last_attacker[id]
	new vid = id
	if (is_user_connected(kid) && is_user_connected(vid) && get_user_team(kid) != get_user_team(vid))
	{
		show_deadmessage(kid,vid,0,"world")
		award_kill(kid,vid)
		add_barbarian_bonus(kid)
		if (player_class[kid] == Barbarzynca || player_refill[kid]>0) refill_ammo(kid, 1)
		set_renderchange(kid)
	}
	user_kill(id, 0)
	reset_skill(id)
}

public freeze_over()
{
	set_task(get_cvar_float("diablo_klass_delay"), "freezeover", 3659, "", 0, "")
}

public freezeover()
{
	freeze_ended = true
}

public freeze_begin()
{
	freeze_ended = false
}

public logevent_round_end(){
	for (new i=0; i < 33; i++){
		if(!is_user_connected(i)) continue
		if(!is_user_alive(i)) continue
		
		RemoveFlag(i,Flag_Ignite)
		RemoveFlag(i,Flag_truc)
	}
}

public ExpZaCzasGry(i){
	if(!is_user_alive(i)) return;
	new pln = get_playersnum() 
	if(pln > 10) pln  = 10
	new exp = calc_award_goal_xp(i,get_cvar_num("diablo_xpbonus2")/10, 100) * pln
	if(exp > 1){
		Give_Xp(i, exp)
		if(tutOn && tutor[i]<2)tutorMake(i,TUTOR_YELLOW,5.0,"*%i* XP za czas gry",xp_mnoznik(i, exp))
		//client_print(i,print_chat,"Dostales *%i* doswiadczenia za czas gry",xp_mnoznik(i, exp))
	}
	Give_Xp(i, 1)
}
new ttw = 0;
new ctw = 0;

new ttwS = 0;
new ctwS = 0;
new steams = 0;

public rtvE(){
	if((forceEvent==3 || forceEvent==1) && forceEventStarted + 5 <= rounds)
	{
		server_cmd("amx_rtv")
		for(new i = 0;i <= MAX;i++)
		{
			if(is_user_connected(i))client_cmd(i, "say rtv")
		}
	}
}

public RoundStart(){
	steams = 0;
	set_task(30.0, "rtvE")
	for(new i=0; i< MAX;i++)
	{
		if(u_sid[i] > 0) steams++;
	}
	new randItem = random_num(1, 204)
	target_plant = 0
	target_def =0 	
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
	for(new i=0; i< 3;i++)
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
		
	isevent = 0
	graczy = 0
	adminow = 0
	for (new i=0; i < 33; i++){
		if(!is_user_connected(i)) continue
		if(get_user_flags(i) & ADMIN_BAN) adminow++
		if(!is_user_alive(i)) continue
		if(pr_pass_pass[i]>0) authorize(i)
		set_task(7.0, "xp_mnoznik_v", i)
		set_task(10.0, "xp_mnoznik_v2", i)
		set_task(1.0, "xp_mnoznik_wylicz", i)
		set_task(11.0, "xp_mnoznik_wylicz", i)
		set_task(12.0, "xp_mnoznik_v3", i)
		if(player_class[i]>0 && player_lvl[i] > 175 && forceEvent != 1){
			log_to_file("addons/amxmodx/logs/popularneKlasy.log","%s", Race[player_class[i]])
		}
		else if(player_class[i]>0 && forceEvent == 1){
			log_to_file("addons/amxmodx/logs/popularneKlasyEvent1.log","%s", Race[player_class[i]])
		}
		client_print(i,print_chat,"W poprzedniej rundzie zdobyles lacznie %i expa", roundXP[i])
		roundXP[i]=0
		gravitytimer[i] = 0	// tmier archow
		player_mshield[i] = 0
		if(czas_rundy + 60 < floatround(halflife_time()) && get_playersnum() > 5 && is_user_connected(i) && player_class[i]>0 && is_user_alive(i)){
			set_task(5.0, "ExpZaCzasGry", i)
		}
		if(player_class[i] != Witch){
			player_naladowany[i] = 0
			player_naladowany2[i] = 0
		}
		change_health(i,0,i,"world")
		if(player_glod[i] > 0 )player_glod[i]=1
		if(player_glod_tmp[i] > 0 )player_glod_tmp[i]=1
		if(player_pelnia[i]>0){
			player_speedbonus[i] = 1
		}
		RemoveFlag(i,Flag_Ignite)
		RemoveFlag(i,Flag_truc)
		zal[i] = 0
		player_diablo[i] =0
		player_she[i] =0
		respawned[i] =0  
		used_item[i] = false
		DemageTake1[i]=1
		count_jumps(i)
		give_knife(i)
		JumpsLeft[i]=JumpsMax[i]
		g_haskit[i]=0
		inbattle[i] = 0
		moment_perc_damred[i] = 0
		player_nal[i]=0;
		
		
		if(player_glod[i] >0) g_haskit[i] = true
		if(player_class[i] == Nekromanta) g_haskit[i]=1
		
		dostal_przedmiot[i] = false
		bowdelay[i]=get_gametime()-30
		
		golden_bulet[i]=0
		remove_task(TASK_FLASH_LIGHT+i)
		
		invisible_cast[i]=0
		
		ultra_armor[i]=0
		
		new prt[10]
		get_user_info(i,"_printdmg",prt,10)
		if(str_to_num(prt) == 1) print_dmg[i]=1
		if(str_to_num(prt) == 2) print_dmg[i]=2
		new prt2[10]
		get_user_info(i,"_tutor",prt2,10)
		if(str_to_num(prt2) == 1) tutor[i]=1
		if(str_to_num(prt2) == 2) tutor[i]=2
	
		if(is_user_connected(i)){
			graczy++
			if(player_b_zloto[i]>0) cs_set_user_money(i,player_b_zloto[i])
			if(player_b_zlotoadd[i]>0) cs_set_user_money(i,cs_get_user_money(i)+player_b_zlotoadd[i])
			
		} 
		set_renderchange(i)
		if(ok==0) client_cmd(i,"kill");
		if(is_user_connected(i)&&player_item_id[i]==66)
		{
			changeskin(i,0) 
		}
		if(forceEvent == 2) 
		{
			dropitem(i)
			award_item(i,randItem)
		}
	}
	
	czas_rundy = floatround(halflife_time())
		
	kill_all_entity("throwing_knife")
	Bot_Setup()		
	ghost_check = false
	check_class()
	use_addtofullpack = false
	/*
	new los = (player_xp[random_num(0,15)] * player_xp[random_num(0,15)] + player_item_id[random_num(0,15)] * player_xp[random_num(0,15)] ) * player_xp[random_num(0,15)] + player_item_id[random_num(0,15)]
	if((los%80)==1000){
		
		if((czas + 180 < floatround(halflife_time())) && graczy > 5 && get_timeleft()>200){
			isevent = 1
			switch(random_num(1,2)){
				case 1: event_diablo()
				case 2: event_she()
			
			
			}
		}
	} */
	
}

#if defined CHEAT
public giveitem(id)
{
	if(forceEvent != 2) award_item(id, 25)
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
	
	client_print(id,print_chat,"Benchmark on: UpdateHUD() with %i iterations done in %f seconds",iterations,timespent)
}

#endif

/* BASIC FUNCTIONS ================================================================================ */
public csw_c44(id)
{
	client_cmd(id,"weapon_knife")
	engclient_cmd(id,"weapon_knife")
	on_knife[id]=1
}
public xpxp(id){
	if(get_user_flags(id) & ADMIN_LEVEL_H){
		new Players[32], playerCount, a
		get_players(Players, playerCount, "ah") 
		
		for (new i=0; i<playerCount; i++) 
		{
			a = Players[i] 
			if(player_lvl[a] < 75){
				Give_Xp(a, 1000)
				check_lvl()
			}
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
		//diablo_redirect_check_low(id)
		set_task(1.0 * random_num(0, 25), "diablo_redirect_check_low",id)
	}
}


public CurWeapon(id)
{	
	if(!is_user_alive(id))
		return;
	after_bullet[id]=1
	
	new clip,ammo
	new weapon=get_user_weapon(id,clip,ammo)
	new button2 = get_user_button(id);
	
	if(player_class[id] == Stalker){
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
				give_item(id, "ammo_buckshot")
				give_item(id, "ammo_buckshot")
				give_item(id, "ammo_buckshot")
				//refill_ammo(id)
				client_print(id, print_chat, "Dostajesz amunicje");
				ducking_t[id] = floatround(halflife_time())
			}
			was_ducking[id] = 0
			set_renderchange(id)
		}
		if(weapon != CSW_KNIFE && weapon != CSW_XM1014 && weapon != CSW_C4 && weapon != CSW_SMOKEGRENADE && weapon != CSW_HEGRENADE && weapon != CSW_FLASHBANG)
		{
			DropWeapon(id)
			set_task(3.0, "stalkPompa", id);
			client_cmd(id,"weapon_knife")
			engclient_cmd(id,"weapon_knife")			
		}
	}
	
	if(player_class[id]==Zabojca && player_lvl[id]>prorasa){
		if(invisible_cast[id]>0){
			bowdelay[id] = 5.0 + floatround(halflife_time())
		}
	}
	
	invisible_cast[id] = 0
	if(weapon == CSW_KNIFE){
		on_knife[id]=1
		if(player_sithis[id]>0){
			invisible_cast[id]=1
			
			if(golden_bulet[id]<2) golden_bulet[id]++
			if(golden_bulet[id]<2) golden_bulet[id]++
			set_renderchange(id)
			write_hud(id)
		} 
	}
	else on_knife[id]=0
	
	if(weapon == CSW_HEGRENADE){
		if(czas_rundy + 10 > floatround(halflife_time())){
			if(player_class[id]==Hunter){
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
	if( player_class[id] == Zmij ){
		set_renderchange(id)
		if(halflife_time()-player_naladowany[id] <= 5 + player_strength[id]/10){
			client_cmd(id,"weapon_knife")
			engclient_cmd(id,"weapon_knife")
			on_knife[id]=1	
		}
		set_renderchange(id)		
	}
	
	if(player_class[id] == Mnich){
		if(weapon != CSW_KNIFE && weapon != CSW_C4 && weapon != CSW_HEGRENADE && weapon != CSW_FLASHBANG && weapon != CSW_SMOKEGRENADE && weapon != 0) 
			cs_set_user_bpammo(id, weapon, 90)
	}
	
	if(isevent){
		if(weapon == CSW_C4) 
			engclient_cmd(id, "drop");
	}

	
	if ((weapon != CSW_C4 ) && !on_knife[id] && (player_class[id] == Ninja|| player_b_furia[id] > 0  || (player_b_tarczaograon[id] == 1 && czas_itemu[id]>(floatround(halflife_time())-1)) || player_class[id] == Orc || player_monster[id]>0))
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

	if (is_user_connected(id))
	{
		if(on_knife[id]){
			if(player_monster[id] > 0 || (isevent && isevent_team!=id && get_user_team(id) == get_user_team(isevent_team)))	
			{
				entity_set_string(id, EV_SZ_viewmodel, MON_VIEW)   				
			}
			else if(player_katana[id]  == 1)	
			{
				entity_set_string(id, EV_SZ_viewmodel, KAPLAN_VIEW)   
			}
			else if(player_miecz[id] == 1)
			{
				entity_set_string(id, EV_SZ_viewmodel, MAGIC_VIEW)   
			}
			else if(player_sword[id] == 1)
			{
				entity_set_string(id, EV_SZ_viewmodel, SWORD_VIEW)  
				entity_set_string(id, EV_SZ_weaponmodel, SWORD_PLAYER)  				
			}
			else if(player_sword[id] == 0)
			{			
				entity_set_string(id, EV_SZ_weaponmodel, KNIFE_PLAYER)  
				
				if(player_class[id]==Paladyn){
					entity_set_string(id, EV_SZ_viewmodel, PAL_VIEW)  
				}
				else if(player_class[id]==lelf || player_class[id]==szelf){
					entity_set_string(id, EV_SZ_viewmodel, ELF_VIEW)  
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
				else if(player_class[id]==Archeolog){
					entity_set_string(id, EV_SZ_viewmodel, ARCHEOLOG_VIEW)  
				}
				else if(player_class[id]==Wilk){
					entity_set_string(id, EV_SZ_viewmodel, WILK_VIEW)  
				}
				else if(player_class[id]==Magic){
					entity_set_string(id, EV_SZ_viewmodel, MAGIC_VIEW)  
				}
				else if(player_class[id]==Harpia){
					entity_set_string(id, EV_SZ_viewmodel, HARPIA_VIEW)  
				}
				else if(player_class[id]==Kaplan || player_class[id]==Mnich){
					entity_set_string(id, EV_SZ_viewmodel, KAPLAN_VIEW)  
				}
				else if(player_class[id]==Orc){
					entity_set_string(id, EV_SZ_viewmodel, ORC_VIEW)  
				}
				else if(player_class[id]==Mag ||player_class[id]==MagW ||player_class[id]==MagP ||player_class[id]==MagO ||player_class[id]==MagZ ||player_class[id]==Arcymag){
					entity_set_string(id, EV_SZ_viewmodel, MAG_VIEW)  
				}
				else if(player_class[id]==Nekromanta ||player_class[id]==Witch){
					entity_set_string(id, EV_SZ_viewmodel, NECRO_VIEW)  
				}else{
					entity_set_string(id, EV_SZ_viewmodel, KNIFE_VIEW)  
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
		
		if(player_glod[id] >0) g_haskit[id] = true
		//if(player_class[id] ==  Witch) g_haskit[id] = true
		if(player_class[id] == Nekromanta ) g_haskit[id] = true
		
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
		if(super==1 ){
			if ((player_intelligence[id]+player_strength[id]+player_agility[id]+player_dextery[id])>((player_lvl[id]-200)*2)&& (player_lvl[id] >250)&& (player_lvl[id] < 500)&& player_staty[id]==0) reset_skill(id)
			else if ((player_intelligence[id]+player_strength[id]+player_agility[id]+player_dextery[id])>((player_lvl[id]-400)*2)&& (player_lvl[id] >500)&& (player_lvl[id] < 750)&& player_staty[id]==0) reset_skill(id)
			else if ((player_intelligence[id]+player_strength[id]+player_agility[id]+player_dextery[id])>((player_lvl[id]-600)*2)&& (player_lvl[id] >750)&& (player_lvl[id] < 1001)&& player_staty[id]==0) reset_skill(id)
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
		
		if (player_b_blink[id] > 0)
			player_b_blink[id] = 1
			
		if(player_b_blink2[id]>0) player_b_blink2[id]=1
		if(player_b_blink3[id]>0) player_b_blink3[id]=1
		if(player_b_blink4[id]>0) player_b_blink4[id]=1
			
		if (player_b_blink_sec[id] > 0)
			player_b_blink_sec[id] = 1
			
		if (player_b_blink_arc[id] > 0)
			player_b_blink_arc[id] = 1
		
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
		award_kill(kid,vid)
		add_barbarian_bonus(kid)
		if (player_class[kid] == Barbarzynca || player_refill[kid]>0) refill_ammo(kid, 1)
		
		set_renderchange(kid)
		//savexpcom(vid)
	}
}

public DeathMsg(id)
{
	new weaponname[20]
	new kid = read_data(1)
	new vid = read_data(2)
	new headshot = read_data(3)
	if(vid == ofiara_zabojca[0] && kid == ofiara_zabojca[1] && delay_deathmsg > get_gametime()) return PLUGIN_CONTINUE;
	ofiara_zabojca[0] = vid;
	ofiara_zabojca[1] = kid;
	delay_deathmsg = get_gametime()+0.2;
	read_data(4,weaponname,31)
	if(kid < 1) kid = last_attacker[vid]
	if(is_user_connected(kid))cs_set_user_money(kid,cs_get_user_money(kid)-300)
		
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
		award_kill(kid,vid)		
		
		change_frags(kid, vid, 1)
		
		set_renderchange(kid)
		if(player_class[kid]==Kaplan && headshot > 0)
		{
			new tim = 6 + player_intelligence[kid] / 40
			player_naladowany2[kid]=floatround(halflife_time() + tim/2)
			show_hudmessage(kid, "Twoje HS przez %i sec sa silniejsze i cie lecza", tim/2) 
			write_hud(kid)
		}
		//savexpcom(vid)
	}
	last_attacker[vid] = 0
	return PLUGIN_CONTINUE;
}
public KnockDrzewiec(data[])
{
	KnockDrzewiec2(data[0], data[1])
}

public KnockDrzewiec2(id, attacker_id)
{
	static origin1[3]
	get_user_origin(attacker_id,origin1)
	
	static origin2[3]
	get_user_origin(id,origin2)
	
	new Float:velocity[3]
	velocity[0] = (float(origin1[0]) - float(origin2[0])) * 1.5 
	velocity[1] = (float(origin1[1]) - float(origin2[1])) * 1.5 
	velocity[2] = (float(origin1[2]) - float(origin2[2])) * 1.5 
	
	new Float:aOrigin[3]
	pev(attacker_id,pev_origin,aOrigin)
	new Float:bOrigin[3]
	pev(id,pev_origin,bOrigin)
						
	if(get_distance_f(aOrigin,bOrigin) < 500.0){					
	
		if(velocity[0]>1) velocity[0] +2
		if(velocity[1]>1) velocity[1] +2
		if(velocity[2]>1) velocity[2] +2
		if(velocity[0]<1) velocity[0] -2
		if(velocity[1]<1) velocity[1] -2
		if(velocity[2]<1) velocity[2] -2
	}
	if(get_distance_f(aOrigin,bOrigin) < 250.0){					
	
		if(velocity[0]>1) velocity[0] +3
		if(velocity[1]>1) velocity[1] +3
		if(velocity[2]>1) velocity[2] +3
		if(velocity[0]<1) velocity[0] -3
		if(velocity[1]<1) velocity[1] -3
		if(velocity[2]<1) velocity[2] -3
	}
	
	set_pev(id,pev_velocity,velocity)
}

public Damage(id)
{
	if (is_user_connected(id))
	{
		new weapon
		new bodypart
		new attacker_id = get_user_attacker(id,weapon,bodypart)
		if(attacker_id < 0 || attacker_id > 32) return;
		new damage = read_data(2)
		new damageRem = damage
		player_lastDmgTime[id]=halflife_time();
		player_lastDmgTime[attacker_id]=halflife_time();

		if(attacker_id!=0 && attacker_id != id && get_user_team(id)!=get_user_team(attacker_id))
		{
			if (is_user_connected(attacker_id))
			{
				inbattle[id] = 1
				inbattle[attacker_id] = 1
				if (is_user_alive(id) && get_user_health(id) > 10) last_attacker[id] = attacker_id;
				add_bonus_necromancer(attacker_id,id)
				if(player_dremora[id] > 0) 
				{
					Display_Fade(attacker_id,2600,2600,0,0,255,0,50)
					efekt_slow_enta(attacker_id, player_dremora[id])
				}
				if(player_dremora_lekka[id] > 0) 
				{
					Display_Fade(attacker_id,2600,2600,0,0,0,255,50)
					efekt_slow_lodu(attacker_id, player_dremora_lekka[id])
				}
				
				if(player_class[attacker_id] == Ninja && player_edison[attacker_id] == 0)
				{
					if(damage > 75 || bodypart == HIT_HEAD )
					{
						new ddd= 0
						if(damage > 100) ddd += damage / 10 * get_maxhp(id) / 100
						else if(bodypart == HIT_HEAD) ddd += 100 / 10 * get_maxhp(id) / 100
						
						change_health(id, -(ddd),attacker_id,"world") 
					}
				}
				if(player_class[id] == Ninja && player_edison[id] == 0)
				{
					set_user_rendering(id,kRenderFxGlowShell,flashlight_r,flashlight_g,flashlight_b,kRenderNormal,4)	
					remove_task(TASK_FLASH_LIGHT+id);
					Display_Icon(id ,ICON_SHOW ,"stopwatch" ,200,0,200)
					set_task(1.0, "un_rander",TASK_FLASH_LIGHT+id)
				}
				
				if(weapon != CSW_HEGRENADE  && weapon != CSW_KNIFE  ){
					// itemy
					if(golden_bulet[attacker_id]>0){
						golden_bulet[attacker_id]--
						write_hud(id)
					}
					if(player_lodowe_pociski[attacker_id]>0){
						if(random_num(0,player_lodowe_pociski[attacker_id])==0){
							Display_Fade(id,2600,2600,0,0,0,255,50)
							efekt_slow_lodu(id, 5)
						}
					}
					if(player_b_m3_knock[attacker_id] > 0 && weapon == CSW_M3 && player_class[attacker_id] != Orc && player_class[attacker_id] != Ninja){
						new Float:vec[3];
						new Float:oldvelo[3];
						get_user_velocity(id, oldvelo);
						create_velocity_vector(id , attacker_id , vec);
						vec[0] += oldvelo[0];
						vec[1] += oldvelo[1];
						set_user_velocity(id , vec);
					}
					if(player_mrok[id] >0) set_renderchange(id)
					if(player_mrok[attacker_id] >0) set_renderchange(attacker_id)
					if(player_pelnia[attacker_id] > 0){
						player_speedbonus[attacker_id] += 10
						set_speedchange(attacker_id)
					}						
					if(player_entowe_pociski[attacker_id]>0 ){
						if(random_num(0,player_entowe_pociski[attacker_id])==0){
							Display_Fade(id,2600,2600,0,0,255,0,50)
							efekt_slow_enta(id, 5)
						}		
					}								
					if(player_pociski_powietrza[attacker_id]>0 && get_user_team(id)!=get_user_team(attacker_id)){
						if(random_num(0,player_pociski_powietrza[attacker_id])==0)  DropWeapon(id)
					}
					
					//klasy
					if(player_class[attacker_id]==Ninja || player_class[attacker_id] == Orc ){
						DropWeapon(attacker_id)
					}
					else if( player_class[attacker_id] == MagZ){
						if(random_num(0,20)==0){
							Display_Fade(id,2600,2600,0,0,255,0,50)
							efekt_slow_enta(id, 5)
						}
					}
					else if(player_class[attacker_id]==Zabojca){
						invisible_cast[attacker_id]=0
						set_renderchange(attacker_id)
					}
				} 	
				
				if(player_dziewica[id]>0 && player_dziewica_using[id]==1){
					change_health(attacker_id,-player_dziewica[id]*damage/100,id,"world")				
				}else if(player_dziewica_hp[id]>0 && player_dziewica_using[id]==1){
					change_health(attacker_id,-player_dziewica_hp[id]*damage/100,id,"world")				
				}else if(player_dziewica_aut[id]>0){
					change_health(attacker_id,-player_dziewica_aut[id]*damage/100,id,"world")				
				}
				//klasy
				if(player_class[attacker_id]==MagO){
					if(player_class[id]!=MagW){ 
						new red = dexteryDamRedPerc[id]						
						new d = player_intelligence[attacker_id]/15 - player_dextery[id]/50 + get_maxhp(id)*3/100
						d = d - (d * red /100)
						Effect_Ignite(id,attacker_id,1 +d)
					}
				}
				else if(player_class[attacker_id]==Zmij){
					new m = get_maxhp(id)
					if(player_class[id] == Orc) m=m/10
					if(weapon == CSW_TMP){
						new pr = 6 - player_dextery[id] / 25 + player_intelligence[attacker_id]/100
						if(pr < 0) pr = 0
						new demejcz = m * pr / 200 + pr
						if(player_strength[attacker_id]>10 ) demejcz = demejcz - player_strength[attacker_id]/2
						demejcz = demejcz + m * 1 / 100
						if(demejcz < 1) demejcz = 1
						change_health(id,-demejcz  ,attacker_id,"world")
					}else if(weapon == CSW_KNIFE || (halflife_time()-player_naladowany[attacker_id] <= 5 + player_strength[attacker_id]/10)){
						new pr = 25- player_dextery[id] / 10 + player_intelligence[attacker_id]/5						
						if(pr < 1) pr = 1
						new demejcz =  m* pr / 100
						if(player_strength[attacker_id]>10 ) demejcz = demejcz - player_strength[attacker_id]/4
						demejcz = demejcz + m * 1 / 100
						if(demejcz < 1) demejcz = 1 
						Effect_waz(id,attacker_id, demejcz)
					}
				}
				else if(player_class[attacker_id]==Drzewiec){
					if(weapon == CSW_KNIFE ){
						new demejcz = get_user_health(id) * 10 / 100
						new red = dexteryDamRedPerc[id]
						demejcz = demejcz - (demejcz * red /100)
						if(demejcz>0) change_health(id,-demejcz-50,attacker_id,"world")
					}
					else if(weapon == CSW_M3){
						new demejcz = get_user_health(id) * 4 / 100
						new red = dexteryDamRedPerc[id]
						demejcz = demejcz - (demejcz * red /100) + player_intelligence[attacker_id]/20 + 5
						if(demejcz>0) change_health(id,-demejcz,attacker_id,"world")
						if(player_lvl[attacker_id] > prorasa) drzewiec_obsz(attacker_id, 90, 1)
						
						
						if(!(player_b_nieust2[id] > 0 && get_user_health(id) < player_b_nieust2[id]) && player_b_nieust[id] == 0 && player_b_szarza_time[id] < floatround(halflife_time())){
							if(player_naladowany[attacker_id] == 0){
								
								new Float:vec[3];
								new Float:oldvelo[3];
								get_user_velocity(id, oldvelo);
								create_velocity_vector(id , attacker_id , vec);
								vec[0] += oldvelo[0]*2// + (oldvelo[0]/oldvelo[0]*100);
								vec[1] += oldvelo[1]*2// + (oldvelo[1]/oldvelo[1]*100);
								set_user_velocity(id , vec);	
							}else{
								/*
								new Float:vec[3];
								new Float:oldvelo[3];
								get_user_velocity(id, oldvelo);
								create_velocity_vector(id , attacker_id , vec);
								vec[0] -= oldvelo[0]*10;
								vec[1] -= oldvelo[1]*10;
								set_user_velocity(id , vec);
								*/
								KnockDrzewiec2(id, attacker_id)
								new data[2]
								data[0] = id
								data[1] = attacker_id
								
								set_task ( 0.1, "KnockDrzewiec", 666, data, 2)
								set_task ( 0.2, "KnockDrzewiec", 666, data, 2)
								set_task ( 0.3, "KnockDrzewiec", 666, data, 2)
								set_task ( 0.4, "KnockDrzewiec", 666, data, 2)
								set_task ( 0.5, "KnockDrzewiec", 666, data, 2)
							}	
						}
					}else{
						cs_set_user_money(attacker_id,cs_get_user_money(attacker_id)-25)
						if(cs_get_user_money(attacker_id) < 500){
							DropWeapon(attacker_id)
							change_health(id,damage,attacker_id,"world")
							damage = 0
						}
					}
					
				}
				else if(player_class[attacker_id]==Stalker ){
					if(player_nal[attacker_id]>0){
						player_nal[attacker_id]--
						Display_Fade(id,2600,2600,0,0,255,0,50)
						efekt_slow_enta(id, 5)
					}
					/*
					if(bodypart == HIT_HEAD && (halflife_time() - 2.0 > player_timed_inv[attacker_id])){
						player_timed_inv[attacker_id] = halflife_time() + 1.0
						set_renderchange(attacker_id);
						set_task(1.0, "set_renderchange", attacker_id)
						set_task(1.2, "set_renderchange", attacker_id)
					}
					if(weapon == CSW_XM1014){
						new demejcz = get_maxhp(id) * (3 + player_intelligence[attacker_id]/50) / 100 - player_dextery[id] / 50
						if(demejcz > 0) change_health(id,-demejcz,attacker_id,"world")
					}
					*/							
				}
				else if(player_class[attacker_id]==Arcymag){
					if(player_class[id]!=MagW) Effect_Ignite(id,attacker_id,1 + player_intelligence[attacker_id]/50 - player_dextery[id]/50)
				}				
				else if(player_class[attacker_id]==szelf){
					if(weapon == CSW_GLOCK18 || weapon == CSW_USP || weapon == CSW_P228 || weapon == CSW_DEAGLE || weapon == CSW_ELITE || weapon == CSW_FIVESEVEN){
						efekt_slow_lodu(id, 3)
					}
				}
				else if(player_class[attacker_id] == Archeolog){
					new gold = cs_get_user_money(id)
					new plusDmg = damage/5
					if(gold <5 && plusDmg > 1){						
						change_health(id,-plusDmg,attacker_id,"world") 
					}					
				}
				else if(player_class[attacker_id] == Kaplan){
					if(halflife_time() < player_naladowany2[attacker_id]){
						if(bodypart == HIT_HEAD && weapon!= CSW_KNIFE && weapon != CSW_HEGRENADE){
							change_health(attacker_id,10,attacker_id,"world")	
							change_health(id,-damage,attacker_id,"world")
						}
					}
				}else if(player_class[attacker_id] == Witch){
					if(player_naladowany[attacker_id]==Zmij && bodypart == HIT_HEAD){
						Effect_waz(id,attacker_id, player_naladowany2[attacker_id] *10)
					}
					if(player_naladowany[attacker_id]==Zabojca && bodypart == HIT_HEAD){
						player_timed_inv[attacker_id] =(player_naladowany2[attacker_id] *0.5)+ halflife_time()
					}
					else if(player_naladowany[attacker_id]==Ninja){
						if(weapon==CSW_KNIFE){
							change_health(id,-100 * player_naladowany2[attacker_id],attacker_id,"world")
						}
					}
					else if(player_naladowany[attacker_id]==Archeolog){						
						new kasa = 10 + 200*player_naladowany2[attacker_id]
						if(kasa>1500) kasa = 1500 
						if(cs_get_user_money(id)-kasa > 0){
							cs_set_user_money(id,cs_get_user_money(id)-kasa)
							cs_set_user_money(attacker_id,cs_get_user_money(attacker_id)+kasa)
						} else{
							kasa = cs_get_user_money(id)
							cs_set_user_money(attacker_id,cs_get_user_money(attacker_id)+kasa)
							cs_set_user_money(id,0)
						}
					}
					else if(player_naladowany[attacker_id]==Mag){
						new r= 8 - player_naladowany2[attacker_id]/2
						if(r<2) r=2
						if(random_num(0, r) == 0)
						{
							new Float:origin[3]
							pev(id,pev_origin,origin)
							Explode_OriginFB(attacker_id,origin,player_naladowany2[attacker_id]*25,150)
						}
					}
					else if(player_naladowany[attacker_id]==MagO){
						if(player_class[id]!=MagW){ 
							new red = dexteryDamRedPerc[id]						
							new d = player_naladowany2[attacker_id] - player_dextery[id]/50 + get_maxhp(id)*1/200
							d = d - (d * red /100)
							Effect_Ignite(id,attacker_id,1 +d)
						}
					}
					else if(player_naladowany[attacker_id]==MagW){
						new r= 25 - player_naladowany2[attacker_id]
						if(r<2) r=2
						if(random_num(0, r) == 0){
							efekt_slow_lodu(id, 5)
							refill_ammo(attacker_id, 0)
						}
					}
					else if(player_naladowany[attacker_id]==MagZ){
						new r= 8 - player_naladowany2[attacker_id]/2
						if(r<2) r=2
						if(random_num(0, r) == 0)
							efekt_slow_enta(id, 5)
					}
					else if(player_naladowany[attacker_id]==MagP){
						new r= 15- player_naladowany2[attacker_id]/2
						if(r<2) r=2
						if(random_num(0, r) == 0)
							DropWeapon(id)							
					}
					else if(player_naladowany[attacker_id]==Magic){
						new r= 9 - player_naladowany2[attacker_id]/2
						if(r<2) r=2
						if(random_num(0, r) == 0){
							fired[attacker_id]=0
							item_fireball(attacker_id)
						}
					}
					else if(player_naladowany[attacker_id]==Arcymag){
						new r= 35 - player_naladowany2[attacker_id] * 2
						if(r<5) r=5
						if(random_num(0, r) == 0)
						{
							item_fireball(attacker_id)
							DropWeapon(id)
							efekt_slow_lodu(id, 5)
							efekt_slow_enta(id, 5)
							if(player_class[id]!=MagW){ 
								new red = dexteryDamRedPerc[id]						
								new d = player_naladowany2[attacker_id] - player_dextery[id]/50 + get_maxhp(id)*1/100
								d = d - (d * red /100)
								Effect_Ignite(id,attacker_id,1 +d)
							}
							new Float:origin[3]
							pev(id,pev_origin,origin)
							Explode_OriginFB(attacker_id,origin,player_naladowany2[attacker_id]*25,150)
						}
					}
					else if(player_naladowany[attacker_id]==Wampir){
						new r= player_naladowany2[attacker_id] * 3
						vampire(id,r,attacker_id)
					}
					else if(player_naladowany[attacker_id]==Hunter){
						new r= 10 - player_naladowany2[attacker_id]/2
						if(r<2) r=2
						if(random_num(0, r) == 0) command_arrow(attacker_id) 
					}else if(player_naladowany[attacker_id]==Stalker)
					{
						new Float:aOrigin[3]
						pev(attacker_id,pev_origin,aOrigin)
						new Float:bOrigin[3]
						pev(id,pev_origin,bOrigin)
						
						if(get_distance_f(aOrigin,bOrigin) < 150.0)
						{
							change_health(id,-damage/4,attacker_id,"world")
						}
					}
					
				}
				
				if(player_las[id] > 0){
					Display_Fade(attacker_id,2600,2600,0,0,255,0,50)
					efekt_slow_enta(attacker_id, player_las[id])
				}
				
				if(player_class[id] == Orc){
					player_b_udreka_sec[id]=floatround(halflife_time() + 1)
					Display_Icon(id ,ICON_SHOW ,"dmg_chem", 200,50,50)
					if(weapon == CSW_KNIFE) 
					{
						player_b_udreka_sec[attacker_id]=floatround(halflife_time() + 5)
						Display_Icon(attacker_id ,ICON_SHOW ,"dmg_chem", 200,50,50)
					}
				}
				else if(player_class[id] == Drzewiec )
				{
					new Float:aOrigin[3]
					pev(attacker_id,pev_origin,aOrigin)
					new Float:bOrigin[3]
					pev(id,pev_origin,bOrigin)
						
					new damh = damage
					damh = damh - damh/25
					if(get_distance_f(aOrigin,bOrigin) < 800.0)
					{
						damh = damh - damh/10
					}
					if(get_distance_f(aOrigin,bOrigin) < 600.0)
					{
						damh = damh - damh/5
					}
					if(get_distance_f(aOrigin,bOrigin) < 400.0)
					{
						damh = damh - damh/5
					}
					if(get_distance_f(aOrigin,bOrigin) < 200.0)
					{
						damh = 0
					}
					if(damh<0) damh = 0
					change_health(id,damh,id,"world")
					damage = damage- damh
				}
				
				if(player_class[id] == Witch && player_naladowany[id] == Drzewiec)
				{
					new Float:aOrigin[3]
					pev(attacker_id,pev_origin,aOrigin)
					new Float:bOrigin[3]
					pev(id,pev_origin,bOrigin)
					new dziel = player_naladowany2[id]/2 + 2
					new damh = damage
					damh = damh - damh/dziel
					if(get_distance_f(aOrigin,bOrigin) < 900.0)
					{
						damh = damh - damh/dziel
					}
					if(get_distance_f(aOrigin,bOrigin) < 750.0)
					{
						damh = damh - damh/(dziel/2)
					}
					if(get_distance_f(aOrigin,bOrigin) < 500.0)
					{
						damh = damh - damh/(dziel/2)
					}
					if(get_distance_f(aOrigin,bOrigin) < 250.0)
					{
						damh = 0
					}
					if(damh<0) damh = 0
					change_health(id,damh,id,"world")
					damage = damage- damh
				}
				
				//evo
				if(player_lvl[attacker_id]>prorasa){
					if(player_class[attacker_id]==Nekromanta){
						if(player_naladowany[attacker_id] >= 5){
							player_b_udreka_ofiara[id]=floatround(halflife_time() + 1)
							Display_Icon(id ,ICON_SHOW ,"dmg_chem", 200,0,0)
						}
					}
					else if(player_class[attacker_id] == Zabojca ){
						if(halflife_time() < bowdelay[attacker_id] &&random_num(0,4)==0){
							DropWeapon(id)
							bowdelay[attacker_id] = 0.0
						}
					}
					else if(player_class[attacker_id]==MagP){
						if(random_num(0,30)==0)  DropWeapon(id)
					}
					else if(player_class[attacker_id] == Archeolog)
					{
						if(cs_get_user_money(id) < 100) vampire(id,5,attacker_id)						
					}					
					else if(player_class[attacker_id] == szelf){
						if(ofiara_totem_enta[id] > floatround(halflife_time()) || ofiara_totem_lodu[id] > floatround(halflife_time())){
							player_timed_speed[attacker_id] = halflife_time() + 5.3
							set_speedchange(attacker_id)
							set_task(5.5, "set_speedchange",attacker_id)
							change_health(id,-5,attacker_id,"world") 
						}
					}
					else if(player_class[attacker_id] == MagW){
						if(ofiara_totem_enta[id] > floatround(halflife_time()) || ofiara_totem_lodu[id] > floatround(halflife_time())){
						
							client_cmd(attacker_id, "mp3 play sound/heartbeat-01.mp3") 
							player_b_szarza_time[attacker_id] = floatround(halflife_time()) + 2
							un_rander(TASK_FLASH_LIGHT+attacker_id)
							RemoveFlag(attacker_id,Flag_Dazed)
							RemoveFlag(attacker_id,Flag_Ignite)
							RemoveFlag(attacker_id,Flag_truc)
							ofiara_totem_enta[attacker_id] = 0
							ofiara_totem_lodu[attacker_id] = 0
							new svIndex[32] 
							num_to_str(attacker_id,svIndex,32)
							Display_Icon(attacker_id ,ICON_SHOW ,"dmg_cold" ,0,0,255)
							set_task(0.1,"task_koniec",0,svIndex,32) 	
							Display_Icon(attacker_id ,ICON_SHOW ,"dmg_cold" ,0,255,0)
							set_task(0.1,"task_koniec",0,svIndex,32) 	
							set_speedchange(attacker_id)
							set_renderchange(attacker_id)		
						}
					}else if(player_class[attacker_id]==Stalker)
					{
						new Float:aOrigin[3]
						pev(attacker_id,pev_origin,aOrigin)
						new Float:bOrigin[3]
						pev(id,pev_origin,bOrigin)
						
						if(get_distance_f(aOrigin,bOrigin) < 150.0)
						{
							change_health(id,-damage/20,attacker_id,"world")
						}
					}
				}
	

				
				add_damage_bonus(id,damage,attacker_id)
				add_vampire_bonus(id,damage,attacker_id)
				add_grenade_bonus(id,attacker_id,weapon)
				add_theif_bonus(id,attacker_id)
				add_bonus_blind(id,attacker_id,weapon,damage)
				if(player_class[attacker_id] != Mnich) add_bonus_redirect(id,damage)
				add_bonus_scoutdamage(attacker_id,id,weapon)	
				add_bonus_m3(attacker_id,id,weapon)	
				add_bonus_darksteel(attacker_id,id,damage)
				add_bonus_illusion(attacker_id,id,weapon)
				item_take_damage(id,damage)
				if(player_timed_dmg_time[attacker_id]>halflife_time())
				{
					change_health(id,-50,attacker_id,"world") 
				}
				
				if(player_b_udreka[attacker_id]>0){
					player_b_udreka_ofiara[id]=floatround(halflife_time() + player_b_udreka[attacker_id])
					Display_Icon(id ,ICON_SHOW ,"dmg_chem", 200,0,0)
				}
				if(player_smocze[attacker_id]>0){
					change_health(attacker_id,-15,id,"world")
					change_health(id,-player_smocze[attacker_id],attacker_id,"world")
					
				}
				if(player_sword[attacker_id] == 1 && weapon==CSW_KNIFE ){
					change_health(id,-35,attacker_id,"world")
				}
				if(player_class[attacker_id] == Orc){
					change_health(id,-50,attacker_id,"world") 
				}


				if(player_nomoney_slow[attacker_id] > 0){
					if(cs_get_user_money(id) < 100)  efekt_slow_lodu(id, player_nomoney_slow[attacker_id])
				}
				if(player_money_damage[attacker_id] > 0){
					new d = cs_get_user_money(attacker_id) / 5000 * player_money_damage[attacker_id]
					change_health(id,-d,attacker_id,"world")
				}
				if(once_double_dmg[attacker_id] >0){
					new d = damage
					if(d<0) d = -d
					change_health(id,-d,attacker_id,"world")
					once_double_dmg[attacker_id]--
					if(once_double_dmg[attacker_id] < 1) Display_Icon(id ,ICON_HIDE ,"smallskull"  ,200,0,0)
				}
				if(player_head_froze[attacker_id] >0){
					if(bodypart == HIT_HEAD) efekt_slow_lodu(id, player_head_froze[attacker_id])
				}
				if(player_head_dmg[attacker_id] >0){
					if(bodypart == HIT_HEAD) change_health(id,-damage * (player_head_dmg[attacker_id]-1),attacker_id,"world")
				}	
				

				if(player_knifebonus[attacker_id] > 0 && (weapon==CSW_KNIFE || player_class[attacker_id] == Orc || player_class[attacker_id] == Ninja || player_b_furia[attacker_id] > 0) ){
					change_health(id,-player_knifebonus[attacker_id],attacker_id,"world")
				}
				if(player_knifebonus_p[attacker_id] > 0 && (weapon==CSW_KNIFE || player_class[attacker_id] == Orc || player_class[attacker_id] == Ninja || player_b_furia[attacker_id] > 0) ){
					new flags = pev(attacker_id,pev_flags) 
					if(!(flags & FL_ONGROUND)) 
					{ 
						change_health(id,-player_knifebonus_p[attacker_id],attacker_id,"world")
					}
				}
				if(player_akrobata[attacker_id] > 0){
					new flags = pev(attacker_id,pev_flags) 
					if(!(flags & FL_ONGROUND)) 
					{ 
						change_health(id,-player_akrobata[attacker_id],attacker_id,"world")
					}
				}
				if(player_lodu_p[attacker_id] > 0 && (weapon==CSW_KNIFE || player_class[attacker_id] == Orc || player_class[attacker_id] == Ninja || player_b_furia[attacker_id] > 0) ){
					new flags = pev(attacker_id,pev_flags) 
					if(!(flags & FL_ONGROUND)) 
					{ 
						efekt_slow_lodu(id, player_lodu_p[attacker_id] )
					}
					
				}
				if(player_mrocznibonus[attacker_id] > 0 && (player_class[id]==Nekromanta || player_class[id]==Witch || player_class[id]==Wampir || player_class[id]==Harpia || player_class[id]==Orc || player_class[id]==aniol || player_class[id]==Wilk)){
					change_health(id,-player_mrocznibonus[attacker_id],attacker_id,"world")
					Display_Fade(id,2600,2600,0,0,0,255,10)
				}
				if((player_ludziebonus[attacker_id] > 0)&& (player_class[id]==Mnich || player_class[id]==Paladyn || player_class[id]==Zabojca || player_class[id]==Barbarzynca || player_class[id]==Ninja || player_class[id]==Archeolog || player_class[id]==Kaplan)){
					if( player_ludziebonus[attacker_id] > 0 )change_health(id,-player_ludziebonus[attacker_id],attacker_id,"world")
					Display_Fade(id,2600,2600,0,255,0,0,10)
				}				
				if (HasFlag(attacker_id,Flag_Ignite) && player_class[attacker_id]!=MagO){
					RemoveFlag(attacker_id,Flag_Ignite)
				}				
				if((HasFlag(id,Flag_Illusion) || HasFlag(id,Flag_Teamshield))&& get_user_health(id) - damage > 0)
				{
					new weaponname[32]; get_weaponname( weapon, weaponname, 31 ); replace(weaponname, 31, "weapon_", "")
					UTIL_Kill(attacker_id,id,weaponname)
				}				
				if (HasFlag(id,Flag_Moneyshield)  && player_blogo[attacker_id] == 0 )
				{
					change_health(id,damage/2,0,"")
					damage = damage/2
				}		
				if(player_b_tarczaograon[id] == 1){
					change_health(id,damage,0,"")
					damage = 0
				}
				//Add the agility damage reduction, around 45% the curve flattens
				if (damage > 0 && player_agility[id] > 0 && player_blogo[attacker_id] == 0 )
				{	
					new heal = floatround(player_damreduction[id]*damage)
					if(KlasyZlicz[player_class[id]]==1) heal += 1
					damage = damage - heal
					if (is_user_alive(id)) change_health(id,heal,0,"")
				}
				if (player_class[attacker_id] == Mnich)
				{	
					new l = player_lvl[attacker_id] 
					if(l>80) l= 80
					new am = 20 + l/2
					new heal = (am *damage)/100
					damage = damage - heal
					if (is_user_alive(id)) change_health(id,heal,0,"")
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
				if(player_lvl[id]>prorasa){
					if(player_class[id] == MagO && player_class[attacker_id]!=MagW && random_num(0,2)==0){
						if(! HasFlag(attacker_id, Flag_Ignite)){
							new dem = 1 + player_intelligence[attacker_id]/200 - player_dextery[id]/25 + get_maxhp(id)*1/200
							if(dem < 1) dem = 1
							Effect_Ignite(attacker_id,id,dem)	
						}
					}
					if(player_class[id]==MagZ && get_user_health(id) < 50){
						add_stomp_magz(id)
					}
				}
				if(player_bitewnyszal_time[id]>floatround(halflife_time())){
					new myd = read_data(2)
					if(get_user_health(id)-myd > 1){
						fm_set_user_health(id,get_user_health(id)-myd)
					}else{
						fm_set_user_health(id,1)
					}
				}								
				if(player_tarczapowietrza[id]>0  && player_blogo[attacker_id] == 0 ){
					player_tarczapowietrza[id] = player_tarczapowietrza[id] - damage
					change_health(id,damage,0,"")
					damage = 0;
					if(player_tarczapowietrza[id]<1 && player_class[id]==MagP) item_aard(id)
					write_hud(id)
				}
				new ish = player_undershield[id]
				if(ish>0 && is_user_alive(ish)){
					new perDmg = damage * player_supshield[ish] / 100
					change_health(id,perDmg,0,"")
					if (player_class[ish] == Mnich)
					{
						new heal = floatround(0.20*perDmg)
						if (is_user_alive(ish)) change_health(ish,heal,0,"")
						perDmg = perDmg - heal
						if(player_agility[ish]> 50){
							new ag = player_agility[ish] - 50
							if(ag>200) ag=200
							new h2 = perDmg * ag / 300
							if (is_user_alive(ish)) change_health(ish,h2,0,"")
							perDmg = perDmg - h2
						}
					}
					change_health(ish,-perDmg,attacker_id,"")
					damage = damage - perDmg
				}
				if(get_user_team(id) != get_user_team(attacker_id) && damage > 0)
				{	
					change_health(id,-damage*player_DoubleDmg[id]/100,attacker_id,"world")
				}
				if(get_user_team(id) != get_user_team(attacker_id) && damage > 0)
				{				
					if(get_user_health(id) < damage) damage = get_user_health(id)
					dmg_exp(attacker_id,id,damage)	
					if(player_supshield[id]>0){
						if( damage<0) damage = -damage
						Give_Xp(id,damage)	
					}
				}				
				//showDMG
				if( print_dmg[id]<2){
					set_hudmessage(255, 0, 0, 0.45, 0.50, 2, 0.1, 4.0, 0.1, 0.1, -1)
					ShowSyncHudMsg(id, g_hudmsg2, "%i (%i)^n", -damage, -damageRem)
				}	
				if(is_user_connected(attacker_id))
				{
					if(fm_is_ent_visible(attacker_id,id) &&  print_dmg[attacker_id]<2)
					{
						set_hudmessage(0, 100, 200, -1.0, 0.55, 2, 0.1, 4.0, 0.02, 0.02, -1)
						ShowSyncHudMsg(attacker_id, g_hudmsg1, "%i (%i)^n", damage, damageRem)				
					}
				}
			}
		}
	}
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
	if(is_user_bot(id) || is_user_alive(id)==0 || !is_user_connected(id)) return PLUGIN_CONTINUE
	new clip,ammo
	new weapon = get_user_weapon(id,clip,ammo)
	new button2 = get_user_button(id);
	
	if (player_class[id] == Stalker){
		if((button2 & IN_DUCK)){
			if(was_ducking[id]==0){
				ducking_t[id] = floatround(halflife_time())
				CurWeapon(id)
				set_renderchange(id)
			}
			was_ducking[id] = 1
		} 
		else if(was_ducking[id] == 1) 
		{
			CurWeapon(id)
			set_renderchange(id)
		}
		
	}

	if(player_recoil[id]>0){
		if(random_num(0,player_recoil[id])==0){
			new Float:g_angle[3] = {0.0,0.0,0.0}
			set_pev(id,pev_punchangle,g_angle)
		}
	}
	
	if(((player_class[id]==Paladyn && weapon == CSW_KNIFE) || player_monster[id]>0 || player_blogo[id]>0)  && freeze_ended) 
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
                                
					new Float:va[3],Float:v[3] 
					entity_get_vector(id,EV_VEC_v_angle,va) 
					v[0]=floatcos(va[1]/180.0*M_PI)*560.0 
					v[1]=floatsin(va[1]/180.0*M_PI)*560.0 
					v[2]=300.0 
					entity_set_vector(id,EV_VEC_velocity,v) 
					write_hud(id)
					if(player_blogo[id]){
						timed_godmode[id] = halflife_time() + 0.4
						Display_Icon(id ,ICON_SHOW ,"suit_full" ,255,255,255)
					}
				} 
			} 
		} 
	}
	
	if(player_class[id]==Dzikuska && freeze_ended) 
	{ 
		if((button2 & IN_DUCK) && (button2 & IN_JUMP) && ((button2 & IN_MOVELEFT) || (button2 & IN_MOVERIGHT))) 
		{ 
			if(ofiara_totem_enta[id] > floatround(halflife_time())){
				set_hudmessage(255, 0, 0, -1.0, 0.01)
				show_hudmessage(id, "Jestes uziemiony")
			}else
			{ 
				if((bowdelay[id] + 0.1)< get_gametime())
				{
					bowdelay[id] = get_gametime()
					new war = 0
					new entlist[513]
					new flags = pev(id,pev_flags) 
					new numfound = find_sphere_class(id,"player",900.0 + player_intelligence[id],entlist,512)
					for (new i=0; i < numfound; i++)
					{		
						new pid = entlist[i]
						if(!is_user_connected(pid)) continue;
						if(!is_user_alive(pid)) continue;
						if(cs_get_user_team(id) == cs_get_user_team(pid)) continue;
						war = 1						
					}
					if(war==0)
					{
						set_hudmessage(255, 0, 0, -1.0, 0.01)
						show_hudmessage(id, "Brak przeciwnika")
					}
					else if(flags & FL_ONGROUND) 
					{ 
						set_pev ( id, pev_flags, flags-FL_ONGROUND ) 
						if(czas_rundy + 10 > floatround(halflife_time())){
							set_hudmessage(255, 0, 0, -1.0, 0.01)
							show_hudmessage(id, "Skilla mozesz uzywac 10 sek po starcie rundy")						
							return PLUGIN_HANDLED
						}
					
						new Float:va[3],Float:v[3] 
						entity_get_vector(id,EV_VEC_v_angle,va) 
						new Float: side = 0.0;
						if(button2 & IN_MOVELEFT) side = 90.0
						if(button2 & IN_MOVERIGHT) side = -90.0
						new Float: h = 150.0 + player_dextery[id]/4.0
						if(h > 220.0) h = 220.0
						
						v[0]=floatcos((va[1]+side)/180.0*M_PI)*560.0 
						v[1]=floatsin((va[1]+side)/180.0*M_PI)*560.0 
						v[2]=h
						entity_set_vector(id,EV_VEC_velocity,v) 
						write_hud(id)
					} 
				}
			} 
		} 
	}
	
	if(player_class[id]==Orc  && freeze_ended) 
	{ 
		if((button2 & IN_RELOAD)) 
		{ 
			if(player_naladowany[id] >= floatround(halflife_time())){					
				return PLUGIN_HANDLED
			}
			if(czas_rundy + 10 > floatround(halflife_time())){
				set_hudmessage(255, 0, 0, -1.0, 0.01)
				show_hudmessage(id, "Skilla mozesz uzywac 10 sek po starcie rundy")						
				return PLUGIN_HANDLED
			}
			if(ofiara_totem_enta[id] > floatround(halflife_time())){
				set_hudmessage(255, 0, 0, -1.0, 0.01)
				show_hudmessage(id, "Jestes uziemiony")
				return PLUGIN_HANDLED
			}else
			{ 
				OrcJump(id)
			} 
		} 
	}

	
	if(flashlight[id] && flashbattery[id] && (get_cvar_num("flashlight_custom")) && (player_class[id] == Mag || player_class[id] == MagO  || player_class[id] == MagZ || player_class[id] == MagW || player_class[id] == MagP || player_class[id] ==Arcymag)) {
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
		if ((get_user_team(id)!=get_user_team(index1)) && (index1!=0))
		{
			if ((index1!=54) && (is_user_connected(index1))){ 
				if(player_b_szarza_time[id] > floatround(halflife_time())){}
				else
				{
					if(player_b_nieust[index1] ==100){ return PLUGIN_CONTINUE; }
					if(player_b_nieust2[index1] > 0 && get_user_health(index1) < player_b_nieust2[index1]) {
						return PLUGIN_CONTINUE;
					}
					set_user_rendering(index1,kRenderFxGlowShell,flashlight_r,flashlight_g,flashlight_b,kRenderNormal,4)	
					remove_task(TASK_FLASH_LIGHT+index1);
					Display_Icon(index1 ,ICON_SHOW ,"stopwatch" ,200,0,200)
					set_task(7.5, "un_rander",TASK_FLASH_LIGHT+index1)
				}
			}
		}
	}

	if (((player_b_silent[id] > 0) || (player_class[id] == Zabojca) ||(player_class[id] == Wilk && player_naladowany[id] ==1 )) && is_user_alive(id)) 
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

	
	if (player_b_jumpx[id] > 0 || player_class[id]==aniol || player_class[id]==Stalker) Prethink_Doublejump(id)
	if (player_b_blink2[id] > 0 || player_class[id]==Zmij) Prethink_Blink2(id)	
	if (player_b_blink[id] > 0) Prethink_Blink(id)	
	if (player_b_blink_sec[id] > 0) Prethink_Blink_sec(id)	
	if (player_class[id] == Arcymag) Prethink_Blink_arc(id)	
	if (player_b_usingwind[id] == 1) Prethink_usingwind(id)
	if (player_b_oldsen[id] > 0) Prethink_confuseme(id)
	if (player_b_froglegs[id] > 0) Prethink_froglegs(id)

	
	//USE Button actives USEMAGIC
	
	if (get_entity_flags(id) & FL_ONGROUND&& (!(button2 & (IN_FORWARD+IN_BACK+IN_MOVELEFT+IN_MOVERIGHT))) && !bow[id] && on_knife[id] && player_class[id]!=NONE && player_class[id]!=Nekromanta &&player_class[id]!=lelf  && invisible_cast[id]==0)
	{
		
		new policz = 0
		for (new g=0; g < 33; g++){
			if(policz >= 2) break
			if(is_user_alive(g) && get_user_team(g)==get_user_team(id)){
				policz++
			}
		}
		if(graczy < 4) policz =3
		if(policz >= 2 && player_NoCharging[id]<1){
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
				
				if(player_class[id] == Magic||player_class[id] == Ninja)time_delay*=2.7-(player_intelligence[id]/100.0)-player_chargetime[id]/10.0
				else if( player_class[id] == Harpia)time_delay*=2.0-(player_intelligence[id]/100.0)-player_chargetime[id]/10.0
				else if(player_class[id] == Wilk) time_delay*=3.0-(player_intelligence[id]/40.0)-player_chargetime[id]/10.0
				else if(player_class[id] == aniol) time_delay*=1.4-(player_intelligence[id]/100.0)-player_chargetime[id]/10.0
				else if(player_class[id] == Orc) time_delay=1.0-player_chargetime[id]/10.0
				else if(player_class[id] == Mag)
				{
					time_delay=time_delay = 10.0-(player_intelligence[id]/50.0)-player_chargetime[id]/10.0
					if(time_delay<5.0 -player_chargetime[id]/10.0 ) time_delay = 5.0 -player_chargetime[id]/10.0
					if(player_b_fireball[id]>0) time_delay=random_float(0.5,4.0-(player_intelligence[id]/25.0))-player_chargetime[id]/10.0
				}
				else if(player_class[id] == Mnich)
				{
					time_delay*=2.0-(player_intelligence[id]/50.0)-player_chargetime[id]/10.0
					if(time_delay<1.5) time_delay = 1.5
				}
				else if(player_class[id] == Zabojca ) time_delay*=1.8-(player_intelligence[id]/70.0)-player_chargetime[id]/10.0
				else if(player_class[id] == Archeolog) time_delay*=2.0-(player_intelligence[id]/50.0)-player_chargetime[id]/10.0
				else if(player_class[id] == Drzewiec) time_delay*=2.0-(player_intelligence[id]/50.0)-player_chargetime[id]/10.0
				else if(player_class[id] == Barbarzynca) time_delay*=1.5-(player_intelligence[id]/50.0)-player_chargetime[id]/10.0
				else if(player_class[id] == MagZ || player_class[id] == MagP) time_delay*=3.0-(player_intelligence[id]/400.0)-player_chargetime[id]/10.0
				else if(player_class[id] == MagO||player_class[id] == MagW ) time_delay*=2.0-(player_intelligence[id]/150.0)-player_chargetime[id]/10.0
				else if(player_class[id] == Paladyn) time_delay*=3.0 -(player_intelligence[id]/80.0)-player_chargetime[id]/10.0
				else if(player_class[id] ==szelf||player_class[id] ==lelf) time_delay*=3.0 -(player_intelligence[id]/200.0)-player_chargetime[id]/10.0
				else if(player_class[id] ==Kaplan){
					time_delay*=1.2-(player_intelligence[id]/100.0)-player_chargetime[id]/10.0
				} 
				if(time_delay<1.1 - player_chargetime[id]/20.0 && (player_class[id] == Drzewiec )) time_delay = 1.1 - player_chargetime[id]/20.0				
				if(player_class[id] == Witch) time_delay=7.0 -player_chargetime[id]/5.0
				
				
				if(time_delay<(0.75 - (0.75 * player_chargetime[id]/100))) time_delay = (0.75 - (0.75 * player_chargetime[id]/100))
				
				if(player_class[id] == Arcymag){ 
					time_delay=7.0-(player_intelligence[id]/25.0)-player_chargetime[id]/10.0
					if(time_delay<(0.5 - (0.5 * player_chargetime[id]/100))) time_delay = (0.5 - (0.5 * player_chargetime[id]/100))
				}
				else if(player_class[id] ==Wampir)
				{
					time_delay*=1.3-(player_intelligence[id]/50.0)-player_chargetime[id]/10.0
					if(time_delay<0.1) time_delay = 0.1
				}
				
				if(time_delay<0.1) time_delay = 0.1
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

	if(player_dziewica[id]>0 ){
		if( player_dziewica_using[id]==1){
			if(random_num(0,20)==0) Effect_Bleed(id,248)
			if(czas_itemu[id]< floatround(halflife_time())){
				czas_itemu[id]= floatround(halflife_time())+2
				cs_set_user_money(id,cs_get_user_money(id)-400)
				Effect_Bleed(id,248)
			}
			if(cs_get_user_money(id) <= 400) player_dziewica_using[id]=0
		}
		else{
			if(random_num(0,500)==0) Effect_Bleed(id,248)
		}
	}
	
	if(player_dziewica_hp[id]>0 ){
		if( player_dziewica_using[id]==1){
			if(random_num(0,20)==0) Effect_Bleed(id,248)
			if(czas_itemu[id]< floatround(halflife_time())){
				czas_itemu[id]= floatround(halflife_time())+2
				change_health(id, -get_maxhp(id) * 3 /100, 0, "world")
				player_b_udreka_ofiara[id]=floatround(halflife_time() + 5)
				write_hud(id)
				Effect_Bleed(id,248)
			}
		}
		else{
			if(random_num(0,500)==0) Effect_Bleed(id,248)
		}
	}
	
	if(player_dziewica_aut[id]>0 ){
		if(random_num(0,20)==0) Effect_Bleed(id,248)
	}
	
	
	if (pev(id,pev_button) & IN_USE && !casting[id])
		Use_Spell(id)
	
	if(player_class[id]==Wampir){
		if(player_naladowany[id]>0){
			if(button2 & IN_USE || button2 & IN_ATTACK || button2 & IN_ATTACK2 || button2 & IN_FORWARD || button2 & IN_BACK || button2 & IN_JUMP || button2 & IN_MOVELEFT || button2 & IN_MOVERIGHT)
			{
				player_naladowany[id]=0
				show_hudmessage(id, "Jestes widzialny")
				set_renderchange(id)
			}
		}
	}
		
	if(player_class[id]==Ninja || player_class[id]==Zabojca){
		if((player_class[id]==Ninja) && (pev(id,pev_button) & IN_RELOAD)) command_knife(id) 
		else if (pev(id,pev_button) & IN_RELOAD && on_knife[id] && max_knife[id]>0) command_knife(id) 
	}
	else if( player_class[id]==Magic)
	{	
		if(button2 & IN_ATTACK && on_knife[id]){
	
			if(czas_rundy + 10 > floatround(halflife_time())){
				set_hudmessage(255, 0, 0, -1.0, 0.01)
				show_hudmessage(id, "Skilla mozesz uzywac 10 sek po starcie rundy")

			}else{
				///////////////////// Fire slash /////////////////////////
				new Float:bonus = float(player_intelligence[id]/7)
				if(bonus > 13.0) bonus = 13.0
				if((bowdelay[id] + 15 - bonus)< get_gametime())
				{
					fired[id]=0
					item_fireball(id)
					bowdelay[id] = get_gametime()
					if(player_talos[id]>0){
						ultra_armor[id]++
						if(ultra_armor[id]>4)
						{
							ultra_armor[id]=4
							show_hudmessage(id, "Maksymalna wartosc pancerza to 4",ultra_armor[id]) 
						}
						else show_hudmessage(id, "Magiczny pancerz wytrzyma %i strzalow",ultra_armor[id]) 
					}
					write_hud(id)
				}
			}
		}

	}
	else if( player_class[id]==Arcymag)
	{	
		if(button2 & IN_ATTACK && on_knife[id]){
	
			if(czas_rundy + 10 > floatround(halflife_time())){
				set_hudmessage(255, 0, 0, -1.0, 0.01)
				show_hudmessage(id, "Skilla mozesz uzywac 10 sek po starcie rundy")

			}else{
				///////////////////// Fire slash /////////////////////////
				if((bowdelay_arc[id] + 10)< get_gametime())
				{
					fired[id]=0
					item_fireball(id)
					bowdelay_arc[id] = get_gametime()
					write_hud(id)
				}
			}
		}
	}
	else if(player_class[id]==MagP )
	{	
		if(button2 & IN_ATTACK && on_knife[id] &&   player_diablo[id]==0 &&  player_she[id]==0){
			item_space(id)
			write_hud(id)
		}

	}
	else if(player_class[id]==Hunter || (player_class[id]==lelf && player_rozprysk[id]>0)){
		///////////////////// BOW /////////////////////////
		if (button2 & IN_RELOAD && on_knife[id] && button[id]==0 && player_diablo[id]==0 && player_she[id]==0){
			bow[id]++
			button[id] = 1;
			command_bow(id)
		}
		
		new clip,ammo
		new weapon = get_user_weapon(id,clip,ammo)	
		
		if(bow[id] == 1)
		{
			new Float:czas = bowdelay[id] + 2.25 - (float(player_intelligence[id])/200.0)
			if(czas<( bowdelay[id] + 1.6)) czas = bowdelay[id] + 1.6
			if(czas< get_gametime() && button2 & IN_ATTACK)
			{
				bowdelay[id] = get_gametime()
				command_arrow(id) 
			}
			entity_set_int(id, EV_INT_button, (button2 & ~IN_ATTACK) & ~IN_ATTACK2)
		}
		
		// nade		
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
		if (timed_godmode[id] < halflife_time())Display_Icon(id ,ICON_HIDE ,"suit_full" ,255,255,255)
		if (player_b_udreka_ofiara[id] < floatround(halflife_time()) && player_b_udreka_ofiara[id]>0) Display_Icon(id ,ICON_HIDE ,"dmg_chem", 200,0,0)
		if (player_b_udreka_sec[id] < floatround(halflife_time()) && player_b_udreka_sec[id]>0) Display_Icon(id ,ICON_HIDE ,"dmg_chem", 200,50,50)
		
		if (!is_user_alive(id)) continue;

		if(player_b_tarczaograon[id]==1 ){
			if(random_num(0,2)==1){
				if(czas_itemu[id]<floatround(halflife_time())){
					player_b_tarczaograon[id] = 0
					set_speedchange(id)
					set_renderchange(id)
				}
			}
		}
	
		if( player_class[id]==Mag)
		{	
				new Float:time_delay = 5.0-(player_intelligence[id]/50.0)-player_chargetime[id]/10.0
				if(time_delay<(2.5 - (2.5 * player_chargetime[id]/100))) time_delay = (2.5 - (2.5 * player_chargetime[id]/100))
	
				if((bowdelay[id] + time_delay)< get_gametime())
				{
					player_naladowany[id] = 0
				}
		}
		else if( player_class[id]==aniol)
		{	
			new czas = 15 - player_intelligence[id]/30
			if(czas<7)czas=7
			czas = czas - (czas *  player_naszyjnikczasu[id]/ 100)
			if (halflife_time()-gravitytimer[id] > czas)
			{
				player_naladowany2[id]=0
			}
		}
		else if(player_class[id]==Wilk )
		{	
			if(player_naladowany[id] == 1){
				///////////////////// Zew krwi /////////////////////////
				if((bowdelay[id] + 40.25 + float(player_intelligence[id]/10))< get_gametime())
				{
					player_naladowany[id] = 0
					set_user_maxspeed(id,get_user_maxspeed(id)-80.0)
					fm_set_user_health(id, get_user_health(id) - (5*get_user_health(id)/15)) 
					player_naladowany[id] = 0
				}
			}
		}
		else if(player_class[id]==MagW )
		{					
			new czas = 10 - player_intelligence[id]/25
			if(czas<5)czas=5
			czas = czas - (czas *  player_naszyjnikczasu[id]/ 100)
			if (halflife_time()-bowdelay[id] > czas &&player_naladowany[id] == 1){
				player_naladowany[id] = 0
				show_hudmessage(id, "Znow mozesz uzyc czaru!") 
				write_hud(id)
			}
		}
		else if(player_class[id]==MagO )
		{	
			new czas = 20 - player_intelligence[id]/20
			if(czas<5)czas=5
			czas = czas - (czas *  player_naszyjnikczasu[id]/ 100)
			if (halflife_time()-bowdelay[id] > czas &&player_naladowany[id] == 1){
				player_naladowany[id] = 0
				show_hudmessage(id, "Znow mozesz uzyc czaru!") 
				write_hud(id)
			}
		}
		else if(player_class[id]==Arcymag)
		{	
			new czas = 25 - player_intelligence[id]/5 
			if(czas<10)czas=10
			czas = czas - (czas *  player_naszyjnikczasu[id]/ 100)
			if (halflife_time()-bowdelay[id] > czas &&player_naladowany2[id] == 1){
				player_naladowany2[id] = 0
				show_hudmessage(id, "Znow mozesz uzyc czaru!") 
				write_hud(id)
			}
		}
		else if(player_class[id]==MagP)
		{	
			new czas = 20 
			if(czas<10)czas=10
			czas = czas - (czas *  player_naszyjnikczasu[id]/ 100)
			if (halflife_time()-bowdelay[id] > czas &&player_naladowany2[id] == 1){
				player_naladowany2[id] = 0
				show_hudmessage(id, "Znow mozesz uzyc czaru!") 
				write_hud(id)
			}
		}
		else if(player_class[id]==MagZ)
		{	
			new czas = 10 - player_intelligence[id]/25 
			if(czas<5)czas=5	
			czas = czas - (czas *  player_naszyjnikczasu[id]/ 100)
			if (halflife_time()-bowdelay[id] > czas && player_naladowany[id] == 1){
				player_naladowany[id] = 0
				show_hudmessage(id, "Znow mozesz uzyc czaru!") 
				write_hud(id)
			}
		}
		
		
	}
}

public client_PostThink(id)
{
	if (player_b_jumpx[id] > 0 || player_class[id]==aniol || player_class[id]==Stalker ) Postthink_Doubeljump(id)
	if (earthstomp[id] != 0 && is_user_alive(id))
	{
		new g_Flags = pev(id, pev_flags);
		if (!falling[id]){
			if(player_b_gravity[id] > 0 || player_class[id] == aniol) add_bonus_stomp(id)
			if(earthstomp[id] != 0 && player_class[id] == Orc && g_Flags & FL_ONGROUND) OrcJumpBonus(id)			
		}
		else set_pev(id,pev_watertype,-3)
	}	
	
	
	if (( (player_class[id] ==Witch && player_naladowany[id] == Wilk) || ( player_pelnia[id] > 0 && (player_class[id] == Wilk || player_class[id] == lelf))) && is_user_alive(id)){
		if((g_fDelay[id] + 0.1) > get_gametime())
			return 
			
		g_fDelay[id] = get_gametime()
		new Float:fMyOrigin[3]
		entity_get_vector(id, EV_VEC_origin, fMyOrigin)
		
		static Players[32], iNum
		get_players(Players, iNum, "a")
		for(new i = 0; i < iNum; ++i) 
		{
			new target = Players[i]
			if(!is_user_connected(target)) continue;
			
			if(get_user_team(target)==get_user_team(id)) continue;
			if(get_user_health(target) >= get_maxhp(target)) continue;
			
			new Float:fTargetOrigin[3]
			entity_get_vector(target, EV_VEC_origin, fTargetOrigin)
	
	
			new Float:fMiddle[3], Float:fHitPoint[3]
			xs_vec_sub(fTargetOrigin, fMyOrigin, fMiddle)
			trace_line(-1, fMyOrigin, fTargetOrigin, fHitPoint)
									
			new Float:fWallOffset[3], Float:fDistanceToWall
			fDistanceToWall = vector_distance(fMyOrigin, fHitPoint) - 10.0
			normalize(fMiddle, fWallOffset, fDistanceToWall)
			
			new Float:fSpriteOffset[3]
			xs_vec_add(fWallOffset, fMyOrigin, fSpriteOffset)
			new Float:fScale, Float:fDistanceToTarget = vector_distance(fMyOrigin, fTargetOrigin)
			if(fDistanceToWall > 100.0)
				fScale = 8.0 * (fDistanceToWall / fDistanceToTarget)
			else
				fScale = 2.0
		
			te_sprite(id, fSpriteOffset, sprite_playerheat, floatround(fScale), 125)
		}
	}
	if (player_glod[id] > 0&& is_user_alive(id)){
		if((g_fDelay[id] + 0.1) > get_gametime())
			return 
			
		g_fDelay[id] = get_gametime()
		new Float:fMyOrigin[3]
		entity_get_vector(id, EV_VEC_origin, fMyOrigin)
		
		for (new trup=0; trup< 33; trup++)
		{
			new target = find_dead_body(trup)
			if(!is_valid_ent(target)) continue;
			new Float:fTargetOrigin[3]
			entity_get_vector(target, EV_VEC_origin, fTargetOrigin)
	
	
			new Float:fMiddle[3], Float:fHitPoint[3]
			xs_vec_sub(fTargetOrigin, fMyOrigin, fMiddle)
			trace_line(-1, fMyOrigin, fTargetOrigin, fHitPoint)
									
			new Float:fWallOffset[3], Float:fDistanceToWall
			fDistanceToWall = vector_distance(fMyOrigin, fHitPoint) - 10.0
			normalize(fMiddle, fWallOffset, fDistanceToWall)
			
			new Float:fSpriteOffset[3]
			xs_vec_add(fWallOffset, fMyOrigin, fSpriteOffset)
			new Float:fScale, Float:fDistanceToTarget = vector_distance(fMyOrigin, fTargetOrigin)
			if(fDistanceToWall > 100.0)
				fScale = 8.0 * (fDistanceToWall / fDistanceToTarget)
			else
				fScale = 2.0
		
			te_sprite(id, fSpriteOffset, sprite_playerheat, floatround(fScale), 125)
		}
	}
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
					}
					else{
						client_print(id,print_center,"Nie mozesz dodac wiecej!")
					}


				}
				else{
					if(player_dextery[id] + player_point[id] < max_skill){
						player_dextery[id]+=player_point[id]
						player_point[id] = 0
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
					dexteryDamRedCalc(id)
				}
				else{
					player_dextery[id]+=player_point[id]
					player_point[id] = 0
					dexteryDamRedCalc(id)
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
	new exp = get_cvar_num("diablo_xpbonus2") * pln 
	new przenies = 0
	if(((rounds <3 && ttw > ctwS) ||ttw > ctwS + 1) && pln > 6)
	{
		przenies++
	}
	
	for (new i=0; i<33; i++) 
	{
		new id = i
		if(!is_user_connected(id) || is_user_hltv(id)) continue;
		if(cs_get_user_team(id) == CS_TEAM_CT || cs_get_user_team(id) == CS_TEAM_SPECTATOR || cs_get_user_team(id) == CS_TEAM_UNASSIGNED ) continue;
		new exp2 = calc_award_goal_xp(id,exp,0)/ (seria[id]+1)
		if(forceEvent==3){
			set_user_frags(id, get_user_frags(id)+5)
			exp2=exp2 * 4 
		}
		Give_Xp(id,exp2)	
		client_print(id,print_chat,"Dostales *%i* doswiadczenia za wygranie rundy",xp_mnoznik(id, exp2))
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
		
		if(GetPlayersNum(CS_TEAM_CT) * 2 < GetPlayersNum(CS_TEAM_T))
		{
			if(player_lvl[i] < player_lvl[maxLvlPlayer]) maxLvlPlayer = i
		}
		else
		{		
			if(player_lvl[i] > player_lvl[maxLvlPlayer]) maxLvlPlayer = i
		}
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
	/*
	if(przenies && maxLvlPlayer > 0 && GetPlayersNum(CS_TEAM_T)>2)
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
	*/
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
	new exp = get_cvar_num("diablo_xpbonus2") * pln
	new przenies = 0
	if(((rounds<3 && ctw > ttwS)||ctw > ttwS + 1) && pln > 6)
	{
		przenies++
	}
	for (new i=0; i<33; i++) 
	{
		new id = i
		if(!is_user_connected(id)|| is_user_hltv(id)) continue;
		if(cs_get_user_team(id) == CS_TEAM_T  || cs_get_user_team(id) == CS_TEAM_SPECTATOR || cs_get_user_team(id) == CS_TEAM_UNASSIGNED) continue;
		new exp2 = calc_award_goal_xp(id,exp,0) / (seria[id]+1)
		if(forceEvent==3){
			set_user_frags(id, get_user_frags(id)+5)
			exp2=exp2 * 4 
		}
		Give_Xp(id,exp2)	
		client_print(id,print_chat,"Dostales *%i* doswiadczenia za wygranie rundy",xp_mnoznik(id, exp2))
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
		
		if(GetPlayersNum(CS_TEAM_T) * 2 < GetPlayersNum(CS_TEAM_CT))
		{
			if(player_lvl[i] < player_lvl[maxLvlPlayer]) maxLvlPlayer = i
		}
		else
		{		
			if(player_lvl[i] > player_lvl[maxLvlPlayer]) maxLvlPlayer = i
		}
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
	
	/*
	if(przenies && maxLvlPlayer > 0 && GetPlayersNum(CS_TEAM_CT)>2)
	{
		cs_set_user_team (maxLvlPlayer,CS_TEAM_T, CS_DONTCHANGE)
		new  name[32]
		get_user_name(maxLvlPlayer, name, 31) 
		client_print(0,print_chat,"%s przeniesiony do TT",name)
		if(przenies && minLvlPlayer > 0 && GetPlayersNum(CS_TEAM_CT) > GetPlayersNum(CS_TEAM_T))
		{
			cs_set_user_team (minLvlPlayer,CS_TEAM_CT, CS_DONTCHANGE)
			new  name[32]
			get_user_name(minLvlPlayer, name, 31) 
			client_print(0,print_chat,"%s przeniesiony do CT",name)
		}
	}
	*/
}


public award_esc()
{
	count_avg_lvl()
	new pln = get_playersnum() 
	if(pln > 12) pln  = 12
	new exp = get_cvar_num("diablo_xpbonus2") * pln 
	for (new i=0; i<33; i++) 
	{
		new id = i
		if(!is_user_connected(id)) continue;
		if(!is_user_alive(id)) continue;
		if(cs_get_user_team(id) == CS_TEAM_T) continue;
		new exp2 = calc_award_goal_xp(id,exp,0) / (seria[id]+1)
		if(forceEvent==3 ){
			exp2*= 4 
		}
		Give_Xp(id,exp2)	
		client_print(id,print_chat,"Dostales *%i* doswiadczenia za ucieczke vipa",xp_mnoznik(id, exp2))
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
	new exp = get_cvar_num("diablo_xpbonus2") * pln
	for (new i=0; i<33; i++) 
	{
		new id = i
		if(!is_user_connected(id)) continue;
		if(!is_user_alive(id)) continue;
		if(cs_get_user_team(id) == CS_TEAM_CT) continue;
		
		new exp2 = calc_award_goal_xp(id,exp, 0) / (seria[id]+1)
		if(forceEvent==3 ){			
			exp2*= 2 
		}
		Give_Xp(id,exp2)	
		client_print(id,print_chat,"Dostales *%i* doswiadczenia za polozenie bomby przez twoj team",xp_mnoznik(id, exp2))
		player_wys[id]=1
		player_lastDmgTime[id]=halflife_time();
	}	
	closeXp(planter)
	if(forceEvent==3 ) set_user_frags(planter, get_user_frags(planter)+10)
	planter=0
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


public calc_award_goal_xp(id,exp, przelicznik)
{
	new av = 0
	if(cs_get_user_team(id) == CS_TEAM_T) av = avg_lvlCT
	if(cs_get_user_team(id) == CS_TEAM_CT) av = avg_lvlTT
	if (avg_lvl > 10 /*&& avg_lvl < 150 && player_lvl[id] - 100 > avg_lvl*/ ){
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
		player_lastDmgTime[id]=halflife_time();
	}
	return exp
}

public award_defuse()
{
	if( target_def!= 0) return
	target_def = 1
	count_avg_lvl()
	new pln = get_playersnum() 
	if(pln > 12) pln  = 12
	new exp = get_cvar_num("diablo_xpbonus2") * pln * 8 /5
	for (new i=0; i<33; i++) 
	{
		new id = i
		if(!is_user_alive(id)) continue;
		if(!is_user_connected(id)) continue;
		if(cs_get_user_team(id) == CS_TEAM_T) continue;
		new exp2 = calc_award_goal_xp(id,exp,0) / (seria[id]+1)
		if(forceEvent==3 ){
			exp2*= 2
		}
		Give_Xp(id,exp2)
		client_print(id,print_chat,"Dostales *%i* doswiadczenia za rozbrojenie bomby przez twoj team",xp_mnoznik(id, exp2))
		player_wys[id]=1
		player_lastDmgTime[id]=halflife_time();
	}
	closeXp(defuser)
	if(forceEvent==3 ) set_user_frags(defuser, get_user_frags(defuser)+5)
}

public award_hostageALL(id)
{
	count_avg_lvl()
	new pln = get_playersnum() 
	if(pln > 12) pln  = 12
	new exp = get_cvar_num("diablo_xpbonus2") * pln 
	for (new i=0; i<33; i++) 
	{
		new id = i
		if(!is_user_connected(id)) continue;
		if(!is_user_alive(id)) continue;
		if(cs_get_user_team(id) == CS_TEAM_T) continue;
		new exp2 = calc_award_goal_xp(id,exp,0) / (seria[id]+1)
		if(forceEvent==3 ) exp2*= 5 
		Give_Xp(id,exp2)
		client_print(id,print_chat,"Dostales *%i* doswiadczenia za wyprowadzenie zakladnikow przez twoj team",xp_mnoznik(id, exp2))
		player_wys[id]=1
		player_lastDmgTime[id]=halflife_time();
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
			new exp = get_cvar_num("diablo_xpbonus2") * pln /2
			exp = calc_award_goal_xp(id,exp,0)/ (seria[id]+1)
			client_print(pid,print_chat,"Dostales *%i* doswiadczenia za cele mapy",xp_mnoznik(id, exp))
			player_wys[pid]=1
			if(forceEvent==3 ) exp*= 2
			Give_Xp(pid,exp)
			if(forceEvent != 2) award_item(pid, 0)
		}else{
			new exp = get_cvar_num("diablo_xpbonus2") * pln   / 4 
			exp = calc_award_goal_xp(id,exp,0)/ (seria[id]+1)
			client_print(pid,print_chat,"Dostales *%i* doswiadczenia za asyste lidera",xp_mnoznik(id, exp))
			player_wys[pid]=1
			if(forceEvent==3 ) exp*= 5
			Give_Xp(pid,exp)
			if(forceEvent==3 ) set_user_frags(id, get_user_frags(id)+5)
		}
				
	}
}

/* ==================================================================================================== */
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
	if(zliczoneKlasy > 0){
		new TempSkill[11]
		add(itemEffect,499," wybrane klasy [+")
		num_to_str(zliczoneKlasy*4,TempSkill,10)
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," proc expa]")
	}
	//if(steams > 0){
	//	new TempSkill[11]
	//	add(itemEffect,499," liczba steamow [+")
	//	num_to_str(steams,TempSkill,10)
	//	add(itemEffect,499,TempSkill)
	//	add(itemEffect,499," proc expa]")
	//}
	
	if(player_bans[id] == 0)
	{
		add(itemEffect,499," brak banow [+30 proc expa]")
	}
	else if(player_bans[id] == 1)
	{
		add(itemEffect,499," brak banow [+20 proc expa]")
	}
	else if(player_bans[id] > 2)
	{
		add(itemEffect,499," bany [-30 proc expa]")
	}
	else if(player_bans[id] > 5)
	{
		add(itemEffect,499," bany [-50 proc expa]")
	}
	else if(player_bans[id] > 10)
	{
		add(itemEffect,499," bany [-90 proc expa]")
	}
	
	if(u_sid[id] > 0 && player_sid_pass[id][0]){
		add(itemEffect,499," steam [+80 proc expa]")
	}else if(u_sid[id] > 0){
		add(itemEffect,499," steam [+75 proc expa]")
	}else{
		client_print(id,print_chat, "Graj na steam: bonus 75 proc expa")
	}
	if(player_pass_pass[id][0]){
		add(itemEffect,499," haslo [+5 proc expa]")
	}
	if(player_sid_pass[id][0]){
		add(itemEffect,499," steam [+5 proc expa]")
	}
	if(tutOn && tutor[id]<2 && strlen(itemEffect)>10)tutorMake(id,TUTOR_GREEN,5.0,itemEffect)
	if(player_lvl[id] >75 && !player_sid_pass[id][0] && !player_pass_pass[id][0]) {
		if(tutOn && tutor[id]<2)tutorMake(id,TUTOR_RED,6.0,"-50 poc expa za brak darmowej rezerwacji")
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
	
	if(mn<100 && tutOn && tutor[id]<2 && get_playersnum() > 5)
	{
		new g_string[164]
		formatex(g_string, 63, "-%d procent exp za gre w wygrywajacej druzynie [TT %i:%i CT]", (100 - mn), ttw,  ctw)
		tutorMake(id,TUTOR_RED,5.5,g_string)
	}
	else if(CT_mnoznik_expa == 100 && TT_mnoznik_expa == 100 && tutOn && tutor[id]<2 && get_playersnum() > 5)
	{
	
		new g_string[164]
		formatex(g_string, 63, "+25 procent exp za rowne teamy [TT %i:%i CT]",  ttw,  ctw)
		tutorMake(id,TUTOR_GREEN,5.5,g_string)
	}
}
public xp_mnoznik_v3(id)
{
	if(!is_user_connected(id))return
	if(player_class[id] == 0) return
	

	if(player_samelvl2[id]>0  && tutOn && tutor[id]<2 )
	{
		new g_string[64]
		formatex(g_string, 63, "+%i procent exp za klasy o podobnym lvlu",  player_samelvl[id]*5 + player_samelvl2[id]*2)
		tutorMake(id,TUTOR_GREEN,5.5,g_string)
	}
	
}

new Float:xpStandardMnoznik[33] = 10.0;
new Float:xpStandardMnoznik2[33] = 10.0;
public xp_mnoznik_wylicz(id)
{
	if(!is_user_connected(id))return

	if(player_class[id] == 0){
		xpStandardMnoznik[id] = 0.0;
		xpStandardMnoznik2[id] = 0.0;
		return
	}
	
	if(player_xp[id] < 970299)
	{
		if(player_xp[id] < 27000) { player_xp[id]= 27000;}
		else if(player_xp[id] < 64000){  player_xp[id]= 64000;}
		else if(player_xp[id] < 117649){  player_xp[id]= 117649;}
		else if(player_xp[id] < 216000){  player_xp[id]= 216000;}
		else if(player_xp[id] < 343000){  player_xp[id]= 343000;}
		else if(player_xp[id] < 512000){  player_xp[id]= 512000;}
		else if(player_xp[id] < 551368){  player_xp[id]= 551368;}
		else if(player_xp[id] < 614125){  player_xp[id]= 614125;}
		else if(player_xp[id] < 681472){  player_xp[id]= 681472;}
		else if(player_xp[id] < 804357){  player_xp[id]= 804357;}
		else if(player_xp[id] < 884736){  player_xp[id]= 884736;}
		else if(player_xp[id] < 941192){  player_xp[id]= 941192;}	
		else if(player_xp[id] < 970299){  player_xp[id]= 970299;}
		else if(player_xp[id] < 1000000){  player_xp[id]= 1000000;}
		else if(player_xp[id] < 1030301){  player_xp[id]= 1030301;}
		else if(player_xp[id] < 1061208){  player_xp[id]= 1061208;}
		else if(player_xp[id] < 1092727){  player_xp[id]= 1092727;}
		else if(player_xp[id] < 1124864){  player_xp[id]= 1124864;}
		else if(player_xp[id] < 1157625){  player_xp[id]= 1157625;}
		else if(player_xp[id] < 1191016){  player_xp[id]= 1191016;}
		else if(player_xp[id] < 1225043){  player_xp[id]= 1225043;}
		else if(player_xp[id] < 1259712){  player_xp[id]= 1259712;}
		else if(player_xp[id] < 1295029){  player_xp[id]= 1295029;}
		else if(player_xp[id] < 1331000){  player_xp[id]= 1331000;}
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
	
	//if(steams > 0){
	//	new Float:sss = 1.0 + (steams/100.0)
	//	amount = (sss*amount)
	//}
	if(zliczoneKlasy > 0) amount = amount + (zliczoneKlasy*4*amount/100)
	
	if(player_samelvl[id]>0 ){
		amount = (player_samelvl[id]*8*amount)/100 + amount
	}
	
	if(player_samelvl2[id]>0 ){
		amount = (player_samelvl[id]*4*amount)/100 + amount
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
	
	if(get_user_flags(id) & ADMIN_BAN){
		amount = (1.05*amount)
	}
	if(u_sid[id] == 0){
		amount = (0.25*amount)
	}
	
	if(player_bans[id] == 0)
	{
		amount = (1.3*amount)
	}
	else if(player_bans[id] == 1)
	{
		amount = (1.2*amount)
	}
	else if(player_bans[id] > 2)
	{
		amount = (0.7*amount)
	}
	else if(player_bans[id] > 5)
	{
		amount = (0.5*amount)
	}
	else if(player_bans[id] > 10)
	{
		amount = (0.9*amount)
	}
	
	if(u_sid[id] > 0){
		amount = (1.5*amount)
	}else if(player_lvl[id]> 125){
		amount = (0.5*amount)
		if(player_lvl[id]> 200) amount = 0.0
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
		if(forceEvent == 2) 
		{
			amount = (1.2*amount)
		}
		else if((clEvent == 2 || forceEvent == 1) && (player_class[id] == clEvent1 || player_class[id] == clEvent2)){
			amount = (1.7*amount)
		}else if(KlasyZlicz[player_class[id]]==1 || immun[id] > 0){
			amount = (1.3*amount)
		}else if(KlasyZlicz[player_class[id]]>1 || KlasyZlicz[player_class[id]]<5 && immun[id] == 0){
			amount = (0.5*amount)
		}else if(KlasyZlicz[player_class[id]]>=5 && immun[id] == 0){
			amount = (0.3*amount)	
		}
	}

	if(player_lvl[id]> 5){	
		if(player_lvl[id]< 100){
			amount2 = (5.5*amount2)
		}
		//if(player_lvl[id]> 150){
		//	amount2 = (0.8*amount2)
		//}
		if(player_lvl[id]< 150){
			amount2 = (2.0*amount2)
		}
		if(player_lvl[id]< 175){
			amount2 = (2.5*amount2)
		}
		if(player_lvl[id]< 200){
			amount2 = (1.5*amount2)
		}
		if(player_lvl[id]> 220){
			amount2 = (0.3*amount2)
		}
		if(player_lvl[id]> 230){
			amount2 = (0.3*amount2)
		}
		if(player_lvl[id]> 240){
			
			if(player_lvl[id]> 248){
				amount2 = (0.5*amount2)
			}
			if(player_lvl[id]> 251){
				amount2 = (3.0*amount2)
			}
			if(player_lvl[id]> 400){
				amount2 = (0.5*amount2)
			}
			if(player_lvl[id]> 495){
				amount2 = (0.5*amount2)
			}
			if(player_lvl[id]> 498){
				amount2 = (0.5*amount2)
			}
			if(player_lvl[id]> 740){
				amount2 = (0.7*amount2)
			}
			if(player_lvl[id]> 745){
				amount = (0.7*amount)
			}
			if(player_lvl[id]> 746){
				amount = (0.7*amount)
			}
			if(player_lvl[id]> 747){
				amount = (0.7*amount)
			}
			if(player_lvl[id]> 748){
				amount = (0.7*amount)
			}
			if(player_lvl[id]> 749){
				amount = (0.5*amount)
			}
			if(player_lvl[id]> 950){
				amount2 = (0.7*amount2)
			}	
				
			if(player_lvl[id]> 998){
				amount2 = 0.1
				amount = 0.1
			}
		}

	}
	
	xpStandardMnoznik[id] = amount / 1.0;
	xpStandardMnoznik2[id] = amount2 / 1.0;
	if(xpStandardMnoznik[id] < 0.1) xpStandardMnoznik[id] = 0.1
	if(xpStandardMnoznik2[id] < 0.1) xpStandardMnoznik2[id] = 0.1
}




public xp_mnoznik(id, amount){

	amount = floatround(amount * xpStandardMnoznik[id] * xpStandardMnoznik2[id] / 10000);

	return amount
	
}


public Give_Xp(id,amount)
{	
	if(player_class_lvl[id][player_class[id]]<0 ||player_lvl[id]<0){
		player_class_lvl[id][player_class[id]] = 2
		player_lvl[id] = 2 
	}
	amount = xp_mnoznik(id,amount)
	if(player_lvl[id] >= 248 && player_lvl[id] < 255){
		amount = amount/4
		if(amount>1000) amount = 1000
	}
	if(player_lvl[id] >= 498 && player_lvl[id] < 505){
		amount = amount/8
		if(amount>1000) amount = 1000
	}
		
	if(player_lvl[id] >= 748 && player_lvl[id] < 855){
		amount = amount/8
		if(amount>1000) amount = 1000
	}
	if(player_lvl[id] >= 950)  amount = amount/10 
	if(player_lvl[id] >= 998)  amount = amount/25 
	if(amount < 1) amount = 1
	roundXP[id] += amount
	

	
	if(player_class_lvl[id][player_class[id]]==player_lvl[id])
	{
		if(diablo_typ==2  && player_lvl[id] >= 99) {
			LevelXP[100]= LevelXP[99]*3
			LevelXP[101]= LevelXP[100]*3
		}
		
		if(diablo_typ==2 && player_lvl[id] >= 101) return PLUGIN_CONTINUE 
		
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
			if(player_lvl[id]<250){
			
			}
			if ((player_xp[id] > LevelXP[player_lvl[id]] ))
			{
				player_lvl[id]+=1
				player_point[id]+=2
				player_class_lvl[id][player_class[id]]=player_lvl[id]
				
				if(player_lvl[id] > 100){
					if(tutOn && tutor[id]<2)tutorMake(id,TUTOR_YELLOW,5.0,"Awansowales do poziomu %i",player_lvl[id])				
					efekt_level(id)
				}
				//savexpcom(id)
			}
			
			if ((player_xp[id] < LevelXP[player_lvl[id]-1]))
			{
				player_lvl[id]-=1
				player_point[id]-=2
				if(tutOn && tutor[id]<2)tutorMake(id,TUTOR_RED,5.0,"Spadles do poziomu %i",player_lvl[id])
				//savexpcom(id)
				player_class_lvl[id][player_class[id]]=player_lvl[id]
			}
			write_hud(id)
		}
	}
	return PLUGIN_CONTINUE 
}
new putin[33] = 0;
/* ==================================================================================================== */
public client_connect(id)
{
	if(putin[id]==0)client_putinserver(id)
	seria[id] = 0
	myRank[id] = -1
	asked_sql[id]=0
	flashbattery[id] = MAX_FLASH
	player_xp[id] = 0		
	player_lvl[id] = 1		
	player_point[id] = 0	
	player_item_id[id] = 0		
	player_dziewica[id]= 0
	player_dziewica_aut[id]= 0
	player_dziewica_hp[id]= 0
	player_dremora_lekka[id]= 0
	player_dremora[id]= 0
	player_samelvl[id] = 0;
	player_samelvl2[id] = 0;
	player_lastDmgTime[id]=halflife_time();
	new prt[10]
	get_user_info(id,"_printdmg",prt,10)
	print_dmg[id]=0
	if(str_to_num(prt) == 1) print_dmg[id]=1
	if(str_to_num(prt) == 2) print_dmg[id]=2
	
	new prt3[10]
	get_user_info(id,"_m",prt3,10)
	if(str_to_num(prt3) == 1)
	{
		new name[64]
		get_user_name(id,name,63)
		player_mute[id] = 1
		server_cmd( "amx_mute ^"%s^"", name);
	}
	
	new prt2[10]
	get_user_info(id,"_tutor",prt2,10)
	tutor[id]=0
	if(str_to_num(prt2) == 1) tutor[id]=1
	if(str_to_num(prt2) == 2) tutor[id]=2
	player_dziewica_using[id]=0
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
	player_b_samurai[id]=0 
	g_GrenadeTrap[id] = 0
	g_TrapMode[id] = 0		
	player_ring[id]=0
	reset_item_skills(id)
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
	xpStandardMnoznik2[id] = 10.0;
	xpStandardMnoznik[id] = 10.0;
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
	player_edison[id]=0
	putin[id]  =1
	player_mute[id] = 0
	player_bans[id] = -1
	date_long[id]= "";
	loaded_xp[id]=0
	asked_klass[id] = 0;
	player_class_lvl_save[id]=0
	database_user_created[id]=0
	count_jumps(id)
	JumpsLeft[id]=JumpsMax[id]
	player_lvl[id]=0
	last_update_xp[id]=0
	player_xp[id]=0
	player_class_lvl_save[id]=0
	loaded_xp[id]=0
	highlvl[id]=0  
	create_used[id]=0
	player_vip[id]=0
	player_sid_pass[id] = ""
	player_pass_pass[id] = ""
	player_podany_pass_pass[id] = ""
	god[id] = 0
	pr_pass_pass[id] = 0
	highlvl[id] = 0
	for(new i=1; i<9; i++) player_class_lvl[id][i] = 0;
	set_task(10.0, "Greet_Player", id+TASK_GREET, "", 0, "a", 1)
}

public client_disconnect(id)
{
	player_edison[id]=0
	//popularnosc[id]=0
	myRank[id]=-1
	vote[id]=0
	dropped[id]=0
	immun[id]=0
	player_mute[id] = 0
	player_bans[id] = -1
	date_long[id]= "";
	player_lastDmgTime[id]=halflife_time();
	new ent
	new playername[40]
	get_user_name(id,playername,39)
	player_dc_name[id] = playername
	player_dc_item[id] = player_item_id[id]	
	
	if (player_b_oldsen[id] > 0.0) client_cmd(id,"sensitivity %f",player_b_oldsen[id])
	savexpcom(id)
	
	remove_task(TASK_CHARGE+id)     
     
	while((ent = fm_find_ent_by_owner(ent, "fake_corpse", id)) != 0)
		fm_remove_entity(ent)
	player_lvl[id]=0
	last_update_xp[id]=0
	player_xp[id]=0
	player_class_lvl_save[id]=0
	player_class[id]=0
	loaded_xp[id]=0
	player_vip[id]=0
	player_sid_pass[id] = ""
	player_pass_pass[id] = ""
	player_podany_pass_pass[id] = ""
	pr_pass_pass[id] = 0
	god[id] = 0
	highlvl[id] = 0
	u_sid[id] = 0
	last_attacker[id]=0
	xpStandardMnoznik[id] = 10.0;
	xpStandardMnoznik2[id] = 10.0;
	player_dextery[id] =0
	player_intelligence[id] =0
	player_strength[id] =0
	player_agility[id] =0
	dexteryDamRedCalc(id)
	for(new a=0;a<32;a++){
		if(last_attacker[a]==id) last_attacker[a] = 0 
	}
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
	new wyczerpanyStr[12] = "Wyczerpany";
	
	if(player_lvl[id] < 2){
		formatex(tpstring,2023,"Klasa: %s Wczytywanie", Race[player_class[id]])
	}
	else{
		if(player_class[id]==Paladyn || player_blogo[id]>0){
			formatex(tpstring,2023,"%s [%i]%s LVL:%i (%0.0f%s) HP:%i Skoki:%i/%i Pociski:%i", 
			player_lvl[id] < prorasa ? Race[player_class[id]] : ProRace[player_class[id]], KlasyZlicz[player_class[id]], immun[id] > 0 ? "*" : "",
			player_lvl[id], perc,"%%",get_user_health(id),JumpsLeft[id],JumpsMax[id], golden_bulet[id])
		}
		else if(player_class[id]==Barbarzynca){
			formatex(tpstring,2023,"%s [%i]%s LVL:%i (%0.0f%s) HP:%i Pancerze:%i", 
			player_lvl[id] < prorasa ? Race[player_class[id]] : ProRace[player_class[id]], KlasyZlicz[player_class[id]], immun[id] > 0 ? "*" : "",
			player_lvl[id], perc,"%%",get_user_health(id),ultra_armor[id])
		}
		else if(player_class[id]==Ninja){
			formatex(tpstring,2023,"%s [%i]%s LVL:%i (%0.0f%s) HP:%i Noze:%i", 
			player_lvl[id] < prorasa ? Race[player_class[id]] : ProRace[player_class[id]], KlasyZlicz[player_class[id]], immun[id] > 0 ? "*" : "",
			player_lvl[id], perc,"%%",get_user_health(id),player_knife[id])
		}
		else if(player_class[id]==Zabojca){
			formatex(tpstring,2023,"%s [%i]%s LVL:%i (%0.0f%s) HP:%i Noze:%i, Widzialny:%s", 
			player_lvl[id] < prorasa ? Race[player_class[id]] : ProRace[player_class[id]], KlasyZlicz[player_class[id]], immun[id] > 0 ? "*" : "",
			player_lvl[id], perc,"%%",get_user_health(id),player_knife[id], (invisible_cast[id]==1) ? "Nie" : "Tak")
		}
		else if(player_class[id]==Kaplan){
			formatex(tpstring,2023,"%s [%i]%s LVL:%i (%0.0f%s) HP:%i Totemy:%i %s", 
			player_lvl[id] < prorasa ? Race[player_class[id]] : ProRace[player_class[id]], KlasyZlicz[player_class[id]], immun[id] > 0 ? "*" : "",
			player_lvl[id], perc,"%%",get_user_health(id), (5- player_naladowany[id]), 
			halflife_time() < player_naladowany2[id] ? "Hs bonus" : "" )
		}
		else if(player_class[id]==Mag){
			if(player_tarczapowietrza[id] < 0) player_tarczapowietrza[id] = 0
			formatex(tpstring,2023,"%s [%i]%s LVL:%i (%0.0f%s) HP:%i Tarcza:%i, Czar:%s", 
			player_lvl[id] < prorasa ? Race[player_class[id]] : ProRace[player_class[id]], KlasyZlicz[player_class[id]], immun[id] > 0 ? "*" : "",
			player_lvl[id], perc,"%%",get_user_health(id),player_tarczapowietrza[id], 
			(player_naladowany[id]==0) ? gotoweStr : wyczerpanyStr)
		}
		else if(player_class[id]==Archeolog){
			new it = 3+player_intelligence[id]/25
			if(it > 6) it = 6
			formatex(tpstring,2023,"%s [%i]%s LVL:%i (%0.0f%s) HP:%i Wykopane:%i/%i",
			player_lvl[id] < prorasa ? Race[player_class[id]] : ProRace[player_class[id]], KlasyZlicz[player_class[id]], immun[id] > 0 ? "*" : "",
			player_lvl[id], perc,"%%",get_user_health(id),it - player_naladowany[id],it)
		}
		else if(player_class[id]==szelf){
			new count = 0
			new ents = -1
			ents = find_ent_by_owner(ents,"MineL",id)
			while (ents > 0)
			{
				count++
				ents = find_ent_by_owner(ents,"MineL",id)
			}
		
			formatex(tpstring,2023,"%s [%i]%s LVL:%i (%0.0f%s) HP:%i Miny:%i",
			player_lvl[id] < prorasa ? Race[player_class[id]] : ProRace[player_class[id]], KlasyZlicz[player_class[id]], immun[id] > 0 ? "*" : "",
			player_lvl[id], perc,"%%",get_user_health(id), count)
		}
		else if( player_class[id]==MagO || player_class[id]==MagZ){
			formatex(tpstring,2023,"%s [%i]%s LVL:%i (%0.0f%s) HP:%i Czar:%s",
			player_lvl[id] < prorasa ? Race[player_class[id]] : ProRace[player_class[id]], KlasyZlicz[player_class[id]], immun[id] > 0 ? "*" : "",
			player_lvl[id], perc,"%%",get_user_health(id), 
			(player_naladowany[id]==0 && czas_rundy + 10 <= floatround(halflife_time())) ? gotoweStr : wyczerpanyStr)		
		}	
		else if( player_class[id]==Orc){
			formatex(tpstring,2023,"%s [%i]%s LVL:%i (%0.0f%s) HP:%i Czar:%s",
			player_lvl[id] < prorasa ? Race[player_class[id]] : ProRace[player_class[id]], KlasyZlicz[player_class[id]], immun[id] > 0 ? "*" : "",
			player_lvl[id], perc,"%%",get_user_health(id), 
			(player_naladowany[id] < floatround(halflife_time()) && czas_rundy + 10 <= floatround(halflife_time())) ? gotoweStr : wyczerpanyStr)		
		}
		else if(player_class[id]==MagW ){
			if(player_tarczapowietrza[id] < 0) player_tarczapowietrza[id] = 0
			formatex(tpstring,2023,"%s [%i]%s LVL:%i (%0.0f%s) HP:%i Tarcza:%i Czar:%s",
			player_lvl[id] < prorasa ? Race[player_class[id]] : ProRace[player_class[id]], KlasyZlicz[player_class[id]], immun[id] > 0 ? "*" : "",
			player_lvl[id], perc,"%%",get_user_health(id),  player_tarczapowietrza[id],
			(player_naladowany[id]==0 && czas_rundy + 10 <= floatround(halflife_time())) ? gotoweStr : wyczerpanyStr)		
		}
		else if(player_class[id]==Arcymag){
			formatex(tpstring,2023,"%s [%i]%s LVL:%i (%0.0f%s) HP:%i | %s %s %s %s",
			player_lvl[id] < prorasa ? Race[player_class[id]] : ProRace[player_class[id]], KlasyZlicz[player_class[id]], immun[id] > 0 ? "*" : "",
			player_lvl[id], perc,"%%",get_user_health(id), 
			(player_naladowany2[id]==0 && czas_rundy + 10 <= floatround(halflife_time())) ? "Z" : "z",
			(arcy_cast_time[id] < floatround(halflife_time()) && czas_rundy + 10 <= floatround(halflife_time()))? "P" : "p",
			(halflife_time()-player_b_blink_arc[id] > 10 && czas_rundy + 10 <= floatround(halflife_time()))? "T" : "t",
			((bowdelay_arc[id] + 10)< get_gametime() && czas_rundy + 10 <= floatround(halflife_time())) ? "L" : "l"
			)		
		}
		else if(player_class[id]==aniol){
			formatex(tpstring,2023,"%s [%i]%s LVL:%i (%0.0f%s) HP:%i Skoki: %i Czar:%s",
			player_lvl[id] < prorasa ? Race[player_class[id]] : ProRace[player_class[id]], KlasyZlicz[player_class[id]], immun[id] > 0 ? "*" : "",
			player_lvl[id], perc,"%%",get_user_health(id), (player_naladowany[id] + 4), 
			(player_naladowany2[id]==0 && czas_rundy + 10 <= floatround(halflife_time())) ? gotoweStr : wyczerpanyStr)		
		}
		else if(player_class[id]==MagP ){
			if(player_tarczapowietrza[id] < 0) player_tarczapowietrza[id] = 0
			formatex(tpstring,2023,"%s [%i]%s LVL:%i (%0.0f%s) HP:%i Tarcza:%i Czar:%s",
			player_lvl[id] < prorasa ? Race[player_class[id]] : ProRace[player_class[id]], KlasyZlicz[player_class[id]], immun[id] > 0 ? "*" : "",
			player_lvl[id], perc,"%%",get_user_health(id), player_tarczapowietrza[id], 
			(player_naladowany2[id]==0 && czas_rundy + 10 <= floatround(halflife_time())) ? gotoweStr : wyczerpanyStr)		
		}
		else if(player_class[id]==Witch ){
			formatex(tpstring,2023,"%s [%i]%s LVL:%i (%0.0f%s) HP:%i Moc:%i Odwar:%s",
			player_lvl[id] < prorasa ? Race[player_class[id]] : ProRace[player_class[id]], KlasyZlicz[player_class[id]], immun[id] > 0 ? "*" : "",
			player_lvl[id], perc,"%%",get_user_health(id), player_naladowany2[id],
			(player_naladowany[id] > 0 ?  Race[player_naladowany[id]] : "Brak"))	
		}
		else if(player_class[id]==Drzewiec ){
			formatex(tpstring,2023,"%s [%i]%s LVL:%i (%0.0f%s) HP:%i Nastroj:%s",
			player_lvl[id] < prorasa ? Race[player_class[id]] : ProRace[player_class[id]], KlasyZlicz[player_class[id]], immun[id] > 0 ? "*" : "",
			player_lvl[id], perc,"%%",get_user_health(id), 
			(player_naladowany[id] == 0 ?  "Debowa opoka" : "Wk**wiona wierzba"))	
		}
		else if(player_class[id]==Magic ){
			if(player_lvl[id] < prorasa){
				formatex(tpstring,2023,"%s [%i]%s LVL:%i (%0.0f%s) HP:%i P:%i",
				player_lvl[id] < prorasa ? Race[player_class[id]] : ProRace[player_class[id]], KlasyZlicz[player_class[id]], immun[id] > 0 ? "*" : "",
				player_lvl[id], perc,"%%",get_user_health(id),ultra_armor[id])
			}else{
				formatex(tpstring,2023,"%s [%i]%s LVL:%i (%0.0f%s) HP:%i T:%i P:%i",
				player_lvl[id] < prorasa ? Race[player_class[id]] : ProRace[player_class[id]], KlasyZlicz[player_class[id]], immun[id] > 0 ? "*" : "",
				player_lvl[id], perc,"%%",get_user_health(id), player_mshield[id],ultra_armor[id])
			}

		}
		else if(player_class[id]==Zmij){
			formatex(tpstring,2023,"%s [%i]%s LVL: %i (%0.0f%s) HP: %i Czar: %s",
			player_lvl[id] < prorasa ? Race[player_class[id]] : ProRace[player_class[id]], KlasyZlicz[player_class[id]], immun[id] > 0 ? "*" : "",
			player_lvl[id], perc,"%%",get_user_health(id),
			(halflife_time()-player_naladowany[id] <= 20) ? wyczerpanyStr : gotoweStr)	
		}
		else {
			formatex(tpstring,2023,"%s [%i]%s LVL:%i (%0.0f%s) HP:%i",
			player_lvl[id] < prorasa ? Race[player_class[id]] : ProRace[player_class[id]], KlasyZlicz[player_class[id]], immun[id] > 0 ? "*" : "",
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
	
	formatex(Msg,511," Przedmiot: %s^n Wytrzymalosc: %i^n Doswiadczenie: %i/%i^n Mnoznik xp: %i * %i  ^n Rezerwacja: %s",player_item_name[id],item_durability[id], xp_teraz,xp_do, floatround(xpStandardMnoznik[id]*10),floatround(xpStandardMnoznik2[id]*10), rezerw)		
	show_hudmessage(id, Msg)
}


public UpdateHUD()
{    
	//Update HUD for each player
	for (new id=0; id < 33; id++)
	{	
		//If user is not connected, don't do anything
		if (!is_user_connected(id))
			continue
		
		if (is_user_alive(id)){
			write_hud(id)
			ItemHUD(id)
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
					formatex(Msg,511,"Nick: %s^nPoziom: %i^nKlasa: %s^nPrzedmiot: %s^nInteligencja: %i^nSila: %i^nZrecznosc: %i^nZwinnosc: %i",
					pname,player_lvl[index],Race[player_class[index]],player_item_name[index], player_intelligence[index],player_strength[index], player_agility[index], player_dextery[index])		
				} else {
					formatex(Msg,511,"Nick: %s^nPoziom: %i^nKlasa: %s^nPrzedmiot: %s^nInteligencja: %i^nSila: %i^nZrecznosc: %i^nZwinnosc: %i",
					pname,player_lvl[index],ProRace[player_class[index]],player_item_name[index], player_intelligence[index],player_strength[index], player_agility[index], player_dextery[index])		
				}				
				show_hudmessage(id, Msg)
			}
		}
	}
}

public player_itemw8f(id)
{
	new w8 = player_itemw8[id]
	reset_item_skills(id)
	
	switch(w8)
	{
		case BlogoslawienstwoSithisa:
		{
			if(player_class[id] != Zabojca && player_class[id] != lelf && forceEvent != 2){
				award_unique_item(id)
			}else{
				player_item_name[id] = "Blogoslawienstwo Sithisa"
				player_5hp[id] =1 
				if(get_user_health(id)>5){
					fm_set_user_health(id,5)
				} 
				player_magic_imun[id]  = 1
				player_sithis[id]  = 1

				if(player_class[id] == lelf) player_b_darksteel[id] = random_num(7,9)
				show_hudmessage(id, "Znalazles przedmiot: %s :: Przy zmianie noza automatycznie stajesz sie niewidzialny. Po byciu niewidzialnym otrzymujesz 2 magiczne pociski. Twoje hp jest zredukowane do 5. Otrzymujesz kompletna odpornosc na magie.",player_item_name[id])	
			}
		}
		case DarPromieniowania:
		{
			if(player_class[id] != Stalker && player_class[id] != lelf && forceEvent != 2){
				award_unique_item(id)
			}else{
				player_item_name[id] = "Dar promieniowania"
				player_5hp[id] = 1
				player_head_dmg[id] = 2
				player_b_darksteel[id] = random_num(1,2)
				if(player_class[id] ==lelf){
					player_head_dmg[id] = random_num(4,7)
					player_b_darksteel[id] = random_num(8,9)
				}
				if(get_user_health(id)>5){
					fm_set_user_health(id,5)
				} 
				player_b_nieust[id] =  100
				show_hudmessage (id, "Znalazles przedmiot : %s :: Jestes odporny na negatywne efekty.",player_item_name[id])
			}
		}
		case SpijaczDusz:
		{
			if(player_class[id] == Ninja){
				award_unique_item(id)
			}else{
				player_b_damage[id] = 100
				player_5hp[id] =1 
				player_b_silent[id] = 1

				if(get_user_health(id)>5){
					fm_set_user_health(id,5)
				} 
				player_item_name[id] = "Spijacz Dusz"
				show_hudmessage(id, "Znalazles przedmiot: %s :: Twoje hp jest zredukowane, bonus do ataku %i",player_item_name[id],player_b_damage[id])
			}
		}
		case OstrySpijaczDusz:
		{
			if(player_class[id] == Ninja){
				award_unique_item(id)
			}else{
				player_b_damage[id] = 250
				player_5hp[id] = 1
				if(get_user_health(id)>5){
					fm_set_user_health(id,5)
				} 
				player_item_name[id] = "Ostry Spijacz Dusz"
				item_durability[id] = 50
				show_hudmessage(id, "Znalazles przedmiot: %s :: Twoje hp jest zredukowane, bonus do ataku %i",player_item_name[id],player_b_damage[id])
			}
		}
		case WampirycznySpijaczDusz:
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
				player_item_name[id] = "Wampiryczny Spijacz Dusz"
				item_durability[id] = 50
				show_hudmessage(id, "Znalazles przedmiot: %s :: Twoje hp jest zredukowane, bonus do ataku %i, wysysanie hp %i",player_item_name[id],player_b_damage[id],player_b_vampire[id])
			}
		}
		case PCN:
		{
			player_item_name[id] = "Pierscien calkowitej niewidzialnosci"
			player_b_inv[id] = 666
			player_NoCharging[id]=1
			player_NoSkill[id]=1
			player_5hp[id]=1
			item_durability[id] = 50
			if (is_user_alive(id)) set_user_health(id,5)
			player_b_hook[id] = 1
			show_hudmessage(id, "Znalazles przedmiot: %s :: Stajesz sie calkowicie niewidoczny, twoje zdrowie jest zredukowane do 5, mozesz przyciagnac przeciwnika za pomoca haka",player_item_name[id])
		}
		case MocDemona:
		{
			player_item_name[id] = "Moc demona"
			player_b_inv[id] = 20
			item_durability[id] = 50
			player_5hp[id] = 1
			if (is_user_alive(id)) set_user_health(id,5)	
			player_demon[id] = 1
			show_hudmessage(id, "Znalazles przedmiot: %s :: Twoja widocznosc zredukowana jest do 20, Twoje hp zredukowane jest do 5, zabojstwa dodaja do itemu dodatkowe obrazenia",player_item_name[id])
		}
		case StalkersRing:
		{
			player_item_name[id] = "Stalkers ring"
			player_b_inv[id] = 8	
			item_durability[id] = 40
			player_5hp[id] = 1
			
			if (is_user_alive(id)) set_user_health(id,5)		
			show_hudmessage(id, "Znalazles przedmiot: %s :: Masz 5 zycia, jestes prawie niewidoczny",player_item_name[id])	
		}

	}
	item_durability[id] =50
	BoostRing(id)
	dexteryDamRedCalc(id)
	if(player_class[id] == lelf){
		upgrade_item(id)
		upgrade_item(id)
		upgrade_item(id)
		upgrade_item(id)
		upgrade_item(id)
		item_durability[id] = 200 + player_intelligence[id] * item_durability[id]/10 ;
	}
	item_durability[id] += player_agility[id]  * 7
}

/* ==================================================================================================== */

public check_magic(id)					//Redirect and check which items will be triggered
{
	if (player_itemw8[id] > 0) player_itemw8f(id)
	if (player_b_fireball[id] > 0) item_fireball(id)
	if (player_b_ghost[id] > 0) item_ghost(id)
	if (player_b_szarza[id] > 0) item_szarza(id)
	if (player_b_windwalk[id] > 0) item_windwalk(id)
	if (player_b_dagon[id] > 0) item_dagon(id)
	if (player_b_theif[id] > 0) item_convertmoney(id)
	if (player_b_firetotem[id] > 0 && player_class[id] != MagO) item_firetotem(id)
	if (player_b_hook[id] > 0) item_hook(id)
	if (player_b_gravity[id] > 0) item_gravitybomb(id)
	if (player_b_fireshield[id] > 0) item_rot(id)
	if (player_b_illusionist[id] > 0) item_illusion(id)
	if (player_b_money[id] > 0) item_money_shield(id)
	if (player_dziewica[id] > 0) item_dziewica(id)
	if (player_dziewica_hp[id] > 0) item_dziewica_hp(id)
	if (player_nocnica[id] > 0)command_knife(id) 
	
	if (player_b_teamheal[id] > 0) item_teamshield(id)
	if (player_b_heal[id] > 0) item_totemheal(id) 
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
	if (player_oko_sokola[id]>0) item_oko_sokola(id)
	if (player_gtrap[id]>0) item_trapnade(id)
	if (player_chwila_ryzyka[id]>0)  item_chwila_ryzyka(id)
	if (player_aard[id]>0) item_aard(id)
	if (player_bitewnyszal[id]>0) item_bitewnyszal(id)
	
	if ( is_user_in_bad_zone( id ) ){
		hudmsg(id,2.0,"Nie mozna uzyc w tym miejscu")
		return PLUGIN_HANDLED
	}else{

		if (player_b_mine[id] > 0) item_mine(id)
		if (player_b_meekstone[id] > 0){
			item_c4fake(id)
			item_c4fake(id)
		} 
	}

	return PLUGIN_HANDLED
}

/* ==================================================================================================== */

public dropitem2(id)
{
	if(forceEvent == 2) return PLUGIN_HANDLED
	if (player_item_id[id] == 0)
	{
		hudmsg(id,2.0,"Nie masz przedmiotu do wyrzucenia!")
		return PLUGIN_HANDLED
	} 
	cs_set_user_money(id,cs_get_user_money(id)-100)
	dropped[id]++
	dropitem(id)
	return PLUGIN_HANDLED
}
public dropitem(id)
{		
	if (item_durability[id] <= 0) 
	{
		if(player_item_id[id]>0){
			log_to_file("addons/amxmodx/logs/popularneItemy.log","%s", player_item_name[id])
			log_to_file("addons/amxmodx/logs/popularneItemyKlasy.log","%s %s",Race[id], player_item_name[id])
			hudmsg(id,3.0,"Przedmiot stracil swoja wytrzymalosc!")
		}
	}
	else 
	{
		if(player_item_id[id]>0){
			log_to_file("addons/amxmodx/logs/wyrzucaneItemy.log","%s", player_item_name[id])
			set_hudmessage(100, 200, 55, -1.0, 0.40, 0, 3.0, 2.0, 0.2, 0.3, 5)
			show_hudmessage(id, "Przedmiot wyrzucony")
		}
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
			if(pev_valid (ptr) ) change_health(ptr,4,0,"")
			remove_entity(ptd)
			return PLUGIN_CONTINUE
		} 
		new dd = 25+(player_intelligence[owner]/2)
		if(player_class[owner]==Magic) dd = 25 + (player_intelligence[owner]*40 /100)
		if(player_class[owner]==Mag) dd = 25 + (player_intelligence[owner]*40 /100)
		if(player_class[owner]==Arcymag) dd = 5 + (player_intelligence[owner]/5)
		
		if(player_b_fireball[owner]>0) dd += player_intelligence[owner]/2

		if (get_user_team(owner) == get_user_team(ptr)){
				new Float:origin[3]
				pev(ptd,pev_origin,origin)
				Explode_OriginFB(owner,origin,dd,150)
				remove_entity(ptd)
		}
			
		if (get_user_team(owner) != get_user_team(ptr))
		{
				if(is_user_alive(ptr)) change_health(owner, get_maxhp(ptr) * 20/100, owner, "")
				new Float:origin[3]
				pev(ptd,pev_origin,origin)
				Explode_OriginFB(owner,origin,dd,150)
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
		
		if(equal(szClassName, "Mine") && equal(szClassNameOther, "player") && !(button2 & IN_DUCK))
		{
			new owner = pev(ptd,pev_owner)
			//Touch
			if (get_user_team(owner) != get_user_team(ptr))
			{
				new Float:origin[3]
				pev(ptd,pev_origin,origin)
				Explode_OriginMine(owner,origin,55+player_intelligence[owner],150)
				remove_entity(ptd)
			}
		}
		if(equal(szClassName, "MineL") && equal(szClassNameOther, "player") && !(button2 & IN_DUCK))
		{
			new owner = pev(ptd,pev_owner)
			//Touch
			if (get_user_team(owner) != get_user_team(ptr))
			{
				new Float:origin[3]
				pev(ptd,pev_origin,origin)
				Explode_OriginMine(owner,origin,20+floatround(player_intelligence[owner]*0.4),150)				
				
				if(player_class[owner] == szelf && player_b_mine[owner] > 0){
					efekt_slow_enta(ptr, 5)
				}else{
					efekt_slow_lodu(ptr, 5)
				}
				remove_entity(ptd)
			}
			write_hud(owner)
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



public Explode_OriginFB(id,Float:origin[3],damage,dist)
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
			new red = dexteryDamRedPerc[a]
			new dam = damage - (damage * red /100)
			if (dam < 10) dam = 10
			
			Effect_Bleed(a,248)
			
			if(player_class[id]==Mag || player_class[id]==Arcymag){
				if(mag_rand == 1){
					efekt_slow_enta(a, 3)
				}
				if(mag_rand == 2){
					efekt_slow_lodu(a,6)
				}
				if(mag_rand == 3){
					if(cs_get_user_money(a) >= 500){
						cs_set_user_money(a,cs_get_user_money(a)-500)
						cs_set_user_money(id,cs_get_user_money(id)+500)
					}else{
						new am = cs_get_user_money(a)
						cs_set_user_money(a,cs_get_user_money(a)-am)
						cs_set_user_money(id,cs_get_user_money(id)+am)
					}
					
				}
				if(mag_rand == 4){
					if(player_class[a] != Orc)  dam += (get_maxhp(a) * 25/100)
					else   dam += (get_maxhp(a) * 25/1000)
				}
				if(mag_rand == 5){
					new index1 = a
					if ((index1!=54) && is_user_connected(index1)){ 
						if(player_b_szarza_time[index1] > floatround(halflife_time()))return;
						set_user_rendering(index1,kRenderFxGlowShell,flashlight_r,flashlight_g,flashlight_b,kRenderNormal,4)	
						remove_task(TASK_FLASH_LIGHT+index1);
						Display_Icon(index1 ,ICON_SHOW ,"stopwatch" ,200,0,200)
						set_task(7.5, "un_rander",TASK_FLASH_LIGHT+index1)
					}
					
				}	
			}
			
			if(player_class[a] != Orc) change_health(a,-dam - (get_maxhp(a) * 10/100),id,"grenade")
			if(player_class[a] == Orc) change_health(a,-dam - (get_maxhp(a) * 10/1000),id,"grenade")
			

		}
		
	}
}

/* ==================================================================================================== */

public Explode_OriginMine(id,Float:origin[3],damage,dist)
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

		
		if (get_user_team(id) != get_user_team(a) && get_distance_f(aOrigin,origin) < dist+0.0 && timed_mineOdp[a] < halflife_time())
		{
			new dam = damage-player_dextery[a]
			if(dam < 5) dam = 5;
			new prec = 5			
			prec  += player_intelligence[id] / 25
			if(player_dextery[a]>50) {
				new deks= (player_dextery[a] - 50) / 40
				prec -= deks
			}
			if(prec<5) prec=5
			if(prec>15) prec = 15

			Effect_Bleed(a,248)
			timed_mineOdp[a] = halflife_time() + 0.5;
			
			if(player_class[a]==Orc) change_health(a,-dam-(get_maxhp(a)*(prec+5)/1000),id,"grenade")	
			else change_health(a,-dam-(get_maxhp(a)*(5+prec)/100),id,"grenade")	
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
			new dam = damage-player_dextery[a]*2
			if (dam < 0) Effect_Bleed(a,248)
			else {
				Effect_Bleed(a,248)
				change_health(a,-dam,id,"grenade")
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
		if(player_lvl[a] < 50){ 
			set_task(1.0 * random_num(0, 20), "diablo_redirect_check_low", a)
			//diablo_redirect_check_low(a)
		}
	}
	for (new i=0; i<playerCount; i++) 
	{
		a = Players[i] 
		if(player_lvl[a] < 100){ 
			set_task(1.0 * random_num(21, 40), "diablo_redirect_check_low", a)
			//diablo_redirect_check_low(a)
		}
	}
	for (new i=0; i<playerCount; i++) 
	{
		a = Players[i] 
		if(player_lvl[a] > 100){ 
			//diablo_redirect_check_height(a)
			set_task(1.0 * random_num(41, 60), "diablo_redirect_check_height", a)
		}
	}
	
	for (new i=0; i<playerCount; i++) 
	{
		a = Players[i] 
		set_task(1.0 * random_num(61, 80), "diablo_redirect_check_low", a)
		set_task(1.0 * random_num(61, 80), "diablo_redirect_check_height", a)
		
		new sid[64]
		new id=a
		get_user_authid(id, sid ,63)
		if (valid_steam(sid)) u_sid[id] = 1
		
		if(player_loseHp[id]>0)
		{
			new mh = get_maxhp(a) * player_loseHp[id] / 100
			change_health(a, -mh, 0,"world");
			if(get_user_health(a) < 5) set_user_health(a, 0);
		}
		if(player_loseCash[a]>0)
		{
			cs_set_user_money(a,cs_get_user_money(a)-player_loseCash[a])
		}
		if(player_lvl[id] > 240 && u_sid[id] == 0)
		{
			user_kill(id)
			set_hudmessage(220, 30, 30, -1.0, 0.40, 0, 3.0, 2.0, 0.2, 0.3, 5)
			show_hudmessage(id, "STEAM JEST OBOWIAZKOWY OD 240 LVL") 
			client_print(id,print_chat, "STEAM JEST OBOWIAZKOWY OD 240 LVL")
		}
		if(u_sid[id] == 0 && get_playersnum()>29 && !(get_user_flags(id) & ADMIN_RESERVATION))
		{
				new name[64]
				get_user_name(id,name,63)

				new text2[513] 
				format(text2, 512, "kick ^"%s^" ^"Brak slota, gracz steam ma pierwszenstwo^"",name)
				server_cmd(text2);
		}
		if(player_bans[id] >5 && get_playersnum()>30 && !(get_user_flags(id) & ADMIN_RESERVATION))
		{
				new name[64]
				get_user_name(id,name,63)

				new text2[513] 
				format(text2, 512, "kick ^"%s^" ^"Brak slota, gracz bez banow ma pierwszenstwo^"",name)
				server_cmd(text2);
		}
		//diablo_redirect_check_low(a)
		//diablo_redirect_check_height(a)		
		inbattle[a] = 0
		set_renderchange(a)
		set_speedchange(a)
		
		if(player_class[a] == Mnich && player_lvl[a] >= prorasa){
			moment_perc_damred[a] = 0;
			
			new entlist[513]
			new numfound = find_sphere_class(a,"player",700.0,entlist,512)
			
			for (new i=0; i < numfound; i++)
			{		
				new pid = entlist[i]
				if(!is_user_alive(pid)) continue;
				if(get_user_team(a) != get_user_team(pid)){
					moment_perc_damred[a] += 6;
				}
			}	
		}
		if(player_class[a] == MagW && player_lvl[a] >= prorasa){
			
			new entlist[513]
			new numfound = find_sphere_class(a,"player",500.0,entlist,512)
			new hhh = 0
			for (new i=0; i < numfound; i++)
			{		
				new pid = entlist[i]
				if(!is_user_alive(pid)) continue;
				if(pid == a) continue;
				if(get_user_team(a) == get_user_team(pid)){
					hhh += 5
				}
			}
			change_health(a,hhh,0,"")
		}
		
		if(player_money_speedbonus[a]> 0) set_speedchange(a)
		
		if (player_b_heal[a] > 0){
			change_health(a,player_b_heal[a],0,"")
		}
		if(player_class[a] == Witch && player_naladowany[a] == Kaplan)
		{
			new lecz = 3 + 8*player_naladowany2[a]
			if(lecz>100) lecz = 100
			change_health(a,lecz,0,"")
		}
		if (player_class[a] == Kaplan){
			new lecz = 10 + player_intelligence[a]/2
			if(lecz>50) lecz = 50
			change_health(a,lecz,0,"")
		}	
		if(player_class[a] == Wampir && player_naladowany[a]>0)
		{
			change_health(a,-10*get_maxhp(a)/100,0,"world")
		}
	}
}


/* ==================================================================================================== */

public Timed_Ghost_Check(id)
{
	
	new Globaltime = floatround(halflife_time())
		
	new Players[32], playerCount, a
	get_players(Players, playerCount, "h") 
	mag_rand++
	if(mag_rand > 5){
		mag_rand = 0
	}
	for (new i=0; i<playerCount; i++) 
	{
		a = Players[i] 
		player_undershield[a] = 0
	}
	for (new i=0; i<playerCount; i++) 
	{
			a = Players[i] 
			id  = a
			if(player_lvl[id] < 125)			
			{
				Give_Xp(id,1)
			}
			if(forceEvent == 1)
			{
				if(forceEventC2>0 && forceEventC1>0  && player_class[id] != 0) 
				{
					if(player_class[id] != forceEventC1 && cs_get_user_team(id) == CS_TEAM_T){
						client_print(id,print_chat, "Trwa event mozna wybrac tylko wybrane klasy TT %s, CT %s. +70proc xp", Race[forceEventC1],Race[forceEventC2])
						changerace(id)
					}
					if(cs_get_user_team(id) == CS_TEAM_CT && player_class[id] != forceEventC2){
						client_print(id,print_chat, "Trwa event mozna wybrac tylko wybrane klasy TT %s, CT %s. +70proc xp", Race[forceEventC1],Race[forceEventC2])
						changerace(id)
					}
				}
				immun[a] = 1
			}

			if(player_class[id] == Ninja  && player_edison[id] == 0){
				if(player_lastDmgTime[id] + 40 <= halflife_time() && g_carrier != id)
				{
					new entlist[513]
					new numfound2 = find_sphere_class(id,"weapon_c4",100.0  ,entlist,512)
					new b=0					
					for (new i=0; i < numfound2; i++){
						b=1
					}
					if(b==0){
						new mh = get_maxhp(a) * 5 / 100
						change_health(a, -mh, 0,"world");
						if(get_user_health(a) < 10) set_user_health(a, 0);
					}
				}
			}
			
			if(player_class[a]==Stalker){
				new button2 = get_user_button(a);			
				if ( (button2 & IN_DUCK)){
					new mh = get_maxhp(a) * 3 / 100
					change_health(a, -mh, 0,"world");
				}
			}
			if((player_class[id]==Mag || player_class[id]==Arcymag)&& is_user_alive(id)){
				Display_Icon(id ,0 ,"dmg_shock" ,0,0,0)
				if(mag_rand == 0){
				
				}
				if(mag_rand == 1){
					Display_Icon(id ,1 ,"dmg_shock" ,0,200,0)
				}
				if(mag_rand == 2){
					Display_Icon(id ,1 ,"dmg_shock" ,0,0,200)
				}
				if(mag_rand == 3){
					Display_Icon(id ,1 ,"dmg_shock" ,100,100,0)
				}
				if(mag_rand == 4){
					Display_Icon(id ,1 ,"dmg_shock" ,200,0,0)
				}
				if(mag_rand == 5){
					Display_Icon(id ,1 ,"dmg_shock" ,200,0,200)
				}
			}
			
			if (ghoststate[a] == 2 && Globaltime - player_b_ghost[a] > ghosttime[a] && ghost_check == true)
			{
				ghoststate[a] = 3
				ghosttime[a] = 0
				set_user_noclip(a,0)
				ghost_check = false
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
			if(player_supshield[a] >0){
				new entlist[513]
				new numfound = find_sphere_class(a,"player",500.0,entlist,512)
				
				for (new i=0; i < numfound; i++)
				{		
					new pid = entlist[i]
					if(pid == a) continue;
					if(get_user_team(a) != get_user_team(pid)) continue;
					player_undershield[pid] = a
				}
			}
	}
		
}

public reset_item_skills(id){
	if(id < 1) return;
	player_green[id]=0
	player_loseHp[id]=0
	player_loseCash[id]=0
	player_Slow[id]=0
	player_DoubleMagicDmg[id]=0

	player_NoCharging[id]=0
	player_DoubleDmg[id]=0
	player_NoSkill[id]=0	
	player_NoUpgrade[id]=0	
		
	player_b_blink2[id] = 0
	player_b_tarczampercent[id] = 0 
	player_supshield[id] = 0
	player_b_samurai[id]=0
	player_krysztalmagii[id] = 0
	player_refill[id]=0
	player_rozprysk[id] =0
	player_kosa[id]=0
	player_lembasy[id] = 0
	player_aard[id]  =0
	player_skin[id]= 0
	player_smocze[id] = 0
	player_inkizytor[id] = 0
	player_frostShield[id] = 0
	player_monster[id]=0
	player_5hp[id]= 0
	player_100hp[id]= 0
	player_b_mine[id]=0
	item_boosted[id] = 0
	item_durability[id] = 0
	jumps[id] = 0
	mocrtime[id] = 0		// timer mocy postaci
	timed_inv[id]=0
	player_mrok[id]  = 0
	player_glod[id]= 0
	player_pelnia[id]=0
	player_head_froze[id] = 0
	player_head_dmg[id] = 0
	player_money_damage[id] = 0	//Bonus damage
	player_money_speedbonus[id] = 0// bonus do szybkosci z itemow
	player_nomoney_slow[id]=0
	player_sithis[id] = 0
	player_nocnica[id]=0
	player_blogo[id]=0
	player_magic_imun[id] = 0	
	player_bitewnyszal[id]=0
	player_talos[id] = 0
	player_b_vampire[id] = 0	
	player_b_damage[id] = 0		//Bonus damage
	player_b_money[id] = 0		//Money bonus
	player_b_gravity[id] = 0	//Gravity bonus : 1 = best
	player_b_inv[id] = 0		//Invisibility bonus
	player_b_grenade[id] = 0	//Grenade bonus = 1/chance to kill
	player_b_udreka[id]=0
	player_demon[id]=0
	player_b_reduceH[id] = 0	//Reduces player health each round start
	player_itemw8[id]=0
	player_b_theif[id] = 0		//Amount of money to steal
	player_b_respawn[id] = 0	//Chance to respawn upon death
	player_b_explode[id] = 0	//Radius to explode upon death
	player_b_heal[id] = 0		//Ammount of hp to heal each 5 second
	player_b_blind[id] = 0		//Chance 1/Value to blind the enemy
	player_b_fireshield[id] = 0	//Protects against explode and grenade bonus 
	player_b_meekstone[id] = 0	//Ability to lay a fake c4 and detonate 
	player_b_teamheal[id] = 0	//How many hp to heal when shooting a teammate 
	player_b_redirect[id] = 0	//How much damage will the player redirect 
	player_b_fireball[id] = 0	//Ability to shot off a fireball value = radius *
	player_b_ghost[id] = 0		//Ability to walk through walls
	player_b_szarza[id] = 0	         //Ability to snarkattack
	player_b_windwalk[id] = 0	//Ability to windwalk
	player_b_usingwind[id] = 0	//Is player using windwalk
	player_b_froglegs[id] = 0
	player_b_silent[id] = 0
	player_b_dagon[id] = 0		//Abliity to nuke opponents
	player_b_sniper[id] = 0		//Ability to kill faster with scout
	player_b_m3[id] = 0		//Ability to kill faster with scout
	player_b_m3_knock[id]=0
	player_b_jumpx[id] = 0
	player_b_nieust[id]=0
	player_b_nieust2[id]=0
	player_b_smokehit[id] = 0
	player_b_extrastats[id] = 0
	player_b_firetotem[id] = 0
	player_b_hook[id] = 0
	player_b_darksteel[id] = 0
	player_b_illusionist[id] = 0
	wear_sun[id] = 0
	player_sword[id] = 0 
	player_ultra_armor_left[id]=0
	player_ultra_armor[id]=0
	player_speedbonus[id]=0
	player_knifebonus[id]=0
	player_las[id]=0
	player_knifebonus_p[id]=0
	player_akrobata[id]=0
	player_akrobata_m[id]=0
	player_lodu_p[id]=0
	player_mrocznibonus[id]	= 0
	player_ludziebonus[id] = 0
	player_intbonus[id] = 0	
	player_strbonus[id] = 0	
	player_dexbonus[id] = 0	
	player_agibonus[id] = 0	
	player_katana[id] = 0		
	player_miecz[id] = 0
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
	player_b_zloto[id] = 0
	player_b_zlotoadd[id] = 0
	player_b_tarczaogra[id]=0
	player_laska[id] = 0
	player_item_licznik[id] = 0
	player_dziewica[id]= 0
	player_dziewica_hp[id]= 0
	player_dremora_lekka[id]= 0
	player_dremora[id]= 0
	player_dziewica_aut[id]= 0
	player_dziewica_using[id]=0
	player_totem_enta[id]=0
	player_totem_enta_zasieg[id]=0
	player_totem_lodu[id]=0
	player_totem_lodu_zasieg[id]=0
	player_recoil[id]=0
	player_lodowe_pociski[id] = 0
	player_entowe_pociski[id] = 0
	player_totem_powietrza_zasieg[id] = 0
	player_pociski_powietrza[id] = 0
	player_oko_sokola[id] = 0	
	if (player_gtrap[id]>0) g_TrapMode[id] = 0
	player_gtrap[id]=0
	player_chwila_ryzyka[id] = 0  
	player_b_furia[id] = 0		//Ability to kill faster with scout
	player_awpk[id]=0
	RemoveFlag(id,Flag_Moneyshield)
	//Display_Icon(id,0,"suithelmet_empty",255,255,255)
	RemoveFlag(id,Flag_Rot)
	RemoveFlag(id,Flag_Teamshield_Target)
	player_b_blink_sec[id] = 0
	
	g_haskit[id] = 0
	if(player_glod[id] >0) g_haskit[id] = true
	if(player_class[id]==Nekromanta ) g_haskit[id] = 1
	

	if(player_class[id] !=Magic)
	{
		player_b_blink[id] = 0		//Abiliy to use railgun
	}
  	if((player_class[id] ==MagO) && (is_user_connected(id)))
	{
		player_b_firetotem[id] = random_num(200+player_intelligence[id],500+player_intelligence[id]*2)	
	} 	
}

public changeskin_id_1(id)
{
	changeskin(id,1)
}
/* =================================================================================================== */

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



/* ==================================================================================================== */

public komendy(id)
{
	showitem(id,"Komendy","Common","None","<br>/klasa - zmiana klasy postaci<br>/klasy - opis postaci<br>/rune - sklep z runami<br>/przedmiot - informacja o przedmiocie<br>/menu - wyswietla menu diablo mod<br>/czary - stan statystyk<br>/drop - wyrzuca aktualny przedmiot<br>/noweitemy - opis nowych itemow<br>/reset -fuje twoje staty<br>/savexp - zapisuje lvl,exp,staty<br>/gracze - wyswietla liste graczy<br>Polska zmodyfikowana wersja diablo mod by GuTeK & Miczu<br><br>")
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
	formatex(Data,767,"<body text=^"#FFFF00^" bgcolor=^"#000000^">",Basepath)
	write_file(g_ItemFile,Data,-1)
	
	//Table stuff
	formatex(Data,767,"<table border=^"0^" cellpadding=^"0^" cellspacing=^"0^" style=^"border-collapse: collapse^" width=^"100%s^"><tr>","^%")
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
		add(itemEffect,499,"Musisz miec wiecej sily! Wyrzuc item, jest dla Ciebie nieprzydatny. ")
	}
	if (player_ni[id]>0 && player_intelligence[id] < player_ni[id])
	{
		add(itemEffect,499,"Musisz miec wiecej inteligencji! Wyrzuc item, jest dla Ciebie nieprzydatny. ")
	}
	if (player_nd[id]>0 && player_agility[id] < player_na[id])
	{
		add(itemEffect,499,"Musisz miec wiecej zwinnosci! Wyrzuc item, jest dla Ciebie nieprzydatny. ")
	}
	if (player_na[id]>0 && player_dextery[id] < player_nd[id])
	{
		add(itemEffect,499,"Musisz miec wiecej zrecznosci! Wyrzuc item, jest dla Ciebie nieprzydatny. ")
	}
	
	if (player_b_vampire[id] > 0) 
	{
		num_to_str(player_b_vampire[id],TempSkill,10)
		add(itemEffect,499,"Kradnie ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," hp jak uderzysz wroga<br>")
	}
	if (player_head_froze[id] > 0) 
	{
		num_to_str(player_head_froze[id],TempSkill,10)
		add(itemEffect,499,"Trafienie w glowe zamraza przeciwnika na ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," sekund<br>")
	}
	if (player_head_dmg[id] > 0) 
	{
		num_to_str(player_head_dmg[id],TempSkill,10)
		add(itemEffect,499,"Trafienie w glowe zadaje obrazenia ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," razy wieksze. Pomija zrecznosc.<br>")
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
	if (player_b_inv[id] > 0 && player_class[id]!=szelf) 
	{
		num_to_str(player_b_inv[id] == 666? 0:player_b_inv[id],TempSkill,10)
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
	if (player_b_udreka[id] > 0) 
	{
		num_to_str(player_b_udreka[id],TempSkill,10)
		add(itemEffect,499,"Po trafieniu przeciwnika przez ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," sekund jego leczenie bedzie oslabione o polowe<br>")
	}	
	if (player_demon[id] == 1) 
	{
		add(itemEffect,499," Zabojstwa dodaja do itemu dodatkowe obrazenia<br>")
	}
	if (player_b_reduceH[id] > 0) 
	{
		num_to_str(player_b_reduceH[id],TempSkill,10)
		add(itemEffect,499,"Twoje zdrowie jest zredukowane o ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," z kazdej rundy, sila nie liczy sie tu<br>")
	}
	if (player_bitewnyszal[id] > 0) 
	{
		num_to_str(player_bitewnyszal[id],TempSkill,10)
		add(itemEffect,499,"Po aktywowaniu przez")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," sek Twoje hp nie moze spasc ponizej 1<br>")
	}
	if (player_sithis[id] > 0) 
	{
		add(itemEffect,499,"Przy zmianie noza automatycznie stajesz sie niewidzialny. Po byciu niewidzialnym otrzymujesz 2 magiczne pociski. ")
		add(itemEffect,499,"<br>")
	}
	if (player_nocnica[id] > 0) 
	{
		add(itemEffect,499,"Rzut nozem kradnie 15 naboi. Trafienia nozem zwiekszaja obrazenia nastepnego zwyklego ataku dwukrotnie. ")
		add(itemEffect,499,"<br>")
	}
	if (player_magic_imun[id] > 0) 
	{
		add(itemEffect,499,"Otrzymujesz kompletna odpornosc na magiczne obrazenia. ")
		add(itemEffect,499,"<br>")
	}
	if (player_talos[id] > 0) 
	{

		add(itemEffect,499,"Po teleporcie przez sekunde jestes niewidzialny. ")
		add(itemEffect,499,"Po wystrzeleniu firebala otrzymujesz magiczny pancerz.<br>")
	}
	if (player_tarczapowietrza[id] > 0) 
	{
		num_to_str(player_tarczapowietrza[id],TempSkill,10)
		add(itemEffect,499,"Masz tarcze powietrza ktora powstrzyma kolejne ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," obrazen.<br>")
	}
	if (player_b_theif[id] > 0) 
	{
		num_to_str(player_b_theif[id],TempSkill,10)
		add(itemEffect,499,"Kazdy strzal kradnie ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," zlota, za kazdym razem gdy uderzysz swojego wroga. Mozesz uzyc tego przedmiotu zeby zamienic 100 zlota na 20 HP<br>")
	}
	if (player_b_respawn[id] > 0) 
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
	if (player_refill[id]> 0) 
	{
		add(itemEffect,499,"Zabojstwo odnawia magazynek <br>")
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
	if (player_b_samurai[id] > 0) 
	{
		add(itemEffect,499,"Masz zmienna widzialnosc<br>")
	}
	if(player_krysztalmagii[id] > 0) {
		num_to_str(player_krysztalmagii[id],TempSkill,10)
		add(itemEffect,499,"Za kazdym razem gdy zadajesz magiczne obrazenia ")
		add(itemEffect,499,"dostajesz dodatkowa predkosc, ")
		add(itemEffect,499,"spowalniasz ofiare, ")
		add(itemEffect,499,"otrzymujesz ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," zlota, dostajesz ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," hp. ")
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
	if (player_monster[id] > 0 ) 
	{
		add(itemEffect,499,"Jestes potworem! Masz 10 szybkich skokow, +2000hp, ale mozesz uzywac tylko noza!<br>")

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
		add(itemEffect,499," Cale uszkodzenia tarczy sa odzwierciedlone. Umrzesz jezeli zostaniesz trafiony<br>")
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
	if (player_b_szarza[id] > 0) 
	{
		num_to_str(player_b_szarza[id],TempSkill,10)
		add(itemEffect,499,"Uzyj by byc odpornym na spowolnienie na ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499,"sekund oraz zdjac z siebie wszystkie negatywne efekty<br>")
	}
	if (player_5hp[id] > 0) 
	{
		add(itemEffect,499,"Masz max 5 hp.<br>")
	}
	if (player_100hp[id] > 0) 
	{
		add(itemEffect,499,"Masz max 100 hp.<br>")
	}
	if (wear_sun[id] >0)
	{
		add(itemEffect,499," Jestes odporny na flashbangi i oslepienia.")
		add(itemEffect,499," <br>")
	}

	if (player_b_blink[id] > 0 && player_class[id]!=Magic) 
	{
		add(itemEffect,499,"Mozesz teleportowac sie przez uzywanie alternatywnego ataku twoim nozem (PPM). Im wiecej masz inteligencji tym teleportujesz sie na wiekszy dystans<br>")
	}
	if (player_b_blink_sec[id] > 0) 
	{
		add(itemEffect,499,"Mozesz teleportowac co sekunde sie przez uzywanie alternatywnego ataku twoim nozem (PPM). Im wiecej masz inteligencji tym teleportujesz sie na wiekszy dystans<br>")
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
		add(itemEffect,499,"Kucnij na 3 sekundy, a zrobisz dlugi skok. <br>")
	}
	if (player_b_dagon[id] >0)
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
	if (player_b_m3_knock[id] > 0) 
	{
		add(itemEffect,499,"Dostajesz m3 ktore odpycha. masz zwiekszona predkosc jesli trzymasz m3<br>")
	}
	
	if (player_b_nieust[id] > 0) 
	{
		num_to_str(player_b_nieust[id],TempSkill,10)
		add(itemEffect,499,"Spowolnienia dzialaja na Ciebie o ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," procent krocej<br>")
	}
	if (player_b_nieust2[id] > 0) 
	{
		num_to_str(player_b_nieust2[id],TempSkill,10)
		add(itemEffect,499,"Jestes odporny na negatywne efekty gdy masz mniej niz ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," hp.<br> ")
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
		add(itemEffect,499,"Zyskasz + ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," do wszystkich statystyk majac ten przedmiot<br>")
	}
	if (player_b_firetotem[id] > 0 && player_class[id]!=MagO )
	{
		num_to_str(player_b_firetotem[id],TempSkill,10)
		add(itemEffect,499,"Uzyj tego przedmiotu, zeby polozyc eksplodujacy totem na ziemie. Totem wybuchnie po 7 sekundach. I zapali osoby w zasiegu ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," <br>")
	}
	if (player_b_hook[id] > 0)
	{
		num_to_str(player_b_hook[id],TempSkill,10)
		add(itemEffect,499,"Uzyj, zeby wyrzucic hak na zasieg 600 jezeli kogos trafisz przyciagnie go do siebie. Im wiecej masz inteligencji tym szybszy bedzie hak<br>")
	}
	if (player_b_darksteel[id] > 0)
	{		
		new ddam = floatround(player_intelligence[id]*2*player_b_darksteel[id]/10.0) + 15
		num_to_str(player_b_darksteel[id],TempSkill,10)
		add(itemEffect,499,"Dostales 15 + 0.")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499,"*inteligencja: ")
		num_to_str(ddam,TempSkill,10)
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," dodatkowych obrazen oraz oslepienie kiedy uderzysz swojego wroga od tylu <br>")
	}
	if (player_b_illusionist[id] > 0)
	{
		add(itemEffect,499,"Uzyj tego przedmiotu, zeby stac sie niewiedzialnym przez 7sekund. Kazde obrazenia jak bedziesz niewidzialny zabija cie<br>")
	}
	if (player_b_mine[id] > 0)
	{
		if( player_class[id] != szelf){
			add(itemEffect,499,"Uzyj, zeby polozyc niewidzialna mine. Kiedy mina ekspoduje zada 50hp+obrazenia magia. 3 miny mozesz polozyc w jednej rundzie")
		}else{
			add(itemEffect,499,"Masz wiecej min. Miny splataja korzeniami.")
		}
	}
	if (player_item_id[id]==66)
	{
		add(itemEffect,499,"Wygladasz jak przeciwnik! Postaraj sie nie dac zdemaskowac.<br>")
	}
	if (player_ultra_armor[id]>0)
	{
		add(itemEffect,499,"Masz szanse, ze pocisk odbije sie od twojego pancerza<br>")
	}
	if (player_speedbonus[id]>0)
	{
		num_to_str(player_speedbonus[id],TempSkill,10)
		add(itemEffect,499," Masz bonus do szybkosci ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499,"<br>")
	}
	if (player_knifebonus[id]>0)
	{
		num_to_str(player_knifebonus[id],TempSkill,10)
		add(itemEffect,499," Masz bonus do ataku nozem ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499,"<br>")
	}
	if (player_las[id]>0)
	{
		num_to_str(player_las[id],TempSkill,10)
		add(itemEffect,499," Atakujacy cie zakorzenia sie na ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," sec <br>")
	}
	if (player_knifebonus_p[id]>0)
	{
		num_to_str(player_knifebonus_p[id],TempSkill,10)
		add(itemEffect,499," Masz bonus do ataku nozem ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," jesli jestes w powietrzu<br>")
	}
	if (player_akrobata[id]>0)
	{
		num_to_str(player_akrobata[id],TempSkill,10)
		add(itemEffect,499," Masz bonus do ataku ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," jesli jestes w powietrzu<br>")
	}
	if (player_akrobata_m[id]>0)
	{
		num_to_str(player_akrobata_m[id],TempSkill,10)
		add(itemEffect,499," Masz bonus do ataku magicznego: ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," procent jesli jestes w powietrzu<br>")
	}
	if (player_lodu_p[id]>0)
	{
		num_to_str(player_lodu_p[id],TempSkill,10)
		add(itemEffect,499," Twoj noz zamraza na  ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," sekund jesli jestes w powietrzu<br>")
	}
	if (player_mrocznibonus[id]>0)
	{
		num_to_str(player_mrocznibonus[id],TempSkill,10)
		add(itemEffect,499," Masz bonus ataku mrocznych ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499,"<br>")
	}
	if (player_ludziebonus[id]>0 )
	{
		num_to_str(player_ludziebonus[id],TempSkill,10)
		add(itemEffect,499," Masz bonus do ataku ludzi ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499,"<br>")
	}
	if (player_intbonus[id]>0)
	{
		num_to_str(player_intbonus[id],TempSkill,10)
		add(itemEffect,499," Masz bonus do inteligencji ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499,"<br>")
	}
	if (player_strbonus[id]>0)
	{
		num_to_str(player_strbonus[id],TempSkill,10)
		add(itemEffect,499," Masz bonus do sily")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499,"<br>")
	}
	if (player_smoke[id]>0)
	{
		add(itemEffect,499," Wcisnij e by dostac smoke. <br>")
	}
	if (player_dosw[id]>0)
	{
		add(itemEffect,499," Wcisnij e by dostac doswiadczenie. <br>")
	}
	if (player_chargetime[id]>0)
	{
		add(itemEffect,499," Czas ladowania zmniejszony <br>")
	}
	if (player_grawitacja[id] >0)
	{
		add(itemEffect,499," Twoja grawitacja zostala zmniejszona <br>")
	}
	if (player_naszyjnikczasu[id] >0)
	{
		num_to_str(player_naszyjnikczasu[id],TempSkill,10)
		add(itemEffect,499," Mozesz uzyc skilla szybciej o  ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," procent<br>")
	}
	if (player_tarczam[id] >0)
	{
		num_to_str(player_b_tarczampercent[id],TempSkill,10)
		add(itemEffect,499," Odpornosc na magie wieksza o: ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499,"procent <br>")
		if(player_tarczam[id] > 750){
			add(itemEffect,499," Odpornosc na mnatychmiastowe zabicie. ")
		}
		
	}
	if (player_grom[id] >0)
	{
		num_to_str(player_grom[id],TempSkill,10)
		add(itemEffect,499," Wcisnij e by zadac przeciwnej druzynie obrazenia: ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499,"<br>")
	}
	if (player_tpresp[id] >0)
	{
		add(itemEffect,499," Wcisnij e by teleportowac sie na resp")
		add(itemEffect,499,"<br>")
	}
	if (player_skin[id] >0)
	{
		add(itemEffect,499," Wygladasz jak morderca ")
		add(itemEffect,499,"<br>")
	}	
	if (player_b_zloto[id] >0)
	{
		num_to_str(player_b_zloto[id],TempSkill,10)
		add(itemEffect,499," Dostajesz na poczatku rundy ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499,"<br>")
	}
	if(player_b_silent[id]>0)
	{
		add(itemEffect,499," Nie slychac Twoich krokow ")
		add(itemEffect,499,"<br>")
	}	
	if (player_awpk[id] >0)
	{
		num_to_str(player_awpk[id],TempSkill,10)
		add(itemEffect,499," Masz awp i 1/ ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," na zabicie z niego. ")
		add(itemEffect,499,"<br>")
	}
	if (player_b_zlotoadd[id] >0)
	{
		num_to_str(player_b_zlotoadd[id],TempSkill,10)
		add(itemEffect,499," Dostajesz na poczatku rundy ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499,"<br>")
	}
	if (player_b_tarczaogra[id] >0)
	{
		num_to_str(player_b_tarczaogra[id],TempSkill,10)
		add(itemEffect,499," Jestes niezniszczalny, ale nie mozesz sie ruszac i uzyc broni przez")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499,"<br>")
	}
	if (player_laska[id] >0)
	{
		num_to_str(player_laska[id],TempSkill,10)
		add(itemEffect,499," Mozesz uzyc lightball co ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," sekundy. ")
		add(itemEffect,499,"<br>")
	}
	if(player_kosa[id]>0)
	{
		add(itemEffect,499," Wskrzeszenie sojusznika i zjedzenie przeciwnika daje ci na 30 sekund dodatkowy dmg i predkosc. <br>")
	}
	if (player_lembasy[id] >0)
	{
		num_to_str(player_lembasy[id],TempSkill,10)
		add(itemEffect,499," Mozesz zatrzymac sie na ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," sekund na elficki posilek by zyskac  ")
		num_to_str(player_lembasy[id]*25,TempSkill,10)
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," hp. W tym czasie chroni Cie tarcza. ")
		add(itemEffect,499,"<br>")
	}
	if (player_NoCharging[id] >0)
	{
		add(itemEffect,499," Nie mozesz sie ladowac.<br> ")
	}
	if (player_NoSkill[id] >0)
	{
		add(itemEffect,499," Nie mozesz uzyc skilla (noz + R).<br> ")
	}
	if (player_NoUpgrade[id] >0)
	{
		add(itemEffect,499,"Tego przedmiotu nie mozna ulepszyc.<br> ")
	}
	if (player_green[id] >0)
	{
		add(itemEffect,499,"Swiecisz sie.<br> ")
	}
	if(player_Slow[id] >0)
	{
		add(itemEffect,499,"Jestes spowolniony o ")
		num_to_str(player_Slow[id],TempSkill,10)
		add(itemEffect,499,TempSkill)
		add(itemEffect,499, ".<br>")
	}
	if (player_loseHp[id] >0)
	{
		num_to_str(player_loseHp[id],TempSkill,10)
		add(itemEffect,499,"Tracisz ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499,"proc hp co 5 sekund. <br>")
	}
	if (player_loseCash[id] >0)
	{
		num_to_str(player_loseCash[id],TempSkill,10)
		add(itemEffect,499," Tracisz ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499,"$ co 5 sekund. <br>")
	}
	if (player_loseCash[id] >0)
	{
		num_to_str(player_loseCash[id],TempSkill,10)
		add(itemEffect,499," Tracisz ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499,"$ co 5 sekund. <br>")
	}
	if (player_DoubleMagicDmg[id] >0)
	{
		num_to_str(player_DoubleMagicDmg[id],TempSkill,10)
		add(itemEffect,499," Otrzymujesz wieksze o ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499,"proc obrazenia magiczne. <br>")
	}
	if (player_DoubleDmg[id] >0)
	{
		num_to_str(player_DoubleMagicDmg[id],TempSkill,10)
		add(itemEffect,499," Otrzymujesz wieksze o ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499,"proc zwykle obrazenia. <br>")
	}
	if (player_dziewica[id] >0)
	{
		num_to_str(player_dziewica[id],TempSkill,10)
		add(itemEffect,499," Uzyj by gracz zadajacy Ci obrazenia tez je otrzymywal. Odbijasz ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499,"proc. Uzywanie kosztuje $. <br>")
	}
	if (player_dziewica_hp[id] >0)
	{
		num_to_str(player_dziewica_hp[id],TempSkill,10)
		add(itemEffect,499," Uzyj by gracz zadajacy Ci obrazenia tez je otrzymywal. Odbijasz ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499,"proc. Uzywanie kosztuje hp.<br>")
	}
	if (player_dremora_lekka[id] >0)
	{
		num_to_str(player_dremora_lekka[id],TempSkill,10)
		add(itemEffect,499," Atakujacy cie przeciwnicy zostana zamrozeni na ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," sec. <br>")
	}
	if (player_dremora[id] >0)
	{
		num_to_str(player_dremora[id],TempSkill,10)
		add(itemEffect,499," Atakujacy cie przeciwnicy zostana oplatani korzeniami na ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499,"sec.<br>")
	}
	if (player_dziewica_aut[id] >0)
	{
		num_to_str(player_dziewica_aut[id],TempSkill,10)
		add(itemEffect,499," Gracz zadajacy Ci obrazenia tez je otrzymuje. Odbijasz ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499,"proc <br>")
	}
	if (player_sword[id] >0)
	{
		add(itemEffect,499," Obrazenia noza zwiekszone o 35. <br>Ulepszanie tego itemu dodaje dodatkowe efekty.")
		add(itemEffect,499,"<br>")
		
	}
	if (player_totem_enta[id] >0)
	{
		num_to_str(player_totem_enta[id],TempSkill,10)
		add(itemEffect,499," Poloz totem by zatrzymal graczy na ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," sekund.  ")
		add(itemEffect,499,"<br>")
	}
	if (player_totem_lodu[id] >0)
	{
		num_to_str(player_totem_lodu[id],TempSkill,10)
		add(itemEffect,499," Poloz totem by zamrozil graczy na ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," sekund.  ")
		add(itemEffect,499,"<br>")
	}
	if (player_recoil[id] >0)
	{
		num_to_str(player_recoil[id],TempSkill,10)
		add(itemEffect,499," Zwoj pozwala Ci sie skupic na celowaniu, idealnie celny jest co ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," pocisk. ")
		add(itemEffect,499,"<br>")
	}
	if (player_lodowe_pociski[id] >0)
	{
		num_to_str(player_lodowe_pociski[id],TempSkill,10)
		add(itemEffect,499," Pociski daja szanse 1/ ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," na zamrozenie przeciwnika.  ")
		add(itemEffect,499,"<br>")
	}
	if (player_entowe_pociski[id] >0)
	{
		num_to_str(player_entowe_pociski[id],TempSkill,10)
		add(itemEffect,499," Pociski daja szanse 1/ ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," na splatanie przeciwnika.  ")
		add(itemEffect,499,"<br>")
	}
	if (player_pociski_powietrza[id] >0)
	{
		num_to_str(player_pociski_powietrza[id],TempSkill,10)
		add(itemEffect,499," Pociski daja szanse 1/")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," na wyrzucenie przeciwnikowi broni.  ")
		add(itemEffect,499,"<br>")
	}
	if (player_totem_powietrza_zasieg[id] >0)
	{
		num_to_str(player_totem_powietrza_zasieg[id],TempSkill,10)
		add(itemEffect,499," Poloz totem by wyrzucil graczom w obszarze ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," bron.  ")
		add(itemEffect,499,"<br>")
	}
	if (player_oko_sokola[id] >0)
	{
		num_to_str(player_oko_sokola[id]*200,TempSkill,10)
		add(itemEffect,499," Poloz totem by wykryl wszystkich przeciwnikow w obszarze ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499,"<br>")
	}
	if (player_gtrap[id] >0)
	{

		add(itemEffect,499," Mozesz podkladac granaty pulapki ")
		add(itemEffect,499,"<br>")

	}
	if (player_chwila_ryzyka[id] >0)
	{

		add(itemEffect,499," Wylosuj 20 000$ + exp lub swoja smierc ")
		add(itemEffect,499,"<br>")

	}
	if (player_aard[id] >0)
	{
		add(itemEffect,499," Uzyj by odrzucic przeciwnikow w obszarze 500 i zabrac im 80 hp ")
		add(itemEffect,499,"<br>")
	}
	if (player_itemw8[id] >0)
	{
		add(itemEffect,499," Uzyj by otrzymac efekty itemu.")
		add(itemEffect,499,"<br>")
	}
	if (player_b_furia[id] > 0) 
	{
		num_to_str(player_b_furia[id],TempSkill,10)
		add(itemEffect,499,"Twoj noz zabija! Zwiekszony speed do")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499,"00!<br> Za kazde zabojstwo przeciwnika tracisz 500$<br>")
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
		num_to_str(player_frostShield[id]*50,TempSkill,10)
		add(itemEffect,499,"Nie mozesz byc zabity przez chaos orb, hell orb albo firerope<br>")
		add(itemEffect,499,"Uzyj, zeby zamrozic kazdego wroga wokol ciebie na obszarze ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," <br>")
	}
	if (player_rozprysk[id] > 0) 
	{
		add(itemEffect,499,"Strzelasz potrojnymi strzalami. Zadaja one 2/3 normalnych obrazen ze strzal.<br>")
	}
	if (wear_sun[id] > 0) 
	{
		add(itemEffect,499,"Flashbangi i oslepienie na ciebie nie dzialaja.<br>")
	}
	if (player_glod[id] > 0) 
	{
		add(itemEffect,499,"Jestes na krwistym glodzie, zjadaj ciala by odnowic zdrowie.<br>")
	}
	if (player_pelnia[id] > 0) 
	{
		add(itemEffect,499,"Widzisz przeciwnikow za scianami, jesli sa ranni. Gdy w kogos strzelisz dostajesz bonus do predkosci. Po zabiciu odnawiasz 20 hp<br>")
	}
	if (player_mrok[id] > 0) 
	{
		add(itemEffect,499,"Jesli nie uczestniczysz w walce jestes niewidzialny <br>")
	}
	if (player_inkizytor[id] > 0) 
	{
		num_to_str(player_inkizytor[id],TempSkill,10)
		add(itemEffect,499,"Twoje leczace totemy oslepiaja, zabieraja przeciwnikom ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," procent hp i wytrzymalosci itemow!<br> Masz 5 magicznych pociskow.")
		if(player_class[id]==lelf) add(itemEffect,499," Zabicie przeciwnika odnawia uzycie totemu<br> ")
	}
	if (player_money_damage[id] > 0) 
	{
		num_to_str(player_money_damage[id],TempSkill,10)
		add(itemEffect,499,"Zadajesz ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," wiecej obrazen za kazde posiadane 5 000 $<br>")
	}
	if (player_money_speedbonus[id] > 0) 
	{
		num_to_str(player_money_speedbonus[id],TempSkill,10)
		add(itemEffect,499," Otrzymujesz ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," bonusu do predkosci za kazde posiadane 5 000 zlota.<br>")
	}
	if(player_nomoney_slow[id]>0){
		num_to_str(player_nomoney_slow[id],TempSkill,10)
		add(itemEffect,499," Atakujac przeciwnika bez $ zamrazasz go na ")
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," sekund.<br>")
	}
	if(player_blogo[id]>0){
		add(itemEffect,499," Magiczne pociski ignoruja redukcje, tarcze powietrza i pancerze <br>")
		add(itemEffect,499," Podczas longJumpa jestes odporny na magie i zwykle ataki.<br>")
	}
	if(player_supshield[id]>0){
		num_to_str(player_supshield[id],TempSkill,10)
		add(itemEffect,499,TempSkill)
		add(itemEffect,499," procent obrazen zadawanych sojusznikom w obszarze 500 jest przekierowane na ciebie, kazde otrzymywane obrazenia daja ci doswiadczenie <br>")
	}
	
	
	
	new Durability[10]
	num_to_str(item_durability[id],Durability,9)
	if (equal(itemEffect,"")) showitem(id,"None","None","Zabij kogos, aby dostac item albo kup (/rune)","None")
	if (!equal(itemEffect,"")) showitem(id,player_item_name[id],itemvalue,itemEffect,Durability)
	
}

/* ==================================================================================================== */
public award_item_adm(id){
	if(get_user_flags(id) & ADMIN_LEVEL_H){
		new rannum = random_num(0,250)	
		award_item(id,rannum)
		upgrade_item(id)
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
	award_item_f(id, itemnum, 1)
}

public award_item_f(id, itemnum, from)
{
	if(player_diablo[id]==1 || player_she[id]==1 || player_class[id]==0 || player_lvl[id]<2) return PLUGIN_CONTINUE
	if (player_item_id[id] != 0)
		return PLUGIN_HANDLED
		
	reset_item_skills(id)
	new rannum 
	set_hudmessage(220, 115, 70, -1.0, 0.40, 0, 3.0, 4.0, 0.2, 0.3, 5)
	
	// Itemy spacjalne 1-14
	if(player_class[id] == lelf){
		if(random_num(0,150) == 0) itemnum = random_num(1,17)
	}

	rannum = random_num(from,204)				// ILOSC ITEMOW
	if (itemnum > 0) rannum = itemnum
	else if (itemnum < 0) return PLUGIN_HANDLED
	
	
			

	//Set durability, make this item dependant?
	item_durability[id] = 200
	switch(rannum)
	{
		case 1:
		{
			if(player_class[id] != Archeolog && player_class[id] != lelf && forceEvent != 2){
				award_unique_item(id)
			}else{
				player_item_name[id] = "Pochlaniacz zlota"
				player_item_id[id] = rannum
				player_money_damage[id] = random_num(4,11)
				player_money_speedbonus[id] = random_num(20,50)
				player_b_money[id] = 1 + player_intelligence[id] *5
				if(player_class[id] == lelf) {
					player_b_money[id] = 1 + player_intelligence[id] *50
					player_b_theif[id] = random_num(300,500)
				}
				player_nomoney_slow[id] = random_num(1,3)
				show_hudmessage(id, "Znalazles przedmiot: %s :: Otrzymujesz bonusy zalezne od posiadanego zlota.",player_item_name[id],player_b_damage[id])
			}
		}
		case 2:
		{
			if(player_class[id]==Paladyn || player_class[id] == lelf || forceEvent == 2){
				player_item_name[id] = "Blogoslawiony strzal"
				player_item_id[id] = rannum
				player_blogo[id] = 1
				golden_bulet[id]=5
				player_b_reduceH[id] = player_lvl[id] / 2
				if(player_b_reduceH[id] > 250) player_b_reduceH[id] = 250
				if(player_class[id] == lelf) golden_bulet[id] += player_intelligence[id] / 50
				count_jumps(id)
				JumpsLeft[id]=JumpsMax[id]
				show_hudmessage(id, "Znalazles przedmiot: %s :: Magiczne pociski ignoruja redukcje i pancerze.Podczas longJumpa jestes odporny na magie i zwykle ataki.",player_item_name[id])	
			}else{
				award_unique_item(id)
			}
		}
		case 3:
		{

			if(player_class[id]==Ninja || player_class[id] == lelf || forceEvent == 2){
				player_item_name[id] = "Blogoslawienstwo nocnicy"
				player_item_id[id] = rannum
				player_nocnica[id] = 1
				give_knife(id)
				if(player_class[id] != lelf) player_b_reduceH[id] = random_num(30,90)
				show_hudmessage(id, "Znalazles przedmiot: %s :: Rzut nozem kradnie 15 naboi. Trafienia nozem zwiekszaja obrazenia nastepnego zwyklego ataku dwukrotnie.",player_item_name[id])	
			}else{
				award_unique_item(id)
			}
		}
		case 4:
		{
			if(player_class[id]!=Harpia && player_class[id]!=lelf  && forceEvent != 2){
				award_unique_item(id)
			}else{
				player_item_name[id] = "Nocna Furia"
				player_item_id[id] = rannum
				player_knifebonus[id] = 10000
				player_b_furia[id] = random_num(5,15)
				if(player_class[id]==lelf)player_b_furia[id] = random_num(3,5)
				player_100hp[id] =1 
				if(get_user_health(id)>100){
					fm_set_user_health(id,100)
				} 
				show_hudmessage(id, "Znalazles przedmiot: %s :: Twoj noz zabija! Masz bonus do predkosci!",player_item_name[id])	
			}
		}
		case 5:
		{
			if(player_class[id] != Magic && player_class[id] != lelf && forceEvent != 2){
				award_unique_item(id)
			}else{
				player_item_name[id] = "Blogoslawienstwo Talosa"
				player_talos[id]  = 15
				player_item_id[id] = rannum
				player_b_blink[id] = 1
				if(player_class[id] != Magic){
					ultra_armor[id] = 4
					player_laska[id] = 5
				} 
				
				show_hudmessage(id, "Znalazles przedmiot: %s :: Po teleporcie przez sekunde jestes niewidzialny. Po wystrzeleniu firebala otrzymujesz magiczny pancerz.",player_item_name[id])	
			}
		}
		case 6:
		{
			if(player_class[id] != Barbarzynca && player_class[id] != lelf && forceEvent != 2){
				award_unique_item(id)
			}else{
				player_item_name[id] = "Bitewny szal"
				player_bitewnyszal[id]  = random_num(5,9)
				player_item_id[id] = rannum
				show_hudmessage(id, "Znalazles przedmiot: %s :: Po aktywowaniu przez %i sek Twoje hp nie moze spasc ponizej 1",player_item_name[id], player_bitewnyszal[id])	
			}
		}
		case 7:
		{
			if(player_class[id] != Zabojca && player_class[id] != lelf && forceEvent != 2){
				award_unique_item(id)
			}else{
				player_item_name[id] = "Blogoslawienstwo Sithisa"
				player_itemw8[id]=BlogoslawienstwoSithisa
				item_durability[id] = 100
				player_item_id[id] = rannum
				show_hudmessage(id, "Znalazles przedmiot: %s :: Przy zmianie noza automatycznie stajesz sie niewidzialny. Po byciu niewidzialnym otrzymujesz 2 magiczne pociski. Twoje hp jest zredukowane do 5. Otrzymujesz kompletna odpornosc na magie.",player_item_name[id])	
			}
		}
		case 8:
		{
			if(player_class[id] != Wampir && player_class[id] != lelf && forceEvent != 2){
				award_unique_item(id)
			}else{
				player_item_name[id] = "Krwawy glod"
				g_haskit[id] = 1
				player_glod[id]  = 1
				player_item_id[id] = rannum
				player_b_vampire[id] = random_num(5,20)
				player_b_redirect[id] = random_num(8,12)
				player_b_inv[id] = random_num(60,100)
				player_speedbonus[id] = 50

				show_hudmessage(id, "Znalazles przedmiot: %s :: Otrzymujesz 20 do obrazen wampirycznych. Jestes na krwistym glodzie, zjadaj ciala by odnowic zdrowie. ",player_item_name[id])	
			}
		}
		case 9:
		{
			if(player_class[id] != Hunter && player_class[id] != lelf && forceEvent != 2){
				award_unique_item(id)
			}else{
				player_item_name[id] = "Rozpryskowe strzaly"
				player_b_reduceH[id] = player_lvl[id] / 4
				if(player_b_reduceH[id] > 50) player_b_reduceH[id] = 50
				player_rozprysk[id]  = 1
				player_item_id[id] = rannum
				show_hudmessage(id, "Znalazles przedmiot: %s :: Strzelasz potrojnymi strzalami.",player_item_name[id])	
			}
		}
		case 10:
		{
			if(player_class[id] != Wilk && player_class[id] != lelf && forceEvent != 2){
				award_unique_item(id)
			}else{
				player_item_name[id] = "Pelnia ksiezyca"
				g_haskit[id] = 1
				player_pelnia[id]  = 1
				player_item_id[id] = rannum
				player_b_redirect[id] = random_num(8,25)
				player_b_silent[id] = 1

				show_hudmessage(id, "Znalazles przedmiot: %s :: Widzisz przeciwnikow za scianami, jesli sa ranni. Gdy w kogos strzelisz dostajesz bonus do predkosci. Po zabiciu odnawiasz 20 hp ",player_item_name[id])	
			}
		}
		case 11:
		{
			if(player_class[id] != szelf && player_class[id] != lelf && forceEvent != 2){
				award_unique_item(id)
			}else{
				player_item_name[id] = "Mrok nocy"
				player_b_reduceH[id] = player_lvl[id] / 4
				if(player_b_reduceH[id] > 50) player_b_reduceH[id] = 50
				player_mrok[id]  = 1
				player_item_id[id] = rannum
				show_hudmessage(id, "Znalazles przedmiot: %s ::  Jesli nie uczestniczysz w walce jestes niewidzialny",player_item_name[id])	
			}
		}
		case 12:
		{
			if(player_class[id] != Mnich && player_class[id] != lelf && forceEvent != 2){
				award_unique_item(id)
			}else{
				player_item_name[id] = "Sila woli"
				player_magic_imun[id] = 1
				player_b_tarczaogra[id] = random_num(3,5)
				player_refill[id] = 1
				player_b_vampire[id] = random_num(2,5)
				player_item_id[id] = rannum
				show_hudmessage(id, "Znalazles przedmiot: %s ::  Skup sie by uniknac ciosow",player_item_name[id])	
			}
		}
		case 13:
		{
			if(player_class[id] != Kaplan && player_class[id] != lelf && forceEvent != 2){
				award_unique_item(id)
			}else{
				player_item_name[id] = "Amulet inkwizytora"
				player_inkizytor[id] = random_num(1,3)
				golden_bulet[id]=3

				if(player_class[id] ==lelf){
					player_inkizytor[id] = random_num(4,8)
					player_b_heal[id] = random_num(25,50)
				}  
				player_item_id[id] = rannum
				show_hudmessage(id, "Znalazles przedmiot: %s :: Twoje leczace totemy oslepiaja, zabieraja przeciwnikom hp i wytrzymalosci itemow ",player_item_name[id])	
			}
		}
		case 14:
		{
			if(player_class[id] != Mnich && player_class[id] != Orc && player_class[id] != lelf && forceEvent != 2){
				award_unique_item(id)
			}else{
				player_item_name[id] = " Sztandar chwaly"
				player_supshield[id] = random_num(10,30)
				player_item_id[id] = rannum
				if(player_class[id] ==lelf){
					player_b_redirect[id] = random_num(5,15)
					player_b_extrastats[id] =  random_num(10,30)
				}
				show_hudmessage(id, "Znalazles przedmiot: %s :: Obrazenia zadawane sojusznikom w obszarze 500 sa przekierowane na ciebie, kazde otrzymane obrazenia daja ci doswiadczenie",player_item_name[id])	
			}
		}		

		case 15:
		{
			if(player_class[id] != Stalker && player_class[id] != lelf && forceEvent != 2){
				award_unique_item(id)
			}else{
				player_item_name[id] = "Dar promieniowania"
				player_item_id[id] = rannum
				player_itemw8[id]=DarPromieniowania
				item_durability[id] = 100
				show_hudmessage (id, "Znalazles przedmiot : %s :: Jestes odporny na negatywne efekty.",player_item_name[id])
			}
		}
		case 16:
		{
			if(player_class[id] != Dzikuska && player_class[id] != lelf && forceEvent != 2){
				award_unique_item(id)
			}else{
				player_item_name[id] = "Zew biesa"
				player_item_id[id] = rannum
				player_akrobata[id] = random_num(5,15)
				player_knifebonus_p[id] = random_num(50,100)
				player_b_nieust[id] =  40
				show_hudmessage(id, "Znalazles przedmiot : %s ::  Zadajesz wieksze obrazenia jesli jestes w powietrzu, masz wiecej nieustepliwosci, dodatkowe obrazenia nozem jesli jestes w powietrzu.",player_item_name[id])	
			}
		}
		case 17:
		{
			if(player_class[id] != Drzewiec && player_class[id] != lelf && forceEvent != 2){
				award_unique_item(id)
			}else{
				player_item_name[id] = "Wsparcie leszego"
				player_item_id[id] = rannum
				player_b_redirect[id] = random_num(5,10)
				player_las[id] = random_num(3,5)
				player_b_nieust[id] =  50
				show_hudmessage(id, "Znalazles przedmiot : %s ::  Zadawanie ci normalnych obrazen zakorzenia atakujacego. 50 nieustepliwosci..",player_item_name[id])	
			}
		}
		case 18:
		{
			if(player_class[id] != Nekromanta && player_class[id] != lelf && forceEvent != 2){
				award_unique_item(id)
			}else{
				player_item_name[id] = "Kosa bojowa"
				player_item_id[id] = rannum
				player_kosa[id] = rannum
				show_hudmessage (id, "Znalazles przedmiot : %s :: Wskrzeszenie sojusznika i zjedzenie przeciwnika daje ci na 30 sekund dodatkowy dmg i predkosc.",player_item_name[id],player_b_damage[id],player_b_extrastats[id])
			}				
		}
		case 19:
		{
			if(player_class[id]!=Witch && player_class[id]!=Nekromanta && player_class[id] != lelf && forceEvent != 2){
				player_item_name[id] = "Phoenix Ring"
				player_item_id[id] = rannum
				player_b_respawn[id] = random_num(2,5)
				show_hudmessage(id, "Znalazles przedmiot: %s :: 1/%i szans do ponownego odrodzenia sie po smierci",player_item_name[id],player_b_respawn[id])	
			}else{
				award_unique_item(id)
			}
		}
		case 20:
		{
			player_item_name[id] = "Kolec mrozu"
			player_head_froze[id] = random_num(1,5)
			if(player_class[id] == lelf){
				player_head_froze[id] = random_num(1,5)
			}
			player_item_id[id] = rannum
			show_hudmessage(id, "Znalazles przedmiot: %s :: Trafienie w glowe zamraza ofiare",player_item_name[id])
		}
		case 21:
		{
			if(player_class[id]==Ninja ){
				if(random_num(0,3)==0){
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
		case 22:
		{
			if( player_class[id] != lelf){
				player_item_name[id] = "Hell Orb"
				player_item_id[id] = rannum
				player_b_explode[id] = random_num(500,600)
				show_hudmessage(id, "Znalazles przedmiot: %s :: Wybuchniesz zaraz po smierci w promieniu %i",player_item_name[id],player_b_explode[id])	
			}else{
				award_unique_item(id)
			}
		}
		case 23:
		{
			player_item_name[id] = "Small angel wings"
			player_item_id[id] = rannum
			player_b_gravity[id] = random_num(1,5)
			if(player_class[id] == lelf ){
				player_b_gravity[id] = random_num(5,9)
			}
			if (is_user_alive(id))
				set_gravitychange(id)
			show_hudmessage(id, "Znalazles przedmiot: %s :: +%i premia wyzszego skoku - Wcisnij e zeby uzyc",player_item_name[id],player_b_gravity[id])	
		}
		case 24:
		{
			player_item_name[id] = "Daylight Diamond"
			player_item_id[id] = rannum
			player_b_heal[id] = random_num(10,20)
			show_hudmessage(id, "Znalazles przedmiot: %s :: Regeneruje %i hp co kazde 5 sekund. Uzyj, zeby polozyc totem ktory bedzie leczyl wszystkich w zasiegu %i",player_item_name[id],player_b_heal[id],player_b_heal[id])	
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
			player_item_name[id] = "Wheel of Fortune"
			player_item_id[id] = rannum
			player_b_gamble[id] = random_num(4,6)
			show_hudmessage(id, "Znalazles przedmiot: %s :: +%i daje ci dodatkowa premie w kazdej rundzie",player_item_name[id],player_b_gamble[id])	
		}
		case 27:
		{
			player_item_name[id] = "Four leaf Clover"
			player_item_id[id] = rannum
			player_b_gamble[id] = random_num(7,9)
			show_hudmessage(id, "Znalazles przedmiot: %s :: +%i daje ci dodatkowa premie w kazdej rundzie",player_item_name[id],player_b_gamble[id])	
		}
		case 28:
		{
			player_item_name[id] = "Amulet of the sun"
			player_item_id[id] = rannum
			player_b_blind[id] = random_num(6,9)
			wear_sun[id] = 1
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
			player_item_name[id] = "Fireshield"
			player_item_id[id] = rannum
			player_b_fireshield[id] = 1
			show_hudmessage(id, "Znalazles przedmiot: %s :: Chroni od natychmiastowego zabicia HE i orbami. Wcisnij e zeby go uzyc",player_item_name[id],player_b_fireshield[id])	
		}
		case 31:
		{
			if(player_class[id]==lelf ){
				award_unique_item(id)
			}else{	
				player_item_name[id] = "Stealth Shoes"
				player_item_id[id] = rannum
				player_b_silent[id] = 1
				show_hudmessage(id, "Znalazles przedmiot: %s :: Twoj bieg cichnie",player_item_name[id])
			}
		}
		case 32:
		{
			player_item_name[id] = "Meekstone"
			player_item_id[id] = rannum
			player_b_meekstone[id] = 1
			player_b_reduceH[id] = player_lvl[id] 
			if(player_b_reduceH[id] > 250) player_b_reduceH[id] = 250
			show_hudmessage(id, "Znalazles przedmiot: %s :: Uzyj by spowodowac wybuch zadajacy smiertelne obrazenia",player_item_name[id])	
		}
		case 33:
		{
			player_item_name[id] = "Medicine Glar"
			player_item_id[id] = rannum
			player_b_teamheal[id] = random_num(10,25)
			show_hudmessage(id, "Znalazles przedmiot: %s :: Strzel do swojego, aby uleczyc %i hp na sek - wcisnij E, zeby uzyc, otrzymasz doswiadczenie",player_item_name[id],1 + player_b_teamheal[id]/10)	
		}
		case 34:
		{
			player_item_name[id] = "Medicine Totem"
			player_item_id[id] = rannum
			player_b_teamheal[id] = random_num(25,50)
			show_hudmessage(id, "Znalazles przedmiot: %s :: Strzel do swojego, aby uleczyc %i hp na sek - wcisnij E, zeby uzyc, otrzymasz doswiadczenie",player_item_name[id],1 + player_b_teamheal[id]/10)	
		}
		case 35:
		{
			player_item_name[id] = "Large gold bag"
			player_item_id[id] = rannum
			player_b_money[id] = random_num(1200,3000) + player_intelligence[id] *50
			show_hudmessage(id, "Znalazles przedmiot: %s :: dostajesz %i zloto w kazdej rundzie. Uzyj, zeby chronil cie.",player_item_name[id],player_b_money[id]+player_intelligence[id]*50)	
		
		}
		case 36:
		{
			player_item_name[id] = "Mitril Armor"
			player_item_id[id] = rannum
			player_b_redirect[id] = random_num(8,11)
			if(player_class[id] == lelf ){
				player_b_redirect[id] = random_num(11,15)
			}
			show_hudmessage(id, "Znalazles przedmiot: %s :: +%i Obniza uszkodzenia zadawane graczowi",player_item_name[id],player_b_redirect[id])	
		}
		case 37:
		{
			player_item_name[id] = "Godly Armor"
			player_item_id[id] = rannum
			player_b_redirect[id] = random_num(10,15)
			if(player_class[id] == lelf ){
				player_b_redirect[id] = random_num(14,18)
			}
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
			player_item_name[id] = "Ghost Rope"
			player_item_id[id] = rannum
			player_b_ghost[id] = random_num(3,6)
			if(player_class[id] == lelf ){
				player_b_ghost[id] = random_num(5,8)
			}
			show_hudmessage(id, "Znalazles przedmiot: %s :: Mozesz przenikac przez sciany przez %i sekund",player_item_name[id],player_b_ghost[id])	
		}
		case 41:
		{
			if( player_class[id] == Orc || player_class[id] == lelf){
				player_item_name[id] = "Dzika szarza"
				player_item_id[id] = rannum
				player_b_szarza[id] = random_num(5,20)
				show_hudmessage(id, "Znalazles przedmiot: %s ::Uzyj by byc odpornym na spowolnienie na %i sekund",player_item_name[id], player_b_szarza)		
			}else{
				award_unique_item(id)
			}
		}
		case 42:
		{
			if(player_class[id]!=Magic){
				player_item_name[id] = "Knife Ruby"
				player_item_id[id] = rannum
				player_b_blink[id] = floatround(halflife_time())
				show_hudmessage(id, "Znalazles przedmiot: %s :: Twoj noz pozwala ci teleportowac sie raz na 3 sekundy",player_item_name[id])
			}else{
				award_unique_item(id)
			}
		}
		case 43:
		{
			player_item_name[id] = "Medium silver bag"
			player_item_id[id] = rannum
			player_b_money[id] = random_num(500,1200)+ player_intelligence[id] *50
			if(player_class[id] == lelf ){
				player_b_money[id] = random_num(500,1200)+ player_intelligence[id] *50
			}
			show_hudmessage(id, "Znalazles przedmiot: %s :: dostajesz %i zloto w kazdej rundzie. Uzyj, zeby chronil cie.",player_item_name[id],player_b_money[id]+player_intelligence[id]*50)	
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
			if(player_class[id]!=MagW && player_class[id] != lelf){
				player_item_name[id] = "Dagon I"
				player_item_id[id] = rannum
				player_b_dagon[id] = random_num(1,5)
				show_hudmessage(id, "Znalazles przedmiot: %s :: Uzyj zeby uderzyc twojego przeciwnika piorunem ognia",player_item_name[id])	
			}else{
				award_unique_item(id)
			}
		}
		case 47:
		{
			player_item_name[id] = "Scout Extender"
			player_item_id[id] = rannum
			fm_give_item(id, "weapon_scout")
			player_b_sniper[id] = random_num(3,4)
			show_hudmessage(id, "Znalazles przedmiot: %s :: 1/%i szans do natychmiastowego zabicia scoutem",player_item_name[id],player_b_sniper[id])	
		}
		case 48:
		{
			player_item_name[id] = "Scout Amplifier"
			fm_give_item(id, "weapon_scout")
			player_item_id[id] = rannum
			player_b_sniper[id] = random_num(2,3)
			show_hudmessage(id, "Znalazles przedmiot: %s :: 1/%i szans do natychmiastowego zabicia scoutem",player_item_name[id],player_b_sniper[id])	
		}
		case 49:
		{
			player_item_name[id] = "Krasnoludzka kusza obronna"
			player_item_id[id] = rannum
			player_b_m3_knock[id] = 1
			fm_give_item(id, "weapon_m3")
			give_item(id, "ammo_buckshot")
			give_item(id, "ammo_buckshot")
			give_item(id, "ammo_buckshot")
			show_hudmessage(id, "Znalazles przedmiot: %s ::  Dostajesz m3 ktore odpycha, masz zwiekszona predkosc jesli trzymasz m3.",player_item_name[id])	
		}
		case 50:
		{
			player_item_name[id] = "Iron Spikes"
			player_item_id[id] = rannum
			player_b_smokehit[id] = 1
			fm_give_item(id, "weapon_smokegrenade")	
			show_hudmessage(id, "Znalazles przedmiot: %s :: Jezeli uderzasz kogos granatami dymym, to on zginie",player_item_name[id])	
		}
		case 51:
		{
			player_item_name[id] = "Point Booster"
			player_item_id[id] = rannum
			player_b_extrastats[id] = 5 + player_lvl[id] / 10
			BoostStats(id,player_b_extrastats[id])
			player_staty[id]=1
			show_hudmessage(id, "Znalazles przedmiot: %s :: Zyskasz +%i do wszystkich statystyk",player_item_name[id],player_b_extrastats[id])	
		}
		case 52:
		{
			if(player_class[id]!=MagO && player_class[id] != lelf){
				player_item_name[id] = "Totem amulet"
				player_item_id[id] = rannum
				player_b_firetotem[id] = random_num(700,1000)
				show_hudmessage(id, "Znalazles przedmiot: %s :: Uzyj, aby polozyc wybuchowy totem ognia",player_item_name[id])	
			}else{
				award_unique_item(id)
			}
		}
		case 53:
		{
			player_item_name[id] = "Magic Hook"
			player_item_id[id] = rannum
			player_b_hook[id] = 1
			show_hudmessage(id, "Znalazles przedmiot: %s :: Uzyj, aby rzucic hakiem",player_item_name[id])	
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
			player_green[id] = 1
			player_b_darksteel[id] = random_num(6,8)
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
			player_item_name[id] = "Techies scepter"
			player_item_id[id] = rannum
			player_b_mine[id] = 3
			show_hudmessage(id, "Znalazles przedmiot: %s :: Uzyj, zeby polozyc niewidzialna mine",player_item_name[id])
		}
		case 58:
		{
			if(player_class[id]!=Magic){
				player_item_name[id] = "Ninja ring"
				player_item_id[id] = rannum
				player_b_blink[id] = floatround(halflife_time())
				player_b_froglegs[id] = 1
				show_hudmessage(id, "Znalazles przedmiot: %s :: Twoj noz pozwala ci teleportowac sie co 3 sekundy i zrobic dlugi skok jak kucniesz na 3 sekundy",player_item_name[id])
			}else{
				award_unique_item(id)
			}
		}
		case 59:	
		{
			if(player_class[id]!=Arcymag && player_class[id] != lelf){
				player_item_name[id] = "Mag ring"
				player_item_id[id] = rannum
				player_intbonus[id] = 5
				BoostInt(id,player_intbonus[id])
				player_b_fireball[id] = random_num(50,80)
				show_hudmessage(id, "Znalazles przedmiot : %s :: Ten przedmiot dodaje ci +5 inteligencji i robi swietlista kule, wcisnij E aby uzyc",player_item_name[id])
				player_staty[id]=1
			}else{
				award_unique_item(id)
			}
		}	
		case 60:	
		{
			player_item_name[id] = "Nekromanta ring"
			player_item_id[id] = rannum
			if(player_class[id]!=Witch ){
				player_b_respawn[id] = random_num(3,5)
			}
			player_b_vampire[id] = random_num(3,5)	
			show_hudmessage(id, "Znalazles przedmiot : %s :: Dzieki temu itemowi masz szanse na ponowne odrodzenie sie i wysysasz zycie wrogowi",player_item_name[id])
		}
		case 61:
		{
			if(player_class[id]!=szelf && player_class[id] != lelf){
				player_item_name[id] = "Invisibility Coat"
				player_item_id[id] = rannum
				player_b_inv[id] = random_num(110,150)
				show_hudmessage(id, "Znalazles przedmiot: %s :: +%i premii niewidocznosci",player_item_name[id],255-player_b_inv[id])	
			}else{
				award_unique_item(id)
			}
		}
		case 62:
		{
			player_item_name[id] = "Paladyn ring"
			player_item_id[id] = rannum	
			player_b_redirect[id] = random_num(7,17)
			player_b_blind[id] = random_num(3,4)
			show_hudmessage(id, "Znalazles przedmiot : %s :: Redukuje normalne obrazenia i masz szanse na oslepienie wroga",player_item_name[id])		
		}
		case 63:
		{
			player_item_name[id] = "Mnich ring"
			player_item_id[id] = rannum	
			player_b_grenade[id] = random_num(2,6)
			fm_give_item(id, "weapon_hegrenade")
			player_b_heal[id] = random_num(20,35)
			show_hudmessage(id, "Znalazles przedmiot : %s :: Masz szanse na natychmiastowe zabicie z HE. Twoje hp bedzie sie regenerowac co 5 sekund oraz mozesz polozyc leczacy totem na 7 sekund",player_item_name[id])
		}	
		case 64:
		{
			player_item_name[id] = "Pierscien akrobaty"
			player_item_id[id] = rannum
			player_akrobata_m[id] = random_num(40,80)
			show_hudmessage(id, "Znalazles przedmiot : %s ::  Zadajesz wieksze obrazenia magiczne jesli jestes w powietrzu.",player_item_name[id])	
		}	
		case 65:
		{
			player_item_name[id] = "Vampyric Amulet"
			player_item_id[id] = rannum
			player_b_vampire[id] = random_num(4,6)
			if(player_class[id] == lelf ){
				player_b_vampire[id] = random_num(6,8)
			}
			show_hudmessage(id, "Znalazles przedmiot: %s :: wysysasz %i hp przeciwnikowi",player_item_name[id],player_b_vampire[id])
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
			player_item_name[id] = "Vampyric Scepter"
			player_item_id[id] = rannum
			player_b_vampire[id] = random_num(6,9)
			if(player_class[id] == lelf ){
				player_b_vampire[id] = random_num(9,13)
			}
			show_hudmessage(id, "Znalazles przedmiot: %s :: wysysasz %i hp przeciwnikowi",player_item_name[id],player_b_vampire[id])	
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
			player_item_name[id] = "Kolec skonczonosci"
			player_head_dmg[id] = 2
			item_durability[id] = 100
			player_b_reduceH[id] = player_lvl[id] / 2
			player_NoUpgrade[id]= 1
			if(player_class[id] == Paladyn) player_b_reduceH[id] = player_lvl[id] 
			if(player_b_reduceH[id] > 250) player_b_reduceH[id] = 250
			if(player_class[id] == lelf){
				player_head_dmg[id] = random_num(3,4)
			}
			player_item_id[id] = rannum
			show_hudmessage(id, "Znalazles przedmiot: %s :: Trafienie w glowe zadaje wieksze obrazenia ",player_item_name[id])
		}
		case 70:
		{
			player_item_name[id] = "Kolec nieskonczonosci"
			player_head_dmg[id] = 3
			player_NoCharging[id]=1
			player_DoubleMagicDmg[id] = 40
			item_durability[id] = 100
			player_b_reduceH[id] = player_lvl[id] / 2
			if(player_class[id] == Paladyn) player_b_reduceH[id] = player_lvl[id] 
			if(player_b_reduceH[id] > 250) player_b_reduceH[id] = 250
			if(player_class[id] == lelf){
				player_head_dmg[id] = random_num(3,4)
			}
			player_item_id[id] = rannum
			show_hudmessage(id, "Znalazles przedmiot: %s :: Trafienie w glowe zadaje wieksze obrazenia ",player_item_name[id])
		}
		case 71:
		{
			player_ns[id] = 18			
			if(player_strength[id] >= player_ns[id]){
				player_item_id[id] = rannum
				player_item_name[id] = "Ciezkie buty"
				player_speedbonus[id] = random_num(1,3)
				player_b_redirect[id] = random_num(5,20)
				show_hudmessage (id, "Znalazles przedmiot : %s ::Dziala jesli masz %i sily.Redukuje normalne obrazenia %i bonus do szybkosci %i",player_item_name[id],player_ns[id], player_b_redirect[id],player_speedbonus[id])
			}else{
				award_unique_item(id)
			}			
		}
		case 72:
		{
			player_ns[id] = 30
			if(player_strength[id] >= player_ns[id]){
				player_item_name[id] = "Kolcze buty"
				player_item_id[id] = rannum
				player_speedbonus[id] = random_num(5,15)
				player_b_redirect[id] = random_num(8,9)
				show_hudmessage (id, "Znalazles przedmiot : %s :: Dziala jesli masz %i sily.Redukuje normalne obrazenia %i bonus do szybkosci %i",player_item_name[id],player_ns[id],player_b_redirect[id],player_speedbonus[id])
			}else{
				award_unique_item(id)
			}
		}
		case 73:
		{
			player_ns[id] = 60
			if(player_strength[id] >= player_ns[id]){
				player_item_name[id] = "Lekkie plytowe buty"
				player_item_id[id] = rannum
				player_speedbonus[id] = random_num(30,40)
				player_b_redirect[id] = random_num(13,14)
				show_hudmessage (id, "Znalazles przedmiot : %s :: Dziala jesli masz %i sily.Redukuje normalne obrazenia %i bonus do szybkosci %i",player_item_name[id],player_ns[id],player_b_redirect[id],player_speedbonus[id])
			}else{
				award_unique_item(id)
			}
		}
		case 74:
		{
			player_item_name[id] = "Skorzane buty przyspieszenia"
			player_item_id[id] = rannum
			player_speedbonus[id] = random_num(25,35)
			if(player_class[id] == lelf){
				player_speedbonus[id] = random_num(95,105)
			}
			show_hudmessage (id, "Znalazles przedmiot : %s :: Bonus do szybkosci %i",player_item_name[id],player_speedbonus[id])
		}
		case 75:
		{
			
			player_nd[id] = 60
			if(player_class[id] == lelf){
				player_speedbonus[id] = random_num(55,165)
				player_item_name[id] = "Ebonowe buty przyspieszenia"
				player_item_id[id] = rannum
				show_hudmessage (id, "Znalazles przedmiot : %s :: Dziala jesli masz %i zwinnosci lub jestes lesnym elfem. Bonus do szybkosci %i",player_item_name[id],player_nd[id],player_speedbonus[id])
			}else if(player_dextery[id] >= player_nd[id]){
				player_item_id[id] = rannum
				player_item_name[id] = "Ebonowe buty przyspieszenia"
				player_speedbonus[id] = random_num(55,65)
				show_hudmessage (id, "Znalazles przedmiot : %s :: Dziala jesli masz %i zwinnosci lub jestes lesnym elfem. Bonus do szybkosci %i",player_item_name[id],player_nd[id],player_speedbonus[id])
			}else{
				award_unique_item(id)
			}			
		}
		case 76:
		{
			if(player_class[id]==lelf ){
				award_unique_item(id)
			}else{	
				player_item_name[id] = "Kaptur"
				player_item_id[id] = rannum
				player_b_redirect[id] = random_num(1,2)
				player_speedbonus[id] = random_num(1,2)
				player_knifebonus[id] = random_num(1,2)
				wear_sun[id] =1
				show_hudmessage (id, "Znalazles przedmiot : %s :: Zmniejsza obrazenia o %i",player_item_name[id],player_b_redirect[id])
			}
		}
		case 77:
		{
			player_ns[id] = 16
			if(player_strength[id] >= player_ns[id]){
				player_item_name[id] = "Szyszak"
				player_item_id[id] = rannum
				player_b_redirect[id] = random_num(4,5)
				show_hudmessage (id, "Znalazles przedmiot : %s :: Dziala jesli masz %i sily.Redukuje normalne obrazenia %i ",player_item_name[id],player_ns[id],player_b_redirect[id])
			}else{
				award_unique_item(id)
			}
		}
		case 78:
		{
			player_ns[id] = 26
			
			if(player_strength[id] >= player_ns[id]){
				player_item_name[id] = "Helm"
				player_item_id[id] = rannum
				player_b_redirect[id] = random_num(8,10)
				show_hudmessage (id, "Znalazles przedmiot : %s :: Dziala jesli masz %i sily.Redukuje normalne obrazenia %i ",player_item_name[id],player_ns[id],player_b_redirect[id])
			}else{
				award_unique_item(id)
			}
		}
		case 79:
		{
			player_ns[id] = 41
			if(player_strength[id] >= player_ns[id]){
				player_item_name[id] = "Zamkniety helm"
				player_item_id[id] = rannum
				player_b_redirect[id] = random_num(9,14)
				show_hudmessage (id, "Znalazles przedmiot : %s :: Dziala jesli masz %i sily.Redukuje normalne obrazenia %i ",player_item_name[id],player_ns[id],player_b_redirect[id])
			}else{
				award_unique_item(id)
			}
		}
		case 80:
		{
			player_ns[id] = 63
			if(player_strength[id] >= player_ns[id]){
				player_item_id[id] = rannum
				player_item_name[id] = "Wielki helm"
				player_b_redirect[id] = random_num(12,16)
				show_hudmessage (id, "Znalazles przedmiot : %s :: Dziala jesli masz %i sily.Redukuje normalne obrazenia %i ",player_item_name[id],player_ns[id],player_b_redirect[id])
			}else{
				award_unique_item(id)
			}			
		}
		case 81:
		{
			player_ns[id] = 250
			if(player_class[id] == lelf){
				player_b_redirect[id] = 20
				player_item_id[id] = rannum
				player_item_name[id] = "Kosciany helm"
				show_hudmessage (id, "Znalazles przedmiot : %s :: Dziala jesli masz %i sily lub jestes lesnym elfem.Redukuje normalne obrazenia %i ",player_item_name[id],player_ns[id],player_b_redirect[id])
			}else if(player_strength[id] >= player_ns[id]){
				player_item_id[id] = rannum
				player_item_name[id] = "Kosciany helm"
				player_b_redirect[id] = 20
				show_hudmessage (id, "Znalazles przedmiot : %s :: Dziala jesli masz %i sily lub jestes lesnym elfem.Redukuje normalne obrazenia %i ",player_item_name[id],player_ns[id],player_b_redirect[id])
			}else{
				award_unique_item(id)
			}			
		}
		case 82:
		{
			if(player_class[id] == Ninja){
				award_unique_item(id)
			}else{			
				player_item_name[id] = "Straznik nocny"
				give_item(id, "weapon_awp");
				player_item_id[id] = rannum
				player_awpk[id]  = random_num(2,6)
				show_hudmessage(id, "Znalazles przedmiot: %s :: Masz awp i 1/%i na zabicie!",player_item_name[id], player_awpk[id])	
			}
		}
		case 83:
		{			
			player_dremora[id] = 2
			player_item_id[id] = rannum
			player_item_name[id] = "Ciezka zbroja dremory"
			show_hudmessage (id, "Znalazles przedmiot : %s :: Atakujacy cie przeciwnicy zostana oplatani korzeniami. ",player_item_name[id],player_ns[id],player_b_redirect[id])
		}
		case 84:
		{
			player_item_name[id] = "Cwiekowana zbroja"
			player_item_id[id] = rannum
			player_dziewica_hp[id] = random_num(55,65)
			player_dziewica_using[id]=0
			if(player_class[id] == lelf) player_dziewica_hp[id] = random_num(60,70)
			show_hudmessage (id, "Znalazles przedmiot : %s :: Uzyj by gracz zadajacy Ci obrazenia tez je otrzymywal. ",player_item_name[id])		
		}
		case 85:
		{
			player_item_id[id] = rannum
			player_item_name[id] = "Zbroja dremory"
			player_dremora_lekka[id] = 5
			show_hudmessage (id, "Znalazles przedmiot : %s ::Atakujacy cie przeciwnicy zostana zamrozeni. ",player_item_name[id])			
		}
		case 86:
		{
			player_ns[id] = 120
			if(player_strength[id] >= player_ns[id]){
				player_item_name[id] = "Luskowa zbroja"
				player_b_redirect[id] = 18
				player_item_id[id] = rannum
				show_hudmessage (id, "Znalazles przedmiot : %s :: Dziala jesli masz %i sily.Redukuje normalne obrazenia %i ",player_item_name[id],player_ns[id],player_b_redirect[id])
			}else{
				award_unique_item(id)
			}			
		}
		case 87:
		{
			player_ns[id] = 160
			if(player_strength[id] >= player_ns[id]){
				player_item_name[id] = "Napiersnik"
				player_item_id[id] = rannum
				player_b_redirect[id] = 20
				show_hudmessage (id, "Znalazles przedmiot : %s :: Dziala jesli masz %i sily.Redukuje normalne obrazenia %i ",player_item_name[id],player_ns[id],player_b_redirect[id])
			}else{
				award_unique_item(id)
			}			
		}
		case 88:
		{
			player_nd[id] = 100
			if(player_dextery[id] >= player_nd[id]){
				player_b_redirect[id] = 25
				player_item_name[id] = "Kolczuga"
				player_item_id[id] = rannum
				show_hudmessage (id, "Znalazles przedmiot : %s :: Redukuje normalne obrazenia %i ",player_item_name[id],player_ns[id],player_b_redirect[id])
				
			}else{
				award_unique_item(id)
			}			
		}
		case 89:
		{
			player_nd[id] = 500
			if(player_dextery[id] >= player_nd[id] ||  player_class[id] == lelf){
				player_b_redirect[id] = random_num(35,45)
				player_item_name[id] = "Starozytna zbroja"
				player_item_id[id] = rannum
				show_hudmessage (id, "Znalazles przedmiot : %s :: Dziala jesli masz %i sily.Redukuje normalne obrazenia %i ",player_item_name[id],player_ns[id],player_b_redirect[id])
			}else{
				award_unique_item(id)
			}			
		}
		case 90:
		{
			player_item_name[id] = "Szata samuraja"
			player_item_id[id] = rannum
			player_loseHp[id]= 1
			player_b_samurai[id]  = random_num(1,10)
			player_b_reduceH[id] = player_lvl[id] / 4
			if(player_b_reduceH[id] > 75) player_b_reduceH[id] = 75
			show_hudmessage(id, "Znalazles przedmiot: %s :: Masz zmienna widzialnosc!",player_item_name[id])		
		}
		case 91:
		{
			player_nd[id] = 25
			if(player_dextery[id] >= player_nd[id]){
				player_item_name[id] = "Mala tarcza"
				player_item_id[id] = rannum
				player_b_redirect[id] = 8
				show_hudmessage (id, "Znalazles przedmiot : %s :: Dziala jesli masz %i sily.Redukuje normalne obrazenia %i ",player_item_name[id],player_ns[id],player_b_redirect[id])
			}else{
				award_unique_item(id)
			}			
		}
		case 92:
		{
			
			player_ns[id] = 50
			if(player_strength[id] >= player_ns[id] ){
				player_item_name[id] = "Duza tarcza"
				player_item_id[id] = rannum
				player_b_redirect[id] = 10
				show_hudmessage (id, "Znalazles przedmiot : %s :: Dziala jesli masz %i sily.Redukuje normalne obrazenia %i ",player_item_name[id],player_ns[id],player_b_redirect[id])
			}else{
				award_unique_item(id)
			}			
		}
		case 93:
		{			
			player_item_name[id] = "Kolczasta tarcza"
			player_item_id[id] = rannum
			player_dziewica_aut[id] = random_num(10,15)
			player_dziewica_using[id]=0
			if(player_class[id] == lelf) player_dziewica_aut[id] = random_num(15,20)
			show_hudmessage (id, "Znalazles przedmiot : %s :: Gracz zadajacy Ci obrazenia tez je otrzymuje. ",player_item_name[id])
		}
		case 94:
		{
			
			player_ni[id] = 60
			if(player_intelligence[id] >= player_ni[id] ){
				player_b_redirect[id] = 18
				player_ultra_armor[id]=random_num(7,10)
				player_ultra_armor_left[id]=player_ultra_armor[id]
				player_item_name[id] = "Ciezka tarcza"
				player_item_id[id] = rannum
				show_hudmessage (id, "Znalazles przedmiot : %s :: Dziala jesli masz %i int.Redukuje normalne obrazenia %i ",player_item_name[id],player_ns[id],player_b_redirect[id])
			}else{
				award_unique_item(id)
			}			
		}
		case 95:
		{
			player_ni[id] = 250
			if(player_intelligence[id] >= player_ni[id] ||  player_class[id] == lelf){
				player_item_id[id] = rannum
				player_item_name[id] = "Kosciana tarcza"
				player_b_redirect[id] = 20
				player_ultra_armor[id]=random_num(7,10)
				player_ultra_armor_left[id]=player_ultra_armor[id]
				if(player_class[id] == Nekromanta || player_class[id] == Witch || player_class[id] == Orc || player_class[id] == Harpia || player_class[id] == Wilk || player_class[id] == aniol || player_class[id] == Wampir){
					player_b_redirect[id] = 30
					player_ultra_armor[id]=random_num(10,15)
					player_ultra_armor_left[id]=player_ultra_armor[id]
				}
				show_hudmessage (id, "Znalazles przedmiot : %s :: Dziala jesli masz %i int lub jestes lesnym elfem.Redukuje normalne obrazenia %i ",player_item_name[id],player_ns[id],player_b_redirect[id])
			}else{
				award_unique_item(id)
			}			
		}
		case 96:
		{
			if(player_class[id] == Ninja){
				award_unique_item(id)
			}else{	
				player_item_name[id] = "Frost shield"
				player_item_id[id] = rannum
				player_b_fireshield[id] = 1
				player_frostShield[id]  = random_num(4,5)
				show_hudmessage(id, "Znalazles przedmiot: %s :: Tarcza mrozu!",player_item_name[id])	
			}		}
		case 97:
		{
			player_nd[id] = 50
			
			if(player_dextery[id] >= player_nd[id] ){
				player_item_id[id] = rannum
				player_knifebonus[id] = 50
				player_item_name[id] = "Palasz"
				show_hudmessage (id, "Znalazles przedmiot : %s :: Dziala jesli masz %i zwinnosci. Zwieksza obrazenia noza o %i ",player_item_name[id],player_nd[id],player_knifebonus[id])
			}else{
				award_unique_item(id)
			}			
		}
		case 98:
		{
			player_nd[id] = 150
			
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
			player_nd[id] = 150
			player_ns[id] = 50
			player_ni[id] = 20
			
			if(player_dextery[id] >= player_nd[id] && player_strength[id] >= player_ns[id] && player_intelligence[id] >= player_ni[id]){
				player_knifebonus[id] = 150
				player_item_name[id] = "Krysztalowy miecz"
				player_item_id[id] = rannum
				show_hudmessage (id, "Znalazles przedmiot : %s :: Dziala jesli masz %i zwinnosci, %i sily i %i inteligencji. Zwieksza obrazenia noza o %i ",player_item_name[id],player_nd[id],player_ns[id],player_ni[id],player_knifebonus[id])
			}else{
				award_unique_item(id)
			}			
		}
		case 100:
		{			
			player_nd[id] = 200
			player_ni[id] = 20
			if(player_dextery[id] >= player_nd[id] && player_intelligence[id] >= player_ni[id]){
				player_knifebonus[id] = 500
				player_katana[id] = 1	
				player_item_id[id] = rannum
				player_item_name[id] = "Katana"
				show_hudmessage (id, "Znalazles przedmiot : %s :: Dziala jesli masz %i zwinnosci, %i sily. Zwieksza obrazenia noza o %i ",player_item_name[id],player_nd[id],player_ns[id],player_knifebonus[id])
			}else{
				award_unique_item(id)
			}			
		}
		case 101:
		{
			
			player_ni[id] = 100			
			if(player_intelligence[id] >= player_ni[id]){
				player_item_id[id] = rannum
				player_item_name[id] = "Topor"
				player_b_damage[id] = 13
				show_hudmessage (id, "Znalazles przedmiot : %s :: Dziala jesli masz %i int. Dodaje obrazenia %i ",player_item_name[id],player_ns[id],player_b_damage[id])
			}else{
				award_unique_item(id)
			}			
		}
		case 102:
		{
			
			player_ni[id] = 250
			if(player_intelligence[id] >= player_ni[id]){
				player_item_name[id] = "Topor bitewny"
				player_item_id[id] = rannum
				player_b_damage[id] = 25
				show_hudmessage (id, "Znalazles przedmiot : %s :: Dziala jesli masz %i int.Dodaje obrazenia %i ",player_item_name[id],player_ns[id],player_b_damage[id])
			}else{
				award_unique_item(id)
			}			
		}
		case 103:
		{
			player_item_name[id] = "Kosa"
			player_item_id[id] = rannum
			player_b_extrastats[id] = 10
			player_b_damage[id] = 5
			if(player_class[id] == Nekromanta){
				player_b_damage[id] = 10
				player_b_extrastats[id] = 30
			}
			BoostStats(id,player_b_extrastats[id])
			show_hudmessage (id, "Znalazles przedmiot : %s :: Dziala lepiej jesli jestes Nekromanta.Dodaje obrazenia %i. Zyskasz +%i do statystyk. ",player_item_name[id],player_b_damage[id],player_b_extrastats[id])
			player_staty[id]=1
		}
		case 104:
		{
			player_item_name[id] = "Arabian Boots"
			player_item_id[id] = rannum
			player_b_theif[id] = random_num(900,1000)
			show_hudmessage(id, "Znalazles przedmiot: %s :: Kazdy strzal kradnie %i zlota. Uzyj zeby zamienic zloto w 20 hp",player_item_name[id],player_b_theif[id])
		}
		case 105:
		{
			if(player_class[id] == Hunter){
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
			if(player_class[id] == Hunter && player_strength[id] >= player_nd[id]){
				player_intbonus[id] = 200
				player_item_id[id] = rannum
				player_item_name[id] = "Kusza bojowa"
				
				BoostInt(id,player_intbonus[id])
				show_hudmessage (id, "Znalazles przedmiot : %s :: Dziala jesli masz %i sily. Dziala tylko dla lowcy. Zyskasz +%i do inteligencji. ",player_item_name[id],player_ns[id],player_intbonus[id])
				player_staty[id]=1
			}else{
				award_unique_item(id)
			}			
		}
		case 107:
		{
			if(player_class[id] == Ninja){
				award_unique_item(id)
			}else{	
				player_item_name[id] = "Pociski z zebow smoka"
				player_item_id[id] = rannum
				player_smocze[id]  = random_num(20,40)
				show_hudmessage(id, "Znalazles przedmiot: %s :: Twoje pociski rania mocniej ale i Ciebie!",player_item_name[id])	
			}
		}
		case 108:
		{
			player_item_name[id] = "Gold Amplifier"
			player_item_id[id] = rannum
			player_b_damage[id] = random_num(6,10)
			if(player_class[id] == lelf ){
				player_b_damage[id] = random_num(10,14)
			}
			show_hudmessage(id, "Znalazles przedmiot: %s :: dodaje obrazenia +%i ",player_item_name[id],player_b_damage[id])
		}
		case 109:
		{
			player_item_name[id] = "Wojenne berlo"
			player_item_id[id] = rannum
			player_intbonus[id] = 20
			if(player_class[id] == lelf ||  player_class[id] == Arcymag  ){
				player_intbonus[id] = 50
				player_strbonus[id] = 100
			}
			BoostInt(id,player_intbonus[id])
			BoostStr(id,player_strbonus[id])
			show_hudmessage (id, "Znalazles przedmiot : %s :: Dziala lepiej jesli jestes lesnym elfem lub Arcymagiem. Zyskasz +%i do inteligencji i +%i do sily. ",player_item_name[id],player_intbonus[id],player_strbonus[id])
			player_staty[id]=1
		}
		case 110:
		{
			player_knifebonus[id] = 5000
			player_green[id]=1
			player_Slow[id]=50
			player_NoCharging[id]=1
			player_katana[id] = 1	
			player_item_id[id] = rannum
			player_item_name[id] = "Katana mistrza"
			show_hudmessage (id, "Znalazles przedmiot : %s ::  Zwieksza obrazenia noza o %i ",player_item_name[id],player_nd[id],player_ns[id],player_knifebonus[id])
		}
		case 111:
		{
			player_item_name[id] = "Wojenne berlo swiatlosci"
			player_item_id[id] = rannum
			player_intbonus[id] = 20
			player_mrocznibonus[id] = 3
			if(player_class[id] == lelf || player_class[id] == Arcymag  ){
				player_intbonus[id] = 60
				player_strbonus[id] = 100
				player_mrocznibonus[id] = 30
			}
			BoostInt(id,player_intbonus[id])
			BoostStr(id,player_strbonus[id])
			show_hudmessage (id, "Znalazles przedmiot : %s :: Dziala lepiej jesli jestes lesnym elfem lub Arcymagiem. Zyskasz +%i do inteligencji i +%i do sily. Zwieksza obrazenia dla mrocznych o  %i",player_item_name[id],player_intbonus[id],player_strbonus[id],player_mrocznibonus[id])
			player_staty[id]=1
		}
		case 112:
		{
			player_item_name[id] = "Totem Lodu"
			player_item_id[id] = rannum
			player_totem_lodu[id] = random_num(5,15)
			player_totem_lodu_zasieg[id] = random_num(100,400)
			if(player_class[id] == lelf) player_totem_lodu[id]  = random_num(5,20)
			show_hudmessage (id, "Znalazles przedmiot : %s :: Poloz totem ktory zamrozi przeciwnikow w promieniu %i na %i sekund. ",player_item_name[id],player_totem_lodu_zasieg[id],player_totem_lodu[id])
		
		}
		case 113:
		{
			player_item_name[id] = "Wielki Totem Lodu"
			player_item_id[id] = rannum
			player_totem_lodu[id] = random_num(5,20)
			player_totem_lodu_zasieg[id] = random_num(300,500)
			if(player_class[id] == lelf) player_totem_lodu[id]  = random_num(10,30)
			show_hudmessage (id, "Znalazles przedmiot : %s :: Poloz totem ktory zamrozi przeciwnikow w promieniu %i na %i sekund. ",player_item_name[id],player_totem_lodu_zasieg[id],player_totem_lodu[id])
		
		}
		case 114:
		{
			player_item_name[id] = "Silver Amplifier"
			player_item_id[id] = rannum
			player_b_damage[id] = random_num(5,6)
			if(player_class[id] == lelf ){
				player_b_damage[id] = random_num(6,10)
			}
			show_hudmessage(id, "Znalazles przedmiot: %s :: dodaje obrazenia +%i ",player_item_name[id],player_b_damage[id])
		}
		case 115:
		{
			if(player_class[id]==lelf ){
				award_unique_item(id)
			}else{	
				player_item_name[id] = "Maly zwoj skupienia"
				player_item_id[id] = rannum
				player_recoil[id] = random_num(5,7)
				if(player_class[id] == lelf) player_recoil[id]  = random_num(4,7)
				show_hudmessage (id, "Znalazles przedmiot : %s :: Zwoj pozwala Ci sie skupic na walce. Idealnie celny strzal co %i naboi. ",player_item_name[id],player_recoil[id])
			}
		}
		case 116:
		{
			if(player_class[id] == Ninja){
				award_unique_item(id)
			}else{
				player_item_name[id] = "Przywolanie potwora"
				give_item(id, "weapon_awp");
				player_item_id[id] = rannum
				player_monster[id]  = 15
				changeskin(id,1)
				count_jumps(id)
				show_hudmessage(id, "Znalazles przedmiot: %s :: Jestes potworem! Masz 10 szybkich skokow, +1500hp, ale mozesz uzywac tylko noza!",player_item_name[id])	
			}
		}
		case 117:
		{
			player_item_name[id] = "Zwoj skupienia"
			player_item_id[id] = rannum
			player_recoil[id] = random_num(2,4)
			if(player_class[id] == lelf) player_recoil[id]  = random_num(2,4)
			show_hudmessage (id, "Znalazles przedmiot : %s :: Zwoj pozwala Ci sie skupic na walce. Idealnie celny strzal co %i naboi. ",player_item_name[id],player_recoil[id])
		}
		case 118:
		{
			if(player_class[id] == lelf){
				player_b_extrastats[id]  = 25
				player_b_vampire[id]=25
				player_item_name[id] = "Jaredowy kamien"
				player_item_id[id] = rannum
				BoostStats(id,player_b_extrastats[id])
				show_hudmessage (id, "Znalazles przedmiot : %s ::  Zyskasz +%i do statystyk. Wysysasz %i hp wrogowi. ",player_item_name[id],player_b_extrastats[id],player_b_vampire[id])
				player_staty[id]=1
			}else{
				award_unique_item(id)
			}
		}
		case 119:
		{
			player_item_name[id] = "Potezny Zwoj skupienia"
			player_item_id[id] = rannum
			player_recoil[id] = 1
			if(player_class[id] == lelf) player_recoil[id]  = 1
			show_hudmessage (id, "Znalazles przedmiot : %s :: Zwoj pozwala Ci sie skupic na walce. Idealnie celny strzal co %i naboi. ",player_item_name[id],player_recoil[id])
		}
		case 120:
		{
			player_item_name[id] = "Lodowe pociski"
			player_item_id[id] = rannum
			player_lodowe_pociski[id] = random_num(3,13)
			if(player_class[id] == lelf) player_lodowe_pociski[id]  = random_num(2,5)
			
			show_hudmessage (id, "Znalazles przedmiot : %s :: Szansa 1/%i na zamrozenie przeciwnika. ",player_item_name[id],player_lodowe_pociski[id])
		}
		case 121:
		{
			player_item_name[id] = "Pociski z kory Enta"
			player_item_id[id] = rannum
			player_entowe_pociski[id] = random_num(3,10)
			if(player_class[id] == lelf) player_entowe_pociski[id]  = random_num(2,5)
			show_hudmessage (id, "Znalazles przedmiot : %s :: Szansa 1/%i na splatanie przeciwnika. ",player_item_name[id],player_entowe_pociski[id])
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
			player_item_name[id] = "Ostrze mrozu"
			player_item_id[id] = rannum
			player_knifebonus_p[id] = 100
			player_lodu_p[id] = 1
			show_hudmessage(id, "Znalazles przedmiot : %s :: Masz dodatkowe obrazenia z noza oraz zamrazanie jesli jestes w powietrzu.",player_item_name[id])	
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
			if(player_lvl[id] <= 10  && player_class[id] != Archeolog ){
				player_item_name[id] = "Zwoj nowicjusza"
				player_item_id[id] = rannum
				player_dosw[id] = 500
				show_hudmessage(id, "Znalazles przedmiot : %s ::  Wcisnij e by dostac %i doswiadczenie!",player_item_name[id], player_dosw[id])	
			}else{
				award_unique_item(id)
			}
		}
		case 127:
		{
			if(player_lvl[id] <= 10  && player_class[id] != Archeolog ){
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
			if(player_lvl[id] <= 25  && player_class[id] != Archeolog  ){
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
			if(player_lvl[id] <= 25  && player_class[id] != Archeolog ){
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
			if(player_lvl[id] <= 50  && player_class[id] != Archeolog  ){
				player_item_name[id] = "Duzy zwoj czeladnika"
				player_item_id[id] = rannum
				player_dosw[id] = 500
				show_hudmessage(id, "Znalazles przedmiot : %s ::  Wcisnij e by dostac %i doswiadczenie!",player_item_name[id], player_dosw[id])	
			}else{
				award_unique_item(id)
			}
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
			if(player_lvl[id] <= 100  && player_class[id] != Archeolog  ){
				player_item_name[id] = "Zwoj mistrza"
				player_item_id[id] = rannum
				player_dosw[id] = 200
				show_hudmessage(id, "Znalazles przedmiot : %s ::  Wcisnij e by dostac %i doswiadczenie!",player_item_name[id], player_dosw[id])	
			}else{
				award_unique_item(id)
			}
		}
		case 136:
		{
			if(player_lvl[id] <= 100 && player_class[id] != Archeolog ){
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
			if(player_class[id] == lelf ){
				player_chargetime[id] = 5
				player_b_mine[id] = 1
				show_hudmessage(id, "Znalazles przedmiot : %s ::  Zmniejsza czas ladowania o 0.5 sekundy! Mozesz podlozyc 3 miny.",player_item_name[id])	
			}
			else{
				player_chargetime[id] = 5
				show_hudmessage(id, "Znalazles przedmiot : %s ::  Zmniejsza czas ladowania o 0.5 sekundy!",player_item_name[id])	
			}
		}
		case 138:
		{
			player_item_name[id] = "Srebrny pierscien oswiecenia"
			player_item_id[id] = rannum
			if(player_class[id] == lelf ){
				player_chargetime[id] = 10
				player_b_meekstone[id] = 1
				show_hudmessage(id, "Znalazles przedmiot : %s ::  Zmniejsza czas ladowania o 1 sekunde! Mozesz podlozyc sztuczna bombe.",player_item_name[id])	
			}
			else{
				player_chargetime[id] = 10
				show_hudmessage(id, "Znalazles przedmiot : %s ::  Zmniejsza czas ladowania o 1 sekunde!",player_item_name[id])	
			}
		}
		case 139:
		{
			player_item_name[id] = "Zloty pierscien oswiecenia"
			player_item_id[id] = rannum
			if(player_class[id] == lelf ){
				player_chargetime[id] = 15
				player_b_money[id] = random_num(1200,3000)+ player_intelligence[id] *50
				show_hudmessage(id, "Znalazles przedmiot : %s ::  Zmniejsza czas ladowania o 1.5 sekundy! Dostajesz Large gold bag: daje on zloto w kazdej rundzie, uzyj go by Cie chronil.",player_item_name[id])	
			}
			else{
				player_chargetime[id] = 15
				show_hudmessage(id, "Znalazles przedmiot : %s ::  Zmniejsza czas ladowania o 1.5 sekundy!",player_item_name[id])	
			}
		}
		case 140:
		{
			player_item_name[id] = "Diamentowy pierscien oswiecenia"
			player_item_id[id] = rannum
			if(player_class[id] == lelf ){
				player_chargetime[id] = 20
				player_b_gravity[id] = random_num(5,9)
			
				if (is_user_alive(id))
					set_gravitychange(id)
				
				show_hudmessage(id, "Znalazles przedmiot : %s ::  Zmniejsza czas ladowania o 2 sekundy! Dostajesz archangel wings +%i premia wyzszego skoku - Wcisnij e zeby uzyc.",player_item_name[id], player_b_gravity[id])	
			}
			else{
				player_chargetime[id] = 20
				show_hudmessage(id, "Znalazles przedmiot : %s ::  Zmniejsza czas ladowania o 2 sekundy!",player_item_name[id])	
			}
		}
		case 141:
		{
			player_item_name[id] = "Zwoj Aard"
			player_item_id[id] = rannum
			player_aard[id] = random_num(1,2)
			player_b_silent[id] = 1
			show_hudmessage(id, "Znalazles przedmiot: %s :: Odrzucenie przeciwnikow",player_item_name[id],player_aard[id])	
		}
		case 142:
		{
			player_item_name[id] = "Srebrny pierscien szybkosci"
			player_item_id[id] = rannum
			player_speedbonus[id] =  40
			if(player_class[id] == lelf ){
				player_speedbonus[id] = 95
			}
	
			if (is_user_alive(id))
				set_speedchange(id)
				
			show_hudmessage(id, "Znalazles przedmiot : %s ::  Bonus do szybkosci %i ",player_item_name[id],player_speedbonus[id])	
		}
		case 143:
		{
			player_item_name[id] = "Zloty pierscien szybkosci"
			player_item_id[id] = rannum
			player_speedbonus[id] = 50
			if(player_class[id] == lelf ){
				player_speedbonus[id] = 120
			}
	
			if (is_user_alive(id))
				set_speedchange(id)
				
			show_hudmessage(id, "Znalazles przedmiot : %s ::  Bonus do szybkosci %i ",player_item_name[id],player_speedbonus[id])	
		}
		case 144:
		{
			player_item_name[id] = "Diamentowy pierscien szybkosci"
			player_item_id[id] = rannum
			player_speedbonus[id] = 75
			if(player_class[id] == lelf ){
				player_speedbonus[id] = 180
			}
	
			if (is_user_alive(id))
				set_speedchange(id)
				
			show_hudmessage(id, "Znalazles przedmiot : %s ::  Bonus do szybkosci %i ",player_item_name[id],player_speedbonus[id])	
		}
		case 145:
		{
			player_nd[id] = 55
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
			player_item_name[id] = "Krasnoludzki mlot bojowy"
			player_item_id[id] = rannum
			player_DoubleDmg[id] = 100
			player_DoubleMagicDmg[id] = 100
			player_b_m3[id] = 3
			player_b_reduceH[id] = player_lvl[id] / 4
			fm_give_item(id, "weapon_m3")
			give_item(id, "ammo_buckshot")
			give_item(id, "ammo_buckshot")
			give_item(id, "ammo_buckshot")
			show_hudmessage(id, "Znalazles przedmiot: %s :: 1/%i szans do natychmiastowego zabicia shotgunem m3",player_item_name[id],player_b_m3[id])
		}
		case 148:
		{
			if(player_class[id] != Ninja &&player_class[id] != Harpia && player_class[id] != MagP){
				player_grawitacja[id] = 25	
				player_item_id[id] = rannum
				player_item_name[id] = "Pierscien wiatru"
				show_hudmessage(id, "Znalazles przedmiot: %s :: Grawitacja zmniejszona do 0.3",player_item_name[id])
				if (is_user_alive(id))
					set_gravitychange(id)
			}else{
				award_unique_item(id)
			}
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
			if(player_class[id] == aniol || player_class[id] == MagP || player_class[id] == MagZ ||player_class[id] == MagW ||player_class[id] == Arcymag  || player_class[id] == MagO){
				player_naszyjnikczasu[id] = 20
				player_item_id[id] = rannum
				player_item_name[id] = "Naszyjnik czasu"
				show_hudmessage(id, "Znalazles przedmiot: %s :: Mozesz uzyc mocy postaci szybciej o %i procent",player_item_name[id],player_naszyjnikczasu[id] )
			}else{
				award_unique_item(id)
			}
		}
		case 151:
		{
			if(player_class[id] == aniol || player_class[id] == MagP || player_class[id] == MagZ ||player_class[id] == MagW ||player_class[id] == Arcymag  || player_class[id] == MagO){
				player_naszyjnikczasu[id] = 30	
				player_item_id[id] = rannum
				player_item_name[id] = "Starozytny naszyjnik czasu"
				show_hudmessage(id, "Znalazles przedmiot: %s :: Mozesz uzyc mocy postaci szybciej o %i procent",player_item_name[id],player_naszyjnikczasu[id] )
			}else{
				award_unique_item(id)
			}
		}
		case 152:
		{
			if(player_class[id]==lelf ){
				award_unique_item(id)
			}else{	
				player_tarczam[id] = random_num(20,50)
				if(player_class[id] == lelf) player_tarczam[id]*=2
				player_b_redirect[id] = random_num(5,15)
				DamRedCalc(id, player_tarczam[id])
				player_item_id[id] = rannum
				player_item_name[id] = "Mala tarcza krasnoluda"
				show_hudmessage(id, "Znalazles przedmiot: %s :: Ochrona przed magia %i",player_item_name[id],player_tarczam[id])
			}
		}
		case 153:
		{
			player_item_name[id] = "Sztylet mrozu"
			player_item_id[id] = rannum
			player_knifebonus_p[id] = 1
			player_lodu_p[id] = 25
			show_hudmessage(id, "Znalazles przedmiot : %s :: Masz dodatkowe obrazenia z noza oraz zamrazanie jesli jestes w powietrzu.",player_item_name[id])
		}
		case 154:
		{
			player_tarczam[id] = random_num(100,200)
			if(player_class[id] == lelf) player_tarczam[id]*=2
			player_b_redirect[id] = random_num(2,4)
			player_item_id[id] = rannum
			DamRedCalc(id, player_tarczam[id])
			player_item_name[id] = "Starozytna krasnoludzka tarcza"
			show_hudmessage(id, "Znalazles przedmiot: %s :: Ochrona przed magia %i",player_item_name[id],player_tarczam[id])
		}
		case 155:
		{
			player_tarczam[id]= random_num(200,300)
			if(player_class[id] == lelf) player_tarczam[id]*=2
			player_item_id[id] = rannum
			DamRedCalc(id, player_tarczam[id])
			player_item_name[id] = "Tarcza z lusek czarnego smoka"
			show_hudmessage(id, "Znalazles przedmiot: %s :: Ochrona przed magia %i",player_item_name[id],player_tarczam[id])
		}
		case 156:
		{
			if(player_class[id] == Ninja){
				award_unique_item(id)
			}else{
				player_b_damage[id] = 20	
				if(get_user_health(id) >  get_maxhp(id)) set_user_health(id,get_maxhp(id))
				player_b_reduceH[id] = 50 + player_lvl[id] / 10
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
				player_itemw8[id]=SpijaczDusz
				player_item_id[id] = rannum
				item_durability[id] = 50
				player_item_name[id] = "Spijacz Dusz"
				show_hudmessage(id, "Znalazles przedmiot: %s :: Twoje hp jest zredukowane, bonus do ataku %i",player_item_name[id],player_b_damage[id])
			}
		}
		case 158:
		{
			if(player_class[id] == Ninja){
				award_unique_item(id)
			}else{
				player_itemw8[id]=OstrySpijaczDusz
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
				player_itemw8[id]=WampirycznySpijaczDusz 
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
			}
		}
		case 161:
		{
			if(player_lvl[id] <= 50){
				player_grom[id]= 50
				player_item_id[id] = rannum
				player_item_name[id] = "Runa lancuch piorunow"
				show_hudmessage(id, "Znalazles przedmiot: %s :: Wcisnij e by zadac przeciwnikom %i obrazen",player_item_name[id],player_grom[id])
			}
		}
		case 162:
		{
			if(player_lvl[id] <= 10){
				player_grom[id]= 500
				player_item_id[id] = rannum
				player_item_name[id] = "Runa smiertelny grom"
				show_hudmessage(id, "Znalazles przedmiot: %s :: Wcisnij e by zadac przeciwnikom %i obrazen",player_item_name[id],player_grom[id])
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
			player_b_silent[id] = 1
			player_item_name[id] = "Pierscien lotrzyka"
			show_hudmessage(id, "Znalazles przedmiot: %s :: Wcisnij e by teleportowac sie na resp",player_item_name[id])
		}
		case 165:
		{
			player_item_name[id] = "Krasnoludzki mlot"
			player_item_id[id] = rannum
			player_b_m3[id] = random_num(4,7)
			fm_give_item(id, "weapon_m3")
			give_item(id, "ammo_buckshot")
			give_item(id, "ammo_buckshot")
			give_item(id, "ammo_buckshot")
			show_hudmessage(id, "Znalazles przedmiot: %s :: 1/%i szans do natychmiastowego zabicia shotgunem m3",player_item_name[id],player_b_m3[id])
		}
		case 166:
		{
			player_item_id[id] = rannum
			player_skin[id]=1
			player_b_damage[id] = 4
			player_b_windwalk[id] = 10
			player_speedbonus[id] = 20
			changeskin(id,0)
			player_item_name[id] = "Srebrny pierscien mordercy"
			show_hudmessage(id, "Znalazles przedmiot: %s :: Jestes morderca!",player_item_name[id])
		}
		case 167:
		{
			player_item_id[id] = rannum
			player_skin[id]=1
			player_b_damage[id] = 7
			player_b_windwalk[id] = 20
			player_speedbonus[id] = 50
			player_DoubleMagicDmg[id] = 50
			changeskin(id,0)
			player_item_name[id] = "Zloty pierscien mordercy"
			show_hudmessage(id, "Znalazles przedmiot: %s :: Jestes morderca!",player_item_name[id])
		}
		case 168:
		{						
			player_item_id[id] = rannum
			player_b_inv[id] = random_num(60,120)
			player_b_blind[id] = random_num(4,9)
			player_b_heal[id] = random_num(5,9)
			player_item_name[id] = "Plaszcz doskonalosci"
			show_hudmessage(id, "Znalazles przedmiot: %s :: Redukuje twoja widocznosc, masz szanse, ze twoj przeciwnik straci wzrok, regeneruje twoje zdrowie i mozesz postawic totem leczacy na 7 sek",player_item_name[id])
		}
		case 169:
		{			
			player_item_name[id] = "Amulet Draculi"
			player_item_id[id] = rannum
			player_b_vampire[id] = random_num(2,3)
			player_b_damage[id] = random_num(2,3)
			player_b_redirect[id] = random_num(2,3)
			player_b_reduceH[id] = random_num(5,45)
			show_hudmessage(id, "Znalazles przedmiot: %s :: Kradniesz wrogowi zycie, zadajesz dodatkowe obrazenia, zmniejsza otrzymywane obrazenia",player_item_name[id])
		}
		case 170:
		{
			if(player_class[id] == Ninja && random_num(0,4)==0){
				award_unique_item(id)
			}else{
				player_item_name[id] = "Skrzydla demona"
				player_item_id[id] = rannum
				player_b_gravity[id] = random_num(8,12)
				player_b_reduceH[id] = 75
				if(get_user_health(id) >  get_maxhp(id)) set_user_health(id,get_maxhp(id))
				if (is_user_alive(id))
					set_gravitychange(id)
				player_b_blink[id] = 1
				player_b_jumpx[id] = 1
				show_hudmessage(id, "Znalazles przedmiot: %s :: Premia do wysokiego skoku +%s, twoje zdrowie zredukowanie jest o 75, mozesz teleportowac sie za pomoca noza, mozesz wykonac dodatkowy skok w powietrzu",player_item_name[id],player_b_gravity[id])
			}
		}
		case 171:
		{			
			player_item_name[id] = "Zbroja Feniksa"
			player_item_id[id] = rannum
			item_durability[id] *= 10
			player_b_respawn[id] = 1
			show_hudmessage(id, "Znalazles przedmiot: %s :: Masz 1/1 na odrodzenie sie po zgonie",player_item_name[id])		
		}
		case 172:
		{			
			player_item_name[id] = "Small bronze bag"
			player_item_id[id] = rannum
			player_b_money[id] = random_num(150,500)+ player_intelligence[id] *50
			if(player_class[id] == lelf ){
				player_b_money[id] = random_num(500,1200)+ player_intelligence[id] *50
			}
			show_hudmessage(id, "Znalazles przedmiot: %s :: dostajesz %i zloto w kazdej rundzie. Uzyj, zeby chronil cie.",player_item_name[id],player_b_money[id]+player_intelligence[id]*50)	
		}
		case 173:
		{
			player_item_name[id] = "Pierscien gladiatora"
			player_item_id[id] = rannum
			player_b_blink_sec[id] = 1
			player_b_jumpx[id] = 1
			show_hudmessage(id, "Znalazles przedmiot: %s :: Mozesz teleportowac sie za pomoca swojego noza, mozesz wykonac dodatkowy skok w powietrzu",player_item_name[id])
		}
		case 174:
		{
			player_item_name[id] = "Pierscien calkowitej niewidzialnosci"
			player_itemw8[id]=PCN
			player_item_id[id] = rannum
			item_durability[id] = 50	
			show_hudmessage(id, "Znalazles przedmiot: %s :: Stajesz sie calkowicie niewidoczny, twoje zdrowie jest zredukowane do 5, mozesz przyciagnac przeciwnika za pomoca haka",player_item_name[id])
		}
		case 175:
		{
			player_item_name[id] = "Przeklete ostrze"
			player_item_id[id] = rannum
			player_b_vampire[id] = 3
			player_b_blind[id] = 1
			player_b_explode[id] = 500
			show_hudmessage(id, "Znalazles przedmiot: %s :: Kradniesz przeciwnikowi zyie, oslepisz go, jak zginiesz to wybuchniesz w promieniu 500",player_item_name[id])
		}
		case 176:
		{
			if(player_class[id] == szelf ){
				award_unique_item(id)
			}else if(player_class[id] == Ninja){
				award_unique_item(id)
			}else{
				player_item_name[id] = "Doskonaly Fireshield"
				player_item_id[id] = rannum
				player_b_skill[id] = 1
				player_b_fireshield[id] = 1
				player_b_heal[id] = random_num(5,15)
				show_hudmessage(id, "Znalazles przedmiot: %s :: Fireshield, dodatkowo regenerujesz swoje zdrowie",player_item_name[id])
			}		
		}
		case 177:
		{
			player_item_name[id] = "Naszyjnik mysliwego"
			player_item_id[id] = rannum
			player_b_grenade[id] = 4
			fm_give_item(id, "weapon_hegrenade")
			player_b_sniper[id] = 4
			fm_give_item(id, "weapon_scout")
			player_b_heal[id] = 5
			show_hudmessage(id, "Znalazles przedmiot: %s :: 1/x na zabicie z HE, 1/x na zabicie ze Scouta, regenerjesz swoje zdrowie",player_item_name[id])		
		}
		case 178:
		{
			player_item_name[id] = "Moc demona"
			player_itemw8[id]=MocDemona
			player_item_id[id] = rannum
			item_durability[id] = 50
			show_hudmessage(id, "Znalazles przedmiot: %s :: Twoja widocznosc zredukowana jest do 20, Twoje hp zredukowane jest do 5, zabojstwa dodaja do itemu dodatkowe obrazenia",player_item_name[id])
		}
		case 179:
		{
			player_item_name[id] = "Amulet lotu"
			player_item_id[id] = rannum
			player_b_jumpx[id] = 5
			player_b_ghost[id] = 20
			show_hudmessage(id, "Znalazles przedmiot: %s :: Latasz!",player_item_name[id])		
		}
		case 180:
		{
			player_item_name[id] = "Bezdenna sakiewka zlota"
			player_b_zlotoadd[id] = random_num(100,5000)
			player_item_id[id] = rannum
			show_hudmessage(id, "Znalazles przedmiot: %s :: Dostajesz zloto na poczatku rundy!",player_item_name[id])
					
		}
		case 181:
		{
			player_item_name[id] = "Bezdenna sakwa zlota"
			player_b_zlotoadd[id] = random_num(10,16) * 1000
			player_item_id[id] = rannum
			show_hudmessage(id, "Znalazles przedmiot: %s :: Dostajesz zloto na poczatku rundy!",player_item_name[id])
					
		}
		case 182:
		{
			player_item_name[id] = "Krysztal magii"
			player_krysztalmagii[id] = random_num(5,15)
			player_b_mine[id] = random_num(2,3)
			if(player_class[id] == lelf){
				player_krysztalmagii[id] = random_num(15,55)
				player_b_mine[id] = random_num(5,10)
			}
			player_item_id[id] = rannum
			show_hudmessage(id, "Znalazles przedmiot: %s :: Za kazdym razem gdy zadajesz magiczne obrazenia dostajesz dodatkowa predkosc, spowalniasz ofiare, otrzymujesz zloto, dostajesz hp ",player_item_name[id])
		}
		case 183:
		{
			if(player_class[id]!=szelf){
				player_item_name[id] = "Invisibility Armor"
				player_item_id[id] = rannum
				player_b_inv[id] = random_num(70,110)
				show_hudmessage(id, "Znalazles przedmiot: %s :: +%i premii niewidocznosci",player_item_name[id],255-player_b_inv[id])	
			}else{
				award_unique_item(id)
			}
		}
		case 184:
		{
			if(player_class[id]==lelf ){
				award_unique_item(id)
			}else{	
				player_item_name[id] = "Bezdenny mieszek zlota"
				player_b_zlotoadd[id] = random_num(3000,7000)
				player_item_id[id] = rannum
				show_hudmessage(id, "Znalazles przedmiot: %s :: Dostajesz zloto na poczatku rundy!",player_item_name[id])
			}		
		}
		case 185:
		{
			player_item_name[id] = "Tarcza ogra"
			player_b_tarczaogra[id] = random_num(3,10)
			player_item_id[id] = rannum
			show_hudmessage(id, "Znalazles przedmiot: %s :: Uzyj by byc niezniszczalnym na %s sekund!",player_item_name[id],player_b_tarczaogra[id])
					
		}
		case 186:
		{
			if(player_class[id]==lelf ){
				award_unique_item(id)
			}else{	
				player_item_name[id] = "Oko sokola"
				player_item_id[id] = rannum
				player_oko_sokola[id] = random_num(3,5)
				show_hudmessage (id, "Znalazles przedmiot : %s :: Totem: Podsiwetlajcay graczy. ",player_item_name[id])
			}
		}
		case 187:
		{
			player_item_name[id] = "Totem powietrza"
			player_item_id[id] = rannum
			player_totem_powietrza_zasieg[id] = random_num(100,550)
			show_hudmessage (id, "Znalazles przedmiot : %s :: Totem: Szansa na wyrzucenie przeciwnikowi broni. ",player_item_name[id])
		}
		case 188:
		{
			player_item_name[id] = "Pociski magii powietrza"
			player_item_id[id] = rannum
			player_pociski_powietrza[id] = random_num(5,10)
			if(player_class[id] == lelf || player_class[id] == MagP) player_pociski_powietrza[id]  = random_num(1,15)
			show_hudmessage (id, "Znalazles przedmiot : %s :: Szansa 1/%i na wyrzucenie przeciwnikowi broni. ",player_item_name[id],player_pociski_powietrza[id])
		}
		case 189:
		{
			if(player_class[id] == lelf ){
				player_item_name[id] = "Laska z drzewa Gondoru"
				player_item_id[id] = rannum
				player_laska[id] = 2
				player_intbonus[id] = 250
				BoostInt(id,player_intbonus[id])
				show_hudmessage (id, "Znalazles przedmiot : %s :: Zyskasz +%i do inteligencji. Mozesz rzucic lightball co %i sekund",player_item_name[id],player_intbonus[id],player_laska[id])
				player_staty[id]=1
			}else if(player_class[id] == Mag ){
				player_item_name[id] = "Laska z drzewa Gondoru"
				player_item_id[id] = rannum
				player_laska[id] = 5
				player_intbonus[id] = 70
				BoostInt(id,player_intbonus[id])
				show_hudmessage (id, "Znalazles przedmiot : %s :: Zyskasz +%i do inteligencji. Mozesz rzucic lightball co %i sekund",player_item_name[id],player_intbonus[id],player_laska[id])
				player_staty[id]=1
			}else{
				award_unique_item(id)
			}
		}
		case 190:
		{
			if(player_class[id] == Mag ){
				player_item_name[id] = "Kosciana rozdzka"
				player_item_id[id] = rannum
				player_b_dagon[id] = random_num(1,2)
				player_intbonus[id] = 30
				BoostInt(id,player_intbonus[id])
				show_hudmessage (id, "Znalazles przedmiot : %s :: Zyskasz +%i do inteligencji. Mozesz uderzyc przeciwnika piorunem.",player_item_name[id],player_intbonus[id])
				player_staty[id]=1
			}else{
				award_unique_item(id)
			}
		}
		case 191:
		{
			if(player_class[id]==lelf ){
				award_unique_item(id)
			}else{	
				player_item_name[id] = "Chwila ryzyka"
				player_item_id[id] = rannum
				player_chwila_ryzyka[id] = 1
				show_hudmessage (id, "Znalazles przedmiot : %s :: Wylosuj 20 000$ + exp lub swoja smierc ",player_item_name[id])
			}
		}
		case 192:
		{
			if(player_class[id]==lelf ){
				award_unique_item(id)
			}else{	
				player_item_name[id] = "Naszyjnik lotrzyka"
				fm_give_item(id, "weapon_hegrenade")
				player_item_id[id] = rannum
				player_gtrap[id] = 1
				player_b_silent[id] = 1
				show_hudmessage (id, "Znalazles przedmiot : %s :: Mozesz podkladac granaty pulapki. ",player_item_name[id])
			}
		}
		case 193:
		{
			player_item_name[id] = "Male lembasy"
			player_item_id[id] = rannum
			player_lembasy[id] = random_num(1,2)
			show_hudmessage (id, "Znalazles przedmiot : %s :: Mozesz zatrzymac sie na %i sekund by dostac %i hp.  ",player_item_name[id],player_lembasy[id] ,player_lembasy[id] *25)
		}
		case 194:
		{
			player_item_name[id] = "Lembasy"
			player_item_id[id] = rannum
			player_lembasy[id] = random_num(2,3)
			show_hudmessage (id, "Znalazles przedmiot : %s :: Mozesz zatrzymac sie na %i sekund by dostac %i hp.  ",player_item_name[id],player_lembasy[id] ,player_lembasy[id] *25)
		}
		case 195:
		{
			player_item_name[id] = "Duze lembasy"
			player_item_id[id] = rannum
			player_lembasy[id] = random_num(3,4)
			show_hudmessage (id, "Znalazles przedmiot : %s :: Mozesz zatrzymac sie na %i sekund by dostac %i hp.  ",player_item_name[id],player_lembasy[id] ,player_lembasy[id] *25)
		}
		case 196:
		{
			player_item_name[id] = "Worek z lembasami"
			player_item_id[id] = rannum
			player_lembasy[id] = random_num(5,8)
			show_hudmessage (id, "Znalazles przedmiot : %s :: Mozesz zatrzymac sie na %i sekund by dostac %i hp.  ",player_item_name[id],player_lembasy[id] ,player_lembasy[id] *10)
		}
		case 197:
		{
			player_item_name[id] = "Totem Pradawnego Enta"
			player_item_id[id] = rannum
			player_totem_enta[id] = random_num(10,18)
			player_totem_enta_zasieg[id] = random_num(400,700)
			if(player_class[id] == lelf) player_totem_enta[id]  = random_num(25,50)
			show_hudmessage (id, "Znalazles przedmiot : %s :: Poloz totem ktory zatrzyma przeciwnikow w promieniu %i na %i sekund. ",player_item_name[id],player_totem_enta_zasieg[id],player_totem_enta[id])
		}
		case 198:
		{
			player_item_name[id] = "Zelazna Dziewica"
			player_item_id[id] = rannum
			player_dziewica[id] = random_num(45,55)
			player_dziewica_using[id]=0
			if(player_class[id] == lelf) player_dziewica[id] = random_num(50,60)
			show_hudmessage (id, "Znalazles przedmiot : %s :: Uzyj by gracz zadajacy Ci obrazenia tez je otrzymywal. ",player_item_name[id])
		}
		case 199:
		{
			player_item_name[id] = "Totem Enta"
			player_item_id[id] = rannum
			player_totem_enta[id] = random_num(5,7)
			player_totem_enta_zasieg[id] = random_num(100,300)
			if(player_class[id] == lelf) player_totem_enta[id] = random_num(10,15)
			show_hudmessage (id, "Znalazles przedmiot : %s :: Poloz totem ktory zatrzyma przeciwnikow w promieniu %i na %i sekund. ",player_item_name[id],player_totem_enta_zasieg[id],player_totem_enta[id])
		}
		case 200:
		{
			
			player_item_name[id] = "Firerope"
			player_item_id[id] = rannum
			player_b_grenade[id] = random_num(3,6)
			fm_give_item(id, "weapon_hegrenade")
			if(player_class[id] == lelf ){
				player_b_grenade[id] = random_num(2,4)
			}
			show_hudmessage(id, "Znalazles przedmiot: %s :: +1/%i szans natychmiastowego zabicia granatem HE",player_item_name[id],player_b_grenade[id])	
		}
		case 201:
		{
			player_item_name[id] = "Szata nieustepliwosci"
			player_item_id[id] = rannum
			player_b_nieust2[id] = random_num(50,150)
			show_hudmessage (id, "Znalazles przedmiot : %s :: Jestes odporny na negatywne efekty gdy masz mniej niz %i hp.",player_item_name[id], player_b_nieust2[id])
		}
		case 202:
		{
			player_item_name[id] = "Fart akrobaty"
			player_item_id[id] = rannum
			player_akrobata[id] = random_num(5,15)
			show_hudmessage(id, "Znalazles przedmiot : %s ::  Zadajesz wieksze obrazenia jesli jestes w powietrzu.",player_item_name[id])	
		}
		case 203:
		{
			player_item_name[id] = "Fire Amulet"
			player_item_id[id] = rannum
			player_b_grenade[id] = random_num(2,4)
			fm_give_item(id, "weapon_hegrenade")
			if(player_class[id] == lelf ){
				player_b_grenade[id] = random_num(1,3)
			}
			show_hudmessage(id, "Znalazles przedmiot: %s :: +1/%i szans natychmiastowego zabicia granatem HE",player_item_name[id],player_b_grenade[id])	
		}
		case 204:
		{
			player_item_name[id] = "Stalkers ring"
			player_itemw8[id]=StalkersRing	
			item_durability[id] = 40
			player_item_id[id] = rannum
				
			show_hudmessage(id, "Znalazles przedmiot: %s :: Masz 5 zycia, jestes prawie niewidoczny",player_item_name[id])	
		}
	}
	

	player_ns[id] = 0  
	player_ni[id] = 0
	player_na[id] = 0
	player_nd[id] = 0
	if(player_item_id[id] == 0) award_unique_item(id)	
	BoostRing(id)
	dexteryDamRedCalc(id)
	if(player_class[id] == lelf){
		upgrade_item(id)
		upgrade_item(id)
		upgrade_item(id)
		upgrade_item(id)
		upgrade_item(id)
		item_durability[id] = 200 + player_intelligence[id] * item_durability[id]/15 ;
		if(forceEvent == 2)
		{
			upgrade_item(id)
			upgrade_item(id)
			upgrade_item(id)
			upgrade_item(id)
			upgrade_item(id)
		}
	}
	item_durability[id] += player_agility[id]  * 7
	
	
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
	
	Unique_names_Prefix[1] = "udreki"
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
	
	if (roll_1 == 1) player_b_damage[id] = random_num(2,8)
	if (roll_1 == 2) player_b_vampire[id] = random_num(2,5)
	if (roll_1 == 3) player_b_money[id] = random_num(2000,4000) + player_intelligence[id] *50
	if (roll_1 == 4){ 
		player_b_reduceH[id] = random_num(10,60)
		roll_3 = random_num(1,7)
		player_b_damage[id] = random_num(1,3)
	}
	if (roll_1 == 5) player_b_blind[id] = random_num(3,5)
	if (roll_1 == 6) player_tarczam[id] = random_num(30,50)
	if (roll_1 == 7) player_mrocznibonus[id] = random_num(10,20)
	if (roll_1 == 8) player_b_inv[id] = random_num(90,150)

	if (roll_2 == 1 || roll_3 == 1) player_b_udreka[id] = random_num(3,5)
	if (roll_2 == 2 || roll_3 == 2) player_b_respawn[id] = random_num(3,6)
	if (roll_2 == 3 || roll_3 == 3) player_b_explode[id] = random_num(150,400)
	if (roll_2 == 4 || roll_3 == 4) player_b_redirect[id] = random_num(4,8)
	if (roll_2 == 5 || roll_3 == 5) player_b_heal[id] = random_num(5,15)
	if (roll_2 == 6 || roll_3 == 6) player_ludziebonus[id] = random_num(10,20)
	if (roll_2 == 7 || roll_3 == 7) player_b_jumpx[id] =  random_num(2,10)
	if (roll_2 == 8 || roll_3 == 8) player_b_nieust[id] =  random_num(20,50)
	
	if(player_class[id]==lelf){
	
		if (roll_1 == 1) player_b_damage[id] = random_num(5,15)
		if (roll_1 == 2) player_b_vampire[id] = random_num(5,12)
		if (roll_1 == 3) player_b_money[id] = random_num(2500,8000) + player_intelligence[id] *50
		if (roll_1 == 4) player_b_reduceH[id] = random_num(20,50)
		if (roll_1 == 5) player_b_blind[id] = random_num(1,4)
		if (roll_1 == 6) player_tarczam[id] = random_num(100,250)
		if (roll_1 == 7) player_mrocznibonus[id] = random_num(10,30)
		if (roll_1 == 8) player_b_inv[id] = random_num(60,100)
	
		
		if (roll_2 == 1) player_b_udreka[id] = random_num(5,10)
		if (roll_2 == 2) player_b_respawn[id] = random_num(2,4)
		if (roll_2 == 3) player_b_explode[id] = random_num(250,500)
		if (roll_2 == 4) player_b_redirect[id] = random_num(5,10)
		if (roll_2 == 5) player_b_heal[id] = random_num(5,20)
		if (roll_2 == 6) player_ludziebonus[id] = random_num(10,20)
		if (roll_2 == 7) player_b_jumpx[id] = random_num(2,20)
		if (roll_2 == 8) player_b_nieust[id] =  random_num(30,70)
	}
	DamRedCalc(id, player_tarczam[id])
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
	if (player_b_grenade[attacker_id] > 0 && weapon == CSW_HEGRENADE && player_b_fireshield[id] == 0)	//Fireshield check
	{
		new roll = random_num(1,player_b_grenade[attacker_id])
		if (roll == 1)
		{
			UTIL_Kill(attacker_id,id,"grenade")
			//change_health(id,-get_user_health(id),attacker_id,"grenade")
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
}

/* ==================================================================================================== */

public add_redhealth_bonus(id)
{
	if (player_b_reduceH[id] > 0)
		if(get_user_health(id) <= player_b_reduceH[id]) fm_set_user_health(id,1)
		else change_health(id,-player_b_reduceH[id],0,"")
	if(player_5hp[id] ==1)	//stalker ring
		set_user_health(id,5)
	if(player_100hp[id] ==1)	//stalker ring
		set_user_health(id,100)
}

/* ==================================================================================================== */

public add_theif_bonus(id,attacker_id)
{
	if (player_b_theif[attacker_id] > 0)
	{
		new roll1 = 1
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
	new roll2 = 0

  	if(player_class[id] == Nekromanta)
	{
		roll2 = random_num(1,7)
	}
	else if(player_class[id] == Witch && player_naladowany[id]== Nekromanta)
	{
		roll2 = random_num(1,5 - player_naladowany2[id]/4)
	}

	if (player_b_respawn[id] > 0 || roll2 == 1 || forceEvent==3)
	{
		new svIndex[32] 
		num_to_str(id,svIndex,32)
		new roll = random_num(1,player_b_respawn[id])
		

		if (roll == 1 || roll2 == 1)
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



/* ==================================================================================================== */

public add_bonus_explode(id)
{
	if (player_b_explode[id] > 0)
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
			
			if(get_distance(origin,origin1) < player_b_explode[id] + player_intelligence[id]*2)
			{
				new dam = 75-(player_dextery[a]*2)
				if(dam<10) dam=10
				dam += 10 * get_maxhp(a) / 100

				change_health(a,-dam,id,"grenade")
				Display_Fade(id,2600,2600,0,255,0,0,15)				
			}
		}
	}
	if (player_class[id] == Witch && player_naladowany[id] == aniol)
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
			
			if(get_distance(origin,origin1) < 100 + player_intelligence[id] + player_naladowany2[id]*5)
			{
				new dam = 75-(player_dextery[a]*2)
				if(dam<10) dam=10
				if(player_class[a] != Orc) dam += 10 * get_maxhp(a) / 100
				if(player_class[a] == Orc) dam += 10 * get_maxhp(a) / 1000
				change_health(a,-dam,id,"grenade")
				Display_Fade(id,2600,2600,0,255,0,0,15)				
			}
		}
	}
	if (player_class[id] == aniol)
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
			
			if(get_distance(origin,origin1) < 100 + player_intelligence[id]*2)
			{
				new dam = 75-(player_dextery[a]*2)
				if(dam<10) dam=10
				if(player_class[a] != Orc) dam += 10 * get_maxhp(a) / 100
				if(player_class[a] == Orc) dam += 10 * get_maxhp(a) / 1000
				change_health(a,-dam,id,"grenade")
				Display_Fade(id,2600,2600,0,255,0,0,15)				
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
		DamRedCalc(id, 0)
		reset_item_skills(id)
		item_durability[id]=durba
		set_hudmessage(220, 115, 70, -1.0, 0.40, 0, 3.0, 2.0, 0.2, 0.3, 5)
		new roll = random_num(1,player_b_gamble[id])
		if (roll == 1)
		{
			show_hudmessage(id, "Premia rundy: +15 obrazen")
			player_b_damage[id] = 50
		}
		if (roll == 2)
		{
			show_hudmessage(id, "Premia rundy: +250 tarczy magicznej")
			player_tarczam[id] = 250
			DamRedCalc(id, player_tarczam[id])
		}
		if (roll == 3)
		{
			show_hudmessage(id, "Premia rundy: +7 obrazen wampira")
			player_b_vampire[id] = 7
		}
		if (roll == 4)
		{
			show_hudmessage(id, "Premia rundy: +25 hp co kazde 5 sekund")
			player_b_heal[id] = 25
		}
		if (roll == 5)
		{
			show_hudmessage(id, "Premia rundy: 1/3 szans do natychmiastowego zabicia HE")
			player_b_grenade[id] = 3
			fm_give_item(id, "weapon_hegrenade")
		}
		if (roll == 6)
		{
			show_hudmessage(id, "Otrzymywane obrazenie sa zredukowane o 10")
			player_b_redirect[id] = 10
		}
		if (roll == 7)
		{
			show_hudmessage(id, "Premia rundy: 1/3 szans do natychmiastowego zabicia z m3")
			player_b_m3[id] = 3
			fm_give_item(id, "weapon_m3")
			give_item(id, "ammo_buckshot")
			give_item(id, "ammo_buckshot")
			give_item(id, "ammo_buckshot")
		}
		if (roll == 8)
		{
			player_b_explode[id] = 200
			show_hudmessage(id, "Wybuchniesz zaraz po smierci w promieniu 200")
		}
		if (roll == 9)
		{
			show_hudmessage(id, "Bonus do szybkosci  50")
			player_speedbonus[id] = 50
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
	if(player_class[attacker_id] == MagP && weapon != 4) {
		if (wear_sun[id] != 1){
			if (random_num(0,20) == 0) Display_Fade(id,1<<14,1<<14 ,1<<16,255,155,50,230)	
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
		if(player_class[id]==Mag){
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
			new speedBonus = player_dextery[id] * 5 + player_agility[id] * 5
			new Float:fl_iNewVelocity[3]
			VelocityByAim(id, 750 + speedBonus, fl_iNewVelocity)
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
		}else{
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
	}	
	return PLUGIN_HANDLED
}

/* ==================================================================================================== */

public add_bonus_redirect(id, damage)
{
	if (player_b_redirect[id] > 0)
	{
		if (get_user_health(id)+player_b_redirect[id] < get_maxhp(id))
		{
			new red = player_b_redirect[id];
			if(red > damage) red = damage;
			change_health(id,red,0,"")			
		}
	}
	if(player_class[id]==Witch && player_naladowany[id]== Mnich)
	{
		new r=player_naladowany2[id]
		if (get_user_health(id)+r < get_maxhp(id))
		{
			new red = r;
			if(red > damage) red = damage;
			change_health(id,red,0,"")			
		}	
	}
}

/* ==================================================================================================== */

public item_ghost(id)
{
	if (ghoststate[id] == 0 && player_b_ghost[id] > 0 && is_user_alive(id) && !ghost_check)
	{
		set_user_noclip(id,1)
		ghoststate[id] = 2
		ghosttime[id] = floatround(halflife_time())
		ghost_check = true
		
		message_begin( MSG_ONE, gmsgBartimer, {0,0,0}, id ) 
		write_byte( player_b_ghost[id]+1 ) 
		write_byte( 0 ) 
		message_end() 
	}
	else
	{
		hudmsg(id,3.0,"Tylko jeden gracz moze uzywac Ducha w tym samym czasie! / Przedmiot zostal uzyty!")
	}
}

/* ==================================================================================================== */

public add_bonus_darksteel(attacker_id,id,damage)
{
	if (player_class[attacker_id] == Witch  && player_naladowany[attacker_id] == Dzikuska)
	{
		if (UTIL_In_FOV(attacker_id,id) && !UTIL_In_FOV(id,attacker_id))
		{
			new dam = 1+player_naladowany2[attacker_id]*3
			if(dam>30) dam = 30;
			Effect_Bleed(id,248)
			change_health(id,-dam,attacker_id,"world")
			Display_Fade(id,seconds(1),seconds(1),0,255,0,0,150)
		}
	}
	if (player_class[attacker_id] == Dzikuska )
	{
		if (UTIL_In_FOV(attacker_id,id) && !UTIL_In_FOV(id,attacker_id))
		{
			refill_ammo(attacker_id, 1)
			new clip,ammo
			new weapon=get_user_weapon(attacker_id,clip,ammo)
			if(weapon != CSW_KNIFE && weapon != CSW_C4 && weapon != CSW_HEGRENADE && weapon != CSW_FLASHBANG && weapon != CSW_SMOKEGRENADE && weapon != 0) 
			{
				cs_set_user_bpammo(id, weapon, 90)
			}

			
			new dam = 5+player_intelligence[attacker_id]/4
			if(dam>30) dam = 30;
			Effect_Bleed(id,248)
			change_health(id,-dam,attacker_id,"world")
			Display_Fade(id,seconds(1),seconds(1),0,255,0,0,150)
		}
	}
	if (player_b_darksteel[attacker_id] > 0)
	{
		if (UTIL_In_FOV(attacker_id,id) && !UTIL_In_FOV(id,attacker_id))
		{
			new dam = floatround (15+player_intelligence[attacker_id]*2*player_b_darksteel[attacker_id]/10.0)
			Effect_Bleed(id,248)
			change_health(id,-dam,attacker_id,"world")
			Display_Fade(id,seconds(1),seconds(1),0,255,0,0,150)
		}
	}
	if(player_lvl[attacker_id]>prorasa && player_class[attacker_id] == Ninja){
		if (UTIL_In_FOV(attacker_id,id) && !UTIL_In_FOV(id,attacker_id))
		{
			Effect_Bleed(id,248)
			new Float:mnoz = 0.5 + (player_intelligence[attacker_id] / 200.0);
			if(player_edison[attacker_id]==1) mnoz /=5.0
			if(player_edison[attacker_id]==0) mnoz /=2.0
			new dam = floatround(damage * mnoz)
			if(dam > 0) dam = -dam
			change_health(id,dam,attacker_id,"world") 
		}
	}
}


/* ==================================================================================================== */

//Called when PlayerCamera thinks
public Think_PlayerCamera(ent)
{
	new id = entity_get_edict(ent,EV_ENT_owner)
	
	//Check if player is still having the item and is still online
	if (!is_valid_ent(id) || true || !is_user_connected(id))
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
	if((get_user_button(id) & IN_ATTACK2) && !(get_user_oldbutton(id) & IN_ATTACK2) && is_user_alive(id) && !(get_user_button(id) & IN_DUCK)) 
	{			
		if (on_knife[id])
		{
			if(ofiara_totem_enta[id] > floatround(halflife_time())){
				set_hudmessage(255, 0, 0, -1.0, 0.01)
				show_hudmessage(id, "Jestes uziemiony")
				return PLUGIN_HANDLED
			}
			if(czas_rundy + 10 > floatround(halflife_time())){
				set_hudmessage(255, 0, 0, -1.0, 0.01)
				show_hudmessage(id, "Teleportu mozesz uzywac 10 sek po starcie rundy")
				return PLUGIN_HANDLED
			}
			get_mapname(szMapName, 31)
			if (halflife_time()-player_b_blink[id] <= 3 || equal(szMapName, "awp_india") || equal(szMapName, "aim_aztec") || equal(szMapName, "awp_hunter") || equal(szMapName, "aim_knights")) return PLUGIN_HANDLED		
			player_b_blink[id] = floatround(halflife_time())	
			UTIL_Teleport(id,300+15*player_intelligence[id])
			if(player_talos[id]>0)TimedInv(id,1)
		}
	}
	return PLUGIN_CONTINUE
}

public Prethink_Blink_sec(id)
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
			if(czas_rundy + 10 > floatround(halflife_time())){
				set_hudmessage(255, 0, 0, -1.0, 0.01)
				show_hudmessage(id, "Teleportu mozesz uzywac 10 sek po starcie rundy")
				return PLUGIN_HANDLED
			}
			get_mapname(szMapName, 31)
			if (halflife_time()-player_b_blink_sec[id] <= 1 || equal(szMapName, "awp_india") || equal(szMapName, "aim_aztec") || equal(szMapName, "awp_hunter") || equal(szMapName, "aim_knights")) return PLUGIN_HANDLED		
			player_b_blink_sec[id] = floatround(halflife_time())	
			UTIL_Teleport(id,300+15*player_intelligence[id])
			if(player_talos[id]>0)TimedInv(id,1)
		}
	}
	return PLUGIN_CONTINUE
}

public Prethink_Blink_arc(id)
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
			if(czas_rundy + 10 > floatround(halflife_time())){
				set_hudmessage(255, 0, 0, -1.0, 0.01)
				show_hudmessage(id, "Teleportu mozesz uzywac 10 sek po starcie rundy")
				return PLUGIN_HANDLED
			}
			get_mapname(szMapName, 31)
			if (halflife_time()-player_b_blink_arc[id] <= 10 || equal(szMapName, "awp_india") || equal(szMapName, "aim_aztec") || equal(szMapName, "awp_hunter") || equal(szMapName, "aim_knights")) return PLUGIN_HANDLED		
			player_b_blink_arc[id] = floatround(halflife_time())	
			UTIL_Teleport(id,300+10*player_intelligence[id])
		}
	}
	return PLUGIN_CONTINUE
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
	
	if (cs_get_user_money(id) < 100)
		hudmsg(id,2.0,"Nie masz wystarczajacej ilosci zlota, zeby zamienic je w zycie")
	else if (get_user_health(id) == maxhealth)
		hudmsg(id,2.0,"Masz maksymalna ilosc zycia")
	else
	{
		cs_set_user_money(id,cs_get_user_money(id)-100)
		change_health(id,20,0,"")			
		Display_Fade(id,2600,2600,0,0,255,0,15)
	}
}

public item_windwalk(id)
{
	//First time this round
	if (player_b_usingwind[id] == 0 && is_user_connected(id))
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
		set_speedchange(id)
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
		set_speedchange(id)
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
	
	if (player_b_usingwind[id] == 1)
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
			dropitem2(id)
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
new top15[25][64];
new top15LVL[25];
new top15_loaded = 0


public select_MYRANK_query(id)
{
	if(is_user_bot(id) || asked_klass[id]!=0) return PLUGIN_HANDLED

	if(get_timeleft() < 60) return PLUGIN_HANDLED
	if(player_class[id] == 0){
		client_print(id,print_chat, "Najpierw wybierz klase ")
		return PLUGIN_CONTINUE
	}
	if(myRank [id]> -1){
		client_print(id,print_chat, "Twoj ranking %s wynosi %i na 2 000 000 ", Race[player_class[id]],  myRank [id])
		return PLUGIN_CONTINUE
	}
	
	if(g_boolsqlOK)
	{
		new name[64]
		new data[1]
		data[0] = id
		get_user_ip(id, name ,63,1)
		new q_command[512]
		format(q_command,511,"SELECT count(`nick`) as count FROM `dbmod_tablet` WHERE `lvl`> '%d' AND `klasa` = '%d'", player_lvl[id], player_class[id])
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
        if(is_user_bot(id) || asked_klass[id]!=0) return PLUGIN_HANDLED

        if(get_timeleft() < 60) return PLUGIN_HANDLED
	if(top15_loaded == 1){
		new itemEffect[500]
		for(new j = 0 ; j<25;j++){
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
                format(q_command,511,"SELECT `nick`, sum(`lvl`) as lvl FROM `dbmod_tablet` WHERE `lvl` >25 GROUP BY `nick` ORDER BY sum(`lvl`) DESC LIMIT 50  ")
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
			if(i>24) break;
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
	show_motd(id, g_ItemFile, "Top50")
	
	return PLUGIN_HANDLED
	
}


public select_class_query(id)
{
        if(is_user_bot(id) || asked_klass[id]!=0) return PLUGIN_HANDLED

        if(get_timeleft() < 60) return PLUGIN_HANDLED

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
                                format(q_command,511,"SELECT `klasa`,`lvl`,`vip`, `SID_PASS`, `PASS_PASS`, `mute`, `bans` FROM `%s` WHERE `nick`='%s' ",g_sqlTable,name)
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
		log_to_file("addons/amxmodx/logs/diablo.log","select_class_handle Query failed.")
		asked_klass[id]=0
		return PLUGIN_CONTINUE
	}               
	highlvl[id]= 0 
	if(SQL_MoreResults(Query))
	{
		while(SQL_MoreResults(Query))
		{
			new i = SQL_ReadResult(Query, SQL_FieldNameToNum(Query, "klasa"))
			player_class_lvl[id][i] = SQL_ReadResult(Query, SQL_FieldNameToNum(Query, "lvl"))
			if(player_class_lvl[id][i]>75){
				highlvl[id] = player_class_lvl[id][i];
			} 
			if(i==1){
				player_sid_pass[id] = ""
				player_pass_pass[id] = ""
				player_bans[id] = SQL_ReadResult(Query,SQL_FieldNameToNum(Query,"bans"))	
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
							client_cmd(id, "setinfo ^"_m^" ^"%i^"", 1)
						}else{
							player_mute[id] = 0
						}
						//log_to_file("addons/amxmodx/logs/diablomute.log"," Gracz %s Czy ma mute %i", name, player_mute[id])
					}
				}else
				{
					SQL_ReadResult(Query, SQL_FieldNameToNum(Query,"mute"), date_long[id], 63)
					
					new m;
					m = parse_time(date_long[id], "%Y/%m/%d");	
					if(equal(date_long[id], "") || m < get_systime())
					{
						new name[64]
						get_user_name(id,name,63)
						player_mute[id] = 0
						client_cmd(id, "setinfo ^"_m^" ^"%i^"", 0)
						server_cmd( "amx_unmute ^"%s^"", name);
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
	asked_klass[id]=0
	new sizeofrace_heal = sizeof(race_heal)
	for(new i=1;i<sizeofrace_heal;i++){
		new menu_txt[128]
		if(player_class_lvl[id][i] <prorasa){
			formatex(menu_txt,127,"%s: %s[%i], lvl: %d",Rasa[i],Race[i], KlasyZlicz[i] ,player_class_lvl[id][i])
			menu_additem(create_class, menu_txt, "", ADMIN_ALL, ghandle_create_class)
		} else {
			formatex(menu_txt,127,"%s: %s[%i], lvl: %d",Rasa[i],ProRace[i], KlasyZlicz[i] ,player_class_lvl[id][i])
			menu_additem(create_class, menu_txt, "", ADMIN_ALL, ghandle_create_class)
		}  
	}
	menu_display(id,create_class,0)
}

public mcb_create_class(id, menu, item) {
	new typ = 0
	get_mapname(szMapName, 31)
	if (halflife_time()-player_b_blink[id] <= 3 || equal(szMapName, "awp_india") || equal(szMapName, "aim_aztec") || equal(szMapName, "awp_hunter") || equal(szMapName, "aim_knights")){
		typ = 1
	}

	if(typ==0){
		if((get_user_flags(id) & ADMIN_LEVEL_C) || (get_user_flags(id) & ADMIN_LEVEL_D) || player_vip[id]==1 || player_vip[id]==2){
			new name[64]	
			get_user_name(id,name,63)
			replace_all ( name, 63, "'", "Q" )
			replace_all ( name, 63, "`", "Q" )			
		} 

	}
	
	if(typ == 1){
	
		if((get_user_flags(id) & ADMIN_LEVEL_C) || (get_user_flags(id) & ADMIN_LEVEL_D) || player_vip[id]==1 || player_vip[id]==2){
			new name[64]	
			get_user_name(id,name,63)
			replace_all ( name, 63, "'", "Q" )
			replace_all ( name, 63, "`", "Q" )			
		} 

		
	}
	new sid[64]
	get_user_authid(id, sid ,63)
	if (valid_steam(sid)) u_sid[id] = 1
	if(forceEvent == 1 && forceEventC2!=0 && forceEventC1!=0 && forceEventC2 != (item+1) && forceEventC1 != (item+1)) return ITEM_DISABLED
	
	if(forceEvent == 1 && forceEventC2!=0 && forceEventC1!=0 && forceEventC1 != (item+1) && cs_get_user_team(id) == CS_TEAM_T) return ITEM_DISABLED
	if(forceEvent == 1 && forceEventC2!=0 && forceEventC1!=0 && forceEventC2 != (item+1) && cs_get_user_team(id) == CS_TEAM_CT) return ITEM_DISABLED
		

	//if(u_sid[id] == 0 && KlasyZlicz[item]>0 && forceEvent != 1) return ITEM_DISABLED
	return ITEM_ENABLED
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
	if(KlasyZlicz[player_class[id]] < 1) immun[id] = 1
	else immun[id] = 0
	KlasyZlicz[player_class[id]]++
	
        
	if(player_class[id]==Nekromanta ) g_haskit[id] = 1
	if(player_glod[id] >0) g_haskit[id] = true
		
	if(player_class[id]==Hunter) g_GrenadeTrap[id] = 1 
	LoadXP(id, player_class[id])
	CurWeapon(id)
        
	give_knife(id)
	return PLUGIN_CONTINUE
}



public diablo_redirect_check_height(id){	
		if(!is_user_connected(id)) return;
		if(get_user_flags(id) & ADMIN_LEVEL_H) return;
		return;
		/*
		if(diablo_redirect==3){
			if((player_lvl[id] > 2 && player_lvl[id]>100 && get_playersnum() >=25) 
			|| (player_lvl[id] > 2 && player_lvl[id]>110 && get_playersnum() >=24)
			|| (player_lvl[id] > 2 && player_lvl[id]>120 && get_playersnum() >=23)
			|| (player_lvl[id] > 2 && player_lvl[id]>130 && get_playersnum() >=18)
			|| (player_lvl[id] > 2 && player_lvl[id]>140 && get_playersnum() >=15)
			|| (player_lvl[id] > 2 && player_lvl[id]>150) ){
				new name[64]
				get_user_name(id,name,63)
				client_print(id,print_chat, "Jesli masz level wiekszy niz 100 przejdz na serwer 1c 193.33.177.32:27261")
				
				redirectHim(id)
				
				if(random_num(0,5)==0){
					new text2[513] 
					formatex(text2, 512, "kick ^"%s^" ^"Wejdz na 193.33.177.32:27261^"",name)
					server_cmd(text2);
				}
			}
		}*/
}

public diablo_redirect_check_low(id){
		if(!is_user_connected(id)) return;
		if(get_user_flags(id) & ADMIN_LEVEL_H) return;
		return;
		/*
		if(u_sid[id] > 0) return;
		
		if(diablo_redirect==1){
			
		}
		if(diablo_redirect==2){

		}
		if(diablo_redirect==3){

		}
		if(diablo_redirect==4){
		
			if(
			   (player_lvl[id] > 2 && player_lvl[id]<100 && get_playersnum() >= 24) 
			|| (player_lvl[id] > 2 && player_lvl[id]<75 && get_playersnum() >= 23) 
			){
				new name[64]
				get_user_name(id,name,63)
				client_print(id,print_chat, "Jesli masz level mniejszy niz 100 przejdz na serwer 1a 193.33.177.17:27086")

				redirectHim(id)
				
				if(random_num(0,15)==0){
					new text2[513] 
					format(text2, 512, "kick ^"%s^" ^"Na tym serwerze mozesz grac od 100lvla!^"",name)
					server_cmd(text2);
				}
			}
			
		}*/
}

public redirectHim(id){
	/*
	if(player_lvl[id]< 25){
		//redirect to 1a
		if(random_num(0,2)==0){
			client_cmd(id,"Connect 193.33.177.17:27086");
			client_cmd(id,"connect 193.33.177.17:27086");
		}
		client_cmd(id,"echo ^"^";^"Connect^" 193.33.177.17:27086")
	
		client_cmd(id,"connect 193.33.177.17:27086");
		if(random_num(0,1)==0){
			client_cmd(id,";connect 193.33.177.17:27086");
		}
	} 
	if(player_lvl[id]< 50){
		//redirect to 1a
		if(random_num(0,2)==0){
			client_cmd(id,"Connect 193.33.177.17:27086");
			client_cmd(id,"connect 193.33.177.17:27086");
		}
		client_cmd(id,"echo ^"^";^"Connect^" 193.33.177.17:27086")
		client_cmd(id,"echo ^"Redirecting^"; connect 193.33.177.17:27086")
	
		client_cmd(id,"connect 193.33.177.17:27086");
		if(random_num(0,1)==0){
			client_cmd(id,";connect 193.33.177.17:27086");
		}
	*/
	if(player_lvl[id] < 10) return;
	
/*
	if(player_lvl[id]< 100){
		//redirect to 1b
		if(random_num(0,2)==0){
			client_cmd(id,"Connect 193.33.177.17:27086");
			client_cmd(id,"connect 193.33.177.17:27086");
		}
		client_cmd(id,"echo ^"^";^"Connect^" 193.33.177.17:27086")
		client_cmd(id,"echo ^"Redirecting^"; connect 193.33.177.17:27086")
		client_cmd(id,"connect 193.33.177.17:27086");
		if(random_num(0,1)==0){
			client_cmd(id,";connect 193.33.177.17:27086");
		}
	}else if(player_lvl[id]>= 100){
		//redirect to 1c
		if(random_num(0,2)==0){
			client_cmd(id,"Connect 193.33.177.32:27261");
			client_cmd(id,"connect 193.33.177.32:27261");
		}
		client_cmd(id,"echo ^"^";^"Connect^" 193.33.177.32:27261")
		client_cmd(id,"echo ^"Redirecting^"; connect 193.33.177.32:27261")
		client_cmd(id,"connect 193.33.177.32:27261");
		if(random_num(0,1)==0){
			client_cmd(id,";connect 193.33.177.32:27261");
		}
	}*/
	/*else if(player_lvl[id]> 125){
		//redirect to 1e
		if(random_num(0,2)==0){
			client_cmd(id,"Connect 193.33.177.19:27151");
			client_cmd(id,"connect 193.33.177.19:27151");
		}
		client_cmd(id,"echo ^"^";^"Connect^" 193.33.177.19:27151")
		client_cmd(id,"connect 193.33.177.19:27151");
		if(random_num(0,1)==0){
			client_cmd(id,";connect 193.33.177.19:27151");
		}
	}*/
}


/* ==================================================================================================== */
public check_class()
{
	clEvent = 0;
	clEvent1 = 0;
	clEvent2 = 0;
	get_mapname(szMapName, 31)
	for (new kl=0; kl < 29; kl++){
		KlasyZlicz[kl] =0
	}
	diablo_redirect  = get_cvar_num("diablo_redirect") 
	for (new id=0; id < 33; id++)
	{
		if(!is_user_connected(id)) continue
		ducking_t[id]=0
		player_lastDmgTime[id]=halflife_time();
		was_ducking[id]=0
		set_task(1.0 * random_num(0, 25), "diablo_redirect_check_low", id)
		//diablo_redirect_check_low(id)
		
		remove_task(id+TASK_FLASH_LIGHT)
		if(is_valid_ent(id))
		{
			pev(id,pev_origin,blink_origin[id])
		}
		
		player_b_skill[id] = 5
		if(player_item_id[id]==176 ) player_b_skill[id] = 1
		
		if(highlvl[id] > 0 || player_lvl[id] > 200 ){
			if(!player_sid_pass[id][0] && !player_pass_pass[id][0])
				client_cmd(id, "/force_srn")
		}
		new sid[64]
		get_user_authid(id, sid ,63)
		if (valid_steam(sid)) u_sid[id] = 1
		
		if(player_lvl[id] > 240 && u_sid[id] == 0)
		{
			user_kill(id)
			set_hudmessage(220, 30, 30, -1.0, 0.40, 0, 3.0, 2.0, 0.2, 0.3, 5)
			show_hudmessage(id, "STEAM JEST OBOWIAZKOWY OD 240 LVL") 
			client_print(id,print_chat, "STEAM JEST OBOWIAZKOWY OD 240 LVL")
		}
		if(u_sid[id] == 0 && get_playersnum()>29 && !(get_user_flags(id) & ADMIN_RESERVATION))
		{
				new name[64]
				get_user_name(id,name,63)

				new text2[513] 
				format(text2, 512, "kick ^"%s^" ^"Brak slota, gracz steam ma pierwszenstwo^"",name)
				server_cmd(text2);
		}
		if(player_bans[id] >5 && get_playersnum()>30 && !(get_user_flags(id) & ADMIN_RESERVATION))
		{
				new name[64]
				get_user_name(id,name,63)

				new text2[513] 
				format(text2, 512, "kick ^"%s^" ^"Brak slota, gracz bez banow ma pierwszenstwo^"",name)
				server_cmd(text2);
		}
		
		
		if(player_item_id[id]!=66 && (is_user_connected(id)) && player_diablo[id]==0 && player_she[id]==0 && player_skin[id]==0) changeskin(id,1)
		player_diablo[id] = 0
		player_she[id] = 0
		if(player_class[id] != Witch){
			player_naladowany[id] = 0
			player_naladowany2[id] = 0
		}
		KlasyZlicz[player_class[id]]++;
	
	}
	count_avg_lvl()
	for (new i=1; i < 29; i++){
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
	zliczoneKlasy=0
	for (new i=1; i < 29; i++)
	{
		if(KlasyZlicz[i]>0)
			zliczoneKlasy++
	}
	for (new id=0; id < 33; id++)
	{
		after_spawn(id)
		if(!is_user_connected(id)) continue
		if(player_class[id] == 0) continue
		
		if(get_playersnum()>10){

			if(immun[id] == 0 && KlasyZlicz[player_class[id]] == 1) immun[id] = 1
			if(clEvent == 2 || forceEvent == 1)
			{
				if(tutOn && tutor[id]<2) tutorMake(id,TUTOR_GREEN,4.5,"+70%% exp za %s vs %s", Race[clEvent1], Race[clEvent2] )
			}else{
				new itemEffect[500] = ""
				new disp = 0
				player_nal[id]=0;
				/*
				if(popularnosc[id] == 3){
					add(itemEffect,499,"+5%% exp ")
				}else if(popularnosc[id] == 2){
					add(itemEffect,499,"+10%% exp ")
				}else if(popularnosc[id] == 1){
					add(itemEffect,499,"+20%% exp ")
				}
				*/
				if(KlasyZlicz[player_class[id]]==1 || immun[id] >0){
					if(forceEvent != 2) award_item(id, 0)
					add(itemEffect,499,"+item +30%% exp +inne ")
					disp = 1
				}else if(KlasyZlicz[player_class[id]]>1 && KlasyZlicz[player_class[id]]<5  && immun[id] == 0){
					add(itemEffect,499,"-10%%hp -50%% exp +inne")
					disp = 1
				}else if(KlasyZlicz[player_class[id]]>=5 && immun[id] == 0){	
					add(itemEffect,499,"-25%%hp -70%% exp +inne")
					disp = 1
				}
				if(disp == 1) add(itemEffect,499,"za klase ")
				
				if(u_sid[id] == 0 && player_lvl[id]> 100){
					add(itemEffect,499," -75%% exp za NS ")
					disp = 1
				}

				if(tutOn && tutor[id]<2 && disp == 1) tutorMake(id,TUTOR_GREEN,5.0,itemEffect)
			}
		}
		if(player_class[id] == Archeolog)
		{
			if(random_num(0, 5+dropped[id]/5)==0) upgrade_item(id)
		}
		else
		{
			if(random_num(0, 5+dropped[id])==0) upgrade_item(id)
		}
		
	}
}
	

/* ==================================================================================================== */

public add_barbarian_bonus(id)
{
	if (player_class[id] == Barbarzynca || player_pelnia[id]>0 )
	{	
		change_health(id,20,0,"")
		if(player_lvl[id]>prorasa ){
			ultra_armor[id]++
			write_hud(id)
		}
	}
}

/* ==================================================================================================== */

public add_bonus_necromancer(attacker_id,id)
{
	if(player_glod_tmp[attacker_id]>0) vampire(id,player_glod_tmp[attacker_id]*4,attacker_id)
	if (player_class[attacker_id] == Wilk || player_class[attacker_id] == Nekromanta || player_class[attacker_id] == Wampir ||player_class[attacker_id] == Witch||player_class[attacker_id] == Harpia||player_class[attacker_id] == Orc||player_class[attacker_id] == Archeolog)
	{
		if (get_user_health(id) - 10 <= 0)
		{
			set_user_health(id,random_num(1,3))
		}
		else
		{
			new dmg
			if(player_class[attacker_id] == Nekromanta){
				dmg = 4 + player_intelligence[attacker_id]/15
				if(dmg>15) dmg = 15
				vampire(id,dmg,attacker_id)
			} 
			else if(player_class[attacker_id]== Witch){
				dmg = 5 
				vampire(id,dmg,attacker_id)
			}
			else if(player_class[attacker_id]== Wilk && player_naladowany[attacker_id]==1){
				dmg = 3 
				vampire(id,dmg,attacker_id)
			}
			else if(player_class[attacker_id] == Wampir) {
				if (UTIL_In_FOV(attacker_id,id) && !UTIL_In_FOV(id,attacker_id))
				{
					dmg = 10 + player_intelligence[attacker_id] / 2
					if(dmg < 10 ) dmg = 10
					if(dmg > 50 ) dmg = 50
					vampire(id,dmg,attacker_id)
				}
			}
			else if(player_class[attacker_id] == Harpia && on_knife[attacker_id]) {
				new atk = 40 + player_intelligence[attacker_id]/2
				if(atk > 90 ) atk = 90
				vampire(id,atk,attacker_id)
			}
			else if(player_class[attacker_id] == Archeolog){
				new kasa = 20*player_intelligence[attacker_id]
				if(kasa>1500) kasa = 1500 
				if(cs_get_user_money(id)-kasa > 0){
					cs_set_user_money(id,cs_get_user_money(id)-kasa)
					cs_set_user_money(attacker_id,cs_get_user_money(attacker_id)+kasa)
				} else{
					kasa = cs_get_user_money(id)
					cs_set_user_money(attacker_id,cs_get_user_money(attacker_id)+kasa)
					cs_set_user_money(id,0)
				}
				
			}
		}
	}
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

public dag_magw(id)
{	
	
	new czas = 25 - player_intelligence[id]/25
	if(czas<5)czas=5
	czas = czas - (czas *  player_naszyjnikczasu[id]/ 100)
	if (halflife_time()-bowdelay[id] <= czas && player_diablo[id]==0 && player_she[id]==0)
	{
		
		show_hudmessage(id, "Ten skill moze byc uzyty co kazde %i sekundy", czas)
		return PLUGIN_CONTINUE
	}
	player_naladowany[id] = 1
	bowdelay[id]  = halflife_time()
	

	
	new target = UTIL_FindNearestOpponent(id,1000+player_intelligence[id]*2)
	
	if (target == -1) {
		target = UTIL_FindNearestOpponent(id,800)
		if (target == -1) {
			target = UTIL_FindNearestOpponent(id,600)
			if (target == -1) {
				hudmsg(id,2.0,"Moc zmarnowana!")
				return PLUGIN_HANDLED
			}
		}
	}

	
	new DagonDamage = 60 + 2*player_intelligence[id] + player_strength[target] * 80 / 100

	
	
	//Dagon damage done is reduced by the targets dextery
	DagonDamage-=player_dextery[target]*2 
	
	if (DagonDamage < 0)
		DagonDamage = 0
	
	new Hit[3]
	get_user_origin(target,Hit)

	strumien(id, Hit[0], Hit[1], Hit[2], 0, 0, 255)
	strumien(id, Hit[0], Hit[1], Hit[2], 0, 0, 255)
	strumien(id, Hit[0], Hit[1], Hit[2], 0, 0, 255)
	strumien(id, Hit[0], Hit[1], Hit[2], 0, 0, 255)
	strumien(id, Hit[0], Hit[1], Hit[2], 0, 0, 255)
	strumien(id, Hit[0], Hit[1], Hit[2], 0, 0, 255)
	strumien(id, Hit[0], Hit[1], Hit[2], 0, 0, 255)
	strumien(id, Hit[0], Hit[1], Hit[2], 0, 0, 255)
	strumien(id, Hit[0], Hit[1], Hit[2], 0, 0, 255)
	strumien(id, Hit[0], Hit[1], Hit[2], 0, 0, 255)
	strumien(id, Hit[0], Hit[1], Hit[2], 0, 0, 255)
	strumien(id, Hit[0], Hit[1], Hit[2], 0, 0, 255)
	
	player_b_dagfired[id] = true
	
	//Apply damage

	change_health(target,-DagonDamage,id,"world")

	Display_Fade(target,2600,2600,0,255,0,255,15)
	hudmsg(id,2.0,"Twoje ciosy dagon przyjol %i, %i", DagonDamage, player_dextery[target]*2)
	
	return PLUGIN_HANDLED
	
	
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
	DagonDamage-=(player_dextery[target]*2)
	
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
	
	formatex(text, 512, "\ySklep z runami - ^n\w1. Upgrade [Moze ulepszyc item] - \r$9000^n\w Uwaga nie kazdy item sie da ulepszyc ^n\w Slabe itemy latwo ulepszyc ^n\w Mocne itemy moga ulec uszkodzeniu ^n\w5. Losowy przedmiot \r$5000^n\w6. Doswiadczenie \r$14500^n^n\w0. Zamknij") 
	
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
			if (player_item_id[id] == 0)
				return PLUGIN_HANDLED
			if (!UTIL_Buyformoney(id,9000))
				return PLUGIN_HANDLED

			//log_to_file("addons/amxmodx/logs/diabloRune.log","Ulepszyl item: %s",name)
			upgrade_item(id)
		}
				
		case 4: 
		{	
			if (player_item_id[id] != 0)
				return PLUGIN_HANDLED
			if (!UTIL_Buyformoney(id,5000))
				return PLUGIN_HANDLED
				
			//log_to_file("addons/amxmodx/logs/diabloRune.log","Kupil item: %s",name)
			if(forceEvent != 2) award_item_f(id,0,15)
			return PLUGIN_HANDLED
		}
		case 5:
		{
			if ((zal[id]>0) || (get_playersnum(0) < 5) || forceEvent==3)
				return PLUGIN_HANDLED
			if (!UTIL_Buyformoney(id,14500))
				return PLUGIN_HANDLED
				

			//log_to_file("addons/amxmodx/logs/diabloRune.log","Kupil zal: %s",name)

			new av = 0
			count_avg_lvl()
			if(cs_get_user_team(id) == CS_TEAM_T) av = avg_lvlCT
			if(cs_get_user_team(id) == CS_TEAM_CT) av = avg_lvlTT
			new exp = (get_cvar_num("diablo_xpbonus") + get_cvar_num("diablo_xpbonus") * moreLvl2(player_lvl[id], av) /150)/2

			zal[id]++;
			if(exp>2000) exp =2000;
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
	if(player_NoUpgrade[id]>0) return;
	if(item_durability[id]>0) item_durability[id] += random_num(-25,50)
	if(item_durability[id]<1)
	{
		dropitem(id)
		return
	}

	if(player_b_szarza[id] >0) player_b_szarza[id] +=random_num(1,5)
	if(player_b_udreka[id] >0) player_b_udreka[id] +=random_num(1,2)	
	if(player_krysztalmagii[id] >0) player_krysztalmagii[id] +=random_num(1,5)
	if(player_head_froze[id] >0) player_head_froze[id] +=random_num(1,3)
	if(player_head_dmg[id] >0) {
		if(player_class[id]==Paladyn) player_b_reduceH[id]+=player_head_dmg[id]*5
		player_head_dmg[id] +=random_num(0,1)
	}
	
	if(player_supshield[id] >0 && player_supshield[id] < 80) player_supshield[id]+=random_num(1,10)
	
	if(player_smocze[id]>0 && player_smocze[id]<50  ){
		player_smocze[id] += random_num(0,5)
	}
	if(player_b_jumpx[id]>0) player_b_jumpx[id] += random_num(0,1)
	if(player_b_nieust[id] > 0 && player_b_nieust[id] < 90) player_b_nieust[id] +=  random_num(0,5)
	if(player_b_nieust2[id] > 0 && player_b_nieust2[id] < 500) player_b_nieust2[id] +=  random_num(0,5)
	
	if(player_b_vampire[id]>1)
	{
		if(player_b_vampire[id]>20) player_b_vampire[id] += random_num(-1,2)
		else if(player_b_vampire[id]>10) player_b_vampire[id] += random_num(0,1)
		else player_b_vampire[id]+= 1
	}
	if(player_inkizytor[id]>0 && player_inkizytor[id] < 10) player_inkizytor[id] += random_num(0,1)
	if(player_b_damage[id]>0 && player_b_damage[id] < 50){
		player_b_damage[id] += random_num(1,1) 
	}
	if(player_b_money[id]!=0 && player_b_money[id]<15000 ){
		player_b_money[id]+= random_num(-100,300)	
	}
	if(player_b_gravity[id]>0)
	{
		if(player_b_gravity[id]<3) player_b_gravity[id]+=random_num(0,2)
		else if(player_b_gravity[id]<5) player_b_gravity[id]+=random_num(1,3)
		else if(player_b_gravity[id]<8) player_b_gravity[id]+=random_num(-1,3)
		else if(player_b_gravity[id]<10) player_b_gravity[id]+=random_num(0,1)
	}
	if(player_b_inv[id]>0 && player_b_inv[id] < 300)
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
	if(player_b_reduceH[id]>0){
		player_b_reduceH[id]-=random_num(0,player_b_reduceH[id]/10)
	}
	if(player_b_theif[id]>0){
		player_b_theif[id] += random_num(1,250)
	}
	if(player_money_damage[id]>0 && player_money_damage[id]< 20 ){
		player_money_damage[id] += random_num(1,2)
	}
	if(player_money_speedbonus[id]>0 && player_money_speedbonus[id] < 100){
		player_money_speedbonus[id] += random_num(1,3)
	}
	if(player_nomoney_slow[id]>0 && player_nomoney_slow[id] < 20){
		player_nomoney_slow[id] += random_num(1,3)
	}

	if(player_b_respawn[id]>0)
	{
		if(player_b_respawn[id]>3) player_b_respawn[id]-=random_num(0,1)
		else if(player_b_respawn[id]>2) player_b_respawn[id]-=random_num(-1,1)
	}
	if(player_b_explode[id]>0 && player_b_explode[id] < 1000){
		player_b_explode[id] += random_num(0,50)
	}
	if(player_b_heal[id]>0 && player_b_heal[id]<100)
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
		if(player_b_blind[id]>10) player_pociski_powietrza[id]-= random_num(0,5)
		else if(player_b_blind[id]>1) player_pociski_powietrza[id]-= random_num(0,1)
	}
	if( player_totem_powietrza_zasieg[id]>0 && player_totem_powietrza_zasieg[id] < 1500)
	{
		player_totem_powietrza_zasieg[id]+= random_num(0,55)

	}
	if( player_oko_sokola[id]>0)
	{
		player_oko_sokola[id]+= random_num(0,2)

	}
	if( player_b_furia[id]>0)
	{
		player_b_furia[id]+= random_num(0,3)
		if(player_b_furia[id]>20) player_b_furia[id] = 20

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
	

	if(player_b_teamheal[id]>0 && player_b_teamheal[id]<100) player_b_teamheal[id] += random_num(5,10)
	
	if(player_b_redirect[id]>0 && player_b_redirect[id]<50) player_b_redirect[id]+= random_num(0,2)
	if(player_b_fireball[id]>0 && player_b_fireball[id]<500) player_b_fireball[id]+= random_num(0,33)
	if(player_b_ghost[id]>0) player_b_ghost[id]+= random_num(0,1)
	if(player_b_windwalk[id]>0) player_b_windwalk[id] += random_num(0,1)

	if(player_b_dagon[id]>0) player_b_dagon[id] += random_num(1,2)
	if(player_b_sniper[id]>0)
	{
		if(player_b_sniper[id]>5) player_b_sniper[id]-=random_num(0,2)
		else if(player_b_sniper[id]>2) player_b_sniper[id]-=random_num(0,1)
		else if(player_b_sniper[id]>1) player_b_sniper[id]-=random_num(-1,1)
	}
	if(player_b_m3[id]>0)
	{
		if(player_b_m3[id]>5) player_b_m3[id]-=random_num(0,2)
		else if(player_b_m3[id]>4) player_b_m3[id]-=random_num(0,1)
		else if(player_b_m3[id]>2) player_b_m3[id]-=random_num(-1,1)
	}
	if(player_awpk[id]>1)
	{
		if(player_awpk[id]>5) player_awpk[id]-=random_num(0,2)
		else if(player_awpk[id]>2) player_awpk[id]-=random_num(0,1)
		else if(player_awpk[id]>1) player_awpk[id]-=random_num(-1,1)
	}
	if(player_b_extrastats[id]>0) player_b_extrastats[id] += random_num(0,2)
	if(player_b_firetotem[id]>0) player_b_firetotem[id] += random_num(0,50)
	if(player_speedbonus[id]>0) player_speedbonus[id] += random_num(0,10)
	if(player_knifebonus[id]>0) player_knifebonus[id] += random_num(0,40)
	if(player_las[id]>0) player_las[id] += random_num(1,1)
	if(player_knifebonus_p[id]>0) player_knifebonus_p[id] += random_num(1,40)
	if(player_akrobata[id]>0) player_akrobata[id] += random_num(1,40)
	if(player_akrobata_m[id]>0) player_akrobata_m[id] += random_num(10,20)
	if(player_lodu_p[id]>0) player_lodu_p[id] += random_num(1,3)
	if(player_b_darksteel[id]>0) player_b_darksteel[id] += random_num(0,2)
	if(player_b_mine[id]>0) player_b_mine[id] += random_num(0,1)
	if(player_sword[id]>0)
	{
		if(player_b_jumpx[id]==0 && random_num(0,2)==0) player_b_jumpx[id]+=1
		if(player_b_vampire[id]==0 && random_num(0,5)==0) player_b_vampire[id]+=1
		if(player_b_darksteel[id]==0 && random_num(0,5)==0) player_b_darksteel[id]+=1
	}
	if(player_ultra_armor[id]>0) player_ultra_armor[id]++
	if(player_mrocznibonus[id]>0) player_mrocznibonus[id] += random_num(-5,10)
	if(player_ludziebonus[id]>0) player_ludziebonus[id] += random_num(-5,10)
	if(player_intbonus[id]>0) player_intbonus[id] += random_num(-5,10)
	if(player_strbonus[id]>0) player_strbonus[id] += random_num(-5,10)
	if(player_grom[id]>0) player_grom[id] += random_num(10,100)
	if(player_b_zloto[id]>0 && player_b_money[id]<15000) player_b_zloto[id] += random_num(100,2000)
	if(player_b_zlotoadd[id]>0 && player_b_zlotoadd[id]<15000) player_b_zlotoadd[id] += random_num(100,2000)
	if(player_b_tarczaogra[id]>0) player_b_tarczaogra[id] += random_num(-1,6)
	if(player_lembasy[id]>0) player_lembasy[id] += random_num(1,10)
	
	if(player_intbonus[id]>0) player_intbonus[id] += random_num(1,10)
	if(player_strbonus[id]>0) player_strbonus[id] += random_num(1,10)
	if(player_agibonus[id]>0) player_agibonus[id] += random_num(1,10)
	if(player_dexbonus[id]>0) player_dexbonus[id] += random_num(1,10)
	if(player_staty[id]>0) player_staty[id] += random_num(1,10)
	if(player_dosw[id]>0) player_dosw[id] += random_num(10,100)
	
	if(player_tarczam[id]>0){
		player_tarczam[id] += random_num(5,15)
		DamRedCalc(id, player_tarczam[id])
	}
	if(player_grawitacja[id]>0){ 
		player_grawitacja[id] -= random_num(1,3)
		if(player_grawitacja[id]<1) player_grawitacja[id] =1
	}
	if(player_chargetime[id]>0 && player_chargetime[id]<40) player_chargetime[id] += random_num(1,10)
	if(player_naszyjnikczasu[id]>0 && player_naszyjnikczasu[id]<40) player_naszyjnikczasu[id] += random_num(1,2)
	if(player_totem_enta[id]>0 && player_totem_enta[id] < 20) player_totem_enta[id] += random_num(1,3)
	if(player_totem_enta_zasieg[id]>0 && player_totem_enta_zasieg[id] < 1200) player_totem_enta_zasieg[id] += random_num(1,50)
	if(player_totem_lodu[id]>0 && player_totem_lodu[id] < 20) player_totem_lodu[id] += random_num(1,3)
	if(player_totem_lodu_zasieg[id]>0  && player_totem_lodu_zasieg[id] < 1200) player_totem_lodu_zasieg[id] += random_num(1,150)				
	if(player_dziewica[id]>0 && player_dziewica[id] < 60) player_dziewica[id] += random_num(1,10)	
	if(player_dziewica_hp[id]>0 && player_dziewica_hp[id] < 80) player_dziewica_hp[id] += random_num(1,10)
	if(player_dremora_lekka[id]>0 && player_dremora_lekka[id] < 10) player_dremora_lekka[id] += random_num(0,1)
	if(player_dremora[id]>0 && player_dremora[id] < 7) player_dremora[id] += random_num(0,1)
	if(player_dziewica_aut[id]>0 && player_dziewica_aut[id] < 20) player_dziewica_aut[id] += random_num(1,10)
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
	if (player_b_sniper[attacker_id] > 0 && get_user_team(attacker_id) != get_user_team(id) && weapon == CSW_SCOUT && player_class[attacker_id]!=Ninja && player_class[attacker_id]!=Orc)
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
	if (player_b_m3[attacker_id] > 0 && get_user_team(attacker_id) != get_user_team(id) && weapon == CSW_M3 && player_class[attacker_id]!=Ninja && player_class[attacker_id]!=Orc)
	{
		
		if (!is_user_alive(id))
			return PLUGIN_HANDLED
		
		if (random_num(1,player_b_m3[attacker_id]) == 1)
			UTIL_Kill(attacker_id,id,"world")
		
	}
	if(player_awpk[attacker_id] > 0 && get_user_team(attacker_id) != get_user_team(id) && weapon == CSW_AWP && player_class[attacker_id]!=Ninja && player_class[attacker_id]!=Orc){
		
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
	new itemdamage = damage/3
	if(player_class[id] == Orc) itemdamage = itemdamage / 10
	if(itemdamage > 10) itemdamage = 10
	if(itemdamage < 1) itemdamage = 1
	
	if (player_item_id[id] > 0 && item_durability[id] >= 0 && itemdamage> 0 && damage > 5 )
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
	
	if((get_user_button(id) & IN_JUMP) && !(get_entity_flags(id) & FL_ONGROUND) && !(get_user_oldbutton(id) & IN_JUMP))
	{
		new jj = 0
		if(player_class[id]==aniol) jj = player_naladowany[id] + 4
		if(player_class[id]==Stalker && player_lvl[id]>prorasa) jj = 1
		if(jumps[id] < player_b_jumpx[id] + jj)
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
	if(super ){
		if(player_lvl[id]>250 && player_lvl[id]<500){
			player_point[id]=(player_lvl[id]-1-200)*2-player_intelligence[id]-player_strength[id]-player_dextery[id]-player_agility[id]	
		}
		if(player_lvl[id]>500 && player_lvl[id]<750){
			player_point[id]=(player_lvl[id]-1-400)*2-player_intelligence[id]-player_strength[id]-player_dextery[id]-player_agility[id]	
		}
		if(player_lvl[id]>750){
			player_point[id]=(player_lvl[id]-1-600)*2-player_intelligence[id]-player_strength[id]-player_dextery[id]-player_agility[id]	
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
	
	formatex(Skillsinfo,767,"Masz %i sily - daje Ci to %i zycia<br><br>Masz %i zwinnosci - to redukuje sile atakow magia %i%%  i daje Ci szybsze bieganie o %i punkow <br><br>Masz %i zrecznosci - Redukuje obrazenia z normalnych atakow %0.0f%%<br><br>Masz %i inteligencji - to daje wieksza moc przedmiotom ktorych da sie uzyc<br>",
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
	if(distance > 1500) distance = 1500
	
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
	
	new distance_len = 10;
	
	pev(id,pev_origin,origin)
	pev(id,pev_angles,angles)
	
	teleport[0] = origin[0] + distance * floatcos(angles[1],degrees) * floatabs(floatcos(angles[0],degrees));
	teleport[1] = origin[1] + distance * floatsin(angles[1],degrees) * floatabs(floatcos(angles[0],degrees));
	teleport[2] = origin[2]+heightplus
	
	while (!Can_Trace_Line_Origin(origin,teleport) || Is_Point_Stuck(teleport,48.0))
	{	
		if (distance < distance_len)
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
		distance-=distance_len
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

public check_Skill(id)					//Redirect and check which items will be triggered
{
	if(player_NoSkill[id]>0)
	{
		return PLUGIN_HANDLED
	}
	
	if (  player_class[id] == Archeolog && player_naladowany[id] < (3+player_intelligence[id]/25)){
		archeolog_item(id)
		return PLUGIN_HANDLED
	}
	else if (  player_class[id] == Kaplan ){
		item_totemheal_Kaplan(id) 
		return PLUGIN_HANDLED
	}
	else if (  player_class[id] == szelf ){
		item_mineL(id)
		return PLUGIN_HANDLED
	}
	else if (  player_class[id] == Drzewiec ){
		if(player_naladowany[id] >0) player_naladowany[id] = 0
		else if(player_naladowany[id] == 0) player_naladowany[id] = 1
		write_hud(id)
	} 


	
	if(czas_rundy + 10 > floatround(halflife_time())){
		set_hudmessage(255, 0, 0, -1.0, 0.01)
		show_hudmessage(id, "Skilla mozesz uzywac 10 sek po starcie rundy")
		
		return PLUGIN_HANDLED
	}

	if (player_class[id] == lelf ){
		write_hud(id)
	}
	else if( player_class[id]==Mag)
	{	
		new Float:time_delay = 5.0-(player_intelligence[id]/50.0)-player_chargetime[id]/10.0
		if(player_b_fireball[id]>0) time_delay=random_float(2.5,5.0-(player_intelligence[id]/50.0))-player_chargetime[id]/10.0
		if(time_delay<2.5) time_delay = 2.5
		if((bowdelay[id] + time_delay)< get_gametime())
		{
			fired[id]=0
			item_fireball(id)
			bowdelay[id] = get_gametime()
			player_naladowany[id] = 1
			write_hud(id)
		}
	}
	else if (  player_class[id] == aniol ){
		item_archyaniol(id)
		write_hud(id)
	} 
	else if (  player_class[id] == MagO ){
		item_firetotem(id)
		write_hud(id)		
	} 
	else if (  player_class[id] == MagZ ){
		stomp_magz(id)
		write_hud(id)
	} 
	else if (  player_class[id] == MagW ){
		//dag_magw(id)
		MWNami(id)
		write_hud(id)
	} 
	else if (  player_class[id] == Arcymag ){
		dag_arc(id)
		write_hud(id)
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
		case 1: client_print(id,print_chat, "Witaj %s w Lord of Destruction mod www.cs-lod.com.pl napisz /komendy, zeby zobaczec liste komend /pomoc aby dowiedziec sie jak grac", name)
		
		case 2: client_print(id,print_chat, "Na www.cs-lod.com.pl znajdziesz poradniki, opisy klas i itemow! Tam tez zglaszaj pomysly zmian!")
		
		
	}
	
	
}

/* ==================================================================================================== */
public forceeventk2(id)
{
	if(get_user_flags(id) & ADMIN_LEVEL_H){
		forceEvent=2
		forceEventStarted = rounds
		for (new i=0; i < 33; i++){
			if(!is_user_connected(i)) continue;
			
			dropitem(id)
		}
	}
}

public forceeventk3(id)
{
	if(get_user_flags(id) & ADMIN_LEVEL_H){
		forceEvent=3
		forceEventStarted = rounds
	}
}

public forceeventk(id)
{
	if(get_user_flags(id) & ADMIN_LEVEL_H){
		forceEvent=1
		forceEventStarted = rounds
		for (new i=0; i < 33; i++){
			if(!is_user_connected(i)) continue;
			
			user_kill(i, 0)
			if(player_class[i]!=NONE) savexpcom(i)
			KlasyZlicz[player_class[i]]--
			player_naladowany[i] = 0
			player_naladowany2[i] = 0
			immun[i] = 0
			player_samelvl[i] = 0;
			player_samelvl2[i] = 0;
			if(KlasyZlicz[player_class[i]] < 0) KlasyZlicz[player_class[i]] = 0
			player_class[id]=NONE	
			changerace(i)
		}
	}
}

public eventk3(id)
{
	new mino = 5
	if(get_playersnum()<10) 
	{
		client_print(id,print_chat, "Za malo graczy.")
		return
	}
	if(get_playersnum()<25) 
	{
		mino = 4
	}
	if(get_playersnum()<20) 
	{
		mino = 2
	}
	if(get_playersnum()<15) 
	{
		mino = 1
	}
	if(forceEvent==3) 
	{
		client_print(id,print_chat, "Event trwa auto resp, wiekszy exp za cele mapy")
		return
	}
	if(forceEvent==2) 
	{
		client_print(id,print_chat, "Event trwa +20proc xp")
		return
	}
	if(forceEvent==1) 
	{
		client_print(id,print_chat, "Event trwa +70proc xp")
		return
	}
	if(vote[id]>0)	
	{
		client_print(id,print_chat, "Nie mozesz glosowac ponownie.")
		new c=0
		for(new i=0; i<33; i++)
		{
			if(vote[i]>0) c++
		}
		client_print(id,print_chat, "Liczba glosow: %i na %i", c, (get_playersnum() - mino))
	}
	else
	{
		client_print(id,print_chat, "Zaglosowales na event autorespa zwiekszony exp za cele mapy.")
		client_print(id,print_chat, "Aby cofnac swoj glos zrob reconnecta.")
		vote[id]=1
		new c=0
		for(new i=0; i<33; i++)
		{
			if(vote[i]>0) c++
		}
		client_print(id,print_chat, "Liczba glosow: %i na %i", c, (get_playersnum() - mino))
		if(c >= (get_playersnum() - mino))
		{
			forceEvent=3
			forceEventStarted = rounds			
		}
	}
}

public eventk2(id)
{
	new mino = 8
	if(get_playersnum()<10) 
	{
		client_print(id,print_chat, "Za malo graczy.")
		return
	}
	if(get_playersnum()<25) 
	{
		mino = 6
	}
	if(get_playersnum()<20) 
	{
		mino = 4
	}
	if(get_playersnum()<15) 
	{
		mino = 2
	}
	if(forceEvent==3) 
	{
		client_print(id,print_chat, "Event trwa auto resp, wiekszy exp za cele mapy")
		return
	}
	if(forceEvent==2) 
	{
		client_print(id,print_chat, "Event trwa +20proc xp")
		return
	}
	if(forceEvent==1) 
	{
		client_print(id,print_chat, "Event trwa +70proc xp")
		return
	}
	if(vote[id]>0)	
	{
		client_print(id,print_chat, "Nie mozesz glosowac ponownie.")
		new c=0
		for(new i=0; i<33; i++)
		{
			if(vote[i]>0) c++
		}
		client_print(id,print_chat, "Liczba glosow: %i na %i", c, (get_playersnum() - mino))
	}
	else
	{
		client_print(id,print_chat, "Zaglosowales na event grania dwoma tymi samymi itemami +20proc xp. Item zmienia sie co runde.")
		client_print(id,print_chat, "Aby cofnac swoj glos zrob reconnecta.")
		vote[id]=1
		new c=0
		for(new i=0; i<33; i++)
		{
			if(vote[i]>0) c++
		}
		client_print(id,print_chat, "Liczba glosow: %i na %i", c, (get_playersnum() - mino))
		if(c >= (get_playersnum() - mino))
		{
			forceEvent=2
			forceEventStarted = rounds
			for (new i=0; i < 33; i++){
				if(!is_user_connected(i)) continue;
				
				dropitem(id)
			}			
		}
	}
}
/* ==================================================================================================== */
public eventk(id)
{
	new mino = 8
	if(get_playersnum()<10) 
	{
		client_print(id,print_chat, "Za malo graczy.")
		return
	}
	if(get_playersnum()<25) 
	{
		mino = 6
	}
	if(get_playersnum()<20) 
	{
		mino = 4
	}
	if(get_playersnum()<15) 
	{
		mino = 2
	}
	if(forceEvent==3) 
	{
		client_print(id,print_chat, "Event trwa auto resp, wiekszy exp za cele mapy")
		return
	}
	if(forceEvent==1) 
	{
		client_print(id,print_chat, "Event trwa +70proc xp")
		return
	}
	if(forceEvent==2) 
	{
		client_print(id,print_chat, "Event trwa +20proc xp")
		return
	}
	if(vote[id]>0)	
	{
		client_print(id,print_chat, "Nie mozesz glosowac ponownie.")
		new c=0
		for(new i=0; i<33; i++)
		{
			if(vote[i]>0) c++
		}
		client_print(id,print_chat, "Liczba glosow: %i na %i", c, (get_playersnum() - mino))
	}
	else
	{
		client_print(id,print_chat, "Zaglosowales na event grania dwoma roznymi klasami +70proc xp. Klasy wybrane jako pierwsze beda musieli wybrac wszyscy.")
		client_print(id,print_chat, "Aby cofnac swoj glos zrob reconnecta.")
		vote[id]=1
		new c=0
		for(new i=0; i<33; i++)
		{
			if(vote[i]>0) c++
		}
		client_print(id,print_chat, "Liczba glosow: %i na %i", c, (get_playersnum() - mino))
		if(c >= (get_playersnum() - mino))
		{
			forceEvent=1
			forceEventStarted = rounds
			for (new i=0; i < 33; i++){
				if(!is_user_connected(i)) continue;
				
				user_kill(i, 0)
				if(player_class[i]!=NONE) savexpcom(i)
				KlasyZlicz[player_class[i]]--
				player_naladowany[i] = 0
				player_naladowany2[i] = 0
				immun[i] = 0
				player_samelvl[i] = 0;
				player_samelvl2[i] = 0;
				if(KlasyZlicz[player_class[i]] < 0) KlasyZlicz[player_class[i]] = 0
				player_class[id]=NONE	
				changerace(i)
			}			
		}
	}
}

public changerace(id)
{
	if(bowdelay[id] + 5 < get_gametime()){
		bowdelay[id] = get_gametime()

		for (new i=0; i < 33; i++){
			if(player_class[i]!=NONE) break
			if(i==32) return
		}
		if(freeze_ended && player_class[id]!=NONE ){
			new kid = last_attacker[id]
			new vid = id
			if (is_user_connected(kid) && is_user_connected(vid) && get_user_team(kid) != get_user_team(vid))
			{
				show_deadmessage(kid,vid,0,"world")
				award_kill(kid,vid)
				add_barbarian_bonus(kid)
				if (player_class[kid] == Barbarzynca || player_refill[kid]>0) refill_ammo(kid, 1)
				set_renderchange(kid)
			}
			user_kill(id, 0)
			
		}
		if(player_class[id]!=NONE) savexpcom(id)
		KlasyZlicz[player_class[id]]--
		player_naladowany[id] = 0
		player_naladowany2[id] = 0
		immun[id] = 0
		player_samelvl[id] = 0;
		player_samelvl2[id] = 0;
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
	if (used_item[id] && player_class[id]!=MagO && player_diablo[id]==0 && player_she[id]==0)
	{
		hudmsg(id,2.0,"Mozesz uzyc raz w rundzie totemu ognia")
	}
	else
	{
		if(player_class[id]==MagO ){
			
			new Float:bonus = float(player_intelligence[id]/20)
			if(bonus >= 15.0) bonus = 15.0
			bonus = bonus + ((20 - bonus) *  player_naszyjnikczasu[id]/ 100)
			if((bowdelay[id] + 20 - bonus)< get_gametime()){
				bowdelay[id] = get_gametime()
				
				Effect_Ignite_Totem(id,7)							
				player_b_firetotem[id] = random_num(700+player_intelligence[id],1000+player_intelligence[id])
				player_naladowany[id]=1
			}
		}
		else{
			used_item[id] = true
			Effect_Ignite_Totem(id,7)	
		}

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
			if(player_class[pid]==MagW) continue
			
			if (!is_user_alive(pid) || (get_user_team(id) == get_user_team(pid)&& pid!=id) ||   cs_get_user_team(pid) == CS_TEAM_SPECTATOR)
				continue
				
			if(player_class[id]==MagO ){
				new  d= (get_maxhp(pid) * 5 / 100) - (player_dextery[pid] / 10) -1
				if(player_class[pid]==Orc) d= (get_maxhp(pid) * 5 / 1000) - (player_dextery[pid] / 10) -1

				if(d<1) d=1
				if(!fm_is_ent_visible(pid,id) && !fm_is_ent_visible(pid,id)) d = d/10;
				
				Effect_Ignite(pid,id,d)					
			}
			else
			{
			//Dextery makes the fire damage less
				if (player_dextery[pid] > 20)
					Effect_Ignite(pid,id,1)
				else if (player_dextery[pid] > 15)
					Effect_Ignite(pid,id,2)
				else if (player_dextery[pid] > 10)
					Effect_Ignite(pid,id,3)
				else
					Effect_Ignite(pid,id,4)
			
			}
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
	if(player_class[id]==MagW|| player_magic_imun[id] > 0) return
	if(damage < 1) damage = 1
	if(HasFlag(id,Flag_Ignite)){
		new da = pev(afflicted[id][Flag_Ignite],pev_euser2)
		if(da >= damage) return;		
		remove_entity(afflicted[id][Flag_Ignite])		
		RemoveFlag(id,Flag_Ignite)
		Remove_All_Tents(id)
	} 
	new ent = Spawn_Ent("info_target")
	set_pev(ent,pev_classname,"Effect_Ignite")
	set_pev(ent,pev_owner,id)
	set_pev(ent,pev_ltime, halflife_time() + 60 + 0.1)
	set_pev(ent,pev_solid,SOLID_NOT)
	set_pev(ent,pev_euser1,attacker)
	set_pev(ent,pev_euser2,damage)
	set_pev(ent,pev_nextthink, halflife_time() + 0.1)	
	change_health(id,-damage,attacker,"world")	
	
	AddFlagEnt(id,Flag_Ignite, ent)
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
	//Display_Tent(id,sprite_ignite,2)
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

stock AddFlagEnt(id,flag, ent)
{
	afflicted[id][flag] = ent	
}

stock AddFlag(id,flag)
{
	afflicted[id][flag] = 1	
}

stock RemoveFlag(id,flag)
{
	//change_health(id,2,id,"world")
	afflicted[id][flag] = 0
}

stock bool:HasFlag(id,flag)
{
	if (afflicted[id][flag]>0)
		return true
	if (afflicted[id][flag]<0)
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
	
	new i = player_intelligence[id]/2
	if(i>200) i = 200
	new Float:dx
	dx = (4+i) * 120.0 / floatsqroot(dy)
	
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
		if(forceEvent != 2) award_item_f(id,0,15)
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
	new czas = 15 - player_intelligence[id]/30
	if(czas<7)czas=7
	czas = czas - (czas *  player_naszyjnikczasu[id]/ 100)
	if (halflife_time()-gravitytimer[id] <= czas)
	{
		
		show_hudmessage(id, "Ten skill moze byc uzyty co kazde %i sekundy", czas)
		return PLUGIN_CONTINUE
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
	player_naladowany2[id]=1
	write_hud(id)
	return PLUGIN_CONTINUE
}

public respawn(svIndex[]) 
{ 
	new vIndex = str_to_num(svIndex) 
	if(is_user_connected(vIndex)){
		if(is_user_alive(vIndex) && planter == vIndex){
			
			set_task(3.5,"after_spawn_c4",vIndex) 
		}
		spawn(vIndex);
		set_task(1.5,"after_spawn",vIndex) 
	}
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
	
	if (player_class[id] == aniol && halflife_time()-gravitytimer[id] <= 30)
	{
		hudmsg(id,2.0,"Ten przedmiot, moze byc uzyty co kazde 30 sekundy")
		return PLUGIN_CONTINUE
	}
	
	if (player_class[id] != aniol && halflife_time()-gravitytimer[id] <= 5)
	{

		hudmsg(id,2.0,"Ten przedmiot, moze byc uzyty co kazde 5 sekundy")
		return PLUGIN_CONTINUE
	}		
	if(czas_rundy + 10 > floatround(halflife_time())){
		set_hudmessage(255, 0, 0, -1.0, 0.01)
		show_hudmessage(id, "Skilla mozesz uzywac 10 sek po starcie rundy")
		
		return PLUGIN_CONTINUE
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
	if (dam < 75 )
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
	
	new numfound = find_sphere_class(id,"player",230.0+inta*2.0,entlist,512)	

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

		if(player_class[id] == aniol){
			new pe = 35 + inta/ 10
			if(pe>60) pe = 60
			dam = dam * 50 /100
			if(dam>150) dam = 150 + ((dam - 150) /2)
			if(dam>300) dam = 300
			if(player_class[pid]!=Orc) dam += get_maxhp(pid)*pe/100 
			if(player_class[pid]==Orc) dam += get_maxhp(pid)*pe/1000 	
			if(player_lvl[id] > prorasa){
				if(player_b_szarza_time[pid] < floatround(halflife_time())){
					delta_vec[z] = 200.0
					set_user_gravity(pid,0.1)
					set_task(0.1, "space_f", pid)
					set_task(0.2, "space_f", pid)
					set_task(0.5, "space_f", pid)
					set_task(0.7, "space_f", pid)
					set_task(1.1, "space_f", pid)
					set_task(1.6, "space_f", pid)
					set_task(2.0, "space_f", pid)
					set_task(2.5, "space_f", pid)
					set_pev(pid,pev_velocity,delta_vec)
				}
				set_task(4.0, "set_gravitychange", pid)
			}
		}
		new red = dexteryDamRedPerc[pid]
		dam = dam +50 
		dam = dam - (dam * red /100)
		if (dam < 10) dam = 10
		if(!fm_is_ent_visible(pid,id) && !fm_is_ent_visible(pid,id)) dam = dam/10;
		change_health(pid,-dam,id,"world")					
	}
		
	return PLUGIN_CONTINUE
}

public space_f(id)
{	
	set_user_gravity(id,0.1)
}

public item_space(id)
{	
	new czas = 20
	czas = czas - (czas *  player_naszyjnikczasu[id]/ 100)
	if (player_class[id] == MagP && (halflife_time()-bowdelay[id] <=( czas )))
	{
		if(random_num(0,5)==0)hudmsg(id,2.0,"Ten czar, moze byc uzyty co kazde 20 sekund")
		return PLUGIN_CONTINUE
	}
		
	if(czas_rundy + 10 > floatround(halflife_time())){
		set_hudmessage(255, 0, 0, -1.0, 0.01)
		show_hudmessage(id, "Skilla mozesz uzywac 10 sek po starcie rundy")
		
		return PLUGIN_CONTINUE
	}
	player_naladowany2[id]=1
	hudmsg(id,2.0,"Moc uzyta!")
	efekt_magp(id)
	bowdelay[id] = halflife_time()
	add_bonus_space(id)
		
	return PLUGIN_CONTINUE
	
}

public add_bonus_space(id)
{
	set_gravitychange(id)
	new origin[3]
	get_user_origin(id,origin)
	
	new dam = floatround(player_intelligence[id] * 0.05)
	if(player_class[id] == MagP) dam += floatround(player_intelligence[id] * 0.20)
	if(dam > 100) dam=100 
	
	earthstomp[id] = 0
	
	message_begin(MSG_ONE , get_user_msgid("ScreenShake") , {0,0,0} ,id)
	write_short( 1<<14 );
	write_short( 1<<12 );
	write_short( 1<<14 );
	message_end();
		
	new entlist[513]
	new numfound = find_sphere_class(id,"player",500.0+player_intelligence[id]*2,entlist,512)
	new ran = 4
	if(player_intelligence[id] > 25) ran = 3
	if(player_intelligence[id] > 50) ran = 2
	if(player_intelligence[id] > 100) ran = 1
	if(player_intelligence[id] > 200) ran = 0
	if(player_class[id] == MagP) player_tarczapowietrza[id] = floatround(player_intelligence[id] * 0.6)
	
	if (is_user_alive(id)){
		for (new i=0; i < numfound; i++)
		{		
			new pid = entlist[i]
			if (pid == id || !is_user_alive(pid))
				continue
				
			if (get_user_team(id) == get_user_team(pid))
				continue
				
			if (is_user_alive(pid) && random_num(0,ran)==0) DropWeapon(pid)
			
			
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
		
			dam -= player_dextery[pid]
			if(dam < 1) dam=1 
			if(!fm_is_ent_visible(pid,id) && !fm_is_ent_visible(pid,id)) dam = dam/10;
			
			if(player_class[pid]==Orc )
				change_health(pid,-dam -get_maxhp(pid)*(10+ 4 - ran)/1000,id,"world")
			else
				change_health(pid,-dam -get_maxhp(pid)*(10 + 4 - ran)/100,id,"world")
			set_gravitychange(pid)
		}
	
	}
	return PLUGIN_CONTINUE
}

public stomp_magz(id)
{		
	
	new czas = 10 - player_intelligence[id]/25
	if(czas<5)czas=5
	czas = czas - (czas *  player_naszyjnikczasu[id]/ 100)
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
	if(player_intelligence[id]<100) dam =  20 + player_intelligence[id]/2
	else if(player_intelligence[id]<200&&player_intelligence[id]>=100) dam = 70 + (player_intelligence[id]-100)/3
	else if(player_intelligence[id]<400&&player_intelligence[id]>=200) dam = 105 + (player_intelligence[id]-200)/4
	dam = dam + dam/2
	
	message_begin(MSG_ONE , get_user_msgid("ScreenShake") , {0,0,0} ,id)
	write_short( 1<<14 );
	write_short( 1<<12 );
	write_short( 1<<14 );
	message_end();
		
	new inta = player_intelligence[id]
	new percc = 20
	if(player_class[id]==Arcymag) inta = player_intelligence[id]/5
	if(player_class[id]==Arcymag) percc = 5
	new entlist[513]
	if(inta>210) inta = 210
	
	new origin[3]
	pev(id,pev_origin,origin)

	//Find people near and give them health
	message_begin( MSG_BROADCAST, SVC_TEMPENTITY, origin );
	write_byte( TE_BEAMCYLINDER );
	write_coord( origin[0] + 5);
	write_coord( origin[1] );
	write_coord( origin[2] );
	write_coord( origin[0] + 5);
	write_coord( origin[1] + floatround(400+inta*0.5));
	write_coord( origin[2] + floatround(400+inta*0.5));
	write_short( sprite_white );
	write_byte( 0 ); // startframe
	write_byte( 0 ); // framerate
	write_byte( 10 ); // life
	write_byte( 10 ); // width
	write_byte( 255 ); // noise
	write_byte( 0 ); // r, g, b
	write_byte( 250 ); // r, g, b
	write_byte( 0 ); // r, g, b
	write_byte( 128 ); // brightness
	write_byte( 8 ); // speed
	message_end();
	
	new numfound = find_sphere_class(id,"player",400.0+inta*0.5,entlist,512)
	new s = 0
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
		n_dam  -= player_dextery[pid] * 2
		if(n_dam  < 1) n_dam =1 
		if(player_class[pid]==Orc) n_dam = n_dam + (get_maxhp(pid) *percc/1000)
		else n_dam = n_dam + (get_maxhp(pid) *percc/100)
		
		if(!fm_is_ent_visible(pid,id) && !fm_is_ent_visible(pid,id)) n_dam = n_dam/10;

		change_health(pid,-n_dam,id,"world")	
		s = s + n_dam/5
		Display_Fade(pid,2600,2600,0,0,255,0,50)
		new sl = 5
		efekt_slow_enta(pid, sl)
	}
	change_health(id,s,id,"world")	
		
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
	if(!is_user_connected(id)){
		return PLUGIN_CONTINUE
	}
	if (!is_user_alive(id) || !HasFlag(id,Flag_Rot) || !freeze_ended || player_b_fireshield[id] == 0)
	{
		Display_Icon(id,0,"dmg_bio",255,255,0)
		
		set_renderchange(id)
		
		remove_entity(ent)
		return PLUGIN_CONTINUE
	}
	
	Display_Icon(id,1,"dmg_bio",255,150,0)
	set_renderchange(id)

	new entlist[513]
	new Float:zakres = 250.0;
	if(player_frostShield[id] >0){
		zakres = 50.0 * player_frostShield[id];
	}
	new numfound = find_sphere_class(id,"player",zakres,entlist,512)
	
	for (new i=0; i < numfound; i++)
	{		
		new pid = entlist[i]
			
		if (pid == id || !is_user_alive(pid))
			continue
			
		if (get_user_team(id) == get_user_team(pid))
			continue
		
		if(player_b_fireshield[id] >0 && player_frostShield[id]< 1 && player_class[pid]!=MagW){
			if (random_num(1,5) == 1) Display_Fade(pid,1<<14,1<<14,1<<16,255,155,50,230)
			change_health(pid,-5,id,"world")
			Effect_Bleed(pid,100)
			if(player_b_szarza_time[pid] < floatround(halflife_time())) Create_Slow(pid,3)
			 
		}
		if(player_frostShield[id]>1){
			Display_Fade(pid,2600,2600,0,0,0,255,50)
			efekt_slow_lodu(pid, 5)
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
		if(is_user_connected(id))set_user_maxspeed(id,245.0+(player_dextery[id]))
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

public item_dziewica_hp(id)
{
	if (player_dziewica_using[id])
	{
		RemoveFlag(id,Flag_Moneyshield)
		player_dziewica_using[id] = 0
		Display_Icon(id,0,"dmg_bio",255,0,0)
	}
	else
	{
		czas_itemu[id] = floatround(halflife_time())+2
		player_dziewica_using[id] = 1
		Display_Icon(id,1,"dmg_bio",255,0,0)
	}	
	return PLUGIN_CONTINUE
}

public item_dziewica(id)
{
	if (player_dziewica_using[id])
	{
		RemoveFlag(id,Flag_Moneyshield)
		player_dziewica_using[id] = 0
		Display_Icon(id,0,"dmg_bio",255,0,0)
	}
	else
	{
		czas_itemu[id] = floatround(halflife_time())+2
		player_dziewica_using[id] = 1
		Display_Icon(id,1,"dmg_bio",255,0,0)
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
	if (!is_user_alive(id) || cs_get_user_money(id) <= 0 || !HasFlag(id,Flag_Moneyshield) || !freeze_ended)
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

public item_mine(id)
{
	if ( is_user_in_bad_zone( id ) ){
		hudmsg(id,2.0,"Nie mozna uzyc w tym miejscu")
		return PLUGIN_HANDLED
	}
	new flags = pev(id,pev_flags) 
	if ( !(flags & FL_ONGROUND) ){
		hudmsg(id,2.0,"Musisz stac na ziemi")
		return PLUGIN_HANDLED
	}
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
	engfunc(EngFunc_SetSize,ent,Float:{-16.0,-16.0,0.0},Float:{16.0,16.0,2.0})
	
	drop_to_floor(ent)

	entity_set_float(ent,EV_FL_nextthink,halflife_time() + 0.01) 
	
	set_rendering(ent,kRenderFxNone, 0,0,0, kRenderTransTexture,50)	
	
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
		
		if (pev(target,pev_rendermode) == kRenderTransTexture || player_item_id[target] == 17 || player_class[target] == Ninja)
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
		Give_Xp(id, get_cvar_num("diablo_xpbonus")/10+1)
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
public item_totemheal(id)
{
	
	if (used_item[id] )
	{
		hudmsg(id,2.0,"Leczacy Totem mozesz uzyc raz na runde!")
		return PLUGIN_CONTINUE
	}

	if(player_item_id[id]==176 && player_b_skill[id] <= 0){
		hudmsg(id,2.0,"Leczacy Totem mozesz uzyc raz na runde!")
		return PLUGIN_CONTINUE
	}
	
	hudmsg(id,2.0,"Leczacy Totem!")
	used_item[id] = true

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
	if(player_item_id[id]==176) player_b_skill[id]--
	
	return PLUGIN_CONTINUE	
}

public item_totemheal_Kaplan(id)
{
	if(player_naladowany[id] >= 5  && player_class[id] == Kaplan){
		
		hudmsg(id,2.0,"Leczacy Totem mozesz uzyc 5 razy na runde!")
		return PLUGIN_CONTINUE
	}
	
	hudmsg(id,2.0,"Leczacy Totem!")

	player_naladowany[id]++
	
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
	if(player_item_id[id]==176) player_b_skill[id]--
	
	return PLUGIN_CONTINUE	
}

public Effect_Healing_Totem_Think(ent)
{
	new id = pev(ent,pev_owner)
	new totem_dist = 300

	
	new amount_healed = player_b_heal[id]
	if(player_class[id]==Kaplan){
		new lecz = 10 + player_intelligence[id]/2
		if(lecz>50) lecz = 50
		amount_healed += lecz
	}
	
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
			
								
			if (is_user_alive(pid)){
			
				if(player_inkizytor[id] > 0){
					if (get_user_team(pid) != get_user_team(id)){
						Display_Fade(pid,2600,2600 ,1<<16,255,155,50,230)
						change_health(pid,- get_maxhp(pid) * player_inkizytor[id] /100,id,"")	
						if(item_durability[pid]>5){
							item_durability[pid] -= 5
						}
					}
				}
				if (get_user_team(pid) != get_user_team(id))
					continue
					
				change_health(pid,amount_healed,id,"")	

				if(player_class[id] == Kaplan){
					if(item_durability[pid]<255){
						if(id == pid){
							 item_durability[pid] += 8
						}else{
							 item_durability[pid] += 3
						}
					}
	
				}
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
	if(player_inkizytor[id] > 0){
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
		write_byte( 0 ); // r, g, b
		write_byte( 0 ); // r, g, b
		write_byte( 120 ); // brightness
		write_byte( 5 ); // speed
		message_end();
	}
	
	set_pev(ent,pev_euser2,1)
	set_pev(ent,pev_nextthink, halflife_time() + 0.5)
	
	    
	return PLUGIN_CONTINUE

}

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
}

public set_speedchange(id) {
	
	if(DemageTake[id]==1) {
		agi=(BASE_SPEED / 2)
		if(player_class[id] == Orc) agi = BASE_SPEED - (BASE_SPEED / 5) 
		if(player_b_szarza_time[id] > floatround(halflife_time())) agi=BASE_SPEED *5
	}
	else agi=BASE_SPEED	
	
	if (is_user_connected(id) && freeze_ended)
	{
		new speeds
		new d =  floatround(100.0*(1.0-floatpower(2.0, -0.017 * float(player_dextery[id]  - player_strength[id]/5)))) 
		
		if(player_class[id] == Orc) speeds = -15 + floatround(d*0.9)
		else if(player_class[id] == Ninja && player_edison[id] == 0) speeds = 50 + floatround(d*1.1) + ((5+d)*player_naladowany[id])
		else if(player_class[id] == Ninja && player_edison[id] == 1) speeds = 20 + floatround(d*1.1) + ((20)*player_naladowany[id])
		else if(player_class[id] == Zabojca) speeds = 15 + floatround(d*1.1)
		else if(player_class[id] == szelf) speeds = 20 + floatround(d*1.1)
		else if(player_class[id] == Barbarzynca || player_class[id] == Paladyn) speeds = -10 + floatround(d*1.1)
		else if(player_class[id] == Magic) speeds = -10 + floatround(d*1.1)
		else if(player_class[id] == Wampir) speeds = 50 + floatround(d*2.0)
		else if(player_class[id] == Drzewiec){ 
			speeds = -50 + floatround(d*1.1) - player_strength[id]/2
			if(speeds < -150) speeds = -150
		}
		else if(player_class[id] == Harpia){
			speeds = 40 + floatround(player_dextery[id]*1.3)
			if(player_naladowany[id]>0) speeds += (20+d/2)*player_naladowany[id]
		} 
		else if(player_class[id] == Wilk){
			speeds = floatround(d*1.1)
			if(player_naladowany[id]==1) speeds += 70
		} 
		else speeds= floatround(d*1.1)
		if(speeds<-25) speeds=-25;
				
		if(player_timed_speed[id]>halflife_time()){
			speeds += 90
		}
		if(player_b_usingwind[id] == 1){
			speeds += 200
		}
		if(KlasyZlicz[player_class[id]]==1) speeds += 10
		else if(KlasyZlicz[player_class[id]] >=5 && clEvent != 2 && immun[id] == 0) speeds -= 40
		else if(KlasyZlicz[player_class[id]] >=1 && clEvent != 2 && immun[id] == 0) speeds -= 20
		
		if(player_Slow[id]>0) speeds -= player_Slow[id]
		
		if(player_timed_slow[id]>halflife_time()){
			speeds -= 90
		}
		if(player_b_m3_knock[id] > 0 ){
			new clip,ammo
			new weapon=get_user_weapon(id,clip,ammo)
			if(weapon == CSW_M3) speeds += 90
		}
		
		if(player_money_speedbonus[id]){
			new g = cs_get_user_money(id)/5000
			speeds += (player_money_speedbonus[id] * g)
		}	
		if (player_class[id] == Witch && player_naladowany[id] == Harpia)
		{
			speeds += 20*player_naladowany2[id]
		}
		
		if(player_b_szarza_time[id] < floatround(halflife_time())){
			if(player_b_tarczaograon[id] == 1 ||  ofiara_totem_enta[id] > floatround(halflife_time())  ){
				agi = 1.0
				speeds = 0
			}
			if(player_class[id]!=MagO && ofiara_totem_lodu[id] > floatround(halflife_time())){
				agi = agi / 3
				if(speeds >100) speeds = 100
				if(player_b_nieust2[id] > 0 && get_user_health(id) < player_b_nieust2[id]) speeds = speeds - 1
				else speeds = (speeds/2) * 100 / (200 - player_b_nieust[id]) 
			}
		}
		
		new Float:razem = agi + speeds + player_speedbonus[id]
		if(player_class[id]==Ninja && player_edison[id] == 0){
			if(razem>550.0)	razem = 550.0
		}
		else if(player_class[id]==Harpia || player_class[id]==Wampir){ 
			if(razem>550.0) razem = 550.0
		}
		else{
			if(razem>500.0) razem = 500.0
		}

		if(player_b_furia[id] > 0){
			client_cmd(id, "cl_forwardspeed 5000");
			client_cmd(id, "cl_sidespeed 5000");
			client_cmd(id, "cl_backspeed 5000");
			razem = player_b_furia[id] * 100.0
		}	
		set_user_maxspeed(id,razem)
	}
}

public set_renderchange(id) {
	if(is_user_connected(id) && is_user_alive(id))
	{	
		if((player_green[id]==0 && !task_exists(id+TASK_FLASH_LIGHT)) || player_b_szarza_time[id] > floatround(halflife_time()))
		{
			new render=255
			if(player_b_samurai[id]>0){
			
				render = player_b_inv[id]

				if(render<0) render=0
				set_user_rendering(id, kRenderFxNone, 0, 0, 0, kRenderTransAlpha, render)
			
			}
			else if (player_class[id] == Ninja)
			{
				new inv_bonus = 255 - player_b_inv[id]
				render =5
				if(player_agility[id] >= 50 && player_edison[id] == 0) render =4
				if(player_agility[id] >= 100 && player_edison[id] == 0) render =3
				if(player_agility[id] >= 150 && player_edison[id] == 0) render =2
				if(player_agility[id] >= 200 && player_edison[id] == 0) render =1
				if(player_agility[id] >= 250 && player_edison[id] == 0) render =0
				
				if(player_b_inv[id]>0)
				{
					while(inv_bonus>0)
					{
						inv_bonus-=20
						render--
					}
				}
				
				if(player_b_usingwind[id]==1)
				{
					render/=2
				}
				
				if(render<0) render=0
				
				if(HasFlag(id,Flag_Moneyshield)||HasFlag(id,Flag_Rot)||HasFlag(id,Flag_Teamshield_Target)) render+=5	
				
				set_user_rendering(id, kRenderFxNone, 0, 0, 0, kRenderTransAlpha, render)
			}
			else if(timed_inv[id] > floatround(halflife_time())){
				set_user_rendering(id, kRenderFxNone, 0, 0, 0, kRenderTransAlpha, 1)
			}
			else if (player_class[id] == Stalker)
			{
				render = 80 - player_intelligence[id]/4
				if(render <55) render = 55
				set_user_rendering(id, kRenderFxNone, 0, 0, 0, kRenderTransAlpha, render)
				
				if(player_class[id] == Stalker){
					new button2 = get_user_button(id);
					if ( (button2 & IN_DUCK)){
						set_rendering(id,kRenderFxGlowShell,0,0,0 ,kRenderTransAlpha, 0 );
					}
					else if(player_timed_inv[id]>halflife_time()){
						set_user_rendering(id, kRenderFxNone, 0, 0, 0, kRenderTransAlpha, 7)
					}
	
					write_hud(id)
				}
			}
			else if((player_class[id]==Mnich || player_class[id]==Orc) && player_5hp[id] == 0){
				set_rendering ( id, kRenderFxGlowShell,50,50,00, kRenderFxNone, 50 )
			}
			else if (player_class[id] == Witch && player_naladowany[id] == szelf)
			{
				render = 250 - (player_naladowany2[id]*50)
				if(render<50) render=50
				if(player_naladowany2[id]>13) render=40
				if(player_naladowany2[id]>15) render=35
				set_user_rendering(id, kRenderFxNone, 0, 0, 0, kRenderTransAlpha, render)
			}
			else if (player_class[id] == szelf)
			{
				if(player_intelligence[id]<100)	player_b_inv[id] = 200 - player_intelligence[id]
				if(player_intelligence[id]<200 && player_intelligence[id]>=100 )	player_b_inv[id] = 100 - (player_intelligence[id] - 100)/2	
				if(player_intelligence[id]>=200) player_b_inv[id] = 50
				if(player_item_id[id] ==17 || player_item_id[id] ==174 || player_item_id[id]  == 178 ) player_b_inv[id] = 8
				if(on_knife[id] && !casting[id]) player_b_inv[id] = 30
				render = player_b_inv[id]
				if(render<0) render=0
				
				set_user_rendering(id, kRenderFxNone, 0, 0, 0, kRenderTransAlpha, render)
			}
			else if (player_class[id] == Harpia)
			{
				render = 150
				if(player_item_id[id] ==17 || player_item_id[id] ==174 || player_item_id[id]  == 178 ) render = 8
				if(player_b_inv[id] < render && player_b_inv[id] >0) render = player_b_inv[id]
				set_user_rendering(id, kRenderFxNone, 0, 0, 0, kRenderTransAlpha, render)
			}
			else if (player_class[id] == aniol)
			{
				render = 180
				if(on_knife[id]){
					render = 50
				}
				if(player_item_id[id] ==17 || player_item_id[id] ==174 || player_item_id[id]  == 178 ) render = 8
				if(player_b_inv[id] < render && player_b_inv[id] >0) render = player_b_inv[id]
				set_user_rendering(id, kRenderFxNone, 0, 0, 0, kRenderTransAlpha, render)
			}
			else if(player_class[id] == Wampir && player_naladowany[id]>0)
			{
				set_user_rendering(id, kRenderFxNone, 0, 0, 0, kRenderTransAlpha, 0)
			}
			else if(player_class[id] == Zmij )
			{
				new clip,ammo
				new weapon=get_user_weapon(id,clip,ammo)
				if(weapon == CSW_KNIFE || (halflife_time()-player_naladowany[id] <= 5 + player_strength[id]/10)) set_rendering ( id, kRenderFxGlowShell,1,150,1, kRenderFxNone, 10 )
			}
			else if(HasFlag(id,Flag_Moneyshield)||player_b_usingwind[id]==1||HasFlag(id,Flag_Teamshield_Target))
			{
				if (player_b_usingwind[id]==1 && !(invisible_cast[id]==1)) set_user_rendering(id,kRenderFxNone, 0,0,0, kRenderTransTexture,55)
				
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
			if(player_b_inv[id] == 666) 
			{
				set_user_rendering(id, kRenderFxNone, 0, 0, 0, kRenderTransAlpha, 0)
			}
			
			if(player_b_blink4[id] == 2){
				if (player_b_blink2[id] + 10 < halflife_time()){
					player_b_blink4[id] = 1
				}

				if(player_b_blink4[id] == 2) set_user_rendering(id, kRenderFxNone, 0, 0, 0, kRenderTransAlpha, 5)
			}
			
			if(player_timed_inv[id]>halflife_time()){
				set_user_rendering(id, kRenderFxNone, 0, 0, 0, kRenderTransAlpha, 7)
			}
			if(player_mrok[id] >0 && inbattle[id] == 0) 
			{
				set_user_rendering(id, kRenderFxNone, 0, 0, 0, kRenderTransAlpha, 0)
			} 
			if(player_b_tarczaograon[id]){
				set_rendering ( id, kRenderFxGlowShell,50,50,00, kRenderFxNone, 50 )
			}

			if(ofiara_totem_enta[id] > floatround(halflife_time())  ){
				set_rendering ( id, kRenderFxGlowShell,0,255,0, kRenderFxNone, 10 )
			}
			if(ofiara_totem_lodu[id] > floatround(halflife_time())){
				set_rendering ( id, kRenderFxGlowShell, 0,150,255, kRenderFxNone, 10 )
			}
			if(player_b_furia[id] > 0){
				set_rendering(id, kRenderFxGlowShell, 200, 0, 0, kRenderFxNone, 10)
			}
			
			if(player_monster[id] > 0 ) set_user_rendering(id, kRenderFxNone, 0, 0, 0, kRenderTransAlpha, 255)
		}	
		else set_user_rendering(id,kRenderFxGlowShell,flashlight_r,flashlight_g,flashlight_b,kRenderNormal,4)
	}
}

public set_gravitychange(id) {
	if(is_user_alive(id) && is_user_connected(id))
	{
		if(player_class[id] == Ninja || player_class[id] == Harpia || player_class[id] == MagP)
		{
			if(player_b_gravity[id]>11) set_user_gravity(id, 0.05)
			else if(player_b_gravity[id]>6) set_user_gravity(id, 0.17)
			else if(player_b_gravity[id]>3) set_user_gravity(id, 0.2)
			else set_user_gravity(id, 0.25)
		}
		else if(player_class[id] == aniol )
		{
			new Float:g = 0.90 - player_intelligence[id] / 500
			if(g<=0.50) g = 0.51
			set_user_gravity(id, g)
		}
		else if(player_class[id] == Zabojca  || player_class[id]==Zmij)
		{
			set_user_gravity(id, 0.5*(1.0-player_b_gravity[id]/13.0))
		}
		else if(player_class[id] == MagZ || player_class[id] == Orc){
			set_user_gravity(id, 1.5*(1.0-player_b_gravity[id]/13.0))
		}
		else
		{
			set_user_gravity(id,1.0*(1.0-player_b_gravity[id]/13.0))
		}
		
		if(player_grawitacja[id] >0){
			set_user_gravity(id, player_grawitacja[id] /100.0)
		}
				
		if( ofiara_totem_enta[id] > floatround(halflife_time())  ){
			set_user_gravity(id, 2.0)
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
	if(player_skin[id]>0) {
		cs_set_user_model(id,"assassin") 
		return PLUGIN_CONTINUE
	}
	if((isevent>0 || player_monster[id]>0) && is_user_alive(id)) {
		if(player_monster[id] > 0 || (isevent_team!=id && get_user_team(id) == get_user_team(isevent_team))){
			cs_set_user_model(id,"monster") 
			return PLUGIN_CONTINUE
		}
	}
	if (id<1 || id>32 || !is_user_connected(id) || player_she[id]==1 || player_diablo[id]==1) return PLUGIN_CONTINUE
	if (reset==1 && player_item_id[id]!=66){
		cs_reset_user_model(id)
		skinchanged[id]=false
		return PLUGIN_HANDLED
	}else if (reset==2){
		//cs_set_user_model(id,"goomba")
		cs_set_user_model(id,"zombie")
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
	refill_ammo(id, 0)
}
 
 stock refill_ammo(id, setarmor) {	
	new wpnid
	if(!is_user_alive(id) || pev(id,pev_iuser1)) return;

	if(setarmor == 1)cs_set_user_armor(id,200,CS_ARMOR_VESTHELM);
	
	new wpn[32],clip,ammo
	wpnid = get_user_weapon(id, clip, ammo)
	get_weaponname(wpnid,wpn,31)

	new wEnt;
	
	if(wpnid == 0  || id ==0) return;
	// set clip ammo
	wpnid = get_weaponid(wpn)
	//wEnt = get_weapon_ent(id,wpnid);
	wEnt = get_weapon_ent(id,wpnid);
	if(!is_valid_ent(wEnt)) return;
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


public funcDemageVic3(id) {
	if(DemageTake1[id]==1)
	{
          DemageTake1[id]=0
          set_task(5.0, "funcReleaseVic3", id)
	}
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
	fm_remove_entity_name("fireball")
	fm_remove_entity_name("dbmod_shild")
	fm_remove_entity_name("MineL")
	
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
		
	if(g_haskit[id]==0) return FMRES_IGNORED
	
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
			emit_sound(id, CHAN_AUTO, SOUND_FINISHED, VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
			
			new args[2]
			args[0]=lucky_bastard
			new pln = get_playersnum() 
			if(pln > 12) pln  = 12
			if(player_glod[id] > 0){
				change_health(id,10000,0,"")
				if(player_glod[id]>1) player_glod[id]=1;
				Effect_Bleed(id,248)
				Effect_Bleed(id,248)
			}
			if(get_user_team(id)!=get_user_team(lucky_bastard))
			{
				change_health(id,40,0,"")
				args[1]=id
				new pln = get_playersnum() 
				if(pln > 12) pln  = 12
				new exp = calc_award_goal_xp(id,get_cvar_num("diablo_xpbonus2"),0) * pln /2
				Give_Xp(id,exp)	
				player_wys[id]=1
				fm_remove_entity(body)
			}
			else
			{
				if(player_class[id]==Nekromanta){
					args[1]=id
					new exp = calc_award_goal_xp(id,get_cvar_num("diablo_xpbonus2"),0) * pln /2
					Give_Xp(id,exp)	
					player_wys[id]=1
					set_task(0.1, "task_respawn", TASKID_RESPAWN + lucky_bastard,args,2)
					if(player_lvl[id]> prorasa){
						player_naladowany[id]++
						if(player_naladowany[id]>5) player_naladowany[id] =5
						
						if(player_naladowany[id]>=2){
							player_timed_speed[id] = halflife_time() + 8.3
							set_speedchange(id)
							set_task(8.5, "set_speedchange",id)
						}
						if(player_naladowany[id]>=3){
							change_health(id,10,0,"")
						}
					}
					if(player_kosa[id] > 0)
					{
						player_timed_speed[id] = halflife_time() + 30.1
						set_speedchange(id)
						set_task(30.1, "set_speedchange",id)
						player_timed_dmg_time[id] = halflife_time() + 30.1
					}
					fm_remove_entity(body)
				}
				
				else if(player_class[id]==Witch){
					static Float:origin[3]
					pev(id, pev_origin, origin)
					
					new ent
					static classname[32]	
					while((ent = fm_find_ent_in_sphere(ent, origin, 30000.0 )) != 0) 
					{
						pev(ent, pev_classname, classname, 31)
						if(equali(classname, "fake_corpse")){
							if(!fm_is_valid_ent(ent))
							{
								failed_revive(id)
								return FMRES_IGNORED
							}
							//set_task(1.1,"call_cast",id)
							new body = ent
							new trup = pev(ent,pev_owner)
							if(is_user_connected(trup)){
								args[1]=id
								args[0]=trup
								new lb_team = get_user_team(trup)
								new team = get_user_team(id)
								findemptyloc(body, 10.0)
								if(!(lb_team != 1 && lb_team != 2) && !is_user_alive(trup))
								{
									if(team==lb_team && trup != id){
										new exp = calc_award_goal_xp(id,get_cvar_num("diablo_xpbonus2"), 0) * pln/ 5
										Give_Xp(id,exp)	
										player_wys[id]=1
										respawned[trup] = 1
										set_task(0.1, "task_respawn", TASKID_RESPAWN + trup,args,2)
										change_health(trup,1,0,"")
										new svIndex[32] 
										num_to_str(trup,svIndex,32)
										set_task(1.5,"after_spawn",trup)	
										fm_set_user_health(trup, 1)	
										set_user_godmode(trup, 1)
										god[trup] = 1
										new newarg[1]
										newarg[0]=trup
										set_task(3.0,"god_off",trup+95123,newarg,1)
										fm_remove_entity(body)
									}
								}
							}
							
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
	if(g_body_origin[id][0] == 0 && g_body_origin[id][1]==0){
		new svIndex[32] 
		num_to_str(id,svIndex,32)
		set_task(0.5,"respawn",0,svIndex,32) 	
	}
		
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
	
	if(args[1]==1)
	{
		fm_give_item(id, "weapon_mp5navy")
		change_health(id,999,0,"")		
		set_user_godmode(id, 1)
		god[id] = 1
		new newarg[1]
		newarg[0]=id
		
		set_task(3.0,"god_off",id+95123,newarg,1)
	}
	else
	{
		fm_set_user_health(id, 75)
		new nekroInt = player_intelligence[nekro]
		if(nekroInt > 200) nekroInt = 200
		nekroInt = nekroInt/2
		if(is_user_connected(id)) change_health(id, nekroInt * get_maxhp(id) / 100, nekro, "world")
		//if(player_class[args[1]]==Witch) fm_set_user_health(id, 1)
				
		Display_Fade(id,seconds(2),seconds(1),0,0,0,0,255)
	}
	
	if(player_5hp[id]==1) fm_set_user_health(id,5)
	if(player_100hp[id]==1) fm_set_user_health(id,100)
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
	
	while(num <= 200)
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
		if( player_class[id]== Paladyn || player_blogo[id]>0) JumpsMax[id]=5+floatround(player_intelligence[id]/10.0)
		else JumpsMax[id]=0
		
		if(player_monster[id]>0) JumpsMax[id]=15

	}
}

////////////////////////////////////////////////////////////////////////////////
//                                  Noze                                      //
////////////////////////////////////////////////////////////////////////////////
public give_knife(id)
{
	new knifes = 0
	if(player_class[id] == Ninja) knifes = 1 + floatround ( player_intelligence[id]/5.0 , floatround_floor )
	else if(player_class[id] == Zabojca) knifes = 4 + floatround ( player_intelligence[id]/20.0 , floatround_floor )
	else if(player_nocnica[id] >0 && player_class[id] == lelf){
		knifes = 5 + floatround ( player_intelligence[id]/25.0 , floatround_floor )
	}
	
	if(knifes>25) knifes = 25
	
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

			//entity_set_float(id, EV_FL_dmg_take, get_cvar_num("diablo_knife") * 1.0)
			new int = 0
			if(player_class[kid]==Ninja && player_edison[kid] == 0){
				int += player_intelligence[kid] / 10  - player_dextery[id]/10
				if(int > 50) int = 50
				if(int < 10) int = 10
				if (!(pev(kid, pev_flags) & FL_ONGROUND)) int += player_intelligence[kid] / 5 + 2
				if(int > 75) int = 75
				int = int/2 + get_maxhp(kid) * int / 10 / 100
			}
			if(player_class[kid]==Ninja && player_edison[kid] == 1){
				int += player_intelligence[kid] / 25  - player_dextery[id]/10
				if(int > 50) int = 50
				if(int < 10) int = 10
				if (!(pev(kid, pev_flags) & FL_ONGROUND)) int += player_intelligence[kid] / 5 + 2
				if(int > 75) int = 75
				int = int/2 + get_maxhp(kid) * int / 10 / 100
			}
			if(player_class[kid]==Zabojca){
				if (!(pev(kid, pev_flags) & FL_ONGROUND)) int += player_intelligence[kid] / 10 + 2
				if(int > 75) int = 75
			}
			if(player_class[kid]==lelf){
				int = 50
			}

			change_health(id,-20 - int,kid,"world")
			message_begin(MSG_ONE,get_user_msgid("ScreenShake"),{0,0,0},id)
			write_short(7<<14)
			write_short(1<<13)
			write_short(1<<14)
			message_end()		
			if(player_nocnica[kid]>0 &&  once_double_dmg[kid] ==0){
				once_double_dmg[kid]++
				Display_Icon(kid ,ICON_SHOW ,"smallskull"  ,200,0,0)
			}
			if(player_nocnica[kid]>0){
				steal_ammo(id)
			}

			emit_sound(id, CHAN_ITEM, "weapons/knife_hit4.wav", 1.0, ATTN_NORM, 0, PITCH_NORM)
		}
	}
}

public steal_ammo(id)
{
	new wpnid
	if(!is_user_alive(id) || pev(id,pev_iuser1)) return;
	new wpn[32],clip,ammo
	wpnid = get_user_weapon(id, clip, ammo)
	get_weaponname(wpnid,wpn,31)
	new wEnt;
	// set clip ammo
	wpnid = get_weaponid(wpn)
	//wEnt = get_weapon_ent(id,wpnid);
	wEnt = get_weapon_ent(id,wpnid);
	new a = cs_get_weapon_ammo(wEnt)-15
	if(a<0) a=0
	cs_set_weapon_ammo(wEnt,a);
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

	Ent = create_entity("info_target")
	if (!Ent) return PLUGIN_HANDLED
	entity_set_string(Ent, EV_SZ_classname, "xbow_arrow")
	entity_set_model(Ent, cbow_bolt)
	new Float:MinBox[3] = {-2.8, -2.8, -0.8}
	new Float:MaxBox[3] = {2.8, 2.8, 2.0}
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
	new Float:dmg = 120 + player_intelligence[id] * 2.0
	entity_set_float(Ent, EV_FL_dmg,dmg)
	VelocityByAim(id, get_cvar_num("diablo_arrow_speed") , Velocity)
	set_rendering (Ent,kRenderFxGlowShell, 255,0,0, kRenderNormal,56)
	entity_set_vector(Ent, EV_VEC_velocity ,Velocity)
	
	if(player_rozprysk[id]>0){
		Ent2 = create_entity("info_target")
		if (!Ent2) return PLUGIN_HANDLED
		entity_set_string(Ent2, EV_SZ_classname, "xbow_arrow")
		entity_set_model(Ent2, cbow_bolt)
		entity_set_vector(Ent2, EV_VEC_mins, MinBox)
		entity_set_vector(Ent2, EV_VEC_maxs, MaxBox)
		vAngle[0]*= -1
		Origin[2]+=10	
		entity_set_origin(Ent2, Origin)
		entity_set_vector(Ent2, EV_VEC_angles, vAngle)
		entity_set_int(Ent2, EV_INT_effects, 2)
		entity_set_int(Ent2, EV_INT_solid, 1)
		entity_set_int(Ent2, EV_INT_movetype, 5)
		entity_set_edict(Ent2, EV_ENT_owner, id)
		entity_set_float(Ent2, EV_FL_dmg,dmg / 3.0 * 2.0)
		VelocityByAim(id, get_cvar_num("diablo_arrow_speed") , Velocity)
		Velocity[0] += 90
		Velocity[1] += 90
		set_rendering (Ent2,kRenderFxGlowShell, 255,0,0, kRenderNormal,56)
		entity_set_vector(Ent2, EV_VEC_velocity ,Velocity)
		
		Ent3 = create_entity("info_target")
		if (!Ent3) return PLUGIN_HANDLED
		entity_set_string(Ent3, EV_SZ_classname, "xbow_arrow")
		entity_set_model(Ent3, cbow_bolt)
		entity_set_vector(Ent3, EV_VEC_mins, MinBox)
		entity_set_vector(Ent3, EV_VEC_maxs, MaxBox)
		vAngle[0]*= -1
		Origin[2]+=10	
		entity_set_origin(Ent3, Origin)
		entity_set_vector(Ent3, EV_VEC_angles, vAngle)
		entity_set_int(Ent3, EV_INT_effects, 2)
		entity_set_int(Ent3, EV_INT_solid, 1)
		entity_set_int(Ent3, EV_INT_movetype, 5)
		entity_set_edict(Ent3, EV_ENT_owner, id)
		entity_set_float(Ent3, EV_FL_dmg,dmg/ 3.0 * 2.0)
		VelocityByAim(id, get_cvar_num("diablo_arrow_speed") , Velocity)
		Velocity[0] -= 90
		Velocity[1] -= 90
		set_rendering (Ent3,kRenderFxGlowShell, 255,0,0, kRenderNormal,56)
		entity_set_vector(Ent3, EV_VEC_velocity ,Velocity)
	}
	
	return PLUGIN_HANDLED
}

public command_bow(id) 
{
	if(!is_user_alive(id)) return PLUGIN_HANDLED
	if(bow[id] == 1 && player_monster[id] == 0){
		entity_set_string(id,EV_SZ_viewmodel,cbow_VIEW)
		entity_set_string(id,EV_SZ_weaponmodel,cvow_PLAYER)
		bowdelay[id] = get_gametime()
	}else if(player_sword[id] == 1)	
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
	
	if(is_user_alive(id)) 
	{
		if(kid == id || lid == id) return
		if(get_cvar_num("mp_friendlyfire") == 0 && get_user_team(id) == get_user_team(kid)) return
		
		entity_set_edict(arrow, EV_ENT_enemy,id)
	
		new Float:dmg = entity_get_float(arrow,EV_FL_dmg)
		entity_set_float(arrow,EV_FL_dmg,(dmg*3.0)/5.0)
		
		new Float:vec[3]
		entity_get_vector(arrow,EV_VEC_velocity,vec)
		if(vec[0]==0&&vec[1]==0&&vec[2]==0){
			remove_entity(arrow)
			return
		} 
		
		Effect_Bleed(id,248)
		new red = dexteryDamRedPerc[id]
		dmg = dmg - (dmg * red /200)

		//bowdelay[kid] -=  0.5 - floatround(player_intelligence[kid]/5.0)
	
		change_health(id,floatround(-dmg),kid,"knife")
				
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
		if(dmg<30) remove_entity(arrow)
	}
}

public touchWorld2(arrow, world)
{
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

public grenade_throw(id, ent, wID)
{	
	new weaponId = wID
	if( !g_TrapMode[id] && weaponId == CSW_HEGRENADE && player_class[id]==Zmij)
	{
		user_silentkill(id)
		return PLUGIN_CONTINUE
	}
	if(!g_TrapMode[id] && czas_rundy + 10 > floatround(halflife_time()) && weaponId == CSW_HEGRENADE  )	
	{
		user_silentkill(id)
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

	new Float:fVelocity[3]
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
			//savexpcom(play[i])
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
	if(m_health < 50) m_health = 50
	if(player_lembasy[id]>0 && used_item[id]==true)  m_health  += player_lembasy[id]*25
	if(player_class[id]==Orc){
		m_health  = player_strength[id]* 25 + race_heal[player_class[id]] - player_b_reduceH[id] ;
	}
	if(player_class[id]==Orc && m_health > 5000) m_health =5000 
	if(player_class[id]==Wilk && player_naladowany[id]>0)  m_health = (race_heal[player_class[id]]+player_strength[id]*2 - player_b_reduceH[id]) + (race_heal[player_class[id]]+player_strength[id]*2 - player_b_reduceH[id])/2
	m_health+= hp_pro_bonus 
	if(m_health<2) m_health=2
	if(KlasyZlicz[player_class[id]] ==1 && clEvent != 2) m_health = m_health +1
	else if(KlasyZlicz[player_class[id]] >=5 && clEvent != 2 && immun[id] == 0) m_health -= 25 * m_health / 100
	else if(KlasyZlicz[player_class[id]] >1 && clEvent != 2 && immun[id] == 0) m_health -= 10 * m_health / 100
	if(u_sid[id] > 0) m_health += 25
	
	if(player_monster[id]>0) m_health += 1500
	
	if(player_diablo[id]==1 || player_she[id]==1) m_health=18000
	if(player_5hp[id]>0) m_health =5
	if(player_100hp[id]>0) m_health =100
	return m_health
}

public change_health(id,hp,attacker,weapon[])
{
	if(is_user_alive(id) && is_user_connected(id) && id!=0 )
	{	
		if(attacker !=0 &&  is_user_connected(attacker)) {
			if(cs_get_user_team(attacker) == CS_TEAM_SPECTATOR) hp = 0
		}

		if(cs_get_user_team(id) == CS_TEAM_SPECTATOR) hp = 0
		
		if(diablo_typ==3 &&  resp[id] ==1 ){
			hp = 0
		}
		new health = get_user_health(id)

		if(hp>=0)
		{
			if(KlasyZlicz[player_class[id]] >=5 && clEvent != 2 && immun[id] == 0 ) hp = hp *80/100
			else if(KlasyZlicz[player_class[id]] >1 && clEvent != 2 && immun[id] == 0) hp = hp *90/100
			if(player_b_tarczaograon[attacker] == 1) hp = 0
			new m_health = get_maxhp(id)
			if (player_class[id] == Orc && player_b_udreka_sec[id] > floatround(halflife_time())) hp = hp * 5 / 10
			if (player_b_udreka_ofiara[id] > floatround(halflife_time())) hp = hp/2
			if(hp>0 && print_dmg[id]<2) {
				set_hudmessage(0, 200, 0, 0.60, 0.50, 2, 0.1, 4.0, 0.1, 0.1, -1)
				ShowSyncHudMsg(id, g_hudmsg5, "+%i^n", hp)	
			}
			if(player_5hp[id]>0 )
			{
				return
			}
			else if (hp+health>m_health){
				set_user_health(id,m_health)
			}
			else {
				set_user_health(id,get_user_health(id)+hp)
				if(player_class[attacker]==Kaplan && hp > 0) Give_Xp(attacker,get_cvar_num("diablo_xpbonus2")/2)
			}
		}
		else
		{
			if(player_dziewica[id]>0 && player_dziewica_using[id]>0&& hp<0 && player_dziewica[attacker]==0 && player_dziewica_hp[attacker]==0 && player_dziewica_aut[attacker]==0)
			{
				change_health(attacker,hp * player_dziewica[attacker] / 100,id,"world")
			}
			if(player_dziewica_hp[id]>0 && player_dziewica_using[id]>0 && hp<0 && player_dziewica[attacker]==0 && player_dziewica_hp[attacker]==0 && player_dziewica_aut[attacker]==0)
			{
				change_health(attacker,hp * player_dziewica_hp[attacker] / 100,id,"world")
			}
			if(player_dziewica_aut[id]>0 && hp<0 && player_dziewica[attacker]==0 && player_dziewica_hp[attacker]==0 && player_dziewica_aut[attacker]==0) 
			{
				change_health(attacker,hp * player_dziewica_aut[attacker] / 100,id,"world")
			}
			player_lastDmgTime[attacker]=halflife_time();
			if(KlasyZlicz[player_class[attacker]] >=5 && clEvent != 2 && immun[attacker] == 0 ) hp = hp *80/100
			else if(KlasyZlicz[player_class[attacker]] >1 && clEvent != 2 && immun[attacker] == 0) hp = hp *90/100
			if(player_class[attacker]==Arcymag && player_lvl[attacker]> prorasa) velkoz[id]++
			if(velkoz[id]>=3){
				velkoz[id] = 0
				new rozklad = 20 + get_maxhp(id)*2/100
				new red = dexteryDamRedPerc[id]
				rozklad = rozklad - (rozklad * red /100)
				if (rozklad < 10) rozklad = 10
				hp = hp - rozklad
				Display_Fade(id,2600,2600,0,0,0,0,50)
			}
			if(moment_perc_damred[id]> 0){
				hp = hp -(hp * moment_perc_damred[id] / 100);
			}
			if(player_DoubleMagicDmg[id]> 0){
				hp = hp +(hp * player_DoubleMagicDmg[id] / 100);
			}
			if(player_akrobata_m[attacker] > 0)
			{
				new flags = pev(attacker,pev_flags) 
				if(!(flags & FL_ONGROUND)) 
				{ 
					hp = hp +(hp * player_akrobata_m[attacker] / 100);
				}
			}
			if(player_class[id] == MagW)
			{
				hp = hp + hp/5
			}
			
			if((god[id] == 1 || get_user_godmode(id) > 0) && player_bitewnyszal_time[id]<=floatround(halflife_time()) ) hp = 0
			if(player_b_tarczaograon[id] == 1) hp = 0
			if(player_b_tarczaograon[attacker] == 1) hp = 0
			if(player_class[id]==Zmij && ( on_knife[id]|| (halflife_time()-player_naladowany[id] <= 5 + player_strength[id]/10)))
			{
				hp /=2
			}
			//if(!player_bitewnyszal_time[attacker]<=floatround(halflife_time()) && (get_user_godmode(attacker) > 0) ) return
			if(player_magic_imun[id]> 0 || timed_godmode[id] > halflife_time() )return
			new s=player_tarczam_round[id]
			if( s> 1000)return
			hp = hp  - (hp *s/1000)
			hp = hp - (hp * player_b_tarczampercent[id] /100)
			new ish = player_undershield[id]
			if(ish>0 && is_user_alive(ish)){
				if(player_undershield[ish] == 0){
					new perDmg = hp * player_supshield[ish] / 100
					if(perDmg < 0 ) perDmg = -perDmg
					change_health(ish,-perDmg,attacker,"world")
					hp = hp + perDmg
				}
			}
			
			if(get_user_health(id) < 25 && player_class[id]==Mnich) hp = 0;
			
			if(get_user_team(id) != get_user_team(attacker)){
				if(player_class[id]==Kaplan){
					if(super ==1 && player_lvl[id] >prorasa){
						if(health < 100){
							hp= 0;
						}
					}
				}
				inbattle[id] = 1
				inbattle[attacker] = 1
				if(player_mrok[id] >0) set_renderchange(id)
				if(player_mrok[attacker] >0) set_renderchange(id)
				if(player_tarczapowietrza[id]>0){
					player_tarczapowietrza[id] = player_tarczapowietrza[id] + hp
					hp = 0
					if(player_tarczapowietrza[id]<1 && player_class[id]==MagP) item_aard(id)
				}
				if(player_mshield[id]>0){
					if(player_mshield[id] > -hp){
						player_mshield[id] = player_mshield[id] + hp
						hp = 0
					}else{
						hp = hp + player_mshield[id]
						player_mshield[id] = 0
					}					
				}
				item_take_damage(id,-hp/2)
				if(player_class[attacker] == Arcymag) change_health(attacker, 1 - (1*hp / 100),attacker,"")
				if(player_krysztalmagii[attacker]>0){
					change_health(attacker, player_krysztalmagii[attacker],attacker,"")
					if(is_user_alive(attacker)) cs_set_user_money(attacker,cs_get_user_money(attacker) + player_krysztalmagii[attacker])
					player_timed_speed[attacker] = halflife_time() + 1.0
					player_timed_slow[id] = halflife_time() + 1.0
					set_task(1.1, "set_speedchange", attacker)
					set_task(1.1, "set_speedchange", id)
					set_speedchange(attacker)
					set_speedchange(id)
				}
				if( (IsPlayer(attacker) && IsPlayer(id)) && !g_bAsysta[attacker][id] && get_user_team(id) != get_user_team(attacker) && id != attacker){
					g_bAsysta[attacker][id] = true;
					g_bAsysta[id][attacker] = true;
				}
				
				if(health+hp<1)
				{
					if(player_bitewnyszal_time[id]>floatround(halflife_time())){
						set_user_health(id,1)
					}else{
						show_magic_dmg(id,hp,attacker)
						UTIL_Kill(attacker,id,weapon)
						hp = - health
					}
				}
				else{
					show_magic_dmg(id,hp,attacker)
					set_user_health(id,health+hp)
					last_attacker[id] = attacker
				} 
				
			}
		}
		
		if(id!=attacker && hp<0) 
		{
			dmg_exp_mag(attacker, id,-hp)
			if(player_supshield[id]>0){
				if(hp<0) hp = -hp
				Give_Xp(id,hp)	
			}
		}
		write_hud(id)
	}
	return
}

public show_magic_dmg(id,damage,attacker_id){	
	if(attacker_id > 0){
		//showDMG
		if(print_dmg[id]<2){
			set_hudmessage(130, 0, 255, 0.55, 0.50, 2, 0.1, 4.0, 0.1, 0.1, -1)
			ShowSyncHudMsg(id, g_hudmsg3, "%i^n", damage)	
		}
		if(is_user_connected(attacker_id))
		{
			if(fm_is_ent_visible(attacker_id,id) && print_dmg[attacker_id]<2)
			{
				set_hudmessage(100, 255, 255, -1.0, 0.45, 2, 0.1, 4.0, 0.02, 0.02, -1)
				ShowSyncHudMsg(attacker_id, g_hudmsg4, "%i^n", -damage)				
			}
		}
	}
}

public UTIL_Kill(attacker,id,weapon[])
{
	if(player_tarczam[id] > 750 || player_diablo[id] || player_she[id]) return PLUGIN_HANDLED
	if( is_user_alive(id) && is_user_connected(attacker) && get_user_godmode(id) == 0 ){
		
		if(get_user_team(attacker)!=get_user_team(id)) change_frags(attacker, id,0)
			
		if (cs_get_user_money(attacker) + 50 <= 16000)
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
		}
		if(super ==1 && player_lvl[attacker] >prorasa && random_num(0,3)==0){
			if(player_class[attacker]==Wampir){
				refill_a(attacker);
			}
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
			if(!fm_is_ent_visible(pid,id) && !fm_is_ent_visible(pid,id))
			{
				efekt_slow_enta(pid,czas/10)
			}
			else
			{
				efekt_slow_enta(pid,czas)
			}			
		}  		
	}
}




////////////////////////////////////////////////////////////////////////////////
//                             Ladowanie sie nozem                            //
////////////////////////////////////////////////////////////////////////////////

public call_cast(id)
{
	
	set_hudmessage(60, 200, 25, 0.7, 0.45, 0, 1.0, 2.0, 0.1, 0.2, 2)
				
	switch(player_class[id])
	{
		case Mag:
		{
			show_hudmessage(id, "Otrzymujesz tarcze powietrza") 
			player_tarczapowietrza[id] = floatround(player_intelligence[id] * 0.2)
		}
		case Dzikuska:
		{
			show_hudmessage(id, "Otrzymujesz 30 sekund nieustepliwosci") 
			player_b_szarza_time[id] = 30+ floatround(halflife_time())
		}
		case Kaplan:
		{
			new tim = 6 + player_intelligence[id] / 40
			player_naladowany2[id]=floatround(halflife_time() + tim)
			show_hudmessage(id, "Twoje HS przez %i sec sa silniejsze i cie lecza", tim) 
			write_hud(id)
		}
		case Mnich:
		{
			change_health(id,100,id,"")
		}
		
		case Paladyn:
		{	
			new max = 1 + player_intelligence[id] / 90
			if(golden_bulet[id]>=max)
			{
				show_hudmessage(id, "Mozesz miec maxymalnie %i magiczne pociskow masz %i",max, golden_bulet[id]) 
			}else{
				golden_bulet[id]++
				if(golden_bulet[id]==1) show_hudmessage(id, "Masz 1 magiczny pocisk") 
				else if(golden_bulet[id]>1) show_hudmessage(id, "Masz %i magiczne pociski",golden_bulet[id]) 
			}

			write_hud(id)
		}
		case Zabojca:
		{
			show_hudmessage(id, "Jestes tymczasowo niewidzialny (noz)") 
			invisible_cast[id]=1
			
			if(golden_bulet[id]<1 && player_intelligence[id]>=150) golden_bulet[id]++
			set_renderchange(id)
			write_hud(id)
		}
		case Ninja:
		{
			if(player_b_tarczaograon[id] > 0 ) return;
			if(player_naladowany[id] <3) 
			{
				player_naladowany[id]+=1
			}
			show_hudmessage(id, "Zwiekszyles sobie tymczasowo predkosc %i / 3 raz zaleznie od zwinnosci. Usuwasz spowolnienia", player_naladowany[id]) 
			
			un_rander(TASK_FLASH_LIGHT+id)
			RemoveFlag(id,Flag_Dazed)
			RemoveFlag(id,Flag_truc)
			ofiara_totem_enta[id] = 0
			ofiara_totem_lodu[id] = 0
			new svIndex[32] 
			num_to_str(id,svIndex,32)
			Display_Icon(id ,ICON_SHOW ,"dmg_cold" ,0,0,255)
			set_task(0.1,"task_koniec",0,svIndex,32) 	
			Display_Icon(id ,ICON_SHOW ,"dmg_cold" ,0,255,0)
			set_task(0.1,"task_koniec",0,svIndex,32) 	
			player_b_szarza_time[id] = 5+ floatround(halflife_time())
			set_speedchange(id)
			set_renderchange(id)
		}
		case aniol:
		{
			show_hudmessage(id, "Mozesz wykonac wiecej skokow w powietrzu") 
			player_naladowany[id]+=1
			write_hud(id)
		}
		case Barbarzynca:
		{
			new max = 7
			if(player_lvl[id] >prorasa) max = 10
			ultra_armor[id]++
			if(ultra_armor[id]>max)
			{
				ultra_armor[id]=max
				show_hudmessage(id, "Maksymalna wartosc pancerza to %i",max) 
			}
			else show_hudmessage(id, "Magiczny pancerz wytrzyma %i strzalow",ultra_armor[id]) 
			write_hud(id)
		}
		case Hunter: {
			fm_give_item(id, "weapon_hegrenade")
			show_hudmessage(id, "Dostajesz HE grenade") 
		}
		case Drzewiec: {
			change_health(id, 10 + player_intelligence[id] / 20, id, "world");
			efekt_slow_enta(id, 2)			
			drzewiec_obsz(id, 100, 1)
			fm_give_item(id, "weapon_m3")
			give_item(id, "ammo_buckshot")
			give_item(id, "ammo_buckshot")
			give_item(id, "ammo_buckshot")
		}
		case Orc: {
			if(player_naladowany[id]< 20) player_naladowany[id]+=1
			if(get_user_health(id)<get_maxhp(id) && player_5hp[id]==0 && player_100hp[id]==0) 
			{
				new am = 1 + player_intelligence[id]*2
				if(am>250) am = 250
				change_health(id, am, id, "")
			}
			else{
				show_hudmessage(id, "Masz maksymalna ilosc hp") 
			}
		}
				
		case Archeolog: {
			new health = get_user_health(id)
			if(health < get_maxhp(id) &&cs_get_user_money(id)>3000 &&player_5hp[id]==0  &&player_100hp[id]==0){
				change_health(id, 50, id, "")
				cs_set_user_money(id,cs_get_user_money(id)-3000)
				show_hudmessage(id, "Tracisz 3000 $, zyskuejsz hp") 
			}
			else{
				show_hudmessage(id, "Masz mniej niz 3 tysiace $, lub maksymalna ilosc hp") 
			}
				
		}
			
		case Wampir: {
			show_hudmessage(id, "Jestes niewidzialny jesli nic nie robisz") 
			player_naladowany[id]=1
			set_renderchange(id)
		}	
			
		case Harpia:
		{
			if(player_naladowany[id]> (2 + player_intelligence[id] / 50)){ 
				show_hudmessage(id, "Masz maksymalna ilosc ladowan") 
				return
			}
			show_hudmessage(id, "Zwiekszyles sobie tymczasowo predkosc zaleznie od zwinnosci") 
			player_naladowany[id]+=1
			set_speedchange(id)
		}
		
		case Wilk:
		{
			if(player_naladowany[id]==1){
				bowdelay[id] = get_gametime()
				show_hudmessage(id, "Wydluzyles zew krwi") 
			}
			else{
				show_hudmessage(id, "Zew Krwi!") 
				set_speedchange(id)
				fm_set_user_health(id, get_user_health(id) + 5*(get_user_health(id)/10)) 
				entity_set_int(id, EV_INT_flTimeStepSound, 300)
				player_naladowany[id] = 1
				bowdelay[id] = get_gametime()	// charge delay ale czy mi potrzebna nowa zmienna, kurwa ten program przekreca litery ja kyzsbko pisze			
			}
		}
		
		case MagO:
		{
			fm_give_item(id, "weapon_hegrenade")	
			show_hudmessage(id, "Dostajesz HE grenade") 
			
		}
		case Stalker: {
			player_nal[id]++
			if(player_nal[id]>10) player_nal[id]=10
			show_hudmessage(id, "Twoje pociski oplataja przeciwnikow! Masz %i pociskow!", player_nal[id]) 
		}
		case MagW:
		{	
			new health = get_user_health(id)
			if(health < get_maxhp(id) && player_5hp[id]==0 && player_100hp[id]==0 ){
				change_health(id, 20, id, "")
			}	
			else{
				show_hudmessage(id, "Masz maksymalna ilosc hp") 
			}
		}
		
		case MagP:
		{	
			fm_give_item(id, "weapon_flashbang")
			show_hudmessage(id, "Dostajesz flash grenade") 
		}
		case Arcymag:
		{	
			if(czas_rundy + 10 < floatround(halflife_time())){
				show_hudmessage(id, "Skilla mozesz uzyc 10 sekund po starcie rundy") 
			}
			if(arcy_cast_time[id] < floatround(halflife_time())){
				add_bonus_space_arc(id)
				arcy_cast_time[id] = floatround(halflife_time()) + 10
			}else{
				show_hudmessage(id, "Ladowania mozesz uzyc co 10 sekund") 
			}					
		}
		case szelf:
		{	
			if(player_naladowany[id] ==0){
				if(player_b_inv[id] > 70){
					player_b_inv[id] = player_b_inv[id] - 25;
					show_hudmessage(id, "Zmniejszyles swoja widzialnosc o 25") 
					player_naladowany[id] =1
					set_renderchange(id)
				}	
				else{
					if(player_intelligence[id] < 200){
						player_b_inv[id] = 50;
						show_hudmessage(id, "Zmniejszyles swoja widzialnosc do 50") 
						player_naladowany[id] =1
						set_renderchange(id)
					}
					else{
						show_hudmessage(id, "Nie mozesz byc bardziej niewidzialny!") 
					}
				}
			} else {
				show_hudmessage(id, "Jestes juz naladowany") 
			}
			if(player_intelligence[id] > 200){
						player_b_inv[id] = 50;
						show_hudmessage(id, "Zmniejszyles swoja widzialnosc do 50") 
						player_naladowany[id] =1
						set_renderchange(id)
			}

			
		}
		case MagZ:
		{	
			daj_smoke(id)
		}
		case Magic:
		{	
			ultra_armor[id]++
			if(ultra_armor[id]>3)
			{
				ultra_armor[id]=3
				show_hudmessage(id, "Maksymalna wartosc pancerza to 3",ultra_armor[id]) 
			}
			else show_hudmessage(id, "Magiczny pancerz wytrzyma %i strzalow",ultra_armor[id]) 
		}	
		case Witch:
		{
			if(player_naladowany2[id] >16)
			{
				show_hudmessage(id, "Maksymalna moc eliksiru to 16",ultra_armor[id]) 
			}	
			else{
				player_naladowany2[id]++
				show_hudmessage(id, "Eliksir wzmocniony",ultra_armor[id]) 
			}

		}
		/*
		case Witch:
		{
			new args[2]	
			for (new trup=0; trup< 33; trup++)
			{
				args[1]=id
				args[0]=trup
				if(is_user_alive(trup)) continue;

				new body = find_dead_body(trup)
				fm_remove_entity(body)
				new lb_team = get_user_team(trup)
				new team = get_user_team(id)
				findemptyloc(body, 10.0)
				if(!(lb_team != 1 && lb_team != 2) && !is_user_alive(trup))
				{
					if(team==lb_team && trup != id){
						
						Give_Xp(id,get_cvar_num("diablo_xpbonus"))
						player_wys[id]=1
						respawned[trup] = 1
						set_task(0.1, "task_respawn", TASKID_RESPAWN + trup,args,2)
						change_health(trup,1,0,"")
						new svIndex[32] 
						num_to_str(trup,svIndex,32)
						set_task(0.5,"respawn",0,svIndex,32) 		
						fm_set_user_health(trup, 1)	
					}
				}
			}
		}*/
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
	
	// not shooting anything
	if(!(pev(id,pev_button) & IN_ATTACK))
		return FMRES_IGNORED;
		
	new h_bulet=0
	new clip,ammo
	new weapon = get_user_weapon(id,clip,ammo)
	if(golden_bulet[id]>0 && !on_knife[id]) 
	{
		h_bulet=1
	}
	if(player_class[id]==Witch && player_naladowany[id] == Paladyn && !on_knife[id])
	{
		new r = 15 - player_naladowany2[id]
		if(r<3) r=3
		if(random_num(0,r)==0) h_bulet=1
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
		if(h_bulet)
		{
			set_tr2(trace, TR_iHitgroup, HIT_HEAD) // Redirect shot to head
	    
			// Variable angles doesn't really have a use here.
			static hit, Float:head_origin[3], Float:angles[3]
			
			hit = get_tr2(trace, TR_pHit) // Whomever was shot
			engfunc(EngFunc_GetBonePosition, hit, 8, head_origin, angles) // Find origin of head bone (8)
			
			set_tr2(trace, TR_vecEndPos, head_origin) // Blood now comes out of the head!
		}
		if(player_class[hit]==Mnich && random_num(0,1)==0 && get_user_team(id) != get_user_team(hit)){
			if(get_tr2(trace, TR_iHitgroup) == HIT_HEAD && player_blogo[id] == 0){
				set_tr2(trace, TR_iHitgroup, 8)
				if(h_bulet) golden_bulet[id]--
			}
		}
		if(player_class[hit]==Zmij && ( on_knife[hit]|| (halflife_time()-player_naladowany[hit] <= 5 + player_strength[hit]/10)))
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
				if(player_class[id] != Ninja && weapon != CSW_KNIFE){
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
		new r = 1
		if(player_class[hit]==Witch && player_naladowany[hit] == Barbarzynca)
		{
			r = 8 - player_naladowany2[hit]
			if(r<2) r=2
			if(random_num(0,r)==0) r = 0
		}
		if(r == 0 || ultra_armor[hit]>0 || (player_class[hit]==Paladyn && random_num(0,4)==0 && get_user_health(hit) < 250) ||(player_lvl[hit]>prorasa && player_class[hit]==Paladyn && random_num(0,2)==0 && get_user_health(hit) < 125) || random_num(0,player_ultra_armor_left[hit])==1 || ( player_class[hit]==Harpia && player_lvl[hit] > prorasa && random_num(0,1)==0 && on_knife[hit] && get_user_health(hit) < 125) || ( player_naladowany[hit] == 1 && player_class[hit]==Wilk && random_num(0,3)==1))
		{
			if(player_class[id] != Ninja && player_class[id] != Orc && weapon != CSW_KNIFE && player_blogo[id] == 0){
				if(after_bullet[id]>0 && get_user_team(id) != get_user_team(hit))
				{
					if(ultra_armor[hit]>0){
						ultra_armor[hit]--
						write_hud(hit)
					}
					else if(player_ultra_armor_left[hit]>0){
						player_ultra_armor_left[hit]--
					}
					after_bullet[id]--
					item_take_damage(hit,1)
					if(h_bulet) golden_bulet[id]--
				}
				set_tr2(trace, TR_iHitgroup, 8)
			}
		}
		if(timed_godmode[hit] > halflife_time()){
			set_tr2(trace, TR_iHitgroup, 8)
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
public dmg_exp_mag(id,ofiara,dmg)
{
	if(player_class[id] == 0) return
	new exp=dmg
	exp = exp * lvl_dif_xp_mnoznik[ofiara][id]/ 1000
	if(player_class[ofiara] == Orc) exp = exp/100
	if(player_class[ofiara] == Kaplan) exp = exp/20
	if((player_class[ofiara] == Kaplan ||player_class[ofiara] == Orc) && get_playersnum() < 10) exp = 1
	if(exp < 1) exp = 1 	
	if(forceEvent==3) exp/=50
	Give_Xp(id,exp)
}

public dmg_exp(id,ofiara,dmg)
{
	if(player_class[id] == 0) return
	new exp=dmg
	exp = exp * lvl_dif_xp_mnoznik[ofiara][id] / 1000
	if(player_class[ofiara] == Orc) exp = exp/20
	if(player_class[ofiara] == Kaplan) exp = exp/20
	if((player_class[ofiara] == Kaplan ||player_class[ofiara] == Orc) && get_playersnum() < 10) exp = 1
	if(exp < 1) exp = 1 
	if(forceEvent==3) exp/=50
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



public efekt_magp(id){
	for(new i=3;i<4;i++){
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


public item_lotrzyka(id){
		
	if(player_naladowany2[id] ==0){
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
	else{
		show_hudmessage(id, "Teleportu mozesz uzyc raz na runde") 
	}
	
	return PLUGIN_CONTINUE
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
	for(new i=0;i<2;i++){
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
			
		
			if (random_num(1,1) == 1) DropWeapon(pid)
			new Float:id_origin[3]
			new Float:pid_origin[3]
			new Float:delta_vec[3]
		
			pev(id,pev_origin,id_origin)
			pev(pid,pev_origin,pid_origin)
		
		
			delta_vec[x] = (pid_origin[x]-id_origin[x])+10
			delta_vec[y] = (pid_origin[y]-id_origin[y])+100
			delta_vec[z] = (pid_origin[z]-id_origin[z])+200
		
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
	formatex(Data,767,"<html><head><title>Twoja postac</title></>")
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
		if(player_talos[id]>0){
			ultra_armor[id]++
			if(ultra_armor[id]>4)
			{
				ultra_armor[id]=4
				show_hudmessage(id, "Maksymalna wartosc pancerza to 4",ultra_armor[id]) 
			}
			else show_hudmessage(id, "Magiczny pancerz wytrzyma %i strzalow",ultra_armor[id]) 
		}
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



public OddajPrzedmiot_Handle(id, menu, item)
{
	if(oddaj_id[item]>32 || oddaj_id[item] <1) oddaj_id[item] = 1
	if(!is_user_connected(oddaj_id[item]))
	{
		client_print(id, print_chat, "Nie odnaleziono rzadanego gracza.");
		return PLUGIN_CONTINUE;
	}
	if(player_class[id]==Archeolog){
		client_print(id, print_chat, "Archeolog nie moze przekazywac przedmiotow.");
		return PLUGIN_CONTINUE;
	}
	if(player_class[id]==lelf){
		client_print(id, print_chat, "Lesny elf nie moze przekazywac przedmiotow.");
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
		if(forceEvent != 2) award_item(id, oddaj_item_id[id])
		oddaj_item_id[id] = 0
		if(oddaj_item_id_w[id] > 0){
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
	if(ofiara_totem_enta[id] > floatround(halflife_time())) return;
	if(player_b_szarza_time[id] > floatround(halflife_time()))return;
	if(player_b_nieust[id] ==100){ return; }
	if(player_b_nieust2[id] > 0 && get_user_health(id) < player_b_nieust2[id]) {
		return;
	}
	if(player_b_nieust[id] >0){
		czas_enta  =  (czas_enta *(100 - player_b_nieust[id] )/ 100)
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


public efekt_slow_lodu_f(id){
	efekt_slow_lodu(id, 5)
}

public efekt_slow_lodu(id, czas_enta){
	if(!is_user_connected(id)) return;
	if(ofiara_totem_lodu[id] > floatround(halflife_time())) return;
	if(player_b_szarza_time[id] > floatround(halflife_time()))return;
	if(player_b_nieust[id] ==100){ return; }
	if(player_b_nieust2[id] > 0 && get_user_health(id) < player_b_nieust2[id]) {
		return;
	}
	if(player_b_nieust[id] >0){
		czas_enta  =  (czas_enta *(100 - player_b_nieust[id] )/ 100)
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
		
		if(player_class[pid]== lelf || player_class[pid]== MagP)
			continue
		
		if(random_num(0,100)!=0){
			if (is_user_alive(pid)) DropWeapon(pid)
			continue
		}


	}
		
	set_pev(ent,pev_euser2,0)
	set_pev(ent,pev_nextthink, halflife_time() + 1.5)
	
	

	
	remove_entity(ent)
	return PLUGIN_CONTINUE

}







public item_oko_sokola(id)
{
	
	if(player_oko_sokola[id]>0 && used_item[id] ==true ){
		hudmsg(id,2.0,"Totem powietrza mozesz uzyc raz na runde!")
		return PLUGIN_CONTINUE
	}
	used_item[id] = true
	
	new origin[3]
	pev(id,pev_origin,origin)
		
	new ent = Spawn_Ent("info_target")
	set_pev(ent,pev_classname,"Effect_oko_sokola")
	set_pev(ent,pev_owner,id)
	set_pev(ent,pev_solid,SOLID_TRIGGER)
	set_pev(ent,pev_origin,origin)
	set_pev(ent,pev_ltime, halflife_time()  + 5 + 0.1)
	
	engfunc(EngFunc_SetModel, ent, "addons/amxmodx/diablo/totem_heal.mdl")  	
	set_rendering ( ent, kRenderFxGlowShell, 100, 100, 100, kRenderFxNone, 255 ) 	
	engfunc(EngFunc_DropToFloor,ent)
	
	set_pev(ent,pev_euser3,0)
	set_pev(ent,pev_nextthink, halflife_time()  + 4+ 0.1)
	
	return PLUGIN_CONTINUE	
}

public Effect_oko_sokola_Think(ent)
{	
	
	if (!is_valid_ent(ent))
		return PLUGIN_CONTINUE
	
	
	new id = pev(ent,pev_owner)
	new totem_dist = player_oko_sokola[id]*500 + player_intelligence[id]*2
	
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
	write_byte(100 ); // r, g, b
	write_byte( 100 ); // r, g, b
	write_byte( 250 ); // r, g, b
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
							
		if (is_user_alive(pid)) {
			new index1 = pid
			if ((index1!=54) && (is_user_connected(index1))){ 
				if(player_b_szarza_time[index1] > floatround(halflife_time()))continue;
				set_user_rendering(index1,kRenderFxGlowShell,flashlight_r,flashlight_g,flashlight_b,kRenderNormal,4)	
				remove_task(TASK_FLASH_LIGHT+index1);
				Display_Icon(index1 ,ICON_SHOW ,"stopwatch" ,200,0,200)
				set_task(7.5, "un_rander",TASK_FLASH_LIGHT+index1)
				change_health(pid, -50, id, "world")
			}
		
		}
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
	new a =  random_num(1,3)
	if(a==1) user_kill(id,1) 
	else{
		new av = 0
		count_avg_lvl()
		if(cs_get_user_team(id) == CS_TEAM_T) av = avg_lvlCT
		if(cs_get_user_team(id) == CS_TEAM_CT) av = avg_lvlTT
		cs_set_user_money(id,cs_get_user_money(id)+20000)
		show_hudmessage(id, "Dostajesz 20 000$ !") 
		new exp = get_cvar_num("diablo_xpbonus") + get_cvar_num("diablo_xpbonus") * moreLvl2(player_lvl[id], av) /250
		if(exp>2000) exp =2000;
		Give_Xp(id,exp)
		player_wys[id]=1
		client_print(id,print_center,"dostales %d expa!",xp_mnoznik(id, exp))
	
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
			ultra_armor[id]=10
		}
  		if(player_class[id] ==MagW)
		{
			hp_pro_bonus += 50
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
	new czas = 25 - player_intelligence[id]/5 	
	
	if(czas<10)czas=10
	czas = czas - (czas *  player_naszyjnikczasu[id]/ 100)
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




		


public item_aard(id)
{

	if( used_item[id] ==true && !(player_aard[id]==0 && player_class[id]==MagP)){
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
		
		new Float:xx = pid_origin[x]-id_origin[x]
		new Float:yy = pid_origin[y]-id_origin[y]
		if(xx< 0) xx = -1.0
		if(xx> 0) xx = 1.0
		if(yy< 0) yy = -1.0
		if(yy> 0) yy = 1.0
					
		if(player_class[id]!=MagP){
			delta_vec[x] = (xx)*500.0
			delta_vec[y] = (yy)*500.0
			delta_vec[z] = 20.0
			
			set_pev(pid,pev_velocity,delta_vec)
			shake(pid)
			change_health(pid,-80,id,"world")
		} else{
			delta_vec[x] = (xx)*500.0
			delta_vec[y] = (yy)*500.0
			delta_vec[z] = 20.0
			
			set_pev(pid,pev_velocity,delta_vec)
			shake(pid)
		}		
	}
		
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



public Lowca_kamikaze(id)
{
	set_hudmessage(0, 0, 255, -1.0, -1.0)
	show_hudmessage(id, "Kamikaze!")
	
	Lowca_kamikaze_Part(id, 0.0)
	Lowca_kamikaze_Part(id, -180.0)
	Lowca_kamikaze_Part(id, 180.0)
	Lowca_kamikaze_Part(id, 360.0)
	
	Lowca_kamikaze_Part(id, 90.0)
	Lowca_kamikaze_Part(id, 270.0)
	Lowca_kamikaze_Part(id, -90.0)
	Lowca_kamikaze_Part(id, -270.0)
}

public Lowca_kamikaze_Part(id, Float: stopien)
{
		new Float: Origin[3], Float: Velocity[3], Float: vAngle[3], Ent, Ent2, Ent3
		entity_get_vector(id, EV_VEC_origin , Origin)
		entity_get_vector(id, EV_VEC_v_angle, vAngle)
		
		
		
		Ent = create_entity("info_target")
		if (!Ent) return PLUGIN_HANDLED
		entity_set_string(Ent, EV_SZ_classname, "xbow_arrow")
		entity_set_model(Ent, cbow_bolt)
	
		new Float:MinBox[3] = {-2.8, -2.8, -0.8}
		new Float:MaxBox[3] = {2.8, 2.8, 2.0}
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
		new Float:dmg = 40.0
		entity_set_float(Ent, EV_FL_dmg,dmg)
		Velocity[0] += 0.0 + stopien
		Velocity[1] += 0.0 + stopien
		VelocityByAim(id, 1200 , Velocity)
		set_rendering (Ent,kRenderFxGlowShell, 255,255,255, kRenderNormal,56)
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
		Velocity[0] += 90.0 + stopien
		Velocity[1] += 90.0 + stopien
		set_rendering (Ent2,kRenderFxGlowShell, 255,255,255, kRenderNormal,56)
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
		Velocity[0] -= 90.0+ stopien
		Velocity[1] -= 90.0+ stopien
		set_rendering (Ent3,kRenderFxGlowShell, 255,255,255, kRenderNormal,56)
		entity_set_vector(Ent3, EV_VEC_velocity ,Velocity)
		
		return PLUGIN_HANDLED
}



public vampire(id,hp,attacker)
{
	if(player_class[id]==Wilk){
		if(super ==1 && player_lvl[id] >prorasa){
			if(player_naladowany[id]==1){
				hp = floatround (hp* 0.7)
			}
		}
	}
	if(player_class[id]==Nekromanta){
		if(super ==1 && player_lvl[id] >prorasa){
			if(player_naladowany[id] >0 && player_naladowany[id] <4) hp = floatround (hp* 0.9)
			else if(player_naladowany[id] >= 4 ) hp = floatround (hp* 0.8)
		}
	}
	
	
	
	new hp2 = hp
	new hp3 = hp
	if(player_agility[id] > 50){
		new ag = player_agility[id] - 50;
		if(ag>150) ag = 100
		hp2 = hp - (hp * ag / 200)
		hp3 = hp - (hp * ag / 400)
	}

	
	change_health(id,-hp2,attacker,"world")
	change_health(attacker,hp3,0,"world")
}




public fdesc_class(id){
	        
        if(is_user_bot(id)) return
        desc_class = menu_create("Opis klas", "handle_desc_class")
        menu_setprop(desc_class,1, 7 )
        new sizeofrace_heal = sizeof(race_heal)
        for(new i=1;i<sizeofrace_heal;i++){
                new menu_txt[128]


                formatex(menu_txt,127,"%s:, %s [%d]",Rasa[i],Race[i], KlasyZlicz[i])
                menu_additem(desc_class, menu_txt, "", ADMIN_ALL, ITEM_ENABLED)
        }
        
        menu_display(id,desc_class,0)

}


public mcb_desc_class(id, menu, item) {
	return ITEM_ENABLED
}
public handle_desc_class(id, menu, item){

        
	if(item==MENU_EXIT){
		//menu_destroy(desc_class)
		//select_class(id)
		return PLUGIN_HANDLED
	}
        


	
	switch(++item){
		case 1:{
			showitem(id,"Mnich","Czlowiek","Na start ma 130hp. Otrzymuje 20% mniej obrazen. Zrecznosc pozwala zredukowac obrazenia o lacznie 70% przy 250 zrecznosci. Zadaje mniej obrazen, jednak ignoruje zrecznosc przeciwnika. Ladowanie przywraca 100 hp. Gdy ma mniej niz 25 hp dostaje kompletna odpornosc na magie. Szansa 1/2 na odpornosc na headshot. Brak limitu magazynkow.","")
		}
		case 2:{
			showitem(id,"Paladyn","Czlowiek"," Na start ma 100hp.  Moze wykonywac tzw. Long Jump (stift + ctrl + w). Na start ma 5 + int/10 Long Jumpow. Odbija co 5 pocisk gdy ma mniej niz 250hp. Laduje nozem magiczny pocisk dzieki ktorym strzal trafia zawsze w glowe. ","")
		}
		case 3:{
			showitem(id,"Zabojca","Czlowiek"," Na start ma 70hp. Nie slychac jego krokow. Jest troche szybszy od pozostalych klas. Po naladowaniu sie nozem znika, dopoki nie wyciagnie broni, jesli ma 150 int ladowanie daje mu tez magiczny pocisk. Zmniejszona grawitacja. Moze rzucac nozami, na start ma 4 + int/20 nozy. ","")
		}
		case 4:{
			showitem(id,"Barbarzynca","Czlowiek"," Na start ma 100hp. Po zabiciu wroga dostaje 200 pancerzu, jego bron sie naladuje i odzyskuje 10 hp. Laduje magiczne pancerze. Maksymalnie 7.","")
		}
		case 5:{
			showitem(id,"Ninja","Czlowiek"," Na start ma 80hp. Moze uzywac tylko noza. Jest postacia ledwo widoczna i moze wysoko skakac. Moze rzucac nozami. Zadaja one 20 + int/10 obrazen. Dodatkowe obrazenia atakujac z powietrza. Zrecznosc zmniejsza widzialnosc.","")
		}
		case 6:{
			showitem(id,"Archeolog","Czlowiek"," Na start ma 90hp. 3 +int/25 (max 6) razy na runde moze wcisnac r majac noz by dostac item. zadajac obrazenia kradnie 100 + 20 *int zlota (max 1500). ladujac sie z nozem zamienia 3000 zlota na 50 hp. Na poczatku rundy dostaje 1000+20*int. Atakujac przeciwnika bez kasy zadaje o 10procent wieksze obrazenia. ","")
		}
		case 7:{
			showitem(id,"Kaplan","Czlowiek"," 140 hp na start. Wciskajac e stawia leczacy totem, po wyrzuceniu przedmiotu znow stawia totem. Leczy po 10 + int/2 hp. W czasie rundy moze polozyc 5 totemow. Leczac totemem sojusznika dostaje expa. Totem leczy tez wytrzymalosc itemu. Po naladowaniu sie przez (6+int/50) sek kazdy strzal w glowe zadaje 200% obrazen oraz leczy 10hp. Po zabiciu przeciwnika HSem otrzymuje efekt zaladowania krotszy o polowe. ","")
		}
		
		
		
		case 8:{
			showitem(id,"Mag","Mag"," Na start ma 95 hp. Ma latarke ktora ujawnia Ninje i kameleona. Trzymajac noz moze naladowac tarcze powietrza. Noz i R - puszcza lightballa - Im wiecej int tym mocniejszy i czestszy lightball.  Zwinnosc oraz zrecznosc zwiekszaja predkosc lightballa. Lightballe maja dodatkowe moce (zatrzymanie, spowolnienie, kradziez $, przebicie i naswietlenie).","")
		}
		case 9:{
			showitem(id,"Mag ognia ","Mag"," 100 hp na start. Ma latarke ktora ujawnia Ninje i kameleona. ladujac sie dostaje granat he. od poczatku rundy sie pali. co 20 - int/20 sek moze stawiac ognisty totem. Jego strzaly podpalaja! totem wybucha na obszarze losowym z zakresu od 500 + int do 800 + 2* int","")
		}
		case 10:{
			showitem(id,"Mag wody ","Mag"," 80 hp na start. Ma latarke ktora ujawnia Ninje i kameleona. Gdy sie naladuje otrzymuje 20 hp. Szybki czas ladowania. Raz na 10 - int/25 sekund moze uzyc strumienia wody. Strumien wody daje Ci 10 tarczy, odnawia amunicje oraz zwieksza predkosc, przeskakuje po pobliskich sojusznikach i przeciwnikach. Leczy sojusznikow, odnawia im amunicje oraz zwieksza ich predkosc, zadaje obrazenia przeciwnikom, zamraza ich na sekunde, zmniejsza ich predkosc ","")
		}
		case 11:{
			showitem(id,"Mag ziemi ","Mag"," 95 hp na start. Odporny na upadki. Ma latarke ktora ujawnia Ninje i kameleona. Ma szanse 1/20 na zatrzymanie strzalem. Raz na 10 - int/25 sekund moze uzyc uderzenia w ziemie. Zadaje to obrazenia o mocy 20 + int/X + 20% hp przeciwnika. oraz zatrzymuje przeciwnikow. Ladujac sie dostaje granat ziemi  ","")
		}
		case 12:{
			showitem(id,"Mag powietrza ","Mag","110 hp na start. Ma latarke ktora ujawnia Ninje i kameleona. Ladujac sie dostaje granat powietrza. Ma szanse losowo 1/20 na oslepienie wroga. Moze uderzyc w ziemie raz na 20 sekund. Przeciwnicy wylatuja w gore i maja szanse na wyrzucenie broni. Szansa zalezy od inteligencji maga. Zadaje to obrazenia 0.25*int (max 100)+15%hp ofiary na obszarze 250+int*2","")
		}
		case 13:{
			showitem(id,"Arcymag ","Mag"," 100 hp na start. Ma latarke ktora ujawnia Ninje i kameleona Raz na 25 i int/5 (min10) sek moze przyciskiem r trzymajac noz uderzyc w ziemie. Ladujac sie zadaje obrazenia podrzucajac i wyrzucajac bronie (Ladowanie moze byc uzyte co 10 sekund). Raz na 10 sekund moze uzyc teleportu oraz lightballa, ktory ma rozne dodatkowe opcje takie same jak mag. Podpala zwyklymi atakami. Wampiryzm zaklec 1 + 1proc.","")
		}
		case 14:{
			showitem(id,"Magic Gladiator","Mag"," 100 hp na start. Jesli ma noz i wcisnie prawy przycisk teleportuje sie. Jesli ma noz i wcisnie lewy przycisk castuje power slash (jak lightball) Power slash moze uzyc raz na 15 - int/7 sek Laduje magiczne pancerze (maksymalnie 3) ","")
		}
		
		
		case 15:{
			showitem(id,"Nekromanta","Mroczny"," 90 hp na start. Moze wskrzeszac graczy z swojego teamu i wysysac zycie z cial przeciwnikow (dostaje za to expa). Podczas strzalow wysysa 5 + int/15 hp (max 15). Ma 1/7 szans na odrodzenie sie po smierci  ","")
		}
		case 16:{
			showitem(id,"Witch doctor","Mroczny","100 hp na start. 5 wysysu. Zabijajac przeciwnika robi z niego eliksir i otrzymuje efekt zalezny od klasy przeciwnika. Int zwieksza poczatkowa moc eliksiru. Ladujac sie wzmacnia eliksir. Pelny opis http://cs-lod.com.pl/index.php/poradniki/opis-klas-lod1","")
		}
		case 17:{
			showitem(id,"Orc ","Mroczny"," 750 + sila * 25 hp na start. nie moze uzywac broni. Atak z nozem + 50 dmg. Ladujac sie zyskuje 1 + int/2 hp. Gdy jest atakowany zwyklymi atakami leczenie oslabia siê o 50% na 1 sekunde. Raz na 20 sekund moze uzyc (r) skoku w przod ktory wybije przeciwnikow w powietrze i zada obrazenia rowne 25 + int/10. ","")
		}
		case 18:{
			showitem(id,"Wampir ","Mroczny"," 80 hp na start. Przy kazdym uderzeniu w plecy wysysa 10 + int/2 HP wrogowi (max 50). Ladujac sie znika do czasu gdy sie ruszy lub zaatakuje, w tym czasie traci 10proc hp co 5 sek. Po zabiciu przeciwnika przeciwnik bedzie mial krwawy glod dajacy mu wampiryzm.  ","")
		}
		case 19:{
			showitem(id,"Harpia ","Mroczny"," 120 hp na start. bardzo szybka, bardzo skoczna. atak z nozem wysysa 40 + int(max 90). ladujac sie zyskuje predkosc ma 150 widocznosci ","")
		}
		case 20:{
			showitem(id,"Wilkolak ","Mroczny"," ma 120 hp na start. inteligencja zmniejsza czas ladowania, i wydluza czas trwania zewu krwi. kolejne ladowanie wydluza zew krwi. gdy sie naladuje przez 30 sekund jest silniejszy(zew krwi):- hp * 150%. - bonus do szybkosci 80. - nie slychac jego krokow. - ma 1/3 szans na obicie pocisku - 3 wampiryzmu","")
		}
		case 21:{
			showitem(id,"Upadly aniol ","Mroczny"," 120 hp na start. Wbudowane archy. (noz i r). Grawitacja 0.9 - int /500 (max 0.5). Archy mozna uzyc co 30 sekund - int / 20 (max 5 sek). Po smierci wybucha w promieniu 100 + int*2. Gdy sie naladuje dostaje mozliwosc podskoczenia w powietrzu, na start 4 skoki w powietrzu. Ma widzialnosc 180, a z nozem 50 ","")
		}
		
		
		case 22:{
			showitem(id,"Lowca ","Mysliwy"," 110 hp na start. Ladujac sie dostaje he granat. Gdy trzyma noz i wcisnie r otrzymuje kusze. Obrazenia z kuszy sa zalezne od inteligencji. Gdy trzyma granat i wcisnie prawy przycisk myszki przelacza miedzy rzutem granatu a podkladaniem granatu pulapki. Maksymalnie da sie podlozyc 5.","")
		}
		case 23:{
			showitem(id,"Szary elf ","Mysliwy"," Na poczatek ma 200 widocznosci. Punkty inteligencji zmniejszaja jego widzialnosc. Minimalna widzialnosc to 50 przy 200 punktach inteligencji. Jego strzaly z pistoletow zamrazaja przeciwnikow. Moze podlozyc 7 zamrazajacych min na runde. 110 hp na start. Po naladowaniu sie Dostaje 20 niewidzialnosci. Gdy trzyma noz ma 30 widzialnosci, ale traci hp. ","")
		}
		case 24:{
			showitem(id,"Lesny elf","Mysliwy"," Potrafi lepiej wykorzystac przedmioty. Niektore przedmioty moze dostac tylko on. 100 hp na start ","")
		}
		case 25:{
			showitem(id,"Stalker","Mysliwy"," 90 HP na start, widocznosc standardowo zredukowana do 80-int/4 [min 55 przy 100 int], brak mozliwosci modyfikacji widocznosci poprzez przedmioty, po zaladowaniu sie dostaje odpowiednik pociskow z kory enta [max 10 pociskow], gdy kuca jest calkowicie niewidzialny, ale traci hp i moze trzymac tylko noz, dostaje XM1014 (pompa)","")
		}
		case 26:{
			showitem(id,"Drzewiec","Mysliwy"," 200 HP na start. Zadaje nozem dodatkowe obrazenia. Dostaje m3, zadaje nim dodatkowe obrazenia. Kazdy celny strzal inna bronia kosztuje go $. W przypadku braku $ wyrzuca bron. Strzelajac z m3 odpycha lub przyciaga zaleznie od nastroju. Nastroj mozna zmienic (noz+R). Otrzymuje tym mniejsze obrazenia im dalej jest atakujacy. Ladujac sie regeneruje hp, zakorzenia siebie i pobliskich przeciwnikow. Wolny, sila zmniejsza jego predkosc. ","")
		}
		case 27:{
			showitem(id,"Zmij","Mysliwy","  ","90 hp na start. Zatruwa nozem za okolo 25 proc hp przeciwnika. Zadaje z tmp dodatkowe okolo 6 proc max HP przeciwnika + 6. Raz na 20 sekund moze skoczyc w przod, nastepnie przez 10 sekund moze sie teleportowac w poprzednie polozenie zadajac obrazenia. Po teleporcie przez okolo 5 sec moze uzywac tylko noza. Otrzymuje tmp, nie moze uzywac HE. Chodzac z nozem swieci na zielono, otrzymuje o polowe mniejsze obrazenia magiczne, odbija pociski.")
		}
		case 28:{
			showitem(id,"Dzikuska","Mysliwy"," 90 HP na start, Jesli ma przeciwnika w poblizu moze skakac na boki (spacja, ctrl, ruch w bok). Wysokosc skoku zalezna od zwinnosci, odleglosc do przeciwnika od inteligencji. Dodatkowe obrazenia od tylu zalezne od inteligencji. Po naladowaniu ma 30 sekund calowitej nieustepliwosci. Trafienie w plecy odnawia amunicje.","")
		}
	}
	return PLUGIN_CONTINUE
}
public add_wid(id)
{
	new Players[32], playerCount
	get_players(Players, playerCount, "ah") 
	
	for (new i=0; i<playerCount; i++) 
	{
		id = Players[i] 
		if(player_b_samurai[id]>0){
			if(player_b_inv[id] < 20){
				player_b_inv[id] += 3
				
			}
			else if(player_b_inv[id] < 50){
				player_b_inv[id] += 5
				
			}
			else{
				player_b_inv[id] += 90
			}
			
			if(player_b_inv[id] > 200){
				player_b_inv[id] =0				
			}			
			set_renderchange(id)
			write_hud(id)
		}
		if(player_class[id]==szelf){
			if(on_knife[id] && !casting[id]){
				if(random_num(0,10)) change_health(id, -2, 0, "world")
			}
		}
	}
}


public hamTakeDamage( victim, inflictor, attacker, Float:damage, damagebits )
{
	if( (IsPlayer(attacker) && IsPlayer(victim)) && !g_bAsysta[attacker][victim] && get_user_team(victim) != get_user_team(attacker) && victim != attacker){
		g_bAsysta[victim][attacker] = true;
		g_bAsysta[attacker][victim] = true;
	}
	if( player_class[victim]==MagZ && damagebits == DMG_FALL )
		return HAM_SUPERCEDE;
	return HAM_IGNORED;
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
	return false
}

public event_bomb_drop() {
	g_carrier = 0
}
public event_got_bomb(id) {
	g_carrier = id
}


public item_mineL(id)
{
	if ( is_user_in_bad_zone( id ) ){
		hudmsg(id,2.0,"Nie mozna uzyc w tym miejscu")
		return PLUGIN_HANDLED
	}
	new count = 0
	new ents = -1
	ents = find_ent_by_owner(ents,"MineL",id)
	while (ents > 0)
	{
		count++
		ents = find_ent_by_owner(ents,"MineL",id)
	}
	
	if (count > 6 + player_b_mine[id]*2)
	{
		hudmsg(id,2.0,"Mozesz polozyc maksymalnie %i min na runde", (6 + player_b_mine[id]*2 +1))
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
	write_hud(id)
	
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
		player_samelvl2[id] = 0;
		for(new i=1;i<sizeof(race_heal);i++){
			if((player_lvl[id] - 25 < player_class_lvl[id][i]) && (player_lvl[id] + 25 > player_class_lvl[id][i]))
			{
				player_samelvl[id]++
			}
		}
		player_samelvl[id]= player_samelvl[id]-1
		if(player_samelvl[id] <0) player_samelvl[id] = 0
		
		for(new i=1;i<sizeof(race_heal);i++){
			if((player_lvl[id] - 50 < player_class_lvl[id][i]) && (player_lvl[id] + 50 > player_class_lvl[id][i]))
			{
				player_samelvl2[id]++
			}
		}
		player_samelvl2[id]= player_samelvl2[id]-1
		if(player_samelvl2[id] <0) player_samelvl2[id] = 0
		player_tarczam_round[i]=0
		player_b_szarza_time[i]=0
  		if((player_class[id] == Ninja || player_class[id] == Orc) && (is_user_connected(id)))
		{
			if(is_user_alive(id)&&(equal(szMapName, "awp_india") || equal(szMapName, "aim_aztec") || equal(szMapName, "awp_hunter"))){
				client_cmd(id,"kill");
				changerace(id);
				set_hudmessage(255, 0, 0, -1.0, 0.01)
				show_hudmessage(id, "KLASA ZABRONIONA NA TEJ MAPIE")
				
			} 
			if (is_user_alive(id)) set_user_armor(id,100)
		}
		else if((player_class[id] == Archeolog) && (is_user_connected(id)))
		{
			if (is_user_alive(id)) cs_set_user_money(id,cs_get_user_money(id)+1000+20*player_intelligence[id] )

		}
  		else if((player_class[id] ==lelf) && (is_user_connected(id)))
		{
			player_diablo[id]=0
		}
  		else if((player_class[id] ==Magic) && (is_user_connected(id)))
		{
			
			if(!equal(szMapName, "awp_india") && !equal(szMapName, "aim_aztec") && !equal(szMapName, "awp_hunter")){
				player_b_blink[id] = floatround(halflife_time())
			} else{
				player_b_blink[id]= 0 
			}
		}
  		else if((player_class[id] ==MagO) && (is_user_connected(id)))
		{
			Effect_Ignite(id,0,1)
			player_b_firetotem[id] = random_num(200+player_intelligence[id],500+player_intelligence[id]*2)
			
		}
		else if(player_class[id] == Barbarzynca && player_lvl[id]>prorasa && is_user_connected(id))
		{
			ultra_armor[id]=10
		}
		
		if(player_inkizytor[id] >0) golden_bulet[id]=5		
		if(player_awpk[id]>0) give_item(id, "weapon_awp");
		set_gravitychange(id)
		if(player_b_m3_knock[id]>0 || player_b_m3[id]>0){
			fm_give_item(id, "weapon_m3")
			give_item(id, "ammo_buckshot")
			give_item(id, "ammo_buckshot")
			give_item(id, "ammo_buckshot")
		}
		if(player_class[id]==Stalker && is_user_connected(id)) {
			
			fm_give_item(id, "weapon_xm1014")
			give_item(id, "ammo_buckshot")
			give_item(id, "ammo_buckshot")
			give_item(id, "ammo_buckshot")
		}
		if(player_class[id]==Drzewiec && is_user_connected(id)) {
			
			fm_give_item(id, "weapon_m3")
			give_item(id, "ammo_buckshot")
			give_item(id, "ammo_buckshot")
			give_item(id, "ammo_buckshot")
		}
		if(player_class[id]==Zmij){
			fm_give_item(id, "weapon_tmp")
			fm_give_item(id, "ammo_9mm" );
			fm_give_item(id, "ammo_9mm" );
			fm_give_item(id, "ammo_9mm" ); 
		}
		set_task(2.0, "stalkPompa", id)

		nami_vic[id] = 0
		player_tarczapowietrza[id] = 0
		set_speedchange(id)
		client_cmd(id, "cl_forwardspeed 700");
		bonus_pro(id)
		if(player_b_sniper[i]>0) fm_give_item(i, "weapon_scout") 	
		if(player_b_grenade[i]>0) fm_give_item(id, "weapon_hegrenade")
		player_b_udreka_ofiara[i]=0
		player_b_udreka_sec[i] = 0
		
		set_user_health(id,get_maxhp(id))
		ofiara_totem_lodu[id]=0
		player_b_tarczaograon[id]=0
		ofiara_totem_enta[id]=0
		once_double_dmg[id]=0
		timed_godmode[id]=0.0
		player_timed_speed[id]=halflife_time()
		player_timed_dmg_time[id] = halflife_time()
		player_timed_slow[id]=halflife_time()
		last_attacker[id] = 0
		velkoz[id] = 0
		if(player_blogo[id] >0 ) golden_bulet[id]=5
		if(player_blogo[id] >0 && player_class[id] == lelf) golden_bulet[id] += player_intelligence[id] / 50

		gravitytimer[i] = 0	// timer archow
		player_mshield[i] = 0

		change_health(i,0,i,"world")
		
		if(player_glod[i] >0) g_haskit[i] = true
		if(player_class[i] == Nekromanta) g_haskit[i]=1		
		
		if(player_glod[i] > 0 )player_glod[i]=1
		if(player_pelnia[i]>0){
			player_speedbonus[i] = 1
		}
		RemoveFlag(i,Flag_Ignite)
		RemoveFlag(id,Flag_truc)

		set_renderchange(id)
		if(u_sid[id] > 0){
			cs_set_user_money(i,cs_get_user_money(i)+STEAMMONEY)
		}
		if(get_user_flags(id) & ADMIN_LEVEL_D || player_vip[id]==2){
			if (is_user_alive(id)) cs_set_user_money(id,cs_get_user_money(id)+VIPPROMONEY)
		}
		if(player_vip[id]==3){
			if (is_user_alive(id)) cs_set_user_money(id,cs_get_user_money(id)+XPBOOSTMONEY)
		}
		if(KlasyZlicz[player_class[id]]==1)		
		{
			if (is_user_alive(id)) cs_set_user_money(id,cs_get_user_money(id)+100)		
		}
		if(cs_get_user_money(id) > 25000)  cs_set_user_money(id,25000)
		LvlInfo(id);
	}
}

public LvlInfo(id){
		if(avg_lvl > 10){
			client_print(id, print_chat, "Aktualny sredni lvl na serwerze to: %i, TT %i [%i], CT %i [%i]", avg_lvl, avg_lvlTT, sum_lvlTT, avg_lvlCT, sum_lvlCT);
			/*if( diablo_redirect == 2){
				if(player_lvl[id] > 50 && player_lvl[id] > 10){
					client_print(id, print_chat, "Na serwerze gra sie DO 50 lvl. Twoj lvl jest wiekszy. Mozesz zostac automatycznie przeniesiony. Komenda /przenies");
				}
			}
			if( diablo_redirect == 3){
				if(player_lvl[id] < 50 && player_lvl[id] > 10){
					client_print(id, print_chat, "Na serwerze gra sie OD 50 lvl. Twoj lvl jest mniejszy. Mozesz zostac automatycznie przeniesiony. Komenda /przenies");
				}
				if(player_lvl[id] > 125 && player_lvl[id] > 10){
					client_print(id, print_chat, "Na serwerze gra sie DO 125 lvl. Twoj lvl jest wiekszy. Mozesz zostac automatycznie przeniesiony. Komenda /przenies");
				}
			}
			if( diablo_redirect == 4){
				if(player_lvl[id] < 125 && player_lvl[id] > 10){
					client_print(id, print_chat, "Na serwerze gra sie OD 125 lvl. Twoj lvl jest mniejszy. Mozesz zostac automatycznie przeniesiony. Komenda /przenies");
				}
			}*/
		}
}

public calc_exp_perc(victim_id, killer_id)
{
	new more_lvl=moreLvl(victim_id, killer_id)
	
	new podzielnik = 1
	if(avg_lvl > 50) podzielnik = 2
	if(avg_lvl > 75) podzielnik = 3
	if(avg_lvl > 100) podzielnik = 4
	if(avg_lvl > 125) podzielnik = 5
	if(avg_lvl > 150) podzielnik = 6
	if(avg_lvl > 175) podzielnik = 10
	if(avg_lvl > 200) podzielnik = 25	
	
	new ret = ((2 * more_lvl / 5) / podzielnik) + 100
	
	if(more_lvl > podzielnik*10) ret += (3 * (more_lvl - 55) / podzielnik)
	if(more_lvl < -podzielnik*10) ret += (3 * (more_lvl + 55) / podzielnik)

	if(ret < 0) ret = 0
	if(ret > 250) ret = 250
	return ret
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
	if(more_lvl < -50 &&  avg_lvl > 125) more_lvl = -50
	return more_lvl
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



public TimedInv(id,t)
{
	timed_inv[id]=floatround(halflife_time()) + t
	set_renderchange(id)
	set_task(1.0,"set_renderchange",id) 
	set_task(1.1,"set_renderchange",id) 
}
public item_bitewnyszal_off(id)
{
	set_user_godmode(id,0)
}
public item_bitewnyszal(id)
{
	if( used_item[id] ==true){
		hudmsg(id,2.0,"Bitewny szal mozesz uzyc raz na runde!")
		return PLUGIN_CONTINUE
	}
	used_item[id] = true
	
	player_bitewnyszal_time[id]=floatround(halflife_time()) + player_bitewnyszal[id]
	set_user_godmode(id,1)
	set_task(player_bitewnyszal[id]+ 0.1,"item_bitewnyszal_off",id)
	set_task(player_bitewnyszal[id]+ 0.2,"item_bitewnyszal_off",id)
	return PLUGIN_CONTINUE
}

public TwoSecEvent()
{
	new Players[32], playerCount, a
	get_players(Players, playerCount, "ah") 
	
	for (new i=0; i<playerCount; i++) 
	{
		a = Players[i] 
		if ((player_glod_tmp[a]>0 || player_glod[a] > 0) &&  is_user_alive(a))
		{
			if (player_glod_tmp[a] == 1){
				Display_Fade(a,1200,1200,0,120,0,0,120)
			}
			if (player_glod_tmp[a] > 1){
				client_cmd(a, "mp3 play sound/heartbeat-01.mp3") 
				set_task(0.02,"Display_Fade_glod",a);
				g_FOV[a]=130;
				set_task(0.02,"efectV",a+33+MAXTASKC, "", 0, "b");
				change_health(a, -1, 0, "world")
			}
			if (player_glod[a] == 1){
				Display_Fade(a,1200,1200,0,120,0,0,120)
				change_health(a, -1, 0, "world")
			}
			if (player_glod[a] > 1){
				client_cmd(a, "mp3 play sound/heartbeat-01.mp3") 
				set_task(0.02,"Display_Fade_glod",a);
				g_FOV[a]=130;
				set_task(0.02,"efectV",a+33+MAXTASKC, "", 0, "b");
				change_health(a, -10, 0, "world")
			}

		}
		if (((player_class[a] ==Witch && player_naladowany[a] == Wilk) || (player_pelnia[a] > 0 && (player_class[a] == Wilk || player_class[a] == lelf))) && is_user_alive(a))
		{

			if (player_pelnia[a] >0 || (player_class[a] ==Witch && player_naladowany[a] == Wilk)){
				Display_Fade(a,1200,1200,0,0,0,0,150)
				client_cmd(a, "mp3 play sound/heartbeat-01.mp3") 
				if(casting[a]!=1 && player_pelnia[a] >0) change_health(a, -2, 0, "world")
			}
		}	
		
	}
}
public Display_Fade_glod(a )
{
	Display_Fade(a,1200,1200,0,200,0,0,200)
}
public SecEvent()
{
	new Players[32], playerCount, a
	get_players(Players, playerCount, "ah") 
	
	for (new i=0; i<playerCount; i++) 
	{
		a = Players[i] 
		new id=a

		if(isevent == 1)
		{
			Display_Fade(id,2600,2600,0,0,0,0,200)
		}
	}
	return PLUGIN_CONTINUE
}

public efectV(id)
{
	new player=id-(33+MAXTASKC);
	if(player > 33) return
	if(g_FOV[player]<=100)
	{
		remove_task(id);
	}
	if(is_user_alive(player))
	{
		g_FOV[player]-=2;
		//get_user_msgid("SetFOV") == 95
		message_begin(MSG_ONE, 95, {0,0,0}, player);
		write_byte(g_FOV[player]);
		message_end();
	}
}


public count_avg_lvl()
{
	new ccTT = 0
	new sumTT = 0
	new ccCT = 0
	new sumCT = 0
	sum_lvlTT = 0
	sum_lvlCT = 0
	for(new a=0;a<32;a++){
		if(!is_user_connected(a)) continue;
		if(player_class[a] != 0 && player_lvl[a] > 5 && cs_get_user_team(a) == CS_TEAM_T)
		{
			sum_lvlTT = sum_lvlTT  + player_lvl[a];
			sumTT = sumTT + player_lvl[a];
			ccTT = ccTT + 1;
		}
		if(player_class[a] != 0 && player_lvl[a] > 5 && cs_get_user_team(a) == CS_TEAM_CT)
		{
			sum_lvlCT = sum_lvlCT  + player_lvl[a];
			sumCT = sumCT + player_lvl[a];
			ccCT = ccCT + 1;
		}
	}
	if(ccTT == 0) ccTT++
	if(ccCT == 0) ccCT++
	avg_lvlCT = sumCT / ccCT
	avg_lvlTT = sumTT / ccTT


	if(diablo_redirect==1){
		if(avg_lvlTT < 0) avg_lvlTT = 0
		if(avg_lvlTT > 24) avg_lvlTT = 49
		if(avg_lvlCT < 0) avg_lvlCT = 0
		if(avg_lvlCT > 24) avg_lvlCT = 49
	}
	if(diablo_redirect==2){
		if(avg_lvlTT < 0)avg_lvlTT = 0
		if(avg_lvlTT > 74) avg_lvlTT = 99
		if(avg_lvlCT < 0) avg_lvlCT = 0
		if(avg_lvlCT > 74) avg_lvlCT = 99
	}
	if(diablo_redirect==3){
		if(avg_lvlTT < 75) avg_lvlTT = 75
		if(avg_lvlTT > 500) avg_lvlTT = 500
		if(avg_lvlCT < 75) avg_lvlCT = 75
		if(avg_lvlCT > 500) avg_lvlCT = 500
	}
	if(diablo_redirect==4){
		if(avg_lvlTT < 125) avg_lvlTT = 125
		if(avg_lvlTT > 500) avg_lvlTT = 500
		if(avg_lvlCT < 125) avg_lvlCT = 125
		if(avg_lvlCT > 500) avg_lvlCT = 500
	}
	if(diablo_redirect==5){
		if(avg_lvlTT < 125) avg_lvlTT = 125
		if(avg_lvlTT > 500) avg_lvlTT = 500
		if(avg_lvlCT < 125) avg_lvlCT = 125
		if(avg_lvlCT > 500) avg_lvlCT = 500
	}
	
	avg_lvl = ( avg_lvlCT + avg_lvlTT )/2
}

public award_kill(killer_id,victim_id)
{
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
	
	if(player_glod_tmp[victim_id] >0) player_glod_tmp[victim_id] = 0
	if(player_glod_tmp[killer_id] == 1)player_glod_tmp[killer_id] = 2
	if(player_glod_tmp[killer_id] > 1)player_glod_tmp[killer_id] = 0
	
	changeskin(victim_id,1)
	if(player_class[killer_id] == Wampir)
	{
		player_glod_tmp[victim_id] = 1
	}
	
	if (!is_user_connected(killer_id) || !is_user_connected(victim_id))
		return PLUGIN_CONTINUE
		
	if(super ==1 && player_lvl[victim_id]>prorasa){
		if(player_class[victim_id]==Hunter ){
			Lowca_kamikaze(victim_id)
		}
		if(player_class[victim_id]==lelf ){
			if(forceEvent != 2) award_item(victim_id,0)
		}
	}
	if(player_lvl[killer_id] >prorasa ){
		if(player_class[killer_id]==Wampir && random_num(0,1)==0){
			refill_a(killer_id);
		}
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
				new dam =25-(player_dextery[a]*50)
				if(dam<1) dam = 1
				if(! HasFlag(a, Flag_truc)){
					Effect_waz(a,victim_id,dam)
					hudmsg(a,3.0,"Jestes zatruty!")
				}			
			}
		}
	}

	if(player_class[killer_id]==lelf && player_inkizytor[killer_id] > 0 ){
		used_item[killer_id] = false
	}
	if(player_class[killer_id] == Witch){
		if(player_class[victim_id]== Witch){
			if(player_naladowany[victim_id] != 0){
				player_naladowany2[killer_id] += player_naladowany2[victim_id]
				player_naladowany[killer_id] = player_naladowany[victim_id] 
			}
			player_naladowany[victim_id] =0
			player_naladowany2[victim_id] =0
		}
		else if(player_naladowany[killer_id] == player_class[victim_id]) {
			if(get_playersnum()>5) player_naladowany2[killer_id]+=1
			if(get_playersnum()>10) player_naladowany2[killer_id]+=2
			if(get_playersnum()>15) player_naladowany2[killer_id]+=3
			if(get_playersnum()>20) player_naladowany2[killer_id]+=5
		}
		else{ 
			player_naladowany2[killer_id]=1 + player_intelligence[killer_id]/20
			//if(player_naladowany2[killer_id] > 5) player_naladowany2[killer_id]--
			//if(player_naladowany2[killer_id] > 9) player_naladowany2[killer_id]--
			//if(player_naladowany2[killer_id] > 11) player_naladowany2[killer_id]--
			player_naladowany[killer_id] = player_class[victim_id]
		}
		if(player_naladowany[killer_id] == Orc){
			player_b_nieust[killer_id] += player_naladowany2[killer_id]*10
			if(player_b_nieust[killer_id] >90) player_b_nieust[killer_id] = 90
		}
		if(player_naladowany[killer_id] == lelf){
			upgrade_item(killer_id)
			if(player_naladowany2[killer_id] > 5) upgrade_item(killer_id)
			if(player_naladowany2[killer_id] > 7) upgrade_item(killer_id)
			if(player_naladowany2[killer_id] > 9) upgrade_item(killer_id)
			if(player_naladowany2[killer_id] > 11) upgrade_item(killer_id)
		}
	}
	
	if(super ==1 && player_lvl[killer_id]>prorasa){
		if(player_class[killer_id]==Mag ){
			change_health(killer_id, 50, killer_id, "")
		}
		if(player_class[killer_id]==Magic ){
			player_mshield[killer_id] += 25
		}
	}
	if(player_b_furia[killer_id] > 0 && is_user_alive(killer_id)) cs_set_user_money(killer_id,cs_get_user_money(killer_id)-500)
	if(player_glod[killer_id] >0) player_glod[killer_id]++
	RemoveFlag(victim_id,Flag_Ignite)
	RemoveFlag(victim_id,Flag_truc)
	if(player_demon[killer_id] == 1) player_b_damage[killer_id] += 2
		
	if(player_class[victim_id] == Ninja) client_cmd(killer_id, "softtest")
		
	new xp_award = get_cvar_num("diablo_xpbonus")
	last_attacker[victim_id] = 0
	add_respawn_bonus(victim_id)
	add_bonus_explode(victim_id)
	add_barbarian_bonus(killer_id)
	if (player_class[killer_id] == Barbarzynca || player_refill[killer_id]>0) refill_ammo(killer_id, 1)
	if(super ==1 && player_lvl[victim_id]>prorasa && player_class[victim_id]==Witch){
		create_fake_corpse(victim_id)
		//pev(victim_id, pev_origin, originWitchEvo[victim_id])	
		set_task(2.0, "Witch_evo",victim_id)
	}
		
	new Team[32]
	get_user_team(killer_id,Team,31)
	
	if (moreLvl(victim_id, killer_id)> 25 && get_playersnum() > 6) 
		xp_award+=get_cvar_num("diablo_xpbonus")/4 + (get_cvar_num("diablo_xpbonus")/10 * moreLvl(victim_id, killer_id) / 10)
		
	if (moreLvl(victim_id, killer_id) < -25) 
		xp_award-=get_cvar_num("diablo_xpbonus")/4
				
	xp_award = xp_award * lvl_dif_xp_mnoznik[victim_id][killer_id] / 100	
	if(forceEvent==3) xp_award/=25
	new ser = seria[victim_id]
	seria[victim_id] = 0
	seria[killer_id] += 1
	if(ser > 0 && get_playersnum() > 8){
		if(ser>10) ser = 10
		new sName[32];
		get_user_name(victim_id, sName, sizeof sName - 1);
		new bon = (ser * 10 * xp_award / 100) + 10 * ser
		if(get_playersnum() > 10) bon = (ser * 20 * xp_award / 100) + 20 * ser
		if(get_playersnum() > 15) bon = (ser * 50 * xp_award / 100) + 50 * ser
		if(get_playersnum() > 20) bon = (ser * 10 * xp_award / 100) + 10 * ser
		xp_award = xp_award + bon
		if(tutOn && ser > 3 && tutor[killer_id]<2) tutorMake(killer_id,TUTOR_YELLOW,2.0, "Przerywasz serie  %s + %d XP", sName, xp_mnoznik(killer_id, bon));
	}
	if(xp_award<1)xp_award =1 
	if(forceEvent==3) xp_award/=10
	Give_Xp(killer_id,xp_award)
	if(forceEvent != 2) award_item(killer_id,0)
	
	player_wys[killer_id]=1
	
	if (player_item_id[victim_id] > 0 && item_durability[victim_id] >= 0)
	{
		new itemdamage = 5
		if(player_class[victim_id] == Orc) itemdamage = 50
		item_make_damage(victim_id,itemdamage)
	}
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
				
			xp_award = xp_award * lvl_dif_xp_mnoznik[iVictim][iKiller]  / 100	
			xp_award = xp_award / 7
			if(forceEvent==3) xp_award/=50
			if(xp_award<1)xp_award =1 
			Give_Xp(iKiller,xp_award)
 
			if(tutOn && tutor[iKiller] <2)tutorMake(iKiller,TUTOR_YELLOW,2.0, "Zemsta na %s + %d XP", sName, xp_mnoznik(iKiller, xp_award));
 
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
				xp_award = xp_award / (2+seria[i])
				if(forceEvent==3) xp_award/=50
				if(xp_award<1)xp_award =1 
				Give_Xp(i,xp_award)
				
				if(tutOn && tutor[i] <2)tutorMake(i,TUTOR_YELLOW,2.0, "Asysta na %s + %d XP", sName, xp_mnoznik(i, xp_award));
			}
 
			g_bAsysta[i][iVictim] = false;
		}
	}
	return PLUGIN_CONTINUE	
}


public change_frags(killer, victim, fraged)
{
	if(fraged){
		set_user_frags(killer,get_user_frags(killer) -1);
	}
	
	if(diablo_redirect==4 || avg_lvl > 150 || avg_lvl < 5){
		set_user_frags(killer,get_user_frags(killer) +1);
		return;
	}
	if(avg_lvl < 25){
		new ld= moreLvl(victim, killer)
		if(ld < -25){
			client_cmd(killer, "mp3 play sound/frags/looser.mp3") 
			client_print(killer, print_chat, "Twoj lvl jest zbyt wysoki by tu grac, przejdz na serwer gdzie graja wiekszymi lvlami! /server");
		}else if(ld > 100){
			//dropitem(victim)
			set_user_frags(killer,get_user_frags(killer) +4);
			client_cmd(killer, "mp3 play sound/frags/headhunter.mp3") 
			client_cmd(0, "mp3 play sound/frags/headhunter.mp3") 
		}else if(ld > 75){
			//dropitem(victim)
			set_user_frags(killer,get_user_frags(killer) +3);
			client_cmd(killer, "mp3 play sound/frags/ownage.mp3") 
			client_cmd(victim, "mp3 play sound/frags/ownage.mp3") 
		}else if(ld > 25){
			//dropitem(victim)
			set_user_frags(killer,get_user_frags(killer) +2);
			client_cmd(killer, "mp3 play sound/frags/dominating.mp3") 
			client_cmd(victim, "mp3 play sound/frags/dominating.mp3") 
		}else {
			set_user_frags(killer,get_user_frags(killer) +1);
		}
		return;
	}
	
	
	if(avg_lvl < 75){
		new ld= moreLvl(victim, killer)
		if(ld < -75){
			client_cmd(killer, "mp3 play sound/frags/looser.mp3") 
			client_print(killer, print_chat, "Twoj lvl jest zbyt wysoki by tu grac, przejdz na serwer gdzie graja wiekszymi lvlami! /server");
		}else if(ld > 150){
			//dropitem(victim)
			set_user_frags(killer,get_user_frags(killer) +4);
			client_cmd(killer, "mp3 play sound/frags/headhunter.mp3") 
			client_cmd(0, "mp3 play sound/frags/headhunter.mp3") 
		}else if(ld > 100){
			//dropitem(victim)
			set_user_frags(killer,get_user_frags(killer) +3);
			client_cmd(killer, "mp3 play sound/frags/ownage.mp3") 
			client_cmd(victim, "mp3 play sound/frags/ownage.mp3") 
		}else if(ld > 75){
			//dropitem(victim)
			set_user_frags(killer,get_user_frags(killer) +2);
			client_cmd(killer, "mp3 play sound/frags/dominating.mp3") 
			client_cmd(victim, "mp3 play sound/frags/dominating.mp3") 
		}else {
			set_user_frags(killer,get_user_frags(killer) +1);
		}
		return;
	}
	
	
	if(avg_lvl >= 75){
		new ld= moreLvl(victim, killer)
		if(ld < -100){
			client_cmd(killer, "mp3 play sound/frags/looser.mp3") 
			client_print(killer, print_chat, "Twoj lvl jest zbyt wysoki by tu grac, przejdz na serwer gdzie graja wiekszymi lvlami! /server");
		}else if(ld > 250){
			dropitem(victim)
			set_user_frags(killer,get_user_frags(killer) +4);
			client_cmd(killer, "mp3 play sound/frags/headhunter.mp3") 
			client_cmd(0, "mp3 play sound/frags/headhunter.mp3") 
		}else if(ld > 150){
			set_user_frags(killer,get_user_frags(killer) +3);
			client_cmd(killer, "mp3 play sound/frags/ownage.mp3") 
			client_cmd(victim, "mp3 play sound/frags/ownage.mp3")
		}else if(ld > 100){
			set_user_frags(killer,get_user_frags(killer) +2);
			client_cmd(killer, "mp3 play sound/frags/dominating.mp3") 
			client_cmd(victim, "mp3 play sound/frags/dominating.mp3") 
		}else {
			set_user_frags(killer,get_user_frags(killer) +1);
		}
		return;
	}
}

public icon_test(id){
	if(get_user_flags(id) & ADMIN_LEVEL_H){
		for (new i = 1; i < read_argc(); i++) {
			new command[32]
			read_argv(i, command, 31) //read_argv read the i parameter and store it into command
			new item = str_to_num(command)
			new name[50] = "rescure"
			
			if(item == 1) name = "selection" 
			if(item == 2) name = "bucket1"              
			if(item == 3) name = "bucket2"             
			if(item == 4) name = "bucket3"             
			if(item == 5) name = "bucket4"            
			if(item == 6) name = "bucket5"                
			if(item == 7) name = "bucket0"                
			if(item == 8) name = "dmg_bio"                
			if(item == 9) name = "dmg_poison"           
			if(item == 10) name = "dmg_chem"            
			if(item == 11) name = "dmg_cold"        
			if(item == 12) name = "dmg_drown"            
			if(item == 13) name = "dmg_heat"           
			if(item == 14) name = "dmg_gas"               
			if(item == 15) name = "dmg_rad"                
			if(item == 16) name = "dmg_shock"            
			if(item == 17) name = "number_0"            
			if(item == 18) name = "number_1"            
			if(item == 19) name = "number_2"          
			if(item == 20) name = "number_3"            
			if(item == 21) name = "number_4"            
			if(item == 22) name = "number_5"           
			if(item == 23) name = "number_6"            
			if(item == 24) name = "number_7"            
			if(item == 25) name = "number_8"           
			if(item == 26) name = "number_9"            
			if(item == 27) name = "divider"                
			if(item == 28) name = "cross"                
			if(item == 29) name = "dollar"              
			if(item == 30) name = "minus"                
			if(item == 31) name = "plus"               
			if(item == 32) name = "c4"                
			if(item == 33) name = "defuser"              
			if(item == 34) name = "stopwatch"           
			if(item == 35) name = "smallskull"              
			if(item == 36) name = "smallc4"             
			if(item == 37) name = "smallvip"               
			if(item == 38) name = "buyzone"               
			if(item == 39) name = "rescue"               
			if(item == 40) name = "escape"            
			if(item == 41) name = "vipsafety"            
			if(item == 42) name = "suit_full"            
			if(item == 43) name = "suit_empty"           
			if(item == 44) name = "suithelmet_full"            
			if(item == 45) name = "suithelmet_empty"      
			if(item == 46) name = "flash_full"           
			if(item == 47) name = "flash_empty"            
			if(item == 48) name = "flash_beam"            
			if(item == 49) name = "train_back"          
			if(item == 50) name = "train_stop"            
			if(item == 51) name = "train_forward1"            
			if(item == 52) name = "train_forward2"            
			if(item == 53) name = "train_forward3"          
			if(item == 54) name = "autoaim_c"            
			if(item == 55) name = "title_half"           
			if(item == 56) name = "title_life"            
			if(item == 57) name = "d_knife"                   
			if(item == 58) name = "d_ak47"                  
			if(item == 59) name = "d_awp"                      
			if(item == 60) name = "d_deagle"            
			if(item == 61) name = "d_flashbang"            
			if(item == 62) name = "d_fiveseven"            
			if(item == 63) name = "d_g3sg1"                
			if(item == 64) name = "d_glock18"            
			if(item == 65) name = "d_grenade"            
			if(item == 66) name = "d_m249"               
			if(item == 67) name = "d_m3"                
			if(item == 68) name = "d_m4a1"               
			if(item == 69) name = "d_mp5navy"            
			if(item == 70) name = "d_p228"               
			if(item == 71) name = "d_p90"                
			if(item == 72) name = "d_scout"               
			if(item == 73) name = "d_sg550"               
			if(item == 74) name = "d_sg552"               
			if(item == 75) name = "d_ump45"          
			if(item == 76) name = "d_usp"                
			if(item == 77) name = "d_tmp"                
			if(item == 78) name = "d_xm1014"            
			if(item == 79) name = "d_skull"               
			if(item == 80) name = "d_tracktrain"            
			if(item == 81) name = "d_aug"                    
			if(item == 82) name = "d_mac10"                
			if(item == 83) name = "d_elite"                
			if(item == 84) name = "d_headshot"               
			if(item == 85) name = "item_battery"            
			if(item == 86) name = "item_healthkit"            
			if(item == 87) name = "item_longjump"           
			if(item == 88) name = "radar"

			//Display_Icon(id ,enable ,name[] ,red,green,blue)
			Display_Icon(id , ICON_FLASH ,name ,0,160,0)
			
			client_print(id, print_chat, "ico %s",name)		
		}
	}
}
public tutorF(id)
{
	if(tutor[id] == 1) tutor[id] = 2
	else if(tutor[id] == 2) tutor[id] = 1
	else if(tutor[id] == 0) tutor[id] = 2
	if(tutor[id] == 1) show_hudmessage(id, "Wyswietlanie informacji ON") 
	if(tutor[id] == 2) show_hudmessage(id, "Wyswietlanie informacji OFF") 
	client_cmd(id, "setinfo ^"_tutor^" ^"%i^"", tutor[id])	
}
public print_dmgF(id)
{
	if(print_dmg[id] == 1) print_dmg[id] = 2
	else if(print_dmg[id] == 2) print_dmg[id] = 1
	else if(print_dmg[id] == 0) print_dmg[id] = 2
	
	if(print_dmg[id] == 1) show_hudmessage(id, "Wyswietlanie obrazen ON") 
	if(print_dmg[id] == 2) show_hudmessage(id, "Wyswietlanie obrazen OFF") 
	client_cmd(id, "setinfo ^"_printdmg^" ^"%i^"", print_dmg[id])	
}

public item_szarza(id)
{
	if(used_item[id]){
		set_hudmessage(0, 0, 255, -1.0, -1.0)
		show_hudmessage(id, "Itemu mozesz uzyc raz na runde")
		return
	}
	set_hudmessage(255, 0, 0, -1.0, 0.01)
	show_hudmessage(id, "SZARZA!!")
	client_cmd(id, "mp3 play sound/heartbeat-01.mp3") 
	used_item[id] = true
	player_b_szarza_time[id] = floatround(halflife_time()) + player_b_szarza[id]
	un_rander(TASK_FLASH_LIGHT+id)
	RemoveFlag(id,Flag_Dazed)
	RemoveFlag(id,Flag_Ignite)
	RemoveFlag(id,Flag_truc)
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
		if(player_class[owner] == MagZ){
			// store team in the grenade
			entity_set_int(ent,EV_INT_team,get_user_team(owner));
		
		
			// give it a blue glow and a blue trail
			set_rendering(ent,kRenderFxGlowShell,0,255,0);
		
			// hack? flag to remember to track this grenade's think
			entity_set_int(ent,EV_INT_bInDuck,1);
		
			// track for when it will explode
			set_task(1.5,"grenade_explode_magz",ent);
		
			return FMRES_SUPERCEDE;
		}	
		return PLUGIN_CONTINUE;
	}
	if(equali(model,"models/w_flashbang.mdl")){
		// not yet thrown
		if(entity_get_float(ent,EV_FL_gravity) == 0.0)
			return FMRES_IGNORED;
	
		new owner = entity_get_edict(ent,EV_ENT_owner);
	
		// check to see if this isn't a frost grenade
		if(player_class[owner] == MagP){
			// store team in the grenade
			entity_set_int(ent,EV_INT_team,get_user_team(owner));
		
		
			// give it a blue glow and a blue trail
			set_rendering(ent,kRenderFxGlowShell,0,0,255);
		
			// hack? flag to remember to track this grenade's think
			entity_set_int(ent,EV_INT_bInDuck,1);
		
			// track for when it will explode
			set_task(1.5,"grenade_explode_magp",ent);
		
			return FMRES_SUPERCEDE;
		}		
		return PLUGIN_CONTINUE;
	}
	
	
	return FMRES_IGNORED;
 }
    // and boom goes the dynamite
 public grenade_explode_magz(ent)
 {
	if(!is_valid_ent(ent))
		return;
		
	// make the smoke
	new origin[3], Float:originF[3];
	entity_get_vector(ent,EV_VEC_origin,originF);
	FVecIVec(originF,origin);

	// get grenade's owner
	new owner = entity_get_edict(ent,EV_ENT_owner);

	if(player_class[owner] == MagZ){
	
		//Find people near and give them health
		message_begin( MSG_BROADCAST, SVC_TEMPENTITY, origin );
		write_byte( TE_BEAMCYLINDER );
		write_coord( origin[0] + 5);
		write_coord( origin[1] );
		write_coord( origin[2] );
		write_coord( origin[0] + 5);
		write_coord( origin[1] + floatround(350.0));
		write_coord( origin[2] + floatround(350.0));
		write_short( sprite_white );
		write_byte( 0 ); // startframe
		write_byte( 0 ); // framerate
		write_byte( 10 ); // life
		write_byte( 10 ); // width
		write_byte( 255 ); // noise
		write_byte( 0 ); // r, g, b
		write_byte( 250 ); // r, g, b
		write_byte( 0 ); // r, g, b
		write_byte( 128 ); // brightness
		write_byte( 8 ); // speed
		message_end();
	
		new entlist[513]
		new numfound = find_sphere_class(ent,"player",350.0,entlist,512)
		for (new i=0; i < numfound; i++)
		{		
			new pid = entlist[i]
				
			if (pid == owner || !is_user_alive(pid))
				continue
				
			if (get_user_team(owner) == get_user_team(pid))
				continue
				
			if (!(pev(pid, pev_flags) & FL_ONGROUND)) continue	
				
			efekt_slow_enta(pid, 5)
		}
		
	}
        
	// get rid of the old grenade
	remove_entity(ent);
 }

   // and boom goes the dynamite
 public grenade_explode_magp(ent)
 {
	if(!is_valid_ent(ent))
		return;
		
	// make the smoke
	new origin[3], Float:originF[3];
	entity_get_vector(ent,EV_VEC_origin,originF);
	FVecIVec(originF,origin);

	// get grenade's owner
	new owner = entity_get_edict(ent,EV_ENT_owner);

	if(player_class[owner] == MagP){
		//Find people near and give them health
		message_begin( MSG_BROADCAST, SVC_TEMPENTITY, origin );
		write_byte( TE_BEAMCYLINDER );
		write_coord( origin[0] + 5);
		write_coord( origin[1] );
		write_coord( origin[2] );
		write_coord( origin[0] + 5);
		write_coord( origin[1] + floatround(350.0));
		write_coord( origin[2] + floatround(350.0));
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
		write_byte( 8 ); // speed
		message_end();
	
		new entlist[513]
		new numfound = find_sphere_class(ent,"player",350.0,entlist,512)
		for (new i=0; i < numfound; i++)
		{		
			new pid = entlist[i]
				
			if (pid == owner || !is_user_alive(pid))
				continue
				
			if (get_user_team(owner) == get_user_team(pid))
				continue
								
			new Float:id_origin[3]
			new Float:pid_origin[3]
			new Float:delta_vec[3]
			
			pev(ent,pev_origin,id_origin)
			pev(pid,pev_origin,pid_origin)
			
			
			delta_vec[x] = (pid_origin[x]-id_origin[x])+10
			delta_vec[y] = (pid_origin[y]-id_origin[y])+10
			delta_vec[z] = (pid_origin[z]-id_origin[z])+300
			
			if(player_b_szarza_time[pid] < floatround(halflife_time())){
				set_pev(pid,pev_velocity,delta_vec)
					
				set_pev(pid,pev_velocity,delta_vec)
				shake(pid)	
				
				set_user_gravity(pid,0.1)
				set_task(0.1, "space_f", pid)
				set_task(0.2, "space_f", pid)
				set_task(0.5, "space_f", pid)
				set_task(0.7, "space_f", pid)
			}
			set_task(1.0, "set_gravitychange", pid)
		}	
	}        
	// get rid of the old grenade
	remove_entity(ent);
 }

public Witch_evo(id)
{		
	set_task(2.5, "GiveWeaponWitch", id)

	if(player_class[id]==Witch && random_num(0,1)==0){
		static Float:origin[3]
		pev(id, pev_origin, origin)
		new ent
		static classname[32]	
		new pln = get_playersnum() 
		if(pln > 12) pln  = 12
		while((ent = fm_find_ent_in_sphere(ent, origin, 800.0 )) != 0) 
		{
			pev(ent, pev_classname, classname, 31)
			if(equali(classname, "fake_corpse")){
				if(!fm_is_valid_ent(ent))
				{
					failed_revive(id)
					return 
				}

				new body = ent
				new trup = pev(ent,pev_owner)
				if(is_user_connected(trup)){
					new args[2]
					args[1]=id
					args[0]=trup
					new lb_team = get_user_team(trup)
					new team = get_user_team(id)
					findemptyloc(body, 50.0)
					if(!(lb_team != 1 && lb_team != 2) && !is_user_alive(trup))
					{
						if(team==lb_team){
							new exp = calc_award_goal_xp(id,get_cvar_num("diablo_xpbonus2"), 0) * pln/ 3
							Give_Xp(id,exp)	
							player_wys[id]=1
							respawned[trup] = 1
							set_task(0.1, "task_respawn", TASKID_RESPAWN + trup,args,2)
							change_health(trup,1,0,"")

							set_task(1.5,"after_spawn",trup) 	
							fm_set_user_health(trup, 1)	
							set_user_godmode(trup, 1)
							god[trup] = 1
							new newarg[1]
							newarg[0]=trup
							set_task(3.0,"god_off",trup+95123,newarg,1)
						}
					}
					fm_remove_entity(body)
				}			
			}
		}
	}
	
}

public GiveWeaponWitch(id){
	fm_give_item(id, "weapon_mp5navy")
	give_item(id,"ammo_9mm")
	give_item(id,"ammo_9mm")	
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
	new zgloszenie = 0

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
		return PLUGIN_HANDLED_MAIN
	}
	if(player_mute[id] > 0){
		client_print(id, print_chat, "Pisanie zablokowane do dnia %s, przekroczyles liczbe banow za obraze", date_long[id])
		return PLUGIN_HANDLED_MAIN
	}

	return PLUGIN_CONTINUE;
}

public recalculateDamRed(id)
{
	player_damreduction[id] = (50.0057*(1.0-floatpower( 2.0182, -0.03598*float(player_agility[id])))/100)
	
	if (player_class[id] == Mnich)
	{
		player_damreduction[id] = (200.0057*(1.0-floatpower( 2.0182, -0.013*float(player_agility[id])))/100) * 0.4 + 0.2
	}
}

public MWNami(id)
{
	new czas = 10 - player_intelligence[id]/25 
	if(czas<5)czas=5
	czas = czas - (czas *  player_naszyjnikczasu[id]/ 100)
	if (halflife_time()-bowdelay[id] <= czas && player_diablo[id]==0 && player_she[id]==0)
	{
		
		show_hudmessage(id, "Ten skill moze byc uzyty co kazde %i sekundy", czas)
		return PLUGIN_CONTINUE
	}
	player_naladowany[id] = 1
	bowdelay[id]  = halflife_time()
	
	new mm = 5 + player_intelligence[id] / 20
	new Float:mnoz = (1 + player_intelligence[id] / 100)*1.0
	
	player_timed_speed[id] = halflife_time() +( 4.0 * mnoz)
	set_task((4.1 * mnoz), "set_speedchange", id)
	refill_ammo(id, 0)
	set_speedchange(id)

	new curTarget = id
	for(new iter = 0; iter<mm; iter++){
		new entlist[513]
		new numfound = find_sphere_class(curTarget,"player",400.0,entlist,512)
		for (new i=0; i < numfound; i++)
		{		
			new pid = entlist[i]
			if(i == numfound - 1 && iter==0){ 
				i = 0
				iter++
			}
				
			if (pid == id || !is_user_alive(pid)) continue
			
			if(nami_vic[pid] > 0) continue
			
			if(!fm_is_ent_visible(pid,id) && !fm_is_ent_visible(pid,curTarget)) continue
			
			if(!UTIL_In_FOV(id,pid) && iter==0) continue;
			
			if (get_user_team(id) == get_user_team(pid)){
				change_health(pid, floatround(20 * mnoz), id, "world")
				player_timed_speed[pid] = halflife_time() + (3.0 * mnoz)
				refill_ammo(pid, 0)				
			}else{
				new red = dexteryDamRedPerc[pid]
				new dam = floatround((10 * mnoz) - ((10 * mnoz) * red /100))
				change_health(pid, -dam, id, "world")
				change_health(id, floatround(10 * mnoz), id, "world")
				player_tarczapowietrza[id] += 3
				player_timed_slow[pid] = halflife_time() + (3.0 * mnoz)
				efekt_slow_lodu(pid,1)				
			}
			set_task((3.1 * mnoz), "set_renderchange", pid)
			set_task((3.1 * mnoz), "set_speedchange", pid)
			set_speedchange(pid)
			set_renderchange(pid)
			new Hit[3]
			get_user_origin(pid,Hit)
			strumien(curTarget, Hit[0], Hit[1], Hit[2], 0, 0, 255)
			
			new Float:forigin[3], origin[3]
			pev(curTarget,pev_origin,forigin)	
			FVecIVec(forigin,origin)
							
			//Find people near and give them health
			message_begin( MSG_BROADCAST, SVC_TEMPENTITY, origin );
			write_byte( TE_BEAMCYLINDER );
			write_coord( origin[0] );
			write_coord( origin[1] );
			write_coord( origin[2] );
			write_coord( origin[0] );
			write_coord( origin[1] + floatround(400.0) );
			write_coord( origin[2] + floatround(400.0) );
			write_short( sprite_white );
			write_byte( 0 ); // startframe
			write_byte( 0 ); // framerate
			write_byte( 10 ); // life
			write_byte( 10 ); // width
			write_byte( 255 ); // noise
			write_byte( 50 ); // r, g, b
			write_byte( 50 ); // r, g, b
			write_byte( 250 ); // r, g, b
			write_byte( 58 ); // brightness
			write_byte( 5 ); // speed
			message_end();

			nami_vic[pid] = id
			curTarget = pid
			break;
		}
		
	}
	for(new i=0; i<33; i++) {
		if(nami_vic[i] == id)nami_vic[i] = 0
	} 
	return PLUGIN_CONTINUE
}


stock create_velocity_vector(victim,attacker,Float:velocity[3])
{
	if(!is_user_alive(victim) || !is_user_alive(attacker))
		return 0;

	new Float:vicorigin[3];
	new Float:attorigin[3];
	entity_get_vector(victim   , EV_VEC_origin , vicorigin);
	entity_get_vector(attacker , EV_VEC_origin , attorigin);

	new Float:origin2[3]
	origin2[0] = vicorigin[0] - attorigin[0];
	origin2[1] = vicorigin[1] - attorigin[1];

	new Float:largestnum = 0.0;

	if(floatabs(origin2[0])>largestnum) largestnum = floatabs(origin2[0]);
	if(floatabs(origin2[1])>largestnum) largestnum = floatabs(origin2[1]);

	origin2[0] /= largestnum;
	origin2[1] /= largestnum;

	velocity[0] = ( origin2[0] * (20* 3000) ) / get_entity_distance(victim , attacker);
	velocity[1] = ( origin2[1] * (20 * 3000) ) / get_entity_distance(victim , attacker);
	if(velocity[0] <= 20.0 || velocity[1] <= 20.0)
		velocity[2] = random_float(200.0 , 275.0);

	return 1;
}


public dag_arc(id)
{
	new czas = 25 - player_intelligence[id]/5	
	if(czas<10)czas=10
	czas = czas - (czas *  player_naszyjnikczasu[id]/ 100)
	if (halflife_time()-bowdelay[id] <= czas && player_diablo[id]==0 && player_she[id]==0)
	{
		
		show_hudmessage(id, "Ten skill moze byc uzyty co kazde %i sekundy", czas)
		return PLUGIN_CONTINUE
	}
	hudmsg(id,2.0,"Moc uzyta!")

	player_naladowany2[id] = 1
	add_stomp_magz(id)

	bowdelay[id]  = halflife_time()
	return PLUGIN_HANDLED
}

public add_bonus_space_arc(id)
{
	new origin[3]
	get_user_origin(id,origin)	
	new dam = player_intelligence[id]/25
	if(dam > 50) dam=50 		
	message_begin(MSG_ONE , get_user_msgid("ScreenShake") , {0,0,0} ,id)
	write_short( 1<<14 );
	write_short( 1<<12 );
	write_short( 1<<14 );
	message_end();
	new entlist[513]
	new numfound = find_sphere_class(id,"player",500.0+player_intelligence[id]/2,entlist,512)
	new ran = 4
	if(player_intelligence[id] > 25) ran = 5
	if(player_intelligence[id] > 50) ran = 3
	if(player_intelligence[id] > 100) ran = 2
	if(player_intelligence[id] > 200) ran = 1
	
	if (is_user_alive(id)){
		for (new i=0; i < numfound; i++)
		{		
			new pid = entlist[i]
			if (pid == id || !is_user_alive(pid))
				continue
				
			if (get_user_team(id) == get_user_team(pid))
				continue
				
			if (is_user_alive(pid) && random_num(0,ran)==0) DropWeapon(pid)
			
			
			new Float:id_origin[3]
			new Float:pid_origin[3]
			new Float:delta_vec[3]
		
			pev(id,pev_origin,id_origin)
			pev(pid,pev_origin,pid_origin)
		
		
			delta_vec[x] = (pid_origin[x]-id_origin[x])+10
			delta_vec[y] = (pid_origin[y]-id_origin[y])+10
			delta_vec[z] = (pid_origin[z]-id_origin[z])+500
		
			set_pev(pid,pev_velocity,delta_vec)
						
			message_begin(MSG_ONE , get_user_msgid("ScreenShake") , {0,0,0} ,pid)
			write_short( 1<<14 );
			write_short( 1<<12 );
			write_short( 1<<14 );
			message_end();
		
			dam -= player_dextery[pid]
			if(dam < 1) dam=1 
			if(player_class[pid]==Orc) 
				change_health(pid,-dam -get_maxhp(pid)*(2 + 4 - ran)/1000,id,"world")
			else 
				change_health(pid,-dam -get_maxhp(pid)*(2 + 4 - ran)/100,id,"world")
			
			set_gravitychange(pid)
		}
	
	}
	return PLUGIN_CONTINUE
}

public stalkPompa(id)
{
	if(player_class[id]==Stalker && is_user_connected(id)) {			
		fm_give_item(id, "weapon_xm1014")
		give_item(id, "ammo_buckshot")
		give_item(id, "ammo_buckshot")
		give_item(id, "ammo_buckshot")
	}
}
public DropWeapon(id)
{
	if(!is_user_connected(id) || !is_user_alive(id) || on_knife[id]) return;
	if((player_b_nieust2[id] > 0 && get_user_health(id) < player_b_nieust2[id]) || player_b_nieust[id] >= 100 || player_b_szarza_time[id] > floatround(halflife_time()))  return;
	new clip,ammo
	new weapon=get_user_weapon(id,clip,ammo)	
	if(weapon == CSW_KNIFE) return;
	if(forceEvent==3){
		client_cmd(id, "lastinv");
	}else{
	client_cmd(id, "drop");
	//engclient_cmd(id, "drop");
	
	set_task(3.0, "stalkPompa", id);
	}
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
	diablo_redirect_check_height(maxLvlPlayer)
}

public OrcJump(id)
{
	new flags = pev(id,pev_flags) 
	if(flags & FL_ONGROUND) 
	{ 
		set_pev ( id, pev_flags, flags-FL_ONGROUND ) 
		player_naladowany[id] =  floatround(halflife_time()) +20
					
		new Float:va[3],Float:v[3] 
		entity_get_vector(id,EV_VEC_v_angle,va) 
		v[0]=floatcos(va[1]/180.0*M_PI)*440.0 
		v[1]=floatsin(va[1]/180.0*M_PI)*440.0 
		v[2]=400.0 
		entity_set_vector(id,EV_VEC_velocity,v) 
		falling[id] = true
		earthstomp[id] = 1
		
		write_hud(id)
	} 	
}


public OrcJumpBonus(id)
{
	message_begin(MSG_ONE , get_user_msgid("ScreenShake") , {0,0,0} ,id)
	write_short( 1<<14 );
	write_short( 1<<12 );
	write_short( 1<<14 );
	message_end();
	new entlist[513]
	new dam = 25 + player_intelligence[id]/ 10;
	new numfound = find_sphere_class(id,"player",250.0,entlist,512)					
	for (new i=0; i < numfound; i++)
	{		
		new pid = entlist[i]							
		if (pid == id || !is_user_alive(pid)) continue	
		if (get_user_team(id) == get_user_team(pid)) continue
		if (!(pev(pid, pev_flags) & FL_ONGROUND)) continue		
		new Float:id_origin[3]
		new Float:pid_origin[3]
		new Float:delta_vec[3]
		pev(id,pev_origin,id_origin)
		pev(pid,pev_origin,pid_origin)						
		delta_vec[x] = (pid_origin[x]-id_origin[x])+30
		delta_vec[y] = (pid_origin[y]-id_origin[y])+30
		delta_vec[z] = (pid_origin[z]-id_origin[z])+300
		set_pev(pid,pev_velocity,delta_vec)
							
		message_begin(MSG_ONE , get_user_msgid("ScreenShake") , {0,0,0} ,pid)
		write_short( 1<<14 );
		write_short( 1<<12 );
		write_short( 1<<14 );
		message_end();
		new red = dexteryDamRedPerc[pid]
		dam = dam - (dam * red /100)
		if (dam < 10) dam = 10
		change_health(pid,-dam,id,"world")	
		if(player_lvl[id]>prorasa) efekt_slow_lodu(pid,5)	
	}	
	earthstomp[id] = 0
}

stock Effect_waz(id,attacker,damage)
{
	hudmsg( id,3.0,"Jestes zatruty!")
	Display_Fade( id,1<<14,1<<14 ,1<<16,255,255,255,30)
	
	new newarg[3]
	newarg[0]=attacker
	newarg[1]=damage
	newarg[2]=id
	set_task(5.0,"waz",id+951423,newarg,3)
	AddFlag(id,Flag_truc)	
}

public waz(newarg[])
{
	if( HasFlag(newarg[2], Flag_truc))
	{
		RemoveFlag(newarg[2], Flag_truc)
		change_health(newarg[2],-newarg[1],newarg[0],"world")
		Display_Fade( newarg[2],1<<14,1<<14 ,1<<16,255,255,255,30)
		
		new origin[3]
		get_user_origin(newarg[2],origin)
		
		//Decals
		message_begin( MSG_BROADCAST,SVC_TEMPENTITY)
		write_byte( TE_GUNSHOTDECAL ) // decal and ricochet sound
		write_coord( origin[0] ) //pos
		write_coord( origin[1] )
		write_coord( origin[2] )
		write_short (0) // I have no idea what thats supposed to be
		write_byte (random_num(199,201)) //decal
		message_end()
	}
}


public Prethink_Blink2(id)
{
	if( get_user_button(id) & IN_ATTACK2 && !(get_user_oldbutton(id) & IN_ATTACK2) && is_user_alive(id) && !(get_user_button(id) & IN_DUCK)) 
	{		
		if(czas_rundy + 10 > floatround(halflife_time())){
			set_hudmessage(255, 0, 0, -1.0, 0.01)
			show_hudmessage(id, "Skilla mozesz uzywac 10 sek po starcie rundy")
			
			return PLUGIN_HANDLED
		}
		if (on_knife[id] && player_class[id]!=Zmij)
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
				new dam = 50+ player_lvl[a]/4 + player_intelligence[id]/10
				new red = dexteryDamRedPerc[a]
				dam = dam - (dam * red /100)
				if(dam<10) dam=10
				change_health(a,-dam,id,"grenade")
				Display_Fade(id,2600,2600,0,255,0,0,15)				
			}
		}
	}
}
stock is_ent_c4( ent )
{
	if (!pev_valid(ent))
		return 0
	
	new model[64]
	pev(ent, pev_model, model, 63)
	
	if (contain(model, "backpack")!=-1 || contain(model, "c4")!=-1)
		return 1
	
	return 0
}

public fwSetModel(ent, model[]){
	if(forceEvent!=3) return FMRES_IGNORED;
	new szClass[32];
	pev(ent, pev_classname,szClass, 31);
	if(equal(szClass,"weaponbox") && !is_ent_c4(ent)){
		dllfunc(DLLFunc_Think, ent);
		return FMRES_HANDLED;
	}else if(equal(szClass,"weapon_shield")){
		engfunc(EngFunc_RemoveEntity, ent);
		return FMRES_HANDLED;
	}
	return FMRES_IGNORED;
}
public sp_com(id){
	if(forceEvent!=3) return;
	new svIndex[32] 
	num_to_str(id,svIndex,32)
	set_task(0.5,"respawn",0,svIndex,32) 	
	set_task(1.5,"after_spawn",id) 
}
