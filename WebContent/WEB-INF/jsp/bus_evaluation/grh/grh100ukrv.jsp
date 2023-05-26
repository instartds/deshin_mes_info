<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//노선별차량현황 
request.setAttribute("PKGNAME","Unilite_app_grh100ukrv");
%>
<t:appConfig pgmId="grh100ukrv"  >
<t:ExtComboStore comboType="AU" comboCode="GO10"/>					<!-- 유형구분 	--> 
<t:ExtComboStore comboType="AU" comboCode="GO11"/>					<!-- 노선구분 	-->
<t:ExtComboStore comboType="AU" comboCode="GR01"/>					<!-- 노선구분 	-->
</t:appConfig>
<script type="text/javascript">
function appMain() {
	Unilite.defineModel('${PKGNAME}Model', {
	
	    fields: [{name: 'COMP_CODE'		            			,text:'COMP_CODE'			,type : 'string', allowBlank: false},
				 {name: 'SERVICE_YEAR'	            			,text:'기준년도'				,type : 'string', allowBlank: false},
				 {name: 'ROUTE_NUM'		            			,text:'노선번호</br>&nbsp;&nbsp;(B+NM)'	,type : 'string', allowBlank: false},
				 {name: 'ROUTE_ID'		            			,text:'노선번호(ID)'			,type : 'string', allowBlank: false},
				 {name: 'OPERATION_TYPE'            			,text:'유형구분'				,type : 'string',comboType:'AU', comboCode:'GO10', allowBlank: false},
				 {name: 'ROUTE_TYPE'		            		,text:'노선구분'				,type : 'string',comboType:'AU', comboCode:'GO11', allowBlank: false},
				 {name: 'COLLECT_TYPE'	            			,text:'징수구분'				,type : 'string',comboType:'AU', comboCode:'GR01', allowBlank: false},
				 {name: 'COLLECT_TOT_AMT'	            		,text:'운송수입금</br>&nbsp;&nbsp;(원/년)'	,type : 'uniPrice'},
				 {name: 'COLLECT_AMT_01'            			,text:'01'					,type : 'uniPrice'},
				 {name: 'COLLECT_AMT_02'            			,text:'02'					,type : 'uniPrice'},
				 {name: 'COLLECT_AMT_03'            			,text:'03'					,type : 'uniPrice'},
				 {name: 'COLLECT_AMT_04'            			,text:'04'					,type : 'uniPrice'},
				 {name: 'COLLECT_AMT_05'            			,text:'05'					,type : 'uniPrice'},
				 {name: 'COLLECT_AMT_06'            			,text:'06'					,type : 'uniPrice'},
				 {name: 'COLLECT_AMT_07'            			,text:'07'					,type : 'uniPrice'},
				 {name: 'COLLECT_AMT_08'            			,text:'08'					,type : 'uniPrice'},
				 {name: 'COLLECT_AMT_09'            			,text:'09'					,type : 'uniPrice'},
				 {name: 'COLLECT_AMT_10'            			,text:'10'					,type : 'uniPrice'},
				 {name: 'COLLECT_AMT_11'            			,text:'11'					,type : 'uniPrice'},
				 {name: 'COLLECT_AMT_12'            			,text:'12'					,type : 'uniPrice'},
				 {name: 'INSERT_DB_USER'            			,text:'INSERT_DB_USER'		,type : 'string'},
				 {name: 'INSERT_DB_TIME'            			,text:'INSERT_DB_TIME'		,type : 'string'},
				 {name: 'UPDATE_DB_USER'            			,text:'UPDATE_DB_USER'		,type : 'string'},
				 {name: 'UPDATE_DB_TIME'            			,text:'UPDATE_DB_TIME'		,type : 'string'}
		]
	});	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'grh100ukrvService.selectList',
			update: 'grh100ukrvService.updateDetail',
			create: 'grh100ukrvService.insertDetail',
			destroy: 'grh100ukrvService.deleteDetail',
			syncAll: 'grh100ukrvService.saveAll'
		}
	});
    var masterStore =  Unilite.createStore('${PKGNAME}Store',{
        model: '${PKGNAME}Model',
         autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:true,			// 삭제 가능 여부 
	            useNavi : true			// prev | next 버튼 사용
            },
            
            proxy: directProxy,
            saveStore : function(config)	{	

            	var paramMaster= panelSearch.getValues();
				var inValidRecs = this.getInvalidRecords();
				
					if(inValidRecs.length == 0 )	{
					config = {
							params: [paramMaster]
					};
					
					this.syncAllDirect(config);					
            }else {
					var grid = Ext.getCmp('${PKGNAME}Grid');
                	grid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			} ,
			loadStoreRecords: function()	{
				var searchForm = Ext.getCmp('${PKGNAME}SearchForm');
				var param= searchForm.getValues();
				if(searchForm.isValid())	{
					this.load({params: param});
				}
			}
			
		});
	
	var panelSearch = Unilite.createSearchPanel('${PKGNAME}SearchForm',{
		title: '월별운송수입금',
        defaultType: 'uniSearchSubPanel',
        defaults: {
			autoScroll:true
	  	},
        collapsed: UserInfo.appOption.collapseLeftSearch,
        listeners: {
	        collapse: function () {
	        	panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
	    },
        width: 330,
		items: [{	
			title: '검색조건', 	
			id: 'search_panel1',
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',  
           	defaults:{
           		labelWidth:80
           	},
	    	items:[{
				fieldLabel: '기준년도',
				name: 'SERVICE_YEAR',
				xtype: 'uniYearField',
				width:185,
				value: new Date().getFullYear(),
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('SERVICE_YEAR', newValue);
					}
				}
			}]				
		}]
		
	});	//end panelSearch    
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
			fieldLabel: '기준년도',
			name: 'SERVICE_YEAR',
			xtype: 'uniYearField',
			width:185,
			value: new Date().getFullYear(),
			allowBlank: false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('SERVICE_YEAR', newValue);
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
					} else {
						//this.mask();
						var fields = this.getForm().getFields();
						Ext.each(fields.items, function(item) {
							if(Ext.isDefined(item.holdable) )	{
							 	if (item.holdable == 'hold') {
									item.setReadOnly(true); 
								}
								
							} 
							if(item.isPopupField)	{
								var popupFC = item.up('uniPopupField')	;							
								if(popupFC.holdable == 'hold') {
									popupFC.setReadOnly(true);
								}
							
							}
						})
	   				}
		  		} else {
  					//this.unmask();
		  			var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) )	{
						 	if (item.holdable == 'hold') {
								item.setReadOnly(false);
							}
							
						} 
						if(item.isPopupField)	{
							var popupFC = item.up('uniPopupField')	;	
							if(popupFC.holdable == 'hold' ) {
								item.setReadOnly(false);
							}
							
						}
					})
  				}
				return r;
  		},
  		setLoadRecord: function(record)	{
			var me = this;			
			me.uniOpt.inLoading=false;
		    me.setAllFieldsReadOnly(true);
		}
	});
	
     var masterGrid = Unilite.createGrid('${PKGNAME}Grid', {
        layout : 'fit',        
    	region:'center',
		uniOpt:{
			useRowNumberer: false,
        	expandLastColumn: false,
            useMultipleSorting: false
        },
        tbar: [{
        	itemId : 'ref1', iconCls : 'icon-referance'	,
    		text:'전년도참조하기',
    		handler: function() {
//	        		openOrderReferWindow();
    			}
   		 },
   		 {
        	itemId : 'ref2', iconCls : 'icon-referance'	,
    		text:'데이터가져오기',
    		handler: function() {
//	        		openOrderReferWindow();
    			}
   		 }],
//        features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true},
//    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: true} ],
    	store: masterStore, 
		columns:[
			{xtype: 'rownumberer'  /* dataIndex:'SEQ', */ 	,width: 40, text:'연번',sortable: false},
			{dataIndex:'COMP_CODE'		            		,width: 66, hidden:true},
			{dataIndex:'SERVICE_YEAR'	            		,width: 66, hidden:true },
			{dataIndex:'ROUTE_NUM'		            		,width: 100},
			{dataIndex:'ROUTE_ID'		            		,width: 100},
			{dataIndex:'OPERATION_TYPE'            			,width: 110},
			{dataIndex:'ROUTE_TYPE'		            		,width: 100},
			{dataIndex:'COLLECT_TYPE'	            		,width: 80},
			{dataIndex:'COLLECT_TOT_AMT'	            	,width: 100},
			{
				text:'운송수입금(원/월)',
	         		columns: [
	         			{dataIndex:'COLLECT_AMT_01'            			,width: 100},
						{dataIndex:'COLLECT_AMT_02'            			,width: 100},
						{dataIndex:'COLLECT_AMT_03'            			,width: 100},
						{dataIndex:'COLLECT_AMT_04'            			,width: 100},
						{dataIndex:'COLLECT_AMT_05'            			,width: 100},
						{dataIndex:'COLLECT_AMT_06'            			,width: 100},
						{dataIndex:'COLLECT_AMT_07'            			,width: 100},
						{dataIndex:'COLLECT_AMT_08'            			,width: 100},
						{dataIndex:'COLLECT_AMT_09'            			,width: 100},
						{dataIndex:'COLLECT_AMT_10'            			,width: 100},
						{dataIndex:'COLLECT_AMT_11'            			,width: 100},
						{dataIndex:'COLLECT_AMT_12'            			,width: 100}
	         		]
			},			
			{dataIndex:'INSERT_DB_USER'            			,width: 66, hidden: true},
			{dataIndex:'INSERT_DB_TIME'            			,width: 66, hidden: true},
			{dataIndex:'UPDATE_DB_USER'            			,width: 66, hidden: true},
			{dataIndex:'UPDATE_DB_TIME'            			,width: 66, hidden: true}
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if(e.field == 'COLLECT_TOT_AMT') return false;	
				if(!e.record.phantom){	//신규아닐때
					if (UniUtils.indexOf(e.field, 
						[ 'ROUTE_NUM'     
   					])) 		
						return false; 
				}
			}
		}
   });
	
      Unilite.Main({
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
		id  : 'grh100ukrApp',
		autoButtonControl : false,
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['print','newData'],false);
			UniAppManager.setToolbarButtons(['reset',  'excel', 'prev', 'next' ],true);
			panelSearch.setValue('SERVICE_YEAR', new Date().getFullYear() -1);
			panelResult.setValue('SERVICE_YEAR', new Date().getFullYear() -1);
		},
		
		onQueryButtonDown : function()	{
			masterStore.loadStoreRecords();
			
			UniAppManager.setToolbarButtons(['newData'],true);
		},
		onPrevDataButtonDown:  function()	{
			masterGrid.selectPriorRow();
		},
		onNextDataButtonDown:  function()	{
			masterGrid.selectNextRow();
		},	
		onNewDataButtonDown:  function()	{

			masterGrid.createRow();
		},	
		
		onSaveDataButtonDown: function (config) {
			masterStore.saveStore();
					
		},
		onDeleteDataButtonDown : function()	{
			var selRow = masterGrid.getSelectedRecord();
			if(selRow.phantom === true)	{				
				masterGrid.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				
					masterGrid.deleteSelectedRow();
				
			}
		},
		onResetButtonDown:function() {
			var me = this;
			panelSearch.reset();
			masterGrid.reset();
			UniAppManager.setToolbarButtons('save',false);
			this.fnInitBinding();
		},
		onSaveAsExcelButtonDown: function() {
			masterGrid.downloadExcelXml();
		}
	});
	Unilite.createValidator('validator01', {
		store: masterStore,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
			//가동대수	
				case "OPERATION_GAS_GEN" :
				if(newValue < 0){
					rv='양수만 입력가능합니다';
					break;
				}						
			}
				return rv;
		}
	});	
	
}; // main
  
</script>