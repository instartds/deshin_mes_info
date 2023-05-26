<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_ttr900ukrv_kd"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B004" /> <!-- 화폐단위 -->
	<t:ExtComboStore comboType="AU" comboCode="B013" /> <!-- 판매단위 -->
	<t:ExtComboStore comboType="AU" comboCode="WS01" /> <!-- 판매종류 -->
	<t:ExtComboStore comboType="AU" comboCode="WS02" /> <!-- 단가구성 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >



var isLoad = false; //로딩 플래그 화폐단위 환율 change 로드시 계속 타므로 임시로 막음
var loadData = false;

function appMain() {
    var groupUrl = '${groupUrl}'; //그룹웨어 호출 url
	var searchInfoWindow;  //검색창
	/**
	 *   Model 정의
	 * @type
	 */
	Unilite.defineModel('S_ttr900ukrv_kdModel', {
		fields: [
			{name: 'DIV_CODE'                 , text: '사업장'                  , type: 'string', comboType:'BOR120'},
            {name: 'REPORT_NO'                , text: '보고번호'                , type: 'string'},
            {name: 'REPORT_SEQ'               , text: '순번'                    , type: 'int'},
            {name: 'ITEM_CODE'                , text: '품목코드'                , type: 'string' , allowBlank: false },
            {name: 'ITEM_ACCOUNT'             , text: '품목계정'                , type: 'string'},
            {name: 'ITEM_CODE_OLD'            , text: '품목코드_OLD'            , type: 'string'},
            {name: 'CAR_TYPE'                 , text: '차종코드'                , type: 'string'},
            {name: 'CAR_TYPE_NAME',         text: '차종명',        type : 'string'},
            {name: 'ITEM_NAME'                , text: '품명'                    , type: 'string'},
            {name: 'SPEC'                     , text: '규격'                    , type: 'string'},
            {name: 'OEM_ITEM_CODE'            , text: '품번'                    , type: 'string'}, //품번추가
            {name: 'ORDER_UNIT'               , text: '판매단위'                , type: 'string', comboType:'AU',comboCode:'B013', displayField: 'value'},
            {name: 'OEM_P'                    , text: 'OEM단가'                 , type: 'uniUnitPrice'},
            {name: 'PUR_P'                    , text: '외주구매가'              , type: 'uniUnitPrice'},
//            {name: 'PROFIT_RATE'              , text: '40%'                   , type: 'int'},
            {name: 'PROFIT_RATE'              , text: '40%'                     , type: 'float', decimalPrecision:2 ,format:'0,000.00'},
            {name: 'LOCAL_APPL_P'             , text: 'Local적용단가'           , type: 'uniUnitPrice'},
            {name: 'BASIC_FOR_P'              , text: '기준외화단가'            , type: 'uniUnitPrice'},
//            {name: 'FOB_FOR_P'                , text: '외화단가'                , type: 'uniUnitPrice'},
            {name: 'FOB_P'                    , text: '자사단가'                , type: 'uniUnitPrice'}, // , allowBlank: false , defaultValue: 0},
            {name: 'LAST_NEGO_FOR_P'          , text: '최종외화단가'            , type: 'uniUnitPrice'},
            {name: 'LAST_NEGO_P'              , text: '최종자사단가'            , type: 'uniUnitPrice'},
            {name: 'NEGO_RATE'                , text: 'Nego%'                   , type: 'float', decimalPrecision:2 ,format:'0,000.00'},

            {name: 'REMARK'                   , text: '비고'                    , type: 'string'},
            {name: 'GW_FLAG'                  , text: '기안여부'                , type: 'string' ,comboType:'AU', comboCode:'WB17'},
            {name: 'GW_DOC'                   , text: '기안문서'                , type: 'string'},
            {name: 'DRAFT_NO'                 , text: '결재번호'                , type: 'string'}
		]
	});

	/**
	 * Store 정의(Service 정의)
	 * @type
	 */
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			create: 's_ttr900ukrv_kdService.insertList',
			read: 's_ttr900ukrv_kdService.selectList',
			update: 's_ttr900ukrv_kdService.updateList',
			destroy: 's_ttr900ukrv_kdService.deleteList',
			syncAll: 's_ttr900ukrv_kdService.saveAll'
		}
	});
   /**
     * Store 정의(Combobox)
     * @type
     */

	var directMasterStore1 = Unilite.createStore('s_ttr900ukrv_kdMasterStore1', {
		model: 'S_ttr900ukrv_kdModel',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결
			editable: true,			// 수정 모드 사용
			deletable: true,		// 삭제 가능 여부
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
                    		Ext.getCmp('GW2').setDisabled(true);
                    	}else if(masterGrid.getStore().getCount() != 0){
                    	  var gwFlag = directMasterStore1.data.items[0].data.GW_FLAG;
                    		UniBase.fnGwBtnControl('GW', gwFlag);
                    		if (gwFlag == '3')
                    		{
                      		Ext.getCmp('GW2').setDisabled(false);
                      	}
                      	else
                      	{
                      		Ext.getCmp('GW2').setDisabled(true);
                      	}
                    	}
                    }
				}

			});
		},
        saveStore : function()	{
        	var paramMaster = panelResult.getValues();
			var inValidRecs = this.getInvalidRecords();
			if(Ext.isEmpty(panelResult.getField('EXCHG_RATE_O')) || Ext.isEmpty(panelSearch.getField('EXCHG_RATE_O')) ){
				panelSearch.setValue("EXCHG_RATE_O", '1');
                panelResult.setValue("EXCHG_RATE_O", '1');
			};
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
//                    Ext.getCmp('GW2').setDisabled(true);
//                } else if(masterGrid.getStore().getCount() != 0) {
//                    Ext.getCmp('GW').setDisabled(false);
//                    Ext.getCmp('GW2').setDisabled(false);
//                } else {
//                    if(directMasterStore1.data.items[0].data.GW_FLAG == 'Y') {
//                        UniAppManager.setToolbarButtons(['save', 'newData', 'delete'], false);
//                    } else {
//                        UniAppManager.setToolbarButtons(['save', 'newData', 'delete'], true);
//                    }
//                }
            }
        }
	});//End of var directMasterStore1 = Unilite.createStore('s_ttr900ukrv_kdMasterStore1', {


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
                allowBlank: false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('DIV_CODE', newValue);
                    }
                }
            },{
                fieldLabel: '판매종류'  ,
                name: 'SALES_KIND',
                xtype:'uniCombobox',
                comboType:'AU',
                comboCode: 'WS01',
                value: '1', //1-국내용, 2-국외용
                listeners: {
                    change: function(combo, newValue, oldValue, eOpts) {
                    	panelResult.setValue('SALES_KIND', newValue);
                    }
                }
            },{
                fieldLabel: '보고번호',
                xtype:'uniTextfield',
                name: 'REPORT_NO',
                readOnly: true
            },{
                fieldLabel: '적용일자',
                xtype: 'uniDatefield',
                name: 'APPLY_DATE',
                allowBlank: false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('APPLY_DATE', newValue);
                    }
                }
            }/*,{
                fieldLabel: 'FOB가격비율',
                xtype: 'uniNumberfield',
                name: 'FOB_P_RATE',
                value:  0 ,
                suffixTpl: '%',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('FOB_P_RATE', newValue);
                        panelSearch.setValue('CIF_P_RATE', '0'); // FOB가격비율 입력시 CIF가격비율 0 으로 고정
                        panelResult.setValue('CIF_P_RATE', '0'); // FOB가격비율 입력시 CIF가격비율 0 으로 고정
                    }
                }
            }*/,
//                Unilite.popup('CUST',{  //거래처
                Unilite.popup('AGENT_CUST',{  //거래처
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
                fieldLabel: '유효기간',
                xtype: 'uniNumberfield',
                name: 'APPLY_DAYS',
                value: '1', //기본값추가
                suffixTpl: '일',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('APPLY_DAYS', newValue);
                    }
                }
            }/*,{
                fieldLabel: 'CIF가격비율',
                xtype: 'uniNumberfield',
                name: 'CIF_P_RATE',
                value: 0 ,
                suffixTpl: '%',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('CIF_P_RATE', newValue);
                        panelSearch.setValue('FOB_P_RATE', '0'); // CIF가격비율 입력시 FOB가격비율 0 으로 고정
                        panelResult.setValue('FOB_P_RATE', '0'); // CIF가격비율 입력시 FOB가격비율 0 으로 고정
                    }

                }
            }*/,{
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
                            panelResult.setValue('EXCHG_RATE_O', newValue);
                            panelSearch.setValue('EXCHG_RATE_O', newValue);
                        }
                    }
                }]
            },{
                fieldLabel: '단가구성'  ,
                name: 'PRICE_KIND',
                xtype:'uniCombobox',
                comboType:'AU',
                comboCode: 'WS02',
                readOnly: true,
                value: '2', //1-구매단가, 2-판매단가
                listeners: {
                    change: function(combo, newValue, oldValue, eOpts) {
                    	panelResult.setValue('PRICE_KIND', newValue);

                    }
                }
            }]
		}]
	});//End of var panelSearch = Unilite.createSearchForm('searchForm', {

	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
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
        },{
            fieldLabel: '판매종류'  ,
            name: 'SALES_KIND',
            xtype:'uniCombobox',
            comboType:'AU',
            comboCode: 'WS01',
            value: '1', //1-국내용, 2-국외용
            colspan: 1,
            listeners: {
                change: function(combo, newValue, oldValue, eOpts) {
                    panelSearch.setValue('SALES_KIND', newValue);
                }
            }
        },{
            fieldLabel: '보고번호',
            xtype:'uniTextfield',
            name: 'REPORT_NO',
            readOnly: true
        }/*,{
            fieldLabel: 'FOB가격비율',
            xtype: 'uniNumberfield',
            suffixTpl: '%',
            value:  0 ,
            name: 'FOB_P_RATE',
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.setValue('FOB_P_RATE', newValue);
                    panelResult.setValue('CIF_P_RATE', '0');// FOB가격비율 입력시 CIF가격비율 0 으로 고정
                    panelSearch.setValue('CIF_P_RATE', '0');// FOB가격비율 입력시 CIF가격비율 0 으로 고정
                }
            }
        }*/,
//            Unilite.popup('CUST',{
            Unilite.popup('AGENT_CUST',{
            validateBlank: false,
            allowBlank: false,
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
                xtype: 'uniCombobox',
                name: 'MONEY_UNIT',
                comboType: 'AU',
                comboCode: 'B004',
                value: 'KRW',
                displayField: 'value',
                allowBlank: false,
                width: 174,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelSearch.setValue('MONEY_UNIT', newValue);
/*                         if(isLoad){
                            isLoad = false;
                        }else{
                        	UniAppManager.app.fnExchngRateO();
                        	loadData = false;
                        }
 */                    }
                }
            },{
                fieldLabel: '환율',
                hideLabel: true,
                xtype:'uniNumberfield',
                name: 'EXCHG_RATE_O',
                decimalPrecision: 4,
                allowBlank: false,
                value: '1',
                width: 70,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelSearch.setValue('EXCHG_RATE_O', newValue);
                        panelResult.setValue('EXCHG_RATE_O', newValue);                        
                    }
                }
            }]
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
        },
        Unilite.popup('Employee',
        		{
            fieldLabel: '담당자',
            valueFieldName:'PERSON_NUMB',
            textFieldName:'NAME',
            //validateBlank:false,
            allowBlank: false,            
            autoPopup:true
        }),{
            fieldLabel: '적용일자',
            xtype: 'uniDatefield',
            name: 'APPLY_DATE',
            allowBlank: false,
            colspan: 1,
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.setValue('APPLY_DATE', newValue);
                }
            }
        },{
            fieldLabel: '유효기간',
            xtype: 'uniNumberfield',
            name: 'APPLY_DAYS',
            value: '1', //기본값추가
            suffixTpl: '일',
            colspan: 2,
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.setValue('APPLY_DAYS', newValue);
                }
            }
        }/*,{
            fieldLabel: 'CIF가격비율',
            xtype: 'uniNumberfield',
            name: 'CIF_P_RATE',
            value:  0 ,
            suffixTpl: '%',
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.setValue('CIF_P_RATE', newValue);
                    panelResult.setValue('FOB_P_RATE', '0');// CIF가격비율 입력시 FOB가격비율 0 으로 고정
                    panelSearch.setValue('FOB_P_RATE', '0');// CIF가격비율 입력시 FOB가격비율 0 으로 고정
                }
            }
        }*/,{
            fieldLabel: '단가구성',
            name: 'PRICE_KIND',
            xtype: 'uniCombobox',
            comboType: 'AU',
            comboCode: 'WS02',
            readOnly: true,
            hidden:true,
            value: '2', //1-구매단가, 2-판매단가
            listeners: {
                change: function(combo, newValue, oldValue, eOpts) {
                    panelSearch.setValue('PRICE_KIND', newValue);

                }
            }
        },{
            fieldLabel: '기안여부TEMP',
            name:'GW_TEMP',
            xtype: 'uniTextfield',
            hidden: true
        }]
    });

    /**
     * Master Grid1 정의(Grid Panel)
     * @type
     */
	var masterGrid = Unilite.createGrid('s_ttr900ukrv_kdGrid1', {
    	// for tab
		layout: 'fit',
		region: 'center',
    	uniOpt: {
    		expandLastColumn: false,
		 	useRowNumberer: true,
		 	copiedRow: true,
            onLoadSelectFirst: true
//		 	useContextMenu: true,
        },
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
                itemId : 'GWBtn',
                id:'GW',
                iconCls : 'icon-referance'  ,
                text:'기안',
                handler: function() {
                    var param = panelResult.getValues();
                    param.DRAFT_NO = UserInfo.compCode + panelResult.getValue('REPORT_NO');
                    if(confirm('기안 하시겠습니까?')) {
                        s_ttr900ukrv_kdService.selectGwData(param, function(provider, response) {
                            if(Ext.isEmpty(provider[0]) || provider[0].GW_FLAG != '1' || provider[0].GW_FLAG != '3') {
                                panelResult.setValue('GW_TEMP', '기안중');
                                s_ttr900ukrv_kdService.makeDraftNum(param, function(provider2, response)   {
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
            },{
                itemId : 'GWBtn2',
                id:'GW2',
                iconCls : 'icon-referance'  ,
                text:'기안뷰',
                handler: function() {
                    var param = panelResult.getValues();
                    param.DRAFT_NO = UserInfo.compCode + panelResult.getValue('REPORT_NO');
                    record = masterGrid.getSelectedRecord();
                    s_ttr900ukrv_kdService.selectDraftNo(param, function(provider, response) {
                        if(Ext.isEmpty(provider[0])) {
                            alert('draft No가 없습니다.');
                            return false;
                        } else {
                            UniAppManager.app.requestApprove2(record);
                        }
                    });
                    UniAppManager.app.onQueryButtonDown();
                }
            }
        ],
		columns: [
            {dataIndex: 'DIV_CODE'     		    , width: 100, hidden: true},                  //사업장
            {dataIndex: 'REPORT_NO'             , width: 100, hidden: true},    //보고번호
            {dataIndex: 'REPORT_SEQ'             , width: 80, hidden: true},
            {dataIndex: 'ITEM_CODE'             , width: 100,                   //품목코드
                editor: Unilite.popup('DIV_PUMOK_G', {                             //품목코드 팝업
                    textFieldName: 'ITEM_CODE',
                    DBtextFieldName: 'ITEM_CODE',
					autoPopup: true,
                    listeners: {
                        'onSelected': {
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
                            masterGrid.setItemData(null,true, masterGrid.uniOpt.currentRecord);
                        },
                        applyextparam: function(popup){ //팝업열때 팝업에 기존데이터를 가져오는것
                            popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
                            popup.setExtParam({'ITEM_ACCOUNT_FILTER': ['00','10']});
                        }
                    }
                })
            },
            {dataIndex: 'ITEM_ACCOUNT'              , width: 100, hidden: true},
            {dataIndex: 'ITEM_CODE_OLD'             , width: 100, hidden: true},                   //품목코드//////////////////////
            {dataIndex: 'CAR_TYPE'                  , width: 120},       //차종코드
            {dataIndex: 'CAR_TYPE_NAME'                  , width: 120},
            {dataIndex: 'ITEM_NAME'                 , width: 150},       //품명
            {dataIndex: 'SPEC'                      , width: 100},       //규격
            {dataIndex: 'OEM_ITEM_CODE'             , width: 100},       //품번 - 20170717추가
            {dataIndex: 'ORDER_UNIT'                , width: 100, align: 'center'},       //판매단위
            {dataIndex: 'OEM_P'                     , width: 100},       //외주구매가  - 품목코드/품목명 입력시 조회되는값(상품 구입가 /type: 1(구매))
            {dataIndex: 'PUR_P'                     , width: 100},       //외주구매가  - 품목코드/품목명 입력시 조회되는값(상품 구입가 /type: 1(구매))
            {dataIndex: 'PROFIT_RATE'               , width: 100},       //40%(마진율) = ((Local적용단가/외주구매가)-1)*100
            {dataIndex: 'LOCAL_APPL_P'              , width: 110},       //Local적용단가   - 품목코드/품목명 입력시 조회되는값(거래처 13199)
            {dataIndex: 'BASIC_FOR_P'               , width: 100},       //기준가외화단가 - 품목코드/품목명 입력시 조회되는값(입력받은 거래처)
//            {dataIndex: 'FOB_FOR_P'                 , width: 100},       //외화단가    = Local적용단가 + (FOB가격비율 + CIF가격비율)* Local적용단가
            {dataIndex: 'FOB_P'                     , width: 100, hidden: true},       //자산단가    = 외화단가 * 환율
            {dataIndex: 'LAST_NEGO_FOR_P'           , width: 100},       //최종외화단가 ( text 입력받음)
            {dataIndex: 'LAST_NEGO_P'               , width: 100},       //최종자사단가 = 최종외화단가 * 환율
            {dataIndex: 'NEGO_RATE'                 , width: 100},       //Nego% = 100 - (자사단가/최종자사단가)*100
            {dataIndex: 'REMARK'                    , width: 100},
            {dataIndex: 'GW_FLAG'                   , width: 100},
            {dataIndex: 'GW_DOC'                    , width: 100},
            {dataIndex: 'DRAFT_NO'                  , width: 100}
		],
		setItemData: function(record, dataClear, grdRecord) {
              var grdRecord = this.uniOpt.currentRecord;
            if(dataClear) {
                grdRecord.set('ITEM_CODE'           ,"");
                grdRecord.set('ITEM_NAME'           ,"");
                grdRecord.set('ITEM_ACCOUNT'        ,"");
                grdRecord.set('CAR_TYPE'            ,"");//차종코드 추가
                grdRecord.set('CAR_TYPE_NAME'            ,"");//차종코드 추가
                grdRecord.set('SPEC'                ,"");
                grdRecord.set('OEM_ITEM_CODE'       ,""); //품번 - 20170717추가
                grdRecord.set('ORDER_UNIT'          ,"");

                grdRecord.set('PUR_P'           ,0);
                grdRecord.set('PROFIT_RATE'         ,0); ///
                grdRecord.set('LOCAL_APPL_P'        ,0);
                grdRecord.set('BASIC_FOR_P'         ,0);
//                grdRecord.set('FOB_FOR_P'           ,0);
                grdRecord.set('FOB_P'               ,0);
                grdRecord.set('LAST_NEGO_FOR_P'     ,0);
                grdRecord.set('LAST_NEGO_P'         ,0);
                grdRecord.set('NEGO_RATE'           ,0); ///

            } else {
                grdRecord.set('ITEM_CODE'           , record['ITEM_CODE']);
                grdRecord.set('ITEM_NAME'           , record['ITEM_NAME']);
                grdRecord.set('ITEM_ACCOUNT'        , record['ITEM_ACCOUNT']);
                grdRecord.set('CAR_TYPE'            , record['CAR_TYPE']); // 차종코드 추가
                grdRecord.set('SPEC'                , record['SPEC']);
                grdRecord.set('OEM_ITEM_CODE'       , record['OEM_ITEM_CODE']); //품번 - 20170717추가
                grdRecord.set('ORDER_UNIT'          , record['SALE_UNIT']);

                //CAR_TYPE_NAME추가
                var param_t = {CAR_TYPE : record['CAR_TYPE']}
                s_ttr900ukrv_kdService.selectCarName( param_t, function(provider3, response3){
                	grdRecord.set('CAR_TYPE_NAME', provider3[0].CAR_TYPE_NAME);
                });

                // LOCAL_APPL_P(Local적용단가)
                var param = {
                	DIV_CODE: record['DIV_CODE'],
                    ITEM_CODE: record['ITEM_CODE'],
                    ITEM_ACCOUNT: record['ITEM_ACCOUNT'],
                    ORDER_UNIT: record['ORDER_UNIT'],
                    APPLY_DATE: UniDate.getDbDateStr(panelSearch.getValue('REPORT_DATE'))
                }
                s_ttr900ukrv_kdService.getSalePrice(param, function(provider, response) {
                	s_ttr900ukrv_kdService.getSalePrice_basis(param, function(provider2, response2) {
                		if(!Ext.isEmpty(provider)){
                            grdRecord.set('LOCAL_APPL_P', provider.ITEM_P);//수출LOCAL판가 SET
                            grdRecord.set('OEM_P', provider2.OEM_P1);  //OEM 판가 SET
                        } else {
                        	grdRecord.set('LOCAL_APPL_P', 0);//수출LOCAL판가 SET
                        }

                        if(!Ext.isEmpty(provider2)){
                        	    grdRecord.set('PUR_P', provider2.OEM_P1);//외주구매가 set
                        	if(record['ITEM_ACCOUNT'] == '00') {
                        		grdRecord.set('PUR_P', provider2.PUR_P1);//외주구매가 set
                        	}else{
                        		grdRecord.set('PUR_P', 0);//외주구매가 set
                        	}
                        } else {
                        	grdRecord.set('PUR_P', 0);//외주구매가 set

                        }
                        if(!Ext.isEmpty(provider2)){
                        	if(record['ITEM_ACCOUNT'] == '00'){
                        		 // 40%(마진율)(품목계정이 '상품'일떄)
                        		 grdRecord.set('PROFIT_RATE' , Math.round(((grdRecord.get('LOCAL_APPL_P') / grdRecord.get('PUR_P') -1) * 100))); // 40%필드 = (Local적용가  / 외주구매가 -1) * 100
                        	}else if(record['ITEM_ACCOUNT'] == '10'){
                        		// 40%(마진율) (품목계정이 '제품'일떄)
                        		 grdRecord.set('PROFIT_RATE' , Math.round(((grdRecord.get('LOCAL_APPL_P') / grdRecord.get('OEM_P') -1) * 100))); // 40%필드 = (Local적용가  / OEM단가 -1) * 100
                        	}
                        	else{
                        		grdRecord.set('PROFIT_RATE', 0);
                        	}
                        } else{
                        	grdRecord.set('PROFIT_RATE', 0);
                        }



                        var localApplP  = grdRecord.get('LOCAL_APPL_P');    //LOCAL적용단가
                        var exchRate    = panelResult.getValue('EXCHG_RATE_O');
                        var lastNegoP   = grdRecord.get('LAST_NEGO_FOR_P'); //최종외화단가
                        var basicForP   = grdRecord.get('BASIC_FOR_P');     //기준외화단가
                        var negoRate    = 0;

                        // 기준외화단가
                        grdRecord.set('BASIC_FOR_P', localApplP / exchRate); //  Local적용단가 /환율
                        // 자사단가    = 기준외화단가 * 환율
                        grdRecord.set('FOB_P', basicForP * exchRate);

                        // 네고율 NEGO% = (최종외화단가-기준외화단가)/기준외화단가*100
                        if (basicForP > 0)
                        {
                          negoRate = (lastNegoP - basicForP) / basicForP * 100;
                        }
                        grdRecord.set('NEGO_RATE', negoRate);    // (최종네고자사가 - Local적용가)/Local적용가 *100


                        //외화단가    = Local적용단가 + (FOB가격비율 + CIF가격비율)* Local적용단가
//                        grdRecord.set('FOB_FOR_P', provider.ITEM_P + ((panelResult.getValue('FOB_P_RATE') + panelResult.getValue('CIF_P_RATE')) * provider.ITEM_P)/100);
                        //자산단가    = 외화단가 * 환율
//                        grdRecord.set('FOB_P', ( provider.ITEM_P + ((panelResult.getValue('FOB_P_RATE') + panelResult.getValue('CIF_P_RATE')) * provider.ITEM_P)/100) * panelResult.getValue('EXCHG_RATE_O'));

                     });

                });

                // BASIC_FOR_P //기준가외화단가 - 품목코드/품목명 입력시 조회되는값(입력받은 거래처)
//                param = {
//                    ITEM_CODE: record['ITEM_CODE'],
//                    CUSTOM_CODE: panelSearch.getValue('CUSTOM_CODE'),
//                    ORDER_UNIT: record['ORDER_UNIT'],
//                    REPORT_DATE: UniDate.getDbDateStr(panelSearch.getValue('REPORT_DATE'))
//                }
//                s_ttr900ukrv_kdService.getSalePrice(param, function(provider, response){
//                    if(!Ext.isEmpty(provider)){
//                         grdRecord.set('BASIC_FOR_P', provider.ITEM_P);//기준외화단가
//                    }
//                });


            }
        },
        listeners: {
          	beforeedit: function(editor, e) { //그리드상에 필드 수정 가능 여부 설정
          		if(e.record.phantom){ //행추가 버튼을 눌렀을때 생긴 행에 대한 설정(신규데이터)
          		    if (!UniUtils.indexOf(e.field, ['ITEM_CODE','LAST_NEGO_FOR_P','REMARK' ])){
                        return false;
                    }
          		}else{ // 조회했을때 설정(기존데이터)
          			var mstRecord = masterGrid.getSelectedRecord(); //선택한 행의 레코드
//                    if(e.record.get('GW_FLAG') != 'N' && e.record.get('GW_FLAG') != '2') { //GW_Flag가 기안전(N), 반려(2)일때 수정가능
                    if(mstRecord.get('GW_FLAG') != 'N' && mstRecord.get('GW_FLAG') != '2') { //GW_Flag가 기안전(N), 반려(2)일때 수정가능
                        return false;
                    } else {
                    	if(!UniUtils.indexOf(e.field, ['ITEM_CODE','LAST_NEGO_FOR_P','REMARK' ])){
                            return false;
                        }else {
                            return true;
                        }
                    }

          		}

          	},
          	edit: function(editor, e) {

          	}
//          	,
//            specialkey: function(elm, e){
//                if (e.getKey() == e.TAB) {
//                    masterGrid.getSelectedRecord().getField('ITEM_CODE').focus();
//                }
//            }
        }
	});//End of var masterGrid = Unilite.createGr100id('s_ttr900ukrv_kdGrid1', {

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
                 {name: 'EXCHG_RATE_O'                 , text: '환율'                , type: 'string'},
                 {name: 'SALES_KIND'                   , text: '판매종류'             , type: 'string'},
                 {name: 'APPLY_DATE'                   , text: '적용일자'             , type: 'uniDate'},
                 {name: 'APPLY_DAYS'                   , text: '유효기간'             , type: 'string'},
                 {name: 'FOB_P_RATE'                   , text: 'FOB가격비율'          , type: 'uniPercent'},
//                 {name: 'CIF_P_RATE'                   , text: 'CIF가격비율'          , type: 'uniPercent'},
                 {name: 'PRICE_KIND'                   , text: '단가구성'             , type: 'string'}
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
                useNavi : false             // prev | newxt 버튼 사용
            },
            proxy: {
                type: 'direct',
                api: {
                    read    : 's_ttr900ukrv_kdService.selectOrderNumMasterList'
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
//    var orderNoMasterGrid = Unilite.createGrid('str103ukrvOrderNoMasterGrid', {
    var orderNoMasterGrid = Unilite.createGrid('s_ttr900ukrvOrderNoMasterGrid', {
        // title: '기본',
        layout : 'fit',
        store: orderNoMasterStore,
        uniOpt:{
            useRowNumberer: false
        },
        columns:  [{ dataIndex: 'REPORT_NO'                    , width: 100 },
                   { dataIndex: 'DIV_CODE'                     , width: 120 },
                   { dataIndex: 'CUSTOM_CODE'                  , width: 100 },
                   { dataIndex: 'CUSTOM_NAME'                  , width: 150 },
                   { dataIndex: 'REPORT_DATE'                  , width: 110 },
                   { dataIndex: 'APPLY_DATE'                  , width: 110 }
          ] ,
          listeners: {
              onGridDblClick: function(grid, record, cellIndex, colName) {
                orderNoMasterGrid.returnData(record);
                UniAppManager.app.onQueryButtonDown();
                searchInfoWindow.hide();
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
                panelSearch.setValue('EXCHG_RATE_O', record.get('EXCHG_RATE_O'));
                panelSearch.setValue('SALES_KIND', record.get('SALES_KIND'));
                panelSearch.setValue('APPLY_DATE', record.get('APPLY_DATE'));
                panelSearch.setValue('APPLY_DAYS', record.get('APPLY_DAYS'));
//                panelSearch.setValue('FOB_P_RATE', record.get('FOB_P_RATE'));
//                panelSearch.setValue('CIF_P_RATE', record.get('CIF_P_RATE'));
                panelSearch.setValue('PRICE_KIND', record.get('PRICE_KIND'));
                panelSearch.setValue('PERSON_NUMB', record.get('PERSON_NUMB'));
                panelSearch.setValue('NAME', record.get('NAME'));

                panelResult.setValue('CUSTOM_CODE', record.get('CUSTOM_CODE'));
                panelResult.setValue('CUSTOM_NAME', record.get('CUSTOM_NAME'));
                panelResult.setValue('DIV_CODE', record.get('DIV_CODE'));
                panelResult.setValue('REPORT_NO', record.get('REPORT_NO'));
                panelResult.setValue('REPORT_DATE', record.get('REPORT_DATE'));
                panelResult.setValue('MONEY_UNIT', record.get('MONEY_UNIT'));
                panelResult.setValue('EXCHG_RATE_O', record.get('EXCHG_RATE_O'));
                panelResult.setValue('SALES_KIND', record.get('SALES_KIND'));
                panelResult.setValue('APPLY_DATE', record.get('APPLY_DATE'));
                panelResult.setValue('APPLY_DAYS', record.get('APPLY_DAYS'));
//                panelResult.setValue('FOB_P_RATE', record.get('FOB_P_RATE'));
//                panelResult.setValue('CIF_P_RATE', record.get('CIF_P_RATE'));
                panelResult.setValue('PRICE_KIND', record.get('PRICE_KIND'));
                panelResult.setValue('PERSON_NUMB', record.get('PERSON_NUMB'));
                panelResult.setValue('NAME', record.get('NAME'));
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
		id: 's_ttr900ukrv_kdApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('APPLY_DATE', UniDate.get('today'));
			panelSearch.setValue('REPORT_DATE', UniDate.get('today'));
			panelSearch.setValue('MONEY_UNIT', 'KRW');
			panelSearch.setValue('XCHG_RATE_O', '1');
			panelSearch.setValue('SALES_KIND', '1');
			panelSearch.setValue('PRICE_KIND', '2');
			panelSearch.setValue('APPLY_DAYS', '1');///
//			panelSearch.setValue('FOB_P_RATE', '0');///
//			panelSearch.setValue('CIF_P_RATE', '0');///
			panelSearch.getField('PRICE_KIND').setReadOnly(true);
			panelSearch.getField('REPORT_NO').setReadOnly(true);
      panelSearch.setValue('EXCHG_RATE_O', '1');			

			panelResult.setValue('DIV_CODE',UserInfo.divCode);
            panelResult.setValue('APPLY_DATE', UniDate.get('today'));
            panelResult.setValue('REPORT_DATE', UniDate.get('today'));
            panelResult.setValue('MONEY_UNIT', 'KRW');
            panelResult.setValue('EXCHG_RATE_O', '1');
            panelResult.setValue('SALES_KIND', '1');
            panelResult.setValue('PRICE_KIND', '2');
            panelResult.setValue('APPLY_DAYS', '1');///
//            panelResult.setValue('FOB_P_RATE', '0');///
//            panelResult.setValue('CIF_P_RATE', '0');///
            panelResult.getField('PRICE_KIND').setReadOnly(true);
            panelResult.getField('REPORT_NO').setReadOnly(true);

			UniAppManager.setToolbarButtons(['reset','newData'], true);

			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('DIV_CODE');
            Ext.getCmp('GW').setDisabled(true);
            Ext.getCmp('GW2').setDisabled(true);
		},
		onQueryButtonDown: function() { //조회
//			if(!this.isValidSearchForm()){
//				return false;
//			}
			panelResult.setValue('GW_TEMP', '');
			var reportNo = panelSearch.getValue('REPORT_NO');
            if(Ext.isEmpty(reportNo)) {
                openSearchInfoWindow()
            } else {
            	isLoad = true;
                var detailform = panelSearch.getForm();
                if (detailform.isValid()) {
                    masterGrid.getStore().loadStoreRecords(); //메인조회
                    panelSearch.getForm().getFields().each(function(field) {
                          field.setReadOnly(true);
                    });
                    panelResult.getForm().getFields().each(function(field) {
                          field.setReadOnly(true);
                    });
                    UniAppManager.setToolbarButtons('reset', true);
                } else {
                    var invalid = panelSearch.getForm().getFields()
                            .filterBy(function(field) {
                                return !field.validate();
                            });

                    if (invalid.length > 0) {
                        r = false;
                        var labelText = ''

                        if (Ext.isDefined(invalid.items[0]['fieldLabel'])) {
                            var labelText = invalid.items[0]['fieldLabel']
                                    + '은(는)';
                        } else if (Ext.isDefined(invalid.items[0].ownerCt)) {
                            var labelText = invalid.items[0].ownerCt['fieldLabel']
                                    + '은(는)';
                        }

                        Ext.Msg.alert('확인', labelText + Msg.sMB083);
                        invalid.items[0].focus();
                    }
                }
            }
		},
//		onDetailButtonDown: function() {
//			var as = Ext.getCmp('AdvanceSerch');
//			if(as.isHidden())	{
//				as.show();
//			}else {
//				as.hide()
//			}
//		},
		onNewDataButtonDown : function() { //행추가
            if(!this.isValidSearchForm()){
                return false;
            }
			var param = panelResult.getValues();
            s_ttr900ukrv_kdService.selectGwData(param, function(provider, response) {
                if(Ext.isEmpty(provider[0]) || provider[0].GW_FLAG != '1' || provider[0].GW_FLAG != '3') {
        			panelSearch.getForm().getFields().each(function(field) {
        			      field.setReadOnly(true);
        			});
        			panelResult.getForm().getFields().each(function(field) {
        			      field.setReadOnly(true);
        			});
        			var seq = directMasterStore1.max('REPORT_SEQ');
                        if(!seq) seq = 1;
                        else  seq += 1;
        			var record = {
        				DIV_CODE: panelSearch.getValue('DIV_CODE'),
        				REPORT_SEQ: seq
        			};
        //			masterGrid.createRow(record, 'PERSON_NUMB');
        			masterGrid.createRow(record);
        //			UniAppManager.setToolbarButtons('delete', true);
        //			UniAppManager.setToolbarButtons('save', true);

        			//포커싱
        //			masterGrid.getSelectedRecord().record.get('ITEM_CODE').focus();
        //          var tmp = masterGrid.uniOpt.currentRecord.get('ITEM_CODE');
        //          alert("1111111111111111111 : ");
        //			masterGrid.createRow(record, 'PERSON_NUMB').record.get('ITEM_CODE').focus();

        //			masterGrid.getSelectedRecord().record.select();
                } else {
                    alert('이미 기안된 자료입니다.');
                    return false;
                }
            })


		},
		onSaveDataButtonDown : function() { //저장
			masterGrid.getStore().saveStore();
		},
		onDeleteDataButtonDown : function()	{ //행삭제
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
                if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
                    masterGrid.deleteSelectedRow();
                    var count = masterGrid.getStore().getCount();
                    if(count > 0) {
                       // panelResult.setAllFieldsReadOnly(true);
                    } else {
                       // panelResult.setAllFieldsReadOnly(false);
                    }
                }
            }
		},
		onResetButtonDown : function() { //초기화
			panelSearch.getForm().getFields().each(function(field) {
			      field.setReadOnly(false);
			});
			panelResult.getForm().getFields().each(function(field) {
			      field.setReadOnly(false);
			});
			panelSearch.clearForm();
			Ext.getCmp('GW').setDisabled(true);
			Ext.getCmp('GW2').setDisabled(true);
			panelResult.clearForm();
			masterGrid.getStore().loadData({});
			this.fnInitBinding();;
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
            var spText      = 'EXEC omegaplus_kdg.unilite.USP_GW_S_TTR900UKRV_KD ' + "'" + compCode + "'" + ', ' + "'" + divCode + "'" + ', ' + "'" + reportNo + "'";
            var spCall      = encodeURIComponent(spText);

//            frm.action = '/payment/payreq.php';
//            frm.action   = groupUrl + "viewMode=docuDraft" + "&prg_no=s_ttr900ukrv_kd&draft_no=" + UserInfo.compCode + panelResult.getValue('REPORT_NO') + "&sp=" + spCall/* + Base64.encode()*/;
//            frm.target   = "payviewer";
//            frm.method   = "post";
//            frm.submit();

            var gwurl = groupUrl + "viewMode=docuDraft" + "&prg_no=s_ttr900ukrv_kd&draft_no=" + UserInfo.compCode + panelResult.getValue('REPORT_NO') + "&sp=" + spCall/* + Base64.encode()*/;

            UniBase.fnGw_Call(gwurl,frm,'GW'); /*end*/

        },
        requestApprove2: function(record){     // VIEW
            var gsWin = window.open('about:blank','payviewer','width=500,height=500');

            var frm         = document.f1;
            var compCode    = UserInfo.compCode;
            var divCode     = panelResult.getValue('DIV_CODE');
            var reportNo    = panelResult.getValue('REPORT_NO');
            var spText      = 'EXEC omegaplus_kdg.unilite.USP_GW_S_TTR900UKRV_KD ' + "'" + compCode + "'" + ', ' + "'" + divCode + "'" + ', ' + "'" + reportNo + "'";
            var spCall      = encodeURIComponent(spText);

//            frm.action = '/payment/payreq.php';
            frm.action   = groupUrl + "appr_id=" + record.data.GW_DOC + "&viewMode=docuView";
            frm.target   = "payviewer";
            frm.method   = "post";
            frm.submit();


        }

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
                case "LOCAL_APPL_P" : //Local적용단가
                    if(newValue == oldValue){
                        return false;
                    }
                	if(newValue == '0' || record.get('PUR_P') == '0') {
                        return false;
                    } else {
                        record.set('PROFIT_RATE', Math.round(((newValue / record.get('PUR_P') - 1) * 100 )));
                    }
                break;

                case "PUR_P" : //외주구매가
                    if(newValue == oldValue){
                        return false;
                    }
                    if(newValue == '0' || record.get('LOCAL_APPL_P') == '0') {
                        return false;
                    } else {
                        record.set('PROFIT_RATE', Math.round(((record.get('LOCAL_APPL_P') / newValue - 1) * 100 )));
                    }
                break;

                case "LAST_NEGO_FOR_P" : //최종외화단가
                    if(newValue == oldValue){
                        return false;
                    }
                    if(newValue == '0') {
                        return false;
                    } else {
                        var exchRate    = panelResult.getValue('EXCHG_RATE_O');
                        var lastNegoP   =  newValue;
                        var localApplP  = record.get('LOCAL_APPL_P');
                        var basicForP   = record.get('BASIC_FOR_P');     //기준외화단가
                                                
                        var negoRate    = 0;
                        if (basicForP > 0 )
                        {
                          negoRate = (lastNegoP - basicForP) / basicForP * 100
                        }

                        record.set('LAST_NEGO_P', newValue * exchRate);
                        record.set('NEGO_RATE', negoRate);    // (최종네고자사가 - Local적용가)/Local적용가 *100

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
