<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bid120skrv"  >	
	<t:ExtComboStore comboType="BOR120" pgmId="bid120skrv"/> 				<!-- 사업장 -->  
	<t:ExtComboStore comboType="AU" comboCode="S010" /> <!--영업담당 -->
	<t:ExtComboStore comboType="AU" comboCode="M032" /> <!--매입유형 -->
	<t:ExtComboStore comboType="AU" comboCode="YP09" /> <!--판매형태 -->
	<t:ExtComboStore comboType="AU" comboCode="B055" /> <!-- 거래처분류 -->  
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList"/>	<!--창고-->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" /> <!-- 대분류 -->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" /> <!-- 중분류 -->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" /> <!-- 소분류 -->
	
</t:appConfig>
<script type="text/javascript" >

var gsWhCode = '';		//창고코드

function appMain() {     

	/**
	 *   Model 정의 
	 * @type  
	 */
	Unilite.defineModel('bid120skrvModel', {
	    fields: [
	    	{name: 'DIV_CODE'			, text: '<t:message code="system.label.inventory.division" default="사업장"/>'		, type: 'string', xtype: 'uniCombobox', comboType: 'BOR120'},
	    	{name: 'ITEM_LEVEL1'		, text: '<t:message code="system.label.inventory.majorgroup" default="대분류"/>'		, type: 'string', store: Ext.data.StoreManager.lookup('itemLeve1Store')},
			{name: 'ITEM_LEVEL2'		, text: '<t:message code="system.label.inventory.middlegroup" default="중분류"/>'		, type: 'string', store: Ext.data.StoreManager.lookup('itemLeve2Store')},
	    	{name: 'ITEM_LEVEL3'		, text: '<t:message code="system.label.inventory.minorgroup" default="소분류"/>'		, type: 'string', store: Ext.data.StoreManager.lookup('itemLeve3Store')},
	    	{name: 'STOCK_Q'			, text: '현재고'		, type: 'uniQty'},
	    	{name: 'STOCK_I'			, text: '재고원가'		, type: 'uniPrice'},
	    	{name: 'STOCK_TAX'			, text: '원가부가세'	, type: 'uniPrice'},
	    	{name: 'SALE_I'				, text: '판매가재고'	, type: 'uniPrice'},
	    	{name: 'SALE_TAX'			, text: '판매가부가세'	, type: 'uniPrice'}
	    ]
	});
	  
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('bid120skrvMasterStore1',{
		model: 'bid120skrvModel',
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
            	read: 'bid120skrvService.selectList'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('bid120skrvpanelSearch').getValues();      
			var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode = UserInfo.deptCode;	//부서코드
			if(authoInfo == "5" && Ext.isEmpty(Ext.getCmp('bid120skrvpanelSearch').getValue('DEPT_CODE'))){
				param.DEPT_CODE = deptCode;
			}
			console.log( param );
			this.load({
				params: param
			});
		}
	});

 	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('bid120skrvpanelSearch',{		// 메인
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
			   },
			   	Unilite.popup('DEPT',{ 
					fieldLabel: '부서', 
					popupWidth: 500,
					popupHeight: 500,
					valueFieldName: 'DEPT_CODE',
					textFieldName: 'DEPT_NAME',
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('DEPT_CODE', panelSearch.getValue('DEPT_CODE'));
								panelResult.setValue('DEPT_NAME', panelSearch.getValue('DEPT_NAME'));	
								gsWhCode = records[0]['WH_CODE'];
								var whStore = panelSearch.getField('WH_CODE').getStore();							
								console.log("whStore : ",whStore);							
								whStore.clearFilter(true);
								whStore.filter([
									 {property:'option', value:panelSearch.getValue('DIV_CODE')}
									,{property:'value', value: records[0]['WH_CODE']}
								]);
								panelSearch.getField('WH_CODE').setValue(records[0]['WH_CODE']);
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
			}),{
				    fieldLabel: '<t:message code="system.label.inventory.warehouse" default="창고"/>',
				    name: 'WH_CODE', 
				    xtype: 'uniCombobox', 
				    store: Ext.data.StoreManager.lookup('whList'),
				    allowBlank: false,
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
	});		// end of var panelSearch = Unilite.createSearchPanel('bid120skrvpanelSearch',{		// 메인
	
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
			   },
			   	Unilite.popup('DEPT',{ 
					fieldLabel: '부서', 
					popupWidth: 500,
					popupHeight: 500,					
					valueFieldName: 'DEPT_CODE',
					textFieldName: 'DEPT_NAME',
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelSearch.setValue('DEPT_CODE', panelResult.getValue('DEPT_CODE'));
								panelSearch.setValue('DEPT_NAME', panelResult.getValue('DEPT_NAME'));		
								gsWhCode = records[0]['WH_CODE'];
								var whStore = panelResult.getField('WH_CODE').getStore();							
								console.log("whStore : ",whStore);							
								whStore.clearFilter(true);
								whStore.filter([
									 {property:'option', value:panelResult.getValue('DIV_CODE')}
									,{property:'value', value: records[0]['WH_CODE']}
								]);
								panelResult.getField('WH_CODE').setValue(records[0]['WH_CODE']);
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
			}),{
				    fieldLabel: '<t:message code="system.label.inventory.warehouse" default="창고"/>',
				    name: 'WH_CODE', 
				    xtype: 'uniCombobox', 
				    colspan: 2,
				    store: Ext.data.StoreManager.lookup('whList'),
				    allowBlank: false,
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
    });		// end of var panelResult = Unilite.createSearchForm('resultForm',{

    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('bid120skrvGrid', {
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
			{dataIndex: 'ITEM_LEVEL1'				, width: 150,
			summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '', '총계');
            }},
			{dataIndex: 'ITEM_LEVEL2'				, width: 150}, 				
			{dataIndex: 'ITEM_LEVEL3'				, width: 150}, 				
			{dataIndex: 'STOCK_Q'					, width: 100 , summaryType: 'sum'}, 				
			{dataIndex: 'STOCK_I'					, width: 120 , summaryType: 'sum'}, 				
			{dataIndex: 'STOCK_TAX'					, width: 120 , summaryType: 'sum'}, 				
			{dataIndex: 'SALE_I'					, width: 120 , summaryType: 'sum'}, 					
			{dataIndex: 'SALE_TAX'					, width: 120 , summaryType: 'sum'}
		] 
    });	//End of var masterGrid = Unilite.createGrid('bid120skrvGrid', {
    
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
		id: 'bid120skrvApp',
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons(['reset', 'prev', 'next'], true);
			UniAppManager.setToolbarButtons('reset', false); 
			this.setDefault();
			bid120skrvService.userWhcode({}, function(provider, response)	{
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
