<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="sma310skrv"  > 
    <t:ExtComboStore comboType="BOR120" pgmId="sma320skrv" />           <!-- 사업장 -->  
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	
	/**
	 * Model 정의 
	 * @type 
	 */   			 
	Unilite.defineModel('sma310skrvModel', {
	    fields: [
	    	{name:'CUSTOM_CODE'             , text: '<t:message code="system.label.sales.client" default="고객"/>'          , type: 'string'},
            {name:'CUSTOM_NAME'             , text: '<t:message code="system.label.sales.client" default="고객"/>'          , type: 'string'},
            {name:'SALE_Q1'                 , text: '전월'          , type: 'uniQty'},
            {name:'SALE_Q2'                 , text: '기준월'        , type: 'uniQty'},
            {name:'SALE_Q3'                 , text: '증가율'        , type: 'uniER'},
            {name:'SALE_Q4'                 , text: '전월'          , type: 'uniQty'},
            {name:'SALE_Q5'                 , text: '기준월'        , type: 'uniQty'},
            {name:'SALE_Q6'                 , text: '증가율'        , type: 'uniER'},
            {name:'SALE_Q7'                 , text: '전월'          , type: 'uniQty'},
            {name:'SALE_Q8'                 , text: '기준월'        , type: 'uniQty'},
            {name:'SALE_Q9'                 , text: '증가율'        , type: 'uniER'}
	    ]	    
	});		//End of Unilite.defineModel
	
	Unilite.defineModel('sma310skrvModel2', {
        fields: [
            {name:'CUSTOM_CODE'             , text: '<t:message code="system.label.sales.client" default="고객"/>'          , type: 'string'},
            {name:'CUSTOM_NAME'             , text: '<t:message code="system.label.sales.client" default="고객"/>'          , type: 'string'},
            {name:'SALE_Q1'                 , text: '전월'          , type: 'uniPrice'},
            {name:'SALE_Q2'                 , text: '기준월'        , type: 'uniPrice'},
            {name:'SALE_Q3'                 , text: '증가율'        , type: 'uniER'},
            {name:'SALE_Q4'                 , text: '전월'          , type: 'uniPrice'},
            {name:'SALE_Q5'                 , text: '기준월'        , type: 'uniPrice'},
            {name:'SALE_Q6'                 , text: '증가율'        , type: 'uniER'},
            {name:'SALE_Q7'                 , text: '전월'          , type: 'uniPrice'},
            {name:'SALE_Q8'                 , text: '기준월'        , type: 'uniPrice'},
            {name:'SALE_Q9'                 , text: '증가율'        , type: 'uniER'}
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
	var MasterStore = Unilite.createStore('sma310skrvMasterStore',{
			model: 'sma310skrvModel',
			uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: false,		// 수정 모드 사용 
            	deletable: false,		// 삭제 가능 여부 
	            useNavi: false			// prev | next 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {
               		read: 'sma310skrvService.selectList'
                }
            },
			loadStoreRecords: function() {
                var param= Ext.getCmp('searchForm').getValues(); 
                param.INOUT_DATE_FR = UniDate.getDbDateStr(UniDate.add(panelSearch.getValue('INOUT_DATE'), {months:-1})).substring(0, 6);
                console.log( param );
                this.load({
                    params : param
                });
            }
	});		// End of var MasterStore 
	
	var MasterStore2 = Unilite.createStore('sma310skrvMasterStore2',{
            model: 'sma310skrvModel2',
            uniOpt : {
                isMaster: true,         // 상위 버튼 연결 
                editable: false,        // 수정 모드 사용 
                deletable: false,       // 삭제 가능 여부 
                useNavi: false          // prev | next 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {
                    read: 'sma310skrvService.selectList'
                }
            },
            loadStoreRecords: function() {
                var param= Ext.getCmp('searchForm').getValues();  
                param.INOUT_DATE_FR = UniDate.getDbDateStr(UniDate.add(panelSearch.getValue('INOUT_DATE'), {months:-1})).substring(0, 6);
                console.log( param );
                this.load({
                    params : param
                });
            }
    });     // End of var MasterStore 
	
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
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{
                fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>', 
                name:'DIV_CODE', 
                xtype: 'uniCombobox', 
                comboType:'BOR120', 
                allowBlank:false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelResult.setValue('DIV_CODE', newValue);
                    }
                }
            },
            Unilite.popup('AGENT_CUST',{ 
                fieldLabel: '<t:message code="system.label.sales.custom" default="거래처"/>', 
                listeners: {
                    onSelected: {
                        fn: function(records, type) {
                            panelResult.setValue('CUSTOM_CODE', panelSearch.getValue('CUSTOM_CODE'));
                            panelResult.setValue('CUSTOM_NAME', panelSearch.getValue('CUSTOM_NAME'));                                                                                                           
                        },
                        scope: this
                    },
                    onClear: function(type) {
                        panelResult.setValue('CUSTOM_CODE', '');
                        panelResult.setValue('CUSTOM_NAME', '');
                    }
                }
            }), {
                fieldLabel: '기준월',                  
                xtype: 'uniMonthfield',
                name: 'INOUT_DATE',                    
                value: new Date(),                    
                allowBlank:false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelResult.setValue('INOUT_DATE', newValue);
                    }
                }
            },{
                xtype: 'radiogroup',                            
                fieldLabel: '적용기준',                                           
                //id: 'rdoSelect',
                items: [{
                    boxLabel: '<t:message code="system.label.sales.qty" default="수량"/>', 
                    width: 50, 
                    name: 'rdoSelect',
                    inputValue: '1',
                    checked: true 
                },{
                    boxLabel : '환산금액', 
                    width: 90,
                    name: 'rdoSelect',
                    inputValue: '2' 
                }],
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {            
                        panelResult.getField('rdoSelect').setValue(newValue.rdoSelect);
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
					} else {
						  var fields = this.getForm().getFields();
						Ext.each(fields.items, function(item) {
							if(Ext.isDefined(item.holdable) )	{
							 	if (item.holdable == 'hold') {
									item.setReadOnly(true); 
								}
							} 
							if(item.isPopupField)	{
								var popupFC = item.up('uniPopupField')	;							
								if(popupFC.holdable == 'hold') {
									popupFC.setReadOnly(true);
								}
							}
						})  
	   				}
		  		} else {
		  			var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) )	{
						 	if (item.holdable == 'hold') {
								item.setReadOnly(false);
							}
						} 
						if(item.isPopupField)	{
							var popupFC = item.up('uniPopupField')	;	
							if(popupFC.holdable == 'hold' ) {
								item.setReadOnly(false);
							}
						}
					})
  				}
				return r;
  			}
	});
	
    var panelResult = Unilite.createSearchForm('panelResultForm', {
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 2},
		padding:'1 1 1 1',
		border:true,
	    	items: [{
                fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>', 
                name:'DIV_CODE', 
                xtype: 'uniCombobox', 
                comboType:'BOR120', 
                allowBlank:false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.setValue('DIV_CODE', newValue);
                    }
                }
            },
            Unilite.popup('AGENT_CUST',{ 
                fieldLabel: '<t:message code="system.label.sales.custom" default="거래처"/>', 
                listeners: {
                    onSelected: {
                        fn: function(records, type) {
                            panelSearch.setValue('CUSTOM_CODE', panelResult.getValue('CUSTOM_CODE'));
                            panelSearch.setValue('CUSTOM_NAME', panelResult.getValue('CUSTOM_NAME'));                                                                                                           
                        },
                        scope: this
                    },
                    onClear: function(type) {
                        panelSearch.setValue('CUSTOM_CODE', '');
                        panelSearch.setValue('CUSTOM_NAME', '');
                    }
                }
            }), {
                fieldLabel: '기준월',                  
                xtype: 'uniMonthfield',
                name: 'INOUT_DATE',                    
                value: new Date(),                    
                allowBlank:false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.setValue('INOUT_DATE', newValue);
                    }
                }
            },{
                xtype: 'radiogroup',                            
                fieldLabel: '적용기준',                                           
                //id: 'rdoSelect',
                items: [{
                    boxLabel: '<t:message code="system.label.sales.qty" default="수량"/>', 
                    width: 50, 
                    name: 'rdoSelect',
                    inputValue: '1',
                    checked: true 
                },{
                    boxLabel : '환산금액', 
                    width: 90,
                    name: 'rdoSelect',
                    inputValue: '2' 
                }],
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {            
                        panelSearch.getField('rdoSelect').setValue(newValue.rdoSelect);
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
					} else {
						  var fields = this.getForm().getFields();
						Ext.each(fields.items, function(item) {
							if(Ext.isDefined(item.holdable) )	{
							 	if (item.holdable == 'hold') {
									item.setReadOnly(true); 
								}
							} 
							if(item.isPopupField)	{
								var popupFC = item.up('uniPopupField')	;							
								if(popupFC.holdable == 'hold') {
									popupFC.setReadOnly(true);
								}
							}
						})  
	   				}
		  		} else {
		  			var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) )	{
						 	if (item.holdable == 'hold') {
								item.setReadOnly(false);
							}
						} 
						if(item.isPopupField)	{
							var popupFC = item.up('uniPopupField')	;	
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
     * Master Grid 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('sma310skrvGrid', {
    	region: 'center' ,
        layout : 'fit',
        store : MasterStore,
        uniOpt:{
        	expandLastColumn: true,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
    		useGroupSummary: false,
			useRowNumberer: false,
			filter: {
				useFilter: true,
				autoCreate: true
			}
        },
    	features: [
    		{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true},
    	    {id : 'masterGridTotal' ,   ftype: 'uniSummary', 	     showSummaryRow: true}
    	],
        columns:  [
			{dataIndex:'CUSTOM_CODE' 	  						, width: 100, hidden:true},
			{dataIndex:'CUSTOM_NAME' 		  					, width: 150
			,summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			        return Unilite.renderSummaryRow(summaryData, metaData, '', '<t:message code="system.label.sales.total" default="총계"/>');
            }},
			{
            	text: '수주',
         		columns: [ 
            		{dataIndex: 'SALE_Q1'						, width: 96, summaryType: 'sum' },
            		{dataIndex: 'SALE_Q2'					    , width: 96, summaryType: 'sum' },
            		{dataIndex: 'SALE_Q3'				        , width: 93}
            	]
           	},
			{
            	text: '출고/반품',
         		columns: [ 
                    {dataIndex: 'SALE_Q4'                       , width: 96, summaryType: 'sum' },
                    {dataIndex: 'SALE_Q5'                       , width: 96, summaryType: 'sum' },
                    {dataIndex: 'SALE_Q6'                       , width: 93}
                ]
           	},
			{
            	text: '매출',
         		columns: [ 
                    {dataIndex: 'SALE_Q7'                       , width: 96, summaryType: 'sum' },
                    {dataIndex: 'SALE_Q8'                       , width: 96, summaryType: 'sum' },
                    {dataIndex: 'SALE_Q9'                       , width: 93}
                ]
           	}
		]
    });		//End of var masterGrid 
    
    /**
	 * Main 정의(Main 정의)
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
		id: 'sma310skrvApp',
		fnInitBinding: function() {
            panelSearch.setValue('DIV_CODE',UserInfo.divCode);
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('reset',false);
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
		}
	});
};
</script>
