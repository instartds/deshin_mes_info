<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_pbs071ukrv_kd"  >
    <t:ExtComboStore comboType="BOR120"  />             <!-- 사업장 -->
    <t:ExtComboStore items="${COMBO_WS_LIST}" storeId="wsList" /> <!-- 작업장 -->
    <t:ExtComboStore comboType="AU" comboCode="A020"/> <!-- 예/아니오 -->
    <t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" /><!--창고-->
    <t:ExtComboStore comboType="AU" comboCode="B024"/> <!-- 입고담당 -->
    <t:ExtComboStore comboType="AU" comboCode="P003"/> <!-- 불량유형 -->
    <t:ExtComboStore comboType="AU" comboCode="P002"/> <!-- 특기사항 분류 -->
    <t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
    <t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
    <t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

var BsaCodeInfo = {
    gsMoldCode      : '${gsMoldCode}',              // 작업지시 설비여부
    gsEquipCode     : '${gsEquipCode}',             // 작업지시 금형여부
    gsProgWorkCode  : '${gsProgWorkCode}'           // 공정등록기준
};

var outDivCode = UserInfo.divCode;
var copyProgWorkShopCode; // 공정복사
var selectedGrid = '';

function appMain() {

	var isMoldCode = false;
    if(BsaCodeInfo.gsMoldCode=='N') {
        isMoldCode = true;
    }

    var isEquipCode = false;
    if(BsaCodeInfo.gsEquipCode=='N') {
        isEquipCode = true;
    }

    var isProgWorkCode = false;
    if(BsaCodeInfo.gsProgWorkCode=='2') {
        isProgWorkCode = true;
    }

    var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{      // 공정 등록
        api: {
            read: 's_pbs071ukrv_kdService.selectList'
        }
    });

    var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{     // 공정수순 등록
        api: {
            read: 's_pbs071ukrv_kdService.selectList2',
            create: 's_pbs071ukrv_kdService.insertDetail',
            update: 's_pbs071ukrv_kdService.updateDetail',
            destroy: 's_pbs071ukrv_kdService.deleteDetail',
            syncAll: 's_pbs071ukrv_kdService.saveAll'
        }
    });

    var directProxy3 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{     // 공정품목 등록
        api: {
            read: 's_pbs071ukrv_kdService.selectList3',
            create: 's_pbs071ukrv_kdService.insertDetail3',
            update: 's_pbs071ukrv_kdService.updateDetail3',
            destroy: 's_pbs071ukrv_kdService.deleteDetail3',
            syncAll: 's_pbs071ukrv_kdService.saveAll3'
        }
    });

    var directProxy4 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{     // 공정&설비 등록
        api: {
            read: 's_pbs071ukrv_kdService.selectList4',
            update: 's_pbs071ukrv_kdService.updateDetail4',
            create: 's_pbs071ukrv_kdService.insertDetail4',
            destroy: 's_pbs071ukrv_kdService.deleteDetail4',
            syncAll: 's_pbs071ukrv_kdService.saveAll4'
        }
    });

    var directProxy5 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{     // 공정&금형 등록
        api: {
            read: 's_pbs071ukrv_kdService.selectList5',
            update: 's_pbs071ukrv_kdService.updateDetail5',
            create: 's_pbs071ukrv_kdService.insertDetail5',
            destroy: 's_pbs071ukrv_kdService.deleteDetail5',
            syncAll: 's_pbs071ukrv_kdService.saveAll5'
      }
    });



    // 공정등록 모델
    Unilite.defineModel('pbs071ukrvsModel', {
        fields: [
                {name: 'ITEM_CODE'              ,text:'품목코드'           ,type : 'string' ,editable: false},
                {name: 'ITEM_NAME'              ,text:'품명'               ,type : 'string',editable: false},
                {name: 'SPEC'                   ,text:'규격'               ,type : 'string',editable: false},
                {name: 'STOCK_UNIT'             ,text:'단위'               ,type : 'string',editable: false},
                {name: 'ITEM_ACCOUNT'           ,text:'계정코드'           ,type : 'string',editable: false},
                {name: 'ITEMACCOUNT_NAME'       ,text:'계정구분'           ,type : 'string'/*, comboType:'AU', comboCode:'B020'*/,editable: false},
                {name: 'SUPPLY_TYPE'            ,text:'조달구분'           ,type : 'string', comboType:'AU', comboCode:'B014',editable: false},
                {name: 'PROG_CNT'               ,text:'등록수'             ,type : 'uniQty',editable: false},
                {name: 'ITEMLEVEL1_NAME'        ,text:'대분류'             ,type : 'string',editable: false},
                {name: 'ITEMLEVEL2_NAME'        ,text:'중분류'             ,type : 'string',editable: false},
                {name: 'ITEMLEVEL3_NAME'        ,text:'소분류'             ,type : 'string',editable: false}
        ]
    });

    // 공정수순 모델
    Unilite.defineModel('pbs071ukrvs2Model', {
        fields: [
//                {name: 'FLAG'                   ,text:'FLAG'               ,type : 'string'},
                {name: 'SORT_FLD'               ,text:'SORT_FLD'           ,type : 'string'},
                {name: 'DIV_CODE'               ,text:'사업장'             ,type : 'string'},
                {name: 'ITEM_CODE'              ,text:'품목코드'           ,type : 'string'},
                {name: 'ITEM_NAME'              ,text:'품목명'             ,type : 'string'},
                {name: 'SPEC'                   ,text:'규격'               ,type : 'string'},
                {name: 'WORK_SHOP_CODE'         ,text:'작업장'             ,type : 'string'},
                {name: 'PROG_WORK_CODE'         ,text:'공정코드'           ,type : 'string', allowBlank: false},
                {name: 'PROG_WORK_NAME'         ,text:'공정명'             ,type : 'string', allowBlank: false},
                {name: 'LINE_SEQ'               ,text:'공정순서'           ,type : 'int', allowBlank: true},
                {name: 'MAKE_LDTIME'            ,text:'공정표준시간'       ,type : 'int', allowBlank: true},
                {name: 'PROG_RATE'              ,text:'공정진척율'         ,type : 'int', allowBlank: true},
                {name: 'PROG_UNIT_Q'            ,text:'공정원단위량'       , type: 'float', decimalPrecision: 6, format:'0,000.000000', allowBlank: true},
                {name: 'PROG_UNIT'              ,text:'공정단위'           ,type : 'string', allowBlank: false},
                {name: 'REMARK'                 ,text:'비고'               ,type : 'string'},
                {name: 'REF_ITEM_CODE'          ,text:'참조품목코드'       ,type : 'string'}
        ]
    });

    // 공정품목 모델
    Unilite.defineModel('pbs071ukrvs3Model', {
        fields: [
                {name: 'COMP_CODE'              ,text:'법인코드'           ,type : 'string'},
                {name: 'DIV_CODE'               ,text:'사업장'             ,type : 'string'},
                {name: 'ITEM_CODE'              ,text:'품목코드'           ,type : 'string'},
                {name: 'SPEC'                   ,text:'규격'               ,type : 'string'},
                {name: 'STOCK_UNIT'             ,text:'재고단위'           ,type : 'string'},
                {name: 'WORK_SHOP_CODE'         ,text:'작업장'             ,type : 'string'},
                {name: 'PROG_WORK_CODE'         ,text:'공정코드'           ,type : 'string'},
                {name: 'CHILD_ITEM_CODE'        ,text:'품목코드'           ,type : 'string', allowBlank: false},
                {name: 'CHILD_ITEM_NAME'        ,text:'품목명'             ,type : 'string', allowBlank: false},
                {name: 'UNIT_Q'                 ,text:'원단위량'           , type: 'float', decimalPrecision: 6, format:'0,000.000000'},
                {name: 'PROD_UNIT_Q'            ,text:'모품목수'           ,type : 'uniQty'},
                {name: 'REMARK'                 ,text:'비고'               ,type : 'string'}
        ]
    });

    // 공정/설비등록 모델
    Unilite.defineModel('pbs071ukrvs4Model', {
        fields: [
            {name: 'COMP_CODE'             ,text:'법인'         ,type : 'string'},
            {name: 'DIV_CODE'              ,text:'사업장'       ,type : 'string', comboType:'BOR120'},
            {name: 'ITEM_CODE'             ,text:'품목코드'     ,type : 'string'},
            {name: 'WORK_SHOP_CODE'        ,text:'작업장'       ,type : 'string'},
            {name: 'PROG_WORK_CODE'        ,text:'공정코드'     ,type : 'string'},
            {name: 'EQUIP_CODE'            ,text:'설비코드'     ,type : 'string', allowBlank: isEquipCode},
            {name: 'EQUIP_NAME'            ,text:'설비명'       ,type : 'string', allowBlank: isEquipCode},
            {name: 'SELECT_BASIS'          ,text:'기본'         ,type : 'string', comboType: 'AU', comboCode: 'A020'},
            {name: 'REMARK'               ,text:'비고'         ,type : 'string'}
        ]
    });

    // 공정/금형등록 모델
    Unilite.defineModel('pbs071ukrvs5Model', {
        fields: [
            {name: 'COMP_CODE'             ,text:'법인'         ,type : 'string'},
            {name: 'DIV_CODE'              ,text:'사업장'       ,type : 'string', comboType:'BOR120'},
            {name: 'ITEM_CODE'             ,text:'품목코드'     ,type : 'string'},
            {name: 'WORK_SHOP_CODE'        ,text:'작업장'       ,type : 'string'},
            {name: 'PROG_WORK_CODE'        ,text:'공정코드'     ,type : 'string'},
            {name: 'MOLD_CODE'             ,text:'금형코드'     ,type : 'string', allowBlank: isMoldCode},
            {name: 'MOLD_NAME'             ,text:'금형명'       ,type : 'string', allowBlank: isMoldCode},
            {name: 'SELECT_BASIS'          ,text:'기본'         ,type : 'string', comboType: 'AU', comboCode: 'A020'},
            {name: 'REMARK'               ,text:'비고'         ,type : 'string'}
        ]
    });


    // 스토어
    var directMasterStore = Unilite.createStore('directMasterStore',{
            model: 'pbs071ukrvsModel',
            autoLoad: false,
            uniOpt : {
                isMaster: false,         // 상위 버튼 연결
                editable: true,         // 수정 모드 사용
                deletable:true,         // 삭제 가능 여부
                useNavi : false         // prev | next 버튼 사용
            },
            proxy : directProxy,
            saveStore : function(){

            	var inValidRecs = this.getInvalidRecords();
                var rv = true;

                if(inValidRecs.length == 0 ){
                    this.syncAllDirect();
                } else {
                    var grid = Ext.getCmp('s_pbs071ukrv_kdGrid');
                    grid.uniSelectInvalidColumnAndAlert(inValidRecs);
                }
            },
            loadStoreRecords : function(){
                var param= panelSearch.getValues();
                param.GS_WORK_SHOP_CODE = BsaCodeInfo.gsProgWorkCode;
                console.log(param);
                this.load({
                    params : param
                });
            },
            listeners: {
                load: function(store, records, successful, eOpts) {
                    if(directMasterStore.count() == 0) {
                        Ext.getCmp('COPY_BTN_PROG').setDisabled(true);
                    } else {
                        Ext.getCmp('COPY_BTN_PROG').setDisabled(false);
                    }
                }
            }
    });
    // 공정수순 스토어
    var directMasterStore2 = Unilite.createStore('directMasterStore2',{
            model: 'pbs071ukrvs2Model',
            autoLoad: false,
            uniOpt : {
                isMaster: false,         // 상위 버튼 연결
                editable: true,         // 수정 모드 사용
                deletable:true,         // 삭제 가능 여부
                allDeletable: true,     // 전체 삭제 가능 여부
                useNavi : false         // prev | next 버튼 사용
            },
            proxy : directProxy2,
            saveStore : function()  {
                var inValidRecs = this.getInvalidRecords();
                var rv = true;

                var toCreate = this.getNewRecords();
                var toUpdate = this.getUpdatedRecords();
                var toDelete = this.getRemovedRecords();
                var list = [].concat(toUpdate, toCreate);
                var paramMaster = panelSearch.getValues();

                var isErr = false;
                Ext.each(list, function(record, index) {
                    if(record.get('LINE_SEQ') == 0){
                        alert((index + 1) + '행의 입력값을 확인해 주세요.\n' + '공정순서: 필수 입력값 입니다.');
                        isErr = true;
                        return false;
                    }
                });
                if(isErr) return false;

                if(inValidRecs.length == 0 )    {
                     config = {
                            params: [paramMaster],
                            success: function(batch, option) {
                             }
                    };
                    this.syncAllDirect(config);
                } else {
                    var grid = Ext.getCmp('s_pbs071ukrv_kdGrid2');
                    grid.uniSelectInvalidColumnAndAlert(inValidRecs);
                }
            },
            loadStoreRecords : function(param){
            	if(Ext.isEmpty(param)) {
            	   	var param = BsaCodeInfo.gsProgWorkCode;
            	} else {
                    param.GS_WORK_SHOP_CODE = BsaCodeInfo.gsProgWorkCode;
            	}
                this.load({
                    params: param
                });
            },
            listeners: {
                load: function(store, records, successful, eOpts) {
                    if(directMasterStore2.count() == 0) {
                        Ext.getCmp('COPY_BTN').setDisabled(true);
                        //selectedGrid = 's_pbs071ukrv_kdGrid2';
                        UniAppManager.setToolbarButtons(['newData'], true);
                        masterGrid3.reset();
                    	directMasterStore3.clearData();
                    } else {
                        Ext.getCmp('COPY_BTN').setDisabled(false);
                        //selectedGrid = 's_pbs071ukrv_kdGrid2';
                        UniAppManager.setToolbarButtons(['delete', 'newData'], true);
                    }
                },
                datachanged : function(store,  eOpts) {
                    if( directMasterStore.isDirty() || store.isDirty()) {
                        UniAppManager.setToolbarButtons('save', true);
                    }else {
                        UniAppManager.setToolbarButtons('save', false);
                    }
                }
            }
    });
    // 공정품목 스토어
    var directMasterStore3 = Unilite.createStore('directMasterStore3',{
            model: 'pbs071ukrvs3Model',
            autoLoad: false,
            uniOpt : {
                isMaster: false,         // 상위 버튼 연결
                editable: true,         // 수정 모드 사용
                deletable:true,         // 삭제 가능 여부
                allDeletable: true,     // 전체 삭제 가능 여부
                useNavi : false         // prev | next 버튼 사용
            },
            proxy : directProxy3,
            saveStore : function()  {
                var inValidRecs = this.getInvalidRecords();
                var rv = true;
                var paramMaster = panelSearch.getValues();
                if(inValidRecs.length == 0 )    {
                     config = {
                            params: [paramMaster],
                            success: function(batch, option) {
                             }
                    };
                    this.syncAllDirect(config);
                } else {
                    var grid = Ext.getCmp('s_pbs071ukrv_kdGrid3');
                    grid.uniSelectInvalidColumnAndAlert(inValidRecs);
                }
            },
            loadStoreRecords : function(param){
                if(Ext.isEmpty(param)) {
                    var param = BsaCodeInfo.gsProgWorkCode;
                }
                this.load({
                    params: param
                });
            },
            listeners: {
                load: function(store, records, successful, eOpts) {
                    if(records != null && records.length > 0 ){
                        UniAppManager.setToolbarButtons('delete', true);
                    }
                },
                update : function( store, record, operation, modifiedFieldNames, details, eOpts ){
                    UniAppManager.setToolbarButtons('save', true);
                },
                datachanged : function(store,  eOpts) {
                    if( directMasterStore2.isDirty() || store.isDirty()) {
                        UniAppManager.setToolbarButtons('save', true);
                    }else {
                        UniAppManager.setToolbarButtons('save', false);
                    }
                }
            }
    });

    // 공정/설비등록 스토어
    var directMasterStore4 = Unilite.createStore('directMasterStore4',{
            model: 'pbs071ukrvs4Model',
            autoLoad: false,
            uniOpt : {
                isMaster: false,         // 상위 버튼 연결
                editable: true,         // 수정 모드 사용
                deletable:true,         // 삭제 가능 여부
                useNavi : false         // prev | next 버튼 사용
            },
            proxy : directProxy4,
            saveStore : function()  {

            	var inValidRecs = this.getInvalidRecords();
                var rv = true;

                if(inValidRecs.length == 0 )    {
                    this.syncAllDirect();
                } else {
                    var grid = Ext.getCmp('s_pbs071ukrv_kdGrid4');
                    grid.uniSelectInvalidColumnAndAlert(inValidRecs);
                }
            },
            loadStoreRecords : function(param){
                if(Ext.isEmpty(param)) {
                    var param = BsaCodeInfo.gsProgWorkCode;
                }
                this.load({
                    params: param
                });
             },
            listeners: {
                load: function(store, records, successful, eOpts) {
                    if(records != null && records.length > 0 ){
                        UniAppManager.setToolbarButtons('delete', true);
                    }
                },
                update : function( store, record, operation, modifiedFieldNames, details, eOpts ){
                    UniAppManager.setToolbarButtons('save', true);
                },
                datachanged : function(store,  eOpts) {
                    if( directMasterStore2.isDirty() || store.isDirty()) {
                        UniAppManager.setToolbarButtons('save', true);
                    }else {
                        UniAppManager.setToolbarButtons('save', false);
                    }
                }
            }
    });
    // 공정/금형등록 스토어
    var directMasterStore5 = Unilite.createStore('directMasterStore5',{
            model: 'pbs071ukrvs5Model',
            autoLoad: false,
            uniOpt : {
                isMaster: false,         // 상위 버튼 연결
                editable: true,         // 수정 모드 사용
                deletable:true,         // 삭제 가능 여부
                useNavi : false         // prev | next 버튼 사용
            },
            proxy : directProxy5,
            saveStore : function()  {

            	var inValidRecs = this.getInvalidRecords();
                var rv = true;

                if(inValidRecs.length == 0 )    {
                    this.syncAllDirect();
                } else {
                    var grid = Ext.getCmp('s_pbs071ukrv_kdGrid5');
                    grid.uniSelectInvalidColumnAndAlert(inValidRecs);
                }
            },
            loadStoreRecords : function(param){
                if(Ext.isEmpty(param)) {
                    var param = BsaCodeInfo.gsProgWorkCode;
                }
                this.load({
                    params: param
                });
             },
            listeners: {
                load: function(store, records, successful, eOpts) {
                    if(records != null && records.length > 0 ){
                        UniAppManager.setToolbarButtons('delete', true);
                    }
                },
                update : function( store, record, operation, modifiedFieldNames, details, eOpts ){
                    UniAppManager.setToolbarButtons('save', true);
                },
                datachanged : function(store,  eOpts) {
                    if( directMasterStore2.isDirty() || store.isDirty()) {
                        UniAppManager.setToolbarButtons('save', true);
                    }else {
                        UniAppManager.setToolbarButtons('save', false);
                    }
                }
            }
    });

    var panelSearch = Unilite.createSearchPanel('s_pbs071ukrv_kdpanelSearch', {
        collapsed: UserInfo.appOption.collapseLeftSearch,
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
            itemId: 'search_panel1',
            layout: {type: 'uniTable', columns: 1},
            defaultType: 'uniTextfield',
            items: [{
                        fieldLabel: '사업장',
                        name:'DIV_CODE',
                        xtype: 'uniCombobox',
                        comboType:'BOR120' ,
                        allowBlank:false,
                        holdable: 'hold',
                        value: UserInfo.divCode,
                        listeners: {
                            change: function(field, newValue, oldValue, eOpts) {
                                panelResult.setValue('DIV_CODE', newValue);
                            }
                        }
                    },{
                        fieldLabel: '작업장',
                        name: 'WORK_SHOP_CODE',
                        xtype: 'uniCombobox',
                        store: Ext.data.StoreManager.lookup('wsList'),
                        hidden: isProgWorkCode,
                        allowBlank: isProgWorkCode,
                        listeners: {
                            change: function(field, newValue, oldValue, eOpts) {
                                panelResult.setValue('WORK_SHOP_CODE', newValue);
                            }
                        }
                    },Unilite.popup('DIV_PUMOK',{
                            fieldLabel: '품목코드',
                            valueFieldName: 'ITEM_FR_CODE',
                            textFieldName: 'ITEM_FR_NAME',
                            listeners: {
                                onSelected: {
                                    fn: function(records, type) {
                                        console.log('records : ', records);
                                        panelResult.setValue('ITEM_FR_CODE', panelSearch.getValue('ITEM_FR_CODE'));
                                        panelResult.setValue('ITEM_FR_NAME', panelSearch.getValue('ITEM_FR_NAME'));
                                    },
                                    scope: this
                                },
                                onClear: function(type) {
                                    panelResult.setValue('ITEM_FR_CODE', '');
                                    panelResult.setValue('ITEM_FR_NAME', '');
                                },
                                applyextparam: function(popup){
                                    popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
                                }
                            }
                    }),Unilite.popup('DIV_PUMOK',{
                            fieldLabel: '~',
                            valueFieldName: 'ITEM_TO_CODE',
                            textFieldName: 'ITEM_TO_NAME',
                            listeners: {
                                onSelected: {
                                    fn: function(records, type) {
                                        console.log('records : ', records);
                                        panelResult.setValue('ITEM_TO_CODE', panelSearch.getValue('ITEM_TO_CODE'));
                                        panelResult.setValue('ITEM_TO_NAME', panelSearch.getValue('ITEM_TO_NAME'));
                                    },
                                    scope: this
                                },
                                onClear: function(type) {
                                    panelResult.setValue('ITEM_TO_CODE', '');
                                    panelResult.setValue('ITEM_TO_NAME', '');
                                },
                                applyextparam: function(popup){
                                    popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
                                }
                            }
                    }),{
                        fieldLabel: '조달구분',
                        name:'SUPPLY_TYPE',
                        xtype: 'uniCombobox',
                        comboCode:'B014',
                        comboType:'AU',
                        listeners: {
                            change: function(field, newValue, oldValue, eOpts) {
                                panelResult.setValue('SUPPLY_TYPE', newValue);
                            }
                        }
                    },{
                        fieldLabel: '계정구분',
                        name:'ITEM_ACCOUNT',
                        xtype: 'uniCombobox',
                        comboCode:'B020',
                        comboType:'AU',
                        listeners: {
                            change: function(field, newValue, oldValue, eOpts) {
                                panelResult.setValue('ITEM_ACCOUNT', newValue);
                            }
                        }
                    },{
                        fieldLabel: '대분류',
                        name: 'ITEM_LEVEL1',
                        xtype: 'uniCombobox',
                        store: Ext.data.StoreManager.lookup('itemLeve1Store'),
                        child: 'ITEM_LEVEL2',
                        listeners: {
                            change: function(field, newValue, oldValue, eOpts) {
                                panelResult.setValue('ITEM_LEVEL1', newValue);
                            }
                        }
                    },{
                        fieldLabel: '중분류',
                        name: 'ITEM_LEVEL2',
                        xtype: 'uniCombobox',
                        store: Ext.data.StoreManager.lookup('itemLeve2Store'),
                        child: 'ITEM_LEVEL3',
                        listeners: {
                            change: function(field, newValue, oldValue, eOpts) {
                                panelResult.setValue('ITEM_LEVEL2', newValue);
                            }
                        }
                    },{
                        fieldLabel: '소분류',
                        name: 'ITEM_LEVEL3',
                        xtype: 'uniCombobox',
                        store: Ext.data.StoreManager.lookup('itemLeve3Store'),
                        parentNames:['ITEM_LEVEL1','ITEM_LEVEL2'],
                        levelType:'ITEM',
                        listeners: {
                            change: function(field, newValue, oldValue, eOpts) {
                                panelResult.setValue('ITEM_LEVEL3', newValue);
                            }
                        }
                    },{
                        xtype: 'radiogroup',
                        fieldLabel: '등록여부',
                        items : [{
                            boxLabel: '전체',
                            width: 60,
                            name: 'ACC_STATUS',
                            inputValue: '0',
                            checked: true
                        },{
                            boxLabel: '등록',
                            width: 60,
                            name: 'ACC_STATUS',
                            inputValue: '1'
                        },{
                            boxLabel: '미등록',
                            width: 60,
                            name: 'ACC_STATUS',
                            inputValue: '2'
                        }],
                        listeners: {
                            change: function(field, newValue, oldValue, eOpts) {
                                panelResult.getField('ACC_STATUS').setValue(newValue.ACC_STATUS);
                            }
                        }
                    }
                ]
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
                        var labelText = invalid.items[0]['fieldLabel']+'은(는)';
                    } else if(Ext.isDefined(invalid.items[0].ownerCt)) {
                        var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
                    }
                    alert(labelText+Msg.sMB083);
                    invalid.items[0].focus();
                } else {
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

    var panelResult = Unilite.createSearchForm('resultForm',{
        hidden: !UserInfo.appOption.collapseLeftSearch,
        region: 'north',
        layout : {type : 'uniTable', columns : 4},
        padding:'1 1 1 1',
        border:true,
        items: [{
                    fieldLabel: '사업장',
                    name:'DIV_CODE',
                    xtype: 'uniCombobox',
                    comboType:'BOR120' ,
                    allowBlank:false,
                    holdable: 'hold',
                    value: UserInfo.divCode,
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {
                            panelSearch.setValue('DIV_CODE', newValue);
                        }
                    }
                },
                Unilite.popup('DIV_PUMOK',{
                        fieldLabel: '품목코드',
                        valueFieldName: 'ITEM_FR_CODE',
                        textFieldName: 'ITEM_FR_NAME',
                        listeners: {
                            onSelected: {
                                fn: function(records, type) {
                                    console.log('records : ', records);
                                    panelSearch.setValue('ITEM_FR_CODE', panelResult.getValue('ITEM_FR_CODE'));
                                    panelSearch.setValue('ITEM_FR_NAME', panelResult.getValue('ITEM_FR_NAME'));
                                },
                                scope: this
                            },
                            onClear: function(type) {
                                panelSearch.setValue('ITEM_FR_CODE', '');
                                panelSearch.setValue('ITEM_FR_NAME', '');
                            },
                            applyextparam: function(popup){
                                popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
                            }
                        }
                }),{
                    fieldLabel: '대분류',
                    name: 'ITEM_LEVEL1',
                    xtype: 'uniCombobox',
                    store: Ext.data.StoreManager.lookup('itemLeve1Store'),
                    child: 'ITEM_LEVEL2',
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {
                            panelSearch.setValue('ITEM_LEVEL1', newValue);
                        }
                    }
                },{
                    xtype: 'component'
                },{
                    fieldLabel: '작업장',
                    name: 'WORK_SHOP_CODE',
                    xtype: 'uniCombobox',
                    store: Ext.data.StoreManager.lookup('wsList'),
                    hidden: isProgWorkCode,
                    allowBlank: isProgWorkCode,
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {
                            panelSearch.setValue('WORK_SHOP_CODE', newValue);
                        }
                    }
                },{
                    xtype: 'component',
                    hidden: !isProgWorkCode
                },
                Unilite.popup('DIV_PUMOK',{
                        fieldLabel: '~',
                        valueFieldName: 'ITEM_TO_CODE',
                        textFieldName: 'ITEM_TO_NAME',
                        listeners: {
                            onSelected: {
                                fn: function(records, type) {
                                    console.log('records : ', records);
                                    panelSearch.setValue('ITEM_TO_CODE', panelResult.getValue('ITEM_TO_CODE'));
                                    panelSearch.setValue('ITEM_TO_NAME', panelResult.getValue('ITEM_TO_NAME'));
                                },
                                scope: this
                            },
                            onClear: function(type) {
                                panelSearch.setValue('ITEM_TO_CODE', '');
                                panelSearch.setValue('ITEM_TO_NAME', '');
                            },
                            applyextparam: function(popup){
                                popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
                            }
                        }
                }),{
                    fieldLabel: '중분류',
                    name: 'ITEM_LEVEL2',
                    xtype: 'uniCombobox',
                    store: Ext.data.StoreManager.lookup('itemLeve2Store'),
                    child: 'ITEM_LEVEL3',
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {
                            panelSearch.setValue('ITEM_LEVEL2', newValue);
                        }
                    }
                },{
                    xtype: 'component'
                },{
                    fieldLabel: '조달구분',
                    name:'SUPPLY_TYPE',
                    xtype: 'uniCombobox',
                    comboCode:'B014',
                    comboType:'AU',
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {
                            panelSearch.setValue('SUPPLY_TYPE', newValue);
                        }
                    }
                },{
                    fieldLabel: '계정구분',
                    name:'ITEM_ACCOUNT',
                    xtype: 'uniCombobox',
                    comboCode:'B020',
                    comboType:'AU',
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {
                            panelSearch.setValue('ITEM_ACCOUNT', newValue);
                        }
                    }
                },{
                    fieldLabel: '소분류',
                    name: 'ITEM_LEVEL3',
                    xtype: 'uniCombobox',
                    store: Ext.data.StoreManager.lookup('itemLeve3Store'),
                    parentNames:['ITEM_LEVEL1','ITEM_LEVEL2'],
                    levelType:'ITEM',
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {
                            panelSearch.setValue('ITEM_LEVEL3', newValue);
                        }
                    }
                },{
                    xtype: 'radiogroup',
                    fieldLabel: '등록여부',
    //                  colspan:2,
                    items : [{
                        boxLabel: '전체',
                        width: 60,
                        name: 'ACC_STATUS',
                        inputValue: '0',
                        checked: true
                    },{
                        boxLabel: '등록',
                        width: 60,
                        name: 'ACC_STATUS',
                        inputValue: '1'
                    },{
                        boxLabel: '미등록',
                        width: 60,
                        name: 'ACC_STATUS',
                        inputValue: '2'
                    }],
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {
                            panelSearch.getField('ACC_STATUS').setValue(newValue.ACC_STATUS);
                        }
                    }
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

    /**
     * Master Grid1 정의(Grid Panel)
     * @type
     */
    var masterGrid = Unilite.createGrid('s_pbs071ukrv_kdGrid', {
        layout : 'fit',
        region:'center',
        store : directMasterStore,
        uniOpt:{    expandLastColumn: false,
                    useRowNumberer: true,
                    useMultipleSorting: true,
                    onLoadSelectFirst: true
        },
        features: [
            {id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
            {id: 'masterGridTotal',    ftype: 'uniSummary',         showSummaryRow: false}
        ],
        columns: [
            {dataIndex: 'COMP_CODE'             ,       width: 80, hidden: true},
            {dataIndex: 'ITEM_CODE'             ,       width: 100},
            {dataIndex: 'ITEM_NAME'             ,       width: 250},
            {dataIndex: 'SPEC'                  ,       width: 133},
            {dataIndex: 'STOCK_UNIT'            ,       width: 53, align:'center'},
            {dataIndex: 'ITEM_ACCOUNT'          ,       width: 66, hidden: true},
            {dataIndex: 'ITEMACCOUNT_NAME'      ,       width: 80},
            {dataIndex: 'SUPPLY_TYPE'           ,       width: 80},
            {dataIndex: 'PROG_CNT'              ,       width: 65},
            {dataIndex: 'ITEMLEVEL1_NAME'       ,       width: 150},
            {dataIndex: 'ITEMLEVEL2_NAME'       ,       width: 150},
            {dataIndex: 'ITEMLEVEL3_NAME'       ,       width: 150}
        ],
        listeners :{
            select: function() {
                UniAppManager.setToolbarButtons(['newData', 'delete'], false);
            },
            cellclick: function() {
                UniAppManager.setToolbarButtons(['newData', 'delete'], false);
            },
            render: function(grid, eOpts) {
            	masterGrid3.getView().refresh(true);
            	var girdNm = grid.getItemId();
                grid.getEl().on('click', function(e, t, eOpt) {
                    Ext.getCmp('COPY_BTN').setDisabled(true);
                	if(directMasterStore2.isDirty() || directMasterStore3.isDirty() || directMasterStore4.isDirty() || directMasterStore5.isDirty() ){
                        grid.suspendEvents();
                        alert(Msg.sMB154);//먼저 저장하십시오
                        return false;
                	}else{
                		UniAppManager.setToolbarButtons(['newData', 'delete'], false);
                        var oldGrid = Ext.getCmp(selectedGrid);
    			    	grid.changeFocusCls(oldGrid);
    			    	selectedGrid = girdNm;
                	}
                });
            },
            selectionchange:function( model1, selected, eOpts ){
                if(selected.length > 0) {
                    var record = selected[0];
                    var param= panelSearch.getValues();
                    param.ITEM_CODE = record.get('ITEM_CODE');
                    param.GS_WORK_SHOP_CODE = BsaCodeInfo.gsProgWorkCode;
                    directMasterStore2.loadStoreRecords(param);

                }
            },
            beforeedit  : function( editor, e, eOpts ) {
                if(!e.record.phantom) {
                    if(UniUtils.indexOf(e.field, ['COMP_CODE', 'ITEM_CODE', 'ITEM_NAME', 'SPEC', 'STOCK_UNIT', 'ITEM_ACCOUNT', 'ITEMACCOUNT_NAME',
                                                    'SUPPLY_TYPE', 'PROG_CNT', 'ITEMLEVEL1_NAME', 'ITEMLEVEL2_NAME', 'ITEMLEVEL3_NAME']))
                    {
                        return false;
                    }
                } else {
                    if(UniUtils.indexOf(e.field, ['COMP_CODE', 'ITEM_CODE', 'ITEM_NAME', 'SPEC', 'STOCK_UNIT', 'ITEM_ACCOUNT', 'ITEMACCOUNT_NAME',
                                                    'SUPPLY_TYPE', 'PROG_CNT', 'ITEMLEVEL1_NAME', 'ITEMLEVEL2_NAME', 'ITEMLEVEL3_NAME']))
                    {
                        return false;
                    }
                }
            }
        }
    });

    Unilite.defineModel('copyProgWorkShopCodeModel', {
        fields: [
        	 {name: 'PROG_WORK_CODE'     ,text:'공정코드'       ,type:'string'  }
            ,{name: 'PROG_WORK_NAME'     ,text:'공정명'         ,type:'string'  }
            ,{name: 'PROG_UNIT'          ,text:'공정단위'       ,type:'string'  }
            ,{name: 'REF_ITEM_CODE'      ,text:'참조품목코드'   ,type:'string'  }
        ]
    });

    var copyStore = Unilite.createStore('copyProgWorkShopCodeStore', {//이동출고 참조
            model: 'copyProgWorkShopCodeModel',
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
                    read: 's_pbs071ukrv_kdService.selectCopyProgWorkShopCode'
                }
            },
            loadStoreRecords : function()   {
                var param= copySearch.getValues();
                param.GS_WORK_SHOP_CODE = BsaCodeInfo.gsProgWorkCode;
                var record = masterGrid.getSelectedRecord();
                param.ITEM_CODE_TEMP         = record.data.ITEM_CODE;
                console.log( param );
                this.load({
                    params : param
                });
            }
    });

    var copySearch = Unilite.createSearchForm('copyForm', {
        layout: {type : 'uniTable', columns : 2},
        items:[
            {
                fieldLabel: '사업장',
                name:'DIV_CODE',
                xtype: 'uniCombobox',
                comboType:'BOR120',
                allowBlank:false,
                value: panelResult.getValue('DIV_CODE')
           },
            Unilite.popup('DIV_PUMOK',{
                    fieldLabel: '품목코드',
                    valueFieldName: 'ITEM_CODE',
                    textFieldName: 'ITEM_NAME',
                    allowBlank:false,
                    listeners: {
                        applyextparam: function(popup){
                            popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
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
            }
    });

    var copyGrid = Unilite.createGrid('copyProgWorkShopCodeGrid', {
        // title: '기본',
        layout : 'fit',
        store: copyStore,
        selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }),
        uniOpt:{
            onLoadSelectFirst : false
        },
        columns: [
             { dataIndex: 'PROG_WORK_CODE'          ,width: 100 }
            ,{ dataIndex: 'PROG_WORK_NAME'          ,width: 400 }
            ,{ dataIndex: 'PROG_UNIT'               ,minWidth: 100, flex: 1 }
            ,{ dataIndex: 'REF_ITEM_CODE'           ,width: 100, hidden: true}
        ],
        listeners: {
            onGridDblClick:function(grid, record, cellIndex, colName) {}
        },
        returnData: function()  {
            var records = this.getSelectedRecords();

            Ext.each(records, function(record,i) {
                UniAppManager.app.onNewDataButtonDown();
                masterGrid2.setCopyData(record.data);
            });
            this.getStore().remove(records);
        }
    });

    function openCopyProgWorkShopCode() {
        copySearch.setValue('DIV_CODE', panelResult.getValue('DIV_CODE'));
        var record = masterGrid.getSelectedRecord();
        copySearch.setValue('ITEM_CODE', record.data.ITEM_CODE);
        copySearch.setValue('ITEM_NAME', record.data.ITEM_NAME);
        copyStore.loadStoreRecords();

        if(!copyProgWorkShopCode) {
            copyProgWorkShopCode = Ext.create('widget.uniDetailWindow', {
                title: '공정복사',
                width: 1080,
                height: 580,
                layout:{type:'vbox', align:'stretch'},

                items: [copySearch, copyGrid],
                tbar:  ['->',
                    {   itemId : 'saveBtn',
                        text: '조회',
                        handler: function() {
                        	if(copySearch.setAllFieldsReadOnly(true) == false){
                                return false;
                            } else {
                                copyStore.loadStoreRecords();
                            }
                        },
                        disabled: false
                    },{ itemId : 'confirmBtn',
                        text: '적용',
                        handler: function() {
                            copyGrid.returnData();
                        },
                        disabled: false
                    },{ itemId : 'confirmCloseBtn',
                        text: '적용 후 닫기',
                        handler: function() {
                            copyGrid.returnData();
                            copyProgWorkShopCode.hide();
                            UniAppManager.setToolbarButtons('reset', true)
                        },
                        disabled: false
                    },{
                        itemId : 'closeBtn',
                        text: '닫기',
                        handler: function() {
                            copyProgWorkShopCode.hide();
                            UniAppManager.setToolbarButtons('reset', true)
                        },
                        disabled: false
                    }
                ],
                listeners : {beforehide: function(me, eOpt)
                    {
                        copySearch.clearForm();
                        copyGrid.reset();
                    },
                    beforeclose: function(panel, eOpts)
                    {
                        copySearch.clearForm();
                        copyGrid.reset();
                    },
                    beforeshow: function (me, eOpts)
                    {
                        copySearch.setValue('DIV_CODE',panelResult.getValue('DIV_CODE'));
                        var record = masterGrid.getSelectedRecord();
                        copySearch.setValue('ITEM_CODE', record.data.ITEM_CODE);
                        copySearch.setValue('ITEM_NAME', record.data.ITEM_NAME);
                        copyStore.loadStoreRecords();
                    }
                }
            })
        }
        copyProgWorkShopCode.show();
        copyProgWorkShopCode.center();
    }

    //공정수순
    var masterGrid2 = Unilite.createGrid('s_pbs071ukrv_kdGrid2', {
        layout : 'fit',
        region:'center',
//        title : '공정수순등록',
        store : directMasterStore2,
        uniOpt:{    expandLastColumn: false,
                    useRowNumberer: true,
                    useMultipleSorting: false,
                    onLoadSelectFirst: true
        },
        features: [
            {id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true},
            {id: 'masterGridTotal',    ftype: 'uniSummary',         showSummaryRow: true}
        ],
        tbar:[
            {
                xtype: 'button',
                text:'공정복사',
                id:'COPY_BTN_PROG',
                app: 'Unilite.app.popup.BomCopyPopup',
                handler:function()  {
                    openCopyProgWorkShopCode();
                }
            }
        ],
        selModel:'rowmodel',
        columns: [
//         {dataIndex: 'FLAG'                  ,       width: 33, hidden: true},
            {dataIndex: 'COMP_CODE'             ,       width: 33, hidden: true},
            {dataIndex: 'SORT_FLD'              ,       width: 33, hidden: true},
            {dataIndex: 'DIV_CODE'              ,       width: 33, hidden: true},
            {dataIndex: 'ITEM_CODE'             ,       width: 66, hidden: true},
            {dataIndex: 'ITEM_NAME'             ,       width: 66, hidden: true},
            {dataIndex: 'SPEC'             ,       width: 66, hidden: true},
            {dataIndex: 'WORK_SHOP_CODE'        ,       width: 33, hidden: true},
            {dataIndex:'PROG_WORK_CODE'     , width: 120 ,locked: false,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                    return Unilite.renderSummaryRow(summaryData, metaData, '소계', '합계');
                },
                editor: Unilite.popup('PROG_WORK_CODE_G', {
                        textFieldName: 'PROG_WORK_NAME',
                        DBtextFieldName: 'PROG_WORK_NAME',
                        //extParam: {SELMODEL: 'MULTI'},
			    		autoPopup: true,
                        listeners: {'onSelected': {
                            fn: function(records, type) {
                                Ext.each(records, function(record,i) {
                                    if(i==0) {
                                        masterGrid2.setItemData(record,false, masterGrid2.uniOpt.currentRecord);
                                    }else{
                                        UniAppManager.app.onNewDataButtonDown();
                                        masterGrid2.setItemData(record,false, masterGrid2.getSelectedRecord());
                                    }
                                });
                            },
                            scope: this
                            },
                            'onClear': function(type) {
                                masterGrid2.setItemData(null,true, masterGrid2.uniOpt.currentRecord);
                            },
                            applyextparam: function(popup){
                            	var record = masterGrid2.getSelectedRecord();
                                popup.setExtParam({'DIV_CODE'       : record.get('DIV_CODE')});
                                popup.setExtParam({'WORK_SHOP_CODE' : record.get('WORK_SHOP_CODE')});
                                popup.setExtParam({'SELMODEL' : 'MULTI'});
                            }
                    }
                })
            },
            {dataIndex: 'PROG_WORK_NAME'    , width: 206,
                editor: Unilite.popup('PROG_WORK_CODE_G', {
                            textFieldName: 'PROG_WORK_NAME',
                            DBtextFieldName: 'PROG_WORK_NAME',
                            //extParam: {SELMODEL: 'MULTI'},
			    			autoPopup: true,
                            listeners: {'onSelected': {
                                fn: function(records, type) {
                                    Ext.each(records, function(record,i) {
                                        if(i==0) {
                                            masterGrid2.setItemData(record,false, masterGrid2.uniOpt.currentRecord);
                                        }else{
                                            UniAppManager.app.onNewDataButtonDown();
                                            masterGrid2.setItemData(record,false, masterGrid2.getSelectedRecord());
                                        }
                                    });
                                },
                                scope: this
                            },
                            'onClear': function(type) {
                                var grdRecord = masterGrid2.getSelectedRecord();
                                masterGrid2.setItemData(null,true, masterGrid2.uniOpt.currentRecord);
                            },
                            applyextparam: function(popup){
                                var record = masterGrid2.getSelectedRecord();
                                popup.setExtParam({'DIV_CODE'       : record.get('DIV_CODE')});
                                popup.setExtParam({'WORK_SHOP_CODE' : record.get('WORK_SHOP_CODE')});
                                popup.setExtParam({'SELMODEL' : 'MULTI'});
                            }
                        }
                })
            },
            {dataIndex: 'LINE_SEQ'              ,       width: 80},
            {dataIndex: 'MAKE_LDTIME'           ,       width: 133, summaryType:'sum' },
            {dataIndex: 'PROG_RATE'             ,       width: 120, summaryType:'sum' },
            {dataIndex: 'PROG_UNIT_Q'           ,       width: 120},
            {dataIndex: 'PROG_UNIT'             ,       width: 100},
            {dataIndex: 'REMARK'             ,       width: 100},
            { dataIndex: 'REF_ITEM_CODE'        ,width: 100, hidden: true}
        ],
        setItemData: function(record, dataClear, grdRecord) {
            if(dataClear) {
                grdRecord.set('PROG_WORK_CODE'          , '');
                grdRecord.set('PROG_WORK_NAME'          , '');
                grdRecord.set('PROG_UNIT'               ,  panelSearch.getValue('PROG_UNIT'));
            }else{
                grdRecord.set('PROG_WORK_CODE'          , record['PROG_WORK_CODE']);
                grdRecord.set('PROG_WORK_NAME'          , record['PROG_WORK_NAME']);
                grdRecord.set('PROG_UNIT'               , record['PROG_UNIT']);
            }
        },
        listeners :{
            select: function() {
                var count = masterGrid.getStore().getCount();
                if(count > 0) {
                    UniAppManager.setToolbarButtons(['delete', 'newData'], true);
                }
            },
            cellclick: function() {
                var count = masterGrid.getStore().getCount();
                if(count > 0) {
                    UniAppManager.setToolbarButtons(['delete', 'newData'], true);
                }
                var record = masterGrid2.getSelectedRecord();
                if(record.get('LINE_SEQ') == 0) {
                    Ext.getCmp('COPY_BTN').setDisabled(true);
                } else {
                    Ext.getCmp('COPY_BTN').setDisabled(false);
                }
            },
            render: function(grid, eOpts) {
                var girdNm = grid.getItemId();
                grid.getEl().on('click', function(e, t, eOpt) {
                   Ext.getCmp('COPY_BTN').setDisabled(true);
                	if(directMasterStore.isDirty() || directMasterStore3.isDirty() || directMasterStore4.isDirty() || directMasterStore5.isDirty() ){
                        grid.suspendEvents();
                        alert(Msg.sMB154);//먼저 저장하십시오
                        return false;
                	}else{
	                    UniAppManager.setToolbarButtons(['delete', 'newData'], true);
	                    var oldGrid = Ext.getCmp(selectedGrid);
				    	grid.changeFocusCls(oldGrid);
				    	selectedGrid = girdNm;
	                    if(directMasterStore2.isDirty() || directMasterStore3.isDirty() || directMasterStore4.isDirty() || directMasterStore5.isDirty()) {
	                        UniAppManager.setToolbarButtons('save', true);
	                    } else {
	                        UniAppManager.setToolbarButtons('save', false);
	                    }
                	}
                });
            },
//            beforedeselect : function ( gird, record, index, eOpts ){
//                var detailStore = Ext.getCmp('s_pbs071ukrv_kdGrid2').getStore();
//                if(directMasterStore2.isDirty())   {
//                    if(confirm(Msg.sMB017 + "\n" + Msg.sMB061)) {
//                        var inValidRecs = directMasterStore2.getInvalidRecords();
//                        if(inValidRecs.length > 0 ) {
//                            alert(Msg.sMB083);
//                            return false;
//                        } else {
//                            directMasterStore2.saveStore();
//                        }
//                    }
//                }
//            },
            selectionchange:function( model1, selected, eOpts ){
                if(selected.length > 0) {
                    var activeTabId = tab.getActiveTab().getId();
                    var selRow = masterGrid2.getSelectedRecord();
                    var record = selected[0];
                    var param= panelSearch.getValues();
                    param.DIV_CODE          = record.get('DIV_CODE');
                    param.ITEM_CODE         = record.get('ITEM_CODE');
                    param.WORK_SHOP_CODE    = record.get('WORK_SHOP_CODE');
                    param.PROG_WORK_CODE    = record.get('PROG_WORK_CODE');
                    param.GS_WORK_SHOP_CODE = BsaCodeInfo.gsProgWorkCode;
                    if(activeTabId == 'tab3') {
                        if(selRow.phantom == false) {
                            directMasterStore3.loadStoreRecords(param);
                        }
                    } else if(activeTabId == 'tab4') {
                        if(selRow.phantom == false) {
                            directMasterStore4.loadStoreRecords(param);
                        }
                    } else {
                        if(selRow.phantom == false) {
                            directMasterStore5.loadStoreRecords(param);
                        }
                    }
                    var count = masterGrid3.getStore().getCount();
                    if(count == 0) {
                        if(masterGrid2.getStore().getCount() > 0) {
                            UniAppManager.setToolbarButtons(['delete', 'newData'], true);
                        }
                    } else {
                        UniAppManager.setToolbarButtons(['delete', 'newData'], false);
                    }

                    var record = masterGrid2.getSelectedRecord();
                    if(record.get('LINE_SEQ') == 0) {
                        Ext.getCmp('COPY_BTN').setDisabled(true);
                    } else {
                        Ext.getCmp('COPY_BTN').setDisabled(false);
                    }
                }
            },
            beforeedit  : function( editor, e, eOpts ) {
                if(!e.record.phantom) {
                    if(UniUtils.indexOf(e.field, ['LINE_SEQ', 'MAKE_LDTIME', 'PROG_RATE', 'PROG_UNIT_Q', 'REMARK']))
                    {
                        return true;
                    } else {
                        return false
                    }
                } else {
                    if(UniUtils.indexOf(e.field, ['LINE_SEQ', 'PROG_WORK_CODE', 'PROG_WORK_NAME', 'MAKE_LDTIME', 'PROG_RATE', 'PROG_UNIT_Q', 'REMARK']))
                    {
                        return true;
                    }  else {
                        return false
                    }
                }
            }
        },
        setCopyData: function(record) {
            var grdRecord = this.getSelectedRecord();
            grdRecord.set('COMP_CODE'          , UserInfo.compCode);
            grdRecord.set('PROG_WORK_CODE'     , record['PROG_WORK_CODE']);
            grdRecord.set('PROG_WORK_NAME'     , record['PROG_WORK_NAME']);
            grdRecord.set('PROG_UNIT'          , record['PROG_UNIT']);
            grdRecord.set('REF_ITEM_CODE'      , record['REF_ITEM_CODE']);
        }
    });

    //공정품목
    var masterGrid3 = Unilite.createGrid('s_pbs071ukrv_kdGrid3', {
        layout : 'fit',
        region:'center',
//        title : '공정/품목',
        store : directMasterStore3,
        uniOpt:{
            expandLastColumn: false,
            useRowNumberer: true,
            useMultipleSorting: false
        },
        tbar:[
        	{
                xtype: 'button',
                text:'품목복사',
                id:'COPY_BTN',
                app: 'Unilite.app.popup.BomCopyPopup',
                handler:function()  {
                    var record = masterGrid2.getSelectedRecord();
                    if(record.get('LINE_SEQ') != 0)  {
                        if (masterGrid2.getSelectedRecord()){
                            this.openPopup();
                        }else {
                            alert('모품목코드를 선택하세요.');
                        }
                    } else {
                        alert('공정순서가 0입니다. 공정순서를 입력해주세요.');
                    }
                },
                listeners:{
                    onSelected: {
                        fn: function(records, type) {
                            var grd1Record = masterGrid2.getSelectedRecord();
                            Ext.each(records, function(record,i) {
                                var r={
                                    'COMP_CODE'         : record.COMP_CODE,
                                    'DIV_CODE'          : record.DIV_CODE,
                                    'ITEM_CODE'         : grd1Record.get('ITEM_CODE'),
                                    'WORK_SHOP_CODE'    : grd1Record.get('WORK_SHOP_CODE'),
                                    'PROG_WORK_CODE'    : grd1Record.get('PROG_WORK_CODE'),
                                    'UNIT_Q'            : record.UNIT_Q,
                                    'PROD_UNIT_Q'       : record.PROD_UNIT_Q,
                                    'CHILD_ITEM_CODE'   : record.CHILD_ITEM_CODE,
                                    'CHILD_ITEM_NAME'   : record.ITEM_NAME,
                                    'SPEC'              : record.SPEC,
                                    'STOCK_UNIT'        : record.STOCK_UNIT,
                                    'REMARK'            : record.REMARK
                                }
                                masterGrid3.createRow(r);
                            });
                        },
                    scope: this
                    }
                },
                openPopup: function() {
                    var me = this;
                    var prodRecord = masterGrid2.getSelectedRecord();
                    var param = {
                            'TYPE':'TEXT',
                            'pageTitle':'BOM 참조',
                            'DIV_CODE':prodRecord.get('DIV_CODE'),
                            'PROD_ITEM_CODE':prodRecord.get('ITEM_CODE'),
                            'ITEM_NAME':prodRecord.get('ITEM_NAME'),
                            'SPEC':prodRecord.get('SPEC')
                            ,'SEL_MODEL':'MULTI'
                    };
                    if(me.app) {
                         var fn = function() {
                            var oWin =  Ext.WindowMgr.get(me.app);
                            if(!oWin) {
                                oWin = Ext.create( me.app, {
                                        title:'BOM 참조',
                                        id: me.app,
                                        callBackFn: me.processResult,
                                        callBackScope: me,
                                        popupType: 'TEXT',
                                        width: 875,
                                        height:450,
                                        param: param
                                 });
                            }
                            oWin.fnInitBinding(param);
                            oWin.center();
                            oWin.show();
                         }
                         Unilite.require(me.app, fn, this, true);
                     }
                },
                processResult: function(result, type) {
                    var me = this, rv;
                    console.log("Result: ", result);
                    if(result && Ext.isDefined(result) && result.status == 'OK') {
                        me.fireEvent('onSelected',  result.data, type);
                    }
                }
            }
        ],
        features: [
            {id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
            {id: 'masterGridTotal',    ftype: 'uniSummary',         showSummaryRow: false}
        ],
        columns: [
            {dataIndex: 'COMP_CODE'                ,       width: 100, hidden: true},
            {dataIndex: 'DIV_CODE'                 ,       width: 100, hidden: true},
            {dataIndex: 'ITEM_CODE'                ,       width: 100, hidden: true},
            {dataIndex: 'WORK_SHOP_CODE'           ,       width: 100, hidden: true},
            {dataIndex: 'PROG_WORK_CODE'           ,       width: 100, hidden: true},
            {dataIndex: 'CHILD_ITEM_CODE'          ,       width: 110},
            {dataIndex: 'CHILD_ITEM_NAME'          ,       width: 200},
            {dataIndex: 'SPEC'                     ,       width: 200},
            {dataIndex: 'STOCK_UNIT'               ,       width: 100},
            {dataIndex: 'UNIT_Q'                   ,       width: 80},
            {dataIndex: 'PROD_UNIT_Q'              ,       width: 80},
            {dataIndex: 'REMARK'                   ,       width: 100}
        ],
        listeners :{
            select: function() {
                var count = masterGrid3.getStore().getCount();
                if(count > 0) {
                    UniAppManager.setToolbarButtons(['delete'], true);
                } else {
                    UniAppManager.setToolbarButtons(['delete'], false);
                }
                UniAppManager.setToolbarButtons(['newData'], false);
            },
            cellclick: function() {
                var count = masterGrid3.getStore().getCount();
                if(count > 0) {
                    UniAppManager.setToolbarButtons(['delete'], true);
                    var record = masterGrid2.getSelectedRecord();
                    if(record.get('LINE_SEQ') == 0) {
                        Ext.getCmp('COPY_BTN').setDisabled(true);
                    } else {
                        Ext.getCmp('COPY_BTN').setDisabled(false);
                    }
                } else {
//                    UniAppManager.setToolbarButtons(['delete'], false);
                }
                UniAppManager.setToolbarButtons(['newData'], false);
            },
            render: function(grid, eOpts) {
                var girdNm = grid.getItemId();
                grid.getEl().on('click', function(e, t, eOpt) {
                	Ext.getCmp('COPY_BTN').setDisabled(false);
                	if(directMasterStore.isDirty() || directMasterStore2.isDirty() || directMasterStore4.isDirty() || directMasterStore5.isDirty() ){
                        grid.suspendEvents();
                        alert(Msg.sMB154);//먼저 저장하십시오
                        return false;
                	}else{
	                    var oldGrid = Ext.getCmp(selectedGrid);
				    	grid.changeFocusCls(oldGrid);
				    	selectedGrid = girdNm;
	                    var count = masterGrid3.getStore().getCount();
	                    if(count > 0) {
	                        UniAppManager.setToolbarButtons(['delete'], true);
	                        var record = masterGrid2.getSelectedRecord();
	                        if(record.get('LINE_SEQ') == 0) {
	                            Ext.getCmp('COPY_BTN').setDisabled(true);
	                        } else {
	                            Ext.getCmp('COPY_BTN').setDisabled(false);
	                        }
	                    } else {
	                    	UniAppManager.setToolbarButtons(['delete'], false);
	                    }
	                    UniAppManager.setToolbarButtons(['newData'], false);

	                    if( directMasterStore2.isDirty() || directMasterStore3.isDirty())    {
	                        UniAppManager.setToolbarButtons('save', true);
	                    }else {
	                        UniAppManager.setToolbarButtons('save', false);
	                    }
                	}
                });
            },
            beforeedit  : function( editor, e, eOpts ) {
                if(UniUtils.indexOf(e.field, ['UNIT_Q', 'PROD_UNIT_Q']))
                {
                    return true;
                } else {
                    return false
                }
            }
        }
    });

    //공정설비
    var masterGrid4 = Unilite.createGrid('s_pbs071ukrv_kdGrid4', {
        layout : 'fit',
        region:'center',
//        title : '공정/설비',
        store : directMasterStore4,
        uniOpt:{    expandLastColumn: false,
                    useRowNumberer: true,
                    useMultipleSorting: true
        },
        features: [
            {id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
            {id: 'masterGridTotal',    ftype: 'uniSummary',         showSummaryRow: false}
        ],
        columns: [
            {dataIndex: 'COMP_CODE'                   ,       width: 100, hidden: true},
            {dataIndex: 'DIV_CODE'                    ,       width: 100, hidden: true},
            {dataIndex: 'ITEM_CODE'                   ,       width: 100, hidden: true},
            {dataIndex: 'WORK_SHOP_CODE'              ,       width: 100, hidden: true},
            {dataIndex: 'PROG_WORK_CODE'              ,       width: 100, hidden: true},
            //20191204 정규 장비팝업으로 변경: 사이트 팝업 EQU_CODE_G -> 정규팝업 EQU_CODE_G
            {dataIndex: 'EQUIP_CODE'                  ,       width: 110, hidden: isEquipCode
                ,'editor' : Unilite.popup('EQU_CODE_G',{textFieldName:'EQUIP_CODE', textFieldWidth:100, DBtextFieldName: 'EQUIP_CODE',
                            autoPopup: true,
                            listeners: {'onSelected': {
                                    fn: function(records, type) {
                                        grdRecord = masterGrid4.getSelectedRecord();
                                        record = records[0];
                                        grdRecord.set('EQUIP_CODE', record.EQU_CODE);
                                        grdRecord.set('EQUIP_NAME', record.EQU_NAME);
                                    },
                                    scope: this
                                },
                                'onClear': function(type) {
                                    grdRecord = masterGrid4.getSelectedRecord();
                                    record = records[0];
                                    grdRecord.set('EQUIP_CODE', '');
                                    grdRecord.set('EQUIP_NAME', '');
                                },
                                applyextparam: function(popup){
                                    var param =  panelSearch.getValues();
                                    var record = masterGrid2.getSelectedRecord();
                                    popup.setExtParam({'DIV_CODE': param.DIV_CODE});
                                    //20191204 수정
                                    popup.setExtParam({'EQU_CODE_TYPE': '2'});
//                                    popup.setExtParam({'ITEM_CODE': param.ITEM_CODE});
//                                    popup.setExtParam({'PROG_WORK_CODE': record.get('PROG_WORK_CODE')});
                                }
                            }
                })
            },
            //20191204 정규 장비팝업으로 변경: 사이트 팝업 EQU_CODE_G -> 정규팝업 EQU_CODE_G
            {dataIndex: 'EQUIP_NAME'                  ,       width: 200, hidden: isEquipCode
                ,'editor' : Unilite.popup('EQU_CODE_G',{textFieldName:'EQUIP_NAME', textFieldWidth:100, DBtextFieldName: 'EQUIP_NAME',
                            autoPopup: true,
                            listeners: {'onSelected': {
                                    fn: function(records, type) {
                                        grdRecord = masterGrid4.getSelectedRecord();
                                        record = records[0];
                                        grdRecord.set('EQUIP_CODE', record.EQU_CODE);
                                        grdRecord.set('EQUIP_NAME', record.EQU_NAME);
                                    },
                                    scope: this
                                },
                                'onClear': function(type) {
                                    grdRecord = masterGrid4.getSelectedRecord();
                                    record = records[0];
                                    grdRecord.set('EQUIP_CODE', '');
                                    grdRecord.set('EQUIP_NAME', '');
                                },
                                applyextparam: function(popup){
                                    var param =  panelSearch.getValues();
                                    var record = masterGrid2.getSelectedRecord();
                                    popup.setExtParam({'DIV_CODE': param.DIV_CODE});
                                    //20191204 수정
                                    popup.setExtParam({'EQU_CODE_TYPE': '2'});
//                                    popup.setExtParam({'ITEM_CODE': param.ITEM_CODE});
//                                    popup.setExtParam({'PROG_WORK_CODE': record.get('PROG_WORK_CODE')});
                                }
                            }
                })
            },
            {dataIndex: 'SELECT_BASIS'                ,       width: 100},
            {dataIndex: 'REMARK'                     ,       width: 100}
        ],
        listeners :{
            select: function() {
                var activeTabId = tab.getActiveTab().getId();
                activeTabId == 'tab4';
                var count = masterGrid.getStore().getCount();
                var record = masterGrid.getSelectedRecord();
                if(count > 0) {
                  if(Ext.isEmpty(record.get('WORK_SHOP_CODE'))) {
                        UniAppManager.setToolbarButtons(['newData', 'delete'], false);
                    }
                    UniAppManager.setToolbarButtons(['newData', 'delete'], true);
                } else {
                    UniAppManager.setToolbarButtons(['newData', 'delete'], false);
                }
            },
            cellclick: function() {
                var activeTabId = tab.getActiveTab().getId();
                activeTabId == 'tab4';
                var count = masterGrid.getStore().getCount();
                var record = masterGrid.getSelectedRecord();
                if(count > 0) {
                  if(Ext.isEmpty(record.get('WORK_SHOP_CODE'))) {
                        UniAppManager.setToolbarButtons(['newData', 'delete'], false);
                    }
                    UniAppManager.setToolbarButtons(['newData', 'delete'], true);
                } else {
                    UniAppManager.setToolbarButtons(['newData', 'delete'], false);
                }
            },
            render: function(grid, eOpts) {
                var girdNm = grid.getItemId();
                grid.getEl().on('click', function(e, t, eOpt) {
                	if(directMasterStore.isDirty() || directMasterStore2.isDirty() || directMasterStore3.isDirty() || directMasterStore5.isDirty() ){
                        grid.suspendEvents();
                        alert(Msg.sMB154);//먼저 저장하십시오
                        return false;
                	}else{
	                    var oldGrid = Ext.getCmp(selectedGrid);
				    	grid.changeFocusCls(oldGrid);
				    	selectedGrid = girdNm;
	                    if( directMasterStore2.isDirty() || directMasterStore5.isDirty())    {
	                        UniAppManager.setToolbarButtons('save', true);
	                    }else {
	                        UniAppManager.setToolbarButtons('save', false);
	                    }
                	}
                });

//                if(directMasterStore2.isDirty) {
//                    UniAppManager.setToolbarButtons(['save'], true);
//                }
            },
            beforeedit  : function( editor, e, eOpts ) {
                if(!e.record.phantom) {
                    if(UniUtils.indexOf(e.field, ['WORK_SHOP_CODE', 'WORK_SHOP_NAME', 'PROG_WORK_CODE', 'EQUIP_CODE', 'EQUIP_NAME']))
                    {
                        return false;
                    } else {
                        return true;
                    }
                } else {
                    if(UniUtils.indexOf(e.field))
                    {
                        return true;
                    }
                }
            }
        }
    });

    //공정금형
    var masterGrid5 = Unilite.createGrid('s_pbs071ukrv_kdGrid5', {
        layout : 'fit',
        region:'center',
//        title : '공정/금형',
        store : directMasterStore5,
        uniOpt:{    expandLastColumn: false,
                    useRowNumberer: true,
                    useMultipleSorting: true
        },
        features: [
            {id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
            {id: 'masterGridTotal',    ftype: 'uniSummary',         showSummaryRow: false}
        ],
        columns: [
            {dataIndex: 'COMP_CODE'                   ,       width: 100, hidden: true},
            {dataIndex: 'DIV_CODE'                    ,       width: 100, hidden: true},
            {dataIndex: 'ITEM_CODE'                   ,       width: 100, hidden: true},
            {dataIndex: 'WORK_SHOP_CODE'              ,       width: 100, hidden: true},
            {dataIndex: 'PROG_WORK_CODE'              ,       width: 100, hidden: true},
            {dataIndex: 'MOLD_CODE'                  ,       width: 110, hidden: isMoldCode
                ,'editor' : Unilite.popup('EQU_CODE_G',{textFieldName:'MOLD_CODE', textFieldWidth:100, DBtextFieldName: 'MOLD_CODE',
                            autoPopup: true,
                            listeners: {'onSelected': {
                                    fn: function(records, type) {
                                        grdRecord = masterGrid5.getSelectedRecord();
                                        record = records[0];
                                        grdRecord.set('MOLD_CODE', record.EQU_CODE);
                                        grdRecord.set('MOLD_NAME', record.EQU_NAME);
                                    },
                                    scope: this
                                },
                                'onClear': function(type) {
                                    grdRecord = masterGrid5.getSelectedRecord();
                                   // record = records[0];
                                    grdRecord.set('MOLD_CODE', '');
                                    grdRecord.set('MOLD_NAME', '');
                                },
                                applyextparam: function(popup){
                                    var param =  panelSearch.getValues();
                                    var record = masterGrid2.getSelectedRecord();
                                    popup.setExtParam({'DIV_CODE': param.DIV_CODE});
                                    //20191204 수정
                                    popup.setExtParam({'EQU_CODE_TYPE': '1'});
//                                    popup.setExtParam({'ITEM_CODE': param.ITEM_CODE});
//                                    popup.setExtParam({'PROG_WORK_CODE': record.get('PROG_WORK_CODE')});
                                }
                            }
                })
            },
            {dataIndex: 'MOLD_NAME'                  ,       width: 200, hidden: isMoldCode
                ,'editor' : Unilite.popup('EQU_CODE_G',{textFieldName:'MOLD_NAME', textFieldWidth:100, DBtextFieldName: 'MOLD_NAME',
                            autoPopup: true,
                            listeners: {'onSelected': {
                                    fn: function(records, type) {
                                        grdRecord = masterGrid5.getSelectedRecord();
                                        record = records[0];
                                        grdRecord.set('MOLD_CODE', record.EQU_CODE);
                                        grdRecord.set('MOLD_NAME', record.EQU_NAME);
                                    },
                                    scope: this
                                },
                                'onClear': function(type) {
                                    grdRecord = masterGrid5.getSelectedRecord();
                                   //record = records[0];
                                    grdRecord.set('MOLD_CODE', '');
                                    grdRecord.set('MOLD_NAME', '');
                                },
                                applyextparam: function(popup){
                                    var param =  panelSearch.getValues();
                                    var record = masterGrid2.getSelectedRecord();
                                    popup.setExtParam({'DIV_CODE': param.DIV_CODE});
                                    //20191204 수정
                                    popup.setExtParam({'EQU_CODE_TYPE': '1'});
//                                    popup.setExtParam({'ITEM_CODE': param.ITEM_CODE});
//                                    popup.setExtParam({'PROG_WORK_CODE': record.get('PROG_WORK_CODE')});
                                }
                            }
                })
            },
            {dataIndex: 'SELECT_BASIS'                ,       width: 100},
            {dataIndex: 'REMARK'                     ,       width: 100}
        ],
        listeners :{
            select: function() {
                var activeTabId = tab.getActiveTab().getId();
                activeTabId == 'tab5';
                var count = masterGrid.getStore().getCount();
                var record = masterGrid.getSelectedRecord();
                if(count > 0) {
                  if(Ext.isEmpty(record.get('WORK_SHOP_CODE'))) {
                        UniAppManager.setToolbarButtons(['newData', 'delete'], false);
                    }
                    UniAppManager.setToolbarButtons(['newData', 'delete'], true);
                } else {
                    UniAppManager.setToolbarButtons(['newData', 'delete'], false);
                }
            },
            cellclick: function() {
                var activeTabId = tab.getActiveTab().getId();
                activeTabId == 'tab5';
                var count = masterGrid.getStore().getCount();
                var record = masterGrid.getSelectedRecord();
                if(count > 0) {
                  if(Ext.isEmpty(record.get('WORK_SHOP_CODE'))) {
                        UniAppManager.setToolbarButtons(['newData', 'delete'], false);
                    }
                    UniAppManager.setToolbarButtons(['newData', 'delete'], true);
                } else {
                    UniAppManager.setToolbarButtons(['newData', 'delete'], false);
                }
            },
            render: function(grid, eOpts) {
                var girdNm = grid.getItemId();
                grid.getEl().on('click', function(e, t, eOpt) {
                	if(directMasterStore.isDirty() || directMasterStore2.isDirty() || directMasterStore3.isDirty() || directMasterStore4.isDirty() ){
                        grid.suspendEvents();
                        alert(Msg.sMB154);//먼저 저장하십시오
                        return false;
                	}else{
	                    var oldGrid = Ext.getCmp(selectedGrid);
				    	grid.changeFocusCls(oldGrid);
				    	selectedGrid = girdNm;
	                    if( directMasterStore2.isDirty() || directMasterStore5.isDirty())    {
	                        UniAppManager.setToolbarButtons('save', true);
	                    }else {
	                        UniAppManager.setToolbarButtons('save', false);
	                    }
                	}
                });
//                if(directMasterStore2.isDirty) {
//                    UniAppManager.setToolbarButtons(['save'], true);
//                }
            },
            beforeedit  : function( editor, e, eOpts ) {
                if(!e.record.phantom) {
                    if(UniUtils.indexOf(e.field, ['WORK_SHOP_CODE', 'WORK_SHOP_NAME', 'PROG_WORK_CODE', 'EQUIP_CODE', 'EQUIP_NAME']))
                    {
                        return false;
                    } else {
                        return true;
                    }
                } else {
                    if(UniUtils.indexOf(e.field))
                    {
                        return true;
                    }
                }
            }
        }
    });

//    var tab1 = Unilite.createTabPanel('tabPanel1',{
//        split: true,
//        border : false,
//        region:'center',
//        items: [
//            {
//                 title: '공정수순등록'
//                 ,xtype:'container'
//                 ,layout:{type:'vbox', align:'stretch'}
//                 ,items:[masterGrid2]
//                 ,id: 'tab2'
//            }
//        ],
//        listeners:  {
//            select: function() {
//                var activeTabId = tab.getActiveTab().getId();
//                if(activeTabId == 'tab2') {
//                    if(directMasterStore.getCount() > 0) {
//                        var record = masterGrid.getSelectedRecord();
//                        var param= panelSearch.getValues();
//                        param.ITEM_CODE = record.get('ITEM_CODE');
//                        param.GS_WORK_SHOP_CODE = BsaCodeInfo.gsProgWorkCode;
//                        directMasterStore2.loadStoreRecords(param);
//                        UniAppManager.setToolbarButtons(['newData', 'delete'], false);
//                    }
//                }
//            }
//        }
//    });

    var tab = Unilite.createTabPanel('tabPanel',{
        split: true,
        border : false,
        region:'south',
        items: [
            {
            	 title: '공정/품목'
                 ,xtype:'container'
                 ,layout:{type:'vbox', align:'stretch'}
                 ,items:[masterGrid3]
                 ,id: 'tab3'
            },{
                 title: '공정/설비'
                 ,xtype:'container'
                 ,layout:{type:'vbox', align:'stretch'}
                 ,items:[masterGrid4]
                 ,id: 'tab4'
            },{
                 title: '공정/금형'
                 ,xtype:'container'
                 ,layout:{type:'vbox', align:'stretch'}
                 ,items:[masterGrid5]
                 ,id: 'tab5'
            }
//           masterGrid3,
//           masterGrid4,
//           masterGrid5
        ],
        listeners:  {
            tabChange:  function ( tabPanel, newCard, oldCard, eOpts )  {
            	var activeTabId = tab.getActiveTab().getId();
                if(activeTabId == 'tab3') {
                	if(directMasterStore2.getCount() > 0) {
                    	var record = masterGrid2.getSelectedRecord();
                        var param= panelSearch.getValues();
                        param.DIV_CODE          = record.get('DIV_CODE');
                        param.ITEM_CODE         = record.get('ITEM_CODE');
                        param.WORK_SHOP_CODE    = record.get('WORK_SHOP_CODE');
                        param.PROG_WORK_CODE    = record.get('PROG_WORK_CODE');
                        directMasterStore3.loadStoreRecords(param);
                        UniAppManager.setToolbarButtons(['newData', 'delete'], false);
                	}
                } else if(activeTabId == 'tab4') {
                    if(directMasterStore2.getCount() > 0) {
                        var record = masterGrid2.getSelectedRecord();
                        var param= panelSearch.getValues();
                        param.DIV_CODE          = record.get('DIV_CODE');
                        param.ITEM_CODE         = record.get('ITEM_CODE');
                        param.WORK_SHOP_CODE    = record.get('WORK_SHOP_CODE');
                        param.PROG_WORK_CODE    = record.get('PROG_WORK_CODE');
                        directMasterStore4.loadStoreRecords(param);
                    	UniAppManager.setToolbarButtons(['newData', 'delete'], true);
                    }
                } else if(activeTabId == 'tab5') {
                    if(directMasterStore2.getCount() > 0) {
                        var record = masterGrid2.getSelectedRecord();
                        var param= panelSearch.getValues();
                        param.DIV_CODE          = record.get('DIV_CODE');
                        param.ITEM_CODE         = record.get('ITEM_CODE');
                        param.WORK_SHOP_CODE    = record.get('WORK_SHOP_CODE');
                        param.PROG_WORK_CODE    = record.get('PROG_WORK_CODE');
                        directMasterStore5.loadStoreRecords(param);
                    	UniAppManager.setToolbarButtons(['newData', 'delete'], true);
                    }
                }
            }
        }
    });

    Unilite.Main( {
        borderItems:[{
            region:'center',
            layout: 'border',
            border : false,
            items:[
                masterGrid, panelResult,
                {
                    region : 'south',
                    xtype : 'container',
                    layout: {type: 'hbox', align: 'stretch'},
                    flex: 1,
                    items : [ masterGrid2,  tab]
                }
            ]
        },
            panelSearch
        ],
        id: 's_pbs071ukrv_kdApp',
        fnInitBinding: function() {
            UniAppManager.setToolbarButtons(['prev', 'next'], true);
            UniAppManager.setToolbarButtons(['save'], false);
            Ext.getCmp('COPY_BTN').setDisabled(true);
            Ext.getCmp('COPY_BTN_PROG').setDisabled(true);
            this.setDefault();
        },
        onQueryButtonDown: function() {
            if(panelSearch.setAllFieldsReadOnly(true) == false){
                return false;
            }
            directMasterStore.loadStoreRecords();
            UniAppManager.setToolbarButtons('reset', true);
//            if(selectedGrid == 's_pbs071ukrv_kdGrid') {
//                directMasterStore.loadStoreRecords();
//                UniAppManager.setToolbarButtons('reset', true);
//            } else if(selectedGrid == 's_pbs071ukrv_kdGrid2') {
//            	var count = masterGrid.getStore().getCount();
//                if(count == 0) {
//                    selectedGrid == 's_pbs071ukrv_kdGrid'
//                } else {
//                	var param = masterGrid.getSelectedRecord();
//                    directMasterStore2.loadStoreRecords(param);
//                    UniAppManager.setToolbarButtons('reset', true);
//                }
//            } else if(selectedGrid == 's_pbs071ukrv_kdGrid3') {
//                var count = masterGrid.getStore().getCount();
//                if(count == 0) {
//                    selectedGrid == 's_pbs071ukrv_kdGrid'
//                } else {
//                    var param = masterGrid2.getSelectedRecord();
//                    directMasterStore3.loadStoreRecords(param);
//                    UniAppManager.setToolbarButtons('reset', true);
//                }
//            } else if(selectedGrid == 's_pbs071ukrv_kdGrid4') {
//                var count = masterGrid.getStore().getCount();
//                if(count == 0) {
//                    selectedGrid == 's_pbs071ukrv_kdGrid'
//                } else {
//                    var param = masterGrid2.getSelectedRecord();
//                    directMasterStore4.loadStoreRecords(param);
//                    UniAppManager.setToolbarButtons('reset', true);
//                }
//            } else if(selectedGrid == 's_pbs071ukrv_kdGrid5') {
//                var count = masterGrid.getStore().getCount();
//                if(count == 0) {
//                    selectedGrid == 's_pbs071ukrv_kdGrid'
//                } else {
//                	var param = masterGrid2.getSelectedRecord();
//                    directMasterStore5.loadStoreRecords(param);
//                    UniAppManager.setToolbarButtons('reset', true);
//                }
//            }
        },
        onNewDataButtonDown: function() {
            var activeTabId = tab.getActiveTab().getId();
//        	if(activeTabId == 'tab2') {
            if(selectedGrid == 's_pbs071ukrv_kdGrid2' && activeTabId != 'tab4' && activeTabId != 'tab5') {

            	var record = masterGrid.getSelectedRecord();
                if(Ext.isEmpty(record)){
                   return false;
                }

                var lineSeq = directMasterStore2.max('LINE_SEQ');
                    if(!lineSeq) lineSeq = 1;
                    else  lineSeq += 1;

                var r = {
                    DIV_CODE         : panelSearch.getValue('DIV_CODE'),
                    WORK_SHOP_CODE   : panelSearch.getValue('WORK_SHOP_CODE'),
                    ITEM_CODE        : record.get('ITEM_CODE'),
                    PROG_UNIT_Q      : '1',
                    LINE_SEQ         : lineSeq,
                    MAKE_LDTIME      : '1'
                }
                masterGrid2.createRow(r);
                Ext.getCmp('COPY_BTN').setDisabled(true);
        	}
        	if(activeTabId == 'tab4') {
//        		if(selectedGrid == 's_pbs071ukrv_kdGrid4') {
                    var pRecord = masterGrid2.getSelectedRecord();
                    if(pRecord != null) {
                        var record       = masterGrid2.getSelectedRecord();
                        var compCode     = UserInfo.compCode;
                        var divCode      = record.get('DIV_CODE');
                        var itemCode     = record.get('ITEM_CODE');
                        var workShopCode = record.get('WORK_SHOP_CODE');
                        var progWorkCode = record.get('PROG_WORK_CODE');
                        var selectBasis  = 'N';

                        var r = {
                            COMP_CODE      : compCode,
                            DIV_CODE       : divCode,
                            ITEM_CODE      : itemCode,
                            WORK_SHOP_CODE : workShopCode,
                            PROG_WORK_CODE : progWorkCode,
                            SELECT_BASIS   : selectBasis
                        }
                        masterGrid4.createRow(r);
                    } else {
                        alert('공정을 먼저 등록하세요.');
                    }
//        		}
            } else if(activeTabId == 'tab5') {
//            	if(selectedGrid == 's_pbs071ukrv_kdGrid4') {
                    var pRecord = masterGrid2.getSelectedRecord();
                    if(pRecord != null) {
                        var record       = masterGrid2.getSelectedRecord();
                        var compCode     = UserInfo.compCode;
                        var divCode      = record.get('DIV_CODE');
                        var itemCode     = record.get('ITEM_CODE');
                        var workShopCode = record.get('WORK_SHOP_CODE');
                        var progWorkCode = record.get('PROG_WORK_CODE');
                        var selectBasis  = 'N';

                        var r = {
                            COMP_CODE      : compCode,
                            DIV_CODE       : divCode,
                            ITEM_CODE      : itemCode,
                            WORK_SHOP_CODE : workShopCode,
                            PROG_WORK_CODE : progWorkCode,
                            SELECT_BASIS   : selectBasis
                        }
                        masterGrid5.createRow(r);
                    } else {
                        alert('공정을 먼저 등록하세요.');
                    }
            	}
//            }
        },
        onDeleteDataButtonDown: function() {
            var activeTabId = tab.getActiveTab().getId();
//        	if(activeTabId == 'tab2') {
            if(selectedGrid == 's_pbs071ukrv_kdGrid2' && activeTabId != 'tab4' && activeTabId != 'tab5') {
            	var selRow = masterGrid2.getSelectedRecord();
                if(selRow.phantom === true) {
                    masterGrid2.deleteSelectedRow();
                } else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
                    masterGrid2.deleteSelectedRow();
                }
             }
            if(activeTabId == 'tab3') {
            	if(selectedGrid == 's_pbs071ukrv_kdGrid3') {
                    var selRow = masterGrid3.getSelectedRecord();
                    if(selRow.phantom === true) {
                        masterGrid3.deleteSelectedRow();
                    } else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
                        masterGrid3.deleteSelectedRow();
                    }
            	}
             } else if(activeTabId == 'tab4') {
             	if(selectedGrid == 's_pbs071ukrv_kdGrid4') {
                    var selRow = masterGrid4.getSelectedRecord();
                    if(selRow.phantom === true) {
                        masterGrid4.deleteSelectedRow();
                    } else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
                        masterGrid4.deleteSelectedRow();
                    }
             	}
             } else if(activeTabId == 'tab5') {
             	if(selectedGrid == 's_pbs071ukrv_kdGrid5') {
                    var selRow = masterGrid5.getSelectedRecord();
                    if(selRow.phantom === true) {
                        masterGrid5.deleteSelectedRow();
                    } else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
                        masterGrid5.deleteSelectedRow();
                    }
             	}
             }
        },
         onDeleteAllButtonDown: function() {
            var records = directMasterStore2.data.items;
            var records2 = directMasterStore3.data.items;
            var records3 = directMasterStore4.data.items;
            var records4 = directMasterStore5.data.items;
            var isNewData = false;
            Ext.each(records, function(record,i) {
                if(record.phantom){                     //신규 레코드일시 isNewData에 true를 반환
                    isNewData = true;
                }else{                                  //신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
                    isNewData = false;
                    if(confirm('전체삭제 하시겠습니까?')) {
                        var deletable = true;
                        /*---------삭제전 로직 구현 시작----------*/

                        /*---------삭제전 로직 구현 끝-----------*/

                        if(deletable){
                            masterGrid2.reset();
                            UniAppManager.app.onSaveDataButtonDown();
                        }
                    }
                    return false;
                }
            });
            Ext.each(records2, function(record,i) {
                if(record.phantom){                     //신규 레코드일시 isNewData에 true를 반환
                    isNewData = true;
                }else{                                  //신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
                    isNewData = false;
                    if(confirm('전체삭제 하시겠습니까?')) {
                        var deletable = true;
                        /*---------삭제전 로직 구현 시작----------*/

                        /*---------삭제전 로직 구현 끝-----------*/

                        if(deletable){
                            masterGrid3.reset();
                            UniAppManager.app.onSaveDataButtonDown();
                        }
                    }
                    return false;
                }
            });
            Ext.each(records3, function(record,i) {
                if(record.phantom){                     //신규 레코드일시 isNewData에 true를 반환
                    isNewData = true;
                }else{                                  //신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
                    isNewData = false;
                    if(confirm('전체삭제 하시겠습니까?')) {
                        var deletable = true;
                        /*---------삭제전 로직 구현 시작----------*/

                        /*---------삭제전 로직 구현 끝-----------*/

                        if(deletable){
                            masterGrid4.reset();
                            UniAppManager.app.onSaveDataButtonDown();
                        }
                    }
                    return false;
                }
            });
            Ext.each(records4, function(record,i) {
                if(record.phantom){                     //신규 레코드일시 isNewData에 true를 반환
                    isNewData = true;
                }else{                                  //신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
                    isNewData = false;
                    if(confirm('전체삭제 하시겠습니까?')) {
                        var deletable = true;
                        /*---------삭제전 로직 구현 시작----------*/

                        /*---------삭제전 로직 구현 끝-----------*/

                        if(deletable){
                            masterGrid5.reset();
                            UniAppManager.app.onSaveDataButtonDown();
                        }
                    }
                    return false;
                }
            });
            if(isNewData){                              //신규 레코드들만 있을시 그리드 리셋
                masterGrid2.reset();
            }
            if(isNewData){                              //신규 레코드들만 있을시 그리드 리셋
                masterGrid3.reset();
            }
            if(isNewData){                              //신규 레코드들만 있을시 그리드 리셋
                masterGrid4.reset();
            }
            if(isNewData){                              //신규 레코드들만 있을시 그리드 리셋
                masterGrid5.reset();
            }
        },
        onSaveDataButtonDown: function() {
            var activeTabId = tab.getActiveTab().getId();
        	//if(activeTabId == 'tab2') {

                var results = directMasterStore2.sumBy(function(record, id) {       // 합계를 가지고 값구하기
                        return true;
                    },
                    ['PROG_RATE']
                );
                var total = results.PROG_RATE;
                if(directMasterStore2.count() > 0 && total != 100) {
                    alert("공정진척율의 합계는 100 이여야 합니다.");
                   // return false;
                } else {
                    directMasterStore2.saveStore();
                }
        	//}
            if(activeTabId == 'tab3') {
            	directMasterStore3.saveStore();
            } else if(activeTabId == 'tab4') {
                directMasterStore4.saveStore();
            } else if(activeTabId == 'tab5') {
                directMasterStore5.saveStore();
            }
        },
        onResetButtonDown: function() {
            panelSearch.clearForm();
            panelResult.clearForm();
            masterGrid.reset();
            masterGrid2.reset();
            masterGrid3.reset();
            masterGrid4.reset();
            masterGrid5.reset();
            directMasterStore.clearData();
            directMasterStore2.clearData();
            directMasterStore3.clearData();
            directMasterStore4.clearData();
            directMasterStore5.clearData();
            this.fnInitBinding();
        },
        setDefault: function() {
            panelSearch.setValue('DIV_CODE',UserInfo.divCode);
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            panelSearch.getForm().wasDirty = false;
            panelResult.getForm().wasDirty = false;
            UniAppManager.setToolbarButtons('save', false);
            selectedGrid == 's_pbs071ukrv_kdGrid';
        },
        fnWorkShopChange: function(records) {
            grdRecord = masterGrid.getSelectedRecord();
            record = records[0];
            grdRecord.set('WORK_SHOP_CODE', record.TREE_CODE);
            grdRecord.set('WORK_SHOP_NAME', record.TREE_NAME);
            if(Ext.isEmpty(grdRecord.get('DIV_CODE'))){
                grdRecord.set('DIV_CODE', record.TYPE_LEVEL);
            }
        }
    });
}
</script>