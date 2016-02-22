<?php

/**
 * WPИ-XM Server Stack - Updater
 * Copyright © 2010 - 2016 Jens A. Koch <jakoch@web.de>
 * http://wpn-xm.org/
 *
 * This source file is subject to the terms of the MIT license.
 * For full copyright and license information, view the bundled LICENSE file.
 */

class MoveDownloadFilesTask extends Task
{
    private $registryfolder;
    private $downloadfolder;
    private $wpnxmversion;

    public function setRegistryFolder($registryfolder)
    {
        $this->registryfolder = realpath($registryfolder);
    }

    public function setDownloadFolder($downloadfolder)
    {
        $this->downloadfolder = realpath($downloadfolder);
    }

    public function setWpnxmVersion($wpnxmversion)
    {
        $this->wpnxmversion = $wpnxmversion;
    }

    public function setUseSharedDownloadFolder($useSharedDownloadFolder)
    {
        $this->useSharedDownloadFolder = (bool) $useSharedDownloadFolder;
    }

    public function main()
    {
        defined('DS') || define('DS', DIRECTORY_SEPARATOR);

        // get all registries files, e.g. "registry/installer/v0.8.0/*0.8.0*.json"
        $registries = glob(
            $this->registryfolder.DS.'v'.$this->wpnxmversion
                                 .DS.'*'.$this->wpnxmversion.'*.json'
        );

        foreach ($registries as $registry)
        {
            $basename = basename($registry, '.json');

            // skip "full" -  download sources
            // skip "literc": these fetch PHP-QA (RC) versions = download sources
            /*if ((false !== strpos($basename, 'full')) ||
                (false !== strpos($basename, 'literc'))) {
                continue;
            }*/

            $fullFolder = preg_replace('(lite|standard)', 'full', $basename);

            $this->log("\n");
            $this->log('Moving Download Files for "' . $basename . '" from "' . $fullFolder . '"');
            $this->log("\n");

            $components = json_decode(file_get_contents($registry));

            foreach ($components as $component)
            {
                if($this->useSharedDownloadFolder) {
                    // shared
                    $source = $this->downloadFolder
                        . self::getTargetFolderShared($fullFolder, $component[0])
                        . DS . $component[2];

                } else {
                    // downloads are in the full installer folder
                    $source = $this->downloadfolder.DS.$fullFolder.DS.$component[2];
                }

                if (is_file($source)) {
                    $version = ($component[3] === 'latest') ? $component[3] : ' v' . $component[3];
                    $this->log('Component ' . $component[0] . ' ' . $version);

                    $targetDir = $this->downloadfolder . DS . $basename;

                    if (is_dir($targetDir) === false) {
                        mkdir($targetDir);
                    }

                    $target = $targetDir . DS . $component[2];

                    self::doCopy($source, $target);

                } else {
                    $this->log('Download missing for Component [' . $component[0] . ']: ' . $component[2]);
                }
            }
        }
    }

    public static function doCopy($source, $target)
    {
        $this->log('  Copying ' . $source);
        $this->log('       to ' . $target);

        if (is_file($target) === false) {
            copy($source, $target);
        } elseif (is_file($target) && filesize($source) !== filesize($target)) {
            $this->log('Target file exists already, but differs in size. Overwriting!');
            copy($source, $target);
        } else {
            $this->log('Target file exists already. Skipping.');
        }
    }

    public static function getTargetFolderShared($installerDir, $component)
    {
        $downloadDir = 'downloads';

        // download PHP main and PHP extensions always into the installer folder
        if((strpos($component, 'phpext_') !== false) ||
           (in_array($component, ['php', 'php-x64', 'php-qa', 'php-qa-x64']))) {
            $downloadDir .= DS . $installerDir;
        }
        // download component into the shared "x64" folder
        elseif(strpos($component, '-x64') !== false) {
            $downloadDir .= DS . 'x64';
        }
        // download component into the "x86" folder
        /*elseif((strpos($component, '-x86') !== false) {
            $downloadDir .= DS.'x86';
        }*/

        return $downloadDir;
    }
}