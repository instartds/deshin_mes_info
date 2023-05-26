<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="sma320skrv"  > 
	<t:ExtComboStore comboType="BOR120" pgmId="sma320skrv" /> 			<!-- 사업장 -->  
</t:appConfig>
<script type="text/javascript" >

function appMain() {    
	var Count = 0;
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Sma320skrvModel1', {
	    fields: [  	 
	    	{name: 'GUBUN'			,text: '진행구분'	,type: 'string'},
	        {name: 'CUSTOM_NAME'	,text: '<t:message code="system.label.sales.custom" default="거래처"/>'	    ,type: 'string'},
		    {name: 'AMOUNT'			,text: '<t:message code="system.label.sales.exchangeamount" default="환산액"/>'	    ,type: 'uniPrice'},
		    {name: 'CUSTOM_CODE'	,text: '<t:message code="system.label.sales.custom" default="거래처"/>'	,type: 'string'},
		    {name: 'DIV_CODE'		,text: '<t:message code="system.label.sales.division" default="사업장"/>'	    ,type: 'string'},
		    {name: 'SOPT'			,text: 'SOPT'	    ,type: 'string'}
		]
	});	
	
	Unilite.defineModel('Sma320skrvModel2', {
	    fields: [  	  
	    	{name: 'ITEM_CODE'		,text: '<t:message code="system.label.sales.item" default="품목"/>'	,type: 'string'},
		    {name: 'ITEM_NAME'		,text: '<t:message code="system.label.sales.itemname" default="품목명"/>'		,type: 'string'},
		    {name: 'SPEC'			,text: '<t:message code="system.label.sales.spec" default="규격"/>'		,type: 'string'},
		    {name: 'ORDER_UNIT'		,text: '<t:message code="system.label.sales.unit" default="단위"/>'		,type: 'string', displayField: 'value'},
		    {name: 'MONEY_UNIT'		,text: '<t:message code="system.label.sales.currency" default="화폐"/>'		,type: 'string'},
		    {name: 'ORDER_O'		,text: '<t:message code="system.label.sales.amount" default="금액"/>'		,type: 'uniPrice'},
		    {name: 'EXCHG_RATE_O'	,text: '<t:message code="system.label.sales.exchangerate" default="환율"/>'		,type: 'uniER'},
			{name: 'ORDER_NUM'		,text: '근거번호'	,type: 'string'},
			{name: 'SER_NO'		    ,text: '<t:message code="system.label.sales.seq" default="순번"/>'		,type: 'string'}
		]       
	});             
	               
	  
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('sma320skrvMasterStore1',{
		model: 'Sma320skrvModel1',
		uniOpt: {
            isMaster: true,		// 상위 버튼 연결 
            editable: false,		// 수정 모드 사용 
            deletable: false,		// 삭제 가능 여부 
	        useNavi : false			// prev | next 버튼 사용
        },
        autoLoad: false,
        proxy: {
        	type: 'direct',
        	api: {			
            	read: 'sma320skrvService.selectList1'                	
            }
        }
		,loadStoreRecords: function()	{
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		},
        listeners:{
            load: function(store, records, successful, eOpts) {
                panelSearch.setValue('COUNT', masterGrid1.getStore().getCount());
            }
        }
	});
	
	var directMasterStore2 = Unilite.createStore('sma320skrvMasterStore2',{
		model: 'Sma320skrvModel2',
		uniOpt : {
            isMaster: false,			// 상위 버튼 연결 
            editable: false,			// 수정 모드 사용 
            deletable:false,			// 삭제 가능 여부 
	        useNavi : false			// prev | next 버튼 사용
        },
        autoLoad: false,
        proxy: {
			type: 'direct',
			api: {			
				read: 'sma320skrvService.selectList1'                	
            }
        }
		,loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();			
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
			}, {
				fieldLabel: '<t:message code="system.label.sales.basisdate" default="기준일"/>',					
				xtype: 'uniDatefield',
				name: 'INOUT_DATE',                    
				value: new Date(),                    
				allowBlank:false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('INOUT_DATE', newValue);
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
					onClear: function(type)	{
						panelResult.setValue('CUSTOM_CODE', '');
						panelResult.setValue('CUSTOM_NAME', '');
					}
				}
			}),{
			    fieldLabel: 'COUNT',                 
                xtype: 'uniNumberfield',
                name: 'COUNT',
                hidden: true
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
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
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
		}, {
			fieldLabel: '<t:message code="system.label.sales.basisdate" default="기준일"/>',			
			xtype: 'uniDatefield',
			name: 'INOUT_DATE',                    
			value: new Date(),                    
			allowBlank:false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('INOUT_DATE', newValue);
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
				onClear: function(type)	{
					panelSearch.setValue('CUSTOM_CODE', '');
					panelSearch.setValue('CUSTOM_NAME', '');
				}
			}
		})]	
    });
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid1 = Unilite.createGrid('sma320skrvGrid1', {
    	region: 'center',
        layout: 'fit',
  		store: directMasterStore1,
  		uniOpt:{    expandLastColumn: false,
                    useRowNumberer: false,
                    useMultipleSorting: false,
                    onLoadSelectFirst   : true     //체크박스모델은 false로 변경
        },
    	features: [{
    		id: 'masterGridSubTotal', 
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
	    	}, {
	    	id: 'masterGridTotal', 	
	    	ftype: 'uniSummary', 	  
	    	showSummaryRow: false
    	}],
        selModel : 'rowmodel',
        columns: [        
        	{dataIndex: 'GUBUN'			, width: 73}, 				
			{dataIndex: 'CUSTOM_NAME'	, width: 133}, 				
			{dataIndex: 'AMOUNT'		, width: 86}, 				
			{dataIndex: 'CUSTOM_CODE'	, width: 80, hidden: true}, 				
			{dataIndex: 'DIV_CODE'		, width: 80, hidden: true}, 				
			{dataIndex: 'SOPT'			, width: 80, hidden: true} 				
		],
        listeners : {
            selectionchange : function(grid, selected, eOpts) {
                this.setDetailGrd(selected, eOpts) ;                       
            }
        },
        setDetailGrd : function (selected, eOpts) {
            if(selected.length > 0) {
                var param= Ext.getCmp('searchForm').getValues();
                param.GUBUN = selected[selected.length-1].get('GUBUN'),
                param.CUSTOM_CODE = selected[selected.length-1].get('CUSTOM_CODE')
                var dgrid = Ext.getCmp('sma320skrvGrid2'); 
                dgrid.getStore().loadStoreRecords(param);
            }
        } 
    });
    
    var masterGrid2 = Unilite.createGrid('sma320skrvGrid2', {
    	region: 'east',
    	layout: 'fit',
    	store: directMasterStore2,
    	features: [{
    		id: 'masterGridSubTotal', 
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
	    	}, {
	    	id: 'masterGridTotal', 	
	    	ftype: 'uniSummary', 	  
	    	showSummaryRow: false
	    }],
        columns: [        
            {dataIndex: 'ITEM_CODE'		,width: 93}, 
	    	{dataIndex: 'ITEM_NAME'		,width: 120},
	    	{dataIndex: 'SPEC'			,width: 120}, 
	    	{dataIndex: 'ORDER_UNIT'	,width: 53}, 
	    	{dataIndex: 'MONEY_UNIT'	,width: 33,  hidden: true}, 
	    	{dataIndex: 'ORDER_O'		,width: 100}, 
	        {dataIndex: 'EXCHG_RATE_O'	,width: 40,  hidden: true},
			{dataIndex: 'ORDER_NUM'		,width: 106},	    
			{dataIndex: 'SER_NO'		,width: 40}	   
        ] 
    });
    
    /**
     * Master Grid2 정의(Grid Panel)
     * @type 
     */

    Unilite.Main( {
		items : [ panelResult, {
            xtype : 'container',
            flex : 1,
            layout : 'border',
            defaults : {
                collapsible : false,
                split : true
            },
            items : [ {
                region : 'center',
                xtype : 'container',
                layout : 'fit',
                items : [ masterGrid1 ]
            }, {
                region : 'east',
                xtype : 'container',
                layout : 'fit',
                flex : 3,
                items : [ masterGrid2 ]
            }, panelSearch ]

        }],
		id: 'sma320skrvApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown : function() {	
			if(!panelSearch.setAllFieldsReadOnly(true)){
	    		return false;
	    	}         
            directMasterStore1.loadStoreRecords();
		}
	});
};


</script>
