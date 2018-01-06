<?php include('engine.php');
$pla = $_GET['player'];
$pla = stripslashes($pla);
$checknick = mysql_query("SELECT `nick` from `$dbtable` where `nick`='$pla'");
if((mysql_num_rows($checknick) > 0)){
    echo $pla;                
}
?>

<?php
	mysql_close($sql_conn);
?>

