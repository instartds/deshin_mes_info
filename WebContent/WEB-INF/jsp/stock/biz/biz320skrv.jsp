<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="biz320skrv"  >
<t:ExtComboStore comboType="BOR120"  />          <!-- 사업장 -->
<t:ExtComboStore comboType="AU" comboCode="B020" /> <!-- 품목계정 -->
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
   Unilite.defineModel('Biz320skrvModel', {
       fields: [ 
       		{name: 'INDEX_01'			 ,text: '계정코드'		,type:'string'},
       		{name: 'INDEX_02'			 ,text: '계정'		,type:'string'},
       		{name: 'ITEM_CODE'			 ,text: '<t:message code="system.label.inventory.item" default="품목"/>'		,type:'string'},
       		{name: 'ITEM_NAME'			 ,text: '<t:message code="system.label.inventory.itemname" default="품목명"/>'		,type:'string'},
       		{name: 'SPEC'				 ,text: '<t:message code="system.label.inventory.spec" default="규격"/>'		,type:'string'},
       		{name: 'STOCK_UNIT'		 	 ,text: '<t:message code="system.label.inventory.inventoryunit" default="재고단위"/>'		,type:'string'},
       		{name: 'BASIS_YYYYMM'		 ,text: '수불년월'		,type:'string'},
       		{name: 'BASIS'				 ,text: '기초수량'		,type:'uniQty'},
       		{name: 'INSTOCK'			 ,text: '입고수량'		,type:'uniQty'},
       		{name: 'OUTSTOCK'			 ,text: '출고수량'		,type:'uniQty'},
       		{name: 'STOCK'				 ,text: '재고수량'		,type:'uniQty'},

       		{name: 'BASIS_I'			 ,text: '기초금액'		,type:'uniPrice'},
       		{name: 'INSTOCK_I'			 ,text: '입고금액'		,type:'uniPrice'},
       		{name: 'OUTSTOCK_I'			 ,text: '출고금액'		,type:'uniPrice'},
       		{name: 'END_STOCK_I'		 ,text: '재고금액'		,type:'uniPrice'},
			
       		{name: 'SEQ'				 ,text: '재고'		,type:'uniQty'}
       ]
   });		// end of Unilite.defineModel('Biz320skrvModel', {
   
   
   Unilite.defineModel('Biz320skrvModel2', {
       fields: [ 

       	    {name: 'INDEX_01'			 ,text: '외주처코드'	,type:'string'},
       		{name: 'INDEX_02'	 		 ,text: '외주처명'		,type:'string'},
       		{name: 'ITEM_CODE'			 ,text: '<t:message code="system.label.inventory.item" default="품목"/>'		,type:'string'},
       		{name: 'ITEM_NAME'			 ,text: '<t:message code="system.label.inventory.itemname" default="품목명"/>'		,type:'string'},
       		{name: 'SPEC'				 ,text: '<t:message code="system.label.inventory.spec" default="규격"/>'		,type:'string'},
       		{name: 'STOCK_UNIT'		 	 ,text: '<t:message code="system.label.inventory.inventoryunit" default="재고단위"/>'		,type:'string'},
       		{name: 'BASIS_YYYYMM'		 ,text: '수불년월'		,type:'string'},
       		{name: 'BASIS'				 ,text: '기초수량'		,type:'uniQty'},
       		{name: 'INSTOCK'			 ,text: '입고수량'		,type:'uniQty'},
       		{name: 'OUTSTOCK'			 ,text: '출고수량'		,type:'uniQty'},
       		{name: 'STOCK'				 ,text: '재고수량'		,type:'uniQty'},

       		{name: 'BASIS_I'			 ,text: '기초금액'		,type:'uniPrice'},
       		{name: 'INSTOCK_I'			 ,text: '입고금액'		,type:'uniPrice'},
       		{name: 'OUTSTOCK_I'			 ,text: '출고금액'		,type:'uniPrice'},
       		{name: 'END_STOCK_I'		 ,text: '재고금액'		,type:'uniPrice'},
			
       		{name: 'SEQ'				 ,text: '재고'		,type:'uniQty'}
       ]
   });
   
   /**
    * Store 정의(Service 정의)
    * @type 
    */               
   var directMasterStore1 = Unilite.createStore('biz320skrvMasterStore1',{
         model: 'Biz320skrvModel',
         uniOpt: {
               isMaster: false,         // 상위 버튼 연결 
               editable: false,         // 수정 모드 사용 
               deletable:false,         // 삭제 가능 여부 
               useNavi : false         // prev | newxt 버튼 사용
                  //비고(*) 사용않함
         },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {         
                      read: 'biz320skrvService.selectList'                   
                }
            },
            loadStoreRecords: function()   {
            var param= Ext.getCmp('searchForm').getValues();
            param.TYPE = '1';
            console.log( param );
            this.load({
               params: param
            });
         },
         groupField: 'INDEX_02'
   });		// end of var directMasterStore1 = Unilite.createStore('biz320skrvMasterStore1',{
   
	var directMasterStore2 = Unilite.createStore('biz320skrvMasterStore2',{
         model: 'Biz320skrvModel2',
         uniOpt: {
               isMaster: false,         // 상위 버튼 연결 
               editable: false,         // 수정 모드 사용 
               deletable:false,         // 삭제 가능 여부 
               useNavi : false         // prev | newxt 버튼 사용
                  //비고(*) 사용않함
         },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {         
                      read: 'biz320skrvService.selectList'                   
                }
            },
            loadStoreRecords: function()   {
            var param= Ext.getCmp('searchForm').getValues();         
            console.log( param );
            param.TYPE = '2';
            this.load({
               params: param
            });
         },
         groupField: 'INDEX_02'
   });
   

   /**
    * 검색조건 (Search Panel)
    * @type 
    */
       var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '검색조건',
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
			title: '기본정보', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
            items:[{
            	fieldLabel: '<t:message code="system.label.inventory.division" default="사업장"/>',
            	name: 'DIV_CODE',
            	xtype: 'uniCombobox',
            	comboType: 'BOR120', 
            	allowBlank: false,
            	value: UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
            },{
            	fieldLabel: '계정',
            	name: 'ACCOUNT',
            	xtype: 'uniCombobox',
            	comboType: 'AU', 
            	comboCode: 'B020',
            	listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ACCOUNT', newValue);
					}
				}
            },{ 
            	fieldLabel: '수불년월',
            	xtype: 'uniMonthRangefield',
            	startFieldName: 'ORDER_DATE_FR',
            	endFieldName: 'ORDER_DATE_TO',
            	startDate: UniDate.get('startOfMonth'),
            	endDate: UniDate.get('startOfMonth'),
            	allowBlank: false,
            	width: 315,
            	onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('ORDER_DATE_FR',newValue);
						
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('ORDER_DATE_TO',newValue);
			    	}
			    }
			},
				Unilite.popup('CUST', {
						fieldLabel: '외주처',
						allowBlank:true,
						autoPopup:false,
						validateBlank:false,						
						valueFieldName: 'CUSTOM_CODE', 
						textFieldName: 'CUSTOM_NAME', 
						textFieldWidth:170, 
						popupWidth: 710,
						listeners: {
							onValueFieldChange:function( elm, newValue, oldValue) {						
								panelResult.setValue('CUSTOM_CODE', newValue);
								
								if(!Ext.isObject(oldValue)) {
									panelResult.setValue('CUSTOM_NAME', '');
									panelSearch.setValue('CUSTOM_NAME', '');
								}
							},
							onTextFieldChange:function( elm, newValue, oldValue) {
								panelResult.setValue('CUSTOM_NAME', newValue);
								
								if(!Ext.isObject(oldValue)) {
									panelResult.setValue('CUSTOM_CODE', '');
									panelSearch.setValue('CUSTOM_CODE', '');
								}
							},
				            applyextparam: function(popup){
				                    popup.setExtParam({'CUSTOM_TYPE':  ['1','2']});
				            	}
						}
					}),
				Unilite.popup('ITEM', {
					fieldLabel: '<t:message code="system.label.inventory.item" default="품목"/>',
					allowBlank:true,
					autoPopup:false,
					validateBlank:false,					
					valueFieldName: 'ITEM_CODE', 
					textFieldName: 'ITEM_NAME', 
					textFieldWidth: 170,
					listeners: {
						onValueFieldChange:function( elm, newValue, oldValue) {						
							panelResult.setValue('ITEM_CODE', newValue);
							
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('ITEM_NAME', '');
								panelSearch.setValue('ITEM_NAME', '');
							}
						},
						onTextFieldChange:function( elm, newValue, oldValue) {
							panelResult.setValue('ITEM_NAME', newValue);
							
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('ITEM_CODE', '');
								panelSearch.setValue('ITEM_CODE', '');
							}
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
	});//End of var panelSearch = Unilite.createSearchForm('searchForm', {
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
            	fieldLabel: '<t:message code="system.label.inventory.division" default="사업장"/>',
            	name: 'DIV_CODE',
            	xtype: 'uniCombobox',
            	comboType: 'BOR120', 
            	allowBlank: false,
            	value: UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
            },{
            	fieldLabel: '계정',
            	name: 'ACCOUNT',
            	xtype: 'uniCombobox',
            	comboType: 'AU', 
            	comboCode: 'B020',
            	listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('ACCOUNT', newValue);
					}
				}
            },{ 
            	fieldLabel: '수불년월',
            	xtype: 'uniMonthRangefield',
            	startFieldName: 'ORDER_DATE_FR',
            	endFieldName: 'ORDER_DATE_TO',
            	startDate: UniDate.get('startOfMonth'),
            	endDate: UniDate.get('today'),
            	allowBlank: false,
            	width: 315,
            	onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelSearch) {
						panelSearch.setValue('ORDER_DATE_FR',newValue);
						
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('ORDER_DATE_TO',newValue);
			    	}
			    }
			},
				Unilite.popup('CUST', {
						fieldLabel: '외주처',
						allowBlank:true,
						autoPopup:false,
						validateBlank:false,						
						valueFieldName: 'CUSTOM_CODE', 
						textFieldName: 'CUSTOM_NAME', 
						textFieldWidth:170, 						
						popupWidth: 710,
						listeners: {
							onValueFieldChange:function( elm, newValue, oldValue) {						
								panelSearch.setValue('CUSTOM_CODE', newValue);
								
								if(!Ext.isObject(oldValue)) {
									panelResult.setValue('CUSTOM_NAME', '');
									panelSearch.setValue('CUSTOM_NAME', '');
								}
							},
							onTextFieldChange:function( elm, newValue, oldValue) {
								panelSearch.setValue('CUSTOM_NAME', newValue);
								
								if(!Ext.isObject(oldValue)) {
									panelResult.setValue('CUSTOM_CODE', '');
									panelSearch.setValue('CUSTOM_CODE', '');
								}
							},
				            applyextparam: function(popup){
				                    popup.setExtParam({'CUSTOM_TYPE':  ['1','2']});
				            	}
						}
					}),
				Unilite.popup('ITEM', {
					fieldLabel: '<t:message code="system.label.inventory.item" default="품목"/>',
					allowBlank:true,
					autoPopup:false,
					validateBlank:false,					
					valueFieldName: 'ITEM_CODE', 
					textFieldName: 'ITEM_NAME', 
					textFieldWidth: 170,
					listeners: {
						onValueFieldChange:function( elm, newValue, oldValue) {						
							panelSearch.setValue('ITEM_CODE', newValue);
							
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('ITEM_NAME', '');
								panelSearch.setValue('ITEM_NAME', '');
							}
						},
						onTextFieldChange:function( elm, newValue, oldValue) {
							panelSearch.setValue('ITEM_NAME', newValue);
							
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('ITEM_CODE', '');
								panelSearch.setValue('ITEM_CODE', '');
							}
						}
					}
				})
		],
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
    });		// end of var panelResult = Unilite.createSearchForm('resultForm',{
   
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */  
    var masterGrid = Unilite.createGrid('biz320skrvGrid1', {
       // for tab       
        layout : 'fit',
        region:'center',
       uniOpt: {
    		useGroupSummary: true,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,
    		filter: {
				useFilter: false,
				autoCreate: false
			},
			excel: {
				useExcel      : true,			//엑셀 다운로드 사용 여부
				exportGroup   : true, 		//group 상태로 export 여부
				onlyData      : false,
				summaryExport : true
			}
        },
        features: [{
        	id: 'masterGridSubTotal',
        	ftype: 'uniGroupingsummary',
        	showSummaryRow: true 
        	},{
        	id: 'masterGridTotal',
        	ftype: 'uniSummary',  
        	showSummaryRow: true
        	} 
        ],
       store: directMasterStore1,
        	columns: [  
        		{ dataIndex: 'INDEX_01'		  	,   width: 73, hidden : true},
        		{ dataIndex: 'INDEX_02'	  	,   width: 150,
					summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
						return Unilite.renderSummaryRow(summaryData, metaData, '품목소계', '총계');
                }},
        		{ dataIndex: 'ITEM_CODE'			,   width: 106},
        		{ dataIndex: 'ITEM_NAME'			,   width: 126},
        		{ dataIndex: 'SPEC'				  	,   width: 126},
        		{ dataIndex: 'STOCK_UNIT'		  	,   width: 66, align:'center'},
        		{ dataIndex: 'BASIS_YYYYMM'		  	,   width: 73, align:'center'},

				{
					text	: '<t:message code="system.label.inventory.basic" default="기초"/>',
					columns	: [
						{ dataIndex: 'BASIS'				,   width: 100,  summaryType:'sum'},
						{ dataIndex: 'BASIS_I'				,   width: 100,  summaryType:'sum'}
					]
				},
				{
					text	: '<t:message code="system.label.inventory.receipt" default="입고"/>',
					columns	: [
						{ dataIndex: 'INSTOCK'				,   width: 100,  summaryType:'sum'},
						{ dataIndex: 'INSTOCK_I'			,   width: 100,  summaryType:'sum'}
					]
				},
				{
					text	: '<t:message code="system.label.inventory.issue" default="출고"/>',
					columns	: [
						{ dataIndex: 'OUTSTOCK'				,   width: 100,  summaryType:'sum'},
						{ dataIndex: 'OUTSTOCK_I'			,   width: 100,  summaryType:'sum'}
					]
				},
				{
					text	: '<t:message code="system.label.inventory.inventory" default="재고"/>',
					columns	: [
						{ dataIndex: 'STOCK'				,   width: 100,  summaryType:'sum'} ,
						{ dataIndex: 'END_STOCK_I'			,   width: 100,  summaryType:'sum'}	
					]
				}			

			]	
    });		// end of var masterGrid = Unilite.createGrid('biz320skrvGrid1', {   
   
    
    var masterGrid2 = Unilite.createGrid('biz320skrvGrid2', {
       // for tab       
        layout : 'fit',
        region:'center',
       uniOpt: {
    		useGroupSummary: true,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,
    		filter: {
				useFilter: false,
				autoCreate: false
			},
			excel: {
				useExcel      : true,			//엑셀 다운로드 사용 여부
				exportGroup   : true, 		//group 상태로 export 여부
				onlyData      : false,
				summaryExport : true
			}
        },
        features: [{
        	id: 'masterGridSubTotal',
        	ftype: 'uniGroupingsummary',
        	showSummaryRow: true 
        	},{
        	id: 'masterGridTotal',
        	ftype: 'uniSummary',  
        	showSummaryRow: true
        	} 
        ],
       store: directMasterStore2,
        	columns: [  
        		{ dataIndex: 'INDEX_01'		  	,   width: 73,	hidden:true},
        		{ dataIndex: 'INDEX_02'		  	,   width: 150,
					summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
						return Unilite.renderSummaryRow(summaryData, metaData, '거래처소계', '총계');
                }},
        		{ dataIndex: 'ITEM_CODE'			,   width: 106},
        		{ dataIndex: 'ITEM_NAME'			,   width: 126},
        		{ dataIndex: 'SPEC'				  	,   width: 126},
        		{ dataIndex: 'STOCK_UNIT'		  	,   width: 66, align:'center'},
        		{ dataIndex: 'BASIS_YYYYMM'		  	,   width: 73, align:'center'},
				{
					text	: '<t:message code="system.label.inventory.basic" default="기초"/>',
					columns	: [
						{ dataIndex: 'BASIS'				,   width: 100,  summaryType:'sum'},
						{ dataIndex: 'BASIS_I'				,   width: 100,  summaryType:'sum'}
					]
				},
				{
					text	: '<t:message code="system.label.inventory.receipt" default="입고"/>',
					columns	: [
						{ dataIndex: 'INSTOCK'				,   width: 100,  summaryType:'sum'},
						{ dataIndex: 'INSTOCK_I'			,   width: 100,  summaryType:'sum'}
					]
				},
				{
					text	: '<t:message code="system.label.inventory.issue" default="출고"/>',
					columns	: [
						{ dataIndex: 'OUTSTOCK'				,   width: 100,  summaryType:'sum'},
						{ dataIndex: 'OUTSTOCK_I'			,   width: 100,  summaryType:'sum'}
					]
				},
				{
					text	: '<t:message code="system.label.inventory.inventory" default="재고"/>',
					columns	: [
						{ dataIndex: 'STOCK'				,   width: 100,  summaryType:'sum'} ,
						{ dataIndex: 'END_STOCK_I'			,   width: 100,  summaryType:'sum'}	
					]
				}		

			]
    });	
    
    //创建标签页面板
	var tab = Unilite.createTabPanel('tabPanel',{
        activeTab: 0,
        region: 'center',
        items: [
                 {
                     title: '품목별'
                     ,xtype:'container'
                     ,layout:{type:'vbox', align:'stretch'}
                     ,items:[masterGrid]
                     ,id: 'biz320skrvGridTab'
                 },
                 {
                     title: '외주처별'
                     ,xtype:'container'
                     ,layout:{type:'vbox', align:'stretch'}
                     ,items:[masterGrid2]
                     ,id: 'biz320skrvGridTab2' 
                 }
        ],
        listeners:  {
            tabChange:  function ( tabPanel, newCard, oldCard, eOpts )  {
                var newTabId = newCard.getId();
                console.log("newCard:  " + newCard.getId());
                console.log("oldCard:  " + oldCard.getId());        
                //탭 넘길때마다 초기화
                UniAppManager.setToolbarButtons(['save', 'newData' ], false);
                panelResult.setAllFieldsReadOnly(false);
//              Ext.getCmp('confirm_check').hide(); //확정버튼 hidden
                
            } 
        }
    });
    
    
    Unilite.Main( {
    	borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				tab, panelResult
			]
		},
			panelSearch  	
		],	
      id  : 'biz320skrvApp',
      fnInitBinding : function() {
         panelSearch.setValue('DIV_CODE',UserInfo.divCode);
         UniAppManager.setToolbarButtons('reset',false);
      },
      onQueryButtonDown : function()   {         
      	if(!UniAppManager.app.checkForNewDetail()){
				return false;
		}else{
			var activeTabId = tab.getActiveTab().getId();  
			if(activeTabId == 'biz320skrvGridTab'){
		         masterGrid.getStore().loadStoreRecords();
//		         var viewLocked = masterGrid.lockedGrid.getView();
//		         var viewNormal = masterGrid.normalGrid.getView();
//		         console.log("viewLocked : ",viewLocked);
//		         console.log("viewNormal : ",viewNormal);
//		         viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
//		         viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
//		         viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
//		         viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
		         UniAppManager.setToolbarButtons('excel',true);
			}else if(activeTabId == 'biz320skrvGridTab2' ){
				 masterGrid2.getStore().loadStoreRecords();
//		         var viewLocked = masterGrid2.lockedGrid.getView();
//		         var viewNormal = masterGrid2.normalGrid.getView();
//		         console.log("viewLocked : ",viewLocked);
//		         console.log("viewNormal : ",viewNormal);
//		         viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
//		         viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
//		         viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
//		         viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
		         UniAppManager.setToolbarButtons('excel',true);
			}
		}
      },
		checkForNewDetail:function() { 			
			return panelSearch.setAllFieldsReadOnly(true);
        }
		/*        onSaveAsExcelButtonDown: function() {
					 masterGrid.downloadExcelXml();
				}*/
   });
};


</script>