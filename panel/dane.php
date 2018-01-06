<?php
$dbuser       = ""; 
$dbpassword   = "";
$dbname       = "";
$dbtable      = "dbmod_tablet";

$nr  			= 1;
$cookiesVar = "zalogowany1";

$amx_dbuser       = ""; 
$amx_dbpassword   = "";
$amx_dbname       = "";
$amx_dbhost       = "sql.pukawka.pl";

$srn_dbuser       = ""; 
$srn_dbpassword   = "";
$srn_dbname       = "";
$srn_dbhost       = "sql.pukawka.pl";

$core_url       = "http://www.cs-lod.com.pl/system/core/";

  $rasy = array('Ludzie', 'Magowie', 'Słudzy mroku', 'Myśliwi');
  $klasy = array(
    'Mnich', 'Paladyn', 'Zabójca', 'Barbarzyńca', 'Ninja', 'Archeolog','Kaplan',
    'Mag', 'Mag ognia', 'Mag wody', 'Mag ziemi', 'Mag powietrza',	'Arcymag', 'Magic Gladiator',
    'Nekromanta', 'Witch doctor', 'Orc', 'Wampir',	'Harpia', 'Wilkołak','Upadły anioł ',
    'Lowca', 'Szary elf', 'Leśny elf');
	
?>
      

	  
<?php
		
		
function isNickSamePerson($user2, $nick1)
{
	$nick2 =mysql_result(mysql_query("SELECT `nick` from `uzytkownicy` where `user`='$user2'"),nick);
	if($nick2 == null || $nick2 == "") return 0;

	$queryNick1 = mysql_query(" SELECT sid FROM dbmod_tablet WHERE `nick` = '$nick1' GROUP BY sid ");
	while ($row = mysql_fetch_array($queryNick1)) 
	{
		$nick1Sidy[] = $row[0];
	}
			
	$queryNick2 = mysql_query(" SELECT sid FROM dbmod_tablet WHERE `nick` = '$nick2' GROUP BY sid ");
	while ($row = mysql_fetch_array($queryNick2)) 
	{
		$nick2Sidy[] = $row[0];
	}
			
	$wspolne = array_intersect_assoc($nick1Sidy, $nick2Sidy);
			
	if(count($wspolne) > 0)
	{
		return 1;
	}
	return 0;
}

class cache {
	var $cache_dir = "cache/"; // Directory where the cache files will be stored
	var $caching = false;
	var $cache_file = "";
	
	// Constructor of the class
	function cache($cache_time) {
		
		$this->cache_file = $this->cache_dir . md5(urlencode($_SERVER["REQUEST_URI"]));
		//echo 'time ' . time() . 'cachetime ' .$cache_time . ' filetime ' . filemtime( $filename );
		if (file_exists($this->cache_file) && (time() - $cache_time) < filemtime( $this->cache_file ) ) {
			
			//Grab the cache:
			$handle = fopen($this->cache_file, "r");
			do {
				$data = fread($handle, 8192);
				if (strlen($data) == 0) {
					break;
				}
				echo $data;
			} while (true);
			fclose($handle);
			echo "<span style='font-size:8px;'>cache page loaded</span>";
			exit();
		} else {
			//create cache :
			$this->caching = true;
			ob_start();
		}
	}
	
   // You should have this at the end of each page
	function close() {
		
		if ($this->caching) {
			// You were caching the contents so display them, and write the cache file
			$data = ob_get_clean();
			echo $data;
			$fp = fopen(str_replace("/ww.", "/", $this->cache_file), 'w');
			fwrite($fp, $data);
			fclose($fp);
		}
	}
}
?>
 