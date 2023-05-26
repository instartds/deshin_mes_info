<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_scl901skrv_kd" >
    <t:ExtComboStore comboType="BOR120" pgmId="s_scl901skrv_kd"/>   <!-- 사업장 -->
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

function appMain() {
    
    var groupUrl = '${groupUrl}'; //그룹웨어 호출 url

    /**
     *   Model 정의 
     * @type 
     */
    Unilite.defineModel('s_scl901skrv_kdModel', {        // 메인1
        fields: [
            {name: 'DIV_CODE'       , text: '사업장'       , type: 'string', comboType:'BOR120'},
            {name: 'CUSTOM_CODE'    , text: '거래처코드'   , type: 'string'},
            {name: 'CUSTOM_NAME'    , text: '거래처명'     , type: 'string'},
            {name: 'CLAIM_DATE'     , text: '접수일자'     , type: 'uniDate'},
            {name: 'CLAIM_NO'       , text: '클레임번호'   , type: 'string'},
            {name: 'SEQ'            , text: '순번'         , type: 'int'},
            {name: 'ITEM_CODE'      , text: '품목코드'     , type: 'string'},
            {name: 'ITEM_NAME'      , text: '품목명'       , type: 'string'},
            {name: 'SPEC'           , text: '규격'         , type: 'string'},
            {name: 'OEM_ITEM_CODE'  , text: '품번'      , type: 'string'},
            {name: 'BS_COUNT'       , text: '발생건수'     , type: 'uniQty'},
            {name: 'MONEY_UNIT'     , text: '화폐'         , type: 'string', comboType: "AU", comboCode: "B004", displayField: 'value'},
            {name: 'EXCHG_RATE_O'   , text: '환율'         , type: 'uniER'},
            {name: 'CLAIM_AMT'      , text: '금액'         , type: 'uniPrice'},
            {name: 'GJ_RATE'        , text: '공제비율'     , type: 'uniER'},
            {name: 'BAD_N_Q'        , text: '불량(N)'      , type: 'uniQty'},
            {name: 'BAD_C_Q'        , text: '불량(C)'      , type: 'uniQty'},
            {name: 'DEPT_CODE'      , text: '부서코드'     , type: 'string'},
            {name: 'DEPT_NAME'      , text: '부서명'       , type: 'string'},
            {name: 'GJ_DATE'        , text: '공제일자'     , type: 'uniDate'},
            {name: 'GJ_AMT'         , text: '공제금액'     , type: 'uniPrice'},
            {name: 'YE_DATE'        , text: '이의일자'     , type: 'uniDate'},
            {name: 'YE_AMT'         , text: '이의금액'     , type: 'uniPrice'},
            {name: 'YE_NO'          , text: '이의번호'     , type: 'string'},
            {name: 'YE_FLAG'        , text: '이의사유'     , type: 'string'},
            {name: 'HB_DATE'        , text: '환불일자'     , type: 'uniDate'},
            {name: 'HB_AMT'         , text: '환불금액'     , type: 'uniPrice'},
            {name: 'HB_NO'          , text: '환불번호'     , type: 'string'},
            {name: 'IO_FLAG'        , text: '수불구분'     , type: 'string'},
            {name: 'KIND_FLAG'      , text: '종류'         , type: 'string'},
            {name: 'REMARK'         , text: '비고'         , type: 'string'}
        ]
    });//End of Unilite.defineModel('s_scl901skrv_kdModel', {
    
    var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 's_scl901skrv_kdService.selectList'
        }
    });
    
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
                allowBlank:false
            },
            Unilite.popup('AGENT_CUST', {
                    fieldLabel: '거래처', 
                    valueFieldName: 'CUSTOM_CODE',
                    textFieldName: 'CUSTOM_NAME'
            }),{ 
                fieldLabel: '접수일자',
                xtype: 'uniDateRangefield',
                startFieldName: 'CLAIM_DATE_FR',
                endFieldName: 'CLAIM_DATE_TO',
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today')
            },      
            Unilite.popup('CLAIM_G', {
                    fieldLabel: '클레임번호', 
                    DBtextFieldName: 'CLAIM_NO',
                    textFieldName: 'CLAIM_NO',
                    name:'CLAIM_NO',
		    		autoPopup: true
            }),
                Unilite.popup('DEPT', { 
                fieldLabel: '부서', 
                valueFieldName: 'DEPT_CODE',
                textFieldName: 'DEPT_NAME',
                listeners: {
                    applyextparam: function(popup){
                        var authoInfo = pgmInfo.authoUser;              //권한정보(N-전체,A-자기사업장>5-자기부서)
                        var deptCode = UserInfo.deptCode;   //부서정보
                        var divCode = '';                   //사업장
                        
                        if(authoInfo == "A"){   //자기사업장 
                            popup.setExtParam({'DEPT_CODE': ""});
                            popup.setExtParam({'DIV_CODE': UserInfo.divCode});
                            
                        }else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){   //전체권한
                            popup.setExtParam({'DEPT_CODE': ""});
                            popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
                            
                        }else if(authoInfo == "5"){     //부서권한
                            popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
                            popup.setExtParam({'DIV_CODE': UserInfo.divCode});
                        }
                    }
                }
            })
            /*,{
                fieldLabel: '클레임번호',
                name:'CLAIM_NO',   
                xtype: 'uniTextfield',
                holdable: 'hold',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelResult.setValue('CLAIM_NO', newValue);
                    }
                }
            }*/],
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
     * Store 정의(Service 정의)
     * @type 
     */                 
    var directMasterStore1 = Unilite.createStore('s_scl901skrv_kdMasterStore1', {
            model: 's_scl901skrv_kdModel',
            autoLoad: false,
            uniOpt : {
                isMaster:  true,         // 상위 버튼 연결
                editable:  false,        // 수정 모드 사용
                deletable: false,        // 삭제 가능 여부
                useNavi :  false         // prev | newxt 버튼 사용
            },
            proxy: directProxy,
            loadStoreRecords : function()  {   
            var param = panelResult.getValues();
                this.load({
                      params : param
                });         
            },
            groupField: 'CUSTOM_NAME'
        });     // End of var directMasterStore1 = Unilite.createStore('s_scl901skrv_kdMasterStore1',{
        
    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('s_scl901skrv_kdGrid1', {
        // for tab      
        layout: 'fit',
        region: 'center',
        uniOpt:{ 
                    useGroupSummary: true,
                    useLiveSearch: true,
                    useContextMenu: true,
                    useMultipleSorting: true,
                    useRowNumberer: true,
                    expandLastColumn: false,
        },
        store: directMasterStore1,
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
        features: [{
            id: 'masterGridSubTotal',
            ftype: 'uniGroupingsummary', 
            showSummaryRow: true 
        },{
            id: 'masterGridTotal', 
            ftype: 'uniSummary',   
            showSummaryRow: true
        }],
      	           
        columns: [
            {dataIndex: 'DIV_CODE'            , width: 140,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                    return Unilite.renderSummaryRow(summaryData, metaData, '품목소계', '총계');
            }
            },
            {dataIndex: 'CUSTOM_CODE'         , width: 120},
            {dataIndex: 'CUSTOM_NAME'         , width: 170},
            {dataIndex: 'CLAIM_DATE'          , width: 90},
            {dataIndex: 'CLAIM_NO'            , width: 90, hidden: true},
//            {dataIndex: 'SEQ'                 , width: 25},
            {dataIndex: 'ITEM_CODE'           , width: 120},
            {dataIndex: 'ITEM_NAME'           , width: 190},
            {dataIndex: 'SPEC'                , width: 130},
            {dataIndex: 'OEM_ITEM_CODE'       , width: 110},
            {dataIndex: 'BS_COUNT'            , width: 90, summaryType: 'sum'},
            {dataIndex: 'MONEY_UNIT'          , width: 80, hidden : true},
            {dataIndex: 'EXCHG_RATE_O'        , width: 80, hidden : true},
            {dataIndex: 'CLAIM_AMT'           , width: 90, summaryType: 'sum'},
            {dataIndex: 'GJ_RATE'             , width: 90},
            {dataIndex: 'BAD_N_Q'             , width: 90, summaryType: 'sum'},
            {dataIndex: 'BAD_C_Q'             , width: 90, summaryType: 'sum'},
            {dataIndex: 'DEPT_CODE'           , width:100},
            {dataIndex: 'DEPT_NAME'           , width:150},
            {dataIndex: 'GJ_DATE'             , width: 90},
            {dataIndex: 'GJ_AMT'              , width: 90, summaryType: 'sum'},
            {dataIndex: 'YE_DATE'             , width: 90},
            {dataIndex: 'YE_AMT'              , width: 90, summaryType: 'sum'},
            {dataIndex: 'YE_NO'               , width: 90},
            {dataIndex: 'YE_FLAG'             , width: 90},
            {dataIndex: 'HB_DATE'             , width: 90},
            {dataIndex: 'HB_AMT'              , width: 90, summaryType: 'sum'},
            {dataIndex: 'HB_NO'               , width: 90},
            {dataIndex: 'IO_FLAG'             , width: 90},
            {dataIndex: 'KIND_FLAG'           , width: 90},
            {dataIndex: 'REMARK'              , width: 250}
        ]
    });//End of var masterGrid = Unilite.createGrid('s_scl901skrv_kdGrid1', { 
    
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
        id: 's_scl901skrv_kdApp',
        fnInitBinding: function() {
            panelResult.setValue('DIV_CODE',        UserInfo.divCode);
            panelResult.setValue('CLAIM_DATE_FR',   UniDate.get('startOfMonth'));
            panelResult.setValue('CLAIM_DATE_TO',   UniDate.get('today'));     
            UniAppManager.setToolbarButtons('save', false);
        },
        onQueryButtonDown: function() {         
            directMasterStore1.loadStoreRecords();
        },
        requestApprove: function(){     //결재 요청
//            if(!panelResult.setAllFieldsReadOnly(true)){
//                return false;
//            }
//            
            if(Ext.isEmpty(panelResult.getValue('DEPT_CODE'))) {
                alert('부서를 입력하십시오.');
                return false;
            }
            
            var startDate   = UniDate.getDbDateStr(panelResult.getValue('CLAIM_DATE_FR'));
            var endDate     = UniDate.getDbDateStr(panelResult.getValue('CLAIM_DATE_TO'));
            
            if(startDate.substring(0, 6) != endDate.substring(0, 6)) {
                alert('접수일자는 같은 달이어야 합니다.');
                return false;
            }
            
            var gsWin = window.open('about:blank','payviewer','width=500,height=500'); 
            
            var frm         = document.f1;
            var compCode    = UserInfo.compCode;
            var divCode     = panelResult.getValue('DIV_CODE');
            var deptCode    = panelResult.getValue('DEPT_CODE');
            var frDate      = UniDate.getDbDateStr(panelResult.getValue('CLAIM_DATE_FR'));
            var toDate      = UniDate.getDbDateStr(panelResult.getValue('CLAIM_DATE_TO'));
            
            if(Ext.isEmpty(panelResult.getValue('CUSTOM_CODE'))) {
                var customCode  = '';
            } else {
                var customCode  = panelResult.getValue('CUSTOM_CODE'); 
            }
            var spText      = 'EXEC omegaplus_kdg.unilite.USP_GW_S_SCL901SKRV_KD ' + "'" + compCode + "'" + ', ' + "'" + divCode + "'" + ', ' + "'" + deptCode + "'" + ', ' + "'" + frDate + "'" + ', ' + "'" + toDate + "'" + ', ' + "'" + customCode + "'";
            var spCall      = encodeURIComponent(spText);
            
//            frm.action = '/payment/payreq.php';
            frm.action   = groupUrl + "viewMode=docuDraft" + "&prg_no=s_scl901skrv_kd&draft_no=" + '0' + "&sp=" + spCall;
//            frm.action   = groupUrl + "&prg_no=s_scl901skrv_kd&draft_no=" + UserInfo.compCode + inoutNum + "&sp=" + spCall + Base64.encode();
            frm.target   = "payviewer"; 
            frm.method   = "post";
            frm.submit();
        },
        setDefault: function() {        // 기본값
            panelResult.setValue('DIV_CODE',        UserInfo.divCode);
            panelResult.setValue('CLAIM_DATE_FR',   UniDate.get('startOfMonth'));
            panelResult.setValue('CLAIM_DATE_TO',   UniDate.get('today'));
            panelResult.getForm().wasDirty = false;
            panelResult.resetDirtyStatus();                            
            UniAppManager.setToolbarButtons('save', false); 
        },
        onResetButtonDown: function() {     // 초기화
            this.suspendEvents();
            panelResult.clearForm();
            panelResult.setAllFieldsReadOnly(false);
            panelResult.setValue('DIV_CODE',        UserInfo.divCode);
            panelResult.setValue('CLAIM_DATE_FR',   UniDate.get('startOfMonth'));
            panelResult.setValue('CLAIM_DATE_TO',   UniDate.get('today'));
            masterGrid.reset();
            this.fnInitBinding();
            directMasterStore1.clearData();
        }
    });
};

</script>

<form id="f1" name="f1" action="" method="post" onSubmit="return false;" >
<input type="hidden" id="loginid" name="loginid" value="superadmin" />
<input type="hidden" id="fmpf" name="fmpf" value="" />
<input type="hidden" id="fmbd" name="fmbd" runat="server" />
</form>