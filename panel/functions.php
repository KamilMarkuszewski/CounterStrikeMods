
<?php
if(!function_exists('curlit'))
{
function curlit($link, $post=null)
    {
    // FUNKCJA OTWIERAJACA DANY LINK Z DANYMI POST
    $ch=curl_init();
    curl_setopt($ch, CURLOPT_URL, $link);
    curl_setopt($ch, CURLOPT_HEADER, 0);
    if(!is_null($post))
	{
        curl_setopt($ch, CURLOPT_POSTFIELDS, $post);
        }
    curl_setopt($ch,CURLOPT_RETURNTRANSFER,1);
    $ch1=curl_exec($ch);
    curl_close($ch);
    return $ch1;
}
}
if (!function_exists('str_getcsv'))
{
function str_getcsv($input, $delimiter=',', $enclosure='"')
    {
    // FUNKCJA PRZETWARZAJACA DANE CSV                                                                               
    $temp=fopen("php://memory", "rw");                                              
    fwrite($temp, $input);                                                          
    fseek($temp, 0);                                                                
    $r=fgetcsv($temp, 4096, $delimiter, $enclosure);                                
    fclose($temp);                                                                  
    return $r;                                                                      
    }                                                                               
}
if(!function_exists('curlit1'))
{
function curlit1($url)
    {
    $fp = @fopen($url,'rb');
    if (!$fp)
	return false;
    $response = @stream_get_contents($fp);
    return $response;
    }
}
function check_ip()
{                 

  if(empty($_SERVER['REMOTE_ADDR']))

  return false;



  $handle = fopen('http://get.homepay.pl/ip','r');

  $data = fgets($handle);

  fclose($handle);

  return in_array($_SERVER['REMOTE_ADDR'], explode(',', $data));

}

/*
function check_ip()
    {                  
    $ips=array('188.165.233.197','31.186.83.75','31.186.84.98'); // tylko ta linijka ulega zmianie

    if (!empty($_SERVER['REMOTE_ADDR']))
    {                                  
    $ip=$_SERVER['REMOTE_ADDR'];       
    if(in_array($ip,$ips)) return true; else return false;
    }
    else                                                    
    return false;                                             
}   
*/          
?>