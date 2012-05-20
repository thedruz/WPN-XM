#include "mainwindow.h"
#include "ui_mainwindow.h"
#include "tray.h"

#include <QMessageBox>
#include <QSharedMemory>
#include <QtGui>
#include <QRegExp>
#include <QDesktopServices>
#include <QUrl>

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);

    // disable Maximize functionality
    setWindowFlags( (windowFlags() | Qt::CustomizeWindowHint) & ~Qt::WindowMaximizeButtonHint);
    //setFixedWidth(600);
    //setFixedHeight(270);

    // overrides the window title defined in mainwindow.ui
    setWindowTitle(APP_NAME_AND_VERSION);

    createActions();

    // The tray icon is an instance of the QSystemTrayIcon class.
    // To check whether a system tray is present on the user's desktop,
    // we call the static QSystemTrayIcon::isSystemTrayAvailable() function.
    if (false == QSystemTrayIcon::isSystemTrayAvailable())
    {
        QMessageBox::critical(0, APP_NAME, tr("You don't have a system tray."));
        //return 1;
    }
    else
    {
        // instantiate and attach the tray icon to the system tray
        trayIcon = new Tray(qApp);
        trayIcon->show();

        // handle clicks on the icon
        connect(trayIcon, SIGNAL(activated(QSystemTrayIcon::ActivationReason)),
                this, SLOT(iconActivated(QSystemTrayIcon::ActivationReason)));
    }

    parseVersionNumber("PHP 5.4.0 (cli) (built: Feb 29 2012 19:06:50)");
    getMariaVersion();
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::createActions()
 {
     minimizeAction = new QAction(tr("Mi&nimize"), this);
     connect(minimizeAction, SIGNAL(triggered()), this, SLOT(hide()));

     restoreAction = new QAction(tr("&Restore"), this);
     connect(restoreAction, SIGNAL(triggered()), this, SLOT(showNormal()));

     quitAction = new QAction(tr("&Quit"), this);
     // qApp is global pointer to QApplication
     connect(quitAction, SIGNAL(triggered()), qApp, SLOT(quit()));

     // PushButtons:: Website, ReportBug, Donate
     connect(ui->pushButton_Website, SIGNAL(clicked()), this, SLOT(goToWebsite()));
     connect(ui->pushButton_GoogleGroup, SIGNAL(clicked()), this, SLOT(goToGoogleGroup()));
     connect(ui->pushButton_ReportBug, SIGNAL(clicked()), this, SLOT(goToReportIssue()));
     connect(ui->pushButton_Donate, SIGNAL(clicked()), this, SLOT(goToDonate()));

     // PushButtons: Configuration, Help, About, Close
     connect(ui->pushButton_Configuration, SIGNAL(clicked()), this, SLOT(openConfigurationDialog()));
     connect(ui->pushButton_Help, SIGNAL(clicked()), this, SLOT(openHelpDialog()));
     connect(ui->pushButton_About, SIGNAL(clicked()), this, SLOT(openAboutDialog()));
     connect(ui->pushButton_Close, SIGNAL(clicked()), qApp, SLOT(quit()));

     // Actions - Start
     connect(ui->pushButton_StartNginx, SIGNAL(clicked()), trayIcon, SLOT(runNginx()));
     connect(ui->pushButton_StartPHP, SIGNAL(clicked()), trayIcon, SLOT(runPhp()));
     connect(ui->pushButton_StartMariaDb, SIGNAL(clicked()), trayIcon, SLOT(runMySQL()));

     // Actions - Stop
     connect(ui->pushButton_StopNginx, SIGNAL(clicked()), trayIcon, SLOT(stopNginx()));
     connect(ui->pushButton_StopPHP, SIGNAL(clicked()), trayIcon, SLOT(stopPhp()));
     connect(ui->pushButton_StopMariaDb, SIGNAL(clicked()), trayIcon, SLOT(stopMySQL()));
 }

void MainWindow::changeEvent(QEvent *event)
{
    switch (event->type())
    {
        //case QEvent::LanguageChange:
        //    this->ui->retranslateUi(this);
        //    break;
        case QEvent::WindowStateChange:
            {
                // minimize to tray (do not minimize to taskbar)
                if (this->windowState() & Qt::WindowMinimized)
                {
                    // @todo provide configuration options to let the user decide on this
                    //if (Preferences::instance().minimizeToTray())
                    //{
                        QTimer::singleShot(0, this, SLOT(hide()));
                    //}
                }

                break;
            }
        default:
            break;
    }

    QMainWindow::changeEvent(event);
}

void MainWindow::closeEvent(QCloseEvent *event)
{
    if (trayIcon->isVisible()) {
        QMessageBox::information(this, APP_NAME,
                                 tr("The program will keep running in the system tray.<br>"
                                    "To terminate the program, choose <b>Quit</b> in the context menu of the system tray."));
        hide();

        // do not propagate the event to the base class
        event->ignore();
    }
}

void MainWindow::setVisible(bool visible)
 {
     minimizeAction->setEnabled(visible);
     restoreAction->setEnabled(isMaximized() || !visible);
     QMainWindow::setVisible(visible);
 }

void MainWindow::iconActivated(QSystemTrayIcon::ActivationReason reason)
{
    switch (reason) {
        case QSystemTrayIcon::Trigger:
        case QSystemTrayIcon::DoubleClick:
        //case QSystemTrayIcon::MiddleClick:

            // clicking the tray icon, when the main window is hidden, shows the main window
            if(!isVisible()) {
                setVisible(true);
                setWindowState( windowState() & ( ~Qt::WindowMinimized | Qt::WindowActive ) );
            }
            else {
                // clicking the tray icon, when the main window is shown, hides it
                setVisible(false);
            }

            break;
        default:;
    }
}

void MainWindow::getNginxVersion()
{
    QProcess* processNginx;

    processNginx = new QProcess(this);
    //processNginx->setWorkingDirectory(cfgNginxDir);
    //processNginx->start("./nginx", QStringList() << "-v");
    processNginx->waitForFinished(-1);

    QString p_stdout = processNginx->readAllStandardOutput();
    QString p_stderr = processNginx->readAllStandardError();

    qDebug() << p_stdout;
    qDebug() << p_stderr;

    return parseVersionNumber(p_stdout); // nginx version: nginx/1.1.11
}

void MainWindow::getMariaVersion()
{
    QProcess* processMaria;

    processMaria = new QProcess(this);
    //processMaria->setWorkingDirectory(cfgMariaDir);
    processMaria->start("./mysqld", QStringList() << "-V"); // upper-case V
    processMaria->waitForFinished(-1);

    QString p_stdout = processMaria->readAllStandardOutput();
    QString p_stderr = processMaria->readAllStandardError();

    qDebug() << p_stdout;
    qDebug() << p_stderr;

    return parseVersionNumber(p_stdout); // mysql  Ver 15.1 Distrib 5.5.23-MariaDB, for Win32 (x86)
}

void MainWindow::getPHPVersion()
{
    QProcess* processPhp;

    processPhp = new QProcess(this);
    //processPhp->setWorkingDirectory(cfgPHPDir);
    //processPhp->start(cfgPHPDir+cfgPHPExec, QStringList() << "-v");
    processPhp->waitForFinished(-1);

    QString p_stdout = processPhp->readAllStandardOutput();
    QString p_stderr = processPhp->readAllStandardError();

    qDebug() << p_stdout;
    qDebug() << p_stderr;

    return parseVersionNumber(p_stdout); // PHP 5.4.0 (cli) (built: Feb 29 2012 19:06:50)
}

void MainWindow::parseVersionNumber(QString stringWithVersion)
{
    // split string at space
    //QStringList listVersionString = stringWithVersion.split("\t");
    QRegExp rx("^(?:(\\d+)\\.)?(?:(\\d+)\\.)?(\\*|\\d+)$");

    //int pos = rx.indexIn(stringWithVersion);
    QStringList list = rx.capturedTexts();

    QStringList::iterator it = list.begin();
    while (it != list.end()) {
        qDebug() << *it; // processing cmd here
        ++it;
    }
}

void MainWindow::goToWebsite()
{
    QDesktopServices::openUrl(QUrl("http://wpn-xm.org/"));
}

void MainWindow::goToGoogleGroup()
{
    QDesktopServices::openUrl(QUrl("http://groups.google.com/group/wpn-xm/"));
}

void MainWindow::goToReportIssue()
{
    QDesktopServices::openUrl(QUrl("https://github.com/jakoch/WPN-XM/issues/"));
}

void MainWindow::goToDonate()
{
    QDesktopServices::openUrl(QUrl("http://wpn-xm.org/#donate"));
}

void MainWindow::openHelpDialog()
{

}

void MainWindow::openConfigurationDialog()
{

}

void MainWindow::openAboutDialog()
{

}


