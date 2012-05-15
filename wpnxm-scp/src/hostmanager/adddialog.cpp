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

#include <QLineEdit>
#include <QLabel>
#include <QPushButton>
#include <QGridLayout>
#include <QHBoxLayout>
#include <QVBoxLayout>

#include "adddialog.h"
#include "host.h"

AddDialog::AddDialog(QWidget *parent) :
    QDialog(parent)
{
    QPushButton* btnOk = new QPushButton("OK", this);
    QPushButton* btnCancel = new QPushButton("Cancel", this);

    m_lineeditName = new QLineEdit(this);
    m_lineeditAddress = new QLineEdit(this);
    m_lineeditAddress->setText("127.0.0.1");

    QGridLayout *gLayout = new QGridLayout;
    gLayout->setColumnStretch(1, 2);
    gLayout->addWidget(new QLabel("Address", this), 0, 0);
    gLayout->addWidget(m_lineeditAddress, 0, 1);

    gLayout->addWidget(new QLabel("Name", this), 1, 0);
    gLayout->addWidget(m_lineeditName, 1, 1);

    QHBoxLayout *buttonLayout = new QHBoxLayout;
    buttonLayout->addWidget(btnOk);
    buttonLayout->addWidget(btnCancel);

    gLayout->addLayout(buttonLayout, 2, 1, Qt::AlignRight);

    QVBoxLayout *mainLayout = new QVBoxLayout;
    mainLayout->addLayout(gLayout);
    setLayout(mainLayout);

    connect(btnOk, SIGNAL(clicked()), this, SLOT(accept()));
    connect(btnCancel, SIGNAL(clicked()), this, SLOT(reject()));

    setWindowTitle(tr("Add Host"));
}

QString AddDialog::name(){
    return m_lineeditName->text().trimmed();
}

QString AddDialog::address(){
    return m_lineeditAddress->text().trimmed();
}

void AddDialog::edit(QString name, QString adress){
    setWindowTitle(tr("Edit Host"));
   // m_leName->setEnabled(false);
    m_lineeditName->setText(name);
    m_lineeditAddress->setText(adress);
}
