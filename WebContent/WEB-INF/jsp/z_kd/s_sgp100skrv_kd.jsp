<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_sgp100skrv_kd"  >
    <t:ExtComboStore comboType="BOR120"  pgmId="s_sgp100skrv_kd"  />             <!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="S002" /> <!--매출구분-->
    <t:ExtComboStore comboType="AU" comboCode="B004" /> <!--화폐-->
    <t:ExtComboStore comboType="AU" comboCode="B042" /> <!--계획금액단위-->
    <t:ExtComboStore comboType="AU" comboCode="S010" /> <!--영업담당-->
    <t:ExtComboStore comboType="AU" comboCode="B055" /> <!--고객분류-->
    <t:ExtComboStore comboType="AU" comboCode="B020" /> <!--품목계정-->
    <t:ExtComboStore comboType="AU" comboCode="B109" /> <!--유통-->
    <t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />   <!-- 대분류 -->
    <t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />   <!-- 중분류 -->
    <t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />   <!-- 소분류 -->
</t:appConfig>
<script type="text/javascript" >


function appMain() {

    var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 's_sgp100skrv_kdService.selectList'
        }
    });

    /**
     *   Model 정의
     * @type
     */

    Unilite.defineModel('Sgp100ukrvModel1', {
        fields: [
            {name : 'MANAGE_CUSTOM',        text: '집계거래처코드',    type : 'string'},
            {name : 'MANAGE_CUSTOM_NAME',   text: '집계거래처명',     type : 'string'},
            {name : 'CUSTOM_CODE',          text: '거래처코드',      type : 'string'},
            {name : 'CUSTOM_NAME',          text: '거래처명',       type : 'string'},
            {name : 'ITEM_CODE',            text: '품목코드',       type : 'string'},
            {name : 'ITEM_NAME',            text: '품목명',        type : 'string'},
            {name : 'SPEC',        			text: '규격/품번',         type : 'string'},
            {name : 'PLAN_TYPE1',           text: '판매유형',       type : 'string', allowBlank : false, comboType : 'AU', comboCode : 'S002'},
            {name : 'ENT_MONEY_UNIT',       text: '금액단위',       type : 'string'},
            {name : 'MONEY_UNIT',           text: '화폐',         type : 'string', allowBlank : false, comboType : 'AU', comboCode : 'B004', displayField : 'value'},
            {name : 'PLAN_TOT',             text: '계획합계',       type : 'uniPrice'},
            {name : 'RESULT_TOT',           text: '실적합계',       type : 'uniPrice'},
            {name : 'RATE_TOT',             text: '비율합계(%)',    type: 'float', decimalPrecision: 2, format: '0,000,000.00'},
            {name : 'PLAN_01',              text: '1월 계획',       type : 'uniPrice'},
            {name : 'RESULT_01',            text: '1월 실적',       type : 'uniPrice'},
            {name : 'RATE_01',              text: '1월 비율(%)',    type: 'float', decimalPrecision: 2, format: '0,000,000.00'},
            {name : 'PLAN_02',              text: '2월 계획',       type : 'uniPrice'},
            {name : 'RESULT_02',            text: '2월 실적',       type : 'uniPrice'},
            {name : 'RATE_02',              text: '2월 비율(%)',       type: 'int'},
            {name : 'PLAN_03',              text: '3월 계획',       type : 'uniPrice'},
            {name : 'RESULT_03',            text: '3월 실적',       type : 'uniPrice'},
            {name : 'RATE_03',              text: '3월 비율(%)',       type: 'int'},
            {name : 'PLAN_04',              text: '4월 계획',       type : 'uniPrice'},
            {name : 'RESULT_04',            text: '4월 실적',       type : 'uniPrice'},
            {name : 'RATE_04',              text: '4월 비율(%)',       type: 'int'},
            {name : 'PLAN_05',              text: '5월 계획',       type : 'uniPrice'},
            {name : 'RESULT_05',            text: '5월 실적',       type : 'uniPrice'},
            {name : 'RATE_05',              text: '5월 비율(%)',      type: 'int'},
            {name : 'PLAN_06',              text: '6월 계획',       type : 'uniPrice'},
            {name : 'RESULT_06',            text: '6월 실적',       type : 'uniPrice'},
            {name : 'RATE_06',              text: '6월 비율(%)',       type: 'int'},
            {name : 'PLAN_07',              text: '7월 계획',       type : 'uniPrice'},
            {name : 'RESULT_07',            text: '7월 실적',       type : 'uniPrice'},
            {name : 'RATE_07',              text: '7월 비율(%)',       type: 'int'},
            {name : 'PLAN_08',              text: '8월 계획',       type : 'uniPrice'},
            {name : 'RESULT_08',            text: '8월 실적',       type : 'uniPrice'},
            {name : 'RATE_08',              text: '8월 비율(%)',       type: 'int'},
            {name : 'PLAN_09',              text: '9월 계획',       type : 'uniPrice'},
            {name : 'RESULT_09',            text: '9월 실적',       type : 'uniPrice'},
            {name : 'RATE_09',              text: '9월 비율(%)',       type: 'int'},
            {name : 'PLAN_10',              text: '10월 계획',       type : 'uniPrice'},
            {name : 'RESULT_10',            text: '10월 실적',       type : 'uniPrice'},
            {name : 'RATE_10',              text: '10월 비율(%)',       type: 'int'},
            {name : 'PLAN_11',              text: '11월 계획',       type : 'uniPrice'},
            {name : 'RESULT_11',            text: '11월 실적',       type : 'uniPrice'},
            {name : 'RATE_11',              text: '11월 비율(%)',       type: 'int'},
            {name : 'PLAN_12',              text: '12월 계획',       type : 'uniPrice'},
            {name : 'RESULT_12',            text: '12월 실적',       type : 'uniPrice'},
            {name : 'RATE_12',              text: '12월 비율(%)',       type: 'int'}
        ]
    });

    /**
     * Store 정의(Service 정의)
     * @type
     */
    var directMasterStore1 = Unilite.createStore('s_sgp100skrv_kdMasterStore1',{
        model: 'Sgp100ukrvModel1',
        uniOpt : {
//            isMaster: true,         // 상위 버튼 연결
            isMaster: false,         // 상위 버튼 연결
            editable: false,         // 수정 모드 사용
            deletable:false,         // 삭제 가능 여부
            useNavi : false         // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
        loadStoreRecords : function()   {
            var param= panelResult.getValues();
            param.CUSTOM_CODE = subForm1.getValue('CUSTOM_CODE');
            param.TAB_ID = '1';

            console.log( param );
            this.load({
                params : param
            });
        }
    });

    var directMasterStore2 = Unilite.createStore('s_sgp100skrv_kdMasterStore2',{
        model: 'Sgp100ukrvModel1',
        uniOpt : {
//            isMaster: true,         // 상위 버튼 연결
            isMaster: false,         // 상위 버튼 연결
            editable: false,         // 수정 모드 사용
            deletable:false,         // 삭제 가능 여부
            useNavi : false         // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
        loadStoreRecords : function()   {
            var param = panelResult.getValues();
            param.ITEM_CODE = subForm2.getValue('ITEM_CODE');
            param.TAB_ID = '2';
            this.load({
                  params : param
            });
        }
    });

    var directMasterStore3 = Unilite.createStore('s_sgp100skrv_kdMasterStore3',{
        model: 'Sgp100ukrvModel1',
        uniOpt : {
//            isMaster: true,         // 상위 버튼 연결
            isMaster: false,         // 상위 버튼 연결
            editable: false,         // 수정 모드 사용
            deletable:false,         // 삭제 가능 여부
            useNavi : false         // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
        loadStoreRecords : function()   {
            var param= panelResult.getValues();
            param.CUSTOM_CODE = subForm3.getValue('CUSTOM_CODE');
            param.TAB_ID = '3';
            this.load({
                  params : param
            });
        },
        groupField : 'CUSTOM_NAME'
    });

    var directMasterStore4 = Unilite.createStore('s_sgp100skrv_kdMasterStore4',{
        model: 'Sgp100ukrvModel1',
        uniOpt : {
//            isMaster: true,         // 상위 버튼 연결
            isMaster: false,         // 상위 버튼 연결
            editable: false,         // 수정 모드 사용
            deletable:false,         // 삭제 가능 여부
            useNavi : false         // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
        loadStoreRecords : function()   {
            var param= panelResult.getValues();
            param.MANAGE_CUSTOM_CODE = subForm4.getValue('MANAGE_CUSTOM_CODE');
            param.TAB_ID = '4';
            this.load({
                  params : param
            });
        },
        groupField : 'MANAGE_CUSTOM_NAME'
    });

    var panelResult = Unilite.createSearchForm('resultForm',{
        region: 'north',
        layout : {type : 'uniTable', columns : 2},
        padding:'1 1 1 1',
        border:true,
        hidden: !UserInfo.appOption.collapseLeftSearch,
        items: [{
            fieldLabel: '사업장',
            name: 'DIV_CODE',
            xtype: 'uniCombobox',
            comboType: 'BOR120',
            allowBlank:false
        },{
            fieldLabel: '계획년도',
            name: 'PLAN_YEAR',
            xtype: 'uniYearField',
            value: new Date().getFullYear(),
            allowBlank: false
        },{
            fieldLabel: '판매유형',
            name:'ORDER_TYPE',
            xtype: 'uniCombobox',
            comboType:'AU',
            comboCode:'S002'
        },{
            fieldLabel: '화폐단위',
            name:'MONEY_UNIT',
            xtype: 'uniCombobox',
            comboType:'AU',
            comboCode:'B004',
            displayField: 'value'
        },{
            xtype: 'radiogroup',
            fieldLabel: '실적선택',
            id: 'RDO_SELECT5',
            items: [{
                boxLabel: '출고',
                width : 50,
                name: 'RDO2',
                inputValue: '1',
                checked: true
            },{
                boxLabel: '매출',
                name: 'RDO2',
                inputValue: '2'
            }]
        },{
            xtype: 'radiogroup',
            fieldLabel: '수량/금액',
            id: 'RDO_SELECT6',
            items: [{
                boxLabel: '수량',
                width : 50,
                name: 'RDO3',
                inputValue: 'QTY'
            },{
                boxLabel: '금액',
                name: 'RDO3',
                inputValue: 'AMT',
                checked: true
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
    });

    var subForm1 = Unilite.createSearchForm('subForm1', {
        padding: '0 0 0 0',
        layout:{type:'uniTable', columns: '1'},
        items: [{
            xtype: 'container',
            items:[{
                xtype: 'container',
                defaultType: 'uniTextfield',
                layout: {type: 'uniTable', columns: 1},
                width : 250,
                items: [{
                    fieldLabel: '거래처코드',
                    width : 200,
                    name: 'CUSTOM_CODE'
                }]
            }]
        }]
    });

    var subForm2 = Unilite.createSearchForm('subForm2', {
        padding: '0 0 0 0',
        layout:{type:'uniTable', columns: '1'},
        items: [{
            xtype: 'container',
            items:[{
                xtype: 'container',
                defaultType: 'uniTextfield',
                layout: {type: 'uniTable', columns: 1},
                width : 250,
                items: [{
                    fieldLabel: '품목코드',
                    width : 200,
                    name: 'ITEM_CODE'
                }]
            }]
        }]
    });

    var subForm3 = Unilite.createSearchForm('subForm3', {
        padding: '0 0 0 0',
        layout:{type:'uniTable', columns: '1'},
        items: [{
            xtype: 'container',
            items:[{
                xtype: 'container',
                defaultType: 'uniTextfield',
                layout: {type: 'uniTable', columns: 1},
                width : 250,
                items: [{
                    fieldLabel: '거래처코드',
                    width : 200,
                    name: 'CUSTOM_CODE'
                }]
            }]
        }]
    });

    var subForm4 = Unilite.createSearchForm('subForm4', {
        padding: '0 0 0 0',
        layout:{type:'uniTable', columns: '1'},
        items: [{
            xtype: 'container',
            items:[{
                xtype: 'container',
                defaultType: 'uniTextfield',
                layout: {type: 'uniTable', columns: 1},
                width : 250,
                items: [{
                    fieldLabel: '집계거래처코드',
                    width : 200,
                    name: 'MANAGE_CUSTOM_CODE'
                }]
            }]
        }]
    });

    /**
     * Master Grid1 정의(Grid Panel)
     * @type
     */

    var masterGrid1 = Unilite.createGrid('s_sgp100skrv_kdmasterGrid1', {
        layout : 'fit',
        store: directMasterStore1,
        flex: 1,
        uniOpt: {
            expandLastColumn: false,
            useMultipleSorting: true,
            useGroupSummary: false,
            useLiveSearch: true,
            useContextMenu: true,
            filter: {
                useFilter: true,
                autoCreate: true
            }
        },
        features: [
            {id: 'masterGridSubTotal',     ftype: 'uniGroupingsummary',    showSummaryRow: false},
            {id: 'masterGridTotal',        ftype: 'uniSummary',            showSummaryRow: true}
        ],
        columns:  [
            {dataIndex : 'COMP_CODE',               width : 80, hidden : true},
            {dataIndex : 'DIV_CODE',                width : 80, hidden : true},
            {dataIndex : 'CUSTOM_CODE',             width : 80, locked : true},
            {dataIndex : 'CUSTOM_NAME',             width : 150, locked : true,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                    return Unilite.renderSummaryRow(summaryData, metaData, '', '총계');
                }
            },
            {dataIndex : 'PLAN_TYPE1',              width : 100},
            {dataIndex : 'ENT_MONEY_UNIT',          width : 80},
            {dataIndex : 'MONEY_UNIT',              width : 90},
            {id : 'PLAN_TOTS'  ,dataIndex : 'PLAN_TOT',                width : 110, summaryType: 'sum'},
            {id : 'RESULT_TOTS',dataIndex : 'RESULT_TOT',              width : 110, summaryType: 'sum'},
            {dataIndex : 'RATE_TOT',                width : 110,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                	var totRateValue = 0;
                	if(summaryData.RESULT_TOTS == 0 && summaryData.PLAN_TOTS == 0 ){
                		totRateValue = 0;
					}else{
						totRateValue = summaryData.RESULT_TOTS/summaryData.PLAN_TOTS * 100
					}

                	return Unilite.renderSummaryRow(summaryData, metaData, '',  '<div style="text-align:right">'+Ext.util.Format.number(totRateValue, '0,000.00')+ '%' + '</div>');
                },renderer: function(value, metaData, record) {
                	return	 '<div style="text-align:right">'+Ext.util.Format.number(value, '0,000.00')+ '%' + '</div>';
                }
            },
            {id : 'PLAN_01S'    ,dataIndex : 'PLAN_01',                 width : 110, summaryType: 'sum'},
            {id : 'RESULT_01S'  ,dataIndex : 'RESULT_01',               width : 110, summaryType: 'sum'},
            {dataIndex : 'RATE_01',                 width : 110,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                	var totRateValue = 0;
                	if(summaryData.RESULT_01S == 0 && summaryData.PLAN_01S == 0 ){
                		totRateValue = 0;
					}else{
						totRateValue = summaryData.RESULT_01S/summaryData.PLAN_01S * 100
					}

                	return Unilite.renderSummaryRow(summaryData, metaData, '',  '<div style="text-align:right">'+Ext.util.Format.number(totRateValue, '0,000.00')+ '%' +'</div>');
                },renderer: function(value, metaData, record) {
                	return	 '<div style="text-align:right">'+Ext.util.Format.number(value, '0,000.00')+ '%' + '</div>';
                }
            },
            {id : 'PLAN_02S'    ,dataIndex : 'PLAN_02',                 width : 110, summaryType: 'sum'},
            {id : 'RESULT_02S'  ,dataIndex : 'RESULT_02',               width : 110, summaryType: 'sum'},
            {dataIndex : 'RATE_02',                 width : 110,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                	var totRateValue = 0;
                	if(summaryData.RESULT_02S == 0 && summaryData.PLAN_02S == 0 ){
                		totRateValue = 0;
					}else{
						totRateValue = summaryData.RESULT_02S/summaryData.PLAN_02S * 100
					}

                	return Unilite.renderSummaryRow(summaryData, metaData, '',  '<div style="text-align:right">'+Ext.util.Format.number(totRateValue, '0,000.00')+ '%' +'</div>');
                },renderer: function(value, metaData, record) {
                	return	 '<div style="text-align:right">'+Ext.util.Format.number(value, '0,000.00')+ '%' + '</div>';
                }
            },
            {id : 'PLAN_03S'    ,dataIndex : 'PLAN_03',                 width : 110, summaryType: 'sum'},
            {id : 'RESULT_03S'  ,dataIndex : 'RESULT_03',               width : 110, summaryType: 'sum'},
            {dataIndex : 'RATE_03',                 width : 110,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                	var totRateValue = 0;
                	if(summaryData.RESULT_03S == 0 && summaryData.PLAN_03S == 0 ){
                		totRateValue = 0;
					}else{
						totRateValue = summaryData.RESULT_03S/summaryData.PLAN_03S * 100
					}

                	return Unilite.renderSummaryRow(summaryData, metaData, '',  '<div style="text-align:right">'+Ext.util.Format.number(totRateValue, '0,000.00')+ '%' +'</div>');
                },renderer: function(value, metaData, record) {
                	return	 '<div style="text-align:right">'+Ext.util.Format.number(value, '0,000.00')+ '%' + '</div>';
                }
            },
            {id : 'PLAN_04S'    ,dataIndex : 'PLAN_04',                 width : 110, summaryType: 'sum'},
            {id : 'RESULT_04S'  ,dataIndex : 'RESULT_04',               width : 110, summaryType: 'sum'},
            {dataIndex : 'RATE_04',                 width : 110,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                	var totRateValue = 0;
                	if(summaryData.RESULT_04S == 0 && summaryData.PLAN_04S == 0 ){
                		totRateValue = 0;
					}else{
						totRateValue = summaryData.RESULT_04S/summaryData.PLAN_04S * 100
					}

                	return Unilite.renderSummaryRow(summaryData, metaData, '',  '<div style="text-align:right">'+Ext.util.Format.number(totRateValue, '0,000.00')+ '%' +'</div>');
                },renderer: function(value, metaData, record) {
                	return	 '<div style="text-align:right">'+Ext.util.Format.number(value, '0,000.00')+ '%' + '</div>';
                }
            },
            {id : 'PLAN_05S'    ,dataIndex : 'PLAN_05',                 width : 110, summaryType: 'sum'},
            {id : 'RESULT_05S'  ,dataIndex : 'RESULT_05',               width : 110, summaryType: 'sum'},
            {dataIndex : 'RATE_05',                 width : 110,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                	var totRateValue = 0;
                	if(summaryData.RESULT_05S == 0 && summaryData.PLAN_05S == 0 ){
                		totRateValue = 0;
					}else{
						totRateValue = summaryData.RESULT_05S/summaryData.PLAN_05S * 100
					}

                	return Unilite.renderSummaryRow(summaryData, metaData, '',  '<div style="text-align:right">'+Ext.util.Format.number(totRateValue, '0,000.00')+ '%' +'</div>');
                },renderer: function(value, metaData, record) {
                	return	 '<div style="text-align:right">'+Ext.util.Format.number(value, '0,000.00')+ '%' + '</div>';
                }
            },
            {id : 'PLAN_06S'   ,dataIndex : 'PLAN_06',                 width : 110, summaryType: 'sum'},
            {id : 'RESULT_06S'  ,dataIndex : 'RESULT_06',               width : 110, summaryType: 'sum'},
            {dataIndex : 'RATE_06',                 width : 110,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                	var totRateValue = 0;
                	if(summaryData.RESULT_06S == 0 && summaryData.PLAN_06S == 0 ){
                		totRateValue = 0;
					}else{
						totRateValue = summaryData.RESULT_06S/summaryData.PLAN_06S * 100
					}

                	return Unilite.renderSummaryRow(summaryData, metaData, '',  '<div style="text-align:right">'+Ext.util.Format.number(totRateValue, '0,000.00')+ '%' +'</div>');
                },renderer: function(value, metaData, record) {
                	return	 '<div style="text-align:right">'+Ext.util.Format.number(value, '0,000.00')+ '%' + '</div>';
                }
            },
            {id : 'PLAN_07S'   ,dataIndex : 'PLAN_07',                 width : 110, summaryType: 'sum'},
            {id : 'RESULT_07S'  ,dataIndex : 'RESULT_07',               width : 110, summaryType: 'sum'},
            {dataIndex : 'RATE_07',                 width : 110,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                	var totRateValue = 0;
                	if(summaryData.RESULT_07S == 0 && summaryData.PLAN_07S == 0 ){
                		totRateValue = 0;
					}else{
						totRateValue = summaryData.RESULT_07S/summaryData.PLAN_07S * 100
					}

                	return Unilite.renderSummaryRow(summaryData, metaData, '',  '<div style="text-align:right">'+Ext.util.Format.number(totRateValue, '0,000.00')+ '%' +'</div>');
                },renderer: function(value, metaData, record) {
                	return	 '<div style="text-align:right">'+Ext.util.Format.number(value, '0,000.00')+ '%' + '</div>';
                }
            },
            {id : 'PLAN_08S'   ,dataIndex : 'PLAN_08',                 width : 110, summaryType: 'sum'},
            {id : 'RESULT_08S'  ,dataIndex : 'RESULT_08',               width : 110, summaryType: 'sum'},
            {dataIndex : 'RATE_08',                 width : 110,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                	var totRateValue = 0;
                	if(summaryData.RESULT_08S == 0 && summaryData.PLAN_08S == 0 ){
                		totRateValue = 0;
					}else{
						totRateValue = summaryData.RESULT_08S/summaryData.PLAN_08S * 100
					}

                	return Unilite.renderSummaryRow(summaryData, metaData, '',  '<div style="text-align:right">'+Ext.util.Format.number(totRateValue, '0,000.00')+ '%' +'</div>');
                },renderer: function(value, metaData, record) {
                	return	 '<div style="text-align:right">'+Ext.util.Format.number(value, '0,000.00')+ '%' + '</div>';
                }
            },
            {id : 'PLAN_09S'   ,dataIndex : 'PLAN_09',                 width : 110, summaryType: 'sum'},
            {id : 'RESULT_09S'  ,dataIndex : 'RESULT_09',               width : 110, summaryType: 'sum'},
            {dataIndex : 'RATE_09',                 width : 110,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                	var totRateValue = 0;
                	if(summaryData.RESULT_09S == 0 && summaryData.PLAN_09S == 0 ){
                		totRateValue = 0;
					}else{
						totRateValue = summaryData.RESULT_09S/summaryData.PLAN_09S * 100
					}

                	return Unilite.renderSummaryRow(summaryData, metaData, '',  '<div style="text-align:right">'+Ext.util.Format.number(totRateValue, '0,000.00')+ '%'+'</div>');
                },renderer: function(value, metaData, record) {
                	return	 '<div style="text-align:right">'+Ext.util.Format.number(value, '0,000.00')+ '%' + '</div>';
                }
            },
            {id : 'PLAN_10S'   ,dataIndex : 'PLAN_10',                 width : 110, summaryType: 'sum'},
            {id : 'RESULT_10S'  ,dataIndex : 'RESULT_10',               width : 110, summaryType: 'sum'},
            {dataIndex : 'RATE_10',                 width : 110,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                	var totRateValue = 0;
                	if(summaryData.RESULT_10S == 0 && summaryData.PLAN_10S == 0 ){
                		totRateValue = 0;
					}else{
						totRateValue = summaryData.RESULT_10S/summaryData.PLAN_10S * 100
					}

                	return Unilite.renderSummaryRow(summaryData, metaData, '',  '<div style="text-align:right">'+Ext.util.Format.number(totRateValue, '0,000.00')+ '%'+'</div>');
                },renderer: function(value, metaData, record) {
                	return	 '<div style="text-align:right">'+Ext.util.Format.number(value, '0,000.00')+ '%' + '</div>';
                }
            },
            {id : 'PLAN_11S'   ,dataIndex : 'PLAN_11',                 width : 110, summaryType: 'sum'},
            {id : 'RESULT_11S'  ,dataIndex : 'RESULT_11',               width : 110, summaryType: 'sum'},
            {dataIndex : 'RATE_11',                 width : 110,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                	var totRateValue = 0;
                	if(summaryData.RESULT_11S == 0 && summaryData.PLAN_11S == 0 ){
                		totRateValue = 0;
					}else{
						totRateValue = summaryData.RESULT_11S/summaryData.PLAN_11S * 100
					}

                	return Unilite.renderSummaryRow(summaryData, metaData, '',  '<div style="text-align:right">'+Ext.util.Format.number(totRateValue, '0,000.00')+ '%'+'</div>');
                },renderer: function(value, metaData, record) {
                	return	 '<div style="text-align:right">'+Ext.util.Format.number(value, '0,000.00')+ '%' + '</div>';
                }
            },
            {id : 'PLAN_12S'    ,dataIndex : 'PLAN_12',                 width : 110, summaryType: 'sum'},
            {id : 'RESULT_12S'  ,dataIndex : 'RESULT_12',               width : 110, summaryType: 'sum'},
            {dataIndex : 'RATE_12',                 width : 110,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                	var totRateValue = 0;
                	if(summaryData.RESULT_12S == 0 && summaryData.PLAN_12S == 0 ){
                		totRateValue = 0;
					}else{
						totRateValue = summaryData.RESULT_12S/summaryData.PLAN_12S * 100
					}

                	return Unilite.renderSummaryRow(summaryData, metaData, '',  '<div style="text-align:right">'+Ext.util.Format.number(totRateValue, '0,000.00')+ '%'+'</div>');
                },renderer: function(value, metaData, record) {
                	return	 '<div style="text-align:right">'+Ext.util.Format.number(value, '0,000.00')+ '%' + '</div>';
                }
            }
        ]
    });

    var activeGrid = masterGrid1;

    var masterGrid2 = Unilite.createGrid('s_sgp100skrv_kdmasterGrid2', {
        layout : 'fit',
        store: directMasterStore2,
        flex: 1,
        uniOpt: {
            expandLastColumn: false,
            useMultipleSorting: true,
            useGroupSummary: false,
            useLiveSearch: true,
            useContextMenu: true,
            filter: {
                useFilter: true,
                autoCreate: true
            }
        },
        features: [
            {id: 'masterGridSubTotal',     ftype: 'uniGroupingsummary',    showSummaryRow: false},
            {id: 'masterGridTotal',        ftype: 'uniSummary',            showSummaryRow: true}
        ],
        columns:  [
            {dataIndex : 'COMP_CODE',               width : 80, hidden : true},
            {dataIndex : 'DIV_CODE',                width : 80, hidden : true},
            {dataIndex : 'ITEM_CODE',               width : 110, locked : true},
            {dataIndex : 'ITEM_NAME',               width : 150, locked : true,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                    return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
                }
            },
            {dataIndex : 'SPEC',  			        width : 110},
            {dataIndex : 'PLAN_TYPE1',              width : 100},
            {dataIndex : 'ENT_MONEY_UNIT',          width : 80},
            {dataIndex : 'MONEY_UNIT',              width : 90},
            {id : 'PLAN_TOTS2'    ,dataIndex : 'PLAN_TOT',                width : 110, summaryType: 'sum'},
            {id : 'RESULT_TOTS2'  ,dataIndex : 'RESULT_TOT',              width : 110, summaryType: 'sum'},
            {dataIndex : 'RATE_TOT',                width : 110,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                	var totRateValue = 0;
                	if(summaryData.RESULT_TOTS2 == 0 && summaryData.PLAN_TOTS2 == 0 ){
                		totRateValue = 0;
					}else{
						totRateValue = summaryData.RESULT_TOTS2/summaryData.PLAN_TOTS2 * 100
					}

                	return Unilite.renderSummaryRow(summaryData, metaData, '',  '<div style="text-align:right">'+Ext.util.Format.number(totRateValue, '0,000.00')+ '%'+'</div>');
                },renderer: function(value, metaData, record) {
                	return	 '<div style="text-align:right">'+Ext.util.Format.number(value, '0,000.00')+ '%' + '</div>';
                }
            },
            {id : 'PLAN_01S2'    ,dataIndex : 'PLAN_01',                 width : 110, summaryType: 'sum'},
            {id : 'RESULT_01S2'  ,dataIndex : 'RESULT_01',               width : 110, summaryType: 'sum'},
            {dataIndex : 'RATE_01',                 width : 110,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                	var totRateValue = 0;
                	if(summaryData.RESULT_01S2 == 0 && summaryData.PLAN_01S2 == 0 ){
                		totRateValue = 0;
					}else{
						totRateValue = summaryData.RESULT_01S2/summaryData.PLAN_01S2 * 100
					}

                	return Unilite.renderSummaryRow(summaryData, metaData, '',  '<div style="text-align:right">'+Ext.util.Format.number(totRateValue, '0,000.00')+ '%'+'</div>');
                },renderer: function(value, metaData, record) {
                	return	 '<div style="text-align:right">'+Ext.util.Format.number(value, '0,000.00')+ '%' + '</div>';
                }
            },
            {id : 'PLAN_02S2'    ,dataIndex : 'PLAN_02',                 width : 110, summaryType: 'sum'},
            {id : 'RESULT_02S2'  ,dataIndex : 'RESULT_02',               width : 110, summaryType: 'sum'},
            {dataIndex : 'RATE_02',                 width : 110,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                	var totRateValue = 0;
                	if(summaryData.RESULT_02S2 == 0 && summaryData.PLAN_02S2 == 0 ){
                		totRateValue = 0;
					}else{
						totRateValue = summaryData.RESULT_02S2/summaryData.PLAN_02S2 * 100
					}

                	return Unilite.renderSummaryRow(summaryData, metaData, '',  '<div style="text-align:right">'+Ext.util.Format.number(totRateValue, '0,000.00')+ '%'+'</div>');
                },renderer: function(value, metaData, record) {
                	return	 '<div style="text-align:right">'+Ext.util.Format.number(value, '0,000.00')+ '%' + '</div>';
                }
            },
            {id : 'PLAN_03S2'    ,dataIndex : 'PLAN_03',                 width : 110, summaryType: 'sum'},
            {id : 'RESULT_03S2'  ,dataIndex : 'RESULT_03',               width : 110, summaryType: 'sum'},
            {dataIndex : 'RATE_03',                 width : 110,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                	var totRateValue = 0;
                	if(summaryData.RESULT_03S2 == 0 && summaryData.PLAN_03S2 == 0 ){
                		totRateValue = 0;
					}else{
						totRateValue = summaryData.RESULT_03S2/summaryData.PLAN_03S2 * 100
					}

                	return Unilite.renderSummaryRow(summaryData, metaData, '',  '<div style="text-align:right">'+Ext.util.Format.number(totRateValue, '0,000.00')+ '%'+'</div>');
                },renderer: function(value, metaData, record) {
                	return	 '<div style="text-align:right">'+Ext.util.Format.number(value, '0,000.00')+ '%' + '</div>';
                }
            },
            {id : 'PLAN_04S2'    ,dataIndex : 'PLAN_04',                 width : 110, summaryType: 'sum'},
            {id : 'RESULT_04S2'  ,dataIndex : 'RESULT_04',               width : 110, summaryType: 'sum'},
            {dataIndex : 'RATE_04',                 width : 110,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                	var totRateValue = 0;
                	if(summaryData.RESULT_04S2 == 0 && summaryData.PLAN_04S2 == 0 ){
                		totRateValue = 0;
					}else{
						totRateValue = summaryData.RESULT_04S2/summaryData.PLAN_04S2 * 100
					}

                	return Unilite.renderSummaryRow(summaryData, metaData, '',  '<div style="text-align:right">'+Ext.util.Format.number(totRateValue, '0,000.00')+ '%'+'</div>');
                },renderer: function(value, metaData, record) {
                	return	 '<div style="text-align:right">'+Ext.util.Format.number(value, '0,000.00')+ '%' + '</div>';
                }
            },
            {id : 'PLAN_05S2'    ,dataIndex : 'PLAN_05',                 width : 110, summaryType: 'sum'},
            {id : 'RESULT_05S2'  ,dataIndex : 'RESULT_05',               width : 110, summaryType: 'sum'},
            {dataIndex : 'RATE_05',                 width : 110,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                	var totRateValue = 0;
                	if(summaryData.RESULT_05S2 == 0 && summaryData.PLAN_05S2 == 0 ){
                		totRateValue = 0;
					}else{
						totRateValue = summaryData.RESULT_05S2/summaryData.PLAN_05S2 * 100
					}

                	return Unilite.renderSummaryRow(summaryData, metaData, '',  '<div style="text-align:right">'+Ext.util.Format.number(totRateValue, '0,000.00')+ '%'+'</div>');
                },renderer: function(value, metaData, record) {
                	return	 '<div style="text-align:right">'+Ext.util.Format.number(value, '0,000.00')+ '%' + '</div>';
                }
            },
            {id : 'PLAN_06S2'    ,dataIndex : 'PLAN_06',                 width : 110, summaryType: 'sum'},
            {id : 'RESULT_06S2'  ,dataIndex : 'RESULT_06',               width : 110, summaryType: 'sum'},
            {dataIndex : 'RATE_06',                 width : 110,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                	var totRateValue = 0;
                	if(summaryData.RESULT_06S2 == 0 && summaryData.PLAN_06S2 == 0 ){
                		totRateValue = 0;
					}else{
						totRateValue = summaryData.RESULT_06S2/summaryData.PLAN_06S2 * 100
					}

                	return Unilite.renderSummaryRow(summaryData, metaData, '',  '<div style="text-align:right">'+Ext.util.Format.number(totRateValue, '0,000.00')+ '%'+'</div>');
                }},
            {id : 'PLAN_07S2'    ,dataIndex : 'PLAN_07',                 width : 110, summaryType: 'sum'},
            {id : 'RESULT_07S2'  ,dataIndex : 'RESULT_07',               width : 110, summaryType: 'sum'},
            {dataIndex : 'RATE_07',                 width : 110,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                	var totRateValue = 0;
                	if(summaryData.RESULT_07S2 == 0 && summaryData.PLAN_07S2 == 0 ){
                		totRateValue = 0;
					}else{
						totRateValue = summaryData.RESULT_07S2/summaryData.PLAN_07S2 * 100
					}

                	return Unilite.renderSummaryRow(summaryData, metaData, '',  '<div style="text-align:right">'+Ext.util.Format.number(totRateValue, '0,000.00')+ '%'+'</div>');
                },renderer: function(value, metaData, record) {
                	return	 '<div style="text-align:right">'+Ext.util.Format.number(value, '0,000.00')+ '%' + '</div>';
                }
            },
            {id : 'PLAN_08S2'    ,dataIndex : 'PLAN_08',                 width : 110, summaryType: 'sum'},
            {id : 'RESULT_08S2'  ,dataIndex : 'RESULT_08',               width : 110, summaryType: 'sum'},
            {dataIndex : 'RATE_08',                 width : 110,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                	var totRateValue = 0;
                	if(summaryData.RESULT_08S2 == 0 && summaryData.PLAN_08S2 == 0 ){
                		totRateValue = 0;
					}else{
						totRateValue = summaryData.RESULT_08S2/summaryData.PLAN_08S2 * 100
					}

                	return Unilite.renderSummaryRow(summaryData, metaData, '',  '<div style="text-align:right">'+Ext.util.Format.number(totRateValue, '0,000.00')+ '%'+'</div>');
                },renderer: function(value, metaData, record) {
                	return	 '<div style="text-align:right">'+Ext.util.Format.number(value, '0,000.00')+ '%' + '</div>';
                }
            },
            {id : 'PLAN_09S2'    ,dataIndex : 'PLAN_09',                 width : 110, summaryType: 'sum'},
            {id : 'RESULT_09S2'  ,dataIndex : 'RESULT_09',               width : 110, summaryType: 'sum'},
            {dataIndex : 'RATE_09',                 width : 110,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                	var totRateValue = 0;
                	if(summaryData.RESULT_09S2 == 0 && summaryData.PLAN_09S2 == 0 ){
                		totRateValue = 0;
					}else{
						totRateValue = summaryData.RESULT_09S2/summaryData.PLAN_09S2 * 100
					}

                	return Unilite.renderSummaryRow(summaryData, metaData, '',  '<div style="text-align:right">'+Ext.util.Format.number(totRateValue, '0,000.00')+ '%'+'</div>');
                },renderer: function(value, metaData, record) {
                	return	 '<div style="text-align:right">'+Ext.util.Format.number(value, '0,000.00')+ '%' + '</div>';
                }
            },
            {id : 'PLAN_10S2'    ,dataIndex : 'PLAN_10',                 width : 110, summaryType: 'sum'},
            {id : 'RESULT_10S2'  ,dataIndex : 'RESULT_10',               width : 110, summaryType: 'sum'},
            {dataIndex : 'RATE_10',                 width : 110,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                	var totRateValue = 0;
                	if(summaryData.RESULT_10S2 == 0 && summaryData.PLAN_10S2 == 0 ){
                		totRateValue = 0;
					}else{
						totRateValue = summaryData.RESULT_10S2/summaryData.PLAN_10S2 * 100
					}

                	return Unilite.renderSummaryRow(summaryData, metaData, '',  '<div style="text-align:right">'+Ext.util.Format.number(totRateValue, '0,000.00')+ '%'+'</div>');
                },renderer: function(value, metaData, record) {
                	return	 '<div style="text-align:right">'+Ext.util.Format.number(value, '0,000.00')+ '%' + '</div>';
                }
            },
            {id : 'PLAN_11S2'    ,dataIndex : 'PLAN_11',                 width : 110, summaryType: 'sum'},
            {id : 'RESULT_11S2'  ,dataIndex : 'RESULT_11',               width : 110, summaryType: 'sum'},
            {dataIndex : 'RATE_11',                 width : 110,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                	var totRateValue = 0;
                	if(summaryData.RESULT_11S2 == 0 && summaryData.PLAN_11S2 == 0 ){
                		totRateValue = 0;
					}else{
						totRateValue = summaryData.RESULT_11S2/summaryData.PLAN_11S2 * 100
					}

                	return Unilite.renderSummaryRow(summaryData, metaData, '',  '<div style="text-align:right">'+Ext.util.Format.number(totRateValue, '0,000.00')+ '%'+'</div>');
                },renderer: function(value, metaData, record) {
                	return	 '<div style="text-align:right">'+Ext.util.Format.number(value, '0,000.00')+ '%' + '</div>';
                }
            },
            {id : 'PLAN_12S2'    ,dataIndex : 'PLAN_12',                 width : 110, summaryType: 'sum'},
            {id : 'RESULT_12S2'  ,dataIndex : 'RESULT_12',               width : 110, summaryType: 'sum'},
            {dataIndex : 'RATE_12',                 width : 110,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                	var totRateValue = 0;
                	if(summaryData.RESULT_12S2 == 0 && summaryData.PLAN_12S2 == 0 ){
                		totRateValue = 0;
					}else{
						totRateValue = summaryData.RESULT_12S2/summaryData.PLAN_12S2 * 100
					}

                	return Unilite.renderSummaryRow(summaryData, metaData, '',  '<div style="text-align:right">'+Ext.util.Format.number(totRateValue, '0,000.00')+ '%'+'</div>');
                },renderer: function(value, metaData, record) {
                	return	 '<div style="text-align:right">'+Ext.util.Format.number(value, '0,000.00')+ '%' + '</div>';
                }
            }
        ]
    });

    var masterGrid3 = Unilite.createGrid('s_sgp100skrv_kdmasterGrid3', {
        layout : 'fit',
        store: directMasterStore3,
        flex: 1,
        uniOpt: {
            expandLastColumn: false,
            useMultipleSorting: true,
            useGroupSummary: false,
            useLiveSearch: true,
            useContextMenu: true,
            filter: {
                useFilter: true,
                autoCreate: true
            }
        },
        features: [
            {id: 'masterGridSubTotal',     ftype: 'uniGroupingsummary',    showSummaryRow: true},
            {id: 'masterGridTotal',        ftype: 'uniSummary',            showSummaryRow: true}
        ],
        columns:  [
            {dataIndex : 'COMP_CODE',               width : 80, hidden : true},
            {dataIndex : 'DIV_CODE',                width : 80, hidden : true},
            {dataIndex : 'CUSTOM_CODE',             width : 80, locked : true},
            {dataIndex : 'CUSTOM_NAME',             width : 150, locked : true,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                    return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
                }
            },
            {dataIndex : 'ITEM_CODE',               width : 110},
            {dataIndex : 'ITEM_NAME',               width : 150},
            {dataIndex : 'SPEC',           			width : 110},
            {dataIndex : 'PLAN_TYPE1',              width : 100},
            {dataIndex : 'ENT_MONEY_UNIT',          width : 80},
            {dataIndex : 'MONEY_UNIT',              width : 90},
            {id : 'PLAN_TOTS3'  ,dataIndex : 'PLAN_TOT',                width : 110, summaryType: 'sum'},
            {id : 'RESULT_TOTS3',dataIndex : 'RESULT_TOT',              width : 110, summaryType: 'sum'},
            {dataIndex : 'RATE_TOT',                width : 110,
            	summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                	var totRateValue = 0;
                	if(summaryData.RESULT_TOTS3 == 0 && summaryData.PLAN_TOTS3 == 0 ){
                		totRateValue = 0;
					}else{
						totRateValue = summaryData.RESULT_TOTS3/summaryData.PLAN_TOTS3 * 100
					}

                	return Unilite.renderSummaryRow(summaryData, metaData, '',  '<div style="text-align:right">'+Ext.util.Format.number(totRateValue, '0,000.00')+ '%' + '</div>');
                },renderer: function(value, metaData, record) {
                	return	 '<div style="text-align:right">'+Ext.util.Format.number(value, '0,000.00')+ '%' + '</div>';
                }
            },
            {id : 'PLAN_01S3'    ,dataIndex : 'PLAN_01',                 width : 110, summaryType: 'sum'},
            {id : 'RESULT_01S3'  ,dataIndex : 'RESULT_01',               width : 110, summaryType: 'sum'},
            {dataIndex : 'RATE_01',                 width : 110,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                	var totRateValue = 0;
                	if(summaryData.RESULT_01S3 == 0 && summaryData.PLAN_01S3 == 0 ){
                		totRateValue = 0;
					}else{
						totRateValue = summaryData.RESULT_01S3/summaryData.PLAN_01S3 * 100
					}

                	return Unilite.renderSummaryRow(summaryData, metaData, '',  '<div style="text-align:right">'+Ext.util.Format.number(totRateValue, '0,000.00')+ '%' +'</div>');
                },renderer: function(value, metaData, record) {
                	return	 '<div style="text-align:right">'+Ext.util.Format.number(value, '0,000.00')+ '%' + '</div>';
                }
            },
            {id : 'PLAN_02S3'    ,dataIndex : 'PLAN_02',                 width : 110, summaryType: 'sum'},
            {id : 'RESULT_02S3'  ,dataIndex : 'RESULT_02',               width : 110, summaryType: 'sum'},
            {dataIndex : 'RATE_02',                 width : 110,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                	var totRateValue = 0;
                	if(summaryData.RESULT_02S3 == 0 && summaryData.PLAN_02S3 == 0 ){
                		totRateValue = 0;
					}else{
						totRateValue = summaryData.RESULT_02S3/summaryData.PLAN_02S3 * 100
					}

                	return Unilite.renderSummaryRow(summaryData, metaData, '',  '<div style="text-align:right">'+Ext.util.Format.number(totRateValue, '0,000.00')+ '%' +'</div>');
                },renderer: function(value, metaData, record) {
                	return	 '<div style="text-align:right">'+Ext.util.Format.number(value, '0,000.00')+ '%' + '</div>';
                }
            },
            {id : 'PLAN_03S3'    ,dataIndex : 'PLAN_03',                 width : 110, summaryType: 'sum'},
            {id : 'RESULT_03S3'  ,dataIndex : 'RESULT_03',               width : 110, summaryType: 'sum'},
            {dataIndex : 'RATE_03',                 width : 110,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                	var totRateValue = 0;
                	if(summaryData.RESULT_03S3 == 0 && summaryData.PLAN_03S3 == 0 ){
                		totRateValue = 0;
					}else{
						totRateValue = summaryData.RESULT_03S3/summaryData.PLAN_03S3 * 100
					}

                	return Unilite.renderSummaryRow(summaryData, metaData, '',  '<div style="text-align:right">'+Ext.util.Format.number(totRateValue, '0,000.00')+ '%' +'</div>');
                },renderer: function(value, metaData, record) {
                	return	 '<div style="text-align:right">'+Ext.util.Format.number(value, '0,000.00')+ '%' + '</div>';
                }
            },
            {id : 'PLAN_04S3'    ,dataIndex : 'PLAN_04',                 width : 110, summaryType: 'sum'},
            {id : 'RESULT_04S3'  ,dataIndex : 'RESULT_04',               width : 110, summaryType: 'sum'},
            {dataIndex : 'RATE_04',                 width : 110,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                	var totRateValue = 0;
                	if(summaryData.RESULT_04S3 == 0 && summaryData.PLAN_04S3 == 0 ){
                		totRateValue = 0;
					}else{
						totRateValue = summaryData.RESULT_04S3/summaryData.PLAN_04S3 * 100
					}

                	return Unilite.renderSummaryRow(summaryData, metaData, '',  '<div style="text-align:right">'+Ext.util.Format.number(totRateValue, '0,000.00')+ '%' +'</div>');
                },renderer: function(value, metaData, record) {
                	return	 '<div style="text-align:right">'+Ext.util.Format.number(value, '0,000.00')+ '%' + '</div>';
                }

            },
            {id : 'PLAN_05S3'    ,dataIndex : 'PLAN_05',                 width : 110, summaryType: 'sum'},
            {id : 'RESULT_05S3'  ,dataIndex : 'RESULT_05',               width : 110, summaryType: 'sum'},
            {dataIndex : 'RATE_05',                 width : 110,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                	var totRateValue = 0;
                	if(summaryData.RESULT_05S3 == 0 && summaryData.PLAN_05S3 == 0 ){
                		totRateValue = 0;
					}else{
						totRateValue = summaryData.RESULT_05S3/summaryData.PLAN_05S3 * 100
					}

                	return Unilite.renderSummaryRow(summaryData, metaData, '',  '<div style="text-align:right">'+Ext.util.Format.number(totRateValue, '0,000.00')+ '%' +'</div>');
                },renderer: function(value, metaData, record) {
                	return	 '<div style="text-align:right">'+Ext.util.Format.number(value, '0,000.00')+ '%' + '</div>';
                }
            },
            {id : 'PLAN_06S3'    ,dataIndex : 'PLAN_06',                 width : 110, summaryType: 'sum'},
            {id : 'RESULT_06S3'  ,dataIndex : 'RESULT_06',               width : 110, summaryType: 'sum'},
            {dataIndex : 'RATE_06',                 width : 110,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                	var totRateValue = 0;
                	if(summaryData.RESULT_06S3 == 0 && summaryData.PLAN_06S3 == 0 ){
                		totRateValue = 0;
					}else{
						totRateValue = summaryData.RESULT_06S3/summaryData.PLAN_06S3 * 100
					}

                	return Unilite.renderSummaryRow(summaryData, metaData, '',  '<div style="text-align:right">'+Ext.util.Format.number(totRateValue, '0,000.00')+ '%' +'</div>');
                },renderer: function(value, metaData, record) {
                	return	 '<div style="text-align:right">'+Ext.util.Format.number(value, '0,000.00')+ '%' + '</div>';
                }
            },
            {id : 'PLAN_07S3'    ,dataIndex : 'PLAN_07',                 width : 110, summaryType: 'sum'},
            {id : 'RESULT_07S3'  ,dataIndex : 'RESULT_07',               width : 110, summaryType: 'sum'},
            {dataIndex : 'RATE_07',                 width : 110,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                	var totRateValue = 0;
                	if(summaryData.RESULT_07S3 == 0 && summaryData.PLAN_07S3 == 0 ){
                		totRateValue = 0;
					}else{
						totRateValue = summaryData.RESULT_07S3/summaryData.PLAN_07S3 * 100
					}

                	return Unilite.renderSummaryRow(summaryData, metaData, '',  '<div style="text-align:right">'+Ext.util.Format.number(totRateValue, '0,000.00')+ '%' +'</div>');
                },renderer: function(value, metaData, record) {
                	return	 '<div style="text-align:right">'+Ext.util.Format.number(value, '0,000.00')+ '%' + '</div>';
                }

            },
            {id : 'PLAN_08S3'    ,dataIndex : 'PLAN_08',                 width : 110, summaryType: 'sum'},
            {id : 'RESULT_08S3'  ,dataIndex : 'RESULT_08',               width : 110, summaryType: 'sum'},
            {dataIndex : 'RATE_08',                 width : 110,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                	var totRateValue = 0;
                	if(summaryData.RESULT_08S3 == 0 && summaryData.PLAN_08S3 == 0 ){
                		totRateValue = 0;
					}else{
						totRateValue = summaryData.RESULT_08S3 /summaryData.PLAN_08S3 * 100
					}

                	return Unilite.renderSummaryRow(summaryData, metaData, '',  '<div style="text-align:right">'+Ext.util.Format.number(totRateValue, '0,000.00')+ '%' +'</div>');
                },renderer: function(value, metaData, record) {
                	return	 '<div style="text-align:right">'+Ext.util.Format.number(value, '0,000.00')+ '%' + '</div>';
                }
            },
            {id : 'PLAN_09S3'    ,dataIndex : 'PLAN_09',                 width : 110, summaryType: 'sum'},
            {id : 'RESULT_09S3'  ,dataIndex : 'RESULT_09',               width : 110, summaryType: 'sum'},
            {dataIndex : 'RATE_09',                 width : 110,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                	var totRateValue = 0;
                	if(summaryData.RESULT_09S3 == 0 && summaryData.PLAN_09S3 == 0 ){
                		totRateValue = 0;
					}else{
						totRateValue = summaryData.RESULT_09S3 /summaryData.PLAN_09S3 * 100
					}

                	return Unilite.renderSummaryRow(summaryData, metaData, '',  '<div style="text-align:right">'+Ext.util.Format.number(totRateValue, '0,000.00')+ '%'+'</div>');
                },renderer: function(value, metaData, record) {
                	return	 '<div style="text-align:right">'+Ext.util.Format.number(value, '0,000.00')+ '%' + '</div>';
                }

            },
            {id : 'PLAN_10S3'    ,dataIndex : 'PLAN_10',                 width : 110, summaryType: 'sum'},
            {id : 'RESULT_10S3'  ,dataIndex : 'RESULT_10',               width : 110, summaryType: 'sum'},
            {dataIndex : 'RATE_10',                 width : 110,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                	var totRateValue = 0;
                	if(summaryData.RESULT_10S3 == 0 && summaryData.PLAN_10S == 0 ){
                		totRateValue = 0;
					}else{
						totRateValue = summaryData.RESULT_10S3 /summaryData.PLAN_10S3 * 100
					}

                	return Unilite.renderSummaryRow(summaryData, metaData, '',  '<div style="text-align:right">'+Ext.util.Format.number(totRateValue, '0,000.00')+ '%'+'</div>');
                },renderer: function(value, metaData, record) {
                	return	 '<div style="text-align:right">'+Ext.util.Format.number(value, '0,000.00')+ '%' + '</div>';
                }

            },
            {id : 'PLAN_11S3'    ,dataIndex : 'PLAN_11',                 width : 110, summaryType: 'sum'},
            {id : 'RESULT_11S3'  ,dataIndex : 'RESULT_11',               width : 110, summaryType: 'sum'},
            {dataIndex : 'RATE_11',                 width : 110,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                	var totRateValue = 0;
                	if(summaryData.RESULT_11S3 == 0 && summaryData.PLAN_11S3 == 0 ){
                		totRateValue = 0;
					}else{
						totRateValue = summaryData.RESULT_11S3 /summaryData.PLAN_11S3 * 100
					}

                	return Unilite.renderSummaryRow(summaryData, metaData, '',  '<div style="text-align:right">'+Ext.util.Format.number(totRateValue, '0,000.00')+ '%'+'</div>');
                },renderer: function(value, metaData, record) {
                	return	 '<div style="text-align:right">'+Ext.util.Format.number(value, '0,000.00')+ '%' + '</div>';
                }

            },
            {id : 'PLAN_12S3'    ,dataIndex : 'PLAN_12',                 width : 110, summaryType: 'sum'},
            {id : 'RESULT_12S3'  ,dataIndex : 'RESULT_12',               width : 110, summaryType: 'sum'},
            {dataIndex : 'RATE_12',                 width : 110,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                	var totRateValue = 0;
                	if(summaryData.RESULT_12S3 == 0 && summaryData.PLAN_12S3 == 0 ){
                		totRateValue = 0;
					}else{
						totRateValue = summaryData.RESULT_12S3 /summaryData.PLAN_12S3  * 100
					}

                	return Unilite.renderSummaryRow(summaryData, metaData, '',  '<div style="text-align:right">'+Ext.util.Format.number(totRateValue, '0,000.00')+ '%'+'</div>');
                },renderer: function(value, metaData, record) {
                	return	 '<div style="text-align:right">'+Ext.util.Format.number(value, '0,000.00')+ '%' + '</div>';
                }

            }
        ]
    });

    var masterGrid4 = Unilite.createGrid('s_sgp100skrv_kdmasterGrid4', {
        layout : 'fit',
        store: directMasterStore4,
        flex: 1,
        uniOpt: {
            expandLastColumn: false,
            useMultipleSorting: true,
            useGroupSummary: false,
            useLiveSearch: true,
            useContextMenu: true,
            filter: {
                useFilter: true,
                autoCreate: true
            }
        },
        features: [
            {id: 'masterGridSubTotal',     ftype: 'uniGroupingsummary',    showSummaryRow: true},
            {id: 'masterGridTotal',        ftype: 'uniSummary',            showSummaryRow: true}
        ],
        columns:  [
            {dataIndex : 'COMP_CODE',               width : 80, hidden : true},
            {dataIndex : 'DIV_CODE',                width : 80, hidden : true},
            {dataIndex : 'MANAGE_CUSTOM',           width : 110, locked : true},
            {dataIndex : 'MANAGE_CUSTOM_NAME',      width : 150, locked : true,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                    return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
                }
            },
            {dataIndex : 'PLAN_TYPE1',              width : 100},
            {dataIndex : 'ENT_MONEY_UNIT',          width : 80},
            {dataIndex : 'MONEY_UNIT',              width : 90},
            {id : 'PLAN_TOTS4'  ,dataIndex : 'PLAN_TOT',                width : 110, summaryType: 'sum'},
            {id : 'RESULT_TOTS4',dataIndex : 'RESULT_TOT',              width : 110, summaryType: 'sum'},
            {dataIndex : 'RATE_TOT',                width : 110,
            	summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                	var totRateValue = 0;
                	if(summaryData.RESULT_TOTS4 == 0 && summaryData.PLAN_TOTS4 == 0 ){
                		totRateValue = 0;
					}else{
						totRateValue = summaryData.RESULT_TOTS4 /summaryData.PLAN_TOTS4 * 100
					}

                	return Unilite.renderSummaryRow(summaryData, metaData, '',  '<div style="text-align:right">'+Ext.util.Format.number(totRateValue, '0,000.00')+ '%' + '</div>');
                },renderer: function(value, metaData, record) {
                	return	 '<div style="text-align:right">'+Ext.util.Format.number(value, '0,000.00')+ '%' + '</div>';
                }

            },
            {id : 'PLAN_01S4'    ,dataIndex : 'PLAN_01',                 width : 110, summaryType: 'sum'},
            {id : 'RESULT_01S4'  ,dataIndex : 'RESULT_01',               width : 110, summaryType: 'sum'},
            {dataIndex : 'RATE_01',                 width : 110,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                	var totRateValue = 0;
                	if(summaryData.RESULT_01S4 == 0 && summaryData.PLAN_01S4 == 0 ){
                		totRateValue = 0;
					}else{
						totRateValue = summaryData.RESULT_01S4/summaryData.PLAN_01S4 * 100
					}

                	return Unilite.renderSummaryRow(summaryData, metaData, '',  '<div style="text-align:right">'+Ext.util.Format.number(totRateValue, '0,000.00')+ '%' +'</div>');
                },renderer: function(value, metaData, record) {
                	return	 '<div style="text-align:right">'+Ext.util.Format.number(value, '0,000.00')+ '%' + '</div>';
                }
            },
            {id : 'PLAN_02S4'    ,dataIndex : 'PLAN_02',                 width : 110, summaryType: 'sum'},
            {id : 'RESULT_02S4'  ,dataIndex : 'RESULT_02',               width : 110, summaryType: 'sum'},
            {dataIndex : 'RATE_02',                 width : 110,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                	var totRateValue = 0;
                	if(summaryData.RESULT_02S4 == 0 && summaryData.PLAN_02S4 == 0 ){
                		totRateValue = 0;
					}else{
						totRateValue = summaryData.RESULT_02S4 /summaryData.PLAN_02S4 * 100
					}

                	return Unilite.renderSummaryRow(summaryData, metaData, '',  '<div style="text-align:right">'+Ext.util.Format.number(totRateValue, '0,000.00')+ '%' +'</div>');
                },renderer: function(value, metaData, record) {
                	return	 '<div style="text-align:right">'+Ext.util.Format.number(value, '0,000.00')+ '%' + '</div>';
                }
            },
            {id : 'PLAN_03S4'    ,dataIndex : 'PLAN_03',                 width : 110, summaryType: 'sum'},
            {id : 'RESULT_03S4'  ,dataIndex : 'RESULT_03',               width : 110, summaryType: 'sum'},
            {dataIndex : 'RATE_03',                 width : 110,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                	var totRateValue = 0;
                	if(summaryData.RESULT_03S4 == 0 && summaryData.PLAN_03S4 == 0 ){
                		totRateValue = 0;
					}else{
						totRateValue = summaryData.RESULT_03S4 /summaryData.PLAN_03S4 * 100
					}

                	return Unilite.renderSummaryRow(summaryData, metaData, '',  '<div style="text-align:right">'+Ext.util.Format.number(totRateValue, '0,000.00')+ '%' +'</div>');
                },renderer: function(value, metaData, record) {
                	return	 '<div style="text-align:right">'+Ext.util.Format.number(value, '0,000.00')+ '%' + '</div>';
                }
            },
            {id : 'PLAN_04S4'    ,dataIndex : 'PLAN_04',                 width : 110, summaryType: 'sum'},
            {id : 'RESULT_04S4'  ,dataIndex : 'RESULT_04',               width : 110, summaryType: 'sum'},
            {dataIndex : 'RATE_04',                 width : 110,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                	var totRateValue = 0;
                	if(summaryData.RESULT_04S4 == 0 && summaryData.PLAN_04S4 == 0 ){
                		totRateValue = 0;
					}else{
						totRateValue = summaryData.RESULT_04S4 /summaryData.PLAN_04S4 * 100
					}

                	return Unilite.renderSummaryRow(summaryData, metaData, '',  '<div style="text-align:right">'+Ext.util.Format.number(totRateValue, '0,000.00')+ '%' +'</div>');
                },renderer: function(value, metaData, record) {
                	return	 '<div style="text-align:right">'+Ext.util.Format.number(value, '0,000.00')+ '%' + '</div>';
                }
            },
            {id : 'PLAN_05S4'    ,dataIndex : 'PLAN_05',                 width : 110, summaryType: 'sum'},
            {id : 'RESULT_05S4'  ,dataIndex : 'RESULT_05',               width : 110, summaryType: 'sum'},
            {dataIndex : 'RATE_05',                 width : 110,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                	var totRateValue = 0;
                	if(summaryData.RESULT_05S4 == 0 && summaryData.PLAN_05S4 == 0 ){
                		totRateValue = 0;
					}else{
						totRateValue = summaryData.RESULT_05S4/summaryData.PLAN_05S4 * 100
					}

                	return Unilite.renderSummaryRow(summaryData, metaData, '',  '<div style="text-align:right">'+Ext.util.Format.number(totRateValue, '0,000.00')+ '%' +'</div>');
                },renderer: function(value, metaData, record) {
                	return	 '<div style="text-align:right">'+Ext.util.Format.number(value, '0,000.00')+ '%' + '</div>';
                }
            },
            {id : 'PLAN_06S4'    ,dataIndex : 'PLAN_06',                 width : 110, summaryType: 'sum'},
            {id : 'RESULT_06S4'  ,dataIndex : 'RESULT_06',               width : 110, summaryType: 'sum'},
            {dataIndex : 'RATE_06',                 width : 110,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                	var totRateValue = 0;
                	if(summaryData.RESULT_06S4 == 0 && summaryData.PLAN_06S4 == 0 ){
                		totRateValue = 0;
					}else{
						totRateValue = summaryData.RESULT_06S4 /summaryData.PLAN_06S4 * 100
					}

                	return Unilite.renderSummaryRow(summaryData, metaData, '',  '<div style="text-align:right">'+Ext.util.Format.number(totRateValue, '0,000.00')+ '%' +'</div>');
                },renderer: function(value, metaData, record) {
                	return	 '<div style="text-align:right">'+Ext.util.Format.number(value, '0,000.00')+ '%' + '</div>';
                }

            },
            {id : 'PLAN_07S4'    ,dataIndex : 'PLAN_07',                 width : 110, summaryType: 'sum'},
            {id : 'RESULT_07S4'  ,dataIndex : 'RESULT_07',               width : 110, summaryType: 'sum'},
            {dataIndex : 'RATE_07',                 width : 110,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                	var totRateValue = 0;
                	if(summaryData.RESULT_07S4 == 0 && summaryData.PLAN_07S4 == 0 ){
                		totRateValue = 0;
					}else{
						totRateValue = summaryData.RESULT_07S4 /summaryData.PLAN_07S4 * 100
					}

                	return Unilite.renderSummaryRow(summaryData, metaData, '',  '<div style="text-align:right">'+Ext.util.Format.number(totRateValue, '0,000.00')+ '%' +'</div>');
                },renderer: function(value, metaData, record) {
                	return	 '<div style="text-align:right">'+Ext.util.Format.number(value, '0,000.00')+ '%' + '</div>';
                }
            },
            {id : 'PLAN_08S4'    ,dataIndex : 'PLAN_08',                 width : 110, summaryType: 'sum'},
            {id : 'RESULT_08S4'  ,dataIndex : 'RESULT_08',               width : 110, summaryType: 'sum'},
            {dataIndex : 'RATE_08',                 width : 110,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                	var totRateValue = 0;
                	if(summaryData.RESULT_08S4 == 0 && summaryData.PLAN_08S4 == 0 ){
                		totRateValue = 0;
					}else{
						totRateValue = summaryData.RESULT_08S4 /summaryData.PLAN_08S4 * 100
					}

                	return Unilite.renderSummaryRow(summaryData, metaData, '',  '<div style="text-align:right">'+Ext.util.Format.number(totRateValue, '0,000.00')+ '%' +'</div>');
                },renderer: function(value, metaData, record) {
                	return	 '<div style="text-align:right">'+Ext.util.Format.number(value, '0,000.00')+ '%' + '</div>';
                }
            },
            {id : 'PLAN_09S4'    ,dataIndex : 'PLAN_09',                 width : 110, summaryType: 'sum'},
            {id : 'RESULT_09S4'  ,dataIndex : 'RESULT_09',               width : 110, summaryType: 'sum'},
            {dataIndex : 'RATE_09',                 width : 110,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                	var totRateValue = 0;
                	if(summaryData.RESULT_09S4 == 0 && summaryData.PLAN_09S4 == 0 ){
                		totRateValue = 0;
					}else{
						totRateValue = summaryData.RESULT_09S4 /summaryData.PLAN_09S4 * 100
					}

                	return Unilite.renderSummaryRow(summaryData, metaData, '',  '<div style="text-align:right">'+Ext.util.Format.number(totRateValue, '0,000.00')+ '%'+'</div>');
                },renderer: function(value, metaData, record) {
                	return	 '<div style="text-align:right">'+Ext.util.Format.number(value, '0,000.00')+ '%' + '</div>';
                }
            },
            {id : 'PLAN_10S4'    ,dataIndex : 'PLAN_10',                 width : 110, summaryType: 'sum'},
            {id : 'RESULT_10S4'  ,dataIndex : 'RESULT_10',               width : 110, summaryType: 'sum'},
            {dataIndex : 'RATE_10',                 width : 110,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                	var totRateValue = 0;
                	if(summaryData.RESULT_10S4 == 0 && summaryData.PLAN_104 == 0 ){
                		totRateValue = 0;
					}else{
						totRateValue = summaryData.RESULT_10S4 /summaryData.PLAN_10S4 * 100
					}

                	return Unilite.renderSummaryRow(summaryData, metaData, '',  '<div style="text-align:right">'+Ext.util.Format.number(totRateValue, '0,000.00')+ '%'+'</div>');
                },renderer: function(value, metaData, record) {
                	return	 '<div style="text-align:right">'+Ext.util.Format.number(value, '0,000.00')+ '%' + '</div>';
                }
            },
            {id : 'PLAN_11S4'    ,dataIndex : 'PLAN_11',                 width : 110, summaryType: 'sum'},
            {id : 'RESULT_11S4'  ,dataIndex : 'RESULT_11',               width : 110, summaryType: 'sum'},
            {dataIndex : 'RATE_11',                 width : 110,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                	var totRateValue = 0;
                	if(summaryData.RESULT_11S4 == 0 && summaryData.PLAN_11S4 == 0 ){
                		totRateValue = 0;
					}else{
						totRateValue = summaryData.RESULT_11S4 /summaryData.PLAN_11S4 * 100
					}
                	return Unilite.renderSummaryRow(summaryData, metaData, '',  '<div style="text-align:right">'+Ext.util.Format.number(totRateValue, '0,000.00')+ '%'+'</div>');
                },renderer: function(value, metaData, record) {
                	return	 '<div style="text-align:right">'+Ext.util.Format.number(value, '0,000.00')+ '%' + '</div>';
                }

            },
            {id : 'PLAN_12S4'    ,dataIndex : 'PLAN_12',                 width : 110, summaryType: 'sum'},
            {id : 'RESULT_12S4'  ,dataIndex : 'RESULT_12',               width : 110, summaryType: 'sum'},
            {dataIndex : 'RATE_12',                 width : 110,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                	var totRateValue = 0;
                	if(summaryData.RESULT_12S4 == 0 && summaryData.PLAN_12S4 == 0 ){
                		totRateValue = 0;
					}else{
						totRateValue = summaryData.RESULT_12S4 /summaryData.PLAN_12S4  * 100
					}
                	return Unilite.renderSummaryRow(summaryData, metaData, '',  '<div style="text-align:right">'+Ext.util.Format.number(totRateValue, '0,000.00')+ '%'+'</div>');
                },renderer: function(value, metaData, record) {
                	return	 '<div style="text-align:right">'+Ext.util.Format.number(value, '0,000.00')+ '%' + '</div>';
                }

            }
        ]
    });

    var tab = Unilite.createTabPanel('tabPanel',{
        activeTab: 0,
        region: 'center',
        items: [
                 {
                     title: '거래처별'
                     ,xtype:'container'
                     ,layout:{type:'vbox', align:'stretch'}
                     ,items:[subForm1, masterGrid1]
                     ,id: 's_sgp100skrv_kdGrid1'
                 },
                 {
                     title: '품목별'
                     ,xtype:'container'
                     ,layout:{type:'vbox', align:'stretch'}
                     ,items:[subForm2, masterGrid2]
                     ,id: 's_sgp100skrv_kdGrid2'
                 },
                 {
                     title: '거래처품목별'
                     ,xtype:'container'
                     ,layout:{type:'vbox', align:'stretch'}
                     ,items:[subForm3, masterGrid3]
                     ,id: 's_sgp100skrv_kdGrid3'
                 },
                 {
                     title: '집계거래처'
                     ,xtype:'container'
                     ,layout:{type:'vbox', align:'stretch'}
                     ,items:[subForm4, masterGrid4]
                     ,id: 's_sgp100skrv_kdGrid4'
                 }
        ],
        listeners:  {
            tabChange:  function ( tabPanel, newCard, oldCard, eOpts )  {
                var newTabId = newCard.getId();
                console.log("newCard:  " + newCard.getId());
                console.log("oldCard:  " + oldCard.getId());
                //탭 넘길때마다 초기화
                UniAppManager.setToolbarButtons(['save', 'newData' ], false);
                panelResult.setAllFieldsReadOnly(false);
                activeGrid.reset();
//              Ext.getCmp('confirm_check').hide(); //확정버튼 hidden

            }
        }
    });


    Unilite.Main( {
        borderItems:[{
            region:'center',
            layout: 'border',
            border: false,
            items:[
                tab, panelResult
            ]
        }
        ],
        id  : 's_sgp100skrv_kdApp',
        fnInitBinding : function() {
            panelResult.setValue('DIV_CODE', UserInfo.divCode);
            UniAppManager.setToolbarButtons('reset', false);
            panelResult.clearForm();
            this.setDefault();
        },
        onQueryButtonDown : function()  {
            if(!panelResult.setAllFieldsReadOnly(true)){
                return false;
            }
            var activeTabId = tab.getActiveTab().getId();
            if(activeTabId == 's_sgp100skrv_kdGrid1') {
                directMasterStore1.loadStoreRecords();
            } else if(activeTabId == 's_sgp100skrv_kdGrid2') {
                directMasterStore2.loadStoreRecords();
            } else if(activeTabId == 's_sgp100skrv_kdGrid3') {
                directMasterStore3.loadStoreRecords();
            } else if(activeTabId == 's_sgp100skrv_kdGrid4') {
                directMasterStore4.loadStoreRecords();
            }
            UniAppManager.setToolbarButtons('reset', true);
        },
        onResetButtonDown: function() {
            panelResult.setAllFieldsReadOnly(false);
            masterGrid1.reset();
            masterGrid2.reset();
            masterGrid3.reset();
            masterGrid4.reset();
            this.fnInitBinding();
        },
        setDefault: function() {
            panelResult.setValue('DIV_CODE', UserInfo.divCode);
            panelResult.setValue('PLAN_YEAR', new Date().getFullYear());
            panelResult.setValue('MONEY_UNIT', UserInfo.currency);
            panelResult.setValue('ORDER_TYPE', '10');
        }
    })
};

</script>