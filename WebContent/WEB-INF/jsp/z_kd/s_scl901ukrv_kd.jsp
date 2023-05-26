<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_scl901ukrv_kd" >
    <t:ExtComboStore comboType="BOR120" pgmId="s_scl901ukrv_kd"/>   <!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="B004" />             <!-- 화폐단위-->
    <t:ExtComboStore comboType="AU" comboCode="B010" />             <!-- 사용여부-->
    <t:ExtComboStore comboType="AU" comboCode="B024" />             <!-- 담당자-->
    <t:ExtComboStore comboType="AU" comboCode="B013" />             <!-- 재고단위  -->
    <t:ExtComboStore comboType="AU" comboCode="B015" />             <!-- 거래처구분    -->         
    <t:ExtComboStore comboType="AU" comboCode="B038" />             <!-- 결제방법-->           
    <t:ExtComboStore comboType="AU" comboCode="B034" />             <!-- 결제조건-->             
    <t:ExtComboStore comboType="AU" comboCode="B055" />             <!-- 거래처분류-->      
    <t:ExtComboStore comboType="AU" comboCode="B038" />             <!-- 결제방법-->  
    <t:ExtComboStore comboType="AU" comboCode="A003" />             <!-- 구분  -->
    <t:ExtComboStore comboType="AU" comboCode="S003" />             <!-- 단가구분1(판매)  -->
    <t:ExtComboStore comboType="AU" comboCode="M301" />             <!-- 단가구분2(구매)  -->
    <t:ExtComboStore comboType="AU" comboCode="WB02" />             <!-- 이의사유  -->
    <t:ExtComboStore comboType="AU" comboCode="WB05" />             <!-- 수불구분  -->
    <t:ExtComboStore comboType="AU" comboCode="WB06" />             <!-- 종류  -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

var BsaCodeInfo = {     //컨트롤러에서 값을 받아옴.
    gsAutoType  :   '${gsAutoType}',
    gsMoneyUnit :   '${gsMoneyUnit}'
};

//var output ='';   // 셋팅 값 확인 alert
//for(var key in BsaCodeInfo){
//    output += key + '  :  ' + BsaCodeInfo[key] + '\n';
//}
//alert(output);

var SearchClaimNoWindow; // 검색창
var excelWindow;

function appMain() {
    var isAutoOrderNum = false;
    if(BsaCodeInfo.gsAutoType=='Y') {
        isAutoOrderNum = true;
    }

    // 엑셀업로드 window의 Grid Model
    Unilite.Excel.defineModel('excel.s_scl901ukrv_kd.sheet01', {
        fields: [
            {name: '_EXCEL_JOBID'        , text: 'EXCEL_JOBID'    , type: 'string'},
            {name: 'COMP_CODE'           , text: '법인코드'          , type: 'string'},
            {name: 'DIV_CODE'            , text: '사업장코드'         , type: 'string'},
            {name: 'ITEM_CODE'           , text: '품목코드'          ,type: 'string'},
            {name: 'ITEM_NAME'           , text: '품목명'          ,type: 'string'},
            {name: 'SPEC'                , text: '규격'          ,type: 'string'},
            {name: 'BS_COUNT'            , text: '발생건수'          , type: 'int'},
            {name: 'CLAIM_AMT'           , text: '금액'            , type: 'uniPrice'},
            {name: 'GJ_RATE'             , text: '공제비율'          , type: 'uniER'},
            {name: 'BAD_N_Q'             , text: '불량(N)'         , type: 'uniQty'},
            {name: 'BAD_C_Q'             , text: '불량(C)'         , type: 'uniQty'},
            {name: 'GJ_DATE'             , text: '공제일자'          , type: 'uniDate'},
            {name: 'GJ_AMT'              , text: '공제금액'          , type: 'uniPrice'},
            {name: 'YE_DATE'             , text: '이의일자'          , type: 'uniDate'},
            {name: 'YE_AMT'              , text: '이의금액'          , type: 'uniPrice'},
            {name: 'YE_NO'               , text: '이의번호'          , type: 'string'},
            {name: 'YE_FLAG'             , text: '이의사유'          , type: 'string', comboType: "AU", comboCode: "WB02"},
            {name: 'HB_DATE'             , text: '환불일자'          , type: 'uniDate'},
            {name: 'HB_AMT'              , text: '환불금액'          , type: 'uniPrice'},
            {name: 'HB_NO'               , text: '환불번호'          , type: 'string'},
            {name: 'IO_FLAG'             , text: '수불구분'          , type: 'string', comboType: "AU", comboCode: "WB05"},
            {name: 'KIND_FLAG'           , text: '종류'            , type: 'string', comboType: "AU", comboCode: "WB06"},
            {name: 'REMARK'              , text: '비고'            , type: 'string'  }


        ]
    });
    /**
     *   Model 정의 
     * @type 
     */
    Unilite.defineModel('s_scl901ukrv_kdModel', {        // 메인1
        fields: [
            {name: 'DIV_CODE'       , text: '사업장'       , type: 'string', comboType:'BOR120'},
            {name: 'CLAIM_NO'       , text: '클레임번호'   , type: 'string', allowBlank: false},
            {name: 'SEQ'            , text: '순번'         , type: 'int'},
            {name: 'CLAIM_DATE'     , text: '접수일자'     , type: 'uniDate'},
            {name: 'CUSTOM_CODE'    , text: '거래처코드'   , type: 'string'},
            {name: 'CUSTOM_NAME'    , text: '거래처명'     , type: 'string'},
            {name: 'ITEM_CODE'      , text: '품목코드'     , type: 'string', allowBlank: false},
            {name: 'ITEM_NAME'      , text: '품목명'       , type: 'string', allowBlank: false},
            {name: 'SPEC'           , text: '규격'         , type: 'string'},
            {name: 'OEM_ITEM_CODE'  , text: '품번'      , type: 'string'},
            {name: 'BS_COUNT'       , text: '발생건수'     , type: 'uniQty', allowBlank: false},
            {name: 'MONEY_UNIT'     , text: '화폐'         , type: 'string', comboType: "AU", comboCode: "B004", displayField: 'value'},
            {name: 'EXCHG_RATE_O'   , text: '환율'         , type: 'uniER'},
            {name: 'CLAIM_AMT'      , text: '금액'         , type: 'uniPrice', allowBlank: false},
            {name: 'GJ_RATE'        , text: '공제비율'     , type: 'uniER'},
            {name: 'BAD_N_Q'        , text: '불량(N)'      , type: 'uniQty'},
            {name: 'BAD_C_Q'        , text: '불량(C)'      , type: 'uniQty'},
            {name: 'DEPT_CODE'      , text: '부서코드'     , type: 'string', allowBlank: false},
            {name: 'DEPT_NAME'      , text: '부서명'       , type: 'string'},
            {name: 'GJ_DATE'        , text: '공제일자'     , type: 'uniDate'},
            {name: 'GJ_AMT'         , text: '공제금액'     , type: 'uniPrice'},
            {name: 'YE_DATE'        , text: '이의일자'     , type: 'uniDate'},
            {name: 'YE_AMT'         , text: '이의금액'     , type: 'uniPrice'},        
            {name: 'YE_NO'          , text: '이의번호'     , type: 'string'},                             
            {name: 'YE_FLAG'        , text: '이의사유'     , type: 'string', comboType: "AU", comboCode: "WB02"},                             
            {name: 'HB_DATE'        , text: '환불일자'     , type: 'uniDate'},
            {name: 'HB_AMT'         , text: '환불금액'     , type: 'uniPrice'},
            {name: 'HB_NO'          , text: '환불번호'     , type: 'string'},
            {name: 'IO_FLAG'        , text: '수불구분'     , type: 'string', comboType: "AU", comboCode: "WB05"},
            {name: 'KIND_FLAG'      , text: '종류'         , type: 'string', comboType: "AU", comboCode: "WB06"},
            {name: 'REMARK'         , text: '비고'         , type: 'string'}
        ]
    });//End of Unilite.defineModel('s_scl901ukrv_kdModel', {
    
    Unilite.defineModel('s_scl901ukrv_kdModel2', {  // 검색 팝업창
        fields: [
            {name: 'DIV_CODE'       , text: '사업장'       , type: 'string', comboType:'BOR120'},
            {name: 'CUSTOM_CODE'    , text: '거래처코드'   , type: 'string'},
            {name: 'CUSTOM_NAME'    , text: '거래처명'     , type: 'string'},
            {name: 'CLAIM_NO'       , text: '클레임번호'   , type: 'string'},
            {name: 'CLAIM_DATE'     , text: '접수일자'     , type: 'uniDate'},
            {name: 'DEPT_CODE'      , text: '부서코드'     , type: 'string'},
            {name: 'DEPT_NAME'      , text: '부서명'       , type: 'string'}
        ]
    });
    
    var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 's_scl901ukrv_kdService.selectList',
            update: 's_scl901ukrv_kdService.updateDetail',
            create: 's_scl901ukrv_kdService.insertDetail',
            destroy: 's_scl901ukrv_kdService.deleteDetail',
            syncAll: 's_scl901ukrv_kdService.saveAll'
        }
    });
    
    var panelSearch = Unilite.createSearchPanel('searchForm', {      
        title: '검색조건',
        region: 'west',
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
            items: [{
                fieldLabel: '사업장',
                name: 'DIV_CODE',
                holdable: 'hold',
                xtype: 'uniCombobox',
                comboType: 'BOR120',
                allowBlank:false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelResult.setValue('DIV_CODE', newValue);
                    }
                }
            },{
                fieldLabel: '클레임번호',
                name:'CLAIM_NO',   
                xtype: 'uniTextfield',
                maxLength:20,
                enforceMaxLength: true,
                //readOnly: isAutoOrderNum,
                holdable: isAutoOrderNum ? 'readOnly':'hold',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelResult.setValue('CLAIM_NO', newValue);
                    }
                }
            }, 
            Unilite.popup('AGENT_CUST', {
                    fieldLabel: '거래처', 
                    valueFieldName: 'CUSTOM_CODE',
                    textFieldName: 'CUSTOM_NAME', 
                    allowBlank:false,
                    holdable: 'hold',
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
                fieldLabel: '접수일자',
                xtype: 'uniDatefield',
                name: 'CLAIM_DATE',
                value: UniDate.get('today'),
                allowBlank:false,
                holdable: 'hold',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelResult.setValue('CLAIM_DATE', newValue);
                    }
                }
            },
                Unilite.popup('DEPT', { 
                fieldLabel: '부서', 
                valueFieldName: 'DEPT_CODE',
                textFieldName: 'DEPT_NAME',
                holdable: 'hold',
                allowBlank : false,
                listeners: {
                    onSelected: {
                        fn: function(records, type) {
                            panelResult.setValue('DEPT_CODE', panelSearch.getValue('DEPT_CODE'));
                            panelResult.setValue('DEPT_NAME', panelSearch.getValue('DEPT_NAME'));
                        },
                        scope: this
                    },
                    onClear: function(type) {
                        panelResult.setValue('DEPT_CODE', '');
                        panelResult.setValue('DEPT_NAME', '');
                    },
                    applyextparam: function(popup){                         
                        var authoInfo = pgmInfo.authoUser;              //권한정보(N-전체,A-자기사업장>5-자기부서)
                        var deptCode = UserInfo.deptCode;   //부서정보
                        var divCode = '';                   //사업장
                        
                        if(authoInfo == "A"){   //자기사업장 
                            popup.setExtParam({'DEPT_CODE': ""});
                            popup.setExtParam({'DIV_CODE': UserInfo.divCode});
                            
                        }else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){   //전체권한
                            popup.setExtParam({'DEPT_CODE': ""});
                            popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
                            
                        }else if(authoInfo == "5"){     //부서권한
                            popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
                            popup.setExtParam({'DIV_CODE': UserInfo.divCode});
                        }
                    }
                }
            })]
        }],     
        api: {
//            load: 's_scl901ukrv_kdService.selectMaster',
            submit: 's_scl901ukrv_kdService.syncMaster'                
        },
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
    });//End of var panelSearch = Unilite.createSearchForm('searchForm', {
    
    var panelResult = Unilite.createSearchForm('resultForm',{
        hidden: !UserInfo.appOption.collapseLeftSearch,
        region: 'north',
        layout : {type : 'uniTable', columns : 3},
        padding:'1 1 1 1',
        border:true,
        items: [{
                fieldLabel: '사업장',
                name: 'DIV_CODE',
                xtype: 'uniCombobox',
                comboType: 'BOR120',
                allowBlank:false,
                holdable: 'hold',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.setValue('DIV_CODE', newValue);
                    }
                }
            },      
//            Unilite.popup('CUST', {
            Unilite.popup('AGENT_CUST', {
                    fieldLabel: '거래처', 
                    valueFieldName: 'CUSTOM_CODE',
                    textFieldName: 'CUSTOM_NAME', 
                    allowBlank:false,
                    holdable: 'hold',
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
            }),{ 
                fieldLabel: '접수일자',
                xtype: 'uniDatefield',
                name: 'CLAIM_DATE',
                value: UniDate.get('today'),
                allowBlank:false,
                holdable: 'hold',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.setValue('CLAIM_DATE', newValue);
                    }
                }
            },{
                fieldLabel: '클레임번호',
                name:'CLAIM_NO',   
                xtype: 'uniTextfield',
                maxLength:20,
                enforceMaxLength: true,
                allowBlank : false,
                //readOnly: isAutoOrderNum,
                holdable: isAutoOrderNum ? 'readOnly':'hold',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.setValue('CLAIM_NO', newValue);

                    }
                }
            },
                Unilite.popup('DEPT', { 
                fieldLabel: '부서', 
                valueFieldName: 'DEPT_CODE',
                textFieldName: 'DEPT_NAME',
                allowBlank : false,
                holdable: 'hold',
                listeners: {
                    onSelected: {
                        fn: function(records, type) {
                            panelSearch.setValue('DEPT_CODE', panelResult.getValue('DEPT_CODE'));
                            panelSearch.setValue('DEPT_NAME', panelResult.getValue('DEPT_NAME'));
                        },
                        scope: this
                    },
                    onClear: function(type) {
                        panelSearch.setValue('DEPT_CODE', '');
                        panelSearch.setValue('DEPT_NAME', '');
                    },
                    applyextparam: function(popup){                         
                        var authoInfo = pgmInfo.authoUser;              //권한정보(N-전체,A-자기사업장>5-자기부서)
                        var deptCode = UserInfo.deptCode;   //부서정보
                        var divCode = '';                   //사업장
                        
                        if(authoInfo == "A"){   //자기사업장 
                            popup.setExtParam({'DEPT_CODE': ""});
                            popup.setExtParam({'DIV_CODE': UserInfo.divCode});
                            
                        }else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){   //전체권한
                            popup.setExtParam({'DEPT_CODE': ""});
                            popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
                            
                        }else if(authoInfo == "5"){     //부서권한
                            popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
                            popup.setExtParam({'DIV_CODE': UserInfo.divCode});
                        }
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
    
    var claimNoSearch = Unilite.createSearchForm('claimNoSearchForm', {     // 검색 팝업창
        layout: {type: 'uniTable', columns : 3},
        trackResetOnLoad: true,
        items: [{
                fieldLabel: '사업장',
                name: 'DIV_CODE',
                holdable: 'hold',
                xtype: 'uniCombobox',
                comboType: 'BOR120',
                allowBlank:false
            },      
//            Unilite.popup('CUST', {
            Unilite.popup('AGENT_CUST', {
                    fieldLabel: '거래처', 
                    valueFieldName: 'CUSTOM_CODE',
                    textFieldName: 'CUSTOM_NAME'
            }),{ 
                fieldLabel: '접수일자',
                xtype: 'uniDatefield',
                name: 'CLAIM_DATE',
                value: UniDate.get('today')
            },{
                fieldLabel: '클레임번호',
                name:'CLAIM_NO',   
                xtype: 'uniTextfield'
            }]
    }); // createSearchForm

    /**
     * Store 정의(Service 정의)
     * @type 
     */                 
    var directMasterStore1 = Unilite.createStore('s_scl901ukrv_kdMasterStore1', {
            model: 's_scl901ukrv_kdModel',
            autoLoad: false,
            uniOpt : {
                isMaster:  true,         // 상위 버튼 연결
                editable:  true,         // 수정 모드 사용
                deletable: true,         // 삭제 가능 여부
                useNavi :  false         // prev | newxt 버튼 사용
            },
            proxy: directProxy,
            loadStoreRecords : function()  {   
            var param = panelSearch.getValues();
                this.load({
                      params : param
                });         
            },
            saveStore : function()   {               
                var inValidRecs = this.getInvalidRecords();
                console.log("inValidRecords : ", inValidRecs);
    
                var toCreate = this.getNewRecords();
                var toUpdate = this.getUpdatedRecords();                
                var toDelete = this.getRemovedRecords();
                var list = [].concat(toUpdate, toCreate);
                console.log("list:", list);
    
                console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));
                var claimNo = panelResult.getValue('CLAIM_NO');
                
                
                //1. 마스터 정보 파라미터 구성
                var paramMaster= panelSearch.getValues();   //syncAll 수정
//                paramMaster.CLAIM_NO = claimNO;
                
                if(inValidRecs.length == 0) {
                    config = {
                        params: [paramMaster],
                        success: function(batch, option) {
                            var master = batch.operations[0].getResultSet();
                            panelSearch.setValue("CLAIM_NO", master.CLAIM_NO);
                            panelResult.setValue("CLAIM_NO", master.CLAIM_NO);
                            
                            panelSearch.getForm().wasDirty = false;
                            panelSearch.resetDirtyStatus();
                            console.log("set was dirty to false");
                            UniAppManager.setToolbarButtons('save', false);     
                         } 
                    };
                    this.syncAllDirect(config);
                } else {
                    var grid = Ext.getCmp('s_scl901ukrv_kdGrid1');
                    grid.uniSelectInvalidColumnAndAlert(inValidRecs);
                }
            }
        });     // End of var directMasterStore1 = Unilite.createStore('s_scl901ukrv_kdMasterStore1',{
        
        var claimNoMasterStore = Unilite.createStore('s_scl901ukrv_kdMasterStore1', {   // 검색 팝업창
            model: 's_scl901ukrv_kdModel2',
            autoLoad: false,
            uniOpt : {
                isMaster: true,         // 상위 버튼 연결
                editable: false,         // 수정 모드 사용
                deletable:false,         // 삭제 가능 여부
                useNavi : false         // prev | newxt 버튼 사용
            },
            proxy: {
                type: 'direct',
                api: {
                    read: 's_scl901ukrv_kdService.selectList2'
                }
            },
            loadStoreRecords : function()  {
                var param= Ext.getCmp('claimNoSearchForm').getValues();            
                console.log( param );
                this.load({
                    params : param
                });
                
            }
        });     // End of var directMasterStore1 = Unilite.createStore('s_scl901ukrv_kdMasterStore1',{
    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('s_scl901ukrv_kdGrid1', {
        // for tab      
        layout: 'fit',
        region: 'center',
        uniOpt:{    expandLastColumn: false,
                    useRowNumberer: true,
                    useMultipleSorting: true
        },tbar  : [{
            text    : '엑셀 업로드',
            id  : 'excelBtn',
            width   : 100,
            handler : function() {
                if(!panelResult.getInvalidMessage()) return;   //필수체크
                openExcelWindow();
            }
        }],
        store: directMasterStore1,
        columns: [
            {dataIndex: 'DIV_CODE'            , width: 140, hidden: true},
            {dataIndex: 'CLAIM_NO'            , width: 90, hidden: true},
            {dataIndex: 'SEQ'                 , width: 25, hidden: true},
            {dataIndex: 'CLAIM_DATE'          , width: 80, hidden: true},
            {dataIndex: 'CUSTOM_CODE'         , width: 100, hidden: true},
            {dataIndex: 'CUSTOM_NAME'         , width: 190, hidden: true},
            {dataIndex: 'ITEM_CODE'                     , width: 120,
                editor: Unilite.popup('DIV_PUMOK_G', {      
                        textFieldName: 'ITEM_CODE',
                        DBtextFieldName: 'ITEM_CODE',
			    		autoPopup: true,
                        listeners: {'onSelected': {
                            fn: function(records, type) {
                                console.log('records : ', records);
                                Ext.each(records, function(record,i) {                                                                     
                                    if(i==0) {
                                        masterGrid.setItemData(record,false, masterGrid.uniOpt.currentRecord);
                                    } else {
                                        UniAppManager.app.onNewDataButtonDown();
                                        masterGrid.setItemData(record,false, masterGrid.getSelectedRecord());
                                    }
                                }); 
                            },
                            scope: this
                        },
                        'onClear': function(type) {
                            masterGrid.setItemData(null,true, masterGrid.uniOpt.currentRecord);
                        },
                        applyextparam: function(popup){                         
                            popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
                        }
                    }
                })
            },
            {dataIndex: 'ITEM_NAME'               , width: 190,
                editor: Unilite.popup('DIV_PUMOK_G', {      
                        textFieldName: 'ITEM_CODE',
                        DBtextFieldName: 'ITEM_CODE',
			    		autoPopup: true,
                        listeners: {'onSelected': {
                            fn: function(records, type) {
                                console.log('records : ', records);
                                Ext.each(records, function(record,i) {                                                                     
                                    if(i==0) {
                                        masterGrid.setItemData(record,false, masterGrid.uniOpt.currentRecord);
                                    } else {
                                        UniAppManager.app.onNewDataButtonDown();
                                        masterGrid.setItemData(record,false, masterGrid.getSelectedRecord());
                                    }
                                }); 
                            },
                            scope: this
                        },
                        'onClear': function(type) {
                            masterGrid.setItemData(null,true, masterGrid.uniOpt.currentRecord);
                        },
                        applyextparam: function(popup){                         
                            popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
                        }
                    }
                })
            },
            {dataIndex: 'SPEC'                , width: 130},
            {dataIndex: 'OEM_ITEM_CODE'       , width: 110},
            {dataIndex: 'BS_COUNT'            , width: 110},
            {dataIndex: 'MONEY_UNIT'          , width: 80, hidden : true},
            {dataIndex: 'EXCHG_RATE_O'        , width: 90, hidden : true},
            {dataIndex: 'CLAIM_AMT'           , width: 120},
            {dataIndex: 'GJ_RATE'             , width: 90},
            {dataIndex: 'BAD_N_Q'             , width: 90},
            {dataIndex: 'BAD_C_Q'             , width: 90},
            {dataIndex: 'DEPT_CODE'                ,               width:100, hidden : true,
                'editor': Unilite.popup('DEPT_G',{
                    autoPopup: true,
                    DBtextFieldName: 'DEPT_CODE',
                    listeners: { 'onSelected': {
                        fn: function(records, type  ){
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('DEPT_CODE',records[0]['TREE_CODE']);
                            grdRecord.set('DEPT_NAME',records[0]['TREE_NAME']);
                            
                        },
                        scope: this
                      },
                      'onClear' : function(type)    {
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('DEPT_CODE','');
                            grdRecord.set('DEPT_NAME','');
                      }
                    }
                })
            },
            {dataIndex: 'DEPT_NAME'                ,               width:150, hidden : true,
              'editor': Unilite.popup('DEPT_G',{
                    autoPopup: true,
                    listeners: { 'onSelected': {
                        fn: function(records, type  ){
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('DEPT_CODE',records[0]['TREE_CODE']);
                            grdRecord.set('DEPT_NAME',records[0]['TREE_NAME']);
                            
                        },
                        scope: this
                      },
                      'onClear' : function(type)    {
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('DEPT_CODE','');
                            grdRecord.set('DEPT_NAME','');
                      }
                    }
                })
            },
            {dataIndex: 'GJ_DATE'             , width: 100},
            {dataIndex: 'GJ_AMT'              , width: 100},
            {dataIndex: 'YE_DATE'             , width: 100},
            {dataIndex: 'YE_AMT'              , width: 100},
            {dataIndex: 'YE_NO'               , width: 100},
            {dataIndex: 'YE_FLAG'             , width: 100},
            {dataIndex: 'HB_DATE'             , width: 100},
            {dataIndex: 'HB_AMT'              , width: 100},
            {dataIndex: 'HB_NO'               , width: 100},
            {dataIndex: 'IO_FLAG'             , width: 100},
            {dataIndex: 'KIND_FLAG'           , width: 100},
            {dataIndex: 'REMARK'              , width: 250}
        ],
        listeners: {
            beforeedit: function( editor, e, eOpts ) {
                if(UniUtils.indexOf(e.field, ['SPEC', 'OEM_ITEM_CODE', 'DEPT_CODE', 'DEPT_NAME', 'CUSTOM_CODE', 'CUSTOM_NAME', 'DIV_CODE']))
                    {
                        return false;
                    }
            }
        },
        setItemData: function(record, dataClear) {
            var grdRecord = this.getSelectedRecord();
            if(dataClear) {                                     
                grdRecord.set('ITEM_CODE'           , ''); 
                grdRecord.set('ITEM_NAME'           , ''); 
                grdRecord.set('SPEC'                , '');  
                grdRecord.set('OEM_ITEM_CODE'       , '');           
            } else {                                    
                grdRecord.set('ITEM_CODE'           , record['ITEM_CODE']);  
                grdRecord.set('ITEM_NAME'           , record['ITEM_NAME']); 
                grdRecord.set('SPEC'                , record['SPEC']);  
                grdRecord.set('OEM_ITEM_CODE'       , record['OEM_ITEM_CODE']); 
            }
            
        },
        setExcelData: function(record) {    //엑셀 업로드 참조
            var grdRecord = this.getSelectedRecord();
            grdRecord.set('COMP_CODE'         , record['COMP_CODE']);
            grdRecord.set('ITEM_CODE'             , record['ITEM_CODE']);
            grdRecord.set('ITEM_NAME'             , record['ITEM_NAME']);
            grdRecord.set('SPEC'             , record['SPEC']);
            grdRecord.set('BS_COUNT'        , record['BS_COUNT']);
            grdRecord.set('CLAIM_AMT'           , record['CLAIM_AMT']);
            grdRecord.set('GJ_RATE'           , record['GJ_RATE']);
            grdRecord.set('BAD_N_Q'                , record['BAD_N_Q']);
            grdRecord.set('BAD_C_Q'          , record['BAD_C_Q']);
            grdRecord.set('GJ_DATE'          , record['GJ_DATE']);
            grdRecord.set('GJ_AMT'         , record['GJ_AMT']);
            grdRecord.set('YE_DATE'        , record['YE_DATE']);
            grdRecord.set('YE_AMT'         , record['YE_AMT']);
            grdRecord.set('YE_NO'         , record['YE_NO']);
            grdRecord.set('YE_FLAG'         , record['YE_FLAG']);
            grdRecord.set('HB_DATE'         , record['HB_DATE']);
            grdRecord.set('HB_AMT'         , record['HB_AMT']);
            grdRecord.set('HB_NO'         , record['HB_NO']);
            grdRecord.set('IO_FLAG'         , record['IO_FLAG']);
            grdRecord.set('KIND_FLAG'         , record['KIND_FLAG']);
            grdRecord.set('REMARK'         , record['REMARK']);
            
        }

    });//End of var masterGrid = Unilite.createGrid('s_scl901ukrv_kdGrid1', { 
    
    var claimNoMasterGrid = Unilite.createGrid('s_scl901ukrv_kdClaimNoMasterGrid', {     // 검색 팝업창
        // title: '기본',
        layout : 'fit',       
        store: claimNoMasterStore,
        uniOpt:{
            useRowNumberer: false
        },
        columns:  [
            {dataIndex : 'DIV_CODE'             , width : 140},
            {dataIndex : 'CUSTOM_CODE'          , width : 120},
            {dataIndex : 'CUSTOM_NAME'          , width : 200},
            {dataIndex : 'CLAIM_NO'             , width : 120},
            {dataIndex : 'DEPT_CODE'            , width : 120, hidden : true},
            {dataIndex : 'DEPT_NAME'            , width : 120, hidden : true},
            {dataIndex : 'CLAIM_DATE'           , width : 90}
        ],
        listeners: {    
            onGridDblClick:function(grid, record, cellIndex, colName) {
                claimNoMasterGrid.returnData(record);
                UniAppManager.app.onQueryButtonDown();
                SearchClaimNoWindow.hide();
            }
        },
        returnData: function(record)   {
            if(Ext.isEmpty(record)) {
                record = this.getSelectedRecord();
            }
            panelSearch.setValues({'DIV_CODE'       : record.get('DIV_CODE')});
            panelSearch.setValues({'CLAIM_NO'       : record.get('CLAIM_NO')});
            panelSearch.setValues({'CLAIM_DATE'     : record.get('CLAIM_DATE')});
            panelSearch.setValues({'CUSTOM_CODE'    : record.get('CUSTOM_CODE')});
            panelSearch.setValues({'CUSTOM_NAME'    : record.get('CUSTOM_NAME')});
            panelSearch.setValues({'DEPT_CODE'      : record.get('DEPT_CODE')});
            panelSearch.setValues({'DEPT_NAME'      : record.get('DEPT_NAME')});
            panelResult.setValues({'DIV_CODE'       : record.get('DIV_CODE')});
            panelResult.setValues({'CLAIM_NO'       : record.get('CLAIM_NO')});
            panelResult.setValues({'CLAIM_DATE'     : record.get('CLAIM_DATE')});
            panelResult.setValues({'CUSTOM_CODE'    : record.get('CUSTOM_CODE')});
            panelResult.setValues({'CUSTOM_NAME'    : record.get('CUSTOM_NAME')});
            panelResult.setValues({'DEPT_CODE'      : record.get('DEPT_CODE')});
            panelResult.setValues({'DEPT_NAME'      : record.get('DEPT_NAME')});
        }   
    });
    
    function openSearchClaimNoWindow() {   // 검색 팝업창
        if(!SearchClaimNoWindow) {
            SearchClaimNoWindow = Ext.create('widget.uniDetailWindow', {
                title: '클레임번호검색',
                width: 1080,                             
                height: 580,
                layout: {type:'vbox', align:'stretch'},                 
                items: [claimNoSearch, claimNoMasterGrid], 
                tbar:  ['->',
                    {itemId : 'saveBtn',
                    text: '조회',
                    handler: function() {
                        claimNoMasterStore.loadStoreRecords();
                    },
                    disabled: false
                    }, {
                        itemId : 'OrderNoCloseBtn',
                        text: '닫기',
                        handler: function() {
                            SearchClaimNoWindow.hide();
                        },
                        disabled: false
                    }
                ],
                listeners: {beforehide: function(me, eOpt)
                    {
                        claimNoSearch.clearForm();
                        claimNoMasterGrid.reset();                                              
                    },
                    beforeclose: function( panel, eOpts ) {
                        claimNoSearch.clearForm();
                        claimNoMasterGrid.reset();
                    },
                    beforeshow: function( panel, eOpts )    {
                        claimNoSearch.setValue('DIV_CODE',panelSearch.getValue('DIV_CODE'));
                        claimNoSearch.setValue('CLAIM_NO',panelSearch.getValue('CLAIM_NO'));
                        claimNoSearch.setValue('CUSTOM_CODE',panelSearch.getValue('CUSTOM_CODE'));
                        claimNoSearch.setValue('CUSTOM_NAME',panelSearch.getValue('CUSTOM_NAME'));   
                        claimNoSearch.setValue('CLAIM_DATE',panelSearch.getValue('CLAIM_DATE'));
                    }
                }       
            })
        }
        SearchClaimNoWindow.show();
        SearchClaimNoWindow.center();
    }
    
    
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
        id: 's_scl901ukrv_kdApp',
        fnInitBinding: function() {
            panelSearch.setValue('DIV_CODE',UserInfo.divCode);
            panelSearch.setValue('CLAIM_DATE', UniDate.get('today'));
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            panelResult.setValue('CLAIM_DATE', UniDate.get('today'));          
            UniAppManager.setToolbarButtons('save', false);  
            UniAppManager.setToolbarButtons(['newData'],true);  
        },
        onQueryButtonDown: function() {         
            var claimNo = panelSearch.getValue('CLAIM_NO');
            if(Ext.isEmpty(claimNo)) {
                openSearchClaimNoWindow() 
            } else {
                if(panelSearch.setAllFieldsReadOnly(true) == false){
                    return false;
                } else if(panelResult.setAllFieldsReadOnly(true) == false){
                    return false;
                }else {
                    var param= panelSearch.getValues();
                    directMasterStore1.loadStoreRecords();
                    UniAppManager.setToolbarButtons(['reset', 'newData'],true);
                }
            }
        },
        setDefault: function() {        // 기본값
            panelSearch.setValue('DIV_CODE',UserInfo.divCode);
            panelSearch.setValue('CLAIM_DATE', UniDate.get('today'));
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            panelResult.setValue('CLAIM_DATE', UniDate.get('today'));
            panelSearch.getForm().wasDirty = false;
            panelSearch.resetDirtyStatus();                            
            UniAppManager.setToolbarButtons('save', false); 
        },
        onResetButtonDown: function() {     // 초기화
            this.suspendEvents();
            panelSearch.clearForm();
            panelResult.clearForm();
            panelSearch.setAllFieldsReadOnly(false);
            panelResult.setAllFieldsReadOnly(false);
            panelSearch.setValue('DIV_CODE',UserInfo.divCode);
            panelSearch.setValue('CLAIM_DATE', UniDate.get('today'));
            masterGrid.reset();
            this.fnInitBinding();
            directMasterStore1.clearData();
        },
        onDeleteDataButtonDown: function() {    // 행삭제 버튼
            var selRow1 = masterGrid.getSelectedRecord();
            if(selRow1.phantom === true)    {
                masterGrid.deleteSelectedRow();
            }else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
                masterGrid.deleteSelectedRow();
            }
        },
        onNewDataButtonDown: function() {       // 행추가
        	var divCode         = panelSearch.getValue('DIV_CODE'); 
            var claimNo         = panelSearch.getValue('CLAIM_NO');  
            var seq             = directMasterStore1.max('SEQ');
                if(!seq) seq = 1;
                else seq += 1;
            var claimDate       = panelSearch.getValue('CLAIM_DATE');  
            var customCode      = panelSearch.getValue('CUSTOM_CODE');  
            var customName      = panelSearch.getValue('CUSTOM_NAME');  
            var itemCode        = '';
            var itemName        = '';
            var spec            = '';
            var oemItemCode     = '';
            var bsCount         = 0;
            var moneyUnit       = BsaCodeInfo.gsMoneyUnit; 
            var exchgRate       = 1;
            var claimAmt        = 0;
            var gjRate          = 0;
            var badNq           = 0;
            var badCq           = 0;
            var deptCode        = panelSearch.getValue('DEPT_CODE');  
            var deptName        = panelSearch.getValue('DEPT_NAME'); 
            var gjDate          = ''; 
            var gjAmt           = 0; 
            var yeDate          =''; 
            var yeAmt           = 0; 
            var yeNo            = ''; 
            var yeFlag          = ''; 
            var hbDate          = ''; 
            var hbAmt           = 0; 
            var hbNo            = ''; 
            var ioFlag          = ''; 
            var kindFlag        = ''; 
            var remark          = '';
            
            var r = {
                DIV_CODE        : divCode,    
                CLAIM_NO        : claimNo,
                SEQ             : seq,
                CLAIM_DATE      : claimDate,
                CUSTOM_CODE     : customCode,
                CUSTOM_NAME     : customName,
                ITEM_CODE       : itemCode,
                ITEM_NAME       : itemName,
                SPEC            : spec,
                OEM_ITEM_CODE   : oemItemCode,
                BS_COUNT        : bsCount,
                MONEY_UNIT      : moneyUnit,
                EXCHG_RATE_O    : exchgRate,
                CLAIM_AMT       : claimAmt,
                GJ_RATE         : gjRate,
                BAD_N_Q         : badNq,
                BAD_C_Q         : badCq,
                DEPT_CODE       : deptCode,
                DEPT_NAME       : deptName,
                GJ_DATE         : gjDate,
                GJ_AMT          : gjAmt,
                YE_DATE         : yeDate,
                YE_AMT          : yeAmt,
                YE_NO           : yeNo,
                YE_FLAG         : yeFlag,
                HB_DATE         : hbDate,
                HB_AMT          : hbAmt,
                HB_NO           : hbNo,
                IO_FLAG         : ioFlag,
                KIND_FLAG       : kindFlag,
                REMARK          : remark
            };
        	if(panelResult.setAllFieldsReadOnly(true) == false){
                return false;
            } else {
            	panelSearch.setAllFieldsReadOnly(true);
                panelResult.setAllFieldsReadOnly(true);
                masterGrid.createRow(r);
            }
        },
        onSaveDataButtonDown: function(config) {    // 저장 버튼
        	var claimNo = panelSearch.getValue('CLAIM_NO');
            if(Ext.isEmpty(claimNo)) {
                alert('클레임번호가 필수입력합니다.');  
                return false;
            } else {
                          directMasterStore1.saveStore(); 
/*
접수일자까지 key 로 잡음.                                      
            	var param = panelSearch.getValues();                                       
                s_scl901ukrv_kdService.checkClaimNo(param, function(provider, response) {  
                      console.log("dataCheckSave", response);                              
                      if(Ext.isEmpty(provider)) {                                          
                          directMasterStore1.saveStore();                             
                      } else {                                                             
                        alert("중복된 클레임번호가 입력되었습니다.");                                      
                      }                                                                    
                  });  
*/                                    
            }
            //UniAppManager.app.onQueryButtonDown();
        }/*,
        fnMasterSave: function() {   
            var param = panelSearch.getValues();
            panelSearch.submit({
                params: param,
                success:function(comp, action)  {
//                	panelSearch.getForm().load();
                	var claimNO = action.result.CLAIM_NO;
                	directMasterStore1.saveStore(claimNO); 
                    UniAppManager.setToolbarButtons('save', false);
                    UniAppManager.updateStatus(Msg.sMB011);
                },
                failure: function(form, action){
                    
                }
            }); 
        }*/
    });
     //엑셀업로드 윈도우 생성 함수
    function openExcelWindow() {
        var me = this;
        var vParam = {};
        var appName = 'Unilite.com.excel.ExcelUpload';
        if(!directMasterStore1.isDirty())  {                                   //화면에 저장할 내용이 있을 경우 저장여부 확인
            //masterStore.loadData({});
        } else {
            if(confirm('저장될 내용이 있습니다. '+'\n'+'저장하시겠습니까?')){
                UniAppManager.app.onSaveDataButtonDown();
                return;
            }else {
                directMasterStore1.loadData({});
            }
        }
        /*if(!Ext.isEmpty(excelWindow)){
            excelWindow.extParam.DIV_CODE       = panelResult.getValue('DIV_CODE');
//          excelWindow.extParam.ISSUE_GUBUN    = Ext.getCmp('rdoSelect0').getChecked()[0].inputValue;
//          excelWindow.extParam.APPLY_YN       = Ext.getCmp('rdoSelect0_0').getChecked()[0].inputValue;
        }*/
        if(!excelWindow) {
            excelWindow = Ext.WindowMgr.get(appName);
            excelWindow = Ext.create( appName, {
                excelConfigName: 's_scl901ukrv_kd',
                width   : 600,
                height  : 400,
                modal   : false,
                extParam: {
                    'PGM_ID'    : 's_scl901ukrv_kd'
                    //'DIV_CODE'  : panelResult.getValue('DIV_CODE')
                },
                grids: [{                           //팝업창에서 가져오는 그리드
                        itemId      : 'grid01',
                        title       : '엑셀업로드',
                        useCheckbox : true,
                        model       : 'excel.s_scl901ukrv_kd.sheet01',
                        readApi     : 's_scl901ukrv_kdService.selectExcelUploadSheet1',
                        columns     : [
                            {dataIndex: '_EXCEL_JOBID'      , width: 80     , hidden: true},
                            {dataIndex: 'COMP_CODE'         , width: 93     , hidden: true},
                            {dataIndex: 'DIV_CODE'         , width: 93     , hidden: true},
                            {dataIndex: 'ITEM_CODE'        , width: 100},
                            {dataIndex: 'ITEM_NAME'        , width: 100},
                            {dataIndex: 'SPEC'        , width: 100},
                            {dataIndex: 'BS_COUNT'        , width: 100},
                            {dataIndex: 'CLAIM_AMT'        , width: 100},
                            {dataIndex: 'GJ_RATE'        , width: 100},
                            {dataIndex: 'BAD_N_Q'         , width: 100},
                            {dataIndex: 'BAD_C_Q'         , width: 100},
                            {dataIndex: 'GJ_DATE'              , width: 100},
                            {dataIndex: 'GJ_AMT'          , width: 100},
                            {dataIndex: 'YE_DATE'      , width: 100},
                            {dataIndex: 'YE_AMT'      , width: 100},
                            {dataIndex: 'YE_NO'      , width: 100},
                            {dataIndex: 'YE_FLAG'     , width: 100},
                            {dataIndex: 'HB_DATE'     , width: 100},
                            {dataIndex: 'HB_AMT'     , width: 100},
                            {dataIndex: 'HB_NO'     , width: 100},
                            {dataIndex: 'IO_FLAG'     , width: 100},
                            {dataIndex: 'KIND_FLAG'     , width: 100},
                            {dataIndex: 'REMARK'            , width: 133}
                        ]
                    }
                ],
                listeners: {
                    close: function() {
                        this.hide();
                    }
                },

                onApply:function()  {
                    excelWindow.getEl().mask('로딩중...','loading-indicator');
                    var me      = this;
                    var grid    = this.down('#grid01');
                    var records = grid.getSelectionModel().getSelection();
                            Ext.each(records, function(record,i){
                                                        UniAppManager.app.onNewDataButtonDown();
                                                        masterGrid.setExcelData(record.data);
                                                    });
                            //grid.getStore().remove(records);
                            excelWindow.getEl().unmask();
                            var beforeRM = grid.getStore().count();
                            grid.getStore().remove(records);
                            var afterRM = grid.getStore().count();
                            if (beforeRM > 0 && afterRM == 0){
                               excelWindow.close();
                            };
                   
                },
                //툴바 세팅
                _setToolBar: function() {
                    var me = this;
                    me.tbar = [
                    '->',
                    {
                        xtype   : 'button',
                        text    : '업로드',
                        tooltip : '업로드',
                        width   : 60,
                        handler: function() {
                            me.jobID = null;
                            me.uploadFile();
                        }
                    },{
                        xtype   : 'button',
                        text    : '적용',
                        tooltip : '적용',
                        width   : 60,
                        handler : function() {
                            var grids   = me.down('grid');
                            var isError = false;
                            if(Ext.isDefined(grids.getEl()))    {
                                grids.getEl().mask();
                            }
                            Ext.each(grids, function(grid, i){
                                var records = grid.getStore().data.items;
                                return Ext.each(records, function(record, i){
                                    if(record.get('_EXCEL_HAS_ERROR') == 'Y') {
                                        console.log("_EXCEL_HAS_ERROR : ", record.get('_EXCEL_HAS_ERROR'));
                                        isError = true;
                                        return false;
                                    }
                                });
                            });
                            if(Ext.isDefined(grids.getEl()))    {
                                grids.getEl().unmask();
                            }
                            if(!isError) {
                                me.onApply();
                            }else {
                                alert("에러가 있는 행은 적용이 불가능합니다.");
                            }
                        }
                    },{
                            xtype: 'tbspacer'
                    },{
                            xtype: 'tbseparator'
                    },{
                            xtype: 'tbspacer'
                    },{
                        xtype: 'button',
                        text : '닫기',
                        tooltip : '닫기',
                        handler: function() {
                            var grid = me.down('#grid01');
                            grid.getStore().removeAll();
                            me.hide();
                        }
                    }
                ]}
            });
        }
        excelWindow.center();
        excelWindow.show();
    };
    

};



</script>
