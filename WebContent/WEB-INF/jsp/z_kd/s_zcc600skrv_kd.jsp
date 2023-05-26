<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_zcc600skrv_kd"  >
    <t:ExtComboStore comboType="BOR120"  pgmId="s_zcc600skrv_kd"  />             <!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="B004" /> <!--화폐단위-->
    <t:ExtComboStore comboType="AU" comboCode="B010" /> <!--사용여부-->
</t:appConfig>
<script type="text/javascript" >

function appMain() {
    var groupUrl = '${groupUrl}'; //그룹웨어 호출 url
	
    var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy', {
        api: {
            read    : 's_zcc600skrv_kdService.selectList'
        }
    });
    
    /**
     *   Model 정의 
     * @type 
     */
    Unilite.defineModel('s_zcc600skrv_kdModel', {
        fields: [
            {name : 'COMP_CODE',            text : '법인코드',       type : 'string'},
            {name : 'DIV_CODE',             text : '사업장',         type : 'string', comboType : "BOR120"},
            {name : 'ENTRY_NUM',            text : '관리코드',        type : 'string'},
            {name : 'ENTRY_DATE',           text : '등록일자',        type : 'uniDate'},
            {name : 'OEM_ITEM_CODE',        text : '품번',          type : 'string'},
            {name : 'ITEM_NAME',            text : '품명',          type : 'string'},
            {name : 'MAKE_QTY',             text : '벌수',          type : 'uniQty'},
            {name : 'MONEY_UNIT',           text : '화폐',            type : 'string', comboType : 'AU', comboCode : 'B004'},
            {name : 'EXCHG_RATE_O',         text : '환율',            type : 'uniER'},
            {name : 'PRODUCT_AMT',          text : '제작금액',         type : 'uniPrice'},
            {name : 'MARGIN_AMT',           text : '마진금액',         type : 'uniPrice'},
            {name : 'TEMP_P',               text : '임시금액',         type : 'uniPrice'},
            {name : 'NEGO_P',               text : '네고금액',         type : 'uniPrice'},
            {name : 'DELIVERY_AMT',         text : '납품금액',         type : 'uniPrice'},
            {name : 'DELIVERY_DATE',        text : '납품일자',         type : 'uniDate'},
            {name : 'COLLECT_AMT',          text : '수금금액',         type : 'uniPrice'},
            {name : 'COLLECT_DATE',         text : '수금일자',         type : 'uniDate'},
            {name : 'UN_COLLECT_AMT',       text : '미수금액',         type : 'uniPrice'},
            {name : 'CLOSE_YN',             text : '완료',            type : 'string', comboType : 'AU', comboCode : 'B010'},
            {name : 'REMARK',               text : '비고',            type : 'string'}
        ]
    });
    
    /**
     * Store 정의(Service 정의)
     * @type 
     */                 
    var directMasterStore = Unilite.createStore('s_zcc600skrv_kdMasterStore1',{
        model: 's_zcc600skrv_kdModel',
        uniOpt : {
            isMaster    : true,            // 상위 버튼 연결 
            editable    : false,           // 수정 모드 사용 
            deletable   : false,           // 삭제 가능 여부 
            useNavi     : false            // prev | newxt 버튼 사용
        },
        autoLoad : false,
        proxy: directProxy,
        loadStoreRecords : function()   {   
            var param= panelResult.getValues();
            this.load({
                  params : param
            });         
        }
    }); // End of var directMasterStore1 
    
    /**
     * 검색조건 (Search Panel)
     * @type 
     */ 
     var panelResult = Unilite.createSearchForm('resultForm',{
        region: 'north',
        layout : {type : 'uniTable', columns : 3},
        padding :'1 1 1 1',
        border :true,
        hidden : !UserInfo.appOption.collapseLeftSearch,
//        uniOnChange: function(basicForm, dirty, eOpts) {                
//            if(directMasterStore.getCount() != 0 && panelResult.isDirty()) {
//                  UniAppManager.setToolbarButtons('save', true);
//            }
//        },
        items : [{
                fieldLabel: '사업장',
                name:'DIV_CODE',
                xtype: 'uniCombobox',
                comboType:'BOR120',
                allowBlank:false,
                value: UserInfo.divCode
            },{ 
                fieldLabel: '등록일자',
                xtype: 'uniDateRangefield',
                startFieldName: 'FR_DATE',
                endFieldName: 'TO_DATE',
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today'),
                allowBlank:false
            },
            Unilite.popup('ENTRY_NUM1_KD', {
                    fieldLabel: '관리코드', 
                    valueFieldName: 'ENTRY_NUM',
                    textFieldName: 'ENTRY_NUM', 
                    validateBlank: false,
                    listeners: {
                        applyextparam: function(popup){                         
                            popup.setExtParam({'DIV_CODE': UserInfo.divCode});
                        }
                    }
            }),{
                fieldLabel: '품번',
                name:'OEM_ITEM_CODE',  
                xtype: 'uniTextfield'
            },
            Unilite.popup('DEPT', {
                    fieldLabel: '부서', 
                    valueFieldName: 'DEPT_CODE',
                    textFieldName: 'DEPT_NAME'
            }),{
                fieldLabel: '완료여부',
                name:'CLOSE_YN',
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'B010',
                allowBlank : false,
                value:'N'
            }
        ],
        api : {
            submit: 's_zcc600skrv_kdService.syncForm'                
        },
        setAllFieldsReadOnly : function(b) { 
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
    
    var masterGrid = Unilite.createGrid('s_zcc600skrv_kdmasterGrid', { 
        layout : 'fit',   
        region : 'center',                          
        store  : directMasterStore,
        uniOpt : {
            expandLastColumn    : false,
            useMultipleSorting  : true,
            useGroupSummary     : false,
            useLiveSearch       : true,
            useContextMenu      : true,
            useRowNumberer      : false,
            filter : {
                useFilter: true,
                autoCreate: true
            }
        },
        tbar : [{
                    xtype : 'button',
                    text:'출력',
                    handler: function() {
                        if(panelResult.setAllFieldsReadOnly(true) == false){
                            return false;
                        }
                        UniAppManager.app.requestApprove();
                    }
                }
        
        ],
        columns : [ 
            {dataIndex : 'COMP_CODE',            width : 100, hidden : true},
            {dataIndex : 'DIV_CODE',             width : 100, hidden : true},
            {dataIndex : 'ENTRY_NUM',            width : 120},
            {dataIndex : 'ENTRY_DATE',           width : 90, align : 'center'},
            {dataIndex : 'OEM_ITEM_CODE',        width : 100},
            {dataIndex : 'ITEM_NAME',            width : 170},
            {dataIndex : 'MAKE_QTY',             width : 80},
            {dataIndex : 'MONEY_UNIT',           width : 90},
            {dataIndex : 'EXCHG_RATE_O',         width : 90},
            {dataIndex : 'PRODUCT_AMT',          width : 120},
            {dataIndex : 'MARGIN_AMT',           width : 120},
            {dataIndex : 'TEMP_P',               width : 120},
            {dataIndex : 'NEGO_P',               width : 120},
            {dataIndex : 'DELIVERY_AMT',         width : 120},
            {dataIndex : 'DELIVERY_DATE',        width : 90, align : 'center'},
            {dataIndex : 'COLLECT_AMT',          width : 120},
            {dataIndex : 'COLLECT_DATE',         width : 90, align : 'center'},
            {dataIndex : 'UN_COLLECT_AMT',       width : 120},
            {dataIndex : 'CLOSE_YN',             width : 100},
            {dataIndex : 'REMARK',               width : 120}
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
        id  : 's_zcc600skrv_kdApp',
        fnInitBinding : function() {
            panelResult.setValue('DIV_CODE', UserInfo.divCode);
            this.setDefault();
        },
        onQueryButtonDown : function()  {
            if(panelResult.setAllFieldsReadOnly(true) == false){
                    return false;
            }
            directMasterStore.loadStoreRecords();
        },
        onResetButtonDown : function() {
            panelResult.setAllFieldsReadOnly(false);
            panelResult.clearForm(); 
            masterGrid.reset();
            this.setDefault();
        },
        onDeleteDataButtonDown : function() {
            var selRow1 = masterGrid.getSelectedRecord();
                if(selRow1.phantom === true) {
                    masterGrid.deleteSelectedRow();
                } else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
                    masterGrid.deleteSelectedRow();
                }
        },
        onSaveDataButtonDown : function () {
        	directMasterStore.saveStore();
        },
        requestApprove : function() {     //결재 요청
            var gsWin = window.open('about:blank','payviewer','width=500,height=500'); 
            
            var frm             = document.f1;
            var record          = masterGrid.getSelectedRecord();
            var compCode        = UserInfo.compCode;
            var divCode         = panelResult.getValue('DIV_CODE');
            var frDate          = UniDate.getDbDateStr(panelResult.getValue('FR_DATE'));
            var toDate          = UniDate.getDbDateStr(panelResult.getValue('TO_DATE'));
            
            if(Ext.isEmpty(panelResult.getValue('ENTRY_NUM'))) {
                var entryNum        = '';
            } else {
                var entryNum        = panelResult.getValue('ENTRY_NUM'); 
            }
            if(Ext.isEmpty(panelResult.getValue('OEM_ITEM_CODE'))) {
                var oemItemCode     = '';
            } else {
                var oemItemCode     = panelResult.getValue('OEM_ITEM_CODE'); 
            }
            if(Ext.isEmpty(panelResult.getValue('DEPT_CODE'))) {
                var deptCode        = '';
            } else {
                var deptCode        = panelResult.getValue('DEPT_CODE'); 
            }
            if(Ext.isEmpty(panelResult.getValue('CLOSE_YN'))) {
                var closeYN         = '';
            } else {
                var closeYN         = panelResult.getValue('CLOSE_YN'); 
            }
            
            var spText          = 'EXEC omegaplus_kdg.unilite.USP_GW_S_ZCC600SKRV_KD ' + "'" + compCode + "'" + ', ' + "'" + divCode + "'" + ', ' + "'" + frDate + "'" + ', ' + "'" + toDate + "'"  + ', ' + "'" + entryNum + "'"  + ', ' + "'" + oemItemCode + "'"  + ', ' + "'" + deptCode + "'"  + ', ' + "'" + closeYN + "'";
            var spCall          = encodeURIComponent(spText); 
            
/* //            frm.action = '/payment/payreq.php';
            frm.action   = groupUrl + "viewMode=docuDraft" + "&prg_no=s_zcc600skrv_kd&draft_no=" + '0' + "&sp=" + spCall;
//            frm.action   = groupUrl + "&prg_no=s_str900skrv2_kd&draft_no=" + UserInfo.compCode + inoutNum + "&sp=" + spCall + Base64.encode();
            frm.target   = "payviewer"; 
            frm.method   = "post";
            frm.submit(); */
            
            var gwurl = groupUrl + "viewMode=docuDraft" + "&prg_no=s_zcc600skrv_kd&draft_no=" + '0' + "&sp=" + spCall;
            UniBase.fnGw_Call(gwurl,frm,'GW'); 
            
        },
        setDefault: function() {
            directMasterStore.clearData();
            panelResult.setValue('DIV_CODE', UserInfo.divCode);
            panelResult.setValue('FR_DATE', UniDate.get('startOfMonth'));
            panelResult.setValue('TO_DATE', UniDate.get('today'));
            panelResult.setValue('CLOSE_YN', 'N');
            UniAppManager.setToolbarButtons(['save'], false);
        },
        checkForNewDetail:function() { 
            return panelResult.setAllFieldsReadOnly(true);
        }                         
    });
    
}

</script>
<form id="f1" name="f1" action="" method="post" onSubmit="return false;" >
<input type="hidden" id="loginid" name="loginid" value="superadmin" />
<input type="hidden" id="fmpf" name="fmpf" value="" />
<input type="hidden" id="fmbd" name="fmbd" runat="server" />
</form>