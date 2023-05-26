<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bid110skrv"  >	
	<t:ExtComboStore comboType="BOR120" pgmId="bid110skrv"/> 				<!-- 사업장 -->  
	<t:ExtComboStore comboType="AU" comboCode="S010" /> <!--영업담당 -->
	<t:ExtComboStore comboType="AU" comboCode="M032" /> <!--매입유형 -->
	<t:ExtComboStore comboType="AU" comboCode="YP09" /> <!--판매형태 -->
	<t:ExtComboStore comboType="AU" comboCode="B055" /> <!-- 거래처분류 -->  
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList"/>	<!--창고-->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />    
	<!-- 대분류 -->
	<!-- 중분류 -->
	<!-- 소분류 -->
</t:appConfig>
<script type="text/javascript" >

function appMain() { 
	var purchaseStore = Unilite.createStore('bid100skrvpurchaseStore', {
	    fields: ['text', 'value'],
		data :  [
			        {'text':'위탁'		, 'value':'1'},
			        {'text':'현매'		, 'value':'2'}
	    		]
	});
	/**
	 *   Model 정의 
	 * @type  
	 */
	Unilite.defineModel('bid110skrvModel', {
	    fields: [
	    	{name: 'DIV_CODE'			,text: '<t:message code="system.label.inventory.division" default="사업장"/>'		,type: 'string', xtype: 'uniCombobox', comboType: 'BOR120'},
	    	{name: 'WH_CODE'			,text: '<t:message code="system.label.inventory.warehouse" default="창고"/>'		 	,type: 'string', xtype: 'uniCombobox', store: Ext.data.StoreManager.lookup('whList')},
	    	{name: 'ITEM_CODE'			,text: '<t:message code="system.label.inventory.item" default="품목"/>'		,type: 'string'},
	    	{name: 'ITEM_NAME'			,text: '품명'			,type: 'string'},
	    	{name: 'CUSTOM_CODE'		,text: '매입처코드'		,type: 'string'},
	    	{name: 'CUSTOM_NAME'		,text: '매입처명'		,type: 'string'},
	    	{name: 'PURCHASE_TYPE'		,text: '매입유형'		,type: 'string', store: Ext.data.StoreManager.lookup('bid100skrvpurchaseStore')},
	    	{name: 'SALES_TYPE'			,text: '판매형태'		,type: 'string', comboType: 'AU', comboCode: 'YP09'},
	    	{name: 'SALE_P'				,text: '판매가'		,type: 'uniPrice'}, 
	    	{name: 'PURCHASE_P'			,text: '매입가'		,type: 'uniUnitPrice'},
	    	{name: 'PURCHASE_RATE'		,text: '매입율'		,type: 'uniPercent'},
	    	{name: 'STOCK_Q'			,text: '현재고'		,type: 'uniPrice'},
	    	{name: 'STOCK_COST'			,text: '재고원가'		,type: 'uniPrice'}
	    ]
	});
	  
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('bid110skrvMasterStore1',{
		model: 'bid110skrvModel',
		uniOpt: {
        	isMaster: 	true,		// 상위 버튼 연결 
        	editable: 	false,		// 수정 모드 사용 
        	deletable: 	false,		// 삭제 가능 여부 
	    	useNavi: 	false		// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
        	type: 'direct',
        	api: {			
            	read: 'bid110skrvService.selectList'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('bid110skrvpanelSearch').getValues();      
			var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode = UserInfo.deptCode;	//부서코드
			if(authoInfo == "5" && Ext.isEmpty(Ext.getCmp('bid110skrvpanelSearch').getValue('DEPT_CODE'))){
				param.DEPT_CODE = deptCode;
			}
			console.log( param );
			this.load({
				params: param
			});
		},
		groupField: 'ITEM_NAME'	
	});

 	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('bid110skrvpanelSearch',{		// 메인
		collapsed: UserInfo.appOption.collapseLeftSearch,
		title: '검색조건',
    	defaultType: 'uniSearchSubPanel',
    	listeners: {
        	collapse: function () {
            	panelResult.show();
        	},
        	expand: function() {
        		panelResult.hide();
        	}
    	},
		items: [{	
			title: '기본정보', 	
			itemId: 'search_panel1',
   			layout: {type: 'uniTable', columns: 1},
   			defaultType: 'uniTextfield',
    		items: [{
				    fieldLabel: '<t:message code="system.label.inventory.division" default="사업장"/>',
				    name:'DIV_CODE',
				    xtype: 'uniCombobox',
				    comboType:'BOR120',
				    allowBlank:false,
				    //holdable: 'hold',
					child:'WH_CODE',
				    value: UserInfo.divCode,
				    listeners: {
				    	change: function(field, newValue, oldValue, eOpts) {      
				      		panelResult.setValue('DIV_CODE', newValue);
				     	}
				    }
			   },Unilite.popup('DEPT', { 
				fieldLabel: '부서', 
				valueFieldName: 'DEPT_CODE',
		   	 	textFieldName: 'DEPT_NAME',
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('WH_CODE',records[0]["WH_CODE"]);
							panelResult.setValue('WH_CODE',records[0]["WH_CODE"]);
							panelResult.setValue('DEPT_CODE', panelSearch.getValue('DEPT_CODE'));
							panelResult.setValue('DEPT_NAME', panelSearch.getValue('DEPT_NAME'));
                    	},
						scope: this
					},
					onClear: function(type)	{
								panelResult.setValue('DEPT_CODE', '');
								panelResult.setValue('DEPT_NAME', '');
					},
						applyextparam: function(popup){							
							var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
							var deptCode = UserInfo.deptCode;	//부서정보
							var divCode = '';					//사업장
							
							if(authoInfo == "A"){	//자기사업장	
								popup.setExtParam({'DEPT_CODE': ""});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
								
							}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
								popup.setExtParam({'DEPT_CODE': ""});
								popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
								
							}else if(authoInfo == "5"){		//부서권한
								popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							}
						}
				}
			}),{
				    fieldLabel: '<t:message code="system.label.inventory.warehouse" default="창고"/>',
				    name: 'WH_CODE', 
				    xtype: 'uniCombobox', 
				    store: Ext.data.StoreManager.lookup('whList'),
//				    allowBlank: false,
				    //holdable: 'hold',
				    listeners: {
				    	change: function(field, newValue, oldValue, eOpts) {      
				      		panelResult.setValue('WH_CODE', newValue);
				     	}
				    }
			   },{
		     		fieldLabel: '<t:message code="system.label.inventory.majorgroup" default="대분류"/>',
		     		name: 'TXTLV_L1',
		     		xtype: 'uniCombobox',
		     		child: 'TXTLV_L2',
		     		store: Ext.data.StoreManager.lookup('itemLeve1Store'),
		     		change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('TXTLV_L1', newValue);
					}
		     	},{
		     		fieldLabel: '<t:message code="system.label.inventory.middlegroup" default="중분류"/>',
		     		name: 'TXTLV_L2', 
		     		xtype: 'uniCombobox',
		     		child: 'TXTLV_L3',
		     		store: Ext.data.StoreManager.lookup('itemLeve2Store'),
		     		change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('TXTLV_L2', newValue);
					}
		     	},{
				    fieldLabel: '<t:message code="system.label.inventory.minorgroup" default="소분류"/>',
				    name: 'TXTLV_L3', 
				    xtype: 'uniCombobox',  
				    store: Ext.data.StoreManager.lookup('itemLeve3Store'),
		            parentNames:['TXTLV_L1','TXTLV_L2'],
		            levelType:'ITEM',
		 			listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('TXTLV_L3', newValue);
						}
					} 
				},
				Unilite.popup('ITEM', {
						fieldLabel: '품목', 
						valueFieldName: 'ITEM_CODE',
			    		textFieldName: 'ITEM_NAME', 
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
								panelSearch.setValue('ITEM_CODE', '');
								panelSearch.setValue('ITEM_NAME', '');
							},
							applyextparam: function(popup){							
								popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
							}
						}
				}),
				Unilite.popup('ITEM',{
						fieldLabel: '~',  
						valueFieldName: 'ITEM_CODE2',
			    		textFieldName: 'ITEM_NAME2',
						validateBlank:false,
						listeners: {
							onSelected: {
								fn: function(records, type) {
									panelResult.setValue('ITEM_CODE2', panelSearch.getValue('ITEM_CODE2'));
									panelResult.setValue('ITEM_NAME2', panelSearch.getValue('ITEM_NAME2'));				 																							
								},
								scope: this
							},
							onClear: function(type)	{
								panelResult.setValue('ITEM_CODE2', '');
								panelResult.setValue('ITEM_NAME2', '');
							},
							onClear: function(type)	{
								panelSearch.setValue('ITEM_CODE', '');
								panelSearch.setValue('ITEM_NAME', '');
							},
							applyextparam: function(popup){							
								popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
							}
						}
				}),{
            	fieldLabel: '현재고 0 포함',
            	name: 'STOCK_ZERO',
//				id: 'FLOOR',
//				value: 'Y',
				xtype: 'checkbox',
				labelWidth: 200,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('STOCK_ZERO', newValue);
					}
				}
    		}
				/*{
		    		xtype: 'uniCheckboxgroup',	
		    		padding: '0 0 0 0',
		    		fieldLabel: ' ',
		    		id: 'ZERO_CK',
		    		items: [{
		    			boxLabel: '현재고 0 포함',
		    			width: 120,
		    			name: 'STOCK_ZERO',
		    			inputValue: 'Y',
		    			uncheckedValue: 'N',
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								panelResult.setValue('STOCK_ZERO', newValue);
							}
						}
		    		}]
		        }*/
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
		      		//this.mask();
		      		var fields = this.getForm().getFields();
		      		Ext.each(fields.items, function(item) {
		       			if(Ext.isDefined(item.holdable) ) {
		         			if (item.holdable == 'hold') {
		         				item.setReadOnly(true); 
		        			}
		       			} 
		       			if(item.isPopupField) {
		        			var popupFC = item.up('uniPopupField') ;       
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
		      		if(Ext.isDefined(item.holdable) ) {
		        		if (item.holdable == 'hold') {
		        			item.setReadOnly(false);
		       			}
		      		} 
		      		if(item.isPopupField) {
		       			var popupFC = item.up('uniPopupField') ; 
		       			if(popupFC.holdable == 'hold' ) {
		        			item.setReadOnly(false);
		      			}
		      		}
		     	})
		    }
		    return r;
		}
	});		// end of var panelSearch = Unilite.createSearchPanel('bid110skrvpanelSearch',{		// 메인
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
	    items: [{	
	    	xtype:'container',
	    	padding:'0 5 5 5',
	        defaultType: 'uniTextfield',
	        layout: {type: 'uniTable', columns : 3},
	        items: [{
				    fieldLabel: '<t:message code="system.label.inventory.division" default="사업장"/>',
				    name:'DIV_CODE',
				    xtype: 'uniCombobox',
				    comboType:'BOR120',
				    allowBlank:false,
				    //holdable: 'hold',
					child:'WH_CODE',
				    value: UserInfo.divCode,
				    listeners: {
				    	change: function(field, newValue, oldValue, eOpts) {      
				      		panelSearch.setValue('DIV_CODE', newValue);
				     	}
				    }
			   },Unilite.popup('DEPT', { 
				fieldLabel: '부서', 
				valueFieldName: 'DEPT_CODE',
		   	 	textFieldName: 'DEPT_NAME',
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('WH_CODE',records[0]["WH_CODE"]);
							panelResult.setValue('WH_CODE',records[0]["WH_CODE"]);
							panelSearch.setValue('DEPT_CODE', panelResult.getValue('DEPT_CODE'));
							panelSearch.setValue('DEPT_NAME', panelResult.getValue('DEPT_NAME'));
                    	},
						scope: this
					},
					onClear: function(type)	{
								panelSearch.setValue('DEPT_CODE', '');
								panelSearch.setValue('DEPT_NAME', '');
					},
						applyextparam: function(popup){							
							var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
							var deptCode = UserInfo.deptCode;	//부서정보
							var divCode = '';					//사업장
							
							if(authoInfo == "A"){	//자기사업장	
								popup.setExtParam({'DEPT_CODE': ""});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
								
							}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
								popup.setExtParam({'DEPT_CODE': ""});
								popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
								
							}else if(authoInfo == "5"){		//부서권한
								popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							}
						}
				}
			}),{
				    fieldLabel: '<t:message code="system.label.inventory.warehouse" default="창고"/>',
				    name: 'WH_CODE', 
				    xtype: 'uniCombobox', 
				    store: Ext.data.StoreManager.lookup('whList'),
//				    allowBlank: false,
				    //holdable: 'hold',
				    listeners: {
				    	change: function(field, newValue, oldValue, eOpts) {      
				      		panelSearch.setValue('WH_CODE', newValue);
				     	}
				    }
			   },{
		     		fieldLabel: '<t:message code="system.label.inventory.majorgroup" default="대분류"/>',
		     		name: 'TXTLV_L1',
		     		xtype: 'uniCombobox',  
		     		store: Ext.data.StoreManager.lookup('itemLeve1Store'), 
					child: 'TXTLV_L2',
		 			listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('TXTLV_L1', newValue);
						}
					} 
		     	},{
		     		fieldLabel: '<t:message code="system.label.inventory.middlegroup" default="중분류"/>',
		     		name: 'TXTLV_L2', 
		     		xtype: 'uniCombobox',  
		     		store: Ext.data.StoreManager.lookup('itemLeve2Store'),
					child: 'TXTLV_L3',
		 			listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('TXTLV_L2', newValue);
						}
					} 
		     	},{
				    fieldLabel: '<t:message code="system.label.inventory.minorgroup" default="소분류"/>',
				    name: 'TXTLV_L3', 
				    xtype: 'uniCombobox',  
				    store: Ext.data.StoreManager.lookup('itemLeve3Store'),
		            parentNames:['TXTLV_L1','TXTLV_L2'],
		            levelType:'ITEM',
		 			listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('TXTLV_L3', newValue);
						}
					} 
				},
				Unilite.popup('DIV_PUMOK',{ 
			        	fieldLabel: '품목',
			        	valueFieldName: 'ITEM_CODE', 
						textFieldName: 'ITEM_NAME', 
			        	listeners: {
							onSelected: {
								fn: function(records, type) {
									console.log('records : ', records);
									panelSearch.setValue('ITEM_CODE', panelResult.getValue('ITEM_CODE'));
									panelSearch.setValue('ITEM_NAME', panelResult.getValue('ITEM_NAME'));	
		                    	},
								scope: this
							},
							onClear: function(type)	{
								panelSearch.setValue('ITEM_CODE', '');
								panelSearch.setValue('ITEM_NAME', '');
							},
							applyextparam: function(popup){							
								popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
							}
						}
			   }),
				Unilite.popup('DIV_PUMOK',{ 
			        	fieldLabel: '~',
			        	valueFieldName: 'ITEM_CODE', 
						textFieldName: 'ITEM_NAME', 
						labelWidth: 15,
			        	listeners: {
							onSelected: {
								fn: function(records, type) {
									console.log('records : ', records);
									panelSearch.setValue('ITEM_CODE', panelResult.getValue('ITEM_CODE'));
									panelSearch.setValue('ITEM_NAME', panelResult.getValue('ITEM_NAME'));	
		                    	},
								scope: this
							},
							onClear: function(type)	{
								panelSearch.setValue('ITEM_CODE', '');
								panelSearch.setValue('ITEM_NAME', '');
							},
							applyextparam: function(popup){							
								popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
							}
						}
			   }),{
            	fieldLabel: '현재고 0 포함',
            	name: 'STOCK_ZERO',
//				id: 'FLOOR',
//				value: 'Y',
				xtype: 'checkbox',
				labelWidth: 200,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('STOCK_ZERO', newValue);
					}
				}
    		}
				/*{
		    		xtype: 'uniCheckboxgroup',	
		    		padding: '0 0 0 0',
		    		fieldLabel: ' ',
		    		id: 'ZERO_CK2',
		    		items: [{
		    			boxLabel: '현재고 0 포함',
		    			width: 120,
		    			name: 'STOCK_ZERO',
		    			inputValue: 'Y',
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								panelSearch.setValue('STOCK_ZERO', newValue);
							}
						}
		    		}]
		        }*/
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
		      		//this.mask();
		      		var fields = this.getForm().getFields();
		      		Ext.each(fields.items, function(item) {
		       			if(Ext.isDefined(item.holdable) ) {
		         			if (item.holdable == 'hold') {
		         				item.setReadOnly(true); 
		        			}
		       			} 
		       			if(item.isPopupField) {
		        			var popupFC = item.up('uniPopupField') ;       
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
		      		if(Ext.isDefined(item.holdable) ) {
		        		if (item.holdable == 'hold') {
		        			item.setReadOnly(false);
		       			}
		      		} 
		      		if(item.isPopupField) {
		       			var popupFC = item.up('uniPopupField') ; 
		       			if(popupFC.holdable == 'hold' ) {
		        			item.setReadOnly(false);
		      			}
		      		}
		     	})
		    }
		    return r;
		}
    });		// end of var panelResult = Unilite.createSearchForm('resultForm',{

    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('bid110skrvGrid', {
    	region: 'center',
		layout: 'fit',
        uniOpt: {	expandLastColumn: true,
        			useRowNumberer: false,
                    useMultipleSorting: true
        },
    	store: directMasterStore,
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: true} ],
       	columns: [        
       		{dataIndex: 'DIV_CODE'				, width: 80, hidden: true},
			{dataIndex: 'WH_CODE'				, width: 80, hidden: true}, 				
			{dataIndex: 'ITEM_CODE'				, width: 110, locked: true, align:'center',
			summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
            	}}, 				
			{dataIndex: 'ITEM_NAME'				, width: 280, locked: true}, 
        	{dataIndex: 'CUSTOM_CODE'			, width: 100}, 				
			{dataIndex: 'CUSTOM_NAME'			, width: 150},	 				
			{dataIndex: 'PURCHASE_TYPE'			, width: 80}, 				
			{dataIndex: 'SALES_TYPE'			, width: 80}, 				
			{dataIndex: 'SALE_P'				, width: 90, summaryType: 'average'}, 				
			{dataIndex: 'PURCHASE_P'			, width: 90, summaryType: 'average'}, 					
			{dataIndex: 'PURCHASE_RATE'			, width: 90, summaryType: 'average'}, 				
			{dataIndex: 'STOCK_Q'				, width: 90, summaryType: 'sum'},
			{dataIndex: 'STOCK_COST'			, width: 90, summaryType: 'sum'}
		] 
    });	//End of var masterGrid = Unilite.createGrid('bid110skrvGrid', {
    
    /**
     * Master Grid2 정의(Grid Panel)
     * @type 
     */
    
	Unilite.Main ({
		borderItems: [{
         region:'center',
         layout: 'border',
         border: false,
         items:[
           	masterGrid, panelResult
         ]
      	},
      	panelSearch     
      	],
		id: 'bid110skrvApp',
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons(['reset','prev', 'next'], true);
			UniAppManager.setToolbarButtons('reset', false); 
			this.setDefault();
			bid110skrvService.userWhcode({}, function(provider, response)	{
				if(!Ext.isEmpty(provider)){
					panelSearch.setValue('WH_CODE',provider['WH_CODE']);
					panelResult.setValue('WH_CODE',provider['WH_CODE']);
				}
			})
		},
		setDefault: function() {
        	panelSearch.setValue('DIV_CODE',UserInfo.divCode);
        	panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.getForm().wasDirty = false;
			panelSearch.resetDirtyStatus();											
			UniAppManager.setToolbarButtons('save', false);
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelSearch.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
			masterGrid.reset();
			panelResult.clearForm();
			this.fnInitBinding();
		},
		onQueryButtonDown: function()	{	
			if(panelSearch.setAllFieldsReadOnly(true) == false){
				return false;
			}
			if(panelResult.setAllFieldsReadOnly(true) == false){
				return false;
			}
			masterGrid.getStore().loadStoreRecords();
   			var viewNormal = masterGrid.getView();
   			console.log("viewNormal : ",viewNormal);
			UniAppManager.setToolbarButtons('reset', true); 
		},
		onResetButtonDown: function() {		// 초기화
			this.suspendEvents();
			panelSearch.clearForm();
			masterGrid.reset();
			panelResult.clearForm();
			this.fnInitBinding();
			panelSearch.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
			directMasterStore.clearData();
		}
	});
};
</script>
