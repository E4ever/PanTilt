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
        if(comAnswer.comand == 'e' && comAnswer.m_charVal[0] == 'v'){
            emit sendTextMessage(getErrorMessage(comAnswer.m_charVal[1]));
        } else if(comAnswer.comand == 'e' && comAnswer.m_charVal[0] == 'm'){
            emit sendTextMessage(getErrorMessageModbus(comAnswer.m_charVal[1]));
        } else if(comAnswer.comand == 'a' || comAnswer.comand == 'w'){
            m_currentMovingState = NO_PARAMETER;
            emit needToDisableControls(false);
            emit sendOKMessage("Ошибок передачи команд через COM-порт нет.");
        } else if(comAnswer.comand == 'd'){
            if(comAnswer.m_intVal == 0){
                emit sendMotionStatusDriver1_Error("Отсутствует подключение шагового двигателя к драйверу! Проверьте подключение.");
            } else if(comAnswer.m_intVal == 1){
                emit sendMotionStatusDriver1_OK("Шаговый двигатель в режиме движения.");
            } else if(comAnswer.m_intVal == 2){
                emit sendMotionStatusDriver1_OK("Шаговый двигатель в режиме ожидания.");
            } else if(comAnswer.m_intVal == 3){
                emit sendMotionStatusDriver2_Error("Отсутствует подключение шагового двигателя к драйверу! Проверьте подключение.");
            } else if(comAnswer.m_intVal == 4){
                emit sendMotionStatusDriver2_OK("Шаговый двигатель в режиме движения.");
            } else if(comAnswer.m_intVal == 5){
                emit sendMotionStatusDriver2_OK("Шаговый двигатель в режиме ожидания.");
            }
        } else if(comAnswer.comand == 'b'){
            if(comAnswer.m_intVal == 0){
                emit sendCurrentAlarmDriver1_OK("Текущих ошибок нет.");
            } else if(comAnswer.m_intVal == 1){
                emit sendCurrentAlarmDriver1_Error("Перегрузка по току! Проверьте подключение двигателя к драйверу или проверьте двигатель на к/з, а затем перезагрузите драйвер.");
            } else if(comAnswer.m_intVal == 2){
                emit sendCurrentAlarmDriver1_Error("Перенапряжение! Проверьте напряжение источника питания, а затем перезагрузите драйвер.");
            } else if(comAnswer.m_intVal == 3){
                emit sendCurrentAlarmDriver1_Error("Ошибка схемы выборки тока! Перезагрузите драйвер.");
            } else if(comAnswer.m_intVal == 4){
                emit sendCurrentAlarmDriver1_Error("Ошибка блокировки вала! Проверьте, не оборван ли провод двигателя.");
            } else if(comAnswer.m_intVal == 5){
                emit sendCurrentAlarmDriver1_Error("Ошибка EEPROM! Подключите привод к программному обеспечению Leadshine, чтобы сбросить параметры до заводских.");
            } else if(comAnswer.m_intVal == 6){
                emit sendCurrentAlarmDriver1_Error("Ошибка автоматической настройки! Перезагрузите драйвер.");
            } else if(comAnswer.m_intVal == 7){
                emit sendCurrentAlarmDriver2_OK("Текущих ошибок нет.");
            } else if(comAnswer.m_intVal == 8){
                emit sendCurrentAlarmDriver2_Error("Перегрузка по току! Проверьте подключение двигателя к драйверу или проверьте двигатель на к/з, а затем перезагрузите драйвер.");
            } else if(comAnswer.m_intVal == 9){
                emit sendCurrentAlarmDriver2_Error("Перенапряжение! Проверьте напряжение источника питания, а затем перезагрузите драйвер.");
            } else if(comAnswer.m_intVal == 10){
                emit sendCurrentAlarmDriver2_Error("Ошибка схемы выборки тока! Перезагрузите драйвер.");
            } else if(comAnswer.m_intVal == 11){
                emit sendCurrentAlarmDriver2_Error("Ошибка блокировки вала! Проверьте, не оборван ли провод двигателя.");
            } else if(comAnswer.m_intVal == 12){
                emit sendCurrentAlarmDriver2_Error("Ошибка EEPROM! Подключите привод к программному обеспечению Leadshine, чтобы сбросить параметры до заводских.");
            } else if(comAnswer.m_intVal == 13){
                emit sendCurrentAlarmDriver2_Error("Ошибка автоматической настройки! Перезагрузите драйвер.");
            }
        } else if(comAnswer.comand == 'r'){
            if(comAnswer.m_intVal == 0){
                emit saveStatusToEEPROM_Driver1_OK("Сохранение прошло успешно.");
            } else if(comAnswer.m_intVal == 1){
                emit saveStatusToEEPROM_Driver1_Error("Ошибка сохранения!");
            } else if(comAnswer.m_intVal == 2){
                emit saveStatusToEEPROM_Driver1_OK("Сохранения не проводилось.");
            } else if(comAnswer.m_intVal == 3){
                emit saveStatusToEEPROM_Driver2_OK("Сохранение прошло успешно.");
            } else if(comAnswer.m_intVal == 4){
                emit saveStatusToEEPROM_Driver2_Error("Ошибка сохранения!");
            } else if(comAnswer.m_intVal == 5){
                emit saveStatusToEEPROM_Driver2_OK("Сохранения не проводилось.");
            }
        } else if(comAnswer.comand == 'i'){
            emit readDeviceID_signal("Идентификатор устройства: ", comAnswer.m_intVal);
        } else if(comAnswer.comand == 'q'){
            emit readEncoderValue_signal("Значение энкодера: ", comAnswer.m_intVal);
        } else if(comAnswer.comand == 't'){
            emit readTemp(comAnswer.m_floatVal);
        } else if(comAnswer.comand == 'p'){
            emit readPress(comAnswer.m_floatVal);
        } else if(comAnswer.comand == 'h'){
            emit readHum(comAnswer.m_floatVal);
        } else {
            emit sendOKMessage("Ошибок передачи команд через COM-порт нет.");
        }
    }
}

QString PlatformMovingController::getErrorMessage(unsigned char errorType)
{
    QString errorText("Ошибка передачи команды через COM-порт: ");
    if(errorType == 'c'){
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

QString PlatformMovingController::getErrorMessageModbus(unsigned char errorType)
{
    QString errorText("Ошибка передачи команды по протоколу Modbus: ");
    if(errorType == 'c'){
        errorText.append("неверная контрольная сумма!");
    }else if(errorType == 't'){
        errorText.append("превышено время ожидания ответа!");
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
    packetToSend.m_intVal = 0;
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
    packetToSend.m_intVal = 1;
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
    packetToSend.comand = 'b';
    packetToSend.m_intVal = 1;
    m_currentMovingState = MB_ERROR;
    emit needToDisableControls(true);
    emit writeCommandToComPort(packetToSend);
    //    qDebug()<<"errorDATA";
}

void PlatformMovingController::saveToEEPROM_Driver1()
{
    PacketData packetToSend;
    preparePacket(packetToSend);
    packetToSend.comand = 'f';
    packetToSend.m_intVal = 2;
    m_currentMovingState = SAVE_TO_EEPROM;
    emit needToDisableControls(true);
    emit writeCommandToComPort(packetToSend);
    //    qDebug()<<"errorDATA";
}

void PlatformMovingController::saveToEEPROM_Driver2()
{
    PacketData packetToSend;
    preparePacket(packetToSend);
    packetToSend.comand = 'f';
    packetToSend.m_intVal = 8;
    m_currentMovingState = SAVE_TO_EEPROM;
    emit needToDisableControls(true);
    emit writeCommandToComPort(packetToSend);
    //    qDebug()<<"errorDATA";
}

void PlatformMovingController::resetParam_Driver1()
{
    PacketData packetToSend;
    preparePacket(packetToSend);
    packetToSend.comand = 'f';
    packetToSend.m_intVal = 3;
    m_currentMovingState = RESET_PARAM;
    emit needToDisableControls(true);
    emit writeCommandToComPort(packetToSend);
    //    qDebug()<<"errorDATA";
}

void PlatformMovingController::resetParam_Driver2()
{
    PacketData packetToSend;
    preparePacket(packetToSend);
    packetToSend.comand = 'f';
    packetToSend.m_intVal = 9;
    m_currentMovingState = RESET_PARAM;
    emit needToDisableControls(true);
    emit writeCommandToComPort(packetToSend);
    //    qDebug()<<"errorDATA";
}

void PlatformMovingController::resetAllParam_Driver1()
{
    PacketData packetToSend;
    preparePacket(packetToSend);
    packetToSend.comand = 'f';
    packetToSend.m_intVal = 4;
    m_currentMovingState = RESET_ALL_PARAM;
    emit needToDisableControls(true);
    emit writeCommandToComPort(packetToSend);
    //    qDebug()<<"errorDATA";
}

void PlatformMovingController::resetAllParam_Driver2()
{
    PacketData packetToSend;
    preparePacket(packetToSend);
    packetToSend.comand = 'f';
    packetToSend.m_intVal = 10;
    m_currentMovingState = RESET_ALL_PARAM;
    emit needToDisableControls(true);
    emit writeCommandToComPort(packetToSend);
    //    qDebug()<<"errorDATA";
}

void PlatformMovingController::readSaveStatus_Driver1()
{
    PacketData packetToSend;
    preparePacket(packetToSend);
    packetToSend.comand = 'r';
    packetToSend.m_intVal = 0;
    m_currentMovingState = READ_SAVE_STATUS;
    emit needToDisableControls(true);
    emit writeCommandToComPort(packetToSend);
    //    qDebug()<<"errorDATA";
}

void PlatformMovingController::readSaveStatus_Driver2()
{
    PacketData packetToSend;
    preparePacket(packetToSend);
    packetToSend.comand = 'r';
    packetToSend.m_intVal = 1;
    m_currentMovingState = READ_SAVE_STATUS;
    emit needToDisableControls(true);
    emit writeCommandToComPort(packetToSend);
    //    qDebug()<<"errorDATA";
}

void PlatformMovingController::readDeviceID()
{
    PacketData packetToSend;
    preparePacket(packetToSend);
    packetToSend.comand = 'i';
    packetToSend.m_intVal = 0;
    m_currentMovingState = READ_DEVICE_ID;
    emit needToDisableControls(true);
    emit writeCommandToComPort(packetToSend);
    //    qDebug()<<"errorDATA";
}

void PlatformMovingController::DC_motor_stop()
{
    PacketData packetToSend;
    preparePacket(packetToSend);
    packetToSend.comand = 'g';
    packetToSend.m_intVal = 0;
    m_currentMovingState = DC_MOTOR_CONTROL;
    emit needToDisableControls(true);
    emit writeCommandToComPort(packetToSend);
    //    qDebug()<<"errorDATA";
}

void PlatformMovingController::DC_motor_CW()
{
    PacketData packetToSend;
    preparePacket(packetToSend);
    packetToSend.comand = 'g';
    packetToSend.m_intVal = 2;
    m_currentMovingState = DC_MOTOR_CONTROL;
    emit needToDisableControls(true);
    emit writeCommandToComPort(packetToSend);
    //    qDebug()<<"errorDATA";
}

void PlatformMovingController::DC_motor_CCW()
{
    PacketData packetToSend;
    preparePacket(packetToSend);
    packetToSend.comand = 'g';
    packetToSend.m_intVal = 1;
    m_currentMovingState = DC_MOTOR_CONTROL;
    emit needToDisableControls(true);
    emit writeCommandToComPort(packetToSend);
    //    qDebug()<<"errorDATA";
}

void PlatformMovingController::readEncoderValue()
{
    PacketData packetToSend;
    preparePacket(packetToSend);
    packetToSend.comand = 'q';
    packetToSend.m_intVal = 0;
    m_currentMovingState = READ_ENCODER_VALUE;
    emit needToDisableControls(true);
    emit writeCommandToComPort(packetToSend);
    //    qDebug()<<"errorDATA";
}

void PlatformMovingController::readTemp1()
{
    PacketData packetToSend;
    preparePacket(packetToSend);
    packetToSend.comand = 't';
    packetToSend.m_intVal = 0;
    m_currentMovingState = READ_TEMP;
    emit needToDisableControls(true);
    emit writeCommandToComPort(packetToSend);
    //    qDebug()<<"errorDATA";
}

void PlatformMovingController::readTemp2()
{
    PacketData packetToSend;
    preparePacket(packetToSend);
    packetToSend.comand = 't';
    packetToSend.m_intVal = 1;
    m_currentMovingState = READ_TEMP;
    emit needToDisableControls(true);
    emit writeCommandToComPort(packetToSend);
    //    qDebug()<<"errorDATA";
}

void PlatformMovingController::readPress1()
{
    PacketData packetToSend;
    preparePacket(packetToSend);
    packetToSend.comand = 'p';
    packetToSend.m_intVal = 0;
    m_currentMovingState = READ_PRESS;
    emit needToDisableControls(true);
    emit writeCommandToComPort(packetToSend);
    //    qDebug()<<"errorDATA";
}

void PlatformMovingController::readPress2()
{
    PacketData packetToSend;
    preparePacket(packetToSend);
    packetToSend.comand = 'p';
    packetToSend.m_intVal = 1;
    m_currentMovingState = READ_PRESS;
    emit needToDisableControls(true);
    emit writeCommandToComPort(packetToSend);
    //    qDebug()<<"errorDATA";
}

void PlatformMovingController::readHum1()
{
    PacketData packetToSend;
    preparePacket(packetToSend);
    packetToSend.comand = 'h';
    packetToSend.m_intVal = 0;
    m_currentMovingState = READ_HUM;
    emit needToDisableControls(true);
    emit writeCommandToComPort(packetToSend);
    //    qDebug()<<"errorDATA";
}

void PlatformMovingController::readHum2()
{
    PacketData packetToSend;
    preparePacket(packetToSend);
    packetToSend.comand = 'h';
    packetToSend.m_intVal = 1;
    m_currentMovingState = READ_HUM;
    emit needToDisableControls(true);
    emit writeCommandToComPort(packetToSend);
    //    qDebug()<<"errorDATA";
}

void PlatformMovingController::shutterOpen()
{
    PacketData packetToSend;
    preparePacket(packetToSend);
    packetToSend.comand = 's';
    packetToSend.m_intVal = 1;
    m_currentMovingState = SHUT_CONTROL;
    emit needToDisableControls(true);
    emit writeCommandToComPort(packetToSend);
    //    qDebug()<<"errorDATA";
}

void PlatformMovingController::shutterClose()
{
    PacketData packetToSend;
    preparePacket(packetToSend);
    packetToSend.comand = 's';
    packetToSend.m_intVal = 0;
    m_currentMovingState = SHUT_CONTROL;
    emit needToDisableControls(true);
    emit writeCommandToComPort(packetToSend);
    //    qDebug()<<"errorDATA";
}
