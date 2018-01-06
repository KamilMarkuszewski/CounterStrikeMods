<script language="JavaScript" type="text/javascript" >
function validateEmail(email) 
{
    var re = /\S+@\S+\.\S+/;
    return re.test(email);
};



	$(document).ready(function() { 
		$('span#ni').hide();
		$('span#po').hide();
		$('span#srn1').hide();
		$( ".srnpassb" ).hide();
		
		$('div.pp').hide();
		$('div.pods').hide();
		
			
		$('form#spr').submit(function() {

			var res = $('span#ni').load('find_player.php?player='+encodeURI($('input#playerForm').attr('value')), function(response){
       
				if(response==" " ||response=="" || response==null  || response==undefined || $.trim(response).length < 4){
					insertError("Podany uzytkownik nie istnieje w bazie danych");
				}else{
					insertInfo('Znaleziono Twoj nick: '+ response);
					
					
					$('input#playerForm').attr('readonly', 'readonly');
					$('input#sprInput').attr('disabled', 'disabled');
					$('div.search').hide();
					$('div.pp').show();
					$('h3.search').html("1. Wyszukiwanie nicku - Zakończone");
					$('input#nickFinal').attr('value', $('input#playerForm').attr('value'));
					$('input#userFinal').attr('value', $('input#playerForm').attr('value'));
				}
			});
			
			return false;
		});
		
		$('form#sprRekl').submit(function() {
			$('div.pp').hide();
			$('div.pods').show();
		});
		
	
		$('form#sprRekl').submit(function() {
			var res = $('span#po').load('find_pp.php?pp='+encodeURI($('input#ppForm').attr('value')+'&dla='+encodeURI($('input#nickFinal').attr('value'))), function(response){
				if(response==" " ||response=="" || response==null  || response==undefined || $.trim(response).length < 4){
					if( response.indexOf("-1") > -1) insertError("Twoje drugie konto nie moze byc polecającym!"); 
					else if($('input#ppForm').attr('value') != "") insertError("Podany uzytkownik nie istnieje w bazie danych"); 
				}else{
					insertInfo('Znaleziono login polecającego: '+ response);
					$('input#ppForm').attr('readonly', 'readonly');
					$('input#ppInput').attr('disabled', 'disabled');
					$('div.pp').hide();
					$('div.pods').show();
					$('h3.pp').html("2. Wyszukiwanie polecającego - Zakończone");
					$('input#reklFinal').attr('value', $('input#ppForm').attr('value'));				
				}
			});
		
			return false;
			
		});
		
		
		
		
		
		$('a#zatwierdz').click(function() {
			var resSRN = $('span#srn1').load('http://cs-lod.com.pl/system/rezerwacje/checkPassAjax.php?login='+encodeURI($('input#playerForm').attr('value') + '&password=' + $('input#SRNpass').attr('value')), function(response1){
				if(response1==0){
					insertError('Hasło do rezerwacji nieprawidłowe!');	
					$('span#srn1').attr('value', 0);					
				}
				if(response1==1){
					insertInfo('Hasło do rezerwacji prawidłowe');
					$('input#SRNpass').attr('readonly', 'readonly');
					$('a#zatwierdz').hide();
					$('span#srn1').attr('value', 1);
				}
			});		

		});
	
		$('form#Final').submit(function() {
		
		
		
			var fUser = $('input#userFinal').attr('value');
			var fNick = $('input#nickFinal').attr('value');
			var fPass = $('input#passFinal').attr('value');
			var fPassPowt = $('input#passFinalPowt').attr('value');
			var fRekl = $('input#reklFinal').attr('value');
			var eMail = $('input#eMail').attr('value');
			var eMailPowt = $('input#eMailPowt').attr('value');
			var srnPass = $('span#srn1').attr('value');
			
			if(fUser.length < 4 ){
				insertError("Za krótki login");
				return false;
			}
			if(fNick.length < 4 ){
				insertError("Za krótki nick");
				return false;
			}
			if(fPass.length < 4 ){
				insertError("Za krótke hasło");
				return false;
			}
			
			if(fUser.length > 40 ){
				insertError("Za długi login");
				return false;
			}
			if(fNick.length > 40 ){
				insertError("Za długi nick");
				return false;
			}
			if(fPass.length > 20 ){
				insertError("Za długie hasło");
				return false;
			}
			
			if(fRekl.length > 20 ){
				insertError("Za długi login reklamującego");
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
			
			if(fPass != fPassPowt ){
				insertError("Podane hasła są różne!");
				return false;
			}			
			
			if(! validateEmail(eMail)  ){
				insertError("To nie jest poprawny adres email!");
				return false;
			}
			
			
		});
	
	
	});



</script>


<?php echo $resources->rejestracja->wyszukiwanieNicku1; ?>
<br><br>
<?php echo $resources->rejestracja->wyszukiwanieNicku2; ?>
<br><br>

<h3 class="search">1. Wyszukiwanie nicku</h3>
<div class="search">

<?php
echo ('<form id="spr" class="search" action="" method="POST" >
        '. $resources->rejestracja->wyszukiwanieNicku3 .' <input id="playerForm" name="player" type="text" MAXLENGTH="32" > 
        <input  TYPE="submit" name="spr" id="sprInput" value="Szukaj">
		</form>');
     
$pla = $_POST['player'];
$nick =$_GET['player'];

?>
</div>
<br>
<div class='h'>
<span id="ni"></span>
<span id="srn1"></span>
<span id="po"></span>
<span id="rej"></span>
</div>

<h3 class="pp">2. Wyszukiwanie polecającego</h3>
<div class="pp">
<?php
	$ppo = $_COOKIE['lod_pp'];
	//echo "cooke done ";
	//echo $ppo;
	if($ppo==null){
		
		echo $resources->rejestracja->wyszukiwaniePolecajacego1 . "<br><br>". $resources->rejestracja->wyszukiwaniePolecajacego2 ."<br><br> " .$resources->rejestracja->wyszukiwaniePolecajacego3. "<br><br>";
		echo ('<form id="sprRekl" class="pp" action="" method="POST" >
				'. $resources->rejestracja->wyszukiwaniePolecajacego4. ' <input id="ppForm" name="pp" type="text" MAXLENGTH="32" > 
				<input  TYPE="submit" name="ppSubm" id="ppInput" value="Szukaj">
				<input  TYPE="submit" name="ppPomin" id="ppPominInput" value="Pomiń">
				</form>');
	}else{
		$querypp = mysql_query("SELECT * FROM uzytkownicy WHERE `user` = '$ppo' ");
		$fetchpp = mysql_fetch_array($querypp);
		?>
		<script language="JavaScript" type="text/javascript" >
			$(document).ready(function() { 
				$('h3.pp').html("2. Wyszukiwanie polecającego - Zakończone");
			});
		</script>
		<?php
		if($fetchpp){

		}
		else{
		  $ppo = null;
		}
	}

?>
</div>

<br><br>
<h3>3. Podsumowanie</h3>
<div class="pods">

<form method="post" action="rejestracja.php" id="Final" name="Final" >
<table>
<tr><td>
	Login*: 
	</td><td>
	<input type="text" name="userFinal"  id="userFinal" readonly="readonly"/> <br>
</td></tr>
<tr><td>
	Hasło*: 
	</td><td>
	<input type="password" name="passFinal" id="passFinal"/> <br>
</td></tr>
<tr><td>
	Powtórz hasło*: 
	</td><td>
	<input type="password" name="passFinalPowt" id="passFinalPowt"/> <br>
</td></tr>

<tr><td> </td><td> </td></tr>
<tr><td> </td><td> </td></tr>
<tr><td> </td><td> </td></tr>
<tr><td> </td><td> </td></tr>

<tr class="srnpassb"><td>
	Hasło do rezerwacji*: 
	</td><td>
	<input type="password" name="SRNpass" id="SRNpass" class="srnpassb"/> <a id="zatwierdz">Zatwierdz</a><br>
</td></tr>

<tr class="srnpassb"><td> </td><td> </td></tr>
<tr class="srnpassb"><td> </td><td> </td></tr>
<tr class="srnpassb"><td> </td><td> </td></tr>
<tr class="srnpassb"><td> </td><td> </td></tr>

<tr><td>
	Nick*: 
	</td><td>
	<input type="text" name="nickFinal" id="nickFinal" readonly="readonly"/><br>
</td></tr>
<tr><td>
	Login polecającego:
	</td><td>
	<input type="text" name="reklFinal" readonly="readonly" id="reklFinal" value="<?php echo $ppo; ?>"/> <br>
</td></tr>

<tr><td> </td><td> </td></tr>
<tr><td> </td><td> </td></tr>
<tr><td> </td><td> </td></tr>
<tr><td> </td><td> </td></tr>

<tr><td>
	E-mail*:
	</td><td>
	<input type="text" name="eMail" id="eMail"/><br>
</td></tr>
<tr><td>
	Powtórz e-mail*:
	</td><td>
	<input type="text" name="eMailPowt" id="eMailPowt"/><br>
</td></tr>
</table>
<br><br>
<?php echo $resources->rejestracja->podsumowanie1; ?>
<br>
<br>
<?php echo $resources->rejestracja->podsumowanie2; ?>
<br><br>
<input type="submit" id="sFinal" name="sFinal" value="Zarejstruj się" />
</form>

</div>






