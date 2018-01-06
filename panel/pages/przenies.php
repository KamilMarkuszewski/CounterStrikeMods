<?php
	$maxVipLvl = mysql_result(mysql_query("SELECT max(`lvl`) as max FROM `dbmod_tablet` WHERE `nick`='$nick' AND (`klasa` in ('13','16','18')) AND `blocked` = 0"),max);

	$cena_move = 0;
	if($maxVipLvl <= 75 && $maxVipLvl > 10) $cena_move = 0;
	else $cena_move = 0;
	
	if(isset($_POST['klasa']) && isset($_POST['klasaNa'])){
		$tmp_klasa = $_POST['klasa'];
		$tmp_klasaNa = $_POST['klasaNa'];
		$ok = 1;
		if($nr==1)
		{
			if($tmp_klasa > 0 && $tmp_klasa< 25 && $tmp_klasaNa > 0 && $tmp_klasaNa< 25)
			{
				if($tmp_klasa != 13 && $tmp_klasa != 16 && $tmp_klasa != 18) $ok = 0;
				if($tmp_klasaNa == 13 || $tmp_klasaNa == 16 || $tmp_klasaNa == 18) $ok = 0;
			}
		}
		if($nr==2)
		{
			if($tmp_klasa > 0 && $tmp_klasa< 25 && $tmp_klasaNa > 0 && $tmp_klasaNa< 25)
			{
				if($tmp_klasa != 16 && $tmp_klasa != 22 && $tmp_klasa != 23 && $tmp_klasa != 24) $ok = 0;
				if($tmp_klasaNa == 16 || $tmp_klasaNa == 22 || $tmp_klasaNa == 23 || $tmp_klasaNa == 24) $ok = 0;
			}
		}
		
		if($pkt >= $cena_move && $ok == 1)
		{
			$blocked = mysql_result(mysql_query("SELECT `blocked` from `$dbtable` where `nick`='$nick' and `klasa`='$tmp_klasa'"),blocked);
			$blockedNa = mysql_result(mysql_query("SELECT `blocked` from `$dbtable` where `nick`='$nick' and `klasa`='$tmp_klasaNa'"),blocked);
			if($blocked  == 1)
			{
				echo '<script language="JavaScript" type="text/javascript" >	$(document).ready(function() { insertError("Ta klasa jest juz zablokowana"); });</script>';	
			}
			else if($blockedNa  == 2)
			{
				echo '<script language="JavaScript" type="text/javascript" >	$(document).ready(function() { insertError("Na tę klasę już przenosiłeś exp"); });</script>';	
			}
			else
			{
				$pobrany_exp_vip = mysql_result(mysql_query("SELECT `exp` from `$dbtable` where `nick`='$nick' and `klasa`='$tmp_klasa' and `blocked` = '0' "),exp);
				$pobrany_exp_na = mysql_result(mysql_query("SELECT `exp` from `$dbtable` where `nick`='$nick' and `klasa`='$tmp_klasaNa'"),exp);
				
				$sum = $pobrany_exp_vip + $pobrany_exp_na ;
				
				mysql_query("UPDATE `$dbtable` set `exp`='0', `blocked` = 1 WHERE `nick`='$nick' and `klasa`='$tmp_klasa' and `blocked` = '0' ");
				mysql_query("UPDATE `$dbtable` set `exp`='$sum', `blocked`='2' WHERE `nick`='$nick' and `klasa`='$tmp_klasaNa' and `blocked` = '0'");
				
				$tmp_pkt = $pkt;
				$tmp_pkt = $tmp_pkt - $cena_move;
				
				//mysql_query("UPDATE `uzytkownicy` set `pkt`='$tmp_pkt' WHERE `ide`='$myid' ");
				echo '<script language="JavaScript" type="text/javascript" >	$(document).ready(function() { insertInfo("Doswiadczenie przelozone"); });</script>';	
				saveLogs(' Przeniosl exp z ' . $tmp_klasa. ' ( ' . $pobrany_exp_vip . ' )  na ' .  $tmp_klasaNa . ' ( '.$pobrany_exp_na. ')', $user, $nick);
			}			
		}
		else if($ok == 0)
		{
			echo '<script language="JavaScript" type="text/javascript" >	$(document).ready(function() { insertError("Zle argumenty"); });</script>';	
		}
		else
		{
			echo '<script language="JavaScript" type="text/javascript" >	$(document).ready(function() { insertError("Masz zbyt mało punktów"); });</script>';	
		}
	}

    echo 'Tu możesz przełożyć cały exp z zklasy VIP na zwykłą klasę.<br> ';
	echo 'Po przełożeniu, exp z obu klas się zsumuje.<br> ';
	echo 'Klasa VIP będzie zablokowana i nie będziesz mógł więcej na niej grać.<br> ';
	echo 'Na każdą klasę exp możesz przenieść tylko raz.<br> ';
	echo 'Gdyby kiedyś w przyszłości klasa stała się nie vip, będzie znów dostępna.<br> ';
	echo '<br> ';
	echo '<br> ';
	
	echo 'Cena:'.$cena_move.' pkt.<br> ';
	echo '<br> ';

	echo '<form method="post" action="index.php?page=przenies">';
	if($nr==1){					
		echo 'Wybierz klasę z której przełożysz: <br> ';
		echo '<select name="klasa" size="7">';
		echo '<option value="13">Arcymag - VIP</option>';
		echo '<option value="16">Witch doctor - VIP</option>';
		echo '<option value="18">Wampir - VIP</option>';
		echo '</select><br>';
		
		echo '<br> ';
		echo '<br> ';
		
		echo 'Wybierz klasę na którą przełożysz: <br> ';
		echo '<select name="klasaNa" size="7">';
		echo '<option value="1">Mnich</option>';
		echo '<option value="2">Paladyn</option>';
		echo '<option value="3">Zabojca</option>';
		echo '<option value="4">Barbarzynca</option>';
		echo '<option value="5">Ninja</option>';
		echo '<option value="6">Archeolog</option>';
		echo '<option value="7">Kaplan</option>';
		
		echo '<option value="8">Mag</option>';
		echo '<option value="9">Mag ognia</option>';
		echo '<option value="10">Mag wody</option>';
		echo '<option value="11">Mag ziemi</option>';
		echo '<option value="12">Mag powietrza</option>';
		echo '<option value="14">Magic Gladiator</option>';
		
		echo '<option value="15">Nekromanta</option>';
		echo '<option value="17">Orc</option>';
		echo '<option value="19">Harpia</option>';
		echo '<option value="20">Wilkołak</option>';
		echo '<option value="21">Upadły anioł </option>';
		
		echo '<option value="22">Łowca</option>';
		echo '<option value="23">Szary elf</option>';
		echo '<option value="24">Leśny elf</option>';
		echo '</select><br>';
	}
	if($nr==2){
		echo 'Wybierz klasę z której przełożysz: <br> ';
		echo '<select name="klasa" size="7">';
		echo '<option value="16">Demon</option>';
		echo '<option value="22">Strzelec krolewski</option>';
		echo '<option value="23">Mroczny elf</option>';
		echo '<option value="24">Heretyk</option>';
		echo '</select><br>';
		
		echo '<br> ';
		echo '<br> ';
		
		echo 'Wybierz klasę na którą przełożysz: <br> ';
		echo '<select name="klasaNa" size="7">';
		echo '<option value="1">Mnich</option>';
		echo '<option value="2">Paladyn</option>';
		echo '<option value="3">Zabojca</option>';
		echo '<option value="4">Barbarzynca</option>';
		echo '<option value="5">Ninja</option>';
		echo '<option value="6">Samurai</option>';
		
		
		echo '<option value="7">Wysoki Elf</option>';
		echo '<option value="8">Ifryt</option>';
		echo '<option value="9">Mag lodu</option>';
		echo '<option value="10">Meduza</option>';
		echo '<option value="11">Druid</option>';
		echo '<option value="12">Przywolywacz</option>';
		
		echo '<option value="13">Nekromanta</option>';
		echo '<option value="14">Dremora</option>';
		echo '<option value="15">Zjawa</option>';
		echo '<option value="17">Ghull</option>';
		echo '<option value="18">Troll</option>';
		
		echo '<option value="19">Inkwizytor</option>';
		echo '<option value="20">Kusznik</option>';
		echo '<option value="21">Lucznik </option>';
		echo '</select><br>';
	}
	echo '<br> ';
	echo '<br> ';

	echo $resources->kupno->panel .'<br>';
	echo '<br><input type="submit" value="Kup"  />';

?>