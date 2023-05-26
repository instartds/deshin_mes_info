<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="pmr310skrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->    
	<t:ExtComboStore comboType="W" /><!-- 작업장  -->
	<t:ExtComboStore comboType="AU" comboCode="B039"  /> 	<!-- 출고방식 -->   
	<t:ExtComboStore comboType="AU" comboCode="B023"  /> 	<!-- 생산입고방식 -->    
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
	Unilite.defineModel('Pmr310skrvModel', {
	    fields: [  	 
	    	{name: 'ITEM_CODE'       	, text: '<t:message code="system.label.product.item" default="품목"/>'		, type: 'string'},
	    	{name: 'ITEM_NAME'       	, text: '<t:message code="system.label.product.itemname" default="품목명"/>'		, type: 'string'},
	    	{name: 'SPEC'            	, text: '<t:message code="system.label.product.spec" default="규격"/>'		, type: 'string'},
	    	{name: 'OUT_METH'        	, text: '<t:message code="system.label.product.issuemethod" default="출고방법"/>'		, type: 'string' , comboType:'AU', comboCode:'B039'},
	    	{name: 'RESULT_YN'       	, text: '<t:message code="system.label.product.receiptmethod" default="입고방법"/>'		, type: 'string' , comboType:'AU', comboCode:'B023'},
	    	{name: 'WORK_SHOP_CODE'  	, text: '<t:message code="system.label.product.workcenter" default="작업장"/>'		, type: 'string' ,comboType:'W'},
	    	{name: 'WKORD_NUM'       	, text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'	, type: 'string'},
	    	{name: 'PRODT_START_DATE'	, text: '<t:message code="system.label.product.startdate" default="시작일"/>'		, type: 'uniDate'},
	    	{name: 'PRODT_END_DATE'  	, text: '<t:message code="system.label.product.workenddate" default="작업완료일"/>'		, type: 'uniDate'},
	    	{name: 'PLAN_Q'          	, text: '<t:message code="system.label.product.orderqty" default="오더량"/>'		, type: 'uniQty'},
	    	{name: 'IN_STOCK_Q'      	, text: '<t:message code="system.label.product.productioninputqty" default="생산투입량"/>'		, type: 'uniQty'},
	    	{name: 'OUT_STOCK_Q'     	, text: '<t:message code="system.label.product.productionqty" default="생산량"/>'		, type: 'uniQty'},
	    	{name: 'WIP_STOCK_Q'     	, text: '<t:message code="system.label.product.wipqty" default="재공량"/>'		, type: 'uniQty'},
	    	{name: 'PROJECT_NO'         , text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>' , type: 'string'}
		]
	});		//End of Unilite.defineModel('Pmr310skrvModel', {
	
	// GroupField string type으로 변환
	function dateToString(v, record){
		return UniDate.safeFormat(v);
	  }
	  
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('pmr310skrvMasterStore1',{
			model: 'Pmr310skrvModel',
			uniOpt: {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi: false			// prev | next 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {			
                	   read: 'pmr310skrvService.selectList'                	
                }
            },
			loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();			
				console.log( param );
				this.load({
					params : param
				});	
			},
			groupField: 'ITEM_NAME'
	});		// End of var directMasterStore1 = Unilite.createStore('pmr310skrvMasterStore1',{
	

	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm',{
		title: '<t:message code="system.label.product.searchconditon" default="검색조건"/>',
        defaultType: 'uniSearchSubPanel',
        collapsed:true,
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
	        	xtype: 'uniCombobox', 
	        	comboType:'BOR120',
	        	allowBlank:false,
	        	value : UserInfo.divCode,
	        	listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							topSearch.setValue('DIV_CODE', newValue);
							panelSearch.setValue('WORK_SHOP_CODE','');
						}
					}
	        },
	        	Unilite.popup('DIV_PUMOK',{ // 20210826 추가: 품목 조회조건 정규화
			    	fieldLabel		: '<t:message code="system.label.product.item" default="품목"/>', 
			    	valueFieldName	: 'ITEM_CODE_FR',
			   	 	textFieldName	: 'ITEM_NAME_FR',
			   	 	validateBlank	: false,
			   	 	listeners: {
						onValueFieldChange:function( elm, newValue, oldValue) {
							topSearch.setValue('ITEM_CODE_FR', newValue);
							
							if(!Ext.isObject(oldValue)) {
								topSearch.setValue('ITEM_NAME_FR', '');
								panelSearch.setValue('ITEM_NAME_FR', '');
							}
						},
						onTextFieldChange:function( elm, newValue, oldValue) {
							topSearch.setValue('ITEM_NAME_FR', newValue);
							
							if(!Ext.isObject(oldValue)) {
								topSearch.setValue('ITEM_CODE_FR', '');
								panelSearch.setValue('ITEM_CODE_FR', '');
							}
						},
						applyextparam: function(popup){							
							popup.setExtParam({'DIV_CODE': topSearch.getValue('DIV_CODE')});
						}
					}
			}),
				Unilite.popup('DIV_PUMOK',{ // 20210826 추가: 품목 조회조건 정규화
			    	fieldLabel		: '~',
			    	valueFieldName	: 'ITEM_CODE_TO',
			   	 	textFieldName	: 'ITEM_NAME_TO',
			   	 	validateBlank	: false,
			   	 	listeners: {
						onValueFieldChange:function( elm, newValue, oldValue) {						
							topSearch.setValue('ITEM_CODE_TO', newValue);
							
							if(!Ext.isObject(oldValue)) {
								topSearch.setValue('ITEM_NAME_TO', '');
								panelSearch.setValue('ITEM_NAME_TO', '');
							}
						},
						onTextFieldChange:function( elm, newValue, oldValue) {
							topSearch.setValue('ITEM_NAME_TO', newValue);
							
							if(!Ext.isObject(oldValue)) {
								topSearch.setValue('ITEM_CODE_TO', '');
								panelSearch.setValue('ITEM_CODE_TO', '');
							}
						},
						applyextparam: function(popup){							
							popup.setExtParam({'DIV_CODE': topSearch.getValue('DIV_CODE')});
						}
					}
			}),{
				fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
				name: 'WORK_SHOP_CODE', 
				xtype: 'uniCombobox', 
				comboType:'W',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						topSearch.setValue('WORK_SHOP_CODE', newValue);
					},
                    beforequery:function( queryPlan, eOpts )   {
                        var store = queryPlan.combo.store;
                        var prStore = topSearch.getField('WORK_SHOP_CODE').store;
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
				Unilite.popup('WKORD_NUM',{ 
			    	fieldLabel: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>',
			   	 	textFieldName:'WKORD_NUM_FR',
			   	 	listeners: {
			   	 		onSelected: {
							fn: function(records, type) {
								topSearch.setValue('WKORD_NUM_FR', panelSearch.getValue('WKORD_NUM_FR'));			 																							
							},
							scope: this
						},
						onClear: function(type)	{
							topSearch.setValue('WKORD_NUM_FR', '');
						},
						applyextparam: function(popup){							
							popup.setExtParam({'DIV_CODE': topSearch.getValue('DIV_CODE')});
							popup.setExtParam({'WORK_SHOP_CODE': topSearch.getValue('WORK_SHOP_CODE')});
						}
					}
			}),
				Unilite.popup('WKORD_NUM',{ 
				    	fieldLabel: '~', 
				   	 	textFieldName:'WKORD_NUM_TO',
				   	 	listeners: {
				   	 		onSelected: {
								fn: function(records, type) {
									topSearch.setValue('WKORD_NUM_TO', panelSearch.getValue('WKORD_NUM_TO'));			 																							
								},
								scope: this
							},
							onClear: function(type)	{
								topSearch.setValue('WKORD_NUM_TO', '');
							},
							applyextparam: function(popup){							
								popup.setExtParam({'DIV_CODE': topSearch.getValue('DIV_CODE')});
								popup.setExtParam({'WORK_SHOP_CODE': topSearch.getValue('WORK_SHOP_CODE')});
							}
						}
				})/*{
				xtype: 'container',
	            layout: {type: 'hbox', align:'stretch'},
	            width:325,
	            defaultType: 'uniTextfield',
	            items: [{
	            	fieldLabel: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>', 
	            	suffixTpl:'&nbsp;~&nbsp;', 
	            	name: 'WKORD_NUM_FR', 
	            	width:218
	            },{
	            	hideLabel: true, 
	            	name: 'WKORD_NUM_TO', 
	            	width:107
	            }] 
			}*/]
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
    }); 		//End of var panelSearch = Unilite.createSearchForm('searchForm',{   
	
    var topSearch = Unilite.createSimpleForm('topSearchForm', {
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
	    	items: [{
	        	fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
	        	name: 'DIV_CODE', 
	        	xtype: 'uniCombobox', 
	        	comboType:'BOR120',
	        	allowBlank:false,
	        	value : UserInfo.divCode,
	        	listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE', newValue);
					topSearch.setValue('WORK_SHOP_CODE','');
					}
				}
	        },
	        	Unilite.popup('DIV_PUMOK',{ // 20210826 추가: 품목 조회조건 정규화
			    	fieldLabel		: '<t:message code="system.label.product.item" default="품목"/>', 
			    	textFieldWidth	: 170, 
			    	valueFieldName	: 'ITEM_CODE_FR',
			   	 	textFieldName	: 'ITEM_NAME_FR',
			   	 	validateBlank	: false,
			   	 	listeners: {
						onValueFieldChange:function( elm, newValue, oldValue) {
							panelSearch.setValue('ITEM_CODE_FR', newValue);
							
							if(!Ext.isObject(oldValue)) {
								topSearch.setValue('ITEM_NAME_FR', '');
								panelSearch.setValue('ITEM_NAME_FR', '');
							}
						},
						onTextFieldChange:function( elm, newValue, oldValue) {
							panelSearch.setValue('ITEM_NAME_FR', newValue);
							
							if(!Ext.isObject(oldValue)) {
								topSearch.setValue('ITEM_CODE_FR', '');
								panelSearch.setValue('ITEM_CODE_FR', '');
							}
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
			}),
				Unilite.popup('DIV_PUMOK',{ // 20210826 추가: 품목 조회조건 정규화
			    	fieldLabel		: '~', 
			    	textFieldWidth	: 170, 
			    	labelWidth		: 15,
			    	valueFieldName	: 'ITEM_CODE_TO',
			   	 	textFieldName	: 'ITEM_NAME_TO',
			   	 	validateBlank	: false,
			   	 	listeners: {
						onValueFieldChange:function( elm, newValue, oldValue) {						
							panelSearch.setValue('ITEM_CODE_TO', newValue);
							
							if(!Ext.isObject(oldValue)) {
								topSearch.setValue('ITEM_NAME_TO', '');
								panelSearch.setValue('ITEM_NAME_TO', '');
							}
						},
						onTextFieldChange:function( elm, newValue, oldValue) {
							panelSearch.setValue('ITEM_NAME_TO', newValue);
							
							if(!Ext.isObject(oldValue)) {
								topSearch.setValue('ITEM_CODE_TO', '');
								panelSearch.setValue('ITEM_CODE_TO', '');
							}
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
			}),{
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
                        var prStore = panelSearch.getField('WORK_SHOP_CODE').store;
                        store.clearFilter();
                        prStore.clearFilter();
                        if(!Ext.isEmpty(topSearch.getValue('DIV_CODE'))){
                            store.filterBy(function(record){
                                return record.get('option') == topSearch.getValue('DIV_CODE');
                            });
                            prStore.filterBy(function(record){
                                return record.get('option') == topSearch.getValue('DIV_CODE');
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
			
				Unilite.popup('WKORD_NUM',{ 
			    	fieldLabel: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>', 
			   	 	textFieldName:'WKORD_NUM_FR',
			   	 	listeners: {
			   	 		onSelected: {
							fn: function(records, type) {
								panelSearch.setValue('WKORD_NUM_FR', topSearch.getValue('WKORD_NUM_FR'));			 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelSearch.setValue('WKORD_NUM_FR', '');
						},
						applyextparam: function(popup){							
							popup.setExtParam({'DIV_CODE': topSearch.getValue('DIV_CODE')});
							popup.setExtParam({'WORK_SHOP_CODE': panelSearch.getValue('WORK_SHOP_CODE')});
						}
					}
			}),
				Unilite.popup('WKORD_NUM',{ 
				    	fieldLabel: '~', 
				   	 	textFieldName:'WKORD_NUM_TO',
				   	 	listeners: {
				   	 		onSelected: {
								fn: function(records, type) {
									panelSearch.setValue('WKORD_NUM_TO', topSearch.getValue('WKORD_NUM_TO'));			 																							
								},
								scope: this
							},
							onClear: function(type)	{
								panelSearch.setValue('WKORD_NUM_TO', '');
							},
							applyextparam: function(popup){							
								popup.setExtParam({'DIV_CODE': topSearch.getValue('DIV_CODE')});
								popup.setExtParam({'WORK_SHOP_CODE': panelSearch.getValue('WORK_SHOP_CODE')});
							}
						}
				})]
    });
    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid1 = Unilite.createGrid('pmr310skrvGrid1', {
        layout : 'fit',
    	region:'center',
        store : directMasterStore1, 
        uniOpt:{
        	expandLastColumn: true,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
    		useGroupSummary: false,
			useRowNumberer: false,
			filter: {
				useFilter: true,
				autoCreate: true
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
    	store: directMasterStore1,
    	features: [ 
    		{id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
    	    {id: 'masterGridTotal',    ftype: 'uniSummary', 	    showSummaryRow: false} 
    	],
        columns: [  
        	{dataIndex: 'ITEM_CODE'       	, width: 100}, 				
			{dataIndex: 'ITEM_NAME'       	, width: 143},  				
			{dataIndex: 'SPEC'            	, width: 100},			
			{dataIndex: 'OUT_METH'        	, width: 100}, 				
			{dataIndex: 'RESULT_YN'       	, width: 100},				
			{dataIndex: 'WORK_SHOP_CODE'  	, width: 100}, 				
			{dataIndex: 'WKORD_NUM'       	, width: 110}, 				
			{dataIndex: 'PRODT_START_DATE'	, width: 94}, 				
			{dataIndex: 'PRODT_END_DATE'  	, width: 94}, 				
			{dataIndex: 'PLAN_Q'          	, width: 92}, 				
			{dataIndex: 'IN_STOCK_Q'      	, width: 92}, 				
			{dataIndex: 'OUT_STOCK_Q'     	, width: 92}, 				
			{dataIndex: 'WIP_STOCK_Q'     	, width: 96},
			{dataIndex: 'PROJECT_NO'        , width: 110}
		] 
    });		// End of var masterGrid1 = Unilite.createGrid('pmr310skrvGrid1', {

    Unilite.Main({
		borderItems:[{
         region:'center',
         layout: 'border',
         border: false,
         items:[
            masterGrid1, topSearch
         ]
      },
         panelSearch
      ],
		id : 'pmr310skrvApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown : function()	{		
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
			
			masterGrid1.getStore().loadStoreRecords();
			/*var viewNormal = masterGrid1.normalGrid.getView();
			var viewLocked = masterGrid1.lockedGrid.getView();
			
			console.log("viewNormal : ",viewNormal);
			console.log("viewLocked : ",viewLocked);
			
			viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
		    viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		    viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
		    UniAppManager.setToolbarButtons('excel',true);*/
			}
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
	});		// End of Unilite.Main({
};
</script>
