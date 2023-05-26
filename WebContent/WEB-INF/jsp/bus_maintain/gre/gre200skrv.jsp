<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//정비팀별 집계 조회
request.setAttribute("PKGNAME","Unilite_app_gre200skrv");
%>
<t:appConfig pgmId="gre200skrv"  >
<t:ExtComboStore comboType="BOR120"/>								<!-- 사업장 -->
<t:ExtComboStore items="${ROUTE_COMBO}" storeId="routeStore" /> 	<!-- 노선 -->
<t:ExtComboStore comboType="AU" comboCode="GO22"/>					<!-- 정비팀 --> 
<t:ExtComboStore comboType="AU" comboCode="GO23"/>					<!-- 작업지 --> 
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
			{name: 'MAINTAIN_PLACE'         	,text:'작업지(코드)'	,type : 'string'},
			{name: 'MAINTAIN_PLACE_NAME'    	,text:'작업지'		,type : 'string'},
			{name: 'MAINTAIN_COUNT'          	,text:'정비횟수'		,type : 'uniQty'},
			{name: 'ASSIGNED_TIME'          	,text:'할당합계'		,type : 'uniQty'},
			{name: 'ASSIGNED_TIME_PER'         	,text:'1회할당'		,type : 'uniQty'}
		]
	});	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'gre200skrvService.selectList'/*,
			update: 'gre200skrvService.updateDetail',
			create: 'gre200skrvService.insertDetail',
			destroy: 'gre200skrvService.deleteDetail',
			syncAll: 'gre200skrvService.saveAll'*/
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
		title: '정비팀별집계',
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
			{dataIndex:'COMP_CODE'                ,width: 80,hidden:true},
			{dataIndex:'DIV_CODE'                 ,width: 110,hidden:true},
			{dataIndex:'MECHANIC_TEAM'       	  ,width: 110,hidden:true},
			{dataIndex:'MECHANIC_TEAM_NAME'  	  ,width: 90},
			{dataIndex:'MAINTAIN_PLACE'      	  ,width: 110,hidden:true},
			{dataIndex:'MAINTAIN_PLACE_NAME' 	  ,width: 80},
			{dataIndex:'MAINTAIN_COUNT'      	  ,width: 80},
			{dataIndex:'ASSIGNED_TIME'       	  ,width: 80},
			{dataIndex:'ASSIGNED_TIME_PER'   	  ,width: 80}
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
		id  : 'gre200skrApp',
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