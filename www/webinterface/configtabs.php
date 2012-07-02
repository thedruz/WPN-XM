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
        echo 'Help';
        break;
    case 'php':
        echo showPage_PHPConfiguration();
        break;

    default:
        # code...
        break;
}

function showPage_PHPConfiguration()
{
    $ini = PHPINI::read();
    // $ini array structure = 'ini_file', 'ini_array'
    //print_r($ini['ini_array']);

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
    /* @todo https://github.com/jakoch/WPN-XM/issues/35
    case 'disableMemcached':
        echo disable_memcached();
    case 'enableMemcached':
        echo enable_memcached();
    case 'disableXdebug':
        echo disable_xdebug();
    case 'enableXdebug':
        echo enable_xdebug();*/
}

function save_phpini_setting()
{
    //var_dump($_POST);

    $section = ''; // @todo section? this is not needed to save the directive, because string (directive=>value) is unique
    $directive = filter_input(INPUT_POST, 'directive');
    $value = filter_input(INPUT_POST, 'value');

    PHPINI::setDirective($section, $directive, $value);

    echo 'Entry saved.';
}

?>