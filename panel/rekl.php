<script src="http://code.jquery.com/jquery-1.9.1.js"></script>
<script src="http://code.jquery.com/ui/1.10.3/jquery-ui.js"></script>


<style>
.scroll-pane { overflow: auto; width: 97%; float:left; height: 180px; }
.scroll-content { width: 600px; height: 170px; float: left; }
.scroll-bar-wrap { clear: left; padding: 0 4px 0 2px; margin: 0 -1px -1px -1px; }
.scroll-bar-wrap .ui-slider { background: none; border:0; height: 2em; margin: 0 auto; }
.scroll-bar-wrap .ui-handle-helper-parent { position: relative; width: 100%; height: 100%; margin: 0 auto; }
.scroll-bar-wrap .ui-slider-handle { top:.2em; height: 1.5em; }
.scroll-bar-wrap .ui-slider-handle .ui-icon { margin: -8px auto 0; position: relative; top: 50%; }
</style>

 <script>
 $(function() {
$( "#tabs" ).tabs();
});
</script>

<?php	
if(isset($_SESSION["$cookiesVar"]) && ($nr == 1 || $nr ==2) ){

	$query1 = "SELECT users.user, users.nick, users.registerData, lvl, lvl_for_points FROM `uzytkownicy` as users left outer join `dbmod_tablet` as dbmod ON dbmod.nick = users.nick WHERE `rekl` = '$user' AND dbmod.nick = users.nick ORDER by lvl desc";
	//echo $query1;
	$tab1a = array();
	$exec1 = mysql_query($query1)or die(mysql_error());
	while ($row = mysql_fetch_array($exec1)) {
		if(!in_array( $row[0], $tab1a)){
			$tab1a[] = $row[0];
			$tab1b[] = $row[1] ;
			$tab1c[] = $row[2] ;
			$tab1d[] = $row[3] ;
			$roznica = 0;
			if($row[3] > $row[4] + 75){
			
				//echo 'sprawdzam <br>';
				$roznica = $row[3] - $row[4];
				$roznica = floor($roznica/50);
				
				$isFirstSidUnique =mysql_result(mysql_query("SELECT isFirstSidUnique from `uzytkownicy` where `user`='$row[0]'"),isFirstSidUnique);
				$forP = $row[4] + $roznica * 50;
				
				$sidHis =mysql_result(mysql_query("SELECT `SID_PASS` from `dbmod_tablet` where `nick`='$row[1]' AND `klasa`= '1'"),SID_PASS);
				$sidFIRSTHis =mysql_result(mysql_query("SELECT `FIRST_SID` from `uzytkownicy` where `user`='$row[0]'"),FIRST_SID);

				if($isFirstSidUnique && $sidFIRSTHis == $sidHis)
				{
					$roznica *= 5;
				}
				
				$t_pkt = $pkt + $roznica;
				$pkt = $t_pkt;
				
				if($t_pkt >0){

					mysql_query("UPDATE `uzytkownicy` set `pkt`='$t_pkt' WHERE `user`='$user'");

					mysql_query("UPDATE `uzytkownicy` set `lvl_for_points`='$forP' WHERE `user`='$row[0]'");
					
					saveLogs(' podarowal za LVL '.$roznica.' pkt userowi '.$user . ' SID' . $isFirstSidUnique , $row[0], $row[1]);
					$ile = mysql_result(mysql_query("SELECT `pp_sum` from `uzytkownicy` where `user`='$user'"),pp_sum);
					$ile  = $ile + $roznica ;
					mysql_query("UPDATE `uzytkownicy` set `pp_sum`='$ile' WHERE `user`='$user'");
				}
				
			}
			$tab1e[] = $row[4] / 50 ;
		}
	}
}
?>




<div id="tabs">
<ul>
<li><a href="#tabs-1">Punkty za reklamę </a></li>
<li><a href="#tabs-2">Bannery reklamowe</a></li>
<li><a href="#tabs-3">Zdobyte punkty</a></li>
</ul>
<div id="tabs-1">
<p>
<?php
	echo $resources->programPartnerski->punktyZaReklame1 . '<br>
	' .$resources->programPartnerski->punktyZaReklame2. '<br><br>

		<br> '.$resources->programPartnerski->punktyZaReklame3. ' <br><br><br>
		'.$resources->programPartnerski->punktyZaReklame4. '
		<br>';   
          
    if(!isset($_SESSION["$cookiesVar"])){
		echo '<script language="JavaScript" type="text/javascript" >	$(document).ready(function() { insertError("Więcej informacji po zalogowaniu!"); });</script>';
	}else{
		echo '<br><br> '.$resources->programPartnerski->punktyZaReklamePoLog1 ; 
			  
		echo '<h4>';
		echo ' http://www.cs-lod.com.pl/pp.php?pp='.$user;
		echo '<br><br> http://www.cs-lod.com.pl/system/'.$nr.'/panel2/pp.php?pp='.$user;
		echo '</h4>';
		
		echo '<br>' .$resources->programPartnerski->punktyZaReklamePoLog2 .'<br>';
	}
?>

</p>
</div>
<div id="tabs-2">
<p>
<?php

 	
	echo '<br>'.$resources->programPartnerski->punktyZaReklamePoLog3.'<br><br>';
	echo '<div align="center">';
	
	echo '<img src="http://www.cs-lod.com.pl/system/banner/banner.gif"><br><br>';
	echo '<img src="http://www.cs-lod.com.pl/system/banner/lodbanner.gif"><br><br>';
	
	echo '<img src="http://cs-lod.com.pl/magazyn/bannery/button300x100.png"><br><br>';
	echo '<img src="http://cs-lod.com.pl/magazyn/bannery/button250x70.png"><br><br>';	
	
	
	
	
	echo '<img src="http://cs-lod.com.pl/magazyn/bannery/button%20200x200.png"><br><br>';
	
	echo ' <img src="http://cs-lod.com.pl/magazyn/bannery/button120x120.png"> ';
	
	echo ' <img src="http://cs-lod.com.pl/magazyn/bannery/banner100x100.gif"> ';
	
	echo ' <img src="http://cs-lod.com.pl/magazyn/bannery/button120x90.jpg"> ';
	
	echo ' <img src="http://cs-lod.com.pl/magazyn/bannery/button120x60.jpg"> ';
	
	
	
	echo ' <img src="http://cs-lod.com.pl/magazyn/bannery/button128x60.jpg"> ';
	
	
	
	
	
	

	
	
	echo '</div>';
 
?>
</p>
</div>
<div id="tabs-3">
<p>
<?php

if(isset($_SESSION["$cookiesVar"]) &&( $nr == 1 || $nr ==2 )){
	echo '<br>'.$resources->programPartnerski->punktyZaReklamePoLog4.'<br>'.$resources->programPartnerski->punktyZaReklamePoLog5.'<br>';
	
	/*
	echo '<div class="scroll-pane ui-widget ui-widget-header ui-corner-all">
			<div class="scroll-content" width="380">';
	*/
	echo '<div>
			<div width="400">';
	echo '<table width="600" align="center">
	<tr>
	<td width="120"> Nazwa Użytkownika  </td>
	<td width="120"> Nick  </td>
	<td width="120"> Data Rejestracji  </td>
	<td width="120"> Wbity Poziom  </td>
	<td width="120"> Otrzymane Punkty <br>(tylko za wbity level)  </td>
	</tr>
	';
	
		for( $x = 0, $cnt = count($tab1a); $x < $cnt; $x++ ){
			echo '<tr>'; 
			echo '<td > ' . $tab1a[$x] . '</td>';
			echo '<td > ' . $tab1b[$x] . '</td>';
			echo '<td > ' . $tab1c[$x] . '</td>';
			echo '<td > ' . $tab1d[$x] . '</td>';
			echo '<td > ' . $tab1e[$x] . '</td>';
			echo '</tr>';					   
		}
	

	
	
	echo '</table> ';
	/*
	echo '</div>
			<div class="scroll-bar-wrap ui-widget-content ui-corner-bottom">
			<div class="scroll-bar"></div>
			</div>
			</div>';
			*/
			
	echo '</div>
			</div>';
	
	$ile = mysql_result(mysql_query("SELECT `pp_sum` from `uzytkownicy` where `user`='$user'"),pp_sum);
	echo '<br><center><h2>Łącznie zdobyłeś ' .$ile . ' punktów</h2></center>';
	
}
	

?>
</p>
</div>
</div>



