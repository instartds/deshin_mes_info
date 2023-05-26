<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ssa720skrv"  >
	
	<t:ExtComboStore comboType="BOR120" pgmId="ssa720skrv"   /> 						<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B020" /> 			<!-- 품목계정 -->
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

	Unilite.defineModel('ssa720skrvModel', {
	    fields: [
	    	{name: 'DEPT_CODE'			, text: '<t:message code="system.label.sales.department" default="부서"/>'				,type: 'string'},
	    	{name: 'DEPT_NAME'			, text: '<t:message code="system.label.sales.departmentname" default="부서명"/>'				,type: 'string'},
	    	{name: 'CUSTOM_CODE'		, text: '<t:message code="system.label.sales.purchaseplace" default="매입처"/>'			,type: 'string'},
	    	{name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.sales.purchaseplacename" default="매입처명"/>'				,type: 'string'},
	    	{name: 'ITEM_LEVEL1' 		, text: '<t:message code="system.label.sales.majorgroup" default="대분류"/>'				,type: 'string' ,store: Ext.data.StoreManager.lookup('itemLeve1Store') ,child:'ITEM_LEVEL2'},
	    	{name: 'ITEM_LEVEL2' 		, text: '<t:message code="system.label.sales.middlegroup" default="중분류"/>'				,type: 'string' ,store: Ext.data.StoreManager.lookup('itemLeve2Store') ,child:'ITEM_LEVEL3'},
	    	{name: 'ITEM_LEVEL3' 		, text: '<t:message code="system.label.sales.minorgroup" default="소분류"/>'				,type: 'string' ,store: Ext.data.StoreManager.lookup('itemLeve3Store')},
	    	{name: 'SALE_DATE'			, text: '판매일자'				,type: 'uniDate'},
	    	{name: 'SALE_Q'				, text: '<t:message code="system.label.sales.qty" default="수량"/>'				,type: 'uniQty'},
	    	{name: 'DISCOUNT_P'			, text: '<t:message code="system.label.sales.discount" default="할인"/>'				,type: 'uniUnitPrice'},
	    	{name: 'SALE_AMT_O'			, text: '<t:message code="system.label.sales.sellingamount" default="판매금액"/>'				,type: 'uniPrice'},
	    	{name: 'TAX_AMT_O'			, text: '<t:message code="system.label.sales.vat" default="부가세"/>'				,type: 'uniPrice'},
	    	{name: 'SALE_AMT_TOT'		, text: '<t:message code="system.label.sales.salestotalamount3" default="매출합계"/>'				,type: 'uniPrice'}
	    ]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('ssa720skrvMasterStore1',{
		model: 'ssa720skrvModel',
		uniOpt : {
			isMaster: true,			// 상위 버튼 연결 
			editable: false,		// 수정 모드 사용 
			deletable:false,		// 삭제 가능 여부 
			useNavi : false			// prev | next 버튼 사용
	            	//비고(*) 사용않함
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {read: 'ssa720skrvService.selectMaster'}
		},
		loadStoreRecords : function() {
			var param= Ext.getCmp('searchForm').getValues();
			param.SUBCON_FLAG = '1N'
			var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode = UserInfo.deptCode;	//부서코드
			if(authoInfo == "5" && Ext.isEmpty(panelSearch.getValue('DEPT_CODE'))){
				param.DEPT_CODE = deptCode;
			}
			console.log( param );
			this.load({
				params : param
			});
		}, groupField: 'DEPT_CODE'
	});
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm',{
		title: '<t:message code="system.label.sales.searchconditon" default="검색조건"/>',         
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
			title: '<t:message code="system.label.sales.basisinfo" default="기본정보"/>', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
			    items: [{
					fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>', 
					name: 'DIV_CODE', 
					xtype: 'uniCombobox', 
					comboType: 'BOR120',
					allowBlank: false,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('DIV_CODE', newValue);
						}
					}
			},{
				fieldLabel: '<t:message code="system.label.sales.salesdate" default="매출일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'SALE_DATE_FR',
				endFieldName: 'SALE_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				allowBlank: false,
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('SALE_DATE_FR',newValue);			
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('SALE_DATE_TO',newValue);			    		
			    	}
			    }
			},{
				xtype: 'radiogroup',		            		
				fieldLabel: '분류',						            		
				items: [{
					boxLabel: '부서별', 
					width: 70, 
					name: 'GUBUN',
					inputValue: '1',
					checked: true 
					
				},{
					boxLabel: '<t:message code="system.label.sales.itemgroupby" default="품목분류별"/>', 
					width: 90, 
					name: 'GUBUN',
					inputValue: '2'
				},{
					boxLabel : '매입처별', 
					width: 70,
					name: 'GUBUN',
					inputValue: '3'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						//panelResult.getField('SALE_YN').setValue({SALE_YN: newValue});
						panelResult.getField('GUBUN').setValue(newValue.GUBUN);
//						masterGrid.reset();
//						masterGrid.getView().refresh();
						directMasterStore1.clearData();
//						UniAppManager.setToolbarButtons('save',false);
						if (newValue.GUBUN == '1' ){  
							/* 부서별 (거래처, 분류별 hidden: true) */
							masterGrid.getColumn('DEPT_CODE').setVisible(true);
							masterGrid.getColumn('DEPT_NAME').setVisible(true);
							
							masterGrid.getColumn('CUSTOM_CODE').setVisible(false);
							masterGrid.getColumn('CUSTOM_NAME').setVisible(false);
							
							masterGrid.getColumn('ITEM_LEVEL1').setVisible(false);
							masterGrid.getColumn('ITEM_LEVEL2').setVisible(false);
							masterGrid.getColumn('ITEM_LEVEL3').setVisible(false);
						}else if(newValue.GUBUN == '2' ){
							/* 상품별 (부서별, 매입처 hidden: true) */
							masterGrid.getColumn('DEPT_CODE').setVisible(false);
							masterGrid.getColumn('DEPT_NAME').setVisible(false);
							
							masterGrid.getColumn('CUSTOM_CODE').setVisible(false);
							masterGrid.getColumn('CUSTOM_NAME').setVisible(false);
							
							masterGrid.getColumn('ITEM_LEVEL1').setVisible(true);
							masterGrid.getColumn('ITEM_LEVEL2').setVisible(true);
							masterGrid.getColumn('ITEM_LEVEL3').setVisible(true);
						}else{
							/* 매입처별 (부서별, 분류별 hidden: true) */
							masterGrid.getColumn('DEPT_CODE').setVisible(false);
							masterGrid.getColumn('DEPT_NAME').setVisible(false);
							
							masterGrid.getColumn('CUSTOM_CODE').setVisible(true);
							masterGrid.getColumn('CUSTOM_NAME').setVisible(true);
							
							masterGrid.getColumn('ITEM_LEVEL1').setVisible(false);
							masterGrid.getColumn('ITEM_LEVEL2').setVisible(false);
							masterGrid.getColumn('ITEM_LEVEL3').setVisible(false);
						}

					}
				}
			},
				Unilite.popup('DEPT',{ 
					fieldLabel: '<t:message code="system.label.sales.department" default="부서"/>', 
					 
					valueFieldName: 'DEPT_CODE',
					textFieldName: 'DEPT_NAME',
					listeners: {
						onSelected: {
							fn: function(records, type) {
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
				Unilite.popup('AGENT_CUST',{
		        fieldLabel: '<t:message code="system.label.sales.purchaseplace" default="매입처"/>',
		        
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
		    	fieldLabel: '<t:message code="system.label.sales.majorgroup" default="대분류"/>',
		    	name: 'ITEM_LEVEL1',
		    	xtype: 'uniCombobox',  
		    	store: Ext.data.StoreManager.lookup('itemLeve1Store'), 
		    	child: 'ITEM_LEVEL2',
		    	listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('ITEM_LEVEL1', newValue);
//							var fField = panelResult.getField('ITEM_LEVEL1');
//							fField.setValue(newValue);
						}
					}
			},{ 
			    fieldLabel: '<t:message code="system.label.sales.middlegroup" default="중분류"/>',
			    name: 'ITEM_LEVEL2', 
			    xtype: 'uniCombobox',  
			    store: Ext.data.StoreManager.lookup('itemLeve2Store'), 
			    child: 'ITEM_LEVEL3',
			    listeners: {
						change: function(field, newValue, oldValue, eOpts) {	
							panelResult.setValue('ITEM_LEVEL2', newValue);
//							var fField = panelResult.getField('ITEM_LEVEL2');
//							fField.setValue(newValue);
						}
					}
			},{ 
			    fieldLabel: '<t:message code="system.label.sales.minorgroup" default="소분류"/>',
			    name: 'ITEM_LEVEL3',
			    xtype: 'uniCombobox', 
			    store: Ext.data.StoreManager.lookup('itemLeve3Store'),
			    listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ITEM_LEVEL3', newValue);
//						var cField = panelResult.getField('ITEM_LEVEL3');
//						cField.setValue(newValue);
					}
				},
				parentNames:['ITEM_LEVEL1','ITEM_LEVEL2'], levelType:'ITEM'
		    }]
		}]	            			 
	});
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
        		fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
        		name: 'DIV_CODE',
        		holdable: 'hold',
        		value : UserInfo.divCode,
        		xtype: 'uniCombobox',
        		comboType: 'BOR120',
        		allowBlank: false,
        		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
        	},{
				fieldLabel: '<t:message code="system.label.sales.salesdate" default="매출일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'SALE_DATE_FR',
				endFieldName: 'SALE_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				allowBlank: false,
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelSearch) {
						panelSearch.setValue('SALE_DATE_FR',newValue);			
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('SALE_DATE_TO',newValue);			    		
			    	}
			    }
			},{
				xtype: 'radiogroup',		            		
				fieldLabel: '분류',						            		
				items: [{
					boxLabel: '부서별', 
					width: 70, 
					name: 'GUBUN',
					inputValue: '1',
					checked: true 
				},{
					boxLabel: '<t:message code="system.label.sales.itemgroupby" default="품목분류별"/>', 
					width: 90, 
					name: 'GUBUN',
					inputValue: '2'
				},{
					boxLabel : '매입처별', 
					width: 70,
					name: 'GUBUN',
					inputValue: '3'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.getField('GUBUN').setValue(newValue.GUBUN);
//						masterGrid.reset();
//						masterGrid.getView().refresh();
						directMasterStore1.clearData();
//						UniAppManager.setToolbarButtons('save',false);
						if (newValue.GUBUN == '1' ){  
							/* 부서별 (거래처, 분류별 hidden: true) */
							directMasterStore1.setGroupField('DEPT_CODE');
							masterGrid.getColumn('DEPT_CODE').setVisible(true);
							masterGrid.getColumn('DEPT_NAME').setVisible(true);
							
							masterGrid.getColumn('CUSTOM_CODE').setVisible(false);
							masterGrid.getColumn('CUSTOM_NAME').setVisible(false);
							
							masterGrid.getColumn('ITEM_LEVEL1').setVisible(false);
							masterGrid.getColumn('ITEM_LEVEL2').setVisible(false);
							masterGrid.getColumn('ITEM_LEVEL3').setVisible(false);
							
						}else if(newValue.GUBUN == '2' ){
							/* 상품별 (부서별, 매입처 hidden: true) */
							directMasterStore1.setGroupField('ITEM_LEVEL1');
							masterGrid.getColumn('DEPT_CODE').setVisible(false);
							masterGrid.getColumn('DEPT_NAME').setVisible(false);
							
							masterGrid.getColumn('CUSTOM_CODE').setVisible(false);
							masterGrid.getColumn('CUSTOM_NAME').setVisible(false);
							
							masterGrid.getColumn('ITEM_LEVEL1').setVisible(true);
							masterGrid.getColumn('ITEM_LEVEL2').setVisible(true);
							masterGrid.getColumn('ITEM_LEVEL3').setVisible(true);

						}else{
							/* 매입처별 (부서별, 분류별 hidden: true) */
							directMasterStore1.setGroupField('CUSTOM_CODE');
							masterGrid.getColumn('DEPT_CODE').setVisible(false);
							masterGrid.getColumn('DEPT_NAME').setVisible(false);
							
							masterGrid.getColumn('CUSTOM_CODE').setVisible(true);
							masterGrid.getColumn('CUSTOM_NAME').setVisible(true);
							
							masterGrid.getColumn('ITEM_LEVEL1').setVisible(false);
							masterGrid.getColumn('ITEM_LEVEL2').setVisible(false);
							masterGrid.getColumn('ITEM_LEVEL3').setVisible(false);
							
						}
						
					}
				}
			},
				Unilite.popup('DEPT',{
					fieldLabel: '<t:message code="system.label.sales.department" default="부서"/>',	
					
					valueFieldName: 'DEPT_CODE',
					textFieldName: 'DEPT_NAME',
					listeners: {
						onSelected: {
							fn: function(records, type) {
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
								popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
								
							}else if(authoInfo == "5"){		//부서권한
								popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							}
						}
					}
			}),
				Unilite.popup('AGENT_CUST',{
		        fieldLabel: '<t:message code="system.label.sales.purchaseplace" default="매입처"/>',
		        
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
				xtype: 'component'
			},{ 
		    	fieldLabel: '<t:message code="system.label.sales.majorgroup" default="대분류"/>',
		    	name: 'ITEM_LEVEL1',
		    	xtype: 'uniCombobox',  
		    	store: Ext.data.StoreManager.lookup('itemLeve1Store'), 
		    	child: 'ITEM_LEVEL2',
		    	listeners: {
						change: function(field, newValue, oldValue, eOpts) {	
							panelSearch.setValue('ITEM_LEVEL1', newValue);
//							var fField = panelSearch.getField('ITEM_LEVEL1');
//							fField.setValue(newValue);
						}
					}
			},{ 
			    fieldLabel: '<t:message code="system.label.sales.middlegroup" default="중분류"/>',
			    name: 'ITEM_LEVEL2', 
			    xtype: 'uniCombobox',  
			    store: Ext.data.StoreManager.lookup('itemLeve2Store'), 
			    child: 'ITEM_LEVEL3',
			    listeners: {
						change: function(field, newValue, oldValue, eOpts) {	
							panelSearch.setValue('ITEM_LEVEL2', newValue);
//							var fField = panelSearch.getField('ITEM_LEVEL2');
//							fField.setValue(newValue);
						}
					}
			},{ 
			    fieldLabel: '<t:message code="system.label.sales.minorgroup" default="소분류"/>',
			    name: 'ITEM_LEVEL3',
			    xtype: 'uniCombobox', 
			    store: Ext.data.StoreManager.lookup('itemLeve3Store'),
			    listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('ITEM_LEVEL3', newValue);
//						var cField = panelSearch.getField('ITEM_LEVEL3');
//						cField.setValue(newValue);
						
					}
				},
				parentNames:['ITEM_LEVEL1','ITEM_LEVEL2'], levelType:'ITEM'
		    }]
	});
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
	var masterGrid = Unilite.createGrid('ssa720skrvGrid1', {
    	region: 'center' ,
        layout : 'fit',
        store : directMasterStore1, 
        uniOpt:{	expandLastColumn: true,
        			useRowNumberer: false,
                    useMultipleSorting: true
        },
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: true} ],
    	store: directMasterStore1,
        columns:  [
        	{dataIndex: 'DEPT_CODE'				,width: 80	},
			{dataIndex: 'DEPT_NAME'				,width: 150 }, 				
			{dataIndex: 'CUSTOM_CODE'			,width: 110, hidden:true}, 				
			{dataIndex: 'CUSTOM_NAME'			,width: 300, hidden:true}, 				
			{dataIndex: 'ITEM_LEVEL1'			,width: 200, hidden:true}, 				
			{dataIndex: 'ITEM_LEVEL2'			,width: 200, hidden:true}, 				
			{dataIndex: 'ITEM_LEVEL3'			,width: 200, hidden:true}, 				
			{dataIndex: 'SALE_DATE'				,width: 100,
        		summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.sales.subtotal" default="소계"/>', '<t:message code="system.label.sales.total" default="총계"/>');
            } }, 				
			{dataIndex: 'SALE_Q'				,width: 100 , summaryType: 'sum'}, 				
			{dataIndex: 'DISCOUNT_P'			,width: 120 , summaryType: 'sum'}, 				
			{dataIndex: 'SALE_AMT_O'			,width: 120 , summaryType: 'sum'}, 				
			{dataIndex: 'TAX_AMT_O'				,width: 120 , summaryType: 'sum'}, 				
			{dataIndex: 'SALE_AMT_TOT'			,width: 120 , summaryType: 'sum'}
		] 
	});   
	
	
    Unilite.Main( {
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
		id  : 'ssa720skrvApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('reset',false);
/* 			masterGrid.getColumn('CUSTOM_CODE').setVisible(false);
			masterGrid.getColumn('CUSTOM_NAME').setVisible(false);
			masterGrid.getColumn('ITEM_LEVEL1').setVisible(false);
			masterGrid.getColumn('ITEM_LEVEL2').setVisible(false);
			masterGrid.getColumn('ITEM_LEVEL3').setVisible(false);  */		
//			panelSearch.setValue('DEPT_CODE', UserInfo.deptCode);
//			panelSearch.setValue('DEPT_NAME', UserInfo.deptName);
//			panelResult.setValue('DEPT_CODE', UserInfo.deptCode);
//			panelResult.setValue('DEPT_NAME', UserInfo.deptName);
		},
		onQueryButtonDown: function()	{
			if(panelSearch.setAllFieldsReadOnly(true) == false){
				return false;
			}
			masterGrid.getStore().loadStoreRecords();
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		}
	});
};


</script>
