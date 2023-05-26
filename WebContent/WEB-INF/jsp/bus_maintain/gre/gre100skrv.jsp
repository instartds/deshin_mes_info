<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//정비댓수집계조회
request.setAttribute("PKGNAME","Unilite_app_gre100skrv");
%>
<t:appConfig pgmId="gre100skrv"  >
<t:ExtComboStore comboType="BOR120"/>								<!-- 사업장 -->
<t:ExtComboStore items="${ROUTE_COMBO}" storeId="routeStore" /> 	<!-- 노선 -->
<t:ExtComboStore comboType="AU" comboCode="GO22"/>					<!-- 정비팀 --> 
<t:ExtComboStore comboType="AU" comboCode="GO25"/>					<!-- 주야간구분 --> 
<t:ExtComboStore comboType="AU" comboCode="GO24"/>					<!-- 작업근거 	--> 
</t:appConfig>
<script type="text/javascript">
function appMain() {
	Unilite.defineModel('${PKGNAME}Model', {
	
	    fields: [
			{name: 'COMP_CODE'            		,text:'법인코드'		,type : 'string'},
			{name: 'DIV_CODE'            		,text:'사업장'		,type : 'string'},
			{name: 'MECHANIC_TEAM'            	,text:'정비팀(코드)'	,type : 'string'},
			{name: 'MECHANIC_TEAM_NAME'         ,text:'정비팀'		,type : 'string'},
			{name: 'AM_PM'          			,text:'주야간구분(코드)'	,type : 'string'},
			{name: 'AM_PM_NAME'            		,text:'주야간구분'		,type : 'string'},
			{name: 'MAINTAIN_GROUND'            ,text:'작업근거(코드)'	,type : 'string'},
			{name: 'MAINTAIN_GROUND_NAME'       ,text:'작업근거'		,type : 'string'},
			{name: 'VEHICLE_COUNT'            	,text:'댓수'			,type : 'uniQty'},
			{name: 'VEHICLE_COUNT_PER_DAY'      ,text:'댓수 1일평균'	,type : 'uniER'},
			{name: 'MECHANIC_NUMBER'            ,text:'정비인원'		,type : 'uniQty'},
			{name: 'MECHANIC_NUMBER_PER_DAY'    ,text:'정비인원 1일평균'	,type : 'uniER'},
			{name: 'WORKING_TIME'            	,text:'소요시간'		,type : 'uniQty'},
			{name: 'WORKING_TIME_PER_DAY'       ,text:'소요시간 1일평균'	,type : 'uniER'},
			{name: 'WT_PER_VEHICLE'            	,text:'대당소요'		,type : 'uniQty'},
			{name: 'WT_PER_VEHICLE_PER_DAY'     ,text:'대당소요 1일평균'	,type : 'uniER'},
			{name: 'NUMBER_PER_VEHICLE'         ,text:'대당투입인원'	,type : 'uniQty'},
			{name: 'NUMBER_PER_VEHICLE_PER_DAY' ,text:'대당투입인원 1일평균',type : 'uniER'}
		]
	});	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'gre100skrvService.selectList'/*,
			update: 'gre100skrvService.updateDetail',
			create: 'gre100skrvService.insertDetail',
			destroy: 'gre100skrvService.deleteDetail',
			syncAll: 'gre100skrvService.saveAll'*/
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
		title: '정비댓수집계',
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
			},{
				fieldLabel: '작업근거',
				name: 'MAINTAIN_GROUND',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'GO24',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('MAINTAIN_GROUND', newValue);
					}
				}
			},{
				//labelWidth: 10,
				fieldLabel:'정비구분',
			 	id:'vehicle_C',
			 	name: 'VEHICLE_COUNT',
			 	xtype: 'checkbox',
			 	boxLabel: '전체작업포함',
			 	listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('VEHICLE_COUNT', newValue);
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
			},{
				fieldLabel: '작업근거',
				name: 'MAINTAIN_GROUND',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'GO24',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('MAINTAIN_GROUND', newValue);
					}
				}
			},{
				//labelWidth: 10,
				fieldLabel:'정비구분',
			 	id:'vehicle_C2',
			 	name: 'VEHICLE_COUNT',
			 	xtype: 'checkbox',
			 	boxLabel: '전체작업포함',
			 	listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('VEHICLE_COUNT', newValue);
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
			{dataIndex:'COMP_CODE'            		  ,width: 80,hidden:true},
			{dataIndex:'DIV_CODE'            		  ,width: 110,hidden:true},
			{dataIndex:'MECHANIC_TEAM'            	  ,width: 110,hidden:true},
			{dataIndex:'MECHANIC_TEAM_NAME'           ,width: 80},
			{dataIndex:'AM_PM'          			  ,width: 110,hidden:true},
			{dataIndex:'AM_PM_NAME'            		  ,width: 100},
			{dataIndex:'MAINTAIN_GROUND'              ,width: 110,hidden:true},
			{dataIndex:'MAINTAIN_GROUND_NAME'         ,width: 80},
			{dataIndex:'VEHICLE_COUNT'            	  ,width: 50},
			{dataIndex:'VEHICLE_COUNT_PER_DAY'        ,width: 100},
			{dataIndex:'MECHANIC_NUMBER'              ,width: 80},
			{dataIndex:'MECHANIC_NUMBER_PER_DAY'      ,width: 110},
			{dataIndex:'WORKING_TIME'            	  ,width: 80},
			{dataIndex:'WORKING_TIME_PER_DAY'         ,width: 110},
			{dataIndex:'WT_PER_VEHICLE'               ,width: 80},
			{dataIndex:'WT_PER_VEHICLE_PER_DAY'       ,width: 110},
			{dataIndex:'NUMBER_PER_VEHICLE'           ,width: 110},
			{dataIndex:'NUMBER_PER_VEHICLE_PER_DAY'   ,width: 130}
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
		id  : 'gre100skrApp',
		autoButtonControl : false,
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['print'],false);
			UniAppManager.setToolbarButtons(['reset', 'excel' ],true);
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
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