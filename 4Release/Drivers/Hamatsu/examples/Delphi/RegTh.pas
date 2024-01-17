unit RegTh;

interface

uses
  Classes, Math, Windows, SysUtils, ccdusb021_i;

type
  TRegThread = class(TThread)
  private
    { Private declarations }
  protected
    procedure Execute; override;

  public
    ID : Integer;
    FFileHandle : THandle;
    FMapHandle : THandle;
    FFileSize : Longword;
    FData  : PBYTE;
    pData : PDWORDArr;
    pDataByte : PBYTEArr;
    Np, Nrow, Ncol, Nf : single;
    f, Block, Blockdiv4, N, NBlock : Integer;
    StTime, CurTime : Cardinal;
    Res : boolean;
    Rate : Real;
//    Rsm : array of double;
  end;

implementation

{ Important: Methods and properties of objects in VCL or CLX can only be used
  in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure TRegThread.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end; }


function DeMin(apData : PDWORDArr; N : Integer) : DWORD;
var i : Integer;
    Sum : DWORD;
begin
  Sum := MAXDWORD;
  for i := 0 to (N-1) do
  begin
     if Sum > apData[i] then
        Sum := apData[i];
  end;
  Result := Sum;
end;

function DeMax(apData : PDWORDArr; N : Integer) : DWORD;
var i : Integer;
    Sum : DWORD;
begin
  Sum := 0;
  for i := 0 to (N-1) do
  begin
     if Sum < apData[i] then
        Sum := apData[i];
  end;
  Result := Sum;
end;

function DeMinByte(apData : PByteArr; N : Integer) : Byte;
var i : Integer;
    Sum : Byte;
begin
  Sum := MAXBYTE;
  for i := 0 to (N-1) do
  begin
     if Sum > apData[i] then
        Sum := apData[i];
  end;
  Result := Sum;
end;

function DeMaxByte(apData : PByteArr; N : Integer) : Byte;
var i : Integer;
    Sum : Byte;
begin
  Sum := 0;
  for i := 0 to (N-1) do
  begin
     if Sum < apData[i] then
        Sum := apData[i];
  end;
  Result := Sum;
end;


{ TRegThread }

procedure TRegThread.Execute;
begin
  { Place thread code here }

//  if not CCD_SetParameter(ID,PRM_DEVICEMODE, GetDEVICEMODESTREAM()) then Exit;

  if not CCD_GetParameter(ID,PRM_NUMPIXELSH, Ncol) then Exit;
  if not CCD_GetParameter(ID,PRM_NUMPIXELSV, Nrow) then Exit;
  if not CCD_GetParameter(ID,PRM_READOUTS, NF) then Exit;
  Np := Ncol * Nrow;
  N := Ceil(N/Round(Nf))*Round(Nf);

//  Block := Round(Np*Nf)*SizeOf(DWORD);
  Block := Round(Np*Nf)*SizeOf(BYTE);

//  Blockdiv4 := Block shr 2;
  Blockdiv4 := Block;
  NBlock :=  Round (N / NF);

  if CCD_HitTest(ID) then
  begin

    FFileHandle := FileCreate('Frames'+IntToStr(ID)+'.frm');
    if FFileHandle = INVALID_HANDLE_VALUE then
      raise Exception.Create('Failed to open or create file');

  try

  try
//    FFileSize := Round(Np*SizeOf(DWORD)*N);
    FFileSize := Round(Np*SizeOf(BYTE)*N);
    FMapHandle := CreateFileMapping(FFileHandle, nil,
       PAGE_READWRITE, 0, FFileSize, nil);

    if FMapHandle = 0 then
      raise Exception.Create('Failed to create file mapping');

  try
    FData := MapViewOfFile(FMapHandle, FILE_MAP_ALL_ACCESS, 0, 0, 0);
  try
    if FData = Nil then
           raise Exception.Create('Failed to map view of file');
//    pData := PDWORDArr(FData);
    pDataBYTE := PBYTEArr(FData);

    F := 0;
try
    if CCD_InitMeasuring(ID) then
    begin
      StTime := GetTickCount;
      if CCD_StartMeasuring (ID) then
        repeat
//          Res := CCD_GetData(ID,Addr(pData[f*Blockdiv4]));
          Res := CCD_GetDataByte(ID,Addr(pDataByte[f*Blockdiv4]));
          if Terminated then Exit;
          if Res then
          begin
             Inc(F);
//             Application.ProcessMessages;
          end;
        until (F>=NBlock );
      CurTime := GetTickCount;
//      lbStreamRate1.Caption := FormatFloat  ('0.###', N/((CurTime-StTime)/1000))+' frame/sec';
      Rate := N/((CurTime-StTime)/1000);
//      Application.ProcessMessages;
    end;
    finally
      CCD_CameraReset(ID);
    end;
    finally
      UnmapViewOfFile(FData);
    end;
    finally
      CloseHandle(FMapHandle);
    end;
    finally
      CloseHandle(FFileHandle);
    end;
  finally
//    SetLength(Rsm, 0);
//    Rsm := nil;
  end;

  end;

end;

end.
