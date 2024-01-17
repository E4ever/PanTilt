#include "ComPortManager.h"
#include "QDebug"

ComPortManager::ComPortManager(QString comPortName, int baudRate) : QObject(), BaseComPort()
{
    m_portTextName = comPortName;
    m_baudRate = baudRate;
    m_connectionState = false;
    m_serialPort = nullptr;
    setUpComPort();
}

ComPortManager::~ComPortManager()
{
    m_serialPort->close();
    if(m_serialPort != nullptr)
        delete m_serialPort;
}

void ComPortManager::setUpComPort()
{
    m_serialPort = new QSerialPort();
    m_serialPort->setPortName(m_portTextName);
    m_serialPort->setBaudRate(m_baudRate);
    m_serialPort->setDataBits(QSerialPort::Data8);
    m_serialPort->setParity(QSerialPort::NoParity);
    m_serialPort->setStopBits(QSerialPort::OneStop);
    m_serialPort->setFlowControl(QSerialPort::NoFlowControl);

//    qDebug()<<"COM-порт:"<<m_serialPort->portName();
//    qDebug()<<"Скорость COM-порта:"<<m_serialPort->baudRate();
    if(m_serialPort->open(QIODevice::ReadWrite)){
        m_connectionState = true;
        connect(m_serialPort, SIGNAL (readyRead()), SLOT(recieveSerialPortAnswer()));
//        qDebug()<<"COM-порт открыт.";
    }else{
        m_connectionState = false;
//        qDebug()<<"COM-порт не открыт!";
    }
}

PacketData ComPortManager::formPacketFromByteArray(QByteArray inputArray)
{
//    qDebug()<<"Recieved:"<<inputArray;
    PacketData data;
    data.startByte = static_cast<unsigned char>(inputArray.at(0));
    data.comand = static_cast<unsigned char>(inputArray.at(1));
    data.m_charVal[0] = static_cast<unsigned char>(inputArray.at(2));
    data.m_charVal[1] = static_cast<unsigned char>(inputArray.at(3));
    data.m_charVal[2] = static_cast<unsigned char>(inputArray.at(4));
    data.m_charVal[3] = static_cast<unsigned char>(inputArray.at(5));
    data.endByte = static_cast<unsigned char>(inputArray.at(6));
    data.checkSumm = static_cast<unsigned char>(inputArray.at(7));
    return data;
}

QByteArray ComPortManager::formByteArrayFromPacket(PacketData packet)
{
    QByteArray array;
    array.append(static_cast<char>(packet.startByte));
    array.append(static_cast<char>(packet.comand));
    array.append(static_cast<char>(packet.m_charVal[0]));
    array.append(static_cast<char>(packet.m_charVal[1]));
    array.append(static_cast<char>(packet.m_charVal[2]));
    array.append(static_cast<char>(packet.m_charVal[3]));
    array.append(static_cast<char>(packet.endByte));
    array.append(static_cast<char>(packet.checkSumm));
    return array;
}

unsigned char ComPortManager::calcCheckSum(PacketData packet)
{
    QByteArray array = formByteArrayFromPacket(packet);
    unsigned char uc=0;
    for (int i=0; i < 7; i++){
        uc += array.at(i);
    }
    return uc;
}

bool ComPortManager::writeCommand(PacketData packet, int msToWait)
{
    packet.checkSumm = calcCheckSum(packet);
    QByteArray command = formByteArrayFromPacket(packet);
//    qDebug()<<"write"<<packet.comand;

    bool res = false;
    if(m_serialPort->isOpen()){
//        qDebug()<<"trying to write...";
        m_serialPort->write(command);
//        qDebug()<<"waiting..."<<msToWait;
        if(m_serialPort->waitForBytesWritten(msToWait))
            res = true;
//        qDebug()<<"written";
    }
//    qDebug()<<"writing result:"<<res;
    return res;
}

void ComPortManager::recieveSerialPortAnswer()
{
    QByteArray data = m_serialPort->readAll();
    QByteArray dataToSend;
    if(appendDataToPacket(data, m_packetRecieved, dataToSend)){
        emit dataIsReady(formPacketFromByteArray(dataToSend));
    }
}

bool ComPortManager::connectionState() const
{
    return m_connectionState;
}
