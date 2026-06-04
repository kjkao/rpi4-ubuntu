<!DOCTYPE html>
<html>
<head>
  <title>My Info</title>
  <link rel="icon" type="image/x-icon" href="/photo.jpg">
</head>
<body>
[<a href="dhcplist.php">DHCP</a>] [<a href="myinfo.php">My Info</a>] [<a href="welcome.php">Welcome</a>]<br>
<?php

$out = shell_exec('date');
print('<pre>');
print($out);
print('</pre>');

$out = shell_exec('last -n 5 -i');
print('<pre>');
print($out);
print('</pre>');

print('<table border=0 cellspacing=4 cellpadding=4><tr><td valign=top>');
$out = shell_exec('sudo /root/scripts/iw-dev-wlan0-station-dump.sh');
$out = str_replace("\n    rx", " rx", str_replace(' bitrate', '', $out));
print('<pre>');
print($out);
print('</pre>');
print('</td><td valign=top>');
$out = shell_exec('sudo /root/scripts/dhcp-log.sh | cut -d " " -f 5,6 | sort -u');
print('<pre>');
print($out);
print('</pre>');
$out = shell_exec('sudo /root/scripts/dhcp-log.sh dhcpoffer | cut -d " " -f 3,5,6');
print('<pre>');
print($out);
print('</pre>');
print('</td></tr></table>');

$out = shell_exec('sudo /root/scripts/dhcp-log.sh noauth');
print('<pre>');
print($out);
print('</pre>');

$out = shell_exec('arp | grep -v -e incomplete');
print('<pre>');
print($out);
print('</pre>');

$out = shell_exec('uptime');
print('<pre>');
print($out);
print('</pre>');

?>
</body>
</html>

