<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="pmr130skrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->  
	<t:ExtComboStore comboType="W" /><!-- 작업장  -->
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
	Unilite.defineModel('Pmr130skrvModel', {
	    fields: [  	
	    	{name: 'DIV_CODE'      		, text: '<t:message code="system.label.product.division" default="사업장"/>'		, type: 'string'},
			{name: 'ITEM_CODE'     		, text: '<t:message code="system.label.product.item" default="품목"/>'		, type: 'string'},
			{name: 'ITEM_NAME'     		, text: '<t:message code="system.label.product.itemname" default="품목명"/>'		, type: 'string'},
			{name: 'SPEC'          		, text: '<t:message code="system.label.product.spec" default="규격"/>'		, type: 'string'},
			{name: 'STOCK_UNIT'    		, text: '<t:message code="system.label.product.unit" default="단위"/>'		, type: 'string'},
			{name: 'WORK_SHOP_CODE'		, text: '<t:message code="system.label.product.workcenter" default="작업장"/>'		, type: 'string',comboType:'W'},
			{name: 'PRODT_Q'       		, text: '<t:message code="system.label.product.productionqty" default="생산량"/>'		, type: 'uniQty'},
			{name: 'PASS_Q'        		, text: '<t:message code="system.label.product.goodreceiptqty" default="양품입고수량"/>'	, type: 'uniQty'},
			{name: 'BAD_Q'         		, text: '<t:message code="system.label.product.defectreceiptqty" default="불량품입고수량"/>'	, type: 'uniQty'}
		]
	});		//End of Unilite.defineModel('Pmr130skrvModel', {
	
	// GroupField string type으로 변환
	function dateToString(v, record){
		return UniDate.safeFormat(v);
	  }

	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('pmr130skrvMasterStore1',{
			model: 'Pmr130skrvModel',
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
                	   read: 'pmr130skrvService.selectList'                	
                }
            },
			loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();	
				
				var temp = UniDate.getDbDateStr(panelSearch.getValue('PRODT_DATE')).substring(0, 6) + '01';
				var lastDay = (new Date(temp.substring(0,4), temp.substring(4,6), 0)).getDate();   // 해당 날짜의 마지막날자 구하기 new Date('년도' , '월' , 0 ).getDate()
				var to_date = UniDate.getDbDateStr(panelSearch.getValue('PRODT_DATE')).substring(0, 6) + lastDay;
				
				param.PRODT_DATE_FR =  temp;
				param.PRODT_DATE_TO =  to_date;

				console.log( param );
				this.load({
					params : param
				});
			}
			/*,groupField: 'ITEM_NAME'*/	
	});
	

	
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
	            panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
        },
		items: [{	
			title: '<t:message code="system.label.product.basisinfo" default="기본정보"/>', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{
	        	fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
	        	name:'DIV_CODE', 
	        	xtype: 'uniCombobox', 
	        	comboType: 'BOR120' ,
	        	allowBlank:false,
	        	value : UserInfo.divCode,
	        	listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('DIV_CODE', newValue);
							panelSearch.setValue('WORK_SHOP_CODE','');
						}
					}
	        },{
	        	fieldLabel:'<t:message code="system.label.product.workmonth" default="작업월"/>',
	        	xtype: 'uniMonthfield',
	        	name: 'PRODT_DATE',
	        	allowBlank:false,
	        	value: new Date(),
	        	listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('PRODT_DATE', newValue);
						}
					}
			},{
				fieldLabel:'<t:message code="system.label.product.workcenter" default="작업장"/>',
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
				Unilite.popup('DIV_PUMOK',{ // 20210826 추가: 품목 조회조건 정규화
			    	fieldLabel: '<t:message code="system.label.product.item" default="품목"/>', 
			    	textFieldWidth: 170, 
			    	validateBlank: false, 
			    	valueFieldName: 'ITEM_CODE_FR',
	        		textFieldName:'ITEM_NAME_FR',
	        		listeners: {
						onValueFieldChange:function( elm, newValue, oldValue) {
							panelResult.setValue('ITEM_CODE_FR', newValue);
							
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('ITEM_NAME_FR', '');
								panelSearch.setValue('ITEM_NAME_FR', '');
							}
						},
						onTextFieldChange:function( elm, newValue, oldValue) {
							panelResult.setValue('ITEM_NAME_FR', newValue);
							
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('ITEM_CODE_FR', '');
								panelSearch.setValue('ITEM_CODE_FR', '');
							}
						},
						applyextparam: function(popup){							
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
			}),
				Unilite.popup('DIV_PUMOK',{ // 20210826 추가: 품목 조회조건 정규화
			    	fieldLabel: '~', 
			    	textFieldWidth: 170, 
			    	validateBlank: false, 
			    	valueFieldName: 'ITEM_CODE_TO',
	        		textFieldName:'ITEM_NAME_TO',
	        		listeners: {
						onValueFieldChange:function( elm, newValue, oldValue) {						
							panelResult.setValue('ITEM_CODE_TO', newValue);
							
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('ITEM_NAME_TO', '');
								panelSearch.setValue('ITEM_NAME_TO', '');
							}
						},
						onTextFieldChange:function( elm, newValue, oldValue) {
							panelResult.setValue('ITEM_NAME_TO', newValue);
							
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('ITEM_CODE_TO', '');
								panelSearch.setValue('ITEM_CODE_TO', '');
							}
						},
						applyextparam: function(popup){							
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
				})
	        ]
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
    });		// End of var panelSearch = Unilite.createSearchForm('searchForm',{    
    
    var panelResult = Unilite.createSimpleForm('panelResultForm', {
		region: 'north',
		layout : {type : 'uniTable', columns : 5},
		padding:'1 1 1 1',
		border:true,
	    	items: [{
	        	fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
	        	name:'DIV_CODE', 
	        	xtype: 'uniCombobox', 
	        	comboType: 'BOR120' ,
	        	allowBlank:false,
	        	value : UserInfo.divCode,
	        	listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE', newValue);
					panelResult.setValue('WORK_SHOP_CODE','');
					}
				}
	        },{
	        	fieldLabel:'<t:message code="system.label.product.workmonth" default="작업월"/>',
	        	xtype: 'uniMonthfield',
	        	name: 'PRODT_DATE',
	        	allowBlank:false,
	        	value: new Date(),
	        	listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('PRODT_DATE', newValue);
					}
				}
			},{
				fieldLabel:'<t:message code="system.label.product.workcenter" default="작업장"/>',
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
                        if(!Ext.isEmpty(panelResult.getValue('DIV_CODE'))){
                            store.filterBy(function(record){
                                return record.get('option') == panelResult.getValue('DIV_CODE');
                            });
                            prStore.filterBy(function(record){
                                return record.get('option') == panelResult.getValue('DIV_CODE');
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
				Unilite.popup('DIV_PUMOK',{ // 20210826 추가: 품목 조회조건 정규화
			    	fieldLabel: '<t:message code="system.label.product.item" default="품목"/>', 
			    	textFieldWidth: 170, 
			    	validateBlank: false, 
			    	valueFieldName: 'ITEM_CODE_FR',
	        		textFieldName:'ITEM_NAME_FR',
	        		listeners: {
						onValueFieldChange:function( elm, newValue, oldValue) {
							panelSearch.setValue('ITEM_CODE_FR', newValue);
							
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('ITEM_NAME_FR', '');
								panelSearch.setValue('ITEM_NAME_FR', '');
							}
						},
						onTextFieldChange:function( elm, newValue, oldValue) {
							panelSearch.setValue('ITEM_NAME_FR', newValue);
							
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('ITEM_CODE_FR', '');
								panelSearch.setValue('ITEM_CODE_FR', '');
							}
						},
						applyextparam: function(popup){							
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
			}),
				Unilite.popup('DIV_PUMOK',{ // 20210826 추가: 품목 조회조건 정규화
			    	fieldLabel: '~', 
			    	labelWidth: 15,
			    	textFieldWidth: 170, 
			    	validateBlank: false, 
			    	valueFieldName: 'ITEM_CODE_TO',
	        		textFieldName:'ITEM_NAME_TO',
	        		listeners: {
						onValueFieldChange:function( elm, newValue, oldValue) {						
							panelSearch.setValue('ITEM_CODE_TO', newValue);
							
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('ITEM_NAME_TO', '');
								panelSearch.setValue('ITEM_NAME_TO', '');
							}
						},
						onTextFieldChange:function( elm, newValue, oldValue) {
							panelSearch.setValue('ITEM_NAME_TO', newValue);
							
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('ITEM_CODE_TO', '');
								panelSearch.setValue('ITEM_CODE_TO', '');
							}
						},
						applyextparam: function(popup){							
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
			})]
    });
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid1 = Unilite.createGrid('pmr130skrvGrid1', {
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
//        tbar: [{
//        	text:'상세보기',
//        	handler: function() {
//        		var record = masterGrid.getSelectedRecord();
//	        	if(record) {
//	        		openDetailWindow(record);
//	        	}
//        	}
//        }],
    	features: [ 
    		{id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
    	    {id: 'masterGridTotal',    ftype: 'uniSummary', 	    showSummaryRow: false} 
    	],
        columns: [	 
        	{dataIndex: 'DIV_CODE'      		 , width: 0,	hidden: true}, 			
			{dataIndex: 'ITEM_CODE'     		 , width: 125}, 			
			{dataIndex: 'ITEM_NAME'     		 , width: 173}, 			
			{dataIndex: 'SPEC'          		 , width: 173},  			
			{dataIndex: 'STOCK_UNIT'    		 , width: 86 , align:'center'},  			
			{dataIndex: 'WORK_SHOP_CODE'		 , width: 126},  			
			{dataIndex: 'PRODT_Q'       		 , width: 112},  			
			{dataIndex: 'PASS_Q'        		 , width: 112},  			
			{dataIndex: 'BAD_Q'         		 , width: 112}  			
        ] 
    });		//End of var masterGrid1 = Unilite.createGrid('pmr130skrvGrid1', {

    Unilite.Main({
		borderItems:[{
         region:'center',
         layout: 'border',
         border: false,
         items:[
            masterGrid1, panelResult
         ]
      },
         panelSearch
      ],
		id: 'pmr130skrvApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			
			panelSearch.setValue('PRODT_DATE',new Date());
			panelResult.setValue('PRODT_DATE',new Date());
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
	});		//End of Unilite.Main({
};
</script>
