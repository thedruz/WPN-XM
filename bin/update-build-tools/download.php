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
 * Download Script for the Build Tools of the Server Stack.
 *
 * The download links are defined in the CSV file "build-tools.txt".
 */

$aria_cmd_template = "..\aria\aria2c.exe \"%url%\" --dir=%targetFolder% --out=%targetFile% --check-certificate=false"
                   . " --split=4 --min-split-size=1M --max-connection-per-server=4 --max-tries=3 --conditional-get=true"
                   . " --auto-file-renaming=false --allow-overwrite=true --http-accept-gzip=true"
                   . " --user-agent=\"WPN-XM Build Tools Updater\" ";

$urls = array_map('str_getcsv', file('build-tools.txt'));

foreach($urls as $component)
{
	$url          = $component[0];
	$targetFolder = ltrim($component[1]);
	$targetFile   = ltrim($component[2]);

	$aria_cmd = str_replace(
		array('%url%', '%targetFolder%', '%targetFile%'),
		array($url, $targetFolder, $targetFile),
		$aria_cmd_template
	);

	passthru($aria_cmd);
}