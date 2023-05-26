<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//노무기간별 조회
request.setAttribute("PKGNAME","Unilite_app_gla100skrv");
%>
<t:appConfig pgmId="gla100skrv"  >
<t:ExtComboStore comboType="BOR120"/>								<!-- 사업장 -->
<t:ExtComboStore items="${ROUTE_COMBO}" storeId="routeStore" /> 	<!-- 노선 -->
<t:ExtComboStore comboType="AU" comboCode="GO31"/>					<!-- 접수방법 --> 
<t:ExtComboStore comboType="AU" comboCode="GO32"/>					<!-- 발생구분 --> 
<t:ExtComboStore comboType="AU" comboCode="GO34"/>					<!-- 처리결과 	--> 
</t:appConfig>
<script type="text/javascript">
function appMain() {
	Unilite.defineModel('${PKGNAME}Model', {
	
	    fields: [
			{name: 'COMP_CODE'            	,text:'법인코드'	,type : 'string'},
			{name: 'DIV_CODE'            	,text:'사업장'	,type : 'string',comboType:'BOR120'},
			{name: 'REGIST_DATE'            ,text:'접수일'	,type : 'uniDate'},
			{name: 'OFFENCE_DATE'           ,text:'발생일'	,type : 'string'},
			{name: 'OFFENCE_TIEM'           ,text:'발생시간'	,type : 'string'},
			{name: 'REGIST_GUBUN'           ,text:'접수방법(코드)'	,type : 'string'},
			{name: 'REGIST_GUBUN_NAME'      ,text:'접수방법'	,type : 'string'},
			{name: 'VEHICLE_CODE'           ,text:'차량코드'	,type : 'string'},
			{name: 'VEHICLE_REGIST_NO'      ,text:'차량번호'	,type : 'string'},
			{name: 'ROUTE_CODE'            	,text:'노선코드'	,type : 'string'},
			{name: 'ROUTE_NUM'            	,text:'노선번호'	,type : 'string'},
			{name: 'DRIVER_CODE'            ,text:'기사코드'	,type : 'string'},
			{name: 'NAME'            		,text:'기사명'	,type : 'string'},
			{name: 'PHONE_NO'            	,text:'연락처'	,type : 'string'},
			{name: 'OFFENCE_TYPE'           ,text:'발생구분(코드)'	,type : 'string'},
			{name: 'OFFENCE_TYPE_NAME'      ,text:'발생구분'	,type : 'string'},
			{name: 'PENALTY_POINT'          ,text:'점수'		,type : 'uniQty'},
			{name: 'PLACE_GUBUN'            ,text:'장소구분(코드)'	,type : 'string'},
			{name: 'PLACE_GUBUN_NAME'       ,text:'장소구분'	,type : 'string'},
			{name: 'PLACE'            		,text:'장소'		,type : 'string'},
			{name: 'RESULT'            		,text:'처리결과(코드)'	,type : 'string'},
			{name: 'RESULT_NAME'            ,text:'처리결과'	,type : 'string'},
			{name: 'FINE'            		,text:'과징금'	,type : 'uniPrice'},
			{name: 'BILL_NUMBER'           	,text:'고지서번호'	,type : 'string'},
			{name: 'RESULT_TEAM'           	,text:'팀'		,type : 'string'},
			{name: 'INSURANCE_YN'          	,text:'보험접수여부',type : 'string'},
			{name: 'JOIN_DATE'            	,text:'입사일'	,type : 'uniDate'},
			{name: 'RETR_DATE'            	,text:'퇴사일'	,type : 'uniDate'},
			{name: 'REMARK'            		,text:'비고'		,type : 'string'}
		]
	});	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'gla100skrvService.selectList'/*,
			update: 'gla100skrvService.updateDetail',
			create: 'gla100skrvService.insertDetail',
			destroy: 'gla100skrvService.deleteDetail',
			syncAll: 'gla100skrvService.saveAll'*/
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
			},
			groupField: 'OFFENCE_DATE'
		});
	
	var panelSearch = Unilite.createSearchPanel('${PKGNAME}SearchForm',{
		title: '노무기간별',
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
	        	fieldLabel: '접수일',
	        	xtype: 'uniDateRangefield',
	        	startFieldName: 'REGIST_DATE_FR',
	        	endFieldName:'REGIST_DATE_TO',
	        	width: 315,
/*	        	startDate: UniDate.get('startOfMonth'),
	        	endDate: UniDate.get('today'),*/
	        	onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('REGIST_DATE_FR',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('REGIST_DATE_TO',newValue);
			    	}
			    }
			},{
	        	fieldLabel: '발생일',
	        	xtype: 'uniDateRangefield',
	        	startFieldName: 'OFFENCE_DATE_FR',
	        	endFieldName:'OFFENCE_DATE_TO',
	        	width: 315,
	        	onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('OFFENCE_DATE_FR',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('OFFENCE_DATE_TO',newValue);
			    	}
			    }
			},{
				fieldLabel: '접수방법',
				name: 'REGIST_GUBUN',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'GO31',
				multiSelect: true, 
				width:305,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('REGIST_GUBUN', newValue);
					}
				}
			},{
				fieldLabel: '발생구분',
				name: 'OFFENCE_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'GO32',
				multiSelect: true, 
				width:305,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('OFFENCE_TYPE', newValue);
					}
				}
			},{
				fieldLabel: '처리결과',
				name: 'RESULT',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'GO34',
				multiSelect: true, 
				width:305,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('RESULT', newValue);
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
	        	fieldLabel: '접수일',
	        	xtype: 'uniDateRangefield',
	        	startFieldName: 'REGIST_DATE_FR',
	        	endFieldName:'REGIST_DATE_TO',
	        	width: 315,
	        	onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelSearch) {
						panelSearch.setValue('REGIST_DATE_FR',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('REGIST_DATE_TO',newValue);
			    	}
			    }
			},{
	        	fieldLabel: '발생일',
	        	xtype: 'uniDateRangefield',
	        	startFieldName: 'OFFENCE_DATE_FR',
	        	endFieldName:'OFFENCE_DATE_TO',
	        	onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelSearch) {
						panelSearch.setValue('OFFENCE_DATE_FR',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('OFFENCE_DATE_TO',newValue);
			    	}
			    }
			},{
				fieldLabel: '접수방법',
				name: 'REGIST_GUBUN',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'GO31',
				multiSelect: true, 
				width:315,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('REGIST_GUBUN', newValue);
					}
				}
			},{
				fieldLabel: '발생구분',
				name: 'OFFENCE_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'GO32',
				multiSelect: true, 
				width:315,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('OFFENCE_TYPE', newValue);
					}
				}
			},{
				fieldLabel: '처리결과',
				name: 'RESULT',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'GO34',
				multiSelect: true, 
				width:315,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('RESULT', newValue);
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
			{xtype: 'rownumberer'			  , width: 40, text:'NO',sortable: false},
			{dataIndex:'COMP_CODE'            ,width: 80,hidden:true},
			{dataIndex:'DIV_CODE'             ,width: 80},
			{dataIndex:'REGIST_DATE'          ,width: 80},
			{dataIndex:'OFFENCE_DATE'         ,width: 80,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
              		return Unilite.renderSummaryRow(summaryData, metaData, '합계', '총계');
                }
	         },
			{dataIndex:'OFFENCE_TIEM'         ,width: 60,align:'center'},
			{dataIndex:'REGIST_GUBUN'         ,width: 110,hidden:true},
			{dataIndex:'REGIST_GUBUN_NAME'    ,width: 80},
			{dataIndex:'VEHICLE_CODE'         ,width: 60,hidden:true},
			{dataIndex:'VEHICLE_REGIST_NO'    ,width: 100},
			{dataIndex:'ROUTE_CODE'           ,width: 60,hidden:true},
			{dataIndex:'ROUTE_NUM'            ,width: 60},
			{dataIndex:'DRIVER_CODE'          ,width: 80,hidden:true},
			{dataIndex:'NAME'            	  ,width: 80},
			{dataIndex:'PHONE_NO'             ,width: 100},
			{dataIndex:'OFFENCE_TYPE'         ,width: 110,hidden:true},
			{dataIndex:'OFFENCE_TYPE_NAME'    ,width: 110},
			{dataIndex:'PENALTY_POINT'        ,width: 50,summaryType: 'sum'},
			{dataIndex:'PLACE_GUBUN'          ,width: 110,hidden:true},
			{dataIndex:'PLACE_GUBUN_NAME'     ,width: 80},
			{dataIndex:'PLACE'            	  ,width: 80},
			{dataIndex:'RESULT'            	  ,width: 110,hidden:true},
			{dataIndex:'RESULT_NAME'          ,width: 80},
			{dataIndex:'FINE'            	  ,width: 80,summaryType: 'sum'},
			{dataIndex:'BILL_NUMBER'          ,width: 110},
			{dataIndex:'RESULT_TEAM'          ,width: 110},
			{dataIndex:'INSURANCE_YN'         ,width: 110}
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
		id  : 'gla100skrApp',
		autoButtonControl : false,
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['print'],false);
			UniAppManager.setToolbarButtons(['reset', 'excel' ],true);
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);/*
			panelSearch.setValue('REQUEST_DATE_FR',UniDate.get('startOfMonth'));
			panelSearch.setValue('REQUEST_DATE_TO',UniDate.get('today'));
			panelResult.setValue('REQUEST_DATE_FR',UniDate.get('startOfMonth'));
			panelResult.setValue('REQUEST_DATE_TO',UniDate.get('today'));*/
		},
		
		onQueryButtonDown : function()	{
			masterStore.loadStoreRecords();/*
			var viewLocked = masterGrid.lockedGrid.getView();
			var viewNormal = masterGrid.normalGrid.getView();
			console.log("viewLocked: ",viewLocked);
			console.log("viewNormal: ",viewNormal);
		    viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		    viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
		    viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		    viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);*/
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