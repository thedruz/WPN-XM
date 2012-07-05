<h2>NGINX vHosts</h2>

<div class="floatleft">

    <h3>Hosts</h3>

    <table>
        <tr>
            <td>Vhost 1</td><td><input type="checkbox" checked="checked"></td></tr>
            <td>Vhost 2</td><td><input type="checkbox"></td></tr>
        </tr>
    </table>

</div>

<div class="floatright">

    <h3>Administrate</h3>

    <form>
    <ul id="form">
      <li>
        <label for="servername">Servername</label>
        <span class="help">Enter the servername.</span>
        <input type="text">
        <span class="example"><b>Example:</b><br/>LALA server</span>

        <label>Add to hosts file for local name resolution.</label><input type="checkbox">

        <!--<label>(Port)</label>-->

        <!--<label>(Dynamic DNS)</label>-->

        <label>Location (Realpath)</label>
        <select id="folder">
            <?php foreach ($project_folders as $folder) { ?>
            <option value="/<?=$folder?>"><?=$folder?></option>
            <?php } ?>
        </select>

        <label>Aliases - [+ Add Alias]</label>
        <table>
            <tr><td>Alias 1</td><td>-</td></tr>
            <tr><td>Alias 2</td><td>-</td></tr>
        </table>

      </li>
    </ul>
    </form>

</div>
