<?php
/**
 * Opens the file (in a background process)
 * @param $file The file to open.
 */
function openFile($file)
{
    if (false === is_file($file)) {
        echo 'Error - File "' . $file . '" not found.';

        return;
    }

    // @todo ask user for the tool to use, for now open with notepad
    $tool = 'notepad';

    /**
     * Notice, that we are not using exec() here.
     * Using exec() would leave the page loading, till the executed app window is closed.
     * Running via WScript.Shell will launch the process in the background.
     */
    $WshShell = new COM("WScript.Shell");
    $oExec = $WshShell->run('cmd /c ' . $tool . ' ' . $file, 0, false);
}
