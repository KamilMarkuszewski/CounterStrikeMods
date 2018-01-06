<?php
	require_once("functions.php");
	$config_homepay_usr_id=2;
	$config_homepay=array();
	// KONFIGURACJA
	// niech ACCID oznacza numer konta PRZELEW KOD w homepay
	// KWOTA to wartosc przelewu , NAZWA to nazwa uslugi
	// kolejne uslugi nalezy dopisywac wg schematu:
	// $config_homepay[ACCID]=array("acc_id"=>ACCID,"kwota"=>KWOTA)
	// czyli np.:
	// $config_homepay[123]=array("acc_id"=>123,"nazwa"=>NAZWA,"kwota"=>KWOTA);
	$config_homepay[]=array("acc_id"=>1240,"nazwa"=>"PRZELEW10","kwota"=>10.00,"pkt"=>25.00);
	$config_homepay[]=array("acc_id"=>1244,"nazwa"=>"PRZELEW20","kwota"=>20.00,"pkt"=>50.00);
	$config_homepay[]=array("acc_id"=>1242,"nazwa"=>"PRZELEW50","kwota"=>50.00,"pkt"=>130.00);
	// KONIEC KONFIGURACJI

?>