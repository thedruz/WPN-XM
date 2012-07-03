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
 * Wrapper for handling php.ini with ini class.
 */
class PHPINI
{
    public static function read()
    {
        $ini_file = php_ini_loaded_file();

        $ini = new ini();
        $ini->read(php_ini_loaded_file());
        $ini_array  = $ini->returnArray();

        return compact('ini_file', 'ini_array');
    }

    public static function setDirective($section, $directive, $value)
    {
        // self::doBackup(); @todo add backup functionality, before writing

        $ini_file = php_ini_loaded_file();

        $ini = new ini();
        $ini->read($ini_file);

        $ini->set($section, $directive, $value);

        $ini->write(php_ini_loaded_file());

        return true;
    }

    public static function doBackup()
    {
        // copy whole file

        // add date/time to new file name

        // keep last 3 files, remove older files

        return true;
    }
}

/**
 * INI Reader and Writer
 * The file content is in array $lines.
 */
class ini {
    protected $lines;
    protected $file;

    public function __construct($file = '')
    {
        if($file != '')
        {
            $this->file = $file;
            $this->read($file);
        }
    }

    public function read($file)
    {
        $this->lines = array();

        $section = '';

        foreach(file($file) as $line) {
            // comment or whitespace
            if(preg_match('/^\s*(;.*)?$/', $line)) {
                $this->lines[] = array('type' => 'comment', 'data' => $line);
            // section
            } elseif(preg_match('/\[(.*)\]/', $line, $match)) {
                $section = $match[1];
                $this->lines[] = array('type' => 'section', 'data' => $line, 'section' => $section);
            // entry
            } elseif(preg_match('/^\s*(.*?)\s*=\s*(.*?)\s*$/', $line, $match)) {
                $this->lines[] = array('type' => 'entry', 'data' => $line, 'section' => $section, 'key' => $match[1], 'value' => $match[2]);
            }
        }

        return $this;
    }

    public function get($section, $key)
    {
        foreach($this->lines as $line) {
            if($line['type'] != 'entry') continue;
            //if($line['section'] != $section) continue;
            if($line['key'] != $key) continue;
            return $line['value'];
        }

        //throw new Exception('Missing Section or Key');
    }

    public function set($section, $key, $value)
    {
        foreach($this->lines as &$line) {
            if($line['type'] != 'entry') continue;
            if($line['section'] != $section) continue;
            if($line['key'] != $key) continue;
            $line['value'] = $value;
            $line['data'] = $key . " = " . $value . "\r\n";
            return;
        }

        throw new Exception('Missing Section or Key');
    }

    public function write($file = '')
    {
        if($file == '') {
            $file = $this->file;
        }

        $fp = fopen($file, 'w');

        foreach($this->lines as $line) {
            fwrite($fp, $line['data']);
        }

        fclose($fp);
    }

    public function returnArray()
    {
        return $this->lines;
    }
}

/**
 * Wrapper for handling php extensions and the php.ini extension section.
 */
class phpextension {

    public function disable($name)
    {
        $this->comment($name);
    }

    public function enabled($name)
    {
        $this->uncomment($name);
    }

    private function comment($name)
    {
        $old_line = $this->getExtensionLineFromPHPINI($name);
        $new_line = ';' + $line;

        $this->replaceLineInPHPINI($old_line, $new_line);
    }

    private function uncomment($name)
    {

    }

    /**
     * Fetches the line from php.ini where the php extension is found.
     */
    private function getExtensionLineFromPHPINI($name)
    {
        return $line;
    }

    private function replaceLineInPHPINI($old_line, $new_line)
    {
        $ini_file = php_ini_loaded_file();

        $ini = new ini();
        $ini->read(php_ini_loaded_file());
        $ini_array  = $ini->returnArray();

    }

    public static function getExtensionDirFileList()
    {
        $glob = $list = array(); // PHP SYNTAX reminder $glob, $list = array();

        $glob = glob(WPNXM_DIR ."bin/php/ext/*");

        foreach ($glob as $key => $file)
        {
            // $list array has the following structure
            // key = filename without suffix
            // value = filename with suffix 
            // e.g. $list = array ( 'php_apc' => 'php_apc.dll' )
            $list[ basename($file, '.dll') ] = basename($file);
        }          

        unset($glob);

        return $list;
    }

    public static function getEnabledExtensions()
    {
        $enabled_extensions = array();

        // read php.ini
        $ini_file = php_ini_loaded_file();
        $ini = new ini();
        $ini->read($ini_file);
        $lines = $ini->returnArray();

        // check php.ini array for extension entries
        foreach($lines as $line)
        {
            if($line['type'] != 'entry') continue;
            if($line['key'] != 'extension') continue;
            // and stuff them in the array
            $enabled_extensions[] = $line['value'];
        }

        // do a key/value flip, to get rid of the numeric index.
        // this is for being able to easily check for a extension filename with isset in foreach.
        $enabled_extensions = array_flip($enabled_extensions);

        return $enabled_extensions;
    }
}
?>