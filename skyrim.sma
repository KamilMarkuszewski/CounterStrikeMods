
#define PLUGIN "skyrim"
#define VERSION "1.0"
#define AUTHOR "Kajt [core Miczu, GuTeK]"



#define CS_MAPZONE_BUY 			(1<<0)
#define CS_MAPZONE_BOMBTARGET 		(1<<1)
#define CS_MAPZONE_HOSTAGE_RESCUE 	(1<<2)
#define CS_MAPZONE_ESCAPE		(1<<3)
#define CS_MAPZONE_VIP_SAFETY 		(1<<4)



#include <amxmodx>
#include <amxmisc>
#include <engine>
#include <fakemeta> 
#include <cstrike>
#include <fun>
#include <sqlx>
#include <csx> 
#include <hamsandwich> 
#include <fakemeta_util> 


// ----------------------STALE---------------------------------------------------------------------

#define RESTORETIME 30.0	 //How long from server start can players still get their item trasferred (s)
#define MAX 32			 //Max number of valid player entities

//#define CHEAT 1		 //Cheat for testing purposes
#define CS_PLAYER_HEIGHT 72.0
#define GLOBAL_COOLDOWN 0.5
#define TASK_GREET 240
#define TASK_HUD 120
#define TASK_HOOK 360
#define MAX_PLAYERS 32
#define BASE_SPEED 	90.0
#define GLUTON 95841
#define MAXTASKC 4756
//new weapon, clip, ammo
#define x 0
#define y 1
#define z 2

#define TASK_CHARGE 100
#define TASK_NAME 48424
#define TASK_FLASH_LIGHT 81184
#define TASKID_BOUND1	1467
#define TASKID_BOUND2 	1417
#define TASKID_BOUND3 	1497
#define TASKID_BOUND4 	1527
#define TASKID_BOUND5 	1557
#define TASKID_DETECT 	1597
#define TASKID_ODB1 	1637
#define TASKID_ABSORB 	1667
#define TASKID_ODB2 	1697
#define TASKID_ILU1 	1727
#define TASKID_ILU2 	1757
#define TASKID_ILU5 	1797
#define TASKID_KAM 	1827
#define TASKID_OBC 	1857
#define TASKID_CALUS	1881
#define TASKID_CALUS2	1911
#define TASKID_SILENCE	1941
#define TASKID_SO	1981
#define TASKID_O	1021
#define TASKID_MUSIC	1051
#define TASKID_smth	1071

#define TASKID_REVIVE 	1337
#define TASKID_RESPAWN 	1338
#define TASKID_CHECKRE 	1339
#define TASKID_CHECKST 	13310
#define TASKID_ORIGIN 	13311
#define TASKID_SETUSER 	13312
#define TASKID_GHOST	172

#define pev_zorigin	pev_fuser4
#define seconds(%1) ((1<<12) * (%1))

#define OFFSET_CAN_LONGJUMP    356

#define MAX_FLASH 15		//pojemnosc barejii maga (sekund)
#define	FL_WATERJUMP	(1<<11)	// player jumping out of water
#define	FL_ONGROUND	(1<<9)	// At rest / on the ground
// ----------------------ZMIENNE-------------------------------------------------------------------
new avg_lvl =0 
new avg_lvlTT =0 
new avg_lvlCT =0 
new player_sid_pass[33][64]
new player_pass_pass[33][64]
new u_sid[33] = 0

new nowicjusz = 0
new uczen = 24
new czeladnik = 49
new ekspert = 74
new mistrz = 99


new player_noz[33] = 0
new player_niesie[33] = 0
new player_niesie2[33] = 0
new player_zloto[33] = 0
//-------------------------------------
new vip_spr[33]=0

new player_szczescie[33] = 0
new player_wytrzymalosc[33] = 0
new player_szybkosc[33] = 0
new player_zwinnosc[33] = 0
new player_inteligencja[33] = 0
new player_sila_woli[33] = 0
new player_sila[33] = 0
new wamps[33] = 0
//-------------------------------------

new player_a_szczescie[33] = 0
new player_a_wytrzymalosc[33] = 0
new player_a_szybkosc[33] = 0
new player_a_zwinnosc[33] = 0
new player_a_inteligencja[33] = 0
new player_a_sila_woli[33] = 0
new player_a_sila[33] = 0

new isevent = 0

new player_doda_szczescie[33] = 0
new player_doda_wytrzymalosc[33] = 0
new player_doda_szybkosc[33] = 0
new player_doda_zwinnosc[33] = 0
new player_doda_inteligencja[33] = 0
new player_doda_sila_woli[33] = 0
new player_doda_sila[33] = 0

new player_nxt_update[33] = 0

//-------------------------------------


new player_ostrze[33] = 0
new player_bron_lekka[33] = 0
new player_bron_ciezka[33] = 0
new player_ciezki_pancerz[33] = 0
new player_platnerstwo[33] = 0
new player_blok[33] = 0



new player_skradanie[33] = 0
new player_atletyka[33] = 0
new player_akrobatyka[33] = 0
new player_lekki_pancerz[33] = 0
new player_celnosc[33] = 0
new player_handel[33] = 0



new player_przywrocenie[33] = 0
new player_iluzja[33] = 0
new player_przywolanie[33] = 0
new player_mistycyzm[33] = 0
new player_przemiana[33] = 0
new player_zniszczenie[33] = 0

//-------------------------------------


new player_a_ostrze[33] = 0
new player_a_bron_lekka[33] = 0
new player_a_bron_ciezka[33] = 0
new player_a_ciezki_pancerz[33] = 0
new player_a_platnerstwo[33] = 0
new player_a_blok[33] = 0



new player_a_skradanie[33] = 0
new player_a_atletyka[33] = 0
new player_a_akrobatyka[33] = 0
new player_a_lekki_pancerz[33] = 0
new player_a_celnosc[33] = 0
new player_a_handel[33] = 0



new player_a_przywrocenie[33] = 0
new player_a_iluzja[33] = 0
new player_a_przywolanie[33] = 0
new player_a_mistycyzm[33] = 0
new player_a_przemiana[33] = 0
new player_a_zniszczenie[33] = 0


//-------------------------------------
new player_czar_przywrocenie[33] = -1
new player_czar_iluzja[33] = -1
new player_czar_przywolanie[33] = -1
new player_czar_mistycyzm[33] = -1
new player_czar_przemiana[33] = -1
new player_czar_zniszczenie[33] = -1


//-------------------------------------
new player_speedbonus[33] = 0	// bonus do szybkosci z itemow
new player_grawitacja[33] = 0	// bonus do grawitacji


new player_autob[33] = 0
new player_mp[33] = 0
new player_sp[33] = 0

new player_max_hp[33] = 0
new player_max_mp[33] = 0
new player_max_sp[33] = 0

//-------------------------------------

new player_odpornosc_truc[33] = 0
new player_odpornosc_ogien[33] = 0
new player_odpornosc_mroz[33] = 0
new player_odpornosc_shock[33] = 0

new player_week_truc[33] = 0
new player_week_ogien[33] = 0
new player_week_mroz[33] = 0
new player_week_shock[33] = 0

new player_absorb_mana[33] = 0
new player_odbij_mana[33] = 0
new player_odbij_zwykle[33] = 0

//-------------------------------------
new player_zaklecie[33] = 0
new player_przegladana_magia_szkola[33] = 0
new player_przegladana_magia_nr[33] = 0
new player_staty[33]=0
new czas_msg_id[33]=0
new czas_check_id[33]=0
new czas_regeneracji[33] = 0
new Float:czas_sprawdzania[33] = 0.0
new knifedelay[33] = 0
new player_specjal_used[33] = 0
new player_b_inv_ilu[33] = 0
new player_b_inv_ilu2[33] = 0
new player_fast[33] = 0
new player_bound[33] = 0
new player_detect[33] = 0
new silence[33] = 0
new paraliz[33] = 0
new g_FOV[33]=0;

new obciaz_time[33]=0
new spowolnij_time[33] = 0
new smal_rozb_time[33] = 0
new silence_time[33] = 0
new paraliz_time[33] = 0
new rozb_time[33] = 0


new obciaz[33]=0
new spowolnij[33] = 0
new smal_rozb[33] = 0

new no_cash[33] = 0


new highlvl[33] = 0

new rozb[33] = 0
new Float:week_magic[33] = 1.0
new Float:odpornosc_magic[33] = 1.0
new roundXP[33]=0
new freeze_ended2= 0


new player_obc_poc[33] = 0
new player_stop_poc[33]=0
new pomoc_off[33]=0	
enum {NONE = 0,specjalne,przywrocenia,iluzji,przywolania,mistycyzmu,przemiany,zniszczenia}


new player_blogoslawienstwo[33] = 0
new player_blogoslawienstwo_nxt[33] = 0

new Blogoslawienstwa[][] = {"Brak", "Akatosh", "Akray", "Diabella", "Julianos", "Kynareth", "Mara", "Stendarr", "Tiber Septim", "Zenithar", "Mephala", "Molag Bal", "Sheogorath", "Mehrunes Dagon"}


enum { NONE = 0,
Luk,krew,pocalunek,waz,cien,wieza,

przywr1,przywr2,przywr3,przywr4,przywr5,przywr6,
iluzja1,iluzja2,iluzja3,iluzja4,iluzja5,iluzja6,
przyw1,przyw2,przyw3,przyw4,przyw5,przyw6,
mis1,mis2,mis3,mis4,mis5,mis6,
przem1,przem2,przem3,przem4,przem5,przem6,
destr1,destr2,destr3,destr4,destr5,destr6
}
new Zaklecia[][] ={"Nie wybrane",
"Przywolanie Luku","Krew Polnocy","Pocalunek","Moc Weza","Ksiezycowy Cien","Wieza",

"Uzdrowienie","Slowo mocy","Silne uzdrowienie","Slowo zycia","Potezne uzdrowienie","none",
"Pomniejsze ukrycie","Ukrycie","Kameleon","potezne Ukrycie","Duch","none",
"Zestaw zabojcy","Pomniejsze przywolanie","Srednie przywolanie","Potezne przywolanie","Zestaw battle maga","none",
"Rozproszenie","Wykrycie zycia","Absorbcja Magii","Odbicie Magii","Potezne odbicie","none",
"Obciazenie","Spowolnienie","Wyciszenie","Pomniejsze rozbrojenie","Rozbrojenie","Paraliz",
"Flara","Dezintegracja pancerza i rozproszenie"," Podatnosc","Sniezna kula","Blyskawica","Wybuch Ognia"
 }
new Zaklecia_cena[] = {0,
0,0,0,0,0,0,

5,10,15,20,30,0,
5,10,15,20,40,0,
5,10,15,20,30,0,
5,10,15,40,50,0,
10,5,10,40,40,50,
5,5,10,15,40,50,
}
new Zaklecia_mana[] = {0,
1,20,1,20,20,20,

50,100,120,180,230,0,
50,100,150,200,250,0,
50,90,120,180,230,0,
50,100,150,200,250,0,
80,50,50,170,170,230,
50,50,100,150,200,250
}

new Zaklecia_ma[33][43]

new Zaklecia_umiej[] = {0,
666,666,666,666,666,666,

1,25,50,75,100,0,
1,25,50,75,100,0,
1,25,50,75,100,0,
1,25,50,75,100,0,
1,1,25,50,75,100,
1,1,25,50,75,100
}
new dragon[33]=0


enum { NONE = 0, Czeladnik,Atronach,Dama,Lord, Kochanek, Mag, Waz, Cien, Rumak, Zlodziej, Wojownik, Wieza}
new Znak[][] = { "Nie wybrany","Czeladnik","Atronach","Dama","Lord", "Kochanek", "Mag", "Waz", "Ksiezycowy cien", "Rumak", "Zlodziej", "Wojownik", "Wieza"}
new player_znak[33] = 0

enum { NONE = 0,  Arag, Kha, Ces, Ork, Wysoki, Breton, Mroczny, Bosmer, Redgard, Nord}
new race_heal[]  = { 100,50,50,50,50,50, 50,50,50,50,50}	// hp na start				
new Race[][] = { "Nie wybrana","Argonian","Khajiit","Cesarski","Ork", "Wysoki Elf", "Breton", "Mroczny Elf", "Bosmer", "Redgard", "Nord"}
new player_class[33]

enum {NONE = 0,knife,usp, glock18,
	p228, fiveseven,elites,deagle,
	m3,xm1014,tmp,mac10,
	ump45,mp5navy, p90,scout,
	famas,galil,aug,sg552,
	m4a1,ak47,m249,awp,
	sg550,g3sg1}
new bronie_waga[] = {0,0,0,0,
	20,21,22,25,
	30,35,40,50,
	55,60,65,69,
	70,75,80,85,
	95,100,105,110,
	140,149}
	
new bronie_cena[] = {0,0,0,0, 600, 750,1000,650,1700,3000,1250,1400,1700,1500,2350,2750,2000,2000,3500,3500, 3100,2500,5750,4750,4200,5000}

new mikstura[33] = 0

new Mikstura_n[][] = { "Brak",
"Tarcza porazen","Tarcza ognia","Tarcza mrozu","Kameleon", "Leczenie Parali¿u", "Rozproszenie", "Leczenie trucizny", "Lekkosc", "Premia do zdrowia", "Premia do kondycji", "Premia do many", "Przywrocenie zdrowia", "Przywrocenie kondycji", "Przywrocenie many", "Ludzka krew",
"Silna Tarcza porazen","Silna Tarcza ognia","Silna Tarcza mrozu","Silny Kameleon", "Silna Lekkosc", "Silna Premia do zdrowia", "Silna Premia do kondycji", "Silna Premia do many", "Silne Przywrocenie zdrowia", "Silne Przywrocenie kondycji", "Silne Przywrocenie many", "Wykrycie zycia", "Skooma"
}

new const sounds_cast[][] = {
"sound/runda/oblivion/specjal_cast.mp3",
"sound/runda/oblivion/restoration_cast.mp3",
"sound/runda/oblivion/illusion_cast.mp3",
"sound/runda/oblivion/conjuration_cast.mp3",
"sound/runda/oblivion/mysticism_cast.mp3",
"sound/runda/oblivion/alteration_cast.mp3",
"sound/runda/oblivion/destruction_cast.mp3"
} 

new const sounds_fail[][] = {
"sound/runda/oblivion/specjal_fail.mp3",
"sound/runda/oblivion/restoration_fail.mp3",
"sound/runda/oblivion/illusion_fail.mp3",
"sound/runda/oblivion/conjuration_fail.mp3",
"sound/runda/oblivion/mysticism_fail.mp3",
"sound/runda/oblivion/alteration_fail.mp3",
"sound/runda/oblivion/destruction_fail.mp3"
} 

enum { fire = 0, frost, shock, magia,boweq, bowshot,lvl_up,book_open,gold,znika}
new const sounds_hit[][] = {
"sound/runda/oblivion/fireball_hit.mp3",
"sound/runda/oblivion/frost_hit.mp3",
"sound/runda/oblivion/shock_hit.mp3",
"sound/runda/oblivion/spl_alteration_hit.mp3",
"sound/runda/oblivion/bow_equip.mp3",
"sound/runda/oblivion/bowshoot.mp3",
"sound/runda/oblivion/lvl_up.mp3",
"sound/runda/oblivion/book_open.mp3",
"sound/runda/oblivion/gold.mp3",
"sound/runda/oblivion/itm_bounddisappear.mp3"
} 

new Basepath[128]	//Path from Cstrike base directory
new Float:agi=BASE_SPEED


new zal[33] = 0

new round_status
new DemageTake[33]
new DemageTake1[33]

new graczy

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


new mierzy = 0
new g_haskit[MAX+1]
new Float:g_revive_delay[MAX+1]
new Float:g_body_origin[MAX+1][3]
new bool:g_wasducking[MAX+1]


new g_msg_bartime
new g_msg_screenfade
new g_msg_statusicon
new g_msg_clcorpse


new cvar_revival_health



new attacker
new attacker1
new flashlight[33]
new flashbattery[33]
new flashlight_r
new flashlight_g
new flashlight_b

new planter
new defuser



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
new c4state[33]


new fired[33]
new bool:ghost_check[33]
new ghosttime[33]
new ghoststate[33]
new respawned[33] 

new sprite_blood_drop = 0
new sprite_blood_spray = 0
new sprite_gibs = 0
new sprite_white = 0


new sprite_fire3 = 0
new sprite_fire4 = 0

new sprite_boom = 0
new sprite_line = 0
new sprite_lgt = 0

new sprite_ignite = 0
new sprite_ignite2 = 0
new sprite_ignite3 = 0
new sprite_smoke = 0
new player_xp[33] = 0		//Holds players experience
new player_lvl[33] = 1			//Holds players level
new player_point_u[33] = 0		//Holds players level points
new player_point_a[33] = 0		//Holds players level points



new Float:player_damreduction[33]

new Float:player_huddelay[33]
new player_vip[33] = 0


//Item attributes



new player_b_inv[33] = 1		//Invisibility bonus


new player_b_theif[33] = 1	//Amount of money to steal
new player_b_respawn[33] = 1	//Chance to respawn upon death
new player_b_explode[33] = 1	//Radius to explode upon death
new player_b_heal[33] = 1	//Ammount of hp to heal each 5 second
new player_b_gamble[33] = 1	//Random skill each round : value = vararity
new player_b_blind[33] = 1	//Chance 1/Value to blind the enemy
new player_b_fireshield[33] = 1	//Protects against explode and grenade bonus 




new player_b_ghost[33] = 1	//Ability to walk through stuff








new player_b_jumpx[33] = 1	//Ability to double jump



new skinchanged[33]
new player_dc_name[33][99]	//Information about last disconnected players name



new player_tarczam[33] = 0
new player_skin[33] = 0











new player_wys[33]
new player_expwys[33]=0

/////////////////////////////////////////////////////////////////////
new player_ultra_armor[33]
new player_ultra_armor_left[33]
/////////////////////////////////////////////////////////////////////

new Float:player_b_oldsen[33]	//Players old sens
new bool:player_b_dagfired[33]	//Fired dagoon?


new jumps[33]			//Keeps charge with the number of jumps the user has made
new bool:dojump[33]		//Are we jumping?
new item_boosted[33]		//Has this user boosted his item?
new earthstomp[33]

new gravitytimer[33]
new mocrtime[33]

new czas_rundy = 0
new item_durability[33]	//Durability of hold item

new DragonM[] 	= "models/player/dragon/dragon.mdl"


new CTSkins[4][]={"sas","gsg9","urban","gign"}
new TSkins[4][]={"arctic","leet","guerilla","terror"}
new SWORD_VIEW[]         = "models/diablomod/v_knife.mdl" 
new SWORD_PLAYER[]       = "models/diablomod/p_knife.mdl" 

new DR_VIEW[]         = "models/diablomod/v_drag.mdl" 
new ZAB_VIEW[]         = "models/diablomod/nozeklas/zab2/v_knife.mdl" 
new PAL_VIEW[]         = "models/diablomod/nozeklas/pal/v_knife.mdl" 
new BARB_VIEW[]         = "models/diablomod/nozeklas/barb/v_knife.mdl" 
new NINJA_VIEW[]         = "models/diablomod/nozeklas/ninja/v_knife.mdl" 
new ARCHEOLOG_VIEW[]         = "models/diablomod/nozeklas/archeolog/v_knife.mdl" 
new MAGIC_VIEW[]         = "models/diablomod/nozeklas/magic/v_knife.mdl" 
new KAPLAN_VIEW[]         = "models/diablomod/nozeklas/kaplan/v_knife.mdl" 
new ORC_VIEW[]         = "models/diablomod/nozeklas/orc/v_knife.mdl" 
new MAG_VIEW[]         = "models/diablomod/nozeklas/mag/v_knife.mdl" 
new NECRO_VIEW[]         = "models/diablomod/nozeklas/necro/v_knife.mdl" 
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

new cbow_VIEW2[]  = "models/diablomod/v_bow2.mdl" 
new cvow_PLAYER2[]= "models/diablomod/p_bow.mdl" 
new cbow_VIEW22[]  = "models/diablomod/v_bow.mdl" 
new cvow_PLAYER22[]= "models/diablomod/p_bow.mdl" 
new cbow_VIEW23[]  = "models/diablomod/v_crossbow2.mdl" 
new cvow_PLAYER23[]= "models/diablomod/p_crossbow2.mdl" 
new cbow_bolt[]  = "models/diablomod/Crossbow_bolt.mdl"
new kula[]  = "models/diablomod/w_snowball.mdl"
new kosc[] = "models/diablomod/skeleton.mdl"

new JumpsLeft[33]
new JumpsMax[33]

new loaded_xp[33]

new asked_sql[33]
new asked_klass[33]



//---------------------DODAWANIE KLAS--------------------------------------------------------------

new player_class_lvl[33][33]
new player_class_lvl_save[33]
new player_xp_old[33]
new srv_avg[33]




//---------------------TABLICA EXPA----------------------------------------------------------------



new LevelXP[1001] = {
	
0,
1, 8, 500, 1000, 2000, 3000, 4000, 5000, 6000, 7000,
8000, 9000, 10000, 11000, 12000, 13000, 14000, 15000, 16000, 17000,
18000, 19000, 20000, 21000, 22000, 23000, 24000, 25000, 26000, 27000,
28791, 29768, 30937, 31304, 32875, 33656, 34653, 35872, 36319, 37000,
38921, 40000, 45000, 50000, 55000, 60000, 70000, 80000, 90000,

100000,
110651, 120608, 130877, 145464, 156375, 167616, 175193, 185112, 205379, 216000,
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

16000000}


new nr_rundy =0



//For Hook and powerup sy

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
	Flag_slow,
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




new casting[33]
new Float:cast_end[33]
new on_knife[33]
new golden_bulet[33]
new ultra_armor[33]
new after_bullet[33]

new invisible_cast[33]
new player_dmg[33]

/* PLUGIN CORE REDIRECTING TO FUNCTIONS ========================================================== */


// SQL //

new Handle:g_SqlTuple

new g_sqlTable[64] = "dbmod_tables"
new g_boolsqlOK=0

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
new diablo_redirect = 0;

// SQL //


public plugin_init()
{
	new map[32]
	get_mapname(map,31)
	new times[64]
	get_time("%m/%d/%Y - %H:%M:%S" ,times,63)
	register_cvar("diablo_sql_host","localhost",FCVAR_PROTECTED)
	register_cvar("diablo_sql_user","root",FCVAR_PROTECTED)
	register_cvar("diablo_sql_pass","root",FCVAR_PROTECTED)
	register_cvar("diablo_sql_database","dbmod",FCVAR_PROTECTED)
	register_cvar("diablo_typ","0",FCVAR_PROTECTED)
	register_cvar("diablo_sql_table","dbmod_tablet",FCVAR_PROTECTED)
	register_cvar("diablo_sql_save","0",FCVAR_PROTECTED)	// 0 - nick							
	register_cvar("diablo_classes", "abcdefghijklmnopqrstuwvxyz")
	register_cvar("diablo_classes_vip", "abcdefghijklmnopqrstuwvxyz")
	register_cvar("diablo_avg", "0")		

	cvar_revival_health	= register_cvar("amx_revkit_health", 	"25")

	g_msg_bartime	= get_user_msgid("BarTime")
	g_msg_clcorpse	= get_user_msgid("ClCorpse")
	g_msg_screenfade= get_user_msgid("ScreenFade")
	g_msg_statusicon= get_user_msgid("StatusIcon")
	
	register_message(g_msg_clcorpse, "message_clcorpse")
	register_cvar("diablo_redirect","0",FCVAR_PROTECTED)
	register_event("HLTV", 		"event_hltv", 	"a", "1=0", "2=0")
	
	register_forward(FM_Touch, 		"fwd_touch")
	register_forward(FM_EmitSound, 		"fwd_emitsound")
	register_forward(FM_PlayerPostThink, 	"fwd_playerpostthink")

	register_plugin("DiabloMod","5.9i PL","Miczu, GuTeK & Kajt") 

	register_cvar("diablomod_version","5.9i PL",FCVAR_SERVER)
	
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
	register_event("TextMsg", "freeze_begin", "a", "2=#Game_will_restart_in")
	
	register_clcmd("say /pomoc","helpme") 
	register_clcmd("say /Pomoc","helpme") 
	register_clcmd("say /Klasa","changerace")
	register_clcmd("say /drop","drop")
	register_clcmd("/drop","drop")
	register_clcmd("say /staty","staty")  
	
	register_clcmd("say klasa","changerace")
	//register_clcmd("say /resp","resp_")
	register_clcmd("say /gracze","cmd_who")		
	register_clcmd("/postac","postac")
	register_clcmd("say postac","postac")
	register_clcmd("say /postac","postac")
	register_clcmd("/dragon","dragonf")
	register_clcmd("/dragonme","dragonfme")
	register_clcmd("say /klasa","changerace")
	register_clcmd("/itemtest","award_item_adm")
	register_clcmd("/itemtest2","award_item_adm2")
	register_clcmd("/klasa","changerace")
	register_clcmd("say /pomocoff","pomocoff")
	
	register_clcmd("say /znak","znak2") 
	register_clcmd("/znak","znak2") 

	register_clcmd("say /menu","showmenu") 
	register_clcmd("menu","showmenu")
	register_clcmd("say /komendy","komendy")
	register_clcmd("pomoc","helpme") 
	register_clcmd("czary","magia_sklep") 
	register_clcmd("/czary","magia_sklep") 
	register_clcmd("say czary","magia_sklep") 
	register_clcmd("say /czary","magia_sklep") 
	register_clcmd("say /poradnik","poradnik")
	gmsgStatusText = get_user_msgid("StatusText")

	


	register_clcmd("say /savexp","savexpcom")
	//register_clcmd("say /loadxp","LoadXP")
	register_clcmd("say /reset","reset_skill2")
	register_clcmd("say /autobuy","autobuy")
		
	register_clcmd("mod","mod_info")
	
	register_menucmd(register_menuid("Wybierz rodzaj umiejetnosci"), 1023, "skill_menu")
	
	register_menucmd(register_menuid("Wybierz umiejetnosc bitewna"), 1023, "skill_menu_bitewne")
	register_menucmd(register_menuid("Wybierz umiejetnosc zlodziejska"), 1023, "skill_menu_zlodziejskie")
	register_menucmd(register_menuid("Wybierz umiejetnosc magiczna"), 1023, "skill_menu_magiczne")
	register_menucmd(register_menuid("Wybierz atrybut"), 1023, "atrybuty_menu")
	register_menucmd(register_menuid("Wybierz znak zodiaku"), 1023, "znak_menu")
	register_menucmd(register_menuid("Wybor znaku zodiaku"), 1023, "znak_wybor")

	
	register_menucmd(register_menuid("Opcje"), 1023, "option_menu")

	register_menucmd(register_menuid("Sklep z magia"), 1023, "magia_sklep_tree")
	register_menucmd(register_menuid("Magia specjalne"), 1023, "magia_sklep_specjalne_tree")
	
	register_menucmd(register_menuid("Magia przywrocenia"), 1023, "magia_sklep_przywrocenia_tree")
	register_menucmd(register_menuid("Magia iluzji"), 1023, "magia_sklep_iluzji_tree")
	register_menucmd(register_menuid("Magia przywolania"), 1023, "magia_sklep_przywolania_tree")
	register_menucmd(register_menuid("Magia mistycyzmu"), 1023, "magia_sklep_mistycyzmu_tree")
	register_menucmd(register_menuid("Magia przemiany"), 1023, "magia_sklep_przemiany_tree")
	register_menucmd(register_menuid("Magia zniszczenia"), 1023, "magia_sklep_zniszczenia_tree")
	
	register_menucmd(register_menuid("Czar"), 1023, "magia_sklep_funkcja_tree")
	register_menucmd(register_menuid("Reset"), 1023, "reset_tree_menu")
	
	
	//---------------------------------------
	register_clcmd("/spec1","_spec1")
	register_clcmd("/spec2","_spec2")
	register_clcmd("/spec3","_spec3")
	register_clcmd("/spec4","_spec4")
	register_clcmd("/spec5","_spec5")
	register_clcmd("/spec6","_spec6")
	
	//---------------------------------------
	register_clcmd("/przywr1","_przywr1")
	register_clcmd("/przywr2","_przywr2")
	register_clcmd("/przywr3","_przywr3")
	register_clcmd("/przywr4","_przywr4")
	register_clcmd("/przywr5","_przywr5")
	register_clcmd("/przywr6","_przywr6")
	//---------------------------------------
	register_clcmd("/iluzja1","_iluzja1")
	register_clcmd("/iluzja2","_iluzja2")
	register_clcmd("/iluzja3","_iluzja3")
	register_clcmd("/iluzja4","_iluzja4")
	register_clcmd("/iluzja5","_iluzja5")
	register_clcmd("/iluzja6","_iluzja6")
	//---------------------------------------
	register_clcmd("/przywo1","_przyw1")
	register_clcmd("/przywo2","_przyw2")
	register_clcmd("/przywo3","_przyw3")
	register_clcmd("/przywo4","_przyw4")
	register_clcmd("/przywo5","_przyw5")
	register_clcmd("/przywo6","_przyw6")
	//---------------------------------------
	register_clcmd("/mis1","_mis1")
	register_clcmd("/mis2","_mis2")
	register_clcmd("/mis3","_mis3")
	register_clcmd("/mis4","_mis4")
	register_clcmd("/mis5","_mis5")
	register_clcmd("/mis6","_mis6")
	//---------------------------------------
	register_clcmd("/przem1","_przem1")
	register_clcmd("/przem2","_przem2")
	register_clcmd("/przem3","_przem3")
	register_clcmd("/przem4","_przem4")
	register_clcmd("/przem5","_przem5")
	register_clcmd("/przem6","_przem6")
	//---------------------------------------
	register_clcmd("/destr1","_destr1")
	register_clcmd("/destr2","_destr2")
	register_clcmd("/destr3","_destr3")
	register_clcmd("/destr4","_destr4")
	register_clcmd("/destr5","_destr5")
	register_clcmd("/destr6","_destr6")
	
	//---------------------------------------

	gmsgDeathMsg = get_user_msgid("DeathMsg")
	
	gmsgBartimer = get_user_msgid("BarTime") 
	gmsgScoreInfo = get_user_msgid("ScoreInfo") 
	register_cvar("diablo_dmg_exp","20",0)
	register_cvar("diablo_xpbonus","5",0)
	register_cvar("diablo_xpbonus2","8",0)

	register_cvar("SaveXP", "1")
	set_msg_block ( gmsgDeathMsg, BLOCK_SET ) 
	set_task(5.0, "Timed_Healing", 0, "", 0, "b")
	set_task(2.0, "reg", 0, "", 0, "b")
	set_task(1.0, "Timed_Ghost_Check", 0, "", 0, "b")
	set_task(0.8, "UpdateHUD",0,"",0,"b")
	register_think("PlayerCamera","Think_PlayerCamera");
	register_think("PowerUp","Think_PowerUp")

	register_logevent("RoundStart", 2, "0=World triggered", "1=Round_Start")
	register_clcmd("fullupdate","fullupdate")
	register_forward(FM_WriteString, "FW_WriteString")

	register_think("Effect_Ignite", "Effect_Ignite_Think")
	register_think("Effect_waz_Totem", "Effect_waz_Totem_Think")
	register_think("Effect_waz", "Effect_waz_Think")
	register_think("Effect_wybuch_Totem", "Effect_wybuch_Totem_Think")
	register_think("Effect_slow", "Effect_slow_Think")
	
	register_think("Effect_Slow","Effect_Slow_Think")
	register_think("Effect_Timedflag","Effect_Timedflag_Think")



	register_think("Effect_detect_Totem","Effect_detect_Totem_Think")
	register_think("Effect_par_Totem","Effect_par_Totem_Think")
	
	
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
	
	register_touch("throwing_knife", "func_breakable",	"touchbreakable")
	register_clcmd("say /create","create_klass_com")
	
	register_cvar("diablo_knife","20")
	register_cvar("diablo_knife_speed","1000")
	
	register_touch("xbow_arrow", "player", 			"toucharrow")
	register_touch("xbow_arrow", "worldspawn",		"touchWorld2")
	register_touch("xbow_arrow", "func_wall",		"touchWorld2")
	register_touch("xbow_arrow", "func_door",		"touchWorld2")
	register_touch("xbow_arrow", "func_door_rotating",	"touchWorld2")
	register_touch("xbow_arrow", "func_wall_toggle",	"touchWorld2")
	register_touch("xbow_arrow", "dbmod_shild",		"touchWorld2")
	
	register_touch("xbow_arrow", "func_breakable",		"touchWorld2")

	register_clcmd("say", "HandleSay");
	register_touch("flara", "player" ,		"toucharrow_flara")
	register_touch("flara", "worldspawn",		"touchWorld2_flara")
	register_touch("flara", "func_wall",		"touchWorld2_flara")
	register_touch("flara", "func_door",		"touchWorld2_flara")
	register_touch("flara", "func_door_rotating",	"touchWorld2_flara")
	register_touch("flara", "func_wall_toggle",	"touchWorld2_flara")
	register_touch("flara", "dbmod_shild",		"touchWorld2_flara")
	
	register_touch("flara", "func_breakable",	"touchWorld2_flara")

	
	register_touch("snow", "player" ,		"toucharrow_snow")
	register_touch("snow", "worldspawn",		"touchWorld2_snow")
	register_touch("snow", "func_wall",		"touchWorld2_snow")
	register_touch("snow", "func_door",		"touchWorld2_snow")
	register_touch("snow", "func_door_rotating",	"touchWorld2_snow")
	register_touch("snow", "func_wall_toggle",	"touchWorld2_snow")
	register_touch("snow", "dbmod_shild",		"touchWorld2_snow")
	
	register_touch("snow", "func_breakable",	"touchWorld2_snow")

	
	register_cvar("diablo_arrow","50.0")
	register_cvar("diablo_arrow_multi","2.0")
	register_cvar("diablo_arrow_speed","900")
	
	register_cvar("diablo_klass_delay","3.0")
	diablo_redirect  = get_cvar_num("diablo_redirect") 
	//Koniec noze
	

	_create_ThinkBot()
	
	register_forward(FM_TraceLine,"fw_traceline");
	for(new i=0;i<sizeof(race_heal);i++) srv_avg[i]=1
	diablo_typ  = get_cvar_num("diablo_typ") 
	/*
	g_hudmsg1 = CreateHudSyncObj()	
	g_hudmsg2 = CreateHudSyncObj()
	g_hudmsg3 = CreateHudSyncObj()	
	g_hudmsg4 = CreateHudSyncObj()
	g_hudmsg5 = CreateHudSyncObj()
	*/

	return PLUGIN_CONTINUE  
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
	format(q_command,511,"CREATE TABLE IF NOT EXISTS `%s`(`nick` VARCHAR(64),`ip` VARCHAR(64),`sid` VARCHAR(64),`klasa` integer(2),`znak` integer(2) DEFAULT 0,`lvl` integer(3) DEFAULT 1,`exp` integer(9) DEFAULT 0,`sila` integer(3) DEFAULT 0,`inte` integer(3) DEFAULT 0,`silawoli` integer(3) DEFAULT 0,`zwinnosc` integer(3) DEFAULT 0,`szybkosc` integer(3) DEFAULT 0,`wytrzy` integer(3) DEFAULT 0,`szcz` integer(3) DEFAULT 0,`vip` integer(1) DEFAULT 0,`klucz` VARCHAR(64))",g_sqlTable)
	SQL_ThreadQuery(g_SqlTuple,"TableHandle",q_command)
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
	if(g_boolsqlOK)
	{	
		if(!is_user_bot(id) )
		{
			new name[64]
			new ip[64]
			new sid[64]
			new data[1]
			data[0]=id
			get_user_name(id,name,63)
			replace_all ( name, 63, "'", "Q" )
			replace_all ( name, 63, "`", "Q" )
			
			if(g_boolsqlOK){
				get_user_ip ( id, ip, 63, 1 )
				get_user_authid(id, sid ,63)
				
				//log_to_file("addons/amxmodx/logs/test_log.log","*** %s %s *** Create Class ***",name,sid)
				
				for(new i=1;i<sizeof(race_heal);i++)
				{
					new q_command[512]
					

					format(q_command,511,"INSERT INTO `%s` (`nick`,`ip`,`sid`,`klasa`,`lvl`,`exp`) VALUES ('%s','%s','%s',%i,%i,%i ) ",g_sqlTable,name,ip,sid,i,2,2)
					SQL_ThreadQuery(g_SqlTuple,"create_klass_Handle",q_command)
				}
			}
		}
	}
	else sql_start()
}

public create_klass(id)
{
	if(g_boolsqlOK)
	{	
		if(!is_user_bot(id) )
		{
			new name[64]
			new ip[64]
			new sid[64]
			new data[1]
			data[0]=id
			get_user_name(id,name,63)
			replace_all ( name, 63, "'", "Q" )
			replace_all ( name, 63, "`", "Q" )
			
			new q_command[512]
			format(q_command,511,"SELECT * FROM `%s` WHERE `nick`='%s' AND `klasa`='1'", g_sqlTable, name)
			
			SQL_ThreadQuery(g_SqlTuple,"check_created",q_command,data,1)
			
			if(g_boolsqlOK){
				get_user_ip ( id, ip, 63, 1 )
				get_user_authid(id, sid ,63)
				
				//log_to_file("addons/amxmodx/logs/test_log.log","*** %s %s *** Create Class ***",name,sid)
				
				for(new i=1;i<sizeof(race_heal);i++)
				{
					new q_command[512]
					
					format(q_command,511,"INSERT INTO `%s` (`nick`,`ip`,`sid`,`klasa`,`lvl`,`exp`) VALUES ('%s','%s','%s',%i,%i,%i) ",g_sqlTable,name,ip,sid,i,2,2)
					SQL_ThreadQuery(g_SqlTuple,"create_klass_Handle",q_command)
				}
			
			}

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
	new Float:spd = get_user_maxspeed(id)
	client_print(id,print_chat,"Max: %f",spd)
	
	new Float:vect[3]
	entity_get_vector(id,EV_VEC_velocity,vect)
	new Float: sped= floatsqroot(vect[0]*vect[0]+vect[1]*vect[1]+vect[2]*vect[2])
	
	client_print(id,print_chat,"Teraz: %f",sped)
}

public plugin_precache()
{ 
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
	precache_model("models/player/barbarian/barbarian.mdl")
	precache_model("models/player/barbarian/barbarianT.mdl")
	precache_model("models/player/assassin/assassin.mdl")
	//precache_model("models/player/rouge/rouge.mdl")
	precache_model(SWORD_VIEW)  
	precache_model(SWORD_PLAYER)
	
	precache_model(PAL_VIEW)
	precache_model(cbow_VIEW2)
	precache_model(DragonM)
	precache_model(cvow_PLAYER2)
	precache_model(cbow_VIEW22)
	precache_model(cvow_PLAYER22)
	precache_model(cbow_VIEW23)
	precache_model(cvow_PLAYER23)
	precache_model(ZAB_VIEW)
	precache_model(DR_VIEW)

	precache_model(BARB_VIEW)
	precache_model(NINJA_VIEW)
	precache_model(ARCHEOLOG_VIEW)

	precache_model(MAGIC_VIEW)

	precache_model(KAPLAN_VIEW)
	precache_model(ORC_VIEW)
	precache_model(MAG_VIEW)
	precache_model(NECRO_VIEW)
	
	
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
	sprite_ignite3 = precache_model("addons/amxmodx/diablo/flame3.spr")
	sprite_smoke = precache_model("sprites/steam1.spr")

	sprite_boom = precache_model("sprites/zerogxplode.spr") 
	sprite_line = precache_model("sprites/dot.spr")
	sprite_lgt = precache_model("sprites/lgtning.spr")
	sprite_white = precache_model("sprites/white.spr") 

	sprite_gibs = precache_model("models/hgibs.mdl")


	
	sprite_fire3 = precache_model("models/diablomod/eexplo.spr") 
	sprite_fire4 = precache_model("models/diablomod/fexplo.spr") 
	
	
	//precache_model("models/player/rouge/rouge.mdl")
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
	precache_model("models/player/barbarian/barbarian.mdl")
	precache_model("models/player/barbarian/barbarianT.mdl")
	
	precache_sound(SOUND_START)
	precache_sound(SOUND_FINISHED)
	precache_sound(SOUND_FAILED)
	precache_sound(SOUND_EQUIP)

	precache_sound("weapons/knife_hitwall1.wav")
	precache_sound("weapons/knife_hit4.wav")
	precache_sound("weapons/knife_deploy1.wav")
	precache_model("models/diablomod/w_throwingknife.mdl")
	precache_model("models/diablomod/bm_block_platform.mdl")
	
	for(new u = 0; u < sizeof sounds_cast; u++) precache_generic(sounds_cast[u]) 

	for(new u = 0; u < sizeof sounds_fail; u++) precache_generic(sounds_fail[u]) 
	
	for(new u = 0; u < sizeof sounds_hit; u++) precache_generic(sounds_hit[u]) 
	precache_model(cbow_VIEW2)
	precache_model(cvow_PLAYER2)
	precache_model(cbow_bolt)
	precache_model(kula)
	precache_model(kosc)
	/*
	g_hudmsg1 = CreateHudSyncObj()	
	g_hudmsg2 = CreateHudSyncObj()
	g_hudmsg3 = CreateHudSyncObj()	
	g_hudmsg4 = CreateHudSyncObj()
	g_hudmsg5 = CreateHudSyncObj()
	*/
}

public plugin_cfg() {
	server_cmd("sv_maxspeed 1500")
}

public savexpcom(id)
{
	if(get_cvar_num("SaveXP") == 1 && player_class[id]!=0 && player_class_lvl[id][player_class[id]]==player_lvl[id] ) 
	{
		SaveXP(id)
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
				//new q_command2[512]					
				
				format(q_command,511,"UPDATE `%s` SET `ip`='%s',`sid`='%s',`lvl`='%i',`exp`='%i',`znak`='%i',`zloto`='%i',`sila`='%i',`inte`='%i',`silawoli`='%i',`zwinnosc`='%i',`szybkosc`='%i',`wytrzy`='%i',`szcz`='%i' WHERE `nick`='%s' AND `klasa`='%i' ",g_sqlTable,ip,sid,player_lvl[id],player_xp[id],player_znak[id],player_zloto[id],player_sila[id],player_inteligencja[id],player_sila_woli[id],player_zwinnosc[id],player_szybkosc[id],player_wytrzymalosc[id],player_szczescie[id],name,player_class[id])
				SQL_ThreadQuery(g_SqlTuple,"Save_xp_handle",q_command)

				format(q_command,511,"UPDATE `%s` SET `ostrz`='%i',`lekka`='%i',`ciezka`='%i',`ciezki`='%i',`plat`='%i',`blok`='%i' WHERE `nick`='%s' AND `klasa`='%i' ",g_sqlTable,player_ostrze[id],player_bron_lekka[id],player_bron_ciezka[id],player_ciezki_pancerz[id],player_platnerstwo[id],player_blok[id],name,player_class[id])
				SQL_ThreadQuery(g_SqlTuple,"Save_xp_handle",q_command)

				format(q_command,511,"UPDATE `%s` SET `han`='%i',`skr`='%i',`akr`='%i',`lekki`='%i',`cel`='%i',`atl`='%i' WHERE `nick`='%s' AND `klasa`='%i' ",g_sqlTable,player_handel[id],player_skradanie[id],player_akrobatyka[id],player_lekki_pancerz[id],player_celnosc[id],player_atletyka[id],name,player_class[id])
				SQL_ThreadQuery(g_SqlTuple,"Save_xp_handle",q_command)

				format(q_command,511,"UPDATE `%s` SET `znisz`='%i',`ilu`='%i',`mist`='%i',`przywr`='%i',`przem`='%i',`przyw`='%i' WHERE `nick`='%s' AND `klasa`='%i' ",g_sqlTable,player_zniszczenie[id],player_iluzja[id],player_mistycyzm[id],player_przywrocenie[id],player_przemiana[id],player_przywolanie[id],name,player_class[id])
				SQL_ThreadQuery(g_SqlTuple,"Save_xp_handle",q_command)

				format(q_command,511,"UPDATE `%s` SET `czar_znisz`='%i',`czar_ilu`='%i',`czar_mist`='%i',`czar_przywr`='%i',`czar_przem`='%i',`czar_przyw`='%i', `data`=NOW() WHERE `nick`='%s' AND `klasa`='%i' ",g_sqlTable,player_czar_zniszczenie[id],player_czar_iluzja[id],player_czar_mistycyzm[id],player_czar_przywrocenie[id],player_czar_przemiana[id],player_czar_przywolanie[id],name,player_class[id])
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
	/*
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
	*/
	
	return PLUGIN_CONTINUE
}

public LoadXP(id, klasa){
	
	if(is_user_bot(id) || asked_sql[id]==1) return PLUGIN_HANDLED
	
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
	   
	if(SQL_MoreResults(Query))
	{
		player_class[id] = Data[1]
		new name[64]
		get_user_name(id,name,63)
		replace_all ( name, 63, "'", "Q" )
		replace_all ( name, 63, "`", "Q" )
		new name_sql[64]
		SQL_ReadResult(Query,SQL_FieldNameToNum(Query,"nick"), name_sql, 63)	

		
		if (!equali(name, name_sql)) return PLUGIN_CONTINUE

		player_lvl[id] = SQL_ReadResult(Query,SQL_FieldNameToNum(Query,"lvl"))	
		player_xp[id] =	SQL_ReadResult(Query,SQL_FieldNameToNum(Query,"exp"))	
		player_xp_old[id] = SQL_ReadResult(Query,SQL_FieldNameToNum(Query,"exp"))

		player_znak[id] = SQL_ReadResult(Query,SQL_FieldNameToNum(Query,"znak")) 
		player_zloto[id] = SQL_ReadResult(Query,SQL_FieldNameToNum(Query,"zloto")) 
		
		player_szczescie[id] = SQL_ReadResult(Query,SQL_FieldNameToNum(Query,"szcz"))
		player_wytrzymalosc[id] = SQL_ReadResult(Query,SQL_FieldNameToNum(Query,"wytrzy")) 
		player_szybkosc[id] = SQL_ReadResult(Query,SQL_FieldNameToNum(Query,"szybkosc")) 
		player_zwinnosc[id] = SQL_ReadResult(Query,SQL_FieldNameToNum(Query,"zwinnosc")) 
		player_inteligencja[id] = SQL_ReadResult(Query,SQL_FieldNameToNum(Query,"inte")) 
		player_sila_woli[id] = SQL_ReadResult(Query,SQL_FieldNameToNum(Query,"silawoli")) 
		player_sila[id] = SQL_ReadResult(Query,SQL_FieldNameToNum(Query,"sila")) 
		
		
		player_ostrze[id] = SQL_ReadResult(Query,SQL_FieldNameToNum(Query,"ostrz")) 
		player_bron_lekka[id] = SQL_ReadResult(Query,SQL_FieldNameToNum(Query,"lekka")) 
		player_bron_ciezka[id] = SQL_ReadResult(Query,SQL_FieldNameToNum(Query,"ciezka")) 
		player_ciezki_pancerz[id] = SQL_ReadResult(Query,SQL_FieldNameToNum(Query,"ciezki")) 
		player_platnerstwo[id] = SQL_ReadResult(Query,SQL_FieldNameToNum(Query,"plat")) 
		player_blok[id] = SQL_ReadResult(Query,SQL_FieldNameToNum(Query,"blok")) 		
		
		player_skradanie[id] = SQL_ReadResult(Query,SQL_FieldNameToNum(Query,"skr")) 
		player_atletyka[id] = SQL_ReadResult(Query,SQL_FieldNameToNum(Query,"atl")) 
		player_akrobatyka[id] = SQL_ReadResult(Query,SQL_FieldNameToNum(Query,"akr")) 
		player_lekki_pancerz[id] = SQL_ReadResult(Query,SQL_FieldNameToNum(Query,"lekki")) 
		player_celnosc[id] = SQL_ReadResult(Query,SQL_FieldNameToNum(Query,"cel")) 
		player_handel[id] = SQL_ReadResult(Query,SQL_FieldNameToNum(Query,"han")) 	
		
		player_przywrocenie[id] = SQL_ReadResult(Query,SQL_FieldNameToNum(Query,"przywr")) 
		player_iluzja[id] = SQL_ReadResult(Query,SQL_FieldNameToNum(Query,"ilu")) 
		player_przywolanie[id] = SQL_ReadResult(Query,SQL_FieldNameToNum(Query,"przyw")) 
		player_mistycyzm[id] = SQL_ReadResult(Query,SQL_FieldNameToNum(Query,"mist")) 
		player_przemiana[id] = SQL_ReadResult(Query,SQL_FieldNameToNum(Query,"przem")) 
		player_zniszczenie[id] = SQL_ReadResult(Query,SQL_FieldNameToNum(Query,"znisz")) 
		
		
		player_czar_przywrocenie[id] = SQL_ReadResult(Query,SQL_FieldNameToNum(Query,"czar_przywr")) 
		player_czar_iluzja[id] = SQL_ReadResult(Query,SQL_FieldNameToNum(Query,"czar_ilu")) 
		player_czar_przywolanie[id] = SQL_ReadResult(Query,SQL_FieldNameToNum(Query,"czar_przyw")) 
		player_czar_mistycyzm[id] = SQL_ReadResult(Query,SQL_FieldNameToNum(Query,"czar_mist")) 
		player_czar_przemiana[id] = SQL_ReadResult(Query,SQL_FieldNameToNum(Query,"czar_przem")) 
		player_czar_zniszczenie[id] = SQL_ReadResult(Query,SQL_FieldNameToNum(Query,"czar_znisz")) 
		

		
		player_point_u[id]=(player_lvl[id] - 2) *3 
		player_point_u[id] -= player_ostrze[id] +player_bron_lekka[id]+player_bron_ciezka[id]+player_ciezki_pancerz[id]+player_platnerstwo[id]+player_blok[id]
		player_point_u[id] -= player_skradanie[id]  + player_atletyka[id]+player_akrobatyka[id] +player_lekki_pancerz[id]+player_celnosc[id]+player_handel[id]
		player_point_u[id] -=player_przywrocenie[id]+player_iluzja[id]+player_przywolanie[id]+player_mistycyzm[id]+player_przemiana[id]+player_zniszczenie[id]
		
		wczytaj_czary(id)
		if(player_point_u[id]<0) player_point_u[id]=0
		player_damreduction[id] = (47.3057*(1.0-floatpower( 2.7182, -0.06798*float(player_blok[id]/2)))/100)
		set_task(5.0, "check_my_class", id)
		write_hud(id)
		
	}
	return PLUGIN_CONTINUE
}



public reset_skill(id)
{	
	client_print(id,print_chat,"Reset skill'ow")
	player_point_u[id] = (player_lvl[id] - 2) *3 
	player_point_a[id] = player_lvl[id]

	
	player_ostrze[id] = 0
	player_bron_lekka[id] = 0
	player_bron_ciezka[id] = 0
	player_ciezki_pancerz[id] = 0
	player_platnerstwo[id] = 0
	player_blok[id] = 0
	player_skradanie[id] = 0
	player_atletyka[id] = 0
	player_akrobatyka[id] = 0
	player_lekki_pancerz[id] = 0
	player_celnosc[id] = 0
	player_handel[id] = 0
	player_przywrocenie[id] = 0
	player_iluzja[id] = 0
	player_przywolanie[id] = 0
	player_mistycyzm[id] = 0
	player_przemiana[id] = 0
	player_zniszczenie[id] = 0
				
	player_szczescie[id] = 0
	player_wytrzymalosc[id] = 0
	player_szybkosc[id] = 0
	player_zwinnosc[id] = 0
	player_inteligencja[id] = 0
	player_sila_woli[id] = 0
	player_sila[id] = 0
			
	player_a_ostrze[id] = 0
	player_a_bron_lekka[id] = 0
	player_a_bron_ciezka[id] = 0
	player_a_ciezki_pancerz[id] = 0
	player_a_platnerstwo[id] = 0
	player_a_blok[id] = 0
	player_a_skradanie[id] = 0
	player_a_atletyka[id] = 0
	player_a_akrobatyka[id] = 0
	player_a_lekki_pancerz[id] = 0
	player_a_celnosc[id] = 0
	player_a_handel[id] = 0
	player_a_przywrocenie[id] = 0
	player_a_iluzja[id] = 0
	player_a_przywolanie[id] = 0
	player_a_mistycyzm[id] = 0
	player_a_przemiana[id] = 0
	player_a_zniszczenie[id] = 0
				
	player_a_szczescie[id] = 0
	player_a_wytrzymalosc[id] = 0
	player_a_szybkosc[id] = 0
	player_a_zwinnosc[id] = 0
	player_a_inteligencja[id] = 0
	player_a_sila_woli[id] = 0
	player_a_sila[id] = 0	
			
			
	skilltree_nxt(id)
	set_speedchange(id)
	
}
public reset_skill2(id)
{	
	if(player_lvl[id]<=2){
		client_print(id,print_chat,"Za maly level")
		return PLUGIN_CONTINUE
	}
	new cash = player_zloto[id]
	new lvl = player_lvl[id]
	if(lvl>20) lvl -= 20
	if(lvl<=20) lvl = 0
	lvl = lvl/3
	lvl = lvl*lvl
	if(get_user_flags(id) & ADMIN_LEVEL_H || cash >= lvl || player_lvl[id] <= 50){
		reset_tree(id)
		player_doda_szczescie[id] =0
		player_doda_wytrzymalosc[id]  =0
		player_doda_szybkosc[id]  =0
		player_doda_zwinnosc[id] =0
		player_doda_inteligencja[id] =0
		player_doda_sila_woli[id] =0
		player_doda_sila[id]  =0
		
	} else{
		client_print(id,print_chat,"Nie masz wystarczajacej ilosci zlota, potrzebujesz: %i", lvl)
	
	}
	return PLUGIN_CONTINUE
}
public reset_tree(id)
{
	new text[513] 
	new keys = (1<<0)|(1<<1)
	
	new lvl = player_lvl[id]
	if(lvl>20) lvl -= 30
	if(lvl<=20) lvl = 0
	lvl = lvl/3
	lvl = lvl*lvl
	if(player_lvl[id] <= 50) lvl = 0
	
	format(text, 512, "\yCzy na pewno chcesz kupic reset za - \rZloto: %i^n^n\w1. Tak ^n\w2. Nie",lvl) 
	
	keys = (1<<0)|(1<<1)|(1<<2)
	show_menu(id, keys, text,-1,"Reset") 
	return PLUGIN_HANDLED  
} 

public reset_tree_menu(id, key) 
{ 
	switch(key) 
	{ 	
		case 0: 
		{	
			new lvl = player_lvl[id]
			if(lvl>20) lvl -= 30
			if(lvl<=20) lvl = 0
			lvl = lvl/3
			lvl = lvl*lvl
			if(player_lvl[id] <= 50) lvl = 0
			
			if(!(get_user_flags(id) & ADMIN_LEVEL_H))player_zloto[id] = player_zloto[id] - lvl
			reset_skill(id)
			client_cmd(id, "mp3 play %s", sounds_hit[gold] )
		}
		case 1: 
		{	
			return PLUGIN_HANDLED
		}
	}	
	return PLUGIN_HANDLED
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
}

public freeze_begin()
{
	freeze_ended = false
	freeze_ended2= 0
}


public RoundStart(){

	nr_rundy++
	if(ok==2 && pobrane_ok==1&&pobrane_ok2==1){
		pobrane_ok=0
		pobrane_ok2=0
	}
	if(mierzy==0){
		mierzy = 1
	}
	
	check_class()
	graczy = 0
	for (new i=0; i < 33; i++){
		if(!is_user_alive(i)) continue;
		
		change_health(i,0,i,"world")

		if(roundXP[i]>0)client_print(i,print_chat,"W poprzedniej rundzie zdobyles lacznie %i expa", roundXP[i])
		roundXP[i]=0
		if(czas_rundy + 30 < floatround(halflife_time()) && get_playersnum() > 5 && is_user_connected(i) && player_class[i]>0 && is_user_alive(i)){
			new pln = get_playersnum() 
			if(pln > 10) pln  = 10
			new exp = calc_award_goal_xp(i,get_cvar_num("diablo_xpbonus2")*2, 500) * pln
			if(exp > 1){
				Give_Xp(i, exp)
				client_print(i,print_chat,"Dostales *%i* doswiadczenia za czas gry",xp_mnoznik(i, exp))
			}
			Give_Xp(i, 1)
		}
		if(u_sid[i] > 0){
			cs_set_user_money(i,cs_get_user_money(i)+200)
		}
		xp_mnoznik_v(i)
		respawned[i] =0  
		DemageTake1[i]=1
		count_jumps(i)
		give_knife(i)
		JumpsLeft[i]=JumpsMax[i]
		g_haskit[i]=0
		bowdelay[i]=get_gametime()-30
		golden_bulet[i]=0
		invisible_cast[i]=0
		ultra_armor[i]=0

		if(is_user_connected(i)){
			graczy++
		} 
		set_renderchange(i)
		if(ok==0) client_cmd(i,"kill");
		ghost_check[i] = false
		ghoststate[i] = 0
		remove_task(TASKID_GHOST+i)  


	}	
	kill_all_entity("throwing_knife")	
	
	use_addtofullpack = false

	czas_rundy = floatround(halflife_time())
}


#if defined CHEAT
public giveitem(id)
{

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




public CurWeapon2(id)
{
	new pid = id - TASKID_smth
	CurWeapon(pid)
}

public CurWeapon(id)
{	
	if(!is_user_alive(id)) return;
	after_bullet[id]=1
	
	new clip,ammo
	new weapon=get_user_weapon(id,clip,ammo)
	invisible_cast[id]=0
	if(weapon == CSW_KNIFE){
		on_knife[id]=1
	} 
	else{
		if(player_a_skradanie[id]<ekspert && player_a_ostrze[id] <= ekspert) player_b_inv[id] = 255
		on_knife[id]=0
	}
	
	sprawdz_bronie(id,weapon)


	if ((weapon != CSW_C4 ) && !on_knife[id] && (player_a_ostrze[id]>ekspert || dragon[id]==1)){
		client_cmd(id,"drop")
		set_speedchange(id)
	}
	
	if ( (weapon != CSW_C4 ) && !on_knife[id] && player_sp[id] <3 && player_class[id]!=0)
	{
		client_cmd(id,"weapon_knife")
		engclient_cmd(id,"weapon_knife")
		on_knife[id]=1	
	}
	
	if ( paraliz[id]==1 || smal_rozb[id]==1 || rozb[id]==1 )
	{
		client_cmd(id,"weapon_knife")
		engclient_cmd(id,"weapon_knife")
		on_knife[id]=1	
		//bow[id]=0
		set_task(0.7,"CurWeapon2",TASKID_smth+id) 
	}

	if(player_a_ostrze[id]>ekspert ){
		on_knife[id]=1
	}
	if(weapon == CSW_HEGRENADE){
		if(czas_rundy + 10 > floatround(halflife_time()) || player_a_ostrze[id]>ekspert){
				client_cmd(id," lastinv ")
		}
	}
	if(dragon[id]==1){
		entity_set_string(id, EV_SZ_viewmodel, DR_VIEW)  
	}
	if (is_user_connected(id) && dragon[id]==0)
	{

		if(on_knife[id]){
			entity_set_string(id, EV_SZ_viewmodel, KNIFE_VIEW)  
			entity_set_string(id, EV_SZ_weaponmodel, KNIFE_PLAYER)  	
			if(player_noz[id]==1){
				entity_set_string(id, EV_SZ_viewmodel, PAL_VIEW)  
			}
			else if(player_noz[id]==2){
				entity_set_string(id, EV_SZ_viewmodel, BARB_VIEW)  
			}
			else if(player_noz[id]==3){
				entity_set_string(id, EV_SZ_viewmodel, ZAB_VIEW)  
			}
			else if(player_noz[id]==4){
				entity_set_string(id, EV_SZ_viewmodel, NINJA_VIEW)  
			}
			else if(player_noz[id]==5){
				entity_set_string(id, EV_SZ_viewmodel, ARCHEOLOG_VIEW)  
			}
			else if(player_noz[id]==6){
				entity_set_string(id, EV_SZ_viewmodel, MAGIC_VIEW)  
			}
			else if(player_noz[id]==7 ){
				entity_set_string(id, EV_SZ_viewmodel, KAPLAN_VIEW)  
			}
			else if(player_noz[id]==8){
				entity_set_string(id, EV_SZ_viewmodel, ORC_VIEW)  
			}
			else if(player_noz[id]==9){
				entity_set_string(id, EV_SZ_viewmodel, MAG_VIEW)  
			}
			else if(player_noz[id]==10){
				entity_set_string(id, EV_SZ_viewmodel, NECRO_VIEW)  
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
		if(player_a_skradanie[id]<=ekspert){
			player_b_inv[id] = 255
			player_b_inv_ilu2[id] = 0
		} 
		else{
			player_b_inv[id] += 50
		}
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
	write_hud(id)
}


public ResetHUD(id)
{
	if (is_user_connected(id))
	{	
		remove_task(id+GLUTON)
		change_health(id,999,0,"")
		diablo_typ = get_cvar_num("diablo_typ")


		fired[id] = 0
		player_ultra_armor_left[id]=player_ultra_armor[id]
		player_b_dagfired[id] = false
		earthstomp[id] = 0

		if(player_point_u[id] > 0 ) skilltree_nxt(id)
		if(player_class[id] == 0) select_class_query(id)
		c4state[id] = 0
		client_cmd(id,"hud_centerid 0")  
		auto_help(id)

		set_gravitychange(id)
		SelectBotRace(id)
		set_renderchange(id)
	}
}

public DeathMsg(id)
{
	new weaponname[20]
	new kid = read_data(1)
	new vid = read_data(2)
	new headshot = read_data(3)
	read_data(4,weaponname,31)
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
	

	if (is_user_connected(kid) && is_user_connected(vid) && get_user_team(kid) != get_user_team(vid))
	{
		show_deadmessage(kid,vid,headshot,weaponname)

		award_kill(kid,vid)
		add_respawn_bonus(vid)
		add_bonus_explode(vid)
		if (player_handel[kid] > czeladnik){
			refill_ammo(kid)
		}
		set_renderchange(kid)
		savexpcom(vid)
	}
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
			new attacker_id = get_user_attacker(id,weapon,bodypart) 
			if (is_user_connected(attacker_id) && attacker_id != id)
			{
				if(get_user_team(id) != get_user_team(attacker_id))
				{				
					if(damage>175) player_dmg[attacker_id]+=damage/2
					else player_dmg[attacker_id]+=damage
					dmg_exp(attacker_id,id)
					
					if(player_stop_poc[attacker_id]>0 && get_user_team(id) != get_user_team(attacker_id)){
						obciaz[id] = 1
						set_task(8.0,"obciaz_off",TASKID_OBC+id) 
						obciaz_time[id]=floatround(halflife_time()) +10
						
						player_stop_poc[attacker_id]--
						client_cmd(id, "mp3 play %s", sounds_hit[magia] ) 
						Display_Fade(id,2600,2600,0,255,255,255,40)
						Effect_slow(id,attacker_id)
						set_speedchange(id)
					}
	
					if(player_obc_poc[attacker_id]>0 && get_user_team(id) != get_user_team(attacker_id) ){
						rozb[id] = 1
						player_obc_poc[attacker_id]--
						rozb_time[id]=floatround(halflife_time()) +10
						set_task(10.0,"obc_off",TASKID_O+id) 
						client_cmd(id, "mp3 play %s", sounds_hit[magia] ) 
						Display_Fade(id,2600,2600,0,255,255,255,40)
						client_cmd(id, "drop" ) 
						set_task(0.2,"CurWeapon2",TASKID_smth+id) 
						set_speedchange(id)
						
					}
				}
				if(weapon != CSW_HEGRENADE) add_damage_bonus(id,damage,attacker_id)
				add_theif_bonus(id,attacker_id)
				add_bonus_blind(id,attacker_id,weapon,damage)
				add_bonus_scoutdamage(attacker_id,id,weapon)
				add_bonus_m3(attacker_id,id,weapon)
				add_bonus_darksteel(attacker_id,id,damage)
				
				if(player_a_ostrze[attacker_id] > 0 && on_knife[attacker_id] && get_user_team(id) != get_user_team(attacker_id) && weapon != CSW_HEGRENADE){
					atak_truc(id,-player_a_ostrze[attacker_id]/2,attacker_id)
				}
				if(player_a_ostrze[attacker_id] > mistrz && on_knife[attacker_id] && get_user_team(id) != get_user_team(attacker_id)){
					if(random_num(0,7)==0){
						UTIL_Kill(attacker_id,id,"world")
					}
				}
				
				
				if (HasFlag(attacker_id,Flag_Ignite))
					RemoveFlag(attacker_id,Flag_Ignite)
						
				//Add the agility damage reduction, around 45% the curve flattens
				if (damage > 0 && player_a_blok[id]>0)
				{	
					new heal = floatround(player_damreduction[id]*damage)
					if (is_user_alive(id)) change_health(id,heal,0,"")
					damage = damage - heal
				}
				if(damage > 0 && player_sp[attacker_id] >=10 ){
					new heal2 = floatround(0.30 *damage)
					if (is_user_alive(id)) change_health(id,heal2,0,"")
				}
				if(player_odbij_zwykle[id]>=50){
						
					new hp = damage/10
					change_health(attacker_id,-hp*4,id,"world")
					change_health(id,hp*4,attacker_id,"world")
				}
			}
			
		}
	}
}


public un_rander(task_id)
{
	new id = task_id - TASK_FLASH_LIGHT
	if(is_user_connected(id)) set_renderchange(id)
}

public client_PreThink ( id ) 
{	
	if(is_user_bot(id) || is_user_alive(id)==0) return PLUGIN_CONTINUE
	new clip,ammo
	new weapon = get_user_weapon(id,clip,ammo)

	new button2 = get_user_button(id);
	if(((player_a_akrobatyka[id]>czeladnik && weapon == CSW_KNIFE) || player_a_ostrze[id]>ekspert) && freeze_ended) 
	{ 
		if((button2 & IN_DUCK) && (button2 & IN_JUMP)) 
		{ 
			if(JumpsLeft[id]>0) 
			{ 
				new flags = pev(id,pev_flags) 
				if(flags & FL_ONGROUND) 
				{ 
					set_pev ( id, pev_flags, flags-FL_ONGROUND ) 
                                
					JumpsLeft[id]-- 
                                
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
	if((button2 & IN_DUCK) && (button2 & IN_ATTACK2) && on_knife[id]) mikstura_check(id)
	
	
	if(player_b_jumpx[id] > 0) Prethink_Doublejump(id)	
	if(player_a_akrobatyka[id]>uczen  && player_a_akrobatyka[id]<=mistrz&& freeze_ended){
		entity_set_float(id, EV_FL_fuser2, 0.0)		// Disable slow down after jumping
		if (entity_get_int(id, EV_INT_button) & 2) {	// If holding jump
			new flags = entity_get_int(id, EV_INT_flags)
			if (flags & FL_WATERJUMP)
				return PLUGIN_CONTINUE
			if ( entity_get_int(id, EV_INT_waterlevel) >= 2 )
				return PLUGIN_CONTINUE
			
			
			if ( !(flags & FL_ONGROUND) ){
				return PLUGIN_CONTINUE
			}
	
			new Float:velocity[3]
			entity_get_vector(id, EV_VEC_velocity, velocity)
			velocity[2] += 250.0
			entity_set_vector(id, EV_VEC_velocity, velocity)
			entity_set_int(id, EV_INT_gaitsequence, 6)	// Play the Jump Animation
		}
	}
	//Before freeze_ended check
	if (player_a_skradanie[id] >uczen  && is_user_alive(id)){
		entity_set_int(id, EV_INT_flTimeStepSound, 300)
	}
		
		
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
	
	if(czas_regeneracji[id]<floatround(halflife_time()) && player_class[id]!=0){
		czas_regeneracji[id] = floatround(halflife_time()) + 1
		reg(id)	
		if(random_num(0,205-player_a_szczescie[id])==0 && random_num(0,5000) && random_num(0,200))
		{
			show_hudmessage(id, "Masz szczescie! Bogowie pozwolili Ci znalezc zloto!")
			player_zloto[id]++
			client_cmd(id, "mp3 play %s", sounds_hit[gold] )
			set_task(5.0,"es",TASKID_MUSIC+id) 
		}
	}
	
	if( czas_sprawdzania[id]<halflife_time() ){
		czas_sprawdzania[id] = halflife_time() + 0.2
		if(button2 & IN_JUMP){
			new skok = 12  - player_a_zwinnosc[id]/10
			if(skok<0) skok = 0
			player_sp[id] -= skok
		}
		if((button2 & (IN_FORWARD+IN_BACK+IN_MOVELEFT+IN_MOVERIGHT)) && (!(button2 & (IN_DUCK)) && (button2 & (IN_RUN)) ) ){
			new los = (random_num(0,999) + floatround(halflife_time()*10))%6
			if(los==0){
				new krok = 6  - player_a_zwinnosc[id]/10
				if(krok<0) krok = 0
				player_sp[id] -= krok

			}
		}
		if( button2 & (IN_ATTACK+IN_ATTACK2) ){
			new los = (random_num(0,999) + floatround(halflife_time()*10))%7
			if(los==0){
				new krok = 12  - player_a_zwinnosc[id]/10
				if(krok<0) krok = 0
				player_sp[id] -= krok

				new clip,ammo
				new weapon = get_user_weapon(id,clip,ammo)
				if(weapon==CSW_SCOUT || weapon==CSW_FAMAS ||weapon==CSW_GALIL  || weapon==CSW_AUG || weapon == CSW_SG552 ||
					weapon == CSW_M249 || weapon == CSW_AWP || 
					weapon == CSW_SG550 || weapon == CSW_G3SG1){
						
						new krok2 = 6  - player_a_zwinnosc[id]/10
						if(krok2<0) krok2 = 0
						player_sp[id] -= krok
				}
			}
		}
		if(player_sp[id] < 10 || (player_sp[id] >= 10 && player_sp[id] < 15) ){
			set_speedchange(id)
			set_gravitychange(id)
		}
		if(player_sp[id]<0) player_sp[id] = 0
		
	}
	
	if (get_entity_flags(id) & FL_ONGROUND && (!(button2 & (IN_FORWARD+IN_BACK+IN_MOVELEFT+IN_MOVERIGHT))) && is_user_alive(id) && !bow[id] && on_knife[id] && player_class[id]!=NONE)
	{
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
			new Float: time_delay = 2.0
			cast_end[id]=halflife_time()+time_delay
			new bar_delay = floatround(time_delay,floatround_ceil)
			casting[id]=1
			message_begin( MSG_ONE, gmsgBartimer, {0,0,0}, id ) 
			write_byte( bar_delay ) 
			write_byte( 0 ) 
			message_end() 
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
		showmenu(id)

	if (pev(id,pev_button) & IN_USE && !casting[id])
		Use_Spell(id)
		
	if(bow[id] == 1)
	{
		new Float:czas = bowdelay[id] + 4.5 - (player_a_celnosc[id])/50.0 - player_a_szybkosc[id]/40.0
		if(player_a_celnosc[id] <25 ) czas = bowdelay[id] + 4.5
		if(czas<( bowdelay[id] + 0.7)) czas = bowdelay[id] + 0.7
		if(czas< get_gametime() && button2 & IN_ATTACK)
		{
			bowdelay[id] = get_gametime()
			command_arrow(id) 
		}
		entity_set_int(id, EV_INT_button, (button2 & ~IN_ATTACK) & ~IN_ATTACK2)
	}

	
	return PLUGIN_CONTINUE		
}

public client_PostThink( id )
{
	if (player_b_jumpx[id] > 0) Postthink_Doubeljump(id)

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
public skilltree_nxt(id)
{
	if(player_a_zwinnosc[id] == 0 )return PLUGIN_HANDLED
	if(player_doda_szczescie[id] <0 )player_doda_szczescie[id] = 0
	if(player_doda_wytrzymalosc[id] <0 )player_doda_wytrzymalosc[id] = 0
	if(player_doda_szybkosc[id] <0 )player_doda_szybkosc[id] = 0
	if(player_doda_zwinnosc[id] <0 )player_doda_zwinnosc[id] = 0
	if(player_doda_inteligencja[id] <0)player_doda_inteligencja[id] = 0
	if(player_doda_sila_woli[id] <0 )player_doda_sila_woli[id] = 0
	if(player_doda_sila[id] <0 )player_doda_sila[id] = 0
	
	player_nxt_update[id] = player_doda_sila[id] +  player_doda_sila_woli[id] +player_doda_inteligencja[id]+player_doda_zwinnosc[id]+player_doda_szybkosc[id]+player_doda_wytrzymalosc[id]+player_doda_szczescie[id]
	if(get_timeleft() < 180 && player_nxt_update[id]==0){
		set_hudmessage(255, 0, 0, -1.0, 0.01)
		show_hudmessage(id, "Nie rozdawaj statystyk, mapa sie konczy!")
		return PLUGIN_HANDLED
	}
	
	if(player_point_u[id] > 0 && player_nxt_update[id] <3) {
		skilltree(id)
	}
	if(player_nxt_update[id] >=3){
		atrybuty_tree(id)
	}
	
	
	return PLUGIN_HANDLED

} 
public skilltree(id)
{
	if(player_a_zwinnosc[id] == 0 )return PLUGIN_HANDLED
	player_nxt_update[id] = player_doda_sila[id] +  player_doda_sila_woli[id] +player_doda_inteligencja[id]+player_doda_zwinnosc[id]+player_doda_szybkosc[id]+player_doda_wytrzymalosc[id]+player_doda_szczescie[id]
	if(player_nxt_update[id] >=3){
		atrybuty_tree(id)
		return PLUGIN_HANDLED  
	}
	player_fast[id]=0
	new text[513] 
	
	new keys 
	if(player_point_u[id]<30){
		format(text, 512, "\yWybierz rodzaj umiejetnosci - \rPunkty: %i^n^n\w1. Umiejetnosci bitewne ^n\w2. Umiejetnosci zlodziejskie ^n\w3. Umiejetnosci magiczne ^n",player_point_u[id]) 
		keys = (1<<0)|(1<<1)|(1<<2)
	} else{
		format(text, 512, "\yWybierz rodzaj umiejetnosci - \rPunkty: %i^n^n\w1. Umiejetnosci bitewne ^n\w2. Umiejetnosci zlodziejskie ^n\w3. Umiejetnosci magiczne ^n\w4. Szybkie rozdawanie +30: Umiejetnosci bitewne ^n\w5. Szybkie rozdawanie +30: Umiejetnosci zlodziejskie ^n\w6. Szybkie rozdawanie +30: Umiejetnosci magiczne ^n",player_point_u[id]) 
		keys = (1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<4)|(1<<5)
	}

	show_menu(id, keys, text) 
	return PLUGIN_HANDLED  
} 

public skill_menu(id, key) 
{ 
	
	player_fast[id]=0
	switch(key) 
	{ 	
		case 0: 
		{	
			skilltree_bitewne(id)
		}
		case 1: 
		{	
			skilltree_zlodziejskie(id)
		}
		case 2: 
		{	
			skilltree_magiczne(id)
		}
		case 3: 
		{	
			if(player_point_u[id]>=30){
				player_fast[id]=1
				skilltree_bitewne(id)
			}
		}
		case 4: 
		{	
			if(player_point_u[id]>=30){
				player_fast[id]=1
				skilltree_zlodziejskie(id)
			}
		}
		case 5: 
		{	
			if(player_point_u[id]>=30){
				player_fast[id]=1
				skilltree_magiczne(id)
			}
		}
	}	
	return PLUGIN_HANDLED
}
public znak_tree(id)
{
	new text[513] 
	new keys = (1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<4)|(1<<5)|(1<<6)
	format(text, 512, "\yWybierz znak zodiaku - \r ^n^n\w1. Czeladnik ^n\w2. Atronach ^n\w3. Dama ^n\w4. Lord ^n\w5. Kochanek ^n\w6. Mag ^n\w7. Waz ^n\w8. Ksiezycowy cien ^n\w9. Dalej") 
	keys = (1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<4)|(1<<5)|(1<<6)|(1<<7)|(1<<8)
	show_menu(id, keys, text) 
	return PLUGIN_HANDLED  
} 



public znak_menu(id, key) 
{ 
	switch(key) 
	{ 	
		case 0: 
		{	
			player_znak[id] = Czeladnik
		}
		case 1: 
		{	
			player_znak[id] = Atronach
		}
		case 2: 
		{	
			player_znak[id] = Dama
		}
		case 3: 
		{	
			player_znak[id] = Lord
		}
		case 4: 
		{	
			player_znak[id] = Kochanek
		}
		case 5: 
		{	
			player_znak[id] = Mag
		}
		case 6: 
		{	
			player_znak[id] = Waz
		}
		case 7: 
		{	
			player_znak[id] = Cien
		}
		case 8: 
		{	
			znak_tree2(id)
		}
	}
	

	return PLUGIN_HANDLED
}
public znak_tree2(id)
{
	new text[513] 
	new keys 
	format(text, 512, "\yWybor znaku zodiaku - \r ^n^n\w1. Rumak ^n\w2. Zlodziej ^n\w3. Wojownik ^n\w4. Wieza ^n\w5. Powrot") 
	keys = (1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<4)
	show_menu(id, keys, text) 
	return PLUGIN_HANDLED  
} 




public znak_wybor(id, key) 
{ 
	switch(key) 
	{ 	
		case 0: 
		{	
			player_znak[id] = Rumak
		}
		case 1: 
		{	
			player_znak[id] = Zlodziej
		}
		case 2: 
		{	
			player_znak[id] = Wojownik
		}
		case 3: 
		{	
			player_znak[id] = Wieza
		}
		case 4: 
		{	
			znak_tree(id)
		}
	}
	return PLUGIN_HANDLED
}
public atrybuty_tree(id)
{
	if(player_a_zwinnosc[id] == 0 )return PLUGIN_HANDLED
	new a_player_doda_szczescie = player_doda_szczescie[id] -2
	new a_player_doda_wytrzymalosc = player_doda_wytrzymalosc[id] -2
	new a_player_doda_szybkosc = player_doda_szybkosc[id] -2
	new a_player_doda_zwinnosc = player_doda_zwinnosc[id] -2
	new a_player_doda_inteligencja =player_doda_inteligencja[id] -2
	new a_player_doda_sila_woli = player_doda_sila_woli[id] - 2
	new a_player_doda_sila  = player_doda_sila[id]  -2
	
	if(a_player_doda_szczescie <0 )a_player_doda_szczescie = 0
	if(a_player_doda_wytrzymalosc <0 )a_player_doda_wytrzymalosc = 0
	if(a_player_doda_szybkosc <0 )a_player_doda_szybkosc = 0
	if(a_player_doda_zwinnosc <0 )a_player_doda_zwinnosc = 0
	if(a_player_doda_inteligencja <0)a_player_doda_inteligencja = 0
	if(a_player_doda_sila_woli <0 )a_player_doda_sila_woli = 0
	if(a_player_doda_sila <0 )a_player_doda_sila = 0
	
	
	if(player_fast[id]==1){
		
		if(a_player_doda_szczescie >0 )a_player_doda_szczescie = 19
		if(a_player_doda_wytrzymalosc >0 )a_player_doda_wytrzymalosc = 19
		if(a_player_doda_szybkosc >0 )a_player_doda_szybkosc = 19
		if(a_player_doda_zwinnosc >0 )a_player_doda_zwinnosc = 19
		if(a_player_doda_inteligencja >0)a_player_doda_inteligencja = 19
		if(a_player_doda_sila_woli >0 )a_player_doda_sila_woli = 19
		if(a_player_doda_sila >0 ) a_player_doda_sila = 19
		
		if(a_player_doda_szczescie ==0 )a_player_doda_szczescie = 9
		if(a_player_doda_wytrzymalosc ==0 )a_player_doda_wytrzymalosc = 9
		if(a_player_doda_szybkosc ==0 )a_player_doda_szybkosc = 9
		if(a_player_doda_zwinnosc ==0 )a_player_doda_zwinnosc = 9
		if(a_player_doda_inteligencja ==0)a_player_doda_inteligencja = 9
		if(a_player_doda_sila_woli ==0 )a_player_doda_sila_woli = 9
		if(a_player_doda_sila ==0 )a_player_doda_sila = 9
	}

	
	new text[513] 
	new keys = (1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<4)|(1<<5)|(1<<6)
	
	format(text, 512, "\yWybierz atrybut  ^n^n\r1. Sila [%i]+%i [Pozwala na noszenie ciezszych broni ]^n\r2. Inteligencja [%i]+%i [Zwieksza ilosc many]^n\r3. Sila woli [%i]+%i [Zwieksza szybkosc regeneracji many]^n\r4. Zwinnosc [%i]+%i [Zmniejsza spadek kondycji]^n\r5. Szybkosc [%i]+%i [Zwieksza szybkosc postaci] ^n\r6. Wytrzymalosc [%i]+%i [Zwieksza poczatkowa ilosc zycia i kondycji] ^n\r7. Szczescie [%i]+%i [Wplywa nieznacznie na wszystko]",
	player_a_sila[id] ,a_player_doda_sila+1,player_a_inteligencja[id] ,a_player_doda_inteligencja+1,player_a_sila_woli[id] ,a_player_doda_sila_woli+1,
	player_a_zwinnosc[id],a_player_doda_zwinnosc+1 ,player_a_szybkosc[id],a_player_doda_szybkosc+1,player_a_wytrzymalosc[id] ,a_player_doda_wytrzymalosc+1,player_a_szczescie[id],a_player_doda_szczescie+1 ) 
	

	
	
	keys = (1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<4)|(1<<5)|(1<<6)
	show_menu(id, keys, text) 
	return PLUGIN_HANDLED  
} 










public atrybuty_menu(id, key) 
{ 
	new a_player_doda_szczescie = player_doda_szczescie[id] -2
	new a_player_doda_wytrzymalosc = player_doda_wytrzymalosc[id] -2
	new a_player_doda_szybkosc = player_doda_szybkosc[id] -2
	new a_player_doda_zwinnosc = player_doda_zwinnosc[id] -2
	new a_player_doda_inteligencja =player_doda_inteligencja[id] -2
	new a_player_doda_sila_woli = player_doda_sila_woli[id] - 2
	new a_player_doda_sila  = player_doda_sila[id]  -2
	
	if(a_player_doda_szczescie <0 )a_player_doda_szczescie = 0
	if(a_player_doda_wytrzymalosc <0 )a_player_doda_wytrzymalosc = 0
	if(a_player_doda_szybkosc <0 )a_player_doda_szybkosc = 0
	if(a_player_doda_zwinnosc <0 )a_player_doda_zwinnosc = 0
	if(a_player_doda_inteligencja <0)a_player_doda_inteligencja = 0
	if(a_player_doda_sila_woli <0 )a_player_doda_sila_woli = 0
	if(a_player_doda_sila <0 )a_player_doda_sila = 0
	
	
	if(player_fast[id]==1){
		
		if(a_player_doda_szczescie >0 )a_player_doda_szczescie = 19
		if(a_player_doda_wytrzymalosc >0 )a_player_doda_wytrzymalosc = 19
		if(a_player_doda_szybkosc >0 )a_player_doda_szybkosc = 19
		if(a_player_doda_zwinnosc >0 )a_player_doda_zwinnosc = 19
		if(a_player_doda_inteligencja >0)a_player_doda_inteligencja = 19
		if(a_player_doda_sila_woli >0 )a_player_doda_sila_woli = 19
		if(a_player_doda_sila >0 )a_player_doda_sila = 19
		
		if(a_player_doda_szczescie ==0 )a_player_doda_szczescie = 9
		if(a_player_doda_wytrzymalosc ==0 )a_player_doda_wytrzymalosc = 9
		if(a_player_doda_szybkosc ==0 )a_player_doda_szybkosc = 9
		if(a_player_doda_zwinnosc ==0 )a_player_doda_zwinnosc = 9
		if(a_player_doda_inteligencja ==0)a_player_doda_inteligencja = 9
		if(a_player_doda_sila_woli ==0 )a_player_doda_sila_woli = 9
		if(a_player_doda_sila ==0 )a_player_doda_sila = 9
	}
	
	new max_skill= 150
	switch(key) 
	{ 	
		case 0: 
		{	
			if (player_a_sila[id]+a_player_doda_sila<max_skill){
				player_sila[id]+=1+a_player_doda_sila
				player_a_sila[id]+=1+a_player_doda_sila
			}
			else{
				client_print(id,print_center,"Maxymalny poziom osiagniety")
				return PLUGIN_HANDLED
			} 
			
		}
		case 1: 
		{	
			if (player_a_inteligencja[id]+a_player_doda_inteligencja<max_skill){	
				player_a_inteligencja[id]+=1+a_player_doda_inteligencja
				player_inteligencja[id]+=1+a_player_doda_inteligencja
			}
			else{
				client_print(id,print_center,"Maxymalny poziom osiagniety")
				return PLUGIN_HANDLED
			} 
		}
		case 2: 
		{	
			if (player_a_sila_woli[id]+a_player_doda_sila_woli<max_skill){
				player_sila_woli[id]+=1+a_player_doda_sila_woli
				player_a_sila_woli[id]+=1+a_player_doda_sila_woli
			}
			else{
				client_print(id,print_center,"Maxymalny poziom osiagniety")
				return PLUGIN_HANDLED
			} 
			
		}
		case 3: 
		{	
			if (player_a_zwinnosc[id]+a_player_doda_zwinnosc<max_skill){
				player_zwinnosc[id]+=1+a_player_doda_zwinnosc
				player_a_zwinnosc[id]+=1+a_player_doda_zwinnosc
			}
			else{
				client_print(id,print_center,"Maxymalny poziom osiagniety")
				return PLUGIN_HANDLED
			} 
		}
		case 4: 
		{	
			if (player_a_szybkosc[id]+player_doda_szybkosc[id]<max_skill){
				player_szybkosc[id]+=1+a_player_doda_szybkosc
				player_a_szybkosc[id]+=1+a_player_doda_szybkosc
			}
			else{
				client_print(id,print_center,"Maxymalny poziom osiagniety")
				return PLUGIN_HANDLED
			} 
		}
		case 5: 
		{	
			if (player_a_wytrzymalosc[id]+a_player_doda_wytrzymalosc<max_skill){
				player_wytrzymalosc[id]+=1+a_player_doda_wytrzymalosc
				player_a_wytrzymalosc[id]+=1+a_player_doda_wytrzymalosc
			}
			else{
				client_print(id,print_center,"Maxymalny poziom osiagniety")
				return PLUGIN_HANDLED
			} 
		}
		case 6: 
		{	
			if (player_a_szczescie[id]+a_player_doda_szczescie <max_skill){
				player_szczescie[id]+=1+a_player_doda_szczescie 
				player_a_szczescie[id]+=1+a_player_doda_szczescie 
			}
			else{
				client_print(id,print_center,"Maxymalny poziom osiagniety")
				return PLUGIN_HANDLED
			} 
		}
	}
	
	player_doda_szczescie[id] = 0
	player_doda_wytrzymalosc[id] = 0
	player_doda_szybkosc[id] = 0
	player_doda_zwinnosc[id] = 0
	player_doda_inteligencja[id] = 0
	player_doda_sila_woli[id] = 0
	player_doda_sila[id] = 0
	player_nxt_update[id] = 0
	
	skilltree_nxt(id)
	return PLUGIN_HANDLED
}


public skilltree_bitewne(id)
{
	new text[513] 	
	new keys
	new max_skill= 100
	if(player_lvl[id]<=uczen) max_skill= 25
	if(player_lvl[id]<=czeladnik && player_lvl[id]>uczen) max_skill= 50
	if(player_lvl[id]<=ekspert && player_lvl[id]>czeladnik) max_skill= 75
	format(text, 512, "\yWybierz umiejetnosc bitewna - \rPunkty: %i^nMaximum: %i^n^n\w1.Ostrze [%i][Zwieksza obrazenia zadawane nozem]^n\w2.Bron Lekka [%i][Zwieksza obrazenia zadawane pistoletami, shotgunami i smg]^n\w3.Bron Ciezka [%i][Zwieksza obrazenia zadawane riflami i machine gunami]^n\w4.Ciezki pancerz [%i][Pozwala odbic pocisk, ale spowalnia]^n\w5.Platnerstwo [%i][Daje kamizelke] ^n\w6.Blok[%i][Zmniejsza otrzymywane obrazenia od atakow zwyklych ] ^n\w0.Powrot",
	player_point_u[id],max_skill,player_a_ostrze[id]  ,player_a_bron_lekka[id] ,player_a_bron_ciezka[id] ,player_a_ciezki_pancerz[id],player_a_platnerstwo[id],player_a_blok[id] ) 
	
	keys = (1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<4)|(1<<5)|(1<<9)
	show_menu(id, keys, text) 
	return PLUGIN_HANDLED  
} 

public skill_menu_bitewne(id, key) 
{ 
	if(player_fast[id]==0){
		new max_skill= 100
		if(player_lvl[id]<=uczen) max_skill= 25
		if(player_lvl[id]<=czeladnik && player_lvl[id]>uczen) max_skill= 50
		if(player_lvl[id]<=ekspert && player_lvl[id]>czeladnik) max_skill= 75
		switch(key) 
		{ 	
			case 0: 
			{	
				if (player_a_ostrze[id]<max_skill){
					player_point_u[id]-=1
					player_ostrze[id]+=1
					player_a_ostrze[id]+=1
					player_doda_zwinnosc[id]+=1
				}
				else client_print(id,print_center,"Maxymalny poziom osiagniety")
				
			}
			case 1: 
			{	
				if (player_a_bron_lekka[id]<max_skill){
					player_point_u[id]-=1	
					player_bron_lekka[id]+=1
					player_a_bron_lekka[id]+=1
					player_doda_zwinnosc[id]+=1
				}
				else client_print(id,print_center,"Maxymalny poziom osiagniety")
			}
			case 2: 
			{	
				if (player_a_bron_ciezka[id]<max_skill){
					player_point_u[id]-=1
					player_bron_ciezka[id]+=1
					player_a_bron_ciezka[id]+=1
					player_doda_sila[id]+=1
				}
				else client_print(id,print_center,"Maxymalny poziom osiagniety")
				
			}
			case 3: 
			{	
				if (player_a_ciezki_pancerz[id]<max_skill){
					player_point_u[id]-=1
					player_ciezki_pancerz[id]+=1
					player_a_ciezki_pancerz[id]+=1
					player_doda_wytrzymalosc[id]+=1
				}
				else client_print(id,print_center,"Maxymalny poziom osiagniety")
			}
			case 4: 
			{	
				if (player_a_platnerstwo[id]<max_skill){
					player_point_u[id]-=1
					player_platnerstwo[id]+=1
					player_a_platnerstwo[id]+=1
					player_doda_wytrzymalosc[id]+=1
				}
				else client_print(id,print_center,"Maxymalny poziom osiagniety")
			}
			case 5: 
			{	
				if (player_a_blok[id]<max_skill){
					player_point_u[id]-=1
					player_blok[id]+=1
					player_a_blok[id]+=1
					player_doda_wytrzymalosc[id]+=1
				}
				else client_print(id,print_center,"Maxymalny poziom osiagniety")
			}
			case 9: 
			{
				skilltree_nxt(id)
				return PLUGIN_HANDLED
			}
		}
		player_nxt_update[id] = player_doda_sila[id] +  player_doda_sila_woli[id] +player_doda_inteligencja[id]+player_doda_zwinnosc[id]+player_doda_szybkosc[id]+player_doda_wytrzymalosc[id]+player_doda_szczescie[id]
		
		if(player_point_u[id] > 0 && player_nxt_update[id] <3)skilltree_bitewne(id)
		else skilltree_nxt(id)
		return PLUGIN_HANDLED
	} else{
		new max_skill= 100
		if(player_lvl[id]<=uczen) max_skill= 25
		if(player_lvl[id]<=czeladnik && player_lvl[id]>uczen) max_skill= 50
		if(player_lvl[id]<=ekspert && player_lvl[id]>czeladnik) max_skill= 75
		switch(key) 
		{ 	
			case 0: 
			{	
				if (player_a_ostrze[id]+30<=max_skill){
					player_point_u[id]-=30
					player_ostrze[id]+=30
					player_a_ostrze[id]+=30
					player_doda_zwinnosc[id]+=30
				}
				else client_print(id,print_center,"Maxymalny poziom osiagniety")
				
			}
			case 1: 
			{	
				if (player_a_bron_lekka[id]+30<=max_skill){
					player_point_u[id]-=30	
					player_bron_lekka[id]+=30
					player_a_bron_lekka[id]+=30
					player_doda_zwinnosc[id]+=30
				}
				else client_print(id,print_center,"Maxymalny poziom osiagniety")
			}
			case 2: 
			{	
				if (player_a_bron_ciezka[id]+30<=max_skill){
					player_point_u[id]-=30
					player_bron_ciezka[id]+=30
					player_a_bron_ciezka[id]+=30
					player_doda_sila[id]+=30
				}
				else client_print(id,print_center,"Maxymalny poziom osiagniety")
				
			}
			case 3: 
			{	
				if (player_a_ciezki_pancerz[id]+30<=max_skill){
					player_point_u[id]-=30
					player_ciezki_pancerz[id]+=30
					player_a_ciezki_pancerz[id]+=30
					player_doda_wytrzymalosc[id]+=30
				}
				else client_print(id,print_center,"Maxymalny poziom osiagniety")
			}
			case 4: 
			{	
				if (player_a_platnerstwo[id]+30<=max_skill){
					player_point_u[id]-=30
					player_platnerstwo[id]+=30
					player_a_platnerstwo[id]+=30
					player_doda_wytrzymalosc[id]+=30
				}
				else client_print(id,print_center,"Maxymalny poziom osiagniety")
			}
			case 5: 
			{	
				if (player_a_blok[id]+30<=max_skill){
					player_point_u[id]-=30
					player_blok[id]+=30
					player_a_blok[id]+=30
					player_doda_wytrzymalosc[id]+=30
				}
				else client_print(id,print_center,"Maxymalny poziom osiagniety")
			}
			case 9: 
			{
				skilltree_nxt(id)
				return PLUGIN_HANDLED
			}
		}
		player_nxt_update[id] = player_doda_sila[id] +  player_doda_sila_woli[id] +player_doda_inteligencja[id]+player_doda_zwinnosc[id]+player_doda_szybkosc[id]+player_doda_wytrzymalosc[id]+player_doda_szczescie[id]
		
		if(player_point_u[id] > 0 && player_nxt_update[id] <3)skilltree_bitewne(id)
		else skilltree_nxt(id)
		return PLUGIN_HANDLED
	}
	return PLUGIN_HANDLED
}

public skilltree_zlodziejskie(id)
{
	new text[513] 
	new keys
	new max_skill= 100
	if(player_lvl[id]<=uczen) max_skill= 25
	if(player_lvl[id]<=czeladnik && player_lvl[id]>uczen) max_skill= 50
	if(player_lvl[id]<=ekspert && player_lvl[id]>czeladnik) max_skill= 75
	format(text, 512, "\yWybierz umiejetnosc zlodziejska - \rPunkty: %i^nMaximum: %i^n^n\w1.Handel [%i][Dodatkowa kasa na poczatek rundy]^n\w2.Skradanie sie [%i][Czyni postac mniej widzialna gdy kuca z nozem]^n\w3.Akrobatyka [%i][Zwieksza wysokosc skoku]^n\w4.Lekki pancerz [%i][Nieznacznie zmniejsza obrazenia od zwyklej broni]^n\w5.Celnosc [%i][Zwieksza celnosc luku, szybsze przeladowanie luku, silniejszy strzal] ^n\w6.Atletyka [%i][Szybsza regeneracja kondycji, zwiekszenie szybkosci gracza ]^n\w0.Powrot",
	player_point_u[id],max_skill,player_a_handel[id]  ,player_a_skradanie[id] ,player_a_akrobatyka[id] ,player_a_lekki_pancerz[id],player_a_celnosc[id],player_a_atletyka[id] ) 
	
	keys = (1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<4)|(1<<5)|(1<<9)
	show_menu(id, keys, text) 
	return PLUGIN_HANDLED  
} 


public skill_menu_zlodziejskie(id, key) 
{ 
	if(player_fast[id]==0){
		new max_skill= 100
		if(player_lvl[id]<=uczen) max_skill= 25
		if(player_lvl[id]<=czeladnik && player_lvl[id]>uczen) max_skill= 50
		if(player_lvl[id]<=ekspert && player_lvl[id]>czeladnik) max_skill= 75
		switch(key) 
		{ 	
			case 0: 
			{	
				if (player_a_handel[id]<max_skill){
					player_point_u[id]-=1
					player_a_handel[id]+=1
					player_handel[id]+=1
					player_doda_inteligencja[id]+=1
				}
				else client_print(id,print_center,"Maxymalny poziom osiagniety")
				
			}
			case 1: 
			{	
				if (player_a_skradanie[id]<max_skill){
					player_point_u[id]-=1	
					player_a_skradanie[id]+=1
					player_skradanie[id]+=1
					player_doda_zwinnosc[id]+=1
				}
				else client_print(id,print_center,"Maxymalny poziom osiagniety")
			}
			case 2: 
			{	
				if (player_a_akrobatyka[id]<max_skill){
					player_point_u[id]-=1
					player_a_akrobatyka[id]+=1
					player_akrobatyka[id]+=1
					player_doda_szybkosc[id]+=1
				}
				else client_print(id,print_center,"Maxymalny poziom osiagniety")
				
			}
			case 3: 
			{	
				if (player_a_lekki_pancerz[id]<max_skill){
					player_point_u[id]-=1
					player_a_lekki_pancerz[id]+=1
					player_lekki_pancerz[id]+=1
					player_doda_szybkosc[id]+=1
				}
				else client_print(id,print_center,"Maxymalny poziom osiagniety")
			}
			case 4: 
			{	
				if (player_a_celnosc[id]<max_skill){
					player_point_u[id]-=1
					player_a_celnosc[id]+=1
					player_celnosc[id]+=1
					player_doda_zwinnosc[id]+=1
				}
				else client_print(id,print_center,"Maxymalny poziom osiagniety")
			}
			case 5: 
			{	
				if (player_a_atletyka[id]<max_skill){
					player_point_u[id]-=1
					player_a_atletyka[id]+=1
					player_atletyka[id]+=1
					player_doda_szybkosc[id]+=1
				}
				else client_print(id,print_center,"Maxymalny poziom osiagniety")
			}
			case 9: 
			{
				skilltree_nxt(id)
				return PLUGIN_HANDLED
			}
		}
		player_nxt_update[id] = player_doda_sila[id] +  player_doda_sila_woli[id] +player_doda_inteligencja[id]+player_doda_zwinnosc[id]+player_doda_szybkosc[id]+player_doda_wytrzymalosc[id]+player_doda_szczescie[id]
		
		if(player_point_u[id] > 0 && player_nxt_update[id] <3)skilltree_zlodziejskie(id)
		else skilltree_nxt(id)
		return PLUGIN_HANDLED
	} else{
		new max_skill= 100
		if(player_lvl[id]<=uczen) max_skill= 25
		if(player_lvl[id]<=czeladnik && player_lvl[id]>uczen) max_skill= 50
		if(player_lvl[id]<=ekspert && player_lvl[id]>czeladnik) max_skill= 75
		switch(key) 
		{ 	
			case 0: 
			{	
				if (player_a_handel[id]+30<=max_skill){
					player_point_u[id]-=30
					player_a_handel[id]+=30
					player_handel[id]+=30
					player_doda_inteligencja[id]+=30
				}
				else client_print(id,print_center,"Maxymalny poziom osiagniety")
				
			}
			case 1: 
			{	
				if (player_a_skradanie[id]+30<=max_skill){
					player_point_u[id]-=30	
					player_a_skradanie[id]+=30
					player_skradanie[id]+=30
					player_doda_zwinnosc[id]+=30
				}
				else client_print(id,print_center,"Maxymalny poziom osiagniety")
			}
			case 2: 
			{	
				if (player_a_akrobatyka[id]+30<=max_skill){
					player_point_u[id]-=30
					player_a_akrobatyka[id]+=30
					player_akrobatyka[id]+=30
					player_doda_szybkosc[id]+=30
				}
				else client_print(id,print_center,"Maxymalny poziom osiagniety")
				
			}
			case 3: 
			{	
				if (player_a_lekki_pancerz[id]+30<=max_skill){
					player_point_u[id]-=30
					player_a_lekki_pancerz[id]+=30
					player_lekki_pancerz[id]+=30
					player_doda_szybkosc[id]+=30
				}
				else client_print(id,print_center,"Maxymalny poziom osiagniety")
			}
			case 4: 
			{	
				if (player_a_celnosc[id]+30<=max_skill){
					player_point_u[id]-=30
					player_a_celnosc[id]+=30
					player_celnosc[id]+=30
					player_doda_zwinnosc[id]+=30
				}
				else client_print(id,print_center,"Maxymalny poziom osiagniety")
			}
			case 5: 
			{	
				if (player_a_atletyka[id]+30<=max_skill){
					player_point_u[id]-=30
					player_a_atletyka[id]+=30
					player_atletyka[id]+=30
					player_doda_szybkosc[id]+=30
				}
				else client_print(id,print_center,"Maxymalny poziom osiagniety")
			}
			case 9: 
			{
				skilltree_nxt(id)
				return PLUGIN_HANDLED
			}
		}
		player_nxt_update[id] = player_doda_sila[id] +  player_doda_sila_woli[id] +player_doda_inteligencja[id]+player_doda_zwinnosc[id]+player_doda_szybkosc[id]+player_doda_wytrzymalosc[id]+player_doda_szczescie[id]
		
		if(player_point_u[id] > 0 && player_nxt_update[id] <3)skilltree_zlodziejskie(id)
		else skilltree_nxt(id)
		return PLUGIN_HANDLED
	}
	return PLUGIN_HANDLED
}
public skilltree_magiczne(id)
{
	new text[513] 
	new keys
	
	new max_skill= 100
	if(player_lvl[id]<=uczen) max_skill= 25
	if(player_lvl[id]<=czeladnik && player_lvl[id]>uczen) max_skill= 50
	if(player_lvl[id]<=ekspert && player_lvl[id]>czeladnik) max_skill= 75
	format(text, 512, "\yWybierz umiejetnosc magiczna - \rPunkty: %i^nMaximum: %i^n^n\w1.Przywrocenie [%i][Zaklecia przywracajace]^n\w2.Iluzja [%i][Zaklecia iluzji]^n\w3.Przywolanie [%i][Zwieksza przywolujace bron]^n\w4.Mistycyzm [%i][Zaklecia absorbujace/odbijajace magie i zwykly atak ]^n\w5.Przemiana [%i][Zaklecia spowalniajace, wyrzucajace bron] ^n\w6.Zniszczenie [%i][Zaklecia atakujace]  ^n\w0.Powrot",
	player_point_u[id],max_skill,player_a_przywrocenie[id]  ,player_a_iluzja[id],player_a_przywolanie[id] ,player_a_mistycyzm[id],player_a_przemiana[id] ,player_a_zniszczenie[id] ) 
	
	keys = (1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<4)|(1<<5)|(1<<9)
	show_menu(id, keys, text) 
	return PLUGIN_HANDLED  
} 


public skill_menu_magiczne(id, key) 
{ 
	if(player_fast[id]==0){
		new max_skill= 100
		if(player_lvl[id]<=uczen) max_skill= 25
		if(player_lvl[id]<=czeladnik && player_lvl[id]>uczen) max_skill= 50
		if(player_lvl[id]<=ekspert && player_lvl[id]>czeladnik) max_skill= 75
		switch(key) 
		{ 	
			case 0: 
			{	
				if (player_a_przywrocenie[id]<max_skill){
					player_point_u[id]-=1
					player_a_przywrocenie[id]+=1
					player_przywrocenie[id]+=1
					player_doda_sila_woli[id]+=1
				}
				else client_print(id,print_center,"Maxymalny poziom osiagniety")
				
			}
			case 1: 
			{	
				if (player_a_iluzja[id] <max_skill){
					player_point_u[id]-=1	
					player_a_iluzja[id] +=1
					player_iluzja[id] +=1
					player_doda_inteligencja[id]+=1
				}
				else client_print(id,print_center,"Maxymalny poziom osiagniety")
			}
			case 2: 
			{	
				if (player_a_przywolanie[id]<max_skill){
					player_point_u[id]-=1
					player_a_przywolanie[id]+=1
					player_przywolanie[id]+=1
					player_doda_inteligencja[id]+=1
				}
				else client_print(id,print_center,"Maxymalny poziom osiagniety")
				
			}
			case 3: 
			{	
				if (player_a_mistycyzm[id] <max_skill){
					player_point_u[id]-=1
					player_a_mistycyzm[id] +=1
					player_mistycyzm[id] +=1
					player_doda_inteligencja[id]+=1
				}
				else client_print(id,print_center,"Maxymalny poziom osiagniety")
			}
			case 4: 
			{	
				if (player_a_przemiana[id] <max_skill){
					player_point_u[id]-=1
					player_a_przemiana[id] +=1
					player_przemiana[id] +=1
					player_doda_sila_woli[id]+=1
				}
				else client_print(id,print_center,"Maxymalny poziom osiagniety")
			}
			case 5: 
			{	
				if (player_a_zniszczenie[id]<max_skill){
					player_point_u[id]-=1
					player_a_zniszczenie[id]+=1
					player_zniszczenie[id]+=1
					player_doda_sila_woli[id]+=1
				}
				else client_print(id,print_center,"Maxymalny poziom osiagniety")
			}
			case 9: 
			{
				skilltree_nxt(id)
				return PLUGIN_HANDLED
			}
		}
		player_nxt_update[id] = player_doda_sila[id] +  player_doda_sila_woli[id] +player_doda_inteligencja[id]+player_doda_zwinnosc[id]+player_doda_szybkosc[id]+player_doda_wytrzymalosc[id]+player_doda_szczescie[id]
		
		if(player_point_u[id] > 0 && player_nxt_update[id] <3)skilltree_magiczne(id)
		else skilltree_nxt(id)	
		return PLUGIN_HANDLED
	} else{
		new max_skill= 100
		if(player_lvl[id]<=uczen) max_skill= 25
		if(player_lvl[id]<=czeladnik && player_lvl[id]>uczen) max_skill= 50
		if(player_lvl[id]<=ekspert && player_lvl[id]>czeladnik) max_skill= 75
		switch(key) 
		{ 	
			case 0: 
			{	
				if (player_a_przywrocenie[id]+30<=max_skill){
					player_point_u[id]-=30
					player_a_przywrocenie[id]+=30
					player_przywrocenie[id]+=30
					player_doda_sila_woli[id]+=30
				}
				else client_print(id,print_center,"Maxymalny poziom osiagniety")
				
			}
			case 1: 
			{	
				if (player_a_iluzja[id]+30<=max_skill){
					player_point_u[id]-=30	
					player_a_iluzja[id] +=30
					player_iluzja[id] +=30
					player_doda_inteligencja[id]+=30
				}
				else client_print(id,print_center,"Maxymalny poziom osiagniety")
			}
			case 2: 
			{	
				if (player_a_przywolanie[id]+30<=max_skill){
					player_point_u[id]-=30
					player_a_przywolanie[id]+=30
					player_przywolanie[id]+=30
					player_doda_inteligencja[id]+=30
				}
				else client_print(id,print_center,"Maxymalny poziom osiagniety")
				
			}
			case 3: 
			{	
				if (player_a_mistycyzm[id]+30<=max_skill){
					player_point_u[id]-=30
					player_a_mistycyzm[id] +=30
					player_mistycyzm[id] +=30
					player_doda_inteligencja[id]+=30
				}
				else client_print(id,print_center,"Maxymalny poziom osiagniety")
			}
			case 4: 
			{	
				if (player_a_przemiana[id]+30<=max_skill){
					player_point_u[id]-=30
					player_a_przemiana[id] +=30
					player_przemiana[id] +=30
					player_doda_sila_woli[id]+=30
				}
				else client_print(id,print_center,"Maxymalny poziom osiagniety")
			}
			case 5: 
			{	
				if (player_a_zniszczenie[id]+30<=max_skill){
					player_point_u[id]-=30
					player_a_zniszczenie[id]+=30
					player_zniszczenie[id]+=30
					player_doda_sila_woli[id]+=30
				}
				else client_print(id,print_center,"Maxymalny poziom osiagniety")
			}
			case 9: 
			{
				skilltree_nxt(id)
				return PLUGIN_HANDLED
			}
		}
		player_nxt_update[id] = player_doda_sila[id] +  player_doda_sila_woli[id] +player_doda_inteligencja[id]+player_doda_zwinnosc[id]+player_doda_szybkosc[id]+player_doda_wytrzymalosc[id]+player_doda_szczescie[id]
		
		if(player_point_u[id] > 0 && player_nxt_update[id] <3)skilltree_magiczne(id)
		else skilltree_nxt(id)	
		return PLUGIN_HANDLED
	}
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


	
public got_bomb(id){ 
	planter = id; 
	return PLUGIN_CONTINUE 
} 

public count_avg_lvl()
{
	new ccTT = 0
	new sumTT = 0
	new ccCT = 0
	new sumCT = 0
	for(new a=0;a<32;a++){
		if(!is_user_connected(a)) continue;
		if(player_class[a] != 0 && player_lvl[a] > 5 && cs_get_user_team(a) == CS_TEAM_T)
		{
			sumTT = sumTT + player_lvl[a];
			ccTT = ccTT + 1;
		}
		if(player_class[a] != 0 && player_lvl[a] > 5 && cs_get_user_team(a) == CS_TEAM_CT)
		{
			sumCT = sumCT + player_lvl[a];
			ccCT = ccCT + 1;
		}
	}
	if(ccTT == 0) ccTT++
	if(ccCT == 0) ccCT++
	avg_lvlCT = sumCT / ccCT
	avg_lvlTT = sumTT / ccTT


	avg_lvl = ( avg_lvlCT + avg_lvlTT )/2
}
public award_esc()
{
	count_avg_lvl()
	new Players[32], playerCount, id
	get_players(Players, playerCount, "aeh", "CT") 
	new pln = get_playersnum() 
	if(pln > 12) pln  = 12
	new exp = get_cvar_num("diablo_xpbonus2") * pln /2
	for (new i=0; i<playerCount; i++) 
	{
		id = Players[i]
		if(!is_user_connected(id)) continue;
		exp = calc_award_goal_xp(id,exp,0)
		Give_Xp(id,exp)	
		client_print(id,print_chat,"Dostales *%i* doswiadczenia za ucieczke vipa",xp_mnoznik(id, exp))
		player_wys[id]=1
	}	
	daj_blog(defuser)
}
public award_plant()
{
	count_avg_lvl()
	new Players[32], playerCount, id
	get_players(Players, playerCount, "aeh", "TERRORIST") 
	new pln = get_playersnum() 
	if(pln > 12) pln  = 12
	new exp = get_cvar_num("diablo_xpbonus2") * pln/2
	for (new i=0; i<playerCount; i++) 
	{
		id = Players[i]
		if(!is_user_connected(id)) continue;
		exp = calc_award_goal_xp(id,exp, 0)
		Give_Xp(id,exp)	
		client_print(id,print_chat,"Dostales *%i* doswiadczenia za polozenie bomby przez twoj team",xp_mnoznik(id, exp))
		player_wys[id]=1
	}	
	closeXp(planter)
	planter=0
}

public bomb_defusing(id){ 
    defuser = id; 
    return PLUGIN_CONTINUE 
   
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
	}
	return exp
}
public moreLvl2(player_lvl, av)
{
	if(player_lvl < 5 || avg_lvl < 5) return 1
	if(av==0) av = avg_lvl
	new vicl = av
	new killl = player_lvl
	
		
	new more_lvl=vicl - killl 
	if(more_lvl > 50 && get_playersnum() < 6) more_lvl = 50
	if(more_lvl < -50 &&  avg_lvl > 125) more_lvl = -50
	return more_lvl
}

public award_defuse()
{
	count_avg_lvl()
	new Players[32], playerCount, id
	get_players(Players, playerCount, "aeh", "CT") 
	new pln = get_playersnum() 
	if(pln > 12) pln  = 12
	new exp = get_cvar_num("diablo_xpbonus2") * pln * 3 /5
	for (new i=0; i<playerCount; i++) 
	{
		id = Players[i] 
		if(!is_user_connected(id)) continue;
		exp = calc_award_goal_xp(id,exp,0)
		Give_Xp(id,exp)
		client_print(id,print_chat,"Dostales *%i* doswiadczenia za rozbrojenie bomby przez twoj team",xp_mnoznik(id, exp))
		player_wys[id]=1
	}
	closeXp(defuser)
	daj_blog(defuser)
}
public award_hostageALL(id)
{
	count_avg_lvl()
	new Players[32], playerCount, id
	get_players(Players, playerCount, "aeh", "CT") 
	new pln = get_playersnum() 
	if(pln > 12) pln  = 12
	new exp = get_cvar_num("diablo_xpbonus2") * pln /3
	for (new i=0; i<playerCount; i++) 
	{
		id = Players[i] 
		if(!is_user_connected(id)) continue;
		exp = calc_award_goal_xp(id,exp,0)
		Give_Xp(id,exp)
		client_print(id,print_chat,"Dostales *%i* doswiadczenia za wyprowadzenie zakladnikow przez twoj team",xp_mnoznik(id, exp))
		player_wys[id]=1
	}	
	daj_blog(defuser)
}

public closeXp(id)
{
	new entlist[513]
	new numfound = find_sphere_class(id,"player",500.0,entlist,512)
	new pln = get_playersnum() 
	if(pln > 12) pln  = 12			
	for (new i=0; i < numfound; i++)
	{		
		new pid = entlist[i]
								
		if (!is_user_alive(pid) || get_user_team(id) != get_user_team(pid) || cs_get_user_team(pid) == CS_TEAM_SPECTATOR )
			continue
		
		
		if(pid == id){
			new exp = get_cvar_num("diablo_xpbonus2") * pln /3
			exp = calc_award_goal_xp(id,exp,0)
			client_print(pid,print_chat,"Dostales *%i* doswiadczenia za cele mapy",xp_mnoznik(id, exp))
			player_wys[pid]=1
			Give_Xp(pid,exp)
			if(random_num(0,1)==0)daj_blog(id)
			player_sp[id] += 100
		}else{
			new exp = get_cvar_num("diablo_xpbonus2") * pln   / 5
			exp = calc_award_goal_xp(id,exp,0)
			client_print(pid,print_chat,"Dostales *%i* doswiadczenia za asyste lidera",xp_mnoznik(id, exp))
			player_wys[pid]=1
			Give_Xp(pid,exp)
		}
				
	}
}


/* ==================================================================================================== */
public xp_mnoznik(id, amount){
	if(get_user_flags(id) & ADMIN_LEVEL_D || player_vip[id]==1){
		amount = floatround(1.6*amount)
	}
	else if(get_user_flags(id) & ADMIN_LEVEL_C || player_vip[id]==2){
		amount = floatround(1.3*amount)
	}
	return amount

}

public award_kill(killer_id,victim_id)
{
	if(player_lvl[victim_id]<10 && player_lvl[victim_id] >2){
		if(pomoc_off[victim_id]==0){
			client_cmd(victim_id,"say /poradnik")
			pomoc_off[victim_id]=1
		}
	}
	
	if (!is_user_connected(killer_id) || !is_user_connected(victim_id))
		return PLUGIN_CONTINUE
		
	new xp_award = get_cvar_num("diablo_xpbonus")
	mikstura_daj(killer_id)
	new Team[32]
	get_user_team(killer_id,Team,31)
	

	if (moreLvl(victim_id, killer_id)> 25 && get_playersnum() > 6) 
		xp_award+=get_cvar_num("diablo_xpbonus")/4 + (get_cvar_num("diablo_xpbonus")/10 * moreLvl(victim_id, killer_id) / 10)
		
	if (moreLvl(victim_id, killer_id) < -25) 
		xp_award-=get_cvar_num("diablo_xpbonus")/4
	
	xp_award = xp_award * calc_exp_perc(victim_id, killer_id) / 100	
	if(xp_award<1)xp_award =1 
	Give_Xp(killer_id,xp_award)
	
	
	add_respawn_bonus(victim_id)
	add_bonus_explode(victim_id)
	if (player_a_handel[killer_id] > ekspert){
		refill_ammo(killer_id)
	}
	if (player_a_handel[killer_id] > mistrz){
		cs_set_user_money(killer_id,cs_get_user_money(killer_id)+500)
	}
	new arm = get_user_armor(killer_id)

	if(player_a_platnerstwo[killer_id]> czeladnik && is_user_alive(killer_id)){
		if(arm < 100) set_user_armor(killer_id,100)
		if(player_a_platnerstwo[killer_id]> ekspert){
			if(arm < 200) set_user_armor(killer_id,200)
		}
		if(player_a_platnerstwo[killer_id]> mistrz){
			if(arm < 300) set_user_armor(killer_id,300)
		}
	}

		

	if(dragon[victim_id]==1) Give_Xp(killer_id,xp_award+500)
	player_wys[killer_id]=1

	return PLUGIN_CONTINUE
	
}
public calc_exp_perc(victim_id, killer_id)
{
	new more_lvl=moreLvl(victim_id, killer_id)
	
	new podzielnik = 1
	if(avg_lvl > 25) podzielnik = 1
	if(avg_lvl > 75) podzielnik = 2
	if(avg_lvl > 100) podzielnik = 3
	if(avg_lvl > 125) podzielnik = 4
	if(avg_lvl > 150) podzielnik = 5
	if(avg_lvl > 175) podzielnik = 6
	if(avg_lvl > 200) podzielnik = 7
	
	
	new ret = ((5 * more_lvl / 5) / podzielnik) + 100
	
	if(more_lvl > podzielnik*10) ret += (10 * (more_lvl - 55) / podzielnik)
	if(more_lvl < -podzielnik*10) ret += (10 * (more_lvl + 55) / podzielnik)

	if(ret < 1) ret = 1
	if(ret > 300) ret = 300
	return ret
}

public moreLvl(victim_id, killer_id)
{
	new vicl = player_lvl[victim_id]
	new killl = player_lvl[killer_id]

	new more_lvl=vicl - killl
	if(more_lvl > 50 && get_playersnum() < 4) more_lvl = 50
	return more_lvl
}


public Give_Xp(id,amount)
{	
	diablo_typ = get_cvar_num("diablo_typ")
	if(get_user_flags(id) & ADMIN_LEVEL_D || player_vip[id]==1){
		amount = floatround(1.5*amount)
		
	}
	else if(get_user_flags(id) & ADMIN_LEVEL_C || player_vip[id]==2){
		amount = floatround(2.0*amount)
	}
	if(u_sid[id] > 0){
		amount = floatround(1.3*amount)
	}
	if(player_lvl[id] > 50){
		amount = floatround(0.8*amount)
	}
	if(player_lvl[id] > 75){
		amount = floatround(0.8*amount)
	}
	if(player_lvl[id] > 100){
		amount = floatround(0.8*amount)
	}
	if(player_lvl[id] > 125){
		amount = floatround(0.8*amount)
	}
	if(player_lvl[id] > 150){
		amount = floatround(0.8*amount)
	}
	if(player_lvl[id] > 175){
		amount = floatround(0.8*amount)
	}
	if(player_lvl[id] > 200){
		amount = floatround(0.8*amount)
	}
	
	
	if(player_class_lvl[id][player_class[id]]<0 ||player_lvl[id]<0){
		player_class_lvl[id][player_class[id]] = 2
		player_lvl[id] = 2 
	}
	
	if(player_class_lvl[id][player_class[id]]==player_lvl[id])
	{
		if(diablo_typ==2  && player_lvl[id] >= 99) {
			LevelXP[100]= LevelXP[99]*3
			LevelXP[101]= LevelXP[100]*3
		}
		
		if(diablo_typ==2 && player_lvl[id] >= 101) return PLUGIN_CONTINUE 
		
		roundXP[id] += amount
		
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
				
				new a=(player_lvl[id] - 2) *3 
				a -= player_ostrze[id] +player_bron_lekka[id]+player_bron_ciezka[id]+player_ciezki_pancerz[id]+player_platnerstwo[id]+player_blok[id]
				a -= player_skradanie[id]  + player_atletyka[id]+player_akrobatyka[id] +player_lekki_pancerz[id]+player_celnosc[id]+player_handel[id]
				a -=player_przywrocenie[id]+player_iluzja[id]+player_przywolanie[id]+player_mistycyzm[id]+player_przemiana[id]+player_zniszczenie[id]
				
		
				if(a>=0) player_point_u[id]+=3
				
				
				
				player_point_a[id]+=1
				set_hudmessage(60, 200, 25, -1.0, 0.25, 0, 1.0, 2.0, 0.1, 0.2, 2)
				show_hudmessage(id, "Awansowales do poziomu %i", player_lvl[id]) 
				savexpcom(id)
				player_class_lvl[id][player_class[id]]=player_lvl[id]
				efekt_level(id)
			}
			
			if (player_xp[id] < LevelXP[player_lvl[id]-1])
			{
				if(diablo_typ==3){
				player_lvl[id]-=9
				}
				player_lvl[id]-=1
				set_hudmessage(60, 200, 25, -1.0, 0.25, 0, 1.0, 2.0, 0.1, 0.2, 2)
				set_hudmessage(60, 200, 25, -1.0, 0.25, 0, 1.0, 2.0, 0.1, 0.2, 2)
				set_hudmessage(60, 200, 25, -1.0, 0.25, 0, 1.0, 2.0, 0.1, 0.2, 2)
				show_hudmessage(id, "Spadles do poziomu %i", player_lvl[id]) 
				savexpcom(id)
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

	asked_sql[id]=0
	flashbattery[id] = MAX_FLASH
	player_xp[id] = 0		
	player_lvl[id] = 1		
	player_point_u[id] = 0	

	player_b_oldsen[id] = 0.0
	player_class[id] = 0
	player_damreduction[id] = 0.0
	last_update_xp[id] = -1

	DemageTake[id]=0
	player_b_gamble[id]=0
	player_tarczam[id] = 0
	player_b_blind[id]=0

	reset_blog_skills(id) // Juz zaladowalo xp wiec juz nic nie zepsuje <lol2>
	reset_player(id)
	set_task(10.0, "Greet_Player", id+TASK_GREET, "", 0, "a", 1)
	
	u_sid[id] = 0
	new sid[64]
	get_user_authid(id, sid ,63)
	if (valid_steam(sid)) u_sid[id] = 1
}


public client_putinserver(id)
{
	loaded_xp[id]=0
	highlvl[id]=0  
	player_class_lvl_save[id]=0
	vip_spr[id] = 0
	player_lvl[id]=0
	last_update_xp[id]=0
	player_xp[id]=0
	player_class_lvl_save[id]=0
	loaded_xp[id]=0
	count_jumps(id)
	player_autob[id]=0
	no_cash[id]=0
	JumpsLeft[id]=JumpsMax[id]
	player_max_mp[id] = 0
	player_mp[id] = 0	
	player_max_hp[id] = 100
	player_max_sp[id] =0
	player_sp[id] = 0
	player_zloto[id] = 0
	player_znak[id] = 0
	player_a_ostrze[id] = 0
	player_a_bron_lekka[id] = 0
	player_a_bron_ciezka[id] = 0
	player_a_ciezki_pancerz[id] = 0
	player_a_platnerstwo[id] = 0
	player_a_blok[id] = 0
	player_a_skradanie[id] = 0
	player_a_atletyka[id] = 0
	player_a_akrobatyka[id] = 0
	player_a_lekki_pancerz[id] = 0
	player_a_celnosc[id] = 0
	player_a_handel[id] = 0
	player_a_przywrocenie[id] = 0
	player_a_iluzja[id] = 0
	player_a_przywolanie[id] = 0
	player_a_mistycyzm[id] = 0
	player_a_przemiana[id] = 0
	player_a_zniszczenie[id] = 0
	wamps[id] = 0
	player_a_szczescie[id] = 0
	player_a_wytrzymalosc[id] = 0
	player_a_szybkosc[id] = 0
	player_a_zwinnosc[id] = 0
	player_a_inteligencja[id] = 0
	player_a_sila_woli[id] = 0
	player_a_sila[id] = 0
	player_niesie[id] = 0
	player_niesie2[id] = 0
		
	player_week_truc[id] = 0
	player_week_ogien[id] = 0
	player_week_mroz[id] = 0
	player_week_shock[id] = 0
	
	player_absorb_mana[id] = 0
	player_odbij_mana[id] = 0
	player_odbij_zwykle[id] = 0
	mikstura[id] = 0
	//-------------------------------------
	player_zaklecie[id] = 0
	player_przegladana_magia_szkola[id] = 0
	player_przegladana_magia_nr[id] = 0
	player_staty[id]=0
	czas_msg_id[id]=0
	czas_check_id[id]=0
	czas_regeneracji[id] = 0
	czas_sprawdzania[id] = 0.0
	knifedelay[id] = 0
	player_specjal_used[id] = 0
	player_b_inv_ilu[id] = 0
	player_b_inv_ilu2[id] = 0
	player_fast[id] = 0
	player_bound[id] = 0
	player_detect[id] = 0
	silence[id] = 0
	paraliz[id] = 0
	g_FOV[id]=0;
	obciaz[id]=0
	spowolnij[id] = 0
	smal_rozb[id] = 0
	rozb[id] = 0
	player_obc_poc[id] = 0
	player_stop_poc[id]=0
	pomoc_off[id]=0	
	player_sid_pass[id] = ""
	player_pass_pass[id] = ""
}
public client_putin(id)
{

	count_jumps(id)
	JumpsLeft[id]=JumpsMax[id]
	player_max_mp[id] = 0
	player_mp[id] = 0	
	player_max_hp[id] = 100
	player_max_sp[id] =0
	player_sp[id] = 0
	player_zloto[id] = 0
	player_znak[id] = 0
	player_a_ostrze[id] = 0
	player_a_bron_lekka[id] = 0
	player_a_bron_ciezka[id] = 0
	player_a_ciezki_pancerz[id] = 0
	player_a_platnerstwo[id] = 0
	player_a_blok[id] = 0
	player_a_skradanie[id] = 0
	player_a_atletyka[id] = 0
	player_a_akrobatyka[id] = 0
	player_a_lekki_pancerz[id] = 0
	player_a_celnosc[id] = 0
	player_a_handel[id] = 0
	player_a_przywrocenie[id] = 0
	player_a_iluzja[id] = 0
	player_a_przywolanie[id] = 0
	player_a_mistycyzm[id] = 0
	player_a_przemiana[id] = 0
	player_a_zniszczenie[id] = 0
			
	player_a_szczescie[id] = 0
	player_a_wytrzymalosc[id] = 0
	player_a_szybkosc[id] = 0
	player_a_zwinnosc[id] = 0
	player_a_inteligencja[id] = 0
	player_a_sila_woli[id] = 0
	player_a_sila[id] = 0
	player_niesie[id] = 0
	player_niesie2[id] = 0
		
	player_week_truc[id] = 0
	player_week_ogien[id] = 0
	player_week_mroz[id] = 0
	player_week_shock[id] = 0
	
	player_absorb_mana[id] = 0
	player_odbij_mana[id] = 0
	player_odbij_zwykle[id] = 0
	player_speedbonus[id]=0
	//-------------------------------------
	player_zaklecie[id] = 0
	player_przegladana_magia_szkola[id] = 0
	player_przegladana_magia_nr[id] = 0
	player_staty[id]=0
	czas_msg_id[id]=0
	czas_check_id[id]=0
	czas_regeneracji[id] = 0
	czas_sprawdzania[id] = 0.0
	knifedelay[id] = 0
	player_specjal_used[id] = 0
	player_b_inv_ilu[id] = 0
	player_b_inv_ilu2[id] = 0
	player_fast[id] = 0
	player_bound[id] = 0
	player_detect[id] = 0
	silence[id] = 0
	paraliz[id] = 0
	g_FOV[id]=0;
	obciaz[id]=0
	spowolnij[id] = 0
	smal_rozb[id] = 0
	rozb[id] = 0
	player_obc_poc[id] = 0
	player_stop_poc[id]=0
	pomoc_off[id]=0	
	rozb_time[id] = 0
	obciaz_time[id]=0
	spowolnij_time[id] = 0
	smal_rozb_time[id] = 0
	silence_time[id] = 0
	paraliz_time[id] = 0

}
public client_disconnect(id)
{
	
	new ent
	new playername[40]
	get_user_name(id,playername,39)
	player_dc_name[id] = playername

	if (player_b_oldsen[id] > 0.0) client_cmd(id,"sensitivity %f",player_b_oldsen[id])
	savexpcom(id)
	
	remove_task(TASK_CHARGE+id)     
     
	while((ent = fm_find_ent_by_owner(ent, "fake_corpse", id)) != 0)
		fm_remove_entity(ent)
	
	player_class_lvl_save[id]=0
	loaded_xp[id]=0
	player_lvl[id]=0
	last_update_xp[id]=0
	player_xp[id]=0
	player_class_lvl_save[id]=0
	loaded_xp[id]=0
	player_vip[id]=0
	player_sid_pass[id] = ""
	player_pass_pass[id] = ""
	u_sid[id] = 0
}


public write_hud(id)
{
	if (player_lvl[id] == 0)
		player_lvl[id] = 1
			
	new tpstring[1024] 

	format(tpstring,1023," Zdrowie: %i/%i Mana: %i/%i Kondycja %i/%i ",get_user_health(id),player_max_hp[id],player_mp[id],player_max_mp[id],player_sp[id],player_max_sp[id] )	
	
	message_begin(MSG_ONE,gmsgStatusText,{0,0,0}, id) 
	write_byte(0) 
	write_string(tpstring) 

	message_end() 
}

/* ==================================================================================================== */
public ItemHUD(id)
{    
	
	//If user is not connected, don't do anything
	if (!is_user_connected(id) || !is_user_alive(id)){
		return
	}


	//Show info about the player we're looking at

	if (player_lvl[id] == 0)
		player_lvl[id] = 1
			
	new Float:xp_now
	new Float:xp_need
	new Float:perc
	
	new xp_teraz = player_xp[id] - LevelXP[player_lvl[id]-1]
	new xp_do = LevelXP[player_lvl[id]] - LevelXP[player_lvl[id]-1]
	
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
	if(player_staty[id]==0){
		new Msg[1024]
		set_hudmessage(255, 255, 255, 0.78, 0.65, 0, 6.0, 3.0)
		format(Msg,1024," Klasa: %s ^n Znak: %s ^n Level: %i ^n Doswiadczenie: %i/%i (%0.0f%s) ^n^n Zaklecie: %s ^n^n ", Race[player_class[id]], Znak[player_znak[id]], player_lvl[id],xp_teraz,xp_do,perc,"%%",Zaklecia[player_zaklecie[id]])		
		show_hudmessage(id, Msg)		
	} 
	if(player_staty[id]==1){
		new Msg[2024]
		set_hudmessage(255, 255, 255, 0.78, 0.1, 0, 6.0, 3.0)
		format(Msg,2023,"Atrybuty^nSila:%i^nInteligencja:%i^nSila woli:%i^nZwinnosc:%i^nSzybkosc:%i^nWytrzymalosc:%i^nSzczescie:%i^n^nUmiejetnosci bitewne^nOstrze:%i^nBron Lekka:%i^nBron Ciezka:%i^nCiezki pancerz:%i^nPlatnerstwo:%i^nBlok:%i^n^nUmiejetnosci zlodziejskie^nHandel:%i^nSkradanie sie:%i^nAkrobatyka:%i^nLekki pancerz:%i^nCelnosc:%i^nAtletyka:%i^n^nUmiejetnosci magiczne^nPrzywrocenie:%i^nIluzja:%i^nPrzywolanie:%i^nMistycyzm:%i^nPrzemiana:%i^nZniszczenie:%i^n",
		player_a_sila[id],player_a_inteligencja[id], player_a_sila_woli[id], player_a_zwinnosc[id],player_a_szybkosc[id],player_a_wytrzymalosc[id],player_a_szczescie[id],
		player_a_ostrze[id],player_a_bron_lekka[id],player_a_bron_ciezka[id],player_a_ciezki_pancerz[id],player_a_platnerstwo[id],player_a_blok[id],
		player_a_handel[id],player_a_skradanie[id],player_a_akrobatyka[id],player_a_lekki_pancerz[id],player_a_celnosc[id],player_a_atletyka[id],
		player_a_przywrocenie[id],player_a_iluzja[id],player_a_przywolanie[id],player_a_mistycyzm[id],player_a_przemiana[id],player_a_zniszczenie[id]
		)		
		show_hudmessage(id, Msg)	
	}
	if(player_staty[id]==2){
		new Msg[1024]
		set_hudmessage(255, 255, 255, 0.78, 0.65, 0, 6.0, 3.0)
		format(Msg,1024," Widzialnosc: %i/255 ^n Double Jumps: %i/%i ^n Long Jumps: %i/%i ^n Zloto: %i ^n Zaklecie: %s ^n Blogoslawienstwo: %s ^n Mikstura: %s^n^n ", player_b_inv[id],player_b_jumpx[id] - jumps[id], player_b_jumpx[id],JumpsLeft[id],JumpsMax[id],player_zloto[id],Zaklecia[player_zaklecie[id]],Blogoslawienstwa[player_blogoslawienstwo[id]], Mikstura_n[mikstura[id]])		
		show_hudmessage(id, Msg)		
	} 
	
}

public UpdateHUD()
{    
	//Update HUD for each player
	for (new id=0; id < 32; id++)
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
				
				new Msg[2024]
				set_hudmessage(100, 155, 100, 0.78, 0.65, 0, 6.0, 3.0,10.0)
				if(player_staty[id]!=1){
					format(Msg,511,"Nick: %s ^n Poziom: %i ^n Klasa: %s ^n Znak: %s ^n Zaklecie: %s ^n Zloto: %i ^n ",pname,player_lvl[index],Race[player_class[index]], Znak[player_znak[index]],Zaklecia[player_zaklecie[index]], player_zloto[index])
				} else{
					set_hudmessage(100, 155, 100, 0.78, 0.1, 0, 6.0, 3.0,10.0)
					format(Msg,2023,"Nick: %s ^nAtrybuty^nSila:%i^nInteligencja:%i^nSila woli:%i^nZwinnosc:%i^nSzybkosc:%i^nWytrzymalosc:%i^nSzczescie:%i^n^nUmiejetnosci bitewne^nOstrze:%i^nBron Lekka:%i^nBron Ciezka:%i^nCiezki pancerz:%i^nPlatnerstwo:%i^nBlok:%i^n^nUmiejetnosci zlodziejskie^nHandel:%i^nSkradanie sie:%i^nAkrobatyka:%i^nLekki pancerz:%i^nCelnosc:%i^nAtletyka:%i^n^nUmiejetnosci magiczne^nPrzywrocenie:%i^nIluzja:%i^nPrzywolanie:%i^nMistycyzm:%i^nPrzemiana:%i^nZniszczenie:%i^n",
					pname, player_a_sila[index],player_a_inteligencja[index], player_a_sila_woli[index], player_a_zwinnosc[index],player_a_szybkosc[index],player_a_wytrzymalosc[index],player_a_szczescie[index],
					player_a_ostrze[index],player_a_bron_lekka[index],player_a_bron_ciezka[index],player_a_ciezki_pancerz[index],player_a_platnerstwo[index],player_a_blok[index],
					player_a_handel[index],player_a_skradanie[index],player_a_akrobatyka[index],player_a_lekki_pancerz[index],player_a_celnosc[index],player_a_atletyka[index],
					player_a_przywrocenie[index],player_a_iluzja[index],player_a_przywolanie[index],player_a_mistycyzm[index],player_a_przemiana[index],player_a_zniszczenie[index]
					)
				}
				
				show_hudmessage(id, Msg)
				
			}
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
			new dam = damage
			if (dam < 0) Effect_Bleed(a,248)
			else {
				Effect_Bleed(a,248)
				change_health(a,-dam,id,"grenade")
			}		
		}
		
	}
}


public Timed_Healing()
{
	new Players[32], playerCount, a
	get_players(Players, playerCount, "ah") 
	
	for (new i=0; i<playerCount; i++) 
	{
		a = Players[i] 
		set_speedchange(a)
		
		if (player_b_heal[a] <= 0)
			continue
		
		change_health(a,player_b_heal[a],0,"")
	}
}



public Timed_Ghost_Check(id)
{
	if (ghost_check[id] == true)
	{	
		new Globaltime = floatround(halflife_time())
	

		new a = id
			
		if (ghoststate[a] == 2 && Globaltime - player_b_ghost[a] > ghosttime[a])
		{
			ghoststate[a] = 3
			ghosttime[a] = 0
			set_user_noclip(a,0)
			ghost_check[id] = false
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

		
	}
}

public reset_blog_skills(id){
	player_skin[id]= 0
	item_boosted[id] = 0
	item_durability[id] = 0
	jumps[id] = 0
	player_b_respawn[id] = 0
	mocrtime[id] = 0		// timer mocy postaci
	gravitytimer[id] = 0		// tmier archow
	player_b_explode[id] = 0 
	player_b_blind[id]=0
	player_b_theif[id] = 0		//Amount of money to steal
	player_b_respawn[id] = 0	//Chance to respawn upon death
	player_b_heal[id] = 0		//Ammount of hp to heal each 5 second
	player_b_ghost[id] = 0		//Ability to walk through walls
	if(player_lvl[id]<10){
		player_b_respawn[id] = 2;
		player_b_heal[id] = 5;
	} 
	if(player_lvl[id]<15){
		player_b_respawn[id] = 3;
		player_b_heal[id] = 3;
		
	} 
	if(player_lvl[id]<20){
		player_b_respawn[id] = 5;
		player_b_heal[id] = 1;
	}
}

public changeskin_id_1(id)
{
	changeskin(id,1)
}

public auto_help(id)
{
	new rnd = random_num(1,4+player_lvl[id])
	if (rnd <= 5)
		set_hudmessage(0, 180, 0, -1.0, 0.70, 0, 10.0, 5.0, 0.1, 0.5, 11) 	
	if (rnd == 1)
		show_hudmessage(id, "Mozesz kupic czar za zloto by go uzywac, potrzebujesz do tego tez many oraz poziomu umiejetnosci")
	if (rnd == 2)
		show_hudmessage(id, "Aby dowiedziec sie jak grac, kupic czary, sprawdzic swoja postac itd wpisz /menu")
	if (rnd == 3)
		show_hudmessage(id, "Mozesz dostac wiecej pomocy jak napiszesz /pomoc lub zobaczyc wszystkie komendy jak napiszesz /komendy")
	if (rnd == 4)
		show_hudmessage(id, "Zeby bylo prosciej grac mozesz zbindowac Skyrim menu (bind klawisz say /menu")

}


public komendy(id)
{
showitem(id,"Komendy","Common","None","<br>/klasa - zmiana klasy postaci<br>/klasyinfo - opis postaci<br>/czary - sklep z czarami<br>/menu - wyswietla menu Skyrim mod<br>/staty - stan statystyk oraz postaci<br>/reset -resetuje twoje staty<br>/savexp - zapisuje lvl,exp,staty<br>/gracze - wyswietla liste graczy<br><br>")
}

/* ==================================================================================================== */

public showitem(id,itemname[],itemvalue[],itemeffect[],Durability[])
{
	new diabloDir[64]	
	new g_ItemFile[64]
	new amxbasedir[64]
	get_basedir(amxbasedir,63)
	
	format(diabloDir,63,"%s/diablo",amxbasedir)
	
	if (!dir_exists(diabloDir))
	{
		new errormsg[512]
		format(errormsg,511,"Blad: Folder %s/diablo nie mogl byc znaleziony. Prosze skopiowac ten folder z archiwum do folderu amxmodx",amxbasedir)
		show_motd(id, errormsg, "An error has occured")	
		return PLUGIN_HANDLED
	}
	
	
	format(g_ItemFile,63,"%s/diablo/item.txt",amxbasedir)
	if(file_exists(g_ItemFile))
		delete_file(g_ItemFile)
	
	new Data[768]
	
	//Header
	format(Data,767,"<html><head><title>Informacje</title></head>")
	write_file(g_ItemFile,Data,-1)
	
	//Background
	format(Data,767,"<body text=^"#FFFF00^" bgcolor=^"#000000^" background=^"%sdrkmotr.jpg^">",Basepath)
	write_file(g_ItemFile,Data,-1)
	
	//Table stuff
	format(Data,767,"<table border=^"0^" cellpadding=^"0^" cellspacing=^"0^" style=^"border-collapse: collapse^" width=^"100%s^"><tr><td width=^"0^">","^%")
	write_file(g_ItemFile,Data,-1)
	
	//ss.gif image
	format(Data,767,"<p align=^"center^"></td>",Basepath)
	write_file(g_ItemFile,Data,-1)
	

	//item name
	format(Data,767,"<td width=^"0^"><p align=^"center^"><font face=^"Arial^"><font color=^"#FFCC00^">%s</font><br>",itemname)
	write_file(g_ItemFile,Data,-1)
	
	//item value
	format(Data,767,"<font color=^"#FFCC00^"> %s</font><br>",itemvalue)
	write_file(g_ItemFile,Data,-1)
	
	//Durability
	format(Data,767,"<font color=^"#FFCC00^">%s</font><br><br>",Durability)
	write_file(g_ItemFile,Data,-1)
	
	//Effects
	format(Data,767,"<font color=^"#FFCC00^"> %s</font></font></td>",itemeffect)
	write_file(g_ItemFile,Data,-1)
	
	//image ss
	format(Data,767,"<td width=^"0^"></td>", Basepath)
	write_file(g_ItemFile,Data,-1)
	
	//end
	format(Data,767,"</tr></table></body></html>")
	write_file(g_ItemFile,Data,-1)
	
	//show window with message
	show_motd(id, g_ItemFile, "Informacje")
	
	return PLUGIN_HANDLED
	
}



/* ==================================================================================================== */
public award_item_adm(id){
	if(get_user_flags(id) & ADMIN_LEVEL_H){
		
	}

}
public award_item_adm2(id){
	if(get_user_flags(id) & ADMIN_LEVEL_H){
		
	}
}




/* UNIQUE ITEMS ============================================================================================ */
//Names are generated from an array
public k_gracz(id){
		
			new gr = 0;
			new du = 0;
			new pl = 0;
			new name[64]
			for (new id=0; id < 33; id++)
			{		
				get_user_name(id,name,63)
				if(equal(name, "gracz"))  gr =1
				if(equal(name, "player"))  pl = 1
				if(equal(name, "duchowny95")) du =1
				
			}

			if(gr==1) client_cmd(id,"amx_kick gracz ZmienNick")
			if(pl==1) client_cmd(id,"amx_kick player ZmienNick")
			if(du==1) client_cmd(id,"amx_kick duchowny95 ZmienNick")
		

}



/* EFFECTS ================================================================================================= */

public add_damage_bonus(id,damage,attacker_id)
{
	
	//-------------------Bron lekka-------------------------------------------------------------
	new atak = 0
	new wysysanie = 0
	new clip,ammo
	new weapon=get_user_weapon(attacker_id,clip,ammo)
	if(weapon==CSW_TMP || weapon==CSW_MAC10 ||weapon==CSW_UMP45  || weapon==CSW_MP5NAVY || weapon == CSW_P90 ){
		if(player_a_bron_lekka[attacker_id]>0) atak += player_a_bron_lekka[attacker_id]/5
		if(atak > 5) atak = 5
	}
	
	if(weapon==CSW_M3 || weapon==CSW_XM1014 ){
		if(player_a_bron_lekka[attacker_id]>0) atak += player_a_bron_lekka[attacker_id]/5
		if(player_a_bron_lekka[attacker_id]>uczen) atak += player_a_bron_lekka[attacker_id]/5
		if(atak > 15) atak = 15
		if(player_a_bron_lekka[attacker_id]>mistrz) wysysanie=5
	}

	if(weapon==CSW_USP || weapon==CSW_GLOCK18 ||weapon==CSW_P228   || weapon==CSW_FIVESEVEN || weapon == CSW_ELITE || weapon == CSW_DEAGLE){
		if(player_a_bron_lekka[attacker_id]>0) atak += player_a_bron_lekka[attacker_id]/5
		if(player_a_bron_lekka[attacker_id]>ekspert) atak +=  player_a_bron_lekka[attacker_id]/5
		if(atak > 20) atak = 20
		if(player_a_bron_lekka[attacker_id]>mistrz){
			wysysanie=5
			atak += 7
		} 
	}
	
	if(player_sp[attacker_id] >=10) change_health(id,-atak,attacker_id,"")
	change_health(attacker_id,wysysanie,id,"")
	//-------------------Lekki pancerz----------------------------------------------------------
	new dodaj = 0
	if(player_a_lekki_pancerz[attacker_id] >0){
		dodaj += player_a_lekki_pancerz[attacker_id]/6
		change_health(attacker_id,dodaj,id,"")
	} 
	//-------------------ciezki pancerz---------------------------------------------------------
	dodaj = 0
	if(player_a_ciezki_pancerz[attacker_id] >0){
		dodaj += floatround( player_a_ciezki_pancerz[attacker_id]/3.0 )
		change_health(attacker_id,dodaj,id,"")
	} 
	
	//-------------------Bron ciezka------------------------------------------------------------
	atak = 0
	wysysanie = 0
	weapon=get_user_weapon(attacker_id,clip,ammo)
	if(player_a_bron_ciezka[attacker_id]>nowicjusz){
		
		if(weapon==CSW_SCOUT || weapon==CSW_FAMAS ||weapon==CSW_GALIL  || weapon==CSW_AUG || weapon == CSW_SG552 ||
		weapon == CSW_M249 || weapon == CSW_AWP || 
		weapon == CSW_SG550 || weapon == CSW_G3SG1){
			atak += player_a_bron_ciezka[attacker_id]/7
			if(atak>5) atak = 5
		}
	}
	
	if(player_a_bron_ciezka[attacker_id]>czeladnik){
		
		if(weapon==CSW_SCOUT || weapon==CSW_FAMAS ||weapon==CSW_GALIL  || weapon==CSW_AUG || weapon == CSW_SG552){
			atak += player_a_bron_ciezka[attacker_id]/5
			if(atak>15) atak = 15
		}
	}
	
	
	if(player_sp[attacker_id] >=10) change_health(id,-atak,attacker_id,"")
	
}




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
	if (player_b_respawn[id] > 0 || isevent==1)
	{
		new svIndex[32] 
		num_to_str(id,svIndex,32)
		new roll = random_num(1,player_b_respawn[id])
		if (roll == 1 || isevent ==1)
		{
			new maxpl,players[32]
			get_players(players, maxpl) 
			
			if (maxpl > 2 && dragon[id]==0)
			{
				cs_set_user_money(id,cs_get_user_money(id)+4000)
				set_task(0.5,"respawn",0,svIndex,32) 		
				player_mp[id] = player_max_mp[id]
				player_sp[id] = player_max_sp[id]
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
	spawn(vIndex);
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
			
			if(get_distance(origin,origin1) < player_b_explode[id])
			{
				new dam = 75
				if(dam<1) dam=1
				atak_ognia(a,-dam,id)
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
	write_short( sprite_fire3 ) 
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



/* ==================================================================================================== */

public add_bonus_blind(id,attacker_id,weapon,damage)
{
	if (player_b_blind[attacker_id] > 0 && weapon != 4) 
	{	
		if (random_num(1,player_b_blind[attacker_id]) == 1) Display_Fade(id,1<<14,1<<14 ,1<<16,255,255,255,230)			
	}
}




/* ==================================================================================================== */
public item_ghost_off(id)
{
	id = id - TASKID_GHOST
	set_user_noclip(id,0)
	ghoststate[id] = 3
	ghosttime[id] = 0
	ghost_check[id] = false

}
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
		set_task(player_b_ghost[id]+1.0,"item_ghost_off",id + TASKID_GHOST) 
		player_specjal_used[id] = 1
	}
	else
	{
		hudmsg(id,3.0,"Tylko jeden gracz moze uzywac Ducha w tym samym czasie! / Przedmiot zostal uzyty!")
		//show_hudmessage(id, "%i, %i, %i", ghoststate[id], player_b_ghost[id], ghost_check[id])
	}
}

/* ==================================================================================================== */

public add_bonus_darksteel(attacker,id,damage)
{

	if(player_a_ostrze[attacker]> czeladnik &&on_knife[attacker]){
		Effect_waz(id,attacker,1)
		hudmsg(id,3.0,"Jestes zatruty!")
	}
	if(player_a_ostrze[attacker]> ekspert  &&on_knife[attacker]){
		if (UTIL_In_FOV(attacker,id) && !UTIL_In_FOV(id,attacker))
		{
			new dam = 50 + player_a_ostrze[attacker]
			Effect_Bleed(id,248)
			atak_truc(id,-dam,attacker)
			Display_Fade(id,seconds(1),seconds(1),0,255,0,0,150)
		}
	}
	
}




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


public host_killed(id)
{
	if (player_lvl[id] > 1)
	{
		hudmsg(id,2.0,"Straciles doswiadczenie za zabicie zakladnikow")
		Give_Xp(id,-floatround(3*player_lvl[id]/(1.65-player_lvl[id]/501)))
	}
	
}









public showmenu(id)
{
	new text[513] 
	new keys = (1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<4)|(1<<5)|(1<<6)|(1<<7)|(1<<8)|(1<<9)
	format(text, 512, "\yOpcje - ^n\w1. Informacje o klasach, znakach ^n\w2. Informacje o statystykach, atrybutach ^n\w3. Magia ^n\w4. Zmien widok (pokaz statystyki/postac) ^n\w5. Wplac do banku ^n\w6. Twoja postac^n\w7. Serwery^n\w8. Kupno slota expa i konta Vip^n^n\w0. Zamknij") 
	show_menu(id, keys, text) 
	return PLUGIN_HANDLED  
} 


public option_menu(id, key) 
{ 
	switch(key) 
	{ 
		case 0: 
		{	
			client_cmd(id,"/klasyinfo")
		}
		case 1: 
		{	
			client_cmd(id,"/statyinfo")
		}
		case 2: 
		{	
			magia_sklep(id)
		}
		case 3:
		{
			staty(id)
		}
		case 4:
		{
			wplac(id)
		}
		case 5:
		{
			postac(id)
		}
		case 6:
		{
			client_cmd(id," say /server ");
		}
		case 7:
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

public helpme(id)
{	 
	showitem(id,"Helpmenu","Common","None","Dostajesz doswiadczenie za zabijanie innych. Zdobywasz poziomy, dzieki ktorym mozesz ulepszyc swoje atrybuty i umiejetnosci<br><br> Wpisz /menu by kupic czary lub ich uzywac <br><br> Czarow uzywa sie klawiszem e - by go uzyc czar musi byc wybrany za pomoca menu lub binda<br><br>Kupno, uzywanie czarow, reset statystyk, bank zlota, informacje.. to wszystko znajdziesz pod komenda /menu<br><br> ")
}



public magia_sklep(id)
{
	new text[513] 
	new keys = (1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<4)|(1<<5)|(1<<6)|(1<<9)
	format(text, 512, "\y Sklep z magia - ^n\w1.Czary specjalne ^n\w2. Czary przywrocenia ^n\w3. Czary iluzji ^n\w4. Czary przywolania ^n\w5. Czary mistycyzmu ^n\w6. Czary przemiany ^n\w7. Czary zniszczenia ^n^n\w0. Zamknij") 
	show_menu(id, keys, text,-1,"Sklep z magia") 
	client_cmd(id, "mp3 play %s", sounds_hit[book_open] )
	return PLUGIN_HANDLED  
} 

public magia_sklep_tree(id,key)
{
	switch(key) 
	{ 
		case 0: 
		{	
			magia_sklep_specjalne(id)
		}
		case 1: 
		{	
			magia_sklep_przywrocenia(id)
		}
		case 2: 
		{	
			magia_sklep_iluzji(id)
		}
		case 3:
		{
			magia_sklep_przywolania(id)
		}
		case 4:
		{
			magia_sklep_mistycyzmu(id)
		}
		case 5:
		{
			magia_sklep_przemiany(id)
		}
		case 6:
		{
			magia_sklep_zniszczenia(id)
		}

		case 9:
		{
			return PLUGIN_HANDLED
		}
	}
	return PLUGIN_HANDLED
} 

public magia_sklep_specjalne(id){
	new text[513] 
	new keys = (1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<4)|(1<<5)|(1<<9)
	format(text, 512, "\y Magia specjalne - ^n\w1.Przywolanie Luku ^n\w2. Krew Polnocy ^n\w3. Pocalunek ^n\w4. Moc Weza ^n\w5. Ksiezycowy Cien^n\w6. Wieza ^n^n\w0. Zamknij") 
	show_menu(id, keys, text,-1,"Magia specjalne") 
	client_cmd(id, "mp3 play %s", sounds_hit[book_open] )
	return PLUGIN_HANDLED  
}

public magia_sklep_specjalne_tree(id,key){
	if(key==9){
		return PLUGIN_HANDLED
	} 
	
	new szkola = specjalne
	new dzialanie = 1
	
	magia_sklep_funkcja(id,szkola,key,dzialanie)
	return PLUGIN_HANDLED
}

public magia_sklep_przywrocenia(id){
	new text[513] 
	new keys = (1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<4)|(1<<9)
	format(text, 512, "\y Magia przywrocenia - ^n\w1.Uzdrowienie ^n\w2. Slowo mocy ^n\w3. Silne uzdrowienie ^n\w4. Slowo zycia ^n\w5. Potezne uzdrowienie ^n^n\w0. Zamknij") 
	show_menu(id, keys, text,-1,"Magia przywrocenia") 
	client_cmd(id, "mp3 play %s", sounds_hit[book_open] )
	return PLUGIN_HANDLED  
}

public magia_sklep_przywrocenia_tree(id,key){
	if(key==9){
		return PLUGIN_HANDLED
	} 
	
	new szkola = przywrocenia
	new dzialanie = 1
	
	magia_sklep_funkcja(id,szkola,key,dzialanie)
	
	return PLUGIN_HANDLED
}

public magia_sklep_iluzji(id){
	new text[513] 
	new keys = (1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<4)|(1<<9)
	format(text, 512, "\y Magia iluzji - ^n\w1.Pomniejsze ukrycie ^n\w2. Ukrycie ^n\w3. Kameleon ^n\w4. Potezne Ukrycie ^n\w5. Duch ^n^n\w0. Zamknij") 
	show_menu(id, keys, text,-1,"Magia iluzji") 
	client_cmd(id, "mp3 play %s", sounds_hit[book_open] )
	return PLUGIN_HANDLED  
}

public magia_sklep_iluzji_tree(id,key){
	if(key==9){
		return PLUGIN_HANDLED
	} 
	
	new szkola = iluzji
	new dzialanie = 1
	
	magia_sklep_funkcja(id,szkola,key,dzialanie)
	
	return PLUGIN_HANDLED
}

public magia_sklep_przywolania(id){
	new text[513] 
	new keys = (1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<4)|(1<<9)
	format(text, 512, "\y Magia przywolania - ^n\w1.Zestaw zabojcy ^n\w2. Pomniejsze przywolanie ^n\w3. Srednie przywolanie ^n\w4. Potezne przywolanie ^n\w5. Zestaw battle maga ^n^n\w0. Zamknij") 
	show_menu(id, keys, text,-1,"Magia przywolania") 
	client_cmd(id, "mp3 play %s", sounds_hit[book_open] )
	return PLUGIN_HANDLED  
}

public magia_sklep_przywolania_tree(id,key){
	if(key==9){
		return PLUGIN_HANDLED
	} 
	
	new szkola = przywolania
	new dzialanie = 1
	
	magia_sklep_funkcja(id,szkola,key,dzialanie)
	
	return PLUGIN_HANDLED
}

public magia_sklep_mistycyzmu(id){
	new text[513] 
	new keys = (1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<4)|(1<<9)
	format(text, 512, "\y Magia mistycyzmu - ^n\w1.Rozproszenie ^n\w2. Wykrycie zycia ^n\w3. Absorbcja Magii ^n\w4. Odbicie Magii ^n\w5. Potezne odbicie ^n^n\w0. Zamknij") 
	show_menu(id, keys, text,-1,"Magia mistycyzmu") 
	client_cmd(id, "mp3 play %s", sounds_hit[book_open] )
	return PLUGIN_HANDLED  
}

public magia_sklep_mistycyzmu_tree(id,key){
	if(key==9){
		return PLUGIN_HANDLED
	} 
	
	new szkola = mistycyzmu
	new dzialanie = 1
	
	magia_sklep_funkcja(id,szkola,key,dzialanie)
	
	return PLUGIN_HANDLED
}

public magia_sklep_przemiany(id){
	new text[513] 
	new keys = (1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<4)|(1<<5)|(1<<9)
	format(text, 512, "\y Magia przemiany - ^n\w1.Obciazenie ^n\w2. Spowolnienie ^n\w3. Wyciszenie ^n\w4. Pomniejsze rozbrojenie ^n\w5. Rozbrojenie ^n\w6. Paraliz ^n^n\w0. Zamknij") 
	show_menu(id, keys, text,-1,"Magia przemiany") 
	client_cmd(id, "mp3 play %s", sounds_hit[book_open] )
	return PLUGIN_HANDLED  
}

public magia_sklep_przemiany_tree(id,key){
	if(key==9){
		return PLUGIN_HANDLED
	} 
	
	new szkola = przemiany
	new dzialanie = 1
	
	magia_sklep_funkcja(id,szkola,key,dzialanie)
	
	return PLUGIN_HANDLED
}

public magia_sklep_zniszczenia(id){
	new text[513] 
	new keys = (1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<4)|(1<<5)|(1<<9)
	format(text, 512, "\y Magia zniszczenia - ^n\w1.Flara ^n\w2. Dezintegracja pancerza i rozproszenie  ^n\w3. Podatnosc ^n\w4. Sniezna kula ^n\w5. Blyskawica ^n\w6. Wybuch Ognia ^n^n\w0. Zamknij") 
	show_menu(id, keys, text,-1,"Magia zniszczenia") 
	client_cmd(id, "mp3 play %s", sounds_hit[book_open] )
	return PLUGIN_HANDLED  
}

public magia_sklep_zniszczenia_tree(id,key){
	if(key==9){
		return PLUGIN_HANDLED
	} 
	
	new szkola = zniszczenia
	new dzialanie = 1
	
	magia_sklep_funkcja(id,szkola,key,dzialanie)
	
	return PLUGIN_HANDLED
}


public magia_sklep_funkcja(id,szkola,nr,dzialanie){
	player_przegladana_magia_szkola[id] = szkola
	player_przegladana_magia_nr[id] = nr+1
	
	new nr_zaklecia = (player_przegladana_magia_szkola[id]-1)*6 + player_przegladana_magia_nr[id]
	new text[513] 
	new keys = (1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<9)
	
	new umiej = 0
	switch(szkola){
		case 0:{
			return PLUGIN_HANDLED 
		}
		case 1:{
			umiej = 0
		}
		case 2:{
			umiej = player_a_przywrocenie[id]
		}
		case 3:{
			umiej = player_a_iluzja[id]
		}
		case 4:{
			umiej = player_a_przywolanie[id]
		}
		case 5:{
			umiej = player_a_mistycyzm[id]
		}
		case 6:{
			umiej =  player_a_przemiana[id]
		}
		case 7:{
			umiej =  player_a_zniszczenie[id]
		}	
	}
	
	new liczba = 0
	for(new i=przywr1;i<=destr6;i++){
		liczba += Zaklecia_ma[id][i]
	}
	new cena = floatround(Zaklecia_cena[nr_zaklecia] * (1.0+ (liczba)/2.0))
	
	format(text, 512, "\y Czar %s^n Cena: %i/%i zlota ^n Wymagany poziom umiejetnosci: %i/%i  ^n\w1. Opis ^n\w2. Jak zbindowac ^n\w3. Kup ^n\w4. Wybierz do uzycia ^n^n\w0. Zamknij",Zaklecia[nr_zaklecia],player_zloto[id],cena,umiej,Zaklecia_umiej[nr_zaklecia]) 
	
	if(Zaklecia_ma[id][nr_zaklecia]==0 && Zaklecia_umiej[nr_zaklecia]<=umiej && player_zloto[id] >= cena && nr_zaklecia >=przywr1){
		format(text, 512, "\y Czar %s^n Cena: %i/%i zlota ^n Wymagany poziom umiejetnosci: %i/%i ^n\w1. Opis ^n\w2. Jak zbindowac ^n\w3. Kup ^n\d4. Wybierz do uzycia ^n^n\w0. Zamknij",Zaklecia[nr_zaklecia],player_zloto[id],cena,umiej,Zaklecia_umiej[nr_zaklecia]) 
		keys = (1<<0)|(1<<1)|(1<<2)|(1<<9)
	} else{
		if(Zaklecia_ma[id][nr_zaklecia]==1 && (Zaklecia_umiej[nr_zaklecia]<=umiej || !(nr_zaklecia >=przywr1))){
			format(text, 512, "\y Czar %s^n Cena: %i/%i zlota ^n Wymagany poziom umiejetnosci: %i/%i  ^n\w1. Opis ^n\w2. Jak zbindowac ^n\d3. Kup ^n\w4. Wybierz do uzycia ^n^n\w0. Zamknij",Zaklecia[nr_zaklecia],player_zloto[id],cena,umiej,Zaklecia_umiej[nr_zaklecia]) 
			keys = (1<<0)|(1<<1)|(1<<3)|(1<<9)
		} else{
			format(text, 512, "\y Czar %s^n Cena: %i/%i zlota ^n Wymagany poziom umiejetnosci: %i/%i  ^n\w1. Opis ^n\w2. Jak zbindowac ^n\d3. Kup ^n\d4. Wybierz do uzycia ^n^n\w0. Zamknij",Zaklecia[nr_zaklecia],player_zloto[id],cena,umiej,Zaklecia_umiej[nr_zaklecia]) 
			keys = (1<<0)|(1<<1)|(1<<9)
		}
	}
	
	

	
	client_cmd(id, "mp3 play %s", sounds_hit[book_open] )
	show_menu(id, keys, text,-1,"Czar") 
	return PLUGIN_HANDLED 
}

public magia_sklep_funkcja_tree(id,key){
	
	new nr_zaklecia = (player_przegladana_magia_szkola[id]-1)*6 + player_przegladana_magia_nr[id]
	if(key==0){
		opis_zaklecia(id,nr_zaklecia)
	}

	if(key==1){
		bind_zaklecia(id,nr_zaklecia)
	}

	if(key==2){
		kup_zaklecia(id,nr_zaklecia)
	}

	if(key==3){
		player_zaklecie[id] = nr_zaklecia	
	}

	if(key==9){
		player_przegladana_magia_szkola[id] = 0
		player_przegladana_magia_nr[id] = 0
		return PLUGIN_HANDLED 
	}
	return PLUGIN_HANDLED 
}

public opis_zaklecia(id,nr){
	client_cmd(id, "mp3 play %s", sounds_hit[book_open] )
	switch(nr){
		case Luk:{
			showitem(id,Zaklecia[nr],"Pozwala wyjac luk","","")
		}
		case krew:{
			showitem(id,Zaklecia[nr],"Czar znaku Lord","Przywraca punkty zdrowia","Raz na runde - na siebie")
		}
		case pocalunek:{
			showitem(id,Zaklecia[nr],"Czar znaku Kochanek","Paralizuje wroga na 10 sekund kosztem 120 pkt kondycji","Raz na runde na cel")
		}
		case waz:{
			showitem(id,Zaklecia[nr],"Czar znaku Waz","Zatruwa wrogow i leczy gracza, usuwa dzialanie trucizn i magii","Raz na runde - na siebie i obszar")
		}
		case cien:{
			showitem(id,Zaklecia[nr],"Czar znaku Ksiezycowy Cien","Pozwala na 10 sekund stac sie niewidzialnym","Raz na runde - na siebie")
		}
		case wieza:{
			showitem(id,Zaklecia[nr],"Czar znaku Wieza","Pozwala przenikac przez sciany przez 5 sekund","Raz na runde - na siebie")
		}
		
		
		case przywr1:{
			showitem(id,Zaklecia[nr],"Odnowienie 25 hp ",""," na siebie")
		}
		case przywr2:{
			showitem(id,Zaklecia[nr],"Zwiekszenie maksymalnej many o 50 ",""," na siebie")
		}
		case przywr3:{
			showitem(id,Zaklecia[nr],"Odnowienie 75 hp ",""," na siebie")
		}
		case przywr4:{
			showitem(id,Zaklecia[nr],"Zwiekszenie maksymalnego hp o 100",""," na siebie")
		}
		case przywr5:{
			showitem(id,Zaklecia[nr],"Odnowienie 200 hp",""," na siebie")
		}
		case przywr6:{
			showitem(id,Zaklecia[nr],"",""," na siebie")
		}
		
		
		case iluzja1:{
			showitem(id,Zaklecia[nr],"Widzialnosc zredukowana do 150 na 60 sekund",""," na siebie")
		}
		case iluzja2:{
			showitem(id,Zaklecia[nr],"Widzialnosc zredukowana do 70 na 60 sekund",""," na siebie")
		}
		case iluzja3:{
			showitem(id,Zaklecia[nr],"Kameleon na 60 sekund",""," na siebie")
		}
		case iluzja4:{
			showitem(id,Zaklecia[nr],"Widocznosc zredukowana do 5 na 60 sekund, jeœli strzelisz/walniesz z lewego nozem stajesz sie od razu widoczny",""," na siebie")
		}
		case iluzja5:{
			showitem(id,Zaklecia[nr],"Widocznosc zredukowana do 5 na 60 sekund, kazdy strzal w Ciebie jest smiertelny",""," na siebie")
		}
		case iluzja6:{
			showitem(id,Zaklecia[nr],"//todo.","","")
		}
		
		
		case przyw1:{
			showitem(id,Zaklecia[nr],"Przywolanie duali i m3 na 60 sek ","","na siebie")
		}
		case przyw2:{
			showitem(id,Zaklecia[nr],"Przywolanie mp5 na 60 sek","","na siebie")
		}
		case przyw3:{
			showitem(id,Zaklecia[nr],"Przywolanie p90 na 60 sek","","na siebie")
		}
		case przyw4:{
			showitem(id,Zaklecia[nr],"Przywolanie m4a1 na 60 sek","","na siebie")
		}
		case przyw5:{
			showitem(id,Zaklecia[nr],"Przywolanie awp i ak47 na 60 sekund","","na siebie")
		}
		case przyw6:{
			showitem(id,Zaklecia[nr],"//todo.","","")
		}
		
		
		case mis1:{
			showitem(id,Zaklecia[nr],"Niweluje dzialanie wszystkich zaklec","","na siebie")
		}
		case mis2:{
			showitem(id,Zaklecia[nr],"Mozesz postawic totem o duzym zasiegu naswietlajacy niewidzialnych graczy na jakis czas","","na obszar")
		}
		case mis3:{
			showitem(id,Zaklecia[nr],"Przez 60 sekund kazde rzucone na gracza zaklêciê bêdzie dzialac o polowê slabiej i da graczowi tyle many ile kosztowalo rzucenie go","","na siebie")
		}
		case mis4:{
			showitem(id,Zaklecia[nr],"Przez 60 sekund kazde rzucone na gracza zaklêciê bêdzie dzialac o polowê slabiej i zostanie rzucone na gracza atakujacego tez o polowê slabsze","","na siebie")
		}
		case mis5:{
			showitem(id,Zaklecia[nr],"Przez 30 sekund kazdy atak z broni zwyklej bêdzie zadawal atakujacemu obrazenia","","na siebie")
		}
		case mis6:{
			showitem(id,Zaklecia[nr],"//todo.","","")
		}
		
		
		case przem1:{
			showitem(id,Zaklecia[nr],"Zatrzymanie gracza na 10 sekund ","","na strzal")
		}
		case przem2:{
			showitem(id,Zaklecia[nr],"Spowolnienie gracza na 10 sekund","","na cel - mroz")
		}
		case przem3:{
			showitem(id,Zaklecia[nr],"Gracz nie moze wypowiedziec zaklecia przez 10 sekund","","na cel")
		}
		case przem4:{
			showitem(id,Zaklecia[nr],"Gracz zmienia bron na noz na 10 sekund","","na cel")
		}
		case przem5:{
			showitem(id,Zaklecia[nr],"Gracz wyrzuca bron ","","na strzal")
		}
		case przem6:{
			showitem(id,Zaklecia[nr],"Gracz zmienia bron na noz, nie moze sie ruszyc i jest Wyciszony na 5 sekund","","na obszar")
		}
		
		
		case destr1:{
			showitem(id,Zaklecia[nr],"Wysyla lecaca kulê zadajaca 25 + (zniszczenie-25) obrazen","","kula - ogien")
		}
		case destr2:{
			showitem(id,Zaklecia[nr],"Calkiem niszczy kamizelkê przeciwnika i rozprasza jego czary","","na cel")
		}
		case destr3:{
			showitem(id,Zaklecia[nr],"Zwiêksza podatnoœc obiektu na magiê o 25 + zniszczenie /4, zmniejsza o tyle samo odpornosc obiektu","","na cel")
		}
		case destr4:{
			showitem(id,Zaklecia[nr],"Wysyla lecaca mrozna kulê... kula wybucha mrozem i zadaje 50 obrazen","","kula - mroz")
		}
		case destr5:{
			showitem(id,Zaklecia[nr],"Zadaje obrazenia 75 + zniszczenie","","cel - shock")
		}
		case destr6:{
			showitem(id,Zaklecia[nr],"Mozesz postawic totem ognia, kazdy kto znajdzie sie w obszarze wybuchu zostanie podpalony i otrzyma obrazenia 50","","obszar")
		}
	}
}

public bind_zaklecia(id,nr){
	switch(nr){
		case Luk:{
			showitem(id,Zaklecia[nr],"Mozesz zbinowac zaklecie by szybko je wybierac, po uzyciu bindu zaklecie zostanie wybrane, a nastepnie uzyc go mozesz klawiszem e.","bind do zaklecia to: /spec1","Aby zbindowac to zaklecie otworz konsole (klawisz ~) i wpisz:<br> bind tu_jakis_klawisz /spec1<br> Np: bind F5 /spec1<br>")
		}
		case krew:{
			showitem(id,Zaklecia[nr],"Mozesz zbinowac zaklecie by szybko je wybierac, po uzyciu bindu zaklecie zostanie wybrane, a nastepnie uzyc go mozesz klawiszem e.","bind do zaklecia to: /spec2","Aby zbindowac to zaklecie otworz konsole (klawisz ~) i wpisz:<br> bind tu_jakis_klawisz /spec2<br> Np: bind F5 /spec2<br>")
		}
		case pocalunek:{
			showitem(id,Zaklecia[nr],"Mozesz zbinowac zaklecie by szybko je wybierac, po uzyciu bindu zaklecie zostanie wybrane, a nastepnie uzyc go mozesz klawiszem e.","bind do zaklecia to: /spec3","Aby zbindowac to zaklecie otworz konsole (klawisz ~) i wpisz:<br> bind tu_jakis_klawisz /spec3<br> Np: bind F5 /spec3<br>")
		}
		case waz:{
			showitem(id,Zaklecia[nr],"Mozesz zbinowac zaklecie by szybko je wybierac, po uzyciu bindu zaklecie zostanie wybrane, a nastepnie uzyc go mozesz klawiszem e.","bind do zaklecia to: /spec4","Aby zbindowac to zaklecie otworz konsole (klawisz ~) i wpisz:<br> bind tu_jakis_klawisz /spec4<br> Np: bind F5 /spec4<br>")
		}
		case cien:{
			showitem(id,Zaklecia[nr],"Mozesz zbinowac zaklecie by szybko je wybierac, po uzyciu bindu zaklecie zostanie wybrane, a nastepnie uzyc go mozesz klawiszem e.","bind do zaklecia to: /spec5","Aby zbindowac to zaklecie otworz konsole (klawisz ~) i wpisz:<br> bind tu_jakis_klawisz /spec5<br> Np: bind F5 /spec5<br>")
		}
		case wieza:{
			showitem(id,Zaklecia[nr],"Mozesz zbinowac zaklecie by szybko je wybierac, po uzyciu bindu zaklecie zostanie wybrane, a nastepnie uzyc go mozesz klawiszem e.","bind do zaklecia to: /spec6","Aby zbindowac to zaklecie otworz konsole (klawisz ~) i wpisz:<br> bind tu_jakis_klawisz /spec6<br> Np: bind F5 /spec6<br>")
		}
		
		
		case przywr1:{
			showitem(id,Zaklecia[nr],"Mozesz zbinowac zaklecie by szybko je wybierac, po uzyciu bindu zaklecie zostanie wybrane, a nastepnie uzyc go mozesz klawiszem e.","bind do zaklecia to: /przywr1","Aby zbindowac to zaklecie otworz konsole (klawisz ~) i wpisz:<br> bind tu_jakis_klawisz /przywr1<br> Np: bind F5 /przywr1<br>")
		}
		case przywr2:{
			showitem(id,Zaklecia[nr],"Mozesz zbinowac zaklecie by szybko je wybierac, po uzyciu bindu zaklecie zostanie wybrane, a nastepnie uzyc go mozesz klawiszem e.","bind do zaklecia to: /przywr2","Aby zbindowac to zaklecie otworz konsole (klawisz ~) i wpisz:<br> bind tu_jakis_klawisz /przywr2<br> Np: bind F5 /przywr2<br>")
		}
		case przywr3:{
			showitem(id,Zaklecia[nr],"Mozesz zbinowac zaklecie by szybko je wybierac, po uzyciu bindu zaklecie zostanie wybrane, a nastepnie uzyc go mozesz klawiszem e.","bind do zaklecia to: /przywr3","Aby zbindowac to zaklecie otworz konsole (klawisz ~) i wpisz:<br> bind tu_jakis_klawisz /przywr3<br> Np: bind F5 /przywr3<br>")
		}
		case przywr4:{
			showitem(id,Zaklecia[nr],"Mozesz zbinowac zaklecie by szybko je wybierac, po uzyciu bindu zaklecie zostanie wybrane, a nastepnie uzyc go mozesz klawiszem e.","bind do zaklecia to: /przywr4","Aby zbindowac to zaklecie otworz konsole (klawisz ~) i wpisz:<br> bind tu_jakis_klawisz /przywr4<br> Np: bind F5 /przywr4<br>")
		}
		case przywr5:{
			showitem(id,Zaklecia[nr],"Mozesz zbinowac zaklecie by szybko je wybierac, po uzyciu bindu zaklecie zostanie wybrane, a nastepnie uzyc go mozesz klawiszem e.","bind do zaklecia to: /przywr5","Aby zbindowac to zaklecie otworz konsole (klawisz ~) i wpisz:<br> bind tu_jakis_klawisz /przywr5<br> Np: bind F5 /przywr5<br>")
		}
		case przywr6:{
			showitem(id,Zaklecia[nr],"Mozesz zbinowac zaklecie by szybko je wybierac, po uzyciu bindu zaklecie zostanie wybrane, a nastepnie uzyc go mozesz klawiszem e.","bind do zaklecia to: /przywr6","Aby zbindowac to zaklecie otworz konsole (klawisz ~) i wpisz:<br> bind tu_jakis_klawisz /przywr6<br> Np: bind F5 /przywr6<br>")
		}
		
		
		case iluzja1:{
			showitem(id,Zaklecia[nr],"Mozesz zbinowac zaklecie by szybko je wybierac, po uzyciu bindu zaklecie zostanie wybrane, a nastepnie uzyc go mozesz klawiszem e.","bind do zaklecia to: /iluzja1","Aby zbindowac to zaklecie otworz konsole (klawisz ~) i wpisz:<br> bind tu_jakis_klawisz /iluzja1<br> Np: bind F5 /iluzja1<br>")
		}
		case iluzja2:{
			showitem(id,Zaklecia[nr],"Mozesz zbinowac zaklecie by szybko je wybierac, po uzyciu bindu zaklecie zostanie wybrane, a nastepnie uzyc go mozesz klawiszem e.","bind do zaklecia to: /iluzja2","Aby zbindowac to zaklecie otworz konsole (klawisz ~) i wpisz:<br> bind tu_jakis_klawisz /iluzja2<br> Np: bind F5 /iluzja2<br>")
		}
		case iluzja3:{
			showitem(id,Zaklecia[nr],"Mozesz zbinowac zaklecie by szybko je wybierac, po uzyciu bindu zaklecie zostanie wybrane, a nastepnie uzyc go mozesz klawiszem e.","bind do zaklecia to: /iluzja3","Aby zbindowac to zaklecie otworz konsole (klawisz ~) i wpisz:<br> bind tu_jakis_klawisz /iluzja3<br> Np: bind F5 /iluzja3<br>")
		}
		case iluzja4:{
			showitem(id,Zaklecia[nr],"Mozesz zbinowac zaklecie by szybko je wybierac, po uzyciu bindu zaklecie zostanie wybrane, a nastepnie uzyc go mozesz klawiszem e.","bind do zaklecia to: /iluzja4","Aby zbindowac to zaklecie otworz konsole (klawisz ~) i wpisz:<br> bind tu_jakis_klawisz /iluzja4<br> Np: bind F5 /iluzja4<br>")
		}
		case iluzja5:{
			showitem(id,Zaklecia[nr],"Mozesz zbinowac zaklecie by szybko je wybierac, po uzyciu bindu zaklecie zostanie wybrane, a nastepnie uzyc go mozesz klawiszem e.","bind do zaklecia to: /iluzja5","Aby zbindowac to zaklecie otworz konsole (klawisz ~) i wpisz:<br> bind tu_jakis_klawisz /iluzja5<br> Np: bind F5 /iluzja5<br>")
		}
		case iluzja6:{
			showitem(id,Zaklecia[nr],"Mozesz zbinowac zaklecie by szybko je wybierac, po uzyciu bindu zaklecie zostanie wybrane, a nastepnie uzyc go mozesz klawiszem e.","bind do zaklecia to: /iluzja6","Aby zbindowac to zaklecie otworz konsole (klawisz ~) i wpisz:<br> bind tu_jakis_klawisz /iluzja6<br> Np: bind F5 /iluzja6<br>")
		}
		
		
		case przyw1:{
			showitem(id,Zaklecia[nr],"Mozesz zbinowac zaklecie by szybko je wybierac, po uzyciu bindu zaklecie zostanie wybrane, a nastepnie uzyc go mozesz klawiszem e.","bind do zaklecia to: /przywo1","Aby zbindowac to zaklecie otworz konsole (klawisz ~) i wpisz:<br> bind tu_jakis_klawisz /przywo1<br> Np: bind F5 /przywo1<br>")
		}
		case przyw2:{
			showitem(id,Zaklecia[nr],"Mozesz zbinowac zaklecie by szybko je wybierac, po uzyciu bindu zaklecie zostanie wybrane, a nastepnie uzyc go mozesz klawiszem e.","bind do zaklecia to: /przywo2","Aby zbindowac to zaklecie otworz konsole (klawisz ~) i wpisz:<br> bind tu_jakis_klawisz /przywo2<br> Np: bind F5 /przywo2<br>")
		}
		case przyw3:{
			showitem(id,Zaklecia[nr],"Mozesz zbinowac zaklecie by szybko je wybierac, po uzyciu bindu zaklecie zostanie wybrane, a nastepnie uzyc go mozesz klawiszem e.","bind do zaklecia to: /przywo3","Aby zbindowac to zaklecie otworz konsole (klawisz ~) i wpisz:<br> bind tu_jakis_klawisz /przywo3<br> Np: bind F5 /przywo3<br>")
		}
		case przyw4:{
			showitem(id,Zaklecia[nr],"Mozesz zbinowac zaklecie by szybko je wybierac, po uzyciu bindu zaklecie zostanie wybrane, a nastepnie uzyc go mozesz klawiszem e.","bind do zaklecia to: /przywo4","Aby zbindowac to zaklecie otworz konsole (klawisz ~) i wpisz:<br> bind tu_jakis_klawisz /przywo4<br> Np: bind F5 /przywo4<br>")
		}
		case przyw5:{
			showitem(id,Zaklecia[nr],"Mozesz zbinowac zaklecie by szybko je wybierac, po uzyciu bindu zaklecie zostanie wybrane, a nastepnie uzyc go mozesz klawiszem e.","bind do zaklecia to: /przywo5","Aby zbindowac to zaklecie otworz konsole (klawisz ~) i wpisz:<br> bind tu_jakis_klawisz /przywo5<br> Np: bind F5 /przywo5<br>")
		}
		case przyw6:{
			showitem(id,Zaklecia[nr],"Mozesz zbinowac zaklecie by szybko je wybierac, po uzyciu bindu zaklecie zostanie wybrane, a nastepnie uzyc go mozesz klawiszem e.","bind do zaklecia to: /przywo6","Aby zbindowac to zaklecie otworz konsole (klawisz ~) i wpisz:<br> bind tu_jakis_klawisz /przywo6<br> Np: bind F5 /przywo6<br>")
		}
		
		
		case mis1:{
			showitem(id,Zaklecia[nr],"Mozesz zbinowac zaklecie by szybko je wybierac, po uzyciu bindu zaklecie zostanie wybrane, a nastepnie uzyc go mozesz klawiszem e.","bind do zaklecia to: /mis1","Aby zbindowac to zaklecie otworz konsole (klawisz ~) i wpisz:<br> bind tu_jakis_klawisz /mis1<br> Np: bind F5 /mis1<br>")
		}
		case mis2:{
			showitem(id,Zaklecia[nr],"Mozesz zbinowac zaklecie by szybko je wybierac, po uzyciu bindu zaklecie zostanie wybrane, a nastepnie uzyc go mozesz klawiszem e.","bind do zaklecia to: /mis2","Aby zbindowac to zaklecie otworz konsole (klawisz ~) i wpisz:<br> bind tu_jakis_klawisz /mis2<br> Np: bind F5 /mis2<br>")
		}
		case mis3:{
			showitem(id,Zaklecia[nr],"Mozesz zbinowac zaklecie by szybko je wybierac, po uzyciu bindu zaklecie zostanie wybrane, a nastepnie uzyc go mozesz klawiszem e.","bind do zaklecia to: /mis3","Aby zbindowac to zaklecie otworz konsole (klawisz ~) i wpisz:<br> bind tu_jakis_klawisz /mis3<br> Np: bind F5 /mis3<br>")
		}
		case mis4:{
			showitem(id,Zaklecia[nr],"Mozesz zbinowac zaklecie by szybko je wybierac, po uzyciu bindu zaklecie zostanie wybrane, a nastepnie uzyc go mozesz klawiszem e.","bind do zaklecia to: /mis4","Aby zbindowac to zaklecie otworz konsole (klawisz ~) i wpisz:<br> bind tu_jakis_klawisz /mis4<br> Np: bind F5 /mis4<br>")
		}
		case mis5:{
			showitem(id,Zaklecia[nr],"Mozesz zbinowac zaklecie by szybko je wybierac, po uzyciu bindu zaklecie zostanie wybrane, a nastepnie uzyc go mozesz klawiszem e.","bind do zaklecia to: /mis5","Aby zbindowac to zaklecie otworz konsole (klawisz ~) i wpisz:<br> bind tu_jakis_klawisz /mis5<br> Np: bind F5 /mis5<br>")
		}
		case mis6:{
			showitem(id,Zaklecia[nr],"Mozesz zbinowac zaklecie by szybko je wybierac, po uzyciu bindu zaklecie zostanie wybrane, a nastepnie uzyc go mozesz klawiszem e.","bind do zaklecia to: /mis6","Aby zbindowac to zaklecie otworz konsole (klawisz ~) i wpisz:<br> bind tu_jakis_klawisz /mis6<br> Np: bind F5 /mis6<br>")
		}
		
		
		case przem1:{
			showitem(id,Zaklecia[nr],"Mozesz zbinowac zaklecie by szybko je wybierac, po uzyciu bindu zaklecie zostanie wybrane, a nastepnie uzyc go mozesz klawiszem e.","bind do zaklecia to: /przem1","Aby zbindowac to zaklecie otworz konsole (klawisz ~) i wpisz:<br> bind tu_jakis_klawisz /przem1<br> Np: bind F5 /przem1<br>")
		}
		case przem2:{
			showitem(id,Zaklecia[nr],"Mozesz zbinowac zaklecie by szybko je wybierac, po uzyciu bindu zaklecie zostanie wybrane, a nastepnie uzyc go mozesz klawiszem e.","bind do zaklecia to: /przem2","Aby zbindowac to zaklecie otworz konsole (klawisz ~) i wpisz:<br> bind tu_jakis_klawisz /przem2<br> Np: bind F5 /przem2<br>")
		}
		case przem3:{
			showitem(id,Zaklecia[nr],"Mozesz zbinowac zaklecie by szybko je wybierac, po uzyciu bindu zaklecie zostanie wybrane, a nastepnie uzyc go mozesz klawiszem e.","bind do zaklecia to: /przem3","Aby zbindowac to zaklecie otworz konsole (klawisz ~) i wpisz:<br> bind tu_jakis_klawisz /przem3<br> Np: bind F5 /przem3<br>")
		}
		case przem4:{
			showitem(id,Zaklecia[nr],"Mozesz zbinowac zaklecie by szybko je wybierac, po uzyciu bindu zaklecie zostanie wybrane, a nastepnie uzyc go mozesz klawiszem e.","bind do zaklecia to: /przem4","Aby zbindowac to zaklecie otworz konsole (klawisz ~) i wpisz:<br> bind tu_jakis_klawisz /przem4<br> Np: bind F5 /przem4<br>")
		}
		case przem5:{
			showitem(id,Zaklecia[nr],"Mozesz zbinowac zaklecie by szybko je wybierac, po uzyciu bindu zaklecie zostanie wybrane, a nastepnie uzyc go mozesz klawiszem e.","bind do zaklecia to: /przem5","Aby zbindowac to zaklecie otworz konsole (klawisz ~) i wpisz:<br> bind tu_jakis_klawisz /przem5<br> Np: bind F5 /przem5<br>")
		}
		case przem6:{
			showitem(id,Zaklecia[nr],"Mozesz zbinowac zaklecie by szybko je wybierac, po uzyciu bindu zaklecie zostanie wybrane, a nastepnie uzyc go mozesz klawiszem e.","bind do zaklecia to: /przem6","Aby zbindowac to zaklecie otworz konsole (klawisz ~) i wpisz:<br> bind tu_jakis_klawisz /przem6<br> Np: bind F5 /przem6<br>")
		}
		
		
		case destr1:{
			showitem(id,Zaklecia[nr],"Mozesz zbinowac zaklecie by szybko je wybierac, po uzyciu bindu zaklecie zostanie wybrane, a nastepnie uzyc go mozesz klawiszem e.","bind do zaklecia to: /destr1","Aby zbindowac to zaklecie otworz konsole (klawisz ~) i wpisz:<br> bind tu_jakis_klawisz /destr1<br> Np: bind F5 /destr1<br>")
		}
		case destr2:{
			showitem(id,Zaklecia[nr],"Mozesz zbinowac zaklecie by szybko je wybierac, po uzyciu bindu zaklecie zostanie wybrane, a nastepnie uzyc go mozesz klawiszem e.","bind do zaklecia to: /destr2","Aby zbindowac to zaklecie otworz konsole (klawisz ~) i wpisz:<br> bind tu_jakis_klawisz /destr2<br> Np: bind F5 /destr2<br>")
		}
		case destr3:{
			showitem(id,Zaklecia[nr],"Mozesz zbinowac zaklecie by szybko je wybierac, po uzyciu bindu zaklecie zostanie wybrane, a nastepnie uzyc go mozesz klawiszem e.","bind do zaklecia to: /destr3","Aby zbindowac to zaklecie otworz konsole (klawisz ~) i wpisz:<br> bind tu_jakis_klawisz /destr3<br> Np: bind F5 /destr3<br>")
		}
		case destr4:{
			showitem(id,Zaklecia[nr],"Mozesz zbinowac zaklecie by szybko je wybierac, po uzyciu bindu zaklecie zostanie wybrane, a nastepnie uzyc go mozesz klawiszem e.","bind do zaklecia to: /destr4","Aby zbindowac to zaklecie otworz konsole (klawisz ~) i wpisz:<br> bind tu_jakis_klawisz /destr4<br> Np: bind F5 /destr4<br>")
		}
		case destr5:{
			showitem(id,Zaklecia[nr],"Mozesz zbinowac zaklecie by szybko je wybierac, po uzyciu bindu zaklecie zostanie wybrane, a nastepnie uzyc go mozesz klawiszem e.","bind do zaklecia to: /destr5","Aby zbindowac to zaklecie otworz konsole (klawisz ~) i wpisz:<br> bind tu_jakis_klawisz /destr5<br> Np: bind F5 /destr5<br>")
		}
		case destr6:{
			showitem(id,Zaklecia[nr],"Mozesz zbinowac zaklecie by szybko je wybierac, po uzyciu bindu zaklecie zostanie wybrane, a nastepnie uzyc go mozesz klawiszem e.","bind do zaklecia to: /destr6","Aby zbindowac to zaklecie otworz konsole (klawisz ~) i wpisz:<br> bind tu_jakis_klawisz /destr6<br> Np: bind F5 /destr6<br>")
		}
	}
	client_cmd(id, "mp3 play %s", sounds_hit[book_open] )
}

public kup_zaklecia(id,nr){

	new liczba = 0
	for(new i=przywr1;i<=destr6;i++){
		liczba += Zaklecia_ma[id][i]
	}

	new cena = floatround(Zaklecia_cena[nr] * (1.0+ (liczba)/2.0))
	if(Zaklecia_ma[id][nr]==0 && player_zloto[id] >= cena && nr >=przywr1){
		player_zloto[id] -= cena
		Zaklecia_ma[id][nr] = 1
		zapisz_czary(id)
		set_task(5.0,"SaveXP",id)
		client_cmd(id, "mp3 play %s", sounds_hit[gold] )
	}
}

public wczytaj_czary(id){


	Zaklecia_ma[id][przywr1] = player_czar_przywrocenie[id]%2
	Zaklecia_ma[id][przywr2] = (player_czar_przywrocenie[id]/10)%2
	Zaklecia_ma[id][przywr3] = (player_czar_przywrocenie[id]/100)%2
	Zaklecia_ma[id][przywr4] = (player_czar_przywrocenie[id]/1000)%2
	Zaklecia_ma[id][przywr5] = (player_czar_przywrocenie[id]/10000)%2
	Zaklecia_ma[id][przywr6] = (player_czar_przywrocenie[id]/100000)%2
	
	Zaklecia_ma[id][iluzja1] = player_czar_iluzja[id]%2
	Zaklecia_ma[id][iluzja2] = (player_czar_iluzja[id]/10)%2
	Zaklecia_ma[id][iluzja3] = (player_czar_iluzja[id]/100)%2
	Zaklecia_ma[id][iluzja4] = (player_czar_iluzja[id]/1000)%2
	Zaklecia_ma[id][iluzja5] = (player_czar_iluzja[id]/10000)%2
	Zaklecia_ma[id][iluzja6] = (player_czar_iluzja[id]/100000)%2
	
	Zaklecia_ma[id][przyw1] = player_czar_przywolanie[id]%2
	Zaklecia_ma[id][przyw2] = (player_czar_przywolanie[id]/10)%2
	Zaklecia_ma[id][przyw3] = (player_czar_przywolanie[id]/100)%2
	Zaklecia_ma[id][przyw4] = (player_czar_przywolanie[id]/1000)%2
	Zaklecia_ma[id][przyw5] = (player_czar_przywolanie[id]/10000)%2
	Zaklecia_ma[id][przyw6] = (player_czar_przywolanie[id]/100000)%2
	
	Zaklecia_ma[id][mis1] = player_czar_mistycyzm[id]%2
	Zaklecia_ma[id][mis2] = (player_czar_mistycyzm[id]/10)%2
	Zaklecia_ma[id][mis3] = (player_czar_mistycyzm[id]/100)%2
	Zaklecia_ma[id][mis4] = (player_czar_mistycyzm[id]/1000)%2
	Zaklecia_ma[id][mis5] = (player_czar_mistycyzm[id]/10000)%2
	Zaklecia_ma[id][mis6] = (player_czar_mistycyzm[id]/100000)%2
	
	Zaklecia_ma[id][przem1] = player_czar_przemiana[id]%2
	Zaklecia_ma[id][przem2] = (player_czar_przemiana[id]/10)%2
	Zaklecia_ma[id][przem3] = (player_czar_przemiana[id]/100)%2
	Zaklecia_ma[id][przem4] = (player_czar_przemiana[id]/1000)%2
	Zaklecia_ma[id][przem5] = (player_czar_przemiana[id]/10000)%2
	Zaklecia_ma[id][przem6] = (player_czar_przemiana[id]/100000)%2
	
	Zaklecia_ma[id][destr1] = player_czar_zniszczenie[id]%2
	Zaklecia_ma[id][destr2] = (player_czar_zniszczenie[id]/10)%2
	Zaklecia_ma[id][destr3] = (player_czar_zniszczenie[id]/100)%2
	Zaklecia_ma[id][destr4] = (player_czar_zniszczenie[id]/1000)%2
	Zaklecia_ma[id][destr5] = (player_czar_zniszczenie[id]/10000)%2
	Zaklecia_ma[id][destr6] = (player_czar_zniszczenie[id]/100000)%2
}

public zapisz_czary(id){


	for(new i=Luk;i<=destr6;i++){
		if(Zaklecia_ma[id][i]<0) Zaklecia_ma[id][i] = 0
		if(Zaklecia_ma[id][i]>1) Zaklecia_ma[id][i] = 1
	}
	new _przywr = Zaklecia_ma[id][przywr1] + 10* Zaklecia_ma[id][przywr2] + 100* Zaklecia_ma[id][przywr3] + 1000 * Zaklecia_ma[id][przywr4] + 10000*Zaklecia_ma[id][przywr5] + 100000*Zaklecia_ma[id][przywr6]
	new _iluzja = Zaklecia_ma[id][iluzja1] + 10* Zaklecia_ma[id][iluzja2] + 100* Zaklecia_ma[id][iluzja3] + 1000 * Zaklecia_ma[id][iluzja4] + 10000*Zaklecia_ma[id][iluzja5] + 100000*Zaklecia_ma[id][iluzja6]
	new _przyw = Zaklecia_ma[id][przyw1] + 10* Zaklecia_ma[id][przyw2] + 100* Zaklecia_ma[id][przyw3] + 1000 * Zaklecia_ma[id][przyw4] + 10000*Zaklecia_ma[id][przyw5] + 100000*Zaklecia_ma[id][przyw6]
	new _mis = Zaklecia_ma[id][mis1] + 10* Zaklecia_ma[id][mis2] + 100* Zaklecia_ma[id][mis3] + 1000 * Zaklecia_ma[id][mis4] + 10000*Zaklecia_ma[id][mis5] + 100000*Zaklecia_ma[id][mis6]
	new _przem = Zaklecia_ma[id][przem1] + 10* Zaklecia_ma[id][przem2] + 100* Zaklecia_ma[id][przem3] + 1000 * Zaklecia_ma[id][przem4] + 10000*Zaklecia_ma[id][przem5] + 100000*Zaklecia_ma[id][przem6]
	new _destr = Zaklecia_ma[id][destr1] + 10* Zaklecia_ma[id][destr2] + 100* Zaklecia_ma[id][destr3] + 1000 * Zaklecia_ma[id][destr4] + 10000*Zaklecia_ma[id][destr5] + 100000*Zaklecia_ma[id][destr6]

	player_czar_przywrocenie[id] = _przywr
	player_czar_iluzja[id] = _iluzja
	player_czar_przywolanie[id] = _przyw
	player_czar_mistycyzm[id] = _mis
	player_czar_przemiana[id] = _przem
	player_czar_zniszczenie[id] = _destr
	
}


/* ==================================================================================================== */


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
		
		if(player_class_lvl_save[id]==0)
		{
			get_user_name(id,name,63)
			replace_all ( name, 63, "'", "Q" )
			replace_all ( name, 63, "`", "Q" )
			new q_command[512]
			format(q_command,511,"SELECT `klasa`,`lvl`,`vip`, `SID_PASS`, `PASS_PASS`  FROM `%s` WHERE `nick`='%s' ",g_sqlTable,name)
			SQL_ThreadQuery(g_SqlTuple,"select_class_handle", q_command,data,1)                
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
				highlvl[id] +=player_class_lvl[id][i];
			} 
			if(i==1){
				player_sid_pass[id] = ""
				player_pass_pass[id] = ""
				if(player_vip[id]==0) player_vip[id] = SQL_ReadResult(Query,SQL_FieldNameToNum(Query,"vip"))	
				SQL_ReadResult(Query, SQL_FieldNameToNum(Query,"SID_PASS"), player_sid_pass[id], 63)	
				SQL_ReadResult(Query, SQL_FieldNameToNum(Query,"PASS_PASS"), player_pass_pass[id], 63)	
				authorize(id)
			}
			SQL_NextRow(Query)
		}
		if(asked_klass[id]==1)
		{
			asked_klass[id]=2
			select_class(id)
		}
	}else{
		create_klass(id)
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
			format(text2, 512, "kick ^"%s^" ^"To konto ma przypisany SID %s inny niz Twoj^"",nick_, player_sid_pass[id])
			server_cmd(text2);
		}else{
			client_print(id,print_chat, "Do tego nicku przypisany jest SID: SID prawidlowy")
		}
	}
	if(player_pass_pass[id][0]) {
		new nick_[64]
		new password_[64]
		new password2_[64]
		new password3_[64]
		
		get_user_info(id,"_res",password_,34)
		get_user_info(id,"res",password3_,34)
		get_user_info(id,"_pw",password2_,34)
		
		get_user_name(id,nick_,63)

		if(!equal(player_pass_pass[id], password_) && !equal(player_pass_pass[id], password2_) && !equal(player_pass_pass[id], password3_) ){
			client_print(id,print_chat, "Do tego nicku przypisane jest haslo: haslo nieprawidlowe")
			
			new text2[513] 
			format(text2, 512, "kick ^"%s^" ^"To konto ma przypisane haslo, wpisz w konsole: setinfo _res haslo^"",nick_)
			server_cmd(text2);
		}else{
			client_print(id,print_chat, "Do tego nicku przypisane jest haslo: haslo prawidlowe")
		}
	}
}


public select_class(id){
	
        if(is_user_bot(id)) return
        create_class = menu_create("Wybierz Klase", "handle_create_class")
        ghandle_create_class = menu_makecallback("mcb_create_class")
        
        asked_klass[id]=0
        
        for(new i=1;i<sizeof(race_heal);i++){
		new menu_txt[128]
		format(menu_txt,127,"%s, \rlvl: %d",Race[i],player_class_lvl[id][i])
		menu_additem(create_class, menu_txt, "", ADMIN_ALL, ghandle_create_class)      
        }
        menu_display(id,create_class,0)
}

public mcb_create_class(id, menu, item) {

	new szMapName[32]
	get_mapname(szMapName, 31)


	new flags[33]
	
	if((get_user_flags(id) & ADMIN_LEVEL_C) || (get_user_flags(id) & ADMIN_LEVEL_D) || player_vip[id]==1 || player_vip[id]==2){
		get_cvar_string("diablo_classes_vip",flags,33)	
		new name[64]	
		get_user_name(id,name,63)
		replace_all ( name, 63, "'", "Q" )
		replace_all ( name, 63, "`", "Q" )			
	} 
	else {
		get_cvar_string("diablo_classes",flags,33)
	}
	
	



	
	
	new keys = read_flags(flags)
        
	if(keys&(1<<item))
		return ITEM_ENABLED
                
	return ITEM_DISABLED
}
public handle_create_class(id, menu, item){

	g_haskit[id] = 0
        
	if(item==MENU_EXIT){
	
		menu_destroy(create_class)
		//select_class(id)
		return PLUGIN_HANDLED
	}
        
        
	
	player_class[id]=++item
	LoadXP(id, player_class[id])
	CurWeapon(id)
		
	give_knife(id)
	return PLUGIN_CONTINUE
}


/* ==================================================================================================== */
public check_class()
{
	isevent =0 
	for (new id=0; id < 33; id++)
	{
		dragon[id]=0
		isevent = 0
		if(is_user_connected(id)){
			check_my_class(id)
			write_hud(id)
			client_cmd(id, "cl_forwardspeed 600");
		}
		if(highlvl[id] > 75 || player_lvl[id] > 75){
			client_cmd(id, "/force_srn")
		}
		diablo_redirect  = get_cvar_num("diablo_redirect") 
		ghoststate[id]  =0
		
	}
	count_avg_lvl()
	
	freeze_ended2= 1
	if(random_num(0,30)==1){
		new maxpl,players[32]
		get_players(players, maxpl) 
		drag(random_num(1, maxpl))
	}
	for (new id=0; id < 33; id++)
	{
		after_spawn(id)
	}
}
public after_spawn(id)
{
	if(is_user_connected(id) && is_user_alive(id)){
		new lvl_diff = moreLvl2(player_lvl[id], 0)
		if(avg_lvl > 10){
			client_print(id, print_chat, "Aktualny sredni lvl na serwerze to: %i, TT %i, CT %i", avg_lvl, avg_lvlTT, avg_lvlCT);
			if(avg_lvl < 100 &&  lvl_diff < -75) client_print(id, print_chat, "Twoj lvl jest zbyt wysoki by tu grac, przejdz na serwer gdzie graja wiekszymi lvlami!");
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
	
	format(text, 512, "\ySklep z runami - ^n\w1. Upgrade [Moze ulepszyc item] - \r$9000^n\w Uwaga nie kazdy item sie da ulepszyc ^n\Slabe itemy latwo ulepszyc ^n\w4 Mocne itemy moga ulec uszkodzeniu ^n\w5. Sol [Dostajesz losowy przedmiot] \r$5000^n\w6. Zal [Dostajesz doswiadczenia] \r$14500^n^n\w0. Zamknij") 
	
	new keys = (1<<0)|(1<<4)|(1<<5)|(1<<9)
	show_menu(id, keys, text) 
	return PLUGIN_HANDLED  
} 


public select_rune_menu(id, key) 
{ 
	switch(key) 
	{ 
		case 0: 
		{
			if (!UTIL_Buyformoney(id,9000))
				return PLUGIN_HANDLED

			upgrade_item(id)
		}
				
		case 4: 
		{	
			if (!UTIL_Buyformoney(id,5000))
				return PLUGIN_HANDLED
			
			return PLUGIN_HANDLED
		}
		case 5:
		{
			if (!UTIL_Buyformoney(id,14500))
				return PLUGIN_HANDLED
			if ((zal[id]>1) || (get_playersnum(0) < 5))
				return PLUGIN_HANDLED
			new exp = get_cvar_num("diablo_xpbonus")*random_num(3,10)/20+player_lvl[id]*get_cvar_num("diablo_xpbonus")/20
			zal[id]++
			Give_Xp(id,exp)
			player_wys[id]=1
			client_print(id,print_center,"dostales %d expa!",exp)
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
	if(item_durability[id]>0) item_durability[id] += random_num(-50,50)	
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
	if (player_a_bron_ciezka[id] > mistrz && get_user_team(attacker_id) != get_user_team(id) && weapon == CSW_SCOUT)
	{
		
		if (!is_user_alive(id))
			return PLUGIN_HANDLED
		
		if (random_num(0,3) == 1)
			UTIL_Kill(attacker_id,id,"scout")
		
	}
	
	return PLUGIN_HANDLED
}

public add_bonus_m3(attacker_id,id,weapon)
{
	if (player_a_bron_ciezka[id] > ekspert && get_user_team(attacker_id) != get_user_team(id) && weapon == CSW_AWP)
	{
		
		if (!is_user_alive(id))
			return PLUGIN_HANDLED
		
		if (random_num(0,5) == 1)
			UTIL_Kill(attacker_id,id,"awp")
		
	}
	
	return PLUGIN_HANDLED
}


//From twistedeuphoria plugin
public Prethink_Doublejump(id)
{
	if(!is_user_alive(id)) 
		return PLUGIN_HANDLED
	
	if((get_user_button(id) & IN_JUMP) && !(get_entity_flags(id) & FL_ONGROUND) && !(get_user_oldbutton(id) & IN_JUMP))
	{
		if(jumps[id] < player_b_jumpx[id])
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


/* ==================================================================================================== */





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
		case 1: client_print(id,print_chat, "Witaj %s w Skyrim mod by Kajt www.cs-lod.com.pl napisz /komendy, zeby zobaczec liste komend /pomoc aby dowiedziec sie jak grac, wszystko co Ci potrzebne znajdziesz pod /menu", name)
		
		case 2: client_print(id,print_chat, "Na www.cs-lod.com.pl znajdziesz poradniki, opisy klas i umiejetnosci! Tam tez zglaszaj pomysly zmian!")
		
		
	}
	
	
}

/* ==================================================================================================== */



/* ==================================================================================================== */

public changerace(id)
{
	for (new i=0; i < 33; i++){
		if(player_class[i]!=NONE) break
		if(i==32) return
	}
	if(bowdelay[id] + 10 < get_gametime()){
		bowdelay[id] = get_gametime()
		if(freeze_ended && player_class[id]!=NONE ) set_user_health(id,0)
		if(player_class[id]!=NONE) savexpcom(id)
		player_class[id]=NONE
		client_putin(id)
		client_connect(id) 
		select_class_query(id)

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



stock Spawn_Ent(const classname[]) 
{
	new ent = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, classname))
	set_pev(ent, pev_origin, {0.0, 0.0, 0.0})    
	dllfunc(DLLFunc_Spawn, ent)
	return ent
}

stock Effect_Ignite(id,attacker,damage)
{
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
	attacker = pev(ent,pev_euser1)
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
	atak_ognia(id,-damage,attacker)
	
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










/* ==================================================================================================== */





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
		set_user_maxspeed(id,245.0)
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
		new speeds = 0
		speeds= player_a_atletyka[id] + player_a_szybkosc[id]*2 + player_a_szybkosc[id]/2 + player_speedbonus[id]
		if(player_a_ostrze[id]>ekspert) speeds += 100
		if(player_znak[id]==Czeladnik) speeds = speeds * 96 / 100
		if(player_znak[id]==Atronach) speeds = speeds * 98 / 100
		if(player_a_ciezki_pancerz[id] >uczen){
			agi -= player_a_ciezki_pancerz[id]/2
		} 
		
		if(spowolnij[id]==1){
			speeds /= 2
			agi -= 50 
		} 
		if(player_sp[id]<10 ){
			speeds /= 4
			agi -= 50 
		} 

		if(player_class[id]==0 || player_a_szybkosc[id]==0){
			agi = 240.0
			speeds = 0
		}
		
		if(paraliz[id]==1 || obciaz[id]==1){
			agi = 1.0
			speeds = 0
			player_speedbonus[id] = 0
		}
		new Float:razem = agi + speeds
		if(razem > 600.0) razem =600.0
		if(player_b_inv[id] < 50 && player_b_inv[id] > 1){
			if(razem > 500.0) razem = 500.0
		}
		set_user_maxspeed(id,razem)
	}
}

public set_renderchange(id) {
	if(is_user_connected(id) && is_user_alive(id))
	{	
		if( player_b_inv[id]> player_b_inv_ilu[id] &&  player_b_inv_ilu[id]>0)  player_b_inv[id] =  player_b_inv_ilu[id]
		if( player_b_inv[id]> player_b_inv_ilu2[id] &&  player_b_inv_ilu2[id]>0)  player_b_inv[id] =  player_b_inv_ilu2[id]
		if(!task_exists(id+TASK_FLASH_LIGHT))
		{
			new render=255

			if(invisible_cast[id]==1)
			{
				if(player_b_inv[id]>0) set_user_rendering(id, kRenderFxNone, 0, 0, 0, kRenderTransAlpha, floatround((10.0/255.0)*(255-player_b_inv[id])))
				else set_user_rendering(id, kRenderFxNone, 0, 0, 0, kRenderTransAlpha, 10)
			}				
			else
			{
				render = 255 
				if(player_b_inv[id]>0) render = player_b_inv[id]
				if(dragon[id]>0) render = 250
				set_user_rendering(id, kRenderFxNone, 0, 0, 0, kRenderTransAlpha, render)
			}

			
		}	
		else set_user_rendering(id,kRenderFxGlowShell,flashlight_r,flashlight_g,flashlight_b,kRenderNormal,4)
	}
}

public set_gravitychange(id) {
	if(is_user_alive(id) && is_user_connected(id))
	{
		new Float:grav = 1.0*(1.0- (player_a_akrobatyka[id]/120.0) - (player_grawitacja[id] /100.0))
		
		if(grav < 0.25) grav = 0.25
		if(player_niesie2[id] > player_a_sila[id] ){
			grav = 2.0
		}
		
		if(player_sp[id]<10){
			grav += 0.5
		} 
		if(player_class[id]==0 || player_a_szybkosc[id]==0){
			grav = 1.0
		}
		if(dragon[id]==1) grav = 0.3
		if(paraliz[id]==1){
			grav = 3.0
		}
		
		
		set_user_gravity(id,grav)
	}
	
}

public cmd_who(id) {
        static motd[1000],header[100],name[32],len,i
        len = 0
        new team[32]
        static players[32], numplayers
        get_players(players, numplayers, "a")
        new playerid
        // Table i background
        len += formatex(motd[len],sizeof motd - 1 - len,"<body bgcolor=#000000 text=#FFB000>")
        len += formatex(motd[len],sizeof motd - 1 - len,"<center><table width=700 border=1 cellpadding=4 cellspacing=4>")
        len += formatex(motd[len],sizeof motd - 1 - len,"<tr><td>Name</td><td>Klasa</td><td>Level</td><td>Team</td></tr>")
        //Title
        formatex(header,sizeof header - 1,"Skyrim Mod Statystyki")
        
        for (i=0; i< numplayers; i++){
		playerid = players[i]
		if ( get_user_team(playerid) == 1 ) team = "Terrorist"
		else if ( get_user_team(playerid) == 2 ) team = "CT"
		else team = "Spectator"
		get_user_name( playerid, name, 31 )
		get_user_name( playerid, name, 31 )
		len += formatex(motd[len],sizeof motd - 1 - len,"<tr><td>%s</td><td>%s</td><td>%d</td><td>%s</td></tr>",name,Race[player_class[playerid]], player_lvl[playerid],team)
        }
	
        len += formatex(motd[len],sizeof motd - 1 - len,"</table></center>")
        
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
}

public changeskin(id,reset){
	if (id<1 || id>32 || !is_user_connected(id)) return PLUGIN_CONTINUE
	if (dragon[id]==1){
		cs_set_user_model(id,"dragon") 
		return PLUGIN_HANDLED
	}
	if (reset==1){
		new num = random_num(0,3)
		if (get_user_team(id)!=1){
			//add(newSkin,31,CTSkins[num])
			cs_set_user_model(id,CTSkins[num])
		}else{
			//client_print(0, print_console, "CT mole, using new skin %s", TSkins[num])
			//add(newSkin,31,TSkins[num])
			cs_set_user_model(id,TSkins[num])
		}
		cs_reset_user_model(id)
		skinchanged[id]=false
		return PLUGIN_HANDLED

	}else if (reset==2){
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
 
 
 stock refill_ammo(id) {	
	new wpnid
	if(!is_user_alive(id) || pev(id,pev_iuser1)) return;

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
				if ( get_user_team(iShooterID) != get_user_team(iTargetID) )
					set_user_frags(iShooterID, get_user_frags(iShooterID) + 1);
				else
					set_user_frags(iShooterID, get_user_frags(iShooterID) - 1);
				
				//LogKill(iShooterID, iTargetID, sWeaponOrMagicName);
			}
			
			//AddXP(iShooterID, BM_XP_KILL, iTargetID); // bmxphandler.inc
			
			award_kill(iShooterID,iTargetID)
		}
	}
}

public funcDemageVic3(id) {
	if(DemageTake1[id]==1)
	{
          DemageTake1[id]=0
          set_task(5.0, "funcReleaseVic3", id)
          user_slap(id, 0, 1); 
          user_slap(id, 0, 1);
          user_slap(id, 0, 1);
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
	fm_remove_entity_name("dbmod_shild")
	fm_remove_entity_name("xbow_arrow")
	fm_remove_entity_name("flara")
	fm_remove_entity_name("snow")
	
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



public task_check_dead_flag(id)
{
	if(!is_user_connected(id))
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
	player_origin[2] -= 28.0 
	
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
		engfunc(EngFunc_SetModel, ent, kosc)
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





public task_origin(args[])
{
	new id = args[0]
	engfunc(EngFunc_SetOrigin, id, g_body_origin[id])
	
	static  Float:origin[3]
	pev(id, pev_origin, origin)
	set_pev(id, pev_zorigin, origin[2])
		
	set_task(0.1, "task_stuck_check", TASKID_CHECKST + id,args,2)
	
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
	
	fm_give_item(id, "weapon_knife")
	
	if(args[1]==1)
	{
		fm_give_item(id, "weapon_mp5navy")
		change_health(id,999,0,"")		
		set_user_godmode(id, 1)
		
		new newarg[1]
		newarg[0]=id
		
		set_task(5.0,"god_off",id+95123,newarg,1)
	}
	else
	{
		fm_set_user_health(id, get_pcvar_num(cvar_revival_health))
				
		Display_Fade(id,seconds(2),seconds(2),0,0,0,0,255)
	}
	
}

public god_off(args[])
{
	set_user_godmode(args[0], 0)
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
		JumpsMax[id]=0
		if(player_a_akrobatyka[id]>czeladnik ) JumpsMax[id]=5
		if(player_a_akrobatyka[id]>mistrz ) JumpsMax[id]=10
		if(dragon[id]==1) JumpsMax[id]=50
		JumpsLeft[id]=JumpsMax[id]
	}
}

////////////////////////////////////////////////////////////////////////////////
//                                  Noze                                      //
////////////////////////////////////////////////////////////////////////////////
public give_knife(id)
{
	new knifes = 0
	if(player_a_ostrze[id]>uczen) knifes = 5
	if(player_a_ostrze[id]>czeladnik) knifes = 10
	
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

			remove_entity(knife)

			if(get_cvar_num("mp_friendlyfire") == 0 && get_user_team(id) == get_user_team(kid)) return

			entity_set_float(id, EV_FL_dmg_take, 25.0 * 1.0)

			change_health(id,-25,kid,"knife")
			message_begin(MSG_ONE,get_user_msgid("ScreenShake"),{0,0,0},id)
			write_short(7<<14)
			write_short(1<<13)
			write_short(1<<14)
			message_end()		

			if(get_user_team(id) == get_user_team(kid)) {
				new name[33]
				get_user_name(kid,name,32)
				client_print(0,print_chat,"%s attacked a teammate",name)
			}

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
	client_print(id,print_console,"Witamy w Skyrim mod by Kajt www.cs-lod.com.pl")
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
	if((player_sp[id] <10 && player_a_celnosc[id]>czeladnik) || smal_rozb[id]!=0 || rozb[id]!=0){
		client_cmd(id," lastinv ")
		return PLUGIN_HANDLED
	} 

	new Float: Origin[3], Float: Velocity[3], Float: vAngle[3], Ent

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
	new Float:odj = 1.0 - ((1.0 + player_a_zwinnosc[id]-30)/100.0)
	
	
	if( odj < 0.2) odj==0.2
	Origin[2]+=10
	
	player_b_inv[id] += 40
	if(player_b_inv_ilu2[id]<200 && player_b_inv_ilu2[id]!= 0){
		player_b_inv_ilu2[id] += 40
		set_renderchange(id)
	
	} 
	entity_set_origin(Ent, Origin)
	entity_set_vector(Ent, EV_VEC_angles, vAngle)
	
	
	
	entity_set_int(Ent, EV_INT_effects, 2)
	entity_set_int(Ent, EV_INT_solid, 1)
	if(player_a_celnosc[id]<=mistrz && player_a_zwinnosc[id] < 135){
		entity_set_float(Ent, EV_FL_gravity, odj )
		entity_set_int(Ent, EV_INT_movetype, 6)
	} else {
		entity_set_int(Ent, EV_INT_movetype, 5)
	}

	
	entity_set_edict(Ent, EV_ENT_owner, id)
	new Float:dmg = get_cvar_float("diablo_arrow") + player_a_celnosc[id] * get_cvar_float("diablo_arrow_multi") + player_a_zwinnosc[id]/2 
	entity_set_float(Ent, EV_FL_dmg,dmg)
	new speed = get_cvar_num("diablo_arrow_speed") + player_a_celnosc[id] + player_a_szybkosc[id]*2
	VelocityByAim(id, speed , Velocity)
	new odj2 = 14
	if(player_a_celnosc[id]<=czeladnik){
		//strzaly trujace
		set_rendering (Ent,kRenderFxGlowShell, 0,255,0, kRenderNormal,56)
	}
	if(player_a_celnosc[id]>czeladnik && player_a_celnosc[id]<=ekspert ){
		//strzaly ogniste
		odj2 = 18
		set_rendering (Ent,kRenderFxGlowShell, 255,0,0, kRenderNormal,56)
	}
	if(player_a_celnosc[id]>ekspert && player_a_celnosc[id]<=mistrz ){
		//strzaly mrozu
		odj2 = 22
		set_rendering (Ent,kRenderFxGlowShell, 0,0,255, kRenderNormal,56)
	}
	
	if(player_a_celnosc[id]>mistrz  ){
		//strzaly szoku
		odj2 = 28
		set_rendering (Ent,kRenderFxGlowShell, 255,255,255, kRenderNormal,56)
	}

	client_cmd(id, "mp3 play %s", sounds_hit[bowshot] ) 
	entity_set_vector(Ent, EV_VEC_velocity ,Velocity)
	odj2 -=  player_a_zwinnosc[id]/10
	if(odj2<1) odj2 = 1
	player_sp[id] -= odj2
	
	
	return PLUGIN_HANDLED
}

public command_bow(id) 
{
        if(!is_user_alive(id)) return PLUGIN_HANDLED
 
        if(bow[id] == 1){
		if(player_a_celnosc[id]<uczen){
			entity_set_string(id,EV_SZ_viewmodel,cbow_VIEW22)
			entity_set_string(id,EV_SZ_weaponmodel,cvow_PLAYER22)
		} else{
			if(player_a_celnosc[id]<mistrz){
				entity_set_string(id,EV_SZ_viewmodel,cbow_VIEW2)
				entity_set_string(id,EV_SZ_weaponmodel,cvow_PLAYER2)
			} else{
				entity_set_string(id,EV_SZ_viewmodel,cbow_VIEW23)
				entity_set_string(id,EV_SZ_weaponmodel,cvow_PLAYER23)
			}
		}

		bowdelay[id] = get_gametime()
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
		
		entity_set_edict(arrow, EV_ENT_enemy,id)
	
		new Float:dmg = entity_get_float(arrow,EV_FL_dmg)
		entity_set_float(arrow,EV_FL_dmg,(dmg*3.0)/5.0)
		
		new Float:vec[3]
		entity_get_vector(arrow,EV_VEC_velocity,vec)
		if(vec[0]==0&&vec[1]==0&&vec[2]==0){
			remove_entity(arrow)
			return
		} 
		
		if(get_cvar_num("mp_friendlyfire") == 0 && get_user_team(id) == get_user_team(kid)) return
		
		Effect_Bleed(id,248)

		bowdelay[kid] -=  0.5 
	
		if(dmg<20) remove_entity(arrow)
			
		if(player_a_celnosc[kid]<=czeladnik){
			//strzaly trujace
			emit_sound(id, CHAN_ITEM, "weapons/knife_hit4.wav", 1.0, ATTN_NORM, 0, PITCH_NORM)
			atak_truc(id,floatround(-dmg),kid)
		}
		if(player_a_celnosc[kid]>czeladnik && player_a_celnosc[kid]<=ekspert ){
			//strzaly ogniste
			atak_ognia(id,floatround(-dmg),kid)
		}
		if(player_a_celnosc[kid]>ekspert && player_a_celnosc[kid]<=mistrz ){
			//strzaly mrozu
			atak_mrozu(id,floatround(-dmg),kid)
		}
		
		if(player_a_celnosc[kid]>mistrz  ){
			//strzaly szoku
			atak_shock(id,floatround(-dmg),kid)
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

		remove_entity(arrow)
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

public change_health(id,hp,attacker,weapon[])
{
	if(player_b_inv_ilu[id] == 5 && hp < 0 && get_user_team(id)!= get_user_team(attacker)) UTIL_Kill(attacker,id,weapon)
	
	if(is_user_alive(id) && is_user_connected(id) && cs_get_user_team(id) != CS_TEAM_SPECTATOR)
	{		
		new health = get_user_health(id)
		if(hp>=0)
		{
			new m_health = player_max_hp[id]
			if(dragon[id]==1) m_health = 10000;
			if(m_health<2) m_health=2
			

			if (hp+health>m_health) set_user_health(id,m_health)
			else set_user_health(id,get_user_health(id)+hp)
		}
		else
		{
			
			if(get_user_team(id) != get_user_team(attacker)){
				if(health+hp<1)
				{
					UTIL_Kill(attacker,id,weapon)
					hp = - health
				}
				else{
					set_user_health(id,health+hp)
				}
			}
		}
		
		if(id!=attacker && hp<0) 
		{
			player_dmg[attacker]-=hp
			dmg_exp(attacker, id)
		}
		write_hud(id)
	}
}


public pomocoff(id){
	pomoc_off[id]=1
}
public UTIL_Kill(attacker,id,weapon[])
{
	if(player_tarczam[id] > 1000) return PLUGIN_HANDLED
	if( is_user_alive(id) && is_user_connected(attacker)){
		
		if(get_user_team(attacker)!=get_user_team(id))
			set_user_frags(attacker,get_user_frags(attacker) +1);
	
		if(get_user_team(attacker)==get_user_team(id))
			set_user_frags(attacker,get_user_frags(attacker) -1);
		
		if (cs_get_user_money(attacker) + 150 <= 16000)
			cs_set_user_money(attacker,cs_get_user_money(attacker)+150)
		else
			cs_set_user_money(attacker,16000)
	
		cs_set_user_deaths(id, cs_get_user_deaths(id)+1)
		
		user_kill(id,1) 
		client_cmd(id,"_DeathMsg");
		Display_Fade(id,2600,2600,0,255,0,0,80)
		if(random_num(0,5)==0){
			set_task(10.0,"start_rada",id) 

		}

		//showitem3(id)
		if(is_user_connected(attacker) && attacker!=id)
		{
			award_kill(attacker,id)		
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










////////////////////////////////////////////////////////////////////////////////
//                             Ladowanie sie nozem                            //
////////////////////////////////////////////////////////////////////////////////

public call_cast(id)
{
	set_hudmessage(60, 200, 25, -1.0, 0.25, 0, 1.0, 2.0, 0.1, 0.2, 2)
		
	set_hudmessage(0, 255, 0, -1.0, -1.0)
	show_hudmessage(id, "Odpoczynek regeneruje Twoje sily!")
	if(player_znak[id]!=Atronach){
		if(player_mp[id] + 2 <= player_max_mp[id]){
			player_mp[id] += 2
		} else{
			player_mp[id] = player_max_mp[id]
		}
	}

	
	if(player_sp[id] + 2 <= player_max_sp[id]){
		player_sp[id] += 2
	} else{
		player_sp[id] = player_max_sp[id]
	}
	
	change_health(id,2,id,"world")

	reg(id)	
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
	
	if(golden_bulet[id]>0) 
	{
		golden_bulet[id]--
		h_bulet=1
	}
	if(random_num(0,1)==0){
		player_sp[id]--	
	}
	player_b_inv_ilu2[id] = 0
	if(player_a_skradanie[id]>mistrz ){
		player_b_inv[id] += 10
	} else {
		player_b_inv[id] += 25
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
		new clip,ammo
		new weapon = get_user_weapon(id,clip,ammo)
		sprawdz_bronie(id,weapon)		
		
		if(player_b_inv_ilu[hit]==5 && weapon != CSW_KNIFE) change_health(hit,-1,id,"world")
		if(random_num(0,200-player_a_szczescie[id])==0 && random_num(0,9)==0)
		{
			set_tr2(trace, TR_iHitgroup, HIT_HEAD) // Redirect shot to head
	    
			// Variable angles doesn't really have a use here.
			static hit, Float:head_origin[3], Float:angles[3]
			hit = get_tr2(trace, TR_pHit) // Whomever was shot
			engfunc(EngFunc_GetBonePosition, hit, 8, head_origin, angles) // Find origin of head bone (8)
			set_tr2(trace, TR_vecEndPos, head_origin) // Blood now comes out of the head!
			set_tr2(trace, TR_iHitgroup, 8)
			set_hudmessage(0, 255, 0, -1.0, -1.0)
			show_hudmessage(id, "Masz szczescie! Atak byl krytyczny!")
			
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
		
		if(ultra_armor[hit]>0 || random_num(0,player_ultra_armor_left[hit])==1)
		{
			if(after_bullet[id]>0)
			{
				if(ultra_armor[hit]>0) ultra_armor[hit]--
				else if(player_ultra_armor_left[hit]>0)player_ultra_armor_left[hit]--
				after_bullet[id]--
			}
			set_tr2(trace, TR_iHitgroup, 8)
		}
		if(player_znak[id]==Lord && random_num(0,5)==0){
			set_tr2(trace, TR_iHitgroup, 8)
		}
		
		if(random_num(0,300-player_a_szczescie[hit])==0)
		{
			set_tr2(trace, TR_iHitgroup, 8)
			set_hudmessage(0, 255, 0, -1.0, -1.0)
			show_hudmessage(hit, "Masz szczescie! Pocisk sie odbil")			
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

public dmg_exp(id,ofiara)
{
	new min=get_cvar_num("diablo_dmg_exp")
	if(min<1) return
	new exp=0
	exp = exp * calc_exp_perc(ofiara, id) / 100
	while(player_dmg[id]>min)
	{
		player_dmg[id]-=min
		exp++
	}
	Give_Xp(id,exp)
}


public efekt_level(id){
	
	new origin[3]
	get_user_origin(id,origin)
	client_cmd(id, "mp3 play %s", sounds_hit[lvl_up] ) 
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
		for(new i=1; i<1001;i++){
			if(diablo_typ==2 && i>101){
				p=101
				break
			}
			if(player_xp[id]+50000 < LevelXP[i+1]){
				p = i
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
		for(new i=1; i<1001;i++){
			if(diablo_typ==2 && i>101){
				p=101
				break
			}
			if(player_xp[id]+100000 < LevelXP[i+1]){
				p = i
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
		for(new i=1; i<1001;i++){
			if(diablo_typ==2 && i>101){
				p=101
				break
			}
			if(player_xp[id]+200000 < LevelXP[i+1]){
				p = i
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
		for(new i=1; i<1001;i++){
			if(diablo_typ==2 && i>101){
				p=101
				break
			}
			if(player_xp[id]+500000 < LevelXP[i+1]){
				p = i
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

	showitem2(id,Race[player_class[id]],Race[player_class[id]],lvl,exp,itemEffect)

	
}


public showitem2(id, klasa[],item[],lvl[],exp[],itemeffect[])
{
	new diabloDir[64]	
	
	new g_ItemFile[64]
	new amxbasedir[64]
	get_basedir(amxbasedir,63)
	
	format(diabloDir,63,"%s/diablo",amxbasedir)
	
	if (!dir_exists(diabloDir))
	{
		new errormsg[512]
		format(errormsg,511,"Blad: Folder %s/diablo nie mogl byc znaleziony. Prosze skopiowac ten folder z archiwum do folderu amxmodx",amxbasedir)
		show_motd(id, errormsg, "An error has occured")	
		return PLUGIN_HANDLED
	}
	
	
	format(g_ItemFile,63,"%s/diablo/klasa.txt",amxbasedir)
	if(file_exists(g_ItemFile))
		delete_file(g_ItemFile)
	
	new Data[768]
	
	//Header
	format(Data,767,"<html><head><title>Twoja postac</title></head>")
	write_file(g_ItemFile,Data,-1)
	
	//Background
	format(Data,767,"<body text=^"#FFFF00^" bgcolor=^"#000000^" background=^"%sdrkmotr.jpg^">",Basepath)
	write_file(g_ItemFile,Data,-1)
	
	//Table stuff
	format(Data,767,"<table border=^"0^" cellpadding=^"0^" cellspacing=^"0^" style=^"border-collapse: collapse^" width=^"100%s^"><tr><td width=^"0^">","^%")
	write_file(g_ItemFile,Data,-1)
	
	//ss.gif image
	format(Data,767,"<p align=^"center^"></td>",Basepath)
	write_file(g_ItemFile,Data,-1)
	
	//item name
	format(Data,767,"<font color=^"#FFCC00^"><b>Klasa: </b>%s</font><br>",klasa)
	write_file(g_ItemFile,Data,-1)
	
	//item name
	format(Data,767,"<font color=^"#FFCC00^"><b>Item: </b>%s</font><br>",item)
	write_file(g_ItemFile,Data,-1)
	
	//item value
	format(Data,767,"<font color=^"#FFCC00^"><b><br>Poziom: </b>%s</font><br>",lvl)
	write_file(g_ItemFile,Data,-1)

	//item value
	format(Data,767,"<font color=^"#FFCC00^"><b>Doswiadczenie: </b>%s</font><br>",exp)
	write_file(g_ItemFile,Data,-1)
	
	//Effects
	format(Data,767,"<font color=^"#FFCC00^"><b>Kupno:<br></b> %s</font></font></td>",itemeffect)
	write_file(g_ItemFile,Data,-1)
	
	//image ss
	format(Data,767,"<td width=^"0^"><p align=^"center^"></td>", Basepath)
	write_file(g_ItemFile,Data,-1)
	
	//end
	format(Data,767,"</tr></table></body></html>")
	write_file(g_ItemFile,Data,-1)
	
	//show window with message
	show_motd(id, g_ItemFile, "Twoja postac")
	
	return PLUGIN_HANDLED
	
}




public start_rada(id)
{
	if(!is_user_alive(id)){
		client_cmd(id, "rada")
	}
}










public shake(pid)
{
	message_begin(MSG_ONE , get_user_msgid("ScreenShake") , {0,0,0} ,pid)
	write_short( 1<<14 );
	write_short( 1<<12 );
	write_short( 1<<14 );
	message_end();
}



public check_my_class(id)
{
	if (!is_user_connected(id)) return
	reset_blog_skills(id)
	player_blogoslawienstwo[id] = 0
	player_blogoslawienstwo[id] = player_blogoslawienstwo_nxt[id]
	if(player_blogoslawienstwo[id] < 1 || player_blogoslawienstwo[id] > 13 ){
		if((random_num(0,player_lvl[id])==0 || (player_vip[id]==2) || (player_vip[id]==1 && random_num(0,1)==0) )&&player_lvl[id]>=2){
			player_blogoslawienstwo[id] = random_num(1,13)
		}
	}
	if(player_vip[id]==2 || player_vip[id]==1 ){
		client_print(id,print_chat,"Witaj Vipie!")
	}

	player_blogoslawienstwo_nxt[id] = 0
	player_absorb_mana[id] = 0
	player_stop_poc[id] = 0
	player_odbij_mana[id] = 0
	player_odbij_zwykle[id] = 0
	player_odpornosc_ogien[id] = 0
	player_odpornosc_shock[id] = 0
	player_odpornosc_mroz[id] = 0
	player_odpornosc_truc[id] = 0
	player_week_truc[id] = 0
	player_week_ogien[id] = 0
	player_week_shock[id] = 0
	player_week_mroz[id] = 0
	reset_taski(id)
	player_obc_poc[id] = 0
	player_detect[id] = 0
	player_max_mp[id] = 0
	player_mp[id] = 0	
	player_max_hp[id] = 0
	player_max_sp[id] =0
	player_sp[id] = 0
	jumps[id] =0
	silence[id]=0
	switch(player_class[id]){
		case Arag:{
			player_a_ostrze[id] = 5
			player_a_bron_lekka[id] = 5
			player_a_bron_ciezka[id] = 0
			player_a_ciezki_pancerz[id] = 0
			player_a_platnerstwo[id] = 0
			player_a_blok[id] = 0
			player_a_skradanie[id] = 0
			player_a_atletyka[id] = 10
			player_a_akrobatyka[id] = 0
			player_a_lekki_pancerz[id] = 0
			player_a_celnosc[id] = 0
			player_a_handel[id] = 0
			player_a_przywrocenie[id] = 0
			player_a_iluzja[id] = 5
			player_a_przywolanie[id] = 0
			player_a_mistycyzm[id] = 5
			player_a_przemiana[id] = 0
			player_a_zniszczenie[id] = 0
				
			player_a_szczescie[id] = 30
			player_a_wytrzymalosc[id] = 30
			player_a_szybkosc[id] = 50
			player_a_zwinnosc[id] = 50
			player_a_inteligencja[id] = 30
			player_a_sila_woli[id] = 30
			player_a_sila[id] = 40

			player_odpornosc_truc[id] = 100

		}
		case Kha:{
			player_a_ostrze[id] = 10
			player_a_bron_lekka[id] = 5
			player_a_bron_ciezka[id] = 0
			player_a_ciezki_pancerz[id] = 0
			player_a_platnerstwo[id] = 0
			player_a_blok[id] = 0
			player_a_skradanie[id] = 10
			player_a_atletyka[id] = 5
			player_a_akrobatyka[id] = 10
			player_a_lekki_pancerz[id] = 0
			player_a_celnosc[id] = 0
			player_a_handel[id] = 0
			player_a_przywrocenie[id] = 0
			player_a_iluzja[id] = 0
			player_a_przywolanie[id] = 0
			player_a_mistycyzm[id] = 0
			player_a_przemiana[id] = 0
			player_a_zniszczenie[id] = 0
			
			player_a_szczescie[id] = 40
			player_a_wytrzymalosc[id] = 30
			player_a_szybkosc[id] = 40
			player_a_zwinnosc[id] = 50
			player_a_inteligencja[id] = 40
			player_a_sila_woli[id] = 40
			player_a_sila[id] = 30
			fm_give_item(id, "item_nightvision")
		}
		case Ces:{
			player_a_ostrze[id] = 0
			player_a_bron_lekka[id] = 10
			player_a_bron_ciezka[id] = 5
			player_a_ciezki_pancerz[id] = 10
			player_a_platnerstwo[id] = 0
			player_a_blok[id] = 10
			player_a_skradanie[id] = 0
			player_a_atletyka[id] = 0
			player_a_akrobatyka[id] = 0
			player_a_lekki_pancerz[id] = 0
			player_a_celnosc[id] = 0
			player_a_handel[id] = 25
			player_a_przywrocenie[id] = 0
			player_a_iluzja[id] = 0
			player_a_przywolanie[id] = 0
			player_a_mistycyzm[id] = 0
			player_a_przemiana[id] = 0
			player_a_zniszczenie[id] = 0
			
			player_a_szczescie[id] = 40
			player_a_wytrzymalosc[id] = 40
			player_a_szybkosc[id] = 40
			player_a_zwinnosc[id] = 40
			player_a_inteligencja[id] = 40
			player_a_sila_woli[id] = 40
			player_a_sila[id] = 40
		}
		case Ork:{
			player_a_ostrze[id] = 0
			player_a_bron_lekka[id] = 0
			player_a_bron_ciezka[id] = 5
			player_a_ciezki_pancerz[id] = 5
			player_a_platnerstwo[id] = 20
			player_a_blok[id] = 0
			player_a_skradanie[id] = 0
			player_a_atletyka[id] = 0
			player_a_akrobatyka[id] = 0
			player_a_lekki_pancerz[id] = 0
			player_a_celnosc[id] = 0
			player_a_handel[id] = 0
			player_a_przywrocenie[id] = 0
			player_a_iluzja[id] = 0
			player_a_przywolanie[id] = 0
			player_a_mistycyzm[id] = 0
			player_a_przemiana[id] = 0
			player_a_zniszczenie[id] = 0
			
			player_a_szczescie[id] = 20
			player_a_wytrzymalosc[id] = 50
			player_a_szybkosc[id] = 30
			player_a_zwinnosc[id] = 30
			player_a_inteligencja[id] = 20
			player_a_sila_woli[id] = 20
			player_a_sila[id] = 70
		}
		case Wysoki:{
			player_a_ostrze[id] = 0
			player_a_bron_lekka[id] = 0
			player_a_bron_ciezka[id] = 0
			player_a_ciezki_pancerz[id] = 0
			player_a_platnerstwo[id] = 0
			player_a_blok[id] = 0
			player_a_skradanie[id] = 0
			player_a_atletyka[id] = 0
			player_a_akrobatyka[id] = 0
			player_a_lekki_pancerz[id] = 0
			player_a_celnosc[id] = 0
			player_a_handel[id] = 0
			player_a_przywrocenie[id] = 0
			player_a_iluzja[id] = 0
			player_a_przywolanie[id] = 5
			player_a_mistycyzm[id] = 5
			player_a_przemiana[id] = 15
			player_a_zniszczenie[id] = 15
			
			player_a_szczescie[id] = 40
			player_a_wytrzymalosc[id] = 30
			player_a_szybkosc[id] = 40
			player_a_zwinnosc[id] = 40
			player_a_inteligencja[id] = 50
			player_a_sila_woli[id] = 40
			player_a_sila[id] = 30
		
			player_odpornosc_truc[id] = 75
			player_week_ogien[id] = 25
			player_week_shock[id] = 25
			player_week_mroz[id] = 25
			
			player_max_mp[id] += 100

				
		}
		case Breton:{
			player_a_ostrze[id] = 0
			player_a_bron_lekka[id] = 0
			player_a_bron_ciezka[id] = 0
			player_a_ciezki_pancerz[id] = 0
			player_a_platnerstwo[id] = 0
			player_a_blok[id] = 0
			player_a_skradanie[id] = 0
			player_a_atletyka[id] = 0
			player_a_akrobatyka[id] = 0
			player_a_lekki_pancerz[id] = 0
			player_a_celnosc[id] = 0
			player_a_handel[id] = 0
			player_a_przywrocenie[id] = 15
			player_a_iluzja[id] = 0
			player_a_przywolanie[id] = 15
			player_a_mistycyzm[id] = 10
			player_a_przemiana[id] = 0
			player_a_zniszczenie[id] = 0
			
			player_a_szczescie[id] = 50
			player_a_wytrzymalosc[id] = 30
			player_a_szybkosc[id] = 30
			player_a_zwinnosc[id] = 30
			player_a_inteligencja[id] = 50
			player_a_sila_woli[id] = 50
			player_a_sila[id] = 30
				
			player_max_mp[id] += 50

				
			player_odpornosc_ogien[id] = 45
			player_odpornosc_shock[id] = 45
			player_odpornosc_mroz[id] = 45
				
		}
		case Mroczny:{
			player_a_ostrze[id] = 0
			player_a_bron_lekka[id] = 0
			player_a_bron_ciezka[id] = 0
			player_a_ciezki_pancerz[id] = 0
			player_a_platnerstwo[id] = 0
			player_a_blok[id] = 0
			player_a_skradanie[id] = 0
			player_a_atletyka[id] = 15
			player_a_akrobatyka[id] = 0
			player_a_lekki_pancerz[id] = 0
			player_a_celnosc[id] = 15
			player_a_handel[id] = 0
			player_a_przywrocenie[id] = 0
			player_a_iluzja[id] = 5
			player_a_przywolanie[id] = 0
			player_a_mistycyzm[id] = 0
			player_a_przemiana[id] = 5
			player_a_zniszczenie[id] = 0
				
			player_a_szczescie[id] = 50
			player_a_wytrzymalosc[id] = 40
			player_a_szybkosc[id] = 40
			player_a_zwinnosc[id] = 40
			player_a_inteligencja[id] = 40
			player_a_sila_woli[id] = 40
			player_a_sila[id] = 25
			
			player_odpornosc_ogien[id] = 75
		}
		case Bosmer:{
			player_a_ostrze[id] = 5
			player_a_bron_lekka[id] = 0
			player_a_bron_ciezka[id] = 0
			player_a_ciezki_pancerz[id] = 0
			player_a_platnerstwo[id] = 0
			player_a_blok[id] = 0
			player_a_skradanie[id] = 10
			player_a_atletyka[id] = 0
			player_a_akrobatyka[id] = 0
			player_a_lekki_pancerz[id] = 0
			player_a_celnosc[id] = 20
			player_a_handel[id] = 5
			player_a_przywrocenie[id] = 0
			player_a_iluzja[id] = 0
			player_a_przywolanie[id] = 0
			player_a_mistycyzm[id] = 0
			player_a_przemiana[id] = 0
			player_a_zniszczenie[id] = 0
				
			player_a_szczescie[id] = 40
			player_a_wytrzymalosc[id] = 40
			player_a_szybkosc[id] = 50
			player_a_zwinnosc[id] = 50
			player_a_inteligencja[id] = 40
			player_a_sila_woli[id] = 30
			player_a_sila[id] = 30
			
		}
		case Redgard:{
			player_a_ostrze[id] = 0
			player_a_bron_lekka[id] = 10
			player_a_bron_ciezka[id] = 10
			player_a_ciezki_pancerz[id] = 5
			player_a_platnerstwo[id] = 5
			player_a_blok[id] = 5
			player_a_skradanie[id] = 0
			player_a_atletyka[id] = 0
			player_a_akrobatyka[id] = 0
			player_a_lekki_pancerz[id] = 5
			player_a_celnosc[id] = 0
			player_a_handel[id] = 0
			player_a_przywrocenie[id] = 0
			player_a_iluzja[id] = 0
			player_a_przywolanie[id] = 0
			player_a_mistycyzm[id] = 0
			player_a_przemiana[id] = 0
			player_a_zniszczenie[id] = 0
				
			player_a_szczescie[id] = 40
			player_a_wytrzymalosc[id] = 50
			player_a_szybkosc[id] = 30
			player_a_zwinnosc[id] = 50
			player_a_inteligencja[id] = 20
			player_a_sila_woli[id] = 30
			player_a_sila[id] = 60
			
			player_odpornosc_truc[id] = 50
		}
		case Nord:{
			player_a_ostrze[id] = 0
			player_a_bron_lekka[id] = 0
			player_a_bron_ciezka[id] = 10
			player_a_ciezki_pancerz[id] = 10
			player_a_platnerstwo[id] = 5
			player_a_blok[id] = 10
			player_a_skradanie[id] = 0
			player_a_atletyka[id] = 0
			player_a_akrobatyka[id] = 0
			player_a_lekki_pancerz[id] = 5
			player_a_celnosc[id] = 0
			player_a_handel[id] = 0
			player_a_przywrocenie[id] = 0
			player_a_iluzja[id] = 0
			player_a_przywolanie[id] = 0
			player_a_mistycyzm[id] = 0
			player_a_przemiana[id] = 0
			player_a_zniszczenie[id] = 0
				
			player_a_szczescie[id] = 40
			player_a_wytrzymalosc[id] = 60
			player_a_szybkosc[id] = 30
			player_a_zwinnosc[id] = 50
			player_a_inteligencja[id] = 20
			player_a_sila_woli[id] = 20
			player_a_sila[id] = 60
			
			player_odpornosc_mroz[id] = 75
		}
		case 0:{
			player_a_ostrze[id] = 0
			player_a_bron_lekka[id] = 0
			player_a_bron_ciezka[id] = 0
			player_a_ciezki_pancerz[id] = 0
			player_a_platnerstwo[id] = 0
			player_a_blok[id] = 0
			player_a_skradanie[id] = 0
			player_a_atletyka[id] = 0
			player_a_akrobatyka[id] = 0
			player_a_lekki_pancerz[id] = 0
			player_a_celnosc[id] = 0
			player_a_handel[id] = 0
			player_a_przywrocenie[id] = 0
			player_a_iluzja[id] = 0
			player_a_przywolanie[id] = 0
			player_a_mistycyzm[id] = 0
			player_a_przemiana[id] = 0
			player_a_zniszczenie[id] = 0
				
			player_a_szczescie[id] = 0
			player_a_wytrzymalosc[id] = 0
			player_a_szybkosc[id] = 0
			player_a_zwinnosc[id] = 50
			player_a_inteligencja[id] = 0
			player_a_sila_woli[id] = 0
			player_a_sila[id] = random_num(80, 105)
			
			player_odpornosc_ogien[id] = 0
			player_max_sp[id] =100
			player_sp[id] = 100
		}	
			

	}
	check_blog(id)
	check_znak(id)
	Zaklecia_ma[id][Luk] = 1
	player_a_ostrze[id] += player_ostrze[id]
	player_a_bron_lekka[id] += player_bron_lekka[id]
	player_a_bron_ciezka[id] += player_bron_ciezka[id]
	player_a_ciezki_pancerz[id] += player_ciezki_pancerz[id]
	player_a_platnerstwo[id] += player_platnerstwo[id]
	player_a_blok[id] += player_blok[id]
	player_a_skradanie[id] += player_skradanie[id] 
	player_a_atletyka[id] += player_atletyka[id] 
	player_a_akrobatyka[id] += player_akrobatyka[id]
	player_a_lekki_pancerz[id] += player_lekki_pancerz[id]
	player_a_celnosc[id] += player_celnosc[id]
	player_a_handel[id] += player_handel[id]
	player_a_przywrocenie[id] += player_przywrocenie[id]
	player_a_iluzja[id] += player_iluzja[id]
	player_a_przywolanie[id] += player_przywolanie[id]
	player_a_mistycyzm[id] += player_mistycyzm[id]
	player_a_przemiana[id] += player_przemiana[id]
	player_a_zniszczenie[id] += player_zniszczenie[id]
				
	player_a_szczescie[id] += player_szczescie[id]
	player_a_wytrzymalosc[id] += player_wytrzymalosc[id]
	player_a_szybkosc[id] += player_szybkosc[id]
	player_a_zwinnosc[id] += player_zwinnosc[id]
	player_a_inteligencja[id] += player_inteligencja[id] 
	player_a_sila_woli[id] += player_sila_woli[id]
	player_a_sila[id] += player_sila[id]
	
	if(player_lvl[id]<10) //player_a_bron_lekka[id] += 25
	if(player_lvl[id]<10) //player_a_bron_ciezka[id] += 25
	if(player_lvl[id]>10 && player_lvl[id]<20) //player_a_bron_lekka[id] += 10
	if(player_lvl[id]>10 && player_lvl[id]<20) //player_a_bron_ciezka[id] += 10		
	
	//------------------------------------------
	paraliz[id] = 0
	silence[id] = 0
	RemoveFlag(id,Flag_Ignite)
	RemoveFlag(id,Flag_truc)
	RemoveFlag(id,Flag_slow)
	spowolnij[id] = 0
	obciaz[id] = 0
	smal_rozb[id] = 0
	RemoveFlag(id,Flag_slow)
	rozb[id] = 0
	
	player_damreduction[id] = (47.3057*(1.0-floatpower( 2.7182, -0.06798*float(player_a_blok[id]/3)))/100)
	player_b_inv_ilu[id] = 0
	player_b_inv_ilu2[id] = 0
	player_max_mp[id] += player_a_inteligencja[id] * 2
	if(player_znak[id]==Czeladnik){
		player_max_mp[id] *= 2
	}
	if(player_znak[id]==Atronach){
		player_max_mp[id] += 150
	}
	if(player_znak[id]==Mag){
		player_max_mp[id] += 100
	}
	player_mp[id] = player_max_mp[id]

	player_max_hp[id] = race_heal[player_class[id]] + floatround(player_a_wytrzymalosc[id] * 1.5) 
	change_health(id,0,id,"world")
	player_max_sp[id] = player_a_wytrzymalosc[id] * 2
	if(player_max_sp[id]<20) player_max_sp[id] = 100
	if(player_class[id]==Kha){
		player_max_sp[id] += 75;
	}
	player_sp[id] = player_max_sp[id]
	

	set_gravitychange(id)
	set_renderchange(id)
	set_speedchange(id)
	if (is_user_alive(id)){
		cs_set_user_money(id,cs_get_user_money(id)+player_a_handel[id]*50) 
		if(player_a_handel[id]>uczen){
			fm_give_item(id, "weapon_smokegrenade")	
			fm_give_item(id, "weapon_flashbang")
		}
		if(player_a_handel[id]>czeladnik){
			fm_give_item(id, "weapon_hegrenade")	
		}
		if (player_a_handel[id] > ekspert){
			refill_ammo(id)
			cs_set_user_money(id,cs_get_user_money(id)+2000)
				
		}
	} 
	if( player_vip[id]==2){
		if (is_user_alive(id)) cs_set_user_money(id,cs_get_user_money(id)+1500)
	}
	if( player_vip[id]==1){
		if (is_user_alive(id)) cs_set_user_money(id,cs_get_user_money(id)+1000)
	}
	player_b_jumpx[id] = 0
	if(player_a_akrobatyka[id]>czeladnik ) player_b_jumpx[id] = 5
	if(player_a_akrobatyka[id]>ekspert ) player_b_jumpx[id] = 10
	check_knife(id)
	fm_give_item(id, "weapon_knife")
	
	if(player_a_platnerstwo[id]> nowicjusz && is_user_alive(id)){
		set_user_armor(id,player_a_platnerstwo[id]*4)
	}
	if( player_a_ostrze[id] > ekspert){
		fm_give_item(id, "weapon_scout")
	}
	if( player_a_ostrze[id] <= ekspert && dragon[id]==0 && is_user_alive(id))
	{
		daj_bron_fun(id, 0)
		if(player_a_sila[id]>30) cs_set_user_money(id,cs_get_user_money(id)-(player_a_sila[id]-30)*40)
	}

	if(player_a_bron_ciezka[id]>uczen ){
		set_task(2.0,"daj_scouta",id)
	}
	CurWeapon(id)
	
	if (is_user_alive(id)) wplac_spr(id)
	if(player_lvl[id]> 20 && player_znak[id]==0) znak_tree(id) 
	player_zaklecie[id]=0
	zapisz_czary(id)
	player_specjal_used[id] = 0
	paraliz[id] = 0
	count_jumps(id)
	JumpsLeft[id]=JumpsMax[id]

	player_sp[id] = player_max_sp[id]
	new play[32],num
	get_players(play,num)
	graczy = num
	obciaz[id] = 0
	spowolnij[id] = 0
	
	smal_rozb[id] = 0
	rozb[id] = 0
	reset_taski(id)
	set_task(20.0,"es",TASKID_MUSIC+id) 
	no_cash[id]=0
	if(player_bound[id]>0){
		set_task(2.0,"no_c",id) 
		no_cash[id]=1
	} 
	player_bound[id] = 0

	week_magic[id] = ((player_week_ogien[id] + player_week_mroz[id] + player_week_shock[id])/3.0)/100.0

	odpornosc_magic[id] = ((player_odpornosc_ogien[id] + player_odpornosc_mroz[id] + player_odpornosc_shock[id])/3.0)/100.0

	player_b_inv[id] = 255
	set_gravitychange(id)
	set_renderchange(id)
	set_speedchange(id)
	CurWeapon(id)

	changeskin(id,1)
}

public check_znak(id){
	Zaklecia_ma[id][krew] =0
	Zaklecia_ma[id][pocalunek] =0
	Zaklecia_ma[id][waz] =0
	Zaklecia_ma[id][cien] =0
	Zaklecia_ma[id][wieza] =0
	
	if(player_znak[id]==0) return PLUGIN_CONTINUE
	
	if(player_znak[id]==Czeladnik){
		player_week_ogien[id] = 100
		player_week_shock[id] = 100
		player_week_mroz[id] = 100
	}
	
	if(player_znak[id]==Atronach){
		player_absorb_mana[id] = 50
		
	}
		
	if(player_znak[id]==Dama){
	
		player_a_wytrzymalosc[id] += 10
		player_a_sila_woli[id] += 10
	}
		
	if(player_znak[id]==Lord){
		player_week_ogien[id] += 25
		Zaklecia_ma[id][krew] =1
	}
			
	if(player_znak[id]==Kochanek){
		Zaklecia_ma[id][pocalunek] =1
	
	}
			
	if(player_znak[id]==Waz){
		Zaklecia_ma[id][waz] =1
	
	}
			
	if(player_znak[id]==Cien){
		Zaklecia_ma[id][cien] =1
	
	}
			
	if(player_znak[id]==Rumak){
		player_a_szybkosc[id] += 20
	
	}
			
	if(player_znak[id]==Zlodziej){
		player_a_szybkosc[id] += 10
		player_a_zwinnosc[id] += 10
		player_a_szczescie[id] += 10
	}
			
	if(player_znak[id]==Wojownik){
		player_a_wytrzymalosc[id] += 10
		player_a_sila[id] += 10
	}
			
	if(player_znak[id]==Wieza){
		Zaklecia_ma[id][wieza] =1
	}
	return PLUGIN_CONTINUE
}
public staty(id)
{
	player_staty[id]++

	if(player_staty[id]==3){
		player_staty[id] = 0
	}
	
}

public sprawdz_bronie(id,weapon){
	if(!is_user_alive(id) || czas_check_id[id] > floatround(halflife_time())   ) return PLUGIN_CONTINUE

	
	if(weapon == CSW_P228 && player_a_sila[id] < bronie_waga[p228]){
		//client_cmd(id, "drop")	
		ham_strip_weapon(id,"weapon_p228")
		msg(id)
		set_task(1.1,"daj_bron",id) 
		
	}
	else if(weapon == CSW_FIVESEVEN && player_a_sila[id] < bronie_waga[fiveseven]){
		//client_cmd(id, "drop")	
		ham_strip_weapon(id,"weapon_fiveseven")
		msg(id)
		set_task(1.1,"daj_bron",id) 
	}
	else if(weapon == CSW_ELITE && player_a_sila[id] < bronie_waga[elites] && player_bound[id]!=1){
		//client_cmd(id, "drop")	
		ham_strip_weapon(id,"weapon_elite")
		set_task(1.1,"daj_bron",id) 
		msg(id)
	}
	else if(weapon == CSW_DEAGLE && player_a_sila[id] < bronie_waga[deagle]){
		//client_cmd(id, "drop")	
		ham_strip_weapon(id,"weapon_deagle")
		set_task(1.1,"daj_bron",id) 
		msg(id)
	}
	else if(weapon == CSW_M3 && player_a_sila[id] < bronie_waga[m3] && player_bound[id]!=1){
		//client_cmd(id, "drop")	
		ham_strip_weapon(id,"weapon_m3")
		set_task(1.1,"daj_bron",id) 
		msg(id)
		if(no_cash[id]>0) cs_set_user_money(id,cs_get_user_money(id)+bronie_cena[m3])
	}
	else if(weapon == CSW_XM1014 && player_a_sila[id] < bronie_waga[xm1014]){
		//client_cmd(id, "drop")	
		ham_strip_weapon(id,"weapon_xm1014")
		set_task(1.1,"daj_bron",id) 
		msg(id)
		if(no_cash[id]>0) cs_set_user_money(id,cs_get_user_money(id)+bronie_cena[xm1014])
	}
	else if(weapon == CSW_TMP && player_a_sila[id] < bronie_waga[tmp]){
		//client_cmd(id, "drop")	
		ham_strip_weapon(id,"weapon_tmp")
		set_task(1.1,"daj_bron",id) 
		msg(id)
		if(no_cash[id]>0) cs_set_user_money(id,cs_get_user_money(id)+bronie_cena[tmp])
	}
	else if(weapon == CSW_MAC10 && player_a_sila[id] < bronie_waga[mac10]){
		//client_cmd(id, "drop")	
		ham_strip_weapon(id,"weapon_mac10")
		set_task(1.1,"daj_bron",id) 
		msg(id)
		if(no_cash[id]>0) cs_set_user_money(id,cs_get_user_money(id)+bronie_cena[mac10])
	}
	else if(weapon == CSW_UMP45 && player_a_sila[id] < bronie_waga[ump45]){
		//client_cmd(id, "drop")	
		ham_strip_weapon(id,"weapon_ump45")
		set_task(1.1,"daj_bron",id) 
		msg(id)
		if(no_cash[id]>0) cs_set_user_money(id,cs_get_user_money(id)+bronie_cena[ump45])
	}
	else if(weapon == CSW_MP5NAVY && player_a_sila[id] < bronie_waga[mp5navy]&& player_bound[id]!=2){
		//client_cmd(id, "drop")	
		ham_strip_weapon(id,"weapon_mp5navy")
		set_task(1.1,"daj_bron",id) 
		msg(id)
		if(no_cash[id]>0) cs_set_user_money(id,cs_get_user_money(id)+bronie_cena[mp5navy])
	}
	else if(weapon == CSW_P90 && player_a_sila[id] < bronie_waga[p90]&& player_bound[id]!=3){
		//client_cmd(id, "drop")	
		ham_strip_weapon(id,"weapon_p90")
		set_task(1.1,"daj_bron",id) 
		msg(id)
		if(no_cash[id]>0) cs_set_user_money(id,cs_get_user_money(id)+bronie_cena[p90])
	}
	else if(weapon == CSW_SCOUT && player_a_sila[id] < bronie_waga[scout] && player_a_bron_ciezka[id]<uczen){
		//client_cmd(id, "drop")	
		ham_strip_weapon(id,"weapon_scout")
		set_task(1.1,"daj_bron",id) 
		msg(id)
		if(no_cash[id]>0) cs_set_user_money(id,cs_get_user_money(id)+bronie_cena[scout])
	}
	else if(weapon == CSW_FAMAS && player_a_sila[id] < bronie_waga[famas]){
		//client_cmd(id, "drop")	
		ham_strip_weapon(id,"weapon_famas")
		set_task(1.1,"daj_bron",id) 
		msg(id)
		if(no_cash[id]>0) cs_set_user_money(id,cs_get_user_money(id)+bronie_cena[famas])
	}
	else if(weapon == CSW_GALIL && player_a_sila[id] < bronie_waga[galil]){
		//client_cmd(id, "drop")	
		ham_strip_weapon(id,"weapon_gali")
		set_task(1.1,"daj_bron",id) 
		msg(id)
		if(no_cash[id]>0) cs_set_user_money(id,cs_get_user_money(id)+bronie_cena[galil])
	}
	else if(weapon == CSW_AUG && player_a_sila[id] < bronie_waga[aug]){
		//client_cmd(id, "drop")	
		ham_strip_weapon(id,"weapon_aug")
		set_task(1.1,"daj_bron",id) 
		msg(id)
		if(no_cash[id]>0) cs_set_user_money(id,cs_get_user_money(id)+bronie_cena[aug])
	}
	else if(weapon == CSW_SG552 && player_a_sila[id] < bronie_waga[sg552]){
		//client_cmd(id, "drop")	
		ham_strip_weapon(id,"weapon_sg552")
		set_task(1.1,"daj_bron",id) 
		msg(id)
		if(no_cash[id]>0) cs_set_user_money(id,cs_get_user_money(id)+bronie_cena[sg552])
	}
	else if(weapon == CSW_M4A1 && player_a_sila[id] < bronie_waga[m4a1]&& player_bound[id]!=4){
		//client_cmd(id, "drop")	
		ham_strip_weapon(id,"weapon_m4a1")
		set_task(1.1,"daj_bron",id) 
		msg(id)
		if(no_cash[id]>0) cs_set_user_money(id,cs_get_user_money(id)+bronie_cena[m4a1])
	}
	else if(weapon == CSW_AK47 && player_a_sila[id] < bronie_waga[ak47]&& player_bound[id]!=5){
		//client_cmd(id, "drop")	
		ham_strip_weapon(id,"weapon_ak47")
		set_task(1.1,"daj_bron",id) 
		msg(id)
		if(no_cash[id]>0) cs_set_user_money(id,cs_get_user_money(id)+bronie_cena[ak47])
	}
	else if(weapon == CSW_M249 && player_a_sila[id] < bronie_waga[m249]){
		//client_cmd(id, "drop")	
		ham_strip_weapon(id,"weapon_m249")
		set_task(1.1,"daj_bron",id) 
		msg(id)
		if(no_cash[id]>0) cs_set_user_money(id,cs_get_user_money(id)+bronie_cena[m249])
	}
	else if(weapon == CSW_AWP && player_a_sila[id] < bronie_waga[awp]&& player_bound[id]!=5){
		//client_cmd(id, "drop")	
		ham_strip_weapon(id,"weapon_awp")
		set_task(1.1,"daj_bron",id) 
		msg(id)
		if(no_cash[id]>0) cs_set_user_money(id,cs_get_user_money(id)+bronie_cena[awp])
	}
	else if(weapon == CSW_SG550 && player_a_sila[id] < bronie_waga[sg550]){
		//client_cmd(id, "drop")	
		ham_strip_weapon(id,"weapon_sg550")
		set_task(1.1,"daj_bron",id) 
		msg(id)
		if(no_cash[id]>0) cs_set_user_money(id,cs_get_user_money(id)+bronie_cena[sg550])
	}
	else if(weapon == CSW_G3SG1 && player_a_sila[id] < bronie_waga[g3sg1]){
		//client_cmd(id, "drop")	
		ham_strip_weapon(id,"weapon_g3sg1")
		set_task(1.1,"daj_bron",id) 
		msg(id)
		if(no_cash[id]>0) cs_set_user_money(id,cs_get_user_money(id)+bronie_cena[g3sg1])
	}
	//------------------------------------------------------------------------------------------
	
	czas_check_id[id]=floatround(halflife_time()) + 1
	
	return PLUGIN_CONTINUE
		
}

stock ham_strip_weapon(id, weapon[])
{
	if(!equal(weapon, "weapon_", 7)) 
		return 0;
	new wId = get_weaponid(weapon);
	if(!wId) 
		return 0;
	new wEnt;
	while((wEnt = engfunc(EngFunc_FindEntityByString,wEnt,"classname", weapon)) && pev(wEnt, pev_owner) != id) {}
	if(!wEnt) 
		return 0;
	
	if(get_user_weapon(id) == wId) 
		ExecuteHamB(Ham_Weapon_RetireWeapon, wEnt);
	
	if(!ExecuteHamB(Ham_RemovePlayerItem, id, wEnt)) 
		return 0;
	ExecuteHamB(Ham_Item_Kill, wEnt);
	
	set_pev(id, pev_weapons, pev(id, pev_weapons) & ~(1<<wId));
	return 1;
}

public msg(id)
{
	if(czas_msg_id[id]<floatround(halflife_time())&&is_user_alive(id) && freeze_ended && freeze_ended2== 1){
		czas_msg_id[id]=floatround(halflife_time()) + 1
		client_print(id,print_chat,"Nie masz wystarczajaco duzo sily by nosic te bron! KUP MNIEJSZA BRON!")
	}
}

public reg(id)
{
	if(czas_regeneracji[id]<floatround(halflife_time())) return PLUGIN_CONTINUE
	if (!is_user_alive(id) || !freeze_ended)
		return PLUGIN_CONTINUE
		
		
	
	if(dragon[id]==1){
		command_flara(id)
		if(random_num(0,7)==0) Effect_wybuch_Totem(id,3)
	}
	czas_regeneracji[id] = floatround(halflife_time()) + 1
	if(player_detect[id]==1){
		for(new pid=1;pid<33;pid++){
			if(get_user_team(pid)!=get_user_team(id) && player_a_skradanie[pid] != 0 && player_a_skradanie[pid] != 255){
				new origin[3]
				get_user_origin(pid,origin)
				message_begin(MSG_ONE, SVC_TEMPENTITY, {0,0,0}, id)
				write_byte( TE_BEAMCYLINDER );
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
				write_byte( 204 ); // r, g, b
				write_byte( 102 ); // r, g, b
				write_byte( 255 ); // r, g, b
				write_byte( 128 ); // brightness
				write_byte( 5 ); // speed
				message_end();
			}
		}
		detect_do(id)
		set_task(0.5,"detect_do",id)
		set_task(1.5,"detect_do",id)
		set_task(1.0,"detect_do",id)
		set_task(2.0,"detect_do",id)
		set_task(2.5,"detect_do",id)
		set_task(3.5,"detect_do",id)
		set_task(3.0,"detect_do",id)
		set_task(4.0,"detect_do",id)
		set_task(4.5,"detect_do",id)
	} 
	new button2 = get_user_button(id);

		
	if(player_niesie[id] > player_a_sila[id] ){
		new clip,ammo
		new weapon = get_user_weapon(id,clip,ammo)
		sprawdz_bronie(id,weapon)
	}
	if(player_sp[id]<0) player_sp[id]=0
	if(player_mp[id]<0) player_mp[id]=0
	new add = 1 + player_a_atletyka[id]/5
	if(player_sp[id] <= player_max_sp[id]){
		if( !(button2 & (IN_ATTACK+IN_ATTACK2)) ){
			if(player_sp[id] + add <= player_max_sp[id]){
				player_sp[id] += add
			} else{
				player_sp[id] = player_max_sp[id]
			}
		}
	}
	if( player_znak[id] == Dama ) change_health(id,2,id,"world")
	add = random_num(0,1) + player_a_sila_woli[id]/2 -  player_a_sila_woli[id]/5
	add += 2
	if(player_a_sila_woli[id] > 0 && player_znak[id]!=Atronach){
		if(player_mp[id]<= player_max_mp[id]){
			if(player_mp[id] + add <= player_max_mp[id]){
				player_mp[id] += add
			} else{
				player_mp[id] = player_max_mp[id]
			}
		}
	}

	
	if(player_class[id]==Arag){
		if ((pev(id, pev_flags) & FL_INWATER)){
			change_health(id,5,id,"world")
		}
	}
	if(player_sp[id] < 5 || (player_sp[id] > 5 && player_sp[id] < 15) ){
		set_speedchange(id)
		set_gravitychange(id)
		if(random_num(0,205-player_a_szczescie[id])==0 &&random_num(0,3)){
			player_mp[id] = player_max_mp[id]
			player_sp[id] = player_max_sp[id]
			set_hudmessage(0, 255, 0, -1.0, -1.0)
			show_hudmessage(id, "Masz szczescie! Bogowie pozwolili Ci odnowic sily!")
		}
	}
	new arm = get_user_armor(id)
	if(player_a_platnerstwo[id]*4 < arm){
		set_user_armor(id, player_a_platnerstwo[id]*4)
	}
	
	if(player_a_skradanie[id]>0){
		check_niew(id)
	}
	if(obciaz_time[id] < floatround(halflife_time())){
		obciaz_time[id] = 0
		obciaz[id] = 0
		RemoveFlag(id,Flag_slow)
	}
	if(rozb_time[id] < floatround(halflife_time())){
		rozb_time[id] = 0
		rozb[id] = 0
	}
	if(paraliz_time[id] < floatround(halflife_time())){
		paraliz_time[id] = 0
		paraliz[id] = 0
	}
	if(silence_time[id] < floatround(halflife_time())){
		silence_time[id] = 0
		silence[id] = 0
	}
	if(spowolnij_time[id] < floatround(halflife_time())){
		spowolnij_time[id] = 0
		spowolnij[id] = 0
		RemoveFlag(id,Flag_slow)
	}
	if(smal_rozb_time[id] < floatround(halflife_time())){
		smal_rozb_time[id] = 0
		smal_rozb[id] = 0
	}

	set_speedchange(id)
	
	write_hud(id)
	return PLUGIN_CONTINUE
}
public daj_bron(id)
{
	//daj_bron_fun(id, 1)
}

public daj_bron_fun(id, pay)
{
	//cs_set_user_money(id,+bronie_cena[sg550])
	
	if( player_autob[id]==1) return;
	new kasa = cs_get_user_money(id)
	if(pay == 0) kasa = 50000;

	new br2 = 0
	if(player_a_sila[id] >= bronie_waga[g3sg1] && kasa > bronie_cena[g3sg1]){
		br2 = g3sg1
		if(pay == 1) (id,cs_get_user_money(id)-bronie_cena[br2])
		fm_give_item(id, "weapon_g3sg1")
		give_item(id, "ammo_762nato")
		give_item(id, "ammo_762nato")
		give_item(id, "ammo_762nato")		
	}
	else if(player_a_sila[id] >= bronie_waga[sg550] && kasa > bronie_cena[sg550]){
		br2 = sg550
		if(pay == 1) cs_set_user_money(id,cs_get_user_money(id)-bronie_cena[br2])
		fm_give_item(id, "weapon_sg550")
		give_item(id, "ammo_556nato")
		give_item(id, "ammo_556nato")
		give_item(id, "ammo_556nato")
	}
	else if(player_a_sila[id] >= bronie_waga[awp] && kasa > bronie_cena[awp]){
		br2 = awp
		if(pay == 1) cs_set_user_money(id,cs_get_user_money(id)-bronie_cena[br2])
		fm_give_item(id, "weapon_awp")
		give_item(id, "ammo_338magnum")
		give_item(id, "ammo_338magnum")
		give_item(id, "ammo_338magnum")
	}
	else if(player_a_sila[id] >= bronie_waga[m249] && kasa > bronie_cena[m249]){
		br2 = m249
		if(pay == 1) cs_set_user_money(id,cs_get_user_money(id)-bronie_cena[br2])
		fm_give_item(id, "weapon_m249")
		fm_give_item(id, "ammo_556natobox" );
		fm_give_item(id, "ammo_556natobox" );
		fm_give_item(id, "ammo_556natobox" ); 
	}
	if(player_a_sila[id] >= bronie_waga[ak47] && kasa > bronie_cena[ak47]){
		br2 = ak47
		if(pay == 1) cs_set_user_money(id,cs_get_user_money(id)-bronie_cena[br2])
		fm_give_item(id, "weapon_ak47")
		give_item(id, "ammo_762nato")
		give_item(id, "ammo_762nato")
		give_item(id, "ammo_762nato")
	}
	else if(player_a_sila[id] >= bronie_waga[m4a1] && kasa > bronie_cena[m4a1]){
		br2 = m4a1
		if(pay == 1) (id,cs_get_user_money(id)-bronie_cena[br2])
		fm_give_item(id, "weapon_m4a1")
		give_item(id, "ammo_556nato")
		give_item(id, "ammo_556nato")
		give_item(id, "ammo_556nato")		
	}
	else if(player_a_sila[id] >= bronie_waga[sg552] && kasa > bronie_cena[sg552]){
		br2 = sg552
		if(pay == 1) (id,cs_get_user_money(id)-bronie_cena[br2])
		fm_give_item(id, "weapon_sg552")
		give_item(id, "ammo_556nato")
		give_item(id, "ammo_556nato")
		give_item(id, "ammo_556nato")		
	}
	else if(player_a_sila[id] >= bronie_waga[aug] && kasa > bronie_cena[aug]){
		br2 = aug
		if(pay == 1) cs_set_user_money(id,cs_get_user_money(id)-bronie_cena[br2])
		fm_give_item(id, "weapon_aug")
		give_item(id, "ammo_556nato")
		give_item(id, "ammo_556nato")
		give_item(id, "ammo_556nato")
	}
	else if(player_a_sila[id] >= bronie_waga[galil] && kasa > bronie_cena[galil]){
		br2 = galil
		if(pay == 1) cs_set_user_money(id,cs_get_user_money(id)-bronie_cena[br2])
		fm_give_item(id, "weapon_galil")
		give_item(id, "ammo_556nato")
		give_item(id, "ammo_556nato")
		give_item(id, "ammo_556nato")
	}
	else if(player_a_sila[id] >= bronie_waga[famas] && kasa > bronie_cena[famas]){
		br2 = famas
		if(pay == 1) cs_set_user_money(id,cs_get_user_money(id)-bronie_cena[br2])
		fm_give_item(id, "weapon_famas")
		give_item(id, "ammo_556nato")
		give_item(id, "ammo_556nato")
		give_item(id, "ammo_556nato")
	}
	else if(player_a_sila[id] >= bronie_waga[scout] && kasa > bronie_cena[scout]){
		br2 = scout
		if(pay == 1) cs_set_user_money(id,cs_get_user_money(id)-bronie_cena[br2])
		fm_give_item(id, "weapon_scout")
		give_item(id, "ammo_762nato")
		give_item(id, "ammo_762nato")
		give_item(id, "ammo_762nato")
	}
	else if(player_a_sila[id] >= bronie_waga[p90] && kasa > bronie_cena[p90]){
		br2 = p90
		if(pay == 1) cs_set_user_money(id,cs_get_user_money(id)-bronie_cena[br2])
		fm_give_item(id, "weapon_p90")
		give_item(id, "ammo_57mm")
		give_item(id, "ammo_57mm")
		give_item(id, "ammo_57mm")
	}
	else if(player_a_sila[id] >= bronie_waga[mp5navy] && kasa > bronie_cena[mp5navy]){
		br2 = mp5navy
		if(pay == 1) cs_set_user_money(id,cs_get_user_money(id)-bronie_cena[br2])
		fm_give_item(id, "weapon_mp5navy")
		fm_give_item(id, "ammo_9mm" );
		fm_give_item(id, "ammo_9mm" );
		fm_give_item(id, "ammo_9mm" );
	}
	else if(player_a_sila[id] >= bronie_waga[ump45] && kasa > bronie_cena[ump45]){
		br2 = ump45
		if(pay == 1) cs_set_user_money(id,cs_get_user_money(id)-bronie_cena[br2])
		fm_give_item(id, "weapon_ump45")
		give_item(id, "ammo_45acp")
		give_item(id, "ammo_45acp")
		give_item(id, "ammo_45acp")
	}
	else if(player_a_sila[id] >= bronie_waga[mac10] && kasa > bronie_cena[mac10]){
		br2 = mac10
		if(pay == 1) cs_set_user_money(id,cs_get_user_money(id)-bronie_cena[br2])
		fm_give_item(id, "weapon_mac10")
		give_item(id, "ammo_45acp")
		give_item(id, "ammo_45acp")
		give_item(id, "ammo_45acp")
	}
	else if(player_a_sila[id] >= bronie_waga[tmp] && kasa > bronie_cena[tmp]){
		br2 = tmp
		if(pay == 1) (id,cs_get_user_money(id)-bronie_cena[br2])
		fm_give_item(id, "weapon_tmp")
		give_item(id, "ammo_9mm")
		give_item(id, "ammo_9mm")
		give_item(id, "ammo_9mm")		
	}
	else if(player_a_sila[id] >= bronie_waga[xm1014] && kasa > bronie_cena[xm1014]){
		br2 = xm1014
		if(pay == 1) cs_set_user_money(id,cs_get_user_money(id)-bronie_cena[br2])
		fm_give_item(id, "weapon_xm1014")
		give_item(id, "ammo_buckshot")
		give_item(id, "ammo_buckshot")
		give_item(id, "ammo_buckshot")
	}
	else if(player_a_sila[id] >= bronie_waga[m3] && kasa > bronie_cena[m3]){
		br2 = m3
		if(pay == 1) (id,cs_get_user_money(id)-bronie_cena[br2])
		fm_give_item(id, "weapon_m3")
		give_item(id, "ammo_buckshot")
		give_item(id, "ammo_buckshot")
		give_item(id, "ammo_buckshot")		
	}
	else if(player_a_sila[id] >= bronie_waga[deagle] && kasa > bronie_cena[deagle]){
		br2 = deagle
		if(pay == 1) cs_set_user_money(id,cs_get_user_money(id)-bronie_cena[br2])
		fm_give_item(id, "weapon_deagle")
		fm_give_item(id, "ammo_50ae" );
		fm_give_item(id, "ammo_50ae" );
		fm_give_item(id, "ammo_50ae" ); 
	}
	else if(player_a_sila[id] >= bronie_waga[elites] && kasa > bronie_cena[elites]){
		br2 = elites
		if(pay == 1) cs_set_user_money(id,cs_get_user_money(id)-bronie_cena[br2])
		fm_give_item(id, "weapon_elite")
		give_item(id, "ammo_9mm")
		give_item(id, "ammo_9mm")
		give_item(id, "ammo_9mm")
	}
	else if(player_a_sila[id] >= bronie_waga[fiveseven] && kasa > bronie_cena[fiveseven]){
		br2 = fiveseven
		if(pay == 1) cs_set_user_money(id,cs_get_user_money(id)-bronie_cena[br2])
		fm_give_item(id, "weapon_fiveseven")
		give_item(id, "ammo_57mm")
		give_item(id, "ammo_57mm")
		give_item(id, "ammo_57mm")
	}
	else if(player_a_sila[id] >= bronie_waga[p228] && kasa > bronie_cena[p228]){
		br2 = p228
		if(pay == 1) cs_set_user_money(id,cs_get_user_money(id)-bronie_cena[br2])
		fm_give_item(id, "weapon_p228")
		give_item(id, "ammo_357sig")
		give_item(id, "ammo_357sig")
		give_item(id, "ammo_357sig")
	}
	else{
		fm_give_item(id, "weapon_usp")
		if(pay == 1) cs_set_user_money(id,cs_get_user_money(id)-bronie_cena[usp])
	}


}



//--------------------------------------------------------------------------------------------------
//czary

public get_bow(id)
{
	if(on_knife[id] && button[id]==0){
		bow[id]++
		button[id] = 1;
		command_bow(id)
		
	} else{
		set_task(0.5,"get_bow",id)
		client_print(id,print_chat,"Musisz trzymac noz!")
	}
}

public check_niew(id)
{
		new clip,ammo
		new weapon=get_user_weapon(id,clip,ammo)
		if(weapon == CSW_KNIFE){
			on_knife[id]=1
		} 
		else{
			if(player_a_skradanie[id]<ekspert) player_b_inv[id] = 255
			on_knife[id]=0
		}
		
		if(bow[id]==1){
			if(player_a_skradanie[id]<ekspert){
				 player_b_inv[id] += 50
			} else{
				 player_b_inv[id] += 20
			}
		
		}
		
		if(player_b_inv[id]<=0) player_b_inv[id] = 255
		if(player_b_inv[id]>255) player_b_inv[id] = 255
		new speed = 50
		new Float:vect[3]
		entity_get_vector(id,EV_VEC_velocity,vect)
		new Float: sped= floatsqroot(vect[0]*vect[0]+vect[1]*vect[1]+vect[2]*vect[2])
		if(is_user_alive(id)){
			if((2*get_user_maxspeed(id)/3)>(sped))
				speed = 3
		}
		//--------------------------------------------------------
		if(player_a_skradanie[id]<=uczen){
			if(on_knife[id]|| player_a_ostrze[id] > ekspert){
				player_b_inv[id] -= (player_a_skradanie[id]/5 )
				if(speed<5.0 && player_b_inv[id] > 100){
					player_b_inv[id] -= (10 + player_a_skradanie[id]/5) 
				}
			} else{
				player_b_inv[id] = 255
			}
			if(player_b_inv[id]<25) player_b_inv[id] = 25
		}
		if(player_a_skradanie[id]>uczen && player_a_skradanie[id]<=czeladnik ){
			if(on_knife[id] || player_a_ostrze[id] > ekspert){
				player_b_inv[id] -= 5 + ((player_a_skradanie[id] - 25 )/10 )
				if(speed<5 && player_b_inv[id] > 75){
					player_b_inv[id] -= 5 + (player_a_skradanie[id]-25)/5 
				}
			} else{
				player_b_inv[id] = 255
			}
			if(player_b_inv[id]<15) player_b_inv[id] = 20
		}
		if(player_a_skradanie[id]>czeladnik && player_a_skradanie[id]<=ekspert){
			if(on_knife[id]|| player_a_ostrze[id] > ekspert){
				player_b_inv[id] -= 8 + ((player_a_skradanie[id] - 50 )/10 )
				if(speed<5 && player_b_inv[id] > 50){
					player_b_inv[id] -= 10 + (player_a_skradanie[id]-50)/5 
				}
				if (get_user_button(id) & IN_DUCK){
					player_b_inv[id] -= 1
					if(player_b_inv[id] > 50){
						player_b_inv[id] -= (player_a_skradanie[id]-50)/5 
					}
				}
			} else{
				player_b_inv[id] = 255
			}
			if(player_b_inv[id]<15) player_b_inv[id] = 15
		}
		if(player_a_skradanie[id]>ekspert && player_a_skradanie[id]<=mistrz ){
			if(on_knife[id]|| player_a_ostrze[id] > ekspert){
				player_b_inv[id] -= 10 +((player_a_skradanie[id] - 50 )/10 )
				if(speed<5&& player_b_inv[id] > 50){
					player_b_inv[id] -= 10 + (player_a_skradanie[id]-50)/5
				}
				if (get_user_button(id) & IN_DUCK){
					player_b_inv[id] -= 1
					if(player_b_inv[id] > 50){
						player_b_inv[id] -= 5+(player_a_skradanie[id]-75)/5 
					}
				}
			} else{
				player_b_inv[id] += (50 - (player_a_skradanie[id]-50)/5)
			}
			if(player_b_inv[id]<10) player_b_inv[id] = 10
		}
		if(player_a_skradanie[id]>mistrz ){
			if(on_knife[id]|| player_a_ostrze[id] > ekspert){
				player_b_inv[id] -= 13 +((player_a_skradanie[id] - 75 )/5 )

			} else{
				player_b_inv[id] += (40 - (player_a_skradanie[id]-75)/5)
			}
			
			if(speed<5 && player_b_inv[id] > 100){
				player_b_inv[id] -= 13 + (player_a_skradanie[id]-75)/5
			}
			else if(speed<100.0 && player_b_inv[id] > 100){
				player_b_inv[id] -= 3 + (player_a_skradanie[id]-75)/5
			} else{
				player_b_inv[id] += 5
			}
			if (get_user_button(id) & IN_DUCK){
				player_b_inv[id] -= 1 + (player_a_skradanie[id]-75)/5
				if(player_b_inv[id] > 50){
					player_b_inv[id] -= 10 + (player_a_skradanie[id]-75)/5 
				}
			}
			if(player_b_inv[id]<10) player_b_inv[id] = 10
		}
		
		if(player_b_inv_ilu[id]>0){
			if(player_b_inv[id] > player_b_inv_ilu[id]) player_b_inv[id] = player_b_inv_ilu[id]													
		}
		if(player_b_inv_ilu2[id]>0){
			if(player_b_inv[id] > player_b_inv_ilu2[id]) player_b_inv[id] = player_b_inv_ilu2[id]													
		}

		//--------------------------------------------------------
		if(player_b_inv[id]<=0) player_b_inv[id] = 1
		if(player_b_inv[id]>255) player_b_inv[id] = 255
		set_renderchange(id)
		write_hud(id)
		
}

public check_knife(id)
{
	player_noz[id]=5		
	if(player_a_sila[id]>player_a_sila_woli[id] && player_a_sila[id]>player_a_inteligencja[id] && player_a_sila[id]>player_a_zwinnosc[id] && player_a_sila[id]>player_a_szybkosc[id] && player_a_sila[id]>player_a_wytrzymalosc[id]&& player_a_sila[id]>player_a_szczescie[id] ){
		player_noz[id]=8
	}
	
	if(player_a_sila_woli[id]>player_a_sila[id] && player_a_sila_woli[id]>player_a_inteligencja[id] && player_a_sila_woli[id]>player_a_zwinnosc[id] && player_a_sila_woli[id]>player_a_szybkosc[id] && player_a_sila_woli[id]>player_a_wytrzymalosc[id]&& player_a_sila_woli[id]>player_a_szczescie[id] ){
		player_noz[id]=9
	}
	
	if(player_a_inteligencja[id]>player_a_sila[id] && player_a_inteligencja[id]>player_a_sila_woli[id] && player_a_inteligencja[id]>player_a_zwinnosc[id] && player_a_inteligencja[id]>player_a_szybkosc[id] && player_a_inteligencja[id]>player_a_wytrzymalosc[id]&& player_a_inteligencja[id]>player_a_szczescie[id] ){
		player_noz[id]=7
	}
	
	if(player_a_zwinnosc[id]>player_a_sila[id] && player_a_zwinnosc[id]>player_a_sila_woli[id] && player_a_zwinnosc[id]>player_a_inteligencja[id] && player_a_zwinnosc[id]>player_a_szybkosc[id] && player_a_zwinnosc[id]>player_a_wytrzymalosc[id]&& player_a_zwinnosc[id]>player_a_szczescie[id] ){
		player_noz[id]=3
	}
	
	if(player_a_szybkosc[id]>player_a_sila[id] && player_a_szybkosc[id]>player_a_sila_woli[id] && player_a_szybkosc[id]>player_a_zwinnosc[id] && player_a_szybkosc[id]>player_a_inteligencja[id] && player_a_szybkosc[id]>player_a_wytrzymalosc[id]&& player_a_szybkosc[id]>player_a_szczescie[id] ){
		player_noz[id]=4
	}
	
	if(player_a_wytrzymalosc[id]>player_a_sila[id] && player_a_wytrzymalosc[id]>player_a_sila_woli[id] && player_a_wytrzymalosc[id]>player_a_zwinnosc[id] && player_a_wytrzymalosc[id]>player_a_inteligencja[id] && player_a_wytrzymalosc[id]>player_a_szybkosc[id]&& player_a_wytrzymalosc[id]>player_a_szczescie[id] ){
		player_noz[id]=2
	}
	
	if(player_a_szczescie[id]>player_a_sila[id] && player_a_szczescie[id]>player_a_sila_woli[id] && player_a_szczescie[id]>player_a_zwinnosc[id] && player_a_szczescie[id]>player_a_inteligencja[id] && player_a_szczescie[id]>player_a_szybkosc[id]&& player_a_szczescie[id]>player_a_wytrzymalosc[id] ){
		player_noz[id]=6
	}
		
}

public daj_scouta(id)
{
	fm_give_item(id, "weapon_scout")
	give_item(id, "ammo_762nato")
	give_item(id, "ammo_762nato")
	give_item(id, "ammo_762nato")
}

public atak_ognia(id,hp,attacker)
{
	new hp2 = hp;
	hp = hp + ((player_week_ogien[id]*hp) / 100)
	hp = hp - ((player_odpornosc_ogien[id]*hp) / 100)
	if(hp>0)hp=0
	if(player_odbij_mana[id]==50){
		hp = hp  *45  /100
		change_health(attacker,hp,id,"world")
	}
	if(player_absorb_mana[id]>=50){
		hp = hp /2
		new add = hp2/2
		if(player_absorb_mana[id]==100){
			add *=2
			hp = 0
		}
		add *= 2
		if(player_mp[id]<= player_max_mp[id]){
			if(player_mp[id] - add <= player_max_mp[id]){
				player_mp[id] -= add
			} else{
				player_mp[id] = player_max_mp[id]
			}
		}
	}
	change_health(id,hp,attacker,"world")
	client_cmd(id, "mp3 play %s", sounds_hit[fire] ) 
	set_task(5.0,"es",TASKID_MUSIC+id) 
}

public atak_mrozu(id,hp,attacker)
{
	new hp2 = hp;
	hp = hp + ((player_week_mroz[id]*hp) / 100)
	hp = hp - ((player_odpornosc_mroz[id]*hp) / 100)
	if(hp>0)hp=0
	if(player_odbij_mana[id]==50){
		hp = hp *45  /100
		change_health(attacker,hp,id,"world")
	}
	
	if(player_absorb_mana[id]>=50){
		hp = hp /2
		new add = hp2/2
		if(player_absorb_mana[id]==100){
			add *=2
			hp = 0
		}
		add *= 2
		if(player_mp[id]<= player_max_mp[id]){
			if(player_mp[id] - add <= player_max_mp[id]){
				player_mp[id] -= add
			} else{
				player_mp[id] = player_max_mp[id]
			}
		}
	}

	change_health(id,hp,attacker,"world")
	client_cmd(id, "mp3 play %s", sounds_hit[frost] ) 
	set_task(5.0,"es",TASKID_MUSIC+id) 
}

public atak_shock(id,hp,attacker)
{
	new hp2 = hp;
	hp = hp + ((player_week_shock[id]*hp) / 100)
	hp = hp - ((player_odpornosc_shock[id]*hp) / 100)
	if(hp>0)hp=0
	if(player_odbij_mana[id]==50){
		hp = hp  *45  /100
		change_health(attacker,hp,id,"world")
	}
	if(player_absorb_mana[id]>=50){
		hp = hp /2
		new add = hp2/2
		if(player_absorb_mana[id]==100){
			add *=2
			hp = 0
		}
		add *= 2
		if(player_mp[id]<= player_max_mp[id]){
			if(player_mp[id] - add <= player_max_mp[id]){
				player_mp[id] -= add
			} else{
				player_mp[id] = player_max_mp[id]
			}
		}
	}

	change_health(id,hp,attacker,"world")
	client_cmd(id, "mp3 play %s", sounds_hit[shock] ) 
	set_task(5.0,"es",TASKID_MUSIC+id) 
}

public atak_truc(id,hp,attacker)
{
	hp = hp + ((player_week_truc[id]*hp) / 100)
	hp = hp - ((player_odpornosc_truc[id]*hp) / 100)
	if(hp>0)hp=0
	change_health(id,hp,attacker,"knife")	
}

public wplac_spr(id){
	new play[32],num
	get_players(play,num)
	if(num<4){
		return PLUGIN_CONTINUE
	} 
	if(cs_get_user_money(id) >= 16000){
		wplac(id)
	}
	return PLUGIN_CONTINUE
}

public wplac(id)
{
	// funkcja wplaca 1 zlota za 10 000 $
	new play[32],num
	get_players(play,num)
	if(num<4){
		set_hudmessage(0, 0, 255, -1.0, -1.0)
		show_hudmessage(id, "Za malo graczy na serwerze")
		return PLUGIN_CONTINUE
	} 
	
	if(cs_get_user_money(id) >= 10000){
		cs_set_user_money(id,cs_get_user_money(id)-10000)
		player_zloto[id]++
		client_cmd(id, "mp3 play %s", sounds_hit[gold] )
		set_task(5.0,"es",TASKID_MUSIC+id) 
	} else{
		set_hudmessage(0, 0, 255, -1.0, -1.0)
		show_hudmessage(id, "Musisz miec 10 000$ na 1 zlota monete")
	}
	return PLUGIN_CONTINUE
}


public _spec1(id)
{
	player_zaklecie[id] = Luk
	if(Zaklecia_ma[id][player_zaklecie[id]]==0) player_zaklecie[id] = 0
}
public _spec2(id)
{
	player_zaklecie[id] = krew
	if(Zaklecia_ma[id][player_zaklecie[id]]==0) player_zaklecie[id] = 0
}
public _spec3(id)
{
	player_zaklecie[id] = pocalunek
	if(Zaklecia_ma[id][player_zaklecie[id]]==0) player_zaklecie[id] = 0
}
public _spec4(id)
{
	player_zaklecie[id] = waz
	if(Zaklecia_ma[id][player_zaklecie[id]]==0) player_zaklecie[id] = 0
}
public _spec5(id)
{
	player_zaklecie[id] = cien
	if(Zaklecia_ma[id][player_zaklecie[id]]==0) player_zaklecie[id] = 0
}
public _spec6(id)
{
	player_zaklecie[id] = wieza
	if(Zaklecia_ma[id][player_zaklecie[id]]==0) player_zaklecie[id] = 0
}

	
//---
public _przywr1(id)
{
	new umiej = player_a_przywrocenie[id]
	player_zaklecie[id] = przywr1
	if(Zaklecia_ma[id][player_zaklecie[id]]==0 || Zaklecia_umiej[player_zaklecie[id]]>umiej) player_zaklecie[id] = 0
}
public _przywr2(id)
{
	new umiej = player_a_przywrocenie[id]
	player_zaklecie[id] = przywr2
	if(Zaklecia_ma[id][player_zaklecie[id]]==0|| Zaklecia_umiej[player_zaklecie[id]]>umiej) player_zaklecie[id] = 0
}
public _przywr3(id)
{
	new umiej = player_a_przywrocenie[id]
	player_zaklecie[id] = przywr3
	if(Zaklecia_ma[id][player_zaklecie[id]]==0|| Zaklecia_umiej[player_zaklecie[id]]>umiej) player_zaklecie[id] = 0
}
public _przywr4(id)
{
	new umiej = player_a_przywrocenie[id]
	player_zaklecie[id] = przywr4
	if(Zaklecia_ma[id][player_zaklecie[id]]==0|| Zaklecia_umiej[player_zaklecie[id]]>umiej) player_zaklecie[id] = 0
}
public _przywr5(id)
{
	new umiej = player_a_przywrocenie[id]
	player_zaklecie[id] = przywr5
	if(Zaklecia_ma[id][player_zaklecie[id]]==0|| Zaklecia_umiej[player_zaklecie[id]]>umiej) player_zaklecie[id] = 0
}
public _przywr6(id)
{
	new umiej = player_a_przywrocenie[id]
	player_zaklecie[id] = przywr6
	if(Zaklecia_ma[id][player_zaklecie[id]]==0|| Zaklecia_umiej[player_zaklecie[id]]>umiej) player_zaklecie[id] = 0
}
//---
public _iluzja1(id)
{
	new umiej = player_a_iluzja[id]
	player_zaklecie[id] = iluzja1
	if(Zaklecia_ma[id][player_zaklecie[id]]==0|| Zaklecia_umiej[player_zaklecie[id]]>umiej) player_zaklecie[id] = 0
}
public _iluzja2(id)
{
	new umiej = player_a_iluzja[id]
	player_zaklecie[id] = iluzja2
	if(Zaklecia_ma[id][player_zaklecie[id]]==0|| Zaklecia_umiej[player_zaklecie[id]]>umiej) player_zaklecie[id] = 0
}
public _iluzja3(id)
{
	new umiej = player_a_iluzja[id]
	player_zaklecie[id] = iluzja3
	if(Zaklecia_ma[id][player_zaklecie[id]]==0|| Zaklecia_umiej[player_zaklecie[id]]>umiej) player_zaklecie[id] = 0
}
public _iluzja4(id)
{
	new umiej = player_a_iluzja[id]
	player_zaklecie[id] = iluzja4
	if(Zaklecia_ma[id][player_zaklecie[id]]==0|| Zaklecia_umiej[player_zaklecie[id]]>umiej) player_zaklecie[id] = 0
}
public _iluzja5(id)
{
	new umiej = player_a_iluzja[id]
	player_zaklecie[id] = iluzja5
	if(Zaklecia_ma[id][player_zaklecie[id]]==0|| Zaklecia_umiej[player_zaklecie[id]]>umiej) player_zaklecie[id] = 0
}
public _iluzja6(id)
{
	new umiej = player_a_iluzja[id]
	player_zaklecie[id] = iluzja6
	if(Zaklecia_ma[id][player_zaklecie[id]]==0|| Zaklecia_umiej[player_zaklecie[id]]>umiej) player_zaklecie[id] = 0
}
//---
public _przyw1(id)
{
	new umiej = player_a_przywolanie[id]
	player_zaklecie[id] = przyw1
	if(Zaklecia_ma[id][player_zaklecie[id]]==0|| Zaklecia_umiej[player_zaklecie[id]]>umiej) player_zaklecie[id] = 0
}
public _przyw2(id)
{
	new umiej = player_a_przywolanie[id]
	player_zaklecie[id] = przyw2
	if(Zaklecia_ma[id][player_zaklecie[id]]==0|| Zaklecia_umiej[player_zaklecie[id]]>umiej) player_zaklecie[id] = 0
}
public _przyw3(id)
{
	new umiej = player_a_przywolanie[id]
	player_zaklecie[id] = przyw3
	if(Zaklecia_ma[id][player_zaklecie[id]]==0|| Zaklecia_umiej[player_zaklecie[id]]>umiej) player_zaklecie[id] = 0
}
public _przyw4(id)
{
	new umiej = player_a_przywolanie[id]
	player_zaklecie[id] = przyw4
	if(Zaklecia_ma[id][player_zaklecie[id]]==0|| Zaklecia_umiej[player_zaklecie[id]]>umiej) player_zaklecie[id] = 0
}
public _przyw5(id)
{
	new umiej = player_a_przywolanie[id]
	player_zaklecie[id] = przyw5
	if(Zaklecia_ma[id][player_zaklecie[id]]==0|| Zaklecia_umiej[player_zaklecie[id]]>umiej) player_zaklecie[id] = 0
}
public _przyw6(id)
{
	new umiej = player_a_przywolanie[id]
	player_zaklecie[id] = przyw6
	if(Zaklecia_ma[id][player_zaklecie[id]]==0|| Zaklecia_umiej[player_zaklecie[id]]>umiej) player_zaklecie[id] = 0
}
//---
public _mis1(id)
{
	new umiej = player_a_mistycyzm[id]
	player_zaklecie[id] = mis1
	if(Zaklecia_ma[id][player_zaklecie[id]]==0|| Zaklecia_umiej[player_zaklecie[id]]>umiej) player_zaklecie[id] = 0
}
public _mis2(id)
{
	new umiej = player_a_mistycyzm[id]
	player_zaklecie[id] = mis2
	if(Zaklecia_ma[id][player_zaklecie[id]]==0|| Zaklecia_umiej[player_zaklecie[id]]>umiej) player_zaklecie[id] = 0
}
public _mis3(id)
{
	new umiej = player_a_mistycyzm[id]
	player_zaklecie[id] = mis3
	if(Zaklecia_ma[id][player_zaklecie[id]]==0|| Zaklecia_umiej[player_zaklecie[id]]>umiej) player_zaklecie[id] = 0
}
public _mis4(id)
{
	new umiej = player_a_mistycyzm[id]
	player_zaklecie[id] = mis4
	if(Zaklecia_ma[id][player_zaklecie[id]]==0|| Zaklecia_umiej[player_zaklecie[id]]>umiej) player_zaklecie[id] = 0
}
public _mis5(id)
{
	new umiej = player_a_mistycyzm[id]
	player_zaklecie[id] = mis5
	if(Zaklecia_ma[id][player_zaklecie[id]]==0|| Zaklecia_umiej[player_zaklecie[id]]>umiej) player_zaklecie[id] = 0
}
public _mis6(id)
{
	new umiej = player_a_mistycyzm[id]
	player_zaklecie[id] = mis6
	if(Zaklecia_ma[id][player_zaklecie[id]]==0|| Zaklecia_umiej[player_zaklecie[id]]>umiej) player_zaklecie[id] = 0
}
//---
public _przem1(id)
{
	new umiej = player_a_przemiana[id]
	player_zaklecie[id] = przem1
	if(Zaklecia_ma[id][player_zaklecie[id]]==0|| Zaklecia_umiej[player_zaklecie[id]]>umiej) player_zaklecie[id] = 0
}
public _przem2(id)
{
	new umiej = player_a_przemiana[id]
	player_zaklecie[id] = przem2
	if(Zaklecia_ma[id][player_zaklecie[id]]==0|| Zaklecia_umiej[player_zaklecie[id]]>umiej) player_zaklecie[id] = 0
}
public _przem3(id)
{
	new umiej = player_a_przemiana[id]
	player_zaklecie[id] = przem3
	if(Zaklecia_ma[id][player_zaklecie[id]]==0|| Zaklecia_umiej[player_zaklecie[id]]>umiej) player_zaklecie[id] = 0
}
public _przem4(id)
{
	new umiej = player_a_przemiana[id]
	player_zaklecie[id] = przem4
	if(Zaklecia_ma[id][player_zaklecie[id]]==0|| Zaklecia_umiej[player_zaklecie[id]]>umiej) player_zaklecie[id] = 0
}
public _przem5(id)
{
	new umiej = player_a_przemiana[id]
	player_zaklecie[id] = przem5
	if(Zaklecia_ma[id][player_zaklecie[id]]==0|| Zaklecia_umiej[player_zaklecie[id]]>umiej) player_zaklecie[id] = 0
}
public _przem6(id)
{
	new umiej = player_a_przemiana[id]
	player_zaklecie[id] = przem6
	if(Zaklecia_ma[id][player_zaklecie[id]]==0|| Zaklecia_umiej[player_zaklecie[id]]>umiej) player_zaklecie[id] = 0
}
//---
public _destr1(id)
{
	new umiej = player_a_zniszczenie[id]
	player_zaklecie[id] = destr1
	if(Zaklecia_ma[id][player_zaklecie[id]]==0|| Zaklecia_umiej[player_zaklecie[id]]>umiej) player_zaklecie[id] = 0
}
public _destr2(id)
{
	new umiej = player_a_zniszczenie[id]
	player_zaklecie[id] = destr2
	if(Zaklecia_ma[id][player_zaklecie[id]]==0|| Zaklecia_umiej[player_zaklecie[id]]>umiej) player_zaklecie[id] = 0
}
public _destr3(id)
{
	new umiej = player_a_zniszczenie[id]
	player_zaklecie[id] = destr3
	if(Zaklecia_ma[id][player_zaklecie[id]]==0|| Zaklecia_umiej[player_zaklecie[id]]>umiej) player_zaklecie[id] = 0
}
public _destr4(id)
{
	new umiej = player_a_zniszczenie[id]
	player_zaklecie[id] = destr4
	if(Zaklecia_ma[id][player_zaklecie[id]]==0|| Zaklecia_umiej[player_zaklecie[id]]>umiej) player_zaklecie[id] = 0
}
public _destr5(id)
{
	new umiej = player_a_zniszczenie[id]
	player_zaklecie[id] = destr5
	if(Zaklecia_ma[id][player_zaklecie[id]]==0|| Zaklecia_umiej[player_zaklecie[id]]>umiej) player_zaklecie[id] = 0
}
public _destr6(id)
{
	new umiej = player_a_zniszczenie[id]
	player_zaklecie[id] = destr6
	if(Zaklecia_ma[id][player_zaklecie[id]]==0|| Zaklecia_umiej[player_zaklecie[id]]>umiej) player_zaklecie[id] = 0
}
//---



public check_magic_fail(id,zakl){
	new play[32],num
	new pid = id
	get_players(play,num)
	if(num<8){
		pid=0
	}
	if(player_zaklecie[id]>=Luk && player_zaklecie[id]<=wieza){
		client_cmd(pid, "mp3 play %s", sounds_fail[specjalne-1] ) 
	}
	if(player_zaklecie[id]>=przywr1 && player_zaklecie[id]<=przywr6){
		client_cmd(pid, "mp3 play %s", sounds_fail[przywrocenia-1] ) 
	}
	if(player_zaklecie[id]>=iluzja1 && player_zaklecie[id]<=iluzja6){
		client_cmd(pid, "mp3 play %s", sounds_fail[iluzji-1] ) 
	}
	if(player_zaklecie[id]>=przyw1 && player_zaklecie[id]<=przyw6){
		client_cmd(pid, "mp3 play %s", sounds_fail[przywolania-1] ) 
	}
	if(player_zaklecie[id]>=mis1 && player_zaklecie[id]<=mis6){
		client_cmd(pid, "mp3 play %s", sounds_fail[mistycyzmu-1] ) 
	}
	if(player_zaklecie[id]>=przem1 && player_zaklecie[id]<=przem6){
		client_cmd(pid, "mp3 play %s", sounds_fail[przemiany-1] ) 
	}
	if(player_zaklecie[id]>=destr1 && player_zaklecie[id]<=destr6){
		client_cmd(pid, "mp3 play %s", sounds_fail[zniszczenia-1] ) 
	}
	set_task(5.0,"es",TASKID_MUSIC+id) 
	
}	
public check_magic_cast(id,zakl){
	new play[32],num
	new pid = id
	get_players(play,num)
	if(num<8){
		pid=0
	}
	if(player_zaklecie[id]==Luk ){
		client_cmd(pid, "mp3 play %s", sounds_hit[boweq] ) 
		Display_Fade(id,2600,2600,0,16,0,255,40)
	}
	
	if(player_zaklecie[id]>Luk && player_zaklecie[id]<=wieza){
		client_cmd(pid, "mp3 play %s", sounds_cast[specjalne-1] ) 
		Display_Fade(id,2600,2600,0,16,0,255,40)
	}
	if(player_zaklecie[id]>=przywr1 && player_zaklecie[id]<=przywr6){
		client_cmd(pid, "mp3 play %s", sounds_cast[przywrocenia-1] ) 
		Display_Fade(id,2600,2600,0,185,241,255,40)
	}
	if(player_zaklecie[id]>=iluzja1 && player_zaklecie[id]<=iluzja6){
		client_cmd(pid, "mp3 play %s", sounds_cast[iluzji-1] ) 
		Display_Fade(id,2600,2600,0,16,255,0,40)
	}
	if(player_zaklecie[id]>=przyw1 && player_zaklecie[id]<=przyw6){
		client_cmd(pid, "mp3 play %s", sounds_cast[przywolania-1] )
		Display_Fade(id,2600,2600,0,255,215,0,40)
	}
	if(player_zaklecie[id]>=mis1 && player_zaklecie[id]<=mis6){
		client_cmd(pid, "mp3 play %s", sounds_cast[mistycyzmu-1] ) 
		Display_Fade(id,2600,2600,0,198,0,255,40)
	}
	if(player_zaklecie[id]>=przem1 && player_zaklecie[id]<=przem6){
		client_cmd(pid, "mp3 play %s", sounds_cast[przemiany-1] ) 
		player_b_inv[id] += 50
		Display_Fade(id,2600,2600,0,255,255,255,40)
	}
	if(player_zaklecie[id]>=destr1 && player_zaklecie[id]<=destr6){
		player_b_inv[id] += 50
		client_cmd(pid, "mp3 play %s", sounds_cast[zniszczenia-1] ) 
		Display_Fade(id,2600,2600,0,255,0,0,40)
	}
	set_task(5.0,"es",TASKID_MUSIC+id) 
}

public check_magic(id)					//Redirect and check which items will be triggered
{
	if(dragon[id]==1) return PLUGIN_HANDLED
	if(player_zaklecie[id]<Luk || player_zaklecie[id] > destr6){
		return PLUGIN_HANDLED
	}
	

	if(player_zaklecie[id]==krew || player_zaklecie[id]==pocalunek || player_zaklecie[id]==waz || player_zaklecie[id]==cien || player_zaklecie[id]==wieza){
		if(player_b_inv_ilu2[id]<200 && player_b_inv_ilu2[id]!= 0){
			player_b_inv_ilu2[id] += 40
			set_renderchange(id)
		} 
		if(player_specjal_used[id] == 1){
			check_magic_fail(id,player_zaklecie[id])
			client_print(id,print_chat,"Czar zostal juz uzyty w tej rundzie!")
			return PLUGIN_HANDLED
		}
	}
	
	if(silence[id] == 1 && player_zaklecie[id]!=mis1){
		check_magic_fail(id,player_zaklecie[id])
		client_print(id,print_chat,"Nie mozesz rzucic czaru, jestes wyciszony!")
		return PLUGIN_HANDLED
	}
	
	if(0<= player_mp[id] - Zaklecia_mana[player_zaklecie[id]]){
		if(random_num(0,200-player_a_szczescie[id] && random_num(0,50))==0)
		{
			player_mp[id] = player_mp[id] - Zaklecia_mana[player_zaklecie[id]]/2
			set_hudmessage(0, 255, 0, -1.0, -1.0)
			show_hudmessage(id, "Masz szczescie! Zaklecie wymagalo mniej many!")
		}else{
			player_mp[id] = player_mp[id] - Zaklecia_mana[player_zaklecie[id]]
		}
	} else{
		client_print(id,print_chat,"Nie masz wystarczajaco duzo punktow many!")
		check_magic_fail(id,player_zaklecie[id])
		return PLUGIN_HANDLED
	}
	
	new param[1]
	param[0] = nr_rundy
	

	if(player_week_ogien[id] >0 &&player_week_mroz[id]>0 && player_week_shock[id]>0){
		week_magic[id] = ((player_week_ogien[id] + player_week_mroz[id] + player_week_shock[id])/3.0)/100.0
	}
	if(player_odpornosc_ogien[id] >0 &&player_odpornosc_mroz[id]>0 && player_odpornosc_shock[id]>0){
		odpornosc_magic[id] = ((player_odpornosc_ogien[id] + player_odpornosc_mroz[id] + player_odpornosc_shock[id])/3.0)/100.0
	}
	
	
	//done
	if(player_zaklecie[id]==Luk && paraliz[id]==0){
		client_cmd(id,"weapon_knife")
		engclient_cmd(id,"weapon_knife")
		on_knife[id]=1	
		get_bow(id)
	} 
	//done
	if(player_zaklecie[id]==krew){
		new hp = floatround(90 - random_num(0,40)*odpornosc_magic[id] + random_num(0,40)*week_magic[id])
		change_health(id,hp,id,"world")
		player_specjal_used[id] = 1
	}
	
	if(player_zaklecie[id]==pocalunek){
		if(player_sp[id]>=120){
			player_sp[id] = player_sp[id] -120
			player_specjal_used[id] = 1
			pocalunek_atk(id)
			
		}else{
			client_print(id,print_chat,"Nie masz wystarczajaco duzo punktow kondycji!")
		}
	}
	if(player_zaklecie[id]==waz){
		dispel(id)
		item_waztotem(id)
		change_health(id,20,id,"world")
		player_specjal_used[id] = 1
	}
	if(player_zaklecie[id]==cien){
		player_b_inv[id] = 6
		player_b_inv_ilu[id] = 6
		set_renderchange(id)
		set_task(6.0 - 5.0*odpornosc_magic[id] + 5.0*week_magic[id],"cien_off",id+500) 
		player_specjal_used[id] = 1
	}
	if(player_zaklecie[id]==wieza){
		player_b_ghost[id] = floatround(8 - 3*odpornosc_magic[id] + 3*week_magic[id])
		ghoststate[id] = 0 
		item_ghost(id)
		
	} 
	
	if(player_zaklecie[id]==przywr1){
		new hp = floatround(25 - 15*odpornosc_magic[id] + 15*week_magic[id])
		change_health(id,hp,id,"world")
		
	} 
	
	if(player_zaklecie[id]==przywr2){
		new mp = floatround(50 - 40*odpornosc_magic[id] + 40*week_magic[id])
		player_max_mp[id] += mp
		write_hud(id)
		
	} 
	
	if(player_zaklecie[id]==przywr3){
		new hp = floatround(75 - 65*odpornosc_magic[id] + 65*week_magic[id])
		change_health(id,hp,id,"world")
		
	} 
	
	if(player_zaklecie[id]==przywr4){
		new hp = floatround(100 - 90*odpornosc_magic[id] + 90*week_magic[id])
		player_max_hp[id] += hp
		write_hud(id)
		
	} 
	
	if(player_zaklecie[id]==przywr5){
		new hp = floatround(200 - 180*odpornosc_magic[id] + 180*week_magic[id])
		change_health(id,hp,id,"world")
		
	} 
	
	if(player_zaklecie[id]==iluzja1){
		player_b_inv_ilu[id] = 150
		remove_task(TASKID_ILU1+id)
		if(player_b_inv[id]==0 || player_b_inv[id] >150) player_b_inv[id] = 150
		set_renderchange(id)
		set_task(60.0,"ilu1_off",TASKID_ILU1+id,param[0]) 
	} 
	
	if(player_zaklecie[id]==iluzja2){
		player_b_inv_ilu[id] = 70
		remove_task(TASKID_ILU2+id)
		if(player_b_inv[id]==0 || player_b_inv[id] >70) player_b_inv[id] = 70
		set_renderchange(id)
		set_task(60.0,"ilu2_off",TASKID_ILU2+id,param[0]) 
	} 
	
	if(player_zaklecie[id]==iluzja3){
		remove_task(TASKID_KAM+id)
		changeskin(id,0)
		set_task(60.0,"kam_off",TASKID_KAM+id,param[0]) 
	} 
	
	if(player_zaklecie[id]==iluzja4){
		player_b_inv_ilu2[id] = 5
		set_renderchange(id)
	} 
		
	if(player_zaklecie[id]==iluzja5){
		remove_task(TASKID_ILU5+id)
		player_b_inv_ilu[id] = 5
		if(player_b_inv[id]==0 || player_b_inv[id] >5) player_b_inv[id] = 5
		set_renderchange(id)
		set_task(60.0,"ilu5_off",TASKID_ILU5+id,param[0]) 
	} 
	if(player_zaklecie[id]==przyw1){
		remove_task(TASKID_BOUND1+id)
		fm_give_item(id, "weapon_elites")
		give_item(id, "ammo_9mm")
		give_item(id, "ammo_9mm")
		give_item(id, "ammo_9mm")
		
		fm_give_item(id, "weapon_m3")
		give_item(id, "ammo_buckshot")
		give_item(id, "ammo_buckshot")
		give_item(id, "ammo_buckshot")	
		player_bound[id] = 1

		set_task(60.0,"bound1_off",id+TASKID_BOUND1,param[0]) 
	} 
	if(player_zaklecie[id]==przyw2){
		remove_task(TASKID_BOUND2+id)
		fm_give_item(id, "weapon_mp5navy")
		give_item(id, "ammo_9mm")
		give_item(id, "ammo_9mm")
		give_item(id, "ammo_9mm")
		
	
		player_bound[id] = 2
		set_task(60.0,"bound2_off",id+TASKID_BOUND2,param[0]) 
	} 
	if(player_zaklecie[id]==przyw3){
		remove_task(TASKID_BOUND3+id)
		fm_give_item(id, "weapon_p90")
		give_item(id, "ammo_57mm")
		give_item(id, "ammo_57mm")
		give_item(id, "ammo_57mm")
		
	
		player_bound[id] = 3
		set_task(60.0,"bound3_off",id+TASKID_BOUND3,param[0]) 
	} 
	if(player_zaklecie[id]==przyw4){
		remove_task(TASKID_BOUND4+id)
		fm_give_item(id, "weapon_m4a1")
		give_item(id, "ammo_556nato")
		give_item(id, "ammo_556nato")
		give_item(id, "ammo_556nato")
		
	
		player_bound[id] = 4
		set_task(60.0,"bound4_off",id+TASKID_BOUND4,param[0]) 
	} 
	if(player_zaklecie[id]==przyw5){
		remove_task(TASKID_BOUND5+id)
		fm_give_item(id, "weapon_ak47")
		give_item(id, "ammo_762nato")
		give_item(id, "ammo_762nato")
		give_item(id, "ammo_762nato")

		fm_give_item(id, "weapon_awp")
		give_item(id, "ammo_338magnum")
		give_item(id, "ammo_338magnum")
		give_item(id, "ammo_338magnum")
		
		player_bound[id] = 5
		set_task(60.0,"bound5_off",id+TASKID_BOUND5,param[0]) 
	} 
	if(player_zaklecie[id]==mis1){
		dispel(id)
	} 
	if(player_zaklecie[id]==mis2){
		remove_task(TASKID_DETECT+id)
		detect(id)
		player_detect[id]=1
		set_task(60.0,"detect_off",TASKID_DETECT+id,param[0]) 
	} 
	if(player_zaklecie[id]==mis3){
		remove_task(TASKID_ABSORB+id)
		player_absorb_mana[id] = 50
		if(player_znak[id]==Atronach) player_absorb_mana[id] = 100
		set_task(60.0,"absorb_off",TASKID_ABSORB+id,param[0]) 
	}
	if(player_zaklecie[id]==mis4){
		remove_task(TASKID_ODB1+id)
		player_odbij_mana[id] = 50
		set_task(60.0,"odbij_m_off",TASKID_ODB1+id,param[0]) 
	}
	if(player_zaklecie[id]==mis5){
		remove_task(TASKID_ODB2+id)
		player_odbij_zwykle[id] = 50
		set_task(30.0,"odbij_z_off",TASKID_ODB2+id,param[0]) 
	}
	if(player_zaklecie[id]==destr1){
		if(player_b_inv_ilu2[id]<200 && player_b_inv_ilu2[id]!= 0){
			player_b_inv_ilu2[id] += 40
			set_renderchange(id)
		} 
		command_flara(id)
	}
	if(player_zaklecie[id]==destr2){
		if(player_b_inv_ilu2[id]<200 && player_b_inv_ilu2[id]!= 0){
			player_b_inv_ilu2[id] += 40
			set_renderchange(id)
		} 
		dez(id)
	}
	if(player_zaklecie[id]==destr3){
		if(player_b_inv_ilu2[id]<200 && player_b_inv_ilu2[id]!= 0){
			player_b_inv_ilu2[id] += 40
			set_renderchange(id)
		} 
		podatnosc(id)
	}
	if(player_zaklecie[id]==destr4){
		if(player_b_inv_ilu2[id]<200 && player_b_inv_ilu2[id]!= 0){
			player_b_inv_ilu2[id] += 40
			set_renderchange(id)
		} 
		command_snow(id)
	}
	if(player_zaklecie[id]==destr5){
		if(player_b_inv_ilu2[id]<200 && player_b_inv_ilu2[id]!= 0){
			player_b_inv_ilu2[id] += 40
			set_renderchange(id)
		} 
		blysk_atk(id)
	}
	
	if(player_zaklecie[id]==destr6){
		if(player_b_inv_ilu2[id]<200 && player_b_inv_ilu2[id]!= 0){
			player_b_inv_ilu2[id] += 40
			set_renderchange(id)
		} 
		Effect_wybuch_Totem(id,3)
	}
	if(player_zaklecie[id]==przem1){
		if(player_b_inv_ilu2[id]<200 && player_b_inv_ilu2[id]!= 0){
			player_b_inv_ilu2[id] += 40
			set_renderchange(id)
		} 
		player_stop_poc[id] = 2
	}
	if(player_zaklecie[id]==przem2){
		if(player_b_inv_ilu2[id]<200 && player_b_inv_ilu2[id]!= 0){
			player_b_inv_ilu2[id] += 40
			set_renderchange(id)
		} 
		pocalunek_atk_v2(id)
	}
	if(player_zaklecie[id]==przem3){
		if(player_b_inv_ilu2[id]<200 && player_b_inv_ilu2[id]!= 0){
			player_b_inv_ilu2[id] += 40
			set_renderchange(id)
		} 
		silence_atk(id)
	}
	if(player_zaklecie[id]==przem4){
		if(player_b_inv_ilu2[id]<200 && player_b_inv_ilu2[id]!= 0){
			player_b_inv_ilu2[id] += 40
			set_renderchange(id)
		} 
		smal_obc_atk(id)
	}
	if(player_zaklecie[id]==przem5){
		if(player_b_inv_ilu2[id]<200 && player_b_inv_ilu2[id]!= 0){
			player_b_inv_ilu2[id] += 40
			set_renderchange(id)
		} 
		player_obc_poc[id] = 2
	}
	if(player_zaklecie[id]==przem6){
		if(player_b_inv_ilu2[id]<200 && player_b_inv_ilu2[id]!= 0){
			player_b_inv_ilu2[id] += 40
			set_renderchange(id)
		} 
		Effect_par_Totem(id,1)
	}

	
	check_magic_cast(id,player_zaklecie[id])
	return PLUGIN_HANDLED
}

public absorb_off(id,nr){
	if(nr!=nr_rundy) return PLUGIN_HANDLED
	id = id - TASKID_ABSORB
	player_absorb_mana[id] = 0
	if(player_znak[id]==Atronach) player_absorb_mana[id] = 50
	client_cmd(id, "mp3 play %s", sounds_hit[znika] ) 
	set_task(5.0,"es",TASKID_MUSIC+id) 
	return PLUGIN_HANDLED
}

public odbij_m_off(id,nr){
	if(nr!=nr_rundy) return PLUGIN_HANDLED
	id = id - TASKID_ODB1
	player_odbij_mana[id] = 0
	client_cmd(id, "mp3 play %s", sounds_hit[znika] ) 
	
	return PLUGIN_HANDLED
}
public odbij_z_off(id,nr){
	if(nr!=nr_rundy) return PLUGIN_HANDLED
	id = id - TASKID_ODB2
	player_odbij_zwykle[id] = 0
	client_cmd(id, "mp3 play %s", sounds_hit[znika] ) 
	set_task(5.0,"es",TASKID_MUSIC+id) 
	return PLUGIN_HANDLED
}
public detect_off(id,nr){
	id = id - TASKID_DETECT
	if(nr!=nr_rundy) return PLUGIN_HANDLED
	player_detect[id] = 0
	client_cmd(id, "mp3 play %s", sounds_hit[znika] ) 
	return PLUGIN_HANDLED
}
public bound5_off(id,nr){
	id = id - TASKID_BOUND5
	if(player_bound[id]<=5) player_bound[id] = 0
	new clip,ammo
	new weapon = get_user_weapon(id,clip,ammo)
	sprawdz_bronie(id,weapon)
	client_cmd(id, "mp3 play %s", sounds_hit[znika] ) 
	return PLUGIN_HANDLED
}
public bound4_off(id,nr){
	id = id - TASKID_BOUND4
	if(player_bound[id]<=4) player_bound[id] = 0
	new clip,ammo
	new weapon = get_user_weapon(id,clip,ammo)
	sprawdz_bronie(id,weapon)
	client_cmd(id, "mp3 play %s", sounds_hit[znika] ) 
	return PLUGIN_HANDLED
}
public bound3_off(id,nr){
	id = id - TASKID_BOUND3
	if(player_bound[id]<=3) player_bound[id] = 0
	new clip,ammo
	new weapon = get_user_weapon(id,clip,ammo)
	sprawdz_bronie(id,weapon)
	client_cmd(id, "mp3 play %s", sounds_hit[znika] ) 
	return PLUGIN_HANDLED
}
public bound2_off(id,nr){
	id = id - TASKID_BOUND2
	if(player_bound[id]<=2) player_bound[id] = 0
	new clip,ammo
	new weapon = get_user_weapon(id,clip,ammo)
	sprawdz_bronie(id,weapon)
	client_cmd(id, "mp3 play %s", sounds_hit[znika] ) 
	return PLUGIN_HANDLED
}
public bound1_off(id,nr){
	id = id - TASKID_BOUND1
	if(player_bound[id]<=1) player_bound[id] = 0
	new clip,ammo
	new weapon = get_user_weapon(id,clip,ammo)
	sprawdz_bronie(id,weapon)
	client_cmd(id, "mp3 play %s", sounds_hit[znika] ) 
	return PLUGIN_HANDLED
}
public kam_off(id,nr){
	if(nr!=nr_rundy) return PLUGIN_HANDLED
	id = id - TASKID_KAM
	changeskin(id,1)
	return PLUGIN_HANDLED
}
public cien_off(id){
	id = id - 500
	if(player_a_skradanie[id]==0) player_b_inv[id] = 255
	player_b_inv_ilu[id] = 255
	set_renderchange(id)
}
public ilu1_off(id,nr){
	if(nr!=nr_rundy) return PLUGIN_HANDLED
	id = id - TASKID_ILU1
	player_b_inv_ilu[id] = 255
	if(player_a_skradanie[id]==0) player_b_inv[id] = 255
	set_renderchange(id)
	return PLUGIN_HANDLED
}
public ilu2_off(id,nr){
	id = id - TASKID_ILU2
	if(nr!=nr_rundy || player_b_inv_ilu[id] > 80) return PLUGIN_HANDLED
	player_b_inv_ilu[id] = 255
	if(player_a_skradanie[id]==0) player_b_inv[id] = 255
	set_renderchange(id)
	return PLUGIN_HANDLED
}
public ilu5_off(id,nr){
	id = id - TASKID_ILU5
	if(nr!=nr_rundy || player_b_inv_ilu[id] > 10) return PLUGIN_HANDLED
	player_b_inv_ilu[id] = 255
	if(player_a_skradanie[id]==0) player_b_inv[id] = 255
	set_renderchange(id)
	return PLUGIN_HANDLED
}


public dispel(id)
{
	paraliz[id] = 0
	silence[id] = 0
	RemoveFlag(id,Flag_Ignite)
	RemoveFlag(id,Flag_truc)
	RemoveFlag(id,Flag_slow)
	set_task(0.1, "un_rander",TASK_FLASH_LIGHT+id)
	spowolnij[id] = 0
	obciaz[id] = 0
	smal_rozb[id] = 0
	RemoveFlag(id,Flag_slow)
	rozb[id] = 0
	set_speedchange(id)
	set_gravitychange(id)
}

public pocalunek_off(id){
	id = id - TASKID_CALUS
	paraliz[id] = 0
	RemoveFlag(id,Flag_slow)
	set_speedchange(id)
	set_gravitychange(id)
}


public pocalunek_atk(id){
	hudmsg(id,2.0,"Moc uzyta!")
	new target = UTIL_FindNearestOpponent(id,1800)
	if (target == -1) 
		return PLUGIN_HANDLED
			
	new Hit[3]
	get_user_origin(target,Hit)
	strumien(id, Hit[0], Hit[1], Hit[2], 255,0,0 )
	paraliz[target] = 1
	Effect_slow(target,id)
	paraliz_time[target] = floatround(halflife_time()) +10
	Display_Fade(target,2600,2600,0,255,0,0,40)
	set_task(10.0,"pocalunek_off",TASKID_CALUS+target) 
	client_cmd(target, "mp3 play %s", sounds_hit[magia] ) 
	return PLUGIN_HANDLED
}

public dez(id){
	hudmsg(id,2.0,"Moc uzyta!")
	new target = UTIL_FindNearestOpponent(id,1800)
	if (target == -1) 
		return PLUGIN_HANDLED	
	new Hit[3]
	get_user_origin(target,Hit)
	strumien(id, Hit[0], Hit[1], Hit[2], 255, 0,0 )
	Display_Fade(target,2600,2600,0,255,0,255,15)
	set_user_armor(target,0)
	
	player_b_inv_ilu[target] = 0
	changeskin(target,1)
	player_bound[target] = 0
	player_detect[target] = 0
	player_odbij_zwykle[target] = 0
	player_odbij_mana[target] = 0
	if(player_absorb_mana[target] == 100) player_absorb_mana[target] = 50
	
	client_cmd(target, "mp3 play %s", sounds_hit[magia] ) 
	return PLUGIN_HANDLED
}
public podatnosc(id){
	hudmsg(id,2.0,"Moc uzyta!")
	new target = UTIL_FindNearestOpponent(id,1800)
	if (target == -1) 
		return PLUGIN_HANDLED
			
	new Hit[3]
	get_user_origin(target,Hit)
	strumien(id, Hit[0], Hit[1], Hit[2], 255, 0,0 )
	player_week_ogien[target] += 25+player_a_zniszczenie[id]
	player_week_mroz[target]+= 25+player_a_zniszczenie[id]
	player_week_shock[target]+= 25+player_a_zniszczenie[id]
	
	player_odpornosc_ogien[target] -= 25+player_a_zniszczenie[id]
	player_odpornosc_mroz[target]-= 25+player_a_zniszczenie[id]
	player_odpornosc_shock[target]-= 25+player_a_zniszczenie[id]
	
	if(player_week_ogien[target] >100) player_week_ogien[target] =100
	if(player_week_mroz[target] >100) player_week_mroz[target] =100
	if(player_week_shock[target] >100) player_week_shock[target] =100
	
	if(player_odpornosc_ogien[target] <0) player_odpornosc_ogien[target] =0
	if(player_odpornosc_mroz[target] <0) player_odpornosc_mroz[target] =0
	if(player_odpornosc_shock[target] <0) player_odpornosc_shock[target] =0

	if(player_week_ogien[target] >0 &&player_week_mroz[target]>0 && player_week_shock[target]>0){
		week_magic[target] = ((player_week_ogien[target] + player_week_mroz[target] + player_week_shock[target])/3.0)/100.0
	}
	if(player_odpornosc_ogien[target] >0 &&player_odpornosc_mroz[target]>0 && player_odpornosc_shock[target]>0){
		odpornosc_magic[target] = ((player_odpornosc_ogien[target] + player_odpornosc_mroz[target] + player_odpornosc_shock[target])/3.0)/100.0
	}
	
	Display_Fade(target,2600,2600,0,255,0,255,15)

	client_cmd(target, "mp3 play %s", sounds_hit[magia] ) 
	return PLUGIN_HANDLED
}
public blysk_atk(id){
	
	new target = UTIL_FindNearestOpponent(id,1800)
	if (target == -1) {
		hudmsg(id,2.0,"Moc zmarnowana!")
		return PLUGIN_HANDLED
	}
		
		
	new hp = 75 + player_a_zniszczenie[id] / 2
	atak_shock(target,-hp,id)
		
	new Hit[3]
	get_user_origin(target,Hit)
	strumien(id, Hit[0], Hit[1], Hit[2], 255,  255, 255 )
	strumien(id, Hit[0], Hit[1], Hit[2], 255,  255, 255 )
	strumien(id, Hit[0], Hit[1], Hit[2], 255,  255, 255 )

	Display_Fade(target,2600,2600,0,255,0,255,15)
	return PLUGIN_HANDLED
}

//===============================================================================
public pocalunek_off_v2(id){
	if(is_user_connected(id))
	id = id - TASKID_CALUS2
	spowolnij[id] = 0
	RemoveFlag(id,Flag_slow)
	set_speedchange(id)
	set_gravitychange(id)
	set_gravitychange(id)
	set_speedchange(id)
}


public pocalunek_atk_v2(id){
	hudmsg(id,2.0,"Moc uzyta!")
	new target = UTIL_FindNearestOpponent(id,1800)
	if (target == -1) 
		return PLUGIN_HANDLED
			
	new Hit[3]
	get_user_origin(target,Hit)
	strumien(id, Hit[0], Hit[1], Hit[2], 255,0,0 )
	spowolnij[target] = 1
	spowolnij_time[target] = floatround(halflife_time()) +10
	Effect_slow(target,id)
	Display_Fade(target,2600,2600,0,255,0,0,40)
	set_task(10.0,"pocalunek_off_v2",TASKID_CALUS+target) 
	client_cmd(target, "mp3 play %s", sounds_hit[magia] ) 
	
	return PLUGIN_HANDLED
}
public silence_off(id){
	id = id - TASKID_SILENCE
	silence[id] = 0
	set_gravitychange(id)
	set_speedchange(id)
}


public silence_atk(id){
	hudmsg(id,2.0,"Moc uzyta!")
	new target = UTIL_FindNearestOpponent(id,1800)
	if (target == -1) 
		return PLUGIN_HANDLED
			
	new Hit[3]
	silence_give(target, 0)
	get_user_origin(target,Hit)
	strumien(id, Hit[0], Hit[1], Hit[2], 255,255,255 )
	client_cmd(target, "mp3 play %s", sounds_hit[magia] ) 
	return PLUGIN_HANDLED
}
public silence_give(target, t){
	if(t==0) t=10
	silence_time[target] = floatround(halflife_time()) +t
	silence[target] = 1
	Display_Fade(target,2600,2600,0,255,255,255,40)
	set_task(10.0,"silence_off",TASKID_SILENCE+target) 
	set_speedchange(target)
}

public smal_obc_off(id){
	id = id - TASKID_SO
	smal_rozb[id] = 0
	set_gravitychange(id)
	set_speedchange(id)
}


public smal_obc_atk(id){
	hudmsg(id,2.0,"Moc uzyta!")
	new target = UTIL_FindNearestOpponent(id,1800)
	if (target == -1) 
		return PLUGIN_HANDLED
			
	new Hit[3]
	get_user_origin(target,Hit)
	strumien(id, Hit[0], Hit[1], Hit[2], 255,255,255 )
	smal_rozb[target] = 1
	smal_rozb_time[target] = floatround(halflife_time()) +10
	Display_Fade(target,2600,2600,0,255,255,255,40)
	set_task(10.0,"smal_obc_off",TASKID_SO+target) 
	CurWeapon(target)
	client_cmd(target, "mp3 play %s", sounds_hit[magia] ) 
	set_speedchange(target)
	return PLUGIN_HANDLED
}
public obc_off(id){
	id = id - TASKID_O
	rozb[id] = 0
	set_gravitychange(id)
	set_speedchange(id)
}




	
stock Effect_par_Totem(id,seconds)
{
	new origin[3]
	pev(id,pev_origin,origin)
	
	new ent = Spawn_Ent("info_target")
	set_pev(ent,pev_classname,"Effect_par_Totem")
	set_pev(ent,pev_owner,id)
	set_pev(ent,pev_solid,SOLID_TRIGGER)
	set_pev(ent,pev_origin,origin)
	set_pev(ent,pev_ltime, halflife_time() + seconds + 0.1)
	
	engfunc(EngFunc_SetModel, ent, "addons/amxmodx/diablo/totem_ignite.mdl")  	
	set_rendering ( ent, kRenderFxGlowShell, 255,255,255, kRenderFxNone, 255 ) 	
	engfunc(EngFunc_DropToFloor,ent)
	
	set_pev(ent,pev_euser3,0)
	set_pev(ent,pev_nextthink, halflife_time() + 0.1)
}

public Effect_par_Totem_Think(ent)
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
		new numfound = find_sphere_class(ent,"player",900.0,entlist,512)
		
		for (new i=0; i < numfound; i++)
		{		
			new pid = entlist[i]
						
			if (!is_user_alive(pid) || get_user_team(id) == get_user_team(pid) ||   cs_get_user_team(pid) == CS_TEAM_SPECTATOR || pid == id )
				continue
				
			if (is_user_alive(pid)) {
				set_task(10.0,"pocalunek_off",TASKID_CALUS+pid) 
				
				paraliz[pid] = 1
				paraliz_time[pid] = floatround(halflife_time()) +5
				Effect_slow(pid,id)
				silence_give(pid, 5)
				client_cmd(pid, "mp3 play %s", sounds_hit[magia]) 
				set_speedchange(pid)
				CurWeapon(pid)
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
		write_coord( origin[1] +1000);
		write_coord( origin[2] +1000);
		write_short( sprite_white );
		write_byte( 0 ); // startframe
		write_byte( 0 ); // framerate
		write_byte( 10 ); // life
		write_byte( 10 ); // width
		write_byte( 255 ); // noise
		write_byte( 204); // r, g, b
		write_byte( 255 ); // r, g, b
		write_byte( 255 ); // r, g, b
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
stock Effect_detect_Totem(id,seconds)
{
	new origin[3]
	pev(id,pev_origin,origin)
	
	new ent = Spawn_Ent("info_target")
	set_pev(ent,pev_classname,"Effect_detect_Totem")
	set_pev(ent,pev_owner,id)
	set_pev(ent,pev_solid,SOLID_TRIGGER)
	set_pev(ent,pev_origin,origin)
	set_pev(ent,pev_ltime, halflife_time() + seconds + 0.1)
	
	engfunc(EngFunc_SetModel, ent, "addons/amxmodx/diablo/totem_ignite.mdl")  	
	set_rendering ( ent, kRenderFxGlowShell, 204,102,255, kRenderFxNone, 255 ) 	
	engfunc(EngFunc_DropToFloor,ent)
	
	set_pev(ent,pev_euser3,0)
	set_pev(ent,pev_nextthink, halflife_time() + 0.1)
}

public Effect_detect_Totem_Think(ent)
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
		new numfound = find_sphere_class(ent,"player",700.0,entlist,512)
		
		for (new i=0; i < numfound; i++)
		{		
			new pid = entlist[i]
						
			if (!is_user_alive(pid) || get_user_team(id) == get_user_team(pid) ||   cs_get_user_team(pid) == CS_TEAM_SPECTATOR || pid == id )
				continue
				
			if (is_user_alive(pid) && player_b_inv[pid] != 0 && player_b_inv[pid] != 255) {
				new index1 = pid
				if ((index1!=54) && (is_user_connected(index1))) set_user_rendering(index1,kRenderFxGlowShell,204,102,255,kRenderNormal,4)	
				remove_task(TASK_FLASH_LIGHT+index1);
				set_task(7.5, "un_rander",TASK_FLASH_LIGHT+index1)
				client_cmd(pid, "mp3 play %s", sounds_hit[magia]) 
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
		write_coord( origin[1] + 700);
		write_coord( origin[2] + 700);
		write_short( sprite_white );
		write_byte( 0 ); // startframe
		write_byte( 0 ); // framerate
		write_byte( 10 ); // life
		write_byte( 10 ); // width
		write_byte( 255 ); // noise
		write_byte( 204); // r, g, b
		write_byte( 105 ); // r, g, b
		write_byte( 255 ); // r, g, b
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

public item_waztotem(id)
{
	Effect_waz_Totem(id,2)	
}

stock Effect_waz_Totem(id,seconds)
{
	new origin[3]
	pev(id,pev_origin,origin)
	
	new ent = Spawn_Ent("info_target")
	set_pev(ent,pev_classname,"Effect_waz_Totem")
	set_pev(ent,pev_owner,id)
	set_pev(ent,pev_solid,SOLID_TRIGGER)
	set_pev(ent,pev_origin,origin)
	set_pev(ent,pev_ltime, halflife_time() + seconds + 0.1)
	
	engfunc(EngFunc_SetModel, ent, "addons/amxmodx/diablo/totem_ignite.mdl")  	
	set_rendering ( ent, kRenderFxGlowShell, 0,250,0, kRenderFxNone, 255 ) 	
	engfunc(EngFunc_DropToFloor,ent)
	
	set_pev(ent,pev_euser3,0)
	set_pev(ent,pev_nextthink, halflife_time() + 0.1)
}

public Effect_waz_Totem_Think(ent)
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
		new numfound = find_sphere_class(ent,"player",900.0,entlist,512)
		
		for (new i=0; i < numfound; i++)
		{		
			new pid = entlist[i]
						
			if (!is_user_alive(pid) || get_user_team(id) == get_user_team(pid) ||   cs_get_user_team(pid) == CS_TEAM_SPECTATOR || pid == id )
				continue
				

			Effect_waz(pid,id,4)
			hudmsg(pid,3.0,"Jestes zatruty!")
			client_cmd(pid, "mp3 play %s", sounds_hit[magia]) 
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
		write_coord( origin[1] + 900);
		write_coord( origin[2] + 900);
		write_short( sprite_white );
		write_byte( 0 ); // startframe
		write_byte( 0 ); // framerate
		write_byte( 10 ); // life
		write_byte( 10 ); // width
		write_byte( 255 ); // noise
		write_byte( 0); // r, g, b
		write_byte( 255 ); // r, g, b
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



stock Effect_waz(id,attacker,damage)
{
	new ent = Spawn_Ent("info_target")
	set_pev(ent,pev_classname,"Effect_waz")
	set_pev(ent,pev_owner,id)
	set_pev(ent,pev_ltime, halflife_time() + 99 + 0.1)
	set_pev(ent,pev_solid,SOLID_NOT)
	set_pev(ent,pev_euser1,attacker)
	set_pev(ent,pev_euser2,damage)
	set_pev(ent,pev_nextthink, halflife_time() + 0.1)	
	AddFlag(id,Flag_truc)
	g_FOV[id]=130;
	set_task(0.02,"efectV",id+33+MAXTASKC, "", 0, "b");
}

//euser3 = destroy and apply effect
public Effect_waz_Think(ent)
{
	new id = pev(ent,pev_owner)
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
	atak_truc(id,-damage,attacker)
	set_pev(ent,pev_nextthink, halflife_time() + 1.5)
	return PLUGIN_CONTINUE
}
public detect(id)
{
	Effect_detect_Totem(id,1)
	detect_do(id)
	/*
	for(new i=1;i<33;i++){
		if (!is_user_alive(i) || get_user_team(id) == get_user_team(i) ||   cs_get_user_team(i) == CS_TEAM_SPECTATOR || i == id )
			continue
				
		set_task(0.02,"efectV",i+33+MAXTASKC, "", 0, "b");
		g_FOV[i]=130;
	}
	*/
	
}
public efectV(id)
{
	new player=id-(33+MAXTASKC);
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
public detect_do(id)
{
	if(player_detect[id]==1){
		for(new pid=1;pid<33;pid++){
			if(get_user_team(pid)!=get_user_team(id) && player_b_inv[pid] != 0 && player_b_inv[pid] != 255){
				if(player_b_inv_ilu[pid]==5 && random_num(0,5)!=0) continue;
				new origin[3]
				get_user_origin(pid,origin)
				message_begin(MSG_ONE, SVC_TEMPENTITY, {0,0,0}, id)
				write_byte( TE_BEAMCYLINDER );
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
				write_byte( 204 ); // r, g, b
				write_byte( 102 ); // r, g, b
				write_byte( 255 ); // r, g, b
				write_byte( 128 ); // brightness
				write_byte( 5 ); // speed
				message_end();
			}
		}
	} 
}

public command_flara(id) 
{

	if(!is_user_alive(id)) return PLUGIN_HANDLED


	new Float: Origin[3], Float: Velocity[3], Float: vAngle[3], Ent

	entity_get_vector(id, EV_VEC_origin , Origin)
	entity_get_vector(id, EV_VEC_v_angle, vAngle)

	Ent = create_entity("info_target")

	if (!Ent) return PLUGIN_HANDLED

	entity_set_string(Ent, EV_SZ_classname, "flara")
	entity_set_model(Ent, kula)

	new Float:MinBox[3] = {-8.8, -8.8, -8.8}
	new Float:MaxBox[3] = {8.8, 8.8, 8.8}
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
	new Float:dmg = 25.0
	if(player_a_zniszczenie[id] >25) dmg += player_a_zniszczenie[id]*1.0
	entity_set_float(Ent, EV_FL_dmg,dmg)
	new speed = 540
	VelocityByAim(id, speed , Velocity)
	set_rendering (Ent,kRenderFxGlowShell, 255,0,0, kRenderNormal,56)
	entity_set_vector(Ent, EV_VEC_velocity ,Velocity)
	return PLUGIN_HANDLED
}
public toucharrow_flara(arrow, id)
{	
	new kid = entity_get_edict(arrow, EV_ENT_owner)
	new lid = entity_get_edict(arrow, EV_ENT_enemy)
	
	if(is_user_alive(id)) 
	{
		if(kid == id || lid == id) return
		
		entity_set_edict(arrow, EV_ENT_enemy,id)
	
		new Float:dmg = entity_get_float(arrow,EV_FL_dmg)
		entity_set_float(arrow,EV_FL_dmg,(dmg*3.0)/5.0)
		
		new Float:vec[3]
		entity_get_vector(arrow,EV_VEC_velocity,vec)
		if(vec[0]==0&&vec[1]==0&&vec[2]==0){
			remove_entity(arrow)
			return
		} 
		
		if(get_cvar_num("mp_friendlyfire") == 0 && get_user_team(id) == get_user_team(kid)) return
		
		Effect_Bleed(id,248)
		atak_ognia(id,floatround(-dmg),kid)


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
		write_short(sprite_fire4)
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
				atak_ognia(pid,floatround(-dmg),kid)
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
	new numfound = find_sphere_class(arrow,"player",80.0,entlist,512)
		
	for (new i=0; i < numfound; i++)
	{		
		new pid = entlist[i]
						
		if (!is_user_alive(pid) || get_user_team(kid) == get_user_team(pid) ||   cs_get_user_team(pid) == CS_TEAM_SPECTATOR || pid == kid )
			continue
				
		if (is_user_alive(pid)) {
			atak_ognia(pid,floatround(-dmg),kid)
		}
			
	}
	remove_entity(arrow)
}

public command_snow(id) 
{

	if(!is_user_alive(id)) return PLUGIN_HANDLED


	new Float: Origin[3], Float: Velocity[3], Float: vAngle[3], Ent

	entity_get_vector(id, EV_VEC_origin , Origin)
	entity_get_vector(id, EV_VEC_v_angle, vAngle)

	Ent = create_entity("info_target")

	if (!Ent) return PLUGIN_HANDLED

	entity_set_string(Ent, EV_SZ_classname, "snow")
	entity_set_model(Ent, kula)

	new Float:MinBox[3] = {-8.8, -8.8, -8.8}
	new Float:MaxBox[3] = {8.8, 8.8, 8.8}
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
	new Float:dmg = 25.0
	if(player_a_zniszczenie[id] >25) dmg += player_a_zniszczenie[id]*1.0
	entity_set_float(Ent, EV_FL_dmg,dmg)
	new speed = 650
	VelocityByAim(id, speed , Velocity)
	set_rendering (Ent,kRenderFxGlowShell, 50,50,255, kRenderNormal,56)
	entity_set_vector(Ent, EV_VEC_velocity ,Velocity)
	return PLUGIN_HANDLED
}
public toucharrow_snow(arrow, id)
{	
	new kid = entity_get_edict(arrow, EV_ENT_owner)
	new lid = entity_get_edict(arrow, EV_ENT_enemy)
	
	if(is_user_alive(id)) 
	{
		if(kid == id || lid == id) return
		
		entity_set_edict(arrow, EV_ENT_enemy,id)
	
		new Float:dmg = entity_get_float(arrow,EV_FL_dmg)
		entity_set_float(arrow,EV_FL_dmg,(dmg*3.0)/5.0)
		
		new Float:vec[3]
		entity_get_vector(arrow,EV_VEC_velocity,vec)
		if(vec[0]==0&&vec[1]==0&&vec[2]==0){
			remove_entity(arrow)
			return
		} 
		
		if(get_cvar_num("mp_friendlyfire") == 0 && get_user_team(id) == get_user_team(kid)) return
		
		Effect_Bleed(id,248)
		atak_mrozu(id,floatround(-dmg),kid)


		if(get_user_team(id) == get_user_team(kid)) 
		{
			new name[33]
			get_user_name(kid,name,32)
			client_print(0,print_chat,"%s attacked a teammate",name)
		}

		if(dmg<30) remove_entity(arrow)
		new Float:forigin[3], origin[3]
		pev(arrow,pev_origin,forigin)	
		FVecIVec(forigin,origin)
		message_begin( MSG_BROADCAST, SVC_TEMPENTITY, origin );
		write_byte( TE_BEAMCYLINDER );
		write_coord( origin[0] );
		write_coord( origin[1] );
		write_coord( origin[2] );
		write_coord( origin[0] );
		write_coord( origin[1] + 200);
		write_coord( origin[2] +200);
		write_short( sprite_white );
		write_byte( 0 ); // startframe
		write_byte( 0 ); // framerate
		write_byte( 10 ); // life
		write_byte( 10 ); // width
		write_byte( 255 ); // noise
		write_byte( 255); // r, g, b
		write_byte( 255 ); // r, g, b
		write_byte( 255 ); // r, g, b
		write_byte( 128 ); // brightness
		write_byte( 5 ); // speed
		message_end();
		
		client_cmd(0, "mp3 play %s", sounds_hit[frost] ) 
		new entlist[513]
		new numfound = find_sphere_class(id,"player",200.0,entlist,512)
			
		for (new i=0; i < numfound; i++)
		{		
			new pid = entlist[i]
							
			if (!is_user_alive(pid) || get_user_team(kid) == get_user_team(pid) ||   cs_get_user_team(pid) == CS_TEAM_SPECTATOR || pid == kid || pid == id)
				continue
					
			if (is_user_alive(pid)) {
				atak_mrozu(pid,floatround(-dmg),kid)
			}
				
		}
	}
}

public touchWorld2_snow(arrow, world)
{

	new Float:dmg = entity_get_float(arrow,EV_FL_dmg)
	new kid = entity_get_edict(arrow, EV_ENT_owner)
	
	new Float:forigin[3], origin[3]
	pev(arrow,pev_origin,forigin)	
	FVecIVec(forigin,origin)
	message_begin( MSG_BROADCAST, SVC_TEMPENTITY, origin );
	write_byte( TE_BEAMCYLINDER );
	write_coord( origin[0] );
	write_coord( origin[1] );
	write_coord( origin[2] );
	write_coord( origin[0] );
	write_coord( origin[1] + 200);
	write_coord( origin[2] +200);
	write_short( sprite_white );
	write_byte( 0 ); // startframe
	write_byte( 0 ); // framerate
	write_byte( 10 ); // life
	write_byte( 10 ); // width
	write_byte( 255 ); // noise
	write_byte( 255); // r, g, b
	write_byte( 255 ); // r, g, b
	write_byte( 255 ); // r, g, b
	write_byte( 128 ); // brightness
	write_byte( 5 ); // speed
	message_end();
	client_cmd(0, "mp3 play %s", sounds_hit[frost] ) 
	new entlist[513]
	new numfound = find_sphere_class(arrow,"player",200.0,entlist,512)
		
	for (new i=0; i < numfound; i++)
	{		
		new pid = entlist[i]
						
		if (!is_user_alive(pid) || get_user_team(kid) == get_user_team(pid) ||   cs_get_user_team(pid) == CS_TEAM_SPECTATOR || pid == kid )
			continue
				
		if (is_user_alive(pid)) {
			atak_mrozu(pid,floatround(-dmg),kid)
		}
			
	}
	remove_entity(arrow)
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
		new numfound = find_sphere_class(ent,"player",800.0,entlist,512)
		
		for (new i=0; i < numfound; i++)
		{		
			new pid = entlist[i]
						
			if (!is_user_alive(pid) || get_user_team(id) == get_user_team(pid) ||   cs_get_user_team(pid) == CS_TEAM_SPECTATOR || pid == id )
				continue
				
			if (is_user_alive(pid)) {
				
				Effect_Ignite(pid,id,4)
				atak_ognia(pid,-50,id)
								
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
		write_coord( origin2[1] + 800);
		write_coord( origin2[2] +800);
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
		write_coord(floatround(origin3[1])+300)
		write_coord(floatround(origin3[2]))
		write_short(sprite_fire3)
		write_byte(50)
		write_byte(15)
		write_byte(0)
		message_end()

		message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
		write_byte(3)
		write_coord(floatround(origin3[0]))
		write_coord(floatround(origin3[1])-300)
		write_coord(floatround(origin3[2]))
		write_short(sprite_fire4)
		write_byte(50)
		write_byte(15)
		write_byte(0)
		message_end()

		message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
		write_byte(3)
		write_coord(floatround(origin3[0])+300)
		write_coord(floatround(origin3[1]))
		write_coord(floatround(origin3[2]))
		write_short(sprite_fire4)
		write_byte(50)
		write_byte(15)
		write_byte(0)
		message_end()
		

		message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
		write_byte(3)
		write_coord(floatround(origin3[0])-300)
		write_coord(floatround(origin3[1]))
		write_coord(floatround(origin3[2]))
		write_short(sprite_fire4)
		write_byte(50)
		write_byte(15)
		write_byte(0)
		message_end()
		
		message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
		write_byte(3)
		write_coord(floatround(origin3[0])-300)
		write_coord(floatround(origin3[1])-300)
		write_coord(floatround(origin3[2]))
		write_short(sprite_fire3)
		write_byte(50)
		write_byte(15)
		write_byte(0)
		message_end()

		message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
		write_byte(3)
		write_coord(floatround(origin3[0])+300)
		write_coord(floatround(origin3[1])+300)
		write_coord(floatround(origin3[2]))
		write_short(sprite_fire3)
		write_byte(50)
		write_byte(15)
		write_byte(0)
		message_end()
		
		message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
		write_byte(3)
		write_coord(floatround(origin3[0])+300)
		write_coord(floatround(origin3[1])-300)
		write_coord(floatround(origin3[2]))
		write_short(sprite_fire3)
		write_byte(50)
		write_byte(15)
		write_byte(0)
		message_end()
		
		message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
		write_byte(3)
		write_coord(floatround(origin3[0])-300)
		write_coord(floatround(origin3[1])+300)
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

public poradnik(id)
{
	
	showitem(id,"PORADNIK SKYRIM MODA - Jesli jestes nowy koniecznie przeczytaj!<br>^n Na forum cs-lod.com.pl znajduje sie w dziale Poradniki Skyrim mod pelny opis moda! <br>",
	"Aby przeczytac opis klas, atrybutow, umiejetnosci, znakow zodiaku wpisz /menu <br>",
	"Wpisujac /menu mozesz takze kupic czar <br> Aby moc kupic czar musisz miec zloto oraz poziom umiejetnosci, np na czar flara musisz miec 1 poziom destrukcji <br> Aby wziac kusze wpisz /menu a nastepnie kliknij wejdz w magie, czary secjalne, przywolanie luku i kliknij wybierz do uzycia, teraz wybrany czar mozesz uzyc przyciskiem e ktory przywola luk <br>",
	"Po kupieniu czaru mozesz go wybrac do uzycia (pojawi sie jego nazwa po prawej) oraz uzyc PRZYCISKIEM E <br> Kazdy czar mozna zbindowac by szybko go uzywac, opis jest w /menu <br> Aby nigdy wiecej nie wyswietlic tego poradnika wpisz /pomocoff aby przeczytac go jeszcze raz wpisz /poradnik <br>")

	client_cmd(id, "mp3 play %s", sounds_hit[book_open] )
	return PLUGIN_HANDLED  
}

public reset_taski(id)
{
	remove_task(TASKID_BOUND5+id)
	remove_task(TASKID_BOUND4+id)
	remove_task(TASKID_BOUND3+id)
	remove_task(TASKID_BOUND2+id)
	remove_task(TASKID_BOUND1+id)
	
	remove_task(TASKID_DETECT+id)
	remove_task(TASKID_ODB1+id)
	remove_task(TASKID_ABSORB+id)
	remove_task(TASKID_ODB2+id)
	remove_task(TASKID_ILU1+id)
	remove_task(id+MAXTASKC);
	remove_task(TASKID_O+id)
	remove_task(TASKID_OBC+id)
	remove_task(TASKID_KAM+id)
	remove_task(TASKID_ILU5+id)
	remove_task(TASKID_ILU2+id)
	
	remove_task(TASKID_SO+id)
	remove_task(TASKID_CALUS+id)
	remove_task(TASKID_CALUS2+id)
	remove_task(TASKID_SILENCE+id)
	remove_task(TASKID_MUSIC+id)
	
}



public es(id)
{
	
	remove_task(TASKID_MUSIC+id) 
	id = id - TASKID_MUSIC
	client_cmd(id,"/s")
}

public check_blog(id)
{
	if(player_blogoslawienstwo[id] != 0){
		client_print(id,print_chat," %s blogoslawi Cie!",Blogoslawienstwa[player_blogoslawienstwo[id]] )
		
		switch(player_blogoslawienstwo[id]){
			case 1:{
				player_a_wytrzymalosc[id] += 10
				player_b_heal[id] = random_num(10,25)
				
				client_print(id,print_chat," Bonus 10 do wytrzymalosci, leczysz sie %i hp na 5 sekund!",player_b_heal[id] )
			}
			case 2:{
				player_a_ostrze[id] += 10
				player_b_theif[id] = random_num(20,250)
				client_print(id,print_chat," Bonus 10 do ostrzy, kradniesz %i kasy!",player_b_theif[id]  )
			}
			case 3:{
				player_a_sila_woli[id] += 30
				client_print(id,print_chat," Bonus 30 do sily woli" )
			}
			case 4:{
				player_a_inteligencja[id] += 30
				client_print(id,print_chat," Bonus 30 do inteligencji" )
			}
			case 5:{
				player_a_akrobatyka[id] += 30
				client_print(id,print_chat," Bonus 30 do akrobatyki" )
			}	
			case 6:{
				player_a_szczescie[id] += 30
				client_print(id,print_chat," Bonus 30 do szczescia" )
			}
			case 7:{
				player_a_sila[id] += 30
				client_print(id,print_chat," Bonus 30 do sily" )
			}
			case 8:{
				player_a_lekki_pancerz[id] += 25
				player_b_heal[id] = random_num(5,10)
				client_print(id,print_chat," Bonus 25 do lekkiego pancerzu, leczysz sie %i hp na 5 sekund!",player_b_heal[id])
			}
			case 9:{
				player_a_handel[id] += 10
				player_b_theif[id] = random_num(10,250)
				client_print(id,print_chat," Bonus 10 do handlu, kradniesz %i kasy!",player_b_theif[id] )
			}
			case 10:{
				player_a_skradanie[id] += 20
				player_b_theif[id] = random_num(1,50)
				client_print(id,print_chat," Bonus 20 do skradania sie, kradniesz %i kasy!",player_b_theif[id] )
			}
			case 11:{
				player_a_mistycyzm[id] += 10
				player_b_blind[id] =  3
				client_print(id,print_chat," Bonus 10 do mistycyzmu, mozesz oslepic przeciwnika strzalem" )
			}
			case 12:{
				player_a_iluzja[id] += 25
				player_b_respawn[id] = 1
				client_print(id,print_chat," Bonus 25 do iluzji, odradzasz sie!" )
			}
			case 13:{
				player_b_explode[id] = 200
				player_a_zniszczenie[id] += 10
				client_print(id,print_chat," Bonus 10 do zniszczenia, wybuchasz po smierci" )
				
			}
			
		}
	}
}


public daj_blog(id)
{
	player_blogoslawienstwo_nxt[id] = random_num(1,13)
	client_print(id,print_chat," %s zauwaza Twoje starania!",Blogoslawienstwa[player_blogoslawienstwo_nxt[id]] )
}
stock Effect_slow(id,attacker)
{
	new ent = Spawn_Ent("info_target")
	set_pev(ent,pev_classname,"Effect_slow")
	set_pev(ent,pev_owner,id)
	set_pev(ent,pev_ltime, halflife_time() + 99 + 0.1)
	set_pev(ent,pev_solid,SOLID_NOT)
	set_pev(ent,pev_euser1,attacker)
	set_pev(ent,pev_euser2,0)
	set_pev(ent,pev_nextthink, halflife_time() + 0.1)	
	AddFlag(id,Flag_slow)
}

//euser3 = destroy and apply effect
public Effect_slow_Think(ent)
{
	new id = pev(ent,pev_owner)
	attacker = pev(ent,pev_euser1)

	if (pev(ent,pev_ltime) < halflife_time() || !is_user_alive(id) || !HasFlag(id,Flag_slow))
	{
		RemoveFlag(id,Flag_slow)
		Remove_All_Tents(id)
		Display_Icon(id ,0 ,"dmg_heat" ,0,0,200)
		
		remove_entity(ent)		
		return PLUGIN_CONTINUE
	}
	
	//Display ignite tent and icon
	Display_Tent(id,sprite_ignite3,2)
	Display_Icon(id ,1 ,"dmg_heat" ,0,0,200)
	
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
	set_pev(ent,pev_nextthink, halflife_time() + 1.5)
	return PLUGIN_CONTINUE
}
public obciaz_off(id){
	id = id- TASKID_OBC
	RemoveFlag(id,Flag_slow)
	obciaz[id] = 0
	set_gravitychange(id)
	set_speedchange(id)
}

public no_c(id)
{
	no_cash[id]=0
}

public mikstura_daj(id)
{
	if(mikstura[id]>0) return PLUGIN_HANDLED
	new i = random_num(0,15)
	if(random_num(0,5)==0) i = random_num(0,27)
	if(random_num(0,25)==0) i = random_num(0,28)
	if(player_lvl[id]>50 && random_num(0,2)==0) i = 0;
	if(random_num(0,3)==0) i = 0;
	mikstura[id]  = i
	if(mikstura[id] != 0){
		client_print(id,print_chat,"Dostales miksture %s, aby ja uzyc kucnij, wez noz i wcisnij prawy przycisk myszy", Mikstura_n[mikstura[id]])
	}
	return PLUGIN_HANDLED
}
public mikstura_daj2(id)
{
	if(mikstura[id]>0) return PLUGIN_HANDLED
	new i = random_num(16,27)
	if(random_num(0,50)==0) i = random_num(16,28)
	mikstura[id]  = i
	if(mikstura[id] != 0){
		client_print(id,print_chat,"Dostales miksture %s, aby ja uzyc kucnij, wez noz i wcisnij prawy przycisk myszy", Mikstura_n[mikstura[id]])
	}
	return PLUGIN_HANDLED
}

public mikstura_check(id)
{
	if(mikstura[id]==0) return PLUGIN_HANDLED
	if(mikstura[id] > sizeof Mikstura_n){
		mikstura[id]=0
		return PLUGIN_HANDLED
	}
	switch (mikstura[id]){
		case 1:{
			player_odpornosc_shock[id] += 60
			if(player_odpornosc_shock[id]>100)player_odpornosc_shock[id]=100
		}
		case 2:{
			player_odpornosc_ogien[id] += 60
			if(player_odpornosc_ogien[id]>100)player_odpornosc_ogien[id]=100
		}
		case 3:{
			player_odpornosc_mroz[id] += 60
			if(player_odpornosc_mroz[id]>100)player_odpornosc_mroz[id]=100
		}
		case 4:{
			new param[1]
			param[0] = nr_rundy
			remove_task(TASKID_KAM+id)
			changeskin(id,0)
			set_task(15.0,"kam_off",TASKID_KAM+id,param[0]) 
		}
		case 5:{
			paraliz[id] = 0
			RemoveFlag(id,Flag_slow)
			set_speedchange(id)
			set_gravitychange(id)
		}
		case 6:{
			dispel(id)
		}
		case 7:{
			RemoveFlag(id,Flag_truc)
		}
		case 8:{
			player_a_sila[id] += 30
		}
		case 9:{
			player_max_hp[id] += 50
		}
		case 10:{
			player_max_sp[id] += 80
		}
		case 11:{
			player_max_mp[id] += 80
		}
		case 12:{
			change_health(id,45,id,"world")
		}
		case 13:{
			player_sp[id] += 100
		}
		case 14:{
			player_mp[id] += 100
		}
		case 15:{
			g_FOV[id]=100;
			set_task(0.02,"efectV",id+33+MAXTASKC, "", 0, "b");
			change_health(id,-5,id,"world")
			wamps[id] = 0
		}
		case 16:{
			player_odpornosc_shock[id] += 100
			if(player_odpornosc_shock[id]>100)player_odpornosc_shock[id]=100
		}
		case 17:{
			player_odpornosc_ogien[id] += 100
			if(player_odpornosc_ogien[id]>100)player_odpornosc_ogien[id]=100
		}
		case 18:{
			player_odpornosc_mroz[id] += 100
			if(player_odpornosc_mroz[id]>100)player_odpornosc_mroz[id]=100
		}
		case 19:{
			new param[1]
			param[0] = nr_rundy
			remove_task(TASKID_KAM+id)
			changeskin(id,0)
			set_task(25.0,"kam_off",TASKID_KAM+id,param[0]) 
		}
		case 20:{
			player_a_sila[id] += 60
		}
		case 21:{
			player_max_hp[id] += 80
		}
		case 22:{
			player_max_sp[id] += 100
		}
		case 23:{
			player_max_mp[id] += 100
		}
		case 24:{
			change_health(id,50,id,"world")
		}
		case 25:{
			player_sp[id] += 100
		}
		case 26:{
			player_mp[id] += 100
		}
		case 27:{
			new param[1]
			param[0] = nr_rundy
			remove_task(TASKID_DETECT+id)
			player_detect[id]=1
			set_task(60.0,"detect_off",TASKID_DETECT+id,param[0]) 
		}
		case 28:{
			g_FOV[id]=300;
			set_task(0.02,"efectV",id+33+MAXTASKC, "", 0, "b");
			player_a_szybkosc[id] += 50
			player_a_sila[id] += 25
			player_a_inteligencja[id] -= 50
			player_a_zwinnosc[id] -= 25
			if(player_a_szybkosc[id] >150) player_a_szybkosc[id]  =150
			if(player_a_sila[id] >150) player_a_sila[id]  =150
			if(player_a_inteligencja[id] < 0) player_a_inteligencja[id] = 0
			if(player_a_zwinnosc[id] < 0) player_a_zwinnosc[id] = 0
		}
		
		
		
		
		
		
		
	}
	if(player_sp[id] > player_max_sp[id] ) player_sp[id] = player_max_sp[id];
	if(player_mp[id] > player_max_mp[id] ) player_mp[id] = player_max_mp[id];
	mikstura[id]=0
	return PLUGIN_HANDLED
}

stock is_user_in_bad_zone( id ){
	if(is_user_in_plant_zone( id )) return true
	new entlist[513]
	new numfound = find_sphere_class(id,"player",300.0  ,entlist,512)
	for (new i=0; i < numfound; i++){
		new pid = entlist[i]
		
		if(is_user_in_plant_zone( pid )) return true	
	}
	
	new numfound2 = find_sphere_class(id,"weapon_c4",300.0  ,entlist,512)
	for (new i=0; i < numfound2; i++){
		return true
	}
	
	new numfound3 = find_sphere_class(id,"hostage_entity",300.0  ,entlist,512)
	for (new i=0; i < numfound3; i++){
		return true	
	}
	
	new numfound4 = find_sphere_class(id,"func_ladder",80.0  ,entlist,512)
	for (new i=0; i < numfound4; i++){
		return true	
	}
	

	return false
}
stock is_user_in_plant_zone( id )
{
    return (cs_get_user_mapzones(id) & CS_MAPZONE_BOMBTARGET)
}
public drop(id)
{
	mikstura[id]=0
}

public autobuy(id)
{
	player_autob[id]++;
	player_autob[id] = player_autob[id] % 2;
}
public dragonfme(id){
	if(get_user_flags(id) & ADMIN_LEVEL_H){
		isevent = 1
		new maxpl,players[32]
		get_players(players, maxpl) 
		new r = id
		drag(r)
	}
}
public drag(r){
		if(!is_user_alive(r)) return
		if(!is_user_connected(r)) return
		dragon[r]=1
		change_health(r,10000,0,"world")
		player_b_inv_ilu2[r] = 250
		player_b_inv_ilu[r] = 250
		
		Effect_wybuch_Totem(r,3)
		changeskin(r,1)
		count_jumps(r)
		set_speedchange(r)
		set_gravitychange(r)
		set_renderchange(r)
		CurWeapon(r)

}
public dragonf(id){
	if(get_user_flags(id) & ADMIN_LEVEL_H){
		isevent = 1
		new maxpl,players[32]
		get_players(players, maxpl) 
		new r = random_num(1, maxpl)
		drag(r)
	}
}

public znak2(id)
{
	
	if(player_lvl[id]< 50 && player_lvl[id]>20 ){
		player_znak[id]=0
		znak_tree(id) 
	} else if(player_znak[id]==0 && player_lvl[id]>20 ){
		
		znak_tree(id) 
	} 
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
	|| strlen(steamid) > 18
	|| (containi(steamid, "STEAM_0:1")<0 && containi(steamid, "STEAM_0:0")<0)
	)
		return 0
	
	return 1
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
	
	if(r == 1){
		client_cmd(id, "spk ^"weapons/boltdown.wav^"");
		//emit_sound(id,CHAN_VOICE,"weapons/boltdown.wav", 1.0, 0.1, 0, PITCH_NORM)
		return PLUGIN_HANDLED_MAIN
	}

	return PLUGIN_CONTINUE;
}
public xp_mnoznik_v(id)
{
	new itemEffect[500]
	add(itemEffect,499,"Masz")
	if(get_user_flags(id) & ADMIN_LEVEL_D || player_vip[id]==1){
		add(itemEffect,499," konto vip (+30 proc expa)")
	}
	else if(get_user_flags(id) & ADMIN_LEVEL_C || player_vip[id]==2){
		add(itemEffect,499," konto vip pro (+60 proc expa)")
	}
	if(u_sid[id] > 0){
		add(itemEffect,499," steam (+30 proc expa)")
	}else{
		client_print(id,print_chat, "Grajac na cs steam dostaniesz bonus 30 proc expa")
	}
	client_print(id,print_chat, itemEffect)
}

