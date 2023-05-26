<%@page language="java" contentType="text/html; charset=utf-8"%>
     {
        title:'구매단가등록',
        xtype: 'uniDetailFormSimple',
        id      : 'tab_unitPrice',
        itemId  : 'tab_unitPrice',
        layout: {type: 'vbox', align:'stretch'},
        padding: '0 0 0 0',
        items:[{
                xtype: 'container',
                layout: {type: 'uniTable', columns: 2},        
                items : [{ 
                        fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
                        name: 'DIV_CODE',
                        xtype: 'uniCombobox',
                        comboType: 'BOR120',
                        value: UserInfo.divCode,
                        allowBlank: false
                    },{
                        fieldLabel: '<t:message code="system.label.purchase.majorgroup" default="대분류"/>',
                        name: 'ITEM_LEVEL1', 
                        xtype: 'uniCombobox',  
                        store: Ext.data.StoreManager.lookup('itemLeve1Store'), 
                        child: 'ITEM_LEVEL2'
                    }, {
                        fieldLabel: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>',
                        name:'ITEM_ACCOUNT', 
                        xtype: 'uniCombobox', 
                        comboType:'AU',
                        comboCode:'B020'
                    }, {
                        fieldLabel: '<t:message code="system.label.purchase.middlegroup" default="중분류"/>',
                        name: 'ITEM_LEVEL2', 
                        xtype: 'uniCombobox',  
                        store: Ext.data.StoreManager.lookup('itemLeve2Store'), 
                        child: 'ITEM_LEVEL3'
                    }, 
                    Unilite.popup('DIV_PUMOK',{
                        fieldLabel: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
                        valueFieldName: 'ITEM_CODE', 
                        textFieldName: 'ITEM_NAME'
                        
                    }), {
                        fieldLabel: '<t:message code="system.label.purchase.minorgroup" default="소분류"/>',
                        name: 'ITEM_LEVEL3', 
                        xtype: 'uniCombobox',  
                        store: Ext.data.StoreManager.lookup('itemLeve3Store'), 
                        colspan: 2
                    },{
                        fieldLabel: '품목HIDDEN',
                        xtype: 'uniTextfield',
                        name: 'ITEM_CODE_TEMP',
                        hidden: true
                    },{
                        fieldLabel: '재고단위HIDDEN',
                        xtype: 'uniTextfield',
                        name: 'STOCK_UNIT_TEMP',
                        hidden: true
                    }
                ]
            }, {
                xtype: 'uniGridPanel',
                id      : 'mba030ukrsGrid2',
                itemId  : 'mba030ukrsGrid2',
                store : mba030ukrvs2Store,
                padding: '0 0 0 0',
                dockedItems: [{
                    xtype: 'toolbar',
                    dock: 'top',
                    padding:'0px',
                    border:0
                }],
                uniOpt: {
                    expandLastColumn: true,
                    useRowNumberer: false,
                    onLoadSelectFirst: true,
                    useMultipleSorting: false
                },              
                columns: [
                    {dataIndex: 'ITEM_CODE'           ,   width: 93},
                    {dataIndex: 'ITEM_NAME'           ,   width: 133},
                    {dataIndex: 'SPEC'                ,   width: 133},
                    {dataIndex: 'STOCK_UNIT'          ,   width: 66},
                    {dataIndex: 'SALE_UNIT'           ,   width: 66},
                    {dataIndex: 'BASIS_P'             ,   width: 86},
                    {dataIndex: 'DOM_FORIGN'          ,   width: 86},
                    {dataIndex: 'ITEM_ACCOUNT'        ,   width: 66},
                    {dataIndex: 'TRNS_RATE'           ,   width: 53}
                ],
                listeners: {
                    beforeedit  : function( editor, e, eOpts ) {
                        return false;
                    },
                    selectionchange:function(selected, eOpts ) {
                        var record = Ext.getCmp('tab_unitPrice').down('#mba030ukrsGrid2').getSelectedRecord();
                        this.returnCell(record);              
                    }
                },
                returnCell: function(record){
                    var param =  panelDetail.down('#tab_unitPrice').getValues();
                    var itemCode = record.get("ITEM_CODE");
                    var stockUnit = record.get("STOCK_UNIT");
                    panelDetail.down('#tab_unitPrice').setValues({'ITEM_CODE_TEMP':itemCode, 'STOCK_UNIT_TEMP':stockUnit});
//                    sbs030ukrvs0_2Store.loadStoreRecords(param);
                }
            },{
                xtype: 'container',
                layout: {type: 'uniTable'},        
                items : [
                    {
                        fieldLabel: '단가검색',
                        xtype: 'uniRadiogroup',
                        name:'RDO_TYPE',
                        id: 'sItemFlag',
                        items: [
                            {boxLabel:'현재 적용단가', name:'ITEM_FLAG', inputValue:'C', checked:true, width: 100},
                            {boxLabel:'<t:message code="system.label.purchase.whole" default="전체"/>', name:'ITEM_FLAG', inputValue:'A', width: 100}
                        ],
                        listeners: {
                            change: function(field, newValue, oldValue, eOpts) {                       
                                var param =  panelDetail.down('#tab_unitPrice').getValues();
//                                sbs030ukrvs0_2Store.loadStoreRecords(param);  
                            }
                        }
                    }
                ]
            }, {
                region: 'south',
                xtype: 'uniGridPanel',
                id      : 'mba030ukrsGrid2_1',
                itemId  : 'mba030ukrsGrid2_1',
                store : mba030ukrvs2Store1, 
                padding: '0 0 0 0',
                uniOpt: {
                    expandLastColumn: true,
                    useRowNumberer: false,
                    useMultipleSorting: false
                },              
                columns: [
                    {dataIndex: 'TYPE'                ,   width: 33, hidden: true},
                    {dataIndex: 'ITEM_CODE'           ,   width: 133, hidden: true},
                    {dataIndex: 'CUSTOM_CODE'         ,   width: 106,
                        editor: Unilite.popup('CUST_G', {      
                                textFieldName: 'CUSTOM_CODE',
                                DBtextFieldName: 'CUSTOM_CODE',
		                    	autoPopup: true,
                                listeners: {'onSelected': {
                                            fn: function(records, type) {
                                                    console.log('records : ', records);
                                                    Ext.each(records, function(record,i) {                                                                     
                                                        if(i==0) {
                                                            Ext.getCmp('tab_unitPrice').down('#mba030ukrsGrid2_1').setCustomData(record,false, Ext.getCmp('tab_unitPrice').down('#mba030ukrsGrid2_1').uniOpt.currentRecord);
                                                        } else {
                                                            UniAppManager.app.onNewDataButtonDown();
                                                            Ext.getCmp('tab_unitPrice').down('#mba030ukrsGrid2_1').setCustomData(record,false, Ext.getCmp('tab_unitPrice').down('#mba030ukrsGrid2_1').getSelectedRecord());
                                                        }
                                                    }); 
                                            },
                                            scope: this
                                    },
                                    'onClear': function(type) {
                                        Ext.getCmp('tab_unitPrice').down('#mba030ukrsGrid2_1').setCustomData(null,true, Ext.getCmp('tab_unitPrice').down('#mba030ukrsGrid2_1').uniOpt.currentRecord);
                                    }
                                }
                        })
                    },
                    {dataIndex: 'CUSTOM_NAME'         ,   width: 166,
                        editor: Unilite.popup('CUST_G', {      
                                textFieldName: 'CUSTOM_CODE',
                                DBtextFieldName: 'CUSTOM_CODE',
		                    	autoPopup: true,
                                listeners: {'onSelected': {
                                            fn: function(records, type) {
                                                    console.log('records : ', records);
                                                    Ext.each(records, function(record,i) {                                                                     
                                                        if(i==0) {
                                                            Ext.getCmp('tab_unitPrice').down('#mba030ukrsGrid2_1').setCustomData(record,false, Ext.getCmp('tab_unitPrice').down('#mba030ukrsGrid2_1').uniOpt.currentRecord);
                                                        } else {
                                                            UniAppManager.app.onNewDataButtonDown();
                                                            Ext.getCmp('tab_unitPrice').down('#mba030ukrsGrid2_1').setCustomData(record,false, Ext.getCmp('tab_unitPrice').down('#mba030ukrsGrid2_1').getSelectedRecord());
                                                        }
                                                    }); 
                                            },
                                            scope: this
                                    },
                                    'onClear': function(type) {
                                        Ext.getCmp('tab_unitPrice').down('#mba030ukrsGrid2_1').setCustomData(null,true, Ext.getCmp('tab_unitPrice').down('#mba030ukrsGrid2_1').uniOpt.currentRecord);
                                    }
                                }
                        })
                    },
                    {dataIndex: 'MONEY_UNIT'          ,   width: 80},
                    {dataIndex: 'ORDER_UNIT'          ,   width: 80},
                    {dataIndex: 'ITEM_P'              ,   width: 126},
                    {dataIndex: 'APLY_START_DATE'     ,   width: 113},
                    {dataIndex: 'DIV_CODE'            ,   width: 113, hidden: true},
                    {dataIndex: 'UPDATE_DB_USER'      ,   width: 113, hidden: true},
                    {dataIndex: 'UPDATE_DB_TIME'      ,   width: 113, hidden: true},
                    {dataIndex: 'REMARK'              ,   width: 113},
                    {dataIndex: 'COMP_CODE'           ,   width: 113, hidden: true}                           
                ],
                listeners: {
                    beforeedit  : function( editor, e, eOpts ) {
                        if(!e.record.phantom) {
                            if(UniUtils.indexOf(e.field, ['ITEM_P', 'REMARK'])) { 
                                return true;
                            } else {
                                return false;
                            }
                        } else {
                            return true; 
                        }
                    }
                },
                setCustomData: function(record, dataClear, grdRecord) {
                    if(dataClear) {
                        grdRecord.set('CUSTOM_CODE'           , '');
                        grdRecord.set('CUSTOM_NAME'           , '');

                    } else {
                        grdRecord.set('CUSTOM_CODE'           , record['CUSTOM_CODE']);
                        grdRecord.set('CUSTOM_NAME'           , record['CUSTOM_NAME']);
                    }
                }
            }
        ],
         setAllFieldsReadOnly1 : function(b) {
                var r= true
                if(b) {
                    var invalid = this.getForm().getFields().filterBy(function(field) {
                                                                        return !field.validate();
                                                                    });
    
                    if(invalid.length > 0) {
                        r=false;
                        var labelText = ''
        
                        if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
                            var labelText = invalid.items[0]['fieldLabel']+':';
                        } else if(Ext.isDefined(invalid.items[0].ownerCt)) {
                            var labelText = invalid.items[0].ownerCt['fieldLabel']+':';
                        }
    
                        alert(labelText+Msg.sMB083);
                        invalid.items[0].focus();
                    } else {
                    //  this.mask();            
                    }
                } else {
                    this.unmask();
                }
                return r;
            }
    }