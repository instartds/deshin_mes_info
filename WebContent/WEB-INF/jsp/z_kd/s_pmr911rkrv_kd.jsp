<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_pmr911rkrv_kd"  >
    <t:ExtComboStore comboType="BOR120"  pgmId="s_pmr911rkrv_kd"  />             <!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="S002" /> <!--매출구분-->
    <t:ExtComboStore comboType="AU" comboCode="B219" /> <!--등록여부-->
    <t:ExtComboStore comboType="WU" /><!-- 작업장  -->
</t:appConfig>
<script type="text/javascript" >

function appMain() {

	var groupUrl = '${groupUrl}'; //그룹웨어 호출 url

    var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 's_pmr911rkrv_kdService.selectList'
        }
    });

    /**
     *   Model 정의
     * @type
     */
    Unilite.defineModel('s_pmr911rkrv_kdModel', {
        fields: [
            {name : 'COMP_CODE',            text : '법인코드',          type : 'string'},
            {name : 'DIV_CODE',             text : '사업장',           type : 'string', comboType:'BOR120'},
            {name : 'GW_TITLE',             text : 'GW_TITLE',       type : 'string'},
            {name : 'TITLE',                text : 'TITLE',          type : 'string'},
            {name : 'TITLE2',               text : 'TITLE2',         type : 'string'},
            {name : 'SECTION_CD',           text : '작업부서',         type : 'string'},
            {name : 'LOCATION',             text : 'OEM/AS',         type : 'string'},
            {name : 'PAB_FR_DAY',           text : 'PAB_FR_DAY',     type : 'int'},
            {name : 'PAB_TO_DAY',           text : 'PAB_TO_DAY',     type : 'int'},
            {name : 'NOW_YYMMDD',           text : 'NOW_YYMMDD',     type : 'string'},
            {name : 'ITEM_CODE',            text : '품목코드',         type : 'string'},
            {name : 'CAR_TYPE',             text : '차종',            type : 'string'},
            {name : 'OEM_ITEM_CODE',        text : '품번',            type : 'string'},
            {name : 'ITEM_NAME',            text : '품명',            type : 'string'},
            {name : 'STOCK_UNIT',           text : '단위',            type : 'string', comboType:'AU', comboCode:'B013'},
            {name : 'STOCK_Q',              text : '현재고량',         type : 'uniQty'},
            {name : 'WIP_Q',                text : '공정재고량',        type : 'uniQty'},
            {name : 'SUM_STOCK_WIP_Q',      text : '합계',            type : 'uniQty'},
            {name : 'NOW_YYMM_PLAN_Q',      text : '판매계획량',        type : 'uniQty'},
            {name : 'PRODT_PLAN_Q',         text : '생산계획량',        type : 'uniQty'},
            {name : 'EXCESS_Q',             text : '과부족량',          type : 'uniQty'},
            {name : 'PAB_DAY',              text : '장부가용일',          type : 'uniQty'},
            {name : 'PAB_DAY2',             text : '공정포함가용일',         type : 'uniQty'},
            {name : 'CUSTOM_CODE',          text : '거래처',           type : 'string'},
            {name : 'CUSTOM_NAME',          text : '거래처명',          type : 'string'},
            {name : 'WORK_SHOP_CODE',       text : '작업장',           type : 'string'},
            {name : 'WORK_SHOP_NAME',       text : '작업장명',          type : 'string'}
        ]
    });

    /**
     * Store 정의(Service 정의)
     * @type
     */
    var directMasterStore = Unilite.createStore('s_pmr911rkrv_kdMasterStore1',{
        model: 's_pmr911rkrv_kdModel',
        uniOpt : {
            isMaster:  true,            // 상위 버튼 연결
            editable:  false,            // 수정 모드 사용
            deletable: false,            // 삭제 가능 여부
            useNavi :  false            // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
        loadStoreRecords : function()   {
            var param = panelResult.getValues();
            this.load({
                  params : param
            });
        }
    }); // End of var directMasterStore1

    var panelResult = Unilite.createSearchForm('resultForm',{
        region: 'north',
        layout : {type : 'uniTable', columns : 2},
        padding:'1 1 1 1',
        border:true,
        items: [{
                fieldLabel: '사업장',
                name:'DIV_CODE',
                xtype: 'uniCombobox',
                comboType:'BOR120',
                allowBlank:false,
                value: UserInfo.divCode
            },
            {
                xtype: 'container',
                layout : {type : 'uniTable', columns : 4},
                items:[ {
                    fieldLabel: '가용일수',
                    name: 'PAB_FR_DAY',
                    xtype: 'uniNumberfield',
                    allowBlank:false,
                    hidden: true,
                    value:1,
                    width:150
                },
                {
                    xtype:'label',
                    padding:'0 20 0 0',
                    hidden: true,
                    text:'일부터'
                },{
        			fieldLabel: '기준일자'  ,
        			name: 'BASIS_DATE',
        			xtype:'uniDatefield',
        			value:UniDate.get('today'),
//        			labelWidth: 140,
        			allowBlank:false,
        			listeners: {
        				change: function(combo, newValue, oldValue, eOpts) {

        				}
        			}
        		},
                {
                	fieldLabel: '가용일수',
                    name: 'PAB_TO_DAY',
                    xtype: 'uniNumberfield',
                    allowBlank:false,
                    value:1,
                    width:150
                },{
                    xtype:'label',
//                    padding:'0 0 0 10',
                    text:'일'
                }
            ]}
            ,{
                fieldLabel: '작업부서',
                name: 'SECTION_CD',
                xtype: 'uniCombobox',
                comboType: 'AU',
                comboCode: 'B113'
            },{
                fieldLabel: '주작업장',
                name: 'WORK_SHOP_CODE',
                xtype: 'uniCombobox',
                comboType: 'WU'
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

    var masterGrid = Unilite.createGrid('s_pmr911rkrv_kdmasterGrid', {
        layout : 'fit',
        region: 'center',
        store: directMasterStore,
        uniOpt: {
            expandLastColumn: false,
            useMultipleSorting: true,
            useGroupSummary: false,
            useLiveSearch: true,
            useContextMenu: true,
            useRowNumberer: false,
            filter: {
                useFilter: true,
                autoCreate: true
            }
        },
        tbar: [{
                xtype : 'button',
                id: 'printBtn',
                text:'기안',
                handler: function() {
                    if(panelResult.setAllFieldsReadOnly(true) == false){
                        return false;
                    }
                    UniAppManager.app.requestApprove();
                }
            }
        ],
        columns:  [
            {dataIndex : 'COMP_CODE',                width: 120, hidden: true},
            {dataIndex : 'DIV_CODE',                 width: 120, hidden: true},
            {dataIndex : 'GW_TITLE',                 width: 100, hidden: true},
            {dataIndex : 'TITLE',                    width: 100, hidden: true},
            {dataIndex : 'TITLE2',                   width: 100, hidden: true},
            {dataIndex : 'SECTION_CD',               width: 110},
            {dataIndex : 'LOCATION',                 width: 100},
            {dataIndex : 'PAB_FR_DAY',               width: 100, hidden: true},
            {dataIndex : 'PAB_TO_DAY',               width: 100, hidden: true},
            {dataIndex : 'NOW_YYMMDD',               width: 100, hidden: true},
            {dataIndex : 'ITEM_CODE',                width: 120},
            {dataIndex : 'CAR_TYPE',                 width: 110},
            {dataIndex : 'OEM_ITEM_CODE',            width: 120},
            {dataIndex : 'ITEM_NAME',                width: 140},
            {dataIndex : 'STOCK_UNIT',               width: 70},
            {dataIndex : 'STOCK_Q',                  width: 110},
            {dataIndex : 'WIP_Q',                    width: 110},
            {dataIndex : 'SUM_STOCK_WIP_Q',          width: 110},
            {dataIndex : 'NOW_YYMM_PLAN_Q',          width: 110},
            {dataIndex : 'PRODT_PLAN_Q',             width: 110, hidden: true},
            {dataIndex : 'EXCESS_Q',                 width: 110},
            {dataIndex : 'PAB_DAY',                  width: 110},
            {dataIndex : 'PAB_DAY2',                 width: 110},
            {dataIndex : 'CUSTOM_CODE',              width: 100, hidden: true},
            {dataIndex : 'CUSTOM_NAME',              width: 140, hidden: true},
            {dataIndex : 'WORK_SHOP_CODE',           width: 80},
            {dataIndex : 'WORK_SHOP_NAME',           width: 120}
        ]
    });

    Unilite.Main( {
        borderItems:[{
            region:'center',
            layout: 'border',
            border: false,
            items:[
                masterGrid, panelResult
            ]
        }
        ],
        id  : 's_pmr911rkrv_kdApp',
        fnInitBinding : function() {
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            UniAppManager.setToolbarButtons(['save', 'newData', 'deleteAll'], false);
            UniAppManager.setToolbarButtons('newData', false);
            panelResult.clearForm();
            directMasterStore.clearData();
            this.setDefault();
        },
        onQueryButtonDown : function()  {
        	if(panelResult.setAllFieldsReadOnly(true) == false){
                return false;
            } else {
                directMasterStore.loadStoreRecords();
                UniAppManager.setToolbarButtons(['reset'], true);
            }
        },
        onResetButtonDown: function() {
            panelResult.setAllFieldsReadOnly(false);
            masterGrid.reset();
            this.fnInitBinding();
        },
        requestApprove: function(){     //결재 요청
            var gsWin = window.open('about:blank','payviewer','width=500,height=500');

            var frm             = document.f1;
            var compCode        = UserInfo.compCode;
            var divCode         = panelResult.getValue('DIV_CODE');

            if(Ext.isEmpty(panelResult.getValue('SECTION_CD'))) {
                var sectionCD   = '';
            } else {
                var sectionCD   = panelResult.getValue('SECTION_CD');
            }

            if(Ext.isEmpty(panelResult.getValue('WORK_SHOP_CODE'))) {
                var workShopCode    = '';
            } else {
                var workShopCode    = panelResult.getValue('WORK_SHOP_CODE');
            }

            var pabFrDay        = panelResult.getValue('PAB_FR_DAY');
            var pabToDay        = panelResult.getValue('PAB_TO_DAY');
            var spText          = 'EXEC omegaplus_kdg.unilite.USP_GW_S_PMR911RKRV_KD ' + "'" + compCode + "'" + ', ' + "'" + divCode + "'" + ', ' + "'" + sectionCD + "'" + ', ' + "'" + workShopCode + "'" + ', ' + "'" + pabFrDay + "'" + ', ' + "'" + pabToDay + "'";
            var spCall          = encodeURIComponent(spText);

//            frm.action = '/payment/payreq.php';
            frm.action   = groupUrl + "viewMode=docuDraft" + "&prg_no=s_pmr911rkrv_kd&draft_no=" + '0' + "&sp=" + spCall;
//            frm.action   = groupUrl + "&prg_no=s_pmr911rkrv_kd&draft_no=" + UserInfo.compCode + inoutNum + "&sp=" + spCall + Base64.encode();
            frm.target   = "payviewer";
            frm.method   = "post";
            frm.submit();
        },
        setDefault: function() {
            panelResult.setValue('DIV_CODE', UserInfo.divCode);
            panelResult.setValue('PAB_FR_DAY', 1);
            panelResult.setValue('PAB_TO_DAY', 1);
            panelResult.setValue('BASIS_DATE',new Date());
        }
    });
}
</script>

<form id="f1" name="f1" action="" method="post" onSubmit="return false;" >
<input type="hidden" id="loginid" name="loginid" value="superadmin" />
<input type="hidden" id="fmpf" name="fmpf" value="" />
<input type="hidden" id="fmbd" name="fmbd" runat="server" />
</form>