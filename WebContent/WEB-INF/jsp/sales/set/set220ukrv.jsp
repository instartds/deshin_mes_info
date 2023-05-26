<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="set220ukrv"  >
<t:ExtComboStore comboType="AU" comboCode="S065"/>	          <!-- 주문 구분 -->
<t:ExtComboStore comboType="BOR120" pgmId="set220ukrv" />     <!-- 사업장 -->
<t:ExtComboStore comboType="OU" />   <!-- 창고   -->
</t:appConfig>
<script type="text/javascript" >

var CustomCodeInfo = {
	csPricePrecision:UniFormat.Price?UniFormat.Price.length - (UniFormat.Price.indexOf(".") != -1?UniFormat.Price.indexOf(".") + 1:UniFormat.Price.length -2):2,
	csQtyPrecision:UniFormat.Qty?UniFormat.Qty.length - (UniFormat.Qty.indexOf(".") != -1?UniFormat.Qty.indexOf(".") + 1:UniFormat.Qty.length -2):2
};

function appMain() {
	var outDivCode = UserInfo.divCode;
	var masterSelectedGrid = 'set220ukrvGrid';  // Grid1 createRow Default
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read    : 'set220ukrvService.selectMaster',
			update  : 'set220ukrvService.updateDetail',
			create  : 'set220ukrvService.insertDetail',
			destroy : 'set220ukrvService.deleteDetail',
			syncAll : 'set220ukrvService.saveAll'
		}
	});
	
	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read    : 'set220ukrvService.selectMaster2',
			update  : 'set220ukrvService.updateDetail2',
			create  : 'set220ukrvService.insertDetail2',
			destroy : 'set220ukrvService.deleteDetail2',
			syncAll : 'set220ukrvService.saveAll'
		}
	});

	Unilite.defineModel('set220ukrvModel', {
	    fields: [{name: 'CHOICE'		    ,text:'<t:message code="system.label.sales.selection" default="선택"/>'			,type: 'string'},				 
				 {name: 'INOUT_DATE'		,text:'<t:message code="system.label.sales.resultsdate" default="실적일"/>'		,type: 'uniDate'},				 
				 {name: 'SER_NO'	    	,text:'<t:message code="system.label.sales.seq" default="순번"/>'			,type: 'int'},				 
				 {name: 'P_ITEM_CODE'    	,text:'<t:message code="system.label.sales.setitem" default="SET품목"/>'			,type: 'string'},				 
				 {name: 'P_ITEM_NAME'		,text:'<t:message code="system.label.sales.setitemname" default="SET품목명"/>'		,type: 'string' , defaultValue:0},				 
				 {name: 'P_INOUT_Q'		    ,text:'<t:message code="system.label.sales.mfgqty" default="제작수량"/>'		,type: 'uniQty'},				 
				 {name: 'P_INOUT_P'			,text:'<t:message code="system.label.sales.mfgprice" default="제작단가"/>'		,type: 'uniUnitPrice'},				 
				 {name: 'P_INOUT_I'	    	,text:'<t:message code="system.label.sales.mfgamount" default="제작금액"/>'		,type: 'uniPrice'},				 
				 {name: 'MAKER_TYPE'	    ,text:'<t:message code="system.label.sales.mfgclass" default="제작구분"/>'		,type: 'string'},
				 {name: 'C_ITEM_CODE'	    ,text:'<t:message code="system.label.sales.compitemcode" default="구성품목"/>'		,type: 'string'},
				 {name: 'C_ITEM_NAME'	    ,text:'<t:message code="system.label.sales.compitemname" default="구성품목명"/>'		,type: 'string'},
				 {name: 'WH_NAME'	    	,text:'<t:message code="system.label.sales.issuewarehouse" default="출고창고"/>'		,type: 'string'},
				 {name: 'WH_CELL_NAME'	    ,text:'<t:message code="system.label.sales.issuewarehousecell" default="출고창고Cell"/>'	,type: 'string'},
				 {name: 'C_INOUT_Q'	    	,text:'<t:message code="system.label.sales.compqty" default="구성수량"/>'		,type: 'uniQty'},
				 {name: 'C_INOUT_P'	    	,text:'<t:message code="system.label.sales.compprice" default="구성단가"/>'		,type: 'uniUnitPrice'},
				 {name: 'C_INOUT_I'	    	,text:'<t:message code="system.label.sales.compamount" default="구성금액"/>'		,type: 'uniPrice'},
				 {name: 'COMP_CODE'	    	,text:'UPDATE_DB_TIME'	,type: 'string'},//
				 {name: 'DIV_CODE'	    	,text:'UPDATE_DB_TIME'	,type: 'string'},//
				 {name: 'P_INOUT_NUM'	    ,text:'P_INOUT_NUM'		,type: 'string'},//
				 {name: 'P_INOUT_SEQ'	    ,text:'P_INOUT_SEQ'		,type: 'int'},//
				 {name: 'P_INOUT_TYPE'	    ,text:'P_INOUT_TYPE'	,type: 'string'},//
				 {name: 'P_ITEM_STATUS'	    ,text:'P_ITEM_STATUS'	,type: 'string'},//
				 {name: 'P_WH_CODE'	    	,text:'P_WH_CODE'		,type: 'string'},//
				 {name: 'P_WH_CELL_CODE'	,text:'P_WH_CELL_CODE'	,type: 'string'},//
				 {name: 'P_LOT_NO'	    	,text:'P_LOT_NO'		,type: 'string'},//
				 {name: 'C_INOUT_NUM'	    ,text:'C_INOUT_NUM'		,type: 'string'},//
				 {name: 'C_INOUT_SEQ'	    ,text:'C_INOUT_SEQ'		,type: 'int'},//
				 {name: 'C_INOUT_TYPE'	    ,text:'C_INOUT_TYPE'	,type: 'string'},//
				 {name: 'C_ITEM_STATUS'	    ,text:'C_ITEM_STATUS'	,type: 'string'},//
				 {name: 'C_WH_CODE'	    	,text:'C_WH_CODE'		,type: 'string'},//
				 {name: 'C_WH_CELL_CODE'	,text:'C_WH_CELL_CODE'	,type: 'string'},//
				 {name: 'C_LOT_NO'	    	,text:'C_LOT_NO'		,type: 'string'}//
			]
	});
	
	Unilite.defineModel('set220ukrvModel2', {
	    fields: [{name: 'CHOICE'		    ,text:'<t:message code="system.label.sales.selection" default="선택"/>'			,type: 'string'},				 
				 {name: 'INOUT_DATE'		,text:'<t:message code="system.label.sales.resultsdate" default="실적일"/>'		,type: 'uniDate'},				 
				 {name: 'SER_NO'	    	,text:'<t:message code="system.label.sales.seq" default="순번"/>'			,type: 'int'},				 
				 {name: 'P_ITEM_CODE'    	,text:'<t:message code="system.label.sales.setitemdisassemblyitem" default="SET품목분해품목"/>'		,type: 'string'},				 
				 {name: 'P_ITEM_NAME'		,text:'<t:message code="system.label.sales.setitemdisassemblyitemname" default="SET품목분해품목명"/>'	,type: 'string' , defaultValue:0},				 
				 {name: 'P_INOUT_Q'		    ,text:'<t:message code="system.label.sales.disassemblyqty" default="분해량"/>'		,type: 'uniQty'},				 
				 {name: 'P_INOUT_P'			,text:'<t:message code="system.label.sales.disassemblyprice" default="분해단가"/>'		,type: 'uniUnitPrice'},				 
				 {name: 'P_INOUT_I'	    	,text:'<t:message code="system.label.sales.disassemblyamount" default="분해금액"/>'		,type: 'uniPrice'},				 
				 {name: 'MAKER_TYPE'	    ,text:'<t:message code="system.label.sales.mfgclass" default="제작구분"/>'		,type: 'string'},
				 {name: 'C_ITEM_CODE'	    ,text:'<t:message code="system.label.sales.compitemcode" default="구성품목"/>'		,type: 'string'},
				 {name: 'C_ITEM_NAME'	    ,text:'<t:message code="system.label.sales.compitemname" default="구성품목명"/>'		,type: 'string'},
				 {name: 'WH_NAME'	    	,text:'<t:message code="system.label.sales.receiptwarehouse" default="입고창고"/>'		,type: 'string'},
				 {name: 'WH_CELL_NAME'	    ,text:'<t:message code="system.label.sales.receiptwarehousecell" default="입고창고Cell"/>'	,type: 'string'},
				 {name: 'C_INOUT_Q'	    	,text:'<t:message code="system.label.sales.compqty" default="구성수량"/>'		,type: 'uniQty'},
				 {name: 'C_INOUT_P'	    	,text:'<t:message code="system.label.sales.compprice" default="구성단가"/>'		,type: 'uniUnitPrice'},
				 {name: 'C_INOUT_I'	    	,text:'<t:message code="system.label.sales.compamount" default="구성금액"/>'		,type: 'uniPrice'},
				 {name: 'COMP_CODE'	    	,text:'COMP_CODE'		,type: 'string'},//
				 {name: 'DIV_CODE'	    	,text:'DIV_CODE'		,type: 'string'},//
				 {name: 'P_INOUT_NUM'	    ,text:'P_INOUT_NUM'		,type: 'string'},//
				 {name: 'P_INOUT_SEQ'	    ,text:'P_INOUT_SEQ'		,type: 'int'},//
				 {name: 'P_INOUT_TYPE'	    ,text:'P_INOUT_TYPE'	,type: 'string'},//
				 {name: 'P_ITEM_STATUS'	    ,text:'P_ITEM_STATUS'	,type: 'string'},//
				 {name: 'P_WH_CODE'	    	,text:'P_WH_CODE'		,type: 'string'},//
				 {name: 'P_WH_CELL_CODE'	,text:'P_WH_CELL_CODE'	,type: 'string'},//
				 {name: 'P_LOT_NO'	    	,text:'P_LOT_NO'		,type: 'string'},//
				 {name: 'C_INOUT_NUM'	    ,text:'C_INOUT_NUM'		,type: 'string'},//
				 {name: 'C_INOUT_SEQ'	    ,text:'C_INOUT_SEQ'		,type: 'int'},//
				 {name: 'C_INOUT_TYPE'	    ,text:'C_INOUT_TYPE'	,type: 'string'},//
				 {name: 'C_ITEM_STATUS'	    ,text:'C_ITEM_STATUS'	,type: 'string'},//
				 {name: 'C_WH_CODE'	    	,text:'C_WH_CODE'		,type: 'string'},//
				 {name: 'C_WH_CELL_CODE'	,text:'C_WH_CELL_CODE'	,type: 'string'},//
				 {name: 'C_LOT_NO'	    	,text:'C_LOT_NO'		,type: 'string'}//
			]
	});

	var MasterStore = Unilite.createStore('set220ukrvMasterStore',{
		model: 'set220ukrvModel',
		uniOpt : {
        	isMaster : true,			// 상위 버튼 연결 
        	editable : true,			// 수정 모드 사용 
        	deletable: false,		// 삭제 가능 여부 
            useNavi  : false			// prev | next 버튼 사용
        },
        autoLoad  : false,
        proxy     : directProxy,
		loadStoreRecords: function(){
			var param= Ext.getCmp('searchForm').getValues();
			this.load({
				params: param
			});
		},
       	saveStore : function(){
       		//1. 마스터 정보 파라미터 구성
			var paramMaster = panelResult.getValues();	//syncAll 수정
			var inValidRecs = this.getInvalidRecords();
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						panelResult.getForm().wasDirty = false;
						panelSearch.getForm().wasDirty = false;
						panelResult.resetDirtyStatus();
						panelSearch.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);
						UniAppManager.app.onQueryButtonDown();
					}
				};
				this.syncAllDirect(config);
			} else {
                Ext.getCmp('set220ukrvGrid').uniSelectInvalidColumnAndAlert(inValidRecs);
			}
       	},
		groupField:'SER_NO'
	});
	
	var MasterStore2 = Unilite.createStore('set220ukrvMasterStore',{
		model: 'set220ukrvModel2',
		uniOpt : {
        	isMaster: true,			// 상위 버튼 연결 
        	editable: true,			// 수정 모드 사용 
        	deletable: false,		// 삭제 가능 여부 
            useNavi: false			// prev | next 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy2,
		loadStoreRecords: function(){
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params: param
			});
		},
       	saveStore : function(){
       		//1. 마스터 정보 파라미터 구성
			var paramMaster = panelResult.getValues();	//syncAll 수정
			var inValidRecs = this.getInvalidRecords();
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						panelResult.getForm().wasDirty = false;
						panelSearch.getForm().wasDirty = false;
						panelResult.resetDirtyStatus();
						panelSearch.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);
						UniAppManager.app.onQueryButtonDown();
					}
				};
				this.syncAllDirect(config);
			} else {
                Ext.getCmp('set220ukrvGrid2').uniSelectInvalidColumnAndAlert(inValidRecs);
			}
       	},
		groupField:'SER_NO'
	});
	
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '<t:message code="system.label.sales.searchconditon" default="검색조건"/>',
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
			title: '<t:message code="system.label.sales.basisinfo" default="기본정보"/>',
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{ 
					fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
					name: 'DIV_CODE',
					xtype: 'uniCombobox',
					value : UserInfo.divCode,
					comboType: 'BOR120',
					allowBlank: false,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('DIV_CODE', newValue);
							panelResult.setValue('WH_CODE', "");
							panelSearch.setValue('WH_CODE', "");
						}
					}
				},{
		        	fieldLabel: '<t:message code="system.label.sales.resultsdate" default="실적일"/>', 
					xtype: 'uniDateRangefield', 
					startFieldName: 'PRODT_DATE_FR',
		        	endFieldName:'PRODT_DATE_TO',
					startDate: UniDate.get('startOfMonth'),
					endDate: UniDate.get('today'),
					width: 315,
					allowBlank: false,
					onStartDateChange: function(field, newValue, oldValue, eOpts) {
		                	if(panelResult) {
								panelResult.setValue('PRODT_DATE_FR',newValue);
		                	}
				    },
				    onEndDateChange: function(field, newValue, oldValue, eOpts) {
				    	if(panelResult) {
				    		panelResult.setValue('PRODT_DATE_TO',newValue);
				    	}
				    }
				},
					Unilite.popup('DIV_PUMOK',{
					fieldLabel: '<t:message code="system.label.sales.setitem" default="SET품목"/>', 
					valueFieldName	: 'ITEM_CODE',
					textFieldName	: 'ITEM_NAME',
					validateBlank	: false,
					listeners: {
						onValueFieldChange: function(field, newValue, oldValue){
							panelResult.setValue('ITEM_CODE', newValue);
							
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('ITEM_NAME', '');
								panelSearch.setValue('ITEM_NAME', '');
							}
						},
						onTextFieldChange: function(field, newValue, oldValue){
							panelResult.setValue('ITEM_NAME', newValue);
							
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('ITEM_CODE', '');
								panelSearch.setValue('ITEM_CODE', '');
							}
						},
						applyextparam: function(popup){							
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
							popup.setExtParam({'ITEM_ACCOUNT'	: '20'});
						}
					}
			}),{ 
					fieldLabel: '<t:message code="system.label.sales.mfgclass" default="제작구분"/>',
					name: 'MAKER_TYPE',
					xtype: 'uniCombobox',
					comboType:"AU",
					comboCode:"S086",
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('MAKER_TYPE', newValue);
						}
					}
				},{
				fieldLabel: '<t:message code="system.label.sales.warehouse" default="창고"/>',
				name: 'WH_CODE',
				xtype: 'uniCombobox',
				comboType:"OU",
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('WH_CODE', newValue);
					},
                    beforequery:function( queryPlan, eOpts )   {
                        var store = queryPlan.combo.store;
                            store.clearFilter();
                        if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE'))){
                            store.filterBy(function(record){
                            return record.get('option') == panelSearch.getValue('DIV_CODE');
                        })
                        }else{
                           store.filterBy(function(record){
                               return false;   
                        })
                     }
                  }
				}
			},Unilite.popup('DIV_PUMOK',{
					fieldLabel: '<t:message code="system.label.sales.compitemcode" default="구성품목"/>', 
					valueFieldName	: 'ITEM_CODE2',
					textFieldName	: 'ITEM_NAME2',
					validateBlank	: false,
					listeners: {
						onValueFieldChange: function(field, newValue, oldValue){
							panelResult.setValue('ITEM_CODE2', newValue);
							
							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('ITEM_NAME2', '');
								panelResult.setValue('ITEM_NAME2', '');
							}
						},
						onTextFieldChange: function(field, newValue, oldValue){
							panelResult.setValue('ITEM_NAME2', newValue);
							
							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('ITEM_CODE2', '');
								panelResult.setValue('ITEM_CODE2', '');
							}
						},
						applyextparam: function(popup){							
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
							popup.setExtParam({'ITEM_ACCOUNT'	: '20'});
						}
					}
			}),{
		          xtype:'container',
		          layout : {type : 'uniTable', columns : 3},
		          items:[{
			          fieldLabel: '<t:message code="system.label.sales.price" default="단가"/>',
			          xtype: 'uniNumberfield',
			          name:'SET_PRICE',
			          decimalPrecision: CustomCodeInfo.csPricePrecision,
			          listeners:{
						change: function(combo, newValue, oldValue, eOpts) {
							panelResult.setValue('SET_PRICE', newValue);
					    }
					  }
		          },{  
			          text: '<t:message code="system.label.sales.priceallupdate" default="단가일괄조정"/>',
			          xtype: 'button',
			          id:'priceButton2',
			          handler: function() {  
			              var activeTabId = tab.getActiveTab().getId();
			              if(activeTabId == 'set220ukrvGridTab'){
			                  if(MasterStore.getCount() > 0){
			                  	  var newPrice = panelResult.getValue("SET_PRICE")
			                  	  if(newPrice == null || newPrice < '0'){
			                  	  	    Unilite.messageBox('<t:message code="unilite.msg.sMM422"/>');
			                  	  	    return false;
			                  	  }
			                      if(confirm(Msg.fSbMsgS0206)){
			                          var records = MasterGrid.getSelectionModel().getSelection()
			                          Ext.each(records, function(record, i){
			                          	   record.set("P_INOUT_P", newPrice)
			                          	   record.set("P_INOUT_I", record.get("P_INOUT_Q") * newPrice);
			                          })
			                      }
			                  }
			              }else{
			              	  if(MasterStore2.getCount() > 0){
			              	  	  var newPrice = panelResult.getValue("SET_PRICE")
			                  	  if(newPrice == null || newPrice < 0){
			                  	  	    Unilite.messageBox('<t:message code="unilite.msg.sMM422"/>');
			                  	  	    return false;
			                  	  }
			                      if(confirm(Msg.fSbMsgS0206)){
			                          var records = MasterGrid2.getSelectionModel().getSelection()
			                          Ext.each(records, function(record, i){
			                          	   record.set("C_INOUT_P", newPrice)
			                          	   record.set("C_INOUT_I", record.get("C_INOUT_Q") * newPrice);
			                          })
			                      }
			                  }
			              }
			          }
		      	 }]
		    }
			]
		}],
   		setAllFieldsReadOnly: setAllFieldsReadOnly
	});
	
    var panelResult = Unilite.createSearchForm('panelResultForm', {
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
	    	items: [{ 
					fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
					name: 'DIV_CODE',
					xtype: 'uniCombobox',
					value : UserInfo.divCode,
					comboType: 'BOR120',
					allowBlank: false,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('DIV_CODE', newValue);
							panelResult.setValue('WH_CODE', "");
							panelSearch.setValue('WH_CODE', "");
						}
					}
				},{
		        	fieldLabel: '<t:message code="system.label.sales.resultsdate" default="실적일"/>', 
					xtype: 'uniDateRangefield', 
					startFieldName: 'PRODT_DATE_FR',
		        	endFieldName:'PRODT_DATE_TO',
					startDate: UniDate.get('startOfMonth'),
					endDate: UniDate.get('today'),
					allowBlank: false,
					width: 315,
					onStartDateChange: function(field, newValue, oldValue, eOpts) {
	                	if(panelResult) {
							panelSearch.setValue('PRODT_DATE_FR',newValue);
	                	}
				    },
				    onEndDateChange: function(field, newValue, oldValue, eOpts) {
				    	if(panelResult) {
				    		panelSearch.setValue('PRODT_DATE_TO',newValue);
				    	}
				    }
				},
					Unilite.popup('DIV_PUMOK',{
					fieldLabel: '<t:message code="system.label.sales.setitem" default="SET품목"/>', 
					valueFieldName	: 'ITEM_CODE',
					textFieldName	: 'ITEM_NAME',
					validateBlank	: false,
					colspan:2,
					listeners: {
						onValueFieldChange: function(field, newValue, oldValue){
							panelSearch.setValue('ITEM_CODE', newValue);
							
							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('ITEM_NAME', '');
								panelResult.setValue('ITEM_NAME', '');
							}
						},
						onTextFieldChange: function(field, newValue, oldValue){
							panelSearch.setValue('ITEM_NAME', newValue);
							
							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('ITEM_CODE', '');
								panelResult.setValue('ITEM_CODE', '');
							}
						},
						applyextparam: function(popup){							
							popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
							popup.setExtParam({'ITEM_ACCOUNT'	: '20'});
						}
					}
			}),{ 
					fieldLabel: '<t:message code="system.label.sales.mfgclass" default="제작구분"/>',
					name: 'MAKER_TYPE',
					xtype: 'uniCombobox',
					comboType:"AU",
					comboCode:"S086",
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelSearch.setValue('MAKER_TYPE', newValue);
						}
					}
				},{
				fieldLabel: '<t:message code="system.label.sales.warehouse" default="창고"/>',
				name: 'WH_CODE',
				xtype: 'uniCombobox',
				comboType   : 'OU',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('WH_CODE', newValue);
					},
                    beforequery:function( queryPlan, eOpts )   {
                        var store = queryPlan.combo.store;
                            store.clearFilter();
                        if(!Ext.isEmpty(panelResult.getValue('DIV_CODE'))){
                            store.filterBy(function(record){
                            return record.get('option') == panelResult.getValue('DIV_CODE');
                        })
                        }else{
                           store.filterBy(function(record){
                               return false;   
                        })
                     }
                  }
				}
			},
			Unilite.popup('DIV_PUMOK',{
					fieldLabel: '<t:message code="system.label.sales.compitemcode" default="구성품목"/>', 
					valueFieldName	: 'ITEM_CODE2',
					textFieldName	: 'ITEM_NAME2',
					validateBlank	: false,
					listeners: {
						onValueFieldChange: function(field, newValue, oldValue){
							panelSearch.setValue('ITEM_CODE2', newValue);
							
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('ITEM_NAME2', '');
								panelSearch.setValue('ITEM_NAME2', '');
							}
						},
						onTextFieldChange: function(field, newValue, oldValue){
							panelSearch.setValue('ITEM_NAME2', newValue);
							
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('ITEM_CODE2', '');
								panelSearch.setValue('ITEM_CODE2', '');
							}
						},
						applyextparam: function(popup){							
							popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
							popup.setExtParam({'ITEM_ACCOUNT'	: '20'});
						}
					}
			}),{
		          xtype:'container',
		          colspan:1,
		          layout : {type : 'uniTable', columns : 3},
		          margin:'0 0 0 115',
		          items:[{
			          fieldLabel: '<t:message code="system.label.sales.price" default="단가"/>',
			          xtype: 'uniNumberfield',
			          name:'SET_PRICE',
			          decimalPrecision: CustomCodeInfo.csPricePrecision,
			          listeners:{
						change: function(combo, newValue, oldValue, eOpts) {
							panelSearch.setValue('SET_PRICE', newValue);
					    }
					  }
		          },{  
			          text: '<t:message code="system.label.sales.priceallupdate" default="단가일괄조정"/>',
			          xtype: 'button',
			          id:'priceButton',
			          handler: function() {  
			              var activeTabId = tab.getActiveTab().getId();
			              if(activeTabId == 'set220ukrvGridTab'){
			                  if(MasterStore.getCount() > 0){
			                  	  var newPrice = panelResult.getValue("SET_PRICE")
			                  	  if(newPrice == null || newPrice < '0'){
			                  	  	    Unilite.messageBox('<t:message code="unilite.msg.sMM422"/>');
			                  	  	    return false;
			                  	  }
			                      if(confirm(Msg.fSbMsgS0206)){
			                          var records = MasterGrid.getSelectionModel().getSelection()
			                          Ext.each(records, function(record, i){
			                          	   record.set("P_INOUT_P", newPrice)
			                          	   record.set("P_INOUT_I", record.get("P_INOUT_Q") * newPrice);
			                          })
			                      }
			                  }
			              }else{
			              	  if(MasterStore2.getCount() > 0){
			              	  	  var newPrice = panelResult.getValue("SET_PRICE")
			                  	  if(newPrice == null || newPrice < 0){
			                  	  	    Unilite.messageBox('<t:message code="unilite.msg.sMM422"/>');
			                  	  	    return false;
			                  	  }
			                      if(confirm(Msg.fSbMsgS0206)){
			                          var records = MasterGrid2.getSelectionModel().getSelection()
			                          Ext.each(records, function(record, i){
			                          	   record.set("C_INOUT_P", newPrice)
			                          	   record.set("C_INOUT_I", record.get("C_INOUT_Q") * newPrice);
			                          })
			                      }
			                  }
			              }
			          }
		      	 }]
		    }

		],
   		setAllFieldsReadOnly: setAllFieldsReadOnly
    });
    
    var MasterGrid = Unilite.createGrid('set220ukrvGrid', {
    	region: 'center' ,
        layout : 'fit',
        store : MasterStore,
        width:400,
        excelTitle:'<t:message code="system.label.sales.setitementry" default="SET품목등록"/>',
        uniOpt:{
        	expandLastColumn: true,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
    		useGroupSummary: false,
			useRowNumberer: false,
			onLoadSelectFirst: false,
			filter: {
				useFilter: true,
				autoCreate: true
			}
        },
    	features: [
    		{id : 'MasterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
    	    {id : 'MasterGridTotal' ,   ftype: 'uniSummary', 	     showSummaryRow: true}
    	],
    	selModel :  Ext.create('Ext.selection.CheckboxModel', {checkOnly : true, toggleOnClick: false,
    	     listeners: { 
    			select: function(grid, selectRecord, index, rowIndex, eOpts ){ 
    				var serNo = selectRecord.get("SER_NO");
    				var records = grid.getStore().data.items;
    				var needSelect = grid.selected.items;
    				Ext.each(records, function(record, i){
    					if(record.get("SER_NO") == serNo && !needSelect.includes(record)){
    					  	needSelect.push(record)
    					}
    				});
    				Ext.getCmp("set220ukrvGrid").getSelectionModel().select(needSelect);
                },
                deselect:  function(grid, selectRecord, index, eOpts ){
                	var serNo = selectRecord.get("SER_NO");
    				var records = grid.getStore().data.items;
    				var needDeSelect = [];
    				Ext.each(records, function(record, i){
    					if(record.get("SER_NO") == serNo){
    						needDeSelect.push(record)
    					}
    				})
    				Ext.getCmp("set220ukrvGrid").getSelectionModel().deselect(needDeSelect);
                }
    		}
        }),
        columns: [
			{dataIndex: 'INOUT_DATE'		,	width: 86 },
			{dataIndex: 'SER_NO'		    ,	width: 66 },
			{dataIndex: 'P_ITEM_CODE'		,	width: 120},
			{dataIndex: 'P_ITEM_NAME'		,	width: 166},
			{dataIndex: 'P_INOUT_Q'    		,	width: 100},
			{dataIndex: 'P_INOUT_P'			,	width: 100},
			{dataIndex: 'P_INOUT_I'			,	width: 100,summaryType:'sum'},
			{dataIndex: 'MAKER_TYPE'    	,   width: 88},
			{dataIndex: 'C_ITEM_CODE'		,	width: 120},
			{dataIndex: 'C_ITEM_NAME'		,	width: 160},
			{dataIndex: 'WH_NAME'			,	width: 100},
			{dataIndex: 'WH_CELL_NAME'	    ,	width: 100},
			{dataIndex: 'C_INOUT_Q'	    	,	width: 100},
			{dataIndex: 'C_INOUT_P'	    	,	width: 100},
			{dataIndex: 'C_INOUT_I'	    	,	width: 100,summaryType:'sum'},
			{dataIndex: 'COMP_CODE'	    	,	width: 100, hidden:true},
			{dataIndex: 'DIV_CODE'	    	,	width: 100, hidden:true},
			{dataIndex: 'P_INOUT_NUM'	    ,	width: 100, hidden:true},
			{dataIndex: 'P_INOUT_SEQ'	    ,	width: 100, hidden:true},
			{dataIndex: 'P_INOUT_TYPE'	    ,	width: 100, hidden:true},
			{dataIndex: 'P_ITEM_STATUS'	    ,	width: 100, hidden:true},
			{dataIndex: 'P_WH_CODE'	   		,	width: 100, hidden:true},
			{dataIndex: 'P_WH_CELL_CODE'	,	width: 100, hidden:true},
			{dataIndex: 'P_LOT_NO'	    	,	width: 100, hidden:true},
			{dataIndex: 'C_INOUT_NUM'	    ,	width: 100, hidden:true},
			{dataIndex: 'C_INOUT_SEQ'	    ,	width: 100, hidden:true},
			{dataIndex: 'C_INOUT_TYPE'	    ,	width: 100, hidden:true},
			{dataIndex: 'C_ITEM_STATUS'	    ,	width: 100, hidden:true},
			{dataIndex: 'C_WH_CODE'	    	,	width: 100, hidden:true},
			{dataIndex: 'C_WH_CELL_CODE'	,	width: 100, hidden:true},
			{dataIndex: 'C_LOT_NO'	    	,	width: 100, hidden:true}
		],
		listeners: {
        	beforeedit  : function( editor, e, eOpts ) {
      			if (UniUtils.indexOf(e.field, ["P_INOUT_P"])){
					return true;
				}else{
					return false;
				}
        	}
		}
    });
    
    var MasterGrid2 = Unilite.createGrid('set220ukrvGrid2', {
    	region: 'center' ,
        layout : 'fit',
        store : MasterStore2,
        excelTitle:'<t:message code="system.label.sales.setitementry" default="SET품목등록"/>',
        uniOpt:{
        	expandLastColumn   : true,
    		useLiveSearch      : true,
			useContextMenu     : true,
			useMultipleSorting : true,
    		useGroupSummary    : false,
    		onLoadSelectFirst : false,
			useRowNumberer     : false,
			filter: {
				useFilter  : true,
				autoCreate : true
			}
        },
    	features: [
    		{id : 'MasterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
    	    {id : 'MasterGridTotal'   , ftype: 'uniSummary', 	     showSummaryRow: true}
    	],
    	selModel :  Ext.create('Ext.selection.CheckboxModel', {checkOnly : true, toggleOnClick:false}),
        columns: [
			{dataIndex: 'INOUT_DATE'		,	width: 86 },
			{dataIndex: 'SER_NO'		    ,	width: 66 },
			{dataIndex: 'P_ITEM_CODE'	    ,	width: 120},
			{dataIndex: 'P_ITEM_NAME'		,	width: 166},
			{dataIndex: 'P_INOUT_Q'    		,	width: 100},
			{dataIndex: 'P_INOUT_P'			,	width: 100},
			{dataIndex: 'P_INOUT_I'			,	width: 100,summaryType:'sum'},
			{dataIndex: 'MAKER_TYPE'    	,   width: 88},
			{dataIndex: 'C_ITEM_CODE'		,	width: 120},
			{dataIndex: 'C_ITEM_NAME'		,	width: 166},
			{dataIndex: 'WH_NAME'			,	width: 100},
			{dataIndex: 'WH_CELL_NAME'	    ,	width: 100},
			{dataIndex: 'C_INOUT_Q'	    	,	width: 100},
			{dataIndex: 'C_INOUT_P'	    	,	width: 100},
			{dataIndex: 'C_INOUT_I'	    	,	width: 100,summaryType:'sum'},
			{dataIndex: 'COMP_CODE'	    	,	width: 100, hidden:true},
			{dataIndex: 'DIV_CODE'	    	,	width: 100, hidden:true},
			{dataIndex: 'P_INOUT_NUM'	    ,	width: 100, hidden:true},
			{dataIndex: 'P_INOUT_SEQ'	    ,	width: 100, hidden:true},
			{dataIndex: 'P_INOUT_TYPE'	    ,	width: 100, hidden:true},
			{dataIndex: 'P_ITEM_STATUS'	    ,	width: 100, hidden:true},
			{dataIndex: 'P_WH_CODE'	    	,	width: 100, hidden:true},
			{dataIndex: 'P_WH_CELL_CODE'	,	width: 100, hidden:true},
			{dataIndex: 'P_LOT_NO'	    	,	width: 100, hidden:true},
			{dataIndex: 'C_INOUT_NUM'	    ,	width: 100, hidden:true},
			{dataIndex: 'C_INOUT_SEQ'	    ,	width: 100, hidden:true},
			{dataIndex: 'C_INOUT_TYPE'	    ,	width: 100, hidden:true},
			{dataIndex: 'C_ITEM_STATUS'	    ,	width: 100, hidden:true},
			{dataIndex: 'C_WH_CODE'	    	,	width: 100, hidden:true},
			{dataIndex: 'C_WH_CELL_CODE'	,	width: 100, hidden:true},
			{dataIndex: 'C_LOT_NO'	    	,	width: 100, hidden:true}
			],
			listeners: {
        		beforeedit  : function( editor, e, eOpts ) {
	      			if (UniUtils.indexOf(e.field, ["C_INOUT_P"])){
						return true;
					}else{
						return false;
					}
        		}
			}
    });
    
	var tab = Unilite.createTabPanel('tabPanel',{
        activeTab: 0,
        region: 'center',
        items: [{
              title: '<t:message code="system.label.sales.setitemproducing" default="SET품목제작"/>'
             ,xtype:'container'
             ,layout:{type:'vbox', align:'stretch'}
             ,items:[MasterGrid]
             ,id: 'set220ukrvGridTab'
        },{
              title: '<t:message code="system.label.sales.setitemdisassembly" default="SET품목분해"/>'
             ,xtype:'container'
             ,layout:{type:'vbox', align:'stretch'}
             ,items:[MasterGrid2]
             ,id: 'set220ukrvGridTab2' 
        }],
        listeners:  {
            tabChange:  function ( tabPanel, newCard, oldCard, eOpts )  {
                UniAppManager.setToolbarButtons(['save', 'newData' ], false);
                UniAppManager.app.onResetButtonDown();
            } 
        }
    });
    
    Unilite.Main ({
		borderItems: [{
         	region:'center',
         	layout: 'border',
         	border: false,
         	items:[{
				region : 'center',
				xtype  : 'container',
				layout : 'fit',
				items : [ tab ]
			},panelResult]	
      	},panelSearch],

		id: 'set220ukrvApp',
		fnInitBinding: function() {
			
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('PRODT_DATE_FR',UniDate.get("startOfMonth"));
			panelResult.setValue('PRODT_DATE_FR',UniDate.get("startOfMonth"));
			panelSearch.setValue('PRODT_DATE_TO',UniDate.get("today"));
			panelResult.setValue('PRODT_DATE_TO',UniDate.get("today"));
			
			UniAppManager.setToolbarButtons(['newData','delete','save'], false);
		},
		onQueryButtonDown: function()	{
			UniAppManager.setToolbarButtons('excel',true);
			var activeTabId = tab.getActiveTab().getId();
			if(panelSearch.setAllFieldsReadOnly(true) == false){
				return false;
			}else if(activeTabId == 'set220ukrvGridTab'){
				MasterGrid.getStore().loadStoreRecords();
				UniAppManager.setToolbarButtons('reset', true);
			}else{
				MasterGrid2.getStore().loadStoreRecords();
				UniAppManager.setToolbarButtons('reset', true);
			}
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelSearch.setAllFieldsReadOnly(false);
			panelResult.clearForm();
			panelResult.setAllFieldsReadOnly(false);
		
			MasterGrid.reset();
			MasterGrid2.reset();
			
			this.fnInitBinding();
			UniAppManager.setToolbarButtons('save', false);
		},
		onSaveDataButtonDown: function(config) {
			var activeTabId = tab.getActiveTab().getId();
     		if(activeTabId == 'set220ukrvGridTab'){
     			MasterStore.saveStore();
     		}else{
     			MasterStore2.saveStore();
     		}
		}
	});
	
	Unilite.createValidator('validator01', {
		store: MasterStore,
		grid: MasterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			var rv = true;
			switch(fieldName) {
				case "P_INOUT_P" :	// 순번
					if(newValue < 0) {
						rv= Msg.sMB076;	
						break;
					}
					record.set("P_INOUT_I", record.get("P_INOUT_Q") * newValue);
					var records = MasterStore.data.items;
					var index = records.indexOf(record);
					var serNo = record.get("SER_NO")
					Ext.each(records, function(rec, i){
    					if(rec.get("SER_NO") == serNo && index != i){
    					  	rec.set("P_INOUT_P", newValue);
    					  	rec.set("P_INOUT_I", rec.get("P_INOUT_Q") * newValue);
    					}
    				});
				break;
			}
			return rv;
		}
	});
	
	Unilite.createValidator('validator02', {
		store: MasterStore2,
		grid: MasterGrid2,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			var rv = true;
			switch(fieldName) {
				case "C_INOUT_P" :
					if(newValue < 0) {
						rv= Msg.sMB076;	
						break;
					}
					record.set("C_INOUT_I", record.get("C_INOUT_Q") * newValue);
					var records = MasterStore.data.items;
					var index = records.indexOf(record);
					var serNo = record.get("SER_NO")
					Ext.each(records, function(rec, i){
    					if(rec.get("SER_NO") == serNo && index != i){
    					  	rec.set("C_INOUT_P", newValue);
    					  	rec.set("C_INOUT_I", rec.get("C_INOUT_I") * newValue);
    					}
    				});
				break;
			}
			return rv;
		}
	});
	
	function setAllFieldsReadOnly(b){
		var r= true
		if(b) {
			var invalid = this.getForm().getFields().filterBy(function(field) {return !field.validate();});

			if(invalid.length > 0) {
				r=false;
				var labelText = ''

				if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
					var labelText = invalid.items[0]['fieldLabel']+' : ';
				} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
					var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
				}
			   	Unilite.messageBox(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
			   	invalid.items[0].focus();
			} else {
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
};
</script>