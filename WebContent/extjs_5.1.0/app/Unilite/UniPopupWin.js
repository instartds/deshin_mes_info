//@charset UTF-8
/**
 * @class Unilite
 * Popup 접근을 쉽게 하기 위한 함수 모음.
 */
Ext.apply(Unilite,{
	/**
	 * ## popup 필드 설정 생성 함수. 
	 * 
	 * Grid 용 : {@link Unilite.com.form.popup.UniPopupColumn}.
	 * Form용 :  {@link Unilite.com.form.popup.UniPopupField}.
	 * 
	 * @param {} sPopItem
	 * 'CUST' :	거래처
	 * 'CUST_G' : 거래처 그리드용
	 * 
	 * @param {} config
	 * @return {PopupConfig}
	 */
	popup: function(sPopItem, config ) {
		var rv={} ;

		if (sPopItem == 'CUST' ) { 		// 거래처 
			rv = {
				xtype:'uniPopupField', // 일반 Form용 
				fieldLabel : '거래처',
			    valueFieldName:'CUSTOM_CODE',
			    textFieldName:'CUSTOM_NAME',
			    DBvalueFieldName: 'CUSTOM_CODE',
			    DBtextFieldName: 'CUSTOM_NAME',
			    api: 'popupService.custPopup',
			    app: 'Unilite.app.popup.CustPopup',
			    //popupPage: '/com/popup/CustPopup.do',
			    pageTitle: '거래처정보'
			};
		} else if (sPopItem == 'CUST_G' ) {    // 거래처 그리드용
			rv = {
				xtype:'uniPopupColumn',		// Grid용 
			    textFieldName:'CUSTOM_NAME',
			    DBtextFieldName: 'CUSTOM_NAME',
			    api: 'popupService.custPopup',
			    app: 'Unilite.app.popup.CustPopup',
			    //popupPage: '/com/popup/CustPopup.do',
			    pageTitle: '거래처정보'
			};
		} else if (sPopItem == 'AGENT_CUST' ) { 		// 거래처 
			rv = {
				xtype:'uniPopupField', // 일반 Form용 
				fieldLabel : '거래처',
			    valueFieldName:'CUSTOM_CODE',
			    textFieldName:'CUSTOM_NAME',
			    DBvalueFieldName: 'CUSTOM_CODE',
			    DBtextFieldName: 'CUSTOM_NAME',
			    api: 'popupService.agentCustPopup',
                app: 'Unilite.app.popup.AgentCustPopup',
                //popupPage: '/com/popup/AgentCustPopup.do',
			    popupWidth: 800,
			    pageTitle: '거래처정보'
			};
		} else if (sPopItem == 'AGENT_CUST_G' ) {    // 거래처 그리드용
			rv = {
				xtype:'uniPopupColumn',		// Grid용 
			    textFieldName:'CUSTOM_NAME',
			    DBtextFieldName: 'CUSTOM_NAME',
			    api: 'popupService.agentCustPopup',
			    app: 'Unilite.app.popup.AgentCustPopup',
			    //popupPage: '/com/popup/AgentCustPopup.do',
			    popupWidth:800,
			    pageTitle: '거래처정보'
			};
		}else if (sPopItem == 'CUSTOMER' ) { 	// 고객정보 ( CLIENT_ID, CLIENT_NAME)
		
			rv = {
				xtype:'uniPopupField',
				fieldLabel : '고객',
			    valueFieldName:'CLIENT_ID',
			    textFieldName:'CLIENT_NAME',
			    DBvalueFieldName: 'CLIENT_ID',
			    DBtextFieldName: 'CLIENT_NAME',
			    api: 'cmPopupService.clientPopup',
			    app: 'Unilite.app.popup.ClientPopup',			    
			    //popupPage: '/crm/ClientPopup.do',
			    pageTitle: '고객 정보'
			};
		} else if (sPopItem == 'CUSTOMER_G' ) {  // 고객 그리드용
		
			rv = {
				xtype:'uniPopupColumn',
			    textFieldName:'CLIENT_NAME',
			    DBtextFieldName: 'CLIENT_NAME',
			    api: 'cmPopupService.clientPopup',
			    app: 'Unilite.app.popup.ClientPopup',
			    //popupPage: '/crm/ClientPopup.do',
			    pageTitle: '고객 정보'
			};
		} else if (sPopItem == 'CLIENT_PROJECT' ) {	// 고객정보 ( CUSTOMER_ID, CUSTOMER_NAME)	
			rv = {
				xtype:'uniPopupField',
				fieldLabel : '영업기회',
			    valueFieldName:'PROJECT_NO',
			    textFieldName:'PROJECT_NAME',
			    DBvalueFieldName: 'PROJECT_NO',
			    DBtextFieldName: 'PROJECT_NAME',
			    api: 'cmPopupService.clientProjectList',
			    app: 'Unilite.app.popup.cmClientProjectPopup',
			   // popupPage: '/crm/cmClientProjectPopup.do',
			    popupWidth:800,
			    pageTitle: '고객 정보'
			};
		} else if (sPopItem == 'CLIENT_PROJECT2' ) {	// 고객정보 ( CUSTOMER_ID, CUSTOMER_NAME)
			
			rv = {
				xtype:'uniPopupField',
				fieldLabel : '영업기회',
			    textFieldName:'CLIENT_NM', 
			    valueFieldName : 'CLIENT',
			    DBtextFieldName:'CLIENT_NAME', 
			    DBvalueFieldName : 'CLIENT_ID',
			    app: 'Unilite.app.popup.cmClientProjectPopup',
			    //popupPage: '/crm/cmClientProjectPopup.do',
			    popupWidth:800,
			    pageTitle: '고객 정보'
			};
		} else if (sPopItem == 'CLIENT_PROJECT_G' ) {	// 고객 그리드용
	 
			rv = {
				xtype:'uniPopupColumn',
			    textFieldName:'PROJECT_NAME',
			    DBtextFieldName: 'PROJECT_NAME',
			    api: 'cmPopupService.clientProjectList',
			   app: 'Unilite.app.popup.cmClientProjectPopup',
			   // popupPage: '/crm/cmClientProjectPopup.do',
			    popupWidth:800,
			    pageTitle: '고객 정보'
			};
		} else if (sPopItem == 'BANK' ) {
			rv = {
				xtype:'uniPopupField',
				fieldLabel : '금융기관',
			    valueFieldName:'BANK_CODE',
			    textFieldName:'BANK_NAME',
			    DBvalueFieldName: 'BANK_CODE',
			    DBtextFieldName: 'BANK_NAME',
			    api: 'popupService.bankPopup',
			    app: 'Unilite.app.popup.BankPopup',
			    //popupPage: '/com/popup/BankPopup.do',
			    popupWidth:300,
			    popupHeight:300,
			    pageTitle: '은행'
			};
		} else if (sPopItem == 'BANK_G' ) {
			rv = {
				xtype:'uniPopupColumn',
			    textFieldName:'BANK_NAME',
			    DBtextFieldName: 'BANK_NAME',
			    api: 'popupService.bankPopup',
			    app: 'Unilite.app.popup.BankPopup',
			    //popupPage: '/com/popup/BankPopup.do',
			    popupWidth:300,
			    popupHeight:300,
			    pageTitle: '은행'
			};
		} else if (sPopItem == 'ZIP' ) {	
			rv = {
				xtype:'uniPopupField',
				fieldLabel : '우편번호',
			    valueFieldName:'ZIP',
			    textFieldName:'ZIP_CODE',
			    DBvalueFieldName: 'ZIP_CODE',
			    DBtextFieldName: 'ZIP_NAME',
			    api: 'popupService.zipPopup',
			    app: 'Unilite.app.popup.ZipPopup',
			    //popupPage: '/com/popup/ZipPopup.do',
			    popupWidth:500,
			    popupHeight:500,
				textFieldStyle: 'text-align:center;',
			    pageTitle: '우편번호'
			};
		} else if (sPopItem == 'ZIP_G' ) {	
		 
			rv = {
				xtype:'uniPopupColumn',
			    textFieldName:'ZIP_CODE',
			    DBtextFieldName: 'ZIP_CODE',
			    api: 'popupService.zipPopup',
			    app: 'Unilite.app.popup.ZipPopup',
			    //popupPage: '/com/popup/ZipPopup.do',
			    popupWidth:500,
			    popupHeight:500,
			    pageTitle: '우편번호'
			};
		} else if (sPopItem == 'USER' ) {				
			rv = {
				xtype:'uniPopupField',
				fieldLabel : '사용자',
			    valueFieldName:'USER_ID',
			    textFieldName:'USER_NAME',
			    DBvalueFieldName: 'USER_ID',
			    DBtextFieldName: 'USER_NAME',
			    api: 'popupService.userPopup',
			    app: 'Unilite.app.popup.UserPopup',
			    //popupPage: '/com/popup/UserPopup.do',                
			    popupWidth:650,
			    popupHeight:400,
			    pageTitle: '사용자 ID'
			};
		} else if (sPopItem == 'USER_SINGLE' ) {	//발주등록 승인자 팝업필요			
			rv = {
					xtype:'uniPopupField',
					fieldLabel : '사용자',
					textFieldOnly: true,
				    valueFieldName:'USER_ID',
				    textFieldName:'USER_NAME',
				    DBvalueFieldName: 'USER_ID',
				    DBtextFieldName: 'USER_NAME',
				    api: 'popupService.userPopup',
				    app: 'Unilite.app.popup.UserPopup',
				    //popupPage: '/com/popup/UserPopup.do',                
				    popupWidth:650,
				    popupHeight:400,
				    pageTitle: '사용자 ID'
				};
		} else if (sPopItem == 'USER_G' ) {
			rv = {
				xtype:'uniPopupColumn',
			    textFieldName:'USER_ID',
			    DBtextFieldName: 'USER_NAME',
			    api: 'popupService.userPopup',
			    app: 'Unilite.app.popup.UserPopup',
			    //popupPage: '/com/popup/UserPopup.do',
			    popupWidth:500,
			    popupHeight:300,
			    pageTitle: '사용자 ID'
			};
		} else if (sPopItem == 'Employee' ) {
			rv = {
				xtype:'uniPopupField',
				fieldLabel : '사원',
			    valueFieldName:'PERSON_NUMB',
			    textFieldName:'NAME',
			    DBvalueFieldName: 'PERSON_NUMB',
			    DBtextFieldName: 'NAME',
			    api: 'popupService.employeePopup',
			    app: 'Unilite.app.popup.EmployeePopup',
			    //popupPage: '/com/popup/EmployeePopup.do',
			    popupWidth:600,
			    popupHeight:500,
			    pageTitle: '사원조회 POPUP'
			};
		} else if (sPopItem == 'Employee_G' ) {
			rv = {
				xtype:'uniPopupColumn',
			    textFieldName:'NAME',
			    DBtextFieldName: 'NAME',
			    api: 'popupService.employeePopup',
			    app: 'Unilite.app.popup.EmployeePopup',
			    //popupPage: '/com/popup/EmployeePopup.do',
			    popupWidth:600,
			    popupHeight:500,
			    pageTitle: '사원조회 POPUP'
			};
		} else if (sPopItem == 'DEPT' ) {

			rv = {
				xtype:'uniPopupField',
				fieldLabel : '부서',
			    valueFieldName:'DEPT_CODE',
			    textFieldName:'DEPT_NAME',
			    DBvalueFieldName: 'TREE_CODE',
			    DBtextFieldName: 'TREE_NAME',
			    api: 'popupService.deptPopup',
			    app: 'Unilite.app.popup.DeptPopup',
			    //popupPage: '/com/popup/DeptPopup.do',
			    popupWidth:300,
			    popupHeight:300,
			    pageTitle: '부서코드'
			};
		} else if (sPopItem == 'DEPT_G' ) {
		
			rv = {
				xtype: 'uniPopupColumn',
			    textFieldName:'DEPT_NAME',
			    DBtextFieldName: 'TREE_NAME',
			    api: 'popupService.deptPopup',
			    app: 'Unilite.app.popup.DeptPopup',
			    //popupPage: '/com/popup/DeptPopup.do',
			    popupWidth:300,
			    popupHeight:300,
			    pageTitle: '부서코드'
			};
		} else if (sPopItem == 'ITEM' ) {		
			rv = {
				xtype:'uniPopupField', // 일반 Form용 
				fieldLabel : '품목코드',
			    valueFieldName:'ITEM_CODE',
			    textFieldName:'ITEM_NAME',
			    DBvalueFieldName: 'ITEM_CODE',
			    DBtextFieldName: 'ITEM_NAME',
			    api: 'popupService.itemPopup',
			    app: 'Unilite.app.popup.ItemPopup',
			    //popupPage: '/com/popup/ItemPopup.do',
			    pageTitle: '품목정보'
			};
		} else if (sPopItem == 'ITEM_G' ) {		
			rv = {
				xtype:'uniPopupColumn', // 일반 Form용 
			    textFieldName:'ITEM_NAME',
			    DBtextFieldName: 'ITEM_NAME',
			    api: 'popupService.itemPopup',
			    app: 'Unilite.app.popup.ItemPopup',
			    //popupPage: '/com/popup/ItemPopup.do',
			    pageTitle: '품목정보'
			};
		} else if (sPopItem == 'ITEM2' ) {		
			rv = {
				xtype:'uniPopupField', // 일반 Form용 
				fieldLabel : '품목코드',
			    valueFieldName:'ITEM_CODE2',
			    textFieldName:'ITEM_NAME2',
			    DBvalueFieldName: 'ITEM_CODE',
			    DBtextFieldName: 'ITEM_NAME',
			    api: 'popupService.itemPopup2',
			    app: 'Unilite.app.popup.ItemPopup2',
			    //popupPage: '/com/popup/ItemPopup2.do',
			    pageTitle: '사용자별 품목정보'
			    
			};
		} else if (sPopItem == 'ITEM2_G' ) {		
			rv = {
				xtype:'uniPopupColumn', // 일반 Form용 
			    textFieldName:'ITEM_NAME2',
			    DBtextFieldName: 'ITEM_NAME',
			    api: 'popupService.itemPopup2',
			    app: 'Unilite.app.popup.ItemPopup2',
			    //popupPage: '/com/popup/ItemPopup.do',
			    pageTitle: '사용자별 품목정보'
			};	
		}else if (sPopItem == 'DIV_PUMOK' ) {		
			rv = {
				xtype:'uniPopupField', // 일반 Form용 
				fieldLabel : '품목코드',
			    valueFieldName:'ITEM_CODE',
			    textFieldName:'ITEM_NAME',
			    DBvalueFieldName: 'ITEM_CODE',
			    DBtextFieldName: 'ITEM_NAME',
			    api: 'popupService.divPumokPopup',
                app: 'Unilite.app.popup.DivPumokPopup',
			    //popupPage: '/com/popup/DivPumokPopup.do',
			    pageTitle: '사업장별 품목정보'
			};
		} else if (sPopItem == 'DIV_PUMOK_G' ) {		
			rv = {
				xtype:'uniPopupColumn', // 일반 Form용 
			    textFieldName:'ITEM_NAME',
			    DBtextFieldName: 'ITEM_NAME',
			    api: 'popupService.divPumokPopup',
                app: 'Unilite.app.popup.DivPumokPopup',
			    //popupPage: '/com/popup/DivPumokPopup.do',
			    pageTitle: '사업장별 품목정보'
			};
		} else if (sPopItem == 'ITEM_GROUP' ) {		
			rv = {
				xtype:'uniPopupField', // 일반 Form용 
				fieldLabel : '품목코드(대표모델)',
			    valueFieldName:'ITEM_CODE',
			    textFieldName:'ITEM_NAME',
			    DBvalueFieldName: 'ITEM_CODE',
			    DBtextFieldName: 'ITEM_NAME',
			    api: 'popupService.itemGroupPopup',
			    app: 'Unilite.app.popup.ItemGroupPopup',
			    //popupPage: '/com/popup/ItemGroupPopup.do',
			    pageTitle: '대표모델정보'
			};
		} else if (sPopItem == 'ITEM_GROUP_G' ) {		
			rv = {
				xtype:'uniPopupColumn', // 일반 Form용 
			    textFieldName:'ITEM_NAME',
			    DBtextFieldName: 'ITEM_NAME',
			    api: 'popupService.itemGroupPopup',
			    app: 'Unilite.app.popup.ItemGroupPopup',
			    //popupPage: '/com/popup/ItemGroupPopup.do',
			    pageTitle: '대표모델정보'
			};
		} else if (sPopItem == 'DIV_ITEM_GROUP' ) {		
			rv = {
				xtype:'uniPopupField', // 일반 Form용 
				fieldLabel : '사업장별 품목코드(대표모델)',
			    valueFieldName:'ITEM_CODE',
			    textFieldName:'ITEM_NAME',
			    DBvalueFieldName: 'ITEM_CODE',
			    DBtextFieldName: 'ITEM_NAME',
			    api: 'popupService.divItemGroupPopup',
			    app: 'Unilite.app.popup.DivItemGroupPopup',
			    //popupPage: '/com/popup/DivItemGroupPopup.do',
			    pageTitle: '사업장별 대표모델정보'
			};
		} else if (sPopItem == 'DIV_ITEM_GROUP_G' ) {		
			rv = {
				xtype:'uniPopupColumn', // 일반 Form용 
			    textFieldName:'ITEM_NAME',
			    DBtextFieldName: 'ITEM_NAME',
			    api: 'popupService.divItemGroupPopup',
			    app: 'Unilite.app.popup.DivItemGroupPopup',
			    //popupPage: '/com/popup/DivItemGroupPopupPopup.do',
			    pageTitle: '사업장별 대표모델정보'
			};
		}else if (sPopItem == 'SAFFER_TAX' ) {
			rv = {
				xtype:'uniPopupField',
				fieldLabel : '세무서코드',
			    valueFieldName:'SUB_CODE',
			    textFieldName:'CODE_NAME',
			    DBvalueFieldName: 'SUB_CODE',
			    DBtextFieldName: 'CODE_NAME',
			    api: 'popupService.safferTaxPopup',			    
			    app: 'Unilite.app.popup.SafferTaxPopup',
			    //popupPage: '/com/popup/SafferTaxPopup.do',
			    popupWidth:300,
			    popupHeight:300,
			    pageTitle: '세무서코드'
			};
		} else if (sPopItem == 'SAFFER_TAX_G' ) {
			rv = {
				xtype:'uniPopupColumn',
			    textFieldName:'SUB_CODE',
			    DBtextFieldName: 'CODE_NAME',
			    api: 'popupService.safferTaxPopup',
			    app: 'Unilite.app.popup.SafferTaxPopup',
			    //popupPage: '/com/popup/SafferTaxPopup.do',
			    popupWidth:300,
			    popupHeight:300,
			    pageTitle: '세무서코드'
			};
		}else if (sPopItem == 'DRIVER' ) {
			rv = {
				xtype:'uniPopupField',
				fieldLabel : '기사',
			    valueFieldName:'DRIVER_CODE',
			    textFieldName:'DRIVER_NAME',
			    DBvalueFieldName: 'DRIVER_CODE',
			    DBtextFieldName: 'DRIVER_NAME',
			    api: 'popupService.driverPopup',			    
			    app: 'Unilite.app.popup.DriverPopupWin',
			    popupWidth:300,
			    popupHeight:300,
			    pageTitle: '기사'
			};
		} else if (sPopItem == 'DRIVER_G' ) {
			rv = {
				xtype:'uniPopupColumn',
			    textFieldName:'DRIVER_NAME',
			    DBtextFieldName: 'DRIVER_NAME',
			    api: 'popupService.driverPopup',
			    app: 'Unilite.app.popup.DriverPopupWin',			   
			    popupWidth:300,
			    popupHeight:300,
			    pageTitle: '기사'
			};
		}else if (sPopItem == 'MECHANIC' ) {
			rv = {
				xtype:'uniPopupField',
				fieldLabel : '정비사',
			    valueFieldName:'MECHANIC_CODE',
			    textFieldName:'MECHANIC_NAME',
			    DBvalueFieldName: 'MECHANIC_CODE',
			    DBtextFieldName: 'MECHANIC_NAME',
			    api: 'popupService.mechanicPopup',			    
			    app: 'Unilite.app.popup.mechanicPopupWin',
			    popupWidth:300,
			    popupHeight:300,
			    pageTitle: '정비사'
			};
		} else if (sPopItem == 'MECHANIC_G' ) {
			rv = {
				xtype:'uniPopupColumn',
			    textFieldName:'MECHANIC_NAME',
			    DBtextFieldName: 'MECHANIC_NAME',
			    api: 'popupService.mechanicPopup',
			    app: 'Unilite.app.popup.MechanicPopupWin',			   
			    popupWidth:300,
			    popupHeight:300,
			    pageTitle: '정비사'
			};
		} else if (sPopItem == 'CUST_BILL_PRSN' ) {
			rv = {
				xtype:'uniPopupField',
				fieldLabel : '담당자',
			    valueFieldName:'SEQ',
			    textFieldName:'PRSN_NAME',
			    DBvalueFieldName: 'SEQ',
			    DBtextFieldName: 'PRSN_NAME',
			    api: 'popupService.custBillPrsnPopup',			    
			    app: 'Unilite.app.popup.CustBillPrsnPopupWin',
			    popupWidth:300,
			    popupHeight:300,
			    pageTitle: '전자세금계산서 담당자'
			};
		} else if (sPopItem == 'CUST_BILL_PRSN_G' ) {
			rv = {
				xtype:'uniPopupColumn',
			    textFieldName:'PRSN_NAME',
			    DBtextFieldName: 'PRSN_NAME',
			    api: 'popupService.custBillPrsnPopup',
			    app: 'Unilite.app.popup.CustBillPrsnPopupWin',			   
			    popupWidth:300,
			    popupHeight:300,
			    pageTitle: '전자세금계산서 담당자'
			};
		}/*else if (sPopItem == 'PROJECT' ) {	//관리번호 팝업
			rv = {
				xtype:'uniPopupField',
				fieldLabel : '관리번호',
			    valueFieldName:'PROJECT_CODE',
			    textFieldName:'PROJECT_NAME',
			    DBvalueFieldName: 'PROJECT_CODE',
			    DBtextFieldName: 'PROJECT_NAME',
			    api: 'popupService.projectPopup',			    	
			    app: 'Unilite.app.popup.ProjectPopup',
			    //popupPage: '/com/popup/bk/DeptPopup.do',
			    popupWidth:300,
			    popupHeight:300,
			    pageTitle: '관리번호'
			}; 
		}*/	
		
       // console.log("BEFORE", rv.allowBlank, config.allowBlank)
		if (config) {
            Ext.apply(rv, config);
            console.log('uniPopup Config : ', config);
            console.log('uniPopup rv : ', rv);
        }
        //console.log("AFTER", rv.allowBlank, config)
		return rv;
				
	}
}) 