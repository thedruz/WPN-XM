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

// common WPN-XM bootstrap file with constants, etc.
include __DIR__ . '/php/bootstrap.php';
include WPNXM_PHP_DIR . 'phpini.php';

/**
 * handle GET request for tab pages "config.php?tab=xy".
 * return content for inline display in the tabs-content container.
 */
$tab = filter_input(INPUT_GET, 'tab');

switch ($tab)
{
    case 'help':
        echo showTab_Help();
        break;
    case 'php':
        echo showTab_PHPConfiguration();
        break;
    case 'php-ext':
        echo showTab_PHPExtensionConfiguration();
        break;
    case 'nginx':
        echo showTab_NginxConfiguration();
        break;
    case 'nginx-vhosts':
        echo showTab_NginxVhostConfiguration();
        break;
    case 'mariadb':
        echo showTab_MariaDbConfiguration();
        break;
    default:
        # code...
        break;
}

function showTab_NginxVhostConfiguration()
{
    $return = '<h2>NGINX vHosts</h2>';

    echo $return;
}

function showTab_MariaDbConfiguration()
{
    $return = '<h2>MariaDB</h2>';

    echo $return;
}

function showTab_NginxConfiguration()
{
    $return = '<h2>NGINX</h2>';

    echo $return;
}

function showTab_PHPExtensionConfiguration()
{
    $return = '<h2>PHP Extensions</h2>';

    $available_extensions = phpextension::getExtensionDirFileList();
    $enabled_extensions = phpextension::getEnabledExtensions();
   
    // use list of available_extensions to draw checkboxes
    $html_checkboxes = '';  

    foreach($available_extensions as $name => $file)
    {       
        // in case the extension is enabled, check the checkbox
        $checked = '';
        if(isset($enabled_extensions[$file]))
        {
            $checked = 'checked="checked"';
        }

        /**
         * Deactivate the checkbox for the XDebug Extension.
         * XDebug is not loaded as normal PHP extension ([PHP]extension=).
         * It is loaded as a Zend Engine extension ([ZEND]zend_extension=).
         */
        $disabled = '';
        if($name === 'php_xdebug')
        {
            $disabled = 'disabled';
        }

        $html_checkboxes .= '<input type="checkbox" name="extensions[]" value="'.$file.'" '.$checked.' '.$disabled.'><label>'.$name.'</label><br/>';
    }   

    echo $return . $html_checkboxes;
}

function showTab_Help()
{
    $return = '<h2>Help</h2>
               <p>The configuration page is divided into tabs for each of the components.
                  <br/>
                  You will find the following functionality there:
               </p>
               <ol>
               <li>Home - The page you are currently reading.</li>
               <li>PHP - Provides an editor for modifying the PHP configuration file (php.ini).</li>
               <li>PHP Extensions - Shows the list of loaded and all available PHP Extensions for activation or deactivation.</li>
               <li>Nginx - Provides an editor for modifying the NGINX configuration file (nginx.conf).</li>
               <li>MariaDB - Provides an editor for modifying the MariaDB configuration file (my.cnf).</li>
               </ol>';

    echo $return;
}

function showTab_PHPConfiguration()
{
    $ini = PHPINI::read();
    // $ini array structure = 'ini_file', 'ini_array'
    //print_r($ini['ini_array']);

    echo '<h2>PHP INI Editor</h2>';
    echo 'The editor allows modifications of existing values in your php.ini.
          Click on a bold section to expand all directives for that section.
          You might then click on the value to edit it.
          Pressing the enter key will saves the new value to your php.ini. Take care!
          Do not forget to restart the PHP daemon in order to let the new settings become alive!';
    echo '<div class="info">';
    echo 'You are editing '. $ini['ini_file'];
    echo '<br>You are only able to modify existing values.';
    echo '</div>';

    $index = 0;
    $node_name = '';
    echo '<table id="treeTable"><thead>
        <tr>
          <th width="35%">Section - Directive</th>
          <th>Value</th>
        </tr>
      </thead>';

    foreach($ini['ini_array'] as $key => $value)
    {
        $index = $index + 1;
        $node_name = 'node-' . $index;

        if($value['type'] == 'section')
        {
            echo '<tr id="'.$node_name.'"><td>'.$value['section'].'</td></tr>'; $section_node_name = $node_name;
        }

        if($value['type'] == 'comment') { }

        if($value['type'] == 'entry')
        {
            echo '<tr id="'.$node_name.'" class="child-of-'.$section_node_name.'"><td>'.$value['key'].'</td><td>';
            echo '<div class="editable">'; // span tag for jquery.jEditable
            echo $value['value'];
            echo '</div>';
            echo '</td></tr>';
        }
    }

    echo '</table>';
}

/**
 * handle post requests from tab pages "config.php?tab=xy".
 */
$action = filter_input(INPUT_GET, 'action');

switch ($action)
{
    case 'save-phpini-setting':
        echo save_phpini_setting();
        break;
    case 'disableMemcached':
        disable_memcached();
        break;
    case 'enableMemcached':
        enable_memcached();
        break;
    case 'disableXdebug':
        disable_xdebug();
        break;
    case 'enableXdebug':
        enable_xdebug();
        break;
}

function save_phpini_setting()
{
    //var_dump($_POST);

    $section = ''; // @todo section? needed to save the directive? string (directive=>value) is unique!?
    $directive = filter_input(INPUT_POST, 'directive');
    $value = filter_input(INPUT_POST, 'value');

    PHPINI::setDirective($section, $directive, $value);

    echo 'Entry saved.';
}

function disableMemcached()
{
    // kill running memcached daemon
    Wpnxm_Serverstack::stopDaemon('memcached');

    // remove memcached php extension
    phpextension::disable('memcached');

    // restart php daemon
    Wpnxm_Serverstack::startDaemon('memcached');
}


function enableMemcached()
{
    // add memcached php extension
    phpextension::enable('memcached');

    // restart php daemon
    Wpnxm_Serverstack::restartDaemon('php');

    // start memcached daemon
    Wpnxm_Serverstack::startDaemon('memcached');
}

function disableXdebug()
{
    // remove xdebug php extension
    phpextension::disable('xdebug');

    // restart php daemon
    Wpnxm_Serverstack::restartDaemon('php');
}


function enableXdebug()
{
    // add xdebug php extension
    phpextension::enable('xdebug');

    // restart php daemon
    Wpnxm_Serverstack::restartDaemon('php');
}

?>