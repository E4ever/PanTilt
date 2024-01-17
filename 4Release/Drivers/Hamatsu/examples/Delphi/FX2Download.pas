unit FX2Download;

interface
Uses
 Windows, USB100, ezusbsys, classes, sysutils, Dialogs, Forms, Math;

Const
 TGT_IMG_SIZE = $10000;        // 64KB (65,536 Byte) target image
 TGT_SEG_SIZE = 16;            // 16 byte segments
 MAX_EP0_XFER_SIZE = (1024*4); // 4K Control EP0 transfer limit imposed by OS
 MAX_INTEL_HEX_RECORD_LENGTH = 4096;
 MAX_FILE_SIZE = (1024*64);
// MAX_INTEL_HEX_RECORD_LENGTH = 16;

Type

// PCAH = ^TDWORDArr;
// TDWORDArr = array[0..0] of DWORD;

  MemSeg =
  record
     TAddr : DWORD; //Target Address
     HAddr : DWORD; //Host Address
     Size  : DWORD;  //block size
     Stat  : DWORD;  //status
     pData : PCHAR; //data bytes
  end;

  TMemImg =
  record
     data : array [0..TGT_IMG_SIZE-1] of CHAR;
  end;//target image store

  TMemCache =
  record
     pImg : ^TMemImg;	//pointer to image
     nSeg : Integer;		//segment count
     pSeg : array [0..(TGT_IMG_SIZE div TGT_SEG_SIZE)-1] of MemSeg; //info about segments
  end;

  PTEXTFILE = ^TEXTFILE;
  PTMemCache = ^TMemCache;

 TANCHOR_DOWNLOAD_CONTROL =
 record
   Offset : WORD;
 end;
 PANCHOR_DOWNLOAD_CONTROL = ^TANCHOR_DOWNLOAD_CONTROL;

 INTEL_HEX_RECORD =
 record
   //BYTE  Length;
   Length  : WORD;
   Address : WORD;
   iType   : BYTE;
//   BYTE  Data[MAX_INTEL_HEX_RECORD_LENGTH];
   Data    : array [0..(MAX_INTEL_HEX_RECORD_LENGTH-1)] of BYTE;
 end;
PINTEL_HEX_RECORD = ^INTEL_HEX_RECORD;


function StrHexToInt(str, frmt : PCHAR; res : PInteger) : integer; cdecl ; external 'StrHexToInt.dll';

function intel_in ( fpIn : PTEXTFILE; pMemCache : PTMemCache; Var ioOffset : DWORD;
		    endianFlags : CHAR; spaces : boolean) : Integer;
procedure On_8051_HOLD (ID : Integer; bFX2 : boolean);
procedure On_8051_RUN  (ID : Integer; bFX2 : boolean);
procedure DownloadFirmwire (ID : Integer);
//procedure Ezusb_DownloadIntelHex ( ID : Integer; pHexRecord : PINTEL_HEX_RECORD);
procedure LoadHEXFile(ID : Integer; strDldFile : string);
function IDC_ANCHOR_DOWNLOAD (ID : Integer) : Boolean;

Var
  m_MemCache  : TMemCache;	//target mem cache info
  m_MemImg    : TMemImg;		//target memory image
  BlkBuf      : array [0..MAX_FILE_SIZE-1] of byte;
  m_dldOffset : DWORD;
  m_DldLen    : Integer;

implementation

uses CCDUSB021_u;

//		case IDC_ANCHOR_DOWNLOAD:
function IDC_ANCHOR_DOWNLOAD (ID : Integer) : Boolean;
Var
   numread : Integer;
   downloadControl : TANCHOR_DOWNLOAD_CONTROL;
   USBDeviceHandle  : THANDLE;
   Size : DWORD;
begin
//			{
//				int numread = 0;
   numread := 0;
//				char                   temp[64]  = "";
//				ANCHOR_DOWNLOAD_CONTROL downloadControl;
//				MAINTAIN_OUTPUT_BOX (hOutputBox, nItems);
//				unsigned char* buffer;
//				downloadControl.Offset = (USHORT) pTh->dldOffset;
   downloadControl.Offset := m_dldOffset;
// BlkBuf			buffer = (unsigned char*)(pTh->pBuf);
//				numread = pTh->length;
   numread := m_DldLen;
//				wsprintf (temp, "Anchor Download %d bytes: addr=%x",numread, downloadControl.Offset);
//				EzSendMessage (hOutputBox, LB_ADDSTRING, 0, (LPARAM)temp);
//				if(theApp.m_nVerbose)
//					DumpBuffer(buffer,numread,hOutputBox);
   Result := false;

 USBDeviceHandle := CreateFile (PChar('\\.\ezusb-'+IntTostr(DriverIndex[ID])),
                 GENERIC_WRITE,
                 FILE_SHARE_WRITE,
                 nil,
                 OPEN_EXISTING,
                 0,
                 0 );
try
				// Open the driver
//				if (bOpenDriver (&hDevice, pcDriverName) != TRUE)
//				{
//					EzSendMessage (hOutputBox, LB_ADDSTRING, 0, (LPARAM)"Failed to Open Driver");
//					hDevice = NULL;
//				}

//				if (hDevice != NULL)
//				{
   if USBDeviceHandle <> INVALID_HANDLE_VALUE then
   begin
//					if(pTh->dldOffset < 0x2000)
//					{
//    Result := DeviceIoControl (hDevice,
//							IOCTL_EZUSB_ANCHOR_DOWNLOAD,
//							&downloadControl,
//							sizeof(TANCHOR_DOWNLOAD_CONTROL),
//							buffer,
//							numread,
//							(unsigned long *)&nBytes,
//							NULL);
//						if(!bResult)
//							ShowSystemError(hOutputBox);
            Result:= DeviceIoControl ( USBDeviceHandle,
                        IOCTL_EZUSB_ANCHOR_DOWNLOAD,
                        @downloadControl,
                        sizeof(TANCHOR_DOWNLOAD_CONTROL),
                        Addr(BlkBuf),
                        numread,
                        Cardinal(Size),
                        nil);

//					}
//					else
//					{
//						VENDOR_OR_CLASS_REQUEST_CONTROL	myRequest;
//						myRequest.request = (BYTE) 0xA3;
//						myRequest.value = (WORD) pTh->dldOffset;
//						myRequest.index = (WORD) 0x00;
//						myRequest.direction = 0;
//						myRequest.requestType = 2;
//						myRequest.recepient = 0;

//						bResult = DeviceIoControl (hDevice,
//							IOCTL_EZUSB_VENDOR_OR_CLASS_REQUEST,
//							&myRequest,
//							sizeof(VENDOR_OR_CLASS_REQUEST_CONTROL),
//							pTh->pBuf,
//							pTh->length,
//							(unsigned long *)&nBytes,
//							NULL);

//						if (bResult==TRUE)
//						{
//							if(theApp.m_nVerbose)
//								DumpBuffer(buffer,nBytes,hOutputBox);
//						}
//						else
//						{
//							EzSendMessage (hOutputBox, LB_ADDSTRING, 0, (LPARAM)"Vendor Request failed");
//							ShowSystemError(hOutputBox);
//						}
//					}
//				}/* if valid driver handle */
   end;
finally
    CloseHandle (USBDeviceHandle);
end;
//				CloseHandle (hDevice); // Close the handle
end;
//			}
//			break;

procedure LoadHEXFile(ID : Integer; strDldFile : string);
//	unsigned char* pbuf = (unsigned char *)((CEzMrFrame*)GetParentFrame())->BlkBuf;
//	unsigned char* pVenbuf = (unsigned char *)((CEzMrFrame*)GetParentFrame())->VenBuf;
//	strDldFile.MakeLower(); // case insensitive compare
Var
  strSaveReq    : string;
  strSaveValue  : string;
  strSaveLength : string;
  nSaveDir : Integer;
//	CFileStatus status;
  fp            : TEXTFILE;
  endianConversion : Char;    // Mask for endian conversion
  offset : DWORD;             // Offset -- set to -1 to get offset from srec or hex file
  res : DWORD;
  i,k,j : Integer;
begin

//	if(strDldFile.Find(".hex") != -1) //intel hex format
//	{

   AssignFile(fp, strDldFile);
try
   Reset(fp);
//		FILE *fp = fopen(strDldFile, "rb");
//		if(fp)
//		{
//		  char endianConversion = 0;    // Mask for endian conversion
//		  DWORD offset = 0;         		// Offset -- set to -1 to get offset from srec or hex file
  endianConversion := CHAR(0);    // Mask for endian conversion
  offset := 0;         		// Offset -- set to -1 to get offset from srec or hex file

//		  ((CEzMrFrame*)GetParentFrame())->m_EBoxReq.GetWindowText(strSaveReq);
//		  ((CEzMrFrame*)GetParentFrame())->m_EBoxVal.GetWindowText(strSaveValue);
//		  ((CEzMrFrame*)GetParentFrame())->m_EBoxLen.GetWindowText(strSaveLength);
//		  nSaveDir = ((CEzMrFrame*)GetParentFrame())->m_CBoxVenDir.GetCurSel();
//   theApp.m_MemCache.pImg = &theApp.m_MemImg;
   m_MemCache.pImg := Addr(m_MemImg);
//   res := intel_in(fp, &theApp.m_MemCache, offset, endianConversion, FALSE);
   res := intel_in( Addr(fp), Addr(m_MemCache), offset, endianConversion, FALSE);
//          fclose(fp);
finally
  CloseFile(fp);
end;
//  for k := 0 to (m_MemCache.nSeg-1) do
//  begin
//		  for(int k=0; k<theApp.m_MemCache.nSeg; k++)
//		  { //check for high mem first; load loader first if necessary
//    if m_MemCache.pSeg[k].TAddr >= $2000 then
//			if(theApp.m_MemCache.pSeg[k].TAddr >= 0x2000)
//			{
//    begin
//        Ezusb_DownloadIntelHex(Vend_Ax_Fx2);
//				if((!theApp.m_nUseUserDefinedLoader) && (!theApp.m_nUseNoLoader))
//				{
//				  if(theApp.m_nTarg)
//				  { // if Fx2
//					TRACE("loading Fx2 loader\n");
//					Ezusb_DownloadIntelHex(Vend_Ax_Fx2);
//					break;
//				  }
//				  else
//				  { // if Ezusb
//					TRACE("loading Ezusb loader\n");
//					Ezusb_DownloadIntelHex(Vend_Ax);
//					break;
//				  }
//				}
//    end;
//			}
//		  }
//  end;
//  for i:=0 to (m_MemCache.nSeg-1) do
//  begin //load all high mem first
//		  for(int i=0; i<theApp.m_MemCache.nSeg; i++)
//		  { //load all high mem first
//			if(theApp.m_MemCache.pSeg[i].TAddr >= 0x2000)
//    if m_MemCache.pSeg[i].TAddr >= $2000 then
//    begin
//			{
//				char text[80];
//				memcpy(pVenbuf, theApp.m_MemCache.pSeg[i].pData, theApp.m_MemCache.pSeg[i].Size);
//				((CEzMrFrame*)GetParentFrame())->m_EBoxReq.SetWindowText("0xA3");
///				sprintf(text, "0x%x", theApp.m_MemCache.pSeg[i].TAddr);
//				((CEzMrFrame*)GetParentFrame())->m_EBoxVal.SetWindowText(text);
//				sprintf(text, "%d", theApp.m_MemCache.pSeg[i].Size);
//				((CEzMrFrame*)GetParentFrame())->m_EBoxLen.SetWindowText(text);
//				((CEzMrFrame*)GetParentFrame())->m_CBoxVenDir.SetCurSel(1); //Set Dir Out
//
//				SendOp(OP_VEND_REQST);
//			}
//			if( ( ((CEzMrFrame*)GetParentFrame())->m_nOpsPending ) >= theApp.m_nMaxOpsPending)
//				break;
//    end;
//		  }
//  end;
//		  if(theApp.m_nAutoHoldRun)
//			On_8051_HOLD();
   On_8051_HOLD (ID, true);

   for j:=0 to (m_MemCache.nSeg-1) do
   begin
//		  for(int j=0; j<theApp.m_MemCache.nSeg; j++)
//		  { //load all low mem last
//			if(theApp.m_MemCache.pSeg[j].TAddr < 0x2000)
//			{
     CopyMemory ( Addr(BlkBuf), m_MemCache.pSeg[j].pData, m_MemCache.pSeg[j].Size );
//				memcpy(pbuf, theApp.m_MemCache.pSeg[j].pData, theApp.m_MemCache.pSeg[j].Size);
     m_DldLen := m_MemCache.pSeg[j].Size;
//				m_DldLen = theApp.m_MemCache.pSeg[j].Size;
     m_dldOffset := m_MemCache.pSeg[j].TAddr;
//				m_dldOffset = theApp.m_MemCache.pSeg[j].TAddr;
     IDC_ANCHOR_DOWNLOAD (ID);
//				SendOp(OP_ANCHOR_DLD);
//			}
//			if( ( ((CEzMrFrame*)GetParentFrame())->m_nOpsPending ) >= theApp.m_nMaxOpsPending)
//				break;
//		  }
    end;
//		  if(theApp.m_nAutoHoldRun)
//		    On_8051_RUN();
   On_8051_RUN (ID, true);

//		  ((CEzMrFrame*)GetParentFrame())->m_EBoxReq.SetWindowText(strSaveReq);
//		  ((CEzMrFrame*)GetParentFrame())->m_EBoxVal.SetWindowText(strSaveValue);
//		  ((CEzMrFrame*)GetParentFrame())->m_EBoxLen.SetWindowText(strSaveLength);
//		  ((CEzMrFrame*)GetParentFrame())->m_CBoxVenDir.SetCurSel(nSaveDir);
//		}
//		else
//		{
//          theApp.report_error("Error opening Input file.\n");
//		}
//	}
end;

procedure DownloadFirmwire (ID : Integer);
begin
  LoadHEXFile(ID, 'FX2_to_extsyncFIFO.hex');
end;
(*
procedure Ezusb_DownloadIntelHex ( ID : Integer; pHexRecord : PINTEL_HEX_RECORD);
Var
  ptr  : PINTEL_HEX_RECORD;
  pbuf :
	unsigned char* ptmp = NULL;
begin
//   PINTEL_HEX_RECORD ptr = pHexRecord;
        ptr := pHexRecord;
//	unsigned char* ptmp = NULL;

	ptr = pHexRecord;
	On_8051_HOLD();

	while (ptr->Type == 0)
	{ //load low mem
		if((ptmp != NULL) &&
			(m_dldOffset+m_DldLen == ptr->Address) &&
			((m_DldLen+ptr->Length) <= MAX_EP0_XFER_SIZE) )
		{ // continue a segment
			memcpy(ptmp, ptr->Data, ptr->Length);
			m_DldLen += ptr->Length;
			ptmp += ptr->Length;
		}
		else
		{ // start a new segment
			if(ptmp != NULL)
			{ // send prev segment first
				SendOp(OP_ANCHOR_DLD);
				break;
			}
			ptmp = pbuf;
			memcpy(ptmp, ptr->Data, ptr->Length);
			m_DldLen = ptr->Length;
			m_dldOffset = ptr->Address;
			ptmp += ptr->Length;
		}
        ptr++;
	}
	if(ptmp != NULL)
	{ // send final segment
		SendOp(OP_ANCHOR_DLD);
	}

	On_8051_RUN();
end;

*)
procedure On_8051_RUN (ID : Integer; bFX2 : boolean);
Var
    USBDeviceHandle  : THANDLE;
    myRequest : TVENDOR_REQUEST_IN;
    Size : DWORD;
//    AA: DEV_BROADCAST_DEVICEINTERFACE;
begin
//				VENDOR_REQUEST_IN	myRequest;
//				MAINTAIN_OUTPUT_BOX (hOutputBox, nItems);
//				EzSendMessage (hOutputBox, LB_ADDSTRING, 0, (LPARAM)"Toggle 8051 Reset");

// Open the driver
//  if (bOpenDriver (&hDevice, pcDriverName) != TRUE)
//  {
//   EzSendMessage (hOutputBox, LB_ADDSTRING, 0, (LPARAM)"Failed to Open Driver");
//   hDevice = NULL;
//  }

 USBDeviceHandle := CreateFile (PChar('\\.\ezusb-'+IntTostr(DriverIndex[ID])),
                 GENERIC_WRITE,
                 FILE_SHARE_WRITE,
                 nil,
                 OPEN_EXISTING,
                 0,
                 0 );
try

				myRequest.bRequest := $A0;
				if bFX2 then
				  myRequest.wValue := $E600 // using CPUCS.0 in FX2
				else
				  myRequest.wValue := $7F92;
				myRequest.wIndex := $00;
				myRequest.wLength := $01;
//				myRequest.bData = (LOWORD(wParam) == IDC_RESET_HLD) ? 1 : 0;
				myRequest.bData := 0;
				myRequest.direction := $00;

//				if hDevice != NULL)
//				{// Perform the Get-Descriptor IOCTL
                                if USBDeviceHandle <> INVALID_HANDLE_VALUE then
                                begin
                                   DeviceIoControl (USBDeviceHandle,
                                                    IOCTL_Ezusb_VENDOR_REQUEST,
                                                    @myRequest,
                                                    sizeof(TVENDOR_REQUEST_IN),
                                                    nil,
                                                    0,
                                                    Cardinal(Size),
                                                    nil);
//				   bResult :=   DeviceIoControl (hDevice,
//						IOCTL_Ezusb_VENDOR_REQUEST,
//						&myRequest,
//						sizeof(VENDOR_REQUEST_IN),
//						NULL,
//						0,
//						(unsigned long *)&nBytes,
//						NULL);
                                end;
//				}/* if valid driver handle */

				// Close the handle
//				CloseHandle (hDevice);
//			}
finally
    CloseHandle (USBDeviceHandle);
end;
end;

procedure On_8051_HOLD (ID : Integer; bFX2 : boolean);
Var
    USBDeviceHandle  : THANDLE;
    myRequest : TVENDOR_REQUEST_IN;
    Size : DWORD;
begin
//				VENDOR_REQUEST_IN	myRequest;
//				MAINTAIN_OUTPUT_BOX (hOutputBox, nItems);
//				EzSendMessage (hOutputBox, LB_ADDSTRING, 0, (LPARAM)"Toggle 8051 Reset");

// Open the driver
//  if (bOpenDriver (&hDevice, pcDriverName) != TRUE)
//  {
//   EzSendMessage (hOutputBox, LB_ADDSTRING, 0, (LPARAM)"Failed to Open Driver");
//   hDevice = NULL;
//  }
 USBDeviceHandle := CreateFile (PChar('\\.\ezusb-'+IntTostr(DriverIndex[ID])),
                 GENERIC_WRITE,
                 FILE_SHARE_WRITE,
                 nil,
                 OPEN_EXISTING,
                 0,
                 0 );
try

				myRequest.bRequest := $A0;
				if bFX2 then
				  myRequest.wValue := $E600 // using CPUCS.0 in FX2
				else
				  myRequest.wValue := $7F92;
				myRequest.wIndex := $00;
				myRequest.wLength := $01;
//				myRequest.bData = (LOWORD(wParam) == IDC_RESET_HLD) ? 1 : 0;
				myRequest.bData := 1;
				myRequest.direction := $00;

//				if hDevice != NULL)
//				{// Perform the Get-Descriptor IOCTL
                                if USBDeviceHandle <> INVALID_HANDLE_VALUE then
                                begin
                                            DeviceIoControl (USBDeviceHandle,
                                                             IOCTL_Ezusb_VENDOR_REQUEST,
                                                             @myRequest,
                                                             sizeof(TVENDOR_REQUEST_IN),
                                                             nil,
                                                             0,
                                                             Cardinal(Size),
                                                             nil);
//				   bResult :=   DeviceIoControl (hDevice,
//						IOCTL_Ezusb_VENDOR_REQUEST,
//						&myRequest,
//						sizeof(VENDOR_REQUEST_IN),
//						NULL,
//						0,
//						(unsigned long *)&nBytes,
//						NULL);
                                end;
//				}/* if valid driver handle */

				// Close the handle
//				CloseHandle (hDevice);
//			}
finally
    CloseHandle (USBDeviceHandle);
end;
end;


function intel_in ( fpIn : PTEXTFILE; pMemCache : PTMemCache; Var ioOffset : DWORD;
		     endianFlags : CHAR; spaces : boolean) : Integer;
//int CEzMrView::intel_in(FILE *fpIn, TMemCache* pMemCache, DWORD &ioOffset,
//						char endianFlags, BOOLEAN spaces)
Var
   i         : Integer;
//   str       : array [0..MAXSTR-1] of CHAR;
   str, str1 : string;
   iByte     : Byte;
   curSeg    : Integer;			// current seg record
   recType   : Integer;
   addr      : WORD;
   cnt       : Integer;
   totalRead : WORD;
   CNTFIELD, ADDRFIELD, RECFIELD, DATAFIELD : Integer;
   ptr       : PCHAR;

begin
	// offsets of fields within record -- may change later due to "spaces" setting
	CNTFIELD    := 1 + 1;
	ADDRFIELD   := 3 + 1;
	RECFIELD    := 7 + 1;
	DATAFIELD   := 9 + 1;
        curSeg      := 0;			// current seg record
	totalRead   := 0;

	if fpIn = nil then
        begin
	  Result := 0;
          Exit;
        end;

	addr := 0;

	pMemCache^.nSeg := 0;

        while not Eof(fpIn^) do
        begin
          ReadLn( fpIn^, str);
//	while(fgets(str,MAXSTR,fpIn))
//	{
	  if str[1] <> ':' then
          begin
	    Result := -1;
            Exit;
          end;
		{get the record type }
	  if spaces or (str[2] = ' ') then
	  begin
	    CNTFIELD  := 1 + 1;
	    ADDRFIELD := 3 + 2;
	    RECFIELD  := 7 + 3;
	    DATAFIELD := 9 + 4;
	  end;

//		sscanf(str+RECFIELD,"%2x",&recType);
          StrHexToInt ( PCHAR(Copy (str, RECFIELD, 2)), '%2x', @recType);
//		PCHAR ptr = (PCHAR)pMemCache->pImg;
          ptr := PCHAR(pMemCache^.pImg);
          case recType of
//		switch(recType)
            2: begin
//                  curSeg := StrToInt (Copy (str, DATAFIELD, 4));
                    StrHexToInt ( PCHAR(Copy (str, DATAFIELD, 4)), '%4x', @curSeg);
               end;
{		case 2: /*seg record*/
			sscanf(str+DATAFIELD,"%4x",&curSeg);
			curSeg *= 0x10;
			break;         }
            0: begin
//                  cnt  := StrToInt (Copy (str, CNTFIELD, 2));
//                  addr := StrToInt (Copy (str, ADDRFIELD, 4));
                  StrHexToInt ( PCHAR(Copy (str, CNTFIELD, 2)), '%2x', @cnt);
                  StrHexToInt ( PCHAR(Copy (str, ADDRFIELD, 4)), '%4x', @addr);
                  if addr >= TGT_IMG_SIZE then
                  begin
		    Result := totalRead;
                    Exit;
                  end;
                  ptr := ptr + addr;

		  if (pMemCache^.nSeg <> 0) and
		     (pMemCache^.pSeg[pMemCache^.nSeg-1].TAddr =
			  (addr - pMemCache^.pSeg[pMemCache^.nSeg-1].Size) ) and
		     ( (pMemCache^.pSeg[pMemCache^.nSeg-1].Size + cnt) <= MAX_EP0_XFER_SIZE ) then
                  begin
		     // if the segment is contiguous to the last segment, and it's not too big yet
		     pMemCache^.pSeg[pMemCache^.nSeg-1].Size := pMemCache^.pSeg[pMemCache^.nSeg-1].Size + cnt; // append to previous segment
                  end else
                      begin
			 // start a new segment
			pMemCache^.pSeg[pMemCache^.nSeg].TAddr := addr;
			pMemCache^.pSeg[pMemCache^.nSeg].Size := cnt;
			pMemCache^.pSeg[pMemCache^.nSeg].pData := ptr;
			Inc(pMemCache^.nSeg);
                      end;
		  for i:=0 to (cnt-1) do
	          begin
//                   iByte := StrToInt (Copy (str, DATAFIELD+i*2, 2));
                   SetLength ( str1, Length(str));
                   StrCopy (PChar (str1), PCHAR(str));
                   StrHexToInt ( PCHAR (Copy (str1, DATAFIELD+i*2, 2)), '%2x', @iByte);
                   ptr[i] := CHAR(iByte);
                   Inc(totalRead);
//				sscanf(str+DATAFIELD+i*2,"%2x",&byte);
//				*(ptr + i) = byte;
//				totalRead++;
		  end;
               end;
//		case 0:
//			sscanf(str+CNTFIELD,"%2x",&cnt);
//			sscanf(str+ADDRFIELD,"%4x",&addr);
//			if(addr >= TGT_IMG_SIZE)
//			//{
//				theApp.report_error("Error loading file: address out of range\n");
//				return(totalRead);
//			}
//			ptr += addr; // get pointer to location in image
//			if(pMemCache->nSeg &&
//				(pMemCache->pSeg[pMemCache->nSeg-1].TAddr ==
//				addr - pMemCache->pSeg[pMemCache->nSeg-1].Size) &&
//				(pMemCache->pSeg[pMemCache->nSeg-1].Size + cnt <= MAX_EP0_XFER_SIZE) )
//			{ // if the segment is contiguous to the last segment, and it's not too big yet
//				pMemCache->pSeg[pMemCache->nSeg-1].Size += cnt; // append to previous segment
//			}
//			else
//			{ // start a new segment
//				pMemCache->pSeg[pMemCache->nSeg].TAddr = addr;
//				pMemCache->pSeg[pMemCache->nSeg].Size = cnt;
//				pMemCache->pSeg[pMemCache->nSeg].pData = ptr;
//				pMemCache->nSeg++;
//			}
//			for(i=0; i<cnt; i++)
//			{
//				sscanf(str+DATAFIELD+i*2,"%2x",&byte);
//				*(ptr + i) = byte;
//				totalRead++;
//			}
//			break;
                1 : begin
	               Result := totalRead;
                       Exit;
                    end;
//		case 1: /*end record*/
//			return(totalRead);
//			break;
//		default:
//			break;
//		}
          end;  // case
        end;
//	return(-1);		// missing end record
	Result := -1;
end;

end.
