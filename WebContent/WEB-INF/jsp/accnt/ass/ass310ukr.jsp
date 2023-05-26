<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ass310ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->        
	<t:ExtComboStore comboType="AU" comboCode="A004" />
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
</t:appConfig>
<script type="text/javascript" >

function appMain() {     
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Ass310ukrModel', {
	    fields: [  	  
	    	{name: 'ASST'				, text: '자산코드' 		,type: 'string'},
		    {name: 'SEQ'				, text: '번호'			,type: 'string'},
		    {name: 'ASST_NAME'			, text: '자산상세명' 		,type: 'string'},
		    {name: 'SPEC'   			, text: '상세규격' 		,type: 'string'},
		    {name: 'DIV_CODE'			, text: '사업장' 			,type: 'string', comboType:'BOR120'},
		    {name: 'DEPT_CODE'			, text: '부서코드' 		,type: 'string'},
		    {name: 'DEPT_NAME'			, text: '부서명' 			,type: 'string'},
		    {name: 'PJT_CODE'			, text: '프로젝트코드' 	,type: 'string'},
		    {name: 'PJT_NAME'			, text: '프로젝트명' 		,type: 'string'},
		    {name: 'FOR_ACQ_AMT_I'		, text: '외화취득가액' 	,type: 'uniFC'},
		    {name: 'ACQ_AMT_I'			, text: '취득가액' 		,type: 'uniPrice'},
		    {name: 'ACQ_Q'				, text: '취득수량' 		,type: 'uniQty'},
		    {name: 'PERSON_NUMB'		, text: '사번' 			,type: 'string'},
		    {name: 'PERSON_NAME'		, text: '성명' 			,type: 'string'},
		    {name: 'SERIES_NO'			, text: '일련번호' 		,type: 'string'},
		    {name: 'REMARK'				, text: '비고' 			,type: 'string'},
		    {name: 'USE_YN'				, text: '사용유무' 		,type: 'string', comboType:'AU' ,comboCode:'A004'},
		    {name: 'COMP_CODE'			, text: 'COMP_CODE' 	,type: 'string'}
		]
	});
	

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'ass310ukrService.selectList',
			update: 'ass310ukrService.updateDetail',
			create: 'ass310ukrService.insertDetail',
			destroy: 'ass310ukrService.deleteDetail',
			syncAll: 'ass310ukrService.saveAll'
		}
	});	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var masterStore = Unilite.createStore('ass310ukrMasterStore',{
		model: 'Ass310ukrModel',
		uniOpt: {
            isMaster: 	true,			// 상위 버튼 연결 
            editable: 	true,			// 수정 모드 사용 
            deletable:	true,			// 삭제 가능 여부 
	        useNavi : 	false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy:directProxy,
        loadStoreRecords: function() {
        	var chkValid1 = panelSearch.isValid() ;
			var chkValid2 = panelResult.isValid();
        	if(chkValid1 && chkValid2)	{
				var param= Ext.getCmp('searchForm').getValues();			
				console.log( param );
				this.load({
					params : param
				});
        	}
		},
		saveStore : function()	{	
			var inValidRecs = this.getInvalidRecords();
        	var rv = true;
			if(inValidRecs.length == 0 )	{
				
				this.syncAllDirect();
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
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
			items: [
				Unilite.popup('ASSET',{
					fieldLabel: '자산코드',
					valueFieldName:'ASST',
					textFieldName:'ASST_NAME',
					validateBlank:false,
					allowBlank:false,
					listeners:{
						onSelected:function(records, type){
							if(UniAppManager.app._needSave())	{
								alert("저장할 데이타가 있습니다. 저장하시겠습니까?");
								UniAppManager.app.onSaveButtonDown();
								return ;
							}else{
								masterStore.loadData({});
							}
							panelSearch.setValue("ACCNT", records[0].ACCNT);
							panelSearch.setValue("ACCNT_NAME", records[0].ACCNT_NAME);
							panelSearch.setValue("ACQ_DATE", records[0].ACQ_DATE);
							panelSearch.setValue("DRB_YEAR", records[0].DRB_YEAR);
							panelSearch.setValue("DRB_RATE", records[0].DEPRECTION); 
							panelSearch.setValue("ACQ_AMT_I", records[0].ACQ_AMT_I);
							
							panelSearch.setValue("SPEC", records[0].SPEC);
							panelSearch.setValue("DIV_CODE", records[0].DIV_CODE);
							panelSearch.setValue("DEPT_CODE", records[0].DEPT_CODE);
							panelSearch.setValue("DEPT_NAME", records[0].DEPT_NAME);
							panelSearch.setValue("PJT_CODE", records[0].PJT_CODE);
							panelSearch.setValue("PJT_NAME", records[0].PJT_NAME);
							
							panelResult.setValue("ASST", records[0].ASSET_CODE);
							panelResult.setValue("ASST_NAME", records[0].ASSET_NAME);
							panelResult.setValue("ACCNT", records[0].ACCNT);
							panelResult.setValue("ACCNT_NAME", records[0].ACCNT_NAME);
							panelResult.setValue("ACQ_DATE", records[0].ACQ_DATE);
							panelResult.setValue("DRB_YEAR", records[0].DRB_YEAR);
							panelResult.setValue("DRB_RATE", records[0].DEPRECTION); 
							panelResult.setValue("ACQ_AMT_I", records[0].ACQ_AMT_I);
							
							panelResult.setValue("SPEC", records[0].SPEC);
							panelResult.setValue("DIV_CODE", records[0].DIV_CODE);
							panelResult.setValue("DEPT_CODE", records[0].DEPT_CODE);
							panelResult.setValue("DEPT_NAME", records[0].DEPT_NAME);
							panelResult.setValue("PJT_CODE", records[0].PJT_CODE);
							panelResult.setValue("PJT_NAME", records[0].PJT_NAME);
							masterStore.loadData({});
							UniAppManager.setToolbarButtons('newData',true);
						},
						onClear:function()	{
							UniAppManager.app.onResetButtonDown();
						}
					}
			}),{
		 	 	xtype: 'container',
	   			defaultType: 'uniTextfield',
				layout: {type: 'hbox', align:'stretch'},
				width:325,
				margin:0,
				items:[{
					fieldLabel:'계정코드', name: 'ACCNT', width:162,
					readOnly: true,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('ACCNT', newValue);
						}
					}
				}, {
					name: 'ACCNT_NAME', width:163,
					readOnly: true,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('ACCNT_NAME', newValue);
						}
					}
				}] 
			},{
			 	fieldLabel: '취득일',
			 	xtype: 'uniTextfield',
			 	name: 'ACQ_DATE',
				readOnly: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ACQ_DATE', newValue);
					}
				}
			},{
		 	 	xtype: 'container',
	   			defaultType: 'uniTextfield',
				layout: {type: 'hbox', align:'stretch'},
				width:325,
				margin:0,
				items:[{
					fieldLabel:'내용년수', name: 'DRB_YEAR', width:218,
					readOnly: true,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('DRB_YEAR', newValue);
						}
					}
				}, {
					name: 'DRB_RATE', width:107,
					readOnly: true,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('DRB_RATE', newValue);
						}
					}
				}] 
			},{
				fieldLabel: '취득가액',
				name:'ACQ_AMT_I',	
				xtype: 'uniTextfield',
				readOnly: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ACQ_AMT_I', newValue);
					}
				}
			},{
				fieldLabel: '규격',
				name:'SPEC',	
				xtype: 'uniTextfield',
				hidden:true			
			},{
				fieldLabel: '사업장',
				name:'DIV_CODE',	
				xtype: 'uniTextfield',
				hidden:true
			},{
				fieldLabel: '부서',
				name:'DEPT_CODE',	
				xtype: 'uniTextfield',
				hidden:true
			},{
				fieldLabel: '부서명',
				name:'DEPT_NAME',	
				xtype: 'uniTextfield',
				hidden:true
			},{
				fieldLabel: '프로젝트',
				name:'PJT_CODE',	
				xtype: 'uniTextfield',
				hidden:true
			},{
				fieldLabel: '프로젝트명',
				name:'PJT_NAME',	
				xtype: 'uniTextfield',
				hidden:true
			}]		
		}]
	});	//end panelSearch  
	
	var panelResult = Unilite.createSearchForm('panelResultForm', {		
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [
			Unilite.popup('ASSET',{
				fieldLabel: '자산코드',
				valueFieldName:'ASST',
				textFieldName:'ASST_NAME',
				validateBlank:false,
				allowBlank:false,
				listeners:{
					onSelected:function(records, type){
						if(UniAppManager.app._needSave())	{
							alert("저장할 데이타가 있습니다. 저장하시겠습니까?");
							UniAppManager.app.onSaveDataButtonDown();
							return false;
						}else{
							masterStore.loadData({});
						}
						panelResult.setValue("ACCNT", records[0].ACCNT);
						panelResult.setValue("ACCNT_NAME", records[0].ACCNT_NAME);
						panelResult.setValue("ACQ_DATE", records[0].ACQ_DATE);
						panelResult.setValue("DRB_YEAR", records[0].DRB_YEAR);
						panelResult.setValue("DRB_RATE", records[0].DEPRECTION); 
						panelResult.setValue("ACQ_AMT_I", records[0].ACQ_AMT_I);
						panelResult.setValue("SPEC", records[0].SPEC);
						panelResult.setValue("DIV_CODE", records[0].DIV_CODE);
						panelResult.setValue("DEPT_CODE", records[0].DEPT_CODE);
						panelResult.setValue("DEPT_NAME", records[0].DEPT_NAME);
						panelResult.setValue("PJT_CODE", records[0].PJT_CODE);
						panelResult.setValue("PJT_NAME", records[0].PJT_NAME);
						
						panelSearch.setValue("ASST", records[0].ASSET_CODE);
						panelSearch.setValue("ASST_NAME", records[0].ASSET_NAME);
						panelSearch.setValue("ACCNT", records[0].ACCNT);
						panelSearch.setValue("ACCNT_NAME", records[0].ACCNT_NAME);
						panelSearch.setValue("ACQ_DATE", records[0].ACQ_DATE);
						panelSearch.setValue("DRB_YEAR", records[0].DRB_YEAR);
						panelSearch.setValue("DRB_RATE", records[0].DEPRECTION); 
						panelSearch.setValue("ACQ_AMT_I", records[0].ACQ_AMT_I);
						panelSearch.setValue("SPEC", records[0].SPEC);
						panelSearch.setValue("DIV_CODE", records[0].DIV_CODE);
						panelSearch.setValue("DEPT_CODE", records[0].DEPT_CODE);
						panelSearch.setValue("DEPT_NAME", records[0].DEPT_NAME);
						panelSearch.setValue("PJT_CODE", records[0].PJT_CODE);
						panelSearch.setValue("PJT_NAME", records[0].PJT_NAME);
						masterStore.loadData({});
						UniAppManager.setToolbarButtons('newData',true);
					},
					onClear:function()	{
						UniAppManager.app.onResetButtonDown();
					}
				}
		}),{
	 	 	xtype: 'container',
   			defaultType: 'uniTextfield',
			layout: {type: 'hbox', align:'stretch'},
			width:325,
			margin:0,
			items:[{
				fieldLabel:'계정코드', name: 'ACCNT', width:162,
				readOnly: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('ACCNT', newValue);
					}
				}
			}, {
				name: 'ACCNT_NAME', width:163,
				readOnly: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('ACCNT_NAME', newValue);
					}
				}
			}] 
		},{
		 	fieldLabel: '취득일', 
		 	xtype: 'uniTextfield',
		 	name: 'ACQ_DATE',
			readOnly: true,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('ACQ_DATE', newValue);
				}
			}
		},{
	 	 	xtype: 'container',
   			defaultType: 'uniTextfield',
			layout: {type: 'hbox', align:'stretch'},
			width:325,
			margin:0,
			items:[{
				fieldLabel:'내용년수', name: 'DRB_YEAR', width:218,
				readOnly: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('DRB_YEAR', newValue);
					}
				}
			}, {
				name: 'DRB_RATE', width:107, 
				readOnly: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('DRB_RATE', newValue);
					}
				}
			}] 
		},{
			fieldLabel: '취득가액',
			name:'ACQ_AMT_I',	
			xtype: 'uniTextfield',
			readOnly: true,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('ACQ_AMT_I', newValue);
				}
			}
		},{
			fieldLabel: '규격',
			name:'SPEC',	
			xtype: 'uniTextfield',
			hidden:true			
		},{
			fieldLabel: '사업장',
			name:'DIV_CODE',	
			xtype: 'uniTextfield',
			hidden:true
		},{
			fieldLabel: '부서',
			name:'DEPT_CODE',	
			xtype: 'uniTextfield',
			hidden:true
		},{
			fieldLabel: '부서명',
			name:'DEPT_NAME',	
			xtype: 'uniTextfield',
			hidden:true
		},{
			fieldLabel: '프로젝트',
			name:'PJT_CODE',	
			xtype: 'uniTextfield',
			hidden:true
		},{
			fieldLabel: '프로젝트명',
			name:'PJT_NAME',	
			xtype: 'uniTextfield',
			hidden:true
		}]
	});
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('ass310ukrGrid1', {
    	layout : 'fit',
        region : 'center',
        store : masterStore, 
        uniOpt:{	expandLastColumn: true,
        			useRowNumberer: true,
                    useMultipleSorting: true
        },
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    		},{
    		id: 'masterGridTotal', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: false
    	}],
        columns: [        
        	{dataIndex: 'ASST'				, width: 100   , hidden: true}, 				
			{dataIndex: 'SEQ'				, width: 40 }, 				
			{dataIndex: 'ASST_NAME'			, width: 200}, 				
			{dataIndex: 'SPEC'   			, width: 146}, 				
			{dataIndex: 'DIV_CODE'			, width: 100}, 				
			{dataIndex: 'DEPT_CODE'			, width: 100, 
			  editor:Unilite.popup('DEPT_G', {
			  	textFieldName:'DEPT_CODE',
				DBtextFieldName: 'TREE_CODE',
				listeners:{
					onSelected:function(records, type)	{
						var curRecord = masterGrid.uniOpt.currentRecord;
						curRecord.set("DEPT_CODE", records[0].TREE_CODE);
						curRecord.set("DEPT_NAME", records[0].TREE_NAME);
					},
					onClear:function(type)	{
						var curRecord = masterGrid.uniOpt.currentRecord;
						curRecord.set("DEPT_NAME", "");
						curRecord.set("DEPT_CODE", "");
					}
				}
			  })}, 				
			{dataIndex: 'DEPT_NAME'			, width: 100, 
			  editor:Unilite.popup('DEPT_G', {
			  	textFieldName:'DEPT_NAME',
				DBtextFieldName: 'TREE_NAME',
				listeners:{
					onSelected:function(records, type)	{
						var curRecord = masterGrid.uniOpt.currentRecord;
						curRecord.set("DEPT_CODE", records[0].TREE_CODE);
						curRecord.set("DEPT_NAME", records[0].TREE_NAME);
					},
					onClear:function(type)	{
						var curRecord = masterGrid.uniOpt.currentRecord;
						curRecord.set("DEPT_NAME", "");
						curRecord.set("DEPT_CODE", "");
					}
				}
			  })}, 				
			{dataIndex: 'PJT_CODE'			, width: 100, 
			  editor:Unilite.popup('AC_PROJECT_G', {
			  	textFieldName:'PJT_CODE',
				DBtextFieldName: 'AC_PROJECT_CODE',
				listeners:{
					onSelected:function(records, type)	{
						var curRecord = masterGrid.uniOpt.currentRecord;
						curRecord.set("PJT_CODE", records[0].AC_PROJECT_CODE);
						curRecord.set("PJT_NAME", records[0].AC_PROJECT_NAME);
					},
					onClear:function(type)	{
						var curRecord = masterGrid.uniOpt.currentRecord;
						curRecord.set("PJT_NAME", "");
						curRecord.set("PJT_CODE", "");
					}
				}
			  })}, 				
			{dataIndex: 'PJT_NAME'			, width: 106, 
			  editor:Unilite.popup('AC_PROJECT_G', {
			  	textFieldName:'PJT_NAME',
				DBtextFieldName: 'AC_PROJECT_NAME',
				listeners:{
					onSelected:function(records, type)	{
						var curRecord = masterGrid.uniOpt.currentRecord;
						curRecord.set("PJT_CODE", records[0].AC_PROJECT_CODE);
						curRecord.set("PJT_CODE", records[0].AC_PROJECT_NAME);
					},
					onClear:function(type)	{
						var curRecord = masterGrid.uniOpt.currentRecord;
						curRecord.set("PJT_NAME", "");
						curRecord.set("PJT_CODE", "");
					}
				}
			  })},		
			{dataIndex:	'FOR_ACQ_AMT_I'		, width: 100},
			{dataIndex: 'ACQ_AMT_I'			, width: 100}, 				
			{dataIndex: 'ACQ_Q'				, width: 66 },		
			{dataIndex:	'PERSON_NUMB'		, width: 80 , 
			  editor:Unilite.popup('Employee_ACCNT_G', {
			  	textFieldName:'PERSON_NUMB',
				DBtextFieldName: 'PERSON_NUMB',
				listeners:{
					onSelected:function(records, type)	{
						var curRecord = masterGrid.uniOpt.currentRecord;
						curRecord.set("PERSON_NUMB", records[0].PERSON_NUMB);
						curRecord.set("PERSON_NAME", records[0].NAME);
					},
					onClear:function(type)	{
						var curRecord = masterGrid.uniOpt.currentRecord;
						curRecord.set("PERSON_NUMB", "");
						curRecord.set("PERSON_NAME", "");
					}
				}
			  })},
			{dataIndex: 'PERSON_NAME'		, width: 80 , 
			  editor:Unilite.popup('Employee_ACCNT_G', {
			  	textFieldName:'PERSON_NAME',
				DBtextFieldName: 'NAME',
				listeners:{
					onSelected:function(records, type)	{
						var curRecord = masterGrid.uniOpt.currentRecord;
						curRecord.set("PERSON_NUMB", records[0].PERSON_NUMB);
						curRecord.set("PERSON_NAME", records[0].NAME);
					},
					onClear:function(type)	{
						var curRecord = masterGrid.uniOpt.currentRecord;
						curRecord.set("PERSON_NUMB", "");
						curRecord.set("PERSON_NAME", "");
					}
				}
			  })}, 				
			{dataIndex: 'SERIES_NO'			, width: 100},		
			{dataIndex:	'REMARK'			, width: 266},
			{dataIndex: 'USE_YN'			, width: 66 }, 				
			{dataIndex: 'UPDATE_DB_USER'	, width: 0  },		
			{dataIndex:	'UPDATE_DB_TIME'	, width: 0 , hidden: true },
			{dataIndex: 'COMP_CODE'			, width: 0 , hidden: true }
		]               	
    });
    
    
	 Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult
			]	
		}		
		,panelSearch
		],
		id : 'ass310ukrApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['detail','reset','newData'],false);
			UniAppManager.setToolbarButtons(['reset','prev', 'next'],true);
		},
		onQueryButtonDown : function()	{		
			masterStore.loadStoreRecords();	
		},
		onNewDataButtonDown: function()	{
			var seq   = Unilite.nvl(masterStore.max('SEQ'), 0)+1;

            var r = {
            	ASST		: panelSearch.getValue("ASST"),
        	 	SEQ    		: seq,
        	 	SPEC		: panelSearch.getValue("SPEC"),
        	 	DIV_CODE	: panelSearch.getValue("DIV_CODE"),
        	 	DEPT_CODE	: panelSearch.getValue("DEPT_CODE"),
        	 	DEPT_NAME	: panelSearch.getValue("DEPT_NAME"),
        	 	PJT_CODE	: panelSearch.getValue("PJT_CODE"),
        	 	PJT_NAME	: panelSearch.getValue("PJT_NAME")
	        };
			masterGrid.createRow(r,'ASST_NAME');
				
		},
		onSaveDataButtonDown: function(config) {				
			masterStore.saveStore();
		},
		onResetButtonDown: function() {		
			panelSearch.clearForm();
			panelResult.clearForm();
			masterStore.loadData({});
			this.fnInitBinding();
		},
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid.getSelectedRecord();
			
			if(selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				masterGrid.deleteSelectedRow();
			}
		},
		onPrevDataButtonDown:  function()	{
			if(masterStore.isDirty())	{
				if(confirm(Msg.sMB061))	{
					this.onSaveDataButtonDown();
				} else {
					this.rejectSave();
				}
				return;
			}
			Ext.getBody().mask();
			var param = panelSearch.getValues();
			ass310ukrService.selectPrev(param, function(provider, response){
				Ext.getBody().unmask();
				if(provider)	{
					panelSearch.setValue("ASST", provider.ASST);
					panelSearch.setValue("ASST_NAME", provider.ASST_NAME);
					panelSearch.setValue("ACCNT", provider.ACCNT);
					panelSearch.setValue("ACCNT_NAME", provider.ACCNT_NAME);
					panelSearch.setValue("ACQ_DATE", provider.ACQ_DATE);
					panelSearch.setValue("DRB_YEAR", provider.DRB_YEAR);
					panelSearch.setValue("DRB_RATE", provider.DRB_RATE); 
					panelSearch.setValue("ACQ_AMT_I", provider.ACQ_AMT_I);
					
					panelResult.setValue("ASST", provider.ASST);
					panelResult.setValue("ASST_NAME", provider.ASST_NAME);
					panelResult.setValue("ACCNT", provider.ACCNT);
					panelResult.setValue("ACCNT_NAME", provider.ACCNT_NAME);
					panelResult.setValue("ACQ_DATE", provider.ACQ_DATE);
					panelResult.setValue("DRB_YEAR", provider.DRB_YEAR);
					panelResult.setValue("DRB_RATE", provider.DRB_RATE); 
					panelResult.setValue("ACQ_AMT_I", provider.ACQ_AMT_I);
					masterStore.loadStoreRecords();	
					UniAppManager.setToolbarButtons('newData',true);
				}else {
					UniAppManager.app.onResetButtonDown();
				}
			});
			
		},
		onNextDataButtonDown:  function()	{
			if(masterStore.isDirty())	{
				if(confirm(Msg.sMB061))	{
					this.onSaveDataButtonDown();
				} else {
					this.rejectSave();
				}
				return;
			}
			Ext.getBody().mask();
			var param = panelSearch.getValues();
			ass310ukrService.selectNext(param, function(provider, response){
				Ext.getBody().unmask();
				if(provider)	{
					panelSearch.setValue("ASST", provider.ASST);
					panelSearch.setValue("ASST_NAME", provider.ASST_NAME);
					panelSearch.setValue("ACCNT", provider.ACCNT);
					panelSearch.setValue("ACCNT_NAME", provider.ACCNT_NAME);
					panelSearch.setValue("ACQ_DATE", provider.ACQ_DATE);
					panelSearch.setValue("DRB_YEAR", provider.DRB_YEAR);
					panelSearch.setValue("DRB_RATE", provider.DRB_RATE); 
					panelSearch.setValue("ACQ_AMT_I", provider.ACQ_AMT_I);
					panelSearch.setValue("SPEC", provider.SPEC);
					panelSearch.setValue("DIV_CODE", provider.DIV_CODE);
					panelSearch.setValue("DEPT_CODE", provider.DEPT_CODE);
					panelSearch.setValue("DEPT_NAME", provider.DEPT_NAME);
					panelSearch.setValue("PJT_CODE", provider.PJT_CODE);
					panelSearch.setValue("PJT_NAME", provider.PJT_NAME);
					
					panelResult.setValue("ASST", provider.ASST);
					panelResult.setValue("ASST_NAME", provider.ASST_NAME);
					panelResult.setValue("ACCNT", provider.ACCNT);
					panelResult.setValue("ACCNT_NAME", provider.ACCNT_NAME);
					panelResult.setValue("ACQ_DATE", provider.ACQ_DATE);
					panelResult.setValue("DRB_YEAR", provider.DRB_YEAR);
					panelResult.setValue("DRB_RATE", provider.DRB_RATE); 
					panelResult.setValue("ACQ_AMT_I", provider.ACQ_AMT_I);
					panelResult.setValue("SPEC", provider.SPEC);
					panelResult.setValue("DIV_CODE", provider.DIV_CODE);
					panelResult.setValue("DEPT_CODE", provider.DEPT_CODE);
					panelResult.setValue("DEPT_NAME", provider.DEPT_NAME);
					panelResult.setValue("PJT_CODE", provider.PJT_CODE);
					panelResult.setValue("PJT_NAME", provider.PJT_NAME);
					masterStore.loadStoreRecords();	
					UniAppManager.setToolbarButtons('newData',true);
				}else {
					UniAppManager.app.onResetButtonDown();	
				}
			});
			
		}
	});
};


</script>
