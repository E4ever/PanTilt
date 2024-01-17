QT       += core gui multimedia multimediawidgets serialport concurrent

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets printsupport

CONFIG += c++11

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

TARGET = PanTilt
TEMPLATE = app
RC_FILE = recource.rc

SOURCES += \
    BaseTools/IniFileLoader.cpp \
    BaseTools/QrcFilesRestorer.cpp \
    Executers/BaseExecutingModule.cpp \
    Executers/ComPortInterface.cpp \
    Executers/ExperimentManager.cpp \
    Executers/PlatformMovingController.cpp \
    Executers/WeatherParametersController.cpp \
    ExtraDevices/BaseComPort.cpp \
    ExtraDevices/ComPortManager.cpp \
    main.cpp \
    mainwindow.cpp

HEADERS += \
    BaseTools/IniFileLoader.h \
    BaseTools/QrcFilesRestorer.h \
    Executers/BaseExecutingModule.h \
    Executers/ComPortInterface.h \
    Executers/ExperimentManager.h \
    Executers/PlatformMovingController.h \
    Executers/WeatherParametersController.h \
    ExtraDevices/BaseComPort.h \
    ExtraDevices/ComPortManager.h \
    Include/CommonTypes.h \
    mainwindow.h \
    version.h

FORMS += \
    mainwindow.ui

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

RESOURCES += \
    res.qrc
