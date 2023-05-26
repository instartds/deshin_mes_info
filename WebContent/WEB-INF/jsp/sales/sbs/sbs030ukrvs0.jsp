<%@page language="java" contentType="text/html; charset=utf-8"%>
     {
        title:'판매단가등록',
        xtype: 'uniDetailFormSimple',
        itemId: 'tab_sbs030ukrv0Tab',
        id: 'tab_sbs030ukrv0Tab',
        layout: {type: 'vbox', align:'stretch'},
        padding: '0 0 0 0',
        items:[{
                xtype: 'container',
                layout: {type: 'uniTable', columns: 2},        
                items : [{ 
                        fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
                        name: 'DIV_CODE',
                        xtype: 'uniCombobox',
                        comboType: 'BOR120',
                        value: UserInfo.divCode,
                        allowBlank: false
                    },{
                        fieldLabel: '<t:message code="system.label.sales.majorgroup" default="대분류"/>',
                        name: 'ITEM_LEVEL1', 
                        xtype: 'uniCombobox',  
                        store: Ext.data.StoreManager.lookup('itemLeve1Store'), 
                        child: 'ITEM_LEVEL2'
                    }, {
                        fieldLabel: '<t:message code="system.label.sales.itemaccount" default="품목계정"/>',
                        name:'ITEM_ACCOUNT', 
                        xtype: 'uniCombobox', 
                        comboType:'AU',
                        comboCode:'B020'
                    }, {
                        fieldLabel: '<t:message code="system.label.sales.middlegroup" default="중분류"/>',
                        name: 'ITEM_LEVEL2', 
                        xtype: 'uniCombobox',  
                        store: Ext.data.StoreManager.lookup('itemLeve2Store'), 
                        child: 'ITEM_LEVEL3'
                    }, 
                    Unilite.popup('ITEM',{
                        fieldLabel: '<t:message code="system.label.sales.item" default="품목"/>',
                        valueFieldName: 'ITEM_CODE', 
                        textFieldName: 'ITEM_NAME',
                        validateBlank: false,
                        listeners: {
                            onValueFieldChange: function(field, newValue, oldValue){
                                if(!Ext.isObject(oldValue)) {
                                    panelDetail.down('#tab_sbs030ukrv0Tab').setValue('ITEM_NAME','');
                                }
                            },
                            onTextFieldChange: function(field, newValue, oldValue){
                                if(!Ext.isObject(oldValue)) {
                                    panelDetail.down('#tab_sbs030ukrv0Tab').setValue('ITEM_CODE','');
                                }
                            }
                        }
                    }), {
                        fieldLabel: '<t:message code="system.label.sales.minorgroup" default="소분류"/>',
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
                itemId:'sbs030ukrv0_Grid',
                //id:'sbs030ukrv0_Grid',
                store : sbs030ukrvs0_1Store,
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
                    	var record = Ext.getCmp('tab_sbs030ukrv0Tab').down('#sbs030ukrv0_Grid').getSelectedRecord();
                        this.returnCell(record);              
                    }
                },
                returnCell: function(record){
                	var param =  panelDetail.down('#tab_sbs030ukrv0Tab').getValues();
                    var itemCode = record.get("ITEM_CODE");
                    var stockUnit = record.get("STOCK_UNIT");
                    panelDetail.down('#tab_sbs030ukrv0Tab').setValues({'ITEM_CODE_TEMP':itemCode, 'STOCK_UNIT_TEMP':stockUnit});
                    sbs030ukrvs0_2Store.loadStoreRecords(param);
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
                            {boxLabel:'<t:message code="system.label.sales.whole" default="전체"/>', name:'ITEM_FLAG', inputValue:'A', width: 100}
                        ],
                        listeners: {
                            change: function(field, newValue, oldValue, eOpts) {                       
                                var param =  panelDetail.down('#tab_sbs030ukrv0Tab').getValues();
                                sbs030ukrvs0_2Store.loadStoreRecords(param);  
                            }
                        }
                    }
                ]
            }, {
                region: 'south',
                xtype: 'uniGridPanel',
                itemId:'sbs030ukrv0_Grid2',
                id:'sbs030ukrv0_Grid2',
                store : sbs030ukrvs0_2Store, 
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
                                                            Ext.getCmp('tab_sbs030ukrv0Tab').down('#sbs030ukrv0_Grid2').setCustomData(record,false, Ext.getCmp('tab_sbs030ukrv0Tab').down('#sbs030ukrv0_Grid2').uniOpt.currentRecord);
                                                        } else {
                                                            UniAppManager.app.onNewDataButtonDown();
                                                            Ext.getCmp('tab_sbs030ukrv0Tab').down('#sbs030ukrv0_Grid2').setCustomData(record,false, Ext.getCmp('tab_sbs030ukrv0Tab').down('#sbs030ukrv0_Grid2').getSelectedRecord());
                                                        }
                                                    }); 
                                            },
                                            scope: this
                                    },
                                    'onClear': function(type) {
                                        Ext.getCmp('tab_sbs030ukrv0Tab').down('#sbs030ukrv0_Grid2').setCustomData(null,true, Ext.getCmp('tab_sbs030ukrv0Tab').down('#sbs030ukrv0_Grid2').uniOpt.currentRecord);
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
                                                            Ext.getCmp('tab_sbs030ukrv0Tab').down('#sbs030ukrv0_Grid2').setCustomData(record,false, Ext.getCmp('tab_sbs030ukrv0Tab').down('#sbs030ukrv0_Grid2').uniOpt.currentRecord);
                                                        } else {
                                                            UniAppManager.app.onNewDataButtonDown();
                                                            Ext.getCmp('tab_sbs030ukrv0Tab').down('#sbs030ukrv0_Grid2').setCustomData(record,false, Ext.getCmp('tab_sbs030ukrv0Tab').down('#sbs030ukrv0_Grid2').getSelectedRecord());
                                                        }
                                                    }); 
                                            },
                                            scope: this
                                    },
                                    'onClear': function(type) {
                                        Ext.getCmp('tab_sbs030ukrv0Tab').down('#sbs030ukrv0_Grid2').setCustomData(null,true, Ext.getCmp('tab_sbs030ukrv0Tab').down('#sbs030ukrv0_Grid2').uniOpt.currentRecord);
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
                    	if(!Ext.isEmpty(grdRecord)) {
	                        grdRecord.set('CUSTOM_CODE'           , '');
	                        grdRecord.set('CUSTOM_NAME'           , '');
                    	}

                    } else {
                    	if(!Ext.isEmpty(grdRecord)) {
	                        grdRecord.set('CUSTOM_CODE'           , record['CUSTOM_CODE']);
	                        grdRecord.set('CUSTOM_NAME'           , record['CUSTOM_NAME']);
                    	}
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
                            var labelText = invalid.items[0]['fieldLabel']+' : ';
                        } else if(Ext.isDefined(invalid.items[0].ownerCt)) {
                            var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
                        }
    
                        Unilite.messageBox(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
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