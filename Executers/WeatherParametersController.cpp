#include "WeatherParametersController.h"
#include <QDebug>
#include <iostream>
#include <sstream>
#include <QDateTime>

WeatherParametersController::WeatherParametersController(QObject *parent, ComPortManager *comPortManager)
    : BaseExecutingModule(comPortManager)
{
    m_currentWeatherParameter = NO_PARAMETER;
}

WeatherParametersController::~WeatherParametersController()
{
}

void WeatherParametersController::requestUpdatingParameters()
{
    PacketData packetToSend;
    preparePacket(packetToSend);
    switch(m_currentWeatherParameter){
    case NO_PARAMETER:
        emit changeTaskProgress(0);
        sendTextMessage("Выполняется обновление метеопараметров. Пожалуйста, подождите...");
        formGetOutTempPacket(packetToSend);
        break;
    case OUT_TEMP:
        formGetOutPresPacket(packetToSend);
        break;
    case OUT_PRES:
        formGetOutHumPacket(packetToSend);
        break;
    case OUT_HUM:
        formGetInTempPacket(packetToSend);
        break;
    case IN_TEMP:
        formGetInPresPacket(packetToSend);
        break;
    case IN_PRES:
        formGetInHumPacket(packetToSend);
        break;
    case IN_HUM:
        m_currentWeatherParameter = NO_PARAMETER;
        emit portIsFree();
        break;
    }
}

void WeatherParametersController::parseComPortData(PacketData comAnswer)
{
    if(m_currentWeatherParameter != NO_PARAMETER){
        if(comAnswer.comand == 'e'){
            emit sendTextMessage(getErrorMessage(comAnswer.m_charVal[0]));
        }else if(comAnswer.comand == 't' || comAnswer.comand == 'p' || comAnswer.comand == 'h'){
            emit weatherParameterWasRecieved(m_currentWeatherParameter, comAnswer.m_floatVal);
            emit changeTaskProgress(m_currentWeatherParameter*16 + 4);
        }
        requestUpdatingParameters();
    }
}

void WeatherParametersController::formGetOutTempPacket(PacketData &packet)
{
    m_currentWeatherParameter = OUT_TEMP;
    packet.comand = 't';
    packet.m_intVal = 1;
    emit writeCommandToComPort(packet);
    emit changeTaskProgress(m_currentWeatherParameter*16);
}

void WeatherParametersController::formGetOutPresPacket(PacketData &packet)
{
    m_currentWeatherParameter = OUT_PRES;
    packet.comand = 'p';
    packet.m_intVal = 1;
    emit writeCommandToComPort(packet);
    emit changeTaskProgress(m_currentWeatherParameter*16);
}

void WeatherParametersController::formGetOutHumPacket(PacketData &packet)
{
    m_currentWeatherParameter = OUT_HUM;
    packet.comand = 'h';
    packet.m_intVal = 1;
    emit writeCommandToComPort(packet);
    emit changeTaskProgress(m_currentWeatherParameter*16);
}

void WeatherParametersController::formGetInTempPacket(PacketData &packet)
{
    m_currentWeatherParameter = IN_TEMP;
    packet.comand = 't';
    packet.m_intVal = 0;
    emit writeCommandToComPort(packet);
    emit changeTaskProgress(m_currentWeatherParameter*16);
}

void WeatherParametersController::formGetInPresPacket(PacketData &packet)
{
    m_currentWeatherParameter = IN_PRES;
    packet.comand = 'p';
    packet.m_intVal = 0;
    emit writeCommandToComPort(packet);
    emit changeTaskProgress(m_currentWeatherParameter*16);
}

void WeatherParametersController::formGetInHumPacket(PacketData &packet)
{
    m_currentWeatherParameter = IN_HUM;
    packet.comand = 'h';
    packet.m_intVal = 0;
    emit writeCommandToComPort(packet);
    emit changeTaskProgress(m_currentWeatherParameter*16);
}

QString WeatherParametersController::getErrorMessage(unsigned char errorType)
{
    QString errorText("Ошибка передачи команды через COM-порт: ");
    if(errorType == 'e'){
        errorText.append("неверная контрольная сумма!");
    }else if(errorType == 't'){
        errorText.append("некорректный тип команды!");
    }else if(errorType == 'd'){
        errorText.append("некорректное значение в блоке данных!");
    }else if(errorType == 'p'){
        errorText.append("некорректный формат пакета!");
    }
    qDebug()<<errorText;
    return errorText;
}

