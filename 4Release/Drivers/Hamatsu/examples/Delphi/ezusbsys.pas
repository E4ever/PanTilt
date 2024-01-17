unit ezusbsys;

interface

Const
//
// Vendor specific request code for Anchor Upload/Download
//
// This one is implemented in the core
//
ANCHOR_LOAD_INTERNAL = $A0;

//
// This command is not implemented in the core.  Requires firmware
//
ANCHOR_LOAD_EXTERNAL = $A3;

//
// This is the highest internal RAM address for the AN2131Q
//
MAX_INTERNAL_ADDRESS = $1B3F;

//#define INTERNAL_RAM(address) ((address <= MAX_INTERNAL_ADDRESS) ? 1 : 0)
//
// EZ-USB Control and Status Register.  Bit 0 controls 8051 reset
//
CPUCS_REG  =  $7F92;

FILE_DEVICE_UNKNOWN   =  $00000022;
METHOD_BUFFERED       =          0;
METHOD_IN_DIRECT      =          1;
METHOD_OUT_DIRECT     =          2;
METHOD_NEITHER        =          3;
FILE_ANY_ACCESS       =          0;

Ezusb_IOCTL_INDEX   = $0800;

Type

TVENDOR_REQUEST_IN = record
    bRequest : BYTE;
    wValue : WORD;
    wIndex : WORD;
    wLength : WORD;
    direction : BYTE ;
    bData : BYTE;
end; // VENDOR_REQUEST_IN, *PVENDOR_REQUEST_IN;
PVENDOR_REQUEST_IN = ^TVENDOR_REQUEST_IN;

///////////////////////////////////////////////////////////
//
// control structure for bulk and interrupt data transfers
//
///////////////////////////////////////////////////////////
TBULK_TRANSFER_CONTROL = record
   pipeNum : Longword;
end; // BULK_TRANSFER_CONTROL, *PBULK_TRANSFER_CONTROL;
PBULK_TRANSFER_CONTROL = ^TBULK_TRANSFER_CONTROL;

TGET_STRING_DESCRIPTOR = record
   Index : BYTE;
   LanguageId : WORD;
end; // GET_STRING_DESCRIPTOR, *PGET_STRING_DESCRIPTOR;
PGET_STRING_DESCRIPTOR = ^TGET_STRING_DESCRIPTOR;

TBULK_LATENCY_CONTROL = record
   bulkPipeNum : Longword;
   intPipeNum : Longword;
   loops : Longword;
end; // BULK_LATENCY_CONTROL, *PBULK_LATENCY_CONTROL;
PBULK_LATENCY_CONTROL = ^TBULK_LATENCY_CONTROL;

///////////////////////////////////////////////////////////
//
// control structure for sending vendor or class specific requests
// to the control endpoint.
//
///////////////////////////////////////////////////////////
TVENDOR_OR_CLASS_REQUEST_CONTROL = record
   // transfer direction (0=host to device, 1=device to host)
   direction : BYTE;

   // request type (1=class, 2=vendor)
   requestType : BYTE;

   // recipient (0=device,1=interface,2=endpoint,3=other)
   recepient : BYTE;
   //
   // see the USB Specification for an explanation of the
   // following paramaters.
   //
   requestTypeReservedBits : BYTE;
   request : BYTE;
   value : WORD;
   index : WORD;
end; // VENDOR_OR_CLASS_REQUEST_CONTROL, *PVENDOR_OR_CLASS_REQUEST_CONTROL;
PVENDOR_OR_CLASS_REQUEST_CONTROL = ^TVENDOR_OR_CLASS_REQUEST_CONTROL;

TEZUSB_DRIVER_VERSION = record
   MajorVersion : WORD;
   MinorVersion : WORD;
   BuildVersion : WORD;
end;
PEZUSB_DRIVER_VERSION = ^TEZUSB_DRIVER_VERSION;

TISO_TRANSFER_CONTROL = record
   //
   // pipe number to perform the ISO transfer to/from.  Direction is
   // implied by the pipe number.
   //
   PipeNum : Longword;
   //
   // ISO packet size.  Determines how much data is transferred each
   // frame.  Should be less than or equal to the maxpacketsize for
   // the endpoint.
   //
   PacketSize  : Longword;
   //
   // Total number of ISO packets to transfer.
   //
   PacketCount : Longword;
   //
   // The following two parameters detmine how buffers are managed for
   // an ISO transfer.  In order to maintain an ISO stream, the driver
   // must create at least 2 transfer buffers and ping pong between them.
   // BufferCount determines how many buffers the driver creates to ping
   // pong between.  FramesPerBuffer specifies how many USB frames of data
   // are transferred by each buffer.
   //
   FramesPerBuffer : Longword;     // 10 is a good value
   BufferCount     : Longword;     // 2 is a good value
end;
PISO_TRANSFER_CONTROL = ^TISO_TRANSFER_CONTROL;

USBD_STATUS = LongInt;

TUSBD_ISO_PACKET_DESCRIPTOR = record
    Offset : LongWord;       // INPUT Offset of the packet from the begining of the
                        // buffer.
    Length : LongWord;       // OUTPUT length of data received (for in).
                        // OUTPUT 0 for OUT.
    Status : USBD_STATUS; // status code for this packet.
end;
PUSBD_ISO_PACKET_DESCRIPTOR = ^TUSBD_ISO_PACKET_DESCRIPTOR;

function CTL_CODE ( DeviceType, Fun, Method, Access : LongWord) : LongWord;
function IOCTL_Ezusb_GET_PIPE_INFO : LongWord;
function IOCTL_Ezusb_GET_DEVICE_DESCRIPTOR : LongWord;
function IOCTL_EZUSB_BULK_READ : LongWord;
function IOCTL_EZUSB_BULK_WRITE : LongWord;
function IOCTL_EZUSB_VENDOR_OR_CLASS_REQUEST : LongWord;
function IOCTL_EZUSB_VENDOR_REQUEST : LongWord;
function IOCTL_EZUSB_ANCHOR_DOWNLOAD : LongWord;
function IOCTL_Ezusb_RESETPIPE : LongWord;
function IOCTL_Ezusb_ABORTPIPE : LongWord;
function IOCTL_Ezusb_GET_STRING_DESCRIPTOR : LongWord;
function IOCTL_EZUSB_GET_DRIVER_VERSION : LongWord;
function IOCTL_EZUSB_ISO_READ : LongWord;
function IOCTL_EZUSB_ISO_WRITE : LongWord;
function IOCTL_EZUSB_START_ISO_STREAM : LongWord;
function IOCTL_EZUSB_STOP_ISO_STREAM : LongWord;
function IOCTL_EZUSB_READ_ISO_BUFFER : LongWord;

implementation

function CTL_CODE ( DeviceType, Fun, Method, Access : LongWord) : LongWord;
Var tmp : LongWord;
begin
   tmp :=
   ( (DeviceType) shl 16) or
   ( (Access) shl 14)     or
   ( (Fun) shl 2)         or
   (Method);
//  tmp:=tmp+1;
//  tmp:=tmp-1;
  Result := tmp;
end;

function IOCTL_Ezusb_GET_PIPE_INFO : LongWord;
begin
   Result := CTL_CODE (FILE_DEVICE_UNKNOWN,
                       Ezusb_IOCTL_INDEX+0,
                       METHOD_BUFFERED,
                       FILE_ANY_ACCESS);
end;
function IOCTL_Ezusb_GET_DEVICE_DESCRIPTOR : LongWord;
begin
   Result := CTL_CODE (FILE_DEVICE_UNKNOWN,
                       Ezusb_IOCTL_INDEX+1,
                       METHOD_BUFFERED,
                       FILE_ANY_ACCESS);
end;

function IOCTL_EZUSB_BULK_READ : LongWord;
begin
   Result := CTL_CODE (FILE_DEVICE_UNKNOWN,
                       Ezusb_IOCTL_INDEX+19,
                       METHOD_OUT_DIRECT,
                       FILE_ANY_ACCESS);
end;

function IOCTL_EZUSB_BULK_WRITE : LongWord;
begin
   Result := CTL_CODE (FILE_DEVICE_UNKNOWN,
                       Ezusb_IOCTL_INDEX+20,
                       METHOD_OUT_DIRECT,
                       FILE_ANY_ACCESS);
end;

function IOCTL_EZUSB_VENDOR_OR_CLASS_REQUEST : LongWord;
begin
   Result := CTL_CODE (FILE_DEVICE_UNKNOWN,
                       Ezusb_IOCTL_INDEX+22,
                       METHOD_IN_DIRECT,
                       FILE_ANY_ACCESS);
end;

function IOCTL_EZUSB_ANCHOR_DOWNLOAD : LongWord;
begin
   Result := CTL_CODE (FILE_DEVICE_UNKNOWN,
                       Ezusb_IOCTL_INDEX+27,
                       METHOD_IN_DIRECT,
                       FILE_ANY_ACCESS);
end;

//#define IOCTL_EZUSB_ANCHOR_DOWNLOAD   CTL_CODE(FILE_DEVICE_UNKNOWN,  \
//                                                   Ezusb_IOCTL_INDEX+27,\
//                                                   METHOD_IN_DIRECT,  \
//                                                   FILE_ANY_ACCESS)

function IOCTL_EZUSB_VENDOR_REQUEST : LongWord;
begin
   Result := CTL_CODE (FILE_DEVICE_UNKNOWN,
                       Ezusb_IOCTL_INDEX+5,
                       METHOD_BUFFERED,
                       FILE_ANY_ACCESS);
end;
//#define IOCTL_Ezusb_VENDOR_REQUEST              CTL_CODE(FILE_DEVICE_UNKNOWN,  \
//                                                   Ezusb_IOCTL_INDEX+5,\
//                                                   METHOD_BUFFERED,  \
//                                                   FILE_ANY_ACCESS)
function IOCTL_Ezusb_RESETPIPE : LongWord;
begin
   Result := CTL_CODE (FILE_DEVICE_UNKNOWN,
                       Ezusb_IOCTL_INDEX+13,
                       METHOD_IN_DIRECT,
                       FILE_ANY_ACCESS);
end;

function IOCTL_Ezusb_ABORTPIPE : LongWord;
begin
   Result := CTL_CODE (FILE_DEVICE_UNKNOWN,
                       Ezusb_IOCTL_INDEX+15,
                       METHOD_IN_DIRECT,
                       FILE_ANY_ACCESS);
end;

function IOCTL_Ezusb_GET_STRING_DESCRIPTOR : LongWord;
begin
   Result := CTL_CODE (FILE_DEVICE_UNKNOWN,
                       Ezusb_IOCTL_INDEX+17,
                       METHOD_BUFFERED,
                       FILE_ANY_ACCESS);
end;

function IOCTL_EZUSB_GET_DRIVER_VERSION : LongWord;
begin
   Result := CTL_CODE (FILE_DEVICE_UNKNOWN,
                       Ezusb_IOCTL_INDEX+29,
                       METHOD_BUFFERED,
                       FILE_ANY_ACCESS);
end;

function IOCTL_EZUSB_ISO_READ : LongWord;
begin
   Result := CTL_CODE (FILE_DEVICE_UNKNOWN,
                       Ezusb_IOCTL_INDEX+25,
                       METHOD_OUT_DIRECT,
                       FILE_ANY_ACCESS);
end;

function IOCTL_EZUSB_ISO_WRITE : LongWord;
begin
   Result := CTL_CODE (FILE_DEVICE_UNKNOWN,
                       Ezusb_IOCTL_INDEX+26,
                       METHOD_OUT_DIRECT,
                       FILE_ANY_ACCESS);
end;

function IOCTL_EZUSB_START_ISO_STREAM : LongWord;
begin
   Result := CTL_CODE (FILE_DEVICE_UNKNOWN,
                       Ezusb_IOCTL_INDEX+30,
                       METHOD_BUFFERED,
                       FILE_ANY_ACCESS);
end;

//#define IOCTL_EZUSB_STOP_ISO_STREAM     CTL_CODE(FILE_DEVICE_UNKNOWN,  \
//                                                   Ezusb_IOCTL_INDEX+31,\
//                                                   METHOD_BUFFERED,  \
//                                                   FILE_ANY_ACCESS)
function IOCTL_EZUSB_STOP_ISO_STREAM : LongWord;
begin
   Result := CTL_CODE (FILE_DEVICE_UNKNOWN,
                       Ezusb_IOCTL_INDEX+31,
                       METHOD_BUFFERED,
                       FILE_ANY_ACCESS);
end;

//#define IOCTL_EZUSB_READ_ISO_BUFFER     CTL_CODE(FILE_DEVICE_UNKNOWN,  \
//                                                   Ezusb_IOCTL_INDEX+32,\
//                                                   METHOD_OUT_DIRECT,  \
//                                                   FILE_ANY_ACCESS)
function IOCTL_EZUSB_READ_ISO_BUFFER : LongWord;
begin
   Result := CTL_CODE (FILE_DEVICE_UNKNOWN,
                       Ezusb_IOCTL_INDEX+32,
                       METHOD_OUT_DIRECT,
                       FILE_ANY_ACCESS);
end;

end.
