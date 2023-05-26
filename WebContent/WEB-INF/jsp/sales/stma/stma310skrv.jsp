<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="stma310skrv"  >	
	<t:ExtComboStore comboType="BOR120" pgmId="stma310skrv" /> 			<!-- 사업장 --> 
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	
	/**
	 * Model 정의 
	 * @type 
	 */   			 
	Unilite.defineModel('stma310skrvModel', {
	    fields: [
	    	{name:'CUSTOM_CODE'             , text: '<t:message code="system.label.sales.client" default="고객"/>'          , type: 'string'},
            {name:'CUSTOM_NAME'             , text: '<t:message code="system.label.sales.client" default="고객"/>'          , type: 'string'},
            {name:'SALE_Q1'                 , text: '<t:message code="system.label.sales.lastmonth" default="전월"/>'          , type: 'uniQty'},
            {name:'SALE_Q2'                 , text: '<t:message code="system.label.sales.basismonth" default="기준월"/>'        , type: 'uniQty'},
            {name:'SALE_Q3'                 , text: '<t:message code="system.label.sales.increasingrate" default="증가율"/>'        , type: 'uniER'},
            {name:'SALE_Q4'                 , text: '<t:message code="system.label.sales.lastmonth" default="전월"/>'           , type: 'uniQty'},
            {name:'SALE_Q5'                 , text: '<t:message code="system.label.sales.basismonth" default="기준월"/>'        , type: 'uniQty'},
            {name:'SALE_Q6'                 , text: '<t:message code="system.label.sales.increasingrate" default="증가율"/>'        , type: 'uniER'},
            {name:'SALE_Q7'                 , text: '<t:message code="system.label.sales.lastmonth" default="전월"/>'           , type: 'uniQty'},
            {name:'SALE_Q8'                 , text: '<t:message code="system.label.sales.basismonth" default="기준월"/>'        , type: 'uniQty'},
            {name:'SALE_Q9'                 , text: '<t:message code="system.label.sales.increasingrate" default="증가율"/>'        , type: 'uniER'}
	    ]	    
	});		//End of Unilite.defineModel
	
	// GroupField string type으로 변환
	function dateToString(v, record){
		return UniDate.safeFormat(v);
	  }
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */
	var MasterStore = Unilite.createStore('stma310skrvMasterStore',{
			model: 'stma310skrvModel',
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
               		read: 'stma310skrvService.selectList'
                }
            },
			loadStoreRecords: function() {
                var param= Ext.getCmp('searchForm').getValues(); 
                if(param.GUBUN == '1'){ //전월
                	param.INOUT_DATE_FR = UniDate.getDbDateStr(UniDate.add(panelSearch.getValue('INOUT_DATE'), {months:-1})).substring(0, 6);
                }else if(param.GUBUN == '2'){ //전년
                	param.INOUT_DATE_FR = UniDate.getDbDateStr(UniDate.add(panelSearch.getValue('INOUT_DATE'), {years:-1})).substring(0, 6);
                	
                }
                
                this.load({
                    params : param
                });
            }
	});		// End of var MasterStore 
	
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
            }), {
                fieldLabel: '<t:message code="system.label.sales.basismonth" default="기준월"/>',                  
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
                fieldLabel: '<t:message code="system.label.sales.applybasis" default="적용기준"/>',                                           
                //id: 'rdoSelect',
                items: [{
                    boxLabel: '<t:message code="system.label.sales.qty" default="수량"/>', 
                    width: 50, 
                    name: 'rdoSelect',
                    inputValue: '1',
                    checked: true 
                },{
                    boxLabel : '<t:message code="system.label.sales.exchangeamount" default="환산액"/>', 
                    width: 90,
                    name: 'rdoSelect',
                    inputValue: '2' 
                }],
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {            
                        panelResult.getField('rdoSelect').setValue(newValue.rdoSelect);
                    }
                }
            },{
                xtype: 'radiogroup',                            
                fieldLabel: '구분',                                           
                //id: 'rdoSelect',
                items: [{
                    boxLabel: '전월대비', 
                    width: 100, 
                    name: 'GUBUN',
                    inputValue: '1',
                    checked: true 
                },{
                    boxLabel : '전년대비', 
                    width: 100,
                    name: 'GUBUN',
                    inputValue: '2' 
                }],
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {            
                        panelResult.getField('GUBUN').setValue(newValue.GUBUN);
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
	
    var panelResult = Unilite.createSearchForm('resultForm', {
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
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
                colspan:2,
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
            }), {
                fieldLabel: '<t:message code="system.label.sales.basismonth" default="기준월"/>',                  
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
                fieldLabel: '<t:message code="system.label.sales.applybasis" default="적용기준"/>',                                           
                //id: 'rdoSelect',
                items: [{
                    boxLabel: '<t:message code="system.label.sales.qty" default="수량"/>', 
                    width: 50, 
                    name: 'rdoSelect',
                    inputValue: '1',
                    checked: true 
                },{
                    boxLabel : '<t:message code="system.label.sales.exchangeamount" default="환산액"/>', 
                    width: 90,
                    name: 'rdoSelect',
                    inputValue: '2' 
                }],
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {            
                        panelSearch.getField('rdoSelect').setValue(newValue.rdoSelect);
                    }
                }
            },{
                xtype: 'radiogroup',                            
                fieldLabel: '구분',                                           
                //id: 'rdoSelect',
                items: [{
                    boxLabel: '전월대비', 
                    width: 100, 
                    name: 'GUBUN',
                    inputValue: '1',
                    checked: true 
                },{
                    boxLabel : '전년대비', 
                    width: 100,
                    name: 'GUBUN',
                    inputValue: '2' 
                }],
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {            
                        panelSearch.getField('GUBUN').setValue(newValue.GUBUN);
                        
                        if(newValue.GUBUN == '1'){
                        	masterGrid.down('#saleQ1').setConfig('text','전월');
                        	masterGrid.down('#saleQ4').setConfig('text','전월');
                        	masterGrid.down('#saleQ7').setConfig('text','전월');
                        }else if(newValue.GUBUN == '2'){
                        	masterGrid.down('#saleQ1').setConfig('text','전년');
                        	masterGrid.down('#saleQ4').setConfig('text','전년');
                        	masterGrid.down('#saleQ7').setConfig('text','전년');
                        }
	    				
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
    var masterGrid = Unilite.createGrid('stma310skrvGrid', {
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
            	text: '<t:message code="system.label.sales.salesorder" default="수주"/>',
         		columns: [ 
            		{dataIndex: 'SALE_Q1'						, width: 96, summaryType: 'sum' ,itemId:'saleQ1'},
            		{dataIndex: 'SALE_Q2'					    , width: 96, summaryType: 'sum' },
            		{dataIndex: 'SALE_Q3'				        , width: 93}
            	]
           	},
			{
            	text: '<t:message code="system.label.sales.issue" default="출고"/>/<t:message code="system.label.sales.return" default="반품"/>',
         		columns: [ 
                    {dataIndex: 'SALE_Q4'                       , width: 96, summaryType: 'sum' ,itemId:'saleQ4'},
                    {dataIndex: 'SALE_Q5'                       , width: 96, summaryType: 'sum' },
                    {dataIndex: 'SALE_Q6'                       , width: 93}
                ]
           	},
			{
            	text: '<t:message code="system.label.sales.sales" default="매출"/>',
         		columns: [ 
                    {dataIndex: 'SALE_Q7'                       , width: 96, summaryType: 'sum' ,itemId:'saleQ7'},
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
		id: 'stma310skrvApp',
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
