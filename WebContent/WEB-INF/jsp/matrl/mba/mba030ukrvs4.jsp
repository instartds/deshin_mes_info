<%@page language="java" contentType="text/html; charset=utf-8"%>
	 {
		title:'외주 기초재고등록',
		border: false,
		id		: 'tab_basicStock',
		itemId	: 'tab_basicStock',
		xtype: 'uniDetailForm',
		layout: {type: 'vbox', align: 'stretch'},
		items:[{
			xtype: 'container',
			layout: {type: 'uniTable', columns: 3},
			items:[{
				fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>', 
				name: 'DIV_CODE', 
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				value:'01',
				allowBlank: false
			},
			Unilite.popup('AGENT_CUST',{
		        	fieldLabel: '<t:message code="system.label.purchase.subcontractor" default="외주처"/>',
                    valueFieldName: 'CUSTOM_CODE', 
                    textFieldName: 'CUSTOM_NAME', 
//		        	extParam:{'CUSTOM_TYPE':'3'},
					allowBlank:true,	// 2021.08 표준화 작업
					autoPopup:false,	// 2021.08 표준화 작업
					validateBlank:false,// 2021.08 표준화 작업
                    listeners: {
                        applyextparam: function(popup){
                            popup.setExtParam({'AGENT_CUST_FILTER':  ['1','2']});
                            popup.setExtParam({'CUSTOM_TYPE':  ['1','2']});
                        },
                        onSelected: {
                            fn: function(records, type) {
                                UniAppManager.app.fnYyyymmSet();
                            }
                        },
						onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
							panelDetail.down('#tab_basicStock').setValue('CUSTOM_CODE', newValue);
							if(!Ext.isObject(oldValue)) {
								panelDetail.down('#tab_basicStock').setValue('CUSTOM_NAME', '');
							}
						},
						onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
							panelDetail.down('#tab_basicStock').setValue('CUSTOM_NAME', newValue);
							if(!Ext.isObject(oldValue)) {
								panelDetail.down('#tab_basicStock').setValue('CUSTOM_CODE', '');
							}
						}
                    }
	    	}),
		    {					
    			fieldLabel: '기초년월',
    			name:'BASIS_YYYYMM',
    			xtype: 'uniMonthfield',
		        allowBlank: false,
		        value: UniDate.get('today')
    		},
	    	Unilite.popup('DIV_PUMOK',{
		        	fieldLabel: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
                    valueFieldName: 'ITEM_CODE', 
                    textFieldName: 'ITEM_NAME', 
                    autoPopup: true,
                    colspan: 3,
					allowBlank:true,	// 2021.08 표준화 작업
					autoPopup:false,	// 2021.08 표준화 작업
					validateBlank:false,// 2021.08 표준화 작업
					listeners: {
								onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
									panelDetail.down('#tab_basicStock').setValue('ITEM_CODE', newValue);
									if(!Ext.isObject(oldValue)) {
										panelDetail.down('#tab_basicStock').setValue('ITEM_NAME', '');
									}
								},
								onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
									panelDetail.down('#tab_basicStock').setValue('ITEM_NAME', newValue);
									if(!Ext.isObject(oldValue)) {
										panelDetail.down('#tab_basicStock').setValue('ITEM_CODE', '');
									}
								},
		                        applyextparam: function(popup){
		                            popup.setExtParam({'DIV_CODE': panelDetail.down('#tab_basicStock').getValue('DIV_CODE')});
		                        }
                    }
	    	})]			
		}, {				
			xtype: 'uniGridPanel',
			id		: 'mba030ukrsGrid4',
			itemId	: 'mba030ukrsGrid4',
		    store : mba030ukrvs4Store,
             tbar: [{
                        itemId: 'excelBtn',
                        text: '<div style="color: blue">엑셀참조</div>',
                        handler: function() {
                            openExcelWindow();
                        }
                    }],
		    uniOpt: {
		    	expandLastColumn: true,
		        useRowNumberer: true,
		        useMultipleSorting: false
			},		        
			columns: [
					 { dataIndex: 'DIV_CODE' 		 , 	width:100,hidden:true},
               		 { dataIndex: 'CUSTOM_CODE' 	 , 	width:100,hidden:true},
               		 { dataIndex: 'ITEM_CODE' 		 , 	width:113,
                        editor: Unilite.popup('DIV_PUMOK_G', {   
                            textFieldName: 'ITEM_CODE',
                            DBtextFieldName: 'ITEM_CODE',
                            useBarcodeScanner: false,
		                    autoPopup: true,
                            listeners: {
                                'onSelected': {
                                    fn: function(records, type) {
                                        console.log('records : ', records);
                                        Ext.each(records, function(record,i) {
                                            console.log('record',record);
                                            if(i==0) {
                                                panelDetail.down('#mba030ukrsGrid4').setItemData(record,false, panelDetail.down('#mba030ukrsGrid4').uniOpt.currentRecord);
                                            } else {
                                                UniAppManager.app.onNewDataButtonDown();
                                                panelDetail.down('#mba030ukrsGrid4').setItemData(record,false, panelDetail.down('#mba030ukrsGrid4').getSelectedRecord());
                                            }
                                        }); 
                                    },
                                    scope: this
                                },
                                'onClear': function(type) {
                                    panelDetail.down('#mba030ukrsGrid4').setItemData(null,true, panelDetail.down('#mba030ukrsGrid4').uniOpt.currentRecord);
                                },
                                applyextparam: function(popup){ 
                                    popup.setExtParam({'DIV_CODE': panelDetail.down('#tab_regPL').getValue('DIV_CODE')});
//                                    popup.setExtParam({'ITEM_ACCOUNT_FILTER': ['20','30','40','50','60','70','80','90']});       
//                                  popup.setExtParam({'ITEM_ACCOUNT': '20'});       
                                }
                            }
                        })
                      },
               		 { dataIndex: 'ITEM_NAME' 		 , 	width:200,
                        editor: Unilite.popup('DIV_PUMOK_G', {   
//                            useBarcodeScanner: false,
		                    autoPopup: true,
                            listeners: {
                                'onSelected': {
                                    fn: function(records, type) {
                                        console.log('records : ', records);
                                        Ext.each(records, function(record,i) {
                                            console.log('record',record);
                                            if(i==0) {
                                                panelDetail.down('#mba030ukrsGrid4').setItemData(record,false, panelDetail.down('#mba030ukrsGrid4').uniOpt.currentRecord);
                                            } else {
                                                UniAppManager.app.onNewDataButtonDown();
                                                panelDetail.down('#mba030ukrsGrid4').setItemData(record,false, panelDetail.down('#mba030ukrsGrid4').getSelectedRecord());
                                            }
                                        }); 
                                    },
                                    scope: this
                                },
                                'onClear': function(type) {
                                    panelDetail.down('#mba030ukrsGrid4').setItemData(null,true, panelDetail.down('#mba030ukrsGrid4').uniOpt.currentRecord);
                                },
                                applyextparam: function(popup){ 
                                    popup.setExtParam({'DIV_CODE': panelDetail.down('#tab_regPL').getValue('DIV_CODE')});
//                                    popup.setExtParam({'ITEM_ACCOUNT_FILTER': ['20','30','40','50','60','70','80','90']});       
//                                  popup.setExtParam({'ITEM_ACCOUNT': '20'});       
                                }
                            }
                        })
                      },
               		 { dataIndex: 'SPEC'		     , 	width:133},
               		 { dataIndex: 'LOT_NO'           ,  width:120},
                     { dataIndex: 'LOT_YN'           ,  width:120, hidden: true },
               		 { dataIndex: 'STOCK_UNIT' 		 , 	width:100},
               		 { dataIndex: 'STOCK_Q' 		 , 	width:100},
               		 { dataIndex: 'AVERAGE_P' 		 , 	width:100},
               		 { dataIndex: 'STOCK_I' 		 , 	width:100},
               		 { dataIndex: 'BASIS_YYYYMM' 	 , 	width:66,hidden:true},
               		 { dataIndex: 'UPDATE_DB_USER' 	 , 	width:80,hidden:true},
               		 { dataIndex: 'UPDATE_DB_TIME'	 , 	width:80,hidden:true},
               		 { dataIndex: 'COMP_CODE' 		 , 	width:66,hidden:true}
			],
            listeners: {
            	beforeedit  : function( editor, e, eOpts ) {
                    if(e.record.phantom) {
                        if(UniUtils.indexOf(e.field, ['SPEC', 'STOCK_UNIT', 'STOCK_I'])) 
                        { 
                            return false;
                        } else {
                            return true;
                        }
                    } else {
                        if(UniUtils.indexOf(e.field, ['ITEM_CODE', 'ITEM_NAME', 'LOT_NO', 'SPEC', 'STOCK_UNIT', 'STOCK_I'])) 
                        { 
                            return false;
                        } else {
                            return true;
                        }
                    }
                },
                edit: function(editor, e) { console.log(e);
                    var newValue = e.value;
                    var fieldName = e.field;
                    if(fieldName == 'STOCK_Q'){
                        e.record.set('STOCK_I', newValue * e.record.get('AVERAGE_P'));
                    } 
                    if(fieldName == 'AVERAGE_P') {
                        e.record.set('STOCK_I', newValue * e.record.get('STOCK_Q'));
                    }
                }
            },
            setItemData: function(record, dataClear) {
                var grdRecord = this.uniOpt.currentRecord;
                if(dataClear) {
                    grdRecord.set('ITEM_CODE'   , "");
                    grdRecord.set('ITEM_NAME'   , "");
                    grdRecord.set('SPEC'        , ""); 
                    grdRecord.set('STOCK_UNIT'  , ""); 
                    grdRecord.set('LOT_YN'      , "");
                }
                else {
                    grdRecord.set('ITEM_CODE'   , record['ITEM_CODE']);
                    grdRecord.set('ITEM_NAME'   , record['ITEM_NAME']);
                    grdRecord.set('SPEC'        , record['SPEC']); 
                    grdRecord.set('STOCK_UNIT'  , record['STOCK_UNIT']); 
                    grdRecord.set('LOT_YN'      , record['LOT_YN']);
                }
            },
            setExcelData: function(record) {
                var grdRecord = this.getSelectedRecord();
                
                grdRecord.set('ITEM_CODE'           , record['ITEM_CODE']);
                grdRecord.set('ITEM_NAME'           , record['ITEM_NAME']);
                grdRecord.set('SPEC'                , record['SPEC']);
                grdRecord.set('STOCK_UNIT'          , record['STOCK_UNIT']);
                grdRecord.set('STOCK_Q'             , record['STOCK_Q']);
                grdRecord.set('AVERAGE_P'           , record['AVERAGE_P']);
                grdRecord.set('BASIS_P'             , record['BASIS_P']);
                grdRecord.set('STOCK_I'             , record['STOCK_I']);
                grdRecord.set('BASIS_YYYYMM'        , record['BASIS_YYYYMM']);
            }						
		}]
	}