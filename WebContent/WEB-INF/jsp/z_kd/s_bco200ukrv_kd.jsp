<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_bco200ukrv_kd" >
    <t:ExtComboStore comboType="BOR120" pgmId="s_bco200ukrv_kd"/>   <!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="B004" />             <!-- 화폐단위-->
    <t:ExtComboStore comboType="AU" comboCode="B010" />             <!-- 사용여부-->
    <t:ExtComboStore comboType="AU" comboCode="B024" />             <!-- 담당자-->
    <t:ExtComboStore comboType="AU" comboCode="B013" />             <!-- 재고단위  -->
    <t:ExtComboStore comboType="AU" comboCode="B015" />             <!-- 거래처구분    -->
    <t:ExtComboStore comboType="AU" comboCode="B004" />             <!-- 기준화폐-->
    <t:ExtComboStore comboType="AU" comboCode="B038" />             <!-- 결제방법-->
    <t:ExtComboStore comboType="AU" comboCode="B034" />             <!-- 결제조건-->
    <t:ExtComboStore comboType="AU" comboCode="B055" />             <!-- 거래처분류-->
    <t:ExtComboStore comboType="AU" comboCode="B038" />             <!-- 결제방법-->
    <t:ExtComboStore comboType="AU" comboCode="A003" />             <!-- 구분  -->
    <t:ExtComboStore comboType="AU" comboCode="S003" />             <!-- 단가구분1(판매)  -->
    <t:ExtComboStore comboType="AU" comboCode="M301" />             <!-- 단가구분2(구매)  -->
    <t:ExtComboStore comboType="AU" comboCode="T005" />             <!-- 가격조건  -->
    <t:ExtComboStore comboType="AU" comboCode="WB01" />             <!-- 운송방법  -->
    <t:ExtComboStore comboType="AU" comboCode="WB03" />             <!-- 변동사유  -->
    <t:ExtComboStore comboType="AU" comboCode="WB04" />             <!-- 차종  -->
    <t:ExtComboStore comboType="AU" comboCode="B020" />             <!-- 품목계정 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

var BsaCodeInfo = {     //컨트롤러에서 값을 받아옴.
    gsAutoType  :   '${gsAutoType}',
    gsMoneyUnit :   '${gsMoneyUnit}'
};

//var output ='';   // 셋팅 값 확인 alert
//for(var key in BsaCodeInfo){
//    output += key + '  :  ' + BsaCodeInfo[key] + '\n';
//}
//alert(output);

var SearchReqNumWindow; // 검색창
var SearchInfoWindow;   // 추가정보창
var checkedCount = 0;   // 체크된 레코드

function appMain() {

    /**
     *   Model 정의
     * @type
     */
    var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 's_bco200ukrv_kdService.selectList',
            update: 's_bco200ukrv_kdService.updateDetail',
            syncAll: 's_bco200ukrv_kdService.saveAll'
        }
    });

    var panelSearch = Unilite.createSearchPanel('searchForm', {
        title: '검색조건',
        region: 'west',
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
                name: 'DIV_CODE',
//                holdable: 'hold',
                xtype: 'uniCombobox',
                comboType: 'BOR120',
                allowBlank:false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('DIV_CODE', newValue);
                    }
                }
            },{
                fieldLabel: '품목계정',
                name: 'ITEM_ACCOUNT',
                xtype: 'uniCombobox',
                comboType: 'AU',
                comboCode: 'B020',
                readOnly: false,
//                holdable: 'hold',
                listeners: {
                    change: function(combo, newValue, oldValue, eOpts) {
                        combo.changeDivCode(combo, newValue, oldValue, eOpts);
                        panelResult.setValue('ITEM_ACCOUNT', newValue);
                    }
                }
            },{
                fieldLabel: '품목코드',
                name:'ITEM_CODE',
                xtype: 'uniTextfield',
//                holdable: 'hold',
                allowBlank:false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('ITEM_CODE', newValue);
                    }
                }
            },{
                fieldLabel: '물품명',
                name:'ITEM_NAME1',
                xtype: 'uniTextfield',
//                holdable: 'hold',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('ITEM_NAME1', newValue);
                    }
                }
            },{
                fieldLabel: 'And',
                name:'ITEM_NAME2',
                xtype: 'uniTextfield',
//                holdable: 'hold',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('ITEM_NAME2', newValue);
                    }
                }
            },{
                fieldLabel: '제외조건',
                name:'ITEM_NAME3',
                xtype: 'uniTextfield',
//                holdable: 'hold',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('ITEM_NAME3', newValue);
                    }
                }
            },{
                fieldLabel: '규격',
                name:'SPEC1',
                xtype: 'uniTextfield',
//                holdable: 'hold',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('SPEC1', newValue);
                    }
                }
            },{
                fieldLabel: 'T*',
                name:'SPEC2',
                xtype: 'uniTextfield',
//                holdable: 'hold',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('SPEC2', newValue);
                    }
                }
            },{
                xtype: 'radiogroup',
                fieldLabel: '작업구분',
                id: 'STATUS_GUBUN',
                //holdable: 'hold',
                items : [{
                    boxLabel: '등록',
                    name: 'STATUS',
                    checked: true,
                    inputValue: 'Y'
                },{
                    boxLabel: '삭제',
                    name: 'STATUS',
                    inputValue: 'N'
                }],
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.getField('STATUS').setValue(newValue.STATUS);
                    }
                }
            },{
                fieldLabel: '레코드(HIDDEN)',
                name:'COUNT',
                xtype: 'uniNumberfield',
                hidden: false
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
    });//End of var panelSearch = Unilite.createSearchForm('searchForm', {

    var panelResult = Unilite.createSearchForm('resultForm',{
        hidden: !UserInfo.appOption.collapseLeftSearch,
        region: 'north',
        layout : {type : 'uniTable', columns : 4},
        padding:'1 1 1 1',
        border:true,
        items: [{
                fieldLabel: '사업장',
                name: 'DIV_CODE',
//                holdable: 'hold',
                xtype: 'uniCombobox',
                comboType: 'BOR120',
                allowBlank:false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelSearch.setValue('DIV_CODE', newValue);
                    }
                }
            },{
                fieldLabel: '품목계정',
                name: 'ITEM_ACCOUNT',
                xtype: 'uniCombobox',
                //holdable: 'hold',
                comboType: 'AU',
                readOnly: false,
                comboCode: 'B020',
                colspan: 3,
                listeners: {
                    change: function(combo, newValue, oldValue, eOpts) {
                        combo.changeDivCode(combo, newValue, oldValue, eOpts);
                        panelSearch.setValue('ITEM_ACCOUNT', newValue);
                    }
                }
            },{
                fieldLabel: '품목코드',
                name:'ITEM_CODE',
                xtype: 'uniTextfield',
//                holdable: 'hold',
                allowBlank:false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelSearch.setValue('ITEM_CODE', newValue);
                    }
                }
            },{
                fieldLabel: '물품명',
                name:'ITEM_NAME1',
                xtype: 'uniTextfield',
//                holdable: 'hold',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelSearch.setValue('ITEM_NAME1', newValue);
                    }
                }
            },{
                fieldLabel: 'And',
                padding: '0 0 0 -65',
                name:'ITEM_NAME2',
                xtype: 'uniTextfield',
//                holdable: 'hold',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelSearch.setValue('ITEM_NAME2', newValue);
                    }
                }
            },{
                fieldLabel: '제외조건',
                padding: '0 0 0 -100',
                name:'ITEM_NAME3',
                xtype: 'uniTextfield',
//                holdable: 'hold',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelSearch.setValue('ITEM_NAME3', newValue);
                    }
                }
            },{
                xtype: 'radiogroup',
                fieldLabel: '작업구분',
                //holdable: 'hold',
                items : [{
                    boxLabel: '등록',
                    name: 'STATUS',
                    checked: true,
                    inputValue: 'Y'
                },{
                    boxLabel: '삭제',
                    name: 'STATUS',
                    inputValue: 'N'
                }],
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelSearch.getField('STATUS').setValue(newValue.STATUS);
                    }
                }
            },{
                fieldLabel: '규격',
                name:'SPEC1',
                xtype: 'uniTextfield',
//                holdable: 'hold',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelSearch.setValue('SPEC1', newValue);
                    }
                }
            },{
                fieldLabel: 'T*',
                padding: '0 0 0 -65',
                name:'SPEC2',
                xtype: 'uniTextfield',
//                holdable: 'hold',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelSearch.setValue('SPEC2', newValue);
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

    var inputTable = Unilite.createSearchForm('detailForm', { //createForm
            layout : {type : 'uniTable', columns : 3},
            padding:'1 1 1 1',
            disabled: false,
            border:true,
            region: 'center',
            items: [
                {
                    fieldLabel: '구분',
                    name:'TYPE',
                    xtype: 'uniCombobox',
                    comboType:'AU',
                    comboCode:'A003',
                    //holdable: 'hold',
                    readOnly: false,
                    allowBlank: false
                },{
                    fieldLabel: '적용일',
                    name: 'APLY_START_DATE',
                    xtype: 'uniDatefield',
                    value: UniDate.get('today'),
                    //holdable: 'hold',
                    allowBlank: false
                },{
                    fieldLabel: '화폐',
                    name:'MONEY_UNIT',
                    xtype: 'uniCombobox',
                    comboType:'AU',
                    comboCode:'B004',
                    displayField: 'value',
                    //holdable: 'hold',
                    allowBlank: false
                },
                Unilite.popup('AGENT_CUST',{
                        fieldLabel: '거래처',
                        valueFieldName:'CUSTOM_CODE',
                        textFieldName:'CUSTOM_NAME',
                        //holdable: 'hold',
                        allowBlank: false,
                        listeners: {
                            onSelected: {
                                fn: function(records, type) {
                                    inputTable.setValue('SET_METH', records[0]['SET_METH']);
                                },
                                scope: this
                            },
                            onClear: function(type) {
                                panelSearch.setValue('SET_METH', '');
                            }
                        }
                }),{
                    fieldLabel: '적용단가',
                    name:'ITEM_P',
                    xtype: 'uniNumberfield',
                    decimalPrecision:6,
                    ///holdable: 'hold',
                    allowBlank: false
                },{
                    fieldLabel: '단가구분',
                    name:'PRICE_TYPE',
                    xtype: 'uniCombobox',
                    comboType:'AU',
                    comboCode:'M301',
                    //holdable: 'hold',
                    allowBlank: false
                },{
                    fieldLabel: '결제조건',
                    //holdable: 'hold',
                    name: 'SET_METH',
                    xtype : 'uniCombobox',
                    comboType:'AU',
                    comboCode:'B034',
                    //holdable: 'hold',
                    readOnly: false
                },/* {
                    fieldLabel: '적용근거',
                    name:'TEMPC_01',
                    xtype: 'uniTextfield'
                   // holdable: 'hold'
                } */
                Unilite.popup('REQ_NUM', {
	                    fieldLabel: '의뢰번호',
	                    textFieldName: 'P_REQ_NUM',
	                    holdable: 'hold',
	                    listeners: {
	                        onSelected: {
	                            fn: function(records, type) {
	                                panelResult.setValue('P_REQ_NUM', panelSearch.getValue('P_REQ_NUM'));
	                                inputTable.setValue('APLY_START_DATE', records[0].APLY_START_DATE);
	                                inputTable.setValue('TYPE', records[0].TYPE);
	                                inputTable.setValue('MONEY_UNIT', records[0].MONEY_UNIT);
	                                inputTable.setValue('CUSTOM_CODE', records[0].CUSTOM_CODE);
	                                inputTable.setValue('CUSTOM_NAME', records[0].CUSTOM_NAME);
	                                inputTable.setValue('ITEM_P', records[0].ITEM_P);
	                                inputTable.setValue('PRICE_TYPE', records[0].PRICE_TYPE);
	                                inputTable.setValue('SET_METH', records[0].PAY_TERMS);
	                                inputTable.setValue('TEMPC_02', records[0].MAKER_NAME);
	                                inputTable.setValue('SER_NO', records[0].SER_NO);

	                            },
	                            scope: this
	                        },
	                        onClear: function(type) {
	                            panelResult.setValue('P_REQ_NUM', '');
	                        },
	                        applyextparam: function(popup){
	                            popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
	                            popup.setExtParam({'TYPE1': inputTable.getValue('TYPE')});

	                        }
	                    }
	            })
                ,{
                	fieldLabel: '의뢰순번',
                    name:'SER_NO',
                    xtype: 'uniNumberfield'
                },{
                    fieldLabel: '비고',
                    name:'REMARK',
                    xtype: 'uniTextfield',
                    //holdable: 'hold',
                    width: 570,
                    colspan:2
                },
                {
                    fieldLabel: '제조처명',
                    name:'TEMPC_02',
                    xtype: 'uniTextfield'
                   // holdable: 'hold'
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
        setAllFieldsReadOnly2: function(b) {
            var r= true
            if(b) {
                var invalid = this.getForm().getFields().filterBy(function(field) {
                    return !field.validate();
                });
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

    Unilite.defineModel('s_bco200ukrv_kdModel', {        // 메인1
        fields: [
            {name: 'CHECK' 							, text: 'CHECK'				, type: 'string'},
            {name: 'ITEM_ACCOUNT'			, text: '품목계정'			, type: 'string', comboType:'AU', comboCode:'B020'},
            {name: 'PRICE_EXISTS_YN'			, text: '단가등록'			, type: 'string'},
            {name: 'ITEM_CODE'					, text: '품목코드'			, type: 'string'},
            {name: 'ITEM_NAME'					, text: '품목명'				, type: 'string'},
            {name: 'SPEC'								, text: '규격'					, type: 'string'},
            {name: 'UNIT'								, text: '단위'					, type: 'string'},
            {name: 'P_REQ_NUM'					, text: '의뢰번호'			, type: 'string'},
            {name: 'SER_NO'							, text: '의뢰순번'			, type: 'int'},
            {name: 'TEMPC_01'						, text: '적용근거'			, type: 'string'},
            {name: 'TEMPC_02'						, text: '제조처명'			, type: 'string'},
            {name: 'REMARK'							, text: '비고'					, type: 'string'},
            {name: 'COMP_CODE'					, text: '법인코드'			, type: 'string'},
            {name: 'DIV_CODE'						, text: '사업장'				, type: 'string'},
            {name: 'TYPE'								, text: '구분'					, type: 'string'},
            {name: 'CUSTOM_CODE'				, text: '거래처'				, type: 'string'},
            {name: 'MONEY_UNIT'				, text: '화폐'					, type: 'string'},
            {name: 'APLY_START_DATE'		, text: '적용일'				, type: 'uniDate'},
            {name: 'ITEM_P'							, text: '적용단가'			, type: 'uniUnitPrice'},
            {name: 'USE_YN'							, text: '사용유무'			, type: 'string'},
            {name: 'PRICE_TYPE'					, text: '단가구분'			, type: 'string', /*allowBlank: priceType1,*/ comboType:'AU', comboCode:'M301'}, // 검색조건의 구분이 매입: S003, 매출: M301
            {name: 'INSERT_DB_USER'			, text: '거래처'				, type: 'string'},
            {name: 'INSERT_DB_TIME'			, text: '화폐'					, type: 'string'}

        ]
    });//End of Unilite.defineModel('s_bco200ukrv_kdModel', {

    /**
     * Store 정의(Service 정의)
     * @type
     */
    var directMasterStore1 = Unilite.createStore('s_bco200ukrv_kdMasterStore1', {
            model: 's_bco200ukrv_kdModel',
            autoLoad: false,
            uniOpt : {
                isMaster: true,          // 상위 버튼 연결
                editable: false,         // 수정 모드 사용
                deletable:false,         // 삭제 가능 여부
                useNavi : false          // prev | newxt 버튼 사용
            },
            proxy: directProxy,
            loadStoreRecords : function()  {
                var param = Ext.getCmp('searchForm').getValues();
                param.P_REQ_NUM = 's_bco200ukrv_kd';
                param.SER_NO = '0';
                param.PRICE_TYPE = inputTable.getValue('PRICE_TYPE');
                param.TYPE = inputTable.getValue('TYPE');
                param.APLY_START_DATE = UniDate.getDbDateStr(inputTable.getValue('APLY_START_DATE'));
                param.MONEY_UNIT = inputTable.getValue('MONEY_UNIT');
                param.CUSTOM_CODE = inputTable.getValue('CUSTOM_CODE');
                param.ITEM_P = inputTable.getValue('ITEM_P');
                param.SET_METH = inputTable.getValue('SET_METH');
                param.TEMPC_01 = inputTable.getValue('TEMPC_01');
                param.TEMPC_02 = inputTable.getValue('TEMPC_02');
                param.REMARK = inputTable.getValue('REMARK');
                console.log( param );
                this.load({
                    params : param
                });

            },
            saveStore : function(config)   {
                var inValidRecs = this.getInvalidRecords();
                console.log("inValidRecords : ", inValidRecs);

                var toCreate = this.getNewRecords();
                var toUpdate = this.getUpdatedRecords();
                var toDelete = this.getRemovedRecords();
                var list = [].concat(toUpdate, toCreate);
                console.log("list:", list);

                console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));

                //1. 마스터 정보 파라미터 구성
                var paramMaster= panelSearch.getValues();   //syncAll 수정

                if(inValidRecs.length == 0) {

                	var records = directMasterStore1.data.items;
                	var stype =    inputTable.getValue('TYPE');
                    var saplyStartDate =    inputTable.getValue('APLY_START_DATE');
                    var customCode =    inputTable.getValue('CUSTOM_CODE');
                    var moneyUnit =    inputTable.getValue('MONEY_UNIT');
                    var priceType =    inputTable.getValue('PRICE_TYPE');
                    var itemP =   inputTable.getValue('ITEM_P');
                    var remark =    inputTable.getValue('REMARK');
                    var tempc02 =    inputTable.getValue('TEMPC_02');
                    var pReqNum =    inputTable.getValue('P_REQ_NUM');
                    var serNo =    inputTable.getValue('SER_NO');

                	Ext.each(records, function(record, rowIndex){
						if(record.get('CHECK') == 'Y'){
							record.set('TYPE', stype);
							record.set('APLY_START_DATE', saplyStartDate);
							record.set('CUSTOM_CODE', customCode);
							record.set('MONEY_UNIT', moneyUnit);
							record.set('PRICE_TYPE', priceType);
							record.set('ITEM_P', itemP) ;
							record.set('REMARK', remark);
							record.set('TEMPC_02', tempc02);
							record.set('P_REQ_NUM', pReqNum);
							record.set('SER_NO', serNo);
						}
                	})
                    config = {
                        params: [paramMaster],
                        success: function(batch, option) {
                            panelSearch.getForm().wasDirty = false;
                            panelSearch.resetDirtyStatus();
                            console.log("set was dirty to false");
                            UniAppManager.setToolbarButtons('save', false);
                            UniAppManager.app.onQueryButtonDown();
                         }
                    };
                    this.syncAllDirect(config);
                } else {
                    var grid = Ext.getCmp('s_bco200ukrv_kdGrid1');
                    grid.uniSelectInvalidColumnAndAlert(inValidRecs);
                }
            }
        });     // End of var directMasterStore1 = Unilite.createStore('s_bco200ukrv_kdMasterStore1',{

    /**
     * Master Grid1 정의(Grid Panel)
     * @type
     */
    var masterGrid = Unilite.createGrid('s_bco200ukrv_kdGrid1', {
        sortableColumns : false,
        // for tab
        layout: 'fit',
        region: 'center',
        uniOpt : {
            useMultipleSorting  : true,
            useLiveSearch       : false,
            onLoadSelectFirst   : false,
            dblClickToEdit      : false,
            useGroupSummary     : false,
            useContextMenu      : false,
            useRowNumberer      : false,
            expandLastColumn    : false,
            useRowContext       : false,
            filter: {
                useFilter       : false,
                autoCreate      : true
            }
        },
        selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: true, toggleOnClick: true,
            listeners: {
            	selectionchange:function ( grid, selectRecord, eOpts ){
            		if(panelSearch.getField('STATUS').checked == true){
            			Ext.each(selectRecord, function(selectRecord, i){
	            			if(selectRecord.get('PRICE_EXISTS_YN') == 'Y') {
	                    		Ext.getCmp('s_bco200ukrv_kdGrid1').getSelectionModel().deselect(selectRecord,i);
	                    		selectRecord.set('CHECK','');
								selectRecord.commit();
	            			}
            			})
            		}

            	   },
                select: function(grid, selectRecord, index, rowIndex, eOpts, oldValue ) {

                	if(Ext.isEmpty(inputTable.getValue('TYPE')) || Ext.isEmpty(inputTable.getValue('APLY_START_DATE')) || Ext.isEmpty(inputTable.getValue('MONEY_UNIT')) ||
                	   Ext.isEmpty(inputTable.getValue('CUSTOM_CODE')) || Ext.isEmpty(inputTable.getValue('ITEM_P')) || Ext.isEmpty(inputTable.getValue('PRICE_TYPE'))) {
                	   	alert('필수입력값을 확인해주세요.');
                        selectRecord.set('CHECK' , oldValue);
                     //   return false;
                    } else {

                        checkedCount = checkedCount + 1;
                        panelSearch.setValue('COUNT', checkedCount);
                        selectRecord.set('CHECK' , 'Y');


                    /*     selectRecord.set('TYPE' , inputTable.getValue('TYPE'));
                        selectRecord.set('APLY_START_DATE' , inputTable.getValue('APLY_START_DATE'));
                        selectRecord.set('CUSTOM_CODE' , inputTable.getValue('CUSTOM_CODE'));
                        selectRecord.set('MONEY_UNIT' , inputTable.getValue('MONEY_UNIT'));
                        selectRecord.set('PRICE_TYPE' , inputTable.getValue('PRICE_TYPE'));
                        selectRecord.set('ITEM_P' , inputTable.getValue('ITEM_P'));
                        selectRecord.set('REMARK' , inputTable.getValue('REMARK'));
                        selectRecord.set('TEMPC_02' , inputTable.getValue('TEMPC_02'));
                        selectRecord.set('P_REQ_NUM' , inputTable.getValue('P_REQ_NUM'));
                        selectRecord.set('SER_NO' , inputTable.getValue('SER_NO'));  */

//                        inputTable.getField('TYPE').setReadOnly(true);
//                        inputTable.getField('APLY_START_DATE').setReadOnly(true);
//                        inputTable.getField('CUSTOM_CODE').setReadOnly(true);
//                        inputTable.getField('CUSTOM_NAME').setReadOnly(true);
//                        inputTable.getField('MONEY_UNIT').setReadOnly(true);
//                        inputTable.getField('TYPE').setReadOnly(true);
//                        inputTable.getField('APLY_START_DATE').setReadOnly(true);
//                        inputTable.getField('CUSTOM_CODE').setReadOnly(true);
//                        inputTable.getField('CUSTOM_NAME').setReadOnly(true);
//                        inputTable.getField('MONEY_UNIT').setReadOnly(true);
//                        inputTable.getField('PRICE_TYPE').setReadOnly(true);
//                        inputTable.getField('ITEM_P').setReadOnly(true);
//                        inputTable.getField('REMARK').setReadOnly(true);
//                        inputTable.getField('TEMPC_01').setReadOnly(true);
//                        inputTable.getField('TEMPC_02').setReadOnly(true);

                   }
                },
                deselect: function(grid, selectRecord, index, rowIndex, eOpts, oldValue ){
                	checkedCount = checkedCount - 1;
                    panelSearch.setValue('COUNT', checkedCount);
                    selectRecord.set('CHECK' , oldValue);

              /*       selectRecord.set('TYPE' , oldValue);
                    //selectRecord.set('APLY_START_DATE' , oldValue);
                    selectRecord.set('CUSTOM_CODE' , oldValue);
                    selectRecord.set('MONEY_UNIT' , oldValue);
                    //selectRecord.set('PRICE_TYPE' , oldValue);
                    selectRecord.set('ITEM_P' , oldValue);
                    selectRecord.set('REMARK' , oldValue); */

//                    if(panelSearch.getValue('COUNT') == '0') {
//                        UniAppManager.setToolbarButtons('save', false);
//                        inputTable.getField('TYPE').setReadOnly(false);
//                        inputTable.getField('APLY_START_DATE').setReadOnly(false);
//                        inputTable.getField('CUSTOM_CODE').setReadOnly(false);
//                        inputTable.getField('CUSTOM_NAME').setReadOnly(false);
//                        inputTable.getField('MONEY_UNIT').setReadOnly(false);
//                        inputTable.getField('TYPE').setReadOnly(false);
//                        inputTable.getField('APLY_START_DATE').setReadOnly(false);
//                        inputTable.getField('CUSTOM_CODE').setReadOnly(false);
//                        inputTable.getField('CUSTOM_NAME').setReadOnly(false);
//                        inputTable.getField('MONEY_UNIT').setReadOnly(false);
//                        inputTable.getField('PRICE_TYPE').setReadOnly(false);
//                        inputTable.getField('ITEM_P').setReadOnly(false);
//                        inputTable.getField('REMARK').setReadOnly(false);
//                        inputTable.getField('TEMPC_01').setReadOnly(false);
//                        inputTable.getField('TEMPC_02').setReadOnly(false);
//                    } else {
//                        UniAppManager.setToolbarButtons('save', true);
//                        inputTable.getField('TYPE').setReadOnly(true);
//                        inputTable.getField('APLY_START_DATE').setReadOnly(true);
//                        inputTable.getField('CUSTOM_CODE').setReadOnly(true);
//                        inputTable.getField('CUSTOM_NAME').setReadOnly(true);
//                        inputTable.getField('MONEY_UNIT').setReadOnly(true);
//                        inputTable.getField('TYPE').setReadOnly(true);
//                        inputTable.getField('APLY_START_DATE').setReadOnly(true);
//                        inputTable.getField('CUSTOM_CODE').setReadOnly(true);
//                        inputTable.getField('CUSTOM_NAME').setReadOnly(true);
//                        inputTable.getField('MONEY_UNIT').setReadOnly(true);
//                        inputTable.getField('PRICE_TYPE').setReadOnly(true);
//                        inputTable.getField('ITEM_P').setReadOnly(true);
//                        inputTable.getField('REMARK').setReadOnly(true);
//                        inputTable.getField('TEMPC_01').setReadOnly(true);
//                        inputTable.getField('TEMPC_02').setReadOnly(true);
//                    }
                }
            }
        }),
        store: directMasterStore1,
        columns: [
            {dataIndex: 'CHECK'                         , width: 100, hidden: true},
            {dataIndex: 'ITEM_ACCOUNT'                  , width: 100, hidden: true},
            {dataIndex: 'PRICE_EXISTS_YN'               , width: 80},
            {dataIndex: 'ITEM_CODE'                     , width: 150},
            {dataIndex: 'ITEM_NAME'                     , width: 200},
            {dataIndex: 'SPEC'                          , width: 80},
            {dataIndex: 'UNIT'                          , width: 80},
            {dataIndex: 'P_REQ_NUM'                     , width: 120},
            {dataIndex: 'SER_NO'                          , width: 80},
            {dataIndex: 'TEMPC_01'                      , width: 100, hidden: true},
            {dataIndex: 'TEMPC_02'                      , width: 100, hidden: true},
            {dataIndex: 'REMARK'                        , width: 400, flex: 1},
            {dataIndex: 'COMP_CODE'                     , width: 100, hidden: true},
            {dataIndex: 'DIV_CODE'                      , width: 100, hidden: true},
            {dataIndex: 'TYPE'                          , width: 100, hidden: true},
            {dataIndex: 'CUSTOM_CODE'                   , width: 100, hidden: true},
            {dataIndex: 'MONEY_UNIT'                    , width: 100, hidden: true},
            {dataIndex: 'APLY_START_DATE'               , width: 100, hidden: true},
            {dataIndex: 'ITEM_P'                        , width: 100, hidden: true},
            {dataIndex: 'USE_YN'                        , width: 100, hidden: true},
            {dataIndex: 'PRICE_TYPE'                    , width: 100, hidden: true}

        ],
        listeners: {
            beforeedit: function( editor, e, eOpts ) {
                if(e.record.phantom == false) {
                	return false;
                } else {
                    return false;
                }
            }
//            cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
//            		  var records = directMasterStore1.data.items;
//         		      data = new Object();
//        			  data.records = [];
//             	      Ext.each(records, function(record, i){
//                      if(record.get('PRICE_EXISTS_YN')== 'Y') {
//                          data.records.push(record);
//						  masterGrid.getSelectionModel().deselect(data.records);
//         			  }
//
//        		     });
//
//            	}
			/*,
            selectionchange:function( model1, selected, eOpts ){
                orderNoSearch.loadForm(selected);
            },
            beforecelldblclick : function( view, td, cellIndex, record, tr, rowIndex, e, eOpts )    {
            	alert('1');
            }*/
        }
    });//End of var masterGrid = Unilite.createGrid('s_bco200ukrv_kdGrid1', {

    Unilite.Main( {
        borderItems:[{
                region:'center',
                layout: 'border',
                border: false,
                items:[{
                        region : 'center',
                        xtype : 'container',
                        layout : 'fit',
                        items : [ masterGrid ]
                    },
                    panelResult,
                    {
                        region : 'north',
                        xtype : 'container',
                        highth: 20,
                        layout : 'fit',
                        items : [ inputTable ]
                    }
                ]
            },
            panelSearch
        ],
        id: 's_bco200ukrv_kdApp',
        fnInitBinding: function() {
            panelSearch.setValue('DIV_CODE', UserInfo.divCode);
            panelSearch.setValue('ITEM_ACCOUNT', '40');
            panelResult.setValue('ITEM_ACCOUNT', '40');
            panelSearch.setValue('P_REQ_DATE', UniDate.get('today'));
            inputTable.setValue('APLY_START_DATE', UniDate.get('today'));
            panelResult.setValue('P_REQ_DATE', UniDate.get('today'));
            inputTable.setValue('MONEY_UNIT', BsaCodeInfo.gsMoneyUnit);
            inputTable.setValue('ITEM_P', '0');
            inputTable.setValue('TYPE', '1');
            inputTable.setValue('PRICE_TYPE', 'Y');
            UniAppManager.setToolbarButtons(['reset','newData'], false);
        },
        onQueryButtonDown: function() {
//        	if(panelSearch.setAllFieldsReadOnly(true) == false){
//                return false;
//            }
//            if(panelResult.setAllFieldsReadOnly(true) == false){
//                return false;
//            }
//            if(inputTable.setAllFieldsReadOnly(true) == false){
//                return false;
//            }
//            if(Ext.getCmp('STATUS_GUBUN').getChecked()[0].inputValue == 'N') {
//                if(inputTable.setAllFieldsReadOnly(true) == false){
//                    return false;
//                } else {
//                	if(inputTable.setAllFieldsReadOnly2(true) == false){
//                        return false;
//                    }
//                }
//            } else {
//                if(inputTable.setAllFieldsReadOnly2(true) == false){
//                    return false;
//                }
//            }
        	directMasterStore1.loadStoreRecords();
            UniAppManager.setToolbarButtons(['reset'], true);
        },
        setDefault: function() {        // 기본값
            panelSearch.setValue('DIV_CODE',UserInfo.divCode);
            inputTable.setValue('TYPE', '1');
            inputTable.setValue('MONEY_UNIT', BsaCodeInfo.gsMoneyUnit);
            inputTable.inputTable('APLY_START_DATE', UniDate.get('today'));
            panelSearch.getForm().wasDirty = false;
            panelSearch.resetDirtyStatus();
            UniAppManager.setToolbarButtons('save', false);
        },
        onResetButtonDown: function() {     // 초기화
            this.suspendEvents();
            panelSearch.clearForm();
            panelResult.clearForm();
            inputTable.clearForm();
            panelSearch.setAllFieldsReadOnly(false);
            panelResult.setAllFieldsReadOnly(false);
            inputTable.setAllFieldsReadOnly(false);
            panelSearch.setValue('DIV_CODE',UserInfo.divCode);
            inputTable.setValue('TYPE', '1');
            inputTable.setValue('APLY_START_DATE', UniDate.get('today'));
            UniAppManager.setToolbarButtons(['reset','newData'],false);
            masterGrid.reset();
            this.fnInitBinding();
            directMasterStore1.clearData();
        },
        onSaveDataButtonDown: function(config) {    // 저장 버튼
                directMasterStore1.saveStore();
                //UniAppManager.app.onQueryButtonDown();
                //UniAppManager.app.onResetButtonDown();
        }
    });
};


</script>
