<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_pmp112ukrv_mit"  >
	<t:ExtComboStore comboType="BOR120"  />				<!-- 사업장  -->
	<t:ExtComboStore comboType="AU" comboCode="B020" />	<!-- 품목계정 -->
	<t:ExtComboStore comboType="WU" />					<!-- 작업장  -->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="level1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="level2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="level3Store" />
</t:appConfig>

<style type="text/css">
	.x-change-cell {
	background-color: #FFFFC6;
}
</style>

<script type="text/javascript" >

var excelWindow;	// 엑셀참조
function appMain() {
	var tab1DirectProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy', {
		api: {
			read	: 's_pmp112ukrv_mitService.tab1SelectList',
			create	: 's_pmp112ukrv_mitService.tab1InsertDetail',
			update	: 's_pmp112ukrv_mitService.tab1UpdateDetail',
			destroy	: 's_pmp112ukrv_mitService.tab1DeleteDetail',
			syncAll	: 's_pmp112ukrv_mitService.tab1SaveAll'
		}
	});
	var tab2DirectProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy', {
		api: {
			read	: 's_pmp112ukrv_mitService.tab2SelectList',
			create	: 's_pmp112ukrv_mitService.tab2InsertDetail',
			update	: 's_pmp112ukrv_mitService.tab2UpdateDetail',
			destroy	: 's_pmp112ukrv_mitService.tab2DeleteDetail',
			syncAll	: 's_pmp112ukrv_mitService.tab2SaveAll'
		}
	});

	Unilite.defineModel('tab1Model', {
		fields: [
			{name: 'CHECK'					,text: 'CHECK'				,type:'string'},
			{name: 'DIV_CODE'				,text: 'DIV_CODE'			,type:'string'},
			{name: 'WORK_SHOP_CODE'			,text: 'WORK_SHOP_CODE'		,type:'string'},
			{name: 'WKORD_TYPE'				,text: '구분'					,type:'string', comboType:'AU', comboCode:'P519'},
			{name: 'CUSTOM_CODE'			,text: '거래처코드'				,type:'string'},
			{name: 'CUSTOM_NAME'			,text: '거래처명'				,type:'string'},
			{name: 'NATION_CODE'			,text: '국가'					,type:'string'},
			{name: 'DVRY_DATE'				,text: '납기일'				,type:'uniDate'},
			{name: 'ORDER_UNIT_Q'			,text: '수주량'				,type:'uniQty'},
			{name: 'ORDER_NUM'				,text: '수주번호'				,type:'string'},
			{name: 'ORDER_SEQ'				,text: '수주순번'				,type:'string'},
			{name: 'ORDER_DATE'				,text: '수주일'				,type:'uniDate'},
			{name: 'WKORD_NUM'				,text: '<t:message code="system.label.product.workorderno2" default="작지번호"/>'		,type:'string'},
			{name: 'ITEM_CODE'				,text: '<t:message code="system.label.product.item" default="품목"/>'					,type:'string', allowBlank: false},
			{name: 'ITEM_NAME'				,text: '<t:message code="system.label.product.itemname" default="품목명"/>'			,type:'string'},
			{name: 'SPEC'					,text: '<t:message code="system.label.product.spec" default="규격"/>'					,type:'string'},
			{name: 'PRODT_WKORD_DATE'		,text: '작업지시일'				,type:'uniDate', allowBlank: false},
			{name: 'LOT_NO'					,text: 'LOT NO'				,type:'string'},
			{name: 'PRODT_START_DATE'		,text: '조립포장일'				,type:'uniDate', allowBlank: false},
			{name: 'PRODT_END_DATE'			,text: '<t:message code="system.label.product.completiondate" default="완료예정일"/>'	,type:'uniDate', allowBlank: false},
			{name: 'LOT_NO'					,text: 'LOT NO'				,type:'string'},
			{name: 'SAFE_STOCK_Q'			,text: '안전재고'				,type:'uniQty'},
			{name: 'STOCK_Q'				,text: '현재고'				,type:'uniQty'},
			{name: 'ERST_WKORD_Q'			,text: '이전작업지시량'			,type:'uniQty'},
			{name: 'SEMI_ITEM_YN'			,text: '삽입기구사용여부'			,type: 'string',comboType: 'AU',comboCode: 'A004', allowBlank: false},
			{name: 'WKORD_Q'				,text: '<t:message code="system.label.product.workorderqty" default="작업지시량"/>'		,type:'uniQty', allowBlank: false},
			{name: 'SPLIT_CNT'				,text: '분리수량'				,type:'uniQty'},
			{name: 'REMARK'					,text: '비고'					,type:'string'},
			{name: 'SALES_REMARK'			,text: '영업PO'				,type:'string'},
			{name: 'SALES_REMARK_INTER'		,text: '영업내부비고'				,type:'string'},
			{name: 'BOM_YN'					,text: 'BOM등록'				,type:'string'},
			{name: 'STANT_CODE'				,text: '스텐트'				,type:'string'},
			{name: 'STANT_STOCK_Q'			,text: '스텐트 재고'				,type:'uniQty'},
			{name: 'RESERVE_Q'				,text: '스텐트 예약량'			,type:'uniQty'},
			{name: 'STANT_REMAIN_Q'			,text: '스텐트 잔량'				,type:'uniQty'},
			{name: 'STANT_DATE'				,text: '스텐트엮기일'				,type:'uniDate'},
			{name: 'STANT_CHKECK_YN1'		,text: '스텐트작지'				,type:'boolean', allowBlank: false},
			{name: 'STANT_CHKECK_YN'		,text: '스텐트작지'				,type:'string'},
			{name: 'COAT_STANT_CODE'		,text: '코팅스텐트'				,type:'string'},
			{name: 'COAT_STANT_STOCK_Q'		,text: '코팅스텐트 재고'			,type:'uniQty'},
			{name: 'COAT_RESERVE_Q'			,text: '코팅스텐트 예약량'			,type:'uniQty'},
			{name: 'COAT_STANT_REMAIN_Q'	,text: '코팅스텐트 잔량'			,type:'uniQty'},
			{name: 'COAT_DATE'				,text: '코팅일'				,type:'uniDate'},
			{name: 'COAT_STANT_CHKECK_YN1'	,text: '코팅작지'				,type:'boolean', allowBlank: false},
			{name: 'COAT_STANT_CHKECK_YN'	,text: '코팅작지'				,type:'string'},
			{name: 'OLD_WKORD_NUM'			,text: '이전작업지시번호'			,type:'string'},
			{name: 'PO_NUM'					,text: 'PO번호'				,type:'string'}
		]
	});	
	Unilite.defineModel('tab2Model', {
		fields: [
			{name: 'DIV_CODE'			,text: 'DIV_CODE'			,type:'string'},
			{name: 'WORK_SHOP_CODE'		,text: '<t:message code="system.label.product.workcenter" default="작업장"/>'		,type:'string'},
			{name: 'WKORD_TYPE'			,text: '구분'					,type:'string', comboType:'AU', comboCode:'P519'},
			{name: 'WKORD_NUM'			,text: '<t:message code="system.label.product.workorderno2" default="작지번호"/>'		,type:'string'},
			{name: 'ITEM_CODE'			,text: '<t:message code="system.label.product.item" default="품목"/>'					,type:'string', allowBlank: false},
			{name: 'ITEM_NAME'			,text: '<t:message code="system.label.product.itemname" default="품목명"/>'			,type:'string'},
			{name: 'SPEC'				,text: '<t:message code="system.label.product.spec" default="규격"/>'					,type:'string'},
			{name: 'PRODT_WKORD_DATE'	,text: '작업지시일'				,type:'uniDate', allowBlank: false},
			{name: 'LOT_NO'				,text: 'LOT NO'				,type:'string'},
			{name: 'PRODT_PRSN'			,text: '<t:message code="system.label.product.worker" default="작업자"/>'				,type:'string'},
			{name: 'PRODT_START_DATE'	,text: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>'	,type:'uniDate', allowBlank: false},
			{name: 'PRODT_END_DATE'		,text: '<t:message code="system.label.product.completiondate" default="완료예정일"/>'	,type:'uniDate', allowBlank: false},
			{name: 'WKORD_Q'			,text: '<t:message code="system.label.product.workorderqty" default="작업지시량"/>'		,type:'uniQty', allowBlank: false},
			{name: 'REMARK'				,text: '비고'					,type:'string'},
			{name: 'SALES_REMARK'		,text: '영업비고'				,type:'string'},
			{name: 'SALES_REMARK_INTER'	,text: '영업내부비고'				,type:'string'},
			{name: 'PO_NUM'				,text: 'PO번호'				,type:'string'},
			{name: 'CUSTOM_CODE'		,text: '거래처코드'				,type:'string'},
			{name: 'CUSTOM_NAME'		,text: '거래처명'				,type:'string'},
			{name: 'ORDER_NUM'			,text: '수주번호'				,type:'string'},
			{name: 'SER_NO'				,text: '수주순번'				,type:'string'},
			{name: 'ORDER_DATE'			,text: '수주일'				,type:'uniDate'},
			{name: 'ORDER_Q'			,text: '수주량'				,type:'uniQty'},
			{name: 'OLD_WKORD_NUM'		,text: '이전작업지시번호'			,type:'string'},
			{name: 'DVRY_DATE'			,text: '납기일'				,type:'uniDate'},
			{name: 'INSERT_APPR_TYPE'	,text: '삽입기구타입'				,type:'string', comboType:'AU', comboCode:'Z013'}				//20200305 추가: bpr200t.INSERT_APPR_TYPE
		]
	});	

	var tab1Store = Unilite.createStore('tab1Store',{
		model: 'tab1Model',
		proxy: tab1DirectProxy,
		autoLoad: false,
		uniOpt: {
			isMaster: false,	// 상위 버튼 연결 
			editable: true,	// 수정 모드 사용 
			deletable: true,	// 삭제 가능 여부 
			useNavi: false	// prev | next 버튼 사용
		},
		loadStoreRecords: function() {
			var param = Ext.merge(panelSearch.getValues(),tab1Form.getValues());
			this.load({
				params : param
			});
		},
		saveStore: function(config) {
			var inValidRecs = this.getInvalidRecords();
			if(inValidRecs.length == 0 ) {
				config = {
					success: function(batch, option) {
						tab1Grid.reset();
						tab1Store.clearData();
						tab.setActiveTab('tab2');
						tab2Store.loadStoreRecords();
					}
				};
				this.syncAllDirect(config);
			} else {
				tab1Grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				var recordsFirst = tab1Store.data.items[0];
				var msg = records.length + Msg.sMB001;
				UniAppManager.updateStatus(msg, true);
/*				
 20210217 베어, 코팅 스텐트 체크 기본  N  
 				if(store.getCount() > 0){
					Ext.each(records, function(record,i) {
						if(Ext.isEmpty(record.get('WORK_SHOP_CODE'))){
							record.set('WORK_SHOP_CODE', panelSearch.getValue('WORK_SHOP_CODE'));	
						}
						if(record.get('STANT_CHKECK_YN') == 'Y'){
							record.set('STANT_CHKECK_YN1', true);
						}else{
							record.set('STANT_CHKECK_YN1', false);
						}
						if(record.get('COAT_STANT_CHKECK_YN') == 'Y'){
							record.set('COAT_STANT_CHKECK_YN1', true);
						}else{
							record.set('COAT_STANT_CHKECK_YN1', false);
						}
					});
				}
*/				
			}
		}
	});
	var tab2Store = Unilite.createStore('tab2Store',{
		model: 'tab2Model',
		proxy: tab2DirectProxy,
		autoLoad: false,
		uniOpt: {
			isMaster: true,	// 상위 버튼 연결 
			//20200225 사용으로 변경
			editable: true,	// 수정 모드 사용 
			deletable: true,	// 삭제 가능 여부 
			useNavi: false	// prev | next 버튼 사용
		},
		loadStoreRecords: function(value) {
			var param = Ext.merge(panelSearch.getValues(),tab2Form.getValues());
			//20200225 추가
			if(value) {
				param.CLOSE_YN = value;
			}
			this.load({
				params : param
			});
		},
		saveStore: function(config) {
			var inValidRecs = this.getInvalidRecords();
			if(inValidRecs.length == 0 ) {
				config = {
					success: function(batch, option) {
						tab2Store.loadStoreRecords();
					}
				};
				this.syncAllDirect(config);
			} else {
				tab2Grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				//if(panelSearch.getValue('WORK_SHOP_CODE') == 'W50') {
					Ext.getCmp('tab2Form').getComponent('btnReWorkOrderPrint').show();
					Ext.getCmp('tab2Form').getComponent('btnReWorkOrderPrint').setDisabled(false);
				//}
				//else {
				//	Ext.getCmp('tab2Form').getComponent('btnReWorkOrderPrint').hide();
				//	Ext.getCmp('tab2Form').getComponent('btnReWorkOrderPrint').setDisabled(true);
				//}
			}
		}
	});

	var panelSearch = Unilite.createSearchForm('panelSearch', {
		region:'north',
		layout: {type : 'uniTable', columns :4},
//			tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
//		},
		padding: '1 1 1 1',
		border: true,
		items: [{
			fieldLabel: '<t:message code="system.label.base.division" default="사업장"/>',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			allowBlank: false,
			value : UserInfo.divCode,
			listeners: {
			change: function(field, newValue, oldValue, eOpts) {
				panelSearch.setValue('WORK_SHOP_CODE','');
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
			name: 'WORK_SHOP_CODE',
			xtype: 'uniCombobox',
			comboType: 'WU',
			allowBlank:false,
			listeners: {
				beforequery:function( queryPlan, eOpts )   {
					var store = queryPlan.combo.store;
					store.clearFilter();
					if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE'))){
						store.filterBy(function(record){
							return record.get('option') == panelSearch.getValue('DIV_CODE');
						});
					}else{
						store.filterBy(function(record){
							return false;
						});
					}
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.base.itemaccount" default="품목계정"/>',
			name: 'ITEM_ACCOUNT',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'B020'
		},{	//20200225 추가: 조회조건 ORDER_NUM 추가
			fieldLabel	: '<t:message code="system.label.sales.sono" default="수주번호"/>',
			xtype		: 'uniTextfield',
			name		: 'ORDER_NUM'
		},
		//20200225 추가
		Unilite.popup('AGENT_CUST',{
			fieldLabel		: '<t:message code="system.label.sales.custom" default="거래처"/>',
			valueFieldName	: 'CUSTOM_CODE',
			validateBlank	: false,
			colspan			: 2,
			listeners		: {
				onValueFieldChange: function(field, newValue){
					if(Ext.isEmpty(newValue)) {
					}
				},
				onTextFieldChange: function(field, newValue){
				},
				onSelected: {
					fn: function(records, type) {
					},
					scope: this
				},
				onClear: function(type) {
				},
				applyextparam: function(popup){
//					popup.setExtParam({'AGENT_CUST_FILTER': ['1','3']});
//					popup.setExtParam({'CUSTOM_TYPE': ['1','3']});
				}
			}
		}),{
			xtype: 'container',
			layout: { type: 'uniTable', columns: 2},
			defaultType: 'uniTextfield',
			items:[
				Unilite.popup('DIV_PUMOK',{
					fieldLabel: '품목코드',
					valueFieldName: 'ITEM_CODE',
					textFieldName: 'ITEM_NAME',
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelSearch.setValue('SPEC',records[0]["SPEC"]);
							},
							scope: this
						},
						onClear: function(type) {
							panelSearch.setValue('SPEC','');
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
			}),{
				name:'SPEC',
				xtype:'uniTextfield'
			}]
		},{
			xtype:'button',
			text:'엑셀업로드',
			disabled:false,
			hidden: true,
			itemId:'btn1',
			width: 200,
//			tdAttrs: {align: 'right'},	
			margin: '0 0 0 10',
			handler: function(){
				if(!panelSearch.getInvalidMessage()) return;   //필수체크
				openExcelWindow();
			}
		}]
	});

	var tab1Grid = Unilite.createGrid('tab1Grid', {
		layout: 'fit',
		region:'center',
		uniOpt: {
			userToolbar:true,
			expandLastColumn: true,
			useLiveSearch: false,
			useContextMenu: false,
			useMultipleSorting: false,
			useGroupSummary: false,
			useRowNumberer: false,
			onLoadSelectFirst: false,
			filter: {
				useFilter: false,
				autoCreate: true
			}
		},
		store: tab1Store,
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: true,// mode: "SIMPLE",
			listeners: {
				select: function(grid, selectRecord, index, rowIndex, eOpts ){
					var selectedRecords = tab1Grid.getSelectedRecords();
					selectRecord.set('CHECK','Y');
					if(Ext.isEmpty(selectedRecords)){
						UniAppManager.setToolbarButtons(['save','delete'], false);
					}else{
						UniAppManager.setToolbarButtons(['save','delete'], true);
					}
				},
				deselect:  function(grid, selectRecord, index, eOpts ){
					var selectedRecords = tab1Grid.getSelectedRecords();
					selectRecord.set('CHECK','');
					if(Ext.isEmpty(selectedRecords)){
						UniAppManager.setToolbarButtons(['save','delete'], false);
					}else{
						UniAppManager.setToolbarButtons(['save','delete'], true);
					}
				}
			}
		}),
		columns: [
			{ dataIndex: 'WKORD_TYPE' 			, width: 80, locked: true},
			{ dataIndex: 'CUSTOM_CODE'			, width: 80, locked: true},
			{ dataIndex: 'CUSTOM_NAME'			, width: 100, locked: true},
			{ dataIndex: 'NATION_CODE'			, width: 100, locked: true},
			{ dataIndex: 'ITEM_CODE'			, width: 100, locked: true},
			{ dataIndex: 'ITEM_NAME'			, width: 250, locked: true},
			{ dataIndex: 'SPEC'					, width: 150, locked: true},
			{ dataIndex: 'DVRY_DATE'			, width: 100},
			{ dataIndex: 'ORDER_UNIT_Q'			, width: 80},
			{ dataIndex: 'PRODT_WKORD_DATE'		, width: 100},
			{ dataIndex: 'LOT_NO'				, width: 100},
			{ dataIndex: 'PRODT_START_DATE'		, width: 100},
			{ dataIndex: 'PRODT_END_DATE'		, width: 100, hidden:true},
			{ dataIndex: 'SAFE_STOCK_Q'			, width: 120, hidden:true},
			{ dataIndex: 'STOCK_Q'				, width: 120, hidden:true},
			{ dataIndex: 'ERST_WKORD_Q'			, width: 120, hidden:true},
			{ dataIndex: 'SEMI_ITEM_YN'			, width: 80},
			{ dataIndex: 'WKORD_Q'				, width: 100},
			{ dataIndex: 'SPLIT_CNT'			, width: 80},
			{ dataIndex: 'REMARK'				, width: 200},
			{ dataIndex: 'SALES_REMARK'			, width: 200},
			{ dataIndex: 'SALES_REMARK_INTER'	, width: 200},
			{ dataIndex: 'BOM_YN'				, width:100},
			{ dataIndex: 'STANT_CODE'			, width:150},
			{ dataIndex: 'STANT_STOCK_Q'		, width:100},
			{ dataIndex: 'RESERVE_Q'			, width:100},
			{ dataIndex: 'STANT_REMAIN_Q'		, width:100},
			{ dataIndex: 'STANT_DATE'			, width:100},
			{ dataIndex: 'STANT_CHKECK_YN1'		, width:80, xtype: 'checkcolumn',align:'center',
				listeners: {
					checkchange: function( CheckColumn, rowIndex, checked, eOpts ){
						var grdRecord = tab1Grid.getStore().getAt(rowIndex);
						if(checked == true) {
							grdRecord.set('STANT_CHKECK_YN', 'Y');
						} else {
							grdRecord.set('STANT_CHKECK_YN', 'N');
						}
					}
				}},
			{ dataIndex: 'STANT_CHKECK_YN'		, width:100,hidden:true},
			{ dataIndex: 'COAT_STANT_CODE'		, width:150},
			{ dataIndex: 'COAT_STANT_STOCK_Q'	, width:100},
			{ dataIndex: 'COAT_RESERVE_Q'		, width:100},
			{ dataIndex: 'COAT_STANT_REMAIN_Q'	, width:100},
			{ dataIndex: 'COAT_DATE'			, width:100},
			{ dataIndex: 'COAT_STANT_CHKECK_YN1', width:80, xtype: 'checkcolumn',align:'center',
				listeners: {
					checkchange: function( CheckColumn, rowIndex, checked, eOpts ){
						var grdRecord = tab1Grid.getStore().getAt(rowIndex);
						if(checked == true) {
							grdRecord.set('COAT_STANT_CHKECK_YN', 'Y');
						} else {
							grdRecord.set('COAT_STANT_CHKECK_YN', 'N');
						}
					}
				}},
			{ dataIndex: 'COAT_STANT_CHKECK_YN'	, width:100,hidden:true},
			{ dataIndex: 'ORDER_NUM'			, width: 120},
			{ dataIndex: 'ORDER_SEQ'			, width: 50},
			{ dataIndex: 'ORDER_DATE'			, width: 100},
			{ dataIndex: 'OLD_WKORD_NUM'		, width: 120},
			{ dataIndex: 'PO_NUM'				, width: 120}
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if (UniUtils.indexOf(e.field, ['PRODT_WKORD_DATE','LOT_NO','PRODT_START_DATE','PRODT_END_DATE','WKORD_Q','SPLIT_CNT','SEMI_ITEM_YN','STANT_REMAIN_Q','STANT_CHKECK_YN','COAT_STANT_REMAIN_Q','COAT_STANT_CHKECK_YN','REMARK', 'COAT_DATE'])) {
					return true;
				} else {
					return false;
				}
			}
		},
		viewConfig: {
			getRowClass: function(record, rowIndex, rowParams, store){
				var cls = '';
				if(record.get('BOM_YN') == 'N'){
					cls = 'x-change-celltext_red';
				}
				return cls;
			}
		}
	});

	var tab2Grid = Unilite.createGrid('tab2Grid', {
		layout: 'fit',
		region:'center',
		uniOpt: {
//			userToolbar:false,
			expandLastColumn: true,
			useLiveSearch: false,
			useContextMenu: false,
			useMultipleSorting: false,
			useGroupSummary: false,
			useRowNumberer: false,
			onLoadSelectFirst: false,
			filter: {
				useFilter: false,
				autoCreate: false
			}
		},
		store: tab2Store,		
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly : false, toggleOnClick:false}),
		columns: [
			{ dataIndex: 'WKORD_TYPE'			, width: 80},
			{ dataIndex: 'WORK_SHOP_CODE'		, width: 100},
			{ dataIndex: 'WKORD_NUM'			, width: 120},
			{ dataIndex: 'ITEM_CODE'			, width: 100},
			{ dataIndex: 'ITEM_NAME'			, width: 250},
			{ dataIndex: 'SPEC'					, width: 200},
			{ dataIndex: 'LOT_NO'				, width: 100},
			{ dataIndex: 'PRODT_PRSN'			, width: 100},
			{ dataIndex: 'PRODT_WKORD_DATE'		, width: 100},
			{ dataIndex: 'PRODT_START_DATE'		, width: 100},
			{ dataIndex: 'PRODT_END_DATE'		, width: 100},
			{ dataIndex: 'WKORD_Q'				, width: 100}, 
			{ dataIndex: 'REMARK'				, width: 200},
			{ dataIndex: 'SALES_REMARK'			, width: 200},
			{ dataIndex: 'SALES_REMARK_INTER'	, width: 200},
			{ dataIndex: 'PO_NUM'				, width: 120},			
			{ dataIndex: 'CUSTOM_CODE'			, width: 120}, 
			{ dataIndex: 'CUSTOM_NAME'			, width: 120}, 
			{ dataIndex: 'ORDER_NUM'			, width: 120}, 
			{ dataIndex: 'SER_NO'				, width: 80}, 
			{ dataIndex: 'ORDER_DATE'			, width: 100}, 
			{ dataIndex: 'ORDER_Q'				, width: 80},
			{ dataIndex: 'OLD_WKORD_NUM'		, width: 120},
			{ dataIndex: 'DVRY_DATE'			, width: 120},
			{ dataIndex: 'INSERT_APPR_TYPE'		, width: 100}			//20200305 추가: bpr200t.INSERT_APPR_TYPE
		],
		//20200225 추가
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if(tab2Form.down('#closeYn').getChecked()[0].inputValue == '2') {
					if (UniUtils.indexOf(e.field, ['PRODT_START_DATE', 'PRODT_END_DATE', 'REMARK'])) {
						return true;
					} else {
						return false;
					}
				} else {
					if (UniUtils.indexOf(e.field, ['REMARK'])) {
						return true;
					} else {
						return false;
					}
				}
			},
			cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
			},
			edit: function(editor, e) {
			}
		}
	});

	var tab1Form = Unilite.createForm('tab1Form', {
		disabled: false,
		region: 'north',
		padding: '1 1 1 1',
		layout: {type: 'uniTable', columns: 5},
		items: [{
			fieldLabel: '<t:message code="system.label.product.deliverydate" default="납기일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'FR_DVRY_DATE',
			endFieldName: 'TO_DVRY_DATE',
			allowBlank: false,
			startDate		 : UniDate.get('startOfMonth'),
			endDate		: UniDate.get('endOfTwoNextMonth'),
			labelWidth:70
		},{
			fieldLabel: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>',
			xtype: 'uniDatefield',
			name : 'PRODT_START_DATE',
			value : UniDate.get('today'),
			allowBlank: false,
			labelWidth:115
		},{			
			labelText : '',
			xtype   : 'button',
			text	: '반영',
			margin  : '0 0 2 5',
			width   : 50,
			tdAttrs : {align: 'left'},
			handler : function() {
				var prodtstartdate = UniDate.getDbDateStr(tab1Form.getValue('PRODT_START_DATE')); 
				records = tab1Store.data.items;
				Ext.each(records, function(record, i) {
					if(record.get('CHECK') == 'Y'){
						record.set('PRODT_START_DATE', prodtstartdate);
					}
				});
			}
		},{
			fieldLabel: '<t:message code="system.label.product.completiondate" default="완료예정일"/>',
			xtype: 'uniDatefield',
			name : 'PRODT_END_DATE',
			allowBlank: false,
			value : UniDate.get('today'),
			labelWidth:115
		},{			
			labelText : '',
			xtype   : 'button',
			text	: '반영',
			margin  : '0 0 2 5',
			width   : 50,
			tdAttrs : {align: 'left'},
			handler : function() {
				var prodtenddate = UniDate.getDbDateStr(tab1Form.getValue('PRODT_END_DATE')); 
				records = tab1Store.data.items;
				Ext.each(records, function(record, i) {
					if(record.get('CHECK') == 'Y'){
						record.set('PRODT_END_DATE', prodtenddate);
					}
				});
			}
		}]
	});

	var tab2Form = Unilite.createForm('tab2Form', {
		disabled: false,
		region: 'north',
		padding: '1 1 1 1',
		layout: {type: 'uniTable', columns: 6},
		items: [{
			fieldLabel: '완료예정일',
			xtype: 'uniDateRangefield',
			startFieldName: 'FR_PRODT_WKORD_DATE',
			endFieldName: 'TO_PRODT_WKORD_DATE',
			width: 350,
			allowBlank: false
		},{	//20200225 추가: 조회조건 LOT_NO 추가
			fieldLabel	: 'LOT NO',
			name		: 'LOT_NO',
			xtype		: 'uniTextfield',
			listeners	: {
			}
		},{	//20200107 추가: 조회조건 상태 추가
			fieldLabel	: '상태',
			xtype		: 'radiogroup',
			itemId		: 'closeYn',
			items		: [{
				boxLabel	: '진행',
				name		: 'CLOSE_YN',
				inputValue	: '2',
				width		: 70
			},{
				boxLabel	: '마감/완료',
				name		: 'CLOSE_YN',
				inputValue	: '8',
				width		: 100
			}],
			//20200225 추가
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					if(!tab2Form.getInvalidMessage()) return;	//필수체크
					if(newValue) {
						tab2Store.loadStoreRecords(newValue.CLOSE_YN);
					} else {
						tab2Store.loadStoreRecords(oldValue.CLOSE_YN);
					}
				}
			}
		},{
			xtype:'button',
			text:'작업지시서 출력',
			disabled:false,
//			itemId:'btn1',
			width: 150,
//			tdAttrs: {align: 'right'},	
			margin: '0 0 0 10',
			handler: function(){
				var selectedRecords = tab2Grid.getSelectedRecords();
				if(Ext.isEmpty(selectedRecords)){
					Unilite.messageBox('<t:message code="system.message.product.message017" default="출력할 데이터가 없습니다."/>');
					return;
				}

				var wkordNumList;
				Ext.each(selectedRecords, function(record, idx) {
					if(idx ==0) {
						wkordNumList= record.get("WKORD_NUM");
					} else {
						wkordNumList= wkordNumList  + ',' + record.get("WKORD_NUM");
					}
				});

				var param = panelSearch.getValues();
				param["WKORD_NUM"] = wkordNumList;
				param["dataCount"] = selectedRecords.length;
				param["USER_LANG"] = UserInfo.userLang;
				param["PGM_ID"]= PGM_ID;
				param["MAIN_CODE"] = 'P010';  //생산용 공통 코드

				win = Ext.create('widget.ClipReport', {
					url: CPATH+'/z_mit/s_pmp111clukrv_mit.do',
					prgID: 's_pmp111clukrv_mit',
					extParam: param,
					//20200519 추가
					submitType : 'POST'
				});
				win.center();
				win.show();
			}
		},{
			xtype:'button',
			text:'자재예약',
			disabled:false,
//			itemId:'btn1',
			width: 150,
//			tdAttrs: {align: 'right'},	
			margin: '0 0 0 10',
			handler: function(){
				var selectedRecords = tab2Grid.getSelectedRecords();
				if(Ext.isEmpty(selectedRecords)){
					Unilite.messageBox('선택된 데이터가 없습니다.');
					return;
				}
				
				var wkordNumList = new Array();
				Ext.each(selectedRecords, function(record, idx) {
					wkordNumList.push(record.get('WKORD_NUM'));
				});

				var params = {
					wkordNumList : wkordNumList,
					WORK_SHOP_CODE : panelSearch.getValue('WORK_SHOP_CODE')
				}
				var rec1 = {data : {prgID : 'pmp160ukrv', 'text':''}};
				parent.openTab(rec1,"/prodt/pmp160ukrv.do",params);
			}
		},{
			xtype:'button',
			text:'재작업지시서 출력',
			disabled:false,
			hidden  :false,
			itemId:'btnReWorkOrderPrint',
			width: 150,
//			tdAttrs: {align: 'right'},	
			margin: '0 0 0 10',
			handler: function(){
//				alert('Hello');
//				
//				return;
				
				var selectedRecords = tab2Grid.getSelectedRecords();
				if(Ext.isEmpty(selectedRecords)){
					Unilite.messageBox('<t:message code="system.message.product.message017" default="출력할 데이터가 없습니다."/>');
					return;
				}

				var wkordNumList;
				Ext.each(selectedRecords, function(record, idx) {
					if(idx ==0) {
						wkordNumList= record.get("WKORD_NUM");
					} else {
						wkordNumList= wkordNumList  + ',' + record.get("WKORD_NUM");
					}
				});

				var param = panelSearch.getValues();
				param["WORK_SHOP_CODE"] = '';	//w40, w50 구분없이 출력위해 조건값 제거
				param["WKORD_NUM"] = wkordNumList;
				param["dataCount"] = selectedRecords.length;
				param["USER_LANG"] = UserInfo.userLang;
				param["PGM_ID"]= PGM_ID;
				param["MAIN_CODE"] = 'P010';  //생산용 공통 코드

				win = Ext.create('widget.ClipReport', {
					url: CPATH+'/z_mit/s_pmp112clukrv_mit.do',
					prgID: 's_pmp112clukrv_mit',
					extParam: param,
					//20200519 추가
					submitType : 'POST'
				});
				win.center();
				win.show();
			}
		}]
	});

	var tab = Unilite.createTabPanel('tabPanel',{
		activeTab: 0,
		region: 'center',
		items: [{
			title: '미등록',
			xtype:'container',
			layout:{type:'vbox', align:'stretch'},
			items:[tab1Form,tab1Grid],
			id: 'tab1'
		},{
			title: '등록',
			xtype:'container',
			layout:{type:'vbox', align:'stretch'},
			items:[tab2Form,tab2Grid],
			id: 'tab2' 
		}],
		listeners : {
			beforetabchange : function ( tabPanel, newCard, oldCard, eOpts )  {
				if(!panelSearch.getInvalidMessage()) return false;   // 필수체크
//				if(UniAppManager.app._needSave())   {
//					alert('<t:message code="system.message.sales.message066" default="먼저 저장 후 다시 작업하십시오."/>');
//					return false;
//				}
				panelSearch.getField('DIV_CODE').setReadOnly(true);
				panelSearch.getField('WORK_SHOP_CODE').setReadOnly(true);
			},
			tabChange : function ( tabPanel, newCard, oldCard, eOpts )  {
				var newTabId = newCard.getId();
				if(newTabId == 'tab1'){
					tab1Store.loadStoreRecords();
					//UniAppManager.setToolbarButtons('delete', false);
				}else{
					tab2Form.setValue('FR_PRODT_WKORD_DATE',tab1Form.getValue('FR_DVRY_DATE'));
					tab2Form.setValue('TO_PRODT_WKORD_DATE',tab1Form.getValue('TO_DVRY_DATE'));
					tab2Store.loadStoreRecords();
					UniAppManager.setToolbarButtons('delete', true);
				}
			}
		}
	});
	function openExcelWindow() {
		var me = this;
		var vParam = {};
		var appName = 'Unilite.com.excel.ExcelUpload';
		if(!Ext.isEmpty(excelWindow)){
			excelWindow.extParam.DIV_CODE = panelSearch.getValue('DIV_CODE');
			excelWindow.extParam.WORK_SHOP_CODE = panelSearch.getValue('WORK_SHOP_CODE');
		}
		if(!excelWindow) {
			excelWindow =  Ext.WindowMgr.get(appName);
			excelWindow = Ext.create( appName, {
				modal: false,
				excelConfigName: 's_pmp112ukrv_mit',
				extParam: {
					'PGM_ID': 's_pmp112ukrv_mit',
					'DIV_CODE': panelSearch.getValue('DIV_CODE'),
					'WORK_SHOP_CODE': panelSearch.getValue('WORK_SHOP_CODE')
				},
				listeners: {
					show: function(){
					},
					close: function() {
						this.hide();
					}
				},
				uploadFile: function() {
					var me = this,
					frm = me.down('#uploadForm');
					if(Ext.isEmpty(frm.getValue('excelFile'))){
						alert(UniUtils.getMessage('system.message.commonJS.excel.requiredText','선택된 파일이 없습니다.'));
						return false;	
					}
					frm.submit({
						params: me.extParam,
						waitMsg: 'Uploading...',
						success: function(form, action) {
							me.jobID = action.result.jobID;
							me.readGridData(me.jobID);
							me.down('tabpanel').setActiveTab(1);
							Ext.Msg.alert('Success', UniUtils.getMessage('system.message.commonJS.excel.succesText','Upload 되었습니다.'));
							me.hide();
							tab.setActiveTab('tab2');
						},
						failure: function(form, action) {
							Ext.Msg.alert('Failed', action.result.msg);
						}
					});
				},
				_setToolBar: function() {
					var me = this;
					me.tbar = [
						{
							xtype: 'button',
							text : UniUtils.getLabel('system.label.commonJS.excel.btnUpload','업로드'),
							tooltip : UniUtils.getLabel('system.label.commonJS.excel.btnUpload','업로드'), 
							handler: function() { 
								me.jobID = null;
								me.uploadFile();
							}
						},
						{
							xtype: 'button',
							text : 'Read Data',
							tooltip : 'Read Data', 
							hidden: true,
							handler: function() { 
								if(me.jobID != null) {
									me.readGridData(me.jobID);
									me.down('tabpanel').setActiveTab(1);
								} else {
									alert(UniUtils.getMessage('system.message.commonJS.excel.requiredText','Upload된 파일이 없습니다.'))
								}
							}
						},
						{
							xtype: 'button',
							hidden:true,
							text : UniUtils.getLabel('system.label.commonJS.excel.btnApply','적용'),
							tooltip : UniUtils.getLabel('system.label.commonJS.excel.btnApply','적용'), 
							handler: function() { 
								var grids = me.down('grid');
								var isError = false;
								if(Ext.isDefined(grids.getEl())) {
									grids.getEl().mask();
								}
								Ext.each(grids, function(grid,i){
									if(me.grids[0].useCheckbox) {
										var records = grid.getSelectionModel().getSelection();
									} else {
										var records = grid.getStore().data.items;
									}
			//						var records = grid.getStore().data.items;
									return Ext.each(records, function(record,i){	
										if(record.get('_EXCEL_HAS_ERROR') == 'Y') {
											console.log("_EXCEL_HAS_ERROR : ", record.get('_EXCEL_HAS_ERROR'));
											isError = true;		
											return false;
										}
									});
								}); 
								if(Ext.isDefined(grids.getEl())) {
									grids.getEl().unmask();
								}
								if(!isError) {
									me.onApply();
								}else {
									alert(UniUtils.getMessage('system.message.commonJS.excel.rowErrorText',"에러가 있는 행은 적용이 불가능합니다."));
								}
							}
						},
						'->',
						{
							xtype: 'button',
							text : UniUtils.getLabel('system.label.commonJS.excel.btnClose','닫기'),
							tooltip : UniUtils.getLabel('system.label.commonJS.excel.btnClose','닫기'), 
							handler: function() { 
								me.hide();
							}
						}
						
					]
				}
			});
		}
		excelWindow.center();
		excelWindow.show();
	}
	Unilite.Main({
		id: 's_pmp112ukrv_mitApp',
		borderItems: [{
			id: 'pageAll',
			region: 'center',
			layout: 'border',
			border: false,
			items: [
				panelSearch, tab
			]
		}],
		fnInitBinding: function() {
			this.fnInitInputFields();
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelSearch.getField('DIV_CODE').setReadOnly(false);
			panelSearch.getField('WORK_SHOP_CODE').setReadOnly(false);
			tab1Form.getField('FR_DVRY_DATE').setReadOnly(false);
			tab1Form.getField('TO_DVRY_DATE').setReadOnly(false);
			tab2Form.getField('FR_PRODT_WKORD_DATE').setReadOnly(false);
			tab2Form.getField('TO_PRODT_WKORD_DATE').setReadOnly(false);
			tab1Grid.reset();
			tab1Store.clearData();
			tab2Grid.reset();
			tab2Store.clearData();
			this.fnInitInputFields();
		},
		onQueryButtonDown: function() {
			if(!panelSearch.getInvalidMessage()) return;	//필수체크
			panelSearch.getField('DIV_CODE').setReadOnly(true);
			panelSearch.getField('WORK_SHOP_CODE').setReadOnly(true);
			var activeTabId = tab.getActiveTab().getId();
			if(activeTabId == 'tab1') {
				if(!tab1Form.getInvalidMessage()) return;	//필수체크
				tab1Store.loadStoreRecords();
				//tab1Form.getField('FR_DVRY_DATE').setReadOnly(true);
				//tab1Form.getField('TO_DVRY_DATE').setReadOnly(true);
			}else if(activeTabId == 'tab2') {
				if(!tab2Form.getInvalidMessage()) return;	//필수체크
				tab2Store.loadStoreRecords();
				//tab2Form.getField('FR_PRODT_WKORD_DATE').setReadOnly(true);
				//tab2Form.getField('TO_PRODT_WKORD_DATE').setReadOnly(true);
			}
		},
		onNewDataButtonDown: function() {
		},
		onDeleteDataButtonDown: function() {
			var activeTabId = tab.getActiveTab().getId();
			if(activeTabId == 'tab1') {
				var selRow = tab1Grid.getSelectedRecord();
				if(!Ext.isEmpty(selRow)){
					if(confirm('<t:message code="system.message.purchase.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
						tab1Grid.deleteSelectedRow();
					}
				}
			}
			if(activeTabId == 'tab2') {
				var selRow = tab2Grid.getSelectedRecord();
				if(!Ext.isEmpty(selRow)){
					if(confirm('<t:message code="system.message.purchase.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
						tab2Grid.deleteSelectedRow();
					}
				}
			}
		},
		onSaveDataButtonDown: function(config) {
			if(!panelSearch.getInvalidMessage()) return;   //필수체크
			var activeTabId = tab.getActiveTab().getId();
			if(activeTabId == 'tab1') {
				if(!tab1Form.getInvalidMessage()) return;	//필수체크
				tab1Store.saveStore();
			}else if(activeTabId == 'tab2') {
				if(!tab2Form.getInvalidMessage()) return;	//필수체크
				tab2Store.saveStore();
			}
		},
		fnInitInputFields: function(){
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			panelSearch.setValue('WORK_SHOP_CODE', 'W40');
			panelSearch.setValue('ITEM_ACCOUNT', '10');
			tab1Form.setValue('FR_DVRY_DATE',UniDate.get('startOfMonth'));
			tab1Form.setValue('TO_DVRY_DATE',UniDate.get('endOfTwoNextMonth'));
			tab2Form.setValue('FR_PRODT_WKORD_DATE',UniDate.get('today'));
			tab2Form.setValue('TO_PRODT_WKORD_DATE',UniDate.get('today'));
			//20200107 추가: 조회조건 상태 추가
			tab2Form.setValue('CLOSE_YN','2');
			UniAppManager.setToolbarButtons(['reset'], true);
			UniAppManager.setToolbarButtons(['print','newData','save'], false);
			
//			Ext.getCmp('tab2Form').getComponent('btnReWorkOrderPrint').hide();
//			Ext.getCmp('tab2Form').getComponent('btnReWorkOrderPrint').setDisabled(true);
		}
	});
};
</script>