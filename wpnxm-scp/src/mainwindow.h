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

#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include "version.h"
#include "tray.h"

namespace Ui {
    class MainWindow;
}

class MainWindow : public QMainWindow
{
    Q_OBJECT  // Enables signals and slots

protected:
    void closeEvent(QCloseEvent *event);
    void changeEvent(QEvent *event);

private slots:
     void iconActivated(QSystemTrayIcon::ActivationReason reason);

private:
    Ui::MainWindow *ui;

    void createActions();
    void createTrayIcon();

    QAction *minimizeAction;
    QAction *restoreAction;
    QAction *quitAction;

public:
    explicit MainWindow(QWidget *parent = 0);
    ~MainWindow();

    void setVisible(bool visible);

    QString getNginxVersion();
    QString getMariaVersion();
    QString getPHPVersion();
    QString parseVersionNumber(QString stringWithVersion);

    QSystemTrayIcon *trayIcon;

public slots:

    void goToWebsite();
    void goToGoogleGroup();
    void goToReportIssue();
    void goToDonate();

    void openConfigurationDialog();
    void openHelpDialog();
    void openAboutDialog();

    void setLabelStatusActive(QString label, bool enabled);
};

#endif // MAINWINDOW_H
