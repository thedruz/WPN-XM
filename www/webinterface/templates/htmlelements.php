<?php
class HtmlElements
{
    public static function renderMenu()
    {
        $menu = '<div class="main_menu">
                 <ul>
                    <li class="first 1"><a href="config.php">Configuration</a></li>
                    <li class="2"><a href="index.php">Projects & Tools</a></li>';

                $item_number = 2;

                // is phpmyadmin installed?
                if(is_dir(WPNXM_WWW_DIR.'phpmyadmin') === true)
                {
                    $item_number = $item_number + 1;
                    $menu .= '<li class="'.$item_number.'"><a href="'.WPNXM_ROOT.'phpmyadmin/">PHPMyAdmin</a></li>';
                }

                // is adminer installed?
                if(is_dir(WPNXM_WWW_DIR.'adminer') === true)
                {
                    $item_number = $item_number + 1;
                    $menu .= '<li class="'.$item_number.'"><a href="'.WPNXM_ROOT.'phpmyadmin/">Adminer</a></li>';
                }

                    $item_number = $item_number + 1;
        $menu .= '<li class="last '.$item_number.'"><a href="phpinfo.php">PHP Info</a></li>
                </ul>
             </div>';

        echo $menu;
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
