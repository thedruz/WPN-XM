<?php

/**
 * WPИ-XM Server Stack
 * Copyright (c) Jens A. Koch <jakoch@web.de>
 * https://wpn-xm.org/
 *
 * Licensed under the MIT License.
 * See the bundled LICENSE file for copyright and license information.
 */

/**
 * Check installer health
 *
 * 1. Bitsize based checks
 *    - [x] get bitsize from filename - w32 or w64
 *    - [x] check bitsize define correct:               (#define BITSIZE "w32") 
 *    - [x] check right bitsize of 7zip is shipped      (Source: ..\bin\7zip\x64)
 *    - [x] check vcredist bitsize VCRedist_x64
 * 2. components
 *    - [x] expect a matching Name: entry
 *    - [x] expect a matching filename_ entry
 *    - [x] expect a matching target_path + filename_ entry (used in the unzip part)
 *    - foreach URL_ 
 *      - [ ] when "URL_phpext_" expect correct "bitsize=x" 
 *      - [ ]when webinstaller, expect a itd_addFile entry, too
 */
class CheckInstallersTask extends Task
{
    private $installersFolder;
    private $registriesFolder;

    private $scripts;
    private $registries;

    public function setInstallersFolder($folder)
    {
        $this->installersFolder = realpath($folder);
    }

    public function setNextInstallerRegistriesFolder($folder)
    {
        $this->registriesFolder = realpath($folder);
    }

    public function main()
    {
        $this->log('== Checking Installer Health');

        $this->checkEveryInstallersHasANextRegistry();
        $this->checkEveryComponentInNextRegistryHasFilenameEntryInInstaller();
        $this->checkBitsizeEntriesInInstaller();
    }

    public function checkEveryInstallersHasANextRegistry()
    {        
        $this->log('Check, that every installer script has a corresponding "next" installer registry file...');

        $this->scripts    = array_map('static::mapIssToRegistry', glob($this->installersFolder . '/*.iss', GLOB_BRACE));
        $this->registries = array_map('basename', glob($this->registriesFolder . '/*.json', GLOB_BRACE));

        $scripts    = array_flip($this->scripts);
        $registries = array_flip($this->registries);

        $missingNextRegistriesWithWebinstallers = array_flip(array_diff($scripts, $registries));
        $missingNextRegistries = array_filter($missingNextRegistriesWithWebinstallers, 'static::filterOutWebinstallers');

        if(empty($missingNextRegistries)) {
            $this->log(' => Ok');
        } else {
            foreach($missingNextRegistries as $missingNextRegistry) {
                $this->log('  => Missing Registry: '. $missingNextRegistry);
            }
        }
    }

    public static function filterOutWebinstallers($item)
    {
        return (false !== strpos($item, 'webinstaller')) ? false : true;
    }

    public static function mapIssToRegistry($item)
    { 
        $item = basename($item);
        $item = preg_replace("/-php(\d)(\d)/", "-next-php$1.$2", $item);
        $item = str_replace(['.iss'], ['.json'], $item);
        return $item;
    }

    public function checkEveryComponentInNextRegistryHasFilenameEntryInInstaller()
    {
        $this->log('Check, that every component in the "next" installer registry file has corresponding entries in the installer script.');

        $scripts = glob($this->installersFolder . '/*.iss', GLOB_BRACE);

        foreach($scripts as $installerFile) 
        {
            if(false !== strpos($installerFile, 'webinstaller')) {
                $this->log('Skipping Installers without registry file: '. $installerFile);
                continue;
            }

            $this->log('Processing Installer: '. $installerFile);
           
            $registryFileName = static::mapIssToRegistry($installerFile);
            $registryFile = $this->registriesFolder . DIRECTORY_SEPARATOR . $registryFileName;
            $this->log(' => Matching Registry file is: ' . $registryFileName, Project::MSG_VERBOSE);

            $installerContent  = file_get_contents($installerFile);
            $installerRegistry = json_decode(file_get_contents($registryFile), true);

            foreach ($installerRegistry as $idx => $data) // data = name, url, filename after download, version
            {
                $registrySoftwareName = $data[0];                
                $name                 = static::getSoftwareName($registrySoftwareName);

                // ---------------------------------------------------------------------

                $this->log('    => Check filename_ entry', Project::MSG_VERBOSE);

                if(false !== strpos($installerContent, "Filename_$name")) {
                    //$this->log(" => Found entry for software Filename_$name");
                } else {
                    $this->log("       => Missing filename_ entry for software $registrySoftwareName => $name.");
                    $this->log("          Please add: Filename_$name = \"$data[2]\";");
                }

                // ---------------------------------------------------------------------

                $this->log('    => Check Name: entry', Project::MSG_VERBOSE);

                $name2 = $this->getSoftwareNameUsedInNameSection($name);

                if(false !== strpos($installerContent, "Name: $name2;")) {
                    //$this->log(" => Found entry for software Filename_$name");
                } else {                
                    $this->log("       => Missing Name entry for software $registrySoftwareName => $name2. Please add \"Name: $name2;\"");
                }

                // ---------------------------------------------------------------------

                $this->log('    => Check Install Section exists', Project::MSG_VERBOSE);

                if(false !== strpos($installerContent, "targetPath + Filename_$name")) {
                    //$this->log(" => Found entry for software Filename_$name");
                } else {                
                    $this->log("       => Missing install section for $registrySoftwareName => $name2.");
                }
            }
        }
    }

    public function getSoftwareNameUsedInNameSection($name)
    {
        if(in_array($name, ['nginx', 'php', 'mariadb'])) {
            return 'serverstack';
        }
        if(false !== strpos($name, "phpext_xdebug")) {
             return 'xdebug';
        }
        if(false !== strpos($name, "phpext_")) {
             return 'phpextensions';
        }
        if(false !== strpos($name, "wpnxm_benchmark")) {
             return 'benchmark';
        }                
        if(in_array($name, ['closure_compiler', 'yuicompressor'])) {
             return 'assettools';
        }
        if(in_array($name, ['gogs', 'msysgit'])) {
             return 'git';
        }
        if(in_array($name, ['node', 'nodenpm'])) {
             return 'node';
        }
        if($name == 'php_cs_fixer') { 
             return 'phpcsfixer'; 
        }
        if($name == 'wpnxm_scp') {
            return 'servercontrolpanel';
        }
        return $name;
    }

    public function checkBitsizeEntriesInInstaller()
    {
        $this->log('Check, for correct bitsize entries in the installer script.');

        $scripts = glob($this->installersFolder . '/*.iss', GLOB_BRACE);

        foreach($scripts as $installerFile) 
        {
            $this->log('Processing Installer: '. $installerFile);
            $bitsizeX = (false !== strpos($installerFile, '-w32')) ? 'x86' : 'x64';
            $bitsizeW = (false !== strpos($installerFile, '-w32')) ? 'w32' : 'w64';    
            $this->log('Found bitsize: ' . $bitsizeX . ' = '. $bitsizeW, Project::MSG_VERBOSE);
           
            $installerContent  = file_get_contents($installerFile);

            // ---------------------------------------------------------------------
           
            $this->log("    => Check bitsize define entry: \"#define BITSIZE\"", Project::MSG_VERBOSE);

            if(false !== strpos($installerContent, "#define BITSIZE              \"$bitsizeW\"")) {
                //$this->log("    => ok");
            } else {                   
                $this->log("       => Missing \"#define BITSIZE\".");
                $this->log("          Please add: #define BITSIZE              \"$bitsizeW\";");
            }

            // ---------------------------------------------------------------------

            $this->log("    => Check 7zip folder entry: \"Source: ..\bin\\7zip\\$bitsizeX\"", Project::MSG_VERBOSE);

            if(false !== strpos($installerContent, "Source: ..\bin\\7zip\\$bitsizeX")) {
                //$this->log("    => ok");
            } else {                   
                $this->log("       => Missing \"#define BITSIZE\".");
                $this->log("          Please add: Source: ..\bin\\7zip\\$bitsizeX\" entry");
            } 

            // ---------------------------------------------------------------------

            $this->log("    => Check \"vcredist_$bitsizeX\" entries", Project::MSG_VERBOSE);

            $regexp = '#vcredist_'.$bitsizeX.'_\d+#mi';
            $result = preg_match_all($regexp, $installerContent);

            if(false !== strpos($installerFile, 'webinstaller')) {
                if($result == 2) {
                    //$this->log("    => ok");
                } else {
                    $this->log("       => Invalid vcredist_ entry.");
                }
            } else {
                if($result == 3) {
                    //$this->log("    => ok");
                } else {
                    $this->log("       => Invalid vcredist_ entry.");                    
                }
            }            
        }
    }

    public static function getSoftwareName($registrySoftwareName)
    {
        $name = str_replace(['-x64', '-x86', '-', ], ['', '', '_'], $registrySoftwareName);
        // turn "php-qa" into "php"
        if($name == 'php_qa') {
            $name = str_replace('_qa', '', $name);
        }
        return $name;
    }

    public static function mapRegistryToIss($item)
    {   
        $item = basename($item);
        $item[strpos($item,'.')] = '@'; // replace first dot with X (php7.1 => php7@1)
        return str_replace(['@', '-next-php', '.json'], ['', '-php', '.iss'], $item);
    }
}