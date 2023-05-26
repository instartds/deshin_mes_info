<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_bco110ukrv_kd" >
    <t:ExtComboStore comboType="BOR120" pgmId="s_bco110ukrv_kd"/>   <!-- 사업장 -->
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
var SearchInfoWindow; // 추가정보창
var gvRowIndex = '';
function appMain() {
    var isAutoOrderNum = false;
    if(BsaCodeInfo.gsAutoType=='Y') {
        isAutoOrderNum = true;
    }


    /**
     *   Model 정의
     * @type
     */
    var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 's_bco110ukrv_kdService.selectList',
            update: 's_bco110ukrv_kdService.updateDetail',
            //create: 's_bco110ukrv_kdService.insertDetail',
            //destroy: 's_bco110ukrv_kdService.deleteDetail',
            syncAll: 's_bco110ukrv_kdService.saveAll'
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
                holdable: 'hold',
                xtype: 'uniCombobox',
                comboType: 'BOR120',
                allowBlank:false,
                holdable: 'hold',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('DIV_CODE', newValue);
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
            {
                fieldLabel: '의뢰번호',
                xtype:'uniTextfield',
                name: 'P_REQ_NUM',
                listeners:{
    				change:function(field, newValue, oldValue) {
    					 panelResult.setValue('P_REQ_NUM', newValue);
    				}
                }
            },{
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
            }, Unilite.popup('Employee',{
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
            })]
        },{
            fieldLabel: 'TEMP',
            name:'WINDOW_DATA',
            xtype: 'uniTextfield',
            hidden: true
        },{fieldLabel: '조회구분',
			id		  : 'rdoSelect0',
			allowBlank:true,
			xtype: 'uniRadiogroup',
			items: [{
				boxLabel: '단가입력의뢰',
				width: 90,
				name: 'QUERY_TYPE',
				inputValue: '1',
				checked: true
			}, {
				boxLabel: '최종단가대비수출가',
				width: 130,
				name: 'QUERY_TYPE',
				inputValue: '2'
			}] ,
			listeners: {
					change: function(field, newValue, oldValue, eOpts) {

						panelResult.getField('QUERY_TYPE').setValue(newValue.QUERY_TYPE);

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
    					panelSearch.setValue('P_REQ_NUM', newValue);
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
            }),{fieldLabel: '조회구분',
			id		  : 'rdoSelect1',
			allowBlank:true,
			xtype: 'uniRadiogroup',
			vertical: false,
			items: [{
				boxLabel: '단가입력의뢰',
				width: 90,
				name: 'QUERY_TYPE',
				inputValue: '1',
				checked: true
			}, {
				boxLabel: '최종단가대비수출가',
				width: 130,
				name: 'QUERY_TYPE',
				inputValue: '2'
			}] ,
			listeners: {
					change: function(field, newValue, oldValue, eOpts) {

						panelSearch.getField('QUERY_TYPE').setValue(newValue.QUERY_TYPE);

		        	}
				}
			} ,
            {
                fieldLabel: '구분',
                name:'TYPE',
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'A003',
                value:'1',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelSearch.setValue('TYPE', newValue);
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

    var reqNumSearch = Unilite.createSearchForm('reqNumSearchForm', {     // 검색 팝업창
        layout: {type: 'uniTable', columns : 2},
        trackResetOnLoad: true,
        items: [{
                fieldLabel: '사업장',
                name: 'DIV_CODE',
                holdable: 'hold',
                xtype: 'uniCombobox',
                comboType: 'BOR120',
                allowBlank:false
            },{
                fieldLabel: '의뢰일자',
                startFieldName: 'P_REQ_DATE_FR',
                endFieldName: 'P_REQ_DATE_TO',
                xtype: 'uniDateRangefield',
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today'),
                allowBlank:false
            },
            Unilite.popup('DEPT', {
                    fieldLabel: '부서',
                    valueFieldName: 'TREE_CODE',
                    textFieldName: 'DEPT_NAME'
            }),{
                fieldLabel: '구분',
                name:'TYPE',
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'A003'
            },{
                fieldLabel: '적용일자',
                startFieldName: 'APLY_START_DATE_FR',
                endFieldName: 'APLY_START_DATE_TO',
                xtype: 'uniDateRangefield',
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today')
            },
            Unilite.popup('Employee',{
                    fieldLabel: '담당자',
                    valueFieldName:'PERSON_NUMB',
                    textFieldName:'PERSON_NAME'
            }),{
                fieldLabel: '의뢰번호',
                xtype:'uniTextfield',
                name: 'P_REQ_NUM'
            }
        ]
    }); // createSearchForm

    Unilite.defineModel('s_bco110ukrv_kdModel', {        // 메인1
        fields: [
            {name: 'CONFIRM_YN_CHECK'       , text: '확정'                         , type: 'boolean'},
            {name: 'P_REQ_NUM'              , text: '의뢰번호'			           , type: 'string', allowBlank: isAutoOrderNum},
            {name: 'SER_NO'                 , text: '의뢰순번'                     , type: 'int'},
            {name: 'COMP_CODE'              , text: '법인코드'				       , type: 'string'},
            {name: 'DIV_CODE'               , text: '사업장'				       , type: 'string'},
            {name: 'TREE_CODE'              , text: '부서코드'				       , type: 'string'},
            {name: 'TREE_NAME'              , text: '부서명'                       , type: 'string'},
            {name: 'PERSON_NUMB'            , text: '사원코드'				       , type: 'string'},
            {name: 'PERSON_NAME'            , text: '사원명'                       , type: 'string'},
            {name: 'TYPE'                   , text: '구분'                         , type: 'string', comboType:'AU', comboCode:'A003'},
            {name: 'MONEY_UNIT'             , text: '화폐단위'				       , type: 'string', comboType:'AU', comboCode:'B004', displayField: 'value'},
            {name: 'P_REQ_DATE'             , text: '의뢰일'				       , type: 'uniDate'},
            {name: 'APLY_START_DATE'        , text: '적용일'				       , type: 'uniDate'},
            {name: 'GW_FLAG'                , text: '기안'				       , type: 'string', comboType:'AU', comboCode:'WB17'},
            {name: 'CUSTOM_CODE'            , text: '거래처코드'			       , type: 'string', allowBlank: true},
            {name: 'CUSTOM_NAME'            , text: '거래처명'				       , type: 'string', allowBlank: true},
            {name: 'PACK_ITEM_P'            , text: '포장단가'				       , type: 'uniUnitPrice'},
            {name: 'PRE_ITEM_P'             , text: '이전단가'				       , type: 'uniUnitPrice'},
			//20191216 추가
			{name: 'DIFFER_UNIT_P'			, text: '단가차액'		, type: 'uniUnitPrice'},
            {name: 'HS_CODE'                , text: 'HS번호'				       , type: 'string'},
            {name: 'HS_NAME'                , text: 'HS명'                         , type: 'string'},
            {name: 'PAY_TERMS'              , text: '결제조건'				       , type: 'string', comboType:'AU', comboCode:'B034'},
            {name: 'TERMS_PRICE'            , text: '가격조건'				       , type: 'string', comboType:'AU', comboCode:'T005'},
            {name: 'DELIVERY_METH'          , text: '운송방법'				       , type: 'string', comboType:'AU', comboCode:'WB01'},
            {name: 'CH_REASON'              , text: '단가변동사유'				       , type: 'string', comboType:'AU', comboCode:'WB03'},
            {name: 'MAKER_CODE'             , text: '제조처코드'                   , type: 'string'},
            {name: 'MAKER_NAME'             , text: '제조처명'                     , type: 'string'},
            {name: 'NEW_ITEM_FREFIX'        , text: '신규품목코드'                 , type: 'string'},
            {name: 'ITEM_CODE'              , text: '품목코드'				       , type: 'string', allowBlank: true},
            {name: 'ITEM_NAME'              , text: '품목명'				       , type: 'string', allowBlank: true},
            {name: 'PRICE_TYPE1'            , text: '단가구분'				       , type: 'string', /*allowBlank: priceType2,*/ comboType:'AU', comboCode:'S003'}, // 검색조건의 구분이 매입: S003, 매출: M301
            {name: 'PRICE_TYPE2'            , text: '단가구분'                     , type: 'string', /*allowBlank: priceType1,*/ comboType:'AU', comboCode:'M301'}, // 검색조건의 구분이 매입: S003, 매출: M301
            {name: 'PRICE_TYPE'        	  , text: '단가구분'                 , type: 'string'},
            {name: 'ORDER_UNIT'             , text: '단위'					       , type: 'string', comboType:'AU', comboCode:'B013', displayField: 'value'},
            {name: 'ITEM_P'                 , text: '단가'					       , type: 'uniUnitPrice'},
            {name: 'OEM_APLY_YN'            , text: 'OEM적용여부'                  , type: 'string', comboType:'AU', comboCode:'B010'},
            {name: 'OEM_YN'                 , text: 'OEM'                          , type: 'boolean'},
            {name: '12199_YN'               , text: '시중'                            , type: 'boolean'},
            {name: '13199_YN'               , text: '수출'                            , type: 'boolean'},
            {name: '14199_YN'               , text: '대리점'                      , type: 'boolean'},
            {name: '13301_YN'               , text: '청도'                           , type: 'boolean'},
            {name: 'OEM_YN1'                 , text: 'OEMtest'                          , type: 'string'},
			{name: 'colume1'               , text: '시중test'                            , type: 'boolean'},
			{name: 'colume2'               , text: '수출test'                            , type: 'boolean'},
			{name: 'colume3'               , text: '대리점test'                      , type: 'boolean'},
			{name: 'colume4'               , text: '청도test'                           , type: 'boolean' },
            {name: 'OEM_ITEM_CODE'          , text: '품번'				           , type: 'string'},
            {name: 'SPEC'                   , text: '규격/품번'					       , type: 'string'},
            {name: 'CAR_TYPE'               , text: '차종'					       , type: 'string', comboType:'AU', comboCode:'WB04'},
            {name: 'STOCK_UNIT'             , text: '재고단위'				       , type: 'string'},
            {name: 'CUSTOM_FULL_NAME'       , text: '거래처명'				       , type: 'string'},
            {name: 'ADD01_CUSTOM_CODE'      , text: '거래처1'				       , type: 'string'},
            {name: 'ADD02_CUSTOM_CODE'      , text: '거래처2'				       , type: 'string'},
            {name: 'ADD03_CUSTOM_CODE'      , text: '거래처3'				       , type: 'string'},
            {name: 'ADD04_CUSTOM_CODE'      , text: '거래처4'				       , type: 'string'},
            {name: 'ADD05_CUSTOM_CODE'      , text: '거래처5'				       , type: 'string'},
            {name: 'ADD06_CUSTOM_CODE'      , text: '거래처6'				       , type: 'string'},
            {name: 'ADD07_CUSTOM_CODE'      , text: '거래처7'				       , type: 'string'},
            {name: 'ADD08_CUSTOM_CODE'      , text: '거래처8'				       , type: 'string'},
            {name: 'ADD09_CUSTOM_CODE'      , text: '거래처9'				       , type: 'string'},
            {name: 'ADD10_CUSTOM_CODE'      , text: '거래처10'				       , type: 'string'},
            {name: 'ADD11_CUSTOM_CODE'      , text: '거래처11'				       , type: 'string'},
            {name: 'ADD12_CUSTOM_CODE'      , text: '거래처12'				       , type: 'string'},
            {name: 'ADD13_CUSTOM_CODE'      , text: '거래처13'				       , type: 'string'},
            {name: 'ADD14_CUSTOM_CODE'      , text: '거래처14'				       , type: 'string'},
            {name: 'ADD15_CUSTOM_CODE'      , text: '거래처15'				       , type: 'string'},
            {name: 'ADD16_CUSTOM_CODE'      , text: '거래처16'				       , type: 'string'},
            {name: 'ADD17_CUSTOM_CODE'      , text: '거래처17'				       , type: 'string'},
            {name: 'ADD18_CUSTOM_CODE'      , text: '거래처18'				       , type: 'string'},
            {name: 'ADD19_CUSTOM_CODE'      , text: '거래처19'				       , type: 'string'},
            {name: 'ADD20_CUSTOM_CODE'      , text: '거래처20'				       , type: 'string'},
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
            {name: 'REMARK'                 , text: '비고'					       , type: 'string'},
            {name: 'RENEWAL_YN'             , text: '갱신'                     , type: 'string', comboType:'AU', comboCode:'B010'},
            {name: 'CONFIRM_YN'             , text: '확정'                     , type: 'string', comboType:'AU', comboCode:'B010'},
            {name: 'INSERT_DB_USER'         , text: '입력ID'				       , type: 'string'},
            {name: 'INSERT_DB_TIME'         , text: '입력일'				       , type: 'uniDate'},
            {name: 'UPDATE_DB_USER'         , text: '수정ID'				       , type: 'string'},
            {name: 'UPDATE_DB_TIME'         , text: '수정일'				       , type: 'uniDate'},
            {name: 'TEMPC_01'               , text: '여유컬럼'                     , type: 'string'},
            {name: 'TEMPC_02'               , text: '여유컬럼'                     , type: 'string'},
            {name: 'TEMPC_03'               , text: '여유컬럼'                     , type: 'string'},
            {name: 'TEMPN_01'               , text: '여유컬럼'                     , type: 'string'},
            {name: 'TEMPN_02'               , text: '여유컬럼'                     , type: 'string'},
            {name: 'TEMPN_03'               , text: '여유컬럼'                     , type: 'string'},
            {name: 'QUERY'                  , text: 'QUERY'                        , type: 'string'},
            {name: 'NS_FLAG'                , text: '내수구분'                     , type: 'string', comboType:'AU', comboCode:'WB18'},
            {name: 'PRE_ITEM_P'             , text: '종전단가'				       , type: 'uniUnitPrice'},
            {name: 'SPEC2'             , text: '신규규격'                     , type: 'string'},
            {name: 'STOCK_UNIT2'             , text: '신규단위'                     , type: 'string'},
            {name: 'NEW_CAR_TYPE'             , text: '신규차종2'                     , type: 'string'},
            {name: 'P_REQ_TYPE'             , text: '의뢰서구분'                   , type: 'string', comboType:'AU', comboCode:'WB22'},
            {name: 'QUERY_TYPE'             , text: '조회구분'                     , type: 'string'},
            {name: 'CUSTOM_NAME2'             , text: '거래처명'                   , type: 'string'},
            {name: 'CUSTOM_FULL_NAME2'     , text: '거래처전명'                     , type: 'string'}
        ]
    });//End of Unilite.defineModel('s_bco110ukrv_kdModel', {

    Unilite.defineModel('s_bco110ukrv_kdModel2', {  // 검색 팝업창
        fields: [
         	 {name: 'P_REQ_NUM'         ,text:'의뢰번호'      ,type:'string'}
            ,{name: 'P_REQ_DATE'        ,text:'의뢰일자'      ,type:'uniDate'}
            ,{name: 'APLY_START_DATE'   ,text:'적용일자'      ,type:'uniDate'}
            ,{name: 'TYPE'              ,text:'구분'          ,type:'string', comboType:'AU', comboCode:'A003'}
            ,{name: 'TREE_CODE'         ,text:'부서코드'      ,type:'string'}
            ,{name: 'TREE_NAME'         ,text:'부서명'        ,type:'string'}
            ,{name: 'PERSON_NUMB'       ,text:'사원번호'      ,type:'string'}
            ,{name: 'PERSON_NAME'       ,text:'사원명'        ,type:'string'}
            ,{name: 'MONEY_UNIT'        ,text:'화폐'          ,type:'string'}
            ,{name: 'DIV_CODE'          ,text:'사업장'        ,type:'string'}
            ,{name: 'GW_FLAG'          ,text:'기안'      ,type:'string', comboType:'AU', comboCode:'WB17'}
            ,{name: 'CONFIRM_YN'        ,text:'확정'      ,type:'string', comboType:'AU', comboCode:'B010'}
        ]
    });

    /**
     * Store 정의(Service 정의)
     * @type
     */
    var directMasterStore1 = Unilite.createStore('s_bco110ukrv_kdMasterStore1', {
            model: 's_bco110ukrv_kdModel',
            autoLoad: false,
            uniOpt : {
                isMaster: true,         // 상위 버튼 연결
                editable: true,         // 수정 모드 사용
                deletable:false,        // 삭제 가능 여부
                useNavi : false         // prev | newxt 버튼 사용
            },
            proxy: directProxy,
            loadStoreRecords : function()  {
            	if(!Ext.isEmpty(panelSearch.getValue('WINDOW_DATA'))) {
            		var param = {
                        "DIV_CODE"      : panelSearch.getValue('DIV_CODE'),
                        "P_REQ_NUM"     : panelSearch.getValue('P_REQ_NUM'),
                        "P_REQ_DATE_FR" : UniDate.getDbDateStr(panelSearch.getValue('P_REQ_DATE_FR')),
                        "P_REQ_DATE_TO" : UniDate.getDbDateStr(panelSearch.getValue('P_REQ_DATE_TO'))
                    };
                    console.log( param );
                    this.load({
                        params : param
                    });
                } else {
                    var param= Ext.getCmp('resultForm').getValues();
                    console.log( param );
                    this.load({
                        params : param
                    });
                }
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
            	var isErr = false;
    			Ext.each(list, function(record, index) {
    				if(record.get('RENEWAL_YN') == 'Y' && record.get('CONFIRM_YN') == 'Y'){//확정이면서 갱신할 경우
    					var msg = '';
    					if(Ext.isEmpty(record.get('ITEM_CODE'))){
    						msg += '\n<t:message code="system.label.base.itemcode" default="품목코드"/> ' + ':' + '<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>';
    					}
    					if(Ext.isEmpty(record.get('CUSTOM_CODE'))){
    						msg += '\n<t:message code="system.label.base.custom" default="거래처"/>' + ':' + '<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>';
    					}
    					if(msg != ''){
    						alert((record.id.replace('s_bco110ukrv_kdModel-','')) + '<t:message code="system.message.purchase.message026" default="행의 입력값을 확인 해주세요."/>' + msg);
    						isErr = true;
    						return false;
    					}
    				}

    			});

    			if(isErr) {
    				return false;
    			}


                //1. 마스터 정보 파라미터 구성
                var paramMaster= panelSearch.getValues();   //syncAll 수정

                if(inValidRecs.length == 0) {
                    config = {
                        params: [paramMaster],
                        success: function(batch, option) {

                            panelSearch.getForm().wasDirty = false;
                            panelSearch.resetDirtyStatus();
                            console.log("set was dirty to false");
                            UniAppManager.setToolbarButtons('save', false);

                            if (directMasterStore1.count() == 0) {
                                UniAppManager.app.onResetButtonDown();
                            }else{
                                directMasterStore1.loadStoreRecords();
                            }
                         }
                    };
                    this.syncAllDirect(config);
                } else {

                	var grid = Ext.getCmp('s_bco110ukrv_kdGrid1');
                    grid.uniSelectInvalidColumnAndAlert(inValidRecs);
                }
            },
            listeners:{
			    load: function(store, records, successful, eOpts){
			      Ext.each(records, function(record, rowIndex){
			      /* 	  if(record.get('OEM_YN1') == 'Y'){
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
			      	  } */
				     })
				  }
			   }
        });     // End of var directMasterStore1 = Unilite.createStore('s_bco110ukrv_kdMasterStore1',{

    var reqNumMasterStore = Unilite.createStore('s_bco110ukrv_kdMasterStore1', {   // 검색 팝업창
        model: 's_bco110ukrv_kdModel2',
        autoLoad: false,
        uniOpt : {
            isMaster: true,         // 상위 버튼 연결
            editable: false,         // 수정 모드 사용
            deletable:false,         // 삭제 가능 여부
            useNavi : false         // prev | newxt 버튼 사용
        },
        proxy: {
            type: 'direct',
            api: {
                read: 's_bco110ukrv_kdService.selectReqNumList'
            }
        },
        loadStoreRecords : function()  {
            var param= Ext.getCmp('reqNumSearchForm').getValues();
            console.log( param );
            this.load({
                params : param
            });

        }
    });     // End of var directMasterStore1 = Unilite.createStore('s_bco110ukrv_kdMasterStore1',{

    /**
     * Master Grid1 정의(Grid Panel)
     * @type
     */
    var masterGrid = Unilite.createGrid('s_bco110ukrv_kdGrid1', {
        store: directMasterStore1,
        layout: 'fit',
        region: 'center',
        uniOpt:{    expandLastColumn: false,
                    useRowNumberer: true,
                    onLoadSelectFirst : false,
                    useMultipleSorting: true
        },
        sortableColumns : false,
        tbar: [ {
                itemId : 'estimateBtn',
                id:'INFO_BTN',
                iconCls : 'icon-referance'  ,
                text:'추가정보',
                handler: function() {
                    openSearchInfoWindow();
                }
        }],
        selModel : Ext.create("Ext.selection.CheckboxModel", {
        	singleSelect : false ,
        	checkOnly : false,
        	showHeaderCheckbox :true,
            listeners: {
    			select: function(grid, selectRecord, index, rowIndex, eOpts ){
    				console.log(selectRecord);
    				if(selectRecord.get("CONFIRM_YN")=='N'){
    					selectRecord.set("CONFIRM_YN",'Y');
    				}
    				//20191224 추가
    				if(selectRecord.get("RENEWAL_YN")=='N'){
    					selectRecord.set("RENEWAL_YN",'Y');
    				}
    			},
	    		deselect:  function(grid, selectRecord, index, eOpts ){
	    			if(selectRecord.get("CONFIRM_YN")=='Y'){
    			       selectRecord.set("CONFIRM_YN",'N');
    				}
    				//20191224 추가
	    			if(selectRecord.get("RENEWAL_YN")=='Y'){
    			       selectRecord.set("RENEWAL_YN",'N');
    				}
	    		}
    		}
        }),
        columns: [
            {dataIndex: 'QUERY'                         , width:100, hidden: true},
            {dataIndex: 'P_REQ_NUM'                     , width:150},
            {dataIndex: 'SER_NO'                        , width:80},
            {dataIndex: 'TYPE'                      , width:100},
            {dataIndex: 'P_REQ_TYPE'              , width:100},
            {dataIndex: 'NEW_ITEM_FREFIX'               , width: 120, hidden: true},
            {dataIndex: 'ITEM_CODE'                     , width: 120,
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
                            masterGrid.setItemData(null,true, masterGrid.uniOpt.currentRecord);
                        },
                        applyextparam: function(popup){
                            popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
                        }
                    }
                })
            },
            {dataIndex: 'ITEM_NAME'                     , width: 190,
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
                            masterGrid.setItemData(null,true, masterGrid.uniOpt.currentRecord);
                        },
                        applyextparam: function(popup){
                            popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
                        }
                    }
                })
            },
            {dataIndex: 'SPEC'                    , width:200},
            {dataIndex: 'OEM_ITEM_CODE'             , width:100, hidden: true},
            {dataIndex: 'CAR_TYPE'                  , width:100},
            {dataIndex: 'HS_CODE'                   , width:100},
            //{dataIndex: 'HS_NAME'                   , width:100},

            {dataIndex: 'ORDER_UNIT'                , width:100, align: 'center'},
            {dataIndex: 'PRICE_TYPE'                 , width:100, hidden: false},
            {dataIndex: 'NS_FLAG'                   , width:100, align: 'center'},
            {dataIndex: 'ITEM_P'                    , width:85},
            {dataIndex: 'PACK_ITEM_P'               , width:85},
            {dataIndex: 'PRE_ITEM_P'               , width:85},
            {dataIndex: 'DIFFER_UNIT_P'         , width:85},
            {dataIndex: 'MONEY_UNIT'                , width:100},
            {dataIndex: 'TERMS_PRICE'               , width:85},
            {dataIndex: 'COMP_CODE'                 , width:100, hidden: true},
            {dataIndex: 'DIV_CODE'                  , width:100, hidden: true},
            {dataIndex: 'APLY_START_DATE'           , width:100},
            {dataIndex: 'CUSTOM_CODE'               , width:120,
              'editor': Unilite.popup('AGENT_CUST_G',{
                    textFieldName : 'CUSTOM_CODE',
                    DBtextFieldName : 'CUSTOM_CODE',
                    autoPopup: true,
                    listeners: { 'onSelected': {
                        fn: function(records, type  ){
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
                            grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);

                            var param = {
                                  'COMP_CODE': UserInfo.compCode
                                , 'MONEY_UNIT': grdRecord.get('MONEY_UNIT')
                                , 'APLY_START_DATE': UniDate.getDbDateStr(grdRecord.get('APLY_START_DATE'))
                                , 'TYPE': panelSearch.getValue('TYPE')
                                , 'CUSTOM_CODE': grdRecord.get('CUSTOM_CODE')
                                , 'ITEM_CODE': grdRecord.get('ITEM_CODE')
                                , 'ORDER_UNIT': grdRecord.get('ORDER_UNIT')
                            };
                            s_bco100ukrv_kdService.fnGetLastPriceInfo(param, function(provider, response)   {
                                if(!Ext.isEmpty(provider)) {
                                    grdRecord.set('PRE_ITEM_P'            , provider[0].ITEM_P);
                                	grdRecord.set('PRICE_TYPE1'            , provider[0].PRICE_TYPE);
                               		grdRecord.set('PRICE_TYPE2'            , provider[0].PRICE_TYPE);
                                }
                            });
                        },
                        scope: this
                      },
                      'onClear' : function(type)    {
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('CUSTOM_CODE','');
                            grdRecord.set('CUSTOM_NAME','');
                            grdRecord.set('ITEM_P','');
                            grdRecord.set('PRICE_TYPE','');
                      }
                    }
                })
            },
            {dataIndex: 'CUSTOM_NAME'               , width: 200,
              'editor': Unilite.popup('AGENT_CUST_G',{
                    textFieldName : 'CUSTOM_CODE',
                    DBtextFieldName : 'CUSTOM_CODE',
                    autoPopup: true,
                    listeners: { 'onSelected': {
                        fn: function(records, type  ){
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
                            grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);

                            var param = {
                                  'COMP_CODE': UserInfo.compCode
                                , 'MONEY_UNIT': grdRecord.get('MONEY_UNIT')
                                , 'APLY_START_DATE': UniDate.getDbDateStr(grdRecord.get('APLY_START_DATE'))
                                , 'TYPE': panelSearch.getValue('TYPE')
                                , 'CUSTOM_CODE': grdRecord.get('CUSTOM_CODE')
                                , 'ITEM_CODE': grdRecord.get('ITEM_CODE')
                                , 'ORDER_UNIT': grdRecord.get('ORDER_UNIT')
                            };
                            s_bco100ukrv_kdService.fnGetLastPriceInfo(param, function(provider, response)   {
                                if(!Ext.isEmpty(provider)) {
                                    grdRecord.set('PRE_ITEM_P'            , provider[0].ITEM_P);
                                    grdRecord.set('PRICE_TYPE1'            , provider[0].PRICE_TYPE);
                                    grdRecord.set('PRICE_TYPE2'            , provider[0].PRICE_TYPE);
                                }
                            });
                        },
                        scope: this
                      },
                      'onClear' : function(type)    {
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('CUSTOM_CODE','');
                            grdRecord.set('CUSTOM_NAME','');
                            grdRecord.set('ITEM_P','');
                            grdRecord.set('PRICE_TYPE','');
                      }
                    }
                })
            },
            {dataIndex: 'PAY_TERMS'                 , width:100},
            {dataIndex: 'DELIVERY_METH'             , width:100},

            {dataIndex: 'MAKER_CODE'                , width: 120,
              'editor': Unilite.popup('AGENT_CUST_G',{
                    textFieldName : 'MAKER_CODE',
                    DBtextFieldName : 'CUSTOM_CODE',
                    autoPopup: true,
                    listeners: {
                          'onSelected': {
                                fn: function(records, type  ){
                                    var grdRecord = masterGrid.uniOpt.currentRecord;
                                    grdRecord.set('MAKER_CODE',records[0]['CUSTOM_CODE']);
                                    grdRecord.set('MAKER_NAME',records[0]['CUSTOM_NAME']);

                                    var param = {
                                          'COMP_CODE': UserInfo.compCode
                                        , 'MONEY_UNIT': grdRecord.get('MONEY_UNIT')
                                        , 'APLY_START_DATE': UniDate.getDbDateStr(grdRecord.get('APLY_START_DATE'))
                                        , 'TYPE': panelSearch.getValue('TYPE')
                                        , 'CUSTOM_CODE': grdRecord.get('CUSTOM_CODE')
                                        , 'ITEM_CODE': grdRecord.get('ITEM_CODE')
                                        , 'ORDER_UNIT': grdRecord.get('ORDER_UNIT')
                                    };
                                    s_bco100ukrv_kdService.fnGetLastPriceInfo(param, function(provider, response)   {
                                        if(!Ext.isEmpty(provider)) {
                                            grdRecord.set('PRE_ITEM_P'             , provider[0].ITEM_P);
                                            grdRecord.set('PRICE_TYPE1'            , provider[0].PRICE_TYPE);
                                            grdRecord.set('PRICE_TYPE2'            , provider[0].PRICE_TYPE);
                                        }
                                    });
                                },
                                scope: this
                          },
                          'onClear' : function(type)    {
                                var grdRecord = masterGrid.uniOpt.currentRecord;
                                grdRecord.set('MAKER_CODE','');
                                grdRecord.set('MAKER_NAME','');
                                grdRecord.set('ITEM_P','');
                                grdRecord.set('PRICE_TYPE','');
                          }
                    }
                })
            },
            {dataIndex: 'MAKER_NAME'                , width: 200,
              'editor': Unilite.popup('AGENT_CUST_G',{
                    textFieldName : 'MAKER_CODE',
                    DBtextFieldName : 'CUSTOM_NAME',
                    autoPopup: true,
                    listeners: { 'onSelected': {
                        fn: function(records, type  ){
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('MAKER_CODE',records[0]['CUSTOM_CODE']);
                            grdRecord.set('MAKER_NAME',records[0]['CUSTOM_NAME']);

                            var param = {
                                  'COMP_CODE': UserInfo.compCode
                                , 'MONEY_UNIT': grdRecord.get('MONEY_UNIT')
                                , 'APLY_START_DATE': UniDate.getDbDateStr(grdRecord.get('APLY_START_DATE'))
                                , 'TYPE': panelSearch.getValue('TYPE')
                                , 'CUSTOM_CODE': grdRecord.get('CUSTOM_CODE')
                                , 'ITEM_CODE': grdRecord.get('ITEM_CODE')
                                , 'ORDER_UNIT': grdRecord.get('ORDER_UNIT')
                            };
                            s_bco100ukrv_kdService.fnGetLastPriceInfo(param, function(provider, response)   {
                                if(!Ext.isEmpty(provider)) {
                                    grdRecord.set('PRE_ITEM_P'            , provider[0].ITEM_P);
                                    grdRecord.set('PRICE_TYPE1'            , provider[0].PRICE_TYPE);
                                    grdRecord.set('PRICE_TYPE2'            , provider[0].PRICE_TYPE);
                                }
                            });
                        },
                        scope: this
                      },
                      'onClear' : function(type)    {
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('MAKER_CODE','');
                            grdRecord.set('MAKER_NAME','');
                            grdRecord.set('ITEM_P','');
                            grdRecord.set('PRICE_TYPE','');
                      }
                    }
                })
            },
            {dataIndex: 'CH_REASON'                 , width:200},
            {dataIndex: 'OEM_APLY_YN'               , width:100},
            {dataIndex: 'PERSON_NUMB'               , width:100, hidden: true},
            {dataIndex: 'OEM_YN'                  , width:85, xtype: 'checkcolumn',id:'chkOemYn',disabled: true, disabledCls : ''},
            {dataIndex: '12199_YN'                , width:85, xtype: 'checkcolumn',id:'chk12199Yn',disabled: true, disabledCls : ''},
            {dataIndex: '13199_YN'                , width:85, xtype: 'checkcolumn',id:'chk13199Yn',disabled: true, disabledCls : ''},
            {dataIndex: '14199_YN'                , width:85, xtype: 'checkcolumn',id:'chk14199Yn',disabled: true, disabledCls : ''},
            {dataIndex: '13301_YN'                , width:85, xtype: 'checkcolumn',id:'chk13301Yn',disabled: true, disabledCls : ''},
            {dataIndex: 'OEM_YN1'                  , width:85,hidden: true},
			{dataIndex: 'colume1'                , width:85,hidden: true},
			{dataIndex: 'colume2'                , width:85,hidden: true},
			{dataIndex: 'colume3'                , width:85,hidden: true},
			{dataIndex: 'colume4'                , width:85,hidden: true},
            {dataIndex: 'CONFIRM_YN'              , width:85, hidden: false},
            {dataIndex: 'RENEWAL_YN'              , width:85, hidden: false},
            {dataIndex: 'GW_FLAG'                 , width:85, hidden: true},
            {dataIndex: 'P_REQ_DATE'                , width:100},
            {dataIndex: 'TREE_CODE'                 , width:100, hidden: false,
                'editor': Unilite.popup('DEPT_G',{
                    autoPopup: true,
                    DBtextFieldName: 'TREE_CODE',
                    listeners: { 'onSelected': {
                        fn: function(records, type  ){
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('TREE_CODE',records[0]['TREE_CODE']);
                            grdRecord.set('TREE_NAME',records[0]['TREE_NAME']);

                        },
                        scope: this
                      },
                      'onClear' : function(type)    {
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('TREE_CODE','');
                            grdRecord.set('TREE_NAME','');
                      }
                    }
                })
            },
            {dataIndex: 'TREE_NAME'                 , width:150, hidden: false,
              'editor': Unilite.popup('DEPT_G',{
                    autoPopup: true,
                    listeners: { 'onSelected': {
                        fn: function(records, type  ){
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('TREE_CODE',records[0]['TREE_CODE']);
                            grdRecord.set('TREE_NAME',records[0]['TREE_NAME']);

                        },
                        scope: this
                      },
                      'onClear' : function(type)    {
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('TREE_CODE','');
                            grdRecord.set('TREE_NAME','');
                      }
                    }
                })
            },
            {dataIndex: 'PERSON_NUMB'             , width:100, hidden: false,
               'editor': Unilite.popup('Employee_G',{
                        textFieldName : 'PERSON_NUMB',
                  		autoPopup: true,
                        listeners: { 'onSelected': {
                            fn: function(records, type  ){
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                                grdRecord.set('PERSON_NUMB',records[0]['PERSON_NUMB']);
                                grdRecord.set('PERSON_NAME',records[0]['NAME']);
                            },
                            scope: this
                          },
                          'onClear' : function(type)    {
                                var grdRecord = masterGrid.uniOpt.currentRecord;
                                grdRecord.set('PERSON_NUMB','');
                                grdRecord.set('PERSON_NAME','');
                          }
                        }
                    })
            },
            {dataIndex: 'PERSON_NAME'             , width:150, hidden: false,
               'editor': Unilite.popup('Employee_G',{
                        textFieldName : 'PERSON_NAME',
                    	autoPopup: true,
                        listeners: { 'onSelected': {
                            fn: function(records, type  ){
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                                grdRecord.set('PERSON_NUMB',records[0]['PERSON_NUMB']);
                                grdRecord.set('PERSON_NAME',records[0]['NAME']);
                            },
                            scope: this
                          },
                          'onClear' : function(type)    {
                                var grdRecord = masterGrid.uniOpt.currentRecord;
                                grdRecord.set('PERSON_NUMB','');
                                grdRecord.set('PERSON_NAME','');
                          }
                        }
                    })
            },
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
            {dataIndex: 'SPEC2'                , width:100, hidden: true},
            {dataIndex: 'STOCK_UNIT2'                , width:100, hidden: true},
            {dataIndex: 'NEW_CAR_TYPE'                , width:100, hidden: true},
            {dataIndex: 'QUERY_TYPE'                , width:100, hidden: true},
            {dataIndex: 'CUSTOM_NAME2'                , width:100, hidden: true},
            {dataIndex: 'CUSTOM_FULL_NAME2'                , width:100, hidden: true}

        ],
        listeners: {
            beforeedit: function( editor, e, eOpts ) {

           		if(Ext.getCmp('rdoSelect1').getChecked()[0].inputValue == '2'){//최종단가대비 수출가일 때
           			Ext.getCmp('chk12199Yn').setDisabled(true);
           			Ext.getCmp('chk13199Yn').setDisabled(true);
           			Ext.getCmp('chk14199Yn').setDisabled(true);
           			Ext.getCmp('chk13301Yn').setDisabled(true);
           			Ext.getCmp('chkOemYn').setDisabled(true);
	           		if(UniUtils.indexOf(e.field, ['RENEWAL_YN','MONEY_UNIT','APLY_START_DATE'])) {
	             		return true;
	           			 /* if(e.record.data.RENEWAL_YN == 'Y') {
	             			return true;
	             		} else {
	             			return false;
	             		} */
	             	}
           		}else{//단가입력의뢰일 때
           			if(UniUtils.indexOf(e.field, ['RENEWAL_YN','PACK_ITEM_P','MONEY_UNIT','OEM_YN','12199_YN','13199_YN','14199_YN','13301_YN','OEM_APLY_YN','APLY_START_DATE'])) {
           				if((e.record.data.RENEWAL_YN == 'Y' && e.record.data.CONFIRM_YN == 'Y')
                    			|| (e.record.data.RENEWAL_YN == 'N' && e.record.data.CONFIRM_YN == 'Y')) {
	           					Ext.getCmp('chk12199Yn').setDisabled(false);
	                   			Ext.getCmp('chk13199Yn').setDisabled(false);
	                   			Ext.getCmp('chk14199Yn').setDisabled(false);
	                   			Ext.getCmp('chk13301Yn').setDisabled(false);
	                   			Ext.getCmp('chkOemYn').setDisabled(false);
	                   			return true
                   		} else {
                   			return false;
                   		}

           			}

           		}

//                if(e.record.phantom == false) {
//                	if(UniUtils.indexOf(e.field, ['ITEM_CODE', 'ITEM_NAME', 'HS_CODE', 'HS_NAME', 'PRICE_TYPE1', 'PRICE_TYPE2', 'ORDER_UNIT', 'ITEM_P', 'APLY_START_DATE',
//                                                   'PACK_ITEM_P', 'TERMS_PRICE', 'PAY_TERMS', 'DELIVERY_METH', 'CH_REASON', 'OEM_YN', '12199_YN', '13199_YN', '14199_YN',
//                                                   '13301_YN', 'OEM_APLY_YN', 'CUSTOM_CODE', 'CUSTOM_NAME', 'MAKER_CODE', 'MAKER_NAME']))
//                    {
//                        return false;
//                    } else {
//                        return false;
//                    }
//                }
            	return false;
            },
            cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
                Ext.getCmp('INFO_BTN').setDisabled(false);
                gvRowIndex = rowIndex;
//              UniAppManager.setToolbarButtons('delete',false);
            }/*,
            selectionchange:function( model1, selected, eOpts ){
                orderNoSearch.loadForm(selected);
            },
            beforecelldblclick : function( view, td, cellIndex, record, tr, rowIndex, e, eOpts )    {
            	alert('1');
            }*/,
			selectionchangerecord:function(selected)	{

			}
        },
        setItemData: function(record, dataClear) {
            var grdRecord = this.getSelectedRecord();
            if(dataClear) {
                grdRecord.set('ITEM_CODE'           , '');
                grdRecord.set('ITEM_NAME'           , '');
                grdRecord.set('SPEC'                , '');
                grdRecord.set('ORDER_UNIT'          , '');
                grdRecord.set('OEM_ITEM_CODE'       , '');
                grdRecord.set('CAR_TYPE'            , '');
                grdRecord.set('HS_CODE'             , '');
                grdRecord.set('HS_NAME'             , '');
                grdRecord.set('PRE_ITEM_P'          , '');
            } else {
                grdRecord.set('ITEM_CODE'           , record['ITEM_CODE']);
                grdRecord.set('ITEM_NAME'           , record['ITEM_NAME']);
                grdRecord.set('SPEC'                , record['SPEC']);
                if(panelResult.getValue('TYPE') == '1') {
                    grdRecord.set('ORDER_UNIT'          , record['ORDER_UNIT']);
                } else {
                    grdRecord.set('ORDER_UNIT'          , record['SALE_UNIT']);
                }
                grdRecord.set('OEM_ITEM_CODE'       , record['OEM_ITEM_CODE']);
                grdRecord.set('CAR_TYPE'            , record['CAR_TYPE']);
                grdRecord.set('HS_CODE'             , record['HS_NO']);
                grdRecord.set('HS_NAME'             , record['HS_NAME']);

//                grdRecord.set('PRE_ITEM_P'          , '');
                var param = {
                      'COMP_CODE': UserInfo.compCode
                    , 'MONEY_UNIT': grdRecord.get('MONEY_UNIT')
                    , 'APLY_START_DATE': UniDate.getDbDateStr(grdRecord.get('APLY_START_DATE'))
                    , 'TYPE': panelSearch.getValue('TYPE')
                    , 'CUSTOM_CODE': grdRecord.get('CUSTOM_CODE')
                    , 'ITEM_CODE': grdRecord.get('ITEM_CODE')
                    , 'ORDER_UNIT': grdRecord.get('ORDER_UNIT')
                };
                s_bco100ukrv_kdService.fnGetLastPriceInfo(param, function(provider, response)   {
                    if(!Ext.isEmpty(provider)) {
                        grdRecord.set('PRE_ITEM_P'            , provider[0].ITEM_P);
                        grdRecord.set('PRICE_TYPE1'            , provider[0].PRICE_TYPE);
                        grdRecord.set('PRICE_TYPE2'            , provider[0].PRICE_TYPE);
                    }
                });
            }

        }
    });//End of var masterGrid = Unilite.createGrid('s_bco110ukrv_kdGrid1', {

    var reqNumMasterGrid = Unilite.createGrid('btr120ukrvreqNumMasterGrid', {     // 검색 팝업창
        // title: '기본',
        layout : 'fit',
        store: reqNumMasterStore,
        uniOpt:{
            useRowNumberer: false
        },
        columns:  [
        	{dataIndex : 'P_REQ_NUM'              , width : 100},
            {dataIndex : 'P_REQ_DATE'             , width : 80},
            {dataIndex : 'APLY_START_DATE'        , width : 80},
            {dataIndex : 'TYPE'                   , width : 80},
            {dataIndex : 'TREE_CODE'              , width : 100},
            {dataIndex : 'TREE_NAME'              , width : 150},
            {dataIndex : 'PERSON_NUMB'            , width : 100},
            {dataIndex : 'PERSON_NAME'            , width : 150},
            {dataIndex : 'MONEY_UNIT'             , width : 100},
            {dataIndex : 'DIV_CODE'               , width : 80, hidden: true},
            {dataIndex : 'GW_FLAG'                , width : 80, hidden: true},
            {dataIndex : 'CONFIRM_YN'             , width : 80, hidden: true}
        ],
        listeners: {
            onGridDblClick:function(grid, record, cellIndex, colName) {
                reqNumMasterGrid.returnData(record);
                UniAppManager.app.onQueryButtonDown();
                SearchReqNumWindow.hide();
                panelSearch.setValue('WINDOW_DATA', '');
            }
        },
        returnData: function(record)   {
            if(Ext.isEmpty(record)) {
                record = this.getSelectedRecord();
            }
            panelSearch.setValues({'DIV_CODE':record.get('DIV_CODE')});
            panelSearch.setValues({'P_REQ_NUM':record.get('P_REQ_NUM')});
            panelSearch.setValues({'P_REQ_DATE_FR':record.get('P_REQ_DATE')});
            panelSearch.setValues({'P_REQ_DATE_TO':record.get('P_REQ_DATE')});
            panelSearch.setValues({'WINDOW_DATA':'data'});
//            panelSearch.setValues({'TREE_CODE':record.get('TREE_CODE')});
//            panelSearch.setValues({'TREE_NAME':record.get('TREE_NAME')});
//            panelSearch.setValues({'TYPE':record.get('TYPE')});
//            panelSearch.setValues({'APLY_START_DATE_FR':record.get('APLY_START_DATE')});
//            panelSearch.setValues({'APLY_START_DATE_TO':record.get('APLY_START_DATE')});
//            panelSearch.setValues({'PERSON_NUMB':record.get('PERSON_NUMB')});
//            panelSearch.setValues({'PERSON_NAME':record.get('PERSON_NAME')});
//            panelSearch.setValues({'MONEY_UNIT':record.get('MONEY_UNIT')});
//            panelSearch.setValues({'GW_FLAG':record.get('GW_FLAG')});
//            panelSearch.setValues({'CONFIRM_YN':record.get('CONFIRM_YN')});
//            panelSearch.setValues({'RENEWAL_YN':record.get('RENEWAL_YN')});
        }
    });

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
                value:'<div style="color:blue;font-weight:bold;padding-left:5px;">[확정정보]</div>',
                colspan: 3
            },{
                xtype: 'container',
                colspan: 3,
                layout: {type: 'uniTable', columns: 4},
                items: [Unilite.popup('DIV_PUMOK',{
                        fieldLabel: '품목',
                        valueFieldName: 'ITEM_CODE1',
                        textFieldName: 'ITEM_NAME1',
                        listeners: {
                            onSelected: {
                                fn: function(records, type) {
                                    console.log('records : ', records);
                                    orderNoSearch.setValue('ITEM_CODE1', records[0].ITEM_CODE);
                                    orderNoSearch.setValue('ITEM_NAME1', records[0].ITEM_NAME);
                                    orderNoSearch.setValue('SPEC1', records[0].SPEC);
                                },
                                scope: this
                            },
                            onClear: function(type) {
                                orderNoSearch.setValue('ITEM_CODE1', '');
                                orderNoSearch.setValue('ITEM_NAME1', '');
                                orderNoSearch.setValue('SPEC1', '');
                            }
                        }
               }),{
                fieldLabel : ' ',
                name:'SPEC1',
                xtype:'uniTextfield',
                readOnly:true,
                hideLabel:true,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        orderNoSearch.setValue('SPEC1', newValue);
                    }
                }
            },{
                        xtype: 'button',
                        name: 'NEW_ITEM',
                        text: '신규품목등록',
                        width: 100,
                        margin: '0 0 0 20',
                        handler: function() {
                            var params = {
                                action:'select',
                                'PGM_ID'          : 's_bco110ukrv_kd'/*,
                                'DIV_CODE'        : masterForm.getValue('DIV_CODE'),
                                'CUSTOM_CODE'     : masterForm.getValue('CUSTOM_CODE'),
                                'CUSTOM_NAME'     : masterForm.getValue('CUSTOM_NAME'),
                                'MONEY_UNIT'      : masterForm.getValue('MONEY_UNIT'),
                                'INOUT_DATE'      : UniDate.getDbDateStr(masterForm.getValue('INOUT_DATE')),
                                'WH_CODE'         : masterForm.getValue('WH_CODE'),
                                'INOUT_PRSN'      : masterForm.getValue('INOUT_PRSN'),
                                'CREATE_LOC'      : masterForm.getValue('CREATE_LOC'),
                                'INOUT_NUM'       : masterForm.getValue('INOUT_NUM') */
                            }
                            var rec1 = {data : {prgID : 'bpr300ukrv', 'text':'품목정보등록(통합)'}};
                            parent.openTab(rec1, '/base/bpr300ukrv.do', params);
                        }
                    },{
                        fieldLabel: '차종',
                        name:'CAR_TYPE3',
                        xtype: 'uniCombobox',
                        comboType:'AU',
                        comboCode:'WB04',
                        holdable: 'hold',
                        readOnly: false

                    },Unilite.popup('AGENT_CUST', {
                    fieldLabel:'<t:message code="unilite.msg.sMSR213" default="거래처"/>',
                    holdable: 'hold',
                    valueFieldName: 'CUSTOM_CODE1',
                    textFieldName: 'CUSTOM_NAME1',
                    colspan: 2,
                    listeners: {
                        onSelected: {
                            fn: function(records, type) {
                                console.log('records : ', records);
                                orderNoSearch.setValue('CUSTOM_CODE1', records[0].CUSTOM_CODE);
                                orderNoSearch.setValue('CUSTOM_NAME1', records[0].CUSTOM_NAME);
                            },
                            scope: this
                        },
                        onClear: function(type) {
                                    orderNoSearch.setValue('CUSTOM_CODE1', '');
                                    orderNoSearch.setValue('CUSTOM_NAME1', '');
                                }
                    }
            }),{
                        xtype: 'button',
                        name: 'NEW_CUSTOM',
                        text: '신규거래처등록',
                        width: 100,
                        margin: '0 0 0 20',
                        handler: function() {
                            var params = {
                                action:'select',
                                'PGM_ID'          : 's_bco110ukrv_kd'/*,
                                'DIV_CODE'        : masterForm.getValue('DIV_CODE'),
                                'CUSTOM_CODE'     : masterForm.getValue('CUSTOM_CODE'),
                                'CUSTOM_NAME'     : masterForm.getValue('CUSTOM_NAME'),
                                'MONEY_UNIT'      : masterForm.getValue('MONEY_UNIT'),
                                'INOUT_DATE'      : UniDate.getDbDateStr(masterForm.getValue('INOUT_DATE')),
                                'WH_CODE'         : masterForm.getValue('WH_CODE'),
                                'INOUT_PRSN'      : masterForm.getValue('INOUT_PRSN'),
                                'CREATE_LOC'      : masterForm.getValue('CREATE_LOC'),
                                'INOUT_NUM'       : masterForm.getValue('INOUT_NUM') */
                            }
                            var rec1 = {data : {prgID : 'bcm106ukrv', 'text':'거래처정보등록(통합)'}};
                            parent.openTab(rec1, '/base/bcm106ukrv.do', params);
                        }
                    }
                ]
            },{
                xtype:'displayfield',
                hideLabel:true,
                value:'<div style="color:blue;font-weight:bold;padding-left:5px;">[추가업체정보]</div>',
                colspan: 3
            },
            Unilite.popup('CUST',{
                fieldLabel:'거래처01',
//                readOnly: true,
                valueFieldName: 'ADD01_CUSTOM_CODE',
                textFieldName: 'CUSTOM_NAME01'
            }),
            Unilite.popup('CUST',{
                fieldLabel:'거래처02',
//                readOnly: true,
                valueFieldName: 'ADD02_CUSTOM_CODE',
                textFieldName: 'CUSTOM_NAME02'
            }),
            Unilite.popup('CUST',{
                fieldLabel:'거래처03',
//                readOnly: true,
                valueFieldName: 'ADD03_CUSTOM_CODE',
                textFieldName: 'CUSTOM_NAME03'
            }),
            Unilite.popup('CUST',{
                fieldLabel:'거래처04',
//                readOnly: true,
                valueFieldName: 'ADD04_CUSTOM_CODE',
                textFieldName: 'CUSTOM_NAME04'
            }),
            Unilite.popup('CUST',{
                fieldLabel:'거래처05',
//                readOnly: true,
                valueFieldName: 'ADD05_CUSTOM_CODE',
                textFieldName: 'CUSTOM_NAME05'
            }),
            Unilite.popup('CUST',{
                fieldLabel:'거래처06',
//                readOnly: true,
                valueFieldName: 'ADD06_CUSTOM_CODE',
                textFieldName: 'CUSTOM_NAME06'
            }),
            Unilite.popup('CUST',{
                fieldLabel:'거래처07',
//                readOnly: true,
                valueFieldName: 'ADD07_CUSTOM_CODE',
                textFieldName: 'CUSTOM_NAME07'
            }),
            Unilite.popup('CUST',{
                fieldLabel:'거래처08',
//                readOnly: true,
                valueFieldName: 'ADD08_CUSTOM_CODE',
                textFieldName: 'CUSTOM_NAME08'
            }),
            Unilite.popup('CUST',{
                fieldLabel:'거래처09',
//                readOnly: true,
                valueFieldName: 'ADD09_CUSTOM_CODE',
                textFieldName: 'CUSTOM_NAME09'
            }),
            Unilite.popup('CUST',{
                fieldLabel:'거래처10',
//                readOnly: true,
                valueFieldName: 'ADD10_CUSTOM_CODE',
                textFieldName: 'CUSTOM_NAME10'
            }),
            Unilite.popup('CUST',{
                fieldLabel:'거래처11',
//                readOnly: true,
                valueFieldName: 'ADD11_CUSTOM_CODE',
                textFieldName: 'CUSTOM_NAME11'
            }),
            Unilite.popup('CUST',{
                fieldLabel:'거래처12',
//                readOnly: true,
                valueFieldName: 'ADD12_CUSTOM_CODE',
                textFieldName: 'CUSTOM_NAME12'
            }),
            Unilite.popup('CUST',{
                fieldLabel:'거래처13',
//                readOnly: true,
                valueFieldName: 'ADD13_CUSTOM_CODE',
                textFieldName: 'CUSTOM_NAME13'
            }),
            Unilite.popup('CUST',{
                fieldLabel:'거래처14',
//                readOnly: true,
                valueFieldName: 'ADD14_CUSTOM_CODE',
                textFieldName: 'CUSTOM_NAME14'
            }),
            Unilite.popup('CUST',{
                fieldLabel:'거래처15',
//                readOnly: true,
                valueFieldName: 'ADD15_CUSTOM_CODE',
                textFieldName: 'CUSTOM_NAME15'
            }),
            Unilite.popup('CUST',{
                fieldLabel:'거래처16',
//                readOnly: true,
                valueFieldName: 'ADD16_CUSTOM_CODE',
                textFieldName: 'CUSTOM_NAME16'
            }),
            Unilite.popup('CUST',{
                fieldLabel:'거래처17',
//                readOnly: true,
                valueFieldName: 'ADD17_CUSTOM_CODE',
                textFieldName: 'CUSTOM_NAME17'
            }),
            Unilite.popup('CUST',{
                fieldLabel:'거래처18',
//                readOnly: true,
                valueFieldName: 'ADD18_CUSTOM_CODE',
                textFieldName: 'CUSTOM_NAME18'
            }),
            Unilite.popup('CUST',{
                fieldLabel:'거래처19',
//                readOnly: true,
                valueFieldName: 'ADD19_CUSTOM_CODE',
                textFieldName: 'CUSTOM_NAME19'
            }),
            Unilite.popup('CUST',{
                fieldLabel:'거래처20',
//                readOnly: true,
                valueFieldName: 'ADD20_CUSTOM_CODE',
                textFieldName: 'CUSTOM_NAME20'
            }),
             Unilite.popup('CUST',{
                fieldLabel:'거래처21',
//                readOnly: true,
                valueFieldName: 'ADD21_CUSTOM_CODE',
                textFieldName: 'CUSTOM_NAME21'
            }),
            Unilite.popup('CUST',{
                fieldLabel:'거래처22',
//                readOnly: true,
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

    function openSearchPreqNumWindow() {   // 검색 팝업창
        if(!SearchReqNumWindow) {
            SearchReqNumWindow = Ext.create('widget.uniDetailWindow', {
                title: '단가의뢰번호검색',
                width: 1080,
                height: 580,
                layout: {type:'vbox', align:'stretch'},
                items: [reqNumSearch, reqNumMasterGrid],
                tbar:  ['->',
                    {itemId : 'saveBtn',
                    text: '조회',
                    handler: function() {
                        reqNumMasterStore.loadStoreRecords();
                    },
                    disabled: false
                    }, {
                        itemId : 'OrderNoCloseBtn',
                        text: '닫기',
                        handler: function() {
                            SearchReqNumWindow.hide();
                        },
                        disabled: false
                    }
                ],
                listeners: {beforehide: function(me, eOpt)
                    {
                        orderNoSearch.clearForm();
                        reqNumMasterGrid.reset();
                    },
                    beforeclose: function( panel, eOpts ) {
                        orderNoSearch.clearForm();
                        reqNumMasterGrid.reset();
                    },
                    beforeshow: function( panel, eOpts )    {
                    	reqNumSearch.setValue('DIV_CODE',panelSearch.getValue('DIV_CODE'));
                        reqNumSearch.setValue('P_REQ_NUM',panelSearch.getValue('P_REQ_NUM'));
                        reqNumSearch.setValue('TREE_CODE',panelSearch.getValue('TREE_CODE'));
                        reqNumSearch.setValue('TREE_NAME',panelSearch.getValue('TREE_NAME'));
                        reqNumSearch.setValue('TYPE',panelSearch.getValue('TYPE'));
                        reqNumSearch.setValue('P_REQ_DATE',panelSearch.getValue('P_REQ_DATE'));
                        reqNumSearch.setValue('APLY_START_DATE',panelSearch.getValue('APLY_START_DATE'));
                        reqNumSearch.setValue('PERSON_NUMB',panelSearch.getValue('PERSON_NUMB'));
                        reqNumSearch.setValue('PERSON_NAME',panelSearch.getValue('PERSON_NAME'));
                        reqNumSearch.setValue('MONEY_UNIT',panelSearch.getValue('MONEY_UNIT'));
                    }
                }
            })
        }
        SearchReqNumWindow.center();
        SearchReqNumWindow.show();
    }

    function openSearchInfoWindow() {   // 추가정보 팝업창
        if(!SearchInfoWindow) {
            SearchInfoWindow = Ext.create('widget.uniDetailWindow', {
                title: '단가의뢰서추가정보',
                width: 1080,
                height: 580,
                layout: {type:'vbox', align:'stretch'},
                items: [orderNoSearch],
                tbar:  ['->',{
                            itemId : 'OrderNoSetBtn',
                            text: '적용',
                            handler: function() {
                                UniAppManager.app.setSearchInfoData();
                                SearchInfoWindow.hide();
                            },
                            disabled: false
                        },{
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
                    	//var record = masterGrid.getSelectedRecord();
                    	var record = masterGrid.getStore().getAt(gvRowIndex);
                    	orderNoSearch.setValue('CAR_TYPE3', orderNoSearch.getField('CAR_TYPE3').getStore().getAt(0));
                    	if(record == null){
                    		alert('데이터를 선택해주세요');
                    		return false;
                    	}else{


                            if(!Ext.isEmpty(record.data.CAR_TYPE2)){
                                orderNoSearch.setValue('CAR_TYPE'           ,record.data.CAR_TYPE2);
                            }else {

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
        id: 's_bco110ukrv_kdApp',
        fnInitBinding: function() {
         //   masterGrid.getColumn('PRICE_TYPE1').setVisible(true);
         //   masterGrid.getColumn('PRICE_TYPE2').setVisible(false);
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
            Ext.getCmp('INFO_BTN').setDisabled(true);
        },
        onQueryButtonDown: function() {
//            var pReqNum = panelSearch.getValue('P_REQ_NUM');
//            if(Ext.isEmpty(pReqNum)) {
//                openSearchPreqNumWindow()
//            } else {
            	var param= panelSearch.getValues();
                directMasterStore1.loadStoreRecords();
                UniAppManager.setToolbarButtons(['reset'],true);
                UniAppManager.setToolbarButtons(['newData'],false);
//                if(panelSearch.setAllFieldsReadOnly(true) == false){
//                    return false;
//                }
//                if(panelResult.setAllFieldsReadOnly(true) == false){
//                    return false;
//                }
//                if(directMasterStore1.count() == 0) {
//                    Ext.getCmp('INFO_BTN').setDisabled(true);
//                } else {
//                    Ext.getCmp('INFO_BTN').setDisabled(false);
//                }
//            }
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
            panelSearch.clearForm();
            panelSearch.setAllFieldsReadOnly(false);
            panelResult.setAllFieldsReadOnly(false);
            panelSearch.setValue('DIV_CODE',UserInfo.divCode);
            panelSearch.setValue('TYPE', '1');
            panelSearch.setValue('P_REQ_DATE_FR', UniDate.get('startOfMonth'));
            panelSearch.setValue('P_REQ_DATE_TO', UniDate.get('today'));
            panelSearch.setValue('APLY_START_DATE_FR', UniDate.get('startOfMonth'));
            panelSearch.setValue('APLY_START_DATE_TO', UniDate.get('today'));
            panelResult.setValue('P_REQ_DATE_FR', UniDate.get('startOfMonth'));
            panelResult.setValue('P_REQ_DATE_TO', UniDate.get('today'));
            panelResult.setValue('APLY_START_DATE_FR', UniDate.get('startOfMonth'));
            panelResult.setValue('APLY_START_DATE_TO', UniDate.get('today'));
            panelSearch.setValue('P_REQ_NUM', '');
            panelResult.setValue('P_REQ_NUM', '');
            UniAppManager.setToolbarButtons(['reset','newData'],true);
            masterGrid.reset();
            this.fnInitBinding();
            directMasterStore1.clearData();
        },
        onSaveDataButtonDown: function(config) {    // 저장 버튼
            directMasterStore1.saveStore();
//            UniAppManager.app.onQueryButtonDown();
//            if(directMasterStore1.count() == 0) {
//                Ext.getCmp('INFO_BTN').setDisabled(true);
//            } else {
//                Ext.getCmp('INFO_BTN').setDisabled(false);
//            }
        },
        setHiddenColumn: function() {
            if(panelSearch.getValue('TYPE') == '2') {
              //  masterGrid.getColumn('PRICE_TYPE1').setVisible(true);
              //  masterGrid.getColumn('PRICE_TYPE2').setVisible(false);
            } else {
              //  masterGrid.getColumn('PRICE_TYPE1').setVisible(false);
              //  masterGrid.getColumn('PRICE_TYPE2').setVisible(true);
            }
        },

        // UniSales.fnGetItemInfo callback 함수
        cbGetItemInfo: function(provider, params)   {
                UniAppManager.app.cbGetPriceInfo(provider, params);
        },
        cbGetPriceInfo: function(provider, params)  {
            var dSalePrice=Unilite.nvl(provider['SALE_PRICE'],0);
            var dWgtPrice = Unilite.nvl(provider['WGT_PRICE'],0);//판매단가(중량단위)
            var dVolPrice = Unilite.nvl(provider['VOL_PRICE'],0);//판매단가(부피단위)
            if(params.sType=='I')   {
                //단가구분별 판매단가 계산
                if(params.priceType == 'A') {                           //단가구분(판매단위)
                    dWgtPrice = (params.unitWgt==0) ? 0 : dSalePrice / params.unitWgt
                    dVolPrice  = (params.unitVol==0) ? 0 : dSalePrice / params.unitVol
                }else if(params.priceType == 'B')   {                       //단가구분(중량단위)
                    dSalePrice = dWgtPrice  * params.unitWgt
                    dVolPrice  = (params.unitVol==0) ? 0 : dSalePrice / params.unitVol
                }else if(params.priceType == 'C')   {                       //단가구분(부피단위)
                    dSalePrice = dVolPrice  * params.unitVol;
                    dWgtPrice = (params.unitWgt==0) ? 0 : dSalePrice / params.unitWgt
                }else {
                    dWgtPrice = (params.unitWgt==0) ? 0 : dSalePrice / params.unitWgt
                    dVolPrice = (params.unitVol==0) ? 0 : dSalePrice / params.unitVol
                }
                //판매단가 적용
                params.rtnRecord.set('ITEM_P',dSalePrice);
                params.rtnRecord.set('PRE_ITEM_P',dSalePrice);
            }
            if(params.qty > 0)  UniAppManager.app.fnOrderAmtCal(params.rtnRecord, "P", dSalePrice);
        },
        setSearchInfoData: function(record, dataClear) {
            var records = masterGrid.getSelectedRecord();
            if(!Ext.isEmpty(orderNoSearch.getValue('ITEM_CODE1'))){
                    records.set('ITEM_CODE'                   ,orderNoSearch.getValue('ITEM_CODE1'));
                    records.set('ITEM_NAME'                   ,orderNoSearch.getValue('ITEM_NAME1'));
                    records.set('SPEC'                        ,orderNoSearch.getValue('SPEC1'));
            }
            if(!Ext.isEmpty(orderNoSearch.getValue('CUSTOM_CODE1'))){
                    records.set('CUSTOM_CODE'                 ,orderNoSearch.getValue('CUSTOM_CODE1'));
                    records.set('CUSTOM_NAME'                 ,orderNoSearch.getValue('CUSTOM_NAME1'));
            }
            records.set('NEW_ITEM_FREFIX'             ,orderNoSearch.getValue('NEW_ITEM_FREFIX'));
            records.set('OEM_ITEM_CODE'               ,orderNoSearch.getValue('OEM_ITEM_CODE'));
            records.set('CAR_TYPE'                    ,orderNoSearch.getValue('CAR_TYPE'));
            records.set('STOCK_UNIT'                  ,orderNoSearch.getValue('STOCK_UNIT'));
            records.set('CUSTOM_FULL_NAME'            ,orderNoSearch.getValue('CUSTOM_FULL_NAME'));
            records.set('ADD01_CUSTOM_CODE'           ,orderNoSearch.getValue('ADD01_CUSTOM_CODE'));
            records.set('ADD02_CUSTOM_CODE'           ,orderNoSearch.getValue('ADD02_CUSTOM_CODE'));
            records.set('ADD03_CUSTOM_CODE'           ,orderNoSearch.getValue('ADD03_CUSTOM_CODE'));
            records.set('ADD04_CUSTOM_CODE'           ,orderNoSearch.getValue('ADD04_CUSTOM_CODE'));
            records.set('ADD05_CUSTOM_CODE'           ,orderNoSearch.getValue('ADD05_CUSTOM_CODE'));
            records.set('ADD06_CUSTOM_CODE'           ,orderNoSearch.getValue('ADD06_CUSTOM_CODE'));
            records.set('ADD07_CUSTOM_CODE'           ,orderNoSearch.getValue('ADD07_CUSTOM_CODE'));
            records.set('ADD08_CUSTOM_CODE'           ,orderNoSearch.getValue('ADD08_CUSTOM_CODE'));
            records.set('ADD09_CUSTOM_CODE'           ,orderNoSearch.getValue('ADD09_CUSTOM_CODE'));
            records.set('ADD10_CUSTOM_CODE'           ,orderNoSearch.getValue('ADD10_CUSTOM_CODE'));
            records.set('ADD11_CUSTOM_CODE'           ,orderNoSearch.getValue('ADD11_CUSTOM_CODE'));
            records.set('ADD12_CUSTOM_CODE'           ,orderNoSearch.getValue('ADD12_CUSTOM_CODE'));
            records.set('ADD13_CUSTOM_CODE'           ,orderNoSearch.getValue('ADD13_CUSTOM_CODE'));
            records.set('ADD14_CUSTOM_CODE'           ,orderNoSearch.getValue('ADD14_CUSTOM_CODE'));
            records.set('ADD15_CUSTOM_CODE'           ,orderNoSearch.getValue('ADD15_CUSTOM_CODE'));
            records.set('ADD16_CUSTOM_CODE'           ,orderNoSearch.getValue('ADD16_CUSTOM_CODE'));
            records.set('ADD17_CUSTOM_CODE'           ,orderNoSearch.getValue('ADD17_CUSTOM_CODE'));
            records.set('ADD18_CUSTOM_CODE'           ,orderNoSearch.getValue('ADD18_CUSTOM_CODE'));
            records.set('ADD19_CUSTOM_CODE'           ,orderNoSearch.getValue('ADD19_CUSTOM_CODE'));
            records.set('ADD20_CUSTOM_CODE'           ,orderNoSearch.getValue('ADD20_CUSTOM_CODE'));
            records.set('ADD21_CUSTOM_CODE'           ,orderNoSearch.getValue('ADD21_CUSTOM_CODE'));
            records.set('ADD22_CUSTOM_CODE'           ,orderNoSearch.getValue('ADD22_CUSTOM_CODE'));
            records.set('ADD01_CUSTOM_NAME'           ,orderNoSearch.getValue('CUSTOM_NAME01'));
            records.set('ADD02_CUSTOM_NAME'           ,orderNoSearch.getValue('CUSTOM_NAME02'));
            records.set('ADD03_CUSTOM_NAME'           ,orderNoSearch.getValue('CUSTOM_NAME03'));
            records.set('ADD04_CUSTOM_NAME'           ,orderNoSearch.getValue('CUSTOM_NAME04'));
            records.set('ADD05_CUSTOM_NAME'           ,orderNoSearch.getValue('CUSTOM_NAME05'));
            records.set('ADD06_CUSTOM_NAME'           ,orderNoSearch.getValue('CUSTOM_NAME06'));
            records.set('ADD07_CUSTOM_NAME'           ,orderNoSearch.getValue('CUSTOM_NAME07'));
            records.set('ADD08_CUSTOM_NAME'           ,orderNoSearch.getValue('CUSTOM_NAME08'));
            records.set('ADD09_CUSTOM_NAME'           ,orderNoSearch.getValue('CUSTOM_NAME09'));
            records.set('ADD10_CUSTOM_NAME'           ,orderNoSearch.getValue('CUSTOM_NAME10'));
            records.set('ADD11_CUSTOM_NAME'           ,orderNoSearch.getValue('CUSTOM_NAME11'));
            records.set('ADD12_CUSTOM_NAME'           ,orderNoSearch.getValue('CUSTOM_NAME12'));
            records.set('ADD13_CUSTOM_NAME'           ,orderNoSearch.getValue('CUSTOM_NAME13'));
            records.set('ADD14_CUSTOM_NAME'           ,orderNoSearch.getValue('CUSTOM_NAME14'));
            records.set('ADD15_CUSTOM_NAME'           ,orderNoSearch.getValue('CUSTOM_NAME15'));
            records.set('ADD16_CUSTOM_NAME'           ,orderNoSearch.getValue('CUSTOM_NAME16'));
            records.set('ADD17_CUSTOM_NAME'           ,orderNoSearch.getValue('CUSTOM_NAME17'));
            records.set('ADD18_CUSTOM_NAME'           ,orderNoSearch.getValue('CUSTOM_NAME18'));
            records.set('ADD19_CUSTOM_NAME'           ,orderNoSearch.getValue('CUSTOM_NAME19'));
            records.set('ADD20_CUSTOM_NAME'           ,orderNoSearch.getValue('CUSTOM_NAME20'));
            records.set('ADD21_CUSTOM_NAME'           ,orderNoSearch.getValue('CUSTOM_NAME21'));
            records.set('ADD22_CUSTOM_NAME'           ,orderNoSearch.getValue('CUSTOM_NAME22'));
        }

    });
};


</script>
