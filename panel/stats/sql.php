<?
$sql_conn = mysql_connect($dbhost , $dbuser, $dbpassword);
mysql_select_db($dbname);
$class = $_GET['class'];

$sql = "SELECT exp,lvl,nick from dbmod_tables where klasa ='$class' ORDER BY lvl,exp ";
$query = mysql_query($sql);
while (mysql_fetch_row($query)) {
	$nick = mysql_result($query, 3);
	$lvl2 = mysql_query($sql_conn,"SELECT lvl FROM $dbtable WHERE nick = '$nick' and klasa = '$class'");
	$lvl = mysql_result($lvl2, 1);
	$exp2 = mysql_query($sql_conn,"SELECT exp FROM $dbtable WHERE nick = '$nick.' and klasa = '$class'");
	$exp = mysql_result($exp2, 1);
		
}

?>