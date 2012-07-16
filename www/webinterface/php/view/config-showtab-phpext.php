<h2>PHP Extensions <small>(<?=count($enabled_extensions)?> of <?=count($available_extensions)?> loaded)</small></h2>

<form action="index.php?page=config&action=update_phpextensions" method="post">
<div style="float: left; width: 125px;">
<?php 
// use list of available_extensions to draw checkboxes
$html_checkboxes = '';  
$i = 0;

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
    if(strpos($name, 'xdebug') !== false)
    {
        $disabled = 'disabled';
    }

    $html_checkboxes .= '<input type="checkbox" name="extensions[]" value="'.$file.'" '.$checked.' '.$disabled.'><label style="vertical-align: 30%;">'.substr($name, 4).'</label><br/>';
    
    $i++; if($i == 12) { $html_checkboxes .= '</div><div style="float: left; width: 125px;">'; $i = 0; }
}   

echo $html_checkboxes;
?>
</div>
<div style="clear:both; float:right;">
    <input type="submit" class="aButton" value=" Submit ">
    <input type="reset" class="aButton" value=" Reset ">
<div>
</form>