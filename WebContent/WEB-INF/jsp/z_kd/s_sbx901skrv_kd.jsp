<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_sbx901skrv_kd"  >
    <t:ExtComboStore comboType="BOR120"  pgmId="s_sbx901skrv_kd"  />             <!-- 사업장 -->  
    <t:ExtComboStore comboType="AU" comboCode="S002" /> <!--매출구분-->
    <t:ExtComboStore comboType="AU" comboCode="B004" /> <!--화폐-->
    <t:ExtComboStore comboType="AU" comboCode="M201" /> <!--담당자-->
    <t:ExtComboStore comboType="AU" comboCode="B042" /> <!--계획금액단위-->
    <t:ExtComboStore comboType="AU" comboCode="S010" /> <!--영업담당-->
    <t:ExtComboStore comboType="AU" comboCode="B055" /> <!--고객분류-->
    <t:ExtComboStore comboType="AU" comboCode="B020" /> <!--품목계정-->
    <t:ExtComboStore comboType="AU" comboCode="B109" /> <!--유통-->
    <t:ExtComboStore comboType="AU" comboCode="B013" /> <!--판매단위-->
    <t:ExtComboStore comboType="AU" comboCode="WB06" /> <!--B/OUT관리여부-->
</t:appConfig>
<script type="text/javascript" >

//var BsaCodeInfo = {     //컨트롤러에서 값을 받아옴.
//    gsBalanceOut:        '${gsBalanceOut}'
//};
//var output ='';   // 입고내역 셋팅 값 확인 alert
//for(var key in BsaCodeInfo){
//    output += key + '  :  ' + BsaCodeInfo[key] + '\n';
//}
//alert(output);


function appMain() {
    var groupUrl = '${groupUrl}'; //그룹웨어 호출 url
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 's_sbx901skrv_kdService.selectList'
        }
    });
    
    /**
     *   Model 정의 
     * @type 
     */
    Unilite.defineModel('s_sbx901skrv_kdModel', {
        fields: [
            {name: 'COMP_CODE'              ,text:'법인코드'           ,type: 'string'},
            {name: 'DIV_CODE'               ,text:'사업장'             ,type: 'string'},
            {name: 'CUSTOM_CODE'            ,text:'거래처코드'         ,type: 'string'},
            {name: 'CUSTOM_NAME'            ,text:'거래처명'           ,type: 'string'},
            {name: 'ITEM_CODE'              ,text:'BOX(품목)코드'      ,type: 'string'},
            {name: 'ITEM_NAME'              ,text:'BOX(품목)명'        ,type: 'string'},
            {name: 'SPEC'                   ,text:'BOX(규격)'          ,type: 'string'},
            {name: 'PRE_STOCK_Q'            ,text:'전월미회수'         ,type: 'uniQty'},
            {name: 'INSTOCK_Q'              ,text:'회수량'             ,type: 'uniQty'},
            {name: 'OUTSTOCK_Q'             ,text:'출고량'             ,type: 'uniQty'},
            {name: 'STOCK_Q'                ,text:'재고량'             ,type: 'uniQty'}
        ]
    }); 
    
    /**
     * Store 정의(Service 정의)
     * @type 
     */                 
    var directMasterStore = Unilite.createStore('s_sbx901skrv_kdMasterStore1',{
        model: 's_sbx901skrv_kdModel',
        uniOpt : {
            isMaster: true,            // 상위 버튼 연결 
            editable: false,            // 수정 모드 사용 
            deletable:false,           // 삭제 가능 여부 
            useNavi : false            // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
        loadStoreRecords : function()   {   
            var param= panelSearch.getValues();
            this.load({
                  params : param
            });         
        }
    }); // End of var directMasterStore1 
    
    /**
     * 검색조건 (Search Panel)
     * @type 
     */ 
    var panelSearch = Unilite.createSearchPanel('searchForm', {     
        title: '검색조건',      
        defaultType: 'uniSearchSubPanel',
        collapsed: UserInfo.appOption.collapseLeftSearch,//true,
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
            items: [{
                    fieldLabel: '사업장',
                    name:'DIV_CODE',
                    xtype: 'uniCombobox',
                    comboType:'BOR120',
                    allowBlank:false,
                    value: UserInfo.divCode,
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                            panelResult.setValue('DIV_CODE', newValue);
                        }
                    }
                },{ 
                    fieldLabel: '기준일',
                    xtype: 'uniDatefield',
                    name: 'BASIS_DATE',
                    value: UniDate.get('today'),
                    allowBlank:false,
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                            panelResult.setValue('BASIS_DATE', newValue);
                        }
                    }
                },
                Unilite.popup('AGENT_CUST',{ 
                        fieldLabel: '거래처',
                        valueFieldName:'CUSTOM_CODE',
                        textFieldName:'CUSTOM_NAME',
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
                Unilite.popup('DIV_PUMOK',{ 
                        fieldLabel: 'BOX코드',
                        valueFieldName:'ITEM_CODE',
                        textFieldName:'ITEM_NAME',
                        listeners: {
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
                            },
                            applyextparam: function(popup){                         
                                popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
                                popup.setExtParam({'ITEM_ACCOUNT': '60'});
    //                            Ext.getCmp('ITEM_ACCOUNT_ID').setDisabled(true);
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
    
    var panelResult = Unilite.createSearchForm('resultForm',{
        region: 'north',
        layout : {type : 'uniTable', columns : 2},
        padding:'1 1 1 1',
        border:true,
        hidden: !UserInfo.appOption.collapseLeftSearch,
        id: 'RESULT_SEARCH',
        items: [{
                fieldLabel: '사업장',
                name:'DIV_CODE',
                xtype: 'uniCombobox',
                comboType:'BOR120',
                allowBlank:false,
                value: UserInfo.divCode,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.setValue('DIV_CODE', newValue);
                    }
                }
            },{ 
                fieldLabel: '기준일',
                xtype: 'uniDatefield',
                name: 'BASIS_DATE',
                value: UniDate.get('today'),
                allowBlank:false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.setValue('BASIS_DATE', newValue);
                    }
                }
            },
            Unilite.popup('AGENT_CUST',{ 
                    fieldLabel: '거래처',
                    valueFieldName:'CUSTOM_CODE',
                    textFieldName:'CUSTOM_NAME',
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
            Unilite.popup('DIV_PUMOK',{ 
                    fieldLabel: 'BOX코드',
                    valueFieldName:'ITEM_CODE',
                    textFieldName:'ITEM_NAME',
                    listeners: {
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
                        },
                        applyextparam: function(popup){                         
                            popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
                            popup.setExtParam({'ITEM_ACCOUNT': '60'});
//                            Ext.getCmp('ITEM_ACCOUNT_ID').setDisabled(true);
                        }
                    }
            })
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
    
    var masterGrid = Unilite.createGrid('s_sbx901skrv_kdmasterGrid', { 
        layout : 'fit',   
        region: 'center',                          
        store: directMasterStore,
        uniOpt: {
            expandLastColumn: false,
            useMultipleSorting: true,
            useGroupSummary: false,
            useLiveSearch: true,
            useContextMenu: true,
            useRowNumberer: true,
            filter: {
                useFilter: true,
                autoCreate: true
            }
        },
        tbar: [{
                xtype : 'button',
                id: 'printBtn',
                text:'출력',
                handler: function() {
                    if(panelResult.setAllFieldsReadOnly(true) == false){
                        return false;
                    }
                    UniAppManager.app.requestApprove();
                }
            }
        ],
        columns:  [ 
            { dataIndex: 'COMP_CODE'                           ,           width: 80, hidden: true},
            { dataIndex: 'DIV_CODE'                            ,           width: 80, hidden: true},
            { dataIndex: 'CUSTOM_CODE'                         ,           width: 110},
            { dataIndex: 'CUSTOM_NAME'                         ,           width: 200},
            { dataIndex: 'ITEM_CODE'                           ,           width: 110},
            { dataIndex: 'ITEM_NAME'                           ,           width: 200},
            { dataIndex: 'SPEC'                                ,           width: 80},
            { dataIndex: 'PRE_STOCK_Q'                         ,           width: 100},
            { dataIndex: 'INSTOCK_Q'                           ,           width: 80},
            { dataIndex: 'OUTSTOCK_Q'                          ,           width: 80},
            { dataIndex: 'STOCK_Q'                             ,           width: 80}
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
        },
            panelSearch     
        ],
        id  : 's_sbx901skrv_kdApp',
        fnInitBinding : function() {
            panelSearch.setValue('DIV_CODE',UserInfo.divCode);
            UniAppManager.setToolbarButtons(['save', 'newData','deleteAll'],false);
            panelSearch.clearForm();
            panelResult.clearForm(); 
            directMasterStore.clearData();
            this.setDefault();
        },
        onQueryButtonDown : function()  {
        	if(!panelSearch.setAllFieldsReadOnly(true)){
                return false;
            }           
            directMasterStore.loadStoreRecords();
            UniAppManager.setToolbarButtons('reset', true);
        },
        onResetButtonDown: function() {
            panelSearch.setAllFieldsReadOnly(false);
            panelResult.setAllFieldsReadOnly(false);
            masterGrid.reset();
            this.fnInitBinding();
        },
        requestApprove: function(){     //결재 요청
        	if(!panelSearch.setAllFieldsReadOnly(true)){
                return false;
            }
            
            var gsWin = window.open('about:blank','payviewer','width=500,height=500'); 
            
            var frm         = document.f1;
            var compCode    = UserInfo.compCode;
            var divCode     = panelResult.getValue('DIV_CODE');
            var customCode  = panelResult.getValue('CUSTOM_CODE');            
            var basisDate   = UniDate.getDbDateStr(panelResult.getValue('BASIS_DATE'));
            var spText      = 'EXEC omegaplus_kdg.unilite.USP_GW_S_SBX901SKRV_KD ' + "'" + compCode + "'" + ', ' + "'" + divCode + "'" +', ' + "'" + customCode + "'"+', '+ "'"+ basisDate + "'";
            var spCall      = encodeURIComponent(spText); 
            
//            frm.action = '/payment/payreq.php';
            frm.action   = groupUrl + "viewMode=docuDraft" + "&prg_no=s_sbx901skrv_kd&draft_no=" + '0' + "&sp=" + spCall;
//            frm.action   = groupUrl + "&prg_no=s_sbx900skrv_kd&draft_no=" + UserInfo.compCode + inoutNum + "&sp=" + spCall + Base64.encode();
            frm.target   = "payviewer"; 
            frm.method   = "post";
            frm.submit();
        },
        setDefault: function() {
            panelSearch.setValue('DIV_CODE',UserInfo.divCode);
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            panelSearch.setValue('BASIS_DATE', UniDate.get('today'));
            panelResult.setValue('BASIS_DATE', UniDate.get('today'));
        }
    });
};

</script>

<form id="f1" name="f1" action="" method="post" onSubmit="return false;" >
<input type="hidden" id="loginid" name="loginid" value="superadmin" />
<input type="hidden" id="fmpf" name="fmpf" value="" />
<input type="hidden" id="fmbd" name="fmbd" runat="server" />
</form>