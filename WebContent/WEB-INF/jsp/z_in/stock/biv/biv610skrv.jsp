<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="biv610skrv">
	<t:ExtComboStore comboType="BOR120" />
	<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B014" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />  
	<!-- 조달구분 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {
	color: #333333;
	font-weight: normal;
	padding: 1px 2px;
}
</style>
<script type="text/javascript">

function appMain() {
   
    /**
	 * Model 정의
	 * 
	 * @type
	 */
	 
	 /**************   갑(제품)   **************/
    Unilite.defineModel('biv610skrvModel1', {  // 모델정의 - 디테일 그리드
        fields: [
			{name: 'ITEM_GROUP'                          ,text: '대표코드'                , type: 'string'},
			{name: 'ITEM_GROUP_NAME'               , text: '대표코드명'            , type: 'string'},
			{name: 'ITEM_GROUP_SPEC'                 , text: '대표코드규격'         , type: 'string'},
			{name: 'ITEM_CODE'                               , text: '<t:message code="system.label.inventory.item" default="품목"/>'                , type: 'string'},
			{name: 'ITEM_NAME'                              , text: '<t:message code="system.label.inventory.itemname" default="품목명"/>'                    , type: 'string'},
			{name: 'SPEC'                                           , text: '<t:message code="system.label.inventory.spec" default="규격"/>'                        , type: 'string'},
			{name: 'IN_Q'                                           , text: '입고량'                    , type: 'uniQty'},
			{name: 'OUT_Q'                                       , text: '출고량'                    , type: 'uniQty'},
			{name: 'SAFE_STOCK_Q'                        , text:'안전재고량'             , type:'uniQty'},
			{name: 'PRODUCT_LDTIME'                  , text: '최소안전재고'         , type: 'uniQty'},
			{name: 'STOCK_Q'                                   , text: '현재고'                    , type: 'uniQty'},
			{name: 'OVER_Q'                                      , text: '과부족'                    , type: 'uniQty'}
        ]
    });
    
    /**************   을(반제품)   **************/
    Unilite.defineModel('biv610skrvModel2', {  // 모델정의 - 디테일 그리드
        fields: [
			{name: 'ITEM_GROUP'                          , text: '대표코드'					, type: 'string'},
			{name: 'ITEM_GROUP_NAME'             , text: '대표코드명'				, type: 'string'},
			{name: 'ITEM_GROUP_SPEC'               , text: '대표코드규격'				, type: 'string'},
			{name: 'ITEM_CODE'                             , text: '<t:message code="system.label.inventory.item" default="품목"/>'					, type: 'string'},
			{name: 'ITEM_NAME'                            , text: '<t:message code="system.label.inventory.itemname" default="품목명"/>'						, type: 'string'},
			{name: 'SPEC'                                         , text: '<t:message code="system.label.inventory.spec" default="규격"/>'							, type: 'string'},
			{name: 'IN_Q'                                        , text: '입고량'						, type: 'uniQty'},
			{name: 'OUT_Q'                                    , text: '출고량'						, type: 'uniQty'},
			{name: 'SAFE_STOCK_Q'                     , text:'안전재고량'					, type:'uniQty'},
			{name: 'PRODUCT_LDTIME'                , text: '최소안전재고'				, type: 'uniQty'},
			{name: 'STOCK_Q'                                 , text: '현재고'						, type: 'uniQty'},
			{name: 'OVER_Q'                                     , text: '과부족'						, type: 'uniQty'}
        ]
    });
    
    /**************   병(자재)   **************/
    Unilite.defineModel('biv610skrvModel3', {  // 모델정의 - 디테일 그리드
        fields: [
			{name: 'ITEM_CODE'							, text: '<t:message code="system.label.inventory.item" default="품목"/>'					, type: 'string'},
			{name: 'ITEM_NAME'							, text: '<t:message code="system.label.inventory.itemname" default="품목명"/>'						, type: 'string'},
			{name: 'SPEC'										, text: '<t:message code="system.label.inventory.spec" default="규격"/>'							, type: 'string'},
			{name: 'RCV_Q'										, text: '실입고량'					, type: 'uniQty'			,hidden:true},
			{name: 'IN_Q'										, text: '입고량'						, type: 'uniQty'},
			{name: 'OUT_Q'									, text: '출고량'						, type: 'uniQty'},
			{name: 'PRODUCT_LDTIME'				, text:'리드타임'						, type:'uniQty'},
			{name: 'SAFE_STOCK_Q'						, text: '안전재고'					, type: 'uniQty'},
			{name: 'STOCK_Q'								, text: '현재고'						, type: 'uniQty'},
			{name: 'OVER_Q'									, text: '과부족'						, type: 'uniQty'}
        ]
    });
    
    
   /**
	 * Store 정의(Combobox)
	 * 
	 * @type
	 */       
	 
    var directMasterStore1 = Unilite.createStore('biv610skrvMasterStore1', {
        model: 'biv610skrvModel1',
        uniOpt: {
            isMaster: true,         // 상위 버튼 연결
            editable: false,         // 수정 모드 사용
            deletable: false,        // 삭제 가능 여부
            useNavi: false          // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy:{
            type: 'direct',
            api: {          
                   read: 'biv610skrvService.selectList1'                    
            }
        },
        loadStoreRecords: function(){
            var param= Ext.getCmp('resultForm').getValues();            
            console.log(param);
            this.load({
                params: param
            });
        }
    });
    
    var directMasterStore2 = Unilite.createStore('biv610skrvMasterStore2', {
        model: 'biv610skrvModel2',
        uniOpt: {
            isMaster: true,         // 상위 버튼 연결
            editable: false,         // 수정 모드 사용
            deletable: false,        // 삭제 가능 여부
            useNavi: false          // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy:{
            type: 'direct',
            api: {          
                   read: 'biv610skrvService.selectList2'                    
            }
        },
        loadStoreRecords: function(){
            var param= Ext.getCmp('resultForm').getValues();            
            console.log(param);
            this.load({
                params: param
            });
        }
    });
    
    var directMasterStore3 = Unilite.createStore('biv610skrvMasterStore3', {
        model: 'biv610skrvModel3',
        uniOpt: {
            isMaster: true,         // 상위 버튼 연결
            editable: false,         // 수정 모드 사용
            deletable: false,        // 삭제 가능 여부
            useNavi: false          // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy:{
            type: 'direct',
            api: {          
                   read: 'biv610skrvService.selectList3'                    
            }
        },
        loadStoreRecords: function(){
            var param= Ext.getCmp('resultForm').getValues();            
            console.log(param);
            this.load({
                params: param
            });
        }
    });
    
    
    
    
	
	/**
	 * 검색조건 (Search Panel)
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {          
		title: '검색조건',         
		defaultType: 'uniSearchSubPanel',
		collapsed: UserInfo.appOption.collapseLeftSearch,
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
			layout: {type: 'vbox', align: 'stretch'},
        	items: [{
        		xtype: 'container',
        		layout: {type: 'uniTable', columns: 1},
        		items: [{
                    fieldLabel: '<t:message code="system.label.inventory.division" default="사업장"/>',
                    name:'DIV_CODE',
                    xtype: 'uniCombobox',
                    comboType:'BOR120',
                    allowBlank:false,
                    holdable: 'hold',
                    value: UserInfo.divCode,  
                    listeners: {
    					change: function(field, newValue, oldValue, eOpts) {						
    						panelResult.setValue('DIV_CODE', newValue);
    					}
    				}
                },
                {
                    fieldLabel: '수불일',
                    xtype: 'uniDateRangefield',
                    startFieldName: 'INOUT_DATE_FR',
                    endFieldName: 'INOUT_DATE_TO',
                   width: 315,
                    startDate: UniDate.get('startOfMonth'),
                    endDate: UniDate.get('today'),
                    onStartDateChange: function(field, newValue, oldValue, eOpts) {
                        if(panelResult) {
                            panelResult.setValue('INOUT_DATE_FR', newValue);
                        }
                    },
                    onEndDateChange: function(field, newValue, oldValue, eOpts) {
                        if(panelResult) {
                        	panelResult.setValue('INOUT_DATE_TO', newValue);
                        }
                    }
                },{
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
                }
            ]	            			 
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
    
    
    
    /**
	 * 검색조건 (Search Result) - 상단조건
	 * 
	 * @type
	 */
    var panelResult = Unilite.createSearchForm('resultForm',{
        region: 'north',
        layout : {type : 'uniTable', columns : 5},
        padding:'1 1 1 1',
        border:true,
        hidden: !UserInfo.appOption.collapseLeftSearch,
        items: [{
                fieldLabel: '<t:message code="system.label.inventory.division" default="사업장"/>',
                name:'DIV_CODE',
                xtype: 'uniCombobox',
                comboType:'BOR120',
                allowBlank:false,
                holdable: 'hold',
                value: UserInfo.divCode,  
                width: 300,
                listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
            },
            {
                fieldLabel: '수불일',
                xtype: 'uniDateRangefield',
                startFieldName: 'INOUT_DATE_FR',
                endFieldName: 'INOUT_DATE_TO',
               width: 315,
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today'),
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelSearch) {
                        panelSearch.setValue('INOUT_DATE_FR', newValue);
                    }
                },
                onEndDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelSearch) {
                        panelSearch.setValue('INOUT_DATE_TO', newValue);
                    }
                }
            },{
                fieldLabel: '<t:message code="system.label.inventory.majorgroup" default="대분류"/>', 
                name: 'ITEM_LEVEL1', 
                xtype: 'uniCombobox',  
                store: Ext.data.StoreManager.lookup('itemLeve1Store'), 
                child: 'ITEM_LEVEL2',
                width: 200,
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
                width: 200,
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
                width: 200,
                listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('ITEM_LEVEL3', newValue);
					}
				}
            }
        ] ,
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
                    var fields = this.getForm().getFields();
                    Ext.each(fields.items, function(item) {
                        if(Ext.isDefined(item.holdable) )   {
                            if (item.holdable == 'hold') {
                                item.setReadOnly(true); 
                            }
                        } 
                        if(item.isPopupField)   {
                            var popupFC = item.up('uniPopupField')  ;                           
                            if(popupFC.holdable == 'hold') {
                                popupFC.setReadOnly(true);
                            }
                        }
                    })  
                }
            } else {
                var fields = this.getForm().getFields();
                Ext.each(fields.items, function(item) {
                    if(Ext.isDefined(item.holdable) )   {
                        if (item.holdable == 'hold') {
                            item.setReadOnly(false);
                        }
                    } 
                    if(item.isPopupField)   {
                        var popupFC = item.up('uniPopupField')  ;   
                        if(popupFC.holdable == 'hold' ) {
                            item.setReadOnly(false);
                        }
                    }
                })
            }
            return r;
        }
    });
    
    
  
    
    
    /**
	 * Master Grid1 정의(Grid Panel)
	 * 
	 * @type
	 */
    var masterGrid1 = Unilite.createGrid('biv610skrvGrid1', {      // detail그리드
        layout: 'fit',
        region: 'center',
        uniOpt: {
        	useGroupSummary    : true,
            expandLastColumn: false,
            useRowNumberer: false,
            copiedRow: true,
            onLoadSelectFirst: true
        },
        features: [{
            id: 'masterGridSubTotal',                                                                     
            ftype: 'uniGroupingsummary',                                                                  
            showSummaryRow: true                                                                         
        },{                                                                                               
            id: 'masterGridTotal',                                                                        
            ftype: 'uniSummary',                                                                          
            showSummaryRow: true                                                                         
        }],                                                                                               
        store: directMasterStore1,
        columns: [
        	     {dataIndex: 'ITEM_GROUP'		    		, width: 100   },
	       	     {dataIndex: 'ITEM_GROUP_NAME'       , width: 150   },
	       	     {dataIndex: 'ITEM_GROUP_SPEC'      	, width: 120   },
	       	     {dataIndex: 'ITEM_CODE'		    			, width: 80   },
	       	     {dataIndex: 'ITEM_NAME'		     			, width: 230   },
	       	     {dataIndex: 'SPEC'			        				, width: 150   },
	       	     {dataIndex: 'IN_Q'			         				, width: 100   , summaryType: 'sum' },
	       	     {dataIndex: 'OUT_Q'			     				, width: 100   , summaryType: 'sum' },
	       	     {dataIndex: 'SAFE_STOCK_Q'	         	, width: 100   , summaryType: 'sum' },
	       	  	 {dataIndex: 'PRODUCT_LDTIME'	     	, width: 100   , summaryType: 'sum' 			, align:'right'},
	       	     {dataIndex: 'STOCK_Q'		         			, width: 100   , summaryType: 'sum' },
	       	     {dataIndex: 'OVER_Q'			     				, width: 100  	, summaryType: 'sum' 			, align:'right' }
        ]
    });
    
    var masterGrid2 = Unilite.createGrid('biv610skrvGrid2', {      // detail그리드
        layout: 'fit',
        region: 'center',
        uniOpt: {
        	useGroupSummary    : true,
            expandLastColumn: false,
            useRowNumberer: false,
            copiedRow: true,
            onLoadSelectFirst: true
        },
        features: [{
            id: 'masterGridSubTotal',                                                                     
            ftype: 'uniGroupingsummary',                                                                  
            showSummaryRow: true                                                                         
        },{                                                                                               
            id: 'masterGridTotal',                                                                        
            ftype: 'uniSummary',                                                                          
            showSummaryRow: true                                                                         
        }],                                                                                               
        store: directMasterStore2,
        columns: [
	        	 {dataIndex: 'ITEM_GROUP'		    		, width: 100   },
	       	     {dataIndex: 'ITEM_GROUP_NAME'       , width: 150   },
	       	     {dataIndex: 'ITEM_GROUP_SPEC'      	, width: 120   },
	       	     {dataIndex: 'ITEM_CODE'		    			, width: 80   },
	       	     {dataIndex: 'ITEM_NAME'		     			, width: 230   },
	       	     {dataIndex: 'SPEC'			        				, width: 150   },
	       	     {dataIndex: 'IN_Q'			         				, width: 100   , summaryType: 'sum'  },
	       	     {dataIndex: 'OUT_Q'			     				, width: 100   , summaryType: 'sum'  },
	       	     {dataIndex: 'SAFE_STOCK_Q'	         	, width: 100   , summaryType: 'sum' },
	       	  	 {dataIndex: 'PRODUCT_LDTIME'	     	, width: 100   , summaryType: 'sum' 			, align:'right'},
	       	     {dataIndex: 'STOCK_Q'		         			, width: 100   , summaryType: 'sum' },
	       	     {dataIndex: 'OVER_Q'			     				, width: 100  	, summaryType: 'sum' 			, align:'right' }
        ]
    });
    
    var masterGrid3 = Unilite.createGrid('biv610skrvGrid3', {      // detail그리드
        layout: 'fit',
        region: 'center',
        uniOpt: {
        	useGroupSummary    : true,
            expandLastColumn: false,
            useRowNumberer: false,
            copiedRow: true,
            onLoadSelectFirst: true
        },
        features: [{
            id: 'masterGridSubTotal',                                                                     
            ftype: 'uniGroupingsummary',                                                                  
            showSummaryRow: true                                                                         
        },{                                                                                               
            id: 'masterGridTotal',                                                                        
            ftype: 'uniSummary',                                                                          
            showSummaryRow: true                                                                         
        }],                                                                                               
        store: directMasterStore3,
        columns: [
	       	     {dataIndex: 'ITEM_CODE'		    			, width: 100   },	
	       	     {dataIndex: 'ITEM_NAME'		     			, width: 250   },                                           			
	       	     {dataIndex: 'SPEC'			        				, width: 320   }, 
	       	     {dataIndex: 'RCV_Q'								, width: 100	, summaryType: 'sum' },		
	       	     {dataIndex: 'IN_Q'			         				, width: 100   , summaryType: 'sum' },                                        		
	       	     {dataIndex: 'OUT_Q'			     				, width: 100   , summaryType: 'sum' }, 
	       	  	 {dataIndex: 'PRODUCT_LDTIME'	     	, width: 100   , summaryType: 'sum' 			, align:'right'},  
	       	     {dataIndex: 'SAFE_STOCK_Q'	         	, width: 100  	, summaryType: 'sum' 			, align:'right' },                                                 
	       	     {dataIndex: 'STOCK_Q'		         			, width: 100   , summaryType: 'sum' },                                           		
	       	     {dataIndex: 'OVER_Q'			     				, width: 100   , summaryType: 'sum' 			, align:'right'}
        ]
    });
    
       
    
    
    /**
	 * Tab 정의(tab)
	 * 
	 * @type
	 */
    var tab = Unilite.createTabPanel('tabPanel', {
		activeTab : 0,
		region : 'center',
		items : [ 
		 {
			title : '갑(제품)',
			xtype : 'container',
			layout : {
				type : 'vbox',
				align : 'stretch'
			},
			items : [ masterGrid1 ],
			id : 'biv610skrvGridTab1'
		}, 
		{
			title : '을(반제품)',
			xtype : 'container',
			layout : {
				type : 'vbox',
				align : 'stretch'
			},
			items : [ masterGrid2 ],
			id : 'biv610skrvGridTab2'
		},
		{
			title : '병(자재)',
			xtype : 'container',
			layout : {
				type : 'vbox',
				align : 'stretch'
			},
			items : [ masterGrid3],
			id : 'biv610skrvGridTab3'
		}]
	});
    
    
    
    Unilite.Main( {
        //border: false,
        borderItems:[{
                region:'center',
                layout: 'border',
                border: false,
                items : [ 
                          tab,panelResult 
                ]
        },panelSearch
        ],
        id: 'biv610skrvApp',
        setDefault: function() {
            UniAppManager.setToolbarButtons(['save'], false);
        },
        fnInitBinding: function() {          
             panelResult.setValue('DIV_CODE',UserInfo.divCode);
             panelResult.setValue('INOUT_DATE_FR',UniDate.get('startOfMonth'));
             panelResult.setValue('INOUT_DATE_TO',UniDate.get('today'));
             panelSearch.setValue('DIV_CODE',UserInfo.divCode);
             panelSearch.setValue('INOUT_DATE_FR',UniDate.get('startOfMonth'));
             panelSearch.setValue('INOUT_DATE_TO',UniDate.get('today'));
            UniAppManager.setToolbarButtons(['reset'], true); // 초기화버튼 활성화여부
        },
        onQueryButtonDown: function() { // 조회//DIV_CODE필수
           
        
            var activeTabId = tab.getActiveTab().getId();
			if(activeTabId == 'biv610skrvGridTab1'){				
				 if(panelResult.getValue('DIV_CODE') != ''){
					 masterGrid1.getStore().loadStoreRecords();
		            	 } else if(panelResult.getValue('DIV_CODE') == ''){
		            		 alert('품목 필수입력값입니다!');
		            		 return false;
		            }else{
		            	return false;
		            }
			}
			else if(activeTabId == 'biv610skrvGridTab2'){
				 if(panelResult.getValue('DIV_CODE') != ''){
		            	directMasterStore2.loadStoreRecords();
		            	 } else if(panelResult.getValue('DIV_CODE') == ''){
		            		 alert('품목 필수입력값입니다!');
		            		 return false;
		            }else{
		            	return false;
		            }
			} 
			else if(activeTabId == 'biv610skrvGridTab3'){
				 if(panelResult.getValue('DIV_CODE') != ''){
		            	directMasterStore3.loadStoreRecords();
		            	 } else if(panelResult.getValue('DIV_CODE') == ''){
		            		 alert('품목 필수입력값입니다!');
		            		 return false;
		            }else{
		            	return false;
		            }
			}
        },
        onResetButtonDown : function() { // 초기화
            panelResult.setAllFieldsReadOnly(false);
            masterGrid1.reset();
            masterGrid2.reset();
            masterGrid3.reset();
            panelResult.clearForm();
            directMasterStore1.clearData();
            directMasterStore2.clearData();
            directMasterStore3.clearData();
            this.fnInitBinding();
        }
    });
};

</script>


