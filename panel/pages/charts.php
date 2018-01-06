
<?php $ch = new cache(86400); ?>
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

	$query1 = "SELECT count( `nick` ), `klasa` FROM `dbmod_tablet` WHERE `lvl` >50 GROUP BY `klasa` ORDER by `klasa`";
	$exec1 = mysql_query($query1)or die(mysql_error());
	while ($row = mysql_fetch_array($exec1)) {
		//echo $row[0] ;
		//echo $row[1] ;
		$tab1a[] = $row[0];
		$tab1b[] = $row[1] ;
	}
	
	$query2 = "SELECT count( `nick` ), `klasa` FROM `dbmod_tablet` WHERE `lvl` >$minlvl GROUP BY `klasa` ORDER by `klasa`";
	$exec2 = mysql_query($query2)or die(mysql_error());
	while ($row = mysql_fetch_array($exec2)) {
		//echo $row[0] ;
		//echo $row[1] ;
		$tab2a[] = $row[0];
		$tab2b[] = $row[1] ;
	}
	


	

	
	
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
				$( "#slider-range-max-link" ).attr('href','index.php?page=charts&minLvl='+minLvl);
			}
			});
			$( "#amount" ).val( minLvl );
			$( "#slider-range-max-link" ).attr('href','index.php?page=charts&minLvl='+minLvl);
    });
</script>



<div id="chart1" style="min-width: 300px; height: 350px; margin: 0 auto"></div>
<br><br>
<div id="chart2" style="min-width: 300px; height: 350px; margin: 0 auto"></div>

<!--
<label for="amount">Powyżej poziomu:</label>
<input type="text" id="amount" style="border: 0; color: #f6931f; font-weight: bold;" />
<br>
<br>
<div id="slider-range-max"></div>
<br>
<br>
<a href="" id="slider-range-max-link">Filtruj</a>

-->


<?php $ch->close(); ?>
