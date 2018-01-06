<?php	
		require( "engine.php" );
        $user = $_POST['userFinal']; 
        $pass = $_POST['passFinal']; 
        $rekl = $_POST['reklFinal']; 
        $nick = $_POST['nickFinal']; 
        $mail = $_POST['eMail']; 
		
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

		 
      
        $query = mysql_query("SELECT * FROM uzytkownicy WHERE `user` = '$user' ");
        $fetch = mysql_fetch_array($query);
        if ( !$fetch ) // jesli user NIE zostanie znaleziony w bazie
        {
        	$query2 = mysql_query("SELECT * FROM uzytkownicy WHERE `user` = '$rekl' ");
        	$fetch2 = mysql_fetch_array($query2);
        	if($fetch2 || $rekl == NULL){
				//isNickSamePerson($nick, $rekl);
			
                $query3 = mysql_query("SELECT * FROM uzytkownicy WHERE `nick` = '$nick' ");
                $fetch3 = mysql_fetch_array($query3);
                if(! $fetch3){
					$query_lvl = mysql_query("SELECT * FROM dbmod_tablet WHERE `nick` = '$nick' AND  lvl > 50");
					$bonus = 0;
					$fetch_lvl = mysql_fetch_array($query_lvl);
					if($fetch_lvl){
						$bonus = 1;
					}

					$max_lvl =mysql_result(mysql_query("SELECT lvl from `dbmod_tablet` where `nick`='$nick' order by lvl desc LIMIT 1"),lvl);
					$max_lvl = floor($max_lvl /50) *50;
					
                    $result= mysql_query("insert into uzytkownicy(user, pass, nick, pkt, vip, vip_data, slot_data, haslo, rekl, email, bonus_code_used, lvl_for_points, lvl_for_points_start) values ('$user', md5('$pass'),'$nick',5,0,NULL,NULL,NULL,'$rekl', '$mail', '$bonus', '$max_lvl', '$max_lvl')");
					
					saveLogsLogowanie("Rejestracja: UTWORZONO KONTO", $user, $nick, "teraz");
					
					echo '<META HTTP-EQUIV=Refresh CONTENT="0; URL=index.php?info=rej">';
                }else{
                    echo '<META HTTP-EQUIV=Refresh CONTENT="0; URL=index.php?err=isnick">';
                }
        	}
        	else{
        		echo '<META HTTP-EQUIV=Refresh CONTENT="0; URL=index.php?err=pp">';
        	}

        } 
        else
        {
                echo '<META HTTP-EQUIV=Refresh CONTENT="0; URL=index.php?err=isuser">';
        }
        mysql_close($sql_conn);


?>