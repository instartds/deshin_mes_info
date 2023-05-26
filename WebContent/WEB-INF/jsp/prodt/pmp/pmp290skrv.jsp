<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="pmp290skrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="pmp290skrv" /> 					  <!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="P505"  /> 		  <!-- 작업자 -->  
	<t:ExtComboStore comboType="W" /><!-- 작업장  -->
</t:appConfig>
<style type="text/css">
.x-change-cell {
background-color: #FFFFC6;
}
.x-change-cell_Red {
background-color: #FF0000;
}
.x-change-cell_Green {
background-color: #1DDB16;
}
</style>
<script type="text/javascript" >

function appMain() {

	Unilite.defineModel('pmp290skrvModel', {
		fields: [
	    	{name: 'WORK_SHOP_CODE'       	, text: '작업장코드'  , type: 'string'},
	    	{name: 'WORK_SHOP_NAME'       	, text: '작업장'  , type: 'string'},
	    	{name: 'ITEM_CODE'       	, text: '품목코드'  , type: 'string'},
	    	{name: 'ITEM_NAME'       	, text: '품목명'  , type: 'string'},
	    	{name: 'SPEC'       	, text: '규격'  , type: 'string'},
	    	{name: '01'        	, text: '1'  , type: 'uniQty'},
	    	{name: '02'        	, text: '2'  , type: 'uniQty'},
	    	{name: '03'        	, text: '3'  , type: 'uniQty'},
	    	{name: '04'        	, text: '4'  , type: 'uniQty'},
	    	{name: '05'        	, text: '5'  , type: 'uniQty'},
	    	{name: '06'        	, text: '6'  , type: 'uniQty'},
	    	{name: '07'        	, text: '7'  , type: 'uniQty'},
	    	{name: '08'        	, text: '8'  , type: 'uniQty'},
	    	{name: '09'        	, text: '9'  , type: 'uniQty'},
	    	{name: '10'       	, text: '10'  , type: 'uniQty'},
	    	{name: '11'       	, text: '11'  , type: 'uniQty'},
	    	{name: '12'       	, text: '12'  , type: 'uniQty'},
	    	{name: '13'       	, text: '13'  , type: 'uniQty'},
	    	{name: '14'       	, text: '14'  , type: 'uniQty'},
	    	{name: '15'       	, text: '15'  , type: 'uniQty'},
	    	{name: '16'       	, text: '16'  , type: 'uniQty'},
	    	{name: '17'       	, text: '17'  , type: 'uniQty'},
	    	{name: '18'       	, text: '18'  , type: 'uniQty'},
	    	{name: '19'       	, text: '19'  , type: 'uniQty'},
	    	{name: '20'       	, text: '20'  , type: 'uniQty'},
	    	{name: '21'       	, text: '21'  , type: 'uniQty'},
	    	{name: '22'       	, text: '22'  , type: 'uniQty'},
	    	{name: '23'       	, text: '23'  , type: 'uniQty'},
	    	{name: '24'       	, text: '24'  , type: 'uniQty'},
	    	{name: '25'       	, text: '25'  , type: 'uniQty'},
	    	{name: '26'       	, text: '26'  , type: 'uniQty'},
	    	{name: '27'       	, text: '27'  , type: 'uniQty'},
	    	{name: '28'       	, text: '28'  , type: 'uniQty'},
	    	{name: '29'       	, text: '29'  , type: 'uniQty'},
	    	{name: '30'       	, text: '30'  , type: 'uniQty'},
	    	{name: '31'       	, text: '31'  , type: 'uniQty'}
	 	]
	});
	
	var directMasterStore = Unilite.createStore('pmp290skrvMasterStore',{
		model: 'pmp290skrvModel',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결
			editable: false,			// 수정 모드 사용
			deletable: false,			// 삭제 가능 여부
			useNavi: false			// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {			
				read: 'pmp290skrvService.selectList'                	
			}
		},
		loadStoreRecords: function() {
			var param= panelSearch.getValues();
			console.log( param );
			this.load({
				params: param
			});
		},
		listeners:{
			load: function(store, records, successful, eOpts) {
				
			}
		},
		groupField:'WORK_SHOP_NAME'
	});

    var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '<t:message code="system.label.product.searchconditon" default="검색조건"/>',
        defaultType: 'uniSearchSubPanel',
        collapsed:true,
        listeners: {
	        collapse: function () {
	        	panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
	    },
		items:[{	
			title: '<t:message code="system.label.product.basisinfo" default="기본정보"/>', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{
        		fieldLabel: '사업장',
        		name: 'DIV_CODE',
        		value : UserInfo.divCode,
        		xtype: 'uniCombobox',
        		comboType: 'BOR120',
        		allowBlank: false,
        		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);						
						panelResult.setValue('WORK_SHOP_CODE', '');						
						panelSearch.setValue('WORK_SHOP_CODE', '');
					}
        		}
			},{
	            fieldLabel: '생산월',                  
	            xtype: 'uniMonthfield',
	            name: 'PRODT_MONTH',                    
	            value: new Date(),                    
	            allowBlank:false,
	            listeners: {
	                change: function(field, newValue, oldValue, eOpts) {                        
	                    panelResult.setValue('PRODT_MONTH', newValue);
	                    
						UniAppManager.app.setColumnMonth(newValue);
	                }
	            }
	        },{
				fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
				name: 'WORK_SHOP_CODE',
				xtype: 'uniCombobox',
				comboType:'W',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('WORK_SHOP_CODE', newValue);
					},
                    beforequery:function( queryPlan, eOpts )   {
                        var store = queryPlan.combo.store;
                        var prStore = panelResult.getField('WORK_SHOP_CODE').store;
                        store.clearFilter();
                        prStore.clearFilter();
                        if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE'))){
                            store.filterBy(function(record){
                                return record.get('option') == panelSearch.getValue('DIV_CODE');
                            });
                            prStore.filterBy(function(record){
                                return record.get('option') == panelSearch.getValue('DIV_CODE');
                            });
                        }else{
                            store.filterBy(function(record){
                                return false;   
                            });
                            prStore.filterBy(function(record){
                                return false;   
                            });
                        }
                    }
				}
			},
			{
				xtype: 'container',
				layout: { type: 'uniTable', columns: 2},
				defaultType: 'uniTextfield',
				items:[
					Unilite.popup('DIV_PUMOK',{
						fieldLabel		: '품목코드',
						valueFieldName	: 'ITEM_CODE',
						textFieldName	: 'ITEM_NAME',
						validateBlank	: false,
						valueFieldWidth:80,
						textFieldWidth:100,
						listeners: {
							onSelected: {
								fn: function(records, type) {
									panelResult.setValue('SPEC',records[0]["SPEC"]);
									panelSearch.setValue('SPEC',records[0]["SPEC"]);
								},
								scope: this
							},
							onValueFieldChange: function(field, newValue, oldValue){
								panelResult.setValue('ITEM_CODE', newValue);
								
								if(!Ext.isObject(oldValue)) {
									panelSearch.setValue('ITEM_NAME', '');
									panelResult.setValue('ITEM_NAME','');
									panelResult.setValue('SPEC','');
									panelSearch.setValue('SPEC','');
								}
							},
							onTextFieldChange: function(field, newValue, oldValue){
								panelResult.setValue('ITEM_NAME', newValue);
								
								if(!Ext.isObject(oldValue)) {
									panelSearch.setValue('ITEM_CODE', '');
									panelResult.setValue('ITEM_CODE','');
									panelResult.setValue('SPEC','');
									panelSearch.setValue('SPEC','');
								}
							},
							applyextparam: function(popup){
								popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
							}
						}
				}),{
					name:'SPEC',
					xtype:'uniTextfield',
					width:50,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('SPEC', newValue);
						}
					}
				}]
			}]
		}]
	});
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items:[{
    		fieldLabel: '사업장',
    		name: 'DIV_CODE',
    		value : UserInfo.divCode,
    		xtype: 'uniCombobox',
    		comboType: 'BOR120',
    		allowBlank: false,
    		listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE', newValue);						
					panelSearch.setValue('WORK_SHOP_CODE', '');						
					panelResult.setValue('WORK_SHOP_CODE', '');
				}
    		}
		},{
            fieldLabel: '생산월',                  
            xtype: 'uniMonthfield',
            name: 'PRODT_MONTH',                    
            value: new Date(),                    
            allowBlank:false,
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {                        
                    panelSearch.setValue('PRODT_MONTH', newValue);
                    
					UniAppManager.app.setColumnMonth(newValue);
                }
            }
        },{
			fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
			name: 'WORK_SHOP_CODE',
			xtype: 'uniCombobox',
			comboType:'W',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('WORK_SHOP_CODE', newValue);
				},
                beforequery:function( queryPlan, eOpts )   {
                    var store = queryPlan.combo.store;
                    var psStore = panelSearch.getField('WORK_SHOP_CODE').store;
                    store.clearFilter();
                    psStore.clearFilter();
                    if(!Ext.isEmpty(panelResult.getValue('DIV_CODE'))){
                        store.filterBy(function(record){
                            return record.get('option') == panelResult.getValue('DIV_CODE');
                        });
                        psStore.filterBy(function(record){
                            return record.get('option') == panelResult.getValue('DIV_CODE');
                        });
                    }else{
                        store.filterBy(function(record){
                            return false;   
                        });
                        psStore.filterBy(function(record){
                            return false;   
                        });
                    }
                }
			}
		},
		{
			xtype: 'container',
			layout: { type: 'uniTable', columns: 2},
			defaultType: 'uniTextfield',
			colspan:2,
			items:[
				Unilite.popup('DIV_PUMOK',{
					fieldLabel		: '품목코드',
					valueFieldName	: 'ITEM_CODE',
					textFieldName	: 'ITEM_NAME',
					validateBlank	: false,
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelSearch.setValue('SPEC',records[0]["SPEC"]);
								panelResult.setValue('SPEC',records[0]["SPEC"]);
							},
							scope: this
						},
						onValueFieldChange: function(field, newValue, oldValue){
							panelSearch.setValue('ITEM_CODE', newValue);
							
							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('ITEM_NAME', '');
								panelResult.setValue('ITEM_NAME','');
								
								panelResult.setValue('SPEC','');
								panelSearch.setValue('SPEC','');
							}
						},
						onTextFieldChange: function(field, newValue, oldValue){
							panelSearch.setValue('ITEM_NAME', newValue);
							
							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('ITEM_CODE', '');
								panelResult.setValue('ITEM_CODE','');
								
								panelResult.setValue('SPEC','');
								panelSearch.setValue('SPEC','');
							}
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
						}
					}
			}),{
				name:'SPEC',
				xtype:'uniTextfield',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('SPEC', newValue);
					}
				}
			}]
		}]
    });
    
	var masterGrid = Unilite.createGrid('pmp290skrvGrid1', {
		layout: 'fit',
		region: 'center',
		sortableColumns : false,
		uniOpt:{
        	expandLastColumn: false,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
    		useGroupSummary: false,
			useRowNumberer: false,
			onLoadSelectFirst:true,
			filter: {
				useFilter: true,
				autoCreate: true
			}
        },
		features: [{
			id: 'masterGridSubTotal', 
			ftype: 'uniGroupingsummary', 
			showSummaryRow: true
		},{
			id: 'masterGridTotal', 
			ftype: 'uniSummary', 
			showSummaryRow: true
		}],
		store: directMasterStore,
		selModel:  'rowmodel',
		columns: [
//			{dataIndex: 'WORK_SHOP_CODE'       	       				, width: 100,hidden:true},
			{dataIndex: 'WORK_SHOP_NAME'       	       				, width: 100,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.inventory.subtotal" default="소계"/>', '<t:message code="system.label.inventory.total" default="총계"/>');
				}
			},
			{dataIndex: 'ITEM_CODE'         	       				, width: 100},
			{dataIndex: 'ITEM_NAME'         	       				, width: 200},
			{dataIndex: 'SPEC'              	       				, width: 250},
			{dataIndex: '01'        	       	       				, width: 100,summaryType:'sum'},
			{dataIndex: '02'        	       	       				, width: 100,summaryType:'sum'},
			{dataIndex: '03'        	       	       				, width: 100,summaryType:'sum'},
			{dataIndex: '04'        	       	       				, width: 100,summaryType:'sum'},
			{dataIndex: '05'        	       	       				, width: 100,summaryType:'sum'},
			{dataIndex: '06'        	       	       				, width: 100,summaryType:'sum'},
			{dataIndex: '07'        	       	       				, width: 100,summaryType:'sum'},
			{dataIndex: '08'        	       	       				, width: 100,summaryType:'sum'},
			{dataIndex: '09'        	       	       				, width: 100,summaryType:'sum'},
			{dataIndex: '10'       	       	       				, width: 100,summaryType:'sum'},
			{dataIndex: '11'       	       	       				, width: 100,summaryType:'sum'},
			{dataIndex: '12'       	       	       				, width: 100,summaryType:'sum'},
			{dataIndex: '13'       	       	       				, width: 100,summaryType:'sum'},
			{dataIndex: '14'       	       	       				, width: 100,summaryType:'sum'},
			{dataIndex: '15'       	       	       				, width: 100,summaryType:'sum'},
			{dataIndex: '16'       	       	       				, width: 100,summaryType:'sum'},
			{dataIndex: '17'       	       	       				, width: 100,summaryType:'sum'},
			{dataIndex: '18'       	       	       				, width: 100,summaryType:'sum'},
			{dataIndex: '19'       	       	       				, width: 100,summaryType:'sum'},
			{dataIndex: '20'       	       	       				, width: 100,summaryType:'sum'},
			{dataIndex: '21'       	       	       				, width: 100,summaryType:'sum'},
			{dataIndex: '22'       	       	       				, width: 100,summaryType:'sum'},
			{dataIndex: '23'       	       	       				, width: 100,summaryType:'sum'},
			{dataIndex: '24'       	       	       				, width: 100,summaryType:'sum'},
			{dataIndex: '25'       	       	       				, width: 100,summaryType:'sum'},
			{dataIndex: '26'       	       	       				, width: 100,summaryType:'sum'},
			{dataIndex: '27'       	       	       				, width: 100,summaryType:'sum'},
			{dataIndex: '28'       	       	       				, width: 100,summaryType:'sum'},
			{dataIndex: '29'       	       	       				, width: 100,summaryType:'sum'},
			{dataIndex: '30'       	       	       				, width: 100,summaryType:'sum'},
			{dataIndex: '31'       	       	       				, width: 100,summaryType:'sum'}
		],
		listeners: {
			afterrender: function(grid) { 
				UniAppManager.app.setColumnMonth(UniDate.get('today'));
			}
		}
	});
	
	Unilite.Main( {
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
		id: 'pmp290skrvApp',
		fnInitBinding: function() {
			
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			
			panelSearch.setValue('PRODT_MONTH',UniDate.get('today'));
			panelResult.setValue('PRODT_MONTH',UniDate.get('today'));

			UniAppManager.setToolbarButtons(['reset'], true);
			UniAppManager.setToolbarButtons(['print','save'], false);
			
		},
		onQueryButtonDown: function() {
			if(!panelResult.getInvalidMessage()) return false;
			directMasterStore.loadStoreRecords();
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			directMasterStore.clearData();
			this.fnInitBinding();
		},
		
		setColumnMonth: function(newValue) {
			for(i = 1; i <= 31; i++){
				masterGrid.getColumn(i).setHidden(false);
			}
				
	        var currDate = UniDate.getDbDateStr(newValue);
	
			var year = currDate.substring(0,4);
	    	var month = currDate.substring(4,6);
			var i = 0;
			var j = 32 - new Date(year, month-1, 32).getDate();
			for(i = j+1; i <= 31; i++){
				masterGrid.getColumn(i).setHidden(true);
			}
		}
	});
};


</script>