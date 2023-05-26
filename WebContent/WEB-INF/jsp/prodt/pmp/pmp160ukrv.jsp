<%--
'   프로그램명 : 자재예약 조정(생산)
'   작  성  자 : 시너지시스템즈 개발실
'   작  성  일 :
'   최종수정자 :
'   최종수정일 :
'   버	  전 : OMEGA Plus V6.0.0
--%>
<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="pmp160ukrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 						<!-- 사업장 -->
	<t:ExtComboStore items="${COMBO_WS_LIST}" storeId="wsList" />	<!-- 작업장 -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" />	<!--창고-->
	<t:ExtComboStore comboType="AU" comboCode="P001"/>				<!-- 진행상태 -->
	<t:ExtComboStore comboType="AU" comboCode="B039"/>				<!-- 출고방법 -->
	<t:ExtComboStore comboType="AU" comboCode="P103"/>				<!-- 참조구분 -->
	<t:ExtComboStore comboType="AU" comboCode="M105"/>				<!-- 사급구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B081"/>				<!-- 대체품목여부 -->
	<t:ExtComboStore comboType="AU" comboCode="P103"/>				<!-- 참조구분 -->
	<t:ExtComboStore comboType="OU" />								<!-- 창고-->
	<t:ExtComboStore comboType="WU" />								<!-- 작업장-->
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>

<script type="text/javascript" >

var SearchInfoWindow;	// 검색창
var ReplaceItemWindow;	// 대체품목
//전역변수 : 대체품목 등록여부
var BsaCodeInfo = {
	gsExchgRegYN			: '${gsExchgRegYN}',
	gsAutomatedIssuance		: '${gsAutomatedIssuance}',				//출고요청자동생성여부(P109)
	gsAvailibleStockCheck	: '${gsAvailibleStockCheck}',			//작지가용재고 체크여부(P112)
	gsIssueRequestDelete	: '${gsIssueRequestDelete}'	,			//자재예약 삭제시 출고요청 삭제여부 (P115)
	gsWorkWhcode            : '${gsWorkWhcode}'                     //생산가공창고적용시 자재예약창고를 출고방법에따라 설정여부(P000)           
};
var outDivCode = UserInfo.divCode;

/*정상적으로 변수 생성 되었는지 테스트
var output ='';
for(var key in BsaCodeInfo){
	output += key + '  :  ' + BsaCodeInfo[key] + '\n';
}
alert(output);*/

function appMain() {
	//gsExchgRegYN 값에 따른 컬럼 동적처리를 위해서 설정
	var isAutoItem = true;
	if(BsaCodeInfo.gsExchgRegYN=='Y') {
		isAutoItem = false;
	}

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'pmp160ukrvService.selectDetailList2',
			update	: 'pmp160ukrvService.updateDetail',
			create	: 'pmp160ukrvService.insertDetail',
			destroy	: 'pmp160ukrvService.deleteDetail',
			syncAll	: 'pmp160ukrvService.saveAll'
		}
	});



	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 3},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel	: '<t:message code="system.label.product.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120' ,
			allowBlank	: false,
			value		: UserInfo.divCode,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelResult.setValue('WORK_SHOP_CODE', '');
				}
			}
		},{
			fieldLabel		: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'PRODT_START_DATE_FR',
			endFieldName	: 'PRODT_START_DATE_TO',
			startDate		: UniDate.get('mondayOfWeek'),
			endDate			: UniDate.get('endOfMonth'),
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
			}
		},
		Unilite.popup('DIV_PUMOK',{
			fieldLabel		: '<t:message code="system.label.product.item" default="품목"/>',
			valueFieldName	: 'ITEM_CODE',
			textFieldName	: 'ITEM_NAME',
			validateBlank	: false,
			listeners		: {
				onValueFieldChange: function( elm, newValue, oldValue ) {
					if(!Ext.isObject(oldValue)) {
						panelResult.setValue('ITEM_NAME', '');
					}
				},
				onTextFieldChange: function( elm, newValue, oldValue ) {
					if(!Ext.isObject(oldValue)) {
						panelResult.setValue('ITEM_CODE', '');
					}
				},
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
				}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.product.workcenter" default="작업장"/>',
			name		: 'WORK_SHOP_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'WU',
	 		allowBlank	: false,
	 		listeners	: {
				beforequery:function( queryPlan, eOpts ) {
					var store = queryPlan.combo.store;
					store.clearFilter();
					if(!Ext.isEmpty(panelResult.getValue('DIV_CODE'))){
						store.filterBy(function(record){
							return record.get('option') == panelResult.getValue('DIV_CODE');
						});
					} else {
						store.filterBy(function(record){
							return false;
						});
					}
				}
			}
		},{
			xtype	: 'container',
			layout	: {type : 'uniTable', columns : 3},
			width	: 315,
			items	: [{
				fieldLabel	: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>',
				xtype		: 'uniTextfield',
				name		: 'WKORD_NUM_FR',
				width		: 218,
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
					}
				}
			},{
				xtype		: 'component',
				html		: '~',
				style		: {
				marginTop	: '3px !important',
				font		: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
				}
			},{
				fieldLabel	: '',
				xtype		: 'uniTextfield',
				name		: 'WKORD_NUM_TO',
				width		: 120,
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
					}
				}
			}]
		},{
			xtype	: 'container',
			layout	: {type : 'uniTable', columns : 3},
			width	: 315,
			items	:[{
				fieldLabel	: '<t:message code="system.label.product.lotno" default="LOT번호"/>',
				xtype		: 'uniTextfield',
				name		: 'LOT_NO_FR',
				width		: 210,
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
					}
				}
			},{
				xtype		: 'component',
				html		: '~',
				style		: {
				marginTop	: '3px !important',
				font		: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
				}
			},{
				fieldLabel	: '',
				xtype		: 'uniTextfield',
				name		: 'LOT_NO_TO',
				width		: 120,
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
					}
				}
			}]
		},{
			fieldLabel	: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>',
			name		: 'WKORD_NUM',
			xtype		: 'uniTextfield',
			hidden		: true
		}],
		setAllFieldsReadOnly: function(b) {
			var r= true
			if(b) {
				var invalid = this.getForm().getFields().filterBy(function(field) {
					return !field.validate();
				});

				if(invalid.length > 0) {
					r				= false;
					var labelText	= ''
					if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
						var labelText = invalid.items[0]['fieldLabel']+' : ';
					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
						var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
					}
					Unilite.messageBox(labelText+Msg.sMB083);
					invalid.items[0].focus();
				} else {
				//	this.mask();
				}
			} else {
				this.unmask();
			}
			return r;
		}
	});



	/**Model 정의
	 * @type
	 */
	Unilite.defineModel('pmp160ukrvMasterModel', {
		fields: [
			{name: 'WORK_END_YN'		,text: '<t:message code="system.label.product.wkordstatus" default="작지상태"/>'			,type:'string'	, comboType: 'AU'	, comboCode: 'P001'},
			{name: 'DIV_CODE'			,text: '<t:message code="system.label.product.mfgplace" default="제조처"/>'				,type:'string'},
			{name: 'WKORD_NUM'			,text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'			,type:'string'},
			{name: 'WORK_SHOP_CODE'		,text: '<t:message code="system.label.product.workcenter" default="작업장"/>'				,type:'string'},
			{name: 'ITEM_CODE'			,text: '<t:message code="system.label.product.item" default="품목"/>'						,type:'string'},
			{name: 'ITEM_NAME'			,text: '<t:message code="system.label.product.itemname" default="품목명"/>'				,type:'string'},
			{name: 'SPEC'				,text: '<t:message code="system.label.product.spec" default="규격"/>'						,type:'string'},
			{name: 'STOCK_UNIT'			,text: '<t:message code="system.label.product.unit" default="단위"/>'						,type:'string'	, displayField: 'value'},
			{name: 'PRODT_START_DATE'	,text: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>'		,type:'uniDate'},
			{name: 'PRODT_END_DATE'		,text: '<t:message code="system.label.product.completiondate" default="완료예정일"/>'		,type:'uniDate'},
			{name: 'WKORD_Q'			,text: '<t:message code="system.label.product.workorderqty" default="작업지시량"/>'			,type:'uniQty'},
			{name: 'PRODT_Q'			,text: '<t:message code="system.label.product.productionqty" default="생산량"/>'			,type:'uniQty'},
			{name: 'LOT_NO'				,text: '<t:message code="system.label.product.lotno" default="LOT번호"/>'					,type:'string'},
			{name: 'REMARK1'			,text: '<t:message code="system.label.product.remarks" default="비고"/>'					,type:'string'},
			{name: 'PROJECT_NO'			,text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'			,type:'string'},
			{name: 'PJT_CODE'			,text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'			,type:'string'},
			{name: 'ORDER_NUM'			,text: '<t:message code="system.label.product.sono" default="수주번호"/>'					,type:'string'},
			{name: 'ORDER_Q'			,text: '<t:message code="system.label.product.soqty" default="수주량"/>'					,type:'uniQty'},
			{name: 'DVRY_DATE'			,text: '<t:message code="system.label.product.deliverydate" default="납기일"/>'			,type:'uniDate'},
			{name: 'REMARK2'			,text: '<t:message code="system.label.product.customname" default="거래처명"/>'				,type:'string'},
			{name: 'WH_CODE'			,text: '<t:message code="system.label.product.processingwarehouse" default="가공창고"/>'	,type:'string'	, xtype: 'uniCombobox'	, comboType: 'OU'}
		]
	});

	Unilite.defineModel('pmp160ukrvDetailModel', {
		fields: [
			{name: 'COMP_CODE'			,text: '<t:message code="system.label.product.compcode" default="법인코드"/>'				,type:'string'},
			{name: 'DIV_CODE'			,text: '<t:message code="system.label.product.division" default="사업장"/>'				,type:'string'},
			{name: 'SEQ'				,text: '<t:message code="system.label.product.seq" default="순번"/>'						,type:'int'},
			{name: 'WKORD_NUM'			,text: '<t:message code="system.label.product.workorderno2" default="작지번호"/>'			,type:'string'},
			{name: 'ITEM_CODE'			,text: '<t:message code="system.label.product.childitemcode" default="자품목코드"/>'			,type:'string'	, allowBlank: false},
			{name: 'ITEM_NAME'			,text: '<t:message code="system.label.product.childitemname" default="자품목명"/>'			,type:'string'},
			{name: 'SPEC'				,text: '<t:message code="system.label.product.spec" default="규격"/>'						,type:'string'},
			{name: 'STOCK_UNIT'			,text: '<t:message code="system.label.product.unit" default="단위"/>'						,type:'string'	, displayField: 'value'},
			{name: 'OLD_ITEM_CODE'		,text: '<t:message code="system.label.product.existingitemcode" default="기존품목코드"/>'		,type:'string'},
			{name: 'UNIT_Q'				,text: '<t:message code="system.label.product.originunitqty" default="원단위량"/>'			,type:'float'	, allowBlank: false, decimalPrecision: 6, format:'0,000.000000'},
			{name: 'LOSS_RATE'			,text: '<t:message code="system.label.product.lossrate" default="LOSS율"/>'				,type:'uniER'},
			{name: 'ALLOCK_Q'			,text: '<t:message code="system.label.product.allocationqty" default="예약량"/>'			,type:'float'	, allowBlank: false, decimalPrecision: 6, format:'0,000.000000'},
			{name: 'PAB_STOCK_Q'		,text: '<t:message code="system.label.product.availableinventoryqty" default="가용재고량"/>'	,type:'float'	, decimalPrecision: 6, format:'0,000.000000'},
			{name: 'SHORTAGE_Q'			,text: '<t:message code="system.label.product.shortageqty2" default="부족수량"/>'			,type:'float'	, decimalPrecision: 6, format:'0,000.000000'},
			{name: 'EXCHG_EXIST_YN'		,text: '<t:message code="system.label.product.subitemexistyn" default="대체품존재여부"/>'		,type:'string'	, comboType: 'AU' , comboCode:"B081"},
			{name: 'REF_ITEM_CODE'		,text: '<t:message code="system.label.product.subbeforeitem" default="대체전품목"/>'			,type:'string'},
			{name: 'REF_ITEM_NAME'		,text: '<t:message code="system.label.product.subbeforeitemname" default="대체전품목명"/>'	,type:'string'},
			{name: 'EXCHG_YN'			,text: '<t:message code="system.label.product.subyn" default="대체여부"/>'					,type:'string'	, comboType: 'AU' , comboCode:"B081"},
			{name: 'OUT_METH'			,text: '<t:message code="system.label.product.issuemethod" default="출고방법"/>'			,type:'string'	, comboType: 'AU' , comboCode:"B039"},
			{name: 'GROUP_CODE'			,text: '<t:message code="system.label.base.routinggroup" default="공정그룹"/>'				,type: 'string'	, comboType: 'AU', comboCode:'B140'},
			{name: 'OUTSTOCK_REQ_DATE'	,text: '<t:message code="system.label.product.issuerequestdate" default="출고요청일"/>'		,type:'uniDate'},
			{name: 'OUTSTOCK_REQ_Q'		,text: '<t:message code="system.label.product.issuerequestqty" default="출고요청량"/>'		,type:'float'	, decimalPrecision: 6, format:'0,000.000000'},
			{name: 'OUTSTOCK_NUM'		,text: '<t:message code="system.label.product.issuerequestno" default="출고요청번호"/>'		,type:'string'},
			{name: 'OUTSTOCK_Q'			,text: '<t:message code="system.label.product.issueqty" default="출고량"/>'				,type:'float'	, decimalPrecision: 6, format:'0,000.000000'},
			{name: 'REF_TYPE'			,text: '<t:message code="system.label.product.requestclassification" default="요청구분"/>'	,type:'string'	, comboType: 'AU' , comboCode:"P103"},
			{name: 'GRANT_TYPE'			,text: '<t:message code="system.label.product.subcontractdivision" default="사급구분"/>'	,type:'string'	, comboType: 'AU' , comboCode:"M105"},
			{name: 'REMARK'				,text: '<t:message code="system.label.product.remarks" default="비고"/>'					,type:'string'},
			{name: 'PROJECT_NO'			,text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'			,type:'string'},
			{name: 'PJT_CODE'			,text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'			,type:'string'},
			{name: 'PATH_CODE'			,text: '<t:message code="system.label.product.pathinfo" default="PATH정보"/>'				,type:'string'},
			{name: 'WH_CODE'			,text: '<t:message code="system.label.product.processingwarehouse" default="가공창고"/>'	,type:'string'	, xtype: 'uniCombobox', comboType   : 'OU'},
			{name: 'WORK_SHOP_CODE'		,text: '<t:message code="system.label.product.workcenter" default="작업장"/>'				,type:'string'},
			{name: 'UPDATE_DB_USER'		,text: '<t:message code="system.label.product.updateuser" default="수정자"/>'				,type:'string'},
			{name: 'UPDATE_DB_TIME'		,text: '<t:message code="system.label.product.updatedate" default="수정일"/>' 				,type:'uniDate'},
			//20200324 추가: 가중치
			{name: 'WEIGHT_RATE'		,text: '가중치'	,type: 'uniPercent'}
		]
	});

	Unilite.defineModel('replaceItemModel', {
		fields: [
			{name: 'ITEM_CODE'		,text: '<t:message code="system.label.product.item" default="품목"/>'						,type:'string'},
			{name: 'ITEM_NAME'		,text: '<t:message code="system.label.product.itemname" default="품목명"/>'				,type:'string'},
			{name: 'SPEC'			,text: '<t:message code="system.label.product.spec" default="규격"/>'						,type:'string'},
			{name: 'STOCK_UNIT'		,text: '<t:message code="system.label.product.inventoryunit" default="재고단위"/>'			,type:'string'},
			{name: 'PAB_STOCK_Q'	,text: '<t:message code="system.label.product.availableinventoryqty" default="가용재고량"/>'	,type:'uniQty'},
			{name: 'ALLOCK_Q'		,text: '<t:message code="system.label.product.allocationqty" default="예약량"/>'			,type:'uniQty'},
			{name: 'UNIT_Q'			,text: '<t:message code="system.label.product.originunitqty" default="원단위량"/>'			,type:'uniQty'},
			{name: 'PROD_UNIT_Q'	,text: '<t:message code="system.label.product.parentitembaseqty" default="모품목기준수"/>'	,type:'uniQty'},
			{name: 'LOSS_RATE'		,text: '<t:message code="system.label.product.lossrate" default="LOSS율"/>'				,type:'uniER'},
			{name: 'UNIT_P1'		,text: '<t:message code="system.label.product.price" default="단가"/>1'					,type:'uniUnitPrice'},
			{name: 'UNIT_P2'		,text: '<t:message code="system.label.product.price" default="단가"/>2'					,type:'uniUnitPrice'},
			{name: 'UNIT_P3'		,text: '<t:message code="system.label.product.price" default="단가"/>3'					,type:'uniUnitPrice'},
			{name: 'MAN_HOUR'		,text: '<t:message code="system.label.product.standardtacttime" default="표준공수"/>'		,type:'uniQty'},
			{name: 'USE_YN'			,text: '<t:message code="system.label.product.useyn" default="사용여부"/>'					,type:'string'},
			{name: 'BOM_YN'			,text: '<t:message code="system.label.product.compyn" default="구성여부"/>'					,type:'string'},
			{name: 'START_DATE'		,text: '<t:message code="system.label.product.startdate" default="시작일"/>'				,type:'uniDate'},
			{name: 'STOP_DATE'		,text: '<t:message code="system.label.product.enddate" default="종료일"/>'					,type:'uniDate'},
			{name: 'REMARK'			,text: '<t:message code="system.label.product.remarks" default="비고"/>'					,type:'string'},
			{name: 'PRIOR_SEQ'		,text: '<t:message code="system.label.product.priority" default="우선순위"/>'				,type:'string'}
		]
	});



	var MasterStore = Unilite.createStore('pmp160ukrvMasterStore', {
		model	: 'pmp160ukrvMasterModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,		// 상위 버튼 연결
			editable	: false,		// 수정 모드 사용
			deletable	: false,		// 삭제 가능 여부
			useNavi		: false			// prev | next 버튼 사용
		},
		//위에 정의해 놓은 selectDetailList2대신 selectDetailList를 직접 호출
		//proxy: directProxy,
		proxy: {
			type: 'direct',
			api	: {
				read: 'pmp160ukrvService.selectDetailList'
			}
		},
		loadStoreRecords: function(wkordNumList) {
			var param = panelResult.getValues();
			if(!Ext.isEmpty(wkordNumList)){
				param.wkordNumList = wkordNumList;
			}
			param.ITEM_CODE = panelResult.getValue('ITEM_CODE');
			param.ITEM_NAME = panelResult.getValue('ITEM_NAME');
			console.log(param);
			this.load({
				params : param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(records[0] != null){
					panelResult.setValue('WKORD_NUM',records[0].get('WKORD_NUM'));
					if(panelResult.getValue('WKORD_NUM') != ''){
						detailStore.loadStoreRecords(records);
					}
				} else {
					panelResult.setValue('WKORD_NUM', '');
					detailGrid.getStore().removeAll();
				}
			}/*,
			add: function(store, records, index, eOpts) {
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
			},
			remove: function(store, record, index, isMove, eOpts) {
			}*/
		}
	});

	var masterGrid = Unilite.createGrid('pmp160ukrvGrid', {
		store	: MasterStore,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			expandLastColumn	: false,
			useRowNumberer		: false,
			useMultipleSorting	: true
		},
		selModel: 'rowmodel',
		columns	: [
			{dataIndex: 'WORK_END_YN'		, width: 80		, align:'center'},
			{dataIndex: 'DIV_CODE'			, width: 66		, hidden: true},
			{dataIndex: 'WKORD_NUM'			, width: 120},
			{dataIndex: 'WORK_SHOP_CODE'	, width: 93		, hidden: true},
			{dataIndex: 'ITEM_CODE'			, width: 110},
			{dataIndex: 'ITEM_NAME'			, width: 200},
			{dataIndex: 'SPEC'				, width: 130},
			{dataIndex: 'STOCK_UNIT'		, width: 60		, align:'center'},
			{dataIndex: 'PRODT_START_DATE'	, width: 80},
			{dataIndex: 'PRODT_END_DATE'	, width: 80},
			{dataIndex: 'WKORD_Q'			, width: 100},
			{dataIndex: 'PRODT_Q'			, width: 80},
			{dataIndex: 'LOT_NO'			, width: 110},
			{dataIndex: 'REMARK1'			, width: 100},
			{dataIndex: 'PROJECT_NO'		, width: 100},
//			{dataIndex: 'PJT_CODE'			, width: 100},
			{dataIndex: 'ORDER_NUM'			, width: 110},
			{dataIndex: 'ORDER_Q'			, width: 66		, hidden: true},
			{dataIndex: 'DVRY_DATE'			, width: 80},
			{dataIndex: 'REMARK2'			, width: 66 	, hidden: true},
			{dataIndex: 'WH_CODE'			, width: 66 	, hidden: true}
		],
		listeners: {
			selectionchange:function( model1, selected, eOpts ){
				if(selected.length > 0) {
					var record		= selected[0];
					var param		= panelResult.getValues();
					param.WKORD_NUM	= record.get('WKORD_NUM');
					param.DIV_CODE	= record.get('DIV_CODE');
					detailStore.loadStoreRecords(param);
				}
			},
			select: function() {
				UniAppManager.setToolbarButtons(['newData', 'delete'], false);
			},
			cellclick: function() {
				UniAppManager.setToolbarButtons(['newData', 'delete'], false);
			},
			render: function(grid, eOpts) {
				var girdNm = grid.getItemId();
				grid.getEl().on('click', function(e, t, eOpt) {
					UniAppManager.setToolbarButtons(['newData', 'delete'], false);
					//20200403 추가: 예약자재 재생성 버튼 control
					if(masterGrid.getSelectedRecord() && masterGrid.getSelectedRecord().get('WORK_END_YN') == '3') {
						detailGrid.down('#REGENERATION_BTN').enable();
					} else {
						detailGrid.down('#REGENERATION_BTN').disable();
					}
				});
			}
//			cellclick: function( viewTable, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
//				if(rowIndex != beforeRowIndex){
//					panelSearch.setValue('WKORD_NUM',record.get('WKORD_NUM'));
//					detailStore.loadStoreRecords(record);
//				}
//				var record = masterGrid.getSelectedRecord();
//
//				if(record[0].data.WORK_END_YN == '9'){
//					UniAppManager.setToolbarButtons(['delete', 'newDate'], false);
//				}
//
//				beforeRowIndex = rowIndex;
//			}
		},
		setEstiData:function(record) {
			var grdRecord = masterGrid.uniOpt.currentRecord;
		}
	});



	var detailStore = Unilite.createStore('pmp160ukrvDetailStore', {
		model	: 'pmp160ukrvDetailModel',
		proxy	: directProxy,
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,			// 상위 버튼 연결
			editable	: true,			// 수정 모드 사용
			deletable	: true,			// 삭제 가능 여부
			useNavi		: false			// prev | next 버튼 사용
		},
		loadStoreRecords: function(param){
			//var param= panelSearch.getValues();
			this.load({
				params : param,
				//상태값이 "완료(9)"일 때, 추가 / 삭제 버튼 비활성화
				callback : function(records,options,success) {
					if(success) {
						var record = masterGrid.getSelectedRecord();
						if(record.data.WORK_END_YN == '9'){
							UniAppManager.setToolbarButtons(['delete', 'newData'], false);
						} else {
							UniAppManager.setToolbarButtons(['delete', 'newData'], true);
						}
					}
				}
			});
		},
		saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();
			var toDelete = this.getRemovedRecords();
			var list = [].concat(toUpdate, toCreate);
			console.log("list:", list);

			var orderNum = panelResult.getValue('ORDER_NUM');
			Ext.each(list, function(record, index) {
				if(record.data['ORDER_NUM'] != orderNum) {
					record.set('ORDER_NUM', orderNum);
				}
			})
			console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));

			//1. panelResult 정보 파라미터 구성
			var paramMaster= panelResult.getValues();	//syncAll 수정

			if(inValidRecs.length == 0) {
				config = {
					params	: [paramMaster],
					success	: function(batch, option) {
						panelResult.getForm().wasDirty = false;
						panelResult.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);
					}
				};
				this.syncAllDirect(config);
			} else {
				if(!Ext.isEmpty(inValidRecs)){
					var grid = Ext.getCmp('pmp160ukrvGrid2');
					grid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			}
		}
	});

	var detailGrid = Unilite.createGrid('pmp160ukrvGrid2', {
		store	: detailStore,
		layout	: 'fit',
		region	: 'south',
		uniOpt	: {
			expandLastColumn	: false,
			useRowNumberer		: false
		},
		tbar	: [{
			//20200403 추가: 예약자재 재생성
			itemId	: 'REGENERATION_BTN',
			hidden	: true,
			text	: '<div style="color: blue"><t:message code="system.label.product.REGENERATIONreservationmaterial" default="예약자재 재생성"/></div>',
			handler	: function() {
				if(confirm('<t:message code="system.message.product.message067" default="선택한 작지품목에 대한 예약정보가 재생성됩니다."/>' + '\n' + '<t:message code="system.message.sales.confirm003" default="진행하시겠습니까?"/>')) {
					Unilite.messageBox('개발진행 중 입니다.')
//					var masterRecord= masterGrid.getSelectedRecord();
//					var param		= {
//					}
//					pmp160ukrvService.fnRegeneration(param, function(provider, response) {
//						if(!Ext.isEmpty(provider)) {
//							UniAppManager.updateStatus('<t:message code="system.message.product.message068" default="재생성작업이 완료되었습니다."/>');
//						}
//					});
				}
			}
		},{
			id		: 'REPLACE_BTN',
			text	: '<div style="color: blue"><t:message code="system.label.product.subitem" default="대체품목"/></div>',
			handler	: function() {
				openReplaceItemWindow();
			}
		}],
		features: [ {id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: true },
					{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: true} ],
		columns: [
			{dataIndex: 'COMP_CODE'			, width: 80 ,	hidden: true},
			{dataIndex: 'DIV_CODE'			, width: 80 ,	hidden: true},
			{dataIndex: 'WKORD_NUM'			, width: 100,	hidden: true},
			{dataIndex: 'SEQ'				, width: 60,	align:'center'},
			{dataIndex: 'ITEM_CODE'			, width: 110,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '', '<t:message code="system.label.product.totalreservationamount" default="예약수량합계"/>');
				},
				editor: Unilite.popup('DIV_PUMOK_G', {
	 				textFieldName	: 'ITEM_CODE',
	 				DBtextFieldName	: 'ITEM_CODE',
//	 				extParam		: {SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'},
					autoPopup		: true,
	 				listeners		: {
	 					'onSelected': {
							fn: function(records, type) {
								console.log('records : ', records);
								Ext.each(records, function(record,i) {
									if(i==0) {
										detailGrid.setItemData(record,false, detailGrid.uniOpt.currentRecord);
									} else {
										UniAppManager.app.onNewDataButtonDown();
										detailGrid.setItemData(record,false, detailGrid.getSelectedRecord());
									}
								});
							},
							scope: this
						},
						'onClear': function(type) {
							detailGrid.setItemData(null,true, detailGrid.uniOpt.currentRecord);
						},
						'applyextparam': function(popup){
							popup.setExtParam({SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'});
						}
					}
				})
			},
			{dataIndex: 'ITEM_NAME'			, width: 200,
				editor: Unilite.popup('DIV_PUMOK_G', {
//					extParam	: {SELMODEL: 'MULTI', DIV_CODE: outDivCode},
					autoPopup	: true,
					listeners	: {
						'onSelected': {
							fn: function(records, type) {
								console.log('records : ', records);
								Ext.each(records, function(record,i) {
									if(i==0) {
										detailGrid.setItemData(record,false, detailGrid.uniOpt.currentRecord);
									} else {
										UniAppManager.app.onNewDataButtonDown();
										detailGrid.setItemData(record,false, detailGrid.getSelectedRecord());
									}
								});
							},
							scope: this
						},
						'onClear': function(type) {
							detailGrid.setItemData(null,true, detailGrid.uniOpt.currentRecord);
						},
						'applyextparam': function(popup){
							popup.setExtParam({SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'});
						}
					}
				})
			},
			{dataIndex: 'SPEC'				, width: 110,	editable: false},
			{dataIndex: 'STOCK_UNIT'		, width: 80,	editable: false,	align:'center'},
			{dataIndex: 'OLD_ITEM_CODE'		, width: 110,	hidden: true},
			{dataIndex: 'UNIT_Q'			, width: 100,	xtype: 'uniNnumberColumn'},
			{dataIndex: 'LOSS_RATE'			, width: 100,	hidden: false},
			{dataIndex: 'ALLOCK_Q'			, width: 100,	summaryType: 'sum', xtype: 'uniNnumberColumn'},
			{dataIndex: 'PAB_STOCK_Q'		, width: 100,	editable: false,	hidden: isAutoItem, xtype: 'uniNnumberColumn'},
			{dataIndex: 'SHORTAGE_Q'		, width: 100,	editable: false,	hidden: isAutoItem, xtype: 'uniNnumberColumn'},
			//20200324 추가: 가중치
			{dataIndex: 'WEIGHT_RATE'		, width: 100,	summaryType: 'sum'},
			{dataIndex: 'OUT_METH'			, width: 100,	align:'center'},
			{dataIndex: 'GROUP_CODE'		, width: 100,	align:'center'},
			{dataIndex: 'EXCHG_EXIST_YN'	, width: 106,	editable: false,	align:'center'},
			{dataIndex: 'REF_ITEM_CODE'		, width: 110,	editable: false,	hidden: isAutoItem},
			{dataIndex: 'REF_ITEM_NAME'		, width: 200,	editable: false,	hidden: isAutoItem},
			{dataIndex: 'EXCHG_YN'			, width: 100,	editable: false,	align:'center',	hidden: isAutoItem},
			{dataIndex: 'OUTSTOCK_REQ_DATE'	, width: 100,	hidden: true},
			{dataIndex: 'OUTSTOCK_REQ_Q'	, width: 100,	editable: false,	xtype: 'uniNnumberColumn'},
			{dataIndex: 'OUTSTOCK_NUM'		, width: 100,	hidden: true},
			{dataIndex: 'OUTSTOCK_Q'		, width: 80,	hidden: true,		xtype: 'uniNnumberColumn'},
			{dataIndex: 'REF_TYPE'			, width: 100,	editable: false},
			{dataIndex: 'GRANT_TYPE'		, width: 100},
			{dataIndex: 'REMARK'			, width: 120},
			{dataIndex: 'PROJECT_NO'		, width: 100,
				editor: Unilite.popup('PROJECT_G', {
	 				textFieldName: 'PROJECT_CODE',
	 				DBtextFieldName: 'PROJECT_CODE',
//	 				extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'},
					autoPopup: true,
	 				listeners: {
	 					'onSelected': {
							fn: function(records, type) {
								console.log('records : ', records);
								Ext.each(records, function(record,i) {
									if(i==0) {
										detailGrid.setProjectData(record,false, detailGrid.uniOpt.currentRecord);
									} else {
										UniAppManager.app.onNewDataButtonDown();
										detailGrid.setProjectData(record,false, detailGrid.getSelectedRecord());
									}
								});
							},
							scope: this
						},
						'onClear': function(type) {
							detailGrid.setProjectData(null,true, detailGrid.uniOpt.currentRecord);
						},
						'applyextparam': function(popup){
							popup.setExtParam({SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'});
						}
					}
				})
			}/*,
			{dataIndex: 'PJT_CODE'			, width: 100,	editor:
			 	Unilite.popup('PJT_G', {
	 				textFieldName: 'PJT_CODE',
	 				DBtextFieldName: 'PJT_CODE',
	 				extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'},
	 				listeners: {'onSelected': {
										fn: function(records, type) {
											console.log('records : ', records);
											Ext.each(records, function(record,i) {
												if(i==0) {
													detailGrid.setPjtData(record,false, detailGrid.uniOpt.currentRecord);
												} else {
													UniAppManager.app.onNewDataButtonDown();
													detailGrid.setPjtData(record,false, detailGrid.getSelectedRecord());
												}
											});
										},
										scope: this
								},
								'onClear': function(type) {
									detailGrid.setPjtData(null,true, detailGrid.uniOpt.currentRecord);
								}
					}
				})
			}*/,
			{dataIndex: 'PATH_CODE'			, width: 100,	editable: false },
			{dataIndex: 'WH_CODE'			, width: 100,	editable: false },
			{dataIndex: 'WORK_SHOP_CODE'	, width: 120,	hidden: true},
			{dataIndex: 'OLD_ITEM_CODE'		, width: 100,	hidden: true},
			{dataIndex: 'UPDATE_DB_USER'	, width: 100,	hidden: true},
			{dataIndex: 'UPDATE_DB_TIME'	, width: 76,	hidden: true}
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ){
				/*if(e.record.get('OUTSTOCK_REQ_Q') > 0){
					alert('<t:message code="system.message.product.message006" default="출고요청된 수량이 있으므로 수정이 불가능합니다."/>');
					return false;
				}*/
				if(e.field=='LOSS_RATE')		return false;

				if(e.record.phantom){
					if(e.field=='ITEM_CODE')	return true;
					if(e.field=='ITEM_NAME')	return true;
				} else {
					if(e.field=='ITEM_CODE')	return false;
					if(e.field=='ITEM_NAME')	return false;
				}
//				if(e.record.data.OUT_METH != '3')

				if(e.field=='SEQ')				return false;
				if(e.field=='GROUP_CODE')		return false;
			},
			select: function() {
				selectedGrid = 's_pbs071ukrv_kdGrid2';
				var count = masterGrid.getStore().getCount();
				if(count > 0) {
					UniAppManager.setToolbarButtons(['delete', 'newData'], true);
				}
			},
			cellclick: function() {
				var count = masterGrid.getStore().getCount();
				if(count > 0) {
					UniAppManager.setToolbarButtons(['newData'], true);
					var record = detailGrid.getSelectedRecord();
					if(record.data.EXCHG_EXIST_YN == 'N') {
						Ext.getCmp('REPLACE_BTN').setDisabled(false);
					} else {
						Ext.getCmp('REPLACE_BTN').setDisabled(false);
					}
				}
			},
			render: function(grid, eOpts) {
				var girdNm = grid.getItemId();
				grid.getEl().on('click', function(e, t, eOpt) {
					UniAppManager.setToolbarButtons(['newData'], true);
					var count = detailGrid.getStore().getCount();
					if(count > 0) {
						UniAppManager.setToolbarButtons(['delete'], true);
					}
					if(detailStore.isDirty()) {
						UniAppManager.setToolbarButtons('save', true);
					} else {
						UniAppManager.setToolbarButtons('save', false);
					}
				});
			}
		},
		setItemData: function(record, dataClear, grdRecord) {
			if(dataClear) {
				grdRecord.set('ITEM_CODE'			,"");
				grdRecord.set('ITEM_NAME'			,"");
				grdRecord.set('SPEC'				,"");
				grdRecord.set('STOCK_UNIT'			,"");
				grdRecord.set('OUT_METH'			,"");
				grdRecord.set('LOSS_RATE'			,"");
				//grdRecord.set('REF_ITEM_CODE'		,"");
			} else {
				grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
				grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
				grdRecord.set('SPEC'				, record['SPEC']);
				grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);
				grdRecord.set('OUT_METH'			, record['OUT_METH']);

				var masterRecord = masterGrid.getSelectedRecord();
				var param = {
					DIV_CODE		: record['DIV_CODE'],
					PATH_CODE		: grdRecord.get('PATH_CODE'),
					PROD_ITEM_CODE	: masterRecord.get('ITEM_CODE'),
					ITEM_CODE		: record['ITEM_CODE']
				}
				pmp160ukrvService.getLossRate(param, function(provider, response) {
					if(!Ext.isEmpty(provider)) {
						grdRecord.set('LOSS_RATE', provider[0].LOSS_RATE);
					}
				});
				//grdRecord.set('REF_ITEM_CODE'		, record['ITEM_CODE']);
			}
		},
		setProjectData:function(record, dataClear, grdRecord) {
			if(dataClear) {
				grdRecord.set('PROJECT_NO', "");
			} else {
				grdRecord.set('PROJECT_NO', record['PJT_CODE']);
			}
		},
		setPjtData:function(record, dataClear, grdRecord) {
			if(dataClear) {
				grdRecord.set('PJT_CODE', "");
			} else {
				grdRecord.set('PJT_CODE', record['PJT_CODE']);
			}
		},
		setReplaceItemData: function(record) {						// 이동출고참조 셋팅
			var grdRecord = this.getSelectedRecord();
			grdRecord.set('REF_ITEM_CODE'	, grdRecord.get('ITEM_CODE'));
			grdRecord.set('REF_ITEM_NAME'	, grdRecord.get('ITEM_NAME'));
			grdRecord.set('ITEM_CODE'		, record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'		, record['ITEM_NAME']);
			grdRecord.set('SPEC'			, record['SPEC']);
			grdRecord.set('STOCK_UNIT'		, record['STOCK_UNIT']);
			grdRecord.set('UNIT_Q'			, record['UNIT_Q']);
			//grdRecord.set('ALLOCK_Q'		, record['ALLOCK_Q']);
			grdRecord.set('PAB_STOCK_Q'		, record['PAB_STOCK_Q']);
			if(record['ALLOCK_Q'] - record['PAB_STOCK_Q'] > 0) {
				nShortageQ = record['ALLOCK_Q'] - record['PAB_STOCK_Q']
			} else {
				nShortageQ = 0
			}
			grdRecord.set('SHORTAGE_Q'		, nShortageQ);
			grdRecord.set('EXCHG_EXIST_YN'	, 'Y');
			grdRecord.set('EXCHG_YN'		, 'Y');

			Ext.getCmp('REPLACE_BTN').setDisabled(true);
		}
	});



	var replaceStore = Unilite.createStore('replaceItemStore', {
		model	: 'replaceItemModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,		// 상위 버튼 연결
			editable	: true,			// 수정 모드 사용
			deletable	: false,		// 삭제 가능 여부
			useNavi		: false			// prev | next 버튼 사용
		},
		proxy: {
			type: 'direct',
			api	: {
				read: 'pmp160ukrvService.selectReplaceItem'
			}
		},
		loadStoreRecords: function(){
			var param				= replaceSearch.getValues();
			var record1				= masterGrid.getSelectedRecord();
			var record2				= detailGrid.getSelectedRecord();
			param.DIV_CODE			= outDivCode;
			param.PROD_ITEM_CODE	= record1.get('ITEM_CODE');
			param.CHILD_ITEM_CODE	= record2.get('ITEM_CODE');
			this.load({
				params : param
			});
		}
	});

	var replaceSearch = Unilite.createSearchForm('replaceSearchForm', {		// 대체품목 팝업
		layout	: {type : 'uniTable', columns : 2},
		items	: [{
			layout	: {type:'uniTable', column:2},
			xtype	: 'container',
			items	: [{
				fieldLabel	: '<t:message code="system.label.product.item" default="품목"/>',
				xtype		: 'uniTextfield',
				name		: 'ITEM_CODE',
				flex		: 2,
				width		: 160
			},{
				xtype	: 'uniTextfield',
				name	: 'ITEM_NAME',
				flex	: 1,
				width	: 153
			}]
		},{
			fieldLabel	: '<t:message code="system.label.product.allocationqty" default="예약량"/>',
			xtype		: 'uniTextfield',
			name		: 'ALLOCK_Q'
		}]
	});

	var replaceGrid = Unilite.createGrid('replacePummokPopupGrid', {		// 대체품목 팝업
		layout	: 'fit',
		store	: replaceStore,
		uniOpt	: {
			onLoadSelectFirst : true
		},
		features: [
			{id: 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: true},
			{id: 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: true}
		],
		columns: [
			{ dataIndex: 'ITEM_CODE'	, width: 110,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.product.subtotal" default="소계"/>', '<t:message code="system.label.product.totalamount" default="합계"/>');
				}
			},
			{ dataIndex: 'ITEM_NAME'	, width: 200},
			{ dataIndex: 'SPEC'			, width: 200},
			{ dataIndex: 'STOCK_UNIT'	, width: 120},
			{ dataIndex: 'PAB_STOCK_Q'	, width: 120, summaryType:'sum'},
			{ dataIndex: 'ALLOCK_Q'		, width: 120, summaryType:'sum'},
			{ dataIndex: 'UNIT_Q'		, width: 100, hidden: true},
			{ dataIndex: 'PROD_UNIT_Q'	, width: 100, hidden: true},
			{ dataIndex: 'LOSS_RATE'	, width: 100, hidden: true},
			{ dataIndex: 'UNIT_P1'		, width: 100, hidden: true},
			{ dataIndex: 'UNIT_P2'		, width: 100, hidden: true},
			{ dataIndex: 'UNIT_P3'		, width: 100, hidden: true},
			{ dataIndex: 'MAN_HOUR'		, width: 100, hidden: true},
			{ dataIndex: 'USE_YN'		, width: 100, hidden: true},
			{ dataIndex: 'BOM_YN'		, width: 100, hidden: true},
			{ dataIndex: 'START_DATE'	, width: 100, hidden: true},
			{ dataIndex: 'STOP_DATE'	, width: 100, hidden: true},
			{ dataIndex: 'REMARK'		, width: 100, hidden: true},
			{ dataIndex: 'PRIOR_SEQ'	, width: 100, hidden: true}
		],
		listeners: {
			beforeedit: function( editor, e, eOpts ){
				if(e.field=='ALLOCK_Q') {
					return true;
				} else {
					return false;
				}
			}
		},
		returnData: function()  {
			var record = replaceGrid.getSelectedRecord();
			detailGrid.setReplaceItemData(record.data);
		}
	});

	function openReplaceItemWindow() {										// 대체품목
		var record = detailGrid.getSelectedRecord();
		replaceSearch.setValue('ITEM_CODE'	, record.get('ITEM_CODE'));
		replaceSearch.setValue('ITEM_NAME'	, record.get('ITEM_NAME'));
		replaceSearch.setValue('ALLOCK_Q'	, record.get('ALLOCK_Q'));
		replaceStore.loadStoreRecords();

		if(!ReplaceItemWindow) {
			ReplaceItemWindow = Ext.create('widget.uniDetailWindow', {
				title	: '<t:message code="system.label.product.movingissuerefer" default="이동출고참조"/>',
				width	: 1080,
				height	: 580,
				layout	:{type:'vbox', align:'stretch'},
				items	: [replaceSearch, replaceGrid],
				tbar	:  ['->',
					{   itemId	: 'saveBtn',
						text	: '<t:message code="system.label.product.inquiry" default="조회"/>',
						handler	: function() {
							replaceStore.loadStoreRecords();
						},
						disabled: false
					},{ itemId	: 'confirmBtn',
						text	: '<t:message code="system.label.product.apply" default="적용"/>',
						handler	: function() {
							var results = replaceStore.sumBy(function(record, id) {				// 합계를 가지고 값구하기
									return true;
								},
								['ALLOCK_Q']
							);
							var total = results.ALLOCK_Q;

							if(total > replaceSearch.getValue('ALLOCK_Q')) {
								if(confirm('<t:message code="system.message.product.message019" default="기존 예약수량보다 대체품목 예약수량의 합이 큽니다. 계속 진행하시겠습니까?"/>')) {
									replaceGrid.returnData();
								} else {
									return false;
								}
							} else {
								replaceGrid.returnData();
							}
						},
						disabled: false
					},{ itemId	: 'confirmCloseBtn',
						text	: '<t:message code="system.label.product.afterapplyclose" default="적용 후 닫기"/>',
						handler	: function() {
							var results = replaceStore.sumBy(function(record, id) {				// 합계를 가지고 값구하기
									return true;
								},
								['ALLOCK_Q']
							);
							var total = results.ALLOCK_Q;

							if(total > replaceSearch.getValue('ALLOCK_Q')) {
								if(confirm('<t:message code="system.message.product.message019" default="기존 예약수량보다 대체품목 예약수량의 합이 큽니다. 계속 진행하시겠습니까?"/>')) {
									replaceGrid.returnData();
								} else {
									return false;
								}
							} else {
								replaceGrid.returnData();
							}
							ReplaceItemWindow.hide();
							UniAppManager.setToolbarButtons('reset', true)
						},
						disabled: false
					},{
						itemId	: 'closeBtn',
						text	: '<t:message code="system.label.product.close" default="닫기"/>',
						handler	: function() {
							ReplaceItemWindow.hide();
							UniAppManager.setToolbarButtons('reset', true)
						},
						disabled: false
					}
				],
				listeners : {
					beforehide: function(me, eOpt) {
						replaceSearch.clearForm();
						replaceGrid.reset();
					},
					beforeclose: function(panel, eOpts) {
						replaceSearch.clearForm();
						replaceGrid.reset();
					},
					beforeshow: function (me, eOpts) {
						var record = detailGrid.getSelectedRecord();
						replaceSearch.setValue('ITEM_CODE'	, record.get('ITEM_CODE'));
						replaceSearch.setValue('ITEM_NAME'	, record.get('ITEM_NAME'));
						replaceSearch.setValue('ALLOCK_Q'	, record.get('ALLOCK_Q'));
						replaceStore.loadStoreRecords();
					 }
				}
			})
		}
		ReplaceItemWindow.show();
		ReplaceItemWindow.center();
	}



	Unilite.Main({
		id			: 'pmp160ukrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	:[
				panelResult , masterGrid, detailGrid
			]
		}],
		fnInitBinding: function(params) {
			UniAppManager.setToolbarButtons(['reset', 'newData', 'prev', 'next'], true);
			this.setDefault();
			this.processParams(params);
//			this.processParams2(params);
		},
		onQueryButtonDown: function() {
			if(panelResult.setAllFieldsReadOnly(true) == false) {	// 필수값을 체크
				return false;
			} else {
				MasterStore.loadStoreRecords();
				beforeRowIndex = -1;
/*				if(panelSearch.getValue('WKORD_NUM') == ''){
					detailGrid.getStore().remove(records);
				}
				if(MasterStore.loadStoreRecords() != null	){
					detailStore.loadStoreRecords(records[0]);
				}
				panelSearch.setAllFieldsReadOnly(false);			*/
			}
		},
		onResetButtonDown: function() {
			this.suspendEvents();
			panelResult.clearForm();
			panelResult.setAllFieldsReadOnly(false);
			masterGrid.reset();
			detailGrid.reset();
			this.fnInitBinding();

		},
		onNewDataButtonDown: function() {
			var selectedRecord = masterGrid.getSelectedRecord();

			if(Ext.isEmpty(selectedRecord)) {
				Unilite.messageBox('<t:message code="system.message.product.datacheck002" default="선택된 자료가 없습니다."/>');
				return false;
			}
			//추가된 행의 각 컬럼의 데이터 정의
			var compCode		= UserInfo.compCode;
			var divCode			= panelResult.getValue('DIV_CODE');
			var wkordNum		= selectedRecord.get('WKORD_NUM');
			var workShopCode	= panelResult.getValue('WORK_SHOP_CODE');
			var unitQ			= '0';
			var allockQ			= '0';
			var pabStockQ		= '0';
			var shortageQ		= '0';
			var exchgExistYN	= 'N';
			var exchgYN			= 'N';
			var outMeth			= '1';
			var outstockReqDate	= selectedRecord.get('PRODT_START_DATE');;
			var outstockReqQ	= '0';
			var outstockQ		= '0';
			var outstockNum		= '*';
			var refType			= '';
			var remark			= selectedRecord.get('REMARK1');
			var projectNo		= selectedRecord.get('PROJECT_NO');
			var pjtCode			= selectedRecord.get('PJT_CODE');
			var grantType		= '2';
			var pathCode		= '0';
			var whCode			= selectedRecord.get('WH_CODE');
			var lossRate		= selectedRecord.get('LOSS_RATE');

			if(BsaCodeInfo.gsAutomatedIssuance == "Y") {
				var detailRecords = detailStore.data.items;
				Ext.each(detailRecords, function(rec, i){
					if(!Ext.isEmpty(rec.get('OUTSTOCK_NUM')) && rec.get('OUTSTOCK_NUM') != '*') {
						outstockNum = rec.get('OUTSTOCK_NUM');
					}
				});
			}

			//var r : 저장할 값 r에 입력
			var r = {
				COMP_CODE			: compCode,
				DIV_CODE			: divCode,
				WKORD_NUM			: wkordNum,
				WORK_SHOP_CODE		: workShopCode,
				UNIT_Q				: unitQ,
				ALLOCK_Q			: allockQ,
				PAB_STOCK_Q			: pabStockQ,
				SHORTAGE_Q			: shortageQ,
				EXCHG_EXIST_YN		: exchgExistYN,
				EXCHG_YN			: exchgYN,
				OUT_METH			: outMeth,
				OUTSTOCK_REQ_DATE	: outstockReqDate,
				OUTSTOCK_REQ_Q		: outstockReqQ,
				OUTSTOCK_Q			: outstockQ,
				OUTSTOCK_NUM		: outstockNum,
				REF_TYPE			: refType,
				REMARK				: remark,
				PROJECT_NO			: projectNo,
				PJT_CODE			: pjtCode,
				GRANT_TYPE			: grantType,
				PATH_CODE			: pathCode,
				WH_CODE				: whCode,
				//20180801 추가
				LOSS_RATE			: lossRate,
				//20200324 추가
				WEIGHT_RATE			: 1
			};
			detailGrid.createRow(r);
		},
		onDeleteDataButtonDown: function() {
			var selRow2 = detailGrid.getSelectedRecord();
			if(Ext.isEmpty(selRow2)){
				Unilite.messageBox('<t:message code="system.message.product.datacheck004" default="삭제할 자료가 없습니다."/>');
				return false;
			}
			if(selRow2.get('OUTSTOCK_REQ_Q') > 0 && BsaCodeInfo.gsAutomatedIssuance != "Y"){
				Unilite.messageBox('<t:message code="system.message.product.message006" default="출고요청된 수량이 있으므로 수정이 불가능합니다."/>');
				return false;
			}

			if(selRow2.get('OUTSTOCK_Q') > 0){
				Unilite.messageBox('<t:message code="system.message.product.message007" default="출고된 수량이 있으므로 수정이 불가능합니다."/>');
				return false;
			}

			if(selRow2.phantom == true) {
				detailGrid.deleteSelectedRow();
			} else if(confirm('<t:message code="system.message.product.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
				if(selRow2.get('OUTSTOCK_Q') > 0 ) {
					Unilite.messageBox('<t:message code="system.message.product.message024" default="출고가 진행중인 수주내역은 삭제가 불가능합니다."/>');
				}
				else if(selRow2.get('OUT_METH') == '3') {
					Unilite.messageBox('<t:message code="system.message.product.message008" default="출고방법이 작지동시인 품목은 수정/추가/삭제하실 수 없습니다."/>');
				} else {
					detailGrid.deleteSelectedRow();
				}
			}
			UniAppManager.setToolbarButtons('save', true);
			// fnOrderAmtSum 호출(grid summary 이용)
		},
		onSaveDataButtonDown: function(config) {
		//	MasterStore.saveStore();
			detailStore.saveStore();
		},
		rejectSave: function() {
			var rowIndex = masterGrid.getSelectedRowIndex();
			masterGrid.select(rowIndex);
			MasterStore.rejectChanges();

			if(rowIndex >= 0){
				masterGrid.getSelectionModel().select(rowIndex);
				var selected = masterGrid.getSelectedRecord();

				var selected_doc_no = selected.data['DOC_NO'];
				bdc100ukrvService.getFileList({DOC_NO : selected_doc_no}, function(provider, response) {
				});
			}
			MasterStore.onStoreActionEnable();
		},
		confirmSaveData: function(config) {
			var fp = Ext.getCmp('pmp160ukrvFileUploadPanel');
			if(MasterStore.isDirty() || fp.isDirty()) {
				if(confirm(Msg.sMB061)) {
					this.onSaveDataButtonDown(config);
				} else {
					this.rejectSave();
				}
			}
		},
		setDefault: function() {
			panelResult.setValue('DIV_CODE'				, UserInfo.divCode);
			panelResult.setValue('PRODT_START_DATE_FR'	, UniDate.get('mondayOfWeek'));
			panelResult.setValue('PRODT_START_DATE_TO'	, UniDate.get('endOfMonth'));
			panelResult.getForm().wasDirty = false;
			panelResult.resetDirtyStatus();
			Ext.getCmp('REPLACE_BTN').setDisabled(true);
			//20200403 추가: 예약자재 재생성 버튼 control
			detailGrid.down('#REGENERATION_BTN').disable();
			UniAppManager.setToolbarButtons('save', false);
		},
		checkForNewDetail:function() {
			if(Ext.isEmpty(panelResult.getValue('WORK_SHOP_CODE'))) {
				Unilite.messageBox('<t:message code="system.label.product.workcenter" default="작업장"/>:<t:message code="system.message.product.datacheck001" default="필수입력 항목입니다."/>');
				return false;
			}
			//마스터 데이타 수정 못 하도록 설정
			return panelResult.setAllFieldsReadOnly(true);
		},
		fnCheckNum: function(value, record, fieldName) {
			var r = true;
			if(record.get("PRICE_YN") == "1" || record.get("ACCOUNT_YNC")=="N") {
				r = true;
			} else if(record.get("PRICE_YN") == "2" ) {
				if(value < 0) {
					Unilite.messageBox(Msg.sMB076);
					r=false;
					return r;
				} else if(value == 0) {
					if(fieldName == "ORDER_TAX_O") {
						if(BsaCodeInfo.gsVatRate != 0) {
							Unilite.messageBox(Msg.sMB083);
							r=false;
						}
					} else {
						Unilite.messageBox(Msg.sMB083);
						r=false;
					}
				}
			}
			return r;
		},
		//링크로 넘어오는 params 받는 부분 (pmp110ukrv)
		processParams: function(params) {
			this.uniOpt.appParams = params;
			if(params && params.DIV_CODE){
				if(params.wkordNumList) {
					panelResult.setValue('PRODT_START_DATE_FR'	, '');
					panelResult.setValue('PRODT_START_DATE_TO'	, '');
					panelResult.setValue('WORK_SHOP_CODE'		, params.WORK_SHOP_CODE);
					masterGrid.getStore().loadStoreRecords(params.wkordNumList);
				} else {
					panelResult.setValue('DIV_CODE',params.DIV_CODE);
					panelResult.setValue('PRODT_START_DATE_FR'	, '');
					panelResult.setValue('PRODT_START_DATE_TO'	, '');
					panelResult.setValue('WORK_SHOP_CODE'		, params.WORK_SHOP_CODE);
					panelResult.setValue('WKORD_NUM_FR'			, params.WKORD_NUM);
					panelResult.setValue('WKORD_NUM_TO'			, params.WKORD_NUM);
					panelResult.setValue('REMARK'				, params.REMARK);

					masterGrid.getStore().loadStoreRecords();

	/*				넘어온 조건을 수정하지 못하도록 처리
	 				panelSearch.getField('DIV_CODE').setReadOnly( true );
					panelSearch.getField('PRODT_START_DATE_FR').setReadOnly( true );
					panelSearch.getField('PRODT_START_DATE_TO').setReadOnly( true );
					panelSearch.getField('WORK_SHOP_CODE').setReadOnly( true );
					panelSearch.getField('WKORD_NUM_FR').setReadOnly( true );
					panelSearch.getField('WKORD_NUM_TO').setReadOnly( true );

					panelResult.getField('DIV_CODE').setReadOnly( true );
					panelResult.getField('PRODT_START_DATE_FR').setReadOnly( true );
					panelResult.getField('PRODT_START_DATE_TO').setReadOnly( true );
					panelResult.getField('WORK_SHOP_CODE').setReadOnly( true );
					panelResult.getField('WKORD_NUM_FR').setReadOnly( true );
					panelResult.getField('WKORD_NUM_TO').setReadOnly( true );
	*/
				}
			}
		},
		//링크로 넘어오는 params 받는 부분 (s_pmp100skrv_in)
		processParams2: function(params) {
			this.uniOpt.appParams = params;
			if(params && params.DIV_CODE) {
				panelResult.setValue('DIV_CODE',params.DIV_CODE);
				panelResult.setValue('PRODT_START_DATE_FR','');
				panelResult.setValue('PRODT_START_DATE_TO','');
				panelResult.setValue('WORK_SHOP_CODE',params.WORK_SHOP_CODE);
				panelResult.setValue('REMARK',params.REMARK);
				panelResult.setValue('WKORD_NUM_FR',params.WKORD_NUM);
				panelResult.setValue('WKORD_NUM_TO',params.WKORD_NUM);
				//panelResult.setValue('LOT_NO_FR',params.LOT_NO);
				//panelResult.setValue('LOT_NO_TO',params.LOT_NO);
				masterGrid.getStore().loadStoreRecords();
			}
		}
	});



	/** Validation
	 */
/*	Unilite.createValidator('validator01', {	//Grid 1 createValidator
		store: MasterStore,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
			}
			return rv;
		}
	}); // validator
*/

	Unilite.createValidator('validator', {		//Grid 2 createValidator
		store: detailStore,
		grid: detailGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;

			if(record.get('OUTSTOCK_REQ_Q') > 0 && BsaCodeInfo.gsAutomatedIssuance != "Y"){
				Unilite.messageBox('<t:message code="system.message.product.message006" default="출고요청된 수량이 있으므로 수정이 불가능합니다."/>');
				return false;
			}
			if(record.get('OUTSTOCK_Q') > 0){
				Unilite.messageBox('<t:message code="system.message.product.message007" default="출고된 수량이 있으므로 수정이 불가능합니다."/>');
				return false;
			}
			var selectedMRecord = masterGrid.getSelectedRecord();				//작업지시량

			switch(fieldName) {
				case "UNIT_Q" : // "원단위량"
					if(newValue <= 0 ){
						rv='<t:message code="system.message.product.message023" default="입력한 값이 0보다 큰 수이어야 합니다."/>';			//0보다 큰수만 입력가능합니다.
					break;
					}
					var resultCalc = newValue * selectedMRecord.get('WKORD_Q') * ( 1 + (record.get('LOSS_RATE') / 100) );
					record.set('ALLOCK_Q', resultCalc);

					//출고요청자동생성여부(P109)가 Y이면 출고요청량 변경 후, 저장
					if(BsaCodeInfo.gsAutomatedIssuance == "Y") {
						record.set('OUTSTOCK_REQ_Q', resultCalc);
					}
				break;

				case "ALLOCK_Q" : // "예약수량"
					if(newValue <= 0 ){
						rv= Msg.sMB076;
						//alert("0보다 큰수만 입력가능 합니다.");
						break;
					}
					var resultCalc = newValue / ( 1 + (record.get('LOSS_RATE') / 100) ) / selectedMRecord.get('WKORD_Q');
					record.set('UNIT_Q', resultCalc);
	
					//출고요청자동생성여부(P109)가 Y이면 출고요청량 변경 후, 저장
					if(BsaCodeInfo.gsAutomatedIssuance == "Y") {
						record.set('OUTSTOCK_REQ_Q', newValue);
					}
					break;
	
/*				case "ITEM_CODE" : // 자품목코드	자품목코드가 "" 이면 자품목명, 규격, 단위도 ""
					if(newValue   == "") {
						record.get('ITEM_NAME')  == "";
						record.get('SPEC') 		 == "";
						record.get('STOCK_UNIT') == "";
					}
	
				case "ITEM_NAME" : // 자품목명	   자품목명이 "" 이면 자품목코드, 규격, 단위도 ""
					if(newValue   == ""){
						record.get('ITEM_CODE')  == "";
						record.get('SPEC') 		 == "";
						record.get('STOCK_UNIT') == "";
					}																*/
	
				case "OUT_METH" : // 출고방법
					if(newValue == "2") {
						if(BsaCodeInfo.gsWorkWhcode =='N') {
							record.set('WH_CODE', '');
						}						
						break;
					}				
					if(newValue == "3") {
						rv='<t:message code="system.message.product.message052" default="작지동시 출고는 선택하실 수 없습니다."/>';
						//작지동시 출고는 선택하실 수 없습니다.
						break;
					}
					if(newValue != "1" && newValue != "2" && newValue != "3") {
						rv='<t:message code="system.message.product.message053" default="정확한 코드를 입력하십시오."/>';  // 공정명이 오류일 때
						//정확한 코드를 입력하십시오.
						break;
					}
					break;
			}
			return rv;
		}
	});
}
</script>