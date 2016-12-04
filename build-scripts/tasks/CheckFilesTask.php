<?php

/**
 * WPИ-XM Server Stack
 * Copyright © 2010 - 2016 Jens A. Koch <jakoch@web.de>
 * http://wpn-xm.org/
 *
 * This source file is subject to the terms of the MIT license.
 * For full copyright and license information, view the bundled LICENSE file.
 */

class CheckFilesTask extends Task
{
    private $downloadFolder;

    public function setDownloadFolder($downloadFolder)
    {
        $this->downloadFolder = realpath($downloadFolder);
    }

    public function main()
    {
        $this->checkFilesizeOfDownloads();
    }

    public function checkFilesizeOfDownloads()
    {
        $this->log('Checking Filesize of Downloads..');

        $rii = new RecursiveIteratorIterator(new RecursiveDirectoryIterator($this->downloadFolder));

        foreach ($rii as $filename)
        {
            // filter out "." and ".."
            if ($filename->isDir()) {
                continue;
            }

            // warn, if filesize is lower than 2kb
            if(filesize($filename) < 2048) {
                echo "\033[01;31m";
                echo "The file \"$filename\" is smaller than 2kb. Please check the download!\n";
                echo "\033[0m";
            }
        }
    }
}