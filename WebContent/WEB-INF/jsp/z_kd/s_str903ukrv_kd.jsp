<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_str903ukrv_kd"  >
    <t:ExtComboStore comboType="BOR120"  pgmId="s_str903ukrv_kd"  />             <!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="S002" /> <!--매출구분-->
    <t:ExtComboStore comboType="AU" comboCode="S003" /> <!--단가유형-->
    <t:ExtComboStore comboType="AU" comboCode="WB04" /> <!-- 차종  -->
    <t:ExtComboStore comboType="AU" comboCode="M201" /> <!--담당자-->
    <t:ExtComboStore comboType="AU" comboCode="B042" /> <!--계획금액단위-->
    <t:ExtComboStore comboType="AU" comboCode="S010" /> <!--영업담당-->
    <t:ExtComboStore comboType="AU" comboCode="B055" /> <!--고객분류-->
    <t:ExtComboStore comboType="AU" comboCode="B020" /> <!--품목계정-->
    <t:ExtComboStore comboType="AU" comboCode="B109" /> <!--유통-->
    <t:ExtComboStore comboType="AU" comboCode="B013" /> <!--판매단위-->
    <t:ExtComboStore comboType="AU" comboCode="WB06" /> <!--B/OUT관리여부-->
</t:appConfig>
<script type="text/javascript" >

//var BsaCodeInfo = {     //컨트롤러에서 값을 받아옴.
//    gsBalanceOut:        '${gsBalanceOut}'
//};
//var output ='';   // 입고내역 셋팅 값 확인 alert
//for(var key in BsaCodeInfo){
//    output += key + '  :  ' + BsaCodeInfo[key] + '\n';
//}
//alert(output);


function appMain() {

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 's_str903ukrv_kdService.selectList',
            update: 's_str903ukrv_kdService.updateDetail',
            syncAll: 's_str903ukrv_kdService.saveAll'
        }
    });

    /**
     *   Model 정의
     * @type
     */
    Unilite.defineModel('s_str903ukrv_kdModel', {
        fields: [
            {name: 'DIV_CODE'              ,text:'사업장'            ,type: 'string', comboType:'BOR120'},
            {name: 'NEGO_YN'               ,text:'네고여부'          ,type: 'string'},
//            {name: 'NEGO_CHECK'            ,text:'네고처리'          ,type: 'boolean'},
            {name: 'NEGO_DATE'             ,text:'네고일자'          ,type: 'uniDate'},
            {name: 'NEGO_DATE_TEMP'        ,text:'네고일자TEMP'      ,type: 'uniDate'},
            {name: 'APLY_START_DATE'       ,text:'확정일자'          ,type: 'uniDate'},
            {name: 'ITEM_P'                ,text:'확정단가'          ,type: 'uniUnitPrice'},
            {name: 'CUSTOM_CODE'           ,text:'거래처코드'        ,type: 'string'},
            {name: 'CUSTOM_NAME'           ,text:'거래처명'          ,type: 'string'},
            {name: 'CAR_TYPE'              ,text:'차종'              ,type: 'string', comboType:'AU', comboCode:'WB04'},
            {name: 'ITEM_CODE'             ,text:'품목코드'          ,type: 'string'},
            {name: 'ITEM_NAME'             ,text:'품목명'            ,type: 'string'},
            {name: 'SPEC'                  ,text:'규격'              ,type: 'string'},
            {name: 'OUT_DATE'              ,text:'출고일자'          ,type: 'uniDate'},
            {name: 'OUT_Q'                 ,text:'출고수량'          ,type: 'uniQty'},
            {name: 'PRICE_YN'              ,text:'단가유형'          ,type: 'string'/*, comboType:'AU', comboCode:'S003'*/},
            {name: 'OUT_P'                 ,text:'출고단가'          ,type: 'uniUnitPrice'},
            {name: 'OUT_I'                 ,text:'출고금액'          ,type: 'uniPrice'},
            {name: 'OUT_NUM'               ,text:'출고번호'          ,type: 'string'},
            {name: 'OUT_SEQ'               ,text:'출고순번'          ,type: 'int'}
        ]
    });

    /**
     * Store 정의(Service 정의)
     * @type
     */
    var directMasterStore = Unilite.createStore('s_str903ukrv_kdMasterStore1',{
        model: 's_str903ukrv_kdModel',
        uniOpt : {
            isMaster: true,            // 상위 버튼 연결
            editable: true,            // 수정 모드 사용
            deletable:false,           // 삭제 가능 여부
            useNavi : false            // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
        loadStoreRecords : function()   {
            var param= panelSearch.getValues();
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
            var paramMaster= panelSearch.getValues();    //syncAll 수정

            if(inValidRecs.length == 0) {
                config = {
                    params: [paramMaster],
                    success: function(batch, option) {
                        panelSearch.getForm().wasDirty = false;
                        panelSearch.resetDirtyStatus();
                        console.log("set was dirty to false");
                        UniAppManager.setToolbarButtons('save', false);
                    }
                };
                this.syncAllDirect(config);
            } else {
                masterGrid3.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
        }
    }); // End of var directMasterStore1

    /**
     * 검색조건 (Search Panel)
     * @type
     */
    var panelSearch = Unilite.createSearchPanel('searchForm', {
        title: '검색조건',
        defaultType: 'uniSearchSubPanel',
        collapsed: UserInfo.appOption.collapseLeftSearch,//true,
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
                    comboType:'BOR120',
                    allowBlank:false,
                    value: UserInfo.divCode,
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {
                            panelResult.setValue('DIV_CODE', newValue);
                        }
                    }
                },
//                Unilite.popup('CUST',{
                Unilite.popup('AGENT_CUST',{
                        fieldLabel: '거래처',
                        valueFieldName:'CUSTOM_CODE',
                        textFieldName:'CUSTOM_NAME',
                        listeners: {
                            onSelected: {
                                fn: function(records, type) {
                                    panelResult.setValue('CUSTOM_CODE', panelSearch.getValue('CUSTOM_CODE'));
                                    panelResult.setValue('CUSTOM_NAME', panelSearch.getValue('CUSTOM_NAME'));
                                },
                                scope: this
                            },
                            onClear: function(type) {
                                panelResult.setValue('CUSTOM_CODE', '');
                                panelResult.setValue('CUSTOM_NAME', '');
                            }
                        }
                }),{
                    fieldLabel: '출고일자',
                    xtype: 'uniDateRangefield',
                    startFieldName: 'OUT_DATE_FR',
                    endFieldName: 'OUT_DATE_TO',
                    startDate: UniDate.get('startOfMonth'),
                    endDate: UniDate.get('today'),
                    allowBlank:false,
                    onStartDateChange: function(field, newValue, oldValue, eOpts) {
                        if(panelSearch) {
                            panelResult.setValue('OUT_DATE_FR', newValue);
                        }
                    },
                    onEndDateChange: function(field, newValue, oldValue, eOpts) {
                        if(panelSearch) {
                            panelResult.setValue('OUT_DATE_TO', newValue);
                        }
                    }
                },
                Unilite.popup('DIV_PUMOK',{
                        fieldLabel: '품목코드',
                        valueFieldName:'ITEM_CODE',
                        textFieldName:'ITEM_NAME',
                        listeners: {
                            onSelected: {
                                fn: function(records, type) {
                                    panelResult.setValue('ITEM_CODE', panelSearch.getValue('ITEM_CODE'));
                                    panelResult.setValue('ITEM_NAME', panelSearch.getValue('ITEM_NAME'));
                                },
                                scope: this
                            },
                            onClear: function(type) {
                                panelResult.setValue('ITEM_CODE', '');
                                panelResult.setValue('ITEM_NAME', '');
                            }
                        }
                }), {
                    xtype: 'radiogroup',
                    fieldLabel: '네고여부',
                    items: [{
                        boxLabel: '미네고',
                        width: 80,
                        name: 'NEGO_YN',
                        inputValue: 'N',
                        checked: true
                    }, {
                        boxLabel: '네고',
                        width: 80,
                        name: 'NEGO_YN',
                        inputValue: 'Y'
                    }],
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {
                            panelResult.getField('NEGO_YN').setValue(newValue.NEGO_YN);
                            UniAppManager.app.onQueryButtonDown();
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
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelSearch.setValue('DIV_CODE', newValue);
                    }
                }
            },
//            Unilite.popup('CUST',{
            Unilite.popup('AGENT_CUST',{
                    fieldLabel: '거래처',
                    valueFieldName:'CUSTOM_CODE',
                    textFieldName:'CUSTOM_NAME',
                    listeners: {
                        onSelected: {
                            fn: function(records, type) {
                                panelSearch.setValue('CUSTOM_CODE', panelResult.getValue('CUSTOM_CODE'));
                                panelSearch.setValue('CUSTOM_NAME', panelResult.getValue('CUSTOM_NAME'));
                            },
                            scope: this
                        },
                        onClear: function(type) {
                            panelSearch.setValue('CUSTOM_CODE', '');
                            panelSearch.setValue('CUSTOM_NAME', '');
                        }
                    }
            }),{
                fieldLabel: '출고일자',
                xtype: 'uniDateRangefield',
                startFieldName: 'OUT_DATE_FR',
                endFieldName: 'OUT_DATE_TO',
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today'),
                allowBlank:false,
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelSearch) {
                        panelSearch.setValue('OUT_DATE_FR', newValue);
                    }
                },
                onEndDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelSearch) {
                        panelSearch.setValue('OUT_DATE_TO', newValue);
                    }
                }
            },
            Unilite.popup('DIV_PUMOK',{
                    fieldLabel: '품목코드',
                    valueFieldName:'ITEM_CODE',
                    textFieldName:'ITEM_NAME',
                    listeners: {
                        onSelected: {
                            fn: function(records, type) {
                                panelSearch.setValue('ITEM_CODE', panelResult.getValue('ITEM_CODE'));
                                panelSearch.setValue('ITEM_NAME', panelResult.getValue('ITEM_NAME'));
                            },
                            scope: this
                        },
                        onClear: function(type) {
                            panelSearch.setValue('ITEM_CODE', '');
                            panelSearch.setValue('ITEM_NAME', '');
                        }
                    }
            }), {
                xtype: 'radiogroup',
                fieldLabel: '네고여부',
                items: [{
                    boxLabel: '미네고',
                    width: 80,
                    name: 'NEGO_YN',
                    inputValue: 'N',
                    checked: true
                }, {
                    boxLabel: '네고',
                    width: 80,
                    name: 'NEGO_YN',
                    inputValue: 'Y'
                }],
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelSearch.getField('NEGO_YN').setValue(newValue.NEGO_YN);
                        UniAppManager.app.onQueryButtonDown();
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
        },
        setLoadRecord: function(record) {
            var me = this;
            me.uniOpt.inLoading=false;
            me.setAllFieldsReadOnly(true);
        }
    });

    var masterGrid = Unilite.createGrid('s_str903ukrv_kdmasterGrid', {
        layout : 'fit',
        region: 'center',
        store: directMasterStore,
        uniOpt: {
            useMultipleSorting  : true,
            useLiveSearch       : false,
            onLoadSelectFirst   : false,
            dblClickToEdit      : true,
            useGroupSummary     : false,
            useContextMenu      : false,
            useRowNumberer      : false,
            expandLastColumn    : true,
            useRowContext       : false,    // rink 항목이 있을경우만 true
            filter: {
                useFilter   : false,
                autoCreate  : true
            }
        },
        selModel: Ext.create('Ext.selection.CheckboxModel', {checkOnly: false,
            listeners: {
                select: function(grid, selectRecord, index, rowIndex, eOpts, newValue, oldValue ){
                    if(selectRecord.get('NEGO_YN') == 'N'){
                        selectRecord.set('NEGO_DATE', UniDate.get('today'));
                        selectRecord.set('NEGO_YN', 'Y');
                    } else {
                        selectRecord.set('NEGO_DATE', '');
                        selectRecord.set('NEGO_YN', 'N');
                    }
                },
                deselect:  function(grid, selectRecord, index, eOpts, newValue, oldValue ){
                    if(selectRecord.get('NEGO_YN') == 'N'){
                        selectRecord.set('NEGO_DATE', selectRecord.get('NEGO_DATE_TEMP'));
                        selectRecord.set('NEGO_YN', 'Y');
                    } else {
                        selectRecord.set('NEGO_DATE', selectRecord.get('NEGO_DATE_TEMP'));
                        selectRecord.set('NEGO_YN', 'N');
                    }
                }
            }
        }),
        columns:  [
            { dataIndex: 'DIV_CODE'                        ,           width: 80},
            { dataIndex: 'NEGO_YN'                         ,           width: 80, hidden: true},
//            { dataIndex: 'NEGO_CHECK'                      ,           width: 80, xtype: 'checkcolumn', align:'center',
//                listeners: {
//                    checkchange: function( CheckColumn, rowIndex, checked, eOpts, newValue, oldValue ) {
//                        var grdRecord = masterGrid.getStore().getAt(rowIndex);
//                        var negoDate = grdRecord.data.NEGO_DATE;
//                        if(checked == true) {
//                            if(grdRecord.get('NEGO_YN') == 'N') {
//                                grdRecord.set('NEGO_DATE', UniDate.get('today'));
//                                grdRecord.set('NEGO_YN', 'Y');
//                            } else {
//                                grdRecord.set('NEGO_DATE', '');
//                                grdRecord.set('NEGO_YN', 'N');
//                            }
//                        } else {
//                            if(grdRecord.get('NEGO_YN') == 'N') {
//                                grdRecord.set('NEGO_DATE', negoDate);
//                                grdRecord.set('NEGO_YN', 'Y');
//                            } else {
//                                grdRecord.set('NEGO_DATE', negoDate);
//                                grdRecord.set('NEGO_YN', 'N');
//                            }
//                        }
//                    }
//                }
//            },
            { dataIndex: 'NEGO_DATE'                       ,           width: 80},
            { dataIndex: 'NEGO_DATE_TEMP'                  ,           width: 80, hidden: true},
            { dataIndex: 'APLY_START_DATE'                 ,           width: 80},
            { dataIndex: 'ITEM_P'                     	   ,           width: 90},
            { dataIndex: 'CUSTOM_CODE'                     ,           width: 110},
            { dataIndex: 'CUSTOM_NAME'                     ,           width: 200},
            { dataIndex: 'CAR_TYPE'                        ,           width: 90},
            { dataIndex: 'ITEM_CODE'                       ,           width: 110},
            { dataIndex: 'ITEM_NAME'                       ,           width: 200},
            { dataIndex: 'SPEC'                            ,           width: 90},
            { dataIndex: 'OUT_DATE'                        ,           width: 80},
            { dataIndex: 'OUT_Q'                           ,           width: 90},
            { dataIndex: 'PRICE_YN'                        ,           width: 90},
            { dataIndex: 'OUT_P'                           ,           width: 90},
            { dataIndex: 'OUT_I'                           ,           width: 90},
            { dataIndex: 'OUT_NUM'                         ,           width: 110},
            { dataIndex: 'OUT_SEQ'                         ,           width: 70}
        ],
        listeners:{
            beforeedit  : function( editor, e, eOpts ) {
                if(UniUtils.indexOf(e.field, ['NEGO_DATE'])) {
                    return true;
                }else{
                    return false;
                }
            }
        }
    });

    Unilite.Main( {
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
        id  : 's_str903ukrv_kdApp',
        fnInitBinding : function() {
            panelSearch.setValue('DIV_CODE',UserInfo.divCode);
            UniAppManager.setToolbarButtons(['save', 'newData','deleteAll'],false);
            panelSearch.clearForm();
            panelResult.clearForm();
            directMasterStore.clearData();
            this.setDefault();
        },
        onQueryButtonDown : function()  {
        	if(!panelSearch.setAllFieldsReadOnly(true)){
                return false;
            }
            directMasterStore.loadStoreRecords();
            UniAppManager.setToolbarButtons('reset', true);
        },
        onResetButtonDown: function() {
            panelSearch.setAllFieldsReadOnly(false);
            panelResult.setAllFieldsReadOnly(false);
            masterGrid.reset();
            this.fnInitBinding();
        },
        onSaveDataButtonDown: function () {
        	directMasterStore.saveStore();
        },
        setDefault: function() {
            panelSearch.setValue('DIV_CODE',UserInfo.divCode);
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            panelSearch.setValue('OUT_DATE_FR', UniDate.get('startOfMonth'));
            panelSearch.setValue('OUT_DATE_TO', UniDate.get('today'));
            panelResult.setValue('OUT_DATE_FR', UniDate.get('startOfMonth'));
            panelResult.setValue('OUT_DATE_TO', UniDate.get('today'));
        }
    });
};


</script>