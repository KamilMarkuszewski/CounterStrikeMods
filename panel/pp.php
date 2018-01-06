
<?php
	if(isset($_GET["pp"])){

		$polecajacy = $_GET["pp"];
		setcookie('lod_pp', $polecajacy, time()+2592000); 
		$ppo = $_COOKIE['lod_pp'];
		echo $ppo;
	}	
?>
<META http-equiv="refresh" content="0; URL=http://www.cs-lod.com.pl/system/1/panel2">