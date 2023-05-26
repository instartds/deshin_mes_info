<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//노무기간별 조회
request.setAttribute("PKGNAME","Unilite_app_gac200skrv");
%>
<t:appConfig pgmId="gac200skrv"  >
<t:ExtComboStore comboType="BOR120"/>								<!-- 사업장 -->
<t:ExtComboStore items="${ROUTE_COMBO}" storeId="routeStore" /> 	<!-- 노선 -->
<t:ExtComboStore comboType="AU" comboCode="GA04"/>					<!-- 사고구분 	--> 
<t:ExtComboStore comboType="AU" comboCode="GO16"/>					<!-- 노선그룹 	--> 
</t:appConfig>
<script type="text/javascript">
function appMain() {
	Unilite.defineModel('${PKGNAME}Model', {
	
	    fields: [
			{name: 'COMP_CODE'            	,text:'법인코드'					,type : 'string'},
			{name: 'DIV_CODE'            	,text:'사업장'					,type : 'string',comboType:'BOR120'},
			{name: 'ROUTE_GROUP'            ,text:'노선그룹'					,type : 'string'},
			{name: 'ROUTE_GROUP_NAME'       ,text:'노선그룹'					,type : 'string'},

			{name: 'DRIVER_CODE'            ,text:'기사코드'					,type : 'string'},
			{name: 'NAME'            		,text:'기사명'					,type : 'string'},
			{name: 'EXPERIENCE_PERIOD'      ,text:'경력'						,type : 'string'},
			{name: 'JOIN_DATE'              ,text:'입사일'					,type : 'uniDate'},
			{name: 'RETR_DATE'          	,text:'퇴사일'					,type : 'uniDate'},
			{name: 'ACCIDENT_COUNT'         ,text:'사고건수'					,type : 'uniQty'},
			
			{name: 'P01'            		,text:'사망'						,type : 'uniQty'},
			{name: 'P02'            		,text:'중상'						,type : 'uniQty'},
			{name: 'P03'            		,text:'경상'						,type : 'uniQty'},
			{name: 'SUM_PERSON_CNT'      	,text:'합계'						,type : 'uniQty'},
			
			{name: 'PERSON_AMT'         	,text:'대인'						,type : 'uniPrice'},
			{name: 'SELF_COMPANY_PAYMENT'   ,text:'자차'						,type : 'uniPrice'},
			{name: 'TOTAL_PAYMENT'      	,text:'대물'						,type : 'uniPrice'},
			{name: 'TOTAL_EXPECT_AMOUNT'    ,text:'추산액'					,type : 'uniPrice'},
			{name: 'SUM_AMOUNT'         	,text:'합계'						,type : 'uniPrice'},
			{name: 'SELF_FAULT'           	,text:'자차과실율'					,type : 'uniPercent'},
			{name: 'SAFETY_INDEX'      		,text:'사고지수'					,type : 'uniQty'}
	
		]
	});	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'gac200skrvService.selectList'/*,
			update: 'gac200skrvService.updateDetail',
			create: 'gac200skrvService.insertDetail',
			destroy: 'gac200skrvService.deleteDetail',
			syncAll: 'gac200skrvService.saveAll'*/
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
		title: '개인별 사고통합 조회',
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
	        	allowBlank: false,
	        	xtype: 'uniDateRangefield',
	        	startFieldName: 'ACCIDENT_DATE_FR',
	        	endFieldName:'ACCIDENT_DATE_TO',
	        	width: 315,
	        	startDate: UniDate.get('startOfMonth'),
	        	endDate: UniDate.get('today'),
	        	onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('ACCIDENT_DATE_FR',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('ACCIDENT_DATE_TO',newValue);
			    	}
			    }
			},{
				fieldLabel: '사고구분', 
				name: 'ACCIDENT_DIV', 
				xtype: 'uniCombobox', 
				multiSelect: true, 
				comboType: 'AU',
				comboCode: 'GA04',
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ACCIDENT_DIV', newValue);
					}
				}
			},
			Unilite.popup('DRIVER',
		 	 	{
		 	 	fieldLabel:'기사',
		 		itemId:'driver',
		 		extParam:{'DIV_CODE': UserInfo.divCode},
		 		useLike:true,
		 		valueFieldName: 'DRIVER_CODE',
				textFieldName: 'DRIVER_NAME',
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
	 		)]				
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
	        	allowBlank: false,
	        	xtype: 'uniDateRangefield',
	        	startFieldName: 'ACCIDENT_DATE_FR',
	        	endFieldName:'ACCIDENT_DATE_TO',
	        	width: 315,
	        	startDate: UniDate.get('startOfMonth'),
	        	endDate: UniDate.get('today'),
	        	onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelSearch) {
						panelSearch.setValue('ACCIDENT_DATE_FR',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('ACCIDENT_DATE_TO',newValue);
			    	}
			    }
			},{
				fieldLabel: '사고구분', 
				name: 'ACCIDENT_DIV', 
				xtype: 'uniCombobox', 
				multiSelect: true, 
				comboType: 'AU',
				comboCode: 'GA04',
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('ACCIDENT_DIV', newValue);
					}
				}
			},
			Unilite.popup('DRIVER',
		 	 	{
		 	 	fieldLabel:'기사',
		 		itemId:'driver',
		 		extParam:{'DIV_CODE': UserInfo.divCode},
		 		useLike:true,
		 		valueFieldName: 'DRIVER_CODE',
				textFieldName: 'DRIVER_NAME',
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
	 	)],
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
		uniOpt: {
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
        },
    	/*uniOpt:{
			useRowNumberer: false,
        	expandLastColumn: false,
            useMultipleSorting: false,
            filter: {
				useFilter: false,
				autoCreate: false
			}
        },*/
        features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true},
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: true} ],
    	store: masterStore, 
		columns:[
			{xtype: 'rownumberer'		   			 	 ,width: 40, text:'NO',sortable: false},
			{dataIndex:'COMP_CODE'         				 ,width: 60  ,hidden:true},
			{dataIndex:'DIV_CODE'            	         ,width: 60  ,hidden:true},
			{dataIndex:'ROUTE_GROUP'                     ,width: 66  , hidden: true},
			{dataIndex:'ROUTE_GROUP_NAME'                ,width: 60  ,
			summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '', '합계');
            }},
			{dataIndex:'DRIVER_CODE'                     ,width: 60  },
			{dataIndex:'NAME'            		         ,width: 66  },
			{dataIndex:'JOIN_DATE'                       ,width: 88  },
			{dataIndex:'RETR_DATE'                   ,width: 88  },
			{dataIndex:'ACCIDENT_COUNT'               ,width: 66  , summaryType: 'sum'},
			{ 
	         	text:'인적집계',
	         		columns: [
			         	{dataIndex:'P01'            	,width: 50  , summaryType: 'sum'},
						{dataIndex:'P02'            	,width: 50  , summaryType: 'sum'},
						{dataIndex:'P03'            	,width: 50  , summaryType: 'sum'},
						{dataIndex:'SUM_PERSON_CNT'     ,width: 60  , summaryType: 'sum'}
		         	]
			},
			{ 
	         	text:'금액집계',
	         		columns: [
			         	{dataIndex:'PERSON_AMT'         	,width: 88  , summaryType: 'sum'},
						{dataIndex:'SELF_COMPANY_PAYMENT'   ,width: 88  , summaryType: 'sum'},
						{dataIndex:'TOTAL_PAYMENT'      	,width: 88  , summaryType: 'sum'},
						{dataIndex:'TOTAL_EXPECT_AMOUNT'    ,width: 88  , summaryType: 'sum'},
						{dataIndex:'SUM_AMOUNT'         	,width: 100 , summaryType: 'sum'}
		         	]
			},
			{dataIndex:'SELF_FAULT'           	         ,width: 88  ,hidden:true, summaryType: 'average',
			renderer : function(val) {
                    if (val > 0) {
                        return val + '%';
                    } else if (val < 0) {
                        return val + '%';
                    }
                    return val;
                },
            summaryRenderer: function(val){
            		return 
            	}
			},
			{dataIndex:'SAFETY_INDEX'      		         ,width: 60  , summaryType: 'sum'}
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
		id  : 'gac200skrApp',
		autoButtonControl : false,
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['print'],false);
			UniAppManager.setToolbarButtons(['reset', 'excel' ],true);
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('ACCIDENT_DATE_FR',UniDate.get('startOfMonth'));
			panelSearch.setValue('ACCIDENT_DATE_TO',UniDate.get('today'));
			panelResult.setValue('ACCIDENT_DATE_FR',UniDate.get('startOfMonth'));
			panelResult.setValue('ACCIDENT_DATE_TO',UniDate.get('today'));
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