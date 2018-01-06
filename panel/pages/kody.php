<?php
	$sql = mysql_query("SELECT * from `sms` ");
    while ( $row = mysql_fetch_array($sql) ){
        $t_kod = $row['kod'];
        $t_user = $row['user'];
        $t_status = $row['status'];
        $t_dop = $row['dop'];
        $t_wart = $row['wart'];
        $t_pkt = $row['pkt'];
        $t_rekl = $row['rekl'];
        if($t_status==0){
            echo '<form action="index.php?page=kody" method="post">';
            echo '<br><input type="text" name="kod" value="'.$t_kod.'" size ="10" readonly /> ';
            echo '<input type="hidden" name="user" value="'.$t_user.'" /> ';
            echo '<input type="hidden" name="dop" value="'.$t_dop.'" /> ';
            echo '<input type="hidden" name="rekl" value="'.$t_rekl.'" /> ';
			echo ' ';
			echo '<select name="wart" size="4"> ';

			if($t_wart*3==$t_pkt) echo '<option value="'.$t_wart.'" selected>'.$t_wart.'</option> ';

			if($t_wart==2) echo '<option value="2" selected>3,14=6pkt</option>';
			else echo '<option value="2">3,14=6pkt</option>';

			if($t_wart==5) echo '<option value="5" selected>5,56=12pkt</option>';
			else echo '<option value="5">5,56=12pkt</option>';

			if($t_wart==11) echo '<option value="11" selected>11,92=26pkt</option>';
			else echo '<option value="11">11,92=26pkt</option>';

			if($t_wart==14) echo '<option value="14" selected>15,68=34pkt</option> ';
			else echo '<option value="14">15,68=34pkt</option> ';

			echo '</select>';

			echo ' ';
			echo '<select name="status" size="3">';
			echo '<option value="0" selected>Niezatwierdzone</option>';
			echo '<option value="1" >Zatwierdzone</option>';
			echo '<option value="2" >Odrzucone</option>';
			echo '</select> ';
			echo ' <input type="submit" value="Potwierdz" />';
			echo '</form>';
		}
    }



?>