<%@page language="java" contentType="text/html; charset=utf-8"%>
     {
        title:'고객품목등록',
        xtype: 'uniDetailFormSimple',
        itemId: 'tab_sbs030ukrv0_1Tab',
        id: 'tab_sbs030ukrv0_1Tab',
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
                        name: 'TXTLV_L1', 
                        xtype: 'uniCombobox',  
                        store: Ext.data.StoreManager.lookup('itemLeve1Store'), 
                        child: 'TXTLV_L2'
                    }, {
                        fieldLabel: '<t:message code="system.label.sales.itemaccount" default="품목계정"/>',
                        name:'', 
                        xtype: 'uniCombobox', 
                        comboType:'AU',
                        comboCode:'B020'
                    }, {
                        fieldLabel: '<t:message code="system.label.sales.middlegroup" default="중분류"/>',
                        name: 'TXTLV_L2', 
                        xtype: 'uniCombobox',  
                        store: Ext.data.StoreManager.lookup('itemLeve2Store'), 
                        child: 'TXTLV_L3'
                    }, 
                    Unilite.popup('ITEM',{
                        fieldLabel: '<t:message code="system.label.sales.item" default="품목"/>',
                       valueFieldName: 'ITEM_CODE', 
                        textFieldName: 'ITEM_NAME',
                        validateBlank: false,
                        extParam: {'CUSTOM_TYPE':'3'},
                        listeners: {
                            onValueFieldChange: function(field, newValue, oldValue){
                                if(!Ext.isObject(oldValue)) {
                                    panelDetail.down('#tab_sbs030ukrv0_1Tab').setValue('ITEM_NAME','');
                                }
                            },
                            onTextFieldChange: function(field, newValue, oldValue){
                                if(!Ext.isObject(oldValue)) {
                                    panelDetail.down('#tab_sbs030ukrv0_1Tab').setValue('ITEM_CODE','');
                                }
                            }
                        }
                    }), {
                        fieldLabel: '<t:message code="system.label.sales.minorgroup" default="소분류"/>',
                        name: 'TXTLV_L3', 
                        xtype: 'uniCombobox',  
                        store: Ext.data.StoreManager.lookup('itemLeve3Store'), 
                        colspan: 2
                    },{
                        fieldLabel: '품목HIDDEN',
                        xtype: 'uniTextfield',
                        name: 'ITEM_CODE_TEMP',
                        hidden: true
                    },{
                        fieldLabel: '판매단위HIDDEN',
                        xtype: 'uniTextfield',
                        name: 'SALE_UNIT_TEMP',
                        hidden: true
                    },{
                        fieldLabel: '입수HIDDEN',
                        xtype: 'uniTextfield',
                        name: 'TRNS_RATE_TEMP',
                        hidden: true
                    }
                ]
            }, {
                xtype: 'uniGridPanel',
                itemId:'sbs030ukrv0_1Grid',
                id:'sbs030ukrv0_1Grid',
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
                    useRowNumberer: true,
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
                        var record = Ext.getCmp('tab_sbs030ukrv0_1Tab').down('#sbs030ukrv0_1Grid').getSelectedRecord();
                        this.returnCell(record);              
                    }
                },
                returnCell: function(record){
                    var param =  panelDetail.down('#tab_sbs030ukrv0_1Tab').getValues();
                    var itemCode2 = record.get("ITEM_CODE");
                    var saleUnit = record.get("SALE_UNIT");
                    var trnsRate = record.get("TRNS_RATE");
                    panelDetail.down('#tab_sbs030ukrv0_1Tab').setValues({'ITEM_CODE_TEMP':itemCode2, 'SALE_UNIT_TEMP':saleUnit, 'TRNS_RATE_TEMP':trnsRate});
                    sbs030ukrvs0_3Store.loadStoreRecords(param);
                }
            },{
                xtype: 'container',
                layout: {type: 'uniTable'},        
                items : [
                    {
                        fieldLabel: '단가검색',
                        xtype: 'uniRadiogroup',
                        name:'RDO_TYPE',
                        id: 'sItemFlag2',
                        items: [
                            {boxLabel:'현재 적용단가', name:'ITEM_FLAG', inputValue:'C', checked:true, width: 100},
                            {boxLabel:'<t:message code="system.label.sales.whole" default="전체"/>', name:'ITEM_FLAG', inputValue:'A', width: 100}
                        ],
                        listeners: {
                            change: function(field, newValue, oldValue, eOpts) {                       
                                var param =  panelDetail.down('#tab_sbs030ukrv0_1Tab').getValues();
                                param.ITEM_FLAG = newValue.ITEM_FLAG;
                                sbs030ukrvs0_3Store.loadStoreRecords(param);  
                            }
                        }
                    }
                ]
            }, {
                region: 'south',
                xtype: 'uniGridPanel',
                itemId:'sbs030ukrv0_Grid3',
                id:'sbs030ukrv0_Grid3',
                padding: '0 0 0 0',
                store : sbs030ukrvs0_3Store,
                uniOpt: {
                    expandLastColumn: true,
                    useRowNumberer: true,
                    useMultipleSorting: false
                },              
                columns: [
                    {dataIndex: 'TYPE'			                  ,   width: 33, hidden: true},
                    {dataIndex: 'ITEM_CODE'			              ,   width: 100, hidden: true},
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
                    {dataIndex: 'CUSTOM_ITEM_CODE'                ,   width: 100},
                    {dataIndex: 'CUSTOM_ITEM_NAME'                ,   width: 180},
                    {dataIndex: 'CUSTOM_ITEM_SPEC'                ,   width: 100},
                    {dataIndex: 'ORDER_UNIT'                      ,   width: 70},
                    {dataIndex: 'BASIS_P'                         ,   width: 100},
                    {dataIndex: 'ORDER_P'                         ,   width: 100},
                    {dataIndex: 'TRNS_RATE'                       ,   width: 80},
                    {dataIndex: 'AGENT_P'                         ,   width: 100},
                    {dataIndex: 'APLY_START_DATE'                 ,   width: 80},
                    {dataIndex: 'ORDER_PRSN'                      ,   width: 100, hidden: true},
                    {dataIndex: 'MAKER_NAME'                      ,   width: 100, hidden: true},
                    {dataIndex: 'AGREE_DATE'                      ,   width: 100, hidden: true},
                    {dataIndex: 'ORDER_RATE'                      ,   width: 100, hidden: true},
                    {dataIndex: 'REMARK'                          ,   width: 200},
                    {dataIndex: 'DIV_CODE'                        ,   width: 100, hidden: true},
                    {dataIndex: 'UPDATE_DB_USER'                  ,   width: 100, hidden: true},
                    {dataIndex: 'UPDATE_DB_TIME'                  ,   width: 100, hidden: true},
                    {dataIndex: 'COMP_CODE'                       ,   width: 100, hidden: true}
                ],
                listeners: {
                    beforeedit  : function( editor, e, eOpts ) {
                        if(!e.record.phantom) {
                            if(UniUtils.indexOf(e.field, ['CUSTOM_ITEM_CODE', 'CUSTOM_CODE', 'CUSTOM_NAME'])) { 
                                return false;
                            } else {
                                return true;
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
         setAllFieldsReadOnly1_2 : function(b) {
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