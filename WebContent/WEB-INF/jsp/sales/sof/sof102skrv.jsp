<%--
'   프로그램명 : 수주현황조회 (영업)
'   작  성  자 : (주)포렌 개발실
'   작  성  일 :
'   최종수정자 :
'   최종수정일 :
'   버	  전 : OMEGA Plus V6.0.0
--%>

<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="sof102skrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="sof102skrv"/>			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="S010" />					<!--영업담당 -->
	<t:ExtComboStore comboType="AU" comboCode="B055" />					<!-- 거래처분류 -->
	<t:ExtComboStore comboType="AU" comboCode="B056" />					<!-- 지역 -->
	<t:ExtComboStore comboType="AU" comboCode="S002" />					<!--판매유형-->
	<t:ExtComboStore comboType="AU" comboCode="B059" />					<!--과세구분-->
	<t:ExtComboStore comboType="AU" comboCode="S011" />					<!--마감유형-->
	<t:ExtComboStore comboType="AU" comboCode="B031" opts= '1;5' />		<!--생성경로-->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
#search_panel2 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
#search_panel3 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
#search_panel4 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >


/*
	* type:
	*	uniQty			-	  수량
	*	uniUnitPrice	-	  단가
	*	uniPrice		-	  금액(자사화폐)
	*	uniPercent		-	  백분율(00.00)
	*	uniFC			-	  금액(외화화폐)
	*	uniER			-	  환율
	*	uniDate			-	  날짜(2999.12.31)
	* maxLength		: 입력가능한 최대 길이
	* editable		: true   수정가능 여부
	* allowBlank	: 필수 여부
	* defaultValue	: 기본값
	* comboType:'AU', comboCode:'B014' : 그리드 콤보 사용시
*/

var BsaCodeInfo = {
	gsMoneyUnit: '${gsMoneyUnit}'
};
var gsInitFlag;
var gsMoneyUnitRef4	= Ext.isEmpty('${gsMoneyUnitRef4}') ? BsaCodeInfo.gsMoneyUnit	: '${gsMoneyUnitRef4}';;
var gsExchangeRate	= '${gsExchangeRate}'; 
if(Ext.isEmpty(gsExchangeRate) || gsExchangeRate == '0.0000') {
	gsExchangeRate = '1.0000';
}

// GroupField string type으로 변환
function dateToString(v, record){
	return UniDate.safeFormat(v);
}
	

function appMain() {
	Unilite.defineModel('sof102skrvModel', {
		fields: [
			{name: 'DVRY_DATE1'			,text:'<t:message code="system.label.sales.deliverydate" default="납기일"/>'						,type:'uniDate',convert:dateToString},
			{name: 'DVRY_TIME1'			,text:'<t:message code="system.label.sales.deliverytime" default="납기시간"/>'						,type:'string'},
			{name: 'ITEM_CODE'			,text:'<t:message code="system.label.sales.item" default="품목"/>'								,type:'string'},
			{name: 'ITEM_NAME'			,text:'<t:message code="system.label.sales.itemname" default="품목명"/>'							,type:'string'},
			{name: 'CUSTOM_CODE1'		,text:'<t:message code="system.label.sales.custom" default="거래처"/>'								,type:'string'},
			{name: 'CUSTOM_NAME1'		,text:'<t:message code="system.label.sales.customname" default="거래처명"/>'						,type:'string'},
			{name: 'SPEC'				,text:'<t:message code="system.label.sales.spec" default="규격"/>'								,type:'string'},
			{name: 'ORDER_UNIT'			,text:'<t:message code="system.label.sales.unit" default="단위"/>'								,type:'string', displayField: 'value'},
			{name: 'PRICE_TYPE'			,text:'<t:message code="system.label.sales.priceclass" default="단가구분"/>'						,type:'string'},
			{name: 'TRANS_RATE'			,text:'<t:message code="system.label.sales.containedqty" default="입수"/>'						,type: 'float' , decimalPrecision: 6 , format:'0,000.000000'},
			{name: 'ORDER_UNIT_Q'		,text:'<t:message code="system.label.sales.soqty" default="수주량"/>'								,type:'uniQty'},
			{name: 'ORDER_WGT_Q'		,text:'<t:message code="system.label.sales.soqtyweight" default="수주량(중량)"/>'					,type:'uniQty'},
			{name: 'ORDER_VOL_Q'		,text:'<t:message code="system.label.sales.soqtyvolumn" default="수주량(부피)"/>'					,type:'uniQty'},
			{name: 'STOCK_UNIT'			,text:'<t:message code="system.label.sales.inventoryunit" default="재고단위"/>'						,type:'string', displayField: 'value'},
			{name: 'STOCK_Q'			,text:'<t:message code="system.label.sales.inventoryunitsoqty" default="재고단위수주량"/>'				,type:'uniQty'},
			{name: 'MONEY_UNIT'			,text:'<t:message code="system.label.sales.currency" default="화폐"/>'							,type:'string'},
			{name: 'ORDER_P'			,text:'<t:message code="system.label.sales.price" default="단가"/>'								,type:'uniUnitPrice'},
			{name: 'ORDER_WGT_P'		,text:'<t:message code="system.label.sales.priceweight" default="단가(중량)"/>'						,type:'uniUnitPrice'},
			{name: 'ORDER_VOL_P'		,text:'<t:message code="system.label.sales.pricevolumn" default="단가(부피)"/>'						,type:'uniUnitPrice'},
			//20181102 외화금액 표시 위해서 uniPrice -> uniFC로 변경
//			{name: 'ORDER_O'			,text:'<t:message code="system.label.sales.soamount" default="수주액"/>'							,type:'uniPrice'},
			{name: 'ORDER_O'			,text:'<t:message code="system.label.sales.soamount" default="수주액"/>'							,type:'uniFC'},

			//20180822 추가
			{name: 'OUTSTOCK_Q'			,text:'<t:message code="system.label.sales.issueqty" default="출고량"/>' 							,type:'uniQty'},
			{name: 'ORDER_REM_Q' 		,text:'<t:message code="system.label.sales.undeliveryqty" default="미납량"/>' 						,type:'uniQty'},
			//20181102 외화금액 표시 위해서 uniPrice -> uniFC로 변경
//			{name: 'ORDER_REM_O' 		,text:'<t:message code="system.label.sales.unissuedamount" default="미납액"/>' 					,type:'uniPrice'},
			{name: 'ORDER_REM_O' 		,text:'<t:message code="system.label.sales.unissuedamount" default="미납액"/>' 					,type:'uniFC'},
			{name: 'SALES_QTY' 			,text:'<t:message code="system.label.sales.salesqty" default="매출량"/>' 							,type:'uniQty'},
			//20181102 외화금액 표시 위해서 uniPrice -> uniFC로 변경
//			{name: 'SALES_AMT' 			,text:'<t:message code="system.label.sales.salesamount" default="매출액"/>' 						,type:'uniPrice'},
			{name: 'SALES_AMT' 			,text:'<t:message code="system.label.sales.salesamount" default="매출액"/>' 						,type:'uniFC'},
			{name: 'PUB_QTY' 			,text:'<t:message code="system.label.sales.taxinvoiceqty" default="세금계산서 수량"/>' 				,type:'uniQty'},
			{name: 'PUB_AMT' 			,text:'<t:message code="system.label.sales.taxinvoiceamount" default="세금계산서 금액"/>' 				,type:'uniPrice'},
			//여기까지

			{name: 'EXCHG_RATE_O'		,text:'<t:message code="system.label.sales.exchangerate" default="환율"/>'						,type:'uniER'},
			{name: 'SO_AMT_WON'			,text:'<t:message code="system.label.sales.exchangeamount" default="환산액"/>'						,type:'uniPrice'},
			{name: 'TAX_TYPE'			,text:'<t:message code="system.label.sales.taxabledivision" default="과세구분"/>'					,type:'string', comboType:'AU', comboCode:'B059'},
			{name: 'ORDER_TAX_O'		,text:'<t:message code="system.label.sales.taxamount" default="세액"/>'							,type:'uniPrice'},
			{name: 'WGT_UNIT'			,text:'<t:message code="system.label.sales.weightunit" default="중량단위"/>'						,type:'string'},
			{name: 'UNIT_WGT'			,text:'<t:message code="system.label.sales.unitweight" default="단위중량"/>'						,type:'string'},
			{name: 'VOL_UNIT'			,text:'<t:message code="system.label.sales.volumnunit" default="부피단위"/>'						,type:'string'},
			{name: 'UNIT_VOL'			,text:'<t:message code="system.label.sales.unitvolumn" default="단위부피"/>'						,type:'string'},
			{name: 'CUSTOM_CODE2'		,text:'<t:message code="system.label.sales.custom" default="거래처"/>'								,type:'string'},
			{name: 'CUSTOM_NAME2'		,text:'<t:message code="system.label.sales.customname" default="거래처명"/>'						,type:'string'},
			{name: 'ORDER_DATE'			,text:'<t:message code="system.label.sales.sodate" default="수주일"/>'								,type:'uniDate',convert:dateToString},
			{name: 'ORDER_TYPE'			,text:'<t:message code="system.label.sales.sellingtype" default="판매유형"/>'						,type:'string',comboType:"AU", comboCode:"S002"},
			{name: 'ORDER_TYPE_NM'		,text:'<t:message code="system.label.sales.sellingtype" default="판매유형"/>'						,type:'string'},
			{name: 'ORDER_NUM'			,text:'<t:message code="system.label.sales.sono" default="수주번호"/>'								,type:'string'},
			{name: 'SER_NO'				,text:'<t:message code="system.label.sales.seq" default="순번"/>'									,type:'integer'},
			{name: 'ORDER_PRSN'			,text:'<t:message code="system.label.sales.salescharge" default="영업담당"/>'						,type:'string',comboType:"AU", comboCode:"S010"},
			{name: 'ORDER_PRSN_NM'		,text:'<t:message code="system.label.sales.chargername" default="담당자명"/>'						,type:'string'},
			{name: 'PROJECT_NO'			,text:'<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'						,type:'string'},
			{name: 'PROJECT_NAME'		,text:'<t:message code="system.label.sales.projectname" default="프로젝트명"/>'						,type:'string'},
			{name: 'PO_NUM'				,text:'<t:message code="system.label.sales.pono2" default="P/O 번호"/>'							,type:'string'},
			{name: 'DVRY_DATE2'			,text:'<t:message code="system.label.sales.deliverydate" default="납기일"/>'						,type:'uniDate',convert:dateToString},
			{name: 'DVRY_TIME'			,text:'<t:message code="system.label.sales.deliverytime" default="납기시간"/>'						,type:'uniTime'},
			{name: 'DVRY_CUST_NM'		,text:'<t:message code="system.label.sales.deliveryplace" default="배송처"/>'						,type:'string'},
			{name: 'PROD_END_DATE'		,text:'<t:message code="system.label.sales.productionfinishrequestdate" default="생산완료요청일"/>'	,type:'uniDate',convert:dateToString},
			{name: 'PROD_Q'				,text:'<t:message code="system.label.sales.productionrequestqty" default="생산요청량"/>'				,type:'uniQty'},
			{name: 'ORDER_STATUS'		,text:'<t:message code="system.label.sales.closing" default="마감"/>'								,type:'string',comboType:"AU", comboCode:"S011"},
			{name: 'REMARK'				,text:'<t:message code="system.label.sales.remarks" default="비고"/>'								,type:'string'},
			{name: 'SORT_KEY'			,text:'SORTKEY'			,type:'string'},
			{name: 'CREATE_LOC'			,text:'CREATE_LOC'		,type:'string'},
			//20181101 추가
			{name: 'EXCHG_MONEY_UNIT'	,text:'<t:message code="system.label.sales.currencyexchanged" default="화폐(환산)"/>'				,type:'string'},
			{name: 'EXCHG_ORDER_O'		,text:'<t:message code="system.label.sales.soamountexchanged" default="수주액(환산)"/>'				,type:'uniFC'},
			{name: 'EXCHG_ORDER_REM_O'	,text:'<t:message code="system.label.sales.unissuedamountexchanged" default="미납액(환산)"/>'		,type:'uniFC'},
			{name: 'EXCHG_SALES_AMT'	,text:'<t:message code="system.label.sales.salesamountexchanged" default="매출액(환산)"/>'			,type:'uniFC'},
			{name: 'ORI_EXCHG_RATE'		,text:'ORI_EXCHG_RATE'	,type:'uniER'}
		]
	});



	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('sof102skrvMasterStore1', {
		model	: 'sof102skrvModel',
		uniOpt	: {
			isMaster	: true,			// 상위 버튼,상태바 연결
			editable	: false,		// 수정 모드 사용
			deletable	: false,		// 삭제 가능 여부
			useNavi		: false			// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api	: {
				read: 'sof102skrvService.selectList1'
			}
		},
		loadStoreRecords: function() {
			var param		= Ext.getCmp('searchForm').getValues();
			var authoInfo	= pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
/*			var deptCode = UserInfo.deptCode;	//부서코드
			if(authoInfo == "5" && Ext.isEmpty(panelSearch.getValue('DEPT_CODE'))){
				param.DEPT_CODE = deptCode;
			}
			console.log( param );*/
			this.load({
				params: param
			});
		},
		groupField: 'CUSTOM_CODE1'
	});



	/** 검색조건 (Search Panel)
	 * @type
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title		: '<t:message code="system.label.sales.searchconditon" default="검색조건"/>',
		defaultType	: 'uniSearchSubPanel',
		collapsed	: UserInfo.appOption.collapseLeftSearch,//true,
		listeners	: {
			collapse: function () {
				panelResult.show();
			},
			expand	: function() {
				panelResult.hide();
			}
		},
		items		: [{
			title		: '<t:message code="system.label.sales.basisinfo" default="기본정보"/>',
			itemId		: 'search_panel1',
			layout		: {type: 'uniTable', columns: 1},
			defaultType	: 'uniTextfield',
			items		: [{
				fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				allowBlank	: false,
				value		: UserInfo.divCode,
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
						combo.changeDivCode(combo, newValue, oldValue, eOpts);
						var field = panelResult.getField('ORDER_PRSN');
						field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult의 필터링 처리 위해..
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel		: '<t:message code="system.label.sales.sodate" default="수주일"/>',
				startFieldName	: 'ORDER_DATE_FR',
				endFieldName	: 'ORDER_DATE_TO',
				xtype			: 'uniDateRangefield',
				width			: 315,
				startDate		: UniDate.get('startOfMonth'),
				endDate			: UniDate.get('today'),
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('ORDER_DATE_FR',newValue);
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('ORDER_DATE_TO',newValue);
					}
				}
			},{
				fieldLabel		: '<t:message code="system.label.sales.deliverydate" default="납기일"/>',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'DVRY_DATE_FR',
				endFieldName	: 'DVRY_DATE_TO',
				width			: 315,
				colspan			: 2,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('DVRY_DATE_FR',newValue);
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('DVRY_DATE_TO',newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>',
				name		: 'ORDER_TYPE',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'S002',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ORDER_TYPE', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.sales.salescharge" default="영업담당"/>',
				name		: 'ORDER_PRSN',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'S010',
				multiSelect	: true,
				typeAhead	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ORDER_PRSN', newValue);
					}
				},
				onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
					if(eOpts){
						combo.filterByRefCode('refCode1', newValue, eOpts.parent);
					}else{
						combo.divFilterByRefCode('refCode1', newValue, divCode);
					}
				}
			},
			Unilite.popup('PROJECT',{
				fieldLabel		: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>',
				valueFieldName	: 'PJT_CODE',
				textFieldName	: 'PJT_NAME',
				DBvalueFieldName: 'PJT_CODE',
				DBtextFieldName	: 'PJT_NAME',
				validateBlank	: false,
				textFieldOnly	: false,
				listeners: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('PJT_CODE', newValue);
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('PJT_NAME', newValue);
					}
				}
			}),{
				xtype		: 'radiogroup',
				fieldLabel	: '<t:message code="system.label.sales.status" default="상태"/>',
				id			: 'STATUS1',
				items		: [{
					boxLabel	: '<t:message code="system.label.sales.whole" default="전체"/>',
					name		: 'STATUS',
					inputValue	: '1',
					width		: 60,
					checked		: true
				},{
					boxLabel	: '<t:message code="system.label.sales.undelivery" default="미납"/>',
					name		: 'STATUS',
					inputValue	: '2',
					width		: 60
				},{
					boxLabel	: '<t:message code="system.label.sales.deliverycomplete" default="납품완료"/>',
					name		: 'STATUS',
					inputValue	: '3',
					width		: 80
				}],
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('STATUS', newValue.STATUS);
					}
				}
			}]
		},{
			title		: '<t:message code="system.label.sales.custominfo" default="거래처정보"/>',
			id			: 'search_panel2',
			itemId		: 'search_panel2',
			defaultType	: 'uniTextfield',
			layout		: {type: 'uniTable', columns: 1},
			items		: [
				Unilite.popup('AGENT_CUST', {
				fieldLabel		: '<t:message code="system.label.sales.custom" default="거래처"/>',
				valueFieldName	: 'CUSTOM_CODE',
				textFieldName	: 'CUSTOM_NAME',
				extParam		: {'CUSTOM_TYPE':['1','3']},
				validateBlank	: false,
				listeners: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('CUSTOM_CODE', newValue);
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('CUSTOM_NAME', newValue);
					},
					applyextparam: function(popup) {
						popup.setExtParam({'CUSTOM_TYPE':['1','3']});
					}
				}
			}),{
				fieldLabel	: '<t:message code="system.label.sales.customclass" default="거래처분류"/>',
				name		: 'AGENT_TYPE',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B055'
			},{
				fieldLabel	: '<t:message code="system.label.sales.area" default="지역"/>',
				name		: 'AREA_TYPE',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B056'
			}]
		},{
			title		: '<t:message code="system.label.sales.iteminfo" default="품목정보"/>',
			defaultType	: 'uniTextfield',
			id			: 'search_panel3',
			itemId		: 'search_panel3',
			layout		: {type: 'uniTable', columns: 1},
			items		: [
				Unilite.popup('DIV_PUMOK',{
				fieldLabel		: '<t:message code="system.label.sales.item" default="품목"/>',
				valueFieldName	: 'ITEM_CODE',
				textFieldName	: 'ITEM_NAME',
				validateBlank	: false,
				autoPopup		: false,
				listeners		: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('ITEM_CODE', newValue);
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('ITEM_NAME', newValue);
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
					}
				}
		   }),
				Unilite.popup('ITEM_GROUP',{
				fieldLabel		: '<t:message code="system.label.sales.repmodel" default="대표모델"/>',
				valueFieldName	: 'ITEM_GROUP',
				textFieldName	: 'ITEM_GROUP_NAME',
				validateBlank	: false,
				popupWidth		: 710,
				colspan			: 2
			}),{
				fieldLabel	: '<t:message code="system.label.sales.majorgroup" default="대분류"/>',
				name		: 'TXTLV_L1',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('itemLeve1Store'),
				child		: 'TXTLV_L2'
			},{
				fieldLabel	: '<t:message code="system.label.sales.middlegroup" default="중분류"/>',
				name		: 'TXTLV_L2',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('itemLeve2Store'),
				child		: 'TXTLV_L3'
			},{
				fieldLabel	: '<t:message code="system.label.sales.minorgroup" default="소분류"/>',
				name		: 'TXTLV_L3',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('itemLeve3Store'),
				parentNames	: ['TXTLV_L1','TXTLV_L2'],
				levelType	: 'ITEM'
			}]
		},{
			title		: '<t:message code="system.label.sales.soinfo" default="수주정보"/>',
			id			: 'search_panel4',
			itemId		: 'search_panel4',
			defaultType	: 'uniTextfield',
			layout		: {type: 'uniTable', columns: 1},
			items		: [{
			 	xtype		: 'container',
	   			defaultType	: 'uniNumberfield',
				layout		: {type: 'hbox', align:'stretch'},
				width		: 325,
				margin		: 0,
				items:[{
					fieldLabel	: '<t:message code="system.label.sales.soqty" default="수주량"/>',
					suffixTpl	: '&nbsp;~&nbsp;',
					name		: 'FR_ORDER_QTY',
					width		: 218
				},{
					name	: 'TO_ORDER_QTY',
					width	: 107
				}]
			},{
			 	xtype		: 'container',
	   			defaultType	: 'uniNumberfield',
				layout		: {type: 'hbox', align:'stretch'},
				width		: 325,
				margin		: 0,
				items		: [{
					fieldLabel	: '<t:message code="system.label.sales.sono" default="수주번호"/>',
					suffixTpl	: '&nbsp;~&nbsp;',
					name		: 'FR_ORDER_NUM',
					width		: 218
				},{
					name	: 'TO_ORDER_NUM',
					width	: 107
				}]
			},{
				fieldLabel	: '<t:message code="system.label.sales.creationpath" default="생성경로"/>',
				name		: 'TXT_CREATE_LOC',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	:'B031'
			},{
				xtype		: 'radiogroup',
				fieldLabel	: '<t:message code="system.label.sales.closingyn" default="마감여부"/>',
				id			: 'ORDER_STATUS',
				items		: [{
					boxLabel	: '<t:message code="system.label.sales.whole" default="전체"/>',
					name		: 'ORDER_STATUS',
					inputValue	: '%',
					width		: 50,
					checked		: true
				},{
					boxLabel	: '<t:message code="system.label.sales.closing" default="마감"/>',
					name		: 'ORDER_STATUS',
					inputValue	: 'Y',
					width		: 60
				},{
					boxLabel	: '미마감',
					name		: 'ORDER_STATUS',
					inputValue	: 'N',
					width		: 80
				}]
			},{
				fieldLabel	: '<t:message code="system.label.sales.status" default="상태"/>',
				xtype		: 'radiogroup',
				id			: 'rdoSelect2',
				items		: [{
					boxLabel	: '<t:message code="system.label.sales.whole" default="전체"/>',
					name		: 'rdoSelect2',
					inputValue	: 'A',
					width		: 50,
					checked		: true
				},{
					boxLabel	: '<t:message code="system.label.sales.unapproved" default="미승인"/>',
					name		: 'rdoSelect2',
					inputValue	: 'N',
					width		: 60
				},{
					boxLabel	: '<t:message code="system.label.sales.approved" default="승인"/>',
					name		: 'rdoSelect2',
					inputValue	: '6',
					width		: 50
				},{
					boxLabel	: '<t:message code="system.label.sales.giveback" default="반려"/>',
					name		: 'rdoSelect2',
					inputValue	: '5',
					width		: 50
				}]
			}]
		},{
			title		: '<t:message code="system.label.sales.etc" default="기타"/>',
			id			: 'search_panel5',
			itemId		: 'search_panel5',
			defaultType	: 'uniNumberfield',
			layout		: {type: 'uniTable', columns: 1},
			items		: [{
				fieldLabel	: '<t:message code="system.label.sales.exchangecurrency" default="환산 화폐"/>',
				name		: 'EXCHG_MONEY_UNIT', 	
				xtype		: 'uniCombobox', 
				comboType	: 'AU',
				comboCode	: 'B004',
				displayField: 'value',
				fieldStyle	: 'text-align: center;',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						if(!gsInitFlag) {
							UniAppManager.app.fnExchngRateO();
						}
						gsInitFlag = false;
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.sales.exchangerate" default="환율"/>',
				name		: 'EXCHANGE_RATE',
				type		: 'uniER'/*,
				readOnly	: true*/,
				listeners: {
					blur : function (e, event, eOpts) {
						if(panelSearch.getValue('EXCHANGE_RATE') != 0) {
							panelSearch.down('#conversionApplied').enable();
						} else {
							panelSearch.down('#conversionApplied').disable();
						}
					}
				}
			},{
				xtype	: 'button',
				text	: '<t:message code="system.label.sales.conversionapplied" default="환산적용"/>',
				id		: 'conversionApplied',
				itemId	: 'conversionApplied',
				margin	: '0 0 0 120',
				handler	: function() {
//					Ext.getCmp('sof102skrvApp').mask('<t:message code="system.label.sales.loading" default="로딩중..."/>','loading-indicator');
					var records			= directMasterStore1.data.items;
					var exchgMoneyUnit	= panelSearch.getValue('EXCHG_MONEY_UNIT');
					var exchgRate		= panelSearch.getValue('EXCHANGE_RATE');
					Ext.each(records, function(record,i) {
						var oriExchgRate= record.get('ORI_EXCHG_RATE');
						var orderO		= record.get('ORDER_O');
						var orderRemO	= record.get('ORDER_REM_O');
						var salesAmt	= record.get('SALES_AMT');
						
						record.set('EXCHG_MONEY_UNIT'	, exchgMoneyUnit);
						record.set('EXCHG_ORDER_O'		, Unilite.multiply(orderO	, oriExchgRate) / exchgRate);
						record.set('EXCHG_ORDER_REM_O'	, Unilite.multiply(orderRemO, oriExchgRate) / exchgRate);
						record.set('EXCHG_SALES_AMT'	, Unilite.multiply(salesAmt	, oriExchgRate) / exchgRate);
						
//						if(records.length == i+1) {
//							Ext.getCmp('sof102skrvApp').unmask();
//						}
					});
					directMasterStore1.commitChanges();
				}
			}]
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
						var labelText = invalid.items[0]['fieldLabel']+' : ';
					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
						var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
					}

					Unilite.messageBox(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
					invalid.items[0].focus();
				}
			}
			return r;
		}
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 3},
		padding	: '1 1 1 1',
		border	: true,
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		items	: [{
				fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				allowBlank	: false,
				value		: UserInfo.divCode,
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
						combo.changeDivCode(combo, newValue, oldValue, eOpts);
						var field = panelSearch.getField('ORDER_PRSN');
						field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult의 필터링 처리 위해..
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel		: '<t:message code="system.label.sales.sodate" default="수주일"/>',
				startFieldName	: 'ORDER_DATE_FR',
				endFieldName	: 'ORDER_DATE_TO',
				xtype			: 'uniDateRangefield',
				startDate		: UniDate.get('startOfMonth'),
				endDate			: UniDate.get('today'),
				width			: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelSearch) {
						panelSearch.setValue('ORDER_DATE_FR',newValue);
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelSearch) {
						panelSearch.setValue('ORDER_DATE_TO',newValue);
					}
				}
			},{
				fieldLabel		: '<t:message code="system.label.sales.deliverydate" default="납기일"/>',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'DVRY_DATE_FR',
				endFieldName	: 'DVRY_DATE_TO',
				width			: 315,
				colspan			: 2,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelSearch) {
						panelSearch.setValue('DVRY_DATE_FR',newValue);
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelSearch) {
						panelSearch.setValue('DVRY_DATE_TO',newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>',
				name		: 'ORDER_TYPE',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'S002',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('ORDER_TYPE', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.sales.salescharge" default="영업담당"/>',
				name		: 'ORDER_PRSN',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'S010',
				multiSelect	: true,
				typeAhead	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('ORDER_PRSN', newValue);
					}
				},
				onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
					if(eOpts){
						combo.filterByRefCode('refCode1', newValue, eOpts.parent);
					}else{
						combo.divFilterByRefCode('refCode1', newValue, divCode);
					}
				}
			},
			Unilite.popup('PROJECT',{
				fieldLabel		: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>',
				valueFieldName	: 'PJT_CODE',
				textFieldName	: 'PJT_NAME',
				DBvalueFieldName: 'PJT_CODE',
				DBtextFieldName	: 'PJT_NAME',
				validateBlank	: false,
				textFieldOnly	: false,
				listeners: {
					onValueFieldChange: function(field, newValue){
						panelSearch.setValue('PJT_CODE', newValue);
					},
					onTextFieldChange: function(field, newValue){
						panelSearch.setValue('PJT_NAME', newValue);
					}
				}
			}),
			Unilite.popup('AGENT_CUST', {
				fieldLabel		: '<t:message code="system.label.sales.custom" default="거래처"/>',
				extParam		: {'CUSTOM_TYPE':'3'},
				valueFieldName	: 'CUSTOM_CODE',
				textFieldName	: 'CUSTOM_NAME',
				autoPopup		: true,
				validateBlank	: false,
				listeners		: {
					onValueFieldChange: function(field, newValue){
						panelSearch.setValue('CUSTOM_CODE', newValue);
					},
					onTextFieldChange: function(field, newValue){
						panelSearch.setValue('CUSTOM_NAME', newValue);
					},
					applyextparam: function(popup) {
						popup.setExtParam({'CUSTOM_TYPE':'3'});
					}
				}
			}),
			Unilite.popup('DIV_PUMOK',{
				fieldLabel		: '<t:message code="system.label.sales.item" default="품목"/>',
				valueFieldName	: 'ITEM_CODE',
				textFieldName	: 'ITEM_NAME',
				validateBlank	: false,
				autoPopup		: false,
				listeners		: {
					onValueFieldChange: function(field, newValue){
						panelSearch.setValue('ITEM_CODE', newValue);
					},
					onTextFieldChange: function(field, newValue){
						panelSearch.setValue('ITEM_NAME', newValue);
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
					}
				}
			}),{
				xtype		: 'radiogroup',
				fieldLabel	: '<t:message code="system.label.sales.status" default="상태"/>',
				id			: 'STATUS2',
				items		: [{
					boxLabel	: '<t:message code="system.label.sales.whole" default="전체"/>',
					name		: 'STATUS',
					inputValue	: '1',
					width		: 60,
					checked		: true
				},{
					boxLabel	: '<t:message code="system.label.sales.undelivery" default="미납"/>',
					name		: 'STATUS',
					inputValue	: '2',
					width		: 60
				},{
					boxLabel	: '<t:message code="system.label.sales.deliverycomplete" default="납품완료"/>',
					name		: 'STATUS',
					inputValue	: '3',
					width		: 80
				}],
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('STATUS', newValue.STATUS);
					}
				}
			}
		]
	});



	/** Master Grid1 정의(Grid Panel),
	 * @type
	 */
	var masterGrid = Unilite.createGrid('sof102skrvGrid1', {
		store	: directMasterStore1,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			useGroupSummary		: false,
			useLiveSearch		: true,
			useContextMenu		: true,
			useMultipleSorting	: true,
			useRowNumberer		: false,
			expandLastColumn	: false,
			filter				: {
				useFilter	: false,
				autoCreate	: false
			},
			excel: {
				useExcel		: true,			//엑셀 다운로드 사용 여부
				exportGroup		: true, 		//group 상태로 export 여부
				onlyData		: false,
				summaryExport	: true
			}
		},
		tbar	: [{
			fieldLabel		: '<t:message code="system.label.sales.selectionsummary" default="선택된 데이터 합계"/>',
			xtype			: 'uniNumberfield',
			itemId			: 'selectionSummary',
			format			: '0,000.0000',
			decimalPrecision: 4,
			value			: 0,
			labelWidth		: 110,
			readOnly		: true
		}],
		features: [ {id : 'masterGridSubTotal',	ftype: 'uniGroupingsummary',showSummaryRow: true},
					{id : 'masterGridTotal',	ftype: 'uniSummary',		showSummaryRow: true} ],

		columns: [
			{dataIndex: 'CUSTOM_CODE1'		, width: 100, hidden: false},
			{dataIndex: 'CUSTOM_NAME1'		, width: 200, hidden: false},
			{dataIndex: 'ITEM_CODE'			, width: 100, locked: false},
			{dataIndex: 'ITEM_NAME'			, width: 200, locked: false},
			{dataIndex: 'SPEC'				, width: 150, locked: false},
			{dataIndex: 'ORDER_UNIT'		, width: 53, locked: false, align: 'center'},
//			{dataIndex: 'PRICE_TYPE'		, width: 80, hidden: true},
			{dataIndex: 'TRANS_RATE'		, width: 60, align: 'right',
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.sales.subtotal" default="소계"/>', '<t:message code="system.label.sales.total" default="총계"/>');
				}
			},
			{dataIndex: 'ORDER_UNIT_Q'		, width: 106, summaryType: 'sum'},

			//20180822 조회쿼리에 없어서 주석처리
//			{dataIndex: 'ORDER_WGT_Q'		, width: 106, hidden: true},
//			{dataIndex: 'ORDER_VOL_Q'		, width: 106, hidden: true},
			//여기까지
			
			{dataIndex: 'STOCK_UNIT'		, width: 53, hidden: true},
			{dataIndex: 'STOCK_Q'			, width: 106,hidden: true},
			{dataIndex: 'MONEY_UNIT'		, width: 53, align: 'center'},
			{dataIndex: 'ORDER_P'			, width: 106},

			//20180822 조회쿼리에 없어서 주석처리
//			{dataIndex: 'ORDER_WGT_P'		, width: 106, hidden: true},
//			{dataIndex: 'ORDER_VOL_P'		, width: 106, hidden: true},
			//여기까지
			
			{dataIndex: 'ORDER_O'			, width: 120, summaryType: 'sum'},
			{dataIndex: 'OUTSTOCK_Q'		, width: 106, summaryType: 'sum'},
			{dataIndex: 'ORDER_REM_Q'		, width: 106, summaryType: 'sum'},
			{dataIndex: 'ORDER_REM_O'		, width: 120, summaryType: 'sum'},

			//20180822 조회쿼리에 없어서 주석처리
//			{dataIndex: 'EXCHG_RATE_O'		, width: 66, align: 'right'},
//			{dataIndex: 'SO_AMT_WON'		, width: 120, summaryType: 'sum'},
//			{dataIndex: 'TAX_TYPE'			, width: 80, align: 'center'},
//			{dataIndex: 'ORDER_TAX_O'		, width: 100, summaryType: 'sum'},
//			{dataIndex: 'WGT_UNIT'			, width: 66, hidden: true},
//			{dataIndex: 'UNIT_WGT'			, width: 80, hidden: true},
//			{dataIndex: 'VOL_UNIT'			, width: 66, hidden: true},
//			{dataIndex: 'UNIT_VOL'			, width: 80, hidden: true},
//			{dataIndex: 'CUSTOM_CODE2'		, width: 80},
//			{dataIndex: 'CUSTOM_NAME2'		, width: 133},
//			{dataIndex: 'ORDER_DATE'		, width: 93},
			//여기까지
			
			{dataIndex: 'ORDER_TYPE'		, width: 100},

			//20180822 조회쿼리에 없어서 주석처리
//			{dataIndex: 'ORDER_TYPE_NM'		, width: 133, hidden: true},
//			{dataIndex: 'ORDER_NUM'			, width: 110},
//			{dataIndex: 'SER_NO'			, width: 53, align:'center'},
			//여기까지
			
			{dataIndex: 'ORDER_PRSN'		, width: 66},
//			{dataIndex: 'ORDER_PRSN_NM'		, width:133, hidden: true},

			//20180822 조회쿼리에 없어서 주석처리
//			{dataIndex: 'PROJECT_NO'		, width:100},
//			{dataIndex: 'PROJECT_NAME'		, width:150},
//			{dataIndex: 'PO_NUM'			, width:86},
//			{dataIndex: 'DVRY_DATE2'		, width:93},
//			{dataIndex: 'DVRY_TIME'			, width:66, hidden: true},
//			{dataIndex: 'DVRY_CUST_NM'		, width:100},
//			{dataIndex: 'PROD_END_DATE'		, width:106, hidden: true},
//			{dataIndex: 'PROD_Q'			, width:90, hidden: true},
			//여기까지

			{dataIndex: 'ORDER_STATUS'		, width:90},

			//20180822 조회쿼리에 없어서 주석처리
//			{dataIndex: 'SORT_KEY'			, width:106, hidden: true},
//			{dataIndex: 'CREATE_LOC'		, width:106, hidden: true},
//			{dataIndex: 'REMARK'			, width:200}
			//여기까지
			
			//20180822 추가
			{dataIndex: 'SALES_QTY'			, width: 106, summaryType: 'sum'},
			{dataIndex: 'SALES_AMT'			, width: 120, summaryType: 'sum'},
			{dataIndex: 'PUB_QTY'			, width: 106, summaryType: 'sum'},
			{dataIndex: 'PUB_AMT'			, width: 120, summaryType: 'sum'},
			//여기까지
			
			//20181101 추가
			{dataIndex: 'EXCHG_MONEY_UNIT'	, width: 80},
			{dataIndex: 'ORI_EXCHG_RATE'	, width: 120, hidden: true},
			{dataIndex: 'EXCHG_ORDER_O'		, width: 120, summaryType: 'sum'},
			{dataIndex: 'EXCHG_ORDER_REM_O'	, width: 120, summaryType: 'sum'},
			{dataIndex: 'EXCHG_SALES_AMT'	, width: 120, summaryType: 'sum'}
			//여기까지
		],
		listeners:{
			selectionchange:function( grid, selection, eOpts )	{
				if(selection && selection.startCell)	{
					var columnName = selection.startCell.column.dataIndex;
					var displayField= Ext.getCmp("selectionSummary");
					if(selection.startCell.column.xtype == 'uniNnumberColumn' && selection.startCell.column.dataIndex == selection.endCell.column.dataIndex)	{
						var startIdx = selection.startCell.rowIdx, endIdx = selection.endCell.rowIdx;
						var store = grid.store;
						var sum = 0;

						for(var i=startIdx; i <= endIdx; i++){
							var record = store.getAt(i);
							sum += record.get(columnName);
						}
						this.down('#selectionSummary').setValue(sum);
						
					} else {
						this.down('#selectionSummary').setValue(0);
					}
				}
			}
		}
	});

	Unilite.Main({
		id			: 'sof102skrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				masterGrid, panelResult
			]
		},
			panelSearch
		],
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('ORDER_DATE_TO', UniDate.get('today'));
			panelSearch.setValue('ORDER_DATE_FR', UniDate.get('startOfMonth', panelSearch.getValue('ORDER_DATE_TO')));

			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('ORDER_DATE_TO', UniDate.get('today'));
			panelResult.setValue('ORDER_DATE_FR', UniDate.get('startOfMonth', panelSearch.getValue('ORDER_DATE_TO')));

//			panelSearch.getField('ORDER_STATUS').setValue('%');
//			panelSearch.getField('rdoSelect2').setValue('A');
			
			
			gsInitFlag = true;
			panelSearch.setValue('EXCHG_MONEY_UNIT'	, gsMoneyUnitRef4);
			panelSearch.setValue('EXCHANGE_RATE'	, gsExchangeRate);
			if(gsMoneyUnitRef4 != BsaCodeInfo.gsMoneyUnit && gsExchangeRate == '1.0000') {
				panelSearch.down('#conversionApplied').disable();
			}
			
			var pCombo	= panelSearch.getField('DIV_CODE');
			var combo 	= panelSearch.getField('ORDER_PRSN').filterByRefCode('refCode1', pCombo.getValue(), pCombo);

			var field = panelSearch.getField('ORDER_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
			var field = panelResult.getField('ORDER_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
		},
		onQueryButtonDown: function()	{
			if(!panelSearch.setAllFieldsReadOnly(true)){
				return false;
			}
			//masterGrid.reset();
			masterGrid.getStore().loadStoreRecords();
			//var viewLocked = masterGrid.lockedGrid.getView();
			//var viewNormal = masterGrid.getView();
			//console.log("viewLocked : ",viewLocked);
			//console.log("viewNormal : ",viewNormal);
			//viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			//viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
			//viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			//viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({})
			this.fnInitBinding();
		},
		fnExchngRateO:function(isIni) {
			var param = {
				"AC_DATE"	: UniDate.getDbDateStr(new Date()),
				"MONEY_UNIT": panelSearch.getValue('EXCHG_MONEY_UNIT')
			};
			salesCommonService.fnExchgRateO(param, function(provider, response) {
				if(!Ext.isEmpty(provider)){
					if(provider.BASE_EXCHG == "1" && !isIni && !Ext.isEmpty(panelSearch.getValue('EXCHG_MONEY_UNIT')) && panelSearch.getValue('EXCHG_MONEY_UNIT') != BsaCodeInfo.gsMoneyUnit){
						panelSearch.down('#conversionApplied').disable();
						Unilite.messageBox('<t:message code="system.message.sales.datacheck008" default="환율정보가 없습니다."/>');
					} else {
						panelSearch.down('#conversionApplied').enable();
					}
					panelSearch.setValue('EXCHANGE_RATE', provider.BASE_EXCHG);
				}
			});
		}
	});
};
</script>
