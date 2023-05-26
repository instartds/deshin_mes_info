<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="aba130ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A054" /> <!-- 집계항목-->
	<t:ExtComboStore comboType="AU" comboCode="A051" /> <!-- 좌우-->
	<t:ExtComboStore comboType="AU" comboCode="A052" /> <!-- 집계구분-->
	<t:ExtComboStore comboType="AU" comboCode="A053" /> <!-- 계산유형-->
	<t:ExtComboStore comboType="AU" comboCode="A054" /> <!-- 참조-->
	<t:ExtComboStore comboType="AU" comboCode="A072" /> <!-- 계산구분-->
	<t:ExtComboStore comboType="AU" comboCode="A073" /> <!-- 계산식구분-->
	<t:ExtComboStore comboType="AU" comboCode="A050" /> <!-- 위치-->
	<t:ExtComboStore comboType="AU" comboCode="A048" /> <!-- 기준-->
	<t:ExtComboStore comboType="AU" comboCode="A004" /> <!-- 구분-->
	<t:ExtComboStore comboType="AU" comboCode="A093" /> <!-- 집계항목설정차수-->
	<t:ExtComboStore comboType="AU" comboCode="A095" /> <!-- 계정구분항목-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >
var gsGubun = '${gsGubun}';	//재무제표 양식차수
function appMain() {
	var formCopyWindow;		//양식복사창
	var activeGridId = 'aba130ukrMasterGrid1'; // 선택된 그리드 (detailGrid포함)
	var activeMasterGridId = 'aba130ukrMasterGrid1';	//저장 될 master그리드(detailGrid는 포함 않됨)

	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Aba130ukrModel1', {	//재무제표
		fields: [
			{name: 'COMP_CODE'			, text: '법인코드'		,type: 'string', defaultValue: UserInfo.compCode},
			{name: 'GUBUN'				, text: '집계항목설정차수'	,type: 'string', comboType:'AU', comboCode:'A093', allowBlank: false},
			{name: 'DIVI'				, text: '구분'		,type: 'string' , comboType:'AU', comboCode:'A054', allowBlank: false},
			{name: 'SEQ'				, text: '순번' 		,type: 'string', allowBlank: false, maxLength: 5},
			{name: 'ACCNT_CD'			, text: '코드'		,type: 'string', allowBlank: false, maxLength: 16},
			{name: 'ACCNT_NAME'			, text: '항목명'		,type: 'string', allowBlank: false, maxLength: 100},
			{name: 'ANNOT'				, text: '주석번호'		,type: 'string'},
			{name: 'OPT_DIVI'			, text: '집계구분'		,type: 'string', comboType:'AU', comboCode:'A052'},
			{name: 'RIGHT_LEFT'			, text: '좌우'		,type: 'string', comboType:'AU', comboCode:'A051'},
			{name: 'DIS_DIVI'			, text: '위치'		,type: 'string', comboType:'AU', comboCode:'A050', allowBlank: false},
			{name: 'KIND_DIVI'			, text: '집계항목'		,type: 'string', comboType:'AU', comboCode:'A054'},
			{name: 'KIND_DIVI2'			, text: '집계항목'		,type: 'string', comboType:'AU', comboCode:'A095'},// 자동변동표
			{name: 'ACCNT_NAME2'		, text: '항목명2'		,type: 'string', maxLength: 100},
			{name: 'ACCNT_NAME3'		, text: '항목명3'		,type: 'string', maxLength: 100},
			{name: 'DISPLAY_YN'			, text: '인쇄여부'		,type: 'string', comboType: "AU", comboCode: "A004"},
			
			{name: 'UPDATE_DB_USER'		, text: '수정자'		,type: 'string', defaultValue: UserInfo.userID},
			{name: 'UPDATE_DB_TIME'		, text: '수정일'		,type: 'uniDate'}
		]
	});


	Unilite.defineModel('Aba130ukrModel2', {	// 현금흐름표
		fields: [
			{name: 'GUBUN'				, text: '집계항목설정차수'	,type: 'string', comboType:'AU', comboCode:'A093', allowBlank: false},
			{name: 'DIVI'				, text: '구분'		,type: 'string' , comboType:'AU', comboCode:'A054', allowBlank: false},
			{name: 'SEQ'				, text: '순번' 		,type: 'string', allowBlank: false, maxLength: 5},
			{name: 'ACCNT_CD'			, text: '코드'		,type: 'string', allowBlank: false, maxLength: 16},

			{name: 'ACCNT_NAME'			, text: '항목명'		,type: 'string', allowBlank: false, maxLength: 100},
			{name: 'OPT_DIVI'			, text: '집계구분'		,type: 'string', comboType:'AU', comboCode:'A052'},
			{name: 'DIS_DIVI'			, text: '인쇄여부'		,type: 'string', comboType:'AU', comboCode:'A050', allowBlank: false},
			{name: 'ACCNT_NAME2'		, text: '항목명2'		,type: 'string', maxLength: 100},
			{name: 'ACCNT_NAME3'		, text: '항목명3'		,type: 'string', maxLength: 100},

			{name: 'UPDATE_DB_USER'		, text: '수정자'		,type: 'string', defaultValue: UserInfo.userID},
			{name: 'UPDATE_DB_TIME'		, text: '수정일'		,type: 'uniDate'},
			{name: 'COMP_CODE'			, text: '법인코드'		,type: 'string', defaultValue: UserInfo.compCode},
			
			/*사용 저장시 필요한 항목*/
			{name: 'ANNOT'				, text: '주석번호'		,type: 'string'},
			{name: 'RIGHT_LEFT'			, text: '좌우'		,type: 'string', comboType:'AU', comboCode:'A051'},
			{name: 'KIND_DIVI'			, text: '집계항목'		,type: 'string', comboType:'AU', comboCode:'A054'},
			{name: 'DISPLAY_YN'			, text: '인쇄여부'		,type: 'string', comboType: "AU", comboCode: "A004"}
		]
	});
	
	Unilite.defineModel('Aba130ukrModel3', { //디테일
		fields: [  	  
			{name: 'GUBUN'				, text: '집계항목설정차수'	,type: 'string' , comboType:'AU', comboCode:'A093', allowBlank: false}, /* A093 */
			{name: 'DIVI'				, text: '구분'		,type: 'string', allowBlank: false}, /* A054 */   
			{name: 'ACCNT_CD'			, text: '출력계정코드'	,type: 'string', allowBlank: false},
			{name: 'ACCNT'				, text: '계정코드'		,type: 'string', allowBlank: false, maxLength: 8},
			{name: 'ACCNT_NAME'			, text: '계정과목명'		,type: 'string'},
			{name: 'CAL_TYPE'			, text: '계산유형'		,type: 'string' , comboType:'AU', comboCode:'A053', allowBlank: false},
			{name: 'DR_CR'				, text: '계산구분'		,type: 'string' , comboType:'AU', comboCode:'A072'},
			{name: 'CAL_DIVI'			, text: '계산식구분'		,type: 'string' , comboType:'AU', comboCode:'A073', allowBlank: false},
			{name: 'REFER'				, text: '참조'		,type: 'string' , comboType:'AU', comboCode:'A054'},

			{name: 'UPDATE_DB_USER'		, text: '수정자'		,type: 'string', defaultValue: UserInfo.userID},
			{name: 'UPDATE_DB_TIME'	 	, text: '수정일'		,type: 'uniDate'},
			{name: 'COMP_CODE'  		, text: '법인코드'		,type: 'string', defaultValue: UserInfo.compCode}
		]
	});

	// GroupField string type으로 변환
	function dateToString(v, record){
		return UniDate.safeFormat(v);
	}

	var directMasterProxy1 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read : 'aba130ukrService.selectMasterList1',
			update: 'aba130ukrService.updateMaster',
			create: 'aba130ukrService.insertMaster',
			destroy: 'aba130ukrService.deleteMaster',
			syncAll: 'aba130ukrService.saveAll'
		}
	});

	var directDetailProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read : 'aba130ukrService.selectDetailList',
			update: 'aba130ukrService.updateDetail',
			create: 'aba130ukrService.insertDetail',
			destroy: 'aba130ukrService.deleteDetail',
			syncAll: 'aba130ukrService.saveAll'
		}
	});

	/**
	 * Store 정의(Service 정의)
	 * 제무제표 탭
	 * @type 
	 */
	var directMasterStore1 = Unilite.createStore('aba130ukrMasterStore1',{
		model: 'Aba130ukrModel1',
		uniOpt: {
			isMaster: false,		// 상위 버튼 연결 
			editable: true,			// 수정 모드 사용 
			deletable:true,			// 삭제 가능 여부 
			useNavi : false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: directMasterProxy1,
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore : function()	{
			var inValidRecs = this.getInvalidRecords();
			if(inValidRecs.length == 0 ) {
				var config = {
					params:[panelSearch.getValues()],
					success : function() {
						if(directDetailStore.isDirty())	{
							directDetailStore.saveStore();
						}else {
							UniAppManager.app.onQueryButtonDown();
						}
					}
				}
				this.syncAllDirect(config);
			}else {
				masterGrid1.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners:{
			load: function(store, records, successful, eOpts) {
				if(records != null && records.length > 0 ){
					UniAppManager.setToolbarButtons('delete', true);
				}
			},
			update : function( store, record, operation, modifiedFieldNames, details, eOpts ){
				UniAppManager.setToolbarButtons('save', true);
			},
			datachanged : function(store,  eOpts) {
				if( directDetailStore.isDirty() || store.isDirty())	{
					UniAppManager.setToolbarButtons('save', true);
				}else {
					UniAppManager.setToolbarButtons('save', false);
				}
			}
		}
	});

	/**
	 * Store 정의(Service 정의)
	 * 현금흐름표 탭
	 * @type 
	 */
	var directMasterStore2 = Unilite.createStore('aba130ukrDetailStore',{
		model: 'Aba130ukrModel2',
		uniOpt: {
			isMaster: false,	// 상위 버튼 연결 
			editable: true,		// 수정 모드 사용 
			deletable:true,		// 삭제 가능 여부 
			useNavi : false		// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: directMasterProxy1,
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore : function() {
			var inValidRecs = this.getInvalidRecords();
			if(inValidRecs.length == 0 ) {
				var config = {
					params:[panelSearch.getValues()],
					success : function() {
						if(directDetailStore.isDirty()) {
							directDetailStore.saveStore();
						} else {
							UniAppManager.app.onQueryButtonDown();
						}
					}
				}
				this.syncAllDirect(config);
			}else {
				masterGrid2.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners:{
			load: function(store, records, successful, eOpts) {
				if(records != null && records.length > 0 ){
					UniAppManager.setToolbarButtons('delete', true);
				}
			},
			update : function( store, record, operation, modifiedFieldNames, details, eOpts ){
				UniAppManager.setToolbarButtons('save', true);
			},
			datachanged : function(store,  eOpts) {
				if( directDetailStore.isDirty() || store.isDirty()) {
					UniAppManager.setToolbarButtons('save', true);
				}else {
					UniAppManager.setToolbarButtons('save', false);
				}
			}
		}
	});
	
	var directDetailStore = Unilite.createStore('aba130ukrMasterStore2',{
		model: 'Aba130ukrModel3',
		uniOpt: {
			isMaster: false,		// 상위 버튼 연결 
			editable: true,			// 수정 모드 사용 
			deletable:true,			// 삭제 가능 여부 
			useNavi : false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: directDetailProxy,
		loadStoreRecords: function(record) {

			var searchParam= Ext.getCmp('searchForm').getValues();
			var param= {
				'ACCNT_CD':record.get('ACCNT_CD')};	
			var params = Ext.merge(searchParam, param);
			console.log( param );
			this.load({
				params : params
			});
		},
		saveStore : function() {
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();
			var toDelete = this.getRemovedRecords();

			var list = [].concat(toCreate);
			if(fnCheckReqiured(list)) return false;

			if(inValidRecs.length == 0 ) {
				var config = {
					params:[panelSearch.getValues()],
					success : function() {
						UniAppManager.app.onQueryButtonDown();
					}
				}
				this.syncAllDirect(config);
			}else {
				detailGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners:{
			load: function(store, records, successful, eOpts) {
				if(records != null && records.length > 0 ){
					UniAppManager.setToolbarButtons('delete', true);
				}
			},
			update : function( store, record, operation, modifiedFieldNames, details, eOpts ){
				UniAppManager.setToolbarButtons('save', true);		
			},
			datachanged : function(store,  eOpts) {
				if( directMasterStore1.isDirty() || directMasterStore2.isDirty() || store.isDirty() )	{
					UniAppManager.setToolbarButtons('save', true);	
				}else {
					UniAppManager.setToolbarButtons('save', false);
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
		collapsed: UserInfo.appOption.collapseLeftSearch,
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
			layout : {type : 'vbox', align : 'stretch'},
			items : [{
				xtype:'container',
				layout : {type : 'uniTable', columns : 1},
				items:[{
					fieldLabel: '집계항목차수',
					name:'GUBUN',	
					xtype: 'uniCombobox',
					allowBlank:false,
					comboType:'AU',
					comboCode:'A093',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('GUBUN', newValue);
						}
					}
				},{
					fieldLabel: '집계항목',
					name:'ITEM_SUM',
					xtype: 'uniCombobox',
					allowBlank:false,
					comboType:'AU',
					comboCode:'A054',
					value:'10',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('ITEM_SUM', newValue);
						},
						beforequery:function( queryPlan, eOpts )	{
							var itemSumStore = queryPlan.combo.store;
							itemSumStore.clearFilter();
							if(activeMasterGridId == 'aba130ukrMasterGrid1'){
								itemSumStore.filter("refCode3","1");
							}else{
								itemSumStore.filter("refCode3","2");
							}
						}
					}
				}]
			}]
		}]
	});	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 4, tableAttrs: {width: '100%'}},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
			fieldLabel: '집계항목차수',
			name:'GUBUN',
			xtype: 'uniCombobox',
			allowBlank:false,
			comboType:'AU',
			comboCode:'A093',
//			labelWidth: 100,
			tdAttrs: {width: 300},
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('GUBUN', newValue);
				}
			}
		},{
			fieldLabel: '집계항목',
			name:'ITEM_SUM',
			xtype: 'uniCombobox',
			allowBlank:false,
			comboType:'AU',
			comboCode:'A054',
			value:'10',
//			labelWidth: 100,
			tdAttrs: {width: 300},
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					
					if(activeMasterGridId == 'aba130ukrMasterGrid1'){
						//자동변동표
						var codeArr = ['35','36'];
						//저장여부 체크
						if((!UniUtils.indexOf(newValue, codeArr) && UniUtils.indexOf(oldValue, codeArr))
							|| (UniUtils.indexOf(newValue, codeArr) && !UniUtils.indexOf(oldValue, codeArr))
							) {
							if(!UniAppManager.app._needSave())	{
								directMasterStore1.loadData({});
								directDetailStore.loadData({});
							} else {
								if(confirm('내용이 변경되었습니다.'+ "\n" +"변경된 내용을 저장하시겠습니까?"))	{
									UniAppManager.app.onSaveDataButtonDown();
								}
								return false;
							}
							var kind054 =  masterGrid1.getColumn("KIND_DIVI");
							var kind095 =  masterGrid1.getColumn("KIND_DIVI2");
							if(UniUtils.indexOf(newValue, codeArr))	{
								kind054.hide();
								kind095.show();
							} else {
								kind054.show();
								kind095.hide();
							}
						}
					}
					panelSearch.setValue('ITEM_SUM', newValue);
				},
				beforequery:function( queryPlan, eOpts )	{
					var itemSumStore = queryPlan.combo.store;
					itemSumStore.clearFilter();
					
					if(activeMasterGridId == 'aba130ukrMasterGrid1'){
						itemSumStore.filter("refCode3","1");
					}else{
						itemSumStore.filter("refCode3","2");
					}
				}
			}
		},{
			width: 100,
			xtype: 'button',
			text: '양식복사',	
			tdAttrs: {align: 'right'},
			handler : function() {
				openFormCopyWindow();
			}
		},{
			width: 100,
			xtype: 'button',
			text: '집계항목적용',
			tdAttrs: {align: 'left', width: 120},
			margin: '0 0 0 5',
			handler : function() {
				if(!UniAppManager.app.isValidSearchForm()){
					return false;
				}
				if(confirm(Msg.sMA0221)){
				   var param = {GUBUN: panelSearch.getValue('GUBUN')};
				   Ext.getBody().mask('로딩중...','loading-indicator');
				   aba130ukrService.insertTotItem(param, function(provider, response)	{
						if(provider){
							UniAppManager.updateStatus(Msg.sMB011);
						}
						Ext.getBody().unmask();
					});	
				}
			}
		}]
	});

	var formCopySearch = Unilite.createSearchForm('formCopySearchForm', {
		padding: '0 0 0 0',
		disabled :false,
		width: 5000,
		height: 3000,		
		layout: {type: 'uniTable', columns :1},
		trackResetOnLoad: true,
		defaults: {xtype: 'uniTextfield', width: 350},
		items: [{	    	
			fieldLabel: '원본 재무제표양식차수',
			labelWidth: 150,
			margin: '20 0 0 0',
			name:'GUBUN1',	
			xtype: 'uniCombobox',
			allowBlank:false,
			comboType:'AU',
			comboCode:'A093'
		}, {
			fieldLabel: '신규 재무제표양식차수',
			labelWidth: 150,
			margin: '10 0 0 0',
			name:'GUBUN2',	
			xtype: 'uniCombobox',
			allowBlank:false,
			comboType:'AU',
			comboCode:'A093'
		}]
	});

	function openFormCopyWindow() {
		if(!formCopyWindow) {
			formCopyWindow = Ext.create('widget.uniDetailWindow', {
				title: '양식복사',
				resizable:false,
				width: 400,
				height:180,
				layout: {type:'uniTable', columns: 1},
				items: [formCopySearch],
				bbar:  [ '->',
						{	itemId : 'searchBtn',
							text: '확인',
							margin: '0 5 0 0',
							handler: function() {
								if(Ext.isEmpty(formCopySearch.getValue('GUBUN1')) || Ext.isEmpty(formCopySearch.getValue('GUBUN2'))){
									alert('재무제표 양식차수를 입력 하십시오.');
								}else{
									formCopySearch.getEl().mask('로딩중...','loading-indicator');
									var param = {GUBUN1 : formCopySearch.getValue('GUBUN1'), GUBUN2 : formCopySearch.getValue('GUBUN2')}
									aba130ukrService.insertFormCopy(param, function(provider, response)	{
										if(provider){
											UniAppManager.updateStatus(Msg.sMB011);
											formCopyWindow.hide();
										}
										formCopySearch.getEl().unmask();
									});
								}
							},
							disabled: false
						}, {
							itemId : 'closeBtn',
							text: '취소',
							handler: function() {
								formCopyWindow.hide();
							},
							disabled: false
						},'->'
				],
				listeners : {
					beforehide: function(me, eOpt)	{
						formCopySearch.clearForm();
					},
					beforeclose: function( panel, eOpts )	{
						formCopySearch.clearForm();
					},
					show: function( panel, eOpts )	{
					}
				}
			})
		}
		formCopyWindow.center();
		formCopyWindow.show();
	}
	
	var masterGrid1 = Unilite.createGrid('aba130ukrMasterGrid1', {
		title: '재무제표',
		layout : 'fit',
		store : directMasterStore1,
		sortableColumns : false,		// 정렬 불가능
		uniOpt:{	
			expandLastColumn: false,
			useRowNumberer	: true,
			copiedRow		: true
		},
		features: [{
			id: 'masterGridSubTotal1',
			ftype: 'uniGroupingsummary', 
			showSummaryRow: false 
			},{
			id: 'masterGridTotal1',
			ftype: 'uniSummary',
			showSummaryRow: false
		}],
		columns: [

			{dataIndex: 'GUBUN'				, width: 53 		,hidden:true},
			{dataIndex: 'DIVI'				, width: 40 		,hidden:true},
			{dataIndex: 'SEQ'				, width: 53, align: 'center' , hidden:true},
			{dataIndex: 'ACCNT_CD'			, width: 66 }, 				
			{dataIndex: 'ACCNT_NAME'		, width: 230/*, renderer:function(value){return '<div style="white-space: pre;">'+(value ? value:'&nbsp;')+"</div>"}*/}, 				
			{dataIndex: 'OPT_DIVI'			, width: 73 },
			{dataIndex: 'RIGHT_LEFT'		, width: 53 		, hidden:true},
			{dataIndex: 'DIS_DIVI'			, width: 100 },
			{dataIndex: 'DISPLAY_YN'		, width: 80, align: 'center'},
			{dataIndex: 'KIND_DIVI'			, width: 80 }, 
			{dataIndex: 'KIND_DIVI2'		, width: 80 , hidden:true},
			{dataIndex: 'ACCNT_NAME2'		, width: 133},
			{dataIndex: 'ACCNT_NAME3'		, minWidth: 133, flex: 1},
			{dataIndex: 'UPDATE_DB_USER'	, width: 133 		, hidden:true},
			{dataIndex: 'UPDATE_DB_TIME'	, width: 133 		, hidden:true},
			{dataIndex: 'COMP_CODE'			, width: 133 		, hidden:true}
		],
		listeners: {
			selectionchange:function( model1, selected, eOpts ){
				if(selected.length > 0)	{
					var record = selected[0];
					directDetailStore.loadData({})
					if(!record.phantom){
						directDetailStore.loadStoreRecords(record);
					}
				}
			},
			render: function(grid, eOpts){
				var girdNm = grid.getItemId();
				var store = grid.getStore();
				grid.getEl().on('click', function(e, t, eOpt) {
					activeGridId = girdNm;
					activeMasterGridId = girdNm;	//저장할 마스터 그리드가 뭔지 알기위해
					//store.onStoreActionEnable();
					if( directDetailStore.isDirty() || directMasterStore1.isDirty() ) {
						UniAppManager.setToolbarButtons('save', true);
					}else {
						UniAppManager.setToolbarButtons('save', false);
					}
					if(grid.getStore().getCount() > 0)	{
						UniAppManager.setToolbarButtons('delete', true);
					}else {
						UniAppManager.setToolbarButtons('delete', false);
					}
				});
			},	
			beforedeselect : function ( gird, record, index, eOpts ){
				if(directDetailStore.isDirty())	{
					if(confirm(Msg.sMB017 + "\n" + Msg.sMB061))	{
						var inValidRecs = directDetailStore.getInvalidRecords();
						if(inValidRecs.length > 0 )	{
							alert(Msg.sMB083);
							return false;
						}else {
							directDetailStore.saveStore();
						}
					}
				}
			},
			beforeedit  : function( editor, e, eOpts ) {
				if (UniUtils.indexOf(e.field,['SEQ', 'ACCNT_CD'])) {
					if(e.record.phantom){
						return true;
					}else{
						return false;
					}
				}else if (UniUtils.indexOf(e.field,['ACCNT_NAME', 'ACCNT_NAME2', 'ACCNT_NAME3', 'OPT_DIVI', 'RIGHT_LEFT', 'DIS_DIVI', 'KIND_DIVI2', 'DISPLAY_YN'])) {
					return true;
				}else if (UniUtils.indexOf(e.field,['KIND_DIVI']) ) {
					if(e.record.phantom){
						return true;
					} else if(e.record.get("KIND_DIVI") == '35' || e.record.get("KIND_DIVI") == '36' ){ //자본변동표인 경우만 수정 가능 (자본변동표가 아닌 경우는 집계항목 컬럼 edit되지 않도록 수정)
						return true;
					} else {
						return false;
					}
				}else{
					return false;
				}
			}
		}
	});

	/**
	* Master Grid2 정의(Grid Panel)
	* @type 
	*/

	var masterGrid2 = Unilite.createGrid('aba130ukrMasterGrid2', {
		title : '현금흐름표',
		layout : 'fit',
		store : directMasterStore1,
		sortableColumns : false,			// 정렬 불가능
		uniOpt:{	
			expandLastColumn: false,
			useRowNumberer	: true,
			copiedRow		: true
		},
		store: directMasterStore2,
		features: [{
			id: 'masterGridSubTotal2',
			ftype: 'uniGroupingsummary',
			showSummaryRow: false 
			},{
			id: 'masterGridTotal2',
			ftype: 'uniSummary',
			showSummaryRow: false
		}],
		columns: [
			{dataIndex: 'GUBUN'				, width: 66 		, hidden:true},
			{dataIndex: 'DIVI'				, width: 40 		, hidden:true},
			{dataIndex: 'SEQ'				, width: 53, align: 'center' , hidden:true},
			{dataIndex: 'ACCNT_CD'			, width: 66 }, 				
			{dataIndex: 'ACCNT_NAME'		, width: 230/*, renderer:function(value){return '<div style="white-space: pre;">'+value+"</div>"}*/}, 				
			{dataIndex: 'OPT_DIVI'			, width: 73},
			{dataIndex: 'DIS_DIVI'			, width: 80			, hidden:true},
			{dataIndex: 'ACCNT_NAME2'		, minWidth: 133, flex: 1},
			{dataIndex: 'ACCNT_NAME3'		, minWidth: 133, flex: 1},
			{dataIndex: 'UPDATE_DB_USER'	, width: 133 		, hidden:true},
			{dataIndex: 'UPDATE_DB_TIME'	, width: 133 		, hidden:true},
			{dataIndex: 'COMP_CODE'			, width: 133 		, hidden:true}
		],
		listeners: {	
			selectionchange:function( model1, selected, eOpts ){
				if(selected.length > 0)	{
					var record = selected[0];
					directDetailStore.loadData({})
					if(!record.phantom){
						directDetailStore.loadStoreRecords(record);
					}
				}
			},
			render: function(grid, eOpts){
				var girdNm = grid.getItemId();
				var store = grid.getStore();
				grid.getEl().on('click', function(e, t, eOpt) {
					activeGridId = girdNm;
					activeMasterGridId = girdNm;	//저장할 마스터 그리드가 뭔지 알기위해
					if( directDetailStore.isDirty() || directMasterStore2.isDirty() ) {
						UniAppManager.setToolbarButtons('save', true);	
					}else {
						UniAppManager.setToolbarButtons('save', false);
					}
					if(grid.getStore().getCount() > 0)	{
						UniAppManager.setToolbarButtons('delete', true);
					}else {
						UniAppManager.setToolbarButtons('delete', false);
					}
				});
			 },
			 beforedeselect : function ( gird, record, index, eOpts ){
				if(directDetailStore.isDirty())	{
					if(confirm(Msg.sMB017 + "\n" + Msg.sMB061))	{
						var inValidRecs = directDetailStore.getInvalidRecords();
						if(inValidRecs.length > 0 )	{
							alert(Msg.sMB083);
							return false;
						}else {
							directDetailStore.saveStore();
						}
					}
				}
			},
			beforeedit  : function( editor, e, eOpts ) {
				if (UniUtils.indexOf(e.field,["SEQ", "ACCNT_CD"])) {
					if(e.record.phantom){
						return true;
					}else{
						return false;
					}
				}else if (UniUtils.indexOf(e.field,["ACCNT_NAME", "ACCNT_NAME2", "ACCNT_NAME3", "OPT_DIVI", "DIS_DIVI"])) {
					return true
				}else{
					return false;
				}
			}
		}
	});

	var detailGrid = Unilite.createGrid('aba130ukrDetailGrid', {
		layout : 'fit',
		region : 'east',
		title: '상세',
		store : directDetailStore, 
		uniOpt:{expandLastColumn	: true,
				useRowNumberer		: true,
				useMultipleSorting	: true,
				onLoadSelectFirst	: false
		},
		features: [{
			id: 'masterGridSubTotal3',
			ftype: 'uniGroupingsummary', 
			showSummaryRow: false 
			},{
			id: 'masterGridTotal3',
			ftype: 'uniSummary',
			showSummaryRow: false
		}],
		columns: [
			{dataIndex: 'GUBUN'				, width: 80			, hidden:true},
			{dataIndex: 'DIVI'				, width: 80 		, hidden:true},
			{dataIndex: 'ACCNT_CD'			, width: 80 		, hidden:true},

			{dataIndex: 'CAL_TYPE'			, width: 80 },
			{dataIndex: 'ACCNT'				, width: 80, 
				getEditor: function(record) {
					if(record.get('CAL_TYPE') == "1"){
						if (panelSearch.getValue('ITEM_SUM') == '48') {							//집계항목이 "수입집계"일 때, 관리항목 팝업(AC_CD == Q2)을 보여준다.
							return  Ext.create('Ext.grid.CellEditor', {
								ptype: 'cellediting',
								clicksToEdit: 1, // 1 or 2 , 수정 모드로 들어가기 위한 Click 횟수 
								autoCancel : false,
								selectOnFocus:true,
								field: Unilite.popup('COM_ABA210_G', {
									autoPopup: true,
									DBtextFieldName: 'COM_ABA210_NAME',
									listeners: {
										'onSelected': {
											fn: function(records, type) {
												console.log('records : ', records);
												 var grdRecord = detailGrid.uniOpt.currentRecord;
													Ext.each(records, function(record,i) {	
													grdRecord.set('ACCNT', record['COM_ABA210_CODE']);
													grdRecord.set('ACCNT_NAME', record['COM_ABA210_NAME']);
												});
											},
											scope: this
										},
										'onClear': function(type) {
											var grdRecord = detailGrid.uniOpt.currentRecord;
											grdRecord.set('ACCNT', '');
											grdRecord.set('ACCNT_NAME', '');
										},
										applyextparam: function(popup){
											popup.setExtParam({'SUB_CODE': 'E3'});
										}
									}
								})
							})

						} else {
							return  Ext.create('Ext.grid.CellEditor', {
								ptype: 'cellediting',
								clicksToEdit: 1, // 1 or 2 , 수정 모드로 들어가기 위한 Click 횟수 
								autoCancel : false,
								selectOnFocus:true,
								field: Unilite.popup('ACCNT_G', {
									autoPopup: true,
									DBtextFieldName: 'ACCNT_CODE',
									listeners: {
										'onSelected': {
											fn: function(records, type) {
												console.log('records : ', records);
												var grdRecord = detailGrid.uniOpt.currentRecord;
												Ext.each(records, function(record,i) {	
													grdRecord.set('ACCNT', record['ACCNT_CODE']);
													grdRecord.set('ACCNT_NAME', record['ACCNT_NAME']);
												}); 
											},
												scope: this
										},
										'onClear': function(type) {
											var grdRecord = detailGrid.uniOpt.currentRecord;
											grdRecord.set('ACCNT', '');
											grdRecord.set('ACCNT_NAME', '');
										},
										applyextparam: function(popup){
											popup.setExtParam({'ADD_QUERY': "SLIP_SW = 'Y' AND GROUP_YN = 'N'"});			//WHERE절 추카 쿼리
											popup.setExtParam({'CHARGE_CODE': ''});			//bParam(3)
										}
									}
								 })
							})
						}

					} else {
						return  Ext.create('Ext.grid.CellEditor', {
							ptype: 'cellediting',
							clicksToEdit: 1, // 1 or 2 , 수정 모드로 들어가기 위한 Click 횟수 
							autoCancel : false,
							selectOnFocus:true,
							field: {xtype: 'uniTextfield'}
						})
					}
				}
			},
			{dataIndex: 'ACCNT_NAME'		, width: 180, 
				getEditor: function(record) {
					if(record.get('CAL_TYPE') == "1"){
						if (panelSearch.getValue('ITEM_SUM') == '48') {															//집계항목이 "수입집계"일 때, 관리항목 팝업(AC_CD == Q2)을 보여준다.
							return  Ext.create('Ext.grid.CellEditor', {
								ptype: 'cellediting',
								clicksToEdit: 1, // 1 or 2 , 수정 모드로 들어가기 위한 Click 횟수 
								autoCancel : false,
								selectOnFocus:true,
								field: Unilite.popup('COM_ABA210_G', {
									autoPopup: true,
									listeners: {
										'onSelected': {
											fn: function(records, type) {
												console.log('records : ', records);
												var grdRecord = detailGrid.uniOpt.currentRecord;
												Ext.each(records, function(record,i) {	
													grdRecord.set('ACCNT', record['COM_ABA210_CODE']);
													grdRecord.set('ACCNT_NAME', record['COM_ABA210_NAME']);
												}); 
											},
											scope: this
										},
										'onClear': function(type) {
											var grdRecord = detailGrid.uniOpt.currentRecord;
											grdRecord.set('ACCNT', '');
											grdRecord.set('ACCNT_NAME', '');
										},
										applyextparam: function(popup){
											popup.setExtParam({'SUB_CODE': 'E3'});
										}
									}
								 })
							})

						} else {
							return  Ext.create('Ext.grid.CellEditor', {
								ptype: 'cellediting',
								clicksToEdit: 1, // 1 or 2 , 수정 모드로 들어가기 위한 Click 횟수 
								autoCancel : false,
								selectOnFocus:true,
								field: Unilite.popup('ACCNT_G', {
									autoPopup: true,
									listeners: {
										'onSelected': {
											fn: function(records, type) {
												console.log('records : ', records);
												var grdRecord = detailGrid.uniOpt.currentRecord;
												Ext.each(records, function(record,i) {	
													grdRecord.set('ACCNT', record['ACCNT_CODE']);
													grdRecord.set('ACCNT_NAME', record['ACCNT_NAME']);
												}); 
											},
												scope: this
										},
										'onClear': function(type) {
											var grdRecord = detailGrid.uniOpt.currentRecord;
											grdRecord.set('ACCNT', '');
											grdRecord.set('ACCNT_NAME', '');
										},
										applyextparam: function(popup){
											popup.setExtParam({'ADD_QUERY': "SLIP_SW = 'Y' AND GROUP_YN = 'N'"});			//WHERE절 추카 쿼리
											popup.setExtParam({'CHARGE_CODE': ''});			//bParam(3)
										}
									}
								})
							})
						}

					} else {
						return  Ext.create('Ext.grid.CellEditor', {
							ptype: 'cellediting',
							clicksToEdit: 1, // 1 or 2 , 수정 모드로 들어가기 위한 Click 횟수 
							autoCancel : false,
							selectOnFocus:true,
							field: {xtype: 'uniTextfield'}
						})
					}
				}
			},
			{dataIndex: 'DR_CR'				, width: 110 },
			{dataIndex: 'CAL_DIVI'			, width: 100 },
			{dataIndex: 'REFER'				, width: 120 },
			
			{dataIndex: 'UPDATE_DB_USER'	, width: 133 		, hidden:true},
			{dataIndex: 'UPDATE_DB_TIME'	, width: 133 		, hidden:true},
			{dataIndex: 'COMP_CODE'			, width: 63			, hidden:true}
		],
		listeners : {
			render: function(grid, eOpts){
				var girdNm = grid.getItemId();
				var store = grid.getStore();
				grid.getEl().on('click', function(e, t, eOpt) {
					activeGridId = girdNm;
					if( directDetailStore.isDirty() || directMasterStore1.isDirty() || directMasterStore2.isDirty()) {
						UniAppManager.setToolbarButtons('save', true);	
					}else {
						UniAppManager.setToolbarButtons('save', false);
					}
					if(grid.getStore().getCount() > 0)	{
						UniAppManager.setToolbarButtons('delete', true);
					}else {
						UniAppManager.setToolbarButtons('delete', false);
					}
				});
			},
			beforeedit  : function( editor, e, eOpts ) {
				if (UniUtils.indexOf(e.field,["CAL_TYPE", "ACCNT", "ACCNT_NAME"])) {
					if(e.record.phantom){
						return true;
					}else{
						return false;
					}
				}else if (UniUtils.indexOf(e.field,["DR_CR", "CAL_DIVI", "REFER"])) {
					return true;
				}else{
					return false;
				}
			}
		}
	});

	var tab = Unilite.createTabPanel('tabPanel',{
		region:'center',
		items: [
			 masterGrid1,
			 masterGrid2
		],
		listeners: {
			beforetabchange:  function ( tabPanel, newCard, oldCard, eOpts ) {
				var newTabId = newCard.getId();
				var itemSumField = panelSearch.getField("ITEM_SUM");
				var itemSumStore = itemSumField.store;
				switch(newTabId)	{
					case 'aba130ukrMasterGrid1':
						if(directMasterStore2.isDirty() || directDetailStore.isDirty())	{
							if(confirm(Msg.sMB017 + "\n" + Msg.sMB061))	{
								var inValidRecs = directMasterStore2.getInvalidRecords();
								if(inValidRecs.length > 0 )	{
									alert(Msg.sMB083);
								}else {
									UniAppManager.app.onSaveDataButtonDown();
								}
								return false;
							} else {
								if(directMasterStore2.isDirty()) {
									directMasterStore2.rejectChanges()
								}
								if(directDetailStore.isDirty()) {
									directDetailStore.rejectChanges()
								}
							}
						}
						activeMasterGridId = 'aba130ukrMasterGrid1';
						if(!Ext.isEmpty(itemSumStore)){
							itemSumStore.clearFilter();
							itemSumStore.filter("refCode3","1");
						}
						panelSearch.setValue('ITEM_SUM','');
						panelResult.setValue('ITEM_SUM','');
						directMasterStore1.loadData({});
						directDetailStore.loadData({});
						break;

					case 'aba130ukrMasterGrid2':

						if(directMasterStore1.isDirty() || directDetailStore.isDirty() ) {
							if(confirm(Msg.sMB017 + "\n" + Msg.sMB061))	{
								var inValidRecs = directMasterStore1.getInvalidRecords();
								if(inValidRecs.length > 0 )	{
									alert(Msg.sMB083);
								}else {
									UniAppManager.app.onSaveDataButtonDown();
								}
								return false;
							} else {
								if(directMasterStore1.isDirty()) {
									directMasterStore1.rejectChanges()
								}
								if(directDetailStore.isDirty()) {
									directDetailStore.rejectChanges()
								}
							}
						}
						activeMasterGridId = 'aba130ukrMasterGrid2';
						if(!Ext.isEmpty(itemSumStore))	{
							itemSumStore.clearFilter();
							itemSumStore.filter("refCode3","2");
						}
						panelSearch.setValue('ITEM_SUM','');
						panelResult.setValue('ITEM_SUM','');
						directMasterStore2.loadData({});
						directDetailStore.loadData({});
						break;
						
					default:
						break;
				}
			},
			tabchange: function( tabPanel, newCard, oldCard ) {
//        		if(oldCard.itemId == 'leftSystemMenu' || oldCard.itemId == 'leftGroupWareMenu') {
//        			tabPanel.uniOpt.oldTitle = tabPanel.title;
//        		}
//        		if(newCard.itemId != 'leftSystemMenu' || oldCard.itemId != 'leftGroupWareMenu') {
//        			tabPanel.setTitle(newCard.title);
//        		} else {
//        			tabPanel.setTitle(tabPanel.uniOpt.oldTitle);
//        		}
			}
		}
	});
	var tab2 = Unilite.createTabPanel('tabPanel2',{
		region:'east',
		items: [
			detailGrid
		]
	});



	Unilite.Main( {
		border: false,
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				tab, tab2, panelResult
			]
		},
			panelSearch
		]
		, 
		id : 'aba130ukrApp',
		fnInitBinding : function() {
//			var gubun = Ext.data.StoreManager.lookup( 'CBS_AU_A093' ).getAt(0).get ('value' );
			panelSearch.setValue('GUBUN', gsGubun);
			panelResult.setValue('GUBUN', gsGubun);
			
			UniAppManager.setToolbarButtons(['newData'],true);
			UniAppManager.setToolbarButtons(['reset'],false);
			
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch) {
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('ITEM_SUM');
		},
		onQueryButtonDown : function()	{
			if(!this.isValidSearchForm()){
				return false;
			}
			var activeTabId = tab.getActiveTab().getId();
			if(activeTabId == 'aba130ukrMasterGrid1'){
				directMasterStore1.loadStoreRecords();
			}
			else if(activeTabId == 'aba130ukrMasterGrid2'){
				directMasterStore2.loadStoreRecords()
			}
		}, 
		onNewDataButtonDown : function()	{
			if(activeGridId == 'aba130ukrMasterGrid1' )	{
				var r = {
					GUBUN: panelSearch.getValue('GUBUN'),		//집계항목 차수
					DIVI: panelSearch.getValue('ITEM_SUM'),		//집계항목
					DIS_DIVI: "1",
					COMP_CODE: UserInfo.compCode,
					DISPLAY_YN : 'N'							// 인쇄여부(DEFAULT: 미사용)
				}
				masterGrid1.createRow(r, 'SEQ');
			}else if(activeGridId == 'aba130ukrMasterGrid2'){
				var r = {
					GUBUN: panelSearch.getValue('GUBUN'),		//집계항목 차수
					DIVI: panelSearch.getValue('ITEM_SUM'),		//집계항목
					DIS_DIVI: "1",
					COMP_CODE: UserInfo.compCode
				}
				masterGrid2.createRow(r, 'SEQ');
			}else if(activeGridId == 'aba130ukrDetailGrid') {
				if(activeMasterGridId == 'aba130ukrMasterGrid1' ) {
					var pRecord = masterGrid1.getSelectedRecord();	
				}else if(activeMasterGridId == 'aba130ukrMasterGrid2'){
					var pRecord = masterGrid2.getSelectedRecord();
				}
				if(pRecord != null && !pRecord.phantom)	{
					var r = {
						GUBUN: pRecord.get("GUBUN"),
						DIVI: pRecord.get("DIVI"),
						ACCNT_CD: pRecord.get("ACCNT_CD"),
						COMP_CODE: UserInfo.compCode
					}
					detailGrid.createRow(r, 'CAL_TYPE');
				}
			}
		},
		onSaveDataButtonDown: function () {
			// 재무재표 탭
			if(activeMasterGridId == 'aba130ukrMasterGrid1' ) {
				// 재무제표 데이터가 변경된 경우
				if(directMasterStore1.isDirty()){
					var records = directMasterStore1.data.items;
					// 순번 저장
					Ext.each(records, function(record,i) {
						record.set('SEQ', directMasterStore1.indexOf(record) + 1);
						directMasterStore1.data.items[i].phantom = true;
					});
				}
				var inValidRecs1 = directMasterStore1.getInvalidRecords();
			
			// 현금흐름표
			} else if(activeMasterGridId == 'aba130ukrMasterGrid2'){
				
				// 현금흐름표 데이터가 변경된 경우
				if(directMasterStore2.isDirty()){
					var records = directMasterStore2.data.items;
					// 순번 저장
					Ext.each(records, function(record,i) {
						record.set('SEQ', directMasterStore2.indexOf(record) + 1);
						directMasterStore2.data.items[i].phantom = true;
					});
				}
				var inValidRecs1 = directMasterStore2.getInvalidRecords();
			}
			
			var inValidRecs2 = directDetailStore.getInvalidRecords();
			
			if(inValidRecs1.length != 0 || inValidRecs2.length != 0)	{
				if(inValidRecs1.length != 0){
					if(activeMasterGridId == 'aba130ukrMasterGrid1' )	{
						masterGrid1.uniSelectInvalidColumnAndAlert(inValidRecs1);
					}else if(activeMasterGridId == 'aba130ukrMasterGrid2'){
						masterGrid2.uniSelectInvalidColumnAndAlert(inValidRecs1);
					}
				}
				if(inValidRecs2.length != 0){
					detailGrid.uniSelectInvalidColumnAndAlert(inValidRecs2);
				}
				return false;
			}else{
				if(directMasterStore1.isDirty() || directMasterStore2.isDirty()) {
					if(activeMasterGridId == 'aba130ukrMasterGrid1' ) {
						directMasterStore1.saveStore();			//Master 데이타 저장 성공 후 Detail 저장함.	
					}else if(activeMasterGridId == 'aba130ukrMasterGrid2'){
						directMasterStore2.saveStore();			//Master 데이타 저장 성공 후 Detail 저장함.
					}		
				}else if(directDetailStore.isDirty()){
					directDetailStore.saveStore();
				}
			}			
		},
		onDeleteDataButtonDown : function()	{
			if(activeGridId == 'aba130ukrMasterGrid1')	{
				var selRow = masterGrid1.getSelectedRecord();
				if(selRow) {
					if(selRow.phantom === true)	{
						masterGrid1.deleteSelectedRow();
					}else {
						var toDelete = directDetailStore.getRemovedRecords();
						if(toDelete.length > 0 || directDetailStore.getCount() > 0 || selRow.get('OPT_DIVI') == "5"){
							alert(Msg.sMB078);
							return false;
						}
						if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
							masterGrid1.deleteSelectedRow();
						}
					}
				}
			}else if(activeGridId == 'aba130ukrMasterGrid2'){
				var selRow = masterGrid2.getSelectedRecord();
				if(selRow) {
					if(selRow.phantom === true)	{
						masterGrid2.deleteSelectedRow();
					}else {
						var toDelete = directDetailStore.getRemovedRecords();
						if(toDelete.length > 0 || directDetailStore.getCount() > 0 || selRow.get('OPT_DIVI') == "5"){
							alert(Msg.sMB078);
							return false;
						}
						if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
							masterGrid2.deleteSelectedRow();
						}
					}
				}
			}else{
				var selRow = detailGrid.getSelectedRecord();
				if(selRow) {
					if(selRow.phantom === true)	{
						detailGrid.deleteSelectedRow();
					}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
						detailGrid.deleteSelectedRow();
					}
				}
			}
		}
	});
	Unilite.createValidator('validator01', {
		store: directMasterStore1,
		grid: masterGrid1,
		validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
			if(newValue == oldValue){
				return false;
			}
			var rv = true;
			switch(fieldName) {
				case "SEQ" :
					if(newValue <= 0 && !Ext.isEmpty(newValue))	{
						rv=Msg.sMB076;
					}
					if(isNaN(newValue)){
						rv = Msg.sMB074;
					}
					break;
			}
			return rv;
		}
	}); 
	
	Unilite.createValidator('validator02', {
		store: directMasterStore2,
		grid: masterGrid2,
		validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
			if(newValue == oldValue){
				return false;
			}			
			var rv = true;
			switch(fieldName) {
				case "SEQ" :
					if(newValue <= 0 && !Ext.isEmpty(newValue))	{
						rv=Msg.sMB076;
					}
					if(isNaN(newValue)){
						rv = Msg.sMB074;
					}
					break;
			}
			return rv;
		}
	}); 
		
	Unilite.createValidator('validator03', {
		store: directDetailStore,
		grid: detailGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
			if(newValue == oldValue){
				return false;
			}
			var rv = true;
			switch(fieldName) {
				case "CAL_TYPE" :
					record.set('ACCNT', '');
					record.set('ACCNT_NAME', '');
					record.set('DR_CR', '');
//					if (newValue == '1') {
//						record.getColumn("DR_CR").setConfig('allowBlank', false);
//					} else {
//						record.getColumn("DR_CR").setConfig('allowBlank', true);
//					}
					break;
			}
			return rv;
		}
	});	// validator

	function fnCheckReqiured(records) {					//DIVERT_DIVI 값에 따른 필수컬럼 체크 로직
		var isErr = false;
		Ext.each(records, function(record, index){
			var alertMessage = '';
			if(record.get('CAL_TYPE') == '1') {								//구분이 "계정이동"일 때,
				if  (Ext.isEmpty(record.get('DR_CR'))){							//원계정
					alert(' 계산유형이 SUM일 때, 계산구분은 필수 입력항목 입니다.');
					isErr = true;
				}

			}
		});
  		return isErr;					//필수값이 입력이 안 되었으면 위에서 메세지 출력 후 return true, 입력이 되었으면 return false
	}; 
};
</script>
