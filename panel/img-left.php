<?php

	if($stats){
		echo '<img src="design/images/left_klasy.png">';
	}else{
		if(!isset($_SESSION["$cookiesVar"])){
			echo '<img src="design/images/left_logowanie.png">';
		}else{
			echo '<img src="design/images/left_konto.png">';
		}
		
	}
	

?>
