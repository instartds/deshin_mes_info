<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_tex900skrv_kd"  >
    <t:ExtComboStore comboType="BOR120"  />             <!-- 사업장 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

    var SearchInfoWindow; // 검색창
    var ReferenceWindow; // 참조


function appMain() {
    var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 's_tex900skrv_kdService.selectList'
        }
    });

    /**
     * Model 정의
     *
     * @type
     */
    Unilite.defineModel('s_tex900skrv_kdModel', {   // 관세환급등록
        fields: [
            {name : 'DIV_CODE',         text : '사업장',           type : 'string', xtype : 'uniCombobox', comboType : 'BOR120', allowBlank : false},
            {name : 'RETURN_NO',        text : '환급번호',          type : 'string'},
            {name : 'SEQ',              text : '순번',            type : 'int'},
            {name : 'CUSTOM_CODE',      text : '거래처',           type : 'string'},
            {name : 'CUSTOM_NAME',      text : '거래처명',          type : 'string'},
            {name : 'ED_DATE',          text : '신고일자',          type : 'uniDate'},
            {name : 'ED_NO',            text : '수출신고번호',       type : 'string'},
            {name : 'MONEY_UNIT',       text : '화폐단위',          type : 'string'},
            {name : 'RT_TARGET_AMT',    text : '수출환급대상액',      type : 'uniPrice'},
            {name : 'BL_SER_NO',        text : '선적번호',          type : 'string'},
            {name : 'RETURN_DATE',      text : '결정일자',          type : 'uniDate'},
            {name : 'EXCHG_RATE_O',     text : '환율',             type : 'uniER'},
            {name : 'RETURN_AMT',       text : '환급액',           type : 'uniPrice'},
            {name : 'RETURN_RATE',      text : '환급율(%)',        type: 'float', decimalPrecision: 2, format:'0,000.00'},
            {name : 'HS_NO',            text : 'HS_NO',          type : 'string'},
            
            {name : 'REMARK',           text : '비고',            type : 'string'}
        ]
    });

    /**
     * Store 정의(Service 정의)
     *
     * @type
     */
    var directMasterStore = Unilite.createStore('s_tex900skrv_kdMasterStore1',{ // 관세환급등록
        model: 's_tex900skrv_kdModel',
        uniOpt: {
            isMaster: true,         // 상위 버튼 연결
            editable: false,            // 수정 모드 사용
            deletable: false,           // 삭제 가능 여부
            useNavi : false         // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
        listeners: {
        },
        loadStoreRecords: function() {
            var param= panelResult.getValues();
            console.log(param);
            this.load({
                params : param
            });
        },
        groupField: 'RETURN_NO',
        fnReturnAmtSum: function() {
            var returnAmt  = 0;
            var results = this.sumBy(function(record, id){return true;},['RETURN_AMT']);
            returnAmt = results.RETURN_AMT;
            inputTable.setValue('RETURN_AMT',returnAmt);           //원화합계
        },
		listeners: {
            load: function(store, records, successful, eOpts) {
                this.fnReturnAmtSum();
            },
            add: function(store, records, index, eOpts) {
                this.fnReturnAmtSum();
            },
            update: function(store, record, operation, modifiedFieldNames, eOpts) {
                this.fnReturnAmtSum();
            },
            remove: function(store, record, index, isMove, eOpts) {
                this.fnReturnAmtSum();
            }
        }
    });

    var panelResult = Unilite.createSearchForm('resultForm',{  // 메인상단에 있는 조회조건검색
        hidden: !UserInfo.appOption.collapseLeftSearch,
        region: 'north',
        layout : {type : 'uniTable', columns : 3},
        padding:'1 1 1 1',
        border:true,
        items: [
            {
            fieldLabel: '사업장',                          // 사업장 콤보박스
            name:'DIV_CODE',
            xtype: 'uniCombobox',
            comboType:'BOR120',
            allowBlank: false
            },{
            	 fieldLabel: '신고일',
		        xtype: 'uniDateRangefield',
		        startFieldName: 'ED_DATE_FR',
		        endFieldName: 'ED_DATE_TO',
		        startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
		        allowBlank: false
	        },{
                fieldLabel: '환급번호',
                name:'RETURN_NO',
                xtype: 'uniTextfield'
            },{
                fieldLabel: 'HS Code',
                name:'HS_NO',
                xtype: 'uniTextfield'
            },{
                fieldLabel: '비고',
                name:'REMARK',
                width:490,
                colspan:2,
                xtype: 'uniTextfield'
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

    var inputTable = Unilite.createSearchForm('detailForm', { //createForm
        layout : {type : 'uniTable', columns : 2},
        disabled: false,
        border:true,
        padding:'1 1 1 1',
        region: 'center',
        masterGrid: masterGrid,
        items: [
           {
                fieldLabel: '환급액',
                name:'RETURN_AMT',
                xtype: 'uniNumberfield',
                //decimalPrecision: 2,
                type: 'uniPrice',
                readOnly: true
            },{
                fieldLabel: '비고',
                name:'REMARK',
                width:490,
                xtype: 'uniTextfield',
                readOnly: true
            }
        ]
    });

    /**
     * Master Grid1 정의(Grid Panel)
     *
     * @type
     */

    var masterGrid = Unilite.createGrid('s_tex900skrv_kdGrid', {        // 관세환급등록 그리드
        layout : 'fit',
        region:'center',
        store : directMasterStore,
        uniOpt: {
            expandLastColumn: true
        },
        selModel: 'rowmodel',
        store: directMasterStore,
        features: [
            {id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true},
            {id: 'masterGridTotal',    ftype: 'uniSummary',         showSummaryRow: true}
        ],
        columns: [
            {dataIndex: 'DIV_CODE'              , width: 120,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                   return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
                }
            },
            {dataIndex : 'RETURN_NO',           width : 120},
            {dataIndex : 'SEQ',                 width : 50},
            {dataIndex : 'CUSTOM_CODE',         width : 100},
            {dataIndex : 'CUSTOM_NAME',         width : 200},
            {dataIndex : 'ED_DATE',             width : 100},
            {dataIndex : 'ED_NO',               width : 120},
            {dataIndex : 'RT_TARGET_AMT',       width : 130, summaryType: 'sum'},
            {dataIndex : 'RETURN_AMT',          width : 100 , summaryType: 'sum'},
            {dataIndex : 'RETURN_RATE',         width : 100, align:"center"},
            {dataIndex : 'BL_SER_NO',           width : 110},
            {dataIndex : 'RETURN_DATE',         width : 95},
            {dataIndex : 'REMARK',              width : 100, hidden : true}
        ],

        listeners: {
            cellclick: function( model1, selected, eOpts ) {
                if(selected.length > 0) {
                    var record = selected[0];
                    //inputTable.setValue('RETURN_AMT', record.get('RETURN_AMT'));
                    inputTable.setValue('REMARK', record.get('REMARK'));
                }
            },
            selectionchange:function( model1, selected, eOpts ){
                if(selected.length > 0) {
                    var record = selected[0];
                    //inputTable.setValue('RETURN_AMT', record.get('RETURN_AMT'));
                    inputTable.setValue('REMARK', record.get('REMARK'));
                }
            }
        }
    }); // End of var masterGrid1 = Unilite.createGrid('s_tex900skrv_kdGrid1', {

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
        }
        ],
        id: 's_tex900skrv_kdApp',
        fnInitBinding: function() {
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            panelResult.setValue('ED_DATE_TO',UniDate.get('today'));
            panelResult.setValue('ED_DATE_FR',UniDate.get('startOfMonth'));
            inputTable.setValue('RETURN_AMT',0);
            UniAppManager.setToolbarButtons('reset',false);
        },
        onQueryButtonDown: function() {
            if(panelResult.setAllFieldsReadOnly(true) == false){
                return false;
            }
            directMasterStore.loadStoreRecords();
            UniAppManager.setToolbarButtons('reset', true);
        },
        checkForNewDetail:function() {
            return panelResult.setAllFieldsReadOnly(true);
        },
        onResetButtonDown: function() {
            panelResult.clearForm();
            masterGrid.reset();
            inputTable.reset();
            directMasterStore.clearData();
            this.fnInitBinding();
            UniAppManager.setToolbarButtons(['reset','save'], false);
        }
    });
};

</script>