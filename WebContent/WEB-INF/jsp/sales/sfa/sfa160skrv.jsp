<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="sfa160skrv"  >	
	<t:ExtComboStore comboType="BOR120"  pgmId="sfa160skrv" /> 			<!-- 사업장 -->  
	<t:ExtComboStore comboType="AU" comboCode="B055" /> <!-- 거래처분류 -->      
	<t:ExtComboStore comboType="AU" comboCode="B056" /> <!-- 지역 -->       
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
	Unilite.defineModel('Sfa160skrvModel', {
	    fields: [  	 
	    	{name: 'SALE_CUSTOM_CODE'	,text: '<t:message code="system.label.sales.custom" default="거래처"/>'		,type: 'string'},
	    	{name: 'CUSTOM_NAME'		,text: '<t:message code="system.label.sales.customname" default="거래처명"/>'		,type: 'string'},
		    {name: 'DIV_CODE'			,text: '<t:message code="system.label.sales.division" default="사업장"/>'		    ,type: 'string'},
		    {name: 'DIV_NAME'			,text: '<t:message code="system.label.sales.division" default="사업장"/>'		    ,type: 'string'},
		    {name: 'ITEM_CODE'			,text: '<t:message code="system.label.sales.item" default="품목"/>'		,type: 'string'},
		    {name: 'ITEM_NAME'			,text: '<t:message code="system.label.sales.itemname" default="품목명"/>'		    ,type: 'string'},
		    {name: 'SPEC'				,text: '<t:message code="system.label.sales.spec" default="규격"/>'			,type: 'string'},
		    {name: 'SALE_UNIT'			,text: '<t:message code="system.label.sales.salesunit" default="판매단위"/>'		,type: 'string', displayField: 'value'},
		    {name: 'TRNS_RATE'			,text: '<t:message code="system.label.sales.containedqty" default="입수"/>'			,type: 'string'},
		    {name: 'INSERT_DB_TIME'     ,text: '<t:message code="system.label.sales.priceapplydate" default="단가적용일"/>'     ,type: 'uniDate'},
		    {name: 'SALE_BASIS_P'		,text: '<t:message code="system.label.sales.sellingprice" default="판매단가"/>'		,type: 'uniUnitPrice'},
		    {name: 'SALE_Q'				,text: '<t:message code="system.label.sales.salesqty" default="매출량"/>'		    ,type: 'uniQty'},
		    {name: 'BASIS_AMT_O'		,text: '<t:message code="system.label.sales.sellingamount" default="판매금액"/>'		,type: 'uniPrice'},
		    {name: 'SALE_AMT_O'			,text: '<t:message code="system.label.sales.salesamount2" default="매출금액"/>'		,type: 'uniPrice'},
		    {name: 'MINUS_AMT_O'		,text: '<t:message code="system.label.sales.deductionamount" default="차감액"/>'		    ,type: 'uniPrice'},
		    {name: 'SALE_RATE'			,text: '<t:message code="system.label.sales.salesrate" default="영업율(%)"/>'	    ,type: 'uniER'},
		    {name: 'AGENT_TYPE'			,text: '<t:message code="system.label.sales.customclass" default="거래처분류"/>'		,type: 'string'},
		    {name: 'AREA_TYPE'			,text: '<t:message code="system.label.sales.area" default="지역"/>'			,type: 'string'},
		    {name: 'SORT'				,text: 'SORT'		    ,type: 'string'}
	    ]
	});
	
	Unilite.defineModel('Sfa160skrvModel2', {
        fields: [    
            {name: 'SALE_CUSTOM_CODE'   ,text: '<t:message code="system.label.sales.item" default="품목"/>'       ,type: 'string'},
            {name: 'CUSTOM_NAME'        ,text: '<t:message code="system.label.sales.itemname" default="품목명"/>'         ,type: 'string'},
            {name: 'DIV_CODE'           ,text: '<t:message code="system.label.sales.division" default="사업장"/>'         ,type: 'string'},
            {name: 'DIV_NAME'           ,text: '<t:message code="system.label.sales.division" default="사업장"/>'         ,type: 'string'},
            {name: 'ITEM_CODE'          ,text: '<t:message code="system.label.sales.item" default="품목"/>'       ,type: 'string'},
            {name: 'ITEM_NAME'          ,text: '<t:message code="system.label.sales.itemname" default="품목명"/>'         ,type: 'string'},
            {name: 'SPEC'               ,text: '<t:message code="system.label.sales.spec" default="규격"/>'           ,type: 'string'},
            {name: 'SALE_UNIT'          ,text: '<t:message code="system.label.sales.salesunit" default="판매단위"/>'       ,type: 'string', displayField: 'value'},
            {name: 'TRNS_RATE'          ,text: '<t:message code="system.label.sales.containedqty" default="입수"/>'           ,type: 'string'},
            {name: 'INSERT_DB_TIME'     ,text: '<t:message code="system.label.sales.priceapplydate" default="단가적용일"/>'     ,type: 'uniDate'},
            {name: 'SALE_BASIS_P'       ,text: '<t:message code="system.label.sales.sellingprice" default="판매단가"/>'       ,type: 'uniUnitPrice'},
            {name: 'SALE_Q'             ,text: '<t:message code="system.label.sales.salesqty" default="매출량"/>'         ,type: 'uniQty'},
            {name: 'BASIS_AMT_O'        ,text: '<t:message code="system.label.sales.sellingamount" default="판매금액"/>'       ,type: 'uniPrice'},
            {name: 'SALE_AMT_O'         ,text: '<t:message code="system.label.sales.salesamount2" default="매출금액"/>'       ,type: 'uniPrice'},
            {name: 'MINUS_AMT_O'        ,text: '<t:message code="system.label.sales.deductionamount" default="차감액"/>'         ,type: 'uniPrice'},
            {name: 'SALE_RATE'          ,text: '<t:message code="system.label.sales.salesrate" default="영업율(%)"/>'      ,type: 'uniER'},
            {name: 'AGENT_TYPE'         ,text: '<t:message code="system.label.sales.customclass" default="거래처분류"/>'     ,type: 'string'},
            {name: 'AREA_TYPE'          ,text: '<t:message code="system.label.sales.area" default="지역"/>'           ,type: 'string'},
            {name: 'SORT'               ,text: 'SORT'           ,type: 'string'}
        ]
    });
	
	// GroupField string type으로 변환
	function dateToString(v, record){
		return UniDate.safeFormat(v);
	  }
	  
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('sfa160skrvMasterStore1',{
		model: 'Sfa160skrvModel',
		uniOpt: {
        	isMaster: true,	// 상위 버튼 연결 
        	editable: false,	// 수정 모드 사용 
        	deletable: false,	// 삭제 가능 여부 
	    	useNavi: false		// prev | next 버튼 사용
        },
        autoLoad: false,
        proxy: {
        	type: 'direct',
        	api: {			
            	read: 'sfa160skrvService.selectList1'                	
            }
        },
        loadStoreRecords: function()	{
			var param = Ext.getCmp('searchForm').getValues();			
				console.log( param );
				this.load({
					params: param
				});
		},
		groupField: 'SALE_CUSTOM_CODE'
	});
	
	var directMasterStore2 = Unilite.createStore('sfa160skrvMasterStore2',{
        model: 'Sfa160skrvModel2',
        uniOpt: {
            isMaster: true, // 상위 버튼 연결 
            editable: false,    // 수정 모드 사용 
            deletable: false,   // 삭제 가능 여부 
            useNavi: false      // prev | next 버튼 사용
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {          
                read: 'sfa160skrvService.selectList2'                   
            }
        },
        loadStoreRecords: function()    {
            var param = Ext.getCmp('searchForm').getValues();           
                console.log( param );
                this.load({
                    params: param
                });
        },
        groupField: 'SALE_CUSTOM_CODE'
    });

 	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */

	var panelSearch = Unilite.createSearchPanel('searchForm', {          
		title: '<t:message code="system.label.sales.searchconditon" default="검색조건"/>',         
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
			title: '<t:message code="system.label.sales.basisinfo" default="기본정보"/>',   
			itemId: 'search_panel1',
			layout: {type: 'vbox', align: 'stretch'},
			items: [{
				xtype: 'container',
		    	layout: {type: 'uniTable', columns: 1},
		    	items: [{
		    		fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
		    		name: 'DIV_CODE', 
		    		xtype: 'uniCombobox', 
		    		comboType: 'BOR120', 
		    		allowBlank: true ,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('DIV_CODE', newValue);
						}
					}
				},
					Unilite.popup('AGENT_CUST',{
						fieldLabel: '<t:message code="system.label.sales.custom" default="거래처"/>', 
						valueFieldName	: 'CUSTOM_CODE',
						textFieldName	: 'CUSTOM_NAME',
						validateBlank	: false,
						listeners: {
							onValueFieldChange: function(field, newValue, oldValue){
								panelResult.setValue('CUSTOM_CODE', newValue);

								if(!Ext.isObject(oldValue)) {
									panelSearch.setValue('CUSTOM_NAME', '');
									panelResult.setValue('CUSTOM_NAME', '');
								}
							},
							onTextFieldChange: function(field, newValue, oldValue){
								panelResult.setValue('CUSTOM_NAME', newValue);

								if(!Ext.isObject(oldValue)) {
									panelSearch.setValue('CUSTOM_CODE', '');
									panelResult.setValue('CUSTOM_CODE', '');
								}
							}
						}
		    	}),{
		    		fieldLabel: '<t:message code="system.label.sales.salesdate" default="매출일"/>',
		    		xtype: 'uniDateRangefield',
					startFieldName: 'SALES_DATE_FR',
					endFieldName: 'SALES_DATE_TO',	
					width: 315,
					startDate: UniDate.get('startOfMonth'),
					endDate: UniDate.get('today'),                	
	                onStartDateChange: function(field, newValue, oldValue, eOpts) {
	                	if(panelResult) {
							panelResult.setValue('SALES_DATE_FR', newValue);
							//panelResult.getField('ISSUE_REQ_DATE_FR').validate();							
	                	}
				    },
				    onEndDateChange: function(field, newValue, oldValue, eOpts) {
				    	if(panelResult) {
				    		panelResult.setValue('SALES_DATE_TO', newValue);
				    		//panelResult.getField('ISSUE_REQ_DATE_TO').validate();				    		
				    	}
				    }
				}]         			 
		     }]
		}, {
			title:'<t:message code="system.label.sales.additionalinfo" default="추가정보"/>',
			id: 'search_panel2',
			itemId:'search_panel2',
	    	defaultType: 'uniTextfield',
	    	layout: {type: 'uniTable', columns: 1},
			items:[{
	     		fieldLabel: '<t:message code="system.label.sales.customclass" default="거래처분류"/>',
	     		name: 'AGENT_TYPE', 	
	     		xtype: 'uniCombobox', 
	     		comboType: 'AU',comboCode: 'B055'  
	     	}, {
			    fieldLabel: '<t:message code="system.label.sales.area" default="지역"/>',
			    name: 'AREA_TYPE', 	
			    xtype: 'uniCombobox', 
			    comboType: 'AU',
			    comboCode: 'B056'  
			}, {
	     		fieldLabel: '<t:message code="system.label.sales.majorgroup" default="대분류"/>',
	     		name: 'TXTLV_L1',
	     		xtype: 'uniCombobox',  
	     		store: Ext.data.StoreManager.lookup('itemLeve1Store'), 
	     		child: 'TXTLV_L2'
	     	}, {
	     		fieldLabel: '<t:message code="system.label.sales.middlegroup" default="중분류"/>',
	     		name: 'TXTLV_L2', 
	     		xtype: 'uniCombobox',  
	     		store: Ext.data.StoreManager.lookup('itemLeve2Store'), 
	     		child: 'TXTLV_L3'
	     	}, {
			    fieldLabel: '<t:message code="system.label.sales.minorgroup" default="소분류"/>',
			    name: 'TXTLV_L3', 
			    xtype: 'uniCombobox',  
			    store: Ext.data.StoreManager.lookup('itemLeve3Store')
			}, {
					xtype: 'container',
		        	defaultType: 'uniTextfield',
		        	layout: {type: 'uniTable', columns: 1},
		            items: [{
		            	fieldLabel: '<t:message code="system.label.sales.salesamount" default="매출액"/>', 
		            	suffixTpl: '&nbsp;<t:message code="system.label.sales.over" default="이상"/>&nbsp;', 
		            	name: 'SALE_AMT_O_FR'
		            }, {
		            	fieldLabel: ' ',
                        name: 'SALE_AMT_O_TO',
		            	suffixTpl: '&nbsp;<t:message code="system.label.sales.below" default="이하"/>&nbsp;', 
		            	name: ''
		            }] 
			},
			Unilite.popup('DIV_PUMOK',{ 
				fieldLabel		: '<t:message code="system.label.sales.repmodel" default="대표모델"/>',
				valueFieldName	: 'ITEM_CODE', 
				textFieldName	: 'ITEM_NAME',
				validateBlank	: false,
				listeners: {
					onValueFieldChange: function(field, newValue, oldValue){
						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('ITEM_NAME', '');
						}
					},
					onTextFieldChange: function(field, newValue, oldValue){
						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('ITEM_CODE', '');
						}
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
			})]
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
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
    		fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
    		name: 'DIV_CODE', 
    		xtype: 'uniCombobox', 
    		comboType: 'BOR120', 
    		allowBlank: true ,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},
			Unilite.popup('AGENT_CUST',{
				fieldLabel: '<t:message code="system.label.sales.custom" default="거래처"/>', 
				valueFieldName	: 'CUSTOM_CODE',
				textFieldName	: 'CUSTOM_NAME',
				validateBlank	: false,
				listeners: {
					onValueFieldChange: function(field, newValue, oldValue){
						panelSearch.setValue('CUSTOM_CODE', newValue);

						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('CUSTOM_NAME', '');
							panelResult.setValue('CUSTOM_NAME', '');
						}
					},
					onTextFieldChange: function(field, newValue, oldValue){
						panelSearch.setValue('CUSTOM_NAME', newValue);

						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('CUSTOM_CODE', '');
							panelResult.setValue('CUSTOM_CODE', '');
						}
					}
				}
    	}),{
    		fieldLabel: '<t:message code="system.label.sales.salesdate" default="매출일"/>',
    		xtype: 'uniDateRangefield',
			startFieldName: 'SALES_DATE_FR',
			endFieldName: 'SALES_DATE_TO',	
			width: 315,
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),                	
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelResult) {
					panelSearch.setValue('SALES_DATE_FR', newValue);
					//panelResult.getField('ISSUE_REQ_DATE_FR').validate();							
            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelResult) {
		    		panelSearch.setValue('SALES_DATE_TO', newValue);
		    		//panelResult.getField('ISSUE_REQ_DATE_TO').validate();				    		
		    	}
		    }
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
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('sfa160skrvGrid1', {
    	region: 'center',
		layout: 'fit',
        title: '<t:message code="system.label.sales.clientby" default="고객별"/>',
        excelTitle: '<t:message code="system.label.sales.salesunitsalesstatusinq" default="판매단가대비영업현황 조회(고객별)"/>',
        uniOpt: {
            expandLastColumn: false
        },
    	store: directMasterStore1,
    	features: [{
    		id: 'masterGridSubTotal', 
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: true 
    		}, {
    		id: 'masterGridTotal', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: true
    	}],
       	columns: [        
        	{dataIndex: 'SALE_CUSTOM_CODE'	, width: 80}, 				
			{dataIndex: 'CUSTOM_NAME'		, width: 120,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                   return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.sales.subtotal" default="소계"/>', '<t:message code="system.label.sales.total" default="총계"/>');
                }
            },   			
			{dataIndex: 'DIV_CODE'			, width: 93, hidden: true},    				
			{dataIndex: 'DIV_NAME'			, width: 86},    				
			{dataIndex: 'ITEM_CODE'			, width: 93}, 				
			{dataIndex: 'ITEM_NAME'			, width: 120}, 				
			{dataIndex: 'SPEC'				, width: 120}, 				
			{dataIndex: 'SALE_UNIT'			, width: 66}, 				
			{dataIndex: 'TRNS_RATE'			, width: 90}, 	              
            {dataIndex: 'INSERT_DB_TIME'    , width: 90, hidden: true},			
			{dataIndex: 'SALE_BASIS_P'		, width: 106, summaryType: 'sum'}, 				
			{dataIndex: 'SALE_Q'			, width: 120, summaryType: 'sum'}, 				
			{dataIndex: 'BASIS_AMT_O'		, width: 120, summaryType: 'sum'}, 				
			{dataIndex: 'SALE_AMT_O'		, width: 120, summaryType: 'sum'}, 				
			{dataIndex: 'MINUS_AMT_O'		, width: 120, summaryType: 'sum'}, 				
			{dataIndex: 'SALE_RATE'			, width: 80}, 				
			{dataIndex: 'AGENT_TYPE'		, width: 100}, 				
			{dataIndex: 'AREA_TYPE'			, width: 100}, 				
			{dataIndex: 'SORT'				, width: 66, hidden: true} 				
		] 
    });	//End of var masterGrid = Unilite.createGrid('sfa160skrvGrid1', {
    
    var masterGrid2 = Unilite.createGrid('sfa160skrvGrid2', {
        region: 'center',
        layout: 'fit',
        title: '<t:message code="system.label.sales.itemby" default="품목별"/>',
        excelTitle: '<t:message code="system.label.sales.salesunitsalesstatusinq1" default="판매단가대비영업현황 조회(품목별)"/>',
        uniOpt: {
            expandLastColumn: false
        },
        store: directMasterStore2,
        features: [{
            id: 'masterGridSubTotal', 
            ftype: 'uniGroupingsummary', 
            showSummaryRow: true 
            }, {
            id: 'masterGridTotal',  
            ftype: 'uniSummary',      
            showSummaryRow: true
        }],
        columns: [        
            {dataIndex: 'SALE_CUSTOM_CODE'  , width: 80},                 
            {dataIndex: 'CUSTOM_NAME'       , width: 120,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                   return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.sales.subtotal" default="소계"/>', '<t:message code="system.label.sales.total" default="총계"/>');
                }
            },            
            {dataIndex: 'DIV_CODE'          , width: 93, hidden: true},                 
            {dataIndex: 'DIV_NAME'          , width: 86},                 
            {dataIndex: 'ITEM_CODE'         , width: 93},                 
            {dataIndex: 'ITEM_NAME'         , width: 120},              
            {dataIndex: 'SPEC'              , width: 120},              
            {dataIndex: 'SALE_UNIT'         , width: 66},               
            {dataIndex: 'TRNS_RATE'         , width: 90},       
            {dataIndex: 'INSERT_DB_TIME'    , width: 90, hidden: true},              
            {dataIndex: 'SALE_BASIS_P'      , width: 106, summaryType: 'sum'},              
            {dataIndex: 'SALE_Q'            , width: 120, summaryType: 'sum'},              
            {dataIndex: 'BASIS_AMT_O'       , width: 120, summaryType: 'sum'},              
            {dataIndex: 'SALE_AMT_O'        , width: 120, summaryType: 'sum'},              
            {dataIndex: 'MINUS_AMT_O'       , width: 120, summaryType: 'sum'},              
            {dataIndex: 'SALE_RATE'         , width: 80},               
            {dataIndex: 'AGENT_TYPE'        , width: 100},              
            {dataIndex: 'AREA_TYPE'         , width: 100},              
            {dataIndex: 'SORT'              , width: 66, hidden: true}              
        ] 
    });
    
    var tab = Unilite.createTabPanel('tabPanel',{
        activeTab:  0,
        region: 'center',
        items:  [
             masterGrid,
             masterGrid2
        ]
    });
    
    /**
     * Master Grid2 정의(Grid Panel)
     * @type 
     */
    
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
		id: 'sfa160skrvApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',true);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown: function()	{
            var activeTabId = tab.getActiveTab().getId();
			if(!panelSearch.setAllFieldsReadOnly(true)){
	    		return false;
	    	}
			if(activeTabId == 'sfa160skrvGrid1') {    
				directMasterStore1.loadStoreRecords();
			}else if(activeTabId == 'sfa160skrvGrid2') {    
                directMasterStore2.loadStoreRecords();
            }
		},
		onDetailButtonDown: function() {
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
