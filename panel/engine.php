<?php
	require( "dane.php" );	
	$sql_conn = @mysql_connect($dbhost , $dbuser, $dbpassword);
	if(!$sql_conn){
		echo '<script type="text/javascript">alert("Uwaga! Brak polaczenia z baza danych! Sproboj ponownie za jakis czas");</script><META HTTP-EQUIV=Refresh CONTENT="0; URL=http://www.cs-lod.com.pl">';
	}
	@mysql_select_db($dbname,$sql_conn);        
	$dbtable         = "dbmod_tablet";
	ob_flush();

	$logged = null;
	$stats = false;
	$page = $_GET['page'];
	
	if($page == "stats"){
		$stats = true;
	}

	$resources = simplexml_load_file( "http://cs-lod.com.pl/system/resources/sklep.xml" );
	if(isset($_SESSION["$cookiesVar"])){
		session_name("$cookiesVar");
		session_register("$cookiesVar");
		session_start();
		$logged = $_SESSION["$cookiesVar"];
		$user = $logged;
		
		/*
		$myid =mysql_result(mysql_query("SELECT `ide` from `uzytkownicy` where `user`='$user'"),ide);
		$pkt =mysql_result(mysql_query("SELECT `pkt` from `uzytkownicy` where `ide`='$myid'"),pkt);		
		$passKonto =mysql_result(mysql_query("SELECT `pass` from `uzytkownicy` where `ide`='$myid'"),pass);
		$nick =mysql_result(mysql_query("SELECT `nick` from `uzytkownicy` where `ide`='$myid'"),nick);
		$vip =mysql_result(mysql_query("SELECT `vip` from `uzytkownicy` where `ide`='$myid'"),vip);
		$vip_data =mysql_result(mysql_query("SELECT `vip_data` from `uzytkownicy` where `ide`='$myid'"),vip_data);
		$slot_data =mysql_result(mysql_query("SELECT `slot_data` from `uzytkownicy` where `ide`='$myid'"),slot_data);
		$haslo =mysql_result(mysql_query("SELECT `haslo` from `uzytkownicy` where `ide`='$myid'"),haslo);
		$rekl =mysql_result(mysql_query("SELECT `rekl` from `uzytkownicy` where `ide`='$myid'"),rekl);
		$mail =mysql_result(mysql_query("SELECT `email` from `uzytkownicy` where `ide`='$myid'"),email);
		$sidFIRST =mysql_result(mysql_query("SELECT `FIRST_SID` from `uzytkownicy` where `ide`='$myid'"),FIRST_SID);
		$prezentowe =mysql_result(mysql_query("SELECT `prezentowe` from `uzytkownicy` where `ide`='$myid'"),prezentowe);		
		$bonus_code_used =mysql_result(mysql_query("SELECT `bonus_code_used` from `uzytkownicy` where `ide`='$myid'"),bonus_code_used);
		$bonus_code =mysql_result(mysql_query("SELECT `bonus_code` from `uzytkownicy` where `ide`='$myid'"),bonus_code);		
		$monthly_limit =mysql_result(mysql_query("SELECT `monthly_limit` from `uzytkownicy` where `ide`='$myid'"),monthly_limit);
		$last_purchase	 =mysql_result(mysql_query("SELECT `last_purchase` from `uzytkownicy` where `ide`='$myid'"),last_purchase);		
		$buyban	 =mysql_result(mysql_query("SELECT `buyban` from `uzytkownicy` where `ide`='$myid'"),buyban);	
		*/
		
		$wynik = mysql_query("SELECT `ide`, `pkt`, `pass`, `nick`, `vip`, `vip_data`, `slot_data`, `haslo`, `rekl`, `email`, `FIRST_SID`, `prezentowe`, `bonus_code_used`, `bonus_code`, `monthly_limit`, `last_purchase`, `buyban` from `uzytkownicy` where `user`='$user'");
		$result = mysql_fetch_array($wynik);
		
		$myid = $result['ide'];
		$pkt = $result['pkt'];
		$passKonto = $result['pass'];
		$nick  = $result['nick'];
		$vip = $result['vip'];
		$vip_data = $result['vip_data'];
		$slot_data = $result['slot_data'];
		$haslo  = $result['haslo'];
		$rekl  = $result['rekl'];
		$mail  = $result['email'];
		$sidFIRST = $result['FIRST_SID'];
		$prezentowe = $result['prezentowe'];		
		$bonus_code_used = $result['bonus_code_used'];
		$bonus_code = $result['bonus_code'];
		$monthly_limit = $result['monthly_limit'];
		$last_purchase = $result['last_purchase'];	
		$buyban	 = $result['buyban'];	
		
		$sid =mysql_result(mysql_query("SELECT `SID_PASS` from `dbmod_tablet` where `nick`='$nick' AND `klasa`= '1'"),SID_PASS);		
		$maxVipLvl = mysql_result(mysql_query("SELECT max(`lvl`) as max FROM `dbmod_tablet` WHERE `nick`='$nick' AND (`klasa` in ('16','18','13')) AND `blocked` = 0"),max);
		
		$dzis = strtotime("- 0 days",time());
		$miesiac_temu = strtotime("- 1 month",time());
		$today = date("d-m-Y",$dzis);
		$miesiac_temu_d = date("Y-m-d",$miesiac_temu);
		if($miesiac_temu_d > $last_purchase) $monthly_limit = 0;
		
		$user = stripslashes($user);
		$nick = stripslashes($nick);
		$rekl = stripslashes($rekl);
		
	}
		
	function saveLogs($dane, $user, $nick)
	{                                         
		// zmienna $dane, kt󲡠b륺ie zapisana
		// moࠥ takࠥ pochodzi桺 formularza np. $dane = $_POST['dane'];
		
		// przypisanie zmniennej $file nazwy pliku
		$file = "logi/".date("m-y").".html";
		// uchwyt pliku, otwarcie do dopisania na poczڴku pliku
		$fp = fopen($file, "a");
		// blokada pliku do zapisu
		flock($fp, 2);
		// zapisanie danych do pliku
		fwrite($fp, date("d-m-y H:i:s" ). ' ' .$user.' o nicku '.$nick. ': '. $dane.' <br>\n');
		// odblokowanie pliku
		flock($fp, 3);
		// zamkni뤩e pliku
		fclose($fp);         
	} 
	
	include ("checkAction.php");

	if(isset($_GET['err']) || isset($err)){
		
		if(!isset($err)){
			$err = $_GET['err'];
		} else{
			$error = $err;
		}
		
		switch($err){
			case "wrongpass":
				$error = "Podane hasło jest błędne";
				break;
			case "wrongpassSRN":
				$error = "Podane hasło rezerwacji nicku jest błędne";
				break;
			case "nouser":
				$error = "Podany uzytkownik nie istnieje w bazie danych";
				break;
			case "isuser":
				$error = "Podany uzytkownik już istnieje w bazie danych";
				break;
			case "shouldlog":
				$error = "Musisz być zalogowany aby wejśc w ten obszar strony";
				break;
			case "dontlog":
				$error = "Nie możesz się zarejestrować gdy jesteś zalogowany!";
				break;
			case "pp":
				$error = "Błędny nick polecającego";
				break;
			case "isnick":
				$error = "Istnieje juz konto z takim nickiem";
				break;
			case "nosrn":
				$error = "Ten nick NIE jest zarezerwowany. Rezerwacja jest wymagana. Wejdz do gry i wpisz /srn";
				break;
		}
	}

	if(isset($_GET['info']) || isset($info) ){
		if(!isset($info)) $info = $_GET['info'];
		
		switch($info){
			case "logok":
				$info = "Logowanie zakonczone sukcesem";
				break;
			case "rej":
				$info = "Rejestracja zakonczona sukcesem";
				break;
			case "passchanged":
				$info = "Zmiana hasła zakonczona sukcesem";
				break;
			case "sidchanged":
				$info = "Zmiana Steam ID zakonczona sukcesem";
				break;
			case "mailchanged":
				$info = "Zmiana e-maila zakonczona sukcesem";
				break;
		}
	}
		
	
	



?>