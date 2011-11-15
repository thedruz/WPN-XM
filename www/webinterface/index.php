<?php
include __DIR__ . DIRECTORY_SEPARATOR . 'serverpack.core.php';
?>
<!DOCTYPE html>
<html lang="en" dir="ltr" xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8" />
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <title>WPИ-XM Serverpack for Windows</title>
    <meta http-equiv="X-UA-Compatible" content="chrome=1">
    <meta name="description" content="WPИ-XM Serverpack for Windows - Webinterface.">
    <link rel="shortcut icon" href="http://wpn-xm.org/favicon.ico" />
    <style type="text/css">
    /*<![CDATA[*/
        body
        {
            margin: 0;
            padding: 0;
            font-family:  verdana, tahoma, arial, geneva, helvetica, sans-serif;
            background: #e7e7e7;
            font-size: 65%; /* Resets 1em to 10px */
            font-family: 'Lucida Grande', Verdana, Arial, Sans-Serif;
            color: #333;
            text-align: center;
        }

        div.page-centered {
            position: relative;
            margin: 0 auto;
            max-width: 1102px;
            min-width: 852px; /*930px;*/
            text-align: left;
            /*border: 1px solid black;*/
        }

        div.content-centered {
            /*border: 1px dotted red;*/
            margin-left: auto;
            margin-right: auto;
            display: inline-block;
        }

        img
        {
            border: 0px;
        }

        .red {
            color: red;            
        }

        .resourceheader
        {
            margin-left:    10px;
            text-align:     left;
            font-size:      12px;
        }


        .resourceheader2
        {
            text-align:     left;
            font-size:      12px;
        }

        .td-with-image
        {
            border-right:   1px dotted #B4B4B4;
            padding-right:  10px;
            width:          55px;
        }

        #footer
        {
            font-family: verdana, tahoma;
            font-size: 9px;
            text-align: center;
        }

        .cs-message
        {
            background: none repeat scroll 0 0 #CDCDCD;
            border-radius: 8px 8px 8px 8px;
            padding: 5px;
            margin-top: 10px;
        }

        .cs-message-content
        {
            background: none repeat scroll 0 0 #F4F4F4;
            border: 1px solid #A7A7A7;
            border-radius: 6px 6px 6px 6px;
            padding: 10px;
            margin-top: 3px;
            margin-bottom: 2px;
            width: 340px;
            height: 100px;
            text-align: left;
            min-height: 152px;
        }

        .cs-message h3
        {
            margin: 5px;
            font-size: 13px;
        }

        .res-header-icon
        {
            vertical-align: text-top;
        }

        h1, h2 {
            text-shadow: 0 1px #FFFFFF;
        }

        .horizontal-rule-light, h2, hr {
            border-bottom: 1px solid #BBBBBB;
            box-shadow: 0 1px 0 white;
            padding-bottom: 10px;
        }

        .aButton {
        	background-color:transparent;
        	-moz-border-radius:4px;
        	-webkit-border-radius:4px;
        	border-radius:4px;
        	border:1px solid #a7a7a7;
        	display:inline-block;
        	color:#777777;
        	font-family:Arial;
        	font-size:12px;
        	font-weight:bold;
        	padding:3px 14px;
        	text-decoration:none;
        	margin-left: 3px;
        	margin-top: 3px;
        	cursor: pointer;
        }
        .aButton:active {
        	position:relative;
        	top:1px;
        }
        .aButton:hover {
            border-color: #777;
            box-shadow: 1px 1px #999999;
            color: #333;
            outline: 0 none;
        }
        /* @todo: hovering the inner three rows with data, not the header, not the buttons;
        table.cs-message-content tr:hover {
            background-color: #ddd;
        }*/
        a:hover {
            color:#114477;
            text-decoration:underline;
        }
        a:hover {
            color:red;
            text-decoration:underline;
        }
        a, a:link, a:visited {
            text-decoration:none;
        }
        a, h2 a:hover, h3 a:hover {
            color:#0066CC;
            text-decoration:none;
        }
        a, a:link, a:visited {
            text-decoration:none;
        }
        hr.footer-line {margin-top: 50px; width: 22%;}
        br.clear {clear:both;}
        div.server-environment-right-box {float:left; margin-left: 2em;}
        td.width-42 {width:42%;}
        td.width-25 {width:25%;}
        .left { text-align: left; }
        .right { text-align: right; }
        .center { text-align: center; }
        .bold {font-weight: bold}
        div.server-software-left-box {float:left; margin-right: 2em;}
        h1.headline {margin-top: 40px; margin-bottom: 30px; font-size: 18px;}
        /*]]>*/
    </style>
</head>
<body>

    <!-- container-for-centering -->
    <div class="page-centered">

        <!-- Main -->
        <div class="center">

            <!-- Headline -->
            <h1 class="headline">
                WPИ-XM<br/>
                Serverpack for Windows<br/>
                <small>Version 0.1b</small>
            </h1>

            <div class="content-centered">

            <!-- Server Software (left box) -->
            <div class="server-software-left-box">

                <h2>Server Software</h2>

                <div class="cs-message">

                    <h3>Main Components</h3>

                        <table class="cs-message-content">
                        <tr>
                            <td class="td-with-image">
                                Webserver
                            </td>
                            <td>
                                <div class="resourceheader">
                                    <img class="res-header-icon" src="http://cdn.clansuite.com/images/report.png" alt="Report Icon" />
                                        <a href="http://nginx.org/">
                                            <b>NGINX <?php echo Wpnxm_Serverpack::getNGINXVersion(); ?></b>
                                        </a>
                                        <br /><br />
                                        <small>NGINX [engine x] is a high performance http and reverse proxy server, as well as a mail proxy server written by Igor Sysoev.</small>
                                        <p>
                                        License: <a href="http://nginx.org/LICENSE">2-clause BSD-like license</a>
                                        </p>
                                </div>
                            </td>
                        </tr>
                        </table>

                        <table class="cs-message-content">
                        <tr>
                            <td class="td-with-image">
                                Scripting Language
                            </td>
                            <td>
                                <div class="resourceheader">
                                    <img class="res-header-icon" src="http://cdn.clansuite.com/images/report.png" alt="Report Icon" />
                                        <a href="http://php.net/">
                                            <b>PHP <?php echo Wpnxm_Serverpack::getPHPVersion(); ?></b>
                                        </a>
                                        <br /><br />
                                        <small>PHP is a widely-used general-purpose scripting language that is especially suited for Web development and can be embedded into HTML.</small>
                                        <p>
                                        License: <a href="http://php.net/license/index.php">PHP License</a>
                                        </p>
                                 </div>
                            </td>
                        </tr>
                        </table>

                        <table class="cs-message-content">
                        <tr>
                            <td class="td-with-image">
                               Database
                            </td>
                            <td>
                                <div class="resourceheader">
                                    <img class="res-header-icon" src="http://cdn.clansuite.com/images/report.png" alt="Report Icon" />
                                        <a href="http://mariadb.org/">
                                            <b>MariaDB <?php echo Wpnxm_Serverpack::getMariaDBVersion(); ?></b>
                                        </a>
                                        <br /><br />
                                        <small>MariaDB is a fork of the world's most popular open source database MySQL by the original author. MariaDb is a binary drop-in replacement for MySQL.</small>
                                        <p>
                                        License: <a href="http://kb.askmonty.org/en/mariadb-license/">GNU/GPL v2</a>
                                        </p>
                                 </div>
                            </td>
                        </tr>
                        </table>

                        <table class="cs-message-content">
                        <tr>
                            <td class="td-with-image">
                               Memcached
                            </td>
                            <td>
                                <div class="resourceheader">
                                    <img class="res-header-icon" src="http://cdn.clansuite.com/images/report.png" alt="Report Icon" />
                                        <a href="http://memcached.org/">
                                            <b>Memcached <?php echo Wpnxm_Serverpack::getMemcachedVersion(); ?></b>
                                        </a>
                                        <br /><br />
                                        <small>memcached is a high-performance, distributed memory object caching system. originally intended for speeding up applications by alleviating database load.</small>
                                        <p>
                                        License: <a href="https://github.com/memcached/memcached/blob/master/LICENSE/">New BSD License</a>
                                        </p>
                                 </div>
                            </td>
                        </tr>
                        </table>

                         <table class="cs-message-content">
                        <tr>
                            <td class="td-with-image">
                               Xdebug
                            </td>
                            <td>
                                <div class="resourceheader">
                                    <img class="res-header-icon" src="http://cdn.clansuite.com/images/report.png" alt="Report Icon" />
                                        <a href="http://xdebug.org/">
                                            <b>Xdebug <?php echo Wpnxm_Serverpack::getXdebugVersion(); ?></b>
                                        </a>
                                        <br /><br />
                                        <small>The Xdebug extension for PHP helps you debugging your scripts by providing a lot of valuable debug information.</small>
                                        <p>
                                        License: <a href="http://xdebug.org/license.php">Xdebug License</a>
                                        </p>
                                 </div>
                            </td>
                        </tr>
                        </table>


                 </div><!-- END: cs-message -->
            </div><!-- END: Server Software (left box) -->

            <!-- Server Environment (right box) -->
            <div class="server-environment-right-box">

                <h2>Server Environment</h2>

                <div class="cs-message">

                    <h3>Overview</h3>

                   <table class="cs-message-content">
                   <tr>
                        <td colspan="2">
                            <div class="resourceheader2 bold">
                                Nginx
                            </div>
                        </td>
                   </tr>
                   <tr>
                     <td class="width-25">Host : Port</td>
                     <td class="right"><?php echo $_SERVER['SERVER_NAME'] ?>:<?php echo $_SERVER['SERVER_PORT'] ?> </td>
                   </tr>
                   <tr>
                     <td>Directory</td>
                     <td class="right"><?php echo Wpnxm_Serverpack::getBaseDir() . '\bin\nginx'; ?></td>
                   </tr>
                   <tr>
                     <td>Config</td>
                     <td class="right"><?php echo Wpnxm_Serverpack::getBaseDir() . '\bin\nginx\conf\nginx.conf'; ?></td>
                   </tr>
                   <tr>
                     <td colspan="2" class="right">
                        <span class="aButton">Configure</span>
                        <span class="aButton">Access Log</span>
                        <span class="aButton">Error Log</span>
                     </td>
                   </tr>
                   </table>

                   <table class="cs-message-content">
                   <tr>
                        <td colspan="2">
                            <div class="resourceheader2 bold">
                                PHP
                            </div>
                        </td>
                   </tr>
                   <tr>
                     <td class="width-42 left">Host : Port</td>
                     <td class="right"><?php echo $_SERVER['SERVER_NAME'] ?>:<?php echo $_SERVER['SERVER_PORT'] ?></td>
                   </tr>
                   <tr>
                     <td>Directory</td>
                     <td class="right"><?php echo Wpnxm_Serverpack::getBaseDir() . '\bin\php'; ?></td>
                   </tr>
                   <tr>
                     <td>Config</td>
                     <td class="right"><?php echo get_cfg_var('cfg_file_path'); ?></td>
                   </tr>
                   <tr>
                     <td colspan="2" class="right">
                        <span class="aButton">Configure</span>
                        <span class="aButton">Show Log</span>
                        <a class="aButton" href="phpinfo.php">Show phpinfo()</a>
                     </td>
                   </tr>
                   </table>

                   <table class="cs-message-content">
                   <tr>
                        <td colspan="2">
                            <div class="resourceheader2 bold">
                                MariaDB
                            </div>
                        </td>
                   </tr>
                   <tr>
                     <td class="width-42 left">Host : Port</td>
                     <td class="right">localhost:port</td>
                   </tr>
                   <tr>
                     <td>Username | Password</td>
                     <td class="right"><span class="red">root</span> | <span class="red">toop</span></td>
                   </tr>
                   <tr>
                     <td>Directory</td>
                     <td class="right"><?php echo Wpnxm_Serverpack::getBaseDir() . '\bin\mariadb';?></td>
                   </tr>
                   <tr>
                     <td>Config</td>
                     <td class="right"><?php echo Wpnxm_Serverpack::getBaseDir() .  '\mariadb\my.ini';?></td>
                   </tr>
                   <tr>
                     <td colspan="2" class="right"><span class="aButton">Configure</span><span class="aButton">Show Log</span><span class="aButton">Reset Password</span>
                     </td>
                   </tr>
                   </table>

                   <table class="cs-message-content">
                   <tr>
                        <td colspan="2">
                            <div class="resourceheader2 bold">
                                Memcached
                            </div>
                        </td>
                   </tr>
                   <tr>
                     <td class="width-42 left">Host : Port</td>
                     <td class="right">localhost:port</td>
                   </tr>
                   <tr>
                     <td>PHP Extension</td>
                     <td class="right"><?php echo Wpnxm_Serverpack::assertExtensionInstalled('memcached');?></td>
                   </tr>
                   <tr>
                     <td colspan="2" class="right"><span class="aButton">Switch on/off</span>
                     </td>
                   </tr>
                   </table>

                   <table class="cs-message-content">
                   <tr>
                        <td colspan="2">
                            <div class="resourceheader2 bold">
                                XDebug
                            </div>
                        </td>
                   </tr>
                   <tr>
                     <td class="width-42 left">Host : Port</td>
                     <td class="right">localhost:port</td>
                   </tr>
                   <tr>
                     <td>Installed & Configured</td>
                     <td class="right"><?php echo Wpnxm_Serverpack::assertExtensionInstalled('xdebug');?></td>
                   </tr>
                   <tr>
                     <td>Extension Type</td>
                     <td class="right"><?php echo Wpnxm_Serverpack::getXdebugExtensionType();?></td>
                   </tr>
                   <tr>
                     <td colspan="2" class="right"><span class="aButton">Switch on/off</span>
                     </td>
                   </tr>
                   </table>

                </div><!-- END: cs-message -->
           </div><!-- END: Server Environment (rught box) -->

    </div><!-- End: Content -->

</div><!-- End: Main -->

<br class="clear" />

<div id="footer">
    <hr class="footer-line" />
    <p>&copy; 2010-<?php echo date("Y"); ?> by Jens-Andr&#x00E9; Koch Softwaresystemtechnik.
        <br />
    </p>
</div>

</div>
</body>
</html>