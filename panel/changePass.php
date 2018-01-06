<?php
session_start();
  include ("engine.php");
  $pass = $_POST['passOld']; 
  $passNew = $_POST['passFinal']; 

  $query = mysql_query("SELECT * FROM uzytkownicy WHERE `user` = '$user' ");
  $fetch = mysql_fetch_array($query);
  if ( $fetch && $user!='') // jesli user zostanie znaleziony w bazie
  {
    
    if (  md5( $pass)  == $fetch['pass'] && isset($_POST['passOld']) && $_POST['passOld']!='') // jesli haslo sie zgadza
    {
      //ZMIANA HASLA
      $passNew = md5( $passNew ); 
      mysql_query("UPDATE `uzytkownicy` set `pass`='$passNew' WHERE `user`='$user' ");
      echo '<META HTTP-EQUIV=Refresh CONTENT="0; URL=index.php?info=passchanged">';
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



