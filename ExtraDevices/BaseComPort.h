#ifndef BASECOMPORT_H
#define BASECOMPORT_H

#include <QByteArray>
#include <Include/CommonTypes.h>
#include <QList>

enum CurrentCommandType
{
    NO_CMD, GET_STMID, GET_TEMPERATURE, GET_PRESSURE, GET_HUMIDITY, SET_SHUTTER, SET_PLATFORM, STM_ERROR
};

/**
 * @brief The PacketData struct Structure for packets sent to and recieved from STM device
 */
struct PacketData{
    unsigned char    startByte;
    unsigned char    comand;
    union {
        unsigned long m_intVal;
        float m_floatVal;
        unsigned char m_charVal[4];
    };
    unsigned char    checkSumm;
    unsigned char    endByte;
};
Q_DECLARE_METATYPE(PacketData)

/**
 * @brief The BaseComPort class Base class for COM-port devices managing
 */
class BaseComPort
{    
    CurrentCommandType m_currentCommandType;    //!< Current Command Type
    QList<QByteArray> m_nextCommands;           //!< List of queed commands

public:
    /**
     * @brief ComPortInterface  Constructor
     */
    BaseComPort();

    /**
     * @brief currentCommandType    Finction to get current command type
     * @return Current command type
     */
    CurrentCommandType currentCommandType() const;

protected:
    /**
     * @brief appendDataToPacket    Function to append new data to packet recieved before
     * @param data  New recieved data
     * @param packet    Packet recieved before
     * @param dataToSend    Ready packet to send (if the function return true)
     * @return  Is all packet recieved
     */
    bool appendDataToPacket(QByteArray data, QByteArray &packet, QByteArray &dataToSend);
};

#endif // BASECOMPORT_H
