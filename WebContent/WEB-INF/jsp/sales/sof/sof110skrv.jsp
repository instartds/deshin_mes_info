<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="sof110skrv"  >
	<t:ExtComboStore comboType="BOR120"  pgmId="sof110skrv"/>	<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="S010" />			<!--영업담당 -->
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}

.x-change-cell_DrvyOver {
	//background-color: #FDE3FF;
	color: #FF0000;
}
.x-change-cell_DrvySoon {
	//background-color: #F3E2A9;
	color: #FFB000;
}

</style>
</t:appConfig>
<script type="text/javascript" >
var beforeRowIndex;	//마스터그리드 같은row중복 클릭시 다시 load되지 않게


function appMain() {
	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('Sof110skrvModel1', {
		fields: [
			{name: 'DIV_CODE'			,text: '<t:message code="system.label.sales.division" default="사업장"/>'						,type: 'string'},
			{name: 'OUT_DIV_CODE'		,text: '<t:message code="system.label.sales.issuedivision" default="출고사업장"/>'				,type: 'string',comboType: 'BOR120'},
			{name: 'ORDER_NUM'			,text: '<t:message code="system.label.sales.sono" default="수주번호"/>'							,type: 'string'},
			{name: 'STATUS'				,text: '<t:message code="system.label.sales.status" default="상태"/>'							,type: 'string'},
			{name: 'SER_NO'				,text: '<t:message code="system.label.sales.seq" default="순번"/>'							,type: 'int'},
			{name: 'PROJECT_NO'			,text: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'					,type: 'string'},
			{name: 'PO_NUM'				,text: 'P/O No.' 		,type: 'string'},
			{name: 'ORDER_PRSN'			,text: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'					,type: 'string'},
			{name: 'ORDERPRSN_NAME'		,text: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'					,type: 'string'},
			{name: 'ORDER_TYPE'			,text: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>'					,type: 'string'},
			{name: 'ORDERTYPE_NAME'		,text: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>'					,type: 'string'},
			{name: 'CUSTOM_CODE'		,text: '<t:message code="system.label.sales.custom" default="거래처"/>'						,type: 'string'},
			{name: 'CUSTOM_NAME'		,text: '<t:message code="system.label.sales.custom" default="거래처"/>'						,type: 'string'},
			{name: 'ITEM_CODE'			,text: '<t:message code="system.label.sales.item" default="품목"/>'							,type: 'string'},
			{name: 'ITEM_NAME'			,text: '<t:message code="system.label.sales.itemname" default="품목명"/>'						,type: 'string'},
			{name: 'ITEM_NAME1'			,text: '<t:message code="system.label.sales.itemname" default="품목명"/>1' 					,type: 'string'},
			{name: 'SPEC'				,text: '<t:message code="system.label.sales.spec" default="규격"/>'							,type: 'string'},
			{name: 'ORDER_DATE'			,text: '<t:message code="system.label.sales.sodate" default="수주일"/>'						,type: 'uniDate'},
			{name: 'DVRY_DATE'			,text: '<t:message code="system.label.sales.deliverydate" default="납기일"/>'					,type: 'uniDate'},
			{name: 'DVRY_TIME'	 		,text: '<t:message code="system.label.sales.deliverytime" default="납기시간"/>'					,type: 'uniDate'},
			{name: 'PROD_END_DATE'		,text: '<t:message code="system.label.sales.productionrequestdate" default="생산요청일"/>'		,type: 'uniDate'},
			{name: 'ORDER_Q'			,text: '<t:message code="system.label.sales.soqty" default="수주량"/>'							,type: 'uniQty'},
			{name: 'PROD_Q'				,text: '<t:message code="system.label.sales.productionrequestqty" default="생산요청량"/>'		,type: 'uniQty'},
			{name: 'WK_PLAN_Q'			,text: '<t:message code="system.label.sales.productionplanqty" default="생산계획량"/>'			,type: 'uniQty'},
			{name: 'WKORD_Q'			,text: '<t:message code="system.label.sales.workorderqty" default="작업지시량"/>'				,type: 'uniQty'},
			{name: 'PRODT_Q'			,text: '<t:message code="system.label.sales.productionresultqty" default="생산실적량"/>'			,type: 'uniQty'},
			{name: 'IN_STOCK_Q'			,text: '<t:message code="system.label.sales.productionreceiptqty" default="생산입고량"/>'		,type: 'uniQty'},
			{name: 'ISSUE_REQ_Q'		,text: '<t:message code="system.label.sales.shipmentorderqty" default="출하지시량"/>'			,type: 'uniQty'},
			{name: 'ISSUE_Q'			,text: '<t:message code="system.label.sales.issueqty" default="출고량"/>'						,type: 'uniQty'},
			{name: 'SALE_Q'				,text: '<t:message code="system.label.sales.salesqtybill" default="매출량(계산서)"/>'				,type: 'uniQty'},
			{name: 'REMARK'				,text: '<t:message code="system.label.sales.remarks" default="비고"/>'						,type: 'string'},
			{name: 'ISSUE_DATE'			,text: '<t:message code="system.label.sales.issuedate" default="출고일"/>'						,type: 'string'},
			{name: 'DVRY_FOLLOW'		,text: '<t:message code="system.label.sales.deliveryobservance" default="납기준수"/>'			,type: 'string'},
			{name: 'DVRY_FOLLOW_RATE'	,text: '<t:message code="system.label.sales.deliverydatecompliancerate" default="납기준수율"/>'	,type: 'float', format:'00.00'},
			//20200120 추가
			{name: 'INSERT_DB_USER'		,text: '<t:message code="system.label.sales.entryuser" default="등록자"/>'						,type: 'string'},
			{name: 'UPDATE_DB_USER'		,text: '<t:message code="system.label.sales.updateuser" default="수정자"/>'					,type: 'string'},
			// 20210604 추가
			{name: 'ORDER_O'				, text:'<t:message code="system.label.sales.amount" default="금액"/>'						, type: 'uniPrice'},
			{name: 'ORDER_P'				, text:'<t:message code="system.label.sales.price" default="단가"/>'						, type: 'uniUnitPrice'}
		]
	});

	Unilite.defineModel('Sof110skrvModel2', {
		fields: [
			{name: 'WK_PLAN_NUM'		,text: '<t:message code="system.label.sales.productionplanno" default="생산계획번호"/>'	,type: 'string'},
			{name: 'WKORD_NUM'			,text: '<t:message code="system.label.sales.workorderno" default="작업지시번호"/>'		,type: 'string'},
			{name: 'WORK_SHOP_CODE'		,text: '<t:message code="system.label.sales.workcentercode" default="작업장코드"/>'		,type: 'string'},
			{name: 'WORKSHOP_NAME'		,text: '<t:message code="system.label.sales.workcenter" default="작업장"/>'			,type: 'string'},
			{name: 'ITEM_CODE'			,text: '<t:message code="system.label.sales.item" default="품목"/>'					,type: 'string'},
			{name: 'ITEM_NAME'			,text: '<t:message code="system.label.sales.itemname" default="품목명"/>'				,type: 'string'},
			{name: 'ITEM_NAME1'			,text: '<t:message code="system.label.sales.itemname" default="품목명"/>1' 			,type: 'string'},
			{name: 'SPEC'				,text: '<t:message code="system.label.sales.spec" default="규격"/>'					,type: 'string'},
			{name: 'PROG_UNIT'			,text: '<t:message code="system.label.sales.unit" default="단위"/>'					,type: 'string'},
			{name: 'PRODT_START_DATE'	,text: '<t:message code="system.label.sales.plannedstartdate" default="착수예정일"/>'	,type: 'string'},
			{name: 'PRODT_END_DATE'		,text: '<t:message code="system.label.sales.completiondate" default="완료예정일"/>'		,type: 'string'},
			{name: 'PROG_WORK_CODE'		,text: '<t:message code="system.label.sales.routingcode" default="공정코드"/>'			,type: 'string'},
			{name: 'PROGWORK_NAME'		,text: '<t:message code="system.label.sales.routingname" default="공정명"/>'			,type: 'string'},
			{name: 'WKORD_Q'			,text: '<t:message code="system.label.sales.ordersqty" default="지시량"/>'				,type: 'uniQty'},
			{name: 'PRODT_Q'			,text: '<t:message code="system.label.sales.productionqty" default="생산량"/>'			,type: 'uniQty'},
			{name: 'BAL_Q'				,text: '<t:message code="system.label.sales.balanceqty" default="잔량"/>'				,type: 'uniQty'},
			{name: 'REMARK'				,text: '<t:message code="system.label.sales.remarks" default="비고"/>'				,type: 'string'},
			//20200120 추가
			{name: 'INSERT_DB_USER'		,text: '<t:message code="system.label.sales.entryuser" default="등록자"/>'				,type: 'string'},
			{name: 'UPDATE_DB_USER'		,text: '<t:message code="system.label.sales.updateuser" default="수정자"/>'			,type: 'string'}
		]
	});

	Unilite.defineModel('Sof110skrvModel3', {
		fields: [
			{name: 'TYPE_FLAG'		,text: '<t:message code="system.label.sales.productiontype" default="생산유형"/>'		,type: 'string'},
			{name: 'WK_PLAN_NUM'	,text: '<t:message code="system.label.sales.productionplanno" default="생산계획번호"/>'	,type: 'string'},
			{name: 'ORDER_NUM'		,text: '<t:message code="system.label.sales.pono" default="발주번호"/>'					,type: 'string'},
			{name: 'ORDER_SEQ'		,text: '<t:message code="system.label.sales.seq" default="순번"/>'					,type: 'int'},
			{name: 'ORDER_TYPE'		,text: '<t:message code="system.label.sales.type" default="유형"/>'					,type: 'string'},
			{name: 'ORDERTYPE_NAME'	,text: '<t:message code="system.label.sales.type" default="유형"/>'					,type: 'string'},
			{name: 'CUSTOM_CODE'	,text: '<t:message code="system.label.sales.customcode" default="거래처코드"/>'			,type: 'string'},
			{name: 'CUSTOM_NAME'	,text: '<t:message code="system.label.sales.custom" default="거래처"/>'				,type: 'string'},
			{name: 'ITEM_CODE'		,text: '<t:message code="system.label.sales.itemcode" default="품목코드"/>'				,type: 'string'},
			{name: 'ITEM_NAME'		,text: '<t:message code="system.label.sales.itemname" default="품목명"/>'				,type: 'string'},
			{name: 'SPEC'			,text: '<t:message code="system.label.sales.spec" default="규격"/>'					,type: 'string'},
			{name: 'ORDER_DATE'		,text: '<t:message code="system.label.sales.podate" default="발주일"/>'				,type: 'uniDate'},
			{name: 'DVRY_DATE'		,text: '<t:message code="system.label.sales.deliverydate" default="납기일"/>'			,type: 'uniDate'},
			{name: 'ORDER_UNIT'		,text: '<t:message code="system.label.sales.unit" default="단위"/>'					,type: 'string'},
			{name: 'ORDER_Q'		,text: '<t:message code="system.label.sales.poqty" default="발주량"/>'					,type: 'uniQty'},
			{name: 'INSTOCK_Q'		,text: '<t:message code="system.label.sales.receiptqty" default="입고량"/>'			,type: 'uniQty'},
			{name: 'BAL_Q'			,text: '<t:message code="system.label.sales.balanceqty" default="잔량"/>'				,type: 'uniQty'},
			{name: 'REMARK'			,text: '<t:message code="system.label.sales.remarks" default="비고"/>'				,type: 'string'},
			//20200120 추가
			{name: 'INSERT_DB_USER'		,text: '<t:message code="system.label.sales.entryuser" default="등록자"/>'			,type: 'string'},
			{name: 'UPDATE_DB_USER'		,text: '<t:message code="system.label.sales.updateuser" default="수정자"/>'		,type: 'string'}
		]
	});

	//20200120 추가
	Unilite.defineModel('Sof110skrvModel4', {
		fields: [
			{name: 'TYPE'				,text: '<t:message code="system.label.sales.type" default="유형"/>'				,type: 'string'},
			{name: 'WK_PLAN_NUM'		,text: 'WK_PLAN_NUM'	,type: 'string'},
			{name: 'ORDER_NUM'			,text: '<t:message code="system.label.sales.orderno2" default="오더번호"/>'			,type: 'string'},
			{name: 'ORDER_SEQ'			,text: '<t:message code="system.label.sales.seq" default="순번"/>'				,type: 'int'},
			{name: 'CLASSFICATION_CD'	,text: 'CUSTOM_CODE'	,type: 'string'},
			{name: 'CLASSFICATION'		,text: '<t:message code="system.label.base.classfication" default="구분"/>'		,type: 'string'},
			{name: 'ITEM_CODE'			,text: '<t:message code="system.label.sales.itemcode" default="품목코드"/>'			,type: 'string'},
			{name: 'ITEM_NAME'			,text: '<t:message code="system.label.sales.itemname" default="품목명"/>'			,type: 'string'},
			{name: 'SPEC'				,text: '<t:message code="system.label.sales.spec" default="규격"/>'				,type: 'string'},
			{name: 'ORDER_UNIT'			,text: '<t:message code="system.label.sales.unit" default="단위"/>'				,type: 'string'},
			{name: 'ORDER_DATE'			,text: '<t:message code="system.label.sales.instructiondate" default="지시일"/>'	,type: 'uniDate'},
			{name: 'DUE_DATE'			,text: '<t:message code="system.label.sales.duedate2" default="예정일"/>'			,type: 'uniDate'},
			{name: 'ORDER_Q'			,text: '<t:message code="system.label.sales.ordersqty" default="지시량"/>'			,type: 'uniQty'},
			{name: 'INSTOCK_Q'			,text: '<t:message code="system.label.sales.receiptqty" default="입고량"/>'		,type: 'uniQty'},
			{name: 'BAL_Q'				,text: '<t:message code="system.label.sales.balanceqty" default="잔량"/>'			,type: 'uniQty'},
			{name: 'REMARK'				,text: '<t:message code="system.label.sales.remarks" default="비고"/>'			,type: 'string'},
			{name: 'INSERT_DB_USER'		,text: '<t:message code="system.label.sales.entryuser" default="등록자"/>'			,type: 'string'},
			{name: 'UPDATE_DB_USER'		,text: '<t:message code="system.label.sales.updateuser" default="수정자"/>'		,type: 'string'}
		]
	});



	/** Store 정의(Service 정의)
	 * @type
	 */
	var masterStore = Unilite.createStore('sof110skrvMasterStore1',{
		model	: 'Sof110skrvModel1',
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api	: {
				read: 'sof110skrvService.selectList'
			}
		},
		loadStoreRecords : function() {
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params : param,
				callback: function() {
					if(masterStore.getCount() > 0) {
						panelResult.setValue('DRVY_FOLLOW_RATE'	, masterStore.data.items[0].data.DVRY_FOLLOW_RATE);
						//20200120 추가
						panelResult.down('#SHOW_DETAIL').setHtml(masterStore.data.items[0].data.SHOW_DETAIL);
					} else {
						panelResult.setValue('DRVY_FOLLOW_RATE'	, 0);
						//20200120 추가
						panelResult.down('#SHOW_DETAIL').setHtml('( 0 / 0 )');
					}
				}
			});
		},
		groupField: 'CUSTOM_CODE'
	});

	var detailStore = Unilite.createStore('sof110skrvMasterStore2',{
		model	: 'Sof110skrvModel2',
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api	: {
				read: 'sof110skrvService.detailList'
			}
		},
		loadStoreRecords : function(record){
			var gridParam = record.data;
			var formParam = {};
			formParam.DIV_CODE = panelSearch.getField('DIV_CODE').getValue();
			var params = Ext.merge(gridParam, formParam);
			this.load({
				params : params
			});
		}
	});

	var detailStore2 = Unilite.createStore('sof110skrvMasterStore3',{
		model	: 'Sof110skrvModel3',
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api	: {
				read: 'sof110skrvService.detailList2'
			}
		},
		loadStoreRecords : function(record){
			var gridParam		= record.data;
			gridParam.USER_LANG	= UserInfo.userLang == 'KO' ? '' : UserInfo.userLang;
			var formParam		= {};
			formParam.DIV_CODE = panelSearch.getField('DIV_CODE').getValue();
			var params = Ext.merge(gridParam, formParam);
			this.load({
				params : params
			});
		}
	});

	//20200120 추가
	var detailStore3 = Unilite.createStore('sof110skrvMasterStore4',{
		model	: 'Sof110skrvModel4',
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api	: {
				read: 'sof110skrvService.detailListAll'
			}
		},
		loadStoreRecords : function(record){
			var gridParam		= record.data;
			gridParam.USER_LANG	= UserInfo.userLang == 'KO' ? '' : UserInfo.userLang;
			var formParam		= {};
			formParam.DIV_CODE = panelSearch.getField('DIV_CODE').getValue();
			var params = Ext.merge(gridParam, formParam);
			this.load({
				params : params
			});
		}
	});



	/** 검색조건 (Search Panel)
	 * @type
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title		: '<t:message code="system.label.sales.searchconditon" default="검색조건"/>',
		defaultType	: 'uniSearchSubPanel',
		collapsed	: UserInfo.appOption.collapseLeftSearch,
		listeners	: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
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
			xtype			: 'uniDateRangefield',
			startFieldName	: 'ORDER_DATE_FR',
			endFieldName	: 'ORDER_DATE_TO',
			width			: 470,
			startDate		: UniDate.get('startOfMonth'),
			endDate			: UniDate.get('today'),
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelResult) {
					panelResult.setValue('ORDER_DATE_FR',newValue);
					//panelResult.getField('ISSUE_REQ_DATE_FR').validate();
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelResult) {
					panelResult.setValue('ORDER_DATE_TO',newValue);
					//panelResult.getField('ISSUE_REQ_DATE_TO').validate();
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>',
			xtype		: 'uniTextfield',
			name		: 'PROJECT_NO',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelResult.setValue('PROJECT_NO', newValue);
				}
			}
		},
		Unilite.popup('AGENT_CUST',{
			fieldLabel		: '<t:message code="system.label.sales.custom" default="거래처"/>',
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
			validateBlank	: false,
			listeners: {
				onValueFieldChange: function(field, newValue, oldValue){
					panelResult.setValue('CUSTOM_CODE', newValue);

					if(!Ext.isObject(oldValue)) {
						panelSearch.setValue('CUSTOM_NAME', '');
						panelResult.setValue('CUSTOM_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue){
					panelResult.setValue('CUSTOM_NAME', newValue);

					if(!Ext.isObject(oldValue)) {
						panelSearch.setValue('CUSTOM_CODE', '');
						panelResult.setValue('CUSTOM_CODE', '');
					}
				}
			}
		}),{
			xtype			: 'container',
			defaultType		: 'uniTextfield',
			layout			: {type: 'uniTable', columns: 1},
			width			: 315,
			items			: [{
				xtype		: 'uniTextfield',
				fieldLabel	: '<t:message code="system.label.sales.sono" default="수주번호"/>',
				name		: 'ORDER_NUM_FR',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ORDER_NUM_FR', newValue);
					}
				}
			},{
				xtype		: 'uniTextfield',
				fieldLabel	: '~',
				name		: 'ORDER_NUM_TO',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ORDER_NUM_TO', newValue);
					}
				}
			}]
		},{
			fieldLabel	: '<t:message code="system.label.sales.issuedivision" default="출고사업장"/>',
			name		: 'OUT_DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					panelResult.setValue('OUT_DIV_CODE', newValue);
				}
			}
		}]},{
			title		: '<t:message code="system.label.sales.additionalinfo" default="추가정보"/>',
			itemId		: 'search_panel2',
			layout		: {type: 'uniTable', columns: 1},
			defaultType	: 'uniTextfield',
			items		: [{
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
			},{
				fieldLabel		: '<t:message code="system.label.sales.deliverydate" default="납기일"/>',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'DVRY_DATE_FR',
				endFieldName	: 'DVRY_DATE_TO',
				width			: 470
			},
			Unilite.popup('DIV_PUMOK',{
				fieldLabel		: '<t:message code="system.label.sales.item" default="품목"/>',
				valueFieldName	: 'ITEM_CODE',
				textFieldName	: 'ITEM_NAME',
				validateBlank	: false,
				listeners: {
					onValueFieldChange: function(field, newValue, oldValue){
						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('ITEM_NAME', '');
						}
					},
					onTextFieldChange: function(field, newValue, oldValue){
						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('ITEM_CODE', '');
						}
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
			}),{
				fieldLabel		: '<t:message code="system.label.sales.productionrequestdate" default="생산요청일"/>',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'PROD_END_DATE_FR',
				endFieldName	: 'PROD_END_DATE_TO',
				width			: 470
			},{
				fieldLabel	: 'P/O No.',
				xtype		: 'uniTextfield',
				name		: 'PO_NUM',
				width		: 325
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
		layout	: {type : 'uniTable', columns : 5
//		,tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/}
//		,tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
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
			xtype			: 'uniDateRangefield',
			startFieldName	: 'ORDER_DATE_FR',
			endFieldName	: 'ORDER_DATE_TO',
			width			: 315,
			startDate		: UniDate.get('startOfMonth'),
			endDate			: UniDate.get('today'),
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
			fieldLabel	: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>',
			xtype		: 'uniTextfield',
			name		: 'PROJECT_NO',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('PROJECT_NO', newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.deliverydatecompliancerate" default="납기준수율"/>(%)',
			xtype		: 'uniNumberfield',
			name		: 'DRVY_FOLLOW_RATE',
			decimalPrecision: 2,
			readOnly	: true
		},{	//20200120 추가
			xtype	: 'component',
			name	: 'SHOW_DETAIL',
			itemId	: 'SHOW_DETAIL',
			align	: 'center',
			tdAttrs	: {align : 'center'},
			width	: 100,
			readOnly: true
		},
		Unilite.popup('AGENT_CUST',{
			fieldLabel		: '<t:message code="system.label.sales.custom" default="거래처"/>',
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
			validateBlank	: false,
			listeners: {
				onValueFieldChange: function(field, newValue, oldValue){
					panelSearch.setValue('CUSTOM_CODE', newValue);

					if(!Ext.isObject(oldValue)) {
						panelSearch.setValue('CUSTOM_NAME', '');
						panelResult.setValue('CUSTOM_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue){
					panelSearch.setValue('CUSTOM_NAME', newValue);

					if(!Ext.isObject(oldValue)) {
						panelSearch.setValue('CUSTOM_CODE', '');
						panelResult.setValue('CUSTOM_CODE', '');
					}
				}
			}
		}),{
			xtype		: 'container',
			defaultType	: 'uniTextfield',
			layout		: {type: 'uniTable', columns: 2},
			items		: [{
				fieldLabel	: '<t:message code="system.label.sales.sono" default="수주번호"/>',
				xtype		: 'uniTextfield',
				name		: 'ORDER_NUM_FR',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('ORDER_NUM_FR', newValue);
					}
				}
			},{
				fieldLabel	: '~',
				xtype		: 'uniTextfield',
				labelWidth	: 5,
				name		: 'ORDER_NUM_TO',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('ORDER_NUM_TO', newValue);
					}
				}
			}]
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
		},{
			fieldLabel	: '<t:message code="system.label.sales.issuedivision" default="출고사업장"/>',
			name		: 'OUT_DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					panelSearch.setValue('OUT_DIV_CODE', newValue);
				}
			}
		}]
	});



	/** Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('sof110skrvGrid1', {
		store	: masterStore,
		layout	: 'fit',
		region	: 'center',
		uniOpt	:{
			expandLastColumn	: false,
			useRowNumberer		: false,
			useMultipleSorting	: true
		},
		selModel: 'rowmodel',
		features: [ {id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false },
					{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false}],
		viewConfig: {
			getRowClass: function(record, rowIndex, rowParams, store){		//오류 row 빨간색 표시
				var cls = '';
				var val = record.get('DVRY_FOLLOW');
				//	하단 로직에서 사용중인 style class 는 현재 페이지 상단에 선언되어 있음.
				if (val == '초과') {
					cls = 'x-change-cell_DrvyOver';
				}
				else {
					if (val == '납품중' && masterGrid.fnGetDrvyArrivalYn(val))
						cls = 'x-change-cell_DrvySoon';
					else
						cls = '';
				}
				return cls;
			}
		},
		columns: [
			{ dataIndex: 'DIV_CODE'			, width: 66, hidden: true },
			{ dataIndex: 'OUT_DIV_CODE'		, width: 100 },
			{ dataIndex: 'ORDER_NUM'		, width: 120 },
			{ dataIndex: 'SER_NO'			, width: 50 },
			{ dataIndex: 'STATUS'			, width: 53 },
			{ dataIndex: 'CUSTOM_CODE'		, width: 66, hidden: true },
			{ dataIndex: 'CUSTOM_NAME'		, width: 120 },
			{ dataIndex: 'ITEM_CODE'		, width: 120 },
			{ dataIndex: 'ITEM_NAME'		, width: 160 },
			{ dataIndex: 'ITEM_NAME1'		, width: 160, hidden: true},
			{ dataIndex: 'SPEC'				, width: 120 },
			{ dataIndex: 'ORDER_DATE'		, width: 90 },
			{ dataIndex: 'ORDER_Q'			, width: 93 },
			{ dataIndex: 'ORDER_P'			, width: 93 },
			{ dataIndex: 'ORDER_O'			, width: 93 },
			{ dataIndex: 'PROD_Q'			, width: 93 },
			{ dataIndex: 'WK_PLAN_Q'		, width: 93 },
			{ dataIndex: 'WKORD_Q'			, width: 93 },
			{ dataIndex: 'PRODT_Q'			, width: 93 },
			{ dataIndex: 'IN_STOCK_Q'		, width: 93 },
			{ dataIndex: 'ISSUE_REQ_Q'		, width: 93 },
			{ dataIndex: 'ISSUE_Q'			, width: 93 },
			{ dataIndex: 'SALE_Q'			, width: 110 },
			{ dataIndex: 'PROJECT_NO'		, width: 110 },
			{ dataIndex: 'PO_NUM'			, width: 100, align: 'center'},
			{ dataIndex: 'DVRY_DATE'		, width: 90 },
			{ dataIndex: 'ISSUE_DATE'		, width: 90 },
			{ dataIndex: 'DVRY_FOLLOW'		, width: 90 },
//			{ dataIndex: 'DVRY_FOLLOW_RATE'	, width: 90 },
			{ dataIndex: 'DVRY_TIME'		, width: 90 },
			{ dataIndex: 'PROD_END_DATE'	, width: 90 },
			{ dataIndex: 'ORDER_PRSN'		, width: 66, hidden: true },
			{ dataIndex: 'ORDERPRSN_NAME'	, width: 66 },
			{ dataIndex: 'ORDER_TYPE'		, width: 66, hidden: true },
			{ dataIndex: 'ORDERTYPE_NAME'	, width: 93 },
			{ dataIndex: 'REMARK'			, width: 166 },
			//20200120 추가
			{ dataIndex: 'INSERT_DB_USER'	, width: 200 , align: 'center' , hidden: true},
			{ dataIndex: 'UPDATE_DB_USER'	, width: 200 , align: 'center' , hidden: true}
		],
		listeners: {
			cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
				if(rowIndex != beforeRowIndex){
					var activeTabId = tab.getActiveTab().getId();
					if(activeTabId == 'sof110skrvGridTab1') {
						detailStore.loadStoreRecords(record);
					} else if(activeTabId == 'sof110skrvGridTab2') {
						detailStore2.loadStoreRecords(record);
					} else {
						detailStore3.loadStoreRecords(record);
					}
				}
				beforeRowIndex = rowIndex;
			}
		},
		fnGetDrvyArrivalYn: function(val) {
			var date = val.split(".");
			var drvyDate = new Date(Number(date[0]), Number(date[1]) - 1, Number(date[2]));
			
			date = UniDate.get('today').split(".");
			var today = new Date(Number(date[0]), Number(date[1]) - 1, Number(date[2]));

			var threeDaysAfterToday = today;
			threeDaysAfterToday.setDate(threeDaysAfterToday.getDate() + 3);

			if(drvyDate >= today && drvyDate <= threeDaysAfterToday) {
				return true;
			}
			return false;
		}
	});

	var detailGrid = Unilite.createGrid('sof110skrvGrid2', {
		store	: detailStore,
		layout	: 'fit',
		region	: 'center',
		flex	: 1,
		features: [ {id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false },
					{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false}],
		columns	: [
			{ dataIndex: 'WK_PLAN_NUM'		, width: 120 },
			{ dataIndex: 'WKORD_NUM'		, width: 120 },
			{ dataIndex: 'WORK_SHOP_CODE'	, width: 100, hidden: true },
			//20191023 작업장 명 보이도록 수정
			{ dataIndex: 'WORKSHOP_NAME'	, width: 100 , align: 'center'},
			{ dataIndex: 'ITEM_CODE'		, width: 100 },
			{ dataIndex: 'ITEM_NAME'		, width: 240 },
			{ dataIndex: 'ITEM_NAME1'		, width: 240, hidden: true},
			{ dataIndex: 'SPEC'				, width: 100 },
			{ dataIndex: 'PROG_UNIT'		, width: 80 },
			{ dataIndex: 'PRODT_START_DATE'	, width: 90 },
			{ dataIndex: 'PRODT_END_DATE'	, width: 90 },
			{ dataIndex: 'PROG_WORK_CODE'	, width: 100, hidden: true },
			{ dataIndex: 'PROGWORK_NAME'	, width: 120 },
			{ dataIndex: 'WKORD_Q'			, width: 100 },
			{ dataIndex: 'PRODT_Q'			, width: 100 },
			{ dataIndex: 'BAL_Q'			, width: 100 },
			{ dataIndex: 'REMARK'			, width: 166 },
			//20200120 추가
			{ dataIndex: 'INSERT_DB_USER'	, width: 200 , align: 'center' , hidden: true},
			{ dataIndex: 'UPDATE_DB_USER'	, width: 200 , align: 'center' , hidden: true}
		]
	});

	var detailGrid2 = Unilite.createGrid('sof110skrvGrid3', {
		store	: detailStore2,
		layout	: 'fit',
		region	: 'center',
		flex	: 1,
		features: [ {id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false },
					{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false}],
		columns	: [
			{ dataIndex: 'TYPE_FLAG'		, width: 100 /*, align: 'center'*/},
			{ dataIndex: 'WK_PLAN_NUM'		, width: 120 , hidden: true},
			{ dataIndex: 'ORDER_NUM'		, width: 120 },
			{ dataIndex: 'ORDER_SEQ'		, width: 80  , align: 'center'},
			{ dataIndex: 'ORDER_TYPE'		, width: 100 , hidden: true},
			{ dataIndex: 'ORDERTYPE_NAME'	, width: 100 , align: 'center'},
			{ dataIndex: 'CUSTOM_CODE'		, width: 150 , hidden: true},
			{ dataIndex: 'CUSTOM_NAME'		, width: 150 },
			{ dataIndex: 'ITEM_CODE'		, width: 100 },
			{ dataIndex: 'ITEM_NAME'		, width: 240 },
			{ dataIndex: 'SPEC'				, width: 100 },
			{ dataIndex: 'ORDER_DATE'		, width: 90  },
			{ dataIndex: 'DVRY_DATE'		, width: 90  },
			{ dataIndex: 'ORDER_UNIT'		, width: 80  , align: 'center'},
			{ dataIndex: 'ORDER_Q'			, width: 100 },
			{ dataIndex: 'INSTOCK_Q'		, width: 100 },
			{ dataIndex: 'BAL_Q'			, width: 100 },
			{ dataIndex: 'REMARK'			, width: 166 },
			//20200120 추가
			{ dataIndex: 'INSERT_DB_USER'	, width: 200 , align: 'center' , hidden: true},
			{ dataIndex: 'UPDATE_DB_USER'	, width: 200 , align: 'center' , hidden: true}
		]
	});

	//20200120 추가
	var detailGrid3 = Unilite.createGrid('sof110skrvGrid4', {
		store	: detailStore3,
		layout	: 'fit',
		region	: 'center',
		flex	: 1,
		features: [ {id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false },
					{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false}],
		columns	: [
			{ dataIndex: 'TYPE'				, width: 100 , align: 'center'},
			{ dataIndex: 'WK_PLAN_NUM'		, width: 120 , hidden: true},
			{ dataIndex: 'ORDER_NUM'		, width: 120 },
			{ dataIndex: 'ORDER_SEQ'		, width: 80  , align: 'center'},
			{ dataIndex: 'CLASSFICATION_CD'	, width: 150 , hidden: true},
			{ dataIndex: 'CLASSFICATION'	, width: 150 },
			{ dataIndex: 'ITEM_CODE'		, width: 100 },
			{ dataIndex: 'ITEM_NAME'		, width: 240 },
			{ dataIndex: 'SPEC'				, width: 100 },
			{ dataIndex: 'ORDER_DATE'		, width: 90  },
			{ dataIndex: 'DUE_DATE'			, width: 90  },
			{ dataIndex: 'ORDER_UNIT'		, width: 80  , align: 'center'},
			{ dataIndex: 'ORDER_Q'			, width: 100 },
			{ dataIndex: 'INSTOCK_Q'		, width: 100 },
			{ dataIndex: 'BAL_Q'			, width: 100 },
			{ dataIndex: 'REMARK'			, width: 166 },
			//20200120 추가
			{ dataIndex: 'INSERT_DB_USER'	, width: 200 , align: 'center' , hidden: true},
			{ dataIndex: 'UPDATE_DB_USER'	, width: 200 , align: 'center' , hidden: true}
		]
	});



	var tab = Unilite.createTabPanel('tabPanel',{
		activeTab	: 0,
		region		: 'south',
		items		: [{
			id		: 'sof110skrvGridTab1',
			title	: '<t:message code="system.label.sales.productiondetails" default="생산내역"/>',
			xtype	: 'container',
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [detailGrid]
		},{
			id		: 'sof110skrvGridTab2',
			title	: '<t:message code="system.label.sales.orderdetails" default="구매내역"/>',
			xtype	: 'container',
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [detailGrid2]
		},{	//20200120 추가
			id		: 'sof110skrvGridTab3',
			title	: '<t:message code="system.label.sales.integrated" default="통합"/>',
			xtype	: 'container',
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [detailGrid3]
		}],
		listeners:  {
			tabChange:  function ( tabPanel, newCard, oldCard, eOpts ) {
				var masterRecord = masterGrid.getSelectedRecord();
				if(!Ext.isEmpty(masterRecord)) {
					var activeTabId  = tab.getActiveTab().getId();
					if(activeTabId == 'sof110skrvGridTab1') {
						detailStore.loadStoreRecords(masterRecord);
					} else if(activeTabId == 'sof110skrvGridTab2') {
						detailStore2.loadStoreRecords(masterRecord);
					} else {
						detailStore3.loadStoreRecords(masterRecord);
					}
				}
			}
		}
	});



	Unilite.Main({
		id			: 'sof110skrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelResult, masterGrid, tab
			]
		},
		panelSearch
		],
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
			//20200120 추가
			panelResult.down('#SHOW_DETAIL').setHtml('( 0 / 0 )');
			UniAppManager.setToolbarButtons(['detail', 'reset'], false);

			var pCombo	= panelSearch.getField('DIV_CODE');
			var combo	= panelSearch.getField('ORDER_PRSN').filterByRefCode('refCode1', pCombo.getValue(), pCombo);

			var field = panelSearch.getField('ORDER_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
			var field = panelResult.getField('ORDER_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");

			panelResult.setValue('DRVY_FOLLOW_RATE',0);
		},
		onQueryButtonDown : function() {
			if(!panelSearch.setAllFieldsReadOnly(true)){
				return false;
			}
			beforeRowIndex = -1;
			masterGrid.getStore().loadStoreRecords();;
		}
	});
};
</script>