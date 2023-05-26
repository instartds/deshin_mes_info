<%@page language="java" contentType="text/html; charset=utf-8"%>
     {
        title:'배송처등록',
        xtype: 'uniDetailFormSimple',
        itemId: 'sbs030ukrvs2Tab',
        id: 'sbs030ukrvs2Tab',
        layout: {type: 'vbox', align:'stretch'},
        padding: '0 0 0 0',
        items:[{
                xtype: 'container',   
//                region: 'north',
                layout: {type: 'uniTable', columns: 2},        
                items : [{
                        fieldLabel: '고객구분',
                        name:'CUSTOM_TYPE', 
                        xtype: 'uniCombobox', 
                        comboType:'AU',
                        comboCode:'B015'
                    }, 
                    Unilite.popup('AGENT_CUST',{
                        fieldLabel: '<t:message code="system.label.sales.custom" default="거래처"/>', 
                        valueFieldName: 'CUSTOM_CODE_FR', 
                        textFieldName: 'CUSTOM_NAME_FR',
                        validateBlank	: false,
                        listeners: {
                            onValueFieldChange: function(field, newValue, oldValue){
                                if(!Ext.isObject(oldValue)) {
                                    panelDetail.down('#sbs030ukrvs2Tab').setValue('CUSTOM_NAME_FR','');
                                }
                            },
                            onTextFieldChange: function(field, newValue, oldValue){
                                if(!Ext.isObject(oldValue)) {
                                    panelDetail.down('#sbs030ukrvs2Tab').setValue('CUSTOM_CODE_FR','');
                                }
                            }
                        }
                    }), {
                        fieldLabel: '<t:message code="system.label.sales.clienttype" default="고객분류"/>',
                        name:'AGENT_TYPE', 
                        xtype: 'uniCombobox', 
                        comboType:'AU',
                        comboCode:'B055'
                    }, 
                    Unilite.popup('AGENT_CUST',{
                        fieldLabel: '~', 
                        valueFieldName: 'CUSTOM_CODE_TO', 
                        textFieldName: 'CUSTOM_NAME_TO',
                        validateBlank	: false,
                        listeners: {
                            onValueFieldChange: function(field, newValue, oldValue){
                                if(!Ext.isObject(oldValue)) {
                                    panelDetail.down('#sbs030ukrvs2Tab').setValue('CUSTOM_NAME_TO','');
                                }
                            },
                            onTextFieldChange: function(field, newValue, oldValue){
                                if(!Ext.isObject(oldValue)) {
                                    panelDetail.down('#sbs030ukrvs2Tab').setValue('CUSTOM_CODE_TO','');
                                }
                            }
                        }
                    }),{
                        fieldLabel: '고객HIDDEN',
                        xtype: 'uniTextfield',
                        name: 'CUSTOM_CODE_TEMP',
                        hidden: true
                    }
                ]
            }, {
                xtype: 'uniGridPanel',     
                region: 'west',
                itemId:'sbs030ukrvs2_1Grid',
                id:'sbs030ukrvs2_1Grid',
                store : sbs030ukrvs2_1Store,
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
                	{dataIndex: 'CUSTOM_CODE'     ,       width: 86},                   
                    {dataIndex: 'CUSTOM_NAME'     ,       width: 250},                      
                    {dataIndex: 'CUSTOM_TYPE'     ,       width: 140, hidden: true},                    
                    {dataIndex: 'AGENT_TYPE'      ,       width: 86, hidden: true},                     
                    {dataIndex: 'TOP_NAME'        ,       width: 100, hidden: true},                    
                    {dataIndex: 'TELEPHON'        ,       width: 100, hidden: true},                    
                    {dataIndex: 'ADDRESS'         ,       width: 80, hidden: true}
                ],
                listeners: {
                    beforeedit  : function( editor, e, eOpts ) {
                        return false;
                    },
                    selectionchange:function(selected, eOpts ) {
                        var record = Ext.getCmp('sbs030ukrvs2Tab').down('#sbs030ukrvs2_1Grid').getSelectedRecord();
                        this.returnCell(record);              
                    }
                },
                returnCell: function(record){
                    var param =  panelDetail.down('#sbs030ukrvs2Tab').getValues();
                    var customCode = record.get("CUSTOM_CODE");
                    panelDetail.down('#sbs030ukrvs2Tab').setValues({'CUSTOM_CODE_TEMP':customCode});
                    sbs030ukrvs2_2Store.loadStoreRecords(param);
                }
            }, {
                region: 'center',
                xtype: 'uniGridPanel',
                itemId:'sbs030ukrvs2_2Grid',
                id:'sbs030ukrvs2_2Grid',
                padding: '0 0 0 0',
                store : sbs030ukrvs2_2Store,
                uniOpt: {
                    expandLastColumn: true,
                    useRowNumberer: false,
                    useMultipleSorting: false
                },              
                columns: [
                	{dataIndex: 'CUSTOM_CODE'	      ,           width: 33, hidden: true },              
                    {dataIndex: 'DVRY_CUST_SEQ'	      ,           width: 53},              
                    {dataIndex: 'DVRY_CUST_NM'	      ,           width: 140},              
                    {dataIndex: 'DVRY_CUST_PRSN'      ,           width: 100 },              
                    {dataIndex: 'DVRY_CUST_TEL'	      ,           width: 200 },              
                    {dataIndex: 'DVRY_CUST_FAX'	      ,           width: 73, hidden: true },              
                    {dataIndex: 'DVRY_CUST_ZIP'	      ,           width: 66, hidden: true },              
                    {dataIndex: 'DVRY_CUST_ADD'	      ,           width: 400},              
                    {dataIndex: 'REMARK'		      ,           width: 113},              
                    {dataIndex: 'BARCODE'		      ,           width: 200} 
                ]
            }
        ],
         setAllFieldsReadOnly2 : function(b) {
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