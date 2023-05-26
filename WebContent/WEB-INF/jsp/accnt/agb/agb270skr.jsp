<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="agb270skr">
	<t:ExtComboStore comboType="BOR120"/>				<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B004"/>	<!--화폐단위-->
	<t:ExtComboStore comboType="AU" comboCode="B055"/>	<!--고객분류-->
	<t:ExtComboStore comboType="AU" comboCode="B056"/>	<!-- 지역 -->
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
.x-grid-cell-inner {padding: 4px 4px 3px 4px;}
</style>	
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	var dinamicModel = null;
	var dinamicStore = null;
	var getStDt = ${getStDt};
	var getChargeCode = ${getChargeCode};
	var colData = ${colData};

	var fields = createModelField(colData);
	var columns = createGridColumn(colData);

	var columnName = '';
	var book1 = false;
	var book2 = false;

	/** Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Agb270skrModel', {
		fields: fields
	});
	
	Unilite.defineModel('agb270srkUnSeletedModel', {
		fields: [
			{name: 'ACCNT'			,text: '계정과목'			,type: 'string'},
			{name: 'ACCNT_NAME'		,text: '계정명'			,type: 'string'},
			{name: 'ACCNT_DIVI'		,text: '계정유형'			,type: 'string'}
//			{name: 'BOOK_CODE'		,text: 'BOOK_CODE'		,type: 'string'}
		]
	});

	Unilite.defineModel('Agb270skrSeletedModel', {
		fields: [
			{name: 'ACCNT'			,text: '계정과목'			,type: 'string'},
			{name: 'ACCNT_NAME'		,text: '계정명'			,type: 'string'},
			{name: 'ACCNT_DIVI'		,text: '계정유형'			,type: 'string'}
//			{name: 'BOOK_CODE'		,text: 'BOOK_CODE'		,type: 'string'}
		]
	});

	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */
	var MasterStore = Unilite.createStore('agb270skrMasterStore',{
		model: 'Agb270skrModel',
		uniOpt : {
			isMaster:	true,			// 상위 버튼 연결 
			editable:	false,			// 수정 모드 사용 
			deletable:	false,			// 삭제 가능 여부 
			useNavi:	false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {
				read: 'agb270skrService.selectList'
			}
		}
		,loadStoreRecords : function(accntArray) {
			var param= Ext.getCmp('searchForm').getValues();
			param.ACCNTS = accntArray;
			console.log( param );
			this.load({
				params : param
			});				
		},
		_onStoreLoad: function ( store, records, successful, eOpts ) {
			if(this.uniOpt.isMaster) {
				var recLength = 0;
				Ext.each(records, function(record, idx){
					if(record.get('DATA_TYPE') == 'D'){
						recLength++;
					}
				});
				if (records) {
					UniAppManager.setToolbarButtons('save', false);
					var msg = recLength + Msg.sMB001; //'건이 조회되었습니다.';
					//console.log(msg, st);
					UniAppManager.updateStatus(msg, true);	
				}
			}
		}
	});
		
	var unSelectedStore = Unilite.createStore('agb270srkUnSeletedStore', { 
		model : 'agb270srkUnSeletedModel',
		autoLoad : false,
		uniOpt : {
			isMaster: false,			// 상위 버튼 연결 
			editable: false,			// 수정 모드 사용 
			deletable:false,			// 삭제 가능 여부 
			useNavi : false			// prev | newxt 버튼 사용
		},
		proxy : {
			type : 'direct',
			api : {
				read: 'agb270skrService.unSelectQuery'
				
			}
		},
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});	
		
	
	var SelectedStore = Unilite.createStore('Agb270skrSeletedStore', { 
		model : 'Agb270skrSeletedModel',
		autoLoad : false,
		uniOpt : {
			isMaster: false,			// 상위 버튼 연결 
			editable: false,			// 수정 모드 사용 
			deletable:false,			// 삭제 가능 여부 
			useNavi : false			// prev | newxt 버튼 사용
		},
		proxy : {
			type : 'direct',
			api : {
				read : 	 'agb270skrService.selectQuery'
				
			}
		},
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	
	var unSelectedGrid = Unilite.createGrid('agb270skrUnSelectedGrid', {
		store: unSelectedStore,
		title : '미선택 계정',
		sortableColumns: false,
		selModel: 'rowmodel',
		selModel : Ext.create('Ext.selection.CheckboxModel', { checkOnly : false, toggleOnClick:false  }),
		uniOpt:{
			onLoadSelectFirst	: false,
			expandLastColumn	: false,		//내용검색 버튼 사용 여부
			state: {
				useState	: false,			//그리드 설정 버튼 사용 여부
				useStateList: false		//그리드 설정 목록 사용 여부
			},
			excel: {
				useExcel	: false,
				exportGroup	: false
			}
		},
		flex:1,
		width: 323,
		height: 170,
		columns : [ {dataIndex : 'ACCNT',			width:80	},
					{dataIndex : 'ACCNT_NAME',		width:150, flex: 1	},
					{dataIndex : 'ACCNT_DIVI',		width:100, hidden: true	}
		],
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
				var records, record, data = new Object();
				if (unSelectedGrid.getSelectedRecords()) {
					records = unSelectedGrid.getSelectedRecords();
					console.log("records : ", records);
					data.records = [];
					for (i = 0, len = records.length; i < len; i++) {
						//data.records.push(records[i].copy());
					var record = records[i].copy();
					record.phantom = true;	//selectedRecords 의 phantom 값이 4.2.2 에서는 기본 true, 5.1 에서는 false 임.
						data.records.push(record);
					}
					selectedGrid.getStore().insert(0, data.records);
					selectedGrid.getSelectionModel().select(data.records);
					unSelectedGrid.getStore().remove(records);
//					unSelectedGrid.getSelectionModel().select(0);
				}
			}	
		}  			
	});

	var selectedGrid =  Unilite.createGrid('agb270skrSelectedGrid', {
		store : SelectedStore,
		title : '선택 계정',
		sortableColumns: false,
		selModel: 'rowmodel',
		selModel : Ext.create('Ext.selection.CheckboxModel', { checkOnly : false, toggleOnClick:false  }),
		uniOpt:{
			onLoadSelectFirst	: false,
			expandLastColumn	: false,		//내용검색 버튼 사용 여부
			state: {
				useState	: false,			//그리드 설정 버튼 사용 여부
				useStateList: false				//그리드 설정 목록 사용 여부
			},
			excel: {
				useExcel: false,
				exportGroup : false
			}
		},
		width: 323,
		height: 170,
//		selModel :   Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false  }), 
		columns : [ {dataIndex : 'ACCNT',			width:80	},
					{dataIndex : 'ACCNT_NAME',		width:150, flex: 1	},
					{dataIndex : 'ACCNT_DIVI',		width:100, hidden: true	}
		],
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
				var records, record, data = new Object();
				if (selectedGrid.getSelectedRecords()) {
					
					records = selectedGrid.getSelectedRecords();
					console.log("records : ", records);
					data.records = [];
					for (i = 0, len = records.length; i < len; i++) {
						//data.records.push(records[i].copy());
					var record = records[i].copy();
					record.phantom = true;	//selectedRecords 의 phantom 값이 4.2.2 에서는 기본 true, 5.1 에서는 false 임.
							data.records.push(record);
						}
					unSelectedGrid.getStore().insert(0, data.records);		
					unSelectedGrid.getSelectionModel().select(data.records);
					selectedGrid.getStore().remove(records);
//					selectedGrid.getSelectionModel().select(0);
				}
			}
		}
  		
	});



	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '검색조건',
		defaultType: 'uniSearchSubPanel',
		collapsed:true,
		listeners: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			}
		},
		items: [{	
			title: '기본정보', 	
			itemId: 'search_panel1',
			layout: {type: 'uniTable', columns: 1},
			defaultType: 'uniTextfield',
			items : [{
				fieldLabel: '기준일',
				name: 'AC_DATE',
				xtype: 'uniDatefield',
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('AC_DATE', newValue);
					}
				}
			},{
				fieldLabel: '사업장',
				name:'ACCNT_DIV_CODE',
				xtype: 'uniCombobox',
				multiSelect: true,
				typeAhead: false,
				value:UserInfo.divCode,
				comboType:'BOR120',
				width: 323,
				colspan:2,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ACCNT_DIV_CODE', newValue);
					}
				}
			},
				//CUST 팝업 오류로 임시로 BCM100t [RETURN_CODE]컬럼 추가(추후 확인)
				Unilite.popup('CUST',{
				fieldLabel: '거래처',
				allowBlank:true,
				autoPopup:false,
				validateBlank:false,/*,
				extParam:{'CUSTOM_TYPE':'3'}*/
				valueFieldName:'CUSTOM_CODE',
				textFieldName:'CUSTOM_NAME',
				listeners: {
						onValueFieldChange:function( elm, newValue, oldValue) {
							panelResult.setValue('CUSTOM_CODE', newValue);
							
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('CUSTOM_NAME', '');
								panelSearch.setValue('CUSTOM_NAME', '');
							}
						},
						onTextFieldChange:function( elm, newValue, oldValue) {
							panelResult.setValue('CUSTOM_NAME', newValue);
							
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('CUSTOM_CODE', '');
								panelSearch.setValue('CUSTOM_CODE', '');
							}
						}
				}
			}), {
				fieldLabel: '화폐단위'	,
				name:'MONEY_UNIT', 
				xtype: 'uniCombobox', 
				comboType:'AU',
				comboCode:'B004',
				displayField: 'value',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('MONEY_UNIT', newValue);
					}
				} 
			}]
		},{
			title: '추가정보', 	
			itemId: 'search_panel2',
			layout: {type: 'uniTable', columns: 1},
			defaultType: 'uniTextfield',
			items : [{
				fieldLabel: '당기시작년월',
				name: 'ST_DATE',
				xtype: 'uniMonthfield',
				allowBlank: false
			},{
				fieldLabel: '고객분류',
				name:'AGENT_TYPE',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'B055'
			},{
				fieldLabel: '지역',
				name:'AREA_TYPE',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'B056'
			},{
				xtype: 'radiogroup',
				fieldLabel: '거래처',
//				id: 'radio1',
				items: [{
					boxLabel: '일반거래처' , width: 82, name: 'radio1', inputValue: 'GCUSTOM', checked: true
				},{
					boxLabel: '집계거래처' , width: 82, name: 'radio1', inputValue: 'MCUSTOM'
				}]
			}]		
		},{
			title: '추가정보', 	
			itemId: 'search_panel2',
			layout: {type: 'uniTable', columns: 1},
			defaultType: 'uniTextfield',
			items : [{
				fieldLabel: '당기시작년월',
				name: 'ST_DATE',
				xtype: 'uniMonthfield',
				allowBlank: false
			},{
				fieldLabel: '고객분류',
				name:'AGENT_TYPE',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'B055'
			},{
				fieldLabel: '지역',
				name:'AREA_TYPE',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'B056'
			},{
				xtype: 'radiogroup',
				fieldLabel: '거래처',
				id: 'radio1',
				items: [{
					boxLabel: '일반거래처' , width: 82, name: 'radio1', inputValue: 'GCUSTOM', checked: true
				},{
					boxLabel: '집계거래처' , width: 82, name: 'radio1', inputValue: 'MCUSTOM'
				}]
			}]		
		},{	
			header:false,
			itemId: 'search_panel3',
			layout:{type:'uniTable', columns: 1},
			padding: '0 0 0 10',
			items: [unSelectedGrid]
		},{
			xtype: 'container',
			layout: {type: 'uniTable', columns:2},
			padding: '0 0 0 111',
			items:[{
				xtype: 'button',
				text: '▼',
				width: 60,
				handler: function(){
					var records, record, data = new Object();
					if (unSelectedGrid.getSelectedRecords()) {
						
						records = unSelectedGrid.getSelectedRecords();
						console.log("records : ", records);
						data.records = [];
						for (i = 0, len = records.length; i < len; i++) {
							//data.records.push(records[i].copy());
						var record = records[i].copy();
						record.phantom = true;	//selectedRecords 의 phantom 값이 4.2.2 에서는 기본 true, 5.1 에서는 false 임.
								data.records.push(record);
							}
						selectedGrid.getStore().insert(0, data.records);		
						selectedGrid.getSelectionModel().select(data.records);
						unSelectedGrid.getStore().remove(records);
//						unSelectedGrid.getSelectionModel().select(0);
					}
				}
			},{
				xtype: 'button',
				text: '▲',
				width: 60,
				margin: '0 0 0 4',
				handler: function(){
					var records, record, data = new Object();
					if (selectedGrid.getSelectedRecords()) {
						
						records = selectedGrid.getSelectedRecords();
						console.log("records : ", records);
						data.records = [];
						for (i = 0, len = records.length; i < len; i++) {
							//data.records.push(records[i].copy());
						var record = records[i].copy();
						record.phantom = true;	//selectedRecords 의 phantom 값이 4.2.2 에서는 기본 true, 5.1 에서는 false 임.
								data.records.push(record);
							}
						unSelectedGrid.getStore().insert(0, data.records);
						unSelectedGrid.getSelectionModel().select(data.records);
						selectedGrid.getStore().remove(records);
//						selectedGrid.getSelectionModel().select(0);
					}
				}
			}]
		},{	
			header:false,
			itemId: 'search_panel4',
			layout:{type:'uniTable', columns: 1},
			padding: '0 0 0 10',
			items: [selectedGrid]
		},
			Unilite.popup('ACCNT',{
			fieldLabel: '계정과목',	
			hidden: true,
			valueFieldName: 'ACCNT_CODE',
			textFieldName: 'ACCNT_NAME'
		})]
	});	

	var panelResult = Unilite.createSearchForm('panelResultForm', {
		hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 2},
		padding:'1 1 1 1',
		border:true,
		items: [{
				fieldLabel: '기준일',
				name: 'AC_DATE',
				xtype: 'uniDatefield',
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('AC_DATE', newValue);
					}
				} 
			},{
				fieldLabel: '사업장',
				name:'ACCNT_DIV_CODE', 
				xtype: 'uniCombobox',
				multiSelect: true, 
				typeAhead: false,
				value:UserInfo.divCode,
				comboType:'BOR120',
				width: 323,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('ACCNT_DIV_CODE', newValue);
					}
				}
			},
				//CUST 팝업 오류로 임시로 BCM100t [RETURN_CODE]컬럼 추가(추후 확인)
				Unilite.popup('CUST',{
				fieldLabel: '거래처',
				allowBlank:true,
				autoPopup:false,
				validateBlank:false,
				valueFieldName:'CUSTOM_CODE',
				textFieldName:'CUSTOM_NAME',
				listeners: {
					onValueFieldChange:function( elm, newValue, oldValue) {
						panelSearch.setValue('CUSTOM_CODE', newValue);
						
						if(!Ext.isObject(oldValue)) {
							panelResult.setValue('CUSTOM_NAME', '');
							panelSearch.setValue('CUSTOM_NAME', '');
						}
					},
					onTextFieldChange:function( elm, newValue, oldValue) {
						panelSearch.setValue('CUSTOM_NAME', newValue);
						
						if(!Ext.isObject(oldValue)) {
							panelResult.setValue('CUSTOM_CODE', '');
							panelSearch.setValue('CUSTOM_CODE', '');
						}
					}
				}
			}), {
				fieldLabel: '화폐단위',
				name:'MONEY_UNIT', 
				xtype: 'uniCombobox', 
				comboType:'AU',
				comboCode:'B004',
				displayField: 'value',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('MONEY_UNIT', newValue);
					}
				} 
			}] 
	});



	/**
	 * Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid = Unilite.createGrid('agb270skrGrid', {
		// for tab
		layout : 'fit',
		region:'center',
		store: MasterStore,
		sortableColumns: false,
		selModel: 'rowmodel',
		uniOpt:{	
			expandLastColumn	: false,	//마지막 컬럼 * 사용 여부
			useRowNumberer		: false,	//첫번째 컬럼 순번 사용 여부
			useLiveSearch		: true,		//찾기 버튼 사용 여부
			lockable			: true,
			filter: {						//필터 사용 여부
				useFilter: true,
				autoCreate: true
			},
			state: {						//그리드 설정 사용 여부
				useState: false,
				useStateList: false
			}
		},
		//20210819 주석: 이벤트 없는 버튼 '설정'만 남아있어서 주석처리
//		tbar: [
//		/*{
//			text:'채권채무조회서',
//			handler: function() {
//				var record = masterGrid.getSelectedRecords();
//				console.log(record);
//				UniAppManager.app.onPrintButtonDown(record);
//				//console.log(record);
////				if(record) {
////					openDetailWindow(record);
////				}
//			}
//		}, */
//		{
//			text:'설정'
////			handler: function() {
////				var record = masterGrid.getSelectedRecord();
////				if(record) {
////					openDetailWindow(record);
////				}
////			}
//		}
//		],
		features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
					{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
		columns:  columns,
		viewConfig: {
			getRowClass: function(record, rowIndex, rowParams, store){
				var cls = '';
				if(record.get('DATA_TYPE') == 'S'){
					cls = 'x-change-cell_dark';
				}
				return cls;
			}
		},
		listeners: {
//			onGridDblClick:function(grid, record, cellIndex, colName) {
//				var params = {
//					appId: UniAppManager.getApp().id,
//					action: 'new',
//					sendPram: ['01', UserInfo.divCode]
//				}
//				var rec = {data : {prgID : 'agb110skr', 'text':''}};
//				parent.openTab(rec, '/accnt/agb110skr.do', params);
			itemmouseenter:function(view, record, item, index, e, eOpts ) {
				view.ownerGrid.setCellPointer(view, item);
			},
			onGridDblClick :function( grid, record, cellIndex, colName ) {
				if(grid.grid.contextMenu) {
					var menuItem = grid.grid.contextMenu.down('#agb110Item');
					if(menuItem) {
						menuItem.handler();
					}
				}
			}
		},
		onItemcontextmenu:function( menu, grid, record, item, index, event  ) {
			columnName = grid.eventPosition.column.dataIndex;	 
			if(columnName.substring(0, 3) != "AMT") return false;
			return true;
		},
		uniRowContextMenu:{
			items: [
				{	text	: '보조부 보기',
					itemId:'agb110Item',
					handler	: function(menuItem, event) {
						var accntCd = columnName.substring(3);
						agb270skrService.getAccntName({ACCNT: accntCd}, function(provider, response) {
							if(provider[0]){
								panelSearch.setValue('ACCNT_CODE', provider[0].ACCNT);
								panelSearch.setValue('ACCNT_NAME', provider[0].ACCNT_NAME);
								if(provider[0].BOOK_CODE == 'BOOK_CODE1'){
									book1 = true;
								}else{
									book2 = true;
								}
								var param = menuItem.up('menu');
								masterGrid.gotoAgb110skr(param.record);
							}
						});
					}
				}
			]
		},
		gotoAgb110skr:function(record) {
			if(record) {
				var params = record;
				params.PGM_ID 			= 'agb270skr';
				params.START_DATE 		= UniDate.getDbDateStr(panelSearch.getValue('ST_DATE'));
				params.FR_DATE 			= UniDate.getDbDateStr(UniDate.get('startOfYear'));
				params.TO_DATE 			= UniDate.getDbDateStr(panelSearch.getValue('AC_DATE'));
				params.ACCNT_CODE 		= panelSearch.getValue('ACCNT_CODE');
				params.ACCNT_NAME 		= panelSearch.getValue('ACCNT_NAME');
				params.ACCNT_DIV_CODE 	= panelSearch.getValue('ACCNT_DIV_CODE');
				params.MONEY_UNIT 		= panelSearch.getValue('MONEY_UNIT');
				if(book1){
					params.BOOK_DATA1 		= record.get('CUSTOM_CODE'); 
					params.BOOK_NAME1 	= record.get('CUSTOM_NAME');
				}else{
					params.BOOK_DATA2 		= record.get('CUSTOM_CODE');
					params.BOOK_NAME2 	= record.get('CUSTOM_NAME');
				}
			}
			var rec1 = {data : {prgID : 'agb110skr', 'text':''}};
			parent.openTab(rec1, '/accnt/agb110skr.do', params);
		}
	});



	Unilite.Main({
		id  : 'agb270skrApp',
		borderItems:[{
			border: false,
			region:'center',
			layout: 'border',
			items:[
				masterGrid,  panelResult
			]
		},
		panelSearch
		],
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail', false);
			UniAppManager.setToolbarButtons('reset'	, false);
			unSelectedStore.loadStoreRecords();
			SelectedStore.loadStoreRecords();

			panelSearch.setValue('AC_DATE', UniDate.get('today'));
			panelResult.setValue('AC_DATE', UniDate.get('today'));
			panelSearch.setValue('ST_DATE', getStDt[0].STDT);

			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch) {
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('AC_DATE');
			
		},
		onQueryButtonDown : function() {
			if(!this.isValidSearchForm()){
				return false;
			}
			var accntCodes = '';
			colData = new Array;
			var selectAccnts = selectedGrid.getStore().data.items;
			if(Ext.isEmpty(selectAccnts)){
				alert(Msg.fSbMsgA0146);
				return;
			}
			Ext.each(selectAccnts, function(rec, i){
				if(i == 0){
					accntCodes = selectAccnts[i].data.ACCNT;
				}else{
					accntCodes += ',' + selectAccnts[i].data.ACCNT;
				}
				colData[i] = {ACCNT: selectAccnts[i].data.ACCNT, ACCNT_NAME: selectAccnts[i].data.ACCNT_NAME, ACCNT_DIVI: selectAccnts[i].data.ACCNT_DIVI};				
			});
//			alert(colData);

			var accntArray = new Array();
			accntArray = accntCodes.split(',');

			createModelStore(colData, accntArray);
//			MasterStore.loadStoreRecords(accntArray);
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');
			if(as.isHidden()) {
				as.show();
			}else {
				as.hide()
			}
		},
		fnSetStDate:function(newValue) {
			if(newValue == null){
				return false;
			}else{
				if(UniDate.getDbDateStr(newValue).substring(0, 6) < (UniDate.getDbDateStr(newValue).substring(0, 4) + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6))){
					panelSearch.setValue('ST_DATE', UniDate.getDbDateStr(newValue).substring(0, 4)-1 + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6));
				}else{
					panelSearch.setValue('ST_DATE', UniDate.getDbDateStr(newValue).substring(0, 4) + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6));
				}
			}
		},
		onPrintButtonDown: function(record) {
			var param= {};
			if(record!=null&&record[0]!=null&&record!=null)
			param = record[0].data
			var win = Ext.create('widget.PDFPrintWindow', {
				url: CPATH+'/accnt/agb270skrPrint.do',
				prgID: 'agb270skr',
				extParam: param
			})
			win.center();
			win.show();
		}
	});

	function createModelField(colData) {
		var fields = [
			{name: 'DATA_TYPE'		,text: '유형'			,type: 'string'},
			{name: 'CUSTOM_NAME'	,text: '거래처명'		,type: 'string'},
			{name: 'CUSTOM_CODE'	,text: '거래처코드'		,type: 'string'},
			{name: 'COMPANY_NUM'	,text: '사업자번호'		,type: 'string'},		//20210819 추가
			{name: 'MONEY_UNIT'		,text: '화폐단위'		,type: 'string'},
			{name: 'AR_AMT_I'		,text: '채권합계'		,type: 'uniPrice'},
			{name: 'AP_AMT_I'		,text: '채무합계'		,type: 'uniPrice'},
			{name: 'JAN_AMT_I'		,text: '잔액'			,type: 'uniPrice'}
		];
		Ext.each(colData, function(item, index){
			fields.push({name: 'AMT' + item.ACCNT, text: item.ACCNT_NAME,	 type: 'uniPrice'});
		});
		return fields;
	}

	// 그리드 컬럼 생성
	function createGridColumn(colData) {
		var columns = [
			//20210819 주석: 사용용도 없어 주석
//			{ dataIndex: 'ISCHECKED', 	xtype : 'checkcolumn',	width: 30, hidden:false,locked: true,
//				listeners:{
//					checkchange: function( column, rowIndex, checked, eOpts ) {
//						if(checked) {
//							masterGrid.select(rowIndex);
//						}
//					}
//				}
//			},
//			{dataIndex: 'DATA_TYPE'				, text: '유형',		width: 66, hidden: true},
			{	//20210819 추가
				xtype		: 'rownumberer', 
				sortable	: false,
				align		: 'center !important',
				resizable	: true,
				locked		: true,
				width		: 35
			},
			{dataIndex: 'CUSTOM_NAME'			, text: '거래처명'		, style: 'text-align: center',	width: 150},
			{dataIndex: 'CUSTOM_CODE'			, text: '거래처코드'		, style: 'text-align: center',	width: 80},
			{dataIndex: 'COMPANY_NUM'			, text: '사업자번호'		, style: 'text-align: center',	width: 110},		//20210819 추가
			{dataIndex: 'MONEY_UNIT_VIEW'		, text: '화폐단위'		, style: 'text-align: center',	width: 70, align: 'center'},
			{dataIndex: 'AR_AMT_I', text: '채권합계' , style: 'text-align: center'	, width: 130, align: 'right' ,xtype:'uniNnumberColumn', format: UniFormat.Price,
				renderer: function(value, metaData, record) {
					if(record.get('MONEY_UNIT') != UserInfo.currency){
						return Ext.util.Format.number(value, UniFormat.FC);	
					}else{
						return Ext.util.Format.number(value, UniFormat.Price);
					}
				}
			},
			{dataIndex: 'AP_AMT_I', text: '채무합계' , style: 'text-align: center'	, width: 130, align: 'right' ,xtype:'uniNnumberColumn', format: UniFormat.Price,
				renderer: function(value, metaData, record) {
					if(record.get('MONEY_UNIT') != UserInfo.currency){
						return Ext.util.Format.number(value, UniFormat.FC);	
					}else{
						return Ext.util.Format.number(value, UniFormat.Price);
					}
				}
			},
			{dataIndex: 'JAN_AMT_I', text: '잔액' , style: 'text-align: center'	, width: 130, align: 'right' ,xtype:'uniNnumberColumn', format: UniFormat.Price,
				renderer: function(value, metaData, record) {
					if(record.get('MONEY_UNIT') != UserInfo.currency){
						return Ext.util.Format.number(value, UniFormat.FC);	
					}else{
						return Ext.util.Format.number(value, UniFormat.Price);
					}
				}
			}
		];
		var array1 = new Array();
		var array2 = new Array();
		Ext.each(colData, function(item, i){
			if(item.ACCNT_DIVI == "1"){
				array1[i] = {dataIndex: 'AMT' + item.ACCNT, text: item.ACCNT_NAME , style: 'text-align: center'	, width: 130, align: 'right' ,xtype:'uniNnumberColumn', format: UniFormat.Price,
					renderer: function(value, metaData, record) {
						if(record.get('MONEY_UNIT') != UserInfo.currency){
							return Ext.util.Format.number(value, UniFormat.FC);	
						}else{
							return Ext.util.Format.number(value, UniFormat.Price);
						}
					}
				}
			}else{
				array2[i] = {dataIndex: 'AMT' + item.ACCNT, text: item.ACCNT_NAME , style: 'text-align: center'	, width: 130, align: 'right' ,xtype:'uniNnumberColumn', format: UniFormat.Price,
					renderer: function(value, metaData, record) {
						if(record.get('MONEY_UNIT') != UserInfo.currency){
							return Ext.util.Format.number(value, UniFormat.FC);	
						}else{
							return Ext.util.Format.number(value, UniFormat.Price);
						}
					}
				}
			}
		});	
		columns.push(
			{text: '채권',
				columns: array1}
		);
		columns.push(
			{text: '채무',
				columns: array2}
		);
		console.log(columns);
		return columns;
	}

	function createModelStore(colData, accntArray) {
		var fields	= createModelField(colData);
		columns		= createGridColumn(colData);
		Ext.destroy(Ext.getCmp('dinamicModel'));
		Ext.destroy(Ext.getCmp('dinamicStore'));
	
		dinamicStore = Unilite.createStore('dinamicStore', {
			model	: 'Agb270skrModel',
			uniOpt	: {
				isMaster	: true,			// 상위 버튼 연결 
				editable	: false,		// 수정 모드 사용 
				deletable	: false,		// 삭제 가능 여부 
				useNavi		: false			// prev | newxt 버튼 사용
			},
			autoLoad: false,
			proxy	: {
				type: 'direct',
				api	: {
					read: 'agb270skrService.selectList'
				}
			},
			loadStoreRecords: function(accntArray){
				var param= Ext.getCmp('searchForm').getValues();
				param.ACCNTS = accntArray;
				this.load({
					params: param
				});
			},
			listeners: {
				load: function() {
				}
			},
			_onStoreLoad: function ( store, records, successful, eOpts ) {
				if(this.uniOpt.isMaster) {
					var recLength = 0;
					Ext.each(records, function(record, idx){
						if(record.get('DATA_TYPE') == 'D'){
							recLength++;
						}
					});
					if (records) {
						UniAppManager.setToolbarButtons('save', false);
						var msg = recLength + Msg.sMB001; //'건이 조회되었습니다.';
						//console.log(msg, st);
						UniAppManager.updateStatus(msg, true);	
					}
				}
			}
		});
		dinamicStore.loadStoreRecords(accntArray);
		masterGrid.reconfigure(dinamicStore, columns);
	}
};
</script>