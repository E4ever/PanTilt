unit RegThread_V06;

interface

uses
  WIndows, Classes, ccdusb06, SyncObjs, USB100, ezusbsys, SysUtils, ccdusb021_u, Math;

type
  TRegThread_V06 = class(TThread)
  private
    { Private declarations }
  protected
    procedure Execute; override;
  public
    ID : Integer;
    ws : TWaitResult;
    btc : TBULK_TRANSFER_CONTROL;
    r : Boolean;
    Size : DWORD;
    USBDeviceHandle  : THANDLE;
    aDataSize : DWORD;
    pwData : PWORDArr;
    pEv    : ^TEvent;
//    pEvCanCOpy  : ^TEvent;
    ezusb : string;
    le : Cardinal;
  end;

implementation

{ Important: Methods and properties of objects in VCL or CLX can only be used
  in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure TRegThread_V06.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end; }

{ TRegThread_V06 }

procedure TRegThread_V06.Execute;
Label L1, L2;
begin
  { Place thread code here }
  csData.Enter;
try
  ezusb := '\\.\ezusb-'+IntTostr(DriverIndex[ID]);
  btc.pipeNum:=0;
finally
   csData.Leave;
end;

L1:
  repeat
//   csData.Enter;
//try
   ws := pEv^.WaitFor(2000);
//finally
//   csData.Leave;
//end;
   if Terminated then Exit;
  until ws <> wrTimeout;

  //Sleep(50);

  USBDeviceHandle := CreateFile (PChar(ezusb),
                 GENERIC_WRITE,
                 FILE_SHARE_WRITE,
                 nil,
                 OPEN_EXISTING,
                 0,
                 0 );
try
  if USBDeviceHandle <> INVALID_HANDLE_VALUE then
  begin
      r:= DeviceIoControl ( USBDeviceHandle,
                            IOCTL_EZUSB_BULK_READ,
                            @btc,
                            sizeof(TBULK_TRANSFER_CONTROL),
                            Addr(pwData[0]),
                            aDataSize,
                            Size,
                            nil);
//      le := GetLastError;

//      OutputDebugString(PChar(IntToStr(pwData[0] AND $00FF)));
//      OutputDebugString(PChar(IntToStr((pwData[0] AND $FF00) shr 8)));
//      OutputDebugString(PChar(IntToStr(pwData[1] AND $00FF)));
//      OutputDebugString(PChar(IntToStr((pwData[1] AND $FF00) shr 8)));

      if r then
      begin
//        if not bInitMesure[ID] then Exit;
      end else begin
                 dwStatus[ID] := STATUS_USB_ERORR;
                 Goto L2;
               end;

      pEv^.ResetEvent;
      csData.Enter;
try
      dwStatus[ID] := STATUS_DATA_READY;
      if Assigned(cbfDataReady[ID]) then
         cbfDataReady[ID];
finally
      csData.Leave;
end;
L2:

  end;  // if USBDeviceHandle <> INVALID_HANDLE_VALUE then

finally
  CloseHandle (USBDeviceHandle);
end; //  try finally

  if Terminated then Exit;

  GoTo L1;
end;

end.
