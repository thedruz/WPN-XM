<?php
/**
 * Error Reporting
 */
error_reporting(E_ALL);

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