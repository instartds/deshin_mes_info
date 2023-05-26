<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="aba200ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A018" /> <!-- 데이터유형-->
	<t:ExtComboStore comboType="AU" comboCode="A004" /> <!-- 사용여부-->
	<t:ExtComboStore comboType="AU" comboCode="A147" /> <!-- 데이터포맷-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {     
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Aba200ukrModel', {
	    fields: [  	  
	    	{name: 'AC_CD'					, text: '관리항목' 	,type: 'string', editable: false},
		    {name: 'AC_NAME'	  			, text: '관리항목명'	,type: 'string', allowBlank: false, maxLength: 20},
		    {name: 'DT_TYPE'				, text: '유형' 		,type: 'string', comboType:'AU', comboCode:'A018', allowBlank: false},
		    {name: 'DT_LEN'					, text: '길이' 		,type: 'int', allowBlank: false, maxLength: 2},
		    {name: 'DT_FMT'					, text: '포맷' 		,type: 'string', comboType:'AU', comboCode:'A147'},
		    {name: 'DT_POPUP'	 			, text: 'POPUP여부' 	,type: 'string', comboType:'AU', comboCode:'A004', allowBlank: false},
		    {name: 'USE_YN'					, text: '사용여부' 	,type: 'string', comboType:'AU', comboCode:'A004'},
		    {name: 'COMP_CODE'				, text: '회사코드' 	,type: 'string'}
		]         	
	});
	
	
	Unilite.defineModel('Aba200ukrModel2', {
	    fields: [  	  
		    {name: 'AC_CD'					, text: 'AC_CD' 	,type: 'string', allowBlank: false},
		    {name: 'DT_TYPE'				, text: 'DT_TYPE' 	,type: 'string'},		    		   
		    {name: 'AC_DATA_STR'			, text: '상세코드' 	,type: 'string', allowBlank: false},
		    {name: 'AC_DATA_DATE'			, text: '상세코드' 	,type: 'uniDate', allowBlank: false},		    
		    {name: 'AC_NAME'				, text: '상세코드명1' 	,type: 'string', allowBlank: false, maxLength: 50},
		    {name: 'REF_CODE1'				, text: '상세코드명2' 	,type: 'string', maxLength: 50},
		    {name: 'REF_CODE2'				, text: '상세코드명3' 	,type: 'string', maxLength: 50},
		    {name: 'COMP_CODE'				, text: '회사코드' 	,type: 'string', allowBlank: false}
		]         	
	});
		  
	var directMasterProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
        	read : 'aba200ukrService.selectMasterList',
        	update: 'aba200ukrService.updateMaster',
//			create: 'aba200ukrService.insertMaster',
//			destroy: 'aba200ukrService.deleteMaster',
			syncAll: 'aba200ukrService.saveAll'
        }
	});
	
	var directDetailProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
        	read : 'aba200ukrService.selectDetailList',
        	update: 'aba200ukrService.updateDetail',
			create: 'aba200ukrService.insertDetail',
			destroy: 'aba200ukrService.deleteDetail',
			syncAll: 'aba200ukrService.saveAll'
        }
	});  
	  
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('aba200ukrMasterStore1',{
		model: 'Aba200ukrModel',
		uniOpt: {
            isMaster: false,		// 상위 버튼 연결 
            editable: true,			// 수정 모드 사용 
            deletable:false,			// 삭제 가능 여부 
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directMasterProxy,
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param,
				callback : function(records,options,success)	{
					if(success)	{
						UniAppManager.setToolbarButtons('newData', false);
					}
				}
			});
		},
		saveStore : function()	{
			var inValidRecs = this.getInvalidRecords();
			if(inValidRecs.length == 0 )	{
				var config = {
					params:[panelSearch.getValues()],
					success : function()	{
						if(directDetailStore.isDirty())	{
							directDetailStore.saveStore();						
						}
					}
				}
				this.syncAllDirect(config);			
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
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
	
	var directDetailStore = Unilite.createStore('aba200ukrMasterStore2',{
		model: 'Aba200ukrModel2',
		uniOpt: {
            isMaster: false,			// 상위 버튼 연결 
            editable: true,			// 수정 모드 사용 
            deletable:true,			// 삭제 가능 여부 
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directDetailProxy,
        loadStoreRecords: function(record) {
      
			var searchParam= Ext.getCmp('searchForm').getValues();
			var param= {
					'AC_CD':record.get('AC_CD')};	
			var params = Ext.merge(searchParam, param);
			console.log( param );
			this.load({
				params : params,
				callback : function(records,options,success)	{
					if(success)	{
						UniAppManager.setToolbarButtons('delete', false);
					}
				}
			});
		},
		saveStore : function()	{
			var inValidRecs = this.getInvalidRecords();
		
			if(inValidRecs.length == 0 )	{
				var config = {
					params:[panelSearch.getValues()],
					success : function()	{}									
				}
				this.syncAllDirect(config);	
			}else {				
				detailGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
			
		},
		listeners: {
           	load: function(store, records, successful, eOpts) {
           		if(records != null && records.length > 0 ){
           			UniAppManager.setToolbarButtons('delete', true);
           		}
			},
			update : function( store, record, operation, modifiedFieldNames, details, eOpts ){
				UniAppManager.setToolbarButtons('save', true);		
			},
			datachanged : function(store,  eOpts) {
				if( directMasterStore.isDirty() || store.isDirty() )	{
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
	    		items:[
	    			Unilite.popup('USER_MANAGE',{
	    			validateBlank: true,
					fieldLabel: '관리항목',    			
					listeners: {
						onValueFieldChange: function(field, newValue){
							panelResult.setValue('USER_MANAGE_CODE', newValue);								
						},
						onTextFieldChange: function(field, newValue){
							panelResult.setValue('USER_MANAGE_NAME', newValue);				
						}
//						onSelected: {
//							fn: function(records, type) {
//								panelResult.setValue('USER_MANAGE_CODE', panelSearch.getValue('USER_MANAGE_CODE'));
//								panelResult.setValue('USER_MANAGE_NAME', panelSearch.getValue('USER_MANAGE_NAME'));				 																							
//							},
//							scope: this
//						}
//						,
//						onClear: function(type)	{
//							panelResult.setValue('USER_MANAGE_CODE', '');
//							panelResult.setValue('USER_MANAGE_NAME', '');
//						}
					}
				})]	
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
		items: [		    
	    	Unilite.popup('USER_MANAGE',{
	    	validateBlank: true,
			fieldLabel: '관리항목',    			
			listeners: {
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('USER_MANAGE_CODE', newValue);								
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('USER_MANAGE_NAME', newValue);				
				}
//				onSelected: {
//					fn: function(records, type) {
//						panelSearch.setValue('USER_MANAGE_CODE', panelResult.getValue('USER_MANAGE_CODE'));
//						panelSearch.setValue('USER_MANAGE_NAME', panelResult.getValue('USER_MANAGE_NAME'));				 																							
//					},
//					scope: this
//				}
//				,
//				onClear: function(type)	{
//					panelSearch.setValue('USER_MANAGE_CODE', '');
//					panelSearch.setValue('USER_MANAGE_NAME', '');
//				}
			}
		})]	
    });
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('aba200ukrGrid1', {
    	layout : 'fit',
        region : 'center',
        itemId:'masterGrid',
        store : directMasterStore,
    	uniOpt: {
    		expandLastColumn: false,
		 	useRowNumberer: true
//		 	copiedRow: true
//		 	useContextMenu: true,
        },
        columns: [        
        	{dataIndex: 'AC_CD'			, width: 80}, 				
			{dataIndex: 'AC_NAME'		, width: 180}, 				
			{dataIndex: 'DT_TYPE'		, width: 90}, 				
			{dataIndex: 'DT_LEN'		, width: 80}, 				
			{dataIndex: 'DT_FMT'		, width: 80}, 				
			{dataIndex: 'DT_POPUP'		, width: 100}, 				
			{dataIndex: 'USE_YN'		, minWidth: 66, flex: 1}, 				
			{dataIndex: 'COMP_CODE'		, width: 66	, hidden: true}
		],
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    	},{
    		id: 'masterGridTotal', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: false
    	}],
		listeners: {
          	beforeedit  : function( editor, e, eOpts ) {
          		if(directDetailStore.data.items.length > 0){
          			if(e.field == 'DT_TYPE'){
          				return false;
          			}
          		}
				if(e.field == 'DT_FMT'){
					if(e.record.get('DT_TYPE') != "N"){
						return false;
					}
				}				
			},	
        	selectionchange:function( model1, selected, eOpts ){       			
       			if(selected.length == 1)	{	
//       				var model = directDetailStore.getModel();
//       				var field = {name: 'AC_DATA'				, text: '상세코드' 	,type: 'uniDate', allowBlank: false};
//       				model.removeFields(['AC_DATA']);
//       				model.addFields([field]);
//       				detailGrid.setColumnInfo(detailGrid, detailGrid.getColumn('AC_DATA'), field);  
//       			detailGrid.setColumns(detailGrid.);
       				
//       				var col = detailGrid.getColumn('AC_DATA');
//       				
//       				Ext.applyIf(col, {align: 'center', xtype: 'uniDateColumn' });
//			      //Ext.applyIf(col, {format: Unilite.dateFormat });
//			      
//			      // 날자 Editor 설정 
//			      Ext.applyIf(editorConfing, {
//			       xtype : 'uniDatefield',
//			          format: Unilite.dateFormat 
//			       });
//					var columns = detailGrid.getColumns();
//					Ext.each(columns, function(col, index){
//						if(col.dataIndex == 'AC_DATA'){
//							col = {align: 'center', xtype: 'uniDateColumn', editor: {xtype : 'uniDatefield', format: Unilite.dateFormat}}
//						}
//					});
//					detailGrid.reconfigure(directDetailStore, columns);
			        
	        		var record = selected[0];
	        		if(record.get('DT_TYPE') == "D"){	//날짜
						detailGrid.getColumn('AC_DATA_STR').setVisible(false);
						detailGrid.getColumn('AC_DATA_DATE').setVisible(true);
					}else{
						detailGrid.getColumn('AC_DATA_STR').setVisible(true);
						detailGrid.getColumn('AC_DATA_DATE').setVisible(false);
					}
	        		directDetailStore.loadStoreRecords(record);
	        		
       			}
          	},
          	render: function(grid, eOpts){
			 	var girdNm = grid.getItemId();
			 	var store = grid.getStore();
			    grid.getEl().on('click', function(e, t, eOpt) {
					if( directMasterStore.isDirty() || directDetailStore.isDirty() )	{
						UniAppManager.setToolbarButtons('save', true);	
					}else {
						UniAppManager.setToolbarButtons('save', false);
					}
			    	if(grid.getStore().getCount() > 0)	{
						UniAppManager.setToolbarButtons('delete', true);		
					}else {
						UniAppManager.setToolbarButtons('delete', false);
					}
					UniAppManager.setToolbarButtons('delete', false);
					UniAppManager.setToolbarButtons('newData', false);
			    });
			 },
			 beforedeselect : function ( gird, record, index, eOpts ){
				if(directDetailStore.isDirty())	{
					if(confirm(Msg.sMB017 + "\n" + Msg.sMB061))	{						
						UniAppManager.app.onSaveDataButtonDown();
					}
				}
			}
		}
    }); 
       
     /**
     * Master Grid2 정의(Grid Panel)
     * @type 
     */
    
    var detailGrid = Unilite.createGrid('aba200ukrGrid2', {
    	layout : 'fit',
        region : 'east',
        itemId:'detailGrid',
        store : directDetailStore,
    	uniOpt: {
    		expandLastColumn: false,
		 	useRowNumberer: true,
		 	copiedRow: true,
            onLoadSelectFirst: false
//		 	useContextMenu: true,
        },
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
        	//{dataIndex: 'AC_CD'			, width: 100 , hidden:true},
        	//{dataIndex: 'DT_TYPE'		, width: 100 , hidden:true},
        	{dataIndex: 'AC_DATA_STR'	, width: 93 },
        	{dataIndex: 'AC_DATA_DATE'	, width: 93, hidden: true },
			{dataIndex: 'AC_NAME'		, width: 180}, 				
			{dataIndex: 'REF_CODE1'		, width: 180},
			{dataIndex: 'REF_CODE2'		, minWidth: 100, flex: 1},
			{dataIndex: 'COMP_CODE'		, width: 66  , hidden:true}
		],
		listeners: {	
        	selectionchange:function( model1, selected, eOpts ){
       			UniAppManager.setToolbarButtons('delete', true);
          	},
          	render: function(grid, eOpts){
			 	var girdNm = grid.getItemId();
			 	var store = grid.getStore();
			    grid.getEl().on('click', function(e, t, eOpt) {	
			    	if( directMasterStore.isDirty() || directDetailStore.isDirty() )	{
						UniAppManager.setToolbarButtons('save', true);	
					}else {
						UniAppManager.setToolbarButtons('save', false);
					}
			    	if(grid.getStore().getCount() > 0)	{
						UniAppManager.setToolbarButtons('delete', true);		
					}else {
						UniAppManager.setToolbarButtons('delete', false);
					}
					var record = masterGrid.getSelectedRecord();
					if(!Ext.isEmpty(record)){
						if(record.get('DT_LEN') != "0"){
							UniAppManager.setToolbarButtons('newData', true);
						}
					}
					
					
			    });
			 },
			 beforeedit  : function( editor, e, eOpts ) {
				if(!e.record.phantom){
					if(e.field == 'AC_DATA_STR' || e.field == 'AC_DATA_DATE'){
						return false;
					}
				}
			}
		}		
    });
    
	 Unilite.Main( {
	 	border: false,
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, detailGrid, panelResult
			]
		},
			panelSearch  	
		], 
		id : 'aba200ukrApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('USER_MANAGE_CODE');
		},
		onQueryButtonDown : function()	{		
			directMasterStore.loadStoreRecords();				
		},
		onNewDataButtonDown: function()	{
			var record = masterGrid.getSelectedRecord();
			var	r = {
				AC_CD: record.get('AC_CD'),
				DT_TYPE: record.get('DT_TYPE'),
				COMP_CODE: UserInfo.compCode
        	};  			  			
			detailGrid.createRow(r, 'AC_DATA_STR');
		},
		onDeleteDataButtonDown: function() {	
		 	var selRow = detailGrid.getSelectedRecord();
			if(selRow.phantom === true)	{
				detailGrid.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				detailGrid.deleteSelectedRow();				
			}			
		},
		onSaveDataButtonDown: function () {
			var inValidRecs1 = directMasterStore.getInvalidRecords();
			var inValidRecs2 = directDetailStore.getInvalidRecords();
			if(inValidRecs1.length != 0 || inValidRecs2.length != 0)	{
				if(inValidRecs1.length != 0){
					masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs1);
				}
				if(inValidRecs2.length != 0){
					detailGrid.uniSelectInvalidColumnAndAlert(inValidRecs2);
				}
				return false;		
			}else{
				if(directMasterStore.isDirty())	{									
					directMasterStore.saveStore();			//Master 데이타 저장 성공 후 Detail 저장함.			
				}else if(directDetailStore.isDirty()){
					directDetailStore.saveStore();
				}
			}
			
								
		}
	});
	
	Unilite.createValidator('validator01', {
		store: directMasterStore,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
			if(newValue == oldValue){
				return false;
			}
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record, 'editor':editor, 'e':e});
			var rv = true;
			switch(fieldName) {
				case "DT_TYPE" :
					if(newValue == "D"){	//날짜
						detailGrid.getColumn('AC_DATA_STR').setVisible(false);
						detailGrid.getColumn('AC_DATA_DATE').setVisible(true);
					}else{
						detailGrid.getColumn('AC_DATA_STR').setVisible(true);
						detailGrid.getColumn('AC_DATA_DATE').setVisible(false);
					}
					break;
				case "DT_LEN" :
					if(newValue > "20"){	//날짜
						rv = "입력 할 수 있는 자릿수를 초과 하였습니다.";
					}
					break;
			}
			
			return rv;
		}
	});
	
	Unilite.createValidator('validator02', {
		store: directDetailStore,
		grid: detailGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
			if(newValue == oldValue){
				return false;
			}
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record, 'editor':editor, 'e':e});
			var rv = true;
			switch(fieldName) {
				case "AC_DATA_STR" :
					var masterRecord = masterGrid.getSelectedRecord();
					if(parseInt(masterRecord.get('DT_LEN')) < newValue.length ){
						rv = "길이를 확인해 주세요.";
					}
					if(masterRecord.get('DT_TYPE') == "N"){	//날짜
						if(isNaN(newValue)){
							rv = "숫만 입력 가능합니다.";
						}
					}
					record.set('AC_DATA_DATE', '29991231');	//필수값 피하기 위해..
					break;
				case "AC_DATA_DATE" :
				 	record.set('AC_DATA_STR', UniDate.getDbDateStr(newValue));
					break;
				case "AC_CODE1" :					
					
					break;
				
			}
			
			return rv;
		}
	});
};


</script>
