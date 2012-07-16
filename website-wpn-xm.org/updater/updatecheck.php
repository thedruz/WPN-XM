<?php
   /**
    * WPИ-XM Server Stack
    * Jens-André Koch © 2010 - onwards
    * http://wpn-xm.org/
    *
    * Update Check - Response
    * -----------------------
    * The script provides a json response to a update-check request
    * for individual components of the WPN-XM Server Stack.
    *
    * Example request: updatecheck.php?s=nginx&v=1.2.1
    */

// load software components registry
$registry = include __DIR__ . DIRECTORY_SEPARATOR . 'wpnxm-software-registry.php';

// ensure registry array is available
if (!is_array($registry)) {
    header("HTTP/1.0 504 Service Unavailable");
}

// $_GET['s'] = software component
$s = filter_input(INPUT_GET, 's', FILTER_SANITIZE_STRING);
// $_GET['v'] = your current version
$v = filter_input(INPUT_GET, 'v', FILTER_SANITIZE_STRING);

// does the requested software exist in our registry?
if ( isset($s) && array_key_exists($s, $registry) ) {
    // yes, and does the requested version of it exist?
    if ( isset($v) && version_compare($v, $registry[$s]['latest']['version'], '<') ) {

       // prepare json data
       $data = array (
            'software'       => $s,
            'your_version'   => $v,
            'latest_version' => $registry[$s]['latest']['version'],
            'href'           => $registry[$s]['latest']['url'],
            'message'        => 'You are running an old version of ' . $s . ' and should update immediately.'
        );

    } else {
        // prepare json data
        $data = array('message' => 'You are running the latest version.');

    }
    // send response as json message
    echo json_encode($data);
} else {
    echo 'Request Error. Specify parameters "s" and "v".';
}
