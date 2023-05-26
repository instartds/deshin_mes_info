<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//정비요청내역조회
request.setAttribute("PKGNAME","Unilite_app_gre600skrv");
%>
<t:appConfig pgmId="gre600skrv"  >
<t:ExtComboStore comboType="BOR120"/>								<!-- 사업장   	-->
<t:ExtComboStore items="${ROUTE_COMBO}" storeId="routeStore" /> 	<!-- 노선 -->
<t:ExtComboStore comboType="AU" comboCode="GO19"/>					<!-- 정비코드 	--> 
<t:ExtComboStore comboType="AU" comboCode="GO21"/>					<!-- 결과판정 	--> 
</t:appConfig>
<script type="text/javascript">
function appMain() {
	Unilite.defineModel('${PKGNAME}Model', {
	
	    fields: [
			{name: 'COMP_CODE'            		,text:'법인코드'		,type : 'string'},
			{name: 'DIV_CODE'            		,text:'사업장'		,type : 'string'},
			{name: 'REQUEST_NUM'            	,text:'요청번호'		,type : 'string'},
			{name: 'VEHICLE_CODE'            	,text:'차량코드'		,type : 'string'},
			{name: 'VEHICLE_REGIST_NO'          ,text:'차량번호'		,type : 'string'},
			{name: 'REQUEST_DATE'            	,text:'요청일자'		,type : 'string'},
			{name: 'ROUTE_CODE'            		,text:'노선코드'		,type : 'string'},
			{name: 'ROUTE_NUM'            		,text:'노선번호'		,type : 'string'},
			{name: 'DRIVER_CODE'            	,text:'기사코드'		,type : 'string'},
			{name: 'NAME'            			,text:'기사명'		,type : 'string'},
			{name: 'MAINTAIN_CODE'            	,text:'정비코드'		,type : 'string', comboType:'AU', comboCode:'GO19'},
			{name: 'CONDITION'            		,text:'상태설명'		,type : 'string'},
			{name: 'CHECK_RESULT'            	,text:'결과판정'		,type : 'string', comboType:'AU', comboCode:'GO21'},
			{name: 'REMARK'            			,text:'비고'			,type : 'string'}
		]
	});	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'gre600skrvService.selectList'/*,
			update: 'gre600skrvService.updateDetail',
			create: 'gre600skrvService.insertDetail',
			destroy: 'gre600skrvService.deleteDetail',
			syncAll: 'gre600skrvService.saveAll'*/
		}
	});
    var masterStore =  Unilite.createStore('${PKGNAME}Store',{
        model: '${PKGNAME}Model',
         autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
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
			},
			groupField: 'REQUEST_DATE'
		});
	
	var panelSearch = Unilite.createSearchPanel('${PKGNAME}SearchForm',{
		title: '정비요청내역',
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
				fieldLabel: '사업장', 
				name: 'DIV_CODE', 
				xtype: 'uniCombobox', 
				comboType: 'BOR120', 
				allowBlank: false,
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{
	        	fieldLabel: '조회기간',
	        	xtype: 'uniDateRangefield',
	        	startFieldName: 'REQUEST_DATE_FR',
	        	endFieldName:'REQUEST_DATE_TO',
	        	width: 315,
	        	startDate: UniDate.get('startOfMonth'),
	        	endDate: UniDate.get('today'),
	        	onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('REQUEST_DATE_FR',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('REQUEST_DATE_TO',newValue);
			    	}
			    }
			},{	    
				fieldLabel: '노선',
				name: 'ROUTE_CODE'	,
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('routeStore'),
				listeners:{
					beforequery: function(queryPlan, eOpts )	{
						var pValue = panelSearch.getValue('ROUTE_GROUP');
						var store = queryPlan.combo.getStore();
						if(!Ext.isEmpty(pValue) )	{
							store.clearFilter(true);
							queryPlan.combo.queryFilter = null;				
							store.filter('option', pValue);
						} else {
							store.clearFilter(true);
							queryPlan.combo.queryFilter = null;	
							store.loadRawData(store.proxy.data);
						}
					},
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ROUTE_CODE', newValue);
					}
				}						
			},
	 		Unilite.popup('VEHICLE',
				 {
				 	itemId:'vehicle',
				 	extParam:{'DIV_CODE': UserInfo.divCode},
				 	listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('VEHICLE_CODE', panelSearch.getValue('VEHICLE_CODE'));
							panelResult.setValue('VEHICLE_NAME', panelSearch.getValue('VEHICLE_NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('VEHICLE_CODE', '');
						panelResult.setValue('VEHICLE_NAME', '');
					}
				}
				 }
			),Unilite.popup('DRIVER',
		 	 {
		 	 	fieldLabel:'기사',
		 		itemId:'driver',
		 		extParam:{'DIV_CODE': UserInfo.divCode},
		 		useLike:true,
		 		validateBlank:false,
		 		listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('DRIVER_CODE', panelSearch.getValue('DRIVER_CODE'));
							panelResult.setValue('DRIVER_NAME', panelSearch.getValue('DRIVER_NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('DRIVER_CODE', '');
						panelResult.setValue('DRIVER_NAME', '');
					}
				}
		 	 }
	 		),{
				fieldLabel: '정비코드',
				name: 'MAINTAIN_CODE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'GO19',
				multiSelect: true, 
		        typeAhead: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('MAINTAIN_CODE', newValue);
					}
				}
			},{
				fieldLabel: '결과판정',
				name: 'CHECK_RESULT',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'GO21',
				multiSelect: true, 
		        typeAhead: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('CHECK_RESULT', newValue);
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
				fieldLabel: '사업장', 
				name: 'DIV_CODE', 
				xtype: 'uniCombobox', 
				comboType: 'BOR120', 
				allowBlank: false,
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
			},{
	        	fieldLabel: '조회기간',
	        	xtype: 'uniDateRangefield',
	        	startFieldName: 'REQUEST_DATE_FR',
	        	endFieldName:'REQUEST_DATE_TO',
	        	width: 315,
	        	startDate: UniDate.get('startOfMonth'),
	        	endDate: UniDate.get('today'),
	        	onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelSearch) {
						panelSearch.setValue('REQUEST_DATE_FR',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('REQUEST_DATE_TO',newValue);
			    	}
			    }
			},{	    
				fieldLabel: '노선',
				name: 'ROUTE_CODE'	,
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('routeStore'),
				listeners:{
					beforequery: function(queryPlan, eOpts )	{
						var pValue = panelResult.getValue('ROUTE_GROUP');
						var store = queryPlan.combo.getStore();
						if(!Ext.isEmpty(pValue) )	{
							store.clearFilter(true);
							queryPlan.combo.queryFilter = null;				
							store.filter('option', pValue);
						} else {
							store.clearFilter(true);
							queryPlan.combo.queryFilter = null;	
							store.loadRawData(store.proxy.data);
						}
					},
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('ROUTE_CODE', newValue);
					}
				}						
			},
	 		Unilite.popup('VEHICLE',
				 {
				 	itemId:'vehicle',
				 	extParam:{'DIV_CODE': UserInfo.divCode},
				 	listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('VEHICLE_CODE', panelResult.getValue('VEHICLE_CODE'));
							panelSearch.setValue('VEHICLE_NAME', panelResult.getValue('VEHICLE_NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('VEHICLE_CODE', '');
						panelSearch.setValue('VEHICLE_NAME', '');
					}
				}
				 }
				
			),Unilite.popup('DRIVER',
		 	 {
		 	 	fieldLabel:'기사',
		 		itemId:'driver',
		 		extParam:{'DIV_CODE': UserInfo.divCode},
		 		useLike:true,
		 		validateBlank:false,
		 		listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('DRIVER_CODE', panelResult.getValue('DRIVER_CODE'));
							panelSearch.setValue('DRIVER_NAME', panelResult.getValue('DRIVER_NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('DRIVER_CODE', '');
						panelSearch.setValue('DRIVER_NAME', '');
					}
				}
		 	 }
	 		),{
				fieldLabel: '정비코드',
				name: 'MAINTAIN_CODE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'GO19',
				multiSelect: true, 
		        typeAhead: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('MAINTAIN_CODE', newValue);
					}
				}
			},{
				fieldLabel: '결과판정',
				name: 'CHECK_RESULT',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'GO21',
				multiSelect: true, 
		        typeAhead: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('CHECK_RESULT', newValue);
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
       	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
    	store: masterStore, 
		columns:[
			{dataIndex:'COMP_CODE'                		,width: 80, hidden:true },
			{dataIndex:'DIV_CODE'                 		,width: 80, hidden:true },
			{dataIndex:'REQUEST_NUM'              		,width: 80 },
			{dataIndex:'VEHICLE_CODE'             		,width: 60 },
			{dataIndex:'VEHICLE_REGIST_NO'        		,width: 100 },
			{dataIndex:'REQUEST_DATE'             		,width: 80,align:'center' },
			{dataIndex:'ROUTE_CODE'               		,width: 60 },
			{dataIndex:'ROUTE_NUM'                		,width: 70 },
			{dataIndex:'DRIVER_CODE'              		,width: 60 },
			{dataIndex:'NAME'            	        	,width: 60 },
			{dataIndex:'MAINTAIN_CODE'            		,width: 90 },
			{dataIndex:'CONDITION'                		,width: 400 },
			{dataIndex:'CHECK_RESULT'             		,width: 60 },
			{dataIndex:'REMARK'                   		,width: 150 }
		]
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
		id  : 'gre600skrApp',
		autoButtonControl : false,
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons(['print'],false);
			UniAppManager.setToolbarButtons(['reset', 'excel' ],true);
			
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
		},
		onSaveAsExcelButtonDown: function() {
			masterGrid.downloadExcelXml();
		}
	});

	
	
}; // main
  
</script>