<?php
   /**
    * WPИ-XM Server Stack - Webinterface
    * Jens-André Koch © 2010 - onwards
    * http://wpn-xm.org/
    *
    *        _\|/_
    *        (o o)
    +-----oOO-{_}-OOo------------------------------------------------------------------+
    |                                                                                  |
    |    LICENSE                                                                       |
    |                                                                                  |
    |    WPИ-XM Serverstack is free software; you can redistribute it and/or modify    |
    |    it under the terms of the GNU General Public License as published by          |
    |    the Free Software Foundation; either version 2 of the License, or             |
    |    (at your option) any later version.                                           |
    |                                                                                  |
    |    WPИ-XM Serverstack is distributed in the hope that it will be useful,         |
    |    but WITHOUT ANY WARRANTY; without even the implied warranty of                |
    |    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the                 |
    |    GNU General Public License for more details.                                  |
    |                                                                                  |
    |    You should have received a copy of the GNU General Public License             |
    |    along with this program; if not, write to the Free Software                   |
    |    Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA    |
    |                                                                                  |
    +----------------------------------------------------------------------------------+
    *
    * @license    GNU/GPL v2 or (at your option) any later version..
    * @author     Jens-André Koch <jakoch@web.de>
    * @copyright  Jens-André Koch (2010 - 2012)
    * @link       http://wpn-xm.org/
    */

// common WPN-XM bootstrap file with constants, etc.
include __DIR__ . '/php/bootstrap.php';
// additional constant, telling header.php to load jquery and plugins
define('LOAD_JQUERY', 1);
include WPNXM_TEMPLATE . 'header.php';
include WPNXM_PHP_DIR . 'serverstack.php';
?>

<script>
function setupTreeTable() {
  // Apply some configuration settings
  $("table#treeTable").treeTable({
    clickableNodeNames: true
  });

  // Make visible that a row is clicked
  $("table#treeTable tbody tr").mousedown(function () {
    $("tr.selected").removeClass("selected"); // Deselect currently selected rows
    $(this).addClass("selected");
  });

  // Make row selected, when span is clicked
  $("table#treeTable tbody tr span").mousedown(function () {
    $($(this).parents("tr")[0]).trigger("mousedown");
  });
}

function setupjEditable() {
  $('.editable').editable(submitEdit, {
         indicator : 'Saving...',
         tooltip   : 'Click to edit...'
     });
  $('.edit_area').editable(submitEdit, {
         type      : 'textarea',
         cancel    : 'Cancel',
         submit    : 'OK',
         indicator : '<img src="img/ajax-spinner.gif">',
         tooltip   : 'Click to edit..' //<img src="img/pencil.png">
     });
}

function submitEdit(value, settings) {
  var edits = new Object();
  var origvalue = this.revert;
  var textbox = this;
  var result = value;

  // ok, we have the value, but not the "name of the directive".
  // therefore let's fetch the html value of the first td tag from the row,
  // which we are currently editing the value of (in the second td).
  var directive = $('td:first', $(this).parents('tr')).html();

  //console.log(edits);
  //alert("You changed the setting "+ directive +" to the value "+ value +".");

  // build array for sending data as json
  edits['directive'] = directive;
  edits['value'] = value;

  var returned = $.ajax({
      //url: 'configtabs.php?tab=php', // @todo set tab dynamically. the content posted is from the "current active tab"
      url: 'configtabs.php?action=save-phpini-setting',
      type: "POST",
      data : edits,
      dataType : "json",
      complete: function(xhr, textStatus) {
          var response = xhr.responseText;
      }
  });
  return(result);
};

function loadTab(tabObj) {

  if (!tabObj || !tabObj.length) {
    return;
  }

  // get the page from the href
  var href = tabObj.attr('href');   // href="configtabs.php?tab=home"
  var page = href.split('=')[1].toLowerCase(); // [configtabs.php?tab=, home], return 1st element from array

  // target content for the incoming content
  var containerId = 'div#tab-content';  // selector for the target container

  // load content via ajax, load additional js for certain pages and "activate" it
  $(containerId).load(href, function () {
    if (page === 'php') {
      setupTreeTable();
      setupjEditable();
    }
    $(containerId).fadeIn('fast');
  });
}

function setupTabs() {
  // define selectors
  var tabsNavigation = 'div#organic-tabs > ul.nav';
  var activeTab = tabsNavigation + ' li a.current';

  // load the first tab on page load (current active tab)
  if ($(activeTab).length > 0) {
    loadTab($(activeTab));
  }

  // intercept clicks on the tab items
  $(tabsNavigation + ' li a').click(function () {

      // do not reload content of current tab
      if ($(this).hasClass('current')) {
        return false;
      }
      // switch current to the new tab
      $(tabsNavigation + ' li a.current').removeClass('current');
      $(this).addClass('current');

      // show ajax loading indicator
      $('div#tab-content').html('<p style="text-align: center;"><img src="img/ajax-spinner.gif" width="64" height="64" /></p>');

      // load content
      loadTab($(this));

      return false;
  });
}

function handleRedirectToTab() {
  var anchor = window.location.href.split('#')[1];
  if (anchor != '') {
        var tabToSelect = $('#organic-tabs').find('a[name="'+anchor+'"]');
        $(tabToSelect).trigger('click');
  }
}

$(function () {
  setupTabs();
  handleRedirectToTab();
});
</script>

<h2 class="heading">Configuration</h2>

<div class="left-box">
    <div class="cs-message">
        <div class="cs-message-content" style="width: auto; height: auto; padding-top: 40px;">

            <div id="organic-tabs">

                <ul class="nav headings-level-1">
                  <li><a name="help" href="configtabs.php?tab=help" class="current">Help</a></li>
                  <li><a name="php" href="configtabs.php?tab=php">PHP</a></li>
                  <li><a name="php-ext" href="configtabs.php?tab=php-ext">PHP Extensions</a></li>
                  <li><a name="nginx" href="configtabs.php?tab=nginx">NGINX</a></li>
                  <li><a name="nginx-vhosts" href="configtabs.php?tab=nginx-vhosts">NGINX vHosts</a></li>
                  <li><a name="mariadb" href="configtabs.php?tab=mariadb">MariaDB</a></li>
                </ul>

                <div id="tab-content"></div>

            </div>

          </div>
    </div>
</div>

</div>

<?php include WPNXM_TEMPLATE . 'footer.php'; ?>