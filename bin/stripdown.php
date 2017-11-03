<?php
/**
 * WPИ-XM Server Stack
 * Copyright © 2010 - 2015 Jens-André Koch <jakoch@web.de>
 * http://wpn-xm.org/
 *
 * This source file is subject to the terms of the MIT license.
 * For full copyright and license information, view the bundled LICENSE file.
 */

/**
 *  Stripdown Scripts
 *
 *  We are re-packaging several components, because they ship files,
 *  which are hardly ever needed by the average developer.
 *
 *  The stripdown procedure consists of the following steps:
 *
 *    1. the stripdown folder is deleted and re-created, to have a clean target folder
 *    2. the downloaded component is unziped into the stripdown folder
 *    3. if the component zip, shipped a versionized folder, it is renamed to a short name
 *    4. the stripdown for this component is executed, reducing the files
 *    5. the original zip file is deleted
 *    6. the stripdown folder is zipped to the download folder, under the short name of the component
 *    7. the stripdown folder is deleted
 */

$stripdown = new Stripdown($argv[1], $argv[2]);
$stripdown->run();

class Stripdown
{
    function __construct($dir, $component)
    {
        if(strpos($dir, "$") !== false) {
            exit('    Folder invalid: ' . $dir . "\n");
        }

        defined('DS') || define('DS', DIRECTORY_SEPARATOR);

        $this->downloadsDir = $dir;
        $this->component = $component;
        $this->componentZip = $component . '.zip';
        $this->componentZipFileInDownloadFolder = realpath($dir . DS . $this->componentZip);
        $this->stripdownFolder = $this->downloadsDir . DS . 'stripdown';

        // all components have their component name as extraction folder, except postgresql
        $folder = ($component != 'postgresql') ? $component : 'pgsql';

        $this->stripdownFolderWithComponent = str_replace('/', DS, /*getcwd() . DIRECTORY_SEPARATOR .*/ $this->stripdownFolder . DS . $folder);

        echo "\n\t" . 'Stripdown for [' . $dir . '][' . $component . "]\n\n";
    }

    function run()
    {
        $this->checkComponentExists();
        $this->checkFilesize();
        $this->createFolderForComponent();
        $this->unzip();
        $this->renameFolder();
        #$this->extractedCheck();
        $this->stripdown();
        //$this->compressExecutables(); // disabled, because UPX causes AV false detections
        $this->zip();
        $this->cleanup();
        $this->goodbye();
    }

    function checkComponentExists()
    {
        if(is_file($this->componentZipFileInDownloadFolder))
        {
            echo "\t> Component found.\n";
            return;
        } else {
            echo "\t> Component not found. Skipping.\n";
            exit;
        }
    }

    function checkFilesize()
    {
        $size = $this->getFilesize($this->componentZipFileInDownloadFolder);

        $size = round($size, 0);

        echo "\t\tFilesize before Stripdown: " . $size . " MB\n";

        if($this->component === 'postgresql' && $size >= 25) {
            return;
        }

        if($this->component === 'imagick' && $size >= 55) {
            return;
        }

        if($this->component === 'mariadb' && $size >= 25) {
            return;
        }

        if($this->component === 'mongodb' && $size >= 50) {
            return;
        }

        echo "\t\tThe archive is too small for a stripdown. Skipping.\n";
        exit;
    }

    function createFolderForComponent()
    {
        if($this->component === 'imagick')
        {
            mkdir($this->stripdownFolderWithComponent, 0777, true);
        }
    }

    function getTargetFolder()
    {
        if($this->component === 'imagick')
        {
            return $this->stripdownFolderWithComponent;
        }

        return $this->stripdownFolder;
    }

    function unzip()
    {
        echo "\t> Unzipping.\n";

        exec(self::zipcmd() . ' x ' . $this->componentZipFileInDownloadFolder . ' -o' . $this->getTargetFolder() .' -y');

        echo "\t\tDone.\n";
    }

    function renameFolder()
    {
        // fix case issues and remove version information from folders by renaming them

        if($this->component === 'mariadb') {
            passthru(self::moveCmd() . ' -if ' . $this->stripdownFolder . '/mariadb* ' . $this->stripdownFolderWithComponent);
        }

        if($this->component === 'mongodb') {
            passthru(self::moveCmd() . ' -if ' . $this->stripdownFolder . '/mongodb* ' . $this->stripdownFolderWithComponent);
        }
    }

    function extractedCheck()
    {
        if($this->component === 'postgresql' && is_file($this->stripdownFolderWithComponent . '/bin/pg_ctl.exe')) {
            return true;
        }

        if($this->component === 'imagick' && is_file($this->stripdownFolderWithComponent . '/animate.exe')) {
            return true;
        }

        if($this->component === 'mariadb' && is_file($this->stripdownFolderWithComponent . '/bin/mysqld.exe')) {
            return true;
        }

        if($this->component === 'mongodb' && is_file($this->stripdownFolderWithComponent . '/bin/mongo.exe')) {
            return true;
        }

        return true;
    }

    function stripdown()
    {
        echo "\t> Stripdown [$this->component].\n";

        if($this->component === 'postgresql') {
            // process the /bin folder
            // delete pdb files (windows crashdumps helpers / debug symbols)
            $this->deleteFiles($this->stripdownFolderWithComponent . '/symbols/*.pdb');
            // delete folders
            $this->deleteFolder($this->stripdownFolderWithComponent . '/symbols');
            $this->deleteFolder($this->stripdownFolderWithComponent . '/doc');
            $this->deleteFolder($this->stripdownFolderWithComponent . '/include');
        }

        if($this->component === 'imagick') {
            // process the /www folder
            $this->deleteFolder($this->stripdownFolderWithComponent . '/www');
        }

        if($this->component === 'mongodb') {
            $this->deleteFiles($this->stripdownFolderWithComponent . '/bin/*.pdb');
        }

        if($this->component === 'mariadb') {
            // Toplevel remove *.ini - replaced by our own
            $this->deleteFiles($this->stripdownFolderWithComponent . '/*.ini');

            // remove these folders completely

            $this->deleteFolder($this->stripdownFolderWithComponent . '/docs');
            $this->deleteFolder($this->stripdownFolderWithComponent . '/include');
            $this->deleteFolder($this->stripdownFolderWithComponent . '/mysql-test');
            $this->deleteFolder($this->stripdownFolderWithComponent . '/sql-bench');

            // process the /bin folder

            // 1) delete pdb files (windows crashdumps debug files)

            $this->deleteFiles($this->stripdownFolderWithComponent . '/bin/*.pdb');

            // 2) delete certain executables
            // This list of executables equals a MariaDB win32 msi install (with only database and no client executables)

            $this->deleteFiles($this->stripdownFolderWithComponent . '/bin/aria_chk.exe');
            $this->deleteFiles($this->stripdownFolderWithComponent . '/bin/aria_dump_log.exe');
            $this->deleteFiles($this->stripdownFolderWithComponent . '/bin/aria_ftdump.exe');
            $this->deleteFiles($this->stripdownFolderWithComponent . '/bin/aria_pack.exe');
            $this->deleteFiles($this->stripdownFolderWithComponent . '/bin/aria_read_log.exe');
            # keep my_print_defaults.exe
            $this->deleteFiles($this->stripdownFolderWithComponent . '/bin/myisam_ftdump.exe');
            $this->deleteFiles($this->stripdownFolderWithComponent . '/bin/myisamchk.exe');
            $this->deleteFiles($this->stripdownFolderWithComponent . '/bin/myisamlog.exe');
            $this->deleteFiles($this->stripdownFolderWithComponent . '/bin/myisampack.exe');
            # keep mysql.exe
            $this->deleteFiles($this->stripdownFolderWithComponent . '/bin/mysql_embedded.exe');
            # keep mysql_install_db.exe - needed for initial database setup during installation
            $this->deleteFiles($this->stripdownFolderWithComponent . '/bin/mysql_plugin.exe');
            $this->deleteFiles($this->stripdownFolderWithComponent . '/bin/mysql_tzinfo_to_sql.exe');
            # keep mysql_upgrade.exe - - needed for initial database setup during installation
            # keep mysql_upgrade_service.exe
            # keep mysql_upgrade_wizard.exe
            # keep mysqladmin.exe
            $this->deleteFiles($this->stripdownFolderWithComponent . '/bin/mysqlbinlog.exe');
            # keep mysqlcheck.exe
            # keep mysqld.exe
            $this->deleteFiles($this->stripdownFolderWithComponent . '/bin/mysqlimport.exe');
            $this->deleteFiles($this->stripdownFolderWithComponent . '/bin/mysqlshow.exe');
            $this->deleteFiles($this->stripdownFolderWithComponent . '/bin/mysqltest.exe');
            $this->deleteFiles($this->stripdownFolderWithComponent . '/bin/mysqltest_embedded.exe');
            $this->deleteFiles($this->stripdownFolderWithComponent . '/bin/mysql_client_test.exe');
            $this->deleteFiles($this->stripdownFolderWithComponent . '/bin/mysql_client_test_embedded.exe');
            $this->deleteFiles($this->stripdownFolderWithComponent . '/bin/echo.exe');
            $this->deleteFiles($this->stripdownFolderWithComponent . '/bin/mysqlslap.exe');
            $this->deleteFiles($this->stripdownFolderWithComponent . '/bin/replace.exe');
            #keep perror.exe

            // 3) delete certain perl files
            $this->deleteFiles($this->stripdownFolderWithComponent . '/bin/mysql_convert_table_format.pl');
            $this->deleteFiles($this->stripdownFolderWithComponent . '/bin/mysql_secure_installation.pl');
            $this->deleteFiles($this->stripdownFolderWithComponent . '/bin/mysqld_multi.pl');
            $this->deleteFiles($this->stripdownFolderWithComponent . '/bin/mysqldumpslow.pl');
            $this->deleteFiles($this->stripdownFolderWithComponent . '/bin/mysqlhotcopy.pl');

            // process the /data folder

            $this->deleteFiles($this->stripdownFolderWithComponent . '/data/performance_schema/*.*');
            $this->deleteFolder($this->stripdownFolderWithComponent . '/data/performance_schema');

            $this->deleteFiles($this->stripdownFolderWithComponent . '/data/test/*.*');
            $this->deleteFolder($this->stripdownFolderWithComponent . '/data/test');

            // process the /lib folder

            $this->deleteFiles($this->stripdownFolderWithComponent . '/lib/*.pdb');
            $this->deleteFiles($this->stripdownFolderWithComponent . '/lib/*.lib');
            $this->deleteFiles($this->stripdownFolderWithComponent . '/lib/plugin/*.pdb');

            // process the /share folder

            // whats left in this folder? english & german

            $this->deleteFolder($this->stripdownFolderWithComponent . '/share/czech');
            $this->deleteFolder($this->stripdownFolderWithComponent . '/share/danish');
            $this->deleteFolder($this->stripdownFolderWithComponent . '/share/dutch');
            $this->deleteFolder($this->stripdownFolderWithComponent . '/share/estonian');
            $this->deleteFolder($this->stripdownFolderWithComponent . '/share/french');
            $this->deleteFolder($this->stripdownFolderWithComponent . '/share/greek');
            $this->deleteFolder($this->stripdownFolderWithComponent . '/share/italian');
            $this->deleteFolder($this->stripdownFolderWithComponent . '/share/hungarian');
            $this->deleteFolder($this->stripdownFolderWithComponent . '/share/japanese');
            $this->deleteFolder($this->stripdownFolderWithComponent . '/share/korean');
            $this->deleteFolder($this->stripdownFolderWithComponent . '/share/norwegian');
            $this->deleteFolder($this->stripdownFolderWithComponent . '/share/norwegian-ny');
            $this->deleteFolder($this->stripdownFolderWithComponent . '/share/polish');
            $this->deleteFolder($this->stripdownFolderWithComponent . '/share/portuguese');
            $this->deleteFolder($this->stripdownFolderWithComponent . '/share/romanian');
            $this->deleteFolder($this->stripdownFolderWithComponent . '/share/russian');
            $this->deleteFolder($this->stripdownFolderWithComponent . '/share/serbian');
            $this->deleteFolder($this->stripdownFolderWithComponent . '/share/spanish');
            $this->deleteFolder($this->stripdownFolderWithComponent . '/share/slovak');
            $this->deleteFolder($this->stripdownFolderWithComponent . '/share/swedish');
            $this->deleteFolder($this->stripdownFolderWithComponent . '/share/ukrainian');

            // process the /support-files folder

            // wtf? a solaris script in a windows distribution?

            $this->deleteFolder($this->stripdownFolderWithComponent . '/support-files');
        }

        echo "\t\tDone.\n";
    }

    function deleteFiles($mask = "*.pdb")
    {
        array_map('unlink', glob($mask));
    }

    function deleteFolder($path)
    {
        if (is_dir($path) === true) {
            $files = new RecursiveIteratorIterator(
                   new RecursiveDirectoryIterator($path),
                   RecursiveIteratorIterator::CHILD_FIRST
            );

            foreach ($files as $file) {
                if (in_array($file->getBasename(), array('.', '..')) !== true) {
                    if ($file->isDir() === true) {
                        rmdir($file->getPathName());
                    } elseif (($file->isFile() === true) || ($file->isLink() === true)) {
                        unlink($file->getPathname());
                    }
                }
            }

            return rmdir($path);
        } elseif ((is_file($path) === true) || (is_link($path) === true)) {
            return unlink($path);
        }

        return false;
    }

    function compressExecutables()
    {
        echo "\t> Compressing executables with UPX.\n";

        if($this->component === 'imagick') {
            $executablesPath = '/*.exe';
        } else {
            $executablesPath = '/bin/*.exe';
        }


        exec(self::upxcmd() .  ' ' . $this->stripdownFolderWithComponent . $executablesPath);

        echo "\t\tDone.\n";
    }

    function zip()
    {
        echo "\t> Zipping.\n";

        // delete old zip file in the download folder
        unlink($this->componentZipFileInDownloadFolder);

        // zip the stripdown folder (and "replace" the old zip file)
        exec(self::zipcmd() . ' a -mx9 -mmt '. $this->componentZipFileInDownloadFolder . ' ' . realpath($this->stripdownFolder) . '/*');

        echo "\t\tDone.\n";
    }

    function cleanup()
    {
        echo "\t> Cleanup.\n";

        $this->deleteFolder($this->stripdownFolder);

        echo "\t\tDone.\n";
    }

    function getFilesize($file)
    {
        $size = filesize($file);
        $sizeMb = floatval($size) / pow(1024, 2);
        return str_replace(".", ",", strval(round($sizeMb, 2)));
    }

    function goodbye()
    {
        echo "\t> Stripdown finished.\n";

        $size = $this->getFilesize($this->componentZipFileInDownloadFolder);

        echo "\t\tFilesize after Stripdown: " . $size . " MB\n";
    }

    function zipcmd()
    {
        return (DS === '/') ? '7a' : __DIR__ . '\7zip\x64\7za.exe';
    }

    function upxcmd()
    {
        $upx = getcwd() . '/bin/upx/upx.exe';
        return (DS === '/') ? ('wine cmd.exe /c ' . $upx) : $upx;
    }

    function movecmd()
    {
        return (DS === '/') ? 'sudo mv ' : 'mv ';
    }
}
