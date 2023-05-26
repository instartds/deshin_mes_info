<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="aiga210ukrv"  >
	<t:ExtComboStore comboType="AU" comboCode="A037" /> <!-- 구분 -->
	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	

<script type="text/javascript" >

var gsChargeCode  = Ext.isEmpty(${getChargeCode}) ? ['']: ${getChargeCode};   //ChargeCode 관련 전역변수

function appMain() {
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'aiga210ukrvService.selectList',
			update: 'aiga210ukrvService.updateDetail',
			create: 'aiga210ukrvService.insertDetail',
			destroy: 'aiga210ukrvService.deleteDetail',
			syncAll: 'aiga210ukrvService.saveAll'
		}
	});	
	
	
	/**
	 *   Model 정의 
	 * @type 
	 */

	Unilite.defineModel('Aiga210ukrvModel', {
	    fields: [
	    	{name: 'DEPT_DIVI'				,text: '구분'					,type: 'string', comboType:'AU', comboCode:'A037', allowBlank:false},
	    	{name: 'ACCNT'					,text: '계정코드'				,type: 'string', allowBlank:false},
	    	{name: 'ACCNT_NAME'				,text: '계정과목'				,type: 'string'},
	    	{name: 'DEP_ACCNT'				,text: '상각비계정'				,type: 'string', allowBlank:false},
	    	{name: 'DEP_ACCNT_NAME'			,text: '상각비계정과목'			,type: 'string'},
	    	{name: 'APP_ACCNT'				,text: '누계액계정'				,type: 'string', allowBlank:false},
	    	{name: 'APP_ACCNT_NAME'			,text: '누계액계정과목'			,type: 'string'},
	    	{name: 'COMP_CODE'				,text: 'COMP_CODE'			,type: 'string', allowBlank:false},
	    	{name: 'INSERT_DB_USER'			,text: 'INSERT_DB_USER'		,type: 'string'},
	    	{name: 'INSERT_DB_TIME'			,text: 'INSERT_DB_TIME'		,type: 'string'},
	    	{name: 'UPDATE_DB_USER'			,text: 'UPDATE_DB_USER'		,type: 'string'},
	    	{name: 'UPDATE_DB_TIME'			,text: 'UPDATE_DB_TIME'		,type: 'string'}
		]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directDetailStore = Unilite.createStore('aiga210ukrvDetailStore', {
		model: 'Aiga210ukrvModel',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결 
			editable: true,			// 수정 모드 사용 
			deletable: true,			// 삭제 가능 여부 
			allDeletable:true,
			useNavi : false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: directProxy,
		saveStore: function() {				
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			var toCreate = this.getNewRecords();
       		var toUpdate = this.getUpdatedRecords();        		
       		var toDelete = this.getRemovedRecords();
       		var list = [].concat(toUpdate, toCreate);
			console.log("list:", list);
			var paramMaster= panelResult.getValues();	//syncAll 수정
			
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						var master = batch.operations[0].getResultSet();
						panelSearch.getForm().wasDirty = false;
						panelSearch.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);		
//						directDetailStore.loadStoreRecords();
						
						if (directDetailStore.count() == 0) {   
							UniAppManager.app.onResetButtonDown();
						}else{
							UniAppManager.app.onQueryButtonDown();
						}
					 } 
				};
				this.syncAllDirect(config);
			} else {
                var grid = Ext.getCmp('aiga210ukrvGrid');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		
		listeners: {
           	load: function(store, records, successful, eOpts) {
        
           	},
           	add: function(store, records, index, eOpts) {
           	},
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {
           	},
           	remove: function(store, record, index, isMove, eOpts) {
           	}
		},
		loadStoreRecords: function(){
			var param= Ext.getCmp('resultForm').getValues();
			console.log( param );
			this.load({
				params: param
			});
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
	        layout: {type: 'uniTable', columns: 1},
	        defaultType: 'uniTextfield',
			items: [{
    			fieldLabel: '구분',
    			name:'DEPT_DIVI', 
    			xtype: 'uniCombobox', 
    			comboType:'AU',
    			comboCode:'A037',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DEPT_DIVI', newValue);
					}
				}
    		}]	
		}]
	});
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel: '구분',
			name:'DEPT_DIVI', 
			xtype: 'uniCombobox', 
			comboType:'AU',
			comboCode:'A037',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DEPT_DIVI', newValue);
				}
			}
		}]
    });		
    var detailGrid = Unilite.createGrid('aiga210ukrvGrid', {
		layout: 'fit',
		region: 'center',
		excelTitle: '감가상각비자동기표방법등록',
		uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: false,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: true,
			useRowContext: true,
			onLoadSelectFirst: true,
    		state: {
				useState: true,			
				useStateList: true		
			}
        },
		features: [{
			id: 'detailGridSubTotal', 
			ftype: 'uniGroupingsummary', 
			showSummaryRow: false
		},{
			id: 'detailGridTotal', 
			ftype: 'uniSummary', 
			showSummaryRow: false
		}],
		store: directDetailStore,
		columns: [        
        	{ dataIndex: 'DEPT_DIVI'				,width:100}, 
        	{ dataIndex: 'ACCNT'					,width:100,
				editor:Unilite.popup('ACCNT_G', {
					autoPopup: true,
					textFieldName:'ACCNT_NAME',
					DBtextFieldName: 'ACCNT_NAME',
					listeners:{
						scope:this,
						onSelected:function(records, type )	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
						   	grdRecord.set('ACCNT'		, records[0].ACCNT_CODE);
							grdRecord.set('ACCNT_NAME'	, records[0].ACCNT_NAME);
						},
						onClear:function(type)	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('ACCNT'		, '');
							grdRecord.set('ACCNT_NAME'	, '');
						},
						applyExtParam:{
							scope:this,
							fn:function(popup){
								var param = {
									'ADD_QUERY' : "SPEC_DIVI = 'K' AND SLIP_SW = 'Y' AND GROUP_YN = 'N'",
									'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
								}
								popup.setExtParam(param);
							}
						}
					}
				})
        	}, 
        	{ dataIndex: 'ACCNT_NAME'				,width:200,
        		editor:Unilite.popup('ACCNT_G', {
					autoPopup: true,
					textFieldName:'ACCNT_NAME',
					DBtextFieldName: 'ACCNT_NAME',
					listeners:{
						scope:this,
						onSelected:function(records, type )	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
						   	grdRecord.set('ACCNT'		, records[0].ACCNT_CODE);
							grdRecord.set('ACCNT_NAME'	, records[0].ACCNT_NAME);
						},
						onClear:function(type)	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('ACCNT'		, '');
							grdRecord.set('ACCNT_NAME'	, '');
						},
						applyExtParam:{
							scope:this,
							fn:function(popup){
								var param = {
									'ADD_QUERY' : "SPEC_DIVI = 'K' AND SLIP_SW = 'Y' AND GROUP_YN = 'N'",
									'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
								}
								popup.setExtParam(param);
							}
						}
					}
				})
        	}, 
        	{ dataIndex: 'DEP_ACCNT'				,width:100,
        		editor:Unilite.popup('ACCNT_G', {
					autoPopup: true,
					textFieldName:'ACCNT_NAME',
					DBtextFieldName: 'ACCNT_NAME',
					listeners:{
						scope:this,
						onSelected:function(records, type )	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
						   	grdRecord.set('DEP_ACCNT'		, records[0].ACCNT_CODE);
							grdRecord.set('DEP_ACCNT_NAME'	, records[0].ACCNT_NAME);
						},
						onClear:function(type)	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('DEP_ACCNT'		, '');
							grdRecord.set('DEP_ACCNT_NAME'	, '');
						},
						applyExtParam:{
							scope:this,
							fn:function(popup){
								var param = {
									'ADD_QUERY' : "SLIP_SW = 'Y' AND GROUP_YN = 'N'",
									'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
								}
								popup.setExtParam(param);
							}
						}
					}
				})
        	}, 
        	{ dataIndex: 'DEP_ACCNT_NAME'			,width:200,
        		editor:Unilite.popup('ACCNT_G', {
					autoPopup: true,
					textFieldName:'ACCNT_NAME',
					DBtextFieldName: 'ACCNT_NAME',
					listeners:{
						scope:this,
						onSelected:function(records, type )	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
						   	grdRecord.set('DEP_ACCNT'		, records[0].ACCNT_CODE);
							grdRecord.set('DEP_ACCNT_NAME'	, records[0].ACCNT_NAME);
						},
						onClear:function(type)	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('DEP_ACCNT'		, '');
							grdRecord.set('DEP_ACCNT_NAME'	, '');
						},
						applyExtParam:{
							scope:this,
							fn:function(popup){
								var param = {
									'ADD_QUERY' : "SLIP_SW = 'Y' AND GROUP_YN = 'N'",
									'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
								}
								popup.setExtParam(param);
							}
						}
					}
				})
        	}, 
        	{ dataIndex: 'APP_ACCNT'				,width:100,
        		editor:Unilite.popup('ACCNT_G', {
					autoPopup: true,
					textFieldName:'ACCNT_NAME',
					DBtextFieldName: 'ACCNT_NAME',
					listeners:{
						scope:this,
						onSelected:function(records, type )	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
						   	grdRecord.set('APP_ACCNT'		, records[0].ACCNT_CODE);
							grdRecord.set('APP_ACCNT_NAME'	, records[0].ACCNT_NAME);
						},
						onClear:function(type)	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('APP_ACCNT'		, '');
							grdRecord.set('APP_ACCNT_NAME'	, '');
						},
						applyExtParam:{
							scope:this,
							fn:function(popup){
								var param = {
									'ADD_QUERY' : "SLIP_SW = 'Y' AND GROUP_YN = 'N'",
									'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
								}
								popup.setExtParam(param);
							}
						}
					}
				})
        	}, 
        	{ dataIndex: 'APP_ACCNT_NAME'			,width:200,
        		editor:Unilite.popup('ACCNT_G', {
					autoPopup: true,
					textFieldName:'ACCNT_NAME',
					DBtextFieldName: 'ACCNT_NAME',
					listeners:{
						scope:this,
						onSelected:function(records, type )	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
						   	grdRecord.set('APP_ACCNT'		, records[0].ACCNT_CODE);
							grdRecord.set('APP_ACCNT_NAME'	, records[0].ACCNT_NAME);
						},
						onClear:function(type)	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('APP_ACCNT'		, '');
							grdRecord.set('APP_ACCNT_NAME'	, '');
						},
						applyExtParam:{
							scope:this,
							fn:function(popup){
								var param = {
									'ADD_QUERY' : "SLIP_SW = 'Y' AND GROUP_YN = 'N'",
									'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
								}
								popup.setExtParam(param);
							}
						}
					}
				})
        	}, 
        	{ dataIndex: 'COMP_CODE'				,width:100,hidden:true}, 
        	{ dataIndex: 'INSERT_DB_USER'			,width:100,hidden:true}, 
        	{ dataIndex: 'INSERT_DB_TIME'			,width:100,hidden:true}, 
        	{ dataIndex: 'UPDATE_DB_USER'			,width:100,hidden:true}, 
        	{ dataIndex: 'UPDATE_DB_TIME'			,width:100,hidden:true}
        ],
        listeners: {
        	afterrender:function()	{
        		
			},
			beforeedit : function( editor, e, eOpts ) {
				if(e.record.phantom == true){
					if(UniUtils.indexOf(e.field, ['COMP_CODE','INSERT_DB_USER','INSERT_DB_TIME','UPDATE_DB_USER','UPDATE_DB_TIME'])){
						return false;
					}else{
						return true;	
					}
				}else{
					if(UniUtils.indexOf(e.field, ['DEPT_DIVI','ACCNT','ACCNT_NAME','COMP_CODE','INSERT_DB_USER','INSERT_DB_TIME','UPDATE_DB_USER','UPDATE_DB_TIME'])){
						return false;
					}else{
						return true;	
					}	
				}
			}
		}
    });   
    Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				panelResult, detailGrid
			]	
		},
			panelSearch
		],
		id  : 'aiga210ukrvApp',
		fnInitBinding: function(){
			UniAppManager.setToolbarButtons(['reset','newData'], true);
			this.setDefault();
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('DEPT_DIVI');
		},
		onQueryButtonDown: function() {      
			if(!panelResult.getInvalidMessage()) return;	//필수체크
			
			directDetailStore.loadStoreRecords();		
		},
		onNewDataButtonDown: function()	{
			if(!panelResult.getInvalidMessage()) return;	//필수체크
		
			 var compCode = UserInfo.compCode;
        	 
        	 var r = {
			
				COMP_CODE: compCode
	        };
			detailGrid.createRow(r);
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			detailGrid.reset();
			directDetailStore.clearData();
			UniAppManager.setToolbarButtons('save', false);
		},
		
		onSaveDataButtonDown: function(config) {				
			directDetailStore.saveStore();
		},
		
		onDeleteDataButtonDown: function() {
			var selRow = detailGrid.getSelectedRecord();
			
			if(selRow.phantom === true)	{
				
				
				detailGrid.deleteSelectedRow();
				
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				detailGrid.deleteSelectedRow();

			}
		},
		onDeleteAllButtonDown: function() {			
			var records = directDetailStore.data.items;
			var isNewData = false;
			Ext.each(records, function(record,i) {
				if(record.phantom){						//신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				}else{									//신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					if(confirm('전체삭제 하시겠습니까?')) {
						var deletable = true;
						if(deletable){		
							detailGrid.reset();			
							UniAppManager.app.onSaveDataButtonDown();	
						}
						isNewData = false;							
					}
					return false;
				}
			});
			if(isNewData){								//신규 레코드들만 있을시 그리드 리셋		   
				detailGrid.reset();
				UniAppManager.app.onResetButtonDown();	//삭제후 RESET..
			}
		},
		setDefault: function(){
		}
	});
	
	Unilite.createValidator('validator01', {
		store: directDetailStore,
		grid: detailGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
			
			}
				return rv;
						}
			});	
			
};

</script>