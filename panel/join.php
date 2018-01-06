<?php
	
	if(isset($page)){
		$file = "blank";
		$title = "Witaj w panelu serwerów CS-LOD ".$nr;
		switch($page){
			case "signup":
				if(!isset($_SESSION["$cookiesVar"])){
					$title = "Rejestracja ";
					$file = $page;
				}else{
					echo '<META HTTP-EQUIV=Refresh CONTENT="0; URL=index.php?err=dontlog">';
					$file = "home";
				}
				break;
			case "sms":
				if(isset($_SESSION["$cookiesVar"])){
					$title = "Doładuj punkty - Sms homepay ";
					$file = $page;
				}else{
					echo '<META HTTP-EQUIV=Refresh CONTENT="0; URL=index.php?err=shouldlog">';
					$file = "home";
				}
				break;
			case "przelew":
				if(isset($_SESSION["$cookiesVar"])){
					$title = "Doładowanie konta przelewem homepay ";
					$file = $page;
				}else{
					echo '<META HTTP-EQUIV=Refresh CONTENT="0; URL=index.php?err=shouldlog">';
					$file = "home";
				}
				break;
			case "pukawka":
				if(isset($_SESSION["$cookiesVar"])){
					$title = "Doładuj punkty - Sms pukawka ";
					$file = $page;
				}else{
					echo '<META HTTP-EQUIV=Refresh CONTENT="0; URL=index.php?err=shouldlog">';
					$file = "home";
				}
				break;
			case "wiaderko":
				if(isset($_SESSION["$cookiesVar"])){
					$title = "Doładuj punkty - Sms wiaderko ";
					$file = $page;
				}else{
					echo '<META HTTP-EQUIV=Refresh CONTENT="0; URL=index.php?err=shouldlog">';
					$file = "home";
				}
				break;
			case "cssetti":
				if(isset($_SESSION["$cookiesVar"])){
					$title = "Doładuj punkty - Sms cs setti ";
					$file = $page;
				}else{
					echo '<META HTTP-EQUIV=Refresh CONTENT="0; URL=index.php?err=shouldlog">';
					$file = "home";
				}
				break;
			case "kody":
				if($nick==kajt ||$nick==Kajt){
					$file = $page;
					$title = "Sprawdzanie kodów sms pukawka ";
				}else{
					$file = "home";
					echo '<META HTTP-EQUIV=Refresh CONTENT="0; URL=index.php?err=shouldlog">';
				}
				break;
			case "vip":
				if(isset($_SESSION["$cookiesVar"])){
					$title = "Kupno - Kup konto VIP ";
					$file = $page;
				}else{
					echo '<META HTTP-EQUIV=Refresh CONTENT="0; URL=index.php?err=shouldlog">';
					$file = "home";
				}
				break;
			case "vippro":
				if(isset($_SESSION["$cookiesVar"])){
					$file = $page;
					$title = "Kupno - Kup konto VIP PRO";
				}else{
					echo '<META HTTP-EQUIV=Refresh CONTENT="0; URL=index.php?err=shouldlog">';
					$file = "home";
				}
				break;
			case "xpboost":
				if(isset($_SESSION["$cookiesVar"])){
					$title = "Kupno - Kup xp boost ";
					$file = $page;
				}else{
					echo '<META HTTP-EQUIV=Refresh CONTENT="0; URL=index.php?err=shouldlog">';
					$file = "home";
				}
				break;
			case "slot":
				if(isset($_SESSION["$cookiesVar"])){
					$file = $page;
					$title = "Kupno - Kup slota ";
				}else{
					echo '<META HTTP-EQUIV=Refresh CONTENT="0; URL=index.php?err=shouldlog">';
					$file = "home";
				}
				break;			
			case "exp":
				if(isset($_SESSION["$cookiesVar"])){
					$file = $page;
					$title = "Kupno - Kup doświadczenie ";
				}else{
					echo '<META HTTP-EQUIV=Refresh CONTENT="0; URL=index.php?err=shouldlog">';
					$file = "home";
				}
				break;
			case "shirt":
				if(isset($_SESSION["$cookiesVar"])){
					$file = $page;
					$title = "Kupno - Kup koszulkę ";
				}else{
					echo '<META HTTP-EQUIV=Refresh CONTENT="0; URL=index.php?err=shouldlog">';
					$file = "home";
				}
				break;
			case "prezentowe":
				if(isset($_SESSION["$cookiesVar"])){
					$file = $page;
					$title = "Punkty prezentowe ";
				}else{
					echo '<META HTTP-EQUIV=Refresh CONTENT="0; URL=index.php?err=shouldlog">';
					$file = "home";
				}
				break;
			case "rekl":
				$file = $page;
				$title = "Program partnerski - punkty za reklamę ";
				break;
			case "stats":
				$file = $page;
				$title = "Statystyki postaci ";
				break;
			case "charts":
				$file = $page;
				$title = "Wykresy ";
				break;
			case "charts2":
				$file = $page;
				$title = "Wykresy ostatni miesiąc ";
				break;
			case "res":
				if($nr==3 && isset($_SESSION["$cookiesVar"]) ){
					$file = $page;
					$title = "Kupno resetu statystyk postaci ";
				}else{
					echo '<META HTTP-EQUIV=Refresh CONTENT="0; URL=index.php?err=shouldlog">';
					$file = "home";
				}
				break;
			case "znak":
				if($nr==3 && isset($_SESSION["$cookiesVar"]) ){
					$file = $page;
					$title = "Kupno - Kup reset znaku ";
				}else{
					echo '<META HTTP-EQUIV=Refresh CONTENT="0; URL=index.php?err=shouldlog">';
					$file = "home";
				}
				break;
			case "zloto":
				if($nr==3 && isset($_SESSION["$cookiesVar"]) ){
					$file = $page;
					$title = "Kupno - Kup złoto ";
				}else{
					echo '<META HTTP-EQUIV=Refresh CONTENT="0; URL=index.php?err=shouldlog">';
					$file = "home";
				}
				break;
			case "settings":
				if(isset($_SESSION["$cookiesVar"]) ){
					$file = $page;
					$title = "Ustawienia konta ";
				}else{
					echo '<META HTTP-EQUIV=Refresh CONTENT="0; URL=index.php?err=shouldlog">';
					$file = "home";
				}
				break;
			case "promocyjne":
				if(isset($_SESSION["$cookiesVar"]) ){
					$file = $page;
					$title = "Doładuj punkty -  Kod promocyjny";
				}else{
					echo '<META HTTP-EQUIV=Refresh CONTENT="0; URL=index.php?err=shouldlog">';
					$file = "home";
				}
				break;
			case "przypomnij":
				if(!isset($_SESSION["$cookiesVar"])){
					$title = "Przypomnij hasło ";
					$file = $page;
				}else{
					echo '<META HTTP-EQUIV=Refresh CONTENT="0; URL=index.php?err=dontlog">';
					$file = "home";
				}
				break;
				break;
			case "przenies":
				if(isset($_SESSION["$cookiesVar"])){
					$title = "Przenies exp z klasy vip";
					$file = $page;
				}else{
					echo '<META HTTP-EQUIV=Refresh CONTENT="0; URL=index.php?err=shouldlog">';
					$file = "home";
				}
				break;
			default:
				$file = "blank";
				break;
		}
	}else{
		$title = "Witaj w panelu serwerów CS-LOD ".$nr;
	}
	





?>