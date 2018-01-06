<?php   

	if($maxVipLvl <= 75){
		echo '<script language="JavaScript" type="text/javascript" >	$(document).ready(function() { insertError("Vipy wyłączone dla nowych graczy."); });</script>';	
	}else{
		$tmp_data = strtotime("+31 days",time());
		if($vip==1 || $vip==2 || $vip==3){
			$tmp_data = strtotime("+31 days",$vip_data);
		}

		$miesiac = date("d.m.Y",$tmp_data);
		echo 'Okres trwania: 30 dni<br><br>';
		echo 'Dzień zakończenia: '.$miesiac.'<br><br>';
		
		
		if($nr==1){
			
			echo 'Cena: 33 punkty<br><br>';
			echo '<br><br>';
		
			echo $resources->vipPro->kupVipPro1 .'<br> <ul>';
			echo '<li>'.$resources->vipPro->kupVipPro2.'</li> ';
			echo '<li>'.$resources->vipPro->kupVipPro3.'</li> ';
			echo '<li>'.$resources->vipProLod1->kupVipPro1.'</li> ';
		}

		if($nr==2 || $nr==4){
			
			echo 'Cena: 55 punkty<br><br>';
			echo '<br><br>';
		
			echo $resources->vipPro->kupVipPro1 .'<br> <ul>';
			echo '<li>'.$resources->vipPro->kupVipPro2.'</li> ';
			echo '<li>'.$resources->vipPro->kupVipPro3.'</li> ';
			echo '<li>'.$resources->vipProLod2->kupVipPro1.'</li> ';
		}	
		

		if($nr==3){
			
			echo 'Cena: 33 punkty<br><br>';
			echo '<br><br>';
		
			echo $resources->vipPro->kupVipPro1 .'<br> <ul>';
			echo '<li>'.$resources->vipPro->kupVipPro2.'</li> ';
			echo '<li>'.$resources->vipProSkyrim->kupVipPro1.'</li> ';
			echo '<li>'.$resources->vipProSkyrim->kupVipPro2.'</li> ';
		}	
		
		if($nr==5){
			
			echo 'Cena: 33 punkty<br><br>';
			echo '<br><br>';
		
			echo $resources->vipPro->kupVipPro1 .'<br> <ul>';
			echo '<li>'.$resources->vipPro->kupVipPro2.'</li> ';
			echo '<li>'.$resources->vipPro->kupVipPro3.'</li> ';
			echo '<li>'.$resources->vipProCod->kupVipPro1.'</li> ';
		}	
		
		
		if($nr==6){
			
			echo 'Cena: 33 punkty<br><br>';
			echo '<br><br>';
		
			echo $resources->vipPro->kupVipPro1 .'<br> <ul>';
			echo '<li>'.$resources->vipPro->kupVipPro2.'</li> ';
			echo '<li>Możliwość gry klasą Vip</li></ul>';
		}	
		
		if($nr==7){
			
			echo 'Cena: 33 punkty<br><br>';
			echo '<br><br>';
		
			echo $resources->vipPro->kupVipPro1 .'<br> <ul>';
			echo '<li>'.$resources->vipPro->kupVipPro2.'</li> ';
			echo '<li>'.$resources->vipPro->kupVipPro3.'</li> ';
			echo '<li>'.$resources->vipProD3->kupVipPro1.'</li> ';
		}

		echo '</ul>';
		echo '<br><br>'.$resources->vipPro->kupVipPro4.'<br><br>';
		echo  $resources->kupno->panel .'<br><br>';
		echo '<form method="post" action="index.php?page=vippro">';
		echo '<input type="hidden" name="kup" value="1" />';

		echo '<script language="JavaScript" type="text/javascript" >	$(document).ready(function() { insertError("Tymczasowo wyłączone."); });</script>';	
		//echo '<input type="submit" value="Kup"  />';


		echo '</form>';
	}

?>