<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_zcc200ukrv_kd" >
    <t:ExtComboStore comboType="BOR120" pgmId="s_zcc200ukrv_kd"/>   <!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="B004"/>              <!-- 화폐단위 -->
    <t:ExtComboStore comboType="AU" comboCode="B010"/>              <!-- 사용 -->
    <t:ExtComboStore comboType="AU" comboCode="B013"/>              <!-- 단위  -->
    <t:ExtComboStore comboType="AU" comboCode="B004"/>              <!-- 기준화폐 -->
    <t:ExtComboStore comboType="AU" comboCode="WB04"/>              <!-- 차종  -->
    <t:ExtComboStore comboType="AU" comboCode="WZ02"/>              <!-- 구분  -->
    <t:ExtComboStore comboType="AU" comboCode="WZ05"/>              <!-- 부품명 -->
    <t:ExtComboStore comboType="AU" comboCode="WZ07"/>              <!-- 재질  -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript">

var BsaCodeInfo = {     //컨트롤러에서 값을 받아옴.
    gsAutoType  :   '${gsAutoType}',
    gsMoneyUnit :   '${gsMoneyUnit}'
};

var selectedGrid = 's_zcc200ukrv_kdGrid1';
var masterUpdateFlag = '';

//var output ='';   // 셋팅 값 확인 alert
//for(var key in BsaCodeInfo) {
//    output += key + '  :  ' + BsaCodeInfo[key] + '\n';
//}
//alert(output);

var SearchEstNumWindow; // 검색창

function appMain() {
    var groupUrl = '${groupUrl}'; //그룹웨어 호출 url

    var isAutoOrderNum = false;
    if(BsaCodeInfo.gsAutoType=='Y') {
        isAutoOrderNum = true;
    }

    /**
     *   Model 정의
     * @type
     */
    var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy', {
        api: {
            read: 's_zcc200ukrv_kdService.selectList',
            update: 's_zcc200ukrv_kdService.updateDetail',
            create: 's_zcc200ukrv_kdService.insertDetail',
            destroy: 's_zcc200ukrv_kdService.deleteDetail',
            syncAll: 's_zcc200ukrv_kdService.saveAll'
        }
    });

    var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy', {
        api: {
            read: 's_zcc200ukrv_kdService.selectList2',
            update: 's_zcc200ukrv_kdService.updateDetail2',
            create: 's_zcc200ukrv_kdService.insertDetail2',
            destroy: 's_zcc200ukrv_kdService.deleteDetail2',
            syncAll: 's_zcc200ukrv_kdService.saveAll2'
        }
    });

    var directProxy3 = Ext.create('Unilite.com.data.proxy.UniDirectProxy', {
        api: {
            read: 's_zcc200ukrv_kdService.selectResetList1'
        }
    });

    var directProxy4 = Ext.create('Unilite.com.data.proxy.UniDirectProxy', {
        api: {
            read: 's_zcc200ukrv_kdService.selectResetList2'
        }
    });

    var panelResult = Unilite.createSearchForm('resultForm',{
        hidden : !UserInfo.appOption.collapseLeftSearch,
        region: 'north',
        layout : {type : 'uniTable', columns : 3},
        padding:'1 1 1 1',
        border:true,
        masterGrid: masterGrid,
        items: [{
                fieldLabel: '사업장',
                name: 'DIV_CODE',
                xtype: 'uniCombobox',
                comboType: 'BOR120',
                holdable: 'hold',
                tdAttrs: {width: 346},
                allowBlank:false
            },{
                fieldLabel: '견적번호',
                name:'EST_NUM',
                xtype: 'uniTextfield',
                readOnly: isAutoOrderNum,
                holdable: isAutoOrderNum ? 'readOnly':'hold'/*,
                tdAttrs: {width: 346}*/
//                allowBlank:false
            },{
                fieldLabel: '견적일자',
                name: 'EST_DATE',
                xtype: 'uniDatefield',
                value: UniDate.get('today'),
//                holdable: 'hold',
                allowBlank: false
            },
            Unilite.popup('AGENT_CUST',{
                    fieldLabel: '거래처',
                    valueFieldName:'CUSTOM_CODE',
                    textFieldName:'CUSTOM_NAME',
//                    holdable: 'hold',
                    allowBlank:false
            }),
            /* Unilite.popup('DIV_PUMOK',{
                fieldLabel: '품목코드',
                valueFieldName: 'ITEM_CODE',
                textFieldName: 'ITEM_NAME',
                allowBlank:false,
                holdable: 'hold',
                listeners: {'onSelected': {
                            fn: function(records, type) {
                                console.log('records : ', records);
                                Ext.each(records, function(record, i) {

//                                    masterGrid.setItemData(record,false, masterGrid.uniOpt.currentRecord);
                                    panelResult.setValue("ITEM_CODE",       record['ITEM_CODE']);
                                    panelResult.setValue("ITEM_NAME",       record['ITEM_NAME']);
                                    panelResult.setValue("OEM_ITEM_CODE",   record['OEM_ITEM_CODE']);
                                    panelResult.setValue("CAR_TYPE",        record['CAR_TYPE']);

                                });
                            },
                            scope: this
                        },
                        'onClear': function(type) {
                            panelResult.setValue("ITEM_CODE",       '');
                            panelResult.setValue("ITEM_NAME",       '');
                            panelResult.setValue("OEM_ITEM_CODE",   '');
                            panelResult.setValue("CAR_TYPE",        '');
                        },
                        applyextparam: function(popup) {
                            popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
                        }
                    }
            }) */
            {
                fieldLabel: '품번',
                name: 'ITEM_CODE',
                xtype: 'uniTextfield',
                readOnly: false,
                allowBlank:false
               // holdable: 'hold'
            } ,{
                fieldLabel: '품명',
                name: 'ITEM_NAME',
                width: 500,
                xtype: 'uniTextfield',
                readOnly: false,
                allowBlank:false
               // holdable: 'hold'
            }
            ,{
                fieldLabel: 'OEM코드',
                name: 'OEM_ITEM_CODE',
                xtype: 'uniTextfield',
                readOnly: true,
                hidden:true
            },{
                fieldLabel: '차종',
                name: 'CAR_TYPE',
                xtype: 'uniTextfield',
                readOnly: false
            },{
                fieldLabel: '공정명',
                name: 'PROG_WORK_NAME',
//                holdable: 'hold',
                xtype: 'uniTextfield',
//                holdable: 'hold',
                colspan:2
            },{
                fieldLabel: '화폐',
                name:'MONEY_UNIT',
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'B004',
//                holdable: 'hold',
                displayField: 'value',
                allowBlank:false,
                hidden : true
            }, {
                fieldLabel: '환율',
                name: 'EXCHG_RATE_O',
                xtype: 'uniNumberfield',
//                holdable: 'hold',
                decimalPrecision: 4,
                value: 1,
                allowBlank: false,
                hidden : true
            },
            Unilite.popup('DEPT', {
                fieldLabel: '부서',
                valueFieldName: 'TREE_CODE',
                textFieldName: 'TREE_NAME',
//                holdable: 'hold',
                autoPopup:true,
                allowBlank:false
            }),
            Unilite.popup('Employee',{
                    fieldLabel: '사번',
//                    holdable: 'hold',
                    valueFieldName:'PERSON_NUMB',
                    textFieldName:'PERSON_NAME',
                    colspan:2,
                    validateBlank:false,
                    autoPopup:true,
                    allowBlank:false,
                    listeners: {
                        onSelected: {
                            fn: function(records, type) {
                                var param= Ext.getCmp('resultForm').getValues();
                                s_mre090ukrv_kdService.selectPersonDept(param, function(provider, response)  {
                                    if(!Ext.isEmpty(provider)){
                                        panelResult.setValue('TREE_CODE', provider[0].DEPT_CODE);
                                        panelResult.setValue('TREE_NAME', provider[0].DEPT_NAME);
                                    }
                                });
                            },
                            scope: this
                        },
                        onClear: function(type) {
                            panelResult.setValue('PERSON_NUMB', '');
                            panelResult.setValue('PERSON_NAME', '');
                        },
                        applyextparam: function(popup){
                            popup.setExtParam({'DEPT_SEARCH': panelResult.getValue('TREE_NAME')});
                        }
                    }
            }),{
                fieldLabel: '비고',
                name: 'REMARK_M',
                xtype: 'uniTextfield',
                width:600,
//                holdable: 'hold',
                colspan:2
            },{
                fieldLabel: 'T4_1',
                name: 'T4_1',
                xtype: 'uniNumberfield',
                decimalPrecision: 0,
                hidden:true
            },{
                fieldLabel: 'T6_1',
                name: 'T6_1',
                xtype: 'uniNumberfield',
                decimalPrecision: 0,
                hidden:true
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
		listeners: {
			uniOnChange: function(basicForm, dirty, eOpts) {
				if(basicForm.isDirty()){
					UniAppManager.setToolbarButtons('save', true);
				}
			}
		}/*,
        listeners : {
                uniOnChange : function( basicForm, dirty, eOpts ) {
                    console.log("onDirtyChange");
                    if(panelResult.isDirty()) {
                        if(!Ext.isEmpty(panelResult.getValue('EST_NUM'))) {
                        	masterUpdateFlag = 'U';
                        }
                        UniAppManager.setToolbarButtons(['save', 'reset'], true);
                    } else {
                        masterUpdateFlag = '';
                        UniAppManager.setToolbarButtons(['save', 'reset'], false);
                    }
                },
                beforeaction : function(panelResult, action, eOpts) {
                    console.log("action : ",action);
                    console.log("action.type : ",action.type);
                    if(action.type =='directsubmit') {
                        var invalid = this.getForm().getFields().filterBy(function(field) {
                            return !field.validate();
                        });
                        if(invalid.length > 0) {
                            r = false;
                            var labelText = ''

                            if(Ext.isDefined(invalid.items[0]['fieldLabel']))   {
                                var labelText = invalid.items[0]['fieldLabel']+'은(는)';
                            }else if(Ext.isDefined(invalid.items[0].ownerCt))   {
                                var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
                            }
                            alert(labelText+Msg.sMB083);
                            invalid.items[0].focus();
                        }
                    }
                }
        }*/,
        setLoadRecord: function(record) {
            var me = this;
            me.uniOpt.inLoading=false;
            me.setAllFieldsReadOnly(true);
        }
    });

    var estNumSearch = Unilite.createSearchForm('estNumSearchForm', {     // 검색팝업창 / 기존의뢰서
        layout: {type: 'uniTable', columns : 3},
//        trackResetOnLoad: true,
        items: [{
                fieldLabel: '사업장',
                name: 'DIV_CODE',
                xtype: 'uniCombobox',
                comboType: 'BOR120',
                allowBlank:false
            },{
                fieldLabel: '견적번호',
                xtype:'uniTextfield',
                name: 'EST_NUM'
            },{
                fieldLabel: '견적일자',
                xtype: 'uniDateRangefield',
                startFieldName: 'FR_EST_DATE',
                endFieldName: 'TO_EST_DATE',
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today'),
                allowBlank: false,
                width: 315
            },{
                fieldLabel: '품번',
                name: 'ITEM_CODE',
                xtype: 'uniTextfield'
            },{
                fieldLabel: '비고',
                name: 'REMARK',
                xtype: 'uniTextfield'
            },
                Unilite.popup('AGENT_CUST',{
                fieldLabel: '거래처',
                valueFieldName:'CUSTOM_CODE',
                textFieldName:'CUSTOM_NAME'
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
    }); // createSearchForm

    Unilite.defineModel('s_zcc200ukrv_kdModel1', {        // 그리드1
        fields: [
        
        
            {name : 'COMP_CODE',        text : '법인코드',      type: 'string'},
            {name : 'DIV_CODE',         text : '사업장',       type: 'string', comboType: 'BOR120'},
            {name : 'EST_NUM',          text : '견적번호',      type: 'string', allowBlank: isAutoOrderNum},
            {name : 'EST_SEQ',          text : '견적순번',      type: 'int'},
            {name : 'GUBUN_CODE',       text : '부품명',       type: 'string', allowBlank : false, comboType:'AU', comboCode:'WZ05'},
            {name : 'JAEGIL',           text : '재질',        type: 'string', comboType:'AU', comboCode:'WZ07'},
            {name : 'STOCK_UNIT',       text : '단위',        type: 'string', comboType:'AU', comboCode:'B013'},
            {name : 'GARO_NUM',         text : '가로',        type: 'int'},
            {name : 'SERO_NUM',         text : '세로',        type: 'int'},
            {name : 'DUGE_NUM',         text : '높이',        type: 'int'},
            {name : 'UNIT_Q',           text : '개수',        type: 'float', decimalPrecision: 0, format:'0,000'},
            {name : 'QTY_HH',           text : '소요량',       type: 'uniQty'},
            {name : 'PRICE_RATE',       text : '단가',        type: 'float', decimalPrecision: 0, format:'0,000'},
            {name : 'AMT_O',            text : '금액',        type: 'float', decimalPrecision: 0, format:'0,000'},
            {name : 'REMARK',           text : '비고',        type: 'string'},
            
            {name : 'EST_DATE',         text : '견적일자',      type: 'uniDate'},
            {name : 'CUSTOM_CODE',      text : '거래처코드',    type: 'string'},
            {name : 'ITEM_CODE',        text : '품목코드',      type: 'string'},
            {name : 'PROG_WORK_NAME',   text : '공정명',       type: 'string'},
            {name : 'MONEY_UNIT',       text : '화폐단위',      type: 'string'},
            {name : 'EXCHG_RATE_O',     text : '환율',        type: 'string'},
            {name : 'DEPT_CODE',        text : '부서코드',     type: 'string'},
            {name : 'PERSEON_NUMB',     text : '사번',        type: 'string'},
            {name : 'GUBUN',            text : '구분',        type: 'string', allowBlank : false, comboType:'AU', comboCode:'WZ02'},
            {name : 'REF_CODE1',        text : 'REF_CODE1',  type: 'string'}
        ]
    });

    Unilite.defineModel('s_zcc200ukrv_kdModel2', {  // 그리드2
    	fields: [
            {name : 'EST_NUM',          text : '견적번호',      type: 'string'},
            {name : 'EST_SEQ',          text : '견적순번',      type: 'int'},
            {name : 'COMP_CODE',        text : '법인코드',      type: 'string'},
            {name : 'DIV_CODE',         text : '사업장',       type: 'string', comboType: 'BOR120'},
            {name : 'GUBUN',            text : '구분',        type: 'string', comboType:'AU', comboCode:'WZ02'},
            {name : 'GUBUN_CODE',       text : '가공공정명',       type: 'string', comboType:'AU', comboCode:'WZ06'},
            {name : 'JAEGIL',           text : '재질',        type: 'string', comboType:'AU', comboCode:'WZ07'},
            {name : 'UNIT_Q',           text : '개수',        type: 'uniQty'},
            {name : 'STOCK_UNIT',       text : '단위',        type: 'string', comboType:'AU', comboCode:'B013'},
            {name : 'QTY_HH',           text : '시간',       type: 'float', decimalPrecision: 0, format:'0,000'},
            {name : 'PRICE_RATE',       text : '임율',        type: 'float', decimalPrecision: 0, format:'0,000'},
            {name : 'AMT_O',            text : '금액',        type: 'float', decimalPrecision: 0, format:'0,000'},
            {name : 'GARO_NUM',         text : '가로',        type: 'int'},
            {name : 'SERO_NUM',         text : '세로',        type: 'int'},
            {name : 'DUGE_NUM',         text : '두께',        type: 'int'},
            {name : 'REMARK',           text : '비고',        type: 'string'}
        ]
    });

    Unilite.defineModel('s_zcc200ukrv_kdModel3', {  // 검색 팝업창
        fields: [
            {name : 'COMP_CODE',        text : '법인코드',      type: 'string'},
            {name : 'DIV_CODE',         text : '사업장',       type: 'string', comboType: 'BOR120'},
        	{name : 'EST_DATE',         text : '견적일자',      type: 'uniDate'},
            {name : 'EST_NUM',          text : '견적번호',      type: 'string'},
            {name : 'CUSTOM_CODE',      text : '거래처코드',    type: 'string'},
            {name : 'CUSTOM_NAME',      text : '거래처명',      type: 'string'},
            {name : 'ITEM_CODE',        text : '품번',      type: 'string'},
            {name : 'ITEM_NAME',        text : '품명',       type: 'string'},
            {name : 'CAR_TYPE',         text : '차종',        type: 'string', comboType:'AU', comboCode:'WB04'},
            {name : 'PROG_WORK_NAME',   text : '공정명',        type: 'string'},
            {name : 'CALC1',            text : '제조원가',        type: 'float', decimalPrecision: 0, format:'0,000'},
            {name : 'CALC2',            text : '관리/이윤',        type: 'float', decimalPrecision: 0, format:'0,000'},
            {name : 'CALC3',            text : '총합계',        type: 'float', decimalPrecision: 0, format:'0,000'},
            {name : 'REMARK',           text : '비고',        type: 'string'},
            {name : 'DEPT_NAME',        text : '부서명',       type: 'string'},
            {name : 'PERSON_NAME',      text : '담당자명',       type: 'string'}
        ]
    });


    /**
    *2020.02.12 초기화 시 공통코드에 등록돼있는 재료비 가공비를 모두 뿌려주기위해 관련 스토어 모델 추가
    **/

    Unilite.defineModel('s_zcc200ukrv_kd_Reset_Model1', {        // 초기화용 그리드1
        fields: [
            {name : 'EST_NUM',          text : '견적번호',      type: 'string', allowBlank: isAutoOrderNum},
            {name : 'EST_SEQ',          text : '견적순번',      type: 'int'},
            {name : 'COMP_CODE',        text : '법인코드',      type: 'string'},
            {name : 'DIV_CODE',         text : '사업장',       type: 'string', comboType: 'BOR120'},
            {name : 'EST_DATE',         text : '견적일자',      type: 'uniDate'},
            {name : 'CUSTOM_CODE',      text : '거래처코드',    type: 'string'},
            {name : 'ITEM_CODE',        text : '품목코드',      type: 'string'},
            {name : 'PROG_WORK_NAME',   text : '공정명',       type: 'string'},
            {name : 'MONEY_UNIT',       text : '화폐단위',      type: 'string'},
            {name : 'EXCHG_RATE_O',     text : '환율',        type: 'string'},
            {name : 'DEPT_CODE',        text : '부서코드',     type: 'string'},
            {name : 'PERSEON_NUMB',     text : '사번',        type: 'string'},
            {name : 'REMARK',           text : '비고',        type: 'string'},
            {name : 'GUBUN',            text : '구분',        type: 'string', allowBlank : false, comboType:'AU', comboCode:'WZ02'},
            {name : 'GUBUN_CODE',       text : '부품명',       type: 'string', allowBlank : false, comboType:'AU', comboCode:'WZ05'},
            {name : 'JAEGIL',           text : '재질',        type: 'string', comboType:'AU', comboCode:'WZ07'},
            {name : 'UNIT_Q',           text : '개수',        type: 'uniQty'},
            {name : 'STOCK_UNIT',       text : '단위',        type: 'string', comboType:'AU', comboCode:'B013'},
            {name : 'QTY_HH',           text : '소요량',       type: 'uniQty'},
            {name : 'PRICE_RATE',       text : '단가',        type: 'uniPrice'},
            {name : 'AMT_O',            text : '금액',        type: 'uniUnitPrice'},
            {name : 'GARO_NUM',         text : '가로',        type: 'int'},
            {name : 'SERO_NUM',         text : '세로',        type: 'int'},
            {name : 'DUGE_NUM',         text : '두께',        type: 'int'},
            {name : 'REF_CODE1',        text : 'REF_CODE1',  type: 'string'}
        ]
    });

    Unilite.defineModel('s_zcc200ukrv_kd_Reset_Model2', {  // 초기화용 그리드2
        fields: [
            {name : 'EST_NUM',          text : '견적번호',      type: 'string', allowBlank: isAutoOrderNum},
            {name : 'EST_SEQ',          text : '견적순번',      type: 'int'},
            {name : 'COMP_CODE',        text : '법인코드',      type: 'string'},
            {name : 'DIV_CODE',         text : '사업장',       type: 'string', comboType: 'BOR120'},
            {name : 'EST_DATE',         text : '견적일자',      type: 'uniDate'},
            {name : 'CUSTOM_CODE',      text : '거래처코드',     type: 'string'},
            {name : 'ITEM_CODE',        text : '품목코드',      type: 'string'},
            {name : 'PROG_WORK_NAME',   text : '공정명',       type: 'string'},
            {name : 'MONEY_UNIT',       text : '화폐단위',      type: 'string'},
            {name : 'EXCHG_RATE_O',     text : '환율',        type: 'string'},
            {name : 'DEPT_CODE',        text : '부서코드',     type: 'string'},
            {name : 'PERSEON_NUMB',     text : '사번',        type: 'string'},
            {name : 'REMARK',           text : '비고',        type: 'string'},
            {name : 'GUBUN',            text : '구분',        type: 'string', allowBlank : false, comboType:'AU', comboCode:'WZ02'},
            {name : 'GUBUN_CODE',       text : '가공공정명',    type: 'string', allowBlank : false, comboType:'AU', comboCode:'WZ06'},
            {name : 'JAEGIL',           text : '재질',        type: 'string', comboType:'AU', comboCode:'WZ07'},
            {name : 'UNIT_Q',           text : '개수',        type: 'uniQty'},
            {name : 'STOCK_UNIT',       text : '단위',        type: 'string', comboType:'AU', comboCode:'B013'},
            {name : 'QTY_HH',           text : '시간',       type: 'uniQty'},
            {name : 'PRICE_RATE',       text : '임율',        type: 'uniPercent'},
            {name : 'AMT_O',            text : '금액',        type: 'uniUnitPrice'}
        ]
    });




    /**
     * Store 정의(Service 정의)
     * @type
     */
    var directMasterStore1 = Unilite.createStore('s_zcc200ukrv_kdMasterStore1', {
        model: 's_zcc200ukrv_kdModel1',
        autoLoad: false,
        uniOpt : {
            isMaster: true,         // 상위 버튼 연결
            editable: true,         // 수정 모드 사용
            deletable:true,         // 삭제 가능
            useNavi : false         // prev | newxt 버튼 사용
        },
        proxy: directProxy,
        loadStoreRecords : function() {
            var param= Ext.getCmp('resultForm').getValues();
            console.log( param );
            this.load({
                params : param
            });
        },
        saveStore : function(pReqNo) {
            var inValidRecs = this.getInvalidRecords();
            console.log("inValidRecords : ", inValidRecs);

            var toCreate = this.getNewRecords();
            var toUpdate = this.getUpdatedRecords();
            var toDelete = this.getRemovedRecords();
            var list = [].concat(toUpdate, toCreate);
            console.log("list:", list);

            console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));

            //1. 마스터 정보 파라미터 구성
            var paramMaster= panelResult.getValues();   //syncAll 수정
//            	paramMaster.MATRL_COST   = subForm.getValue('TOTAL1');      //재료비
//            	paramMaster.PROCESS_COST = subForm.getValue('TOTAL2');      //가공비
//            	paramMaster.PROFIT_RATE  = subForm.getValue('PROFIT_RATE'); //이익률
//            	paramMaster.MNGM_COST  	 = subForm.getValue('MNGM_COST');   //관리비
//            paramMaster.FLAG = masterUpdateFlag;
            
            if(inValidRecs.length == 0) {
                config = {
                    params: [paramMaster],
                    success: function(batch, option) {
                        var master = batch.operations[0].getResultSet();
                        if(Ext.isEmpty(panelResult.getValue('EST_NUM'))){
                            panelResult.setValue("EST_NUM", master.EST_NUM);
                        }
                        panelResult.getForm().wasDirty = false;
                        panelResult.resetDirtyStatus();
                        console.log("set was dirty to false");
                        UniAppManager.setToolbarButtons('save', false);

                        if(directMasterStore2.isDirty()) {
                            directMasterStore2.saveStore();
                            /* if (directMasterStore1.count() == 0 && directMasterStore2.count() == 0) {
                                UniAppManager.app.onResetButtonDown();
                            } else {
                                UniAppManager.app.onQueryButtonDown();
                            } */
                        }else{
                        	UniAppManager.app.onQueryButtonDown();
                        }
                     }
                };
                this.syncAllDirect(config);
            } else {
                var grid = Ext.getCmp('s_zcc200ukrv_kdGrid1');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
        },
        listeners: {
            load: function(store, records, successful, eOpts) {
                selectedGrid = 's_zcc200ukrv_kdGrid1';
                UniAppManager.setToolbarButtons(['delete', 'newData'], true);
            },
            datachanged : function(store,  eOpts) {
                if( directMasterStore1.isDirty() || store.isDirty()) {
                    UniAppManager.setToolbarButtons('save', true);
                }else {
                    UniAppManager.setToolbarButtons('save', false);
                }
            }
        }
    });     // End of var directMasterStore1 = Unilite.createStore('s_zcc200ukrv_kdMasterStore1',{

    var directMasterStore2 = Unilite.createStore('s_zcc200ukrv_kdMasterStore1', {
        model: 's_zcc200ukrv_kdModel2',
        autoLoad: false,
        uniOpt : {
            isMaster: true,         // 상위 버튼 연결
            editable: true,         // 수정 모드 사용
            deletable:true,         // 삭제 가능
            useNavi : false         // prev | newxt 버튼 사용
        },
        proxy: directProxy2,
        loadStoreRecords : function() {
            var param= Ext.getCmp('resultForm').getValues();
            console.log( param );
            this.load({
                params : param
            });
        },
        saveStore : function(pReqNo) {
            var inValidRecs = this.getInvalidRecords();
            console.log("inValidRecords : ", inValidRecs);

            var toCreate = this.getNewRecords();
            var toUpdate = this.getUpdatedRecords();
            var toDelete = this.getRemovedRecords();
            var list = [].concat(toUpdate, toCreate);
            console.log("list:", list);

            console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));

            //1. 마스터 정보 파라미터 구성
            var paramMaster = panelResult.getValues();   //syncAll 수정
//            paramMaster.FLAG = masterUpdateFlag;
//            paramMaster.MATRL_COST   = subForm.getValue('TOTAL1');      //재료비
//        	paramMaster.PROCESS_COST = subForm.getValue('TOTAL2');      //가공비
//        	paramMaster.PROFIT_RATE  = subForm.getValue('PROFIT_RATE'); //이익률
//        	paramMaster.MNGM_COST  	 = subForm.getValue('MNGM_COST');   //관리비
            if(inValidRecs.length == 0) {
                config = {
                    params: [paramMaster],
                    success: function(batch, option) {
//                        var master = batch.operations[0].getResultSet();
//                        panelResult.setValue("EST_NUM", master.EST_NUM);
                        panelResult.getForm().wasDirty = false;
                        panelResult.resetDirtyStatus();
                        console.log("set was dirty to false");
                        UniAppManager.setToolbarButtons('save', false);
                        UniAppManager.app.onQueryButtonDown();
//                            if (directMasterStore2.count() == 0) {
//                                UniAppManager.app.onResetButtonDown();
//                            }else{
//                                directMasterStore1.loadStoreRecords();
//                            }
                     }
                };
                this.syncAllDirect(config);
            } else {
                var grid = Ext.getCmp('s_zcc200ukrv_kdGrid2');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
        },
        listeners:{
            load: function(store, records, successful, eOpts) {
                selectedGrid = 's_zcc200ukrv_kdGrid2';
                UniAppManager.app.fnCalcFormTotal(subForm.getValue('T4_1'),subForm.getValue('T6_1'));
                UniAppManager.setToolbarButtons(['delete', 'newData'], true);
            },
            datachanged : function(store,  eOpts) {
                if( directMasterStore2.isDirty() || store.isDirty()) {
                    UniAppManager.setToolbarButtons('save', true);
                }else {
                    UniAppManager.setToolbarButtons('save', false);
                }
            }
        }
    });     // End of var directMasterStore1 = Unilite.createStore('s_zcc200ukrv_kdMasterStore2',{

    var estNumMasterStore = Unilite.createStore('s_zcc200ukrv_kdMasterStore1', {   // 검색 팝업창
        model: 's_zcc200ukrv_kdModel3',
        autoLoad: false,
        uniOpt : {
            isMaster: false,        // 상위 버튼 연결
            editable: false,        // 수정 모드 사용
            deletable:false,        // 삭제 가능
            useNavi : false         // prev | newxt 버튼 사용
        },
        proxy: {
            type: 'direct',
            api: {
                read: 's_zcc200ukrv_kdService.selectEstNumList'
            }
        },
        loadStoreRecords : function()  {
            var param= Ext.getCmp('estNumSearchForm').getValues();
            console.log( param );
            this.load({
                params : param
            });
        },
        groupField:'CUSTOM_NAME'
    });     // End of var directMasterStore1 = Unilite.createStore('s_zcc200ukrv_kdMasterStore1',{

    var directResetStore1 = Unilite.createStore('s_zcc200ukrv_kdResetStore1', {
        model: 's_zcc200ukrv_kd_Reset_Model1',
        autoLoad: false,
        uniOpt : {
            isMaster: false,         // 상위 버튼 연결
            editable: false,         // 수정 모드 사용
            deletable:false,         // 삭제 가능
            useNavi : false         // prev | newxt 버튼 사용
        },
        proxy: directProxy3,
        loadStoreRecords : function() {
            var param= Ext.getCmp('resultForm').getValues();
            console.log( param );
            this.load({
                params : param,
				callback : function(records,options,success) {
					if(success) {
						directResetStore2.loadStoreRecords()
					}
				}
            });
        },
        saveStore : function() {

        },
        listeners:{
            load: function(store, records, successful, eOpts) {
            	Ext.each(directResetStore1.data.items, function(rec, i){
					UniAppManager.app.onNewDataButtonDown2('s_zcc200ukrv_kdGrid1', rec.get('GUBUN_CODE'), '1', rec.get('REF_CODE1'));
        		});
            }
        }
    });     // End of var directMasterStore1 = Unilite.createStore('s_zcc200ukrv_kdMasterStore2',{

    var directResetStore2 = Unilite.createStore('s_zcc200ukrv_kdResetStore2', {
        model: 's_zcc200ukrv_kd_Reset_Model2',
        autoLoad: false,
        uniOpt : {
            isMaster: false,         // 상위 버튼 연결
            editable: false,         // 수정 모드 사용
            deletable: false,         // 삭제 가능
            useNavi : false         // prev | newxt 버튼 사용
        },
        proxy: directProxy4,
        loadStoreRecords : function() {
            var param= Ext.getCmp('resultForm').getValues();
            console.log( param );
            this.load({
                params : param,
				callback : function(records,options,success) {
					if(success) {
						Ext.each(directResetStore2.data.items, function(rec, i){
							UniAppManager.app.onNewDataButtonDown2('s_zcc200ukrv_kdGrid2', rec.get('GUBUN_CODE'), '2');
		        		});
					}
				}
            });
        },
        saveStore : function() {

        },
        listeners:{
            load: function(store, records, successful, eOpts) {

            }
        }
    });     // End of var directMasterStore1 = Unilite.createStore('s_zcc200ukrv_kdMasterStore2',{

    var subForm = Unilite.createSearchForm('subForm', {
        region: 'center',
        layout : {type : 'uniTable', columns : 5, tableAttrs: {width: '99.5%'}},
        padding:'1 1 1 1',
        border:true,
        items: [{
            fieldLabel: '③제조원가(①+②)',
            name: 'T3',
            xtype: 'uniNumberfield',
            value: 0,
            readOnly: true,
            labelWidth:120
        },{
			xtype: 'container',
			layout: { type: 'uniTable', columns: 2},
			defaultType: 'uniTextfield',
          	padding: '0 0 0 0',
			items:[{
                fieldLabel: '④관리',
				name:'T4',
				xtype:'uniNumberfield',
				decimalPrecision: 0,
				format:'0,000',
            	readOnly: true
			},{
                name:'T4_1',
                xtype: 'uniNumberfield',
                decimalPrecision: 0,
                width: 50,
                readOnly: false,
				suffixTpl:'%',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						UniAppManager.app.fnCalcFormTotal(newValue, subForm.getValue('T6_1'));
						
						panelResult.setValue('T4_1',newValue);
					}
				}
            }]
        },{
			xtype: 'container',
			layout: { type: 'uniTable', columns: 2},
			defaultType: 'uniTextfield',
          	padding: '0 0 0 0',
//          	colspan:3,
			items:[{
                fieldLabel: '⑥이윤',
				name:'T6',
				xtype:'uniNumberfield',
				decimalPrecision: 0,
				format:'0,000',
            	readOnly: true
			},{
                name:'T6_1',
                xtype: 'uniNumberfield',
                decimalPrecision: 0,
                width: 50,
                readOnly: false,
				suffixTpl:'%',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						UniAppManager.app.fnCalcFormTotal(subForm.getValue('T4_1'), newValue);
						
						panelResult.setValue('T6_1',newValue);
					}
				}
            }]
        },
        {
			xtype: 'container',
			layout: { type: 'uniTable', columns: 5},
          	padding: '0 0 0 0',
          	tdAttrs: {align: 'right'},
//      		margin: '0 10 0 50',
          	defaults:{
//          		rowspan:2
//	          	padding: '0 0 20 0'
          		labelAlign: 'top',
            	readOnly: true,
            	width:100
          		
          	},
          	rowspan:2,
			items:[{
                fieldLabel: '원가구성',
				name:'T8',
				xtype:'uniNumberfield',
				decimalPrecision: 0,
				format:'0,000',
				suffixTpl:'%'
			},{
                fieldLabel: '재료비',
				name:'T9',
				xtype:'uniNumberfield',
				decimalPrecision: 0,
				format:'0,000',
				suffixTpl:'%'
			},{
                fieldLabel: '가공비',
				name:'T10',
				xtype:'uniNumberfield',
				decimalPrecision: 0,
				format:'0,000',
				suffixTpl:'%'
			},{
                fieldLabel: '관리/이윤',
				name:'T11',
				xtype:'uniNumberfield',
				decimalPrecision: 0,
				format:'0,000',
				suffixTpl:'%'
			}]
        },
        {
            width: 100,
            xtype: 'button',
            text: '내역생성',
            tdAttrs: {align: 'right'},
            handler: function() {
                var param = panelResult.getValues();

                if(panelResult.setAllFieldsReadOnly(true) == false) {
                    return false;
                } else {
                	if (fnDataExistCheck()) {
                		return false;
                    }
                    //신규이나, 이미 생성하였거나 행이 있는 경우 체크
                    if(masterGrid.getStore().getCount() != 0 || masterGrid2.getStore().getCount() != 0) {

                    	if(confirm('이미 입력중인 항목이 존재합니다. 내역을 재생성하시겠습니까?')) {

                        	var paramDelete = {
								"COMP_CODE": UserInfo.compCode,
								"EST_NUM": panelResult.getValue('EST_NUM')
							};
                        s_zcc200ukrv_kdService.deleteDetail_t(paramDelete,function(provider, response) { });

			                masterGrid.getStore().loadData({});
			                masterGrid2.getStore().loadData({});

                            s_zcc200ukrv_kdService.createList1(param,function(provider, response){
                                    panelResult.setAllFieldsReadOnly(true)
                                    var records = response.result;
//                                        masterGrid.reset();
                                    Ext.each(records, function(record, i) {
                                        var compCode    = UserInfo.compCode;
                                        var divCode     = panelResult.getValue('DIV_CODE');
                                        var estNum      = panelResult.getValue('EST_NUM');
                                        var est_seq     = directMasterStore1.max('EST_SEQ');
                                             if(!est_seq) est_seq = 1;
                                             else est_seq += 1;

                                        var r = {
                                            'COMP_CODE'     : compCode,
                                            'DIV_CODE'      : divCode,
                                            'EST_NUM'       : estNum,
                                            'EST_SEQ'       : est_seq
                                        };
                                        masterGrid.createRow(r);
                                        masterGrid.setProviderData(record);
                                    });
                                })
                            s_zcc200ukrv_kdService.createList2(param,function(provider, response) {
                                    panelResult.setAllFieldsReadOnly(true)
                                    var records = response.result;
//                                        masterGrid2.reset();
                                    Ext.each(records, function(record, i) {
                                        var compCode    = UserInfo.compCode;
                                        var divCode     = panelResult.getValue('DIV_CODE');
                                        var estNum      = panelResult.getValue('EST_NUM');

                                        if(i == 0) {
                                            var est_seq     = directMasterStore1.max('EST_SEQ');
                                            if(!est_seq) est_seq = 1;
                                            else est_seq += 1;
                                        } else {
                                            var est_seq     = directMasterStore2.max('EST_SEQ');
                                            if(!est_seq) est_seq = 1;
                                            else est_seq += 1;
                                        }

                                        var r = {
                                            'COMP_CODE'     : compCode,
                                            'DIV_CODE'      : divCode,
                                            'EST_NUM'       : estNum,
                                            'EST_SEQ'       : est_seq
                                        };
                                        masterGrid2.createRow(r);
                                        masterGrid2.setProviderData(record);
                                    });
                                })
                                
                                panelResult.setValue('T4_1',10);
                                panelResult.setValue('T6_1',8);
                                subForm.setValue('T4_1',10);
                                subForm.setValue('T6_1',8);
                                
                                
                        } else {
                            return false;
                        }
                    }
                    //CHECK END






                    else {
                        s_zcc200ukrv_kdService.createList1(param,
                            function(provider, response) {
                                panelResult.setAllFieldsReadOnly(true)
                                var records = response.result;
                                
        						masterGrid.getStore().loadData({});
        
                                Ext.each(records, function(record, i) {
                                    var compCode    = UserInfo.compCode;
                                    var divCode     = panelResult.getValue('DIV_CODE');
                                    var estNum      = panelResult.getValue('EST_NUM');
                                    var est_seq     = directMasterStore1.max('EST_SEQ');
                                         if(!est_seq) est_seq = 1;
                                         else est_seq += 1;

                                    var r = {
                                        'COMP_CODE'     : compCode,
                                        'DIV_CODE'      : divCode,
                                        'EST_NUM'       : estNum,
                                        'EST_SEQ'       : est_seq
                                    };
                                    masterGrid.createRow(r);
                                    masterGrid.setProviderData(record);
                                });
                            }
                        )
                        s_zcc200ukrv_kdService.createList2(param,
                            function(provider, response) {
                                panelResult.setAllFieldsReadOnly(true)
                                var records = response.result;
                                
				                masterGrid2.getStore().loadData({});
                                Ext.each(records, function(record, i) {
                                    var compCode    = UserInfo.compCode;
                                    var divCode     = panelResult.getValue('DIV_CODE');
                                    var estNum      = panelResult.getValue('EST_NUM');

                                    if(i == 0) {
                                        var est_seq     = directMasterStore1.max('EST_SEQ');
                                        if(!est_seq) est_seq = 1;
                                        else est_seq += 1;
                                    } else {
                                        var est_seq     = directMasterStore2.max('EST_SEQ');
                                        if(!est_seq) est_seq = 1;
                                        else est_seq += 1;
                                    }

                                    var r = {
                                        'COMP_CODE'     : compCode,
                                        'DIV_CODE'      : divCode,
                                        'EST_NUM'       : estNum,
                                        'EST_SEQ'       : est_seq
                                    };
                                    masterGrid2.createRow(r);
                                    masterGrid2.setProviderData(record);
                                });
                            }
                        )
                        
                        panelResult.setValue('T4_1',10);
                        panelResult.setValue('T6_1',8);
                        subForm.setValue('T4_1',10);
                        subForm.setValue('T6_1',8);
                    }
                }
            }
        },
        
        {
            xtype: 'component',
            width: 50
        },{
            fieldLabel: '⑤소계(③+④)',
            name: 'T5',
            xtype: 'uniNumberfield',
            value: 0,
            readOnly: true
        },{
//            fieldLabel: '<div style = "font-weight:bold">⑦총합계(⑤+⑥)</div>',
            fieldLabel: '⑦총합계(⑤+⑥)',
            name: 'T7',
            xtype: 'uniNumberfield',
            value: 0,
            readOnly: true,
            fieldStyle: 'font-weight:bold'
        }]
    });    
    
    
    
    
    
    
    
    
    
    
    
    
    /*
    
    
    
    var subForm = Unilite.createSearchForm('subForm', {
        region: 'center',
        layout : {type : 'uniTable', columns : 5, tableAttrs: {width: '99.5%'}},
        padding:'1 1 1 1',
        border:true,
        items: [{
                    fieldLabel: '재료비합',
                    name: 'TOTAL1',
                    xtype: 'uniNumberfield',
                    value: 0,
                    readOnly: true
                },{
                    fieldLabel: '가공비합',
                    name: 'TOTAL2',
                    xtype: 'uniNumberfield',
                    value: 0,
                    readOnly: true
                },{
                    fieldLabel: '제조원가',
                    name: 'TOTAL3',
                    xtype: 'uniNumberfield',
                    value: 0,
                    readOnly: true
                },{
                    fieldLabel: '총합계',
                    name: 'TOTAL_ALL',
                    xtype: 'uniNumberfield',
                    value: 0,
                    readOnly: true
                },{
                    width: 100,
                    xtype: 'button',
                    text: '내역생성',
                    tdAttrs: {align: 'right'},
                    handler: function() {
                        var param = panelResult.getValues();

                        if(panelResult.setAllFieldsReadOnly(true) == false) {
                            return false;
                        } else {
                        	if (fnDataExistCheck()) {
                        		return false;
                            }
                            //신규이나, 이미 생성하였거나 행이 있는 경우 체크
                            if(masterGrid.getStore().getCount() != 0 || masterGrid2.getStore().getCount() != 0) {

                            	if(confirm('이미 입력중인 항목이 존재합니다. 내역을 재생성하시겠습니까?')) {

                                	var paramDelete = {
										"COMP_CODE": UserInfo.compCode,
										"EST_NUM": panelResult.getValue('EST_NUM')
									};
                                s_zcc200ukrv_kdService.deleteDetail_t(paramDelete,function(provider, response) { });

					                masterGrid.getStore().loadData({});
					                masterGrid2.getStore().loadData({});

                                    s_zcc200ukrv_kdService.createList1(param,function(provider, response){
                                            panelResult.setAllFieldsReadOnly(true)
                                            var records = response.result;
    //                                        masterGrid.reset();
                                            Ext.each(records, function(record, i) {
                                                var compCode    = UserInfo.compCode;
                                                var divCode     = panelResult.getValue('DIV_CODE');
                                                var estNum      = panelResult.getValue('EST_NUM');
                                                var est_seq     = directMasterStore1.max('EST_SEQ');
                                                     if(!est_seq) est_seq = 1;
                                                     else est_seq += 1;

                                                var r = {
                                                    'COMP_CODE'     : compCode,
                                                    'DIV_CODE'      : divCode,
                                                    'EST_NUM'       : estNum,
                                                    'EST_SEQ'       : est_seq
                                                };
                                                masterGrid.createRow(r);
                                                masterGrid.setProviderData(record);
                                            });
                                        })
                                    s_zcc200ukrv_kdService.createList2(param,function(provider, response) {
                                            panelResult.setAllFieldsReadOnly(true)
                                            var records = response.result;
    //                                        masterGrid2.reset();
                                            Ext.each(records, function(record, i) {
                                                var compCode    = UserInfo.compCode;
                                                var divCode     = panelResult.getValue('DIV_CODE');
                                                var estNum      = panelResult.getValue('EST_NUM');

                                                if(i == 0) {
                                                    var est_seq     = directMasterStore1.max('EST_SEQ');
                                                    if(!est_seq) est_seq = 1;
                                                    else est_seq += 1;
                                                } else {
                                                    var est_seq     = directMasterStore2.max('EST_SEQ');
                                                    if(!est_seq) est_seq = 1;
                                                    else est_seq += 1;
                                                }

                                                var r = {
                                                    'COMP_CODE'     : compCode,
                                                    'DIV_CODE'      : divCode,
                                                    'EST_NUM'       : estNum,
                                                    'EST_SEQ'       : est_seq
                                                };
                                                masterGrid2.createRow(r);
                                                masterGrid2.setProviderData(record);
                                            });
                                        })
                                } else {
                                    return false;
                                }
                            }
                            //CHECK END






                            else {
                                s_zcc200ukrv_kdService.createList1(param,
                                    function(provider, response) {
                                        panelResult.setAllFieldsReadOnly(true)
                                        var records = response.result;
                                        
                						masterGrid.getStore().loadData({});
                
                                        Ext.each(records, function(record, i) {
                                            var compCode    = UserInfo.compCode;
                                            var divCode     = panelResult.getValue('DIV_CODE');
                                            var estNum      = panelResult.getValue('EST_NUM');
                                            var est_seq     = directMasterStore1.max('EST_SEQ');
                                                 if(!est_seq) est_seq = 1;
                                                 else est_seq += 1;

                                            var r = {
                                                'COMP_CODE'     : compCode,
                                                'DIV_CODE'      : divCode,
                                                'EST_NUM'       : estNum,
                                                'EST_SEQ'       : est_seq
                                            };
                                            masterGrid.createRow(r);
                                            masterGrid.setProviderData(record);
                                        });
                                    }
                                )
                                s_zcc200ukrv_kdService.createList2(param,
                                    function(provider, response) {
                                        panelResult.setAllFieldsReadOnly(true)
                                        var records = response.result;
                                        
						                masterGrid2.getStore().loadData({});
                                        Ext.each(records, function(record, i) {
                                            var compCode    = UserInfo.compCode;
                                            var divCode     = panelResult.getValue('DIV_CODE');
                                            var estNum      = panelResult.getValue('EST_NUM');

                                            if(i == 0) {
                                                var est_seq     = directMasterStore1.max('EST_SEQ');
                                                if(!est_seq) est_seq = 1;
                                                else est_seq += 1;
                                            } else {
                                                var est_seq     = directMasterStore2.max('EST_SEQ');
                                                if(!est_seq) est_seq = 1;
                                                else est_seq += 1;
                                            }

                                            var r = {
                                                'COMP_CODE'     : compCode,
                                                'DIV_CODE'      : divCode,
                                                'EST_NUM'       : estNum,
                                                'EST_SEQ'       : est_seq
                                            };
                                            masterGrid2.createRow(r);
                                            masterGrid2.setProviderData(record);
                                        });
                                    }
                                )
                            }
                        }
                    }
                },{
    				xtype: 'component',
    				width: 182
    				//tdAttrs: {style: 'border-bottom: 1px solid #cccccc; padding-top: 0px; padding-bottom: 4px'  }
    			},{
                    fieldLabel: '이익률',
                    name: 'PROFIT_RATE',
                    xtype: 'uniNumberfield',
                    value: 0,
                    decimalPrecision: 2,
	                suffixTpl:'&nbsp;%',
                    readOnly: false,
	                listeners: {
		              	change: function(field, newValue, oldValue, eOpts) {
		              		UniAppManager.app.fnCalcFormTotal();
						}
					}
                },{
                    fieldLabel: '관리',
                    name: 'TOTAL4',
                    xtype: 'uniNumberfield',
                    value: 0,
                    colspan: 2,
                    readOnly: true
                },{
                    width: 100,
                    xtype: 'button',
                    text: '출력',
                    tdAttrs: {align: 'right'},
                    handler: function() {
                        var param = panelResult.getValues();

                        if(Ext.isEmpty(panelResult.getValue('EST_NUM'))) {
                            alert('견적번호가 존재하지 않습니다.');
                            return false;
                        }
                        UniAppManager.app.requestApprove();
                    }
                 }],
         		listeners: {
        			uniOnChange: function(basicForm, dirty, eOpts) {
        				if(basicForm.isDirty()){
        					UniAppManager.setToolbarButtons('save', true);
        				}
        			}
        		}
        });
*/
    /**
     * Master Grid1 정의(Grid Panel)
     * @type
     */
    var masterGrid = Unilite.createGrid('s_zcc200ukrv_kdGrid1', {
        sortableColumns : false,
        layout: 'fit',
        region: 'center',
        flex: 2,
        title : '재료비',
        uniOpt:{    expandLastColumn: false,
                    useRowNumberer: true,
                    useMultipleSorting: true,       //순번표시
                    copiedRow: false
        },
        store: directMasterStore1,
        features: [{		
			id: 'masterGridSubTotal', 
			ftype: 'uniGroupingsummary', 
			showSummaryRow: false
		},{
			id: 'masterGridTotal', 
			ftype: 'uniSummary', 
			showSummaryRow: true
		}],
        columns: [
            {dataIndex : 'COMP_CODE',     width :100, hidden : true},
            {dataIndex : 'DIV_CODE',      width :100, hidden : true},
            {dataIndex : 'EST_NUM',       width :100, hidden : true},
            {dataIndex : 'EST_SEQ',       width :70, hidden : true},
            {dataIndex : 'GUBUN_CODE',    width :100,
            	summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '', '①재료비 소계');
            	}
        	},
            {dataIndex : 'JAEGIL',        width :100},
            {dataIndex : 'STOCK_UNIT',    width :100,
                editor : {
                    xtype:'uniCombobox',
                    store:Ext.data.StoreManager.lookup('CBS_AU_B013'),
                    listeners:{
                        beforequery: function(queryPlan, eOpts) {
                            var store = queryPlan.combo.getStore();

                            store.clearFilter(true);
                            queryPlan.combo.queryFilter = null;

                            store.filterBy(function(record, id) {
                               if(record.get('value') == 'EA' || record.get('value') == 'KG' || record.get('value') == 'HT' || record.get('value') == '') {
                                  return record;
                               } else {
                                  return null;
                               }
                            });
                        }
                    }
                }
            },
            {dataIndex : 'GARO_NUM',      width :100},
            {dataIndex : 'SERO_NUM',      width :100},
            {dataIndex : 'DUGE_NUM',      width :100},
            {dataIndex : 'UNIT_Q',        width :100},
            {dataIndex : 'QTY_HH',        width :100},
            {dataIndex : 'PRICE_RATE',    width :100},
            {dataIndex : 'AMT_O',         width :100,summaryType:'sum',
            	summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData,metaData,'<div align="right">'+Ext.util.Format.number(value, '0,000')+'</div>','<div align="right">'+Ext.util.Format.number(value, '0,000')+'</div>');
            	}
            },
            {dataIndex : 'REMARK',        width :100}
        
        
        /*
            {dataIndex : 'EST_NUM',             width :150, hidden : true},
            {dataIndex : 'COMP_CODE',           width :100, hidden : true},
            {dataIndex : 'DIV_CODE',            width :140, hidden : true},
            {dataIndex : 'EST_SEQ',             width :70,  hidden : true},
            {dataIndex : 'GUBUN',               width :100, hidden : true},
            {dataIndex : 'GUBUN_CODE',          width :130,
            	summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '', '재료비 소계');
            	}
            },
            {dataIndex : 'JAEGIL',              width :100},
            {dataIndex : 'UNIT_Q',              width :100},
            {dataIndex : 'STOCK_UNIT',          width :90,
                editor : {
                    xtype:'uniCombobox',
                    store:Ext.data.StoreManager.lookup('CBS_AU_B013'),
                    listeners:{
                        beforequery: function(queryPlan, eOpts) {
                            var store = queryPlan.combo.getStore();

                            store.clearFilter(true);
                            queryPlan.combo.queryFilter = null;

                            store.filterBy(function(record, id) {
                               if(record.get('value') == 'EA' || record.get('value') == 'KG' || record.get('value') == 'HT' || record.get('value') == '') {
                                  return record;
                               } else {
                                  return null;
                               }
                            });
                        }
                    }
                }
            },
            {dataIndex : 'QTY_HH',              width :100},
            {dataIndex : 'PRICE_RATE',          width :100},
            {dataIndex : 'AMT_O',               width :100,summaryType:'sum'},
            {dataIndex : 'GARO_NUM',            width :100},
            {dataIndex : 'SERO_NUM',            width :100},
            {dataIndex : 'DUGE_NUM',            width :100},
            {dataIndex : 'REMARK',              width :120},
            {dataIndex : 'REF_CODE1',           width :100, hidden : true}*/
        ],
        listeners: {
            select: function() {
                selectedGrid = 's_zcc200ukrv_kdGrid1';
            },
            cellclick: function() {
                selectedGrid = 's_zcc200ukrv_kdGrid1';
            },
            render: function(grid, eOpts) {
                var girdNm = grid.getItemId();
                grid.getEl().on('click', function(e, t, eOpt) {
                    selectedGrid = 's_zcc200ukrv_kdGrid1';
                });
            },
            beforeedit  : function( editor, e, eOpts ) {
            	if(e.record.data.STOCK_UNIT =='KG'){
            		if(UniUtils.indexOf(e.field, ['GUBUN_CODE', 'JAEGIL','STOCK_UNIT','GARO_NUM', 'SERO_NUM', 'DUGE_NUM', 'UNIT_Q', 'PRICE_RATE','REMARK'])){
                        return true;
                    }else{
                    	return false;
                    }
            	}else if(e.record.data.STOCK_UNIT =='EA'){
            		if(UniUtils.indexOf(e.field, ['GUBUN_CODE', 'JAEGIL','STOCK_UNIT','UNIT_Q', 'PRICE_RATE','REMARK'])){
                        return true;
                    }else{
                    	return false;
                    }
            	}else if(e.record.data.STOCK_UNIT =='HT'){
            		if(UniUtils.indexOf(e.field, ['GUBUN_CODE', 'JAEGIL','STOCK_UNIT','QTY_HH', 'PRICE_RATE','REMARK'])){
                        return true;
                    }else{
                    	return false;
                    }
            	}else if(e.record.data.STOCK_UNIT ==''){
            		if(UniUtils.indexOf(e.field, ['GUBUN_CODE', 'JAEGIL','STOCK_UNIT','AMT_O', 'REMARK'])){
                        return true;
                    }else{
                    	return false;
                    }
            	}else{
            		if(UniUtils.indexOf(e.field, ['GUBUN_CODE', 'JAEGIL','STOCK_UNIT'])){
                        return true;
                    }else{
                    	return false;
                    }
            	}
            	
            	
            	
            	
            	/*if(e.record.data.GUBUN_CODE =='18'){
                	
                    if(UniUtils.indexOf(e.field, ['QTY_HH', 'PRICE_RATE'])) {
                        return true;
                    }else{
                    	return false;	
                    }

                }else{
            	
	                if(!e.record.phantom) {
	                    if(UniUtils.indexOf(e.field, ['GUBUN', 'GUBUN_CODE', 'JAEGIL', 'STOCK_UNIT', 'REMARK']))
	                    {
	                        return true;
	                    }
	                    if(UniUtils.indexOf(e.field, ['GARO_NUM', 'SERO_NUM', 'DUGE_NUM'])) {
	                        if(e.record.data.STOCK_UNIT == 'KG') {
	                            return true;
	                        } else {
	                            return false;
	                        }
	                    }
	                    if(UniUtils.indexOf(e.field, ['UNIT_Q', 'PRICE_RATE'])) {
	                        if(e.record.data.STOCK_UNIT == 'EA' || e.record.data.STOCK_UNIT == 'KG') {
	                            return true;
	                        } else {
	                            return false;
	                        }
	                    }
	                    if(UniUtils.indexOf(e.field, ['AMT_O'])) {
	                        if(Ext.isEmpty(e.record.data.STOCK_UNIT)) {
	                            return true;
	                        } else {
	                            return false;
	                        }
	                    }
	                    if(UniUtils.indexOf(e.field, ['QTY_HH', 'DIV_CODE', 'EST_SEQ'])) {
	                        return false;
	                    }
	
	                } else {
	                    if(UniUtils.indexOf(e.field, ['GUBUN', 'GUBUN_CODE', 'JAEGIL', 'STOCK_UNIT', 'REMARK']))
	                    {
	                        return true;
	                    }
	                    if(UniUtils.indexOf(e.field, ['GARO_NUM', 'SERO_NUM', 'DUGE_NUM'])) {
	                        if(e.record.data.STOCK_UNIT == 'KG') {
	                            return true;
	                        } else {
	                            return false;
	                        }
	                    }
	                    if(UniUtils.indexOf(e.field, ['UNIT_Q', 'PRICE_RATE'])) {
	                        if(e.record.data.STOCK_UNIT == 'EA' || e.record.data.STOCK_UNIT == 'KG') {
	                            return true;
	                        } else {
	                            return false;
	                        }
	                    }
	                    if(UniUtils.indexOf(e.field, ['AMT_O'])) {
	                        if(Ext.isEmpty(e.record.data.STOCK_UNIT)) {
	                            return true;
	                        } else {
	                            return false;
	                        }
	                    }
	                    if(UniUtils.indexOf(e.field, ['QTY_HH', 'DIV_CODE', 'EST_SEQ'])) {
	                        return false;
	                    }
	
	                }
                
                }*/
                
                
            }, edit : function(editor, e) {
                var fieldName = e.field;

                if(fieldName == 'JAEGIL') {
                   if(Ext.isEmpty(e.record.get('GUBUN_CODE'))) {
                        alert("부품명을 먼저 입력하십시오.");
                        e.record.set('JAEGIL', '');
                        return false;
                   }
                }
                
//                fnCalcGrid1Value();
//                if(e.record.get('GUBUN_CODE') == '18'){
//                	return false;
//                }else {                
//	                if(fieldName == 'GARO_NUM' || fieldName == 'SERO_NUM' || fieldName == 'DUGE_NUM' || fieldName == 'UNIT_Q' || fieldName == 'PRICE_RATE') {
//	                    fnCalcGrid1Value();
//                    	return false;
//                	}
//                }
            }
        },
        setProviderData: function(record) {
            var grdRecord = this.getSelectedRecord();
            grdRecord.set('GUBUN'                  , record['GUBUN']);
            grdRecord.set('GUBUN_CODE'             , record['GUBUN_CODE']);
            grdRecord.set('REF_CODE1'              , record['REF_CODE1']);
            grdRecord.set('STOCK_UNIT'              , record['STOCK_UNIT']);
        }
    });//End of var masterGrid = Unilite.createGrid('s_zcc200ukrv_kdGrid1', {

    var masterGrid2 = Unilite.createGrid('s_zcc200ukrv_kdGrid2', {
        sortableColumns : false,
        layout: 'fit',
        region: 'south',
        split: true,
        flex:1,
        title : '가공비',
        uniOpt:{    
        	expandLastColumn: false,
	        useRowNumberer: true,
	        useMultipleSorting: true,
	        copiedRow: true
        },
        store: directMasterStore2,
        features: [{		
			id: 'masterGridSubTotal', 
			ftype: 'uniGroupingsummary', 
			showSummaryRow: false
		},{
			id: 'masterGridTotal', 
			ftype: 'uniSummary', 
			showSummaryRow: true
		}],
        columns: [
            {dataIndex : 'EST_NUM',             width :150, hidden : true},
            {dataIndex : 'COMP_CODE',           width :100, hidden : true},
            {dataIndex : 'DIV_CODE',            width :140, hidden : true},
            {dataIndex : 'EST_SEQ',             width :70,  hidden : true},
            {dataIndex : 'GUBUN',               width :100, hidden : true},
            {dataIndex : 'GUBUN_CODE',          width :130,
            	summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '', '②가공비 소계');
            	}
            },
            {dataIndex : 'QTY_HH',              width :100},
            {dataIndex : 'PRICE_RATE',          width :100},
            {dataIndex : 'AMT_O',               width :100,summaryType:'sum',
            	summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData,metaData,'<div align="right">'+Ext.util.Format.number(value, '0,000')+'</div>','<div align="right">'+Ext.util.Format.number(value, '0,000')+'</div>');
            	}
            },
            {dataIndex : 'REMARK',              width :120}
        ],
        listeners: {
            select: function() {
                selectedGrid = 's_zcc200ukrv_kdGrid2';
            },
            cellclick: function() {
                selectedGrid = 's_zcc200ukrv_kdGrid2';
            },
            render: function(grid, eOpts) {
                var girdNm = grid.getItemId();
                grid.getEl().on('click', function(e, t, eOpt) {
                    selectedGrid = 's_zcc200ukrv_kdGrid2';
                });
            },
            beforeedit  : function( editor, e, eOpts ) {
                if(!e.record.phantom) {
                    if(UniUtils.indexOf(e.field, ['GUBUN', 'GUBUN_CODE', 'QTY_HH', 'PRICE_RATE', 'REMARK']))
                    {
                        return true;
                    } else {
                        return false;
                    }
                } else {
                    if(UniUtils.indexOf(e.field, ['GUBUN', 'GUBUN_CODE', 'QTY_HH', 'PRICE_RATE', 'REMARK']))
                    {
                        return true;
                    } else {
                        return false;
                    }
                }
            } 
            
            
//            edit : function(editor, e) {
//                var fieldName = e.field;
//
//                if(fieldName == 'QTY_HH' || fieldName == 'PRICE_RATE') {
//                    fnCalcGrid2Value();
//                    return false;
//                }
//            }
        },
        setProviderData: function(record) {
            var grdRecord = this.getSelectedRecord();
            grdRecord.set('GUBUN'                  , record['GUBUN']);
            grdRecord.set('GUBUN_CODE'             , record['GUBUN_CODE']);
        }
    });//End of var masterGrid = Unilite.createGrid('s_zcc200ukrv_kdGrid1', {

    var estNumMasterGrid = Unilite.createGrid('estNumMasterGrid', {     // 검색 팝업창
        // title: '기본',
        layout : 'fit',
        store: estNumMasterStore,
        uniOpt:{
            useRowNumberer: false
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
        selModel: 'rowmodel',
        columns:  [
            {dataIndex : 'COMP_CODE',                width : 100,hidden:true},
            {dataIndex : 'DIV_CODE',                 width : 100,hidden:true},
            {dataIndex : 'EST_DATE',                 width : 100},
            {dataIndex : 'EST_NUM',                  width : 100
//            	summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
//			       return Unilite.renderSummaryRow(summaryData, metaData, '', '합계');
//            	}
            },
            {dataIndex : 'CUSTOM_CODE',              width : 100},
            {dataIndex : 'CUSTOM_NAME',              width : 200},
            {dataIndex : 'ITEM_CODE',                width : 100},
            {dataIndex : 'ITEM_NAME',                width : 200},
            {dataIndex : 'CAR_TYPE',                 width : 100},
            {dataIndex : 'PROG_WORK_NAME',           width : 100},
            {dataIndex : 'CALC1',                    width : 100,summaryType:'sum'
//            	summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
//			       return Unilite.renderSummaryRow(summaryData,metaData,'<div align="right">'+Ext.util.Format.number(value, '0,000')+'</div>','<div align="right">'+Ext.util.Format.number(value, '0,000')+'</div>');
//            	}
            },
            {dataIndex : 'CALC2',                    width : 100,summaryType:'sum'
//            	summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
//			       return Unilite.renderSummaryRow(summaryData,metaData,'<div align="right">'+Ext.util.Format.number(value, '0,000')+'</div>','<div align="right">'+Ext.util.Format.number(value, '0,000')+'</div>');
//            	}
            },
            {dataIndex : 'CALC3',                    width : 100,summaryType:'sum'
//            	summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
//			       return Unilite.renderSummaryRow(summaryData,metaData,'<div align="right">'+Ext.util.Format.number(value, '0,000')+'</div>','<div align="right">'+Ext.util.Format.number(value, '0,000')+'</div>');
//            	}
            },
            {dataIndex : 'REMARK',                   width : 250},
            {dataIndex : 'DEPT_NAME',                width : 100},
            {dataIndex : 'PERSON_NAME',              width : 100}
        ],
        listeners: {
            onGridDblClick:function(grid, record, cellIndex, colName) {
                if(estNumSearch.setAllFieldsReadOnly(true) == false) {
                    return false;
                } else {
                    estNumMasterGrid.returnData(record);
                    UniAppManager.app.onQueryButtonDown();
                    SearchEstNumWindow.hide();
                }
            }
        },
        returnData: function(record)   {
            if(Ext.isEmpty(record)) {
                record = this.getSelectedRecord();
            }
            panelResult.setValues({'DIV_CODE'       : record.get('DIV_CODE')});
            panelResult.setValues({'EST_NUM'        : record.get('EST_NUM')});
            panelResult.setValues({'EST_DATE'       : record.get('EST_DATE')});
            panelResult.setValues({'CUSTOM_CODE'    : record.get('CUSTOM_CODE')});
            panelResult.setValues({'CUSTOM_NAME'    : record.get('CUSTOM_NAME')});
            panelResult.setValues({'ITEM_CODE'      : record.get('ITEM_CODE')});
            panelResult.setValues({'ITEM_NAME'      : record.get('ITEM_NAME')});
            
            panelResult.setValues({'CAR_TYPE'       : record.get('CAR_TYPE')});
            panelResult.setValues({'PROG_WORK_NAME' : record.get('PROG_WORK_NAME')});
            panelResult.setValues({'TREE_CODE'      : record.get('DEPT_CODE')});
            panelResult.setValues({'TREE_NAME'      : record.get('DEPT_NAME')});
            panelResult.setValues({'PERSON_NUMB'    : record.get('PERSON_NUMB')});
            panelResult.setValues({'PERSON_NAME'    : record.get('PERSON_NAME')});
            panelResult.setValues({'REMARK_M'       : record.get('REMARK')});
            
            panelResult.setValues({'T4_1'       : record.get('T4_1')});
            panelResult.setValues({'T6_1'       : record.get('T6_1')});
            
            
            subForm.setValues({'T4_1'       : record.get('T4_1')});
            subForm.setValues({'T6_1'       : record.get('T6_1')});

//            subForm.setValues({'MATRL_COST'     : record.get('MATRL_COST')});
//            subForm.setValues({'PROCESS_COST'   : record.get('PROCESS_COST')});
//            subForm.setValues({'TOTAL4'      	: record.get('MNGM_COST')});
//            subForm.setValues({'PROFIT_RATE'    : record.get('PROFIT_RATE')});
        }
    });

    function openSearchEstNumWindow() {   // 검색 팝업창
        if(!SearchEstNumWindow) {
            SearchEstNumWindow = Ext.create('widget.uniDetailWindow', {
                title: '견적번호검색',
                width: 1080,
                height: 580,
                layout: {type:'vbox', align:'stretch'},
                items: [estNumSearch, estNumMasterGrid],
                tbar:  ['->',
                    {itemId : 'saveBtn',
                    text: '조회',
                    handler: function() {
                        if(estNumSearch.setAllFieldsReadOnly(true) == false) {
                            return false;
                        } else {
                            estNumMasterStore.loadStoreRecords();
                        }
                    },
                    disabled: false
                    }, {
                        itemId : 'OrderNoCloseBtn',
                        text: '닫기',
                        handler: function() {
                            SearchEstNumWindow.hide();
                        },
                        disabled: false
                    }
                ],
                listeners: {
                	beforehide: function(me, eOpt){
                        estNumSearch.clearForm();
                        estNumMasterGrid.getStore().loadData({});
                    },
                	
                    beforeshow: function( panel, eOpts ) {
                        estNumSearch.setValue('DIV_CODE',       panelResult.getValue('DIV_CODE'));
                        estNumSearch.setValue('EST_NUM',        panelResult.getValue('EST_NUM'));
                        estNumSearch.setValue('FR_EST_DATE',    UniDate.get('startOfMonth'));
                        estNumSearch.setValue('TO_EST_DATE',    UniDate.get('today'));

                        estNumMasterStore.loadStoreRecords();
                    }
                }
            })
        }
        SearchEstNumWindow.show();
        SearchEstNumWindow.center();
    }

    Unilite.Main( {
            borderItems:[{
            region:'center',
            layout: 'border',
            border : false,
            items:[
                panelResult,
                {
                    region : 'north',
                    xtype : 'container',
                    layout : 'fit',
                    items : [ subForm ]
                }
                , {
                    region : 'center',
                    xtype : 'container',
                    layout: {type: 'hbox', align: 'stretch'},
                    flex: 1,
                    items : [ masterGrid,  masterGrid2]
                }
            ]
        }
        ],
        id: 's_zcc200ukrv_kdApp',
        fnInitBinding: function() {
            UniAppManager.setToolbarButtons(['newData'], true);
            UniAppManager.setToolbarButtons(['prev', 'next'], false);
            panelResult.setValue('DIV_CODE', UserInfo.divCode);
            panelResult.setValue('MONEY_UNIT', BsaCodeInfo.gsMoneyUnit);
            panelResult.setValue('EXCHG_RATE_O', 1);
//            subForm.setValue('PROFIT_RATE', 10);
            panelResult.setValue('EST_DATE', UniDate.get('today'));
            UniAppManager.setToolbarButtons(['save'], false);
            masterUpdateFlag = '';
//            directResetStore1.loadStoreRecords();

        },
        onQueryButtonDown: function() {
            var estNum = panelResult.getValue('EST_NUM');
            if(Ext.isEmpty(estNum)) {
                openSearchEstNumWindow()
            } else {
                var param = panelResult.getValues();
                directMasterStore1.loadStoreRecords();
                directMasterStore2.loadStoreRecords();
                UniAppManager.setToolbarButtons(['reset','newData','deleteAll'], true);
                if(panelResult.setAllFieldsReadOnly(true) == false) {
                    return false;
                }
            };
        },
        setDefault: function() {        // 기본값
            panelResult.setValue('DIV_CODE'     , UserInfo.divCode);
            panelResult.setValue('MONEY_UNIT'   , BsaCodeInfo.gsMoneyUnit);
            panelResult.setValue('EXCHG_RATE_O' , 1);
            panelResult.setValue('EST_DATE'     , UniDate.get('today'));
			subForm.setValue('T3', 0);
            subForm.setValue('T4', 0);
            subForm.setValue('T4_1', 0);
            subForm.setValue('T5', 0);
            subForm.setValue('T6', 0);
            subForm.setValue('T6_1', 0);
            subForm.setValue('T7', 0);
            subForm.setValue('T8', 0);
            subForm.setValue('T9', 0);
            subForm.setValue('T10', 0);
            subForm.setValue('T11', 0);
//            subForm.setValue('TOTAL1'   , 0);
//            subForm.setValue('TOTAL2'   , 0);
//            subForm.setValue('TOTAL3'   , 0);
//            subForm.setValue('TOTAL4'   , 0);
//            subForm.setValue('TOTAL_ALL', 0);
//            subForm.setValue('PROFIT_RATE', 10);
            panelResult.getForm().wasDirty = false;
            panelResult.resetDirtyStatus();
            UniAppManager.setToolbarButtons('save', false);
            UniAppManager.setToolbarButtons(['reset'], true);
//            directResetStore1.loadStoreRecords();
            masterUpdateFlag = '';
        },
        onResetButtonDown: function() {     // 초기화
            this.suspendEvents();
            panelResult.clearForm();
            subForm.clearForm();
            masterGrid.getStore().loadData({});
            masterGrid2.getStore().loadData({});
            panelResult.setAllFieldsReadOnly(false);
            panelResult.setValue('EST_NUM', '');
            UniAppManager.setToolbarButtons(['reset','newData','save'], false);
            UniAppManager.setToolbarButtons(['newData'], true);
            UniAppManager.setToolbarButtons(['prev', 'next'], false);

            this.setDefault();
        },
        onNewDataButtonDown: function() {       // 행추가
            var param = panelResult.getValues();

            if(panelResult.setAllFieldsReadOnly(true) == false) {
                return false;
            }       // 행추가

            if(selectedGrid == 's_zcc200ukrv_kdGrid1') {
                var record = masterGrid.getSelectedRecord();
//                if(Ext.isEmpty(record)) {
//                   return false;
//                }
                var compCode    = UserInfo.compCode;
                var divCode     = panelResult.getValue('DIV_CODE');
                var estNum      = panelResult.getValue('EST_NUM');
//                var est_seq     = directMasterStore1.max('EST_SEQ');
//               if(!est_seq) est_seq = 1;
//               else est_seq += 1;
                
//                var est_seq     = record.get('EST_SEQ') + 1;
                if(directMasterStore1.max('EST_SEQ') > directMasterStore2.max('EST_SEQ')) {
                    var est_seq = directMasterStore1.max('EST_SEQ') + 1;
                } else if(directMasterStore1.max('EST_SEQ') < directMasterStore2.max('EST_SEQ')) {
                	var est_seq = directMasterStore2.max('EST_SEQ') + 1;
                } else {
                    var est_seq = directMasterStore1.max('EST_SEQ');
                        if(!est_seq) est_seq = 1;
                        else est_seq += 1;
                }
                var gubun       = '1';

                var r = {
                    'COMP_CODE' : compCode,
                    'DIV_CODE'  : divCode,
                    'EST_NUM'   : estNum,
                    'EST_SEQ'   : est_seq,
                    'GUBUN'     : gubun
                };
                masterGrid.createRow(r);
            }
            else if(selectedGrid == 's_zcc200ukrv_kdGrid2') {
                var record = masterGrid2.getSelectedRecord();

                var compCode    = UserInfo.compCode;
                var divCode     = panelResult.getValue('DIV_CODE');
                var estNum      = panelResult.getValue('EST_NUM');
//                var est_seq     = record.get('EST_SEQ') + 1;
                if(directMasterStore1.max('EST_SEQ') > directMasterStore2.max('EST_SEQ')) {
                    var est_seq = directMasterStore1.max('EST_SEQ') + 1;
                } else if(directMasterStore1.max('EST_SEQ') < directMasterStore2.max('EST_SEQ')) {
                    var est_seq = directMasterStore2.max('EST_SEQ') + 1;
                } else {
                    var est_seq = directMasterStore1.max('EST_SEQ');
                        if(!est_seq) est_seq = 1;
                        else est_seq += 1;
                }
                var gubun       = '2';

                var r = {
                    'COMP_CODE' : compCode,
                    'DIV_CODE'  : divCode,
                    'EST_NUM'   : estNum,
                    'EST_SEQ'   : est_seq,
                    'GUBUN'     : gubun
                };
                masterGrid2.createRow(r);
            }

            UniAppManager.setToolbarButtons(['reset'], true);
        },onNewDataButtonDown2: function(selectedGrid, gubunCode, gubun, refCode1) {       // 행추가
            var param = panelResult.getValues();

           /*  if(panelResult.setAllFieldsReadOnly(true) == false) {
                return false;
            }     */   // 행추가

            if(selectedGrid == 's_zcc200ukrv_kdGrid1') {
                var record = masterGrid.getSelectedRecord();
//                if(Ext.isEmpty(record)) {
//                   return false;
//                }
                var compCode    = UserInfo.compCode;
                var divCode     = panelResult.getValue('DIV_CODE');
                var estNum      = panelResult.getValue('EST_NUM');
//                var est_seq     = record.get('EST_SEQ') + 1;
                if(directMasterStore1.max('EST_SEQ') > directMasterStore2.max('EST_SEQ')) {
                    var est_seq = directMasterStore1.max('EST_SEQ') + 1;
                } else if(directMasterStore1.max('EST_SEQ') < directMasterStore2.max('EST_SEQ')) {
                	var est_seq = directMasterStore2.max('EST_SEQ') + 1;
                } else {
                    var est_seq = directMasterStore1.max('EST_SEQ');
                        if(!est_seq) est_seq = 1;
                        else est_seq += 1;
                }
                var gubun       = '1';

                var r = {
                    'COMP_CODE' : compCode,
                    'DIV_CODE'  : divCode,
                    'EST_NUM'   : estNum,
                    'EST_SEQ'   : est_seq,
                    'GUBUN'     : gubun,
                    'GUBUN_CODE': gubunCode,
                    'REF_CODE1' : refCode1
                };
                masterGrid.createRow(r);
            }
            else if(selectedGrid == 's_zcc200ukrv_kdGrid2') {
                var record = masterGrid2.getSelectedRecord();

                var compCode    = UserInfo.compCode;
                var divCode     = panelResult.getValue('DIV_CODE');
                var estNum      = panelResult.getValue('EST_NUM');
//                var est_seq     = record.get('EST_SEQ') + 1;
                if(directMasterStore1.max('EST_SEQ') > directMasterStore2.max('EST_SEQ')) {
                    var est_seq = directMasterStore1.max('EST_SEQ') + 1;
                } else if(directMasterStore1.max('EST_SEQ') < directMasterStore2.max('EST_SEQ')) {
                    var est_seq = directMasterStore2.max('EST_SEQ') + 1;
                } else {
                    var est_seq = directMasterStore1.max('EST_SEQ');
                        if(!est_seq) est_seq = 1;
                        else est_seq += 1;
                }
                var gubun       = '2';

                var r = {
                    'COMP_CODE' : compCode,
                    'DIV_CODE'  : divCode,
                    'EST_NUM'   : estNum,
                    'EST_SEQ'   : est_seq,
                    'GUBUN'     : gubun,
                    'GUBUN_CODE': gubunCode
                };
                masterGrid2.createRow(r);
            }

            UniAppManager.setToolbarButtons(['reset'], true);
        },
        onSaveDataButtonDown: function(config) {    // 저장 버튼
        	if(panelResult.setAllFieldsReadOnly(true) == false) {
            	return false;
        	}
        	var estNum = panelResult.getValue('EST_NUM');
            if(Ext.isEmpty(estNum)) {
                var param = panelResult.getValues();
                s_zcc200ukrv_kdService.selectMasterCheck(param, function(provider, response) {
                    console.log("dataCheckSave", response);
                    if(Ext.isEmpty(provider)) {
                    	if(directMasterStore1.isDirty()) {
                            directMasterStore1.saveStore();
                        }
//                        if(directMasterStore2.isDirty()) {
//                            directMasterStore2.saveStore();
//                        }
                    } else {
                        alert("중복된 견적번호가 입력되었습니다.");
                        return false;
                    }
                });
            } else {
                if(directMasterStore1.isDirty()) {
                    directMasterStore1.saveStore();
                    //masterGrid.reset();
                }
                if(!directMasterStore1.isDirty() && directMasterStore2.isDirty()) {
                    directMasterStore2.saveStore();
                    //masterGrid2.reset();
                }

                if(!directMasterStore1.isDirty() && !directMasterStore2.isDirty()) {
	                if(panelResult.isDirty()|| subForm.isDirty()) {
	                    //directMasterStore1.saveStore();

	                    var param = panelResult.getValues();   //syncAll 수정
				//            paramMaster.FLAG = masterUpdateFlag;
//		                      param.MATRL_COST   = subForm.getValue('TOTAL1');      //재료비
//		                      param.PROCESS_COST = subForm.getValue('TOTAL2');      //가공비
//		                      param.PROFIT_RATE  = subForm.getValue('PROFIT_RATE'); //이익률
//		                      param.MNGM_COST  	 = subForm.getValue('MNGM_COST');   //관리비
	                     s_zcc200ukrv_kdService.updateMasterInfo(param, function(provider, response) {
	                    	 if(provider){
								UniAppManager.app.onQueryButtonDown();
	                    	 }
		                });
	                    //panelResult.resetDirtyStatus();
	                }
                }
            }
        },
        onDeleteDataButtonDown: function() {
            var param = panelResult.getValues();

            if(selectedGrid == 's_zcc200ukrv_kdGrid1') {
                var record = masterGrid.getSelectedRecord();

                if(record.phantom === true) {
                    masterGrid.deleteSelectedRow();
                } else {
                    if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
                        masterGrid.deleteSelectedRow();
                    }
                }
            } else if(selectedGrid == 's_zcc200ukrv_kdGrid2') {
                var record = masterGrid2.getSelectedRecord();

                if(record.phantom === true) {
                    masterGrid2.deleteSelectedRow();
                } else {
                    if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
                        masterGrid2.deleteSelectedRow();
                    }
                }
            }

            if(directMasterStore1.isDirty() || directMasterStore2.isDirty()) {
            	UniAppManager.setToolbarButtons(['save'], true);
            } else if(!directMasterStore1.isDirty() && !directMasterStore2.isDirty()) {
                UniAppManager.setToolbarButtons(['save'], false);
            }

        },
        onDeleteAllButtonDown: function() {
        	if(!Ext.isEmpty(panelResult.getValue('EST_NUM'))){
	        	if(confirm('전체삭제 하시겠습니까?')) {
	            	var paramDelete = {
						"COMP_CODE": UserInfo.compCode,
						"EST_NUM": panelResult.getValue('EST_NUM')
					};
		            s_zcc200ukrv_kdService.deleteDetail_t(paramDelete,function(provider, response) {
		            	s_zcc200ukrv_kdService.deleteMaster_t(paramDelete,function(provider, response) {
		            		UniAppManager.updateStatus(UniUtils.getMessage('system.message.commonJS.store.saved','저장되었습니다.'));
	            			UniAppManager.app.onResetButtonDown();
		            	});
	            	});
	        	}	
        	}
        	
        	
    /*        var records = directMasterStore1.data.items;
            var records2 = directMasterStore2.data.items;
            var isNewData = false;
            Ext.each(records, function(record,i) {
                if(record.phantom){                     //신규 레코드일시 isNewData에 true를 반환
                    isNewData = true;
                }else{                                  //신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
                    isNewData = false;
                    if(confirm('전체삭제 하시겠습니까?')) {
                        var deletable = true;
                        ---------삭제전 로직 구현 시작----------

                        ---------삭제전 로직 구현 끝-----------

                        if(deletable){
			                masterGrid.reset();
			                masterGrid2.reset();
                            UniAppManager.app.onSaveDataButtonDown();
                        }
                    }
                    return false;
                }
            });
            subForm.clearForm();
            masterGrid.reset();
            masterGrid2.reset();
*/
        },
        fnCalcFormTotal: function(t4_1, t6_1, gubun, newValue) {
        	
        	var records1 = directMasterStore1.data.items;
        	
        	var records2 = directMasterStore2.data.items;
        	
//            var result1 = directMasterStore1.sumBy(function(record, id) {       // 합계를 가지고 값구하기
//                    return true;
//                },
//                ['AMT_O']
//            );
//            var result2 = directMasterStore2.sumBy(function(record, id) {       // 합계를 가지고 값구하기
//                    return true;
//                },
//                ['AMT_O']
//            );
            
            var t1 = 0;		//재료비 합
            var t2 = 0;		//가공비 합
            var t3 = 0;		//제조원가
            var t4 = 0;		//관리
            var t5 = 0;		//이윤
            var t6 = 0;		//소계
            var t7 = 0;		//총합계
            var t8 = 0;		//원가구성
            var t9 = 0;		//재료비
            var t10 = 0;		//가공비
            var t11 = 0;		//관리/이윤
            
            
            Ext.each(records1, function(record,i) {
        		t1 = t1 + record.get('AMT_O');
        	});
        	   Ext.each(records2, function(record,i) {
        		t2 = t2 + record.get('AMT_O');
        	});
        	
        	if(gubun == '1'){
        		t1 = t1 + newValue;	
        	}else if(gubun == '2'){
        		t2 = t2 + newValue;	
        	}
            
//            
//            t1 = result1.AMT_O;
//            t2 = result2.AMT_O;
//            
            t3 = t1 + t2;
            
            if(Ext.isEmpty(t4_1)){
//            	t4_1 = 10;
            	t4_1 = 0;
            }
            t4 = t3 * t4_1 / 100;
            
            t5 = t3 + t4;
            
            if(Ext.isEmpty(t6_1)){
//            	t6_1 = 8;
            	t6_1 = 0;
            }
            t6 = t5 * t6_1 / 100;
            
            t7 = t5 + t6;
            
            t8 = 100;
            
            if(t7 == 0){
            	t9 = 0;
            }else{
            	t9 = t1 / t7 * 100;
            }
            
            if(t7 == 0){
            	t10 = 0;
            }else{
           		t10 = t2 / t7 * 100;
            }
            
            t11 = 100 - t9 - t10;
            
            subForm.setValue('T3', t3);
            subForm.setValue('T4', t4);
            
            subForm.setValue('T4_1', t4_1);
            
            subForm.setValue('T5', t5);
            subForm.setValue('T6', t6);
            
            subForm.setValue('T6_1', t6_1);
            
            subForm.setValue('T7', t7);
            subForm.setValue('T8', t8);
            subForm.setValue('T9', t9);
            subForm.setValue('T10', t10);
            subForm.setValue('T11', t11);
            
        }
    });

    Unilite.createValidator('validator01', {
        store: directMasterStore1,
        grid: masterGrid,
        validate: function( type, fieldName, newValue, oldValue, record, eopt) {
            console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
            var rv = true;
            switch(fieldName) {
            	case "GARO_NUM" :
            		fnCalcGrid1Value(record,newValue,'1'); 
            	break;
            	
            	case "SERO_NUM" :
            		fnCalcGrid1Value(record,newValue,'2'); 
            	
            	break;
            	
            	case "DUGE_NUM" :
            		fnCalcGrid1Value(record,newValue,'3'); 
            	
            	break;
            	
            	case "UNIT_Q" :
            		fnCalcGrid1Value(record,newValue,'4'); 
            	
            	break;
            	
            	case "PRICE_RATE" :
            		fnCalcGrid1Value(record,newValue,'5'); 
            	
            	break;
            	
            	case "QTY_HH" :
            		fnCalcGrid1Value(record,newValue,'6'); 
            	
            	break;
//            	
            	case "AMT_O" :
        			UniAppManager.app.fnCalcFormTotal(subForm.getValue('T4_1'),subForm.getValue('T6_1'),'1',newValue);
            	
            	break;
            	
//            	
//				case "QTY_HH" :
//                	if(record.get('GUBUN_CODE') == '18'){
//                		record.set('AMT_O', newValue * record.get('PRICE_RATE'));
//                	}
//                	UniAppManager.app.fnCalcFormTotal();
//					
//				break;
//                
//                case "PRICE_RATE" :
//                	if(record.get('GUBUN_CODE') == '18'){
//                		record.set('AMT_O', newValue * record.get('QTY_HH'));
//                	}
//                	
//                	UniAppManager.app.fnCalcFormTotal();
//                
//                

//                    var stockUnit   = record.get('STOCK_UNIT');
//                    var garoNum     = record.get('GARO_NUM');
//                    var seroNum     = record.get('SERO_NUM');
//                    var dugeNum     = record.get('DUGE_NUM');
//                    var unitQ       = record.get('PRICE_RATE');
//                    var priceRate   = newValue;
//
//                    if(stockUnit == 'KG') {
//                        if(garoNum == 0 || seroNum == 0 || dugeNum == 0 || unitQ == 0) {
//                            record.set('QTY_HH', 0);
//                        }
//                        else if(garoNum != 0 && seroNum != 0 && dugeNum != 0 && unitQ != 0) {
//                            record.set('QTY_HH', (parseInt(newValue) * parseInt(seroNum) * parseInt(dugeNum) * parseInt(unitQ) * 8) / 100000);
//                        }
//                    } else if(stockUnit == 'EA') {
//                        record.set('QTY_HH', 0);
//
//                        if(unitQ == 0 || priceRate == 0) {
//                            record.set('AMT_O', 0);
//                        }
//                        else if(unitQ != 0 || priceRate != 0) {
//                            record.set('AMT_O', unitQ * priceRate);
//                        }
//                    } else {
//                        record.set('QTY_HH', 0);
//                        record.set('AMT_O', 0);
//                    }
//                    fnCalcGrid1Value();
//                    fnCalcFormTotal();

                break;
            }
            return rv;
        }
    })

    Unilite.createValidator('validator02', {
        store: directMasterStore2,
        grid: masterGrid2,
        validate: function( type, fieldName, newValue, oldValue, record, eopt) {
            console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
            var rv = true;
            switch(fieldName) {
                case "QTY_HH" :
            		fnCalcGrid2Value(record,newValue,'1'); 
                break;

                case "PRICE_RATE" :
            		fnCalcGrid2Value(record,newValue,'2'); 
                
                break;

            	case "AMT_O" :
        			UniAppManager.app.fnCalcFormTotal(subForm.getValue('T4_1'),subForm.getValue('T6_1'),'2',newValue);
            	
            	break;
            	
            }
            return rv;
        }
    })

  /*  
    
    
    
    function fnCalcFormTotal() {
        var result1 = directMasterStore1.sumBy(function(record, id) {       // 합계를 가지고 값구하기
                return true;
            },
            ['AMT_O']
        );
        var total1 = result1.AMT_O;

        var result2 = directMasterStore2.sumBy(function(record, id) {       // 합계를 가지고 값구하기
                return true;
            },
            ['AMT_O']
        );
        var total2 = result2.AMT_O;
        var profitRate = subForm.getValue('PROFIT_RATE') / 100;
        subForm.setValue('TOTAL1',      total1);
        subForm.setValue('TOTAL2',      total2);
        subForm.setValue('TOTAL3',      total1 + total2);
        //subForm.setValue('TOTAL4',     (total1 + total2) * 0.15);
        subForm.setValue('TOTAL4',     (total1 + total2) * profitRate);
        subForm.setValue('TOTAL_ALL',  (total1 + total2) + ((total1 + total2) * profitRate));
    }*/

    function fnCalcGrid1Value(record,newValue,gubun1) {
//        var record = masterGrid.getSelectedRecord();

        var stockUnit   = record.get('STOCK_UNIT');
        var garoNum     = '';
        var seroNum     = '';
        var dugeNum     = '';
        var unitQ       = '';
        var priceRate   = '';
        var qtyHH = '';
        if(gubun1 == '1'){
	        garoNum     = newValue;
	        seroNum     = record.get('SERO_NUM');
	        dugeNum     = record.get('DUGE_NUM');
	        unitQ       = record.get('UNIT_Q');
	        priceRate   = record.get('PRICE_RATE');
	        qtyHH = record.get('QTY_HH');
        }else if(gubun1 == '2'){
        	
	        garoNum     = record.get('GARO_NUM');
	        seroNum     = newValue;
	        dugeNum     = record.get('DUGE_NUM');
	        unitQ       = record.get('UNIT_Q');
	        priceRate   = record.get('PRICE_RATE');
	        qtyHH = record.get('QTY_HH');
        }else if(gubun1 == '3'){
        	garoNum     = record.get('GARO_NUM');
	        seroNum     = record.get('SERO_NUM');
	        dugeNum     = newValue;
	        unitQ       = record.get('UNIT_Q');
	        priceRate   = record.get('PRICE_RATE');
	        qtyHH = record.get('QTY_HH');
        }else if(gubun1 == '4'){
        	garoNum     = record.get('GARO_NUM');
	        seroNum     = record.get('SERO_NUM');
	        dugeNum     = record.get('DUGE_NUM');
	        unitQ       = newValue;
	        priceRate   = record.get('PRICE_RATE');
	        qtyHH = record.get('QTY_HH');
        }else if(gubun1 == '5'){
        	garoNum     = record.get('GARO_NUM');
	        seroNum     = record.get('SERO_NUM');
	        dugeNum     = record.get('DUGE_NUM');
	        unitQ       = record.get('UNIT_Q');
	        priceRate   = newValue;
	        qtyHH = record.get('QTY_HH');
        }else if(gubun1 == '6'){
        	garoNum     = record.get('GARO_NUM');
	        seroNum     = record.get('SERO_NUM');
	        dugeNum     = record.get('DUGE_NUM');
	        unitQ       = record.get('UNIT_Q');
	        priceRate   = record.get('PRICE_RATE');
	        qtyHH = newValue;
        }

        if(stockUnit == 'KG') {
            if(garoNum == 0 || seroNum == 0 || dugeNum == 0 || unitQ == 0) {
                record.set('QTY_HH', 0);
            }
            else if(garoNum != 0 && seroNum != 0 && dugeNum != 0 && unitQ != 0) {
                record.set('QTY_HH', (parseInt(garoNum) * parseInt(seroNum) * parseInt(dugeNum) * parseInt(unitQ) * 8) / 1000000);
                record.set('AMT_O', (parseInt(garoNum) * parseInt(seroNum) * parseInt(dugeNum) * parseInt(unitQ) * 8) / 1000000 * priceRate);
            }
        } else if(stockUnit == 'EA') {
            record.set('QTY_HH', 0);

            if(unitQ == 0 || priceRate == 0) {
                record.set('AMT_O', 0);
            }
            else if(unitQ != 0 || priceRate != 0) {
                record.set('AMT_O', unitQ * priceRate);
            }
        } else if(stockUnit == 'HT') { 
        	record.set('AMT_O', qtyHH * priceRate);
        } else {
            record.set('QTY_HH', 0);
            record.set('AMT_O', 0);
        }

        UniAppManager.app.fnCalcFormTotal(subForm.getValue('T4_1'),subForm.getValue('T6_1'));
    }

    function fnCalcGrid2Value(record,newValue,gubun1) {

        var qtyHH       = '';
        var priceRate   = '';
        
        if(gubun1 == '1'){
        	qtyHH       = newValue;
        	priceRate   = record.get('PRICE_RATE');
        }else if(gubun1 == '2'){
        	qtyHH       = record.get('QTY_HH');
        	priceRate   = newValue;
        }

        if(qtyHH == 0 || priceRate == 0) {
            record.set('AMT_O', 0);
        }
        else if(qtyHH != 0 && priceRate != 0) {
            record.set('AMT_O', qtyHH * priceRate);
        }

        UniAppManager.app.fnCalcFormTotal(subForm.getValue('T4_1'),subForm.getValue('T6_1'));
    }

    function fnDataExistCheck() {

        var dataExist = true;
        var param = panelResult.getValues();
        dataExist = false;
        //체크
       s_zcc200ukrv_kdService.existsYN(param, function(provider, response) {
            if(!Ext.isEmpty(provider)) {
                if(provider[0].EXISTS_YN == 'Y') {
                    //alert('이미 해당 견적번호로 견적내용이 존재하여 생성할 수 없습니다.');
                    dataExist = true;
                } else {
	                 dataExist = false;
                }
            }
        });
        return dataExist;
    }
};
</script>

