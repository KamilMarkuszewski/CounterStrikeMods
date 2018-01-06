<script language="JavaScript" type="text/javascript" >
function validateEmail(email) 
{
    var re = /\S+@\S+\.\S+/;
    return re.test(email);
}

	$(document).ready(function() { 

		$('form#NickFinal').submit(function() {
			var fNick = $('input#Nick').attr('value');

			if(fNick.length < 4 ){
				insertError("Za krótki login");
				return false;
			}
			
			if(fNick.length > 20 ){
				insertError("Za długi login");
				return false;
			}			
		});
		
		
		$('form#MailFinal').submit(function() {
			var fMail = $('input#eMail').attr('value');

			if(fMail.length < 4 ){
				insertError("Za krótki email");
				return false;
			}
			
			if(fMail.length > 60 ){
				insertError("Za długi email");
				return false;
			}
			
			if(! validateEmail(fMail)  ){
				insertError("To nie jest poprawny adres email!");
				return false;
			}
		});
		
		$('form#ChangePass').submit(function() {
			var FPass = $('input#FPass').attr('value');
			var APass = $('input#APass').attr('value');

			if(FPass.length < 4 ){
				insertError("Za krótke hasło");
				return false;
			}
			
			if(FPass.length > 20 ){
				insertError("Za długie hasło");
				return false;
			}

			if(FPass != APass ){
				insertError("Podane hasła są różne!");
				return false;
			}
		});
	
	
	});



</script>

<?php 

	function sendmail($mail, $hash, $user){
		$from = "cslod@cs-lod.com.pl";
		$headers = 	"From: ".$from." \nContent-Type:".
			' text/plain;charset="iso-8859-2"'.
			"\nContent-Transfer-Encoding: 8bit";
	
		$title = "Odzyskiwanie hasla a cs-lod.com.pl";
		$pow = "Witaj.\r\nKtos uzyl odzyskiwania hasla podajac ten email.\r\nJesli nie wiesz o co chodzi zignoruj ten email. \r\nJesli chcesz zmienic haslo kliknij w ponizszy link.\r\n\r\n";
		$link = "http://".$_SERVER['HTTP_HOST'].$_SERVER['REQUEST_URI']."&user=".$user."&hash=$hash";		
		mail("$mail", "$title", $pow . $link, $headers); 
		
		echo '<script language="JavaScript" type="text/javascript" >	$(document).ready(function() { insertInfo("Email został wysłany."); });</script>';		
	}

	function makehash($mail, $pass, $user){
		$tmp =  $mail . ' ' . $pass . ' ' . $user . time() . rand(3,9);
		$tmp = md5($tmp);
		$tmp = substr($tmp, 0, 16);

		mysql_query("UPDATE `uzytkownicy` set `hashcode`='$tmp' WHERE `user`='$user' ");
		return $tmp;
	}
	
	


	$ok = false;
	
	if(isset($_POST['eMail'])){
		$femail = htmlspecialchars($_POST['eMail']); 
		
		$query = mysql_query("SELECT * FROM uzytkownicy WHERE `email` = '$femail' ");
		$num_rows = mysql_num_rows($query);
		$nicki = "";
		
		if($num_rows == 0 ) echo '<script language="JavaScript" type="text/javascript" >	$(document).ready(function() { insertError("Nie ma takiego emaila w bazie danych !"); });</script>';
		
		while($fetch = mysql_fetch_array($query)){
			$nicki = $nicki . ' ' . $fetch['user'];
			
			if($num_rows == 1){
				$hash = makehash($fetch['email'], $fetch['pass'], $fetch['user']);
				sendmail($fetch['email'], $hash, $fetch['user']);
				$ok = true;
			}
		}
		$nicki = substr($nicki, 0, 40);
		if($num_rows > 1 ) echo '<script language="JavaScript" type="text/javascript" >	$(document).ready(function() { insertError("Wyszukaj po nicku. Email przypisany do wielu nicków: '.$nicki.'"); });</script>';
		
	}else if(isset($_POST['Nick'])){
		$fnick = htmlspecialchars($_POST['Nick']); 
		$query = mysql_query("SELECT * FROM uzytkownicy WHERE `user` = '$fnick' ");
		$num_rows = mysql_num_rows($query);
		if($num_rows == 0 ) echo '<script language="JavaScript" type="text/javascript" >	$(document).ready(function() { insertError("Nie ma takiego loginu w bazie danych !"); });</script>';
		
		while($fetch = mysql_fetch_array($query)){
			if($fetch['email'] == ""){
				echo '<script language="JavaScript" type="text/javascript" >	$(document).ready(function() { insertError("Ten login nie ma podanego maila!"); });</script>';
			}   
			else{
				$hash = makehash($fetch['email'], $fetch['pass'], $fetch['user']);
				sendmail($fetch['email'], $hash, $fetch['user']);
				$ok = true;
			}			
		}	
	}
	
	if(isset($_GET['user']) && isset($_GET['hash'])){
	
		$uu = htmlspecialchars($_GET['user']); 
		$hh = htmlspecialchars($_GET['hash']); 
		$ok = true;
		$query = mysql_query("SELECT * FROM uzytkownicy WHERE `user` = '$uu' AND `hashcode`='$hh' ");

		$num_rows = mysql_num_rows($query);
		if($num_rows != 1){
			echo '<script language="JavaScript" type="text/javascript" >	$(document).ready(function() { insertError("Link jest niepoprawny lub nieaktualny!"); });</script>';
		}
		else
		{
			?>
				<h3>1. Zmiana hasła</h3>

				<form method="post" action="index.php?page=przypomnij" id="ChangePass" name="ChangePass" >
				<table>
				<tr><td>
					Hash: 
					</td><td>
					<input type="text" name="Fhash" id="Fhash" value="<?php echo $hh;?>" readonly="readonly"/><br>
				</td></tr>
				<tr><td>
					Login: 
					</td><td>
					<input type="text" name="Flogin" id="Flogin" value="<?php echo $uu;?>" readonly="readonly"/><br>
				</td></tr>
				<tr><td>
					Hasło: 
					</td><td>
					<input type="password" name="FPass" id="FPass"/><br>
				</td></tr>
				<tr><td>
					Powtórz hasło: 
					</td><td>
					<input type="password" name="APass" id="APass"/><br>
				</td></tr>

				</table>
				<br><br>
				<?php echo $resources->przypomnijHaslo->zmianaHasla1; ?>

				<br><br>
				<input type="submit" id="ChangePass" name="ChangePass" value="Wyślij" />
				</form>
			
			<?php		
		}
	}
	
	if(isset($_POST['Flogin']) && isset($_POST['Fhash']) && isset($_POST['FPass'])){
	
		$uu = htmlspecialchars($_POST['Flogin']); 
		$hh = htmlspecialchars($_POST['Fhash']); 
		$pp = $_POST['FPass']; 
		$ok = true;
		$query = mysql_query("SELECT * FROM uzytkownicy WHERE `user` = '$uu' AND `hashcode`='$hh' ");

		$num_rows = mysql_num_rows($query);
		if($num_rows != 1){
			echo '<script language="JavaScript" type="text/javascript" >	$(document).ready(function() { insertError("Link jest niepoprawny lub nieaktualny!"); });</script>';
		}
		else
		{
			$pp = md5($pp);
			mysql_query("UPDATE `uzytkownicy` set `pass`='$pp', `hashcode`=NULL WHERE `user`='$uu' ");
			echo '<script language="JavaScript" type="text/javascript" >	$(document).ready(function() { insertInfo("Hasło zostało zmienione. Link nie będzie już aktualny."); });</script>';		
		}
	}
	
	
	if($ok==false){
?>
		<h3>1. Zmiana hasła</h3>

		<form method="post" action="index.php?page=przypomnij" id="MailFinal" name="MailFinal" >
		<table>
		<tr><td>
			Email: 
			</td><td>
			<input type="text" name="eMail" id="eMail"/><br>
		</td></tr>

		</table>
		<br><br>
		<?php echo $resources->przypomnijHaslo->zmianaHasla1; ?>

		<br><br>
		<input type="submit" id="MailFinal" name="MailFinal" value="Wyślij" />
		</form>

		<br>
		<?php echo $resources->przypomnijHaslo->zmianaHasla2; ?>

		<br><br>
		<br><br>
		<h3>2. Zmiana hasła</h3>


		<form method="post" action="index.php?page=przypomnij" id="NickFinal" name="NickFinal" >
		<table>
		<tr><td>
			Login do panelu: 
			</td><td>
			<input type="text" name="Nick" id="Nick"/><br>
		</td></tr>

		</table>
		<br><br>
		<?php echo $resources->przypomnijHaslo->zmianaHasla1; ?>
		

		<br><br>
		<input type="submit" id="NickFinal" name="NickFinal" value="Wyślij" />
		</form>

		<br>
		<?php echo $resources->przypomnijHaslo->zmianaHasla3; ?>
<?php 
	}



?>




