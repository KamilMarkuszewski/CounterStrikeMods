<?php session_start(); 
include("../config.php"); 
$sql_conn = mysql_connect($dbhost , $dbuser, $dbpassword);
mysql_select_db($dbname,$sql_conn);	

?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html><head>





	<title>Diablo Mod Statystyki</title>
	<link href="img/main.css" rel="stylesheet" type="text/css">
	<style type="text/css">
.style1 {
	font-size: medium;
	font-weight: bold;
}

</style>
<meta http-equiv="content-type" content="text/html; charset=windows-1250">
</head><body bgcolor="#931818">
<div class="cTopBanner">
	<br>
	<a href="index.php"><img src="img/banner.png" alt="Diablo Mod PL" style="border: 0px none ;"></a>
</div>
<?
$a = 0;
if(session_is_registered("zalogowany")){
	echo '<div style="clear: both;" class="style1"><a href="acp.php?players=show">Edytowanie Gracza</a> <a href="acp.php?reset=t">Zerowanie expa i lvla wszystkim</a> <a href="acp.php?logout=t">Wyloguj</a></div>';
	if($_GET['players'] == 'show'){
		echo '<br><center>Wyszukaj gracza : <form action="" method=post><input type=text name="szukaj"><input type=submit name=szukaj2 value=Szukaj></form>';
		if (isset($_POST['szukaj2'])){
			$szukaj = $_POST['szukaj'];
			$szuk = mysql_query("Select `nick` from `$dbtable` where `nick`='$szukaj'");
			if(mysql_num_rows($szuk) > 0) {
				echo '<META HTTP-EQUIV=Refresh CONTENT="0; URL=acp.php?editplayer='.$szukaj.'">';
			} else {
				echo '<br>Nie ma gracza o takim nicku.<br>';
			}
		}
		echo '<br>';
		echo '<center><table border="0" width="25%">
			<tr class="tbl-hdr">
				<td width="184"><center>Nick Gracza:</center></td>
				<td><center>Edytuj:</center></td>
				</tr>';
		$sql = mysql_query("SELECT `nick` from `$dbtable` where `klasa` = '1'");
		while ($row = mysql_fetch_array($sql)) {
			$a++;
			if($a % 2 == 0){
				echo '<tr class ="tbl-shade2">';
			} else {
				echo '<tr class ="tbl-shade3">';
			}
			echo '
						<td width="184"><center>'.$row["nick"].'</center></td>
						<td><center><b><a href="acp.php?editplayer='.$row["nick"].'">Edytuj</a></b></center></td>
				  ';
			echo '</tr>';
		
		}
		echo '</table></center>';
	}

	if($_GET['editplayer'] != ' '){
		$chn = $_GET['editplayer'];
		$sql2 = mysql_query("SELECT `nick` from `$dbtable` where `nick`='$chn'");
		
		if((mysql_num_rows($sql2) < 0)){
			echo 'Nie ma użytkownika o takim nicku'.$chn;
		} elseif (mysql_num_rows($sql2) > 0) {
			$l = 0;
			echo '<br>';
			for ($i=1;$i<25;$i++){
				$player = mysql_query("SELECT `nick`,`lvl`,`exp`,`str`,`dex`,`int`,`agi` from `$dbtable` where `klasa`='$i' and `nick`='$chn' ");

		if($i==1){$pclass ='Mnich';} 
		else if($i==2){$pclass ='Paladyn';} 
		else if ($i==3){$pclass ='Zabojca';}
		else if($i==4){ $pclass ='Barbarzynca';}
		else if($i==5){$pclass ='Ninja';} 
		else if($i==6){$pclass ='Archeolog';}
		else if($i==7){ $pclass ='Kaplan';} 
		
		else if($i==8){$pclass ='Mag';} 
		else if($i==9){$pclass ='Mag Ognia';} 
		else if ($i==10){$pclass ='Mag Wody';}
		else if($i==11){ $pclass ='Mag Ziemi';}
		else if($i==12){$pclass ='Mag Powietrza';} 
		else if($i==13){$pclass ='Arcymag';}
		else if($i==14){ $pclass ='Magiczny gladiator';} 
		
		
		else if($i==15){$pclass ='Nekromanta';} 
		else if($i==16){$pclass ='Witch Doctor';} 
		else if ($i==17){$pclass ='Ork';}
		else if($i==18){ $pclass ='Wampir';}
		else if($i==19){$pclass ='Harpia';} 
		else if($i==20){$pclass ='Wilkołak';}
		else if($i==21){ $pclass ='Upadły Anioł';} 
		
		else if($i==22){$pclass ='Łowca';} 
		else if($i==23){$pclass ='Szary elf';}
		else { $pclass ='Leśny elf';} 
				
				echo '<b><font size=3>'.$pclass.'</font></b>';
				echo '<br>';
				echo '<center><form action="" method="POST"><table border="1" style="border-color:green" width="62% class="tbl-players"">
						<tr class="tbl-hdr">
							<td width="162">Nick Gracza:</center></td>
							<td width="30"><center>Lvl:</center></td>
							<td width="97"><center>Exp:</center></td>
							<td width="48"><center>Str:</center></td>
							<td width="48"><center>Dex:</center></td>
							<td width="48"><center>Int:</center></td>
							<td width="48"><center>Agi:</center></td>
							<td><center>Edytuj:</center></td>
						</tr>';
				while ($r = mysql_fetch_array($player)) {
						++$l;
						echo '<tr>
									<td width="162"><center><b>'.$r["nick"].'</b></center></td>
									<td width="30"><center><input type=text name="lvl'.$i.'" value="'.$r['lvl'].'" size="5"></center></td>
									<td width="97"><center><input type=text name="exp'.$i.'" value="'.$r['exp'].'" size="12"></center></td>
									<td width="48"><center><input type=text name="str'.$i.'" value="'.$r['str'].'" size="5"></center></td>
									<td width="48"><center><input type=text name="dex'.$i.'" value="'.$r['dex'].'" size="5"></center></td>
									<td width="48"><center><input type=text name="int'.$i.'" value="'.$r['int'].'" size="5"></center></td>
									<td width="48"><center><input type=text name="agi'.$i.'" value="'.$r['agi'].'" size="5"></center></td>
									<td><center><input type=submit value=Edytuj name="edytuj'.$l.'" ></center></td>
							</tr>';
				}
				echo '</table>';
				
			}
			echo '<input type=submit name="edytuj9" value="Edytuj wszystkie"></form></center><br>';
			$lvl1 = $_POST['lvl1']; $exp1 = $_POST['exp1']; $str1 = $_POST['str1']; $dex1 = $_POST['dex1']; $int1 = $_POST['int1']; $agi1 = $_POST['agi1'];
			$lvl2 = $_POST['lvl2']; $exp2 = $_POST['exp2']; $str2 = $_POST['str2']; $dex2 = $_POST['dex2']; $int2 = $_POST['int2']; $agi2 = $_POST['agi2'];
			$lvl3 = $_POST['lvl3']; $exp3 = $_POST['exp3']; $str3 = $_POST['str3']; $dex3 = $_POST['dex3']; $int3 = $_POST['int3']; $agi3 = $_POST['agi3'];
			$lvl4 = $_POST['lvl4']; $exp4 = $_POST['exp4']; $str4 = $_POST['str4']; $dex4 = $_POST['dex4']; $int4 = $_POST['int4']; $agi4 = $_POST['agi4'];
			$lvl5 = $_POST['lvl5']; $exp5 = $_POST['exp5']; $str5 = $_POST['str5']; $dex5 = $_POST['dex5']; $int5 = $_POST['int5']; $agi5 = $_POST['agi5'];
		  $lvl6 = $_POST['lvl6']; $exp6 = $_POST['exp6']; $str6 = $_POST['str6']; $dex6 = $_POST['dex6']; $int6 = $_POST['int6']; $agi6 = $_POST['agi6'];
		  $lvl7 = $_POST['lvl7']; $exp7 = $_POST['exp7']; $str7 = $_POST['str7']; $dex7 = $_POST['dex7']; $int7 = $_POST['int7']; $agi7 = $_POST['agi7'];
			$lvl8 = $_POST['lvl8']; $exp8 = $_POST['exp8']; $str8 = $_POST['str8']; $dex8 = $_POST['dex8']; $int8 = $_POST['int8']; $agi8 = $_POST['agi8'];
			$lvl9 = $_POST['lvl9']; $exp9 = $_POST['exp9']; $str9 = $_POST['str9']; $dex9 = $_POST['dex9']; $int9 = $_POST['int9']; $agi9 = $_POST['agi9'];
			$lvl10 = $_POST['lvl10']; $exp10 = $_POST['exp10']; $str10 = $_POST['str10']; $dex10 = $_POST['dex10']; $int10 = $_POST['int10']; $agi10 = $_POST['agi10'];
			$lvl11 = $_POST['lvl11']; $exp11 = $_POST['exp11']; $str11 = $_POST['str11']; $dex11 = $_POST['dex11']; $int11 = $_POST['int11']; $agi11 = $_POST['agi11'];
			$lvl12 = $_POST['lvl12']; $exp12 = $_POST['exp12']; $str12 = $_POST['str12']; $dex12 = $_POST['dex12']; $int12 = $_POST['int12']; $agi12 = $_POST['agi12'];
			$lvl13 = $_POST['lvl13']; $exp13 = $_POST['exp13']; $str13 = $_POST['str13']; $dex13 = $_POST['dex13']; $int13 = $_POST['int13']; $agi13 = $_POST['agi13'];	
			$lvl14 = $_POST['lvl14']; $exp14 = $_POST['exp14']; $str14 = $_POST['str14']; $dex14 = $_POST['dex14']; $int14 = $_POST['int14']; $agi14 = $_POST['agi14'];
			$lvl15 = $_POST['lvl15']; $exp15 = $_POST['exp15']; $str15 = $_POST['str15']; $dex15 = $_POST['dex15']; $int15 = $_POST['int15']; $agi15 = $_POST['agi15'];
			$lvl16 = $_POST['lvl16']; $exp16 = $_POST['exp16']; $str16 = $_POST['str16']; $dex16 = $_POST['dex16']; $int16 = $_POST['int16']; $agi16 = $_POST['agi16'];
			$lvl17 = $_POST['lvl17']; $exp17 = $_POST['exp17']; $str17 = $_POST['str17']; $dex17 = $_POST['dex17']; $int17 = $_POST['int17']; $agi17 = $_POST['agi17'];
			$lvl18 = $_POST['lvl18']; $exp18 = $_POST['exp18']; $str18 = $_POST['str18']; $dex18 = $_POST['dex18']; $int18 = $_POST['int18']; $agi18 = $_POST['agi18'];
			$lvl19 = $_POST['lvl19']; $exp19 = $_POST['exp19']; $str19 = $_POST['str19']; $dex19 = $_POST['dex19']; $int19 = $_POST['int19']; $agi19 = $_POST['agi19'];	
			$lvl20 = $_POST['lvl20']; $exp20 = $_POST['exp20']; $str20 = $_POST['str20']; $dex20 = $_POST['dex20']; $int20 = $_POST['int20']; $agi20 = $_POST['agi20'];
			$lvl21 = $_POST['lvl21']; $exp21 = $_POST['exp21']; $str21 = $_POST['str21']; $dex21 = $_POST['dex21']; $int21 = $_POST['int21']; $agi21 = $_POST['agi21'];
			$lvl22 = $_POST['lvl22']; $exp22 = $_POST['exp22']; $str22 = $_POST['str22']; $dex22 = $_POST['dex22']; $int22 = $_POST['int22']; $agi22 = $_POST['agi22'];
			$lvl23 = $_POST['lvl23']; $exp23 = $_POST['exp23']; $str23 = $_POST['str23']; $dex23 = $_POST['dex23']; $int23 = $_POST['int23']; $agi23 = $_POST['agi23'];
			$lvl24 = $_POST['lvl24']; $exp24 = $_POST['exp24']; $str24 = $_POST['str24']; $dex24 = $_POST['dex24']; $int24 = $_POST['int24']; $agi24 = $_POST['agi24'];
			
			if (isset($_POST['edytuj1'])){
				mysql_query("UPDATE `$dbtable` set `lvl`='$lvl1', `exp`='$exp1', `str`='$str1', `dex`='$dex1', `int`='$int1', `agi`='$agi1' WHERE `nick`='$chn' and `klasa`='1'") or die(mysql_error());
				echo 'Mag zedytowany';
				echo '<META HTTP-EQUIV=Refresh CONTENT="1; URL=acp.php?editplayer='.$chn.'">';
			}
			if (isset($_POST['edytuj2'])){
				mysql_query("UPDATE `$dbtable` set `lvl`='$lvl2', `exp`='$exp2', `str`='$str2', `dex`='$dex2', `int`='$int2', `agi`='$agi2' WHERE `nick`='$chn' and `klasa`='2'");
				echo 'Mnich zedytowany';
				echo '<META HTTP-EQUIV=Refresh CONTENT="1; URL=acp.php?editplayer='.$chn.'">';
			}			
			if (isset($_POST['edytuj3'])){
				mysql_query("UPDATE `$dbtable` set `lvl`='$lvl3', `exp`='$exp3', `str`='$str3', `dex`='$dex3', `int`='$int3', `agi`='$agi3' WHERE `nick`='$chn' and `klasa`='3'");
				echo 'Paladyn zedytowany';
				echo '<META HTTP-EQUIV=Refresh CONTENT="1; URL=acp.php?editplayer='.$chn.'">';			
			}
			if (isset($_POST['edytuj4'])){
				mysql_query("UPDATE `$dbtable` set `lvl`='$lvl4', `exp`='$exp4', `str`='$str4', `dex`='$dex4', `int`='$int4', `agi`='$agi4' WHERE `nick`='$chn' and `klasa`='4'");
				echo 'Zabójca zedytowany';
				echo '<META HTTP-EQUIV=Refresh CONTENT="1; URL=acp.php?editplayer='.$chn.'">';			
			}
			if (isset($_POST['edytuj5'])){
				mysql_query("UPDATE `$dbtable` set `lvl`='$lvl5', `exp`='$exp5', `str`='$str5', `dex`='$dex5', `int`='$int5', `agi`='$agi5' WHERE `nick`='$chn' and `klasa`='5'");
				echo 'Nekromanta zedytowany';
				echo '<META HTTP-EQUIV=Refresh CONTENT="1; URL=acp.php?editplayer='.$chn.'">';			
			}			
			if (isset($_POST['edytuj6'])){
				mysql_query("UPDATE `$dbtable` set `lvl`='$lvl6', `exp`='$exp6', `str`='$str6', `dex`='$dex6', `int`='$int6', `agi`='$agi6' WHERE `nick`='$chn' and `klasa`='6'");
				echo 'Barbarzyńca zedytowany';
				echo '<META HTTP-EQUIV=Refresh CONTENT="1; URL=acp.php?editplayer='.$chn.'">';				
			}
			if (isset($_POST['edytuj7'])){
				mysql_query("UPDATE `$dbtable` set `lvl`='$lvl7', `exp`='$exp7', `str`='$str7', `dex`='$dex7', `int`='$int7', `agi`='$agi7' WHERE `nick`='$chn' and `klasa`='7'");
				echo 'Ninja zedytowany';
				echo '<META HTTP-EQUIV=Refresh CONTENT="1; URL=acp.php?editplayer='.$chn.'">';			
			}
			if (isset($_POST['edytuj8'])){
				mysql_query("UPDATE `$dbtable` set `lvl`='$lvl8', `exp`='$exp8', `str`='$str8', `dex`='$dex8', `int`='$int8', `agi`='$agi8' WHERE `nick`='$chn' and `klasa`='8'");
				echo 'Łowca zedytowany';
				echo '<META HTTP-EQUIV=Refresh CONTENT="1; URL=acp.php?editplayer='.$chn.'">';
			}
			if (isset($_POST['edytuj9'])){
				mysql_query("UPDATE `$dbtable` set `lvl`='$lvl9', `exp`='$exp9', `str`='$str9', `dex`='$dex9', `int`='$int9', `agi`='$agi9' WHERE `nick`='$chn' and `klasa`='9'");
				echo 'Łowca zedytowany';
				echo '<META HTTP-EQUIV=Refresh CONTENT="1; URL=acp.php?editplayer='.$chn.'">';
			}
			if (isset($_POST['edytuj10'])){
				mysql_query("UPDATE `$dbtable` set `lvl`='$lvl10', `exp`='$exp10', `str`='$str10', `dex`='$dex10', `int`='$int10', `agi`='$agi10' WHERE `nick`='$chn' and `klasa`='10'");
				echo 'Łowca zedytowany';
				echo '<META HTTP-EQUIV=Refresh CONTENT="1; URL=acp.php?editplayer='.$chn.'">';
			}
			if (isset($_POST['edytuj11'])){
				mysql_query("UPDATE `$dbtable` set `lvl`='$lvl11', `exp`='$exp11', `str`='$str11', `dex`='$dex11', `int`='$int11', `agi`='$agi11' WHERE `nick`='$chn' and `klasa`='11'");
				echo 'Łowca zedytowany';
				echo '<META HTTP-EQUIV=Refresh CONTENT="1; URL=acp.php?editplayer='.$chn.'">';
			}
			if (isset($_POST['edytuj12'])){
				mysql_query("UPDATE `$dbtable` set `lvl`='$lvl12', `exp`='$exp12', `str`='$str12', `dex`='$dex12', `int`='$int12', `agi`='$agi12' WHERE `nick`='$chn' and `klasa`='12'");
				echo 'Łowca zedytowany';
				echo '<META HTTP-EQUIV=Refresh CONTENT="1; URL=acp.php?editplayer='.$chn.'">';
			}
			if (isset($_POST['edytuj13'])){
				mysql_query("UPDATE `$dbtable` set `lvl`='$lvl13', `exp`='$exp13', `str`='$str13', `dex`='$dex13', `int`='$int13', `agi`='$agi13' WHERE `nick`='$chn' and `klasa`='13'");
				echo 'Łowca zedytowany';
				echo '<META HTTP-EQUIV=Refresh CONTENT="1; URL=acp.php?editplayer='.$chn.'">';
			}
			if (isset($_POST['edytuj14'])){
				mysql_query("UPDATE `$dbtable` set `lvl`='$lvl14', `exp`='$exp14', `str`='$str14', `dex`='$dex14', `int`='$int14', `agi`='$agi14' WHERE `nick`='$chn' and `klasa`='14'");
				echo 'Łowca zedytowany';
				echo '<META HTTP-EQUIV=Refresh CONTENT="1; URL=acp.php?editplayer='.$chn.'">';
			}
			if (isset($_POST['edytuj15'])){
				mysql_query("UPDATE `$dbtable` set `lvl`='$lvl15', `exp`='$exp15', `str`='$str15', `dex`='$dex15', `int`='$int15', `agi`='$agi15' WHERE `nick`='$chn' and `klasa`='15'");
				echo 'Łowca zedytowany';
				echo '<META HTTP-EQUIV=Refresh CONTENT="1; URL=acp.php?editplayer='.$chn.'">';
			}
			if (isset($_POST['edytuj16'])){
				mysql_query("UPDATE `$dbtable` set `lvl`='$lvl16', `exp`='$exp16', `str`='$str16', `dex`='$dex16', `int`='$int16', `agi`='$agi16' WHERE `nick`='$chn' and `klasa`='16'");
				echo 'Łowca zedytowany';
				echo '<META HTTP-EQUIV=Refresh CONTENT="1; URL=acp.php?editplayer='.$chn.'">';
			}
			if (isset($_POST['edytuj17'])){
				mysql_query("UPDATE `$dbtable` set `lvl`='$lvl17', `exp`='$exp17', `str`='$str17', `dex`='$dex17', `int`='$int17', `agi`='$agi17' WHERE `nick`='$chn' and `klasa`='17'");
				echo 'Łowca zedytowany';
				echo '<META HTTP-EQUIV=Refresh CONTENT="1; URL=acp.php?editplayer='.$chn.'">';
			}
			if (isset($_POST['edytuj18'])){
				mysql_query("UPDATE `$dbtable` set `lvl`='$lvl18', `exp`='$exp18', `str`='$str18', `dex`='$dex18', `int`='$int18', `agi`='$agi18' WHERE `nick`='$chn' and `klasa`='18'");
				echo 'Łowca zedytowany';
				echo '<META HTTP-EQUIV=Refresh CONTENT="1; URL=acp.php?editplayer='.$chn.'">';
			}
			if (isset($_POST['edytuj19'])){
				mysql_query("UPDATE `$dbtable` set `lvl`='$lvl19', `exp`='$exp19', `str`='$str19', `dex`='$dex19', `int`='$int19', `agi`='$agi19' WHERE `nick`='$chn' and `klasa`='19'");
				echo 'Łowca zedytowany';
				echo '<META HTTP-EQUIV=Refresh CONTENT="1; URL=acp.php?editplayer='.$chn.'">';
			}
			if (isset($_POST['edytuj20'])){
				mysql_query("UPDATE `$dbtable` set `lvl`='$lvl20', `exp`='$exp20', `str`='$str20', `dex`='$dex20', `int`='$int20', `agi`='$agi20' WHERE `nick`='$chn' and `klasa`='20'");
				echo 'Łowca zedytowany';
				echo '<META HTTP-EQUIV=Refresh CONTENT="1; URL=acp.php?editplayer='.$chn.'">';
			}
			if (isset($_POST['edytuj21'])){
				mysql_query("UPDATE `$dbtable` set `lvl`='$lvl21', `exp`='$exp21', `str`='$str21', `dex`='$dex21', `int`='$int21', `agi`='$agi21' WHERE `nick`='$chn' and `klasa`='21'");
				echo 'Łowca zedytowany';
				echo '<META HTTP-EQUIV=Refresh CONTENT="1; URL=acp.php?editplayer='.$chn.'">';
			}
			if (isset($_POST['edytuj22'])){
				mysql_query("UPDATE `$dbtable` set `lvl`='$lvl22', `exp`='$exp22', `str`='$str22', `dex`='$dex22', `int`='$int22', `agi`='$agi22' WHERE `nick`='$chn' and `klasa`='22'");
				echo 'Łowca zedytowany';
				echo '<META HTTP-EQUIV=Refresh CONTENT="1; URL=acp.php?editplayer='.$chn.'">';
			}
			if (isset($_POST['edytuj23'])){
				mysql_query("UPDATE `$dbtable` set `lvl`='$lvl23', `exp`='$exp23', `str`='$str23', `dex`='$dex23', `int`='$int23', `agi`='$agi23' WHERE `nick`='$chn' and `klasa`='23'");
				echo 'Łowca zedytowany';
				echo '<META HTTP-EQUIV=Refresh CONTENT="1; URL=acp.php?editplayer='.$chn.'">';
			}
			if (isset($_POST['edytuj24'])){
				mysql_query("UPDATE `$dbtable` set `lvl`='$lvl24', `exp`='$exp24', `str`='$str24', `dex`='$dex24', `int`='$int24', `agi`='$agi24' WHERE `nick`='$chn' and `klasa`='24'");
				echo 'Łowca zedytowany';
				echo '<META HTTP-EQUIV=Refresh CONTENT="1; URL=acp.php?editplayer='.$chn.'">';
			}
			
			
			
			
			
			if (isset($_POST['edytuj9'])){	
				mysql_query("UPDATE `$dbtable` set `lvl`='$lvl1', `exp`='$exp1', `str`='$str1', `dex`='$dex1', `int`='$int1', `agi`='$agi1' WHERE `nick`='$chn' and `klasa`='1'");
				mysql_query("UPDATE `$dbtable` set `lvl`='$lvl2', `exp`='$exp2', `str`='$str2', `dex`='$dex2', `int`='$int2', `agi`='$agi2' WHERE `nick`='$chn' and `klasa`='2'");
				mysql_query("UPDATE `$dbtable` set `lvl`='$lvl3', `exp`='$exp3', `str`='$str3', `dex`='$dex3', `int`='$int3', `agi`='$agi3' WHERE `nick`='$chn' and `klasa`='3'");
				mysql_query("UPDATE `$dbtable` set `lvl`='$lvl4', `exp`='$exp4', `str`='$str4', `dex`='$dex4', `int`='$int4', `agi`='$agi4' WHERE `nick`='$chn' and `klasa`='4'");
				mysql_query("UPDATE `$dbtable` set `lvl`='$lvl5', `exp`='$exp5', `str`='$str5', `dex`='$dex5', `int`='$int5', `agi`='$agi5' WHERE `nick`='$chn' and `klasa`='5'");
				mysql_query("UPDATE `$dbtable` set `lvl`='$lvl6', `exp`='$exp6', `str`='$str6', `dex`='$dex6', `int`='$int6', `agi`='$agi6' WHERE `nick`='$chn' and `klasa`='6'");
				mysql_query("UPDATE `$dbtable` set `lvl`='$lvl7', `exp`='$exp7', `str`='$str7', `dex`='$dex7', `int`='$int7', `agi`='$agi7' WHERE `nick`='$chn' and `klasa`='7'");
				mysql_query("UPDATE `$dbtable` set `lvl`='$lvl8', `exp`='$exp8', `str`='$str8', `dex`='$dex8', `int`='$int8', `agi`='$agi8' WHERE `nick`='$chn' and `klasa`='8'");
				mysql_query("UPDATE `$dbtable` set `lvl`='$lvl9', `exp`='$exp9', `str`='$str9', `dex`='$dex9', `int`='$int9', `agi`='$agi9' WHERE `nick`='$chn' and `klasa`='9'");
				mysql_query("UPDATE `$dbtable` set `lvl`='$lvl10', `exp`='$exp10', `str`='$str10', `dex`='$dex10', `int`='$int10', `agi`='$agi10' WHERE `nick`='$chn' and `klasa`='10'");
				mysql_query("UPDATE `$dbtable` set `lvl`='$lvl11', `exp`='$exp11', `str`='$str11', `dex`='$dex11', `int`='$int11', `agi`='$agi11' WHERE `nick`='$chn' and `klasa`='11'");
				mysql_query("UPDATE `$dbtable` set `lvl`='$lvl12', `exp`='$exp12', `str`='$str12', `dex`='$dex12', `int`='$int12', `agi`='$agi12' WHERE `nick`='$chn' and `klasa`='12'");
				mysql_query("UPDATE `$dbtable` set `lvl`='$lvl13', `exp`='$exp13', `str`='$str13', `dex`='$dex13', `int`='$int13', `agi`='$agi13' WHERE `nick`='$chn' and `klasa`='13'");
				mysql_query("UPDATE `$dbtable` set `lvl`='$lvl14', `exp`='$exp14', `str`='$str14', `dex`='$dex14', `int`='$int14', `agi`='$agi14' WHERE `nick`='$chn' and `klasa`='14'");
				mysql_query("UPDATE `$dbtable` set `lvl`='$lvl15', `exp`='$exp15', `str`='$str15', `dex`='$dex15', `int`='$int15', `agi`='$agi15' WHERE `nick`='$chn' and `klasa`='15'");
				mysql_query("UPDATE `$dbtable` set `lvl`='$lvl16', `exp`='$exp16', `str`='$str16', `dex`='$dex16', `int`='$int16', `agi`='$agi16' WHERE `nick`='$chn' and `klasa`='16'");
				mysql_query("UPDATE `$dbtable` set `lvl`='$lvl17', `exp`='$exp17', `str`='$str17', `dex`='$dex17', `int`='$int17', `agi`='$agi17' WHERE `nick`='$chn' and `klasa`='17'");
				mysql_query("UPDATE `$dbtable` set `lvl`='$lvl18', `exp`='$exp18', `str`='$str18', `dex`='$dex18', `int`='$int18', `agi`='$agi18' WHERE `nick`='$chn' and `klasa`='18'");
				mysql_query("UPDATE `$dbtable` set `lvl`='$lvl19', `exp`='$exp19', `str`='$str19', `dex`='$dex19', `int`='$int19', `agi`='$agi19' WHERE `nick`='$chn' and `klasa`='19'");
				mysql_query("UPDATE `$dbtable` set `lvl`='$lvl20', `exp`='$exp20', `str`='$str20', `dex`='$dex20', `int`='$int20', `agi`='$agi20' WHERE `nick`='$chn' and `klasa`='20'");
				mysql_query("UPDATE `$dbtable` set `lvl`='$lvl21', `exp`='$exp21', `str`='$str21', `dex`='$dex21', `int`='$int21', `agi`='$agi21' WHERE `nick`='$chn' and `klasa`='21'");
				mysql_query("UPDATE `$dbtable` set `lvl`='$lvl22', `exp`='$exp22', `str`='$str22', `dex`='$dex22', `int`='$int22', `agi`='$agi22' WHERE `nick`='$chn' and `klasa`='22'");
				mysql_query("UPDATE `$dbtable` set `lvl`='$lvl23', `exp`='$exp23', `str`='$str23', `dex`='$dex23', `int`='$int23', `agi`='$agi23' WHERE `nick`='$chn' and `klasa`='23'");
				mysql_query("UPDATE `$dbtable` set `lvl`='$lvl24', `exp`='$exp24', `str`='$str24', `dex`='$dex24', `int`='$int24', `agi`='$agi24' WHERE `nick`='$chn' and `klasa`='24'");
				
				echo 'Postacie zedytowane';
				echo '<META HTTP-EQUIV=Refresh CONTENT="1; URL=acp.php?editplayer='.$chn.'">';				
			}
		}
	}
	if($_GET['reset'] == 't'){
		echo '<form action="" method="POST"><center><b>Czy na pewno chcesz zresetować lvle i exp?</b><br><input type=submit name=Tak value="Tak"><input type=submit name=Nie value="Nie"></center></from>';
		if (isset($_POST['Tak'])){
				mysql_query("Truncate Table `$dbtable`");
				echo 'Restart wykonany pomyślnie';
		}
		if (isset($_POST['Nie'])){
			echo '<META HTTP-EQUIV=Refresh CONTENT="0; URL=acp.php">';
		}
	}
	if($_GET['logout'] == 't'){
		echo "Wylogowano Poprawnie<br>";
		echo "<b><a href=\"index.php\">Strona Główna</a></b>";
		session_destroy();
	}
	
} else {
	echo 'Najpierw się zaloguj';
}
?>
<div class="cBottom">
	<br><font size="1">Powered by <a href="http://amxx.pl/" target="_blank">GuTeK &amp; Miczu</a> v2.0</font><br>
	<font size="1"><a href="http:///" target="_blank"></a></font><br><br>
</div>


</body></html>