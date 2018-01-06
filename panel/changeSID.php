<?php
session_start();
  include ("engine.php");
  $pass = $_POST['passSid']; 
  $passSRN = $_POST['passSRN']; 
  $eSID = $_POST['eSID']; 
  $eSID = preg_replace('/\s+/','',$eSID);
  
  //echo $pass . '<br>';
  //echo $passSRN . '<br>';
  //echo $eSID . '<br>';
  

  $query = mysql_query("SELECT * FROM uzytkownicy WHERE `user` = '$user' ");
  $fetch = mysql_fetch_array($query);
  if ( $fetch && $user!='') // jesli user zostanie znaleziony w bazie
  {
    
    if (  md5( $pass)  == $fetch['pass']) // jesli haslo sie zgadza
    {
		$srn_sql_conn = mysql_connect($srn_dbhost , $srn_dbuser, $srn_dbpassword);
		mysql_select_db($srn_dbname,$srn_sql_conn);   
		ini_set(‘error_reporting’, 0);
		$srn_p = @mysql_result(mysql_query("SELECT password from `srn_reservations` where `nick`='$nick'"),password);
		//echo "SELECT password from `srn_reservations` where `nick`='$nick'";
		//echo $srn_p;
		
		if (  md5($passSRN)  == $srn_p || $srn_p  == "" || $srn_p  == null) // jesli haslo sie zgadza
		{	
			$sql_conn = mysql_connect($dbhost , $dbuser, $dbpassword);
			mysql_select_db($dbname,$sql_conn);    
			
			$istnieje  = mysql_result(mysql_query("SELECT count(`FIRST_SID`) from `uzytkownicy` where `FIRST_SID`='$eSID'"),0);
			$istnieje_w_db  = @mysql_result(mysql_query("SELECT sid from `dbmod_tablet` where `sid`='$eSID' AND `nick`='$nick'"),0);		

			$unique = false;
			if($istnieje == 0 && $istnieje_w_db == $eSID){

				$unique = true;
			}
			
			if(strlen($sidFIRST) <1 || $sidFIRST == null || $sidFIRST == "")
			{
				if($unique){
					$t_pkt = $pkt + 10;
					mysql_query("UPDATE `uzytkownicy` set `pkt`='$t_pkt' WHERE `ide`='$myid' ");
				}
			}
			

			mysql_query("UPDATE `$dbtable` set `SID_PASS`='$eSID' WHERE `nick`='$nick' and `klasa`='1' ");
			mysql_query("UPDATE `uzytkownicy` set `FIRST_SID`='$eSID', `isFirstSidUnique`='$unique' WHERE `user` = '$user' AND `FIRST_SID` is NULL ");
			echo '<META HTTP-EQUIV=Refresh CONTENT="0; URL=index.php?info=sidchanged">';
		
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
  else
  {
		echo '<META HTTP-EQUIV=Refresh CONTENT="0; URL=index.php?err=nouser">';
  }

  mysql_close($sql_conn);
?> 



