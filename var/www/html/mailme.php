<?php
header("Cache-Control: no-cache, no-store, must-revalidate"); // HTTP 1.1.
header("Pragma: no-cache"); // HTTP 1.0.
header("Expires: 0 "); // Proxies.
header("Refresh:3; url=phpinfo.php");
$out = shell_exec("sudo /root/scripts/phpcmd.sh MailMe " . $_SERVER['REMOTE_ADDR']);
print('<pre>');
print($out);
print('</pre>');

?>
