<?php

    echo 'Czas trwania: 90 dni<br><br>';
    echo 'Dzien zakonczenia: '.$miesiac.'<br><br>';
	echo 'Cena: 6 punktów<br><br>';
	echo '<br><br>';
		
    echo $resources->slot->kupSlota1 .'<br><br>';
    echo $resources->slot->kupSlota2 .'<br><br>';
    echo $resources->slot->kupSlota3 .'<br><br>';
	echo '<br><br>';
    echo '<form method="post" action="index.php?page=slot">';
	echo '<table><tr><td>';
    echo 'Nick: </td><td><input type="text" name="user"  readonly  value="'.$nick.'" /></td></tr><tr><td>';
    echo 'Hasło: </td><td><input type="text" name="haslo" /></td></tr></table>';

    echo '<input type="hidden" name="kup" value="1" /><br>';

    echo '<input type="submit" value="Kup"  />';

?>