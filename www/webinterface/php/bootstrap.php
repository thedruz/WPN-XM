<?php
/**
 * Definition of Path Constants
 *
 * WPNXM_DIR        -> wpn-xm/ Root Folder (bin, configs, ....)
 * WPNXM_WWW_DIR    -> wpn-xm/www
 * WPNXM_PHP_DIR    -> wpn-xm/www/webinterface
 * WPNXM_WWW_ROOT   -> www path (http:// to the www folder)
 */
if(!defined('WPNXM_DIR'))
{
    // Path Constants -> "c:/.."
    define('WPNXM_DIR', dirname(dirname(dirname(__DIR__))) . DIRECTORY_SEPARATOR);
    define('WPNXM_WWW_DIR', WPNXM_DIR . 'www\\');
    define('WPNXM_PHP_DIR', WPNXM_WWW_DIR . 'webinterface\php\\');
    define('WPNXM_TEMPLATE', WPNXM_WWW_DIR . 'webinterface\templates\\');

    // Web Path Constants -> "http://.."
    define('SERVER_URL', 'http://' . $_SERVER['SERVER_NAME'], false);
    define('WPNXM_ROOT', SERVER_URL . dirname(dirname(dirname($_SERVER['PHP_SELF']))) . '/', false);
    define('WPNXM_WWW_ROOT', WPNXM_ROOT . 'www/', false);
    define('WPNXM_WEBINTERFACE_ROOT', WPNXM_ROOT . 'www/webinterface/', false);
}
?>