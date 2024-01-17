#pragma once
#ifndef COMMONTYPES_H
#define COMMONTYPES_H
#include <QString>
#include <QVector>
#include <QMetaType>
#include <QDateTime>


    enum Owner{

        IAPP_OF_BSU
    };

    /**
     * @brief The SpectrometerType enum
     * Enum with Spectrometer Types
     *
     * HSS_SPECTROMETER     HSS spectrometer (hyperspectral system)
     * FTDI_SPECTROMETER    Spectrometer using FTDI-drivers (FSR, SSP and etc.)
     * ORMIN_SPECTROMETER   Spectrometer using Ormin device (while no common solar device)
     * STM_SPECTROMETER     Spectrometer based on STM device
     * QHY_SPECTROMETER     Spectrometer based on QHY device
     * UNKNOWN_SPECTROMETER Unknown version
     */
    enum SpectrometerType {
       HSS_SPECTROMETER,
       FTDI_SPECTROMETER,
       ORMIN_SPECTROMETER,
       STM_SPECTROMETER,
       QHY_SPECTROMETER,
       UNKNOWN_SPECTROMETER
    };

    static const QStringList SPECTROMETER_NAMES = {"HSS", "FTDI", "ORMIN", "STM", "QHY", "UNKNOWN"};

    /**
     * @brief The IpCameraType enum
     * Enum with camera types
     *
     *  IP_NAN          IP camera was not defined
     *  IP_OVERVIEW     IP camera needed for spectrometers fields of view showing
     *  IP_SKY          IP camera needed for a cloud situation showing
     */
    enum IpCameraType{
        IP_NAN,
        IP_OVERVIEW,
        IP_SKY
    };

    static const QStringList IP_CAMERAS_NAMES = {"Undefined Camera", "Overview Camera", "Sky Camera"};

    /**
     * @brief The BandUnits enum
     * Enum of bands units in spectrum
     *
     * BU_NUMBERS     Numbers of bands
     * BU_WAVELENGTH  Waves, nm
     */
    enum BandUnits{

        BU_NUMBERS,
        BU_WAVELENGTH
    };

    /**
     * @brief The SpectrumUnits enum
     * Enum of graph units in spectrum
     *
     * SU_ADC       ADC units
     * SU_RFL       Reflectance (from 0 to 1)
     * SU_BRIGHT    Brightness (from 0 to 1)
     */
    enum SpectrumUnits{

        SU_ADC,
        SU_RFL,
        SU_BRIGHT
    };

    /**
     * @brief The ShutterState enum
     * Enom of shutter states
     */
    enum ShutterState{
        SHUTTER_CLOSED, SHUTTER_OPENED, SHUTTER_CHANGING
    };

    /**
     * @brief The Spectrum struct
     * Structure of spectrum data
     */
    struct Spectrum{

        Owner           owner;      //!< Owner of the spectra data
        QDateTime       dateTime;   //!< Spectrum date time
        QString         name;       //!< Spectrum name
        double          expoMs;     //!< Exposition in spectrum
        BandUnits       bandsUnits; //!< Bands values
        SpectrumUnits   graphUnits; //!< Graph values
        QVector<double> bands;      //!< Vector of wavelength
        QVector<double> data;       //!< Vector of Spectrum data
        double maxInSpectrum;       //!< Maximum value in spectrum

    };

    /**
     * @brief The SpectrometerSettingsType enum
     * Enum of base spectrometer settings types
     *
     * EXPOSITION               Exposition settings
     * COUNT_IN_SERIES          Count of spectrums while series shooting is chosen
     * CALIBRATION_FILE_PATH    Path to calibration file (actual for FTDI device)
     * IS_NEED2SAVE_MEAN        Is need to calculate and save mean spectrums
     */
    enum SpectrometerSettingsType {

        EXPOSITION,
        COUNT_IN_SERIES,
        CALIBRATION_FILE_PATH,
        IS_NEED2SAVE_MEAN

    };

    enum SavingMode{
        SAVING_TXT,
        SAVING_JSON
    };

    /**
     * @brief The CurrentLocation struct
     * Sctructure needed to contain coordinates
     */
    struct CurrentLocation
    {
        double longitude;  //!< Longtitude
        double latitude;   //!< Latitude
    };

    /**
     * @brief The SunCoordinates struct
     * Sctructure needed to contain sun coordinates
     */
    struct SunCoordinates
    {
        double zenithAngle;     //!< Zenith angle
        double azimuth;         //!< azimuth
    };

    /**
     * @brief The GpsData struct
     * Structure to combine GPS data
     */
    struct GpsData{
        QString utcTime;      //!< UTC time from GPS
        QString utcDate;      //!< UTC date from GPS
        QString latitude;     //!< Latitude from GPS
        QString longitude;    //!< Longitude from GPS
        QString altitude;     //!< Altitude from GPS
        QString speed;        //!< Speed from GPS
        QString azimutAngle;  //!< Azimuth angle from GPS
        QString sunAngle;     //!< Sun angle
    };

    /**
     * @brief The SpectrMode enum
     * Enum with spectrometer shooting modes
     *
     * SM_SINGLE            Single spectrum mode
     * SM_SERIES            Series spectrum mode
     * SM_CONTINUOUS        Continious shooting mode
     * SM_NOSHOOTING        No shooting mode
     */
    enum SpectrMode {
        SM_SINGLE,
        SM_SERIES,
        SM_CONTINUOUS,
        SM_NOSHOOTING
    };



Q_DECLARE_METATYPE(SpectrometerType)
Q_DECLARE_METATYPE(BandUnits)
Q_DECLARE_METATYPE(SpectrumUnits)
Q_DECLARE_METATYPE(Spectrum)
Q_DECLARE_METATYPE(SpectrometerSettingsType)
Q_DECLARE_METATYPE(GpsData)
Q_DECLARE_METATYPE(SpectrMode)
#endif // COMMONTYPES_H
