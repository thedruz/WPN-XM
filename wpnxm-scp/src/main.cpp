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
#include <QObject>
#include <QSystemTrayIcon>
#include <QMessageBox>
#include <QSharedMemory>

// WPN-XM SCP includes
#include "wpnxm-tray.h"

// main method
int main(int argc, char * argv[])
{
    QApplication application(argc, argv);

    exitIfAlreadyRunning();

    // Application Meta Data
    application.setApplicationName("WPN-XM Server Control Panel");
    application.setOrganizationName("Jens-André Koch");
    application.setOrganizationDomain("http://clansuite.com");
    application.setWindowIcon(QIcon(":/wpnxm"));

    // if setStyle() is not used, the submenus are not displayed properly. bug?
    application.setStyle("windowsxp");

    if (false == QSystemTrayIcon::isSystemTrayAvailable())
    {
        QMessageBox::critical(0, QObject::tr("Systray"), QObject::tr("You don't have a system tray."));
        return 1;
    }

    WpnxmTray trayIcon(&application);
    trayIcon.show();

    // do not leave until Quit is clicked in the tray menu
    application.setQuitOnLastWindowClosed(false);

    // enter the Qt Event loop here
    return application.exec();
}

/*
 * Single Instance Check
 * Although some people tend to solve this problem by using QtSingleApplication,
 * this approach uses a GUID stored into shared memory.
 */
void exitIfAlreadyRunning()
{
      // Set GUID for WPN-XM Server Control Panel to memory
      QSharedMemory shared("004d54f6-7d00-4478-b612-f242f081b023");

      // theres only one GUID
      if(false == shared.create( 512, QSharedMemory::ReadWrite) )
      {
          QMessageBox msgBox;
          msgBox.setText( QObject::tr("Application is already running.  Exiting.") );
          msgBox.setIcon( QMessageBox::Critical );
          msgBox.exec();

          exit(0);
      }
}
