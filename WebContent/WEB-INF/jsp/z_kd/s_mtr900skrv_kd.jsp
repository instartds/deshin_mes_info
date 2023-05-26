<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_mtr900skrv_kd"  >
    <t:ExtComboStore comboType="BOR120"  />             <!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="B020" /> <!--품목계정-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
    // var searchInfoWindow; // 검색창

    /**
	 * Model 정의
	 *
	 * @type
	 */
    Unilite.defineModel('S_mtr900skrv_kdModel', {  // 모델정의 - 디테일 그리드
        fields: [
            {name: 'COMP_CODE'          , text: '법인코드'                , type: 'string'},
            {name: 'DIV_CODE'           , text: '사업장'                 , type: 'string', comboType:'BOR120'},
            {name: 'DEPT_CODE'          , text: '부서(코드)'              , type: 'string'},
            {name: 'DEPT_NAME'          , text: '부서(명)'               , type: 'string'},
            {name: 'PO_REQ_DATE'        , text: '요청일'                 , type: 'uniDate'},
            {name: 'PO_REQ_NUM'         , text: '요청번호'                , type: 'string'},
            {name: 'PO_SER_NO'          , text: '요청순번'                , type: 'string'},
            {name: 'ITEM_CODE'          , text: '품목코드'                , type: 'string'},
            {name: 'ITEM_NAME'          , text: '품목명'                 , type: 'string'},
            {name: 'SPEC'               , text: '규격'                  , type: 'string'},
            {name: 'REQ_ORDER_Q'        , text: '요청수량(재고수량)'          , type: 'uniQty'},
            {name: 'STOCK_UNIT'         , text: '단위(재고단위)'            , type: 'string'},
            {name: 'ORDER_Q'            , text: '발주량(재고수량)'           , type: 'uniQty'},
            {name: 'IN_Q'               , text: '입고량(재고수량)'           , type: 'uniQty'},
            {name: 'NOT_IN_Q'           , text: '미입고량'                ,type: 'uniQty'}
        ]
    });

   /**
	 * Store 정의(Combobox)
	 *
	 * @type
	 */
    var directMasterStore1 = Unilite.createStore('s_mtr900skrv_kdMasterStore1', {
        model: 'S_mtr900skrv_kdModel',
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
                read: 's_mtr900skrv_kdService.selectList'
            }
        },
        loadStoreRecords: function(){
            var param= Ext.getCmp('searchForm').getValues();
            console.log(param);
            this.load({
                params: param
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
            },{
                fieldLabel: '요청일',
                xtype: 'uniDateRangefield',
                startFieldName: 'PO_REQ_DATE_FR',
                endFieldName: 'PO_REQ_DATE_TO',
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today'),
                allowBlank:false,
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelSearch) {
                        panelResult.setValue('PO_REQ_DATE_FR',newValue);
                    }
                },
                onEndDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelSearch) {
                        panelResult.setValue('PO_REQ_DATE_TO',newValue);
                    }
                }
            },{
                fieldLabel: '품목계정',
                name: 'ITEM_ACCOUNT',
                xtype: 'uniCombobox',
                comboType: 'AU',
                comboCode: 'B020',
                listeners: {
                    change: function(combo, newValue, oldValue, eOpts) {
                        panelResult.setValue('ITEM_ACCOUNT', newValue);
                    }
                }
            },
            Unilite.popup('AGENT_CUST', {
                fieldLabel: '거래처',
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
            }),
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
            Unilite.popup('DIV_PUMOK',{
                    fieldLabel: '품목코드',
                    valueFieldName:'ITEM_CODE',
                    textFieldName:'ITEM_NAME',
                    listeners: {
                        applyextparam: function(popup){
                            popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
                        },
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
               })
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
        layout : {type : 'uniTable', columns : 3},
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
            listeners: {
                change: function(combo, newValue, oldValue, eOpts) {
                    panelSearch.setValue('DIV_CODE', newValue);
                }
            }
        },{
            fieldLabel: '요청일',
            xtype: 'uniDateRangefield',
            startFieldName: 'PO_REQ_DATE_FR',
            endFieldName: 'PO_REQ_DATE_TO',
            startDate: UniDate.get('startOfMonth'),
            endDate: UniDate.get('today'),
            allowBlank:false,
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
                if(panelResult) {
                    panelSearch.setValue('PO_REQ_DATE_FR',newValue);
                }
            },
            onEndDateChange: function(field, newValue, oldValue, eOpts) {
                if(panelResult) {
                    panelSearch.setValue('PO_REQ_DATE_TO',newValue);
                }
            }
        },{
            fieldLabel: '품목계정',
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
        Unilite.popup('AGENT_CUST', {
            fieldLabel: '거래처',
            //holdable: 'hold',
            validateBlank: false,
            autoPopup: true,
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
        }),
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
        Unilite.popup('DIV_PUMOK',{
            fieldLabel: '품목코드',
            valueFieldName:'ITEM_CODE',
            textFieldName:'ITEM_NAME',
            listeners: {
                applyextparam: function(popup){
                    popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
                },
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
       })
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

    /**
	 * Master Grid1 정의(Grid Panel)
	 *
	 * @type
	 */
    var masterGrid = Unilite.createGrid('s_mtr900skrv_kdGrid1', {      // detail그리드
        layout: 'fit',
        region: 'center',
        uniOpt: {
            expandLastColumn: false,
            useRowNumberer: true,
            copiedRow: true
        },
        features: [{
            id: 'masterGridSubTotal',
            ftype: 'uniGroupingsummary',
            showSummaryRow: false
        },{
            id: 'masterGridTotal',
            ftype: 'uniSummary',
            showSummaryRow: true
        }],
        store: directMasterStore1,
        columns: [
        	{dataIndex: 'COMP_CODE'     , width: 100, hidden: true},     // hidden: true
            {dataIndex: 'DIV_CODE'      , width: 100, hidden: true},     // hidden: true
            {dataIndex: 'DEPT_CODE'     , width: 100, hidden: true},
            {dataIndex: 'DEPT_NAME'     , width: 100},
            {dataIndex: 'PO_REQ_DATE'   , width: 100},
            {dataIndex: 'PO_REQ_NUM'    , width: 150,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.inventory.subtotal" default="소계"/>', '<t:message code="system.label.inventory.total" default="총계"/>');
				}
            },
            {dataIndex: 'PO_SER_NO'     , width: 100},
            {dataIndex: 'ITEM_CODE'     , width: 100},
            {dataIndex: 'ITEM_NAME'     , width: 150},
            {dataIndex: 'SPEC'          , width: 150},
            {dataIndex: 'REQ_ORDER_Q'   , width: 100, summaryType: 'sum'},
            {dataIndex: 'STOCK_UNIT'    , width: 100},
            {dataIndex: 'ORDER_Q'       , width: 100, summaryType: 'sum'},
            {dataIndex: 'IN_Q'          , width: 100, summaryType: 'sum'},
            {dataIndex: 'NOT_IN_Q'      , width: 100, summaryType: 'sum'}
        ]
    });// End of var masterGrid

    Unilite.Main( {
        border: false,
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
        id: 's_mtr900skrv_kdApp',
        fnInitBinding: function() {
            panelSearch.setValue('DIV_CODE',UserInfo.divCode);
            panelSearch.setValue('PO_REQ_DATE_FR', UniDate.get('startOfMonth'));
            panelSearch.setValue('PO_REQ_DATE_TO', UniDate.get('today'));

            panelResult.setValue('DIV_CODE',UserInfo.divCode);

            panelResult.setValue('PO_REQ_DATE_FR', UniDate.get('startOfMonth'));
            panelResult.setValue('PO_REQ_DATE_TO', UniDate.get('today'));

            UniAppManager.setToolbarButtons(['reset'], true);

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
            this.fnInitBinding();

        }
    });

};
</script>
