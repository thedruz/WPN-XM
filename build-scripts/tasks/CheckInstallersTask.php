<?php

/**
 * WPИ-XM Server Stack - Updater
 * Copyright © 2010 - 2016 Jens A. Koch <jakoch@web.de>
 * http://wpn-xm.org/
 *
 * This source file is subject to the terms of the MIT license.
 * For full copyright and license information, view the bundled LICENSE file.
 */

class CheckInstallersTask extends Task
{
    private $buildFolder;

    public function setBuildFolder($buildFolder)
    {
        $this->buildFolder = realpath($buildFolder);
    }

    public function main()
    {
        $this->checkInstallers();
    }

    public function checkInstallers()
    {
        $this->log('Checking Installers..');

        $installer_scripts = array_map('basename', glob($this->buildFolder . '/*.iss', GLOB_BRACE));
        $installer_executables = array_map('basename', glob($this->buildFolder . '/*.exe', GLOB_BRACE));

        $missing_installer_executables = array_diff($installer_scripts, $installer_executables);

        if(count($missing_installer_executables) > 0) {
            echo "\033[01;31m";
            echo "The following installer executables were not compiled:\n";
            foreach($missing_installer_executables as $exe) {
               echo "  - \"$exe\".exe \n";
            }
            echo "Please check the InnoSetup script files for errors!\n";
            echo "\033[0m";
        } else {
            $total_installers_build = count($installer_executables);
            if($total_installers_build > 0) {
                $this->log('Successfully build ' . $total_installers_build . ' installers!');
            } else {
                $this->log('0 installers build! Grrr. Check the log and the compile task.');
            }
        }
    }
}