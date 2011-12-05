<?php
# common bootstrap file with constants, etc.
include __DIR__ . '/php/bootstrap.php';
include WPNXM_TEMPLATE . 'header.php';

# Functions to display Projects and Tools directories
include WPNXM_PHP_DIR . 'projects.php'; 
$projects = new Projects();
?>

        <div class="left-box">    
            <div class="cs-message">        
                <!-- Widget: Projects (scanned project paths / www folder) -->
                <div class="cs-message-content">
                    <h2>Projects (<?=$projects->getNumberOfProjects();?>)</h2>
                    <?php $projects->listProjects();?>
                </div>
            </div>
        </div>

        <div class="right-box"> 
            <div class="cs-message">  
                <!-- Widget: Tools (selected set of paths / www folder) -->
                <div class="cs-message-content">
                    <h2>Tools (<?= $projects->getNumberOfTools(); ?>)</h2>
                    <?=$projects->listTools();?>
                </div>         
            </div>    
        </div>

<?php include WPNXM_TEMPLATE . 'footer.php'; ?>