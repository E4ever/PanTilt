#ifndef COMPORTINTERFACE_H
#define COMPORTINTERFACE_H

#include <QObject>
#include <ExtraDevices/ComPortManager.h>

/**
 * @brief The ComPortInterface class    Interface class for using COM-port devices
 */
class ComPortInterface : public QObject
{
    Q_OBJECT
public:
    /**
     * @brief ComPortInterface  Constructor
     */
    ComPortInterface();

signals:
    /**
     * @brief writeCommandToComPort Function to write command trought serial port
     * @param command   Command to write
     */
    void writeCommandToComPort(PacketData command);

    /**
     * @brief sendTextMessage   Signal to send text message
     * @param text  Message to send
     */
    void sendTextMessage(QString text);

    void sendOKMessage(QString text);

    void sendMotionStatusDriver1_Error(QString text);

    void sendMotionStatusDriver1_OK(QString text);

    void sendMotionStatusDriver2_Error(QString text);

    void sendMotionStatusDriver2_OK(QString text);

    void sendCurrentAlarmDriver1_Error(QString text);

    void sendCurrentAlarmDriver1_OK(QString text);

    void sendCurrentAlarmDriver2_Error(QString text);

    void sendCurrentAlarmDriver2_OK(QString text);

    void saveStatusToEEPROM_Driver1_OK(QString text);

    void saveStatusToEEPROM_Driver1_Error(QString text);

    void saveStatusToEEPROM_Driver2_OK(QString text);

    void saveStatusToEEPROM_Driver2_Error(QString text);

    void readDeviceID_signal(QString text, unsigned long id);

    void readEncoderValue_signal(QString text, unsigned long enc_value);

    /**
     * @brief changeTaskProgress    Signal to set value on progress bar
     * @param progressPercent
     */
    void changeTaskProgress(int progressPercent);

private slots:
    /**
     * @brief parseComPortData  Function to parse Data recieved from COM-port device
     * @param comAnswer Data Packet drom COM-port device
     */
    virtual void parseComPortData(PacketData comAnswer) = 0;

protected:
    /**
     * @brief getErrorMessage   Function to form error message
     * @param errorType Type of error
     * @return  Text message
     */
    virtual QString getErrorMessage(unsigned char errorType) = 0;
};

#endif // COMPORTINTERFACE_H
