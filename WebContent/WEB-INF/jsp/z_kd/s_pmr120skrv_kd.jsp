<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_pmr120skrv_kd">
    <t:ExtComboStore comboType="BOR120"  pgmId="s_pmr120skrv_kd"  />             <!-- 사업장 -->
    <t:ExtComboStore comboType="WU" /><!-- 작업장  -->
</t:appConfig>

<script type="text/javascript">

var BsaCodeInfo = {     //컨트롤러에서 값을 받아옴.
    gsBalanceOut:        '${gsBalanceOut}'
};

function appMain() {

	var groupUrl = '${groupUrl}'; //그룹웨어 호출 url

    var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 's_pmr120skrv_kdService.selectList'
        }
    });

    Unilite.defineModel('s_pmr120skrv_kdModel', {
        fields: [
            {name: 'COMP_CODE',             text: '법인코드',       type : 'string'},
            {name: 'DIV_CODE',              text: '사업장',        type : 'string', comboType : "BOR120"},
            {name: 'SECTION_CD',            text: '부서코드',       type : 'string'},
            {name: 'SECTION_NAME',          text: '라인',         type : 'string'},
            {name: 'WORK_SHOP_CODE',        text: '작업장코드',      type : 'string'},
            {name: 'WORK_SHOP_NAME',        text: '작업장명',        type : 'string'},
            {name: 'NOW_PLAN_Q',            text: '당월판매계획량',    type : 'uniQty'},
            {name: 'BASIS_Q',               text: '전월재고량',      type : 'uniQty'},
            {name: 'INSTOCK_Q',             text: '당월입고량',      type : 'uniQty'},
            {name: 'INSTOCK_I',             text: '당월입고액',      type : 'uniUnitPrice'},
            {name: 'OUTSTOCK_Q',            text: '당월출고량',      type : 'uniQty'},
            {name: 'OUTSTOCK_I',            text: '당월출고액',      type : 'uniUnitPrice'},
            {name: 'STOCK_Q',               text: '현재고량',       type : 'uniQty'},
            {name: 'STOCK_I',               text: '현재고액',       type : 'uniUnitPrice'},
            {name: 'DEF_INOUT_Q',           text: '재고증감량',      type : 'uniQty'},
            {name: 'DEF_INOUT_RATE',        text: '재고증감율',      type : 'uniPercent'},
            {name: 'MAN_HOUR',              text: '작업시간',        type : 'int'},
            {name: 'MAN_CNT',               text: '작업인원',        type : 'int'}
        ]
    });

    var directMasterStore = Unilite.createStore('s_pmr120skrv_kdMasterStore',{
        model: 's_pmr120skrv_kdModel',
        uniOpt : {
            isMaster: true,          // 상위 버튼 연결
            editable: false,         // 수정 모드 사용
            deletable:false,         // 삭제 가능 여부
            useNavi : false          // prev | newxt 버튼 사용
        },
        expanded : false,
        autoLoad: false,
        proxy: directProxy,
        loadStoreRecords : function()   {
            var param= panelResult.getValues();
            this.load({
                  params : param
            });
        },
        listeners: {
            load:function( store, records, successful, operation, eOpts ) {
                var count = masterGrid.getStore().getCount();

                if (count == 0) {
                    Ext.getCmp('printBtn').setDisabled(true);
                } else {
                    Ext.getCmp('printBtn').setDisabled(false);
                }
            }
        },groupField: 'SECTION_NAME'
    });

    //panelResult(검색조건)
    var panelResult = Unilite.createSearchForm('resultForm', {
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
                value: UserInfo.divCode
            },{
                fieldLabel: '기준월',
                name:'BASE_MONTH',
                xtype: 'uniMonthfield',
                value: UniDate.get('today'),
                allowBlank:false
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

    /**
     * Master Grid1 정의(Grid Panel)
     * @type
     */
    var masterGrid = Unilite.createGrid('s_pmr120skrv_kdmasterGrid', {
        layout : 'fit',
        region: 'center',
        store: directMasterStore,
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

        tbar: [{
                xtype : 'button',
                id: 'printBtn',
       					hidden:true,
                text:'출력',
                handler: function() {
                    if(panelResult.setAllFieldsReadOnly(true) == false){
                        return false;
                    }
                    UniAppManager.app.requestApprove();
                }
            }
        ],
        features: [
                   {id: 'masterGridSubTotal',     ftype: 'uniGroupingsummary',    showSummaryRow: true},
                   {id: 'masterGridTotal',        ftype: 'uniSummary',            showSummaryRow: true}
               ],

        columns:  [
            {dataIndex : 'COMP_CODE',           width : 130, hidden : true},
            {dataIndex : 'DIV_CODE',            width : 130, hidden : true},
            {dataIndex : 'SECTION_CD',          width : 120, hidden : true},
            {dataIndex : 'SECTION_NAME',        width : 120},
            {dataIndex : 'WORK_SHOP_CODE',      width : 110},
            {dataIndex : 'WORK_SHOP_NAME',      width : 150,
            	summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
				return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.sales.subtotal" default="소계"/>', '<t:message code="system.label.sales.total" default="총계"/>');
			}},
            {dataIndex : 'NOW_PLAN_Q',          width : 120, summaryType: 'sum'},
            {id :'ID_BASIS_Q',dataIndex : 'BASIS_Q',             width : 110, summaryType: 'sum'},
            {dataIndex : 'INSTOCK_Q',           width : 110, summaryType: 'sum'},
            {dataIndex : 'INSTOCK_I',           width : 120, summaryType: 'sum'},
            {dataIndex : 'OUTSTOCK_Q',          width : 110, summaryType: 'sum'},
            {dataIndex : 'OUTSTOCK_I',          width : 120, summaryType: 'sum'},
            {id :'ID_STOCK_Q', dataIndex : 'STOCK_Q',             width : 100, summaryType: 'sum'},
            {dataIndex : 'STOCK_I',             width : 120, summaryType: 'sum'},
            {dataIndex : 'DEF_INOUT_Q',         width : 110, summaryType: 'sum'},
            {dataIndex : 'DEF_INOUT_RATE',      width : 100,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                	var totRateValue = 0;
					if(summaryData.ID_BASIS_Q != 0){
						totRateValue = (summaryData.ID_STOCK_Q - summaryData.ID_BASIS_Q) /summaryData.ID_BASIS_Q * 100
					}else{
						totRateValue= 0;
					}
                	return Unilite.renderSummaryRow(summaryData, metaData, '<div style="text-align:right">'+Ext.util.Format.number(totRateValue, '0,000.00')+'</div>',  '<div style="text-align:right">'+Ext.util.Format.number(totRateValue, '0,000.00')+'</div>');
                }},
            {dataIndex : 'MAN_HOUR',            width : 100, summaryType: 'sum'},
            {dataIndex : 'MAN_CNT',             width : 100, summaryType: 'sum'}

        ],
        listeners: {

        }
    });

    Unilite.Main( {
        borderItems:[{
//            region:'center',
//            layout: 'border',
//            border: false,
        	layout: {type: 'vbox', align: 'stretch'},
            region: 'center',
            items:[
                panelResult, masterGrid
            ]
        }],
        id  : 's_pmr120skrv_kdApp',
        fnInitBinding : function() {
            panelResult.clearForm();
            directMasterStore.clearData();
            this.setDefault();
        },
        onQueryButtonDown : function()  {
        	if(panelResult.setAllFieldsReadOnly(true) == false){
                return false;
            }

            directMasterStore.loadStoreRecords();
            UniAppManager.setToolbarButtons('reset', true);

        },
        onResetButtonDown: function() {
            panelResult.setAllFieldsReadOnly(false);
            masterGrid.reset();
            this.fnInitBinding();
        },
        requestApprove: function(){     //결재 요청
            var gsWin = window.open('about:blank','payviewer','width=500,height=500');

            var frm         = document.f1;
            var compCode    = UserInfo.compCode;
            var divCode     = panelResult.getValue('DIV_CODE');
            var baseMonth   = UniDate.getDbDateStr(panelResult.getValue('BASE_MONTH'));
            var spText      = 'EXEC omegaplus_kdg.unilite.USP_GW_S_PMR120SKRV_KD ' + "'" + compCode + "'" + ', ' + "'" + divCode + "'" + ', ' + "'" + baseMonth + "'";
            var spCall      = encodeURIComponent(spText);

//            frm.action = '/payment/payreq.php';
            frm.action   = groupUrl + "viewMode=docuDraft" + "&prg_no=s_pmr120skrv_kd&draft_no=" + '0' + "&sp=" + spCall;
//            frm.action   = groupUrl + "&prg_no=s_pmr120skrv2_kd&draft_no=" + UserInfo.compCode + inoutNum + "&sp=" + spCall + Base64.encode();
            frm.target   = "payviewer";
            frm.method   = "post";
            frm.submit();
        },
        setDefault: function() {
            panelResult.setValue('DIV_CODE', UserInfo.divCode);
            panelResult.setValue('BASE_MONTH', UniDate.get('today'));

            Ext.getCmp('printBtn').setDisabled(true);
            UniAppManager.setToolbarButtons('save', false);
        }
    });
};

</script>

<form id="f1" name="f1" action="" method="post" onSubmit="return false;" >
<input type="hidden" id="loginid" name="loginid" value="superadmin" />
<input type="hidden" id="fmpf" name="fmpf" value="" />
<input type="hidden" id="fmbd" name="fmbd" runat="server" />
</form>