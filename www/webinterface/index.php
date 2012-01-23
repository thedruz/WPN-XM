<?php
# common bootstrap file with constants, etc.
include __DIR__ . '/php/bootstrap.php';
include WPNXM_TEMPLATE . 'header.php';

# Functions to display Projects and Tools directories
include WPNXM_PHP_DIR . 'projects.php';
$projects = new Projects();
?>

     <h2 class="heading">Projects and Tools</h2>

        <div class="left-box">
            <div class="cs-message">
                <div class="cs-message-content">
                    <h2>Projects (<?php echo $projects->getNumberOfProjects(); ?>)</h2>
                    <?php $projects->listProjects(); ?>
                </div>
            </div>
        </div>

        <div class="right-box">
            <div class="cs-message">
                <div class="cs-message-content">
                    <h2>Tools (<?php echo $projects->getNumberOfTools(); ?>)</h2>
                    <?php $projects->listTools(); ?>
                </div>
            </div>
        </div>

<?php include WPNXM_TEMPLATE . 'footer.php'; ?>