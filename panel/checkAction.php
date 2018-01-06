<?php
	$changed = false;
	if(isset($page) && isset($_SESSION["$cookiesVar"])){

		switch($page){
			case "sms":
				require_once ("hpaysms.php");
				if($_POST&&isset($_POST['code'])&&!empty($_POST['code'])&&isset($_POST['id'])&&!empty($_POST['id']))
				{
					$return=true;
					// w tym miejscu wstaw funkcje ktore przerwa skrypt, gdy np. uzytkownik jest niezalogowany albo niepoprawnie wypelnil dodatkowe pola formularza
					// np. jesli masz dodatkowe pole "telefon" i ma skladac sie z 9 cyfr, napisz
					// if( !isset($_POST['telefon']) || !preg_match("/^[0-9]{9}$/",$_POST['telefon']) ) $return="Nie wypelniles wszystkich pol formularza";
					// jesli posiadasz funkcje sprawdzajaca czy uzytkownik jest zalogowany wstaw ja rowniez tutaj, np.
					// if(! userLoggedIn() ) $return="Niepoprawna nazwa uzytkownika";
					// pamietaj, ze wywolanie funkcji check_code_homepay() badz check_codet_homepay z prawdziwym kodem
					// sprawi ze ten kod bedzie nieodwracalnie zuzyty (badz rozpoczety jesli to kod czasowy)

					if($return === true)
					{
						if($config['homepay'][(int)($_POST['id'])]['type']=="sms")
						{
								$id_elem = 0;	
								$user_check = $_POST['login'];
								$user_id = $_POST['id'];
								$jestw2 = mysql_result(mysql_query("SELECT `user` from `uzytkownicy` where `user`='$user_check'"),user);

								if(( $jestw2 != NULL  )){
								
									$kodUsera = trim($_POST['code']);
									$s1=check_code_homepay($kodUsera ,1);
									$s2=check_code_homepay($kodUsera ,2);
									$s3=check_code_homepay($kodUsera ,3);
									$s4=check_code_homepay($kodUsera ,4);
									
									$s5=check_code_homepay($kodUsera ,5);
									$s6=check_code_homepay($kodUsera ,6);
									$s7=check_code_homepay($kodUsera ,7);
									$s8=check_code_homepay($kodUsera ,8);
											
									if($s1>0){
									  $id_elem = 1;
									  $status=$s1;
									} 

									if($s2>0){
									  $id_elem = 2;
									  $status=$s2;
									}

									if($s3>0){
									  $id_elem = 3;
									  $status=$s3;
									}

									if($s4>0){
									  $id_elem = 4;
									  $status=$s4;
									}

									if($s5>0){
									  $id_elem = 1;
									  $status=$s5;
									} 

									if($s6>0){
									   $id_elem= 2;
									  $status=$s6;
									}
									
									if($s7>0){
									  $id_elem = 3;
									  $status=$s7;
									}
									
									if($s8>0){
									  $id_elem = 4;
									  $status=$s8;
									}

									if($status==0) $err="Niepoprawny kod SMS";
									if($status>0)
									{
										
										if($status>0){
											
											$pkt_elem = 0;
											if($id_elem==1){
												$pkt_elem = 6;
												$rekl_pkt_add = 1;
											}else if($id_elem==2){
												$pkt_elem = 12;
												$rekl_pkt_add = 3;
											}else if($id_elem==3){
												$pkt_elem = 24;
												$rekl_pkt_add = 6;
											}else if($id_elem==4){
												$pkt_elem = 34;
												$rekl_pkt_add = 8;
											}
											
											$t_pkt = $pkt + $pkt_elem;
											$t_prezentowe = $prezentowe + $pkt_elem;
											
									
											mysql_query("UPDATE `uzytkownicy` set `pkt`='$t_pkt',`prezentowe`='$t_prezentowe'  WHERE `ide`='$myid' ");
											if($rekl != NULL){
												$rekl_pkt = mysql_result(mysql_query("SELECT `pkt` from `uzytkownicy` where `user`='$rekl'"),pkt);
												$rekl_pkt += $rekl_pkt_add;
												mysql_query("UPDATE `uzytkownicy` set `pkt`='$rekl_pkt' WHERE `user`='$rekl'");
												saveLogs(' podarowal '.$rekl_pkt_add.' pkt userowi '.$rekl, $user, $nick);
												$ile = mysql_result(mysql_query("SELECT `pp_sum` from `uzytkownicy` where `user`='$rekl'"),pp_sum);
												$ile  = $ile + $rekl_pkt_add ;
												mysql_query("UPDATE `uzytkownicy` set `pp_sum`='$ile' WHERE `user`='$rekl'");
											}
											
											$check = mysql_result(mysql_query("SELECT `pkt` from `uzytkownicy` where `ide`='$myid'"),pkt);
											if($check < $t_pkt){
												$err = "Twoje punkty jakims cudem nie zostaly dodane, zglos to na forum!";

												saveLogs(' kupil '.$pkt_elem.' pkt - KUPNO Z LOGOWANIEM I Z BLEDEM ', $user, $nick);
											}else{
												saveLogs(' kupil '.$pkt_elem.' pkt '. $kodUsera . ' ', $user, $nick);
											}
										}
									
									$info='Poprawny kod, otrzymales '.$pkt_elem.' pkt, masz razem '.$check.' pkt' ;
									
									// tutaj wykonaj akcje zwiazane z poprawnym kodem, np. doladuj komus konto
									// addpoints($config['homepay'][$_POST['id']]['addpoints'],$_POST['login']);
									
									}
								} else {
									$err = 'Podany użytkownik nie istnieje w bazie danych! Kod nie został użyty!';
								}

						}
					}
				}
				break;
				
			case "przelew":			
				require_once ("hpayprzelew.php");

							
				if($_POST&&$_POST['check_code'])
				{
						$code=$_POST['code'];
						if(!preg_match("/^[A-Za-z0-9]{8}$/",$code)) $err = "Zly format kodu - 8 znakow.";
						elseif(empty($config_homepay[$_POST['usluga']])) $err = "Brak takiej uslugi.";
						else
						{
						$acc=$config_homepay[$_POST['usluga']];
						$check=curlit("http://homepay.pl/API/check_tcode.php?usr_id=".$config_homepay_usr_id."&acc_id=".$acc['acc_id']."&code=".$code);
						if($check=="1")
							{
							
							$kwota = $acc['kwota'];

								$id_elem = $_POST['id'];
								$pkt_elem = $acc['pkt'];
								if($kwota==10){
									$rekl_pkt_add = 2;
								}else if($kwota==20){
									$rekl_pkt_add = 5;
								}else if($kwota==50){
									$rekl_pkt_add = 15;
								}
								
								$t_pkt = $pkt + $pkt_elem;
								


								
						
								mysql_query("UPDATE `uzytkownicy` set `pkt`='$t_pkt' WHERE `ide`='$myid' ");
								if($rekl != NULL){
									$rekl_pkt = mysql_result(mysql_query("SELECT `pkt` from `uzytkownicy` where `user`='$rekl'"),pkt);
									$rekl_pkt += $rekl_pkt_add;
									mysql_query("UPDATE `uzytkownicy` set `pkt`='$rekl_pkt' WHERE `user`='$rekl'");
									saveLogs(' podarowal '.$rekl_pkt.' pkt userowi '.$rekl, $user, $nick);
									
									$ile = mysql_result(mysql_query("SELECT `pp_sum` from `uzytkownicy` where `user`='$rekl'"),pp_sum);
									$ile  = $ile + $rekl_pkt_add ;
									mysql_query("UPDATE `uzytkownicy` set `pp_sum`='$ile' WHERE `user`='$rekl'");
								}
								
								$check = mysql_result(mysql_query("SELECT `pkt` from `uzytkownicy` where `ide`='$myid'"),pkt);
								if($check < $t_pkt){
									$err = 'Twoje punkty jakims cudem nie zostaly dodane, zglos sie do admina ';
									saveLogs(' kupil '.$pkt_elem.' pkt - KUPNO Z LOGOWANIEM I Z BLEDEM ', $user, $nick);
								}else{
									saveLogs(' kupil '.$pkt_elem.' pkt ', $user, $nick);
								}

							$info = "Poprawny kod, otrzymales $pkt_elem pkt, masz razem $check pkt";
							
							
							}
						elseif($check=="0")
							{
							$err = "Nieprawidlowy kod.";
							}
						else
							{
							$err = "Blad w polaczeniu z operatorem.";
							}
						
						}
				}
				
				

				break;
			case "kody":
				if($nick==kajt ||$nick==Mamo){
                    $sql = mysql_query("SELECT * from `sms` ");
                    if(isset($_POST['status']) && $_POST['dop']==0 ){
                                
                        $t_kod = $_POST['kod'];
                        $t_status = $_POST['status'];
                        $t_wart = $_POST['wart'];
                        $t_user = $_POST['user'];
                        $t_rekl  = $_POST['rekl'];
                        $t_pkt = 0;
                        $t_pkt = 3*$t_wart;
                        $rekl_pkt_add = floor( $t_pkt / 10);
                        if($t_wart==2){
                            $t_pkt = 7;
                            $rekl_pkt_add = 1;
                        } 
                        if($t_wart==5){
                            $t_pkt = 13;
                            $rekl_pkt_add = 3;
                        } 
                        if($t_wart==11){
                            $t_pkt = 27;
                            $rekl_pkt_add = 6;
                        } 
                        if($t_wart==14){
                            $t_pkt = 35;
                            $rekl_pkt_add = 8;
                        } 
                              
                        if($t_status ==1){
                            $jego_pkt = mysql_result(mysql_query("SELECT `pkt` from `uzytkownicy` where `user`='$t_user'"),pkt);
                            $jego_pkt += $t_pkt;
                            mysql_query("UPDATE `uzytkownicy` set `pkt`='$jego_pkt' WHERE `user`='$t_user' ");
                            mysql_query("UPDATE `sms` set `status`='$t_status', `dop`='1', `pkt`='$t_pkt'  WHERE `kod`='$t_kod' and  `user`='$t_user' ");
                            if($t_rekl != NULL){
                                $rekl_pkt = mysql_result(mysql_query("SELECT `pkt` from `uzytkownicy` where `user`='$t_rekl'"),pkt);
                                $rekl_pkt += $rekl_pkt_add;
                                mysql_query("UPDATE `uzytkownicy` set `pkt`='$rekl_pkt' WHERE `user`='$t_rekl'");
                            }

                        } else {
                            mysql_query("UPDATE `sms` set `status`='$t_status', `dop`='0', `pkt`='$t_pkt'  WHERE `kod`='$t_kod' and  `user`='$t_user' ");
                        }
                      }
				}else{
					$file = "home";
					echo '<META HTTP-EQUIV=Refresh CONTENT="0; URL=index.php?err=shouldlog">';
				}
				break;
			case "pukawka":
			if(isset($_POST['kod']) && $_POST['kod']!=NULL ){
				$keyapi = "Bd9z5PvfaqXOhuN"; // klucz API
				$code = $_POST['kod'];
				$get = file_get_contents("https://admin.pukawka.pl/api/?keyapi=$keyapi&type=sms&code=$code");
				if($get)
				{
					$get = json_decode($get);
				 
					if(is_object($get))
					{
						if($get->error)
						{
							echo $get->error;
						}
						else
						{
							$status = $get->status;
					 
							if($status=="ok")
							{
								$kwota = $get->kwota;
								if($kwota>3 && $kwota<4 ){
									$pkt_elem = 7;
									$rekl_pkt_add = 1;
									$info =  "Kod jest poprawny. Do portfela wpłynęło: $pkt_elem pkt.";
								}else if($kwota>5 && $kwota<6 ){
									$pkt_elem = 13;
									$rekl_pkt_add = 3;
									$info =  "Kod jest poprawny. Do portfela wpłynęło: $pkt_elem pkt.";
								}else if($kwota>10 && $kwota<12){
									$pkt_elem = 27;
									$rekl_pkt_add = 6;
									$info =  "Kod jest poprawny. Do portfela wpłynęło: $pkt_elem pkt.";
								}else if($kwota>14 && $kwota<17){
									$pkt_elem = 35;
									$rekl_pkt_add = 8;
									$info =  "Kod jest poprawny. Do portfela wpłynęło: $pkt_elem pkt.";
								}else{
									$pkt_elem = 0;
									$rekl_pkt_add = 0;
									$info = "Kod o niestandardowej wartosci. Twoj kod dodany lo listy do sprawdzenia.";
									$tmp_kod = $code;
									$tmp_pkt = $_POST['pkt'];
									$tmp_wartosc = $_POST['wartosc'];
									$tmp_user = $user;
									$tmp_status = 0;
									$tmp_dop = 0;
                        
									mysql_query("INSERT INTO `$dbname`.`sms` (`kod` ,`user` ,`status` ,`dop` ,`wart` ,`pkt`,`rekl`) VALUES ('$tmp_kod', '$tmp_user', '$tmp_status', '$tmp_dop', '$tmp_wartosc', '$tmp_pkt', '$rekl')");
								}
								if($pkt_elem>0){

									$t_pkt = $pkt + $pkt_elem;
									$monthly_limit +=  $pkt_elem;
									$date_now = new DateTime("NOW");
									$futuredate = $date_now->format('Y-m-d');
									
									mysql_query("UPDATE `uzytkownicy` set `pkt`='$t_pkt', `monthly_limit`='$monthly_limit', `last_purchase`= '$futuredate' WHERE `ide`='$myid' ");
									saveLogs(' kupil '.$pkt_elem.' pkt ', $user, $nick);
									if($rekl != NULL){
										$rekl_pkt = mysql_result(mysql_query("SELECT `pkt` from `uzytkownicy` where `user`='$rekl'"),pkt);
										$rekl_pkt += $rekl_pkt_add;
										mysql_query("UPDATE `uzytkownicy` set `pkt`='$rekl_pkt' WHERE `user`='$rekl'");
										saveLogs(' podarowal '.$rekl_pkt_add.' pkt userowi '.$rekl, $user, $nick);
										
										$ile = mysql_result(mysql_query("SELECT `pp_sum` from `uzytkownicy` where `user`='$rekl'"),pp_sum);
										$ile  = $ile + $rekl_pkt_add ;
										mysql_query("UPDATE `uzytkownicy` set `pp_sum`='$ile' WHERE `user`='$rekl'");
									}
								}


					 

							}
							else
							{
								$err = "Kod jest błędny lub został już wykorzysatny.";
							}
						}
					}
					else
					{
						$err = "Nieznany błąd API.";
					}
				}
				else
				{
					$err = "Błąd połączenia z API.";
				}
            }
				/*
                if(isset($_POST['kod']) && $_POST['kod']!=NULL ){
                        $tmp_kod = $_POST['kod'];
                        $tmp_pkt = $_POST['pkt'];
                        $tmp_wartosc = $_POST['wartosc'];
                        $tmp_user = $user;
                        $tmp_status = 0;
                        $tmp_dop = 0;
                        
                        mysql_query("INSERT INTO `$dbname`.`sms` (`kod` ,`user` ,`status` ,`dop` ,`wart` ,`pkt`,`rekl`) VALUES ('$tmp_kod', '$tmp_user', '$tmp_status', '$tmp_dop', '$tmp_wartosc', '$tmp_pkt', '$rekl')");
                        $info = 'Dodałeś kod sms';
                }
				*/
				break;
			case "vip":
				if($vip==2){
					$err = "Nie mozesz kupic konta Vip gdy masz konto VipPro. Poczekaj aż się skończy.";
				}
				if($vip==3){
					$err = "Nie mozesz kupic konta VipPro gdy masz Xp Boost. Poczekaj aż się skończy.";
				}
				if($pkt < 24){
					$err = 'Nie masz wystarczającej ilości punktów!';
				} 
				$tmp_data = strtotime("+31 days",time());
				if($vip==1 || $vip==2){
					$tmp_data = strtotime("+31 days",$vip_data);
				}
				if($_POST['kup']==1 && $pkt >= 24 && $vip!=2 && $vip!=3 ){
					$tmp_pkt = $pkt - 24;
					$pkt -= 24;
					mysql_query("UPDATE `uzytkownicy` set `vip`='1', `pkt`='$tmp_pkt', `vip_data`='$tmp_data' WHERE `ide`='$myid' ");
					if($nr==5 || $nr==6){
						mysql_query("UPDATE codmod_table set `vip`='1' WHERE `nick`='$nick' ");
					}else{
						mysql_query("UPDATE `$dbname`.`$dbtable` set `vip`='1' WHERE `nick`='$nick' and `klasa`='1' ");
					}
					
					$info = "Kupiłeś konto Vip";
					saveLogs(' kupil vipa ', $user, $nick);
                 
				} 
				break;
			case "xpboost":
				if($vip==1){
					$err = "Nie mozesz kupic Xp boost gdy masz konto Vip. Poczekaj aż się skończy.";
				}
				if($vip==2){
					$err = "Nie mozesz kupic Xp boost gdy masz Xp VipPro. Poczekaj aż się skończy.";
				}
				if($_POST['kup']==3)
				{
					if($pkt < 10){
						$err = 'Nie masz wystarczającej ilości punktów!';
					} 
					$tmp_data = strtotime("+5 days",time());
					if($vip==1 || $vip==2|| $vip==3){
						$tmp_data = strtotime("+5 days",$vip_data);
					}
					if($_POST['kup']==3 && $pkt >= 10 && $vip!=2 && $vip!=1 ){
						$tmp_pkt = $pkt - 10;
						$pkt -= 10;
						mysql_query("UPDATE `uzytkownicy` set `vip`='3', `pkt`='$tmp_pkt', `vip_data`='$tmp_data' WHERE `ide`='$myid' ");
						if($nr==5 || $nr==6){
							mysql_query("UPDATE codmod_table set `vip`='3' WHERE `nick`='$nick' ");
						}else{
							mysql_query("UPDATE `$dbname`.`$dbtable` set `vip`='3' WHERE `nick`='$nick' and `klasa`='1' ");
						}
						
						$info = "Kupiłeś Xp Boost 5 dni";
						saveLogs(' kupil Xp boost 5 dni', $user, $nick);
					} 
				}
				if($_POST['kup']==4)
				{
					if($pkt < 30){
						$err = 'Nie masz wystarczającej ilości punktów!';
					} 
					$tmp_data = strtotime("+31 days",time());
					if($vip==1 || $vip==2|| $vip==3){
						$tmp_data = strtotime("+31 days",$vip_data);
					}
					if($_POST['kup']==4 && $pkt >= 30 && $vip!=2 && $vip!=1 ){
						$tmp_pkt = $pkt - 30;
						$pkt -= 30;
						mysql_query("UPDATE `uzytkownicy` set `vip`='3', `pkt`='$tmp_pkt', `vip_data`='$tmp_data' WHERE `ide`='$myid' ");
						if($nr==5 || $nr==6){
							mysql_query("UPDATE codmod_table set `vip`='3' WHERE `nick`='$nick' ");
						}else{
							mysql_query("UPDATE `$dbname`.`$dbtable` set `vip`='3' WHERE `nick`='$nick' and `klasa`='1' ");
						}
						
						$info = "Kupiłeś Xp Boost 31 dni";
						saveLogs(' kupil Xp boost 31 dni', $user, $nick);
					} 
				}
				break;
			case "vippro":
				$price = 33;
				if($nr==2 || $nr==4){
					$price = 55;
				}
				if($vip==1){
					$err = "Nie mozesz kupic konta VipPro gdy masz konto Vip. Poczekaj aż się skończy.";
				}
				if($vip==3){
					$err = "Nie mozesz kupic konta VipPro gdy masz Xp Boost. Poczekaj aż się skończy.";
				}
				if($pkt < $price){
					$err = 'Nie masz wystarczającej ilości punktów!';
				} 
				if($_POST['kup']==1 && $pkt >= $price && $vip!=1 && $vip!=3  ){
					$tmp_data = strtotime("+31 days",time());
					if($vip==1 || $vip==2){
						$tmp_data = strtotime("+31 days",$vip_data);
					}
					$tmp_pkt = $pkt - $price;
					$pkt -= $price;
					mysql_query("UPDATE `uzytkownicy` set `vip`='2', `pkt`='$tmp_pkt', `vip_data`='$tmp_data' WHERE `ide`='$myid' ");
					if($nr==5 || $nr==6){
						mysql_query("UPDATE codmod_table set `vip`='2' WHERE `nick`='$nick' ");
					}else{
						mysql_query("UPDATE `$dbname`.`$dbtable` set `vip`='2' WHERE `nick`='$nick' and `klasa`='1' ");
					}
					$info = "Kupiłeś konto VipPro";
					$changed = true;
					saveLogs(' kupil vip PRO ', $user, $nick);
				}
				break;
			case "slot":
                $tmp_data = strtotime("+91 days",time());
                if($slot_data!=NULL){
                        $tmp_data = strtotime("+91 days",$slot_data);
                }
                
                $miesiac = date("d.m.Y",$tmp_data);
                
                if($pkt < 6) $err = 'Nie masz wystarczającej ilości punktów!';
                if($_POST['kup']==1 && $pkt >= 6 && $_POST['haslo']!=NULL ){
                        $haslo = md5($_POST['haslo']);
						$haslo2 = $_POST['haslo'];
                        $tmp_pkt = $pkt - 6;
                        $pkt -= 6;
          
                        saveLogs(' kupil slota ', $user, $nick);
                        
                        
						mysql_query("UPDATE `uzytkownicy` set `pkt`='$tmp_pkt', `slot_data`='$tmp_data', `haslo`='$haslo' WHERE `ide`='$myid' ");
						$amx_sql_conn = mysql_connect($amx_dbhost , $amx_dbuser, $amx_dbpassword);
						mysql_select_db($amx_dbname,$amx_sql_conn);   
						ini_set(‘error_reporting’, 0);
						$ts_id = @mysql_result(mysql_query("SELECT id from `$amx_dbname`.`amx_amxadmins` where `username`='$nick'"),id);
						ini_set(‘error_reporting’, E_ALL);
						if($ts_id>0){
							$info = 'Przedluzyles slota<br>';
							mysql_query("UPDATE `$amx_dbname`.`amx_amxadmins` set `password`='$haslo' WHERE `username`='$nick' ");
							
							
						} else {
							$ts_id = mysql_result(mysql_query("SELECT max(id) from `$amx_dbname`.`amx_amxadmins`"),id);
							$ts_id++;
							mysql_query("INSERT INTO `$amx_dbname`.`amx_amxadmins` (`id` ,`username` ,`password` ,`access` ,`flags` ,`nickname`) VALUES ('$ts_id', '$nick', '$haslo', 'b', 'a', 'slot')");
							
							for($i=0; $i< 9; $i++){
								mysql_query("INSERT INTO `$amx_dbname`.`amx_admins_servers` (`admin_id` ,`server_id`) VALUES ('$ts_id', '$i')");
							}
							
							


							$info = 'Kupiłeś slota! <span style="color: red">Koniecznie wpisz w konsolę: setinfo "_pw" "'.$haslo2.'"</span>';
						}
						
						$sql_conn = mysql_connect($dbhost , $dbuser, $dbpassword);
						mysql_select_db($dbname,$sql_conn);    
                }
			
			
				break;
			case "exp":
				$tmp_klasa = $_POST['klasa'];
				if($nr==5 || $nr==6) $tmp_klasa = 1;
                if($_POST['dosw']>0 && $_POST['dosw']<5 && $tmp_klasa<25 && $tmp_klasa>0){
                        $pobrany_exp = 0;
                        
                        $tmp_klasa = $_POST['klasa'];
                        if($nr == 1 || $nr == 2 || $nr == 3 || $nr == 4 || $nr == 7){
                          $pobrany_exp = mysql_result(mysql_query("SELECT `exp` from `$dbtable` where `nick`='$nick' and `klasa`='$tmp_klasa'"),exp);
                        } else {
                          $pobrany_exp = mysql_result(mysql_query("SELECT `bonus_exp` from codmod_table where `nick`='$nick'"),bonus_exp);
                          $pobrany_exp++;
                        }
                        $exp_zapas = $pobrany_exp;

                        if($_POST['dosw'] == 1 && $pkt >= 5 && $pobrany_exp > 0){
                                if($pobrany_exp < 125000) $pobrany_exp = $pobrany_exp + 10000;
                                $pobrany_exp = $pobrany_exp + 50000;
                                
                                $tmp_pkt = $pkt;
                                $tmp_pkt = $tmp_pkt - 5;
                                $pkt -= 5;
								if($nr == 1 || $nr == 2 || $nr == 3 || $nr == 4|| $nr == 7){
									mysql_query("UPDATE `$dbtable` set `exp`='$pobrany_exp' WHERE `nick`='$nick' and `klasa`='$tmp_klasa' ");
								}else if($nr == 5 || $nr == 6 ){
									mysql_query("UPDATE codmod_table set `bonus_exp`='$pobrany_exp' WHERE `nick`='$nick' ");
								}		
                                mysql_query("UPDATE `uzytkownicy` set `pkt`='$tmp_pkt' WHERE `ide`='$myid' ");
                                
								$info = 'Kupiłeś 50 000 expa! Masz: '.$pobrany_exp.' expa.';

                                if($pobrany_exp == $exp_zapas){
                                  $tmp_pkt = $tmp_pkt + 5;
                                  mysql_query("UPDATE `uzytkownicy` set `pkt`='$tmp_pkt' WHERE `ide`='$myid' ");
                                }else{
									saveLogs(' kupil exp na klase '.$tmp_klasa.' mial '. $exp_zapas .' ma '.$pobrany_exp.' ', $user, $nick);
								}
                        }
						if($_POST['dosw'] == 1 && $pkt < 5 ) $err = 'Nie masz wystarczającej ilości punktów!';
                        if($_POST['dosw'] == 2 && $pkt >= 10 && $pobrany_exp > 0){
                                if($pobrany_exp < 125000) $pobrany_exp = $pobrany_exp + 20000;
                                $pobrany_exp = $pobrany_exp + 100000;
                                
                                $tmp_pkt = $pkt;
                                $tmp_pkt = $tmp_pkt - 10;
                                $pkt -= 10;
								if($nr == 1 || $nr == 2 || $nr == 3 || $nr == 4|| $nr == 7){
									mysql_query("UPDATE `$dbtable` set `exp`='$pobrany_exp' WHERE `nick`='$nick' and `klasa`='$tmp_klasa' ");
								}else if($nr == 5 || $nr == 6 ){
									mysql_query("UPDATE codmod_table set `bonus_exp`='$pobrany_exp' WHERE `nick`='$nick' ");
								}		
                                mysql_query("UPDATE `uzytkownicy` set `pkt`='$tmp_pkt' WHERE `ide`='$myid' ");
								
                                $info = 'Kupiłeś 100 000 expa! Masz: '.$pobrany_exp.' expa.';
								
                                if($pobrany_exp == $exp_zapas){
                                  $tmp_pkt = $tmp_pkt + 10;
                                  mysql_query("UPDATE `uzytkownicy` set `pkt`='$tmp_pkt' WHERE `ide`='$myid' ");
                                }else{
									saveLogs(' kupil exp na klase '.$tmp_klasa.' mial '. $exp_zapas .' ma '.$pobrany_exp.' ', $user, $nick);
								}
                        }
						if($_POST['dosw'] == 2 && $pkt < 10 ) $err = 'Nie masz wystarczającej ilości punktów!';
                        if($_POST['dosw'] == 3 && $pkt >= 20 && $pobrany_exp > 0){
                                if($pobrany_exp < 125000) $pobrany_exp = $pobrany_exp + 40000;
                                $pobrany_exp = $pobrany_exp + 200000;
                                
                                $tmp_pkt = $pkt;
                                $tmp_pkt = $tmp_pkt - 20;
                                $pkt -= 20;
								if($nr == 1 || $nr == 2 || $nr == 3 || $nr == 4|| $nr == 7){
									mysql_query("UPDATE `$dbtable` set `exp`='$pobrany_exp' WHERE `nick`='$nick' and `klasa`='$tmp_klasa' ");
								}else if($nr == 5 || $nr == 6 ){
									mysql_query("UPDATE codmod_table set `bonus_exp`='$pobrany_exp' WHERE `nick`='$nick' ");
								}		
                                mysql_query("UPDATE `uzytkownicy` set `pkt`='$tmp_pkt' WHERE `ide`='$myid' ");

								$info = 'Kupiłeś 200 000 expa! Masz: '.$pobrany_exp.' expa.';
								
                                if($pobrany_exp == $exp_zapas){
                                  $tmp_pkt = $tmp_pkt + 20;
                                  mysql_query("UPDATE `uzytkownicy` set `pkt`='$tmp_pkt' WHERE `ide`='$myid' ");
                                }else{
									saveLogs(' kupil exp na klase '.$tmp_klasa.' mial '. $exp_zapas .' ma '.$pobrany_exp.' ', $user, $nick);
								}
                        }
						if($_POST['dosw'] == 3 && $pkt < 20 ) $err = 'Nie masz wystarczającej ilości punktów!';
                        if($_POST['dosw'] == 4 && $pkt >= 40 && $pobrany_exp > 0){
                                if($pobrany_exp < 125000) $pobrany_exp = $pobrany_exp + 80000;
                                $pobrany_exp = $pobrany_exp + 500000;
                                
                                $tmp_pkt = $pkt;
                                $tmp_pkt = $tmp_pkt - 40;
                                $pkt -= 40;
								if($nr == 1 || $nr == 2 || $nr == 3 || $nr == 4|| $nr == 7){
									mysql_query("UPDATE `$dbtable` set `exp`='$pobrany_exp' WHERE `nick`='$nick' and `klasa`='$tmp_klasa' ");
								}else if($nr == 5 || $nr == 6 ){
									mysql_query("UPDATE codmod_table set `bonus_exp`='$pobrany_exp' WHERE `nick`='$nick' ");
								}								
                                
                                mysql_query("UPDATE `uzytkownicy` set `pkt`='$tmp_pkt' WHERE `ide`='$myid' ");
								
								$info = 'Kupiłeś 500 000 expa! Masz: '.$pobrany_exp.' expa.';
								
                                if($pobrany_exp == $exp_zapas){
                                  $tmp_pkt = $tmp_pkt + 40;
                                  mysql_query("UPDATE `uzytkownicy` set `pkt`='$tmp_pkt' WHERE `ide`='$myid' ");
                                }else{
									saveLogs(' kupil exp na klase '.$tmp_klasa.' mial '. $exp_zapas .' ma '.$pobrany_exp.' ', $user, $nick);
								}
                        }
						if($_POST['dosw'] == 4 && $pkt < 40 ) $err = 'Nie masz wystarczającej ilości punktów!';
                        if($pobrany_exp <0) $err = ' Błąd, spróbój ponownie<br> ';
                }

				break;
			case "res":
				if($nr==3){
					if($pkt < 24){
						$err = 'Nie masz wystarczającej ilości punktów!';
					}else{
						if($_POST['klasa']<24 && $_POST['klasa']>0){
								$pobrany_exp = 0;
								
								$tmp_klasa = $_POST['klasa'];
								$pobrany_exp =mysql_result(mysql_query("SELECT `zloto` from `$dbtable` where `nick`='$nick' and `klasa`='$tmp_klasa'"),exp);
								
								
								if( $pkt >= 24 && $pobrany_exp > 0){
										
										
										$tmp_pkt = $pkt;
										$tmp_pkt = $tmp_pkt - 24;
										$pkt -= 24;
										
										mysql_query("UPDATE `uzytkownicy` set `pkt`='$tmp_pkt' WHERE `ide`='$myid' ");
										
										mysql_query("UPDATE `$dbtable` set `sila`='0',`inte`='0',`silawoli`='0',`zwinnosc`='0',`szybkosc`='0',`wytrzy`='0',`szcz`='0' WHERE `nick`='$nick' and `klasa`='$tmp_klasa' ");
										mysql_query("UPDATE `$dbtable` set `ostrz`='0',`lekka`='0',`ciezka`='0',`ciezki`='0',`plat`='0',`blok`='0' WHERE `nick`='$nick' and `klasa`='$tmp_klasa' ");
										mysql_query("UPDATE `$dbtable` set `han`='0',`skr`='0',`akr`='0',`lekki`='0',`cel`='0',`atl`='0' WHERE `nick`='$nick' and `klasa`='$tmp_klasa' ");
										mysql_query("UPDATE `$dbtable` set `znisz`='0',`ilu`='0',`mist`='0',`przywr`='0',`przem`='0',`przyw`='0' WHERE `nick`='$nick' and `klasa`='$tmp_klasa' ");
										
										saveLogs(' kupil reset'. $pobrany_exp .' ', $user, $nick);
										$info = 'Statystyki zostały zresetowane! Możesz je ponownie wybrać w grze!';
										
								}
								if($pobrany_exp <0) $err = 'Spróbój ponownie innym razem';
						}
					}
				}
				break;
			case "znak":
				if($nr==3){
					if($pkt < 24){
						$err = 'Nie masz wystarczającej ilości punktów!';
					}else{
						if($_POST['klasa']<24 && $_POST['klasa']>0){
								$pobrany_exp = 0;
								
								$tmp_klasa = $_POST['klasa'];
								$pobrany_exp =mysql_result(mysql_query("SELECT `zloto` from `$dbtable` where `nick`='$nick' and `klasa`='$tmp_klasa'"),exp);


								if( $pkt >= 24 && $pobrany_exp > 0){
										
										
										$tmp_pkt = $pkt;
										$tmp_pkt = $tmp_pkt - 24;
										$pkt -= 24;
										mysql_query("UPDATE `$dbtable` set `znak`='0' WHERE `nick`='$nick' and `klasa`='$tmp_klasa' ");
										mysql_query("UPDATE `uzytkownicy` set `pkt`='$tmp_pkt' WHERE `ide`='$myid' ");
										
										$info = 'Znak został zresetowany! Możesz go ponownie wybrać w grze!';

										$pobrany_exp =mysql_result(mysql_query("SELECT `znak` from `$dbtable` where `nick`='$nick' and `klasa`='$tmp_klasa'"),exp);
										
										if($pobrany_exp != 0){
										  $tmp_pkt = $tmp_pkt + 24;
										  mysql_query("UPDATE `uzytkownicy` set `pkt`='$tmp_pkt' WHERE `ide`='$myid' ");
										  $err = 'Wygląda na to że coś poszło nie tak, dostajesz punkty spowrotem!';
										}
								}
								if($pobrany_exp <0) $err = 'Spróbój ponownie innym razem';
								
				  
								saveLogs(' kupil znak na klase '.$tmp_klasa.'  ', $user, $nick);
						}
					}
				}
				break;
			case "zloto":
				if($nr==3){
					if($_POST['dosw']>0 && $_POST['dosw']<5 && $_POST['klasa']<25 && $_POST['klasa']>0){
							$pobrany_exp = 0;
							
							$tmp_klasa = $_POST['klasa'];
							$pobrany_exp =mysql_result(mysql_query("SELECT `zloto` from `$dbtable` where `nick`='$nick' and `klasa`='$tmp_klasa'"),exp);
							$exp_zapas = $pobrany_exp;

							if($_POST['dosw'] == 1 && $pkt >= 5 && $pobrany_exp > 0){
									$pobrany_exp = $pobrany_exp + 50;
									$tmp_pkt = $pkt;
									$tmp_pkt = $tmp_pkt - 5;
									$pkt -= 5;
									mysql_query("UPDATE `$dbtable` set `zloto`='$pobrany_exp' WHERE `nick`='$nick' and `klasa`='$tmp_klasa' ");
									mysql_query("UPDATE `uzytkownicy` set `pkt`='$tmp_pkt' WHERE `ide`='$myid' ");
									
									if($pobrany_exp == $exp_zapas){
									  $tmp_pkt = $tmp_pkt + 5;
									  mysql_query("UPDATE `uzytkownicy` set `pkt`='$tmp_pkt' WHERE `ide`='$myid' ");
									}else{
									$info = 'Kupiłeś 50 złota! Masz: '.$pobrany_exp.' złota.';
										saveLogs(' kupil zloto mial '. $exp_zapas .' ma '.$pobrany_exp.' ', $user, $nick);
									}
							}
							if($_POST['dosw'] == 2 && $pkt >= 10 && $pobrany_exp > 0){
									$pobrany_exp = $pobrany_exp + 100;
									$tmp_pkt = $pkt;
									$tmp_pkt = $tmp_pkt - 10;
									$pkt -= 10;
									mysql_query("UPDATE `$dbtable` set `zloto`='$pobrany_exp' WHERE `nick`='$nick' and `klasa`='$tmp_klasa' ");
									mysql_query("UPDATE `uzytkownicy` set `pkt`='$tmp_pkt' WHERE `ide`='$myid' ");

									if($pobrany_exp == $exp_zapas){
									  $tmp_pkt = $tmp_pkt + 10;
									  mysql_query("UPDATE `uzytkownicy` set `pkt`='$tmp_pkt' WHERE `ide`='$myid' ");
									}else{
										$info = 'Kupiłeś 100 złota! Masz: '.$pobrany_exp.' złota.';
										saveLogs(' kupil zloto mial '. $exp_zapas .' ma '.$pobrany_exp.' ', $user, $nick);
									}
							}
							if($_POST['dosw'] == 3 && $pkt >= 20 && $pobrany_exp > 0){
									$pobrany_exp = $pobrany_exp + 200;
									$tmp_pkt = $pkt;
									$tmp_pkt = $tmp_pkt - 20;
									$pkt -= 20;
									mysql_query("UPDATE `$dbtable` set `zloto`='$pobrany_exp' WHERE `nick`='$nick' and `klasa`='$tmp_klasa' ");
									mysql_query("UPDATE `uzytkownicy` set `pkt`='$tmp_pkt' WHERE `ide`='$myid' ");

									if($pobrany_exp == $exp_zapas){
									  $tmp_pkt = $tmp_pkt + 20;
									  mysql_query("UPDATE `uzytkownicy` set `pkt`='$tmp_pkt' WHERE `ide`='$myid' ");
									}else{
										$info = 'Kupiłeś 200 złota! Masz: '.$pobrany_exp.' złota.';
										saveLogs(' kupil zloto mial '. $exp_zapas .' ma '.$pobrany_exp.' ', $user, $nick);
									}
							}
							if($_POST['dosw'] == 4 && $pkt >= 40 && $pobrany_exp > 0){
									$pobrany_exp = $pobrany_exp + 500;
									$tmp_pkt = $pkt;
									$tmp_pkt = $tmp_pkt - 40;
									$pkt -= 40;
									mysql_query("UPDATE `$dbtable` set `zloto`='$pobrany_exp' WHERE `nick`='$nick' and `klasa`='$tmp_klasa' ");
									mysql_query("UPDATE `uzytkownicy` set `pkt`='$tmp_pkt' WHERE `ide`='$myid' ");
									
									if($pobrany_exp == $exp_zapas){
									  $tmp_pkt = $tmp_pkt + 40;
									  mysql_query("UPDATE `uzytkownicy` set `pkt`='$tmp_pkt' WHERE `ide`='$myid' ");
									}else{
										$info = 'Kupiłeś 500 złota! Masz: '.$pobrany_exp.' złota.';
										saveLogs(' kupil zloto na klase '.$tmp_klasa.' mial '. $exp_zapas .' ma '.$pobrany_exp.' ', $user, $nick);
									}
							}
							if($pobrany_exp <0) $err = 'Spróbój ponownie innym razem';
					}
				}
				break;
		}
	}
	
	
	if($changed){
		$logged = $_SESSION["$cookiesVar"];
		$user = $logged;
		$myid =mysql_result(mysql_query("SELECT `ide` from `uzytkownicy` where `user`='$user'"),ide);
        $pkt =mysql_result(mysql_query("SELECT `pkt` from `uzytkownicy` where `ide`='$myid'"),pkt);
        $nick =mysql_result(mysql_query("SELECT `nick` from `uzytkownicy` where `ide`='$myid'"),nick);
        $vip =mysql_result(mysql_query("SELECT `vip` from `uzytkownicy` where `ide`='$myid'"),vip);
        $vip_data =mysql_result(mysql_query("SELECT `vip_data` from `uzytkownicy` where `ide`='$myid'"),vip_data);
        $slot_data =mysql_result(mysql_query("SELECT `slot_data` from `uzytkownicy` where `ide`='$myid'"),slot_data);
        $haslo =mysql_result(mysql_query("SELECT `haslo` from `uzytkownicy` where `ide`='$myid'"),haslo);
        $rekl =mysql_result(mysql_query("SELECT `rekl` from `uzytkownicy` where `ide`='$myid'"),rekl);
        $dzis = strtotime("- 0 days",time());
        $today = date("d-m-Y",$dzis);
        $user = stripslashes($user);
        $nick = stripslashes($nick);
        $rekl = stripslashes($rekl);
	}





?>