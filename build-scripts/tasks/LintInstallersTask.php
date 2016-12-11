<?php

/**
 * WPИ-XM Server Stack
 * Copyright © 2010 - 2016 Jens A. Koch <jakoch@web.de>
 * http://wpn-xm.org/
 *
 * This source file is subject to the terms of the MIT license.
 * For full copyright and license information, view the bundled LICENSE file.
 */

class LintInstallersTask extends Task
{
    private $buildFolder;
    private $syntaxError = false;

    public function setBuildFolder($buildFolder)
    {
        $this->buildFolder = realpath($buildFolder);
    }

    public function main()
    {
        $this->lintInstallers();

        if ($this->syntaxError) {
            throw new BuildException('Syntax Error(s) in Installer!');
        }
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
            
            $this->log('Executing: ' . $lint_cmd, Project::MSG_DEBUG);
            
            @exec($lint_cmd, $output, $return);
            
            if ($return !== 0) {
                $this->log("Found Syntax Error!", Project::MSG_ERR);
                $this->syntaxError = true;
            }            
        }
    }
}