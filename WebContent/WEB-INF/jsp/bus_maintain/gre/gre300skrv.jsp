<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//차량별 정비내역조회
request.setAttribute("PKGNAME","Unilite_app_gre300skrv");
%>
<t:appConfig pgmId="gre300skrv"  >
<t:ExtComboStore comboType="BOR120"/>								<!-- 사업장 -->
<t:ExtComboStore items="${ROUTE_COMBO}" storeId="routeStore" /> 	<!-- 노선 -->
<t:ExtComboStore comboType="AU" comboCode="GO22"/>					<!-- 정비팀 --> 
<t:ExtComboStore comboType="AU" comboCode="GO23"/>					<!-- 작업지 --> 
<t:ExtComboStore comboType="AU" comboCode="GO25"/>					<!-- 주야간구분 --> 
<t:ExtComboStore comboType="AU" comboCode="GO19"/>					<!-- 정비코드 --> 
</t:appConfig>
<script type="text/javascript">
function appMain() {
	Unilite.defineModel('${PKGNAME}Model', {
	
	    fields: [
			{name: 'COMP_CODE'                  ,text:'법인코드'		,type : 'string'},
			{name: 'DIV_CODE'                   ,text:'사업장'		,type : 'string'},
			{name: 'MECHANIC_TEAM'       	    ,text:'정비팀(코드)'	,type : 'string'},
			{name: 'MECHANIC_TEAM_NAME'  	    ,text:'정비팀'		,type : 'string'},
			{name: 'AM_PM'  	  			    ,text:'주야간구분(코드)'	,type : 'string'},
			{name: 'AM_PM_NAME'  	  		    ,text:'주야간구분'		,type : 'string'},
			{name: 'VEHICLE_CODE'  	  		    ,text:'차량코드'		,type : 'string'},
			{name: 'VEHICLE_NAME'  	  		    ,text:'차량명'		,type : 'string'},
			{name: 'MAINTAIN_GROUND'  	  	    ,text:'작업근거(코드)'	,type : 'string'},
			{name: 'MAINTAIN_GROUND_NAME'  	    ,text:'작업근거'		,type : 'string'},
			{name: 'MAINTAIN_DATE'  	  	    ,text:'정비일자'		,type : 'uniDate'},
			{name: 'VEHICLE_COUNT'  	  	    ,text:'차량대수'		,type : 'uniQty'},
			{name: 'MECHANIC_NUMBER'  	  	    ,text:'정비인원'		,type : 'uniQty'},
			{name: 'MAINTAIN_CODE'  	  	    ,text:'정비코드(코드)'	,type : 'string'},
			{name: 'MAINTAIN_NAME'  	  		    ,text:'정비코드'		,type : 'string'},
			{name: 'ASSIGNED_TIME'    		    ,text:'할당'			,type : 'string'},
			{name: 'DIFFICULTY'  	  		    ,text:'난이도(코드)'	,type : 'string'},
			{name: 'DIFFICULTY_NAME'  	  		    ,text:'난이도'		,type : 'string'},
			{name: 'TASK_DESC'  	  		    ,text:'작업내역'		,type : 'string'}
		]
	});	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'gre300skrvService.selectList'/*,
			update: 'gre300skrvService.updateDetail',
			create: 'gre300skrvService.insertDetail',
			destroy: 'gre300skrvService.deleteDetail',
			syncAll: 'gre300skrvService.saveAll'*/
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
            /*saveStore : function(config)	{				
				var inValidRecs = this.getInvalidRecords();
				
				if(inValidRecs.length == 0 )	{
					this.syncAllDirect(config);					
				}else {
					var grid = Ext.getCmp('${PKGNAME}Grid');
                	grid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			} ,*/
			loadStoreRecords: function()	{
				var searchForm = Ext.getCmp('${PKGNAME}SearchForm');
				var param= searchForm.getValues();
				if(searchForm.isValid())	{
					this.load({params: param});
				}
			}
		});
	
	var panelSearch = Unilite.createSearchPanel('${PKGNAME}SearchForm',{
		title: '차량별정비내역',
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
	        	allowBlank:false,
	        	holdable: 'hold',
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
				fieldLabel: '작업지',
				name: 'MAINTAIN_PLACE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'GO23',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('MAINTAIN_PLACE', newValue);
					}
				}
			},{
				fieldLabel: '정비팀',
				name: 'MECHANIC_TEAM',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'GO22',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('MECHANIC_TEAM', newValue);
					}
				}
			},{
				fieldLabel: '주야간구분',
				name: 'AM_PM',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'GO25',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('AM_PM', newValue);
					}
				}
			},Unilite.popup('VEHICLE',
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
			),{
				fieldLabel: '정비코드',
				name: 'MAINTAIN_CODE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'GO19',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('MAINTAIN_CODE', newValue);
					}
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
  		}
		
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
	        	allowBlank:false,
	        	holdable: 'hold',
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
				fieldLabel: '작업지',
				name: 'MAINTAIN_PLACE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'GO23',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('MAINTAIN_PLACE', newValue);
					}
				}
			},{
				fieldLabel: '정비팀',
				name: 'MECHANIC_TEAM',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'GO22',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('MECHANIC_TEAM', newValue);
					}
				}
			},{
				fieldLabel: '주야간구분',
				name: 'AM_PM',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'GO25',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('AM_PM', newValue);
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
				
			),{
				fieldLabel: '정비코드',
				name: 'MAINTAIN_CODE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'GO19',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('MAINTAIN_CODE', newValue);
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
		/*uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: false,
			useContextMenu: false,
			useMultipleSorting: false,
			useRowNumberer: false,
			expandLastColumn: false,
    		filter: {
				useFilter: false,
				autoCreate: false
			}
        },*/
    	uniOpt:{
			useRowNumberer: false,
        	expandLastColumn: false,
            useMultipleSorting: false,
            filter: {
				useFilter: false,
				autoCreate: false
			}
        },
//        features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true},
//    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: true} ],
    	store: masterStore, 
		columns:[
			{dataIndex:'COMP_CODE'              ,width: 80,hidden:true},
			{dataIndex:'DIV_CODE'               ,width: 110,hidden:true},
			{dataIndex:'MECHANIC_TEAM'       	,width: 110,hidden:true},
			{dataIndex:'MECHANIC_TEAM_NAME'  	,width: 90},
			{dataIndex:'AM_PM'  	  			,width: 110,hidden:true},
			{dataIndex:'AM_PM_NAME'  	  		,width: 90},
			{dataIndex:'VEHICLE_CODE'  	  		,width: 80},
			{dataIndex:'VEHICLE_NAME'  	  		,width: 80},
			{dataIndex:'MAINTAIN_GROUND'  	  	,width: 110,hidden:true},
			{dataIndex:'MAINTAIN_GROUND_NAME'  	,width: 80},
			{dataIndex:'MAINTAIN_DATE'  	  	,width: 80},
			{dataIndex:'VEHICLE_COUNT'  	  	,width: 80},
			{dataIndex:'MECHANIC_NUMBER'  	  	,width: 80},
			{dataIndex:'MAINTAIN_CODE'  	  	,width: 110,hidden:true},
			{dataIndex:'MAINTAIN_NAME'  	  	,width: 110},
			{dataIndex:'ASSIGNED_TIME'    		,width: 70},
			{dataIndex:'DIFFICULTY'  	  		,width: 110,hidden:true},
			{dataIndex:'DIFFICULTY_NAME'  	  	,width: 70},
			{dataIndex:'TASK_DESC'  	  		,width: 300}
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
		id  : 'gre300skrApp',
		autoButtonControl : false,
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['print'],false);
			UniAppManager.setToolbarButtons(['reset', 'excel' ],true);
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('REQUEST_DATE_FR',UniDate.get('startOfMonth'));
			panelSearch.setValue('REQUEST_DATE_TO',UniDate.get('today'));
			panelResult.setValue('REQUEST_DATE_FR',UniDate.get('startOfMonth'));
			panelResult.setValue('REQUEST_DATE_TO',UniDate.get('today'));
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
			this.fnInitBinding();
		},
		onSaveAsExcelButtonDown: function() {
			masterGrid.downloadExcelXml();
		}
	});

	
	
}; // main
  
</script>