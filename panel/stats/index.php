<?php

	require( "config.php" );
	$sql_conn = mysql_connect($dbhost , $dbuser, $dbpassword);
	mysql_select_db($dbname,$sql_conn);	
?>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>

	<title>Diablo Mod Statystyki</title>
	<link href="main.css" rel="stylesheet" type="text/css">
	<style type="text/css">
.style1 {
	font-size: medium;
	font-weight: bold;
}

</style>
<meta http-equiv="content-type" content="text/html; charset=windows-1250">
</head>
<body bgcolor="#931818">

<?php
if($_GET['szukaj'] != 'show'){
echo '<form action="" method="POST">
   Wyszukaj gracza: <input name="player" type="text" MAXLENGTH="32" >
   <input  TYPE="submit" name="spr" VALUE="Szukaj">
</form>';}
$pla = $_POST['player'];
$nick =$_GET['player'];
$checknick = mysql_query("SELECT `nick` from `$dbtable` where `nick`='$pla'");
if(isset($_POST['spr'])){
	if((mysql_num_rows($checknick) > 0)){
		echo '<META HTTP-EQUIV=Refresh CONTENT="1; URL=index.php?player='.$pla.'">';	
		
	} else {
		echo '<br><b>Nie ma gracza o takim nicku.</b><br><br>';
		echo '<META HTTP-EQUIV=Refresh CONTENT="1; URL=index.php?szukaj=show">';
	}
}
if($_GET['szukaj'] == 'show'){
	echo '<form action="" method="POST">
   Wyszukaj gracza: <input name="player" type="text" MAXLENGTH="32" >
   <input  TYPE="submit" name="spr" VALUE="Szukaj">
</form>';
}
if($nick != '')	{
echo '<title>DiabloMod Statystyki gracza: '.$nick.'</title>';	
echo '<head><meta http-equiv="content-type" content="text/html; charset=windows-1250"></head>';
echo '<div class="cMain">
		
		<tr>Postacie gracza: <b>'.$nick.'</b></tr>	
		
		<div class="cPlayers_Inner1">
			<table width="100%" border="0" cellpadding="0" cellspacing="0" class="tbl-players">
				<tr class="tbl-hdr">
					<td>Klasa</td>
					<td>Poziom</td>
					<td>Exp</td>
					<td>Siła</td>
					<td>Zręczność</td>
					<td>Inteligencja</td>
					<td>Szybkość</td>

				</tr>
				<tr style="height:4px; background-color:#000000; font-size:4px;"><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>
';	
$a =0;
$i = 0;
$player = "SELECT * from $dbtable where nick='$nick'";
	$query2 = mysql_query($player)or die(mysql_error());
while ($row = mysql_fetch_array($query2)) {
		
		$a++;
		++$i;
		if($a % 2 == 0){
		echo '<tr class ="tbl-shade2">';
		} else {
			echo '<tr class ="tbl-shade3">';
		}


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
	
								
		echo '<td>'.$pclass.'</td>';
		echo "<td>".$row["lvl"].'</td>';
		echo "<td>".$row["exp"].'</td>';
		echo "<td>".$row["str"].'</td>';
		echo "<td>".$row["dex"].'</td>';
		echo "<td>".$row["int"].'</td>';
		echo "<td>".$row["agi"].'</td>';
		echo '</tr>';
			}
}
if ($_GET['class'] >= '0') {



$class = $_GET['class'];
if($class == 0){
	echo '<div class="cMain">
		  <div class="cPlayers_Inner1">
			<table width="100%" border="0" cellpadding="0" cellspacing="0" class="tbl-players">
				<tr class="tbl-hdr">
					<td>Rank</td>
					<td>Nick</td>
					<td>Klasa</td>
					<td>Poziom</td>
					<td>Exp</td>
				</tr>
				<tr style="height:4px; background-color:#000000; font-size:4px;"><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>
';
	$a =0;
	$i = 1;
	$queryall = mysql_query("SELECT * from $dbtable ORDER BY lvl DESC, exp DESC limit 0,$ile")or die(mysql_error());
	while ($rall = mysql_fetch_array($queryall)) {
		
		$a++;

		if($rall["klasa"]==1){$pclass ='Mnich';} 
		else if($rall["klasa"]==2){$pclass ='Paladyn';} 
		else if ($rall["klasa"]==3){$pclass ='Zabojca';}
		else if($rall["klasa"]==4){ $pclass ='Barbarzynca';}
		else if($rall["klasa"]==5){$pclass ='Ninja';} 
		else if($rall["klasa"]==6){$pclass ='Archeolog';}
		else if($rall["klasa"]==7){ $pclass ='Kaplan';} 
		
		else if($rall["klasa"]==8){$pclass ='Mag';} 
		else if($rall["klasa"]==9){$pclass ='Mag Ognia';} 
		else if ($rall["klasa"]==10){$pclass ='Mag Wody';}
		else if($rall["klasa"]==11){ $pclass ='Mag Ziemi';}
		else if($rall["klasa"]==12){$pclass ='Mag Powietrza';} 
		else if($rall["klasa"]==13){$pclass ='Arcymag';}
		else if($rall["klasa"]==14){ $pclass ='Magiczny gladiator';} 
		
		
		else if($rall["klasa"]==15){$pclass ='Nekromanta';} 
		else if($rall["klasa"]==16){$pclass ='Witch Doctor';} 
		else if ($rall["klasa"]==17){$pclass ='Ork';}
		else if($rall["klasa"]==18){ $pclass ='Wampir';}
		else if($rall["klasa"]==19){$pclass ='Harpia';} 
		else if($rall["klasa"]==20){$pclass ='Wilkołak';}
		else if($rall["klasa"]==21){ $pclass ='Upadły Anioł';} 
		
		else if($rall["klasa"]==22){$pclass ='Łowca';} 
		else if($rall["klasa"]==23){$pclass ='Szary elf';}
		else { $pclass ='Leśny elf';} 
	
		
		
		if($a % 2 == 0){
		echo '<tr class ="tbl-shade2">';
		} else {
			echo '<tr class ="tbl-shade3">';
		}
		echo "<td>" . $i++ . "</td>";
		echo '<td><b><a href="index.php?player='.$rall["nick"].'">'.$rall["nick"].'</a></b></td>';
		echo '<td>'.$pclass.'</td>';
		echo "<td>".$rall["lvl"].'</td>';
		echo "<td>".$rall["exp"].'</td></tr>';
			}
}
	
if($class <= 24){
	if($class > 0){
		echo '<div class="cMain">

		
		<div class="cPlayers_Inner1">
			<table width="100%" border="0" cellpadding="0" cellspacing="0" class="tbl-players">
				<tr class="tbl-hdr">
					<td>Rank</td>
					<td>Nick</td>
					<td>Poziom</td>
					<td>Exp</td>

				</tr>
				<tr style="height:4px; background-color:#000000; font-size:4px;"><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>
		';
	}
$a =0;
	$i = 1;
	$sql = "SELECT * from $dbtable where klasa ='$class' ORDER BY lvl DESC, exp DESC limit 0,$ile";
	$query = mysql_query($sql)or die(mysql_error());
	while ($row = mysql_fetch_array($query)) {
		
		$a++;
		if($a % 2 == 0){
		echo '<tr class ="tbl-shade2">';
		} else {
			echo '<tr class ="tbl-shade3">';
		}
		echo "<td>" . $i++ . "</td>";
		echo '<td><b><a href="index.php?player='.$row["nick"].'">'.$row["nick"].'</a></b></td>';
		echo "<td>".$row["lvl"].'</td>';
		echo "<td>".$row["exp"].'</td></tr>';
			}
	
		
			
} else {
	echo 'Nie ma takiej klasy';
}


}
?>
			</table>
		</div>
	</div>
<br>


</div>


</div>

<div class="cBottom">
	<br /><font size="1">Copyright 2008-2009 <a href="http://amxx.pl" target="_blank">GuTeK & Miczu</a> v2.0</font><br />
	<br /><font size="1">Copyright 2010 <a href="http://cs-lod.prv.pl" target="_blank">Kajt</a> v2.1</font><br />
	<font size="1"><a href="http://" target="_blank"></a></font><br /><br />
</div>

</form>
</body>
</html>