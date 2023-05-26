<%@page language="java" contentType="text/html; charset=utf-8"%>

	var process_register =	{
		itemId: 'process_register',
		id:'process_register',
		layout: 'fit',
		items:[{
				title:'공정등록',
				itemId: 'tab_pbs070ukrvs5Tab',
				id:'tab_pbs070ukrvs5Tab',
				xtype: 'uniDetailFormSimple',
		        		layout: {type: 'vbox', align:'stretch'},
			        	padding: '0 0 0 0',
		        		items:[{
							xtype: 'container',
							id : 'container5',
							layout: {type: 'uniTable'},
							items:[{
								fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
								name:'DIV_CODE',
								xtype: 'uniCombobox',
								comboType:'BOR120',
								value: UserInfo.divCode,
								holdable: 'hold',
								allowBlank:false,
								listeners: {
		                            change: function(field, newValue, oldValue, eOpts) {
		                            	panelDetail.down('#tab_pbs070ukrvs5Tab').setValue('WORK_SHOP_CODE','');
		                            }
		                        }
							},
							{
							fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
							name: 'WORK_SHOP_CODE',
							xtype: 'uniCombobox',
							comboType:'WU',
							listeners:{
                                beforequery:function( queryPlan, eOpts )   {
	                                var store = queryPlan.combo.store;
	                                store.clearFilter();
	                                if(!Ext.isEmpty(panelDetail.down('#tab_pbs070ukrvs5Tab').getValue('DIV_CODE'))){
	                                    store.filterBy(function(record){
	                                        return record.get('option') == panelDetail.down('#tab_pbs070ukrvs5Tab').getValue('DIV_CODE');
	                                    })
	                                }else{
	                                    store.filterBy(function(record){
	                                        return false;
	                                    })
	                                }
	                            }
							}




						},{
                                fieldLabel: '사업장temp',
                                name:'DIV_CODE_TEMP',
                                xtype: 'uniTextfield',
                                hidden: true
                            },{
                                fieldLabel: '작업장temp',
                                name:'WORK_SHOP_CODE_TEMP',
                                xtype: 'uniTextfield',
                                hidden: true
                            },{
                                fieldLabel: '공정temp',
                                name:'PROG_WORK_CODE_TEMP',
                                xtype: 'uniTextfield',
                                hidden: true
                            }]
			        	},{
                            xtype: 'container',
                            layout: 'fit',
                            region: 'center',
                            items:[]
//        				    	{
//                                xtype: 'component'
//                            },{
//                                border: false,
//                                name: '',
//                                html: "<font color = 'blue' >설비등록</font>",
//                                width: 350
//                            },{
//                                border: false,
//                                name: '',
//                                html: "<font color = 'blue' >금형등록</font>",
//                                width: 350,
//                                margin: '0 0 0 -800'
//                            },{
//                                xtype: 'uniGridPanel',
//                                itemId:'pbs070ukrvs_5_2Grid',
//                                store : pbs070ukrvs_5_2Store,
//                                id: 'pbs070ukrvs_5_2Grid',
//                                width: 800,
//                                height: 350,
//                                padding: '0 0 0 0',
//                                dockedItems: [{
//                                    xtype: 'toolbar',
//                                    dock: 'top',
//                                    padding:'0px',
//                                    border:0
//                                }],
//                                uniOpt:{    expandLastColumn: false,
//                                            useRowNumberer: true,
//                                            useMultipleSorting: false
//                                },
//                                columns: [
//                                	{dataIndex: 'COMP_CODE'                   ,       width: 100, hidden: true},
//                                	{dataIndex: 'DIV_CODE'                    ,       width: 100, hidden: true},
//                                    {dataIndex: 'WORK_SHOP_CODE'              ,       width: 100, hidden: true},
//                                    {dataIndex: 'PROG_WORK_CODE'              ,       width: 100, hidden: true},
//                                    {dataIndex: 'EQUIP_CODE'                  ,       width: 110},
//                                    {dataIndex: 'EQUIP_NAME'                  ,       width: 200},
//                                    {dataIndex: 'SELECT_BASIS'                ,       width: 100},
//                                    {dataIndex: 'REMARK '                     ,       width: 100}
//                                ],
//                                listeners: {
//                                    containerclick: function() {
//                                        selectedGrid = 'pbs070ukrvs_5_2Grid';
//                                        UniAppManager.setToolbarButtons('newData', true);
//                                        UniAppManager.setToolbarButtons('delete', true);
//                                    }, select: function() {
//                                        selectedGrid = 'pbs070ukrvs_5_2Grid';
//                                        UniAppManager.setToolbarButtons('newData', true);
//                                        UniAppManager.setToolbarButtons('delete', true);
//                                    }, cellclick: function() {
//                                        selectedGrid = 'pbs070ukrvs_5_2Grid';
//                                        UniAppManager.setToolbarButtons('newData', true);
//                                        UniAppManager.setToolbarButtons('delete', true);
//                                    }
//                                }
//                        },{
//                                xtype: 'uniGridPanel',
//                                itemId:'pbs070ukrvs_5_3Grid',
//                                store : pbs070ukrvs_5_3Store,
//                                id: 'pbs070ukrvs_5_3Grid',
//                                width: 800,
//                                height: 350,
//                                margin: '0 0 0 -800',
//                                dockedItems: [{
//                                    xtype: 'toolbar',
//                                    dock: 'top',
//                                    padding:'0px',
//                                    border:0
//                                }],
//                                uniOpt:{    expandLastColumn: false,
//                                            useRowNumberer: true,
//                                            useMultipleSorting: false
//                                },
//                                columns: [
//                                    {dataIndex: 'COMP_CODE'                   ,       width: 100, hidden: true},
//                                    {dataIndex: 'DIV_CODE'                    ,       width: 100, hidden: true},
//                                    {dataIndex: 'WORK_SHOP_CODE'              ,       width: 100, hidden: true},
//                                    {dataIndex: 'PROG_WORK_CODE'              ,       width: 100, hidden: true},
//                                    {dataIndex: 'MOLD_CODE'                   ,       width: 110},
//                                    {dataIndex: 'MOLD_NAME'                   ,       width: 200},
//                                    {dataIndex: 'SELECT_BASIS'                ,       width: 100},
//                                    {dataIndex: 'REMARK '                     ,       width: 100}
//                                ],
//                                listeners: {
//                                    containerclick: function() {
//                                        selectedGrid = 'pbs070ukrvs_5_3Grid';
//                                        UniAppManager.setToolbarButtons('newData', true);
//                                        UniAppManager.setToolbarButtons('delete', true);
//                                    }, select: function() {
//                                        selectedGrid = 'pbs070ukrvs_5_3Grid';
//                                        UniAppManager.setToolbarButtons('newData', true);
//                                        UniAppManager.setToolbarButtons('delete', true);
//                                    }, cellclick: function() {
//                                        selectedGrid = 'pbs070ukrvs_5_3Grid';
//                                        UniAppManager.setToolbarButtons('newData', true);
//                                        UniAppManager.setToolbarButtons('delete', true);
//                                    }
//                                }
//                        }
//                 ]
	          },{
                                    xtype: 'component'
                                },{
                                    xtype: 'uniGridPanel',
                                    itemId:'pbs070ukrvs_5Grid',
                                    id: 'pbs070ukrvs_5Grid',
                                    store : pbs070ukrvs_5Store,
                                    width: 1620,
                                    height: 723,
                                    padding: '0 0 0 0',
//                                  dockedItems: [{
//                                      xtype: 'toolbar',
//                                      dock: 'top',
//                                      padding:'0px',
//                                      border:0
//                                  }],
                                    uniOpt:{    expandLastColumn: false,
                                                useRowNumberer: true,
                                                useMultipleSorting: false
                                    },
                                    columns: [
                                        {dataIndex: 'DIV_CODE'              ,       width: 100, hidden: true},
                                        {dataIndex: 'WORK_SHOP_CODE'        ,       width: 100
                                            ,'editor' : Unilite.popup('WORK_SHOP_G',{textFieldName:'TREE_CODE', textFieldWidth:100, DBtextFieldName: 'TREE_CODE',
                                            autoPopup: true,
                                            listeners: {'onSelected': {
                                                    fn: function(records, type) {
                                                       process_register.fnWorkShopChange(records);
                                                    },
                                                    scope: this
                                                },
                                                'onClear': function(type) {
                                                    grdRecord = Ext.getCmp('tab_pbs070ukrvs5Tab').down('#pbs070ukrvs_5Grid').getSelectedRecord();
                                                    //record = records[0];
                                                    grdRecord.set('WORK_SHOP_CODE', '');
                                                    grdRecord.set('WORK_SHOP_NAME', '');
                                                },
                                                applyextparam: function(popup){
                                                   var param =  panelDetail.down('#tab_pbs070ukrvs5Tab').getValues();
                                                   popup.setExtParam({'TYPE_LEVEL': param.DIV_CODE});
                                                }
                                            }
                                        })
                                    },
                                        {dataIndex: 'WORK_SHOP_NAME'        ,       width: 200
                                            ,'editor' : Unilite.popup('WORK_SHOP_G',{
                                                        textFieldName:'TREE_NAME',
                                                        textFieldWidth:100,
                                                        DBtextFieldName: 'TREE_NAME',
                                                        autoPopup: true,
                                                        listeners: {
                                                            'onSelected': {
                                                                fn: function(records, type) {
                                                                    process_register.fnWorkShopChange(records);
                                                                },
                                                                scope: this
                                                            },
                                                            'onClear': function(type) {
                                                                grdRecord = Ext.getCmp('tab_pbs070ukrvs5Tab').down('#pbs070ukrvs_5Grid').getSelectedRecord();
                                                                //record = records[0];
                                                                grdRecord.set('WORK_SHOP_CODE', '');
                                                                grdRecord.set('WORK_SHOP_NAME', '');
                                                            },
                                                            applyextparam: function(popup){
                                                                var param =  panelDetail.down('#tab_pbs070ukrvs5Tab').getValues();
                                                                popup.setExtParam({'TYPE_LEVEL': param.DIV_CODE});
                                                            }
                                                        }
                                            })
                                        },
                                        {dataIndex: 'PROG_WORK_CODE'        ,       width: 100
//                                      editor: Unilite.popup('PROG_WORK_CODE_G', {
//                                                textFieldName: 'PROG_WORK_NAME',
//                                                DBtextFieldName: 'PROG_WORK_NAME',
//                                                //extParam: {SELMODEL: 'MULTI'},
//                                                autoPopup: true,
//                                                listeners: {
//                                                         'onSelected': {
//                                                                fn: function(records, type) {
//                                                                    Ext.each(records, function(record,i) {
//                                                                        if(i==0) {
//
//                                                                            detailGrid.setItemData(record,false, detailGrid.uniOpt.currentRecord);
//                                                                        }else{
//                                                                            UniAppManager.app.onNewDataButtonDown();
//                                                                            detailGrid.setItemData(record,false, detailGrid.getSelectedRecord());
//                                                                        }
//                                                                    });
//                                                                },
//                                                                scope: this
//                                                            },
//                                                            'onClear': function(type) {
//                                                                detailGrid.setItemData(null,true, detailGrid.uniOpt.currentRecord);
//                                                            },
//                                                            applyextparam: function(popup){
//                                                                var param =  panelDetail.down('#tab_pbs070ukrvs5Tab').getValues();
//                                                                popup.setExtParam({'TYPE_LEVEL': param.DIV_CODE});
//                                                            }
//                                                        }
//                                            })
                                    },
                                        {dataIndex: 'PROG_WORK_NAME'        ,       width: 200
//                                      editor: Unilite.popup('PROG_WORK_CODE_G', {
//                                                textFieldName: 'PROG_WORK_NAME',
//                                                DBtextFieldName: 'PROG_WORK_NAME',
//                                                //extParam: {SELMODEL: 'MULTI'},
//                                                autoPopup: true,
//                                                listeners: {'onSelected': {
//                                                                fn: function(records, type) {
//                                                                    Ext.each(records, function(record,i) {
//                                                                        if(i==0) {
//
//                                                                            detailGrid.setItemData(record,false, detailGrid.uniOpt.currentRecord);
//                                                                        }else{
//                                                                            UniAppManager.app.onNewDataButtonDown();
//                                                                            detailGrid.setItemData(record,false, detailGrid.getSelectedRecord());
//                                                                        }
//                                                                    });
//                                                                },
//                                                                scope: this
//                                                            },
//                                                            'onClear': function(type) {
//                                                                detailGrid.setItemData(null,true, detailGrid.uniOpt.currentRecord);
//                                                            },
//                                                            applyextparam: function(popup){
//                                                                var param =  panelDetail.down('#tab_pbs070ukrvs5Tab').getValues();
//                                                                popup.setExtParam({'TYPE_LEVEL': param.DIV_CODE});
//                                                            }
//                                                        }
//                                            })
                                    },
                                       	{dataIndex: 'PROG_UNIT'             ,       width: 80},
                                        {dataIndex: 'STD_TIME'              ,       width: 105},
                                        {dataIndex: 'MAN_Q'             	  ,       width: 80},
                                        {dataIndex: 'CAPA_Q'             	  ,       width: 80},
                                        {dataIndex: 'BATCH_Q'                ,       width: 80},
                                        {dataIndex: 'EQU_CODE'              ,       width: 100
                                        	  ,'editor' : Unilite.popup('EQU_MACH_CODE_G',{textFieldName:'EQU_MACH_NAME', textFieldWidth:100, DBtextFieldName: 'EQU_MACH_NAME',
															    			autoPopup: true,
												                            listeners: {'onSelected': {
												                                    fn: function(records, type) {
												                                        grdRecord = Ext.getCmp('tab_pbs070ukrvs5Tab').down('#pbs070ukrvs_5Grid').getSelectedRecord();
												                                        Ext.each(records, function(record,i) {
												                                            grdRecord.set('EQU_CODE', record.EQU_MACH_CODE);
												                                            grdRecord.set('EQU_NAME', record.EQU_MACH_NAME);
												                                        });
												                                    },
												                                    scope: this
												                                },
												                                'onClear': function(type) {
												                                    grdRecord = Ext.getCmp('tab_pbs070ukrvs5Tab').down('#pbs070ukrvs_5Grid').getSelectedRecord();
												                                    grdRecord.set('EQU_CODE', '');
												                                    grdRecord.set('EQU_NAME', '');
												                                },
												                                applyextparam: function(popup){
												                                    var param =  panelDetail.down('#tab_pbs070ukrvs5Tab').getValues();
												                                    record = Ext.getCmp('tab_pbs070ukrvs5Tab').down('#pbs070ukrvs_5Grid').getSelectedRecord();
												                                    popup.setExtParam({'DIV_CODE': param.DIV_CODE});

												                                }
												                            }
												                })
                                        },
                                        {dataIndex: 'EQU_NAME'              ,       width: 150
                                        	  ,'editor' : Unilite.popup('EQU_MACH_CODE_G',{textFieldName:'EQU_MACH_NAME', textFieldWidth:100, DBtextFieldName: 'EQU_MACH_NAME',
															    			autoPopup: true,
												                            listeners: {'onSelected': {
												                                    fn: function(records, type) {
												                                        grdRecord = Ext.getCmp('tab_pbs070ukrvs5Tab').down('#pbs070ukrvs_5Grid').getSelectedRecord();
												                                        Ext.each(records, function(record,i) {
												                                            grdRecord.set('EQU_CODE', record.EQU_MACH_CODE);
												                                            grdRecord.set('EQU_NAME', record.EQU_MACH_NAME);
												                                        });
												                                    },
												                                    scope: this
												                                },
												                                'onClear': function(type) {
												                                    grdRecord = Ext.getCmp('tab_pbs070ukrvs5Tab').down('#pbs070ukrvs_5Grid').getSelectedRecord();
												                                    grdRecord.set('EQU_CODE', '');
												                                    grdRecord.set('EQU_NAME', '');
												                                },
												                                applyextparam: function(popup){
												                                    var param =  panelDetail.down('#tab_pbs070ukrvs5Tab').getValues();
												                                    record = Ext.getCmp('tab_pbs070ukrvs5Tab').down('#pbs070ukrvs_5Grid').getSelectedRecord();
												                                    popup.setExtParam({'DIV_CODE': param.DIV_CODE});

												                                }
												                            }
												                })
                                        },
                                        {dataIndex: 'PROG_UNIT_COST'        ,       width: 100},
                                        {dataIndex: 'LAST_YN'             ,       width: 80,align:'center'},
                                        {dataIndex: 'TEMPC_01'        	    ,       width: 100},
                                        {dataIndex: 'USE_YN'                ,       width: 100},
                                        {dataIndex: 'UPDATE_DB_USER'        ,       width: 100, hidden: true},
                                        {dataIndex: 'UPDATE_DB_TIME'        ,       width: 100, hidden: true},
                                        {dataIndex: 'EXIST'                 ,       width: 100, hidden: true},
                                        {dataIndex: 'COMP_CODE'             ,       width: 100, hidden: true},
                                        {dataIndex: 'WKORD_YN'				,		width: 100},
                                        {dataIndex: 'REMARK'                ,       flex:1}
                                    ],
                                    listeners: {
                                        selectionchange:function(selected, eOpts ) {
                                            var record = Ext.getCmp('tab_pbs070ukrvs5Tab').down('#pbs070ukrvs_5Grid').getSelectedRecord();
                                            //process_register.fnSelectList5_2Change(record);
                                            //process_register.fnSelectList5_3Change(record);
                                        },
                                        beforeedit  : function( editor, e, eOpts ) {
                                            if(e.record.phantom) {
                                                if(UniUtils.indexOf(e.field, ['WORK_SHOP_CODE', 'WORK_SHOP_NAME', 'PROG_WORK_CODE', 'PROG_WORK_NAME',
                                                                    'STD_TIME', 'PROG_UNIT', 'PROG_UNIT_COST', 'TEMPC_01', 'USE_YN','REMARK', 'MAN_Q', 'CAPA_Q', 'BATCH_Q', 'EQU_CODE', 'EQU_NAME'
                                                                    , 'WKORD_YN']))
                                                {
                                                    return true;
                                                } else {
                                                    return false;
                                                }
                                            } else {
                                                if(UniUtils.indexOf(e.field, ['WORK_SHOP_CODE', 'WORK_SHOP_NAME', 'PROG_WORK_CODE']))
                                                {
                                                    return false
                                                }
                                                else{
                                                     return true;
                                                }
                                            }
                                        },
                                        containerclick: function() {
                                            selectedGrid = 'pbs070ukrvs_5Grid';
                                            UniAppManager.setToolbarButtons('newData', true);
                                            UniAppManager.setToolbarButtons('delete', true);
                                        }, select: function() {
                                            selectedGrid = 'pbs070ukrvs_5Grid';
                                            UniAppManager.setToolbarButtons('newData', true);
                                            UniAppManager.setToolbarButtons('delete', true);
                                        }, cellclick: function() {
                                            selectedGrid = 'pbs070ukrvs_5Grid';
                                            UniAppManager.setToolbarButtons('newData', true);
                                            UniAppManager.setToolbarButtons('delete', true);
                                        }
                                    }
                            }],
              setAllFieldsReadOnly5 : function(b) {
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
		}],
		fnWorkShopChange: function(records) {
			grdRecord = Ext.getCmp('tab_pbs070ukrvs5Tab').down('#pbs070ukrvs_5Grid').getSelectedRecord();
			record = records[0];
			grdRecord.set('WORK_SHOP_CODE', record.TREE_CODE);
			grdRecord.set('WORK_SHOP_NAME', record.TREE_NAME);
			if(Ext.isEmpty(grdRecord.get('DIV_CODE'))){
				grdRecord.set('DIV_CODE', record.TYPE_LEVEL);
			}
		}
//        fnSelectList5_2Change: function(records) {
//            var record = Ext.getCmp('tab_pbs070ukrvs5Tab').down('#pbs070ukrvs_5Grid').getSelectedRecord();
//            var param = {
//            	DIV_CODE       : record.get('DIV_CODE'),
//            	WORK_SHOP_CODE : record.get('WORK_SHOP_CODE'),
//                PROG_WORK_CODE : record.get('PROG_WORK_CODE')
//            }
//            pbs070ukrvs_5_2Store.loadStoreRecords(param);
//        },
//        fnSelectList5_3Change: function(records) {
//            var record = Ext.getCmp('tab_pbs070ukrvs5Tab').down('#pbs070ukrvs_5Grid').getSelectedRecord();
//            var param = {
//                DIV_CODE       : record.get('DIV_CODE'),
//                WORK_SHOP_CODE : record.get('WORK_SHOP_CODE'),
//                PROG_WORK_CODE : record.get('PROG_WORK_CODE')
//            }
//            pbs070ukrvs_5_3Store.loadStoreRecords(param);
//        },

	}