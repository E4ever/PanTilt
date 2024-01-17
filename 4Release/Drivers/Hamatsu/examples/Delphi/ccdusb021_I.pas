unit ccdusb021_I;

interface
Uses
 Windows, classes, sysutils;

Const
 //The parameter identification number
 PRM_DIGIT       = 1; //The digit capacity of CCD-camera
 PRM_PIXELRATE   = 2; //The pixel timeing
 PRM_NUMPIXELS   = 3; //The number of pixels
 PRM_READOUTS    = 4; //The number of readouts
 PRM_EXPTIME     = 5; //The exposure time
 PRM_SYNCHR      = 6; //The synchronization mode

 PRM_NUMPIXELSH  = 7;  //The number of pixels on a horizontal (columns number of CCD-array)
 PRM_NUMPIXELSV  = 8;  //The number of pixels on a vertical (rows number of CCD-array)
 PRM_SUMMING     = 9;  //The summing mode
 PRM_DEVICEMODE  = 10; //The device mode
                       // DEVICEMODEA1 - Matrix mode #1
                       // DEVICEMODEA2 - Matrix mode #2
                       // DEVICEMODES  - The spectroscope mode without a strips.
                       //                The matrix is submitted as one line
 PRM_STRIPCOUNT  = 11; //The number of strips for a spectral mode

 PRM_SENSIT         = 14;//The sensitivity
 PRM_DEVICEPROPERTY = 15;//The device property.
 PRM_PREBURNING     = 16;// The Time preliminary burning in seconds.
                         // Really only at synchronization SYNCHR_CONTR_NEG but not for all cameras!!!
                         // Use GetDeviceProperty function to receive properties of the device.
                         // Is used  at a spectrum measurements.
 PRM_SHUTERTIME     = 17;//

 PRM_STANDLIGHTERDELAY = 18;//
 PRM_STANDLIGHTERTIME  = 19;//

 PRM_SUBMODE           = 20;
 PRM_BYTEFROMWORD      = 21;


 // Parameters for 08 and [KVADRO_T_DAC,  KITAY_4000_DAC]
 PRM_K2000             = $1000;
 PRM_K20001            = $1001;
 PRM_K20002            = $1002;
 PRM_K20003            = $1003;
 PRM_KAdd2000          = $1004;
 PRM_KAdd20002         = $1005;
 PRM_KAdd20003         = $1006;
 PRM_KAdd20004         = $1007;
 PRM_Offset2000        = $1008;
 PRM_Offset20001       = $1009;
 PRM_Offset20002       = $1010;
 PRM_Offset20003       = $1011;
 PRM_SortPixels        = $1012;

 PRM_ShiftAGFT         = $1014;   // Shift AG FT in mks !!!
 PRM_STANDAGPULSE      = $1015;   // 0 - const, 1 - Impulse
 PRM_STANDSTOPTIME     = $1016;   //  Stop time in mks !!!

 PRM_STANDLIGTERPULSE  = $1017; // Lighter is pulse

 PRM_STANDADCFIRSTWORD  = $1018;
 PRM_STANDADCFIRSTWORD1 = $1019;
 PRM_STANDADCFIRSTWORD2 = $1020;
 PRM_STANDADCFIRSTWORD3 = $1021;
 
 // The synchronization mode
 SYNCHR_NONE      = $1;   // Without synchronization.
 SYNCHR_CONTR     = $20;  // In the beginning of the first accumulation the positive
                          // pulse of synchronization is formed.
 SYNCHR_CONTR_FRS = $4;   // Clock pulse is formed in the beginning of each accumulation.
 SYNCHR_CONTR_NEG = $8;   // One pulse of synchronization is formed on all time of registration.
                          // A pulse of negative polarity.
 SYNCHR_EXT       = $10;  // The beginning of the first accumulation is adhered to growing
                          // front of external clock pulse.
                          // All other accumulation occur so quickly as it is possible.
                          // In a limit -- without the misses.
 SYNCHR_EXT_FRS   = $2;   // The beginning of each accumulation is adhered to growing front of clock pulse.
                          // How much accumulation, so much clock pulses are expected.
                          
                          
 //The status of measurement
 STATUS_WAIT_DATA  = 1; //the measurement in processing
 STATUS_WAIT_TRIG  = 2; //the waiting of synchronization pulse
 STATUS_DATA_READY = 3; //the measurement has been finished

 MAXSTRIPS = 8;

 // DEVICE MODE
// Some cameras on the basis of CCD-matrixes have an additional modes. See dwProperty.
// DP_MODEA2 It is an additional mode of the matrix registrar. If the device has DP_MODEA2 property it is possible to establish dwDeviceMode in value DEVICEMODEA2.
// In mode DEVICEMODES the device works in a spectroscopic mode.
// The photosensitive field of a matrix is broken into some strips. Strips are set by parameters nStripCount and rcStrips.
// While translating the device in mode DEVICEMODES change nNumPixelsH and nNumPixelsV.
 DEVICEMODEA1          = $0002;
 DEVICEMODEA2          = $0000;
 DEVICEMODES           = $0003;
 DEVICEMODESTREAM      = $0004;
 DEVICEMODEFASTSCAN    = $0010;
 DEVICEMODESTEND2      = $0001;
 DEVICEMODESTREAMBYTE  = $0020;
 DEVICEMODESTREAMBYTE1 = $0040;



// DEVICEPROPERTY

 DP_SYNCHR_CONTR         = $00000001; // SYNCHR_CONTR is enaible
 DP_SYNCHR_CONTR_FRS     = $00000002; // SYNCHR_CONTR_FRS is enaible
 DP_SYNCHR_CONTR_NEG     = $00000004; // SYNCHR_CONTR_NEG is enaible
 DP_SYNCHR_EXT           = $00000008; // SYNCHR_EXT is enaible
 DP_SYNCHR_EXT_FRS       = $00000010; // SYNCHR_EXT_FRS is enaible
 DP_SENSIT               = $00000020; // The sensor or first sensor has a mode of the raised sensitivity.
 DP_MODEA2               = $00000040; // Additional matrix mode of the camera.
 DP_MODES1               = $00000080; // Spectroscopic mode of a CCD-matrix.
 DP_MODES2               = $00000100; // Spectroscopic mode of a CCD-matrix.
 DP_PREBURNING           = $00000200; // Opportunity to establish preliminary burning.
 DP_SHUTER               = $00000400; // Property of an electronic shutter.
 DP_CLOCKCONTROL         = $00000800; // Control ADC clock frequency (nPixelRate).
 DP_FASTSCAN             = $00001000; // The "fast scan mode" is enaible
 DP_STREAMSCAN           = $00002000; // The "stream scan mode" is enaible
 DP_SENSIT2              = $00004000; // The second sensor has a mode of the raised sensitivity.
 DP_STENDMODE2           = $00008000; // Not used
 DP_STENDLIGHTERCONTROL  = $00010000; // Not used
 DP_COLORSENSOR          = $00020000; // Color sensor
 DP_STREAMSCANBYTE       = $00040000; // The "byte-per-pixel stream scan mode" is enaible
 DP_STREAMSCANBYTE1      = $00080000; // The additional "byte-per-pixel stream scan mode" is enaible 

 NCAMMAX = 3;

Type
 PDWORDArr = ^TDWORDArr;
 TDWORDArr = array[0..0] of DWORD;
 PWORDArr = ^TWORDArr;
 TWORDArr = array[0..0] of WORD;
 PBYTEArr = ^TBYTEArr;
 TBYTEArr = array[0..0] of BYTE;

 TCCDUSBParams =
  record
   dwDigitCapacity : DWORD;  //The digit capacity of CCD-camera
   nPixelRate      : integer;//The pixel rate kHz
   nNumPixels      : integer;//The number of pixels

   nNumReadOuts    : integer;//The number of readouts
   nExposureTime   : integer;//The exposure time
   dwSynchr        : DWORD;  //The synchronization mode
  end;

 TCCDUSBExtendParams =
  record
   dwDigitCapacity : DWORD;  // The digit capacity of CCD-camera
   nPixelRate      : integer;// The pixel rate (kHz)
   nNumPixelsH     : integer;// The number of pixels on a horizontal (columns number of CCD-array)
   nNumPixelsV     : integer;// The number of pixels on a vertical (rows number of CCD-array)
   Reserve1        : DWORD; // not used
   Reserve2        : DWORD; // not used

   nNumReadOuts    : integer; // The number of readouts
   sPreBurning     : single; // The Time preliminary burning in seconds.
                             // Really only at synchronization SYNCHR_CONTR_NEG but not for all cameras!!!
                             // Use GetDeviceProperty function to receive properties of the device.
                             // Is used at a spectrum measurements.
   sExposureTime   : single; // The exposure time
   sTime2          : single; // not used
   dwSynchr        : DWORD;  // The synchronization mode.
   bSummingMode    : boolean; // Turn on(off) summing mode. Not used.

   dwDeviceMode    : DWORD; // Turn on(off) spectral mode of CCD-array.
                            // Some cameras on the basis of CCD-matrixes have an additional modes. See dwProperty.
                            // DP_MODEA2 It is an additional mode of the matrix registrar. If the device has DP_MODEA2 property it is possible to establish dwDeviceMode in value DEVICEMODEA2.
                            // In mode DEVICEMODES the device works in a spectroscopic mode.
                            // The photosensitive field of a matrix is broken into some strips. Strips are set by parameters nStripCount and rcStrips.
                            // While translating the device in mode DEVICEMODES change nNumPixelsH and nNumPixelsV.
   nStripCount     : integer; // The number of strips for a spectral mode
   rcStrips        : array [0..MAXSTRIPS-1] of TRect; // The strips for a spectral mode.
   Reserve11       : integer;

   dwSensitivity   : DWORD; // Turn on (off) a mode of the raised sensitivity of a CCD-sensor control. Actually if dwProperty & DP_SENSIT <> 0.
   dwProperty      : DWORD; // The device property.
   sShuterTime     : Single; // Shuter time (ms). Active in minimal exposure time.
                             // Exposure time = MinExp - sShaterTime.
   Reserve6        : DWORD; // not used
   Reserve7        : DWORD; // not used
   Reserve8        : DWORD; // not used
   Reserve9        : DWORD; // not used
   Reserve10       : DWORD; // not used
  end;

  TCallBackDataReady = procedure; stdcall;
  PCallBackDataReady = ^TCallBackDataReady;

//if the operation was executed successfully then all function results True

//The function CCD_Init should start before all another function.
//This function performs the search of all CCD-cameras and sets the initial parameters
//ahAppWnd may be 0. Prm and ID not used;
function CCD_Init (ahAppWnd : HWND; Prm : PChar; Var ID : Integer) : boolean; stdcall; external 'CCDUSBDCOM01.DLL'

//The function CCD_HitTest is used for hit test of CCD-cameras
//If some devices are used ID is the identifier USB-device. Can be 0, 1, 2.
//If one device is used then ID = 0.
function CCD_HitTest (ID : Integer) : boolean; stdcall; external 'CCDUSBDCOM01.DLL'

// Cause function CCD_CameraReset when there was a mistake or it is necessary to interrupt registration.
//If some devices are used ID is the identifier USB-device. Can be 0, 1, 2.
//If one device is used then ID = 0.
function CCD_CameraReset (ID : Integer) : boolean; stdcall; external 'CCDUSBDCOM01.DLL'

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
function CCD_SetParameters(ID : Integer; var Prms : TCCDUSBParams) : boolean; stdcall; external 'CCDUSBDCOM01.DLL'

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
function CCD_SetExtendParameters(ID : Integer; var Prms : TCCDUSBExtendParams) : boolean; stdcall; external 'CCDUSBDCOM01.DLL'

//The function CCD_GetParameters is used to get the current parameters
//of CCD-camera.
//If some devices are used ID is the identifier USB-device. Can be 0, 1, 2.
//If one device is used then ID = 0.
function CCD_GetParameters(ID : Integer; var Prms : TCCDUSBParams) : boolean; stdcall; external 'CCDUSBDCOM01.DLL'
function CCD_GetExtendParameters(ID : Integer; var Prms : TCCDUSBExtendParams) : boolean; stdcall; external 'CCDUSBDCOM01.DLL'

//The function CCD_SetParameter is used to set the parameters of CCD-camera separately
// If some devices are used ID is the identifier USB-device. Can be 0, 1, 2.
// If one device is used then ID = 0.
// dwPrmID - parameter identification number. Its can take following values of constants:
// PRM_READOUTS - the number of readouts
// PRM_EXPTIME  - the exposure time
// PRM_SYNCHR   - the synchronization mode. In the external synchronization mode the number of
//                readouts always equals one.
//Prm - the value of parameter
function CCD_SetParameter(ID : Integer; dwPrmID : DWORD; Prm : single) : boolean; stdcall; external 'CCDUSBDCOM01.DLL'

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
function CCD_GetParameter(ID : Integer; dwPrmID : DWORD; var Prm : single) : boolean; stdcall; external 'CCDUSBDCOM01.DLL'

//The function CCD_InitMeasuring must be start before beginning of measuring
//If some devices are used ID is the identifier USB-device. Can be 0, 1, 2.
//If one device is used then ID = 0.
function CCD_InitMeasuring(ID : Integer) : boolean; stdcall; external 'CCDUSBDCOM01.DLL'
function CCD_InitMeasuringCallBack(ID : Integer; callbackfun : PCallBackDataReady ) : boolean; stdcall; external 'CCDUSBDCOM01.DLL'

//The function CCD_InitMeasuringData must be start before beginning of measuring
//If some devices are used ID is the identifier USB-device. Can be 0, 1, 2.
//If one device is used then ID = 0.
//apData is the pointegr to array of DWORD.
//The size of array must be equal tothe pixels' number of CCD-camera
//(nNumPixelsH*nNumPixelsV*nNumReadOuts*SizeOf(DWORD))
function CCD_InitMeasuringData(ID : Integer; apData : PDWORDArr) : boolean; stdcall; external 'CCDUSBDCOM01.DLL'

//Call CCD_DoneMeasuringData function after the termination of all measurements.
//If you plan to begin measurement anew, do not call this function.
//It is called automatically at a exit from DLL.
//If some devices are used ID is the identifier USB-device. Can be 0, 1, 2.
//If one device is used then ID = 0.
function CCD_DoneMeasuring(ID : Integer) : boolean; stdcall; external 'CCDUSBDCOM01.DLL'

//The function CCD_StartWaitMeasuring is used to start and wait the measurement.
//The function starts the measurement and waits the finishing of the measurement.
//If some devices are used ID is the identifier USB-device. Can be 0, 1, 2.
//If one device is used then ID = 0.
function CCD_StartWaitMeasuring (ID : Integer) : boolean; stdcall; external 'CCDUSBDCOM01.DLL'

//The function CCD_StartMeasuring is used to start the measurement only
//If some devices are used ID is the identifier USB-device. Can be 0, 1, 2.
//If one device is used then ID = 0.
function CCD_StartMeasuring (aID : Integer) : boolean; stdcall; external 'CCDUSBDCOM01.DLL'

// The function CCD_GetMeasureStatus is used to check status of a measurement.
// This function is used with the function CCDUSB_StartMeasuring.
// If some devices are used ID is the identifier USB-device. Can be 0, 1, 2.
// If one device is used then ID = 0.
// dwStatus - the result value can take one of following constants:
// STATUS_WAIT_DATA  - the measurement in processing
// STATUS_WAIT_TRIG  - the waiting of synchronization pulse
// STATUS_DATA_READY - the measurement has been finished
function CCD_GetMeasureStatus(ID : Integer; var adwStatus : DWORD) : boolean; stdcall; external 'CCDUSBDCOM01.DLL'

//The function CCD_GetData is used to get the result of measurement.
//If some devices are used ID is the identifier USB-device. Can be 0, 1, 2.
//If one device is used then ID = 0.
//bData - the pointegr to array of DWORD. The length of array must be equal to
//the pixels' number of CCD-camera
//It is applied to cameras with a linear CCD-sensor and function CCDUSB_InitMeasuring.
//To matrix registrars should apply function CCDUSB_InitMeasuringData.
function CCD_GetData(ID : Integer; pData : PDWORDArr) : boolean; stdcall; external 'CCDUSBDCOM01.DLL'
function CCD_GetDataWord(ID : Integer; pData : PWORDArr) : boolean; stdcall; external 'CCDUSBDCOM01.DLL'
function CCD_GetDataByte(ID : Integer; pData : PBYTEArr) : boolean; stdcall; external 'CCDUSBDCOM01.DLL'

//The function CCD_GetSerialNum returns unique serial number of CCD-camera.
//If some devices are used ID is the identifier USB-device. Can be 0, 1, 2.
//If one device is used then ID = 0.
function CCD_GetSerialNum (ID : Integer; Var sernum : PChar) : boolean; stdcall; external 'CCDUSBDCOM01.DLL'

//The function CCD_GetSerialNumber returns unique serial number of CCD-camera.
//If some devices are used ID is the identifier USB-device. Can be 0, 1, 2.
//If one device is used then ID = 0.
function CCD_GetSerialNumber (ID : Integer ) : PChar; stdcall; external 'CCDUSBDCOM01.DLL'

//The function CCD_GetSensorName returns a device name.
//If some devices are used ID is the identifier USB-device. Can be 0, 1, 2.
//If one device is used then ID = 0.
function CCD_GetSensorName (ID : Integer ) : PChar; stdcall; external 'CCDUSBDCOM01.DLL'


//The function CCD_GetID allows to receive ID for the chamber with known serial number.
function CCD_GetID ( sernum : PChar; Var ID : Integer ) : boolean; stdcall; external 'CCDUSBDCOM01.DLL'

//Parameters of a spectroscopic mode of a matrix are established either through function CCDUSB_SetExtendParameters
//or through functions CCD_ClearStrips, CCD_AddStrip and CCD_DeleteStrip.

//This function is used for management in parameters of a spectroscopic mode of a CCD-matrix.
//Function CCD_ClearStrips clears the list of strips.
//If some devices are used ID is the identifier USB-device. Can be 0, 1, 2.
//If one device is used then ID = 0.
function CCD_ClearStrips (ID : Integer) : boolean; stdcall;  external 'CCDUSBDCOM01.DLL'

//Function CCD_AddStrip adds a strip in the list.
//Parameters of a strip are specified in arcStrip.
//The number of strips increases on 1.
//Strips cannot be blocked.
//Function returns TRUE if parameters of a strip are correct also a strip is successfully added.
//If some devices are used ID is the identifier USB-device. Can be 0, 1, 2.
//If one device is used then ID = 0.
function CCD_AddStrip (ID : Integer; arcStrip : TRect) : boolean; stdcall;  external 'CCDUSBDCOM01.DLL'

//Function CCD_DeleteStrip deletes a strip with number Index from the list of strips.
//The number of strips in the list decreases on 1.
//If some devices are used ID is the identifier USB-device. Can be 0, 1, 2.
//If one device is used then ID = 0.
function CCD_DeleteStrip (ID : Integer; Index : Integer) : boolean; stdcall;  external 'CCDUSBDCOM01.DLL'

//The function CCDUSB_SetPIN3 control a pin number 3 of the synch sockets.
//If some devices are used ID is the identifier USB-device. Can be 0, 1, 2.
//If one device is used then ID = 0.
//If OnOff = false that on pin 0 V.
//If OnOff = true  that on pin 5 V.
//Function CCDUSB_Init reset pin in 0 V.
function CCDUSB_SetPIN0 ( ID: Integer; OnOff : Boolean ) : boolean; stdcall;  external 'CCDUSBDCOM01.dll'
function CCDUSB_SetPIN3 ( OnOff : Boolean ) : boolean; stdcall;  external 'CCDUSBDCOM01.dll'
function CCDUSB_SetPIN4 ( OnOff : Boolean ) : boolean; stdcall;   external 'CCDUSBDCOM01.dll'

// Генерирует синхроимпуль
function CCDUSB_SynchPIN () : boolean; stdcall;   external 'CCDUSBDCOM01.dll'

function SetWordUSBExt( ID: Integer; bRequest : byte; wValue, wIndex : WORD ) : boolean; stdcall; external 'CCDUSBDCOM01.dll'

function CCDDCOM_DisconectDCOM (ID : Integer) : boolean; stdcall; external 'CCDUSBDCOM01.dll'
function CCDDCOM_SetDCOMRemoteName (ID : Integer; RemoteName : PChar) : boolean;  stdcall; external 'CCDUSBDCOM01.dll'

implementation

end.
