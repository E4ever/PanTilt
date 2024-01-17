#ifndef WEATHERPARAMETERSCONTROLLER_H
#define WEATHERPARAMETERSCONTROLLER_H

#include <QObject>
#include <QTimer>
#include <stdio.h>
#include <stdint.h>
#include "BaseExecutingModule.h"

enum WeatherParameters{
    NO_PARAMETER, OUT_TEMP, OUT_PRES, OUT_HUM, IN_TEMP, IN_PRES, IN_HUM
};
Q_DECLARE_METATYPE(WeatherParameters)

/**
 * @brief The WeatherParametersController class Class for controlling weather parameters inside VKP-box and outside it.
 * Allows to get pressure, temperature and humidity from COM-port device
 */
class WeatherParametersController : public BaseExecutingModule
{
    Q_OBJECT
public:
    /**
     * @brief WeatherParametersController   Constructor
     * @param parent    Parent object
     * @param comPortManager    COM-port device manager
     */
    explicit WeatherParametersController(QObject *parent = nullptr, ComPortManager *comPortManager = nullptr);
    ~WeatherParametersController() override;

signals:
    /**
     * @brief weatherParameterWasRecieved   Signal about recieved from COM-port device weather parameter
     * @param parameterType Weather parameter type
     * @param value Recieved parameter value
     */
    void weatherParameterWasRecieved(WeatherParameters parameterType, float value);

private slots:
    /**
     * @brief requestUpdatingParameters Function to request weather parameters
     */
    void requestUpdatingParameters();

    /**
     * @brief parseComPortData  Function to take date from Com port and parse it
     * @param comAnswer Array from port
     */
    void parseComPortData(PacketData comAnswer) override;

private:
    /**
     * @brief formGetOutTempPacket  Function to get out temperature
     * @param packet    Formed data packet
     */
    void formGetOutTempPacket(PacketData &packet);

    /**
     * @brief formGetOutPresPacket  Function to get out pressure
     * @param packet    Formed data packet
     */
    void formGetOutPresPacket(PacketData &packet);

    /**
     * @brief formGetOutHumPacket  Function to get out humidity
     * @param packet    Formed data packet
     */
    void formGetOutHumPacket(PacketData &packet);

    /**
     * @brief formGetInTempPacket  Function to get in temperature
     * @param packet    Formed data packet
     */
    void formGetInTempPacket(PacketData &packet);

    /**
     * @brief formGetInPresPacket  Function to get in pressure
     * @param packet    Formed data packet
     */
    void formGetInPresPacket(PacketData &packet);

    /**
     * @brief formGetInHumPacket  Function to get in humidity
     * @param packet    Formed data packet
     */
    void formGetInHumPacket(PacketData &packet);
    /**
     * @brief getErrorMessage   Function to form error message
     * @param errorType Type of current error
     * @return  Text message
     */
    QString getErrorMessage(unsigned char errorType) override;

    const int m_timerInterval = 5000;   //!< Time interval (ms) for weather parameters updating
    WeatherParameters m_currentWeatherParameter;    //!< Current weather parameter type
};

#endif // WEATHERPARAMETERSCONTROLLER_H
