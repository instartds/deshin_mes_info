<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="aep150ukr"  >
    <t:ExtComboStore comboType="AU" comboCode="J501" /> <!-- 채권구분 -->
    <t:ExtComboStore comboType="AU" comboCode="J502" /> <!-- 이관취소사유 -->
    <t:ExtComboStore comboType="AU" comboCode="J504" /> <!-- 진행상태 -->
    <t:ExtComboStore comboType="AU" comboCode="J504" /> <!-- 관리구분 -->
    <t:ExtComboStore comboType="AU" comboCode="A134" /> <!-- 결재상태 -->
    <t:ExtComboStore comboType="AU" comboCode="J682" /> <!-- 전표상태코드 -->
    <t:ExtComboStore comboType="AU" comboCode="A177" /> <!-- 경비유형 -->
    <t:ExtComboStore comboType="AU" comboCode="A006" /> <!-- 원가구분 -->
    <t:ExtComboStore comboType="AU" comboCode="J518" /> <!-- 전표유형 -->
    <t:ExtComboStore comboType="AU" comboCode="J668" /> <!-- 지급방법코드 -->
    <t:ExtComboStore comboType="AU" comboCode="J699" /> <!-- 원천세유형 -->
    <t:ExtComboStore comboType="AU" comboCode="J650" /> <!-- 소득자유형 -->  
    <t:ExtComboStore items="${COMBO_INDUS_CODE}" storeId="indusCodeList" />         <!--사업장-->
    <t:ExtComboStore items="${COMBO_DIV_CODE}" storeId="divCodeList" />             <!--사업장-->
    <t:ExtComboStore items="${COMBO_BUSINESS_AREA}" storeId="businessAreaList" />   <!--사업영역-->
    <t:ExtComboStore items="${COMBO_TAX_CD}" storeId="taxCdList" />                 <!--세금코드-->
    <t:ExtComboStore items="${COMBO_PAY_TERM_CD}" storeId="payTermCdList" />        <!--지급조건-->
    <t:ExtComboStore items="${COMBO_BANK_TYPE}" storeId="bankType" />               <!--입금계좌-->
    
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>    

</script><script type="text/javascript" charset="UTF-8" src='<c:url value="/resources/plupload/plupload.full.js" />' >
// ↑ 파일uplod용 plupload.full.js파일 include
</script>
<script type="text/javascript" >


var BsaCodeInfo = { 
	hiddenCheck_1: '${hiddenCheck_1}',
	hiddenCheck_2: '${hiddenCheck_2}',
	hiddenCheck_3: '${hiddenCheck_3}',
    hiddenCheck_4: '${hiddenCheck_4}',
    hiddenCheck_5: '${hiddenCheck_5}',
	
    paySysGubun: '${paySysGubun}'      // MIS , SAP 구분관련
};
var personName   = '${personName}';

// var getChargeCode = ${getChargeCode};
//
// if(getChargeCode == '' ){
// getChargeCode = [{"SUB_CODE":""}];
// }
var detailGridClickFlag = '';

var buttonFlag = '';

var preEmpNo = '';
var nxtEmpNo = '';
var transDesc = '';

var gsCustomCode   = '${gsCustomCode}';
var gsCustomName   = '${gsCustomName}';
var gsCompanyNum   = '${gsCompanyNum}';

var SAVE_FLAG = '';
var aaa = '안녕"';
var loadFlag = '';

var dateStFr = '';

function appMain() {
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 'aep150ukrService.selectDetailList',
            update: 'aep150ukrService.updateDetail',
            create: 'aep150ukrService.insertDetail',
            destroy: 'aep150ukrService.deleteDetail',
            syncAll: 'aep150ukrService.saveAll'
        }
    }); 
    
    var directButtonProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            create: 'aep150ukrService.insertButton',
            syncAll: 'aep150ukrService.saveButtonAll'
        }
    }); 
    
    var directProxyRequest = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            create: 'aep150ukrService.insertDetailRequest',
            syncAll: 'aep150ukrService.saveAllRequest'
        }
    }); 
    
    Unilite.defineModel('aep150ukrSearchModel', {
        fields: [
            {name: 'SELECT'               ,text: '선택'           , type: 'boolean'},
            {name: 'RNUM'                 ,text: 'NO'            ,type: 'string'},
            {name: 'SLIP_STAT_CD'         ,text: '전표상태'        ,type: 'string',comboType:'AU', comboCode:'J682'},
            {name: 'INVOICE_DATE'         ,text: '증빙일자'        ,type: 'uniDate'},
            {name: 'GL_DATE'              ,text: '회계일자'        ,type: 'uniDate'},
            {name: 'INVOICE_AMT'          ,text: '총금액'         ,type: 'uniPrice'},
            {name: 'VENDOR_NM'            ,text: '거래처'         ,type: 'string'},
            {name: 'SLIP_DESC'            ,text: '사용내역'        ,type: 'string'},
            {name: 'DEPT_NAME'            ,text: '작성부서'        ,type: 'string'},
            {name: 'REG_NM'               ,text: '작성자'         ,type: 'string'},
            {name: 'REG_DT2'              ,text: '작성일자'        ,type: 'uniDate'},
            {name: 'ELEC_SLIP_NO'         ,text: '관리번호'        ,type: 'string'}
        ]
    });
    
    
    Unilite.defineModel('aep150ukrDetailModel', {
        fields: [
            {name: 'ELEC_SLIP_NO'    ,text: '전표관리번호'       ,type: 'string'},
            {name: 'SEQ'             ,text: 'SEQ'            ,type: 'int'},
            {name: 'LINE_TYPE_CD'    ,text: '차변TAX구분'      ,type: 'string'}, 
            {name: 'DC_DIV_CD'       ,text: '유형'            ,type: 'string',comboType:'AU', comboCode:'J518'},
            {name: 'ACCT_CD'         ,text: '계정코드'         ,type: 'string',allowBlank:false},
            {name: 'ACCT_NM'         ,text: '계정명'          ,type: 'string'},
            {name: 'COST_DEPT_CD'    ,text: '귀속부서'         ,type: 'string',allowBlank:false},
            {name: 'COST_DEPT_NM'    ,text: '귀속부서명'        ,type: 'string'},
            {name: 'TAX_CD'          ,text: '세금'            ,type: 'string',store: Ext.data.StoreManager.lookup('taxCdList'),allowBlank:false},
            {name: 'DR_AMT_I'        ,text: '차변금액'         ,type: 'uniPrice',allowBlank:false},
            {name: 'CR_AMT_I'        ,text: '대변금액'         ,type: 'uniPrice'},
            {name: 'ITEM_DESC_USE'   ,text: '사용내역'         ,type: 'string',allowBlank:false},
            {name: 'ITEM_DESC'       ,text: '적요'            ,type: 'string',allowBlank:false},
            {name: 'PAY_TYPE'        ,text: '경비유형'         ,type: 'string'},
            {name: 'MAKE_SALE'       ,text: '원가구분'         ,type: 'string'},
            {name: 'PJT_CODE'        ,text: '사업코드'         ,type: 'string'},
            {name: 'PJT_NAME'        ,text: '사업명'           ,type: 'string'},
            {name: 'ORG_ACCNT'       ,text: '본계정'           ,type: 'string'},
            {name: 'ORG_ACCNT_NM'    ,text: '본계정명'          ,type: 'string'},
            {name: 'PAY_DATE'        ,text: '지급요청일'         ,type: 'uniDate'},
            {name: 'ITEM_CODE'       ,text: '제품코드'          ,type: 'string'},
            {name: 'ITEM_NAME'       ,text: '제품명'           ,type: 'string'},     
            
            {name: 'FILE_UPLOAD_FLAG'	,text: '파일업로드관련'           ,type: 'string'}

        ]
    });
    
    var buttonStore = Unilite.createStore('Aep150ukrButtonStore',{      
        uniOpt: {
            isMaster: false,            // 상위 버튼 연결
            editable: false,            // 수정 모드 사용
            deletable: false,           // 삭제 가능 여부
            useNavi : false         // prev | newxt 버튼 사용
        },
        proxy: directButtonProxy,
        saveStore: function() {             
            var inValidRecs = this.getInvalidRecords();
// var toCreate = branchStore.data.items;
            var toCreate = this.getNewRecords();
            var toUpdate = this.getUpdatedRecords();                
            var toDelete = this.getRemovedRecords();
// var paramList = branchStore.data.items;
            var paramMaster = searchForm.getValues();   
            
            paramMaster.buttonFlag = buttonFlag;
            
            if(buttonFlag == 'btnConf'){
            	
            	paramMaster.preEmpNo = preEmpNo;
                paramMaster.nxtEmpNo = nxtEmpNo;
                paramMaster.transDesc = transDesc;
            }
            
// param.FR_INPUT_DATE =
// UniDate.getDbDateStr(panelSearch.getValue('FR_INPUT_DATE'));
            if(inValidRecs.length == 0) {
                config = {
                    params: [paramMaster],
                    success: function(batch, option) {
                        var master = batch.operations[0].getResultSet();
                        
                        UniAppManager.app.onQueryButtonDown();
                        buttonStore.clearData();
                        buttonFlag = '';
                        preEmpNo = '';
                        nxtEmpNo = '';
                        transDesc = '';
                     },
                     failure: function(batch, option) {
                        buttonStore.clearData();
                        buttonFlag = '';
                        preEmpNo = '';
                        nxtEmpNo = '';
                        transDesc = '';
                        
                     }
                };
                this.syncAllDirect(config);
            } else {
                var grid = Ext.getCmp('aep150ukrSearchGrid');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
        },
        listeners: {
            load: function(store, records, successful, eOpts) {
            },
            add: function(store, records, index, eOpts) {
            },
            update: function(store, record, operation, modifiedFieldNames, eOpts) {
            },
            remove: function(store, record, index, isMove, eOpts) {
            }
        }
    });

    var requestStore = Unilite.createStore('Aep150ukrRequestStore',{      
        uniOpt: {
            isMaster: false,            // 상위 버튼 연결
            editable: false,            // 수정 모드 사용
            deletable: false,           // 삭제 가능 여부
            useNavi : false         // prev | newxt 버튼 사용
        },
        proxy: directProxyRequest,
        saveStore: function() {             
            
            var paramMaster = searchForm.getValues(); 
// param.FR_INPUT_DATE =
// UniDate.getDbDateStr(panelSearch.getValue('FR_INPUT_DATE'));
            config = {
                params: [paramMaster],
                success: function(batch, option) {
                    var master = batch.operations[0].getResultSet();
                    
                    var gwKeyValue = master.GW_KEY_VALUE;
                    
                 
                    var requestRecords = requestStore.data.items;
                    
                    var mercNmStr = '';     //사용내역 관련
               
                    var aquiSumStr = 0;     //지급액 관련
      
                    Ext.each(requestRecords, function(record,j){
                        if(j == 0){
                            mercNmStr = record.get('VENDOR_NM');
                        }
                        aquiSumStr = aquiSumStr + record.get('INVOICE_AMT');
                        
                    });
                    if(requestRecords.length > 1){
                        mercNmStr = mercNmStr + " 외 " + (requestRecords.length-1) + "건";
                    }else{
                        mercNmStr = mercNmStr;
                    }
                    
                    var apprDateFr = '';
                    var apprDateTo = '';
                    
                    if(Ext.isEmpty(searchForm.getValue('INVOICE_DATE_FR'))){
                        apprDateFr = '';
                    }else{
                        apprDateFr = UniDate.getDbDateStr(searchForm.getValue('INVOICE_DATE_FR'));
                        apprDateFr = apprDateFr.substring(0,4) + '.' + apprDateFr.substring(4,6) + '.' + apprDateFr.substring(6,8);
                    }
                    if(Ext.isEmpty(searchForm.getValue('INVOICE_DATE_TO'))){
                        apprDateTr = '';
                    }else{
                        apprDateTr = UniDate.getDbDateStr(searchForm.getValue('INVOICE_DATE_TO'));
                        apprDateTr = apprDateTr.substring(0,4) + '.' + apprDateTr.substring(4,6) + '.' + apprDateTr.substring(6,8);
                    }
                    var useDate =  apprDateFr + ' ~ ' +  apprDateTr
                    
                    
                    
                    var winWidth=1000;
                    var winHeight=600;
                    
                    var scrW=screen.availWidth;
                    var scrH=screen.availHeight;
                    
                    var positionX=(scrW-winWidth)/2;
                    var positionY=(scrH-winHeight)/2;

                    var gsWin = window.open('about:blank','cardviewer','left='+positionX+',top='+positionY+',width='+winWidth+',height='+winHeight+'');
                    var requestMsg = '<?xml version="1.0" encoding="euc-kr" ?>';
                    requestMsg = requestMsg + '<aprv APPID="WF_COST_MIS_REQ">';
                    requestMsg = requestMsg + '<item>';
                    requestMsg = requestMsg + '<apprManageNo>'+ gwKeyValue + '</apprManageNo>';
                    requestMsg = requestMsg + '<subject>'+ '경비처리 원천세 결재' +'</subject>';
                    requestMsg = requestMsg + '</item>';
                    requestMsg = requestMsg + '<content><![CDATA[';
                    requestMsg = requestMsg + '<table style="border-collapse:collapse; border:1px gray solid; margin:20px 0 20px 0; word-break:break-all;" width= "100%" align="center">';
                    requestMsg = requestMsg + '<tr style="border:1px gray solid;padding: 5px 10px;">';
                    
                    requestMsg = requestMsg + '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6" height= "20", width = "25%">';
                    requestMsg = requestMsg + '증빙일자';
                    requestMsg = requestMsg + '</th>';
                    requestMsg = requestMsg + '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6", width = "35%">';
                    requestMsg = requestMsg + '내용';
                    requestMsg = requestMsg + '</th>';
                    requestMsg = requestMsg + '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6", width = "20%">';
                    requestMsg = requestMsg + '지급액';
                    requestMsg = requestMsg + '</th>';
                    requestMsg = requestMsg + '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6", width = "20%">';
                    requestMsg = requestMsg + '상세리스트보기';
                    requestMsg = requestMsg + '</th>';
                    requestMsg = requestMsg + '</tr>';
                    
                    requestMsg = requestMsg + '<tr style="border:1px gray solid;padding: 5px 10px;">';
                    requestMsg = requestMsg + '<td style="border:1px gray solid;padding: 5px 10px;">';
                    requestMsg = requestMsg + useDate;
                    requestMsg = requestMsg + '</td>';
                    requestMsg = requestMsg + '<td style="border:1px gray solid;padding: 5px 10px; ">';
                    requestMsg = requestMsg + mercNmStr;
                    requestMsg = requestMsg + '</td>';
                    requestMsg = requestMsg + '<td style="border:1px gray solid;padding: 5px 10px;" align="right">';
                    requestMsg = requestMsg + Ext.util.Format.number(aquiSumStr,'0,000') + ' 원';
                    requestMsg = requestMsg + '</td>';
                    requestMsg = requestMsg + '<td style="border:1px gray solid;padding: 5px 10px;" align="center">';
                    requestMsg = requestMsg + '<p><a target="_blank" style="color: blue; text-decoration:underline" href="'+ CHOST + CPATH + '/jbill/req/req100skr.do?COMP_CODE='+ UserInfo.compCode + '&KEY_VALUE='+gwKeyValue+'">' + "상세리스트" + '</a></p>';
                    requestMsg = requestMsg + '</td>';
                    requestMsg = requestMsg + '</tr>';
                    requestMsg = requestMsg + '</table>';
                    requestMsg = requestMsg + ']]></content>';
                    requestMsg = requestMsg + '</aprv>';
                    
                    console.log(requestMsg);
                    document.getElementById("fmbd").value = requestMsg;
                    
                    var frm = document.f1;
                    frm.action = "http://ep.joinsdev.net/WebSite/Approval/FormLinkForLEGACY.aspx";
                    frm.target ="cardviewer";
                    frm.method ="post";
                    frm.submit();
                    
//                    if(confirm("결재팝업을 오픈하였습니다.\n기안을 완료 하신 후,\n확인을 눌러주세요.\n재조회 합니다.")) { 
//                        UniAppManager.app.onQueryButtonDown();
//                            
//                    }else{
//                        return false;
//                    }
                    
                },
                failure: function(batch, option) {
                 
                    
                }
            };
            this.syncAllDirect(config);
        }
    });
    
    
    var directSearchStore = Unilite.createStore('aep150ukrSearchStore', {
        model: 'aep150ukrSearchModel',
        uniOpt: {
            isMaster: false,         // 상위 버튼 연결
            editable: false,            // 수정 모드 사용
            deletable: false,           // 삭제 가능 여부
            allDeletable:false,
            useNavi : false         // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {
                read: 'aep150ukrService.selectSearchList'                 
            }
        },
        
        listeners: {
            load: function(store, records, successful, eOpts) {
            	/*if(store.count() == 0) { 
                	detailGrid.disable(true);
                	fileUploadForm.down('#uploadDisabled').disable();
            	}else{
            		detailGrid.enable(true);
            		fileUploadForm.down('#uploadDisabled').enable();
            	}*/
            },
            add: function(store, records, index, eOpts) {
            },
            update: function(store, record, operation, modifiedFieldNames, eOpts) {
            },
            remove: function(store, record, index, isMove, eOpts) {
            }
        },
        loadStoreRecords: function(){
            var param= Ext.getCmp('searchForm').getValues();
            console.log( param );
            this.load({
                params: param
            });
        }
    }); 
    
    var directDetailStore = Unilite.createStore('aep150ukrDetailStore', {
        model: 'aep150ukrDetailModel',
        uniOpt: {
            isMaster: true,         // 상위 버튼 연결
            editable: true,         // 수정 모드 사용
            deletable: false,           // 삭제 가능 여부
            allDeletable:false,
            useNavi : false         // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
        saveStore: function() {             
            var inValidRecs = this.getInvalidRecords();
            console.log("inValidRecords : ", inValidRecs);
            var toCreate = this.getNewRecords();
            var toUpdate = this.getUpdatedRecords();                
            var toDelete = this.getRemovedRecords();
            var list = [].concat(toUpdate, toCreate);
            console.log("list:", list);
            var paramMaster= masterForm.getValues();   
            paramMaster.BANK_TYPE = masterForm.getField("BANK_TYPE").rawValue;
    // paramMaster. = masterForm.getField("").rawValue;//원천세유형 추가필요
            if(directDetailStore.data.items.length > 0){
                paramMaster.SLIP_DESC = directDetailStore.data.items[0].data.ITEM_DESC_USE;
            }
// paramMaster.GL_DATE = masterForm.getValue('GL_DATE');
// paramMaster.ELEC_SLIP_NO = masterForm.getValue('ELEC_SLIP_NO');
// paramMaster.GLOBAL_ATTRIBUTE2 = masterForm.getValue('GLOBAL_ATTRIBUTE2');
// paramMaster.GLOBAL_ATTRIBUTE3 = masterForm.getValue('GLOBAL_ATTRIBUTE3');
// paramMaster.INVOICE_AMT = masterForm.getValue('INVOICE_AMT');
// paramMaster.ATTRIBUTE2 = masterForm.getValue('ATTRIBUTE2');
            
            
            if(inValidRecs.length == 0) {
                config = {
                    params: [paramMaster],
                    success: function(batch, option) {
                        var master = batch.operations[0].getResultSet();
                        
                        masterForm.setValue("ELEC_SLIP_NO", master.ELEC_SLIP_NO);
                        masterForm.setValue("FILE_NO", master.ELEC_SLIP_NO);
                        
                        if(masterForm.getValue('ELEC_SLIP_NO') != ''){
                            directDetailStore.loadStoreRecords(); 
                        	if(BsaCodeInfo.paySysGubun == '1'){
                                masterForm.getForm().getFields().each(function(field) {
                                    field.setReadOnly(true);
                                });
                            }
                            
                        }else{
                             UniAppManager.app.setMasterDefault();	
                        }
                        
                        UniAppManager.app.fileUploadLoad();
                        UniAppManager.setToolbarButtons('save', false);     
                     } 
                };
                this.syncAllDirect(config);
            } else {
                var grid = Ext.getCmp('aep150ukrDetailGrid');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
        },
        
        listeners: {
            load: function(store, records, successful, eOpts) {
            	UniAppManager.app.fnAcctAmtChange1();
            },
            add: function(store, records, index, eOpts) {
            },
            update: function(store, record, operation, modifiedFieldNames, eOpts) {
            },
            remove: function(store, record, index, isMove, eOpts) {
            }
        },
        loadStoreRecords: function(){
            var param= Ext.getCmp('masterForm').getValues();
            console.log( param );
            this.load({
                params: param
            });
        }
    });
    
    
    
    var searchForm = Unilite.createForm('searchForm',{
        region: 'north',
        layout : {type : 'uniTable', columns : 3
// tableAttrs: { /*style: 'border : 1px solid #ced9e7;',*/width: '100%'}
// tdAttrs: {/*style: 'border : 1px solid #ced9e7;',*/width: '100%'/*,align :
// 'left'*/}
        },
        padding:'1 1 1 1',
        disabled:false,
        items: [{
            fieldLabel: '전표유형',
            name:'ELEC_SLIP_TYPE_CD',  
            xtype: 'uniCombobox',
            comboType:'AU',
            comboCode:'J647',
            hidden:true
        },{
            xtype: 'uniDateRangefield',
            fieldLabel: '증빙일자',
            startFieldName: 'INVOICE_DATE_FR',
            endFieldName: 'INVOICE_DATE_TO',
            allowBlank:false
        },
        Unilite.popup('DEPT',{ 
            fieldLabel: '작성부서', 
            valueFieldName: 'DEPT_CODE',
            textFieldName: 'DEPT_NAME',
            autoPopup:true,
            listeners: {
                onSelected: {
                    fn: function(records, type) {
                    },
                    scope: this
                },
                onClear: function(type) {
                }
            }
        }), 
        {
            xtype: 'container',
            layout: {type : 'uniTable', columns : 2},
            items :[
            Unilite.popup('Employee',{
                fieldLabel: '작성자', 
                valueFieldWidth: 90,
                textFieldWidth: 140,
                valueFieldName:'PERSON_NUMB',
                textFieldName:'NAME',
                readOnly:true,
                listeners: {
                    onSelected: {
                        fn: function(records, type) {
                            searchForm.setValue('PERSON_DEPT_NAME', records[0].DEPT_NAME);
                        },
                        scope: this
                    },
                    onClear: function(type) {
                        searchForm.setValue('PERSON_DEPT_NAME', '');
                    }
                }
            }),
            {
                xtype: 'uniTextfield',
                fieldLabel:'',
                name: 'PERSON_DEPT_NAME',
                width:140,
                readOnly:true
            }]
        },{
            xtype: 'uniDateRangefield',
            fieldLabel: '회계일자',
            startFieldName: 'GL_DATE_FR',
            endFieldName: 'GL_DATE_TO'
        },{
            xtype:'uniTextfield',
            fieldLabel:'전표번호',
            name:'ELEC_SLIP_NO'
        },{
            xtype:'uniTextfield',
            fieldLabel:'거래처',
            name:'VENDOR_NM'
        },{
            xtype: 'uniDateRangefield',
            fieldLabel: '작성일자',
            startFieldName: 'INSERT_DB_TIME_FR',
            endFieldName: 'INSERT_DB_TIME_TO'
        },{
            fieldLabel: '진행상태',
            name:'SLIP_STAT_CD',  
            xtype: 'uniCombobox',
            comboType:'AU',
            comboCode:'J682'
        }]
    });
    
    var masterForm = Unilite.createForm('masterForm',{
// split:true,
// title:'기본사항',
// flex:0.9,
        region: 'north',
        layout : {type : 'uniTable', columns : 2
// tableAttrs: { /*style: 'border : 1px solid #ced9e7;',*/width: '100%'},
// tdAttrs: {style: 'border : 1px solid #ced9e7;',width: '100%'/*,align :
// 'left'*/}
    
        },
        padding:'1 1 1 1',
// border:true,
        disabled:false,
        items: [{
            xtype:'component',
            html:'[기본사항]',
            componentCls : 'component-text_green',
            tdAttrs: {align : 'left'},
            width: 150,
            colspan:2
        },{
            xtype: 'component',
            width: 10
        },{
            title: '',
            xtype: 'fieldset',
            id: 'fieldset1',
            padding: '10 10 10 10',
            margin: '0 0 0 0',
            width:1125,
            defaults: {xtype: 'uniTextfield'},
            layout: {type: 'uniTable' , columns: 3
// ,tdAttrs: {style: 'border : 1px solid #ced9e7;'}
            },
            items: [{ 
                xtype: 'uniDatefield',
                fieldLabel: '증빙일자',
                    labelWidth:110,
                name: 'INVOICE_DATE',
                value: UniDate.get('today'),
                allowBlank: false
            },{ 
                xtype: 'uniDatefield',
                fieldLabel: '회계일자',
                name: 'GL_DATE',
                value: UniDate.get('today'),
                allowBlank: false
            },{
                xtype: 'uniTextfield',
                fieldLabel:'전표번호', 
                name: 'ELEC_SLIP_NO', 
// labelWidth:168,
                readOnly:true
            },{
                xtype: 'container',
                layout: {type : 'uniTable', columns : 2},
                width:455,
// colspan:2,
    // padding:'10 10 0 10',
                items :[
                Unilite.popup('CUST',{
                    fieldLabel: '지급처', 
                    labelWidth:110,
    // labelAlign : "top",
    // labelWidth:150,
                    valueFieldWidth: 90,
                    textFieldWidth: 140,
                    valueFieldName:'VENDOR_ID',
                    textFieldName:'VENDOR_NM',
                    allowBlank:false,
    // readOnly:true,
                    listeners: {
                        onSelected: {
                            fn: function(records, type) {
                                masterForm.setValue('VENDOR_SITE_CD', records[0].COMPANY_NUM);
                            },
                            scope: this
                        },
                        onClear: function(type) {
                            masterForm.setValue('VENDOR_SITE_CD', '');
                        },
                        applyextparam: function(popup){
                            popup.setExtParam({'ADD_QUERY': "ISNULL(A.VENDOR_GROUP_CODE,'')!='V090'"});                           
                        }
                    }
                }),
                {
                    xtype: 'uniTextfield',
                    fieldLabel:'',
    // labelAlign : "top",
                    name: 'VENDOR_SITE_CD',
                    width:110,
                    readOnly:true
                }]
            },{
                xtype: 'container',
                layout: {type : 'uniTable', columns : 1},
                width:402,
                items :[{
                    xtype: 'uniCombobox',
                    fieldLabel: '입금계좌',
                    id:'bankType',
                    name:'BANK_TYPE',  
                    allowBlank:false,
                    store: Ext.data.StoreManager.lookup('bankType'),
                    hidden:false,
                    width:325,
                    valueField: 'text',
                    displayField: 'value',
    // pickerWidth: 100,
        // allowBlank:false
                    listeners:{
                        beforequery:function( queryPlan, eOpts )   {
                        var store = queryPlan.combo.store;
                        store.clearFilter();
                        if(!Ext.isEmpty(masterForm.getValue('VENDOR_ID'))){
                            store.filterBy(function(record){
                                return record.get('option') == masterForm.getValue('VENDOR_ID');
                            })
                        }else{
                            store.filterBy(function(record){
                                return false;   
                            })
                        }
                    }
                    
              // searchForm.getField("BANK_TYPE").rawValue; ==> value값으로 써야함
        // afterrender: function(combo) {
        // var recordSelected = combo.getStore().getAt(0);
        // combo.setValue(recordSelected.get('value'));
        // }
                    }
                }]
            },{
                xtype: 'uniCombobox',
                fieldLabel: '결재상태', 
                name:'SLIP_STAT_CD',   
                comboType:'AU',
                comboCode:'J682',
                readOnly:true
            },{
                xtype: 'uniCombobox',
                fieldLabel: '원천세유형',
                labelWidth:110,
                name:'INCOME_TAX_ATTRIBUTE13',   
                comboType:'AU',
                comboCode:'J699',
                allowBlank:false,
                width:455,
                listeners:{
                    change: function(field, newValue, oldValue, eOpts) {
                    	masterForm.setValue('ATTRIBUTE5','');
                    	masterForm.setValue('ATTRIBUTE6','');
                    	masterForm.setValue('ATTRIBUTE7','');
                    	masterForm.setValue('ATTRIBUTE8','');
                    	
                    	masterForm.setValue('INVOICE_AMT','');
                        masterForm.setValue('INCOME_TAX_ACCT_AMT','');
                        masterForm.setValue('RSD_TAX_ACCT_AMT','');
                        masterForm.setValue('CREDIT_ACCT_AMT','');
                    	
                    	
                    	if(newValue == '03_K1'){
                    	   	masterForm.down("#incomeTaxOpt1").enable(true);
                    	   	masterForm.down("#incomeTaxOpt2").enable(true);
                    	   	masterForm.down("#incomeTaxOpt3").enable(true);
                    	   	masterForm.getField("ATTRIBUTE5").setConfig('allowBlank',false);
                    	   	masterForm.getField("ATTRIBUTE6").setConfig('allowBlank',false);
                    	   	masterForm.getField("ATTRIBUTE7").setConfig('allowBlank',false);
                    	   	masterForm.getField("ATTRIBUTE8").setConfig('allowBlank',false);
                    		
                    	}else{
                    	    masterForm.down("#incomeTaxOpt1").disable(true);
                    	    masterForm.down("#incomeTaxOpt2").disable(true);    
                    	    masterForm.down("#incomeTaxOpt3").disable(true);    
                    	    masterForm.getField("ATTRIBUTE5").setConfig('allowBlank',true);
                            masterForm.getField("ATTRIBUTE6").setConfig('allowBlank',true);
                            masterForm.getField("ATTRIBUTE7").setConfig('allowBlank',true);
                            masterForm.getField("ATTRIBUTE8").setConfig('allowBlank',true);
                    	}
                    }
                }
    // value:'0',
            },{
                xtype: 'uniCombobox',
                fieldLabel: '소득자유형',
                name:'INCOME_TAX_ATTRIBUTE12', 
                allowBlank:false, 
                comboType:'AU',
                comboCode:'J650'
            },{
                xtype: 'container',
                layout: {type : 'uniTable', columns : 1},
                items :[{ 
                    xtype: 'uniDatefield',
                    fieldLabel: '지급요청일', 
// labelWidth:168,
                    id:'payDate',
                    name: 'PAY_DATE',
                    value: UniDate.get('today'),
                    allowBlank: false,
                    hidden:true
                }]
            },{
            	
                xtype: 'container',
// layout: {type : 'uniTable', columns : 2},
                layout: {type : 'hbox'},
                width:1000,
// itemId:'incomeTaxOpt',
                colspan:3,
                items :[{
                    xtype: 'container',
// layout: {type : 'uniTable', columns : 2},
                    layout: {type : 'hbox'},
                    width:455,
// width:540,
    // colspan:2,
        // padding:'10 10 0 10',
                    items :[{
                        xtype: 'uniNumberfield',
                        itemId:'incomeTaxOpt1',
                        fieldLabel:'일당/일수',
                        labelWidth:110,
                        name: 'ATTRIBUTE7',
                        disabled:true,
                        listeners:{
                            change: function(field, newValue, oldValue, eOpts) {
                            	masterForm.setValue('INVOICE_AMT', newValue * masterForm.getValue('ATTRIBUTE8'));
                            	
                            	UniAppManager.app.fnTaxCalc();
                            	
                            	
                                UniAppManager.app.fnAcctAmtChange1();
                            }
                        }
                    },{
                        xtype: 'uniNumberfield',
                        itemId:'incomeTaxOpt2',
                        fieldLabel:'',
                        name: 'ATTRIBUTE8',
                        disabled:true,
                        listeners:{
                            change: function(field, newValue, oldValue, eOpts) {
                                masterForm.setValue('INVOICE_AMT', newValue * masterForm.getValue('ATTRIBUTE7'));
                                
                                UniAppManager.app.fnTaxCalc();
                                
                                
                                UniAppManager.app.fnAcctAmtChange1();
                            }
                        }
                    }]
               },{
                    xtype: 'uniDateRangefield',
                    itemId:'incomeTaxOpt3',
                    fieldLabel: '시작/종료일자',
                    startFieldName: 'ATTRIBUTE5',
                    endFieldName: 'ATTRIBUTE6',
                    disabled:true,
                    onStartDateChange: function(field, newValue, oldValue, eOpts) {
                        if(!Ext.isEmpty(masterForm.getValue('ATTRIBUTE6'))){
                        	UniAppManager.app.fnDateCalc();
                        }
                    },
                    onEndDateChange: function(field, newValue, oldValue, eOpts) {
                        if(!Ext.isEmpty(masterForm.getValue('ATTRIBUTE5'))){
                            UniAppManager.app.fnDateCalc();
                        }
                    }
                }]
            },
            Unilite.popup('Employee',{
                fieldLabel: '신청자', 
                valueFieldWidth: 90,
                textFieldWidth: 140,
                valueFieldName:'APPLICANT_ID',
                textFieldName:'APPLICANT_NAME',
                allowBlank: false,
                labelWidth:110,
                listeners: {
                    onSelected: {
                        fn: function(records, type) {
                            detailForm.setValue('COST_DEPT_CD', records[0].DEPT_CODE);
                            detailForm.setValue('COST_DEPT_NM', records[0].DEPT_NAME);
                            
                            var param = {
                                "COST_DEPT_CD": records[0].DEPT_CODE
                            };
                                
                            accntCommonService.setMakeSale_J(param, function(provider, response)   {
                                if(!Ext.isEmpty(provider)){
                                    detailForm.setValue('MAKE_SALE',provider.MAKE_SALE);
                                }else{
                                    detailForm.setValue('MAKE_SALE','');    
                                }
                            })
                        },
                        scope: this
                    },
                    onClear: function(type) {
                            detailForm.setValue('COST_DEPT_CD', '');
                            detailForm.setValue('COST_DEPT_NM', '');
                    }
//			                onValueFieldChange: function(field, newValue){
//		                            detailForm.setValue('COST_DEPT_CD', records[0].DEPT_CODE);
//		                            detailForm.setValue('COST_DEPT_NM', records[0].DEPT_NAME);
//			                },
//			                onTextFieldChange: function(field, newValue){
//			                }
                }
            }),{
                xtype: 'uniNumberfield',
                fieldLabel:'총금액',
                name: 'INVOICE_AMT',
                allowBlank:false,
                listeners:{
                    change: function(field, newValue, oldValue, eOpts) {
                    	
                    	UniAppManager.app.fnTaxCalc();
                    	
                        UniAppManager.app.fnAcctAmtChange1();
                    	
// masterForm.setValue('CREDIT_ACCT_AMT',newValue);
                    	
                    	/*
						 * var detailData = directDetailStore.data.items;
						 * 
						 * if(Ext.getCmp('evdeTypeCd').getValue().EVDE_TYPE_CD !=
						 * '60'){ if(masterForm.getValue('TAX_CD') != 'NA' ){
						 * 
						 * if(newValue > 0){
						 * masterForm.setValue('ATTRIBUTE2',Math.floor(newValue /
						 * 11)); } } }
						 * 
						 * if(detailData.length > 0){
						 * 
						 * var drAmtISum = 0;
						 * 
						 * Ext.each(detailData, function(record,i){ drAmtISum =
						 * drAmtISum + record.get('DR_AMT_I'); });
						 * 
						 * detailForm.setValue('ACCT_AMT',newValue - drAmtISum); }
						 */
                    }
                }
                
            },{
                xtype: 'uniNumberfield',
                fieldLabel:'소득세',
                name: 'INCOME_TAX_ACCT_AMT',
                readOnly:true
//                colspan:2
            },{
            	xtype: 'component'
            },{
                xtype: 'uniNumberfield',
                fieldLabel:'실지급액',
//                labelWidth:110,
                name: 'CREDIT_ACCT_AMT',
                readOnly:true,
                listeners:{
                    change: function(field, newValue, oldValue, eOpts) {
                    }
                }
            },{
                xtype: 'uniNumberfield',
                fieldLabel:'지방세',
                name: 'RSD_TAX_ACCT_AMT',
                readOnly:true
//                colspan:2
            },{
                xtype: 'uniCombobox',
                fieldLabel: '사업장',
                labelWidth:110,
                id:'globalAttribute2',
                name:'GLOBAL_ATTRIBUTE2', 
                store: Ext.data.StoreManager.lookup('indusCodeList'),
                hidden:false,
                listeners:{
                    afterrender: function(combo) {
                    	if(!Ext.isEmpty(combo.getStore().data.items)){
                            var recordSelected = combo.getStore().getAt(0);                     
                            combo.setValue(recordSelected.get('value'));
                    	}
                    }
                }
            },{
                xtype: 'uniCombobox',
                fieldLabel: '사업영역',
                id:'globalAttribute3',
                name:'GLOBAL_ATTRIBUTE3',  
                store: Ext.data.StoreManager.lookup('businessAreaList'),
                hidden:false,
    // allowBlank:false,
                listeners:{
                    afterrender: function(combo) {
                    	if(!Ext.isEmpty(combo.getStore().data.items)){
                            var recordSelected = combo.getStore().getAt(0);                     
                            combo.setValue(recordSelected.get('value'));
                    	}
                    }
                }
            },{
                xtype: 'uniCombobox',
                fieldLabel: '섹션코드',     
                id:'temp1code',                 //추후 재정의
                name:'TEMP1CODE',  
//                store: Ext.data.StoreManager.lookup('businessAreaList'),
                hidden:false,
    // allowBlank:false,
                colspan:2,
                listeners:{
                    afterrender: function(combo) {
                        if(!Ext.isEmpty(combo.getStore().data.items)){
                            var recordSelected = combo.getStore().getAt(0);                     
                            combo.setValue(recordSelected.get('value'));
                        }
                    }
                }
            },{
                xtype: 'uniCombobox',
                fieldLabel: '지급조건',
                labelWidth:110,
                id:'payTermsCd',
                name:'PAY_TERMS_CD', 
                allowBlank:false,
                store: Ext.data.StoreManager.lookup('payTermCdList'),
                hidden:false
    // listeners:{
    // afterrender: function(combo) {
    // var recordSelected = combo.getStore().getAt(0);
    // combo.setValue(recordSelected.get('value'));
    // }
    // }
                
    // allowBlank:false
    // visible:false
                
                
    // setVisible(false)
            },{
                xtype: 'uniCombobox',
                fieldLabel: '지급방법',
                id:'payMetoCd',
                name:'PAY_METO_CD', 
                allowBlank:false, 
                comboType:'AU',
                comboCode:'J668',
    // store: Ext.data.StoreManager.lookup('businessAreaList'),
                hidden:false,
    // allowBlank:false,
                colspan:2,
                listeners:{
                    beforequery:function( queryPlan, eOpts )   {
                        var store = queryPlan.combo.store;
                        store.clearFilter();
                        if(!Ext.isEmpty(masterForm.getValue('PAY_TERMS_CD'))){
                            store.filterBy(function(record){
                                return record.get('value') == masterForm.getField("PAY_TERMS_CD").selection.data.option;
                            })
                        }else{
                            store.filterBy(function(record){
                                return false;   
                            })
                        }
                    }
    // afterrender: function(combo) {
    // var recordSelected = combo.getStore().getAt(0);
    // combo.setValue(recordSelected.get('value'));
    // }
                }
            },{
                xtype		: 'uniTextfield',
                fieldLabel	: 'FILE_NO',          
                name		: 'FILE_NO',
                value		: '',                		//임시 파일 번호
                readOnly	: true,
                hidden		: true
            } ,{
                xtype		: 'uniTextfield',
                fieldLabel	: '삭제파일FID',		       //삭제 파일번호를 set하기 위한 hidden 필드
                name		: 'DEL_FID',
                readOnly	: true,
                hidden		: true
            },{
                xtype		: 'uniTextfield',
                fieldLabel	: '등록파일FID',		       //등록 파일번호를 set하기 위한 hidden 필드
                name		: 'ADD_FID',
                width		: 500,
                readOnly	: true,
                hidden		: true
            }]
        }],
        api: {
            load: 'aep150ukrService.selectMasterForm'  
        }
    });
    
    
    var detailForm = Unilite.createForm('resultForm',{
    	masterGrid: detailGrid,
// flex:0.8,
// split:true,
// title:'경비내역',
        region: 'north',
        layout : {type : 'uniTable', columns : 2
// tableAttrs: { /*style: 'border : 1px solid #ced9e7;',*/width: '100%'}
// tdAttrs: {/*style: 'border : 1px solid #ced9e7;',*/width: '100%'/*,align :
// 'left'*/}
    
        },
        padding:'1 1 1 1',
// border:true,
        disabled:false,
        items: [{
            xtype:'component',
            html:'[경비내역]',
            componentCls : 'component-text_green',
            tdAttrs: {align : 'left'},
            width: 150,
            colspan:2
        },{
            xtype: 'component',
            width: 10
        },{
            title: '',
            xtype: 'fieldset',
            id: 'fieldset2',
            padding: '10 10 10 10',
            margin: '0 0 0 0',
            defaults: {xtype: 'uniTextfield'},
            layout: {type: 'uniTable' , columns: 3
// tdAttrs: {style: 'border : 1px solid #ced9e7;'}
            },
            items: [{
                xtype: 'uniCombobox',
                fieldLabel: '경비유형',
                    labelWidth:110, 
                id:'payType',
                name:'PAY_TYPE',   
                comboType:'AU',
                comboCode:'A177',
                width:325,
                hidden:true,
                listeners:{
                    change: function(field, newValue, oldValue, eOpts) {
                        if(detailGridClickFlag != 'Y'){
                            
                            if(!Ext.isEmpty(newValue) && !Ext.isEmpty(detailForm.getValue('MAKE_SALE'))){   
                                var param = {
                                    "PAY_TYPE": newValue,
                                    "MAKE_SALE": detailForm.getValue('MAKE_SALE')
                                };
                                
                                UniAppManager.app.fnSelectAccntData(param);
                            }
                        }
                    }
                }
            },{
                xtype: 'uniCombobox',
                fieldLabel: '원가구분',
                id:'makeSale',
                name:'MAKE_SALE',   
                comboType:'AU',
                comboCode:'A006',
                hidden:true,
                colspan:2,
                listeners:{
                    change: function(field, newValue, oldValue, eOpts) {  
                        if(detailGridClickFlag != 'Y'){
                            if(!Ext.isEmpty(newValue) && !Ext.isEmpty(detailForm.getValue('PAY_TYPE'))){  
                            
                                var param = {
                                    "PAY_TYPE": detailForm.getValue('PAY_TYPE'),
                                    "MAKE_SALE": newValue
                                };
                                UniAppManager.app.fnSelectAccntData(param);
                            }
                        }
                    }
                }
            },{
                xtype: 'container',
                layout: {type : 'uniTable', columns : 1},
                width:455,
                items :[
                Unilite.popup('DEPT',{ 
                    fieldLabel: '귀속부서', 
                    labelWidth:110,
                    valueFieldName: 'COST_DEPT_CD',
                    textFieldName: 'COST_DEPT_NM',
                    autoPopup:true,
                    allowBlank:false,
                    listeners: {
                        onSelected: {
                            fn: function(records, type) {
                                detailForm.setValue('ITEM_DESC',UniDate.getDbDateStr(masterForm.getValue('GL_DATE')) + 
                                                    '_' + detailForm.getValue('COST_DEPT_NM') + '_' + detailForm.getValue('ACCT_NM'));
                                                    
                                if(!Ext.isEmpty(detailForm.getValue('ACCT_CD')) && !Ext.isEmpty(detailForm.getValue('COST_DEPT_CD'))){  
                                    var param2 = {
                                        "BUDG_YYYYMM": UniDate.getDbDateStr(masterForm.getValue('GL_DATE')),
                                        "ACCNT": detailForm.getValue('ACCT_CD'),
                                        "DEPT_CODE": detailForm.getValue('COST_DEPT_CD')
                                    };
                                    UniAppManager.app.fnPossibleBudgAmt110(param2);
                                }   
                                var param = {
                                    "COST_DEPT_CD": detailForm.getValue('COST_DEPT_CD')
                                };
                                    
                                accntCommonService.setMakeSale_J(param, function(provider, response)   {
                                    if(!Ext.isEmpty(provider)){
                                        detailForm.setValue('MAKE_SALE',provider.MAKE_SALE);
                                    }else{
                                        detailForm.setValue('MAKE_SALE','');    
                                    }
                                })
                            },
                            scope: this
                        },
                        onClear: function(type) {
                            detailForm.setValue('ITEM_DESC','');
                            detailForm.setValue('AMTBG',0);
                            detailForm.setValue('AMTRM',0);
                        }
                    }
                })]
            }, 
            Unilite.popup('ACCNT',{
                fieldLabel: '계정코드', 
                valueFieldWidth: 90,
                textFieldWidth: 140,
                valueFieldName:'ACCT_CD',
                textFieldName:'ACCT_NM',
                autoPopup:true,
                allowBlank:false,
    // validateBlank:'text',
                listeners: {
                	onSelected: {
                        fn: function(records, type) {
                        	var param = {
                                "ACCT_CD": detailForm.getValue('ACCT_CD')
                            };
                            aep150ukrService.selectAccntYnData(param, function(provider, response)   {
                                if(!Ext.isEmpty(provider)){   
                                
                                    if(BsaCodeInfo.hiddenCheck_3 == 'Y'){
                                        if(provider[0].PJT_CODE_YN == 'Y'){
                                            detailForm.getField("PJT_CODE").setConfig('allowBlank',false);                                                 
                                        }else{
                                            detailForm.getField("PJT_CODE").setConfig('allowBlank',true);
                                        }
                                    }else{
                                        detailForm.getField("PJT_CODE").setConfig('allowBlank',true);
                                    }
                                    if(BsaCodeInfo.hiddenCheck_4 == 'Y'){
                                        if(provider[0].ORG_ACCNT_YN == 'Y'){
                                            detailForm.getField("ORG_ACCNT").setConfig('allowBlank',false);                                                 
                                        }else{
                                            detailForm.getField("ORG_ACCNT").setConfig('allowBlank',true);
                                        }
                                    }else{
                                        detailForm.getField("ORG_ACCNT").setConfig('allowBlank',true);
                                    }
                                    if(BsaCodeInfo.hiddenCheck_5 == 'Y'){
                                        if(provider[0].ITEM_CODE_YN == 'Y'){
                                            detailForm.getField("ITEM_CODE").setConfig('allowBlank',false);                                                 
                                        }else{
                                            detailForm.getField("ITEM_CODE").setConfig('allowBlank',true);
                                        }
                                    }else{
                                        detailForm.getField("ITEM_CODE").setConfig('allowBlank',true);
                                    }
                                    
                                }
                            });
                            
                            detailForm.setValue('ITEM_DESC',UniDate.getDbDateStr(masterForm.getValue('GL_DATE')) + 
                                                '_' + detailForm.getValue('COST_DEPT_NM') + '_' + detailForm.getValue('ACCT_NM'));
                                                
	                    	//MIS의 경우
	                    	if (BsaCodeInfo.paySysGubun == '1') {
	                            if(!Ext.isEmpty(detailForm.getValue('ACCT_CD')) && !Ext.isEmpty(detailForm.getValue('COST_DEPT_CD'))){  
	                                var param2 = {
	                                    "BUDG_YYYYMM": UniDate.getDbDateStr(masterForm.getValue('GL_DATE')),
	                                    "ACCNT": detailForm.getValue('ACCT_CD'),
	                                    "DEPT_CODE": detailForm.getValue('COST_DEPT_CD')
	                                };
	                                UniAppManager.app.fnPossibleBudgAmt110(param2);
	                            }
							//SAP의 경우
	                    	} else {
								Ext.getBody().mask('로딩중...','loading-indicator');
	                            var paramSap = {
	                            	"PERSON_NUMB"	: UserInfo.personNumb,
	                            	"COMP_CODE"		: UserInfo.compCode,
	                            	"YEAR"			: UniDate.getDbDateStr(masterForm.getValue('GL_DATE')).substring(0, 4),
	                            	"MONTH"			: UniDate.getDbDateStr(masterForm.getValue('GL_DATE')).substring(4, 6),
	                            	"ACCT_CD"		: detailForm.getValue('ACCT_CD'), 
	                            	"DEPT_CD"		: detailForm.getValue('COST_DEPT_CD')
	                            };
								jbillCommonService.execute(paramSap, function(provider, response)   {
					                if(!Ext.isEmpty(provider)){
					                    detailForm.setValue('AMTBG',provider.AMTBG);    // 예산금액
					                    detailForm.setValue('AMTRM',provider.AMTRM);    // 잔여금액
					                    
					                }else{
					                    detailForm.setValue('AMTBG',0);
					                    detailForm.setValue('AMTRM',0);
					                }
								Ext.getBody().unmask();
								});
                            }
                        },
                        scope: this
                    },
                    onClear: function(type) {
                        detailForm.setValue('ITEM_DESC','');
                        detailForm.setValue('AMTBG',0);
                        detailForm.setValue('AMTRM',0);
                    },
                	
                    applyextparam: function(popup){
    // popup.setExtParam({'CHARGE_CODE': getChargeCode[0].SUB_CODE});
                        popup.setExtParam({'ADD_QUERY': Ext.isEmpty(detailForm.getValue('COST_DEPT_CD')) ? 
                                    "C.KOSTL_CODE = '' AND C.KOSTL_TYPE IN ('ALL', 'C') AND A.SLIP_SW = 'Y' AND A.GROUP_YN = 'N'" :  "C.KOSTL_CODE = '" + detailForm.getValue('COST_DEPT_CD') + "' AND C.KOSTL_TYPE IN ('ALL', 'C') AND A.SLIP_SW = 'Y' AND A.GROUP_YN = 'N'"
                        });
                        popup.setExtParam({'ADD_QUERY2': "Y"});
                    },
                    
                    onValueFieldChange: function(field, newValue){
                    },
                    onTextFieldChange: function(field, newValue){
                    }
                }
            }),
            {
                xtype: 'container',
                layout: {type : 'uniTable', columns : 1},
                items :[
                    Unilite.popup('PJT_NONTREE',{ 
                        fieldLabel: '사업코드',
                        valueFieldWidth: 90,
                        textFieldWidth: 140,
                        id:'pjts',
                        valueFieldName:'PJT_CODE',
                        textFieldName:'PJT_NAME',
                        autoPopup:true,
                        listeners: {
                            onSelected: {
                                fn: function(records, type) {
                                
                                },
                                scope: this
                            },
                            onClear: function(type) {
                            
                            },
                            
                            applyextparam: function(popup){
                            
                            
                            },
                            onValueFieldChange: function(field, newValue){
                              
                            },
                            onTextFieldChange: function(field, newValue){
                            }
                        }
                        
                    })
                ]
            },{
                xtype: 'container',
                layout: {type : 'uniTable', columns : 2},
                colspan:2,
                items :[{
                    xtype: 'uniNumberfield',
                    fieldLabel:'예산총액/잔액', 
                    labelWidth:110, 
                    name: 'AMTBG',
                    width:200,
                    readOnly:true
               },{
                    xtype: 'uniNumberfield',
                    fieldLabel:'',
                    name: 'AMTRM',
                    width:125,
                    readOnly:true
               }]
            },{
                xtype: 'container',
                layout: {type : 'uniTable', columns : 1},
                items :[
                Unilite.popup('ITEM',{
                    fieldLabel: '제품코드', 
                    valueFieldWidth: 90,
                    textFieldWidth: 140,
                    id:'itemCode',
                    valueFieldName:'ITEM_CODE',
                    textFieldName:'ITEM_NAME',
                    autoPopup:true,
                    hidden:true
                })]
            },{
                xtype: 'container',
                layout: {type : 'uniTable', columns : 2},
                items :[{
                    xtype: 'uniNumberfield',
                    fieldLabel:'경비처리금액', 
                    labelWidth:110, 
                    name: 'ACCT_AMT',
    // width:185,
                    allowBlank:false,
                    readOnly:true
               }/*
				 * { xtype: 'uniNumberfield', fieldLabel:'봉사료', id:'aquiServ',
				 * name: 'AQUI_SERV', labelWidth:50, width:140, //
				 * visible:false, hidden:true, readOnly:true }
				 *//*
					 * { xtype: 'container', layout: {type : 'vbox', columns :
					 * 1}, items :[{ xtype: 'uniNumberfield', fieldLabel:'봉사료',
					 * id:'aquiServ', name: 'AQUI_SERV', labelWidth:50,
					 * width:140, // visible:false, hidden:true, readOnly:true }] }
					 */]
            },{
                xtype: 'uniCombobox',
                fieldLabel: '세금코드',
                name:'TAX_CD',   
                store: Ext.data.StoreManager.lookup('taxCdList'),
                width:325,
                value:'NA',
                readOnly:true
// allowBlank:false,
    // colspan:2
            },{
                xtype: 'container',
                layout: {type : 'uniTable', columns : 1},
                items :[
                Unilite.popup('ACCNT',{
                    fieldLabel: '본계정', 
                    valueFieldWidth: 90,
                    textFieldWidth: 140,
                    id:'orgAccnt',
                    valueFieldName:'ORG_ACCNT',
                    textFieldName:'ORG_ACCNT_NM',
                    autoPopup:true,
        // allowBlank:false,
        // validateBlank:'text',
                    listeners: {
                        applyextparam: function(popup){
        // popup.setExtParam({'CHARGE_CODE': getChargeCode[0].SUB_CODE});
                            popup.setExtParam({'ADD_QUERY': "GROUP_YN = 'N' AND SLIP_SW = 'Y'"});
                        }
                    }
                })]
            },{
                xtype:'uniTextfield',
                fieldLabel:'적요',  
                    labelWidth:110,
                name:'ITEM_DESC',
                width:455,
                readOnly:true,
                allowBlank:false
            },{
                xtype:'uniTextfield',
                fieldLabel:'사용내역',
                name:'ITEM_DESC_USE',
                width:650,
                colspan:2,
                allowBlank:false
            },{
                xtype:'component',
                fieldLabel:' ',
                html:"'사용내역' 란에는 해당 예산을 사용한 목적/방법 등을 순차적으로 기입합니다.",
                componentCls : 'component-text_Remark1_bold',
                colspan:3,
                margin: '20 0 0 10'
            },{
                xtype:'component',
                fieldLabel:' ',
                html:"귀속부서 변경 필요시 각사 재무팀에 문의 바랍니다.",
                componentCls : 'component-text_Remark1_bold',
                colspan:3,
                margin: '0 0 0 10'
            }]
        }]
// ,
// api: {
// load: 'aep150ukrService.selectForm' ,
// submit: 'aep150ukrService.syncMaster'
// }
    });
    
    
    var fileUploadForm = Unilite.createSimpleForm('fileUploadForm',{
        region: 'center',
        disabled:false,
// split:true,
// border:true,
        items: [{
            xtype: 'container',
            layout: {type : 'uniTable', columns : 1},
            width:1135,
            id:'uploadDisabled',
            disabled:false,
            tdAttrs: {align : 'center'},
            items :[{
                xtype:'component',
                html:'[증빙내역]',
                componentCls : 'component-text_green',
                tdAttrs: {align : 'left'},
                width: 1135
            },{
                xtype: 'xuploadpanel',
                height: 150,
                flex: 0,
                padding: '0 0 0 0',
                listeners : {
                    change: function(xup ) {
                    	var addFiles = xup.getAddFiles();
                        masterForm.setValue('ADD_FID', addFiles);                  //추가 파일 담기
                        var removeFiles = xup.getRemoveFiles();
                        masterForm.setValue('DEL_FID', removeFiles);               //삭제 파일 담기
                        
                        var detailRecordAll = directDetailStore.data.items;
                        if(!Ext.isEmpty(masterForm.getValue('ELEC_SLIP_NO'))){
                            if(!Ext.isEmpty(detailRecordAll)){
                                detailRecordAll[0].set('FILE_UPLOAD_FLAG',addFiles + removeFiles);
                            }
                        }
                    },
                    
                    uploadcomplete : function(xup){
                        var addFiles = xup.getAddFiles();
                        masterForm.setValue('ADD_FID', addFiles);                  //추가 파일 담기
                        
                        var detailRecordAll = directDetailStore.data.items;
                        if(!Ext.isEmpty(masterForm.getValue('ELEC_SLIP_NO'))){
                            if(!Ext.isEmpty(detailRecordAll)){
                                detailRecordAll[0].set('FILE_UPLOAD_FLAG',addFiles);
                            }
                        }
                    }
                }
            }]
        }],
        api: {
             load: 'aep150ukrService.getFileList',   // 조회 api
             submit: 'aep150ukrService.saveFile'      // 저장 api
        }
    });  
    var searchGrid = Unilite.createGrid('aep150ukrSearchGrid', {
// split:true,
// layout: 'fit',
        region: 'center',
        excelTitle: '원천세내역',
        height:250,
        uniOpt: {
            useGroupSummary: false,
            useLiveSearch: true,
            useContextMenu: false,
            useMultipleSorting: true,
            onLoadSelectFirst: true,
            useRowNumberer: false,
            expandLastColumn: false,
            useRowContext: false,
            state: {
                useState: false,         
                useStateList: false      
            }
        },
        tbar:[{
            xtype: 'button',
            text: '전체선택',
            handler: function() {   
                var records = directSearchStore.data.items;  
                Ext.each(records,  function(record, index, records){
                    record.set('SELECT', true);
                });
                    
// if(checkCount > 0){
// UniAppManager.setToolbarButtons('save',true);
// }else if(checkCount < 1){
// UniAppManager.setToolbarButtons('save',false);
// }
            }
        },{
            xtype: 'button',
            text: '전체취소',
            handler: function() {   
                var records = directSearchStore.data.items;  
                Ext.each(records,  function(record, index, records){
                    record.set('SELECT', false);
                });
                
// if(checkCount > 0){
// UniAppManager.setToolbarButtons('save',true);
// }else if(checkCount < 1){
// UniAppManager.setToolbarButtons('save',false);
// }
            }
        }],
        bbar: ['->',{
            xtype: 'button',
            id: 'btnReq',
            text: '결재요청',
            handler: function() {
                
                var searchRecords = directSearchStore.data.items;
                
                var selectTrueFlag = '';
                
                if(searchRecords.length > 0){
                    
                    Ext.each(searchRecords, function(record,i){
                        if(record.get('SELECT') == true){
                            selectTrueFlag = 'Y';
                        }
                    });
                    
                    if(selectTrueFlag == 'Y'){
                        if(confirm('선택한 원천세내역을 결재요청 처리하시겠습니까?')) { 
                            requestStore.clearData();
                            Ext.each(searchRecords, function(record,i){
                                if(record.get('SELECT') == true){
                                    record.phantom = true;
                                    requestStore.insert(i, record);
                                 
                                }
                            });
                            
                            requestStore.saveStore(); 
                        }else{
                           return false;    
                        }
                    }else{
                        Ext.Msg.alert('확인','결재요청 처리할 데이터를 선택해 주세요.');
                    }
                }else{
                    Ext.Msg.alert('확인','결재요청 처리할 데이터를 선택해 주세요.');
                }
            }
        }],
        features: [{
            id: 'detailGridSubTotal', 
            ftype: 'uniGroupingsummary', 
            showSummaryRow: false
        },{
            id: 'detailGridTotal', 
            ftype: 'uniSummary', 
            showSummaryRow: false
        }],
        store: directSearchStore,
        selModel:'rowmodel',
        columns: [
            {dataIndex: 'SELECT'                , width: 40, xtype: 'checkcolumn',align:'center',
                listeners: {    
                    checkchange: function( CheckColumn, rowIndex, checked, eOpts ){
                    }
                }
            },                   
            { dataIndex: 'RNUM'                                ,width:40,align:'center'},
            { dataIndex: 'SLIP_STAT_CD'                        ,width:80,align:'center'},
            { dataIndex: 'INVOICE_DATE'                        ,width:80},
            { dataIndex: 'GL_DATE'                             ,width:80},
            { dataIndex: 'INVOICE_AMT'                         ,width:120},
            { dataIndex: 'VENDOR_NM'                           ,width:150},
            { dataIndex: 'SLIP_DESC'                           ,width:250},
            { dataIndex: 'DEPT_NAME'                           ,width:120},
            { dataIndex: 'REG_NM'                              ,width:100,align:'center'},
            { dataIndex: 'REG_DT2'                             ,width:80},
            { dataIndex: 'ELEC_SLIP_NO'                        ,width:120}
        ],
        listeners: { 
            beforeselect: function(rowSelection, record, index, eOpts) { 
                var focusMove = true;
                
                if(!UniAppManager.app.getTopToolbar().getComponent('save').isDisabled()) {
                    
                    focusMove = false;
                    Ext.Msg.show({
                         title:'확인',
                         msg: Msg.sMB017 + "\n" + Msg.sMB061,
                         buttons: Ext.Msg.YESNOCANCEL,
                         icon: Ext.Msg.QUESTION,
                         fn: function(res) {
                            if (res === 'yes' ) {
                                
                            focusMove = false;
// alert('저장로직');
                                UniAppManager.app.onSaveDataButtonDown();
                                
                            } else if(res === 'no') {
                                focusMove = true;
// masterForm.setValue('TAX_CD','');
                                detailForm.clearForm();
                                detailGrid.reset();
                                directDetailStore.clearData();
                                UniAppManager.setToolbarButtons('save', false);
                                searchGrid.getSelectionModel().select(index);
                            }else{
                                focusMove = false;
                            }
                         }
                    });
                } else {
// masterForm.setValue('TAX_CD','');
                    detailForm.clearForm();
                    
                    if(BsaCodeInfo.paySysGubun == '1'){
                        detailForm.setValue('COST_DEPT_CD',UserInfo.deptCode);
                        detailForm.setValue('COST_DEPT_NM',UserInfo.deptName);
                        
                        var param = {
                            "COST_DEPT_CD": UserInfo.deptCode
                        };
                            
                        accntCommonService.setMakeSale_J(param, function(provider, response)   {
                            if(!Ext.isEmpty(provider)){
                                detailForm.setValue('MAKE_SALE',provider.MAKE_SALE);
                            }else{
                                detailForm.setValue('MAKE_SALE','');    
                            }
                        })
                    }
                    
                    
                    detailGrid.reset();
                    directDetailStore.clearData();
                }
                
                return focusMove;
            },
            
            selectionchangerecord:function(selected)    {
            	
                masterForm.setValue('ATTRIBUTE5','');
                masterForm.setValue('ATTRIBUTE6','');
                masterForm.setValue('ATTRIBUTE7','');
                masterForm.setValue('ATTRIBUTE8','');
                
                masterForm.setValue('ELEC_SLIP_NO',selected.data.ELEC_SLIP_NO);
            	//파일업로드용 setting
                masterForm.setValue('FILE_NO',selected.data.ELEC_SLIP_NO);
                
                detailForm.setValue('TAX_CD', 'NA');
      /*
		 * 추후 확인 필요 로우클릭시 마스터 폼 셋 팅
		 * masterForm.setValue('INVOICE_AMT',selected.data.AQUI_SUM);
		 * masterForm.setValue('ATTRIBUTE2',selected.data.AQUI_TAX);
		 * 
		 * masterForm.setValue('ELEC_SLIP_NO',selected.data.ELEC_SLIP_NO);
		 * 
		 * masterForm.setValue('UL_NO',selected.data.UL_NO);
		 */
                
                masterForm.mask('loading...');
                var param= masterForm.getValues();
                param.ELEC_SLIP_NO = selected.data.ELEC_SLIP_NO;
                loadFlag = 'Y';
                masterForm.getForm().load({
                    params: param,
                    success: function(form, action) {
                        directDetailStore.loadStoreRecords();
                        masterForm.unmask();
                        
                        if(BsaCodeInfo.paySysGubun == '1'){
                            masterForm.getForm().getFields().each(function(field) {
                            
                                field.setReadOnly(true);
                            
                            });
                        }
                        
                        loadFlag = '';
                    },
                    failure: function(form, action) {
                        UniAppManager.app.fnAcctAmtChange1();
                        masterForm.unmask();
                        loadFlag = '';
                    }
                });
                UniAppManager.setToolbarButtons('reset',true);
                UniAppManager.setToolbarButtons('save', false);
                UniAppManager.app.fileUploadLoad();
            }
        }
    });  
    
    
    var subForm = Unilite.createSimpleForm('subForm',{
        region: 'north',
// border:true,
// split:true,
        items: [{
                xtype:'component',
                html:'[원천세내역]',
                componentCls : 'component-text_green',
                tdAttrs: {align : 'left'},
                width: 150
            },searchGrid]
        
    }); 
    
    var detailGrid = Unilite.createGrid('aep150ukrDetailGrid', {
    	height:300,
        width:1135,
        region: 'south',
        excelTitle: '원천세경비내역',
        uniOpt: {
            useGroupSummary: false,
            useLiveSearch: true,
            useContextMenu: false,
            useMultipleSorting: true,
            onLoadSelectFirst: false,
            useRowNumberer: true,
            expandLastColumn: false,
            useRowContext: true,
            state: {
                useState: false,         
                useStateList: false      
            }
        },
        features: [{
            id: 'detailGridSubTotal', 
            ftype: 'uniGroupingsummary', 
            showSummaryRow: false
        },{
            id: 'detailGridTotal', 
            ftype: 'uniSummary', 
            showSummaryRow: false
        }],
        dockedItems: [{         
            xtype: 'toolbar',
            dock: 'top',
            items: [{
                xtype: 'uniBaseButton',
                text : '신규',
                tooltip : '초기화',
                iconCls: 'icon-reset',
                width: 26, height: 26,
                itemId : 'detail_reset',
                handler : function() { 
                    detailForm.clearForm();
                    detailForm.setValue('TAX_CD', 'NA');
                    UniAppManager.app.fnAcctAmtChange1();
                }
            },{
                xtype: 'uniBaseButton',
                text : '추가',
                tooltip : '추가',
                iconCls: 'icon-new',
                width: 26, height: 26,
                itemId : 'detail_newData',
                handler : function() { 
                	if(!masterForm.getInvalidMessage()) return; 
                    if(!detailForm.getInvalidMessage()) return; 
                    
                    var detailData = directDetailStore.data.items;
                    
                    var drAmtISum = 0;
                    var aquiServSum = 0;
                    
                    Ext.each(detailData, function(record,i){
                        if(record.get('LINE_TYPE_CD') != 'TAX'){
                            drAmtISum = drAmtISum + record.get('DR_AMT_I');
                        }
                    });
                    
                    var param = {
                        "ACCNT": detailForm.getValue('ACCT_CD')
                    };
                    aep150ukrService.selectBudgctlYn(param, function(provider, response)   {
                        if(!Ext.isEmpty(provider)){
                            if(provider.BUDGCTL_YN == 'Y'){
                                if(!Ext.isEmpty(detailForm.getValue('AMTRM'))){
                                    if(detailForm.getValue('AMTRM') < detailForm.getValue('ACCT_AMT') + drAmtISum){
                                        alert("경비금액은 예산잔액을 초과하여 입력할 수 없습니다.");
                                    }else{
                                        if(!Ext.isEmpty(detailForm.getValue('TAX_CD'))){
                                            if(masterForm.getValue('INVOICE_AMT') < detailForm.getValue('ACCT_AMT') + drAmtISum){
                                                alert("차변(원화)금액의 총합이 대변금액 보다 클 수 없습니다.");
                                            }else{
//                                            	if(masterForm.getValue('INCOME_TAX_ATTRIBUTE13') == '03_K1'){
//                                                    if(masterForm.getValue('ATTRIBUTE8') >  dateStFr){
//                                                        alert("일수보다 시작일자와 종료일자 차이일수가 작습니다.\n일수 : "+ masterForm.getValue('ATTRIBUTE8') + "/n기간일수 : " + dateStFr);
//                                                        return false;
//                                                    }
//                                                }
//                                            	if(UniAppManager.app.fnDateStFrCheck()){
//                                                    UniAppManager.app.fnCreateRow();
//                                            	}
                                            	UniAppManager.app.fnDateStFrCheck();
                                            }
                                        }
                                    }
                                }else{
                                    alert("예산잔액이 없습니다.");   
                                }
                            }else{
                                if(!Ext.isEmpty(detailForm.getValue('TAX_CD'))){
                                    if(masterForm.getValue('INVOICE_AMT') < detailForm.getValue('ACCT_AMT') + drAmtISum){
                                        alert("차변(원화)금액의 총합이 대변금액 보다 클 수 없습니다.");
                                    }else{
//                                    	if(masterForm.getValue('INCOME_TAX_ATTRIBUTE13') == '03_K1'){
//                                            if(masterForm.getValue('ATTRIBUTE8') >  dateStFr){
//                                                alert("일수보다 시작일자와 종료일자 차이일수가 작습니다.\n일수 : "+ masterForm.getValue('ATTRIBUTE8') + "/n기간일수 : " + dateStFr);
//                                                return false;
//                                            }
//                                        }
//                                    	if(UniAppManager.app.fnDateStFrCheck()){
//                                            UniAppManager.app.fnCreateRow();
//                                        }
                                    	UniAppManager.app.fnDateStFrCheck();
                                    }
                                }
                            }
                        }else{
                            if(!Ext.isEmpty(detailForm.getValue('TAX_CD'))){
                                if(masterForm.getValue('INVOICE_AMT') < detailForm.getValue('ACCT_AMT') + drAmtISum){
                                    alert("차변(원화)금액의 총합이 대변금액 보다 클 수 없습니다.");
                                }else{
//                                	if(masterForm.getValue('INCOME_TAX_ATTRIBUTE13') == '03_K1'){
//                                        if(masterForm.getValue('ATTRIBUTE8') >  dateStFr){
//                                            alert("일수보다 시작일자와 종료일자 차이일수가 작습니다.\n일수 : "+ masterForm.getValue('ATTRIBUTE8') + "/n기간일수 : " + dateStFr);
//                                            return false;
//                                        }
//                                    }
//                                	if(UniAppManager.app.fnDateStFrCheck()){
//                                        UniAppManager.app.fnCreateRow();
//                                    }
                                	UniAppManager.app.fnDateStFrCheck();
                                }
                            }
                        }
                    });
             /*
				 * 
				 *  // var mainGridRecord = detailGrid.getSelectedRecord(); //
				 * var customCode =
				 * mainGridReceiveRecord.get('PAY_CUSTOM_CODE');
				 * 
				 * 
				 * var dcDivCd = 'D'; var acctCd =
				 * detailForm.getValue('ACCT_CD'); var acctNm =
				 * detailForm.getValue('ACCT_NM'); var costDeptCd =
				 * detailForm.getValue('COST_DEPT_CD'); var costDeptNm =
				 * detailForm.getValue('COST_DEPT_NM'); // var attribute2 =
				 * detailForm.getValue('ATTRIBUTE2');
				 * 
				 * var crAmtI = 0; var taxCd = detailForm.getValue('TAX_CD');
				 * var itemDescUse = detailForm.getValue('ITEM_DESC_USE'); var
				 * itemDesc = detailForm.getValue('ITEM_DESC');
				 * 
				 * var drAmtI = detailForm.getValue('ACCT_AMT'); //차변금액으로
				 * DR_AMT_I // var aquiServ = detailForm.getValue('AQUI_SERV');
				 * var payType = detailForm.getValue('PAY_TYPE'); var makeSale =
				 * detailForm.getValue('MAKE_SALE'); var pjtCode =
				 * detailForm.getValue('PJT_CODE'); var pjtName =
				 * detailForm.getValue('PJT_NAME'); var orgAccnt =
				 * detailForm.getValue('ORG_ACCNT'); var orgAccntNm =
				 * detailForm.getValue('ORG_ACCNT_NM'); var payDate =
				 * masterForm.getValue('PAY_DATE');
				 * 
				 * var elecSlipNo = masterForm.getValue('ELEC_SLIP_NO');
				 * 
				 * var itemCode = detailForm.getValue('ITEM_CODE'); var itemName =
				 * detailForm.getValue('ITEM_NAME');
				 * 
				 * var r = { DC_DIV_CD: dcDivCd, ACCT_CD: acctCd, ACCT_NM:
				 * acctNm, COST_DEPT_CD: costDeptCd, COST_DEPT_NM: costDeptNm, //
				 * ATTRIBUTE2: attribute2,
				 * 
				 * CR_AMT_I: crAmtI, TAX_CD: taxCd, ITEM_DESC_USE: itemDescUse,
				 * ITEM_DESC: itemDesc,
				 * 
				 * DR_AMT_I: drAmtI, // AQUI_SERV: aquiServ, PAY_TYPE: payType,
				 * MAKE_SALE: makeSale, PJT_CODE: pjtCode, PJT_NAME: pjtName,
				 * ORG_ACCNT: orgAccnt, ORG_ACCNT_NM: orgAccntNm, PAY_DATE:
				 * payDate,
				 * 
				 * ELEC_SLIP_NO: elecSlipNo,
				 * 
				 * ITEM_CODE: itemCode, ITEM_NAME: itemName };
				 * detailGrid.createRow(r);
				 * 
				 * detailForm.clearForm(); // var searchGridRecord =
				 * searchGrid.getSelectedRecord();
				 * 
				 * var detailData = directDetailStore.data.items;
				 * 
				 * var drAmtISum = 0;
				 * 
				 * Ext.each(detailData, function(record,i){ drAmtISum =
				 * drAmtISum + record.get('DR_AMT_I');
				 * 
				 * });
				 * 
				 * 
				 * if(masterForm.getValue('INVOICE_AMT') - drAmtISum == 0){
				 * detailForm.setValue('ACCT_AMT',0); //
				 * detailForm.setValue('AQUI_SERV',0); }else{
				 * detailForm.setValue('ACCT_AMT',masterForm.getValue('INVOICE_AMT') -
				 * drAmtISum); //
				 * detailForm.setValue('AQUI_SERV',searchGridRecord.get('AQUI_SERV')); }
				 * 
				 * 
				 */
                    
                }
            },{
                xtype: 'uniBaseButton',
                text : '삭제',
                tooltip : '삭제',
                iconCls: 'icon-delete',
                // disabled: true,
                width: 26, height: 26,
                itemId : 'detail_delete',
                handler : function() { 
                    var selRow = detailGrid.getSelectedRecord();
                    if(!Ext.isEmpty(selRow)){
                        if(selRow.phantom === true) {
                            detailGrid.deleteSelectedRow();
                            
                            detailForm.clearForm();
                            
// var searchGridRecord = searchGrid.getSelectedRecord();
                        
                            UniAppManager.app.fnAcctAmtChange2(); 
                            /*
							 * var detailData = directDetailStore.data.items;
							 * 
							 * var drAmtISum = 0;
							 * 
							 * Ext.each(detailData, function(record,i){
							 * drAmtISum = drAmtISum + record.get('DR_AMT_I');
							 * });
							 * 
							 * 
							 * if( masterForm.getValue('INVOICE_AMT') +
							 * drAmtISum == 0){
							 * detailForm.setValue('ACCT_AMT',0); }else{
							 * detailForm.setValue('ACCT_AMT',masterForm.getValue('INVOICE_AMT') -
							 * drAmtISum); }
							 */
                            
                        }else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
                            detailGrid.deleteSelectedRow();      
                            
                            detailForm.clearForm();
                            
// var searchGridRecord = searchGrid.getSelectedRecord();
                            UniAppManager.app.fnAcctAmtChange2(); 
                         /*
							 * var detailData = directDetailStore.data.items;
							 * 
							 * var drAmtISum = 0;
							 * 
							 * Ext.each(detailData, function(record,i){
							 * drAmtISum = drAmtISum + record.get('DR_AMT_I');
							 * });
							 * 
							 * 
							 * if(masterForm.getValue('INVOICE_AMT') + drAmtISum ==
							 * 0){ detailForm.setValue('ACCT_AMT',0); }else{
							 * detailForm.setValue('ACCT_AMT',masterForm.getValue('INVOICE_AMT') -
							 * drAmtISum); }
							 */
                        }   
                    }
                }               
            },{
                xtype: 'button',
                id: 'btnUpdate',
                text: '수정',
                handler: function() {
                    if(!masterForm.getInvalidMessage()) return; 
                    if(!detailForm.getInvalidMessage()) return; 
                    
                    var detailGridRecord = detailGrid.getSelectedRecord();
                    if(!Ext.isEmpty(detailGridRecord)){
                        detailGridRecord.set('PAY_TYPE'     ,detailForm.getValue('PAY_TYPE'));
                        detailGridRecord.set('MAKE_SALE'    ,detailForm.getValue('MAKE_SALE'));
                        detailGridRecord.set('ACCT_CD'      ,detailForm.getValue('ACCT_CD'));
                        detailGridRecord.set('ACCT_NM'      ,detailForm.getValue('ACCT_NM'));
                        detailGridRecord.set('COST_DEPT_CD' ,detailForm.getValue('COST_DEPT_CD'));
                        detailGridRecord.set('COST_DEPT_NM' ,detailForm.getValue('COST_DEPT_NM'));
                        detailGridRecord.set('ORG_ACCNT'    ,detailForm.getValue('ORG_ACCNT'));
                        detailGridRecord.set('ORG_ACCNT_NM' ,detailForm.getValue('ORG_ACCNT_NM'));
                        detailGridRecord.set('DR_AMT_I'     ,detailForm.getValue('ACCT_AMT'));
                        detailGridRecord.set('TAX_CD'       ,detailForm.getValue('TAX_CD'));
                        detailGridRecord.set('ITEM_DESC_USE'    ,detailForm.getValue('ITEM_DESC_USE'));
                        detailGridRecord.set('ITEM_DESC'    ,detailForm.getValue('ITEM_DESC'));
                        
                        detailGridRecord.set('PAY_DATE'    ,masterForm.getValue('PAY_DATE'));
                    
                        detailGridRecord.set('PJT_CODE'    ,detailForm.getValue('PJT_CODE'));
                        detailGridRecord.set('PJT_NAME'    ,detailForm.getValue('PJT_NAME'));
                        detailGridRecord.set('ITEM_CODE'   ,detailForm.getValue('ITEM_CODE'));
                        detailGridRecord.set('ITEM_NAME'   ,detailForm.getValue('ITEM_NAME'));
// var searchGridRecord = searchGrid.getSelectedRecord();
                        UniAppManager.app.fnAcctAmtChange1();
                        /*
						 * var detailData = directDetailStore.data.items;
						 * 
						 * var drAmtISum = 0;
						 * 
						 * Ext.each(detailData, function(record,i){ drAmtISum =
						 * drAmtISum + record.get('DR_AMT_I'); });
						 * 
						 * 
						 * if( masterForm.getValue('INVOICE_AMT') - drAmtISum ==
						 * 0){ detailForm.setValue('ACCT_AMT',0); }else{
						 * detailForm.setValue('ACCT_AMT',masterForm.getValue('INVOICE_AMT') -
						 * drAmtISum); }
						 */
                    }
                }
            }
            
            ]
        }],
        store: directDetailStore,
        columns: [
            { dataIndex: 'SEQ'                      ,width:80,hidden:true},
            { dataIndex: 'ELEC_SLIP_NO'             ,width:80,hidden:true},
            { dataIndex: 'LINE_TYPE_CD'             ,width:50,align:'center',hidden:true},
            { dataIndex: 'DC_DIV_CD'                ,width:80,align:'center'},
            { dataIndex: 'ACCT_CD'                  ,width:120},
            { dataIndex: 'ACCT_NM'                  ,width:150},
            { dataIndex: 'COST_DEPT_CD'             ,width:100},
            { dataIndex: 'COST_DEPT_NM'             ,width:120},
            { dataIndex: 'TAX_CD'                   ,width:100},
            { dataIndex: 'DR_AMT_I'                 ,width:100},
            { dataIndex: 'CR_AMT_I'                 ,width:100},
            { dataIndex: 'ITEM_DESC_USE'            ,width:150},
            { dataIndex: 'ITEM_DESC'                ,width:200},
// 			{ dataIndex: 'ACCT_AMT' ,width:80,hidden:false},
// 			{ dataIndex: 'AQUI_SERV' ,width:80,hidden:true},
            { dataIndex: 'PAY_TYPE'                 ,width:80,hidden:true},
            { dataIndex: 'MAKE_SALE'                ,width:80,hidden:true},
            { dataIndex: 'PJT_CODE'                 ,width:80,hidden:true},
            { dataIndex: 'PJT_NAME'                 ,width:80,hidden:true},
            { dataIndex: 'ORG_ACCNT'                ,width:80,hidden:true},
            { dataIndex: 'ORG_ACCNT_NM'             ,width:80,hidden:true},
            { dataIndex: 'PAY_DATE'                 ,width:80,hidden:true},
            
            { dataIndex: 'ITEM_CODE'                ,width:80,hidden:true},
            { dataIndex: 'ITEM_NAME'                ,width:80,hidden:true},
            
            { dataIndex: 'FILE_UPLOAD_FLAG'     	,width:80,hidden:false}
        ],
        listeners: { 
            selectionchangerecord:function(selected)    {
            },
            beforeedit : function( editor, e, eOpts ) {
                return false;
            },
            cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
            	
            	detailGridClickFlag = 'Y';
            	
                detailForm.setValue('ACCT_CD'       ,record.get('ACCT_CD'));     
                detailForm.setValue('ACCT_NM'       ,record.get('ACCT_NM'));          
                detailForm.setValue('COST_DEPT_CD'  ,record.get('COST_DEPT_CD'));     
                detailForm.setValue('COST_DEPT_NM'  ,record.get('COST_DEPT_NM'));     
                           
                detailForm.setValue('TAX_CD'        ,record.get('TAX_CD'));           
                detailForm.setValue('ITEM_DESC_USE'     ,record.get('ITEM_DESC_USE'));        
                detailForm.setValue('ITEM_DESC'     ,record.get('ITEM_DESC'));        
                                             
                detailForm.setValue('ACCT_AMT'      ,record.get('DR_AMT_I'));         
                detailForm.setValue('PAY_TYPE'      ,record.get('PAY_TYPE'));         
                detailForm.setValue('MAKE_SALE'     ,record.get('MAKE_SALE'));        
                detailForm.setValue('PJT_CODE'      ,record.get('PJT_CODE'));   
                detailForm.setValue('PJT_NAME'      ,record.get('PJT_NAME'));        
                detailForm.setValue('ORG_ACCNT'     ,record.get('ORG_ACCNT'));
                detailForm.setValue('ORG_ACCNT_NM'  ,record.get('ORG_ACCNT_NM'));
                
                masterForm.setValue('PAY_DATE'      ,record.get('PAY_DATE'));           
            	
                detailForm.setValue('ITEM_CODE'      ,record.get('ITEM_CODE'));
                detailForm.setValue('ITEM_NAME'      ,record.get('ITEM_NAME'));  
                
            	detailGridClickFlag = '';
            	
            	if(!Ext.isEmpty(detailForm.getValue('ACCT_CD')) && !Ext.isEmpty(detailForm.getValue('COST_DEPT_CD'))){  
                    var param2 = {
                        "BUDG_YYYYMM": UniDate.getDbDateStr(masterForm.getValue('GL_DATE')),
                        "ACCNT": detailForm.getValue('ACCT_CD'),
                        "DEPT_CODE": detailForm.getValue('COST_DEPT_CD')
                    };
                    UniAppManager.app.fnPossibleBudgAmt110(param2);
                }
            }
        }
    });   
    
    
    
     var subForm2 = Unilite.createSimpleForm('subForm2',{
        region: 'south',
        items: [{
            xtype: 'container',
            layout: {type : 'uniTable', columns : 1},
            width:1000,
            items :[detailGrid]
            }]
    }); 

    
    
    Unilite.Main( {
        borderItems:[{
            region:'center',
            layout:{type:'vbox', align:'stretch'},
            border: false,
            autoScroll: true,
            
            items:[{
                region:'north',
                xtype:'container',
                layout:{type:'vbox', align:'stretch'},
                items:[
                    searchForm, subForm
                ]
            },{
                region:'center',
                xtype:'container',
                layout:{type:'vbox', align:'stretch'},
                items:[
                    masterForm, detailForm, subForm2
                ]
            },{
                region:'south',
                xtype:'container',
                layout:{type:'vbox', align:'stretch'},
                items:[
                    fileUploadForm
                ]
            }]
        }],
        id  : 'aep150ukrApp',
        fnInitBinding: function(params){
            UniAppManager.setToolbarButtons(['newData'], false);
            UniAppManager.setToolbarButtons(['reset'], true);
            
            this.setDefault(params);
        },
        
        onQueryButtonDown: function() {   
			if(!searchForm.getInvalidMessage()){
				return false;
			}
        	directSearchStore.loadStoreRecords();
        },
/*
 * onNewDataButtonDown: function() { if(!panelResult.getInvalidMessage())
 * return; //필수체크 // var compCode = UserInfo.compCode;
 * 
 * var r = { // COMP_CODE: compCode }; detailGrid.createRow(r); },
 */
        onResetButtonDown: function() {
// 			detailForm.clearForm();
        	masterForm.clearForm();
            detailForm.clearForm();
            fileUploadForm.clearForm();
            fileUploadForm.down('xuploadpanel').reset();
            searchGrid.reset();
            directSearchStore.clearData();
            detailGrid.reset();
            directDetailStore.clearData();
            UniAppManager.setToolbarButtons(['newData','save','delete'], false);
            UniAppManager.setToolbarButtons(['reset'], true);
            UniAppManager.app.fnInitInputFields();  
            SAVE_FLAG = '';
            
            if(BsaCodeInfo.paySysGubun == '1'){
                masterForm.getForm().getFields().each(function(field) {
                    if (field.name == 'ELEC_SLIP_NO' || // FR_VENDOR_NM
                        field.name == 'VENDOR_SITE_CD' || 
                        field.name == 'SLIP_STAT_CD' || 
                        field.name == 'INCOME_TAX_ACCT_AMT' || 
                        field.name == 'CREDIT_ACCT_AMT' || 
                        field.name == 'RSD_TAX_ACCT_AMT' 
                    ){
                        field.setReadOnly(true);
                    }else{
                        field.setReadOnly(false);
                    }
                });
            }
        },
        
        onSaveDataButtonDown: function(config) {
            if(!masterForm.getInvalidMessage()) return; 
//            if(masterForm.getValue('INCOME_TAX_ATTRIBUTE13') == '03_K1'){
//                if(masterForm.getValue('ATTRIBUTE8') >  dateStFr){
//                    alert("일수보다 시작일자와 종료일자 차이일수가 작습니다.\n일수 : "+ masterForm.getValue('ATTRIBUTE8') + "/n기간일수 : " + dateStFr);
//                    return;
//                }
//            }
//            UniAppManager.app.fnDateStFrCheck();
            if(masterForm.getValue('INCOME_TAX_ATTRIBUTE13') == '03_K1'){
                if(masterForm.getValue('ATTRIBUTE8') >  dateStFr){
                    alert("일수보다 시작일자와 종료일자 차이일수가 작습니다.\n일수 : "+ masterForm.getValue('ATTRIBUTE8') + "\n기간일수 : " + dateStFr);
                    return false;
                }
            }
            /** 파일업로드 관련
             **/
            var fp = fileUploadForm.down('xuploadpanel'); 
            var addFiles = fp.getAddFiles();                
            var removeFiles = fp.getRemoveFiles();
            masterForm.setValue('ADD_FID', addFiles);                  //추가 파일 담기
            masterForm.setValue('DEL_FID', removeFiles);               //삭제 파일 담기

            directDetailStore.saveStore();
        },
        
        onDeleteDataButtonDown: function() {
            if(confirm('현재 데이터를 삭제 합니다.\n 삭제 하시겠습니까?')) {
                var param = detailForm.getValues();
                param.SAVE_FLAG = 'D';
                detailForm.getForm().submit({
                    params : param,
                    success : function(form, action) {
                        detailForm.getForm().wasDirty = false;
                        detailForm.resetDirtyStatus();                                          
                      
                        UniAppManager.updateStatus(Msg.sMB011);// 저장되었습니다
                        
                        detailForm.clearForm();
                        detailGrid.reset();
                        directDetailStore.clearData();
                        UniAppManager.app.fnInitInputFields();  
                        
                        UniAppManager.setToolbarButtons(['delete','save'],false);
                    }   
                });
            }
        },
        /*
		 * onDeleteAllButtonDown: function() { var records =
		 * directDetailStore.data.items; var isNewData = false;
		 * Ext.each(records, function(record,i) { if(record.phantom){ //신규 레코드일시
		 * isNewData에 true를 반환 isNewData = true; }else{ //신규 레코드가 아닌게 중간에 나오면 전체
		 * 삭제후 저장 로직 실행 if(confirm('전체삭제 하시겠습니까?')) { var deletable = true;
		 * if(deletable){ detailGrid.reset();
		 * UniAppManager.app.onSaveDataButtonDown(); } isNewData = false; }
		 * return false; } }); if(isNewData){ //신규 레코드들만 있을시 그리드 리셋
		 * detailGrid.reset(); UniAppManager.app.onResetButtonDown(); //삭제후
		 * RESET.. } },
		 */
        setDefault: function(params){
            if(!Ext.isEmpty(params.ELEC_SLIP_NO)){
                this.processParams(params);
            }else{
                UniAppManager.app.fnInitInputFields();  
            }
        },
/*
 * onPrintButtonDown: function() { //var records =
 * detailForm.down('#imageList').getSelectionModel().getSelection(); var param=
 * Ext.getCmp('resultForm').getValues();
 * 
 * var prgId = ''; // if(라디오 값에따라){ // prgId = 'arc100rkr'; // }else if{ //
 * prgId = 'abh221rkr'; // }
 * 
 * 
 * var win = Ext.create('widget.PDFPrintWindow', { url:
 * CPATH+'/abh/arc100rkrPrint.do', // prgID:prgId, prgID: 'arc100rkr', extParam: {
 * COMP_CODE: param.COMP_CODE // INOUT_SEQ: param.INOUT_SEQ, // INOUT_NUM:
 * param.INOUT_NUM, // DIV_CODE: param.DIV_CODE, // INOUT_CODE:
 * param.INOUT_CODE, // INOUT_DATE: param.INOUT_DATE, // ITEM_CODE:
 * param.ITEM_CODE, // INOUT_Q: param.INOUT_Q, // INOUT_P: param.INOUT_P, //
 * INOUT_I: param.INOUT_I, // INOUT_DATE_FR: param.INOUT_DATE_FR, //
 * INOUT_DATE_TO: param.INOUT_DATE_TO } }); win.center(); win.show(); }
 */
        processParams: function(params) {
            this.uniOpt.appParams = params;
			if (params.PGM_ID == 'aep200skr') {
                searchForm.setValue('ELEC_SLIP_NO',params.ELEC_SLIP_NO);
                searchForm.setValue('INVOICE_DATE_FR',params.INVOICE_DATE);
                searchForm.setValue('INVOICE_DATE_TO',params.INVOICE_DATE);
                
                searchForm.setValue('FILE_NO',params.ELEC_SLIP_NO);
//                Ext.getCmp('uploadDisabled').setDisabled(false);
                this.onQueryButtonDown();
            }
        },
        setMasterDefault: function(){
            masterForm.setValue('SLIP_STAT_CD','10');
            
            if(BsaCodeInfo.paySysGubun == '1'){
                masterForm.setValue('VENDOR_ID',gsCustomCode);
                masterForm.setValue('VENDOR_NM',gsCustomName);
                masterForm.setValue('VENDOR_SITE_CD',gsCompanyNum);
            }else if(BsaCodeInfo.paySysGubun == '2'){
                masterForm.setValue('VENDOR_ID',UserInfo.personNumb);
                masterForm.setValue('VENDOR_NM',personName);
                masterForm.setValue('VENDOR_SITE_CD','');
            }
            masterForm.setValue('COST_DEPT_CD',UserInfo.deptCode);
            masterForm.setValue('COST_DEPT_NM',UserInfo.deptName);
            
            if(BsaCodeInfo.paySysGubun == '1'){
                detailForm.setValue('COST_DEPT_CD',UserInfo.deptCode);
                detailForm.setValue('COST_DEPT_NM',UserInfo.deptName);
                
                var param = {
                    "COST_DEPT_CD": UserInfo.deptCode
                };
                    
                accntCommonService.setMakeSale_J(param, function(provider, response)   {
                    if(!Ext.isEmpty(provider)){
                        detailForm.setValue('MAKE_SALE',provider.MAKE_SALE);
                    }else{
                        detailForm.setValue('MAKE_SALE','');    
                    }
                })
            }
            
            masterForm.setValue('GL_DATE', UniDate.get('today'));
            masterForm.setValue('INVOICE_DATE', UniDate.get('today'));
            masterForm.setValue('PAY_DATE', UniDate.get('today'));
// masterForm.setValue('GLOBAL_ATTRIBUTE2',masterForm.getField('GLOBAL_ATTRIBUTE2').getStore().getAt(0).get('value'));
            if(!Ext.isEmpty(masterForm.getField('GLOBAL_ATTRIBUTE3').getStore().data.items)){
                masterForm.setValue('GLOBAL_ATTRIBUTE3',masterForm.getField('GLOBAL_ATTRIBUTE3').getStore().getAt(0).get('value'));
            }
            
            masterForm.down("#incomeTaxOpt1").disable(true);
            masterForm.down("#incomeTaxOpt2").disable(true);    
            masterForm.down("#incomeTaxOpt3").disable(true);   
            
            detailForm.setValue('TAX_CD', 'NA');
// masterForm.getField('EVDE_TYPE_CD').setValue('60');
        },
        
        fnInitInputFields: function(){
        	searchForm.setValue('INVOICE_DATE_FR',UniDate.get('twoMonthsAgo'));
            searchForm.setValue('INVOICE_DATE_TO',UniDate.get('today'));
            searchForm.setValue('GL_DATE_FR',UniDate.get('twoMonthsAgo'));
            searchForm.setValue('GL_DATE_TO',UniDate.get('today'));
            searchForm.setValue('INSERT_DB_TIME_FR',UniDate.get('twoMonthsAgo'));
            searchForm.setValue('INSERT_DB_TIME_TO',UniDate.get('today'));
            
            searchForm.setValue('ELEC_SLIP_TYPE_CD','A040');
            searchForm.getField('ELEC_SLIP_TYPE_CD').setReadOnly(true);
            
            searchForm.setValue('PERSON_NUMB',UserInfo.personNumb);
            searchForm.setValue('NAME',personName);
            searchForm.setValue('PERSON_DEPT_NAME',UserInfo.deptName);
            
// var calcDate = UniDate.get('today');
// calcDate = UniDate.add(UniDate.getDbDateStr(calcDate), {months: -2});
        /*
		 * searchForm.setValue('APPR_DATE_FR',UniDate.get('twoMonthsAgo'));
		 * searchForm.setValue('APPR_DATE_TO',UniDate.get('today'));
		 * 
		 * searchForm.setValue('CARD_EXPENSE_ID',UserInfo.personNumb);
		 * searchForm.setValue('CARD_EXPENSE_NAME',personName);
		 * 
		 * masterForm.setValue('SLIP_STAT_CD','0');
		 */
            
            if(BsaCodeInfo.hiddenCheck_1 == 'Y'){
                Ext.getCmp('globalAttribute2').setHidden(false);
                Ext.getCmp('globalAttribute3').setHidden(false);
                Ext.getCmp('temp1code').setHidden(false);
                
                Ext.getCmp('payMetoCd').setHidden(false);
                Ext.getCmp('payTermsCd').setHidden(false);
                Ext.getCmp('bankType').setHidden(false);
       
                
                masterForm.getField("GLOBAL_ATTRIBUTE2").setConfig('allowBlank',false);
                masterForm.getField("GLOBAL_ATTRIBUTE3").setConfig('allowBlank',false);
                masterForm.getField("TEMP1CODE").setConfig('allowBlank',false);
                
                masterForm.getField("PAY_METO_CD").setConfig('allowBlank',false);
                masterForm.getField("PAY_TERMS_CD").setConfig('allowBlank',false);
                masterForm.getField("BANK_TYPE").setConfig('allowBlank',false);
                
            }else{
            	Ext.getCmp('globalAttribute2').setHidden(true);
                Ext.getCmp('globalAttribute3').setHidden(true);
                Ext.getCmp('temp1code').setHidden(true);
                
                Ext.getCmp('payMetoCd').setHidden(true);
                Ext.getCmp('payTermsCd').setHidden(true);
                Ext.getCmp('bankType').setHidden(true);
                
                masterForm.getField("GLOBAL_ATTRIBUTE2").setConfig('allowBlank',true);
                masterForm.getField("GLOBAL_ATTRIBUTE3").setConfig('allowBlank',true);
                masterForm.getField("TEMP1CODE").setConfig('allowBlank',true);
                
                masterForm.getField("PAY_METO_CD").setConfig('allowBlank',true);
                masterForm.getField("PAY_TERMS_CD").setConfig('allowBlank',true);
                masterForm.getField("BANK_TYPE").setConfig('allowBlank',true);
                
            }
            
            if(BsaCodeInfo.hiddenCheck_2 == 'Y'){
            	Ext.getCmp('payType').setHidden(false);
                Ext.getCmp('makeSale').setHidden(false);
                detailForm.getField("PAY_TYPE").setConfig('allowBlank',false);
                detailForm.getField("MAKE_SALE").setConfig('allowBlank',false);
            }else{
                Ext.getCmp('payType').setHidden(true);
                Ext.getCmp('makeSale').setHidden(true);
                detailForm.getField("PAY_TYPE").setConfig('allowBlank',true);
                detailForm.getField("MAKE_SALE").setConfig('allowBlank',true);
                
            }
            
            if(BsaCodeInfo.hiddenCheck_3 == 'Y'){
                Ext.getCmp('pjts').setHidden(false);
// detailForm.getField("PJT_CODE").setConfig('allowBlank',false);
            }else{
                Ext.getCmp('pjts').setHidden(true);
// detailForm.getField("PJT_CODE").setConfig('allowBlank',true);
            }
            
            if(BsaCodeInfo.hiddenCheck_4 == 'Y'){
                Ext.getCmp('orgAccnt').setHidden(false);
                Ext.getCmp('payDate').setHidden(false);
                
// detailForm.getField("ORG_ACCNT").setConfig('allowBlank',false);
                masterForm.getField("PAY_DATE").setConfig('allowBlank',false);
            }else{
                Ext.getCmp('orgAccnt').setHidden(true);
                Ext.getCmp('payDate').setHidden(true);
                
                detailForm.getField("ORG_ACCNT").setConfig('allowBlank',true);
                masterForm.getField("PAY_DATE").setConfig('allowBlank',true);
            }
            
            if(BsaCodeInfo.hiddenCheck_5 == 'Y'){
                Ext.getCmp('itemCode').setHidden(false);
// detailForm.getField("ITEM_CODE").setConfig('allowBlank',false);
            }else{
                Ext.getCmp('itemCode').setHidden(true);
// detailForm.getField("ITEM_CODE").setConfig('allowBlank',true);
            }
            
        	this.setMasterDefault();

            masterForm.setValue('FILE_NO','');
//			fileUploadForm.down('#uploadDisabled').disable(true);
            
            masterForm.setValue('APPLICANT_ID', UserInfo.personNumb);
            masterForm.setValue('APPLICANT_NAME', personName);
        },
        
        fnAcctAmtChange1: function(){   // 경비처리 금액 계산 관련
            var detailData = directDetailStore.data.items;
            
            var drAmtISum = 0;
            
            Ext.each(detailData, function(record,i){
                if(record.get('LINE_TYPE_CD') != 'TAX'){
                    drAmtISum = drAmtISum + record.get('DR_AMT_I');
                }
            });
            if(masterForm.getValue('INVOICE_AMT') - drAmtISum == 0){
                detailForm.setValue('ACCT_AMT',0);
            }else{
                detailForm.setValue('ACCT_AMT',masterForm.getValue('INVOICE_AMT') - drAmtISum);
            }
            /*
			 * if(!Ext.isEmpty(masterForm.getValue('TAX_CD'))){
			 * if(masterForm.getField("TAX_CD").selection.data.option == 'Y' ){
			 * 
			 * if(masterForm.getValue('INVOICE_AMT') -
			 * masterForm.getValue('ATTRIBUTE2') - drAmtISum == 0){
			 * detailForm.setValue('ACCT_AMT',0); }else{
			 * detailForm.setValue('ACCT_AMT',masterForm.getValue('INVOICE_AMT') -
			 * masterForm.getValue('ATTRIBUTE2') - drAmtISum); } }else{
			 * if(masterForm.getValue('INVOICE_AMT') - drAmtISum == 0){
			 * detailForm.setValue('ACCT_AMT',0); }else{
			 * detailForm.setValue('ACCT_AMT',masterForm.getValue('INVOICE_AMT') -
			 * drAmtISum); } } }else{ detailForm.setValue('ACCT_AMT',0); }
			 */
        },
        
        fileUploadLoad: function(){
        	var fp = fileUploadForm.down('xuploadpanel');                 //mask on
            fp.getEl().mask('로딩중...','loading-indicator');
            var fileNO = masterForm.getValue('FILE_NO');
            aep150ukrService.getFileList({DOC_NO : fileNO},              //파일조회 메서드  호출(param - 파일번호) 
                function(provider, response) {                          
                    fp.loadData(response.result);                       //업로드 파일 load해서 보여주기
                    fp.getEl().unmask();                                //mask off
                }
             )
        },

        fnAcctAmtChange2: function(){  // 삭제시 경비처리 금액 계산 관련
            var detailData = directDetailStore.data.items;
            
            var drAmtISum = 0;
            
            Ext.each(detailData, function(record,i){
                if(record.get('LINE_TYPE_CD') != 'TAX'){
                    drAmtISum = drAmtISum + record.get('DR_AMT_I');
                }
            });
             if(masterForm.getValue('INVOICE_AMT') + drAmtISum == 0){
                detailForm.setValue('ACCT_AMT',0);
            }else{
                detailForm.setValue('ACCT_AMT',masterForm.getValue('INVOICE_AMT') - drAmtISum);
            }
        /*
		 * if(!Ext.isEmpty(masterForm.getValue('TAX_CD'))){
		 * if(masterForm.getField("TAX_CD").selection.data.option == 'Y' ){
		 * 
		 * if(masterForm.getValue('INVOICE_AMT') -
		 * masterForm.getValue('ATTRIBUTE2') + drAmtISum == 0){
		 * detailForm.setValue('ACCT_AMT',0); }else{
		 * detailForm.setValue('ACCT_AMT',masterForm.getValue('INVOICE_AMT') -
		 * masterForm.getValue('ATTRIBUTE2') - drAmtISum); } }else{
		 * if(masterForm.getValue('INVOICE_AMT') + drAmtISum == 0){
		 * detailForm.setValue('ACCT_AMT',0); }else{
		 * detailForm.setValue('ACCT_AMT',masterForm.getValue('INVOICE_AMT') -
		 * drAmtISum); } } }else{ detailForm.setValue('ACCT_AMT',0); }
		 */        
        },
        
        fnSelectAccntData: function(param){
            aep150ukrService.selectAccntData(param, function(provider, response)   {
                if(!Ext.isEmpty(provider)){
                    Ext.each(provider, function(record,i){
                        
                        if(Ext.isEmpty(provider[0].ACCNT)){
                            Ext.Msg.alert(Msg.sMB099,"지출유형과 원가구분에 mapping된 계정코드가 존재하지 않습니다. 계정과목을 직접 등록하십시오.");
                        }else{
                            detailForm.setValue('ACCT_CD'       ,provider[0].ACCNT);   
                            detailForm.setValue('ACCT_NM'       ,provider[0].ACCNT_NAME);   
                        
                            if(BsaCodeInfo.hiddenCheck_3 == 'Y'){
                                if(provider[0].PJT_CODE_YN == 'Y'){
                                    detailForm.getField("PJT_CODE").setConfig('allowBlank',false);                                                 
                                }else{
                                    detailForm.getField("PJT_CODE").setConfig('allowBlank',true);
                                }
                            }else{
                                detailForm.getField("PJT_CODE").setConfig('allowBlank',true);
                            }
                            if(BsaCodeInfo.hiddenCheck_4 == 'Y'){
                                if(provider[0].ORG_ACCNT_YN == 'Y'){
                                    detailForm.getField("ORG_ACCNT").setConfig('allowBlank',false);                                                 
                                }else{
                                    detailForm.getField("ORG_ACCNT").setConfig('allowBlank',true);
                                }
                            }else{
                                detailForm.getField("ORG_ACCNT").setConfig('allowBlank',true);
                            }
                            if(BsaCodeInfo.hiddenCheck_5 == 'Y'){
                                if(provider[0].ITEM_CODE_YN == 'Y'){
                                    detailForm.getField("ITEM_CODE").setConfig('allowBlank',false);                                                 
                                }else{
                                    detailForm.getField("ITEM_CODE").setConfig('allowBlank',true);
                                }
                            }else{
                                detailForm.getField("ITEM_CODE").setConfig('allowBlank',true);
                            }
                            
                            detailForm.setValue('ITEM_DESC',UniDate.getDbDateStr(masterForm.getValue('GL_DATE')) + 
                            '_' + detailForm.getValue('COST_DEPT_NM') + '_' + provider[0].ACCNT_NAME);
                            
                            
                            if(!Ext.isEmpty(provider[0].ACCNT) && !Ext.isEmpty(detailForm.getValue('COST_DEPT_CD'))){  
                                var param2 = {
                                    "BUDG_YYYYMM": UniDate.getDbDateStr(masterForm.getValue('GL_DATE')),
                                    "ACCNT": provider[0].ACCNT,
                                    "DEPT_CODE": detailForm.getValue('COST_DEPT_CD')
                                };
                                UniAppManager.app.fnPossibleBudgAmt110(param2);
                            
                            }
                            
                        }
                    })
                }else{
                    Ext.Msg.alert(Msg.sMB099,"지출유형과 원가구분에 mapping된 계정코드가 존재하지 않습니다. 계정과목을 직접 등록하십시오.");
                }
            })
        },
        
        fnPossibleBudgAmt110: function(param){
            aep150ukrService.spAccntGetPossibleBudgAmt110(param, function(provider, response)   {
                if(!Ext.isEmpty(provider)){
                    detailForm.setValue('AMTBG',provider[0].BUDG_I);
                    detailForm.setValue('AMTRM',provider[0].BALN_I);
                }else{
                    detailForm.setValue('AMTBG',0);
                    detailForm.setValue('AMTRM',0);
                }
            })
        },
        
        fnCreateRow: function(){
            var dcDivCd     = 'D';   
            var acctCd      = detailForm.getValue('ACCT_CD');     
            var acctNm      = detailForm.getValue('ACCT_NM');    
            var costDeptCd  = detailForm.getValue('COST_DEPT_CD');
            var costDeptNm  = detailForm.getValue('COST_DEPT_NM');
// var attribute2 = detailForm.getValue('ATTRIBUTE2');
            
            var crAmtI      = 0; 
            var taxCd       = detailForm.getValue('TAX_CD');
            var itemDescUse    = detailForm.getValue('ITEM_DESC_USE');   
            var itemDesc    = detailForm.getValue('ITEM_DESC'); 
            
            var drAmtI      = detailForm.getValue('ACCT_AMT');    // 차변금액으로
																	// DR_AMT_I
// var aquiServ = detailForm.getValue('AQUI_SERV');
            var payType     = detailForm.getValue('PAY_TYPE');    
            var makeSale    = detailForm.getValue('MAKE_SALE');   
            var pjtCode     = detailForm.getValue('PJT_CODE');   
            var pjtName     = detailForm.getValue('PJT_NAME');   
            var orgAccnt    = detailForm.getValue('ORG_ACCNT');
            var orgAccntNm    = detailForm.getValue('ORG_ACCNT_NM');
            var payDate    = masterForm.getValue('PAY_DATE');
            
            var elecSlipNo    = masterForm.getValue('ELEC_SLIP_NO');  
            
            var itemCode    = detailForm.getValue('ITEM_CODE');
            var itemName    = detailForm.getValue('ITEM_NAME');
              
            var lineTypeCd  = 'ITEM'
            
            var r = {
                DC_DIV_CD:       dcDivCd,            
                ACCT_CD:         acctCd,             
                ACCT_NM:         acctNm,             
                COST_DEPT_CD:    costDeptCd,         
                COST_DEPT_NM:    costDeptNm,        
// ATTRIBUTE2: attribute2,
                                                   
                CR_AMT_I:        crAmtI,
                TAX_CD:          taxCd,
                ITEM_DESC_USE:       itemDescUse,           
                ITEM_DESC:       itemDesc,           
                                                    
                DR_AMT_I:        drAmtI,             
// AQUI_SERV: aquiServ,
                PAY_TYPE:        payType,            
                MAKE_SALE:       makeSale,           
                PJT_CODE:        pjtCode, 
                PJT_NAME:        pjtName,            
                ORG_ACCNT:       orgAccnt,
                ORG_ACCNT_NM:    orgAccntNm,
                PAY_DATE:        payDate,
                
                ELEC_SLIP_NO:    elecSlipNo,
                
                ITEM_CODE:      itemCode,
                ITEM_NAME:      itemName,
        
                LINE_TYPE_CD:   lineTypeCd
                
            };
            detailGrid.createRow(r);
            
            if(BsaCodeInfo.paySysGubun == '1'){
                detailForm.setValue('ACCT_CD','');
                detailForm.setValue('ACCT_NM','');
                detailForm.setValue('AMTBG',0);
                detailForm.setValue('AMTRM',0);
            }else{
                detailForm.clearForm();
            }
        
            UniAppManager.app.fnAcctAmtChange1();
        },
        
        fnTaxCalc: function(){   // 소득세 , 지방세 , 실지급액 계산 관련
        	var invoiceAmt = 0;                // 총금액
        	var incomeTaxAcctAmt = 0;          // 소득세 INCOME_TAX_ACCT_AMT
        	var rsdTaxAcctAmt = 0;             // 지방세 RSD_TAX_ACCT_AMT
        	var creditAcctAmt = 0;             // 실지급액 CREDIT_ACCT_AMT
        	
        	var incomeTaxRefCode1 = 0;         // J699 REF_CODE1
        	var incomeTaxRefCode3 = 0;         // J699 REF_CODE3
        	var incomeTaxRefCode6 = '';        // J699 REF_CODE6
        	
        	var tempCalc = 0;
        	
        	if(!Ext.isEmpty(masterForm.getValue('INCOME_TAX_ATTRIBUTE13'))){
                incomeTaxRefCode6 = masterForm.getField("INCOME_TAX_ATTRIBUTE13").selection.data.refCode6;
                incomeTaxRefCode3 = masterForm.getField("INCOME_TAX_ATTRIBUTE13").selection.data.refCode3;
                incomeTaxRefCode1 = masterForm.getField("INCOME_TAX_ATTRIBUTE13").selection.data.refCode1;
        	}else{
        		incomeTaxRefCode6 = '';
        		incomeTaxRefCode3 = 0;
        		incomeTaxRefCode1 = 0;
        	}
        	
        	invoiceAmt = masterForm.getValue('INVOICE_AMT');
        	
	        if (masterForm.getValue('INCOME_TAX_ATTRIBUTE13') == '03_K1') {		//원천세 유형이 "일용직근로소득 (일당10만원 초과 일 경우)" - (일당-100,0000 * 세율)
	        	tempCalc = (masterForm.getValue('ATTRIBUTE7') - 100000) * masterForm.getValue('ATTRIBUTE8')
	        	
	        } else {
	        	if(incomeTaxRefCode6 == 'P1'){
	                tempCalc = invoiceAmt - incomeTaxRefCode3;
	        	}else if(incomeTaxRefCode6 == 'P2'){
	        	   	tempCalc = invoiceAmt - invoiceAmt * 0.8;
	        	}else{
	        		tempCalc = invoiceAmt;
	        	}
	        }
        	
        	incomeTaxAcctAmt = tempCalc * incomeTaxRefCode1 / 100;
        	incomeTaxAcctAmt = Math.floor(incomeTaxAcctAmt / 10) * 10;
        	
        	if(incomeTaxAcctAmt < 1000){ // / 1000 보다 작으면 0 원 만드는것 아닌듯 확인필요
        		incomeTaxAcctAmt = 0;
        	}
        	
        	rsdTaxAcctAmt = incomeTaxAcctAmt * 0.1;
        	rsdTaxAcctAmt = Math.floor(rsdTaxAcctAmt / 10) * 10;
        	
        	creditAcctAmt = invoiceAmt - incomeTaxAcctAmt - rsdTaxAcctAmt;
        	
        	masterForm.setValue('INCOME_TAX_ACCT_AMT',incomeTaxAcctAmt);
            masterForm.setValue('RSD_TAX_ACCT_AMT',rsdTaxAcctAmt);
            masterForm.setValue('CREDIT_ACCT_AMT',creditAcctAmt);
        },
        
        fnDateCalc: function(){
        	if(!Ext.isEmpty(masterForm.getValue('ATTRIBUTE5')) && !Ext.isEmpty(masterForm.getValue('ATTRIBUTE6'))){
            	var frYear = UniDate.getDbDateStr(masterForm.getValue('ATTRIBUTE5')).substring(0,4);
            	var toYear = UniDate.getDbDateStr(masterForm.getValue('ATTRIBUTE6')).substring(0,4);
            	var frMonth = UniDate.getDbDateStr(masterForm.getValue('ATTRIBUTE5')).substring(4,6);
                var toMonth = UniDate.getDbDateStr(masterForm.getValue('ATTRIBUTE6')).substring(4,6);
                var frDay = UniDate.getDbDateStr(masterForm.getValue('ATTRIBUTE5')).substring(6,8);
                var toDay = UniDate.getDbDateStr(masterForm.getValue('ATTRIBUTE6')).substring(6,8);
                
            	var startDate = new Date(parseInt(frYear), parseInt(frMonth)-1, parseInt(frDay));
                var endDate   = new Date(parseInt(toYear), parseInt(toMonth)-1, parseInt(toDay));
                
                var tempMs = endDate.getTime() - startDate.getTime();
                var tempDay = tempMs / (1000*60*60*24);
                
                dateStFr = tempDay+1;
                
                masterForm.setValue('ATTRIBUTE8',tempDay+1);
                
                masterForm.setValue('INVOICE_AMT', masterForm.getValue('ATTRIBUTE8') * masterForm.getValue('ATTRIBUTE7'));
                
                UniAppManager.app.fnTaxCalc();
                
                UniAppManager.app.fnAcctAmtChange1();
            
        	}
        },
        
        fnDateStFrCheck: function(){
        
            if(masterForm.getValue('INCOME_TAX_ATTRIBUTE13') == '03_K1'){
                if(masterForm.getValue('ATTRIBUTE8') >  dateStFr){
                    alert("일수보다 시작일자와 종료일자 차이일수가 작습니다.\n일수 : "+ masterForm.getValue('ATTRIBUTE8') + "\n기간일수 : " + dateStFr);
                    return false;
                }
            }
            
            UniAppManager.app.fnCreateRow();
        }
        
    });
    
    
    
    Unilite.createValidator('validator01', {
        store: directDetailStore,
        grid: detailGrid,
        validate: function( type, fieldName, newValue, oldValue, record, eopt) {
        console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
            var rv = true;
            switch(fieldName) {
            
            }
        	return rv;
        }
    }); 
    
            
    Unilite.createValidator('validator02', {
        forms: {'formA:':detailForm},
        validate: function( type, fieldName, newValue, lastValidValue, record, form, field) {
            console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'lastValidValue':lastValidValue, 'record':record});
            var rv = true;  
            switch(fieldName) { 
// case fieldName:
// UniAppManager.setToolbarButtons('save',true);
// break;
            }
            return rv;
        }
    });     
};

</script>
<form id="f1" name="f1" action="http://ep.joinsdev.net/WebSite/Approval/FormLinkForLEGACY.aspx" method="post" onSubmit="return false;" >
<input type="hidden" id="loginid" name="loginid" value="superadmin" />
<input type="hidden" id="fmpf" name="fmpf" value="WF_COST_MIS_REQ" />
<input type="hidden" id="fmbd" name="fmbd" runat="server" />
</form>