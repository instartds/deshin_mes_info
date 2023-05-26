<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bid100skrv"  >	
	<t:ExtComboStore comboType="BOR120"  pgmId="bid100skrv"/> 				<!-- 사업장 -->  
	<t:ExtComboStore comboType="AU" comboCode="S010" /> <!--영업담당 -->
	<t:ExtComboStore comboType="AU" comboCode="M032" /> <!--매입유형 -->
	<t:ExtComboStore comboType="AU" comboCode="YP09" /> <!--판매형태 -->
	<t:ExtComboStore comboType="AU" comboCode="B055" /> <!-- 거래처분류 -->
	<t:ExtComboStore comboType="AU" comboCode="B059" /> <!-- 과세구분 -->
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
	Unilite.defineModel('bid100skrvModel', {
	    fields: [
	    	{name: 'DIV_CODE'			,text: '<t:message code="system.label.inventory.division" default="사업장"/>'		,type: 'string', xtype: 'uniCombobox', comboType: 'BOR120'},
	    	{name: 'WH_CODE'			,text: '<t:message code="system.label.inventory.warehouse" default="창고"/>'		 	,type: 'string', xtype: 'uniCombobox', store: Ext.data.StoreManager.lookup('whList')},
	    	{name: 'CUSTOM_CODE'		,text: '매입처코드'		,type: 'string'},
	    	{name: 'CUSTOM_NAME'		,text: '매입처명'		,type: 'string'},
	    	{name: 'ITEM_CODE'			,text: '<t:message code="system.label.inventory.item" default="품목"/>'		,type: 'string'},
	    	{name: 'ITEM_NAME'			,text: '품명'			,type: 'string'},
	    	{name: 'PUBL_NM'			,text: '출판사'		,type: 'string'},
	    	{name: 'TAX_TYPE'			,text: '과세구분'		,type: 'string', comboType:'AU', comboCode:'B059'},
	    	{name: 'PURCHASE_TYPE'		,text: '매입유형'		,type: 'string', store: Ext.data.StoreManager.lookup('bid100skrvpurchaseStore')},
	    	{name: 'SALES_TYPE'			,text: '판매형태'		,type: 'string', comboType: 'AU', comboCode: 'YP09'},
	    	{name: 'SALE_BASIS_P'		,text: '판매가'		,type: 'uniUnitPrice'}, 
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
	var directMasterStore = Unilite.createStore('bid100skrvMasterStore1',{
		model: 'bid100skrvModel',
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
            	read: 'bid100skrvService.selectList'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('bid100skrvpanelSearch').getValues();      
			var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode = UserInfo.deptCode;	//부서코드
			if(authoInfo == "5" && Ext.isEmpty(Ext.getCmp('bid100skrvpanelSearch').getValue('DEPT_CODE'))){
				param.DEPT_CODE = deptCode;
			}
			console.log( param );
			this.load({
				params: param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				var count = masterGrid.getStore().getCount();
				if(count > 0) {	
					UniAppManager.setToolbarButtons(['print'], true);
				}
			}
		},
		groupField: 'CUSTOM_NAME'	
	});

 	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('bid100skrvpanelSearch',{		// 메인
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
				    //allowBlank:false,
				    //holdable: 'hold',
					child:'WH_CODE',
				    value: UserInfo.divCode,
				    listeners: {
				    	change: function(field, newValue, oldValue, eOpts) {      
				      		panelResult.setValue('DIV_CODE', newValue);
				     	},
				     	afterrender: function(field) {
				     		var divStore = field.getStore();
				     		divStore.insert(0, {"value":"", "option":null, "text":"전사"});
				     	}
				    }
			   },{
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
				    //allowBlank: false,
		     		store: Ext.data.StoreManager.lookup('itemLeve1Store'),
		     		change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('TXTLV_L1', newValue);
					}
		     	},{
		     		fieldLabel: '<t:message code="system.label.inventory.middlegroup" default="중분류"/>',
		     		name: 'TXTLV_L2', 
		     		xtype: 'uniCombobox',
		     		child: 'TXTLV_L3',
				    //allowBlank: false,
		     		store: Ext.data.StoreManager.lookup('itemLeve2Store'),
		     		change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('TXTLV_L2', newValue);
					}
		     	},{
				    fieldLabel: '<t:message code="system.label.inventory.minorgroup" default="소분류"/>',
				    name: 'TXTLV_L3', 
				    xtype: 'uniCombobox', 
				    //allowBlank: false, 
				    store: Ext.data.StoreManager.lookup('itemLeve3Store'),
		            parentNames:['TXTLV_L1','TXTLV_L2'],
		            levelType:'ITEM',
		 			listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('TXTLV_L3', newValue);
						}
					} 
				},
				Unilite.popup('CUST', {
						fieldLabel: '매입처', 
						valueFieldName: 'CUSTOM_CODE',
			    		textFieldName: 'CUSTOM_NAME', 
						listeners: {
							onSelected: {
								fn: function(records, type) {
									panelResult.setValue('CUSTOM_CODE', panelSearch.getValue('CUSTOM_CODE'));
									panelResult.setValue('CUSTOM_NAME', panelSearch.getValue('CUSTOM_NAME'));				 																							
								},
								scope: this
							},
							onClear: function(type)	{
								panelResult.setValue('CUSTOM_CODE', '');
								panelResult.setValue('CUSTOM_NAME', '');
							}
						}
				}),{
				fieldLabel: '고객분류', 
				name: 'AGENT_TYPE', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'B055',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('AGENT_TYPE', newValue);
						}
					}				
			},{
				xtype: 'radiogroup',		            		
				fieldLabel: '현재고 조건',					            		
				id: 'rdoSelect',
				items: [{
					boxLabel: '전체', 
					width: 50, 
					name: 'STOCK_ZERO',
					checked: true  
				},{
					boxLabel : '0만조회', 
					width: 70,
					inputValue: 'Y',
					name: 'STOCK_ZERO'
				},{
					boxLabel : '미포함', 
					width: 55,
					inputValue: 'N',
					name: 'STOCK_ZERO'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {			
						panelResult.getField('STOCK_ZERO').setValue(newValue.STOCK_ZERO);
					}
				}
		}
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
	});		// end of var panelSearch = Unilite.createSearchPanel('bid100skrvpanelSearch',{		// 메인
	
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
				    //allowBlank:false,
				    //holdable: 'hold',
					child:'WH_CODE',
				    value: UserInfo.divCode,
				    listeners: {
				    	change: function(field, newValue, oldValue, eOpts) {      
				      		panelSearch.setValue('DIV_CODE', newValue);
				     	},
				     	afterrender: function(field) {
				     		var divStore = field.getStore();
				     		divStore.insert(0, {"value":"", "option":null, "text":"전사"});
				     	}
				    }
			   },{
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
				    //allowBlank: false,
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
				    //allowBlank: false,
		 			listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('TXTLV_L2', newValue);
						}
					} 
		     	},{
				    fieldLabel: '<t:message code="system.label.inventory.minorgroup" default="소분류"/>',
				    name: 'TXTLV_L3', 
				    xtype: 'uniCombobox', 
				    //allowBlank: false, 
				    store: Ext.data.StoreManager.lookup('itemLeve3Store'),
		            parentNames:['TXTLV_L1','TXTLV_L2'],
		            levelType:'ITEM',
		 			listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('TXTLV_L3', newValue);
						}
					} 
				},
				Unilite.popup('CUST', {
						fieldLabel: '매입처', 
						valueFieldName: 'CUSTOM_CODE',
			    		textFieldName: 'CUSTOM_NAME', 
						listeners: {
							onSelected: {
								fn: function(records, type) {
									panelSearch.setValue('CUSTOM_CODE', panelResult.getValue('CUSTOM_CODE'));
									panelSearch.setValue('CUSTOM_NAME', panelResult.getValue('CUSTOM_NAME'));				 																							
								},
								scope: this
							},
							onClear: function(type)	{
								panelSearch.setValue('CUSTOM_CODE', '');
								panelSearch.setValue('CUSTOM_NAME', '');
							}
						}
				}),{
				fieldLabel: '고객분류', 
				name: 'AGENT_TYPE', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'B055',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('AGENT_TYPE', newValue);
					}
				}
			  },{
					xtype: 'radiogroup',		            		
					fieldLabel: '현재고 조건',					            		
					id: 'rdoSelect2',
					items: [{
						boxLabel: '전체', 
						width: 50, 
						name: 'STOCK_ZERO',
						checked: true  
					},{
						boxLabel : '0만조회', 
						width: 70,
						inputValue: 'Y',
						name: 'STOCK_ZERO'
					},{
						boxLabel : '미포함', 
						width: 55,
						inputValue: 'N',
						name: 'STOCK_ZERO'
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {			
							panelSearch.getField('STOCK_ZERO').setValue(newValue.STOCK_ZERO);
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
    
    var masterGrid = Unilite.createGrid('bid100skrvGrid', {
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
        	{dataIndex: 'CUSTOM_CODE'			, width: 100, align:'center',
			summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
            	}}, 				
			{dataIndex: 'CUSTOM_NAME'			, width: 150}, 				
			{dataIndex: 'WH_CODE'				, width: 80,align:'center'},
			{dataIndex: 'ITEM_CODE'				, width: 110}, 				
			{dataIndex: 'ITEM_NAME'				, width: 280}, 				
			{dataIndex: 'PUBL_NM'				, width: 150}, 	
			{dataIndex: 'TAX_TYPE'				, width: 80,align:'center'},
			{dataIndex: 'PURCHASE_TYPE'			, width: 80,align:'center'}, 				
			{dataIndex: 'SALES_TYPE'			, width: 80,align:'center'}, 				
			{dataIndex: 'SALE_BASIS_P'			, width: 90}, 				
			{dataIndex: 'PURCHASE_P'			, width: 90, summaryType: 'average'}, 					
			{dataIndex: 'PURCHASE_RATE'			, width: 90, summaryType: 'average'}, 				
			{dataIndex: 'STOCK_Q'				, width: 90, summaryType: 'sum'},
			{dataIndex: 'STOCK_COST'			, width: 90, summaryType: 'sum'}
		] 
    });	//End of var masterGrid = Unilite.createGrid('bid100skrvGrid', {
    
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
		id: 'bid100skrvApp',
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons(['reset', 'prev', 'next'], true);
			UniAppManager.setToolbarButtons('reset', false); 
			this.setDefault();
			/*panelSearch.setValue('DEPT_CODE',UserInfo.deptCode);
			panelSearch.setValue('DEPT_NAME',UserInfo.deptName);
			panelResult.setValue('DEPT_CODE',UserInfo.deptCode);
			panelResult.setValue('DEPT_NAME',UserInfo.deptName);*/
			bid100skrvService.userWhcode({}, function(provider, response)	{
				if(!Ext.isEmpty(provider)){
					panelSearch.setValue('WH_CODE',provider['WH_CODE']);
					panelResult.setValue('WH_CODE',provider['WH_CODE']);
				}
			})
		},
		setDefault: function() {
        	panelSearch.setValue('DIV_CODE',UserInfo.divCode);
        	panelResult.setValue('DIV_CODE',UserInfo.divCode);
        	//panelResult.setValue('ORDER_DATE',new Date());
			panelSearch.getForm().wasDirty = false;
			panelSearch.resetDirtyStatus();											
			UniAppManager.setToolbarButtons('save', false);
			UniAppManager.setToolbarButtons(['print'], false);
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
		onPrintButtonDown: function() {
	         //var records = panelSearch.down('#imageList').getSelectionModel().getSelection();
	         var param= Ext.getCmp('bid100skrvpanelSearch').getValues();
	
	         var win = Ext.create('widget.PDFPrintWindow', {
	            url: CPATH+'/bid/bid100rkrPrint.do',
	            prgID: 'bid100rkr',
	               extParam: {
	
	                  DIV_CODE  		: param.DIV_CODE,
	                  WH_CODE 			: param.WH_CODE,
	                  DEPT_CODE  		: param.DEPT_CODE,
	                  DEPT_NAME  		: param.DEPT_NAME,
	                  TXTLV_L1			: param.TXTLV_L1,
	                  TXTLV_L2			: param.TXTLV_L2,
	                  TXTLV_L3			: param.TXTLV_L3,
	                  CUSTOM_CODE		: param.CUSTOM_CODE,
	                  CUSTOM_NAME		: param.CUSTOM_NAME,
	                  AGENT_TYPE		: param.AGENT_TYPE,
	                  STOCK_ZERO		: param.STOCK_ZERO
	               }
	            });
	            win.center();
	            win.show();
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
