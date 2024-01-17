unit Test;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, {ccd_u, ccdusb021_u, ccddcom_u, }ccdusb021_i,
  StdCtrls, ExtCtrls, Spin, TeEngine, Series, TeeProcs, Chart,
  Grids, ComCtrls, Mask, Buttons, Math;

type

  TForm1 = class(TForm)
    btnGetSerialNum: TButton;
    PageControl1: TPageControl;
    Parameters: TTabSheet;
    TabSheet2: TTabSheet;
    seSumMode: TSpinEdit;
    seSynchr: TSpinEdit;
    seNumReadOuts: TSpinEdit;
    seNumPH: TSpinEdit;
    sePixelRate: TSpinEdit;
    seDigitalCap: TSpinEdit;
    btnSetPrms: TButton;
    btnGetPrms: TButton;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label1: TLabel;
    Button12: TButton;
    Button10: TButton;
    Button11: TButton;
    Button8: TButton;
    lbSerialNum: TLabel;
    Label2: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label14: TLabel;
    StringGrid1: TStringGrid;
    seNumPV: TSpinEdit;
    seDeviceMode: TSpinEdit;
    seStripCount: TSpinEdit;
    v: TSpinEdit;
    edtExpTime: TEdit;
    btnClearStrips: TButton;
    btnAddStrip: TButton;
    btnDelStrip: TButton;
    SpinEdit12: TSpinEdit;
    Label13: TLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    seLeft: TSpinEdit;
    seRight: TSpinEdit;
    seTop: TSpinEdit;
    seBottom: TSpinEdit;
    Label19: TLabel;
    CheckBox1: TCheckBox;
    Chart1: TChart;
    Series1: TFastLineSeries;
    Label20: TLabel;
    edtPreBurn: TSpinEdit;
    Label21: TLabel;
    seShuterTime: TEdit;
    Label22: TLabel;
    lnNPKT: TLabel;
    edtRemoteHost: TEdit;
    btnSetRemoteHost: TButton;
    seID: TSpinEdit;
    Label23: TLabel;
    TabSheet1: TTabSheet;
    GroupBox1: TGroupBox;
    SpeedButton2: TSpeedButton;
    SpeedButton1: TSpeedButton;
    btnSynchCom: TButton;
    btnFastScan1: TButton;
    lbRate: TLabel;
    btnFastScan2: TButton;
    btnFastScan3: TButton;
    tsStreamScan: TTabSheet;
    btnStreamScan1: TButton;
    lbStreamRate: TLabel;
    ProgressBar1: TProgressBar;
    btnStreamScanTh0: TButton;
    lbStreamRate0: TLabel;
    btnStreamScanTh1: TButton;
    btnStreamScanTh2: TButton;
    lbStreamRate1: TLabel;
    lbStreamRate2: TLabel;
    cbStreamScan: TComboBox;
    btnStreamScanCallBack0: TButton;
    lbStreamRateCB0: TLabel;
    lbStreamRateCB1: TLabel;
    btnStreamScanCallBack1: TButton;
    lbStreamRateCB2: TLabel;
    btnStreamScanCallBack2: TButton;
    cbDeviceMode: TComboBox;
    lbDeviceMode: TLabel;
    tsPin0: TTabSheet;
    SpeedButton3: TSpeedButton;
    procedure btnSetPrmsClick(Sender: TObject);
    procedure btnGetPrmsClick(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnGetSerialNumClick(Sender: TObject);
    procedure btnClearStripsClick(Sender: TObject);
    procedure btnDelStripClick(Sender: TObject);
    procedure btnAddStripClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnSetRemoteHostClick(Sender: TObject);
    procedure seIDChange(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure btnSynchComClick(Sender: TObject);
    procedure btnFastScan1Click(Sender: TObject);
    procedure btnFastScan2Click(Sender: TObject);
    procedure btnFastScan3Click(Sender: TObject);
    procedure btnStreamScan1Click(Sender: TObject);
    procedure btnStreamScanTh0Click(Sender: TObject);
    procedure btnStreamScanTh1Click(Sender: TObject);
    procedure btnStreamScanTh2Click(Sender: TObject);
    procedure btnStreamScanCallBack0Click(Sender: TObject);
    procedure btnStreamScanCallBack1Click(Sender: TObject);
    procedure btnStreamScanCallBack2Click(Sender: TObject);
    procedure cbDeviceModeChange(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
  private
    { Private declarations }
    function GetDEVICEMODESTREAM() : Integer;
  public
    { Public declarations }
    Procedure FOnTerminateTh0 (Sender: TObject);
    Procedure FOnTerminateTh1 (Sender: TObject);
    Procedure FOnTerminateTh2 (Sender: TObject);
  end;

var
  Form1: TForm1;
  ID : Integer;
  serial : string;


procedure SetDevicePropertyToForm( DevProperty : DWORD );

implementation

Uses RegTh;

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
Var Prm : array[0..99] of CHAR;
//    ID : Integer;
begin

    if CCD_Init(Application.Handle, Addr(Prm), ID) then
    else
       ShowMessage('False');
    ID := seID.Value;
end;

procedure TForm1.btnSetPrmsClick(Sender: TObject);
Var Prms : TCCDUSBExtendParams;
    i, j : Integer;
 Prm : array[0..99] of CHAR;
begin

(*    if CCD_Init(Application.Handle, Addr(Prm), ID) then
    else
       ShowMessage('False');
  *)

    Prms.dwDigitCapacity := Round (seDigitalCap.Value);
    Prms.nPixelRate := Round (sePixelRate.Value);
    Prms.nNumPixelsH := Round (seNumPH.Value);
    Prms.nNumPixelsV := Round (seNumPV.Value);
    Prms.nNumReadOuts := Round (seNumReadOuts.Value);
    Prms.sExposureTime := StrToFloat(edtExpTime.Text);
    Prms.sShuterTime := StrToFloat(seShuterTime.Text);
    Prms.sPreBurning := Round (edtPreBurn.Value);
    Prms.dwSynchr := Round (seSynchr.Value);
    if Round (seSumMode.Value) <> 0 then
      Prms.bSummingMode := true else
      Prms.bSummingMode := false;
    if CheckBox1.Checked then
      Prms.dwSensitivity := 1  else
      Prms.dwSensitivity := 0;
    Prms.dwDeviceMode := seDeviceMode.Value;
    Prms.nStripCount := Round (seStripCount.Value);
try
    for i:=0 to Prms.nStripCount-1 do
    begin
       Prms.rcStrips[i].Left :=    StrToInt (StringGrid1.Cells[1,i+1]);
       Prms.rcStrips[i].Right :=   StrToInt (StringGrid1.Cells[2,i+1]);
       Prms.rcStrips[i].Top :=     StrToInt (StringGrid1.Cells[3,i+1]);
       Prms.rcStrips[i].Bottom :=  StrToInt (StringGrid1.Cells[4,i+1]);
    end;
except on EConvertError do
    begin
       ShowMessage('Convert Error in table!');
       Exit;
    end;
end;
    if CCD_SetExtendParameters(ID,Prms) then
    begin
       seDigitalCap.Value := Prms.dwDigitCapacity;
       sePixelRate.Value := Prms.nPixelRate;
       seNumPH.Value := Prms.nNumPixelsH;
       seNumPV.Value := Prms.nNumPixelsV;

       seNumReadOuts.Value := Prms.nNumReadOuts;
       edtExpTime.Text := FloatToStr(Round(Prms.sExposureTime*1000)/1000);
       seSynchr.Value := Prms.dwSynchr;
       seShuterTime.Text := FloatToStr(Round(Prms.sShuterTime*1000)/1000);

       seSumMode.Value := Integer(Prms.bSummingMode);
       seDeviceMode.Value := Prms.dwDeviceMode;
       seStripCount.Value := Prms.nStripCount;

       for j:=1 to StringGrid1.RowCount-1 do
         for i:=1 to StringGrid1.ColCount-1 do
         begin
           StringGrid1.Cells[i,j] := '';
         end;

       for i:=0 to Prms.nStripCount-1 do
       begin
         StringGrid1.Cells[1,i+1] := IntToStr (Prms.rcStrips[i].Left);
         StringGrid1.Cells[2,i+1] := IntToStr (Prms.rcStrips[i].Right);
         StringGrid1.Cells[3,i+1] := IntToStr (Prms.rcStrips[i].Top);
         StringGrid1.Cells[4,i+1] := IntToStr (Prms.rcStrips[i].Bottom);
       end;
       SetDevicePropertyToForm(Prms.dwProperty);
    end else
    begin
       ShowMessage('False');
    end;

end;

procedure TForm1.btnGetPrmsClick(Sender: TObject);
Var Prms : TCCDUSBExtendParams;
    i,j : Integer;
begin
    if CCD_GetExtendParameters( ID , Prms ) then
    begin
       seDigitalCap.Value := Prms.dwDigitCapacity;
       sePixelRate.Value := Prms.nPixelRate;
       seNumPH.Value := Prms.nNumPixelsH;
       seNumPV.Value := Prms.nNumPixelsV;

       seNumReadOuts.Value := Prms.nNumReadOuts;
       edtExpTime.Text := FloatToStr(Round(Prms.sExposureTime*1000)/1000);
       edtPreBurn.Value := Round (Prms.sPreBurning);
       seShuterTime.Text := FloatToStr(Round(Prms.sShuterTime*1000)/1000);
       seSynchr.Value := Prms.dwSynchr;

       seSumMode.Value := Integer(Prms.bSummingMode);
       seDeviceMode.Value := Prms.dwDeviceMode;
       seStripCount.Value := Prms.nStripCount;

       if Prms.dwSensitivity = 1 then
         CheckBox1.Checked := true  else
         CheckBox1.Checked := false;

       for j:=1 to StringGrid1.RowCount-1 do
         for i:=1 to StringGrid1.ColCount-1 do
         begin
           StringGrid1.Cells[i,j] := '';
         end;
       for i:=0 to Prms.nStripCount-1 do
       begin
         StringGrid1.Cells[1,i+1] := IntToStr (Prms.rcStrips[i].Left);
         StringGrid1.Cells[2,i+1] := IntToStr (Prms.rcStrips[i].Right);
         StringGrid1.Cells[3,i+1] := IntToStr (Prms.rcStrips[i].Top);
         StringGrid1.Cells[4,i+1] := IntToStr (Prms.rcStrips[i].Bottom);
       end;
       SetDevicePropertyToForm(Prms.dwProperty);
    end else
    begin
       ShowMessage('False');
    end;
end;

procedure TForm1.Button8Click(Sender: TObject);
Var pData : PDWORDArr;
    Np, Nrow, Ncol, Nf  : single;
    i : Integer;
begin
  CCD_GetParameter(ID,PRM_NUMPIXELSH, Ncol);
  CCD_GetParameter(ID,PRM_NUMPIXELSV, Nrow);
  Np := Ncol * Nrow;
  CCD_GetParameter(ID,PRM_READOUTS,  NF);

  Series1.Clear;
  Application.ProcessMessages;

  GetMem(pData, Round(Np*SizeOf(DWORD)*Nf));
try
  if CCD_HitTest(ID) then
   if CCD_InitMeasuringData(ID,pData) then
   begin
     if CCD_StartWaitMeasuring (ID) then
      begin
       for i:=0 to (Round(Np*NF)-1) do
        Series1.AddXY(i,pData[i],'',clTeeColor);
      end;
      begin
//       for i:=0 to (Round(Np*NF)-1) do
//         Series1.AddXY(i,pData[i],'',clTeeColor);
      end;
   end;
{  if CCD_HitTest(ID) then
   if CCD_InitMeasuring(ID) then
     if CCD_StartWaitMeasuring (ID) then
       if CCD_GetData(ID,pData) then
       begin
        Series1.Clear;
        for i:=0 to (Round(Np*NF)-1) do
          Series1.AddXY(i,pData[i],'',clTeeColor);
       end;}
 Application.ProcessMessages;
finally
  FreeMem(pData);
end; // try ... finally
end;

procedure TForm1.Button10Click(Sender: TObject);
Var ms : DWord;
begin
    ms:=0;
    if CCD_GetMeasureStatus (ID, ms) then
    else
       ShowMessage('False');
    Label19.Caption := IntTostr(ms);
end;

procedure TForm1.Button11Click(Sender: TObject);
Var pData : PDWORDArr;
    Np, Nrow, Ncol, Nf : single;
    status : DWORD;
    i : Integer;
begin
  CCD_GetParameter(ID,PRM_NUMPIXELSH, Ncol);
  CCD_GetParameter(ID,PRM_NUMPIXELSV, Nrow);
  Np := Ncol * Nrow;
  CCD_GetParameter(ID,PRM_READOUTS,  NF);
  GetMem(pData, Round(Np*SizeOf(DWORD)*Nf));
try
  if CCD_HitTest(ID) then
   if CCD_InitMeasuringData(ID,pData) then
     if CCD_StartMeasuring (ID) then
     begin
      Application.ProcessMessages;
      repeat
       if not CCD_GetMeasureStatus(ID,status)
        then Exit;
//           OutputDebugString (PCHAR('CCD_GetMeasureStatus(ID,status)'));

       Application.ProcessMessages;
      until status = STATUS_DATA_READY;
       Series1.Clear;
       for i:=0 to (Round(Np*NF)-1) do
         Series1.AddXY(i,pData[i],'',clTeeColor);
//        ShowMessage('Ok');
     end;
{  if CCD_HitTest(ID) then
   if CCD_InitMeasuring(ID) then
     if CCD_StartMeasuring (ID) then
     begin
      Application.ProcessMessages;
      repeat
       if not CCD_GetMeasureStatus(ID,status)
        then Exit;
       Application.ProcessMessages;
      until status = STATUS_DATA_READY;
       CCD_GetData(ID,pData);
       Series1.Clear;
       for i:=0 to (Round(Np*NF)-1) do
         Series1.AddXY(i,pData[i],'',clTeeColor);
//        ShowMessage('Ok');
     end;                      }
finally
  FreeMem(pData);
end; // try ... finally
end;

procedure TForm1.Button12Click(Sender: TObject);
begin
    if CCD_CameraReset(ID) then
    else
       ShowMessage('False');
end;

procedure TForm1.btnGetSerialNumClick(Sender: TObject);
Var str : PChar;
begin
//    str := CCD_GetSensorName(ID);
    if CCD_GetSerialNum (ID,str) then
      lbSerialNum.Caption := str
    else
       ShowMessage('False');
end;

procedure TForm1.btnClearStripsClick(Sender: TObject);
begin
    if CCD_ClearStrips( ID ) then
    begin
          btnGetPrmsClick(Sender);
    end else
    begin
       ShowMessage('False');
    end;
end;

procedure TForm1.btnDelStripClick(Sender: TObject);
begin
    if CCD_DeleteStrip( ID, SpinEdit12.Value ) then
    begin
          btnGetPrmsClick(Sender);
    end else
    begin
       ShowMessage('False');
    end;
end;

procedure TForm1.btnAddStripClick(Sender: TObject);
begin

    if CCD_AddStrip( ID,
         Rect ( {Left}  seLeft.Value,
                {Top}   seTop.Value,
                {Right} seRight.Value,
                {Botom} seBottom.Value) ) then
    begin
        btnGetPrmsClick(Sender);
    end else
    begin
       ShowMessage('False');
    end;
end;

procedure SetDevicePropertyToForm( DevProperty : DWORD );
begin
    if (DevProperty and DP_SENSIT) <> 0 then
       Form1.CheckBox1.Enabled := true else
       Form1.CheckBox1.Enabled := false;
    if (DevProperty and (DP_MODEA2 or DP_MODES1 or DP_MODES2 or DP_STREAMSCAN or DP_STENDMODE2 or DP_STREAMSCANBYTE or DP_STREAMSCANBYTE1)) <> 0 then
       Form1.seDeviceMode.Enabled := true else
       Form1.seDeviceMode.Enabled := false;
    if (DevProperty and DP_MODES1) <> 0 then
    begin
       Form1.StringGrid1.Enabled := true;
       Form1.btnClearStrips.Enabled := true;
       Form1.btnAddStrip.Enabled := true;
       Form1.btnDelStrip.Enabled := true;
       Form1.SpinEdit12.Enabled := true;
       Form1.seLeft.Enabled := true;
       Form1.seRight.Enabled := true;
       Form1.seTop.Enabled := true;
       Form1.seBottom.Enabled := true;
    end  else
    begin
       Form1.StringGrid1.Enabled := false;
       Form1.btnClearStrips.Enabled := false;
       Form1.btnAddStrip.Enabled := false;
       Form1.btnDelStrip.Enabled := false;
       Form1.SpinEdit12.Enabled := false;
       Form1.seLeft.Enabled := false;
       Form1.seRight.Enabled := false;
       Form1.seTop.Enabled := false;
       Form1.seBottom.Enabled := false;
    end;
    if (DevProperty and DP_PREBURNING) <> 0 then
       Form1.edtPreBurn.Enabled := true
     else
       Form1.edtPreBurn.Enabled := false;
    if (DevProperty and DP_SHUTER) <> 0 then
       Form1.seShuterTime.Enabled := true
     else
       Form1.seShuterTime.Enabled := false;
    if (DevProperty and DP_FASTSCAN) <> 0 then
    begin
       with Form1 do
       begin
         btnFastScan1.Enabled := true;
         btnFastScan2.Enabled := true;
         btnFastScan3.Enabled := true;
         lbRate.Enabled := true;
       end;
    end else
        begin
       with Form1 do
       begin
         btnFastScan1.Enabled := false;
         btnFastScan2.Enabled := false;
         btnFastScan3.Enabled := false;
         lbRate.Enabled := false;
//           tsStreamScan.TabVisible := false;
       end;
        end;
    if (DevProperty and DP_STREAMSCAN) <> 0 then
    begin
       with Form1 do
       begin
//         btnStreamScan1.Enabled := true;
//         lbStreamRate.Enabled := true;
         tsStreamScan.TabVisible := true;
         cbDeviceMode.Enabled := true;
         cbDeviceMode.ItemIndex := 0;
         lbDeviceMode.Enabled := true;
       end;
    end else
        begin
       with Form1 do
       begin
//         btnStreamScan1.Enabled := false;
//         lbStreamRate.Enabled := false;
         tsStreamScan.TabVisible := false;
         cbDeviceMode.Enabled := false;
         lbDeviceMode.Enabled := false;
       end;
        end;

    Form1.cbDeviceMode.Items.Delete(2);
    Form1.cbDeviceMode.Items.Delete(1);

    if (DevProperty and DP_STREAMSCANBYTE) <> 0 then
    begin
       with Form1 do
       begin
          cbDeviceMode.Items.Add('DEVICEMODESTREAMBYTE');
       end;
    end else
        begin
       with Form1 do
       begin
       end;
        end;

    if (DevProperty and DP_STREAMSCANBYTE1) <> 0 then
    begin
       with Form1 do
       begin
          cbDeviceMode.Items.Add('DEVICEMODESTREAMBYTE1');
       end;
    end else
        begin
       with Form1 do
       begin
       end;
        end;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
   CCDDCOM_DisconectDCOM(ID);
end;

procedure TForm1.btnSetRemoteHostClick(Sender: TObject);
Var Prm : array[0..99] of CHAR;
begin
    if CCDDCOM_SetDCOMRemoteName(ID, PChar(edtRemoteHost.Text) ) then
      if CCD_Init(Application.Handle, Addr(Prm), ID) then
       else
         ShowMessage('False')
      else
         ShowMessage('False');
    ID := seID.Value;
end;

procedure TForm1.seIDChange(Sender: TObject);
begin
   ID := seID.Value;
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
begin
    CCDUSB_SetPIN4 ( SpeedButton2.Down);
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
    CCDUSB_SetPIN3 ( SpeedButton1.Down);
end;

procedure TForm1.btnSynchComClick(Sender: TObject);
begin
   CCDUSB_SynchPIN;
end;

procedure TForm1.btnFastScan1Click(Sender: TObject);
Var pData : PDWORDArr;
    Np, Nrow, Ncol  : single;
    f, i, N : Integer;
    StTime, CurTime : Cardinal;
begin

  CCD_GetParameter(ID,PRM_NUMPIXELSH, Ncol);
  CCD_GetParameter(ID,PRM_NUMPIXELSV, Nrow);
  Np := Ncol * Nrow;
  N := 100;
//  N := 1;

  Application.ProcessMessages;
  GetMem(pData, Round(Np*SizeOf(DWORD)));

  CCD_SetParameter(ID,PRM_DEVICEMODE, DEVICEMODEFASTSCAN);

try
  if CCD_HitTest(ID) then
  begin
    if CCD_InitMeasuring(ID) then
    StTime := GetTickCount;
     if CCD_StartMeasuring (ID) then
      for f := 0 to (N-1) do
      begin
        if CCD_GetData(ID,pData) then
        begin
          if f<>(N-1) then
           if CCD_StartMeasuring (ID) then
           begin
             Series1.Clear;
             for i:=0 to (Round(1000)-1) do
               Series1.AddXY(i,pData[i],'',clTeeColor);
             Application.ProcessMessages;
           end else
              Exit;
        end
            else Exit;
      end;
   CurTime := GetTickCount;
try
   lbRate.Caption := FormatFloat  ('0.###', N/((CurTime-StTime)/1000))+' frame/sec';
except
   On EDivByZero do
      lbRate.Caption := FormatFloat  ('0.###', 0) +' frame/sec';
end;
   CCD_CameraReset(ID);
   Series1.Clear;
   for i:=0 to (Round(Ncol)-1) do
      Series1.AddXY(i,pData[i],'',clTeeColor);
   Application.ProcessMessages;
  end;
finally
  FreeMem(pData);
end; // try ... finally
end;

procedure TForm1.btnFastScan2Click(Sender: TObject);
Const N = 50;
Var pData : array [0..N-1] of PDWORDArr;
    Np, Nrow, Ncol  : single;
    f, i : Integer;
    StTime, CurTime : Cardinal;
begin
  CCD_GetParameter(ID,PRM_NUMPIXELSH, Ncol);
  CCD_GetParameter(ID,PRM_NUMPIXELSV, Nrow);
  Np := Ncol * Nrow;
  for i := 0 to N-1 do
    GetMem(pData[i], Round(Np*SizeOf(DWORD)));
  CCD_SetParameter(ID,PRM_DEVICEMODE, DEVICEMODEFASTSCAN);
    
try
  if CCD_HitTest(ID) then
  begin
    if CCD_InitMeasuring(ID) then
    StTime := GetTickCount;
     if CCD_StartMeasuring (ID) then
      for f := 0 to (N-1) do
      begin
        if CCD_GetData(ID,pData[f]) then
        begin
          if f<>(N-1) then
           if CCD_StartMeasuring (ID) then
           begin
             Series1.Clear;
             for i:=0 to (Round(1000)-1) do
               Series1.AddXY(i,pData[f][i],'',clTeeColor);
             Application.ProcessMessages;
           end else
              Exit;
        end
            else Exit;
      end;
    CurTime := GetTickCount;
    lbRate.Caption := FormatFloat  ('0.###', N/((CurTime-StTime)/1000))+' frame/sec';
    CCD_CameraReset(ID);
    Series1.Clear;
    for i:=0 to (Round(Ncol)-1) do
      Series1.AddXY(i,pData[(N-1)][i],'',clTeeColor);
    Application.ProcessMessages;
  end;
finally
  for i := 0 to N-1 do
    FreeMem(pData[i]);
end; // try ... finally
end;

procedure TForm1.btnFastScan3Click(Sender: TObject);
Var
   FFileHandle : THandle;
   FMapHandle : THandle;
   FFileSize : Longword;
   FData  : PBYTE;
   pData : PDWORDArr;
   Np, Nrow, Ncol  : single;
   f, i, Block, Blockdiv4, N : Integer;
   StTime, CurTime : Cardinal;
begin

  if not CCD_GetParameter(ID,PRM_NUMPIXELSH, Ncol) then Exit;
  if not CCD_GetParameter(ID,PRM_NUMPIXELSV, Nrow) then Exit;
  Np := Ncol * Nrow;
  N := 100;
  Block := Round(Np)*SizeOf(DWORD);
  Blockdiv4 := Block shr 2;

  CCD_SetParameter(ID,PRM_DEVICEMODE, DEVICEMODEFASTSCAN);
  
  if CCD_HitTest(ID) then
  begin

    FFileHandle := FileCreate('Frames.frm');
    if FFileHandle = INVALID_HANDLE_VALUE then
      raise Exception.Create('Failed to open or create file');

  try
    FFileSize := Round(Np*SizeOf(DWORD))*N;
    FMapHandle := CreateFileMapping(FFileHandle, nil,
       PAGE_READWRITE, 0, FFileSize, nil);

    if FMapHandle = 0 then
      raise Exception.Create('Failed to create file mapping');

  try
    FData := MapViewOfFile(FMapHandle, FILE_MAP_ALL_ACCESS, 0, 0, 0);
  try
    if FData = Nil then
           raise Exception.Create('Failed to map view of file');
    pData := PDWORDArr(FData);

    if CCD_InitMeasuring(ID) then
    begin
      StTime := GetTickCount;
      if CCD_StartMeasuring (ID) then
       for f := 0 to (N-1) do
       begin
        if CCD_GetData(ID,Addr(pData[f*Blockdiv4])) then
        begin
          if f<>(N-1) then
           if CCD_StartMeasuring (ID) then
           begin
             Series1.Clear;
             for i:=0 to (Round(1000)-1) do
               Series1.AddXY(i,pData[(f*Blockdiv4)+i],'',clTeeColor);
             Application.ProcessMessages;
           end else
              Exit;
        end
            else Exit;
      end;
      CurTime := GetTickCount;
      lbRate.Caption := FormatFloat  ('0.###', N/((CurTime-StTime)/1000))+' frame/sec';
      CCD_CameraReset(ID);
      Series1.Clear;
      for i:=0 to (Round(Ncol)-1) do
        Series1.AddXY(i,pData[(N-1)*Blockdiv4+i],'',clTeeColor);
      Application.ProcessMessages;
    end;
    finally
      CloseHandle(FFileHandle);
    end;
    finally
      UnmapViewOfFile(FData);
    end;
    finally
      CloseHandle(FMapHandle);
    end;
  end;
end;

// Используйте для задания формата выходного файла
// На один пиксел можно использовать
// 4-байта - DWORD
// 2-байта - WORD
// 1-байт  - BYTE
//{$define DATADWORD}
//{$define DATAWORD}
{$define DATABYTE}

procedure TForm1.btnStreamScan1Click(Sender: TObject);
// Камера переводится в режим DEVICEMODESTREAM.
// Камера работает непрерывно, пока не будет вызвана CCD_CameraReset.
// nNumReadOuts - размер двух внутренних, переменно работающих буферов (<=6).
// Регистрируется некоторое число кадров, от 10000 до 1000000.
// Выходные данные сохраняются в файл.
// Работает только с одной камерой.
Var
   FFileHandle : THandle;
   FMapHandle : THandle;
   FFileSize : Longword;
   FData  : PBYTE;
{$IFDEF DATADWORD}
   pData : PDWORDArr;
{$ENDIF}
{$IFDEF DATAWORD}
   pwData : PWORDArr;
{$ENDIF}
{$IFDEF DATABYTE}
   pbData : PBYTEArr;
{$ENDIF}
   Np, Nrow, Ncol, Nf : single;
   f, Block, Blockdiv4, N, NBlock : Integer;
   StTime, CurTime : Cardinal;
   Res : boolean;
   DataSize : Integer;
begin

  btnStreamScan1.Enabled := False;

  if not CCD_SetParameter(ID,PRM_DEVICEMODE, GetDEVICEMODESTREAM()) then Exit;

  if not CCD_GetParameter(ID,PRM_NUMPIXELSH, Ncol) then Exit;
  if not CCD_GetParameter(ID,PRM_NUMPIXELSV, Nrow) then Exit;
  if not CCD_GetParameter(ID,PRM_READOUTS, NF) then Exit;
  Np := Ncol * Nrow;
  N := StrToInt(cbStreamScan.Items[cbStreamScan.ItemIndex]);
  N := Ceil(N/Round(Nf))*Round(Nf);

{$IFDEF DATADWORD}
  DataSize := SizeOf(DWORD);
{$ENDIF}
{$IFDEF DATAWORD}
  DataSize := SizeOf(WORD);
{$ENDIF}
{$IFDEF DATABYTE}
  DataSize := SizeOf(BYTE);
{$ENDIF}
  Block := Round(Np*Nf)*DataSize;

  Blockdiv4 := Block div DataSize;
  NBlock :=  Round (N / NF);

  ProgressBar1.Max := NBlock;
  ProgressBar1.Position := 0;

  if CCD_HitTest(ID) then
  begin

    FFileHandle := FileCreate('Frames.frm');
    if FFileHandle = INVALID_HANDLE_VALUE then
      raise Exception.Create('Failed to open or create file');

  try
    FFileSize := Round(Np*DataSize*N);
    FMapHandle := CreateFileMapping(FFileHandle, nil,
       PAGE_READWRITE, 0, FFileSize, nil);

    if FMapHandle = 0 then
      raise Exception.Create('Failed to create file mapping');

  try
    FData := MapViewOfFile(FMapHandle, FILE_MAP_ALL_ACCESS, 0, 0, 0);
  try
    if FData = Nil then
           raise Exception.Create('Failed to map view of file');
{$IFDEF DATADWORD}
    pData := PDWORDArr(FData);
{$ENDIF}
{$IFDEF DATAWORD}
    pwData := PWORDArr(FData);
{$ENDIF}
{$IFDEF DATABYTE}
    pbData := PBYTEArr(FData);
{$ENDIF}

    F := 0;
try
    if CCD_InitMeasuring(ID) then
    begin
      StTime := GetTickCount;
      if CCD_StartMeasuring (ID) then
        repeat
{$IFDEF DATADWORD}
          Res := CCD_GetData(ID,Addr(pData[f*Blockdiv4]));
{$ENDIF}
{$IFDEF DATAWORD}
          Res := CCD_GetDataWord(ID,Addr(pwData[f*Blockdiv4]));
{$ENDIF}
{$IFDEF DATABYTE}
          Res := CCD_GetDataByte(ID,Addr(pbData[f*Blockdiv4]));
{$ENDIF}
          if Res then
          begin
             Inc(F);
             ProgressBar1.Position := F;
             Application.ProcessMessages;
          end;
        until (F>=NBlock );
      CurTime := GetTickCount;
      lbStreamRate.Caption := FormatFloat  ('0.###', N/((CurTime-StTime)/1000))+' frame/sec';
      Application.ProcessMessages;
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
    btnStreamScan1.Enabled := True;
  end;
end;

Var
   thReg0 : TRegThread;
   thReg1 : TRegThread;
   thReg2 : TRegThread;

procedure TForm1.btnStreamScanTh0Click(Sender: TObject);
// Камера переводится в режим DEVICEMODESTREAM.
// Камера работает непрерывно, пока не будет вызвана CCD_CameraReset.
// nNumReadOuts - размер двух внутренних, переменно работающих буферов (<=6).
// Регистрируется некоторое число кадров, от 10000 до 1000000.
// Выходные данные сохраняются в файл.
// Запусается отдельная нить.
// Работает с камерой с ID=0
Var Prms : TCCDUSBExtendParams;
begin
//
   if CCD_GetExtendParameters(0,Prms) then
   begin
      if (Prms.dwProperty and DP_STREAMSCAN) = DP_STREAMSCAN then
      begin

         if not CCD_SetParameter(0,PRM_DEVICEMODE, GetDEVICEMODESTREAM()) then Exit;

         btnStreamScanTh0.Enabled := False;
         lbStreamRate0.Caption := '';
         if thReg0 <> nil then
         begin
           thReg0.Terminate;
           thReg0.WaitFor;
           thReg0.Free;
         end;
         thReg0 := TRegThread.Create(true);
         thReg0.OnTerminate := FOnTerminateTh0;
         thReg0.ID := 0;
         thReg0.N := StrToInt(cbStreamScan.Items[cbStreamScan.ItemIndex]);
         thReg0.FreeOnTerminate := False;
         thReg0.Resume;
      end;
   end;
end;

procedure TForm1.FOnTerminateTh0(Sender: TObject);
begin
     btnStreamScanTh0.Enabled := True;
     lbStreamRate0.Caption := FormatFloat  ('0.###', thReg0.Rate )+' frame/sec';
end;

procedure TForm1.btnStreamScanTh1Click(Sender: TObject);
// Камера переводится в режим DEVICEMODESTREAM.
// Камера работает непрерывно, пока не будет вызвана CCD_CameraReset.
// nNumReadOuts - размер двух внутренних, переменно работающих буферов (<=6).
// Регистрируется некоторое число кадров, от 10000 до 1000000.
// Выходные данные сохраняются в файл.
// Запусается отдельная нить.
// Работает с камерой с ID=2
Var Prms : TCCDUSBExtendParams;
begin


   if CCD_GetExtendParameters(1,Prms) then
   begin
      if (Prms.dwProperty and DP_STREAMSCAN) = DP_STREAMSCAN then
      begin

         if not CCD_SetParameter(1,PRM_DEVICEMODE, GetDEVICEMODESTREAM()) then Exit;

         btnStreamScanTh1.Enabled := False;
         lbStreamRate1.Caption := '';
         if thReg1 <> nil then
         begin
           thReg1.Terminate;
           thReg1.WaitFor;
           thReg1.Free;
         end;
         thReg1 := TRegThread.Create(true);
         thReg1.OnTerminate := FOnTerminateTh1;
         thReg1.ID := 1;
         thReg1.N := StrToInt(cbStreamScan.Items[cbStreamScan.ItemIndex]);
         thReg1.FreeOnTerminate := False;
         thReg1.Resume;
      end;
   end;

//
 {  if CCD_GetExtendParameters(1,Prms) then
   begin
      if (Prms.dwProperty and DP_STREAMSCAN) = DP_STREAMSCAN then
      begin
         btnStreamScanTh1.Enabled := False;
         lbStreamRate1.Caption := '';
         if thReg1 <> nil then
           thReg1.Free;
         thReg1 := TRegThread.Create(true);
         thReg1.OnTerminate := FOnTerminateTh1;
         thReg1.ID := 1;
         thReg1.N := StrToInt(cbStreamScan.Items[cbStreamScan.ItemIndex]);
         thReg1.FreeOnTerminate := False;
         thReg1.Resume;
      end;
   end;          }
end;

procedure TForm1.FOnTerminateTh1(Sender: TObject);
begin
     btnStreamScanTh1.Enabled := True;
     lbStreamRate1.Caption := FormatFloat  ('0.###', thReg1.Rate )+' frame/sec';
end;

procedure TForm1.btnStreamScanTh2Click(Sender: TObject);
// Камера переводится в режим DEVICEMODESTREAM.
// Камера работает непрерывно, пока не будет вызвана CCD_CameraReset.
// nNumReadOuts - размер двух внутренних, переменно работающих буферов (<=6).
// Регистрируется некоторое число кадров, от 10000 до 1000000.
// Выходные данные сохраняются в файл.
// Запусается отдельная нить.
// Работает с камерой с ID=2
Var Prms : TCCDUSBExtendParams;
begin
   if CCD_GetExtendParameters(2,Prms) then
   begin
      if (Prms.dwProperty and DP_STREAMSCAN) = DP_STREAMSCAN then
      begin

         if not CCD_SetParameter(2,PRM_DEVICEMODE, GetDEVICEMODESTREAM()) then Exit;

         btnStreamScanTh2.Enabled := False;
         lbStreamRate2.Caption := '';
         if thReg2 <> nil then
         begin
           thReg2.Terminate;
           thReg2.WaitFor;
           thReg2.Free;
         end;
         thReg2 := TRegThread.Create(true);
         thReg2.OnTerminate := FOnTerminateTh2;
         thReg2.ID := 2;
         thReg2.N := StrToInt(cbStreamScan.Items[cbStreamScan.ItemIndex]);
         thReg2.FreeOnTerminate := False;
         thReg2.Resume;
      end;
   end;
end;

procedure TForm1.FOnTerminateTh2(Sender: TObject);
begin
     btnStreamScanTh2.Enabled := True;
     lbStreamRate2.Caption := FormatFloat  ('0.###', thReg2.Rate )+' frame/sec';
end;

Var
   FFileHandle : array [0..3] of THandle;
   FMapHandle  : array [0..3] of THandle;
   FFileSize : array [0..3] of Longword;
   FData  : array [0..3] of PBYTE;
   pData : array [0..3] of PDWORDArr;
   Np, Nrow, Ncol, Nf : array [0..3] of single;
   f, Block, Blockdiv4, N, NBlock : array [0..3] of Integer;
   StTime, CurTime : array [0..3] of Cardinal;
   Res : array [0..3] of boolean;

procedure DataRedy0; stdcall;
// Вызывается DLL, когда данные готовы их можно записывать
// Указатель передается в функции
// CCD_InitMeasuringCallBack(ID, Addr(DataRedy0))
// THREAD SAFE FUNCTION!!!!!!!!!!!!!!!!!!!!!!
Const ID = 0;
begin
//    Res[ID] := CCD_GetData(ID,Addr(pData[ID][f[ID]*Blockdiv4[ID]]));
    Res[ID] := CCD_GetDataByte(ID,Addr(PBYTEArr(pData[ID])[f[ID]*Blockdiv4[ID]]));
    if Res[ID] then
    begin
      Inc(F[ID]);
    end;
    if F[ID]<NBlock[ID] then
         Exit;
    CurTime[ID] := GetTickCount;
// :-)
    Form1.lbStreamRateCB0.Caption := FormatFloat  ('0.###', N[ID]/((CurTime[ID]-StTime[ID])/1000))+' frame/sec';
    CCD_CameraReset(ID);
    UnmapViewOfFile(FData[ID]);
    CloseHandle(FMapHandle[ID]);
    CloseHandle(FFileHandle[ID]);
// :-)
    Form1.btnStreamScanCallBack0.Enabled := True;
    Application.ProcessMessages;
end;

procedure DataRedy1; stdcall;
// Вызывается DLL, когда данные готовы их можно записывать
// Указатель передается в функции
// CCD_InitMeasuringCallBack(ID, Addr(DataRedy0))
// THREAD SAFE FUNCTION!!!!!!!!!!!!!!!!!!!!!!
Const ID = 1;
begin
//    Res[ID] := CCD_GetData(ID,Addr(pData[ID][f[ID]*Blockdiv4[ID]]));
    Res[ID] := CCD_GetDataByte(ID,Addr(PBYTEArr(pData[ID])[f[ID]*Blockdiv4[ID]]));
    if Res[ID] then
    begin
      Inc(F[ID]);
    end;
    if F[ID]<NBlock[ID] then
         Exit;
    CurTime[ID] := GetTickCount;
// :-)
    Form1.lbStreamRateCB1.Caption := FormatFloat  ('0.###', N[ID]/((CurTime[ID]-StTime[ID])/1000))+' frame/sec';
    CCD_CameraReset(ID);
    UnmapViewOfFile(FData[ID]);
    CloseHandle(FMapHandle[ID]);
    CloseHandle(FFileHandle[ID]);
// :-)
    Form1.btnStreamScanCallBack1.Enabled := True;
end;

procedure DataRedy2; stdcall;
// Вызывается DLL, когда данные готовы их можно записывать
// Указатель передается в функции
// CCD_InitMeasuringCallBack(ID, Addr(DataRedy0))
// THREAD SAFE FUNCTION!!!!!!!!!!!!!!!!!!!!!!
Const ID = 2;
begin
//    Res[ID] := CCD_GetData(ID,Addr(pData[ID][f[ID]*Blockdiv4[ID]]));
    Res[ID] := CCD_GetDataByte(ID,Addr(PBYTEArr(pData[ID])[f[ID]*Blockdiv4[ID]]));
    if Res[ID] then
    begin
      Inc(F[ID]);
    end;
    if F[ID]<NBlock[ID] then
         Exit;
    CurTime[ID] := GetTickCount;
// :-)
    Form1.lbStreamRateCB2.Caption := FormatFloat  ('0.###', N[ID]/((CurTime[ID]-StTime[ID])/1000))+' frame/sec';
    CCD_CameraReset(ID);
    UnmapViewOfFile(FData[ID]);
    CloseHandle(FMapHandle[ID]);
    CloseHandle(FFileHandle[ID]);
// :-)
    Form1.btnStreamScanCallBack2.Enabled := True;
end;

procedure TForm1.btnStreamScanCallBack0Click(Sender: TObject);
Const ID = 0;
// Камера переводится в режим DEVICEMODESTREAM.
// Камера работает непрерывно, пока не будет вызвана CCD_CameraReset.
// nNumReadOuts - размер двух внутренних, переменно работающих буферов (<=6).
// Регистрируется некоторое число кадров, от 10000 до 1000000.
// Выходные данные сохраняются в файл.
// Используется callback функция DataRedy0.
// Работает с камерой с ID=0
Var
    pDataByte : PBYTEArr;
begin
  btnStreamScanCallBack0.Enabled := False;

  if not CCD_SetParameter(ID,PRM_DEVICEMODE, GetDEVICEMODESTREAM) then Exit;

  if not CCD_GetParameter(ID,PRM_NUMPIXELSH, Ncol[ID]) then Exit;
  if not CCD_GetParameter(ID,PRM_NUMPIXELSV, Nrow[ID]) then Exit;
  if not CCD_GetParameter(ID,PRM_READOUTS, NF[ID]) then Exit;
  Np[ID] := Ncol[ID] * Nrow[ID];
  N[ID] := StrToInt(cbStreamScan.Items[cbStreamScan.ItemIndex]);
  N[ID] := Ceil(N[ID]/Round(Nf[ID]))*Round(Nf[ID]);

//  Block[ID] := Round(Np[ID]*Nf[ID])*SizeOf(DWORD);
//  Blockdiv4[ID] := Block[ID] shr 2;

  Block[ID] := Round(Np[ID]*Nf[ID])*SizeOf(BYTE);
  Blockdiv4[ID] := Block[ID];

  NBlock[ID] :=  Round (N[ID] / NF[ID]);

  lbStreamRateCB0.Caption := '';

  if CCD_HitTest(ID) then
  begin

    FFileHandle[ID] := FileCreate('Frames'+IntToStr(ID)+'.frm');
    if FFileHandle[ID] = INVALID_HANDLE_VALUE then
      raise Exception.Create('Failed to open or create file');

//    FFileSize[ID] := Round(Np[ID]*SizeOf(DWORD)*N[ID]);
    FFileSize[ID] := Round(Np[ID]*SizeOf(BYTE)*N[ID]);
    FMapHandle[ID] := CreateFileMapping(FFileHandle[ID], nil,
       PAGE_READWRITE, 0, FFileSize[ID], nil);

    if FMapHandle[ID] = 0 then
      raise Exception.Create('Failed to create file mapping');

    FData[ID] := MapViewOfFile(FMapHandle[ID], FILE_MAP_ALL_ACCESS, 0, 0, 0);
    if FData[ID] = Nil then
           raise Exception.Create('Failed to map view of file');
    pData[ID] := PDWORDArr(FData[ID]);

    F[ID] := 0;
//    if CCD_InitMeasuring(ID) then
    if CCD_InitMeasuringCallBack(ID, Addr(DataRedy0)) then
    begin
      StTime[ID] := GetTickCount;
      CCD_StartMeasuring (ID);
    end;
  end;
end;

procedure TForm1.btnStreamScanCallBack1Click(Sender: TObject);
// Камера переводится в режим DEVICEMODESTREAM.
// Камера работает непрерывно, пока не будет вызвана CCD_CameraReset.
// nNumReadOuts - размер двух внутренних, переменно работающих буферов (<=6).
// Регистрируется некоторое число кадров, от 10000 до 1000000.
// Выходные данные сохраняются в файл.
// Используется callback функция DataRedy1.
// Работает с камерой с ID=1
Const ID = 1;
begin
  btnStreamScanCallBack1.Enabled := False;

  if not CCD_SetParameter(ID,PRM_DEVICEMODE, GetDEVICEMODESTREAM) then Exit;

  if not CCD_GetParameter(ID,PRM_NUMPIXELSH, Ncol[ID]) then Exit;
  if not CCD_GetParameter(ID,PRM_NUMPIXELSV, Nrow[ID]) then Exit;
  if not CCD_GetParameter(ID,PRM_READOUTS, NF[ID]) then Exit;
  Np[ID] := Ncol[ID] * Nrow[ID];
//  N := 10000;//10000 frames;
  N[ID] := StrToInt(cbStreamScan.Items[cbStreamScan.ItemIndex]);
  N[ID] := Ceil(N[ID]/Round(Nf[ID]))*Round(Nf[ID]);

//  Block[ID] := Round(Np[ID]*Nf[ID])*SizeOf(DWORD);
//  Blockdiv4[ID] := Block[ID] shr 2;
  Block[ID] := Round(Np[ID]*Nf[ID])*SizeOf(BYTE);
  Blockdiv4[ID] := Block[ID];

  NBlock[ID] :=  Round (N[ID] / NF[ID]);

  lbStreamRateCB1.Caption := '';

  if CCD_HitTest(ID) then
  begin

    FFileHandle[ID] := FileCreate('Frames'+IntToStr(ID)+'.frm');
    if FFileHandle[ID] = INVALID_HANDLE_VALUE then
      raise Exception.Create('Failed to open or create file');

//    FFileSize[ID] := Round(Np[ID]*SizeOf(DWORD)*N[ID]);
    FFileSize[ID] := Round(Np[ID]*SizeOf(BYTE)*N[ID]);
    FMapHandle[ID] := CreateFileMapping(FFileHandle[ID], nil,
       PAGE_READWRITE, 0, FFileSize[ID], nil);

    if FMapHandle[ID] = 0 then
      raise Exception.Create('Failed to create file mapping');

    FData[ID] := MapViewOfFile(FMapHandle[ID], FILE_MAP_ALL_ACCESS, 0, 0, 0);
    if FData[ID] = Nil then
           raise Exception.Create('Failed to map view of file');
    pData[ID] := PDWORDArr(FData[ID]);

    F[ID] := 0;
//    if CCD_InitMeasuring(ID) then
    if CCD_InitMeasuringCallBack(ID, Addr(DataRedy1)) then
    begin
      StTime[ID] := GetTickCount;
      CCD_StartMeasuring (ID);
    end;
  end;
end;

procedure TForm1.btnStreamScanCallBack2Click(Sender: TObject);
// Камера переводится в режим DEVICEMODESTREAM.
// Камера работает непрерывно, пока не будет вызвана CCD_CameraReset.
// nNumReadOuts - размер двух внутренних, переменно работающих буферов (<=6).
// Регистрируется некоторое число кадров, от 10000 до 1000000.
// Выходные данные сохраняются в файл.
// Используется callback функция DataRedy2.
// Работает с камерой с ID=2
Const ID = 2;
begin
  btnStreamScanCallBack2.Enabled := False;

  if not CCD_SetParameter(ID,PRM_DEVICEMODE, GetDEVICEMODESTREAM) then Exit;

  if not CCD_GetParameter(ID,PRM_NUMPIXELSH, Ncol[ID]) then Exit;
  if not CCD_GetParameter(ID,PRM_NUMPIXELSV, Nrow[ID]) then Exit;
  if not CCD_GetParameter(ID,PRM_READOUTS, NF[ID]) then Exit;
  Np[ID] := Ncol[ID] * Nrow[ID];
//  N := 10000;//10000 frames;
  N[ID] := StrToInt(cbStreamScan.Items[cbStreamScan.ItemIndex]);
  N[ID] := Ceil(N[ID]/Round(Nf[ID]))*Round(Nf[ID]);

//  Block[ID] := Round(Np[ID]*Nf[ID])*SizeOf(DWORD);
//  Blockdiv4[ID] := Block[ID] shr 2;
  Block[ID] := Round(Np[ID]*Nf[ID])*SizeOf(BYTE);
  Blockdiv4[ID] := Block[ID];

  NBlock[ID] :=  Round (N[ID] / NF[ID]);

  lbStreamRateCB2.Caption := '';

  if CCD_HitTest(ID) then
  begin

    FFileHandle[ID] := FileCreate('Frames'+IntToStr(ID)+'.frm');
    if FFileHandle[ID] = INVALID_HANDLE_VALUE then
      raise Exception.Create('Failed to open or create file');

//    FFileSize[ID] := Round(Np[ID]*SizeOf(DWORD)*N[ID]);
    FFileSize[ID] := Round(Np[ID]*SizeOf(BYTE)*N[ID]);
    FMapHandle[ID] := CreateFileMapping(FFileHandle[ID], nil,
       PAGE_READWRITE, 0, FFileSize[ID], nil);

    if FMapHandle[ID] = 0 then
      raise Exception.Create('Failed to create file mapping');

    FData[ID] := MapViewOfFile(FMapHandle[ID], FILE_MAP_ALL_ACCESS, 0, 0, 0);
    if FData[ID] = Nil then
           raise Exception.Create('Failed to map view of file');
    pData[ID] := PDWORDArr(FData[ID]);

    F[ID] := 0;
//    if CCD_InitMeasuring(ID) then
    if CCD_InitMeasuringCallBack(ID, Addr(DataRedy2)) then
    begin
      StTime[ID] := GetTickCount;
      CCD_StartMeasuring (ID);
    end;
  end;
end;

function TForm1.GetDEVICEMODESTREAM: Integer;
begin
   Result := DEVICEMODESTREAM;
   case cbDeviceMode.ItemIndex of
     1: Result := DEVICEMODESTREAMBYTE OR DEVICEMODESTREAM;
     2: Result := DEVICEMODESTREAMBYTE1 OR DEVICEMODESTREAM;
   end;
end;

procedure TForm1.cbDeviceModeChange(Sender: TObject);
Var mode : boolean;
begin
    mode := cbDeviceMode.ItemIndex > 0;
    btnStreamScanTh0.Enabled := CCD_HitTest(0) and mode;
    btnStreamScanTh1.Enabled := CCD_HitTest(1) and mode;
    btnStreamScanTh2.Enabled := CCD_HitTest(2) and mode;
    btnStreamScanCallBack0.Enabled := CCD_HitTest(0) and mode;
    btnStreamScanCallBack1.Enabled := CCD_HitTest(1) and mode;
    btnStreamScanCallBack2.Enabled := CCD_HitTest(2) and mode;
end;


procedure TForm1.SpeedButton3Click(Sender: TObject);
begin
    CCDUSB_SetPIN0 ( ID, SpeedButton3.Down);
end;

initialization
begin
end;

finalization
begin
   if thReg0 <> nil then
   begin
      thReg0.Terminate;
      thReg0.Free;
   end;
   if thReg1 <> nil then
   begin
      thReg1.Terminate;
      thReg1.Free;
   end;
   if thReg2 <> nil then
   begin
      thReg2.Terminate;
      thReg2.Free;
   end;
end;

end.




