<?php
                echo $resources->exp->kupExp1.'<br> ';


				
				echo  $resources->exp->kupExp2.'<ul><li>50 000 doświadczenia za 5 punktów</li><li>100 000 doświadczenia za 10 punktów</li><li>200 000 doświadczenia za 20 punktów</li><li>500 000 doświadczenia za 40 punktów</li></ul>';
				
				echo '<br>'.$resources->exp->kupExp3.' <br> ';
                

				echo '<form method="post" action="index.php?page=exp">';
				if($nr==1){
					
					echo 'Wybierz klasę: <br> ';
					echo '<select name="klasa" size="7">';
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
					echo '<option value="13">Arcymag - VIP</option>';
					echo '<option value="14">Magic Gladiator</option>';
					
					echo '<option value="15">Nekromanta</option>';
					echo '<option value="16">Witch doctor - VIP</option>';
					echo '<option value="17">Orc</option>';
					echo '<option value="18">Wampir - VIP</option>';
					echo '<option value="19">Harpia</option>';
					echo '<option value="20">Wilkołak</option>';
					echo '<option value="21">Upadły anioł </option>';
					
					echo '<option value="22">Łowca</option>';
					echo '<option value="23">Szary elf</option>';
					echo '<option value="24">Leśny elf</option>';
					echo '</select><br>';
				}
				
				if($nr==2 || $nr==4){
					echo '<form method="post" action="index.php?page=exp">';
					echo 'Wybierz klasę: <br> ';
					echo '<select name="klasa" size="7">';
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
					echo '<option value="16">Demon</option>';
					echo '<option value="17">Ghull</option>';
					echo '<option value="18">Troll</option>';
					
					echo '<option value="19">Inkwizytor</option>';
					echo '<option value="20">Kusznik</option>';
					echo '<option value="21">Lucznik </option>';
					echo '<option value="22">Strzelec krolewski</option>';
					echo '<option value="23">Mroczny elf</option>';
					echo '<option value="24">Heretyk</option>';
					echo '</select><br>';
				}
				
				if($nr==3){
					echo '<form method="post" action="index.php?page=exp">';
					echo 'Wybierz klasę: <br> ';
					echo '<select name="klasa" size="7">';
					echo '<option value="1">Argonian</option>';
					echo '<option value="2">Khajiit</option>';
					echo '<option value="3">Cesarski</option>';
					echo '<option value="4">Ork</option>';
					echo '<option value="5">Wysoki Elf</option>';
					echo '<option value="6">Breton</option>';
					echo '<option value="7">Mroczny Elf</option>';
					echo '</select><br>';
				}
				
				if($nr==5 || $nr==6){
					echo 'Zakupione doświadczenie doda się do doświadczenia postaci którą będziesz grał.';
				}
				if($nr==7){
					
					echo 'Wybierz klasę: <br> ';
					echo '<select name="klasa" size="7">';
					echo '<option value="1">Czarownik</option>';
					echo '<option value="2">Szaman</option>';
					echo '<option value="3">Paladyn</option>';
					echo '<option value="4">Mścicielka</option>';
					echo '<option value="5">Nekromanta</option>';
					echo '<option value="6">Barbarzyńca</option>';
					echo '<option value="7">Ninja</option>';
					echo '<option value="8">Łowczyni Demonów</option>';
					
					echo '<option value="9">Andariel</option>';
					echo '<option value="10">Duriel</option>';
					echo '<option value="11">Mephisto</option>';
					echo '<option value="12">Hefasto</option>';
					echo '<option value="13">Diablo</option>';
					echo '<option value="14">Baal</option>';
					echo '<option value="15">Upadły</option>';
					echo '<option value="16">Pan Jadu</option>';
					
					echo '<option value="17">Martwy Anioł</option>';
					echo '<option value="18">Mały Diabeł</option>';
					echo '<option value="19">Uwieziona Dusza</option>';
					echo '<option value="20">Rzygacz</option>';
					echo '<option value="21">Nietoperz </option>';
					echo '<option value="22">Król Pająków</option>';
					echo '<option value="23">Zimowy Potwór</option>';
					
					echo '<option value="24">Kowal z Tristram</option>';
					echo '<option value="25">Bronmistrz</option>';
					echo '<option value="26">Uczeń Diabła</option>';

					echo '</select><br>';
				}
                echo '<br>Wybierz ilość doświadczenia:  <br> ';
				
                echo '<select name="dosw" size="4">';
                if($pkt >= 5) echo '<option value="1">50 000 doświadczenia za 5 pkt</option>';
                if($pkt >= 10) echo '<option value="2">100 000 doświadczenia za 10 pkt</option>';
                if($pkt >= 20) echo '<option value="3">200 000 doświadczenia za 20 pkt</option>';
                if($pkt >= 40) echo '<option value="4">500 000 doświadczenia za 40 pkt</option>';
                echo '</select><br><br>';
				echo $resources->kupno->panel .'<br>';
				echo '<br><input type="submit" value="Kup"  />';

?>