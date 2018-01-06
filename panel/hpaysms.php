<?php
	require_once("functions.php");


	$config['homepay'] = array();                                                             
	$config['homepay']['active_transfers']=false; // jesli uzywasz przelewow                                                         
	$config['homepay']['active_sms']=true;  // jesli uzywasz smsow
						   
	# przykladowy konfig dla SMS                                                              
	$config['homepay'][1]['type']="sms";  
	$config['homepay'][1]['acc_id']=3160; // twoje id uslugi widoczne w panelu                                                       
													 
	$config['homepay'][1]['sms_number']="7555"; // numer sms do wysylania wiadomosci
	$config['homepay'][1]['sms_text']="HPAY.CSLOD5";  // text smsa                                      
	$config['homepay'][1]['cost']="5zł + VAT <br>(6,15 zł brutto)"; // kwota wyswietlana
	$config['homepay'][1]['text']="Doladuj konto za 6 punktow";
	$config['homepay'][1]['addpoints']=6;  // tu mozesz wpisywac dowolne parametry uslugi,
	// potrzebne ci do zaakceptowania platnosci - np. ilosc punktow do doladowania konta w zaleznosci od kwoty

	# przykladowy konfig dla SMS                                                              
	$config['homepay'][2]['type']="sms";  
	$config['homepay'][2]['acc_id']=3156; // twoje id uslugi widoczne w panelu                                                       
													 
	$config['homepay'][2]['sms_number']="7955"; // numer sms do wysylania wiadomosci
	$config['homepay'][2]['sms_text']="HPAY.CSLOD9";  // text smsa                                      
	$config['homepay'][2]['cost']="9zł + VAT <br>(11,07 zł brutto)"; // kwota wyswietlana
	$config['homepay'][2]['text']="Doladuj konto za 12 punktow";
	$config['homepay'][2]['addpoints']=12;  // tu mozesz wpisywac dowolne parametry uslugi,
	// potrzebne ci do zaakceptowania platnosci - np. ilosc punktow do doladowania konta w zaleznosci od kwoty

	# przykladowy konfig dla SMS                                                              
	$config['homepay'][3]['type']="sms";  
	$config['homepay'][3]['acc_id']=3157; // twoje id uslugi widoczne w panelu                                                       
													
	$config['homepay'][3]['sms_number']="91955"; // numer sms do wysylania wiadomosci
	$config['homepay'][3]['sms_text']="HPAY.CSLOD19";  // text smsa                                      
	$config['homepay'][3]['cost']="19zł + VAT <br>(23,37 zł brutto)"; // kwota wyswietlana
	$config['homepay'][3]['text']="Doladuj konto za 24 punkty";
	$config['homepay'][3]['addpoints']=24;  // tu mozesz wpisywac dowolne parametry uslugi,
	// potrzebne ci do zaakceptowania platnosci - np. ilosc punktow do doladowania konta w zaleznosci od kwoty

	# przykladowy konfig dla SMS                                                              
	$config['homepay'][4]['type']="sms";  
	$config['homepay'][4]['acc_id']=3158; // twoje id uslugi widoczne w panelu                                                       
													 
	$config['homepay'][4]['sms_number']="92520"; // numer sms do wysylania wiadomosci
	$config['homepay'][4]['sms_text']="HPAY.CSLOD25";  // text smsa                                      
	$config['homepay'][4]['cost']="25zł + VAT <br>(30,75 zł brutto)"; // kwota wyswietlana
	$config['homepay'][4]['text']="Doladuj konto za 34 punkty";
	$config['homepay'][4]['addpoints']=34;  // tu mozesz wpisywac dowolne parametry uslugi,
	// potrzebne ci do zaakceptowania platnosci - np. ilosc punktow do doladowania konta w zaleznosci od kwoty
	
	
	/////////////////////////
	
		# przykladowy konfig dla SMS                                                              
	$config['homepay'][5]['type']="sms";  
	$config['homepay'][5]['acc_id']=8380; // twoje id uslugi widoczne w panelu                                                       
													 
	$config['homepay'][5]['sms_number']="7555"; // numer sms do wysylania wiadomosci
	$config['homepay'][5]['sms_text']="HPAY.LOD";  // text smsa                                      
	$config['homepay'][5]['cost']="5zł + VAT <br>(6,15 zł brutto)"; // kwota wyswietlana
	$config['homepay'][5]['text']="Doladuj konto za 6 punktow";
	$config['homepay'][5]['addpoints']=6;  // tu mozesz wpisywac dowolne parametry uslugi,
	// potrzebne ci do zaakceptowania platnosci - np. ilosc punktow do doladowania konta w zaleznosci od kwoty

	# przykladowy konfig dla SMS                                                              
	$config['homepay'][6]['type']="sms";  
	$config['homepay'][6]['acc_id']=8381; // twoje id uslugi widoczne w panelu                                                       
													 
	$config['homepay'][6]['sms_number']="7955"; // numer sms do wysylania wiadomosci
	$config['homepay'][6]['sms_text']="HPAY.LOD";  // text smsa                                      
	$config['homepay'][6]['cost']="9zł + VAT <br>(11,07 zł brutto)"; // kwota wyswietlana
	$config['homepay'][6]['text']="Doladuj konto za 12 punktow";
	$config['homepay'][6]['addpoints']=12;  // tu mozesz wpisywac dowolne parametry uslugi,
	// potrzebne ci do zaakceptowania platnosci - np. ilosc punktow do doladowania konta w zaleznosci od kwoty

	# przykladowy konfig dla SMS                                                              
	$config['homepay'][7]['type']="sms";  
	$config['homepay'][7]['acc_id']=8382; // twoje id uslugi widoczne w panelu                                                       
													
	$config['homepay'][7]['sms_number']="91955"; // numer sms do wysylania wiadomosci
	$config['homepay'][7]['sms_text']="HPAY.LOD";  // text smsa                                      
	$config['homepay'][7]['cost']="19zł + VAT <br>(23,37 zł brutto)"; // kwota wyswietlana
	$config['homepay'][7]['text']="Doladuj konto za 24 punkty";
	$config['homepay'][7]['addpoints']=24;  // tu mozesz wpisywac dowolne parametry uslugi,
	// potrzebne ci do zaakceptowania platnosci - np. ilosc punktow do doladowania konta w zaleznosci od kwoty

	# przykladowy konfig dla SMS                                                              
	$config['homepay'][8]['type']="sms";  
	$config['homepay'][8]['acc_id']=8383; // twoje id uslugi widoczne w panelu                                                       
													 
	$config['homepay'][8]['sms_number']="92520"; // numer sms do wysylania wiadomosci
	$config['homepay'][8]['sms_text']="HPAY.LOD";  // text smsa                                      
	$config['homepay'][8]['cost']="25zł + VAT <br>(30,75 zł brutto)"; // kwota wyswietlana
	$config['homepay'][8]['text']="Doladuj konto za 34 punkty";
	$config['homepay'][8]['addpoints']=34;  // tu mozesz wpisywac dowolne parametry uslugi,
	// potrzebne ci do zaakceptowania platnosci - np. ilosc punktow do doladowania konta w zaleznosci od kwoty
	
	////////////////////////
	

	function check_code_homepay($code,$usluga)
	{                                         
		global $config;                           
		if(!preg_match("/^[A-Za-z0-9]{8}$/",$code)) return 0;
		$code=urlencode($code);                              
		
		/*
		$handle=fopen("http://homepay.pl/sms/check_code.php?usr_id=320&acc_id=".(int)($config['homepay'][$usluga]['acc_id'])."&code=".$code,'r');                                                                                
		$status=fgets($handle,8);
		fclose($handle); 
		*/
		$status=curlit("http://homepay.pl/sms/check_code.php?usr_id=320&acc_id=".(int)($config['homepay'][$usluga]['acc_id'])."&code=".$code); 
		//$status=curlit("http://homepay.pl/API/check_tcode.php?usr_id=320&acc_id=".(int)($config['homepay'][$usluga]['acc_id'])."&code=".$code);
	  //$check=curlit("http://homepay.pl/sms/check_code.php?usr_id=320&acc_id=".(int)($config['homepay'][$usluga]['acc_id'])."&code=".$code);
		//$check=str_getcsv($check);
			   
		return $status;          
	}                                                                                                                     

	function check_tcode_homepay($code,$usluga)
	{                                          
		global $config;                            
		if(!preg_match("/^[A-Za-z0-9]{8}$/",$code)) return 0;
		$code=urlencode($code);                              
		$handle=fopen("http://homepay.pl/API/check_tcode.php?usr_id=320&acc_id=".(int)($config['homepay'][$usluga]['acc_id'])."&code=".$code,'r');                                                                               

		$status=fgets($handle,8);
		fclose($handle);      
		return $status;          
	}




?>