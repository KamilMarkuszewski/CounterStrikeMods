


		<link type="text/css" href="design/css/ui-lightness/jquery-ui-1.8.23.custom.css" rel="stylesheet" />
		<script type="text/javascript" src="design/js/jquery-1.8.0.min.js"></script>
		<script type="text/javascript" src="design/js/jquery-ui-1.8.23.custom.min.js"></script>
		
		<script type="text/javascript">
			$(function(){

				// Accordion
				$("#accordion").accordion({ header: "h3" });

				//hover states on the static widgets
				$('#dialog_link, ul#icons li').hover(
					function() { $(this).addClass('ui-state-hover'); },
					function() { $(this).removeClass('ui-state-hover'); }
				);


			});
		</script>


<?php
function wSMSCheck($Code, $Username)
{
	$C = curl_init();
	curl_setopt($C, CURLOPT_URL, 'http://serwery.wiaderko.com/sms_api.php');
	curl_setopt($C, CURLOPT_POST, 1);
	curl_setopt($C, CURLOPT_POSTFIELDS, array(
		'code' => $Code,
		'username' => $Username
	));
	curl_setopt($C, CURLOPT_RETURNTRANSFER, true); 
	$X = curl_exec($C);
	curl_close($C);
	
	return unserialize($X);
}


	if(isset($_POST['wartosc']) && isset($_POST['kod']) && $_POST['kod']!=Null && $_POST['kod']!= ""){
		$fwartosc = htmlspecialchars($_POST['wartosc']); 
		$fkod = strtoupper(htmlspecialchars($_POST['kod'])); 
		$Username = "kajtsweb";
		$ret = wSMSCheck($fkod, $Username);
		
		if($ret[error] == 0)
		{
				$pkt_elem = floor($ret[amount]) *3;
				$rekl_pkt_add = floor($pkt_elem/6);
				$t_pkt = $pkt + $pkt_elem;
				mysql_query("UPDATE `uzytkownicy` set `pkt`='$t_pkt' WHERE `ide`='$myid' ");
				if($rekl != NULL){
					$rekl_pkt = mysql_result(mysql_query("SELECT `pkt` from `uzytkownicy` where `user`='$rekl'"),pkt);
					$rekl_pkt += $rekl_pkt_add;
					mysql_query("UPDATE `uzytkownicy` set `pkt`='$rekl_pkt' WHERE `user`='$rekl'");
					saveLogs(' podarowal '.$rekl_pkt_add.' pkt userowi '.$rekl, $user, $nick);
				}
											
				$check = mysql_result(mysql_query("SELECT `pkt` from `uzytkownicy` where `ide`='$myid'"),pkt);
				if($check < $t_pkt){
					$err = "Twoje punkty jakims cudem nie zostaly dodane, zglos to na forum!";
					saveLogs(' kupil '.$pkt_elem.' pkt - KUPNO Z LOGOWANIEM I Z BLEDEM ', $user, $nick);
				}else{
					saveLogs(' kupil na wiaderko '.$pkt_elem.' pkt '. $kodUsera . ' ', $user, $nick);
				}

				echo '<script language="JavaScript" type="text/javascript" >	$(document).ready(function() { insertInfo("Otrzymałeś '.$pkt_elem.' punkty! "); });</script>';
									
		}
		if($ret[error] == 3)
		{		
			echo '<script language="JavaScript" type="text/javascript" >	$(document).ready(function() { insertError("Podany kod jest niepoprawny. "); });</script>';
		}
	}
		
	if($buyban > 0)
	{
			echo'
			<div class="ui-widget">
				<div class="ui-state-error ui-corner-all" style="padding: 0 .7em;">
					<p><span class="ui-icon ui-icon-alert" style="float: left; margin-right: .3em;"></span>
					<strong>Błąd: </strong> Kupno na tym koncie zostało zablokowane z jednego z powodów: hacking, oszustwa, nieprzestrzeganie regulaminu. </p>
				</div>
			</div>
			';
	
	}else if(strlen($sid)<10){
		echo '<script language="JavaScript" type="text/javascript" >	$(document).ready(function() { insertError("Aby kupić punkty musisz przypisać do konta STEAM ID!"); });</script>';	
	}else{

			echo 'Tutaj możesz doładować punkty za różne kwoty. Pieniądze z tego doładowania będa bezpośrednio opłacać reklamę serwerów!<br><br>';
			echo '
								<div class="c">
								Dostawcą usługi jest Kamil Markuszewski<br>
								Usługą jest kupno punktów w panelu cs-lod<br>
								Wysyłając kod akceptujesz <a href="http://serwery.wiaderko.com/panel/wplata/">Regulamin wiaderko.com</a> oraz <a href="http://cs-lod.com.pl/index.php/regulaminy/regulamin-sklepu">Regulamin sklepu</a><br><br>
								Opłata jest naliczana za wysłanego przez Klienta SMS-a za wykonaną transmisję danych,<br> pobierana z góry przy wysyłaniu SMS-a, a nie po otrzymaniu SMS-a zwrotnego.<br>
								Usługa dostępna w sieciach: T-mobile, Orange, Play, Plus GSM.<br>
								</div><br>';
			
			$tresc = 'TC.WIADERKO';
			
					echo '<div id="accordion">';
					/*
					echo '<h3><a href="#">Doladuj 7 punktów za 6,15 zł</a></h3>';
					echo '<div><p>';
								$add = 7;
						
								echo 'Punkty z doładowania: '.$add.'<br>';
								echo 'Koszt doładowania: 6.15 zł <br>';
								echo 'Zysk serwera:  3.20 zł<br><br>';
								echo 'Treść smsa: '.$tresc.' <br>';
								echo 'Nr tel: 75480<br><br>';
								echo 'Po wysłaniu smsa otrzymasz kod, który należy podać poniżej.<br><br>';
								echo '<form method="post" action="index.php?page=wiaderko">';
								echo 'Kod smsa: <input type="text" name="kod" />';
								echo '<input type="hidden" name="wartosc" value="2" />';
								echo '<input type="hidden" name="pkt" value="7" />';
								echo '<input type="submit" value="Wyślij" />';
								echo '</form>';
								
					echo '</p></div>';
					
					
					echo '<h3><a href="#">Doladuj 13 punktów za 11,07 zł</a></h3>';
					echo '<div><p>';
								$add = 13;
						

								echo 'Punkty z doładowania: '.$add.'<br>';
								echo 'Koszt doładowania: 11,07 zl <br>';
								echo 'Zysk serwera:  5,76 zł<br><br>';
								echo 'Treść smsa: '.$tresc.' <br>';
								echo 'Nr tel: 79480<br><br>';
								echo 'Po wysłaniu smsa otrzymasz kod, który należy podać poniżej.<br><br>';
								echo '<form method="post" action="index.php?page=wiaderko">';
								echo 'Kod smsa: <input type="text" name="kod" />';
								echo '<input type="hidden" name="wartosc" value="5" />';
								echo '<input type="hidden" name="pkt" value="13" />';
								echo '<input type="submit" value="Wyślij" />';
								echo '</form>';
					echo '</p></div>';
			*/		
					
					echo '<h3><a href="#">Doladuj 27 punktów za 23,37 zł</a></h3>';
					echo '<div><p>';
								$add = 27;
						

								echo 'Punkty z doładowania: '.$add.'<br>';
								echo 'Koszt doładowania: 23.37 zł <br>';
								echo 'Zysk serwera:  9.50 zł<br><br>';
								echo 'Treść smsa: '.$tresc.' <br>';
								echo 'Nr tel: 91958<br><br>';
								echo 'Po wysłaniu smsa otrzymasz kod, który należy podać poniżej.<br><br>';
								echo '<form method="post" action="index.php?page=wiaderko">';
								echo 'Kod smsa: <input type="text" name="kod" />';
								echo '<input type="hidden" name="wartosc" value="11" />';
								echo '<input type="hidden" name="pkt" value="27" />';
								echo '<input type="submit" value="Wyślij" />';
								echo '</form>';
					echo '</p></div>';
				
								
					
					echo '<h3><a href="#">Doladuj 36 punkty za 30,75 zł</a></h3>';
					echo '<div><p>';
								$add = 36;
						
								echo 'Punkty z doładowania: '.$add.'<br>';
								echo 'Koszt doładowania: 30.75 zł <br>';
								echo 'Zysk serwera:  12,50 zł<br><br>';
								echo 'Treść smsa: '.$tresc.' <br>';
								echo 'Nr tel: 92578<br><br>';
								echo 'Po wysłaniu smsa otrzymasz kod, który należy podać poniżej.<br><br>';
								echo '<form method="post" action="index.php?page=wiaderko">';
								echo 'Kod smsa: <input type="text" name="kod" />';
								echo '<input type="hidden" name="wartosc" value="14" />';
								echo '<input type="hidden" name="pkt" value="36" />';
								echo '<input type="submit" value="Wyślij" />';
								echo '</form>';
					echo '</p></div>';
				echo '</div>';
						
						
						echo '<br>';
						echo '
						<div id="dialog" title="Informacja" width="600">
						<p>
							Przed dokonaniem zamówienia Użytkownik powinien upewnić się czy w jego telefonie komórkowym pozostało wystarczająco dużo wolnej pamięci niezbędnej do pobrania i zainstalowania lub odczytania wybranego Produktu. Wprzypadku gdy ilość pamięci jest zbyt mała, Produkt zostanie zamówiony i opłacony jednak Użytkownik nie będzie mógł dokonać jego pobrania, odczytania lub instalacji.
							<br><br>
							Eurokoncept ani CS-LOD nie ponosi odpowiedzialności za błędne wpisanie przez Użytkownika kodu zamówienia bądź wybranie błędnego numeru SMS lub MMS Premium lub telefonu.
							<br><br>
							Serwis zapewnia obsługę maksymalnie 2 wiadomości SMS/MMS przesłanych z jednego numeru telefonu w okresie 60 sekund dla wiadomości SMS/MMS o wartości netto do 9 PLN włącznie, jak również wszystkich wiadomości SMS/MMS z sieci operatorów zagranicznych. Dla wiadomości SMS/MMS o wartości netto powyżej 9 PLN, o ile nie ustalono inaczej, Serwis zapewnia obsługę maksymalnie 1 wiadomości SMS/MMS, przesłanej z jednego numeru telefonu w okresie 20 minut. Serwis może wprowadzić dodatkowe obostrzenia i blokady w przypadku stwierdzenia prób nadużycia i/lub działania na szkodę Serwisu.
							<br><br>
							Jeżeli w czasie 24 godzin od chwili zamówienia Produktu Użytkownik nie otrzyma SMS lub MMS lub WAP-Push, należy złożyć reklamacje pod adresem http://www.dotpay.pl/reklamacja lub przesłać listem poleconym na adres: Eurokoncept Sp.z o.o., Wielicka 72, 30-552 Kraków. Reklamacja zostanie rozpatrzona w terminie 7 dni roboczych od daty otrzymania.
							<br><br>
							Po pierwszej nieudanej próbie zamówienia prosimy o niedokonywanie dalszych zamówień. W przypadku niedostosowania się do powyższej procedury Eurokoncept nie ponosi odpowiedzialności za kilkakrotne nieudane zamówienie produktu.
							</p></div>
							';
						
						
		}
?>
