<?php

/**
 * Redirection script for download sources of WPN-XM.
 * @author Tobias Fichtner <github@tobiasfichtner.com>
 */

// load software components registry
include _DIR_ . 'wpnxm-software-registry.php';

// ensure registry array is available
if(!is_array($registry))
{
    header("HTTP/1.0 404 Not Found");
}

// $_GET['s'] = software component
$s = filter_input(INPUT_GET, 's', FILTER_SANITIZE_STRING);
// $_GET['v'] = version
$v = filter_input(INPUT_GET, 'v', FILTER_SANITIZE_STRING);

if(isset($s) && array_key_exists($s, $registry)) {
    if(isset($v) && array_key_exists($v, $registry[$s])) {
        header("Location: " . $registry[$s][$v]['url']);
    } else {
        header("Location: " . $registry[$s]['latest']['url']);
    }
} else {
    header("HTTP/1.0 404 Not Found");
}

?>