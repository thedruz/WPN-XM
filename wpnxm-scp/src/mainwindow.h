#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include "tray.h"

namespace Ui {
    class MainWindow;
}

class MainWindow : public QMainWindow
{
    Q_OBJECT  // Enables signals and slots

protected:
    void closeEvent(QCloseEvent *event);

private slots:
     void iconActivated(QSystemTrayIcon::ActivationReason reason);

private:
    Ui::MainWindow *ui;

    void createActions();

    QAction *minimizeAction;
    QAction *restoreAction;
    QAction *quitAction;

    QSystemTrayIcon *trayIcon;

public:
    explicit MainWindow(QWidget *parent = 0);
    ~MainWindow();

    void setVisible(bool visible);
};

#endif // MAINWINDOW_H
