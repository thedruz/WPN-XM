<?php

/*
 * ----------------------------------------------------------------------------
 * "THE BEER-WARE LICENSE" (Revision 42):
 * <daniel.winterfeldt@gmail.com>
 * wrote this file. As long as you retain this notice you
 * can do whatever you want with this stuff. If we meet some day, and you think
 * this stuff is worth it, you can buy me a beer in return Daniel Winterfeldt
 * ----------------------------------------------------------------------------
 */

if(!extension_loaded('curl'))
{
	exit('Enable PHP extension cURL.');
}

require_once __DIR__ . 'php/goutte.phar';

use Goutte\Client;

$version = array();
$version['nginx_current']       = '1.2.1';
$version['php_current']         = '5.4.3';
$version['mariadb_current']     = '5.5.24';
$version['xdebug_current']      = '2.2.0';
$version['apc_current']         = '3.1.10';
$version['phpmyadmin_current']  = '3.4.9';
$version['adminer_current']     = '3.3.4';

$client = new Client();

/**
 * NGINX
 */
$crawler = $client->request('GET', 'http://www.nginx.org/download/');

 $nginx_latest = $crawler->filter('a')->each(function ($node, $i) use ($version) {
    if(preg_match("#(\d+\.\d+(\.\d+)*)#", $node->nodeValue, $matches)) {
        if ($version['nginx_current'] <= $matches[0]) {
            return $matches[0];
        }
    }
});

foreach ($nginx_latest as $key => $value) {
    if ($value != null) {
        $version['nginx_latest'] = $value;
    }
}

/**
 * PHP
 */
$crawler = $client->request('GET', 'http://windows.php.net/downloads/releases/');

$php_latest = $crawler->filter('a')->each(function ($node, $i) use ($version) {
    if(preg_match("#(\d+\.\d+(\.\d+)*)#", $node->nodeValue, $matches)) {
        if ($version['php_current'] <= $matches[0]) {
            return $matches[0];
        }
    }
});

foreach ($php_latest as $key => $value) {
    if ($value != null) {
        $version['php_latest'] = $value;
    }
}

/**
 * MariaDB
 */
$crawler = $client->request('GET', 'http://downloads.mariadb.org/MariaDB/+files/');

 $mariadb_latest = $crawler->filter('a')->each(function ($node, $i) use ($version) {
    if(preg_match("#(\d+\.\d+(\.\d+)*)#", $node->nodeValue, $matches)) {
        if ($version['mariadb_current'] <= $matches[0]) {
            return $matches[0];
        }
    }
});

foreach ($mariadb_latest as $key => $value) {
    if ($value != null) {
        $version['mariadb_latest'] = $value;
    }
}

/**
 * XDebug - PHP Extension
 */
$crawler = $client->request('GET', 'http://xdebug.org/files/');

 $xdebug_latest = $crawler->filter('a')->each(function ($node, $i) use ($version) {
    if(preg_match("#((\d+\.)?(\d+\.)?(\d+\.)?(\*|\d+))([^\s]+nts(\.(?i)(dll))$)#i", $node->nodeValue, $matches)) {
            if ($version['xdebug_current'] <= $matches[0] ){
                return $matches[0];
            }
    }
});

foreach ($xdebug_latest as $key => $value) {
    if ($value != null) {
        $version['xdebug_latest'] = $value;
    }
}

$version['xdebug_latest'] = substr($version['xdebug_latest'], 0, -4); // remove ".dll" (4)

/**
 * APC - PHP Extension
 */
$crawler = $client->request('GET', 'http://downloads.php.net/pierre/');

 $apc_latest = $crawler->filter('a')->each(function ($node, $i) use ($version) {
    if(preg_match("#php_apc-(\d+\.\d+(\.\d+)*)#", $node->nodeValue, $matches)) {
        if ($version['apc_current'] <= $matches[0]) {
            return $matches[0];
        }
    }
});

foreach ($apc_latest as $key => $value) {
    if ($value != null) {
        $version['apc_latest'] = $value;
    }
}

$version['apc_latest'] = substr($version['apc_latest'], 8); // remove "php_ext-" (8)

/**
 * phpMyAdmin
 */
$crawler = $client->request('GET', 'http://www.phpmyadmin.net/home_page/downloads.php');

 $phpmyadmin_latest = $crawler->filter('a')->each(function ($node, $i) use ($version) {
    if(preg_match("#(\d+\.\d+(\.\d+)*)#", $node->nodeValue, $matches)) {
        if ($version['phpmyadmin_current'] <= $matches[0]) {
            return $matches[0];
        }
    }
});

foreach ($phpmyadmin_latest as $key => $value) {
    if ($value != null) {
        $version['phpmyadmin_latest'] = $value;
    }
}

/**
 * Adminer
 */
$crawler = $client->request('GET', 'http://www.adminer.org/#download');

 $adminer_latest = $crawler->filter('a')->each(function ($node, $i) use ($version) {
    if(preg_match("#(\d+\.\d+(\.\d+)*)#", $node->nodeValue, $matches)) {
        if ($version['adminer_current'] <= $matches[0]) {
            return $matches[0];
        }
    }
});

foreach ($adminer_latest as $key => $value) {
    if ($value != null) {
        $version['adminer_latest'] = $value;
    }
}

?>

<table>
    <thead>application</thead><thead>current version</thead><thead>latest version</thead>
<tr>
    <td>nginx</td><td><?php echo $version['nginx_current'] ?></td><td><?php echo $version['nginx_latest'] ?></td>
</tr>
<tr>
    <td>php</td><td><?php echo $version['php_current'] ?></td><td><?php echo $version['php_latest'] ?></td>
</tr>
<tr>
    <td>mariadb</td><td><?php echo $version['mariadb_current'] ?></td><td><?php echo $version['mariadb_latest'] ?></td>
</tr>
<tr>
    <td>xdebug</td><td><?php echo $version['xdebug_current'] ?></td><td><?php echo $version['xdebug_latest'] ?></td>
</tr>
<tr>
    <td>apc</td><td><?php echo $version['apc_current'] ?></td><td><?php echo $version['apc_latest'] ?></td>
</tr>
<tr>
    <td>phpmyadmin</td><td><?php echo $version['phpmyadmin_current'] ?></td><td><?php echo $version['phpmyadmin_latest'] ?></td>
</tr>
<tr>
    <td>adminer</td><td><?php echo $version['adminer_current'] ?></td><td><?php echo $version['adminer_latest'] ?></td>
</tr>
</table>