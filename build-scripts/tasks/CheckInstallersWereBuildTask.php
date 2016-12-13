<?php

/**
 * WPИ-XM Server Stack
 * Copyright © 2010 - 2016 Jens A. Koch <jakoch@web.de>
 * http://wpn-xm.org/
 *
 * This source file is subject to the terms of the MIT license.
 * For full copyright and license information, view the bundled LICENSE file.
 */

class CheckInstallersWereBuildTask extends Task
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

        $installerScripts     = array_map('basename', glob($this->buildFolder . '/*.iss', GLOB_BRACE));
        $installerExecutables = array_map('self::mapExecutables', glob($this->buildFolder . '/*.exe', GLOB_BRACE));
        $missing_installers   = array_diff($installerScripts, $installerExecutables);

        if(count($missing_installers) > 0) {
            echo "\033[01;31m";
            echo "The following installer executables were not compiled:\n";
            foreach($missing_installers as $installer) {
               echo '  - '.$installer."\n";
            }
            echo "Please check the InnoSetup script files for errors!\n";
            echo "\033[0m\n";
        }

        $total_installers_build = count($installerExecutables);
        if($total_installers_build > 0) {
            $this->log('Successfully build installers for the following ' . $total_installers_build . ' scripts:');
            foreach($installerExecutables as $installer) {
               echo '  - '.$installer."\n";
            }
        } else {
            $this->log('0 installers build! Grrr. Check the log and the compile task.');
        }
    }

    public static function mapExecutables($item)
    {
        $item  = basename($item);
        $item  = substr($item, 12);
        $item  = str_replace(['-Setup','.exe'], ['', '.iss'], $item);
        $item  = strtolower($item);

        return $item;
    }
}