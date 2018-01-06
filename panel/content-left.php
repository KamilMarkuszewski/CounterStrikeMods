<?php
	
	if($stats && $nr!=5 && $nr!=6){
		
		echo '<div class="left stats"></div><div class="center stats">';
		
		echo '<br>';
		echo '<a href="index.php?page=stats&class=0">Wszystkie</a><br>';
		echo '<a href="index.php?page=charts">Wykresy</a><br>';
		echo '<a href="index.php?page=charts2">Wykresy ostatni miesiąc</a><br>';
		echo '<br>';
		if($nr==1 ){
			echo $rasy[0].':<br>';
			echo '<a href="index.php?page=stats&class=1">'.$klasy[0].'</a><br>';
			echo '<a href="index.php?page=stats&class=2">'.$klasy[1].'</a><br>';
			echo '<a href="index.php?page=stats&class=3">'.$klasy[2].'</a><br>';
			echo '<a href="index.php?page=stats&class=4">'.$klasy[3].'</a><br>';
			echo '<a href="index.php?page=stats&class=5">'.$klasy[4].'</a><br>';
			echo '<a href="index.php?page=stats&class=6">'.$klasy[5].'</a><br>';
			echo '<a href="index.php?page=stats&class=7">'.$klasy[6].'</a><br>';
			echo '<br>';
			echo '<br>';
			
			echo $rasy[1].':<br>';
			echo '<a href="index.php?page=stats&class=8">'.$klasy[7].'</a><br>';
			echo '<a href="index.php?page=stats&class=9">'.$klasy[8].'</a><br>';
			echo '<a href="index.php?page=stats&class=10">'.$klasy[9].'</a><br>';
			echo '<a href="index.php?page=stats&class=11">'.$klasy[10].'</a><br>';
			echo '<a href="index.php?page=stats&class=12">'.$klasy[11].'</a><br>';
			echo '<a href="index.php?page=stats&class=13">'.$klasy[12].'</a><br>';
			echo '<a href="index.php?page=stats&class=14">'.$klasy[13].'</a><br>';
			echo '<br>';
			echo '<br>';
			
			echo $rasy[2].':<br>';
			echo '<a href="index.php?page=stats&class=15">'.$klasy[14].'</a><br>';
			echo '<a href="index.php?page=stats&class=16">'.$klasy[15].'</a><br>';
			echo '<a href="index.php?page=stats&class=17">'.$klasy[16].' </a><br>';
			echo '<a href="index.php?page=stats&class=18">'.$klasy[17].'</a><br>';
			echo '<a href="index.php?page=stats&class=19">'.$klasy[18].'</a><br>';
			echo '<a href="index.php?page=stats&class=20">'.$klasy[19].'</a><br>';
			echo '<a href="index.php?page=stats&class=21">'.$klasy[20].'</a><br>';	
			echo '<br>';
			echo '<br>';
			
			echo $rasy[3].':<br>';
			echo '<a href="index.php?page=stats&class=22">'.$klasy[21].'</a><br>';
			echo '<a href="index.php?page=stats&class=23">'.$klasy[22].'</a><br>';
			echo '<a href="index.php?page=stats&class=24">'.$klasy[23].'</a><br>';

			echo '</div><div class="right stats" ></div>';
		}
		if($nr==2 || $nr==4 ){
			echo $rasy[0].':<br>';
			echo '<a href="index.php?page=stats&class=1">'.$klasy[0].'</a><br>';
			echo '<a href="index.php?page=stats&class=2">'.$klasy[1].'</a><br>';
			echo '<a href="index.php?page=stats&class=3">'.$klasy[2].'</a><br>';
			echo '<a href="index.php?page=stats&class=4">'.$klasy[3].'</a><br>';
			echo '<a href="index.php?page=stats&class=5">'.$klasy[4].'</a><br>';
			echo '<a href="index.php?page=stats&class=6">'.$klasy[5].'</a><br>';
			
			echo '<br>';
			echo '<br>';
			
			echo $rasy[1].':<br>';
			echo '<a href="index.php?page=stats&class=7">'.$klasy[6].'</a><br>';
			echo '<a href="index.php?page=stats&class=8">'.$klasy[7].'</a><br>';
			echo '<a href="index.php?page=stats&class=9">'.$klasy[8].'</a><br>';
			echo '<a href="index.php?page=stats&class=10">'.$klasy[9].'</a><br>';
			echo '<a href="index.php?page=stats&class=11">'.$klasy[10].'</a><br>';
			echo '<a href="index.php?page=stats&class=12">'.$klasy[11].'</a><br>';

			echo '<br>';
			echo '<br>';
			
			echo $rasy[2].':<br>';
			echo '<a href="index.php?page=stats&class=15">'.$klasy[12].'</a><br>';
			echo '<a href="index.php?page=stats&class=13">'.$klasy[13].'</a><br>';
			echo '<a href="index.php?page=stats&class=14">'.$klasy[14].'</a><br>';
			echo '<a href="index.php?page=stats&class=16">'.$klasy[15].'</a><br>';
			echo '<a href="index.php?page=stats&class=17">'.$klasy[16].' </a><br>';
			echo '<a href="index.php?page=stats&class=18">'.$klasy[17].'</a><br>';
			
			echo '<br>';
			echo '<br>';
			
			echo $rasy[3].':<br>';
			echo '<a href="index.php?page=stats&class=19">'.$klasy[18].'</a><br>';
			echo '<a href="index.php?page=stats&class=20">'.$klasy[19].'</a><br>';
			echo '<a href="index.php?page=stats&class=21">'.$klasy[20].'</a><br>';	
			echo '<a href="index.php?page=stats&class=22">'.$klasy[21].'</a><br>';
			echo '<a href="index.php?page=stats&class=23">'.$klasy[22].'</a><br>';
			echo '<a href="index.php?page=stats&class=24">'.$klasy[23].'</a><br>';

			echo '</div><div class="right stats" ></div>';
		}
		if($nr==3 ){

			echo '<a href="index.php?page=stats&class=1">'.$klasy[0].'</a><br>';
			echo '<a href="index.php?page=stats&class=2">'.$klasy[1].'</a><br>';
			echo '<a href="index.php?page=stats&class=3">'.$klasy[2].'</a><br>';
			echo '<a href="index.php?page=stats&class=4">'.$klasy[3].'</a><br>';
			echo '<a href="index.php?page=stats&class=5">'.$klasy[4].'</a><br>';
			echo '<a href="index.php?page=stats&class=6">'.$klasy[5].'</a><br>';
			echo '<a href="index.php?page=stats&class=7">'.$klasy[6].'</a><br>';
			echo '<br>';
			echo '<br>';
			
			echo '</div><div class="right stats" ></div>';
		}
		if($nr==7 ){
			echo $rasy[0].':<br>';
			echo '<a href="index.php?page=stats&class=1">'.$klasy[0].'</a><br>';
			echo '<a href="index.php?page=stats&class=2">'.$klasy[1].'</a><br>';
			echo '<a href="index.php?page=stats&class=3">'.$klasy[2].'</a><br>';
			echo '<a href="index.php?page=stats&class=4">'.$klasy[3].'</a><br>';
			echo '<a href="index.php?page=stats&class=5">'.$klasy[4].'</a><br>';
			echo '<a href="index.php?page=stats&class=6">'.$klasy[5].'</a><br>';
			echo '<a href="index.php?page=stats&class=7">'.$klasy[6].'</a><br>';
			echo '<a href="index.php?page=stats&class=8">'.$klasy[7].'</a><br>';
			
			echo '<br>';
			echo '<br>';
			
			echo $rasy[1].':<br>';			
			echo '<a href="index.php?page=stats&class=9">'.$klasy[8].'</a><br>';
			echo '<a href="index.php?page=stats&class=10">'.$klasy[9].'</a><br>';
			echo '<a href="index.php?page=stats&class=11">'.$klasy[10].'</a><br>';
			echo '<a href="index.php?page=stats&class=12">'.$klasy[11].'</a><br>';
			echo '<a href="index.php?page=stats&class=15">'.$klasy[12].'</a><br>';
			echo '<a href="index.php?page=stats&class=13">'.$klasy[13].'</a><br>';
			echo '<a href="index.php?page=stats&class=14">'.$klasy[14].'</a><br>';
			echo '<a href="index.php?page=stats&class=16">'.$klasy[15].'</a><br>';
			
			echo '<br>';
			echo '<br>';
			
			echo $rasy[2].':<br>';

			echo '<a href="index.php?page=stats&class=17">'.$klasy[16].' </a><br>';
			echo '<a href="index.php?page=stats&class=18">'.$klasy[17].'</a><br>';
			echo '<a href="index.php?page=stats&class=19">'.$klasy[18].'</a><br>';
			echo '<a href="index.php?page=stats&class=20">'.$klasy[19].'</a><br>';
			echo '<a href="index.php?page=stats&class=21">'.$klasy[20].'</a><br>';	
			echo '<a href="index.php?page=stats&class=22">'.$klasy[21].'</a><br>';
			echo '<a href="index.php?page=stats&class=23">'.$klasy[22].'</a><br>';
			
			echo '<br>';
			echo '<br>';
			
			echo $rasy[3].':<br>';

			echo '<a href="index.php?page=stats&class=24">'.$klasy[23].'</a><br>';
			echo '<a href="index.php?page=stats&class=25">'.$klasy[24].'</a><br>';
			echo '<a href="index.php?page=stats&class=26">'.$klasy[25].'</a><br>';

			echo '</div><div class="right stats" ></div>';
		}

		
	}else{
		if(!isset($_SESSION["$cookiesVar"])){
			echo '<div class="left log"></div><div class="center log">';
		echo '<br>';
			echo '
					<div class="c">
						<form action="sprawdz.php" method="post">
							<table>
								<tr><td>
									Login:
								</td><td>
									<input type="text" name="login" />
								</td></tr>
								<tr><td>							
									Hasło:
								</td><td>
									<input type="password" name="password" />
								</td></tr>
									
							</table>
							<input type="submit" value="Zaloguj się" class="submit"/><br>
						</form>
						<br>
						<a href="index.php?page=signup">Rejestracja</a>
						<br><a href="index.php?page=przypomnij">Przypomnij hasło</a>
					</div>
				';
			echo '</div><div class="right log" ></div>';

		}else{
			echo '<div class="left konto"></div><div class="center konto">';
			
							

			echo '<p>';
			echo '
				Twój login: '.$user.'<br>
				Twój nick: '.$nick.'<br>
				Twój email: '.$mail.'<br>
				<br>
				<a href="index.php?page=pukawka">Twoje punkty: '.$pkt.'</a><br>
				<a href="index.php?page=prezentowe">Punkty prezentowe: '.$prezentowe.'</a><br>
				';
            if($vip==1){
                echo '<br>';
				$date= date("d-m-Y",$vip_data);
				echo '<a href="index.php?page=vip">Masz konto Vip</a><br>'; 
				echo 'Do dnia: '.$date.'<br>'; 
            }
            if($vip==2){
                echo '<br>';
				$date= date("d-m-Y",$vip_data);
				echo '<a href="index.php?page=vippro">Masz konto VipPro</a><br>'; 
				echo 'Do dnia: '.$date.'<br>'; 
            }
            if($vip==3){
                echo '<br>';
				$date= date("d-m-Y",$vip_data);
				echo '<a href="index.php?page=vippro">Masz XP Boost</a><br>'; 
				echo 'Do dnia: '.$date.'<br>'; 
            }
            if($slot_data!=NULL){
                echo '<br>';
				$date= date("d-m-Y",$slot_data);
				echo '<a href="index.php?page=slot">Masz slota</a><br>'; 
				echo 'Do dnia: '.$date.'<br>'; 
            }

			echo '
				<br><br>
				Dziś jest: '.$today.'
				<br><br>
				<a href="index.php?page=settings">Ustawienia</a><br>
				<a href="wyloguj.php">Wyloguj</a><br>
				
			';
			

			echo '</p>';
			echo '</div><div class="right konto" ></div>';
		}
		
	}


?>
