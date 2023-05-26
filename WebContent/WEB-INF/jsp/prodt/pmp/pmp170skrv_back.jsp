<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="pmp170skrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="pmp170skrv" /> 			<!-- 사업장 -->  
	<t:ExtComboStore items="${COMBO_WS_LIST}" storeId="wsList" /> <!-- 작업장 -->  
	<t:ExtComboStore comboType="AU" comboCode="P001"  /> <!-- 상태 --> 
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
	Unilite.defineModel('Pmp170skrvModel', {
	    fields: [
	    	{name: 'WORK_END_YN'     	, text: '<t:message code="system.label.product.status" default="상태"/>'		, type: 'string' , comboType:'AU', comboCode:'P001'},
	    	{name: 'PROG_WORK_CODE'  	, text: '<t:message code="system.label.product.routingcode" default="공정코드"/>'		, type: 'string'},
	    	{name: 'PROG_WORK_NAME'  	, text: '<t:message code="system.label.product.routingname" default="공정명"/>'		, type: 'string'},
			{name: 'WKORD_NUM'       	, text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'  , type: 'string'},
			{name: 'ITEM_CODE'       	, text: '<t:message code="system.label.product.item" default="품목"/>'		, type: 'string'},
			{name: 'ITEM_NAME'       	, text: '<t:message code="system.label.product.itemname" default="품목명"/>'		, type: 'string'},
			{name: 'SPEC'            	, text: '<t:message code="system.label.product.spec" default="규격"/>'		, type: 'string'},
			{name: 'STOCK_UNIT'      	, text: '<t:message code="system.label.product.unit" default="단위"/>'		, type: 'string'},
			{name: 'PRODT_START_DATE'	, text: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>'	, type: 'uniDate'},
			{name: 'PRODT_END_DATE'  	, text: '<t:message code="system.label.product.completiondate" default="완료예정일"/>'	, type: 'uniDate'},
			{name: 'WKORD_Q'         	, text: '<t:message code="system.label.product.workorderqty" default="작업지시량"/>'		, type: 'uniQty'},
			{name: 'PRODT_Q'         	, text: '<t:message code="system.label.product.productionqty" default="생산량"/>'		, type: 'uniQty'},
			{name: 'REMARK1'         	, text: '<t:message code="system.label.product.remarks" default="비고"/>'		, type: 'string'},
			{name: 'PROJECT_NO'      	, text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'		, type: 'string'},
			{name: 'PJT_CODE'        	, text: '<t:message code="system.label.product.projectcode" default="프로젝트코드"/>'	, type: 'string'},
			{name: 'ORDER_NUM'       	, text: '<t:message code="system.label.product.sono" default="수주번호"/>'		, type: 'string'},
			{name: 'ORDER_Q'         	, text: '<t:message code="system.label.product.soqty" default="수주량"/>'		, type: 'uniQty'},
			{name: 'DVRY_DATE'       	, text: '<t:message code="system.label.product.deliverydate" default="납기일"/>'		, type: 'uniDate'},
			{name: 'LOT_NO'          	, text: '<t:message code="system.label.product.lotno" default="LOT번호"/>'		, type: 'string'},
			{name: 'REMARK2'         	, text: '<t:message code="system.label.product.customname" default="거래처명"/>'		, type: 'string'},
			{name: 'WORK_SHOP_CODE'  	, text: '<t:message code="system.label.product.workcenter" default="작업장"/>'		, type: 'string'},
			{name: 'WORK_SHOP_NAME'  	, text: '<t:message code="system.label.product.workcentername" default="작업장명"/>'		, type: 'string'}		
		] 
	});	
	
	function dateToString(v, record){
		return UniDate.safeFormat(v);
	}
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'pmp170skrvService.selectList'
		}
	});
	
	/**
	 * Master Store 정의(Service 정의)
	 * @type 
	 */					
	var MasterStore = Unilite.createStore('pmp170skrvMasterStore', {
		model: 'Pmp170skrvModel',
		autoLoad: false,
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결
			editable: false,			// 수정 모드 사용
			deletable: false,		// 삭제 가능 여부
			useNavi : false			// prev | next 버튼 사용
		},
		proxy: directProxy,
		loadStoreRecords: function() {
			var param= panelSearch.getValues();			
			console.log(param);
			this.load({
				params : param
			});
			
		},
		groupField: 'PROG_WORK_NAME'
	});
	
	
	
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '<t:message code="system.label.product.searchconditon" default="검색조건"/>',
        defaultType: 'uniSearchSubPanel',
        collapsed: UserInfo.appOption.collapseLeftSearch,
        listeners: {
	        collapse: function () {
	            topSearch.show();
	        },
	        expand: function() {
	        	topSearch.hide();
	        }
        },
		items: [{	
			title: '<t:message code="system.label.product.basisinfo" default="기본정보"/>', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{
        		fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
        		name: 'DIV_CODE',
        		value : UserInfo.divCode,
        		xtype: 'uniCombobox',
        		comboType: 'BOR120',
        		allowBlank: false,
        		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						topSearch.setValue('DIV_CODE', newValue);
					}
        		}
			},{
	        	fieldLabel: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>',
	        	xtype: 'uniDateRangefield',
	        	startFieldName: 'PRODT_START_DATE_FR',
	        	endFieldName: 'PRODT_START_DATE_TO',
	        	width: 315,
	        	startDate: UniDate.get('mondayOfWeek'),
	        	endDate: UniDate.get('sundayOfNextWeek'),
	        	onStartDateChange: function(field, newValue, oldValue, eOpts) {
	                	if(topSearch) {
							topSearch.setValue('PRODT_START_DATE_FR',newValue);
							//topSearch.getField('ISSUE_REQ_DATE_FR').validate();
							
	                	}
				    },
				    onEndDateChange: function(field, newValue, oldValue, eOpts) {
				    	if(topSearch) {
				    		topSearch.setValue('PRODT_START_DATE_TO',newValue);
				    		//topSearch.getField('ISSUE_REQ_DATE_TO').validate();				    		
				    	}
				    }
			},{
			    xtype: 'container',
				layout: {type : 'uniTable', columns : 3},
				width:285,
				items :[{
					fieldLabel:'<t:message code="system.label.product.lotno" default="LOT번호"/>', 
					xtype: 'uniTextfield',
					name: 'LOT_NO_FR',
					width:175,
						listeners: {
						change: function(field, newValue, oldValue, eOpts) {      
							topSearch.setValue('LOT_NO_FR', newValue);
						}
					}
				},{
					xtype:'component', 
					html:'~',
					style: {
						marginTop: '3px !important',
						font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
					}
				},{
					fieldLabel:'', 
					xtype: 'uniTextfield',
					name: 'LOT_NO_TO', 
					width: 85,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {      
							topSearch.setValue('LOT_NO_TO', newValue);
						}
					}
				}]
			},{
				fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
				name: 'WORK_SHOP_CODE',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('wsList'),allowBlank:false,
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							topSearch.setValue('WORK_SHOP_CODE', newValue);
						}
					}
			},
				Unilite.popup('DIV_PUMOK',{ 
					fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
	        		listeners: {
						onSelected: {
							fn: function(records, type) {
								topSearch.setValue('ITEM_CODE', panelSearch.getValue('ITEM_CODE'));
								topSearch.setValue('ITEM_NAME', panelSearch.getValue('ITEM_NAME'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							topSearch.setValue('ITEM_CODE', '');
							topSearch.setValue('ITEM_NAME', '');
						}
					}
			}),
				Unilite.popup('PROG_WORK_CODE',{ 
					fieldLabel: '<t:message code="system.label.product.routingcode" default="공정코드"/>', 
	        		listeners: {
						onSelected: {
							fn: function(records, type) {
								topSearch.setValue('PROG_WORK_CODE', panelSearch.getValue('PROG_WORK_CODE'));
								topSearch.setValue('PROG_WORK_NAME', panelSearch.getValue('PROG_WORK_NAME'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							topSearch.setValue('PROG_WORK_CODE', '');
							topSearch.setValue('PROG_WORK_NAME', '');
						},
						applyextparam: function(popup){
							//if(panelSearch.getValue('WORK_SHOP_CODE') != null){
							if(!Ext.isEmpty(panelSearch.getValue('WORK_SHOP_CODE'))){	
								
									popup.setExtParam({'DIV_CODE'		: panelSearch.getValue('DIV_CODE')});
									popup.setExtParam({'WORK_SHOP_CODE' : panelSearch.getValue('WORK_SHOP_CODE')
								});
							}else{
								UniAppManager.app.checkForNewDetail();
								panelSearch.getField('WORK_SHOP_CODE').focus();
								
								return false;
							}
						}
					}
			}),{
			    xtype: 'container',
				layout: {type : 'uniTable', columns : 3},
				width:285,
				items :[{
					fieldLabel:'<t:message code="system.label.product.workorderno" default="작업지시번호"/>', 
					xtype: 'uniTextfield',
					name: 'WKORD_NUM_FR',
					width:175,
						listeners: {
						change: function(field, newValue, oldValue, eOpts) {      
							topSearch.setValue('WKORD_NUM_FR', newValue);
						}
					}
				},{
					xtype:'component', 
					html:'~',
					style: {
						marginTop: '3px !important',
						font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
					}
				},{
					fieldLabel:'', 
					xtype: 'uniTextfield',
					name: 'WKORD_NUM_TO', 
					width: 85,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {      
							topSearch.setValue('WKORD_NUM_TO', newValue);
						}
					}
				}]
			},{	
				xtype: 'radiogroup',		            		
				fieldLabel: '   ',						            		
				labelWidth:90,
				items: [{
					boxLabel: '<t:message code="system.label.product.whole" default="전체"/>',
					width: 60,
					name: 'WORK_END_YN',
					inputValue: '',
					checked: true
				},{
					boxLabel: '<t:message code="system.label.product.process" default="진행"/>',
					width: 60,
					name: 'WORK_END_YN' ,
					inputValue: 'N'
				},{
					boxLabel: '<t:message code="system.label.product.completion" default="완료"/>',
					width: 60,
					name: 'WORK_END_YN' ,
					inputValue: 'Y'
				},{
					boxLabel: '<t:message code="system.label.product.closing" default="마감"/>',
					width: 60,
					name: 'WORK_END_YN' ,
					inputValue: 'F'
				}],
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							//topSearch.getField('SALE_YN').setValue({SALE_YN: newValue});
							topSearch.getField('WORK_END_YN').setValue(newValue.WORK_END_YN);
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
	   						var labelText = invalid.items[0]['fieldLabel']+' : ';
	   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
	   						var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
	   					}
					   	alert(labelText+Msg.sMB083);
					   	invalid.items[0].focus();
					} else {
					//	this.mask();		    
	   				}
		  		} else {
  					this.unmask();
  				}
				return r;
  			}
	}); //End of var panelSearch = Unilite.createForm('pmp110ukrvpanelSearch', {
	
	var topSearch = Unilite.createSearchForm('topSearchForm', {
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
	    	items: [{
        		fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
        		name: 'DIV_CODE',
        		value : UserInfo.divCode,
        		xtype: 'uniCombobox',
        		comboType: 'BOR120',
        		allowBlank: false,
        		colspan:3,
        		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('DIV_CODE', newValue);
					}
        		}
			},{
	        	fieldLabel: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>',
	        	xtype: 'uniDateRangefield',
	        	startFieldName: 'PRODT_START_DATE_FR',
	        	endFieldName: 'PRODT_START_DATE_TO',
	        	width: 315,
	        	startDate: UniDate.get('mondayOfWeek'),
	        	endDate: UniDate.get('sundayOfNextWeek'),
	        	onStartDateChange: function(field, newValue, oldValue, eOpts) {
	            	if(panelSearch) {
						panelSearch.setValue('PRODT_START_DATE_FR',newValue);
						//panelSearch.getField('ISSUE_REQ_DATE_FR').validate();
						
	            	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('PRODT_START_DATE_TO',newValue);
			    		//panelSearch.getField('ISSUE_REQ_DATE_TO').validate();				    		
			    	}
			    }
			},{
			    xtype: 'container',
				layout: {type : 'uniTable', columns : 3},
				width:285,
				items :[{
					fieldLabel:'<t:message code="system.label.product.lotno" default="LOT번호"/>', 
					xtype: 'uniTextfield',
					name: 'LOT_NO_FR',
					width:175,
						listeners: {
						change: function(field, newValue, oldValue, eOpts) {      
							panelSearch.setValue('LOT_NO_FR', newValue);
						}
					}
				},{
					xtype:'component', 
					html:'~',
					style: {
						marginTop: '3px !important',
						font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
					}
				},{
					fieldLabel:'', 
					xtype: 'uniTextfield',
					name: 'LOT_NO_TO', 
					width: 85,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {      
							panelSearch.setValue('LOT_NO_TO', newValue);
						}
					}
				}]
			},{
				fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
				name: 'WORK_SHOP_CODE',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('wsList'),allowBlank:false,
				listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('WORK_SHOP_CODE', newValue);
					}
				}
			},
				Unilite.popup('DIV_PUMOK',{ 
					fieldLabel: '<t:message code="system.label.product.item" default="품목"/>', 
					validateBlank:false,
					colspan:2,
	        		listeners: {
						onSelected: {
							fn: function(records, type) {
								panelSearch.setValue('ITEM_CODE', topSearch.getValue('ITEM_CODE'));
								panelSearch.setValue('ITEM_NAME', topSearch.getValue('ITEM_NAME'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelSearch.setValue('ITEM_CODE', '');
							panelSearch.setValue('ITEM_NAME', '');
						}
					}
			}),
				Unilite.popup('PROG_WORK_CODE',{ 
					fieldLabel: '<t:message code="system.label.product.routingcode" default="공정코드"/>', 
	        		listeners: {
						onSelected: {
							fn: function(records, type) {
								panelSearch.setValue('PROG_WORK_CODE', topSearch.getValue('PROG_WORK_CODE'));
								panelSearch.setValue('PROG_WORK_NAME', topSearch.getValue('PROG_WORK_NAME'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelSearch.setValue('PROG_WORK_CODE', '');
							panelSearch.setValue('PROG_WORK_NAME', '');
						},
						applyextparam: function(popup){
							//if(panelSearch.getValue('WORK_SHOP_CODE') != null){
							if(!Ext.isEmpty(panelSearch.getValue('WORK_SHOP_CODE'))){		
								
									popup.setExtParam({'DIV_CODE'		: topSearch.getValue('DIV_CODE')});
									popup.setExtParam({'WORK_SHOP_CODE' : topSearch.getValue('WORK_SHOP_CODE')
								});
							}else{
								UniAppManager.app.checkForNewDetail();					
								topSearch.getField('WORK_SHOP_CODE').focus();
								
								return false;
							}
						}
					}
			}),{
			    xtype: 'container',
				layout: {type : 'uniTable', columns : 3},
				width:285,
				items :[{
					fieldLabel:'<t:message code="system.label.product.workorderno" default="작업지시번호"/>', 
					xtype: 'uniTextfield',
					name: 'WKORD_NUM_FR',
					width:175,
						listeners: {
						change: function(field, newValue, oldValue, eOpts) {      
							panelSearch.setValue('WKORD_NUM_FR', newValue);
						}
					}
				},{
					xtype:'component', 
					html:'~',
					style: {
						marginTop: '3px !important',
						font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
					}
				},{
					fieldLabel:'', 
					xtype: 'uniTextfield',
					name: 'WKORD_NUM_TO', 
					width: 85,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {      
							panelSearch.setValue('WKORD_NUM_TO', newValue);
						}
					}
				}]
			},{	
				xtype: 'radiogroup',		            		
				fieldLabel: '   ',						            		
				labelWidth:90,
				items: [{
					boxLabel: '<t:message code="system.label.product.whole" default="전체"/>',
					width: 60,
					name: 'WORK_END_YN',
					inputValue: '',
					checked: true
				},{
					boxLabel: '<t:message code="system.label.product.process" default="진행"/>',
					width: 60,
					name: 'WORK_END_YN' ,
					inputValue: 'N'
				},{
					boxLabel: '<t:message code="system.label.product.completion" default="완료"/>',
					width: 60,
					name: 'WORK_END_YN' ,
					inputValue: 'Y'
				},{
					boxLabel: '<t:message code="system.label.product.closing" default="마감"/>',
					width: 60,
					name: 'WORK_END_YN' ,
					inputValue: 'F'
				}],
				listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					//panelSearch.getField('SALE_YN').setValue({SALE_YN: newValue});
					panelSearch.getField('WORK_END_YN').setValue(newValue.WORK_END_YN);
					}
				}
			}]
	});
	
	
	
	
    /**
     * Master Grid 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('pmp170skrvGrid', {
    	layout: 'fit',
        region:'center',
        uniOpt: {
			expandLastColumn: true,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
    		useGroupSummary: false,
			useRowNumberer: false,
			filter: {
				useFilter: false,
				autoCreate: false
			}
        },
    	store: MasterStore,
        columns: [        
			{dataIndex: 'WORK_END_YN'     	, width: 40		, locked: true}, 	  			
			{dataIndex: 'PROG_WORK_CODE'  	, width: 70		, locked: true}, 	  			
			{dataIndex: 'PROG_WORK_NAME'  	, width: 100	, locked: true}, 	  			
			{dataIndex: 'WKORD_NUM'       	, width: 93		, locked: true}, 	  			
			{dataIndex: 'ITEM_CODE'       	, width: 100	, locked: true}, 	  			
			{dataIndex: 'ITEM_NAME'       	, width: 146	, locked: true}, 	  
			{dataIndex: 'SPEC'            	, width: 100 	}, 	  			
			{dataIndex: 'STOCK_UNIT'      	, width: 40 	}, 
			{dataIndex: 'PRODT_START_DATE'	, width: 73 	}, 	  			
			{dataIndex: 'PRODT_END_DATE'  	, width: 73 	}, 
			{dataIndex: 'WKORD_Q'         	, width: 73},	  			
			{dataIndex: 'PRODT_Q'        	, width: 73}, 
			{dataIndex: 'REMARK1'        	, width: 100},		
			{dataIndex: 'PROJECT_NO'     	, width: 100}, 	  			
			{dataIndex: 'PJT_CODE'       	, width: 100	,hidden: true}, 	  			
			{dataIndex: 'ORDER_NUM'      	, width: 86}, 	  			
			{dataIndex: 'ORDER_Q'         	, width: 66}, 	  			
			{dataIndex: 'DVRY_DATE'       	, width: 66}, 	  			
			{dataIndex: 'LOT_NO'          	, width: 100}, 	  			
			{dataIndex: 'REMARK2'         	, width: 66		,hidden: true}, 	  			
			{dataIndex: 'WORK_SHOP_CODE'  	, width: 66}, 	  			
			{dataIndex: 'WORK_SHOP_NAME'  	, width: 66}
		]
    });
    
   
	

    
    
   /**
	 * main app
	 */

		
	Unilite.Main ({
		borderItems: [{
         	region:'center',
         	layout: 'border',
         	border: false,
         	items:[
           		topSearch, masterGrid
         	]	
      	},
      	panelSearch     
      	],	
		id: 'pmp170skrvApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons(['reset','detail', 'save'], false);
			
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			topSearch.setValue('DIV_CODE', UserInfo.divCode);
			
			panelSearch.setValue('PRODT_START_DATE_FR', UniDate.get('mondayOfWeek'));
			topSearch.setValue('PRODT_START_DATE_FR', UniDate.get('mondayOfWeek'));
			
			panelSearch.setValue('PRODT_START_DATE_TO', UniDate.get('sundayOfNextWeek'));
			topSearch.setValue('PRODT_START_DATE_TO', UniDate.get('sundayOfNextWeek'));
			
		},
		onQueryButtonDown: function() {
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
				masterGrid.getStore().loadStoreRecords();
				UniAppManager.setToolbarButtons('reset', true); 
			}
		},
		onResetButtonDown: function() {
			this.suspendEvents();
			panelSearch.reset();
			masterGrid.reset();
			topSearch.reset();
			
			MasterStore.clearData();
			this.fnInitBinding();
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		},
		checkForNewDetail:function() { 
			return panelSearch.setAllFieldsReadOnly(true);
        }
	});
	
			
};
</script>