<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_sof100skrv_kd"  >
    <t:ExtComboStore comboType="BOR120"  pgmId="s_sof100skrv_kd"  />             <!-- 사업장 -->
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
            read: 's_sof100skrv_kdService.selectList'
        }
    });
    
    Unilite.defineModel('s_sof100skrv_kdModel', {
        fields: [
            {name : 'COMP_CODE',        text: '법인코드',       type : 'string'},
            {name : 'DIV_CODE',         text: '사업장',        type : 'string', comboType : "BOR120"},
            {name : 'OFFER_NO',         text: '수출Offer번호',  type : 'string'},
            {name : 'CUSTOM_CODE',      text: '거래처코드',      type : 'string'},
            {name : 'CUSTOM_NAME',      text: '거래처명',       type : 'string'},
            {name : 'ORDER_DATE',       text: '수주일',         type : 'uniDate'},
            {name : 'PAY_METHODE1',     text: '결제방법',       type : 'string', comboType : 'AU', comboCode : 'T016'},
            {name : 'PAY_TERMS',        text: '결제조건',       type : 'string', comboType : 'AU', comboCode : 'T006'},  
            {name : 'TERMS_PRICE',      text: '가격조건',       type : 'string', comboType : 'AU', comboCode : 'T005'},
            {name : 'MONEY_UNIT',       text: '화폐',         type : 'string', comboType : 'AU', comboCode : 'B004'},
            {name : 'EXCHANGE_RATE',    text: '환율',         type : 'uniER'},
            {name : 'METH_CARRY',       text: '운송방법',       type : 'string', comboType : 'AU', comboCode : 'T004'},
            {name : 'SHIP_PORT',        text: '선적항',        type : 'string', comboType : 'AU', comboCode : 'T008'},
            {name : 'DEST_PORT',        text: '도착항',        type : 'string', comboType : 'AU', comboCode : 'T008'}, 
            {name : 'SER_NO',           text: '순번',         type : 'int'},
            {name : 'ITEM_CODE',        text: '품목코드',      type : 'string'},
            {name : 'ITEM_NAME',        text: '품목명',        type : 'string'},   
            {name : 'SPEC',             text: '규격',         type : 'string'},
            {name : 'ORDER_Q',          text: '구매량',        type : 'uniQty'},
            {name : 'ORDER_UNIT',       text: '구매단위',       type : 'string', comboType : 'AU', comboCode : 'B013'},
            {name : 'TRANS_RATE',       text: '입수',         type : 'uniUnitPrice'},
            {name : 'STOCK_Q',          text: '재고량',        type : 'uniQty'},
            {name : 'STOCK_UNIT',       text: '재고단위',       type : 'string', comboType : 'AU', comboCode : 'B013'},
            {name : 'PRICE',            text: '구매단가',       type : 'uniPrice'},
            {name : 'ORDER_P',          text: '수주단가',      type : 'uniUnitPrice'},
            {name : 'ORDER_O',          text: 'Offer액',      type : 'uniUnitPrice'},
            {name : 'ORDER_O_WON',      text: '환산액',        type : 'uniUnitPrice'},
            {name : 'HS_NO',            text: 'HS코드',       type : 'string'},
            {name : 'PO_NUM',           text: 'PO번호',       type : 'string'},
            {name : 'ORDER_NUM',        text: '수주번호',      type : 'string'}
        ]
    }); 
    
    var directMasterStore = Unilite.createStore('s_sof100skrv_kdMasterStore',{
        model: 's_sof100skrv_kdModel',
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
        }
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
                    validateBlank:false, 
                    popupWidth: 710
                }),
                Unilite.popup('DIV_PUMOK',{ 
                    fieldLabel: '품목코드',
                    name:'FRITEM',
                    valueFieldName: 'FR_ITEM_CODE', 
                    textFieldName: 'FR_ITEM_NAME'
                })
            ,{ 
                fieldLabel: '수주일',
                xtype: 'uniDateRangefield',
                startFieldName: 'FR_ORDER_DATE',
                endFieldName: 'TO_ORDER_DATE',
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today'),
                allowBlank:false
            },{
                fieldLabel:  '수출 Offer',
                name: 'OFFER_NO'
            },
                Unilite.popup('AGENT_CUST',{ 
                    fieldLabel: '~', 
                    valueFieldName: 'TO_CUSTOM_CODE', 
                    textFieldName: 'TO_CUSTOM_NAME', 
                    validateBlank: false, 
                    popupWidth: 710
                }),
                Unilite.popup('DIV_PUMOK',{ 
                    fieldLabel: '~',
                        valueFieldName: 'TO_ITEM_CODE', 
                        textFieldName: 'TO_ITEM_NAME'
                }),
            	{ 
                fieldLabel: '납기예정',
                xtype: 'uniDateRangefield',
                startFieldName: 'FR_DVRY_DATE',
                endFieldName: 'TO_DVRY_DATE',
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
    var masterGrid = Unilite.createGrid('s_sof100skrv_kdmasterGrid', { 
        layout : 'fit',   
        region: 'center',                          
        store: directMasterStore,
        uniOpt: {
            expandLastColumn: false,
            useMultipleSorting: true,
            useGroupSummary: false,
            useLiveSearch: true,
            useContextMenu: true
        },
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
                        alert('출력할 항목을 선택 후 진행하십시오.');
                        return false;
                    }
                    UniAppManager.app.requestApprove();
                }
            }
        ],
        columns:  [
            {dataIndex : 'COMP_CODE',       width : 180, hidden : true},
            {dataIndex : 'DIV_CODE',        width : 120},
            {dataIndex : 'OFFER_NO',        width : 110},
            {dataIndex : 'CUSTOM_CODE',     width : 100},
            {dataIndex : 'CUSTOM_NAME',     width : 160},
            {dataIndex : 'ORDER_DATE',      width : 100},
            {dataIndex : 'PAY_METHODE1',    width : 160},
            {dataIndex : 'PAY_TERMS',       width : 100},
            {dataIndex : 'TERMS_PRICE',     width : 120},
            {dataIndex : 'MONEY_UNIT',      width : 90},
            {dataIndex : 'EXCHANGE_RATE',   width : 100},
            {dataIndex : 'METH_CARRY',      width : 80},
            {dataIndex : 'SHIP_PORT',       width : 110},
            {dataIndex : 'DEST_PORT',       width : 110},
            {dataIndex : 'SER_NO',          width : 50},
            {dataIndex : 'ITEM_CODE',       width : 110},
            {dataIndex : 'ITEM_NAME',       width : 160},
            {dataIndex : 'SPEC',            width : 140},
            {dataIndex : 'ORDER_Q',         width : 100},
            {dataIndex : 'ORDER_UNIT',      width : 70},
            {dataIndex : 'TRANS_RATE',      width : 70},
            {dataIndex : 'STOCK_Q',         width : 100},
            {dataIndex : 'STOCK_UNIT',      width : 70},
            {dataIndex : 'ORDER_P',         width : 100},
            {dataIndex : 'ORDER_O',         width : 130},
            {dataIndex : 'ORDER_O_WON',     width : 130},
            {dataIndex : 'HS_NO',           width : 130},
            {dataIndex : 'PO_NUM',          width : 120},
            {dataIndex : 'ORDER_NUM',       width : 130}
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
        id  : 's_sof100skrv_kdApp',
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
        requestApprove: function(){     //결재 요청
            var gsWin = window.open('about:blank','payviewer','width=500,height=500'); 
            
            var frm         = document.f1;
            var record      = masterGrid.getSelectedRecord();
            var compCode    = UserInfo.compCode;
            var divCode     = record.data['DIV_CODE'];
            var soSerNo    = record.data['OFFER_NO'];
//            var userId      = UserInfo.userID;
            var spText      = 'EXEC omegaplus_kdg.unilite.USP_GW_S_SOF100SKRV_KD ' + "'" + compCode + "'" + ', ' + "'" + divCode + "'" + ', ' + "'" + soSerNo + "'";
            var spCall      = encodeURIComponent(spText); 
            
//            frm.action = '/payment/payreq.php';
//            frm.action   = groupUrl + "&prg_no=s_str900skrv1_kd&draft_no=" + UserInfo.compCode + inoutNum + "&sp=" + spCall + Base64.encode();
            frm.action   = groupUrl + "&prg_no=s_sof100skrv_kd&draft_no=" + '0' + "&sp=" + spCall;
            frm.target   = "payviewer"; 
            frm.method   = "post";
            frm.submit();
        },
        setDefault: function() {
            panelResult.setValue('DIV_CODE', UserInfo.divCode);
            panelResult.setValue('FR_ORDER_DATE', UniDate.get('startOfMonth'));
            panelResult.setValue('TO_ORDER_DATE', UniDate.get('today'));
        }
    });
};

</script>

<form id="f1" name="f1" action="" method="post" onSubmit="return false;" >
<input type="hidden" id="loginid" name="loginid" value="superadmin" />
<input type="hidden" id="fmpf" name="fmpf" value="" />
<input type="hidden" id="fmbd" name="fmbd" runat="server" />
</form>