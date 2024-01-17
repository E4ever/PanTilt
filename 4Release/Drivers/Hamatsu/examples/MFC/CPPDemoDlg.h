// CPP DemoDlg.h : header file
//

#if !defined(AFX_CPPDEMODLG_H__8B31C5E3_F733_4740_98A0_3CBF05C30C53__INCLUDED_)
#define AFX_CPPDEMODLG_H__8B31C5E3_F733_4740_98A0_3CBF05C30C53__INCLUDED_

#include "UsbCDD.h"	// Added by ClassView
#if _MSC_VER >= 1000
#pragma once
#endif // _MSC_VER >= 1000

/////////////////////////////////////////////////////////////////////////////
// CCPPDemoDlg dialog

class CCPPDemoDlg : public CDialog
{
// Construction
public:
	CUsbCDD m_usbCCD;
	CCPPDemoDlg(CWnd* pParent = NULL);	// standard constructor

// Dialog Data
	//{{AFX_DATA(CCPPDemoDlg)
	enum { IDD = IDD_CPPDEMO_DIALOG };
		// NOTE: the ClassWizard will add data members here
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CCPPDemoDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
	HICON m_hIcon;

	// Generated message map functions
	//{{AFX_MSG(CCPPDemoDlg)
	virtual BOOL OnInitDialog();
	afx_msg void OnSysCommand(UINT nID, LPARAM lParam);
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	afx_msg void OnStartWaitMeasureBUTTON();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
public:
	afx_msg void OnBnClickedCameraresetbutton();
	afx_msg void OnBnClickedGetserialnumberbutton();
	CString m_strSN;
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Developer Studio will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_CPPDEMODLG_H__8B31C5E3_F733_4740_98A0_3CBF05C30C53__INCLUDED_)
