<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="mms120skrv">
	<t:ExtComboStore comboType="BOR120" pgmId="mms120skrv" /> 		<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B020" />				<!-- 품목계정 -->
	<t:ExtComboStore comboType="AU" comboCode="M001" />				<!-- 발주형태 -->
	<t:ExtComboStore comboType="AU" comboCode="M201" />				<!-- 구매담당 -->
	<t:ExtComboStore comboType="AU" comboCode="Q021" />				<!-- 접수담당 -->
	<t:ExtComboStore comboType="AU" comboCode="Q001" opts="1;3;5"/>	<!-- 검사진행상태 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

var SearchInfoWindow;		//조회버튼 누르면 나오는 조회창
var referOrderWindow;		//발주참조
var referCommerceWindow;	//무역참조
var labelPartitionPrintWindow;//라벨분할출력
var BsaCodeInfo = {
	gsReportGubun: '${gsReportGubun}'
};
var printHiddenYn = true;
if(BsaCodeInfo.gsReportGubun == 'CLIP'){
	printHiddenYn = false
}
var collectDateHidden = true;
if(UserInfo.deptName == '노비스바이오(주)'){
	collectDateHidden = false;
}

function appMain() {

	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('Mms120skrvModel', {
		fields: [
			{name: 'PRINT_CNT'			, text: '출력매수'			, type: 'int'},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.purchase.division" default="사업장"/>'			, type: 'string'},
			{name: 'RECEIPT_NUM'		, text: '<t:message code="system.label.purchase.receiptno2" default="접수번호"/>'		, type: 'string'},
			{name: 'RECEIPT_SEQ'		, text: '<t:message code="system.label.purchase.seq" default="순번"/>'				, type: 'int'},
			{name: 'RECEIPT_DATE'		, text: '<t:message code="system.label.purchase.receiptdate2" default="접수일"/>'		, type: 'uniDate'},
			{name: 'CUSTOM_CODE'		, text: '<t:message code="system.label.purchase.customcode" default="거래처코드"/>'		, type: 'string'},
			{name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.purchase.customname" default="거래처명"/>'		, type: 'string'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'			, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'			, type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.purchase.spec" default="규격"/>'				, type: 'string'},
			{name: 'ORDER_DATE'			, text: '발주일자'				, type: 'uniDate'},
			{name: 'MAKE_LOT_NO'		, text: '업체LOT'				, type: 'string'},
			{name: 'MAKE_DATE'			, text: '업체제조일'				, type: 'uniDate'},
			{name: 'MAKE_EXP_DATE'		, text: '유통기한'				, type: 'uniDate'},
			{name: 'ORDER_Q'			, text: '<t:message code="system.label.purchase.poqty" default="발주량"/>'				, type: 'uniQty'},
			{name: 'RECEIPT_Q'			, text: '<t:message code="system.label.purchase.receiptqty2" default="접수량"/>'		, type: 'uniQty'},
			{name: 'NOR_RECEIPT_Q'		, text: '(정상)접수량'		, type: 'uniQty' },
			{name: 'FREE_RECEIPT_Q'		, text: '(무상)접수량'		, type: 'uniQty' },
			{name: 'ORDER_UNIT'			, text: '구매단위'				, type: 'string'},
			{name: 'ORDER_P'			, text: '<t:message code="system.label.purchase.price" default="단가"/>'				, type: 'uniUnitPrice'},
			{name: 'ORDER_UNIT_P'		, text: '<t:message code="system.label.purchase.price" default="단가"/>'				, type: 'uniUnitPrice'},
			{name: 'ORDER_O'			, text: '<t:message code="system.label.purchase.amount" default="금액"/>'				, type: 'uniFC'},
			{name: 'NOT_RECEIPT_Q'		, text: '<t:message code="system.label.purchase.notreceiveqty" default="미접수량"/>'	, type: 'uniQty'},
			{name: 'RECEIPT_PRSN'		, text: '<t:message code="system.label.purchase.receiptcharge2" default="접수담당"/>'	, type: 'string' 	, comboType: 'AU' , comboCode: 'Q021'},
			{name: 'INSPEC_FLAG'		, text: '검사대상'		, type: 'string' ,comboType: 'AU' ,comboCode:'Q002'},
			{name: 'ORDER_NUM'			, text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'				, type: 'string'},
			{name: 'ORDER_SEQ'			, text: '<t:message code="system.label.purchase.poseq" default="발주순번"/>'			, type: 'int'},
			{name: 'PJT_NAME'			, text: '프로젝트명'		, type: 'string'},
			{name: 'PROJECT_NO'			, text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'		, type: 'string'},
			{name: 'ORDER_PRSN'			, text: '<t:message code="system.label.purchase.purchasecharge" default="구매담당"/>'	, type: 'string' 	, comboType: 'AU' , comboCode: 'M201'},
			{name: 'LOT_NO'				, text: 'LOT NO'	, type: 'string'},
			{name: 'ORDER_TYPE'			, text: '<t:message code="system.label.purchase.potype" default="발주형태"/>'			, type: 'string' 	, comboType: 'AU' , comboCode: 'M001'},
			{name: 'DEPT_CODE'			, text: '<t:message code="system.label.purchase.departmencode" default="부서코드"/>'	, type: 'string'},
			{name: 'DEPT_NAME'			, text: '<t:message code="system.label.purchase.departmentname" default="부서명"/>'	, type: 'string'},
			{name: 'WH_CODE'			, text: '<t:message code="system.label.purchase.warehouse" default="창고"/>'			, type: 'string'},
			{name: 'INSPEC_STATUS'		, text: '검사진행상태'	, type: 'string', comboType: 'AU' , comboCode: 'Q001'},
			{name: 'INSPEC_DATE'		, text: '검사일'		, type: 'uniDate'},
			{name: 'END_DECISION'		, text: '<t:message code="system.label.purchase.finaldecision" default="최종판정"/>'		, type: 'string',comboType:'AU',comboCode:'Q033'},
			{name: 'STOCK_UNIT'			, text: '<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>'	, type: 'string',comboType:'AU',comboCode:'B013', displayField: 'value'},
			// 20210215 납기요청일(DVRY_DATE) 추가 
			{name: 'DVRY_DATE'			, text: '<t:message code="system.label.purchase.deliveryreqdate" default="납기요청일"/>'	, type: 'uniDate'},
			{name: 'SO_NUM'			, text: '<t:message code="system.label.sales.sono" default="수주번호"/>'	, type: 'string'}
		]
	});



	var masterStore = Unilite.createStore('Mms120skrvMasterStore',{	//조회버튼 누르면 나오는 조회창
		model: 'Mms120skrvModel',
		autoLoad: false,
		uniOpt: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: true,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		proxy: {
			type: 'direct',
			api: {
				read: 'mms120skrvService.selectreceiptNumMasterList'
			}
		},
		loadStoreRecords: function() {
			var param= panelResult.getValues();

			panelResult.setValue('RECEIPT_NUMS','');
			panelResult.setValue('ITEM_CODES','');
			console.log( param );
			this.load({
				params : param
			});
		}
	});



	/** 검색조건 (Search Panel)
	 * @type
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title		: '<t:message code="system.label.purchase.searchconditon" default="검색조건"/>',
		defaultType	: 'uniSearchSubPanel',
		collapsed	: UserInfo.appOption.collapseLeftSearch,
		layout		: {type: 'uniTable', columns: 1},
		listeners	: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			}
		},
		items: [{
			fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelResult.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel		: '<t:message code="system.label.purchase.receiptdate2" default="접수일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'RECEIPT_DATE_FR',
			endFieldName	: 'RECEIPT_DATE_TO',
			allowBlank		: false,
			startDate		: UniDate.get('startOfMonth'),
			endDate			: UniDate.get('today'),
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelResult) {
					panelResult.setValue('RECEIPT_DATE_FR',newValue);
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelResult) {
					panelResult.setValue('RECEIPT_DATE_TO',newValue);
				}
			}
		},
		Unilite.popup('CUST',{
			fieldLabel		: '<t:message code="system.label.purchase.custom" default="거래처"/>',
			autoPopup		: true,
			validateBlank	: false,
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
//			extParam		: {'CUSTOM_TYPE': ['1','2']},
			allowBlank:true,	// 2021.08 표준화 작업
			autoPopup:false,	// 2021.08 표준화 작업
			validateBlank:false,// 2021.08 표준화 작업
			listeners: {
						onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
							panelSearch.setValue('CUSTOM_CODE', newValue);
							panelResult.setValue('CUSTOM_CODE', newValue);
							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('CUSTOM_NAME', '');
								panelResult.setValue('CUSTOM_NAME', '');
							}
						},
						onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
							panelSearch.setValue('CUSTOM_NAME', newValue);
							panelResult.setValue('CUSTOM_NAME', newValue);
							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('CUSTOM_CODE', '');
								panelResult.setValue('CUSTOM_CODE', '');
							}	
						},
						applyextparam: function(popup){
							popup.setExtParam({'CUSTOM_TYPE': ['1','2']});
						}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.purchase.potype" default="발주형태"/>',
			name		: 'ORDER_TYPE',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'M001',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelResult.setValue('ORDER_TYPE', newValue);
				}
			}
		},{
			fieldLabel	: 'LOT NO',
			name		: 'LOT_NO',
			xtype		: 'uniTextfield',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelResult.setValue('LOT_NO', newValue);
				}
			}
		},
		Unilite.popup('DIV_PUMOK',{
			fieldLabel		: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
			valueFieldName	: 'ITEM_CODE',
			textFieldName	: 'ITEM_NAME',
			allowBlank:true,	// 2021.08 표준화 작업
			autoPopup:false,	// 2021.08 표준화 작업
			validateBlank:false,// 2021.08 표준화 작업
			listeners: {
						onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
							panelSearch.setValue('ITEM_CODE', newValue);
							panelResult.setValue('ITEM_CODE', newValue);
							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('ITEM_NAME', '');
								panelResult.setValue('ITEM_NAME', '');
							}
						},
						onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
							panelSearch.setValue('ITEM_NAME', newValue);
							panelResult.setValue('ITEM_NAME', newValue);
							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('ITEM_CODE', '');
								panelResult.setValue('ITEM_CODE', '');
							}	
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.purchase.purchasecharge" default="구매담당"/>',
			name		: 'RECEIPT_PRSN',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'Q021',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelResult.setValue('RECEIPT_PRSN', newValue);
				}
			}
		},{
			fieldLabel	: '검사진행상태',
			name		: 'INSPEC_STATUS',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'Q001',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelResult.setValue('INSPEC_STATUS', newValue);
				}
			}
		},{
			name		: 'ITEM_ACCOUNT',
			fieldLabel	: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B020',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelResult.setValue('ITEM_ACCOUNT', newValue);
				}
			}
		}],
		setAllFieldsReadOnly: function(b) {
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
					alert(labelText+Msg.sMB083);
					invalid.items[0].focus();
				} else {
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) ) {
							if (item.holdable == 'hold') {
								item.setReadOnly(true);
							}
						}
						if(item.isPopupField) {
							var popupFC = item.up('uniPopupField')	;
							if(popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					})
				}
			} else {
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) ) {
						if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					}
					if(item.isPopupField) {
						var popupFC = item.up('uniPopupField')	;
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		}
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		layout	: {type : 'uniTable', columns : 5},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,
			child		: 'WH_CODE',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel		: '<t:message code="system.label.purchase.receiptdate2" default="접수일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'RECEIPT_DATE_FR',
			endFieldName	: 'RECEIPT_DATE_TO',
			allowBlank		: false,
			startDate		: UniDate.get('startOfMonth'),
			endDate			: UniDate.get('today'),
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				panelSearch.setValue('RECEIPT_DATE_FR',newValue);
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				panelSearch.setValue('RECEIPT_DATE_TO',newValue);
			}
		},
		Unilite.popup('CUST',{
			fieldLabel		: '<t:message code="system.label.purchase.custom" default="거래처"/>',
			autoPopup		: true,
			validateBlank	: false,
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
//			extParam		: {'CUSTOM_TYPE': ['1','2']},
			allowBlank:true,	// 2021.08 표준화 작업
			autoPopup:false,	// 2021.08 표준화 작업
			validateBlank:false,// 2021.08 표준화 작업
			listeners: {
						onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
							panelSearch.setValue('CUSTOM_CODE', newValue);
							panelResult.setValue('CUSTOM_CODE', newValue);
							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('CUSTOM_NAME', '');
								panelResult.setValue('CUSTOM_NAME', '');
							}
						},
						onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
							panelSearch.setValue('CUSTOM_NAME', newValue);
							panelResult.setValue('CUSTOM_NAME', newValue);
							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('CUSTOM_CODE', '');
								panelResult.setValue('CUSTOM_CODE', '');
							}
						},
						applyextparam: function(popup){
							popup.setExtParam({'CUSTOM_TYPE': ['1','2']});
						}
			}
		}),{
			xtype: 'container',
			layout:{type:'uniTable',columns:2},
			colspan:2,
			items:[{
						text:'<div style="color: red">시험의뢰서 출력</div>',
						xtype: 'button',
						margin: '0 0 0 15',
						hidden: printHiddenYn,
						handler: function(){
							if(!panelResult.getInvalidMessage()) return;		//필수체크

							var selectedRecords = masterGrid.getSelectedRecords();
							if(Ext.isEmpty(selectedRecords)){
								alert('출력할 데이터를 선택하여 주십시오.');
								return;
							}
							var receiptNums = '';
							var receiptSeqs = '';
							var itemCodes = '';
//							var param = panelResult.getValues();
							var param = {};
							param.COLLECT_DATE = UniDate.getDateStr(panelResult.getValue('COLLECT_DATE'));
							param.DIV_CODE = panelResult.getValue('DIV_CODE');
							Ext.each(selectedRecords, function(selectedRecord, index){
								if(index ==0) {
									receiptNums	= receiptNums + selectedRecord.get('RECEIPT_NUM');
									receiptSeqs		= receiptSeqs + selectedRecord.get('RECEIPT_SEQ');
									itemCodes	    = itemCodes + selectedRecord.get('ITEM_CODE');
								}else{
									receiptNums	= receiptNums + ',' + selectedRecord.get('RECEIPT_NUM');
									receiptSeqs		= receiptSeqs + ',' + selectedRecord.get('RECEIPT_SEQ');
									itemCodes      = itemCodes + ',' + selectedRecord.get('ITEM_CODE');
								}
							});

							param["dataCount"] = selectedRecords.length;
							param["RECEIPT_NUMS"] = receiptNums;
							param["RECEIPT_SEQS"] = receiptSeqs;
							param["ITEM_CODES"] = itemCodes;
							param["MAIN_CODE"] = 'M030';
							param["sTxtValue2_fileTitle"]='검사결과서';

							param["RPT_ID"]='mms110rkrv';
							param["PGM_ID"]='mms110ukrv';
							var win = '';
								 win = Ext.create('widget.ClipReport', {
									url: CPATH+'/matrl/mms110clukrv_2.do',
									prgID: 'mms110ukrv',
									extParam: param
								});
								win.center();
								win.show();
						}
					},{
						text	: '<div style="color: red">라벨출력</div>',
						xtype	: 'button',
						margin	: '0 0 0 20',
						handler	: function(){
							UniAppManager.app.onPrintButtonDown();
						}
					}]
		}
		,{
			fieldLabel	: '<t:message code="system.label.purchase.potype" default="발주형태"/>',
			name		: 'ORDER_TYPE',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'M001',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('ORDER_TYPE', newValue);
				}
			}
		},{
			fieldLabel	: 'LOT NO',
			name		: 'LOT_NO',
			xtype		: 'uniTextfield',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('LOT_NO', newValue);
				}
			}
		},
		Unilite.popup('DIV_PUMOK',{
			fieldLabel		: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
			valueFieldName	: 'ITEM_CODE',
			textFieldName	: 'ITEM_NAME',
			validateBlank	: false,
			colspan			: 3,
			allowBlank:true,	// 2021.08 표준화 작업
			autoPopup:false,	// 2021.08 표준화 작업
			validateBlank:false,// 2021.08 표준화 작업
			listeners: {
						onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
							panelSearch.setValue('ITEM_CODE', newValue);
							panelResult.setValue('ITEM_CODE', newValue);
							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('ITEM_NAME', '');
								panelResult.setValue('ITEM_NAME', '');
							}
						},
						onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
							panelSearch.setValue('ITEM_NAME', newValue);
							panelResult.setValue('ITEM_NAME', newValue);
							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('ITEM_CODE', '');
								panelResult.setValue('ITEM_CODE', '');
							}	
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.purchase.purchasecharge" default="구매담당"/>',
			name		: 'RECEIPT_PRSN',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'Q021',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('RECEIPT_PRSN', newValue);
				}
			}
		},{
			fieldLabel	: '검사진행상태',
			name		: 'INSPEC_STATUS',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'Q001',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('INSPEC_STATUS', newValue);
				}
			}
		},{
			name		: 'ITEM_ACCOUNT',
			fieldLabel	: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B020',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('ITEM_ACCOUNT', newValue);
				}
			}
		},{
        	fieldLabel: '<t:message code="system.label.purchase.collectiondate" default="채취일"/>',
        	xtype: 'uniDatefield',
        	name:'COLLECT_DATE',
       		value: UniDate.get('today'),
     		allowBlank: true,
     		hidden: collectDateHidden,
 //    		holdable: 'hold',
     		listeners: {
				change: function(field, newValue, oldValue, eOpts) {

				}
			}
		},{
			fieldLabel	: 'RECEIPT_NUM',
			xtype		: 'uniTextfield',
			name		: 'RECEIPT_NUM',
			hidden		: true
		},{
			fieldLabel	: 'RECEIPT_NUMS',
			xtype		: 'textarea',
			name		: 'RECEIPT_NUMS',
			hidden		: true
		},{
			fieldLabel	: 'ITEM_CODES',
			xtype		: 'textarea',
			name		: 'ITEM_CODES',
			hidden		: true
		}],
		setAllFieldsReadOnly: function(b) {
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
					alert(labelText+Msg.sMB083);
					invalid.items[0].focus();
				} else {
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) ) {
							if (item.holdable == 'hold') {
								item.setReadOnly(true);
							}
						}
						if(item.isPopupField) {
							var popupFC = item.up('uniPopupField')	;
							if(popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					})
				}
			} else {
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) ) {
						if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					}
					if(item.isPopupField) {
						var popupFC = item.up('uniPopupField')	;
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		}
	});



	/** Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('mms120skrvGrid1', {
		layout: 'fit',
		region: 'center',
		excelTitle: '<t:message code="system.label.purchase.receiptentry2" default="접수등록"/>',
		uniOpt: {
			onLoadSelectFirst: false,
			expandLastColumn: false,
			useRowNumberer: false
		},
		features: [{
			id: 'masterGridSubTotal',
			ftype: 'uniGroupingsummary',
			showSummaryRow: true
		},{
			id: 'masterGridTotal',
			ftype: 'uniSummary',
			showSummaryRow: true
		}],
		store: masterStore,
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: false, toggleOnClick: false,
			listeners: {
				select: function(grid, selectRecord, index, rowIndex, eOpts ){

				},
				deselect:  function(grid, selectRecord, index, eOpts ){

				}
			}
		}),
		columns: [
			{ dataIndex: 'PRINT_CNT'		 ,width:80 ,align: 'center' },
			{ dataIndex: 'DIV_CODE'		 ,width:100 ,hidden: true},
			{ dataIndex: 'RECEIPT_NUM'		,width:120,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {

					var sumPrintQ = 0;
					Ext.each(masterStore.data.items, function(record, idx) {
						sumPrintQ = sumPrintQ + record.get('PRINT_CNT') * record.get('RECEIPT_Q');
					});

					return Unilite.renderSummaryRow(summaryData, metaData, '소계', sumPrintQ);
					}},
			{ dataIndex: 'RECEIPT_SEQ'		,width:50},
			{ dataIndex: 'RECEIPT_DATE'		,width:80},
			{ dataIndex: 'CUSTOM_CODE'		,width:80},
			{ dataIndex: 'CUSTOM_NAME'		,width:100},
			{ dataIndex: 'ITEM_CODE'		,width:100},
			{ dataIndex: 'ITEM_NAME'		,width:150},
			{ dataIndex: 'SPEC'				,width:100},
			{ dataIndex: 'INSPEC_FLAG'		,width:100,align: 'center'},
			{ dataIndex: 'INSPEC_STATUS'	,width:100,align: 'center'},
			{  text: '<t:message code="system.label.purchase.print" default="출력"/>',
				width: 100,
				xtype: 'widgetcolumn',
				widget: {
					xtype: 'button',
					text: '<t:message code="system.label.purchase.label" default="라벨"/><t:message code="system.label.purchase.partition" default="분할"/>',
					listeners: {
						buffer:1,
						click: function(button, event, eOpts) {
							gsSelRecord2 = event.record.data;
							labelPartitionPrintSearch.setValue('LABEL_ITEM_CODE'  , gsSelRecord2.ITEM_CODE);
							labelPartitionPrintSearch.setValue('LABEL_LOT_NO'	, gsSelRecord2.LOT_NO);
							labelPartitionPrintSearch.setValue('LABEL_RECEIPT_QTY', gsSelRecord2.RECEIPT_Q * gsSelRecord2.TRNS_RATE);
							labelPartitionPrintSearch.setValue('LABEL_RECEIPT_NUM', gsSelRecord2.RECEIPT_NUM);
							labelPartitionPrintSearch.setValue('LABEL_RECEIPT_SEQ', gsSelRecord2.RECEIPT_SEQ);
							Ext.getCmp('LABEL_STOCK_UNIT').setText(gsSelRecord2.STOCK_UNIT);
							openLabelPartitionWindow(gsSelRecord2);
						}
					}
				}
			},
			{ dataIndex: 'END_DECISION'	,width:100,align: 'center'},
			{ dataIndex: 'INSPEC_DATE'		,width:100},
			{ dataIndex: 'ORDER_DATE'		,width:100},
			{ dataIndex: 'DVRY_DATE'		,width:100}, // 20210215 납기요청일 추가
			{ dataIndex: 'ORDER_Q'			,width:80 , summaryType: 'sum'},
			{ dataIndex: 'RECEIPT_Q'		,width:80 , summaryType: 'sum'},
			{ dataIndex: 'NOR_RECEIPT_Q'	,width:80 ,hidden: true, summaryType: 'sum'},
			{ dataIndex: 'FREE_RECEIPT_Q'	,width:80 ,hidden: true, summaryType: 'sum'},
			{ dataIndex: 'LOT_NO'			,width:100,align: 'center'},
			{ dataIndex: 'ORDER_UNIT'		,width:80, align: 'center'},
			{ dataIndex: 'ORDER_P'			,width:80,hidden:true},
			{ dataIndex: 'ORDER_UNIT_P'		,width:80},
			{ dataIndex: 'ORDER_O'			,width:120 , summaryType: 'sum'},
			{ dataIndex: 'NOT_RECEIPT_Q'	,width:80 , summaryType: 'sum'},
			{ dataIndex: 'MAKE_LOT_NO'		,width:100},
			{ dataIndex: 'MAKE_DATE'		,width:80},
			{ dataIndex: 'MAKE_EXP_DATE'		,width:80},
			{ dataIndex: 'RECEIPT_PRSN'		,width:80 ,align: 'center' ,hidden: true},
			{ dataIndex: 'SO_NUM'		,width:100,hidden:true},
			{ dataIndex: 'ORDER_NUM'		,width:100},
			{ dataIndex: 'ORDER_SEQ'		,width:80},
			{ dataIndex: 'ORDER_PRSN'		,width:100 ,align: 'center'},
			{ dataIndex: 'PJT_NAME'			,width:180},
			{ dataIndex: 'PROJECT_NO'		,width:100},
			{ dataIndex: 'STOCK_UNIT'		,width:80,hidden: true},
			{ dataIndex: 'ORDER_TYPE'		,width:50 ,align: 'center' ,hidden: true},
			{ dataIndex: 'WH_CODE'			,width:50 ,align: 'center' ,hidden: true}
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if(UniUtils.indexOf(e.field, ['PRINT_CNT'])){
					return true;
				}else{
					return false;
				}
			}
		}
	});

	function pad(n, width) {
		  n = n + '';
		  return n.length >= width ? n : new Array(width - n.length + 1).join('0') + n;
	}

	 //라벨분할출력 폼
  	var labelPartitionPrintSearch = Unilite.createSearchForm('labelPartitionPrintForm', {
  		layout	: {type : 'uniTable', columns : 2},
  		border:true,
  		items	: [{
  			fieldLabel	: '<t:message code="system.label.purchase.oemitemcode" default="품번"/>',
  			name		: 'LABEL_ITEM_CODE',
  			xtype		: 'uniTextfield',
  			align		: 'center',
  			margin  : '0 0 0 0',
  			decimalPrecision: 0,
  			value		: 1,
  			colspan	 : 2,
  			hidden		: false,
  			readOnly	: true,
  			fieldStyle: 'text-align: center;',
  			listeners	: {
  				change: function(field, newValue, oldValue, eOpts) {
  				}
  			}
  		},{
  			fieldLabel	: 'LOT_NO',
  			xtype		: 'uniTextfield',
  			name		: 'LABEL_LOT_NO',
  			margin  : '0 0 0 0',
  			colspan	 : 2,
  			allowBlank	: true,
  			align		: 'center',
  			readOnly	: true,
  			fieldStyle: 'text-align: center;',
  			holdable	: 'hold'
  		},{
  			fieldLabel	: '<t:message code="system.label.purchase.receiptqty" default="입고량"/>',
  			xtype		: 'uniNumberfield',
  			name		: 'LABEL_RECEIPT_QTY',
  			margin  : '0 0 0 0',
  			allowBlank	: true,
  //			suffixTpl:'&nbsp;M',
  			hidden	: false,
  			fieldStyle: 'text-align: center;',
  			holdable	: 'hold'
  		},{
  			xtype: 'label',
  			id : 'LABEL_STOCK_UNIT',
  			text : '&nbsp;M',
  			margin: '0 0 0 0'
  		},{
  			fieldLabel	: 'LABEL_RECEIPT_NUM',
  			xtype		: 'uniTextfield',
  			name		: 'LABEL_RECEIPT_NUM',
  			margin  : '0 0 0 0',
  			allowBlank	: true,
  			readOnly	: true,
  			hidden	: true,
  			holdable	: 'hold'
  		},{
  			fieldLabel	: 'LABEL_RECEIPT_SEQ',
  			xtype		: 'uniNumberfield',
  			name		: 'LABEL_RECEIPT_SEQ',
  			margin  : '0 0 0 0',
  			allowBlank	: true,
  			hidden	: true,
  			holdable	: 'hold'
  		}]
  	});


	 Unilite.defineModel('labelPartitonPrintModel', {		//라벨 분할 출력 모델
 		fields: [
			{name: 'SEQ'		 	, text: '<t:message code="system.label.purchase.seq" default="순번"/>'		 , type: 'int'},
 	 	 	{name: 'PACK_QTY'		, text: '<t:message code="system.label.purchase.qty" default="수량"/>'		 , type: 'int'},
 	 	 	{name: 'PRINT_QTY'	, text: '<t:message code="system.label.purchase.printqty" default="출력매수"/>'	, type: 'int'}
 		]
 	});

	 var labelPartitonPrintStore = Unilite.createStore('labelPartitonPrintStore', {	//라벨분할출력스토어
 		model: 'labelPartitonPrintModel',
		 autoLoad: false,
		 uniOpt: {
		 	isMaster: false,			// 상위 버튼 연결
		 	editable: true,			// 수정 모드 사용
		 	deletable: false,			// 삭제 가능 여부
			useNavi: false			// prev | newxt 버튼 사용
		 },
		 proxy: {
		 	type: 'direct',
			 api: {
			 	read: 'mms110ukrvService.selectLabelPrintList'
			 }
		 },
		 loadStoreRecords: function() {
 			var param= labelPartitionPrintSearch.getValues();
 			console.log( param );
 			this.load({
 				params : param
 			});
 		},
		listeners:{
			load:function(store, records, successful, eOpts) {
			}
		}
 	});



 	//라벨분할출력 폼
 	var labelPartitionPrintSearch2 = Unilite.createSearchForm('labelPartitionPrintForm2', {
 		layout		: {type:'vbox', align:'center', pack: 'center' },
 		region: 'south',
 		padding :'1 1 1 1',
 		border:true,
 		items	: [{
			xtype		: 'container',
			defaultType	: 'uniTextfield',
			//layout		: {type:'vbox', align:'center', pack: 'center' },
			layout		: {type : 'uniTable', columns : 2},
			items		: [{
			 				xtype	: 'button',
			 				name	: 'labelPrint',
			 				text	: '<t:message code="system.label.purchase.labelprint" default="라벨출력"/>',
			 				width	: 80,
			 				hidden	: false,
			 				handler : function() {

			 					var param = labelPartitionPrintSearch.getValues();

			 					param.PGM_ID= 'mms110ukrv';
			 					param.MAIN_CODE= 'M030';

			 					var packQtyList;
			 					var printQtyList;
			 					var receiptNumList;
			 					var receiptSeqList;
			 					var seqList;
			 					var dataCount = 0;

			 					Ext.each(labelPartitonPrintStore.data.items, function(record, idx) {
			 						if(record.get("PACK_QTY") > 0 && record.get("PRINT_QTY") > 0) {
			 							if(dataCount == 0){
			 								packQtyList = record.get("PACK_QTY");
				 							printQtyList   = record.get("PRINT_QTY");
				 							seqList   	 = record.get("SEQ");
				 							dataCount 	 = dataCount + 1;
			 							}else{
			 								packQtyList	= packQtyList	+ ',' + record.get("PACK_QTY");
				 							printQtyList   = printQtyList	+ ',' + record.get("PRINT_QTY");
				 							seqList   	 = seqList		+ ',' + record.get("SEQ");
				 							dataCount	= dataCount 		+ 1;
			 							}
			 						}
			 					});
								if(dataCount == 0){
									alert('출력할 데이터가 없습니다.');
									return false;
								}
			 					param["seqList"]   = seqList;
			 					param["dataCount"] = dataCount;
			 					param["PACK_QTY"]  = packQtyList;
			 					param["PRINT_QTY"] = printQtyList;
								param["DIV_CODE"]  = panelResult.getValue('DIV_CODE');

			 					var win = Ext.create('widget.ClipReport', {
			 					url: CPATH+'/mms/mms110clukrv_partition.do',
			 					prgID: 'mms110ukrv',
			 					extParam: param
			 					});
			 					win.center();
			 					win.show();
			 				}
			 			},{
			 				xtype	: 'button',
			 				name	: 'btnCancel',
			 				text	: '<t:message code="system.label.purchase.close" default="닫기"/>',
			 				width	: 80,
			 				hidden	: false,
			 				handler	: function() {
			 					labelPartitionPrintSearch.clearForm();
			 					labelPartitionPrintWindow.hide();
			 				}
			 		}]
 		}]
 	});
 	var labelPartitionPrintGrid = Unilite.createGrid('mms110ukrvPartitionPrintGrid', {		//라벨분할그리드
		layout :'fit',
		store: labelPartitonPrintStore,
		uniOpt: {
			userToolbar:true,
			expandLastColumn: false,
			useLiveSearch: false,
			useContextMenu: false,
			useMultipleSorting: false,
			useGroupSummary: false,
			useRowNumberer: false,
			onLoadSelectFirst: false,
			state: {
				useState: false,
				useStateList: false
			}
		},
		tbar: [{itemId: 'labelPartitonReset',
				text: '<div style="color: blue"><t:message code="system.label.purchase.reset2" default="초기화"/></div>',
				handler: function() {
					labelPartitonPrintStore.loadStoreRecords();
				}
			 }],
		features: [ {id : 'masterGridSubTotal',	ftype: 'uniGroupingsummary',	showSummaryRow: false},
					{id : 'masterGridTotal',	ftype: 'uniSummary',			showSummaryRow: true} ],
		columns:  [
			{ dataIndex: 'SEQ'	 	 	,width:50, align: 'center',
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '소계', '합계');
					}
			},
			{ dataIndex: 'PACK_QTY'	 	,width:147 ,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {

					var sumPrintQ = 0;
					Ext.each(labelPartitonPrintStore.data.items, function(record, idx) {
						sumPrintQ = sumPrintQ + record.get('PACK_QTY') * record.get('PRINT_QTY');
					});

					return  Ext.util.Format.number(sumPrintQ, '0,000');
				}
			},
			{ dataIndex: 'PRINT_QTY'		,width:147, summaryType: 'sum'}
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if(UniUtils.indexOf(e.field, ['PACK_QTY','PRINT_QTY'])){
					return true;
				}else{
					return false;
				}
			}
		}
	});

	function openLabelPartitionWindow() {
 		//if(!UniAppManager.app.checkForNewDetail()) return false;
 		if(!labelPartitionPrintWindow) {
 			labelPartitionPrintWindow = Ext.create('widget.uniDetailWindow', {
 				title		: '<t:message code="system.label.purchase.label" default="라벨"/><t:message code="system.label.purchase.partition" default="분할"/><t:message code="system.label.purchase.print" default="출력"/>',
 				width		: 360,
 				height		: 380,
 		 		//resizable	: false,
 				layout		:{type:'vbox', align:'stretch'},
 				items		: [labelPartitionPrintSearch, labelPartitionPrintGrid, labelPartitionPrintSearch2],
 				listeners	: {
 					beforehide	: function(me, eOpt) {
 						labelPartitionPrintGrid.reset();
 						labelPartitonPrintStore.clearData();
 						labelPartitionPrintSearch.clearForm();
 						//labelPartitonPrintStore.loadStoreRecords();
 					},
 					beforeclose: function( panel, eOpts ) {

 					},
 					beforeshow: function ( me, eOpts ) {

 					},
					show: function(me, eOpts) {
						labelPartitonPrintStore.loadStoreRecords();
					}
 				}
 			})
 		}
 		labelPartitionPrintWindow.center();
 		labelPartitionPrintWindow.show();
 	}


	Unilite.Main({
		id			: 'mms120skrvApp',
		borderItems	: [{
			region: 'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult
			]
		},
			panelSearch
		],
		fnInitBinding: function(){
			panelResult.setValue('RECEIPT_DATE_FR'		,UniDate.get('startOfMonth'));
			panelResult.setValue('RECEIPT_DATE_TO'		,UniDate.get('today'));
			panelResult.setValue('DIV_CODE'		,UserInfo.divCode);
			this.setDefault();
		},
		onQueryButtonDown: function() {
			if(panelResult.setAllFieldsReadOnly(true) == false){
				return false;
			}
			masterStore.loadStoreRecords();
		},
		onResetButtonDown: function(){
			panelSearch.clearForm();
			panelSearch.setAllFieldsReadOnly(false);
			panelResult.clearForm();
			panelResult.setAllFieldsReadOnly(false);
			masterGrid.reset();
			masterStore.clearData();
			this.fnInitBinding();
		},
		setDefault: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('COLLECT_DATE'		,UniDate.get('today'));
			panelSearch.getForm().wasDirty = false;
			panelSearch.resetDirtyStatus();
			UniAppManager.setToolbarButtons(['save','print'], false);
		},
		onPrintButtonDown: function(){
//			var param = panelResult.getValues();
			var param = {};
			param.DIV_CODE = panelResult.getValue('DIV_CODE');
			var selectedDetails = masterGrid.getSelectedRecords();
			if(Ext.isEmpty(selectedDetails)){
				alert('출력할 데이터를 선택하여 주십시오.');
				return;
			}

			param.PGM_ID= 'mms110ukrv';
			param.MAIN_CODE= 'M030';

			var receiptNumList;
			var receiptSeqList;

			var printCntList;

			Ext.each(selectedDetails, function(record, idx) {
				if(idx ==0) {
					receiptNumList= record.get("RECEIPT_NUM");
					receiptSeqList= record.get("RECEIPT_SEQ");
					printCntList= record.get("PRINT_CNT");
				} else {
					receiptNumList= receiptNumList	+ ',' + record.get("RECEIPT_NUM");
					receiptSeqList= receiptSeqList	+ ',' + record.get("RECEIPT_SEQ");
					printCntList= printCntList	+ ',' + record.get("PRINT_CNT");
				}

			});

			param["dataCount"] = selectedDetails.length;
			param["RECEIPT_NUM"] = receiptNumList;
			param["RECEIPT_SEQ"] = receiptSeqList;
			param["PRINT_CNT"] = printCntList;
			param.COLLECT_DATE = UniDate.getDateStr(panelResult.getValue('COLLECT_DATE'));
			var win = Ext.create('widget.ClipReport', {
			url: CPATH+'/mms/mms120clskrv.do',
			prgID: 'mms110ukrv',
			extParam: param
			});
			win.center();
			win.show();
		}
	});
};
</script>