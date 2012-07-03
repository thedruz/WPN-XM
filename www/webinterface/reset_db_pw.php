<?php

/**
 * @author Tobias Fichtner <github@tobiasfichtner.com>
 */

include __DIR__ . '/php/bootstrap.php';

$action = filter_input(INPUT_GET, 'action', FILTER_SANITIZE_STRING);

if($action === 'show')
{
    $return = '
    <form id="reset-password-form" style="width:400px;" action="reset_db_pw.php?action=update" method="POST">
    <fieldset>
        <legend>Change Database Password</legend>
        <h3>Please enter the new database password (user root):</h3>
        <input type="text" name="newPassword">
        <br><br>
        <a class="aButton" rel="modal:close">Cancel</a>
        <a class="aButton" id="btn-change-password" rel="ajax:modal">Change Password</a>
        <div id="reset-pw-result"></div>
    </fieldset>
    </form>
    <script type="text/javascript" charset="utf-8">
        $(document).ready(function() {
             $(\'a[rel="ajax:modal"]\').click(function(event) {
                //xy.showSpinner();
              $.ajax({
                url: $(this).closest(\'form\').attr(\'action\'),
                method: $(this).closest(\'form\').attr(\'method\'),
                data: "newPassword=" + $(this).closest(\'form\').find(\'input[name="newPassword"]\').val(),
                dataType: \'html\',
                success: function(newHTML, textStatus, jqXHR) {
                  //xy.hideSpinner();
                  $(newHTML).appendTo(\'div#reset-pw-result\'); //.modal();
                },
                // ajax error
              });
              return false;
            });
        });
    </script>
    ';

    echo $return;
}

/**
 * Resets the MariaDB Password
 * 
 * The procedure is described in:
 * http://dev.mysql.com/doc/mysql-windows-excerpt/5.0/en/resetting-permissions-windows.html
 */
$newPassword = filter_input(INPUT_GET, 'newPassword', FILTER_SANITIZE_STRING);

if($action === "update" && !empty($newPassword))
{
     // commands
    $stop_mariadb = "taskkill /f /IM mysqld.exe 1>nul 2>nul";
    $mysqld_exe = WPNXM_DIR . 'bin\\tools\\runhiddenconsole.exe ' . WPNXM_DIR . "bin\\mariadb\\bin\\mysqld.exe";
    $start_mariadb_change_pw = $mysqld_exe . " --defaults-file=". WPNXM_DIR . 'bin\\mariadb\\my.ini --init-file=' . WPNXM_DIR . 'bin\\mariadb\\init_passwd_change.txt';
    $start_mariadb_normal = $mysqld_exe . " --defaults-file=". WPNXM_DIR . 'bin\\mariadb\\my.ini';

    // create the init-file with passwd update query
    file_put_contents( WPNXM_DIR . 'bin\\mariadb\\init_passwd_change.txt', "UPDATE mysql.user SET PASSWORD=PASSWORD('$newPassword') WHERE User='root';\nFLUSH PRIVILEGES;");

    // start mysqld again with init-file to change password
    exec($stop_mariadb);
    exec($start_mariadb_change_pw);
    sleep("5");

    exec($stop_mariadb);
    exec($start_mariadb_normal);
    sleep("3");

    unlink(WPNXM_DIR . 'bin\\mariadb\\init_passwd_change.txt');

    $connection = new mysqli("localhost", "root", $newPassword, "mysql");

    if(mysqli_connect_errno()) {
        $return = '<div class="error">Database Connection with new password FAILED.<br/>(MySQL ["' . mysqli_connect_errno() . '"]"' . mysqli_connect_error() . '")';
    }
    else {
        $return = '<div class="success">Password changed SUCCESSFULLY.';

        // write new password to wpnxm.ini
        include __DIR__ . '/php/phpini.php';
        $ini = new ini(WPNXM_INI);
        $ini->set('MariaDB', 'password', $newPassword);
        $ini->write();
    }

    $return .= '<br/><a class="aButton" rel="modal:close" href="#">Close</a></div>';

    echo $return;
}
?>