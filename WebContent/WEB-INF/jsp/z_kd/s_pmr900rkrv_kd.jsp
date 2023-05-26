<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_pmr900rkrv_kd">
    <t:ExtComboStore comboType="BOR120"  pgmId="s_pmr900rkrv_kd"  />             <!-- 사업장 -->  
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
            read: 's_pmr900rkrv_kdService.selectList'
        }
    });
    
    Unilite.defineModel('s_pmr900rkrv_kdModel', {
        fields: [
            {name: 'COMP_CODE',             text: '법인코드',       type : 'string'},
            {name: 'DIV_CODE',              text: '사업장',        type : 'string', comboType : "BOR120"},
            {name: 'PRODT_DATE',            text: '생산일자',       type : 'uniDate'},
//            {name: 'WORK_SHOP_CODE',        text: '작업장'       , type: 'string' , comboType:"WU"},
            {name: 'WORK_SHOP_CODE',        text: '작업장코드',      type : 'string'},
            {name: 'WORK_SHOP_NAME',        text: '라인명',        type : 'string'},
            {name: 'PRODT_NUM',             text: '전표번호',       type : 'string'},
            {name: 'ITEM_CODE',             text: '제품코드',       type : 'string'},
            {name: 'CAR_TYPE',              text: '차종코드',       type : 'string'},
            {name: 'CAR_TYPE_NAME',         text: '차종명',        type : 'string'},
            {name: 'ITEM_NAME',             text: '품명',         type : 'string'},
            {name: 'SPEC',                  text: '규격',         type : 'string'},
            {name: 'LOT_NO',                text: 'LOT NO',     type : 'string'},
            {name: 'STOCK_UNIT',            text: '단위',         type : 'string'},
            {name: 'PRODT_Q',               text: '생산수량',      type : 'uniQty'},
            {name: 'GOOD_PRODT_Q',          text: '양품량',        type : 'uniQty'},
            {name: 'IN_STOCK_Q',            text: '입고량',        type : 'uniQty'}
        ]
    }); 
    
    var directMasterStore = Unilite.createStore('s_pmr900rkrv_kdMasterStore',{
        model: 's_pmr900rkrv_kdModel',
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
        }
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
                fieldLabel: '생산일자',
                name:'PRODT_DATE',
                xtype: 'uniDatefield',
                value: UniDate.get('today'),
                allowBlank:false
            },{
                fieldLabel: '작업장',
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
    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('s_pmr900rkrv_kdmasterGrid', { 
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
                text:'생산일보 출력',
                handler: function() {
                    if(panelResult.setAllFieldsReadOnly(true) == false){
                        return false;
                    }
                    UniAppManager.app.requestApprove();
                }
            }
        ],
        columns:  [
            {dataIndex : 'COMP_CODE',           width : 130, hidden : true},
            {dataIndex : 'DIV_CODE',            width : 120},
            {dataIndex : 'PRODT_DATE',          width : 100},
            {dataIndex : 'WORK_SHOP_CODE',      width : 100},
            {dataIndex : 'WORK_SHOP_NAME',      width : 150},
            {dataIndex : 'PRODT_NUM',           width : 120},
            {dataIndex : 'ITEM_CODE',           width : 120},
            {dataIndex : 'CAR_TYPE',            width : 100},
            {dataIndex : 'CAR_TYPE_NAME',       width : 120},
            {dataIndex : 'ITEM_NAME',           width : 160},
            {dataIndex : 'SPEC',                width : 130},
            {dataIndex : 'LOT_NO',              width : 120},
            {dataIndex : 'STOCK_UNIT',          width : 90},
            {dataIndex : 'PRODT_Q',             width : 120},
            {dataIndex : 'GOOD_PRODT_Q',        width : 120},
            {dataIndex : 'IN_STOCK_Q',          width : 120}
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
        id  : 's_pmr900rkrv_kdApp',
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
            
            var frm             = document.f1;
            var compCode        = UserInfo.compCode;
            var divCode         = panelResult.getValue('DIV_CODE');
            
            if(Ext.isEmpty(panelResult.getValue('WORK_SHOP_CODE'))) {
                var workShopCode    = '';
            } else {
                var workShopCode    = panelResult.getValue('WORK_SHOP_CODE'); 
            }
            
            var prodtDate       = UniDate.getDbDateStr(panelResult.getValue('PRODT_DATE'));
            var spText          = 'EXEC omegaplus_kdg.unilite.USP_GW_S_PMR900RKRV_KD ' + "'" + compCode + "'" + ', ' + "'" + divCode + "'" + ', ' + "'" + workShopCode + "'" + ', ' + "'" + prodtDate + "'";
            var spCall          = encodeURIComponent(spText); 
            
//            frm.action = '/payment/payreq.php';
            frm.action   = groupUrl + "viewMode=docuDraft" + "&prg_no=s_pmr900rkrv_kd&draft_no=" + '0' + "&sp=" + spCall;
//            frm.action   = groupUrl + "&prg_no=s_pmr900rkrv2_kd&draft_no=" + UserInfo.compCode + inoutNum + "&sp=" + spCall + Base64.encode();
            frm.target   = "payviewer"; 
            frm.method   = "post";
            frm.submit();
        },
        setDefault: function() {
            panelResult.setValue('DIV_CODE', UserInfo.divCode);
            panelResult.setValue('PRODT_DATE', UniDate.get('today'));
            
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