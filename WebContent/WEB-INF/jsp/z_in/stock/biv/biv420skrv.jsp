<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="biv420skrv"  >
   
   <t:ExtComboStore comboType="BOR120" comboCode="B001"  />          <!-- 사업장 -->
   <t:ExtComboStore comboType="AU" comboCode="B020" /> 				 <!-- 계정구분 --> 
   <t:ExtComboStore comboType="AU" comboCode="B036" />				 <!-- 수불방법 -->
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

   Unilite.defineModel('Biv420skrvModel', {
       fields: [ 
			{name: 'COMP_CODE',			 		text:'<t:message code="system.label.inventory.companycode" default="법인코드"/>',	   		type: 'string'},
            {name: 'DIV_CODE',				 	text:'<t:message code="system.label.inventory.division" default="사업장"/>',		   	    type: 'string'},
            {name: 'COMMON_CODE',			 	text:'계정코드',	   		type: 'string'},
            {name: 'COMMON_NAME',			 	text:'계정',		   		type: 'string'},
            {name: 'ITEM_CODE',				 	text:'<t:message code="system.label.inventory.item" default="품목"/>',	   		type: 'string'},
            {name: 'ITEM_NAME',				 	text:'<t:message code="system.label.inventory.itemname" default="품목명"/>',		   	    type: 'string'},
            {name: 'SPEC',					 	text:'<t:message code="system.label.inventory.spec" default="규격"/>',		  		type :'string'},
            {name: 'STOCK_UNIT',			 	text:'단위',		   		type: 'string'},
            {name: 'INOUT_MONTH',			 	text:'수불년월',	   		type: 'uniDate'},
            {name: 'BASIS_Q',				 	text:'기초수량',	   		type: 'uniQty'},
            {name: 'BASIS_I',				 	text:'기초금액',	   		type: 'uniPrice'},
            {name: 'INOUT_DATE',			 	text:'수불일',		   	    type: 'uniDate'},
            {name: 'ITEM_STATUS',			 	text:'수불타입',	   		type: 'string'},
            {name: 'ITEM_STATUS_NAME',		 	text:'수불일',		   	    type: 'uniDate'},
            {name: 'INOUT_TYPE',			 	text:'수불타입코드',  		type: 'string'},
            {name: 'INOUT_TYPE_NAME',		 	text:'수불타입',	   		type: 'string'},
            {name: 'INOUT_TYPE_DETAIL',		 	text:'유형코드',	   		type: 'string'},
            {name: 'INOUT_TYPE_DETAIL_NAME',	text:'유형',		   		type: 'string'},
            {name: 'INOUT_METH',			 	text:'방법코드',	   		type: 'string'},
            {name: 'INOUT_METH_NAME',		 	text:'방법',		   		type: 'string'},
            {name: 'WH_CODE',				 	text:'<t:message code="system.label.inventory.warehouse" default="창고"/>',	   		type: 'string'},
            {name: 'WH_NAME',				 	text:'<t:message code="system.label.inventory.warehouse" default="창고"/>',		   		type: 'string'},
            {name: 'CREATE_LOC',			 	text:'생성코드',	   		type: 'string'},
            {name: 'CREATE_LOC_NAME',		 	text:'생성',		   		type: 'string'},
            {name: 'INOUT_CODE_TYPE',		 	text:'수불코드',	   		type: 'string'},
            {name: 'INOUT_CODE_TYPE_NAME',	 	text:'수불처',		   	    type: 'string'},
            {name: 'INOUT_CODE',			 	text:'수불코드',	   		type: 'string'},
            {name: 'INOUT_CODE_NAME',		 	text:'수불처명',	   		type: 'string'},
            {name: 'PRICE_YN',				 	text:'단가형태',	   		type: 'string'},
            {name: 'PRICE_YN_NAME',			 	text:'단가형태',	   		type: 'string'},
            {name: 'IN_Q',					 	text:'수량',		   		type: 'uniQty'},
            {name: 'IN_P',					 	text:'단가',		   		type: 'uniUnitPrice'},
            {name: 'IN_I',					 	text:'금액',		   		type: 'uniPrice'},
            {name: 'TOT_IN_Q',				 	text:'수량',		   		type: 'uniQty'},
            {name: 'TOT_IN_I',				 	text:'금액',		   		type: 'uniPrice'},
            {name: 'CAL_Q',					 	text:'수량',		   		type: 'uniQty'}, 
            {name: 'CAL_I',					 	text:'금액',		   		type: 'uniPrice'}, 
            {name: 'AVERAGE_P',				 	text:'단가',		   		type: 'uniUnitPrice'}, 
            {name: 'BASIS_P',				 	text:'기준원가',	   		type: 'uniUnitPrice'}, 
            {name: 'PERIODIC_YN',			 	text:'재고평가대상',  		type: 'string'},
            {name: 'PERIODIC_YN_NAME',		 	text:'재고평가대상',  		type: 'string'},
            {name: 'INOUT_PRSN',			 	text:'담당자코드',	   		type: 'string'}, 
            {name: 'INOUT_PRSN_NAME',		 	text:'담당자명',	  		type: 'string'}, 
            {name: 'INOUT_NUM',				 	text:'수불번호',	   		type: 'string'}, 
            {name: 'INOUT_SEQ',				 	text:'수불순번',	   		type: 'string'},
            {name: 'PROJECT_NO',                text:'프로젝트번호',        type: 'string'}, 
            {name: 'LOT_NO',				 	text:'<t:message code="system.label.inventory.lotno" default="LOT번호"/>',		   	    type: 'string'}, 
            {name: 'SORT_WH_CODE',			 	text:'SORT_WH_CODE',  	    type: 'string'}, 
            {name: 'SORT_FLD',				 	text:'SORT_FLD',	   	    type: 'string'} 
		]
	});
   
   /**
    * Store 정의(Service 정의)
    * @type 
    */               
   var directMasterStore1 = Unilite.createStore('biv420skrvMasterStore1',{
         model: 'Biv420skrvModel',
         uniOpt : {
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
                      read: 'biv420skrvService.selectList'                   
                }
            }
         ,loadStoreRecords : function()   {
            var param= Ext.getCmp('searchForm').getValues();         
            console.log( param );
            this.load({
               params : param
            });
            
         },
         groupField: 'CUSTOM_NAME'
         
   });

   /**
    * 검색조건 (Search Panel)
    * @type 
    */
	var panelSearch = Unilite.createSearchPanel('searchForm',{
		collapsed: true,
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
            		name: 'DIV_CODE',
            		xtype: 'uniCombobox',
            		comboType:'BOR120',
            		comboCode:'B001',
            		allowBlank:false,
	            		listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								panelResult.setValue('DIV_CODE', newValue);
							}
						}
            	},{
            		fieldLabel: '<t:message code="system.label.inventory.itemaccount" default="품목계정"/>',
            		name:'ITEM_ACCOUNT',
            		xtype: 'uniCombobox',
            		comboType: 'AU',
            		comboCode: 'B020',
	            		listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								panelResult.setValue('ITEM_ACCOUNT', newValue);
							}
						}
            	},{
					fieldLabel: '수불년월',
	 		        width: 315,
	                xtype: 'uniMonthRangefield',
	                startFieldName: 'FR_INOUT_DATE',
	                endFieldName: 'TO_INOUT_DATE',
	                startDate: UniDate.get('startOfMonth'),
	                endDate: UniDate.get('today'),                	
	                onStartDateChange: function(field, newValue, oldValue, eOpts) {
	                	if(panelResult) {
							panelResult.setValue('FR_INOUT_DATE',newValue);						
	                	}
				    },
				    onEndDateChange: function(field, newValue, oldValue, eOpts) {
				    	if(panelResult) {
				    		panelResult.setValue('TO_INOUT_DATE',newValue);			    		
				    	}
				    }
	            },
					Unilite.popup('DIV_PUMOK',{
						fieldLabel: '<t:message code="system.label.inventory.item" default="품목"/>',
						valueFieldName: 'DIV_PUMOK_CODE', 
						textFieldName: 'DIV_PUMOK_NAME',
						validateBlank: false,
						listeners: {
							onSelected: {
								fn: function(records, type) {
									panelResult.setValue('DIV_PUMOK_CODE', panelSearch.getValue('DIV_PUMOK_CODE'));
									panelResult.setValue('DIV_PUMOK_NAME', panelSearch.getValue('DIV_PUMOK_NAME'));				 																							
								},
								scope: this
							},
							onClear: function(type)	{
								panelResult.setValue('DIV_PUMOK_CODE', '');
								panelResult.setValue('DIV_PUMOK_NAME', '');
							}
						}
				}),{
					xtype: 'radiogroup',                        
					fieldLabel: '재고평가대상',
					items : [{
						boxLabel: '전체',
						width: 60,
						name: 'PERIODIC_YN',
						inputValue: 'A'
					},{
						boxLabel: '<t:message code="system.label.inventory.yes" default="예"/>',
						width: 60,
						name: 'PERIODIC_YN',
						inputValue: 'Y',
						checked: true
					},{
						boxLabel: '<t:message code="system.label.inventory.no" default="아니오"/>', 
						width: 60, 
						name: 'PERIODIC_YN',
						inputValue: 'N'
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {		
							panelResult.getField('PERIODIC_YN').setValue(newValue.PERIODIC_YN);
						}
					}
				}]            
		},{
			title: '추가정보', 	
			itemId: 'search_panel2',
	       	layout: {type: 'uniTable', columns: 1},
	       	defaultType: 'uniTextfield',
			    items: [{ 
					fieldLabel: '<t:message code="system.label.inventory.majorgroup" default="대분류"/>',
					name: 'ITEM_LEVEL1',
					xtype: 'uniCombobox',
					store: Ext.data.StoreManager.lookup('itemLeve1Store'),
					child: 'ITEM_LEVEL2'
				},{
					fieldLabel: '<t:message code="system.label.inventory.middlegroup" default="중분류"/>',
					name: 'ITEM_LEVEL2',
					xtype: 'uniCombobox',
					store: Ext.data.StoreManager.lookup('itemLeve2Store'),
					child: 'ITEM_LEVEL3'
				},{ 
					fieldLabel: '<t:message code="system.label.inventory.minorgroup" default="소분류"/>',
					name: 'ITEM_LEVEL3',
					xtype: 'uniCombobox',
					store: Ext.data.StoreManager.lookup('itemLeve3Store')
				}]
			}
		]
	});
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
            		fieldLabel: '<t:message code="system.label.inventory.division" default="사업장"/>',
            		name: 'DIV_CODE',
            		xtype: 'uniCombobox',
            		comboType:'BOR120',
            		comboCode:'B001',
            		allowBlank:false,
	            		listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								panelSearch.setValue('DIV_CODE', newValue);
							}
						}
            	},{
            		fieldLabel: '<t:message code="system.label.inventory.itemaccount" default="품목계정"/>',
            		name:'ITEM_ACCOUNT',
            		xtype: 'uniCombobox',
            		comboType: 'AU',
            		comboCode: 'B020',
	            		listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								panelSearch.setValue('ITEM_ACCOUNT', newValue);
							}
						}
            	},{
					fieldLabel: '수불년월',
	 		        width: 315,
	                xtype: 'uniMonthRangefield',
	                startFieldName: 'FR_INOUT_DATE',
	                endFieldName: 'TO_INOUT_DATE',
	                startDate: UniDate.get('startOfMonth'),
	                endDate: UniDate.get('today'),                	
	                onStartDateChange: function(field, newValue, oldValue, eOpts) {
	                	if(panelResult) {
							panelSearch.setValue('FR_INOUT_DATE',newValue);						
	                	}
				    },
				    onEndDateChange: function(field, newValue, oldValue, eOpts) {
				    	if(panelResult) {
				    		panelSearch.setValue('TO_INOUT_DATE',newValue);			    		
				    	}
				    }
	            },
					Unilite.popup('DIV_PUMOK',{
						fieldLabel: '<t:message code="system.label.inventory.item" default="품목"/>',
						valueFieldName: 'DIV_PUMOK_CODE', 
						textFieldName: 'DIV_PUMOK_NAME',
						validateBlank: false,
						listeners: {
							onSelected: {
								fn: function(records, type) {
									panelSearch.setValue('DIV_PUMOK_CODE', panelResult.getValue('DIV_PUMOK_CODE'));
									panelSearch.setValue('DIV_PUMOK_NAME', panelResult.getValue('DIV_PUMOK_NAME'));				 																							
								},
								scope: this
							},
							onClear: function(type)	{
								panelSearch.setValue('DIV_PUMOK_CODE', '');
								panelSearch.setValue('DIV_PUMOK_NAME', '');
							}
						}
				}),{
					xtype: 'radiogroup',                        
					fieldLabel: '재고평가대상',
					items : [{
						boxLabel: '전체',
						width: 60,
						name: 'PERIODIC_YN',
						inputValue: 'A'
					},{
						boxLabel: '<t:message code="system.label.inventory.yes" default="예"/>',
						width: 60,
						name: 'PERIODIC_YN',
						inputValue: 'Y',
						checked: true
					},{
						boxLabel: '<t:message code="system.label.inventory.no" default="아니오"/>', 
						width: 60, 
						name: 'PERIODIC_YN',
						inputValue: 'N'
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {		
							panelSearch.getField('PERIODIC_YN').setValue(newValue.PERIODIC_YN);
						}
					}
				}]
	});
   
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('biv420skrvGrid1', {
       region: 'center' ,
        layout : 'fit',
        store : directMasterStore1, 
        uniOpt:{	expandLastColumn: true,
        			useRowNumberer: true,
                    useMultipleSorting: true
        },
        tbar: [{
        	text:'상세보기',
        	handler: function() {
        		var record = masterGrid.getSelectedRecord();
	        	if(record) {
	        		openDetailWindow(record);
	        	}
        	}
        }],
    	store: directMasterStore1,
    	features: [{
    		id: 'masterGridSubTotal', 
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    	},{
    		id: 'masterGridTotal',
    		ftype: 'uniSummary',
    		showSummaryRow: false
    	}],
        columns: [ 
        	{dataIndex: 'COMP_CODE',    width: 66,  hidden: true},             
            {dataIndex: 'DIV_CODE',     width: 66,  hidden: true},             
            {dataIndex: 'COMMON_CODE',  width: 66,  hidden: true},               
            {dataIndex: 'COMMON_NAME',  width: 66,  hidden: true},               
            {dataIndex: 'ITEM_CODE',    width: 100, locked: true},               
            {dataIndex: 'ITEM_NAME',    width: 166, locked: true},               
            {dataIndex: 'SPEC',         width: 133, hidden: true},               
            {dataIndex: 'STOCK_UNIT',   width: 53,  hidden: true},              
			{
				text:'입고정보',
           		columns:[ 
					{dataIndex:'INOUT_TYPE_DETAIL_NAME', width:80, summaryType:'sum'},
             		{dataIndex:'INOUT_METH_NAME',		 width:66, summaryType:'sum'},
             		{dataIndex:'INOUT_METH_NAME',		 width:80, summaryType:'sum'},
              		{dataIndex:'PRICE_YN_NAME',			 width:66, summaryType:'sum'},
              		{dataIndex:'IN_Q',					 width:80, summaryType:'sum'},
             		{dataIndex:'IN_P',					 width:80, summaryType:'sum'},
              		{dataIndex:'IN_I',					 width:80, summaryType:'sum'}
                    
                   		]
          			}, 
					{dataIndex: 'INOUT_DATE',			width: 66, hidden: true},              
					{dataIndex: 'ITEM_STATUS',			width: 66, hidden: true},              
					{dataIndex: 'ITEM_STATUS_NAME',		width: 53, hidden: true},              
					{dataIndex: 'INOUT_TYPE',			width: 66, hidden: true},              
					{dataIndex: 'INOUT_TYPE_NAME',		width: 66, hidden: true},              
					{dataIndex: 'INOUT_TYPE_DETAIL',	width: 66, hidden: true},         
					{dataIndex: 'INOUT_METH',			width: 66, hidden: true},           
					{dataIndex: 'WH_CODE',				width: 66, hidden: true},   
					{dataIndex: 'CREATE_LOC',			width: 66, hidden: true},              
					{dataIndex: 'CREATE_LOC_NAME',		width: 80, hidden: true},              
					{dataIndex: 'INOUT_CODE_TYPE',		width: 66, hidden: true},              
					{dataIndex: 'INOUT_CODE_TYPE_NAME',	width: 80, hidden: true},              
					{dataIndex: 'INOUT_CODE',			width: 66, hidden: true},              
					{dataIndex: 'INOUT_CODE_NAME',		width: 80, hidden: true},              
					{dataIndex: 'PRICE_YN',				width: 66, hidden: true},               
					{
						text: '입고합계',
           				columns:[ 
							{dataIndex: 'TOT_IN_Q', width: 80, summaryType:'sum'},
							{dataIndex: 'TOT_IN_I', width: 80, summaryType:'sum'}
						]
          			},{
						text:'재고평가',
           				columns:[ 
							{dataIndex: 'CAL_Q', width: 80, summaryType: 'sum'},
             				{dataIndex: 'CAL_I', width: 80, summaryType: 'sum'}
                    	]
          			},{
          				text: '평균단가',
           				columns: [ 
             				 {dataIndex: 'AVERAGE_P', width: 73, summaryType: 'sum'},
             				 {dataIndex: 'BASIS_P',   width: 73, summaryType: 'sum'}
                    	]
          			},{
						text: '부가정보',
           				columns:[ 
             				 {dataIndex: 'PERIODIC_YN_NAME', width: 100, summaryType: 'sum'},
             				 {dataIndex: 'INOUT_NUM',        width: 120, summaryType: 'sum'},
             				 {dataIndex: 'INOUT_SEQ',        width: 80,  summaryType: 'sum'}
                    
                   			]
          			},
					{dataIndex: 'PERIODIC_YN',		width: 66,  hidden: true},               
					{dataIndex: 'INOUT_PRSN',		width: 66,  hidden: true},               
					{dataIndex: 'INOUT_PRSN_NAME',	width: 80 , hidden: true},          
					{dataIndex: 'PROJECT_NO',		width: 100, hidden: true},               
					{dataIndex: 'LOT_NO',			width: 100, hidden: true},               
					{dataIndex: 'SORT_WH_CODE',		width: 66,  hidden: true},               
					{dataIndex: 'SORT_FLD',			width: 66,  hidden: true}               
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
      id  : 'biv420skrvApp',
      fnInitBinding : function() {
         panelSearch.setValue('DIV_CODE',UserInfo.divCode);
         UniAppManager.setToolbarButtons('detail',true);
         UniAppManager.setToolbarButtons('reset',false);
      },
      onQueryButtonDown : function()   {         
         
         masterGrid.getStore().loadStoreRecords();
         var viewLocked = masterGrid.lockedGrid.getView();
         var viewNormal = masterGrid.normalGrid.getView();
         console.log("viewLocked : ",viewLocked);
         console.log("viewNormal : ",viewNormal);
          viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
          viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
          viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
          viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
            
      },
      onDetailButtonDown:function() {
         var as = Ext.getCmp('AdvanceSerch');   
         if(as.isHidden())   {
            as.show();
         }else {
            as.hide()
         }
      }
   });

};


</script>