<?php

/**
 * WPИ-XM Server Stack - Updater
 * Copyright © 2010 - 2016 Jens A. Koch <jakoch@web.de>
 * http://wpn-xm.org/
 *
 * This source file is subject to the terms of the MIT license.
 * For full copyright and license information, view the bundled LICENSE file.
 */

class DownloadFiles extends Task
{
    private $registryfolder;
    private $wpnxmversion;

    function setRegistryFolder($registryfolder)
    {
        $this->registryfolder = realpath($registryfolder);
    }

    function setWpnxmVersion($wpnxmversion)
    {
        $this->wpnxmversion = $wpnxmversion;
    }

    function main()
    {
        defined('DS') || define('DS', DIRECTORY_SEPARATOR);

        // wget fails on sourceforge downloads
        // $wget_cmd_template = "wget --continue --progress=bar:force --tries=5 --no-check-certificate %url% -O %targetFolder%/%targetFile%";

        //$curl_cmd_template = "curl -C - --insecure --fail --retry 5 --stderr - --location %url% -o %targetFolder%/%targetFile%";

        $aria_cmd_template = "aria2c \"%url%\" --dir=%targetFolder% --out=%targetFile%";
        //$aria_cmd_template .= " --deferred-input=true";
        $aria_cmd_template .= " --disk-cache=0 --max-download-result=0 --max-tries=5 --file-allocation=falloc" //none,prealloc,alloc
        $aria_cmd_template .= " --check-certificate=false --split=6 --min-split-size=12M --max-connection-per-server=6";
        $aria_cmd_template .= " --conditional-get=true --auto-file-renaming=false --allow-overwrite=true --http-accept-gzip=true";
        $aria_cmd_template .= " --user-agent=\"WPN-XM Server Stack Downloader\" "; // --quiet=true

        /**
         * We download all packages of the Full and LiteRC installers.
         * Later, we copy the downloads from Full into the Standard and Lite folders.
         *
         * "/registry/installer/v0.8.6/{full,literc}-0.8.6-*.json"
         */
        $registries = glob(
            $this->registryfolder.DS.'v'.$this->wpnxmversion
            .DS.'{full,literc}-'.$this->wpnxmversion.'-*.json',
            GLOB_BRACE
        );

        foreach ($registries as $registry)
        {
            $basename = basename($registry, '.json');

            // remove php version dot from basename ("php5.6" => "php56")
            $basename = preg_replace("#(.*)-(.*)-(.*).(\d)-(.*)#", "$1-$2-$3$4-$5", $basename);

            $this->log('Starting Downloads for Installer ['. $basename .']');
            $this->log('');

            $targetFolder = 'downloads' . DS . $basename;

            if (!file_exists($targetFolder)) {
                mkdir($targetFolder, 0777, true);
            }

            $components = json_decode(file_get_contents($registry));

            foreach ($components as $component)
            {
                $url          = $component[1];
                $targetFile   = $component[2];

                $download_cmd = str_replace(
                    array('%url%', '%targetFolder%', '%targetFile%'),
                    array($url, $targetFolder, $targetFile),
                    $aria_cmd_template
                );

                $this->log('Downloading: ' . $targetFolder . DS . $targetFile);

                // execute directly
                //exec($download_cmd);

                // write commands to file - for line-wise execution on the shell
                file_put_contents('downloads-cmds.txt', $download_cmd . PHP_EOL, FILE_APPEND);

                if(is_file($targetFolder . DS . $targetFile) === false) {
                    $this->log('File not found. Download failed.');
                }

                unset($url, $targetFile, $download_cmd);
            }

            $this->log('');

            unset($basename, $targetFolder, $components);
        }
        unset($registries);
    }
}