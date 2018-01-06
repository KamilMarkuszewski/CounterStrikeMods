<?php
    $tmp_data = strtotime("+5 days",time());
    if($vip==1 || $vip==2 || $vip==3){
        $tmp_data = strtotime("+5 days",$vip_data);
    }

    $miesiac = date("d.m.Y",$tmp_data);
	echo 'Okres trwania: 5 dni<br><br>';
	echo 'Dzień zakończenia: '.$miesiac.'<br><br>';

	echo 'Cena: 10 punktów<br><br>';
	echo '<br><br>';	
	echo 'Xp Boost<br> <ul>';
	echo '<li> 50% szybszy exp</li> ';
	echo '<li> 1000$ co rundę </li></ul>';
		
    echo '<br><br>'.$resources->vip->kupVip3.'<br><br>';
    echo $resources->kupno->panel .'<br><br>';
    echo '<form method="post" action="index.php?page=xpboost">';
    echo '<input type="hidden" name="kup" value="3" />';
                
    echo '<input type="submit" value="Kup"  />';
               
    echo '</form>';
	
	 echo '<br><br><hr><br><br>';
	
	$tmp_data = strtotime("+31 days",time());
    if($vip==1 || $vip==2 || $vip==3){
        $tmp_data = strtotime("+31 days",$vip_data);
    }

    $miesiac = date("d.m.Y",$tmp_data);
	echo 'Okres trwania: 31 dni<br><br>';
	echo 'Dzień zakończenia: '.$miesiac.'<br><br>';

	echo 'Cena: 30 punktów<br><br>';
	echo '<br><br>';	
	echo 'Xp Boost<br> <ul>';
	echo '<li> 50% szybszy exp</li> ';
	echo '<li> 1000$ co rundę </li></ul>';
		
    echo '<br><br>'.$resources->vip->kupVip3.'<br><br>';
    echo $resources->kupno->panel .'<br><br>';
    echo '<form method="post" action="index.php?page=xpboost">';
    echo '<input type="hidden" name="kup" value="4" />';
                
    echo '<input type="submit" value="Kup"  />';
               
    echo '</form>';
?>