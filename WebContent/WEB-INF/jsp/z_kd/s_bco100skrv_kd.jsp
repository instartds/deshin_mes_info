<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_bco100skrv_kd" >
    <t:ExtComboStore comboType="BOR120" pgmId="s_bco100skrv_kd"/>   <!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="B004" />             <!-- 화폐단위-->
    <t:ExtComboStore comboType="AU" comboCode="B010" />             <!-- 사용여부-->
    <t:ExtComboStore comboType="AU" comboCode="B024" />             <!-- 담당자-->
    <t:ExtComboStore comboType="AU" comboCode="B013" />             <!-- 재고단위  -->
    <t:ExtComboStore comboType="AU" comboCode="B015" />             <!-- 거래처구분    -->
    <t:ExtComboStore comboType="AU" comboCode="B004" />             <!-- 기준화폐-->
    <t:ExtComboStore comboType="AU" comboCode="B038" />             <!-- 결제방법-->
    <t:ExtComboStore comboType="AU" comboCode="B034" />             <!-- 결제조건-->
    <t:ExtComboStore comboType="AU" comboCode="B055" />             <!-- 거래처분류-->
    <t:ExtComboStore comboType="AU" comboCode="A003" />             <!-- 구분  -->
    <t:ExtComboStore comboType="AU" comboCode="S003" />             <!-- 단가구분1(판매)  -->
    <t:ExtComboStore comboType="AU" comboCode="M301" />             <!-- 단가구분2(구매)  -->
    <t:ExtComboStore comboType="AU" comboCode="T005" />             <!-- 가격조건  -->
    <t:ExtComboStore comboType="AU" comboCode="WB01" />             <!-- 운송방법  -->
    <t:ExtComboStore comboType="AU" comboCode="WB03" />             <!-- 변동사유  -->
    <t:ExtComboStore comboType="AU" comboCode="WB04" />             <!-- 차종  -->
    <t:ExtComboStore items="${WB22_LIST}" storeId="WB22List" /> 		 <!--의뢰서구분리스트-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

var BsaCodeInfo = {     //컨트롤러에서 값을 받아옴.
    gsMoneyUnit:        '${gsMoneyUnit}'
};
var gstypeChk;
var SearchInfoWindow; // 추가정보창

/*var output ='';   // 입고내역 셋팅 값 확인 alert
for(var key in BsaCodeInfo){
    output += key + '  :  ' + BsaCodeInfo[key] + '\n';
}
alert(output);*/


function appMain() {

	var groupUrl = '${groupUrl}'; //그룹웨어 호출 url
	
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
                holdable: 'hold',
                xtype: 'uniCombobox',
                comboType: 'BOR120',
                holdable: 'hold',
                allowBlank:false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('DIV_CODE', newValue);
                    }
                }
            },{
                fieldLabel: '의뢰일',
                xtype: 'uniDateRangefield',
                startFieldName: 'P_REQ_DATE_FR',
                endFieldName: 'P_REQ_DATE_TO',
                holdable: 'hold',
                allowBlank:false,
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                        if(panelResult) {
                            panelResult.setValue('P_REQ_DATE_FR',newValue);
                        }
                    },
                onEndDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelResult) {
                        panelResult.setValue('P_REQ_DATE_TO',newValue);
                    }
                }
            },
            Unilite.popup('DEPT', {
                    fieldLabel: '부서',
                    valueFieldName: 'TREE_CODE',
                    textFieldName: 'TREE_NAME',
                    holdable: 'hold',
                    listeners: {
                        onSelected: {
                            fn: function(records, type) {
                                panelResult.setValue('TREE_CODE', panelSearch.getValue('TREE_CODE'));
                                panelResult.setValue('TREE_NAME', panelSearch.getValue('TREE_NAME'));
                            },
                            scope: this
                        },
                        onClear: function(type) {
                            panelResult.setValue('TREE_CODE', '');
                            panelResult.setValue('TREE_NAME', '');
                        }
                    }
            }),{
                fieldLabel: '구분',
                name:'TYPE',
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'A003',
                holdable: 'hold',
                value:'1',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('TYPE', newValue);
                     //   masterGrid.setHiddenColumn();
                        var priceType1 = true;
                        if(panelSearch.getValue('TYPE') == '1')    {
                            priceType1 = false;
                        }
                        var priceType2 = true;
                        if(panelSearch.getValue('TYPE') == '2')    {
                            priceType2 = false;
                        }
                    }
                }
            },{
                fieldLabel: '기안여부',
                name: 'GW_FLAG',
                xtype: 'uniCombobox',
//                allowBlank: false,
                comboType:'AU',
                comboCode:'WB17',
                holdable: 'hold',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('GW_FLAG', newValue);
                    }
                }
            },{
                fieldLabel: '확정여부',
                name: 'CONFIRM_YN',
                xtype: 'uniCombobox',
//                allowBlank: false,
                comboType:'AU',
                comboCode:'B010',
                holdable: 'hold',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
						 panelResult.setValue('CONFIRM_YN', newValue);
                    }
                }
            },
            Unilite.popup('Employee',{
                    fieldLabel: '담당자',
                    valueFieldName:'PERSON_NUMB',
                    textFieldName:'PERSON_NAME',
                    validateBlank:false,
                    autoPopup:true,
                    holdable: 'hold',
                    listeners: {
                        onSelected: {
                            fn: function(records, type) {
                                panelResult.setValue('PERSON_NUMB', panelSearch.getValue('PERSON_NUMB'));
                                panelResult.setValue('PERSON_NAME', panelSearch.getValue('PERSON_NAME'));
                            },
                            scope: this
                        },
                        onClear: function(type) {
                            panelResult.setValue('PERSON_NUMB', '');
                            panelResult.setValue('PERSON_NAME', '');
                        },
                        onValueFieldChange: function(field, newValue){
                            panelResult.setValue('PERSON_NUMB', newValue);
                        },
                        onTextFieldChange: function(field, newValue){
                            panelResult.setValue('PERSON_NAME', newValue);
                        },
                        applyextparam: function(popup){
                            popup.setExtParam({'DEPT_SEARCH': panelSearch.getValue('TREE_NAME')});
                        }
                    }
            }),{
                fieldLabel: '의뢰번호',
                xtype:'uniTextfield',
                name: 'P_REQ_NUM',
                listeners:{
    				change:function(field, newValue, oldValue) {

    				}
                }
            },
            {
                fieldLabel: '의뢰서구분',
                name:'P_REQ_TYPE',
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'WB22',
                allowBlank:true,
                listeners: {
                	beforequery: function( queryPlan, eOpts ) {
                		var store = queryPlan.combo.getStore();
                		var sType = panelSearch.getValue('TYPE');
                		var rtn = typeChk(sType);
                		var rtnValue = rtn[0];
                		var default1 = rtn[1];
                		var default2 = rtn[2];

                		store.clearFilter();
                		store.getFilters().add({
                		    property: 'value',
                		    value: rtnValue,
                		    operator: 'in'
                		});
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
        layout : {type : 'uniTable', columns : 3},
        padding:'1 1 1 1',
        border:true,
        items: [{
                fieldLabel: '사업장',
                name: 'DIV_CODE',
                xtype: 'uniCombobox',
                comboType: 'BOR120',
                holdable: 'hold',
                allowBlank:false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelSearch.setValue('DIV_CODE', newValue);
                    }
                }
            },{
                fieldLabel: '의뢰번호',
                xtype:'uniTextfield',
                name: 'P_REQ_NUM',
                listeners:{
    				change:function(field, newValue, oldValue) {

    				}
                }
            },
            Unilite.popup('DEPT', {
                    fieldLabel: '부서',
                    holdable: 'hold',
                    valueFieldName: 'TREE_CODE',
                    textFieldName: 'TREE_NAME',
                    listeners: {
                        onSelected: {
                            fn: function(records, type) {
                                panelSearch.setValue('TREE_CODE', panelResult.getValue('TREE_CODE'));
                                panelSearch.setValue('TREE_NAME', panelResult.getValue('TREE_NAME'));
                            },
                            scope: this
                        },
                        onClear: function(type) {
                            panelSearch.setValue('TREE_CODE', '');
                            panelSearch.setValue('TREE_NAME', '');
                        }
                    }
            }),{
                fieldLabel: '구분',
                name:'TYPE',
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'A003',
                holdable: 'hold',
                value:'1',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelSearch.setValue('TYPE', newValue);
                     //   masterGrid.setHiddenColumn();
                        var priceType1 = true;
                        if(panelSearch.getValue('TYPE') == '1')    {
                            priceType1 = false;
                        }
                        var priceType2 = true;
                        if(panelSearch.getValue('TYPE') == '2')    {
                            priceType2 = false;
                        }
                    }
                }
            },{
                fieldLabel: '의뢰일',
                xtype: 'uniDateRangefield',
                startFieldName: 'P_REQ_DATE_FR',
                endFieldName: 'P_REQ_DATE_TO',
                holdable: 'hold',
                allowBlank:false,
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                        if(panelResult) {
                            panelSearch.setValue('P_REQ_DATE_FR',newValue);
                        }
                    },
                onEndDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelResult) {
                        panelSearch.setValue('P_REQ_DATE_TO',newValue);
                    }
                }
            },
            Unilite.popup('Employee',{
                    fieldLabel: '담당자',
                    holdable: 'hold',
                    valueFieldName:'PERSON_NUMB',
                    textFieldName:'PERSON_NAME',
                    validateBlank:false,
                    autoPopup:true,
                    listeners: {
                        onSelected: {
                            fn: function(records, type) {
                                panelSearch.setValue('PERSON_NUMB', panelResult.getValue('PERSON_NUMB'));
                                panelSearch.setValue('PERSON_NAME', panelResult.getValue('PERSON_NAME'));
                            },
                            scope: this
                        },
                        onClear: function(type) {
                            panelSearch.setValue('PERSON_NUMB', '');
                            panelSearch.setValue('PERSON_NAME', '');
                        },
                        onValueFieldChange: function(field, newValue){
                            panelSearch.setValue('PERSON_NUMB', newValue);
                        },
                        onTextFieldChange: function(field, newValue){
                            panelSearch.setValue('PERSON_NAME', newValue);
                        },
                        applyextparam: function(popup){
                            popup.setExtParam({'DEPT_SEARCH': panelSearch.getValue('TREE_NAME')});
                        }
                    }
            }),{
                fieldLabel: '의뢰서구분',
                name:'P_REQ_TYPE',
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'WB22',
                allowBlank:true,
                listeners: {
                	beforequery: function( queryPlan, eOpts ) {
                		var store = queryPlan.combo.getStore();
                		var sType = panelResult.getValue('TYPE');
                		var rtn = typeChk(sType);
                		var rtnValue = rtn[0];
                		var default1 = rtn[1];
                		var default2 = rtn[2];

                		store.clearFilter();
                		store.getFilters().add({
                		    property: 'value',
                		    value: rtnValue,
                		    operator: 'in'
                		});
                	}
                }
            },{
                fieldLabel: '기안여부',
                name: 'GW_FLAG',
                xtype: 'uniCombobox',
//                allowBlank: false,
                comboType:'AU',
                comboCode:'WB17',
                holdable: 'hold',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelSearch.setValue('GW_FLAG', newValue);
                    }
                }
            },
            {
                fieldLabel: '확정여부',
                name: 'CONFIRM_YN',
                xtype: 'uniCombobox',
//                allowBlank: false,
                comboType:'AU',
                comboCode:'B010',
                holdable: 'hold',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelSearch.setValue('CONFIRM_YN', newValue);
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

    Unilite.defineModel('s_bco100skrv_kdModel', {        // 메인1
        fields: [
            {name: 'P_REQ_NUM'              , text: '의뢰번호'                     , type: 'string'},
            {name: 'SER_NO'                 , text: '의뢰순번'                     , type: 'int'},
            {name: 'COMP_CODE'              , text: '법인코드'                     , type: 'string'},
            {name: 'DIV_CODE'               , text: '사업장'                      , type: 'string'},
            {name: 'TREE_CODE'              , text: '부서코드'                     , type: 'string'},
            {name: 'TREE_NAME'              , text: '부서명'                       , type: 'string'},
            {name: 'PERSON_NUMB'            , text: '사원코드'                     , type: 'string'},
            {name: 'PERSON_NAME'            , text: '사원명'                       , type: 'string'},
            {name: 'TYPE'                   , text: '구분'                         , type: 'string', comboType:'AU', comboCode:'A003'},
            {name: 'MONEY_UNIT'             , text: '화폐단위'                     , type: 'string', comboType:'AU', comboCode:'B004', displayField: 'value'},
            {name: 'P_REQ_DATE'             , text: '의뢰일'                      , type: 'uniDate'},
            {name: 'APLY_START_DATE'        , text: '적용일'                      , type: 'uniDate'},
            {name: 'GW_FLAG'                , text: '기안'                         , type: 'string', comboType:'AU', comboCode:'WB17'},
            {name: 'CUSTOM_CODE'            , text: '거래처코드'                , type: 'string'},
            {name: 'CUSTOM_NAME'            , text: '거래처명'                     , type: 'string'},
            {name: 'MAKER_CODE'             , text: '제조처코드'                   , type: 'string'},
            {name: 'MAKER_NAME'             , text: '제조처명'                     , type: 'string'},
            {name: 'NEW_ITEM_FREFIX'        , text: '신규품목코드'                 , type: 'string'},
            {name: 'ITEM_CODE'              , text: '품목코드'                     , type: 'string'},
            {name: 'ITEM_NAME'              , text: '품목명'                      , type: 'string'},
            {name: 'PRICE_TYPE1'            , text: '단가구분'                     , type: 'string', /*allowBlank: priceType2,*/ comboType:'AU', comboCode:'S003'}, // 검색조건의 구분이 매입: S003, 매출: M301
            {name: 'PRICE_TYPE2'            , text: '단가구분'                     , type: 'string', /*allowBlank: priceType1,*/ comboType:'AU', comboCode:'M301'}, // 검색조건의 구분이 매입: S003, 매출: M301
            {name: 'PRICE_TYPE'              , text: '단가구분코드'                      , type: 'string'},
            {name: 'PRICE_TYPE_NM'         , text: '단가구분'                      , type: 'string'},
            {name: 'NS_FLAG'                , text: '내수구분'                     , type: 'string', comboType:'AU', comboCode:'WB18'},
            {name: 'ORDER_UNIT'             , text: '단위'                           , type: 'string', allowBlank: false, comboType:'AU', comboCode:'B013', displayField: 'value'},
            {name: 'ITEM_P'                 , text: '단가'                           , type: 'uniUnitPrice', allowBlank: false},
            {name: 'PACK_ITEM_P'            , text: '포장단가'                     , type: 'uniUnitPrice'},
            //20191224 컬럼명 변경: 이전단가 -> 종전단가
            {name: 'PRE_ITEM_P'             , text: '종전단가'                     , type: 'uniUnitPrice'},
			//20191216 추가
			{name: 'DIFFER_UNIT_P'		, text: '단가차액'		, type: 'uniUnitPrice'},
            {name: 'HS_CODE'                , text: 'HS번호'                     , type: 'string'},
            {name: 'HS_NAME'                , text: 'HS명'                         , type: 'string'},
            {name: 'PAY_TERMS'              , text: '결제조건'                     , type: 'string', comboType:'AU', comboCode:'B034'},
            {name: 'TERMS_PRICE'            , text: '가격조건'                     , type: 'string', comboType:'AU', comboCode:'T005', displayField: 'value'},
            {name: 'DELIVERY_METH'          , text: '운송방법'                     , type: 'string', comboType:'AU', comboCode:'WB01'},
            {name: 'CH_REASON'              , text: '단가변동사유'                   , type: 'string', allowBlank: false, comboType:'AU', comboCode:'WB03'},
            {name: 'OEM_YN'                 , text: 'OEM'                          , type: 'boolean'},
            {name: '12199_YN'               , text: '시중'                            , type: 'boolean'},
            {name: '13199_YN'               , text: '수출'                            , type: 'boolean'},
            {name: '14199_YN'               , text: '대리점'                      , type: 'boolean'},
            {name: '13301_YN'               , text: '청도'                           , type: 'boolean'},
			{name: 'OEM_YN1'                 , text: 'OEMtest'                          , type: 'string'},
			{name: 'colume1'               , text: '시중test'                            , type: 'string'},
			{name: 'colume2'               , text: '수출test'                            , type: 'string'},
			{name: 'colume3'               , text: '대리점test'                      , type: 'string'},
			{name: 'colume4'               , text: '청도test'                           , type: 'string' },
            {name: 'OEM_ITEM_CODE'          , text: '품번'                           , type: 'string'},
            {name: 'SPEC'                   , text: '규격/품번'                         , type: 'string'},
            {name: 'CAR_TYPE'               , text: '차종'                           , type: 'string', comboType:'AU', comboCode:'WB04', valueWidth:40},
            {name: 'STOCK_UNIT'             , text: '재고단위'                     , type: 'string', displayField: 'value'},
            {name: 'CUSTOM_FULL_NAME'       , text: '거래처명'                     , type: 'string'},
            {name: 'ADD01_CUSTOM_CODE'      , text: '거래처1'                     , type: 'string'},
            {name: 'ADD02_CUSTOM_CODE'      , text: '거래처2'                     , type: 'string'},
            {name: 'ADD03_CUSTOM_CODE'      , text: '거래처3'                     , type: 'string'},
            {name: 'ADD04_CUSTOM_CODE'      , text: '거래처4'                     , type: 'string'},
            {name: 'ADD05_CUSTOM_CODE'      , text: '거래처5'                     , type: 'string'},
            {name: 'ADD06_CUSTOM_CODE'      , text: '거래처6'                     , type: 'string'},
            {name: 'ADD07_CUSTOM_CODE'      , text: '거래처7'                     , type: 'string'},
            {name: 'ADD08_CUSTOM_CODE'      , text: '거래처8'                     , type: 'string'},
            {name: 'ADD09_CUSTOM_CODE'      , text: '거래처9'                     , type: 'string'},
            {name: 'ADD10_CUSTOM_CODE'      , text: '거래처10'                    , type: 'string'},
            {name: 'ADD11_CUSTOM_CODE'      , text: '거래처11'                    , type: 'string'},
            {name: 'ADD12_CUSTOM_CODE'      , text: '거래처12'                    , type: 'string'},
            {name: 'ADD13_CUSTOM_CODE'      , text: '거래처13'                    , type: 'string'},
            {name: 'ADD14_CUSTOM_CODE'      , text: '거래처14'                    , type: 'string'},
            {name: 'ADD15_CUSTOM_CODE'      , text: '거래처15'                    , type: 'string'},
            {name: 'ADD16_CUSTOM_CODE'      , text: '거래처16'                    , type: 'string'},
            {name: 'ADD17_CUSTOM_CODE'      , text: '거래처17'                    , type: 'string'},
            {name: 'ADD18_CUSTOM_CODE'      , text: '거래처18'                    , type: 'string'},
            {name: 'ADD19_CUSTOM_CODE'      , text: '거래처19'                    , type: 'string'},
            {name: 'ADD20_CUSTOM_CODE'      , text: '거래처20'                    , type: 'string'},
            {name: 'ADD01_CUSTOM_NAME'      , text: '거래처1'                      , type: 'string'},
            {name: 'ADD02_CUSTOM_NAME'      , text: '거래처2'                      , type: 'string'},
            {name: 'ADD03_CUSTOM_NAME'      , text: '거래처3'                      , type: 'string'},
            {name: 'ADD04_CUSTOM_NAME'      , text: '거래처4'                      , type: 'string'},
            {name: 'ADD05_CUSTOM_NAME'      , text: '거래처5'                      , type: 'string'},
            {name: 'ADD06_CUSTOM_NAME'      , text: '거래처6'                      , type: 'string'},
            {name: 'ADD07_CUSTOM_NAME'      , text: '거래처7'                      , type: 'string'},
            {name: 'ADD08_CUSTOM_NAME'      , text: '거래처8'                      , type: 'string'},
            {name: 'ADD09_CUSTOM_NAME'      , text: '거래처9'                      , type: 'string'},
            {name: 'ADD10_CUSTOM_NAME'      , text: '거래처10'                     , type: 'string'},
            {name: 'ADD11_CUSTOM_NAME'      , text: '거래처11'                     , type: 'string'},
            {name: 'ADD12_CUSTOM_NAME'      , text: '거래처12'                     , type: 'string'},
            {name: 'ADD13_CUSTOM_NAME'      , text: '거래처13'                     , type: 'string'},
            {name: 'ADD14_CUSTOM_NAME'      , text: '거래처14'                     , type: 'string'},
            {name: 'ADD15_CUSTOM_NAME'      , text: '거래처15'                     , type: 'string'},
            {name: 'ADD16_CUSTOM_NAME'      , text: '거래처16'                     , type: 'string'},
            {name: 'ADD17_CUSTOM_NAME'      , text: '거래처17'                     , type: 'string'},
            {name: 'ADD18_CUSTOM_NAME'      , text: '거래처18'                     , type: 'string'},
            {name: 'ADD19_CUSTOM_NAME'      , text: '거래처19'                     , type: 'string'},
            {name: 'ADD20_CUSTOM_NAME'      , text: '거래처20'                     , type: 'string'},
            {name: 'ADD21_CUSTOM_NAME'      , text: '거래처21'                     , type: 'string'},
            {name: 'ADD22_CUSTOM_NAME'      , text: '거래처22'                     , type: 'string'},
            {name: 'REMARK'                 , text: '비고'                           , type: 'string'},
            {name: 'CONFIRM_YN'             , text: '확정'                         , type: 'string', comboType:'AU', comboCode:'B010'},
            {name: 'RENEWAL_YN'             , text: '갱신'                         , type: 'string', comboType:'AU', comboCode:'B010'},
            {name: 'INSERT_DB_USER'         , text: '입력ID'                     , type: 'string'},
            {name: 'INSERT_DB_TIME'         , text: '입력일'                      , type: 'uniDate'},
            {name: 'UPDATE_DB_USER'         , text: '수정ID'                     , type: 'string'},
            {name: 'UPDATE_DB_TIME'         , text: '수정일'                      , type: 'uniDate'},
            {name: 'TEMPC_01'               , text: '여유컬럼'                     , type: 'string'},
            {name: 'TEMPC_02'               , text: '여유컬럼'                     , type: 'string'},
            {name: 'TEMPC_03'               , text: '여유컬럼'                     , type: 'string'},
            {name: 'TEMPN_01'               , text: '여유컬럼'                     , type: 'string'},
            {name: 'TEMPN_02'               , text: '여유컬럼'                     , type: 'string'},
            {name: 'TEMPN_03'               , text: '여유컬럼'                     , type: 'string'},
            {name: 'OEM_APLY_YN'            , text: 'OEM적용여부'                  , type: 'string', comboType:'AU', comboCode:'B010'},
            {name: 'P_REQ_TYPE'             , text: '의뢰서구분'                   , type: 'string', comboType:'AU', comboCode:'WB22'},


            {name: 'NEW_CAR_TYPE'           , text: '신규 품목코드'                     , type: 'string'},
            {name: 'STOCK_UNIT2'            , text: '신규 품목단위'                     , type: 'string'},
            {name: 'CAR_TYPE2'              , text: '신규 차종'                     , type: 'string'},
            {name: 'ITEM_NAME2'             , text: '신규 품목명'                     , type: 'string'},
            {name: 'SPEC2'                  , text: '신규 품목규격'                     , type: 'string'},
            {name: 'CUSTOM_NAME2'             , text: '신규 거래처명'                     , type: 'string'},
            {name: 'CUSTOM_FULL_NAME2'                  , text: '신규 거래처전명'                     , type: 'string'},
            {name: 'GW_DOC'                  , text: 'GW_DOC'                     , type: 'string'}

        ]
    });//End of Unilite.defineModel('s_bco100skrv_kdModel', {

    /**
     * Store 정의(Service 정의)
     * @type
     */
    var directMasterStore1 = Unilite.createStore('s_bco100skrv_kdMasterStore1', {
            model: 's_bco100skrv_kdModel',
            autoLoad: false,
            uniOpt : {
                isMaster: true,         // 상위 버튼 연결
                editable: false,        // 수정 모드 사용
                deletable:false,        // 삭제 가능 여부
                useNavi : false         // prev | newxt 버튼 사용
            },
            proxy: {
                type: 'direct',
                api: {
                    read: 's_bco100skrv_kdService.selectList'
                }
            },
            loadStoreRecords : function()  {
                var param= Ext.getCmp('resultForm').getValues();
                console.log( param );
                this.load({
                    params : param
                });

            },
			listeners:{
			    load: function(store, records, successful, eOpts){
			    	/*Ext.each(records, function(record, rowIndex){
			      	  if(record.get('OEM_YN1') == 'Y'){
				      	record.set('OEM_YN', true);
			      	  }
			      	  if(record.get('colume1') == 'Y'){
			      	    record.set('12199_YN', true);
			      	  }
			      	  if(record.get('colume2') == 'Y'){
			      	  	record.set('13199_YN', true);
			      	  }
			      	  if(record.get('colume3') == 'Y'){
			      	  	record.set('14199_YN', true);
			      	  }
			      	  if(record.get('colume4') == 'Y'){
			      	  	record.set('13301_YN', true);
			      	  }
				     }) */
				  }
			   },
            groupField: 'P_REQ_NUM'
        });     // End of var directMasterStore1 = Unilite.createStore('s_bco100skrv_kdMasterStore1',{

    /**
     * Master Grid1 정의(Grid Panel)
     * @type
     */
    var masterGrid = Unilite.createGrid('s_bco100skrv_kdGrid1', {
        // for tab
        layout: 'fit',
        region: 'center',
        selModel:'rowmodel',
        uniOpt:{ useMultipleSorting	: true,
	    	useLiveSearch		: true,
	    	onLoadSelectFirst	: true,
	    	dblClickToEdit		: false,
	    	useGroupSummary		: true,
			useContextMenu		: false,
			useRowNumberer		: true,
			expandLastColumn	: true,
			useRowContext		: true,
    		filter: {
				useFilter: false,
				autoCreate: false
			}
        },
        store: directMasterStore1,
        tbar: [{
            itemId : 'estimateBtn',
            id:'INFO_BTN',
            iconCls : 'icon-referance'  ,
            text:'추가정보',
            handler: function() {
                openSearchInfoWindow();
            }
        },{
            itemId : 'GWBtn2',
            id:'GW2',
            iconCls : 'icon-referance'  ,
            text:'기안뷰',
            handler: function() {
                var param = panelResult.getValues();
                param.DRAFT_NO = UserInfo.compCode + panelResult.getValue('P_REQ_NUM');
                record = masterGrid.getSelectedRecord();
                s_bco100skrv_kdService.selectDraftNo(param, function(provider, response) {
                    if(Ext.isEmpty(provider[0])) {
                        alert('draft No가 없습니다.');
                        return false;
                    } else {
                        UniAppManager.app.requestApprove2(record);
                    }
                });
                UniAppManager.app.onQueryButtonDown();
            }
        }],

    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true },
    	           		{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: true}
    	                ],
        columns: [
            {dataIndex: 'COMP_CODE'               , width:100, hidden: true},
            {dataIndex: 'DIV_CODE'                , width:100, hidden: true},
            {dataIndex: 'P_REQ_NUM'               , width:150, hidden: false,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
				       return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총합');
	            	}},
            {dataIndex: 'SER_NO'                  , width:80, hidden: false},
            {dataIndex: 'TYPE'                    , width:100, hidden: false},
            {dataIndex: 'P_REQ_TYPE'              , width:100},
            {dataIndex: 'NEW_ITEM_FREFIX'         , width: 120, hidden: true},
            {dataIndex: 'ITEM_CODE'                     , width: 120},
            {dataIndex: 'ITEM_NAME'                     , width: 200},
            {dataIndex: 'SPEC'                    , width:100},
            {dataIndex: 'OEM_ITEM_CODE'           , width:100, hidden: true},
            {dataIndex: 'CAR_TYPE'                , width:100},
            {dataIndex: 'HS_CODE'                 , width: 120},
            {dataIndex: 'HS_NAME'               , width: 120, hidden: true},
            {dataIndex: 'ORDER_UNIT'              , width:100, align: 'center'},
            {dataIndex: 'PRICE_TYPE_NM'             , width:100, hidden: false, align: 'center'},
            {dataIndex: 'NS_FLAG'                   , width:100, align: 'center'},
            {dataIndex: 'ITEM_P'                  , width:100, summaryType: 'sum' },
            {dataIndex: 'PACK_ITEM_P'             , width:100, summaryType: 'sum'},
            {dataIndex: 'PRE_ITEM_P'              , width:100, summaryType: 'sum'},
            {dataIndex: 'DIFFER_UNIT_P'         , width:100},
            {dataIndex: 'MONEY_UNIT'              , width:100, align: 'center'},
            {dataIndex: 'TERMS_PRICE'             , width:85, align: 'center'},
            {dataIndex: 'APLY_START_DATE'         , width:100},
            {dataIndex: 'CUSTOM_CODE'             , width:120},
            {dataIndex: 'CUSTOM_NAME'             , width: 200},
            {dataIndex: 'PAY_TERMS'               , width:100},
            {dataIndex: 'DELIVERY_METH'           , width:100},
            {dataIndex: 'MAKER_CODE'              , width: 120},
            {dataIndex: 'MAKER_NAME'               , width: 200},
            {dataIndex: 'CH_REASON'               , width:200},
            {dataIndex: 'OEM_APLY_YN'             , width:100},
            {dataIndex: 'OEM_YN'                  , width:85, xtype: 'checkcolumn', disabled: true, disabledCls : ''},
            {dataIndex: '12199_YN'                , width:85, xtype: 'checkcolumn', disabled: true, disabledCls : ''},
            {dataIndex: '13199_YN'                , width:85, xtype: 'checkcolumn', disabled: true, disabledCls : ''},
            {dataIndex: '14199_YN'                , width:85, xtype: 'checkcolumn', disabled: true, disabledCls : ''},
            {dataIndex: '13301_YN'                , width:85, xtype: 'checkcolumn', disabled: true, disabledCls : ''},
			{dataIndex: 'OEM_YN1'                  , width:85,hidden: true},
            {dataIndex: 'CONFIRM_YN'              , width:85},
            {dataIndex: 'RENEWAL_YN'              , width:85},
            {dataIndex: 'GW_FLAG'                 , width:100},
            {dataIndex: 'P_REQ_DATE'              , width:100, hidden: false},
            {dataIndex: 'TREE_CODE'               , width:100, hidden: false},
            {dataIndex: 'TREE_NAME'               , width:150, hidden: false},
            {dataIndex: 'PERSON_NUMB'             , width:100, hidden: false},
            {dataIndex: 'PERSON_NAME'             , width:150, hidden: false},
            {dataIndex: 'SER_NO'                  , width:100, hidden: true},
            {dataIndex: 'SPEC'                    , width:100, hidden: true},
            {dataIndex: 'STOCK_UNIT'              , width:100, hidden: true},
            {dataIndex: 'CUSTOM_FULL_NAME'        , width:100, hidden: true},
            {dataIndex: 'ADD01_CUSTOM_CODE'       , width:100, hidden: true},
            {dataIndex: 'ADD02_CUSTOM_CODE'       , width:100, hidden: true},
            {dataIndex: 'ADD03_CUSTOM_CODE'       , width:100, hidden: true},
            {dataIndex: 'ADD04_CUSTOM_CODE'       , width:100, hidden: true},
            {dataIndex: 'ADD05_CUSTOM_CODE'       , width:100, hidden: true},
            {dataIndex: 'ADD06_CUSTOM_CODE'       , width:100, hidden: true},
            {dataIndex: 'ADD07_CUSTOM_CODE'       , width:100, hidden: true},
            {dataIndex: 'ADD08_CUSTOM_CODE'       , width:100, hidden: true},
            {dataIndex: 'ADD09_CUSTOM_CODE'       , width:100, hidden: true},
            {dataIndex: 'ADD10_CUSTOM_CODE'       , width:100, hidden: true},
            {dataIndex: 'ADD11_CUSTOM_CODE'       , width:100, hidden: true},
            {dataIndex: 'ADD12_CUSTOM_CODE'       , width:100, hidden: true},
            {dataIndex: 'ADD13_CUSTOM_CODE'       , width:100, hidden: true},
            {dataIndex: 'ADD14_CUSTOM_CODE'       , width:100, hidden: true},
            {dataIndex: 'ADD15_CUSTOM_CODE'       , width:100, hidden: true},
            {dataIndex: 'ADD16_CUSTOM_CODE'       , width:100, hidden: true},
            {dataIndex: 'ADD17_CUSTOM_CODE'       , width:100, hidden: true},
            {dataIndex: 'ADD18_CUSTOM_CODE'       , width:100, hidden: true},
            {dataIndex: 'ADD19_CUSTOM_CODE'       , width:100, hidden: true},
            {dataIndex: 'ADD20_CUSTOM_CODE'       , width:100, hidden: true},
            {dataIndex: 'ADD21_CUSTOM_CODE'       , width:100, hidden: true},
            {dataIndex: 'ADD22_CUSTOM_CODE'       , width:100, hidden: true},
            {dataIndex: 'ADD01_CUSTOM_NAME'       , width:100, hidden: true},
            {dataIndex: 'ADD02_CUSTOM_NAME'       , width:100, hidden: true},
            {dataIndex: 'ADD03_CUSTOM_NAME'       , width:100, hidden: true},
            {dataIndex: 'ADD04_CUSTOM_NAME'       , width:100, hidden: true},
            {dataIndex: 'ADD05_CUSTOM_NAME'       , width:100, hidden: true},
            {dataIndex: 'ADD06_CUSTOM_NAME'       , width:100, hidden: true},
            {dataIndex: 'ADD07_CUSTOM_NAME'       , width:100, hidden: true},
            {dataIndex: 'ADD08_CUSTOM_NAME'       , width:100, hidden: true},
            {dataIndex: 'ADD09_CUSTOM_NAME'       , width:100, hidden: true},
            {dataIndex: 'ADD10_CUSTOM_NAME'       , width:100, hidden: true},
            {dataIndex: 'ADD11_CUSTOM_NAME'       , width:100, hidden: true},
            {dataIndex: 'ADD12_CUSTOM_NAME'       , width:100, hidden: true},
            {dataIndex: 'ADD13_CUSTOM_NAME'       , width:100, hidden: true},
            {dataIndex: 'ADD14_CUSTOM_NAME'       , width:100, hidden: true},
            {dataIndex: 'ADD15_CUSTOM_NAME'       , width:100, hidden: true},
            {dataIndex: 'ADD16_CUSTOM_NAME'       , width:100, hidden: true},
            {dataIndex: 'ADD17_CUSTOM_NAME'       , width:100, hidden: true},
            {dataIndex: 'ADD18_CUSTOM_NAME'       , width:100, hidden: true},
            {dataIndex: 'ADD19_CUSTOM_NAME'       , width:100, hidden: true},
            {dataIndex: 'ADD20_CUSTOM_NAME'       , width:100, hidden: true},
            {dataIndex: 'ADD21_CUSTOM_NAME'       , width:100, hidden: true},
            {dataIndex: 'ADD22_CUSTOM_NAME'       , width:100, hidden: true},
            {dataIndex: 'REMARK'                  , width:100, hidden: true},
            {dataIndex: 'INSERT_DB_USER'          , width:100, hidden: true},
            {dataIndex: 'INSERT_DB_TIME'          , width:100, hidden: true},
            {dataIndex: 'UPDATE_DB_USER'          , width:100, hidden: true},
            {dataIndex: 'UPDATE_DB_TIME'          , width:100, hidden: true},
            {dataIndex: 'TEMPC_01'                , width:100, hidden: true},
            {dataIndex: 'TEMPC_02'                , width:100, hidden: true},
            {dataIndex: 'TEMPC_03'                , width:100, hidden: true},
            {dataIndex: 'TEMPN_01'                , width:100, hidden: true},
            {dataIndex: 'TEMPN_02'                , width:100, hidden: true},
            {dataIndex: 'TEMPN_03'                , width:100, hidden: true},

            {dataIndex: 'NEW_CAR_TYPE'                , width:100, hidden: true},
            {dataIndex: 'STOCK_UNIT2'                , width:100, hidden: true},
            {dataIndex: 'CAR_TYPE2'                , width:100, hidden: true},
            {dataIndex: 'ITEM_NAME2'                , width:100, hidden: true},
            {dataIndex: 'SPEC2'                , width:100, hidden: true},
            {dataIndex: 'CUSTOM_NAME2'                , width:100, hidden: true},
            {dataIndex: 'CUSTOM_FULL_NAME2'                , width:100, hidden: true},
            {dataIndex: 'GW_DOC'                  , width:100, hidden: true}


        ],
        selModel: 'rowmodel',		// 조회화면 selectionchange event 사용
        setHiddenColumn: function() {
        	var me = this;
        	var colPriceTyp1 = me.getColumn('PRICE_TYPE1');
        	var colPriceTyp2 = me.getColumn('PRICE_TYPE2');
            if(panelSearch.getValue('TYPE') == '2') {
                if(colPriceTyp1 && colPriceTyp1.isHidden())		colPriceTyp1.setVisible(true);
                if(colPriceTyp2 && colPriceTyp2.isVisible())	colPriceTyp2.setVisible(false);
            } else {
                if(colPriceTyp1 && colPriceTyp1.isVisible())	colPriceTyp1.setVisible(false);
                if(colPriceTyp2 && colPriceTyp2.isHidden())		colPriceTyp2.setVisible(true);
            }
        },
        listeners:{
        	afterrender : function(grid, eOpts) {
        	//	grid.setHiddenColumn();
        	},
        	cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
                panelResult.setValue('P_REQ_NUM',record.get('P_REQ_NUM'));
               }
            }
        
    });//End of var masterGrid = Unilite.createGrid('s_bco100skrv_kdGrid1', {


    function openSearchInfoWindow() {   // 추가정보 팝업창
        if(!SearchInfoWindow) {
            SearchInfoWindow = Ext.create('widget.uniDetailWindow', {
                title: '단가의뢰서추가정보',
                width: 1080,
                height: 580,
                layout: {type:'vbox', align:'stretch'},
                items: [orderNoSearch],
                tbar:  ['->',{
                            itemId : 'OrderNoCloseBtn',
                            text: '닫기',
                            handler: function() {
                                SearchInfoWindow.hide();
                            },
                            disabled: false
                        }
                ],
                listeners: {beforehide: function(me, eOpt)
                    {
                         orderNoSearch.setValue('ITEM_CODE1'    , '');
                         orderNoSearch.setValue('ITEM_NAME1'    , '');
                         orderNoSearch.setValue('SPEC1'    , '');
                         orderNoSearch.setValue('CUSTOM_CODE1'    , '');
                         orderNoSearch.setValue('CUSTOM_NAME1'    , '');
                         orderNoSearch.setValue('ADD01_CUSTOM_CODE'  ,'');
                        orderNoSearch.setValue('ADD02_CUSTOM_CODE'  ,'');
                        orderNoSearch.setValue('ADD03_CUSTOM_CODE'  ,'');
                        orderNoSearch.setValue('ADD04_CUSTOM_CODE'  ,'');
                        orderNoSearch.setValue('ADD05_CUSTOM_CODE'  ,'');
                        orderNoSearch.setValue('ADD06_CUSTOM_CODE'  ,'');
                        orderNoSearch.setValue('ADD07_CUSTOM_CODE'  ,'');
                        orderNoSearch.setValue('ADD08_CUSTOM_CODE'  ,'');
                        orderNoSearch.setValue('ADD09_CUSTOM_CODE'  ,'');
                        orderNoSearch.setValue('ADD10_CUSTOM_CODE'  ,'');
                        orderNoSearch.setValue('ADD11_CUSTOM_CODE'  ,'');
                        orderNoSearch.setValue('ADD12_CUSTOM_CODE'  ,'');
                        orderNoSearch.setValue('ADD13_CUSTOM_CODE'  ,'');
                        orderNoSearch.setValue('ADD14_CUSTOM_CODE'  ,'');
                        orderNoSearch.setValue('ADD15_CUSTOM_CODE'  ,'');
                        orderNoSearch.setValue('ADD16_CUSTOM_CODE'  ,'');
                        orderNoSearch.setValue('ADD17_CUSTOM_CODE'  ,'');
                        orderNoSearch.setValue('ADD18_CUSTOM_CODE'  ,'');
                        orderNoSearch.setValue('ADD19_CUSTOM_CODE'  ,'');
                        orderNoSearch.setValue('ADD20_CUSTOM_CODE'  ,'');
                        orderNoSearch.setValue('ADD21_CUSTOM_CODE'  ,'');
                        orderNoSearch.setValue('ADD22_CUSTOM_CODE'  ,'');
                        orderNoSearch.setValue('CUSTOM_NAME01'      ,'');
                        orderNoSearch.setValue('CUSTOM_NAME02'      ,'');
                        orderNoSearch.setValue('CUSTOM_NAME03'      ,'');
                        orderNoSearch.setValue('CUSTOM_NAME04'      ,'');
                        orderNoSearch.setValue('CUSTOM_NAME05'      ,'');
                        orderNoSearch.setValue('CUSTOM_NAME06'      ,'');
                        orderNoSearch.setValue('CUSTOM_NAME07'      ,'');
                        orderNoSearch.setValue('CUSTOM_NAME08'      ,'');
                        orderNoSearch.setValue('CUSTOM_NAME09'      ,'');
                        orderNoSearch.setValue('CUSTOM_NAME10'      ,'');
                        orderNoSearch.setValue('CUSTOM_NAME11'      ,'');
                        orderNoSearch.setValue('CUSTOM_NAME12'      ,'');
                        orderNoSearch.setValue('CUSTOM_NAME13'      ,'');
                        orderNoSearch.setValue('CUSTOM_NAME14'      ,'');
                        orderNoSearch.setValue('CUSTOM_NAME15'      ,'');
                        orderNoSearch.setValue('CUSTOM_NAME16'      ,'');
                        orderNoSearch.setValue('CUSTOM_NAME17'      ,'');
                        orderNoSearch.setValue('CUSTOM_NAME18'      ,'');
                        orderNoSearch.setValue('CUSTOM_NAME19'      ,'');
                        orderNoSearch.setValue('CUSTOM_NAME20'      ,'');
                        orderNoSearch.setValue('CUSTOM_NAME21'      ,'');
                        orderNoSearch.setValue('CUSTOM_NAME22'      ,'');

                        //orderNoSearch.clearForm();
                    },
                    beforeclose: function( panel, eOpts ) {

                         orderNoSearch.setValue('ITEM_CODE1'    , '');
                         orderNoSearch.setValue('ITEM_NAME1'    , '');
                         orderNoSearch.setValue('SPEC1'    , '');
                         orderNoSearch.setValue('CUSTOM_CODE1'    , '');
                         orderNoSearch.setValue('CUSTOM_NAME1'    , '');
                          orderNoSearch.setValue('ADD01_CUSTOM_CODE'  ,'');
                        orderNoSearch.setValue('ADD02_CUSTOM_CODE'  ,'');
                        orderNoSearch.setValue('ADD03_CUSTOM_CODE'  ,'');
                        orderNoSearch.setValue('ADD04_CUSTOM_CODE'  ,'');
                        orderNoSearch.setValue('ADD05_CUSTOM_CODE'  ,'');
                        orderNoSearch.setValue('ADD06_CUSTOM_CODE'  ,'');
                        orderNoSearch.setValue('ADD07_CUSTOM_CODE'  ,'');
                        orderNoSearch.setValue('ADD08_CUSTOM_CODE'  ,'');
                        orderNoSearch.setValue('ADD09_CUSTOM_CODE'  ,'');
                        orderNoSearch.setValue('ADD10_CUSTOM_CODE'  ,'');
                        orderNoSearch.setValue('ADD11_CUSTOM_CODE'  ,'');
                        orderNoSearch.setValue('ADD12_CUSTOM_CODE'  ,'');
                        orderNoSearch.setValue('ADD13_CUSTOM_CODE'  ,'');
                        orderNoSearch.setValue('ADD14_CUSTOM_CODE'  ,'');
                        orderNoSearch.setValue('ADD15_CUSTOM_CODE'  ,'');
                        orderNoSearch.setValue('ADD16_CUSTOM_CODE'  ,'');
                        orderNoSearch.setValue('ADD17_CUSTOM_CODE'  ,'');
                        orderNoSearch.setValue('ADD18_CUSTOM_CODE'  ,'');
                        orderNoSearch.setValue('ADD19_CUSTOM_CODE'  ,'');
                        orderNoSearch.setValue('ADD20_CUSTOM_CODE'  ,'');
                        orderNoSearch.setValue('ADD21_CUSTOM_CODE'  ,'');
                        orderNoSearch.setValue('ADD22_CUSTOM_CODE'  ,'');
                        orderNoSearch.setValue('CUSTOM_NAME01'      ,'');
                        orderNoSearch.setValue('CUSTOM_NAME02'      ,'');
                        orderNoSearch.setValue('CUSTOM_NAME03'      ,'');
                        orderNoSearch.setValue('CUSTOM_NAME04'      ,'');
                        orderNoSearch.setValue('CUSTOM_NAME05'      ,'');
                        orderNoSearch.setValue('CUSTOM_NAME06'      ,'');
                        orderNoSearch.setValue('CUSTOM_NAME07'      ,'');
                        orderNoSearch.setValue('CUSTOM_NAME08'      ,'');
                        orderNoSearch.setValue('CUSTOM_NAME09'      ,'');
                        orderNoSearch.setValue('CUSTOM_NAME10'      ,'');
                        orderNoSearch.setValue('CUSTOM_NAME11'      ,'');
                        orderNoSearch.setValue('CUSTOM_NAME12'      ,'');
                        orderNoSearch.setValue('CUSTOM_NAME13'      ,'');
                        orderNoSearch.setValue('CUSTOM_NAME14'      ,'');
                        orderNoSearch.setValue('CUSTOM_NAME15'      ,'');
                        orderNoSearch.setValue('CUSTOM_NAME16'      ,'');
                        orderNoSearch.setValue('CUSTOM_NAME17'      ,'');
                        orderNoSearch.setValue('CUSTOM_NAME18'      ,'');
                        orderNoSearch.setValue('CUSTOM_NAME19'      ,'');
                        orderNoSearch.setValue('CUSTOM_NAME20'      ,'');
                        orderNoSearch.setValue('CUSTOM_NAME21'      ,'');
                        orderNoSearch.setValue('CUSTOM_NAME22'      ,'');
                        //orderNoSearch.clearForm();
                    },
                    beforeshow: function( panel, eOpts )    {
                    	var record = masterGrid.getSelectedRecord();
                    	if(record == null){
                    		alert('데이터를 선택해주세요');
                    		return false;
                    	}else{
                            if(!Ext.isEmpty(record.data.CAR_TYPE2)){
                                orderNoSearch.setValue('CAR_TYPE'           ,record.data.CAR_TYPE2);
                            }
                            else
                            {
                                orderNoSearch.setValue('CAR_TYPE'           ,record.data.NEW_CAR_TYPE);
                            }
                    	orderNoSearch.setValue('P_REQ_NUM'          ,record.data.P_REQ_NUM);
                        orderNoSearch.setValue('SER_NO'             ,record.data.SER_NO);
                        orderNoSearch.setValue('NEW_ITEM_FREFIX'    ,record.data.NEW_ITEM_FREFIX);
                        orderNoSearch.setValue('ITEM_CODE'          ,record.data.ITEM_CODE);
                        orderNoSearch.setValue('ITEM_NAME'          ,record.data.ITEM_NAME2);
                        orderNoSearch.setValue('SPEC'               ,record.data.SPEC2);
                        orderNoSearch.setValue('OEM_ITEM_CODE'      ,record.data.OEM_ITEM_CODE);
                        orderNoSearch.setValue('STOCK_UNIT'         ,record.data.STOCK_UNIT2);
                        orderNoSearch.setValue('CUSTOM_CODE'        ,record.data.CUSTOM_CODE);
                        orderNoSearch.setValue('CUSTOM_NAME'        ,record.data.CUSTOM_NAME2);
                        orderNoSearch.setValue('CUSTOM_FULL_NAME'   ,record.data.CUSTOM_FULL_NAME2);
                        orderNoSearch.setValue('ADD01_CUSTOM_CODE'  ,record.data.ADD01_CUSTOM_CODE);
                        orderNoSearch.setValue('ADD02_CUSTOM_CODE'  ,record.data.ADD02_CUSTOM_CODE);
                        orderNoSearch.setValue('ADD03_CUSTOM_CODE'  ,record.data.ADD03_CUSTOM_CODE);
                        orderNoSearch.setValue('ADD04_CUSTOM_CODE'  ,record.data.ADD04_CUSTOM_CODE);
                        orderNoSearch.setValue('ADD05_CUSTOM_CODE'  ,record.data.ADD05_CUSTOM_CODE);
                        orderNoSearch.setValue('ADD06_CUSTOM_CODE'  ,record.data.ADD06_CUSTOM_CODE);
                        orderNoSearch.setValue('ADD07_CUSTOM_CODE'  ,record.data.ADD07_CUSTOM_CODE);
                        orderNoSearch.setValue('ADD08_CUSTOM_CODE'  ,record.data.ADD08_CUSTOM_CODE);
                        orderNoSearch.setValue('ADD09_CUSTOM_CODE'  ,record.data.ADD09_CUSTOM_CODE);
                        orderNoSearch.setValue('ADD10_CUSTOM_CODE'  ,record.data.ADD10_CUSTOM_CODE);
                        orderNoSearch.setValue('ADD11_CUSTOM_CODE'  ,record.data.ADD11_CUSTOM_CODE);
                        orderNoSearch.setValue('ADD12_CUSTOM_CODE'  ,record.data.ADD12_CUSTOM_CODE);
                        orderNoSearch.setValue('ADD13_CUSTOM_CODE'  ,record.data.ADD13_CUSTOM_CODE);
                        orderNoSearch.setValue('ADD14_CUSTOM_CODE'  ,record.data.ADD14_CUSTOM_CODE);
                        orderNoSearch.setValue('ADD15_CUSTOM_CODE'  ,record.data.ADD15_CUSTOM_CODE);
                        orderNoSearch.setValue('ADD16_CUSTOM_CODE'  ,record.data.ADD16_CUSTOM_CODE);
                        orderNoSearch.setValue('ADD17_CUSTOM_CODE'  ,record.data.ADD17_CUSTOM_CODE);
                        orderNoSearch.setValue('ADD18_CUSTOM_CODE'  ,record.data.ADD18_CUSTOM_CODE);
                        orderNoSearch.setValue('ADD19_CUSTOM_CODE'  ,record.data.ADD19_CUSTOM_CODE);
                        orderNoSearch.setValue('ADD20_CUSTOM_CODE'  ,record.data.ADD20_CUSTOM_CODE);
                        orderNoSearch.setValue('ADD21_CUSTOM_CODE'  ,record.data.ADD21_CUSTOM_CODE);
                        orderNoSearch.setValue('ADD22_CUSTOM_CODE'  ,record.data.ADD22_CUSTOM_CODE);
                        orderNoSearch.setValue('CUSTOM_NAME01'      ,record.data.ADD01_CUSTOM_NAME);
                        orderNoSearch.setValue('CUSTOM_NAME02'      ,record.data.ADD02_CUSTOM_NAME);
                        orderNoSearch.setValue('CUSTOM_NAME03'      ,record.data.ADD03_CUSTOM_NAME);
                        orderNoSearch.setValue('CUSTOM_NAME04'      ,record.data.ADD04_CUSTOM_NAME);
                        orderNoSearch.setValue('CUSTOM_NAME05'      ,record.data.ADD05_CUSTOM_NAME);
                        orderNoSearch.setValue('CUSTOM_NAME06'      ,record.data.ADD06_CUSTOM_NAME);
                        orderNoSearch.setValue('CUSTOM_NAME07'      ,record.data.ADD07_CUSTOM_NAME);
                        orderNoSearch.setValue('CUSTOM_NAME08'      ,record.data.ADD08_CUSTOM_NAME);
                        orderNoSearch.setValue('CUSTOM_NAME09'      ,record.data.ADD09_CUSTOM_NAME);
                        orderNoSearch.setValue('CUSTOM_NAME10'      ,record.data.ADD10_CUSTOM_NAME);
                        orderNoSearch.setValue('CUSTOM_NAME11'      ,record.data.ADD11_CUSTOM_NAME);
                        orderNoSearch.setValue('CUSTOM_NAME12'      ,record.data.ADD12_CUSTOM_NAME);
                        orderNoSearch.setValue('CUSTOM_NAME13'      ,record.data.ADD13_CUSTOM_NAME);
                        orderNoSearch.setValue('CUSTOM_NAME14'      ,record.data.ADD14_CUSTOM_NAME);
                        orderNoSearch.setValue('CUSTOM_NAME15'      ,record.data.ADD15_CUSTOM_NAME);
                        orderNoSearch.setValue('CUSTOM_NAME16'      ,record.data.ADD16_CUSTOM_NAME);
                        orderNoSearch.setValue('CUSTOM_NAME17'      ,record.data.ADD17_CUSTOM_NAME);
                        orderNoSearch.setValue('CUSTOM_NAME18'      ,record.data.ADD18_CUSTOM_NAME);
                        orderNoSearch.setValue('CUSTOM_NAME19'      ,record.data.ADD19_CUSTOM_NAME);
                        orderNoSearch.setValue('CUSTOM_NAME20'      ,record.data.ADD20_CUSTOM_NAME);
                        orderNoSearch.setValue('CUSTOM_NAME21'      ,record.data.ADD21_CUSTOM_NAME);
                        orderNoSearch.setValue('CUSTOM_NAME22'      ,record.data.ADD22_CUSTOM_NAME);
                    }
                   }
                }
            })
        }
        SearchInfoWindow.center();
        SearchInfoWindow.show();
    }

    var orderNoSearch = Unilite.createSearchForm('otherorderForm', {         // 추가정보 팝업창
        layout: {type : 'uniTable', columns : 3},
        height: 580,
        masterGrid: masterGrid,
        items:[
            {
                fieldLabel: '의뢰번호',
                name:'P_REQ_NUM',
                xtype: 'uniTextfield',
                readOnly: true
            },{
                fieldLabel: '의뢰순번',
                name:'SER_NO',
                xtype: 'uniTextfield',
                readOnly: true,
                colspan: 2
            },{
        		xtype:'displayfield',
                hideLabel:true,
                value:'<div style="color:blue;font-weight:bold;padding-left:5px;">[신규물품정보]</div>',
                colspan: 3
            },{
                xtype: 'container',
                layout: {type: 'uniTable', columns: 2},
                items: [{
                        fieldLabel: '품목코드',
                        name:'NEW_ITEM_FREFIX',
                        readOnly: true,
                        xtype: 'uniTextfield'
                    }
                ]
            },{
                xtype: 'container',
                layout: {type: 'uniTable', columns: 1},
                items: [{
                        fieldLabel: '품목명',
                        readOnly: true,
                        name:'ITEM_NAME',
                        xtype: 'uniTextfield'
                    }
                ]
            },{
                fieldLabel: '규격',
                xtype: 'uniTextfield',
                readOnly: true,
                name: 'SPEC',
                width: 330,
                colspan: 1
            },{
                name: 'CAR_TYPE',
                fieldLabel: '차종',
                readOnly: true,
                xtype:'uniTextfield'
            },{
                name: 'STOCK_UNIT',
                fieldLabel: '재고단위',
                readOnly: true,
                xtype:'uniCombobox',
                comboType:'AU',
                comboCode:'B013',
                displayField: 'value',
                colspan: 2
            },
//            	{
//                fieldLabel: 'PartNum코드',
//                xtype: 'uniTextfield',
//                name: 'OEM_ITEM_CODE',
//                readOnly: true,
//                colspan: 1
//            },
            	{
                xtype:'displayfield',
                hideLabel:true,
                value:'<div style="color:blue;font-weight:bold;padding-left:5px;">[신규업체정보]</div>',
                colspan: 3
            },{
                xtype: 'container',
                layout: {type: 'uniTable', columns: 1},
                items: [{
                        fieldLabel: '거래처약명',
                        name:'CUSTOM_NAME',
                        readOnly: true,
                        xtype: 'uniTextfield'
                    }
                ]
            },{
                fieldLabel: '거래처전명',
                readOnly: true,
                xtype: 'uniTextfield',
                width: 650,
                name: 'CUSTOM_FULL_NAME',
                colspan: 2
            },{
                xtype:'displayfield',
                hideLabel:true,
                value:'<div style="color:blue;font-weight:bold;padding-left:5px;">[추가업체정보]</div>',
                colspan: 3
            },
            Unilite.popup('CUST',{
                fieldLabel:'거래처01',
                readOnly: true,
                valueFieldName: 'ADD01_CUSTOM_CODE',
                textFieldName: 'CUSTOM_NAME01'
            }),
            Unilite.popup('CUST',{
                fieldLabel:'거래처02',
                readOnly: true,
                valueFieldName: 'ADD02_CUSTOM_CODE',
                textFieldName: 'CUSTOM_NAME02'
            }),
            Unilite.popup('CUST',{
                fieldLabel:'거래처03',
                readOnly: true,
                valueFieldName: 'ADD03_CUSTOM_CODE',
                textFieldName: 'CUSTOM_NAME03'
            }),
            Unilite.popup('CUST',{
                fieldLabel:'거래처04',
                readOnly: true,
                valueFieldName: 'ADD04_CUSTOM_CODE',
                textFieldName: 'CUSTOM_NAME04'
            }),
            Unilite.popup('CUST',{
                fieldLabel:'거래처05',
                readOnly: true,
                valueFieldName: 'ADD05_CUSTOM_CODE',
                textFieldName: 'CUSTOM_NAME05'
            }),
            Unilite.popup('CUST',{
                fieldLabel:'거래처06',
                readOnly: true,
                valueFieldName: 'ADD06_CUSTOM_CODE',
                textFieldName: 'CUSTOM_NAME06'
            }),
            Unilite.popup('CUST',{
                fieldLabel:'거래처07',
                readOnly: true,
                valueFieldName: 'ADD07_CUSTOM_CODE',
                textFieldName: 'CUSTOM_NAME07'
            }),
            Unilite.popup('CUST',{
                fieldLabel:'거래처08',
                readOnly: true,
                valueFieldName: 'ADD08_CUSTOM_CODE',
                textFieldName: 'CUSTOM_NAME08'
            }),
            Unilite.popup('CUST',{
                fieldLabel:'거래처09',
                readOnly: true,
                valueFieldName: 'ADD09_CUSTOM_CODE',
                textFieldName: 'CUSTOM_NAME09'
            }),
            Unilite.popup('CUST',{
                fieldLabel:'거래처10',
                readOnly: true,
                valueFieldName: 'ADD10_CUSTOM_CODE',
                textFieldName: 'CUSTOM_NAME10'
            }),
            Unilite.popup('CUST',{
                fieldLabel:'거래처11',
                readOnly: true,
                valueFieldName: 'ADD11_CUSTOM_CODE',
                textFieldName: 'CUSTOM_NAME11'
            }),
            Unilite.popup('CUST',{
                fieldLabel:'거래처12',
                readOnly: true,
                valueFieldName: 'ADD12_CUSTOM_CODE',
                textFieldName: 'CUSTOM_NAME12'
            }),
            Unilite.popup('CUST',{
                fieldLabel:'거래처13',
                readOnly: true,
                valueFieldName: 'ADD13_CUSTOM_CODE',
                textFieldName: 'CUSTOM_NAME13'
            }),
            Unilite.popup('CUST',{
                fieldLabel:'거래처14',
                readOnly: true,
                valueFieldName: 'ADD14_CUSTOM_CODE',
                textFieldName: 'CUSTOM_NAME14'
            }),
            Unilite.popup('CUST',{
                fieldLabel:'거래처15',
                readOnly: true,
                valueFieldName: 'ADD15_CUSTOM_CODE',
                textFieldName: 'CUSTOM_NAME15'
            }),
            Unilite.popup('CUST',{
                fieldLabel:'거래처16',
                readOnly: true,
                valueFieldName: 'ADD16_CUSTOM_CODE',
                textFieldName: 'CUSTOM_NAME16'
            }),
            Unilite.popup('CUST',{
                fieldLabel:'거래처17',
                readOnly: true,
                valueFieldName: 'ADD17_CUSTOM_CODE',
                textFieldName: 'CUSTOM_NAME17'
            }),
            Unilite.popup('CUST',{
                fieldLabel:'거래처18',
                readOnly: true,
                valueFieldName: 'ADD18_CUSTOM_CODE',
                textFieldName: 'CUSTOM_NAME18'
            }),
            Unilite.popup('CUST',{
                fieldLabel:'거래처19',
                readOnly: true,
                valueFieldName: 'ADD19_CUSTOM_CODE',
                textFieldName: 'CUSTOM_NAME19'
            }),
            Unilite.popup('CUST',{
                fieldLabel:'거래처20',
                readOnly: true,
                valueFieldName: 'ADD20_CUSTOM_CODE',
                textFieldName: 'CUSTOM_NAME20'
            }),
             Unilite.popup('CUST',{
                fieldLabel:'거래처21',
                readOnly: true,
                valueFieldName: 'ADD21_CUSTOM_CODE',
                textFieldName: 'CUSTOM_NAME21'
            }),
            Unilite.popup('CUST',{
                fieldLabel:'거래처22',
                readOnly: true,
                valueFieldName: 'ADD22_CUSTOM_CODE',
                textFieldName: 'CUSTOM_NAME22'
            })
        ]/*,
        loadForm: function(record)  {
            // window 오픈시 form에 Data load
            var count = masterGrid.getStore().getCount();
            if(count > 0) {
                this.reset();
                this.setActiveRecord(record[0] || null);
                this.resetDirtyStatus();
            }
        }*/
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
        id: 's_bco100skrv_kdApp',
        fnInitBinding: function() {
            UniAppManager.setToolbarButtons(['reset', 'save'],false);
            panelSearch.setValue('DIV_CODE', UserInfo.divCode);
            panelSearch.setValue('TYPE', '1');
            panelSearch.setValue('MONEY_UNIT', BsaCodeInfo.gsMoneyUnit);
            panelSearch.setValue('P_REQ_DATE_FR', UniDate.get('startOfMonth'));
            panelSearch.setValue('P_REQ_DATE_TO', UniDate.get('today'));
            panelSearch.setValue('APLY_START_DATE_FR', UniDate.get('startOfMonth'));
            panelSearch.setValue('APLY_START_DATE_TO', UniDate.get('today'));
            panelResult.setValue('P_REQ_DATE_FR', UniDate.get('startOfMonth'));
            panelResult.setValue('P_REQ_DATE_TO', UniDate.get('today'));
            panelResult.setValue('APLY_START_DATE_FR', UniDate.get('startOfMonth'));
            panelResult.setValue('APLY_START_DATE_TO', UniDate.get('today'));
        },
        onQueryButtonDown: function() {
//            if(panelSearch.setAllFieldsReadOnly(true) == false){
//                return false;
//            }
//            if(panelResult.setAllFieldsReadOnly(true) == false){
//                return false;
//            }
            masterGrid.getStore().loadStoreRecords();
            UniAppManager.setToolbarButtons(['reset'],true);
        },
        setDefault: function() {        // 기본값
            panelSearch.setValue('DIV_CODE',UserInfo.divCode);
            panelSearch.setValue('TYPE', '1');
            panelSearch.setValue('MONEY_UNIT', BsaCodeInfo.gsMoneyUnit);
            panelSearch.setValue('P_REQ_DATE_FR', UniDate.get('startOfMonth'));
            panelSearch.setValue('P_REQ_DATE_TO', UniDate.get('today'));
            panelSearch.setValue('APLY_START_DATE_FR', UniDate.get('startOfMonth'));
            panelSearch.setValue('APLY_START_DATE_TO', UniDate.get('today'));
            panelResult.setValue('P_REQ_DATE_FR', UniDate.get('startOfMonth'));
            panelResult.setValue('P_REQ_DATE_TO', UniDate.get('today'));
            panelResult.setValue('APLY_START_DATE_FR', UniDate.get('startOfMonth'));
            panelResult.setValue('APLY_START_DATE_TO', UniDate.get('today'));
            panelSearch.getForm().wasDirty = false;
            panelSearch.resetDirtyStatus();
            UniAppManager.setToolbarButtons('save', false);
        },
        onResetButtonDown: function() {     // 초기화
            this.suspendEvents();
            UniAppManager.setToolbarButtons('save', false);
            panelSearch.clearForm();
            panelResult.clearForm();
            panelSearch.setAllFieldsReadOnly(false);
            panelResult.setAllFieldsReadOnly(false);
            panelSearch.setValue('DIV_CODE',UserInfo.divCode);
            panelSearch.setValue('TYPE', '1');
            panelSearch.setValue('P_REQ_DATE_FR', UniDate.get('startOfMonth'));
            panelSearch.setValue('P_REQ_DATE_TO', UniDate.get('today'));
            panelResult.setValue('P_REQ_DATE_FR', UniDate.get('startOfMonth'));
            panelResult.setValue('P_REQ_DATE_TO', UniDate.get('today'));
            masterGrid.reset();
            this.fnInitBinding();
            directMasterStore1.clearData();
        },
        requestApprove2: function(record){     // VIEW
            var gsWin = window.open('about:blank','payviewer','width=500,height=500');

            var frm         = document.f1;
            var compCode    = UserInfo.compCode;
            var divCode     = panelResult.getValue('DIV_CODE');
            var pReqNum  = panelResult.getValue('P_REQ_NUM');
            //var spText      = 'EXEC omegaplus_kdg.unilite.USP_GW_BTR101UKRV ' + "'" + compCode + "'" + ', ' + "'" + divCode + "'" + ', ' + "'" + reqStcoNum + "'";
           // var spCall      = encodeURIComponent(spText);

            frm.action   = groupUrl + "appr_id=" + record.data.GW_DOC + "&viewMode=docuView";
            frm.target   = "payviewer";
            frm.method   = "post";
            frm.submit();
        }
    });
};

function typeChk(sType) {           //매입,의뢰서구분 관련 체크 로직

	var records = Ext.data.StoreManager.lookup('WB22List').data.items;
	var sValue = [];
	var defaultValue1 = '';
	var defaultValue2 = '';
	var rtnVal =  new Array();
	Ext.each(records, function(item, i){
		if(sType == '1'){
			if(item.get("refCode1") == '1'){
				sValue.push(item.get("value"));
			}
		}else{
			if(item.get("refCode1") == '2'){
				sValue.push(item.get("value"));
			}
		}

		if(item.get("refCode2") == '1' ){
			defaultValue1 = item.get("value");
		}
		if(item.get("refCode2") == '2' ){
			defaultValue2 = item.get("value");
		}
	})

	rtnVal[0] = sValue;
	rtnVal[1] = defaultValue1;
	rtnVal[2] = defaultValue2;

	return rtnVal ;
}
</script>
<form id="f1" name="f1" action="" method="post" onSubmit="return false;" >
<input type="hidden" id="loginid" name="loginid" value="superadmin" />
<input type="hidden" id="fmpf" name="fmpf" value="" />
<input type="hidden" id="fmbd" name="fmbd" runat="server" />
</form>