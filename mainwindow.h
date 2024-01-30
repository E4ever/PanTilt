#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
//#include "Include/CommonTypes.h"
#include <QSettings>
#include <ExtraDevices/ComPortManager.h>
#include <Executers/PlatformMovingController.h>

QT_BEGIN_NAMESPACE
namespace Ui { class MainWindow; }
QT_END_NAMESPACE

/**
 * @brief The MainWindow class   Main window class
 */
class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    /**
     * @brief MainWindow Constructor
     * @param parent    Parent object
     */
    MainWindow(QWidget *parent = nullptr);
    ~MainWindow() override;

    /**
     * @brief setupProject   Function that setups project
     */
    void setupProject();

    /**
     * @brief initObjects   Function that inits objects
     */
    void initObjects();

    /**
     * @brief setComPortManager Function to set COM-Port Manager
     * @param comPortManager    COM-Port Manager object
     */
    void setComPortManager(ComPortManager *comPortManager);

    /**
     * @brief setUpdatesNeeded  Slot needed for changing updates state in widget (depends on which Tab is active in window)
     * @param areUpdatesNeeded  Is it needed to update spectrums in widget
     */
    void setUpdatesNeeded(bool areUpdatesNeeded);

private slots:
    /**
     * @brief on_pushButtonUp_clicked     Slot for pushButtonUp 'clicked' signal
     */
    void on_pushButtonUp_clicked();

    /**
     * @brief on_pushButtonDown_clicked     Slot for pushButtonDown 'clicked' signal
     */
    void on_pushButtonDown_clicked();

    /**
     * @brief on_pushButtonCW_clicked     Slot for pushButtonCW 'clicked' signal
     */
    void on_pushButtonCW_clicked();

    /**
     * @brief on_pushButtonCCW_clicked     Slot for pushButtonCCW 'clicked' signal
     */
    void on_pushButtonCCW_clicked();

    /**
     * @brief on_pushButtonStopPan_clicked     Slot for pushButtonStopPan 'clicked' signal
     */
    void on_pushButtonStopPan_clicked();

    /**
     * @brief on_pushButtonStopTilt_clicked     Slot for pushButtonStopTilt 'clicked' signal
     */
    void on_pushButtonStopTilt_clicked();

    /**
     * @brief disableControls   Function needed to disable and enable buttons state
     * @param isNeedToDisable   Is it needed to set controls disabled
     */
    void disableControls(bool isNeedToDisable);

    /**
     * @brief showMessage   Signal to show to user text message in message box
     * @param message   Needed information
     */
    void showMessage(QString message);

    /**
     * @brief on_spinBoxTiltSpeed_editingFinished    Slot for spinBoxTiltSpeed 'editingFinished' signal
     */
    void on_spinBoxTiltSpeed_editingFinished();

    /**
     * @brief on_spinBoxPanSpeed_editingFinished    Slot for spinBoxPanSpeed 'editingFinished' signal
     */
    void on_spinBoxPanSpeed_editingFinished();

    void on_pushButtonUpIteration_clicked();

    void on_pushButtonStopTiltIteration_clicked();

    void on_pushButtonDownIteration_clicked();

    void on_pushButtonCCWIteration_clicked();

    void on_pushButtonStopPanIteration_clicked();

    void on_pushButtonCWIteration_clicked();

    void on_spinBoxTiltIteration_editingFinished();

    void on_spinBoxPanIteration_editingFinished();

    void CMD_State_Label(QString text);

    void labelMessageOK(QString text);

    void on_pushButtonErrorCMD_clicked();

    void on_pushButtonErrorDATA_clicked();

    void on_pushButtonMotionStatusDriver1_clicked();

    void on_pushButtonMotionStatusDriver2_clicked();

    void motionStatusDriver1_Error(QString text);

    void motionStatusDriver1_OK(QString text);

    void motionStatusDriver2_Error(QString text);

    void motionStatusDriver2_OK(QString text);

    void on_pushButtonCurrentAlarmDriver1_clicked();

    void on_pushButtonCurrentAlarmDriver2_clicked();

    void currentAlarmDriver1_Error(QString text);

    void currentAlarmDriver1_OK(QString text);

    void currentAlarmDriver2_Error(QString text);

    void currentAlarmDriver2_OK(QString text);

    void on_pushButtonSaveParamToEEPROM_Dr1_clicked();

    void on_pushButtonSaveParamToEEPROM_Dr2_clicked();

    void on_pushButtonResetParam_Dr1_clicked();

    void on_pushButtonResetParam_Dr2_clicked();

    void on_pushButtonResetAllParam_Dr1_clicked();

    void on_pushButtonResetAllParam_Dr2_clicked();

    void on_pushButtonReadSaveStatus_Dr1_clicked();

    void on_pushButtonReadSaveStatus_Dr2_clicked();

    void readSaveStatusDriver1_OK(QString text);

    void readSaveStatusDriver1_Error(QString text);

    void readSaveStatusDriver2_OK(QString text);

    void readSaveStatusDriver2_Error(QString text);

signals:

    /**
     * @brief comInitComplete    Signal to application that COM port initialization was finished
     */
    void comInitComplete();

    //void startMovingUp();

private:

    /**
     * @brief setupGui  Function to setup GUI
     */
    void setupGui();

    Ui::MainWindow *ui;         //!< GUI
    bool m_areUpdatesNeeded;    //!< Is it needed to update spectrums in widget
    QString m_title;            //!< Window Title
    QSettings *m_settings;      //!< Settings

    ComPortManager *m_comPortManager;       //!< Object for COM-port device control

    PlatformMovingController *m_movingController;   //!< Platform Moving Controller
    int m_currentPlatformPanSpeed; //!< Current platform panning speed
    int m_currentPlatformTiltSpeed;  //!< Current platform tilt speed

    int m_currentPlatformPanIteration; //!< Current platform pan iterations number
    int m_currentPlatformTiltIteration;  //!< Current platform tilt iterations number
};
#endif // MAINWINDOW_H
