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

// QT includes
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
#include <QPlastiqueStyle>
//#include <QDebug>

// WPN-XM SCP includes
#include "tray.h"
#include "hostmanager/hostmanagerdialog.h"

// ShellExecute() used by openFileWithDefaultHandler() needs Windows API
#include "qt_windows.h"
#include "qwindowdefs_win.h"
#include <shellapi.h>

// Constructor
Tray::Tray(QApplication *parent) : QSystemTrayIcon(parent)
{
    // Tray Icon
    setIcon(QIcon(":/wpnxm"));
    // @todo append to tooltip the status of the daemons
    setToolTip("WPN-XM");

    initializeConfiguration();

    createTrayIcon();

    // the timer is used for monitoring the process state of each daemon
    timer = new QTimer(this);
    timer->setInterval(1000); // msec = 1sec

    processNginx = new QProcess(this);
    processNginx->setWorkingDirectory(cfgNginxDir);
    connect(processNginx, SIGNAL(stateChanged(QProcess::ProcessState)), this, SLOT(nginxStateChanged(QProcess::ProcessState)));
    connect(processNginx, SIGNAL(error(QProcess::ProcessError)), this, SLOT(nginxProcessError(QProcess::ProcessError)));

    processPhp = new QProcess(this);
    processPhp->setWorkingDirectory(cfgPhpDir);
    connect(processPhp, SIGNAL(stateChanged(QProcess::ProcessState)), this, SLOT(phpStateChanged(QProcess::ProcessState)));
    connect(processPhp, SIGNAL(error(QProcess::ProcessError)), this, SLOT(phpProcessError(QProcess::ProcessError)));

    processMySql = new QProcess(this);
    processMySql->setWorkingDirectory(cfgMySqlDir);
    connect(processMySql, SIGNAL(stateChanged(QProcess::ProcessState)), this, SLOT(mysqlStateChanged(QProcess::ProcessState)));
    connect(processMySql, SIGNAL(error(QProcess::ProcessError)), this, SLOT(mysqlProcessError(QProcess::ProcessError)));

    // @todo make this a configuration option in user preference dialog
    if(bAutostartDaemons)
    {
        runAll();
    }
}

// Destructor
Tray::~Tray()
{
    // @todo stop all daemons, when you quit the tray application? add option to configure dialog
    stopAll();
    processNginx->waitForFinished();
    processPhp->waitForFinished();
    processMySql->waitForFinished();
    delete MainMenu;
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
    cfgPhpExec              = globalSettings.value("php/exec", "/php-cgi.exe").toString();
    cfgPhpConfig            = globalSettings.value("php/config", "./bin/php/php.ini").toString();
    cfgPhpFastCgiHost       = globalSettings.value("php/fastcgi-bindaddress", "localhost").toString();
    cfgPhpFastCgiPort       = globalSettings.value("php/fastcgi-bindport", "9000").toString();

    cfgNginxDir             = globalSettings.value("path/nginx", "./bin/nginx").toString();
    cfgNginxExec            = globalSettings.value("nginx/exec", "/nginx.exe").toString();    
    cfgNginxConfig          = globalSettings.value("nginx/config", "./bin/nginx/conf/nginx.conf").toString();
    cfgNginxSites           = globalSettings.value("nginx/sites", "/www").toString();

    cfgMySqlDir             = globalSettings.value("path/mysql", "./bin/mariadb/bin").toString();
    cfgMySqlExec            = globalSettings.value("mysql/exec", "/mysqld.exe").toString();
    cfgMySqlConfig          = globalSettings.value("mysql/config", "./bin/mariadb/my.ini").toString();
    cfgMySqlClientExec      = globalSettings.value("mysql/clientExec", "./bin/mariadb/bin/mysql.exe").toString();

    //cfgMySqlWorkbenchDir    = globalSettings.value("path/mysqlworkbench", "./bin/mysqlworkbench").toString();
    //cfgMySqlWorkbenchExec   = globalSettings.value("mysqlworkbench/exec", "/MySQLWorkbench.exe").toString();
}

void Tray::createTrayIcon()
{
    MainMenu = new QMenu();
    //MainMenu->setStyle(new QPlastiqueStyle);

    // Nginx
    nginxStatusSubmenu = new QMenu("Nginx", MainMenu);
    nginxStatusSubmenu->setIcon(QIcon(":/status_stop"));
    nginxStatusSubmenu->addAction(QIcon(":/action_reload"), tr("Reload"), this, SLOT(reloadNginx()), QKeySequence());
    nginxStatusSubmenu->addSeparator();
    nginxStatusSubmenu->addAction(QIcon(":/action_restart"), tr("Restart"), this, SLOT(restartNginx()), QKeySequence());
    nginxStatusSubmenu->addSeparator();
    nginxStatusSubmenu->addAction(QIcon(":/action_run"), tr("Start"), this, SLOT(runNginx()), QKeySequence());
    nginxStatusSubmenu->addAction(QIcon(":/action_stop"), tr("Stop"), this, SLOT(stopNginx()), QKeySequence());

//    QMenu* nginxConfigSubmenu = new QMenu("NGINX config", MainMenu);
//    nginxConfigSubmenu->setIcon(QIcon(":/nginx"));
//    nginxConfigSubmenu->addAction(tr("Open site folder"), this, SLOT(openNginxSite()), QKeySequence());
//    nginxConfigSubmenu->addSeparator();
//    nginxConfigSubmenu->addAction(tr("Open configuration folder"), this, SLOT(openNginxConfig()), QKeySequence());
//    nginxConfigSubmenu->addAction(tr("Open log folder"), this, SLOT(openNginxLogs()), QKeySequence());

    // PHP
    phpStatusSubmenu = new QMenu("PHP", MainMenu);
    phpStatusSubmenu->setIcon(QIcon(":/status_stop"));
    phpStatusSubmenu->addAction(QIcon(":/action_restart"), tr("Restart"), this, SLOT(restartPhp()), QKeySequence());
    phpStatusSubmenu->addSeparator();
    phpStatusSubmenu->addAction(QIcon(":/action_run"), tr("Start"), this, SLOT(runPhp()), QKeySequence());
    phpStatusSubmenu->addAction(QIcon(":/action_stop"), tr("Stop"), this, SLOT(stopPhp()), QKeySequence());

//    QMenu* phpConfigSubmenu = new QMenu("PHP Config", MainMenu);
//    phpConfigSubmenu->setIcon(QIcon(":/php"));
//    phpConfigSubmenu->addAction("Open php config", this, SLOT(openPhpConfig()), QKeySequence());

    // MySQL
    mysqlStatusSubmenu = new QMenu("MariaDb", MainMenu);
    mysqlStatusSubmenu->setIcon(QIcon(":/status_stop"));
    mysqlStatusSubmenu->addAction(QIcon(":/action_restart"), tr("Restart"), this, SLOT(restartMySQL()), QKeySequence());
    mysqlStatusSubmenu->addSeparator();
    mysqlStatusSubmenu->addAction(QIcon(":/action_run"), tr("Start"), this, SLOT(runMySQL()), QKeySequence());
    mysqlStatusSubmenu->addAction(QIcon(":/action_stop"), tr("Stop"), this, SLOT(stopMySQL()), QKeySequence());

    //QMenu* mysqlConfigSubmenu = new QMenu("MySql Config", MainMenu);
    //mysqlConfigSubmenu->setIcon(QIcon(":/mysql"));
    //mysqlConfigSubmenu->addAction(QIcon(":/mysqlworkbench"), tr("Open MySQL workbench"), this, SLOT(openMySqlWorkbench()), QKeySequence());
    //mysqlConfigSubmenu->addAction(QIcon(":/cmd"), tr("Open MySQL client"), this, SLOT(openMySqlClient()), QKeySequence());
    //mysqlConfigSubmenu->addSeparator();
    //mysqlConfigSubmenu->addAction(tr("Open mysql config"), this, SLOT(openMySqlConfig()), QKeySequence());

    //QUrl url(SUPPORT_URL);
    //QDesktopServices::openUrl(url);
    // QDesktopServices::openUrl(QUrl("file:///C:/Documents and Settings/All Users/Desktop", QUrl::TolerantMode));

    // Build main menu
    MainMenu->addAction(QIcon(":/action_run"), tr("Start All"), this, SLOT(runAll()), QKeySequence());
    MainMenu->addAction(QIcon(":/action_stop"), tr("Stop All"), this, SLOT(stopAll()), QKeySequence());
    MainMenu->addSeparator();
    MainMenu->addMenu(nginxStatusSubmenu);
    MainMenu->addMenu(phpStatusSubmenu);
    MainMenu->addMenu(mysqlStatusSubmenu);
    MainMenu->addSeparator();
    MainMenu->addAction(QIcon(":/gear"), tr("Manage Hosts"), this, SLOT(openHostManagerDialog()), QKeySequence());
    //MainMenu->addMenu(nginxConfigSubmenu);
    //MainMenu->addMenu(phpConfigSubmenu);
    //MainMenu->addMenu(mysqlConfigSubmenu);
    MainMenu->addSeparator();
    MainMenu->addAction(QIcon(":/report_bug"), tr("&Report Bug"), this, SLOT(goToReportIssue()), QKeySequence());
    MainMenu->addAction(QIcon(":/help"),tr("&Help"), this, SLOT(goToWebsiteHelp()), QKeySequence());
    MainMenu->addAction(QIcon(":/quit"),tr("&Quit"), qApp, SLOT(quit()), QKeySequence());
    setContextMenu(MainMenu);
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
void Tray::runAll()
{
    runNginx();
    runPhp();
    runMySQL();
}

void Tray::stopAll()
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
void Tray::runNginx()
{
    if(processNginx->state() != QProcess::NotRunning)
    {
        QMessageBox::warning(0, tr("Nginx"), tr("Nginx already running."));
        return;
    }
    processNginx->start(cfgNginxDir+cfgNginxExec);
}

void Tray::stopNginx()
{
    QProcess processStopNginx;
    processStopNginx.setWorkingDirectory(cfgNginxDir);
    processStopNginx.start(cfgNginxDir+cfgNginxExec, QStringList() << "-s" << "stop");
    processStopNginx.waitForFinished();
}

void Tray::reloadNginx()
{
    QProcess processStopNginx;
    processStopNginx.setWorkingDirectory(cfgNginxDir);
    processStopNginx.start(cfgNginxDir+cfgNginxExec, QStringList() << "-s" << "reload");
    processStopNginx.waitForFinished();
}

void Tray::restartNginx()
{
    stopNginx();
    runNginx();
}

/*
 * PHP - Actions: run, stop, restart
 */
void Tray::runPhp()
{
    if(processPhp->state() != QProcess::NotRunning)
    {
        QMessageBox::warning(0, tr("PHP"), tr("PHP is already running."));
        return;
    }
    processPhp->start(cfgPhpDir+cfgPhpExec, QStringList() << "-b" << cfgPhpFastCgiHost+":"+cfgPhpFastCgiPort);
}

void Tray::stopPhp()
{
    processPhp->kill();
    processPhp->waitForFinished();
}

void Tray::restartPhp()
{
    stopPhp();
    runPhp();
}

/*
 * MySql Actions - run, stop, restart
 */
void Tray::runMySQL()
{
    if(processMySql->state() != QProcess::NotRunning){
        QMessageBox::warning(0, tr("MySQL"), tr("MySQL already running."));
        return;
    }
    QDir dir(QDir::currentPath());
    QString strDir = QDir::toNativeSeparators(dir.absoluteFilePath(cfgMySqlDir));
    processMySql->start(cfgMySqlDir+cfgMySqlExec, QStringList() << "--basedir="+strDir);
}

void Tray::stopMySQL()
{    
    processMySql->kill();
    processMySql->waitForFinished();
}

void Tray::restartMySQL()
{
    stopMySQL();
    runMySQL();
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
    QProcess::startDetached(cfgMySqlDir+cfgMySqlClientExec, QStringList(), cfgMySqlDir);
}

void Tray::openMySqlWorkbench()
{
    QProcess::startDetached(cfgMySqlWorkbenchDir+cfgMySqlWorkbenchExec, QStringList(), cfgMySqlWorkbenchDir);
}

void Tray::openMySqlConfig()
{
    QDir dir(QDir::currentPath());
    QString strDir = QDir::toNativeSeparators(dir.absoluteFilePath(cfgMySqlConfig));
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
            break;
        case QProcess::Running:
            nginxStatusSubmenu->setIcon(QIcon(":/status_run"));
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
            break;
        case QProcess::Running:
            phpStatusSubmenu->setIcon(QIcon(":/status_run"));
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
            break;
        case QProcess::Running:
            mysqlStatusSubmenu->setIcon(QIcon(":/status_run"));
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
}
