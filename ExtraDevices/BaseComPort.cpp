#include "BaseComPort.h"
#include <QDebug>

BaseComPort::BaseComPort()
{
    m_currentCommandType = NO_CMD;
}

CurrentCommandType BaseComPort::currentCommandType() const
{
    return m_currentCommandType;
}

bool BaseComPort::appendDataToPacket(QByteArray data, QByteArray &packet, QByteArray &dataToSend)
{
    bool res = false;
//    qDebug()<<m_currentCommandType<<"recieving packet"<<packet.count()<<data.count();
    if(data.count() == 8){
        dataToSend = data;
        packet.clear();
        res = true;
    }else{
        packet.append(data);
        if(packet.count() > static_cast<int>(sizeof(PacketData))){
            dataToSend = packet.mid(0, sizeof(PacketData));
            packet = packet.mid(sizeof(PacketData) - 1, packet.count() - static_cast<int>(sizeof(PacketData)));
            res = true;
        }else if(packet.count() == static_cast<int>(sizeof(PacketData))){
            dataToSend = packet;
            packet.clear();
            res = true;
        }
    }
    return res;
}
