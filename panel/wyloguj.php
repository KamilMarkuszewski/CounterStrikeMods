<?php
        session_start();
        require( "dane.php" );
        $sql_conn = mysql_connect($dbhost , $dbuser, $dbpassword);
        mysql_select_db($dbname,$sql_conn);        
        $dbtable         = "dbmod_tablet";
        ob_flush();

        echo '<META HTTP-EQUIV=Refresh CONTENT="0; URL=index.php">';
        session_start();
        session_destroy();
		ob_flush();
?>







