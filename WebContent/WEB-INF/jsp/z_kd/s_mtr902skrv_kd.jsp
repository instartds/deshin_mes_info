<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_mtr902skrv_kd"  >
    <t:ExtComboStore comboType="BOR120"  />             <!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="B014" /> <!-- 조달구분 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
    var searchInfoWindow;  // 검색창
    var groupUrl = '${groupUrl}'; //그룹웨어 호출 url
    var checkedCount = 0;   // 체크된 레코드

    /**
	 * Model 정의
	 *
	 * @type
	 */
    Unilite.defineModel('S_mtr902skrv_kdModel', {  // 모델정의 - 디테일 그리드
        fields: [
            {name: 'COMP_CODE'          , text: '법인코드'              , type: 'string'},
            {name: 'DIV_CODE'           , text: '사업장'                , type: 'string', comboType:'BOR120'},
            {name: 'INOUT_NUM'          , text: '수불번호'              , type: 'string'},
            {name: 'INOUT_DATE'         , text: '입고일자'              , type: 'uniDate'},
            {name: 'CUSTOM_CODE'        , text: '거래처'                , type: 'string'},
            {name: 'CUSTOM_NAME'        , text: '거래처명'              , type: 'string'},
            {name: 'INOUT_SEQ'          , text: '순번'                  , type: 'int'},
            {name: 'ITEM_CODE'          , text: '품목코드'              , type: 'string'},
            {name: 'ITEM_NAME'          , text: '품목명'                , type: 'string'},
            {name: 'SPEC'               , text: '규격'                  , type: 'string'},
            {name: 'MONEY_UNIT'         , text: '화폐'                  , type: 'string'},
            {name: 'EXCHG_RATE_O'       , text: '환율'                  , type: 'uniER'},
            {name: 'STOCK_UNIT'         , text: '(재고)단위'            , type: 'string'},
            {name: 'TRNS_RATE'          , text: '입수'                  , type: 'string'},
            {name: 'ORDER_UNIT'         , text: '(구매)단위'            , type: 'string'},
            {name: 'ORDER_UNIT_Q'       , text: '(구매)수량'            , type: 'uniQty'},
            {name: 'ORDER_UNIT_FOR_P'   , text: '(구매)단가'            , type: 'uniUnitPrice'},
            {name: 'INOUT_FOR_O'        , text: '(구매)금액'            , type: 'uniPrice'},
            {name: 'INOUT_Q'            , text: '(재고)수량'            , type: 'uniQty'},
            {name: 'INOUT_P'            , text: '(재고)단가'            , type: 'uniUnitPrice'},
            {name: 'INOUT_I'            , text: '(재고)금액'            , type: 'uniPrice'},
            {name: 'TREE_CODE'          , text: '구매요청부서코드'      , type: 'string'},
            {name: 'DEPT_NAME'          , text: '구매요청부서명'        , type: 'string'},
            {name: 'PERSON_NUMB'        , text: '구매요청사원코드'      , type: 'string'},
            {name: 'PERSON_NAME'        , text: '구매요청사원명'      , type: 'string'},
            {name: 'PO_REQ_NUM'         , text: '구매요청번호'          , type: 'string'},
            {name: 'PO_REQ_SEQ'         , text: '구매요청순번'          , type: 'int'},
            {name: 'ORDER_NUM'          , text: '발주번호'              , type: 'string'},
            {name: 'ORDER_SEQ'          , text: '발주순번'              , type: 'int'},
            {name: 'GW_DOC'             , text: '기안문서번호'                , type: 'string'},
            {name: 'GW_FLAG'            , text: '기안여부'                , type: 'string', comboType:'AU', comboCode:'WB17'},
            {name: 'DRAFT_NO'           , text: 'DRAFT_NO'              , type: 'string'}
        ]
    });

   /**
	 * Store 정의(Combobox)
	 *
	 * @type
	 */
    var directMasterStore1 = Unilite.createStore('s_mtr902skrv_kdMasterStore1', {
        model: 'S_mtr902skrv_kdModel',
        uniOpt: {
            isMaster: true,         // 상위 버튼 연결
            editable: false,         // 수정 모드 사용
            deletable: false,        // 삭제 가능 여부
            useNavi: false          // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy:{
            type: 'direct',
            api: {
                   read: 's_mtr902skrv_kdService.selectList'
            }
        },
        loadStoreRecords: function(){
            var param= Ext.getCmp('searchForm').getValues();
            console.log(param);
            this.load({
                params: param,
             // NEW ADD
				callback: function(records, operation, success){
					console.log(records);
					if(success){
						if(masterGrid.getStore().getCount() == 0){
							Ext.getCmp('GW').setDisabled(true);
						}else if(masterGrid.getStore().getCount() != 0){
							UniBase.fnGwBtnControl('GW',directMasterStore1.data.items[0].data.GW_FLAG);
						}
					}
				}
				//END
            });
        }
    });// End of var directMasterStore1

    /**
	 * 검색조건 (Search Panel) - 좌측 검색조건
	 *
	 * @type
	 */
    var panelSearch = Unilite.createSearchPanel('searchForm', {
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
            items:[{
                fieldLabel: '사업장',
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
            Unilite.popup('AGENT_CUST', {
                fieldLabel: '거래처',
                allowBlank:false,
                // holdable: 'hold',
                validateBlank: false,
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
                fieldLabel: '입고일',
                xtype: 'uniDateRangefield',
                startFieldName: 'INOUT_DATE_FR',
                endFieldName: 'INOUT_DATE_TO',
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today'),
                allowBlank:false,
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelSearch) {
                        panelResult.setValue('INOUT_DATE_FR',newValue);
                    }
                },
                onEndDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelSearch) {
                        panelResult.setValue('INOUT_DATE_TO',newValue);
                    }
                }
            },{
                xtype: 'radiogroup',
                fieldLabel: '조달구분',
                items : [
                    {
                        boxLabel: '내수',
                        width: 60,
                        name: 'CREATE_LOC',
                        checked: true,
                        inputValue: '2'
                    }
                    /*
                    //180424 의미 없어 제거
                    ,{
                        boxLabel: '외주',
                        width: 60,
                        name: 'CREATE_LOC',
                        inputValue: '4'
                    }
                    */
                    ,{
                        boxLabel: '수입',
                        width: 60,
                        name: 'CREATE_LOC',
                        inputValue: '6'
                    }
                ],
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.getField('CREATE_LOC').setValue(newValue.CREATE_LOC);
                    }
                }
            },{
                fieldLabel:'발주번호',
                name: 'ORDER_NUM',
                xtype: 'uniTextfield',
                // holdable: 'hold',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('ORDER_NUM', newValue);
                    }
                }
            },{
                xtype: 'radiogroup',
                fieldLabel: 'GW기안',
                items : [
                    {
                        boxLabel: '기안',
                        width: 60,
                        name: 'GW_FLAG',
                        checked: true,
                        inputValue: '1'
                    },{
                        boxLabel: '미기안',
                        width: 60,
                        name: 'GW_FLAG',
                        inputValue: 'N'
                    }
                ],
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.getField('GW_FLAG').setValue(newValue.GW_FLAG);
                    }
                }
            }/*,
            Unilite.popup('DEPT', {
                fieldLabel: '부서',
                valueFieldName: 'DEPT_CODE',
                textFieldName: 'DEPT_NAME',
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
                        var authoInfo = pgmInfo.authoUser;              // 권한정보(N-전체,A-자기사업장>5-자기부서)
                        // var deptCode = UserInfo.deptCode; //부서정보
                        var divCode = '';                   // 사업장
                        if(authoInfo == "A"){   // 자기사업장
                            // popup.setExtParam({'DEPT_CODE': ""});
                            popup.setExtParam({'DIV_CODE': UserInfo.divCode});
                        }else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){   // 전체권한
                            // popup.setExtParam({'DEPT_CODE': ""});
                            popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
                        }else if(authoInfo == "5"){     // 부서권한
                            // popup.setExtParam({'DEPT_CODE':
							// UserInfo.deptCode});
                            popup.setExtParam({'DIV_CODE': UserInfo.divCode});
                        }
                    }
                }
            }),
            Unilite.popup('Employee', {
                fieldLabel: '구매요청사원',
                // holdable: 'hold',
                validateBlank: false,
                listeners: {
                            onSelected: {
                                fn: function(records, type) {
                                    panelResult.setValue('PERSON_NUMB', panelSearch.getValue('PERSON_NUMB'));
                                    panelResult.setValue('NAME', panelSearch.getValue('NAME'));
                                },
                                scope: this
                            },
                            onClear: function(type) {
                                panelResult.setValue('PERSON_NUMB', '');
                                panelResult.setValue('NAME', '');
                            }
                        }
            })*/
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
    });// End of var panelSearch

    /**
	 * 검색조건 (Search Result) - 상단조건
	 *
	 * @type
	 */
    var panelResult = Unilite.createSearchForm('resultForm',{
        region: 'north',
        layout : {type : 'uniTable', columns : 5, tableAttrs: {width: '99.5%'}},
        tdAttrs: {align: 'right'},
        padding:'1 1 1 1',
        border:true,
        hidden: !UserInfo.appOption.collapseLeftSearch,
        items: [{
                fieldLabel: '사업장',
                name:'DIV_CODE',
                xtype: 'uniCombobox',
                comboType:'BOR120',
                allowBlank:false,
                holdable: 'hold',
                value: UserInfo.divCode,
                tdAttrs: {width: 300},
                listeners: {
                    change: function(combo, newValue, oldValue, eOpts) {
                        panelSearch.setValue('DIV_CODE', newValue);
                    }
                }
            },
            Unilite.popup('AGENT_CUST', {
                fieldLabel: '거래처',
                allowBlank:false,
                tdAttrs: {width: 346},
                // holdable: 'hold',
                validateBlank: false,
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
                fieldLabel: '입고일',
                xtype: 'uniDateRangefield',
                startFieldName: 'INOUT_DATE_FR',
                endFieldName: 'INOUT_DATE_TO',
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today'),
                allowBlank:false,
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelResult) {
                        panelSearch.setValue('INOUT_DATE_FR',newValue);
                    }
                },
                onEndDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelResult) {
                        panelSearch.setValue('INOUT_DATE_TO',newValue);
                    }
                }
            },{xtype: 'container',
				layout:{type:'vbox'},
				tdAttrs: {align: 'right'},
				items:[{ xtype : 'button',//재기안버튼
			             itemId : 'GWBtn3',
			             id:'GW3',
			             text:'재기안',
			             margin:'0 0 0 0',
			             hidden: true,
			             handler: function() {
			                if(Ext.isEmpty(inputTable.getValue('PERSON_NUMB'))) {
			                    alert('수령자를 선택 후 기안하십시오.');
			                    return false;
			                }
			                var param = panelResult.getValues();
			                if(confirm('기안 하시겠습니까?')) {
			                    record = masterGrid.getSelectedRecord();
			                    param.DRAFT_NO  = UserInfo.compCode + record.data.INOUT_NUM;
			                    param.DIV_CODE  = record.data.DIV_CODE;
			                    param.INOUT_NUM = record.data.INOUT_NUM;
			                    param.PERSON_NUMB = inputTable.getValue('PERSON_NUMB');
			                    panelResult.setValue('GW_TEMP', '기안중');
	                            s_mtr902skrv_kdService.makeDraftNum(param, function(provider2, response)   {//기안 상태 관련없이 기안처리
	                                UniAppManager.app.requestApprove(record);
	                            });
			                  /*   s_mtr902skrv_kdService.selectGwData(param, function(provider, response) {
			                        if(Ext.isEmpty(provider[0]) || provider[0].GW_FLAG != '1' || provider[0].GW_FLAG != '3') {
			                            panelResult.setValue('GW_TEMP', '기안중');
			                            s_mtr902skrv_kdService.makeDraftNum(param, function(provider2, response)   {
			                                UniAppManager.app.requestApprove(record);
			                            });
			                        } else {
			                            alert('이미 기안된 자료입니다.');
			                            return false;
			                        }
			                    }); */
			                }
			                	UniAppManager.app.onQueryButtonDown();
				            },listeners: {
				            	 el: {
				            		mouseover: function(e, elem, eOpts) {

							         },
						            mouseout: function(e, elem, eOpts) {

						            }, blur: function(e, elem, eOpts){
						            	Ext.getCmp('GW3').hide();
							        }
				            	 }
				            }
						}]
        			},{ xtype : 'button',//재기안 버튼을 보이게 하기위한 히든 버튼
		                text:'',
		                width:0.1,
		                height:8,
		                tdAttrs: {align: 'right'},
		                padding: '0 0 0 0',
		               // margin:'0 0 0 0',
		                fieldStyle: 'background: inherit ; border:none; box-shadow:none; border-radius:0; padding:0; overflow:visible; cursor:pointer',
		                border: false,
		                //hidden: true,
		                handler: function() {
		                	Ext.getCmp('GW3').show();
		                }
					 },{
		                xtype: 'radiogroup',
		                fieldLabel: '조달구분',
		                items : [
		                    {
		                    boxLabel: '내수',
		                    width: 60,
		                    name: 'CREATE_LOC',
		                    checked: true,
		                    inputValue: '2'
		                }
                /*
                ,{
                    boxLabel: '외주',
                    width: 60,
                    name: 'CREATE_LOC',
                    inputValue: '4'

                }
                */
                ,{
                    boxLabel: '수입',
                    width: 60,
                    name: 'CREATE_LOC',
                    inputValue: '6'
                }
                ],
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelSearch.getField('CREATE_LOC').setValue(newValue.CREATE_LOC);
                    }
                }
            },{
                fieldLabel:'발주번호',
                name: 'ORDER_NUM',
                xtype: 'uniTextfield',
                // holdable: 'hold',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelSearch.setValue('ORDER_NUM', newValue);
                    }
                }
            },{
                xtype: 'radiogroup',
                fieldLabel: 'GW기안',
                items : [
                	{
                        boxLabel: '기안',
                        width: 60,
                        name: 'GW_FLAG',
                        checked: true,
                        inputValue: '1'
                    },{
                        boxLabel: '미기안',
                        width: 60,
                        name: 'GW_FLAG',
                        inputValue: 'N'
                    }
                ],
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelSearch.getField('GW_FLAG').setValue(newValue.GW_FLAG);

                    }
                }
            }/*,
            Unilite.popup('DEPT', {
                fieldLabel: '부서',
                valueFieldName: 'DEPT_CODE',
                textFieldName: 'DEPT_NAME',
                listeners: {
                    onSelected: {
                        fn: function(records, type) {
                            panelSearch.setValue('DEPT_CODE', panelResult.getValue('DEPT_CODE'));
                            panelSearch.setValue('DEPT_NAME', panelResult.getValue('DEPT_NAME'));
                        },
                        scope: this
                    },
                    onClear: function(type) {
                                panelResult.setValue('DEPT_CODE', '');
                                panelResult.setValue('DEPT_NAME', '');
                    },
                    applyextparam: function(popup){
                        var authoInfo = pgmInfo.authoUser;              // 권한정보(N-전체,A-자기사업장>5-자기부서)
                        // var deptCode = UserInfo.deptCode; //부서정보
                        var divCode = '';                   // 사업장
                        if(authoInfo == "A"){   // 자기사업장
                            // popup.setExtParam({'DEPT_CODE': ""});
                            popup.setExtParam({'DIV_CODE': UserInfo.divCode});
                        }else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){   // 전체권한
                            // popup.setExtParam({'DEPT_CODE': ""});
                            popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
                        }else if(authoInfo == "5"){     // 부서권한
                            // popup.setExtParam({'DEPT_CODE':
							// UserInfo.deptCode});
                            popup.setExtParam({'DIV_CODE': UserInfo.divCode});
                        }
                    }
                }
            }),
            Unilite.popup('Employee', {
                fieldLabel: '구매요청사원',
                // holdable: 'hold',
                validateBlank: false,
                listeners: {
                            onSelected: {
                                fn: function(records, type) {
                                    panelSearch.setValue('PERSON_NUMB', panelResult.getValue('PERSON_NUMB'));
                                    panelSearch.setValue('NAME', panelResult.getValue('NAME'));
                                },
                                scope: this
                            },
                            onClear: function(type) {
                                panelSearch.setValue('PERSON_NUMB', '');
                                panelSearch.setValue('NAME', '');
                            }
                        }
            })*/
        ] ,
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
    });// End of var panelSearch

    var inputTable = Unilite.createSearchForm('detailForm', { //createForm
        layout : {type:'uniTable', columns: '1', tableAttrs: {width: '99.5%'}},
        disabled: false,
        border:true,
        padding: '1',
        region: 'center',
        items: [	{ xtype: 'container',
		            layout:{type:'uniTable', columns: '3'},
		            tdAttrs: {align: 'right'},
		            items:[ Unilite.popup('Employee',{
				                        fieldLabel: '수령자(사원)',
				                        id:'PERSON',
				                        valueFieldName:'PERSON_NUMB',
				                        textFieldName:'NAME',
				                        validateBlank:false,
				                        autoPopup:true
				                }),{                          //기안버튼
				                    xtype : 'button',
				                    itemId : 'GWBtn',
				                    id:'GW',
				//                    iconCls : 'icon-referance',
				                    text:'기안',
				                    disabled: true,
				                    handler: function() {
				                        if(Ext.isEmpty(inputTable.getValue('PERSON_NUMB'))) {
				                            alert('수령자를 선택 후 기안하십시오.');
				                            return false;
				                        }
				                        var param = panelResult.getValues();
				                        if(confirm('기안 하시겠습니까?')) {
				                            record = masterGrid.getSelectedRecord();
				                            param.DRAFT_NO  = UserInfo.compCode + record.data.INOUT_NUM;
				                            param.DIV_CODE  = record.data.DIV_CODE;
				                            param.INOUT_NUM = record.data.INOUT_NUM;
				                            param.PERSON_NUMB = inputTable.getValue('PERSON_NUMB');
				                            s_mtr902skrv_kdService.selectGwData(param, function(provider, response) {
				                                if(Ext.isEmpty(provider[0]) || provider[0].GW_FLAG != '1' || provider[0].GW_FLAG != '3') {
				                                    panelResult.setValue('GW_TEMP', '기안중');
				                                    s_mtr902skrv_kdService.makeDraftNum(param, function(provider2, response)   {
				                                        UniAppManager.app.requestApprove(record);
				                                    });
				                                } else {
				                                    alert('이미 기안된 자료입니다.');
				                                    return false;
				                                }
				                            });
				                        }
				                        UniAppManager.app.onQueryButtonDown();
				                    }
				                },{
				                    xtype : 'button',
				                    itemId : 'GWBtn2',
				                    id:'GW2',
				                    text:'기안뷰',
				                    handler: function() {
				                        var param = panelResult.getValues();
				                        record = masterGrid.getSelectedRecord();
				                        if(!Ext.isEmpty(record)){
				                        	param.DRAFT_NO  = UserInfo.compCode + record.data.INOUT_NUM;
				                            param.DIV_CODE  = record.data.DIV_CODE;
				                            param.INOUT_NUM = record.data.INOUT_NUM;
				                            param.PERSON_NUMB = inputTable.getValue('PERSON_NUMB');
				                            param.DRAFT_NO = UserInfo.compCode + record.data.INOUT_NUM;
				                            s_mtr902skrv_kdService.selectDraftNo(param, function(provider, response) {
				                                if(Ext.isEmpty(provider[0])) {
				                                    alert('draft No가 없습니다.');
				                                    return false;
				                                } else {
				                                    UniAppManager.app.requestApprove2(record);
				                                }
				                            });
				                            UniAppManager.app.onQueryButtonDown();
				                        }
				                    }
				                }
			            ]}
		        ]
    });

    /**
	 * Master Grid1 정의(Grid Panel)
	 *
	 * @type
	 */
    var masterGrid = Unilite.createGrid('s_mtr902skrv_kdGrid1', {      // detail그리드
        layout: 'fit',
        region: 'center',
        uniOpt: {
            expandLastColumn: false,
            useRowNumberer: true,
            copiedRow: true,
            onLoadSelectFirst: true
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
        store: directMasterStore1,
//        selModel:   Ext.create('Ext.selection.CheckboxModel', { checkOnly: true, toggleOnClick: false,
//            listeners: {
//                select: function(grid, selectRecord, index, rowIndex, eOpts ) {
//                    UniAppManager.setToolbarButtons(['save'], false);
//                    checkedCount = checkedCount + 1;
//                    panelResult.setValue('COUNT', checkedCount);
//                    if(panelResult.getValue('COUNT') > 0) {
//                        Ext.getCmp('GW').setDisabled(false);
//                    } else {
//                        Ext.getCmp('GW').setDisabled(true);
//                    }
//                },
//                deselect:  function(grid, selectRecord, index, eOpts ) {
//                    UniAppManager.setToolbarButtons(['save'], false);
//                    checkedCount = checkedCount - 1;
//                    panelResult.setValue('COUNT', checkedCount);
//                    if(panelResult.getValue('COUNT') > 0) {
//                        Ext.getCmp('GW').setDisabled(false);
//                    } else {
//                        Ext.getCmp('GW').setDisabled(true);
//                    }
//                }
//            }
//        }),
        selModel: 'rowmodel',
        columns: [
        	{dataIndex: 'COMP_CODE'       , width: 100 , hidden: true},     // hidden:
            {dataIndex: 'DIV_CODE'        , width: 100 , hidden: true},
            {dataIndex: 'INOUT_NUM'       , width: 120},
            {dataIndex: 'INOUT_DATE'      , width: 100},
            {dataIndex: 'CUSTOM_CODE'     , width: 100},
            {dataIndex: 'CUSTOM_NAME'     , width: 120},
            {dataIndex: 'INOUT_SEQ'       , width: 70},
            {dataIndex: 'ITEM_CODE'       , width: 100},
            {dataIndex: 'ITEM_NAME'       , width: 150},
            {dataIndex: 'SPEC'            , width: 150},
            {dataIndex: 'MONEY_UNIT'      , width: 100 , hidden: true},
            {dataIndex: 'EXCHG_RATE_O'    , width: 100 , hidden: true},
            
            {dataIndex: 'TRNS_RATE'       , width: 100 },
            {dataIndex: 'ORDER_UNIT'      , width: 80, align: 'center' },  // 20201015 우부장님 요청으로 구매단가,금액 오픈
            {dataIndex: 'ORDER_UNIT_Q'    , width: 120 },
            {dataIndex: 'ORDER_UNIT_FOR_P'     , width: 120 },
            {dataIndex: 'INOUT_FOR_O'     , width: 120 },
            {dataIndex: 'STOCK_UNIT'      , width: 80, align: 'center'},
            {dataIndex: 'INOUT_Q'         , width: 120},
            {dataIndex: 'INOUT_P'         , width: 120},
            {dataIndex: 'INOUT_I'         , width: 120},
            {dataIndex: 'TREE_CODE'       , width: 120, hidden: true},
            {dataIndex: 'DEPT_NAME'       , width: 150},
            {dataIndex: 'PERSON_NUMB'     , width: 120, hidden: true},
            {dataIndex: 'PERSON_NAME'     , width: 120},
            {dataIndex: 'PO_REQ_NUM'      , width: 120},
            {dataIndex: 'PO_REQ_SEQ'      , width: 70},
            {dataIndex: 'ORDER_NUM'       , width: 120},
            {dataIndex: 'ORDER_SEQ'       , width: 70},
            {dataIndex: 'GW_DOC'          , width: 150},
            {dataIndex: 'GW_FLAG'         , width: 120, align: 'center'},
            {dataIndex: 'DRAFT_NO'        , width: 150, hidden:true}
        ]
    });// End of var masterGrid

    Unilite.Main( {
        border: false,
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
        id: 's_mtr902skrv_kdApp',
        fnInitBinding: function() {
             panelSearch.setValue('DIV_CODE',UserInfo.divCode);
             panelSearch.setValue('INOUT_DATE_TO', UniDate.get('today'));
             panelSearch.setValue('INOUT_DATE_FR', UniDate.get('startOfMonth'));
             panelSearch.setValue('CREATE_LOC', '2');
             panelSearch.setValue('GW_FLAG', '1');

             panelResult.setValue('DIV_CODE',UserInfo.divCode);
             panelResult.setValue('INOUT_DATE_TO', UniDate.get('today'));
             panelResult.setValue('INOUT_DATE_FR', UniDate.get('startOfMonth'));
             panelResult.setValue('CREATE_LOC', '2');
             panelResult.setValue('GW_FLAG', '1');

             Ext.getCmp('GW').disable();
//             Ext.getCmp('GW2').disable();
             Ext.getCmp('PERSON').disable();

            UniAppManager.setToolbarButtons(['reset'], true); // 초기화버튼 활성화여부

            var activeSForm ;
            if(!UserInfo.appOption.collapseLeftSearch)  {
                activeSForm = panelSearch;
            }else {
                activeSForm = panelResult;
            }
            activeSForm.onLoadSelectText('DIV_CODE');
        },
        onQueryButtonDown: function() { // 조회
            if(panelSearch.setAllFieldsReadOnly(true) == false){
                return false;
            }
            if(panelResult.setAllFieldsReadOnly(true) == false){
                return false;
            }

//            기안버튼 활성화
            var gw_flg = panelResult.getValue('GW_FLAG');
            if (gw_flg){
                Ext.getCmp('GW').disable();
//                Ext.getCmp('GW2').disable();
                Ext.getCmp('PERSON').enable();
            }else{
                Ext.getCmp('GW').enable();
//                Ext.getCmp('GW2').enable();
                Ext.getCmp('PERSON').enable();
            };

            directMasterStore1.loadStoreRecords();

            // var viewLocked = masterGrid.getView();
            // var viewNormal = masterGrid.getView();
            // viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
            // viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
            // viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
            // viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
        },
        onResetButtonDown : function() { // 초기화
            panelSearch.clearForm();
            panelSearch.setAllFieldsReadOnly(false);
            panelResult.setAllFieldsReadOnly(false);
            masterGrid.reset();
            panelResult.clearForm();
            directMasterStore1.clearData();
            Ext.getCmp('GW').setDisabled(true);
            this.fnInitBinding();

        },
        requestApprove: function(record){     //결재 요청
            var gsWin       = window.open('about:blank','payviewer','width=500,height=500');
            var frm         = document.f1;
            var compCode    = UserInfo.compCode;
            var divCode     = record.data.DIV_CODE;
            var inoutNum    = record.data.INOUT_NUM;
            var spText      = 'EXEC omegaplus_kdg.unilite.USP_GW_S_MTR902SKRV_KD ' + "'" + compCode + "'" + ', ' + "'" + divCode + "'" + ', ' + "'" + inoutNum + "'";
            var spCall      = encodeURIComponent(spText);

            /* frm.action   = groupUrl + "viewMode=docuDraft" + "&prg_no=s_mtr902skrv_kd&draft_no=" + UserInfo.compCode + record.data.INOUT_NUM + "&sp=" + spCall/* + Base64.encode();
            frm.target   = "payviewer";
            frm.method   = "post";
            frm.submit();  */
            var gwurl = groupUrl + "viewMode=docuDraft" + "&prg_no=s_mtr902skrv_kd&draft_no=" + UserInfo.compCode + inoutNum + "&sp=" + spCall/* + Base64.encode()*/;
            UniBase.fnGw_Call(gwurl,frm,'GW');
        },
        requestApprove2: function(record){     // VIEW
            var gsWin = window.open('about:blank','payviewer','width=500,height=500');

            var frm         = document.f1;
            var compCode    = UserInfo.compCode;
            var divCode     = record.data.DIV_CODE;
            var inoutNum    = record.data.INOUT_NUM;
            var spText      = 'EXEC omegaplus_kdg.unilite.USP_GW_S_MTR902SKRV_KD ' + "'" + compCode + "'" + ', ' + "'" + divCode + "'" + ', ' + "'" + inoutNum + "'";
            var spCall      = encodeURIComponent(spText);

            frm.action   = groupUrl + "appr_id=" + record.data.GW_DOC + "&viewMode=docuView";
            frm.target   = "payviewer";
            frm.method   = "post";
            frm.submit();


        }
    });

};

</script>

<form id="f1" name="f1" action="" method="post" onSubmit="return false;" >
<input type="hidden" id="loginid" name="loginid" value="superadmin" />
<input type="hidden" id="fmpf" name="fmpf" value="" />
<input type="hidden" id="fmbd" name="fmbd" runat="server" />
</form>

