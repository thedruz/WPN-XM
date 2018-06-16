<?php

/**
 * WPИ-XM Server Stack
 * Copyright (c) Jens A. Koch <jakoch@web.de>
 * https://wpn-xm.org/
 *
 * Licensed under the MIT License.
 * See the bundled LICENSE file for copyright and license information.
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

        $installerScripts = glob($this->buildFolder . '\*.iss', GLOB_BRACE);

        foreach($installerScripts as $installer)
        {
            $this->log('Linting Installer "' . basename($installer) . '"');

            $wine_cmd = 'wine cmd.exe /c';

            $iscc_cmd = realpath(__DIR__ . '\..\..\bin\innosetup\ISCC.exe');

            $iscc_lint_args = '/q /DCOMPILE_FROM_IDE=false /O-';

            if(DIRECTORY_SEPARATOR === '/') {
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