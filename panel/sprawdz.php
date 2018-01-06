<?php
	session_start();
	include ("engine.php");
	
	function saveLogsLogowanie($dane, $user, $nick, $data)
	{                                         
		// zmienna $dane, kt??b?ie zapisana
		// mo? tak? pochodzi? formularza np. $dane = $_POST['dane'];
				
		// przypisanie zmniennej $file nazwy pliku
		$file = "logowanie/".date("m-y").".html";
		// uchwyt pliku, otwarcie do dopisania na pocz?ku pliku
		$fp = fopen($file, "a");
		// blokada pliku do zapisu
		flock($fp, 2);
		// zapisanie danych do pliku
		
		$bro = $_SERVER['HTTP_USER_AGENT'];
		
		fwrite($fp, date("d-m-y H:i:s" ). ' ' .$user.' o nicku '.$nick. ': '. $dane.', IP:' . $_SERVER['REMOTE_ADDR'].', Konto utworzono: '. $data  . ' ' . 
		' przegladarka: ' .  $bro . ' <br>');
		// odblokowanie pliku
		flock($fp, 3);
		// zamkni?e pliku
		fclose($fp);         
	}

	$user = $_POST['login'];
	$query = mysql_query("SELECT * FROM uzytkownicy WHERE `user` = '$user' ");
	$fetch = mysql_fetch_array($query);
	if ( $fetch && isset($_POST['login']) && $_POST['login']!='') // jesli user zostanie znaleziony w bazie
	{
		$tt_n = $fetch['nick'];
		if (  md5( $_POST['password'])  == $fetch['pass'] && isset($_POST['password']) && $_POST['password']!='') // jesli haslo sie zgadza
		{			
			check_id($fetch['ide']);
			// $srn_sql_conn = @mysql_connect($dbhost , "149260", "6s90f");
			// mysql_select_db("149260_rezerwacje",$srn_sql_conn);  
			// if(!$srn_sql_conn){
				// echo '<script type="text/javascript">alert("Uwaga! Brak polaczenia z baza danych! Sproboj ponownie za jakis czas");</script><META HTTP-EQUIV=Refresh CONTENT="0; URL=http://www.cs-lod.com.pl">';
			// }        
			
			// $StrquerySRN = "SELECT `nick` from `srn_reservations` where `nick`='$tt_n' ";//
			// $querySRN = mysql_query($StrquerySRN);
			// $fetchSRN = mysql_fetch_array($querySRN);
			$data = $fetch['registerData'];
			//echo $StrquerySRN;
			/*
			if($fetchSRN){
				$_SESSION["$cookiesVar"] = $user;
				saveLogsLogowanie("Logowanie: ZALOGOWANY", $user, $tt_n, $data);
				echo '<META HTTP-EQUIV=Refresh CONTENT="0; URL=index.php?info=logok">';
			}else{
				saveLogsLogowanie("Logowanie: blad brak SRN", $user, $tt_n, $data);
				echo '<META HTTP-EQUIV=Refresh CONTENT="0; URL=index.php?err=nosrn">';
			}	
			*/
			$_SESSION["$cookiesVar"] = $user;
			saveLogsLogowanie("Logowanie: ZALOGOWANY", $user, $tt_n, $data);
			echo '<META HTTP-EQUIV=Refresh CONTENT="0; URL=index.php?info=logok">';

		}
		else
		{
			saveLogsLogowanie("Logowanie: blad zle haslo", $user, $tt_n, $data);
			echo '<META HTTP-EQUIV=Refresh CONTENT="0; URL=index.php?err=wrongpass">';
		}
	}
	else
	{
		echo '<META HTTP-EQUIV=Refresh CONTENT="0; URL=index.php?err=nouser">';
	}


	function check_id($id){
		$now = $id;
        $sql = mysql_query("SELECT * from `uzytkownicy` WHERE `ide`='$now' ");
		$ok = 0;
        while ( $row = mysql_fetch_array($sql) )
		{
			$ok = 1;
            $t_dzis = strtotime("- 0 days",time());
            $t_user = $row['user'];
			$t_pass = $row['pass'];
			$t_nick = $row['nick'];
			$t_pkt = $row['pkt'];
			$t_vip = $row['vip'];
			$t_vip_data = $row['vip_data'];
			$t_vip_data_c = date("d.m.Y",$t_vip_data);
			$t_slot_data = $row['slot_data'];
			$t_slot_data_c = date("d.m.Y",$t_slot_data);
			$t_haslo = $row['haslo'];
										 
			if($t_dzis > $t_vip_data && $t_vip_data!= NULL && $t_vip_data!= 0 ){
				$t_vip_data = NULL;
				$t_vip = 0;
				saveLogs(' koniec vipa  ', $t_user, $t_nick); 
				//echo "UPDATE `dbmod_tablet` set `vip`='0' WHERE `nick`='$t_nick' and `klasa`='1' ";
				mysql_query("UPDATE `dbmod_tablet` set `vip`='0' WHERE `nick`='$t_nick' and `klasa`='1' ");
				mysql_query("UPDATE `uzytkownicy` set `vip`='0', `vip_data`=NULL WHERE `user`='$t_user' ");
			} else {					

				if($t_vip==1)mysql_query("UPDATE `$dbname`.`$dbtable` set `vip`='1' WHERE `nick`='$t_nick' and `klasa`='1' ");
				if($t_vip==2)mysql_query("UPDATE `$dbname`.`$dbtable` set `vip`='2' WHERE `nick`='$t_nick' and `klasa`='1' ");
			}         
		}
		return $ok;
	}
	

	mysql_close($sql_conn);
?> 



