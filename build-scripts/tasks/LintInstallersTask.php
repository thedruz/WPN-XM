<?php

/**
 * WPИ-XM Server Stack - Updater
 * Copyright © 2010 - 2016 Jens A. Koch <jakoch@web.de>
 * http://wpn-xm.org/
 *
 * This source file is subject to the terms of the MIT license.
 * For full copyright and license information, view the bundled LICENSE file.
 */

class LintInstallersTask extends Task
{
    private $buildFolder;

    public function setBuildFolder($buildFolder)
    {
        $this->buildFolder = realpath($buildFolder);
    }

    public function main()
    {
        $this->lintInstallers();
    }

    public function lintInstallers()
    {
        $this->log('Linting Installers..');

        $installerScripts = glob($this->buildFolder . '/*.iss', GLOB_BRACE);

        foreach($installerScripts as $installer)
        {
            $this->log('Linting Installer "' . basename($installer) . '"');

            $wine_cmd = 'wine cmd.exe /c';

            $iscc_cmd = realpath(__DIR__ . '\..\..\bin\innosetup\ISCC.exe');

            $iscc_lint_args = '/q /DCOMPILE_FROM_IDE=false /O-';

            if(DS === '/') {
                $lint_cmd = $wine_cmd . ' ' . $iscc_cmd . ' ' . $iscc_lint_args . ' ' . $installer;
            } else {
                $lint_cmd = $iscc_cmd . ' ' . $iscc_lint_args . ' ' . $installer;
            }
            
            //$this->log('cmd: ' . $lint_cmd);

            passthru($lint_cmd);
        }
    }
}