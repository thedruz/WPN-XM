/*
    WPN-XM Server Control Panel

    WPN-XM SCP is a tool to manage Nginx, PHP and MariaDb daemons under windows.
    It's a fork of Easy WEMP originally written by Yann Le Moigne and (c) 2010.
    WPN-XM SCP is written by Jens-Andre Koch and (c) 2011 - onwards.
        
    This file is part of WPN-XM Serverpack for Windows.

    WPN-XM SCP is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    WPN-XM SCP is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with WPN-XM SCP. If not, see <http://www.gnu.org/licenses/>.
*/

// Local WPN-XM SCP includes
#include "tray.h"
#include "hostmanager/hostmanagerdialog.h"

// Global QT includes
#include <QApplication>
#include <QMenu>
#include <QAction>
#include <QPushButton>
#include <QWidgetAction>
#include <QMessageBox>
#include <QSettings>
#include <QDir>
#include <QTimer>
#include <QDesktopServices>
#include <QUrl>
//#include <QDebug>

// Global ShellExecute() used by openFileWithDefaultHandler() needs Windows API
//#include "qt_windows.h"
//#include "qwindowdefs_win.h"
//#include <shellapi.h>

// Constructor
Tray::Tray(QApplication *parent) : QSystemTrayIcon(parent)
{
    // Tray Icon
    setIcon(QIcon(":/wpnxm"));

    // @todo append status of the daemons to tooltip
    // or create seperate popup?
    setToolTip("WPN-XM");

    initializeConfiguration();

    createTrayMenu();

    // the timer is used for monitoring the process state of each daemon
    timer = new QTimer(this);
    timer->setInterval(1000); // msec = 1sec

    startMonitoringDaemonProcesses();

    // @todo make this a configuration option in user preferences dialog
    if(bAutostartDaemons)
    {
        startAllDaemons();
    }

    /* Auto-connect Slots
       The following definition isneeded:
                void on_<object name>_<signal name>(<signal parameters>);
       like:    private slots: void on_okButton_clicked();
                or  void on_xy_triggered();
    */
    // QMetaObject::connectSlotsByName(this);
}

// Destructor
Tray::~Tray()
{
    // @todo stop all daemons, when you quit the tray application?
    // add option to configure dialog
    stopAllDaemons();

    delete trayMenu;
}

void Tray::startMonitoringDaemonProcesses()
{
    processNginx = new QProcess(this);
    processNginx->setWorkingDirectory(cfgNginxDir);
    connect(processNginx, SIGNAL(stateChanged(QProcess::ProcessState)), this, SLOT(nginxStateChanged(QProcess::ProcessState)));
    connect(processNginx, SIGNAL(error(QProcess::ProcessError)), this, SLOT(nginxProcessError(QProcess::ProcessError)));

    processPhp = new QProcess(this);
    processPhp->setWorkingDirectory(cfgPhpDir);
    connect(processPhp, SIGNAL(stateChanged(QProcess::ProcessState)), this, SLOT(phpStateChanged(QProcess::ProcessState)));
    connect(processPhp, SIGNAL(error(QProcess::ProcessError)), this, SLOT(phpProcessError(QProcess::ProcessError)));

    processMySql = new QProcess(this);
    processMySql->setWorkingDirectory(cfgMariaDBDir);
    connect(processMySql, SIGNAL(stateChanged(QProcess::ProcessState)), this, SLOT(mysqlStateChanged(QProcess::ProcessState)));
    connect(processMySql, SIGNAL(error(QProcess::ProcessError)), this, SLOT(mysqlProcessError(QProcess::ProcessError)));
}

void Tray::initializeConfiguration()
{
    // if the cfg file doesn't already exist, it is created
    QSettings globalSettings("wpnxm.ini", QSettings::IniFormat, this);

    // check if reading settings was successful
    if(globalSettings.status() != QSettings::NoError)
    {
        QMessageBox::critical(0, tr("Settings"), tr("Can't read settings."));
        exit(1);
    }

    /*
     * Declation of Default Settings for WPN-XM Server Control Panel
     */
    bAutostartDaemons       = globalSettings.value("global/autostartdaemons", true).toBool();
    cfgLogsDir              = globalSettings.value("path/logs", "/logs").toString();

    cfgPhpDir               = globalSettings.value("path/php", "./bin/php").toString();
    cfgPhpConfig            = globalSettings.value("php/config", "./bin/php/php.ini").toString();
    cfgPhpFastCgiHost       = globalSettings.value("php/fastcgi-host", "localhost").toString();
    cfgPhpFastCgiPort       = globalSettings.value("php/fastcgi-port", "9000").toString();

    cfgNginxDir             = globalSettings.value("path/nginx", "./bin/nginx").toString();   
    cfgNginxConfig          = globalSettings.value("nginx/config", "./bin/nginx/conf/nginx.conf").toString();
    cfgNginxSites           = globalSettings.value("nginx/sites", "/www").toString();

    cfgMariaDBDir           = globalSettings.value("path/mysql", "./bin/mariadb/bin").toString();
    cfgMariaDBConfig        = globalSettings.value("mysql/config", "./bin/mariadb/my.ini").toString();
}

void Tray::createTrayMenu()
{
    QMenu *trayMenu = contextMenu();

    if (trayMenu) {
        trayMenu->clear();
    } else {
        trayMenu = new QMenu;
        setContextMenu(trayMenu);
    }

    // Nginx
    nginxStatusSubmenu = new QMenu("Nginx", trayMenu);
    nginxStatusSubmenu->setIcon(QIcon(":/status_stop"));
    nginxStatusSubmenu->addAction(QIcon(":/action_reload"), tr("Reload"), this, SLOT(reloadNginx()), QKeySequence());
    nginxStatusSubmenu->addSeparator();
    nginxStatusSubmenu->addAction(QIcon(":/action_restart"), tr("Restart"), this, SLOT(restartNginx()), QKeySequence());
    nginxStatusSubmenu->addSeparator();
    nginxStatusSubmenu->addAction(QIcon(":/action_run"), tr("Start"), this, SLOT(startNginx()), QKeySequence());
    nginxStatusSubmenu->addAction(QIcon(":/action_stop"), tr("Stop"), this, SLOT(stopNginx()), QKeySequence());

    // PHP
    phpStatusSubmenu = new QMenu("PHP", trayMenu);
    phpStatusSubmenu->setIcon(QIcon(":/status_stop"));
    phpStatusSubmenu->addAction(QIcon(":/action_restart"), tr("Restart"), this, SLOT(restartPhp()), QKeySequence());
    phpStatusSubmenu->addSeparator();
    phpStatusSubmenu->addAction(QIcon(":/action_run"), tr("Start"), this, SLOT(startPhp()), QKeySequence());
    phpStatusSubmenu->addAction(QIcon(":/action_stop"), tr("Stop"), this, SLOT(stopPhp()), QKeySequence());

    // MySQL
    mysqlStatusSubmenu = new QMenu("MariaDb", trayMenu);
    mysqlStatusSubmenu->setIcon(QIcon(":/status_stop"));
    mysqlStatusSubmenu->addAction(QIcon(":/action_restart"), tr("Restart"), this, SLOT(restartMySQL()), QKeySequence());
    mysqlStatusSubmenu->addSeparator();
    mysqlStatusSubmenu->addAction(QIcon(":/action_run"), tr("Start"), this, SLOT(startMySQL()), QKeySequence());
    mysqlStatusSubmenu->addAction(QIcon(":/action_stop"), tr("Stop"), this, SLOT(stopMySQL()), QKeySequence());

    // Build Tray Menu

    // add title entry like for WPN-XM in KVirc style (background gray, bold, small font)
    // trayMenu->addAction("WPN-XM SCP")->setFont(QFont("Arial", 8, QFont::Bold));

    trayMenu->addAction(QIcon(":/action_run"), tr("Start All"), this, SLOT(startAllDaemons()), QKeySequence());
    trayMenu->addAction(QIcon(":/action_stop"), tr("Stop All"), this, SLOT(stopAllDaemons()), QKeySequence());
    trayMenu->addSeparator();
    trayMenu->addMenu(nginxStatusSubmenu);
    trayMenu->addMenu(phpStatusSubmenu);
    trayMenu->addMenu(mysqlStatusSubmenu);
    trayMenu->addSeparator();
    trayMenu->addAction(QIcon(":/gear"), tr("Manage Hosts"), this, SLOT(openHostManagerDialog()), QKeySequence());
    trayMenu->addSeparator();
    trayMenu->addAction(QIcon(":/report_bug"), tr("&Report Bug"), this, SLOT(goToReportIssue()), QKeySequence());
    trayMenu->addAction(QIcon(":/question"),tr("&Help"), this, SLOT(goToWebsiteHelp()), QKeySequence());
    trayMenu->addAction(QIcon(":/quit"),tr("&Quit"), qApp, SLOT(quit()), QKeySequence());
    setContextMenu(trayMenu);
}

void Tray::goToWebsiteHelp()
{
    QDesktopServices::openUrl(QUrl("http://wpn-xm.org/"));
}

void Tray::goToReportIssue()
{
    QDesktopServices::openUrl(QUrl("https://github.com/jakoch/WPN-XM/issues/"));
}

//*
//* Action slots
//*
void Tray::startAllDaemons()
{
    startNginx();
    startPhp();
    startMySQL();
}

void Tray::stopAllDaemons()
{
    stopMySQL();
    stopPhp();
    stopNginx();
}

void Tray::restartAll()
{
    restartNginx();
    restartPhp();
    restartMySQL();
}

/*
 * Nginx - Actions: run, stop, restart
 */
void Tray::startNginx()
{
    // already running
    if(processNginx->state() != QProcess::NotRunning)
    {
        QMessageBox::warning(0, tr("Nginx"), tr("Nginx already running."));
        return;
    }

    // start daemon
    processNginx->start(cfgNginxDir+NGINX_EXEC);
}

void Tray::stopNginx()
{
    QProcess processStopNginx;
    processStopNginx.setWorkingDirectory(cfgNginxDir);
    processStopNginx.start(cfgNginxDir+NGINX_EXEC, QStringList() << "-s" << "stop");
    processStopNginx.waitForFinished();
}

void Tray::reloadNginx()
{
    QProcess processStopNginx;
    processStopNginx.setWorkingDirectory(cfgNginxDir);
    processStopNginx.start(cfgNginxDir+NGINX_EXEC, QStringList() << "-s" << "reload");
    processStopNginx.waitForFinished();
}

void Tray::restartNginx()
{
    stopNginx();
    startNginx();
}

/*
 * PHP - Actions: run, stop, restart
 */
void Tray::startPhp()
{
    // already running
    if(processPhp->state() != QProcess::NotRunning)
    {
        QMessageBox::warning(0, tr("PHP"), tr("PHP is already running."));
        return;
    }

    // start daemon
    processPhp->start(cfgPhpDir+PHPCGI_EXEC, QStringList() << "-b" << cfgPhpFastCgiHost+":"+cfgPhpFastCgiPort);

    emit signalSetLabelStatusActive("nginx", true);
}

void Tray::stopPhp()
{
    // 1) processPhp->terminate(); will fail because WM_CLOSE message not handled
    // 2) By killing the process, we are crashing it!
    //    The user will get a "Process Crashed" Error MessageBox.
    //    Therefore we need to disconnect signal/sender from method/receiver.
    //    The result is, that crashing the php daemon intentionally is not shown as error.
    disconnect(processPhp, SIGNAL(error(QProcess::ProcessError)), this, SLOT(phpProcessError(QProcess::ProcessError)));

    // kill PHP daemon
    processPhp->kill();
    processPhp->waitForFinished();
}

void Tray::restartPhp()
{
    stopPhp();
    startPhp();
}

/*
 * MySql Actions - run, stop, restart
 */
void Tray::startMySQL()
{
    // already running
    if(processMySql->state() != QProcess::NotRunning){
        QMessageBox::warning(0, tr("MySQL"), tr("MySQL already running."));
        return;
    }

    // start
    QDir dir(QDir::currentPath());
    QString strDir = QDir::toNativeSeparators(dir.absoluteFilePath(cfgMariaDBDir));
    processMySql->start(cfgMariaDBDir+MARIADB_EXEC, QStringList() << "--basedir="+strDir);
}

void Tray::stopMySQL()
{    
    processMySql->kill();
    processMySql->waitForFinished();
}

void Tray::restartMySQL()
{
    stopMySQL();
    startMySQL();
}

/*
 * Config slots
 */
void Tray::openHostManagerDialog()
{
    HostsManagerDialog dlg;
    dlg.exec();
}

void Tray::openAboutDialog()
{
    //AboutDialog dlg;
    //dlg.exec();
}

void Tray::openConfigurationDialog()
{
    //ConfigDialog dlg;
    //dlg.exec();
}

void Tray::openNginxSite()
{
    QDir dir(QDir::currentPath());
    QString strDir = QDir::toNativeSeparators(dir.absoluteFilePath(cfgNginxDir+cfgNginxSites));

    // start as own process ( not as a child process), will live after Tray terminates
    QProcess::startDetached("explorer", QStringList() << strDir);
}

void Tray::openNginxConfig(){
    QDir dir(QDir::currentPath());
    QString strDir = QDir::toNativeSeparators(dir.absoluteFilePath(cfgNginxConfig));
    QProcess::startDetached("explorer", QStringList() << strDir);
}

void Tray::openNginxLogs()
{
    QDir dir(QDir::currentPath());
    QString strDir = QDir::toNativeSeparators(dir.absoluteFilePath(cfgLogsDir));
    QProcess::startDetached("explorer", QStringList() << strDir);
}

void Tray::openMySqlClient()
{
    QProcess::startDetached(cfgMariaDBDir+MARIADB_CLIENT_EXEC, QStringList(), cfgMariaDBDir);
}

void Tray::openMySqlConfig()
{
    QDir dir(QDir::currentPath());
    QString strDir = QDir::toNativeSeparators(dir.absoluteFilePath(cfgMariaDBConfig));
    QProcess::startDetached("cmd", QStringList() << "/c" << "start "+strDir);
}

void Tray::openPhpConfig()
{
    QDir dir(QDir::currentPath());
    QString strDir = QDir::toNativeSeparators(dir.absoluteFilePath(cfgPhpConfig));
    QProcess::startDetached("cmd", QStringList() << "/c" << "start "+strDir);
}

/*
 * State slots
 */
void Tray::globalStateChanged()
{
    QProcess::ProcessState stateNginx = QProcess::Running;
    QProcess::ProcessState statePhp = QProcess::Running;
    QProcess::ProcessState stateMySql = QProcess::Running;

    stateNginx = processNginx->state();
    statePhp = processPhp->state();
    stateMySql = processMySql->state();

    if(stateNginx==QProcess::Starting || statePhp==QProcess::Starting || stateMySql==QProcess::Starting)
    {
        timer->start();
    }
    else
    {
        timer->stop();
        setIcon(QIcon(":/wpnxm"));
    }

    return;
}

void Tray::nginxStateChanged(QProcess::ProcessState state)
{
    switch(state)
    {
        case QProcess::NotRunning:
            nginxStatusSubmenu->setIcon(QIcon(":/status_stop"));
            emit signalSetLabelStatusActive("nginx", false);
            break;
        case QProcess::Running:
            nginxStatusSubmenu->setIcon(QIcon(":/status_run"));
            emit signalSetLabelStatusActive("nginx", true);
            break;
        case QProcess::Starting:
            nginxStatusSubmenu->setIcon(QIcon(":/status_reload"));
            break;
    }
    globalStateChanged();
}

void Tray::phpStateChanged(QProcess::ProcessState state)
{
    switch(state)
    {
        case QProcess::NotRunning:
            phpStatusSubmenu->setIcon(QIcon(":/status_stop"));
            emit signalSetLabelStatusActive("php", false);
            break;
        case QProcess::Running:
            phpStatusSubmenu->setIcon(QIcon(":/status_run"));
            emit signalSetLabelStatusActive("php", true);
            break;
        case QProcess::Starting:
            phpStatusSubmenu->setIcon(QIcon(":/status_reload"));
            break;            
    }
    globalStateChanged();
}

void Tray::mysqlStateChanged(QProcess::ProcessState state)
{
    switch(state)
    {
        case QProcess::NotRunning:
            mysqlStatusSubmenu->setIcon(QIcon(":/status_stop"));
            emit signalSetLabelStatusActive("mariadb", false);
            break;
        case QProcess::Running:
            mysqlStatusSubmenu->setIcon(QIcon(":/status_run"));
            emit signalSetLabelStatusActive("mariadb", true);
            break;
        case QProcess::Starting:
            mysqlStatusSubmenu->setIcon(QIcon(":/status_reload"));
            break;
    }
    globalStateChanged();
}

/*
 * Error slots
 */
void Tray::nginxProcessError(QProcess::ProcessError error)
{
    QMessageBox::warning(0, APP_NAME " - Error", "Nginx Error. "+getProcessErrorMessage(error));
}

void Tray::phpProcessError(QProcess::ProcessError error)
{
    QMessageBox::warning(0, APP_NAME " - Error", "PHP Error. "+getProcessErrorMessage(error));
}

void Tray::mysqlProcessError(QProcess::ProcessError error)
{
    QMessageBox::warning(0, APP_NAME " - Error", "MySQL Error. "+getProcessErrorMessage(error));
}

QString Tray::getProcessErrorMessage(QProcess::ProcessError error){
    QString ret;
    switch(error){
        case QProcess::FailedToStart:
            ret = "The process failed to start. Either the invoked program is missing, or you may have insufficient permissions to invoke the program.";
            break;
        case QProcess::Crashed:
            ret = "The process crashed some time after starting successfully.";
            break;
        case QProcess::Timedout:
            ret = "The process timed out.";
            break;
        case QProcess::WriteError:
            ret = "An error occurred when attempting to write to the process. For example, the process may not be running, or it may have closed its input channel.";
            break;
        case QProcess::ReadError:
            ret = "An error occurred when attempting to read from the process. For example, the process may not be running.";
            break;
        case QProcess::UnknownError:
            ret = "An unknown error occurred.";
            break;
    }
    return ret;
}
/*
void Tray::openFileWithDefaultHandler( QString p_target_path )
{
    p_target_path = p_target_path.remove( "\"" );

    HINSTANCE result = ShellExecute( NULL, TEXT("open"), (LPCWSTR) p_target_path.utf16(), NULL, NULL, SW_SHOWNORMAL );

    QString error_string = "";

    int result_code = (int) result;

    switch( result_code )
    {
    case 0:
        error_string = "Your operating system is out of memory or resources.";
        break;
    case ERROR_FILE_NOT_FOUND:
        error_string = "The specified file was not found.";
        break;
    case ERROR_PATH_NOT_FOUND:
        error_string = "The specified path was not found.";
        break;
    case ERROR_BAD_FORMAT:
        error_string = "The .exe file is invalid (non-Win32 .exe or error in .exe image).";
        break;
    case SE_ERR_ACCESSDENIED:
        error_string = "Your operating system denied access to the specified file.";
        break;
    case SE_ERR_ASSOCINCOMPLETE:
        error_string = "The file name association is incomplete or invalid.";
        break;
    case SE_ERR_DDEBUSY:
        error_string = "The DDE transaction could not be completed because other DDE transactions were being processed.";
        break;
    case SE_ERR_DDEFAIL:
        error_string = "The DDE transaction failed.";
        break;
    case SE_ERR_DDETIMEOUT:
        error_string = "The DDE transaction could not be completed because the request timed out.";
        break;
    case SE_ERR_DLLNOTFOUND:
        error_string = "The specified DLL was not found.";
        break;
    case SE_ERR_NOASSOC:
        error_string = "There is no application associated with the given file name extension.\nThis error will also be returned if you attempt to print a file that is not printable.";
        break;
    case SE_ERR_OOM:
        error_string = "There was not enough memory to complete the operation.";
        break;
    case SE_ERR_SHARE:
        error_string = "A sharing violation occurred.";
        break;
    default:
        return;
    }

    QMessageBox::warning(0, APP_NAME " - Error", error_string );
}*/
