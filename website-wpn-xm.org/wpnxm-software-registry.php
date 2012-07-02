<?php
   /**
    * WPИ-XM Server Stack
    * Jens-André Koch © 2010 - onwards
    * http://wpn-xm.org/
    *
    *        _\|/_
    *        (o o)
    +-----oOO-{_}-OOo------------------------------------------------------------------+
    |                                                                                  |
    |    LICENSE                                                                       |
    |                                                                                  |
    |    WPИ-XM Serverstack is free software; you can redistribute it and/or modify    |
    |    it under the terms of the GNU General Public License as published by          |
    |    the Free Software Foundation; either version 2 of the License, or             |
    |    (at your option) any later version.                                           |
    |                                                                                  |
    |    WPИ-XM Serverstack is distributed in the hope that it will be useful,         |
    |    but WITHOUT ANY WARRANTY; without even the implied warranty of                |
    |    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the                 |
    |    GNU General Public License for more details.                                  |
    |                                                                                  |
    |    You should have received a copy of the GNU General Public License             |
    |    along with this program; if not, write to the Free Software                   |
    |    Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA    |
    |                                                                                  |
    +----------------------------------------------------------------------------------+
    */

/**
 * WPN-XM Software Components Registry
 * ====================================
 *
 * The array has the following structure:
 *
 * a) Version => URL Relationship of a Component
 *
 *      $registry[$software_component_name][$version_number] => ['url']
 *      e.g. $url = $registry['nginx']['1.2.1'];
 *
 * b) Latest Version and URL of a Component
 *
 *      $registry[$software_component_name]['latest']['url']
 *      $registry[$software_component_name]['latest']['version']
 *      e.g. $url = $registry['nginx']['latest']['url'];
 *      $version = $registry['nginx']['latest']['version'];
 *
 */
$registry = array(
    'nginx'             =>  array( '1.2.1' => 'http://www.nginx.org/download/nginx-1.2.1.zip',
                                array( 'latest' =>
                                    array( 'version' => '1.2.1',
                                            'url'    => 'http://www.nginx.org/download/nginx-1.2.1.zip'))),

    'php'               =>  array( '5.4.4'  => 'http://windows.php.net/downloads/releases/php-5.4.4-nts-Win32-VC9-x86.zip',
                                array( 'latest' =>
                                    array( 'version' => '5.4.4',
                                            'url'    => 'http://windows.php.net/downloads/releases/php-5.4.4-nts-Win32-VC9-x86.zip'))),

    'mariadb'           =>  array( '5.5.24' => 'http://mirror3.layerjet.com/mariadb/mariadb-5.5.24/windows/mariadb-5.5.24-win32.zip',
                                array( 'latest' =>
                                    array( 'version' => '5.5.24',
                                            'url'    => 'http://mirror3.layerjet.com/mariadb/mariadb-5.5.24/windows/mariadb-5.5.24-win32.zip'))),

    'phpext_xdebug'     =>  array( '2.2.0RC2' => 'http://xdebug.org/files/php_xdebug-2.2.0RC2-5.4-vc9-nts.dll',
                                 array( 'latest' =>
                                    array( 'version' => '2.2.0RC2',
                                            'url'    => 'http://xdebug.org/files/php_xdebug-2.2.0RC2-5.4-vc9-nts.dll'))),

    'phpext_memcache'   =>  array( '2.2.6' => 'http://downloads.php.net/pierre/php_memcache-2.2.6-5.3-vc9-x86.zip',
                                array( 'latest' =>
                                    array( 'version' => '2.2.6',
                                            'url'    => 'http://downloads.php.net/pierre/php_memcache-2.2.6-5.3-vc9-x86.zip'))),

    'phpext_zeromq'     =>  array( '1.0' => 'http://snapshot.zero.mq/download/win32/php53-ext/php-zmq-20111011_12-39.zip',
                                array( 'latest' =>
                                    array( 'version' => '1.0',
                                            'url'    => 'http://snapshot.zero.mq/download/win32/php53-ext/php-zmq-20111011_12-39.zip'))),

    'phpext_apc'        =>  array( '3.1.10' => 'http://wpn-xm.org/files/php_apc-3.1.10-5.4-vc9-x86-xp.zip',
                                array( 'latest' =>
                                    array( 'version' => '3.1.10',
                                            'url'    => 'http://wpn-xm.org/files/php_apc-3.1.10-5.4-vc9-x86-xp.zip'))),

    'phpmyadmin'        => array( '3.5.1' => 'http://netcologne.dl.sourceforge.net/project/phpmyadmin/phpMyAdmin/3.5.1/phpMyAdmin-3.5.1-english.zip',
                                array( 'latest' =>
                                    array( 'version' => '3.5.1',
                                            'url'    => 'http://netcologne.dl.sourceforge.net/project/phpmyadmin/phpMyAdmin/3.5.1/phpMyAdmin-3.5.1-english.zip'))),

    'adminer'           => array( '3.3.4' => 'http://downloads.sourceforge.net/adminer/adminer-3.3.4.php',
                                  '3.4.0' => 'http://downloads.sourceforge.net/adminer/adminer-3.4.0.php',
                                array( 'latest' =>
                                    array( 'version' => '3.4.0',
                                            'url'    => 'http://downloads.sourceforge.net/adminer/adminer-3.4.0.php'))),

    'memcached'         => array( '1.4.5' => 'http://downloads.northscale.com/memcached-1.4.5-x86.zip',
                                array( 'latest' =>
                                    array( 'version' => '1.4.5',
                                            'url'    => 'http://downloads.northscale.com/memcached-1.4.5-x86.zip'))),

    'junction'          => array( '1.0' => 'http://download.sysinternals.com/files/Junction.zip',
                                array( 'latest' =>
                                    array( 'version' => '1.0',
                                            'url'    => 'http://download.sysinternals.com/files/Junction.zip'))),

    'pear'              => array( '1.0' => 'http://pear.php.net/go-pear.phar',
                                array( 'latest' =>
                                    array( 'version' => '1.0',
                                            'url'    => 'http://pear.php.net/go-pear.phar'))),

    'wpnxmscp'          => array( '0.3.0' => 'http://wpn-xm.org/files/wpn-xm-scp-0.3.0.zip',
                                array(  'latest' =>
                                    array( 'version' => '0.3.0',
                                            'url'    => 'http://wpn-xm.org/files/wpn-xm-scp-0.3.0.zip'))),

    'webgrind'          => array( '1.0' => 'http://webgrind.googlecode.com/files/webgrind-release-1.0.zip',
                                array( 'latest' =>
                                    array( 'version' => '1.0',
                                            'url'    => 'http://webgrind.googlecode.com/files/webgrind-release-1.0.zip'))),

    'xhprof'            => array( '1.0' => 'http://nodeload.github.com/preinheimer/xhprof/zipball/master',
                                array( 'latest' =>
                                    array( 'version' => '1.0',
                                            'url'    => 'http://nodeload.github.com/preinheimer/xhprof/zipball/master'))),

    'composer'          => array( '1.0' => 'http://getcomposer.org/composer.phar',
                                array( 'latest' =>
                                    array( 'version' => '1.0',
                                            'url'    => 'http://getcomposer.org/composer.phar'))),

    'clansuite'         => array( '0.2.1' => 'http://nodeload.github.com/jakoch/Clansuite/zipball/svnsync',
                                array( 'latest' =>
                                    array( 'version' => '0.2.1',
                                            'url'    => 'http://nodeload.github.com/jakoch/Clansuite/zipball/svnsync')))
);

?>