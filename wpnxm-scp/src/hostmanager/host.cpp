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

// C++
#include <stdlib.h>
#include <windows.h>
#include <string>

// QT
#include <QStringList>
#include <QTextStream>
#include <QDebug>
#include <QFile>
#include <QTemporaryFile>
#include <QDir>
#include <QThread>
#include <QDebug>

// WPNXM
#include "host.h"

QList<Host*> Host::GetHosts()
{
    QList<Host*> listReturn;

    QFile hostFile(getHostFile());

    if(hostFile.open(QFile::ReadOnly))
    {
        QTextStream hostStream(&hostFile);
        QString strLine;

        while (!(strLine = hostStream.readLine()).isNull())
        {
            strLine = strLine.trimmed();

            QStringList strList = strLine.split(QRegExp("[ \t]"), QString::SkipEmptyParts);

            // skip comment line
            if(strList.empty() || strList.startsWith("#"))
            {
                continue;
            }

            qDebug() << strList;

            Host* host = new Host(strList[1], strList[0]);
            listReturn << host;
        }
    }    

    return listReturn;
}

void Host::writeHostFile(QList<Host*> listHosts)
{
    QFile hostFile(getHostFile());
    QTemporaryFile tempFile;

    tempFile.setAutoRemove(false);

    if(hostFile.open(QFile::ReadOnly) && tempFile.open())
    {
         QTextStream hostStream(&hostFile);
         QTextStream tempStream(&tempFile);

         QString strLine;
         while (!(strLine = hostStream.readLine()).isNull())
         {
             if(strLine.trimmed().isEmpty() || strLine.startsWith("#"))
             {
                tempStream << strLine << "\r\n";
                continue;
             }

             // It's a host line
             QStringList lst = strLine.split(QRegExp("[ \t]"), QString::SkipEmptyParts);

             Host hostFromFile(lst[1], lst[0]);
             int index = listHosts.indexOf(&hostFromFile);
             // It match an host setup
             if(index>=0)
             {
                Host* host = listHosts.takeAt(index);
                tempStream << host->address() << "       " << host->name() << "\r\n";
             }
         }

         // Copy remaining hosts
         tempStream << "\r\n";
         while(!listHosts.isEmpty())
         {
             Host* host = listHosts.takeFirst();
             tempStream << host->address() << "       " << host->name() << "\r\n";
         }

         // Cleanup
         hostFile.close();
         tempFile.close();
    }

    // Copy content of tempfile to host file
    QString strHostFile = QDir::toNativeSeparators(hostFile.fileName());
    QString strTempFile = QDir::toNativeSeparators(tempFile.fileName());

    QString strArguments = "/c copy /y \""+strTempFile+"\" \""+strHostFile+"\"";
    std::wstring tmp = strArguments.toStdWString();
    LPCTSTR wcArguments = tmp.c_str();

    SHELLEXECUTEINFO shExecInfo;
    shExecInfo.cbSize = sizeof(SHELLEXECUTEINFO);
    shExecInfo.fMask = NULL;
    shExecInfo.hwnd = NULL;
    shExecInfo.lpVerb = L"runas";
    shExecInfo.lpFile = L"cmd.exe";
    shExecInfo.lpParameters = wcArguments;
    shExecInfo.lpDirectory = NULL;
    shExecInfo.nShow = SW_MAXIMIZE;
    shExecInfo.hInstApp = NULL;

    ShellExecuteEx(&shExecInfo);
}

QString Host::getHostFile()
{
    QString windir(getenv("windir"));
    return windir+"\\System32\\drivers\\etc\\hosts";
}

//--------------------------------
Host::Host() {}

Host::Host(QString strName, QString strAddress)
{
    setName(strName);
    setAddress(strAddress);
}

void Host::setAddress(QString strAddress)
{
    strAddress = strAddress.trimmed();
}

QString Host::address()
{
    return strAddress;
}

void Host::setName(QString strName)
{
    strName = strName.trimmed();
}

QString Host::name()
{
    return strName;
}

bool Host::operator==(const Host &host) const
{
    return strName == host.strName && strAddress == host.strAddress;
}
