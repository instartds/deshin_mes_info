<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_sbx900ukrv_kd"  >
    <t:ExtComboStore comboType="BOR120"  pgmId="s_sbx900ukrv_kd"  />             <!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="S002" /> <!--매출구분-->
    <t:ExtComboStore comboType="AU" comboCode="B004" /> <!--화폐-->
    <t:ExtComboStore comboType="AU" comboCode="M201" /> <!--담당자-->
    <t:ExtComboStore comboType="AU" comboCode="B042" /> <!--계획금액단위-->
    <t:ExtComboStore comboType="AU" comboCode="S010" /> <!--영업담당-->
    <t:ExtComboStore comboType="AU" comboCode="B055" /> <!--고객분류-->
    <t:ExtComboStore comboType="AU" comboCode="B020" /> <!--품목계정-->
    <t:ExtComboStore comboType="AU" comboCode="B109" /> <!--유통-->
    <t:ExtComboStore comboType="AU" comboCode="B013" /> <!--판매단위-->
    <t:ExtComboStore comboType="AU" comboCode="WB05" /> <!--수불구분-->
    <t:ExtComboStore comboType="AU" comboCode="WB06" /> <!--B/OUT관리여부-->
    <t:ExtComboStore comboType="AU" comboCode="H177" /> <!--자사구분-->
    <t:ExtComboStore items="${COMBO_Z0031}" storeId="comboZ0031" /> <!--BOX입출고유형 입고-->
    <t:ExtComboStore items="${COMBO_Z0032}" storeId="comboZ0032" /> <!--BOX입출고유형 출고-->
</t:appConfig>
<script type="text/javascript" >

var BsaCodeInfo = {     //컨트롤러에서 값을 받아옴.
    gsAutoType  : '${gsAutoType}',
    gsMoneyUnit : '${gsMoneyUnit}'
};
var SearchInoutNumWindow;   // 검색창
var tabGubun; //팝업에서 조회 후 재조회할 때 출고,입고 구분이 필요하여 추가
var excelWindow;

function appMain() {
    var isAutoOrderNum = false;
    if(BsaCodeInfo.gsAutoType=='Y') {
        isAutoOrderNum = true;
    }

    var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 's_sbx900ukrv_kdService.selectList',
            update: 's_sbx900ukrv_kdService.updateDetail',
            create: 's_sbx900ukrv_kdService.insertDetail',
            destroy: 's_sbx900ukrv_kdService.deleteDetail',
            syncAll: 's_sbx900ukrv_kdService.saveAll'
        }
    });
    // 엑셀업로드 window의 Grid Model
    Unilite.Excel.defineModel('excel.s_sbx900ukrv_kd.sheet01', {
        fields: [
            {name: '_EXCEL_JOBID'        , text:'EXCEL_JOBID'    , type: 'string'},
            {name: 'COMP_CODE'           , text: '법인코드'          , type: 'string'},
            {name: 'DIV_CODE'           , text: '사업장코드'          , type: 'string'},
            {name: 'INOUT_TYPE'           ,text:'수불구분'              ,type: 'string', comboType: "AU", comboCode: "WB05"},
            {name: 'INOUT_CODE'          , text: '거래처코드'         , type: 'string'},
            {name: 'CUSTOM_NAME'         , text: '거래처명'         , type: 'string'},
            {name: 'INOUT_DATE'          , text: '수불일자'          , type: 'string'},
            {name: 'ITEM_CODE'           , text: 'BOX코드'         , type: 'string'},
            {name: 'ITEM_NAME'           , text: 'BOX명'         , type: 'string'},
            {name: 'SPEC'                , text: '규격'         , type: 'string'},
            {name: 'OWN_TYPE'            , text: '출고유형'          , type: 'string', store: Ext.data.StoreManager.lookup('comboZ0032')},
            {name: 'ORDER_UNIT_Q'        , text: '수량'            , type: 'int'},
            {name: 'ORDER_UNIT_P'        , text: '운송단가'          , type: 'int'},
            {name: 'ORDER_UNIT_O'        , text: '운송금액'          , type: 'int'},
            {name: 'TRANS_CUST_CD'       , text: '운송업체코드'        , type: 'string'},
            {name: 'TRANS_CUST_NM'       , text: '운송업체명'        , type: 'string'},
            {name: 'REMARK'              , text: '비고'             , type: 'string'  }


        ]
    });
    /**
     *   Model 정의
     * @type
     */
    Unilite.defineModel('s_sbx900ukrv_kdModel', {
        fields: [
            {name: 'COMP_CODE'            ,text:'법인코드'              ,type: 'string'},
            {name: 'DIV_CODE'             ,text:'사업장'                ,type: 'string', comboType:'BOR120'},
            {name: 'INOUT_NUM'            ,text:'수불번호'              ,type: 'string'},
            {name: 'INOUT_SEQ'            ,text:'수불순번'              ,type: 'int'},
            {name: 'INOUT_TYPE'           ,text:'수불구분'              ,type: 'string', comboType: "AU", comboCode: "WB05"},
            {name: 'INOUT_CODE'           ,text:'거래처'                ,type: 'string', allowBlank: false},
            {name: 'CUSTOM_NAME'          ,text:'거래처명'              ,type: 'string', allowBlank: false},
            {name: 'INOUT_DATE'           ,text:'수불일자'              ,type: 'uniDate',allowBlank: true},
            {name: 'ITEM_CODE'            ,text:'BOX코드'               ,type: 'string', allowBlank: false},
            {name: 'ITEM_NAME'            ,text:'BOX명'                 ,type: 'string', allowBlank: false},
            {name: 'SPEC'                 ,text:'규격'                  ,type: 'string'},
            {name: 'ITEM_STATUS'          ,text:'품목상태'              ,type: 'string'},
            {name: 'INOUT_PRSN'           ,text:'수불담당'              ,type: 'string'},
            {name: 'EXCHG_RATE_O'         ,text:'환율'                  ,type: 'uniER'},
            {name: 'MONEY_UNIT'           ,text:'화폐단위'              ,type: 'string', comboType: "AU", comboCode: "B004"},
            {name: 'PROJECT_NO'           ,text:'프로젝트번호'          ,type: 'string'},
            {name: 'LOT_NO'               ,text:'LOT_NO'                ,type: 'string'},
            {name: 'REMARK'               ,text:'비고'                  ,type: 'string'},
            {name: 'ORDER_UNIT'           ,text:'단위'                  ,type: 'string'},
            {name: 'OWN_TYPE'             ,text:'출고유형'              ,type: 'string', store: Ext.data.StoreManager.lookup('comboZ0032')},
            {name: 'TRNS_RATE'            ,text:'입수'                  ,type: 'uniER'},
            {name: 'ORDER_UNIT_Q'         ,text:'수량'                  ,type: 'uniQty', allowBlank: false},
            {name: 'ORDER_UNIT_P'         ,text:'운송단가'              ,type: 'uniUnitPrice', allowBlank: false},
            {name: 'ORDER_UNIT_O'         ,text:'운송금액'              ,type: 'uniPrice' , editable:false},
            {name: 'INOUT_Q'              ,text:'(재고단위)수량'        ,type: 'uniQty'},
            {name: 'INOUT_P'              ,text:'(재고단위-원화)단가'   ,type: 'uniUnitPrice'},
            {name: 'INOUT_I'              ,text:'(재고단위-원화)금액'   ,type: 'uniPrice'},
            {name: 'INOUT_FOR_P'          ,text:'(재고단위-외화)단가'   ,type: 'uniUnitPrice'},
            {name: 'INOUT_FOR_O'          ,text:'(재고단위-외화)금액'   ,type: 'uniFC'},
            {name: 'INOUT_TAX_AMT'        ,text:'부가세'                ,type: 'uniPrice'},
            {name: 'TAX_TYPE'             ,text:'세구분'                ,type: 'string'},
            {name: 'TRANS_CUST_CD'        ,text:'운송업체'              ,type: 'string'},
            {name: 'TRANS_CUST_NM'        ,text:'운송업체명'            ,type: 'string'},
            {name: 'INSERT_DB_USER'       ,text:'등록자'                ,type: 'string'},
            {name: 'INSERT_DB_TIME'       ,text:'등록일'                ,type: 'uniDate'},
            {name: 'UPDATE_DB_USER'       ,text:'수정자'                ,type: 'string'},
            {name: 'UPDATE_DB_TIME'       ,text:'수정일'                ,type: 'uniDate'}
        ]
    });

    Unilite.defineModel('s_sbx900ukrv_kdModel3', {          // 검색 팝업창
        fields: [
            {name: 'DIV_CODE'       , text: '사업장'       , type: 'string', comboType:'BOR120'},
            {name: 'INOUT_CODE'     , text: '거래처코드'   , type: 'string'},
            {name: 'CUSTOM_NAME'    , text: '거래처명'     , type: 'string'},
            {name: 'INOUT_SEQ'      , text: '수불순번'     , type: 'int'},
            {name: 'INOUT_NUM'      , text: '수불번호'     , type: 'string'},
            {name: 'INOUT_DATE'     , text: '수불일자'     , type: 'uniDate'}
        ]
    });

    /**
     * Store 정의(Service 정의)
     * @type
     */
    var directMasterStore = Unilite.createStore('s_sbx900ukrv_kdMasterStore1',{
        model: 's_sbx900ukrv_kdModel',
        uniOpt : {
            isMaster: true,            // 상위 버튼 연결
            editable: true,            // 수정 모드 사용
            deletable:true,            // 삭제 가능 여부
            useNavi : false            // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
        loadStoreRecords : function()   {
            var param = panelResult.getValues();
            this.load({
                  params : param
            });
        },
        saveStore: function() {
            var inValidRecs = this.getInvalidRecords();
            console.log("inValidRecords : ", inValidRecs);

            var toCreate = this.getNewRecords();
            var toUpdate = this.getUpdatedRecords();
            var toDelete = this.getRemovedRecords();
            var list = [].concat(toUpdate, toCreate);
            console.log("inValidRecords : ", inValidRecs);
            console.log("list:", list);
            console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));


            var inoutNum = panelResult.getValue('INOUT_NUM');
            if(Ext.isEmpty(inoutNum)){
	            Ext.each(list, function(record, index) {
	                if(record.data['INOUT_NUM'] != inoutNum) {
	                    record.set('INOUT_NUM', inoutNum);
	                }
	            });
            };

            //1. 마스터 정보 파라미터 구성
            var paramMaster = panelResult.getValues();    //syncAll 수정

            if(inValidRecs.length == 0) {
                config = {
                    params: [paramMaster],
                    success: function(batch, option) {
//                        var master = batch.operations[0].getResultSet();
//                        panelResult.setValue("INOUT_NUM", master.INOUT_NUM);

                        panelResult.getForm().wasDirty = false;
                        panelResult.resetDirtyStatus();
                        console.log("set was dirty to false");
                        UniAppManager.setToolbarButtons('save', false);
                    }
                };
                this.syncAllDirect(config);
            } else {
                masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
        }
    }); // End of var directMasterStore1


    /**
     * Store 정의(Service 정의)
     * @type
     */
    var directMasterStore3 = Unilite.createStore('s_sbx900ukrv_kdMasterStore3',{
        model: 's_sbx900ukrv_kdModel3',
        uniOpt : {
            isMaster: true,             // 상위 버튼 연결
            editable: false,            // 수정 모드 사용
            deletable:false,            // 삭제 가능 여부
            useNavi : false             // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {
                read: 's_sbx900ukrv_kdService.selectList3'
            }
        },
        loadStoreRecords : function()   {
            var param= inoutNumSearch.getValues();
            this.load({
                  params : param
            });
        }
    }); // End of var directMasterStore1

    var panelResult = Unilite.createSearchForm('resultForm',{
        region: 'north',
        layout : {type : 'uniTable', columns : 3},
        padding:'1 1 1 1',
        border:true,
        hidden: !UserInfo.appOption.collapseLeftSearch,
        id: 'RESULT_SEARCH',
        items: [{
                fieldLabel: '사업장',
                name:'DIV_CODE',
                xtype: 'uniCombobox',
                comboType:'BOR120',
                allowBlank:false,
                value: UserInfo.divCode,
                holdable: 'hold'
            },
//                {
//                fieldLabel: '수불일자',
//                xtype: 'uniDatefield',
//                name: 'INOUT_DATE',
//                value: UniDate.get('today'),
//                allowBlank:false,
//                holdable: 'hold'
//            },
            Unilite.popup('AGENT_CUST',{
                    fieldLabel: '거래처',
                    valueFieldName:'CUSTOM_CODE',
                    textFieldName:'CUSTOM_NAME',
                    allowBlank:false,
                    holdable: 'hold'
            }) ,{
                fieldLabel: '수불번호',
                name:'INOUT_NUM',
                xtype: 'uniTextfield',
                readOnly: isAutoOrderNum,
                holdable: isAutoOrderNum ? 'readOnly':'hold',
                hidden:true
            },{
		        fieldLabel: '출고일자',
				xtype: 'uniDateRangefield',
				id:"INOUT_DATE_COMMON",
				startFieldName: 'INOUT_START_DATE_FR',
				endFieldName:'INOUT_START_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				textFieldWidth:170,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {},
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {}
			}
        ],
        setAllFieldsReadOnly: function(b) {
            var r= true
            if(b) {
                var invalid = this.getForm().getFields().filterBy(function(field) {
                    return !field.validate();
                });
                if(invalid.length > 0) {
                    r=false;
                    var labelText = ''
                    if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
                        var labelText = invalid.items[0]['fieldLabel']+'은(는)';
                    } else if(Ext.isDefined(invalid.items[0].ownerCt)) {
                        var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
                    }
                    alert(labelText+Msg.sMB083);
                    invalid.items[0].focus();
                } else {
                    //this.mask();
                    var fields = this.getForm().getFields();
                    Ext.each(fields.items, function(item) {
                        if(Ext.isDefined(item.holdable) ) {
                            if (item.holdable == 'hold') {
                                item.setReadOnly(true);
                            }
                        }
                        if(item.isPopupField) {
                            var popupFC = item.up('uniPopupField') ;
                            if(popupFC.holdable == 'hold') {
                                popupFC.setReadOnly(true);
                            }
                        }
                    })
                }
            } else {
                //this.unmask();
                var fields = this.getForm().getFields();
                Ext.each(fields.items, function(item) {
                    if(Ext.isDefined(item.holdable) ) {
                        if (item.holdable == 'hold') {
                            item.setReadOnly(false);
                        }
                    }
                    if(item.isPopupField) {
                        var popupFC = item.up('uniPopupField') ;
                        if(popupFC.holdable == 'hold' ) {
                            item.setReadOnly(false);
                        }
                    }
                })
            }
            return r;
        },
        setLoadRecord: function(record) {
            var me = this;
            me.uniOpt.inLoading=false;
            me.setAllFieldsReadOnly(true);
        }
    });

    var inoutNumSearch = Unilite.createSearchForm('inoutNumSearchForm', {     // 검색 팝업창
        layout: {type: 'uniTable', columns : 3},
        trackResetOnLoad: true,
        items: [{
                fieldLabel: '사업장',
                name: 'DIV_CODE',
                xtype: 'uniCombobox',
                comboType: 'BOR120',
                allowBlank:false
            },
//                {
//                fieldLabel: '수불일자',
//                startFieldName: 'INOUT_DATE_FR',
//                endFieldName: 'INOUT_DATE_TO',
//                xtype: 'uniDateRangefield',
//                startDate: UniDate.get('startOfMonth'),
//                endDate: UniDate.get('today')
//            },
            Unilite.popup('AGENT_CUST',{
                    fieldLabel: '거래처',
                    valueFieldName:'CUSTOM_CODE',
                    textFieldName:'CUSTOM_NAME'
            }), {
                fieldLabel: '수불구분',
                name: 'INOUT_TYPE',
                xtype: 'uniTextfield',
                hidden : true
            },{
		        fieldLabel: '출고일자',
				xtype: 'uniDateRangefield',
				startFieldName: 'INOUT_START_DATE_FR',
				endFieldName:'INOUT_START_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				textFieldWidth:170,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {},
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {}
			}/*,{
                fieldLabel: '수불번호',
                xtype:'uniTextfield',
                name: 'INOUT_NUM'
            }*/
        ],
        setAllFieldsReadOnly: function(b) {
            var r= true
            if(b) {
                var invalid = this.getForm().getFields().filterBy(function(field) {
                    return !field.validate();
                });
                if(invalid.length > 0) {
                    r=false;
                    var labelText = ''
                    if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
                        var labelText = invalid.items[0]['fieldLabel']+'은(는)';
                    } else if(Ext.isDefined(invalid.items[0].ownerCt)) {
                        var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
                    }
                    alert(labelText+Msg.sMB083);
                    invalid.items[0].focus();
                } else {
                    //this.mask();
                    var fields = this.getForm().getFields();
                    Ext.each(fields.items, function(item) {
                        if(Ext.isDefined(item.holdable) ) {
                            if (item.holdable == 'hold') {
                                item.setReadOnly(true);
                            }
                        }
                        if(item.isPopupField) {
                            var popupFC = item.up('uniPopupField') ;
                            if(popupFC.holdable == 'hold') {
                                popupFC.setReadOnly(true);
                            }
                        }
                    })
                }
            } else {
                //this.unmask();
                var fields = this.getForm().getFields();
                Ext.each(fields.items, function(item) {
                    if(Ext.isDefined(item.holdable) ) {
                        if (item.holdable == 'hold') {
                            item.setReadOnly(false);
                        }
                    }
                    if(item.isPopupField) {
                        var popupFC = item.up('uniPopupField') ;
                        if(popupFC.holdable == 'hold' ) {
                            item.setReadOnly(false);
                        }
                    }
                })
            }
            return r;
        },
        setLoadRecord: function(record) {
            var me = this;
            me.uniOpt.inLoading=false;
            me.setAllFieldsReadOnly(true);
        }
    });

    var masterGrid = Unilite.createGrid('s_sbx900ukrv_kdmasterGrid', {
        layout : 'fit',
        region: 'center',
        store: directMasterStore,
        uniOpt: {
            expandLastColumn: false,
            useMultipleSorting: true,
            useGroupSummary: false,
            useLiveSearch: true,
            useContextMenu: true,
            useRowNumberer: false,
            filter: {
                useFilter: true,
                autoCreate: true
            }
        },tbar  : [{
            text    : '엑셀 업로드',
            id  : 'excelBtn',
            width   : 100,
            handler : function() {
                if(!panelResult.getInvalidMessage()) return;   //필수체크
                openExcelWindow();
            }
        }],
        features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
					{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: true} ],
        columns:  [
            { dataIndex: 'COMP_CODE'                            ,           width: 80, hidden: true},
            { dataIndex: 'DIV_CODE'                             ,           width: 80, hidden: true},
            { dataIndex: 'INOUT_NUM'                            ,           width: 120, hidden: true},
            { dataIndex: 'INOUT_SEQ'                            ,           width: 70, hidden: true},
            { dataIndex: 'INOUT_TYPE'                           ,           width: 80, hidden: true},
            { dataIndex: 'INOUT_CODE'                           ,           width: 110, hidden: true,
              'editor': Unilite.popup('AGENT_CUST_G',{
                    textFieldName : 'CUSTOM_CODE',
                    DBtextFieldName : 'CUSTOM_CODE',
                    autoPopup: true,
                    listeners: { 'onSelected': {
                        fn: function(records, type  ){
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
                            grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
                        },
                        scope: this
                      },
                      'onClear' : function(type)    {
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('CUSTOM_CODE','');
                            grdRecord.set('CUSTOM_NAME','');
                      }
                    }
                })
            },
            {dataIndex: 'CUSTOM_NAME'             , width: 200, hidden: true,
              'editor': Unilite.popup('AGENT_CUST_G',{
                    textFieldName : 'CUSTOM_CODE',
                    DBtextFieldName : 'CUSTOM_CODE',
                    autoPopup: true,
                    listeners: { 'onSelected': {
                        fn: function(records, type  ){
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
                            grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
                        },
                        scope: this
                      },
                      'onClear' : function(type)    {
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('CUSTOM_CODE','');
                            grdRecord.set('CUSTOM_NAME','');
                      }
                    }
                })
            },
            { dataIndex: 'INOUT_DATE'                           , width: 100},
            { dataIndex: 'ITEM_CODE'                            ,           width: 110,
                editor: Unilite.popup('DIV_PUMOK_G', {
                        textFieldName: 'ITEM_CODE',
                        DBtextFieldName: 'ITEM_CODE',
                        autoPopup: true,
                        listeners: {'onSelected': {
                            fn: function(records, type) {
                                console.log('records : ', records);
                                Ext.each(records, function(record,i) {
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
                           masterGrid.setItemData2(null,true, masterGrid.uniOpt.currentRecord,true);
                        },
                        applyextparam: function(popup){
                            popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
                            popup.setExtParam({'ITEM_ACCOUNT': '60'});
//                            Ext.getCmp('ITEM_ACCOUNT_ID').setDisabled(true);
                        }
                    }
                }),
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '', '<t:message code="system.label.inventory.total" default="총계"/>');
				}
            },
            {dataIndex: 'ITEM_NAME'               , width: 200,
                editor: Unilite.popup('DIV_PUMOK_G', {
                        textFieldName: 'ITEM_CODE',
                        DBtextFieldName: 'ITEM_CODE',
                        autoPopup: true,
                        listeners: {'onSelected': {
                            fn: function(records, type) {
                                console.log('records : ', records);
                                Ext.each(records, function(record,i) {
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
                            masterGrid.setItemData2(null,true, masterGrid.uniOpt.currentRecord,false);
                        },
                        applyextparam: function(popup){
                            popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
                            popup.setExtParam({'ITEM_ACCOUNT': '60'});
//                            Ext.getCmp('ITEM_ACCOUNT_ID').setDisabled(true);
                        }
                    }
                })
            },
            { dataIndex: 'SPEC'                                 ,           width: 80},
            { dataIndex: 'ITEM_STATUS'                          ,           width: 80, hidden: true},
            { dataIndex: 'INOUT_PRSN'                           ,           width: 80, hidden: true},
            { dataIndex: 'EXCHG_RATE_O'                         ,           width: 80, hidden: true},
            { dataIndex: 'MONEY_UNIT'                           ,           width: 80, hidden: true},
            { dataIndex: 'PROJECT_NO'                           ,           width: 80, hidden: true},
            { dataIndex: 'LOT_NO'                               ,           width: 80, hidden: true},
            { dataIndex: 'ORDER_UNIT'                           ,           width: 80, hidden: true},
            { dataIndex: 'OWN_TYPE'                             ,           width: 80},
            { dataIndex: 'TRNS_RATE'                            ,           width: 80, hidden: true},
            { dataIndex: 'ORDER_UNIT_Q'                         ,           width: 80, summaryType: 'sum'},
            { dataIndex: 'ORDER_UNIT_P'                         ,           width: 80},
            { dataIndex: 'ORDER_UNIT_O'                         ,           width: 100, summaryType: 'sum'},
            { dataIndex: 'INOUT_Q'                              ,           width: 80, hidden: true},
            { dataIndex: 'INOUT_P'                              ,           width: 80, hidden: true},
            { dataIndex: 'INOUT_I'                              ,           width: 80, hidden: true},
            { dataIndex: 'INOUT_FOR_P'                          ,           width: 80, hidden: true},
            { dataIndex: 'INOUT_FOR_O'                          ,           width: 80, hidden: true},
            { dataIndex: 'INOUT_TAX_AMT'                        ,           width: 80, hidden: true},
            { dataIndex: 'TAX_TYPE'                             ,           width: 80, hidden: true},
            { dataIndex: 'TRANS_CUST_CD'                        ,           width: 110,
              'editor': Unilite.popup('AGENT_CUST_G',{
                    textFieldName : 'CUSTOM_CODE',
                    DBtextFieldName : 'CUSTOM_CODE',
                    autoPopup: true,
                    listeners: { 'onSelected': {
                        fn: function(records, type  ){
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('TRANS_CUST_CD',records[0]['CUSTOM_CODE']);
                            grdRecord.set('TRANS_CUST_NM',records[0]['CUSTOM_NAME']);
                        },
                        scope: this
                      },
                      'onClear' : function(type)    {
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('TRANS_CUST_CD','');
                            grdRecord.set('TRANS_CUST_NM','');
                      }
                    }
                })
            },
            { dataIndex: 'TRANS_CUST_NM'                          ,           width: 200,
              'editor': Unilite.popup('AGENT_CUST_G',{
                    textFieldName : 'CUSTOM_CODE',
                    DBtextFieldName : 'CUSTOM_CODE',
                    autoPopup: true,
                    listeners: { 'onSelected': {
                        fn: function(records, type  ){
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('TRANS_CUST_CD',records[0]['CUSTOM_CODE']);
                            grdRecord.set('TRANS_CUST_NM',records[0]['CUSTOM_NAME']);
                        },
                        scope: this
                      },
                      'onClear' : function(type)    {
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('TRANS_CUST_CD','');
                            grdRecord.set('TRANS_CUST_NM','');
                      }
                    }
                })
            },
            { dataIndex: 'REMARK'                               ,           width: 200},
            { dataIndex: 'INSERT_DB_USER'                       ,           width: 80, hidden: true},
            { dataIndex: 'INSERT_DB_TIME'                       ,           width: 80, hidden: true},
            { dataIndex: 'UPDATE_DB_USER'                       ,           width: 80, hidden: true},
            { dataIndex: 'UPDATE_DB_TIME'                       ,           width: 80, hidden: true}
        ],
        listeners: {
            beforeedit : function( editor, e, eOpts ) {
            	if(e.record.phantom == true) {
            	   if(UniUtils.indexOf(e.field, ['ITEM_STATUS',    'INOUT_PRSN',   'EXCHG_RATE_O', 'MONEY_UNIT',       'PROJECT_NO',   'LOT_NO',
            	                                 'ORDER_UNIT',       'TRNS_RATE',    'INOUT_TAX_AMT',    'TAX_TYPE',     'INOUT_TYPE',
            	                                 'INOUT_CODE',     'CUSTOM_NAME',     'SPEC',
            	                                 'INSERT_DB_USER',   'INSERT_DB_TIME',   'UPDATE_DB_USER',   'UPDATE_DB_TIME']))
                    {
                        return false;
                    } else if(UniUtils.indexOf(e.field, ['INOUT_SEQ',    'REMARK',  'ORDER_UNIT_Q', 'ORDER_UNIT_P', 'ITEM_CODE','INOUT_DATE',
                                                          'INOUT_Q', 'INOUT_P',      'INOUT_I',  'INOUT_FOR_P',  'INOUT_FOR_O','OWN_TYPE', 'TRANS_CUST_CD' ]))
                    {
                        return true;
                    } else {
                    	return false;
                    }
            	} else {
                   if(UniUtils.indexOf(e.field, ['ITEM_STATUS',    'INOUT_PRSN',   'EXCHG_RATE_O', 'MONEY_UNIT',       'PROJECT_NO',   'LOT_NO',
                                                 'ORDER_UNIT',     'OWN_TYPE',     'TRNS_RATE',    'INOUT_TAX_AMT',    'TAX_TYPE',     'INOUT_TYPE',
                                                 'INOUT_CODE',     'CUSTOM_NAME',  'INOUT_DATE',   'SPEC',
                                                 'INSERT_DB_USER',   'INSERT_DB_TIME',   'UPDATE_DB_USER',   'UPDATE_DB_TIME']))
                    {
                        return false;
                    } else if(UniUtils.indexOf(e.field, ['REMARK',  'ORDER_UNIT_Q', 'ORDER_UNIT_P',
                                                         'INOUT_Q', 'INOUT_P',      'INOUT_I',  'INOUT_FOR_P',  'INOUT_FOR_O', 'TRANS_CUST_CD']))
                    {
                        return true;
                    } else {
                        return false;
                    }
            	}
            }
        },
        setItemData: function(record, dataClear, grdRecord) {
//              var grdRecord = this.uniOpt.currentRecord;
            if(dataClear) {
              //  grdRecord.set('ITEM_CODE'       , "");
              //  grdRecord.set('ITEM_NAME'       , "");
                grdRecord.set('SPEC'            , "");
              //  grdRecord.set('OWN_TYPE'        , "");
            } else {
                grdRecord.set('ITEM_CODE'       , record['ITEM_CODE']);
                grdRecord.set('ITEM_NAME'       , record['ITEM_NAME']);
                grdRecord.set('SPEC'            , record['SPEC']);
             /*    if(record['STOCK_CARE_YN'] == 'Y') {
                	grdRecord.set('OWN_TYPE'        , '1');
                } else {
                    grdRecord.set('OWN_TYPE'        , '2');
                } */
            }
        },
        setItemData2: function(record, dataClear, grdRecord, itemCodeVal) {
//          var grdRecord = this.uniOpt.currentRecord;
        if(dataClear) {
        	if(itemCodeVal == true){
               grdRecord.set('ITEM_NAME'       , "");
        	}else{
        	   grdRecord.set('ITEM_CODE'       , "");
        	}
            grdRecord.set('SPEC'            , "");
           // grdRecord.set('OWN_TYPE'        , "");
        } else {
            grdRecord.set('ITEM_CODE'       , record['ITEM_CODE']);
            grdRecord.set('ITEM_NAME'       , record['ITEM_NAME']);
            grdRecord.set('SPEC'            , record['SPEC']);
      /*       if(record['STOCK_CARE_YN'] == 'Y') {
            	grdRecord.set('OWN_TYPE'        , '1');
            } else {
                grdRecord.set('OWN_TYPE'        , '2');
            } */
        }
    },
    setExcelData: function(record) {    //엑셀 업로드 참조
            var grdRecord = this.getSelectedRecord();
            grdRecord.set('COMP_CODE'         , record['COMP_CODE']);
            grdRecord.set('DIV_CODE'             , panelResult.getValue('DIV_CODE'));
            //grdRecord.set('INOUT_TYPE'             , record['INOUT_TYPE']);
            grdRecord.set('INOUT_CODE'             , record['INOUT_CODE']);
            grdRecord.set('CUSTOM_NAME'        , record['CUSTOM_NAME']);
            grdRecord.set('INOUT_DATE'           , record['INOUT_DATE']);
            grdRecord.set('ITEM_CODE'           , record['ITEM_CODE']);
            grdRecord.set('ITEM_NAME'                , record['ITEM_NAME']);
            grdRecord.set('SPEC'          , record['SPEC']);
            grdRecord.set('OWN_TYPE'          , record['OWN_TYPE']);
            grdRecord.set('ORDER_UNIT_Q'         , record['ORDER_UNIT_Q']);
            grdRecord.set('ORDER_UNIT_P'        , record['ORDER_UNIT_P']);
            grdRecord.set('ORDER_UNIT_O'         , record['ORDER_UNIT_O']);
            grdRecord.set('TRANS_CUST_CD'         , record['TRANS_CUST_CD']);
            grdRecord.set('TRANS_CUST_NM'         , record['TRANS_CUST_NM']);
            grdRecord.set('REMARK'         , record['REMARK']);

        }
    });

    var inoutNumGrid = Unilite.createGrid('inoutNumMasterGrid', {     // 검색 팝업창
        // title: '기본',
        layout : 'fit',
        store: directMasterStore3,
        uniOpt:{
            useRowNumberer      : false,
            expandLastColumn    : true//마지막컬럼 빈컬럼 사용여부
        },
        columns:  [
            {dataIndex : 'INOUT_SEQ'              , width : 70, hidden: true},
            {dataIndex : 'INOUT_NUM'              , width : 130},
            {dataIndex : 'INOUT_DATE'             , width : 90},
            {dataIndex : 'DIV_CODE'               , width : 140},
            {dataIndex : 'INOUT_CODE'             , width : 110},
            {dataIndex : 'CUSTOM_NAME'            , width : 180}
        ],
        listeners: {
            onGridDblClick:function(grid, record, cellIndex, colName) {
                inoutNumGrid.returnData(record);
                UniAppManager.app.onQueryButtonDown();
                SearchInoutNumWindow.hide();
            }
        },
        returnData: function(record) {
            if(Ext.isEmpty(record)) {
                record = this.getSelectedRecord();
            }
            panelResult.setValues({'DIV_CODE'       : record.get('DIV_CODE')});
            panelResult.setValues({'INOUT_NUM'      : record.get('INOUT_NUM')});
            panelResult.setValues({'CUSTOM_CODE'    : record.get('INOUT_CODE')});
            panelResult.setValues({'CUSTOM_NAME'    : record.get('CUSTOM_NAME')});
            panelResult.setValues({'INOUT_DATE'     : record.get('INOUT_DATE')});
            panelResult.setValues({'INOUT_START_DATE_FR'     : inoutNumSearch.getValue('INOUT_START_DATE_FR')});
            panelResult.setValues({'INOUT_START_DATE_TO'     : inoutNumSearch.getValue('INOUT_START_DATE_TO')});
        }
    });

    function openSearchInoutNumWindow() {   // 검색 팝업창
        if(!SearchInoutNumWindow) {
            SearchInoutNumWindow = Ext.create('widget.uniDetailWindow', {
                title: '수불번호검색',
                width: 1080,
                height: 580,
                layout: {type:'vbox', align:'stretch'},
                items: [inoutNumSearch, inoutNumGrid],
                tbar:  ['->',
                    {itemId : 'saveBtn',
                    text: '조회',
                    handler: function() {
                        directMasterStore3.loadStoreRecords();
                    },
                    disabled: false
                    }, {
                        itemId : 'OrderNoCloseBtn',
                        text: '닫기',
                        handler: function() {
                            SearchInoutNumWindow.hide();
                        },
                        disabled: false
                    }
                ],
                listeners: {beforehide: function(me, eOpt)
                    {
                        inoutNumSearch.clearForm();
                        inoutNumGrid.reset();
                    },
                    beforeclose: function( panel, eOpts) {
                        inoutNumSearch.clearForm();
                        inoutNumGrid.reset();
                    },
                    beforeshow: function( panel, eOpts) {
                        inoutNumSearch.setValue('DIV_CODE',     panelResult.getValue('DIV_CODE'));
                        inoutNumSearch.setValue('INOUT_NUM',    panelResult.getValue('INOUT_NUM'));
                        inoutNumSearch.setValue('CUSTOM_CODE',  panelResult.getValue('CUSTOM_CODE'));
                        inoutNumSearch.setValue('CUSTOM_NAME',  panelResult.getValue('CUSTOM_NAME'));
                        inoutNumSearch.setValue('INOUT_START_DATE_FR',  panelResult.getValue('INOUT_START_DATE_FR'));
                        inoutNumSearch.setValue('INOUT_START_DATE_TO',  panelResult.getValue('INOUT_START_DATE_TO'));
                        inoutNumSearch.setValue('INOUT_TYPE',   '2');
                    }
                }
            })
        }
        SearchInoutNumWindow.show();
        SearchInoutNumWindow.center();
    }

    Unilite.Main( {
        borderItems:[{
            region:'center',
            layout: 'border',
            border: false,
            items:[
                masterGrid, panelResult
            ]
        }
        ],
        id  : 's_sbx900ukrv_kdApp',
        fnInitBinding : function() {
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            UniAppManager.setToolbarButtons(['save', 'newData','deleteAll'],false);
            UniAppManager.setToolbarButtons('newData', true);
            panelResult.clearForm();
            directMasterStore.clearData();
            this.setDefault();
        },
        onQueryButtonDown : function()  {
//            if(!panelResult.setAllFieldsReadOnly(true)) {
//                return false;
//            }
            var inoutNum = panelResult.getValue('INOUT_NUM');
            if(Ext.isEmpty(inoutNum)) {
                openSearchInoutNumWindow()
            } else {
                    directMasterStore.loadStoreRecords();
                UniAppManager.setToolbarButtons('reset', true);
            }
        },
        onResetButtonDown: function() {
            panelResult.setAllFieldsReadOnly(false);
            masterGrid.reset();
            this.fnInitBinding();

        },
        onNewDataButtonDown: function() {       // 행추가
            if(panelResult.setAllFieldsReadOnly(true) == false) {
                return false;
            }
                var compCode           = panelResult.getValue('COMP_CODE');
                var divCode            = panelResult.getValue('DIV_CODE');
                var customCode         = panelResult.getValue('CUSTOM_CODE');
                var customName         = panelResult.getValue('CUSTOM_NAME');
                var seq                = directMasterStore.max('INOUT_SEQ');
                    if(!seq) seq = 1;
                    else  seq += 1;
                var inoutType          = '2';
                var inoutDate          = panelResult.getValue('INOUT_DATE');
//                var moneyUnit          = UserInfo.currency;
                var moneyUnit          = BsaCodeInfo.gsMoneyUnit;
                var trnsRate           = '1';
                var userId             = UserInfo.userID;
				var ownType 	       = '10'
                var r = {
                    'COMP_CODE'                  : compCode,
                    'DIV_CODE'                   : divCode,
                    'INOUT_CODE'                 : customCode,
                    'CUSTOM_NAME'                : customName,
                    'INOUT_SEQ'                  : seq,
                    'INOUT_TYPE'                 : inoutType,
                    'INOUT_DATE'                 : inoutDate,
                    'MONEY_UNIT'                 : moneyUnit,
                    'TRNS_RATE'                  : trnsRate,
                    'USER_ID'                    : userId,
                    'OWN_TYPE'				: ownType
                };
                masterGrid.createRow(r);
        },
        onDeleteDataButtonDown: function() {
                var record = masterGrid.getSelectedRecord();
            	if(record.phantom === true) {
                    masterGrid.deleteSelectedRow();
                } else {
                    if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
                        masterGrid.deleteSelectedRow();
                    }
                }
        },
        onSaveDataButtonDown: function () {
               directMasterStore.saveStore();
        },
        setDefault: function() {
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
         	panelResult.setValue('INOUT_START_DATE_FR',UniDate.get('startOfMonth'));
        	panelResult.setValue('INOUT_START_DATE_TO',UniDate.get('endOfMonth'));

        }
    });
    //엑셀업로드 윈도우 생성 함수
    function openExcelWindow() {
        var me = this;
        var vParam = {};
        var appName = 'Unilite.com.excel.ExcelUpload';
        if(!directMasterStore.isDirty())  {                                   //화면에 저장할 내용이 있을 경우 저장여부 확인
            //masterStore.loadData({});
        } else {
            if(confirm('저장될 내용이 있습니다. '+'\n'+'저장하시겠습니까?')){
                UniAppManager.app.onSaveDataButtonDown();
                return;
            }else {
                directMasterStore.loadData({});
            }
        }
        /*if(!Ext.isEmpty(excelWindow)){
            excelWindow.extParam.DIV_CODE       = panelResult.getValue('DIV_CODE');
//          excelWindow.extParam.ISSUE_GUBUN    = Ext.getCmp('rdoSelect0').getChecked()[0].inputValue;
//          excelWindow.extParam.APPLY_YN       = Ext.getCmp('rdoSelect0_0').getChecked()[0].inputValue;
        }*/
        if(!excelWindow) {
            excelWindow = Ext.WindowMgr.get(appName);
            excelWindow = Ext.create( appName, {
                excelConfigName: 's_sbx900ukrv_kd',
                width   : 600,
                height  : 400,
                modal   : false,
                extParam: {
                    'PGM_ID'    : 's_sbx900ukrv_kd'
                    //'DIV_CODE'  : panelResult.getValue('DIV_CODE')
                },
                grids: [{                           //팝업창에서 가져오는 그리드
                        itemId      : 'grid01',
                        title       : '엑셀업로드',
                        useCheckbox : true,
                        model       : 'excel.s_sbx900ukrv_kd.sheet01',
                        readApi     : 's_sbx900ukrv_kdService.selectExcelUploadSheet1',
                        columns     : [
                            {dataIndex: '_EXCEL_JOBID'      , width: 80     , hidden: true},
                            {dataIndex: 'COMP_CODE'         , width: 93     , hidden: true},
                            {dataIndex: 'DIV_CODE'         , width: 93     , hidden: true},
                            {dataIndex: 'INOUT_TYPE'        , width: 100, hidden: true},
                            {dataIndex: 'INOUT_CODE'        , width: 100},
                            {dataIndex: 'CUSTOM_NAME'        , width: 100},
                            {dataIndex: 'INOUT_DATE'        , width: 100},
                            {dataIndex: 'ITEM_CODE'         , width: 100},
                            {dataIndex: 'ITEM_NAME'         , width: 100},
                            {dataIndex: 'SPEC'              , width: 100},
                            {dataIndex: 'OWN_TYPE'          , width: 100},
                            {dataIndex: 'ORDER_UNIT_Q'      , width: 100},
                            {dataIndex: 'ORDER_UNIT_P'      , width: 100},
                            {dataIndex: 'ORDER_UNIT_O'      , width: 100},
                            {dataIndex: 'TRANS_CUST_CD'     , width: 100},
                            {dataIndex: 'TRANS_CUST_NM'     , width: 100},
                            {dataIndex: 'REMARK'            , width: 133}
                        ]
                    }
                ],
                listeners: {
                    close: function() {
                        this.hide();
                    }
                },

                onApply:function()  {
                    excelWindow.getEl().mask('로딩중...','loading-indicator');
                    var me      = this;
                    var grid    = this.down('#grid01');
                    var records = grid.getSelectionModel().getSelection();
                            Ext.each(records, function(record,i){
                                                        UniAppManager.app.onNewDataButtonDown();
                                                        masterGrid.setExcelData(record.data);
                                                    });
                            //grid.getStore().remove(records);
                            excelWindow.getEl().unmask();
                            var beforeRM = grid.getStore().count();
                            grid.getStore().remove(records);
                            var afterRM = grid.getStore().count();
                            if (beforeRM > 0 && afterRM == 0){
                               excelWindow.close();
                            };
                },

                //툴바 세팅
                _setToolBar: function() {
                    var me = this;
                    me.tbar = [
                    '->',
                    {
                        xtype   : 'button',
                        text    : '업로드',
                        tooltip : '업로드',
                        width   : 60,
                        handler: function() {
                            me.jobID = null;
                            me.uploadFile();
                        }
                    },{
                        xtype   : 'button',
                        text    : '적용',
                        tooltip : '적용',
                        width   : 60,
                        handler : function() {
                            var grids   = me.down('grid');
                            var isError = false;
                            if(Ext.isDefined(grids.getEl()))    {
                                grids.getEl().mask();
                            }
                            Ext.each(grids, function(grid, i){
                                var records = grid.getStore().data.items;
                                return Ext.each(records, function(record, i){
                                    if(record.get('_EXCEL_HAS_ERROR') == 'Y') {
                                        console.log("_EXCEL_HAS_ERROR : ", record.get('_EXCEL_HAS_ERROR'));
                                        isError = true;
                                        return false;
                                    }
                                });
                            });
                            if(Ext.isDefined(grids.getEl()))    {
                                grids.getEl().unmask();
                            }
                            if(!isError) {
                                me.onApply();
                            }else {
                                alert("에러가 있는 행은 적용이 불가능합니다.");
                            }
                        }
                    },{
                            xtype: 'tbspacer'
                    },{
                            xtype: 'tbseparator'
                    },{
                            xtype: 'tbspacer'
                    },{
                        xtype: 'button',
                        text : '닫기',
                        tooltip : '닫기',
                        handler: function() {
                            var grid = me.down('#grid01');
                            grid.getStore().removeAll();
                            me.hide();
                        }
                    }
                ]}
            });
        }
        excelWindow.center();
        excelWindow.show();
    };

    Unilite.createValidator('validator01', {
        store: directMasterStore,
        grid: masterGrid,
        validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
            console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
            var rv = true;
            switch(fieldName) {
                case "ORDER_UNIT_Q" :
                    if(newValue <= '0') {
                        rv= Msg.sMB076;
                        break;
                    }
                    record.set('ORDER_UNIT_O', newValue * record.get('ORDER_UNIT_P'));
                break;

                case "ORDER_UNIT_P" :
                    if(newValue <= '0') {
                        rv= Msg.sMB076;
                        break;
                    }
                    record.set('ORDER_UNIT_O', newValue * record.get('ORDER_UNIT_Q'));
                break;
            }
            return rv;
        }
    }); // validator
}
</script>