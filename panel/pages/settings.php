<script language="JavaScript" type="text/javascript" >
function validateEmail(email) 
{
    var re = /\S+@\S+\.\S+/;
    return re.test(email);
}

	$(document).ready(function() { 

		$('form#changeMail').submit(function() {
			var fPass = $('input#passMail').attr('value');
			var eMail = $('input#eMail').attr('value');
			var eMailPowt = $('input#eMailPowt').attr('value');

			if(fPass.length < 4 ){
				insertError("Za krótke hasło");
				return false;
			}
			
			if(fPass.length > 20 ){
				insertError("Za długie hasło");
				return false;
			}
			

			if(eMail.length > 60 ){
				insertError("Za długi email");
				return false;
			}
			
			if(eMail != eMailPowt ){
				insertError("Podane emaile są różne!");
				return false;
			}
			
			if(! validateEmail(eMail)  ){
				insertError("To nie jest poprawny adres email!");
				return false;
			}
			
		});
		
		
		$('form#changePass').submit(function() {
			var fPass = $('input#passFinal').attr('value');
			var fPassPowt = $('input#passFinalPowt').attr('value');
			var fPassOld = $('input#passOld').attr('value');

			if(fPass.length < 4 ){
				insertError("Za krótke hasło");
				return false;
			}
			
			if(fPass.length > 20 ){
				insertError("Za długie hasło");
				return false;
			}

			if(fPass != fPassPowt ){
				insertError("Podane hasła są różne!");
				return false;
			}
				
			

		});
		
		$('form#changeSID').submit(function() {
			var fPass = $('input#eSID').attr('value');
			var SPowt = $('input#eSIDPowt').attr('value');
			var fPassOld = $('input#passSid').attr('value');

			if(fPass.length < 4 ){
				insertError("Za krótki SID");
				return false;
			}
			
			if(fPass.length > 19 ){
				insertError("Za długi SID");
				return false;
			}
			
			if( fPass.indexOf("STEAM") == -1  ){
				insertError("SID niepoprawny");
				return false;
			}

			if(fPass != SPowt ){
				insertError("Podane SID są różne!");
				return false;
			}
		});
		
		$('form#changeNickPass').submit(function() {
			var fPass = $('input#passNick').attr('value');
			var SPowt = $('input#passNickPowt').attr('value');
			var fPassOld = $('input#passSid').attr('value');

			if(fPass.length < 4 ){
				insertError("Za krótke hasło");
				return false;
			}
			
			if(fPass.length > 18 ){
				insertError("Za długie hasło");
				return false;
			}

			if(fPass != SPowt ){
				insertError("Podane hasła są różne!");
				return false;
			}
		});
	
	});



</script>
<?php

		$srn_sql_conn = mysql_connect($srn_dbhost , $srn_dbuser, $srn_dbpassword);
		mysql_select_db($srn_dbname,$srn_sql_conn);   
		ini_set(‘error_reporting’, 0);
		$srn_p = @mysql_result(mysql_query("SELECT password from `srn_reservations` where `nick`='$nick'"),password);
		$sql_conn = mysql_connect($dbhost , $dbuser, $dbpassword);
		mysql_select_db($dbname,$sql_conn);    
	
?>

<table >
<tr>
	<td width=350 valign="top">

		<h3>1. Zmiana hasła</h3>

		<form method="post" action="changePass.php" id="changePass" name="changePass" >
		<table>
		<tr><td>
			Stare hasło: 
			</td><td>
			<input type="password" name="passOld"  id="passOld"/> <br>
		</td></tr>
		<tr><td> </td><td> </td></tr>
		<tr><td> </td><td> </td></tr>
		<tr><td> </td><td> </td></tr>
		<tr><td> </td><td> </td></tr>
		<tr><td>
			Nowe hasło: 
			</td><td>
			<input type="password" name="passFinal" id="passFinal"/> <br>
		</td></tr>
		<tr><td>
			Powtórz nowe hasło: 
			</td><td>
			<input type="password" name="passFinalPowt" id="passFinalPowt"/> <br>
		</td></tr>


		</table>
		<br><br>
		<?php echo $resources->przypomnijHaslo->zmianaHasla1; ?>

		<br><br>
		<input type="submit" id="passCh" name="passCh" value="Zmień hasło" />
		</form>
		<br><br>
		
	</td>
	<td width=350 valign="top">


		<h3>2. Zmiana e-maila</h3>


		<form method="post" action="changeMail.php" id="changeMail" name="changeMail" >
		<table>
		<tr><td>
			Hasło: 
			</td><td>
			<input type="password" name="passMail" id="passMail"/> <br>
		</td></tr>
		<tr><td> </td><td> </td></tr>
		<tr><td> </td><td> </td></tr>
		<tr><td> </td><td> </td></tr>
		<tr><td> </td><td> </td></tr>
		<tr><td>
			E-mail:
			</td><td>
			<input type="text" name="eMail" id="eMail"/><br>
		</td></tr>
		<tr><td>
			Powtórz e-mail:
			</td><td>
			<input type="text" name="eMailPowt" id="eMailPowt"/><br>
		</td></tr>
		</table>
		<br><br>
		<?php echo $resources->przypomnijHaslo->zmianaHasla1; ?>

		<br><br>
		<input type="submit" id="mailFinal" name="mailFinal" value="Zmień e-mail" />
		</form>
		<br><br>
		
	</td>
</tr>
<tr>
	<td width=350 valign="top">

		<h3>3. Zmiana hasła rezerwacji nicku</h3>
		<br>

		<br><br>
		<?php
			if($_POST && isset($_POST['passNick'])){
				$hasłoNICK = $_POST['passNick'];
				$pass = $_POST['passSid']; 
				$passSRN = $_POST['passSRN']; 
				if (  md5( $pass)  == $passKonto) // jesli haslo sie zgadza
				{
					$srn_sql_conn = mysql_connect($srn_dbhost , $srn_dbuser, $srn_dbpassword);
					mysql_select_db($srn_dbname,$srn_sql_conn);   
					ini_set(‘error_reporting’, 0);
					$srn_p = @mysql_result(mysql_query("SELECT password from `srn_reservations` where `nick`='$nick'"),password);
					
					if (  md5($passSRN)  == $srn_p || $srn_p  == "" || $srn_p  == null) // jesli haslo sie zgadza
					{						
						mysql_query("DELETE FROM `srn_reservations` WHERE `nick`='$nick' ");
						$sql_conn = mysql_connect($dbhost , $dbuser, $dbpassword);
						mysql_select_db($dbname,$sql_conn);    
						$hasłoNICK = md5($hasłoNICK);
						saveLogs(' zmienia hasło rezerwacji ', $user, $nick);
						mysql_query("UPDATE `dbmod_tablet` set `PASS_PASS`='$hasłoNICK' WHERE `klasa`='1' AND `nick`='$nick' ");
						$first_pass_old = @mysql_result(mysql_query("SELECT `FIRST_PASS` from `uzytkownicy` where `ide`='$myid'"),FIRST_PASS);
						if($first_pass_old == null){
							$t_pkt = $pkt + 4;
							mysql_query("UPDATE `uzytkownicy` set `pkt`='$t_pkt' WHERE `ide`='$myid' ");
						}
						mysql_query("UPDATE `uzytkownicy` set `FIRST_PASS`='$hasłoNICK' WHERE `ide`='$myid' AND `FIRST_PASS` is NULL ");
						
						echo '<script language="JavaScript" type="text/javascript" >	$(document).ready(function() { insertInfo("Hasło zostalo zmienione, stara rezerwacja została usunięta!"); });</script>';
					}
					else
					{
						echo '<META HTTP-EQUIV=Refresh CONTENT="0; URL=index.php?err=wrongpassSRN">';
					}
				}
				else
				{
				  echo '<META HTTP-EQUIV=Refresh CONTENT="0; URL=index.php?err=wrongpass">';
				}
			}


			echo '
					<form method="post" action="index.php?page=settings" id="changeNickPass" name="changeNickPass" >
					<table>

					<tr><td>
						Hasło do sklepu: 
						</td><td>
						<input type="password" name="passSid" id="passSid"/> <br>
					</td></tr>';
			if(!($srn_p == "" || $srn_p == null))
			{
			echo '
					<tr><td>
						Hasło do rezerwacji SRN: 
						</td><td>
						<input type="password" name="passSRN" id="passSRN"/> <br>
					</td></tr>
			';
			}
			
					
			echo '
					<tr><td>
						Hasło: 
						</td><td>
						<input type="password" name="passNick" id="passNick"/> <br>
					</td></tr>
					<tr><td>
						Powtórz hasło: 
						</td><td>
						<input type="password" name="passNickPowt" id="passNickPowt"/> <br>
					</td></tr>
					</table>
					<br><br>'
					. $resources->przypomnijHaslo->zmianaHasla1 .

					'<br><br>
					<input type="submit" id="passNickFinal" name="passNickFinal" value="Zmień hasło" />
					</form>
					
					Po przypisaniu hasła rezerwacji nicku,<br> w grze będzie można wejść tylko podając to hasło.
					<br><br>
					Po przypisaniu hasła rezerwacji nicku,<br> będzie można zmienić hasło,<br> ale nie usunąć je.
					<br><br>
					Przypisanie hasła USUNIE hasło w starej rezerwacji nicków.
					<br>
			';		

		?>
		
		<br><br>
	</td>
	<td width=350 valign="top">
	
		<h3>4. Przypisanie steam do konta </h3>
		<br>
		<?php echo " Aktualny steam id: ".$sid; ?>
		<br><br>

		<form method="post" action="changeSID.php" id="changeSID" name="changeSID" >
		<table>
		<tr><td>
			Hasło do sklepu: 
			</td><td>
			<input type="password" name="passSid" id="passSid"/> <br>
		</td></tr>
		<?php
		if(!($srn_p == "" || $srn_p == null))
		{
		?>
			<tr><td>
				Hasło do rezerwacji SRN: 
				</td><td>
				<input type="password" name="passSRN" id="passSRN"/> <br>
			</td></tr>
		<?php
		}
		?>
		<tr><td> </td><td> </td></tr>
		<tr><td> </td><td> </td></tr>
		<tr><td> </td><td> </td></tr>
		<tr><td> </td><td> </td></tr>
		<tr><td>
			STEAM ID:
			</td><td>
			<input type="text" name="eSID" id="eSID"/><br>
		</td></tr>
		<tr><td>
			Powtórz STEAM ID:
			</td><td>
			<input type="text" name="eSIDPowt" id="eSIDPowt"/><br>
		</td></tr>
		</table>
		<br><br>
		<?php echo $resources->przypomnijHaslo->zmianaHasla1; ?>

		<br><br>
		<input type="submit" id="SIDFinal" name="SIDFinal" value="Przypisz SID" />
		</form>
		Po przypisaniu steam na konto w grze<br> będzie można wejść tylko z tego SID.
		<br><br>
		Po przypisaniu steam,<br> będzie można zmienić przypisany SID,<br> ale nie usunąć go.
		<br>
		<br><br>
	
	</td>
</tr>

<tr>
	<td width=350 valign="top">
	
	
		<h3>5. Zmiana hasła slota</h3>

		<?php
			if($_POST && isset($_POST['passSlot']) && $slot_data > 0){
				$hasłoSL = $_POST['passSlot'];
				saveLogs(' zmienia hasło slota ', $user, $nick);
				mysql_query("UPDATE `uzytkownicy` set `hasło`='$hasłoSL' WHERE `ide`='$myid' ");
				
				$amx_sql_conn = mysql_connect($amx_dbhost , $amx_dbuser, $amx_dbpassword);
				mysql_select_db($amx_dbname,$amx_sql_conn);   
				ini_set(‘error_reporting’, 0);
				$ts_id = @mysql_result(mysql_query("SELECT id from `$amx_dbname`.`amx_amxadmins` where `username`='$nick'"),id);
				ini_set(‘error_reporting’, E_ALL);
				
				if($ts_id>0){
					echo '<script language="JavaScript" type="text/javascript" >	$(document).ready(function() { insertInfo("hasło zostalo zmienione!"); });</script>';
					mysql_query("UPDATE `$amx_dbname`.`amx_amxadmins` set `password`='$hasłoSL' WHERE `username`='$nick' ");							
				} else {
					echo '<script language="JavaScript" type="text/javascript" >	$(document).ready(function() { insertError("Brak aktywnego slota, hasło do slota w panelu zostalo zmienione!"); });</script>';					
				}
								
				$sql_conn = mysql_connect($dbhost , $dbuser, $dbpassword);
				mysql_select_db($dbname,$sql_conn);    
			}

			if($slot_data > 0){
				echo '
					<form method="post" action="index.php?page=settings" id="changeSlotPass" name="changeSlotPass" >
					<table>
					<tr><td>
						Hasło: 
						</td><td>
						<input type="password" name="passSlot" id="passSlot"/> <br>
					</td></tr>
					<tr><td> </td><td> </td></tr>
					<tr><td> </td><td> </td></tr>
					<tr><td> </td><td> </td></tr>
					<tr><td> </td><td> </td></tr>
					</table>
					<br><br>'
					. $resources->przypomnijHaslo->zmianaHasla1 .

					'<br><br>
					<input type="submit" id="passSlotFinal" name="passSlotFinal" value="Zmień hasło" />
					</form>
				';
			}else{
				echo 'Nie masz wykupionego slota';
			}
		
		
		?>
		<br><br>
	</td>
	<td width=350 valign="top">		
	
	</td>
</tr>

</table>














