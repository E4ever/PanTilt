#include "mainwindow.h"
#include "ui_mainwindow.h"
#include "version.h"
#include <QStyleFactory>
#include <BaseTools/IniFileLoader.h>

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    m_movingController = nullptr;

    setupProject();
    //    qDebug()<<"Project setup end";
    initObjects();
    //    qDebug()<<"Objects were initted";
    setupGui();
    timer.start(100);
}

MainWindow::~MainWindow()
{
    delete m_comPortManager;
    delete m_movingController;
    delete ui;
}

void MainWindow::setupProject()
{
    m_title.append(VER_PRODUCTNAME_STR).append(" v_").append(VER_FILEVERSION_STR);
    QApplication::setStyle(QStyleFactory::create("Fusion"));
    ui->setupUi(this);
    this->setWindowTitle(m_title);
    m_settings = IniFileLoader::createSettingsObject(VER_PRODUCTNAME_STR);
}

void MainWindow::initObjects()
{
    m_comPortManager = new ComPortManager(m_settings->value("DeviceSettings/StmComPort").toString(), 115200);
    m_movingController = new PlatformMovingController(this, m_comPortManager);
    if(!m_comPortManager->connectionState()){
//        ui->labelMessage->setStyleSheet("color: red");
        ui->statusbar->setStyleSheet("color: red");
        showMessage("COM-порт не подключен!");
    }else{
//        ui->labelMessage->setStyleSheet("color: black");
        ui->statusbar->setStyleSheet("color: black");
        showMessage("COM-порт подключен.");
        //m_statusBarForm->setComPortManager(m_comPortManager);
        //m_statusBarForm->setSpectrometers(m_spectroManager->hss(), m_spectroManager->irSpectrometer(), m_spectroManager->skySpectrometer());
        //m_irSpectrometerTab->setComPortManager(m_comPortManager);
        //m_viewCamTab->setComPortManager(m_comPortManager);
        //connect(m_statusBarForm, SIGNAL(weatherParametrersUpdated()), m_irSpectrometerTab, SLOT(initShutterState()));
        //connect(m_irSpectrometerTab, SIGNAL(shutterIsReady()), m_viewCamTab, SLOT(initSpeeds()));
        //connect(m_viewCamTab, SIGNAL(comInitComplete()), SLOT(disconnectInitialSignals()));
    }
    connect(m_movingController, SIGNAL(sendTextMessage(QString)), SLOT(CMD_State_Label(QString)));
    connect(m_movingController, SIGNAL(sendOKMessage(QString)), SLOT(labelMessageOK(QString)));

    connect(m_movingController, SIGNAL(sendMotionStatusDriver1_Error(QString)), SLOT(motionStatusDriver1_Error(QString)));
    connect(m_movingController, SIGNAL(sendMotionStatusDriver1_OK(QString)), SLOT(motionStatusDriver1_OK(QString)));
    connect(m_movingController, SIGNAL(sendMotionStatusDriver2_Error(QString)), SLOT(motionStatusDriver2_Error(QString)));
    connect(m_movingController, SIGNAL(sendMotionStatusDriver2_OK(QString)), SLOT(motionStatusDriver2_OK(QString)));

    connect(m_movingController, SIGNAL(sendCurrentAlarmDriver1_Error(QString)), SLOT(currentAlarmDriver1_Error(QString)));
    connect(m_movingController, SIGNAL(sendCurrentAlarmDriver1_OK(QString)), SLOT(currentAlarmDriver1_OK(QString)));
    connect(m_movingController, SIGNAL(sendCurrentAlarmDriver2_Error(QString)), SLOT(currentAlarmDriver2_Error(QString)));
    connect(m_movingController, SIGNAL(sendCurrentAlarmDriver2_OK(QString)), SLOT(currentAlarmDriver2_OK(QString)));

    connect(m_movingController, SIGNAL(saveStatusToEEPROM_Driver1_OK(QString)), SLOT(readSaveStatusDriver1_OK(QString)));
    connect(m_movingController, SIGNAL(saveStatusToEEPROM_Driver1_Error(QString)), SLOT(readSaveStatusDriver1_Error(QString)));
    connect(m_movingController, SIGNAL(saveStatusToEEPROM_Driver2_OK(QString)), SLOT(readSaveStatusDriver2_OK(QString)));
    connect(m_movingController, SIGNAL(saveStatusToEEPROM_Driver2_Error(QString)), SLOT(readSaveStatusDriver2_Error(QString)));

    connect(m_movingController, SIGNAL(readDeviceID_signal(QString, ulong)), SLOT(readDevice_ID(QString, ulong)));

    connect(&timer, SIGNAL(timeout()), SLOT(readEncoderValue_timer()));

    connect(m_movingController, SIGNAL(readEncoderValue_signal(QString, ulong)), SLOT(readEncoderValue(QString, ulong)));

    connect(m_movingController, SIGNAL(sendTextMessage(QString)), SLOT(protocolErrorMessage(QString)));

    connect(m_movingController, SIGNAL(readTemp(float)), SLOT(readTemp_slot(float)));
    connect(m_movingController, SIGNAL(readPress(float)), SLOT(readPress_slot(float)));
    connect(m_movingController, SIGNAL(readHum(float)), SLOT(readHum_slot(float)));

    m_movingController->readDeviceID();

    //initExperimentMaker();
}

void MainWindow::setComPortManager(ComPortManager *comPortManager)
{
    m_movingController = new PlatformMovingController(this, comPortManager);
    connect(m_movingController, SIGNAL(needToDisableControls(bool)), SLOT(disableControls(bool)));
}

void MainWindow::setUpdatesNeeded(bool areUpdatesNeeded)
{
    m_areUpdatesNeeded = areUpdatesNeeded;
}

void MainWindow::disableControls(bool isNeedToDisable)
{
    ui->pushButtonDown->setDisabled(isNeedToDisable);
    ui->pushButtonUp->setDisabled(isNeedToDisable);
    ui->pushButtonStopTilt->setDisabled(isNeedToDisable);
    ui->pushButtonCCW->setDisabled(isNeedToDisable);
    ui->pushButtonCW->setDisabled(isNeedToDisable);
    ui->pushButtonStopPan->setDisabled(isNeedToDisable);
    //ui->spinBoxSpeedAzim->setDisabled(isNeedToDisable);
    //ui->spinBoxSpeedZen->setDisabled(isNeedToDisable);
}

void MainWindow::on_pushButtonUp_clicked()
{
    if(m_movingController != nullptr){
        m_movingController->moveUp();
//        qDebug()<<"Вверх.";
    }
}

void MainWindow::on_pushButtonDown_clicked()
{
    if(m_movingController != nullptr)
        m_movingController->moveDown();
}

void MainWindow::on_pushButtonCW_clicked()
{
    if(m_movingController != nullptr)
        m_movingController->moveCW();
}

void MainWindow::on_pushButtonCCW_clicked()
{
    if(m_movingController != nullptr)
        m_movingController->moveCCW();
}

void MainWindow::on_pushButtonStopPan_clicked()
{
    if(m_movingController != nullptr)
        m_movingController->stopPan();
}


void MainWindow::on_pushButtonStopTilt_clicked()
{
    if(m_movingController != nullptr)
        m_movingController->stopTilt();
}

void MainWindow::showMessage(QString message)
{
//    ui->labelMessage->setText(message);
    ui->statusbar->showMessage(message);
}

void MainWindow::on_spinBoxTiltSpeed_editingFinished()
{
    if(m_movingController != nullptr)
        if(m_currentPlatformTiltSpeed != ui->spinBoxTiltSpeed->value()){
            m_currentPlatformTiltSpeed = ui->spinBoxTiltSpeed->value();
            m_movingController->setZenithSpeed(ui->spinBoxTiltSpeed->value());
//            qDebug()<<ui->spinBoxTiltSpeed->value();
        }
}

void MainWindow::on_spinBoxPanSpeed_editingFinished()
{
    if(m_movingController != nullptr)
        if(m_currentPlatformPanSpeed != ui->spinBoxPanSpeed->value()){
            m_currentPlatformPanSpeed = ui->spinBoxPanSpeed->value();
            m_movingController->setAzimSpeed(ui->spinBoxPanSpeed->value());
//            qDebug()<<ui->spinBoxPanSpeed->value();
        }
}

void MainWindow::setupGui()
{
    m_currentPlatformPanSpeed = m_settings->value("DeviceSettings/AzimSpeed").toInt();
    m_currentPlatformTiltSpeed = m_settings->value("DeviceSettings/ZenSpeed").toInt();

    //    qDebug()<<"read"<<m_currentPlatformZenSpeed<<m_currentPlatformAzimSpeed;
    ui->spinBoxPanSpeed->setValue(m_currentPlatformPanSpeed);
    ui->spinBoxTiltSpeed->setValue(m_currentPlatformTiltSpeed);

//    m_movingController->setAzimSpeed(ui->spinBoxPanSpeed->value());
//    m_movingController->setZenithSpeed(ui->spinBoxTiltSpeed->value());

    ui->labelPanSpeed->setText("Скорость:");
    ui->labelTiltSpeed->setText("Скорость:");

    ui->labelPanIteration->setText("Кол-во итераций:");
    ui->labelTiltIteration->setText("Кол-во итераций:");

    ui->labelInfo_1->setText("Непрерывное движение:");
    ui->labelInfo_2->setText("Движение итерациями:");

    ui->labelCMDState->setText("Ошибок передачи команд через COM-порт нет.");
    ui->labelCMDState->setWordWrap(true);

    ui->labelMotionStatusDriver1->setText("Состояние работы 1-го драйвера.");
    ui->labelMotionStatusDriver1->setWordWrap(true);
    ui->labelMotionStatusDriver2->setText("Состояние работы 2-го драйвера.");
    ui->labelMotionStatusDriver2->setWordWrap(true);

    ui->labelCurrentAlarmDriver1->setText("Текущая ошибка 1-го драйвера.");
    ui->labelCurrentAlarmDriver1->setWordWrap(true);
    ui->labelCurrentAlarmDriver2->setText("Текущая ошибка 2-го драйвера.");
    ui->labelCurrentAlarmDriver2->setWordWrap(true);

    ui->labelSaveStatusToEEPROM_Dr1->setWordWrap(true);
    ui->labelSaveStatusToEEPROM_Dr2->setWordWrap(true);

    ui->labelEncoder->setText(" -");

//    ui->labelCam->setScaledContents(true);
//    ui->labelCam->setStyleSheet("color: black;"
//                                "background-color: white");
//    ui->labelCam->setFont(QFont("Helvetica", 16));
//    ui->labelCam->setText("Cameras connection.\nPlease, wait...");
//    ui->labelCam->setAlignment(Qt::AlignCenter);
}


void MainWindow::on_pushButtonUpIteration_clicked()
{
    if(m_movingController != nullptr)
        m_movingController->moveUpIteration();
}


void MainWindow::on_pushButtonStopTiltIteration_clicked()
{
    if(m_movingController != nullptr)
        m_movingController->stopTiltIteration();
}


void MainWindow::on_pushButtonDownIteration_clicked()
{
    if(m_movingController != nullptr)
        m_movingController->moveDownIteration();
}


void MainWindow::on_pushButtonCCWIteration_clicked()
{
    if(m_movingController != nullptr)
        m_movingController->moveCCWIteration();
}


void MainWindow::on_pushButtonStopPanIteration_clicked()
{
    if(m_movingController != nullptr)
        m_movingController->stopPanIteration();
}


void MainWindow::on_pushButtonCWIteration_clicked()
{
    if(m_movingController != nullptr)
        m_movingController->moveCWIteration();
}


void MainWindow::on_spinBoxPanIteration_editingFinished()
{
    if(m_movingController != nullptr)
        if(m_currentPlatformPanIteration != ui->spinBoxPanIteration->value()){
            m_currentPlatformPanIteration = ui->spinBoxPanIteration->value();
//            qDebug()<<m_currentPlatformPanIteration;
            m_movingController->setNumberOfIterationPan(ui->spinBoxPanIteration->value());
//            qDebug()<<ui->spinBoxTiltSpeed->value();
        }
}


void MainWindow::on_spinBoxTiltIteration_editingFinished()
{
    if(m_movingController != nullptr)
        if(m_currentPlatformTiltIteration != ui->spinBoxTiltIteration->value()){
            m_currentPlatformTiltIteration = ui->spinBoxTiltIteration->value();
//            qDebug()<<m_currentPlatformTiltIteration;
            m_movingController->setNumberOfIterationTilt(ui->spinBoxTiltIteration->value());
//            qDebug()<<ui->spinBoxTiltSpeed->value();
        }
}

void MainWindow::CMD_State_Label(QString text){
    ui->labelCMDState->setStyleSheet("color: red");
    ui->labelCMDState->setText(text);
}

void MainWindow::labelMessageOK(QString text){
    ui->labelCMDState->setStyleSheet("color: black");
    ui->labelCMDState->setText(text);
}

void MainWindow::on_pushButtonErrorCMD_clicked()
{
    if(m_movingController != nullptr)
        m_movingController->errorCMD();
}

void MainWindow::on_pushButtonErrorDATA_clicked()
{
    if(m_movingController != nullptr)
        m_movingController->errorDATA();
}

void MainWindow::on_pushButtonMotionStatusDriver1_clicked()
{
    if(m_movingController != nullptr)
        m_movingController->motionStatusDriver1();
}

void MainWindow::on_pushButtonMotionStatusDriver2_clicked()
{
    if(m_movingController != nullptr)
        m_movingController->motionStatusDriver2();
}

void MainWindow::motionStatusDriver1_Error(QString text){
    ui->labelMotionStatusDriver1->setStyleSheet("color: red");
    ui->labelMotionStatusDriver1->setText(text);
}

void MainWindow::motionStatusDriver1_OK(QString text){
    ui->labelMotionStatusDriver1->setStyleSheet("color: black");
    ui->labelMotionStatusDriver1->setText(text);
}

void MainWindow::motionStatusDriver2_Error(QString text){
    ui->labelMotionStatusDriver2->setStyleSheet("color: red");
    ui->labelMotionStatusDriver2->setText(text);
}

void MainWindow::motionStatusDriver2_OK(QString text){
    ui->labelMotionStatusDriver2->setStyleSheet("color: black");
    ui->labelMotionStatusDriver2->setText(text);
}

void MainWindow::on_pushButtonCurrentAlarmDriver1_clicked()
{
    if(m_movingController != nullptr)
        m_movingController->currentAlarmDriver1();
}

void MainWindow::on_pushButtonCurrentAlarmDriver2_clicked()
{
    if(m_movingController != nullptr)
        m_movingController->currentAlarmDriver2();
}

void MainWindow::currentAlarmDriver1_Error(QString text){
    ui->labelCurrentAlarmDriver1->setStyleSheet("color: red");
    ui->labelCurrentAlarmDriver1->setText(text);
}

void MainWindow::currentAlarmDriver1_OK(QString text){
    ui->labelCurrentAlarmDriver1->setStyleSheet("color: black");
    ui->labelCurrentAlarmDriver1->setText(text);
}

void MainWindow::currentAlarmDriver2_Error(QString text){
    ui->labelCurrentAlarmDriver2->setStyleSheet("color: red");
    ui->labelCurrentAlarmDriver2->setText(text);
}

void MainWindow::currentAlarmDriver2_OK(QString text){
    ui->labelCurrentAlarmDriver2->setStyleSheet("color: black");
    ui->labelCurrentAlarmDriver2->setText(text);
}

void MainWindow::on_pushButtonSaveParamToEEPROM_Dr1_clicked()
{
    if(m_movingController != nullptr)
        m_movingController->saveToEEPROM_Driver1();
}


void MainWindow::on_pushButtonSaveParamToEEPROM_Dr2_clicked()
{
    if(m_movingController != nullptr)
        m_movingController->saveToEEPROM_Driver2();
}


void MainWindow::on_pushButtonResetParam_Dr1_clicked()
{
    if(m_movingController != nullptr)
        m_movingController->resetParam_Driver1();
}


void MainWindow::on_pushButtonResetParam_Dr2_clicked()
{
    if(m_movingController != nullptr)
        m_movingController->resetParam_Driver2();
}


void MainWindow::on_pushButtonResetAllParam_Dr1_clicked()
{
    if(m_movingController != nullptr)
        m_movingController->resetAllParam_Driver1();
}


void MainWindow::on_pushButtonResetAllParam_Dr2_clicked()
{
    if(m_movingController != nullptr)
        m_movingController->resetAllParam_Driver2();
}


void MainWindow::on_pushButtonReadSaveStatus_Dr1_clicked()
{
    if(m_movingController != nullptr)
        m_movingController->readSaveStatus_Driver1();
}


void MainWindow::on_pushButtonReadSaveStatus_Dr2_clicked()
{
    if(m_movingController != nullptr)
        m_movingController->readSaveStatus_Driver2();
}

void MainWindow::readSaveStatusDriver1_OK(QString text)
{
    ui->labelSaveStatusToEEPROM_Dr1->setStyleSheet("color: black");
    ui->labelSaveStatusToEEPROM_Dr1->setText(text);
}

void MainWindow::readSaveStatusDriver1_Error(QString text)
{
    ui->labelSaveStatusToEEPROM_Dr1->setStyleSheet("color: red");
    ui->labelSaveStatusToEEPROM_Dr1->setText(text);
}

void MainWindow::readSaveStatusDriver2_OK(QString text)
{
    ui->labelSaveStatusToEEPROM_Dr2->setStyleSheet("color: black");
    ui->labelSaveStatusToEEPROM_Dr2->setText(text);
}

void MainWindow::readSaveStatusDriver2_Error(QString text)
{
    ui->labelSaveStatusToEEPROM_Dr2->setStyleSheet("color: red");
    ui->labelSaveStatusToEEPROM_Dr2->setText(text);
}

void MainWindow::readDevice_ID(QString text, unsigned long id){
    ui->labelDeviceID->setText(text.append(" " + QString::number(id)));
}

void MainWindow::on_pushButtonDCMotorCCW_clicked()
{
    if(m_movingController != nullptr)
        m_movingController->DC_motor_CCW();
}


void MainWindow::on_pushButtonDCMotorStop_clicked()
{
    if(m_movingController != nullptr)
        m_movingController->DC_motor_stop();
}


void MainWindow::on_pushButtonDCMotorCW_clicked()
{
    if(m_movingController != nullptr)
        m_movingController->DC_motor_CW();
}


void MainWindow::on_pushButtonEncoder_clicked()
{
    if(m_movingController != nullptr)
        m_movingController->readEncoderValue();
}

void MainWindow::readEncoderValue(QString text, unsigned long enc_value){
    ui->labelEncoder->setText(text.append(" " + QString::number(enc_value)));
}

void MainWindow::readEncoderValue_timer()
{
    if(m_movingController != nullptr)
        m_movingController->readEncoderValue();
}

void MainWindow::protocolErrorMessage(QString text){
    ui->labelCMDState->setStyleSheet("color: red");
    ui->labelCMDState->setText(text);
}

void MainWindow::on_pushButtonTemp1_clicked()
{
    if(m_movingController != nullptr)
        m_movingController->readTemp1();
}


void MainWindow::on_pushButtonTemp2_clicked()
{
    if(m_movingController != nullptr)
        m_movingController->readTemp2();
}


void MainWindow::on_pushButtonPress1_clicked()
{
    if(m_movingController != nullptr)
        m_movingController->readPress1();
}


void MainWindow::on_pushButtonPress2_clicked()
{
    if(m_movingController != nullptr)
        m_movingController->readPress2();
}


void MainWindow::on_pushButtonHum1_clicked()
{
    if(m_movingController != nullptr)
        m_movingController->readHum1();
}


void MainWindow::on_pushButtonHum2_clicked()
{
    if(m_movingController != nullptr)
        m_movingController->readHum2();
}


void MainWindow::on_pushButtonShutOpen_clicked()
{
    if(m_movingController != nullptr)
        m_movingController->shutterOpen();
}


void MainWindow::on_pushButtonShutClose_clicked()
{
    if(m_movingController != nullptr)
        m_movingController->shutterClose();
}

void MainWindow::readTemp_slot(float temp)
{
    ui->labelTemp1->setText(QString::number(temp));
    ui->labelTemp2->setText(QString::number(temp));
}

void MainWindow::readPress_slot(float press)
{
    ui->labelPress1->setText(QString::number(press));
    ui->labelPress2->setText(QString::number(press));
}

void MainWindow::readHum_slot(float hum)
{
    ui->labelHum1->setText(QString::number(hum));
    ui->labelHum2->setText(QString::number(hum));
}
