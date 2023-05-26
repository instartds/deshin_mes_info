<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_pmp111ukrv_mit"  >
	<t:ExtComboStore comboType="BOR120"  />										<!-- 사업장  -->
	<t:ExtComboStore comboType="AU" comboCode="B020" />							<!-- 품목계정 -->
	<t:ExtComboStore comboType="AU" comboCode="P505" opts= '${gsComboList1}' />	<!-- 작업자 -->
	<t:ExtComboStore comboType="WU" />											<!-- 작업장  -->
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

function appMain() {
	var excelWindow;	// 엑셀참조

	var tab1DirectProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy', {
		api: {
			read	: 's_pmp111ukrv_mitService.tab1SelectList',
			create	: 's_pmp111ukrv_mitService.tab1InsertDetail',
			update	: 's_pmp111ukrv_mitService.tab1UpdateDetail',
			destroy	: 's_pmp111ukrv_mitService.tab1DeleteDetail',
			syncAll	: 's_pmp111ukrv_mitService.tab1SaveAll'
		}
	});
	var tab2DirectProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy', {
		api: {
			read	: 's_pmp111ukrv_mitService.tab2SelectList',
			create	: 's_pmp111ukrv_mitService.tab2InsertDetail',
			update	: 's_pmp111ukrv_mitService.tab2UpdateDetail',
			destroy	: 's_pmp111ukrv_mitService.tab2DeleteDetail',
			syncAll	: 's_pmp111ukrv_mitService.tab2SaveAll'
		}
	});

	Unilite.defineModel('tab1Model', {
		fields: [
			{name: 'CHECK'				,text: 'CHECK'		,type:'string'},
			{name: 'DIV_CODE'			,text: 'DIV_CODE'	,type:'string'},
			{name: 'WKORD_TYPE'			,text: '구분'			,type:'string', comboType:'AU', comboCode:'P519'},
			{name: 'WORK_SHOP_CODE'		,text: '작업장'		,type:'string',comboType:'WU'},
			{name: 'WKORD_NUM'			,text: '<t:message code="system.label.product.workorderno2" default="작지번호"/>'		,type:'string'},
			{name: 'ITEM_CODE'			,text: '<t:message code="system.label.product.item" default="품목"/>'					,type:'string', allowBlank: false},
			{name: 'ITEM_NAME'			,text: '<t:message code="system.label.product.itemname" default="품목명"/>'			,type:'string'},
			{name: 'SPEC'				,text: '<t:message code="system.label.product.spec" default="규격"/>'					,type:'string'},
			{name: 'PRODT_WKORD_DATE'	,text: '작업지시일'		,type:'uniDate', allowBlank: false},
			{name: 'PRODT_PRSN'			,text: '작업자'		,type:'string', comboType:'AU', comboCode:'P505'},
			{name: 'LOT_NO'				,text: 'LOT NO'		,type:'string'},
			{name: 'PRODT_START_DATE'	,text: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>'	,type:'uniDate', allowBlank: false},
			{name: 'PRODT_END_DATE'		,text: '<t:message code="system.label.product.completiondate" default="완료예정일"/>'	,type:'uniDate', allowBlank: false},
			{name: 'REMARK'				,text: '비고'			,type:'string'},
			{name: 'SAFE_STOCK_Q'		,text: '안전재고'		,type:'uniQty'},
			{name: 'STOCK_Q'			,text: '현재고'		,type:'uniQty'},
			{name: 'ERST_WKORD_Q'		,text: '이전작업지시량'	,type:'uniQty'},
			{name: 'RESERVE_Q'			,text: '예약량'		,type:'uniQty'},
			{name: 'WKORD_Q'			,text: '<t:message code="system.label.product.workorderqty" default="작업지시량"/>'		,type:'uniQty', allowBlank: false},
			{name: 'SPLIT_CNT'			,text: '분리수량'		,type:'uniQty'},
			{name: 'AVG_3Q'				,text: '월 평균 출고량'	,type:'uniQty'},
			{name: 'ROTATION'			,text: '회전률'		,type:'uniQty'},
			{name: 'BOM_YN'				,text: 'BOM등록'		,type:'string'},
			{name: 'OLD_WKORD_NUM'		,text: '이전작업지시번호'	,type:'string'}
		]
	});	
	Unilite.defineModel('tab2Model', {
		fields: [
			{name: 'DIV_CODE'			,text: 'DIV_CODE'	,type:'string'},
			{name: 'WKORD_TYPE'			,text: '구분'			,type:'string', comboType:'AU', comboCode:'P519'},
			{name: 'WORK_SHOP_CODE'		,text: '작업장'		,type:'string',comboType:'WU'},
			{name: 'WKORD_NUM'			,text: '<t:message code="system.label.product.workorderno2" default="작지번호"/>'		,type:'string'},
			{name: 'ITEM_CODE'			,text: '<t:message code="system.label.product.item" default="품목"/>'					,type:'string', allowBlank: false},
			{name: 'ITEM_NAME'			,text: '<t:message code="system.label.product.itemname" default="품목명"/>'			,type:'string'},
			{name: 'SPEC'				,text: '<t:message code="system.label.product.spec" default="규격"/>'					,type:'string'},
			{name: 'PRODT_WKORD_DATE'	,text: '작업지시일'		,type:'uniDate', allowBlank: false},
			{name: 'LOT_NO'				,text: 'LOT NO'		,type:'string'},
			{name: 'TOP_LOT_NO'			,text: '제품LOT NO'		,type:'string'},
			{name: 'PRODT_PRSN_CODE'	,text: '작업자코드'		,type:'string'},
			{name: 'PRODT_PRSN'			,text: '<t:message code="system.label.product.worker" default="작업자"/>'				,type:'string',comboType:'AU',comboCode:'P505'},
			{name: 'PRODT_START_DATE'	,text: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>'	,type:'uniDate', allowBlank: false},
			{name: 'PRODT_END_DATE'		,text: '<t:message code="system.label.product.completiondate" default="완료예정일"/>'	,type:'uniDate', allowBlank: false},
			{name: 'REMARK'				,text: '비고'			,type:'string'},
			{name: 'WKORD_Q'			,text: '<t:message code="system.label.product.workorderqty" default="작업지시량"/>'		,type:'uniQty', allowBlank: false},
			{name: 'OLD_WKORD_NUM'		,text: '이전작업지시번호'	,type:'string'}, 
			{name: 'UPDATE_DB_USER'		,text: '등록자'		,type:'string'}
		]
	});	
	
	var tab1Store = Unilite.createStore('tab1Store',{
		model: 'tab1Model',
		proxy: tab1DirectProxy,
		autoLoad: false,
		uniOpt: {
			isMaster: false,	// 상위 버튼 연결 
			editable: true,	// 수정 모드 사용 
			deletable: false,	// 삭제 가능 여부 
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
				var msg = records.length + Msg.sMB001;
				UniAppManager.updateStatus(msg, true);
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
			}
		}
	});

	var panelSearch = Unilite.createSearchForm('panelSearch', {
		region:'north',
		layout: {type : 'uniTable', columns :3/*,tableAttrs:{width:'100%'}*/},
//			tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
//		},
		padding: '1 1 1 1',
		border: true,
		items: [{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 3},
			colspan:3,
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
				labelWidth:145,
				allowBlank: false,
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
					},
					change: function(field, newValue, oldValue, eOpts) {
						var activeTabId = tab.getActiveTab().getId();
						if(newValue == 'W10'){
							tab2Form.down('#pwd').setConfig('fieldLabel','작업지시일');
						}else{
							tab2Form.down('#pwd').setConfig('fieldLabel','착수예정일');
						}
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.base.itemaccount" default="품목계정"/>',
				name: 'ITEM_ACCOUNT',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B020',
				labelWidth:145
			}]
		},{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 3},
			items: [{
				fieldLabel: '<t:message code="system.label.base.itemgroup" default="품목분류"/>',
				name: 'ITEM_LEVEL1',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('level1Store'),
				child: 'ITEM_LEVEL2'
			}, {
				fieldLabel: '',
				name: 'ITEM_LEVEL2',
				xtype:'uniCombobox',
				store: Ext.data.StoreManager.lookup('level2Store'),
				child: 'ITEM_LEVEL3'
			}, {
				fieldLabel: '',
				name: 'ITEM_LEVEL3',
				xtype:'uniCombobox',
				store: Ext.data.StoreManager.lookup('level3Store')
			}]
		},{
			xtype: 'container',
			layout: { type: 'uniTable', columns: 2},
			defaultType: 'uniTextfield',
			items:[
				Unilite.popup('DIV_PUMOK',{
					fieldLabel: '품목코드',
					valueFieldName: 'ITEM_CODE',
					textFieldName: 'ITEM_NAME',
					labelWidth:133,
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
			itemId:'btn1',
			width: 200,
//			tdAttrs: {align: 'right'},	
			margin: '0 0 0 30',
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
		store: tab1Store,
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: true,// mode: "SIMPLE",
			listeners: {
				select: function(grid, selectRecord, index, rowIndex, eOpts ){
					var selectedRecords = tab1Grid.getSelectedRecords();
					selectRecord.set('CHECK','Y');
					if(Ext.isEmpty(selectedRecords)){
						UniAppManager.setToolbarButtons(['save'], false);
					}else{
						UniAppManager.setToolbarButtons(['save'], true);
					}
				},
				deselect:  function(grid, selectRecord, index, eOpts ){
					var selectedRecords = tab1Grid.getSelectedRecords();
					selectRecord.set('CHECK','');
					if(Ext.isEmpty(selectedRecords)){
						UniAppManager.setToolbarButtons(['save'], false);
					}else{
						UniAppManager.setToolbarButtons(['save'], true);
					}
				}
			}
		}),
		columns: [
			{ dataIndex: 'WKORD_TYPE'		, width: 100, locked: true},
			{ dataIndex: 'WORK_SHOP_CODE'	, width: 100, locked: true},
			{ dataIndex: 'ITEM_CODE'		, width: 100, locked: true},
			{ dataIndex: 'ITEM_NAME'		, width: 200, locked: true},
			{ dataIndex: 'SPEC'				, width: 250, locked: true},
			{ dataIndex: 'PRODT_WKORD_DATE'	, width: 100},
			{ dataIndex: 'PRODT_PRSN'		, width: 100},
			{ dataIndex: 'LOT_NO'			, width: 100},
			{ dataIndex: 'PRODT_START_DATE'	, width: 100},
			{ dataIndex: 'PRODT_END_DATE'	, width: 100},
			{ dataIndex: 'REMARK'			, width: 200},
			{ dataIndex: 'SAFE_STOCK_Q'		, width: 120},
			{ dataIndex: 'STOCK_Q'			, width: 120},
			{ dataIndex: 'ERST_WKORD_Q'		, width: 120},
			{ dataIndex: 'RESERVE_Q'		, width: 120},
			{ dataIndex: 'WKORD_Q'			, width: 120},
			{ dataIndex: 'SPLIT_CNT'		, width: 120},
			{ dataIndex: 'AVG_3Q'			, width: 120},
			{ dataIndex: 'ROTATION'			, width: 120},
			{ dataIndex: 'BOM_YN'			, width: 80},
			{ dataIndex: 'OLD_WKORD_NUM'	, width: 120}
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if (UniUtils.indexOf(e.field, ['PRODT_WKORD_DATE','LOT_NO','PRODT_START_DATE','PRODT_END_DATE','WKORD_Q','SPLIT_CNT','PRODT_PRSN','REMARK'])) {
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
			{ dataIndex: 'WKORD_TYPE'		, width: 100},
			{ dataIndex: 'WORK_SHOP_CODE'	, width: 100},
			{ dataIndex: 'WKORD_NUM'		, width: 120},
			{ dataIndex: 'ITEM_CODE'		, width: 100},
			{ dataIndex: 'ITEM_NAME'		, width: 200},
			{ dataIndex: 'SPEC'				, width: 250},
			{ dataIndex: 'LOT_NO'			, width: 100, hidden:true},
			{ dataIndex: 'TOP_LOT_NO'		, width: 100},
			{ dataIndex: 'PRODT_PRSN_CODE'	, width: 100},
			{ dataIndex: 'PRODT_PRSN'		, width: 100},
			{ dataIndex: 'PRODT_WKORD_DATE'	, width: 100},
			{ dataIndex: 'PRODT_START_DATE'	, width: 100},
			{ dataIndex: 'PRODT_END_DATE'	, width: 100},
			{ dataIndex: 'REMARK'			, width: 200},
			{ dataIndex: 'WKORD_Q'			, width: 120},
			{ dataIndex: 'OLD_WKORD_NUM'	, width: 120},
			{ dataIndex: 'UPDATE_DB_USER'	, width: 120}
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
					return false;
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
		layout: {type: 'uniTable', columns: 2},
		items: [{
			xtype: 'radiogroup',
			fieldLabel: '대상',
			items: [{
				boxLabel: '전체',
				width: 70,
				name: 'RDO1',
				inputValue: 'A'
			},{
				boxLabel : '안전재고 부족',
				width: 100,
				name: 'RDO1',
				inputValue: 'B',
				checked: true
			}]
		},{
			fieldLabel: '<t:message code="system.label.product.workorderdate" default="작업지시일"/>',
			xtype: 'uniDatefield',
			name: 'PRODT_WKORD_DATE',
			allowBlank: false,
			value:UniDate.get('today'),
			labelWidth:115
		}]
	});

	var tab2Form = Unilite.createForm('tab2Form', {
		disabled: false,
		region: 'north',
		padding: '1 1 1 1',
		layout: {type: 'uniTable', columns: 4},
		items: [{
			fieldLabel: '완료예정일',
			xtype: 'uniDateRangefield',
			itemId: 'pwd',
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
			xtype: 'container',
			layout:{type:'uniTable',columns:5},
			items:[{
				xtype:'button',
				text:'작업지시서 출력',
				disabled:false,
	//			itemId:'btn1',
				width: 130,	
//				margin: '0 0 0 10',
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
				xtype:'component',
				width:10
			},{
				xtype:'button',
				text:'태그 출력',
				disabled:false,
				width: 130,
//					margin: '0 0 0 20',
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
					param["ARR_GUBUN"] = "Y";
					param["USER_LANG"] = UserInfo.userLang;
					param["PGM_ID"]= PGM_ID;
					param["MAIN_CODE"] = 'P010';  //생산용 공통 코드
					param["sTxtValue2_fileTitle"]='';
					
					var win = null;
					win = Ext.create('widget.ClipReport', {
						url: CPATH+'/z_mit/s_pmp110clukrv2_mit.do',
						prgID: 's_pmp110ukrv_mit',
						extParam: param,
						//20200519 추가
						submitType : 'POST'
					});
					win.center();
					win.show();
				}
			},{
				xtype:'component',
				width:10
			},{
				xtype:'button',
				text:'자재 예약',
				disabled:false,
	//			itemId:'btn1',
				width: 130,
	//			tdAttrs: {align: 'right'},
//				margin: '0 0 0 30',
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
			}]
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
//					Unilite.messageBox('<t:message code="system.message.sales.message066" default="먼저 저장 후 다시 작업하십시오."/>');
//					return false;
//				}
				panelSearch.getField('DIV_CODE').setReadOnly(true);
				panelSearch.getField('WORK_SHOP_CODE').setReadOnly(true);
			},
			tabChange : function ( tabPanel, newCard, oldCard, eOpts )  {
				var newTabId = newCard.getId();
				if(newTabId == 'tab1'){
					tab1Store.loadStoreRecords();
					UniAppManager.setToolbarButtons('delete', false);
//					tab1Form.getField('PRODT_WKORD_DATE').setReadOnly(true);
				}else{
					tab2Form.setValue('FR_PRODT_WKORD_DATE',tab1Form.getValue('PRODT_WKORD_DATE'));
					tab2Form.setValue('TO_PRODT_WKORD_DATE',tab1Form.getValue('PRODT_WKORD_DATE'));
					tab2Store.loadStoreRecords();
					UniAppManager.setToolbarButtons('delete', true);
//					tab2Form.getField('FR_PRODT_WKORD_DATE').setReadOnly(true);
//					tab2Form.getField('TO_PRODT_WKORD_DATE').setReadOnly(true);
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
				excelConfigName: 's_pmp111ukrv_mit',
				extParam: {
					'PGM_ID': 's_pmp111ukrv_mit',
					'DIV_CODE': panelSearch.getValue('DIV_CODE'),
					'WORK_SHOP_CODE': panelSearch.getValue('WORK_SHOP_CODE')
				},
				listeners: {
					show: function(){
						Ext.getCmp('pageAll').getEl().mask('엑셀업로드중...');
					},
					close: function() {
						this.hide();
					},
					hide: function() {
						Ext.getCmp('pageAll').getEl().unmask();
					}
				},
				uploadFile: function() {
					var me = this,
					frm = me.down('#uploadForm');
					if(Ext.isEmpty(frm.getValue('excelFile'))){
						Unilite.messageBox(UniUtils.getMessage('system.message.commonJS.excel.requiredText','선택된 파일이 없습니다.'));
						return false;
					}
					frm.submit({
						params: me.extParam,
						waitMsg: 'Uploading...',
						success: function(form, action) {
							me.jobID = action.result.jobID;
							me.readGridData(me.jobID);
							me.down('tabpanel').setActiveTab(1);
							//20200309 수정: 메세지 형식 수정
//							Ext.Msg.alert('Success', UniUtils.getMessage('system.message.commonJS.excel.succesText','Upload 되었습니다.'));
							Unilite.messageBox('Upload 되었습니다.');
							me.hide();
							tab.setActiveTab('tab2');
						},
						failure: function(form, action) {
							//20200309 수정: 메세지 형식 수정
//							Ext.Msg.alert('Failed', action.result.msg);
							Unilite.messageBox('Upload에 실패하였습니다.');
							//메세지 표현 안되는것 확인필요
						}
					});
				},
				_setToolBar: function() {
					var me = this;
					me.tbar = [{
						xtype: 'button',
						text : UniUtils.getLabel('system.label.commonJS.excel.btnUpload','업로드'),
						tooltip : UniUtils.getLabel('system.label.commonJS.excel.btnUpload','업로드'), 
						handler: function() { 
							me.jobID = null;
							me.uploadFile();
						}
					},{
						xtype: 'button',
						text : 'Read Data',
						tooltip : 'Read Data', 
						hidden: true,
						handler: function() { 
							if(me.jobID != null) {
								me.readGridData(me.jobID);
								me.down('tabpanel').setActiveTab(1);
							} else {
								Unilite.messageBox(UniUtils.getMessage('system.message.commonJS.excel.requiredText','Upload된 파일이 없습니다.'))
							}
						}
					},{
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
								Unilite.messageBox(UniUtils.getMessage('system.message.commonJS.excel.rowErrorText',"에러가 있는 행은 적용이 불가능합니다."));
							}
						}
					},'->',{
						xtype: 'button',
						text : UniUtils.getLabel('system.label.commonJS.excel.btnClose','닫기'),
						tooltip : UniUtils.getLabel('system.label.commonJS.excel.btnClose','닫기'), 
						handler: function() { 
							me.hide();
						}
					}]
				}
			});
		}
		excelWindow.center();
		excelWindow.show();
	}



	Unilite.Main({
		id			: 's_pmp111ukrv_mitApp',
		borderItems	: [{
			id		: 'pageAll',
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelSearch, tab
			]
		}],
		fnInitBinding: function() {
			this.fnInitInputFields();
		},
		onResetButtonDown: function() {
//			panelSearch.clearForm();
			panelSearch.getField('DIV_CODE').setReadOnly(false);
			panelSearch.getField('WORK_SHOP_CODE').setReadOnly(false);
//			tab1Form.getField('PRODT_WKORD_DATE').setReadOnly(false);
//			tab2Form.getField('FR_PRODT_WKORD_DATE').setReadOnly(false);
//			tab2Form.getField('TO_PRODT_WKORD_DATE').setReadOnly(false);
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
//				tab1Form.getField('PRODT_WKORD_DATE').setReadOnly(true);
			}else if(activeTabId == 'tab2') {
				if(!tab2Form.getInvalidMessage()) return;	//필수체크
				tab2Store.loadStoreRecords();
//				tab2Form.getField('FR_PRODT_WKORD_DATE').setReadOnly(true);
//				tab2Form.getField('TO_PRODT_WKORD_DATE').setReadOnly(true);
			}
		},
		onNewDataButtonDown: function() {
		},
		onDeleteDataButtonDown: function() {
			var activeTabId = tab.getActiveTab().getId();
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
			if(!panelSearch.getInvalidMessage()) return;	//필수체크
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
			panelSearch.setValue('ITEM_ACCOUNT', '20');
			tab1Form.setValue('PRODT_WKORD_DATE',UniDate.get('today'));
			tab2Form.setValue('FR_PRODT_WKORD_DATE',UniDate.get('today'));
			tab2Form.setValue('TO_PRODT_WKORD_DATE',UniDate.get('today'));
			//20200107 추가: 조회조건 상태 추가
			tab2Form.setValue('CLOSE_YN','2');
			UniAppManager.setToolbarButtons(['reset'], true);
			UniAppManager.setToolbarButtons(['print','newData','save'], false);
		}
	});
};
</script>