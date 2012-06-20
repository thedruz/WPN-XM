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
    }

    public function get($section, $key)
    {
        foreach($this->lines as $line) {
            if($line['type'] != 'entry') continue;
            //if($line['section'] != $section) continue;
            if($line['key'] != $key) continue;
            return $line['value'];
        }

        throw new Exception('Missing Section or Key');
    }

    public function set($section, $key, $value)
    {
        foreach($this->lines as &$line) {
            if($line['type'] != 'entry') continue;
            //if($line['section'] != $section) continue;
            if($line['key'] != $key) continue;
            $line['value'] = $value;
            $line['data'] = $key . " = " . $value . "\r\n";
            return;
        }
        var_dump($lines);

        throw new Exception('Missing Section or Key');
    }

    public function write($file)
    {
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
?>