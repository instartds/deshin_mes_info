<%@page language="java" contentType="text/html; charset=utf-8"%>
     {
        title:'<t:message code="system.label.trade.expensedetailsentry" default="경비내역등록"/>',
        xtype: 'uniDetailFormSimple',
        itemId: 'tbs030ukrvs1Tab',
        id: 'tbs030ukrvs1Tab',
        layout: {type: 'vbox', align:'stretch'},
        padding: '0 0 0 0',
        items:[{
                xtype: 'container',   
                layout: {type: 'uniTable', columns: 2},        
                items : [{
                        fieldLabel: '<t:message code="system.label.trade.tradeclass" default="무역구분"/>',
                        name:'TRADE_DIV', 
                        xtype: 'uniCombobox', 
                        holdable: 'hold',
                        allowBlank: false,
                        comboType:'AU',
                        comboCode:'T001',
                        listeners: {
				    	change: function(field, newValue, oldValue, eOpts) { 
				    		if(panelDetail.down('#tbs030ukrvs1Tab').getValue('TRADE_DIV') == 'E') {
				    			UniAppManager.app.setHiddenFormColumn();
				    			UniAppManager.app.setHiddenGridColumn();
				    		} else {
				    			UniAppManager.app.setHiddenFormColumn();
				    			UniAppManager.app.setHiddenGridColumn();
				    		}
				     	}
				    }
                    }, {
                        fieldLabel: '진행구분',
                        name:'CHARGE_TYPE1', 
                        xtype: 'uniCombobox', 
                        comboType:'AU',
                        comboCode:'T070'
                    }, {
                        fieldLabel: '진행구분',
                        name:'CHARGE_TYPE2', 
                        xtype: 'uniCombobox', 
                        comboType:'AU',
                        comboCode:'T071'
                    }
                ]
            }, {
                xtype: 'uniGridPanel',     
                region: 'west',
                itemId:'tbs030ukrvs1Grid',
                id:'tbs030ukrvs1Grid',
                store : tbs030ukrvs1Store,
                padding: '0 0 0 0',
                dockedItems: [{
                    xtype: 'toolbar',
                    dock: 'top',
                    padding:'0px',
                    border:0
                }],
                uniOpt: {
                    expandLastColumn: false,
                    useRowNumberer: true,
                    onLoadSelectFirst: true,
                    useMultipleSorting: false
                },              
                columns: [
                	{dataIndex: 'TRADE_DIV'     	,       width: 70},                   
                    {dataIndex: 'CHARGE_TYPE1'      ,       width: 140, hidden: true},                 
                    {dataIndex: 'CHARGE_TYPE2'      ,       width: 140},                       
                    {dataIndex: 'CHARGE_CODE'     	,       width: 133},                    
                    {dataIndex: 'CHARGE_NAME'      	,       width: 133},                     
                    {dataIndex: 'COST_DIV'        	,       width: 113},                    
                    {dataIndex: 'TAX_DIV'        	,       width: 113}
                ],
                listeners: {
                   beforeedit: function( editor, e, eOpts ) {
                   	if(e.field=='TRADE_DIV') {
								return false;
							} else {
								return true;
							}
                   	
//						if(e.record.phantom == true) {
//	        		 		if(UniUtils.indexOf(e.field))
//					   		{
//								return false;
//	      					}
//	        			} else {
//							if(e.field=='INOUT_PRSN') {
//								return true;
//							} else {
//								return false;
//							}
//						}
					}
                } 
            }] 
    } 