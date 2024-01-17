#ifndef DLLLOADER_H
#define DLLLOADER_H

//#ifdef __cplusplus
//extern "C" {
//#endif

//#include <QRect>
//#include <qglobal.h>
//#include <QWindow>
//#include <QLibrary>
//#include <QSet>

#include <windows.h>

//#ifdef __cplusplus
//}
//#endif

#pragma once

#define BYTEx8_ALIGN __declspec(align(8))

//The parameter identification number

//The digit capacity of CCD-camera
#define  PRM_DIGIT              1
//The pixel rate
#define  PRM_PIXELRATE          2
//The number of pixels
#define  PRM_NUMPIXELS          3
//The number of readouts
#define PRM_READOUTS            4
//The exposure time
#define PRM_EXPTIME             5
//The synchronization mode
#define PRM_SYNCHR              6
//The number of pixels on a horizontal (columns number of CCD-array)
#define PRM_NUMPIXELSH          7
//The number of pixels on a vertical (rows number of CCD-array)
#define PRM_NUMPIXELSV          8
//The summing mode
#define PRM_SUMMING             9
//The device mode
#define PRM_DEVICEMODE          10
// DEVICEMODEA1 - Matrix mode #1
// DEVICEMODEA2 - Matrix mode #2
// DEVICEMODES  - The spectroscope mode without a strips.
//                The matrix is submitted as one line
//The number of strips for a spectral mode
#define PRM_STRIPCOUNT          11
//The sensitivity
#define PRM_SENSIT              14
//The device property.
#define PRM_DEVICEPROPERTY      15
// The Time preliminary burning in seconds.
#define PRM_PREBURNING          16
// Really only at synchronization SYNCHR_CONTR_NEG but not for all cameras!!!
// Use GetDeviceProperty function to receive properties of the device.
// Is used  at a spectrum measurements.
#define PRM_SHUTERTIME          17//

// ******************************************************************
// Специальные и неиспользуемые параметры:
#define PRM_STANDLIGHTERDELAY   18//
#define PRM_STANDLIGHTERTIME    19//

#define PRM_REGISTERMODE        22//

#define PRM_KAmpRed             0x1022
#define PRM_KRed2000            0x1022 //
#define PRM_KAmpGreen           0x1023
#define PRM_KAmpBlue            0x1024
#define PRM_KAmpRed1            0x1025
#define PRM_KAmpGreen1          0x1026
#define PRM_KAmpBlue1           0x1027
#define PRM_KAmpRed2            0x1028
#define PRM_KAmpGreen2          0x1029
#define PRM_KAmpBlue2           0x1030
#define PRM_KAmpRed3            0x1031
#define PRM_KAmpGreen3          0x1032
#define PRM_KAmpBlue3           0x1033
#define PRM_OffsetRed           0x1034
#define PRM_OffsetRed2000       0x1034 //
#define PRM_OffsetGreen         0x1035
#define PRM_OffsetBlue          0x1036
#define PRM_OffsetRed1          0x1037
#define PRM_OffsetGreen1        0x1038
#define PRM_OffsetBlue1         0x1039
#define PRM_OffsetRed2          0x1040
#define PRM_OffsetGreen2        0x1041
#define PRM_OffsetBlue2         0x1042
#define PRM_OffsetRed3          0x1043
#define PRM_OffsetGreen3        0x1044
#define PRM_OffsetBlue3         0x1045
// ******************************************************************


// The synchronization mode
// Without synchronization.
#define SYNCHR_NONE      0x01
// In the beginning of the first accumulation the positive
// pulse of synchronization is formed.
#define SYNCHR_CONTR     0x20
// Clock pulse is formed in the beginning of each accumulation.
#define SYNCHR_CONTR_FRS 0x04
// One pulse of synchronization is formed on all time of registration.
// A pulse of negative polarity.
#define SYNCHR_CONTR_NEG 0x08

// The beginning of the first accumulation is adhered to growing
// front of external clock pulse.
//All other accumulation occur so quickly as it is possible.
// In a limit -- without the misses.
#define SYNCHR_EXT       0x10

// The beginning of each accumulation is adhered to growing front of clock pulse.
// How much accumulation, so much clock pulses are expected.
#define SYNCHR_EXT_FRS   0x02


//The status of measurement
//the measurement in processing
#define STATUS_WAIT_DATA   1
//the waiting of synchronization pulse
#define STATUS_WAIT_TRIG   2
//the measurement has been finished
#define STATUS_DATA_READY  3

#define MAXSTRIPS          8

// DEVICE MODE
// Some cameras on the basis of CCD-matrixes have an additional modes. See dwProperty.
// DP_MODEA2 It is an additional mode of the matrix registrar. If the device has DP_MODEA2 property it is possible to establish dwDeviceMode in value DEVICEMODEA2.
// In mode DEVICEMODES the device works in a spectroscopic mode.
// The photosensitive field of a matrix is broken into some strips. Strips are set by parameters nStripCount and rcStrips.
// While translating the device in mode DEVICEMODES change nNumPixelsH and nNumPixelsV.
#define DEVICEMODEA1  0x0002
#define DEVICEMODEA2  0x0000
#define DEVICEMODES   0x0003

// ******************************************************************
// Специальные режимы камер и стендов:
#define DEVICEMODESTREAM      0x0004;
#define DEVICEMODEFASTSCAN    0x0010;
#define DEVICEMODESTEND2      0x0001;
#define DEVICEMODESTREAMBYTE  0x0020;
#define DEVICEMODESTREAMBYTE1 0x0040;
#define DEVICEMODESTREAMBYTE3 0x0080;

#define DEVICEMODEHORD1       0x0007;
#define DEVICEMODEHORD2       0x000B;
#define DEVICEMODEHORD4       0x0013;

#define DEVICEREGISTERMODEALL 0x0000;
#define DEVICEREGISTERMODELU  0x0001;
#define DEVICEREGISTERMODERU  0x0002;
#define DEVICEREGISTERMODELD  0x0003;
#define DEVICEREGISTERMODERD  0x0004;
// ******************************************************************


// DEVICEPROPERTY

// SYNCHR_CONTR is enaible
#define DP_SYNCHR_CONTR         0x00000001
// SYNCHR_CONTR_FRS is enaible
#define DP_SYNCHR_CONTR_FRS     0x00000002
// SYNCHR_CONTR_NEG is enaible
#define DP_SYNCHR_CONTR_NEG     0x00000004
// SYNCHR_EXT is enaible
#define DP_SYNCHR_EXT           0x00000008
// SYNCHR_EXT_FRS is enaible
#define DP_SYNCHR_EXT_FRS       0x00000010
// The sensor has a mode of the raised sensitivity.
#define DP_SENSIT               0x00000020;
// Additional matrix mode of the camera.
#define DP_MODEA2               0x00000040
// Spectroscopic mode of a CCD-matrix.
#define DP_MODES1               0x00000080
// Spectroscopic mode of a CCD-matrix.
#define DP_MODES2               0x00000100
// Opportunity to establish preliminary burning.
#define DP_PREBURNING           0x00000200
// Property of an electronic shutter.
#define DP_SHUTER               0x00000400
// Control ADC clock frequency (nPixelRate).
#define DP_CLOCKCONTROL         0x00000800

#define DP_STREAMSCAN           0x00002000 // The "stream scan mode" is enaible
#define DP_SENSIT2              0x00004000 // The second sensor has a mode of the raised sensitivity.
#define DP_STENDMODE2           0x00008000 // Not used
#define DP_STENDLIGHTERCONTROL  0x00010000 // Not used
#define DP_COLORSENSOR          0x00020000 // Color sensor
#define DP_STREAMSCANBYTE       0x00040000 // The "byte-per-pixel stream scan mode" is enaible
#define DP_STREAMSCANBYTE1      0x00080000 // The additional "byte-per-pixel stream scan mode" is enaible
#define DP_STREAMSCANBYTE3      0x00100000 // The additional "byte-per-pixel stream scan mode" is enaible
#define DP_REGISTERMODE         0x00200000 // Set the QUADRO register mode. ALL, LU, RU, LD, RD
#define DP_SPIMEMORY            0x00400000 // SPI Memory
#define DP_SHUTTER2             0x00800000 // Extenal Shutter from Solar LS. Not used
#define DP_SHUTTER3             0x01000000 // Extenal Shutter from Solar LS. Not used

// Ext device property
 #define DP_DELAY                0x00000001 // The accumelation Delay in mksec
// #define DP_ICX282AQCOLOR        0x00000002 // Not used


#define NCAMMAX  3

#define strSYNCHR_NONE "PC"
#define strSYNCHR_CONTR_FRS "[->..[->"
#define strSYNCHR_EXT_FRS "[<-..[<-"

//typedef quint32*  Puint32Arr;
//typedef quint16*  Puint16Arr;
typedef DWORD*  Puint32Arr;
typedef WORD*  Puint16Arr;

//typedef struct tagRECT {
//  LONG left;
//  LONG top;
//  LONG right;
//  LONG bottom;
//} RECT, *PRECT, *NPRECT, *LPRECT;

//typedef int int;

typedef struct
{
    DWORD dwDigitCapacity;  //The digit capacity of CCD-camera
    int nPixelRate;//The pixel rate kHz
    int nNumPixels;//The number of pixels

    int nNumReadOuts;//The number of readouts
    int nExposureTime;//The exposure time
    DWORD dwSynchr;  //The synchronization mode
} TCCDUSBParams;

typedef float single;

typedef struct BYTEx8_ALIGN
{
    DWORD dwDigitCapacity;  //The digit capacity of CCD-camera
    int nPixelRate;//The pixel rate kHz
    int nNumPixelsH;// The number of pixels on a horizontal (columns number of CCD-array)
    int nNumPixelsV;// The number of pixels on a vertical (rows number of CCD-array)
    DWORD Reserve1; // not used
    DWORD Reserve2; // not used

    int nNumReadOuts; // The number of readouts
    single sPreBurning; // The Time preliminary burning in seconds.
    // Really only at synchronization SYNCHR_CONTR_NEG but not for all cameras!!!
    // Use GetDeviceProperty function to receive properties of the device.
    // Is used at a spectrum measurements.
    single sExposureTime; // The exposure time
    single sTime2; // not used
    DWORD dwSynchr;  // The synchronization mode.
    bool bSummingMode; // Turn on(off) summing mode. Not used.

    DWORD dwDeviceMode; // Turn on(off) spectral mode of CCD-array.
    // Some cameras on the basis of CCD-matrixes have an additional modes. See dwProperty.
    // DP_MODEA2 It is an additional mode of the matrix registrar. If the device has DP_MODEA2 property it is possible to establish dwDeviceMode in value DEVICEMODEA2.
    // In mode DEVICEMODES the device works in a spectroscopic mode.
    // The photosensitive field of a matrix is broken into some strips. Strips are set by parameters nStripCount and rcStrips.
    // While translating the device in mode DEVICEMODES change nNumPixelsH and nNumPixelsV.
    int nStripCount; // The number of strips for a spectral mode
    RECT rcStrips[MAXSTRIPS]; // The strips for a spectral mode.
    int Reserve11;

    DWORD dwSensitivity; // Turn on (off) a mode of the raised sensitivity of a CCD-sensor control. Actually if dwProperty & DP_SENSIT <> 0.
    DWORD dwProperty ; // The device property.
    single sShuterTime; // Shuter time (ms). Active in minimal exposure time.
    // Exposure time = MinExp - sShaterTime.
    DWORD Reserve6; // not used
    DWORD Reserve7; // not used
    DWORD Reserve8; // not used
    DWORD Reserve9; // not used
    DWORD Reserve10; // not used
} TCCDUSBExtendParams;

typedef struct
{
  bool timeout_flag; //флаг управления таймаутом
                     //true – таймаут включен
                     //false – таймаут выключен
  int short_timeout;  //длительность таймаута для функций группы б) в миллисекундах
  int long_timeout;   //длительность таймаута для функций группы в) в миллисекундах
} TIMEOUT;

#define INFINITE            -1  // Infinite timeout

//#define PChar PCHAR
typedef char* PChar;

//if the operation was executed successfully then all function results True

//The function CCD_Init should start before all another function.
//This function performs the search of all CCD-cameras and sets the initial parameters
//ahAppWnd may be 0. Prm and ID not used;
typedef bool (__stdcall *PCCD_Init)(HWND ahAppWnd, PChar Prm, int* ID);
//function CCD_Init (ahAppWnd : HWND; Prm : PChar; Var ID : int) : boolean; stdcall; external 'CCDUSBDCOM01.DLL'

//The function CCD_HitTest is used for hit test of CCD-cameras
//If some devices are used ID is the identifier USB-device. Can be 0, 1, 2.
//If one device is used then ID = 0.
typedef bool (__stdcall *PCCD_HitTest)(int ID);
//function CCD_HitTest (ID : int) : boolean; stdcall; external 'CCDUSBDCOM01.DLL'

// Cause function CCD_CameraReset when there was a mistake or it is necessary to interrupt registration.
//If some devices are used ID is the identifier USB-device. Can be 0, 1, 2.
//If one device is used then ID = 0.
typedef bool (__stdcall *PCCD_CameraReset)(int ID);
//CCD_CameraReset (ID : int) : boolean; stdcall; external 'CCDUSBDCOM01.DLL'

//The function CCD_SetParameters is used for CCD-camera parameters' setting.
//The parameter Prms is structure of type TCCDUSBParams. The declaration of structure
//TCCDUSBParams defines above.
//It is allowed to set only following parameters:
//  - exposure time
//  - number of readouts
//  - synchronization mode
//The remaining parameters is set automatically
//If some devices are used ID is the identifier USB-device. Can be 0, 1, 2.
//If one device is used then ID = 0.
typedef bool (__stdcall *PCCD_SetParameters)(int ID,TCCDUSBParams* Prms);
//CCD_SetParameters(ID : int; var Prms : TCCDUSBParams) : boolean; stdcall; external 'CCDUSBDCOM01.DLL'

//The function CCD_SetExtendParameters is used for CCD-camera parameters' setting.
//The parameter Prms is structure of type TCCDUSBExtendParams. The declaration of structure
//TCCDUSBExtendParams defines above.
//It is allowed to set only following parameters:
//  - exposure time
//  - number of readouts
//  - synchronization mode
//  - device mode
//  - strips
//  - the time preliminary burning
//  - the raised sensitivity
//  - shuter time
//The remaining parameters is set automatically.
//If some devices are used ID is the identifier USB-device. Can be 0, 1, 2.
//If one device is used then ID = 0.
typedef bool (__stdcall *PCCD_SetExtendParameters)(int ID, TCCDUSBExtendParams* Prms);
//CCD_SetExtendParameters(ID : int; var Prms : TCCDUSBExtendParams) : boolean; stdcall; external 'CCDUSBDCOM01.DLL'

//The function CCD_GetParameters is used to get the current parameters
//of CCD-camera.
//If some devices are used ID is the identifier USB-device. Can be 0, 1, 2.
//If one device is used then ID = 0.
typedef bool (__stdcall *PCCD_GetParameters)      (int ID, TCCDUSBExtendParams* Prms);
typedef bool (__stdcall *PCCD_GetExtendParameters)(int ID, TCCDUSBExtendParams* Prms);
//CCD_GetParameters(ID : int; var Prms : TCCDUSBParams) : boolean; stdcall; external 'CCDUSBDCOM01.DLL'
//CCD_GetExtendParameters(ID : int; var Prms : TCCDUSBExtendParams) : boolean; stdcall; external 'CCDUSBDCOM01.DLL'

//The function CCD_SetParameter is used to set the parameters of CCD-camera separately
// If some devices are used ID is the identifier USB-device. Can be 0, 1, 2.
// If one device is used then ID = 0.
// dwPrmID - parameter identification number. Its can take following values of constants:
// PRM_READOUTS - the number of readouts
// PRM_EXPTIME  - the exposure time
// PRM_SYNCHR   - the synchronization mode. In the external synchronization mode the number of
//                readouts always equals one.
//Prm - the value of parameter

typedef bool (__stdcall *PCCD_SetParameter)(int ID, DWORD dwPrmID, single Prm);
//CCD_SetParameter(ID : int; dwPrmID : uint32; Prm : single) : boolean; stdcall; external 'CCDUSBDCOM01.DLL'

//The function CCD_GetParameter is used to get the parameters of CCD-camera separately
// If some devices are used ID is the identifier USB-device. Can be 0, 1, 2.
// If one device is used then ID = 0.
// dwPrmID - parameter identification number. Its can take following values of constants:
// PRM_DIGIT       - The digit capacity of CCD-camera
// PRM_PIXELRATE   - The pixel timing
// PRM_NUMPIXELS   - The number of pixels
// PRM_READOUTS    - The  number of readouts
// PRM_EXPTIME     - The exposure time
// PRM_SYNCHR      - The synchronization mode
//Prm - the returned value of parameter

typedef bool (__stdcall *PCCD_GetParameter)(int ID, DWORD dwPrmID, single* Prm);
//CCD_GetParameter(ID : int; dwPrmID : uint32; var Prm : single) : boolean; stdcall; external 'CCDUSBDCOM01.DLL'

//The function CCD_InitMeasuring must be start before beginning of measuring
//If some devices are used ID is the identifier USB-device. Can be 0, 1, 2.
//If one device is used then ID = 0.
typedef bool (__stdcall *PCCD_InitMeasuring)(int ID);
//CCD_InitMeasuring(ID : int) : boolean; stdcall; external 'CCDUSBDCOM01.DLL'

//The function CCD_InitMeasuringData must be start before beginning of measuring
//If some devices are used ID is the identifier USB-device. Can be 0, 1, 2.
//If one device is used then ID = 0.
//apData is the pointegr to array of uint32.
//The size of array must be equal tothe pixels' number of CCD-camera
//(nNumPixelsH*nNumPixelsV*nNumReadOuts*SizeOf(uint32))
typedef bool (__stdcall *PCCD_InitMeasuringData)(int ID, Puint32Arr apData);
//CCD_InitMeasuringData(ID : int; apData : Puint32Arr) : boolean; stdcall; external 'CCDUSBDCOM01.DLL'

//The function CCD_StartWaitMeasuring is used to start and wait the measurement.
//The function starts the measurement and waits the finishing of the measurement.
//If some devices are used ID is the identifier USB-device. Can be 0, 1, 2.
//If one device is used then ID = 0.
typedef bool (__stdcall *PCCD_StartWaitMeasuring) (int ID);
//CCD_StartWaitMeasuring (ID : int) : boolean; stdcall; external 'CCDUSBDCOM01.DLL'

//The function CCD_StartMeasuring is used to start the measurement only
//If some devices are used ID is the identifier USB-device. Can be 0, 1, 2.
//If one device is used then ID = 0.
typedef bool (__stdcall *PCCD_StartMeasuring) (int aID);
//CCD_StartMeasuring (aID : int) : boolean; stdcall; external 'CCDUSBDCOM01.DLL'

// The function CCD_GetMeasureStatus is used to check status of a measurement.
// This function is used with the function CCDUSB_StartMeasuring.
// If some devices are used ID is the identifier USB-device. Can be 0, 1, 2.
// If one device is used then ID = 0.
// dwStatus - the result value can take one of following constants:
// STATUS_WAIT_DATA  - the measurement in processing
// STATUS_WAIT_TRIG  - the waiting of synchronization pulse
// STATUS_DATA_READY - the measurement has been finished
typedef bool (__stdcall *PCCD_GetMeasureStatus)(int ID, DWORD* adwStatus);
//CCD_GetMeasureStatus(ID : int; var adwStatus : uint32) : boolean; stdcall; external 'CCDUSBDCOM01.DLL'

//The function CCD_GetData is used to get the result of measurement.
//If some devices are used ID is the identifier USB-device. Can be 0, 1, 2.
//If one device is used then ID = 0.
//bData - the pointegr to array of uint32. The length of array must be equal to
//the pixels' number of CCD-camera
//It is applied to cameras with a linear CCD-sensor and function CCDUSB_InitMeasuring.
//To matrix registrars should apply function CCDUSB_InitMeasuringData.
typedef bool (__stdcall *PCCD_GetData)(int ID, Puint32Arr pData);
//CCD_GetData(ID : int; pData : Puint32Arr) : boolean; stdcall; external 'CCDUSBDCOM01.DLL'

//The function CCD_GetSerialNum returns unique serial number of CCD-camera.
//If some devices are used ID is the identifier USB-device. Can be 0, 1, 2.
//If one device is used then ID = 0.
typedef bool (__stdcall *PCCD_GetSerialNum)(int ID, char* sernum);
//typedef bool (__stdcall *PCCD_GetSerialNum)(int ID, wchar_t* sernum);
//CCD_GetSerialNum (ID : int; Var sernum : PChar) : boolean; stdcall; external 'CCDUSBDCOM01.DLL'

typedef char* (__stdcall *PCCD_GetSerialNumber)(int ID);

//The function CCD_GetID allows to receive ID for the chamber with known serial number.
typedef bool (__stdcall *PCCD_GetID) (char* sernum, int * ID );
//CCD_GetID ( sernum : PChar; Var ID : int ) : boolean; stdcall; external 'CCDUSBDCOM01.DLL'

//Parameters of a spectroscopic mode of a matrix are established either through function CCDUSB_SetExtendParameters
//or through functions CCD_ClearStrips, CCD_AddStrip and CCD_DeleteStrip.

//This function is used for management in parameters of a spectroscopic mode of a CCD-matrix.
//Function CCD_ClearStrips clears the list of strips.
//If some devices are used ID is the identifier USB-device. Can be 0, 1, 2.
//If one device is used then ID = 0.
typedef bool (__stdcall *PCCD_ClearStrips) (int ID);
//CCD_ClearStrips (ID : int) : boolean; stdcall;  external 'CCDUSBDCOM01.DLL'

//Function CCD_AddStrip adds a strip in the list.
//Parameters of a strip are specified in arcStrip.
//The number of strips increases on 1.
//Strips cannot be blocked.
//Function returns TRUE if parameters of a strip are correct also a strip is successfully added.
//If some devices are used ID is the identifier USB-device. Can be 0, 1, 2.
//If one device is used then ID = 0.
typedef bool (__stdcall *PCCD_AddStrip)  (int ID, RECT arcStrip);
//CCD_AddStrip (ID : int; arcStrip : TRect) : boolean; stdcall;  external 'CCDUSBDCOM01.DLL'

//Function CCD_DeleteStrip deletes a strip with number Index from the list of strips.
//The number of strips in the list decreases on 1.
//If some devices are used ID is the identifier USB-device. Can be 0, 1, 2.
//If one device is used then ID = 0.
typedef bool (__stdcall *PCCD_DeleteStrip) ( int ID , int Index);
//CCD_DeleteStrip (ID : int; Index : int) : boolean; stdcall;  external 'CCDUSBDCOM01.DLL'

typedef bool (__stdcall *PCCDUSB_MemoryWrite)(int ID, int aStartAddr, Puint32Arr aBuff, int BuffSize);
//function CCDUSB_MemoryWrite ( ID, aStartAddr : int; aBuff : PWORDArr; BuffSize : int  ) : boolean; stdcall;

typedef bool (__stdcall *PCCDUSB_MemoryRead)(int ID, int aStartAddr, Puint32Arr aBuff, int BuffSize);
//function CCDUSB_MemoryRead  ( ID, aStartAddr : int; aBuff : PWORDArr; BuffSize : int  ) : boolean; stdcall;

typedef bool (__stdcall *PCCDUSB_MemoryFileWrite)(int ID, char* FileName);
//function CCDUSB_MemoryFileWrite ( ID : int; FileName : PAnsiChar ) : boolean; stdcall;

typedef bool (__stdcall *PCCDUSB_MemoryFileRead)(int ID, char* FileName);
//function CCDUSB_MemoryFileRead  ( ID : int; FileName : PAnsiChar ) : boolean; stdcall;


typedef bool (__stdcall *PCCD_GetTimeout)(int ID, TIMEOUT* timeout);
typedef bool (__stdcall *PCCD_SetTimeout)(int ID, TIMEOUT* timeout);


#endif // DLLLOADER_H
