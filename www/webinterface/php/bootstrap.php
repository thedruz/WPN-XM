<?php
   /**
    * WPИ-XM Server Stack - Webinterface
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
    *
    * @license    GNU/GPL v2 or (at your option) any later version..
    * @author     Jens-André Koch <jakoch@web.de>
    * @copyright  Jens-André Koch (2010 - 2012)
    * @link       http://wpn-xm.org/
    */

/**
 * Error Reporting
 */
error_reporting(E_ALL);

ini_set('memory_limit', -1);

/**
 * Definition of Constants
 *
 * WPNXM_VERSION    -> major.minor.buildnumber
 *
 * Path Constants
 * --------------
 * WPNXM_DIR        -> wpn-xm/ Root Folder (bin, configs, ....)
 * WPNXM_WWW_DIR    -> wpn-xm/www
 * WPNXM_PHP_DIR    -> wpn-xm/www/webinterface
 * WPNXM_WWW_ROOT   -> www path (http:// to the www folder)
 */
if(!defined('WPNXM_DIR'))
{
    // WPNXM Version String (replaced automatically during build)
    define('WPNXM_VERSION', '@APPVERSION@');

    define('DS', DIRECTORY_SEPARATOR);

    // Path Constants -> "c:/.."
    define('WPNXM_DIR', dirname(dirname(dirname(__DIR__))) . DS);
    define('WPNXM_WWW_DIR', WPNXM_DIR . 'www' . DS);
    define('WPNXM_PHP_DIR', WPNXM_WWW_DIR . 'webinterface\php' . DS);
    define('WPNXM_TEMPLATE', WPNXM_WWW_DIR . 'webinterface\templates'. DS);

    // Web Path Constants -> "http://.."
    define('SERVER_URL', 'http://' . $_SERVER['SERVER_NAME'], false);
    define('WPNXM_ROOT', SERVER_URL . ltrim(dirname(dirname(dirname($_SERVER['PHP_SELF']))), '\\') . '/', false);
    define('WPNXM_WWW_ROOT', WPNXM_ROOT . 'www/', false);
    define('WPNXM_WEBINTERFACE_ROOT', WPNXM_ROOT . 'webinterface/', false);

    // NGINX Configuration and vhosts
    define('NGINX_CONF_DIR',   WPNXM_DIR . '/bin/nginx/conf/');
    define('NGINX_VHOSTS_DIR', WPNXM_DIR . '/bin/nginx/conf/vhosts/');
}

if(!function_exists('debug'))
{
    function debug()
    {
        # list path constants
        $array = get_defined_constants(true);
        var_dump($array['user']);
    }
}
?>