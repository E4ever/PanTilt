#include "PlatformMovingController.h"

PlatformMovingController::PlatformMovingController(QObject *parent, ComPortManager *comPortManager)
    : BaseExecutingModule(comPortManager)
{
    m_currentMovingState = NO_PARAMETER;
}

PlatformMovingController::~PlatformMovingController()
{

}

void PlatformMovingController::moveCCW()
{
    PacketData packetToSend;
    preparePacket(packetToSend);
    packetToSend.comand = 'a';
    packetToSend.m_intVal = 2;
    m_currentMovingState = MOVING_CCW;
    emit needToDisableControls(true);
    emit writeCommandToComPort(packetToSend);
}

void PlatformMovingController::moveCW()
{
    PacketData packetToSend;
    preparePacket(packetToSend);
    packetToSend.comand = 'a';
    packetToSend.m_intVal = 1;
    m_currentMovingState = MOVING_CW;
    emit needToDisableControls(true);
    emit writeCommandToComPort(packetToSend);
}

void PlatformMovingController::stopPan()
{
    PacketData packetToSend;
    preparePacket(packetToSend);
    packetToSend.comand = 'a';
    packetToSend.m_intVal = 0;
    m_currentMovingState = STOP_PAN;
    emit needToDisableControls(true);
    emit writeCommandToComPort(packetToSend);
}

void PlatformMovingController::moveUp()
{
//    qDebug()<<"Вверх.";
    PacketData packetToSend;
    preparePacket(packetToSend);
    packetToSend.comand = 'w';
    packetToSend.m_intVal = 2;
    m_currentMovingState = MOVING_UP;
    emit needToDisableControls(true);
    emit writeCommandToComPort(packetToSend);
}

void PlatformMovingController::moveDown()
{
    PacketData packetToSend;
    preparePacket(packetToSend);
    packetToSend.comand = 'w';
    packetToSend.m_intVal = 1;
    m_currentMovingState = MOVING_DOWN;
    emit needToDisableControls(true);
    emit writeCommandToComPort(packetToSend);
}

void PlatformMovingController::stopTilt()
{
    PacketData packetToSend;
    preparePacket(packetToSend);
    packetToSend.comand = 'w';
    packetToSend.m_intVal = 0;
    m_currentMovingState = STOP_TILT;
    emit needToDisableControls(true);
    emit writeCommandToComPort(packetToSend);
}

void PlatformMovingController::moveUpIteration(){
    PacketData packetToSend;
    preparePacket(packetToSend);
    packetToSend.comand = 'w';
    packetToSend.m_intVal = 5;
    m_currentMovingState = MOVING_UP;
    emit needToDisableControls(true);
    emit writeCommandToComPort(packetToSend);
}

void PlatformMovingController::stopTiltIteration(){
    PacketData packetToSend;
    preparePacket(packetToSend);
    packetToSend.comand = 'w';
    packetToSend.m_intVal = 3;
    m_currentMovingState = STOP_TILT;
    emit needToDisableControls(true);
    emit writeCommandToComPort(packetToSend);
}

void PlatformMovingController::moveDownIteration(){
    PacketData packetToSend;
    preparePacket(packetToSend);
    packetToSend.comand = 'w';
    packetToSend.m_intVal = 4;
    m_currentMovingState = MOVING_DOWN;
    emit needToDisableControls(true);
    emit writeCommandToComPort(packetToSend);
}

void PlatformMovingController::moveCCWIteration(){
    PacketData packetToSend;
    preparePacket(packetToSend);
    packetToSend.comand = 'a';
    packetToSend.m_intVal = 5;
    m_currentMovingState = MOVING_CCW;
    emit needToDisableControls(true);
    emit writeCommandToComPort(packetToSend);
}

void PlatformMovingController::stopPanIteration(){
    PacketData packetToSend;
    preparePacket(packetToSend);
    packetToSend.comand = 'a';
    packetToSend.m_intVal = 3;
    m_currentMovingState = STOP_PAN;
    emit needToDisableControls(true);
    emit writeCommandToComPort(packetToSend);
}

void PlatformMovingController::moveCWIteration(){
    PacketData packetToSend;
    preparePacket(packetToSend);
    packetToSend.comand = 'a';
    packetToSend.m_intVal = 4;
    m_currentMovingState = MOVING_CW;
    emit needToDisableControls(true);
    emit writeCommandToComPort(packetToSend);
}

void PlatformMovingController::setNumberOfIterationPan(unsigned long numberOfIterations){
    PacketData packetToSend;
    preparePacket(packetToSend);
    packetToSend.comand = 'n';
    packetToSend.m_intVal = numberOfIterations;
    m_currentMovingState = SETTING_NUMBER_OF_ITR_PAN;
    emit needToDisableControls(true);
    emit writeCommandToComPort(packetToSend);
}

void PlatformMovingController::setNumberOfIterationTilt(unsigned long numberOfIterations){
    PacketData packetToSend;
    preparePacket(packetToSend);
    packetToSend.comand = 'o';
    packetToSend.m_intVal = numberOfIterations;
    m_currentMovingState = SETTING_NUMBER_OF_ITR_TILT;
    emit needToDisableControls(true);
    emit writeCommandToComPort(packetToSend);
}

void PlatformMovingController::setAzimSpeed(int speedValue)
{
    if(speedValue >= 0 && speedValue <= 5000){
        PacketData packetToSend;
        preparePacket(packetToSend);
        packetToSend.comand = 'x';
        packetToSend.m_intVal = static_cast<unsigned long>(speedValue);
        m_currentMovingState = SETTING_PAN_SPEED;
        emit needToDisableControls(true);
        emit writeCommandToComPort(packetToSend);
    }else{
        QString errorText("Скорость поворота СНС по азимутальному углу выходит за область допустимых значений");
        qDebug()<<errorText;
        emit sendTextMessage(errorText);
    }
}

void PlatformMovingController::setZenithSpeed(int speedValue)
{
    if(speedValue >= 0 && speedValue <= 5000){
        PacketData packetToSend;
        preparePacket(packetToSend);
        packetToSend.comand = 'y';
        packetToSend.m_intVal = static_cast<unsigned long>(speedValue);
        m_currentMovingState = SETTING_TILT_SPEED;
        emit needToDisableControls(true);
        emit writeCommandToComPort(packetToSend);
    }else{
        QString errorText("Скорость поворота СНС по зенитному углу выходит за область допустимых значений");
        qDebug()<<errorText;
        emit sendTextMessage(errorText);
    }
}

void PlatformMovingController::setSpeeds(int azimSpeed, int zenSpeed)
{
    m_zenSpeed = zenSpeed;
    m_azimSpeed = azimSpeed;
    switch(m_currentMovingState){
    case PlatformMovingController::NO_PARAMETER:
        setAzimSpeed(azimSpeed);
        break;
    case PlatformMovingController::SETTING_PAN_SPEED:
        setZenithSpeed(zenSpeed);
        break;
    case PlatformMovingController::SETTING_TILT_SPEED:
        m_currentMovingState = NO_PARAMETER;
        emit needToDisableControls(false);
        emit portIsFree();
        break;
    default:
        break;
    }
}

void PlatformMovingController::parseComPortData(PacketData comAnswer)
{
//    qDebug()<<"parsing data..."<<comAnswer.comand;
    if(m_currentMovingState != NO_PARAMETER){
        if(comAnswer.comand == 'e'){
            emit sendTextMessage(getErrorMessage(comAnswer.m_charVal[0]));
        } else if(comAnswer.comand == 'a' || comAnswer.comand == 'w'){
            m_currentMovingState = NO_PARAMETER;
            emit needToDisableControls(false);
            emit sendOKMessage("Ошибок передачи команд через COM-порт нет.");
        } else if(comAnswer.comand == 'd'){
            if(comAnswer.m_charVal[0] == 0){

            } else if(comAnswer.m_charVal[0] == 1){
                emit sendMotionStatusDriver1_Error("Нет связи с драйвером! Проверьте питание или подключение кабеля Ethernet.");
            } else if(comAnswer.m_charVal[0] == 2){
                emit sendMotionStatusDriver1_Error("Отсутствует подключение шагового двигателя к драйверу! Проверьте подключение.");
            } else if(comAnswer.m_charVal[0] == 3){
                emit sendMotionStatusDriver1_OK("Шаговый двигатель в режиме движения.");
            } else if(comAnswer.m_charVal[0] == 4){
                emit sendMotionStatusDriver1_OK("Шаговый двигатель в режиме ожидания.");
            } else if(comAnswer.m_charVal[0] == 5){
                emit sendMotionStatusDriver2_Error("Нет связи с драйвером! Проверьте питание или подключение кабеля Ethernet.");
            } else if(comAnswer.m_charVal[0] == 6){
                emit sendMotionStatusDriver2_Error("Отсутствует подключение шагового двигателя к драйверу! Проверьте подключение.");
            } else if(comAnswer.m_charVal[0] == 7){
                emit sendMotionStatusDriver2_OK("Шаговый двигатель в режиме движения.");
            } else if(comAnswer.m_charVal[0] == 8){
                emit sendMotionStatusDriver2_OK("Шаговый двигатель в режиме ожидания.");
            }
        } else if(comAnswer.comand == 'c'){
            if(comAnswer.m_charVal[0] == 0){
                emit sendCurrentAlarmDriver2_OK("Текущих ошибок нет.");
            } else if(comAnswer.m_charVal[0] == 1){
                emit sendCurrentAlarmDriver2_Error("Перегрузка по току! Проверьте подключение двигателя к драйверу или проверьте двигатель на к/з, а затем перезагрузите драйвер.");
            } else if(comAnswer.m_charVal[0] == 2){
                emit sendCurrentAlarmDriver2_Error("Перенапряжение! Проверьте напряжение источника питания, а затем перезагрузите драйвер.");
            } else if(comAnswer.m_charVal[0] == 3){
                emit sendCurrentAlarmDriver2_Error("Ошибка схемы выборки тока! Перезагрузите драйвер.");
            } else if(comAnswer.m_charVal[0] == 4){
                emit sendCurrentAlarmDriver2_Error("Ошибка блокировки вала! Проверьте, не оборван ли провод двигателя.");
            } else if(comAnswer.m_charVal[0] == 5){
                emit sendCurrentAlarmDriver2_Error("Ошибка EEPROM! Подключите привод к программному обеспечению Leadshine, чтобы сбросить параметры до заводских.");
            } else if(comAnswer.m_charVal[0] == 6){
                emit sendCurrentAlarmDriver2_Error("Ошибка автоматической настройки! Перезагрузите драйвер.");
            } else if(comAnswer.m_charVal[0] == 7){
                emit sendCurrentAlarmDriver2_Error("Ошибка отправки пакета драйверу! Проверьте питание драйвера или подключение кабеля Ethernet.");
            }
        } else if(comAnswer.comand == 'b'){
            if(comAnswer.m_charVal[0] == 0){
                emit sendCurrentAlarmDriver1_OK("Текущих ошибок нет.");
            } else if(comAnswer.m_charVal[0] == 1){
                emit sendCurrentAlarmDriver1_Error("Перегрузка по току! Проверьте подключение двигателя к драйверу или проверьте двигатель на к/з, а затем перезагрузите драйвер.");
            } else if(comAnswer.m_charVal[0] == 2){
                emit sendCurrentAlarmDriver1_Error("Перенапряжение! Проверьте напряжение источника питания, а затем перезагрузите драйвер.");
            } else if(comAnswer.m_charVal[0] == 3){
                emit sendCurrentAlarmDriver1_Error("Ошибка схемы выборки тока! Перезагрузите драйвер.");
            } else if(comAnswer.m_charVal[0] == 4){
                emit sendCurrentAlarmDriver1_Error("Ошибка блокировки вала! Проверьте, не оборван ли провод двигателя.");
            } else if(comAnswer.m_charVal[0] == 5){
                emit sendCurrentAlarmDriver1_Error("Ошибка EEPROM! Подключите привод к программному обеспечению Leadshine, чтобы сбросить параметры до заводских.");
            } else if(comAnswer.m_charVal[0] == 6){
                emit sendCurrentAlarmDriver1_Error("Ошибка автоматической настройки! Перезагрузите драйвер.");
            } else if(comAnswer.m_charVal[0] == 7){
                emit sendCurrentAlarmDriver1_Error("Ошибка отправки пакета драйверу! Проверьте питание драйвера или подключение кабеля Ethernet.");
            }
        } else {
            emit sendOKMessage("Ошибок передачи команд через COM-порт нет.");
        }
    }
}

QString PlatformMovingController::getErrorMessage(unsigned char errorType)
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
    emit sendErrorMessage(errorText);
    return errorText;
}

void PlatformMovingController::errorCMD()
{
    PacketData packetToSend;
    preparePacket(packetToSend);
    packetToSend.comand = 'l';
    packetToSend.m_intVal = 2;
    m_currentMovingState = MB_ERROR;
    emit needToDisableControls(true);
    emit writeCommandToComPort(packetToSend);
//    qDebug()<<"errorCMD";
}

void PlatformMovingController::errorDATA()
{
    PacketData packetToSend;
    preparePacket(packetToSend);
    packetToSend.comand = 'a';
    packetToSend.m_intVal = 6;
    m_currentMovingState = MB_ERROR;
    emit needToDisableControls(true);
    emit writeCommandToComPort(packetToSend);
//    qDebug()<<"errorDATA";
}

void PlatformMovingController::motionStatusDriver1()
{
    PacketData packetToSend;
    preparePacket(packetToSend);
    packetToSend.comand = 'd';
    packetToSend.m_intVal = 1;
    m_currentMovingState = MB_ERROR;
    emit needToDisableControls(true);
    emit writeCommandToComPort(packetToSend);
    //    qDebug()<<"errorDATA";
}

void PlatformMovingController::motionStatusDriver2()
{
    PacketData packetToSend;
    preparePacket(packetToSend);
    packetToSend.comand = 'd';
    packetToSend.m_intVal = 2;
    m_currentMovingState = MB_ERROR;
    emit needToDisableControls(true);
    emit writeCommandToComPort(packetToSend);
    //    qDebug()<<"errorDATA";
}

void PlatformMovingController::currentAlarmDriver1()
{
    PacketData packetToSend;
    preparePacket(packetToSend);
    packetToSend.comand = 'b';
    packetToSend.m_intVal = 0;
    m_currentMovingState = MB_ERROR;
    emit needToDisableControls(true);
    emit writeCommandToComPort(packetToSend);
    //    qDebug()<<"errorDATA";
}

void PlatformMovingController::currentAlarmDriver2()
{
    PacketData packetToSend;
    preparePacket(packetToSend);
    packetToSend.comand = 'c';
    packetToSend.m_intVal = 0;
    m_currentMovingState = MB_ERROR;
    emit needToDisableControls(true);
    emit writeCommandToComPort(packetToSend);
    //    qDebug()<<"errorDATA";
}
