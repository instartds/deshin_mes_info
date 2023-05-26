<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bid200skrv"  >	
	<t:ExtComboStore comboType="BOR120"  pgmId="bid200skrv"/> 				<!-- 사업장 -->  
	<t:ExtComboStore comboType="AU" comboCode="S010" /> <!--영업담당 -->
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
	/**
	 *   Model 정의 
	 * @type  
	 */
	Unilite.defineModel('bid200skrvModel', {
	    fields: [
	    	{name: 'DIV_CODE'			,text: '<t:message code="system.label.inventory.division" default="사업장"/>'		,type: 'string', xtype: 'uniCombobox', comboType: 'BOR120'},
	    	{name: 'INOUT_DATE'			,text: '입고일'		,type: 'uniDate'},
	    	{name: 'DEPT_CODE'			,text: '부서코드'		,type: 'string'},
	    	{name: 'DEPT_NAME'			,text: '부서명'		,type: 'string'},
	    	{name: 'WH_CODE'			,text: '<t:message code="system.label.inventory.warehouse" default="창고"/>'		 	,type: 'string', xtype: 'uniCombobox', store: Ext.data.StoreManager.lookup('whList')},
	    	{name: 'ITEM_CODE'			,text: '<t:message code="system.label.inventory.item" default="품목"/>'		,type: 'string'},
	    	{name: 'ITEM_NAME'			,text: '품명'			,type: 'string'},
	    	{name: 'CUSTOM_CODE'		,text: '거래처코드'		,type: 'string'},
	    	{name: 'CUSTOM_NAME'		,text: '거래처명'		,type: 'string'},
	    	{name: 'PRICE'				,text: '판매가'		,type: 'uniPrice'}, 
	    	{name: 'COST'				,text: '매입가'		,type: 'uniPrice'},
	    	{name: 'PURCHASE_RATE'		,text: '매입율'		,type: 'uniPercent'},
	    	{name: 'INOUT_Q'			,text: '기초'			,type: 'uniQty'},
	    	{name: 'IN_Q'				,text: '입고'			,type: 'uniQty'},
	    	{name: 'IN_RTN_Q'			,text: '입고반품'		,type: 'uniQty'},
	    	{name: 'OUT_Q'				,text: '출고'			,type: 'uniQty'},
	    	{name: 'OUT_RTN_Q'			,text: '출고반품'		,type: 'uniQty'},
	    	{name: 'END_STOCK_Q'		,text: '기말'			,type: 'uniQty'},
	    	{name: 'STOCK_QTY'			,text: '현재고'		,type: 'uniPrice'},
	    	{name: 'ITEM_LEVEL1'		,text: '<t:message code="system.label.inventory.majorgroup" default="대분류"/>'		,type: 'string', xtype: 'uniCombobox', store: Ext.data.StoreManager.lookup('itemLeve1Store')},
	    	{name: 'ITEM_LEVEL1_NAME'	,text: '<t:message code="system.label.inventory.majorgroup" default="대분류"/>'		,type: 'string'},
	    	{name: 'ITEM_LEVEL2'		,text: '<t:message code="system.label.inventory.middlegroup" default="중분류"/>'		,type: 'string', xtype: 'uniCombobox', store: Ext.data.StoreManager.lookup('itemLeve2Store')},
	    	{name: 'ITEM_LEVEL2_NAME'	,text: '<t:message code="system.label.inventory.middlegroup" default="중분류"/>'		,type: 'string'},
	    	{name: 'ITEM_LEVEL3'		,text: '<t:message code="system.label.inventory.minorgroup" default="소분류"/>'		,type: 'string', xtype: 'uniCombobox', store: Ext.data.StoreManager.lookup('itemLeve3Store')},
	    	{name: 'ITEM_LEVEL3_NAME'	,text: '<t:message code="system.label.inventory.minorgroup" default="소분류"/>'		,type: 'string'}
	    ]
	});
	  
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('bid200skrvMasterStore1',{
		model: 'bid200skrvModel',
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
            	read: 'bid200skrvService.selectList'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('bid200skrvpanelSearch').getValues();		
			var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode = UserInfo.deptCode;	//부서코드
			if(authoInfo == "5" && Ext.isEmpty(panelSearch.getValue('DEPT_CODE'))){
				param.DEPT_CODE = deptCode;
			}
			console.log( param );
			this.load({
				params : param
			});
		}
	});

 	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('bid200skrvpanelSearch',{		// 메인
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
					child:'WH_CODE',
				    allowBlank:false,
				    holdable: 'hold',
				    value: UserInfo.divCode,
				    listeners: {
				    	change: function(field, newValue, oldValue, eOpts) {      
				      		panelResult.setValue('DIV_CODE', newValue);
				     	}
				    }
			   },
			   Unilite.popup('DEPT', { 
			   		fieldLabel: '부서', 
			   		valueFieldName: 'DEPT_CODE',
			        textFieldName: 'DEPT_NAME',
				    allowBlank:false,
			    	holdable: 'hold',
			    	listeners: {
			     		onSelected: {
			      			fn: function(records, type) {
			       				panelResult.setValue('DEPT_CODE', panelSearch.getValue('DEPT_CODE'));
			       				panelResult.setValue('DEPT_NAME', panelSearch.getValue('DEPT_NAME'));
			                },
			      			scope: this
			     		},
			     		onClear: function(type) {
			        		panelResult.setValue('DEPT_CODE', '');
			        		panelResult.setValue('DEPT_NAME', '');
			     		},
						applyextparam: function(popup){							
							var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
							var deptCode = UserInfo.deptCode;	//부서정보
							var divCode = '';					//사업장
							
							if(authoInfo == "A"){	
								popup.setExtParam({'DEPT_CODE': ""});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
								
							}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
								popup.setExtParam({'DEPT_CODE': ""});
								popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
								
							}else if(authoInfo == "5"){		//부서권한
								popup.setExtParam({'DEPT_CODE': deptCode});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							}
						}
			    	}
			   }),
			   {
				    fieldLabel: '납품창고',
				    name: 'WH_CODE', 
				    xtype: 'uniCombobox', 
				    store: Ext.data.StoreManager.lookup('whList'),
				    allowBlank: false,
				    holdable: 'hold',
				    listeners: {
				    	change: function(field, newValue, oldValue, eOpts) {      
				      		panelResult.setValue('WH_CODE', newValue);
				     	}
				    }
			   },{
					fieldLabel: '입고일자',
					xtype: 'uniDateRangefield',
					startFieldName: 'INOUT_FR_DATE',
					endFieldName: 'INOUT_TO_DATE',
					startDate: UniDate.get('startOfMonth'),
					endDate: UniDate.get('today'),
					width:315,
				    allowBlank: false,
					onStartDateChange: function(field, newValue, oldValue, eOpts) {
	                	if(panelResult) {
							panelResult.setValue('INOUT_FR_DATE',newValue);						
	                	}
				    },
				    onEndDateChange: function(field, newValue, oldValue, eOpts) {
				    	if(panelResult) {
				    		panelResult.setValue('INOUT_TO_DATE',newValue);			    		
				    	}
				    }
				},
				Unilite.popup('CUST', {
						fieldLabel: '거래처', 
						valueFieldName: 'FR_CUST_CODE',
			    		textFieldName: 'CUSTOM_NAME', 
						listeners: {
							onSelected: {
								fn: function(records, type) {
									panelResult.setValue('FR_CUST_CODE', panelSearch.getValue('FR_CUST_CODE'));
									panelResult.setValue('CUSTOM_NAME', panelSearch.getValue('CUSTOM_NAME'));				 																							
								},
								scope: this
							},
							onClear: function(type)	{
								panelResult.setValue('FR_CUST_CODE', '');
								panelResult.setValue('CUSTOM_NAME', '');
							}
						}
				}),
				Unilite.popup('CUST',{
						fieldLabel: '~',  
						valueFieldName: 'TO_CUST_CODE',
			    		textFieldName: 'CUSTOM_NAME2',
						validateBlank:false,
						listeners: {
							onSelected: {
								fn: function(records, type) {
									panelResult.setValue('TO_CUST_CODE', panelSearch.getValue('TO_CUST_CODE'));
									panelResult.setValue('CUSTOM_NAME2', panelSearch.getValue('CUSTOM_NAME2'));				 																							
								},
								scope: this
							},
							onClear: function(type)	{
								panelResult.setValue('TO_CUST_CODE', '');
								panelResult.setValue('CUSTOM_NAME2', '');
							}
						}
				}),{
		     		fieldLabel: '<t:message code="system.label.inventory.majorgroup" default="대분류"/>',
		     		name: 'TXTLV_L1',
		     		xtype: 'uniCombobox', 
				    hidden: true, 
				    child: 'TXTLV_L2',
		     		store: Ext.data.StoreManager.lookup('itemLeve1Store'),
		     		change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('TXTLV_L1', newValue);
					}
					
		     		//child: 'TXTLV_L2'
		     	},{
		     		fieldLabel: '<t:message code="system.label.inventory.middlegroup" default="중분류"/>',
		     		name: 'TXTLV_L2', 
		     		xtype: 'uniCombobox',  
				    hidden: true,
				    child: 'TXTLV_L3',
		     		store: Ext.data.StoreManager.lookup('itemLeve2Store'),
		     		change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('TXTLV_L2', newValue);
					}
		     		//child: 'TXTLV_L3'
		     	},{
				    fieldLabel: '<t:message code="system.label.inventory.minorgroup" default="소분류"/>',
				    name: 'TXTLV_L3', 
				    xtype: 'uniCombobox',
				    hidden: true,
				    store: Ext.data.StoreManager.lookup('itemLeve3Store'),
		     		change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('TXTLV_L3', newValue);
					}
				},{
		    		xtype: 'uniCheckboxgroup',	
		    		padding: '0 0 0 0',
		    		fieldLabel: ' ',
		    		id: 'STOCKMOVE_YN2',
		    		items: [{
		    			boxLabel: '재고이동 포함여부',
		    			width: 120,
		    			name: 'STOCKMOVE_YN',
		    			inputValue: 'Y',
		    			uncheckedValue: 'N',
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								panelResult.setValue('STOCKMOVE_YN', newValue);
							}
						}
		    		}]
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
	});		// end of var panelSearch = Unilite.createSearchPanel('bid200skrvpanelSearch',{		// 메인
	
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
				    holdable: 'hold',
					child:'WH_CODE',
				    value: UserInfo.divCode,
				    listeners: {
				    	change: function(field, newValue, oldValue, eOpts) {      
				      		panelSearch.setValue('DIV_CODE', newValue);
				     	}
				    }
			   },
			   Unilite.popup('DEPT', { 
			   		fieldLabel: '부서', 
			   		valueFieldName: 'DEPT_CODE',
			        textFieldName: 'DEPT_NAME',
				    allowBlank:false,
			    	holdable: 'hold',
			    	listeners: {
			     		onSelected: {
			      			fn: function(records, type) {
			       				panelSearch.setValue('DEPT_CODE', panelResult.getValue('DEPT_CODE'));
			       				panelSearch.setValue('DEPT_NAME', panelResult.getValue('DEPT_NAME'));
			                },
			      			scope: this
			     		},
			     		onClear: function(type) {
			        		panelSearch.setValue('DEPT_CODE', '');
			        		panelSearch.setValue('DEPT_NAME', '');
			     		},
						applyextparam: function(popup){							
							var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
							var deptCode = UserInfo.deptCode;	//부서정보
							var divCode = '';					//사업장
							
							if(authoInfo == "A"){	
								popup.setExtParam({'DEPT_CODE': ""});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
								
							}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
								popup.setExtParam({'DEPT_CODE': ""});
								popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
								
							}else if(authoInfo == "5"){		//부서권한
								popup.setExtParam({'DEPT_CODE': deptCode});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							}
						}
			    	}
			   }),
			   {
				    fieldLabel: '납품창고',
				    name: 'WH_CODE', 
				    xtype: 'uniCombobox', 
				    store: Ext.data.StoreManager.lookup('whList'),
				    allowBlank: false,
				    holdable: 'hold',
				    listeners: {
				    	change: function(field, newValue, oldValue, eOpts) {      
				      		panelSearch.setValue('WH_CODE', newValue);
				     	}
				    }
			   },{
					fieldLabel: '입고일자',
					xtype: 'uniDateRangefield',
					startFieldName: 'INOUT_FR_DATE',
					endFieldName: 'INOUT_TO_DATE',
					startDate: UniDate.get('startOfMonth'),
					endDate: UniDate.get('today'),
					width:315,
				    allowBlank: false,
					onStartDateChange: function(field, newValue, oldValue, eOpts) {
	                	if(panelSearch) {
							panelSearch.setValue('INOUT_FR_DATE',newValue);						
	                	}
				    },
				    onEndDateChange: function(field, newValue, oldValue, eOpts) {
				    	if(panelSearch) {
				    		panelSearch.setValue('INOUT_TO_DATE',newValue);			    		
				    	}
				    }
				},
				Unilite.popup('CUST', {
						fieldLabel: '거래처', 
						valueFieldName: 'FR_CUST_CODE',
			    		textFieldName: 'CUSTOM_NAME', 
						listeners: {
							onSelected: {
								fn: function(records, type) {
									panelSearch.setValue('FR_CUST_CODE', panelResult.getValue('FR_CUST_CODE'));
									panelSearch.setValue('CUSTOM_NAME', panelResult.getValue('CUSTOM_NAME'));				 																							
								},
								scope: this
							},
							onClear: function(type)	{
								panelSearch.setValue('FR_CUST_CODE', '');
								panelSearch.setValue('CUSTOM_NAME', '');
							}
						}
				}),
				Unilite.popup('CUST',{
						fieldLabel: '~',
						valueFieldName:'TO_CUST_CODE',
			    		textFieldName:'CUSTOM_NAME',
						labelWidth: 15,
						validateBlank: false,
						listeners: {
							onSelected: {
								fn: function(records, type) {
									panelSearch.setValue('TO_CUST_CODE', panelResult.getValue('TO_CUST_CODE'));
									panelSearch.setValue('CUSTOM_NAME', panelResult.getValue('CUSTOM_NAME'));				 																							
								},
								scope: this
							},
							onClear: function(type)	{
								panelSearch.setValue('TO_CUST_CODE', '');
								panelSearch.setValue('CUSTOM_NAME', '');
							}
						}
				}),{
		     		fieldLabel: '<t:message code="system.label.inventory.majorgroup" default="대분류"/>',
		     		name: 'TXTLV_L1',
		     		xtype: 'uniCombobox',  
				    hidden: true,
		     		store: Ext.data.StoreManager.lookup('itemLeve1Store'), 
					child: 'TXTLV_L2',
		 			listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('TXTLV_L1', newValue);
						}
					} 
		     		//child: 'TXTLV_L2'
		     	},{
		     		fieldLabel: '<t:message code="system.label.inventory.middlegroup" default="중분류"/>',
		     		name: 'TXTLV_L2', 
		     		xtype: 'uniCombobox',  
				    hidden: true,
		     		store: Ext.data.StoreManager.lookup('itemLeve2Store'),
					child: 'TXTLV_L3',
		 			listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('TXTLV_L2', newValue);
						}
					} 
		     		//child: 'TXTLV_L3'
		     	},{
				    fieldLabel: '<t:message code="system.label.inventory.minorgroup" default="소분류"/>',
				    name: 'TXTLV_L3', 
				    xtype: 'uniCombobox',
				    hidden: true,
				    store: Ext.data.StoreManager.lookup('itemLeve3Store'),
		 			listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('TXTLV_L3', newValue);
						}
					} 
				},{
		    		xtype: 'uniCheckboxgroup',	
		    		padding: '0 0 0 0',
		    		fieldLabel: ' ',
		    		id: 'STOCKMOVE_YN1',
		    		items: [{
		    			boxLabel: '재고이동 포함여부',
		    			width: 120,
		    			name: 'STOCKMOVE_YN',
		    			inputValue: 'Y',
		    			uncheckedValue: 'N',
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								panelSearch.setValue('STOCKMOVE_YN', newValue);
							}
						}
		    		}]
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
		     		var r= false;
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
    
    var masterGrid = Unilite.createGrid('bid200skrvGrid', {
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
       		{dataIndex: 'INOUT_DATE'			, width: 93, hidden: true},	
       		{dataIndex: 'DEPT_CODE'				, width: 100}, 				
			{dataIndex: 'DEPT_NAME'				, width: 150,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '매입처계', '총계');
            }},
			{dataIndex: 'WH_CODE'				, width: 80, hidden: true},				
			{dataIndex: 'ITEM_CODE'				, width: 110}, 				
			{dataIndex: 'ITEM_NAME'				, width: 200},
        	{dataIndex: 'CUSTOM_CODE'			, width: 100}, 				
			{dataIndex: 'CUSTOM_NAME'			, width: 150},  				
			{dataIndex: 'PRICE'					, width: 90}, 				
			{dataIndex: 'COST'					, width: 90}, 				
			{dataIndex: 'PURCHASE_RATE'			, width: 70, summaryType: 'average'}, 
			{dataIndex: 'INOUT_Q'				, width: 90, summaryType: 'sum'},
	    	{dataIndex: 'IN_Q'					, width: 90, summaryType: 'sum'},
	    	{dataIndex: 'IN_RTN_Q'				, width: 90, summaryType: 'sum'},
	    	{dataIndex: 'OUT_Q'					, width: 90, summaryType: 'sum'},
	    	{dataIndex: 'OUT_RTN_Q'				, width: 90, summaryType: 'sum'},
	    	{dataIndex: 'END_STOCK_Q'			, width: 90, summaryType: 'sum'},
			{dataIndex: 'STOCK_QTY'				, width: 70, summaryType: 'sum'}, 
			{dataIndex: 'ITEM_LEVEL1'			, width: 100}, 				
			{dataIndex: 'ITEM_LEVEL1_NAME'		, width: 100, hidden: true}, 				
			{dataIndex: 'ITEM_LEVEL2'			, width: 100},				
			{dataIndex: 'ITEM_LEVEL2_NAME'		, width: 100, hidden: true}, 				
			{dataIndex: 'ITEM_LEVEL3'			, width: 100}, 				
			{dataIndex: 'ITEM_LEVEL3_NAME'		, width: 100, hidden: true}
		] 
    });	//End of var masterGrid = Unilite.createGrid('bid200skrvGrid', {
    
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
		id: 'bid200skrvApp',
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons(['reset', 'prev', 'next'], true);
			UniAppManager.setToolbarButtons('reset', false); 
			this.setDefault();
			panelSearch.setValue('DEPT_CODE', UserInfo.deptCode);
			panelSearch.setValue('DEPT_NAME', UserInfo.deptName);
			panelResult.setValue('DEPT_CODE', UserInfo.deptCode);
			panelResult.setValue('DEPT_NAME', UserInfo.deptName);
			panelSearch.setValue('INOUT_FR_DATE', UniDate.get('startOfMonth'));
			panelSearch.setValue('INOUT_TO_DATE', UniDate.get('today'));
			panelResult.setValue('INOUT_FR_DATE', UniDate.get('startOfMonth'));
			panelResult.setValue('INOUT_TO_DATE', UniDate.get('today'));
			bid200skrvService.userWhcode({}, function(provider, response)	{
				if(!Ext.isEmpty(provider)){
					panelSearch.setValue('WH_CODE', provider['WH_CODE']);
					panelResult.setValue('WH_CODE', provider['WH_CODE']);
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
      		viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
      		viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
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
			panelSearch.setValue('INOUT_FR_DATE', UniDate.get('startOfMonth'));	
			panelSearch.setValue('INOUT_TO_DATE', UniDate.get('today'));	
			panelResult.setValue('INOUT_FR_DATE', UniDate.get('startOfMonth'));	
			panelResult.setValue('INOUT_TO_DATE', UniDate.get('today'));
		}
	});
};
</script>
