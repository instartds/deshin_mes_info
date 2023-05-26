<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_tio190skrv_kd"  >
    <t:ExtComboStore comboType="BOR120"  pgmId="s_tio190skrv_kd"  />             <!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="B004" /> <!--화폐-->
    <t:ExtComboStore comboType="AU" comboCode="B013" /> <!--단위-->
    <t:ExtComboStore comboType="AU" comboCode="T004" /> <!--운송방법-->
    <t:ExtComboStore comboType="AU" comboCode="T005" /> <!--가격조건-->
    <t:ExtComboStore comboType="AU" comboCode="T006" /> <!--결제조건-->
    <t:ExtComboStore comboType="AU" comboCode="T008" /> <!--선적항/도착항-->
    <t:ExtComboStore comboType="AU" comboCode="T016" /> <!--결제방법-->
</t:appConfig>

<script type="text/javascript">


function appMain() {
	
	var groupUrl = '${groupUrl}'; //그룹웨어 호출 url
    
    var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 's_tio190skrv_kdService.selectList'
        }
    });
    
    Unilite.defineModel('s_tio190skrv_kdModel', {
        fields: [
            {name : 'COMP_CODE',                text: '법인코드',            type : 'string'},
            {name : 'DIV_CODE',                     text: '사업장',                type : 'string', comboType : "BOR120"},
            {name : 'SO_SER_NO',                  text: '수입Offer번호',   type : 'string'},
            {name : 'EXPORTER',                     text: '거래처코드',       type : 'string'},
            {name : 'EXPORTER_NAME',        text: '거래처명',           type : 'string'},
            {name : 'DATE_DEPART',              text: '작성일',               type : 'uniDate'},
            {name : 'PAY_METHODE',            text: '결제방법',           type : 'string', comboType : 'AU', comboCode : 'T016'},
            {name : 'PAY_TERMS',                   text: '결제조건',           type : 'string', comboType : 'AU', comboCode : 'T006'},  
            {name : 'TERMS_PRICE',               text: '가격조건',            type : 'string', comboType : 'AU', comboCode : 'T005'},
            {name : 'AMT_UNIT',                     text: '화폐',                   type : 'string', comboType : 'AU', comboCode : 'B004'},
            {name : 'EXCHANGE_RATE',        text: '환율',                    type : 'uniER'},
            {name : 'METHD_CARRY',            text: '운송방법',            type : 'string', comboType : 'AU', comboCode : 'T004'},
            {name : 'SHIP_PORT',                    text: '선적항',               type : 'string', comboType : 'AU', comboCode : 'T008'},
            {name : 'DEST_PORT',                    text: '도착항',              type : 'string', comboType : 'AU', comboCode : 'T008'}, 
            {name : 'SO_SER',                           text: '순번',                  type : 'int'},
            {name : 'ITEM_CODE',                    text: '품목코드',          type : 'string'},
            {name : 'ITEM_NAME',                   text: '품목명',             type : 'string'},   
            {name : 'SPEC',                                 text: '규격',                type : 'string'},
            {name : 'QTY',                                  text: '구매량',            type : 'uniQty'},
            {name : 'UNIT',                                 text: '구매단위',       type : 'string', comboType : 'AU', comboCode : 'B013'},
            {name : 'TRNS_RATE',                    text: '입수',                type : 'uniUnitPrice'},
            {name : 'STOCK_UNIT_Q',             text: '재고량',             type : 'uniQty'},
            {name : 'STOCK_UNIT',                  text: '재고단위',       type : 'string', comboType : 'AU', comboCode : 'B013'},
            {name : 'PRICE',                                text: '구매단가',       type : 'uniUnitPrice'},
            {name : 'SO_AMT',                           text: 'Offer액',        type : 'uniUnitPrice'},
            {name : 'SO_AMT_WON',               text: '환산액',           type : 'uniUnitPrice'},
            {name : 'REMAIN_QTY',                   text: '미진행수량',        type : 'uniQty'},
            {name : 'HS_NO',                             text: 'HS코드',             type : 'string'},
            {name : 'LOT_NO',                           text: 'LOT_NO',         type : 'string'}
        ]
    }); 
    
    var directMasterStore = Unilite.createStore('s_tio190skrv_kdMasterStore',{
        model: 's_tio190skrv_kdModel',
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

            }
        },
        groupField:'SO_SER_NO'
    });     
    
    //panelResult(검색조건)
    var panelResult = Unilite.createSearchForm('resultForm', {
        region: 'north',
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
                value: UserInfo.divCode
            }, Unilite.popup('AGENT_CUST', {
                    fieldLabel: '거래처', 
                    valueFieldName: 'FR_CUSTOM_CODE', 
                    textFieldName: 'FR_CUSTOM_NAME', 
                    popupWidth: 710,
                    autoPopup:true,
                    validateBlank :false
                }),
                Unilite.popup('DIV_PUMOK',{ 
                    fieldLabel: '품목코드',
                    name:'FRITEM',
                    valueFieldName: 'FR_ITEM_CODE', 
                    textFieldName: 'FR_ITEM_NAME',
                    autoPopup:true,
                    validateBlank :false
                })
            ,{ 
                fieldLabel: '작성일',
                xtype: 'uniDateRangefield',
                startFieldName: 'FR_DATE_DEPART',
                endFieldName: 'TO_DATE_DEPART',
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today'),
                allowBlank:false
            },{
                fieldLabel:  '수입 Offer',
                name: 'SO_SER_NO'
            },
            {
                xtype: 'radiogroup',
                fieldLabel: '진행상태',
                items: [{
                    boxLabel: '전체',
                    width: 90,
                    name: 'RDO_SELECT',
                    inputValue: '1',
                }, {
                    boxLabel: '진행중',
                    width: 90,
                    inputValue: '2',
                    name: 'RDO_SELECT',
                    checked: true
                }, {
                    boxLabel: '완료',
                    width: 90,
                    inputValue: '3',
                    name: 'RDO_SELECT'
                }],
                listeners : {
                    blur : function(field, newValue,oldValue, eOpts) {
                        UniAppManager.app.onQueryButtonDown();
                    }
                }
            },
            	{ 
                fieldLabel: '납기예정',
                xtype: 'uniDateRangefield',
                startFieldName: 'FR_DELIVERY_DATE',
                endFieldName: 'TO_DELIVERY_DATE',
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today')
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
        } ,
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
    var masterGrid = Unilite.createGrid('s_tio190skrv_kdmasterGrid', { 
        layout : 'fit',   
        region: 'center',                          
        store: directMasterStore,
        selModel:'rowmodel',
        uniOpt: {
            expandLastColumn: false,
            useMultipleSorting: true,
            useGroupSummary: false,
            useLiveSearch: true,
            useContextMenu: true
        },
        /*
사용자요청에 의해 제거 : 180424 

        tbar: [{
                itemId : 'GWBtn',
                id:'GW',
                iconCls : 'icon-referance',
                text:'기안',
                handler: function() {
                    var masterRecord = masterGrid.getSelectedRecord();
                    var count = masterGrid.getStore().getCount();
                    var param = panelResult.getValues();
                    
                    if(count == 0) {
                        alert('기안할 항목을 선택 후 진행하십시오.');
                        return false;
                    }
                    
                    param.DRAFT_NO = UserInfo.compCode + masterRecord.data.SO_SER_NO;
                    if(confirm('기안 하시겠습니까?')) {
                        s_tio190skrv_kdService.selectGwData(param, function(provider, response) {
                            if(Ext.isEmpty(provider[0]) || provider[0].GW_FLAG != '1' || provider[0].GW_FLAG != '3') {
                                s_tio190skrv_kdService.makeDraftNum(param, function(provider2, response) {
                                    UniAppManager.app.requestApprove1();
                                }); 
                            } else {
                                alert('이미 기안된 자료입니다.');
                                return false;
                            }
                        });
                    }
                }
            }, {
                xtype : 'button',
                text:'출력',
                handler: function() {
                    var masterRecord = masterGrid.getSelectedRecord();
                    var count = masterGrid.getStore().getCount();
                    var param = panelResult.getValues();

                    if(count == 0) {
                        alert('출력할 항목을 선택 후 진행하십시오.');
                        return false;
                    }

                    UniAppManager.app.requestApprove2();
                    
                }
             }
        ],
        */
        features: [{
            id: 'masterGridSubTotal', 
            ftype: 'uniGroupingsummary', 
            showSummaryRow: true
        },{
            id: 'masterGridTotal', 
            ftype: 'uniSummary', 
            showSummaryRow: true
        }],
        columns:  [
            {dataIndex : 'COMP_CODE',       width : 180, hidden : true},
            {dataIndex : 'DIV_CODE',        width : 120, hidden : true},
            {dataIndex : 'SO_SER_NO',       width : 110,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                   return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
                }
            },
            {dataIndex : 'EXPORTER',        width : 100},
            {dataIndex : 'EXPORTER_NAME',   width : 160},
            {dataIndex : 'DATE_DEPART',     width : 100},
            {dataIndex : 'PAY_METHODE',     width : 160},
            {dataIndex : 'PAY_TERMS',       width : 100},
            {dataIndex : 'TERMS_PRICE',     width : 120},
            {dataIndex : 'AMT_UNIT',        width : 90},
            {dataIndex : 'EXCHANGE_RATE',   width : 100},
            {dataIndex : 'METHD_CARRY',     width : 80},
            {dataIndex : 'SHIP_PORT',       width : 110},
            {dataIndex : 'DEST_PORT',       width : 110},
            {dataIndex : 'SO_SER',          width : 50},
            {dataIndex : 'ITEM_CODE',       width : 110},
            {dataIndex : 'ITEM_NAME',       width : 160},
            {dataIndex : 'SPEC',            width : 140},
            {dataIndex : 'QTY',             width : 100, summaryType: 'sum'},
            {dataIndex : 'UNIT',            width : 70},
            {dataIndex : 'TRNS_RATE',       width : 70},
            {dataIndex : 'STOCK_UNIT_Q',    width : 100, summaryType: 'sum'},
            {dataIndex : 'STOCK_UNIT',      width : 70},
            {dataIndex : 'PRICE',           width : 100, summaryType: 'sum'},
            {dataIndex : 'SO_AMT',          width : 130, summaryType: 'sum'},
            {dataIndex : 'SO_AMT_WON',      width : 130, summaryType: 'sum'},
            {dataIndex : 'REMAIN_QTY',      width : 100, summaryType: 'sum'},            
            {dataIndex : 'HS_NO',           width : 110},
            {dataIndex : 'LOT_NO',          width : 130}
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
        id  : 's_tio190skrv_kdApp',
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
            var viewLocked = masterGrid.getView();
            var viewNormal = masterGrid.getView();
            UniAppManager.setToolbarButtons('reset', true);
        },
        onResetButtonDown: function() {
            panelResult.setAllFieldsReadOnly(false);
            masterGrid.reset();
            this.fnInitBinding();
        },
        requestApprove1: function() {     //결재 요청
            var gsWin = window.open('about:blank','payviewer','width=500,height=500'); 
            
            var frm         = document.f1;
            var record      = masterGrid.getSelectedRecord();
            var divCode     = record.data['DIV_CODE'];
            var soSerNo     = record.data['SO_SER_NO'];
//            var userId      = UserInfo.userID;
            var spText      = 'EXEC omegaplus_kdg.unilite.USP_GW_S_TIO190SKRV_KD ' + "'" + compCode + "'" + ', ' + "'" + divCode + "'" + ', ' + "'" + soSerNo + "'";
            var spCall      = encodeURIComponent(spText); 
            
//            frm.action = '/payment/payreq.php';
//            frm.action   = groupUrl + "&prg_no=s_str900skrv1_kd&draft_no=" + UserInfo.compCode + inoutNum + "&sp=" + spCall + Base64.encode();
            frm.action   = groupUrl + "viewMode=docuDraft" + "&prg_no=s_tio190skrv_kd&draft_no=" + UserInfo.compCode + soSerNo + "&sp=" + spCall;
            frm.target   = "payviewer"; 
            frm.method   = "post";
            frm.submit();
        },
        requestApprove2: function() {     //결재 요청
            var gsWin = window.open('about:blank','payviewer','width=500,height=500'); 
            
            var frm         = document.f1;
            var record      = masterGrid.getSelectedRecord();
            var compCode    = UserInfo.compCode;
            var divCode     = record.data['DIV_CODE'];
            var soSerNo     = record.data['SO_SER_NO'];
//            var userId      = UserInfo.userID;
            var spText      = 'EXEC omegaplus_kdg.unilite.USP_GW_S_TIO190SKRV_KD ' + "'" + compCode + "'" + ', ' + "'" + divCode + "'" + ', ' + "'" + soSerNo + "'";
            var spCall      = encodeURIComponent(spText); 
            
//            frm.action = '/payment/payreq.php';
//            frm.action   = groupUrl + "&prg_no=s_tio190skrv_kd&draft_no=" + UserInfo.compCode + soSerNo + "&sp=" + spCall + Base64.encode();
            frm.action   = groupUrl + "viewMode=docuDraft" + "&prg_no=s_tio190skrv_kd&draft_no=" + '0' + "&sp=" + spCall;
            frm.target   = "payviewer"; 
            frm.method   = "post";
            frm.submit();
        },
        setDefault: function() {
            panelResult.setValue('DIV_CODE', UserInfo.divCode);
            panelResult.setValue('FR_DATE_DEPART', UniDate.get('startOfMonth'));
            panelResult.setValue('TO_DATE_DEPART', UniDate.get('today'));
        }
    });
};

</script>

<form id="f1" name="f1" action="" method="post" onSubmit="return false;" >
<input type="hidden" id="loginid" name="loginid" value="superadmin" />
<input type="hidden" id="fmpf" name="fmpf" value="" />
<input type="hidden" id="fmbd" name="fmbd" runat="server" />
</form>