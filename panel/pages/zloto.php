<?php

	echo 'Cennik:<ul><li>50 zlota za 5 pkt</li><li>100 zlota za 10 pkt</li><li>200 zlota za 20 pkt</li><li>500 zlota za 40 pkt</li></ul>';

    echo '<b>Pamiętaj, aby przed kupnem wyjść z gry!</b><br><br>';
                
    echo '<form method="post" action="index.php?page=zloto">';
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
                
                

    echo '<br>Wybierz ilość zlota:  <br> ';
    echo '<select name="dosw" size="4">';
    if($pkt >= 5) echo '<option value="1">50 zlota za 5 pkt</option>';
    if($pkt >= 10) echo '<option value="2">100 zlota za 10 pkt</option>';
    if($pkt >= 20) echo '<option value="3">200 zlota za 20 pkt</option>';
    if($pkt >= 40) echo '<option value="4">500 zlota za 40 pkt</option>';
    echo '</select><br>';
	echo '<br><input type="submit" value="Kup"  />';
	echo '</form>';

                


?>