<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="arc030ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A007" /> <!-- 마감여부 -->
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >


var checkSave = '';

function appMain() {
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'arc030ukrService.selectList',
			update: 'arc030ukrService.updateDetail',
			create: 'arc030ukrService.insertDetail',
			destroy: 'arc030ukrService.deleteDetail',
			syncAll: 'arc030ukrService.saveAll'
		}
	});	
	/**
	 *   Model 정의 
	 * @type 
	 */

	Unilite.defineModel('arc030ukrModel', {
		fields: [
			{name: 'CLOSE_DATE'		 			,text: '마감년월' 			,type: 'string'},
			{name: 'CLOSE_CHK'	 			    ,text: '선택' 			,type: 'boolean'},
			{name: 'CLOSE_FG'	 			    ,text: '마감여부' 			,type: 'string',comboType:'AU', comboCode:'A007'},
			{name: 'CLOSE_FG_DUMMY'	 	        ,text: '마감여부DUMMY' 	,type: 'string'},
			{name: 'INSERT_DB_USER'             ,text: 'INSERT_DB_USER' ,type: 'string'},
            {name: 'INSERT_DB_TIME'             ,text: 'INSERT_DB_TIME' ,type: 'uniDate'},
			{name: 'UPDATE_DB_USER' 			,text: 'UPDATE_DB_USER' ,type: 'string'},
			{name: 'UPDATE_DB_TIME' 			,text: 'UPDATE_DB_TIME' ,type: 'uniDate'},
			{name: 'COMP_CODE'      			,text: 'COMP_CODE' 		,type: 'string'}		
		]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('arc030ukrMasterStore1',{
		model: 'arc030ukrModel',
		uniOpt : {
        	isMaster: true,			// 상위 버튼 연결 
        	editable: true,			// 수정 모드 사용 
        	deletable:false,			// 삭제 가능 여부 
            useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
		loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore: function() {				
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			var toCreate = this.getNewRecords();
	   		var toUpdate = this.getUpdatedRecords();        		
	   		var toDelete = this.getRemovedRecords();
	   		var list = [].concat(toUpdate, toCreate);
			console.log("list:", list);
			var paramMaster= panelSearch.getValues();	//syncAll 수정
			
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						directMasterStore1.loadStoreRecords(); 
						
						checkSave = '';
					} 
				};
				this.syncAllDirect(config);
			} else {
	        	var grid = Ext.getCmp('arc030ukrGrid1');
	            grid.uniSelectInvalidColumnAndAlert(inValidRecs);
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
//			layout : {type : 'vbox', align : 'stretch'},
	    	items : [{
	    		xtype:'container',
	    		layout : {type : 'uniTable', columns : 1},
	    		items:[{
		            xtype: 'uniYearField',
		            name: 'F_CLOSE_DATE',
		            fieldLabel: '마감년도',
		            allowBlank:false,
		            value: new Date().getFullYear(),
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('F_CLOSE_DATE', newValue);
						}
					}
		         }]	
			},{
				xtype: 'button',
				text: '연간자료생성',
				width: 100,
				margin: '0 0 0 120',
				handler:function()	{
				
					masterGrid.reset();
					directMasterStore1.clearData();
	//				var records = directMasterStore1.data.items;
	//				Ext.each(records, function(record,i) {
	//					UniAppManager.app.onNewDataButtonDown();
	//				})
					
	//				var a = panelSearch.getValue('CLOSE_DATE')+'02'+'10';
								
	//				alert(Ext.Date.format(a, 'm'));
					var monthArr = ['01','02','03','04','05','06','07','08','09','10','11','12'];
					
					for (var i=0; i<12; i++) {
						UniAppManager.app.onNewDataButtonDown();
					
						var record = masterGrid.getSelectedRecord();
						record.set('CLOSE_DATE',panelSearch.getValue('F_CLOSE_DATE') + monthArr[i]);
					}
					
					checkSave = 'N';
				
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
   						var labelText = invalid.items[0]['fieldLabel']+'은(는)';
   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
   						var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
   					}

				   	alert(labelText+Msg.sMB083);
				   	invalid.items[0].focus();
				}
	  		}
			return r;
  		}
	});	
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
            xtype: 'uniYearField',
            name: 'F_CLOSE_DATE',
            fieldLabel: '마감년도',
            allowBlank:false,
            value: new Date().getFullYear(),
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('F_CLOSE_DATE', newValue);
				}
			}
         },{
			xtype: 'button',
			text: '연간자료생성',
			width: 100,
			margin: '0 0 0 120',
			handler:function()	{
				
				masterGrid.reset();
				directMasterStore1.clearData();
//				var records = directMasterStore1.data.items;
//				Ext.each(records, function(record,i) {
//					UniAppManager.app.onNewDataButtonDown();
//				})
				
//				var a = panelSearch.getValue('CLOSE_DATE')+'02'+'10';
							
//				alert(Ext.Date.format(a, 'm'));
				var monthArr = ['01','02','03','04','05','06','07','08','09','10','11','12'];
				
				for (var i=0; i<12; i++) {
					UniAppManager.app.onNewDataButtonDown();
				
					var record = masterGrid.getSelectedRecord();
					record.set('CLOSE_DATE',panelSearch.getValue('F_CLOSE_DATE') + monthArr[i]);

				}
				
				checkSave = 'N';
			}
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
   						var labelText = invalid.items[0]['fieldLabel']+'은(는)';
   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
   						var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
   					}

				   	alert(labelText+Msg.sMB083);
				   	invalid.items[0].focus();
				}
	  		}
			return r;
  		}	
    });    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('arc030ukrGrid1', {
        layout : 'fit',
        region:'center',
        excelTitle: '월마감등록',
        uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: false,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,
			enterKeyCreateRow : false,
    		filter: {
				useFilter: false,
				autoCreate: false
			}
        },
    	store: directMasterStore1,
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false , enableGroupingMenu:false },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
        columns: [        
			{ dataIndex: 'CLOSE_DATE'		,width: 100,align:'center'/*,
				renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
            		return  val.substring(0,4) + '.' + val.substring(4,6);
                }*/
            },
			{ dataIndex: 'CLOSE_CHK'		,width: 66, xtype: 'checkcolumn',align:'center',
				listeners:{
					checkchange: function( CheckColumn, rowIndex, checked, eOpts ){
    					var grdRecord = masterGrid.getStore().getAt(rowIndex);
			    		if(checked == true){
			    			if(grdRecord.get('CLOSE_FG') == 'N'){
			    				grdRecord.set('CLOSE_FG','Y');
			    			}else{
			    				grdRecord.set('CLOSE_FG','N');
			    			}
			    		}else{
			    			grdRecord.set('CLOSE_FG',grdRecord.get('CLOSE_FG_DUMMY'));
			    		}
    				}
				}
			},
			{ dataIndex: 'CLOSE_FG'		,width: 200,align:'center'},
			{ dataIndex: 'INSERT_DB_USER'   ,width:50, hidden: true},
            { dataIndex: 'INSERT_DB_TIME'   ,width:50, hidden: true},
			{ dataIndex: 'UPDATE_DB_USER'	,width:50, hidden: true},
			{ dataIndex: 'UPDATE_DB_TIME'	,width:50, hidden: true},
			{ dataIndex: 'COMP_CODE'     	,width:50, hidden: true}
		],
		listeners:{
			beforeedit  : function( editor, e, eOpts ) {
				if(UniUtils.indexOf(e.field, ['CLOSE_CHK'])){
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
				masterGrid, panelResult
			]
		},
			panelSearch  	
		],
		id  : 'arc030ukrApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons('save',false);
			UniAppManager.setToolbarButtons('reset',false);
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('F_CLOSE_DATE');
			this.setDefault();
		},
		onQueryButtonDown : function()	{
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
				checkSave = '';
				masterGrid.getStore().loadStoreRecords();
			    UniAppManager.setToolbarButtons('reset',true);
			}
		},
		onResetButtonDown: function() {
			checkSave = '';
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			directMasterStore1.clearData();
			this.fnInitBinding();
		},
		onNewDataButtonDown: function()	{
			if(!this.checkForNewDetail()) return false;
				/**
				 * Detail Grid Default 값 설정
				 */
				var compCode = UserInfo.compCode;
				var closeFg = 'N';
				var closeFgDummy = 'N';
				
            	 var r = {
            	 	COMP_CODE:	    compCode,
            	 	CLOSE_FG:		closeFg,
            	 	CLOSE_FG_DUMMY:	closeFgDummy
		        };
				masterGrid.createRow(r);
				
		},
		onSaveDataButtonDown: function(config) {
			if(checkSave == 'N'){
				var param = {"F_CLOSE_DATE": panelSearch.getValue('F_CLOSE_DATE')};
				arc030ukrService.checkBeforeInsert(param, function(provider, response)	{
					if(!Ext.isEmpty(provider)){
						if(provider['CNT'] > 0 ){
							if(confirm('이미 데이터가 존재합니다.\n다시 생성하시면 기존데이터가 삭제됩니다.\n그래도 생성하시겠습니까?')) {
							
								directMasterStore1.saveStore();
							}
						}else{
							directMasterStore1.saveStore();	
						}
					}
				});
			}else{
				directMasterStore1.saveStore();	
			}
			
			
		},
		setDefault: function() {
        	panelSearch.setValue('F_CLOSE_DATE',new Date().getFullYear());
        	panelResult.setValue('F_CLOSE_DATE',new Date().getFullYear());
		},
		checkForNewDetail:function() { 			
			return panelSearch.setAllFieldsReadOnly(true);
        }
	});

};


</script>
