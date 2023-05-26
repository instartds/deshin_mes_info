<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_ten900ukrv_kd"  >
	<t:ExtComboStore comboType="AU" comboCode="B013" /> <!-- 판매단위 -->
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >
var isLoad = false; //로딩 플래그 화폐단위 환율 change 로드시 계속 타므로 임시로 막음
var loadData = false;

function appMain() {
	var searchInfoWindow;  //검색창
	var referOrderRecordWindow; // 수주이력참조
    var groupUrl = '${groupUrl}'; //그룹웨어 호출 url
	/**
	 *   Model 정의
	 * @type
	 */
	Unilite.defineModel('S_ten900ukrv_kdModel', {
		fields: [

			{name: 'DIV_CODE'     		, text: '사업장'		  , type: 'string', comboType:'BOR120'},
			{name: 'REPORT_NO'          , text: '보고번호'        , type: 'string'},
            {name: 'REPORT_SEQ'         , text: '순번'            , type: 'int'},
            {name: 'ITEM_CODE'          , text: '품목코드'        , type: 'string', allowBlank:false},
            {name: 'ITEM_NAME'          , text: '품명'            , type: 'string'},
            {name: 'SPEC'               , text: '규격/품번'            , type: 'string'},
            {name: 'ORDER_UNIT'         , text: '판매단위'        , type: 'string', comboType:'AU',comboCode:'B013', displayField: 'value'},
            {name: 'TRADE_SALE_P'       , text: '수출Local판가'   , type: 'float', decimalPrecision:2 ,format:'0,000.00' },
            {name: 'NEGO_SALE_P'        , text: 'Nego가'       	  ,type: 'float', decimalPrecision:2 ,format:'0,000.00'},
            {name: 'NEGO_SALE_LOC_P'        , text: 'Nego단가(자사)'       	  ,type: 'float', decimalPrecision:2 ,format:'0,000.00'},
            {name: 'SALE_Q'             , text: '수량'            , type: 'uniQty', allowBlank:false},
            {name: 'AMT_SALE'           , text: '금액'            , type: 'uniPrice'},
            {name: 'NEGO_DIFF'          , text: '네고차액'        , type: 'uniPrice'},
            {name: 'P_RATE'             , text: '단가증감율(%)'          , type: 'uniPercent'},
            {name: 'REMARK'             , text: '비고'            , type: 'string'},
            {name: 'GW_FLAG'                  , text: '기안여부'                , type: 'string'},
            {name: 'GW_DOC'                   , text: '기안문서'                , type: 'string'},
            {name: 'DRAFT_NO'                 , text: 'DRAFT_NO'                , type: 'string'}


		]
	});//End of Unilite.defineModel('S_ten900ukrv_kdModel', {

	/**
	 * Store 정의(Service 정의)
	 * @type
	 */
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			create: 's_ten900ukrv_kdService.insertList',
			read: 's_ten900ukrv_kdService.selectList',
			update: 's_ten900ukrv_kdService.updateList',
			destroy: 's_ten900ukrv_kdService.deleteList',
			syncAll: 's_ten900ukrv_kdService.saveAll'
		}
	});
   /**
     * Store 정의(Combobox)
     * @type
     */

	var directMasterStore1 = Unilite.createStore('s_ten900ukrv_kdMasterStore1', {
		model: 'S_ten900ukrv_kdModel',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결
			editable: true,			// 수정 모드 사용
			deletable: true,			// 삭제 가능 여부
			useNavi: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: directProxy,
		loadStoreRecords: function(){
			var param= Ext.getCmp('searchForm').getValues();
			console.log(param);
			this.load({
				params: param,
                callback: function(records, operation, success){
                    console.log(records);
                    if(success){
                        if(masterGrid.getStore().getCount() == 0){
                            Ext.getCmp('GW').setDisabled(true);
                        }else if(masterGrid.getStore().getCount() != 0){
                            var moneyUnit = directMasterStore1.data.items[0].data.MONEY_UNIT;
                        	UniBase.fnGwBtnControl('GW', directMasterStore1.data.items[0].data.GW_FLAG);
                           // panelResult.setValue("MONEY_UNIT", directMasterStore1.data.items[0].data.MONEY_UNIT);
                            if(moneyUnit == 'KRW'){

                            	//panelResult.setValue("EXCHG_RATE_O", 1);

                            }else{

                            	//panelResult.setValue("EXCHG_RATE_O", directMasterStore1.data.items[0].data.EXCHG_RATE);

                            }

                        }
                    }
                }
			});
		},
        saveStore : function()	{
        	var paramMaster = panelSearch.getValues();
			var inValidRecs = this.getInvalidRecords();
			if(inValidRecs.length == 0 )	{
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						var master = batch.operations[0].getResultSet();
                        panelSearch.setValue("REPORT_NO", master.REPORT_NO);
                        panelResult.setValue("REPORT_NO", master.REPORT_NO);
                        directMasterStore1.loadStoreRecords();
                        if(directMasterStore1.getCount() == 0){
                            UniAppManager.app.onResetButtonDown();
                        }
					 }
				};
				this.syncAllDirect(config);
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
        listeners:{
            load: function(store, records, successful, eOpts) {
//                if(masterGrid.getStore().getCount() == 0) {
//                    Ext.getCmp('GW').setDisabled(true);
//                } else if(masterGrid.getStore().getCount() != 0) {
//                    Ext.getCmp('GW').setDisabled(false);
//                } else {
//                    if(directMasterStore1.data.items[0].data.GW_FLAG == 'Y') {
//                        UniAppManager.setToolbarButtons(['save', 'newData', 'delete'], false);
//                    } else {
//                        UniAppManager.setToolbarButtons(['save', 'newData', 'delete'], true);
//                    }
//                }
            }
        }
	});//End of var directMasterStore1 = Unilite.createStore('s_ten900ukrv_kdMasterStore1', {


	/**
	 * 검색조건 (Search Panel)
	 * @type
	 */

	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '검색조건',
        defaultType: 'uniSearchSubPanel',
        collapsed: UserInfo.appOption.collapseLeftSearch,
        listeners: {
	        collapse: function () {
	        	panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
	    },
		items: [{
			title: '기본정보',
			id: 'search_panel1',
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
			items: [{
                fieldLabel: '사업장',
                name: 'DIV_CODE',
                xtype: 'uniCombobox',
                comboType: 'BOR120',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('DIV_CODE', newValue);
                    }
                }
            },
                Unilite.popup('AGENT_CUST',{
                validateBlank: false,
                allowBlank: false,
                listeners: {
                	onSelected: {
                        fn: function(records, type) {
                            panelResult.setValue('CUSTOM_CODE', panelSearch.getValue('CUSTOM_CODE'));
                            panelResult.setValue('CUSTOM_NAME', panelSearch.getValue('CUSTOM_NAME'));
                            panelResult.setValue('MONEY_UNIT',records[0].MONEY_UNIT);
                            panelSearch.setValue('MONEY_UNIT',records[0].MONEY_UNIT);
                        },
                        scope: this
                    },
                    onClear: function(type) {
                        panelResult.setValue('CUSTOM_CODE', '');
                        panelResult.setValue('CUSTOM_NAME', '');
                    },
                    applyextparam: function(popup) {

                    }
                }
            }),{
                xtype: 'container',
                layout: {type: 'uniTable', columns: 2},
                items:[{
                    fieldLabel: '화폐/환율',
                    xtype:'uniCombobox',
                    name: 'MONEY_UNIT',
                    comboType: 'AU',
                    comboCode: 'B004',
                    value: 'KRW',
                    displayField: 'value',
                    width: 174,
                    allowBlank: false,
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {
                            panelResult.setValue('MONEY_UNIT', newValue);

                        }
                    }
                },{
                    fieldLabel: '',
                    xtype:'uniNumberfield',
                    name: 'EXCHG_RATE_O',
                    decimalPrecision: 4,
                    allowBlank: false,
                    width: 70,
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {
                            panelResult.setValue('EXCHG_RATE_O', newValue);
                        }
                    }
                }]
            },{
                fieldLabel: '보고번호',
                xtype:'uniTextfield',
                name: 'REPORT_NO'
            },{
    			fieldLabel: '보고일',
    			xtype: 'uniDatefield',
    			name: 'REPORT_DATE',
    			allowBlank: false,
    			listeners: {
    				change: function(field, newValue, oldValue, eOpts) {
    					panelResult.setValue('REPORT_DATE', newValue);
    				}
    			}
    		},{
                fieldLabel: '화폐단위',
                xtype:'uniTextfield',
                fieldLabel: 'MONEY_UNIT',
                value: 'KRW',
                hidden: true
    		},{
                fieldLabel: '기안여부TEMP',
                name:'GW_TEMP',
                xtype: 'uniTextfield',
                hidden: true
            }]
		}]
	});//End of var panelSearch = Unilite.createSearchForm('searchForm', {

	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
            fieldLabel: '사업장',
            name: 'DIV_CODE',
            xtype: 'uniCombobox',
            comboType: 'BOR120',
            allowBlank: false,
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.setValue('DIV_CODE', newValue);
                }
            }
        },
            Unilite.popup('AGENT_CUST',{
            validateBlank: false,
            allowBlank: false,
            colspan: 2,
            listeners: {
            	onSelected: {
                    fn: function(records, type) {
                        panelSearch.setValue('CUSTOM_CODE', panelResult.getValue('CUSTOM_CODE'));
                        panelSearch.setValue('CUSTOM_NAME', panelResult.getValue('CUSTOM_NAME'));
                        panelResult.setValue('MONEY_UNIT',records[0].MONEY_UNIT);
                        panelSearch.setValue('MONEY_UNIT',records[0].MONEY_UNIT);
                    },
                    scope: this
                },
                onClear: function(type) {
                    panelSearch.setValue('CUSTOM_CODE', '');
                    panelSearch.setValue('CUSTOM_NAME', '');
                },
                applyextparam: function(popup) {

                }
            }
        }),{
            xtype: 'container',
            layout: {type: 'uniTable', columns: 2},
            items:[{
                fieldLabel: '화폐/환율',
                xtype:'uniCombobox',
                name: 'MONEY_UNIT',
                comboType: 'AU',
                comboCode: 'B004',
                value: 'KRW',
                displayField: 'value',
                width: 174,
                allowBlank: false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelSearch.setValue('MONEY_UNIT', newValue);
                      if(isLoad){
                          isLoad = false;
                        }else{
                           UniAppManager.app.fnExchngRateO();
                           loadData = false;
                       }
                    }
                }
            },{
                fieldLabel: '',
                xtype:'uniNumberfield',
                name: 'EXCHG_RATE_O',
                decimalPrecision: 4,
                allowBlank: false,
                width: 70,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelSearch.setValue('EXCHG_RATE_O', newValue);
                    }
                }
            }]
        },{
            fieldLabel: '보고번호',
            xtype:'uniTextfield',
            name: 'REPORT_NO'
        },{
            fieldLabel: '보고일',
            xtype: 'uniDatefield',
            name: 'REPORT_DATE',
            allowBlank: false,
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.setValue('REPORT_DATE', newValue);
                }
            }
        },{
            fieldLabel: '화폐단위',
            xtype:'uniTextfield',
            fieldLabel: 'MONEY_UNIT',
            value: 'KRW',
            hidden: true
        }]
    });

    /**
     * Master Grid1 정의(Grid Panel)
     * @type
     */
	var masterGrid = Unilite.createGrid('s_ten900ukrv_kdGrid1', {
    	// for tab
		layout: 'fit',
		region: 'center',
    	uniOpt: {
    		expandLastColumn: false,
		 	useRowNumberer: true,
		 	copiedRow: true
//		 	useContextMenu: true,
        },
         tbar: [{

        }],
		features: [{
			id: 'masterGridSubTotal',
			ftype: 'uniGroupingsummary',
			showSummaryRow: false
		},{
			id: 'masterGridTotal',
			ftype: 'uniSummary',
			showSummaryRow: false
		}],
		store: directMasterStore1,
		tbar: [{
				xtype: 'button',
	            itemId:'refTool',
	            text: '참조...',
	            iconCls : 'icon-referance',
	            menu: Ext.create('Ext.menu.Menu', {
	                items: [{
	                    itemId: 'refBtn',
	                    text: '수주이력참조',
	                    handler: function() {
	                            openRefWindow();
	                        }
					}]
	            })
			},{
                itemId : 'GWBtn',
                id:'GW',
                iconCls : 'icon-referance'  ,
                text:'기안',
                handler: function() {
                    var param = panelResult.getValues();
                    param.DRAFT_NO = UserInfo.compCode + panelResult.getValue('REPORT_NO');
                    if(confirm('기안 하시겠습니까?')) {
                        s_ten900ukrv_kdService.selectGwData(param, function(provider, response) {
                            if(Ext.isEmpty(provider[0]) || provider[0].GW_FLAG != '1' || provider[0].GW_FLAG != '3') {
                                panelResult.setValue('GW_TEMP', '기안중');
                                s_ten900ukrv_kdService.makeDraftNum(param, function(provider2, response)   {
                                    UniAppManager.app.requestApprove();
                                });
                            } else {
                                alert('이미 기안된 자료입니다.');
                                return false;
                            }
                        });
                    }
                    UniAppManager.app.onQueryButtonDown();
                }
            }
        ],
		columns: [
            {dataIndex: 'DIV_CODE'     		 , width: 100, hidden:true},
            {dataIndex: 'REPORT_SEQ'          , width: 80, hidden:true},
            {dataIndex: 'REPORT_NO'          , width: 100, hidden:true},
            {dataIndex: 'ITEM_CODE',        width: 130,
             editor: Unilite.popup('DIV_PUMOK_G', {
                    textFieldName: 'ITEM_CODE',
                    DBtextFieldName: 'ITEM_CODE',
//                                      extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'},
                    useBarcodeScanner: false,
					autoPopup: true,
                    listeners: {'onSelected': {
                                    fn: function(records, type) {
                                            console.log('records : ', records);
                                            Ext.each(records, function(record,i) {
                                                    console.log('record',record);
                                                    if(i==0) {
                                                        masterGrid.setItemData(record,false, masterGrid.uniOpt.currentRecord);
                                                    } else {
                                                        UniAppManager.app.onNewDataButtonDown();
                                                        masterGrid.setItemData(record,false, masterGrid.getSelectedRecord());
                                                    }
                                            });
                                        },
                                    scope: this
                                    },
                                'onClear': function(type) {
                                                var itemCode = masterGrid.uniOpt.currentRecord.get('ITEM_CODE');
                                                masterGrid.setItemData(null,true, masterGrid.uniOpt.currentRecord);
                                                masterGrid.uniOpt.currentRecord.set('ITEM_CODE',itemCode);
                                            },
                                applyextparam: function(popup){
                                    var record = masterGrid.getSelectedRecord();
                                    var divCode = record.get('OUT_DIV_CODE');
                                    popup.setExtParam({'SELMODEL': 'MULTI', 'DIV_CODE': divCode, 'POPUP_TYPE': 'GRID_CODE'});
                                    popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
                                }
                    }
            })
            },
            {dataIndex: 'ITEM_NAME',        width: 150,
             editor: Unilite.popup('DIV_PUMOK_G', {
//                                      extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode},
//                    useBarcodeScanner: false,
					autoPopup: true,
                    listeners: {'onSelected': {
                                    fn: function(records, type) {
                                            console.log('records : ', records);
                                            Ext.each(records, function(record,i) {
                                                    console.log('record',record);
                                                    if(i==0) {
                                                        masterGrid.setItemData(record,false, masterGrid.uniOpt.currentRecord);
                                                    } else {
                                                        UniAppManager.app.onNewDataButtonDown();
                                                        masterGrid.setItemData(record,false, masterGrid.getSelectedRecord());
                                                    }
                                            });
                                        },
                                    scope: this
                                    },
                                'onClear': function(type) {
                                                var itemCode = masterGrid.uniOpt.currentRecord.get('ITEM_CODE');
                                                masterGrid.setItemData(null,true, masterGrid.uniOpt.currentRecord);
                                                masterGrid.uniOpt.currentRecord.set('ITEM_CODE',itemCode);
                                            },
                                applyextparam: function(popup){
                                    var record = masterGrid.getSelectedRecord();
                                    var divCode = record.get('OUT_DIV_CODE');
                                    popup.setExtParam({'SELMODEL': 'MULTI', 'DIV_CODE': divCode});
                                    popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
                                }
                    }
            })
            },
            {dataIndex: 'SPEC'               , width: 100},
            {dataIndex: 'ORDER_UNIT'         , width: 100, align: 'center'},
            {dataIndex: 'TRADE_SALE_P'       , width: 120},
            {dataIndex: 'NEGO_SALE_P'        , width: 100},
            {dataIndex: 'NEGO_SALE_LOC_P'        , width: 120},
            {dataIndex: 'SALE_Q'             , width: 100},
            {dataIndex: 'AMT_SALE'           , width: 110},
            {dataIndex: 'NEGO_DIFF'          , width: 110},
            {dataIndex: 'P_RATE'             , width: 110},
            {dataIndex: 'REMARK'             , width: 300}
		],
		setItemData: function(record, dataClear, grdRecord) {
//              var grdRecord = this.uniOpt.currentRecord;
			var exchRate    = panelResult.getValue('EXCHG_RATE_O');
            if(dataClear) {
                grdRecord.set('ITEM_CODE'       ,"");
                grdRecord.set('ITEM_NAME'       ,"");
                grdRecord.set('SPEC'            ,"");
                grdRecord.set('ORDER_UNIT'      ,"");
                grdRecord.set('TRADE_SALE_P'    , 0);
                grdRecord.set('NEGO_SALE_P'     , 0);
                grdRecord.set('SALE_Q'          , 0);
            } else {
                grdRecord.set('ITEM_CODE'           , record['ITEM_CODE']);
                grdRecord.set('ITEM_NAME'           , record['ITEM_NAME']);
                grdRecord.set('ITEM_ACCOUNT'        , record['ITEM_ACCOUNT']);
                grdRecord.set('SPEC'                , record['SPEC']);
                grdRecord.set('ORDER_UNIT'          , record['SALE_UNIT']);

                var param = {
                    ITEM_CODE: record['ITEM_CODE'],
                    CUSTOM_CODE: '13199',
                    ORDER_UNIT: record['SALE_UNIT'],
                    REPORT_DATE: UniDate.getDbDateStr(panelSearch.getValue('REPORT_DATE'))
                }
                s_ten900ukrv_kdService.getSalePrice(param, function(provider, response){
                    if(!Ext.isEmpty(provider)){
                         grdRecord.set('TRADE_SALE_P', provider.ITEM_P);//수출LOCAL판가 SET
                    }
                });

                param = {
                    ITEM_CODE: record['ITEM_CODE'],
                    CUSTOM_CODE: panelSearch.getValue('CUSTOM_CODE'),
                    ORDER_UNIT: record['SALE_UNIT'],
                    REPORT_DATE: UniDate.getDbDateStr(panelSearch.getValue('REPORT_DATE'))
                }
                s_ten900ukrv_kdService.getSalePrice(param, function(provider, response){
                    if(!Ext.isEmpty(provider)){
                         grdRecord.set('NEGO_SALE_P', provider.ITEM_P);//NEGO가 SET
                         grdRecord.set('NEGO_SALE_LOC_P', provider.ITEM_P * exchRate);//NEGOLOC가 SET
                    }
                });

            }
        },
         setRefData: function(record) {
         	var grdRecord = this.getSelectedRecord();

    		if(!Ext.isEmpty(grdRecord)){

    			  var exchRate    = panelResult.getValue('EXCHG_RATE_O');

				   	  grdRecord.set('DIV_CODE'            , record['DIV_CODE']);
			        //grdRecord.set('REPORT_SEQ'            , record['SER_NO']);
			          grdRecord.set('REPORT_NO'            , panelSearch.getValue('REPORT_NO'));
			        //grdRecord.set('ORDER_NUM'           , masterForm.getValue('ORDER_NUM'));
		              grdRecord.set('ITEM_CODE'           , record['ITEM_CODE']);
			          grdRecord.set('ITEM_NAME'           , record['ITEM_NAME']);
			          grdRecord.set('SPEC'                , record['SPEC']);
			          grdRecord.set('ORDER_UNIT'          , record['ORDER_UNIT']);
			          grdRecord.set('TRADE_SALE_P'          , record['ITEM_P']);
			          grdRecord.set('NEGO_SALE_P'             , record['ORDER_P']);
			          grdRecord.set('SALE_Q'             , record['ORDER_Q']);
			          grdRecord.set('AMT_SALE'         , record['ORDER_O']);
			          grdRecord.set('NEGO_SALE_LOC_P'             ,  grdRecord.get('NEGO_SALE_P') * exchRate);
			          grdRecord.set('NEGO_DIFF'         , 0);
			          grdRecord.set('P_RATE'         , 0);
			          grdRecord.set('REMARK'         , "");

				//            if(masterForm.getValue('TAX_INOUT') != 50)
				//            {
				//                grdRecord.set('TAX_TYPE'        ,record['TAX_TYPE']);
				//            }
				//            if(Ext.isEmpty(masterForm.getValue('DVRY_DATE')))   {
				//
				//                grdRecord.set('DVRY_DATE'       ,masterForm.getValue('ORDER_DATE'));
				//            }else {
				//                grdRecord.set('DVRY_DATE'       ,masterForm.getValue('DVRY_DATE'));
				//            }
				//            grdRecord.set('DISCOUNT_RATE'       , 0);
				//            grdRecord.set('REF_WH_CODE'         , record['WH_CODE']);
				//            grdRecord.set('REF_STOCK_CARE_YN'   , record['STOCK_CARE_YN']);
				//            grdRecord.set('OUT_DIV_CODE'        , record['OUT_DIV_CODE']);
				//            grdRecord.set('STOCK_UNIT'          , record['STOCK_UNIT']);
				//            grdRecord.set('ACCOUNT_YNC'         , record['ACCOUNT_YNC']);
				//
				//
				//            if(Ext.isEmpty(masterForm.getValue('SALE_CUST_CD')))    {
				//                grdRecord.set('SALE_CUST_CD'        ,masterForm.getValue('CUSTOM_CODE'));
				//            }else {
				//                grdRecord.set('SALE_CUST_CD'        ,masterForm.getValue('SALE_CUST_CD'));
				//            }
				//
				//            if(Ext.isEmpty(masterForm.getValue('SALE_CUST_NM')))    {
				//                grdRecord.set('CUSTOM_NAME'     ,masterForm.getValue('CUSTOM_NAME'));
				//            }else {
				//                grdRecord.set('CUSTOM_NAME'     ,masterForm.getValue('SALE_CUST_NM'));
				//            }
				//
				//            grdRecord.set('DVRY_CUST_CD'        , record['DVRY_CUST_CD']);
				//            grdRecord.set('DVRY_CUST_NAME'      , record['DVRY_CUST_NAME']);
				//            grdRecord.set('PRICE_YN'            , record['PRICE_YN']);
				//            grdRecord.set('PROD_PLAN_Q'         , 0);
				//            grdRecord.set('DISCOUNT_RATE'       , record['DISCOUNT_RATE']);
				//            grdRecord.set('PRE_ACCNT_YN'        , record['PRE_ACCNT_YN']);
				//            grdRecord.set('REF_ORDER_DATE'      , masterForm.getValue('ORDER_DATE'));
				//            grdRecord.set('REF_ORD_CUST'        , masterForm.getValue('CUSTOM_CODE'));
				//            grdRecord.set('REF_ORDER_TYPE'      , masterForm.getValue('ORDER_TYPE'));
				//            grdRecord.set('REF_PROJECT_NO'      , masterForm.getValue('PLAN_NUM'));
				//            grdRecord.set('REF_TAX_INOUT'       , Ext.getCmp('taxInout').getChecked()[0].inputValue);
				//            // FIXME gsExchageRate값 설정
				//            // grdRecord.set('REF_EXCHG_RATE_O' ,gsExchageRate);
				//            grdRecord.set('REF_REMARK'          , masterForm.getValue('REMARK'));
				//            grdRecord.set('ORIGIN_Q'            , record['ORDER_Q']);
				//            grdRecord.set('REF_BILL_TYPE'       , masterForm.getValue('BILL_TYPE'));
				//            grdRecord.set('REF_RECEIPT_SET_METH', masterForm.getValue('RECEIPT_SET_METH'));
				//            grdRecord.set('WGT_UNIT'            , record['WGT_UNIT']);
				//            grdRecord.set('UNIT_WGT'            , record['UNIT_WGT']);
				//            grdRecord.set('VOL_UNIT'            , record['VOL_UNIT']);
				//            grdRecord.set('UNIT_VOL'            , record['UNIT_VOL']);

				//            UniSales.fnGetItemInfo(grdRecord
				//                                    , UniAppManager.app.cbGetItemInfo
				//                                    ,'R'
				//                                    ,UserInfo.compCode
				//                                    ,masterForm.getValue('CUSTOM_CODE')
				//                                    ,CustomCodeInfo.gsAgentType
				//                                    ,record['ITEM_CODE']
				//                                    ,BsaCodeInfo.gsMoneyUnit
				//                                    ,record['ORDER_UNIT']
				//                                    ,record['STOCK_UNIT']
				//                                    ,record['TRANS_RATE']
				//                                    ,UniDate.getDbDateStr(masterForm.getValue('ORDER_DATE'))
				//                                    ,grdRecord.get('ORDER_Q')
				//                                    ,grdRecord.get('WGT_UNIT')
				//                                    ,grdRecord.get('VOL_UNIT')
				//                                    ,grdRecord.get('UNIT_WGT')
				//                                    ,grdRecord.get('UNIT_VOL')
				//                                    ,grdRecord.get('PRICE_TYPE')
				//                                    , record['OUT_DIV_CODE']
				//                                    , null
				//                                    , ''
				//                                    );

				            // UniAppManager.app.fnOrderAmtCal(grdRecord, "Q")
				            // UniAppManager.app.fnStockQ(grdRecord, UserInfo.compCode,
							// record['OUT_DIV_CODE'],
							// null,record['ITEM_CODE'],record['WH_CODE']);

    		}

       },
        listeners: {
          	beforeedit: function(editor, e) {
          		if(panelResult.getValue('GW_TEMP') == '기안중') {
                    return false;
                }
          		if(e.record.phantom){
          		    if (!UniUtils.indexOf(e.field, ['ITEM_CODE','ITEM_NAME','SALE_Q'])){
                        return false;
                    }
          		}else{
          		    if (!UniUtils.indexOf(e.field, ['SALE_Q'])){
                        return false;
                    }
          		}

          	}, edit: function(editor, e) {

          	}
          }
	});//End of var masterGrid = Unilite.createGr100id('s_ten900ukrv_kdGrid1', {

	 //검색창 폼 정의
    var orderNoSearch = Unilite.createSearchForm('orderNoSearchForm', {
        layout: {type: 'uniTable', columns : 2},
        trackResetOnLoad: true,
        items: [{
            fieldLabel: '<t:message code="unilite.msg.sMS631" default="사업장"/>'  ,
            name: 'DIV_CODE',
            xtype:'uniCombobox',
            comboType:'BOR120',
            value:UserInfo.divCode,
            listeners: {
                change: function(combo, newValue, oldValue, eOpts) {
                }
            }
        }, {
            fieldLabel: '보고일',
            xtype: 'uniDateRangefield',
            startFieldName: 'REPORT_DATE_FR',
            endFieldName: 'REPORT_DATE_TO',
            width: 350,
            startDate: new Date() ,
            endDate: new Date()
        },
            Unilite.popup('AGENT_CUST',{
            fieldLabel:'<t:message code="unilite.msg.sMSR213" default="거래처"/>' ,
            validateBlank: false
        }),{
            xtype: 'uniTextfield',
            name: 'REPORT_NO',
            fieldLabel: '보고번호'
        }]
    });

	//검색창 모델 정의
    Unilite.defineModel('orderNoMasterModel', {
        fields: [
                 {name: 'REPORT_NO'                    , text: '보고번호'             , type: 'string'},
        	     {name: 'DIV_CODE'                     , text: '사업장'              , type: 'string'},
                 {name: 'CUSTOM_CODE'                  , text: '거래처'              , type: 'string'},
                 {name: 'CUSTOM_NAME'                  , text: '거래처명'             , type: 'string'},
                 {name: 'REPORT_DATE'                  , text: '보고일'              , type: 'uniDate'},
                 {name: 'MONEY_UNIT'                   , text: '화폐단위'             , type: 'string'}
	     ]
    });
    //검색창 스토어 정의
    var orderNoMasterStore = Unilite.createStore('orderNoMasterStore', {
            model: 'orderNoMasterModel',
            autoLoad: false,
            uniOpt : {
                isMaster: false,            // 상위 버튼 연결
                editable: false,            // 수정 모드 사용
                deletable:false,            // 삭제 가능 여부
                useNavi : false         // prev | newxt 버튼 사용
            },
            proxy: {
                type: 'direct',
                api: {
                    read    : 's_ten900ukrv_kdService.selectOrderNumMasterList'
                }
            }
            ,loadStoreRecords : function()  {
                var param= orderNoSearch.getValues();
                console.log( param );
                this.load({
                    params : param
                });
            }
    });
    //검색창 그리드 정의
    var orderNoMasterGrid = Unilite.createGrid('str103ukrvOrderNoMasterGrid', {
        // title: '기본',
        layout : 'fit',
        store: orderNoMasterStore,
        uniOpt:{
            useRowNumberer: false
        },
        columns:  [{ dataIndex: 'REPORT_NO'                    , width: 130 },
                   { dataIndex: 'DIV_CODE'                     , width: 120, hidden:true },
                   { dataIndex: 'CUSTOM_CODE'                  , width: 120 },
                   { dataIndex: 'CUSTOM_NAME'                  , width: 150 },
                   { dataIndex: 'REPORT_DATE'                  , width: 120 }
          ] ,
          listeners: {
              onGridDblClick: function(grid, record, cellIndex, colName) {
                orderNoMasterGrid.returnData(record);
                searchInfoWindow.hide();
                UniAppManager.app.onQueryButtonDown();
              }
          } // listeners
          ,returnData: function(record) {
                if(Ext.isEmpty(record)) {
                    record = this.getSelectedRecord();
                }
                panelSearch.setValue('CUSTOM_CODE', record.get('CUSTOM_CODE'));
                panelSearch.setValue('CUSTOM_NAME', record.get('CUSTOM_NAME'));
                panelSearch.setValue('DIV_CODE', record.get('DIV_CODE'));
                panelSearch.setValue('REPORT_NO', record.get('REPORT_NO'));
                panelSearch.setValue('REPORT_DATE', record.get('REPORT_DATE'));
                panelSearch.setValue('MONEY_UNIT', record.get('MONEY_UNIT'));
                panelSearch.setValue('EXCHG_RATE_O', record.get('EXCHG_RATE'));
                panelResult.setValue('CUSTOM_CODE', record.get('CUSTOM_CODE'));
                panelResult.setValue('CUSTOM_NAME', record.get('CUSTOM_NAME'));
                panelResult.setValue('DIV_CODE', record.get('DIV_CODE'));
                panelResult.setValue('REPORT_NO', record.get('REPORT_NO'));
                panelResult.setValue('REPORT_DATE', record.get('REPORT_DATE'));
                panelResult.setValue('MONEY_UNIT', record.get('MONEY_UNIT'));
                if(!Ext.isEmpty(record.get('EXCHG_RATE'))){
                panelResult.setValue('EXCHG_RATE_O', record.get('EXCHG_RATE'));
               }else{
                	panelResult.setValue('EXCHG_RATE_O', '1');
                }
                loadData = true;
          }



    });
//openSearchInfoWindow

    //검색창 메인
    function openSearchInfoWindow() {
        if(!searchInfoWindow) {
            searchInfoWindow = Ext.create('widget.uniDetailWindow', {
                title: '보고번호검색',
                width: 1080,
                height: 580,
                layout: {type:'vbox', align:'stretch'},
                items: [orderNoSearch, orderNoMasterGrid],
                tbar:  ['->',
                        {   itemId : 'searchBtn',
                            text: '조회',
                            handler: function() {
                                orderNoMasterStore.loadStoreRecords();
                            },
                            disabled: false
                        }, {
                            itemId : 'closeBtn',
                            text: '닫기',
                            handler: function() {
                                searchInfoWindow.hide();
                            },
                            disabled: false
                        }
                ],
                listeners : {beforehide: function(me, eOpt) {
                                            orderNoSearch.clearForm();
                                            orderNoMasterGrid.reset();
                                        },
                             beforeclose: function( panel, eOpts )  {
                                            orderNoSearch.clearForm();
                                            orderNoMasterGrid.reset();
                                        },
                             show: function( panel, eOpts ) {
                                orderNoSearch.setValue('DIV_CODE',panelSearch.getValue('DIV_CODE'));
                                orderNoSearch.setValue('CUSTOM_CODE',panelSearch.getValue('CUSTOM_CODE'));
                                orderNoSearch.setValue('CUSTOM_NAME',panelSearch.getValue('CUSTOM_NAME'));
                                orderNoSearch.setValue('REPORT_DATE_TO', UniDate.get('today'));
                                orderNoSearch.setValue('REPORT_DATE_FR', UniDate.get('startOfMonth', orderNoSearch.getValue('REPORT_DATE_TO')));
                             }
                }
            })
        }
        searchInfoWindow.center();
        searchInfoWindow.show();
    }
     // 수주이력 모델
    Unilite.defineModel('s_ten900ukrv_kdRefModel', {
        fields: [
                     { name: 'CUSTOM_CODE'          , text:'<t:message code="unilite.msg.sMS777" default="수주처"/>' ,type : 'string' }
                    ,{ name: 'CUSTOM_NAME'          , text:'<t:message code="unilite.msg.sMS777" default="수주처"/>' ,type : 'string' }
                    ,{ name: 'ORDER_DATE'           , text:'<t:message code="unilite.msg.sMS508" default="수주일"/>' ,type : 'string' }
                    ,{ name: 'ORDER_NUM'            , text:'<t:message code="unilite.msg.sMS533" default="수주번호"/>' ,type : 'string' }
                    ,{ name: 'SER_NO'               , text:'<t:message code="unilite.msg.sMSR003" default="순번"/>' ,type : 'int' }
                    ,{ name: 'ITEM_CODE'            , text:'<t:message code="unilite.msg.sMS501" default="품목코드"/>' ,type : 'string' }
                    ,{ name: 'ITEM_NAME'            , text:'<t:message code="unilite.msg.sMS688" default="품명"/>' ,type : 'string' }
                    ,{ name: 'SPEC'                 , text:'<t:message code="unilite.msg.sMSR033" default="규격"/>' ,type : 'string' }
                    ,{ name: 'ORDER_UNIT'           , text:'<t:message code="unilite.msg.sMS690" default="판매단위"/>' ,type : 'string' , comboType:'AU', comboCode:'B013', displayField: 'value'}
                    ,{ name: 'TRANS_RATE'           , text:'<t:message code="unilite.msg.sMSR010" default="입수"/>' ,type : 'uniQty' }
                    ,{ name: 'ORDER_Q'              , text:'<t:message code="unilite.msg.sMS543" default="수주량"/>' ,type : 'uniQty' }
                    ,{ name: 'ORDER_P'              , text:'개별단가'                    ,type : 'uniUnitPrice' }
                    ,{ name: 'ORDER_WGT_Q'          , text:'수주량(중량)'                 ,type : 'uniQty' }
                    ,{ name: 'ORDER_WGT_P'          , text:'단가(중량)'                  ,type : 'uniQty' }
                    ,{ name: 'ORDER_VOL_Q'          , text:'수주량(부피)'                 ,type : 'uniUnitPrice' }
                    ,{ name: 'ORDER_VOL_P'          , text:'단가(부피)'                  ,type : 'uniQty' }
                    ,{ name: 'ORDER_O'              , text:'<t:message code="unilite.msg.sMS681" default="금액"/>' ,type : 'uniPrice' }
                    ,{ name: 'ORDER_TAX_O'          , text:'ORDER_TAX_O'             ,type : 'uniPrice' }
                    ,{ name: 'TAX_TYPE'             , text:'TAX_TYPE'                ,type : 'string' }
                    ,{ name: 'DIV_CODE'             , text:'DIV_CODE'                ,type : 'string' }
                    ,{ name: 'OUT_DIV_CODE'         , text:'OUT_DIV_CODE'            ,type : 'string' }
                    ,{ name: 'ACCOUNT_YNC'          , text:'ACCOUNT_YNC'             ,type : 'string' }
                    ,{ name: 'SALE_CUST_CD'         , text:'SALE_CUST_CD'            ,type : 'string' }
                    ,{ name: 'SALE_CUST_NM'         , text:'SALE_CUST_NM'            ,type : 'string' }
                    ,{ name: 'PRICE_YN'             , text:'PRICE_YN'                ,type : 'string' }
                    ,{ name: 'STOCK_Q'              , text:'STOCK_Q'                 ,type : 'string' }
                    ,{ name: 'DVRY_CUST_CD'         , text:'DVRY_CUST_CD'            ,type : 'string' }
                    ,{ name: 'DVRY_CUST_NAME'       , text:'DVRY_CUST_NAME'          ,type : 'string' }
                    ,{ name: 'STOCK_UNIT'           , text:'STOCK_UNIT'              ,type : 'string' }
                    ,{ name: 'WH_CODE'              , text:'WH_CODE'                 ,type : 'string' }
                    ,{ name: 'STOCK_CARE_YN'        , text:'STOCK_CARE_YN'           ,type : 'string' }
                    ,{ name: 'DISCOUNT_RATE'        , text:'DISCOUNT_RATE'           ,type : 'string' }
                    ,{ name: 'ITEM_ACCOUNT'         , text:'ITEM_ACCOUNT'            ,type : 'string' }
                    ,{ name: 'PRICE_TYPE'           , text:'PRICE_TYPE'              ,type : 'string' }
                    ,{ name: 'WGT_UNIT'             , text:'WGT_UNIT'                ,type : 'string' }
                    ,{ name: 'UNIT_WGT'             , text:'UNIT_WGT'                ,type : 'string' }
                    ,{ name: 'VOL_UNIT'             , text:'VOL_UNIT'                ,type : 'string' }
                    ,{ name: 'UNIT_VOL'             , text:'UNIT_VOL'                ,type : 'string' }
                    ,{ name: 'SO_KIND'              , text:'SO_KIND'                 ,type : 'string' }
                    ,{ name: 'ITEM_P'              , text:'ITEM_P'                 ,type : 'string' }
                ]
    });
     // 수주이력 스토어
    var refStore = Unilite.createStore('s_ten900ukrv_kdRefStore', {
            model: 's_ten900ukrv_kdRefModel',
            autoLoad: false,
            uniOpt : {
                isMaster: false,            // 상위 버튼 연결
                editable: false,            // 수정 모드 사용
                deletable:false,            // 삭제 가능 여부
                useNavi : false         // prev | newxt 버튼 사용
            },
            proxy: {
                type: 'direct',
                api: {
                    read    : 's_ten900ukrv_kdService.selectRefList'

                }
            },
            listeners:{
                load:function(store, records, successful, eOpts)    {
                 /*       if(successful)  {
                           var masterRecords = detailStore.data.filterBy(detailStore.filterNewOnly);
                           var estiRecords = new Array();

                           if(masterRecords.items.length > 0)   {
                                console.log("store.items :", store.items);
                                console.log("records", records);

                                Ext.each(records,
                                    function(item, i)   {
                                        Ext.each(masterRecords.items, function(record, i)   {
                                            console.log("record :", record);

                                                if( (record.data['ORDER_NUM'] == item.data['ORDER_NUM'])
                                                        && (record.data['ESTI_SEQ'] == item.data['ESTI_SEQ'])
                                                  )
                                                {
                                                    estiRecords.push(item);
                                                }
                                        });
                                });
                               store.remove(estiRecords);
                           }
                        }*/
                }
            }
            ,loadStoreRecords : function()  {
                var param= refSearch.getValues();
                console.log( param );
                this.load({
                    params : param
                });
            }
    });
     //참조grid
     var refGrid = Unilite.createGrid('s_ten900ukrv_kdRefGrid', {
        // title: '기본',
        layout : 'fit',
        store: refStore,
        selModel :   Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }),
        uniOpt:{
            onLoadSelectFirst : false
        },
        columns:  [
                     { dataIndex: 'CUSTOM_CODE',  width: 50 , hidden:true}
                    ,{ dataIndex: 'CUSTOM_NAME',  width: 110 }
                    ,{ dataIndex: 'ORDER_DATE',  width: 80 }
                    ,{ dataIndex: 'ORDER_NUM',  width: 100 }
                    ,{ dataIndex: 'SER_NO',  width: 60 }
                    ,{ dataIndex: 'ITEM_CODE',  width: 00 }
                    ,{ dataIndex: 'ITEM_NAME',  width: 110 }
                    ,{ dataIndex: 'SPEC',  width: 130 }
                    ,{ dataIndex: 'ORDER_UNIT',  width: 80 , align: 'center'}
                    ,{ dataIndex: 'TRANS_RATE',  width: 60 }
                    ,{ dataIndex: 'ORDER_Q',  width: 90 }
                    ,{ dataIndex: 'ORDER_P',  width: 80 }
                    ,{ dataIndex: 'ORDER_WGT_Q',  width: 90 , borderColor:'red'}
                    ,{ dataIndex: 'ORDER_WGT_P',  width: 90 }
                    ,{ dataIndex: 'ORDER_VOL_Q',  width: 90 }
                    ,{ dataIndex: 'ORDER_VOL_P',  width: 90 }
                    ,{ dataIndex: 'ORDER_O',  width: 90 }
                    ,{ dataIndex: 'ORDER_TAX_O',  width: 50 , hidden:true}
                    ,{ dataIndex: 'TAX_TYPE',  width: 50 , hidden:true}
                    ,{ dataIndex: 'DIV_CODE',  width: 50 , hidden:true}
                    ,{ dataIndex: 'OUT_DIV_CODE',  width: 50 , hidden:true}
                    ,{ dataIndex: 'ACCOUNT_YNC',  width: 50 , hidden:true}
                    ,{ dataIndex: 'SALE_CUST_CD',  width: 50 , hidden:true}
                    ,{ dataIndex: 'SALE_CUST_NM',  width: 50 , hidden:true}
                    ,{ dataIndex: 'PRICE_YN',  width: 50 , hidden:true}
                    ,{ dataIndex: 'STOCK_Q',  width: 50 , hidden:true}
                    ,{ dataIndex: 'DVRY_CUST_CD',  width: 50 , hidden:true}
                    ,{ dataIndex: 'DVRY_CUST_NAME',  width: 50 , hidden:true}
                    ,{ dataIndex: 'STOCK_UNIT',  width: 50 , hidden:true}
                    ,{ dataIndex: 'WH_CODE',  width: 50 , hidden:true}
                    ,{ dataIndex: 'STOCK_CARE_YN',  width: 50 , hidden:true}
                    ,{ dataIndex: 'DISCOUNT_RATE',  width: 50 , hidden:true}
                    ,{ dataIndex: 'ITEM_ACCOUNT',  width: 50 , hidden:true}
                    ,{ dataIndex: 'PRICE_TYPE',  width: 50 , hidden:true}
                    ,{ dataIndex: 'WGT_UNIT',  width: 50 , hidden:true}
                    ,{ dataIndex: 'UNIT_WGT',  width: 50 , hidden:true}
                    ,{ dataIndex: 'VOL_UNIT',  width: 50 , hidden:true}
                    ,{ dataIndex: 'UNIT_VOL',  width: 50 , hidden:true}
                    ,{ dataIndex: 'SO_KIND',  width: 50 , hidden:true}
                    ,{ dataIndex: 'ITEM_P',  width: 50 , hidden:true}

          ]
       ,listeners: {
                onGridDblClick:function(grid, record, cellIndex, colName) {

                }
            }
        ,returnData: function(records) {
            var records = this.getSelectedRecords();
            Ext.each(records, function(record,i){
               	UniAppManager.app.onNewDataButtonDown();
                masterGrid.setRefData(record.data);
            });
          //  this.getStore().remove(records);
        }

    });
     var refSearch = Unilite.createSearchForm('RefSForm', {
            layout :  {type : 'uniTable', columns : 3},
            items :[    Unilite.popup('AGENT_CUST',{fieldLabel:'수주처' , validateBlank: false,
                        listeners:{
                            applyextparam: function(popup){
                                popup.setExtParam({'AGENT_CUST_FILTER':  ['1','3']});
                                popup.setExtParam({'CUSTOM_TYPE':  ['1','3']});
                            }
                        }})
                        ,Unilite.popup('DIV_PUMOK',{validateBlank: false, colspan:2,
                        listeners: {
                            applyextparam: function(popup){
                                popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
                            }
                        }})
                        ,{ fieldLabel: '수주일'
                           ,xtype: 'uniDateRangefield'
                           ,startFieldName: 'FR_ORDER_DATE'
                           ,endFieldName: 'TO_ORDER_DATE'
                           ,width: 350
                           ,startDate: UniDate.get('startOfMonth')
                           ,endDate: UniDate.get('today')
                         },{
                            fieldLabel: '<t:message code="unilite.msg.sMS573" default="영업담당"/>'     ,
                            name: 'ORDER_PRSN',
                            xtype:'uniCombobox',
                            comboType:'AU',
                            comboCode:'S010',
                            onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
                                if(eOpts){
                                    combo.filterByRefCode('refCode1', newValue, eOpts.parent);
                                }else{
                                    combo.divFilterByRefCode('refCode1', newValue, divCode);
                                }
                            }
                         },{fieldLabel: '최근이력'      , name: 'RDO_YN',   xtype:'uniRadiogroup', comboType:'AU', comboCode:'B131' , width:210, allowBlank:false, value:'Y'}
                    ]
    });
     function openRefWindow() {
        //if(!UniAppManager.app.checkForNewDetail()) return false;
//        var field = refSearch.getField('ORDER_PRSN');
//        field.fireEvent('changedivcode', field, panelSearch.getValue('DIV_CODE'), null, null, "DIV_CODE");
        refSearch.setValue('CUSTOM_CODE', panelSearch.getValue('CUSTOM_CODE'));
        refSearch.setValue('CUSTOM_NAME', panelSearch.getValue('CUSTOM_NAME'));

        refSearch.setValue('CUSTOM_CODE', panelResult.getValue('CUSTOM_CODE'));
        refSearch.setValue('CUSTOM_NAME', panelResult.getValue('CUSTOM_NAME'));


        if(!referOrderRecordWindow) {
            referOrderRecordWindow = Ext.create('widget.uniDetailWindow', {
                title: '수주이력참조',
                width: 1080,
                height: 580,
                layout:{type:'vbox', align:'stretch'},

                items: [refSearch, refGrid],
                tbar:  ['->',
                                        {   itemId : 'saveBtn',
                                            text: '조회',
                                            handler: function() {
                                                refStore.loadStoreRecords();
                                            },
                                            disabled: false
                                        },
                                        {   itemId : 'confirmBtn',
                                            text: '수주적용',
                                            handler: function() {
                                                refGrid.returnData();
                                            },
                                            disabled: false
                                        },
                                        {   itemId : 'confirmCloseBtn',
                                            text: '수주적용 후 닫기',
                                            handler: function() {
                                              var records = refGrid.getSelectedRecords();
                                              if(!Ext.isEmpty(records)){
                                              	  refGrid.returnData(records);
                                              	  Ext.getCmp('GW').setDisabled(false);
										          //UniAppManager.app.onQueryButtonDown();
										          referOrderRecordWindow.hide();
											   }

                                            },
                                            disabled: false
                                        },{
                                            itemId : 'closeBtn',
                                            text: '닫기',
                                            handler: function() {

                                                referOrderRecordWindow.hide();
                                            },
                                            disabled: false
                                        }
                                ]
                            ,
                listeners : {beforehide: function(me, eOpt) {
                                            // refSearch.clearForm();
                                            // refGrid.reset();
                                        },
                             beforeclose: function( panel, eOpts )  {
                                            // RefSearch.clearForm();
                                            // refGrid.reset();
                                        },
                              beforeshow: function ( me, eOpts )    {
                                refStore.loadStoreRecords();
                             }
                }
            })
        }
        referOrderRecordWindow.center();
        referOrderRecordWindow.show();
    }


	Unilite.Main( {
		border: false,
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult
			]
		},
			panelSearch
		],
		id: 's_ten900ukrv_kdApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('REPORT_DATE', UniDate.get('today'));
			panelSearch.setValue('MONEY_UNIT', 'KRW');
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
            panelResult.setValue('REPORT_DATE', UniDate.get('today'));
            panelSearch.setValue('EXCHG_RATE_O', '1');
            panelResult.setValue('EXCHG_RATE_O', '1');
            panelSearch.getField('REPORT_NO').setReadOnly(true);
            panelResult.getField('REPORT_NO').setReadOnly(true);
            Ext.getCmp('GW').setDisabled(true);

			UniAppManager.setToolbarButtons(['reset','newData'], true);
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('DIV_CODE');
		},
		onQueryButtonDown: function() {
//			if(!this.isValidSearchForm()){
//				return false;
//			}

            panelResult.setValue('GW_TEMP', '');
			var reportNo = panelSearch.getValue('REPORT_NO');
            if(Ext.isEmpty(reportNo)) {
                openSearchInfoWindow()
            } else {
            	if(Ext.isEmpty(panelResult.getValue('EXCHG_RATE_O'))){
            		alert('환율 필수합니다.');
            		return false;
            	}
            	directMasterStore1.loadStoreRecords();
            /* 
            	isLoad = true;
            	var detailform = panelSearch.getForm();
                if (detailform.isValid()) {
                    
                    panelSearch.getForm().getFields().each(function(field) {
                          field.setReadOnly(true);
                    });
                    panelResult.getForm().getFields().each(function(field) {
                          field.setReadOnly(true);
                    });
                    UniAppManager.setToolbarButtons('reset', true);
                }  *//* else {
                    var invalid = panelSearch.getForm().getFields().filterBy(function(field) {
                                return !field.validate();
                            });

                    if (invalid.length > 0) {
                        r = false;
                        var labelText = ''

                        if (Ext.isDefined(invalid.items[0]['fieldLabel'])) {
                            var labelText = invalid.items[0]['fieldLabel'] + '은(는)';
                        } else if (Ext.isDefined(invalid.items[0].ownerCt)) {
                            var labelText = invalid.items[0].ownerCt['fieldLabel'] + '은(는)';
                        }
                        Ext.Msg.alert('확인', labelText + Msg.sMB083);
                        invalid.items[0].focus();
                    }
                } */
            }
		},
		onDetailButtonDown: function() {
			var as = Ext.getCmp('AdvanceSerch');
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		},
		onNewDataButtonDown : function() {
			if(!this.isValidSearchForm()){
				return false;
			}
			var param = panelResult.getValues();
				masterGrid.createRow(param);
				panelSearch.getForm().getFields().each(function(field) {
  			      field.setReadOnly(true);
  				});
				panelResult.getForm().getFields().each(function(field) {
	  			      field.setReadOnly(true);
	  			});
           // s_ttr900ukrv_kdService.selectGwData(param, function(provider, response) {
          //      if(Ext.isEmpty(provider[0]) || provider[0].GW_FLAG != '1' || provider[0].GW_FLAG != '3') {
       	//		panelSearch.getForm().getFields().each(function(field) {
        //			      field.setReadOnly(false);
        //			});
        //			panelResult.getForm().getFields().each(function(field) {
        //			      field.setReadOnly(false);
       // 			});
       	//		var seq = directMasterStore1.max('REPORT_SEQ');
         //               if(!seq) seq = 1;
         //               else  seq += 1;
        //			var record = {
        //				DIV_CODE: panelSearch.getValue('DIV_CODE'),
        	//			REPORT_SEQ: seq
        //			};
 //       			masterGrid.createRow(record, 'PERSON_NUMB');
//        //			UniAppManager.setToolbarButtons('delete', true);
//        //			UniAppManager.setToolbarButtons('save', true);
       //        } else {
       //             alert('이미 기안된 자료입니다.');
       //             return false;
      //          }
    //        })


        },
		onSaveDataButtonDown : function() {
			masterGrid.getStore().saveStore();
		},
		onDeleteDataButtonDown : function()	{
			var param = panelResult.getValues();
            if(!Ext.isEmpty(param.REPORT_NO)) {
                s_ttr900ukrv_kdService.selectGwData(param, function(provider, response) {
                    if(Ext.isEmpty(provider[0]) || provider[0].GW_FLAG != '1' || provider[0].GW_FLAG != '3') {
                        var record = masterGrid.getSelectedRecord();
                        if(record.get('GW_FLAG') == 'Y') {
                            alert('기안된 데이터는 삭제가 불가능합니다.');
                            return false;
                        } else {
                			var selRow = masterGrid.getSelectedRecord();
                			if(selRow.phantom === true)	{
                				masterGrid.deleteSelectedRow();
                			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
                				masterGrid.deleteSelectedRow();
                			}
                        }
                    } else {
                        alert('기안된 데이터는 삭제가 불가능합니다.');
                        return false;
                    }
                })
            } else {
                var selRow = masterGrid.getSelectedRecord();
                if(selRow.phantom === true) {
                    masterGrid.deleteSelectedRow();
                }else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
                    masterGrid.deleteSelectedRow();
                }
            }
        },
		onResetButtonDown : function() {
			panelSearch.getForm().getFields().each(function(field) {
			      field.setReadOnly(false);
			});
			panelResult.getForm().getFields().each(function(field) {
			      field.setReadOnly(false);
			});
			panelSearch.clearForm();
			panelResult.clearForm();
			Ext.getCmp('GW').setDisabled(true);
			masterGrid.getStore().loadData({});
			this.fnInitBinding();
		},
		 fnExchngRateO:function(isIni) {  // 화폐/환율
	            var param = {
	                "AC_DATE"    : UniDate.getDbDateStr(panelResult.getValue('REPORT_DATE')),
	                "MONEY_UNIT" : panelResult.getValue('MONEY_UNIT')
	            };
	            salesCommonService.fnExchgRateO(param, function(provider, response) {
	                if(!Ext.isEmpty(provider)){

	                    if(!loadData && provider.BASE_EXCHG == "1" && !isIni && !Ext.isEmpty(panelResult.getValue('MONEY_UNIT')) && panelResult.getValue('MONEY_UNIT') != "KRW"){
	                        alert('환율정보가 없습니다.');
	                    }
	                    if(!isLoad){
	                    	panelSearch.setValue('EXCHG_RATE_O', provider.BASE_EXCHG);
	                        panelResult.setValue('EXCHG_RATE_O', provider.BASE_EXCHG);
	                    }
	                }
	            });
	     },
        requestApprove: function(){     //결재 요청
            var gsWin = window.open('about:blank','payviewer','width=500,height=500');

            var frm         = document.f1;
            var compCode    = UserInfo.compCode;
            var divCode     = panelResult.getValue('DIV_CODE');
            var reportNo    = panelResult.getValue('REPORT_NO');
            var spText      = 'EXEC omegaplus_kdg.unilite.USP_GW_S_Ten900UKRV_KD ' + "'" + compCode + "'" + ', ' + "'" + divCode + "'" + ', ' + "'" + reportNo + "'";
            var spCall      = encodeURIComponent(spText);

//            frm.action = '/payment/payreq.php';
//            frm.action   = groupUrl + "viewMode=docuDraft" + "&prg_no=s_ten900ukrv_kd&draft_no=" + '0' + "&sp=" + spCall/* + Base64.encode()*/;
//            frm.target   = "payviewer";
//            frm.method   = "post";
//            frm.submit();
            var gwurl = groupUrl + "viewMode=docuDraft" + "&prg_no=s_ten900ukrv_kd&draft_no=" + '0' + "&sp=" + spCall/* + Base64.encode()*/;

            UniBase.fnGw_Call(gwurl,frm,'GW'); /*end*/

        }
//        checkForNewDetail:function() {
//            if(BsaCodeInfo.gsAutoType=='N' && Ext.isEmpty(masterForm.getValue('ORDER_NUM')))    {
//                alert('<t:message code="unilite.msg.sMS533" default="수주번호"/>:<t:message code="unilite.msg.sMB083" default="필수입력값입니다."/>');
//                return false;
//            }
//
//            /**
//			 * 여신한도 확인
//			 */
//            if(!masterForm.fnCreditCheck()) {
//                return false;
//            }
//
//            /**
//			 * 마스터 데이타 수정 못 하도록 설정
//			 */
//            panelResult.setAllFieldsReadOnly(true);
//            return masterForm.setAllFieldsReadOnly(true);
//        }
	});

	 /**
     * Validation
     */
    Unilite.createValidator('validator01', {
        store: directMasterStore1,
        grid: masterGrid,
        validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
            if(newValue == oldValue){
                return false;
            }
            var rv = true;
            switch(fieldName) {
                case "SALE_Q" : //수량 수정시
                    var rec = e.record;
                    var exchRate    = panelResult.getValue('EXCHG_RATE_O');
                    rec.set('AMT_SALE', rec.get('NEGO_SALE_P') * newValue);      //금액
                    rec.set('NEGO_SALE_LOC_P', rec.get('AMT_SALE') * exchRate);      //금액
                    rec.set('NEGO_DIFF', rec.get('AMT_SALE') - (rec.get('TRADE_SALE_P') * newValue));     //네고차액

                    if( rec.get('NEGO_SALE_P') == 0){
                    	rec.set('P_RATE', 0);        //단가율
                    }else{
                    	rec.set('P_RATE', (1 - (rec.get('TRADE_SALE_P') / rec.get('NEGO_SALE_P'))) * 100);        //단가율
                    }

                    break;
            }
            return rv;
        }
    }); // validator
};


</script>

<form id="f1" name="f1" action="" method="post" onSubmit="return false;" >
<input type="hidden" id="loginid" name="loginid" value="superadmin" />
<input type="hidden" id="fmpf" name="fmpf" value="" />
<input type="hidden" id="fmbd" name="fmbd" runat="server" />
</form>
