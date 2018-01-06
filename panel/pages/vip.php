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
			
			echo 'Cena: 24 punkty<br><br>';
			echo '<br><br>';
		
			echo $resources->vip->kupVip1 .'<br> <ul>';
			echo '<li>'.$resources->vip->kupVip2.'</li> ';
			echo '<li>'.$resources->vipLod1->kupVip1.'</li></ul>';
		}

		if($nr==2 || $nr==4){
			
			echo 'Cena: 24 punkty<br><br>';
			echo '<br><br>';
		
			echo $resources->vip->kupVip1 .'<br> <ul>';
			echo '<li>'.$resources->vip->kupVip2.'</li> ';
			echo '<li>'.$resources->vipLod2->kupVip1.'</li></ul>';
		}	
		

		if($nr==3){
			
			echo 'Cena: 24 punkty<br><br>';
			echo '<br><br>';
		
			echo $resources->vip->kupVip1 .'<br> <ul>';
			echo '<li>'.$resources->vip->kupVip2.'</li> ';
			echo '<li>'.$resources->vipSkyrim->kupVip1.'</li> ';
			echo '<li>'.$resources->vipSkyrim->kupVip2.'</li></ul>';
		}	
		
		if($nr==5){
			
			echo 'Cena: 24 punkty<br><br>';
			echo '<br><br>';
		
			echo $resources->vip->kupVip1 .'<br> <ul>';
			echo '<li>'.$resources->vip->kupVip2.'</li> ';
			echo '<li>'.$resources->vipCod->kupVip1.'</li></ul>';
		}	
		
		
		if($nr==6){
			
			echo 'Cena: 24 punkty<br><br>';
			echo '<br><br>';
		
			echo $resources->vip->kupVip1 .'<br> <ul>';
			echo '<li>'.$resources->vip->kupVip2.'</li> ';
			echo '<li>Możliwość gry klasą Vip</li></ul>';
		}	
		if($nr==7){
			
			echo 'Cena: 24 punkty<br><br>';
			echo '<br><br>';
		
			echo $resources->vip->kupVip1 .'<br> <ul>';
			echo '<li>'.$resources->vip->kupVip2.'</li> ';
			echo '<li>'.$resources->vipD3->kupVip1.'</li></ul>';
		}
		
		echo '<br><br>'.$resources->vip->kupVip3.'<br><br>';
		echo $resources->kupno->panel .'<br><br>';
		echo '<form method="post" action="index.php?page=vip">';
		echo '<input type="hidden" name="kup" value="1" />';
					
		//echo '<script language="JavaScript" type="text/javascript" >	$(document).ready(function() { insertError("Tymczasowo wyłączone."); });</script>';	
		echo '<input type="submit" value="Kup"  />';
				   
		echo '</form>';
	}








?>