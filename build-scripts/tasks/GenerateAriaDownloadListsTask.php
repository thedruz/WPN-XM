<?php

/**
 * WPИ-XM Server Stack
 * Copyright (c) Jens A. Koch <jakoch@web.de>
 * https://wpn-xm.org/
 *
 * Licensed under the MIT License.
 * See the bundled LICENSE file for copyright and license information.
 */

class GenerateAriaDownloadListsTask extends Task
{
    private $registryFolder;
    private $downloadFolder;
    private $wpnxmVersion;
    private $useSharedDownloadFolder;

    public function setRegistryFolder($registryFolder)
    {
        $this->registryFolder = realpath($registryFolder);
    }

    public function setDownloadFolder($downloadFolder)
    {
        $this->downloadFolder = realpath($downloadFolder);
    }

    public function setWpnxmVersion($wpnxmVersion)
    {
        $this->wpnxmVersion = $wpnxmVersion;
    }

    public function setUseSharedDownloadFolder($useSharedDownloadFolder)
    {
        $this->useSharedDownloadFolder = (bool) $useSharedDownloadFolder;
    }


    public function main()
    {
        defined('DS') || define('DS', DIRECTORY_SEPARATOR);

        /**
         * We download all packages of the Full and LiteRC installers.
         * Later, we copy the downloads from Full into the Standard and Lite folders.
         *
         * "/registry/installer/v0.8.6/{full,literc}-0.8.6-*.json"
         */
        $registries = glob(
            $this->registryFolder.DS.'v'.$this->wpnxmVersion
            .DS.'{full,literc}-'.$this->wpnxmVersion.'-*.json',
            GLOB_BRACE
        );

        foreach ($registries as $registry)
        {
            $basename = basename($registry, '.json');

            // remove php version dot from basename ("php5.6" => "php56")
            $basename = preg_replace("#(.*)-(.*)-(.*).(\d)-(.*)#", "$1-$2-$3$4-$5", $basename);

            // "/registry/installer/downloads-for-full-0.8.6-php70-w64.txt"
            $file = $this->registryFolder.DS.'downloads-for-'.$basename.'.txt';

            $txt  = self::getAriaFileHeader($basename);

            $components = json_decode(file_get_contents($registry));

            if($this->useSharedDownloadFolder) {
                $txt .= self::downloadIntoSharedFolder($components, $basename);
            } else {
                $txt .= self::downloadIntoIndividualFolder($components, $basename);
            }

            file_put_contents($file, $txt);

            $this->log('Created Aria2 Download Description File - ' . $file);
        }
    }

    // create Download Description For Shared Download Folder
    public static function downloadIntoSharedFolder($components,$installerDir)
    {
        $txt = '';

        foreach ($components as $component)
        {
            $url       = $component[1];
            $targetDir = self::getTargetFolderShared($installerDir, $component[0]);
            $target    = $targetDir.DS.$component[2];

            $txt .= self::insertDownload($url, $target);
        }

        return $txt;
    }

    public static function getTargetFolderShared($installerDir, $component)
    {
        $downloadDir = 'downloads' ;

        // download PHP main and PHP extensions always into the installer folder
        if((strpos($component, 'phpext_') !== false) ||
           (in_array($component, ['php', 'php-x64', 'php-qa', 'php-qa-x64']))) {
            $downloadDir .= DS.$installerDir;
        }
        // download component into the shared "x64" folder
        elseif(strpos($component, '-x64') !== false) {
            $downloadDir .= DS.'x64';
        }
        // download component into the "x86" folder
        /*elseif((strpos($component, '-x86') !== false) {
            $downloadDir .= DS.'x86';
        }*/

        return $downloadDir;
    }

    public static function downloadIntoIndividualFolder($components, $installerDir)
    {
        $txt = '';

        foreach ($components as $component)
        {
            $url    = $component[1];
            $target = 'downloads' . DS . $installerDir . DS . $component[2];

            $txt .= self::insertDownload($url, $target);
        }

        return $txt;
    }

    public static function getAriaFileHeader($installerName)
    {
        $txt = '#' . PHP_EOL;
        $txt .= '# WPN-XM Server Stack' . PHP_EOL;
        $txt .= '#' . PHP_EOL;
        $txt .= '# Download Links for the Installation Wizard "' . $installerName . '".' . PHP_EOL;
        $txt .= '#' . PHP_EOL;
        $txt .= '# This aria2c input file contains a list of URIs for parallel downloading.' . PHP_EOL;
        $txt .= '# The file is auto-generated. Do not modify.' . PHP_EOL;
        $txt .= '#' . PHP_EOL;
        $txt .= '# For syntax, see:' . PHP_EOL;
        $txt .= '#   https://aria2.github.io/manual/en/html/aria2c.html#id2' . PHP_EOL;
        $txt .= '#' . PHP_EOL;

        return $txt;
    }

    // add a download line in Aria2C Syntax
    public static function insertDownload($url = '', $target = '')
    {
        return $url . PHP_EOL . '    out=' . $target . PHP_EOL;
    }
}