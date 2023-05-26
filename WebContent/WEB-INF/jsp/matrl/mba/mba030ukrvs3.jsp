<%@page language="java" contentType="text/html; charset=utf-8"%>
	 {
		title	: '외주 P/L등록',
		border	: false,
		id		: 'tab_regPL',
		itemId	: 'tab_regPL',
		xtype	: 'uniDetailForm',
		layout	: {type: 'vbox', align: 'stretch'},
		items	: [{
			xtype	: 'container',
			layout	: {type: 'uniTable', columns: 3, tdAttrs: {/*style: 'border : 1px solid #ced9e7;',*/ width: '100%'}},
			items	: [{
				fieldLabel	: '<t:message code="system.label.purchase.division" default="사업장"/>',
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				value		: UserInfo.divCode,
				allowBlank	: false,
				tdAttrs		: {width: 380}
			},{
				xtype		: 'radiogroup',
				fieldLabel	: '품목검색',
				id			: 'rdoSelect',
				colspan		: 2,
				items		: [{
					boxLabel	: '현재 적용품목',
					name		: 'OPT_APT_ITEM',
					inputValue	: 'C',
					width		: 120,
					checked		: true
				},{
					boxLabel	: '<t:message code="system.label.purchase.whole" default="전체"/>',
					width		: 120,
					name		: 'OPT_APT_ITEM',
					inputValue	: 'A'
				}
			]},
				Unilite.popup('AGENT_CUST',{
					fieldLabel		: '<t:message code="system.label.purchase.subcontractor" default="외주처"/>',
					validateBlank	: false,
					allowBlank		: false,
					colspan			: 3,
					width			: 380,
					tdAttrs			: {width: 380},
					listeners		: {
						'onSelected': {
							fn: function(records, type) {
								Ext.each(records, function(record,i) {
									gsCustomCode = record.CUSTOM_CODE;
									gsCustomName = record.CUSTOM_NAME;
								});
							},
							scope: this
						},
						applyextparam: function(popup){
							popup.setExtParam({'CUSTOM_TYPE': ['1', '2']});
						}
					}
			}),
				Unilite.popup('DIV_PUMOK',{
					fieldLabel		: '<t:message code="system.label.purchase.parentitemcode" default="모품목코드"/>',
					validateBlank	: false,
					allowBlank		: false,
					colspan			: 1,
					width			: 324,
					tdAttrs			: {width: 324},
					listeners		: {
						'onSelected': {
							fn: function(records, type) {
								Ext.each(records, function(record,i) {
									gsSpec = record.SPEC;
								panelDetail.down('#tab_regPL').setValue('SPEC', gsSpec);

								});
							},
							scope: this
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': panelDetail.down('#tab_regPL').getValue('DIV_CODE')});
                            popup.setExtParam({'ITEM_ACCOUNT_FILTER': ['10','20']});
//                            popup.setExtParam({'ITEM_ACCOUNT': '10'});
						}
					}
			}),
				{
                fieldLabel : '',
                name:'SPEC',
                id   : 'specField',
                xtype:'uniTextfield',
                readOnly:true,
//                holdable: 'hold',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                    }
                }
            },
            {
				xtype	: 'container',
				layout	: {type : 'uniTable'},
				tdAttrs	: {align: 'right'},
				padding: '0 0 5 0',
				items	: [{
						xtype	: 'button',
						name	: 'CONFIRM_CHECK',
						id		: 'procCanc3',
						text	: '외주처 복사',
						width	: 100,
						handler : function() {//외주처 복사 팝업 호출
							openPartListCopyWindow();
						 }
						},{
						xtype	: 'button',
						name	: 'CONFIRM_CHECK',
						id		: 'procCanc1',
						text	: 'BOM 참조',
						width	: 100,
						handler : function() {//BOM참조 팝업 호출
							openBomCopyWindow();
						}
					},{
						xtype	: 'button',
						name	: 'CONFIRM_CHECK',
						id		: 'procCanc2',
						text	: '기존 P/L 참조',
						width	: 100,
						handler : function() {//기존P/L참조 팝업 호출
							openCustCopyWindow();
						}
					}
				]
			}]
		}, {
            xtype   : 'uniGridPanel',
            id      : 'mba030ukrsGrid3_1',
            itemId  : 'mba030ukrsGrid3_1',
            store   : mba030ukrvs3_1Store,
            uniOpt  : {
                dblClickToEdit: true,
                expandLastColumn: false,
                useRowNumberer: false,
                onLoadSelectFirst  : true,
                useMultipleSorting: false
            },
            columns: [{dataIndex: 'COMP_CODE'       , width:66      , hidden:true},
                      {dataIndex: 'DIV_CODE'        , width:66      , hidden:true},
                      {dataIndex: 'CUSTOM_CODE'     , width:66      , hidden:true},
                      {dataIndex: 'PROD_ITEM_CODE'  , width:66      , hidden:true},
                      {dataIndex: 'SEQ'             , width:66      , align: 'center'},
                      {dataIndex: 'ITEM_CODE'       , width:86,
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
                                                panelDetail.down('#mba030ukrsGrid3_1').setItemData(record,false, panelDetail.down('#mba030ukrsGrid3_1').uniOpt.currentRecord);
                                            } else {
                                                UniAppManager.app.onNewDataButtonDown();
                                                panelDetail.down('#mba030ukrsGrid3_1').setItemData(record,false, panelDetail.down('#mba030ukrsGrid3_1').getSelectedRecord());
                                            }
                                        });
                                    },
                                    scope: this
                                },
                                'onClear': function(type) {
                                    panelDetail.down('#mba030ukrsGrid3_1').setItemData(null,true, panelDetail.down('#mba030ukrsGrid3_1').uniOpt.currentRecord);
                                },
                                applyextparam: function(popup){
                                    popup.setExtParam({'DIV_CODE': panelDetail.down('#tab_regPL').getValue('DIV_CODE')});
                                    popup.setExtParam({'ITEM_ACCOUNT_FILTER': ['20','30','40','50','60','70','80','90']});
//                                  popup.setExtParam({'ITEM_ACCOUNT': '20'});
                                }
                            }
                        })
                      },
                      {dataIndex: 'ITEM_NAME'       , width:133,
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
                                                panelDetail.down('#mba030ukrsGrid3_1').setItemData(record,false, panelDetail.down('#mba030ukrsGrid3_1').uniOpt.currentRecord);
                                            } else {
                                                UniAppManager.app.onNewDataButtonDown();
                                                panelDetail.down('#mba030ukrsGrid3_1').setItemData(record,false, panelDetail.down('#mba030ukrsGrid3_1').getSelectedRecord());
                                            }
                                        });
                                    },
                                    scope: this
                                },
                                'onClear': function(type) {
                                    panelDetail.down('#mba030ukrsGrid3_1').setItemData(null,true, panelDetail.down('#mba030ukrsGrid3_1').uniOpt.currentRecord);
                                },
                                applyextparam: function(popup){
                                    popup.setExtParam({'DIV_CODE': panelDetail.down('#tab_regPL').getValue('DIV_CODE')});
                                    popup.setExtParam({'ITEM_ACCOUNT_FILTER': ['20','30','40','50','60','70','80','90']});
//                                  popup.setExtParam({'ITEM_ACCOUNT': '20'});
                                }
                            }
                        })
                      },
                      {dataIndex: 'SPEC'            , width:133},
                      {dataIndex: 'STOCK_UNIT'      , width:80},
                      {dataIndex: 'ITEM_ACCOUNT'    , width:66      , hidden:true},
                      {dataIndex: 'OLD_PATH_CODE'   , width:90      , hidden:true},
                      {dataIndex: 'PATH_CODE'       , width:90      , hidden:true},
                      {dataIndex: 'UNIT_Q'          , width:80},
                      {dataIndex: 'PROD_UNIT_Q'     , width:110},
                      {dataIndex: 'LOSS_RATE'       , width:73},
                      {dataIndex: 'USE_YN'          , width:73},
                      {dataIndex: 'START_DATE'      , width:100},
                      {dataIndex: 'STOP_DATE'       , width:100},
                      {dataIndex: 'GRANT_TYPE'      , width:80},
                      {dataIndex: 'REMARK'          , flex: 1       , minWidth: 200},
                      {dataIndex: 'UPDATE_DB_USER'  , width:66      , hidden:true},
                      {dataIndex: 'UPDATE_DB_TIME'  , width:66      , hidden:true}
            ],
            listeners:{
                beforeedit  : function( editor, e, eOpts ) {
                    //기존 데이터일 경우
                    if(!e.record.phantom){
                        if(UniUtils.indexOf(e.field,  ['ITEM_CODE','ITEM_NAME','SPEC', 'STOCK_UNIT', 'START_DATE'])) {
                           return false;
                        } else {
                            return true;
                        }

                    //신규 데이터일 경우
                    } else {
                        if (UniUtils.indexOf(e.field, ['SPEC','STOCK_UNIT'])) {
                                return false;
                        } else {
                                return true;
                        }
                    }
                },
                selectionchange:function( model1, selected, eOpts ){
                    if(selected.length > 0) {
                    	var record = selected[0];
                        mba030ukrvs3_2Store.loadStoreRecords(record);
                    }
                },
                render: function(grid, eOpts){
                    grid.getEl().on('click', function(e, t, eOpt) {
                        plActiveGridId = grid.getItemId();
                        if( mba030ukrvs3_1Store.isDirty() || mba030ukrvs3_2Store.isDirty() )    {
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
                 },
                 beforedeselect : function ( gird, record, index, eOpts ){
                    if(mba030ukrvs3_2Store.isDirty()) {
                        if(confirm(Msg.sMB017 + "\n" + Msg.sMB061)) {
                            var inValidRecs = mba030ukrvs3_2Store.getInvalidRecords();
                            if(inValidRecs.length > 0 ) {
                                alert(Msg.sMB083);
                                return false;
                            }else {
                                mba030ukrvs3_2Store.saveStore();
                            }
                        }

    //                  Ext.Msg.show({
    //                       title:'확인',
    //                       msg: Msg.sMB017 + "\n" + Msg.sMB061,
    //                       buttons: Ext.Msg.YESNOCANCEL,
    //                       icon: Ext.Msg.QUESTION,
    //                       fn: function(res) {
    //                          //console.log(res);
    //                          if (res === 'yes' ) {
    //                              var inValidRecs = mba030ukrvs3_2Store.getInvalidRecords();
    //                              if(inValidRecs.length > 0 ) {
    //                                  alert(Msg.sMB083);
    //                                  return false;
    //                              }else {
    //                                  mba030ukrvs3_2Store.saveStore();
    //                              }
    //                              saveTask.delay(500);
    //                          } else if(res === 'cancel') {
    //                              return false;
    //                          }
    //                       }
    //                  });
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
                }
                else {
                    grdRecord.set('ITEM_CODE'   , record['ITEM_CODE']);
                    grdRecord.set('ITEM_NAME'   , record['ITEM_NAME']);
                    grdRecord.set('SPEC'        , record['SPEC']);
                    grdRecord.set('STOCK_UNIT'  , record['STOCK_UNIT']);
                }
            },
            setItemData2: function(record, dataClear) {
                var grdRecord = this.uniOpt._selectionRecord.selected;
                if(dataClear) {
                    grdRecord.set('DIV_CODE'        , "");
                    grdRecord.set('CUSTOM_CODE'     , "");
                    grdRecord.set('PROD_ITEM_CODE'  , "");
                    grdRecord.set('SEQ'             , "");
                    grdRecord.set('ITEM_CODE'       , "");
                    grdRecord.set('ITEM_NAME'       , "");
                    grdRecord.set('SPEC'            , "");
                    grdRecord.set('STOCK_UNIT'      , "");
                    grdRecord.set('ITEM_ACCOUNT'    , "");
                    grdRecord.set('PATH_CODE'       , "");
                    grdRecord.set('UNIT_Q'          , "");
                    grdRecord.set('PROD_UNIT_Q'     , "");
                    grdRecord.set('LOSS_RATE'       , "");
                    grdRecord.set('USE_YN'          , "");
                    grdRecord.set('START_DATE'      , "");
                    grdRecord.set('STOP_DATE'       , "");
                    grdRecord.set('REMARK'          , "");
                }
                else {//여기부터
                    grdRecord.set('DIV_CODE'        , record.get('DIV_CODE'));
                    grdRecord.set('CUSTOM_CODE'     , record.get('CUSTOM_CODE'));
                    grdRecord.set('PROD_ITEM_CODE'  , panelDetail.down('#tab_regPL').getValue('ITEM_CODE'));				//record.get('PROD_ITEM_CODE'));
                    grdRecord.set('SEQ'             , record.get('SEQ'));
                    grdRecord.set('ITEM_CODE'       , record.get('ITEM_CODE'));
                    grdRecord.set('ITEM_NAME'       , record.get('ITEM_NAME'));
                    grdRecord.set('SPEC'            , record.get('SPEC'));
                    grdRecord.set('STOCK_UNIT'      , record.get('STOCK_UNIT'));
                    grdRecord.set('ITEM_ACCOUNT'    , record.get('ITEM_ACCOUNT'));
                    grdRecord.set('PATH_CODE'       , record.get('PATH_CODE'));
                    grdRecord.set('UNIT_Q'          , record.get('UNIT_Q'));
                    grdRecord.set('PROD_UNIT_Q'     , record.get('PROD_UNIT_Q'));
                    grdRecord.set('LOSS_RATE'       , record.get('LOSS_RATE'));
                    grdRecord.set('USE_YN'          , record.get('USE_YN'));
                    grdRecord.set('START_DATE'      , record.get('START_DATE'));
                    if(!Ext.isEmpty(record.get('STOP_DATE'))) {		//20210819 추가
                        grdRecord.set('STOP_DATE'   , record.get('STOP_DATE'));
                    }
                    grdRecord.set('REMARK'          , record.get('REMARK'));
                }
            }
        }, {
            xtype   : 'uniGridPanel',
            id      : 'mba030ukrsGrid3_2',
            itemId  : 'mba030ukrsGrid3_2',
            store   : mba030ukrvs3_2Store,
            uniOpt  : {
                dblClickToEdit: true,
                expandLastColumn: false,
                useRowNumberer: false,
                onLoadSelectFirst  : true,
                useMultipleSorting: false
            },
            columns: [ { dataIndex: 'COMP_CODE'               ,width: 66, hidden: true   },
                       { dataIndex: 'DIV_CODE'               ,width: 66, hidden: true   },
                       { dataIndex: 'CUSTOM_CODE'               ,width: 66, hidden: true   },
    //                 { dataIndex: 'SEQ'                    ,width: 45, locked: true   },
                       { dataIndex: 'PROD_ITEM_CODE'         ,width: 66, hidden: true   },
                       { dataIndex: 'CHILD_ITEM_CODE'        ,width: 66, hidden: true   },
                       { dataIndex: 'EXCHG_ITEM_CODE'        ,width: 120  , tdCls:'x-change-cell' ,
                       editor: Unilite.popup('DIV_PUMOK_G', {
                                            textFieldName: 'EXCHG_ITEM_CODE',
                                            DBtextFieldName: 'ITEM_CODE',
                                            extParam: {DIV_CODE: UserInfo.divCode, ITEM_ACCOUNT_FILTER:['20','40','50','60'], ITEM_EXCLUDE:'PROD_ITEM_CODE' ,DEFAULT_ITEM_ACCOUNT:'20'},
                                            uniOpt:{
                                                recordFields : ['DIV_CODE','PROD_ITEM_CODE','CHILD_ITEM_CODE'],
                                                grid:'bpr560ukrvGrid3'
                                            },
		                  				  	autoPopup: true,
                                            listeners: {'onSelected': {
                                                            fn: function(records, type) {
                                                                    console.log('records : ', records);

                                                                    panelDetail.down('#mba030ukrsGrid3_2').setItemData(records[0],false);

                                                                },
                                                            scope: this
                                                            },
                                                        'onClear': function(type) {
                                                                        panelDetail.down('#mba030ukrsGrid3_2').setItemData(null,true);
                                                                    }
                                            }
                                    })
                        },
                       { dataIndex: 'ITEM_NAME'              ,width: 200  ,
                       editor: Unilite.popup('DIV_PUMOK_G', {
                                            extParam: {DIV_CODE: UserInfo.divCode, ITEM_ACCOUNT_FILTER:['20','40','50','60'], ITEM_EXCLUDE:'PROD_ITEM_CODE' ,DEFAULT_ITEM_ACCOUNT:'20'},
                                            uniOpt:{
                                                recordFields : ['DIV_CODE','PROD_ITEM_CODE','CHILD_ITEM_CODE'],
                                                grid:'bpr560ukrvGrid3'
                                            },
		                    				autoPopup: true,
                                            listeners: {'onSelected': {
                                                            fn: function(records, type) {
                                                                    console.log('records : ', records);
                                                                    panelDetail.down('#mba030ukrsGrid3_2').setItemData(records[0],false);

                                                                },
                                                            scope: this
                                                            },
                                                        'onClear': function(type) {
                                                                        panelDetail.down('#mba030ukrsGrid3_2').setItemData(null,true);
                                                                    }
                                                                }
                                    })
                        },
                       { dataIndex: 'SPEC'                   ,width: 100   },
                       { dataIndex: 'STOCK_UNIT'             ,width: 40   },
                       { dataIndex: 'UNIT_Q'                 ,width: 80  ,format:'0,000.000',editor:{format:'0,000.000'} },
                       { dataIndex: 'PROD_UNIT_Q'            ,width: 100 ,format:'0,000.000',editor:{format:'0,000.000'} },
                       { dataIndex: 'LOSS_RATE'              ,width: 80  ,format:'0,000.000',editor:{format:'0,000.000'} },
                       { dataIndex: 'UNIT_P1'                ,width: 80   },
                       { dataIndex: 'UNIT_P2'                ,width: 80   },
                       { dataIndex: 'UNIT_P3'                ,width: 80   },
                       { dataIndex: 'MAN_HOUR'               ,width: 80   },
                       { dataIndex: 'USE_YN'                 ,width: 80   },
                       { dataIndex: 'BOM_YN'                 ,width: 80   },
                       { dataIndex: 'PRIOR_SEQ'              ,width: 80   },
                       { dataIndex: 'START_DATE'             ,width: 100  , tdCls:'x-change-cell' },
                       { dataIndex: 'STOP_DATE'              ,width: 100   },
                       { dataIndex: 'REMARK'                 ,width: 226  },
                       { dataIndex: 'UPDATE_DB_USER'         ,width: 66, hidden: true   },
                       { dataIndex: 'UPDATE_DB_TIME'         ,width: 66, hidden: true   }
            ],
            listeners:{
                render: function(grid, eOpts){
                    grid.getEl().on('click', function(e, t, eOpt) {
                        plActiveGridId = grid.getItemId();
                        if( mba030ukrvs3_1Store.isDirty() || mba030ukrvs3_2Store.isDirty() )    {
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
                 },
                beforeedit  : function( editor, e, eOpts ) {
                    if (UniUtils.indexOf(e.field,
                                                ['COMP_CODE','DIV_CODE', 'CUSTOM_CODE','PROD_ITEM_CODE','CHILD_ITEM_CODE',
                                                 'SPEC','STOCK_UNIT','OLD_PATH_CODE','STOCK_UNIT',
                                                 'REMARK','UPDATE_DB_USER','UPDATE_DB_TIME']))
                                return false;
                    if(!e.record.phantom){
                        if(UniUtils.indexOf(e.field,
                                            ['EXCHG_ITEM_CODE','ITEM_NAME','START_DATE']))
                               return false;
                    }
                }
            },
            setItemData: function(record, dataClear) {
                var grdRecord = this.uniOpt.currentRecord;
                if(dataClear) {
                    grdRecord.set('EXCHG_ITEM_CODE' ,"");
                    grdRecord.set('ITEM_NAME'       ,"");
                    grdRecord.set('SPEC'            ,"");
                    grdRecord.set('STOCK_UNIT'      ,"");
                    grdRecord.set('OLD_PATH_CODE'   ,"");
                    grdRecord.set('PATH_CODE'       ,"");
                    grdRecord.set('UNIT_Q'          , 1);
                    grdRecord.set('PROD_UNIT_Q'     , 1);
                    grdRecord.set('LOSS_RATE'       , 0);
                    grdRecord.set('UNIT_P1'         , 0);
                    grdRecord.set('UNIT_P2'         , 0);
                    grdRecord.set('UNIT_P3'         , 0);
                    grdRecord.set('MAN_HOUR'        , 0);
                    grdRecord.set('USE_YN'          , 1);
                    grdRecord.set('BOM_YN'          , 1);
                    grdRecord.set('START_DATE'      , UniDate.get('today'));
                    grdRecord.set('STOP_DATE'       , '2999.12.31');
                }
                else {
                    grdRecord.set('EXCHG_ITEM_CODE' , record['ITEM_CODE']);
                    grdRecord.set('ITEM_NAME'       , record['ITEM_NAME']);
                    grdRecord.set('SPEC'            , record['SPEC']);
                    grdRecord.set('STOCK_UNIT'      , record['STOCK_UNIT']);
                    grdRecord.set('OLD_PATH_CODE'   , record['OLD_PATH_CODE']);
                    grdRecord.set('PATH_CODE'       , record['PATH_CODE']);
                    grdRecord.set('UNIT_Q'          , 1);
                    grdRecord.set('PROD_UNIT_Q'     , 1);
                    grdRecord.set('LOSS_RATE'       , 0);
                    grdRecord.set('UNIT_P1'         , record['BASIS_P']);
                    grdRecord.set('UNIT_P2'         , 0);
                    grdRecord.set('UNIT_P3'         , 0);
                    grdRecord.set('MAN_HOUR'        , 0);
                    grdRecord.set('USE_YN'          , 1);
                    grdRecord.set('BOM_YN'          , 1);
                    //grdRecord.set('PRIOR_SEQ'     , record['SEQ']);
                    grdRecord.set('START_DATE'      , UniDate.get('today'));
                    grdRecord.set('STOP_DATE'       , '2999.12.31');
                }
            }
        }]
	}
