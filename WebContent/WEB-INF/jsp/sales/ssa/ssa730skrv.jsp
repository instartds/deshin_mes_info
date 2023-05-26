<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ssa730skrv"  >	
	<t:ExtComboStore comboType="BOR120" pgmId="ssa730skrv"  /> 						<!-- 사업장 -->
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

	Unilite.defineModel('ssa730skrvModel', {
	    fields: [
	    	{name: 'ITEM_LEVEL1' 		, text: '<t:message code="system.label.sales.majorgroup" default="대분류"/>'					,type: 'string' ,store: Ext.data.StoreManager.lookup('itemLeve1Store') ,child:'ITEM_LEVEL2'},
	    	{name: 'ITEM_LEVEL2' 		, text: '<t:message code="system.label.sales.middlegroup" default="중분류"/>'					,type: 'string' ,store: Ext.data.StoreManager.lookup('itemLeve2Store') ,child:'ITEM_LEVEL3'},
	    	{name: 'ITEM_LEVEL3' 		, text: '<t:message code="system.label.sales.minorgroup" default="소분류"/>'					,type: 'string' ,store: Ext.data.StoreManager.lookup('itemLeve3Store')},
	    	{name: 'CUSTOM_CODE'		, text: '<t:message code="system.label.sales.purchaseplace" default="매입처"/>'				,type: 'string'},
	    	{name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.sales.purchaseplacename" default="매입처명"/>'					,type: 'string'},
	    	{name: 'ITEM_CODE'			, text: '<t:message code="system.label.sales.item" default="품목"/>'					,type: 'string'},
	    	{name: 'ITEM_NAME'			, text: '<t:message code="system.label.sales.itemname" default="품목명"/>'					,type: 'string'},
	    	{name: 'AUTHOR'				, text: '저자'					,type: 'string'},
	    	{name: 'PUBLISHER'			, text: '출판사명'					,type: 'string'},
	    	{name: 'SALE_BASIS_P'		, text: '<t:message code="system.label.sales.sellingprice2" default="판매가"/>'					,type: 'uniUnitPrice'},
	    	{name: 'FIRST_SALES_DATE'	, text: '최초판매'					,type: 'uniDate'},
	    	{name: 'LAST_SALES_DATE'	, text: '최종판매'					,type: 'uniDate'},
	    	{name: 'GOOD_STOCK_Q'		, text: '<t:message code="system.label.sales.inventoryqty2" default="재고수량"/>'					,type: 'uniQty'},
	    	{name: 'COST_AMT'			, text: '재고원가'					,type: 'uniPrice'}
	    ]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('ssa730skrvMasterStore1',{
		model: 'ssa730skrvModel',
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
			api: {read: 'ssa730skrvService.selectList'}
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
		}
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
				fieldLabel: '기준일자',
				xtype: 'uniDatefield',
				name: 'BASIS_DATE',
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('BASIS_DATE',newValue);	
					}
				}
			},{
				xtype: 'radiogroup',		            		
				fieldLabel: '분류',						            		
				items: [{
					boxLabel: '<t:message code="system.label.sales.itemgroupby" default="품목분류별"/>', 
					width: 90, 
					name: 'GUBUN',
					inputValue: '1',
					checked: true
				},{
					boxLabel : '매입처별', 
					width: 70,
					name: 'GUBUN',
					inputValue: '2'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						directMasterStore1.clearData();
						panelResult.getField('GUBUN').setValue(newValue.GUBUN);
						if (newValue.GUBUN == '1' ){
							masterGrid.getColumn('CUSTOM_CODE').setVisible(false);
							masterGrid.getColumn('CUSTOM_NAME').setVisible(false);
							
							masterGrid.getColumn('ITEM_LEVEL1').setVisible(true);
							masterGrid.getColumn('ITEM_LEVEL2').setVisible(true);
							masterGrid.getColumn('ITEM_LEVEL3').setVisible(true);
						}else if(newValue.GUBUN == '2' ){
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
								popup.setExtParam({'DIV_CODE': panelSearch.getValue('BILL_DIV_CODE')});
								
							}else if(authoInfo == "5"){		//부서권한
								popup.setExtParam({'DEPT_CODE': deptCode});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							}
						}
					}
			}),
				Unilite.popup('CUST',{
					fieldLabel: '<t:message code="system.label.sales.custom" default="거래처"/>',
					valueFieldName:'CUSTOM_CODE',
			    	textFieldName:'CUSTOM_NAME',
					extParam: {'CUSTOM_TYPE': ['1','2']},  
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
						}
					}
			},{ 
			    fieldLabel: '<t:message code="system.label.sales.minorgroup" default="소분류"/>',
			    name: 'ITEM_LEVEL3',
			    xtype: 'uniCombobox', 
			    store: Ext.data.StoreManager.lookup('itemLeve3Store'),
				parentNames:['ITEM_LEVEL1','ITEM_LEVEL2'],
	            levelType:'ITEM',
			    listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('ITEM_LEVEL3', newValue);
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

				   	Unilite.messageBox(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
				   	invalid.items[0].focus();
				}
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
				fieldLabel: '기준일자',
				xtype: 'uniDatefield',
				name: 'BASIS_DATE',
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('BASIS_DATE',newValue);	
					}
				}
			},{
				xtype: 'radiogroup',		            		
				fieldLabel: '분류',						            		
				items: [{
					boxLabel: '<t:message code="system.label.sales.itemgroupby" default="품목분류별"/>', 
					width: 90, 
					name: 'GUBUN',
					inputValue: '1',
					checked: true
				},{
					boxLabel : '매입처별', 
					width: 70,
					name: 'GUBUN',
					inputValue: '2'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						directMasterStore1.clearData();
						panelSearch.getField('GUBUN').setValue(newValue.GUBUN);
						if (newValue.GUBUN == '1' ){
							masterGrid.getColumn('CUSTOM_CODE').setVisible(false);
							masterGrid.getColumn('CUSTOM_NAME').setVisible(false);
							
							masterGrid.getColumn('ITEM_LEVEL1').setVisible(true);
							masterGrid.getColumn('ITEM_LEVEL2').setVisible(true);
							masterGrid.getColumn('ITEM_LEVEL3').setVisible(true);
						}else if(newValue.GUBUN == '2' ){
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
				Unilite.popup('CUST',{
					fieldLabel: '<t:message code="system.label.sales.custom" default="거래처"/>',
					valueFieldName:'CUSTOM_CODE',
			    	textFieldName:'CUSTOM_NAME',
					extParam: {'CUSTOM_TYPE': ['1','2']},   
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
					}
				}
			},{ 
			    fieldLabel: '<t:message code="system.label.sales.minorgroup" default="소분류"/>',
			    name: 'ITEM_LEVEL3',
			    xtype: 'uniCombobox', 
			    store: Ext.data.StoreManager.lookup('itemLeve3Store'),
				parentNames:['ITEM_LEVEL1','ITEM_LEVEL2'],
	            levelType:'ITEM',
			    listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('ITEM_LEVEL3', newValue);
					}
				}
		    }]
	});
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
	var masterGrid = Unilite.createGrid('ssa730skrvGrid1', {
    	region: 'center' ,
        layout : 'fit',
        store : directMasterStore1, 
        uniOpt:{	expandLastColumn: true,
        			useRowNumberer: false,
                    useMultipleSorting: true
        },
//    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true },
//    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: true} ],
    	store: directMasterStore1,
        columns:  [{dataIndex: 'ITEM_LEVEL1' 		,		width: 100}
        		  ,{dataIndex: 'ITEM_LEVEL2' 		,		width: 100}
        		  ,{dataIndex: 'ITEM_LEVEL3' 		,		width: 100}
        		  ,{dataIndex: 'CUSTOM_CODE'		,		width: 100}
        		  ,{dataIndex: 'CUSTOM_NAME'		,		width: 166}
        		  ,{dataIndex: 'ITEM_CODE'			,		width: 105}
        		  ,{dataIndex: 'ITEM_NAME'			,		width: 166}
        		  ,{dataIndex: 'AUTHOR'				,		width: 100}
        		  ,{dataIndex: 'PUBLISHER'			,		width: 120}
        		  ,{dataIndex: 'SALE_BASIS_P'		,		width: 100}
        		  ,{dataIndex: 'FIRST_SALES_DATE'	,		width: 100}
        		  ,{dataIndex: 'LAST_SALES_DATE'	,		width: 100}
        		  ,{dataIndex: 'GOOD_STOCK_Q'		,		width: 100}
        		  ,{dataIndex: 'COST_AMT'			,		width: 100}
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
		id  : 'ssa730skrvApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('BASIS_DATE',UniDate.get('today'));
			panelResult.setValue('BASIS_DATE',UniDate.get('today'));
			panelSearch.setValue('BASIS_DATE',UniDate.get('startOfMonth', panelSearch.getValue('BASIS_DATE')));
			panelResult.setValue('BASIS_DATE',UniDate.get('startOfMonth', panelResult.getValue('BASIS_DATE')));
		
			masterGrid.getColumn('CUSTOM_CODE').hidden = true;
			masterGrid.getColumn('CUSTOM_NAME').hidden = true;
			
			masterGrid.getColumn('ITEM_LEVEL1').hidden = false;
			masterGrid.getColumn('ITEM_LEVEL2').hidden = false;
			masterGrid.getColumn('ITEM_LEVEL3').hidden = false;
			
//			panelSearch.setValue('DEPT_CODE', UserInfo.deptCode);
//			panelSearch.setValue('DEPT_NAME', UserInfo.deptName);
//			panelResult.setValue('DEPT_CODE', UserInfo.deptCode);
//			panelResult.setValue('DEPT_NAME', UserInfo.deptName);
		},
		onQueryButtonDown: function()	{
			if(!panelSearch.setAllFieldsReadOnly(true)){
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
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({})
			this.fnInitBinding();			
		}
	});
};


</script>
