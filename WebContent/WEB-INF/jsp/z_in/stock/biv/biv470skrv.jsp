<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="biv470skrv"  >
	
	<t:ExtComboStore comboType="BOR120" pgmId="biv470skrv"/> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B020" /> 				<!-- 수불타입 -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList"/>		<!--창고-->
	<t:ExtComboStore comboType="AU" comboCode="B036" />					<!-- 수불방법 -->
	<t:ExtComboStore comboType="AU" comboCode="B031" />					<!-- 생성경로 -->
	<t:ExtComboStore comboType="AU" comboCode="B005" />					<!-- 수불처유형 -->
	<t:ExtComboStore comboType="AU" comboCode="B035" />					<!-- 수불타입 -->
	
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />	
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	/**
	 *   Model 정의 
	 * @type 
	 */

	Unilite.defineModel('Biv470skrvModel', {
	    fields: [  	 
	    	{name: 'COMP_CODE'				, text: '<t:message code="system.label.inventory.companycode" default="법인코드"/>',	type:'string'},
	    	{name: 'DIV_CODE'					, text: '<t:message code="system.label.inventory.division" default="사업장"/>',		type:'string'},
	    	{name: 'WH_NAME'					, text: '<t:message code="" default="창고"/>',	type:'string'},
	    	{name: 'ITEM_CODE'					, text: '<t:message code="system.label.inventory.item" default="품목"/>',	type:'string'},
	    	{name: 'ITEM_NAME'				, text: '품목명',		type:'string'},
	    	{name: 'LOT_NO'						, text: 'LOT NO',			type:'string'},
	    	{name: 'STOCK_UNIT'				, text: '재고단위',			type:'string'},	    	
	    	{name: 'STOCK_Q'					, text: '현재고량',		type:'uniQty'},
	    	{name: 'AVERAGE_P' 	 		 	, text: '<t:message code="system.label.inventory.averageprice" default="평균단가"/>'		,type: 'uniUnitPrice'},
	    	{name: 'STOCK_I'						, text: '재고금액', type:'uniPrice'},  
	    	{name: 'GOOD_STOCK_Q'      	, text: '<t:message code="system.label.inventory.goodqty" default="양품수량"/>'  ,type: 'uniQty'},      
	    	{name: 'BAD_STOCK_Q' 	 		, text: '<t:message code="system.label.inventory.defectqty" default="불량수량"/>'		,type: 'uniQty'},	
	    	{name: 'EXP_DATE'   					, text: '유통기한'  , type: 'uniDate'},

		]
	});
	
	var directMasterStore = Unilite.createStore('biv470skrvMasterStore1',{
			model: 'Biv470skrvModel',
			uniOpt : {
            	isMaster: 	false,			// 상위 버튼 연결 
            	editable: 	false,			// 수정 모드 사용 
            	deletable:	false,			// 삭제 가능 여부 
	            useNavi : 	false			// prev | newxt 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {			
                	read: 'biv470skrvService.selectList'                	
                }
            }, 
            loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();
				console.log( param );
				this.load({
					params : param
				});
			},
			groupField: 'WH_NAME'
	});
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm',{
		title: '검색조건',         
		defaultType: 'uniSearchSubPanel',
		collapsed: true,
        listeners: {
	        collapse: function () {
	        	panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
	    },
		items: [{	
			title: '<t:message code="system.label.inventory.basisinfo" default="기본정보"/>', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
			    items: [{
					fieldLabel: '<t:message code="system.label.inventory.division" default="사업장"/>',
					name:'DIV_CODE',
					xtype: 'uniCombobox',
					comboType:'BOR120',
					comboCode:'B001',
					child:'WH_CODE',
					allowBlank:false,
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								panelResult.setValue('DIV_CODE', newValue);
							}
						}
				},{ 
				    fieldLabel: '기준일',
				    xtype: 'uniDatefield',
				    name: 'EXEC_DATE',
				    value: UniDate.get('today'),
				    listeners: {
				        change: function(field, newValue, oldValue, eOpts) {                        
				        	panelResult.setValue('EXEC_DATE', newValue);
				        }
				    }
				},{
					fieldLabel: '계정', 
					name:'ITEM_ACCOUNT',
					xtype: 'uniCombobox',
					comboType:'AU',
					comboCode:'B020',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('ITEM_ACCOUNT', newValue);
						}
					}
				},
				Unilite.popup('DIV_PUMOK',{ 
						fieldLabel: '<t:message code="system.label.inventory.item" default="품목"/>', 
						valueFieldName: 'ITEM_CODE', 
						textFieldName: 'ITEM_NAME',
						//colspan: 2,
						listeners: {
							onSelected: {
								fn: function(records, type) {
									panelResult.setValue('ITEM_CODE', panelSearch.getValue('ITEM_CODE'));
									panelResult.setValue('ITEM_NAME', panelSearch.getValue('ITEM_NAME'));				 																							
								},
								scope: this
							},
							onClear: function(type)	{
								panelResult.setValue('ITEM_CODE', '');
								panelResult.setValue('ITEM_NAME', '');
							},
							onClear: function(type)	{
								panelResult.setValue('ITEM_CODE', '');
								panelResult.setValue('ITEM_NAME', '');
							},
							applyextparam: function(popup){							
								popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
							}
						}
				}),{
					fieldLabel: '<t:message code="system.label.inventory.warehouse" default="창고"/>',
					name:'WH_CODE',
						xtype: 'uniCombobox',
						store: Ext.data.StoreManager.lookup('whList'),
						listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('WH_CODE', newValue);
						}
					}
				},{
					xtype: 'radiogroup',		            		
				    fieldLabel: '유통기한',						            		
				    labelWidth: 90,
				    items: [{
						boxLabel: '6개월',
						width: 60,
						name: 'EXP_FLAG',
						inputValue: '180',
						checked: true
					},{
						boxLabel: '12개월',
						width: 60,
						name: 'EXP_FLAG',
						inputValue: '365'
					}],
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {	
								panelResult.getField('EXP_FLAG').setValue(newValue.EXP_FLAG);
							}
						}
				}]
				}],
				setAllFieldsReadOnly: function(b){
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
    });
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
            		fieldLabel: '<t:message code="system.label.inventory.division" default="사업장"/>',
            		name:'DIV_CODE',
            		xtype: 'uniCombobox',
            		comboType:'BOR120',
            		comboCode:'B001',
					child:'WH_CODE',
            		allowBlank:false,
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								panelSearch.setValue('DIV_CODE', newValue);
							}
						}
            	},{ 
                    fieldLabel: '기준일',
                    xtype: 'uniDatefield',
                    name: 'EXEC_DATE',
                    value: UniDate.get('today'),
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                            panelSearch.setValue('EXEC_DATE', newValue);
                        }
                    }
                },
	            Unilite.popup('DIV_PUMOK',{ 
						fieldLabel: '<t:message code="system.label.inventory.item" default="품목"/>', 
						valueFieldName: 'ITEM_CODE', 
						textFieldName: 'ITEM_NAME',
						//colspan: 2,
						listeners: {
							onSelected: {
								fn: function(records, type) {
									panelSearch.setValue('ITEM_CODE', panelResult.getValue('ITEM_CODE'));
									panelSearch.setValue('ITEM_NAME', panelResult.getValue('ITEM_NAME'));				 																							
								},
								scope: this
							},
							onClear: function(type)	{
								panelSearch.setValue('ITEM_CODE', '');
								panelSearch.setValue('ITEM_NAME', '');
							},
							onClear: function(type)	{
								panelSearch.setValue('ITEM_CODE', '');
								panelSearch.setValue('ITEM_NAME', '');
							},
							applyextparam: function(popup){							
								popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
							}
						}
				}),{
            		fieldLabel: '계정', 
            		name:'ITEM_ACCOUNT',
            		xtype: 'uniCombobox',
            		comboType:'AU',
            		comboCode:'B020',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('ITEM_ACCOUNT', newValue);
						}
					}
            	},{
					fieldLabel: '<t:message code="system.label.inventory.warehouse" default="창고"/>',
					name:'WH_CODE',
		       		xtype: 'uniCombobox',
		       		store: Ext.data.StoreManager.lookup('whList'),
		       		listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('WH_CODE', newValue);
						}
					}
			    },{
					xtype: 'radiogroup',		            		
				    fieldLabel: '유통기한',						            		
				    labelWidth: 90,
				    items: [{
			    		boxLabel: '6개월',
			    		width: 60,
			    		name: 'EXP_FLAG',
			    		inputValue: '180',
			    		checked: true
			    	},{
			    		boxLabel: '12개월',
			    		width: 60,
			    		name: 'EXP_FLAG',
			    		inputValue: '365'
			    	}],
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {	
								panelSearch.getField('EXP_FLAG').setValue(newValue.EXP_FLAG);
							}
						}
				}]
	});
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('biv470skrvGrid1', {
    	region: 'center' ,
        layout : 'fit',
        store : directMasterStore, 
        uniOpt:{	
        	useGroupSummary    : true,
    		useLiveSearch      : true,
			useContextMenu     : true,
			useMultipleSorting : true,
			useRowNumberer     : false,
			expandLastColumn   : false,
    		filter: {
				useFilter  : false,
				autoCreate : false
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
    	features: [{
    		id: 'masterGridSubTotal', 
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: true 
    	},{
    		id: 'masterGridTotal',
    		ftype: 'uniSummary',
    		showSummaryRow: true
    	}],
        columns:  [  
        	{dataIndex: 'COMP_CODE'		  		, width: 100 , hidden: true}, 				
    			{dataIndex: 'DIV_CODE'		 			, width: 100 , hidden: true},				
    			{dataIndex: 'WH_NAME'		  				, width: 150,
    			summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
		       return Unilite.renderSummaryRow(summaryData, metaData, '', '총계');
        	}}, 				
    			{dataIndex: 'ITEM_CODE'		  			, width: 100}, 				
    			{dataIndex: 'ITEM_NAME'		  			, width: 140}, 				
    			{dataIndex: 'LOT_NO'			  			, width: 100},
    			{dataIndex: 'STOCK_UNIT'			  			, width: 100},    			
    			{dataIndex: 'STOCK_Q'		  				, width: 100	, summaryType: 'sum'}, 				
          {dataIndex: 'GOOD_STOCK_Q'     	, width: 100	, summaryType: 'sum'},
          {dataIndex: 'BAD_STOCK_Q' 	  		, width: 100	, summaryType: 'sum'},
    			{dataIndex: 'AVERAGE_P' 	 	  			, width: 100},			
    			{dataIndex: 'STOCK_I'		  				, width: 100	, summaryType: 'sum'}, 
          {dataIndex: 'EXP_DATE'   	  				, width: 100}

          ] 
    });
    
	
    Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				panelResult,masterGrid
			]
		},
			panelSearch  	
		],
		id  : 'biv470skrvApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('EXEC_DATE',UniDate.get("today"));
			panelSearch.getField('EXP_FLAG').setValue('6');
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('EXEC_DATE',UniDate.get("today"));
			panelResult.getField('EXP_FLAG').setValue('6');
			UniAppManager.setToolbarButtons('detail',true);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown : function()	{
			UniAppManager.setToolbarButtons(['reset' ], true);
			masterGrid.getStore().loadStoreRecords();	
		},
		onResetButtonDown:function() {
        	panelSearch.clearForm();
        	panelResult.clearForm();
        	masterGrid.reset();
        	masterGrid.getStore().clearData();
        	this.fnInitBinding();
        }
	});

}


</script>
