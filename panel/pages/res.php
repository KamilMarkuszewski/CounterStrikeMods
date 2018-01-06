<?php
	echo 'Cena: 24pkt<br><br> ';
    echo 'Reset umiejętności i atrybutów.<br> Pamiętaj, że do 40 lvl reset w grze jest za darmo, a później za złoto!<br> Reset nie usuwa zaklęć!<br><Br>';
	echo '<b>Pamiętaj, aby przed kupnem wyjść z gry!</b><br><br>';
   
    echo '<form method="post" action="index.php?page=res">';
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
    echo '<br><input type="submit" value="Kup"  />';     
	echo '</form>';
                


?>