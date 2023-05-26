<%@page language="java" contentType="text/html; charset=utf-8"%>

	{
		title	: 'Cost Pool 정보등록',
		itemId	: 'tab_costPool',
		id		: 'tab_costPool',
		xtype	: 'uniDetailForm',
//		api		: {load: 'cbm030ukrvService.select2'},
		layout	: {type: 'vbox', align:'stretch'},
		items	: [{
			xtype:'container',
			style: {
				color: 'blue'				
			}
		}, {	
			xtype: 'uniGridPanel',
			itemId:'cbm030ukrvsGrid2',
		    store : cbm030ukrvStore2,
		    uniOpt: {			
			    useMultipleSorting	: true,		
			    useLiveSearch		: true,		
			    onLoadSelectFirst	: true,			
			    dblClickToEdit		: true,		
			    useGroupSummary		: false,		
				useContextMenu		: false,	
				useRowNumberer		: true,	
				expandLastColumn	: false,		
				useRowContext		: true,	
				copiedRow			: true,
			    filter: {				
					useFilter		: false,
					autoCreate		: false
				}			
			},		        
			columns: [{dataIndex: 'COMP_CODE'			, width: 100,		hidden: true},
					  {dataIndex: 'DIV_CODE'  			, width: 150},
					  {dataIndex: 'COST_POOL_CODE' 		, width: 100},
					  {dataIndex: 'COST_POOL_NAME' 		, width: 150},
					  {dataIndex: 'COST_POOL_GB' 		, width: 100},                      
                      {dataIndex: 'SAVE_CODE'           ,      width: 80, hidden:true,
                        editor: Unilite.popup('BANK_BOOK_G', {
                                autoPopup: true,
                                textFieldName: 'BANK_BOOK_CODE',
                                DBtextFieldName: 'BANK_BOOK_CODE',
                                    listeners: {'onSelected': {
                                        fn: function(records, type) {
                                            grdRecord = Ext.getCmp('tab_costPool').down('#cbm030ukrvsGrid2').getSelectedRecord();
                                            record = records[0];                                    
                                            grdRecord.set('SAVE_CODE', record['BANK_BOOK_CODE']);
                                            grdRecord.set('SAVE_NAME', record['BANK_BOOK_NAME']);
                                            grdRecord.set('BANK_CODE', record['BANK_CD']);
                                            grdRecord.set('BANK_NAME', record['BANK_NM']);
                                            },
                                        scope: this 
                                        },
                                        'onClear': function(type) {
                                            grdRecord = Ext.getCmp('tab_costPool').down('#cbm030ukrvsGrid2').getSelectedRecord();
                                            grdRecord.set('SAVE_CODE', '');
                                            grdRecord.set('SAVE_NAME', '');
                                            grdRecord.set('BANK_CODE', '');
                                            grdRecord.set('BANK_NAME', '');
                                        },
                                        applyextparam: function(popup){
                                            
                                        }                                   
                                    }
                        })
                      },
                      {dataIndex: 'SAVE_NAME'           ,       width: 133, hidden:true,
                        editor: Unilite.popup('BANK_BOOK_G', {
                                autoPopup: true,
                                    listeners: {'onSelected': {
                                        fn: function(records, type) {
                                            grdRecord = Ext.getCmp('tab_costPool').down('#cbm030ukrvsGrid2').getSelectedRecord();
                                            record = records[0];                                    
                                            grdRecord.set('SAVE_CODE', record['BANK_BOOK_CODE']);
                                            grdRecord.set('SAVE_NAME', record['BANK_BOOK_NAME']);
                                            grdRecord.set('BANK_CODE', record['BANK_CD']);
                                            grdRecord.set('BANK_NAME', record['BANK_NM']);
                                            },
                                        scope: this 
                                        },
                                        'onClear': function(type) {
                                            grdRecord = Ext.getCmp('tab_costPool').down('#cbm030ukrvsGrid2').getSelectedRecord();
                                            grdRecord.set('SAVE_CODE', '');
                                            grdRecord.set('SAVE_NAME', '');
                                            grdRecord.set('BANK_CODE', '');
                                            grdRecord.set('BANK_NAME', '');
                                        },
                                        applyextparam: function(popup){
                                            
                                        }                                   
                                    }
                        })
                    },
                      {dataIndex: 'BANK_CODE'           ,       width: 80, hidden:true,
                        editor: Unilite.popup('BANK_G', {
                            autoPopup: true,
                            textFieldName:'BANK_NAME',
                            DBtextFieldName: 'BANK_NAME',
                            listeners:{
                                scope:this,
                                onSelected:function(records, type ) {
                                    grdRecord = Ext.getCmp('tab_costPool').down('#cbm030ukrvsGrid2').getSelectedRecord();
                                    record = records[0];                                    
                                    grdRecord.set('BANK_CODE', record['BANK_CODE']);
                                    grdRecord.set('BANK_NAME', record['BANK_NAME']);
                                },
                                onClear:function(type)  {
                                    grdRecord = Ext.getCmp('tab_costPool').down('#cbm030ukrvsGrid2').getSelectedRecord();
                                    grdRecord.set('BANK_CODE', '');
                                    grdRecord.set('BANK_NAME', '');
                                }
                            }
                        })
                    },
                      {dataIndex: 'BANK_NAME'           ,       width: 133, hidden:true,
                        editor: Unilite.popup('BANK_G', {
                            autoPopup: true,
                            textFieldName:'BANK_NAME',
                            DBtextFieldName: 'BANK_NAME',
                            listeners:{
                                scope:this,
                                onSelected:function(records, type ) {
                                    grdRecord = Ext.getCmp('tab_costPool').down('#cbm030ukrvsGrid2').getSelectedRecord();
                                    record = records[0];                                    
                                    grdRecord.set('BANK_CODE', record['BANK_CODE']);
                                    grdRecord.set('BANK_NAME', record['BANK_NAME']);
                                },
                                onClear:function(type)  {
                                    grdRecord = Ext.getCmp('tab_costPool').down('#cbm030ukrvsGrid2').getSelectedRecord();
                                    grdRecord.set('BANK_CODE', '');
                                    grdRecord.set('BANK_NAME', '');
                                }
                            }
                        })
                    },
                      {dataIndex: 'BANK_ACCOUNT'        , width: 100 , hidden:true},
					  {dataIndex: 'PRODT_CP_GB' 		, width: 100},
					  {dataIndex: 'APPORTION_YN' 		, width: 100},
					  {dataIndex: 'APPORTION_GB' 		, width: 100},
					  {dataIndex: 'APPORTION_LEVEL' 	, width: 80},
					  {dataIndex: 'COST_POOL_DISTR' 	, width: 150},
					  {dataIndex: 'LLC_SEQ' 			, width: 80},
					  {dataIndex: 'SORT_SEQ' 			, width: 80},
					  {dataIndex: 'REMARK'				, width: 200},
					  {dataIndex: 'UPDATE_DB_USER'		, width: 100,		hidden: true},
					  {dataIndex: 'UPDATE_DB_TIME'		, width: 100,		hidden: true}
			]/*,
			listeners:{
				beforeedit  : function( editor, e, eOpts ) {
					if(UniUtils.indexOf(e.field, ['SUB_CODE', 'CODE_NAME', 'USE_YN'])){
						if(e.record.phantom){
							return true;
						}else{
							return false;
						}
					}
				}	
			}*/
		}]      
	}
