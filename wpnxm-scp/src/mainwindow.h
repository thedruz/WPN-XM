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

    QAction *minimizeAction;
    QAction *restoreAction;
    QAction *quitAction;

public:
    explicit MainWindow(QWidget *parent = 0);
    ~MainWindow();

    void setVisible(bool visible);

    void getNginxVersion();
    void getMariaVersion();
    void getPHPVersion();
    void parseVersionNumber(QString stringWithVersion);

    QSystemTrayIcon *trayIcon;

public slots:

    void goToWebsite();
    void goToGoogleGroup();
    void goToReportIssue();
    void goToDonate();

    void openConfigurationDialog();
    void openHelpDialog();
    void openAboutDialog();

};

#endif // MAINWINDOW_H
