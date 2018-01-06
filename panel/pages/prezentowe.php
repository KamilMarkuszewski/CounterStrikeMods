<link type="text/css" href="design/css/ui-lightness/jquery-ui-1.8.23.custom.css" rel="stylesheet" />
<script type="text/javascript" src="design/js/jquery-1.8.0.min.js"></script>
<script type="text/javascript" src="design/js/jquery-ui-1.8.23.custom.min.js"></script>

<script type="text/javascript">
			$(function(){

				// Accordion
				$("#accordion").accordion({ 
					heightStyle: "content",
					header: "h3",
					collapsible: true,
					active: false				
				});

				//hover states on the static widgets
				$('#dialog_link, ul#icons li').hover(
					function() { $(this).addClass('ui-state-hover'); },
					function() { $(this).removeClass('ui-state-hover'); }
				);

			});
		</script><?php
		
	function sendmail($mail, $tresc){
		$from = "cslod@cs-lod.com.pl";
		$headers = 	"From: ".$from." \nContent-Type:".
			' text/plain;charset="utf-8"'.
			"\nContent-Transfer-Encoding: 8bit";
	
		$title = "CS-LOD Zamówienie prezentowe";
	
		mail("kajt_sweb@tlen.pl", $title, $tresc , $headers); 

		echo '<script language="JavaScript" type="text/javascript" >	$(document).ready(function() { insertInfo("Email został wysłany."); });</script>';		
	}

		
	if(isset($_POST['rozmiar']) && isset($_POST['name']) && isset($_POST['surname']) && isset($_POST['ul'])&& isset($_POST['nr1'])&& isset($_POST['nr2'])&& isset($_POST['city'])&& isset($_POST['zip'])){
		$rozmiar = $_POST['rozmiar'];
		$name = $_POST['name'];
		$surname = $_POST['surname'];
		$ul = $_POST['ul'];
		$nr1 = $_POST['nr1'];
		$nr2 = $_POST['nr2'];
		$city = $_POST['city'];
		$zip = $_POST['zip'];
		
		
		
		
		$tresc = " CS KOSZULKA\r\n 
		login: $user\r\n 
		nick: $nick\r\n
		rozmiar: $rozmiar \r\n
		imie: $name\r\n
		nazwisko: $surname\r\n
		ulica: $ul\r\n
		numer domu: $nr1\r\n
		numer mieszkania: $nr2\r\n
		miasto: $city\r\n
		kod pocztowy: $zip\r\n		
		";
		if($_POST['opt'] == 1){
			if($prezentowe > 500) {
				$t_prezentowe = $prezentowe - 500;
				mysql_query("UPDATE `uzytkownicy` set `prezentowe`='$t_prezentowe'  WHERE `ide`='$myid' ");

				sendmail($mail, $tresc);
				echo '<script language="JavaScript" type="text/javascript" >	$(document).ready(function() { insertInfo("Zamówienie zostało wysłane! "); });</script>';
			}
		}
		if($_POST['opt'] == 3){
			if($prezentowe > 700) {
				$t_prezentowe = $prezentowe - 700;
				mysql_query("UPDATE `uzytkownicy` set `prezentowe`='$t_prezentowe'  WHERE `ide`='$myid' ");

				sendmail($mail, $tresc);
				echo '<script language="JavaScript" type="text/javascript" >	$(document).ready(function() { insertInfo("Zamówienie zostało wysłane! "); });</script>';
			}
		}
	}
	
	if(isset($_POST['email']) && $_POST['opt'] == 2 ){
		$tmp_mail = $_POST['email'];
		if($tmp_mail != $mail){
			echo '<script language="JavaScript" type="text/javascript" >	$(document).ready(function() { insertError("Podany email jest inny niż email konta. "); });</script>';
		}else{
			if($prezentowe > 900) {
				$t_prezentowe = $prezentowe - 900;
				mysql_query("UPDATE `uzytkownicy` set `prezentowe`='$t_prezentowe'  WHERE `ide`='$myid' ");
				$tresc = " CS STEAM\r\n login: $user\r\n nick: $nick\r\n email: $tmp_mail\r\n ";
				sendmail($mail, $tresc);
				echo '<script language="JavaScript" type="text/javascript" >	$(document).ready(function() { insertInfo("Zamówienie zostało wysłane! "); });</script>';
			}else{
				echo '<script language="JavaScript" type="text/javascript" >	$(document).ready(function() { insertError("Masz zbyt mało punktów prezentowych. "); });</script>';
			}

		}
			
	}
	

    echo $resources->punktyPrezentowe->punktyPrezentowe1.'<br>';
    echo $resources->punktyPrezentowe->punktyPrezentowe2.'<br>';
	echo '<br><br>';
		
    echo $resources->punktyPrezentowe->punktyPrezentowe3.'<br><br>';
    echo $resources->punktyPrezentowe->punktyPrezentowe4.'<br><br>';
    echo $resources->punktyPrezentowe->punktyPrezentowe5.'<br><br>';
	echo '<br><br>';
	
			echo '<div id="accordion">';
			echo '<h3><a href="#">Koszulka CS-LOD</a></h3>';
			echo '<div><p>';
                        echo 'Koszt: 500 pkt <br>';
						echo 'Wysyłane pocztą polską, przesyłka priorytetowa. <br>';

                        echo '<form method="post" action="index.php?page=prezentowe">';
						echo '<table>';
                        echo '<tr><td>Rozmiar(M/L/XL): </td><td><input type="text" name="rozmiar" /></td></tr>';
						echo '<tr><td>Imię: </td><td><input type="text" name="name" /></td></tr>';
						echo '<tr><td>Nazwisko: </td><td><input type="text" name="surname" /></td></tr>';
						echo '<tr><td>Ulica: </td><td><input type="text" name="ul" /></td></tr>';
						echo '<tr><td>Nr domu: </td><td><input type="text" name="nr1" /></td></tr>';
						echo '<tr><td>Nr mieszkania: </td><td><input type="text" name="nr2" /></td></tr>';
						echo '<tr><td>Miejscowość: </td><td><input type="text" name="city" /></td></tr>';
						echo '<tr><td>Kod pocztowy: </td><td><input type="text" name="zip" /></td></tr>';
						
						echo '</table>';
						echo '<input type="hidden" name="opt" value="1" />';
                        echo '<input type="submit" value="Wyślij" />';
                        echo '</form>';
						
			echo '</p></div>';
			echo '<h3><a href="#">Klucz steam Counter strike</a></h3>';
			echo '<div><p>';
                        echo 'Koszt: 900 pkt <br>';
						echo 'Zestaw 2 produktów: Counter-Strike, Counter-Strike: Condition Zero<br>';
						echo 'Klucz wysyłany na podany email.<br>';

                        echo '<form method="post" action="index.php?page=prezentowe">';
						echo '<table>';
                        echo '<tr><td>Adres e-mail: </td><td><input type="text" name="email" /></td></tr>';
						
						echo '</table>';
						echo '<input type="hidden" name="opt" value="2" />';
                        echo '<input type="submit" value="Wyślij" />';
                        echo '</form>';
						
			echo '</p></div>';
			echo '<h3><a href="#">Zestaw prezentowy CS-LOD</a></h3>';
			echo '<div><p>';
                        echo 'Koszt: 700 pkt <br>';
						echo  $resources->punktyPrezentowe->zestaw2.'<br>';
						echo 'Wysyłane pocztą polską, przesyłka priorytetowa. <br>';
						echo 'Niedostępne. <br>';

                        echo '<form method="post" action="index.php?page=prezentowe">';
						echo '<table>';
                        echo '<tr><td>Rozmiar(M/L/XL): </td><td><input type="text" name="rozmiar" /></td></tr>';
						echo '<tr><td>Imię: </td><td><input type="text" name="name" /></td></tr>';
						echo '<tr><td>Nazwisko: </td><td><input type="text" name="surname" /></td></tr>';
						echo '<tr><td>Ulica: </td><td><input type="text" name="ul" /></td></tr>';
						echo '<tr><td>Nr domu: </td><td><input type="text" name="nr1" /></td></tr>';
						echo '<tr><td>Nr mieszkania: </td><td><input type="text" name="nr2" /></td></tr>';
						echo '<tr><td>Miejscowość: </td><td><input type="text" name="city" /></td></tr>';
						echo '<tr><td>Kod pocztowy: </td><td><input type="text" name="zip" /></td></tr>';
						echo '<input type="hidden" name="opt" value="3" />';
						echo '</table>';
                        //echo '<input type="submit" value="Wyślij" />';
                        echo '</form>';
						
			echo '</p></div>';
			
			
			
			echo '</div>';
	

?>