<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_ryt400ukrv_kd"  >
    <t:ExtComboStore comboType="BOR120"  pgmId="s_ryt400ukrv_kd"  />             <!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="B131" /> <!--BOM적용여부 -->
    <t:ExtComboStore comboType="AU" comboCode="B004" /> <!-- 화폐 -->
    <t:ExtComboStore comboType="AU" comboCode="WR01" /> <!--비율/단가 -->
    <t:ExtComboStore comboType="AU" comboCode="WR02" /> <!--프로젝트타입-->
    <t:ExtComboStore comboType="AU" comboCode="WR03" /> <!--작업반기-->
    <t:ExtComboStore comboType="AU" comboCode="WR04" /> <!--수량/금액-->
    <t:ExtComboStore comboType="AU" comboCode="BS90" /> <!--작업년도-->
</t:appConfig>
<script type="text/javascript" >

var SearchInfoWindow;   //조회버튼 누르면 나오는 조회창

function appMain() {

    var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 's_ryt400ukrv_kdService.selectList',
            update: 's_ryt400ukrv_kdService.updateDetail',
            create: 's_ryt400ukrv_kdService.insertDetail',
            destroy: 's_ryt400ukrv_kdService.deleteDetail',
            syncAll: 's_ryt400ukrv_kdService.saveAll'
        }
    });

    /**
     *   Model 정의
     * @type
     */
    Unilite.defineModel('s_ryt400ukrv_kdModel', {       // (DETAIL)
        fields: [
            {name: 'COMP_CODE'              ,text: '법인코드'               ,type: 'string'},
            {name: 'DIV_CODE'               ,text: '사업장'                 ,type: 'string'},
            {name: 'CUSTOM_CODE'            ,text: '거래처코드'             ,type: 'string'},
            {name: 'CUSTOM_NAME'            ,text: '거래처명'               ,type: 'string'},
            {name: 'PROD_ITEM_CODE'         ,text: '제품코드'               ,type: 'string'},
            {name: 'PROD_ITEM_NAME'         ,text: '제품명'                 ,type: 'string'},
            {name: 'PROD_ITEM_SPEC'         ,text: '제품규격'               ,type: 'string'},
            {name: 'PROD_OEM_ITEM_CODE'     ,text: '품번(OEM)'              ,type: 'string'},
            {name: 'CHILD_ITEM_CODE'        ,text: '소요자재코드'           ,type: 'string'},
            {name: 'CHILD_ITEM_NAME'        ,text: '소요자재명'             ,type: 'string'},
            {name: 'CHILD_ITEM_SPEC'        ,text: '소요자재규격'           ,type: 'string'},
            {name: 'KG_PRICE'               ,text: 'KG당단가'               ,type: 'uniUnitPrice'},
            {name: 'KG_REQ_QTY'             ,text: 'KG당소요량'           , type: 'float', decimalPrecision:3 ,format:'0,000.000'},
            {name: 'UNIT_REQ_QTY'           ,text: '단위소요량'           , type: 'float', decimalPrecision:6 ,format:'0,000.000000'},
            {name: 'AMT'                    ,text: '소요금액'               			, type: 'float', decimalPrecision:6 ,format:'0,000.000000'},
            {name: 'WORK_YEAR'                  ,text:'작업년도'                   ,type: 'string'},
            {name: 'WORK_SEQ'                  ,text:'반기'                   ,type: 'string'}
        ]
    });

    /**
     * Store 정의(Service 정의)
     * @type
     */
    var directMasterStore = Unilite.createStore('s_ryt400ukrv_kdMasterStore1',{
        model: 's_ryt400ukrv_kdModel',
        uniOpt : {
            isMaster:  true,            // 상위 버튼 연결
            editable:  true,            // 수정 모드 사용
            deletable: true,            // 삭제 가능 여부
            useNavi :  false            // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
        loadStoreRecords : function()   {
            var param= panelResult.getValues();
            this.load({
                  params : param
            });
        },
        listeners: {
            load: function(store, records, successful, eOpts) {
                var count = masterGrid.getStore().getCount();
                if(count > 0) {
                    panelResult.setAllFieldsReadOnly(true)
                }
                else{
                    panelResult.setAllFieldsReadOnly(false)
                }
            },
            add: function(store, records, index, eOpts) {
            	var count = masterGrid.getStore().getCount();
                if(count > 0) {
                    panelResult.setAllFieldsReadOnly(true)
                }
                else{
                    panelResult.setAllFieldsReadOnly(false)
                }
            }
        },
        saveStore: function() {
            var inValidRecs = this.getInvalidRecords();
            console.log("inValidRecords : ", inValidRecs);

            var toCreate = this.getNewRecords();
            var toUpdate = this.getUpdatedRecords();
            var toDelete = this.getRemovedRecords();
            var list = [].concat(toUpdate, toCreate);


            //1. 마스터 정보 파라미터 구성
            var paramMaster= panelResult.getValues();    //syncAll 수정

            if(inValidRecs.length == 0) {
                config = {
                    params: [paramMaster],
                    success: function(batch, option) {
                        panelResult.getForm().wasDirty = false;
                        panelResult.resetDirtyStatus();
                        console.log("set was dirty to false");
                        UniAppManager.setToolbarButtons('save', false);
//                        UniAppManager.app.onQueryButtonDown();
                    }
                };
                this.syncAllDirect(config);
            } else {
                masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
        }
    }); // End of var directMasterStore1

    /**
     * 검색조건 (Search Panel)
     * @type
     */
     var panelResult = Unilite.createSearchForm('resultForm',{
        region: 'north',
        layout : {type : 'uniTable', columns : 4},
        padding:'1 1 1 1',
        border:true,
        masterGrid: masterGrid,
        items: [{
                fieldLabel: '사업장',
                name:'DIV_CODE',
                xtype: 'uniCombobox',
                comboType:'BOR120',
                allowBlank:false,
                holdable: 'hold',
                value: UserInfo.divCode
            },{
				fieldLabel: '작업년도',
				name: 'WORK_YEAR',
				xtype: 'uniCombobox',
				comboType : 'AU',
			    comboCode : 'BS90',
				holdable: 'hold',
				value: new Date().getFullYear(),
				allowBlank: false
	    	},{
				fieldLabel	: '반기',
				name		: 'WORK_SEQ',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'Z004',
				value:'1',
				holdable: 'hold',
				allowBlank: false
				},
            Unilite.popup('AGENT_CUST', {
                    fieldLabel: '거래처',
                    allowBlank:false,
                    holdable: 'hold',
                    listeners: {
                        applyextparam: function(popup){
                            popup.setExtParam({
                                'DIV_CODE':   panelResult.getValue('DIV_CODE'),
                                'ADD_QUERY1': "A.CUSTOM_CODE IN ((SELECT CUSTOM_CODE FROM S_RYT100T_KD WHERE COMP_CODE = ",
                                'ADD_QUERY2': " AND DIV_CODE = ",
                                'ADD_QUERY3': "))"
                            });   //WHERE절 추카 쿼리
                        },
                        onSelected: {
                            fn: function(records, type) {
                                var param = panelResult.getValues();
                                s_ryt400ukrv_kdService.selectMasterData(param, function(provider, response) {
                                    if(!Ext.isEmpty(provider))   {
                                        panelResult.setValue('DIV_CODE', provider[0].DIV_CODE);
                                        panelResult.setValue('CUSTOM_CODE', provider[0].CUSTOM_CODE);
                                        panelResult.setValue('CUSTOM_NAME', provider[0].CUSTOM_NAME);
                                        UniAppManager.app.onQueryButtonDown();
                                    }
                                });
                            },
                            scope: this
                        }
                    }
            })
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

    var masterGrid = Unilite.createGrid('s_ryt400ukrv_kdmasterGrid', {
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
        },
        tbar: [{
            xtype: 'button',
            text: '내역생성',
            margin:'0 0 0 100',
            handler: function() {
            	if(panelResult.setAllFieldsReadOnly(true) == false){
                    return false;
                }
                var param = panelResult.getValues();
                s_ryt400ukrv_kdService.selectList(param, function(provider, response) {
                	if(Ext.isEmpty(provider)) {
                	    s_ryt400ukrv_kdService.selectList3(param, function(provider2, response2) {
                	    	if(Ext.isEmpty(provider2)) {
                	    		panelResult.setAllFieldsReadOnly(false)
                	    	} else {
                	    		panelResult.setAllFieldsReadOnly(true)
                	    	}
                            var records2 = response2.result;
                            masterGrid.reset();
                            Ext.each(records2, function(record,i){
                                UniAppManager.app.onNewDataButtonDown();
                                masterGrid.setProviderData(record);
                            });
                        });
                	} else {
                		if(confirm('기존 데이터가 있습니다. 재생성하시겠습니까?')) {
                    	    s_ryt400ukrv_kdService.beforeSaveDelete(param, function(provider3, response3) {
                    	       s_ryt400ukrv_kdService.selectList3(param, function(provider4, response4) {
                        	       	if(Ext.isEmpty(provider4)) {
                                        panelResult.setAllFieldsReadOnly(false)
                                    } else {
                                        panelResult.setAllFieldsReadOnly(true)
                                    }
                                    var records4 = response4.result;
                                    masterGrid.reset();
                                    Ext.each(records4, function(record,i){
                                        UniAppManager.app.onNewDataButtonDown();
                                        masterGrid.setProviderData(record);
                                    });
                                });
                    	    });
                		}
                	}
                });
//                s_ryt400ukrv_kdService.selectList3(param, function(provider, response) {
//                    var records = response.result;
//                    Ext.each(records, function(record,i){
//                        UniAppManager.app.onNewDataButtonDown();
//                        masterGrid.setProviderData(record);
//                    });
//                });
            }
        }],
        columns:  [
            { dataIndex: 'COMP_CODE'                  ,           width: 80, hidden: true},
            { dataIndex: 'DIV_CODE'                   ,           width: 80, hidden: true},
            { dataIndex: 'CUSTOM_CODE'                ,           width: 80, hidden: true},
            { dataIndex: 'CUSTOM_NAME'                ,           width: 80, hidden: true},
            { dataIndex: 'PROD_ITEM_CODE'             ,           width: 110},
            { dataIndex: 'PROD_ITEM_NAME'             ,           width: 200},
            { dataIndex: 'PROD_ITEM_SPEC'             ,           width: 200},
            { dataIndex: 'PROD_OEM_ITEM_CODE'         ,           width: 110},
            { dataIndex: 'CHILD_ITEM_CODE'            ,           width: 110},
            { dataIndex: 'CHILD_ITEM_NAME'            ,           width: 200},
            { dataIndex: 'CHILD_ITEM_SPEC'            ,           width: 200},
            { dataIndex: 'KG_PRICE'                   ,           width: 100},
            { dataIndex: 'KG_REQ_QTY'                 ,           width: 100},
            { dataIndex: 'UNIT_REQ_QTY'               ,           width: 100},
            { dataIndex: 'AMT'                        ,           width: 100},
            { dataIndex: 'WORK_YEAR'                        ,           width: 80, hidden: true},
            { dataIndex: 'WORK_SEQ'                        ,           width: 80, hidden: true}
        ],
        listeners: {
        	beforeedit  : function( editor, e, eOpts ) {
                if(e.record.phantom) {
                    if(UniUtils.indexOf(e.field, ['KG_PRICE'])) {
                        return true;
                    } else {
                        return false;
                    }
                } else {
                	if(UniUtils.indexOf(e.field, ['KG_PRICE'])) {
                        return true;
                    } else {
                        return false;
                    }
                }
            }
        },
        setProviderData: function(record) {
            var grdRecord = this.getSelectedRecord();

//            grdRecord.set('COMP_CODE'               , record['COMP_CODE']);
//            grdRecord.set('DIV_CODE'                , record['DIV_CODE']);
            grdRecord.set('CUSTOM_CODE'             , record['CUSTOM_CODE']);
            grdRecord.set('CUSTOM_NAME'             , record['CUSTOM_NAME']);
            grdRecord.set('PROD_ITEM_CODE'          , record['PROD_ITEM_CODE']);
            grdRecord.set('PROD_ITEM_NAME'          , record['PROD_ITEM_NAME']);
            grdRecord.set('PROD_ITEM_SPEC'          , record['PROD_ITEM_SPEC']);
            grdRecord.set('PROD_OEM_ITEM_CODE'      , record['PROD_OEM_ITEM_CODE']);
            grdRecord.set('CHILD_ITEM_CODE'         , record['CHILD_ITEM_CODE']);
            grdRecord.set('CHILD_ITEM_NAME'         , record['CHILD_ITEM_NAME']);
            grdRecord.set('CHILD_ITEM_SPEC'         , record['CHILD_ITEM_SPEC']);
            grdRecord.set('KG_PRICE'                , 0);
            grdRecord.set('KG_REQ_QTY'              , record['KG_REQ_QTY']);
            grdRecord.set('UNIT_REQ_QTY'            , record['UNIT_REQ_QTY']);
            grdRecord.set('UNIT_REQ_QTY'            , record['WORK_YEAR']);
            grdRecord.set('UNIT_REQ_QTY'            , record['WORK_SEQ']);
//            grdRecord.set('AMT'                     , grdRecord.get('KG_PRICE') * grdRecord.get('KG_REQ_QTY') * grdRecord.set('UNIT_REQ_QTY'));
//            alert(grdRecord.get('UNIT_REQ_QTY'));
        }
    });

    var inoutNoMasterStore = Unilite.createStore('inoutNoMasterStore', {    //조회버튼 누르면 나오는 조회창
        model: 's_ryt400ukrv_kdModel',
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
                read: 's_ryt400ukrv_kdService.selectList2'
            }
        }
        ,loadStoreRecords : function()  {
            var param= inoutNoSearch.getValues();
            if(Ext.isEmpty( inoutNoSearch.getValue('WORK_YEAR')) || Ext.isEmpty( inoutNoSearch.getValue('WORK_SEQ')) ){
            	alert('필수 항목은 입력하십시오.');
            	return false;
            }
            console.log( param );
            this.load({
                params : param
            });
        }
    });

    var inoutNoSearch = Unilite.createSearchForm('inoutNoSearchForm', {     //조회버튼 누르면 나오는 조회창
        layout: {type: 'uniTable', columns : 3},
        trackResetOnLoad: true,
        items: [
            {
                fieldLabel: '사업장',
                name:'DIV_CODE',
                xtype: 'uniCombobox',
                comboType:'BOR120',
                allowBlank:false,
                holdable: 'hold',
                value: UserInfo.divCode
            },{
				fieldLabel: '작업년도',
				name: 'WORK_YEAR',
				xtype: 'uniCombobox',
				comboType : 'AU',
			    comboCode : 'BS90',
				value: new Date().getFullYear(),
				allowBlank: false
	    	},{
				fieldLabel	: '반기',
				name		: 'WORK_SEQ',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'Z004',
				allowBlank: false
				},
            Unilite.popup('AGENT_CUST', {
                fieldLabel: '거래처',
                listeners: {
                    applyextparam: function(popup){
                        popup.setExtParam({
                            'DIV_CODE':   panelResult.getValue('DIV_CODE'),
                            'ADD_QUERY1': "A.CUSTOM_CODE IN ((SELECT CUSTOM_CODE FROM S_RYT100T_KD WHERE COMP_CODE = ",
                            'ADD_QUERY2': " AND DIV_CODE = ",
                            'ADD_QUERY3': "))"
                        });   //WHERE절 추카 쿼리
                    }
                }
            })
        ]
    }); // createSearchForm

    var inoutNoMasterGrid = Unilite.createGrid('s_ryt400ukrv_kdMasterGrid', {     //조회버튼 누르면 나오는 조회창
        layout : 'fit',
        excelTitle: '기술료정산소요량검색',
        store: inoutNoMasterStore,
        uniOpt:{
            expandLastColumn: true,
            useRowNumberer: false
        },
        columns:  [
            { dataIndex: 'COMP_CODE'                  ,           width: 80, hidden: true},
            { dataIndex: 'DIV_CODE'                   ,           width: 80, hidden: true},
            { dataIndex: 'CUSTOM_CODE'                ,           width: 100},
            { dataIndex: 'CUSTOM_NAME'                ,           width: 200},
            { dataIndex: 'PROD_ITEM_CODE'             ,           width: 110, hidden: true},
            { dataIndex: 'PROD_ITEM_NAME'             ,           width: 200, hidden: true},
            { dataIndex: 'PROD_ITEM_SPEC'             ,           width: 300, hidden: true},
            { dataIndex: 'PROD_OEM_ITEM_CODE'         ,           width: 110, hidden: true},
            { dataIndex: 'CHILD_ITEM_CODE'            ,           width: 110, hidden: true},
            { dataIndex: 'CHILD_ITEM_NAME'            ,           width: 200, hidden: true},
            { dataIndex: 'CHILD_ITEM_SPEC'            ,           width: 300, hidden: true},
            { dataIndex: 'KG_PRICE'                   ,           width: 100, hidden: true},
            { dataIndex: 'KG_REQ_QTY'                 ,           width: 100, hidden: true},
            { dataIndex: 'UNIT_REQ_QTY'               ,           width: 100, hidden: true},
            { dataIndex: 'AMT'                        ,           width: 150, hidden: true},
            { dataIndex: 'WORK_YEAR'                        ,           width: 80, hidden: true},
            { dataIndex: 'WORK_SEQ'                        ,           width: 80, hidden: true}
        ],
        listeners: {
            onGridDblClick: function(grid, record, cellIndex, colName) {
                inoutNoMasterGrid.returnData(record);
                UniAppManager.app.onQueryButtonDown();
                SearchInfoWindow.hide();
                panelResult.setAllFieldsReadOnly(true);
            }
        },
        returnData: function(record)    {
            if(Ext.isEmpty(record)) {
                record = this.getSelectedRecord();
            }
            panelResult.setValues({
                'DIV_CODE'      :record.get('DIV_CODE'),
                'CUSTOM_CODE'   :record.get('CUSTOM_CODE'),
                'CUSTOM_NAME'   :record.get('CUSTOM_NAME'),
                'WORK_YEAR'   :record.get('WORK_YEAR'),
                'WORK_SEQ'   :record.get('WORK_SEQ')
            });
        }
    });

    function openSearchInfoWindow() {           //조회버튼 누르면 나오는 조회창
        if(!SearchInfoWindow) {
            SearchInfoWindow = Ext.create('widget.uniDetailWindow', {
                title: '기술료정산소요량검색',
                width: 850,
                height: 580,
                layout: {type:'vbox', align:'stretch'}, //위치 확인 필요
                items: [inoutNoSearch, inoutNoMasterGrid],
                tbar:  ['->',
                    {
                        itemId : 'saveBtn',
                        text: '조회',
                        handler: function() {
                            inoutNoMasterStore.loadStoreRecords();
                        },
                        disabled: false
                    }, {
                        itemId : 'inoutNoCloseBtn',
                        text: '닫기',
                        handler: function() {
                            SearchInfoWindow.hide();
                        },
                        disabled: false
                    }
                ],
                listeners : {
                    beforehide: function(me, eOpt)  {
                        inoutNoSearch.clearForm();
                        inoutNoMasterGrid.reset();
                    },
                     beforeclose: function( panel, eOpts )  {
                        inoutNoSearch.clearForm();
                        inoutNoMasterGrid.reset();
                    },
                    show: function( panel, eOpts )  {
                        inoutNoSearch.setValue('DIV_CODE'       , panelResult.getValue('DIV_CODE'));
                        inoutNoSearch.setValue('CUSTOM_CODE'    , panelResult.getValue('CUSTOM_CODE'));
                        inoutNoSearch.setValue('WORK_YEAR'    , panelResult.getValue('WORK_YEAR'));
                        inoutNoSearch.setValue('WORK_SEQ'    , panelResult.getValue('WORK_SEQ'));
                     }
                }
            })
        }
        SearchInfoWindow.center();
        SearchInfoWindow.show();
    };


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
        id  : 's_ryt400ukrv_kdApp',
        fnInitBinding : function() {
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            UniAppManager.setToolbarButtons(['save', 'newData','deleteAll'],false);
            this.setDefault();
        },
        onQueryButtonDown : function()  {
        	var customCode = panelResult.getValue('CUSTOM_CODE');
            if(Ext.isEmpty(customCode)) {
                openSearchInfoWindow()
            } else {
            	if(panelResult.setAllFieldsReadOnly(true) == false){
                    return false;
                }
                directMasterStore.loadStoreRecords();

            }
            UniAppManager.setToolbarButtons(['reset'], true);
            UniAppManager.setToolbarButtons(['newData'], false);
        },
        onResetButtonDown: function() {
            panelResult.setAllFieldsReadOnly(false);
            panelResult.clearForm();
            masterGrid.reset();
            this.setDefault();
        },
        onNewDataButtonDown: function() {       // 행추가
        	var compCode        =   UserInfo.compCode;
            var divCode         =   panelResult.getValue('DIV_CODE');
            var workYear	 = panelResult.getValue('WORK_YEAR');
            var workSeq	 = panelResult.getValue('WORK_SEQ');
            var r = {
                COMP_CODE       : compCode,
                DIV_CODE        : divCode,
                WORK_YEAR		:workYear,
                WORK_SEQ		: workSeq
            };
            masterGrid.createRow(r);
        },
        onDeleteDataButtonDown: function() {
        	var selRow1 = masterGrid.getSelectedRecord();
                if(selRow1.phantom === true) {
                    masterGrid.deleteSelectedRow();
                } else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
                    masterGrid.deleteSelectedRow();
                }
        },
        onSaveDataButtonDown: function () {
        	if(panelResult.setAllFieldsReadOnly(true) == false) {
                return false;
            } else {
                directMasterStore.saveStore();
            }
        },
        setDefault: function() {
            directMasterStore.clearData();
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            panelResult.setValue('WORK_YEAR',new Date().getFullYear());
            panelResult.setValue('WORK_SEQ','1');


        }
    });

    Unilite.createValidator('validator01', {
        store: directMasterStore,
        grid: masterGrid,
        validate: function( type, fieldName, newValue, oldValue, record, eopt) {
            if(newValue == oldValue){
                return false;
            }
            console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
            var rv = true;
            var record1 = masterGrid.getSelectedRecord();
            switch(fieldName) {
                case "KG_PRICE" :
                       record.set('AMT', newValue * record.get('KG_REQ_QTY') * record.get('UNIT_REQ_QTY'));
                    break;

//                case "KG_REQ_QTY" :
//
//                    break;
//
//                case "UNIT_REQ_QTY" :
//
//                    break;
            }
            return rv;
        }
    });
}
</script>