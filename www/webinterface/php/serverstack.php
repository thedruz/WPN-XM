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
    |    WPИ-XM Serverstack is free software; you can redistribute it and/or modify     |
    |    it under the terms of the GNU General Public License as published by          |
    |    the Free Software Foundation; either version 2 of the License, or             |
    |    (at your option) any later version.                                           |
    |                                                                                  |
    |    WPИ-XM Serverstack is distributed in the hope that it will be useful,          |
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
    * @license    GNU/GPL v2 or (at your option) any later version, see "license.txt".
    * @author     Jens-André Koch <jakoch@web.de>
    * @copyright  Jens-André Koch (2010 - 2011)
    * @link       http://wpn-xm.org/
    * @version    SVN: $Id: serverstack.core.php 5795 2011-11-09 12:39:38Z vain $
    */

class Wpnxm_Serverstack
{
    /**
     * Prints the Exclaimation Mark Icon with title text.
     *
     * @param string $image_title_text
     * @return string HTML
     */
    public static function printExclamationMark($image_title_text = '')
    {
        return '<img style="float:right;" src="' . WPNXM_WEBINTERFACE_ROOT . 'img/exclamation-red-frame.png" alt=""
                 title="'.$image_title_text.'">';
    }

    public static function get_MySQL_datadir()
    {
        $myini_array = file("../mysql/my.ini");
        $key_datadir = key(preg_grep("/^datadir/", $myini_array));
        $mysql_datadir_array = explode("\"", $myini_array[$key_datadir]);
        $mysql_datadir = str_replace("/", "\\", $mysql_datadir_array[1]);

        return $mysql_datadir;
    }

    /**
     * Returns MySQL Database Connection
     *
     * @return boolean
     */
    public static function openMySQLConnection()
    {
        return mysql_connect('localhost', 'root', 'toop');
    }

    /**
     * Returns MariaDB Version.
     *
     * @return string MariaDB Version
     */
    public static function getMariaDBVersion()
    {
        $connection = self::openMySQLConnection();
        if(false === $connection)
        {
           # Daemon running? Login credentials correct?
           #echo ('No Connection: ' . mysql_error());
           return self::printExclamationMark('MySQL Connection not possible. Access denied.');
        }
        else
        {
            if(false === function_exists('mysql_get_server_info'))
            {
                return self::printExclamationMark('PHP Extension: mysql, mysqli, mysqlnd missing.');
            }

            # mysql_get_server_info() returns e.g. "5.3.0-maria"
            $arr = explode('-', mysql_get_server_info($connection));
            return $arr[0];

            mysql_close($connection);
        }
    }

    /**
     * Returns PHP Version.
     *
     * @return string PHP Version
     */
    public static function getPHPVersion()
    {
        return PHP_VERSION;
    }

    /**
     * Returns Nginx Version.
     *
     * @return string Nginx Version
     */
    public static function getNGINXVersion()
    {
        if(strpos($_SERVER["SERVER_SOFTWARE"], 'Apache') !== false)
        {
            return self::printExclamationMark('You are using Apache!? You Traitor!');
        }

        return substr($_SERVER["SERVER_SOFTWARE"], 6);
    }

    /**
     * Returns Xdebug Version.
     *
     * @return string Xdebug Version
     */
    public static function getXdebugVersion()
    {
        $xdebug_version = false;
        $matches = '';
        $phpinfo = self::fetchPHPInfo(true);

        // Check phpinfo content for Xdebug as Zend Extension
        if(preg_match('/with\sXdebug\sv([0-9.rcdevalphabeta-]+),/', $phpinfo, $matches))
        {
            $xdebug_version = $matches[1];
        }

        return $xdebug_version;
    }

    /**
     * Tests, if the extension file is found.
     *
     * @param string $extension Extension name, e.g. xdebug, memcached.
     * @return bool True if $extension file is found, false otherwise.
     */
    public static function assertExtensionFileFound($extension)
    {
        $files = array(
            'apc'       => 'bin\php\ext\php_apc.dll',
            'xdebug'    => 'bin\php\ext\php_xdebug.dll',
            'xhprof'    => 'bin\php\ext\php_xhprof.dll',
            'memcached' => 'bin\php\ext\php_memcache.dll',
            'nginx'     => 'bin\nginx\nginx.conf',
            'mariadb'   => 'bin\mariadb\my.ini',
            'php'       => 'bin\php\php.ini',
        );

        $file = WPNXM_DIR . $files[$extension];

        if(is_file($file) === true)
        {
            return true;
        }
        else
        {
            return false;
        }
    }

    /**
     * Tests, if an extension is correctly configured and loaded.
     *
     * @param string $extension Extension to check.
     * @return bool True if loaded, false otherwise.
     */
    public static function assertExtensionConfigured($extension)
    {
        $loaded = false;
        $matches = '';

        switch($extension)
        {
            case "xdebug":
                $phpinfo = self::fetchPHPInfo();

                // Check phpinfo content for Xdebug as Zend Extension
                if(preg_match('/with\sXdebug\sv([0-9.rcdevalphabeta-]+),/', $phpinfo, $matches))
                {
                    $loaded = true;
                }

                // Check phpinfo content for Xdebug as normal PHP extension
                if(preg_match('/xdebug support/', $phpinfo, $matches))
                {
                    $loaded = true;
                }

                unset($phpinfo);

                break;
            case "memcached":
                if(is_file(WPNXM_DIR . 'bin\php\ext\php_memcache.dll') === true)
                {
                    $loaded = true;
                }
                break;
        }

        return $loaded;
    }

    public static function getXdebugExtensionType()
    {
        $phpinfo = self::fetchPHPInfo(true);
        $matches = '';

        // Check phpinfo content for Xdebug as Zend Extension
        if(preg_match('/with\sXdebug\sv([0-9.rcdevalphabeta-]+),/', $phpinfo, $matches))
        {
            return 'Zend Extension';
        }

        // Check phpinfo content for Xdebug as normal PHP extension
        if(preg_match('/xdebug support/', $phpinfo, $matches))
        {
            return 'PHP Extension';
        }

        return ':(';
    }

    public static function getPHPExtensionDirectory()
    {
        $phpinfo = self::fetchPHPInfo(true);
        $matches = '';

        if(preg_match('/extension_dir([ =>\t]*)([^ =>\t]+)/', $phpinfo, $matches))
        {
            $extensionDir = $m[2];
        }

        return $extensionDir;
    }

    /**
     * Tests, if an extension is installed,
     * by ensuring that the extension file exists and is correctly configured.
     *
     * @param string $extension Extension to check.
     * @return bool True if installed, false otherwise.
     */
    public static function assertExtensionInstalled($extension)
    {
        $installed = false;

        if(self::assertExtensionFileFound($extension) === true and self::assertExtensionConfigured($extension) === true)
        {
            $installed = true;
        }

        return $installed;
    }

    /**
     * Returns memcached Version.
     *
     * @return string memcached Version
     */
    public static function getMemcachedVersion()
    {
        if(extension_loaded('memcache') === false)
        {
            return self::printExclamationMark('PHP Extension: memcached missing.');
        }

        $matches = new Memcache;
        $matches->addServer('localhost', 11211);
        return $matches->getVersion();
    }

    /**
     * Returns the (full) content of phpinfo().
     *
     * @return string Content of phpinfo()
     */
    public static function getPHPInfoContent()
    {
        # fetch the output of phpinfo into a buffer and assign it to a variable
        ob_start();
        phpinfo();
        $buffered_phpinfo = ob_get_contents();
        ob_end_clean();

        return $buffered_phpinfo;
    }

    /**
     * Returns only the body content of phpinfo().
     *
     * When settings $strip_tags true, the phpinfo body content is
     * further reduced for better and faster processing with preg_match().
     *
     * @param boolean Strips tags from content when true.
     * @return string phpinfo
     */
    public static function fetchPHPInfo($strip_tags = false)
    {
        $matches = '';
        $buffered_phpinfo = self::getPHPInfoContent();

        # only the body content
        preg_match_all("=<body[^>]*>(.*)</body>=siU", $buffered_phpinfo, $matches);
        $phpinfo = $matches[1][0];

        # enhance the readability of semicolon separated items
        $phpinfo = str_replace(";", "; ", $phpinfo);

        if($strip_tags === true)
        {
            $phpinfo = strip_tags($phpinfo);
            $phpinfo = str_replace('&nbsp;', ' ', $phpinfo);
            $phpinfo = str_replace('  ', ' ', $phpinfo);
        }

        return $phpinfo;
    }

    public static function determinePort($daemon)
    {

    }

    /**
     * Attempts to establish a connection to the specified port (on localhost)
     */
    public static function portCheck($daemon)
    {

    }

    /**
     * Checks, if webserver is running.
     *
     * @return  bool
     */
    public static function isWebserverRunning()
    {
        ini_set('default_socket_timeout', '3');

        if(false !== ($handle = @fopen('http://127.0.0.1/', 'r')))
        {
            fclose($handle);
            unset($handle);

            return true;
        }

        return false;
    }

}
?>