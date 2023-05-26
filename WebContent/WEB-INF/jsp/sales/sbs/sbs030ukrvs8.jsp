<%@page language="java" contentType="text/html; charset=utf-8"%>
	 {
		title:'SET품목등록',
        xtype: 'uniDetailFormSimple',
        itemId: 'sbs030ukrvs8Tab',
        id: 'sbs030ukrvs8Tab',
        layout: {type: 'vbox', align:'stretch'},
        padding: '0 0 0 0',
        items:[{
                xtype: 'container',   
//                region: 'north',
                layout: {type: 'uniTable', columns: 3, tableAttrs: {width: '100%'}},        
                items : [{ 
    					fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
    					name: 'DIV_CODE',
    					xtype: 'uniCombobox',
                        value: UserInfo.divCode,
    					comboType: 'BOR120',           	
	        			tdAttrs: {width: 280}, 
    					allowBlank: false
    				},
    				Unilite.popup('DIV_PUMOK',{
    					fieldLabel: '<t:message code="system.label.sales.item" default="품목"/>', 
//    					textFieldWidth: 170, 
                        valueFieldName: 'ITEM_CODE', 
                        textFieldName: 'ITEM_NAME',
                        validateBlank: false,
                        listeners: {
                            onValueFieldChange: function(field, newValue, oldValue){
                                if(!Ext.isObject(oldValue)) {
                                    panelDetail.down('#sbs030ukrvs8Tab').setValue('ITEM_NAME','');
                                }
                            },
                            onTextFieldChange: function(field, newValue, oldValue){
                                if(!Ext.isObject(oldValue)) {
                                    panelDetail.down('#sbs030ukrvs8Tab').setValue('ITEM_CODE','');
                                }
                            },
                            applyextparam: function(popup){                         
                                popup.setExtParam({'DIV_CODE': panelDetail.down('#sbs030ukrvs8Tab').getValue('DIV_CODE')});
                            }
                        }
    				}),{
                        fieldLabel: '사업장HIDDEN',
                        xtype: 'uniTextfield',
                        name: 'DIV_CODE_TEMP',
                        hidden: true
                    },{
                        fieldLabel: '품목코드HIDDEN',
                        xtype: 'uniTextfield',
                        name: 'SET_ITEM_CODE_TEMP',
                        hidden: true
                    },{
                        fieldLabel: '품목코드HIDDEN',
                        xtype: 'uniTextfield',
                        name: 'CONST_ITEM_CODE_TEMP',
                        hidden: true
                    },{
                        xtype: 'container',
                        layout : {type : 'uniTable'},
                        tdAttrs: {align: 'right'},
                        flex:1,
                        items:[{
                            xtype: 'button',
                            text: '품목등록',
                            hidden: showBtn,
                            handler: function() {
                                var rec = {data : {prgID : 's_bpr100ukrv_kd', 'text':''}};    // 품목정보(상세) 등록으로 이동                               
                                parent.openTab(rec, '/z_kd/s_bpr100ukrv_kd.do', '');
                            }
                        }]
                    }
    			]
			}, {
                xtype: 'uniGridPanel',     
                region: 'west',
                itemId:'sbs030ukrvs8_1Grid',
                id:'sbs030ukrvs8_1Grid',
                store : sbs030ukrvs8_1Store,
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
                	{dataIndex: 'COMP_CODE'		   	    ,	width: 100, hidden:true},
    				{dataIndex: 'DIV_CODE'		   	    ,	width: 100, hidden:true},
    				{dataIndex: 'SET_ITEM_CODE'	   	    ,	width: 100,
                        editor: Unilite.popup('DIV_PUMOK_G', {      
                                textFieldName: 'ITEM_CODE',
                                DBtextFieldName: 'ITEM_CODE',
		         				autoPopup: true,
                                listeners: {'onSelected': {
                                            fn: function(records, type) {
                                                    console.log('records : ', records);
                                                    Ext.each(records, function(record,i) {                                                                     
                                                        if(i==0) {
                                                            Ext.getCmp('sbs030ukrvs8Tab').down('#sbs030ukrvs8_1Grid').setItemData(record,false, Ext.getCmp('sbs030ukrvs8Tab').down('#sbs030ukrvs8_1Grid').uniOpt.currentRecord);
                                                        } else {
                                                            UniAppManager.app.onNewDataButtonDown();
                                                            Ext.getCmp('sbs030ukrvs8Tab').down('#sbs030ukrvs8_1Grid').setItemData(record,false, Ext.getCmp('sbs030ukrvs8Tab').down('#sbs030ukrvs8_1Grid').getSelectedRecord());
                                                        }
                                                    }); 
                                            },
                                            scope: this
                                    },
                                    'onClear': function(type) {
                                        Ext.getCmp('sbs030ukrvs8Tab').down('#sbs030ukrvs8_1Grid').setItemData(null,true, Ext.getCmp('sbs030ukrvs8Tab').down('#sbs030ukrvs8_1Grid').uniOpt.currentRecord);
                                    }
                                }
                        })
                    },
    				{dataIndex: 'CONST_ITEM_CODE'       ,	width: 100, hidden:true},
    				{dataIndex: 'CONST_SEQ'		   	    ,	width: 100, hidden:true},
    				{dataIndex: 'ITEM_NAME'		   	    ,	width: 200,
                        editor: Unilite.popup('DIV_PUMOK_G', {      
                                textFieldName: 'ITEM_CODE',
                                DBtextFieldName: 'ITEM_CODE',
		         				autoPopup: true,
                                listeners: {'onSelected': {
                                            fn: function(records, type) {
                                                    console.log('records : ', records);
                                                    Ext.each(records, function(record,i) {                                                                     
                                                        if(i==0) {
                                                            Ext.getCmp('sbs030ukrvs8Tab').down('#sbs030ukrvs8_1Grid').setItemData(record,false, Ext.getCmp('sbs030ukrvs8Tab').down('#sbs030ukrvs8_1Grid').uniOpt.currentRecord);
                                                        } else {
                                                            UniAppManager.app.onNewDataButtonDown();
                                                            Ext.getCmp('sbs030ukrvs8Tab').down('#sbs030ukrvs8_1Grid').setItemData(record,false, Ext.getCmp('sbs030ukrvs8Tab').down('#sbs030ukrvs8_1Grid').getSelectedRecord());
                                                        }
                                                    }); 
                                            },
                                            scope: this
                                    },
                                    'onClear': function(type) {
                                        Ext.getCmp('sbs030ukrvs8Tab').down('#sbs030ukrvs8_1Grid').setItemData(null,true, Ext.getCmp('sbs030ukrvs8Tab').down('#sbs030ukrvs8_1Grid').uniOpt.currentRecord);
                                    }
                                }
                        })
                    },
    				{dataIndex: 'SPEC'			   	    ,	width: 300},
    				{dataIndex: 'UPDATE_DB_USER'	    ,	width: 100, hidden:true},
    				{dataIndex: 'UPDATE_DB_TIME'	    ,	width: 100, hidden:true}
				],
                listeners: {
                	beforeedit  : function( editor, e, eOpts ) {
                        if(!e.record.phantom) {
                            return false;
                        } else {
                            return true; 
                        }
                    },
                    selectionchange:function(selected, eOpts ) {
                        var record = Ext.getCmp('sbs030ukrvs8Tab').down('#sbs030ukrvs8_1Grid').getSelectedRecord();
                        if(record) {
                            this.returnCell(record);    
                        }          
                    },
                    select: function() {
                        selectedGrid = 'sbs030ukrvs8_1Grid';
                        UniAppManager.setToolbarButtons(['newData', 'delete'], true);
                    }, 
                    cellclick: function() {
                        selectedGrid = 'sbs030ukrvs8_1Grid';
                        UniAppManager.setToolbarButtons(['newData', 'delete'], true);
                    },
                    render: function(grid, eOpts) {
                        var girdNm = grid.getItemId();
                        var store = grid.getStore();
                        grid.getEl().on('click', function(e, t, eOpt) {
                            selectedMasterGrid = 'sbs030ukrvs8_1Grid';
                            
                            if( sbs030ukrvs8_1Store.isDirty() || sbs030ukrvs8_2Store.isDirty() )    {
                                UniAppManager.setToolbarButtons('save', true);  
                            }else {
                                UniAppManager.setToolbarButtons('save', false);
                            }
                            if(grid.getStore().getCount() > 0)  {
                                UniAppManager.setToolbarButtons('delete', true);        
                            }else {
                                UniAppManager.setToolbarButtons('delete', false);
                            }
                        });
                    }
                },
                returnCell: function(record){
                    var param =  panelDetail.down('#sbs030ukrvs8Tab').getValues();
                    var divCode = record.get("DIV_CODE");
                    var setItemCode = record.get("SET_ITEM_CODE");
                    var constItemCode = record.get("CONST_ITEM_CODE");
                    panelDetail.down('#sbs030ukrvs8Tab').setValues({'DIV_CODE_TEMP':divCode, 'SET_ITEM_CODE_TEMP':setItemCode, 'CONST_ITEM_CODE_TEMP':constItemCode});
                    sbs030ukrvs8_2Store.loadStoreRecords(param);
                },
                setItemData: function(record, dataClear, grdRecord) {
                    if(dataClear) {
                    	grdRecord.set('SET_ITEM_CODE'       , '');
                        grdRecord.set('ITEM_NAME'           , '');
                        grdRecord.set('SPEC'                , '');

                    } else {
                        grdRecord.set('SET_ITEM_CODE'       , record['ITEM_CODE']);
                        grdRecord.set('ITEM_NAME'           , record['ITEM_NAME']);
                        grdRecord.set('SPEC'                , record['SPEC']);
                    }
                }
            }, {
                region: 'center',
                xtype: 'uniGridPanel',
                itemId:'sbs030ukrvs8_2Grid',
                id:'sbs030ukrvs8_2Grid',
                padding: '0 0 0 0',
                store : sbs030ukrvs8_2Store,
                uniOpt: {
                    expandLastColumn: true,
                    useRowNumberer: false,
                    onLoadSelectFirst: false,
                    useMultipleSorting: false
                },
                columns: [
                	{dataIndex: 'DIV_CODE'		      ,	width: 93, hidden: true},
					{dataIndex: 'SET_ITEM_CODE'	      ,	width: 100, hidden: true},
					{dataIndex: 'CONST_SEQ'		   	  ,	width: 66},
					{dataIndex: 'CONST_ITEM_CODE'     ,	width: 100,
                        editor: Unilite.popup('DIV_PUMOK_G', {      
                                textFieldName: 'ITEM_CODE',
                                DBtextFieldName: 'ITEM_CODE',
		         				autoPopup: true,
                                listeners: {'onSelected': {
                                            fn: function(records, type) {
                                                    console.log('records : ', records);
                                                    Ext.each(records, function(record,i) {                                                                     
                                                        if(i==0) {
                                                            Ext.getCmp('sbs030ukrvs8Tab').down('#sbs030ukrvs8_2Grid').setItemData(record,false, Ext.getCmp('sbs030ukrvs8Tab').down('#sbs030ukrvs8_2Grid').uniOpt.currentRecord);
                                                        } else {
                                                            UniAppManager.app.onNewDataButtonDown();
                                                            Ext.getCmp('sbs030ukrvs8Tab').down('#sbs030ukrvs8_2Grid').setItemData(record,false, Ext.getCmp('sbs030ukrvs8Tab').down('#sbs030ukrvs8_2Grid').getSelectedRecord());
                                                        }
                                                    }); 
                                            },
                                            scope: this
                                    },
                                    'onClear': function(type) {
                                        Ext.getCmp('sbs030ukrvs8Tab').down('#sbs030ukrvs8_2Grid').setItemData(null,true, Ext.getCmp('sbs030ukrvs8Tab').down('#sbs030ukrvs8_2Grid').uniOpt.currentRecord);
                                    }
                                }
                        })
                    },
					{dataIndex: 'ITEM_NAME'		      ,	width: 200,
                        editor: Unilite.popup('DIV_PUMOK_G', {      
                                textFieldName: 'ITEM_CODE',
                                DBtextFieldName: 'ITEM_CODE',
		         				autoPopup: true,
                                listeners: {'onSelected': {
                                            fn: function(records, type) {
                                                    console.log('records : ', records);
                                                    Ext.each(records, function(record,i) {                                                                     
                                                        if(i==0) {
                                                            Ext.getCmp('sbs030ukrvs8Tab').down('#sbs030ukrvs8_2Grid').setItemData(record,false, Ext.getCmp('sbs030ukrvs8Tab').down('#sbs030ukrvs8_2Grid').uniOpt.currentRecord);
                                                        } else {
                                                            UniAppManager.app.onNewDataButtonDown();
                                                            Ext.getCmp('sbs030ukrvs8Tab').down('#sbs030ukrvs8_2Grid').setItemData(record,false, Ext.getCmp('sbs030ukrvs8Tab').down('#sbs030ukrvs8_2Grid').getSelectedRecord());
                                                        }
                                                    }); 
                                            },
                                            scope: this
                                    },
                                    'onClear': function(type) {
                                        Ext.getCmp('sbs030ukrvs8Tab').down('#sbs030ukrvs8_2Grid').setItemData(null,true, Ext.getCmp('sbs030ukrvs8Tab').down('#sbs030ukrvs8_2Grid').uniOpt.currentRecord);
                                    }
                                }
                        })
                    },
					{dataIndex: 'SPEC'			      ,	width: 300},
					{dataIndex: 'STOCK_UNIT'	  	  ,	width: 80},
					{dataIndex: 'CONST_Q'		  	  ,	width: 80},
					{dataIndex: 'BASIS_SET_Q'	  	  ,	width: 80, hidden: true},
					{dataIndex: 'SO_KIND'		  	  ,	width: 100},
					{dataIndex: 'USE_YN'		  	  ,	width: 56, hidden: true},
					{dataIndex: 'REMARK'		  	  ,	width: 226, hidden: true},
					{dataIndex: 'UPDATE_DB_USER'  	  ,	width: 93, hidden: true},
					{dataIndex: 'UPDATE_DB_TIME'  	  ,	width: 93, hidden: true}						  
				],
                listeners: {
                    beforeedit  : function( editor, e, eOpts ) {
                        if(!e.record.phantom) {
                            if(UniUtils.indexOf(e.field, ['ITEM_NAME'])) { 
                                return true;
                            } else {
                                return false;
                            }
                        } else {
                             if(UniUtils.indexOf(e.field, ['CONST_ITEM_CODE', 'ITEM_NAME'])) { 
                                return true;
                            }
                        }
                    },
                    select: function() {
                        selectedGrid = 'sbs030ukrvs8_2Grid';
                        UniAppManager.setToolbarButtons(['newData', 'delete'], true);
                    }, 
                    cellclick: function() {
                        selectedGrid = 'sbs030ukrvs8_2Grid';
                        UniAppManager.setToolbarButtons(['newData', 'delete'], true);
                    },
                    render: function(grid, eOpts) {
                        var girdNm = grid.getItemId();
                        var store = grid.getStore();
                        grid.getEl().on('click', function(e, t, eOpt) {
                            selectedMasterGrid = 'sbs030ukrvs8_2Grid';
                            
                            if( sbs030ukrvs8_2Store.isDirty() || sbs030ukrvs8_2Store.isDirty() )    {
                                UniAppManager.setToolbarButtons('save', true);  
                            }else {
                                UniAppManager.setToolbarButtons('save', false);
                            }
                            if(grid.getStore().getCount() > 0)  {
                                UniAppManager.setToolbarButtons('delete', true);        
                            }else {
                                UniAppManager.setToolbarButtons('delete', false);
                            }
                        });
                    }
                },
                setItemData: function(record, dataClear, grdRecord) {
                    if(dataClear) {
                        grdRecord.set('CONST_ITEM_CODE'     , '');
                        grdRecord.set('ITEM_NAME'           , '');
                        grdRecord.set('SPEC'                , '');
                        grdRecord.set('STOCK_UNIT'          , '');

                    } else {
                        grdRecord.set('CONST_ITEM_CODE'     , record['ITEM_CODE']);
                        grdRecord.set('ITEM_NAME'           , record['ITEM_NAME']);
                        grdRecord.set('SPEC'                , record['SPEC']);
                        grdRecord.set('STOCK_UNIT'          , record['STOCK_UNIT']);
                    }
                }
            }
        ],
         setAllFieldsReadOnly8 : function(b) {
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