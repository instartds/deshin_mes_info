//@charset UTF-8
/**
 * @class Unilite
 * Popup 접근을 쉽게 하기 위한 함수 모음.
 */
Ext.apply(Unilite,{
	/**
	 * ## popup 설정 생성 함수. 
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
	_setUseYn: function()	{
		var r = '';
		console.log('PGM_ID.indexOf("ukr") : ', PGM_ID.indexOf("ukr"));
		if(Ext.isDefined(PGM_ID))	{
			if(PGM_ID.indexOf("ukr")==6)	{
				r = 'Y'
			}
		}
		return r;
	},
	popup: function(sPopItem, config ) {
		var rv={} ;
		
		
		
		if (sPopItem == 'WKORD_NUM' ) { 		// 작업지시정보
			rv = {
				xtype:'uniPopupField', // 일반 Form용 
				fieldLabel : '작업지시정보',
				textFieldOnly: true,		
				textFieldName:'WKORD_NUM',
			    DBtextFieldName: 'WKORD_NUM',
			    api: 'popupService.wkordNum',
			    app: 'Unilite.app.popup.WkordNum',
			    //popupPage: '/com/popup/bk/CustPopup.do',
			    valueFieldWidth: 60,
			    textFieldWidth: 170,
			    pageTitle: '작업지시정보'
			};
		} else if (sPopItem == 'WKORD_NUM_G' ) {    // 작업지시정보_G
			rv = {
				xtype:'uniPopupColumn',		// Grid용 
				textFieldName:'WKORD_NUM',
			    DBtextFieldName: 'WKORD_NUM',
			    api: 'popupService.wkordNum',
			    app: 'Unilite.app.popup.WkordNum',
			    //popupPage: '/com/popup/bk/CustPopup.do',
			    pageTitle: '작업지시정보'
			};
		}
		
		if (sPopItem == 'PROG_WORK_CODE' ) { 		// 공정정보
			rv = {
				xtype:'uniPopupField', // 일반 Form용 
				fieldLabel : '공정정보',
				valueFieldName:'PROG_WORK_CODE',
			    textFieldName:'PROG_WORK_NAME',
			    DBvalueFieldName: 'PROG_WORK_CODE',
			    DBtextFieldName: 'PROG_WORK_NAME',
			    api: 'popupService.progWorkCode',
			    app: 'Unilite.app.popup.ProgWorkCode',
			    //popupPage: '/com/popup/bk/CustPopup.do',
			    valueFieldWidth: 60,
			    textFieldWidth: 170,
			    pageTitle: '공정정보'
			};
		} else if (sPopItem == 'PROG_WORK_CODE_G' ) {    // 공정정보
			rv = {
				xtype:'uniPopupColumn',		// Grid용 
				textFieldName:'PROG_WORK_NAME',
			    DBtextFieldName: 'PROG_WORK_NAME',
			    api: 'popupService.progWorkCode',
			    app: 'Unilite.app.popup.ProgWorkCode',
			    //popupPage: '/com/popup/bk/CustPopup.do',
			    pageTitle: '공정정보'
			};
		}
		
		if (sPopItem == 'OUTSTOCK_NUM' ) { 		// 출고요청번호
			rv = {
				xtype:'uniPopupField', // 일반 Form용 
				fieldLabel : '출고요청번호',
				textFieldName:'OUTSTOCK_NUM',
			    DBtextFieldName: 'OUTSTOCK_NUM',
			    textFieldOnly: true,
			    textFieldConfig: {
			    	xtype: 'uniTextfield'
			    },
			    api: 'popupService.outStockNum',
			    app: 'Unilite.app.popup.OutStockNum',
			    popupWidth:600,
			    popupHeight:300,
			    textFieldWidth: 150,
			    pageTitle: '출고요청번호'
			};
		}
		
		if (sPopItem == 'CREDIT_CARD2' ) { 		// 신용카드
			rv = {
				xtype:'uniPopupField', // 일반 Form용 
				fieldLabel : '법인카드',
			    valueFieldName:'CRDT_NUM',
			    textFieldName:'CRDT_NAME',
			    DBvalueFieldName: 'CRDT_NUM',
			    DBtextFieldName: 'CRDT_NAME',
			    api: 'popupService.creditCard2',
			    app: 'Unilite.app.popup.CreditCard2',
			    //popupPage: '/com/popup/bk/CustPopup.do',
			    valueFieldWidth: 60,
			    textFieldWidth: 170,
			    pageTitle: '신용카드'
			};
		} else if (sPopItem == 'CREDIT_CARD2_G' ) {    // 신용카드
			rv = {
				xtype:'uniPopupColumn',		// Grid용 
			    textFieldName:'CRDT_NAME',
			    DBtextFieldName: 'CRDT_NAME',
			    api: 'popupService.creditCard2',
			    app: 'Unilite.app.popup.CreditCard2',
			    //popupPage: '/com/popup/bk/CustPopup.do',
			    pageTitle: '신용카드'
			};
		}
		
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
			    //popupPage: '/com/popup/bk/CustPopup.do',
			    useyn:this._setUseYn() ,
			    valueFieldWidth: 60,
			    textFieldWidth: 170,
			    pageTitle: '거래처정보'
			};
		} else if (sPopItem == 'CUST_G' ) {    // 거래처 그리드용
			rv = {
				xtype:'uniPopupColumn',		// Grid용 
			    textFieldName:'CUSTOM_NAME',
			    DBtextFieldName: 'CUSTOM_NAME',
			    api: 'popupService.custPopup',
			    app: 'Unilite.app.popup.CustPopup',
			    //popupPage: '/com/popup/bk/CustPopup.do',
			    useyn:this._setUseYn() ,
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
                //popupPage: '/com/popup/bk/AgentCustPopup.do',
                useyn:this._setUseYn() ,
			    popupWidth: 800,
			    valueFieldWidth: 60,
			    textFieldWidth: 170,
			    pageTitle: '거래처정보'
			};
		} else if (sPopItem == 'AGENT_CUST_G' ) {    // 거래처 그리드용
			rv = {
				xtype:'uniPopupColumn',		// Grid용 
			    textFieldName:'CUSTOM_NAME',
			    DBtextFieldName: 'CUSTOM_NAME',
			    api: 'popupService.agentCustPopup',
			    app: 'Unilite.app.popup.AgentCustPopup',
			    //popupPage: '/com/popup/bk/AgentCustPopup.do',
			    useyn:this._setUseYn() ,
			    popupWidth:800,
			    pageTitle: '거래처정보'
			};
		} else if (sPopItem == 'AGENT_CUST_MULTI' ) { 		// 거래처 MULTI
			rv = {
				xtype:'uniPopupField', // 일반 Form용 
				fieldLabel : '거래처',
			    valueFieldName:'CUSTOM_CODE',
			    textFieldName:'CUSTOM_NAME',
			    DBvalueFieldName: 'CUSTOM_CODE',
			    DBtextFieldName: 'CUSTOM_NAME',
			    api: 'popupService.agentCustPopup',
                app: 'Unilite.app.popup.AgentCustPopup2',
                //popupPage: '/com/popup/bk/AgentCustPopup.do',
                useyn:this._setUseYn() ,
			    popupWidth: 800,
			    valueFieldWidth: 60,
			    textFieldWidth: 170,
			    pageTitle: '거래처정보'
			};
		} else if (sPopItem == 'AGENT_CUST_SINGLE' ) { 		// 거래처 1칸짜리 폼용..ssa560ukrv적용위해..(매출용 single팝업)
			rv = {
				xtype:'uniPopupField', // 일반 Form용 
				fieldLabel : '거래처',
				textFieldOnly: true,
			    valueFieldName:'CUSTOM_CODE',
			    textFieldName:'CUSTOM_NAME',
			    DBvalueFieldName: 'CUSTOM_CODE',
			    DBtextFieldName: 'CUSTOM_NAME',
			    api: 'popupService.agentCustPopup',
                app: 'Unilite.app.popup.AgentCustPopup',
                //popupPage: '/com/popup/bk/AgentCustPopup.do',
                useyn:this._setUseYn() ,
			    popupWidth: 800,
			    textFieldWidth: 150,
			    pageTitle: '거래처정보'
			};
		} else if (sPopItem == 'AGENT_CUST_SINGLE2' ) { 		// 거래처 1칸짜리 폼용..bpr102ukrv적용위해..(매입용 single팝업)
			rv = {
				xtype:'uniPopupField', // 일반 Form용 
				fieldLabel : '거래처',
				textFieldOnly: true,
			    valueFieldName:'CUSTOM_CODE',
			    textFieldName:'CUSTOM_NAME',
			    DBvalueFieldName: 'CUSTOM_CODE',
			    DBtextFieldName: 'CUSTOM_NAME',
			    api: 'popupService.custPopup',
                app: 'Unilite.app.popup.CustPopup',
                //popupPage: '/com/popup/bk/AgentCustPopup.do',
                useyn:this._setUseYn() ,
			    popupWidth: 800,
			    textFieldWidth: 150,
			    pageTitle: '거래처정보'
			};
		} else if (sPopItem == 'AGENT_CUST_MULTI_G' ) {    // 거래처 그리드용 MULTI
			rv = {
				xtype:'uniPopupColumn',		// Grid용 
			    textFieldName:'CUSTOM_NAME',
			    DBtextFieldName: 'CUSTOM_NAME',
			    api: 'popupService.agentCustPopup',
			    app: 'Unilite.app.popup.AgentCustPopup2',
			    //popupPage: '/com/popup/bk/AgentCustPopup.do',
			    useyn:this._setUseYn() ,
			    popupWidth:800,
			    pageTitle: '거래처정보'
			};
		} else if (sPopItem == 'CUSTOMER' ) { 	// 고객정보 ( CLIENT_ID, CLIENT_NAME)
		
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
			    valueFieldWidth: 60,
			    textFieldWidth: 170,
			    pageTitle: '고객 정보'
			};
		} else if (sPopItem == 'CUSTOMER_G' ) {  // 고객 그리드용
		
			rv = {
				xtype:'uniPopupColumn',
			    textFieldName:'CLIENT_NAME',
			    DBtextFieldName: 'CLIENT_NAME',
			    //api: 'cmPopupService.clientPopup',
			    app: 'Unilite.app.popup.ClientPopup',
			    popupPage: '/crm/ClientPopup.do',
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
			    //popupPage: '/crm/cmClientProjectPopup.do',
			    popupWidth:800,
			    valueFieldWidth: 60,
			    textFieldWidth: 170,
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
                api: 'cmPopupService.clientProjectList',
			    app: 'Unilite.app.popup.cmClientProjectPopup',
			    //popupPage: '/crm/cmClientProjectPopup.do',
			    popupWidth:800,
			    valueFieldWidth: 60,
			    textFieldWidth: 170,
			    pageTitle: '고객 정보'
			};
		} else if (sPopItem == 'CLIENT_PROJECT_G' ) {	// 고객 그리드용
	 
			rv = {
				xtype:'uniPopupColumn',
			    textFieldName:'PROJECT_NAME',
			    DBtextFieldName: 'PROJECT_NAME',
			    api: 'cmPopupService.clientProjectList',
			    app: 'Unilite.app.popup.cmClientProjectPopup',
			    //popupPage: '/crm/cmClientProjectPopup.do',
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
			    //popupPage: '/com/popup/bk/BankPopup.do',
			    popupWidth:400,
			    popupHeight:500,
			    valueFieldWidth: 60,
			    textFieldWidth: 170,
			    pageTitle: '은행'
			};
		} else if (sPopItem == 'BANK_G' ) {
			rv = {
				xtype:'uniPopupColumn',
				valueFieldName:'BANK_CODE',
			    textFieldName:'BANK_NAME',
			    DBvalueFieldName: 'BANK_CODE',
			    DBtextFieldName: 'BANK_NAME',
			    api: 'popupService.bankPopup',
			    app: 'Unilite.app.popup.BankPopup',
			    //popupPage: '/com/popup/bk/BankPopup.do',
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
			    api: '',//'popupService.zipPopup', 
			    app: 'Unilite.app.popup.ZipPopup',
			    //popupPage: '/com/popup/bk/ZipPopup.do',
			    popupWidth:500,
			    popupHeight:500,
			    valueFieldWidth: 60,
			    textFieldWidth: 170,
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
			    //popupPage: '/com/popup/bk/ZipPopup.do',
			    popupWidth:500,
			    popupHeight:500,
			    pageTitle: '우편번호'
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
			    textFieldWidth: 150,
			    pageTitle: '사용자 ID'
				};
		}else if (sPopItem == 'USER' ) {				
			rv = {
				xtype:'uniPopupField',
				fieldLabel : '사용자',
			    valueFieldName:'USER_ID',
			    textFieldName:'USER_NAME',
			    DBvalueFieldName: 'USER_ID',
			    DBtextFieldName: 'USER_NAME',
			    api: 'popupService.userPopup',
			    app: 'Unilite.app.popup.UserPopup',
			    //popupPage: '/com/popup/bk/UserPopup.do',                
			    popupWidth:650,
			    popupHeight:400,
			    valueFieldWidth: 60,
			    textFieldWidth: 170,
			    pageTitle: '사용자 ID'
			};
		} else if (sPopItem == 'USER_G' ) {
			rv = {
				xtype:'uniPopupColumn',
			    textFieldName:'USER_NAME',
			    DBtextFieldName: 'USER_NAME',
			    api: 'popupService.userPopup',
			    app: 'Unilite.app.popup.UserPopup',
			    //popupPage: '/com/popup/bk/UserPopup.do',
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
			    //popupPage: '/com/popup/bk/EmployeePopup.do',
			    popupWidth:600,
			    popupHeight:500,
			    valueFieldWidth: 60,
			    textFieldWidth: 170,
			    pageTitle: '사원조회 POPUP'
			};
		} else if (sPopItem == 'Employee_G' ) {
			rv = {
				xtype:'uniPopupColumn',
			    textFieldName:'NAME',
			    DBtextFieldName: 'NAME',
			    api: 'popupService.employeePopup',
			    app: 'Unilite.app.popup.EmployeePopup',
			    //popupPage: '/com/popup/bk/EmployeePopup.do',
			    popupWidth:600,
			    popupHeight:500,
			    pageTitle: '사원조회 POPUP'
			};
		} else if (sPopItem == 'WORK_SHOP' ) {

			rv = {
				xtype:'uniPopupField',
				fieldLabel : '작업장',
			    valueFieldName:'TREE_CODE',
			    textFieldName:'TREE_NAME',
			    DBvalueFieldName: 'TREE_CODE',
			    DBtextFieldName: 'TREE_NAME',
			    api: 'popupService.workShopPopup',
			    app: 'Unilite.app.popup.WorkShopPopup',
			    //popupPage: '/com/popup/bk/DeptPopup.do',
			    popupWidth:600,
			    popupHeight:500,
			    valueFieldWidth: 60,
			    textFieldWidth: 170,
			    pageTitle: '작업장조회'
			};
		} else if (sPopItem == 'WORK_SHOP_G' ) {	// 그리드용

			rv = {
				xtype:'uniPopupColumn',
				//fieldLabel : '작업장',
			    valueFieldName:'TREE_CODE',
			    textFieldName:'TREE_NAME',
			    DBvalueFieldName: 'TREE_CODE',
			    DBtextFieldName: 'TREE_NAME',
			    api: 'popupService.workShopPopup',
			    app: 'Unilite.app.popup.WorkShopPopup',
			    //popupPage: '/com/popup/bk/DeptPopup.do',
			    popupWidth:600,
			    popupHeight:500,
			    //valueFieldWidth: 60,
			    //textFieldWidth: 170,
			    pageTitle: '작업장조회'
			};
		}  else if (sPopItem == 'DEPT' ) {

			rv = {
				xtype:'uniPopupField',
				fieldLabel : '부서',
			    valueFieldName:'DEPT_CODE',
			    textFieldName:'DEPT_NAME',
			    DBvalueFieldName: 'TREE_CODE',
			    DBtextFieldName: 'TREE_NAME',
			    api: 'popupService.deptPopup',
			    app: 'Unilite.app.popup.DeptPopup',
			    //popupPage: '/com/popup/bk/DeptPopup.do',
			    popupWidth:350,
			    popupHeight:500,
			    valueFieldWidth: 60,
			    textFieldWidth: 170,
			    pageTitle: '부서코드'
			};
		} else if (sPopItem == 'DEPT_G' ) {
		
			rv = {
				xtype: 'uniPopupColumn',
			    textFieldName:'DEPT_NAME',
			    DBtextFieldName: 'TREE_NAME',
			    api: 'popupService.deptPopup',
			    app: 'Unilite.app.popup.DeptPopup',
			    //popupPage: '/com/popup/bk/DeptPopup.do',
			    popupWidth:350,
			    popupHeight:500,
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
			    useyn:this._setUseYn() ,
			    //popupPage: '/com/popup/bk/ItemPopup.do',
			    valueFieldWidth: 90,
				textFieldWidth: 140,
			    pageTitle: '품목정보'
			};
		} else if (sPopItem == 'ITEM_G' ) {		
			rv = {
				xtype:'uniPopupColumn', // 일반 Form용 
			    textFieldName:'ITEM_NAME',
			    DBtextFieldName: 'ITEM_NAME',
			    api: 'popupService.itemPopup',
			    app: 'Unilite.app.popup.ItemPopup',
			    //popupPage: '/com/popup/bk/ItemPopup.do',
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
			    //app: 'Unilite.app.popup.ItemPopup2',
			    useyn:this._setUseYn() ,
			    valueFieldWidth: 90,
				textFieldWidth: 140,
			    popupPage: '/com/popup/bk/ItemPopup2.do',
			    pageTitle: '사용자별 품목정보'
			    
			};
		} else if (sPopItem == 'ITEM2_G' ) {		
			rv = {
				xtype:'uniPopupColumn', // 일반 Form용 
			    textFieldName:'ITEM_NAME2',
			    DBtextFieldName: 'ITEM_NAME',
			    api: 'popupService.itemPopup2',
			    //app: 'Unilite.app.popup.ItemPopup2',
			    popupPage: '/com/popup/bk/ItemPopup2.do',
			    useyn:this._setUseYn() ,
			    pageTitle: '사용자별 품목정보'
			};	
		} else if (sPopItem == 'CUST_PUMOK' ) {		
			rv = {
				xtype:'uniPopupField', // 일반 Form용 
				fieldLabel : '품목코드',
			    valueFieldName:'ITEM_CODE',
			    textFieldName:'ITEM_NAME',
			    DBvalueFieldName: 'ITEM_CODE',
			    DBtextFieldName: 'ITEM_NAME',
			    api: 'popupService.custPumokPopup',
                app: 'Unilite.app.popup.CustPumokPopup',
			    //popupPage: '/com/popup/bk/DivPumokPopup.do',
                useyn:this._setUseYn() ,
                valueFieldWidth: 90,
				textFieldWidth: 140,
			    pageTitle: '거래처별 품목정보'
			};
		} else if (sPopItem == 'CUST_PUMOK_G' ) {		
			rv = {
				xtype:'uniPopupColumn', 
			    textFieldName:'ITEM_NAME',
			    DBtextFieldName: 'ITEM_NAME',
			    api: 'popupService.custPumokPopup',
                app: 'Unilite.app.popup.CustPumokPopup',
                useyn:this._setUseYn() ,
			    //popupPage: '/com/popup/bk/DivPumokPopup.do',
			    pageTitle: '거래처별 품목정보'
			};
		} else if (sPopItem == 'DIV_PUMOK' ) {		
			rv = {
				xtype:'uniPopupField', // 일반 Form용 
				fieldLabel : '품목코드',
			    valueFieldName:'ITEM_CODE',
			    textFieldName:'ITEM_NAME',
			    DBvalueFieldName: 'ITEM_CODE',
			    DBtextFieldName: 'ITEM_NAME',
			    api: 'popupService.divPumokPopup',
                app: 'Unilite.app.popup.DivPumokPopup',
			    //popupPage: '/com/popup/bk/DivPumokPopup.do',
                useyn:this._setUseYn() ,
                valueFieldWidth: 90,
				textFieldWidth: 140,
			    pageTitle: '사업장별 품목정보'
			};
		} else if (sPopItem == 'DIV_PUMOK_G' ) {		
			rv = {
				xtype:'uniPopupColumn', 
			    textFieldName:'ITEM_NAME',
			    DBtextFieldName: 'ITEM_NAME',
			    api: 'popupService.divPumokPopup',
                app: 'Unilite.app.popup.DivPumokPopup',
                useyn:this._setUseYn() ,
			    //popupPage: '/com/popup/bk/DivPumokPopup.do',
			    pageTitle: '사업장별 품목정보'
			};
		} else if (sPopItem == 'DIV_PUMOK2' ) {		
			rv = {
				xtype:'uniPopupField', // 일반 Form용 
				fieldLabel : '품목코드',
			    valueFieldName:'ITEM_CODE',
			    textFieldName:'ITEM_NAME',
			    DBvalueFieldName: 'ITEM_CODE',
			    DBtextFieldName: 'ITEM_NAME',
			    api: 'popupService.divPumok2Popup',
                app: 'Unilite.app.popup.DivPumok2Popup',
			    //popupPage: '/com/popup/bk/DivPumokPopup.do',
                useyn:this._setUseYn() ,
                valueFieldWidth: 90,
				textFieldWidth: 140,
			    pageTitle: '사업장별 품목정보'
			};
		} else if (sPopItem == 'DIV_PUMOK2_G' ) {		
			rv = {
				xtype:'uniPopupColumn', 
			    textFieldName:'ITEM_NAME',
			    DBtextFieldName: 'ITEM_NAME',
			    api: 'popupService.divPumok2Popup',
                app: 'Unilite.app.popup.DivPumok2Popup',
			    //popupPage: '/com/popup/bk/DivPumokPopup.do',
                useyn:this._setUseYn() ,
			    pageTitle: '사업장별 품목정보'
			};
		} else if (sPopItem == 'COMMISSION_DIV_PUMOK' ) {		
			rv = {
				xtype:'uniPopupField', // 일반 Form용 
				fieldLabel : '품목코드',
			    valueFieldName:'ITEM_CODE',
			    textFieldName:'ITEM_NAME',
			    DBvalueFieldName: 'ITEM_CODE',
			    DBtextFieldName: 'ITEM_NAME',
			    api: 'popupService.commissionDivPumokPopup',
                app: 'Unilite.app.popup.CommissionDivPumokPopup',
			    //popupPage: '/com/popup/bk/DivPumokPopup.do',
                useyn:this._setUseYn() ,
                valueFieldWidth: 90,
				textFieldWidth: 140,
			    pageTitle: '사업장별 품목정보'
			};
		} else if (sPopItem == 'COMMISSION_DIV_PUMOK_G' ) {		//수탁상품 품목(ITEM_ACCOUNT = '04')
			rv = {
				xtype:'uniPopupColumn', 
			    textFieldName:'ITEM_NAME',
			    DBtextFieldName: 'ITEM_NAME',
			    api: 'popupService.commissionDivPumokPopup',
                app: 'Unilite.app.popup.CommissionDivPumokPopup',
                useyn:this._setUseYn() ,
			    pageTitle: '수탁 품목정보'
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
			    valueFieldWidth: 90,
				textFieldWidth: 140,
			    //popupPage: '/com/popup/bk/ItemGroupPopup.do',
			    pageTitle: '대표모델정보'
			};
		} else if (sPopItem == 'ITEM_GROUP_G' ) {		
			rv = {
				xtype:'uniPopupColumn', // 일반 Form용 
			    textFieldName:'ITEM_NAME',
			    DBtextFieldName: 'ITEM_NAME',
			    api: 'popupService.itemGroupPopup',
			    app: 'Unilite.app.popup.ItemGroupPopup',
			    //popupPage: '/com/popup/bk/ItemGroupPopup.do',
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
			    valueFieldWidth: 90,
				textFieldWidth: 140,
			    //popupPage: '/com/popup/bk/DivItemGroupPopup.do',
			    pageTitle: '사업장별 대표모델정보'
			};
		} else if (sPopItem == 'DIV_ITEM_GROUP_G' ) {		
			rv = {
				xtype:'uniPopupColumn', // 일반 Form용 
			    textFieldName:'ITEM_NAME',
			    DBtextFieldName: 'ITEM_NAME',
			    api: 'popupService.divItemGroupPopup',
			    app: 'Unilite.app.popup.DivItemGroupPopup',
			    //popupPage: '/com/popup/bk/DivItemGroupPopupPopup.do',
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
			    //popupPage: '/com/popup/bk/SafferTaxPopup.do',
			    popupWidth:300,
			    popupHeight:300,
			    valueFieldWidth: 60,
			    textFieldWidth: 170,
			    pageTitle: '세무서코드'
			};
		} else if (sPopItem == 'SAFFER_TAX_G' ) {
			rv = {
				xtype:'uniPopupColumn',
			    textFieldName:'SUB_CODE',
			    DBtextFieldName: 'CODE_NAME',
			    api: 'popupService.safferTaxPopup',
			    app: 'Unilite.app.popup.SafferTaxPopup',
			    //popupPage: '/com/popup/bk/SafferTaxPopup.do',
			    popupWidth:300,
			    popupHeight:300,
			    pageTitle: '세무서코드'
			};
		} else if (sPopItem == 'DRIVER' ) {
			rv = {
				xtype:'uniPopupField',
				fieldLabel : '기사',
			    valueFieldName:'DRIVER_CODE',
			    textFieldName:'DRIVER_NAME',
			    DBvalueFieldName: 'DRIVER_CODE',
			    DBtextFieldName: 'DRIVER_NAME',
			    api: 'popupService.driverPopup',			    
			    app: 'Unilite.app.popup.DriverPopup',
			    popupWidth:400,
			    popupHeight:300,
			    valueFieldWidth: 60,
			    textFieldWidth: 170,
			    pageTitle: '기사'
			};
		} else if (sPopItem == 'DRIVER_G' ) {
			rv = {
				xtype:'uniPopupColumn',
			    textFieldName:'DRIVER_NAME',
			    DBtextFieldName: 'DRIVER_NAME',
			    api: 'popupService.driverPopup',
			    app: 'Unilite.app.popup.DriverPopup',
			    popupWidth:400,
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
			    app: 'Unilite.app.popup.MechanicPopupWin',
			    popupWidth:300,
			    popupHeight:300,
			    valueFieldWidth: 60,
			    textFieldWidth: 170,
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
		}else if (sPopItem == 'COUNT_DATE' ) {
			rv = {
				xtype:'uniPopupField',
				textFieldName:'COUNT_DATE',
			    DBtextFieldName: 'COUNT_DATE',
			    textFieldOnly: true,
			    textFieldConfig: {
			    	xtype: 'uniTextfield'
			    },
			    api: 'popupService.countdatePopup',
			    app: 'Unilite.app.popup.CountDatePopup',
			    popupWidth:480,
			    popupHeight:300,
			    textFieldWidth: 150,
			    pageTitle: '실사일'
			};
		} else if (sPopItem == 'VEHICLE' ) {
			rv = {
				xtype:'uniPopupField',
				fieldLabel : '차량',
			    valueFieldName:'VEHICLE_CODE',
			    textFieldName:'VEHICLE_NAME',
			    DBvalueFieldName: 'VEHICLE_CODE',
			    DBtextFieldName: 'VEHICLE_NAME',
			    api: 'popupService.vehiclePopup',			    
			    app: 'Unilite.app.popup.VehiclePopup',
			    popupWidth:400,
			    popupHeight:300,
			    valueFieldWidth: 60,
			    textFieldWidth: 170,
			    pageTitle: '차량'
			};
		} else if (sPopItem == 'VEHICLE_G' ) {
			rv = {
				xtype:'uniPopupColumn',
			    textFieldName:'VEHICLE_NAME',
			    DBtextFieldName: 'VEHICLE_NAME',
			    api: 'popupService.vehiclePopup',
			    app: 'Unilite.app.popup.VehiclePopup',
			    popupWidth:400,
			    popupHeight:300,
			    pageTitle: '차량'
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
			    valueFieldWidth: 60,
			    textFieldWidth: 170,
			    pageTitle: '전자세금계산서 담당자'
			};
		} else if (sPopItem == 'CUST_BILL_PRSN_G' ) {
			rv = {
				xtype:'uniPopupColumn',
			    textFieldName:'PRSN_NAME',
			    DBtextFieldName: 'PRSN_NAME',
			    api: 'popupService.custBillPrsnPopup',
			    app: 'Unilite.app.popup.CustBillPrsnPopupWin',
			    popupWidth:600,
			    popupHeight:400,
			    pageTitle: '전자세금계산서 담당자'
			};
		} else if (sPopItem == 'PJT' ) {	//프로젝트정보 팝업
			rv = {
				xtype:'uniPopupField',
				fieldLabel : '프로젝트정보',
			    textFieldName:'PJT_CODE',			    
			    DBtextFieldName: 'PJT_CODE',
			    textFieldOnly: true,
			    api: 'popupService.pjtPopup',			    	
			    app: 'Unilite.app.popup.PjtPopup',
			    popupWidth:1200,
			    popupHeight:450,
			    textFieldWidth: 150,
			    pageTitle: '프로젝트정보'
			};
		} else if (sPopItem == 'PJT_G' ) {	// 프로젝트정보 팝업
			rv = {
				xtype:'uniPopupColumn',
			    textFieldName:'PJT_CODE',			    
			    DBtextFieldName: 'PJT_CODE',
			    api: 'popupService.pjtPopup',			    	
			    app: 'Unilite.app.popup.PjtPopup',
			    popupWidth:1200,
			    popupHeight:450,
			    pageTitle: '프로젝트정보'
			};
		}else if (sPopItem == 'PROJECT' ) {	//관리번호 팝업
			rv = {
				xtype:'uniPopupField',
				fieldLabel : '관리번호',
			    textFieldName:'PJT_CODE',			    
			    DBtextFieldName: 'PJT_CODE',
			    textFieldOnly: true,
			    api: 'popupService.projectPopup',			    	
			    app: 'Unilite.app.popup.ProjectPopup',
			    popupWidth:600,
			    popupHeight:450,
			    textFieldWidth: 150,
			    pageTitle: '관리번호'
			};
		} else if (sPopItem == 'PROJECT_G' ) {	//관리번호 팝업
			rv = {
				xtype:'uniPopupColumn',
			    textFieldName:'PJT_CODE',			    
			    DBtextFieldName: 'PJT_CODE',
			    api: 'popupService.projectPopup',			    	
			    app: 'Unilite.app.popup.ProjectPopup',
			    popupWidth:600,
			    popupHeight:450,
			    pageTitle: '관리번호'
			};
		} else if (sPopItem == 'SHOP' ) { 		// 매장 
			rv = {
				xtype:'uniPopupField', // 일반 Form용 
				fieldLabel : '매장',
			    valueFieldName:'SHOP_CODE',
			    textFieldName:'SHOP_NAME',
			    DBvalueFieldName: 'SHOP_CODE',
			    DBtextFieldName: 'SHOP_NAME',
			    api: 'popupService.shopPopup',
			    app: 'Unilite.app.popup.ShopPopup',
			    //popupPage: '/com/popup/bk/CustPopup.do',
			    popupWidth:650,
			    popupHeight:400,
			    valueFieldWidth: 60,
			    textFieldWidth: 170,
			    pageTitle: '매장정보'
			};
		} else if (sPopItem == 'SHOP_G' ) {    // 매장 그리드용
			rv = {
				xtype:'uniPopupColumn',		// Grid용 
			    textFieldName:'SHOP_NAME',
			    DBtextFieldName: 'SHOP_NAME',
			    api: 'popupService.shopPopup',
			    app: 'Unilite.app.popup.ShopPopup',
			    //popupPage: '/com/popup/bk/CustPopup.do',
			    popupWidth:650,
			    popupHeight:400,
			    pageTitle: '매장정보'
			};
		} else if (sPopItem == 'LOT_NO' ) { 		// LOT
			rv = {
					xtype:'uniPopupField', // 일반 Form용 
					textFieldName:'LOT_NO',			    
				    DBtextFieldName: 'LOT_NO',
				    textFieldOnly: true,
				    api: 'popupService.lotPopup',
				    app: 'Unilite.app.popup.LotPopup',
				    //popupPage: '/com/popup/bk/CustPopup.do',
				    popupWidth:1200,
				    popupHeight:400,
				    textFieldWidth: 150,
				    pageTitle: 'LOT목록'
				};
			} else if (sPopItem == 'LOT_G' ) {    // LOT 그리드용
				rv = {
					xtype:'uniPopupColumn',		// Grid용 
				    textFieldName:'LOT_CODE',
				    DBtextFieldName: 'LOT_NAME',
				    api: 'popupService.lotPopup',
				    app: 'Unilite.app.popup.LotPopup',
				    //popupPage: '/com/popup/bk/CustPopup.do',
				    popupWidth:700,
				    popupHeight:500,
				    pageTitle: 'LOT목록'
				};
			} else if (sPopItem == 'LOTNO_G' ) {    // LOTNO 그리드용
				rv = {
					xtype:'uniPopupColumn',		// Grid용 
					textFieldName:'LOTNO_CODE',
				    DBtextFieldName: 'LOTNO_CODE',
				    api: 'popupService.lotNoPopup',
				    app: 'Unilite.app.popup.LotNoPopup',
				    //popupPage: '/com/popup/bk/CustPopup.do',
				    popupWidth:1200,
				    popupHeight:550,
				    pageTitle: 'LOT 재고정보'
				};
			} else if (sPopItem == 'INOUT_NUM' ) {	//수불번호 팝업
			rv = {
				//xtype:'uniPopupColumn',//uniPopupField 로 해야 masterForm, pnelResult 연동됨
				xtype:'uniPopupField',
				textFieldName:'INOUT_NUM',
			    DBtextFieldName: 'INOUT_NUM',
			    textFieldOnly: true,
			    api: 'popupService.inoutNumPopup',
			    app: 'Unilite.app.popup.InoutNumPopup',
			    popupWidth:480,
			    popupHeight:450,
			    textFieldWidth: 150,
			    pageTitle: '수불번호'
			};
		} else if (sPopItem == 'ORDER_NUM' ) {	//수주번호 팝업
			rv = {
				//xtype:'uniPopupColumn',//uniPopupField 로 해야 masterForm, pnelResult 연동됨
				xtype:'uniPopupField',
				textFieldName:'ORDER_NUM',
			    DBtextFieldName: 'ORDER_NUM',
			    textFieldOnly: true,
			    api: 'popupService.orderNumPopup',
			    app: 'Unilite.app.popup.OrderNumPopup',
			    popupWidth:480,
			    popupHeight:450,
			    textFieldWidth: 150,
			    pageTitle: '수주번호'
			};
		} else if (sPopItem == 'TAXBILL_SEARCH' ) {	//원본세금계산서 검색 ssa560ukrv에서 사용..
			rv = {				
				xtype:'uniPopupField',
				textFieldName:'UPDATE_REASON_CODE',
			    DBtextFieldName: 'UPDATE_REASON_NAME',
			    api: 'popupService.TaxBillSearchPopup',
			    app: 'Unilite.app.popup.TaxBillSearchPopup',
			    popupWidth:750,
			    popupHeight:450,
			    valueFieldWidth: 90,
				textFieldWidth: 140,
			    pageTitle: '원본세금계산서 검색'
			};
		} else if (sPopItem == 'BOM_COPY' ) {	
			rv = {				
				xtype:'uniPopupField',
				textFieldName:'ITEM_NAME',
			    DBtextFieldName: 'ITEM_NAME',
			    api: 'popupService.BomCopy',
			    app: 'Unilite.app.popup.BomCopyPopup',
			    popupWidth:650,
			    popupHeight:450,
			    valueFieldWidth: 60,
			    textFieldWidth: 170,
			    pageTitle: 'BOM 참조'
			};
		} else if (sPopItem == 'CUST_CREDIT_CARD' ) {	//신용카드 거래처

			rv = {
				xtype:'uniPopupField',
				fieldLabel : '신용카드거래처',			   
			    valueFieldName:'CUST_CREDIT_CODE_V',		//valueFieldName을  DBvalueFieldName와 중복주면 set안됨..
			    textFieldName:'CUST_CREDIT_NAME_V',
			    DBvalueFieldName: 'CUST_CREDIT_CODE',
			    DBtextFieldName: 'CUST_CREDIT_NAME',
			    api: 'popupService.custCreditCard',
			    app: 'Unilite.app.popup.CustCreditCard',
			    //popupPage: '/com/popup/bk/DeptPopup.do',
			    popupWidth:600,
			    popupHeight:500,
			    valueFieldWidth: 60,
			    textFieldWidth: 170,
			    pageTitle: '신용카드거래처'
			};
		} else if (sPopItem == 'CUST_CREDIT_CARD_G' ) {	//신용카드 거래처
			rv = {
				xtype:'uniPopupColumn',		// Grid용 
			    textFieldName:'CUST_CREDIT_NAME_V',
			    DBtextFieldName: 'CUST_CREDIT_NAME',
			    api: 'popupService.custCreditCard',
			    app: 'Unilite.app.popup.CustCreditCard',
			    //popupPage: '/com/popup/bk/AgentCustPopup.do',
			    popupWidth:600,
			    popupHeight:500,
			    pageTitle: '신용카드거래처'
			};
		} else if (sPopItem == 'CREDIT_CARD' ) {	//신용카드사

			rv = {
				xtype:'uniPopupField',
				fieldLabel : '신용카드사',
			    valueFieldName:'CREDIT_CODE_V',
			    textFieldName:'CREDIT_NAME_V',
			    DBvalueFieldName: 'CREDIT_CODE',
			    DBtextFieldName: 'CREDIT_NAME',
			    api: 'popupService.creditCard',
			    app: 'Unilite.app.popup.CreditCard',
			    //popupPage: '/com/popup/bk/DeptPopup.do',
			    popupWidth:390,
			    popupHeight:400,
			    valueFieldWidth: 60,
			    textFieldWidth: 170,
			    pageTitle: '신용카드사'
			};
		} else if (sPopItem == 'CREDIT_CARD_G' ) {	//신용카드사
			rv = {
				xtype:'uniPopupColumn',		// Grid용 
			    textFieldName:'CREDIT_NAME_V',
			    DBtextFieldName: 'CREDIT_NAME',
			    api: 'popupService.creditCard',
			    app: 'Unilite.app.popup.CreditCard',
			    //popupPage: '/com/popup/bk/AgentCustPopup.do',
			    popupWidth:390,
			    popupHeight:400,
			    pageTitle: '신용카드사'
			};
		} else if (sPopItem == 'BIN' ) {

			rv = {
				xtype:'uniPopupField',
				fieldLabel : '부서',
			    valueFieldName:'BIN_NUM',
			    textFieldName:'BIN_NAME',
			    DBvalueFieldName: 'BIN_NUM',
			    DBtextFieldName: 'DOC_NAME',
			    api: 'popupService.binPopup',
			    app: 'Unilite.app.popup.BinPopup',
			    popupWidth:550,
			    popupHeight:400,
			    valueFieldWidth: 60,
			    textFieldWidth: 170,
			    pageTitle: '진열대번호'
			};
		} else if (sPopItem == 'BIN_G' ) {
		
			rv = {
				xtype: 'uniPopupColumn',
			    textFieldName:'BIN_NAME',
			    DBtextFieldName: 'DOC_NAME',
			    api: 'popupService.binPopup',
			    app: 'Unilite.app.popup.BinPopup',
			    popupWidth:550,
			    popupHeight:400,
			    pageTitle: '진열대번호'
			};
			
		} else if (sPopItem == 'POS' ) {

			rv = {
				xtype:'uniPopupField',
				fieldLabel : '부서',
			    valueFieldName:'POS_NO',
			    textFieldName:'POS_NAME',
			    DBvalueFieldName: 'POS_NO',
			    DBtextFieldName: 'POS_NAME',
			    api: 'popupService.posPopup',
			    app: 'Unilite.app.popup.PosPopup',
			    popupWidth:550,
			    popupHeight:400,
			    valueFieldWidth: 60,
			    textFieldWidth: 170,
			    pageTitle: '장비정보'
			};
		} else if (sPopItem == 'POS_G' ) {
		
			rv = {
				xtype: 'uniPopupColumn',
			    textFieldName:'POS_NO',
			    DBtextFieldName: 'POS_NAME',
			    api: 'popupService.posPopup',
			    app: 'Unilite.app.popup.PosPopup',
			    popupWidth:550,
			    popupHeight:400,
			    pageTitle: '장비정보'
			};
		} else if (sPopItem == 'ACCNT_DIV_CODE' ) {		//회계 - 사업장
			rv = {
				xtype:'uniPopupField', 
				fieldLabel : '사업장',
			    valueFieldName:'ACCNT_DIV_CODE',
			    textFieldName:'ACCNT_DIV_NAME',
			    DBvalueFieldName: 'ACCNT_DIV_CODE',
			    DBtextFieldName: 'ACCNT_DIV_NAME',
			    api: 'popupService.accntDivCodePopup',
                app: 'Unilite.app.popup.AccntDivCodePopup',
                valueFieldWidth: 60,
				textFieldWidth: 170,
				popupWidth:535,
			    popupHeight:400,
			    pageTitle: '사업장'
			};
		} else if (sPopItem == 'ACCNT_DIV_CODE_G' ) {	//회계 -  사업장그리드	
			rv = {
				xtype:'uniPopupColumn', 
			    textFieldName:'ACCNT_DIV_NAME',
			    DBtextFieldName: 'ACCNT_DIV_NAME',
			    api: 'popupService.accntDivCodePopup',
                app: 'Unilite.app.popup.AccntDivCodePopup',
			    pageTitle: '사업장'
			};
		} else if (sPopItem == 'ACCNT' ) {		//회계 - 계정과목
			rv = {
				xtype:'uniPopupField', 
				fieldLabel : '계정과목',
			    valueFieldName:'ACCNT_CODE',
			    textFieldName:'ACCNT_NAME',
			    DBvalueFieldName: 'ACCNT_CODE',
			    DBtextFieldName: 'ACCNT_NAME',
			    api: 'popupService.accntsPopup',
                app: 'Unilite.app.popup.AccntsPopup',
                valueFieldWidth: 60,
				textFieldWidth: 170,
				popupWidth:535,
			    popupHeight:400,
			    pageTitle: '계정과목'
			};
		} else if (sPopItem == 'ACCNT_G' ) {	//회계 - 계정과목그리드	
			rv = {
				xtype:'uniPopupColumn', 
			    textFieldName:'ACCNT_NAME',
			    DBtextFieldName: 'ACCNT_NAME',
			    api: 'popupService.accntsPopup',
                app: 'Unilite.app.popup.AccntsPopup',
			    pageTitle: '계정과목'
			};
		} else if (sPopItem == 'MANAGE' ) {		//회계 - 관리항목
			rv = {
				xtype:'uniPopupField', 
				fieldLabel : '관리항목',
			    valueFieldName:'MANAGE_CODE',
			    textFieldName:'MANAGE_NAME',
			    DBvalueFieldName: 'MANAGE_CODE',
			    DBtextFieldName: 'MANAGE_NAME',
			    api: 'popupService.managePopup',
                app: 'Unilite.app.popup.ManagePopup',
                valueFieldWidth: 60,
				textFieldWidth: 170,
				popupWidth:640,
			    popupHeight:400,
			    pageTitle: '관리항목'
			};
		} else if (sPopItem == 'MANAGE_G' ) {	//회계 - 관리항목 그리드	
			rv = {
				xtype:'uniPopupColumn', 
			    textFieldName:'MANAGE_NAME',
			    DBtextFieldName: 'MANAGE_NAME',
			    api: 'popupService.managePopup',
                app: 'Unilite.app.popup.ManagePopup',
			    pageTitle: '관리항목'
			};
		} else if (sPopItem == 'REMARK' ) {		//회계 - 적요
			rv = {
				xtype:'uniPopupField', 
				fieldLabel : '적요',
			    valueFieldName:'REMARK_CODE',
			    textFieldName:'REMARK_NAME',
			    DBvalueFieldName: 'REMARK_CODE',
			    DBtextFieldName: 'REMARK_NAME',
			    api: 'popupService.remarkPopup',
                app: 'Unilite.app.popup.RemarkPopup',
                valueFieldWidth: 60,
				textFieldWidth: 170,
				popupWidth:535,
			    popupHeight:400,
			    pageTitle: '적요'
			};
		} else if (sPopItem == 'REMARK_G' ) {	//회계 - 적요그리드	
			rv = {
				xtype:'uniPopupColumn', 
			    textFieldName:'REMARK_NAME',
			    DBtextFieldName: 'REMARK_NAME',
			    api: 'popupService.remarkPopup',
                app: 'Unilite.app.popup.RemarkPopup',
			    pageTitle: '적요'
			};
		} else if (sPopItem == 'COST' ) {		//회계 - 기간비용
			rv = {
				xtype:'uniPopupField', 
				fieldLabel : '기간비용',
			    valueFieldName:'COST_CODE',
			    textFieldName:'COST_NAME',
			    DBvalueFieldName: 'COST_CODE',
			    DBtextFieldName: 'COST_NAME',
			    api: 'popupService.costPopup',
                app: 'Unilite.app.popup.CostPopup',
                valueFieldWidth: 60,
				textFieldWidth: 170,
				popupWidth:535,
			    popupHeight:400,
			    pageTitle: '기간비용'
			};
		} else if (sPopItem == 'COST_G' ) {	//회계 - 기간비용 그리드	
			rv = {
				xtype:'uniPopupColumn', 
			    textFieldName:'COST_NAME',
			    DBtextFieldName: 'COST_NAME',
			    api: 'popupService.costPopup',
                app: 'Unilite.app.popup.CostPopup',
			    pageTitle: '기간비용'
			};
		} else if (sPopItem == 'ACCNT_PRSN' ) {		//회계 - 담당자
			rv = {
				xtype:'uniPopupField', 
				fieldLabel : '회계담당자',
			    valueFieldName:'PRSN_CODE',
			    textFieldName:'PRSN_NAME',
			    DBvalueFieldName: 'PRSN_CODE',
			    DBtextFieldName: 'PRSN_NAME',
			    api: 'popupService.accntPrsnPopup',
                app: 'Unilite.app.popup.AccntPrsnPopup',
                valueFieldWidth: 60,
				textFieldWidth: 170,
				popupWidth:535,
			    popupHeight:400,
			    pageTitle: '회계담당자'
			};
		} else if (sPopItem == 'ACCNT_PRSN_G' ) {	//회계 - 담당자 그리드	
			rv = {
				xtype:'uniPopupColumn', 
			    textFieldName:'PRSN_NAME',
			    DBtextFieldName: 'PRSN_NAME',
			    api: 'popupService.accntPrsnPopup',
                app: 'Unilite.app.popup.AccntPrsnPopup',
			    pageTitle: '회계담당자'
			};
		} else if (sPopItem == 'EXPENSE' ) {		//회계 - 경비코드
			rv = {
				xtype:'uniPopupField', 
				fieldLabel : '경비코드',
			    valueFieldName:'EXPENSE_CODE',
			    textFieldName:'EXPENSE_NAME',
			    DBvalueFieldName: 'EXPENSE_CODE',
			    DBtextFieldName: 'EXPENSE_NAME',
			    api: 'popupService.expensePopup',
                app: 'Unilite.app.popup.ExpensePopup',
                valueFieldWidth: 60,
				textFieldWidth: 170,
				popupWidth:535,
			    popupHeight:400,
			    pageTitle: '경비코드'
			};
		} else if (sPopItem == 'EXPENSE_G' ) {	//회계 - 경비코드	
			rv = {
				xtype:'uniPopupColumn', 
			    textFieldName:'EXPENSE_NAME',
			    DBtextFieldName: 'EXPENSE_NAME',
			    api: 'popupService.expensePopup',
                app: 'Unilite.app.popup.ExpensePopup',
			    pageTitle: '경비코드'
			};
		} else if (sPopItem == 'EARNER' ) {		//회계 - 소득자
			rv = {
				xtype:'uniPopupField', 
				fieldLabel : '소득자',
			    valueFieldName:'EARNER_CODE',
			    textFieldName:'EARNER_NAME',
			    DBvalueFieldName: 'EARNER_CODE',
			    DBtextFieldName: 'EARNER_NAME',
			    api: 'popupService.earnerPopup',
                app: 'Unilite.app.popup.EarnerPopup',
                valueFieldWidth: 60,
				textFieldWidth: 170,
				popupWidth:700,
			    popupHeight:500,
			    pageTitle: '소득자'
			};
		} else if (sPopItem == 'EARNER_G' ) {	//회계 - 소득자 그리드	
			rv = {
				xtype:'uniPopupColumn', 
			    textFieldName:'EARNER_NAME',
			    DBtextFieldName: 'EARNER_NAME',
			    api: 'popupService.earnerPopup',
                app: 'Unilite.app.popup.EarnerPopup',
			    pageTitle: '소득자'
			};
		} else if (sPopItem == 'REALTY' ) {		//회계 - 부동산
			rv = {
				xtype:'uniPopupField', 
				fieldLabel : '부동산',
			    valueFieldName:'REALTY_CODE',
			    textFieldName:'REALTY_NAME',
			    DBvalueFieldName: 'REALTY_CODE',
			    DBtextFieldName: 'REALTY_NAME',
			    api: 'popupService.realtyPopup',
                app: 'Unilite.app.popup.RealtyPopup',
                valueFieldWidth: 60,
				textFieldWidth: 170,
				popupWidth:670,
			    popupHeight:450,
			    pageTitle: '부동산'
			};
		} else if (sPopItem == 'REALTY_G' ) {	//회계 - 부동산그리드	
			rv = {
				xtype:'uniPopupColumn', 
			    textFieldName:'REALTY_NAME',
			    DBtextFieldName: 'REALTY_NAME',
			    api: 'popupService.realtyPopup',
                app: 'Unilite.app.popup.RealtyPopup',
			    pageTitle: '부동산'
			};
		} else if (sPopItem == 'ASSET' ) {		//회계 - 자산코드
			rv = {
				xtype:'uniPopupField', 
				fieldLabel : '자산코드',
			    valueFieldName:'ASSET_CODE',
			    textFieldName:'ASSET_NAME',
			    DBvalueFieldName: 'ASSET_CODE',
			    DBtextFieldName: 'ASSET_NAME',
			    api: 'popupService.assetPopup',
                app: 'Unilite.app.popup.AssetPopup',
                valueFieldWidth: 60,
				textFieldWidth: 170,
				popupWidth:670,
			    popupHeight:450,
			    pageTitle: '자산코드'
			};
		} else if (sPopItem == 'ASSET_G' ) {	//회계 - 자산코드 그리드	
			rv = {
				xtype:'uniPopupColumn', 
			    textFieldName:'ASSET_NAME',
			    DBtextFieldName: 'ASSET_NAME',
			    api: 'popupService.assetPopup',
                app: 'Unilite.app.popup.AssetPopup',
			    pageTitle: '자산코드'
			};
		} else if (sPopItem == 'COST_POOL' ) {		//회계 - Cost Pool
			rv = {
				xtype:'uniPopupField', 
				fieldLabel : 'Cost Pool',
			    valueFieldName:'COST_POOL_CODE',
			    textFieldName:'COST_POOL_NAME',
			    DBvalueFieldName: 'COST_POOL_CODE',
			    DBtextFieldName: 'COST_POOL_NAME',
			    api: 'popupService.costPoolPopup',
                app: 'Unilite.app.popup.CostPoolPopup',
                valueFieldWidth: 60,
				textFieldWidth: 170,
				popupWidth:670,
			    popupHeight:450,
			    pageTitle: 'Cost Pool'
			};
		} else if (sPopItem == 'COST_POOL_G' ) {	//회계 - Cost Pool그리드	
			rv = {
				xtype:'uniPopupColumn', 
			    textFieldName:'COST_POOL_NAME',
			    DBtextFieldName: 'COST_POOL_NAME',
			    api: 'popupService.costPoolPopup',
                app: 'Unilite.app.popup.CostPoolPopup',
			    pageTitle: 'Cost Pool'
			};
		} else if (sPopItem == 'UNIT' ) {		//회계 - 단위
			rv = {
				xtype:'uniPopupField', 
				fieldLabel : '단위',
			    valueFieldName:'UNIT_CODE',
			    textFieldName:'UNIT_NAME',
			    DBvalueFieldName: 'UNIT_CODE',
			    DBtextFieldName: 'UNIT_NAME',
			    api: 'popupService.unitPopup',
                app: 'Unilite.app.popup.UnitPopup',
                valueFieldWidth: 60,
				textFieldWidth: 170,
				popupWidth:535,
			    popupHeight:400,
			    pageTitle: '단위'
			};
		} else if (sPopItem == 'UNIT_G' ) {	//회계 - 단위그리드	
			rv = {
				xtype:'uniPopupColumn', 
			    textFieldName:'UNIT_NAME',
			    DBtextFieldName: 'UNIT_NAME',
			    api: 'popupService.unitPopup',
                app: 'Unilite.app.popup.UnitPopup',
			    pageTitle: '단위'
			};
		} else if (sPopItem == 'NOTE_TYPE' ) {		//회계 - 어음종류
			rv = {
				xtype:'uniPopupField', 
				fieldLabel : '어음종류',
			    valueFieldName:'NOTE_TYPE_CODE',
			    textFieldName:'NOTE_TYPE_NAME',
			    DBvalueFieldName: 'NOTE_TYPE_CODE',
			    DBtextFieldName: 'NOTE_TYPE_NAME',
			    api: 'popupService.noteTypePopup',
                app: 'Unilite.app.popup.NoteTypePopup',
                valueFieldWidth: 60,
				textFieldWidth: 170,
				popupWidth:535,
			    popupHeight:400,
			    pageTitle: '어음종류'
			};
		} else if (sPopItem == 'NOTE_TYPE_G' ) {	//회계 -  어음종류 그리드	
			rv = {
				xtype:'uniPopupColumn', 
			    textFieldName:'NOTE_TYPE_NAME',
			    DBtextFieldName: 'NOTE_TYPE_NAME',
			    api: 'popupService.noteTypePopup',
                app: 'Unilite.app.popup.NoteTypePopup',
			    pageTitle: '어음종류'
			};
		} else if (sPopItem == 'NOTE_NUM' ) {		//회계 - 어음번호
			rv = {
				xtype:'uniPopupField', 
				fieldLabel : '어음번호',
			    valueFieldName:'NOTE_NUM_CODE',
			    textFieldName:'NOTE_NUM_NAME',
			    DBvalueFieldName: 'NOTE_NUM_CODE',
			    DBtextFieldName: 'NOTE_NUM_NAME',
			    api: 'popupService.noteNumPopup',
                app: 'Unilite.app.popup.NoteNumPopup',
                valueFieldWidth: 90,
				textFieldWidth: 140,
				popupWidth:670,
			    popupHeight:450,
			    pageTitle: '어음번호'
			};
		} else if (sPopItem == 'NOTE_NUM_G' ) {	//회계 -  어음번호그리드	
			rv = {
				xtype:'uniPopupColumn', 
			    textFieldName:'NOTE_NUM_NAME',
			    DBtextFieldName: 'NOTE_NUM_NAME',
			    api: 'popupService.noteNumPopup',
                app: 'Unilite.app.popup.NoteNumPopup',
			    pageTitle: '어음번호'
			};
		} else if (sPopItem == 'CHECK_NUM' ) {		//회계 - 수표번호
			rv = {
				xtype:'uniPopupField', 
				fieldLabel : '수표번호',
			    valueFieldName:'CHECK_NUM_CODE',
			    textFieldName:'CHECK_NUM_NAME',
			    DBvalueFieldName: 'CHECK_NUM_CODE',
			    DBtextFieldName: 'CHECK_NUM_NAME',
			    api: 'popupService.checkNumPopup',
                app: 'Unilite.app.popup.CheckNumPopup',
                valueFieldWidth: 90,
				textFieldWidth: 140,
				popupWidth:670,
			    popupHeight:450,
			    pageTitle: '수표번호'
			};
		} else if (sPopItem == 'CHECK_NUM_G' ) {	//회계 -  수표번호 그리드	
			rv = {
				xtype:'uniPopupColumn', 
			    textFieldName:'CHECK_NUM_NAME',
			    DBtextFieldName: 'CHECK_NUM_NAME',
			    api: 'popupService.checkNumPopup',
                app: 'Unilite.app.popup.CheckNumPopup',
			    pageTitle: '수표번호'
			};
		} else if (sPopItem == 'MONEY' ) {		//회계 - 화폐단위
			rv = {
				xtype:'uniPopupField', 
				fieldLabel : '화폐단위',
			    valueFieldName:'MONEY_CODE',
			    textFieldName:'MONEY_NAME',
			    DBvalueFieldName: 'MONEY_CODE',
			    DBtextFieldName: 'MONEY_NAME',
			    api: 'popupService.moneyPopup',
                app: 'Unilite.app.popup.MoneyPopup',
                valueFieldWidth: 60,
				textFieldWidth: 170,
				popupWidth:535,
			    popupHeight:400,
			    pageTitle: '화폐단위'
			};
		} else if (sPopItem == 'MONEY_G' ) {	//회계 - 화폐단위 그리드	
			rv = {
				xtype:'uniPopupColumn', 
			    textFieldName:'MONEY_NAME',
			    DBtextFieldName: 'MONEY_NAME',
			    api: 'popupService.moneyPopup',
                app: 'Unilite.app.popup.MoneyPopup',
			    pageTitle: '화폐단위'
			};
		} else if (sPopItem == 'EX_LCNO' ) {		//회계 - L/C번호(수출)
			rv = {
				xtype:'uniPopupField', 
				fieldLabel : 'L/C번호(수출)',
			    valueFieldName:'EX_LCNO_CODE',
			    textFieldName:'EX_LCNO_NAME',
			    DBvalueFieldName: 'EX_LCNO_CODE',
			    DBtextFieldName: 'EX_LCNO_NAME',
			    api: 'popupService.exLcnoPopup',
                app: 'Unilite.app.popup.ExLcnoPopup',
                valueFieldWidth: 90,
				textFieldWidth: 140,
				popupWidth:670,
			    popupHeight:450,
			    pageTitle: 'L/C번호(수출)'
			};
		} else if (sPopItem == 'EX_LCNO_G' ) {	//회계 -  L/C번호(수출) 그리드	
			rv = {
				xtype:'uniPopupColumn', 
			    textFieldName:'EX_LCNO_NAME',
			    DBtextFieldName: 'EX_LCNO_NAME',
			    api: 'popupService.exLcnoPopup',
                app: 'Unilite.app.popup.ExLcnoPopup',
			    pageTitle: 'L/C번호(수출)'
			};
		} else if (sPopItem == 'IN_LCNO' ) {		//회계 - L/C번호(수입)
			rv = {
				xtype:'uniPopupField', 
				fieldLabel : 'L/C번호(수입)',
			    valueFieldName:'IN_LCNO_CODE',
			    textFieldName:'IN_LCNO_NAME',
			    DBvalueFieldName: 'IN_LCNO_CODE',
			    DBtextFieldName: 'IN_LCNO_NAME',
			    api: 'popupService.inLcnoPopup',
                app: 'Unilite.app.popup.InLcnoPopup',
                valueFieldWidth: 90,
				textFieldWidth: 140,
				popupWidth:670,
			    popupHeight:450,
			    pageTitle: 'L/C번호(수입)'
			};
		} else if (sPopItem == 'IN_LCNO_G' ) {	//회계 -  L/C번호(수입)그리드	
			rv = {
				xtype:'uniPopupColumn', 
			    textFieldName:'IN_LCNO_NAME',
			    DBtextFieldName: 'IN_LCNO_NAME',
			    api: 'popupService.inLcnoPopup',
                app: 'Unilite.app.popup.InLcnoPopup',
			    pageTitle: 'L/C번호(수입)'
			};
		} else if (sPopItem == 'EX_BLNO' ) {		//회계 - B/L번호(수출)
			rv = {
				xtype:'uniPopupField', 
				fieldLabel : 'B/L번호(수출)',
			    valueFieldName:'EX_BLNO_CODE',
			    textFieldName:'EX_BLNO_NAME',
			    DBvalueFieldName: 'EX_BLNO_CODE',
			    DBtextFieldName: 'EX_BLNO_NAME',
			    api: 'popupService.exBlnoPopup',
                app: 'Unilite.app.popup.ExBlnoPopup',
                valueFieldWidth: 90,
				textFieldWidth: 140,
				popupWidth:670,
			    popupHeight:450,
			    pageTitle: 'B/L번호(수출)'
			};
		} else if (sPopItem == 'EX_BLNO_G' ) {	//회계 -  B/L번호(수출) 그리드	
			rv = {
				xtype:'uniPopupColumn', 
			    textFieldName:'EX_BLNO_NAME',
			    DBtextFieldName: 'EX_BLNO_NAME',
			    api: 'popupService.exBlnoPopup',
                app: 'Unilite.app.popup.ExBlnoPopup',
			    pageTitle: 'B/L번호(수출)'
			};
		} else if (sPopItem == 'IN_BLNO' ) {		//회계 - B/L번호(수입)
			rv = {
				xtype:'uniPopupField', 
				fieldLabel : 'B/L번호(수입)',
			    valueFieldName:'IN_BLNO_CODE',
			    textFieldName:'IN_BLNO_NAME',
			    DBvalueFieldName: 'IN_BLNO_CODE',
			    DBtextFieldName: 'IN_BLNO_NAME',
			    api: 'popupService.inBlnoPopup',
                app: 'Unilite.app.popup.InBlnoPopup',
                valueFieldWidth: 90,
				textFieldWidth: 140,
				popupWidth:670,
			    popupHeight:450,
			    pageTitle: 'B/L번호(수입)'
			};
		} else if (sPopItem == 'IN_BLNO_G' ) {	//회계 -  B/L번호(수입)그리드	
			rv = {
				xtype:'uniPopupColumn', 
			    textFieldName:'IN_BLNO_NAME',
			    DBtextFieldName: 'IN_BLNO_NAME',
			    api: 'popupService.inBlnoPopup',
                app: 'Unilite.app.popup.InBlnoPopup',
			    pageTitle: 'B/L번호(수입)'
			};
		} else if (sPopItem == 'AC_PROJECT' ) {		//회계 - 프로젝트
			rv = {
				xtype:'uniPopupField', 
				fieldLabel : '프로젝트',
			    valueFieldName:'AC_PROJECT_CODE',
			    textFieldName:'AC_PROJECT_NAME',
			    DBvalueFieldName: 'AC_PROJECT_CODE',
			    DBtextFieldName: 'AC_PROJECT_NAME',
			    api: 'popupService.acProjectPopup',
                app: 'Unilite.app.popup.AcProjectPopup',
                valueFieldWidth: 60,
				textFieldWidth: 170,
				popupWidth:670,
			    popupHeight:450,
			    pageTitle: '프로젝트'
			};
		} else if (sPopItem == 'AC_PROJECT_G' ) {	//회계 -  프로젝트 그리드	
			rv = {
				xtype:'uniPopupColumn', 
			    textFieldName:'AC_PROJECT_NAME',
			    DBtextFieldName: 'AC_PROJECT_NAME',
			    api: 'popupService.acProjectPopup',
                app: 'Unilite.app.popup.AcProjectPopup',
			    pageTitle: '프로젝트'
			};
		} else if (sPopItem == 'FUND' ) {		//회계 - 자금항목
			rv = {
				xtype:'uniPopupField', 
				fieldLabel : '자금항목',
			    valueFieldName:'FUND_CODE',
			    textFieldName:'FUND_NAME',
			    DBvalueFieldName: 'FUND_CODE',
			    DBtextFieldName: 'FUND_NAME',
			    api: 'popupService.fundPopup',
                app: 'Unilite.app.popup.FundPopup',
                valueFieldWidth: 60,
				textFieldWidth: 170,
				popupWidth:670,
			    popupHeight:450,
			    pageTitle: '자금항목'
			};
		} else if (sPopItem == 'FUND_G' ) {	//회계 -  자금항목 그리드	
			rv = {
				xtype:'uniPopupColumn', 
			    textFieldName:'FUND_NAME',
			    DBtextFieldName: 'FUND_NAME',
			    api: 'popupService.fundPopup',
                app: 'Unilite.app.popup.FundPopup',
			    pageTitle: '자금항목'
			};
		} else if (sPopItem == 'CREDIT_NO' ) {		//회계 - 신용카드번호
			rv = {
				xtype:'uniPopupField', 
				fieldLabel : '신용카드번호',
			    valueFieldName:'CREDIT_NO_CODE',
			    textFieldName:'CREDIT_NO_NAME',
			    DBvalueFieldName: 'CREDIT_NO_CODE',
			    DBtextFieldName: 'CREDIT_NO_NAME',
			    api: 'popupService.creditNoPopup',
                app: 'Unilite.app.popup.CreditNoPopup',
                valueFieldWidth: 60,
				textFieldWidth: 170,
				popupWidth:670,
			    popupHeight:450,
			    pageTitle: '신용카드번호'
			};
		} else if (sPopItem == 'CREDIT_CARD_G' ) {	//회계 -  신용카드번호 그리드	
			rv = {
				xtype:'uniPopupColumn', 
			    textFieldName:'CREDIT_CARD_NAME',
			    DBtextFieldName: 'CREDIT_CARD_NAME',
			    api: 'popupService.creditCardPopup',
                app: 'Unilite.app.popup.CreditCardPopup',
			    pageTitle: '신용카드번호'
			};
		} else if (sPopItem == 'PUR_SALE_TYPE' ) {		//회계 - 매입매출구분
			rv = {
				xtype:'uniPopupField', 
				fieldLabel : '매입매출구분',
			    valueFieldName:'PUR_SALE_TYPE_CODE',
			    textFieldName:'PUR_SALE_TYPE_NAME',
			    DBvalueFieldName: 'PUR_SALE_TYPE_CODE',
			    DBtextFieldName: 'PUR_SALE_TYPE_NAME',
			    api: 'popupService.purSaleTypePopup',
                app: 'Unilite.app.popup.PurSaleTypePopup',
                valueFieldWidth: 60,
				textFieldWidth: 170,
				popupWidth:535,
			    popupHeight:400,
			    pageTitle: '매입매출구분'
			};
		} else if (sPopItem == 'PUR_SALE_TYPE_G' ) {	//회계 -  매입매출구분 그리드	
			rv = {
				xtype:'uniPopupColumn', 
			    textFieldName:'PUR_SALE_TYPE_NAME',
			    DBtextFieldName: 'PUR_SALE_TYPE_NAME',
			    api: 'popupService.purSaleTypePopup',
                app: 'Unilite.app.popup.PurSaleTypePopup',
			    pageTitle: '매입매출구분'
			};
		} else if (sPopItem == 'PROOF' ) {		//회계 - 증빙유형
			rv = {
				xtype:'uniPopupField', 
				fieldLabel : '증빙유형',
			    valueFieldName:'PROOF_CODE',
			    textFieldName:'PROOF_NAME',
			    DBvalueFieldName: 'PROOF_CODE',
			    DBtextFieldName: 'PROOF_NAME',
			    api: 'popupService.proofPopup',
                app: 'Unilite.app.popup.ProofPopup',
                valueFieldWidth: 60,
				textFieldWidth: 170,
				popupWidth:535,
			    popupHeight:400,
			    pageTitle: '증빙유형'
			};
		} else if (sPopItem == 'PROOF_G' ) {	//회계 -  증빙유형 그리드	
			rv = {
				xtype:'uniPopupColumn', 
			    textFieldName:'PROOF_NAME',
			    DBtextFieldName: 'PROOF_NAME',
			    api: 'popupService.proofPopup',
                app: 'Unilite.app.popup.ProofPopup',
			    pageTitle: '증빙유형'
			};
		} else if (sPopItem == 'EMISSION' ) {		//회계 - 전자발행여부
			rv = {
				xtype:'uniPopupField', 
				fieldLabel : '전자발행여부',
			    valueFieldName:'EMISSION_CODE',
			    textFieldName:'EMISSION_NAME',
			    DBvalueFieldName: 'EMISSION_CODE',
			    DBtextFieldName: 'EMISSION_NAME',
			    api: 'popupService.emissionPopup',
                app: 'Unilite.app.popup.EmissionPopup',
                valueFieldWidth: 60,
				textFieldWidth: 170,
				popupWidth:535,
			    popupHeight:400,
			    pageTitle: '전자발행여부'
			};
		} else if (sPopItem == 'EMISSION_G' ) {	//회계 - 전자발행여부 그리드	
			rv = {
				xtype:'uniPopupColumn', 
			    textFieldName:'EMISSION_NAME',
			    DBtextFieldName: 'EMISSION_NAME',
			    api: 'popupService.emissionPopup',
                app: 'Unilite.app.popup.EmissionPopup',
			    pageTitle: '전자발행여부'
			};
		} else if (sPopItem == 'BANK_BOOK' ) {		//회계 - 통장번호
			rv = {
				xtype:'uniPopupField', 
				fieldLabel : '통장번호',
			    valueFieldName:'BANK_BOOK_CODE',
			    textFieldName:'BANK_BOOK_NAME',
			    DBvalueFieldName: 'BANK_BOOK_CODE',
			    DBtextFieldName: 'BANK_BOOK_NAME',
			    api: 'popupService.bankBookPopup',
                app: 'Unilite.app.popup.BankBookPopup',
                valueFieldWidth: 60,
				textFieldWidth: 170,
				popupWidth:670,
			    popupHeight:450,
			    pageTitle: '통장번호'
			};
		} else if (sPopItem == 'BANK_BOOK_G' ) {	//회계 -  통장번호 그리드	
			rv = {
				xtype:'uniPopupColumn', 
			    textFieldName:'BANK_BOOK_NAME',
			    DBtextFieldName: 'BANK_BOOK_NAME',
			    api: 'popupService.bankBookPopup',
                app: 'Unilite.app.popup.BankBookPopup',
			    pageTitle: '통장번호'
			};
		} else if (sPopItem == 'DEBT_NO' ) {		//회계 - 차입금번호
			rv = {
				xtype:'uniPopupField', 
				fieldLabel : '차입금번호',
			    valueFieldName:'DEBT_NO_CODE',
			    textFieldName:'DEBT_NO_NAME',
			    DBvalueFieldName: 'DEBT_NO_CODE',
			    DBtextFieldName: 'DEBT_NO_NAME',
			    api: 'popupService.debtNoPopup',
                app: 'Unilite.app.popup.DebtNoPopup',
                valueFieldWidth: 60,
				textFieldWidth: 170,
				popupWidth:670,
			    popupHeight:450,
			    pageTitle: '차입금번호'
			};
		} else if (sPopItem == 'DEBT_NO_G' ) {	//회계 -  차입금번호 그리드	
			rv = {
				xtype:'uniPopupColumn', 
			    textFieldName:'DEBT_NO_NAME',
			    DBtextFieldName: 'DEBT_NO_NAME',
			    api: 'popupService.debtNoPopup',
                app: 'Unilite.app.popup.DebtNoPopup',
			    pageTitle: '차입금번호'
			};
		} else if (sPopItem == 'CAR_NUM' ) {		//회계 - 차량번호
			rv = {
				xtype:'uniPopupField', 
				fieldLabel : '차량번호',
			    valueFieldName:'CAR_NUM_CODE',
			    textFieldName:'CAR_NUM_NAME',
			    DBvalueFieldName: 'CAR_NUM_CODE',
			    DBtextFieldName: 'CAR_NUM_NAME',
			    api: 'popupService.carNumPopup',
                app: 'Unilite.app.popup.CarNumPopup',
                valueFieldWidth: 60,
				textFieldWidth: 170,
				popupWidth:670,
			    popupHeight:450,
			    pageTitle: '차량번호'
			};
		} else if (sPopItem == 'CAR_NUM_G' ) {	//회계 -  차량번호 그리드	
			rv = {
				xtype:'uniPopupColumn', 
			    textFieldName:'CAR_NUM_NAME',
			    DBtextFieldName: 'CAR_NUM_NAME',
			    api: 'popupService.carNumPopup',
                app: 'Unilite.app.popup.CarNumPopup',
			    pageTitle: '차량번호'
			};
		}		
		
       // console.log("BEFORE", rv.allowBlank, config.allowBlank)
		if (config) {
            rv = Ext.apply(rv, config);
            console.log('uniPopup Config : ', config);
            console.log('uniPopup rv : ', rv);
        }
        //console.log("AFTER", rv.allowBlank, config)
		return rv;
				
	},
	
	popupGridConfig: function(param, callback, scope) {
		var app = "Unilite.app.popup.GridConfigPopup";
    	var fn = function() {	                            		
            var oWin =  Ext.WindowMgr.get(app);
            if(!oWin) {
                oWin = Ext.create( app, {
                        //id: 'GridConfigPopup', 
                        callBackFn: callback, 
                        callBackScope: scope, 
                        width: 800,
                        height: 550,
                        title: 'Grid 설정',
                        param: param
                 });
            }
            oWin.fnInitBinding(param);
            oWin.center();
            oWin.show();
        };
        Unilite.require(app, fn, this, true);
	}
}) 