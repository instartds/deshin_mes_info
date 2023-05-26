<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="aiga240ukrv"  >
	<t:ExtComboStore comboType="AU" comboCode="A042" /> <!-- 자산구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A142" /> <!-- 변동구분 -->

	<t:ExtComboStore comboType="AU" comboCode="A140" includeMainCode="true"/> <!-- 결제및구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A143" includeMainCode="true"/> <!-- 결제및구분 -->
	
	<t:ExtComboStore comboType="AU" comboCode="A144" includeMainCode="true"/> <!-- 금액구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A145" includeMainCode="true"/> <!-- 금액구분 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	

<script type="text/javascript" >

var gsChargeCode  = Ext.isEmpty(${getChargeCode}) ? ['']: ${getChargeCode};   //ChargeCode 관련 전역변수

function appMain() {
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'aiga240ukrvService.selectList',
			update: 'aiga240ukrvService.updateDetail',
			create: 'aiga240ukrvService.insertDetail',
			destroy: 'aiga240ukrvService.deleteDetail',
			syncAll: 'aiga240ukrvService.saveAll'
		}
	});	
	
	/**
	 * 결제및구분 콤보컬럼 관련 스토어
	 */
	var setDiviStore = Ext.create('Ext.data.Store', {
        id : 'comboStoreSetDivi',
		fields : ['name', 'value'],
        data:[].concat(Ext.data.StoreManager.lookup('CBS_MAIN_AU_A140').getData().items).concat(Ext.data.StoreManager.lookup('CBS_MAIN_AU_A143').getData().items).concat({"value":"*","option":null,"text":"*","includeMainCode":true,"refCode1":"","refCode2":"","search":"*","refCode10":null,"refCode3":"","refCode4":"","refCode5":"","refCode6":null,"refCode7":null,"refCode8":null,"refCode9":null})
    });

    /**
	 * 금액구분 콤보컬럼 관련 스토어
	 */
	var amtDiviStore = Ext.create('Ext.data.Store', {
        id : 'comboStoreAmtDivi',
		fields : ['name', 'value'],
        data:[].concat(Ext.data.StoreManager.lookup('CBS_MAIN_AU_A144').getData().items).concat(Ext.data.StoreManager.lookup('CBS_MAIN_AU_A145').getData().items)
    });
	
	/**
	 *   Model 정의 
	 * @type 
	 */

	Unilite.defineModel('Aiga240ukrvModel', {
	    fields: [
	    	{name: 'COMP_CODE'			,text: 'COMP_CODE'			,type: 'string',allowBlank:false},
	    	{name: 'ASST_DIVI'			,text: '자산구분'				,type: 'string',comboType:'AU', comboCode:'A042',allowBlank:false},
	    	{name: 'ASST_ACCNT'			,text: '자산계정코드'			,type: 'string',allowBlank:false},
	    	{name: 'ASST_ACCNT_NAME'	,text: '자산계정명'				,type: 'string'},
	    	{name: 'ALTER_DIVI'			,text: '변동구분'				,type: 'string',comboType:'AU', comboCode:'A142',allowBlank:false},
	    	{name: 'SET_DIVI'			,text: '결제및구분'				,type: 'string',store: Ext.data.StoreManager.lookup('comboStoreSetDivi'),allowBlank:false},
	    	
	    	{name: 'DR_CR'				,text: '차대구분'				,type: 'string',comboType:'AU', comboCode:'A001',allowBlank:false},
	    	{name: 'AMT_DIVI'			,text: '금액구분'				,type: 'string',store: Ext.data.StoreManager.lookup('comboStoreAmtDivi'),allowBlank:false},
	    	
	    	{name: 'REVERSE_YN'			,text: '역분개여부'				,type: 'string',comboType:'AU', comboCode:'A020',allowBlank:false},
	    	{name: 'ACCNT'				,text: '전표계정코드'			,type: 'string',allowBlank:false},
	    	{name: 'ACCNT_NAME'			,text: '전표계정명'				,type: 'string'},
	    	{name: 'REMARK'				,text: '비고'					,type: 'string'},
	    	{name: 'INSERT_DB_USER'		,text: 'INSERT_DB_USER'		,type: 'string'},
	    	{name: 'INSERT_DB_TIME'		,text: 'INSERT_DB_TIME'		,type: 'string'},
	    	{name: 'UPDATE_DB_USER'		,text: 'UPDATE_DB_USER'		,type: 'string'},
	    	{name: 'UPDATE_DB_TIME'		,text: 'UPDATE_DB_TIME'		,type: 'string'}
		]
	});
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directDetailStore = Unilite.createStore('aiga240ukrvDetailStore', {
		model: 'Aiga240ukrvModel',
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
                var grid = Ext.getCmp('aiga240ukrvGrid');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		
		listeners: {
           	load: function(store, records, successful, eOpts) {
           		
           		
//        		var store = queryPlan.combo.store;
         /*  		Ext.each(records, function(record, i){
           			setDiviStore.clearFilter();
					setDiviStore.filterBy(function(item){
						if(record.get('ALTER_DIVI') == '10' || record.get('ALTER_DIVI') == '21'){
							return item.get('option') == 'A140';
						}else if(record.get('ALTER_DIVI') == '30'){
							return item.get('option') == 'A143';
						}else{
							return item.get('option') == '';
						}
					})
           			
           			
           			if(record.get('ALTER_DIVI') == '10' || record.get('ALTER_DIVI') == '21'){
           				setDiviStore.gridRoadStoreRecords({"MAIN_CODE" : "A140"}, setDiviStore);
           			}else if(record.get('ALTER_DIVI') == '30'){
           				setDiviStore.gridRoadStoreRecords({"MAIN_CODE" : "A143"}, setDiviStore);
           			}
           			
           		})*/
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
    			fieldLabel: '자산구분',
    			name:'ASST_DIVI', 
    			xtype: 'uniCombobox', 
    			comboType:'AU',
    			comboCode:'A042',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ASST_DIVI', newValue);
					}
				}
    		},
    		
    		Unilite.popup('ACCNT',{
				fieldLabel: '계정과목', 
				valueFieldName:'ASST_ACCNT',
			    textFieldName:'ASST_ACCNT_NAME',
			    listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('ASST_ACCNT', panelSearch.getValue('ASST_ACCNT'));
							panelResult.setValue('ASST_ACCNT_NAME', panelSearch.getValue('ASST_ACCNT_NAME'));
	                	},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('ASST_ACCNT', '');
						panelResult.setValue('ASST_ACCNT_NAME', '');
					},
                    applyExtParam:{
                        scope:this,
                        fn:function(popup){
                            var param = {
                                'ADD_QUERY' : "SPEC_DIVI IN ('K', 'K2')",
                                'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
                            }
                            popup.setExtParam(param);
                        }
                    }
				}
			}),
			{
    			fieldLabel: '변동구분',
    			name:'ALTER_DIVI', 
    			xtype: 'uniCombobox', 
    			comboType:'AU',
    			comboCode:'A142',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ALTER_DIVI', newValue);
					}
				}
    		}]	
		}]
	});
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 2},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel: '자산구분',
			name:'ASST_DIVI', 
			xtype: 'uniCombobox', 
			comboType:'AU',
			comboCode:'A042',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('ASST_DIVI', newValue);
				}
			}
		},
		
		Unilite.popup('ACCNT',{
			fieldLabel: '계정과목', 
			valueFieldName:'ASST_ACCNT',
		    textFieldName:'ASST_ACCNT_NAME',
		    listeners: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('ASST_ACCNT', panelResult.getValue('ASST_ACCNT'));
						panelSearch.setValue('ASST_ACCNT_NAME', panelResult.getValue('ASST_ACCNT_NAME'));
                	},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('ASST_ACCNT', '');
					panelSearch.setValue('ASST_ACCNT_NAME', '');
				},
                applyExtParam:{
                    scope:this,
                    fn:function(popup){
                        var param = {
                            'ADD_QUERY' : "SPEC_DIVI IN ('K', 'K2')",
                            'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
                        }
                        popup.setExtParam(param);
                    }
                }
			}
		}),
		{
			fieldLabel: '변동구분',
			name:'ALTER_DIVI', 
			xtype: 'uniCombobox', 
			comboType:'AU',
			comboCode:'A142',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('ALTER_DIVI', newValue);
				}
			}
		}]
    });		
    var detailGrid = Unilite.createGrid('aiga240ukrvGrid', {
		layout: 'fit',
		region: 'center',
		excelTitle: '감가상각비자동기표방법등록',
		uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: false,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,
			useRowContext: true,
			onLoadSelectFirst: true,
			copiedRow: true,
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
        	{ dataIndex: 'COMP_CODE'						,width:100, hidden:true},
        	{ dataIndex: 'ASST_DIVI'						,width:100,align:'center'},
        	{ dataIndex: 'ASST_ACCNT'						,width:100,
        		editor:Unilite.popup('ACCNT_G', {
					autoPopup: true,
					textFieldName:'ACCNT_NAME',
					DBtextFieldName: 'ACCNT_NAME',
					listeners:{
						scope:this,
						onSelected:function(records, type )	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
						   	grdRecord.set('ASST_ACCNT'		, records[0].ACCNT_CODE);
							grdRecord.set('ASST_ACCNT_NAME'	, records[0].ACCNT_NAME);
						},
						onClear:function(type)	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('ASST_ACCNT'		, '');
							grdRecord.set('ASST_ACCNT_NAME'	, '');
						},
						applyExtParam:{
							scope:this,
							fn:function(popup){
								var grdRecord = detailGrid.uniOpt.currentRecord;
								var param = {
									"ADD_QUERY" : grdRecord.get('ASST_DIVI') == '1' ? "SPEC_DIVI = 'K'" : "SPEC_DIVI = 'K2'",
									'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
								}
								popup.setExtParam(param);
							}
						}
					}
				})
        	},
        	{ dataIndex: 'ASST_ACCNT_NAME'				,width:200,
        		editor:Unilite.popup('ACCNT_G', {
					autoPopup: true,
					textFieldName:'ACCNT_NAME',
					DBtextFieldName: 'ACCNT_NAME',
					listeners:{
						scope:this,
						onSelected:function(records, type )	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
						   	grdRecord.set('ASST_ACCNT'		, records[0].ACCNT_CODE);
							grdRecord.set('ASST_ACCNT_NAME'	, records[0].ACCNT_NAME);
						},
						onClear:function(type)	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('ASST_ACCNT'		, '');
							grdRecord.set('ASST_ACCNT_NAME'	, '');
						},
						applyExtParam:{
							scope:this,
							fn:function(popup){
								var grdRecord = detailGrid.uniOpt.currentRecord;
								var param = {
									"ADD_QUERY" : grdRecord.get('ASST_DIVI') == '1' ? "SPEC_DIVI = 'K'" : "SPEC_DIVI = 'K2'",
									'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
								}
								popup.setExtParam(param);
							}
						}
					}
				})
        	},
        	{ dataIndex: 'ALTER_DIVI'						,width:150},
        	{ dataIndex: 'SET_DIVI'						,width:150,
        		listeners:{
	        		render:function(elm)	{
	        			var tGrid = elm.getView().ownerGrid;
	        			elm.editor.on('beforequery',function(queryPlan, eOpts)	{
	        				var grid = tGrid;
	        				var record = grid.uniOpt.currentRecord;
							var store = queryPlan.combo.store;
							store.clearFilter();
							store.filterBy(function(item){
								if(record.get('ALTER_DIVI') == '10' || record.get('ALTER_DIVI') == '21'){
									return item.get('value').substring(0, 4) == 'A140';
								}else if(record.get('ALTER_DIVI') == '30'){
									return item.get('value').substring(0, 4) == 'A143';
								}else{
									return item.get('value') == '*';
								}
							})
	        			});
	        			elm.editor.on('collapse',function(combo,  eOpts )	{
							var store = combo.store;
							store.clearFilter();
	        			});
	        		}
	        	}
        	},
        	{ dataIndex: 'DR_CR'							,width:100,align:'center'},
        	{ dataIndex: 'AMT_DIVI'						,width:150,
        		listeners:{
	        		render:function(elm)	{
	        			var tGrid = elm.getView().ownerGrid;
	        			elm.editor.on('beforequery',function(queryPlan, eOpts)	{
	        				var grid = tGrid;
	        				var record = grid.uniOpt.currentRecord;
							var store = queryPlan.combo.store;
							store.clearFilter();
							store.filterBy(function(item){
								if(record.get('ALTER_DIVI') == '10' || record.get('ALTER_DIVI') == '21' || record.get('ALTER_DIVI') == '22'){
									return item.get('value').substring(0, 4) == 'A144';
								}else if(record.get('ALTER_DIVI') == '30' || record.get('ALTER_DIVI') == '40'){
									return item.get('value').substring(0, 4) == 'A145';
								}else{
									return item.get('value') == '';
								}
							})
	        			});
	        			elm.editor.on('collapse',function(combo,  eOpts )	{
							var store = combo.store;
							store.clearFilter();
	        			});
	        		}
	        	}
        	},
        	{ dataIndex: 'REVERSE_YN'						,width:100,align:'center'},
        	{ dataIndex: 'ACCNT'							,width:100,
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
//									'ADD_QUERY' : "SPEC_DIVI = 'K' AND SLIP_SW = 'Y' AND GROUP_YN = 'N'",
									'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
								}
								popup.setExtParam(param);
							}
						}
					}
				})
        	},
        	{ dataIndex: 'ACCNT_NAME'						,width:200,
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
//									'ADD_QUERY' : "SPEC_DIVI = 'K' AND SLIP_SW = 'Y' AND GROUP_YN = 'N'",
									'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
								}
								popup.setExtParam(param);
							}
						}
					}
				})
        	},
        	{ dataIndex: 'REMARK'							,width:250},
        	{ dataIndex: 'INSERT_DB_USER'					,width:100,hidden:true},
        	{ dataIndex: 'INSERT_DB_TIME'					,width:100,hidden:true},
        	{ dataIndex: 'UPDATE_DB_USER'					,width:100,hidden:true},
        	{ dataIndex: 'UPDATE_DB_TIME'					,width:100,hidden:true}
        ],
        listeners: {
        	afterrender:function()	{
        		
			},
			beforeedit : function( editor, e, eOpts ) {
				if(UniUtils.indexOf(e.field, ['ASST_DIVI', 'ASST_ACCNT', 'ASST_ACCNT_NAME', 'DR_CR', 'AMT_DIVI', 'REVERSE_YN', 'ACCNT', 'ACCNT_NAME'])){
					if(e.record.phantom == false){
						return false;
					}else{
						return true;
					}
				}else if(UniUtils.indexOf(e.field, ['ALTER_DIVI'])){
					if(e.record.phantom == false || e.record.data.ASST_DIVI == '2'){
						return false;
					}else{
						return true;
					}
				}else if(UniUtils.indexOf(e.field, ['SET_DIVI'])){
					if(e.record.phantom == false || e.record.data.ALTER_DIVI == '22' || e.record.data.ALTER_DIVI == '40'){
						return false;
					}else{
						return true;
					}
				}else if(UniUtils.indexOf(e.field, ['REMARK'])){
					return true;
				}else{
					return false;
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
		id  : 'aiga240ukrvApp',
		fnInitBinding: function(){
			UniAppManager.setToolbarButtons(['reset','newData'], true);
			this.setDefault();
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('ASST_DIVI');
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
				case "ASST_DIVI":
					if(newValue == '2'){
						record.set('ALTER_DIVI','21');
					}
				break;
				
				case "ALTER_DIVI":
					if(newValue == '22' || newValue == '40'){
						record.set('SET_DIVI','*');
					}else{
						record.set('SET_DIVI','');
					}
					
					record.set('AMT_DIVI','');
					
				break;
				
			}
			return rv;
		}
	});	
			
};

</script>