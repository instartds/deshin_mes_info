<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="biv430skrv"  >	
	<t:ExtComboStore comboType="BOR120"  pgmId="biv430skrv"/> 				<!-- 사업장 -->  
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
	var purchaseStore = Unilite.createStore('biv430skrvpurchaseStore', {
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
	Unilite.defineModel('biv430skrvModel', {									//////////////////////////// 모델(DB컬럼명, 타입 등..) 정의
	    fields: [
	    	{name: 'DIV_CODE'			,text: '<t:message code="system.label.inventory.division" default="사업장"/>'			,type: 'string', xtype: 'uniCombobox', comboType: 'BOR120'},
	    	{name: 'WH_CODE'			,text: '<t:message code="system.label.inventory.warehouse" default="창고"/>'		 	,type: 'string'/*, xtype: 'uniCombobox', store: Ext.data.StoreManager.lookup('whList')*/},
	    	{name: 'WH_NAME'			,text: '창고명'			,type: 'string'},
	    	{name: 'ITEM_CODE'			,text: '<t:message code="system.label.inventory.item" default="품목"/>'			,type: 'string'},
	    	{name: 'ITEM_NAME'			,text: '<t:message code="system.label.inventory.itemname" default="품목명"/>'			,type: 'string'},
	    	{name: 'ITEM_ACCOUNT'		,text: '계정'				,type: 'string'},
	    	{name: 'CUSTOM_CODE'		,text: '매입처코드'			,type: 'string'},
	    	{name: 'CUSTOM_NAME'		,text: '매입처명'			,type: 'string'},
	    	{name: 'BASIS_Q'			,text: '기초'				,type: 'uniQty'},
	    	{name: 'IN_Q'				,text: '입고'				,type: 'uniQty'},
	    	{name: 'OUT_Q'				,text: '출고'				,type: 'uniQty'},
	    	{name: 'S_RTN_Q'			,text: '출고'				,type: 'uniQty'},
	    	{name: 'M_RTN_Q'			,text: '입고'				,type: 'uniQty'},
	    	{name: 'STOCK_Q'			,text: '재고량'			,type: 'uniQty'},
	    	{name: 'STOCK_I'			,text: '재고금액'			,type: 'uniPrice'}	
	    ]
	});
	  
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('biv430skrvMasterStore1',{		//////////////////////////// directMasterStore 정의
		model: 'biv430skrvModel',
		uniOpt: {
        	isMaster: 	true,		// 상위 버튼 연결 
        	editable: 	false,		// 수정 모드 사용 
        	deletable: 	false,		// 삭제 가능 여부 
	    	useNavi: 	false		// prev | newxt 버튼 사용
        },																		//////////////////////////// 화면 상위버튼 연결	
        autoLoad: false,	//////////////////////////// 자동 조회
        proxy: {
        	type: 'direct',
        	api: {			
            	read: 'biv430skrvService.selectList'                	
            }
        },					//////////////////////////// proxy정의(serviceImple, xml 연결) - 이름 참고하고 jsp = imple, imple = xml
        loadStoreRecords: function() {
			var param= Ext.getCmp('biv430skrvpanelSearch').getValues();      
			var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode = UserInfo.deptCode;	//부서코드
			if(authoInfo == "5" && Ext.isEmpty(Ext.getCmp('biv430skrvpanelSearch').getValue('DEPT_CODE'))){
				param.DEPT_CODE = deptCode;
			}
			console.log( param );
			this.load({
				params: param
			});
		},
		groupField: 'CUSTOM_NAME'	
	});						//////////////////////////// 쿼리 조회(loadStoreRecords에서 proxy를 호출함.)

 	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('biv430skrvpanelSearch',{		//////////////////////////// 왼쪽 검색창
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
			   },{
					fieldLabel: '기준일자',
					xtype: 'uniDateRangefield',
					startFieldName: 'INOUT_DATE_FR',
					endFieldName: 'INOUT_DATE_TO',
					startDate: UniDate.get('today'),
					endDate: UniDate.get('today'),
					allowBlank: false,
					width: 315,
					onStartDateChange: function(field, newValue, oldValue, eOpts) {
	                	if(panelResult) {
							panelResult.setValue('INOUT_DATE_FR',newValue);
	                	}   
				    },
				    onEndDateChange: function(field, newValue, oldValue, eOpts) {
				    	if(panelResult) {
				    		panelResult.setValue('INOUT_DATE_TO',newValue);
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
			   },Unilite.popup('CUST', {
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
				}),
				Unilite.popup('DIV_PUMOK',{ 
			        	fieldLabel: '품목',
			        	valueFieldName: 'ITEM_CODE', 
						textFieldName: 'ITEM_NAME', 
			        	listeners: {
							onSelected: {
								fn: function(records, type) {
									console.log('records : ', records);
									panelResult.setValue('ITEM_CODE', panelSearch.getValue('ITEM_CODE'));
									panelResult.setValue('ITEM_NAME', panelSearch.getValue('ITEM_NAME'));	
		                    	},
								scope: this
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
					fieldLabel: '<t:message code="system.label.inventory.itemaccount" default="품목계정"/>', 
					name: 'ITEM_ACCOUNT', 
					xtype: 'uniCombobox', 
					comboType: 'AU', 
					comboCode: 'B020',
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								panelResult.setValue('ITEM_ACCOUNT', newValue);
							}
						}				
				},{
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
						name: 'STOCK_ZERO'
					},{
						boxLabel : '0만조회', 
						width: 70,
						inputValue: 'Y',
						name: 'STOCK_ZERO'
					},{
						boxLabel : '0미포함', 
						width: 70,
						inputValue: 'N',
						name: 'STOCK_ZERO',
						checked: true  
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {			
							panelResult.getField('STOCK_ZERO').setValue(newValue.STOCK_ZERO);
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
				}]
		}],
		setAllFieldsReadOnly: function(b) { 								//////////////////////////// 필수값 입력안하고 조회버튼 눌렀을떄 메세지 처리 함수
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
	});		// end of var panelSearch = Unilite.createSearchPanel('biv430skrvpanelSearch',{		// 메인
	
	var panelResult = Unilite.createSearchForm('resultForm',{						//////////////////////////// 화면 상단 검색창
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
	    items: [{	
	    	xtype:'container',
	    	padding:'0 5 5 5',
	        defaultType: 'uniTextfield',
	        layout: {type: 'uniTable', columns : 4},
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
			   },{
					fieldLabel: '기준일자',
					xtype: 'uniDateRangefield',
					startFieldName: 'INOUT_DATE_FR',
					endFieldName: 'INOUT_DATE_TO',
					startDate: UniDate.get('today'),
					endDate: UniDate.get('today'),
					allowBlank: false,
					width: 315,
					onStartDateChange: function(field, newValue, oldValue, eOpts) {
	                	if(panelResult) {
							panelSearch.setValue('INOUT_DATE_FR',newValue);
	                	}
	
				    },
				    onEndDateChange: function(field, newValue, oldValue, eOpts) {
				    	if(panelResult) {
				    		panelSearch.setValue('INOUT_DATE_TO',newValue);
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
				}),
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
								popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
							}
						}
			   }),{
					fieldLabel: '<t:message code="system.label.inventory.itemaccount" default="품목계정"/>', 
					name: 'ITEM_ACCOUNT', 
					xtype: 'uniCombobox', 
					comboType: 'AU', 
					comboCode: 'B020',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.setValue('ITEM_ACCOUNT', newValue);
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
							name: 'STOCK_ZERO'
						},{
							boxLabel : '0만조회', 
							width: 70,
							inputValue: 'Y',
							name: 'STOCK_ZERO'
						},{
							boxLabel : '0미포함', 
							width: 70,
							inputValue: 'N',
							name: 'STOCK_ZERO',
							checked: true  
						}],
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {			
								panelSearch.getField('STOCK_ZERO').setValue(newValue.STOCK_ZERO);
							}
						}
				},{
					xtype: 'component'
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
    
    var masterGrid = Unilite.createGrid('biv430skrvGrid', {				//////////////////////////// masterGrid 정의
    	region: 'center',
		layout: 'fit',
        uniOpt: {	expandLastColumn: true,
        			useRowNumberer: false,
                    useMultipleSorting: true
        },
    	store: directMasterStore,
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true },	//////////////////////////// 소계(그룹핑)
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: true} ],		//////////////////////////// 총게계(그리드 전체)
       	columns: [        
       		{dataIndex: 'DIV_CODE'				, width: 80, hidden: true},			
        	{dataIndex: 'WH_CODE'				, width: 80, align:'center',							//////////////////////////// 이 컬럼 위치에 소계, 총계 타이틀 넣는다.
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
				       return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
		    	}
	    	}, 				
			{dataIndex: 'WH_NAME'				, width: 100}, 				
			{dataIndex: 'ITEM_CODE'				, width: 120, isLink:true},	
			{dataIndex: 'ITEM_NAME'				, width: 230}, 				
			{dataIndex: 'CUSTOM_CODE'			, width: 76}, 				
			{dataIndex: 'CUSTOM_NAME'			, width: 160},				
			{dataIndex: 'ITEM_ACCOUNT'			, width: 160, hidden: true},
			{dataIndex: 'BASIS_Q'				, width: 90, summaryType: 'sum'},
			{dataIndex: 'IN_Q'					, width: 90, summaryType: 'sum'}, 				
			{dataIndex: 'OUT_Q'					, width: 90, summaryType: 'sum'}, 					
			{
          		text:'반품',		//////////////////////////// 그리드에 컬럼명들 위에 한번더 이름 지어줄떄 텍스트로 한번 감싸줌.(반품 - 컬럼명, 컬럼명...)	
           		columns:[ 
              		{dataIndex: 'S_RTN_Q'				, width: 90, summaryType: 'sum'}, 				
					{dataIndex: 'M_RTN_Q'				, width: 90, summaryType: 'sum'}
                ]
          	},	
			{dataIndex: 'STOCK_Q'				, width: 90, summaryType: 'sum'},
			{dataIndex: 'STOCK_I'				, width: 120, summaryType: 'sum'}
			
		],
		listeners: {			//////////////////////////// 그리드에서 특별한 이벤트가 일어날때나 listeners 사용
			afterrender: function(grid) {	
					//useContextMenu:true 설정으로 툴바 우측 버튼은 자동 생성되며 그 외 추가할 메뉴  작성					
					this.contextMenu.add(
						{
					        xtype: 'menuseparator'
					    },{	
					    	text: '상세보기',   iconCls : '',
		                	handler: function(menuItem, event) {	
		                		var record = grid.getSelectedRecord();
								var params = {
									action:'select',
									'DIV_CODE' : record.data['DIV_CODE'],
									'ITEM_ACCOUNT' : record.data['ITEM_ACCOUNT'],
									'INOUT_DATE_FR' : panelSearch.getValue('INOUT_DATE_FR'),
									'INOUT_DATE_TO' : panelSearch.getValue('INOUT_DATE_TO'),
									'ITEM_CODE' : record.data['ITEM_CODE'],
									'ITEM_NAME' : record.data['ITEM_NAME'],
									'WH_CODE' : record.data['WH_CODE']
								}
								var rec = {data : {prgID : 'biv330skrv', 'text':''}};									
								parent.openTab(rec, '/stock/biv330skrv.do', params);
		                	}
		            	}
	       			)
				},
			/*beforeedit  : function( editor, e, eOpts ) {
				if(e.record.phantom || !e.record.phantom)	{
					if (UniUtils.indexOf(e.field, 
							['POS_NO','POS_NAME','RECEIPT_NO','SALE_TIME','STAFF_CODE','STAFF_NM','SALE_Q',
							 'DETAIL_CNT','TOTAL_AMT_O','CASH_O','CARD_O'
							 ,'CREDIT_O','DISCOUNT_O','ETC','SALE_DATE']
							 
						))
					return false;
				}	
			},*/
          	onGridDblClick:function(grid, record, cellIndex, colName) {
          		if(!record.phantom) {
	      			switch(colName)	{
					case 'ITEM_CODE' :
							var params = {
								action:'select',
								'DIV_CODE' : record.data['DIV_CODE'],
								'ITEM_ACCOUNT' : record.data['ITEM_ACCOUNT'],
								'INOUT_DATE_FR' : panelSearch.getValue('INOUT_DATE_FR'),
								'INOUT_DATE_TO' : panelSearch.getValue('INOUT_DATE_TO'),
								'ITEM_CODE' : record.data['ITEM_CODE'],
								'ITEM_NAME' : record.data['ITEM_NAME'],
								'WH_CODE' : record.data['WH_CODE']
							}
							var rec = {data : {prgID : 'biv330skrv', 'text':''}};							
							parent.openTab(rec, '/stock/biv330skrv.do', params);
							
							break;		
					default:
							break;
	      			}
          		}
          	}
          }
    });	//End of var masterGrid = Unilite.createGrid('biv430skrvGrid', {
    
    /**
     * Master Grid2 정의(Grid Panel)
     * @type 
     */
    
	Unilite.Main ({							//////////////////////////// 전체관리(그리드, 폼 위치라던지 함수, 버튼 호출 기타 등등..)
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
		id: 'biv430skrvApp',
		fnInitBinding: function() {			//////////////////////////// 화면 처음 열렸을 떄
			UniAppManager.setToolbarButtons('reset', false); 
			this.setDefault();
			/*panelSearch.setValue('DEPT_CODE',UserInfo.deptCode);
			panelSearch.setValue('DEPT_NAME',UserInfo.deptName);
			panelResult.setValue('DEPT_CODE',UserInfo.deptCode);
			panelResult.setValue('DEPT_NAME',UserInfo.deptName);*/
			biv430skrvService.userWhcode({}, function(provider, response)	{		//////////////////////////// 창고 초기화 쿼리 호출 하면서 값 셋팅
				if(!Ext.isEmpty(provider)){
					panelSearch.setValue('WH_CODE',provider['WH_CODE']);
					panelResult.setValue('WH_CODE',provider['WH_CODE']);
				}
			})
			panelSearch.setValue('INOUT_DATE_FR',UniDate.get('today'));				//////////////////////////// 화면의 검색조건 값 셋팅
			panelResult.setValue('INOUT_DATE_FR',UniDate.get('today'));
			
			panelSearch.setValue('INOUT_DATE_TO',UniDate.get('today'));
			panelResult.setValue('INOUT_DATE_TO',UniDate.get('today'));
		},
		setDefault: function() {													//////////////////////////// 기본값 셋팅
        	panelSearch.setValue('DIV_CODE',UserInfo.divCode);
        	panelResult.setValue('DIV_CODE',UserInfo.divCode);
        	//panelResult.setValue('ORDER_DATE',new Date());
			panelSearch.getForm().wasDirty = false;
			panelSearch.resetDirtyStatus();											
			UniAppManager.setToolbarButtons('save', false);
		},
		/*onResetButtonDown: function() {												//////////////////////////// 초기화 버튼
			panelSearch.clearForm();
			panelSearch.setAllFieldsReadOnly(false);	
			panelResult.setAllFieldsReadOnly(false);
			masterGrid.reset();
			panelResult.clearForm();	
			this.fnInitBinding();
		},*/
		onQueryButtonDown: function()	{	
 			if(panelSearch.setAllFieldsReadOnly(true) == false){	////////////////////////////  조회 버튼 눌렀을때 필수값체크 함수 호출
				return false;
			}
			if(panelResult.setAllFieldsReadOnly(true) == false){
				return false;
			}
			masterGrid.getStore().loadStoreRecords();			////////////////////////////  스토어의 정의한 쿼리 호출
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
			panelSearch.setAllFieldsReadOnly(false);			//////////////////////////// 초기화 하면서 페이지 처음 상태로 돌아가기 때문에 setAllFieldsReadOnly(false) 시켜줌
			panelResult.setAllFieldsReadOnly(false);
			directMasterStore.clearData();
		}
	});
};
</script>
