<?php
class HtmlElements
{
    public static function renderMenu()
    {
        echo '<div class="main_menu">
                <ul>
                    <li class="first 1"><a href="config.php">Configuration</a></li>
                    <li class="2"><a href="index.php">Projects & Tools</a></li>
                    <li class="3"><a href="phpinfo.php">PHP Info</a></li>
                    <li class="4"><a href="'.WPNXM_ROOT.'phpmyadmin/phpmyadmin.php">PHPMyAdmin</a></li>
                    <li class="5"><a href="/5/">5</a></li>
                    <li class="last 6"><a href="/PHP on Windows/">http://windows.php.net/downloads/</a></li>
                </ul>
            </div>';
    }

    public static function renderWelcome()
    {
        if(self::fileCounter(__DIR__ . '/welcomeMsgCounter.txt', 10) === true)
        {
            return;
        }
        else
        {
            echo '<h1>Welcome to the WPИ-XM server stack!</h1>';
        }
    }

    /**
     * Uses a file for counting the display of the welcome message.
     *
     * @param string $file The file containing the counter.
     * @param int $max_counts The number of times to return false.
     * @return boolean When the number of max_displays is reached, method will return true; else false;
     */
    public static function fileCounter($file, $max_counts)
    {
        $max_counts = (int) $max_counts;

        # file to write
        $file = (string) $file;

        # if file not existing, create and start counting with 1
        if(is_file($file) === false)
        {
            file_put_contents($file, 1);
        }
        else
        {
            # read file
            $current = file_get_contents($file);

            # comparison
            if($current == $max_counts)
            {
                return true;
            }

            # increase counter
            if($current < $max_counts)
            {
                $current++;
                file_put_contents($file, $current);
            }
        }

        return false;
    }
}
?>
