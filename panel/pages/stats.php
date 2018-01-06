<?php
	if($nr==5 ||$nr==6){
		echo 'Brak statystyk dla tych serwerów.';
	}else{

		if($sql_conn) mysql_close($sql_conn);

		require( "stats/config.php" );
		$sql_conn = mysql_connect($dbhost , $dbuser, $dbpassword);
		mysql_select_db($dbname,$sql_conn);	
		echo '<link href="stats/main.css" rel="stylesheet" type="text/css">';
		
		if($_GET['szukaj'] != 'show'){
		
			echo '<form action="" method="POST">
				Wyszukaj gracza: <input name="player" type="text" MAXLENGTH="32" >
				<input  TYPE="submit" name="spr" VALUE="Szukaj">
				</form>';
		}
		$pla = $_POST['player'];
		$nick =$_GET['player'];
		$checknick = mysql_query("SELECT `nick` from `$dbtable` where `nick`='$pla'");
		if(isset($_POST['spr'])){
			if((mysql_num_rows($checknick) > 0)){
				echo '<META HTTP-EQUIV=Refresh CONTENT="1; URL=index.php?page=stats&player='.$pla.'">';	
				
			} else {
				echo '<br><b>Nie ma gracza o takim nicku.</b><br><br>';
				echo '<META HTTP-EQUIV=Refresh CONTENT="1; URL=index.php??page=stats&szukaj=show">';
			}
		}
		if($_GET['szukaj'] == 'show'){
			echo '<form action="" method="POST">
				Wyszukaj gracza: <input name="player" type="text" MAXLENGTH="32" >
				<input  TYPE="submit" name="spr" VALUE="Szukaj">
				</form>';
		}
		
		
		if($_GET['szukaj'] == 'show'){
			echo '<form action="" method="POST">
				Wyszukaj gracza: <input name="player" type="text" MAXLENGTH="32" >
				<input  TYPE="submit" name="spr" VALUE="Szukaj">
				</form>';
		}
		echo '<br><br>';
		if($nick != '')	{

			if($nr==1 || $nr==2 || $nr==4 || $nr==7 ){
				echo '<div class="cMain">
					<tr>Postacie gracza: <b>'.$nick.'</b></tr>
					<div class="cPlayers_Inner1">
					<tr style="height:4px; background-color:#ffffff; font-size:4px;"><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>
						<table width="100%" border="0" cellpadding="0" cellspacing="0" class="tbl-players">
							<tr class="tbl-hdr">
								<td>Klasa</td>
								<td>Poziom</td>
								<td>Exp</td>
								<td>Siła</td>
								<td>Zwinność</td>
								<td>Inteligencja</td>
								<td>Zręczność</td>

							</tr>
							<tr style="height:4px; background-color:#ffffff; font-size:4px;"><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>
				';	
			} else if($nr==3){
				echo '<div class="cMain">
					<tr>Postacie gracza: <b>'.$nick.'</b></tr>
					<div class="cPlayers_Inner1">
					<tr style="height:4px; background-color:#ffffff; font-size:4px;"><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>
						<table width="100%" border="0" cellpadding="0" cellspacing="0" class="tbl-players">
							<tr class="tbl-hdr">
								<td>Klasa</td>
								<td>Poziom</td>
								<td>Exp</td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>

							</tr>
							<tr style="height:4px; background-color:#ffffff; font-size:4px;"><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>
				';				
			}
			
			$a =0;
			$i = 0;
			$player = "SELECT * from $dbtable where nick='$nick'  ORDER BY klasa";
			$query2 = mysql_query($player)or die(mysql_error());
			while ($row = mysql_fetch_array($query2)) {
					
					$a++;
					++$i;
					if($a % 2 == 0){
					echo '<tr class ="tbl-shade2">';
					} else {
						echo '<tr class ="tbl-shade3">';
					}

					if($nr==1 || $nr==2 || $nr==4 ){
						if($i==1){$pclass =$klasy[0];} 
						else if($i==2){$pclass =$klasy[1];} 
						else if ($i==3){$pclass =$klasy[2];}
						else if($i==4){ $pclass =$klasy[3];}
						else if($i==5){$pclass =$klasy[4];} 
						else if($i==6){$pclass =$klasy[5];}
						else if($i==7){ $pclass =$klasy[6];} 
						
						else if($i==8){$pclass =$klasy[7];} 
						else if($i==9){$pclass =$klasy[8];} 
						else if ($i==10){$pclass =$klasy[9];}
						else if($i==11){ $pclass =$klasy[10];}
						else if($i==12){$pclass =$klasy[11];} 
						else if($i==13){$pclass =$klasy[12];}
						else if($i==14){ $pclass =$klasy[13];} 
						
						
						else if($i==15){$pclass =$klasy[14];} 
						else if($i==16){$pclass =$klasy[15];} 
						else if ($i==17){$pclass =$klasy[16];}
						else if($i==18){ $pclass =$klasy[17];}
						else if($i==19){$pclass =$klasy[18];} 
						else if($i==20){$pclass =$klasy[19];}
						else if($i==21){ $pclass =$klasy[20];} 
						
						else if($i==22){$pclass =$klasy[21];} 
						else if($i==23){$pclass =$klasy[22];}
						else if($i==24){$pclass =$klasy[23];}
					} else if($nr==7 ){
						if($i==1){$pclass =$klasy[0];} 
						else if($i==2){$pclass =$klasy[1];} 
						else if ($i==3){$pclass =$klasy[2];}
						else if($i==4){ $pclass =$klasy[3];}
						else if($i==5){$pclass =$klasy[4];} 
						else if($i==6){$pclass =$klasy[5];}
						else if($i==7){ $pclass =$klasy[6];} 
						
						else if($i==8){$pclass =$klasy[7];} 
						else if($i==9){$pclass =$klasy[8];} 
						else if ($i==10){$pclass =$klasy[9];}
						else if($i==11){ $pclass =$klasy[10];}
						else if($i==12){$pclass =$klasy[11];} 
						else if($i==13){$pclass =$klasy[12];}
						else if($i==14){ $pclass =$klasy[13];} 
						
						
						else if($i==15){$pclass =$klasy[14];} 
						else if($i==16){$pclass =$klasy[15];} 
						else if ($i==17){$pclass =$klasy[16];}
						else if($i==18){ $pclass =$klasy[17];}
						else if($i==19){$pclass =$klasy[18];} 
						else if($i==20){$pclass =$klasy[19];}
						else if($i==21){ $pclass =$klasy[20];} 
						
						else if($i==22){$pclass =$klasy[21];} 
						else if($i==23){$pclass =$klasy[22];}
						else if($i==24){$pclass =$klasy[23];}
						else if($i==25){$pclass =$klasy[24];}
						else if($i==26){$pclass =$klasy[25];}
						else{ break; }

					} else if($nr==3){
						if($i==1){$pclass =$klasy[0];} 
						else if($i==2){$pclass =$klasy[1];} 
						else if ($i==3){$pclass =$klasy[2];}
						else if($i==4){ $pclass =$klasy[3];}
						else if($i==5){$pclass =$klasy[4];} 
						else if($i==6){$pclass =$klasy[5];}
						else if($i==7){ $pclass =$klasy[6];} 
					}

				
											
					echo '<td>'.$pclass.'</td>';
					echo "<td>".$row["lvl"].'</td>';
					echo "<td>".$row["exp"].'</td>';
					echo "<td>".$row["str"].'</td>';
					echo "<td>".$row["dex"].'</td>';
					echo "<td>".$row["int"].'</td>';
					echo "<td>".$row["agi"].'</td>';
					echo '</tr>';
			}
			echo '</table></div></div>';
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
							<tr style="height:4px; background-color:#ffffff; font-size:4px;"><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>';
				$a =0;
				$i = 1;
				$queryall = mysql_query("SELECT * from $dbtable ORDER BY lvl DESC, exp DESC limit 0,$ile")or die(mysql_error());
				while ($rall = mysql_fetch_array($queryall)) {
					
					$a++;

					
					if($nr==1 || $nr==2 || $nr==4 ){
						if($rall["klasa"]==1){$pclass =$klasy[0];} 
						else if($rall["klasa"]==2){$pclass =$klasy[1];} 
						else if ($rall["klasa"]==3){$pclass =$klasy[2];}
						else if($rall["klasa"]==4){ $pclass =$klasy[3];}
						else if($rall["klasa"]==5){$pclass =$klasy[4];} 
						else if($rall["klasa"]==6){$pclass =$klasy[5];}
						else if($rall["klasa"]==7){ $pclass =$klasy[6];} 
						
						else if($rall["klasa"]==8){$pclass =$klasy[7];} 
						else if($rall["klasa"]==9){$pclass =$klasy[8];} 
						else if ($rall["klasa"]==10){$pclass =$klasy[9];}
						else if($rall["klasa"]==11){ $pclass =$klasy[10];}
						else if($rall["klasa"]==12){$pclass =$klasy[11];} 
						else if($rall["klasa"]==13){$pclass =$klasy[12];}
						else if($rall["klasa"]==14){ $pclass =$klasy[13];} 
						
						
						else if($rall["klasa"]==15){$pclass =$klasy[14];} 
						else if($rall["klasa"]==16){$pclass =$klasy[15];} 
						else if ($rall["klasa"]==17){$pclass =$klasy[16];}
						else if($rall["klasa"]==18){ $pclass =$klasy[17];}
						else if($rall["klasa"]==19){$pclass =$klasy[18];} 
						else if($rall["klasa"]==20){$pclass =$klasy[19];}
						else if($rall["klasa"]==21){ $pclass =$klasy[20];} 
						
						else if($rall["klasa"]==22){$pclass =$klasy[21];} 
						else if($rall["klasa"]==23){$pclass =$klasy[22];}

					} else if($nr==7){
						if($rall["klasa"]==1){$pclass =$klasy[0];} 
						else if($rall["klasa"]==2){$pclass =$klasy[1];} 
						else if ($rall["klasa"]==3){$pclass =$klasy[2];}
						else if($rall["klasa"]==4){ $pclass =$klasy[3];}
						else if($rall["klasa"]==5){$pclass =$klasy[4];} 
						else if($rall["klasa"]==6){$pclass =$klasy[5];}
						else if($rall["klasa"]==7){ $pclass =$klasy[6];} 
						
						else if($rall["klasa"]==8){$pclass =$klasy[7];} 
						else if($rall["klasa"]==9){$pclass =$klasy[8];} 
						else if ($rall["klasa"]==10){$pclass =$klasy[9];}
						else if($rall["klasa"]==11){ $pclass =$klasy[10];}
						else if($rall["klasa"]==12){$pclass =$klasy[11];} 
						else if($rall["klasa"]==13){$pclass =$klasy[12];}
						else if($rall["klasa"]==14){ $pclass =$klasy[13];} 
						
						
						else if($rall["klasa"]==15){$pclass =$klasy[14];} 
						else if($rall["klasa"]==16){$pclass =$klasy[15];} 
						else if ($rall["klasa"]==17){$pclass =$klasy[16];}
						else if($rall["klasa"]==18){ $pclass =$klasy[17];}
						else if($rall["klasa"]==19){$pclass =$klasy[18];} 
						else if($rall["klasa"]==20){$pclass =$klasy[19];}
						else if($rall["klasa"]==21){ $pclass =$klasy[20];} 
						
						else if($rall["klasa"]==22){$pclass =$klasy[21];} 
						else if($rall["klasa"]==23){$pclass =$klasy[22];}
						else if($rall["klasa"]==24){$pclass =$klasy[23];} 
						else if($rall["klasa"]==25){$pclass =$klasy[24];}
						else if($rall["klasa"]==26){$pclass =$klasy[25];} 

					} else if($nr==3){
						if($rall["klasa"]==1){$pclass =$klasy[0];} 
						else if($rall["klasa"]==2){$pclass =$klasy[1];} 
						else if ($rall["klasa"]==3){$pclass =$klasy[2];}
						else if($rall["klasa"]==4){ $pclass =$klasy[3];}
						else if($rall["klasa"]==5){$pclass =$klasy[4];} 
						else if($rall["klasa"]==6){$pclass =$klasy[5];}
						else if($rall["klasa"]==7){ $pclass =$klasy[6];} 
					}
					
							
					
					
					if($a % 2 == 0){
						echo '<tr class ="tbl-shade2">';
					} else {
						echo '<tr class ="tbl-shade3">';
					}
					echo "<td>" . $i++ . "</td>";
					echo '<td><b><a href="index.php?page=stats&player='.$rall["nick"].'">'.$rall["nick"].'</a></b></td>';
					echo '<td>'.$pclass.'</td>';
					echo "<td>".$rall["lvl"].'</td>';
					echo "<td>".$rall["exp"].'</td></tr>';
				}
				
			}
				
			if($class <= 26){
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
							<tr style="height:4px; background-color:#ffffff; font-size:4px;"><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>
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
					echo '<td><b><a href="index.php?page=stats&player='.$row["nick"].'">'.$row["nick"].'</a></b></td>';
					echo "<td>".$row["lvl"].'</td>';
					echo "<td>".$row["exp"].'</td></tr>';
				}
				echo '</table></div></div>';

			} else {
				echo 'Nie ma takiej klasy';
			}
		}

		mysql_close($sql_conn);
	}

?>



