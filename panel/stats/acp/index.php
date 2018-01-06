<?php session_start(); 
include("../config.php"); 

?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html><head>





	<title>Diablo Mod Statystyki</title>
	<link href="img/main.css" rel="stylesheet" type="text/css">
	<style type="text/css">
.style1 {
	font-size: medium;
	font-weight: bold;
}

</style>
<meta http-equiv="content-type" content="text/html; charset=windows-1250">
</head><body bgcolor="#931818">
<div class="cTopBanner">
	<br>
	<a href="index.php"><img src="img/banner.png" alt="Diablo Mod PL" style="border: 0px none ;"></a>
</div>

<br>
<form action="" method="POST">
   Login: <input name="log" maxlength="32" type="text">
   Hasło: <input name="has" type=password>
   <input value="Zaloguj" name=check type="submit">
</form>			
<?
if(isset($_POST['check'])){
$lc= htmlspecialchars($_POST['log']);
$hc = htmlspecialchars($_POST['has']);
if($lc!= $admlogin & $h != $admhaslo or $lc == $admlogin & $hc != $admhaslo){
	echo 'Zły login lub hasło';
} else if ($lc == $admlogin & $hc == $admhaslo){
	session_register("zalogowany");
	echo 'Zalogowany. Zaraz przekieruje cię do panelu <META HTTP-EQUIV=Refresh CONTENT="2; URL=acp.php">';
	}

}		
?>	
<br>







<div class="cBottom">
	<br><font size="1">Powered by <a href="http://amxx.pl/" target="_blank">GuTeK &amp; Miczu</a> v2.0</font><br>
	<font size="1"><a href="http:///" target="_blank"></a></font><br><br>
</div>


</body></html>