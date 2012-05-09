#ifndef MAIN_H
#define MAIN_H

#include <QtGui>

// declare interfaces
void exitIfAlreadyRunning();

class Main : public QObject
{
    Q_OBJECT  // Enables signals and slots

public:
    explicit Main(QObject *parent = 0);

signals:

public slots:

};

#endif // MAIN_H
