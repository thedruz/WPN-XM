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

require_once __DIR__ . '/php/goutte.phar';

use Goutte\Client;

$version = array();
$version['nginx']['current']       = '1.2.1';
$version['php']['current']         = '5.4.3';
$version['mariadb']['current']     = '5.5.24';
$version['xdebug']['current']      = '2.2.0';
$version['apc']['current']         = '3.1.10';
$version['phpmyadmin']['current']  = '3.4.9';
$version['adminer']['current']     = '3.3.4';

$client = new Client();

/**
 * NGINX
 */
$crawler = $client->request('GET', 'http://www.nginx.org/download/');

 $nginx_latest = $crawler->filter('a')->each(function ($node, $i) use ($version) {
    if(preg_match("#(\d+\.\d+(\.\d+)*)(.zip)$#i", $node->nodeValue, $matches)) {
        if ($version['nginx']['current'] <= $matches[1]) {
            return array('version' => $matches[1], 'url' => 'http://www.nginx.org/download/' . $node->nodeValue);
        }
    }
});

add('nginx', $nginx_latest);

/**
 * PHP
 */
$crawler = $client->request('GET', 'http://windows.php.net/downloads/releases/');

 $php_latest = $crawler->filter('a')->each(function ($node, $i) use ($version) {
    if(preg_match("#php-+(\d+\.\d+(\.\d+)*)-nts-Win32-VC9-x86.zip$#", $node->nodeValue, $matches)) {
        if ($version['php']['current'] <= $matches[1]) {
            return array('version' => $matches[1], 'url' => 'http://windows.php.net/downloads/releases/' . $node->nodeValue);
        }
    }
});

add('php', $php_latest);

/**
 * MariaDB
 */
$crawler = $client->request('GET', 'http://downloads.mariadb.org/MariaDB/+files/');

 $mariadb_latest = $crawler->filter('a')->each(function ($node, $i) use ($version) {
    if(preg_match("#(\d+\.\d+(\.\d+)*)(.*)(win32.zip)$#", $node->nodeValue, $matches)) {
        if ($version['mariadb']['current'] <= $matches[0] and '7' > $matches[0]) {
            return array('version' => $matches[1], 'url' => 'http://downloads.mariadb.org/MariaDB/+files/' . trim($node->nodeValue));
        }
    }
});

add('mariadb', $mariadb_latest);

/**
 * XDebug - PHP Extension
 */
$crawler = $client->request('GET', 'http://xdebug.org/files/');

 $xdebug_latest = $crawler->filter('a')->each(function ($node, $i) use ($version) {
    if(preg_match("#((\d+\.)?(\d+\.)?(\d+\.)?(\*|\d+))([^\s]+nts(\.(?i)(dll))$)#i", $node->nodeValue, $matches)) {
            if ($version['xdebug']['current'] <= $matches[1] ){
                return array('version' => $matches[1], 'url' => 'http://xdebug.org/files/' . $node->nodeValue);
            }
    }
});

add('xdebug', $xdebug_latest);

/**
 * APC - PHP Extension
 */
$crawler = $client->request('GET', 'http://downloads.php.net/pierre/');

 $apc_latest = $crawler->filter('a')->each(function ($node, $i) use ($version) {
    if(preg_match("#php_apc-(\d+\.\d+(\.\d+)*)(.*)-vc9-x86.zip$#", $node->nodeValue, $matches)) {
        if ($version['apc']['current'] <= $matches[1]) {
            return array('version' => $matches[1], 'url' => 'http://downloads.php.net/pierre/' . $node->nodeValue);
        }
    }
});

add('apc', $apc_latest);

//$version['apc_latest'] = substr($version['apc_latest'], 8); // remove "php_ext-" (8)

/**
 * phpMyAdmin
 */
$crawler = $client->request('GET', 'http://www.phpmyadmin.net/home_page/downloads.php');

 $phpmyadmin_latest = $crawler->filter('a')->each(function ($node, $i) use ($version) {
    if(preg_match("#(\d+\.\d+(\.\d+)*)#", $node->nodeValue, $matches)) {
        if ($version['phpmyadmin']['current'] <= $matches[0]) {
            $url = 'http://sourceforge.net/projects/phpmyadmin/files/phpMyAdmin/'.$matches[0].'/phpMyAdmin-'.$matches[0].'-english.zip/download?use_mirror=autoselect';
            return array('version' => $matches[0], 'url' => $url);
        }
    }
});

add('phpmyadmin', $phpmyadmin_latest);

/**
 * Adminer
 */
$crawler = $client->request('GET', 'http://www.adminer.org/#download');

 $adminer_latest = $crawler->filter('a')->each(function ($node, $i) use ($version) {
    if(preg_match("#(\d+\.\d+(\.\d+)*)#", $node->nodeValue, $matches)) {
        if ($version['adminer']['current'] <= $matches[0]) {
            $url = 'http://sourceforge.net/projects/adminer/files/Adminer/Adminer%20'.$matches[0].'/adminer-'.$matches[0].'.php/download?use_mirror=autoselect';
            return array('version' => $matches[0], 'url' => $url);
        }
    }
});

add('adminer', $adminer_latest);

function array_unset_null_values(array $array)
{
    foreach ($array as $key => $value) {
        if ($value === null) {
            unset($array[$key]);
        }
    }
    return $array;
}

function add($name, array $array)
{
    global $version;

    $array = array_unset_null_values($array);

    $version[$name]['latest'] = array_pop($array);
    $version[$name]['versions'] = array($version[$name]['latest']['version'] => $version[$name]['latest']['url']);
}

var_dump($version);

?>

<table>
    <thead>application</thead><thead>current version</thead><thead>latest version</thead>
<tr>
    <td>nginx</td><td><?php echo $version['nginx']['current'] ?></td><td><?php echo $version['nginx']['latest']['version'] ?></td>
</tr>
<tr>
    <td>php</td><td><?php echo $version['php']['current'] ?></td><td><?php echo $version['php']['latest']['version'] ?></td>
</tr>
<tr>
    <td>mariadb</td><td><?php echo $version['mariadb']['current'] ?></td><td><?php echo $version['mariadb']['latest']['version'] ?></td>
</tr>
<tr>
    <td>xdebug</td><td><?php echo $version['xdebug']['current'] ?></td><td><?php echo $version['xdebug']['latest']['version'] ?></td>
</tr>
<tr>
    <td>apc</td><td><?php echo $version['apc']['current'] ?></td><td><?php echo $version['apc']['latest']['version'] ?></td>
</tr>
<tr>
    <td>phpmyadmin</td><td><?php echo $version['phpmyadmin']['current'] ?></td><td><?php echo $version['phpmyadmin']['latest']['version'] ?></td>
</tr>
<tr>
    <td>adminer</td><td><?php echo $version['adminer']['current'] ?></td><td><?php echo $version['adminer']['latest']['version'] ?></td>
</tr>
</table>