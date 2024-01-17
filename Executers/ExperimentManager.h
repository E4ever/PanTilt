#ifndef EXPERIMENTMANAGER_H
#define EXPERIMENTMANAGER_H

#include <QObject>
//#include <SpectroDevices/BaseSpectrometer.h>
//#include <GuiModules/CameraWidgets/IpCameraModule.h>
#include <Executers/PlatformMovingController.h>
#include <Executers/WeatherParametersController.h>
//#include <Executers/IrSpecShootingModule.h>
//#include <SpectroDevices/SpectroManager.h>

/**
 * @brief The ExperimentManager class
 * The class to make shooting experiment for hypercube getting
 */
class ExperimentManager : public QObject
{
    Q_OBJECT
public:

    explicit ExperimentManager(//SpectroManager *spectroManager,
                               //IpCameraModule *overviewCamera,
                               //IpCameraModule *skyCamera,
                               PlatformMovingController *movingModule,
                               WeatherParametersController *weatherController);
                               //IrSpecShootingModule *shutterControlller);

public slots:
    /**
     * @brief startExperiment   Function to start the experiment
     */
    void startExperiment();

signals:
    /**
     * @brief experimentProgressChanged Signal for sending information about experiment progress
     * @param percent   Current progress percent
     */
    void experimentProgressChanged(int percent);

private:
    int m_iterationsCount;                  //!< Count of iterations for experiment
    //BaseSpectrometer *m_irSpectrometer;     //!< The spectrometer for IR data processing (Ormin device)
    //BaseSpectrometer *m_skySpectrometer;    //!< The spectrometer for sky information getting (FTDI device)
    //BaseSpectrometer *m_visSpectrometer;    //!< The spectrometer for visible data drocessing (QHY device)
    //IpCameraModule *m_overviewCamera;       //!< The camera for connecting spectrometers FOV to hypercube
    //IpCameraModule *m_skyCamera;            //!< The camera to analyse clouds intencity
    PlatformMovingController *m_movingModule;   //!< The module for the platform rotation control
    WeatherParametersController *m_weatherController;   //!< The module for the weather parameters controlling
    //IrSpecShootingModule *m_shutterController;  //!< The module for the IR spectrometer shutter controlling
};

#endif // EXPERIMENTMANAGER_H
