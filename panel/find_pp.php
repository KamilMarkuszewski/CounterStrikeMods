<?php include('engine.php');
$pla = $_GET['pp'];
$dla = $_GET['dla'];
$pla = stripslashes($pla);

$querypp = mysql_query("SELECT * FROM uzytkownicy WHERE `user` = '$pla' ");
$fetchpp = mysql_fetch_array($querypp);

if($fetchpp && isNickSamePerson($pla, $dla)){
	echo -1;
}else if($fetchpp){
    echo $pla;                
}
?>

<?php
	mysql_close($sql_conn);
?>

