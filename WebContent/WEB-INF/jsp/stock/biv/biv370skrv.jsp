<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="biv370skrv"  >
	
	<t:ExtComboStore comboType="BOR120" pgmId="biv370skrv" /> 		<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B020" /> 			<!-- 품목계정 -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList"/>		<!--창고-->
	<t:ExtComboStore comboType="AU" comboCode="YP08" /> <!--매입조건 -->
	<t:ExtComboStore comboType="AU" comboCode="YP09" /> <!--판매형태 -->	
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

	Unilite.defineModel('biv370skrvModel', {
	    fields: [
	    	{name: 'DIV_CODE'			, text: '<t:message code="system.label.inventory.division" default="사업장"/>'				,type: 'string', xtype: 'uniCombobox', comboType: 'BOR120'},
	    	{name: 'WH_CODE'			, text: '<t:message code="system.label.inventory.warehouse" default="창고"/>'				,type: 'string', xtype: 'uniCombobox', store: Ext.data.StoreManager.lookup('whList')},
	    	{name: 'ITEM_CODE'			, text: '<t:message code="system.label.inventory.item" default="품목"/>'				,type: 'string'},
	    	{name: 'ITEM_NAME'			, text: '<t:message code="system.label.inventory.itemname" default="품목명"/>'				,type: 'string'},
	    	{name: 'CUSTOM_CODE'		, text: '매입처코드'			,type: 'string'},
	    	{name: 'CUSTOM_NAME'		, text: '매입처명'				,type: 'string'},
	    	{name: 'PURCHASE_TYPE'		, text: '매입조건'				,type: 'string', comboType:'AU', comboCode:'YP08'},
	    	{name: 'SALES_TYPE'			, text: '판매형태'				,type: 'string', comboType:'AU', comboCode:'YP09'},
	    	{name: 'SALE_BASIS_P'		, text: '판매가'				,type: 'uniUnitPrice'},
	    	{name: 'PURCHASE_P'			, text: '매입가'				,type: 'uniUnitPrice'},
	    	{name: 'PURCHASE_RATE'		, text: '매입율'				,type: 'uniPercent'},
	    	{name: 'GOOD_STOCK_Q'		, text: '현재고'				,type: 'uniQty'}	    	
	    ]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('biv370skrvMasterStore1',{
		model: 'biv370skrvModel',
		uniOpt : {
			isMaster: true,			// 상위 버튼 연결 
			editable: false,		// 수정 모드 사용 
			deletable:false,		// 삭제 가능 여부 
			useNavi : false			// prev | newxt 버튼 사용
	            	//비고(*) 사용않함
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {read: 'biv370skrvService.selectMaster'}
		},
		loadStoreRecords : function() {
			var param= Ext.getCmp('searchForm').getValues();
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
			title: '기본정보', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
			    items: [{
					fieldLabel: '<t:message code="system.label.inventory.division" default="사업장"/>', 
					name: 'DIV_CODE', 
					xtype: 'uniCombobox', 
					comboType: 'BOR120',
					allowBlank: false,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('DIV_CODE', newValue);
						}
					}
			},
				Unilite.popup('DEPT',{ 
				fieldLabel: '부서', 
				popupWidth: 400,
				popupHeight: 400,				
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
		        fieldLabel: '매입처',
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
				Unilite.popup('DIV_PUMOK', {
				fieldLabel: '<t:message code="system.label.inventory.item" default="품목"/>',
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
					applyextparam: function(popup){							
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
			}),{ 
		    	fieldLabel: '<t:message code="system.label.inventory.majorgroup" default="대분류"/>',
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
			    fieldLabel: '<t:message code="system.label.inventory.middlegroup" default="중분류"/>',
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
			    fieldLabel: '<t:message code="system.label.inventory.minorgroup" default="소분류"/>',
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

				   	alert(labelText+Msg.sMB083);
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
        		fieldLabel: '<t:message code="system.label.inventory.division" default="사업장"/>',
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
        	},
				Unilite.popup('DEPT',{
				fieldLabel: '부서',
				popupWidth: 400,
				popupHeight: 400,				
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
			}),{
				xtype: 'component'
			},
				Unilite.popup('CUST',{
		        fieldLabel: '매입처',
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
				Unilite.popup('DIV_PUMOK', {
				fieldLabel: '<t:message code="system.label.inventory.item" default="품목"/>',
				colspan:2,
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
					applyextparam: function(popup){							
						popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
					}
				}
			}),{ 
		    	fieldLabel: '<t:message code="system.label.inventory.majorgroup" default="대분류"/>',
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
			    fieldLabel: '<t:message code="system.label.inventory.middlegroup" default="중분류"/>',
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
			    fieldLabel: '<t:message code="system.label.inventory.minorgroup" default="소분류"/>',
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
    
	var masterGrid = Unilite.createGrid('biv370skrvGrid1', {
    	region: 'center' ,
        layout : 'fit',
        store : directMasterStore1, 
        uniOpt:{	expandLastColumn: false,
        			useRowNumberer: false,
                    useMultipleSorting: true
        },
    	features: [ {id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: true} ],
    	store: directMasterStore1,
        columns:  [        	
        	{dataIndex: 'DIV_CODE'			,width: 100, hidden: true},
       	 	{dataIndex: 'WH_CODE'			,width: 85, locked: true},
			{dataIndex: 'ITEM_CODE'			,width: 105, locked: true,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
            		return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
            	}
            }, 	
			{dataIndex: 'ITEM_NAME'			,width: 200, locked: true },
			{dataIndex: 'CUSTOM_CODE'		,width: 105 }, 	
			{dataIndex: 'CUSTOM_NAME'		,width: 200 },
			{dataIndex: 'PURCHASE_TYPE'		,width: 120 }, 	
			{dataIndex: 'SALES_TYPE'		,width: 120 },
			{dataIndex: 'SALE_BASIS_P'		,width: 120, summaryType: 'sum'  }, 	
			{dataIndex: 'PURCHASE_P'		,width: 120, summaryType: 'sum'  },
			{dataIndex: 'PURCHASE_RATE'		,width: 120, summaryType: 'average' }, 	
			{dataIndex: 'GOOD_STOCK_Q'		,width: 120, summaryType: 'sum' }
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
		id  : 'biv370skrvApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
		},
		onQueryButtonDown: function()	{
			if(!panelSearch.setAllFieldsReadOnly(true)){
				return false;
			}
			masterGrid.getStore().loadStoreRecords();
			var viewLocked = masterGrid.lockedGrid.getView();
			var viewNormal = masterGrid.normalGrid.getView();		    
		    viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);		    
		    viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);	
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
