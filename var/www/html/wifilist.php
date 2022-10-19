<?php
$out = shell_exec('/var/www/html/iw-dev-wlan0-station-dump.sh');
#var_dump($out);
#header('Content-type: application/json');
print('<pre>');
print($out);
print('</pre>');
?>
