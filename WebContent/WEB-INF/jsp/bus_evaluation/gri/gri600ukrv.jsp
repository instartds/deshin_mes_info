<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//노선별손실보조금 
request.setAttribute("PKGNAME","Unilite_app_grd200ukrv");
%>
<t:appConfig pgmId="grd200ukrv"  >
<t:ExtComboStore comboType="AU" comboCode="GO10"/>					<!-- 운행구분 	--> 
<t:ExtComboStore comboType="AU" comboCode="GO11"/>					<!-- 노선구분 	--> 
</t:appConfig>
<script type="text/javascript">
function appMain() {
	Unilite.defineModel('${PKGNAME}Model', {

		fields: [
			{name: 'COMP_CODE'      		,text:'법인코드'					,type : 'string'}, 
			{name: 'SERVICE_YEAR'   		,text:'기준년도'					,type : 'uniDate'},
			{name: 'ROUTE_NUM'      		,text:'노선번호</br>&nbsp;&nbsp;(B+NM)'					,type : 'string', allowBlank: false},
			{name: 'ROUTE_ID'       		,text:'노선번호</br>&nbsp;&nbsp;(ID)'					,type : 'string', allowBlank: false},
			{name: 'OPERATION_TYPE' 		,text:'유형구분'					,type : 'string',comboType:'AU', comboCode:'GO10', allowBlank: false},
			{name: 'ROUTE_TYPE'     		,text:'노선구분'					,type : 'string',comboType:'AU', comboCode:'GO11', allowBlank: false},
			
			{name: 'SUBSIDY_TYPE'			,text:'보조금구분'					,type : 'string'},
			{name: 'SUBSIDY_AMT'     		,text:'노선별손실보조금(원/년)'		,type : 'uniPrice'},
			
			{name: 'SUBSIDY_AMT_01'			,text:'01'						,type : 'uniPrice'},
			{name: 'SUBSIDY_AMT_02'			,text:'02'						,type : 'uniPrice'},
			{name: 'SUBSIDY_AMT_03'			,text:'03'						,type : 'uniPrice'},
			{name: 'SUBSIDY_AMT_04'			,text:'04'						,type : 'uniPrice'},
			{name: 'SUBSIDY_AMT_05'			,text:'05'						,type : 'uniPrice'},
			{name: 'SUBSIDY_AMT_06'			,text:'06'						,type : 'uniPrice'},
			{name: 'SUBSIDY_AMT_07'			,text:'07'						,type : 'uniPrice'},
			{name: 'SUBSIDY_AMT_08' 		,text:'08'						,type : 'uniPrice'},
			{name: 'SUBSIDY_AMT_09'			,text:'09'						,type : 'uniPrice'},
			{name: 'SUBSIDY_AMT_10'			,text:'10'						,type : 'uniPrice'},
			{name: 'SUBSIDY_AMT_11'			,text:'11'						,type : 'uniPrice'},
			{name: 'SUBSIDY_AMT_12'			,text:'12'						,type : 'uniPrice'}
		]
	});	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'grd200ukrvService.selectList'/*,
			update: 'grd200ukrvService.updateDetail',
			create: 'grd200ukrvService.insertDetail',
			destroy: 'grd200ukrvService.deleteDetail',
			syncAll: 'grd200ukrvService.saveAll'*/
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
				var inValidRecs = this.getInvalidRecords();
				
				if(inValidRecs.length == 0 )	{
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
		title: '노선별 손실보조금',
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
				name: 'BASE_YEAR',
				xtype: 'uniYearField',
				width:185,				
				value: new Date().getFullYear(),
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('BASE_YEAR', newValue);
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
			name: 'BASE_YEAR',
			xtype: 'uniYearField',
			width:185,
			value: new Date().getFullYear(),
			allowBlank: false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('BASE_YEAR', newValue);
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
    	store: masterStore, 
		columns:[
			{dataIndex:'COMP_CODE'        		,width: 80 ,hidden:true},
			{dataIndex:'SERVICE_YEAR'     		,width: 80 ,hidden:true},
			{dataIndex:'ROUTE_NUM'        		,width: 80 },
			{dataIndex:'ROUTE_ID'         		,width: 80 },
			{dataIndex:'OPERATION_TYPE'   		,width: 120 },
			{dataIndex:'ROUTE_TYPE'       		,width: 100 },
			{dataIndex:'SUBSIDY_TYPE'       	,width: 80 },
			{dataIndex:'SUBSIDY_AMT'        	,width: 200 },
			{ 
	         	text:'운송수입금(원/월)',
	         		columns: [
			         	{dataIndex:'SUBSIDY_AMT_01'  	,width: 80 },
			         	{dataIndex:'SUBSIDY_AMT_02'  	,width: 80 },
			         	{dataIndex:'SUBSIDY_AMT_03' 	,width: 80 },
			         	{dataIndex:'SUBSIDY_AMT_04'  	,width: 80 },
			         	{dataIndex:'SUBSIDY_AMT_05'  	,width: 80 },
			         	{dataIndex:'SUBSIDY_AMT_06'  	,width: 80 },
			         	{dataIndex:'SUBSIDY_AMT_07'  	,width: 80 },
			         	{dataIndex:'SUBSIDY_AMT_08'  	,width: 80 },
			         	{dataIndex:'SUBSIDY_AMT_09'  	,width: 80 },
			         	{dataIndex:'SUBSIDY_AMT_10'  	,width: 80 },
			         	{dataIndex:'SUBSIDY_AMT_11'  	,width: 80 },
			         	{dataIndex:'SUBSIDY_AMT_12' 	,width: 80 }
		         	]              
			}]                      
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
		id  : 'grc100ukrApp',
		autoButtonControl : false,
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['reset', 'newData', 'excel', 'prev', 'next' ],true);
			panelSearch.setValue('BASE_YEAR', new Date().getFullYear() -1);
			panelResult.setValue('BASE_YEAR', new Date().getFullYear() -1);
		},
		
		onQueryButtonDown : function()	{
			masterStore.loadStoreRecords();
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
			if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				masterGrid.deleteSelectedRow();				
			}
		},
		onResetButtonDown:function() {
			var me = this;
			panelSearch.reset();
			masterGrid.reset();
			UniAppManager.setToolbarButtons('save',false);
			panelSearch.setValue('BASE_YEAR', new Date().getFullYear() -1);
			panelResult.setValue('BASE_YEAR', new Date().getFullYear() -1);
		},
		onSaveAsExcelButtonDown: function() {
			masterGrid.downloadExcelXml();
		}
	});

	
	
}; // main
  
</script>