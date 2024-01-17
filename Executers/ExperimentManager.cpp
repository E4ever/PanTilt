#include "ExperimentManager.h"

ExperimentManager::ExperimentManager(//SpectroManager *spectroManager,
                                     //IpCameraModule *overviewCamera,
                                     //IpCameraModule *skyCamera,
                                     PlatformMovingController *movingModule,
                                    WeatherParametersController *weatherController)
                                     //IrSpecShootingModule *shutterControlller)
    : QObject{}
{
    m_iterationsCount = 5;
    //m_irSpectrometer = spectroManager->irSpectrometer();
    //m_skySpectrometer = spectroManager->skySpectrometer();
    //m_visSpectrometer = spectroManager->hss();
    //m_overviewCamera = overviewCamera;
    //m_skyCamera = skyCamera;
    m_movingModule = movingModule;
    m_weatherController = weatherController;
    //m_shutterController = shutterControlller;
}

void ExperimentManager::startExperiment()
{
    qDebug()<<"Experiment start";
}
