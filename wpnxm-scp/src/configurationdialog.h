#ifndef CONFIGURATIONDIALOG_H
#define CONFIGURATIONDIALOG_H

// global includes
#include <QDialog>

// forward declarations
class QCheckBox;

namespace Ui {
class ConfigurationDialog;
}

class ConfigurationDialog : public QDialog
{
    Q_OBJECT
    
public:
    explicit ConfigurationDialog(QWidget *parent = 0);
    ~ConfigurationDialog();

    void setRunOnStartUp(bool run = true);

    bool runOnStartUp() const;
    
private:
    Ui::ConfigurationDialog *ui;

    QCheckBox *m_chkRunStartUp;
};

#endif // CONFIGURATIONDIALOG_H
