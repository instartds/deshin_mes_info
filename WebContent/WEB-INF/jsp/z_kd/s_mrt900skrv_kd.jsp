<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_mrt900skrv_kd"  >
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

	 //180713 사용자(이준상대리) 요청에 의해 수량정보 소수점제거위해 int 형으로 변경
    Unilite.defineModel('S_mrt900skrv_kdModel', {  // 모델정의 - 디테일 그리드
        fields: [
            {name: 'COMP_CODE'          , text: '법인코드'       , type: 'string'},
            {name: 'DIV_CODE'           , text: '사업장'        , type: 'string', comboType:'BOR120'},
            {name: 'M_CUSTOM_NAME'      , text: '외주처명'       , type: 'string'},
            {name: 'ITEM_CODE'          , text: '품목코드'       , type: 'string'},
            {name: 'ITEM_NAME'          , text: '품목명'        , type: 'string'},
            {name: 'SPEC'               , text: '규격'         , type: 'string'},
            {name: 'STOCK_UNIT'         , text: '재고단위'      , type: 'string'},
            {name: 'ORD_CUSTOM_CODE'    , text: '발주거래처'    , type: 'string'},
            {name: 'ORD_CUSTOM_NAME'    , text: '발주거래처명'      , type: 'string'},
//            {name: 'CUSTOM_CODE'          , text: '주거래처'    , type: 'string'},
//            {name: 'CUSTOM_NAME'          , text: '거래처명'      , type: 'string'},
            {name: 'ORDER_Q'            , text: '발주수량'      , type: 'int'},
            {name: 'ORDER_O'            , text: '발주금액'      , type: 'uniPrice'},
            {name: 'IN_Q'               , text: '입고수량'      , type: 'int'},
            {name: 'IN_O'               , text: '입고금액'      , type: 'uniPrice'},
            {name: 'NOT_IN_Q'          , text: '미입고량'       , type: 'int'},
            {name: 'STOCK_Q'          , text: '현재고'       , type: 'int'}
        ]
    });

   /**
	 * Store 정의(Combobox)
	 *
	 * @type
	 */
    var directMasterStore1 = Unilite.createStore('s_mrt900skrv_kdMasterStore1', {
        model: 'S_mrt900skrv_kdModel',
        uniOpt: {
            isMaster: false,         // 상위 버튼 연결
            editable: false,         // 수정 모드 사용
            deletable: false,        // 삭제 가능 여부
            useNavi: false          // prev | newxt 버튼 사용

        },
        autoLoad: false,
        proxy:{
            type: 'direct',
            api: {
                read: 's_mrt900skrv_kdService.selectList'
            }
        },
        loadStoreRecords: function(){
            var param= Ext.getCmp('searchForm').getValues();
            console.log(param);
            this.load({
                params: param
            });
        },
        groupField: 'M_CUSTOM_NAME'
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
                // holdable: 'hold',
                 autoPopup   : true ,
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
                fieldLabel: '품번',
                name:'OEM_ITEM_CODE',
                textFieldWidth: 130,
                listeners: {
                    change: function(combo, newValue, oldValue, eOpts) {
                        panelResult.setValue('OEM_ITEM_CODE', newValue);
                    }
                }
            }
            /*,
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
                                panelSearch.setValue('SPEC',records[0]["SPEC"]);
                                panelResult.setValue('SPEC',records[0]["SPEC"]);
                            },
                            scope: this
                        },
                        onClear: function(type) {
                            panelResult.setValue('ITEM_CODE', '');
                            panelResult.setValue('ITEM_NAME', '');
                            panelSearch.setValue('SPEC', '');
                            panelResult.setValue('SPEC', '');
                        }
                    }
               }),
               {
                fieldLabel : ' ',
                name:'SPEC',
                xtype:'uniTextfield',
                readOnly:true,
                holdable: 'hold',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('SPEC', newValue);
                    }
                }
            }*/]
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
//        layout : {type : 'uniTable', columns : 3},
        layout : {type : 'uniTable', columns : 4},
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
        },
        Unilite.popup('AGENT_CUST', {
            fieldLabel: '거래처',
            id:'CUSTOM_NAME',
            // holdable: 'hold',
            validateBlank: false,
            //allowBlank:false,
            autoPopup   : true ,
            listeners: {
                onSelected: {
                    fn: function(records, type) {
                        panelSearch.setValue('CUSTOM_CODE', panelResult.getValue('CUSTOM_CODE'));
                        panelSearch.setValue('CUSTOM_NAME', panelResult.getValue('CUSTOM_NAME'));
                        Ext.getCmp('OEM_ITEM_CODE').focus();
                    },
                    scope: this
                },
                onClear: function(type) {
                    panelSearch.setValue('CUSTOM_CODE', '');
                    panelSearch.setValue('CUSTOM_NAME', '');
                }
            }
        }),{
            fieldLabel: '품번',
            name:'OEM_ITEM_CODE',
            id:'OEM_ITEM_CODE',
            textFieldWidth: 130,
            listeners: {
                change: function(combo, newValue, oldValue, eOpts) {
                	panelSearch.setValue('OEM_ITEM_CODE', newValue);
                }
            }
        }
        /*,
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
                        panelResult.setValue('SPEC',records[0]["SPEC"]);//
                        panelSearch.setValue('SPEC',records[0]["SPEC"]);//

                    },
                    scope: this
                },
                onClear: function(type) {
                    panelSearch.setValue('ITEM_CODE', '');
                    panelSearch.setValue('ITEM_NAME', '');
                    panelResult.setValue('SPEC','');
                    panelSearch.setValue('SPEC','');
                }
            }
       }),
       {
            name:'SPEC',
            xtype:'uniTextfield',
            holdable: 'hold',
            readOnly:true,
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.setValue('SPEC', newValue);
                }
            }
        }*/] ,
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
    var masterGrid = Unilite.createGrid('s_mrt900skrv_kdGrid1', {      // detail그리드
        layout: 'fit',
        region: 'center',
        uniOpt: {
            expandLastColumn: true,
            useRowNumberer: true,
            copiedRow: true
        },
        features: [
            {id: 'masterGridSubTotal',     ftype: 'uniGroupingsummary',    showSummaryRow: false },
            {id: 'masterGridTotal',        ftype: 'uniSummary',            showSummaryRow: false}
        ],
        store: directMasterStore1,
        columns: [
        	{dataIndex: 'COMP_CODE'         , width: 100, hidden: true},     // hidden: true
            {dataIndex: 'DIV_CODE'          , width: 100, hidden: true},     // hidden: true
            {dataIndex: 'M_CUSTOM_NAME'     , width: 130,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                    return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
                }
            },
            {dataIndex: 'ITEM_CODE'         , width: 100},
            {dataIndex: 'ITEM_NAME'         , width: 170},
            {dataIndex: 'SPEC'              , width: 130},
            {dataIndex: 'STOCK_UNIT'        , width: 80},
//            {dataIndex: 'ORD_CUSTOM_CODE'       , width: 100},
//            {dataIndex: 'ORD_CUSTOM_NAME'       , width: 100},
//            {dataIndex: 'CUSTOM_CODE'       , width: 100},
//            {dataIndex: 'CUSTOM_NAME'       , width: 100},
            {dataIndex: 'ORDER_Q'           , width: 100, summaryType : 'sum',
            	summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData,'<div align="right">'+ Ext.util.Format.number(value,'0,000') + '</div>', '<div align="right">'+Ext.util.Format.number(value,'0,000')+ '</div>');
            	}},
            {dataIndex: 'ORDER_O'           , width: 120, summaryType : 'sum'},
            {dataIndex: 'IN_Q'              , width: 100, summaryType : 'sum',
            	summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData,'<div align="right">'+ Ext.util.Format.number(value,'0,000') + '</div>', '<div align="right">'+Ext.util.Format.number(value,'0,000')+ '</div>');
            	}},
            {dataIndex: 'IN_O'              , width: 120, summaryType : 'sum'},
            {dataIndex: 'NOT_IN_Q'          , width: 100, summaryType : 'sum',
            	summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData,'<div align="right">'+ Ext.util.Format.number(value,'0,000') + '</div>', '<div align="right">'+Ext.util.Format.number(value,'0,000')+ '</div>');
            	}},
            {dataIndex: 'STOCK_Q'          , width: 100, summaryType : 'sum',
            	summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData,'<div align="right">'+ Ext.util.Format.number(value,'0,000') + '</div>', '<div align="right">'+Ext.util.Format.number(value,'0,000')+ '</div>');
            	}
            }
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
        id: 's_mrt900skrv_kdApp',
        fnInitBinding: function() {
            panelSearch.setValue('DIV_CODE',UserInfo.divCode);
            panelResult.setValue('DIV_CODE',UserInfo.divCode);

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
            if(Ext.isEmpty(panelResult.getValue('CUSTOM_CODE')) && Ext.isEmpty(panelResult.getValue('OEM_ITEM_CODE'))){
            	alert('거래처와 품번중 하나의 정보는 필수 입력입니다.');
            	return false;
            }
            directMasterStore1.clearData();
            directMasterStore1.loadStoreRecords();

            var viewLocked = masterGrid.getView();
            var viewNormal = masterGrid.getView();
            viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
            viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
            viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
            viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
        },
        onResetButtonDown : function() { // 초기화
            panelSearch.clearForm();
            panelResult.clearForm();
//            panelSearch.setAllFieldsReadOnly(false);
//            panelResult.setAllFieldsReadOnly(false);
            masterGrid.reset();

            directMasterStore1.clearData();
            this.fnInitBinding();
        }
    });

};

</script>
