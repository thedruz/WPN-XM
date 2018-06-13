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
 * The UpdateComponentSizes task fetches the packed/unpacked archive sizes
 * and calculates the ExtraDiskSpaceRequired for each component
 * in each installer specific download folder.
 * It creates a "sizes-report.txt", which provides all the details.
 * Finally, the installer files (*.iss) are updated with the new ExtraDiskSpaceRequired value.
 */
class UpdateComponentSizes extends Task
{
    private $downloadDir;

    private $sizes;

    function setDownloadDir($dir)
    {
        if(self::isDirEmpty($dir)) {
            throw new BuildException('Download folder is empty.');
        }

        $this->downloadDir = $dir;
    }

    function main()
    {
        $this->calculateSizes();
        $this->updateInstallers();
    }

    function calculateSizes()
    {
        $array = self::recursiveGlob($this->downloadDir, 'zip');
        $array = self::convertDirNamesToFileNames($array);
        $array = self::calculateSizesForFolders($array);
        $array = self::calculateSizesOfCombinedComponents($array);

        file_put_contents('sizes-report.txt', var_export($array, true));

        $this->sizes = $array;
    }

    function updateInstallers()
    {
        $this->insertExtraDiskSizeIntoInstallers($this->sizes);
    }

    function insertExtraDiskSizeIntoInstallers($folders)
    {
        $installers = glob("D:\Github\WPN-XM\WPN-XM\installers\*.iss");

        foreach ($installers as $installer) {

            $this->log('Writing to ' . $installer);

            $lines = file($installer);

            foreach ($folders as $folder => $components) {
                foreach ($components as $component => $values) {
                    // skip PHP extensions, they are Component: phpextensions;
                    if (false !== strpos($component, 'phpext_')) {
                        continue;
                    }

                    $this->log('Updating "extraDiskSpaceRequired" for ' . $component);

                    $nameLookup             = 'Name: ' . $component;
                    $extraDiskSpaceRequired = $values['extraDiskSpaceRequired'];

                    foreach ($lines as $lineNum => $line) {
                        if (false !== strpos($line, $nameLookup)) {
                            $lines[$lineNum] = preg_replace("/ExtraDiskSpaceRequired:\s(\d+);/", "ExtraDiskSpaceRequired: $extraDiskSpaceRequired;", $line, 1);
                            break;
                        }
                    }
                }
            }

            file_put_contents($installer, $lines);
        }
    }

    static function recursiveGlob($dir, $ext)
    {
        $dirs    = glob("$dir\*", GLOB_ONLYDIR);
        $results = array();

        foreach ($dirs as $dir) {
            $files = glob("$dir\*.$ext");

            if (count($files) > 0) {
                foreach ($files as $file) {
                    $component = str_replace(".$ext", '', basename($file));

                    $results[basename($dir)][$component]['file'] = $file;
                }
            }

            recursiveGlob($dir, $ext);
        }

        return $results;
    }

    // get rid of the "version number" and the "PHP version dot" in the directory names
    // so that directory names match the installer filenames
    static function convertDirNamesToFileNames($array)
    {
        foreach ($array as $dir => $values) {
            $dirWithoutVersion = str_replace(array('-0.8.0', '.'), array('', ''), $dir);

            $array[$dirWithoutVersion] = $array[$dir];
            unset($array[$dir]);
        }

        return $array;
    }

    static function calculateSizesForZipArchive($file)
    {
        $zip = new ZipArchive();

        $results = array();

        if ($zip->open($file) === true) {
            $totalSize = 0;

            for ($i = 0; $i < $zip->numFiles; $i++) {
                $fileStats = $zip->statIndex($i);
                $totalSize += $fileStats['size'];
            }

            $results['uncompressed']           = $totalSize;
            $results['compressed']             = filesize($file);
            $results['extraDiskSpaceRequired'] = round(($totalSize - filesize($file)), -4);

            $zip->close();
        }

        return $results;
    }

    static function calculateSizesForFolders($folders)
    {
        foreach ($folders as $folder => $components) {
            foreach ($components as $component => $values) {
                $file    = $values['file'];
                $results = calculateSizesForZipArchive($file);
                if (empty($results) === true) {
                    echo 'Error calculating Zip Archive size: ' . $file . PHP_EOL;
                } else {
                    $folders[$folder][$component] = array_merge($folders[$folder][$component], $results);
                }
            }
        }

        return $folders;
    }

    static function calculateSizesOfCombinedComponents($folders)
    {
        $results = [];

        foreach ($folders as $folder => $components)
        {
            $results['serverstack']['extraDiskSpaceRequired']   = self::getSizeOfComponentServerstack($components);
            $results['phpextensions']['extraDiskSpaceRequired'] = self::getSizeOfComponentPHPExtensions($components);

            $folders[$folder] = array_merge($folders[$folder], $results);
        }

        return $folders;
    }

    /**
     * getSizeOfComponent: "serverstack"
     *
     * Calculate the size for the base of the server stack: php + nginx + mariadb.
     */
    static function getSizeOfComponentServerstack($components)
    {
        $size = $components['php']['extraDiskSpaceRequired']
              + $components['nginx']['extraDiskSpaceRequired']
              + $components['mariadb']['extraDiskSpaceRequired'];

        return round($size, -4);
    }

    /**
     * getSizeOfComponent: "phpextensions"
     *
     * Calculate the size for all PHP extensions.
     */
    static function getSizeOfComponentPHPExtensions($components)
    {
        $size = 0;

        foreach ($components as $component => $values)
        {
            if (strpos('phpext_', $component) !== false) {
                $size =+ $values['extraDiskSpaceRequired'];
            }
        }

        return round($size, -4);
    }

    static function isDirEmpty($dir)
    {
        if (!is_readable($dir)) return null;
        $handle = opendir($dir);
        while (false !== ($entry = readdir($handle))) {
            if ($entry !== '.' && $entry !== '..') {
              return false;
            }
        }
        return true;
    }
}