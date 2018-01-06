<?php 
session_start();
?>
<!doctype html public "-//W3C//DTD HTML 4.0 Transitional//EN">

<?php
	include ("engine.php");
?> 
	
<html>
<head>
<meta http-equiv="Content-type" content="text/html; charset=utf-8">
<title>Panel serwerów CS-LOD <?php echo $nr; ?></title>
<link href="design/styl.css" rel="Stylesheet" type="text/css">

<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.2.6/jquery.min.js"></script>
<link type="text/css" href="design/css/cupertino/jquery-ui-1.8.19.custom.css" rel="stylesheet" />
<link rel="Stylesheet" type="text/css" href="design/jqueryslidemenu.css" />
<script type="text/javascript" src="design/jqueryslidemenu.js"></script>
<script type="text/javascript" src="functions.js"></script>

<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.3.2/jquery.min.js"></script>
<script src="http://cs-lod.com.pl/cookies/script.js"></script>


</head>
<body>


<div class="overall">
	<div class="top">
		<?php include ("top.php"); ?>
	</div>
	
	<div class="menu">
		<div class="menu-l"></div>
		
		<div id="myslidemenu" class="jqueryslidemenu" style="float:left;">
			<ul>
			<li><a href="index.php"><div class="menu0"></div></a></li>
			<li><div class="menu1"></div>
			  <ul>
				  <!--<li><a href="index.php?page=sms">Sms homepay</a></li>-->
				  <!--<li><a href="index.php?page=przelew">Przelew homepay</a></li>-->
				  <?php 

						echo '<li><a href="index.php?page=pukawka">Sms pukawka</a></li>';
						//echo '<li><a href="index.php?page=wiaderko">Sms wiaderko</a></li>';
						//echo '<li><a href="index.php?page=cssetti">Sms cssetti</a></li>';
						//echo '<li><a href="index.php?page=promocyjne">Kody promocyjne</a></li>';
		  
				  ?>
			  </ul>
			</li>
			<li><div class="menu2"></div>
			  <ul>
					<?php include ("menu_kup.php"); ?>
			  </ul>
			</li>

			<li><a href="index.php?page=rekl"><div class="menu3"></div></a></li>
			<li><a href="index.php?page=stats"><div class="menu4"></div></a></li>
			<li><div class="menu5"></div>
			  <ul>
				  <li><a href="http://www.cs-lod.com.pl/system/1/panel2">LOD 1</a></li>
				  <li><a href="http://www.cs-lod.com.pl/system/2/panel2">LOD 2</a></li>
				  <li><a href="http://www.cs-lod.com.pl/system/3/panel2">Skyrim</a></li>
				  <!--<li><a href="http://www.cs-lod.com.pl/system/cod/panel2">COD</a></li>-->
				  <li><a href="http://www.cs-lod.com.pl/system/7/panel2">Diablo 3</a></li>
				  <!--<li><a href="http://www.cs-lod.com.pl/system/zombie/panel2">Zombie</a></li>-->
			  </ul>
			</li>
			<li><a href="http://www.cs-lod.com.pl"><div class="menu6"></div></a></li>
			</ul>

		</div>

		
		
		
		
		
		
	
		
		
		
		
		
		<div class="menu-r"></div>
	</div>

	<div class="columns">
		<div class="column-left">
			<div class="column-header">
				<div class="left"></div>
				<div class="center">
						<?php 
							include ("img-left.php");
						?>
				</div>
				<div class="right"></div>
			</div>
			<div class="column-body">
				<div class="top">
					<div class="left"></div>
					<div class="center"></div>
					<div class="right"></div>
				</div>
				<div class="mid">
					<?php 
						include ("content-left.php");
					?>

				</div>
				<div class="bot">
					<div class="left"></div>
					<div class="center"></div>
					<div class="right"></div>
				</div>
			</div>
			
			<?php if(!$stats){ ?>

				<div class="column-header">
					<div class="left"></div>
						<div class="center">
							<img src="design/images/left_dotacja.png">
						</div>
					<div class="right"></div>
				</div>
				<div class="column-body">
					<div class="top">
						<div class="left"></div>
						<div class="center"></div>
						<div class="right"></div>
					</div>
					<div class="mid">
						<div class="left dot"></div>
						<div class="center dot">
							<br>
							<iframe src="https://admin.pukawka.pl/api/?keyapi=Bd9z5PvfaqXOhuN" width="214px" height="277px" border="0" style="border:0;width:214pxpx;height:277pxpx;">
								<a href="https://admin.pukawka.pl/api/?keyapi=Bd9z5PvfaqXOhuN">Przejdź do płatności</a>
							</iframe>
							<br><br>
							<?php echo $resources->dotacja->string1; ?>
							<br>
						</div>
						<div class="right dot" ></div>
					</div>
					<div class="bot">
						<div class="left"></div>
						<div class="center"></div>
						<div class="right"></div>
					</div>
				</div>
			<?php } ?>

		</div>
		<div class="column-right">
			<div class="top">
				<div class="left"></div>
				<div class="center"></div>
				<div class="right"></div>
			</div>
			<div class="mid">
				<div class="left"></div>
				<div class="center">
				
					<?php 
						include ("content.php");
					?>
				
				</div>
				<div class="right"></div>
			</div>
			<div class="bot">
				<div class="left"></div>
				<div class="center"></div>
				<div class="right"></div>
			</div>
		</div>	
	</div>

	<div class="footer">
		<div class="footer-left"></div>
		<div class="footer-body">
			<p>
				Copyright &copy; 2012 
				<a href="http://www.cs-lod.com.pl/">www.cs-lod.com.pl</a>
				 - All rights reserved
				 <br>
				 Projekt i wykonanie: Kajt
			</p>
		</div>
		<div class="footer-right"></div>
	</div>


<?php
	if($sql_conn && $page != "stats") mysql_close($sql_conn);
	
?>

</div>
</body>
</html>
