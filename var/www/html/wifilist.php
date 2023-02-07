<?php

$out = shell_exec('uptime');
print('<pre>');
print($out);
print('</pre>');

$out = shell_exec('last -n 5 -F');
print('<pre>');
print($out);
print('</pre>');

$out = shell_exec('/var/www/html/iw-dev-wlan0-station-dump.sh');
print('<pre>');
print($out);
print('</pre>');

$out = shell_exec('/var/www/html/dhcp-log.sh noauth');
print('<pre>');
print($out);
print('</pre>');

$out = shell_exec('/var/www/html/dhcp-log.sh | cut -d " " -f 5,6 | sort -u');
print('<pre>');
print($out);
print('</pre>');

?>
