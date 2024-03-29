#ifndef PLATFORMMOVINGCONTROLLER_H
#define PLATFORMMOVINGCONTROLLER_H

#include "BaseExecutingModule.h"


/**
 * @brief The PlatformMovingController class    Class for controlling orientation platform with VKP-box
 */
class PlatformMovingController : public BaseExecutingModule
{    
    Q_OBJECT
public:
    /**
     * @brief PlatformMovingController  Constructor
     * @param parent    Parent object
     * @param comPortManager    COM-port device manager
     */
    PlatformMovingController(QObject *parent = nullptr, ComPortManager *comPortManager = nullptr);
    ~PlatformMovingController() override;

    /**
     * @brief moveCCW  Fuctinon to rotate VKP control clockwise
     */
    void moveCCW();

    /**
     * @brief moveCW  Fuctinon to rotate VKP clockwise
     */
    void moveCW();

    /**
     * @brief stopPan  Fuctinon to stop VKP panning
     */
    void stopPan();

    /**
     * @brief moveUp  Fuctinon to rotate VKP for zenith angle minimizing
     */
    void moveUp();

    /**
     * @brief moveDown  Fuctinon to rotate VKP for zenith angle rising
     */
    void moveDown();

    /**
     * @brief stopTilt  Fuctinon to stop VKP tilt
     */
    void stopTilt();

    void moveUpIteration();

    void stopTiltIteration();

    void moveDownIteration();

    void moveCCWIteration();

    void stopPanIteration();

    void moveCWIteration();

    void setNumberOfIterationPan(unsigned long numberOfIterations);

    void setNumberOfIterationTilt(unsigned long numberOfIterations);

    /**
     * @brief setAzimSpeed  Function to set the speed of moving on azimooth
     * @param speedValue    Speed value
     */
    void setAzimSpeed(int speedValue);

    /**
     * @brief setZenithSpeed    Function to set the speed of moving on zenith angle
     * @param speedValue    Speed value
     */
    void setZenithSpeed(int speedValue);

    /**
     * @brief setSpeeds Function to set speeds of moving
     * @param azimSpeed The speed of moving on azimooth
     * @param zenSpeed  The speed of moving on zenith angle
     */
    void setSpeeds(int azimSpeed, int zenSpeed);

    void errorCMD();

    void errorDATA();

    void motionStatusDriver1();

    void motionStatusDriver2();

    void currentAlarmDriver1();

    void currentAlarmDriver2();

    void saveToEEPROM_Driver1();

    void saveToEEPROM_Driver2();

    void resetParam_Driver1();

    void resetParam_Driver2();

    void resetAllParam_Driver1();

    void resetAllParam_Driver2();

    void readSaveStatus_Driver1();

    void readSaveStatus_Driver2();

    void readDeviceID();

    void DC_motor_stop();

    void DC_motor_CW();

    void DC_motor_CCW();

    void readEncoderValue();

    void readTemp1();

    void readTemp2();

    void readPress1();

    void readPress2();

    void readHum1();

    void readHum2();

    void shutterOpen();

    void shutterClose();

signals:
    /**
     * @brief needToDisableControls Signal that it is needed (not needed) to set controls disabled
     * @param isNeededToDisable     Is it needed to set controls disabled
     */
    void needToDisableControls(bool isNeededToDisable);

    /**
     * @brief sendErrorMessage  Signal to send error message
     * @param textError Error text
     */
    void sendErrorMessage(QString textError);

private slots:
    /**
     * @brief parseComPortData  Function to take date from Com port and parse it
     * @param comAnswer Array from port
     */
    void parseComPortData(PacketData comAnswer) override;

private:
    /**
     * @brief getErrorMessage   Function to form error message
     * @param errorType Type of current error
     * @return  Text message
     */
    QString getErrorMessage(unsigned char errorType) override;

    QString getErrorMessageModbus(unsigned char errorType);

    enum MovementParameters{
        NO_PARAMETER, MOVING_CCW, MOVING_CW, STOP_PAN, MOVING_DOWN,
        MOVING_UP, STOP_TILT, SETTING_PAN_SPEED, SETTING_TILT_SPEED,
        SETTING_NUMBER_OF_ITR_PAN, SETTING_NUMBER_OF_ITR_TILT, MB_ERROR,
        SAVE_TO_EEPROM, RESET_PARAM, RESET_ALL_PARAM, READ_SAVE_STATUS,
        READ_DEVICE_ID, DC_MOTOR_CONTROL, READ_ENCODER_VALUE,
        READ_TEMP, READ_PRESS, READ_HUM, SHUT_CONTROL
    };
    MovementParameters m_currentMovingState;    //!< Current task for controller
    int m_zenSpeed;     //!< The speed on zenith angle
    int m_azimSpeed;    //!< The speed on azimut
};

#endif // PLATFORMMOVINGCONTROLLER_H
