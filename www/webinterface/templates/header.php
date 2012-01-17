<?php
/**
 * Include the common startup with paths / constants, etc.
 */
include dirname(__DIR__) . '/php/bootstrap.php';
?>
<!DOCTYPE html>
<html lang="en" dir="ltr" xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8" />
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <title>WPИ-XM Serverstack for Windows</title>
    <meta http-equiv="X-UA-Compatible" content="chrome=1">
    <meta name="description" content="WPИ-XM Serverstack for Windows - Webinterface.">
    <link rel="shortcut icon" href="http://wpn-xm.org/favicon.ico" />
    <link rel="stylesheet" href="css/style.css" type="text/css" media="screen, projection" />
</head>
<body>

<div class="page-wrapper">

    <div class="center">

        <h1 class="headline">
            WPИ-XM<br/>
            Serverstack for Windows<br/>
            <small>Version 0.2</small>
        </h1>

        <div class="content-centered">

        <?php
            include WPNXM_TEMPLATE . 'htmlelements.php';

            HtmlElements::renderMenu(); 
            HtmlElements::renderWelcome();
        ?>
