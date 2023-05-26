<%@page language="java" contentType="text/html; charset=utf-8"%>
     {
        title:'<t:message code="system.label.sales.sellingtype" default="판매유형"/>',
        
        xtype: 'uniDetailForm',
        api: { load: 'aba050ukrService.select' },
        layout: 'border',
        items:[{
            region: 'west',
            xtype: 'uniSearchPanel',          
            title: '<t:message code="system.label.sales.searchconditon" default="검색조건"/>',         
            defaultType: 'uniSearchSubPanel',
            items: [{     
                title: '<t:message code="system.label.sales.basisinfo" default="기본정보"/>',   
                itemId: 'search_panel1',
                layout: {type: 'uniTable', columns: 1},
                defaultType: 'uniTextfield',
                items : [{                  
                    fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
                    name:'DIV_CODE',
                    xtype: 'uniCombobox',
                    comboType:'BOR120',
                    allowBlank:false
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
                    fieldLabel: '<t:message code="system.label.sales.itemaccount" default="품목계정"/>',
                    name:'', 
                    xtype: 'uniCombobox', 
                    comboType:'AU',
                    comboCode:'B020'
                }, 
                    Unilite.popup('ITEM',{
                    fieldLabel: '<t:message code="system.label.sales.item" default="품목"/>', 
                    textFieldWidth: 170, 
                    validateBlank: false
                })]
            }]      
        }, {
            region: 'center',
            xtype: 'uniGridPanel',
            
            store : sbs030ukrvs1Store,
            uniOpt: {
                expandLastColumn: true,
                useRowNumberer: true,
                useMultipleSorting: false
            },              
            columns: [{dataIndex: 'ITEM_CODE'           ,       width: 93},
                      {dataIndex: 'ITEM_NAME'           ,       width: 133},
                      {dataIndex: 'SPEC'                ,       width: 133},
                      {dataIndex: 'STOCK_UNIT'          ,       width: 66},
                      {dataIndex: 'SALE_UNIT'           ,       width: 66},
                      {dataIndex: 'BASIS_P'             ,       width: 86},
                      {dataIndex: 'DOM_FORIGN'          ,       width: 86},
                      {dataIndex: 'ITEM_ACCOUNT'        ,       width: 66},
                      {dataIndex: 'TRNS_RATE'           ,       width: 53}                        
            ]
        }]
    }