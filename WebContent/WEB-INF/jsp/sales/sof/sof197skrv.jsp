<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="sof197skrv"  >

	<t:ExtComboStore comboType="BOR120" pgmId="sof197skrv" /> 					<!-- 사업장 -->  
	<t:ExtComboStore comboType="AU" comboCode="B083"  /> 		<!-- BOM PATH 정보 -->  
	<t:ExtComboStore comboType="AU" comboCode="A020"  /> 		<!-- 예/아니오 --> 
	<t:ExtComboStore comboType="AU" comboCode="S010"  /> 
	
	<t:ExtComboStore comboType="AU" comboCode="B018"  /> 
	<t:ExtComboStore comboType="AU" comboCode="B059"  /> 
	<t:ExtComboStore comboType="AU" comboCode="S002"  /> 
	<t:ExtComboStore comboType="AU" comboCode="S011"  /> 
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	


<script type="text/javascript" >


var BsaCodeInfo = {
	gsMoneyUnit: 'KRW'
};
var gsInitFlag;
var gsMoneyUnitRef4	= Ext.isEmpty('${gsMoneyUnitRef4}') ? BsaCodeInfo.gsMoneyUnit	: '${gsMoneyUnitRef4}';;
var gsExchangeRate	= '${gsExchangeRate}';
if(Ext.isEmpty(gsExchangeRate) || gsExchangeRate == '0.0000') {
	gsExchangeRate = '1.0000';
}
var loadData=[{}];
var win2;
function appMain() {
/* type:
 *	  uniQty		 -	  수량
 *	  uniUnitPrice   -	  단가
 *	  uniPrice	   -	  금액(자사화폐)
 *	  uniPercent	 -	  백분율(00.00)
 *	  uniFC		  -	  금액(외화화폐)
 *	  uniER		  -	  환율
 *	  uniDate		-	  날짜(2999.12.31)
 * maxLength: 입력가능한 최대 길이
 * editable: true   수정가능 여부
 * allowBlank: 필수 여부
 * defaultValue: 기본값
 * comboType:'AU', comboCode:'B014' : 그리드 콤보 사용시
 */

	// GroupField string type으로 변환
	function dateToString(v, record){
		return UniDate.safeFormat(v);
	}
 
	Unilite.defineModel('Sof100skrvModel', {
		fields: [
			//20190513 추가: OUT_DIV_CODE
			{name: 'OUT_DIV_CODE'		,text: '<t:message code="system.label.sales.issuedivision" default="출고사업장"/>'					,type: 'string',comboType: 'BOR120'},
			{name: 'DVRY_DATE1'			,text:'<t:message code="system.label.sales.deliverydate" default="납기일"/>'						,type:'uniDate',convert:dateToString},
			{name: 'DVRY_TIME1'			,text:'<t:message code="system.label.sales.deliverytime" default="납기시간"/>'						,type:'string'},
			{name: 'ITEM_CODE'			,text:'<t:message code="system.label.sales.item" default="품목"/>'								,type:'string'},
			{name: 'ITEM_NAME'			,text:'<t:message code="system.label.sales.itemname" default="품목명"/>'							,type:'string'},
			{name: 'ITEM_NAME1'			,text:'<t:message code="system.label.sales.itemname" default="품목명"/>1'							,type:'string'},
			{name: 'CUSTOM_CODE1'		,text:'<t:message code="system.label.sales.custom" default="거래처"/>'								,type:'string'},
			{name: 'CUSTOM_NAME1'		,text:'<t:message code="system.label.sales.customname" default="거래처명"/>'						,type:'string'},
			{name: 'SPEC'				,text:'<t:message code="system.label.sales.spec" default="규격"/>'								,type:'string'},
			//20191008 추가
			{name: 'PURCHASE_YN'		,text:'<t:message code="system.label.sales.purchaserequest" default="구매요청"/>'					,type:'string',comboType:'AU', comboCode:'B018'},
			{name: 'ORDER_UNIT'			,text:'<t:message code="system.label.sales.unit" default="단위"/>'								,type:'string', displayField: 'value'},
			{name: 'PRICE_TYPE'			,text:'<t:message code="system.label.sales.priceclass" default="단가구분"/>'						,type:'string'},
			{name: 'TRANS_RATE'			,text:'<t:message code="system.label.sales.containedqty" default="입수"/>'						,type:'string'},
			{name: 'ORDER_UNIT_Q'		,text:'<t:message code="system.label.sales.soqty" default="수주량"/>'								,type:'uniQty'},
			{name: 'ORDER_WGT_Q'		,text:'<t:message code="system.label.sales.soqtyweight" default="수주량(중량)"/>'					,type:'uniQty'},
			{name: 'ORDER_VOL_Q'		,text:'<t:message code="system.label.sales.soqtyvolumn" default="수주량(부피)"/>'					,type:'uniQty'},
			{name: 'STOCK_UNIT'			,text:'<t:message code="system.label.sales.inventoryunit" default="재고단위"/>'						,type:'string', displayField: 'value'},
			{name: 'STOCK_Q'			,text:'<t:message code="system.label.sales.inventoryunitsoqty" default="재고단위수주량"/>'				,type:'uniQty'},
			{name: 'MONEY_UNIT'			,text:'<t:message code="system.label.sales.currency" default="화폐"/>'							,type:'string'},
			{name: 'ORDER_P'			,text:'<t:message code="system.label.sales.price" default="단가"/>'								,type:'uniUnitPrice'},
			{name: 'ORDER_WGT_P'		,text:'<t:message code="system.label.sales.priceweight" default="단가(중량)"/>'						,type:'uniUnitPrice'},
			{name: 'ORDER_VOL_P'		,text:'<t:message code="system.label.sales.pricevolumn" default="단가(부피)"/>'						,type:'uniUnitPrice'},
			{name: 'ORDER_O'			,text:'<t:message code="system.label.sales.soamount" default="수주액"/>'							,type:'uniFC'},
			{name: 'EXCHG_RATE_O'		,text:'<t:message code="system.label.sales.exchangerate" default="환율"/>'						,type:'uniER'},
			//20181116 컬럼명 / type 변경 (환산액 -> 수주액(자사), uniPrice -> uniFC)
			{name: 'SO_AMT_WON'			,text:'<t:message code="system.label.sales.cosoamount" default="수주액(자사)"/>'						,type:'uniPrice'},
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
			{name: 'SORT_KEY'			,text:'SORTKEY'		,type:'string'},
			{name: 'CREATE_LOC'			,text:'CREATE_LOC'	,type:'string'},

			{name: 'LOT_NO'				,text:'LOT NO'		,type:'string'},
			{name: 'PROD_END_DATE'		,text:'생산완료 예정일'	,type:'uniDate'},
			//20181116 추가
			{name: 'EXCHG_MONEY_UNIT'	,text:'<t:message code="system.label.sales.currencyexchanged" default="화폐(환산)"/>'				,type:'string'},
			{name: 'EXCHG_ORDER_O'		,text:'<t:message code="system.label.sales.soamountexchanged" default="수주액(환산)"/>'				,type:'uniFC'},
			{name: 'ORI_EXCHG_RATE'		,text:'ORI_EXCHG_RATE'	,type:'uniER'},
			//20190725 고객명(RECEIVER_NAME), 송장번호(INVOICE_NUM), 등록자, 수정자 추가
			{name: 'RECEIVER_NAME'		, text: '<t:message code="system.label.sales.clientname" default="고객명"/>'						, type: 'string'},
			{name: 'INVOICE_NUM'		, text: '<t:message code="system.label.sales.invoice" default="송장번호"/>'							, type: 'string'},
			{name: 'INSERT_DB_USER'		, text: '<t:message code="system.label.sales.entryuser" default="등록자"/>'						, type: 'string'},
			{name: 'UPDATE_DB_USER'		, text: '<t:message code="system.label.sales.updateuser" default="수정자"/>'						, type: 'string'}
		]
	});


	
	
	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('sof100skrvMasterStore1', {
		model	: 'Sof100skrvModel',
		uniOpt	: {
			isMaster	: true,		// 상위 버튼,상태바 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api: {
				read: 'sof100skrvService.selectList1'
			}
		},
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
			this.load({
				params: param,
				callback:function(responseText, arg)	{
					/* var pivotComp2 = Ext.getCmp( masterGrid.getId()+'Pivot2');
					 pivotComp2.onLoadRender();
					 var pivotComp3 = Ext.getCmp( masterGrid.getId()+'Pivot3');
					 pivotComp3.onLoadRender(); */
				}
			});
		},
		listeners:{
			load:function( store, records, successful, operation, eOpts ) {
				
			}
		}
//		groupField: 'ITEM_CODE'
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
			expand: function() {
				panelResult.hide();
			}
		},
		items: [{
			title: '<t:message code="system.label.sales.basisinfo" default="기본정보"/>',
			itemId: 'search_panel1',
			layout: {type: 'uniTable', columns: 1},
			defaultType: 'uniTextfield',
			items: [{
				fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank: false,
				value: UserInfo.divCode,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						combo.changeDivCode(combo, newValue, oldValue, eOpts);
						var field = panelResult.getField('ORDER_PRSN');
						field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult의 필터링 처리 위해..
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.sales.sodate" default="수주일"/>',
				startFieldName: 'ORDER_DATE_FR',
				endFieldName: 'ORDER_DATE_TO',
				xtype: 'uniDateRangefield',
				width: 315,
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
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
				fieldLabel: '<t:message code="system.label.sales.deliverydate" default="납기일"/>',
			 	xtype: 'uniDateRangefield',
			 	startFieldName: 'DVRY_DATE_FR',
			 	endFieldName: 'DVRY_DATE_TO',
			 	width: 315,
			 	colspan: 2,
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
				fieldLabel	: '<t:message code="system.label.sales.itemaccount" default="품목계정"/>',
				name		: 'ITEM_ACCOUNT',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B020',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ITEM_ACCOUNT', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>',
				name:'ORDER_TYPE',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'S002',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ORDER_TYPE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.sales.salescharge" default="영업담당"/>',
				name:'ORDER_PRSN',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'S010',
				multiSelect: true,
				typeAhead: false,
				listeners: {
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
				fieldLabel: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>',
				valueFieldName:'PJT_CODE',
				textFieldName:'PJT_NAME',
				DBvalueFieldName: 'PJT_CODE',
				DBtextFieldName: 'PJT_NAME',
				validateBlank: false,
//				allowBlank:false,
				textFieldOnly: false,
				listeners: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('PJT_CODE', newValue);
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('PJT_NAME', newValue);
					}
				}
			}),{
				fieldLabel	: '<t:message code="system.label.sales.issuedivision" default="출고사업장"/>',
				name		: 'OUT_DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelResult.setValue('OUT_DIV_CODE', newValue);
					}
				}
			}]
		},{
			title:'<t:message code="system.label.sales.custominfo" default="거래처정보"/>',
			id: 'search_panel2',
			itemId:'search_panel2',
			defaultType: 'uniTextfield',
			layout: {type: 'uniTable', columns: 1},
			items:[
				Unilite.popup('AGENT_CUST', {
				fieldLabel: '<t:message code="system.label.sales.custom" default="거래처"/>',
				valueFieldName: 'CUSTOM_CODE',
				textFieldName: 'CUSTOM_NAME',
				extParam: {'CUSTOM_TYPE':['1','3']},
				validateBlank: false,
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
				fieldLabel: '<t:message code="system.label.sales.customclass" default="거래처분류"/>',
				name:'AGENT_TYPE',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'B055'
			},{
				fieldLabel: '<t:message code="system.label.sales.area" default="지역"/>',
				name:'AREA_TYPE',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'B056'
			}]
		},{
			title:'<t:message code="system.label.sales.iteminfo" default="품목정보"/>',
			defaultType: 'uniTextfield',
			id: 'search_panel3',
			itemId:'search_panel3',
			layout: {type: 'uniTable', columns: 1},
			items:[
				 Unilite.popup('DIV_PUMOK',{
				fieldLabel: '<t:message code="system.label.sales.item" default="품목"/>',
				valueFieldName: 'ITEM_CODE',
				textFieldName: 'ITEM_NAME',
				validateBlank: false,
				autoPopup:false,
				listeners: {
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
				fieldLabel: '<t:message code="system.label.sales.repmodel" default="대표모델"/>',
				valueFieldName: 'ITEM_GROUP',
				textFieldName: 'ITEM_GROUP_NAME',
				validateBlank:false,
				popupWidth: 710,
				colspan: 2
			}),{
				fieldLabel: '<t:message code="system.label.sales.majorgroup" default="대분류"/>',
				name: 'TXTLV_L1',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('itemLeve1Store'),
				child: 'TXTLV_L2'
			},{
				fieldLabel: '<t:message code="system.label.sales.middlegroup" default="중분류"/>',
				name: 'TXTLV_L2',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('itemLeve2Store'),
				child: 'TXTLV_L3'
			},{
				fieldLabel: '<t:message code="system.label.sales.minorgroup" default="소분류"/>',
				name: 'TXTLV_L3',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('itemLeve3Store'),
				parentNames:['TXTLV_L1','TXTLV_L2'],
				levelType:'ITEM'
			}]
		},{
			title:'<t:message code="system.label.sales.soinfo" default="수주정보"/>',
			id: 'search_panel4',
			itemId:'search_panel4',
			defaultType: 'uniTextfield',
			layout: {type: 'uniTable', columns: 1},
			items:[{
			 	xtype: 'container',
				defaultType: 'uniNumberfield',
				layout: {type: 'hbox', align:'stretch'},
				width:325,
				margin:0,
				items:[{
					fieldLabel:'<t:message code="system.label.sales.soqty" default="수주량"/>',
					suffixTpl:'&nbsp;~&nbsp;',
					name: 'FR_ORDER_QTY',
					width:218
				},{
					name: 'TO_ORDER_QTY',
					width:107
				}]
			},{
			 	xtype: 'container',
				defaultType: 'uniTextfield',
				layout: {type: 'hbox', align:'stretch'},
				width:325,
				margin:0,
				items:[{
					fieldLabel:'<t:message code="system.label.sales.sono" default="수주번호"/>',
					suffixTpl:'&nbsp;~&nbsp;',
					name: 'FR_ORDER_NUM',
					width:218
				},{
					name: 'TO_ORDER_NUM',
					width:107
				}]
			},{
				fieldLabel: '<t:message code="system.label.sales.creationpath" default="생성경로"/>',
				name:'TXT_CREATE_LOC',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'B031'
			},{
				xtype: 'radiogroup',
				fieldLabel: '<t:message code="system.label.sales.closingyn" default="마감여부"/>',
				id: 'ORDER_STATUS',
//				name: 'ORDER_STATUS',
				items: [{
					boxLabel: '<t:message code="system.label.sales.whole" default="전체"/>',
					width: 50,
					name: 'ORDER_STATUS',
					inputValue: '%',
					checked: true
				},{
					boxLabel: '<t:message code="system.label.sales.closing" default="마감"/>',
					width: 60, name: 'ORDER_STATUS',
					inputValue: 'Y'
				},{
					boxLabel: '<t:message code="system.label.sales.noclosing" default="미마감"/>',
					width: 80, name: 'ORDER_STATUS',
					inputValue: 'N'
				}]
			},{
				fieldLabel: '<t:message code="system.label.sales.status" default="상태"/>',
				xtype: 'radiogroup',
				id: 'rdoSelect2',
//				name: 'rdoSelect2',
				items: [{
					boxLabel: '<t:message code="system.label.sales.whole" default="전체"/>',
					width: 50,
					name: 'rdoSelect2',
					inputValue: 'A',
					checked: true
				},{
					boxLabel: '<t:message code="system.label.sales.unapproved" default="미승인"/>',
					width: 60, name: 'rdoSelect2',
					inputValue: 'N'
				},{
					boxLabel: '<t:message code="system.label.sales.approved" default="승인"/>',
					width: 50, name: 'rdoSelect2',
					inputValue: '6'
				},{
					boxLabel: '<t:message code="system.label.sales.giveback" default="반려"/>',
					width: 50, name: 'rdoSelect2',
					inputValue: '5'
				}]
			},{
				fieldLabel: '<t:message code="system.label.sales.remarks" default="비고"/>',
				xtype: 'uniTextfield',
				name:'REMARK'
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

						record.set('EXCHG_MONEY_UNIT'	, exchgMoneyUnit);
						record.set('EXCHG_ORDER_O'		, Unilite.multiply(orderO	, oriExchgRate) / exchgRate);
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
		region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
				fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank: false,
				value: UserInfo.divCode,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						combo.changeDivCode(combo, newValue, oldValue, eOpts);
						var field = panelSearch.getField('ORDER_PRSN');
						field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult의 필터링 처리 위해..
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.sales.sodate" default="수주일"/>',
				startFieldName: 'ORDER_DATE_FR',
				endFieldName: 'ORDER_DATE_TO',
				xtype: 'uniDateRangefield',
				width: 315,
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelSearch) {
						panelSearch.setValue('ORDER_DATE_FR',newValue);
						//panelSearch.getField('ISSUE_REQ_DATE_FR').validate();
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelSearch) {
						panelSearch.setValue('ORDER_DATE_TO',newValue);
						//panelSearch.getField('ISSUE_REQ_DATE_TO').validate();

					}
				}
			},{
				fieldLabel: '<t:message code="system.label.sales.deliverydate" default="납기일"/>',
			 	xtype: 'uniDateRangefield',
			 	startFieldName: 'DVRY_DATE_FR',
			 	endFieldName: 'DVRY_DATE_TO',
			 	width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelSearch) {
						panelSearch.setValue('DVRY_DATE_FR',newValue);
						//panelSearch.getField('ISSUE_REQ_DATE_FR').validate();
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelSearch) {
						panelSearch.setValue('DVRY_DATE_TO',newValue);
						//panelSearch.getField('ISSUE_REQ_DATE_TO').validate();

					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.sales.itemaccount" default="품목계정"/>',
				name		: 'ITEM_ACCOUNT',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B020',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('ITEM_ACCOUNT', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>',
				name:'ORDER_TYPE',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'S002',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('ORDER_TYPE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.sales.salescharge" default="영업담당"/>',
				name:'ORDER_PRSN',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'S010',
				multiSelect: true,
				typeAhead: false,
				listeners: {
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
				fieldLabel: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>',
				valueFieldName:'PJT_CODE',
				textFieldName:'PJT_NAME',
				DBvalueFieldName: 'PJT_CODE',
				DBtextFieldName: 'PJT_NAME',
				validateBlank: false,
//				allowBlank:false,
				textFieldOnly: false,
				autoPopup: true,
				colspan		: 2,
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
				fieldLabel: '<t:message code="system.label.sales.custom" default="거래처"/>',
				extParam: {'CUSTOM_TYPE':'3'},
				valueFieldName: 'CUSTOM_CODE',
				textFieldName: 'CUSTOM_NAME',
				autoPopup: true,
				validateBlank: false,
				listeners: {
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
				fieldLabel: '<t:message code="system.label.sales.item" default="품목"/>',
				valueFieldName: 'ITEM_CODE',
				textFieldName: 'ITEM_NAME',
				validateBlank: false,
				autoPopup:true,
				listeners: {
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
				fieldLabel	: '<t:message code="system.label.sales.issuedivision" default="출고사업장"/>',
				name		: 'OUT_DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelSearch.setValue('OUT_DIV_CODE', newValue);
					}
				}
			}
		]
	});

	
	Unilite.Main({
		id			: 'sof197skrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				//masterGrid,
				panelResult,
				{	xtype :'panel',
		    		height 	: 400,
		    		region	: 'center',
		    		title 	: '현황분석',
		    		collapsible : true,
		    		collapseDirection : 'top',
		    		scrollable : true,
		    		
		    		items :[
		    		{
			    		xtype 	: 'UniPivotComponent',
			    		id    	:  'sof100skrvGrid1Pivot2',
			    		initFields : [
			    			{name: 'OUT_DIV_CODE'		,text: '<t:message code="system.label.sales.issuedivision" default="출고사업장"/>'	,type: 'string',comboType: 'BOR120'},
			    			{name: 'ITEM_CODE'			,text:'<t:message code="system.label.sales.item" default="품목"/>'					,type:'string'},
			    			{name: 'ITEM_NAME'			,text:'<t:message code="system.label.sales.itemname" default="품목명"/>'				,type:'string'},
			    			{name: 'CUSTOM_NAME1'		,text:'<t:message code="system.label.sales.customname" default="거래처명"/>'			,type:'string'},
			    			{name: 'SPEC'				,text:'<t:message code="system.label.sales.spec" default="규격"/>'					,type:'string'},
			    			{name: 'ORDER_UNIT_Q'		,text:'<t:message code="system.label.sales.soqty" default="수주량"/>'				,type:'uniQty'},
			    			{name: 'ORDER_O'			,text:'<t:message code="system.label.sales.soamount" default="수주액"/>'				,type:'uniFC'},
			    			{name: 'SO_AMT_WON'			,text:'<t:message code="system.label.sales.cosoamount" default="수주액(자사)"/>'		,type:'uniPrice'},
			    			{name: 'CUSTOM_NAME2'		,text:'<t:message code="system.label.sales.customname" default="거래처명"/>'			,type:'string'},
			    			{name: 'ORDER_DATE'			,text:'<t:message code="system.label.sales.sodate" default="수주일"/>'				,type:'uniDate'},
			    			{name: 'ORDER_PRSN'			,text:'<t:message code="system.label.sales.chargername" default="담당자명"/>'		,type:'string',comboType:"AU", comboCode:"S010"},
			    			{name: 'PROJECT_NAME'		,text:'<t:message code="system.label.sales.projectname" default="프로젝트명"/>'		,type:'string'}
			    		], 
			    		store : directMasterStore1,
			    		scrollable : true,
			    	    initCols: ["수주월"],
			    	    initVals:["수주액"],
			    	    chartSize : {width : 1000, height:220},
			    	    rendererName : 'Line Chart',
			    		flex : 0.5,
						addFields :[{
							text : '실적율',
							name : 'ADD_FIELD1',
							type : 'UniPercent',
							addfunction : function(record) {
								return Math.round(record.get("ORDER_O")/directMasterStore1.sum("ORDER_O")*10000)/100;
							}
						},{
							text : '수주월',
							name : 'ADD_FIELD2',
							type : 'string',
							addfunction : function(record) {
								return Ext.Date.format(UniDate.extParseDate(record.get("ORDER_DATE")),'Y.m')
							}
						}]
					},
					{
			    		xtype 	: 'UniPivotComponent',
			    		id    	:  'sof100skrvGrid1Pivot3',
			    		initFields : [
			    			{name: 'OUT_DIV_CODE'		,text: '<t:message code="system.label.sales.issuedivision" default="출고사업장"/>'					,type: 'string',comboType: 'BOR120'},
			    			{name: 'ITEM_CODE'			,text:'<t:message code="system.label.sales.item" default="품목"/>'								,type:'string'},
			    			{name: 'ITEM_NAME'			,text:'<t:message code="system.label.sales.itemname" default="품목명"/>'							,type:'string'},
			    			{name: 'CUSTOM_NAME1'		,text:'<t:message code="system.label.sales.customname" default="거래처명"/>'						,type:'string'},
			    			{name: 'SPEC'				,text:'<t:message code="system.label.sales.spec" default="규격"/>'								,type:'string'},
			    			{name: 'ORDER_UNIT_Q'		,text:'<t:message code="system.label.sales.soqty" default="수주량"/>'								,type:'uniQty'},
			    			{name: 'ORDER_O'			,text:'<t:message code="system.label.sales.soamount" default="수주액"/>'							,type:'uniFC'},
			    			{name: 'SO_AMT_WON'			,text:'<t:message code="system.label.sales.cosoamount" default="수주액(자사)"/>'						,type:'uniPrice'},
			    			{name: 'CUSTOM_NAME2'		,text:'<t:message code="system.label.sales.customname" default="거래처명"/>'						,type:'string'},
			    			{name: 'ORDER_DATE'			,text:'<t:message code="system.label.sales.sodate" default="수주일"/>'								,type:'uniDate'},
			    			{name: 'ORDER_PRSN'		,text:'<t:message code="system.label.sales.chargername" default="담당자명"/>'						,type:'string',comboType:"AU", comboCode:"S010"},
			    			{name: 'PROJECT_NAME'		,text:'<t:message code="system.label.sales.projectname" default="프로젝트명"/>'						,type:'string'}
			    		], 
			    		//model : Sof100skrvModel,
			    		store : directMasterStore1,
			    		initRows: ["담당자명"],
			    	    initCols: ["수주월"],
			    	    initVals:["실적율"],
			    	    aggregatorName: "Sum",
			    	    //chartSize : {width : 1000, height:500},
			    	    addFields :[{
							text : '실적율',
							name : 'ADD_FIELD1',
							type : 'UniPercent',
							addfunction : function(record) {
								return Math.round(Unilite.nvl(record.get("ORDER_O"),0)/directMasterStore1.sum("ORDER_O")*10000)/100;
							}
						},{
							text : '수주월',
							name : 'ADD_FIELD2',
							type : 'string',
							addfunction : function(record) {
								return Ext.Date.format(UniDate.extParseDate(record.get("ORDER_DATE")),'Y.m')
							}
						}],			
			    	    rendererName : 'Table',
			    		flex : 0.5,
			    		border : true,
					}]
				}
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

			//20181116 추가 (기본 화폐단위, 환산 화폐단위, 환산 환율 관련 로직)
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
			this.onQueryButtonDown();
		},
		onQueryButtonDown: function() {
			if(!panelSearch.setAllFieldsReadOnly(true)){
				return false;
			}
			directMasterStore1.loadStoreRecords();

		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			directMasterStore1.loadData({})
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