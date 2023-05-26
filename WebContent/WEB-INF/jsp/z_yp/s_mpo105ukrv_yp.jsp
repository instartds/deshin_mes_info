<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_mpo105ukrv_yp"  >
    <t:ExtComboStore comboType="BOR120"  pgmId="s_mpo105ukrv_yp"  />             <!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="B012" /><!-- 국가코드-->
    <t:ExtComboStore comboType="AU" comboCode="B013" /> <!--구매단위-->
</t:appConfig>
<script type="text/javascript" >

var selectedMasterGrid = 's_mpo105ukrv_ypGrid';

function appMain() {

    var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 's_mpo105ukrv_ypService.selectList',
            update: 's_mpo105ukrv_ypService.updateDetail',
            create: 's_mpo105ukrv_ypService.insertDetail',
            destroy: 's_mpo105ukrv_ypService.deleteDetail',
            syncAll: 's_mpo105ukrv_ypService.saveAll'
        }
    });

    var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 's_mpo105ukrv_ypService.selectList2'
        }
    });

    /**
     *   Model 정의
     * @type
     */
    Unilite.defineModel('s_mpo105ukrv_ypModel', {
        fields: [
            {name: 'ITEM_CODE'            ,text:'품목코드'               ,type: 'string'},
            {name: 'ITEM_NAME'            ,text:'품목명'                 ,type: 'string'},
            {name: 'SPEC'                 ,text:'규격'                  ,type: 'string'},
            {name: 'REQ_PLAN_Q'           ,text:'소요량'                 ,type: 'uniQty'},
            {name: 'STOCK_UNIT'           ,text:'단위'                  ,type: 'string', comboType: "AU", comboCode: "B013"},
            {name: 'DVRY_DATE'            ,text:'구매납기'                ,type: 'uniDate'},
            {name: 'ORDER_PLAN_Q'         ,text:'발주예정량'               ,type: 'uniQty', allowBlank: false},
            {name: 'STOCK_Q'              ,text:'현재고'                 ,type: 'uniQty'},
            {name: 'CUSTOM_CODE'          ,text:'발주처코드'               ,type: 'string'},
            {name: 'CUSTOM_NAME'          ,text:'발주처'                  ,type: 'string'},
            {name: 'INSTOCK_PLAN_Q'       ,text:'입고예정량'                ,type: 'uniQty'},
            {name: 'OUTSTOCK_PLAN_Q'      ,text:'출고예정량'                ,type: 'uniQty'},
            {name: 'PAB_STOCK_Q'          ,text:'가용재고'                  ,type: 'uniQty'},
            {name: 'COMP_CODE'            ,text:'COMP_CODE'               ,type: 'string'},
            {name: 'DIV_CODE'             ,text:'사업장'                    ,type: 'string'},
            {name: 'ORDER_REQ_NUM'        ,text:'구매요청번호'                ,type: 'string'},
            {name: 'MRP_CONTROL_NUM'      ,text:'MRP전개번호'                ,type: 'string'},

            {name: 'ORDER_NUM'            ,text:'수주번호'                ,type: 'string'},
            {name: 'SER_NO'               ,text:'순번'                ,type: 'string'},
            {name: 'ORDER_CUSTOM_NAME'    ,text:'수주처'                ,type: 'string'},
            {name: 'EXP_ISSUE_DATE'       ,text:'출하예정일'                ,type: 'uniDate'}
        ]
    });

    Unilite.defineModel('s_mpo105ukrv_ypModel2', {
        fields: [
            {name: 'ITEM_CODE'             ,text:'품목코드'              ,type: 'string'},
            {name: 'ITEM_NAME'             ,text:'품목명'               ,type: 'string'},
            {name: 'SPEC'                  ,text:'규격'                 ,type: 'string'},
            {name: 'ORDER_UNIT_Q'          ,text:'소요량'                ,type: 'uniQty'},
            {name: 'STOCK_UNIT'            ,text:'단위'                 ,type: 'string', comboType: "AU", comboCode: "B013"},
            {name: 'DVRY_DATE'             ,text:'납기일자'               ,type: 'uniDate'},
            {name: 'CUSTOM_NAME'           ,text:'수주처'                ,type: 'string'}
        ]
    });

    /**
     * Store 정의(Service 정의)
     * @type
     */
    var directMasterStore = Unilite.createStore('s_mpo105ukrv_ypMasterStore1',{
        model: 's_mpo105ukrv_ypModel',
        uniOpt : {
            isMaster:  true,            // 상위 버튼 연결
            editable:  true,            // 수정 모드 사용
            deletable: false,            // 삭제 가능 여부
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

    var directMasterStore2 = Unilite.createStore('s_mpo105ukrv_ypMasterStore2',{
        model: 's_mpo105ukrv_ypModel2',
        uniOpt : {
            isMaster:  false,            // 상위 버튼 연결
            editable:  false,            // 수정 모드 사용
            deletable: false,            // 삭제 가능 여부
            useNavi :  false            // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy2,
        loadStoreRecords : function(param)   {
//            var param= panelResult.getValues();
        	if(selectedMasterGrid == 's_mpo105ukrv_ypGrid2') {
        		var param= panelResult2.getValues();
        	}
            this.load({
                  params : param
            });
        }
    });

    /**
     * 검색조건 (Search Panel)
     * @type
     */
    var panelResult = Unilite.createSearchForm('resultForm',{
        region: 'north',
        layout : {type : 'uniTable', columns : 4, tableAttrs: {width: '100%'}},
        padding:'1 1 1 1',
        border:true,
        hidden: !UserInfo.appOption.collapseLeftSearch,
        items: [{
                fieldLabel: '사업장',
                name:'DIV_CODE',
                xtype: 'uniCombobox',
                comboType:'BOR120',
                allowBlank:false,
                value: UserInfo.divCode,
                tdAttrs: {width: 300},
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('DIV_CODE', newValue);
                    }
                }
            },{
                fieldLabel: '납기일',
                labelWidth: 107,
                xtype: 'uniDateRangefield',
                startFieldName: 'DVRY_DATE_FR',
                endFieldName: 'DVRY_DATE_TO',
                allowBlank:false,
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today'),
                tdAttrs: {width: 300},
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                },
                onEndDateChange: function(field, newValue, oldValue, eOpts) {
                }
            },{
                xtype: 'container',
                layout: {type: 'uniTable', columns: 2},
                margin: '0 15 1 0',
                tdAttrs: {align: 'right'},
                items:[{ xtype: 'uniDatefield',
		                    name: 'BASIS_DATE',
		                    fieldLabel: '기준일자',
		                    tdAttrs: {width: 300}
		                },{   xtype: 'button',
			                   text: '발주예정정보 생성',
			                   width: 130,
			                   handler : function() {
	                   	    if(confirm('발주예정정보를 생성하시겠습니까?')) {
	                   	        var param = {DIV_CODE: panelResult.getValue('DIV_CODE'), BASIS_DATE: UniDate.getDbDateStr(panelResult.getValue('BASIS_DATE')), ORDER_PLAN_TYPE: panelResult.getValue('ORDER_PLAN_TYPE')}
	                            Ext.getBody().mask('로딩중...','loading-indicator');
	                            s_mpo105ukrv_ypService.createOrderInfo(param, function(provider, response)  {
	                                if(provider){
	                                    UniAppManager.updateStatus(Msg.sMB011);
	                                    UniAppManager.app.onQueryButtonDown();
	                                }
	                                Ext.getBody().unmask();
	                            });
	                   	    }
                  	 }
                }]
            },{
                xtype: 'uniTextfield',
                hidden: true,
                name: 'ORDER_PLAN_TYPE'
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
        }
    });

    var panelResult2 = Unilite.createSearchForm('detailForm2', { //createForm
        layout : {type : 'uniTable', columns : 2},
        disabled: false,
        border:true,
        padding:'1 1 1 1',
//        region: 'north',
        masterGrid: masterGrid2,
        items: [
            {
                fieldLabel: '비율/단가',
                xtype: 'uniCombobox',
                holdable: 'hold',
                comboType:'AU',
                comboCode:'WR01',
                name: 'INIT_PAY'
            },{
                fieldLabel: '작업기간',
                xtype: 'uniMonthRangefield',
                startFieldName: 'CON_FR_YYMM',
                endFieldName: 'CON_TO_YYMM',
                holdable: 'hold'
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

    var masterGrid = Unilite.createGrid('s_mpo105ukrv_ypGrid1', {
        layout : 'fit',
        region: 'center',
        store: directMasterStore,
        selModel: 'rowmodel',
//        flex: 3.3,
        uniOpt: {
            expandLastColumn: false,
            useMultipleSorting: true,
            useGroupSummary: false,
            useLiveSearch: true,
            useContextMenu: true,
            useRowNumberer: false,       //순번표시
            copiedRow: true,
            filter: {
                useFilter: true,
                autoCreate: true
            }
        },
        columns:  [
            { dataIndex: 'ITEM_CODE'            ,           width: 90},
            { dataIndex: 'ITEM_NAME'            ,           width: 180},
            { dataIndex: 'SPEC'                 ,           width: 130},
            { dataIndex: 'REQ_PLAN_Q'           ,           width: 100},
            { dataIndex: 'STOCK_UNIT'           ,           width: 100, align: 'center'},
            { dataIndex: 'DVRY_DATE'            ,           width: 100},
            { dataIndex: 'ORDER_PLAN_Q'         ,           width: 100},
            { dataIndex: 'STOCK_Q'              ,           width: 100},
            { dataIndex: 'CUSTOM_CODE'          ,           width: 90},
            { dataIndex: 'CUSTOM_NAME'          ,           width: 160},
            { dataIndex: 'INSTOCK_PLAN_Q'       ,           width: 100},
            { dataIndex: 'OUTSTOCK_PLAN_Q'      ,           width: 100},
//            { dataIndex: 'ORDER_PLAN_Q'         ,           width: 100},
            { dataIndex: 'COMP_CODE'            ,           width: 100, hidden: true},
            { dataIndex: 'DIV_CODE'             ,           width: 100, hidden: true},
            { dataIndex: 'ORDER_REQ_NUM'        ,           width: 120, hidden: true},
            { dataIndex: 'MRP_CONTROL_NUM'      ,           width: 120, hidden: true},

            { dataIndex: 'ORDER_NUM'            ,          width: 110},
            { dataIndex: 'SER_NO'               ,          width: 60, align: 'center'},
            { dataIndex: 'ORDER_CUSTOM_NAME'    ,          minWidth: 120, flex: 1},
            { dataIndex: 'EXP_ISSUE_DATE'       ,          width: 100}

        ],
        listeners: {
        	beforeedit  : function( editor, e, eOpts ) {
                if(!UniUtils.indexOf(e.field, ['ORDER_PLAN_Q'])) {
                    return false;
                }
            },
            render: function(grid, eOpts) {
                var girdNm = grid.getItemId();
                grid.getEl().on('click', function(e, t, eOpt) {
                    selectedMasterGrid = 's_mpo105ukrv_ypGrid';
                });
            },
            selectionchange:function( model1, selected, eOpts ){
                if(selected.length > 0) {
                    var record = selected[0];
                    var param = {
                        DIV_CODE       : record.data.DIV_CODE,
                        MRP_CONTROL_NUM    : record.data.MRP_CONTROL_NUM,
                        DVRY_DATE    : UniDate.getDbDateStr(record.data.DVRY_DATE),
                        ITEM_CODE    : record.data.ITEM_CODE
                    }
                    directMasterStore2.loadStoreRecords(param);
                }
            }
        }
    });

    var masterGrid2 = Unilite.createGrid('s_mpo105ukrv_ypGrid2', {
        layout : 'fit',
        region: 'south',
        store: directMasterStore2,
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
        columns:  [
            { dataIndex: 'ITEM_CODE'             ,           width: 100},
            { dataIndex: 'ITEM_NAME'             ,           width: 180},
            { dataIndex: 'SPEC'                  ,           width: 130},
            { dataIndex: 'ORDER_UNIT_Q'          ,           width: 100},
            { dataIndex: 'STOCK_UNIT'            ,           width: 100},
            { dataIndex: 'DVRY_DATE'             ,           width: 100},
            { dataIndex: 'CUSTOM_NAME'           ,           width: 160}
        ],
        listeners: {

        }
    });

    /*
     * panelResult   n
     * inputTable    n
     * masterGrid    c
     * panelResult2  s
     * masterGrid2   s
     * */
    Unilite.Main( {
        borderItems:[{
            region:'center',
            layout: 'border',
            border: false,
            items:[
                panelResult, masterGrid, masterGrid2]
        }
        ],
        id  : 's_mpo105ukrv_ypApp',
        fnInitBinding : function() {
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            UniAppManager.setToolbarButtons(['save', 'newData','deleteAll'],false);
            UniAppManager.setToolbarButtons('newData', true);
            this.setDefault();
            if('${gsOrderPlanType}' == '2'){
                masterGrid2.hide();
            }
        },
        onQueryButtonDown : function()  {
            if(selectedMasterGrid == 's_mpo105ukrv_ypGrid') {
                if(panelResult.setAllFieldsReadOnly(true) == false){
                    return false;
                }
                if(panelResult.setAllFieldsReadOnly(true) == false){
                    return false;
                }
                directMasterStore.loadStoreRecords();
            } else {
            	if(panelResult2.setAllFieldsReadOnly(true) == false){
                    return false;
                }
            	directMasterStore2.loadStoreRecords();
            }
//            UniAppManager.setToolbarButtons(['reset'], true);
        },
        onResetButtonDown: function() {
            panelResult.setAllFieldsReadOnly(false);
            panelResult.clearForm();
            directMasterStore.loadData({});
            directMasterStore2.loadData({});
            this.setDefault();
//            UniAppManager.setToolbarButtons(['save', 'reset'], false);
        },
        onNewDataButtonDown: function() {       // 행추가
        	if(selectedMasterGrid == 's_mpo105ukrv_ypGrid') {
                var compCode      = UserInfo.compCode;
                var divCode       = panelResult.getValue('DIV_CODE');
                var conDate       = UniDate.get('today');
                var flag          = 'N';

                var r = {
                    COMP_CODE      : compCode,
                    DIV_CODE       : divCode,
                    CON_DATE       : conDate,
                    FLAG           : flag
                }
                masterGrid.createRow(r);
            } else {
                var record       = masterGrid.getSelectedRecord();
                var compCode     = UserInfo.compCode;
                var divCode      = record.get('DIV_CODE');
                var customCode   = record.get('CUSTOM_CODE');
                var seq = directMasterStore2.max('SEQ');
                    if(!seq) seq = 1;
                    else seq += 1;
                var conDate      = record.get('CON_DATE');
                var rateN        = 0;

                var r = {
                    COMP_CODE      : compCode,
                    DIV_CODE       : divCode,
                    CUSTOM_CODE    : customCode,
                    SEQ            : seq,
                    CON_DATE       : conDate,
                    RATE_N         : rateN
                }
                masterGrid2.createRow(r);
            }
        },
        onDeleteDataButtonDown: function() {
        	if(selectedMasterGrid == 's_mpo105ukrv_ypGrid') {
        		var selRow1 = masterGrid.getSelectedRecord();
                if(selRow1.phantom === true) {
                    masterGrid.deleteSelectedRow();
                } else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
                    masterGrid.deleteSelectedRow();
                }
        	} else {
        		var selRow2 = masterGrid2.getSelectedRecord();
                if(selRow2.phantom === true) {
                    masterGrid2.deleteSelectedRow();
                } else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
                    masterGrid2.deleteSelectedRow();
                }
        	}
        },
        onSaveDataButtonDown: function () {
        	if(selectedMasterGrid == 's_mpo105ukrv_ypGrid') {
                directMasterStore.saveStore();
        	} else {
        		directMasterStore2.saveStore();
        	}
        },
        setDefault: function() {
            directMasterStore.clearData();
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            panelResult.setValue('DVRY_DATE_TO', UniDate.get('today'));
            panelResult.setValue('DVRY_DATE_FR', UniDate.get('startOfMonth', panelResult.getValue('DVRY_DATE_TO')));
            panelResult.setValue('BASIS_DATE', UniDate.get('today'));
            panelResult.setValue('ORDER_PLAN_TYPE', '${gsOrderPlanType}');
        }
    });


//    Unilite.createValidator('validator01', {
//        store: directMasterStore,
//        grid: masterGrid,
//        validate: function( type, fieldName, newValue, oldValue, record, eopt) {
//            if(newValue == oldValue){
//                return false;
//            }
//            console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
//            var rv = true;
//            var record1 = masterGrid.getSelectedRecord();
//            switch(fieldName) {
//                case "CON_DATE" :
//                    if(UniDate.getDbDateStr(record.set('EXP_DATE')) < newValue) {
//                        alert("계약일자보다 만료일자가 작을수없습니다.");
//                        record.set('CON_DATE', oldValue);
//                        break;
//                    }
//                    break;
//
//                case "EXP_DATE" :
//                    if(UniDate.getDbDateStr(record.set('CON_DATE')) > newValue) {
//                        alert("계약일자보다 만료일자가 작을수없습니다.");
//                        record.set('EXP_DATE', oldValue);
//                        break;
//                    }
//                    break;
//            }
//            return rv;
//        }
//    });

    Unilite.createValidator('validator02', {
        store: directMasterStore2,
        grid: masterGrid2,
        validate: function( type, fieldName, newValue, oldValue, record, eopt) {
            if(newValue == oldValue){
                return false;
            }
            console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
            var rv = true;
            var record1 = masterGrid.getSelectedRecord();
            switch(fieldName) {
                case "CON_FR_YYMM" :
                    if(!Ext.isEmpty(record1.data.EXP_DATE)) {
                        if(UniDate.getDbDateStr(record1.data.EXP_DATE).substring(0, 6) < newValue) {
                            alert("만료일보다 시작월이 클수없습니다.");
                            record.set('CON_FR_YYMM', oldValue);
                            break;
                        } else if(UniDate.getDbDateStr(record1.data.CON_DATE).substring(0, 6) > newValue) {
                            alert("계약일자보다 시작월이 작을수없습니다.");
                            record.set('CON_FR_YYMM', oldValue);
                            break;
                        }
//                        if(UniDate.getDbDateStr(panelResult2.getValue('CON_FR_YYMM')).substring(0, 6) > newValue || UniDate.getDbDateStr(panelResult2.getValue('CON_TO_YYMM')).substring(0, 6) < newValue) {
//                            alert("작업기간 내에서 입력하세요.");
//                            record.set('CON_FR_YYMM', oldValue);
//                            break;
//                        }
                    }
//                    if(UniDate.getDbDateStr(record.set('CON_TO_YYMM')) < newValue) {
//                        alert("시작월보다 종료월이 작을수없습니다.");
//                        record.set('CON_TO_YYMM', oldValue);
//                        break;
//                    }
//                    break;

                case "CON_TO_YYMM" :
                    if(!Ext.isEmpty(record1.data.EXP_DATE)) {
                        if(UniDate.getDbDateStr(record1.data.EXP_DATE).substring(0, 6) < newValue) {
                            alert("만료일보다 종료월이 클수없습니다.");
                            record.set('CON_TO_YYMM', oldValue);
                            break;
                        } else if(UniDate.getDbDateStr(record1.data.CON_DATE).substring(0, 6) > newValue) {
                            alert("계약일자보다 종료월이 작을수없습니다.");
                            record.set('CON_TO_YYMM', oldValue);
                            break;
                        }
//                        if(UniDate.getDbDateStr(panelResult2.getValue('CON_FR_YYMM')).substring(0, 6) > newValue || UniDate.getDbDateStr(panelResult2.getValue('CON_TO_YYMM')).substring(0, 6) < newValue) {
//                            alert("작업기간 내에서 입력하세요.");
//                            record.set('CON_TO_YYMM', oldValue);
//                            break;
//                        }
                    }
//                    if(UniDate.getDbDateStr(record.set('CON_FR_YYMM')) > newValue) {
//                        alert("시작월보다 종료월이 작을수없습니다.");
//                        record.set('CON_TO_YYMM', oldValue);
//                        break;
//                    }
//                    break;
            }
            return rv;
        }
    });

}
</script>