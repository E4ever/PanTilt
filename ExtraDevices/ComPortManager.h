#ifndef COMPORTMANAGER_H
#define COMPORTMANAGER_H

#include "QtSerialPort/QSerialPort"
#include "qbytearray.h"
#include "Windows.h"
#include "BaseComPort.h"

/**
 * @brief The ComPortManager class
 * Base class for COM-port using
 */
class ComPortManager : public QObject, public BaseComPort
{
    Q_OBJECT

    QString m_portTextName;         //!< Com Port name
    int m_baudRate;                 //!< Baudrate
    QSerialPort *m_serialPort;      //!< Serial port
    bool m_connectionState;         //!< Manager state (0 - not connected, 1 - connected)
    QByteArray m_packetRecieved;    //!< Recieved packet as QByteArray

public:
    /**
     * @brief ComPortManager    Constructor
     * @param comPortName       Com Port Name
     * @param baudRate          Com Port Baud Rate
     */
    explicit ComPortManager(QString comPortName = "", int baudRate  = 0);
    ~ComPortManager() override;

    /**
     * @brief managerState  Function returns COM-port manager state
     * @return COM-port manager state (0 - not connected, 1 - connected)
     */
    bool connectionState() const;

public slots:
    /**
     * @brief writeCommand  Function writes command to device and recieves answer from device if it exists
     * @param packet        Command as QByteArray
     * @param msToWait      Waiting time for writing
     * @return Is writing OK
     */
    bool writeCommand(PacketData packet, int msToWait = 50);

private:
    /**
     * @brief setUpComPort  Function makes COM-port setup and opens device
     */
    void setUpComPort();

    /**
     * @brief formPacketFromByteArray   Function to convert input QByteArray to PacketData structure
     * @param inputArray    Input data array
     * @return  Converted structure
     */
    PacketData formPacketFromByteArray(QByteArray inputArray);

    /**
     * @brief formByteArrayFromPacket   Function to convert input PacketData structure to QByteArray
     * @param packet    Input data structure
     * @return  Converted array
     */
    QByteArray formByteArrayFromPacket(PacketData packet);

    /**
     * @brief calcCheckSum  Function to calculate check summ for data packet
     * @param packet    Packet to claculate
     * @return  Resulting check summ
     */
    unsigned char calcCheckSum(PacketData packet);

private slots:
    /**
     * @brief recieveSerialPortAnswer   Slot for Serial port signal 'readyRead()'
     */
    void recieveSerialPortAnswer();

signals:
    /**
     * @brief dataIsReady   Signal about data recieved
     * @param recievedData  Data packet recieved throught serial port
     */
    void dataIsReady(PacketData packet);
};

#endif // COMPORTMANAGER_H
