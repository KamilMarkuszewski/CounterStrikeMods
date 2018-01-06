<?php
	echo '<div class="main">';
	include 'join.php';
	echo '<h3>'.$title.'</h3>';

	echo '<div class="inf">';
	if(isset($error)){
		echo'
			<div class="ui-widget">
				<div class="ui-state-error ui-corner-all" style="padding: 0 .7em;">
					<p><span class="ui-icon ui-icon-alert" style="float: left; margin-right: .3em;"></span>
					<strong>Błąd: </strong>'.$error.'</p>
				</div>
			</div>
		';
	}
	
	if(isset($info)){
		echo'
			<div class="ui-widget">
				<div class="ui-state-highlight ui-corner-all" style="margin-top: 20px; padding: 0 .7em;">
					<p><span class="ui-icon ui-icon-info" style="float: left; margin-right: .3em;"></span>
					<strong>Info: </strong>'.$info.'</p>
				</div>
			</div>
		';
	}
	echo '</div><br><br>';
	
	if(isset($page)){
		include 'pages/'.$file.'.php';
	}else{
		include 'pages/home.php';
	}

	echo '</div>';
?>