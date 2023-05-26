<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="mre100ukrv"  >
    <t:ExtComboStore comboType="BOR120" pgmId="mre100ukrv"  />          <!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="M001" /> <!-- 발주형태 -->
    <t:ExtComboStore comboType="AU" comboCode="M201" /> <!-- 구매담당 -->
    <t:ExtComboStore comboType="AU" comboCode="M007" /> <!-- 승인여부 -->
    <t:ExtComboStore comboType="AU" comboCode="B038" /> <!-- 결제조건 -->

    <t:ExtComboStore comboType="AU" comboCode="M002" /> <!-- 진행상태 -->
    <t:ExtComboStore comboType="AU" comboCode="B020" /> <!-- 품목계정 -->
    <t:ExtComboStore comboType="AU" comboCode="Q002" /> <!-- 품질대상여부 -->
    <t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" /> <!--창고-->
    <t:ExtComboStore comboType="AU" comboCode="B014" /> <!-- 조달구분 -->
    <t:ExtComboStore comboType="AU" comboCode="B004" /> <!-- 화폐 -->
    <t:ExtComboStore comboType="AU" comboCode="M301" /> <!-- 단가형태 -->
    <t:ExtComboStore comboType="AU" comboCode="B013" /> <!-- 단위 -->
</t:appConfig>
<script type="text/javascript" >

var SearchInfoWindow;       //조회버튼 누르면 나오는 조회창
var referOtherMrpWindow;   //자재소요량참조
var outsidePlWindow;       //외주P/L참조
var itemRequestWindow;     //물품의뢰참조

var BsaCodeInfo = {
    gsAutoType:     '${gsAutoType}',
    gsDefaultMoney: '${gsDefaultMoney}'
};


var outDivCode = UserInfo.divCode;
var aa = 0;
function appMain() {

    var isAutoOrderNum = false;
    if(BsaCodeInfo.gsAutoType=='Y') {
        isAutoOrderNum = true;
    }

    var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 'mre100ukrvService.selectList',
            update: 'mre100ukrvService.updateDetail',
            create: 'mre100ukrvService.insertDetail',
            destroy: 'mre100ukrvService.deleteDetail',
            syncAll: 'mre100ukrvService.saveAll'
        }
    });
    /**
     * Model 정의
     * @type
     */
    Unilite.defineModel('Mre100ukrvModel', {
        fields: [
            {name: 'DIV_CODE'           ,text: '<t:message code="system.label.purchase.division" default="사업장"/>'                    ,type: 'string'},
            {name: 'PO_REQ_NUM'         ,text: '<t:message code="system.label.purchase.purchaserequestno" default="구매요청번호"/>'         ,type: 'string',allowBlank: isAutoOrderNum},
            {name: 'PO_SER_NO'          ,text: '<t:message code="system.label.purchase.seq" default="순번"/>'                 ,type: 'int', allowBlank: false},
            {name: 'ITEM_CODE'          ,text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'               ,type: 'string', allowBlank: false},
            {name: 'ITEM_NAME'          ,text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'                    ,type: 'string'},
            {name: 'SPEC'               ,text: '<t:message code="system.label.purchase.spec" default="규격"/>'                 ,type: 'string'},
            {name: 'STOCK_UNIT'         ,text: '<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>'               ,type: 'string'},
            {name: 'R_ORDER_Q'          ,text: '<t:message code="system.label.purchase.unreceiptqty" default="미입고량"/>'               ,type: 'uniQty'},
            {name: 'PAB_STOCK_Q'        ,text: '<t:message code="system.label.purchase.onhandqty" default="현재고량"/>'               ,type: 'uniQty'},
            {name: 'ORDER_UNIT_Q'       ,text: '발주요청량(재고)'      ,type: 'uniQty', allowBlank: false, editable: false},
            {name: 'ORDER_UNIT'         ,text: '<t:message code="system.label.purchase.purchaseunit" default="구매단위"/>'               ,type: 'string', allowBlank: false,comboType:'AU',comboCode:'B013',displayField: 'value'},
            {name: 'TRNS_RATE'          ,text: '구매입수'               ,type: 'uniQty'},
            {name: 'ORDER_Q'            ,text: '발주요청량'              ,type: 'uniQty', allowBlank: false},
            {name: 'MONEY_UNIT'         ,text: '<t:message code="system.label.purchase.currencyunit" default="화폐단위"/>'               ,type: 'string',comboType:'AU',comboCode:'B004', displayField: 'value'},
            {name: 'EXCHG_RATE_O'       ,text: '<t:message code="system.label.purchase.exchangerate" default="환율"/>'                 ,type: 'uniER'},

            {name: 'UNIT_PRICE_TYPE'    ,text: '<t:message code="system.label.purchase.pricetype" default="단가형태"/>'               ,type: 'string',comboType:'AU',comboCode:'M301', allowBlank: false},
            {name: 'ORDER_P'            ,text: '<t:message code="system.label.purchase.price" default="단가"/>'                 ,type: 'uniUnitPrice', allowBlank: false},
            {name: 'ORDER_O'            ,text: '<t:message code="system.label.purchase.amount" default="금액"/>'                 ,type: 'uniPrice'},
            {name: 'ORDER_LOC_P'        ,text: '<t:message code="system.label.purchase.coprice" default="자사단가"/>'               ,type: 'uniUnitPrice'},
            {name: 'ORDER_LOC_O'        ,text: '<t:message code="system.label.purchase.coamount" default="자사금액"/>'               ,type: 'uniPrice'},

            {name: 'DVRY_DATE'          ,text: '<t:message code="system.label.purchase.deliverydate" default="납기일"/>'                    ,type: 'uniDate', allowBlank: false},
            {name: 'WH_CODE'            ,text: '<t:message code="system.label.purchase.deliverywarehouse" default="납품창고"/>'               ,type: 'string',store: Ext.data.StoreManager.lookup('whList'), allowBlank: false},
            {name: 'SUPPLY_TYPE'        ,text: '<t:message code="system.label.purchase.procurementclassification" default="조달구분"/>'               ,type: 'string',comboType:'AU',comboCode:'B014'},
            {name: 'CUSTOM_CODE'        ,text: '<t:message code="system.label.purchase.custom" default="거래처"/>'                    ,type: 'string'},
            {name: 'CUSTOM_NAME'        ,text: '<t:message code="system.label.purchase.customname" default="거래처명"/>'               ,type: 'string'},

            {name: 'PO_REQ_DATE'        ,text: '<t:message code="system.label.purchase.poreservedate" default="발주예정일"/>'              ,type: 'uniDate'},
            {name: 'INSPEC_FLAG'        ,text: '<t:message code="system.label.purchase.qualityyn" default="품질대상여부"/>'         ,type: 'string',comboType:'AU',comboCode:'Q002', allowBlank: false},
            {name: 'REMARK'             ,text: '<t:message code="system.label.purchase.remarks" default="비고"/>'                 ,type: 'string'},

            {name: 'ORDER_REQ_NUM'      ,text: '<t:message code="system.label.purchase.poreserveno" default="발주예정번호"/>'         ,type: 'string'},
            {name: 'MRP_CONTROL_NUM'    ,text: 'MRP번호'              ,type: 'string'},
            {name: 'ORDER_YN'           ,text: '<t:message code="system.label.purchase.processstatus" default="진행상태"/>'               ,type: 'string'},
            {name: 'ITEM_REQ_SEQ'       ,text: '물품의뢰순번'           ,type: 'string'},
            {name: 'ITEM_REQ_NUM'       ,text: '물품의뢰번호'           ,type: 'string'},

            {name: 'PURCH_LDTIME'       ,text: '구매LT'               ,type: 'uniQty'},
            {name: 'COMP_CODE'          ,text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'               ,type: 'string'},
            {name: 'UPDATE_DB_USER'     ,text: 'UPDATE_DB_USER'         ,type: 'string'},
            {name: 'UPDATE_DB_TIME'     ,text: 'UPDATE_DB_TIME'         ,type: 'string'}
        ]
    });

    Unilite.defineModel('orderNoMasterModel', {     //조회버튼 누르면 나오는 조회창(구매요청번호)
        fields: [
            {name: 'PO_REQ_DATE'                , text: '<t:message code="system.label.purchase.requestdate" default="요청일"/>'      , type: 'uniDate'},
            {name: 'SUPPLY_TYPE'                , text: '<t:message code="system.label.purchase.procurementclassification" default="조달구분"/>'      , type: 'string',comboType:'AU', comboCode:'B014'},
            {name: 'PO_REQ_NUM'                 , text: '<t:message code="system.label.purchase.purchaserequestno" default="구매요청번호"/>'  , type: 'string'},
            {name: 'DEPT_CODE'                  , text: '<t:message code="system.label.purchase.departmencode" default="부서코드"/>'      , type: 'string'},
            {name: 'DEPT_NAME'                  , text: '<t:message code="system.label.purchase.departmentname" default="부서명"/>'           , type: 'string'},
            {name: 'PERSON_NUMB'                , text: '<t:message code="system.label.purchase.charger" default="담당자"/>'       , type: 'string'},
            {name: 'PERSON_NAME'                , text: '담당자명'      , type: 'string'},
            {name: 'MONEY_UNIT'                 , text: '<t:message code="system.label.purchase.currency" default="화폐"/>'            , type: 'string'},
            {name: 'EXCHG_RATE_O'               , text: '<t:message code="system.label.purchase.exchangerate" default="환율"/>'            , type: 'string'},
            {name: 'ITEM_ACCOUNT'               , text: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>'      , type: 'string', comboType:'AU',comboCode:'B020'},
            {name: 'DIV_CODE'                   , text: '<t:message code="system.label.purchase.division" default="사업장"/>'       , type: 'string',comboType:'BOR120'}
        ]
    });

    Unilite.defineModel('mre100ukrvOtherModel', {   //자재소요량 참조
        fields: [
            {name: 'ORDER_PLAN_DATE'            , text: '<t:message code="system.label.purchase.poreservedate" default="발주예정일"/>'         , type: 'uniDate'},
            {name: 'ORDER_REQ_NUM'              , text: '<t:message code="system.label.purchase.poreserveno" default="발주예정번호"/>'    , type: 'string'},
            {name: 'CUSTOM_CODE'                , text: '<t:message code="system.label.purchase.customcode" default="거래처코드"/>'         , type: 'string'},
            {name: 'CUSTOM_NAME'                , text: '<t:message code="system.label.purchase.customname" default="거래처명"/>'          , type: 'string'},
            {name: 'ITEM_CODE'                  , text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'          , type: 'string', allowBlank: false},
            {name: 'ITEM_NAME'                  , text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'           , type: 'string'},
            {name: 'SPEC'                       , text: '<t:message code="system.label.purchase.spec" default="규격"/>'                , type: 'string'},
            {name: 'STOCK_UNIT'                 , text: '<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>'          , type: 'string'},
            {name: 'ORDER_PLAN_Q'               , text: '발주계획량'     , type: 'uniQty'},
            {name: 'REQ_PLAN_Q'                 , text: '발주요청량(재고)'  , type: 'uniQty'},
            {name: 'REMAIN_Q'                   , text: '잔량'                , type: 'uniQty'},
            {name: 'SUPPLY_TYPE'                , text: '<t:message code="system.label.purchase.procurementclassification" default="조달구분"/>'          , type: 'string',comboType:'AU', comboCode:'B014'},
            {name: 'PAB_STOCK_Q'                , text: '<t:message code="system.label.purchase.availableinventoryqty" default="가용재고량"/>'          , type: 'uniQty'},
            {name: 'DOM_FORIGN'                 , text: '<t:message code="system.label.purchase.domesticoverseasclass" default="국내외구분"/>'     , type: 'string',comboType:'AU', comboCode:'T109'},
            {name: 'MRP_CONTROL_NUM'            , text: '<t:message code="system.label.purchase.requestno" default="요청번호"/>'          , type: 'string'},
            {name: 'WKORD_NUM'                  , text: '<t:message code="system.label.purchase.workorderno" default="작업지시번호"/>'        , type: 'string'},
            {name: 'ORDER_NUM'                  , text: '<t:message code="system.label.purchase.sono" default="수주번호"/>'          , type: 'string'},
            {name: 'ORDER_SEQ'                  , text: '<t:message code="system.label.purchase.soseq" default="수주순번"/>'          , type: 'uniQty'},
            {name: 'PROJECT_NO'                 , text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'        , type: 'string'},
            {name: 'INPUT_REMAIN_QTY'           , text: '<t:message code="system.label.purchase.unreceiptqty" default="미입고량"/>'          , type: 'uniQty'},
            {name: 'ORDER_UNIT'                 , text: '<t:message code="system.label.purchase.purchaseunit" default="구매단위"/>'          , type: 'string'},
            {name: 'TRNS_RATE'                  , text: '구매입수'          , type: 'uniQty'},
            {name: 'PURCH_LDTIME'               , text: '구매LT'          , type: 'uniQty'},
            {name: 'DVRY_DATE'                  , text: '<t:message code="system.label.purchase.deliverydate" default="납기일"/>'               , type: 'string'},
            {name: 'ORDER_Q'                    , text: '발주요청량'         , type: 'uniQty'}
        ]
    });

    Unilite.defineModel('mre100ukrvOutsidePlModel', {  //외주P/L 참조
        fields: [
            {name: 'COMP_CODE'              , text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'         , type: 'string'},
            {name: 'DIV_CODE'               , text: '<t:message code="system.label.purchase.division" default="사업장"/>'           , type: 'string'},
            {name: 'CHILD_ITEM_CODE'        , text: '소요자재코드'     , type: 'string'},
            {name: 'CHILD_ITEM_NAME'        , text: '소요자재명'       , type: 'string'},
            {name: 'SPEC1'                  , text: '<t:message code="system.label.purchase.spec" default="규격"/>'             , type: 'string'},
            {name: 'PROD_ITEM_CODE'         , text: '외주품목코드'     , type: 'string'},
            {name: 'PROD_ITEM_NAME'         , text: '외주품목명'       , type: 'string'},
            {name: 'SPEC2'                  , text: '<t:message code="system.label.purchase.spec" default="규격"/>'             , type: 'string'},
            {name: 'UNIT_Q'                 , text: '<t:message code="system.label.purchase.originunitqty" default="원단위량"/>'         , type: 'uniQty'}
        ]
    });

    Unilite.defineModel('mre100ukrvItemRequestModel', {  //품목의뢰 참조
        fields: [
            {name: 'COMP_CODE'             , text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'             , type: 'string'},
            {name: 'DIV_CODE'              , text: '<t:message code="system.label.purchase.division" default="사업장"/>'               , type: 'string'},
            {name: 'ITEM_REQ_NUM'          , text: '품목의뢰번호'         , type: 'string'},
            {name: 'ITEM_REQ_SEQ'          , text: '의뢰순번'             , type: 'int'},
            {name: 'ITEM_CODE'             , text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'             , type: 'string'},
            {name: 'ITEM_NAME'             , text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'               , type: 'string'},
            {name: 'SPEC'                  , text: '<t:message code="system.label.purchase.spec" default="규격"/>'                 , type: 'string'},
            {name: 'STOCK_UNIT'            , text: '<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>'             , type: 'string'},
            {name: 'REQ_Q'                 , text: '의뢰량'               , type: 'uniQty'},
            {name: 'DEPT_CODE'             , text: '<t:message code="system.label.purchase.department" default="부서"/>'                 , type: 'string'},
            {name: 'PERSON_NUMB'           , text: '사원'                 , type: 'string'},
            {name: 'ITEM_REQ_DATE'         , text: '의뢰일'               , type: 'uniDate'},
            {name: 'MONEY_UNIT'            , text: '<t:message code="system.label.purchase.currencyunit" default="화폐단위"/>'             , type: 'string'},
            {name: 'EXCHG_RATE_O'          , text: '<t:message code="system.label.purchase.exchangerate" default="환율"/>'                 , type: 'uniER'},
            {name: 'DELIVERY_DATE'         , text: '<t:message code="system.label.purchase.deliverydate" default="납기일"/>'               , type: 'uniDate'},
            {name: 'USE_REMARK'            , text: '용도'                 , type: 'string'},
            {name: 'GW_DOCU_NUM'           , text: 'GW문서번호'           , type: 'string'},
            {name: 'GW_FLAG'               , text: 'GW기안상태'           , type: 'string'},
            {name: 'NEXT_YN'               , text: '<t:message code="system.label.purchase.processstatus" default="진행상태"/>'             , type: 'string'}
        ]
    });

    /**
     * Store 정의(Service 정의)
     * @type
     */
    var directMasterStore1 = Unilite.createStore('mre100ukrvMasterStore1',{
        model: 'Mre100ukrvModel',
        uniOpt: {
            isMaster: true,         // 상위 버튼 연결
            editable: true,         // 수정 모드 사용
            deletable: true,            // 삭제 가능 여부
            allDeletable: true,
            useNavi: false              // prev | newxt 버튼 사용
        },
            autoLoad: false,
        proxy: directProxy,
        listeners: {
            load: function(store, records, successful, eOpts) {
                this.fnSumOrderO();
            },
            add: function(store, records, index, eOpts) {
                this.fnSumOrderO();
            },
            update: function(store, record, operation, modifiedFieldNames, eOpts) {
                this.fnSumOrderO();
            },
            remove: function(store, record, index, isMove, eOpts) {
                this.fnSumOrderO();
            }
        },
        loadStoreRecords: function() {
            var param= panelSearch.getValues();
            console.log(param);
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
            console.log("list:", list);
            var paramMaster= panelSearch.getValues();   //syncAll 수정
            if(inValidRecs.length == 0) {
                config = {
                    params: [paramMaster],
                    success: function(batch, option) {
                        var master = batch.operations[0].getResultSet();
                        panelSearch.setValue("PO_REQ_NUM", master.PO_REQ_NUM);
                        panelResult.setValue("PO_REQ_NUM", master.PO_REQ_NUM);
                        panelSearch.getForm().wasDirty = false;
                        panelSearch.resetDirtyStatus();
                        console.log("set was dirty to false");
                        UniAppManager.setToolbarButtons('save', false);
                        if(directMasterStore1.getCount() == 0){
                            UniAppManager.app.onResetButtonDown();
                        }
                    }
                };
                this.syncAllDirect(config);
            } else {
                var grid = Ext.getCmp('mre100ukrvGrid');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
        },
        fnSumOrderO: function() {
            console.log("=============Exec fnOrderAmtSum()");
            var sSumOrderO = Ext.isNumeric(this.sum('ORDER_O')) ? this.sum('ORDER_O'):0;
            var sSumOrderLocO = Ext.isNumeric(this.sum('ORDER_LOC_O')) ? this.sum('ORDER_LOC_O'):0;
            //panelSearch.setValue('SumOrderO',sSumOrderO);
            //panelSearch.setValue('SumOrderLocO',sSumOrderLocO);
        }
    });

    var orderNoMasterStore = Unilite.createStore('orderNoMasterStore', {    //조회버튼 누르면 나오는 조회창(구매요청번호)
        model: 'orderNoMasterModel',
        autoLoad: false,
        uniOpt: {
            isMaster: false,            // 상위 버튼 연결
            editable: false,            // 수정 모드 사용
            deletable:false,            // 삭제 가능 여부
            useNavi : false         // prev | newxt 버튼 사용
        },
        proxy: {
            type: 'direct',
            api: {
                read    : 'mre100ukrvService.selectOrderNumMasterList'
            }
        },
        loadStoreRecords : function()   {
            var param= orderNoSearch.getValues();
            var authoInfo = pgmInfo.authoUser;              //권한정보(N-전체,A-자기사업장>5-자기부서)
            var deptCode = UserInfo.deptCode;   //부서코드
            if(authoInfo == "5" && Ext.isEmpty(orderNoSearch.getValue('DEPT_CODE'))){
                param.DEPT_CODE = deptCode;
            }
            console.log( param );
            this.load({
                params : param
            });
        }
    });

    var otherOrderStore = Unilite.createStore('mre100ukrvOtherOrderStore', {   //자재소요량정보 참조
        model: 'mre100ukrvOtherModel',
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
                read: 'mre100ukrvService.selectMrpList'
            }
        },
        listeners:{
            load:function(store, records, successful, eOpts) {
                if(successful)  {
                   var masterRecords = directMasterStore1.data.filterBy(directMasterStore1.filterNewOnly);
                   var orderRecords = new Array();
                   if(masterRecords.items.length > 0)   {
                        console.log("store.items :", store.items);
                        console.log("records", records);
                        Ext.each(records,
                            function(item, i)   {
                                Ext.each(masterRecords.items, function(record, i)   {
                                    console.log("record :", record);
                                    if((record.data['ORDER_REQ_NUM'] == item.data['ORDER_REQ_NUM'])){
                                        orderRecords.push(item);
                                    }
                                });
                            });
                       store.remove(orderRecords);
                   }
                }
            }
        },
        loadStoreRecords : function()   {
            var param= otherorderSearch.getValues();
            var authoInfo = pgmInfo.authoUser;              //권한정보(N-전체,A-자기사업장>5-자기부서)
            var deptCode = UserInfo.deptCode;   //부서코드
            if(authoInfo == "5" && Ext.isEmpty(otherorderSearch.getValue('DEPT_CODE'))){
                param.DEPT_CODE = deptCode;
            }
            console.log( param );
            this.load({
                params : param
            });
        }
    });

    var outsidePlStore = Unilite.createStore('mre100ukrvOutsidePlStore', {   //외주P/L 참조
        model: 'mre100ukrvOutsidePlModel',
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
                read: 'mre100ukrvService.selectOutsidePlList'
            }
        },
        listeners:{
            load:function(store, records, successful, eOpts) {
                if(successful)  {
                   var masterRecords = directMasterStore1.data.filterBy(directMasterStore1.filterNewOnly);
                   var orderRecords = new Array();
                   if(masterRecords.items.length > 0)   {
                        console.log("store.items :", store.items);
                        console.log("records", records);
                        Ext.each(records,
                            function(item, i)   {
                                Ext.each(masterRecords.items, function(record, i)   {
                                    console.log("record :", record);

                                        if( (record.data['PO_REQ_NUM'] == item.data['PO_REQ_NUM'])
                                         && (record.data['PO_SER_NO'] == item.data['PO_SER_NO'])
                                          ){
                                            orderRecords.push(item);
                                        }
                                });
                            });
                       store.remove(orderRecords);
                   }
                }
            }
        },
        loadStoreRecords : function()   {
            var param= outsidePlSearch.getValues();
            console.log( param );
            this.load({
                params : param
            });
        }
    });

    var itemRequestStore = Unilite.createStore('mre100ukrvOutsidePlStore', {   //물품의뢰 참조
        model: 'mre100ukrvItemRequestModel',
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
                read: 'mre100ukrvService.selectItemRequestList'
            }
        },
        loadStoreRecords : function()   {
            var param= itemRequestSearch.getValues();
            console.log( param );
            this.load({
                params : param
            });
        }
    });

    /**
     * 검색조건 (Search Panel)
     * @type
     */
    var panelSearch = Unilite.createSearchPanel('searchForm', {
        title: '구매요청조건',
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
            title: '<t:message code="system.label.purchase.basisinfo" default="기본정보"/>',
            itemId: 'search_panel1',
            layout: {type: 'uniTable', columns: 1},
            defaultType: 'uniTextfield',
            items:[{
                fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
                name:'DIV_CODE',
                xtype: 'uniCombobox',
                comboType:'BOR120',
                allowBlank:false,
                holdable: 'hold',
                value: UserInfo.divCode,
                listeners: {
                    change: function(combo, newValue, oldValue, eOpts) {
                        panelResult.setValue('DIV_CODE', newValue);
                    }
                }
            },
            {
                fieldLabel:'<t:message code="system.label.purchase.purchaserequestno" default="구매요청번호"/>',
                name: 'PO_REQ_NUM',
                xtype: 'uniTextfield',
                holdable: 'hold',
                readOnly: isAutoOrderNum,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('PO_REQ_NUM', newValue);
                    }
                }
            },
            {
                fieldLabel: '<t:message code="system.label.purchase.requestdate" default="요청일"/>',
                xtype: 'uniDatefield',
                name: 'PO_REQ_DATE',
                value: UniDate.get('today'),
                allowBlank:false,
                holdable: 'hold',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('PO_REQ_DATE', newValue);
                    }
                }
            },
            Unilite.popup('DEPT', {
                fieldLabel: '<t:message code="system.label.purchase.department" default="부서"/>',
                valueFieldName: 'DEPT_CODE',
                textFieldName: 'DEPT_NAME',
                holdable: 'hold',
                listeners: {
                    onSelected: {
                        fn: function(records, type) {
                            panelResult.setValue('DEPT_CODE', panelSearch.getValue('DEPT_CODE'));
                            panelResult.setValue('DEPT_NAME', panelSearch.getValue('DEPT_NAME'));
                        },
                        scope: this
                    },
                    onClear: function(type) {
                        panelResult.setValue('DEPT_CODE', '');
                        panelResult.setValue('DEPT_NAME', '');
                    },
                    applyextparam: function(popup){
                        var authoInfo = pgmInfo.authoUser;              //권한정보(N-전체,A-자기사업장>5-자기부서)
                        var deptCode = UserInfo.deptCode;   //부서정보
                        var divCode = '';                   //사업장
                        if(authoInfo == "A"){   //자기사업장
                            popup.setExtParam({'TREE_CODE': ""});
                            popup.setExtParam({'DIV_CODE': UserInfo.divCode});
                        }else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){   //전체권한
                            popup.setExtParam({'TREE_CODE': ""});
                            popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
                        }else if(authoInfo == "5"){     //부서권한
                            popup.setExtParam({'TREE_CODE': UserInfo.deptCode});
                            popup.setExtParam({'DIV_CODE': UserInfo.divCode});
                        }
                    }
                }
            }),
            Unilite.popup('Employee',{
                fieldLabel: '사원',
                valueFieldName:'PERSON_NUMB',
                textFieldName:'PERSON_NAME',
                holdable: 'hold',
                autoPopup:true,
                listeners: {
                    onValueFieldChange: function(field, newValue){
                        panelResult.setValue('PERSON_NUMB', newValue);
                    },
                    onTextFieldChange: function(field, newValue){
                        panelResult.setValue('PERSON_NAME', newValue);
                    }
                }
            }),
            {
                fieldLabel: '<t:message code="system.label.purchase.currency" default="화폐"/>',
                name:'MONEY_UNIT',
                fieldStyle: 'text-align: center;',
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'B004',
                displayField: 'value',
                allowBlank:false,
                holdable: 'hold',
                fieldStyle: 'text-align: center;',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('MONEY_UNIT', newValue);
//                        UniAppManager.app.fnExchngRateO();
                    },
                    blur: function( field, The, eOpts )    {
                       UniAppManager.app.fnExchngRateO();
                    }
                }
            },
            {
                fieldLabel: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>',
                name: 'ITEM_ACCOUNT',
                xtype: 'uniCombobox',
                comboType: 'AU',
                comboCode: 'B020',
                readOnly: false,
                holdable: 'hold',
                listeners: {
                    change: function(combo, newValue, oldValue, eOpts) {
                        combo.changeDivCode(combo, newValue, oldValue, eOpts);
                        panelResult.setValue('ITEM_ACCOUNT', newValue);
                    }
                }
            },
            {
                fieldLabel:'<t:message code="system.label.purchase.exchangerate" default="환율"/>',
                name: 'EXCHG_RATE_O',
                xtype: 'uniNumberfield',
                allowBlank:false,
                decimalPrecision: 4,
                value: 1,
                holdable: 'hold',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('EXCHG_RATE_O', newValue);
                    }
                }
            },
            {
                fieldLabel: '<t:message code="system.label.purchase.procurementclassification" default="조달구분"/>',
                name: 'SUPPLY_TYPE',
                xtype: 'uniCombobox',
                comboType: 'AU',
                comboCode: 'B014',
                allowBlank:false,
                holdable: 'hold',
                listeners: {
                    change: function(combo, newValue, oldValue, eOpts) {
                        panelResult.setValue('SUPPLY_TYPE', newValue);
                    }
                }
            }]
        }],
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
                        var labelText = invalid.items[0]['fieldLabel']+':';
                    } else if(Ext.isDefined(invalid.items[0].ownerCt)) {
                        var labelText = invalid.items[0].ownerCt['fieldLabel']+':';
                    }
                    alert(labelText+Msg.sMB083);
                    invalid.items[0].focus();
                } else {
                    var fields = this.getForm().getFields();
                    Ext.each(fields.items, function(item) {
                        if(Ext.isDefined(item.holdable) )   {
                            if (item.holdable == 'hold') {
                                item.setReadOnly(true);
                            }
                        }
                        if(item.isPopupField)   {
                            var popupFC = item.up('uniPopupField')  ;
                            if(popupFC.holdable == 'hold') {
                                popupFC.setReadOnly(true);
                            }
                        }
                    })
                }
            } else {
                var fields = this.getForm().getFields();
                Ext.each(fields.items, function(item) {
                    if(Ext.isDefined(item.holdable) )   {
                        if (item.holdable == 'hold') {
                            item.setReadOnly(false);
                        }
                    }
                    if(item.isPopupField)   {
                        var popupFC = item.up('uniPopupField')  ;
                        if(popupFC.holdable == 'hold' ) {
                            item.setReadOnly(false);
                        }
                    }
                })
            }
            return r;
        }
    });

    var panelResult = Unilite.createSearchForm('resultForm',{
        hidden: !UserInfo.appOption.collapseLeftSearch,
        region: 'north',
        layout : {type : 'uniTable', columns : 3},
        padding:'1 1 1 1',
        border:true,
        items: [{
            fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
            name:'DIV_CODE',
            xtype: 'uniCombobox',
            comboType:'BOR120',
            allowBlank:false,
            holdable: 'hold',
            value: UserInfo.divCode,
            listeners: {
                change: function(combo, newValue, oldValue, eOpts) {
                    panelSearch.setValue('DIV_CODE', newValue);
                }
            }
        },
        {
            fieldLabel:'<t:message code="system.label.purchase.purchaserequestno" default="구매요청번호"/>',
            name: 'PO_REQ_NUM',
            xtype: 'uniTextfield',
            holdable: 'hold',
            readOnly: isAutoOrderNum,
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.setValue('PO_REQ_NUM', newValue);
                }
            }
        },
        {
            fieldLabel: '<t:message code="system.label.purchase.requestdate" default="요청일"/>',
            xtype: 'uniDatefield',
            name: 'PO_REQ_DATE',
            value: UniDate.get('today'),
            allowBlank:false,
            holdable: 'hold',
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.setValue('PO_REQ_DATE', newValue);
                }
            }
        },
        Unilite.popup('DEPT', {
            fieldLabel: '<t:message code="system.label.purchase.department" default="부서"/>',
            valueFieldName: 'DEPT_CODE',
            textFieldName: 'DEPT_NAME',
            holdable: 'hold',
            listeners: {
                onSelected: {
                    fn: function(records, type) {
                        panelSearch.setValue('DEPT_CODE', panelResult.getValue('DEPT_CODE'));
                        panelSearch.setValue('DEPT_NAME', panelResult.getValue('DEPT_NAME'));
                    },
                    scope: this
                },
                onClear: function(type) {
                    panelSearch.setValue('DEPT_CODE', '');
                    panelSearch.setValue('DEPT_NAME', '');
                },
                applyextparam: function(popup){
                    var authoInfo = pgmInfo.authoUser;              //권한정보(N-전체,A-자기사업장>5-자기부서)
                    var deptCode = UserInfo.deptCode;   //부서정보
                    var divCode = '';                   //사업장
                    if(authoInfo == "A"){   //자기사업장
                        popup.setExtParam({'TREE_CODE': ""});
                        popup.setExtParam({'DIV_CODE': UserInfo.divCode});
                    }else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){   //전체권한
                        popup.setExtParam({'TREE_CODE': ""});
                        popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
                    }else if(authoInfo == "5"){     //부서권한
                        popup.setExtParam({'TREE_CODE': UserInfo.deptCode});
                        popup.setExtParam({'DIV_CODE': UserInfo.divCode});
                    }
                }
            }
        }),
        Unilite.popup('Employee',{
            fieldLabel: '사원',
            valueFieldName:'PERSON_NUMB',
            textFieldName:'PERSON_NAME',
            holdable: 'hold',
            autoPopup:true,
            listeners: {
                onValueFieldChange: function(field, newValue){
                    panelSearch.setValue('PERSON_NUMB', newValue);
                },
                onTextFieldChange: function(field, newValue){
                    panelSearch.setValue('PERSON_NAME', newValue);
                }
            }
        }),
        {
            fieldLabel: '<t:message code="system.label.purchase.currency" default="화폐"/>',
            name:'MONEY_UNIT',
            fieldStyle: 'text-align: center;',
            xtype: 'uniCombobox',
            comboType:'AU',
            comboCode:'B004',
            displayField: 'value',
            allowBlank:false,
            holdable: 'hold',
            fieldStyle: 'text-align: center;',
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.setValue('MONEY_UNIT', newValue);
//                    UniAppManager.app.fnExchngRateO();
                },
                blur: function( field, The, eOpts )    {
                   UniAppManager.app.fnExchngRateO();
                }
            }
        },
        {
            fieldLabel: '<t:message code="system.label.purchase.procurementclassification" default="조달구분"/>',
            name: 'SUPPLY_TYPE',
            xtype: 'uniCombobox',
            comboType: 'AU',
            comboCode: 'B014',
            allowBlank:false,
            holdable: 'hold',
            listeners: {
                change: function(combo, newValue, oldValue, eOpts) {
                    panelSearch.setValue('SUPPLY_TYPE', newValue);
                }
            }
        },
        {
            fieldLabel: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>',
            name: 'ITEM_ACCOUNT',
            xtype: 'uniCombobox',
            comboType: 'AU',
            comboCode: 'B020',
            readOnly: false,
            holdable: 'hold',
            listeners: {
                change: function(combo, newValue, oldValue, eOpts) {
                    combo.changeDivCode(combo, newValue, oldValue, eOpts);
                    panelSearch.setValue('ITEM_ACCOUNT', newValue);
                }
            }
        },
        {
            fieldLabel:'<t:message code="system.label.purchase.exchangerate" default="환율"/>',
            name: 'EXCHG_RATE_O',
            xtype: 'uniNumberfield',
            allowBlank:false,
            decimalPrecision: 4,
            value: 1,
            holdable: 'hold',
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.setValue('EXCHG_RATE_O', newValue);
                }
            }
        }],
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
                        var labelText = invalid.items[0]['fieldLabel']+':';
                    } else if(Ext.isDefined(invalid.items[0].ownerCt)) {
                        var labelText = invalid.items[0].ownerCt['fieldLabel']+':';
                    }
                    alert(labelText+Msg.sMB083);
                    invalid.items[0].focus();
                } else {
                    var fields = this.getForm().getFields();
                    Ext.each(fields.items, function(item) {
                        if(Ext.isDefined(item.holdable) )   {
                            if (item.holdable == 'hold') {
                                item.setReadOnly(true);
                            }
                        }
                        if(item.isPopupField)   {
                            var popupFC = item.up('uniPopupField')  ;
                            if(popupFC.holdable == 'hold') {
                                popupFC.setReadOnly(true);
                            }
                        }
                    })
                }
            } else {
                var fields = this.getForm().getFields();
                Ext.each(fields.items, function(item) {
                    if(Ext.isDefined(item.holdable) )   {
                        if (item.holdable == 'hold') {
                            item.setReadOnly(false);
                        }
                    }
                    if(item.isPopupField)   {
                        var popupFC = item.up('uniPopupField')  ;
                        if(popupFC.holdable == 'hold' ) {
                            item.setReadOnly(false);
                        }
                    }
                })
            }
            return r;
        }
    });

    var orderNoSearch = Unilite.createSearchForm('orderNoSearchForm', {     //조회버튼 누르면 나오는 조회창
        layout: {type: 'uniTable', columns : 3},
        trackResetOnLoad: true,
        items: [{
            fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
            name:'DIV_CODE',
            xtype: 'uniCombobox',
            comboType:'BOR120',
            value: UserInfo.divCode,
            allowBlank: false
        },
        {
            fieldLabel: '<t:message code="system.label.purchase.requestdate" default="요청일"/>',
            xtype: 'uniDateRangefield',
            startFieldName: 'PO_REQ_DATE_FR',
            endFieldName: 'PO_REQ_DATE_TO',
            allowBlank: false,
            startDate: UniDate.get('startOfMonth'),
            endDate: UniDate.get('today'),
            width: 315
        },
        Unilite.popup('DEPT', {
            fieldLabel: '<t:message code="system.label.purchase.department" default="부서"/>',
            valueFieldName: 'DEPT_CODE',
            textFieldName: 'DEPT_NAME',
            listeners: {
                applyextparam: function(popup){
                    var authoInfo = pgmInfo.authoUser;              //권한정보(N-전체,A-자기사업장>5-자기부서)
                    var deptCode = UserInfo.deptCode;   //부서정보
                    var divCode = '';                   //사업장
                    if(authoInfo == "A"){   //자기사업장
                        popup.setExtParam({'DEPT_CODE': ""});
                        popup.setExtParam({'DIV_CODE': UserInfo.divCode});
                    }else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){   //전체권한
                        popup.setExtParam({'DEPT_CODE': ""});
                        popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
                    }else if(authoInfo == "5"){     //부서권한
                        popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
                        popup.setExtParam({'DIV_CODE': UserInfo.divCode});
                    }
                }
            }
        }),
        {
            fieldLabel: '<t:message code="system.label.purchase.procurementclassification" default="조달구분"/>',
            name: 'SUPPLY_TYPE',
            xtype: 'uniCombobox',
            comboType: 'AU',
            comboCode: 'B014',
            listeners: {
                change: function(combo, newValue, oldValue, eOpts) {
                    panelSearch.setValue('SUPPLY_TYPE', newValue);
                }
            }
        },
        {
            fieldLabel: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>',
            name: 'ITEM_ACCOUNT',
            xtype: 'uniCombobox',
            comboType: 'AU',
            comboCode: 'B020',
            listeners: {
                change: function(combo, newValue, oldValue, eOpts) {
                    panelSearch.setValue('ITEM_ACCOUNT', newValue);
                }
            }
        },
        Unilite.popup('Employee',{
            fieldLabel: '사원',
            valueFieldName:'PERSON_NUMB',
            textFieldName:'PERSON_NAME',
            autoPopup:true,
            listeners: {
                onValueFieldChange: function(field, newValue){
                    panelSearch.setValue('PERSON_NUMB', newValue);
                },
                onTextFieldChange: function(field, newValue){
                    panelSearch.setValue('PERSON_NAME', newValue);
                }
            }
        })],
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
                        var labelText = invalid.items[0]['fieldLabel']+':';
                    } else if(Ext.isDefined(invalid.items[0].ownerCt)) {
                        var labelText = invalid.items[0].ownerCt['fieldLabel']+':';
                    }
                    alert(labelText+Msg.sMB083);
                    invalid.items[0].focus();
                } else {
                    var fields = this.getForm().getFields();
                    Ext.each(fields.items, function(item) {
                        if(Ext.isDefined(item.holdable) )   {
                            if (item.holdable == 'hold') {
                                item.setReadOnly(true);
                            }
                        }
                        if(item.isPopupField)   {
                            var popupFC = item.up('uniPopupField')  ;
                            if(popupFC.holdable == 'hold') {
                                popupFC.setReadOnly(true);
                            }
                        }
                    })
                }
            } else {
                var fields = this.getForm().getFields();
                Ext.each(fields.items, function(item) {
                    if(Ext.isDefined(item.holdable) )   {
                        if (item.holdable == 'hold') {
                            item.setReadOnly(false);
                        }
                    }
                    if(item.isPopupField)   {
                        var popupFC = item.up('uniPopupField')  ;
                        if(popupFC.holdable == 'hold' ) {
                            item.setReadOnly(false);
                        }
                    }
                })
            }
            return r;
        }
    });

    var otherorderSearch = Unilite.createSearchForm('otherorderForm', {     //자재소요량 참조
        layout: {type : 'uniTable', columns : 4},
        items :[{
            fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
            name:'DIV_CODE',
            xtype: 'uniCombobox',
            allowBlank:false,
            comboType:'BOR120'
        },
        {
            fieldLabel: '<t:message code="system.label.purchase.poreservedate" default="발주예정일"/>',
            xtype: 'uniDateRangefield',
            startFieldName: 'ORDER_PLAN_DATE_FR',
            endFieldName: 'ORDER_PLAN_DATE_TO',
            startDate: UniDate.get('startOfMonth'),
            endDate: UniDate.get('today')
        },
        Unilite.popup('CUST', {
            fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
            valueFieldName:'CUSTOM_CODE',
            textFieldName:'CUSTOM_NAME',
            extParam: {'CUSTOM_TYPE': ['1','2']},
            colspan: 2
        }),
        {
            fieldLabel: '<t:message code="system.label.purchase.procurementclassification" default="조달구분"/>',
            name: 'SUPPLY_TYPE',
            xtype: 'uniCombobox',
            comboType: 'AU',
            comboCode: 'B014',
            readOnly: true
        },
        Unilite.popup('DIV_PUMOK', {
            fieldLabel: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
            //textFieldWidth: 170,
            validateBlank: false
        }),
        {
            fieldLabel: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>',
            name: 'ITEM_ACCOUNT',
            xtype: 'uniCombobox',
            comboType: 'AU',
            comboCode: 'B020'
        }/*,{
          fieldLabel: '<t:message code="system.label.purchase.spec" default="규격"/>',
          name: 'SPEC',
          xtype: 'uniTextfield'
        }*/],
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
                        var labelText = invalid.items[0]['fieldLabel']+':';
                    } else if(Ext.isDefined(invalid.items[0].ownerCt)) {
                        var labelText = invalid.items[0].ownerCt['fieldLabel']+':';
                    }
                    alert(labelText+Msg.sMB083);
                    invalid.items[0].focus();
                } else {
                    var fields = this.getForm().getFields();
                    Ext.each(fields.items, function(item) {
                        if(Ext.isDefined(item.holdable) )   {
                            if (item.holdable == 'hold') {
                                item.setReadOnly(true);
                            }
                        }
                        if(item.isPopupField)   {
                            var popupFC = item.up('uniPopupField')  ;
                            if(popupFC.holdable == 'hold') {
                                popupFC.setReadOnly(true);
                            }
                        }
                    })
                }
            } else {
                var fields = this.getForm().getFields();
                Ext.each(fields.items, function(item) {
                    if(Ext.isDefined(item.holdable) )   {
                        if (item.holdable == 'hold') {
                            item.setReadOnly(false);
                        }
                    }
                    if(item.isPopupField)   {
                        var popupFC = item.up('uniPopupField')  ;
                        if(popupFC.holdable == 'hold' ) {
                            item.setReadOnly(false);
                        }
                    }
                })
            }
            return r;
        }
    });

    var outsidePlSearch = Unilite.createSearchForm('outSidePlForm', {     //외주P/L 참조
        layout: {type : 'uniTable', columns : 3},
        items :[{
            fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
            name:'DIV_CODE',
            xtype: 'uniCombobox',
            allowBlank:false,
            comboType:'BOR120'
        },
        {
            fieldLabel: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>',
            name: 'ITEM_ACCOUNT',
            xtype: 'uniCombobox',
            comboType: 'AU',
            comboCode: 'B020',
            colspan: 2
        },
        {
            fieldLabel: '<t:message code="system.label.purchase.procurementclassification" default="조달구분"/>',
            name: 'SUPPLY_TYPE',
            xtype: 'uniCombobox',
//            value: '3',
            readOnly: true,
            comboType: 'AU',
            comboCode: 'B014'
        },
        {
            xtype: 'container',
            layout: { type: 'uniTable', columns: 3},
            defaultType: 'uniTextfield',
            defaults : {enforceMaxLength: true},
            items:[
                Unilite.popup('DIV_PUMOK',{
                    fieldLabel: '소요자재',
                    allowBlank:false,
                    listeners: {
                        onSelected: {
                            fn: function(records, type) {
                                console.log('records : ', records);
                                outsidePlSearch.setValue('SPEC',records[0]["SPEC"]);
                            },
                            scope: this
                        },
                        onClear: function(type) {
                            outsidePlSearch.setValue('SPEC','');

                        },
                        applyextparam: function(popup){
                            popup.setExtParam({'DIV_CODE': outsidePlSearch.getValue('DIV_CODE')});
                        }
                    }
           }),{
                name:'SPEC',
                xtype:'uniTextfield',
                holdable: 'hold',
                readOnly:true
            }]
        }],
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
                        var labelText = invalid.items[0]['fieldLabel']+':';
                    } else if(Ext.isDefined(invalid.items[0].ownerCt)) {
                        var labelText = invalid.items[0].ownerCt['fieldLabel']+':';
                    }
                    alert(labelText+Msg.sMB083);
                    invalid.items[0].focus();
                } else {
                    var fields = this.getForm().getFields();
                    Ext.each(fields.items, function(item) {
                        if(Ext.isDefined(item.holdable) )   {
                            if (item.holdable == 'hold') {
                                item.setReadOnly(true);
                            }
                        }
                        if(item.isPopupField)   {
                            var popupFC = item.up('uniPopupField')  ;
                            if(popupFC.holdable == 'hold') {
                                popupFC.setReadOnly(true);
                            }
                        }
                    })
                }
            } else {
                var fields = this.getForm().getFields();
                Ext.each(fields.items, function(item) {
                    if(Ext.isDefined(item.holdable) )   {
                        if (item.holdable == 'hold') {
                            item.setReadOnly(false);
                        }
                    }
                    if(item.isPopupField)   {
                        var popupFC = item.up('uniPopupField')  ;
                        if(popupFC.holdable == 'hold' ) {
                            item.setReadOnly(false);
                        }
                    }
                })
            }
            return r;
        }
    });

    var itemRequestSearch = Unilite.createSearchForm('itemRequestForm', {     //품품의뢰 참조
        layout: {type : 'uniTable', columns : 3},
        items :[{
            fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
            name:'DIV_CODE',
            xtype: 'uniCombobox',
            allowBlank:false,
            comboType:'BOR120'
        },
        {
            fieldLabel:'물품의뢰번호',
            name: 'ITEM_REQ_NUM',
            xtype: 'uniTextfield'
        },
        {
            fieldLabel: '의뢰일자',
            xtype: 'uniDateRangefield',
            startFieldName: 'ITEM_REQ_DATE_FR',
            endFieldName:'ITEM_REQ_DATE_TO',
            allowBlank:false,
            startDate: UniDate.get('startOfMonth'),
            endDate: UniDate.get('today')
        },
        Unilite.popup('DEPT', {
                fieldLabel: '<t:message code="system.label.purchase.department" default="부서"/>',
                valueFieldName: 'DEPT_CODE',
                textFieldName: 'DEPT_NAME',
                listeners: {
                    applyextparam: function(popup){
                        var authoInfo = pgmInfo.authoUser;              //권한정보(N-전체,A-자기사업장>5-자기부서)
                        var deptCode = UserInfo.deptCode;   //부서정보
                        var divCode = '';                   //사업장
                        if(authoInfo == "A"){   //자기사업장
                            popup.setExtParam({'TREE_CODE': ""});
                            popup.setExtParam({'DIV_CODE': UserInfo.divCode});
                        }else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){   //전체권한
                            popup.setExtParam({'TREE_CODE': ""});
                            popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
                        }else if(authoInfo == "5"){     //부서권한
                            popup.setExtParam({'TREE_CODE': UserInfo.deptCode});
                            popup.setExtParam({'DIV_CODE': UserInfo.divCode});
                        }
                    }
                }
        }),
        Unilite.popup('Employee',{
                fieldLabel: '사원',
                valueFieldName:'PERSON_NUMB',
                textFieldName:'PERSON_NAME'
        })],
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
                        var labelText = invalid.items[0]['fieldLabel']+':';
                    } else if(Ext.isDefined(invalid.items[0].ownerCt)) {
                        var labelText = invalid.items[0].ownerCt['fieldLabel']+':';
                    }
                    alert(labelText+Msg.sMB083);
                    invalid.items[0].focus();
                } else {
                    var fields = this.getForm().getFields();
                    Ext.each(fields.items, function(item) {
                        if(Ext.isDefined(item.holdable) )   {
                            if (item.holdable == 'hold') {
                                item.setReadOnly(true);
                            }
                        }
                        if(item.isPopupField)   {
                            var popupFC = item.up('uniPopupField')  ;
                            if(popupFC.holdable == 'hold') {
                                popupFC.setReadOnly(true);
                            }
                        }
                    })
                }
            } else {
                var fields = this.getForm().getFields();
                Ext.each(fields.items, function(item) {
                    if(Ext.isDefined(item.holdable) )   {
                        if (item.holdable == 'hold') {
                            item.setReadOnly(false);
                        }
                    }
                    if(item.isPopupField)   {
                        var popupFC = item.up('uniPopupField')  ;
                        if(popupFC.holdable == 'hold' ) {
                            item.setReadOnly(false);
                        }
                    }
                })
            }
            return r;
        }
    });

    /**
     * Master Grid1 정의(Grid Panel)
     * @type
     */
    var masterGrid= Unilite.createGrid('mre100ukrvGrid', {
        region: 'center' ,
        layout: 'fit',
        excelTitle: '구매요청등록',
        uniOpt: {
            useGroupSummary: false,
            useLiveSearch: true,
            useContextMenu: true,
            useMultipleSorting: true,
            useRowNumberer: false,
            expandLastColumn: false,
            filter: {
                useFilter: false,
                autoCreate: false
            }
        },
        tbar: [{
            xtype: 'splitbutton',
            itemId:'orderTool',
            text: '<t:message code="system.label.purchase.reference" default="참조..."/>',
            iconCls : 'icon-referance',
            menu: Ext.create('Ext.menu.Menu', {
                items: [{
                            itemId: 'mrpRefBtn',
                            text: '자재소요량정보 참조',
                            handler: function() {
                                openOtherMrpWindow();
                            }
                        },{
                            itemId: 'plRefBtn2',
                            text: '외주P/L 참조',
                            handler: function() {
                                openOutsidePlWindow();
                            }
                        },{
                            itemId: 'plRefBtn3',
                            text: '물품의뢰 참조',
                            handler: function() {
                                openItemRequestWindow();
                            }
                        }]
            })
        }],
        store: directMasterStore1,
        features: [{
            id: 'masterGridSubTotal',
            ftype: 'uniGroupingsummary',
            showSummaryRow: false
        },{
            id: 'masterGridTotal',
            ftype: 'uniSummary',
            showSummaryRow: false
        }],
        columns: [
            {dataIndex:'DIV_CODE'                   , width: 93 ,hidden: true},
            {dataIndex:'CUSTOM_CODE'                , width: 93 ,hidden: true},
            {dataIndex:'PO_REQ_NUM'                 , width: 110 ,hidden: true},
            {dataIndex:'PO_SER_NO'                  , width: 55 ,locked: false},
            {dataIndex:'ITEM_CODE'                  , width: 120 ,locked: false,
                editor: Unilite.popup('DIV_PUMOK_G', {
                    textFieldName: 'ITEM_CODE',
                    DBtextFieldName: 'ITEM_CODE',
                    extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'},
                    useBarcodeScanner: false,
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
                            var a = masterGrid.uniOpt.currentRecord.get('ITEM_CODE');
                            masterGrid.setItemData(null,true, masterGrid.uniOpt.currentRecord);
                            masterGrid.uniOpt.currentRecord.set('ITEM_CODE',a);
                            if(aa == 0){
                                if(a != ''){
                                    alert("미등록상품입니다.");
                                    aa++;
                                }
                            }else{
                                aa=0;
                            }
                        },
                        applyextparam: function(popup){
                            popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
                            popup.setExtParam({'SUPPLY_TYPE': panelSearch.getValue('SUPPLY_TYPE')});
                        }
                    }
                })
            },
            {dataIndex:'ITEM_NAME'                  , width: 250 ,locked: false,
                editor: Unilite.popup('DIV_PUMOK_G', {
                    extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode},
		            autoPopup: true,
                    listeners: {
                        'onSelected': {
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
                            masterGrid.setItemData(null,true, masterGrid.uniOpt.currentRecord);
                        },
                        applyextparam: function(popup){
                            popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
                            popup.setExtParam({'SUPPLY_TYPE': panelSearch.getValue('SUPPLY_TYPE')});
                        }
                    }
                })
            },
            {dataIndex:'SPEC'                   , width: 138 },
            {dataIndex:'STOCK_UNIT'             , width: 88 , align: 'center'},
            {dataIndex:'R_ORDER_Q'              , width: 90 },
            {dataIndex:'PAB_STOCK_Q'            , width: 90 },
            {dataIndex:'ORDER_Q'                , width: 93 },
            {dataIndex:'ORDER_UNIT'             , width: 88 , align: 'center'},
            {dataIndex:'TRNS_RATE'              , width: 93 },
            {dataIndex:'ORDER_UNIT_Q'          , width: 125 },
            {dataIndex:'MONEY_UNIT'             , width: 73 ,hidden : true, align: 'center'},
            {dataIndex:'EXCHG_RATE_O'           , width: 80 ,hidden : true},

            {dataIndex:'UNIT_PRICE_TYPE'        , width: 88 , align: 'center'},
            {dataIndex:'ORDER_P'                , width: 93 },
            {dataIndex:'ORDER_O'                , width: 106 },
            {dataIndex:'ORDER_LOC_P'            , width: 93 },
            {dataIndex:'ORDER_LOC_O'            , width: 106 },

            {dataIndex:'SUPPLY_TYPE'            , width: 80 ,hidden : true},
            { dataIndex: 'CUSTOM_CODE'      ,width: 90,
                'editor' : Unilite.popup('CUST_G',{
                    textFieldName:'CUSTOM_CODE',
                    DBtextFieldName:'CUSTOM_CODE',
		            autoPopup: true,
                    listeners: {
                        'onSelected':  function(records, type  ){
                                var grdRecord = masterGrid.uniOpt.currentRecord;
                                var record = masterGrid.getSelectedRecord();
                                grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
                                grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);

                                var param = {"ITEM_CODE": record.data.ITEM_CODE,
                                             "CUSTOM_CODE": records[0]['CUSTOM_CODE'],
                                             "DIV_CODE": panelSearch.getValue('DIV_CODE'),
                                             "MONEY_UNIT": panelSearch.getValue('MONEY_UNIT'),
                                             "ORDER_UNIT": record.data.ORDER_UNIT,
                                             "ORDER_DATE": UniDate.getDbDateStr(panelSearch.getValue('ORDER_DATE')),
                                             "PO_REQ_DATE":UniDate.getDbDateStr(panelSearch.getValue('PO_REQ_DATE'))
                                            };
                                mre100ukrvService.fnOrderPrice(param, function(provider, response)  {
                                    if(!Ext.isEmpty(provider)){
                                        grdRecord.set('ORDER_P', provider['ORDER_P']);
                                        grdRecord.set('UNIT_PRICE_TYPE', provider['PRICE_TYPE']);
                                    }
                                });
                        },
                        'onClear':  function( type  ){
                                var grdRecord = masterGrid.uniOpt.currentRecord;
                                grdRecord.set('CUSTOM_NAME','');
                                grdRecord.set('CUSTOM_CODE','');
                                grdRecord.set('ORDER_P','');
                                grdRecord.set('UNIT_PRICE_TYPE','');
                        }
                    } //listeners
                })
             }
            ,{ dataIndex: 'CUSTOM_NAME'     ,width: 106 ,
                'editor' : Unilite.popup('CUST_G',{
                    textFieldName:'CUSTOM_NAME',
		            autoPopup: true,
                    listeners: {
                        'onSelected':  function(records, type  ){
                                var grdRecord = masterGrid.uniOpt.currentRecord;
                                var record = masterGrid.getSelectedRecord();
                                grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
                                grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);

                                var param = {"ITEM_CODE": record.data.ITEM_CODE,
                                             "CUSTOM_CODE": records[0]['CUSTOM_CODE'],
                                             "DIV_CODE": panelSearch.getValue('DIV_CODE'),
                                             "MONEY_UNIT": panelSearch.getValue('MONEY_UNIT'),
                                             "ORDER_UNIT": record.data.ORDER_UNIT,
                                             "ORDER_DATE": UniDate.getDbDateStr(panelSearch.getValue('ORDER_DATE')),
                                             "PO_REQ_DATE":UniDate.getDbDateStr(panelSearch.getValue('PO_REQ_DATE'))
                                            };
                                mre100ukrvService.fnOrderPrice(param, function(provider, response)  {
                                    if(!Ext.isEmpty(provider)){
                                        grdRecord.set('ORDER_P', provider['ORDER_P']);
                                        grdRecord.set('UNIT_PRICE_TYPE', provider['PRICE_TYPE']);
                                    }
                                });
                        },
                        'onClear':  function( type  ){
                                var grdRecord = masterGrid.uniOpt.currentRecord;
                                grdRecord.set('CUSTOM_NAME','');
                                grdRecord.set('CUSTOM_CODE','');
                                grdRecord.set('ORDER_P','');
                                grdRecord.set('UNIT_PRICE_TYPE','');
                        }
                    } //listeners
                })
             },
            {dataIndex:'DVRY_DATE'              , width: 80 },

            {dataIndex:'PO_REQ_DATE'            , width: 80 },
            {dataIndex:'WH_CODE'                , width: 120,
                    listeners: {
                        'onSelected':  function(records, type  ){
                                var grdRecord = masterGrid.uniOpt.currentRecord;
                                var record = masterGrid.getSelectedRecord();
                                var param = {"ITEM_CODE": record.data.ITEM_CODE,
                                              "WH_CODE": record.data.WH_CODE
                                            };
                                mre100ukrvService.fnStockQ(param, function(provider, response)  {
                                    if(!Ext.isEmpty(provider)){
                                        grdRecord.set('PAB_STOCK_Q', provider['STOCK_Q']);
                                    }
                                });
                        },
                        'onClear':  function( type  ){
                                var grdRecord = masterGrid.uniOpt.currentRecord;
                                grdRecord.set('WH_CODE','');
                                grdRecord.set('PAB_STOCK_Q','');
                        }
                    }},
            {dataIndex:'INSPEC_FLAG'            , width: 95 , align: 'center'},
            {dataIndex:'REMARK'                 , width: 200 },

            {dataIndex:'ORDER_REQ_NUM'          , width: 100 },
            {dataIndex:'MRP_CONTROL_NUM'        , width: 100 },
            {dataIndex:'ITEM_REQ_SEQ'           , width: 100 },
            {dataIndex:'ITEM_REQ_NUM'           , width: 100 },

            {dataIndex:'ORDER_YN'               , width: 80 ,hidden : true},
            {dataIndex:'PURCH_LDTIME'           , width: 80 ,hidden : true},
            {dataIndex:'COMP_CODE'              , width: 10 ,hidden : true},
            {dataIndex:'UPDATE_DB_USER'         , width: 10 ,hidden : true},
            {dataIndex:'UPDATE_DB_TIME'         , width: 10 ,hidden : true}
        ],
        listeners: {
            beforeedit  : function( editor, e, eOpts ) {
                if(e.record.data.ORDER_YN == 'Y'){
                    return false;
                }
                if(e.record.phantom){
                    if(e.record.data.ORDER_REQ_NUM != ''){
                        if(UniUtils.indexOf(e.field, ['ITEM_CODE','ITEM_NAME','PO_SER_NO','ORDER_O'])) return false;
                    }else{
                    if(UniUtils.indexOf(e.field, ['ITEM_CODE','ITEM_NAME','PO_SER_NO'])) return true;
                    }
                }
                if(UniUtils.indexOf(e.field, [
                    'ORDER_UNIT','DVRY_DATE','ORDER_P','ORDER_Q',
                    'UNIT_PRICE_TYPE','SUPPLY_TYPE','ORDER_UNIT_Q','CUSTOM_CODE','CUSTOM_NAME',
                    'REMARK','PO_REQ_DATE','WH_CODE','INSPEC_FLAG'
                ])) return true;
                if(e.record.data.ORDER_UNIT != e.record.data.STOCK_UNIT){
                    if(e.field=='TRNS_RATE') return true;
                }else{
                    if(e.field=='TRNS_RATE') return false;
                }
                return false;
            }
        },
        disabledLinkButtons: function(b) {
            this.down('#procTool').menu.down('#reqIssueLinkBtn').setDisabled(b);
            this.down('#procTool').menu.down('#issueLinkBtn').setDisabled(b);
            this.down('#procTool').menu.down('#saleLinkBtn').setDisabled(b);
        },
        setItemData: function(record, dataClear, grdRecord) {
            if(dataClear) {
                grdRecord.set('ITEM_CODE'           ,"");
                grdRecord.set('ITEM_NAME'           ,"");
                grdRecord.set('ITEM_ACCOUNT'        ,"");
                grdRecord.set('SPEC'                ,"");
                grdRecord.set('ORDER_UNIT'          ,"");
                grdRecord.set('STOCK_UNIT'          ,"");
                grdRecord.set('TRNS_RATE'           ,'1');
                grdRecord.set('ORDER_P'             ,0);
                grdRecord.set('DVRY_DATE'           ,UniDate.get('today'));
                grdRecord.set('INSPEC_FLAG'         ,"");
                grdRecord.set('ORDER_P'             ,0);
                grdRecord.set('WH_CODE'             ,"");
                grdRecord.set('CUSTOM_CODE'         ,"");
                grdRecord.set('CUSTOM_NAME'         ,"");
            } else {
                grdRecord.set('ITEM_CODE'           , record['ITEM_CODE']);
                grdRecord.set('ITEM_NAME'           , record['ITEM_NAME']);
                grdRecord.set('ITEM_ACCOUNT'        , record['ITEM_ACCOUNT']);
                grdRecord.set('SPEC'                , record['SPEC']);
                grdRecord.set('ORDER_UNIT'          , record['ORDER_UNIT']);
                grdRecord.set('STOCK_UNIT'          , record['STOCK_UNIT']);
                grdRecord.set('TRNS_RATE'           , record['TRNS_RATE']);
                grdRecord.set('ORDER_P'             , record['BASIS_P']);
                grdRecord.set('DVRY_DATE'           , moment().add('day',record['PURCH_LDTIME']).format('YYYYMMDD'));
                grdRecord.set('INSPEC_FLAG'         , record['INSPEC_YN']);
                grdRecord.set('WH_CODE'             , record['WH_CODE']);
                grdRecord.set('CUSTOM_CODE'         , record['MAIN_CUSTOM_CODE']);
                grdRecord.set('CUSTOM_NAME'         , record['MAIN_CUSTOM_NAME']);

                var param = {
                     "ITEM_CODE": record['ITEM_CODE'],
                     "CUSTOM_CODE": record['MAIN_CUSTOM_CODE'],
                     "DIV_CODE": panelSearch.getValue('DIV_CODE'),
                     "MONEY_UNIT": panelSearch.getValue('MONEY_UNIT'),
                     "ORDER_UNIT": record['ORDER_UNIT'],
                     "ORDER_DATE": UniDate.getDbDateStr(panelSearch.getValue('ORDER_DATE')),
                     "PO_REQ_DATE":UniDate.getDbDateStr(panelSearch.getValue('PO_REQ_DATE'))
                };

                mre100ukrvService.fnOrderPrice(param, function(provider, response)  {
                    if(!Ext.isEmpty(provider)){
                        grdRecord.set('ORDER_P', provider['ORDER_P']);
                        grdRecord.set('UNIT_PRICE_TYPE', provider['PRICE_TYPE']);
                    }
                });

                //현재고 : 납품창고 지정후
                var param = {"ITEM_CODE": record['ITEM_CODE'],
                              "WH_CODE": record['WH_CODE']
                            };
                mre100ukrvService.fnStockQ(param, function(provider, response)  {
                    if(!Ext.isEmpty(provider)){
                        grdRecord.set('PAB_STOCK_Q', provider['STOCK_Q']);
                    }
                });

                //UniSales.fnStockQ(grdRecord, UserInfo.compCode, grdRecord.get('OUT_DIV_CODE'), null, grdRecord.get('ITEM_CODE'),  grdRecord.get('REF_WH_CODE'));
            }
        },
        setMrpData:function(record) {
            var grdRecord = this.getSelectedRecord();
            grdRecord.set('DIV_CODE'            , panelSearch.getValue('DIV_CODE'));

            grdRecord.set('ITEM_CODE'           , record['ITEM_CODE']);
            grdRecord.set('ITEM_NAME'           , record['ITEM_NAME']);
            grdRecord.set('ITEM_ACCOUNT'        , record['ITEM_ACCOUNT']);
            grdRecord.set('SPEC'                , record['SPEC']);
            grdRecord.set('STOCK_UNIT'          , record['STOCK_UNIT']);
            if(Ext.isEmpty(panelSearch.getValue('SUPPLY_TYPE'))){
                grdRecord.set('SUPPLY_TYPE'     ,panelSearch.getValue('SUPPLY_TYPE'));
            }
            grdRecord.set('R_ORDER_Q'           , record['INPUT_REMAIN_QTY']);  //미입고량
            grdRecord.set('ORDER_UNIT'          , record['ORDER_UNIT']);
            grdRecord.set('ORDER_UNIT_Q'        , record['REMAIN_Q']);    //잔량
            grdRecord.set('TRNS_RATE'           , record['TRNS_RATE']);
            grdRecord.set('ORDER_Q'             , record['ORDER_Q']);

            //현재고 : 납품창고 지정후
            var param = {"ITEM_CODE": record['ITEM_CODE'],
                          "WH_CODE": record['WH_CODE']
                        };
            mre100ukrvService.fnStockQ(param, function(provider, response)  {
                if(!Ext.isEmpty(provider)){
                    grdRecord.set('PAB_STOCK_Q', provider['STOCK_Q']);
                }
            });
            grdRecord.set('ORDER_REQ_NUM'       , record['ORDER_REQ_NUM']);
            grdRecord.set('MRP_CONTROL_NUM'     , record['MRP_CONTROL_NUM']);

            grdRecord.set('PO_REQ_DATE'         , record['ORDER_PLAN_DATE']);
            grdRecord.set('PURCH_LDTIME'        , record['PURCH_LDTIME']);
            grdRecord.set('DVRY_DATE'           , record['DVRY_DATE']);
            grdRecord.set('CUSTOM_CODE'         , record['CUSTOM_CODE']);
            grdRecord.set('CUSTOM_NAME'         , record['CUSTOM_NAME']);
            grdRecord.set('PAB_STOCK_Q'         , record['PAB_STOCK_Q']);

            var param = {"ITEM_CODE": record['ITEM_CODE'],
                         "CUSTOM_CODE": record['CUSTOM_CODE'],
                         "DIV_CODE": panelSearch.getValue('DIV_CODE'),
                         "MONEY_UNIT": panelSearch.getValue('MONEY_UNIT'),
                         "ORDER_UNIT": record['ORDER_UNIT'],
                         "ORDER_DATE": UniDate.getDbDateStr(panelSearch.getValue('ORDER_DATE')),
                         "PO_REQ_DATE":UniDate.getDbDateStr(panelSearch.getValue('PO_REQ_DATE'))
                        };
            mre100ukrvService.fnOrderPrice(param, function(provider, response)  {
                if(!Ext.isEmpty(provider)){
                    grdRecord.set('ORDER_P', provider['ORDER_P']);
                    grdRecord.set('UNIT_PRICE_TYPE', provider['PRICE_TYPE']);
                }
            });
        },
        setOutsidePlData:function(record) {
            var grdRecord = this.getSelectedRecord();
            grdRecord.set('DIV_CODE'            , panelSearch.getValue('DIV_CODE'));

            grdRecord.set('ITEM_CODE'           , record['PROD_ITEM_CODE']);
            grdRecord.set('ITEM_NAME'           , record['PROD_ITEM_NAME']);
            grdRecord.set('ITEM_ACCOUNT'        , record['ITEM_ACCOUNT']);
            grdRecord.set('SPEC'                , record['SPEC2']);
//            grdRecord.set('STOCK_UNIT'          , record['STOCK_UNIT']);
            grdRecord.set('SUPPLY_TYPE'         , record['SUPPLY_TYPE']);
            grdRecord.set('R_ORDER_Q'           , '0');  //미입고량
//            grdRecord.set('ORDER_UNIT'          , record['ORDER_UNIT']);
            grdRecord.set('ORDER_UNIT_Q'        , record['UNIT_Q']);
            grdRecord.set('TRNS_RATE'           , '1');
            grdRecord.set('ORDER_Q'             , record['UNIT_Q']);

            //현재고 : 납품창고 지정후
            var param = {"ITEM_CODE": record['ITEM_CODE'],
                          "WH_CODE": record['WH_CODE']
                        };
            mre100ukrvService.fnStockQ(param, function(provider, response)  {
                if(!Ext.isEmpty(provider)){
                    grdRecord.set('PAB_STOCK_Q', provider['STOCK_Q']);
                }
            });
//            grdRecord.set('ORDER_REQ_NUM'       , record['ORDER_REQ_NUM']);
//            grdRecord.set('MRP_CONTROL_NUM'     , record['MRP_CONTROL_NUM']);

//            grdRecord.set('PO_REQ_DATE'         , record['ORDER_PLAN_DATE']);
//            grdRecord.set('PURCH_LDTIME'        , record['PURCH_LDTIME']);
//            grdRecord.set('DVRY_DATE'           , record['DVRY_DATE']);
//            grdRecord.set('CUSTOM_CODE'         , record['CUSTOM_CODE']);
//            grdRecord.set('CUSTOM_NAME'         , record['CUSTOM_NAME']);
            grdRecord.set('PAB_STOCK_Q'         , '0');

            var param = {"ITEM_CODE": record['ITEM_CODE'],
                         "CUSTOM_CODE": record['CUSTOM_CODE'],
                         "DIV_CODE": panelSearch.getValue('DIV_CODE'),
                         "MONEY_UNIT": panelSearch.getValue('MONEY_UNIT'),
                         "ORDER_UNIT": record['ORDER_UNIT'],
                         "ORDER_DATE": UniDate.getDbDateStr(panelSearch.getValue('ORDER_DATE')),
                         "PO_REQ_DATE":UniDate.getDbDateStr(panelSearch.getValue('PO_REQ_DATE'))
                        };
            mre100ukrvService.fnOrderPrice(param, function(provider, response)  {
                if(!Ext.isEmpty(provider)){
                    grdRecord.set('ORDER_P', provider['ORDER_P']);
                    grdRecord.set('UNIT_PRICE_TYPE', provider['PRICE_TYPE']);
                }
            });
        },
        setItemRequestData:function(record) {
            var grdRecord = this.getSelectedRecord();
            grdRecord.set('DIV_CODE'            , panelSearch.getValue('DIV_CODE'));

            grdRecord.set('ITEM_CODE'           , record['ITEM_CODE']);
            grdRecord.set('ITEM_NAME'           , record['ITEM_NAME']);
            grdRecord.set('ITEM_ACCOUNT'        , '');
            grdRecord.set('SPEC'                , record['SPEC']);
            grdRecord.set('STOCK_UNIT'          , record['STOCK_UNIT']);
            grdRecord.set('SUPPLY_TYPE'         , '');
            grdRecord.set('R_ORDER_Q'           , '0');  //미입고량
//            grdRecord.set('ORDER_UNIT'          , record['ORDER_UNIT']);
            grdRecord.set('ORDER_UNIT_Q'        , record['REQ_Q']);
            grdRecord.set('TRNS_RATE'           , '1');
            grdRecord.set('ORDER_Q'             , record['REQ_Q']);

            //현재고 : 납품창고 지정후
            var param = {"ITEM_CODE": record['ITEM_CODE'],
                          "WH_CODE": record['WH_CODE']
                        };
            mre100ukrvService.fnStockQ(param, function(provider, response)  {
                if(!Ext.isEmpty(provider)){
                    grdRecord.set('PAB_STOCK_Q', provider['STOCK_Q']);
                }
            });
            grdRecord.set('ITEM_REQ_NUM'       , record['ITEM_REQ_NUM']);
            grdRecord.set('ITEM_REQ_SEQ'       , record['ITEM_REQ_SEQ']);
//            grdRecord.set('MRP_CONTROL_NUM'     , record['MRP_CONTROL_NUM']);

//            grdRecord.set('PO_REQ_DATE'         , record['ORDER_PLAN_DATE']);
//            grdRecord.set('PURCH_LDTIME'        , record['PURCH_LDTIME']);
//            grdRecord.set('DVRY_DATE'           , record['DVRY_DATE']);
//            grdRecord.set('CUSTOM_CODE'         , record['CUSTOM_CODE']);
//            grdRecord.set('CUSTOM_NAME'         , record['CUSTOM_NAME']);
            grdRecord.set('PAB_STOCK_Q'         , '0');

            var param = {"ITEM_CODE": record['ITEM_CODE'],
                         "CUSTOM_CODE": record['CUSTOM_CODE'],
                         "DIV_CODE": panelSearch.getValue('DIV_CODE'),
                         "MONEY_UNIT": panelSearch.getValue('MONEY_UNIT'),
                         "ORDER_UNIT": record['ORDER_UNIT'],
                         "ORDER_DATE": UniDate.getDbDateStr(panelSearch.getValue('ORDER_DATE')),
                         "PO_REQ_DATE":UniDate.getDbDateStr(panelSearch.getValue('PO_REQ_DATE'))
                        };
            mre100ukrvService.fnOrderPrice(param, function(provider, response)  {
                if(!Ext.isEmpty(provider)){
                    grdRecord.set('ORDER_P', provider['ORDER_P']);
                    grdRecord.set('UNIT_PRICE_TYPE', provider['PRICE_TYPE']);
                }
            });
        }
    });

    var orderNoMasterGrid = Unilite.createGrid('mre100ukrvOrderNoMasterGrid', {     //조회버튼 누르면 나오는 조회창 (구매요청번호)
        layout : 'fit',
        //excelTitle: '구매요청등록(구매요청번호검색)',
        store: orderNoMasterStore,
        uniOpt:{
            expandLastColumn: false,
            useRowNumberer: false
        },
        columns: [
            { dataIndex: 'PO_REQ_DATE'          ,  width: 133},
            { dataIndex: 'SUPPLY_TYPE'          ,  width: 93,align:'center'},
            { dataIndex: 'PO_REQ_NUM'           ,  width: 133},
            { dataIndex: 'DEPT_CODE'            ,  width: 80},
            { dataIndex: 'DEPT_NAME'            ,  width: 80},
            { dataIndex: 'PERSON_NUMB'          ,  width: 93,align:'center'},
            { dataIndex: 'PERSON_NAME'          ,  width: 66,align:'center'},
            { dataIndex: 'MONEY_UNIT'           ,  width: 100, align: 'center'},
            { dataIndex: 'EXCHG_RATE_O'         ,  width: 100},
            { dataIndex: 'ITEM_ACCOUNT'         ,  width: 66},
            { dataIndex: 'MONEY_UNIT'           ,  width: 66, align: 'center', hidden: true},
            { dataIndex: 'DIV_CODE'             ,  width: 66,hidden:true}

        ],
        listeners: {
            onGridDblClick: function(grid, record, cellIndex, colName) {
                orderNoMasterGrid.returnData(record);
                //UniAppManager.app.onQueryButtonDown();
                SearchInfoWindow.hide();
            }
        },
        returnData: function(record)    {
            if(Ext.isEmpty(record)) {
                record = this.getSelectedRecord();
            }
            panelSearch.setValues({
                'DIV_CODE':record.get('DIV_CODE'),
                'CUSTOM_CODE':record.get('CUSTOM_CODE'),
                'CUSTOM_NAME':record.get('CUSTOM_NAME'),
                'ORDER_DATE':record.get('ORDER_DATE'),
                'ORDER_TYPE':record.get('ORDER_TYPE'),
                'ORDER_PRSN':record.get('ORDER_PRSN'),
                'PO_REQ_NUM':record.get('PO_REQ_NUM'),
                'MONEY_UNIT':record.get('MONEY_UNIT'),
                'EXCHG_RATE_O':record.get('EXCHG_RATE_O'),
                'COMP_NAME':record.get('COMP_NAME'),
                'AGREE_STATUS':record.get('AGREE_STATUS'),
                'AGREE_PRSN_NAME':record.get('AGREE_PRSN_NAME'),
                'DRAFT_YN':record.get('DRAFT_YN'),
                'DEPT_CODE':record.get('DEPT_CODE'),
                'DEPT_NAME':record.get('DEPT_NAME'),
                'ITEM_ACCOUNT':record.get('ITEM_ACCOUNT')
            });
            panelResult.setValues({
                'DIV_CODE':record.get('DIV_CODE'),
                'DEPT_CODE':record.get('DEPT_CODE'),
                'DEPT_NAME':record.get('DEPT_NAME'),
                'PO_REQ_NUM':record.get('PO_REQ_NUM'),
                'CUSTOM_CODE':record.get('CUSTOM_CODE'),
                'CUSTOM_NAME':record.get('CUSTOM_NAME'),
                'ORDER_DATE':record.get('ORDER_DATE'),
                'ORDER_PRSN':record.get('ORDER_PRSN'),
                'AGREE_STATUS':record.get('AGREE_STATUS'),
                'AGREE_PRSN_NAME':record.get('AGREE_PRSN_NAME'),
                'ITEM_ACCOUNT':record.get('ITEM_ACCOUNT')
            });
            panelSearch.setAllFieldsReadOnly(true);
            panelResult.setAllFieldsReadOnly(true);
            directMasterStore1.loadStoreRecords();
        }
    });

    var otherorderGrid = Unilite.createGrid('mre100ukrvOtherorderGrid', {   //자재소요량정보 참조
        layout: 'fit',
        store: otherOrderStore,
        uniOpt: {
            useGroupSummary: false,
            useLiveSearch: true,
            useContextMenu: true,
            useMultipleSorting: true,
            useRowNumberer: false,
            expandLastColumn: false,
            onLoadSelectFirst: false,
            filter: {
                useFilter: false,
                autoCreate: false
            }
        },
        selModel:   Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }),
        columns: [
            { dataIndex: 'ORDER_PLAN_DATE'      ,  width: 90},
            { dataIndex: 'ORDER_REQ_NUM'        ,  width: 90,hidden:true},
            { dataIndex: 'CUSTOM_CODE'          ,  width: 80},
            { dataIndex: 'CUSTOM_NAME'          ,  width: 180},
            { dataIndex: 'ITEM_CODE'            ,  width: 80},
            { dataIndex: 'ITEM_NAME'            ,  width: 120},
            { dataIndex: 'SPEC'                 , width: 138 },
            { dataIndex: 'STOCK_UNIT'           , width: 70 , align: 'center'},
            { dataIndex: 'ORDER_PLAN_Q'         ,  width: 93},
            { dataIndex: 'REQ_PLAN_Q'           ,  width: 133},
            { dataIndex: 'REMAIN_Q'             ,  width: 133},
            { dataIndex: 'SUPPLY_TYPE'          ,  width: 66, align: 'center'},
            { dataIndex: 'PAB_STOCK_Q'          ,  width: 133},
            { dataIndex: 'DOM_FORIGN'           ,  width: 70, align: 'center'},
            { dataIndex: 'ORDER_NUM'            ,  width: 100},
            { dataIndex: 'ORDER_SEQ'            ,  width: 100},
            { dataIndex: 'MRP_CONTROL_NUM'      ,  width: 100},
            { dataIndex: 'WKORD_NUM'            ,  width: 100},
            { dataIndex: 'PROJECT_NO'           ,  width: 100},
            { dataIndex: 'INPUT_REMAIN_QTY'     ,  width: 90,hidden:true},
            { dataIndex: 'ORDER_UNIT'           ,  width: 70,hidden:true},
            { dataIndex: 'TRNS_RATE'            ,  width: 80,hidden:true},
            { dataIndex: 'PURCH_LDTIME'         ,  width: 80,hidden:true},
            { dataIndex: 'DVRY_DATE'            ,  width: 80,hidden:true},
            { dataIndex: 'ORDER_Q'              ,  width: 80,hidden:true}
        ],
        listeners: {
            onGridDblClick:function(grid, record, cellIndex, colName) {
                if(Ext.isEmpty(record)) {
                    record = this.getSelectedRecord();
                }

            }
        },
        returnData: function(record)    {
            var records = this.sortedSelectedRecords(this);

            Ext.each(records, function(record,i){
                UniAppManager.app.onNewDataButtonDown();
                masterGrid.setMrpData(record.data);
                //masterGrid.setDepositData(record.data);
            });
            this.deleteSelectedRow();
        }
    });

    var outsidePlGrid = Unilite.createGrid('mre100ukrvoutsidePlGrid', {   //외주P/L 참조
        layout: 'fit',
        store: outsidePlStore,
        uniOpt: {
            useGroupSummary: false,
            useLiveSearch: true,
            useContextMenu: true,
            useMultipleSorting: true,
            useRowNumberer: false,
            expandLastColumn: false,
            onLoadSelectFirst: false,
            filter: {
                useFilter: false,
                autoCreate: false
            }
        },
        selModel:   Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }),
        columns: [
            { dataIndex: 'COMP_CODE'          ,  width: 90, hidden: true},
            { dataIndex: 'DIV_CODE'           ,  width: 90, hidden: true},
            { dataIndex: 'CHILD_ITEM_CODE'    ,  width: 110},
            { dataIndex: 'CHILD_ITEM_NAME'    ,  width: 200},
            { dataIndex: 'SPEC1'              ,  width: 90},
            { dataIndex: 'PROD_ITEM_CODE'     ,  width: 110},
            { dataIndex: 'PROD_ITEM_NAME'     ,  width: 200},
            { dataIndex: 'SPEC2'              ,  width: 90},
            { dataIndex: 'UNIT_Q'             ,  width: 80}
        ],
        listeners: {
            onGridDblClick:function(grid, record, cellIndex, colName) {
                if(Ext.isEmpty(record)) {
                    record = this.getSelectedRecord();
                }

            }
        },
        returnData: function(record)    {
            var records = this.sortedSelectedRecords(this);

            Ext.each(records, function(record,i){
                UniAppManager.app.onNewDataButtonDown();
                masterGrid.setOutsidePlData(record.data);
                //masterGrid.setDepositData(record.data);
            });

        }
    });

    var itemRequestGrid = Unilite.createGrid('mre100ukrvItemRequestGrid', {   //외주P/L 참조
        layout: 'fit',
        store: itemRequestStore,
        uniOpt: {
            useGroupSummary: false,
            useLiveSearch: true,
            useContextMenu: true,
            useMultipleSorting: true,
            useRowNumberer: false,
            expandLastColumn: false,
            onLoadSelectFirst: false,
            filter: {
                useFilter: false,
                autoCreate: false
            }
        },
        selModel:   Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }),
        columns: [
            { dataIndex: 'COMP_CODE'            ,  width: 90, hidden: true},
            { dataIndex: 'DIV_CODE'             ,  width: 90, hidden: true},
            { dataIndex: 'ITEM_REQ_NUM'         ,  width: 90},
            { dataIndex: 'ITEM_REQ_SEQ'         ,  width: 90},
            { dataIndex: 'ITEM_CODE'            ,  width: 90},
            { dataIndex: 'ITEM_NAME'            ,  width: 90},
            { dataIndex: 'SPEC'                 ,  width: 90},
            { dataIndex: 'STOCK_UNIT'           ,  width: 90},
            { dataIndex: 'REQ_Q'                ,  width: 90},
            { dataIndex: 'DEPT_CODE'            ,  width: 90, hidden: true},
            { dataIndex: 'PERSON_NUMB'          ,  width: 90, hidden: true},
            { dataIndex: 'ITEM_REQ_DATE'        ,  width: 90, hidden: true},
            { dataIndex: 'MONEY_UNIT'           ,  width: 90, hidden: true, align: 'center'},
            { dataIndex: 'EXCHG_RATE_O'         ,  width: 90, hidden: true},
            { dataIndex: 'DELIVERY_DATE'        ,  width: 90},
            { dataIndex: 'USE_REMARK'           ,  width: 90},
            { dataIndex: 'GW_DOCU_NUM'          ,  width: 90},
            { dataIndex: 'GW_FLAG'              ,  width: 90},
            { dataIndex: 'NEXT_YN'              ,  width: 90}
        ],
        listeners: {
            onGridDblClick:function(grid, record, cellIndex, colName) {
                if(Ext.isEmpty(record)) {
                    record = this.getSelectedRecord();
                }

            }
        },
        returnData: function(record)    {
            var records = this.sortedSelectedRecords(this);

            Ext.each(records, function(record,i){
                UniAppManager.app.onNewDataButtonDown();
                masterGrid.setItemRequestData(record.data);
                //masterGrid.setDepositData(record.data);
            });

        }
    });

    function openSearchInfoWindow() {           //조회버튼 누르면 나오는 조회창
        if(!SearchInfoWindow) {
            SearchInfoWindow = Ext.create('widget.uniDetailWindow', {
                title: '구매의뢰번호검색',
                width: 1200,
                height: 350,
                layout: {type:'vbox', align:'stretch'},
                items: [orderNoSearch, orderNoMasterGrid], //orderNoDetailGrid],
                tbar:  ['->',{
                    itemId : 'saveBtn',
                    text: '<t:message code="system.label.purchase.inquiry" default="조회"/>',
                    handler: function() {
                        orderNoMasterStore.loadStoreRecords();
                    },
                    disabled: false
                }, {
                    itemId : 'OrderNoCloseBtn',
                    text: '<t:message code="system.label.purchase.close" default="닫기"/>',
                    handler: function() {
                        SearchInfoWindow.hide();
                    },
                    disabled: false
                }],
                listeners : {
                    beforehide: function(me, eOpt)  {
                        orderNoSearch.clearForm();
                        orderNoMasterGrid.reset();
                    },
                    beforeclose: function( panel, eOpts )   {
                        orderNoSearch.clearForm();
                        orderNoMasterGrid.reset();
                    },
                    show: function( panel, eOpts )  {
                        orderNoSearch.setValue('DIV_CODE',      panelSearch.getValue('DIV_CODE'));
                        orderNoSearch.setValue('DEPT_CODE',     panelSearch.getValue('DEPT_CODE'));
                        orderNoSearch.setValue('DEPT_NAME',     panelSearch.getValue('DEPT_NAME'));
                        orderNoSearch.setValue('WH_CODE',       panelSearch.getValue('WH_CODE'));
                        orderNoSearch.setValue('CUSTOM_CODE',   panelSearch.getValue('CUSTOM_CODE'));
                        orderNoSearch.setValue('CUSTOM_NAME',   panelSearch.getValue('CUSTOM_NAME'));
                        orderNoSearch.setValue('ORDER_DATE_FR', UniDate.get('startOfMonth'));
                        orderNoSearch.setValue('ORDER_DATE_TO', panelSearch.getValue('ORDER_DATE'));
                        orderNoSearch.setValue('ORDER_PRSN',    panelSearch.getValue('ORDER_PRSN'));
                        orderNoSearch.setValue('ORDER_TYPE',    panelSearch.getValue('ORDER_TYPE'));
                        orderNoSearch.setValue('PO_REQ_DATE_TO', UniDate.get('today'));
                        orderNoSearch.setValue('PO_REQ_DATE_FR', UniDate.get('startOfMonth', orderNoSearch.getValue('PO_REQ_DATE_TO')));

                        if(BsaCodeInfo.gsApproveYN == '2'){
                            orderNoSearch.setValue('AGREE_STATUS','2');
                        }else if(BsaCodeInfo.gsApproveYN == '1'){
                            orderNoSearch.setValue('AGREE_STATUS',panelSearch.getValue('AGREE_STATUS'));
                        }
                     }
                }
            })
        }
        SearchInfoWindow.center();
        SearchInfoWindow.show();
    }

    function openOtherMrpWindow() {         //자재소요량정보 참조
        //if(!Unilite.Main.checkForNewDetail()) return false;
        if(BsaCodeInfo.gsAutoType=='N' && Ext.isEmpty(panelSearch.getValue('PO_REQ_NUM')))  {
            alert('구매요청번호는 필수입력값이고 수동입력입니다 먼저 입력후 진행하십시오');
            return false;
        }
        if(!panelSearch.setAllFieldsReadOnly(true)) return false;

        if(!referOtherMrpWindow) {
            referOtherMrpWindow = Ext.create('widget.uniDetailWindow', {
                title: '자재소요량정보참조',
                width: 1200,
                height: 350,
                layout: {type:'vbox', align:'stretch'},
                items: [otherorderSearch, otherorderGrid],
                tbar: ['->',{
                    itemId : 'saveBtn',
                    text: '<t:message code="system.label.purchase.inquiry" default="조회"/>',
                    handler: function() {
                        if(otherorderSearch.setAllFieldsReadOnly(true) == false){
                            return false;
                        }
                        otherOrderStore.loadStoreRecords();
                    },
                    disabled: false
                },{
                    itemId : 'confirmCloseBtn',
                    text: '적용 후 닫기',
                    handler: function() {
                        otherorderGrid.returnData();
                        referOtherMrpWindow.hide();
                        //directMasterStore1.loadStoreRecords();
                    },
                    disabled: false
                },{
                    itemId : 'closeBtn',
                    text: '<t:message code="system.label.purchase.close" default="닫기"/>',
                    handler: function() {
                        referOtherMrpWindow.hide();
                    },
                    disabled: false
                }],
                listeners: {
                    beforehide: function(me, eOpt)  {
                    },
                    beforeclose: function( panel, eOpts )   {
                    },
                    beforeshow: function ( me, eOpts )  {
                    },
                    show: function( panel, eOpts )  {
                        otherorderSearch.setValue('DIV_CODE',   panelSearch.getValue('DIV_CODE'));
                        otherorderSearch.setValue('ITEM_ACCOUNT',   panelSearch.getValue('ITEM_ACCOUNT'));
                        otherorderSearch.setValue('SUPPLY_TYPE',    panelSearch.getValue('SUPPLY_TYPE'));
                    }
                }
            })
        }
        referOtherMrpWindow.center();
        referOtherMrpWindow.show();
    };

    function openOutsidePlWindow() {            //외주P/L 참조
        //if(!Unilite.Main.checkForNewDetail()) return false;
        if(!panelSearch.setAllFieldsReadOnly(true)) return false;

        if(!outsidePlWindow) {
            outsidePlWindow = Ext.create('widget.uniDetailWindow', {
                title: '외주P/L참조',
                width: 1200,
                height: 350,
                layout: {type:'vbox', align:'stretch'},
                items: [outsidePlSearch, outsidePlGrid],
                tbar: ['->',{
                    itemId : 'saveBtn',
                    text: '<t:message code="system.label.purchase.inquiry" default="조회"/>',
                    handler: function() {
                        if(outsidePlSearch.setAllFieldsReadOnly(true) == false){
                            return false;
                        }
                        outsidePlStore.loadStoreRecords();
                    },
                    disabled: false
                },{
                    itemId : 'confirmCloseBtn',
                    text: '적용 후 닫기',
                    handler: function() {
                        outsidePlGrid.returnData();
                        outsidePlWindow.hide();
                        //directMasterStore1.loadStoreRecords();
                    },
                    disabled: false
                },{
                    itemId : 'closeBtn',
                    text: '<t:message code="system.label.purchase.close" default="닫기"/>',
                    handler: function() {
                        outsidePlWindow.hide();
                    },
                    disabled: false
                }],
                listeners: {
                    beforehide: function(me, eOpt)  {
                    },
                    beforeclose: function( panel, eOpts )   {
                    },
                    beforeshow: function ( me, eOpts )  {
                    },
                    show: function( panel, eOpts )  {
                        outsidePlSearch.setValue('DIV_CODE',       panelSearch.getValue('DIV_CODE'));
                        outsidePlSearch.setValue('ITEM_ACCOUNT',   panelSearch.getValue('ITEM_ACCOUNT'));
                        outsidePlSearch.setValue('SUPPLY_TYPE',    panelSearch.getValue('SUPPLY_TYPE'));
                    }
                }
            })
        }
        outsidePlWindow.center();
        outsidePlWindow.show();
    };

    function openItemRequestWindow() {            //물품의뢰 참조
        //if(!Unilite.Main.checkForNewDetail()) return false;
        if(!panelSearch.setAllFieldsReadOnly(true)) return false;

        if(!itemRequestWindow) {
            itemRequestWindow = Ext.create('widget.uniDetailWindow', {
                title: '물품의뢰참조',
                width: 1200,
                height: 350,
                layout: {type:'vbox', align:'stretch'},
                items: [itemRequestSearch, itemRequestGrid],
                tbar: ['->',{
                    itemId : 'saveBtn',
                    text: '<t:message code="system.label.purchase.inquiry" default="조회"/>',
                    handler: function() {
                        if(itemRequestSearch.setAllFieldsReadOnly(true) == false){
                            return false;
                        }
                        itemRequestStore.loadStoreRecords();
                    },
                    disabled: false
                },{
                    itemId : 'confirmCloseBtn',
                    text: '적용 후 닫기',
                    handler: function() {
                        itemRequestGrid.returnData();
                        itemRequestWindow.hide();
                        //directMasterStore1.loadStoreRecords();
                    },
                    disabled: false
                },{
                    itemId : 'closeBtn',
                    text: '<t:message code="system.label.purchase.close" default="닫기"/>',
                    handler: function() {
                        itemRequestWindow.hide();
                    },
                    disabled: false
                }],
                listeners: {
                    beforehide: function(me, eOpt)  {
                    },
                    beforeclose: function( panel, eOpts )   {
                    },
                    beforeshow: function ( me, eOpts )  {
                    },
                    show: function( panel, eOpts )  {
                        itemRequestSearch.setValue('DIV_CODE',       panelSearch.getValue('DIV_CODE'));
                        itemRequestSearch.setValue('DEPT_CODE',      panelSearch.getValue('DEPT_CODE'));
                        itemRequestSearch.setValue('DEPT_NAME',      panelSearch.getValue('DEPT_NAME'));
                        itemRequestSearch.setValue('PERSON_NUMB',    panelSearch.getValue('PERSON_NUMB'));
                        itemRequestSearch.setValue('PERSON_NAME',    panelSearch.getValue('PERSON_NAME'));
                    }
                }
            })
        }
        itemRequestWindow.center();
        itemRequestWindow.show();
    };


    Unilite.Main({
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
        id: 'mre100ukrvApp',
        fnInitBinding: function() {
//          panelSearch.setValue('DEPT_CODE',UserInfo.deptCode);
//          panelSearch.setValue('DEPT_NAME',UserInfo.deptName);
//          panelResult.setValue('DEPT_CODE',UserInfo.deptCode);
//          panelResult.setValue('DEPT_NAME',UserInfo.deptName);
//          panelSearch.setValue('PERSON_NUMB',UserInfo.userID);
//          panelSearch.setValue('PERSON_NAME',UserInfo.userName);
//          panelResult.setValue('PERSON_NUMB',UserInfo.userID);
//          panelResult.setValue('PERSON_NAME',UserInfo.userName);

            UniAppManager.setToolbarButtons(['reset','newData','print', 'prev', 'next'], true);
            this.setDefault();
        },
        onQueryButtonDown: function()   {
            panelSearch.setAllFieldsReadOnly(false);
            var orderNo = panelSearch.getValue('PO_REQ_NUM');
            if(Ext.isEmpty(orderNo)) {
                openSearchInfoWindow()
            } else {
                directMasterStore1.loadStoreRecords();
                panelSearch.setAllFieldsReadOnly(true);
                panelResult.setAllFieldsReadOnly(true);
            }
        },
        onNewDataButtonDown: function() {
            if(!this.checkForNewDetail()) return false;
                /**
                 * Detail Grid Default 값 설정
                 */
             var poReqNum = panelSearch.getValue('PO_REQ_NUM');
             var seq = directMasterStore1.max('PO_SER_NO');
             if(!seq) seq = 1;
             else  seq += 1;
             var divCode = panelSearch.getValue('DIV_CODE');
             var moneyUnit = panelSearch.getValue('MONEY_UNIT'); // MoneyUnit
             var exchgRateO = panelSearch.getValue('EXCHG_RATE_O');
             var unitPriceType = 'Y';
             var orderYn = 'N';
             var dvryDate = UniDate.get('today');
             var poReqDate = UniDate.get('today');

             var orderQ = '0';
             var orderP = '0';
             var orderO = '0';
             var orderUnitQ = '0';

             var trnsRate = '1';
             var orderLocP = '0';
             var orderLocO = '0';
             var inspecFlag = 'N';

             var r = {
                PO_REQ_NUM: poReqNum,
                PO_SER_NO: seq,
                DIV_CODE: divCode,
                UNIT_PRICE_TYPE: unitPriceType,
                ORDER_YN: orderYn,

                ORDER_Q: orderQ,
                ORDER_P: orderP,
                ORDER_O: orderO,
                ORDER_UNIT_Q: orderUnitQ,

                TRNS_RATE: trnsRate,
                ORDER_LOC_P: orderLocP,
                ORDER_LOC_O: orderLocO,
                DVRY_DATE: dvryDate,
                PO_REQ_DATE: poReqDate,
                MONEY_UNIT: moneyUnit,
                EXCHG_RATE_O: exchgRateO,
                INSPEC_FLAG: inspecFlag
            };
            masterGrid.createRow(r);
            panelSearch.setAllFieldsReadOnly(true);
            panelResult.setAllFieldsReadOnly(true);
        },
        onResetButtonDown: function() {
            panelSearch.clearForm();
            panelSearch.setAllFieldsReadOnly(false);
            panelResult.setAllFieldsReadOnly(false);
            masterGrid.reset();
            panelResult.clearForm();
            directMasterStore1.clearData();
            this.fnInitBinding();
        },
        onSaveDataButtonDown: function(config) {
            /*
            if(!directMasterStore1.isDirty())   {
                if(panelSearch.isDirty())   {
                    panelSearch.saveForm();
                }
            }else {
                directMasterStore1.saveStore();
            }
            */

            if(directMasterStore1.isDirty())    {
                directMasterStore1.saveStore();
            }
        },
        onDeleteDataButtonDown: function() {
            var selRow = masterGrid.getSelectedRecord();
            if(selRow.phantom === true) {
                masterGrid.deleteSelectedRow();
            }else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
                if(selRow.get('ORDER_YN') == 'Y')
                {
                    alert('발주되어 삭제할수 없습니다');
                }else{
                    masterGrid.deleteSelectedRow();
                }
            }
        },
        onDeleteAllButtonDown: function() {
            var records = directMasterStore1.data.items;
            var isNewData = false;
            Ext.each(records, function(record,i) {
                if(record.phantom){                     //신규 레코드일시 isNewData에 true를 반환
                    isNewData = true;
                }else{                                  //신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
                    if(confirm('전체삭제 하시겠습니까?')) {
                        if(record.get('INSPEC_Q') > 1){
                                alert('<t:message code="unilite.msg.sMM435"/>');
                        }else{
                            var deletable = true;
                            if(deletable){
                                masterGrid.reset();
                                UniAppManager.app.onSaveDataButtonDown();
                            }
                            isNewData = false;
                        }
                    }
                    return false;
                }
            });
            if(isNewData){                              //신규 레코드들만 있을시 그리드 리셋
                masterGrid.reset();
                UniAppManager.app.onResetButtonDown();  //삭제후 RESET..
            }
        },
        onPrintButtonDown: function() {
            alert('추후 만들어질 예정입니다.');
            /*
            if(panelSearch.getValue('AGREE_STATUS') != '2'){
                alert('미승인건은 인쇄할 수 없습니다.');
                return false;
            }
            var param= Ext.getCmp('searchForm').getValues();
            var win = Ext.create('widget.PDFPrintWindow', {
                url: CPATH+'/mpo/mpo502rkrPrint.do',
                prgID: 'mpo502rkr',
                    extParam: {
                        PO_REQ_NUM : param.PO_REQ_NUM,
                        DIV_CODE : panelSearch.getValue('DIV_CODE')
                    }
                });
            win.center();
            win.show();
            */
        },
        setDefault: function() {
            panelSearch.setValue('DIV_CODE',UserInfo.divCode);
            panelSearch.setValue('PO_REQ_DATE',new Date());
            panelResult.setValue('PO_REQ_DATE',new Date());
            panelSearch.setValue('MONEY_UNIT', BsaCodeInfo.gsDefaultMoney);
            panelSearch.setValue('SUPPLY_TYPE', '1');
//            panelSearch.setValue('ITEM_ACCOUNT', '00');
//            panelResult.setValue('ITEM_ACCOUNT', '00');
            // panelResult.setValue('DIV_CODE',UserInfo.divCode);
            UniAppManager.app.fnExchngRateO();

            panelSearch.getForm().wasDirty = false;
            panelSearch.resetDirtyStatus();
            UniAppManager.setToolbarButtons('save', false);

        },
        fnExchngRateO:function() {
            var param = {
                "AC_DATE"    : UniDate.getDbDateStr(panelSearch.getValue('PO_REQ_DATE')),
                "MONEY_UNIT" : panelSearch.getValue('MONEY_UNIT')
            };
            mre100ukrvService.fnExchgRateO(param, function(provider, response) {
                panelSearch.setValue('EXCHG_RATE_O', provider[0].BASE_EXCHG);
                panelResult.setValue('EXCHG_RATE_O', provider[0].BASE_EXCHG);
            });
        },
        checkForNewDetail:function() {
            if(BsaCodeInfo.gsAutoType=='N' && Ext.isEmpty(panelSearch.getValue('PO_REQ_NUM')))  {
                alert('구매요청번호는 필수입력값이고 수동입력입니다 먼저 입력후 진행하십시오');
                return false;
            }
            return panelSearch.setAllFieldsReadOnly(true);
        },
        fnCalOrderAmt: function(rtnRecord, sType, nValue) {
            var dOrderUnitQ= sType =='Q' ? nValue : Unilite.nvl(rtnRecord.get('ORDER_Q'),0);  //발주요청량
            var dOrderUnitP= sType =='P' ? nValue : Unilite.nvl(rtnRecord.get('ORDER_P'),0);       //구매단위 단가
            var dOrderO= sType =='O' ? nValue : Unilite.nvl(rtnRecord.get('ORDER_O'),0);
            var dTransRate= sType =='R' ? nValue : Unilite.nvl(rtnRecord.get('TRNS_RATE'),1);
            var dOrderQ;  //발주요청량(구매)
            ///var dOrderP;
            var dExchgRateO= sType =='X' ? nValue : Unilite.nvl(rtnRecord.get('EXCHG_RATE_O'),1); //환율
            var dOrderLocP= sType =='L' ? nValue : Unilite.nvl(rtnRecord.get('ORDER_LOC_P'),0);
            var dOrderLocO= sType =='I' ? nValue : Unilite.nvl(rtnRecord.get('ORDER_LOC_O'),0);

            if(sType == 'P' || sType == 'Q'){
                dOrderQ = dOrderUnitQ * dTransRate;
                rtnRecord.set('ORDER_UNIT_Q', dOrderQ);

                dOrderO = dOrderUnitQ * dOrderUnitP; //금액 = 발주요청량 * 단가
                rtnRecord.set('ORDER_O', dOrderO);

                //dOrderP = dOrderUnitP / dTransRate;
                //rtnRecord.set('ORDER_P', dOrderP);

                dOrderLocP = dOrderUnitP * dExchgRateO;
                rtnRecord.set('ORDER_LOC_P', dOrderLocP);

                dOrderLocO = dOrderUnitQ * dOrderLocP;
                rtnRecord.set('ORDER_LOC_O', dOrderLocO);

            }else if(sType == 'R'){      //구매입수
                dOrderQ = dOrderUnitQ / dTransRate;
                //dOrderQ = dOrderUnitQ * dTransRate;
                rtnRecord.set('ORDER_Q', dOrderQ);

                //dOrderP = dOrderUnitP / dTransRate;
                //rtnRecord.set('ORDER_P', dOrderP);
            }else if(sType == 'O'){                 // DISABLE
                if(Math.abs(dOrderUnitQ) > '0'){
                    dOrderUnitP = Math.abs(dOrderO) / Math.abs(dOrderUnitQ);
                    rtnRecord.set('ORDER_P', dOrderUnitP);

                    dOrderP = dOrderUnitP / dTransRate;
                    rtnRecord.set('ORDER_P', dOrderP);

                    dOrderLocP = dOrderUnitP * dExchgRateO;
                    rtnRecord.set('ORDER_LOC_P', dOrderLocP);

                    dOrderLocO = dOrderUnitQ * dOrderLocP;
                    rtnRecord.set('ORDER_LOC_O', dOrderLocO);
                }else{
                    rtnRecord.set('ORDER_P', '0');
                    rtnRecord.set('ORDER_P', '0');
                    rtnRecord.set('ORDER_LOC_P', '0');

                    dOrderLocO = dOrderO * dExchgRateO;
                    rtnRecord.set('ORDER_LOC_O', dOrderLocO);
                }
            }else if(sType == 'X'){                //환율
                dOrderLocP = dOrderUnitP * dExchgRateO;
                rtnRecord.set('ORDER_LOC_P', dOrderLocP);

                dOrderLocO = dOrderUnitQ * dOrderLocP;
                rtnRecord.set('ORDER_LOC_O', dOrderLocO);
            }else if(sType == 'L'){               //자사단가  DISABLE
                dOrderLocO = dOrderLocP * dOrderUnitQ;
                rtnRecord.set('ORDER_LOC_O', dOrderLocO);

                dOrderUnitP = dOrderLocP / dExchgRateO;
                rtnRecord.set('ORDER_P', dOrderUnitP);

                dOrderO = dOrderUnitQ * dOrderUnitP;
                rtnRecord.set('ORDER_O', dOrderO);

                dOrderQ = dOrderUnitQ * dTransRate;
                rtnRecord.set('ORDER_Q', dOrderQ);

                dOrderP = dOrderUnitP / dTransRate;
                rtnRecord.set('ORDER_P', dOrderP);
            }else if(sType == 'I'){           //자사금액 DISABLE
                dOrderLocP = dOrderLocO / dOrderUnitQ;
                rtnRecord.set('ORDER_LOC_P', dOrderLocP);

                dOrderUnitP = dOrderLocP / dExchgRateO;
                rtnRecord.set('ORDER_P', dOrderUnitP);

                dOrderO = dOrderUnitQ * dOrderUnitP;
                rtnRecord.set('ORDER_O', dOrderO);

                dOrderQ = dOrderUnitQ * dTransRate;
                rtnRecord.set('ORDER_Q', dOrderQ);

                dOrderP = dOrderUnitP / dTransRate;
                rtnRecord.set('ORDER_P', dOrderP);
            }
        }
    });

    Unilite.createValidator('validator01', {
        store: directMasterStore1,
        grid: masterGrid,
        validate: function( type, fieldName, newValue, oldValue, record, eopt) {
        console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
            var rv = true;
            switch(fieldName) {
                case "PO_SER_NO" : //발주순번
                    if(newValue <= 0){
                        rv='<t:message code="unilite.msg.sMB076"/>';
                        break;
                    }

                case "ORDER_UNIT" :
                    directMasterStore1.fnSumOrderO();
                break;

//              case "ORDER_UNIT_Q" :
//                    if(newValue <= 0){
//                        rv='<t:message code="unilite.msg.sMB076"/>';
//                        break;
//                    }
//                    UniAppManager.app.fnCalOrderAmt(record, "Q", newValue);
//                    directMasterStore1.fnSumOrderO();
//                    break;

                case "ORDER_Q" :
                    if(newValue <= 0){
                        rv='<t:message code="unilite.msg.sMB076"/>';
                        break;
                    }
                    UniAppManager.app.fnCalOrderAmt(record, "Q", newValue);
                    directMasterStore1.fnSumOrderO();
                    break;

                case "ORDER_P":
                    if(record.get('UNIT_PRICE_TYPE') == 'Y'){
                        if(newValue <= 0){
                        rv='<t:message code="unilite.msg.sMB076"/>';
                        break;
                        }
                    }
                    UniAppManager.app.fnCalOrderAmt(record, "P", newValue);
                    directMasterStore1.fnSumOrderO();
                    break;

                case "ORDER_O" :
                    if(newValue <= 0){
                        rv='<t:message code="unilite.msg.sMB076"/>';
                        break;
                    }
                    UniAppManager.app.fnCalOrderAmt(record, "O", newValue);
                    directMasterStore1.fnSumOrderO();
                    break;

                case "MONEY_UNIT" :
                    if(newValue == BsaCodeInfo.gsDefaultMoney){
                        record.set('EXCHG_RATE_O', '1');
                    }
                    UniAppManager.app.fnCalOrderAmt(record, "X");
                    directMasterStore1.fnSumOrderO();
                    break;

                case "EXCHG_RATE_O":
                    if(newValue <= 0){
                        rv='<t:message code="unilite.msg.sMB076"/>';
                        break;
                    }
                    UniAppManager.app.fnCalOrderAmt(record, "X", newValue);
                    directMasterStore1.fnSumOrderO();
                    break;

                case "ORDER_LOC_P":              //자사단가
                    if(record.get('UNIT_PRICE_TYPE') == 'Y'){
                        if(newValue <= 0){
                            rv='<t:message code="unilite.msg.sMB076"/>';
                            break;
                        }
                    }
                    UniAppManager.app.fnCalOrderAmt(record, "L", newValue);
                    directMasterStore1.fnSumOrderO();
                    break;

                case "ORDER_LOC_O":              //자사금액
                    if(newValue <= 0){
                            rv='<t:message code="unilite.msg.sMB076"/>';
                            break;
                    }
                    UniAppManager.app.fnCalOrderAmt(record, "I", newValue);
                    directMasterStore1.fnSumOrderO();
                    break;

                case "DVRY_DATE":
                    if(newValue < panelSearch.getValue('ORDER_DATE')){
                        rv='<t:message code="unilite.msg.sMM374"/>';
                                break;
                    }
                    break;

                case "TRNS_RATE":
                    if(newValue <= 0){
                            rv='<t:message code="unilite.msg.sMB076"/>';
                            break;
                    }
                    UniAppManager.app.fnCalOrderAmt(record, "R", newValue);
                    directMasterStore1.fnSumOrderO();
                    break;

            }
            return rv;
        }
    });
};
</script>
