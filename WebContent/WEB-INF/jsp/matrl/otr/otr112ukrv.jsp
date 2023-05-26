<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="otr112ukrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 								<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B004" />						<!-- 화폐단위 -->
	<t:ExtComboStore comboType="AU" comboCode="B024" />						<!-- 출고담당 -->
	<t:ExtComboStore comboType="AU" comboCode="M104" />						<!-- 출고유형-->
	<t:ExtComboStore comboType="AU" comboCode="B022" />						<!-- 재고상태관리-->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList"/>			<!-- 창고-->
	<t:ExtComboStore items="${COMBO_WH_CELL_LIST}" storeId="whCellList" />	<!-- 창고Cell-->
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}	
</style>	

<script type="text/javascript" >

var SearchInfoWindow; // 검색창
var ReservationWindow; // 예약참조
var ReturnReservationWindow; // 반품가능예약참조
var alertWindow;			//alertWindow : 경고창
var gsText			= ''	//바코드 알람 팝업 메세지

var gsMaxInoutSeq	= 0;
var gsSaveFlag		= false;

var BsaCodeInfo = {	// 컨트롤러에서 값을 받아옴
	//gsInvstatus		: '${gsInvstatus}',
	gsSumTypeLot		: '${gsSumTypeLot}',		//'Y'
	gsSumTypeCell		: '${gsSumTypeCell}',		//'N'
	gsBaseWhCode		: '${gsBaseWhCode}',		//B095코드가 없음.
	gsBaseWhCodeCell	: '${gsBaseWhCodeCell}',	//B095코드가 없음.
	gsDefaultMoney		: '${gsDefaultMoney}',		//'KRW'
	gsLotNoInputMethod	: '${gsLotNoInputMethod}',
	gsLotNoEssential	: '${gsLotNoEssential}',
	gsEssItemAccount	: '${gsEssItemAccount}',
	gsUsePabStockYn		: '${gsUsePabStockYn}',
	gsFifo				: '${gsFifo}'
};

var outDivCode = UserInfo.divCode;

var usePabStockYn = true; //가용재고 컬럼 사용여부
if(BsaCodeInfo.gsUsePabStockYn =='Y') {
	usePabStockYn = false;
}

var output =''; 	// 출고내역 셋팅 값 확인 alert
for(var key in BsaCodeInfo){
	output += key + '  :  ' + BsaCodeInfo[key] + '\n';
}

function appMain() {
	var sumtypeCell			= BsaCodeInfo.gsSumTypeCell			== 'Y'?		false	: true;	//재고합산유형 : 창고 Cell 합산에 따라 컬럼설정
	var lotNoEssential		= BsaCodeInfo.gsLotNoEssential		== "Y"?		true	: false;
	var lotNoInputMethod	= BsaCodeInfo.gsLotNoInputMethod	== "Y"?		true	: false;
	
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'otr112ukrvService.selectMaster'/*,
			update	: 'otr112ukrvService.updateDetail',
			create	: 'otr112ukrvService.insertDetail',
			destroy	: 'otr112ukrvService.deleteDetail',
			syncAll	: 'otr112ukrvService.saveAll'*/
		}
	});

	//바코드 관련 Proxy
	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'otr112ukrvService.selectMaster2',
			update	: 'otr112ukrvService.updateDetail',
			create	: 'otr112ukrvService.insertDetail',
			destroy	: 'otr112ukrvService.deleteDetail',
			syncAll	: 'otr112ukrvService.saveAll'
		}
	});



	var panelResult = Unilite.createSearchForm('otr112ukrvpanelResult', {	// 메인	
		region	: 'north',
		layout	: {type : 'uniTable', columns : 4},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel	: '<t:message code="system.label.purchase.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			holdable	: 'hold',
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
			
		},
		//外包单位
		Unilite.popup('AGENT_CUST',{
			fieldLabel		: '<t:message code="system.label.purchase.subcontractor" default="외주처"/>',
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
			holdable		: 'hold',
			allowBlank		: false,
			listeners		: {
				onSelected: {
					fn: function(records, type) {
					},
					scope: this
				},
				onClear: function(type)	{
				}
			}
		}),
		//出库日期
		{ 
			fieldLabel	: '<t:message code="system.label.purchase.issuedate" default="출고일"/>',
			name		: 'INOUT_DATE',
			xtype		: 'uniDatefield',
			value		: new Date(),
			holdable	: 'hold',
			allowBlank	: false,
			colspan		: 2,
			listeners	: {
				change : function(field, newValue, oldValue, eOpts) {
				}
			}
		},
		//出库主管
		{
			fieldLabel	: '<t:message code="system.label.purchase.issuecharge" default="출고담당"/>', 
			name		: 'INOUT_PRSN', 
			xtype		: 'uniCombobox', 
			holdable	: 'hold',
			comboType	: 'AU', 
			comboCode	: 'B024',
			listeners	: {
				change : function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.purchase.issuewarehouse" default="출고창고"/>',
			name		: 'WH_CODE',
			xtype		: 'uniCombobox',
			store		: Ext.data.StoreManager.lookup('whList'),
			child		: 'WH_CELL_CODE',
			holdable	: 'hold',
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
				}
			}
		},
		//出库编号
		{					
			fieldLabel	: '<t:message code="system.label.purchase.issueno" default="출고번호"/>',
			name		: 'INOUT_NUM',
			xtype		: 'uniTextfield',
			readOnly	: true,
			colspan		: 2,
			listeners	: {
				change : function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.purchase.issuewarehouse" default="출고창고"/>Cell',
			name		: 'WH_CELL_CODE',
			xtype		:'uniCombobox',
			store		: Ext.data.StoreManager.lookup('whCellList'),
			holdable	: 'hold',
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.purchase.pono" default="발주번호"/>', 
			name		: 'ORDER_NUM_BARCODE',
			xtype		: 'uniTextfield',
			readOnly	: false,
			fieldStyle	: 'IME-MODE: inactive',				//IE에서만 적용 됨
//				autoCreate	: {tag: 'input', type: 'text', size: '20', style :'IME-MODE:DISABLED' ,autocomplete: 'off', maxlength: '8'},
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
				},
				specialkey:function(field, event)	{
					if(event.getKey() == event.ENTER) {
						var newValue	= panelResult.getValue('ORDER_NUM_BARCODE');
						var customCode	= panelResult.getValue('CUSTOM_CODE');
						if(Ext.isEmpty(customCode)) {		//외주처 필수 체크
							alert(Msg.sMM009);				//외주처 를 입력하십시오.
							panelResult.setValue('ORDER_NUM_BARCODE', '');
							panelResult.getField('CUSTOM_CODE').focus();
							return false;
						}
						if(!Ext.isEmpty(newValue)) {
							Ext.getBody().mask('<t:message code="system.label.purchase.loading" default="로딩중..."/>','loading-indicator');
							masterGrid.focus();
							fnEnterOrderNumBarcode(newValue);
							panelResult.setValue('ORDER_NUM_BARCODE', '');
						}
					}
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.purchase.barcode" default="바코드"/>', 
			name		: 'BARCODE',
			xtype		: 'uniTextfield',
			readOnly	: false,
			fieldStyle	: 'IME-MODE: inactive',				//IE에서만 적용 됨
//			autoCreate	: {tag: 'input', type: 'text', size: '20', style :'IME-MODE:DISABLED' ,autocomplete: 'off', maxlength: '8'},
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
				},
				specialkey:function(field, event)	{
					if(event.getKey() == event.ENTER) {
						var newValue = panelResult.getValue('BARCODE');
						if(!Ext.isEmpty(newValue)) {
							var masterRecords = masterGrid.getStore().count();
							//masterGrid에 데이터 존재여부 확인
							if(masterRecords == 0) {
								alert('<t:message code="system.message.purchase.message043" default="입력할 출고요청 데이터가 없습니다."/>');
								panelResult.setValue('BARCODE', '');
								return false;
							}
							masterGrid.focus();
							fnEnterBarcode(newValue);
							panelResult.setValue('BARCODE', '');
						}
					}
				}
			}
		}/*,{
			xtype	: 'container',
			padding	: '0 0 0 0',
			items	: [{
				xtype	: 'button',
				text	: '전표출력',//凭证输出
//				hidden	: true
			}]
		}*/],
		setAllFieldsReadOnly: setAllFieldsReadOnly
	});

	var orderNoSearch = Unilite.createSearchForm('orderNoSearchForm', {		// 검색 팝업창
		layout: {type: 'uniTable', columns : 2},
		trackResetOnLoad: true,
		items: [
			Unilite.popup('AGENT_CUST',{
				fieldLabel: '<t:message code="system.label.purchase.subcontractor" default="외주처"/>',
				textFieldWidth: 170
			}),{
				fieldLabel: '<t:message code="system.label.purchase.issuedate" default="출고일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'FR_INOUT_DATE',
				endFieldName: 'TO_INOUT_DATE',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				allowBlank: false
			},{
 				fieldLabel: '<t:message code="system.label.purchase.issuewarehouse" default="출고창고"/>',
 				name:'WH_CODE',
 				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('whList')
 			},{
				fieldLabel: '<t:message code="system.label.purchase.issuecharge" default="출고담당"/>', 
				name:'INOUT_PRSN', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'B024'
			}
		],
		setAllFieldsReadOnly: setAllFieldsReadOnly
	});
	
	var otherorderSearch = Unilite.createSearchForm('otherorderForm', {		//예약참조
			layout :  {type : 'uniTable', columns : 3},
			items :[
				{
					fieldLabel: '<t:message code="system.label.purchase.podate" default="발주일"/>',
					xtype: 'uniDateRangefield',
					startFieldName: 'FR_INOUT_DATE',
					endFieldName: 'TO_INOUT_DATE',
					startDate: UniDate.get('startOfMonth'),
					endDate: UniDate.get('today')
				},{
					xtype: 'radiogroup',
					fieldLabel: '<t:message code="system.label.purchase.subcontractorderclosing" default="외주발주마감"/>',
					id: 'rdoSelect',
					items: [{
						boxLabel: '<t:message code="system.label.purchase.inclusion" default="포함"/>', 
						width:  60, 
						name: '', 
						inputValue: 'A', 
						checked: true
					},{
						boxLabel: '<t:message code="system.label.purchase.notinclustion" default="미포함"/>', 
						width :60, 
						name: '', 
						inputValue: 'Y'
					}]
				},{
					xtype: 'uniTextfield',
					name: 'SPEC',
					fieldLabel: '<t:message code="system.label.purchase.spec" default="규격"/>'
				},
				Unilite.popup('IDIV_PUMOK',{ 
					fieldLabel: '<t:message code="system.label.purchase.poitem" default="발주품목"/>', 
					validateBlank: false,
					textFieldName: 'ORDER_ITEM_NAME',
					valueFieldName: 'ORDER_ITEM_CODE'		
				}),
				Unilite.popup('IDIV_PUMOK',{ 
					fieldLabel: '<t:message code="system.label.purchase.allocationitem" default="예약품목"/>', 
					textFieldWidth: 170, 
					validateBlank: false,
					textFieldName: 'ITEM_NAME',
					valueFieldName: 'ITEM_CODE'
				}),{
					fieldLabel: '<t:message code="system.label.purchase.subcontractor" default="외주처"/>',
					xtype: 'uniTextfield',
					name: 'CUSTOM_CODE',
					hidden: true
				},{
					fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
					xtype: 'uniTextfield',
					name: 'DIV_CODE',
					hidden: true
				}
			]
	});
	
	var otherorderSearch2 = Unilite.createSearchForm('otherorderForm2', {	//반품가능예약참조
			layout :  {type : 'uniTable', columns : 2},
			items : [
				{
					fieldLabel	 : '<t:message code="system.label.purchase.podate" default="발주일"/>',
					xtype		  : 'uniDateRangefield',
					startFieldName : 'FR_ORDER_DATE',
					endFieldName   : 'TO_ORDER_DATE',
					startDate	  : UniDate.get('startOfMonth'),
					endDate		: UniDate.get('today'),
					width		  : 315
				},{
					fieldLabel : '<t:message code="system.label.purchase.division" default="사업장"/>',
					name	   : 'DIV_CODE',
					xtype	  : 'uniTextfield',
					hidden	 : true,
					readOnly   : true
				},{
					fieldLabel : '<t:message code="system.label.purchase.subcontractor" default="외주처"/>',
					name	   : 'CUSTOM_CODE',
					xtype	  : 'uniTextfield',
					hidden	 : true,
					readOnly   : true
				}
			]
	});
	
	
	
	//메인
	Unilite.defineModel('otr112ukrvModel', {
		fields: [
			{name: 'INOUT_NUM'			,text: '<t:message code="system.label.purchase.tranno" default="수불번호"/>' 			,type: 'string'},
			{name: 'INOUT_SEQ'			,text: '<t:message code="system.label.purchase.seq" default="순번"/>' 			,type: 'int',maxLength:3},
			{name: 'INOUT_TYPE'			,text: '<t:message code="system.label.purchase.type" default="타입"/>' 			,type: 'string', defaultValue: '2'},
			{name: 'INOUT_METH'			,text: '<t:message code="system.label.purchase.method" default="방법"/>' 			,type: 'string'},
			{name: 'INOUT_TYPE_DETAIL'	,text: '<t:message code="system.label.purchase.issuetype" default="출고유형"/>'			,type: 'string', comboType: 'AU', comboCode: 'M104', defaultValue: "10", allowBlank: false}, ////defaultValue:콤보의 첫번쨰Value로 해야함
			{name: 'INOUT_CODE_TYPE'	,text: '<t:message code="system.label.purchase.issueplaceclassfication" default="출고처구분"/>'			,type: 'string'},
			{name: 'INOUT_CODE'			,text: '<t:message code="system.label.purchase.subcontractor" default="외주처"/>' 			,type: 'string'},
			{name: 'INOUT_NAME'			,text: '<t:message code="system.label.purchase.subcontractorname" default="외주처명"/>' 			,type: 'string'},
			{name: 'ITEM_CODE'			,text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>' 			,type: 'string', allowBlank: false},
			{name: 'ITEM_NAME'			,text: '<t:message code="system.label.purchase.itemname" default="품목명"/>' 			,type: 'string', allowBlank: false},
			{name: 'SPEC'				,text: '<t:message code="system.label.purchase.spec" default="규격"/>' 			,type: 'string'},
			{name: 'STOCK_UNIT'			,text: '<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>' 			,type: 'string'},
			// 출고창고 WH_CODE / WH_NAME 조회할때 CODE로 하면 출고창고 값 출력, NAME으로 하면 출고창고 값이 안나옴.
			{name: 'WH_CODE'			,text: '<t:message code="system.label.purchase.issuewarehouse" default="출고창고"/>' 			,type: 'string', store: Ext.data.StoreManager.lookup('whList'), child: 'WH_CELL_CODE', allowBlank: false},
			{name: 'WH_NAME'			,text: '<t:message code="system.label.purchase.issuewarehouse" default="출고창고"/>' 			,type: 'string'},
			// 출고창고 WH_CODE / WH_NAME 조회할때 CODE로 하면 출고창고 값 출력, NAME으로 하면 출고창고 값이 안나옴.
			{name: 'WH_CELL_CODE'		,text: '<t:message code="system.label.purchase.issuewarehouse" default="출고창고"/>Cell'		,type: 'string', allowBlank: sumtypeCell, store: Ext.data.StoreManager.lookup('whCellList'), parentNames:['WH_CODE','DIV_CODE']},
			{name: 'WH_CELL_NAME'		,text: '<t:message code="system.label.purchase.issuewarehouse" default="출고창고"/>Cell' 		,type: 'string',maxLength:20},
			{name: 'ALLOC_Q'			,text: '<t:message code="system.label.purchase.allocationqty" default="예약량"/>' 			,type: 'uniQty'},
			{name: 'NOT_OUTSTOCK_Q'		,text: '<t:message code="system.label.purchase.unissuedqty" default="미출고량"/>' 			,type: 'uniQty'},
			{name: 'INOUT_Q'			,text: '<t:message code="system.label.purchase.issueqty" default="출고량"/>' 			,type: 'uniQty', allowBlank: false},
			{name: 'ITEM_STATUS'		,text: '<t:message code="system.label.purchase.itemstatus" default="품목상태"/>' 			,type: 'string', comboType: 'AU', comboCode: 'B021'},
			{name: 'ORIGINAL_Q'			,text: '<t:message code="system.label.purchase.existingoutqty" default="기존출고량"/>' 			,type: 'uniQty'},
			{name: 'PAB_STOCK_Q'		,text: '<t:message code="system.label.purchase.availableinventory" default="가용재고"/>'			,type: 'uniQty'},
			{name: 'GOOD_STOCK_Q'		,text: '<t:message code="system.label.purchase.goodstock" default="양품재고"/>' 			,type: 'uniQty'},
			{name: 'BAD_STOCK_Q'		,text: '<t:message code="system.label.purchase.defectinventory" default="불량재고"/>' 			,type: 'uniQty'},
			{name: 'INOUT_DATE'			,text: '<t:message code="system.label.purchase.issuedate" default="출고일"/>' 			,type: 'uniDate'},
			{name: 'COMP_CODE'			,text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>' 			,type: 'string'},
			{name: 'DIV_CODE'			,text: '<t:message code="system.label.purchase.division" default="사업장"/>' 			,type: 'string', child: 'WH_CODE'},
			{name: 'INOUT_P'			,text: '<t:message code="system.label.purchase.tranprice" default="수불단가"/>' 			,type: 'uniUnitPrice'},
			{name: 'INOUT_I'			,text: '<t:message code="system.label.purchase.localamount" default="원화금액"/>' 			,type: 'uniPrice'},
			{name: 'EXPENSE_I'			,text: '<t:message code="system.label.purchase.expenseamount" default="경비금액"/>' 			,type: 'uniPrice'},
			{name: 'MONEY_UNIT'			,text: '<t:message code="system.label.purchase.currencyunit" default="화폐단위"/>' 			,type: 'string', comboType: 'AU', comboCode: 'B004'},
			{name: 'INOUT_FOR_P'		,text: '<t:message code="system.label.purchase.foreigncurrencyunit" default="외화단가"/>' 			,type: 'uniUnitPrice'},
			{name: 'INOUT_FOR_O'		,text: '<t:message code="system.label.purchase.foreigncurrencyamount" default="외화금액"/>' 			,type: 'uniFC'},
			{name: 'EXCHG_RATE_O'		,text: '<t:message code="system.label.purchase.exchangerate" default="환율"/>' 			,type: 'uniER'},
			{name: 'ORDER_TYPE'			,text: '<t:message code="system.label.purchase.potype" default="발주형태"/>' 			,type: 'string'},
			{name: 'ORDER_NUM'			,text: '<t:message code="system.label.purchase.pono" default="발주번호"/>' 			,type: 'string'},
			{name: 'ORDER_SEQ'			,text: '<t:message code="system.label.purchase.poseq" default="발주순번"/>' 			,type: 'int'},
			{name: 'LC_NUM'				,text: '<t:message code="system.label.purchase.lcno" default="L/C번호"/>' 			,type: 'string'},
			{name: 'BL_NUM'				,text: '<t:message code="system.label.purchase.blno" default="B/L번호"/>' 			,type: 'string'},
			{name: 'INOUT_PRSN'			,text: '<t:message code="system.label.purchase.trancharge" default="수불담당"/>' 			,type: 'string',comboType: 'AU', comboCode: 'B024'},
			{name: 'BASIS_NUM'			,text: '<t:message code="system.label.purchase.basisno" default="근거번호"/>' 			,type: 'string'},
			{name: 'BASIS_SEQ'			,text: '<t:message code="system.label.purchase.basisseq" default="근거순번"/>' 			,type: 'string'},
			{name: 'ACCOUNT_YNC'		,text: '<t:message code="system.label.purchase.billobject" default="계산서대상"/>' 			,type: 'string'},
			{name: 'ACCOUNT_Q'			,text: '<t:message code="system.label.purchase.billqty" default="계산서량"/>' 			,type: 'uniQty'},
			{name: 'CREATE_LOC'			,text: '<t:message code="system.label.purchase.creationpath" default="생성경로"/>' 			,type: 'string'},
			{name: 'SALE_C_YN'			,text: '<t:message code="system.label.purchase.notbillingclosingyn" default="미매출마감여부"/>'		,type: 'string'},
			{name: 'SALE_C_DATE'		,text: '<t:message code="system.label.purchase.notbillingclosingdate" default="미매출마감일자"/>'		,type: 'uniDate'},
			{name: 'SALE_C_REMARK'		,text: '<t:message code="system.label.purchase.notbillingclosingreason" default="미매출마감사유"/>'		,type: 'string'},
			{name: 'GRANT_TYPE'			,text: 'GRANT_TYPE'		,type: 'string'},
			{name: 'REMARK'				,text: '<t:message code="system.label.purchase.remarks" default="비고"/>' 			,type: 'string',maxLength:200},
			{name: 'PROJECT_NO'  		,text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>' 		,type: 'string',maxLength:20},
			{name: 'SALE_DIV_CODE'		,text: '<t:message code="system.label.purchase.salesdivision" default="매출사업장"/>' 			,type: 'string'},
			{name: 'SALE_CUSTOM_CODE'	,text: '<t:message code="system.label.purchase.salesplace" default="매출처"/>' 			,type: 'string'},
			{name: 'BILL_TYPE'			,text: '<t:message code="system.label.purchase.salestype" default="매출유형"/>' 			,type: 'string'},
			{name: 'SALE_TYPE'			,text: '<t:message code="system.label.purchase.salesclass" default="매출구분"/>' 			,type: 'string'},
			{name: 'UPDATE_DB_USER'		,text: '<t:message code="system.label.purchase.updateuser" default="수정자"/>' 			,type: 'string'},
			{name: 'UPDATE_DB_TIME'		,text: '<t:message code="system.label.purchase.updatedate" default="수정일"/>' 		,type: 'uniDate'},
			{name: 'ITEM_ACCOUNT'		,text: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>' 			,type: 'string'},
			{name: 'STOCK_CARE_YN'		,text: '<t:message code="system.label.purchase.inventorymanagementyn" default="재고관리여부"/>' 		,type: 'string'},
			{name: 'LOT_NO'  			,text: '<t:message code="system.label.purchase.lotno" default="LOT번호"/>' 		,type: 'string', allowBlank:lotNoInputMethod || !lotNoEssential},
			{name: 'LOT_YN'				,text: '<t:message code="system.label.purchase.lotmanageyn" default="LOT관리여부"/>'		,type: 'string'},
			{name: 'REF_GUBUN'			,text: '<t:message code="system.label.purchase.referenceclassification" default="참조구분"/>'			,type: 'string'}
		]
	});
	//검색조회창
	Unilite.defineModel('orderNoMasterModel', {
		fields: [
			{name: 'INOUT_DATE'			,text: '<t:message code="system.label.purchase.issuedate" default="출고일"/>'			,type: 'string'},
			{name: 'INOUT_CODE'			,text: '<t:message code="system.label.purchase.subcontractorcode" default="외주처코드"/>'			,type: 'string'},
			{name: 'CUSTOM_NAME'		,text: '<t:message code="system.label.purchase.subcontractorname" default="외주처명"/>'			,type: 'string'},
			{name: 'WH_CODE'			,text: '<t:message code="system.label.purchase.issuewarehouse" default="출고창고"/>'			,type: 'string'},
			{name: 'INOUT_PRSN'			,text: '<t:message code="system.label.purchase.issuecharge" default="출고담당"/>'			,type: 'string',comboType: 'AU', comboCode: 'B024'},
			{name: 'INOUT_NUM'			,text: '<t:message code="system.label.purchase.issueno" default="출고번호"/>'			,type: 'string'},
			{name: 'LOT_NO'				,text: '<t:message code="system.label.purchase.lotno" default="LOT번호"/>'			,type: 'string'}
		]
	});
	//예약참조 
	Unilite.defineModel('otr112ukrvOTHERModel', {
		fields: [
			{name: 'ORDER_NUM'			,text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'			,type: 'string'},
			{name: 'ORDER_SEQ'			,text: '<t:message code="system.label.purchase.poseq" default="발주순번"/>'			,type: 'string'},
			{name: 'ORDER_DATE'			,text: '<t:message code="system.label.purchase.podate" default="발주일"/>'			,type: 'uniDate'},
			{name: 'ORDER_ITEM_CODE'	,text: '<t:message code="system.label.purchase.poitemcode" default="발주품목코드"/>'			,type: 'string'},
			{name: 'ORDER_ITEM_NAME'	,text: '<t:message code="system.label.purchase.poitemname" default="발주품목명"/>'			,type: 'string'},
			{name: 'ITEM_CODE'			,text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'			,type: 'string'},
			{name: 'ITEM_NAME'			,text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'			,type: 'string'},
			{name: 'SPEC'				,text: '<t:message code="system.label.purchase.spec" default="규격"/>'				,type: 'string'},
			{name: 'ALLOC_Q'			,text: '<t:message code="system.label.purchase.allocationqty" default="예약량"/>'			,type: 'uniQty'},
			{name: 'OUTSTOCK_Q'			,text: '<t:message code="system.label.purchase.issueqty" default="출고량"/>'			,type: 'uniQty'},
			{name: 'NOT_OUTSTOCK'		,text: '<t:message code="system.label.purchase.unissuedqty" default="미출고량"/>'			,type: 'uniQty'},
			{name: 'AVERAGE_P'			,text: '<t:message code="system.label.purchase.price" default="단가"/>'				,type: 'uniUnitPrice'},
			{name: 'STOCK_UNIT'			,text: '<t:message code="system.label.purchase.unit" default="단위"/>'				,type: 'string'},
			{name: 'WH_CODE'			,text: '<t:message code="system.label.purchase.mainwarehouse" default="주창고"/>'			,type: 'string', xtype: 'uniCombobox', store: Ext.data.StoreManager.lookup('whList')},
			{name: 'STOCK_Q'			,text: '<t:message code="system.label.purchase.onhandstock" default="현재고"/>'			,type: 'uniQty'},
			{name: 'CUSTOM_CODE'		,text: '<t:message code="system.label.purchase.subcontractor" default="외주처"/>'			,type: 'string'},
			{name: 'CUSTOM_NAME'		,text: '<t:message code="system.label.purchase.subcontractorname" default="외주처명"/>'			,type: 'string'},
			{name: 'MONEY_UNIT'			,text: '<t:message code="system.label.purchase.currency" default="화폐"/>'				,type: 'string'},
			{name: 'COMP_CODE'			,text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'			,type: 'string'},
			{name: 'DIV_CODE'			,text: '<t:message code="system.label.purchase.division" default="사업장"/>'			,type: 'string'},
			{name: 'GRANT_TYPE'			,text: '<t:message code="system.label.purchase.subcontractdivision" default="사급구분"/>'			,type: 'string'},
			{name: 'REMARK'				,text: '<t:message code="system.label.purchase.remarks" default="비고"/>'				,type: 'string'},
			{name: 'PROJECT_NO'			,text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'			,type: 'string'},
			{name: 'STOCK_CARE_YN'		,text: '<t:message code="system.label.purchase.inventorymanagementyn" default="재고관리여부"/>'			,type: 'string'},
			{name: 'LOT_YN'				,text: '<t:message code="system.label.purchase.lotmanageyn" default="LOT관리여부"/>'		,type: 'string'}
		]
	});
	//반품가능예약참조 
	Unilite.defineModel('otr112ukrvOTHERModel2', {
		fields: [
			{name: 'ORDER_NUM'			,text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'			,type: 'string'},
			{name: 'ORDER_SEQ'			,text: '<t:message code="system.label.purchase.poseq" default="발주순번"/>'			,type: 'string'},
			{name: 'ORDER_DATE'			,text: '<t:message code="system.label.purchase.podate" default="발주일"/>'			,type: 'uniDate'},
			{name: 'ORDER_ITEM_CODE'	,text: '<t:message code="system.label.purchase.poitemcode" default="발주품목코드"/>'			,type: 'string'},
			{name: 'ORDER_ITEM_NAME'	,text: '<t:message code="system.label.purchase.poitemname" default="발주품목명"/>'			,type: 'string'},
			{name: 'ITEM_CODE'			,text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'			,type: 'string'},
			{name: 'ITEM_NAME'			,text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'			,type: 'string'},
			{name: 'SPEC'				,text: '<t:message code="system.label.purchase.spec" default="규격"/>'				,type: 'string'},
			{name: 'WH_CODE'			,text: '<t:message code="system.label.purchase.mainwarehouse" default="주창고"/>'			,type: 'string', xtype: 'uniCombobox', store: Ext.data.StoreManager.lookup('whList')},
			{name: 'ALLOC_Q'			,text: '<t:message code="system.label.purchase.allocationqty" default="예약량"/>'			,type: 'uniQty'},
			{name: 'NOTOUTSTOCK_Q'		,text: '<t:message code="system.label.purchase.returnavaiableqty" default="반품가능량"/>'			,type: 'uniQty'},
			{name: 'OUTSTOCK_Q'			,text: '<t:message code="system.label.purchase.issueqty" default="출고량"/>'			,type: 'uniQty'},
			{name: 'NOT_OUTSTOCK'		,text: '<t:message code="system.label.purchase.unissuedqty" default="미출고량"/>'			,type: 'uniQty'},
			{name: 'AVERAGE_P'			,text: '<t:message code="system.label.purchase.price" default="단가"/>'				,type: 'uniUnitPrice'},
			{name: 'STOCK_UNIT'			,text: '<t:message code="system.label.purchase.unit" default="단위"/>'				,type: 'string'},
			{name: 'STOCK_Q'			,text: '<t:message code="system.label.purchase.onhandstock" default="현재고"/>'			,type: 'uniQty'},
			{name: 'CUSTOM_CODE'		,text: '<t:message code="system.label.purchase.subcontractor" default="외주처"/>'			,type: 'string'},
			{name: 'CUSTOM_NAME'		,text: '<t:message code="system.label.purchase.subcontractorname" default="외주처명"/>'			,type: 'string'},
			{name: 'MONEY_UNIT'			,text: '<t:message code="system.label.purchase.currency" default="화폐"/>'				,type: 'string'},
			{name: 'COMP_CODE'			,text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'			,type: 'string'},
			{name: 'DIV_CODE'			,text: '<t:message code="system.label.purchase.division" default="사업장"/>'			,type: 'string'},
			{name: 'GRANT_TYPE'			,text: '<t:message code="system.label.purchase.subcontractdivision" default="사급구분"/>'			,type: 'string'},
			{name: 'REMARK'				,text: '<t:message code="system.label.purchase.remarks" default="비고"/>'				,type: 'string'},
			{name: 'PROJECT_NO'			,text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'			,type: 'string'},
			{name: 'STOCK_CARE_YN'		,text: '<t:message code="system.label.purchase.inventorymanagementyn" default="재고관리여부"/>'			,type: 'string'},
			{name: 'LOT_YN'				,text: '<t:message code="system.label.purchase.lotmanageyn" default="LOT관리여부"/>'		,type: 'string'}
		]
	});
	
	
	
	/** Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('otr112ukrvMasterStore1',{		// 메인
		model: 'otr112ukrvModel',
		uniOpt: {
			isMaster	: true,		// 상위 버튼 연결 
			editable	: true,		// 수정 모드 사용 
			deletable	: true,		// 삭제 가능 여부 
			allDeletable: true,		// 전체 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: directProxy,
		loadStoreRecords: function() {
			var param= panelResult.getValues();
			console.log(param);
			this.load({
				params : param
			});
		},
		saveStore: function() {				
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();
			var toDelete = this.getRemovedRecords();
			var list = [].concat(toUpdate, toCreate);
			console.log("inValidRecords : ", inValidRecs);
			console.log("list:", list);
			var isErr = false;
			Ext.each(list, function(record, index) {
				if(BsaCodeInfo.gsUsePabStockYn == "Y" && record.get('INOUT_Q') > record.get('PAB_STOCK_Q') + record.get('ORIGINAL_Q')){
					alert('<t:message code="system.message.purchase.message014" default="출고량은 가용재고량을 초과할 수 없습니다."/>');
					isErr = true;
					return false;
				}				
				if(record.get('LOT_YN') == 'Y' && Ext.isEmpty(record.get('LOT_NO'))){
					alert((index + 1) + '<t:message code="system.message.commonJS.grid.invalidColumn" default="행의 입력값을 확인해 주세요."/>' + '\n' + '<t:message code="system.label.purchase.lotno" default="LOT번호"/>' + ':' + '<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>');
					isErr = true;
					return false;
				}
			});
			if(isErr) return false;

			var inoutNum = panelResult.getValue('INOUT_NUM');
			Ext.each(list, function(record, index) {
				if(record.data['INOUT_NUM'] != inoutNum) {
					record.set('INOUT_NUM', inoutNum);
				}
			})
			//console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));
			
			//1. 마스터 정보 파라미터 구성
			var paramMaster= panelResult.getValues();	//syncAll 수정
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						var result = batch.operations[0].getResultSet();
						panelResult.setValue("INOUT_NUM", result["INOUT_NUM"]);
						panelResult.getForm().wasDirty = false;
						panelResult.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);
						UniAppManager.app.onQueryButtonDown();
						if(directMasterStore1.getCount() == 0){
							UniAppManager.app.onResetButtonDown();
						}
					 } 
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('otr112ukrvGrid');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});

	//검색버튼 조회창
	var orderNoMasterStore = Unilite.createStore('orderNoMasterStore', {
		model: 'orderNoMasterModel',
		autoLoad: false,
		uniOpt : {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		proxy: {
			type: 'direct',
			api: {
				read: 'otr112ukrvService.selectDetail'
			}
		},
		loadStoreRecords : function()	{
			var param= orderNoSearch.getValues();
			this.load({
				params : param
			});
		}
	});
	
	//예약참조
	var otherOrderStore = Unilite.createStore('otr112ukrvOtherOrderStore', {
		model: 'otr112ukrvOTHERModel',
		autoLoad: false,
		uniOpt : {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		proxy: {
			type: 'direct',
			api: {
				read : 'otr112ukrvService.selectDetail2'
			}
		},
		listeners:{
			load:function(store, records, successful, eOpts) {
				if(successful)	{
					var masterRecords = directMasterStore1.data.filterBy(directMasterStore1.filterNewOnly);  
					var refRecords = new Array();
					if(masterRecords.items.length > 0) {
						console.log("store.items :", store.items);
						console.log("records", records);
						Ext.each(records, 
							function(item, i) {
								Ext.each(masterRecords.items, function(record, i) {
										if((record.data['ORDER_NUM'] == item.data['ORDER_NUM']) 
										&& (record.data['ORDER_SEQ'] == item.data['ORDER_SEQ'])
										){
											refRecords.push(item);
										}
									}
								);		
							}
						);
						store.remove(refRecords);
					}
				}
			}
		},
		loadStoreRecords : function()	{
			var param= otherorderSearch.getValues();
			this.load({
				params : param
			});
		}
	});
	
	//반품가능예약참조
	var otherOrderStore2 = Unilite.createStore('otr112ukrvotherOrderStore2', {//반품가능예약참조
		model: 'otr112ukrvOTHERModel2',
		autoLoad: false,
		uniOpt : {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		proxy: {
			type: 'direct',
			api: {
				read	: 'otr112ukrvService.selectDetail3'
			}
		},
		listeners:{
			load:function(store, records, successful, eOpts) {
				if(successful)	{
					var masterRecords = directMasterStore1.data.filterBy(directMasterStore1.filterNewOnly);  
					var refRecords = new Array();
					if(masterRecords.items.length > 0) {
						console.log("store.items :", store.items);
						console.log("records", records);
						Ext.each(records, 
					   		function(item, i) {
								Ext.each(masterRecords.items, function(record, i) {
									console.log("record :", record);
								
										if((record.data['ORDER_NUM'] == item.data['ORDER_NUM']) 
										&& (record.data['ORDER_SEQ'] == item.data['ORDER_SEQ'])
										){
											refRecords.push(item);
										}
									}
								);		
							}
						);
						store.remove(refRecords);
					}
				}
			}
		},
		loadStoreRecords : function()	{
			var param= otherorderSearch2.getValues();
			this.load({
				params : param
			});
		}
	});
	
	//바코드관련 Store
	var barcodeStore = Unilite.createStore('otr112ukrvBarcodeStore', {
		model	: 'otr112ukrvModel',
		proxy	: directProxy2,
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,			// 상위 버튼 연결
			editable	: true,			// 수정 모드 사용
			deletable	: true,			// 삭제 가능 여부
			allDeletable: true,			// 전체 삭제 가능 여부
			useNavi		: false			// prev | next 버튼 사용
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(!Ext.isEmpty(records)) {
					gsMaxInoutSeq = records[0].get('MAX_INOUT_SEQ');
				}
				panelResult.getField('BARCODE').focus();
			},
			add: function(store, records, index, eOpts) {
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
			},
			remove: function(store, record, index, isMove, eOpts) {
			}
		},
		loadStoreRecords: function() {
			var param = panelResult.getValues();
			
			console.log(param);
			this.load({
				params : param,
				callback : function(records,options,success) {
					if(success)	{
//						panelResult.setValue('LOT_NO_S', '');
					}
				}
			});
		},
		saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);

			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();
			var toDelete = this.getRemovedRecords();
			var list = [].concat(toUpdate, toCreate);
			console.log("list:", list);

			var orderNum = panelResult.getValue('INOUT_NUM');
			var isErr = false;
			Ext.each(list, function(record, index) {
				if(record.data['INOUT_NUM'] != orderNum) {
					record.set('INOUT_NUM', orderNum);
				}
				if(record.get('LOT_YN') == 'Y' && Ext.isEmpty(record.get('LOT_NO'))){
					alert((index + 1) + '<t:message code="system.message.commonJS.grid.invalidColumn" default="행의 입력값을 확인해 주세요."/>' + '\n' + '<t:message code="system.label.purchase.lotno" default="LOT번호"/>' + ':' + '<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>');
					isErr = true;
					return false;
				}
			});
			if(isErr) return false;
			
			//1. 마스터 정보 파라미터 구성
			var paramMaster= panelResult.getValues();	//syncAll 수정
			
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						var master = batch.operations[0].getResultSet();
						panelResult.setValue("INOUT_NUM", master.INOUT_NUM);
						
						panelResult.getForm().wasDirty = false;
						panelResult.resetDirtyStatus();
//						Ext.getCmp('btnPrint').setDisabled(false);			//출력버튼 활성화
						UniAppManager.setToolbarButtons(['print'], true);	//출력버튼 활성화(버튼 대신 상단 아이콘 사용)
						UniAppManager.setToolbarButtons('save', false);	
						directMasterStore1.loadStoreRecords();
						if(directMasterStore1.getCount() == 0){
							UniAppManager.app.onResetButtonDown();
						}
					} 
				};
				this.syncAllDirect(config);
			} else {
				barcodeGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});	
	
	
	
	
	var masterGrid = Unilite.createGrid('otr112ukrvGrid', {		// 메인
		store	: directMasterStore1,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			useLiveSearch	: true,
			expandLastColumn: false,
		 	useRowNumberer	: true,
		 	useContextMenu	: true
		},
		tbar: [{
			xtype: 'splitbutton',
		   	itemId:'orderTool',
			text: '<t:message code="system.label.purchase.reference" default="참조..."/>',
			iconCls : 'icon-referance',
			menu: Ext.create('Ext.menu.Menu', {
				items: [{
					itemId: 'ReservationBtn',
					text: '<t:message code="system.label.purchase.allocationrefer" default="예약참조"/>',
					handler: function() {
						if(panelResult.setAllFieldsReadOnly(true)){
							openReservationWindow();
						}
					}
				}, {
					itemId: 'ReturnReservationBtn',
					text: '<t:message code="system.label.purchase.returnavaiableallocationrefer" default="반품가능예약참조"/>',
					handler: function() {
						if(panelResult.setAllFieldsReadOnly(true)){
							openReturnReservationWindow();
						}
					}
				}]
			})
		}],  
		features: [ {id: 'masterGridSubTotal',	ftype: 'uniGroupingsummary',	showSummaryRow: false },
					{id: 'masterGridTotal',		ftype: 'uniSummary',			showSummaryRow: false} ],
		columns:  [		
//					 { dataIndex: 'REF_GUBUN'				, width:66	, hidden: false},
					 { dataIndex: 'INOUT_NUM'				, width:66	, hidden: true},
					 { dataIndex: 'INOUT_SEQ'				, width:50	, align: 'center'},
					 { dataIndex: 'INOUT_TYPE'				, width:80	, hidden: true},
					 { dataIndex: 'INOUT_METH'				, width:66	, hidden: true},
					 { dataIndex: 'INOUT_TYPE_DETAIL'		, width:76},
					 { dataIndex: 'INOUT_CODE_TYPE'			, width:76	, hidden: true},
					 { dataIndex: 'INOUT_CODE'				, width:80	, hidden: true},
					 { dataIndex: 'INOUT_NAME'				, width:150	, hidden: true},
					 { dataIndex: 'ITEM_CODE'				, width:130	,
						editor: Unilite.popup('DIV_PUMOK_G', {
					 		textFieldName: 'ITEM_CODE',
					 		DBtextFieldName: 'ITEM_CODE',
					 		extParam: {SELMODEL: 'MULTI', POPUP_TYPE: 'GRID_CODE'},
							autoPopup: true,
							listeners: {
								'onSelected': {
									fn: function(records, type) {
										console.log('records : ', records);
										Ext.each(records, function(record,i) {
											console.log('record',record);
											if(i==0) {
												masterGrid.setItemData(record,false);
												UniAppManager.app.checkStockPrice(record);
											} else {
												UniAppManager.app.onNewDataButtonDown();
												masterGrid.setItemData(record,false);
												UniAppManager.app.checkStockPrice(record);
											}
										}); 
									},
									scope: this
								},
								'onClear': function(type) {
									masterGrid.setItemData(null,true);
								},
								applyextparam: function(popup){
									popup.setExtParam({'SELMODEL': 'MULTI'});
									popup.setExtParam({'POPUP_TYPE': 'GRID_CODE'});
									popup.setExtParam({'DIV_CODE': Ext.getCmp("otr112ukrvpanelResult").getValue("DIV_CODE")});
								}
							}
						})
					 },
					 { dataIndex: 'ITEM_NAME'				, width: 180,
						editor: Unilite.popup('DIV_PUMOK_G', {
					 		extParam: {SELMODEL: 'MULTI'},
							autoPopup: true,
							listeners: {
								'onSelected': {
									fn: function(records, type) {
										console.log('records : ', records);
										Ext.each(records, function(record,i) {
											if(i==0) {
												masterGrid.setItemData(record,false);
												UniAppManager.app.checkStockPrice(record);
											} else {
												UniAppManager.app.onNewDataButtonDown();
												masterGrid.setItemData(record,false);
												UniAppManager.app.checkStockPrice(record);
											}
										}); 
									},
									scope: this
								},
								'onClear': function(type) {
									masterGrid.setItemData(null,true);
								},
								applyextparam: function(popup){
									popup.setExtParam({'SELMODEL': 'MULTI'});
									popup.setExtParam({'POPUP_TYPE': 'GRID_CODE'});
									popup.setExtParam({'DIV_CODE': Ext.getCmp("otr112ukrvpanelResult").getValue("DIV_CODE")});
								}
							}
						})
					 },
//					 { dataIndex: 'LOT_NO'					, width:120,
//						editor: Unilite.popup('LOTNO_G', {
//							textFieldName: 'LOT_CODE',
//							DBtextFieldName: 'LOT_CODE',
//							validateBlank: false,
//				 			autoPopup: true,
//							listeners: {
//								applyextparam: function(popup){
//									var record = masterGrid.getSelectedRecord();
//									var divCode = panelResult.getValue('DIV_CODE');
//									var itemCode = record.get('ITEM_CODE');
//									var itemName = record.get('ITEM_NAME');
//									var whCode = record.get('WH_CODE');
//									var whCellCode = record.get('WH_CELL_CODE');
//									var stockYN = 'Y'
//									popup.setExtParam({'DIV_CODE': divCode, 'ITEM_CODE': itemCode, 'ITEM_NAME': itemName, 'S_WH_CODE': whCode, 'S_WH_CELL_CODE': whCellCode, 'STOCK_YN': stockYN});
//								},
//								'onSelected': {
//									fn: function(records, type) {
//										console.log('records : ', records);
//										var rtnRecord;
//										Ext.each(records, function(record,i) {
//											if(i==0){
//												rtnRecord = masterGrid.uniOpt.currentRecord
//											}else{
//												rtnRecord = masterGrid.getSelectedRecord()
//											}
//											rtnRecord.set('LOT_NO',		 record['LOT_NO']);
//											rtnRecord.set('WH_CODE',		record['WH_CODE']);
//											rtnRecord.set('WH_CELL_CODE',   record['WH_CELL_CODE']);
//										}); 
//									},
//									scope: this
//								},
//								'onClear': function(type) {
//									var rtnRecord = masterGrid.uniOpt.currentRecord;
//									rtnRecord.set('LOT_NO', '');
//								}
//							}
//						})
//					 },
					 { dataIndex: 'LOT_YN'					, width:120		, hidden: true },
					 { dataIndex: 'SPEC'					, width:180}	,
					 { dataIndex: 'STOCK_UNIT'				, width:90		, align: 'center'},
					 { dataIndex: 'WH_CODE'					, width:110}	,
					 { dataIndex: 'WH_NAME'					, width:93		, hidden: true},
					 { dataIndex: 'WH_CELL_CODE'			, width:100		, hidden: sumtypeCell},
					 { dataIndex: 'WH_CELL_NAME'			, width:100		, hidden: true},
					 { dataIndex: 'ALLOC_Q'					, width:96},
					 { dataIndex: 'NOT_OUTSTOCK_Q'			, width:96},
					 { dataIndex: 'INOUT_Q'					, width:96},
//					 { dataIndex: 'ITEM_STATUS'				, width:96		, align: 'center'},
					 { dataIndex: 'ORIGINAL_Q'				, width:96		, hidden: true},
//	   				 { dataIndex: 'PAB_STOCK_Q'				, width:100		, hidden: usePabStockYn},
					 { dataIndex: 'GOOD_STOCK_Q'			, width:96},
					 { dataIndex: 'BAD_STOCK_Q'				, width:96},
					 { dataIndex: 'INOUT_DATE'				, width:100		, hidden: true},
					 { dataIndex: 'COMP_CODE'				, width:100		, hidden: true},
					 { dataIndex: 'DIV_CODE'				, width:60		, hidden: true},
					 { dataIndex: 'INOUT_P'					, width:100		, hidden: true},
					 { dataIndex: 'INOUT_I'					, width:100		, hidden: true},
					 { dataIndex: 'EXPENSE_I'				, width:100		, hidden: true},
					 { dataIndex: 'MONEY_UNIT'				, width:100		, hidden: true},
					 { dataIndex: 'INOUT_FOR_P'				, width:100		, hidden: true},
					 { dataIndex: 'INOUT_FOR_O'				, width:100		, hidden: true},
					 { dataIndex: 'EXCHG_RATE_O'			, width:100		, hidden: true},
					 { dataIndex: 'ORDER_TYPE'				, width:100		, hidden: true},
					 { dataIndex: 'ORDER_NUM'				, width:100		, hidden: true},
					 { dataIndex: 'ORDER_SEQ'				, width:100		, hidden: true},
					 { dataIndex: 'LC_NUM'					, width:100		, hidden: true},
					 { dataIndex: 'BL_NUM'					, width:100		, hidden: true},
					 { dataIndex: 'INOUT_PRSN'				, width:100		, hidden: true},
					 { dataIndex: 'BASIS_NUM'				, width:100		, hidden: true},
					 { dataIndex: 'BASIS_SEQ'				, width:100		, hidden: true},
					 { dataIndex: 'ACCOUNT_YNC'				, width:100		, hidden: true},
					 { dataIndex: 'ACCOUNT_Q'				, width:100		, hidden: true},
					 { dataIndex: 'CREATE_LOC'				, width:100		, hidden: true},
					 { dataIndex: 'SALE_C_YN'				, width:100		, hidden: true},
					 { dataIndex: 'SALE_C_DATE'				, width:100		, hidden: true},
					 { dataIndex: 'SALE_C_REMARK'			, width:100		, hidden: true},
					 { dataIndex: 'GRANT_TYPE'				, width:100		, hidden: true},
					 { dataIndex: 'PROJECT_NO'  			, width:120},
					 { dataIndex: 'SALE_DIV_CODE'			, width:133		, hidden: true},
					 { dataIndex: 'SALE_CUSTOM_CODE'		, width:66		, hidden: true},
					 { dataIndex: 'BILL_TYPE'				, width:66		, hidden: true},
					 { dataIndex: 'SALE_TYPE'				, width:66		, hidden: true},
					 { dataIndex: 'UPDATE_DB_USER'			, width:66		, hidden: true},
					 { dataIndex: 'UPDATE_DB_TIME'			, width:66		, hidden: true},
					 { dataIndex: 'ITEM_ACCOUNT'			, width:66		, hidden: true},
					 { dataIndex: 'STOCK_CARE_YN'			, width:66		, hidden: true},
					 { dataIndex: 'REMARK'					, width:200}
		],
		listeners: {
			afterrender: function(grid) {	//useContextMenu:true 설정으로 툴바 우측 버튼은 자동 생성되며 그 외 추가할 메뉴  작성
				this.contextMenu.add({
					xtype: 'menuseparator'
				},{	
					text: '<t:message code="system.label.purchase.iteminfo" default="품목정보"/>',   iconCls : '',
					handler: function(menuItem, event) {	
						var record = grid.getSelectedRecord();
						var params = {
							ITEM_CODE : record.get('ITEM_CODE')
						}
						var rec = {data : {prgID : 'bpr100ukrv', 'text':''}};
						parent.openTab(rec, '/base/bpr100ukrv.do', params);
					}
				},{	
					text: '<t:message code="system.label.purchase.custominfo" default="거래처정보"/>',   iconCls : '',
					handler: function(menuItem, event) {
						var params = {
							CUSTOM_CODE : panelResult.getValue('CUSTOM_CODE'),
							COMP_CODE : UserInfo.compCode
						}
						var rec = {data : {prgID : 'bcm100ukrv', 'text':''}};
						parent.openTab(rec, '/base/bcm100ukrv.do', params);
					}
				})
			},
			//contextMenu의 복사한 행 삽입 실행 전
			beforePasteRecord: function(rowIndex, record) {
				if(!UniAppManager.app.checkForNewDetail()) return false;
					var seq = directMasterStore1.max('INOUT_SEQ');
					if(!seq) seq = 1;
					else  seq += 1;
			  		record.INOUT_SEQ = seq;

			  		return true;
			},
			//contextMenu의 복사한 행 삽입 실행 후
			afterPasteRecord: function(rowIndex, record) {
				panelResult.setAllFieldsReadOnly(true);
			}
		},
		listeners: {	  	
			render: function(grid, eOpts){
				var girdNm	= grid.getItemId();
				var store	= grid.getStore();
				grid.getEl().on('click', function(e, t, eOpt) {
					var oldGrid = Ext.getCmp(activeGridId);
					grid.changeFocusCls(oldGrid);
					activeGridId = girdNm;
					//store.onStoreActionEnable();
					if( barcodeStore.isDirty() ) {
						UniAppManager.setToolbarButtons('save', true);
					}else {
						UniAppManager.setToolbarButtons('save', false);
					}
					if(grid.getStore().getCount() > 0) {
						UniAppManager.setToolbarButtons('delete', true);
					}else {
						UniAppManager.setToolbarButtons('delete', false);
					}
					
					if(gsSaveFlag) {
						UniAppManager.setToolbarButtons('save', true);
					} else {
						UniAppManager.setToolbarButtons('save', false);
					}

				});
			},
			selectionChange: function( gird, selected, eOpts )	{
				barcodeStore.clearFilter();
				if(UniAppManager.app._needSave()) {
					gsSaveFlag = true;
				} else {
					gsSaveFlag = false;
				}
				//선택된 행의 저장된 데이터만 barcodeGrid에 보여주도록 filter
				if(!Ext.isEmpty(selected)) {
					barcodeStore.filterBy(function(record){
						return record.get('ORDER_NUM') == selected[0].get('ORDER_NUM')
							&& record.get('ITEM_CODE') == selected[0].get('ITEM_CODE');
					})
				}
//				var colName = e.position.column.dataIndex;
//				if(colName == 'INOUT_NUM') {
				panelResult.getField('BARCODE').focus();
//				}
			},
			beforeedit: function( editor, e, eOpts ) {
				if(e.record.phantom == false) {		// 신규데이터가 아닌것.
					return false;
/*					
					if(UniUtils.indexOf(e.field, ['LOT_NO'])){
						if(Ext.isEmpty(e.record.data.ITEM_CODE)){
							alert(Msg.sMS003);
							return false;
						}
						if(Ext.isEmpty(e.record.data.WH_CODE) && BsaCodeInfo.gsManageLotNoYN == 'Y' ){
							alert('출고창고를 입력하십시오.');
							return false;
						}
						if(BsaCodeInfo.gsSumTypeCell == 'Y' && Ext.isEmpty(e.record.data.WH_CELL_CODE)){
							alert('출고창고 CELL코드를 입력하십시오.');
							return false;
						}
					}
  					if(UniUtils.indexOf(e.field, ['INOUT_TYPE_DETAIL', 'WH_NAME', 'WH_CELL_CODE', 'LOT_NO',
												  'INOUT_Q', 'ITEM_STATUS', 'REMARK', 'PROJECT_NO'])) { 
						return true;
	  				} else {
	  					return false;
	  				}*/
				} else {
					if (UniUtils.indexOf(e.field, 'LOT_NO')){
						if(Ext.isEmpty(e.record.data.ITEM_CODE)){
							alert(Msg.sMS003);
							return false;
						}
						if(Ext.isEmpty(e.record.data.WH_CODE) && BsaCodeInfo.gsManageLotNoYN == 'Y' ){
							alert('<t:message code="system.message.purchase.message015" default="출고창고를 입력하십시오."/>');
							return false;
						}
						if(BsaCodeInfo.gsSumTypeCell == 'Y' && Ext.isEmpty(e.record.data.WH_CELL_CODE)){
							alert('<t:message code="system.message.purchase.message016" default="출고창고 CELL코드를 입력하십시오."/>');
							return false;
						}
					}
					if(UniUtils.indexOf(e.field, ['INOUT_SEQ', 'INOUT_TYPE_DETAIL', 'ITEM_CODE', 'ITEM_NAME', 'WH_CODE', 'WH_CELL_CODE',
												  'LOT_NO', 'INOUT_Q', 'ITEM_STATUS', 'REMARK', 'PROJECT_NO'])) 
				   	{
						return true;
	  				} else {
	  					return false;
	  				}
				}
			}
		},
		setReservationData: function(record) {						// 예약참조 셋팅
			var grdRecord = this.getSelectedRecord();	
			grdRecord.set('DIV_CODE'			, panelResult.getValue('DIV_CODE'));
//			grdRecord.set('INOUT_DATE'			, record['ORDER_DATE']);
			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
			grdRecord.set('ITEM_STATUS'			, '1');
			if(Ext.isEmpty(panelResult.getValue('WH_CODE'))) {
				grdRecord.set('WH_CODE'			, record['WH_CODE']);
			} else {
				grdRecord.set('WH_CODE'			, panelResult.getValue('WH_CODE'));
			}
			grdRecord.set('INOUT_CODE'			, record['CUSTOM_CODE']);
			grdRecord.set('INOUT_NAME'			, record['CUSTOM_NAME']);
			grdRecord.set('SPEC'				, record['SPEC']);
			grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);
			grdRecord.set('INOUT_METH'			, '1');
			grdRecord.set('NOT_OUTSTOCK_Q'		, record['NOT_OUTSTOCK']);
			grdRecord.set('ORIGINAL_Q'			, '0');
			grdRecord.set('ALLOC_Q'				, record['ALLOC_Q']);
			grdRecord.set('INOUT_Q'				, 0);
//			grdRecord.set('INOUT_Q'				, record['NOT_OUTSTOCK']);
			grdRecord.set('EXPENSE_I'			, '');
			grdRecord.set('MONEY_UNIT'			, record['MONEY_UNIT']);
			grdRecord.set('INOUT_FOR_P'			, '');
			grdRecord.set('INOUT_FOR_O'			, '');
			grdRecord.set('EXCHG_RATE_O'		, '');
			grdRecord.set('ORDER_TYPE'			, '4');	
			grdRecord.set('ORDER_NUM'			, record['ORDER_NUM']);
			grdRecord.set('ORDER_SEQ'			, record['ORDER_SEQ']);
			grdRecord.set('LC_NUM'				, '');
			grdRecord.set('BL_NUM'				, '');
			grdRecord.set('INOUT_PRSN'			, panelResult.getValue('INOUT_PRSN'));
			grdRecord.set('BASIS_NUM'			, '');
			grdRecord.set('BASIS_SEQ'			, '');
			grdRecord.set('ACCOUNT_YNC'			, '');
			grdRecord.set('ACCOUNT_Q'			, '0');
			grdRecord.set('CREATE_LOC'			, '2');
			grdRecord.set('SALE_C_YN'			, 'N');
			grdRecord.set('SALE_C_DATE'			, '');
			grdRecord.set('SALE_C_REMARK'		, '');
			grdRecord.set('WH_NAME'				, record['WH_CODE']);
			grdRecord.set('REMARK'				, record['REMARK']);
			grdRecord.set('PROJECT_NO'			, record['PROJECT_NO']);
			grdRecord.set('GRANT_TYPE'			, record['GRANT_TYPE']);
			grdRecord.set('STOCK_CARE_YN'		, record['STOCK_CARE_YN']);
			grdRecord.set('LOT_YN'				, record['LOT_YN']);
			grdRecord.set('SALE_DIV_CODE'		, '*');
			grdRecord.set('SALE_CUSTOM_CODE'	, '*');
			grdRecord.set('SALE_TYPE'			, '*');
			grdRecord.set('BILL_TYPE'			, '*');
			
			if(grdRecord.get('INOUT_METH') == "2" && BsaCodeInfo.gsUsePabStockYn == "Y"){   //예외 출고 및 가용재고체크 사용할시
				UniMatrl.fnStockQ_kd(grdRecord, UniAppManager.app.cbStockQ_kd, UserInfo.compCode, grdRecord.get('DIV_CODE'), UniDate.getDbDateStr(grdRecord.get('INOUT_DATE')), grdRecord.get('ITEM_CODE'));
			}
			UniMatrl.fnStockQ(grdRecord, UniAppManager.app.cbStockQ, UserInfo.compCode
							, grdRecord.get('DIV_CODE'), null, grdRecord.get('ITEM_CODE')
							, grdRecord.get('WH_CODE') );
			panelResult.getField('BARCODE').focus();
		},
		setReturnReservationData: function(record) {				// 반품가능 예약참조 셋팅
			var grdRecord = this.getSelectedRecord();
			grdRecord.set('REF_GUBUN'			, 'R');
			grdRecord.set('INOUT_NUM'			, panelResult.getValue('INOUT_NUM'));
			grdRecord.set('INOUT_TYPE'			, '2');
			grdRecord.set('INOUT_METH'			, '1');
			grdRecord.set('INOUT_TYPE_DETAIL'	, '10');
			grdRecord.set('INOUT_CODE_TYPE'		, '5');
			grdRecord.set('INOUT_CODE'			, record['CUSTOM_CODE']);
			grdRecord.set('INOUT_NAME'			, record['CUSTOM_NAME']);
			if(Ext.isEmpty(panelResult.getValue('WH_CODE'))) {
				grdRecord.set('WH_CODE'			, record['WH_CODE']);
			} else {
				grdRecord.set('WH_CODE'			, panelResult.getValue('WH_CODE'));
			}
			grdRecord.set('DIV_CODE'			, record['DIV_CODE']);
			grdRecord.set('INOUT_DATE'			, panelResult.getValue('INOUT_DATE'));
			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
			grdRecord.set('ITEM_STATUS'			, '1');
			grdRecord.set('SPEC'				, record['SPEC']);
			grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);
			grdRecord.set('NOT_OUTSTOCK_Q'		, record['NOT_OUTSTOCK']);
			grdRecord.set('ORIGINAL_Q'			, '0');;
			grdRecord.set('ALLOC_Q'				, record['ALLOC_Q']);
			grdRecord.set('INOUT_Q'				, 0);
//			grdRecord.set('INOUT_Q'				, record['NOT_OUTSTOCK']);
			grdRecord.set('EXPENSE_I'			, '');
			grdRecord.set('MONEY_UNIT'			, record['MONEY_UNIT']);
			grdRecord.set('INOUT_FOR_P'			, '');
			grdRecord.set('INOUT_FOR_O'			, '');
			grdRecord.set('EXCHG_RATE_O'		, '');
			grdRecord.set('ORDER_TYPE'			, '4');
			grdRecord.set('ORDER_NUM'			, record['ORDER_NUM']);
			grdRecord.set('ORDER_SEQ'			, record['ORDER_SEQ']);
			grdRecord.set('LC_NUM'				, '');
			grdRecord.set('BL_NUM'				, '');
			grdRecord.set('INOUT_PRSN'			, panelResult.getValue('INOUT_PRSN'));
			grdRecord.set('BASIS_NUM'			, '');
			grdRecord.set('BASIS_SEQ'			, '');
			grdRecord.set('ACCOUNT_YNC'			, '');
			grdRecord.set('ACCOUNT_Q'			, '0');
			grdRecord.set('CREATE_LOC'			, '2');
			grdRecord.set('SALE_C_YN'			, 'N');
			grdRecord.set('SALE_C_DATE'			, '');
			grdRecord.set('SALE_C_REMARK'		, '');
			grdRecord.set('REMARK'				, '');
			grdRecord.set('GRANT_TYPE'			, record['GRANT_TYPE']);
			grdRecord.set('STOCK_CARE_YN'		, record['STOCK_CARE_YN']);
			grdRecord.set('LOT_YN'				, record['LOT_YN']);
			grdRecord.set('SALE_DIV_CODE'		, '*');
			grdRecord.set('SALE_CUSTOM_CODE'	, '*');
			grdRecord.set('SALE_TYPE'			, '*');
			grdRecord.set('BILL_TYPE'			, '*');
			UniMatrl.fnStockQ(grdRecord, UniAppManager.app.cbStockQ, UserInfo.compCode
							, grdRecord.get('DIV_CODE'), null, grdRecord.get('ITEM_CODE')
							, grdRecord.get('WH_CODE') );
			panelResult.getField('BARCODE').focus();
		},
		setItemData: function(record, dataClear) {
			var grdRecord = this.getSelectedRecord();
			if(dataClear) {
				grdRecord.set('ITEM_CODE'		, "");
				grdRecord.set('ITEM_NAME'		, "");
				grdRecord.set('SPEC'			, ""); 
				grdRecord.set('WH_CODE'			, ""); 
				grdRecord.set('STOCK_UNIT'		, "");
				grdRecord.set('ACCOUNT_Q'		, 0);
				grdRecord.set('NOT_OUTSTOCK_Q'	, 0);
				grdRecord.set('INOUT_Q'			, 0);
				grdRecord.set('ORIGINAL_Q'		, 0);
				grdRecord.set('GOOD_STOCK_Q'	, 0); 
				grdRecord.set('BAD_STOCK_Q'		, 0);
				grdRecord.set('STOCK_Q'			, 0);
				grdRecord.set('DISCOUNT_RATE'	, 0);
				grdRecord.set('LOT_NO'			, '');
				grdRecord.set('WH_NAME'			, '');
				grdRecord.set('WH_CELL_CODE'	, '');
				grdRecord.set('WH_CELL_NAME'	, '');
				grdRecord.set('LOT_YN'			, '');
			} else {
				grdRecord.set('ITEM_CODE'		, record['ITEM_CODE']);
				grdRecord.set('ITEM_NAME'		, record['ITEM_NAME']);
				grdRecord.set('ITEM_ACCOUNT'	, record['ITEM_ACCOUNT']);
				grdRecord.set('SPEC'			, record['SPEC']); 
				if(Ext.isEmpty(panelResult.getValue('WH_CODE'))) {
					grdRecord.set('WH_CODE'		, record['WH_CODE']);
				} else {
					grdRecord.set('WH_CODE'		, panelResult.getValue('WH_CODE'));
				}
				grdRecord.set('STOCK_UNIT'		, record['STOCK_UNIT']);
				grdRecord.set('ORDER_NUM'		, panelResult.getValue('ORDER_NUM'));
				grdRecord.set('LOT_YN'			, record['LOT_YN']);
				
				if(grdRecord.get('INOUT_METH') == "2" && BsaCodeInfo.gsUsePabStockYn == "Y"){   //예외 출고 및 가용재고체크 사용할시
					UniMatrl.fnStockQ_kd(grdRecord, UniAppManager.app.cbStockQ_kd, UserInfo.compCode, grdRecord.get('DIV_CODE'), UniDate.getDbDateStr(grdRecord.get('INOUT_DATE')), grdRecord.get('ITEM_CODE'));
				}
				UniMatrl.fnStockQ(grdRecord, UniAppManager.app.cbStockQ, UserInfo.compCode
								, grdRecord.get('DIV_CODE'), null, grdRecord.get('ITEM_CODE')
								, grdRecord.get('WH_CODE') );
			}
		}
	});
	
	var barcodeGrid = Unilite.createGrid('otr112ukrvBarcodeGridGrid', {		// 메인
		store	: barcodeStore,
		layout	: 'fit',
		region	: 'south',
		split	: true,
		flex	: 0.5,
		uniOpt	: {
			expandLastColumn	: true,
			useLiveSearch		: true,
			expandLastColumn	: false,
		 	useRowNumberer		: true,
		 	useContextMenu		: true
		},
		features: [ {id: 'masterGridSubTotal',	ftype: 'uniGroupingsummary',	showSummaryRow: false },
					{id: 'masterGridTotal',		ftype: 'uniSummary',			showSummaryRow: false} ],
		columns:  [		
					 { dataIndex: 'INOUT_NUM'				, width:66	, hidden: true},
//					 { dataIndex: 'INOUT_SEQ'				, width:50	, align: 'center'},
//					 { dataIndex: 'INOUT_TYPE'				, width:80	, hidden: true},
					 { dataIndex: 'INOUT_METH'				, width:66	, hidden: true},
//					 { dataIndex: 'INOUT_TYPE_DETAIL'		, width:76},
					 { dataIndex: 'INOUT_CODE_TYPE'			, width:76	, hidden: true},
					 { dataIndex: 'INOUT_CODE'				, width:80	, hidden: true},
					 { dataIndex: 'INOUT_NAME'				, width:150	, hidden: true},
					 { dataIndex: 'ITEM_CODE'				, width:130	,
						editor: Unilite.popup('DIV_PUMOK_G', {
					 		textFieldName: 'ITEM_CODE',
					 		DBtextFieldName: 'ITEM_CODE',
					 		extParam: {SELMODEL: 'MULTI', POPUP_TYPE: 'GRID_CODE'},
							autoPopup: true,
							listeners: {
								'onSelected': {
									fn: function(records, type) {
										console.log('records : ', records);
										Ext.each(records, function(record,i) {
											console.log('record',record);
											if(i==0) {
												masterGrid.setItemData(record,false);
												UniAppManager.app.checkStockPrice(record);
											} else {
												UniAppManager.app.onNewDataButtonDown();
												masterGrid.setItemData(record,false);
												UniAppManager.app.checkStockPrice(record);
											}
										}); 
									},
									scope: this
								},
								'onClear': function(type) {
									masterGrid.setItemData(null,true);
								},
								applyextparam: function(popup){
									popup.setExtParam({'SELMODEL': 'MULTI'});
									popup.setExtParam({'POPUP_TYPE': 'GRID_CODE'});
									popup.setExtParam({'DIV_CODE': Ext.getCmp("otr112ukrvpanelResult").getValue("DIV_CODE")});
								}
							}
						})
					 },
					 {dataIndex: 'ITEM_NAME'				, width: 180,
						editor: Unilite.popup('DIV_PUMOK_G', {
					 		extParam: {SELMODEL: 'MULTI'},
							autoPopup: true,
							listeners: {
								'onSelected': {
									fn: function(records, type) {
										console.log('records : ', records);
										Ext.each(records, function(record,i) {
											if(i==0) {
												masterGrid.setItemData(record,false);
												UniAppManager.app.checkStockPrice(record);
											} else {
												UniAppManager.app.onNewDataButtonDown();
												masterGrid.setItemData(record,false);
												UniAppManager.app.checkStockPrice(record);
											}
										}); 
									},
									scope: this
								},
								'onClear': function(type) {
									masterGrid.setItemData(null,true);
								},
								applyextparam: function(popup){
									popup.setExtParam({'SELMODEL': 'MULTI'});
									popup.setExtParam({'POPUP_TYPE': 'GRID_CODE'});
									popup.setExtParam({'DIV_CODE': Ext.getCmp("otr112ukrvpanelResult").getValue("DIV_CODE")});
								}
							}
						})
					 },
					 { dataIndex: 'LOT_YN'					, width:120		, hidden: true },
					 { dataIndex: 'SPEC'					, width:180}	,
					 { dataIndex: 'STOCK_UNIT'				, width:90		, align: 'center'},
					 { dataIndex: 'WH_CODE'					, width:110}	,
					 { dataIndex: 'WH_NAME'					, width:93		, hidden: true},
					 { dataIndex: 'WH_CELL_CODE'			, width:100		, hidden: sumtypeCell},
					 { dataIndex: 'WH_CELL_NAME'			, width:100		, hidden: true},
//					 { dataIndex: 'ALLOC_Q'					, width:96},
//					 { dataIndex: 'NOT_OUTSTOCK_Q'			, width:96},
					 { dataIndex: 'INOUT_Q'					, width:96},
					 { dataIndex: 'LOT_NO'					, width:120,
						editor: Unilite.popup('LOTNO_G', {
							textFieldName: 'LOT_CODE',
							DBtextFieldName: 'LOT_CODE',
							validateBlank: false,
				 			autoPopup: true,
							listeners: {
								applyextparam: function(popup){
									var record = masterGrid.getSelectedRecord();
									var divCode = panelResult.getValue('DIV_CODE');
									var itemCode = record.get('ITEM_CODE');
									var itemName = record.get('ITEM_NAME');
									var whCode = record.get('WH_CODE');
									var whCellCode = record.get('WH_CELL_CODE');
									var stockYN = 'Y'
									popup.setExtParam({'DIV_CODE': divCode, 'ITEM_CODE': itemCode, 'ITEM_NAME': itemName, 'S_WH_CODE': whCode, 'S_WH_CELL_CODE': whCellCode, 'STOCK_YN': stockYN});
								},
								'onSelected': {
									fn: function(records, type) {
										console.log('records : ', records);
										var rtnRecord;
										Ext.each(records, function(record,i) {
											if(i==0){
												rtnRecord = masterGrid.uniOpt.currentRecord
											}else{
												rtnRecord = masterGrid.getSelectedRecord()
											}
											rtnRecord.set('LOT_NO',		 record['LOT_NO']);
											rtnRecord.set('WH_CODE',		record['WH_CODE']);
											rtnRecord.set('WH_CELL_CODE',   record['WH_CELL_CODE']);
										}); 
									},
									scope: this
								},
								'onClear': function(type) {
									var rtnRecord = masterGrid.uniOpt.currentRecord;
									rtnRecord.set('LOT_NO', '');
								}
							}
						})
					 },
//					 { dataIndex: 'ITEM_STATUS'				, width:96		, align: 'center'},
					 { dataIndex: 'ORIGINAL_Q'				, width:96		, hidden: true},
//	   				 { dataIndex: 'PAB_STOCK_Q'				, width:100		, hidden: usePabStockYn},
//					 { dataIndex: 'GOOD_STOCK_Q'			, width:96},
//					 { dataIndex: 'BAD_STOCK_Q'				, width:96},
					 { dataIndex: 'INOUT_DATE'				, width:100		, hidden: true},
					 { dataIndex: 'COMP_CODE'				, width:100		, hidden: true},
					 { dataIndex: 'DIV_CODE'				, width:60		, hidden: true},
					 { dataIndex: 'INOUT_P'					, width:100		, hidden: true},
					 { dataIndex: 'INOUT_I'					, width:100		, hidden: true},
					 { dataIndex: 'EXPENSE_I'				, width:100		, hidden: true},
					 { dataIndex: 'MONEY_UNIT'				, width:100		, hidden: true},
					 { dataIndex: 'INOUT_FOR_P'				, width:100		, hidden: true},
					 { dataIndex: 'INOUT_FOR_O'				, width:100		, hidden: true},
					 { dataIndex: 'EXCHG_RATE_O'			, width:100		, hidden: true},
					 { dataIndex: 'ORDER_TYPE'				, width:100		, hidden: true},
					 { dataIndex: 'ORDER_NUM'				, width:100		, hidden: true},
					 { dataIndex: 'ORDER_SEQ'				, width:100		, hidden: true},
					 { dataIndex: 'LC_NUM'					, width:100		, hidden: true},
					 { dataIndex: 'BL_NUM'					, width:100		, hidden: true},
					 { dataIndex: 'INOUT_PRSN'				, width:100		, hidden: true},
					 { dataIndex: 'BASIS_NUM'				, width:100		, hidden: true},
					 { dataIndex: 'BASIS_SEQ'				, width:100		, hidden: true},
					 { dataIndex: 'ACCOUNT_YNC'				, width:100		, hidden: true},
					 { dataIndex: 'ACCOUNT_Q'				, width:100		, hidden: true},
					 { dataIndex: 'CREATE_LOC'				, width:100		, hidden: true},
					 { dataIndex: 'SALE_C_YN'				, width:100		, hidden: true},
					 { dataIndex: 'SALE_C_DATE'				, width:100		, hidden: true},
					 { dataIndex: 'SALE_C_REMARK'			, width:100		, hidden: true},
					 { dataIndex: 'GRANT_TYPE'				, width:100		, hidden: true},
//					 { dataIndex: 'REMARK'					, width:200},
//					 { dataIndex: 'PROJECT_NO'  			, width:120},
					 { dataIndex: 'SALE_DIV_CODE'			, width:133		, hidden: true},
					 { dataIndex: 'SALE_CUSTOM_CODE'		, width:66		, hidden: true},
					 { dataIndex: 'BILL_TYPE'				, width:66		, hidden: true},
					 { dataIndex: 'SALE_TYPE'				, width:66		, hidden: true},
					 { dataIndex: 'UPDATE_DB_USER'			, width:66		, hidden: true},
					 { dataIndex: 'UPDATE_DB_TIME'			, width:66		, hidden: true},
					 { dataIndex: 'ITEM_ACCOUNT'			, width:66		, hidden: true},
					 { dataIndex: 'STOCK_CARE_YN'			, width:66		, hidden: true}
		],
		listeners: {
			render: function(grid, eOpts){
				var girdNm	= grid.getItemId();
				var store	= grid.getStore();
				grid.getEl().on('click', function(e, t, eOpt) {
					var oldGrid = Ext.getCmp(activeGridId);
					grid.changeFocusCls(oldGrid);
					activeGridId = girdNm;
					//store.onStoreActionEnable();
					if( barcodeStore.isDirty() ) {
						UniAppManager.setToolbarButtons('save', true);
					}else {
						UniAppManager.setToolbarButtons('save', false);
					}
					if(grid.getStore().getCount() > 0) {
						UniAppManager.setToolbarButtons('delete', true);
					}else {
						UniAppManager.setToolbarButtons('delete', false);
					}
					
					if(gsSaveFlag) {
						UniAppManager.setToolbarButtons('save', true);
					} else {
						UniAppManager.setToolbarButtons('save', false);
					}

				});
			},
			beforeedit: function( editor, e, eOpts ) {
				if(e.record.phantom == false) {		// 신규데이터가 아닌것.
					if(UniUtils.indexOf(e.field, ['LOT_NO'])){
						if(Ext.isEmpty(e.record.data.ITEM_CODE)){
							alert(Msg.sMS003);
							return false;
						}
						if(Ext.isEmpty(e.record.data.WH_CODE) && BsaCodeInfo.gsManageLotNoYN == 'Y' ){
							alert('<t:message code="system.message.purchase.message015" default="출고창고를 입력하십시오."/>');
							return false;
						}
						if(BsaCodeInfo.gsSumTypeCell == 'Y' && Ext.isEmpty(e.record.data.WH_CELL_CODE)){
							alert('<t:message code="system.message.purchase.message016" default="출고창고 CELL코드를 입력하십시오."/>');
							return false;
						}
					}
  					if(UniUtils.indexOf(e.field, ['INOUT_TYPE_DETAIL', 'WH_NAME', 'WH_CELL_CODE', 'LOT_NO',
												  'INOUT_Q', 'ITEM_STATUS', 'REMARK', 'PROJECT_NO'])) { 
						return true;
	  				} else {
	  					return false;
	  				}
				} else {
					if (UniUtils.indexOf(e.field, 'LOT_NO')){
						if(Ext.isEmpty(e.record.data.ITEM_CODE)){
							alert(Msg.sMS003);
							return false;
						}
						if(Ext.isEmpty(e.record.data.WH_CODE) && BsaCodeInfo.gsManageLotNoYN == 'Y' ){
							alert('<t:message code="system.message.purchase.message015" default="출고창고를 입력하십시오."/>');
							return false;
						}
						if(BsaCodeInfo.gsSumTypeCell == 'Y' && Ext.isEmpty(e.record.data.WH_CELL_CODE)){
							alert('<t:message code="system.message.purchase.message016" default="출고창고 CELL코드를 입력하십시오."/>');
							return false;
						}
					}
					if(UniUtils.indexOf(e.field, ['INOUT_SEQ', 'INOUT_TYPE_DETAIL', 'ITEM_CODE', 'ITEM_NAME', 'WH_CODE', 'WH_CELL_CODE',
												  'LOT_NO', 'INOUT_Q', 'ITEM_STATUS', 'REMARK', 'PROJECT_NO'])) 
				   	{
						return true;
	  				} else {
	  					return false;
	  				}
				}
			}
		},
		setItemData: function(record, dataClear) {
			var grdRecord = this.getSelectedRecord();
			if(dataClear) {
				grdRecord.set('ITEM_CODE'		, "");
				grdRecord.set('ITEM_NAME'		, "");
				grdRecord.set('SPEC'			, ""); 
				grdRecord.set('WH_CODE'			, ""); 
				grdRecord.set('STOCK_UNIT'		, "");
				grdRecord.set('ACCOUNT_Q'		, 0);
				grdRecord.set('NOT_OUTSTOCK_Q'	, 0);
				grdRecord.set('INOUT_Q'			, 0);
				grdRecord.set('ORIGINAL_Q'		, 0);
				grdRecord.set('GOOD_STOCK_Q'	, 0); 
				grdRecord.set('BAD_STOCK_Q'		, 0);
				grdRecord.set('STOCK_Q'			, 0);
				grdRecord.set('DISCOUNT_RATE'	, 0);
				grdRecord.set('LOT_NO'			, '');
				grdRecord.set('WH_NAME'			, '');
				grdRecord.set('WH_CELL_CODE'	, '');
				grdRecord.set('WH_CELL_NAME'	, '');
				grdRecord.set('LOT_YN'			, '');
			} else {
				grdRecord.set('ITEM_CODE'		, record['ITEM_CODE']);
				grdRecord.set('ITEM_NAME'		, record['ITEM_NAME']);
				grdRecord.set('ITEM_ACCOUNT'	, record['ITEM_ACCOUNT']);
				grdRecord.set('SPEC'			, record['SPEC']); 
				if(Ext.isEmpty(panelResult.getValue('WH_CODE'))) {
					grdRecord.set('WH_CODE'		, record['WH_CODE']);
				} else {
					grdRecord.set('WH_CODE'		, panelResult.getValue('WH_CODE'));
				}
//				grdRecord.set('WH_CODE'			, record['WH_CODE']); 
				grdRecord.set('STOCK_UNIT'		, record['STOCK_UNIT']);
				grdRecord.set('ORDER_NUM'		, panelResult.getValue('ORDER_NUM'));
				grdRecord.set('LOT_YN'			, record['LOT_YN']);
				
				if(grdRecord.get('INOUT_METH') == "2" && BsaCodeInfo.gsUsePabStockYn == "Y"){   //예외 출고 및 가용재고체크 사용할시
					UniMatrl.fnStockQ_kd(grdRecord, UniAppManager.app.cbStockQ_kd, UserInfo.compCode, grdRecord.get('DIV_CODE'), UniDate.getDbDateStr(grdRecord.get('INOUT_DATE')), grdRecord.get('ITEM_CODE'));
				}
//				UniMatrl.fnStockQ(grdRecord, UniAppManager.app.cbStockQ, UserInfo.compCode, grdRecord.get('DIV_CODE'), null, grdRecord.get('ITEM_CODE'), grdRecord.get('WH_CODE'));
			}
		}
	});
	
	var orderNoMasterGrid = Unilite.createGrid('otr112ukrvOrderNoMasterGrid', {		// 검색팝업창
		// title: '기본',
		layout : 'fit',	   
		store: orderNoMasterStore,
		uniOpt:{
			useLiveSearch : true,
			useRowNumberer: false
		},
		columns:  [ 
					 { dataIndex: 'INOUT_DATE'			,  width: 100, align:"center"}, 
					 { dataIndex: 'INOUT_CODE'			,  width: 133, hidden: true}, 
					 { dataIndex: 'CUSTOM_NAME'			,  width: 173}, 
					 { dataIndex: 'WH_CODE'				,  width: 153}, 
					 { dataIndex: 'INOUT_PRSN'			,  width: 120}, 
					 { dataIndex: 'INOUT_NUM'			,  width: 166}, 
					 { dataIndex: 'LOT_NO'				,  width: 86}
		] ,
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
				 orderNoMasterGrid.returnData(record);
				 UniAppManager.app.onQueryButtonDown();
				 SearchInfoWindow.hide();
			}
		},
		returnData: function(record)	{
			if(Ext.isEmpty(record))	{
		  		record = this.getSelectedRecord();
		  	}
		  	panelResult.setValues({
		  		'INOUT_NUM'	: record.get('INOUT_NUM') ,
		  		'CUSTOM_CODE'  : record.get('INOUT_CODE'), 
		  		'CUSTOM_NAME'  : record.get('CUSTOM_NAME'), 
		  		'INOUT_DATE'   : record.get('INOUT_DATE'), 
		  		'INOUT_PRSN'   : record.get('INOUT_PRSN')
		  	});
		} 
	});
	
	//预定参考
	var otherorderGrid = Unilite.createGrid('otr112ukrvotherorderGrid', {			//예약참조
		// title: '기본',
		layout : 'fit',
		store: otherOrderStore,
		selModel :   Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }), 
		uniOpt:{
			onLoadSelectFirst : false
		},
		columns:  [  
					 { dataIndex: 'ORDER_NUM'				,  width: 66, hidden: true},
					 { dataIndex: 'ORDER_SEQ'				,  width: 66, hidden: true},
					 { dataIndex: 'ORDER_DATE'				,  width: 90},
					 { dataIndex: 'ORDER_ITEM_CODE'			,  width: 120},
					 { dataIndex: 'ORDER_ITEM_NAME'			,  width: 150},
					 { dataIndex: 'ITEM_CODE'				,  width: 120},
					 { dataIndex: 'ITEM_NAME'				,  width: 150},
					 { dataIndex: 'SPEC'					,  width: 150},
					 { dataIndex: 'ALLOC_Q'					,  width: 96},
					 { dataIndex: 'OUTSTOCK_Q'				,  width: 96},
					 { dataIndex: 'NOT_OUTSTOCK'			,  width: 96},
					 { dataIndex: 'AVERAGE_P'				,  width: 66, hidden: true},
					 { dataIndex: 'STOCK_UNIT'				,  width: 66, hidden: true},
					 { dataIndex: 'WH_CODE'					,  width: 100},
					 { dataIndex: 'STOCK_Q'					,  width: 96},
					 { dataIndex: 'CUSTOM_CODE'				,  width: 66, hidden: true},
					 { dataIndex: 'CUSTOM_NAME'				,  width: 120},
					 { dataIndex: 'MONEY_UNIT'				,  width: 66, hidden: true},
					 { dataIndex: 'COMP_CODE'				,  width: 66, hidden: true},
					 { dataIndex: 'DIV_CODE'				,  width: 66, hidden: true},
					 { dataIndex: 'GRANT_TYPE'				,  width: 66, hidden: true},
					 { dataIndex: 'REMARK'					,  width: 200},
					 { dataIndex: 'PROJECT_NO'				,  width: 120},
					 { dataIndex: 'STOCK_CARE_YN'  			,  width: 66, hidden: true},
					 { dataIndex: 'LOT_YN'				  ,  width: 66, hidden: true}
		  ], 
		listeners: {	
		  	onGridDblClick:function(grid, record, cellIndex, colName) {}
	   	}, 
	   	returnData: function(barcode) {
	   		var records = this.getSelectedRecords();
			if(!Ext.isEmpty(barcode)) {						//발주번호 바코드 입력 시,
				records = barcode;
			}
	   		Ext.each(records, function(record,i){	
				UniAppManager.app.onNewDataButtonDown();
				if(!Ext.isEmpty(barcode)) {					//발주번호 바코드 입력 시,
					masterGrid.setReservationData(record);
					UniAppManager.app.checkStockPrice(record);
					
				} else {
					masterGrid.setReservationData(record.data);
					UniAppManager.app.checkStockPrice(record.data);
				}
			}); 
			this.deleteSelectedRow();
	   	}
	});
	
	//退货可能预定参考
	var otherorderGrid2 = Unilite.createGrid('otr112ukrvotherorderGrid2', {			//반품가능예약참조
		// title: '기본',
		layout : 'fit',
		store: otherOrderStore2,
		selModel :   Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }), 
			uniOpt:{
				onLoadSelectFirst : false
			},
		columns:  [  
					 { dataIndex: 'ORDER_NUM'				,  width: 66, hidden: true},
					 { dataIndex: 'ORDER_SEQ'				,  width: 66, hidden: true},
					 { dataIndex: 'ORDER_DATE'				,  width: 90},
					 { dataIndex: 'ORDER_ITEM_CODE'			,  width: 120},
					 { dataIndex: 'ORDER_ITEM_NAME'			,  width: 150},
					 { dataIndex: 'ITEM_CODE'				,  width: 120},
					 { dataIndex: 'ITEM_NAME'				,  width: 150},
					 { dataIndex: 'SPEC'					,  width: 150},
					 { dataIndex: 'WH_CODE'					,  width: 106},
					 { dataIndex: 'ALLOC_Q'					,  width: 106, hidden: true},
					 { dataIndex: 'NOTOUTSTOCK_Q'			,  width: 96},
					 { dataIndex: 'OUTSTOCK_Q'				,  width: 96},
					 { dataIndex: 'NOT_OUTSTOCK'			,  width: 96},
					 { dataIndex: 'AVERAGE_P'				,  width: 66, hidden: true},
					 { dataIndex: 'STOCK_UNIT'				,  width: 66, hidden: true},
					 { dataIndex: 'STOCK_Q'					,  width: 66, hidden: true},
					 { dataIndex: 'CUSTOM_CODE'				,  width: 66, hidden: true},
					 { dataIndex: 'CUSTOM_NAME'				,  width: 66, hidden: true},
					 { dataIndex: 'MONEY_UNIT'				,  width: 66, hidden: true},
					 { dataIndex: 'COMP_CODE'				,  width: 66, hidden: true},
					 { dataIndex: 'DIV_CODE'				,  width: 66, hidden: true},
					 { dataIndex: 'GRANT_TYPE'				,  width: 66, hidden: true},
					 { dataIndex: 'REMARK'					,  width: 133, hidden: true},
					 { dataIndex: 'PROJECT_NO'				,  width: 133, hidden: true},
					 { dataIndex: 'STOCK_CARE_YN'  			,  width: 66, hidden: true},
					 { dataIndex: 'LOT_YN'				  ,  width: 66, hidden: true}
		  ], 
		listeners: {	
		  	onGridDblClick:function(grid, record, cellIndex, colName) {}
	   	}, 
	   	returnData: function(record) {
	   		var records = this.getSelectedRecords();
	   		Ext.each(records, function(record,i){	
				UniAppManager.app.onNewDataButtonDown();
				masterGrid.setReturnReservationData(record.data);	
				UniAppManager.app.checkStockPrice(record.data);
			}); 
			this.getStore().remove(records);
	   	}
	});
	
	
	
	function openSearchInfoWindow() {			// 검색팝업창
		if(!SearchInfoWindow) {
			SearchInfoWindow = Ext.create('widget.uniDetailWindow', {
				title: '<t:message code="system.label.purchase.issuenosearch" default="출고번호검색"/>',
				width: 1080,
				height: 580,
				layout: {type:'vbox', align:'stretch'},
				items: [orderNoSearch, orderNoMasterGrid], //orderNomasterGrid],
				tbar:  ['->',
					{ itemId : 'saveBtn',
					text: '<t:message code="system.label.purchase.inquiry" default="조회"/>',
					handler: function() {
						if(orderNoSearch.setAllFieldsReadOnly(true)){
							orderNoMasterStore.loadStoreRecords();
						}
					},
					disabled: false
					}, {
						itemId : 'OrderNoCloseBtn',
						text: '<t:message code="system.label.purchase.close" default="닫기"/>',
						handler: function() {
							SearchInfoWindow.hide();
						},
						disabled: false
					}
				],
				listeners : {
					beforehide: function(me, eOpt){
						orderNoSearch.clearForm();
						orderNoMasterGrid.reset();
					},
					beforeclose: function( panel, eOpts )	{
						orderNoSearch.clearForm();
						orderNoMasterGrid.reset();
					},
					show: function( panel, eOpts )	{
						orderNoSearch.setValue('CUSTOM_CODE',panelResult.getValue('CUSTOM_CODE'));
						orderNoSearch.setValue('CUSTOM_NAME',panelResult.getValue('CUSTOM_NAME'));
						orderNoSearch.setValue('INOUT_PRSN',panelResult.getValue('INOUT_PRSN'));
						if(Ext.isDate(panelResult.getValue('INOUT_DATE'))){
							orderNoSearch.setValue('FR_INOUT_DATE',UniDate.get("startOfMonth", panelResult.getValue('INOUT_DATE')));
							orderNoSearch.setValue('TO_INOUT_DATE',panelResult.getValue('INOUT_DATE'));
						}
					}
				}		
			})
		}
		SearchInfoWindow.show();
		SearchInfoWindow.center();
	}
	
	function openReservationWindow() {			//예약참조
  		if(!ReservationWindow) {
			ReservationWindow = Ext.create('widget.uniDetailWindow', {
				title: '<t:message code="system.label.purchase.allocationrefer" default="예약참조"/>',
				width: 1080,								
				height: 580,
				layout:{type:'vbox', align:'stretch'},
				
				items: [otherorderSearch, otherorderGrid],
				tbar:  ['->',
					{	itemId : 'saveBtn',
						text: '<t:message code="system.label.purchase.inquiry" default="조회"/>',
						handler: function() {
							otherOrderStore.loadStoreRecords();
						},
						disabled: false
					},{	itemId : 'confirmBtn',
						text: '<t:message code="system.label.purchase.issueapply" default="출고적용"/>',
						handler: function() {
							otherorderGrid.returnData();
						},
						disabled: false
					},{	itemId : 'confirmCloseBtn',
						text: '<t:message code="system.label.purchase.issueapplyclose" default="출고적용후 닫기"/>',
						handler: function() {
							otherorderGrid.returnData();
							ReservationWindow.hide();
						},
						disabled: false
					},{
						itemId : 'closeBtn',
						text: '<t:message code="system.label.purchase.close" default="닫기"/>',
						handler: function() {
							ReservationWindow.hide();
						},
						disabled: false
					}
				],
				listeners : {
					beforehide: function(me, eOpt)	{
						//otherorderSearch.clearForm();
						//otherorderGrid,reset();
					},
					beforeclose: function( panel, eOpts )	{
						//otherorderSearch.clearForm();
						//otherorderGrid,reset();
					},
					beforeshow: function ( me, eOpts )	{
						otherorderSearch.setValue('CUSTOM_CODE', panelResult.getValue('CUSTOM_CODE'));
						otherorderSearch.setValue('DIV_CODE', panelResult.getValue('DIV_CODE'));
						otherorderSearch.setValue("FR_INOUT_DATE" , UniDate.get('startOfMonth',panelResult.getValue("INOUT_DATE")));
						otherorderSearch.setValue("TO_INOUT_DATE" , panelResult.getValue("INOUT_DATE"));
						otherOrderStore.loadStoreRecords();
					}
				}
			})
		}
		
		ReservationWindow.show();
		ReservationWindow.center();
	}
	
	function openReturnReservationWindow() {	//반품가능예약참조
  		if(!ReturnReservationWindow) {
			ReturnReservationWindow = Ext.create('widget.uniDetailWindow', {
				title: '<t:message code="system.label.purchase.returnavaiableallocationrefer" default="반품가능예약참조"/>',
				width: 1080,								
				height: 580,
				layout:{type:'vbox', align:'stretch'},
				
				items: [otherorderSearch2, otherorderGrid2],
				tbar:  ['->',
					{	itemId : 'saveBtn',
						text: '<t:message code="system.label.purchase.inquiry" default="조회"/>',
						handler: function() {
							otherOrderStore2.loadStoreRecords();
						},
						disabled: false
					},{	itemId : 'confirmBtn',
						text: '<t:message code="system.label.purchase.issueapply" default="출고적용"/>',
						handler: function() {
							otherorderGrid2.returnData();
						},
						disabled: false
					},{	itemId : 'confirmCloseBtn',
						text: '<t:message code="system.label.purchase.issueapplyclose" default="출고적용후 닫기"/>',
						handler: function() {
							otherorderGrid2.returnData();
							ReturnReservationWindow.hide();
						},
						disabled: false
					},{
						itemId : 'closeBtn',
						text: '<t:message code="system.label.purchase.close" default="닫기"/>',
						handler: function() {
							ReturnReservationWindow.hide();
						},
						disabled: false
					}
				],
				listeners : {
					beforehide: function(me, eOpt)	{
						//otherorderSearch.clearForm();
						//otherorderGrid2,reset();
					},
					beforeclose: function( panel, eOpts )	{
						//otherorderSearch.clearForm();
						//otherorderGrid2,reset();
					},
					beforeshow: function ( me, eOpts )	{
						otherorderSearch2.setValue("DIV_CODE"	, panelResult.getValue("DIV_CODE"));
						otherorderSearch2.setValue("CUSTOM_CODE" , panelResult.getValue("CUSTOM_CODE"));
						otherorderSearch2.setValue("FR_ORDER_DATE" , UniDate.get('startOfMonth',panelResult.getValue("INOUT_DATE")));
						otherorderSearch2.setValue("TO_ORDER_DATE" , panelResult.getValue("INOUT_DATE"));
						otherOrderStore2.loadStoreRecords();
					}
				}
			})
		}
		ReturnReservationWindow.show();
		ReturnReservationWindow.center();
	}

	
	


	//경고창
	var alertSearch = Unilite.createSearchForm('alertSearch', {
		layout	: {type : 'uniTable', columns : 1
		, tdAttrs: {width: '100%', align : 'center', style: 'background-color: #dfe8f6;'}		//cfd9e7
		},
		items	:[{
			xtype	: 'component',
			itemId	: 'TEXT_TEST',
			width	: 330,
			height	: 50,
			html	: '',
			style	: {
				marginTop	: '3px !important',
				font		: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
            }
		},{
			xtype	: 'container',
			padding	: '0 0 0 0',
			align	: 'center',
			items	: [{
				xtype	: 'button',
				text	: '<t:message code="system.label.purchase.confirm" default="확인"/>',
				width	: 80,
				handler	: function() {
					alertWindow.hide();
				},
				disabled: false
			}]
		}]
	}); 
	function openAlertWindow() {
		if(!alertWindow) {
			alertWindow = Ext.create('widget.uniDetailWindow', {
				title	: '<t:message code="system.label.purchase.warntitle" default="경고"/>',
				width	: 350,
				height	: 120,
				layout	: {type:'vbox', align:'stretch'},
				items	: [alertSearch],
				listeners : {
					beforehide: function(me, eOpt) {
						alertSearch.clearForm();
					},
					beforeclose: function( panel, eOpts ) {
						alertSearch.clearForm();
					},
					beforeshow: function( panel, eOpts ) {
						alertSearch.down('#TEXT_TEST').setHtml(gsText);
					}/*,
					specialkey:function(field, event)	{
						if(event.getKey() == event.ENTER) {
							beep();
						}
					}*/
				}		
			})
		}
		alertWindow.center();
		alertWindow.show();
	}

	
	
	Unilite.Main({
		id			: 'otr112ukrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				masterGrid, panelResult, barcodeGrid
			]
		}],
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons(['reset', 'newData', 'prev', 'next'], true);
			UniAppManager.setToolbarButtons('save', false);

//			cbStore.loadStoreRecords();
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('INOUT_DATE',new Date());
			panelResult.getForm().wasDirty = false;
		 	panelResult.resetDirtyStatus();
//			cbStore.loadStoreRecords();
		},
		onQueryButtonDown: function()	{		// 조회버튼 눌렀을때
			panelResult.setAllFieldsReadOnly(false);
			var inoutNo = panelResult.getValue('INOUT_NUM');
			if(Ext.isEmpty(inoutNo)) {
				openSearchInfoWindow() 
			} else {
		//		var param= panelResult.getValues();
				directMasterStore1.loadStoreRecords();	
				barcodeStore.clearFilter();
				barcodeStore.loadStoreRecords();
			};
			gsMaxInoutSeq = 0;
		},
		onResetButtonDown: function() {		// 초기화
			gsMaxInoutSeq = 0;
			this.suspendEvents();
			
			panelResult.clearForm();
			panelResult.setAllFieldsReadOnly(false);
			
			masterGrid.reset();
			masterGrid.getStore().clearData();
			barcodeStore.loadData({});
			this.fnInitBinding();
			
			panelResult.getField('CUSTOM_CODE').setReadOnly(false);
			panelResult.getField('CUSTOM_NAME').setReadOnly(false);
			panelResult.getField('DIV_CODE').setReadOnly(false);
			panelResult.getField('INOUT_DATE').setReadOnly(false);
			panelResult.getField('INOUT_PRSN').setReadOnly(false);
			panelResult.getField('WH_CODE').setReadOnly(false);
			panelResult.getField('WH_CELL_CODE').setReadOnly(false);
			
			panelResult.getField('CUSTOM_CODE').focus();
			
		},
		onSaveDataButtonDown: function(config) {
			barcodeStore.clearFilter();
			if(barcodeStore.isDirty()) {
				barcodeStore.saveStore();
			}
		},
		onDeleteDataButtonDown: function() {
			var selRow			= masterGrid.getSelectedRecord();
			var selRow2			= barcodeGrid.getSelectedRecord();
			
			if(Ext.isEmpty(selRow) && Ext.isEmpty(selRow2)) {
				alert('<t:message code="system.message.purchase.message017" default="선택된 자료가 없습니다."/>');					//선택된 자료가 없습니다.
				return false;
			}
			if(activeGridId == 'otr112ukrvGrid' && !Ext.isEmpty(selRow) && selRow.phantom === true)	{			//masterGrid 삭제 함수 호출
				fnDeleteDetail(selRow);
				
			} else if(activeGridId != 'otr112ukrvGrid' && !Ext.isEmpty(selRow2) && selRow2.phantom === true) {	//barcodeGrid 삭제 함수 호출
				fnBarcodeGrid(selRow, selRow2)
					
			} else if (confirm('<t:message code="system.message.sales.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
				if( activeGridId == 'mtr202ukrvGrid1' && !Ext.isEmpty(selRow)) {			//masterGrid 삭제 함수 호출
					if(BsaCodeInfo.gsInoutAutoYN == "N" && selRow.get('ACCOUNT_Q') > 0) {	//동시매출발생이 아닌 경우,매출존재체크 제외
						alert('<t:message code="system.message.purchase.message044" default="매출이 진행된 건은 수정/삭제할 수 없습니다."/>');													//매출이 진행된 건은 수정/삭제할 수 없습니다.
						return false;
					}
					if(selRow.get('SALE_C_YN') == "Y"){
						alert('<t:message code="system.message.purchase.message045" default="계산서가 마감된 건은 수정/삭제가 불가능합니다."/>');													//계산서가 마감된 건은 수정/삭제가 불가능합니다.
						return false;
					}
					fnDeleteDetail(selRow);
					
				} else if(activeGridId != 'mtr202ukrvGrid1' && !Ext.isEmpty(selRow2)) {		//barcodeGrid 삭제 함수 호출
					if(BsaCodeInfo.gsInoutAutoYN == "N" && selRow2.get('ACCOUNT_Q') > 0) {	//동시매출발생이 아닌 경우,매출존재체크 제외
						alert('<t:message code="system.message.purchase.message044" default="매출이 진행된 건은 수정/삭제할 수 없습니다."/>');													//매출이 진행된 건은 수정/삭제할 수 없습니다.
						return false;
					}
					if(selRow2.get('SALE_C_YN') == "Y"){
						alert('<t:message code="system.message.purchase.message045" default="계산서가 마감된 건은 수정/삭제가 불가능합니다."/>');													//계산서가 마감된 건은 수정/삭제가 불가능합니다.
						return false;
					}
					fnBarcodeGrid(selRow, selRow2)
				}
			}
		},
		onDeleteAllButtonDown: function() {
			var records1	= directMasterStore1.data.items;
			var records2	= barcodeStore.data.items;
			var records		= [].concat(records1, records2);
			var isNewData	= false;
			Ext.each(records, function(record,i) {
				if(record.phantom){						//신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				}else{									//신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					isNewData = false;
					if(confirm('<t:message code="system.message.purchase.message008" default="전체삭제 하시겠습니까?"/>')) {
						var deletable = true;
						/*---------삭제전 로직 구현 시작----------*/
//						if(gsMonClosing == "Y" || gsDayClosing == "Y"){	//마감여부 check
//							alert(Msg.sMS042);			//마감된 월(일)에 대해서는 자료의 수정/추가/삭제가 불가능합니다.
//							return false;
//						}
						Ext.each(records, function(record,i) {
							if(BsaCodeInfo.gsInoutAutoYN == "N" && record.get('ACCOUNT_Q') > 0) {//동시매출발생이 아닌 경우,매출존재체크 제외
								alert('<t:message code="system.message.purchase.message044" default="매출이 진행된 건은 수정/삭제할 수 없습니다."/>');		//매출이 진행된 건은 수정/삭제할 수 없습니다.
								deletable = false;
								return false;
							}
							if(record.get('SALE_C_YN') == "Y"){
								alert('<t:message code="system.message.purchase.message045" default="계산서가 마감된 건은 수정/삭제가 불가능합니다."/>');		//계산서가 마감된 건은 수정/삭제가 불가능합니다.
								deletable = false;
								return false;
							}
						});
						/*---------삭제전 로직 구현 끝-----------*/
						
						if(deletable){
							masterGrid.reset();
							barcodeGrid.reset();
							UniAppManager.app.onSaveDataButtonDown();
						}
					}
					return false;
				}
			});
			if(isNewData){								//신규 레코드들만 있을시 그리드 리셋
				masterGrid.reset();
				barcodeGrid.reset();
				UniAppManager.app.onResetButtonDown();	//삭제후 RESET..
			}
		},
		rejectSave: function() {	// 저장
			var rowIndex = masterGrid.getSelectedRowIndex();
			masterGrid.select(rowIndex);
			directMasterStore1.rejectChanges();
			
			if(rowIndex >= 0){
				masterGrid.getSelectionModel().select(rowIndex);
				var selected = masterGrid.getSelectedRecord();
				
				var selected_doc_no = selected.data['DOC_NO'];
  				bdc100ukrvService.getFileList(
					{DOC_NO : selected_doc_no},
					function(provider, response) {
					}
				);
			}
			directMasterStore1.onStoreActionEnable();
		},
		confirmSaveData: function(config)	{	// 저장하기전 원복 시키는 작업
			var fp = Ext.getCmp('otr112ukrvFileUploadPanel');
			if(masterStore.isDirty() || fp.isDirty()) {
				if(confirm('<t:message code="system.message.purchase.message025" default="변경된 내용을 저장하시겠습니까?"/>'))	{
					this.onSaveDataButtonDown(config);
				} else {
					this.rejectSave();
				}
			}
		},
		cbStockQ: function(provider, params) {
			var rtnRecord	= params.rtnRecord;
			var goodStockQ	= Unilite.nvl(provider['GOOD_STOCK_Q'], 0);
			var badtockQ	= Unilite.nvl(provider['BAD_STOCK_Q'], 0);
			var inoutP		= Unilite.nvl(provider['AVERAGE_P'], 0);
			var inoutI		= Unilite.nvl(provider['AVERAGE_P'], 0) * rtnRecord.get('INOUT_Q');
			
			rtnRecord.set('GOOD_STOCK_Q'	, goodStockQ);
			rtnRecord.set('BAD_STOCK_Q'		, badtockQ);
			rtnRecord.set('INOUT_P'			, inoutP);
			rtnRecord.set('INOUT_I'			, inoutI);
		},
		cbStockQ_kd: function(provider, params)	{  
			var rtnRecord = params.rtnRecord;
			var pabStockQ = Unilite.nvl(provider['PAB_STOCK_Q'], 0);//가용재고량			
			rtnRecord.set('PAB_STOCK_Q', pabStockQ);
		},
		onNewDataButtonDown: function()	{		// 행추가
			if(!this.checkForNewDetail()) return false;
			//Detail Grid Default 값 설정
			var inoutNum		= panelResult.getValue('INOUT_NUM');
			var seq				= !directMasterStore1.max('INOUT_SEQ')?1: directMasterStore1.max('INOUT_SEQ') + 1;
			//var inoutType	= '2';
			var inoutMeth		= '2';
			var inoutTypeDetail	= Ext.data.StoreManager.lookup('CBS_AU_M104').getAt(0).get('value'); //출고유형콤보value중 첫번째 value
			var inoutCodeType	= '5';
			var inoutCode		= panelResult.getValue('CUSTOM_CODE');
			var whCode			= panelResult.getValue('WH_CODE');
			var whCellCode		= panelResult.getValue('WH_CELL_CODE');
			var divCode			= panelResult.getValue('DIV_CODE');
			var inoutDate		= UniDate.getDbDateStr(panelResult.getValue('INOUT_DATE'));
			var itemCode		= '';
			var itemName		= '';
			var itemStatus		= '1';
			var Spec			= '';
			var stockUnit		= '';
			var notOutstockQ	= '0';
			var originalQ		= '0';
			var allocQ			= '0';
			var inoutQ			= '0';
			var expenseI		= '0';
			var moneyUnit		= BsaCodeInfo.gsDefaultMoney;
			var inoutForP		= '';
			var inoutForO		= '';
			var exchgRateO		= '4';
			var orderType		= '';
			var orderNum		= '';
			var orderSeq		= '';
			var lcNum			= '';
			var blNum			= '';
			var inoutPrsn		= panelResult.getValue('INOUT_PRSN');
			var basisNum		= '';
			var basisSeq		= '';
			var accountYnc		= '';
			var accountQ		= '0';
			var createLoc		= '2';
			var saleCYn			= 'N';
			var saleCDate		= '';
			var saleCRemark		= '';
			var grantTytpe		= '2';
			var Remark			= '';
			var whCellName		= '';
			var saleDivCode		= '*';
			var saleCustomCode	= '*';
			var saleType		= '*';
			var billType		= '*';
				
			var r = {
				//COMP_CODE: compCode,
				INOUT_NUM			: inoutNum,
				INOUT_SEQ			: seq,
				//INOUT_TYPE		: inoutType,
				INOUT_METH			: inoutMeth,
				INOUT_TYPE_DETAIL	: inoutTypeDetail,
				INOUT_CODE_TYPE		: inoutCodeType,
				INOUT_CODE			: inoutCode,
				WH_CODE				: whCode,
				DIV_CODE			: divCode,
				INOUT_DATE			: inoutDate,
				ITEM_CODE			: itemCode,
				ITEM_NAME			: itemName,
				ITEM_STATUS			: itemStatus,
				SPEC				: Spec,
				STOCK_UNIT			: stockUnit,
				NOT_OUTSTOCK_Q		: notOutstockQ,
				ORIGINAL_Q			: originalQ,
				ALLOC_Q				: allocQ,
				INOUT_Q				: inoutQ,
				EXPENSE_I			: expenseI,
				MONEY_UNIT			: moneyUnit,
				INOUT_FOR_P			: inoutForP,
				INOUT_FOR_O			: inoutForO,
				EXCHG_RATE_O		: exchgRateO,
				ORDER_TYPE			: orderType,
				ORDER_NUM			: orderNum,
				ORDER_SEQ			: orderSeq,
				LC_NUM				: lcNum,
				BL_NUM				: blNum,
				INOUT_PRSN			: inoutPrsn,
				BASIS_NUM			: basisNum,
				BASIS_SEQ			: basisSeq,
				ACCOUNT_YNC			: accountYnc,
				ACCOUNT_Q			: accountQ,
				CREATE_LOC			: createLoc,
				SALE_C_YN			: saleCYn,
				SALE_C_DATE			: saleCDate,
				SALE_C_REMARK		: saleCRemark,
				GRANT_TYPE			: grantTytpe,
				REMARK				: Remark,
				WH_CELL_CODE		: whCellCode,
				WH_CELL_NAME		: whCellName,
				SALE_DIV_CODE		: saleDivCode,
				SALE_CUSTOM_CODE	: saleCustomCode,
				SALE_TYPE			: saleType,
				BILL_TYPE			: billType	
			};
			
//			cbStore.loadStoreRecords(whCode);
			masterGrid.createRow(r, 'ITEM_CODE', seq-2);
			panelResult.setAllFieldsReadOnly(false);
		},
		checkForNewDetail:function() { 
			if(BsaCodeInfo.gsAutoType=='N' && Ext.isEmpty(panelResult.getValue('INOUT_NUM')))	{
				alert('<t:message code="system.label.purchase.sono" default="수주번호"/>:<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>');
				return false;
			}
			return panelResult.setAllFieldsReadOnly(true);
		},
		onDetailButtonDown: function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		},
		checkStockPrice:function(record){
			if(record){
				var param = {
					"ITEM_CODE":record["ITEM_CODE"],
					"WH_CODE"  :record["WH_CODE"]
				}
				Ext.Ajax.request({
					url	 : CPATH+'/otr/otr110SelectProductNumInWh.do',
					params  : param,
					async   : false,
					success : function(response){
						if(response.status == "200"){
							var provider = JSON.parse(response.responseText);
							var selectRecord = Ext.getCmp("otr112ukrvGrid").getSelectedRecord();
							if(selectRecord){
								selectRecord.set("AVERAGE_P", provider["AVERAGE_P"]);
								selectRecord.set("BAD_STOCK_Q", provider["BAD_STOCK_Q"]);
								selectRecord.set("GOOD_STOCK_Q", provider["GOOD_STOCK_Q"]);
								selectRecord.set("STOCK_Q", provider["STOCK_Q"]);
							}
						}
					},
					callback: function()	{
						Ext.getBody().unmask();
					}
				});
			}
		}
	});
	
	
	
	
	
	Unilite.createValidator('validator01', {
		store	: barcodeStore,
		grid	: barcodeGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "INOUT_SEQ" :	// 순번
					if(newValue <= '0') {
						rv= '<t:message code="system.message.purchase.message024" default="양수만 입력 가능합니다."/>';	
						break;
					}
					break;
					
				case "INOUT_Q" :	// 출고량
					if(newValue < 0 && !Ext.isEmpty(newValue))  {
						rv='<t:message code="system.message.purchase.message024" default="양수만 입력 가능합니다."/>';
						break;
					}
					if(record.get('INOUT_METH') == "2" && BsaCodeInfo.gsUsePabStockYn == "Y"){   //예외 출고 및 가용재고체크 사용할시
						var sInout_q = newValue;	//출고량
						var sInv_q = record.get('PAB_STOCK_Q'); //가용재고량
						var sOriginQ = record.get('ORIGINAL_Q'); //출고량(원)					
						if(sInout_q > (sInv_q + sOriginQ)){
							rv='<t:message code="system.message.purchase.message014" default="출고량은 가용재고량을 초과할 수 없습니다."/>';  //출고량은 재고량을 초과할 수 없습니다.
							break;
						}
					}				
					var sInout_q = newValue;	//출고량
					var sInv_q = record.get('ITEM_STATUS') == "1"? record.get('GOOD_STOCK_Q') : record.get('BAD_STOCK_Q');  //재고량
					var sOriginQ = record.get('ORIGINAL_Q'); //출고량(원)
					
					if(sInout_q > (sInv_q + sOriginQ)){
						rv='<t:message code="system.message.purchase.message036" default="출고량은 재고량을 초과할 수 없습니다."/>';  //출고량은 재고량을 초과할 수 없습니다.
						break;
					}
					break;
				case "WH_CODE":
					var data ={
						"ITEM_CODE": record.get("ITEM_CODE"),
						"WH_CODE"  : newValue
					}
					//그리드 창고cell콤보 reLoad.. 
//					cbStore.loadStoreRecords(newValue);
					UniAppManager.app.checkStockPrice(data);
					
					if(!Ext.isEmpty(record.get('ITEM_CODE'))){
						if(record.get('INOUT_METH') == "2" && BsaCodeInfo.gsUsePabStockYn == "Y"){   //예외 출고 및 가용재고체크 사용할시
							UniMatrl.fnStockQ_kd(record, UniAppManager.app.cbStockQ_kd, UserInfo.compCode, record.get('DIV_CODE'), UniDate.getDbDateStr(record.get('INOUT_DATE')), record.get('ITEM_CODE'));
						}
//						UniMatrl.fnStockQ(record, UniAppManager.app.cbStockQ, UserInfo.compCode, record.get('DIV_CODE'), null, record.get('ITEM_CODE'), newValue );
					}
					break;
			}
			return rv;
		}
	});
	
	
	
	function setAllFieldsReadOnly(b){
		var r= true
		if(b) {
			var invalid = this.getForm().getFields().filterBy(function(field) {
				return !field.validate();
			});
			if(invalid.length > 0) {
				r=false;
				var labelText = ''
	
				if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
					var labelText = invalid.items[0]['fieldLabel']+':';
				} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
					var labelText = invalid.items[0].ownerCt['fieldLabel']+':';
				}
				alert(labelText+'<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>');
				invalid.items[0].focus();
			}else{
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) )	{
						if (item.holdable == 'hold') {
							item.setReadOnly(true); 
						}
					} 
					if(item.isPopupField)	{
						var popupFC = item.up('uniPopupField');
						if(popupFC.holdable == 'hold') {
							popupFC.setReadOnly(true);
						}
					}
				});
			}
		} else {
			this.unmask();
		}
		return r;
	}
	
	
	
	//바코드 입력 로직 (출하지시번호)
	function fnEnterOrderNumBarcode(newValue) {
		var masterRecords		= directMasterStore1.data.items;
		var OutStockReqBarcode	= newValue
		var flag = true;
		
		//동일한 발주번호 입력되었을 경우 처리
		Ext.each(masterRecords, function(masterRecord,i) {
			if(masterRecord.get('ORDER_NUM').toUpperCase() == OutStockReqBarcode.toUpperCase()) {
				beep();
				gsText = '<t:message code="system.message.purchase.message007" default="동일한  발주번호가 이미 등록 되었습니다."/>';
				openAlertWindow(gsText);
				flag = false;
				Ext.getBody().unmask();
				panelResult.getField('ORDER_NUM_BARCODE').focus();
				return false;
			}
		});
		
		if(flag) {
			var param = {
				DIV_CODE	: panelResult.getValue('DIV_CODE'),
				ORDER_NUM	: OutStockReqBarcode
			}
			//출하지시참조 조회쿼리 호출
			otr112ukrvService.selectDetail2(param, function(provider, response){
				if(!Ext.isEmpty(provider)){
//					panelResult.setValue('INOUT_CODE_TYPE'	, provider[0].WH_CODE);
//					panelResult.setValue('WH_CODE'			, provider[0].WH_CODE);
					otherorderGrid.returnData(provider);
					Ext.getBody().unmask();
					panelResult.getField('BARCODE').focus();
					
				} else {
					beep();
					gsText = '<t:message code="system.message.purchase.message006" default="입력하신 발주번호의 데이터가 존재하지 않습니다."/>';
					openAlertWindow(gsText);
					Ext.getBody().unmask();
					panelResult.getField('ORDER_NUM_BARCODE').focus();
					return false;
				}
			});
		}
	}
	
	
	//바코드 입력 로직 (lot_no)
	function fnEnterBarcode(newValue) {
		var selectedRecord	= masterGrid.getSelectedRecord();
		var masterRecords	= masterGrid.getStore().data.items;
		var barcodeItemCode	= newValue.split('|')[0].toUpperCase();
		var barcodeLotNo	= newValue.split('|')[1];
		var barcodeInoutQ	= newValue.split('|')[2];
		var param3			= {};
		var flag = true;
		
		if(!Ext.isEmpty(barcodeLotNo)) {
			barcodeLotNo = barcodeLotNo.toUpperCase();
		}
		
		//동일한 LOT_NO 입력되었을 경우 처리
		barcodeStore.clearFilter();						//filter clear 후
		var records		= barcodeStore.data.items;		//비교할 records 구성
/*		if(!Ext.isEmpty(selectedRecord)) {
			barcodeStore.filterBy(function(record){			//다시 필터 set
				return record.get('ORDER_NUM') == selectedRecord.get('ORDER_NUM')
					&& record.get('ITEM_CODE') == selectedRecord.get('ITEM_CODE');
			})
		}*/
		Ext.each(records, function(record, i) {
			if(record.get('LOT_NO').toUpperCase() == barcodeLotNo) {
				beep();
				gsText = '<t:message code="system.message.purchase.message003" default="동일한  Lot No.(이)가 이미 등록되었습니다."/>'
				openAlertWindow(gsText);
				panelResult.getField('BARCODE').focus();
				flag = false;
				return false;
			}
		});
		
		//masterGrid에서 필요한 데이터 가져옴
		Ext.each(masterRecords, function(masterRecord, i) {
			if(masterRecord.get('ITEM_CODE').toUpperCase() == barcodeItemCode) {
				param3 = {
					COMP_CODE			: UserInfo.compCode,
					DIV_CODE			: panelResult.getValue('DIV_CODE'),
					INOUT_DATE			: masterRecord.data['ORDER_DATE'],
					INOUT_TYPE_DETAIL	: masterRecord.data['INOUT_TYPE_DETAIL'],
					INOUT_METH			: masterRecord.data['INOUT_METH'],
					ITEM_CODE			: masterRecord.data['ITEM_CODE'],
					ITEM_NAME			: masterRecord.data['ITEM_NAME'],
					ITEM_STATUS			: '1',
					WH_CODE				: masterRecord.data['WH_CODE'],
					CREATE_LOC			: masterRecord.data['CREATE_LOC'],
					INOUT_CODE_TYPE		: masterRecord.data['INOUT_CODE_TYPE'],
					INOUT_CODE			: masterRecord.data['INOUT_CODE'],			//CUSTOM_CODE
					INOUT_NAME			: masterRecord.data['INOUT_NAME'],			//CUSTOM_NAME
					SPEC				: masterRecord.data['SPEC'],
					STOCK_UNIT			: masterRecord.data['STOCK_UNIT'],
					NOT_OUTSTOCK_Q		: masterRecord.data['NOT_OUTSTOCK'],
					ORIGINAL_Q			: 0,
					ALLOC_Q				: masterRecord.data['ALLOC_Q'],
					INOUT_Q				: masterRecord.data['NOT_OUTSTOCK'],
					EXPENSE_I			: '',
					MONEY_UNIT			: masterRecord.data['MONEY_UNIT'],
					INOUT_FOR_P			: '',
					INOUT_FOR_O			: '',
					EXCHG_RATE_O		: '',
					ORDER_TYPE			: '4',	
					ORDER_NUM			: masterRecord.data['ORDER_NUM'],
					ORDER_SEQ			: masterRecord.data['ORDER_SEQ'],
					LC_NUM				: '',
					BL_NUM				: '',
					INOUT_PRSN			: panelResult.getValue('INOUT_PRSN'),
					BASIS_NUM			: '',
					BASIS_SEQ			: '',
					ACCOUNT_YNC			: '',
					ACCOUNT_Q			: 0,
					CREATE_LOC			: '2',
					SALE_C_YN			: 'N',
					SALE_C_DATE			: '',
					SALE_C_REMARK		: '',
					WH_NAME				: masterRecord.data['WH_CODE'],
					REMARK				: masterRecord.data['REMARK'],
					PROJECT_NO			: masterRecord.data['PROJECT_NO'],
					GRANT_TYPE			: masterRecord.data['GRANT_TYPE'],
					STOCK_CARE_YN		: masterRecord.data['STOCK_CARE_YN'],
					LOT_YN				: masterRecord.data['LOT_YN'],
					SALE_DIV_CODE		: '*',
					SALE_CUSTOM_CODE	: '*',
					SALE_TYPE			: '*',
					BILL_TYPE			: '*',
					INOUT_P				: masterRecord.data['INOUT_P'],
					INOUT_I				: masterRecord.data['INOUT_I'],
					EXPENSE_I			: masterRecord.data['EXPENSE_I'],
					INOUT_FOR_P			: masterRecord.data['INOUT_FOR_P'],
					INOUT_FOR_O			: masterRecord.data['INOUT_FOR_O'],
					EXCHG_RATE_O		: masterRecord.data['EXCHG_RATE_O'],
					REF_GUBUN			: masterRecord.data['REF_GUBUN']				//반품가능예약참조 - "R"
/*					DIV_CODE			: masterRecord.data.DIV_CODE,
					ORDER_NUM			: masterRecord.data.ORDER_NUM,
					ORDER_SEQ			: masterRecord.data.ORDER_SEQ,
					ORDER_DATE			: masterRecord.data.ORDER_DATE,
					ORDER_ITEM_CODE		: masterRecord.data.ORDER_ITEM_CODE,
					ORDER_ITEM_NAME		: masterRecord.data.ORDER_ITEM_NAME,
					ITEM_CODE			: masterRecord.data.ITEM_CODE,
					ITEM_NAME			: masterRecord.data.ITEM_NAME,
					SPEC				: masterRecord.data.SPEC,
					ALLOC_Q				: masterRecord.data.ALLOC_Q,
					OUTSTOCK_Q			: masterRecord.data.OUTSTOCK_Q,
					NOT_OUTSTOCK		: masterRecord.data.ALLOC_Q - masterRecord.data.OUTSTOCK_Q,
					AVERAGE_P			: masterRecord.data.AVERAGE_P,
					STOCK_UNIT			: masterRecord.data.STOCK_UNIT,
					WH_CODE				: masterRecord.data.WH_CODE,
					STOCK_Q				: masterRecord.data.STOCK_Q,
					CUSTOM_CODE			: masterRecord.data.CUSTOM_CODE,
					CUSTOM_NAME			: masterRecord.data.CUSTOM_NAME,
					MONEY_UNIT			: masterRecord.data.MONEY_UNIT,
					GRANT_TYPE			: masterRecord.data.GRANT_TYPE,
					REMARK				: masterRecord.data.REMARK,
					PROJECT_NO			: masterRecord.data.PROJECT_NO,
					STOCK_CARE_YN		: masterRecord.data.STOCK_CARE_YN,
					LOT_YN				: masterRecord.data.LOT_YN*/
				};
			}
		});
		
		if(Ext.isEmpty(param3.DIV_CODE)) {
			beep();
			gsText = '<t:message code="system.message.purchase.message005" default="입력하신 바코드의 품목이 기조회된 데이터에 존재하지 않습니다."/>'
			openAlertWindow(gsText);
			panelResult.getField('BARCODE').focus();
			flag = false;
			return false;
		}
		
		gsMaxInoutSeq = gsMaxInoutSeq + 1;
		
		//바코드 정보 UPDATE
		param3.ITEM_CODE	= barcodeItemCode;
		param3.LOT_NO		= barcodeLotNo;
		param3.INOUT_Q		= barcodeInoutQ;
		param3.INOUT_SEQ	= gsMaxInoutSeq;
		param3.INOUT_DATE	= UniDate.getDbDateStr(panelResult.getValue('INOUT_DATE'));
					
		//반품가능요청 참조일 경우, lot 정보 체크 하지 않음
		if(flag && param3.REF_GUBUN == 'R') {
			fnBarcodeInfo(masterRecords, param3);
		}
		if(flag && param3.REF_GUBUN != 'R') {
			var param = {
				ITEM_CODE		: barcodeItemCode,
				LOT_NO			: barcodeLotNo,
				ORDER_UNIT_Q	: barcodeInoutQ,
				WH_CODE			: param3.WH_CODE,
				DIV_CODE		: panelResult.getValue('DIV_CODE'),
				LOT_NO_S		: panelResult.getValue('LOT_NO_S'),
				GSFIFO			: BsaCodeInfo.gsFifo
			}
			str105ukrvService.getFifo(param, function(provider, response){
				if(!Ext.isEmpty(provider)){
					if(!Ext.isEmpty(provider[0].ERR_MSG)) {
						beep();
						gsText = provider[0].ERR_MSG;
						openAlertWindow(gsText);
						panelResult.getField('BARCODE').focus();
						return false;
					};
					fnBarcodeInfo(masterRecords, param3);
				}
			});
		}
	}
	
	
	
	//masterGrid 삭제
	function fnDeleteDetail(selRow) {
		var deleteRecords	= new Array();
		
		masterGrid.deleteSelectedRow();
		//barcode그리드의 관련 내용 삭제
		barcodeStore.clearFilter();
		var barcodeRecords = barcodeStore.data.items;
		Ext.each(barcodeRecords, function(barcodeRecord,i) {
			if(barcodeRecord.get('ITEM_CODE') == selRow.get('ITEM_CODE')) {
				deleteRecords.push(barcodeRecord);
			}
		});
		barcodeStore.remove(deleteRecords);
		gsMaxInoutSeq = Unilite.nvl(barcodeStore.max('INOUT_SEQ'), 0);
	}

	//barcodeGrid 삭제
	function fnBarcodeGrid(selRow, selRow2) {
		var deleteRecords	= new Array();
		var selRows = directMasterStore1.data.items;
		Ext.each(selRows, function(selRow,i) {
			if(selRow2.get('ITEM_CODE') == selRow.get('ITEM_CODE')) {
				selRow.set('INOUT_Q', selRow.get('INOUT_Q') - selRow2.get('INOUT_Q'));
				if(selRow.get('INOUT_Q') == 0) {
					deleteRecords.push(selRow);
				}
			}
		});
		directMasterStore1.remove(deleteRecords);
		barcodeGrid.deleteSelectedRow();
		gsMaxInoutSeq = Unilite.nvl(barcodeStore.max('INOUT_SEQ'), 0);
	}
	
	//bacode 정보  get / set
	function fnBarcodeInfo(masterRecords, param3) {
		otr112ukrvService.getBarcodeInfo(param3, function(provider2, response){
			if(!Ext.isEmpty(provider2)){
				Ext.each(provider2, function(barcodeInfo, i) {
					barcodeInfo.phantom = true;
					barcodeStore.insert(i, barcodeInfo);
					//masterGird inout_q update
					Ext.each(masterRecords, function(masterRecord, i) {
						if(masterRecord.get('ITEM_CODE') == param3.ITEM_CODE) {
							var newInoutQ		= parseInt(masterRecord.get('INOUT_Q')) + parseInt(barcodeInfo.INOUT_Q);
							var newNotInoutQ	= parseInt(masterRecord.get('NOT_OUTSTOCK_Q')) - parseInt(barcodeInfo.INOUT_Q);
							if (newNotInoutQ < 0) {
								newNotInoutQ = 0;
							}
							masterRecord.set('INOUT_Q'			, newInoutQ);
							masterRecord.set('NOT_OUTSTOCK_Q'	, newNotInoutQ);
							UniMatrl.fnStockQ(masterRecord, UniAppManager.app.cbStockQ, UserInfo.compCode
											, masterRecord.get('DIV_CODE'), null, masterRecord.get('ITEM_CODE')
											, masterRecord.get('WH_CODE') );
						}
					});
					panelResult.getField('BARCODE').focus();
//					=================================================
//							UniMatrl.fnStockQ(masterRecord, UniAppManager.app.cbStockQ, UserInfo.compCode
//											, masterRecord.get('DIV_CODE'), null, masterRecord.get('ITEM_CODE')
//											, masterRecord.get('WH_CODE') );
				});
			} else {
				beep();
				gsText = '<t:message code="system.message.purchase.message004" default="입력하신 품목의 데이터가 존재하지 않습니다."/>'
				openAlertWindow(gsText);
				Ext.getBody().unmask();
				panelResult.getField('BARCODE').focus();
				return false;
			}
		});
	}
	
	

	
	
	function beep() {
		audioCtx = new(window.AudioContext || window.webkitAudioContext)();
	
		var oscillator = audioCtx.createOscillator();
		var gainNode = audioCtx.createGain();
	
		oscillator.connect(gainNode);
		gainNode.connect(audioCtx.destination);
	
		gainNode.gain.value = 0.1;				//VOLUME 크기
		oscillator.frequency.value = 4100;
		oscillator.type = 'sine';				//sine, square, sawtooth, triangle
	
		oscillator.start();
	
		setTimeout(
			function() {
			  oscillator.stop();
			},
			1000									//길이
		);
	};
	
	
	
	
	function getLotPopupEditor(gsLotNoInputMethod){
		var editField;
		if(gsLotNoInputMethod == "E" || gsLotNoInputMethod == "Y"){
					 editField = Unilite.popup('LOTNO_G',{ 
									 textFieldName: 'LOTNO_CODE',
		 							 DBtextFieldName: 'LOTNO_CODE',
		 							 width:1000,
		   							 autoPopup: true,
									 listeners: {
									 	'onSelected': {
									 		fn: function(record, type) {
									 			var selectRec = masterGrid.getSelectedRecord()
									 			if(selectRec){
									 				selectRec.set('LOT_NO', record[0]["LOT_NO"]);
									 				selectRec.set('WH_CODE', record[0]["WH_CODE"]);
									 				selectRec.set('WH_NAME', record[0]["WH_NAME"]);
									 				selectRec.set('WH_CELL_CODE', record[0]["WH_CELL_CODE"]);
									 				selectRec.set('WH_CELL_NAME', record[0]["WH_CELL_NAME"]);
									 				selectRec.set('GOOD_STOCK_Q', record[0]["GOOD_STOCK_Q"]);
									 				selectRec.set('BAD_STOCK_Q', record[0]["BAD_STOCK_Q"]);
									 			}
										 	},
									 		scope: this
									 	},
									 	'onClear': {
									 		fn: function(record, type) {
									 			var selectRec = masterGrid.getSelectedRecord()
									 			if(selectRec){
									 				selectRec.set('LOT_NO', '');
									 				selectRec.set('WH_CELL_CODE', '');
									 				selectRec.set('WH_CELL_NAME', '');
									 				selectRec.set('GOOD_STOCK_Q', 0);
									 				selectRec.set('BAD_STOCK_Q', 0);
									 				UniAppManager.app.checkStockPrice(selectRec.data);
									 			}
										 	},
									 		scope: this
									 	},
									 	applyextparam: function(popup){	
									 		var selectRec = masterGrid.getSelectedRecord();
									 		if(selectRec){
									 			popup.setExtParam({'DIV_CODE':  selectRec.get('DIV_CODE')});
									 			popup.setExtParam({'ITEM_CODE': selectRec.get('ITEM_CODE')});
									 			popup.setExtParam({'ITEM_NAME': selectRec.get('ITEM_NAME')});
									 			popup.setExtParam({'CUSTOM_CODE': panelResult.getValue('CUSTOM_CODE')});
									 			popup.setExtParam({'CUSTOM_NAME': panelResult.getValue('CUSTOM_NAME')});
									 			popup.setExtParam({'WH_CODE': selectRec.get('WH_CODE')});
									 			popup.setExtParam({'WH_CELL_CODE': selectRec.get('WH_CELL_CODE')});
									 			popup.setExtParam({'stockYN': 'Y'});
									 		}
									 	}
									 }
								});
		}else if(gsLotNoInputMethod == "N"){
			editField = {xtype : 'textfield', maxLength:20}
		}
		
		var editor = Ext.create('Ext.grid.CellEditor', {
			ptype: 'cellediting',
			clicksToEdit: 1, // 1 or 2 , 수정 모드로 들어가기 위한 Click 횟수 
			autoCancel : false,
			selectOnFocus:true,
			field: editField
		});
		
		return editor;
	}
	
	var activeGridId = 'otr112ukrvGrid';
};
</script>