<?php
session_start();
  include ("engine.php");
  $pass = $_POST['passMail']; 
  $mail = $_POST['eMail']; 

  $query = mysql_query("SELECT * FROM uzytkownicy WHERE `user` = '$user' ");
  $fetch = mysql_fetch_array($query);
  if ( $fetch && $user!='') // jesli user zostanie znaleziony w bazie
  {
    
    if (  md5( $pass)  == $fetch['pass'] && isset($_POST['passMail']) && $_POST['passMail']!='') // jesli haslo sie zgadza
    {
      //ZMIANA MAILA

      mysql_query("UPDATE `uzytkownicy` set `email`='$mail' WHERE `user`='$user' ");
      echo '<META HTTP-EQUIV=Refresh CONTENT="0; URL=index.php?info=mailchanged">';
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



