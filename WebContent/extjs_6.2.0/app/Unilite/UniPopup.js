//@charset UTF-8
/**@class Unilite
 * Popup 접근을 쉽게 하기 위한 함수 모음.
 */
Ext.apply(Unilite,{
	/**## popup 설정 생성 함수.
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
	_setUseYn: function() {
		var r = '';
//		console.log('PGM_ID.indexOf("ukr") : ', PGM_ID.indexOf("ukr"));
		if(Ext.isDefined(PGM_ID)) {
			if(PGM_ID.indexOf("ukr")==6) {
				r = 'Y'
			}
		}
		return r;
	},

	popup: function(sPopItem, config ) {
		var rv={} ;

		if (sPopItem == 'WKORD_NUM' ) {		// 작업지시정보
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
		} else if (sPopItem == 'WKORD_NUM_G' ) {	// 작업지시정보_G
			rv = {
				xtype:'uniPopupColumn',		// Grid용
				textFieldName:'WKORD_NUM',
				DBtextFieldName: 'WKORD_NUM',
				api: 'popupService.wkordNum',
				app: 'Unilite.app.popup.WkordNum',
				//popupPage: '/com/popup/bk/CustPopup.do',
				pageTitle: '작업지시정보'
			};
		} else if (sPopItem == 'BU_CODE_POPUP' ) {	// 원천부표코드
			rv = {
				xtype:'uniPopupField', // 일반 Form용
				fieldLabel : '부표코드',
				valueFieldName:'BU_CODE',
				textFieldName:'BU_NAME',
				DBvalueFieldName: 'BU_CODE',
				DBtextFieldName: 'BU_NAME',
				api: 'popupService.buCodePopup',
				app: 'Unilite.app.popup.BuCodePopup',
				//popupPage: '/com/popup/bk/CustPopup.do',
				valueFieldWidth: 60,
				textFieldWidth: 170,
				popupWidth: 900,
				pageTitle: '부표코드'
			};
		} else if (sPopItem == 'BU_CODE_POPUP_G' ) {	// 원천부표코드_G
			rv = {
				xtype:'uniPopupColumn',		// Grid용
				textFieldName:'BU_NAME',
				DBtextFieldName: 'BU_NAME',
				api: 'popupService.buCodePopup',
				app: 'Unilite.app.popup.BuCodePopup',
				//popupPage: '/com/popup/bk/CustPopup.do',
				popupWidth: 900,
				pageTitle: '부표코드'
			};
		} else if (sPopItem == 'BUSS_OFFICE_CODE' ) { 	// 지점정보
			rv = {
				xtype:'uniPopupField', // 일반 Form용
				fieldLabel : '소속지점',
				valueFieldName:'BUSS_OFFICE_CODE',
				textFieldName:'BUSS_OFFICE_NAME',
				DBvalueFieldName: 'BUSS_OFFICE_CODE',
				DBtextFieldName: 'BUSS_OFFICE_NAME',
				api: 'popupService.bussOfficeCode',
				app: 'Unilite.app.popup.BussOfficeCode',
				//popupPage: '/com/popup/bk/CustPopup.do',
				valueFieldWidth: 60,
				textFieldWidth: 170,
				pageTitle: '지점정보'
			};
		} else if (sPopItem == 'BUSS_OFFICE_CODE_G' ) {	// 지점정보_그리드
			rv = {
				xtype:'uniPopupColumn',		// Grid용
				textFieldName:'BUSS_OFFICE_NAME',
				DBtextFieldName: 'BUSS_OFFICE_NAME',
				api: 'popupService.bussOfficeCode',
				app: 'Unilite.app.popup.BussOfficeCode',
				//popupPage: '/com/popup/bk/CustPopup.do',
				pageTitle: '지점정보'
			};
		} else if (sPopItem == 'SAUP_POPUP' ) { 	// 사업소득자 공통코드
			rv = {
				xtype:'uniPopupField', // 일반 Form용
				fieldLabel : '소득구분',
				valueFieldName:'SAUP_POPUP_CODE',
				textFieldName:'SAUP_POPUP_NAME',
				DBvalueFieldName: 'SAUP_POPUP_CODE',
				DBtextFieldName: 'SAUP_POPUP_NAME',
				api: 'popupService.saupPopupCode',
				app: 'Unilite.app.popup.SaupPopupCode',
				//popupPage: '/com/popup/bk/CustPopup.do',
				valueFieldWidth: 60,
				textFieldWidth: 170,
				popupWidth: 900,
				pageTitle: '소득구분'
			};
		} else if (sPopItem == 'SAUP_POPUP_SINGLE' ) { 	// 사업소득자 공통코드_Single
			rv = {
				xtype:'uniPopupField', // 일반 Form용
				fieldLabel : '소득구분',
				textFieldOnly: true,  // code만 사용
				//valueFieldName:'SAUP_POPUP_CODE',
				textFieldName:'SAUP_POPUP_CODE',
				//DBvalueFieldName: 'SAUP_POPUP_CODE',
				DBtextFieldName: 'SAUP_POPUP_CODE',
				api: 'popupService.saupPopupCode',
				app: 'Unilite.app.popup.SaupPopupCode',
				//popupPage: '/com/popup/bk/CustPopup.do',
				valueFieldWidth: 60,
				textFieldWidth: 170,
				popupWidth: 900,
				pageTitle: '소득구분'
			};
		} else if (sPopItem == 'SAUP_POPUP_G' ) {	// 사업소득자 공통코드_G
			rv = {
				xtype:'uniPopupColumn',		// Grid용
				textFieldName:'SAUP_POPUP_NAME',
				DBtextFieldName: 'SAUP_POPUP_NAME',
				api: 'popupService.saupPopupCode',
				app: 'Unilite.app.popup.SaupPopupCode',
				//popupPage: '/com/popup/bk/CustPopup.do',
				popupWidth: 900,
				pageTitle: '소득구분'
			};
		} else if (sPopItem == 'PRIZE_POPUP' ) { 	  // 금융상품코드  (2012년 이전 까지 사용)
			rv = {
				xtype:'uniPopupField', // 일반 Form용
				fieldLabel : '금융상품코드',
				valueFieldName:'PRIZE_POPUP_CODE',
				textFieldName:'PRIZE_POPUP_NAME',
				DBvalueFieldName: 'PRIZE_POPUP_CODE',
				DBtextFieldName: 'PRIZE_POPUP_NAME',
				api: 'popupService.prizePopup',
				app: 'Unilite.app.popup.PrizePopup',
				//popupPage: '/com/popup/bk/CustPopup.do',
				valueFieldWidth: 60,
				textFieldWidth: 170,
				popupWidth: 900,
				pageTitle: '금융상품코드'
			};
		} else if (sPopItem == 'PRIZE_POPUP_G' ) {	// 금융상품코드_G (2012년 부터 사용)
			rv = {
				xtype:'uniPopupColumn',		// Grid용
				textFieldName:'PRIZE_POPUP_NAME',
				DBtextFieldName: 'PRIZE_POPUP_NAME',
				api: 'popupService.prizePopup',
				app: 'Unilite.app.popup.PrizePopup',
				//popupPage: '/com/popup/bk/CustPopup.do',
				popupWidth: 900,
				pageTitle: '금융상품코드'
			};
		} else if (sPopItem == 'PROG_WORK_CODE' ) { 		// 공정정보
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
		} else if (sPopItem == 'PROG_WORK_CODE_G' ) {	// 공정정보
			rv = {
				xtype:'uniPopupColumn',		// Grid용
				textFieldName:'PROG_WORK_NAME',
				DBtextFieldName: 'PROG_WORK_NAME',
				api: 'popupService.progWorkCode',
				app: 'Unilite.app.popup.ProgWorkCode',
				//popupPage: '/com/popup/bk/CustPopup.do',
				pageTitle: '공정정보'
			};
		} else if (sPopItem == 'EQUIP_CODE' ) {	   // 설비정보_극동
			rv = {
				xtype:'uniPopupField', // 일반 Form용
				fieldLabel : '설비정보',
				valueFieldName:'EQUIP_CODE',
				textFieldName:'EQUIP_NAME',
				DBvalueFieldName: 'EQUIP_CODE',
				DBtextFieldName: 'EQUIP_NAME',
				api: 'popupService.equipCode',
				app: 'Unilite.app.popup.EquipCode',
				//popupPage: '/com/popup/bk/CustPopup.do',
				valueFieldWidth: 60,
				textFieldWidth: 170,
				pageTitle: '설비정보'
			};
		} else if (sPopItem == 'EQUIP_CODE_G' ) {	// 설비정보_극동
			rv = {
				xtype:'uniPopupColumn',	 // Grid용
				textFieldName:'EQUIP_NAME',
				DBtextFieldName: 'EQUIP_NAME',
				api: 'popupService.equipCode',
				app: 'Unilite.app.popup.EquipCode',
				//popupPage: '/com/popup/bk/CustPopup.do',
				pageTitle: '설비정보'
			};
		} else if (sPopItem == 'MOLD_CODE' ) {	   // 금형정보_극동
			rv = {
				xtype:'uniPopupField', // 일반 Form용
				fieldLabel : '금형정보',
				valueFieldName:'MOLD_CODE',
				textFieldName:'MOLD_NAME',
				DBvalueFieldName: 'MOLD_CODE',
				DBtextFieldName: 'MOLD_NAME',
				api: 'popupService.moldCode',
				app: 'Unilite.app.popup.MoldCode',
				//popupPage: '/com/popup/bk/CustPopup.do',
				valueFieldWidth: 60,
				textFieldWidth: 170,
				pageTitle: '금형정보'
			};
		} else if (sPopItem == 'MOLD_CODE_G' ) {	// 금형정보_극동
			rv = {
				xtype:'uniPopupColumn',	 // Grid용
				textFieldName:'MOLD_NAME',
				DBtextFieldName: 'MOLD_NAME',
				api: 'popupService.moldCode',
				app: 'Unilite.app.popup.MoldCode',
				//popupPage: '/com/popup/bk/CustPopup.do',
				pageTitle: '금형정보'
			};
		} else if (sPopItem == 'OUTSTOCK_NUM' ) { 		// 출고요청번호
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
		} else if (sPopItem == 'CREDIT_CARD2' ) { 		// 신용카드
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
		} else if (sPopItem == 'CREDIT_CARD2_G' ) {	// 신용카드
			rv = {
				xtype:'uniPopupColumn',		// Grid용
				textFieldName:'CRDT_NAME',
				DBtextFieldName: 'CRDT_NAME',
				api: 'popupService.creditCard2',
				app: 'Unilite.app.popup.CreditCard2',
				//popupPage: '/com/popup/bk/CustPopup.do',
				pageTitle: '신용카드'
			};
		} else if (sPopItem == 'CREDIT_NO_J' ) {	 //JOINS - 신용카드번호
			rv = {
				xtype:'uniPopupField',
				fieldLabel : '신용카드번호',
				valueFieldName:'CRDT_FULL_NUM_EXPOS',
				textFieldName:'CREDIT_NO_NAME',
				DBvalueFieldName: 'CRDT_FULL_NUM_EXPOS',
				DBtextFieldName: 'CREDIT_NO_NAME',
				api: 'popupService.creditNoPopupJ',
				app: 'Unilite.app.popup.CreditNoPopupJ',
				valueFieldWidth: 90,
				textFieldWidth: 140,
				popupWidth:699,
				popupHeight:446,
				pageTitle: '신용카드번호'
			};
		} else if (sPopItem == 'CREDIT_NO_J_G' ) {		//JOINS - 신용카드번호
			rv = {
				xtype:'uniPopupColumn',
				fieldLabel : '신용카드번호',
				textFieldName:'CREDIT_NO_NAME',
				DBtextFieldName: 'CREDIT_NO_NAME',
				api: 'popupService.creditNoPopupJ',
				app: 'Unilite.app.popup.CreditNoPopupJ',
				valueFieldWidth: 90,
				textFieldWidth: 140,
				popupWidth:699,
				popupHeight:446,
				pageTitle: '신용카드번호'
			};
		} else if (sPopItem == 'CUST' ) { 		// 거래처
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
				valueFieldWidth: 90,
				textFieldWidth: 140,
				pageTitle: '거래처정보'
			};
		} else if (sPopItem == 'CUST_G' ) {	// 거래처 그리드용
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
		} else if (sPopItem == 'AGENT_CUST' ) { 	// 거래처
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
				valueFieldWidth: 90,
				textFieldWidth: 140,
				pageTitle: '거래처정보'
			};
		} else if (sPopItem == 'AGENT_CUST_G' ) {	// 거래처 그리드용
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
				valueFieldWidth: 90,
				textFieldWidth: 140,
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
		} else if (sPopItem == 'CUST_SINGLE' ) { 		// 거래처 1칸짜리 폼(사업자번호)용..agd131ukrv적용
			rv = {
				xtype:'uniPopupField', // 일반 Form용
				fieldLabel : '사업자번호',
				textFieldOnly: true,
				valueFieldName:'CUSTOM_CODE',
				textFieldName:'COMPANY_NUM',
				DBvalueFieldName: 'CUSTOM_CODE',
				DBtextFieldName: 'COMPANY_NUM',
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
		} else if (sPopItem == 'AGENT_CUST_MULTI_G' ) {	// 거래처 그리드용 MULTI
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
				popupWidth:400,
				popupHeight:500,
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
				popupHeight:570,
				valueFieldWidth: 60,
				textFieldWidth: 170,
				textFieldStyle: 'text-align:center;',
				pageTitle: '우편번호'
			};
		} else if (sPopItem == 'ZIP_TEST' ) {
			rv = {
				xtype:'uniPopupField',
				fieldLabel : '전자결재',
				valueFieldName:'ZIP',
				textFieldName:'ZIP_CODE',
				DBvalueFieldName: 'ZIP_CODE',
				DBtextFieldName: 'ZIP_NAME',
				api: '',//'popupService.zipPopup',
				app: 'Unilite.app.popup.ZipPopupTest',
				//popupPage: '/com/popup/bk/ZipPopup.do',
				popupWidth:880,
				popupHeight:800,
				valueFieldWidth: 60,
				textFieldWidth: 170,
				textFieldStyle: 'text-align:center;',
				pageTitle: '전자결재'
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
				popupHeight:565,
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
				popupWidth:650,
				popupHeight:400,
				pageTitle: '사용자 ID'
			};
		} else if (sPopItem == 'USER_NOCOMP' ) {
			rv = {
				xtype:'uniPopupField',
				fieldLabel : '사용자',
				valueFieldName:'USER_ID',
				textFieldName:'USER_NAME',
				DBvalueFieldName: 'USER_ID',
				DBtextFieldName: 'USER_NAME',
				api: 'popupService.userNoCompPopup',
				app: 'Unilite.app.popup.UserNoCompPopup',
				//popupPage: '/com/popup/bk/UserPopup.do',
				popupWidth:650,
				popupHeight:400,
				valueFieldWidth: 60,
				textFieldWidth: 170,
				pageTitle: '사용자 ID'
			};
		} else if (sPopItem == 'USER_NOCOMP_G' ) {
			rv = {
				xtype:'uniPopupColumn',
				textFieldName:'USER_NAME',
				DBtextFieldName: 'USER_NAME',
				api: 'popupService.userNoCompPopup',
				app: 'Unilite.app.popup.UserNoCompPopup',
				//popupPage: '/com/popup/bk/UserPopup.do',
				popupWidth:650,
				popupHeight:400,
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
				popupWidth:660,
				popupHeight:490,
				valueFieldWidth: 90,
				textFieldWidth: 140,
				pageTitle: '사원조회 POPUP',
				extParam:{useBasicInfo:false}// 성명, 사번, 직위, 부서필드만 사용할 경우  false
			};
		} else if (sPopItem == 'Employee_G' ) {
			rv = {
				xtype:'uniPopupColumn',
				textFieldName:'NAME',
				DBtextFieldName: 'NAME',
				api: 'popupService.employeePopup',
				app: 'Unilite.app.popup.EmployeePopup',
				//popupPage: '/com/popup/bk/EmployeePopup.do',
				popupWidth:660,
				popupHeight:490,
				pageTitle: '사원조회 POPUP'
			};
		} else if (sPopItem == 'Employee_G1' ) {
			rv = {
				xtype:'uniPopupColumn',
				textFieldName:'NAME',
				DBtextFieldName: 'NAME',
				api: 'popupService.employeePopup1',
				app: 'Unilite.app.popup.EmployeePopup1',
				//popupPage: '/com/popup/bk/EmployeePopup.do',
				popupWidth:660,
				popupHeight:490,
				pageTitle: '사원조회 POPUP1'
			};
		} else if (sPopItem == 'ParttimeEmployee' ) {
			rv = {
				xtype:'uniPopupField',
				fieldLabel : '사원',
				valueFieldName:'PERSON_NUMB',
				textFieldName:'NAME',
				DBvalueFieldName: 'PERSON_NUMB',
				DBtextFieldName: 'NAME',
				api: 'popupService.parttimeEmployeePopup',
				app: 'Unilite.app.popup.ParttimeEmployeePopup',
				//popupPage: '/com/popup/bk/EmployeePopup.do',
				popupWidth:660,
				popupHeight:490,
				valueFieldWidth: 90,
				textFieldWidth: 140,
				pageTitle: '일용직사원조회 ',
				extParam:{useBasicInfo:false}// 성명, 사번, 직위, 부서필드만 사용할 경우  false
			};
		} else if (sPopItem == 'ParttimeEmployee_G' ) {
			rv = {
				xtype:'uniPopupColumn',
				textFieldName:'NAME',
				DBtextFieldName: 'NAME',
				api: 'popupService.parttimeEmployeePopup',
				app: 'Unilite.app.popup.ParttimeEmployeePopup',
				//popupPage: '/com/popup/bk/EmployeePopup.do',
				popupWidth:660,
				popupHeight:490,
				pageTitle: '일용직사원조회 '
			};
		}else if (sPopItem == 'Employee_ACCNT' ) {		//회계 - 사원 팝업
			rv = {
				xtype:'uniPopupField',
				fieldLabel : '사원',
				valueFieldName:'PERSON_NUMB',
				textFieldName:'NAME',
				DBvalueFieldName: 'PERSON_NUMB',
				DBtextFieldName: 'NAME',
				api: 'popupService.employeePopup',
				app: 'Unilite.app.popup.EmployeeAccntPopup',
				//popupPage: '/com/popup/bk/EmployeePopup.do',
				popupWidth:660,
				popupHeight:490,
				valueFieldWidth: 90,
				textFieldWidth: 140,
				pageTitle: '사원조회 POPUP'
			};
		} else if (sPopItem == 'Employee_ACCNT_G' ) {		//회계 - 사원 팝업
			rv = {
				xtype:'uniPopupColumn',
				textFieldName:'NAME',
				DBtextFieldName: 'NAME',
				api: 'popupService.employeePopup',
				app: 'Unilite.app.popup.EmployeeAccntPopup',
				//popupPage: '/com/popup/bk/EmployeePopup.do',
				popupWidth:660,
				popupHeight:490,
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
				//popupPage: '/com/popup/bk/DeptPopup.do',
				popupWidth:388,
				popupHeight:497,
				valueFieldWidth: 90,
				textFieldWidth: 140,
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
				popupWidth:388,
				popupHeight:497,
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
				useyn:this._setUseYn() ,
				valueFieldWidth: 90,
				textFieldWidth: 140,
				//20190523 팝업오픈 오류로 app주석 해제, popupPage 주석 처리
				app: 'Unilite.app.popup.ItemPopup2',
//				popupPage: '/com/popup/bk/ItemPopup2.do',
				pageTitle: '사용자별 품목정보'
			};
		} else if (sPopItem == 'ITEM2_G' ) {
			rv = {
				xtype:'uniPopupColumn', // 일반 Form용
				textFieldName:'ITEM_NAME2',
				DBtextFieldName: 'ITEM_NAME',
				api: 'popupService.itemPopup2',
				//20190523 팝업오픈 오류로 app주석 해제, popupPage 주석 처리
				app: 'Unilite.app.popup.ItemPopup2',
//				popupPage: '/com/popup/bk/ItemPopup2.do',
				useyn:this._setUseYn() ,
				pageTitle: '사용자별 품목정보'
			};
		} else if (sPopItem == 'ITEM3' ) {	// 품목팝업
			rv = {
				xtype:'uniPopupColumn', // 일반 Form용
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
				fieldLabel : UniUtils.getPopupText('system.label.common.popup.item','품목코드'),
				valueFieldName:'ITEM_CODE',
				textFieldName:'ITEM_NAME',
				DBvalueFieldName: 'ITEM_CODE',
				DBtextFieldName: 'ITEM_NAME',
				extraFieldsConfig:itemPopupExtraField,//[{extraFieldName:'SPEC', extraFieldWidth:153}],품목팝업 추가 필드 공통코드(B252) 옵션으로 처리
				api: 'popupService.divPumokPopup',
				app: 'Unilite.app.popup.DivPumokPopup',
				//popupPage: '/com/popup/bk/DivPumokPopup.do',
				useyn:this._setUseYn() ,
				valueFieldWidth: 90,
				textFieldWidth: 140,
				pageTitle: '사업장별 품목정보'
			};
		}else if (sPopItem == 'AGENT_DIV_PUMOK' ) {
            rv = {
                xtype:'uniPopupField', // 일반 Form용
                fieldLabel : UniUtils.getPopupText('system.label.common.popup.item','품목코드'),
                valueFieldName:'ITEM_CODE',
                textFieldName:'ITEM_NAME',
                DBvalueFieldName: 'ITEM_CODE',
                DBtextFieldName: 'ITEM_NAME',
                extraFieldsConfig:itemPopupExtraField,//[{extraFieldName:'SPEC', extraFieldWidth:153}],품목팝업 추가 필드 공통코드(B252) 옵션으로 처리
                api: 'popupService.AgentDivPumokPopup',
                app: 'Unilite.app.popup.AgentDivPumokPopup',
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
		} else if (sPopItem == 'SAFFER_TAX' ) {
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
		} else if (sPopItem == 'MECHANIC' ) {
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
		} else if (sPopItem == 'COUNT_DATE' ) {
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
		} else if (sPopItem == 'CUST_BILL_PRSN_SINGLE' ) {		//담당자_SINGLE
			rv = {
				xtype:'uniPopupField',
				fieldLabel : '담당자',
				valueFieldName:'SEQ',
				textFieldName:'PRSN_NAME',
				DBvalueFieldName: '담당자',
				DBtextFieldName: 'PRSN_NAME',
				api: 'popupService.custBillPrsnPopup',
				app: 'Unilite.app.popup.CustBillPrsnPopupWin',
				textFieldOnly: true,
				textFieldWidth: 230,
				popupWidth:600,
				popupHeight:400,
				pageTitle: '전자세금계산서 담당자'
			};
		}  else if (sPopItem == 'CUST_BILL_PRSN_G_MULTI' ) {
			rv = {
					xtype:'uniPopupColumn',
					textFieldName:'PRSN_NAME',
					DBtextFieldName: 'PRSN_NAME',
					api: 'popupService.custBillPrsnPopup',
					app: 'Unilite.app.popup.CustBillPrsnPopupMultiWin',
					useyn:this._setUseYn() ,
					popupWidth:600,
					popupHeight:400,
					pageTitle: '전자세금계산서 담당자'


				};
		} else if (sPopItem == 'PJT' ) {	//프로젝트정보 팝업 (PJT100T)
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
		} else if (sPopItem == 'PROJECT' ) {	//프로젝트번호 팝업 (BCM600T)
			rv = {
				xtype:'uniPopupField',
				fieldLabel : '프로젝트번호',
				textFieldName:'PJT_CODE',
				DBtextFieldName: 'PJT_CODE',
				textFieldOnly: true,
				api: 'popupService.projectPopup',
				app: 'Unilite.app.popup.ProjectPopup',
				popupWidth:1000,
				popupHeight:600,
				valueFieldWidth: 90,
				textFieldWidth: 140,
				pageTitle: '프로젝트번호'
			};
		} else if (sPopItem == 'PROJECT_G' ) {	//프로젝트번호 팝업
			rv = {
				xtype:'uniPopupColumn',
				textFieldName:'PJT_CODE',
				DBtextFieldName: 'PJT_CODE',
				api: 'popupService.projectPopup',
				app: 'Unilite.app.popup.ProjectPopup',
				popupWidth:1000,
				popupHeight:600,
				pageTitle: '프로젝트번호'
			};
		} else if (sPopItem == 'SHOP' ) {					// 연세대(매장) - BSA250T 테이블 필요
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
		} else if (sPopItem == 'SHOP_G' ) {					// 연세대(매장) - BSA250T 테이블 필요
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
		} else if (sPopItem == 'HS' ) { 		// HS
			rv = {
				xtype:'uniPopupField', // 일반 Form용
				valueFieldName:'HS_NO',
				textFieldName:'HS_NAME',
				DBvalueFieldName: 'HS_NO',
				DBtextFieldName: 'HS_NAME',
				textFieldOnly: true,
				api: 'popupService.hsPopup',
				app: 'Unilite.app.popup.HsPopup',
				//popupPage: '/com/popup/bk/CustPopup.do',
				popupWidth:1200,
				popupHeight:400,
				textFieldWidth: 150,
				pageTitle: 'HS목록'
			};
		} else if (sPopItem == 'HS_G' ) {	// HS번호 그리드용
			rv = {
				xtype:'uniPopupColumn',	 // Grid용
				valueFieldName:'HS_NO',
				textFieldName:'HS_NAME',
				DBvalueFieldName: 'HS_NO',
				DBtextFieldName: 'HS_NAME',
				api: 'popupService.hsPopup',
				app: 'Unilite.app.popup.HsPopup',
				//popupPage: '/com/popup/bk/CustPopup.do',
				popupWidth:700,
				popupHeight:500,
				pageTitle: 'HS목록'
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
				popupWidth:910,
				popupHeight:490,
				textFieldWidth: 150,
				pageTitle: 'LOT목록'
			};
		} else if (sPopItem == 'LOT_G' ) {	// LOT 그리드용
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
		} else if (sPopItem == 'LOTNO' ) {	 // LOTNO
			 rv = {
				xtype:'uniPopupField', // 일반 Form용
				textFieldName:'LOTNO_CODE',
				DBtextFieldName: 'LOTNO_CODE',
				textFieldOnly: true,
				api: 'popupService.lotNoPopup',
				app: 'Unilite.app.popup.LotNoPopup',
				//popupPage: '/com/popup/bk/CustPopup.do',
				popupWidth:1200,
				popupHeight:400,
				textFieldWidth: 150,
				pageTitle: 'LOT 재고정보'
			};
		} else if (sPopItem == 'LOTNO_G' ) {	// LOTNO 그리드용
			rv = {
				xtype:'uniPopupColumn',	 // Grid용
				textFieldName:'LOTNO_CODE',
				DBtextFieldName: 'LOTNO_CODE',
				api: 'popupService.lotNoPopup',
				app: 'Unilite.app.popup.LotNoPopup',
				//popupPage: '/com/popup/bk/CustPopup.do',
				popupWidth:1200,
				popupHeight:550,
				pageTitle: 'LOT 재고정보'
			};
		} else if (sPopItem == 'LOT_MULTI_G' ) {	// LOT 그리드용 (멀티 선택)
			rv = {
				xtype:'uniPopupColumn',		// Grid용
				textFieldName:'LOTNO_CODE',
				DBtextFieldName: 'LOTNO_CODE',
				api: 'popupService.lotNoPopup',
				app: 'Unilite.app.popup.LotPopupMulti',
				//popupPage: '/com/popup/bk/CustPopup.do',
				popupWidth:1200,
				popupHeight:550,
				pageTitle: 'LOT 재고정보'
			};
		} else if (sPopItem == 'LOT_STOCK_G' ) {		// LOT 그리드용 (멀티 선택), 현재고 > 0
			rv = {
				xtype			: 'uniPopupColumn',		// Grid용
				textFieldName	: 'LOTNO_CODE',
				DBtextFieldName	: 'LOTNO_CODE',
				api				: 'popupService.lotStockPopup',
				app				: 'Unilite.app.popup.LotPopupStock',
				popupWidth		: 1200,
				popupHeight		: 550,
				pageTitle		: 'LOT 재고정보'
			};
		} else if (sPopItem == 'LOT_ITEM_G' ) {		// LOT 그리드용 (멀티 선택), 현재고 > 0, 품목 팝업 대신 사용 (출고등록(건별)(LOT팝업) (str106ukrv))
			rv = {
				xtype			: 'uniPopupColumn',		// Grid용
				textFieldName	: 'LOTNO_CODE',
				DBtextFieldName	: 'LOTNO_CODE',
				api				: 'popupService.lotItemPopup',
				app				: 'Unilite.app.popup.LotPopupItem',
				popupWidth		: 1200,
				popupHeight		: 550,
				pageTitle		: 'LOT 품목'
			};
		} else if (sPopItem == 'LOTNO_YP' ) {	// 양평공사 LOT팝업
			 rv = {
				xtype:'uniPopupField', // 일반 Form용
				textFieldName:'LOTNO_CODE',
				DBtextFieldName: 'LOTNO_CODE',
				textFieldOnly: true,
				api: 'popupService.lotNoYpPopup',
				app: 'Unilite.app.popup.LotNoYpPopup',
				popupWidth:1200,
				popupHeight:400,
				textFieldWidth: 150,
				pageTitle: 'LOT 재고정보'
			};
		} else if (sPopItem == 'LOTNO_YP_G' ) {	// 양평공사 LOT팝업 그리드용
			rv = {
				xtype:'uniPopupColumn',	 // Grid용
				textFieldName:'LOTNO_CODE',
				DBtextFieldName: 'LOTNO_CODE',
				api: 'popupService.lotNoYpPopup',
				app: 'Unilite.app.popup.LotNoYpPopup',
				//popupPage: '/com/popup/bk/CustPopup.do',
				popupWidth:1200,
				popupHeight:550,
				pageTitle: 'LOT 재고정보'
			};
		} else if (sPopItem == 'LOTNO_YP_G2' ) {	// 양평공사 LOT팝업 그리드용 (작업지시등록 LOT 분할시 POPUP)
			rv = {
				xtype:'uniPopupColumn',	 // Grid용
				textFieldName:'LOTNO_CODE',
				DBtextFieldName: 'LOTNO_CODE',
				api: 'popupService.lotNoYpPopup2',
				app: 'Unilite.app.popup.LotNoYpPopup2',
				popupWidth:1100,
				popupHeight:550,
				pageTitle: 'LOT 재고정보'
			};
		} else if (sPopItem == 'REQ_NUM' ) {		 // 의뢰번호
			rv = {
					xtype:'uniPopupField', // 일반 Form용
					textFieldName: 'P_REQ_NUM',
					DBtextFieldName: 'P_REQ_NUM',
					textFieldOnly: true,
					api: 'popupService.reqNumPopup',
					app: 'Unilite.app.popup.ReqNumPopup',
					//popupPage: '/com/popup/bk/CustPopup.do',
					popupWidth:1020,
					popupHeight:600,
					textFieldWidth: 150,
					pageTitle: '의뢰번호목록'
				};
		} else if (sPopItem == 'PLAN_NUM' ) {		 // 계획번호
			rv = {
					xtype:'uniPopupField', // 일반 Form용
					textFieldName: 'PLAN_NUM',
					DBtextFieldName: 'PLAN_NUM',
					textFieldOnly: true,
					api: 'popupService.planNumPopup',
					app: 'Unilite.app.popup.PlanNumPopup',
					//popupPage: '/com/popup/bk/CustPopup.do',
					popupWidth:600,
					popupHeight:400,
					textFieldWidth: 150,
					pageTitle: '계획번호목록'
				};
		} else if (sPopItem == 'ENTRY_NUM1_KD' ) {		 // 관리코드(S_ZCC600T_KD)
			rv = {
					xtype:'uniPopupField', // 일반 Form용
					textFieldName: 'ENTRY_NUM',
					DBtextFieldName: 'ENTRY_NUM',
					textFieldOnly: true,
					api: 'popupService.entryNumPopup1',
					app: 'Unilite.app.popup.EntryNumPopup1',
					//popupPage: '/com/popup/bk/CustPopup.do',
					popupWidth:750,
					popupHeight:450,
					textFieldWidth: 150,
					pageTitle: '관리코드목록'
				};
		} else if (sPopItem == 'ENTRY_NUM2_KD' ) {		 // 관리코드(S_ZCC700T_KD)
			rv = {
					xtype:'uniPopupField', // 일반 Form용
					textFieldName: 'ENTRY_NUM',
					DBtextFieldName: 'ENTRY_NUM',
					textFieldOnly: true,
					api: 'popupService.entryNumPopup2',
					app: 'Unilite.app.popup.EntryNumPopup2',
					//popupPage: '/com/popup/bk/CustPopup.do',
					popupWidth:750,
					popupHeight:450,
					textFieldWidth: 150,
					pageTitle: '관리코드목록'
				};
		} else if (sPopItem == 'REQ_NUM_G' ) {   // 의뢰번호 그리드
			rv = {
				xtype:'uniPopupColumn',
				textFieldName: 'P_REQ_NUM',
				DBtextFieldName: 'P_REQ_NUM',
				api: 'popupService.reqNumPopup',
				app: 'Unilite.app.popup.ReqNumPopup',
				popupWidth:679,
				popupHeight:407,
				pageTitle: '의뢰번호목록'
			};
		} else if (sPopItem == 'RETURN_NUM' ) {		 // 관세환급번호
			rv = {
					xtype:'uniPopupField', // 일반 Form용
					textFieldName: 'RETURN_NO',
					DBtextFieldName: 'RETURN_NO',
					textFieldOnly: true,
					api: 'popupService.returnNumPopup',
					app: 'Unilite.app.popup.ReturnNumPopup',
					//popupPage: '/com/popup/bk/CustPopup.do',
					popupWidth:600,
					popupHeight:400,
					textFieldWidth: 150,
					pageTitle: '관세환급번호목록'
				};
		} else if (sPopItem == 'RETURN_NUM_G' ) {   // 관세환급번호 그리드
			rv = {
				xtype:'uniPopupColumn',
				textFieldName: 'RETURN_NO',
				DBtextFieldName: 'RETURN_NO',
				api: 'popupService.returnNumPopup',
				app: 'Unilite.app.popup.ReturnNumPopup',
				popupWidth:679,
				popupHeight:407,
				pageTitle: '관세환급번호목록'
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
				popupWidth:600,
				popupHeight:450,
				textFieldWidth: 150,
				pageTitle: '<t:message code="system.label.common.sono" default="수주번호"/>'
			};
		} else if (sPopItem == 'ORDER_NUM_G' ) {	//수주번호 팝업(그리드)
			rv = {
				xtype			: 'uniPopupColumn',
				textFieldName	: 'ORDER_NUM',
				DBtextFieldName	: 'ORDER_NUM',
				textFieldOnly	: true,
				api				: 'popupService.orderNumPopup2',
				app				: 'Unilite.app.popup.OrderNumPopup',
				popupWidth		: 600,
				popupHeight		: 450,
				textFieldWidth	: 150,
				pageTitle		: '<t:message code="system.label.common.sono" default="수주번호"/>'
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
				api: 'popupService.getBomCopyPopup',
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
		} else if (sPopItem == 'BIN' ) {				//연세대 - BPR210T 테이블 필요
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
		} else if (sPopItem == 'BIN_G' ) {				//연세대 - BPR210T 테이블 필요
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
		} else if (sPopItem == 'POS' ) {				//연세대 - BSA240T 테이블 필요
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
		} else if (sPopItem == 'POS_G' ) {				//연세대 - BSA240T 테이블 필요
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
		} else if (sPopItem == 'REMARK_DISTRIBUTION' ) {		// 적요(물류)(TEXT필드만..)
			rv = {
				xtype:'uniPopupField',
				fieldLabel : '적요',
				valueFieldName:'REMARK_CODE',
				textFieldName:'REMARK_NAME',
				DBvalueFieldName: 'REMARK_CODE',
				DBtextFieldName: 'REMARK_NAME',
				api: 'popupService.remarkDistributionPopup',
				app: 'Unilite.app.popup.RemarkDistributionPopup',
				textFieldOnly: true,
				textFieldWidth: 230,
				popupWidth:579,
				popupHeight:407,
				pageTitle: '적요'
			};
		} else if (sPopItem == 'NEGO_INCOM_NO' ) {		//무역 - 수입NEGO관리번호
			rv = {
				xtype:'uniPopupField',
				fieldLabel : '관리번호',
				valueFieldName:'NEGO_SER_NO',
				textFieldName:'NEGO_SER_NO',
				DBvalueFieldName: 'NEGO_SER_NO',
				DBtextFieldName: 'NEGO_SER_NO',
				textFieldOnly: true,
				api: 'popupService.negoIncomNoPopup',
				app: 'Unilite.app.popup.NegoIncomNoPopup',
				valueFieldWidth: 90,
				textFieldWidth: 140,
				popupWidth:789,
				popupHeight:450,
				pageTitle: '수입대금 관리번호'
			};
		} else if (sPopItem == 'NEGO_INCOM_NO_G' ) {  //무역 - 수입NEGO관리번호 그리드
			rv = {
				xtype:'uniPopupColumn',
				textFieldName:'NEGO_SER_NO',
				DBtextFieldName: 'NEGO_SER_NO',
				api: 'popupService.negoIncomNoPopup',
				app: 'Unilite.app.popup.NegoIncomNoPopup',
				popupWidth:789,
				popupHeight:450,
				pageTitle: '수입대금 관리번호'
			};
		} else if (sPopItem == 'PASS_INCOM_NO' ) {		//무역 - 수입 통관관리번호
			rv = {
				xtype:'uniPopupField',
				fieldLabel : '관리번호',
				valueFieldName:'PASS_INCOM_NO',
				textFieldName:'PASS_INCOM_NO',
				DBvalueFieldName: 'PASS_INCOM_NO',
				DBtextFieldName: 'PASS_INCOM_NO',
				textFieldOnly: true,
				api: 'popupService.passIncomNoPopup',
				app: 'Unilite.app.popup.PassIncomNoPopup',
				valueFieldWidth: 90,
				textFieldWidth: 140,
				popupWidth:789,
				popupHeight:450,
				pageTitle: '통관관리번호'
			};
		} else if (sPopItem == 'PASS_INCOM_NO_G' ) {  //무역 - 수입 통관관리번호
			rv = {
				xtype:'uniPopupColumn',
				textFieldName:'PASS_INCOM_NO',
				DBtextFieldName: 'PASS_INCOM_NO',
				api: 'popupService.passIncomNoPopup',
				app: 'Unilite.app.popup.PassIncomNoPopup',
				popupWidth:1018,
				popupHeight:500,
				pageTitle: '통관관리번호'
			};
		} else if (sPopItem == 'NEGO_SER_NO' ) {		//무역 - 수출NEGO관리번호
			rv = {
				xtype:'uniPopupField',
				fieldLabel : '관리번호',
				valueFieldName:'NEGO_SER_NO',
				textFieldName:'NEGO_SER_NO',
				DBvalueFieldName: 'NEGO_SER_NO',
				DBtextFieldName: 'NEGO_SER_NO',
				textFieldOnly: true,
				api: 'popupService.negoNoPopup',
				app: 'Unilite.app.popup.NegoNoPopup',
				valueFieldWidth: 90,
				textFieldWidth: 140,
				popupWidth:789,
				popupHeight:450,
				pageTitle: '관리번호'
			};
		} else if (sPopItem == 'NEGO_SER_NO_G' ) {  //무역 - 수출NEGO관리번호 그리드
			rv = {
				xtype:'uniPopupColumn',
				textFieldName:'NEGO_SER_NO',
				DBtextFieldName: 'NEGO_SER_NO',
				api: 'popupService.negoNoPopup',
				app: 'Unilite.app.popup.NegoNoPopup',
				popupWidth:789,
				popupHeight:450,
				pageTitle: '관리번호'
			};
		} else if (sPopItem == 'INCOM_OFFER' ) {		//무역 - 수입 OFFER번호
			rv = {
				xtype:'uniPopupField',
				fieldLabel : '관리번호',
				valueFieldName:'OFFER_NO',
				textFieldName:'OFFER_NO',
				DBvalueFieldName: 'OFFER_NO',
				DBtextFieldName: 'OFFER_NO',
				textFieldOnly: true,
				api: 'popupService.incomOfferNoPopup',
				app: 'Unilite.app.popup.IncomOfferNoPopup',
				valueFieldWidth: 90,
				textFieldWidth: 140,
				popupWidth:789,
				popupHeight:450,
				pageTitle: 'OFFER관리번호'
			};
		} else if (sPopItem == 'INCOM_OFFER_G' ) {  //무역 - 수입 OFFER번호
			rv = {
				xtype:'uniPopupColumn',
				textFieldName:'OFFER_NO',
				DBtextFieldName: 'OFFER_NO',
				api: 'popupService.incomOfferNoPopup',
				app: 'Unilite.app.popup.IncomOfferNoPopup',
				popupWidth:789,
				popupHeight:450,
				pageTitle: 'OFFER관리번호'
			};
		} else if (sPopItem == 'INCOM_BL' ) {		//무역 - 수입 B/L번호
			rv = {
				xtype:'uniPopupField',
				fieldLabel : '관리번호',
				valueFieldName:'BL_SER_NO',
				textFieldName:'BL_SER_NO',
				DBvalueFieldName: 'BL_SER_NO',
				DBtextFieldName: 'BL_SER_NO',
				textFieldOnly: true,
				api: 'popupService.incomBlNoPopup',
				app: 'Unilite.app.popup.IncomBlNoPopup',
				valueFieldWidth: 90,
				textFieldWidth: 140,
				popupWidth:789,
				popupHeight:450,
				pageTitle: 'B/L관리번호'
			};
		} else if (sPopItem == 'INCOM_BL_G' ) {  //무역 - 수입 B/L번호
			rv = {
				xtype:'uniPopupColumn',
				textFieldName:'BL_SER_NO',
				DBtextFieldName: 'BL_SER_NO',
				api: 'popupService.incomBlNoPopup',
				app: 'Unilite.app.popup.IncomBlNoPopup',
				popupWidth:789,
				popupHeight:450,
				pageTitle: 'B/L관리번호'
			};
		} else if (sPopItem == 'DELIVERY' ) {	  //배송처
			rv = {
				xtype:'uniPopupField',
				fieldLabel : '배송처',
				valueFieldName:'DELIVERY_CODE',
				textFieldName:'DELIVERY_NAME',
				DBvalueFieldName: 'DELIVERY_CODE',
				DBtextFieldName: 'DELIVERY_NAME',
				api: 'popupService.deliveryPopup',
				app: 'Unilite.app.popup.DeliveryPopup',
				valueFieldWidth: 60,
				textFieldWidth: 170,
				popupWidth:679,
				popupHeight:407,
				pageTitle: '배송처'
			};
		} else if (sPopItem == 'DELIVERY_G' ) {   //배송처 그리드
			rv = {
				xtype:'uniPopupColumn',
				textFieldName:'DELIVERY_NAME',
				DBtextFieldName: 'DELIVERY_NAME',
				api: 'popupService.deliveryPopup',
				app: 'Unilite.app.popup.DeliveryPopup',
				popupWidth:679,
				popupHeight:407,
				pageTitle: '배송처'
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
				popupWidth:579,
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
				popupWidth:579,
				popupHeight:400,
				pageTitle: '사업장'
			};
		} else if (sPopItem == 'ACCNT' ) {		// 회계 - 계정과목
			rv = {								// applyextparam: ADD_QUERY, CHARGE_CODE
				xtype:'uniPopupField',
				fieldLabel : '계정과목',
				valueFieldName:'ACCNT_CODE',
				textFieldName:'ACCNT_NAME',
				DBvalueFieldName: 'ACCNT_CODE',
				DBtextFieldName: 'ACCNT_NAME',
				api: 'popupService.accntsPopup',
				app: 'Unilite.app.popup.AccntsPopup',
				valueFieldWidth: 80,
				textFieldWidth: 150,
				popupWidth:559,
				popupHeight:407,
				pageTitle: '계정과목'
			};
		} else if (sPopItem == 'ACCNT_G' ) {	//회계 - 계정과목그리드
			rv = {
				xtype:'uniPopupColumn',
				textFieldName:'ACCNT_NAME',
				DBtextFieldName: 'ACCNT_NAME',
				popupWidth:559,
				popupHeight:407,
				api: 'popupService.accntsPopup',
				app: 'Unilite.app.popup.AccntsPopup',
				pageTitle: '계정과목'
			};
		} else if (sPopItem == 'FOREIGN_ACCNT' ) {		// 외화계정
			rv = {
				xtype:'uniPopupField',
				fieldLabel : '계정과목',
				valueFieldName:'ACCNT',
				textFieldName:'ACCNT_NAME',
				DBvalueFieldName: 'ACCNT',
				DBtextFieldName: 'ACCNT_NAME',
				api: 'popupService.foreignAccntPopup',
				app: 'Unilite.app.popup.ForeignAccntsPopup',
				valueFieldWidth: 80,
				textFieldWidth: 150,
				popupWidth:559,
				popupHeight:407,
				pageTitle: '외화계정'
			};
		} else if (sPopItem == 'FOREIGN_ACCNTT_G' ) {	// 외화계정(그리드)
			rv = {
				xtype:'uniPopupColumn',
				textFieldName:'ACCNT',
				DBtextFieldName: 'ACCNT_NAME',
				popupWidth:559,
				popupHeight:407,
				api: 'popupService.foreignAccntPopup',
				app: 'Unilite.app.popup.ForeignAccntsPopup',
				pageTitle: '외화계정'
			};
		} else if (sPopItem == 'EXCHANGE_ACCNT' ) {		// 환산계정
			rv = {
				xtype:'uniPopupField',
				fieldLabel : '계정과목',
				valueFieldName:'ACCNT',
				textFieldName:'ACCNT_NAME',
				DBvalueFieldName: 'ACCNT',
				DBtextFieldName: 'ACCNT_NAME',
				api: 'popupService.exchangeAccntPopup',
				app: 'Unilite.app.popup.ExchangeAccntsPopup',
				valueFieldWidth: 80,
				textFieldWidth: 150,
				popupWidth:559,
				popupHeight:407,
				pageTitle: '환산계정'
			};
		} else if (sPopItem == 'EXCHANGE_ACCNT_G' ) {	// 환산계정(그리드)
			rv = {
				xtype:'uniPopupColumn',
				textFieldName:'ACCNT',
				DBtextFieldName: 'ACCNT_NAME',
				popupWidth:559,
				popupHeight:407,
				api: 'popupService.exchangeAccntPopup',
				app: 'Unilite.app.popup.ExchangeAccntsPopup',
				pageTitle: '환산계정'
			};
		} else if (sPopItem == 'ACCNT_AC' ) {		// 회계 - 계정과목, 관라항목
			rv = {								// applyextparam: ADD_QUERY, CHARGE_CODE
				xtype:'uniPopupField',
				fieldLabel : '계정과목',
				valueFieldName:'ACCNT_CODE',
				textFieldName:'ACCNT_NAME',
				DBvalueFieldName: 'ACCNT_CODE',
				DBtextFieldName: 'ACCNT_NAME',
				api: 'popupService.accntPopupWithAcCode',
				app: 'Unilite.app.popup.AccntsPopupWithAcCode',
				valueFieldWidth: 80,
				textFieldWidth: 150,
				popupWidth:559,
				popupHeight:407,
				pageTitle: '계정과목'
			};
		} else if (sPopItem == 'ACCNT_AC_G' ) {	//회계 - 계정과목, 관라항목 그리드
			rv = {
				xtype:'uniPopupColumn',
				textFieldName:'ACCNT_NAME',
				DBtextFieldName: 'ACCNT_NAME',
				popupWidth:559,
				popupHeight:407,
				api: 'popupService.accntPopupWithAcCode',
				app: 'Unilite.app.popup.AccntsPopupWithAcCode',
				pageTitle: '계정과목'
			};
		} else if (sPopItem == 'ACCNT_PAY' ) {		// 회계 - 지출결의 계정과목
			rv = {								
					xtype:'uniPopupField',
					fieldLabel : '계정과목',
					valueFieldName:'ACCNT',
					textFieldName:'ACCNT_NAME',
					DBvalueFieldName: 'ACCNT',
					DBtextFieldName: 'ACCNT_NAME',
					api: 'popupService.accntsPayPopup',
					app: 'Unilite.app.popup.AccntsPayPopup',
					valueFieldWidth: 80,
					textFieldWidth: 150,
					popupWidth:559,
					popupHeight:407,
					pageTitle: '계정과목'
				};
			} else if (sPopItem == 'ACCNT_PAY_G' ) {	//회계 - 지출결의 계정과목그리드
				rv = {
					xtype:'uniPopupColumn',
					textFieldName:'ACCNT_NAME',
					DBtextFieldName: 'ACCNT_NAME',
					popupWidth:559,
					popupHeight:407,
					api: 'popupService.accntsPayPopup',
					app: 'Unilite.app.popup.AccntsPayPopup',
					pageTitle: '계정과목'
				};
			}else if (sPopItem == 'MANAGE' ) {		//회계 - 관리항목
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
				popupWidth:679,
				popupHeight:407,
				pageTitle: '관리항목'
			};
		} else if (sPopItem == 'MANAGE_G' ) {	//회계 - 관리항목 그리드
			rv = {
				xtype:'uniPopupColumn',
				textFieldName:'MANAGE_NAME',
				DBtextFieldName: 'MANAGE_NAME',
				api: 'popupService.managePopup',
				app: 'Unilite.app.popup.ManagePopup',
				popupWidth:679,
				popupHeight:407,
				pageTitle: '관리항목'
			};
		} else if (sPopItem == 'USER_MANAGE' ) {		//회계 - 관리항목(사용자용)
			rv = {
				xtype:'uniPopupField',
				fieldLabel : '관리항목',
				valueFieldName:'USER_MANAGE_CODE',
				textFieldName:'USER_MANAGE_NAME',
				DBvalueFieldName: 'USER_MANAGE_CODE',
				DBtextFieldName: 'USER_MANAGE_NAME',
				api: 'popupService.userManagePopup',
				app: 'Unilite.app.popup.UserManagePopup',
				valueFieldWidth: 60,
				textFieldWidth: 170,
				popupWidth:679,
				popupHeight:407,
				pageTitle: '관리항목'
			};
		} else if (sPopItem == 'USER_MANAGE_G' ) {	//회계 - 관리항목(사용자용) 그리드
			rv = {
				xtype:'uniPopupColumn',
				textFieldName:'USER_MANAGE_NAME',
				DBtextFieldName: 'USER_MANAGE_NAME',
				api: 'popupService.userManagePopup',
				app: 'Unilite.app.popup.UserManagePopup',
				popupWidth:679,
				popupHeight:407,
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
				popupWidth:579,
				popupHeight:407,
				pageTitle: '적요'
			};
		} else if (sPopItem == 'REMARK_G' ) {	//회계 - 적요그리드
			rv = {
				xtype:'uniPopupColumn',
				textFieldName:'REMARK_NAME',
				DBtextFieldName: 'REMARK_NAME',
				api: 'popupService.remarkPopup',
				app: 'Unilite.app.popup.RemarkPopup',
				popupWidth:579,
				popupHeight:407,
				pageTitle: '적요'
			};
		} else if (sPopItem == 'REMARK_SINGLE' ) {		//회계 - 적요(TEXT필드만..)
			rv = {
				xtype:'uniPopupField',
				fieldLabel : '적요',
				valueFieldName:'REMARK_CODE',
				textFieldName:'REMARK_NAME',
				DBvalueFieldName: 'REMARK_CODE',
				DBtextFieldName: 'REMARK_NAME',
				api: 'popupService.remarkPopup',
				app: 'Unilite.app.popup.RemarkPopup',
				textFieldOnly: true,
				textFieldWidth: 230,
				popupWidth:579,
				popupHeight:407,
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
				popupWidth:579,
				popupHeight:407,
				pageTitle: '기간비용'
			};
		} else if (sPopItem == 'COST_G' ) {	//회계 - 기간비용 그리드
			rv = {
				xtype:'uniPopupColumn',
				textFieldName:'COST_NAME',
				DBtextFieldName: 'COST_NAME',
				api: 'popupService.costPopup',
				app: 'Unilite.app.popup.CostPopup',
				popupWidth:579,
				popupHeight:407,
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
				popupWidth:579,
				popupHeight:407,
				pageTitle: '회계담당자'
			};
		} else if (sPopItem == 'ACCNT_PRSN_G' ) {	//회계 - 담당자 그리드
			rv = {
				xtype:'uniPopupColumn',
				textFieldName:'PRSN_NAME',
				DBtextFieldName: 'PRSN_NAME',
				api: 'popupService.accntPrsnPopup',
				app: 'Unilite.app.popup.AccntPrsnPopup',
				popupWidth:579,
				popupHeight:407,
				pageTitle: '회계담당자'
			};
		} else if (sPopItem == 'ALLOW' ) {		// 회계 - 수당/공제코드
			rv = {									// applyextparam: ALLOW_TAG(수당/공제구분)
					xtype:'uniPopupField',
					fieldLabel : '수당/공제코드',
					valueFieldName:'ALLOW_CODE',
					textFieldName:'ALLOW_NAME',
					DBvalueFieldName: 'ALLOW_CODE',
					DBtextFieldName: 'ALLOW_NAME',
//					api: 'popupService.allowPopup',	   //정규
					api: 'popupService.allowPopup',	 //조인스
					app: 'Unilite.app.popup.AllowPopup',
					valueFieldWidth: 60,
					textFieldWidth: 170,
					popupWidth:559,
					popupHeight:407,
					pageTitle: '수당/공제코드'
				};
			} else if (sPopItem == 'ALLOW_G' ) {	//회계 - 수당/공제코드 그리드

				rv = {
					xtype:'uniPopupColumn',
					textFieldName:'ALLOW_NAME',
					DBtextFieldName: 'ALLOW_NAME',
//					api: 'popupService.allowPopup',	   //정규
					api: 'popupService.allowPopup',	  //조인스
					app: 'Unilite.app.popup.AllowPopup',
					popupWidth:559,
					popupHeight:407,
					pageTitle: '수당/공제코드'
				};
		} else if (sPopItem == 'EXPENSE' ) {		// 회계 - 경비코드
			rv = {									// applyextparam: TRADE_DIV(무역구분), CHARGE_TYPE(진행구분)
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
				popupWidth:559,
				popupHeight:407,
				pageTitle: '경비코드'
			};
		} else if (sPopItem == 'EXPENSE_G' ) {	//회계 - 경비코드
			rv = {
					xtype:'uniPopupColumn',
					textFieldName:'EXPENSE_NAME',
					DBtextFieldName: 'EXPENSE_NAME',
					api: 'popupService.expensePopup',
					app: 'Unilite.app.popup.ExpensePopup',
					popupWidth:559,
					popupHeight:407,
					pageTitle: '경비코드'
				};
		} else if (sPopItem == 'EARNER' ) {		// 회계 - 소득자
			rv = {								// applyextparam: DED_TYPE(소득자타입), BILL_DIV_CODE(신고사업장)
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
				popupWidth:709,
				popupHeight:493,
				pageTitle: '소득자'
			};
		} else if (sPopItem == 'EARNER_G' ) {	//회계 - 소득자 그리드
			rv = {
				xtype:'uniPopupColumn',
				textFieldName:'EARNER_NAME',
				DBtextFieldName: 'EARNER_NAME',
				api: 'popupService.earnerPopup',
				app: 'Unilite.app.popup.EarnerPopup',
				popupWidth:709,
				popupHeight:493,
				pageTitle: '소득자'
			};
		} else if (sPopItem == 'REALTY' ) {		// 회계 - 부동산
			rv = {								// applyextparam: BILL_DIV_CODE(신고사업장)
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
				popupWidth:720,
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
				popupWidth:720,
				popupHeight:450,
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
				valueFieldWidth: 90,
				textFieldWidth: 140,
				popupWidth:725,
				popupHeight:447,
				pageTitle: '자산코드'
			};
		} else if (sPopItem == 'ASSET_G' ) {	//회계 - 자산코드 그리드
			rv = {
				xtype:'uniPopupColumn',
				textFieldName:'ASSET_NAME',
				DBtextFieldName: 'ASSET_NAME',
				api: 'popupService.assetPopup',
				app: 'Unilite.app.popup.AssetPopup',
				popupWidth:725,
				popupHeight:447,
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
				popupWidth:720,
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
				popupWidth:720,
				popupHeight:450,
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
				popupWidth:579,
				popupHeight:407,
				pageTitle: '단위'
			};
		} else if (sPopItem == 'UNIT_G' ) {	//회계 - 단위그리드
			rv = {
				xtype:'uniPopupColumn',
				textFieldName:'UNIT_NAME',
				DBtextFieldName: 'UNIT_NAME',
				api: 'popupService.unitPopup',
				app: 'Unilite.app.popup.UnitPopup',
				popupWidth:579,
				popupHeight:407,
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
				popupWidth:579,
				popupHeight:407,
				pageTitle: '어음종류'
			};
		} else if (sPopItem == 'NOTE_TYPE_G' ) {	//회계 -  어음종류 그리드
			rv = {
				xtype:'uniPopupColumn',
				textFieldName:'NOTE_TYPE_NAME',
				DBtextFieldName: 'NOTE_TYPE_NAME',
				api: 'popupService.noteTypePopup',
				app: 'Unilite.app.popup.NoteTypePopup',
				popupWidth:579,
				popupHeight:407,
				pageTitle: '어음종류'
			};
		} else if (sPopItem == 'NOTE_NUM' ) {		//회계 - 어음번호
			rv = {
				xtype:'uniPopupField',
				fieldLabel : '어음번호',
				valueFieldName:'NOTE_NUM_CODE',
				textFieldName:'NOTE_NUM_CODE',
				DBvalueFieldName: 'NOTE_NUM_CODE',
				DBtextFieldName: 'NOTE_NUM_CODE',
				textFieldOnly: true,
				api: 'popupService.noteNumPopup',
				app: 'Unilite.app.popup.NoteNumPopup',
				valueFieldWidth: 90,
				textFieldWidth: 140,
				popupWidth:689,
				popupHeight:447,
				pageTitle: '어음번호'
			};
		} else if (sPopItem == 'NOTE_NUM_G' ) {	//회계 -  어음번호그리드
			rv = {
				xtype:'uniPopupColumn',
				textFieldName:'NOTE_NUM_NAME',
				DBtextFieldName: 'NOTE_NUM_NAME',
				api: 'popupService.noteNumPopup',
				app: 'Unilite.app.popup.NoteNumPopup',
				popupWidth:689,
				popupHeight:447,
				pageTitle: '어음번호'
			};
		} else if (sPopItem == 'CHECK_NUM' ) {		//회계 - 수표번호
			rv = {
				xtype:'uniPopupField',
				fieldLabel : '수표번호',
				valueFieldName:'CHECK_NUM_CODE',
				textFieldName:'CHECK_NUM_CODE',
				DBvalueFieldName: 'CHECK_NUM_CODE',
				DBtextFieldName: 'CHECK_NUM_CODE',
				textFieldOnly: true,
				api: 'popupService.checkNumPopup',
				app: 'Unilite.app.popup.CheckNumPopup',
				valueFieldWidth: 90,
				textFieldWidth: 140,
				popupWidth:719,
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
				popupWidth:719,
				popupHeight:450,
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
				popupWidth:579,
				popupHeight:407,
				pageTitle: '화폐단위'
			};
		} else if (sPopItem == 'MONEY_G' ) {	//회계 - 화폐단위 그리드
			rv = {
				xtype:'uniPopupColumn',
				textFieldName:'MONEY_NAME',
				DBtextFieldName: 'MONEY_NAME',
				api: 'popupService.moneyPopup',
				app: 'Unilite.app.popup.MoneyPopup',
				popupWidth:579,
				popupHeight:407,
				pageTitle: '화폐단위'
			};
		} else if (sPopItem == 'EX_LCNO' ) {		//회계 - L/C번호(수출)
			rv = {
				xtype:'uniPopupField',
				fieldLabel : 'L/C번호(수출)',
				valueFieldName:'EX_LCNO_CODE',
				textFieldName:'EX_LCNO_CODE',
				DBvalueFieldName: 'EX_LCNO_CODE',
				DBtextFieldName: 'EX_LCNO_CODE',
				textFieldOnly: true,
				api: 'popupService.exLcnoPopup',
				app: 'Unilite.app.popup.ExLcnoPopup',
				valueFieldWidth: 90,
				textFieldWidth: 140,
				popupWidth:759,
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
				popupWidth:759,
				popupHeight:450,
				pageTitle: 'L/C번호(수출)'
			};
		} else if (sPopItem == 'IN_LCNO' ) {		//회계 - L/C번호(수입)
			rv = {
				xtype:'uniPopupField',
				fieldLabel : 'L/C번호(수입)',
				valueFieldName:'IN_LCNO_CODE',
				textFieldName:'IN_LCNO_CODE',
				DBvalueFieldName: 'IN_LCNO_CODE',
				DBtextFieldName: 'IN_LCNO_CODE',
				textFieldOnly: true,
				api: 'popupService.inLcnoPopup',
				app: 'Unilite.app.popup.InLcnoPopup',
				valueFieldWidth: 90,
				textFieldWidth: 140,
				popupWidth:759,
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
				popupWidth:759,
				popupHeight:450,
				pageTitle: 'L/C번호(수입)'
			};
		} else if (sPopItem == 'EX_BLNO' ) {		//회계 - B/L번호(수출)
			rv = {
				xtype:'uniPopupField',
				fieldLabel : 'B/L번호(수출)',
				valueFieldName:'BL_SER_NO',
				textFieldName:'BL_SER_NO',
				DBvalueFieldName: 'BL_SER_NO',
				DBtextFieldName: 'BL_SER_NO',
				textFieldOnly: true,
				api: 'popupService.exBlnoPopup',
				app: 'Unilite.app.popup.ExBlnoPopup',
				valueFieldWidth: 90,
				textFieldWidth: 140,
				popupWidth:789,
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
				popupWidth:789,
				popupHeight:450,
				pageTitle: 'B/L번호(수출)'
			};
		} else if (sPopItem == 'IN_BLNO' ) {		//회계 - B/L번호(수입)
			rv = {
				xtype:'uniPopupField',
				fieldLabel : 'B/L번호(수입)',
				valueFieldName:'IN_BLNO_CODE',
				textFieldName:'IN_BLNO_CODE',
				DBvalueFieldName: 'IN_BLNO_CODE',
				DBtextFieldName: 'IN_BLNO_CODE',
				textFieldOnly: true,
				api: 'popupService.inBlnoPopup',
				app: 'Unilite.app.popup.InBlnoPopup',
				valueFieldWidth: 90,
				textFieldWidth: 140,
				popupWidth:789,
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
				popupWidth:789,
				popupHeight:450,
				pageTitle: 'B/L번호(수입)'
			};
		} else if (sPopItem == 'PASS_SER_NO' ) {		//회계 - 수출신고번호
			rv = {
				xtype:'uniPopupField',
				fieldLabel : '수출신고번호',
				valueFieldName:'PASS_SER_NO',
				textFieldName:'PASS_SER_NO',
				DBvalueFieldName: 'PASS_SER_NO',
				DBtextFieldName: 'PASS_SER_NO',
				textFieldOnly: true,
				api: 'popupService.passSerNoPopup',
				app: 'Unilite.app.popup.PassSerNoPopup',
				valueFieldWidth: 90,
				textFieldWidth: 140,
				popupWidth:789,
				popupHeight:450,
				pageTitle: '수출신고번호'
			};
		} else if (sPopItem == 'PASS_SER_NO_G' ) {	//회계 -  수출신고번호 그리드
			rv = {
				xtype:'uniPopupColumn',
				textFieldName:'PASS_SER_NO',
				DBtextFieldName: 'PASS_SER_NO',
				api: 'popupService.passSerNoPopup',
				app: 'Unilite.app.popup.PassSerNoPopup',
				popupWidth:789,
				popupHeight:450,
				pageTitle: '수출신고번호'
			};
		} else if (sPopItem == 'AC_PROJECT' ) {		//회계 - 프로젝트
			rv = {
				xtype:'uniPopupField',
				fieldLabel : '사업코드',
				valueFieldName:'AC_PROJECT_CODE',
				textFieldName:'AC_PROJECT_NAME',
				DBvalueFieldName: 'AC_PROJECT_CODE',
				DBtextFieldName: 'AC_PROJECT_NAME',
				api: 'popupService.acProjectPopup',
				app: 'Unilite.app.popup.AcProjectPopup',
				valueFieldWidth: 90,
				textFieldWidth: 140,
				popupWidth:559,
				popupHeight:407,
				pageTitle: '사업코드'
			};
		} else if (sPopItem == 'AC_PROJECT_G' ) {	//회계 -  프로젝트 그리드
			rv = {
				xtype:'uniPopupColumn',
				textFieldName:'AC_PROJECT_NAME',
				DBtextFieldName: 'AC_PROJECT_NAME',
				api: 'popupService.acProjectPopup',
				app: 'Unilite.app.popup.AcProjectPopup',
				popupWidth:559,
				popupHeight:407,
				pageTitle: '사업코드'
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
				popupWidth:725,
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
				popupWidth:725,
				popupHeight:450,
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
				valueFieldWidth: 90,
				textFieldWidth: 140,
				popupWidth:699,
				popupHeight:446,
				pageTitle: '신용카드번호'
			};
		} else if (sPopItem == 'CREDIT_NO_G' ) {		//회계 - 신용카드번호
			rv = {
				xtype:'uniPopupColumn',
				fieldLabel : '신용카드번호',
				textFieldName:'CREDIT_NO_NAME',
				DBtextFieldName: 'CREDIT_NO_NAME',
				api: 'popupService.creditNoPopup',
				app: 'Unilite.app.popup.CreditNoPopup',
				valueFieldWidth: 90,
				textFieldWidth: 140,
				popupWidth:699,
				popupHeight:446,
				pageTitle: '신용카드번호'
			};
		} else if (sPopItem == 'CREDIT_CARD_G' ) {	//회계 -  신용카드번호 그리드
			rv = {
				xtype:'uniPopupColumn',
				textFieldName:'CREDIT_CARD_NAME',
				DBtextFieldName: 'CREDIT_CARD_NAME',
				api: 'popupService.creditCardPopup',
				app: 'Unilite.app.popup.CreditCardPopup',
				popupWidth:699,
				popupHeight:446,
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
				popupWidth:579,
				popupHeight:407,
				pageTitle: '매입매출구분'
			};
		} else if (sPopItem == 'PUR_SALE_TYPE_G' ) {	//회계 -  매입매출구분 그리드
			rv = {
				xtype:'uniPopupColumn',
				textFieldName:'PUR_SALE_TYPE_NAME',
				DBtextFieldName: 'PUR_SALE_TYPE_NAME',
				api: 'popupService.purSaleTypePopup',
				app: 'Unilite.app.popup.PurSaleTypePopup',
				popupWidth:579,
				popupHeight:407,
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
				popupWidth:579,
				popupHeight:407,
				pageTitle: '증빙유형'
			};
		} else if (sPopItem == 'PROOF_G' ) {	//회계 -  증빙유형 그리드
			rv = {
				xtype:'uniPopupColumn',
				textFieldName:'PROOF_NAME',
				DBtextFieldName: 'PROOF_NAME',
				api: 'popupService.proofPopup',
				app: 'Unilite.app.popup.ProofPopup',
				popupWidth:579,
				popupHeight:407,
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
				popupWidth:579,
				popupHeight:407,
				pageTitle: '전자발행여부'
			};
		} else if (sPopItem == 'EMISSION_G' ) {	//회계 - 전자발행여부 그리드
			rv = {
				xtype:'uniPopupColumn',
				textFieldName:'EMISSION_NAME',
				DBtextFieldName: 'EMISSION_NAME',
				api: 'popupService.emissionPopup',
				app: 'Unilite.app.popup.EmissionPopup',
				popupWidth:579,
				popupHeight:407,
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
				popupWidth:675,
				popupHeight:430,
				pageTitle: '통장번호'
			};
		} else if (sPopItem == 'BOOK_CODE' ) {		//회계 -거래처계좌 코드
			rv = {
				xtype:'uniPopupField',
				fieldLabel : '거래처계좌번호',
				valueFieldName:'BOOK_CODE',
				textFieldName:'BOOK_NAME',
				DBvalueFieldName: 'BOOK_CODE',
				DBtextFieldName: 'BOOK_NAME',
				api: 'popupService.bankBookCodePopup',
				app: 'Unilite.app.popup.BankBookCodePopup',
				valueFieldWidth: 60,
				textFieldWidth: 170,
				popupWidth:675,
				popupHeight:430,
				pageTitle: '거래처계좌번호'
			};
		} else if (sPopItem == 'BOOK_CODE_G' ) {		//회계 -거래처계좌 코드
			rv = {
				xtype:'uniPopupColumn',
				//fieldLabel : '거래처계좌번호',
				textFieldName:'BOOK_NAME',
				DBtextFieldName: 'BOOK_NAME',
				api: 'popupService.bankBookCodePopup',
				app: 'Unilite.app.popup.BankBookCodePopup',
				valueFieldWidth: 60,
				textFieldWidth: 170,
				popupWidth:675,
				popupHeight:430,
				pageTitle: '거래처계좌번호'
			};
		} else if (sPopItem == 'BANK_BOOK_G' ) {	//회계 -  통장번호 그리드
			rv = {
				xtype:'uniPopupColumn',
				textFieldName:'BANK_BOOK_NAME',
				DBtextFieldName: 'BANK_BOOK_NAME',
				api: 'popupService.bankBookPopup',
				app: 'Unilite.app.popup.BankBookPopup',
				popupWidth:675,
				popupHeight:430,
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
				popupWidth:823,
				popupHeight:550,
				pageTitle: '차입금번호'
			};
		} else if (sPopItem == 'DEBT_NO_G' ) {	//회계 -  차입금번호 그리드
			rv = {
				xtype:'uniPopupColumn',
				textFieldName:'DEBT_NO_NAME',
				DBtextFieldName: 'DEBT_NO_NAME',
				api: 'popupService.debtNoPopup',
				app: 'Unilite.app.popup.DebtNoPopup',
				popupWidth:823,
				popupHeight:450,
				pageTitle: '차입금번호'
			};
		} else if (sPopItem == 'BANK_ACCNT' ) {		//회계 - 계좌번호
			rv = {
				xtype:'uniPopupField',
				fieldLabel : '계좌번호',
				valueFieldName:'BANK_ACCNT_CODE',
				textFieldName:'BANK_ACCNT_CODE',
				DBvalueFieldName: 'BANK_ACCNT_CODE',
				DBtextFieldName: 'BANK_ACCNT_CODE',
				api: 'popupService.bankAccntPopup',
				app: 'Unilite.app.popup.BankAccntPopup',
				textFieldOnly: true,
				textFieldWidth: 150,
				popupWidth:719,
				popupHeight:450,
				pageTitle: '계좌번호'
			};
		} else if (sPopItem == 'BANK_ACCNT_G' ) {	//회계 -  계좌번호 그리드
			rv = {
				xtype:'uniPopupColumn',
				textFieldName:'BANK_ACCNT_CODE',
				DBtextFieldName: 'BANK_ACCNT_CODE',
				api: 'popupService.bankAccntPopup',
				app: 'Unilite.app.popup.BankAccntPopup',
				popupWidth:750,
				popupHeight:450,
				pageTitle: '계좌번호'
			};
		} else if (sPopItem == 'BUSINESS_BANK' ) {		//회계 - 거래은행
			rv = {
				xtype:'uniPopupField',
				fieldLabel : '거래은행',
				valueFieldName:'BUSINESS_BANK_CODE',
				textFieldName:'BUSINESS_BANK_NAME',
				DBvalueFieldName: 'BUSINESS_BANK_CODE',
				DBtextFieldName: 'BUSINESS_BANK_NAME',
				api: 'popupService.businessBankPopup',
				app: 'Unilite.app.popup.BusinessBankPopup',
				valueFieldWidth: 60,
				textFieldWidth: 170,
				popupWidth:480,
				popupHeight:520,
				pageTitle: '거래은행'
			};
		} else if (sPopItem == 'MONEY_UNIT' ) {		//회계 - 통화코드
			rv = {
				xtype:'uniPopupField',
				fieldLabel : '통화코드',
				valueFieldName:'MONEY_UNIT',
				textFieldName:'MONEY_UNIT',
				DBvalueFieldName: 'MONEY_UNIT',
				DBtextFieldName: 'MONEY_UNIT',
				api: 'popupService.moneyUnitPopup',
				app: 'Unilite.app.popup.MoneyUnitPopup',
				textFieldOnly: true,
				textFieldWidth: 150,
				popupWidth:719,
				popupHeight:450,
				pageTitle: '통화코드'
			};
		} else if (sPopItem == 'MONEY_UNIT_G' ) {	//회계 -  통화코드 그리드
			rv = {
				xtype:'uniPopupColumn',
				textFieldName:'MONEY_UNIT',
				DBtextFieldName: 'MONEY_UNIT',
				api: 'popupService.moneyUnitPopup',
				app: 'Unilite.app.popup.MoneyUnitPopup',
				popupWidth:550,
				popupHeight:430,
				pageTitle: '통화코드'
			};
		} else if (sPopItem == 'BUDG' ) {	//회계 -  예산과목
			rv = {
				xtype:'uniPopupField', 					// applyextparam: ADD_QUERY, ACCNT
				valueFieldName:'BUDG_CODE',
				textFieldName:'BUDG_NAME_L1',
				DBvalueFieldName: 'BUDG_CODE',
				DBtextFieldName: 'BUDG_NAME_L1',
				api: 'popupService.budgPopup',
				app: 'Unilite.app.popup.BudgPopup',
				valueFieldWidth: 90,
				textFieldWidth: 140,
				popupWidth:936,
				popupHeight:650,
				pageTitle: '예산과목'
			};
		} else if (sPopItem == 'BUDG_G' ) {	//회계 -  예산과목 그리드
			rv = {
				xtype:'uniPopupColumn',  				// applyextparam: ADD_QUERY, ACCNT
				textFieldName:'BUDG_NAME_L1',
				DBtextFieldName: 'BUDG_NAME_L1',
				api: 'popupService.budgPopup',
				app: 'Unilite.app.popup.BudgPopup',
				pageTitle: '예산과목'

			};
		} else if (sPopItem == 'PAY_CUSTOM' ) {		//회계 - 지급처
			rv = {
				xtype:'uniPopupField',
				fieldLabel : '지급처',
				valueFieldName:'PAY_CUSTOM_CODE',
				textFieldName:'PAY_CUSTOM_NAME',
				DBvalueFieldName: 'PAY_CUSTOM_CODE',
				DBtextFieldName: 'PAY_CUSTOM_NAME',
				api: 'popupService.payCustomPopup',
				app: 'Unilite.app.popup.PayCustomPopup',
				valueFieldWidth: 60,
				textFieldWidth: 170,
				popupWidth:675,
				popupHeight:430,
				pageTitle: '지급처'
			};
		} else if (sPopItem == 'PAY_CUSTOM_G' ) {	//회계 -  지급처 그리드
			rv = {
				xtype:'uniPopupColumn',
				textFieldName:'PAY_CUSTOM_NAME',
				DBtextFieldName: 'PAY_CUSTOM_NAME',
				api: 'popupService.payCustomPopup',
				app: 'Unilite.app.popup.PayCustomPopup',
				popupWidth:550,
				popupHeight:430,
				pageTitle: '지급처'
			};
		} else if (sPopItem == 'COMP' ) {
			rv = {
				xtype:'uniPopupField',
				fieldLabel : '회사정보',
				valueFieldName:'COMP_CODE',
				textFieldName:'COMP_NAME',
				DBvalueFieldName: 'COMP_CODE',
				DBtextFieldName: 'COMP_NAME',
				api: 'popupService.compPopup',
				app: 'Unilite.app.popup.CompPopup',
				popupWidth:550,
				popupHeight:400,
				valueFieldWidth: 60,
				textFieldWidth: 170,
				useyn:this._setUseYn() ,
				pageTitle: '회사정보'
			};
		} else if (sPopItem == 'COMP_G' ) {
			rv = {
				xtype:'uniPopupColumn',
				textFieldName:'COMP_NAME',
				DBtextFieldName: 'COMP_NAME',
				api: 'popupService.compPopup',
				app: 'Unilite.app.popup.CompPopup',
				popupWidth:650,
				popupHeight:400,
				pageTitle: '회사정보'
			};
		}
		else if (sPopItem == 'CONF_RECE' ) {
			rv = {
				xtype:'uniPopupField',
				fieldLabel : '채권번호',
				valueFieldName:'CONF_RECE_NO',
				textFieldName:'CONF_RECE_CUSTOM_NAME',
				DBvalueFieldName: 'CONF_RECE_NO',
				DBtextFieldName: 'CONF_RECE_CUSTOM_NAME',
				api: 'popupService.confRecePopup',
				app: 'Unilite.app.popup.ConfRecePopup',
				popupWidth:550,
				popupHeight:400,
				valueFieldWidth: 100,
				textFieldWidth: 130,
				useyn:this._setUseYn() ,
				pageTitle: '채권번호'
			};
		} else if (sPopItem == 'CONF_RECE_G' ) {
			rv = {
				xtype:'uniPopupColumn',
				textFieldName:'CONF_RECE_CUSTOM_NAME',
				DBtextFieldName: 'CONF_RECE_CUSTOM_NAME',
				api: 'popupService.confRecePopup',
				app: 'Unilite.app.popup.ConfRecePopup',
				popupWidth:650,
				popupHeight:400,
				pageTitle: '채권번호'
			};
		} else if (sPopItem == 'ADVM_REQ_SLIP_NO' ) {		//조인스(가지급전표) - TB_ES_ADV_HD 테이블 필요
			rv = {
				xtype:'uniPopupField', // 일반 Form용
				fieldLabel : '가지급전표',
				textFieldOnly: true,
				textFieldName:'ADVM_REQ_SLIP_NO',
				DBtextFieldName: 'ADVM_REQ_SLIP_NO',
				api: 'popupService.advmReqSlipNo',
				app: 'Unilite.app.popup.AdvmReqSlipNo',
				//popupPage: '/com/popup/bk/CustPopup.do',
				valueFieldWidth: 60,
				textFieldWidth: 170,
				pageTitle: '가지급전표'
			};
		} else if (sPopItem == 'ADVM_REQ_SLIP_NO_G' ) {		//조인스(가지급전표) - TB_ES_ADV_HD 테이블 필요
			rv = {
				xtype:'uniPopupColumn',	 // Grid용
				textFieldName:'ADVM_REQ_SLIP_NO',
				DBtextFieldName: 'ADVM_REQ_SLIP_NO',
				api: 'popupService.advmReqSlipNo',
				app: 'Unilite.app.popup.AdvmReqSlipNo',
				//popupPage: '/com/popup/bk/CustPopup.do',
				pageTitle: '가지급전표'
			};
		} else if (sPopItem == 'COMMON' ) {		//공통코드 팝업
			rv = {
				xtype:'uniPopupField',
				fieldLabel : '공통코드',
				valueFieldName:'COMMON_CODE',
				textFieldName:'COMMON_NAME',
				DBvalueFieldName: 'COMMON_CODE',
				DBtextFieldName: 'COMMON_NAME',
				api: 'popupService.commonPopup',
				app: 'Unilite.app.popup.CommonPopup',
				valueFieldWidth: 60,
				textFieldWidth: 170,
				popupWidth:579,
				popupHeight:407,
				pageTitle: '공통코드'
			};
		} else if (sPopItem == 'COMMON_G' ) {		//공통코드 팝업
			rv = {
				xtype:'uniPopupColumn',
				fieldLabel : '공통코드',
				textFieldName:'COMMON_NAME',
				DBtextFieldName: 'COMMON_NAME',
				api: 'popupService.commonPopup',
				app: 'Unilite.app.popup.CommonPopup',
				textFieldWidth: 170,
				popupWidth:579,
				popupHeight:407,
				pageTitle: '공통코드'
			};
		} else if (sPopItem == 'USER_DEFINE' ) {		//사용자 정의 팝업
			rv = {
				xtype:'uniPopupField',
				fieldLabel : '사용자 정의 팝업',
				valueFieldName:'USER_DEFINE_CODE',
				textFieldName:'USER_DEFINE_NAME',
				DBvalueFieldName: 'USER_DEFINE_CODE',
				DBtextFieldName: 'USER_DEFINE_NAME',
				api: 'popupService.userDefinePopup',
				app: 'Unilite.app.popup.UserDefinePopup',
				valueFieldWidth: 60,
				textFieldWidth: 170,
				popupWidth:725,
				popupHeight:455,
				pageTitle: '사용자 정의 팝업'
			};
		}	else if (sPopItem == 'USER_DEFINE_G' ) {		//사용자 정의 팝업
			rv = {
				xtype:'uniPopupColumn',
				//fieldLabel : '사용자 정의 팝업',
				textFieldName:'USER_DEFINE_NAME',
				DBtextFieldName: 'USER_DEFINE_NAME',
				api: 'popupService.userDefinePopup',
				app: 'Unilite.app.popup.UserDefinePopup',
				valueFieldWidth: 60,
				textFieldWidth: 170,
				popupWidth:725,
				popupHeight:455,
				pageTitle: '사용자 정의 팝업'
			};
		} else if (sPopItem == 'DEPTTREE' ) {		//부서조직도 팝업
			rv = {
				xtype:'uniPopupField',
				fieldLabel : '부서조직도',
				valueFieldName:'DEPT_CODE',
				textFieldName:'DEPT_NAME',
				DBvalueFieldName: 'TREE_CODE',
				DBtextFieldName: 'TREE_NAME',
				api: 'popupService.selectList',
				app: 'Unilite.app.popup.DeptTree',
				valueFieldWidth: 60,
				textFieldWidth: 170,
				popupWidth:400,
				popupHeight:400,
				useyn:this._setUseYn() ,
				pageTitle: '부서조직도'
			};

		} else if (sPopItem == 'PJT_TREE' ) {		//사업코드 등록 프로그램용 트리 팝업 (조회용)
			rv = {
				xtype:'uniPopupField',
				fieldLabel : '사업코드',
				valueFieldName:'PJT_CODE',
				textFieldName:'PJT_NAME',
				DBvalueFieldName: 'PJT_CODE',
				DBtextFieldName: 'PJT_NAME',
				api: 'popupService.selectList',
				app: 'Unilite.app.popup.PjtTree',
				valueFieldWidth: 60,
				textFieldWidth: 170,
				popupWidth:400,
				popupHeight:400,
				pageTitle: '사업코드'
			};
		} else if (sPopItem == 'PJT_NONTREE' ) {		//사업코드 팝업 (입력용)
			rv = {
				xtype:'uniPopupField',
				fieldLabel : '사업코드',
				valueFieldName:'PJT_CODE',
				textFieldName: 'PJT_NAME',
				DBvalueFieldName: 'PJT_CODE',
				DBtextFieldName: 'PJT_NAME',
				api: 'popupService.pjtPopupW',
				app: 'Unilite.app.popup.PjtNonTreePopup',
				valueFieldWidth: 60,
				textFieldWidth: 170,
				popupWidth:400,
				popupHeight:400,
				pageTitle: '사업코드'
			};
		} else if (sPopItem == 'PJT_TREE_G' ) {		//사업코드 트리 팝업 (그리드)
			rv = {
				xtype:'uniPopupColumn',
				textFieldName:'PJT_CODE',
				DBtextFieldName: 'PJT_CODE',
				api: 'popupService.pjtPopupW',
				app: 'Unilite.app.popup.PjtTreeGPopup',
				popupWidth:670,
				popupHeight:450,
				pageTitle: '사업코드'
			};
		} else if (sPopItem == 'CLAIM_G' ) {
			rv = {
				xtype:'uniPopupColumn', // 일반 Form용
				textFieldName:'CLAIM_NO',
				DBtextFieldName: 'CLAIM_NO',
				api: 'popupService.claimPopup',
				app: 'Unilite.app.popup.ClaimPopup',
				//popupPage: '/com/popup/bk/ItemPopup.do',
				popupWidth:700,
				popupHeight:450,
				pageTitle: '클레임정보'
			};
		}	else if (sPopItem == 'NONTAX_CODE' ) {		//인사 - 비과세코드
			rv = {										// applyextparam: PAY_YM_FR
				xtype:'uniPopupField',
				fieldLabel : '비과세코드',
				valueFieldName:'',
				textFieldName:'NONTAX_CODE_NAME',
				DBvalueFieldName: 'NONTAX_CODE',
				DBtextFieldName: 'NONTAX_CODE_NAME',
				api: 'popupService.nonTaxPopup',
				app: 'Unilite.app.popup.NonTaxPopup',
				valueFieldWidth: 60,
				textFieldWidth: 170,
				popupWidth:670,
				popupHeight:450,
				pageTitle: '비과세코드'
			};
		} else if (sPopItem == 'NONTAX_CODE_G' ) {	//인사 -  비과세코드 그리드
			rv = {
				xtype:'uniPopupColumn',
				textFieldName:'NONTAX_CODE',
				DBtextFieldName: 'NONTAX_CODE',
				api: 'popupService.nonTaxPopup',
				app: 'Unilite.app.popup.NonTaxPopup',
				popupWidth:670,
				popupHeight:450,
				pageTitle: '비과세코드'
			};
		} else if (sPopItem == 'PAY_GRADE' ) {		//인사  - 급호
			rv = {
				xtype:'uniPopupField',
				fieldLabel : '급호',
				valueFieldName:'PAY_GRADE_01',
				textFieldName:'PAY_GRADE_02',
				DBvalueFieldName: 'PAY_GRADE_01',
				DBtextFieldName: 'PAY_GRADE_02',
				api: 'popupService.payGradePopup',
				app: 'Unilite.app.popup.PayGradePopup',
				valueFieldWidth: 90,
				textFieldWidth: 140,
				popupWidth:559,
				popupHeight:407,
				pageTitle: '급호봉조회'
			};
		} else if (sPopItem == 'PAY_GRADE_G' ) {	//인사 -  급호  그리드
			rv = {
				xtype:'uniPopupColumn',
				textFieldName:'PAY_GRADE_02',
				DBtextFieldName: 'PAY_GRADE_02',
				api: 'popupService.payGradePopup',
				app: 'Unilite.app.popup.PayGradePopup',
				popupWidth:559,
				popupHeight:407,
				pageTitle: '급호봉조회'
			};
		} /*else if (sPopItem == 'TEMPLATE' ) {		//템플릿 팝업
			rv = {
				xtype:'uniPopupField',
				fieldLabel : 'TEPLETE 팝업',
				valueFieldName:'TMP_CD',
				textFieldName:'TMP_NM',
				DBvalueFieldName: 'TMP_CD',
				DBtextFieldName: 'TMP_NM',
				api: 'popupService.templatePopup',
				app: 'Unilite.app.popup.templatePopup',
				valueFieldWidth: 60,
				textFieldWidth: 170,
				popupWidth:725,
				popupHeight:455,
				pageTitle: 'TEMPLATE'
			};
		}	else if (sPopItem == 'TEMPLATE_G' ) {		//템플릿 팝업 그리드
			rv = {
				xtype:'uniPopupColumn',
//				fieldLabel : '사용자 정의 팝업',
				textFieldName:'TMP_NM',
				DBtextFieldName: 'TMP_NM',
				api: 'popupService.templatePopup',
				app: 'Unilite.app.popup.templatePopup',
				valueFieldWidth: 60,
				textFieldWidth: 170,
				popupWidth:725,
				popupHeight:455,
				pageTitle: 'TEMPLATE'
			};
		}*/	else if (sPopItem == 'IFRS_ASSET' ) {		//IFRS - 자산코드
			rv = {
				xtype:'uniPopupField',
				fieldLabel : '자산코드',
				valueFieldName:'ASSET_CODE',
				textFieldName:'ASSET_NAME',
				DBvalueFieldName: 'ASSET_CODE',
				DBtextFieldName: 'ASSET_NAME',
				api: 'popupService.IFRSassetPopup',
				app: 'Unilite.app.popup.IFRSAssetPopup',
				valueFieldWidth: 90,
				textFieldWidth: 140,
				popupWidth:725,
				popupHeight:447,
				pageTitle: '자산코드'
			};
		} else if (sPopItem == 'IFRS_ASSET_G' ) {	//IFRS - 자산코드 그리드
			rv = {
				xtype:'uniPopupColumn',
				textFieldName:'ASSET_NAME',
				DBtextFieldName: 'ASSET_NAME',
				api: 'popupService.IFRSassetPopup',
				app: 'Unilite.app.popup.IFRSAssetPopup',
				popupWidth:725,
				popupHeight:447,
				pageTitle: '자산코드'
			};
		} else if (sPopItem == 'PURCHASE_CARD' ) {		//IFRS - 자산코드
			rv = {
				xtype:'uniPopupField',
				fieldLabel : '구매카드정보',
				valueFieldName:'PURCHASE_CARD_NUM',
				textFieldName:'PURCHASE_CARD_NAME',
				DBvalueFieldName: 'PURCHASE_CARD_NUM',
				DBtextFieldName: 'PURCHASE_CARD_NAME',
				api: 'popupService.purchaseCardPopup',
				app: 'Unilite.app.popup.PurchaseCardPopup',
				valueFieldWidth: 90,
				textFieldWidth: 140,
				popupWidth:500,
				popupHeight:447,
				pageTitle: '구매카드정보'
			};
		} else if (sPopItem == 'COM_ABA210' ) {		//회계 - ABA210에서 관리항목 가져오는 팝업(AC_CD 변수로 넘김)
			rv = {
				xtype			: 'uniPopupField',
				fieldLabel		: 'COMMON ABA210',
				valueFieldName	: 'COM_ABA210_CODE',
				textFieldName	: 'COM_ABA210_NAME',
				DBvalueFieldName: 'COM_ABA210_CODE',
				DBtextFieldName	: 'COM_ABA210_NAME',
				api				: 'popupService.comAba210Popup',
				app				: 'Unilite.app.popup.ComAba210Popup',
				valueFieldWidth	: 60,
				textFieldWidth	: 170,
				popupWidth		: 720,
				popupHeight		: 450,
				pageTitle		: '관리항목'
			};
		} else if (sPopItem == 'COM_ABA210_G' ) {	//회계 그리드 - ABA210에서 관리항목 가져오는 팝업(AC_CD 변수로 넘김)
			rv = {
				xtype			: 'uniPopupColumn',
				textFieldName	: 'COM_ABA210_NAME',
				DBtextFieldName	: 'COM_ABA210_NAME',
				api				: 'popupService.comAba210Popup',
				app				: 'Unilite.app.popup.ComAba210Popup',
				popupWidth		: 720,
				popupHeight		: 450,
				pageTitle		: '관리항목'
			};
		} else if (sPopItem == 'COM_ABA900_G' ) {	//회계 그리드 - ABA900에서 미결항목 가져오는 팝업
			rv = {
					xtype			: 'uniPopupColumn',
					textFieldName	: 'COM_ABA900_NAME',
					DBtextFieldName	: 'COM_ABA900_NAME',
					api				: 'popupService.comAba900Popup',
					app				: 'Unilite.app.popup.ComAba900Popup',
					popupWidth		: 720,
					popupHeight		: 450,
					pageTitle		: '미결항목'
				};
		} else if (sPopItem == 'CIPHER_CARDNO' ) {
			rv = {
				xtype:'uniPopupField',
				fieldLabel : '카드번호',
				textFieldOnly: true,
				textFieldName:'DECRYP_WORD',
				DBtextFieldName: 'DECRYP_WORD',
				api: 'popupService.incryptDecryptPopup',
				app: 'Unilite.app.popup.CipherCardNoPopup',
				popupWidth:388,
				popupHeight:140,
				valueFieldWidth: 60,
				textFieldWidth: 170,
				pageTitle: '카드번호 암복호화'
			};
		} else if (sPopItem == 'CIPHER_CARDNO_G' ) {
			rv = {
				xtype:'uniPopupColumn',
				textFieldName:'DECRYP_WORD',
				DBtextFieldName: 'DECRYP_WORD',
				api: 'popupService.incryptDecryptPopup',
				app: 'Unilite.app.popup.CipherCardNoPopup',
				popupWidth:388,
				popupHeight:140,
				valueFieldWidth: 60,
				textFieldWidth: 170,
				pageTitle: '카드번호 암복호화'
			};
		} else if (sPopItem == 'CIPHER_REPRENO' ) {
			rv = {
				xtype:'uniPopupField',
				textFieldOnly: true,
				textFieldName:'DECRYP_WORD',
				DBtextFieldName: 'DECRYP_WORD',
				api: 'popupService.incryptDecryptPopup',
				app: 'Unilite.app.popup.CipherRepreNoPopup',
				popupWidth:388,
				popupHeight:140,
				valueFieldWidth: 60,
				textFieldWidth: 170,
				pageTitle: '주민번호 암복호화'
			};
		} else if (sPopItem == 'CIPHER_REPRENO_G' ) {
			rv = {
				xtype:'uniPopupColumn',
				textFieldName:'DECRYP_WORD',
				DBtextFieldName: 'DECRYP_WORD',
				api: 'popupService.incryptDecryptPopup',
				app: 'Unilite.app.popup.CipherRepreNoPopup',
				popupWidth:388,
				popupHeight:140,
				valueFieldWidth: 60,
				textFieldWidth: 170,
				pageTitle: '주민번호 암복호화'
			};
		} else if (sPopItem == 'CIPHER_BANKACCNT' ) {
			rv = {
				xtype:'uniPopupField',
				//fieldLabel : '계좌번호',
				textFieldOnly: true,
				textFieldName:'DECRYP_WORD',
				DBtextFieldName: 'DECRYP_WORD',
				api: 'popupService.incryptDecryptPopup',
				app: 'Unilite.app.popup.CipherBankAccntPopup',
				popupWidth:388,
				popupHeight:140,
				valueFieldWidth: 60,
				textFieldWidth: 170,
				pageTitle: '계좌번호 암복호화'
			};
		} else if (sPopItem == 'CIPHER_BANKACCNT_G' ) {
			rv = {
				xtype:'uniPopupColumn',
				//fieldLabel : '계좌번호',
				//textFieldOnly: true,
				textFieldName:'DECRYP_WORD',
				DBtextFieldName: 'DECRYP_WORD',
				api: 'popupService.incryptDecryptPopup',
				app: 'Unilite.app.popup.CipherBankAccntPopup',
				popupWidth:388,
				popupHeight:140,
				//valueFieldWidth: 60,
				//textFieldWidth: 170,
				pageTitle: '계좌번호 암복호화'


			};
		} else if (sPopItem == 'CIPHER_FOREIGNNO' ) {
			rv = {
				xtype:'uniPopupField',
				fieldLabel : '외국인등록번호',
				textFieldOnly: true,
				textFieldName:'DECRYP_WORD',
				DBtextFieldName: 'DECRYP_WORD',
				api: 'popupService.incryptDecryptPopup',
				app: 'Unilite.app.popup.CipherForeignNoPopup',
				popupWidth:388,
				popupHeight:140,
				valueFieldWidth: 60,
				textFieldWidth: 170,
				pageTitle: '외국인등록번호 암복호화'


			};
		} else if (sPopItem == 'CIPHER_PASSWORD_G' ) {
			rv = {

				xtype:'uniPopupColumn',
				//fieldLabel : '계좌번호',
				//textFieldOnly: true,
				textFieldName:'DECRYP_WORD',
				DBtextFieldName: 'DECRYP_WORD',
				api: 'popupService.incryptDecryptPopup',
				app: 'Unilite.app.popup.CipherPassWordPopup',
				popupWidth:388,
				popupHeight:140,
				//valueFieldWidth: 60,
				//textFieldWidth: 170,
				pageTitle: '비밀번호 암복호화'

			};
		} else if (sPopItem == 'BUDG_KOCIS' ) {  //KOCIS(해외문화홍보원) -  예산과목
			rv = {
				xtype:'uniPopupField',				  // applyextparam: ADD_QUERY, ACCNT
				valueFieldName:'BUDG_CODE',
				textFieldName:'BUDG_NAME',
				DBvalueFieldName: 'BUDG_CODE',
				DBtextFieldName: 'BUDG_NAME',
				api: 'popupService.budgKocisPopup',
				app: 'Unilite.app.popup.BudgKocisPopup',
				valueFieldWidth: 90,
				textFieldWidth: 140,
				popupWidth:936,
				popupHeight:650,
				pageTitle: '예산과목'
			};
		} else if (sPopItem == 'BUDG_KOCIS_G' ) { //KOCIS(해외문화홍보원) -  예산과목 그리드
			rv = {
				xtype:'uniPopupColumn',				 // applyextparam: ADD_QUERY, ACCNT
				textFieldName:'BUDG_NAME',
				DBtextFieldName: 'BUDG_NAME',
				api: 'popupService.budgKocisPopup',
				app: 'Unilite.app.popup.BudgKocisPopup',
				pageTitle: '예산과목',
				popupWidth:1100,
				popupHeight:650

			};
		} else if (sPopItem == 'BUDG_KOCIS_NORMAL' ) {  //KOCIS(해외문화홍보원) -  예산과목-normal
			rv = {
				xtype:'uniPopupField',				  // applyextparam: ADD_QUERY, ACCNT
				valueFieldName:'BUDG_CODE',
				textFieldName:'BUDG_NAME',
				DBvalueFieldName: 'BUDG_CODE',
				DBtextFieldName: 'BUDG_NAME',
				api: 'popupService.budgKocisNormalPopup',
				app: 'Unilite.app.popup.BudgKocisNormalPopup',
				valueFieldWidth: 90,
				textFieldWidth: 140,
//					popupWidth:936,
//					popupHeight:650,
				pageTitle: '예산과목'
			};
		} else if (sPopItem == 'BUDG_KOCIS_NORMAL_G' ) { //KOCIS(해외문화홍보원) -  예산과목-normal 그리드
			rv = {
				xtype:'uniPopupColumn',				 // applyextparam: ADD_QUERY, ACCNT
				textFieldName:'BUDG_NAME',
				DBtextFieldName: 'BUDG_NAME',
				api: 'popupService.budgKocisNormalPopup',
				app: 'Unilite.app.popup.BudgKocisNormalPopup',
				pageTitle: '예산과목',
				popupWidth:500,
				popupHeight:500

			};
		} else if (sPopItem == 'CUST_KOCIS' ) {  //KOCIS(해외문화홍보원) -  거래처
			rv = {
				xtype:'uniPopupField',				  // applyextparam: ADD_QUERY, ACCNT
				valueFieldName:'CUST_CODE',
				textFieldName:'CUST_NAME',
				DBvalueFieldName: 'CUSTOM_CODE',
				DBtextFieldName: 'CUSTOM_NAME',
				api: 'popupService.custKocisPopup',
				app: 'Unilite.app.popup.CustKocisPopup',
				valueFieldWidth: 90,
				textFieldWidth: 140,
//						popupWidth:936,
//						popupHeight:650,
				pageTitle: '거래처'
			};
		} else if (sPopItem == 'CUST_KOCIS_G' ) { //KOCIS(해외문화홍보원) -  거래처 그리드
			rv = {
				xtype:'uniPopupColumn',				 // applyextparam: ADD_QUERY, ACCNT
				textFieldName:'CUST_NAME',
				DBtextFieldName: 'CUSTOM_NAME',
				api: 'popupService.custKocisPopup',
				app: 'Unilite.app.popup.CustKocisPopup',
				pageTitle: '거래처'
//						popupWidth:1100,
//						popupHeight:650

			};
		} else if (sPopItem == 'ART_KOCIS' ) {  //KOCIS(해외문화홍보원) -  미술품
			rv = {
				xtype:'uniPopupField',				  // applyextparam: ADD_QUERY, ACCNT
				valueFieldName:'ITEM_CODE',
				textFieldName:'ITEM_NAME',
				DBvalueFieldName: 'ITEM_CODE',
				DBtextFieldName: 'ITEM_NAME',
				api: 'popupService.artKocisPopup',
				app: 'Unilite.app.popup.ArtKocisPopup',
				valueFieldWidth: 90,
				textFieldWidth: 140,
				pageTitle: '미술품'
			};
		} else if (sPopItem == 'ART_KOCIS_G' ) { //KOCIS(해외문화홍보원) -  미술품 그리드
			rv = {
				xtype:'uniPopupColumn',				 // applyextparam: ADD_QUERY, ACCNT
				textFieldName:'ITEM_NAME',
				DBtextFieldName: 'ITEM_NAME',
				api: 'popupService.artKocisPopup',
				app: 'Unilite.app.popup.ArtKocisPopup',
				pageTitle: '미술품'

			};
		} else if (sPopItem == 'EQU_CODE' ) {	//금형,설비
			rv = {
				xtype:'uniPopupField',
				valueFieldName:'EQU_CODE',
				textFieldName:'EQU_NAME',
				DBvalueFieldName: 'EQU_CODE',
				DBtextFieldName: 'EQU_NAME',
//					valueFieldOnly: true,
				api: 'popupService.equCodePopup',
				app: 'Unilite.app.popup.EquCodePopup',
				popupWidth:936,
				popupHeight:650,
				valueFieldWidth: 60,
				textFieldWidth: 170,
				pageTitle: '장비번호'
			};
		} else if (sPopItem == 'EQU_CODE_G' ) {	// //금형,설비
			rv = {
				xtype:'uniPopupColumn',	 // Grid용
				textFieldName:'EQU_NAME',
				DBtextFieldName: 'EQU_NAME',
				api: 'popupService.equCodePopup',
				app: 'Unilite.app.popup.EquCodePopup',
				//popupPage: '/com/popup/bk/CustPopup.do',
				pageTitle: '장비번호'
			};
		} else if (sPopItem == 'EQU_MACH_CODE' ) {	   // 설비정보_정규
			rv = {
				xtype:'uniPopupField', // 일반 Form용
				fieldLabel : '설비정보',
				valueFieldName:'EQU_MACH_CODE',
				textFieldName:'EQU_MACH_NAME',
				DBvalueFieldName: 'EQU_MACH_CODE',
				DBtextFieldName: 'EQU_MACH_NAME',
				api: 'popupService.equMachCodePopup',
				app: 'Unilite.app.popup.EquMachCodePopup',
				valueFieldWidth: 60,
				textFieldWidth: 170,
				pageTitle: '설비정보'
			};
		} else if (sPopItem == 'EQU_MACH_CODE_G' ) {	// 설비정보_정규
			rv = {
				xtype:'uniPopupColumn',	 // Grid용
				textFieldName:'EQU_MACH_NAME',
				DBtextFieldName: 'EQU_MACH_NAME',
				api: 'popupService.equMachCodePopup',
				app: 'Unilite.app.popup.EquMachCodePopup',
				pageTitle: '설비정보'
			};
		} else if (sPopItem == 'EQU_MOLD_CODE' ) {	   // 금형정보_정규
			rv = {
				xtype:'uniPopupField', // 일반 Form용
				fieldLabel : '금형정보',
				valueFieldName:'EQU_MOLD_CODE',
				textFieldName:'EQU_MOLD_NAME',
				DBvalueFieldName: 'EQU_MOLD_CODE',
				DBtextFieldName: 'EQU_MOLD_NAME',
				api: 'popupService.equMoldCodePopup',
				app: 'Unilite.app.popup.EquMoldCodePopup',
				valueFieldWidth: 60,
				textFieldWidth: 170,
				pageTitle: '금형정보'
			};
		} else if (sPopItem == 'EQU_MOLD_CODE_G' ) {	// 금형정보_정규
			rv = {
				xtype:'uniPopupColumn',	 // Grid용
				textFieldName:'EQU_MOLD_NAME',
				DBtextFieldName: 'EQU_MOLD_NAME',
				api: 'popupService.equMoldCodePopup',
				app: 'Unilite.app.popup.EquMoldCodePopup',
				pageTitle: '금형정보'
			};
		} else if (sPopItem == 'CORE_CODE' ) {	   // 코어정보_정규
			rv = {
				xtype:'uniPopupField', // 일반 Form용
				fieldLabel : '코어정보',
				valueFieldName:'CORE_CODE',
				textFieldName:'CORE_NAME',
				DBvalueFieldName: 'CORE_CODE',
				DBtextFieldName: 'CORE_NAME',
				api: 'popupService.coreCodePopup',
				app: 'Unilite.app.popup.CoreCodePopup',
				valueFieldWidth: 60,
				textFieldWidth: 170,
				pageTitle: '코어정보'
			};
		} else if (sPopItem == 'CORE_CODE_G' ) {	// 코어정보_정규
			rv = {
				xtype:'uniPopupColumn',	 // Grid용
				textFieldName:'CORE_NAME',
				DBtextFieldName: 'CORE_NAME',
				api: 'popupService.coreCodePopup',
				app: 'Unilite.app.popup.CoreCodePopup',
				pageTitle: '코어정보'
			};
		} else if (sPopItem == 'TREE_CODE' ) {
			rv = {
				xtype:'uniPopupField',
				fieldLabel : '공구코드',
				valueFieldName:'TREE_CODE',
				textFieldName:'TREE_NAME',
				DBvalueFieldName: 'TREE_CODE',
				DBtextFieldName: 'TREE_NAME',
				api: 'popupService.treeCodePopup',
				app: 'Unilite.app.popup.TreeCodePopup',
				//popupPage: '/com/popup/bk/DeptPopup.do',
				popupWidth:600,
				popupHeight:500,
				valueFieldWidth: 60,
				textFieldWidth: 170,
				pageTitle: '소모공구 정보'
			};
		} else if (sPopItem == 'TREE_CODE_G' ) {	// 그리드용
			rv = {
				xtype:'uniPopupColumn',
				//fieldLabel : '작업장',
				valueFieldName:'TREE_CODE',
				textFieldName:'TREE_NAME',
				DBvalueFieldName: 'TREE_CODE',
				DBtextFieldName: 'TREE_NAME',
				api: 'popupService.treeCodePopup',
				app: 'Unilite.app.popup.TreeCodePopup',
				//popupPage: '/com/popup/bk/DeptPopup.do',
				popupWidth:600,
				popupHeight:500,
				//valueFieldWidth: 60,
				//textFieldWidth: 170,
				pageTitle: '소모공구 정보'
			};
		} else if (sPopItem == 'AS_NUM' ) {
			rv = {
				xtype:'uniPopupField',
				valueFieldName:'AS_NUM',
				textFieldName:'AS_NUM',
				DBvalueFieldName: 'AS_NUM',
				DBtextFieldName: 'AS_NUM',
				textFieldOnly: true,
				api: 'popupService.asNumPopup',
				app: 'Unilite.app.popup.AsNumPopup',
				popupWidth:936,
				popupHeight:650,
				valueFieldWidth: 60,
				textFieldWidth: 170,
				pageTitle: '접수번호 PopUp'
			};
		//SMS 전송 팝업
		} else if (sPopItem == 'SEND_SMS' ) {
			rv = {
				xtype			: 'uniPopupField',
				api				: 'popupService.sendSMS',
				app				: 'Unilite.app.popup.SendSMS',
//				valueFieldName	: 'AS_NUM',
//				textFieldName	: 'AS_NUM',
//				DBvalueFieldName: 'AS_NUM',
//				DBtextFieldName	: 'AS_NUM',
//				textFieldOnly	: true,
				popupWidth		: 936,
				popupHeight		: 650,
//				valueFieldWidth	: 60,
//				textFieldWidth	: 170,
				pageTitle		: 'SMS 전송'
			};
		//농가정보 팝업
		}
		else if (sPopItem == 'FARM_INOUT_G' ) {
			rv = {
				xtype			: 'uniPopupColumn',
				textFieldName	: 'FARM_NAME',
				DBtextFieldName	: 'FARM_NAME',
				api				: 'popupService.farmInout',
				app				: 'Unilite.app.popup.FarmInout',
				popupWidth		: 936,
				popupHeight		: 650,
				pageTitle		: '농가별 입고정보'
			};
		}
		else if (sPopItem == 'M_REG_NUM_KD_G' ) { // 모니터정보(S_ZEE200T_KD) 극동가스케트공업
			rv = {
				xtype:'uniPopupColumn',
				//fieldLabel : '작업장',
				valueFieldName:'M_REG_NUM',
				textFieldName:'M_REG_NAME',
				DBvalueFieldName: 'M_REG_NUM',
				DBtextFieldName: 'M_REG_NAME',
				api: 'popupService.mRegNumPopup',
				app: 'Unilite.app.popup.MregNumPopup',
				//popupPage: '/com/popup/bk/DeptPopup.do',
				popupWidth:900,
				popupHeight:480,
				//valueFieldWidth: 60,
				//textFieldWidth: 170,
				pageTitle: '모니터 정보'
			};
		}
		else if (sPopItem == 'SW_CODE' ) { // SW코드 극동가스케트공업
			rv = {
				xtype:'uniPopupField',
				valueFieldName:'SW_CODE',
				textFieldName:'SW_NAME',
				DBvalueFieldName: 'SW_CODE',
				DBtextFieldName: 'SW_NAME',
				api: 'popupService.swCodePopup',
				app: 'Unilite.app.popup.SwCodePopup',
				//popupPage: '/com/popup/bk/DeptPopup.do',
				popupWidth:500,
				popupHeight:400,
				pageTitle: 'SW정보'
			};
		}
		else if (sPopItem == 'SW_CODE_G' ) { // SW코드 극동가스케트공업
			rv = {
				xtype:'uniPopupColumn',
				valueFieldName:'SW_CODE',
				textFieldName:'SW_NAME',
				DBvalueFieldName: 'SW_CODE',
				DBtextFieldName: 'SW_NAME',
				api: 'popupService.swCodePopup',
				app: 'Unilite.app.popup.SwCodePopup',
				//popupPage: '/com/popup/bk/DeptPopup.do',
				popupWidth:500,
				popupHeight:400,
				pageTitle: 'SW정보'
			};
		}
		else if (sPopItem == 'REQ_NUM2' ) { // 의뢰서번호 극동가스케트공업
			rv = {
				xtype:'uniPopupField',
				valueFieldName:'REQ_NUM',
				textFieldName:'REQ_NUM',
				DBvalueFieldName: 'REQ_NUM',
				DBtextFieldName: 'REQ_NUM',
				api: 'popupService.reqNum2Popup',
				app: 'Unilite.app.popup.ReqNum2Popup',
				//popupPage: '/com/popup/bk/DeptPopup.do',
				popupWidth:850,
				popupHeight:500,
				valueFieldWidth: 60,
				textFieldWidth: 150,
				textFieldOnly: true,
				pageTitle: '의뢰서번호'
			};
		} else if (sPopItem == 'COST_POOL_CBM600T' ) {
			rv = {
					xtype:'uniPopupField',
					fieldLabel : '회계부서',
					valueFieldName:'COST_POOL_CODE',
					textFieldName:'COST_POOL_NAME',
					DBvalueFieldName: 'COST_POOL_CODE',
					DBtextFieldName: 'COST_POOL_NAME',
					api: 'popupService.costPoolCbm600tPopup',
					app: 'Unilite.app.popup.CostPoolCbm600tPopup',
					//popupPage: '/com/popup/bk/BankPopup.do',
					popupWidth:450,
					popupHeight:500,
					valueFieldWidth: 60,
					textFieldWidth: 170,
					pageTitle: '회계부서'
				};
		} else if (sPopItem == 'DIV_PUMOK_YP_G' ) {
			rv = {
				xtype			: 'uniPopupColumn',
				textFieldName	: 'ITEM_NAME',
				DBtextFieldName	: 'ITEM_NAME',
				api				: 'popupService.divPumokPopup_YP',
				app				: 'Unilite.app.popup.DivPumokPopup_YP',
				useyn			: this._setUseYn() ,
				pageTitle		: '사업장별 품목정보(양평)'
			};
		} else if (sPopItem == 'WKORD_NUM_KDG' ) { 		// 작업지시정보_KDG

			rv = {
					xtype:'uniPopupField', // 일반 Form용
					fieldLabel : '작업지시정보',
					textFieldOnly: true,
					textFieldName:'WKORD_NUM',
					DBtextFieldName: 'WKORD_NUM',
					api: 'popupService.wkordNum_KDG',
					app: 'Unilite.app.popup.WkordNum_KDG',
					//popupPage: '/com/popup/bk/CustPopup.do',
					valueFieldWidth: 60,
					textFieldWidth: 170,
					pageTitle: '작업지시정보'
				};

		} else if (sPopItem == 'WOODEN_CODE' ) {	   // 목형정보
			rv = {
				xtype			: 'uniPopupField', // 일반 Form용
				fieldLabel		: '목형정보',
				valueFieldName	: 'WOODEN_CODE',
				textFieldName	: 'SN_NO',
				DBvalueFieldName: 'WOODEN_CODE',
				DBtextFieldName	: 'SN_NO',
				api				: 'popupService.woodenCode',
				app				: 'Unilite.app.popup.WoodenCode',
				valueFieldWidth	: 90,
				textFieldWidth	: 140,
				popupWidth		: 650,
				popupHeight		: 400,
				pageTitle		: '목형정보'
			};
		} else if (sPopItem == 'WOODEN_CODE_G' ) {	// 목형정보
			rv = {
				xtype			: 'uniPopupColumn',	 // Grid용
				textFieldName	: 'SN_NO',
				DBtextFieldName	: 'SN_NO',
				api				: 'popupService.woodenCode',
				app				: 'Unilite.app.popup.WoodenCode',
				pageTitle		: '목형정보'
			};
		} else if (sPopItem == 'WKORD_NUM_JW' ) { 		// 작업지시정보 (제이월드)
			rv = {
				xtype:'uniPopupField', // 일반 Form용
				fieldLabel : '작업지시정보',
				textFieldOnly: true,
				textFieldName:'WKORD_NUM',
				DBtextFieldName: 'WKORD_NUM',
				api: 'popupService.wkordNum_JW',
				app: 'Unilite.app.popup.WkordNum_JW',
				valueFieldWidth: 60,
				textFieldWidth: 170,
				popupWidth		: 1000,
				pageTitle: '작업지시정보'
			};
		} else if (sPopItem == 'WKORD_NUM_JW_G' ) {	// 작업지시정보_G (제이월드)
			rv = {
				xtype:'uniPopupColumn',		// Grid용
				textFieldName:'WKORD_NUM',
				DBtextFieldName: 'WKORD_NUM',
				api: 'popupService.wkordNum_JW',
				app: 'Unilite.app.popup.WkordNum_JW',
				//popupPage: '/com/popup/bk/CustPopup.do',
				pageTitle: '작업지시정보'
			};
		} else if (sPopItem == 'WAREHOUSE' ) {					//창고 팝업
			rv = {
				xtype			: 'uniPopupField',
				fieldLabel		: '창고',
				valueFieldName	: 'TREE_CODE',
				textFieldName	: 'TREE_NAME',
				DBvalueFieldName: 'TREE_CODE',
				DBtextFieldName	: 'TREE_NAME',
				api				: 'popupService.whCodePopup',
				app				: 'Unilite.app.popup.WhCodePopup',
				valueFieldWidth	: 60,
				textFieldWidth	: 170,
				popupWidth		: 600,
				popupHeight		: 500,
				pageTitle		: '창고조회'
			};
		} else if (sPopItem == 'WAREHOUSE_G' ) {				//창고 팝업 그리드용
			rv = {
				xtype			: 'uniPopupColumn',
				valueFieldName	: 'TREE_CODE',
				textFieldName	: 'TREE_NAME',
				DBvalueFieldName: 'TREE_CODE',
				DBtextFieldName	: 'TREE_NAME',
				api				: 'popupService.whCodePopup',
				app				: 'Unilite.app.popup.WhCodePopup',
				popupWidth		: 600,
				popupHeight		: 500,
				pageTitle		: '창고조회'
			};
		} else if (sPopItem == 'PROGRAM' ) {					//창고 팝업
			rv = {
				xtype			: 'uniPopupField',
				fieldLabel		: '프로그램',
				valueFieldName	: 'PGM_ID',
				textFieldName	: 'PGM_NAME',
				DBvalueFieldName: 'PGM_ID',
				DBtextFieldName	: 'PGM_NAME',
				api				: 'popupService.programPopup',
				app				: 'Unilite.app.popup.programPopup',
				valueFieldWidth	: 60,
				textFieldWidth	: 170,
				popupWidth		: 600,
				popupHeight		: 500,
				pageTitle		: '프로그램조회'
			};
		} else if (sPopItem == 'PROGRAM_G' ) {				//창고 팝업 그리드용
			rv = {
				xtype			: 'uniPopupColumn',
				valueFieldName	: 'PGM_ID',
				textFieldName	: 'PGM_NAME',
				DBvalueFieldName: 'PGM_ID',
				DBtextFieldName	: 'PGM_NAME',
				api				: 'popupService.programPopup',
				app				: 'Unilite.app.popup.programPopup',
				popupWidth		: 600,
				popupHeight		: 500,
				pageTitle		: '프로그램조회'
			};
		} else if (sPopItem == 'CHEMICAL_G' ) {				//성분팝업 그리드용
			rv = {
				xtype			: 'uniPopupColumn',
				valueFieldName	: 'CHEMICAL_CODE',
				textFieldName	: 'CHEMICAL_NAME',
				DBvalueFieldName: 'CHEMICAL_CODE',
				DBtextFieldName	: 'CHEMICAL_NAME',
				api				: 'popupService.chemicalPopup',
				app				: 'Unilite.app.popup.chemicalPopup',
				popupWidth		: 600,
				popupHeight		: 500,
				pageTitle		: '성분 조회'
			};
		} else if (sPopItem == 'LAB_NO' ) {	//LABNO 팝업
			rv = {
				xtype:'uniPopupField',
				fieldLabel: 'LAB NO',
				valueFieldName:'LAB_NO',
				textFieldName:'REQST_ID',
				DBvalueFieldName: 'LAB_NO',
				DBtextFieldName: 'REQST_ID',
//					valueFieldOnly: true,
				api: 'popupService.labNoPopup',
				app: 'Unilite.app.popup.LabNoPopup',
				popupWidth:936,
				popupHeight:650,
				valueFieldWidth: 60,
				textFieldWidth: 170,
				pageTitle: 'LAB NO'
			};
		} else if (sPopItem == 'LAB_NO_G' ) {	//LAPNO 팝업
			rv = {
				xtype:'uniPopupColumn',	 // Grid용
				valueFieldName:'LAB_NO',
				textFieldName:'REQST_ID',
				DBvalueFieldName: 'LAB_NO',
				DBtextFieldName: 'REQST_ID',
				api: 'popupService.labNoPopup',
				app: 'Unilite.app.popup.LabNoPopup',
				//popupPage: '/com/popup/bk/CustPopup.do',
				pageTitle: 'LAB NO'
			};
		//20191113 LOT 재고 팝업 (MIT) 추가
		} else if (sPopItem == 'LOT_MULTI_MIT_G' ) {	// LOT 그리드용 (멀티 선택)
			rv = {
				xtype			: 'uniPopupColumn',		// Grid용
				textFieldName	: 'LOTNO_CODE',
				DBtextFieldName	: 'LOTNO_CODE',
				api				: 'popupService.lotNoPopup_mit',
				app				: 'Unilite.app.popup.LotPopupMulti_mit',
				popupWidth		: 1200,
				popupHeight		: 550,
				pageTitle		: 'LOT 재고정보(MIT)'
			};
		//20200217 실사일(외주) 팝업 추가
		} else if(sPopItem == 'COUNT_DATE_OUT') {
			rv = {
				xtype			: 'uniPopupField',
				textFieldName	: 'COUNT_DATE',
				DBtextFieldName	: 'COUNT_DATE',
				textFieldOnly	: true,
				textFieldConfig	: {
					xtype: 'uniTextfield'
				},
				api				: 'popupService.countdateoutPopup',
				app				: 'Unilite.app.popup.CountDateOutPopup',
				popupWidth		: 480,
				popupHeight		: 300,
				textFieldWidth	: 150,
				pageTitle		: '실사일(외주)'
			};
		} else if (sPopItem == 'ISSUE_REQ_NUM' ) {	//출하지시번호 팝업
			rv = {
				xtype			: 'uniPopupField',
				textFieldName	: 'ISSUE_REQ_NUM',
				DBtextFieldName	: 'ISSUE_REQ_NUM',
				textFieldOnly	: true,
				api				: 'popupService.issueReqNumPopup',
				app				: 'Unilite.app.popup.IssueReqNumPopup',
				popupWidth		: 600,
				popupHeight		: 450,
				textFieldWidth	: 150,
				pageTitle		: '<t:message code="system.label.sales.shipmentorderno" default="출하지시번호"/>'
			};
		} else if (sPopItem == 'ASST_MIT' ) {	// 자산코드(mit용)
			rv = {
				xtype			: 'uniPopupField',
				fieldLabel		: '자산코드',
				valueFieldName	: 'ASST',
				textFieldName	: 'ASST_NAME',
				DBvalueFieldName: 'ASST',
				DBtextFieldName	: 'ASST_NAME',
				api				: 'popupService.s_asset_mitPopup',
				app				: 'Unilite.app.popup.s_asset_mitPopup',
				valueFieldWidth	: 90,
				textFieldWidth	: 140,
				popupWidth		: 725,
				popupHeight		: 447,
				pageTitle		: '자산코드'
			};
		//20200605 LOT 재고 팝업 (INNO) 추가
		} else if (sPopItem == 'LOT_MULTI_IN_G' ) {	// LOT 그리드용 (멀티 선택)
			rv = {
				xtype			: 'uniPopupColumn',		// Grid용
				textFieldName	: 'LOTNO_CODE',
				DBtextFieldName	: 'LOTNO_CODE',
				api				: 'popupService.lotNoPopup_in',
				app				: 'Unilite.app.popup.LotPopupMulti_in',
				popupWidth		: 1200,
				popupHeight		: 550,
				pageTitle		: 'LOT 재고정보(IN)'
			};
		} else if (sPopItem == 'PURCH_DOC_NO' ) {		//회계 - 수출신고번호
			rv = {
					xtype:'uniPopupField',
					fieldLabel : '구매확인서번호',
					textFieldName:'PURCH_DOC_NO',
					DBtextFieldName: 'PURCH_DOC_NO',
					textFieldOnly: true,
					api: 'popupService.selectPurchDocNoPopupList',
					app: 'Unilite.app.popup.purchDocNoPopup',
					textFieldWidth: 140,
					popupWidth:789,
					popupHeight:450,
					pageTitle: '구매확인서번호'
				};
		} else if (sPopItem == 'PURCH_DOC_NO_G' ) {	//회계 -  수출신고번호 그리드
			rv = {
				xtype:'uniPopupColumn',
				textFieldName:'PURCH_DOC_NO',
				DBtextFieldName: 'PURCH_DOC_NO',
				api: 'popupService.PurchDocNoPopup',
				app: 'Unilite.app.popup.purchDocNoPopup',
				popupWidth:789,
				popupHeight:450,
				pageTitle: '구매확인서번호'
			};
		} else if (sPopItem == 'SAS_LOT' ) {		//영업- 판매이력 S/N 팝업 (A/S (MIT)) 
			rv = {
					xtype:'uniPopupField',
					fieldLabel : 'S/N',
					textFieldName:'SERIAL_NO',
					DBtextFieldName: 'SERIAL_NO',
					textFieldOnly: true,
					api: 'popupService.selectSasLotPopupList',
					app: 'Unilite.app.popup.sasLotPopup',
					textFieldWidth: 140,
					popupWidth:789,
					popupHeight:450,
					pageTitle: '판매이력 S/N 팝업'
				};
		} else if (sPopItem == 'SAS_LOT_G' ) {	//영업- 판매이력 S/N 팝업 (A/S (MIT)) 
			rv = {
				xtype:'uniPopupColumn',
				textFieldName:'SERIAL_NO',
				DBtextFieldName: 'SERIAL_NO',
				api: 'popupService.selectSasLotPopupList',
				app: 'Unilite.app.popup.sasLotPopup',
				popupWidth:789,
				popupHeight:450,
				pageTitle: '판매이력 S/N 팝업'
			};
		} else if (sPopItem == 'AS_RECEIPT_NUM' ) {		//영업- 접수번호 팝업 (A/S (MIT)) 
			rv = {
					xtype:'uniPopupField',
					fieldLabel : '접수번호',
					textFieldName:'RECEIPT_NUM',
					DBtextFieldName: 'RECEIPT_NUM',
					textFieldOnly: true,
					api: 'popupService.selectReceiptNumPopup',
					app: 'Unilite.app.popup.receiptNumPopup',
					textFieldWidth: 140,
					popupWidth:850,
					popupHeight:450,
					pageTitle: '접수번호 팝업'
				};
		} else if (sPopItem == 'AS_RECEIPT_NUM_G' ) {	//영업- 접수번호 팝업 (A/S (MIT)) 
			rv = {
				xtype:'uniPopupColumn',
				textFieldName:'RECEIPT_NUM',
				DBtextFieldName: 'RECEIPT_NUM',
				api: 'popupService.selectReceiptNumPopup',
				app: 'Unilite.app.popup.receiptNumPopup',
				popupWidth:850,
				popupHeight:450,
				pageTitle: '접수번호 팝업'
			};
		} else if (sPopItem == 'AS_QUOT_NUM' ) {		//영업- 수리견적번호 팝업 (A/S (MIT)) 
			rv = {
					xtype:'uniPopupField',
					fieldLabel : '수리견적번호',
					textFieldName:'QUOT_NUM',
					DBtextFieldName: 'QUOT_NUM',
					textFieldOnly: true,
					api: 'popupService.selectQuotNumPopup',
					app: 'Unilite.app.popup.quotNumPopup',
					textFieldWidth: 140,
					popupWidth:850,
					popupHeight:450,
					pageTitle: '수리견적'
				};
		} else if (sPopItem == 'AS_QUOT_NUM_G' ) {	//영업- 수리견적번호 팝업 (A/S (MIT)) 
			rv = {
				xtype:'uniPopupColumn',
				textFieldName:'QUOT_NUM',
				DBtextFieldName: 'QUOT_NUM',
				api: 'popupService.selectQuotNumPopup',
				app: 'Unilite.app.popup.quotNumPopup',
				popupWidth:850,
				popupHeight:450,
				pageTitle: '수리견적'
			};
		} else if (sPopItem == 'AS_REPAIR_NUM' ) {		//영업- 수리번호 팝업 (A/S (MIT)) 
			rv = {
					xtype:'uniPopupField',
					fieldLabel : '수리번호',
					textFieldName:'REPAIR_NUM',
					DBtextFieldName: 'REPAIR_NUM',
					textFieldOnly: true,
					api: 'popupService.selectRepairNumPopup',
					app: 'Unilite.app.popup.repairNumPopup',
					textFieldWidth: 140,
					popupWidth:850,
					popupHeight:450,
					pageTitle: '수리조회'
				};
		} else if (sPopItem == 'AS_REPAIR_NUM_G' ) {	//영업- 수리번호  팝업 (A/S (MIT)) 
			rv = {
				xtype:'uniPopupColumn',
				textFieldName:'REPAIR_NUM',
				DBtextFieldName: 'REPAIR_NUM',
				api: 'popupService.selectRepairNumPopup',
				app: 'Unilite.app.popup.repairNumPopup',
				popupWidth:850,
				popupHeight:450,
				pageTitle: '수리조회'
			};
		}  else if (sPopItem == 'AS_REPAIR_HISTORY' ) {		//영업- 수리이력 팝업 (A/S (MIT)) 
			rv = {
					xtype:'uniPopupField',
					fieldLabel : '수리번호',
					textFieldName:'REPAIR_NUM',
					DBtextFieldName: 'REPAIR_NUM',
					textFieldOnly: true,
					api: 'popupService.selectRepairHistoryPopup',
					app: 'Unilite.app.popup.repairHistoryPopup',
					textFieldWidth: 140,
					popupWidth:850,
					popupHeight:450,
					pageTitle: '수리이력조회'
				};
		} else if (sPopItem == 'BAD_CODE' ) { 		// 공정불량정보
			rv = {
				xtype:'uniPopupField', // 일반 Form용
				fieldLabel : '공정불량',
				valueFieldName:'BAD_CODE',
				textFieldName:'BAD_NAME',
				DBvalueFieldName: 'BAD_CODE',
				DBtextFieldName: 'BAD_CODE_NAME',
				api: 'popupService.selectBadCodePopup',
				app: 'Unilite.app.popup.badCode',
				//popupPage: '/com/popup/bk/CustPopup.do',
				valueFieldWidth: 60,
				textFieldWidth: 170,
				pageTitle: '공정불량'
			};
		} else if (sPopItem == 'BAD_CODE_G' ) {	// 공정불량정보
			rv = {
				xtype:'uniPopupColumn',		// Grid용
				textFieldName:'BAD_NAME',
				DBtextFieldName: 'BAD_NAME',
				api: 'popupService.selectBadCodePopup',
				app: 'Unilite.app.popup.BadCode',
				//popupPage: '/com/popup/bk/CustPopup.do',
				pageTitle: '공정불량'
			};
		} else if (sPopItem == 'DIV_PUMOK_WM_G' ) {			//월드와이드메모리용 그룹품목정보 팝업
			rv = {
				xtype			: 'uniPopupColumn',
				textFieldName	: 'ITEM_NAME',
				DBtextFieldName	: 'ITEM_NAME',
				api				: 'popupService.divPumokPopup_WM',
				app				: 'Unilite.app.popup.DivPumokPopup_WM',
				useyn			: this._setUseYn() ,
				pageTitle		: '품목그룹정보(WM)'
			};
		} else if(sPopItem == 'AS_PUMOK_MIT_G' ) {
			
			rv = {
					xtype			: 'uniPopupColumn',
					textFieldName	: 'ITEM_NAME',
					DBtextFieldName	: 'ITEM_NAME',
					api				: 'popupService.asDivPumokPopup',
					app				: 'Unilite.app.popup.ASDivPumokPopup',
					useyn			: this._setUseYn() ,
					pageTitle		: 'AS 품목정보'
				};
	    } else if (sPopItem == 'AS_ASST' ) { 		// AS 데모자산정보
			rv = {
					xtype:'uniPopupField', // 일반 Form용
					fieldLabel : '데모자산',
					valueFieldName:'ASST_CODE',
					textFieldName:'ASST_NAME',
					DBvalueFieldName: 'ASST_CODE',
					DBtextFieldName: 'ASST_NAME',
					api: 'popupService.selectASAssetPopup',
					app: 'Unilite.app.popup.ASAssetPopup',
					//popupPage: '/com/popup/bk/CustPopup.do',
					valueFieldWidth: 80,
					textFieldWidth: 150,
					pageTitle: '데모자산정보'
				};
		} else if(sPopItem == 'AS_ASST_G' ) {		// AS 데모자산정보
			
			rv = {
					xtype			: 'uniPopupColumn',
					textFieldName	: 'ASST_NAME',
					DBtextFieldName	: 'ASST_NAME',
					api				: 'popupService.selectASAssetPopup',
					app				: 'Unilite.app.popup.ASAssetPopup',
					useyn			: this._setUseYn() ,
					pageTitle		: '데모자산정보'
				};
		} else if (sPopItem == 'VMI_PUMOK') {		//20210803 추가: VMI사용자용 품목 생성
			rv = {
					xtype			: 'uniPopupField', // 일반 Form용
					valueFieldName	: 'ITEM_CODE',
					textFieldName	: 'ITEM_NAME',
					DBvalueFieldName: 'ITEM_CODE',
					DBtextFieldName	: 'ITEM_NAME',
					api				: 'popupService.vmiPumokPopup',
					app				: 'Unilite.app.popup.VmiPumokPopup',
					popupWidth		: 756,
					valueFieldWidth	: 90,
					textFieldWidth	: 140,
					pageTitle		: '품목정보'
				};
		} else if (sPopItem == 'MODEL_MICS' ) { 	// 모델 20210821 멕아이씨에스 전용 추가
			rv = {
					xtype			: 'uniPopupField', // 일반 Form용
					fieldLabel		: '모델',
					valueFieldName	: 'MODEL_CODE',
					textFieldName	: 'MODEL_NAME',
					DBvalueFieldName: 'MODEL_CODE',
					DBtextFieldName	: 'MODEL_NAME',
					api				: 'popupService.modelPopup',
					app				: 'Unilite.app.popup.ModelPopup',
					popupWidth		: 500,
					valueFieldWidth	: 90,
					textFieldWidth	: 140,
					pageTitle		: '모델 정보'
			};
		} else if (sPopItem == 'WONSANGI_G' ) { 	// 202109 jhj: 원산지 팝업 추가 (양평농협 전용) 
			rv = {
//				xtype			: 'uniPopupField',						// Control Popup
					xtype			: 'uniPopupColumn',						// Grid Column Popup
					textFieldName	: 'WONSANGI',
					DBtextFieldName	: 'WONSANGI',
					api				: 'popupService.wonsangiPopup',			//PopupServiceImpl Mapping
					app				: 'Unilite.app.popup.wonsangiPopup',	//PopupController Mapping
					popupWidth		: 700,
					textFieldWidth	: 140,
					pageTitle		: '원산지 정보'
			};
		}
		
		// console.log("BEFORE", rv.allowBlank, config.allowBlank)
		if (config) {
			if(rv.listeners) {
				config.listeners = Ext.apply(config.listeners, rv.listeners);
			}
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
					callBackFn		: callback,
					callBackScope	: scope,
					width			: 800,
					height			: 550,
					alwaysOnTop		: 89001,
					title			: 'Grid 설정',
					param			: param
				});
			}
			oWin.fnInitBinding(param);
			oWin.center();
			oWin.show();
			oWin.setAlwaysOnTop(true);
		};
		Unilite.require(app, fn, this, true);
	},
	popupGridNewConfig: function(param, callback, scope) {
		var app = "Unilite.app.popup.GridNewConfigPopup";
		var fn = function() {
			var oWin =  Ext.WindowMgr.get(app);
			if(!oWin) {
				oWin = Ext.create( app, {
					//id: 'GridConfigPopup',
					callBackFn		: callback,
					callBackScope	: scope,
					width			: 600,
					height			: 120,
					title			: 'Grid 설정',
					alwaysOnTop		: 89001,
					param			: param
				});
			}
			oWin.fnInitBinding(param);
			oWin.center();
			oWin.show();
			oWin.setAlwaysOnTop(true);
		};
		Unilite.require(app, fn, this, true);
	},
	/** 회계 계좌번호 암호화팝업
	 * @param String pObjType: form or grid
	 * @param Object record : grid 일 경우 해당 record, form 일경우 form obj
	 * @param String colName : 표시 필드명
	 * @param String secName : 암호화값 저장 필드명
	 * @param {} params : params
	 */
	popupCryptBankAccnt:function(pObjType, record, colName, secName, params) {
		var app = "Unilite.app.popup.BankAccntPopup";
		if(params == null) params = {}
		var fn = function() {
			var oWin =  Ext.WindowManager.get(app);
			if(!oWin) {
				oWin = Ext.create(app, {
					width	: 750,
					height	: 450,
					title	: '계좌번호',
					objType	: pObjType,
					record	: record,
					colName	: colName,
		 			secName	: secName,
					param	: params,
					callBackFn: function(rtnData,type) {
						var me = oWin;
						if(rtnData) {
						var records = rtnData.data;
							if(me.objType == "grid") {
								me.record.set(me.secName, records[0]["BANK_ACCNT_CODE"]);
								if(Ext.isEmpty(me.record.BANK_CODE) && Ext.isEmpty(me.record.BANK_NAME)) {
									me.record.set('BANK_CODE', records[0]["BANK_CODE"]);
									me.record.set('BANK_NAME', records[0]["BANK_NAME"]);
								}
								me.record.set(me.colName, '***************');
							} else if(me.objType == "form") {
								me.record.setValue(me.secName, records[0]["BANK_ACCNT_CODE"]);
								if(!Ext.isEmpty(me.record.getField("BANK_CODE")) && !Ext.isEmpty(me.record.getField("BANK_NAME"))) {
									me.record.setValue('BANK_CODE', records[0]["BANK_CODE"]);
									me.record.setValue('BANK_NAME', records[0]["BANK_NAME"]);
								}
								me.record.setValue(me.colName, '***************');
							}
						}
					},
					callBackScope: function() {
						return Ext.WindowManager.get(app);
					}
				});
			}
			oWin.objType = pObjType;
			oWin.record = record;
			oWin.colName = colName;
			oWin.secName = secName;
			oWin.param = params;
			oWin.fnInitBinding(params);

			oWin.center();
			oWin.show();
			oWin.setAlwaysOnTop(true);
		}
		Unilite.require(app, fn, this, true);
	},



	/** 공통 암호복호화팝업
	 * @param String pObjType: form or grid
	 * @param Object record : grid 일 경우 해당 record, form 일경우 form obj
	 * @param String colName : 표시 필드명
	 * @param String secName : 암호화값 저장 필드명
	 * @param {} params : params
	 *
	 */
	popupCipherComm:function(pObjType, record, colName, secName, params) {
		var app = "";
		if(params == null){
			params = {}
		} else{
			if(params.GUBUN_FLAG =='1'){				//카드번호
				app = "Unilite.app.popup.CipherCardNoPopup";

			} else if(params.GUBUN_FLAG =='2'){			//'계좌번호'
				app = "Unilite.app.popup.CipherBankAccntPopup";

			} else if(params.GUBUN_FLAG =='3'){			//'주민번호'
				app = "Unilite.app.popup.CipherRepreNoPopup";
			} else if(params.GUBUN_FLAG =='4'){			//'외국인번호'
				app = "Unilite.app.popup.CipherForeignNoPopup";
			} else if(params.GUBUN_FLAG =='5') {		//일반암호화
				app = "Unilite.app.popup.CipherOtherPopup";
			} else {
				Unilite.messageBox("암호화대상구분이 정확하지 않습니다");
				return;
			}
		}
		var fn = function() {
			var oWin =  Ext.WindowManager.get(app);
			if(!oWin) {
				oWin = Ext.create(app, {
					width	: 388,
					height	: 140,
					title	: '암복호화',
					objType	: pObjType,
					record	: record,
					colName	: colName,
		 			secName	: secName,
					param	: params,
					callBackFn: function(rtnData,type) {
						var me = oWin;
						if(rtnData) {
							var records = rtnData.data;
							if(me.objType == "grid") {
								//me.record.set('DECRYP_WORD',records[0]["DECRYP_WORD"]);
								me.record.set(me.secName,records[0]["INC_WORD"]);
								if(Ext.isEmpty(records[0]["INC_WORD"])){
									me.record.set(me.colName,'');
								} else{
									me.record.set(me.colName,'**************');
								}
							} else if(me.objType == "form") {
								//me.record.setValue('DECRYP_WORD',records[0]["DECRYP_WORD"]);
								me.record.setValue(me.secName,records[0]["INC_WORD"]);
								if(Ext.isEmpty(records[0]["INC_WORD"])){
									me.record.setValue(me.colName,'');
								} else{
									me.record.setValue(me.colName,'**************');
								}

							}
						}
					},
					callBackScope: function() {
						return Ext.WindowManager.get(app);
					}
				});
			}
			oWin.objType = pObjType;
			oWin.record = record;
			oWin.colName = colName;
			oWin.secName = secName;
			oWin.param = params;
			oWin.fnInitBinding(params);

			oWin.center();
			oWin.show();
			oWin.setAlwaysOnTop(true);
		}
		Unilite.require(app, fn, this, true);
	},
	loadCryptPopupApp: function() {
		if(Ext.ieVersion == 10) {
			Unilite.require("Unilite.app.popup.BankAccntPopup", null, null, true);
			Unilite.require("Unilite.app.popup.CipherCardNoPopup", null, null, true);
			Unilite.require("Unilite.app.popup.CipherBankAccntPopup", null, null, true);
			Unilite.require("Unilite.app.popup.CipherRepreNoPopup", null, null, true);
			Unilite.require("Unilite.app.popup.CipherForeignNoPopup", null, null, true);
			Unilite.require("Unilite.app.popup.CipherOtherPopup", null, null, true);
		}
	},
	/**
	 * 복호화 팝업 공용 20181002
	 * @param {} params
	 */
	popupDecryptCom:function( params) {
		var app = "";
		app = "Unilite.app.popup.DecryptComPopup";

		var fn = function() {
			var oWin =  Ext.WindowManager.get(app);

			if(!oWin) {
				oWin = Ext.create(app, {
					width: 388,
					height: 92,
					param: params
				});
			}
			oWin.param = params;
			oWin.fnInitBinding(params);

			oWin.center();
			oWin.show();
			oWin.setAlwaysOnTop(true);
		}
		Unilite.require(app, fn, this, true);
	}
}) ;
Unilite.loadCryptPopupApp();  // IE10 인경우 만 실행됨