#include "BaseExecutingModule.h"
#include <QDebug>

BaseExecutingModule::BaseExecutingModule(ComPortManager *comPortManager)
{
    m_comPortManager = comPortManager;
    qRegisterMetaType<PacketData>();
    connect(m_comPortManager, SIGNAL(dataIsReady(PacketData)), SLOT(parseComPortData(PacketData)));
    connect(this, SIGNAL(writeCommandToComPort(PacketData)), m_comPortManager, SLOT(writeCommand(PacketData)), Qt::QueuedConnection);
}

void BaseExecutingModule::preparePacket(PacketData &packet)
{
    ZeroMemory(&packet, sizeof(PacketData));
    packet.startByte = 0xA5;
    packet.endByte = 0x5A;
}
