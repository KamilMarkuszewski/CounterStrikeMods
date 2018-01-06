
<?php $ch = new cache(60*60*24); ?>

<?php
// SELECT count( `nick` ), `klasa`
// FROM `dbmod_tablet`
// WHERE `lvl` >25
// GROUP BY `klasa` ORDER by `klasa`

	if(isset($_GET['minLvl'])){
		$minlvl = $_GET['minLvl'];
	}else{
		$minlvl = 100;
	}
	
	$query3 = "SELECT max( `lvl` ) FROM `dbmod_tablet` ";
	$exec3 = mysql_query($query3)or die(mysql_error());
	while ($row = mysql_fetch_array($exec3)) {
		$maxlvl = $row[0];
		if($minlvl >= $maxlvl) $minlvl = $maxlvl-2;
		
	}

	$query1 = "SELECT count( `nick` ), `klasa` FROM `dbmod_tablet` WHERE `lvl` >50 AND `exp`>='20' AND (`data` > DATE_SUB(now(), INTERVAL 30 DAY)) GROUP BY `klasa` ORDER by `klasa`";
	$exec1 = mysql_query($query1)or die(mysql_error());
	while ($row = mysql_fetch_array($exec1)) {
		//echo $row[0] ;
		//echo $row[1] ;
		$tab1a[] = $row[0];
		$tab1b[] = $row[1] ;
	}
	
	$query2 = "SELECT count( `nick` ), `klasa` FROM `dbmod_tablet` WHERE `lvl` >$minlvl AND `exp`>='20' AND (`data` > DATE_SUB(now(), INTERVAL 30 DAY)) GROUP BY `klasa` ORDER by `klasa`";
	$exec2 = mysql_query($query2)or die(mysql_error());
	while ($row = mysql_fetch_array($exec2)) {
		//echo $row[0] ;
		//echo $row[1] ;
		$tab2a[] = $row[0];
		$tab2b[] = $row[1] ;
	}
	
	$query3 = "SELECT count( `nick` ), `klasa` FROM `dbmod_tablet` WHERE `lvl` >25 AND `exp`>='20' AND (`data` > DATE_SUB(now(), INTERVAL 60 DAY)) AND (`data` < DATE_SUB(now(), INTERVAL 30 DAY)) GROUP BY `klasa` ORDER by `klasa`";
	$exec3 = mysql_query($query3)or die(mysql_error());
	while ($row = mysql_fetch_array($exec3)) {
		//echo $row[0] ;
		//echo $row[1] ;
		$tab3a[] = $row[0];
		$tab3b[] = $row[1] ;
	}
	
	$query4 = "SELECT count( `nick` ), `klasa` FROM `dbmod_tablet` WHERE `lvl` >$minlvl AND `exp`>='20' AND (`data` > DATE_SUB(now(), INTERVAL 60 DAY)) AND (`data` < DATE_SUB(now(), INTERVAL 30 DAY)) GROUP BY `klasa` ORDER by `klasa`";
	$exec4 = mysql_query($query4)or die(mysql_error());
	while ($row = mysql_fetch_array($exec4)) {
		//echo $row[0] ;
		//echo $row[1] ;
		$tab4a[] = $row[0];
		$tab4b[] = $row[1] ;
	}
	/*
	if($minlvl == 100){
		$suma = 0;
		for($x = 0, $cnt = count($tab2a); $x < $cnt; $x++ ){
			$suma += $tab2a[$x];
		}
		for($x = 0, $cnt = count($tab2a); $x < $cnt; $x++ ){
			$prec = round($tab2a[$x] * 100 / $suma);
			$x1 = $x +1 ;
			if(rand(0,5)==0)
				mysql_query("UPDATE `dbmod_tablet` SET `popularnosc100`='$prec' WHERE `klasa`='$x1' AND `lvl`>='20' AND `exp`>='20' ");
		}
	}
	*/

	
	
?>
 <link rel="stylesheet" href="http://code.jquery.com/ui/1.10.3/themes/smoothness/jquery-ui.css" />
<script src="http://code.jquery.com/jquery-1.9.1.js"></script>
<script src="http://code.jquery.com/ui/1.10.3/jquery-ui.js"></script>
<script src="http://code.highcharts.com/highcharts.js"></script>
<script src="http://code.highcharts.com/modules/exporting.js"></script>

<script type="text/javascript">
$(function () {
    	var minLvl=<?php echo $minlvl; ?>;
    	// Radialize the colors
		Highcharts.getOptions().colors = Highcharts.map(Highcharts.getOptions().colors, function(color) {
		    return {
		        radialGradient: { cx: 0.5, cy: 0.3, r: 0.7 },
		        stops: [
		            [0, color],
		            [1, Highcharts.Color(color).brighten(-0.3).get('rgb')] // darken
		        ]
		    };
		});
		
		// Build the chart
        $('#chart1').highcharts({
            chart: {
                plotBackgroundColor: null,
                plotBorderWidth: null,
                plotShadow: false
            },
            title: {
                text: 'Najczęściej wybierane klasy'
            },
            tooltip: {
        	    pointFormat: '{series.name}: <b>{point.percentage:.0f}%</b>'
            },
            plotOptions: {
                pie: {
                    allowPointSelect: true,
                    cursor: 'pointer',
                    dataLabels: {
                        enabled: true,
                        color: '#000000',
                        connectorColor: '#000000',
                        formatter: function() {
                            return '<b>'+ this.point.name +'</b>';
                        }
                    }
                }
            },
            series: [{
                type: 'pie',
                name: 'graczy',
                data: [
					<?php
					for( $x = 0, $cnt = count($tab1a); $x < $cnt; $x++ ){

					   echo "['".$klasy[$tab1b[$x]-1]."',".$tab1a[$x]."],";
					   
					}

					
					?>
                ]
            }]
        });
		
				// Build the chart
        $('#chart2').highcharts({
            chart: {
                plotBackgroundColor: null,
                plotBorderWidth: null,
                plotShadow: false
            },
            title: {
                text: 'Najczęściej wybierane klasy powyżej '+minLvl+' poziomu'
            },
            tooltip: {
        	    pointFormat: '{series.name}: <b>{point.percentage:.0f}%</b>'
            },
            plotOptions: {
                pie: {
                    allowPointSelect: true,
                    cursor: 'pointer',
                    dataLabels: {
                        enabled: true,
                        color: '#000000',
                        connectorColor: '#000000',
                        formatter: function() {
                            return '<b>'+ this.point.name +'</b>';
                        }
                    }
                }
            },
            series: [{
                type: 'pie',
                name: 'graczy',
                data: [
					<?php
					for( $x = 0, $cnt = count($tab2a); $x < $cnt; $x++ ){

					   echo "['".$klasy[$tab2b[$x]-1]."',".$tab2a[$x]."],";
					   
					}

					
					?>
                ]
            }]
        });
		 $( "#slider-range-max" ).slider({
			range: "max",
			min: 25,
			max: <?php echo $maxlvl-1; ?>,
			value: <?php echo minLvl; ?>,
			slide: function( event, ui ) {
				minLvl = ui.value;
				$( "#amount" ).val( minLvl );
				$( "#slider-range-max-link" ).attr('href','index.php?page=charts2&minLvl='+minLvl);
			}
			});
			
		$('#bar1').highcharts({
					chart: {
						type: 'column'
					},
					title: {
						text: 'Przyrost wybierania klas w ciągu miesiaca'
					},
					yAxis: {
						title: {
							text: 'Procentowy przyrost'
						}
					},
					xAxis: {
						type: 'category',
						labels: {
							rotation: -45,
							style: {
								fontSize: '12px',
								fontFamily: 'Verdana, sans-serif'
							}
						}
					},
					credits: {
						enabled: false
					},
					series: [{
						name: 'przyrost graczy',
						data: [
							<?php
							for( $x = 0, $cnt = count($tab1a); $x < $cnt; $x++ ){
								if($tab3a[$x] != 0)
									echo "['".$klasy[$tab1b[$x]-1]."',".(($tab1a[$x] / $tab3a[$x]) -1 )."],";
								else
									echo "['".$klasy[$tab1b[$x]-1]."',".(($tab1a[$x] / ($tab3a[$x] + 1))-1 )."],";
							}
							?>
						]
					}]
				});
			
				
		$('#bar2').highcharts({
					chart: {
						type: 'column'
					},
					title: {
						text: 'Przyrost wybierania klas w ciągu miesiaca'
					},
					yAxis: {
						title: {
							text: 'Procentowy przyrost'
						}
					},
					xAxis: {
						type: 'category',
						labels: {
							rotation: -45,
							style: {
								fontSize: '12px',
								fontFamily: 'Verdana, sans-serif'
							}
						}
					},
					credits: {
						enabled: false
					},
					series: [{
						name: 'przyrost graczy',
						data: [
							<?php
							for( $x = 0, $cnt = count($tab2a); $x < $cnt; $x++ ){
								if($tab4a[$x] != 0)
									echo "['".$klasy[$tab2b[$x]-1]."',".(($tab2a[$x] / $tab4a[$x])-1 )."],";
								else
									echo "['".$klasy[$tab2b[$x]-1]."',".(($tab2a[$x] / ($tab4a[$x] + 1))-1 )."],";
							}

							
							?>
						]
					}]
				});
			
			$( "#amount" ).val( minLvl );
			$( "#slider-range-max-link" ).attr('href','index.php?page=charts2&minLvl='+minLvl);
    });
	
	
	
</script>
 <script>
 $(function() {
$( "#tabs" ).tabs();
});
</script>

<div id="tabs">
<ul>
<li><a href="#tabs-1">Wybierane klasy </a></li>
<li><a href="#tabs-2">Przyrost graczy</a></li>
</ul>

<div id="tabs-1">
<p>

	<div id="chart1" style="min-width: 300px; height: 350px; margin: 0 auto"></div>
	<div id="chart2" style="min-width: 300px; height: 350px; margin: 0 auto"></div>

	<!--
	<label for="amount">Powyżej poziomu:</label>
	<input type="text" id="amount" style="border: 0; color: #f6931f; font-weight: bold;" />
	<br>
	
	<div id="slider-range-max"></div>
	<br>
	<a href="" id="slider-range-max-link">Filtruj</a>
-->
</p>
</div>

<div id="tabs-2">
<p>
	<div id="bar1" style="min-width: 300px; height: 350px; margin: 0 auto"></div>
	
	<div id="bar2" style="min-width: 300px; height: 350px; margin: 0 auto"></div>
</p>
</div>


</div>

<?php $ch->close(); ?>



