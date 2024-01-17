unit USB100;

interface

Const
MAXIMUM_USB_STRING_LENGTH = 255;

// values for the bits returned by the USB GET_STATUS command
USB_GETSTATUS_SELF_POWERED    =            $01;
USB_GETSTATUS_REMOTE_WAKEUP_ENABLED    =   $02;


USB_DEVICE_DESCRIPTOR_TYPE          =      $01;
USB_CONFIGURATION_DESCRIPTOR_TYPE   =      $02;
USB_STRING_DESCRIPTOR_TYPE          =      $03;
USB_INTERFACE_DESCRIPTOR_TYPE       =      $04;
USB_ENDPOINT_DESCRIPTOR_TYPE        =      $05;
USB_POWER_DESCRIPTOR_TYPE           =      $06;

//USB_DESCRIPTOR_MAKE_TYPE_AND_INDEX(d, i) ((USHORT)((USHORT)d<<8 | i))

//
// Values for bmAttributes field of an
// endpoint descriptor
//

USB_ENDPOINT_TYPE_MASK         =           $03;

USB_ENDPOINT_TYPE_CONTROL      =           $00;
USB_ENDPOINT_TYPE_ISOCHRONOUS  =           $01;
USB_ENDPOINT_TYPE_BULK         =           $02;
USB_ENDPOINT_TYPE_INTERRUPT    =           $03;


//
// definitions for bits in the bmAttributes field of a
// configuration descriptor.
//
USB_CONFIG_POWERED_MASK        =           $c0;

USB_CONFIG_BUS_POWERED         =           $80;
USB_CONFIG_SELF_POWERED        =           $40;
USB_CONFIG_REMOTE_WAKEUP       =           $20;

//
// Endpoint direction bit, stored in address
//

USB_ENDPOINT_DIRECTION_MASK   =            $80;

// test direction bit in the bEndpointAddress field of
// an endpoint descriptor.
//USB_ENDPOINT_DIRECTION_OUT(addr)          (!((addr) & USB_ENDPOINT_DIRECTION_MASK))
//USB_ENDPOINT_DIRECTION_IN(addr)           ((addr) & USB_ENDPOINT_DIRECTION_MASK)

//
// USB defined request codes
// see chapter 9 of the USB 1.0 specifcation for
// more information.
//

// These are the correct values based on the USB 1.0
// specification

USB_REQUEST_GET_STATUS          =          $00;
USB_REQUEST_CLEAR_FEATURE       =          $01;

USB_REQUEST_SET_FEATURE         =          $03;

USB_REQUEST_SET_ADDRESS         =          $05;
USB_REQUEST_GET_DESCRIPTOR      =          $06;
USB_REQUEST_SET_DESCRIPTOR      =          $07;
USB_REQUEST_GET_CONFIGURATION   =          $08;
USB_REQUEST_SET_CONFIGURATION   =          $09;
USB_REQUEST_GET_INTERFACE       =          $0A;
USB_REQUEST_SET_INTERFACE       =          $0B;
USB_REQUEST_SYNC_FRAME          =          $0C;


//
// defined USB device classes
//


USB_DEVICE_CLASS_RESERVED           = $00;
USB_DEVICE_CLASS_AUDIO              = $01;
USB_DEVICE_CLASS_COMMUNICATIONS     = $02;
USB_DEVICE_CLASS_HUMAN_INTERFACE    = $03;
USB_DEVICE_CLASS_MONITOR            = $04;
USB_DEVICE_CLASS_PHYSICAL_INTERFACE = $05;
USB_DEVICE_CLASS_POWER              = $06;
USB_DEVICE_CLASS_PRINTER            = $07;
USB_DEVICE_CLASS_STORAGE            = $08;
USB_DEVICE_CLASS_HUB                = $09;
USB_DEVICE_CLASS_VENDOR_SPECIFIC    = $FF;

//
// USB defined Feature selectors
//

USB_FEATURE_ENDPOINT_STALL       =   $0000;
USB_FEATURE_REMOTE_WAKEUP        =   $0001;
USB_FEATURE_POWER_D0             =   $0002;
USB_FEATURE_POWER_D1             =   $0003;
USB_FEATURE_POWER_D2             =   $0004;
USB_FEATURE_POWER_D3             =   $0005;

TYPE

TUSB_DEVICE_DESCRIPTOR = record
    bLength : Byte;
    bDescriptorType : Byte;
    bcdUSB : Word;
    bDeviceClass : Byte;
    bDeviceSubClass : Byte;
    bDeviceProtocol : Byte;
    bMaxPacketSize0 : Byte;
    idVendor : Word;
    idProduct : Word;
    bcdDevice : Word;
    iManufacturer : Byte;
    iProduct : Byte;
    iSerialNumber : Byte;
    bNumConfigurations : Byte;
 end; // USB_DEVICE_DESCRIPTOR, *PUSB_DEVICE_DESCRIPTOR;
 PUSB_DEVICE_DESCRIPTOR = ^TUSB_DEVICE_DESCRIPTOR;

TUSB_ENDPOINT_DESCRIPTOR = record
    bLength : Byte;
    bDescriptorType : Byte;
    bEndpointAddress : Byte;
    bmAttributes : Byte;
    wMaxPacketSize : Word;
    bInterval : Byte;
 end; // USB_ENDPOINT_DESCRIPTOR, *PUSB_ENDPOINT_DESCRIPTOR;
 PUSB_ENDPOINT_DESCRIPTOR = ^TUSB_ENDPOINT_DESCRIPTOR;

TUSB_CONFIGURATION_DESCRIPTOR = record
    bLength : Byte;
    bDescriptorType : Byte;
    wTotalLength : Word;
    bNumInterfaces : Byte;
    bConfigurationValue : Byte;
    iConfiguration : Byte;
    bmAttributes : Byte;
    MaxPower : Byte;
 end; // USB_CONFIGURATION_DESCRIPTOR, *PUSB_CONFIGURATION_DESCRIPTOR;
 PUSB_CONFIGURATION_DESCRIPTOR = ^TUSB_CONFIGURATION_DESCRIPTOR;

TUSB_INTERFACE_DESCRIPTOR = record
    bLength : Byte;
    bDescriptorType : Byte;
    bInterfaceNumber : Byte;
    bAlternateSetting : Byte;
    bNumEndpoints : Byte;
    bInterfaceClass : Byte;
    bInterfaceSubClass : Byte;
    bInterfaceProtocol : Byte;
    iInterface : Byte;
 end; // USB_INTERFACE_DESCRIPTOR, *PUSB_INTERFACE_DESCRIPTOR;
 PUSB_INTERFACE_DESCRIPTOR = ^TUSB_INTERFACE_DESCRIPTOR;

TUSB_STRING_DESCRIPTOR = record
    bLength  : Byte;
    bDescriptorType  : Byte;
    bString : PChar;
 end; // USB_STRING_DESCRIPTOR, *PUSB_STRING_DESCRIPTOR;
 PUSB_STRING_DESCRIPTOR = ^TUSB_STRING_DESCRIPTOR;

implementation

end.
