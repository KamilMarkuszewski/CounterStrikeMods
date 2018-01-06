

		<link type="text/css" href="design/css/ui-lightness/jquery-ui-1.8.23.custom.css" rel="stylesheet" />
		<script type="text/javascript" src="design/js/jquery-1.8.0.min.js"></script>
		<script type="text/javascript" src="design/js/jquery-ui-1.8.23.custom.min.js"></script>
		



<?php
	if(isset($_POST['kod'])){
		$kkod = $_POST['kod'];

		$tmp_pkt =  $pkt;
	
		$dbuser_k       = "111039"; 
		$dbpassword_k   = "3swb8n";
		$dbname_k       = "111039_baza";
		$dbhost_k       = "sql.pukawka.pl";
		
        $sql_conn_k = @mysql_connect($dbhost_k , $dbuser_k, $dbpassword_k);
		if(!$sql_conn_k){
			echo '<script language="JavaScript" type="text/javascript" >	$(document).ready(function() { insertError("Brak połączniea, spróbuj później."); });</script>';
		}else{
			@mysql_select_db($dbname_k,$sql_conn_k);  
			$query1 = mysql_query("SELECT * FROM kody WHERE `kod`='$kkod' ");
			while($fetch1 = mysql_fetch_array($query1)){

				$kstan = $fetch1['stan'];
				$kkwota = $fetch1['kwota'];
				if($kstan==2){
					echo '<script language="JavaScript" type="text/javascript" >	$(document).ready(function() { insertError("Kod został już wykorzystany! "); });</script>';
				}
				if($kstan==0){
					echo '<script language="JavaScript" type="text/javascript" >	$(document).ready(function() { insertError("Coś poszło nie tak. Zgłoś się z kodem do administratora. "); });</script>';
				}
				if($kstan==1){
					if($kkwota == 5 || $kkwota == 20 || $kkwota == 50){
						if($kkwota == 50){
							if($bonus_code_used==0){
								$kkwota = floor($kkwota / 2);
								$bonus_code_used++;
								$tmp_pkt = $tmp_pkt + $kkwota;
								echo '<script language="JavaScript" type="text/javascript" >	$(document).ready(function() { insertInfo("Otrzymałeś punkty! "); });</script>';
								saveLogs(' uzyl Promocyjnego '.$kkwota.' pkt '. $kkod . ' ', $user, $nick);
								$kstan==2;
								$query = mysql_query("UPDATE `kody` SET `stan`=2 WHERE `kod`='$kkod' ");
							}else{
								echo '<script language="JavaScript" type="text/javascript" >	$(document).ready(function() { insertError("Masz tu konto od dawna, lub uzywales juz kodu promocyjnego! "); });</script>';
							}
						}else{
							if($bonus_code_used==0){
								$kkwota = floor($kkwota / 2);
								$bonus_code_used++;
								$tmp_pkt = $tmp_pkt + $kkwota;
								echo '<script language="JavaScript" type="text/javascript" >	$(document).ready(function() { insertInfo("Otrzymałeś punkty! "); });</script>';
								saveLogs(' uzyl Promocyjnego '.$kkwota.' pkt '. $kkod . ' ', $user, $nick);
								$kstan==2;
								$query = mysql_query("UPDATE `kody` SET `stan`=2 WHERE `kod`='$kkod' ");
							}else{
								echo '<script language="JavaScript" type="text/javascript" >	$(document).ready(function() { insertError("Masz tu konto od dawna, lub uzywales juz kodu promocyjnego! "); });</script>';
							}
						}
					
						
					}else{
						echo '<script language="JavaScript" type="text/javascript" >	$(document).ready(function() { insertError("Zła kwota kodu, zgłoś się do administratora. "); });</script>';
					}
					
					
				}
			
				
			}
			
			$sql_conn = mysql_connect($dbhost , $dbuser, $dbpassword);
			mysql_select_db($dbname,$sql_conn);    
			
			mysql_query("UPDATE `uzytkownicy` set `pkt`='$tmp_pkt',`bonus_code_used`='$bonus_code_used',`bonus_code`='$bonus_code'  WHERE `ide`='$myid' ");
		
		}
	
	}



	echo 'Tutaj możesz doładować punkty za pomocą kodów promocyjnych. <br><br><br>';


    echo '<form method="post" action="index.php?page=promocyjne">';
    echo 'Kod promocyjny: <input type="text" name="kod" />';
    echo '<input type="submit" value="Wyślij" />';

    echo '<br><br><br><br><br><br><br><br><br><br><br><br>';
				
	echo 'Wysyłając kod akceptujesz <a href="http://www.cs-lod.com.pl/system/regulamin.html">Regulamin panelu</a><br><br>';
?>
