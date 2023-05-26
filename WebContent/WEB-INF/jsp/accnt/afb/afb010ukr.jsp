<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="afb010ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A007" /> <!-- 마감여부 -->
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'afb010ukrService.selectList',
			update: 'afb010ukrService.updateDetail',
			create: 'afb010ukrService.insertDetail',
			destroy: 'afb010ukrService.deleteDetail',
			syncAll: 'afb010ukrService.saveAll'
		}
	});	
	/**
	 *   Model 정의 
	 * @type 
	 */

	Unilite.defineModel('Afb010ukrModel', {
		fields: [
			{name: 'CLOSE_DATE'		 			,text: '마감년도' 			,type: 'string',allowBlank:false},
			{name: 'BUDG_CLOSE_CHK'	 			,text: '선택' 			,type: 'boolean'},
			{name: 'BUDG_CLOSE_FG'	 			,text: '마감여부' 			,type: 'string',comboType:'AU', comboCode:'A007'},
			{name: 'BUDG_CLOSE_FG_DUMMY'	 			,text: '마감여부DUMMY' 			,type: 'string'},
			{name: 'CONF_CLOSE_CHK'	 			,text: '선택' 			,type: 'boolean'},
			{name: 'CONF_CLOSE_FG'	 			,text: '마감여부' 			,type: 'string',comboType:'AU', comboCode:'A007'},
			{name: 'CONF_CLOSE_FG_DUMMY'	 			,text: '마감여부DUMMY' 			,type: 'string'},
			{name: 'DRAFT_CLOSE_CHK'	 			,text: '선택' 			,type: 'boolean'},
			{name: 'DRAFT_CLOSE_FG'	 			,text: '마감여부' 			,type: 'string',comboType:'AU', comboCode:'A007'},
			{name: 'DRAFT_CLOSE_FG_DUMMY'	 			,text: '마감여부DUMMY' 			,type: 'string'},
			{name: 'PAY_CLOSE_CHK'	 			,text: '선택' 			,type: 'boolean'},
			{name: 'PAY_CLOSE_FG'	 			,text: '마감여부' 			,type: 'string',comboType:'AU', comboCode:'A007'},
			{name: 'PAY_CLOSE_FG_DUMMY'	 			,text: '마감여부DUMMY' 			,type: 'string'},
			{name: 'IN_CLOSE_CHK'	 			,text: '선택' 			,type: 'boolean'},
			{name: 'IN_CLOSE_FG'	 			,text: '마감여부' 			,type: 'string',comboType:'AU', comboCode:'A007'},
			{name: 'IN_CLOSE_FG_DUMMY'	 			,text: '마감여부DUMMY' 			,type: 'string'},
			{name: 'UPDATE_DB_USER' 			,text: 'UPDATE_DB_USER' ,type: 'string'},
			{name: 'UPDATE_DB_TIME' 			,text: 'UPDATE_DB_TIME' ,type: 'uniDate'},
			{name: 'COMP_CODE'      			,text: 'COMP_CODE' 		,type: 'string',allowBlank:false}		
		]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('afb010ukrMasterStore1',{
		model: 'Afb010ukrModel',
		uniOpt : {
        	isMaster: true,			// 상위 버튼 연결 
        	editable: true,			// 수정 모드 사용 
        	deletable:true,			// 삭제 가능 여부 
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
						directMasterStore.loadStoreRecords(); 
						
					} 
				};
				this.syncAllDirect(config);
			} else {
	        	var grid = Ext.getCmp('afb010ukrGrid1');
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
		            name: 'CLOSE_DATE',
		            fieldLabel: '마감년도',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('CLOSE_DATE', newValue);
						}
					}
		         }]	
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
            name: 'CLOSE_DATE',
            fieldLabel: '마감년도',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('CLOSE_DATE', newValue);
				}
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
    
    var masterGrid = Unilite.createGrid('afb010ukrGrid1', {
        layout : 'fit',
        region:'center',
        excelTitle: '예산마감등록',
        uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: false,
			useMultipleSorting: true,
			useRowNumberer: true,
			expandLastColumn: true,
			enterKeyCreateRow : false,
    		filter: {
				useFilter: false,
				autoCreate: false
			},
			state: {
				useState: true,			
				useStateList: true		
			}
        },
    	store: directMasterStore,
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false , enableGroupingMenu:false  },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
        columns: [        
			{ dataIndex: 'CLOSE_DATE'		,width: 100,align:'center'},
			{ text: '예산신청/편성',
				columns: [
					{ dataIndex: 'BUDG_CLOSE_CHK'		,width: 66, xtype: 'checkcolumn',align:'center',
						listeners:{
							checkchange: function( CheckColumn, rowIndex, checked, eOpts ){
		    					var grdRecord = masterGrid.getStore().getAt(rowIndex);
					    		if(checked == true){
					    			if(grdRecord.get('BUDG_CLOSE_FG') == 'N'){
					    				grdRecord.set('BUDG_CLOSE_FG','Y');
					    			}else{
					    				grdRecord.set('BUDG_CLOSE_FG','N');
					    			}
					    		}else{
					    			grdRecord.set('BUDG_CLOSE_FG',grdRecord.get('BUDG_CLOSE_FG_DUMMY'));
					    		}
		    				}
						}
					},
					{ dataIndex: 'BUDG_CLOSE_FG'		,width: 200,align:'center'}
				]
			},{
				text: '예산조정/확정',
				columns: [
					{ dataIndex: 'CONF_CLOSE_CHK'		,width: 66, xtype: 'checkcolumn',align:'center',
						listeners:{
							checkchange: function( CheckColumn, rowIndex, checked, eOpts ){
		    					var grdRecord = masterGrid.getStore().getAt(rowIndex);
					    		if(checked == true){
					    			if(grdRecord.get('CONF_CLOSE_FG') == 'N'){
					    				grdRecord.set('CONF_CLOSE_FG','Y');
					    			}else{
					    				grdRecord.set('CONF_CLOSE_FG','N');
					    			}
					    		}else{
					    			grdRecord.set('CONF_CLOSE_FG',grdRecord.get('CONF_CLOSE_FG_DUMMY'));
					    		}
		    				}
						}
					},
					{ dataIndex: 'CONF_CLOSE_FG'		,width: 200,align:'center'}
				]
			},{
				text: '예산기안(추산)',
				columns: [
					{ dataIndex: 'DRAFT_CLOSE_CHK'		,width: 66, xtype: 'checkcolumn',align:'center',
						listeners:{
							checkchange: function( CheckColumn, rowIndex, checked, eOpts ){
		    					var grdRecord = masterGrid.getStore().getAt(rowIndex);
					    		if(checked == true){
					    			if(grdRecord.get('DRAFT_CLOSE_FG') == 'N'){
					    				grdRecord.set('DRAFT_CLOSE_FG','Y');
					    			}else{
					    				grdRecord.set('DRAFT_CLOSE_FG','N');
					    			}
					    		}else{
					    			grdRecord.set('DRAFT_CLOSE_FG',grdRecord.get('DRAFT_CLOSE_FG_DUMMY'));
					    		}
		    				}
						}
					},
					{ dataIndex: 'DRAFT_CLOSE_FG'		,width: 200,align:'center'}
				]
			},{
				text: '지출결의',
				columns: [
					{ dataIndex: 'PAY_CLOSE_CHK'		,width: 66, xtype: 'checkcolumn',align:'center',
						listeners:{
							checkchange: function( CheckColumn, rowIndex, checked, eOpts ){
		    					var grdRecord = masterGrid.getStore().getAt(rowIndex);
					    		if(checked == true){
					    			if(grdRecord.get('PAY_CLOSE_FG') == 'N'){
					    				grdRecord.set('PAY_CLOSE_FG','Y');
					    			}else{
					    				grdRecord.set('PAY_CLOSE_FG','N');
					    			}
					    		}else{
					    			grdRecord.set('PAY_CLOSE_FG',grdRecord.get('PAY_CLOSE_FG_DUMMY'));
					    		}
		    				}
						}
					},
					{ dataIndex: 'PAY_CLOSE_FG'		,width: 200,align:'center'}
				]
			},{
				text: '수입결의',
				columns: [
					{ dataIndex: 'IN_CLOSE_CHK'		,width: 66, xtype: 'checkcolumn',align:'center',
						listeners:{
							checkchange: function( CheckColumn, rowIndex, checked, eOpts ){
		    					var grdRecord = masterGrid.getStore().getAt(rowIndex);
					    		if(checked == true){
					    			if(grdRecord.get('IN_CLOSE_FG') == 'N'){
					    				grdRecord.set('IN_CLOSE_FG','Y');
					    			}else{
					    				grdRecord.set('IN_CLOSE_FG','N');
					    			}
					    		}else{
					    			grdRecord.set('IN_CLOSE_FG',grdRecord.get('IN_CLOSE_FG_DUMMY'));
					    		}
		    				}
						}
					},
					{ dataIndex: 'IN_CLOSE_FG'		,width: 200,align:'center'}
				]
			},
			{ dataIndex: 'UPDATE_DB_USER'	,width:50, hidden: true},
			{ dataIndex: 'UPDATE_DB_TIME'	,width:50, hidden: true},
			{ dataIndex: 'COMP_CODE'     	,width:50, hidden: true}
		],
		listeners:{
			beforeedit  : function( editor, e, eOpts ) {
				if(e.record.phantom){
					if(UniUtils.indexOf(e.field, ['CLOSE_DATE','BUDG_CLOSE_FG_CHK','CONF_CLOSE_FG_CHK',
												'DRAFT_CLOSE_FG_CHK','PAY_CLOSE_FG_CHK','IN_CLOSE_FG_CHK'])){
						return true;
					}else{
						return false;
					}
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
		id  : 'afb010ukrApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['save','reset','newData'],false);
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('CLOSE_DATE');
			this.setDefault();
		},
		onQueryButtonDown : function()	{
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
				masterGrid.getStore().loadStoreRecords();
			    UniAppManager.setToolbarButtons([/*'reset',*/'newData'],true);
			}
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			directMasterStore.clearData();
			this.fnInitBinding();
		},
		onNewDataButtonDown: function()	{
			if(!this.checkForNewDetail()) return false;
				/**
				 * Detail Grid Default 값 설정
				 */
				var compCode = UserInfo.compCode;
				var budgCloseFg = 'N';
				var budgCloseFgDummy = 'N';
				var confCloseFg = 'N';
				var confCloseFgDummy = 'N';
				var draftCloseFg = 'N';
				var draftCloseFgDummy = 'N';
				var payCloseFg = 'N';
				var payCloseFgDummy = 'N';
				var inCloseFg = 'N';
				var inCloseFgDummy = 'N';
				
            	 var r = {
            	 	COMP_CODE:			compCode,
            	 	BUDG_CLOSE_FG:		budgCloseFg,
            	 	BUDG_CLOSE_FG_DUMMY:	budgCloseFgDummy,
            	 	CONF_CLOSE_FG:		confCloseFg,
            	 	CONF_CLOSE_FG_DUMMY:	confCloseFgDummy,
					DRAFT_CLOSE_FG:		draftCloseFg,
					DRAFT_CLOSE_FG_DUMMY:	draftCloseFgDummy,
					PAY_CLOSE_FG:		payCloseFg,
					PAY_CLOSE_FG_DUMMY:		payCloseFgDummy,
					IN_CLOSE_FG:		inCloseFg,
					IN_CLOSE_FG_DUMMY:		inCloseFgDummy
 
		        };
				masterGrid.createRow(r);
				
		},
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid.getSelectedRecord();
			if(selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();
			}
		},
		onSaveDataButtonDown: function(config) {
			directMasterStore.saveStore();
		},
		setDefault: function() {
		},
		checkForNewDetail:function() { 			
			return panelSearch.setAllFieldsReadOnly(true);
        }
	});
	Unilite.createValidator('validator01', {
		store: directMasterStore,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			if(newValue != oldValue)	{
				switch(fieldName) {
					case "CLOSE_DATE" :
						if(isNaN(newValue)|| newValue.length > 4){
							rv='<t:message code = "unilite.msg.sMB070"/>';
						}else{
							if(1900 > newValue || newValue > 2999){
								rv='<t:message code = "unilite.msg.sMB069"/>';
							}
						}
				}
			}
			return rv;
		}
	});	
};


</script>
