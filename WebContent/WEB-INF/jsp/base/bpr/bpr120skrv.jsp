<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bpr120skrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" /><!--창고-->	
	<t:ExtComboStore comboType="AU" comboCode="B013" /><!-- 단위 -->
	<t:ExtComboStore comboType="AU" comboCode="B059" /><!-- 세구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B010" /><!-- 단위 -->
	<t:ExtComboStore comboType="AU" comboCode="B020" /><!-- 품목계정 -->
	<t:ExtComboStore comboType="AU" comboCode="B014" /><!-- 조달구분 -->
	<t:ExtComboStore comboType="AU" comboCode="YP19" /><!-- 주방프린터 -->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="bpr120skrvLevel1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="bpr120skrvLevel2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="bpr120skrvLevel3Store" />
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {     
	Ext.define("Docs.view.search.Container", {
		extend: "Ext.container.Container",
		alias: "widget.searchcontainer",		
		initComponent: function() {			
			var me = this;			
	    	var searchStore  = Ext.create('Ext.data.Store',{
	            fields: [ 
		            {name:'ITEM_NAME', type:'string'}
	            ],
	            storeId: 'SearchMenuStore',
	            autoLoad: false,
	            pageSize: 50,
	            proxy: {
	                type: 'direct',
	                api: {
	                    read : 'bpr101skrvService.searchMenu'
	                },
		            reader: {
		                type: 'json',
				<c:choose>
		        	<c:when test="${ext_version == '4.2.2'}">
		        		root: 'records'	//4.2.2
		        	</c:when>		
		        	<c:otherwise>
		        		rootProperty: 'records'	//5.1.0
		        	</c:otherwise>		
		        </c:choose>		                
		            }
	            }
	        });
			this.items = [{
				fieldLabel:'<t:message code="system.label.base.itemname" default="품목명"/>',
		        xtype: "combobox",
		        autoSelect: false,
	  	        store: searchStore,
		        queryMode: 'remote',
	//	        pageSize: true, 
		        displayField: 'ITEM_NAME',
		        name: 'ITEM_NAME',
		        minChars: 1,
		        queryParam: 'searchStr',
		        hideTrigger: true,
		        selectOnFocus: false,
		        width: 388,
		        itemId: 'itemSearchForm',
		        listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('ITEM_NAME', newValue);
						panelResult.setValue('ITEM_NAME', newValue);
					},
					blur: function(){
						var itemID = me.getItemId();
						if(itemID == 'panelSearch'){
							panelResult.setValue('ITEM_NAME', panelSearch.getValue('ITEM_NAME'));
						}else{
							panelSearch.setValue('ITEM_NAME', panelResult.getValue('ITEM_NAME'));
						}
					}
				}
			}];  
			searchStore.on('beforeload', function(store, operation) {				
			    var proxy = store.getProxy();
			    proxy.setConfig('extraParams', {DIV_CODE: panelSearch.getValue('DIV_CODE')});
			});
			this.callParent();
		}
	});
	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('bpr120skrvModel', {
	    fields: [  	  
		{name:'KEY_VALUE'					,text:'변경이력KEY'			,type:'string'},
		{name:'OPR_FLAG'					,text:'변경로그'				,type:'string'},		     
		{name:'COMP_CODE'					,text:'COMP_CODE'			,type:'string'},
		{name:'DIV_CODE'					,text:'<t:message code="system.label.base.division" default="사업장"/>'				,type:'string'},
		{name:'DIV_NAME'					,text:'<t:message code="system.label.base.division" default="사업장"/>'				,type:'string'},
		{name:'ITEM_CODE'					,text:'<t:message code="system.label.base.itemcode" default="품목코드"/>'				,type:'string'},
		{name:'ITEM_NAME'					,text:'<t:message code="system.label.base.itemname" default="품목명"/>'				,type:'string'},
		{name:'ITEM_LEVEL1'					,text:'<t:message code="system.label.base.majorgroup" default="대분류"/>'				,type:'string', store: Ext.data.StoreManager.lookup('bpr120skrvLevel1Store')},
		{name:'ITEM_LEVEL2'					,text:'<t:message code="system.label.base.middlegroup" default="중분류"/>'				,type:'string', store: Ext.data.StoreManager.lookup('bpr120skrvLevel2Store')},
		{name:'ITEM_LEVEL3'					,text:'<t:message code="system.label.base.minorgroup" default="소분류"/>'				,type:'string', store: Ext.data.StoreManager.lookup('bpr120skrvLevel3Store')},
		{name:'STOCK_UNIT'					,text:'<t:message code="system.label.base.inventoryunit" default="재고단위"/>'				,type:'string', comboType:'AU', comboCode:'B013', displayField: 'value'},
		{name:'STOCK_CARE_YN'				,text:'<t:message code="system.label.base.inventorymanageobject" default="재고관리대상"/>'			,type:'string', comboType:'AU', comboCode:'B010'},
		{name:'TAX_TYPE'					,text:'<t:message code="system.label.base.taxtype" default="세구분"/>'				,type:'string', comboType:'AU', comboCode:'B059'},
		{name:'CONSIGNMENT_FEE'				,text:'위탁수수료'				,type:'uniPrice'},
		{name:'SALE_BASIS_P'				,text:'<t:message code="system.label.base.sellingprice" default="판매단가"/>'				,type:'uniUnitPrice'},
		{name:'AUTO_DISCOUNT'				,text:'자동할인'				,type:'string', comboType:'AU', comboCode:'B010'},
		{name:'SALE_UNIT'					,text:'<t:message code="system.label.base.salesunit" default="판매단위"/>'				,type:'string', comboType:'AU', comboCode:'B013', displayField: 'value'},
		{name:'ITEM_ACCOUNT'				,text:'<t:message code="system.label.base.itemaccount" default="품목계정"/>'				,type:'string', comboType:'AU', comboCode:'B020'},
		{name:'SUPPLY_TYPE'					,text:'<t:message code="system.label.base.procurementclassification" default="조달구분"/>'				,type:'string', comboType:'AU', comboCode:'B014'},
		{name:'ORDER_UNIT'					,text:'<t:message code="system.label.base.purchaseunit" default="구매단위"/>'				,type:'string', comboType:'AU', comboCode:'B013', displayField: 'value'},
		{name:'TRNS_RATE'					,text:'<t:message code="system.label.base.purchasereceiptcount" default="구매입수"/>'				,type:'int'},
		{name:'BIG_BOX_BARCODE'				,text:'물류바코드'				,type:'string'},
		{name:'K_PRINTER'					,text:'주방프린터'				,type:'string', comboType:'AU', comboCode:'YP19'},
		{name:'BARCODE'						,text:'상품바코드'				,type:'string'},
		{name:'UPDATE_DB_TIME'				,text:'수정일'				,type:'string'},
		{name:'UPDATE_DB_USER'				,text:'수정자ID'				,type:'string'},
		{name:'USER_NAME'					,text:'수정자'				,type:'string'}
		]
	}); //End of Unilite.defineModel('bpr120skrvModel', {
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('bpr120skrvMasterStore1',{
		model: 'bpr120skrvModel',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: false,			// 수정 모드 사용 
            deletable: false,			// 삭제 가능 여부 
	        useNavi : false			// prev | next 버튼 사용
        },
        autoLoad: false,
        proxy: {
        	type: 'direct',
            api: {			
            	read: 'bpr120skrvService.selectList'                	
            }
        },
        loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		},
		groupField: 'CUSTOM_CODE'
	});
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm',{
		title: '<t:message code="system.label.base.searchconditon" default="검색조건"/>',
        defaultType: 'uniSearchSubPanel',
        collapsed: UserInfo.appOption.collapseLeftSearch,
        listeners: {
	       collapse: function () {
	        	panelResult.show();
	        	panelSearch.down('#itemSearchForm').setWidth(388);
	        },
	        expand: function() {
	        	panelResult.hide();	
	        	panelSearch.down('#itemSearchForm').setWidth(245);
	        }
	    },
		items: [{	
			title: '<t:message code="system.label.base.basisinfo2" default="기본정보"/>', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{
		        fieldLabel: '변경일',
		        xtype: 'uniDateRangefield',  
				startFieldName: 'FROM_DATE',
				endFieldName: 'TO_DATE',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				allowBlank: false,
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('FROM_DATE',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('TO_DATE',newValue);
			    	}
			    }
			},
				Unilite.popup('USER',{
					fieldLabel: '수정자',
					valueFieldName:'USER_ID',
			    	textFieldName:'USER_NAME',
			    	listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('USER_ID', panelSearch.getValue('USER_ID'));
								panelResult.setValue('USER_NAME', panelSearch.getValue('USER_NAME'));
	                    	},
							scope: this
						},
						onClear: function(type)	{
								panelResult.setValue('USER_ID', '');
								panelResult.setValue('USER_NAME', '');
						}
					}
			}),{ 
				fieldLabel: '<t:message code="unilite.msg.sMS631" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				readOnly: false,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						combo.changeDivCode(combo, newValue, oldValue, eOpts);
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{
    			xtype: 'uniTextfield',
	            name: 'ITEM_CODE',  		
    			fieldLabel: '<t:message code="system.label.base.itemcode" default="품목코드"/>' ,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ITEM_CODE', newValue);
					},
					specialkey: function(field, event){
						if(Ext.isEmpty(field.getValue())) return false;
						if(event.getKey() == event.ENTER){								
							var needSave = !UniAppManager.app.getTopToolbar().getComponent('save').isDisabled();
							if(needSave) {
								Ext.Msg.show({
								     title:'확인',
								     msg: Msg.sMB017 + "\n" + Msg.sMB061,
								     buttons: Ext.Msg.YESNOCANCEL,
								     icon: Ext.Msg.QUESTION,
								     fn: function(res) {
								     	//console.log(res);
								     	if (res === 'yes' ) {
								     		var saveTask =  Ext.create('Ext.util.DelayedTask', function(){
						                  		UniAppManager.app.onSaveAndQueryButtonDown();
						                    });
						                    saveTask.delay(500);
								     	} else if(res === 'no') {
								     		UniAppManager.app.onQueryButtonDown();
								     	}
								     }
								});
							} else {
								setTimeout(function(){
									UniAppManager.app.onQueryButtonDown()
									}
									, 500
								)
							}
						}							
					}
					/*blur: function(field, event, eOpts) {
						if(Ext.isEmpty(field.getValue())) return false;
						var needSave = !UniAppManager.app.getTopToolbar().getComponent('save').isDisabled();
						if(needSave) {
							Ext.Msg.show({
							     title:'확인',
							     msg: Msg.sMB017 + "\n" + Msg.sMB061,
							     buttons: Ext.Msg.YESNOCANCEL,
							     icon: Ext.Msg.QUESTION,
							     fn: function(res) {
							     	//console.log(res);
							     	if (res === 'yes' ) {
							     		var saveTask =  Ext.create('Ext.util.DelayedTask', function(){
					                  		UniAppManager.app.onSaveAndQueryButtonDown();
					                    });
					                    saveTask.delay(500);
							     	} else if(res === 'no') {
							     		UniAppManager.app.onQueryButtonDown();
							     	}
							     }
							});
						} else {
							setTimeout(function(){
								UniAppManager.app.onQueryButtonDown()
								}
								, 500
							)
						}					
					}*/
				}
    		},{ 
    			xtype: 'searchcontainer',
    			itemId: 'panelSearch'
            },{ 
				fieldLabel: '<t:message code="system.label.base.itemaccount" default="품목계정"/>',
				name: 'ITEM_ACCOUNT',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B020',
				readOnly: false,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						combo.changeDivCode(combo, newValue, oldValue, eOpts);
						panelResult.setValue('ITEM_ACCOUNT', newValue);
					}
				}
			}]
		}]
    }); //End of var panelSearch = Unilite.createSearchForm('searchForm',{
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
  
    var panelResult = Unilite.createSearchForm('resultForm',{		
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		hidden: !UserInfo.appOption.collapseLeftSearch,
		border:true,
		items: [{
	        fieldLabel: '변경일',
	        xtype: 'uniDateRangefield',  
			startFieldName: 'FROM_DATE',
			endFieldName: 'TO_DATE',
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
			allowBlank: false,
			width: 315,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('FROM_DATE',newValue);
            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('TO_DATE',newValue);
		    	}
		    }
		},
			Unilite.popup('USER',{
				fieldLabel: '수정자',
				valueFieldName:'USER_ID',
		    	textFieldName:'USER_NAME',
		    	listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('USER_ID', panelResult.getValue('USER_ID'));
							panelSearch.setValue('USER_NAME', panelResult.getValue('USER_NAME'));
                    	},
						scope: this
					},
					onClear: function(type)	{
							panelSearch.setValue('USER_ID', '');
							panelSearch.setValue('USER_NAME', '');
					}
				}
		}),{ 
			fieldLabel: '<t:message code="unilite.msg.sMS631" default="사업장"/>',
			name: 'DIV_CODE',
			labelWidth: 70,
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			readOnly: false,		
			labelWidth: 110,			
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
					combo.changeDivCode(combo, newValue, oldValue, eOpts);
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{		
			name: 'ITEM_CODE',  		
			fieldLabel: '<t:message code="system.label.base.itemcode" default="품목코드"/>' ,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('ITEM_CODE', newValue);
				},
				specialkey: function(field, event){
					if(Ext.isEmpty(field.getValue())) return false;
					if(event.getKey() == event.ENTER){						
						var needSave = !UniAppManager.app.getTopToolbar().getComponent('save').isDisabled();
						if(needSave) {
							Ext.Msg.show({
							     title:'확인',
							     msg: Msg.sMB017 + "\n" + Msg.sMB061,
							     buttons: Ext.Msg.YESNOCANCEL,
							     icon: Ext.Msg.QUESTION,
							     fn: function(res) {
							     	//console.log(res);
							     	if (res === 'yes' ) {
							     		var saveTask =  Ext.create('Ext.util.DelayedTask', function(){
					                  		UniAppManager.app.onSaveAndQueryButtonDown();
					                    });
					                    saveTask.delay(500);
							     	} else if(res === 'no') {
							     		UniAppManager.app.onQueryButtonDown();
							     	}
							     }
							});
						} else {
							setTimeout(function(){
								UniAppManager.app.onQueryButtonDown()
								}
								, 500
							)
						}	
					}
				}
				/*blur: function(field, event, eOpts) {
					if(Ext.isEmpty(field.getValue())) return false;
					var needSave = !UniAppManager.app.getTopToolbar().getComponent('save').isDisabled();
					if(needSave) {
						Ext.Msg.show({
						     title:'확인',
						     msg: Msg.sMB017 + "\n" + Msg.sMB061,
						     buttons: Ext.Msg.YESNOCANCEL,
						     icon: Ext.Msg.QUESTION,
						     fn: function(res) {
						     	//console.log(res);
						     	if (res === 'yes' ) {
						     		var saveTask =  Ext.create('Ext.util.DelayedTask', function(){
				                  		UniAppManager.app.onSaveAndQueryButtonDown();
				                    });
				                    saveTask.delay(500);
						     	} else if(res === 'no') {
						     		UniAppManager.app.onQueryButtonDown();
						     	}
						     }
						});
					} else {
						setTimeout(function(){
							UniAppManager.app.onQueryButtonDown()
							}
							, 500
						)
					}					
				}*/		
			}
		},{ 
			xtype: 'searchcontainer',
			itemId: 'panelResult'
        },{ 
			fieldLabel: '<t:message code="system.label.base.itemaccount" default="품목계정"/>',
			name: 'ITEM_ACCOUNT',
			labelWidth: 110,
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'B020',
			readOnly: false,
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
					combo.changeDivCode(combo, newValue, oldValue, eOpts);
					panelSearch.setValue('ITEM_ACCOUNT', newValue);
				}
			}
		}/*, {
			text: '상품전송',
			xtype: 'button',
			margin: '0 0 0 40',
			handler: function(){    	
				var param = panelSearch.getValues();
				bpr120skrvService.goInterFace(param, function(provider, response)	{
				});
			}
		}*/]	
    });
   
    var panelChangeHistory = Unilite.createSearchForm('changeHistoryForm',{
    	flex : 1,
    	autoScroll: true,
    	width: -100,
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'east',
		padding:'1 1 1 1',
		border:true,
		layout: {xtype: 'uniTable', columns: 3},
		items: [{
			xtype: 'component',
			margin: '7.5,7.5,7.5,7.5',
			algin: 'center',
			html: '<b><font size = "2" color = "blue">변경이력</font></b>'
		},{
			name: 'CHANGE_HISTORY',
			xtype: 'textarea',
			margin: '1, 1, 1, 1',
			editable: false,
			width: 1000,
			height: 2000
		}]
    });	
    
    var masterGrid = Unilite.createGrid('bpr120skrvGrid1', {
    	layout : 'fit',
    	flex : 3,
    	region:'center',
        store : directMasterStore, 
        uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,
    		filter: {
				useFilter: false,
				autoCreate: false
			}
        },
       /* tbar: [{
        	text:'상세보기',
        	handler: function() {
        		var record = masterGrid.getSelectedRecord();
	        	if(record) {
	        		openDetailWindow(record);
	        	}
        	}
        }],*/
        columns: [
        	 {dataIndex:'KEY_VALUE'					,width:80, hidden: true},
			 {dataIndex:'OPR_FLAG'					,width:80, locked: true},
			 {dataIndex:'COMP_CODE'					,width:80, hidden: true},
			 {dataIndex:'DIV_CODE'					,width:80, locked: true},
			 {dataIndex:'DIV_NAME'					,width:160, locked: true},
			 {dataIndex:'ITEM_CODE'					,width:105, locked: true},
			 {dataIndex:'ITEM_NAME'					,width:200, locked: true},
			 {dataIndex:'ITEM_LEVEL1'				,width:120},
			 {dataIndex:'ITEM_LEVEL2'				,width:120},
			 {dataIndex:'ITEM_LEVEL3'				,width:120},
			 {dataIndex:'STOCK_UNIT'				,width:90, align: 'center'},
			 {dataIndex:'STOCK_CARE_YN'				,width:100},
			 {dataIndex:'TAX_TYPE'					,width:80, align: 'center'},
			 {dataIndex:'CONSIGNMENT_FEE'			,width:80},
			 {dataIndex:'SALE_BASIS_P'				,width:80},
			 {dataIndex:'AUTO_DISCOUNT'				,width:80},
			 {dataIndex:'SALE_UNIT'					,width:80, align: 'center'},
			 {dataIndex:'ITEM_ACCOUNT'				,width:145},
			 {dataIndex:'SUPPLY_TYPE'				,width:110},
			 {dataIndex:'ORDER_UNIT'				,width:90},
			 {dataIndex:'TRNS_RATE'					,width:70},
			 {dataIndex:'BIG_BOX_BARCODE'			,width:100},
			 {dataIndex:'K_PRINTER'					,width:80},
			 {dataIndex:'BARCODE'					,width:80},
			 {dataIndex:'UPDATE_DB_TIME'			,width:146},			 
			 {dataIndex:'UPDATE_DB_USER'			,width:80},
			 {dataIndex:'USER_NAME'					,width:80}
		],
        selModel: 'rowmodel',		// 조회화면 selectionchange event 사용
		listeners: {        	
        	selectionchange:function( model1, selected, eOpts ){
        		panelChangeHistory.setValue('CHANGE_HISTORY', '');
        		if(selected[0].data.OPR_FLAG == '수정'){
					var param = masterGrid.getSelectedRecord().data;
        			bpr120skrvService.getChangeHistory(param, function(provider, response)	{
	        			if(!Ext.isEmpty(provider)){
	        				panelChangeHistory.setValue('CHANGE_HISTORY', provider[0].MODIFY_FACTOR);
	        			}	        		
	        		});	
        		}
        		
				       			
          	}
        } 
    });	//End of   var masterGrid = Unilite.createGrid('bpr120skrvGrid1', {

    Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
			masterGrid, panelResult, panelChangeHistory  	
			]
		},
			panelSearch
		],
		id: 'bpr120skrvApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
		},
		onQueryButtonDown : function() {		
			directMasterStore.loadStoreRecords();			
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			this.fnInitBinding();
			directMasterStore.loadData({});
		}
	}); //End of Unilite.Main( {
};

</script>
