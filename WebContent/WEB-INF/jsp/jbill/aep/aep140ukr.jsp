<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="aep140ukr"  >
    <t:ExtComboStore comboType="AU" comboCode="J501" /> <!-- 채권구분 -->
    <t:ExtComboStore comboType="AU" comboCode="J502" /> <!-- 이관취소사유 -->
    <t:ExtComboStore comboType="AU" comboCode="J504" /> <!-- 진행상태 -->
    <t:ExtComboStore comboType="AU" comboCode="J504" /> <!-- 관리구분 -->
    <t:ExtComboStore comboType="AU" comboCode="A134" /> <!-- 결재상태 -->
    <t:ExtComboStore comboType="AU" comboCode="J682" /> <!-- 전표상태 -->
    <t:ExtComboStore comboType="AU" comboCode="A177" /> <!-- 경비유형 -->
    <t:ExtComboStore comboType="AU" comboCode="A006" /> <!-- 원가구분 -->
    <t:ExtComboStore comboType="AU" comboCode="J518" /> <!-- 전표유형 -->    
    <t:ExtComboStore comboType="AU" comboCode="J668" /> <!-- 지급방법코드 -->
    
    <t:ExtComboStore comboType="AU" comboCode="J653" opts= '10;15' /> <!-- 처리상태 -->
    
   
    <t:ExtComboStore items="${COMBO_INDUS_CODE}" storeId="indusCodeList" />         <!--사업장-->
    <t:ExtComboStore items="${COMBO_DIV_CODE}" storeId="divCodeList" />             <!--사업장-->
    <t:ExtComboStore items="${COMBO_BUSINESS_AREA}" storeId="businessAreaList" />   <!--사업영역-->
    <t:ExtComboStore items="${COMBO_TAX_CD}" storeId="taxCdList" />                 <!--세금코드-->
    <t:ExtComboStore items="${COMBO_PAY_TERM_CD}" storeId="payTermCdList" />                 <!--지급조건-->
    <t:ExtComboStore items="${COMBO_BANK_TYPE}" storeId="bankType" />               <!--입급계좌-->

</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>    

<script type="text/javascript" charset="UTF-8" src='<c:url value="/resources/plupload/plupload.full.js" />' >
//  ↑ 파일uplod용 plupload.full.js파일 include
</script>
<script type="text/javascript" >


var BsaCodeInfo = { 
	hiddenCheck_1: '${hiddenCheck_1}',
	hiddenCheck_2: '${hiddenCheck_2}',
	hiddenCheck_3: '${hiddenCheck_3}',
    hiddenCheck_4: '${hiddenCheck_4}',
    hiddenCheck_5: '${hiddenCheck_5}',
    
    paySysGubun: '${paySysGubun}'      //MIS , SAP 구분관련
};

var elecSlipTransWindow; //전표이관
var personName   = '${personName}';

//var getChargeCode = ${getChargeCode};
//
//if(getChargeCode == '' ){
//    getChargeCode = [{"SUB_CODE":""}];
//}

var detailGridClickFlag = '';

var buttonFlag = '';

var preEmpNo = '';
var nxtEmpNo = '';
var transDesc = '';

var gsCustomCode   = '${gsCustomCode}';
var gsCustomName   = '${gsCustomName}';
var gsCompanyNum   = '${gsCompanyNum}';
var aaa = '안녕"';
var SAVE_FLAG = '';

var loadFlag = '';

function appMain() {
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 'aep140ukrService.selectDetailList',
            update: 'aep140ukrService.updateDetail',
            create: 'aep140ukrService.insertDetail',
            destroy: 'aep140ukrService.deleteDetail',
            syncAll: 'aep140ukrService.saveAll'
        }
    }); 
    
    var directButtonProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            create: 'aep140ukrService.insertButton',
            syncAll: 'aep140ukrService.saveButtonAll'
        }
    }); 
    var directProxyRequest = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            create: 'aep140ukrService.insertDetailRequest',
            syncAll: 'aep140ukrService.saveAllRequest'
        }
    }); 
    
    
    Unilite.defineModel('aep140ukrSearchModel', {
        fields: [
            {name: 'SELECT'             ,text: '선택'         ,type: 'boolean'},
            {name: 'SLIP_STAT_CD'       ,text: '전표상태'      ,type: 'string',comboType:'AU', comboCode:'J682'},
            {name: 'RNUM'               ,text: 'NO'         ,type: 'string'},
            {name: 'ETAX_CHECK'         ,text: '작성'         ,type: 'string'},
            {name: 'ELEC_SLIP_NO'       ,text: '전표번호'      ,type: 'string'},
            {name: 'REG_DT'             ,text: '작성일자'      ,type: 'uniDate'},
            {name: 'DTI_WDATE'          ,text: '발행일자'      ,type: 'uniDate'},
            {name: 'REG_NM'             ,text: '작성자'       ,type: 'string'},
            {name: 'ETAX_STATUS_CD'     ,text: '처리상태'      ,type: 'string',comboType:'AU', comboCode:'J653'},
            {name: 'CONVERSATION_ID'    ,text: '승인번호'      ,type: 'string'},
            {name: 'CREATION_DATE'      ,text: '전송일자'      ,type: 'uniDate'},
            {name: 'FR_VENDOR_SITE_CD'      ,text: '사업자번호'     ,type: 'string'},
            {name: 'FR_VENDOR_NM'       ,text: '거래처명'      ,type: 'string'},
            {name: 'SUP_AMOUNT'         ,text: '공급가액'      ,type: 'uniPrice'},
            {name: 'TAX_AMOUNT'         ,text: '부가세액'      ,type: 'uniPrice'},
            {name: 'TOTAL_AMOUNT'       ,text: '총금액'       ,type: 'uniPrice'},
            {name: 'FR_VENDOR_BUSINESS_CONDITION'   ,text: '업종'         ,type: 'string'},
            {name: 'FR_VENDOR_BUSINESS_TYPE'       ,text: '업태'         ,type: 'string'},
//            {name: 'UPLOAD_EMPLOYEE_NO' ,text: '담담 사용자사번'  ,type: 'string'},
//            {name: 'EMPLOYEE_KOR_NAME'  ,text: '담당자'        ,type: 'string'},
//            {name: 'kostl_nm'           ,text: '비용부서명'     ,type: 'string'},
            {name: 'SUP_EMAIL'          ,text: '공급자이메일'    ,type: 'string'},
            {name: 'BYR_EMAIL'          ,text: '공급받는자이메일' ,type: 'string'},
            {name: 'BYR_EMP_NAME'       ,text: '구매 담당자'     ,type: 'string'},
            {name: 'REMARK'             ,text: '내역'         ,type: 'string'},
//            {name: 'KOSTL'              ,text: '비용부서'      ,type: 'string'},
            
            {name: 'FR_VENDOR_ID'        ,text: '공급자(거래처)'       ,type: 'string'},
            {name: 'FR_VENDOR_SITE_CD'      ,text: '공급자(등록번호)'      ,type: 'string'},
            {name: 'FR_VENDOR_NM'       ,text: '공급자(상호(법인명))'   ,type: 'string'},
            {name: 'FR_VENDOR_CEO_NAME'       ,text: '공급자(성명(대표자))'   ,type: 'string'},
            {name: 'FR_VENDOR_ADDRESS'       ,text: '공급자(사업장주소)'     ,type: 'string'},
            {name: 'FR_VENDOR_BUSINESS_TYPE'       ,text: '공급자(업태)'         ,type: 'string'},
            {name: 'FR_VENDOR_BUSINESS_CONDITION'   ,text: '공급자(업종)'         ,type: 'string'},
            {name: 'TO_VENDOR_ID'           ,text: '공급받는자(사업장)'     ,type: 'string'},
            {name: 'TO_VENDOR_SITE_CD'      ,text: '공급받는자(등록번호)'    ,type: 'string'},
            {name: 'TO_VENDOR_NM'       ,text: '공급받는자(상호(법인명))' ,type: 'string'},
            {name: 'TO_VENDOR_CEO_NAME'       ,text: '공급받는자(성명(대표자))' ,type: 'string'},
            {name: 'TO_VENDOR_ADDRESS'       ,text: '공급받는자(사업장주소)'   ,type: 'string'},
            {name: 'TO_VENDOR_BUSINESS_TYPE'       ,text: '공급받는자(업태)'       ,type: 'string'},
            {name: 'TO_VENDOR_BUSINESS_CONDITION'   ,text: '공급받는자(업종)'       ,type: 'string'}

        ]
    });
    
    
    Unilite.defineModel('aep140ukrDetailModel', {
        fields: [
            {name: 'ELEC_SLIP_NO'    ,text: '전표관리번호'       ,type: 'string'},
            
            {name: 'SEQ'             ,text: 'SEQ'       ,type: 'int'},
            
            {name: 'LINE_TYPE_CD'    ,text: '차변TAX구분'       ,type: 'string'},
            
            {name: 'DC_DIV_CD'       ,text: '유형'            ,type: 'string',comboType:'AU', comboCode:'J518'},
            {name: 'ACCT_CD'         ,text: '계정코드'         ,type: 'string',allowBlank:false},
            {name: 'ACCT_NM'         ,text: '계정명'          ,type: 'string'},
            {name: 'COST_DEPT_CD'    ,text: '귀속부서'         ,type: 'string',allowBlank:false},
            {name: 'COST_DEPT_NM'    ,text: '귀속부서명'        ,type: 'string'},
            {name: 'TAX_CD'          ,text: '세금'           ,type: 'string',store: Ext.data.StoreManager.lookup('taxCdList'),allowBlank:false},
            {name: 'DR_AMT_I'        ,text: '차변금액'        ,type: 'uniPrice',allowBlank:false},
            {name: 'CR_AMT_I'        ,text: '대변금액'        ,type: 'uniPrice'},
            {name: 'ITEM_DESC_USE'       ,text: '사용내역'        ,type: 'string',allowBlank:false},
            {name: 'ITEM_DESC'       ,text: '적요'           ,type: 'string',allowBlank:false},
            
//            {name: 'ACCT_AMT'        ,text: '경비처리금액'           ,type: 'uniPrice'},
//            {name: 'AQUI_SERV'       ,text: '봉사료'           ,type: 'uniPrice'},
            {name: 'PAY_TYPE'        ,text: '경비유형'           ,type: 'string'},
            {name: 'MAKE_SALE'       ,text: '원가구분'           ,type: 'string'},
            {name: 'PJT_CODE'        ,text: '사업코드'           ,type: 'string'},
            {name: 'PJT_NAME'        ,text: '사업명'           ,type: 'string'},
            {name: 'ORG_ACCNT'       ,text: '본계정'           ,type: 'string'},
            {name: 'ORG_ACCNT_NM'       ,text: '본계정명'           ,type: 'string'},
            {name: 'PAY_DATE'       ,text: '지급요청일'           ,type: 'uniDate'},
            
            {name: 'ITEM_CODE'       ,text: '제품코드'           ,type: 'string'},
            {name: 'ITEM_NAME'       ,text: '제품명'           ,type: 'string'},   
            
            {name: 'FILE_UPLOAD_FLAG'	,text: '파일업로드관련'           ,type: 'string'}
        ]
    });
    
    
    
    var buttonStore = Unilite.createStore('Aep140ukrButtonStore',{      
        uniOpt: {
            isMaster: false,            // 상위 버튼 연결 
            editable: false,            // 수정 모드 사용 
            deletable: false,           // 삭제 가능 여부 
            useNavi : false         // prev | newxt 버튼 사용
        },
        proxy: directButtonProxy,
        saveStore: function() {             
            var inValidRecs = this.getInvalidRecords();
//          var toCreate = branchStore.data.items;
            var toCreate = this.getNewRecords();
            var toUpdate = this.getUpdatedRecords();                
            var toDelete = this.getRemovedRecords();
//              var paramList = branchStore.data.items;
            var paramMaster = searchForm.getValues();   
            
            paramMaster.buttonFlag = buttonFlag;
            
            if(buttonFlag == 'btnConf'){
            	
            	paramMaster.preEmpNo = preEmpNo;
                paramMaster.nxtEmpNo = nxtEmpNo;
                paramMaster.transDesc = transDesc;
            }
            
//          param.FR_INPUT_DATE = UniDate.getDbDateStr(panelSearch.getValue('FR_INPUT_DATE'));
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
                var grid = Ext.getCmp('aep140ukrSearchGrid');
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
    
    var requestStore = Unilite.createStore('Aep140ukrRequestStore',{      
        uniOpt: {
            isMaster: false,            // 상위 버튼 연결 
            editable: false,            // 수정 모드 사용 
            deletable: false,           // 삭제 가능 여부 
            useNavi : false         // prev | newxt 버튼 사용
        },
        proxy: directProxyRequest,
        saveStore: function() {             
            
            var paramMaster = searchForm.getValues(); 
//          param.FR_INPUT_DATE = UniDate.getDbDateStr(panelSearch.getValue('FR_INPUT_DATE'));
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
                            mercNmStr = record.get('FR_VENDOR_NM');
                        }
                        aquiSumStr = aquiSumStr + record.get('TOTAL_AMOUNT');
                        
                    });
                    if(requestRecords.length > 1){
                        mercNmStr = mercNmStr + " 외 " + (requestRecords.length-1) + "건";
                    }else{
                        mercNmStr = mercNmStr;
                    }
                    
                    var apprDateFr = '';
                    var apprDateTo = '';
                    
                    if(Ext.isEmpty(searchForm.getValue('DATE_FR'))){
                        apprDateFr = '';
                    }else{
                        apprDateFr = UniDate.getDbDateStr(searchForm.getValue('DATE_FR'));
                        apprDateFr = apprDateFr.substring(0,4) + '.' + apprDateFr.substring(4,6) + '.' + apprDateFr.substring(6,8);
                    }
                    if(Ext.isEmpty(searchForm.getValue('DATE_TO'))){
                        apprDateTr = '';
                    }else{
                        apprDateTr = UniDate.getDbDateStr(searchForm.getValue('DATE_TO'));
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
                    requestMsg = requestMsg + '<subject>'+ '경비처리 전자세금계산서(계산서) 결재' +'</subject>';
                    requestMsg = requestMsg + '</item>';
                    requestMsg = requestMsg + '<content><![CDATA[';
                    requestMsg = requestMsg + '<table style="border-collapse:collapse; border:1px gray solid; margin:20px 0 20px 0; word-break:break-all;" width= "100%" align="center">';
                    requestMsg = requestMsg + '<tr style="border:1px gray solid;padding: 5px 10px;">';
                    
                    requestMsg = requestMsg + '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6" height= "20", width = "25%">';
                    requestMsg = requestMsg + '발행일자';
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
    
    
    var directSearchStore = Unilite.createStore('aep140ukrSearchStore', {
        model: 'aep140ukrSearchModel',
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
                read: 'aep140ukrService.selectSearchList'                 
            }
        },
        
        listeners: {
            load: function(store, records, successful, eOpts) {
            	if(store.count() == 0) { 
                    detailGrid.disable(true);
                	fileUploadForm.down('#uploadDisabled').disable();
                }else{
                    detailGrid.enable(true);
            		fileUploadForm.down('#uploadDisabled').enable();
                }
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
    
    
    var directDetailStore = Unilite.createStore('aep140ukrDetailStore', {
        model: 'aep140ukrDetailModel',
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
            if(directDetailStore.data.items.length > 0){
                paramMaster.SLIP_DESC = directDetailStore.data.items[0].data.ITEM_DESC_USE;
            }
//            paramMaster.GL_DATE              = masterForm.getValue('GL_DATE'); 
//            paramMaster.ELEC_SLIP_NO         = masterForm.getValue('ELEC_SLIP_NO'); 
//            paramMaster.GLOBAL_ATTRIBUTE2    = masterForm.getValue('GLOBAL_ATTRIBUTE2'); 
//            paramMaster.GLOBAL_ATTRIBUTE3    = masterForm.getValue('GLOBAL_ATTRIBUTE3'); 
//            paramMaster.INVOICE_AMT          = masterForm.getValue('INVOICE_AMT'); 
//            paramMaster.ATTRIBUTE2           = masterForm.getValue('ATTRIBUTE2'); 
            
            
            if(inValidRecs.length == 0) {
                config = {
                    params: [paramMaster],
                    success: function(batch, option) {
                        var master = batch.operations[0].getResultSet();
                        
                        masterForm.setValue("ELEC_SLIP_NO", master.ELEC_SLIP_NO);
                        masterForm.setValue("FILE_NO", master.ELEC_SLIP_NO);
                        
                       var searchGridSelectedRecord = searchGrid.getSelectedRecord();
                        
                        if(masterForm.getValue('ELEC_SLIP_NO') != ''){
                            searchGridSelectedRecord.set('ELEC_SLIP_NO',master.ELEC_SLIP_NO);       //전표번호       
                            searchGridSelectedRecord.set('ETAX_CHECK','O');         //작성
                            
                            searchGridSelectedRecord.set('SLIP_STAT_CD', '10');     //전표상태
                            searchGridSelectedRecord.set('REG_NM', UserInfo.userName);  //작성자
                            directSearchStore.commitChanges();  
                            
                            directDetailStore.loadStoreRecords(); 
                        }else{
                            searchGridSelectedRecord.set('ELEC_SLIP_NO','');
                            searchGridSelectedRecord.set('ETAX_CHECK','X');
                            directSearchStore.commitChanges();  
                            
                            UniAppManager.app.setMasterDefault();
                        }

                        UniAppManager.app.fileUploadLoad();
                        UniAppManager.setToolbarButtons('save', false);     
                     } 
                };
                this.syncAllDirect(config);
            } else {
                var grid = Ext.getCmp('aep140ukrDetailGrid');
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
//      split:true,
        region: 'north',
        layout : {type : 'uniTable', columns : 3
//            tableAttrs: { /*style: 'border : 1px solid #ced9e7;',*/width: '100%'}
//          tdAttrs: {/*style: 'border : 1px solid #ced9e7;',*/width: '100%'/*,align : 'left'*/}
        },
        padding:'1 1 1 1',
//        border:true,
        disabled:false,
        items: [{ 
            fieldLabel: '발행일자',
            xtype: 'uniDateRangefield',
            startFieldName: 'DATE_FR',
            endFieldName: 'DATE_TO',
            startDate: UniDate.get('startOfMonth'),
            endDate: UniDate.get('today'),
            allowBlank: false
        },
        Unilite.popup('Employee',{
            fieldLabel: '사원정보', 
            valueFieldWidth: 90,
            textFieldWidth: 140,
            valueFieldName:'PERSON_NUMB',
            textFieldName:'NAME',
            colspan:2,
            readOnly:true
        }), 
        Unilite.popup('CUST',{
            fieldLabel: '거래처', 
            valueFieldName:'FR_VENDOR_ID',
            textFieldName:'CUSTOM_NAME'
        }),{
            xtype:'uniTextfield',
            fieldLabel:'승인번호',
            name:'CONVERSATION_ID',
            width:325
        },{
            xtype: 'uniCombobox',
            fieldLabel: '처리상태',
            name:'ETAX_STATUS_CD',   
            comboType:'AU',
            comboCode:'J653'
            // 처리상태 값 10, 15만 콤보에서 나오도록 수정필요 
        },{
            xtype: 'uniTextfield',
            fieldLabel:'전표관리번호', 
            name: 'ELEC_SLIP_NO', 
            labelWidth:165,
            readOnly:true,
       		hidden:true
        }]
    });
    
    var masterForm = Unilite.createForm('masterForm',{
//        split:true,
//       title:'기본사항',
//    	flex:0.9,
        region: 'north',
        layout : {type : 'uniTable', columns : 2
//            tableAttrs: { /*style: 'border : 1px solid #ced9e7;',*/width: '100%'},
//          tdAttrs: {style: 'border : 1px solid #ced9e7;',width: '100%'/*,align : 'left'*/}
    
        },
        padding:'1 1 1 1',
//        border:true,
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
            padding: '10 10 10 0',
            margin: '0 0 0 0',
            defaults: {xtype: 'uniTextfield'},
            layout: {type: 'uniTable' , columns: 1
//                    tdAttrs: {style: 'border : 1px solid #ced9e7;'}
            },
            items: [{
                    
                xtype: 'container',
                layout: {type : 'uniTable', columns : 1},
                border:true,
                padding:'1 1 1 0',
                items:[{
                    xtype: 'container',
                    margin: '0 0 0 0',
                    layout: {type : 'uniTable', columns : 4},          
                    items: [{
                        xtype: 'component',
                        width: 10
                    },{
                        title: '공급자',
                        xtype: 'fieldset',
                        id: 'fieldset2',
                        padding: '0 10 10 10',
                        margin: '0 0 0 0',
                        defaults: {readOnly: true, xtype: 'uniTextfield'},
                        layout: {type: 'uniTable' , columns: 2},
                        items: [
                            {
                            fieldLabel: '거래처',
                            name:'FR_VENDOR_ID',    
                            allowBlank:false
                        },{
                            fieldLabel: '등록번호',
                            name:'FR_VENDOR_SITE_CD',    
                            allowBlank:false
                        }, { 
                            fieldLabel: '상호(법인명)',
                            name: 'FR_VENDOR_NM'
                        }, {
                            fieldLabel: '성명(대표자)',
                            name:'FR_VENDOR_CEO_NAME'     
                        }, {
                            fieldLabel: '사업장주소',
                            name:'FR_VENDOR_ADDRESS',     
                            width: 490,     
                            colspan: 2
                        }, {
                            fieldLabel: '업태',
                            name:'FR_VENDOR_BUSINESS_TYPE'    
                        }, {
                            fieldLabel: '업종',
                            name:'FR_VENDOR_BUSINESS_CONDITION'   
                        }]
                    }, {
                        xtype: 'component',
                        width: 10
                    }, {
                        title   : '공급받는자',
                        padding : '0 10 10 10',
                        margin  : '0 0 0 0',
                        xtype   : 'fieldset',
                        id      : 'fieldset3',
                        defaults: {readOnly: true, xtype: 'uniTextfield'},
                        layout  : {type: 'uniTable' , columns: 2},
                        items   : [{
                            fieldLabel: '사업장',
                            name:'TO_VENDOR_ID',     
                            allowBlank:false
                        },{
                            fieldLabel: '등록번호',
                            name:'TO_VENDOR_SITE_CD',     
                            allowBlank:false
                        }, { 
                            fieldLabel: '상호(법인명)',
                            name: 'TO_VENDOR_NM'
                        }, {
                            fieldLabel: '성명(대표자)',
                            name:'TO_VENDOR_CEO_NAME'     
                        }, {
                            fieldLabel: '사업장주소',
                            name:'TO_VENDOR_ADDRESS',     
                            width: 490,     
                            colspan: 2
                        }, {
                            fieldLabel: '업태',
                            name:'TO_VENDOR_BUSINESS_TYPE'    
                        }, {
                            fieldLabel: '업종',
                            name:'TO_VENDOR_BUSINESS_CONDITION'   
                        }]
                    }]
                }]
            },{
                xtype: 'container',
                layout: {type : 'uniTable', columns : 2},
                border:true,
                padding:'1 1 10 10',
                items:[{
                    xtype: 'component',
                    width: 10
                },{
                
                    xtype: 'container',
                    layout: {type : 'uniTable', columns : 2},
    //                defaults: {xtype: 'uniTextfield'},
                    border:false,
                    padding:'0 0 0 0',
                    items:[{
                        xtype: 'uniDatefield',
                        name: 'REG_DT_NM',
                        fieldLabel: '작성일자',
                        value: UniDate.get('today'),
                        allowBlank: false,
                        holdable: 'hold',
                        listeners: {
                            change: function(field, newValue, oldValue, eOpts) {                        
                            }
                        }                   
                    },{
                        xtype: 'uniTextfield',
                        name: 'UPDATE_REASON',              //ATTRIBUTE10
                        fieldLabel: '수정사유',
                        width: 490
                    },{
                        xtype: 'container',
                        layout: {type : 'uniTable', columns : 2},
                        border:false,
                        width:523,
                        padding:'0 0 0 0',
                        items:[{
                            xtype: 'uniNumberfield',
                            name: 'AMOUNT_AMT',             //ATTRIBUTE9
                            fieldLabel: '공급가액',
                            allowBlank: false,
                            listeners: {
                                change: function(field, newValue, oldValue, eOpts) {
                                    if(newValue == 0){
                                        masterForm.setValue('TAX_ACCT_AMT',0);
                                        masterForm.setValue('INVOICE_AMT',0);
                                    }else if(Ext.isEmpty(newValue)){
                                        masterForm.setValue('TAX_ACCT_AMT','');
                                        masterForm.setValue('INVOICE_AMT','');
                                    }else{
                                        masterForm.setValue('INVOICE_AMT', newValue + masterForm.getValue('TAX_ACCT_AMT'));
                                    }
                                    
                                    UniAppManager.app.fnAcctAmtChange1();
                                }
                            }          
                        },{
                            xtype: 'uniNumberfield',
                            name: 'TAX_ACCT_AMT',
                            fieldLabel: '세액',
                            listeners: {
                                change: function(field, newValue, oldValue, eOpts) {  
                                    if(newValue == 0){
                                        masterForm.setValue('INVOICE_AMT',masterForm.getValue('AMOUNT_AMT'));
                                    }else if(Ext.isEmpty(newValue)){
                                        masterForm.setValue('INVOICE_AMT',masterForm.getValue('AMOUNT_AMT'));
                                    }else{
                                        masterForm.setValue('INVOICE_AMT', newValue + masterForm.getValue('AMOUNT_AMT'));
                                    }
                                    
                        /*            var detailData = directDetailStore.data.items;
                                    if(detailData.length > 0){
                                        
                                        var drAmtISum = 0;
                                    
                                        Ext.each(detailData, function(record,i){
                                            drAmtISum = drAmtISum + record.get('DR_AMT_I');
                                        });
                                        
                                        detailForm.setValue('ACCT_AMT',masterForm.getValue('INVOICE_AMT') - drAmtISum);
                                        
                                    }*/
                                }
                            }          
                        }]
                    },{
                        xtype: 'uniNumberfield',
                        name: 'INVOICE_AMT',
                        fieldLabel: '합계',
//                        width:122,
                        readOnly:true,
                        listeners: {
                            change: function(field, newValue, oldValue, eOpts) {   
                                /*var detailData = directDetailStore.data.items;
                    
                                if(Ext.getCmp('evdeTypeCd').getValue().EVDE_TYPE_CD != '60'){
                                    if(masterForm.getValue('TAX_CD') != 'NA' ){
                                        
                                        if(newValue > 0){
                                            masterForm.setValue('ATTRIBUTE2',Math.floor(newValue / 11));
                                        }
                                    }
                                }
                                
                                if(detailData.length > 0){
                                    
                                    var drAmtISum = 0;
                                
                                    Ext.each(detailData, function(record,i){
                                        drAmtISum = drAmtISum + record.get('DR_AMT_I');
                                    });
                                    
                                    detailForm.setValue('ACCT_AMT',newValue - drAmtISum);
                                    
                                }*/
                            }
                        }          
                    },{
                        xtype: 'uniTextfield',
                        fieldLabel:'승인번호',
                        name: 'CONVERSATION_ID',                   //ATTRIBUTE4
                        width: 490,  
                        readOnly:true
                    },{
                        xtype: 'container',
                        layout: {type : 'uniTable', columns : 2},
                        width:492,
            //            padding:'10 10 0 10',
                        items :[
                        Unilite.popup('ADVM_REQ_SLIP_NO',{ 
                            fieldLabel: '가지급전표',
                            textFieldName:'ADVM_REQ_SLIP_NO',
                            listeners: {
                                onSelected: {
                                    fn: function(records, type) {
                                        masterForm.setValue('ADVM_REQ_VENDOR_ID', records[0].VENDOR_ID);                                                                                                       
                                    },
                                    scope: this
                                },
                                onClear: function(type) {
                                    masterForm.setValue('ADVM_REQ_VENDOR_ID', '');   
                                },
                                applyextparam: function(popup){                         
            //                        popup.setExtParam({'TO_VENDOR_ID': topSearch.getValue('TO_VENDOR_ID')});
            //                        popup.setExtParam({'WORK_SHOP_CODE': topSearch.getValue('WORK_SHOP_CODE')});
                                }
                            }
                        }),
                        {
                            xtype: 'uniTextfield',
                            fieldLabel:'',
            //                labelAlign : "top",
                            name: 'ADVM_REQ_VENDOR_ID',
            //                width:140,
                            readOnly:true
                        }]
                    },{
                        xtype: 'radiogroup',                            
                        fieldLabel: '증빙유형',
        //                            labelWidth:150,
                        itemId:'evdeTypeCd',
                        allowBlank:false,
                        items: [{
                            boxLabel: '세금계산서', 
                            width: 100,
                            name: 'EVDE_TYPE_CD',
                            itemId:'evdeTypeCd1',
                            inputValue: '10'
                        },{
                            boxLabel: '계산서', 
                            width: 100,
                            name: 'EVDE_TYPE_CD',
                            itemId:'evdeTypeCd2',
                            inputValue: '20'
                        },{
                            boxLabel: '전자세금계산서', 
                            width: 110,
                            name: 'EVDE_TYPE_CD',
                            itemId:'evdeTypeCd3',
                            inputValue: '80'
                        },{
                            boxLabel: '전자계산서', 
                            width: 100,
                            name: 'EVDE_TYPE_CD',
                            itemId:'evdeTypeCd4',
                            inputValue: '85'
                        }],
                        listeners: {
                            change: function(field, newValue, oldValue, eOpts) {/*  
                                if(newValue.EVDE_TYPE_CD == '50'){
                                    
                                    Ext.getCmp('attribute2').setHidden(false);
                                    Ext.getCmp('conVendorNm').setHidden(false);
                                    Ext.getCmp('conVendorSiteCd').setHidden(false);
                                    masterForm.getField("ATTRIBUTE2").setConfig('allowBlank',false);
                                    masterForm.getField("CON_VENDOR_NM").setConfig('allowBlank',false);
                                    masterForm.getField("CON_VENDOR_SITE_CD").setConfig('allowBlank',false);
                                    Ext.getCmp('cardNo').setHidden(true);
                                    masterForm.getField("CARD_NO").setConfig('allowBlank',true);
                                    
                                    if(masterForm.getValue('INVOICE_AMT') > 0){
                                        masterForm.setValue('ATTRIBUTE2',Math.floor(masterForm.getValue('INVOICE_AMT') / 11));
                                    }
                                }else if(newValue.EVDE_TYPE_CD == '60'){
                                    Ext.getCmp('attribute2').setHidden(true);
                                    Ext.getCmp('conVendorNm').setHidden(true);
                                    Ext.getCmp('conVendorSiteCd').setHidden(true);
                                    Ext.getCmp('cardNo').setHidden(true);
                                    masterForm.getField("CARD_NO").setConfig('allowBlank',true);
                                    masterForm.getField("ATTRIBUTE2").setConfig('allowBlank',true);
                                    masterForm.getField("CON_VENDOR_NM").setConfig('allowBlank',true);
                                    masterForm.getField("CON_VENDOR_SITE_CD").setConfig('allowBlank',true);
                                    
                                    masterForm.setValue('ATTRIBUTE2','');
                                    
                                    
                                    
                                }else if(newValue.EVDE_TYPE_CD == '90'){
                                    Ext.getCmp('attribute2').setHidden(false);
                                    Ext.getCmp('conVendorNm').setHidden(false);
                                    Ext.getCmp('conVendorSiteCd').setHidden(false);
                                    Ext.getCmp('cardNo').setHidden(false);
                                    masterForm.getField("CARD_NO").setConfig('allowBlank',false);
                                    masterForm.getField("ATTRIBUTE2").setConfig('allowBlank',false);
                                    masterForm.getField("CON_VENDOR_NM").setConfig('allowBlank',false);
                                    masterForm.getField("CON_VENDOR_SITE_CD").setConfig('allowBlank',false);
                                    
                                    if(masterForm.getValue('INVOICE_AMT') > 0){
                                        masterForm.setValue('ATTRIBUTE2',Math.floor(masterForm.getValue('INVOICE_AMT') / 11));
                                    }
                                }
                            */
                                if(loadFlag != 'Y'){
                                    masterForm.getField("TAX_CD").setRawValue('');
                                    masterForm.getField("TAX_CD").reset();
                                    masterForm.getField("TAX_CD").getStore().clearFilter();
                                    masterForm.setValue('TAX_CD','');
                                }
                                
                            	
                            }
                        }
                    },{
                        xtype: 'container',
                        layout: {type : 'uniTable', columns : 1},
                        items :[{
                            xtype: 'uniCombobox',
                            fieldLabel: '사업영역',
                            id:'globalAttribute3',
                            name:'GLOBAL_ATTRIBUTE3',  
                            store: Ext.data.StoreManager.lookup('businessAreaList'),
                            hidden:false,
                //            allowBlank:false,
                            listeners:{
                                afterrender: function(combo) {
                                	if(!Ext.isEmpty(combo.getStore().data.items)){
                                        var recordSelected = combo.getStore().getAt(0);                     
                                        combo.setValue(recordSelected.get('value'));
                                	}
                                }
                            }
                        }]
                    },
                    Unilite.popup('DEPT', {
                        fieldLabel: '발생부서', 
    //                        labelWidth:150,
                        valueFieldName: 'COST_DEPT_CD',
                        textFieldName: 'COST_DEPT_NM',
                        readOnly:true,
                        allowBlank: false
                    }),
                    {
                        xtype: 'uniCombobox',
                        fieldLabel: '세금코드',
                        name:'TAX_CD',   
                        store: Ext.data.StoreManager.lookup('taxCdList'),
                        allowBlank:false,
            //            valueField: 'value',
            //            displayField: 'text',
                        width:325,
                        listeners:{
                        	beforequery:function( queryPlan, eOpts )    {
                                var store = queryPlan.combo.store;
                                    store.clearFilter();
                                    store.filterBy(function(record){
                                        return record.get('refCode1') == masterForm.down('#evdeTypeCd').getValue().EVDE_TYPE_CD;
                                    })
                            /*    if(masterForm.down('#evdeTypeCd').getValue().EVDE_TYPE_CD == '10'){
                                    store.filterBy(function(record){
                                        return record.get('refCode1') == '10';
                                    })
                                }else if(masterForm.down('#evdeTypeCd').getValue().EVDE_TYPE_CD == '20'){
        //                          var store = queryPlan.combo.store;
        //                            store.clearFilter();
                                    store.filterBy(function(record){
                                        return record.get('refCode1') == '20';
                                    })
                                }else if(masterForm.down('#evdeTypeCd').getValue().EVDE_TYPE_CD == '30'){
        //                          var store = queryPlan.combo.store;
        //                            store.clearFilter();
                                    store.filterBy(function(record){
                                        return record.get('refCode1') == '30';
                                    })
                                }*/
                            },
                        	collapse:function(field, eOpts){
                                field.getStore().clearFilter();
                            },
                            change: function(field, newValue, oldValue, eOpts) {
//                            	if(BsaCodeInfo.paySysGubun == '1'){
                                    detailForm.setValue('TAX_CD',newValue);
//                                }
                            	
                            	
                            	
                            	/*
                                
                                if(newValue == 'NA'){
                                   masterForm.setValue('ATTRIBUTE2','');
                                   Ext.getCmp('attribute2').setReadOnly(true);
                                   
                                }else{
                                    if(masterForm.getValue('INVOICE_AMT') > 0){
                                        masterForm.setValue('ATTRIBUTE2',Math.floor(masterForm.getValue('INVOICE_AMT') / 11));
                                    }
                                   Ext.getCmp('attribute2').setReadOnly(false); 
                                }
        
                            */
                            
                            
                            }
                            
                        }
                        
                    },{
                        xtype: 'container',
                        layout: {type : 'uniTable', columns : 2},
                        width:520,
            //            padding:'10 10 0 10',
                        items :[
                        Unilite.popup('CUST',{
                            fieldLabel: '지급처', 
    //                        labelWidth:150,
            //                labelAlign : "top",
            //                labelWidth:150,
                            valueFieldWidth: 90,
                            textFieldWidth: 140,
                            valueFieldName:'VENDOR_ID',
                            textFieldName:'VENDOR_NM',
                            allowBlank:false,
            //                readOnly:true,
                            listeners: {
                                onSelected: {
                                    fn: function(records, type) {
                                        masterForm.setValue('VENDOR_SITE_CD', records[0].COMPANY_NUM);
                                        
                                    //    elecSlipTransForm.setValue('TRANS_POST_CODE_NAME', records[0].POST_CODE_NAME);
                                    //    elecSlipTransForm.setValue('TRANS_DEPT_NAME', records[0].DEPT_NAME);
                                    },
                                    scope: this
                                },
                                onClear: function(type) {
                                    masterForm.setValue('VENDOR_SITE_CD', '');
                                //    elecSlipTransForm.setValue('TRANS_POST_CODE_NAME', '');
                                //    elecSlipTransForm.setValue('TRANS_DEPT_NAME', '');
                                },
            
                                applyextparam: function(popup){
                                    popup.setExtParam({'ADD_QUERY': "ISNULL(A.VENDOR_GROUP_CODE,'')!='V090'"});                           
                                }
            
                            }
                        }),
                        {
                            xtype: 'uniTextfield',
                            fieldLabel:'',
            //                labelAlign : "top",
                            name: 'VENDOR_SITE_CD',
                            width:165,
                            readOnly:true
                        }]
                    },{
                        xtype: 'container',
                        layout: {type : 'uniTable', columns : 1},
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
            //                pickerWidth: 100,
                //            allowBlank:false
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
                            
                      //      searchForm.getField("BANK_TYPE").rawValue; ==> value값으로 써야함
                //                afterrender: function(combo) {
                //                    var recordSelected = combo.getStore().getAt(0);                     
                //                    combo.setValue(recordSelected.get('value'));
                //                }
                            }
                        }]
                    },{
                        xtype: 'uniCombobox',
                        fieldLabel: '지급조건',
    //                        labelWidth:150,
                        id:'payTermsCd',
                        name:'PAY_TERMS_CD', 
                        allowBlank:false,
                        store: Ext.data.StoreManager.lookup('payTermCdList'),
                        hidden:false
            //            listeners:{
            //                afterrender: function(combo) {
            //                    var recordSelected = combo.getStore().getAt(0);                     
            //                    combo.setValue(recordSelected.get('value'));
            //                }
            //            }
                        
            //            allowBlank:false
            //            visible:false
                        
                        
            //            setVisible(false)
                    },{
                        xtype: 'uniCombobox',
                        fieldLabel: '지급방법',
                        id:'payMetoCd',
                        name:'PAY_METO_CD', 
                        allowBlank:false, 
                        comboType:'AU',
                        comboCode:'J668',
            //            store: Ext.data.StoreManager.lookup('businessAreaList'),
                        hidden:false,
            //            allowBlank:false,
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
            //                afterrender: function(combo) {
            //                    var recordSelected = combo.getStore().getAt(0);                     
            //                    combo.setValue(recordSelected.get('value'));
            //                }
                        }
                    },{ 
                        xtype: 'uniDatefield',
                        fieldLabel: '회계일자',
                        name: 'GL_DATE',
                        value: UniDate.get('today'),
                        allowBlank: false
                    },{
                        xtype: 'container',
                        layout: {type : 'uniTable', columns : 2},
                        items :[{ 
                            xtype: 'uniDatefield',
                            fieldLabel: '지급요청일',
                            id:'payDate',
                            name: 'PAY_DATE',
                            value: UniDate.get('today'),
                            allowBlank: false,
                            hidden:true
                        },{
                            xtype: 'uniCombobox',
                            fieldLabel: '결재상태',
                            name:'SLIP_STAT_CD',   
                            comboType:'AU',
                            comboCode:'J682',
                            readOnly:true
                        }]
                    },{
                        xtype: 'uniTextfield',
                        fieldLabel:'전표관리번호', 
                        name: 'ELEC_SLIP_NO', 
            //            labelWidth:165,
                        readOnly:true
                    },
                    Unilite.popup('Employee',{
		                fieldLabel: '신청자', 
		                valueFieldWidth: 90,
		                textFieldWidth: 140,
		                valueFieldName:'APPLICANT_ID',
		                textFieldName:'APPLICANT_NAME',
		                allowBlank: false,
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
                }]
            }]
        }],
        api: {
          load: 'aep140ukrService.selectMasterForm'  
        }
    });
    
    var detailForm = Unilite.createForm('resultForm',{
    	masterGrid: detailGrid,
//    	flex:0.8,
//      split:true,
//              title:'경비내역',
        region: 'north',
        layout : {type : 'uniTable', columns : 2
//      , tableAttrs: { /*style: 'border : 1px solid #ced9e7;',*/width: '100%'}
//         , tdAttrs: {/*style: 'border : 1px solid #ced9e7;',*/width: '100%'/*,align : 'left'*/}
        },
        padding:'1 1 1 1',
//        border:true,
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
            id: 'fieldset4',
            padding: '10 10 10 20',
            margin: '0 0 0 0',
            defaults: {xtype: 'uniTextfield'},
            layout: {type: 'uniTable' , columns: 3
//                   , tdAttrs: {style: 'border : 1px solid #ced9e7;'}
            },
            items: [{
            xtype: 'uniCombobox',
            fieldLabel: '경비유형', 
            id:'payType',
            name:'PAY_TYPE',   
            comboType:'AU',
            comboCode:'A177',
            width:325,          	
	        tdAttrs: {width: 342},   
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
//            width:520,
            items :[
            Unilite.popup('DEPT',{ 
                fieldLabel: '귀속부서', 
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
	        tdAttrs: {width: 342},  
//                  validateBlank:'text',
            listeners: {
                onSelected: {
                    fn: function(records, type) {
                        var param = {
                            "ACCT_CD": detailForm.getValue('ACCT_CD')
                        };
                        
                        aep140ukrService.selectAccntYnData(param, function(provider, response)   {
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
//                    popup.setExtParam({'CHARGE_CODE': getChargeCode[0].SUB_CODE});
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
	        tdAttrs: {width: 340},  
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
        },
            
        {
            xtype: 'container',
            layout: {type : 'uniTable', columns : 2},
            colspan:2,
            items :[{
                xtype: 'uniNumberfield',
                fieldLabel:'예산총액/잔액', 
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
            xtype: 'uniNumberfield',
            fieldLabel:'카드한도금액',
            name: '',
            readOnly:true,
            hidden:true
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
                name: 'ACCT_AMT',
//                width:185,
                allowBlank:false
           }/*{
                    xtype: 'uniNumberfield',
                    fieldLabel:'봉사료',
                    id:'aquiServ',
                    name: 'AQUI_SERV',
                    labelWidth:50,
                    width:140,
    //                visible:false,
                    hidden:true,
                    readOnly:true
                }*//*{
                xtype: 'container',
                layout: {type : 'vbox', columns : 1},
                items :[{
                    xtype: 'uniNumberfield',
                    fieldLabel:'봉사료',
                    id:'aquiServ',
                    name: 'AQUI_SERV',
                    labelWidth:50,
                    width:140,
    //                visible:false,
                    hidden:true,
                    readOnly:true
                }]
           }*/]
        },{
            xtype: 'uniCombobox',
            fieldLabel: '세금코드',
            name:'TAX_CD',   
            store: Ext.data.StoreManager.lookup('taxCdList'),
            width:325,
            allowBlank:false,
            readOnly:true
//            colspan:2
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
    //            allowBlank:false,
    //                  validateBlank:'text',
                listeners: {
                    applyextparam: function(popup){
    //                    popup.setExtParam({'CHARGE_CODE': getChargeCode[0].SUB_CODE});
                        popup.setExtParam({'ADD_QUERY': "GROUP_YN = 'N' AND SLIP_SW = 'Y'"});
                    }
                }
            })]
        },{
            xtype:'uniTextfield',
            fieldLabel:'적요', 
            name:'ITEM_DESC',
            width:325,
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
//        ,
//        api: {
//            load: 'aep140ukrService.selectForm' ,
//            submit: 'aep140ukrService.syncMaster'   
//        }
    });
    
    
    var elecSlipTransForm = Unilite.createForm('elecSlipTransForm',{
//      split:true,
        region: 'center',
        layout : {type : 'uniTable', columns : 1},
        padding:'1 1 1 1',
//        border:true,
        disabled:false,
        items: [{
            xtype: 'container',
            layout: {type : 'uniTable', columns : 3},
            padding:'10 10 0 10',
            items :[
            Unilite.popup('Employee',{
                fieldLabel: '전표 이관 받을 임직원', 
                labelAlign : "top",
                labelWidth:150,
                valueFieldWidth: 90,
                textFieldWidth: 140,
                valueFieldName:'PERSON_NUMB',
                textFieldName:'NAME',
                allowBlank:false,
//                readOnly:true,
                listeners: {
                    onSelected: {
                        fn: function(records, type) {
                            elecSlipTransForm.setValue('TRANS_POST_CODE_NAME', records[0].POST_CODE_NAME);
                            elecSlipTransForm.setValue('TRANS_DEPT_NAME', records[0].DEPT_NAME);
                        },
                        scope: this
                    },
                    onClear: function(type) {
                        elecSlipTransForm.setValue('TRANS_POST_CODE_NAME', '');
                        elecSlipTransForm.setValue('TRANS_DEPT_NAME', '');
                    }
                }
            }),
            {
                xtype: 'uniTextfield',
                fieldLabel:' ',
                labelAlign : "top",
                name: 'TRANS_POST_CODE_NAME',
                width:140,
                readOnly:true
            },{
                xtype: 'uniTextfield',
                fieldLabel:' ',
                labelAlign : "top",
                name: 'TRANS_DEPT_NAME',
                width:140,
                readOnly:true
            }]
        },{
            xtype: 'container',
            layout: {type : 'uniTable', columns : 1},
            padding:'10 10 10 10',
            items :[{
                xtype: 'uniTextfield',
                fieldLabel:'이관내역',
                labelAlign : "top",
                name: 'TRANS_DESC',
                width:510
            }]
        }]
    });
    
    
    function openElecSlipTransWindow() {          

        if(!elecSlipTransWindow) {
            elecSlipTransWindow = Ext.create('widget.uniDetailWindow', {
                title: '전표이관',
                width: 550,                                
                height: 200,
                layout:{type:'vbox', align:'stretch'},
                items: [elecSlipTransForm],
                tbar:  [
                    '->',{
//                        itemId : 'Btn',
                        text: '확인',
                        handler: function() {
                            if(!elecSlipTransForm.getInvalidMessage()) return; 
                            
                            var searchRecords = directSearchStore.data.items;
                            buttonStore.clearData();
                            Ext.each(searchRecords, function(record,i){
                                if(record.get('SELECT') == true){
                                    record.phantom = true;
                                    buttonStore.insert(i, record);
                                }
                            });
                            
                            buttonFlag = 'btnConf';
                            preEmpNo = searchForm.getValue('CARD_EXPENSE_ID');
                            nxtEmpNo =  elecSlipTransForm.getValue('PERSON_NUMB');
                            transDesc = elecSlipTransForm.getValue('TRANS_DESC');
                            
                            buttonStore.saveStore();
                            
                            elecSlipTransWindow.hide();
//                          draftNoGrid.reset();
                          elecSlipTransForm.clearForm();
                        },
                        disabled: false
                    },{
                        itemId : 'closeBtn',
                        text: '닫기',
                        handler: function() {
                            elecSlipTransWindow.hide();
//                          draftNoGrid.reset();
                          elecSlipTransForm.clearForm();
                        },
                        disabled: false
                    }
                ],
                listeners : {
                    beforehide: function(me, eOpt)  {
                    },
                    beforeclose: function( panel, eOpts )   {
                    },
                    show: function ( panel, eOpts ) {
                    }
                }
            })
        }
        elecSlipTransWindow.center();
        elecSlipTransWindow.show();
    }
    

    
    var fileUploadForm = Unilite.createSimpleForm('fileUploadForm',{
        region: 'center',
        disabled:false,
        items: [{
            xtype	: 'container',
            itemId	: 'uploadDisabled',
            layout	: {type : 'uniTable', columns : 1},
            width	: 1066,
            disabled: true,
            tdAttrs	: {align : 'center'},
            items	: [{
                xtype:'component',
                html:'[증빙내역]',
                componentCls : 'component-text_green',
                tdAttrs: {align : 'left'},
                width: 1066
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
             load	: 'aep140ukrService.getFileList',   //조회 api
             submit	: 'aep140ukrService.saveFile'       //저장 api
        }
    });  
    
    
    
    var searchGrid = Unilite.createGrid('aep110ukrSearchGrid', {
//      split:true,
//        layout: 'fit',
        region: 'center',
        excelTitle: '실물증빙내역',
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
                    
//                    if(checkCount > 0){
//                        UniAppManager.setToolbarButtons('save',true);
//                    }else if(checkCount < 1){
//                        UniAppManager.setToolbarButtons('save',false);
//                    }
            }
        },{
            xtype: 'button',
            text: '전체취소',
            handler: function() {   
                var records = directSearchStore.data.items;  
                Ext.each(records,  function(record, index, records){
                    record.set('SELECT', false);
                });
                
//                    if(checkCount > 0){
//                        UniAppManager.setToolbarButtons('save',true);
//                    }else if(checkCount < 1){
//                        UniAppManager.setToolbarButtons('save',false);
//                    }
            }
        }],
        bbar: [{
            xtype: 'button',
            id: 'btnConf',
            text: '계산서 이관',
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
                        if(confirm('선택한 전자세금계산서 이용내역을 전표이관 처리하시겠습니까?')) { 
                            Ext.each(searchRecords, function(record,i){
                                if(record.get('SELECT') == true){
                                    if(record.get('ETAX_CHECK') == 'O'){
                                        alert(record.get('RNUM') + "번째 전자세금계산서 이용내역은 미작성 상태가 아닙니다.\n미작성만 전표이관이 가능합니다.");
//                                          Ext.Msg.alert(Msg.sMB099, record.get('RNUM') + "번째 전자세금계산서 이용내역은 미작성 상태가 아닙니다.</br>미작성만 전표이관이 가능합니다.")
                                        record.set('SELECT', false);
                                    }
                                }
                            });
                            
                            selectTrueFlag = '';
                            
                            Ext.each(searchRecords, function(record,i){
                                if(record.get('SELECT') == true){
                                    selectTrueFlag = 'Y';
                                }
                            });
                            if(selectTrueFlag == 'Y'){
                                openElecSlipTransWindow();
                            }else{
                                Ext.Msg.alert('확인','전표이관 처리할 데이터를 선택해 주세요.');
                            }
                        }else{
                           return false;    
                        }
                    }else{
                        Ext.Msg.alert('확인','전표이관 처리할 데이터를 선택해 주세요.');
                    }
                }else{
                    Ext.Msg.alert('확인','전표이관 처리할 데이터를 선택해 주세요.');
                }
            }
        },'->',{
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
                        if(confirm('선택한 전자세금계산서 이용내역을 결재요청 처리하시겠습니까?')) { 
                            Ext.each(searchRecords, function(record,i){
                                if(record.get('SELECT') == true){
                                    if(record.get('ETAX_CHECK') == 'X'){
                                        alert(record.get('RNUM') + "번째 전자세금계산서 이용내역은 작성 상태가 아닙니다.\n작성 상태만 결재요청이 가능합니다.");
//                                          Ext.Msg.alert(Msg.sMB099, record.get('RNUM') + "번째 전자세금계산서 이용내역은 미작성 상태가 아닙니다.</br>미작성만 전표이관이 가능합니다.")
                                        record.set('SELECT', false);
                                    }
                                }
                            });
                            
                            selectTrueFlag = '';
                            
                            Ext.each(searchRecords, function(record,i){
                                if(record.get('SELECT') == true){
                                    selectTrueFlag = 'Y';
                                }
                            });
                            if(selectTrueFlag == 'Y'){
                                
                                /*var dataArr = [];*/
                                 
                                requestStore.clearData();
                                Ext.each(searchRecords, function(record,i){
                                    if(record.get('SELECT') == true){
                                        record.phantom = true;
                                        requestStore.insert(i, record);
//                                        dataArr.push(record.get('CARD_NO2'));
                                    }
                                });
                                
                                requestStore.saveStore(); 
                                
                                
                  /*              dataArr.sort();
                                var requestRecords = requestStore.data.items;
                                
                                var cardNoDataArr = [];
                                var realDataTemp = '';
                                
                                realDataTemp = dataArr[0];
                                cardNoDataArr.push(realDataTemp);
                                
                                for(var i = 0; i < dataArr.length; i++){
                                    if(realDataTemp != dataArr[i]){
                                        realDataTemp = dataArr[i];
                                        cardNoDataArr.push(dataArr[i]);
                                    }
                                }
                                
                                var mercNmArr = [];
                                var mercNmStr = '';
                                
                                var cnt= 0;
                                for(var i = 0; i < cardNoDataArr.length; i++){
                                    cnt = 0;
                                    Ext.each(requestRecords, function(record,j){
                                        if(cardNoDataArr[i] == record.get('CARD_NO2')){
                                            cnt = cnt + 1;
                                            if(cnt == 1){
                                                 mercNmStr = record.get('MERC_NM');
                                            }
                                        }
                                    });
                                    if(cnt > 1){
                                        mercNmArr.push(mercNmStr + " 외 " + (cnt-1) + "건");
                                    }else{
                                        mercNmArr.push(mercNmStr);
                                    }
                                }
                                mercNmArr.sort();
                                
                                
                                
                                var winWidth=1000;
                                var winHeight=600;
                                
                                var scrW=screen.availWidth;
                                var scrH=screen.availHeight;
                                
                                var positionX=(scrW-winWidth)/2;
                                var positionY=(scrH-winHeight)/2;

                                var gsWin = window.open('about:blank','cardviewer','left='+positionX+',top='+positionY+',width='+winWidth+',height='+winHeight+'');
                                var requestMsg = '<?xml version="1.0" encoding="euc-kr" ?>';
                                requestMsg = requestMsg + '<aprv APPID="MIS_ACCNT">';
                                requestMsg = requestMsg + '<item>';
                                requestMsg = requestMsg + '<apprManageNo>AP2014123100001482</apprManageNo>';
                                requestMsg = requestMsg + '</item>';
                                requestMsg = requestMsg + '<content><![CDATA[';
                                requestMsg = requestMsg + '<table style="border-collapse:collapse; border:1px gray solid;">';
                                requestMsg = requestMsg + '<tr style="border:1px gray solid;padding: 5px 10px;">';
                                requestMsg = requestMsg + '<td style="border:1px gray solid;padding: 5px 10px;">';
                                requestMsg = requestMsg + '카드번호';
                                requestMsg = requestMsg + '</td>';
                                requestMsg = requestMsg + '<td style="border:1px gray solid;padding: 5px 10px;">';
                                requestMsg = requestMsg + '내용';
                                requestMsg = requestMsg + '</td>';
                                requestMsg = requestMsg + '</tr>';

                                for(var i = 0; i < cardNoDataArr.length; i++){
                                    
                                    requestMsg = requestMsg + '<tr style="border:1px gray solid;padding: 5px 10px;">';
                                    requestMsg = requestMsg + '<td style="border:1px gray solid;padding: 5px 10px;">';
                                    requestMsg = requestMsg + cardNoDataArr[i];
                                    requestMsg = requestMsg + '</td>';
                                    requestMsg = requestMsg + '<td style="border:1px gray solid;padding: 5px 10px;">';
                                    requestMsg = requestMsg + '<p><a target="_blank" href="http://localhost:8080/accnt/test/extjs/req999skrTestRequest.jsp?testValue ='+aaa+' title="상세리스트보기">' + mercNmArr[i] + '</a></p>';
                                    
                                    
//                                    requestMsg = requestMsg + '<p><a target="_blank" href="http://localhost:8080/accnt/test/extjs/req999skrTestRequest.jsp?testValue ='+'안녕"'+' title="상세리스트보기">' + mercNmArr[i] + '</a></p>';
//                                    style="selector-dummy: true"
//onmouseover="window.status=나타낼내용;return true" onmouseout="window.status= ;return true"

//                                    requestMsg = requestMsg + '<p><a target="_blank"  onclick="onclick()">' + mercNmArr[i] + '</a></p>';
                                 //   href="#" onclick="location.href='URL'
                                    
                                    requestMsg = requestMsg + '</td>';
                                    requestMsg = requestMsg + '</tr>';
                                }
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
                                
                                
                                
                                if(confirm("결재팝업을 오픈하였습니다.\n기안을 완료 하신 후,\n확인을 눌러주세요.\n재조회 합니다.")) { 
                                    UniAppManager.app.onQueryButtonDown();
                                        
                                        
                                }else{
                                    return false;
                                }
                            */
                            }else{
                                Ext.Msg.alert('확인','결재요청 처리할 데이터를 선택해 주세요.');
                            }
                             
                            
                            
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
            { dataIndex: 'RNUM'                                  ,width:40,align:'center'},
            { dataIndex: 'ETAX_CHECK'                            ,width:40,align:'center'},
            { dataIndex: 'SLIP_STAT_CD'                          ,width:80,align:'center'},
            { dataIndex: 'ELEC_SLIP_NO'                          ,width:120,align:'center'},
            { dataIndex: 'REG_DT'                                ,width:80		,hidden:true},
            { dataIndex: 'DTI_WDATE'                             ,width:80},
            { dataIndex: 'REG_NM'                                ,width:60,align:'center'},
            { dataIndex: 'ETAX_STATUS_CD'                        ,width:80,align:'center'},
            { dataIndex: 'CONVERSATION_ID'                       ,width:180},
            { dataIndex: 'CREATION_DATE'                         ,width:80},
            { dataIndex: 'FR_VENDOR_SITE_CD'                         ,width:120,align:'center'},
            { dataIndex: 'FR_VENDOR_NM'                          ,width:150},
            { dataIndex: 'SUP_AMOUNT'                            ,width:80},
            { dataIndex: 'TAX_AMOUNT'                            ,width:80},
            { dataIndex: 'TOTAL_AMOUNT'                          ,width:80},
            { dataIndex: 'FR_VENDOR_BUSINESS_CONDITION'                      ,width:100},
            { dataIndex: 'FR_VENDOR_BUSINESS_TYPE'                          ,width:100},
//            { dataIndex: 'UPLOAD_EMPLOYEE_NO'                    ,width:120,align:'center'},
//            { dataIndex: 'EMPLOYEE_KOR_NAME'                     ,width:80,align:'center'},
//            { dataIndex: 'kostl_nm'                              ,width:80,align:'center'},
            { dataIndex: 'SUP_EMAIL'                             ,width:180},
            { dataIndex: 'BYR_EMAIL'                             ,width:180},
            { dataIndex: 'BYR_EMP_NAME'                          ,width:80,align:'center'},
            { dataIndex: 'REMARK'                                ,width:120},
//            { dataIndex: 'KOSTL'                                 ,width:100,align:'center'},
            
            
            { dataIndex: 'FR_VENDOR_ID'                           ,width:120, hidden:true},
            { dataIndex: 'FR_VENDOR_SITE_CD'                         ,width:120, hidden:true},
            { dataIndex: 'FR_VENDOR_NM'                          ,width:120, hidden:true},
            { dataIndex: 'FR_VENDOR_CEO_NAME'                          ,width:120, hidden:true},
            { dataIndex: 'FR_VENDOR_ADDRESS'                          ,width:120, hidden:true},
            { dataIndex: 'FR_VENDOR_BUSINESS_TYPE'                          ,width:120, hidden:true},
            { dataIndex: 'FR_VENDOR_BUSINESS_CONDITION'                      ,width:120, hidden:true},
            { dataIndex: 'TO_VENDOR_ID'                              ,width:120, hidden:true},
            { dataIndex: 'TO_VENDOR_SITE_CD'                         ,width:120, hidden:true},
            { dataIndex: 'TO_VENDOR_NM'                          ,width:120, hidden:true},
            { dataIndex: 'TO_VENDOR_CEO_NAME'                          ,width:120, hidden:true},
            { dataIndex: 'TO_VENDOR_ADDRESS'                          ,width:120, hidden:true},
            { dataIndex: 'TO_VENDOR_BUSINESS_TYPE'                          ,width:120, hidden:true},
            { dataIndex: 'TO_VENDOR_BUSINESS_CONDITION'                      ,width:120, hidden:true}
            
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
//                            alert('저장로직');
                                UniAppManager.app.onSaveDataButtonDown();
                                
                            } else if(res === 'no') {
                                focusMove = true;
                                masterForm.setValue('TAX_CD','');
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
                    masterForm.setValue('TAX_CD','');
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
            	if(selected.data.ETAX_CHECK == 'X'){
            	
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
                    
                    masterForm.setValue('REG_DT_NM', selected.data.DTI_WDATE);
                    masterForm.setValue('GL_DATE', UniDate.get('today'));
//                    masterForm.setValue('INVOICE_DATE', UniDate.get('today'));
                    masterForm.setValue('PAY_DATE', UniDate.get('today'));
                    
                    masterForm.setValue('TAX_CD', '');
	            	//파일업로드용 setting
	                masterForm.setValue('FILE_NO',selected.data.ELEC_SLIP_NO);
                    
            		if(BsaCodeInfo.paySysGubun == '1'){
                        masterForm.getForm().getFields().each(function(field) {
                            if (
                                field.name == 'REG_DT_NM' || 
                                field.name == 'UPDATE_REASON' || 
                                field.name == 'AMOUNT_AMT' || 
                                field.name == 'TAX_ACCT_AMT' ||
                                field.name == 'ADVM_REQ_SLIP_NO' ||
                                field.name == 'EVDE_TYPE_CD' ||
                                field.name == 'TAX_CD' ||
                                field.name == 'VENDOR_ID' ||
                                field.name == 'VENDOR_NM' ||
                                field.name == 'GL_DATE' ||
                                field.name == 'PAY_DATE' 
                            ){
                                field.setReadOnly(false);
                            }else{
                                field.setReadOnly(true);
                            }
                        });
                    }
            	    masterForm.setValue('ELEC_SLIP_NO'    				, selected.data.ELEC_SLIP_NO);
                                                                          
                    masterForm.setValue('FR_VENDOR_ID'     				, selected.data.FR_VENDOR_ID);
                    masterForm.setValue('FR_VENDOR_SITE_CD'   			, selected.data.FR_VENDOR_SITE_CD);
                    masterForm.setValue('FR_VENDOR_NM'    				, selected.data.FR_VENDOR_NM);
                    masterForm.setValue('FR_VENDOR_CEO_NAME'    		, selected.data.FR_VENDOR_CEO_NAME);
                    masterForm.setValue('FR_VENDOR_ADDRESS'    			, selected.data.FR_VENDOR_ADDRESS);
                    masterForm.setValue('FR_VENDOR_BUSINESS_TYPE'   	, selected.data.FR_VENDOR_BUSINESS_TYPE);
                    masterForm.setValue('FR_VENDOR_BUSINESS_CONDITION'	, selected.data.FR_VENDOR_BUSINESS_CONDITION);
                    masterForm.setValue('TO_VENDOR_ID'        			, selected.data.TO_VENDOR_ID);
                    masterForm.setValue('TO_VENDOR_SITE_CD'   			, selected.data.TO_VENDOR_SITE_CD);
                    masterForm.setValue('TO_VENDOR_NM'    				, selected.data.TO_VENDOR_NM);
                    masterForm.setValue('TO_VENDOR_CEO_NAME'		    , selected.data.TO_VENDOR_CEO_NAME);
                    masterForm.setValue('TO_VENDOR_ADDRESS'    			, selected.data.TO_VENDOR_ADDRESS);
                    masterForm.setValue('TO_VENDOR_BUSINESS_TYPE'   	, selected.data.TO_VENDOR_BUSINESS_TYPE);
                    masterForm.setValue('TO_VENDOR_BUSINESS_CONDITION'	, selected.data.TO_VENDOR_BUSINESS_CONDITION);
                                                                          
                    masterForm.setValue('AMOUNT_AMT'					, selected.data.SUP_AMOUNT);
                    masterForm.setValue('TAX_ACCT_AMT'					, selected.data.TAX_AMOUNT);
                    masterForm.setValue('INVOICE_AMT'					, selected.data.TOTAL_AMOUNT);
                    masterForm.setValue('CONVERSATION_ID'				, selected.data.CONVERSATION_ID);
                     if(BsaCodeInfo.paySysGubun == '1'){
                     	
                        if(selected.data.TAX_AMOUNT == 0){
                            masterForm.getField('EVDE_TYPE_CD').setValue('20');
                     	}else{
                     		masterForm.getField('EVDE_TYPE_CD').setValue('10');
                     	}
                     }
                    
                    UniAppManager.app.fnAcctAmtChange1();
                    UniAppManager.setToolbarButtons('reset',true);
                    UniAppManager.setToolbarButtons('save', false);
                    
            	}else{
          /*   추후 확인 필요  로우클릭시 마스터 폼 셋 팅
                    masterForm.setValue('INVOICE_AMT',selected.data.AQUI_SUM);
                    masterForm.setValue('ATTRIBUTE2',selected.data.AQUI_TAX);
                    
                    masterForm.setValue('ELEC_SLIP_NO',selected.data.ELEC_SLIP_NO);
                    
                    masterForm.setValue('UL_NO',selected.data.UL_NO);
                    */
                    
//                	masterForm.setValue('ELEC_SLIP_NO',selected.data.ELEC_SLIP_NO);
            		
	            	//파일업로드용 setting
	                masterForm.setValue('FILE_NO',selected.data.ELEC_SLIP_NO);
                    
                    
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
        }
    });  
    
    var subForm = Unilite.createSimpleForm('subForm',{
        region: 'north',
//        border:true,
//      split:true,
        items: [{
            xtype:'component',
//                padding:'1 1 1 1',
            html:'[전자세금계산서내역]',
            componentCls : 'component-text_green',
            tdAttrs: {align : 'left'},
            width: 150
        },searchGrid]
        
    }); 
    
    
    var detailGrid = Unilite.createGrid('aep140ukrDetailGrid', {
        disabled:true,
    	height:300,
        width:1065,
        region: 'south',
        excelTitle: '전자세금계산서(전자계산서)경비내역',
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
//                  var mainGridRecord = detailGrid.getSelectedRecord();
                    
//                    var customCode = mainGridReceiveRecord.get('PAY_FR_VENDOR_ID');
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
                    aep140ukrService.selectBudgctlYn(param, function(provider, response)   {
                        if(!Ext.isEmpty(provider)){
                            if(provider.BUDGCTL_YN == 'Y'){
                                if(!Ext.isEmpty(detailForm.getValue('AMTRM'))){
                                    if(detailForm.getValue('AMTRM') < detailForm.getValue('ACCT_AMT') + drAmtISum){
                                        alert("경비금액은 예산잔액을 초과하여 입력할 수 없습니다.");
                                    }else{
                                        if(!Ext.isEmpty(masterForm.getValue('TAX_CD'))){
                                            if(masterForm.getValue('AMOUNT_AMT') < detailForm.getValue('ACCT_AMT') + drAmtISum){
                                                alert("차변(원화)금액의 총합이 대변금액 보다 클 수 없습니다.");
                                            }else{
                                                UniAppManager.app.fnCreateRow();
                                            }
                                        }
                                    }
                                }else{
                                    alert("예산잔액이 없습니다.");   
                                }
                            }else{
                                if(!Ext.isEmpty(masterForm.getValue('TAX_CD'))){
                                    if(masterForm.getValue('AMOUNT_AMT') < detailForm.getValue('ACCT_AMT') + drAmtISum){
                                        alert("차변(원화)금액의 총합이 대변금액 보다 클 수 없습니다.");
                                    }else{
                                        UniAppManager.app.fnCreateRow();
                                    }
                                }
                            }
                        }else{
                            if(!Ext.isEmpty(masterForm.getValue('TAX_CD'))){
                                if(masterForm.getValue('AMOUNT_AMT') < detailForm.getValue('ACCT_AMT') + drAmtISum){
                                    alert("차변(원화)금액의 총합이 대변금액 보다 클 수 없습니다.");
                                }else{
                                    UniAppManager.app.fnCreateRow();
                                }
                            }
                        }
                    });
                }
            },{
                xtype: 'uniBaseButton',
                text : '삭제',
                tooltip : '삭제',
                iconCls: 'icon-delete',
                //disabled: true,
                width: 26, height: 26,
                itemId : 'detail_delete',
                handler : function() { 
                    var selRow = detailGrid.getSelectedRecord();
                    if(!Ext.isEmpty(selRow)){
                        if(selRow.phantom === true) {
                            detailGrid.deleteSelectedRow();
                            
                            detailForm.clearForm();
                            
                            UniAppManager.app.fnAcctAmtChange2(); 
                            
                        }else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
                            detailGrid.deleteSelectedRow();      
                            
                            detailForm.clearForm();
                            
                            UniAppManager.app.fnAcctAmtChange2(); 
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

                        UniAppManager.app.fnAcctAmtChange1();
                        
                    }
                }
            }]
        }],
        store: directDetailStore,
        columns: [
            { dataIndex: 'SEQ'             ,width:80,hidden:true},
            { dataIndex: 'ELEC_SLIP_NO'    ,width:80,hidden:true},
            { dataIndex: 'DC_DIV_CD'       ,width:50,align:'center'},
            { dataIndex: 'ACCT_CD'         ,width:80},
            { dataIndex: 'ACCT_NM'         ,width:150},
            { dataIndex: 'COST_DEPT_CD'    ,width:80},
            { dataIndex: 'COST_DEPT_NM'    ,width:100},
            { dataIndex: 'TAX_CD'          ,width:100},
            { dataIndex: 'DR_AMT_I'        ,width:100},
            { dataIndex: 'CR_AMT_I'        ,width:100},
            { dataIndex: 'ITEM_DESC_USE'   ,width:200},
            { dataIndex: 'ITEM_DESC'       ,width:200},
            
//            { dataIndex: 'ACCT_AMT'                ,width:80,hidden:false},
//            { dataIndex: 'AQUI_SERV'                ,width:80,hidden:true},
            { dataIndex: 'PAY_TYPE'        ,width:80,hidden:true},
            { dataIndex: 'MAKE_SALE'       ,width:80,hidden:true},
            { dataIndex: 'PJT_CODE'        ,width:80,hidden:true},
            { dataIndex: 'PJT_NAME'        ,width:80,hidden:true},
            { dataIndex: 'ORG_ACCNT'       ,width:80,hidden:true},
            { dataIndex: 'ORG_ACCNT_NM'    ,width:80,hidden:true},
            { dataIndex: 'PAY_DATE'        ,width:80,hidden:true},
            
            { dataIndex: 'ITEM_CODE'       ,width:80,hidden:true},
            { dataIndex: 'ITEM_NAME'       ,width:80,hidden:true},
            
            { dataIndex: 'FILE_UPLOAD_FLAG'     ,width:80,hidden:true}
        ],
        listeners: { 
            selectionchangerecord:function(selected)    {
//                detailForm.setActiveRecord(selected);
//                if(!Ext.isEmpty(selected.data.UPDATE_DB_TIME)){
//                    Ext.getCmp('crdt_num').setReadOnly(true);
//                }else{
//                    Ext.getCmp('crdt_num').setReadOnly(false);
//                }
                
                
                
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
//        border:true,
//        width:500,
//      split:true,
        items: [{
            xtype: 'container',
            layout: {type : 'uniTable', columns : 1},
            width:1010,
//          colspan:2,
            items :[detailGrid]
            }]
        
    }); 

    Unilite.Main( {
        borderItems:[{
            region:'center',
//            layout : 'border',
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
        id  : 'aep140ukrApp',
        fnInitBinding: function(params){
            UniAppManager.setToolbarButtons(['newData'], false);
            UniAppManager.setToolbarButtons(['reset'], true);
            
            this.setDefault(params);
//            UniAppManager.app.fnInitInputFields();  
        },
        onQueryButtonDown: function() {   
			if(!searchForm.getInvalidMessage()){
				return false;
			}
        	directSearchStore.loadStoreRecords();   
        },
/*      onNewDataButtonDown: function() {
            if(!panelResult.getInvalidMessage()) return;    //필수체크
        
//           var compCode = UserInfo.compCode;
             
             var r = {
            
//              COMP_CODE: compCode
            };
            detailGrid.createRow(r);
        },*/
        onResetButtonDown: function() {
//          detailForm.clearForm();
            masterForm.clearForm();
            detailForm.clearForm();
            fileUploadForm.clearForm();
            fileUploadForm.down('xuploadpanel').reset();
            searchGrid.reset();
            directSearchStore.clearData();
            detailGrid.reset();
            directDetailStore.clearData();
            detailGrid.disable();
            UniAppManager.setToolbarButtons(['newData','save','delete'], false);
            UniAppManager.setToolbarButtons(['reset'], true);
            UniAppManager.app.fnInitInputFields();  
            SAVE_FLAG = '';
            
            if(BsaCodeInfo.paySysGubun == '1'){
                masterForm.getForm().getFields().each(function(field) {
                    if (
                        field.name == 'REG_DT_NM' || 
                        field.name == 'UPDATE_REASON' || 
                        field.name == 'AMOUNT_AMT' || 
                        field.name == 'TAX_ACCT_AMT' ||
                        field.name == 'ADVM_REQ_SLIP_NO' ||
                        field.name == 'EVDE_TYPE_CD' ||
                        field.name == 'TAX_CD' ||
                        field.name == 'VENDOR_ID' ||
                        field.name == 'VENDOR_NM' ||
                        field.name == 'GL_DATE' ||
                        field.name == 'PAY_DATE' 
                    ){
                        field.setReadOnly(false);
                    }else{
                        field.setReadOnly(true);
                    }
                });
            }
        },
        
        onSaveDataButtonDown: function(config) {
            if(!masterForm.getInvalidMessage()) return; 
            
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
        /*onDeleteAllButtonDown: function() {           
            var records = directDetailStore.data.items;
            var isNewData = false;
            Ext.each(records, function(record,i) {
                if(record.phantom){                     //신규 레코드일시 isNewData에 true를 반환
                    isNewData = true;
                }else{                                  //신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
                    if(confirm('전체삭제 하시겠습니까?')) {
                        var deletable = true;
                        if(deletable){      
                            detailGrid.reset();         
                            UniAppManager.app.onSaveDataButtonDown();   
                        }
                        isNewData = false;                          
                    }
                    return false;
                }
            });
            if(isNewData){                              //신규 레코드들만 있을시 그리드 리셋          
                detailGrid.reset();
                UniAppManager.app.onResetButtonDown();  //삭제후 RESET..
            }
        },*/
 		setDefault: function(params){
            if(!Ext.isEmpty(params.ELEC_SLIP_NO)){
            	searchForm.getField("DATE_FR").setConfig('allowBlank',true);
            	searchForm.getField("DATE_TO").setConfig('allowBlank',true);
                this.processParams(params);
            }else{
                UniAppManager.app.fnInitInputFields();  
            }
        },
        
/*      onPrintButtonDown: function() {
             //var records = detailForm.down('#imageList').getSelectionModel().getSelection();
             var param= Ext.getCmp('resultForm').getValues();
             
             var prgId = '';
             
             
//           if(라디오 값에따라){
//              prgId = 'arc100rkr';    
//           }else if{
//              prgId = 'abh221rkr';
//           }
             
             
             var win = Ext.create('widget.PDFPrintWindow', {
                url: CPATH+'/abh/arc100rkrPrint.do',
//              prgID:prgId,
                prgID: 'arc100rkr',
                   extParam: {
                        COMP_CODE:          param.COMP_CODE       
//                      INOUT_SEQ:          param.INOUT_SEQ,     
//                      INOUT_NUM:          param.INOUT_NUM,      
//                      TO_VENDOR_ID:           param.TO_VENDOR_ID, 
//                      INOUT_CODE:         param.INOUT_CODE,      
//                      INOUT_DATE:         param.INOUT_DATE,      
//                      ITEM_CODE:          param.ITEM_CODE,       
//                      INOUT_Q:            param.INOUT_Q,         
//                      INOUT_P:            param.INOUT_P,         
//                      INOUT_I:            param.INOUT_I,
//                      INOUT_DATE_FR:      param.INOUT_DATE_FR,      
//                      INOUT_DATE_TO:      param.INOUT_DATE_TO  
                   }
                });
                win.center();
                win.show();
                   
          }*/

        processParams: function(params) {
            this.uniOpt.appParams = params;
            
            if (params.PGM_ID == 'aep200skr') {
                searchForm.setValue('ELEC_SLIP_NO',params.ELEC_SLIP_NO);
                searchForm.setValue('DATE_FR','');
                searchForm.setValue('DATE_TO','');
                
                subForm1.setValue('FILE_NO',params.ELEC_SLIP_NO);
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
            masterForm.setValue('REG_DT_NM', UniDate.get('today'));
            masterForm.setValue('GL_DATE', UniDate.get('today'));
//            masterForm.setValue('INVOICE_DATE', UniDate.get('today'));
            masterForm.setValue('PAY_DATE', UniDate.get('today'));
//            masterForm.setValue('GLOBAL_ATTRIBUTE2',masterForm.getField('GLOBAL_ATTRIBUTE2').getStore().getAt(0).get('value'));
           
            if(!Ext.isEmpty(masterForm.getField('GLOBAL_ATTRIBUTE3').getStore().data.items)){
                masterForm.setValue('GLOBAL_ATTRIBUTE3',masterForm.getField('GLOBAL_ATTRIBUTE3').getStore().getAt(0).get('value'));
            }
            masterForm.setValue('TAX_CD', '');
            
            
            if(BsaCodeInfo.paySysGubun == '1'){
            	masterForm.down('#evdeTypeCd1').setHidden(false);
            	masterForm.down('#evdeTypeCd2').setHidden(false);
            	masterForm.down('#evdeTypeCd3').setHidden(true);
            	masterForm.down('#evdeTypeCd4').setHidden(true);
            	
            	masterForm.getField('EVDE_TYPE_CD').setValue('20');
            }else{
            	masterForm.down('#evdeTypeCd1').setHidden(true);
                masterForm.down('#evdeTypeCd2').setHidden(true);
                masterForm.down('#evdeTypeCd3').setHidden(false);
                masterForm.down('#evdeTypeCd4').setHidden(false);
                
                masterForm.getField('EVDE_TYPE_CD').setValue('80');
            }
        },
        
        
        fnInitInputFields: function(){
        	searchForm.getField("DATE_FR").setConfig('allowBlank',false);
        	searchForm.getField("DATE_TO").setConfig('allowBlank',false);

        	searchForm.setValue('DATE_FR',UniDate.get('startOfMonth'));
            searchForm.setValue('DATE_TO',UniDate.get('today'));
            
            searchForm.setValue('PERSON_NUMB',UserInfo.personNumb);
            searchForm.setValue('NAME',personName);
         
            if(BsaCodeInfo.hiddenCheck_1 == 'Y'){
//                Ext.getCmp('globalAttribute2').setHidden(false);
                Ext.getCmp('globalAttribute3').setHidden(false);
                
                Ext.getCmp('payMetoCd').setHidden(false);
                Ext.getCmp('payTermsCd').setHidden(false);
                Ext.getCmp('bankType').setHidden(false);
       
//                masterForm.getField("GLOBAL_ATTRIBUTE2").setConfig('allowBlank',false);
                masterForm.getField("GLOBAL_ATTRIBUTE3").setConfig('allowBlank',false);
                
                masterForm.getField("PAY_METO_CD").setConfig('allowBlank',false);
                masterForm.getField("PAY_TERMS_CD").setConfig('allowBlank',false);
                masterForm.getField("BANK_TYPE").setConfig('allowBlank',false);
                
            }else{
//            	Ext.getCmp('globalAttribute2').setHidden(true);
                Ext.getCmp('globalAttribute3').setHidden(true);
                
                Ext.getCmp('payMetoCd').setHidden(true);
                Ext.getCmp('payTermsCd').setHidden(true);
                Ext.getCmp('bankType').setHidden(true);
                
//                masterForm.getField("GLOBAL_ATTRIBUTE2").setConfig('allowBlank',true);
                masterForm.getField("GLOBAL_ATTRIBUTE3").setConfig('allowBlank',true);
                
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
//                detailForm.getField("PJT_CODE").setConfig('allowBlank',false);
            }else{
                Ext.getCmp('pjts').setHidden(true);
//                detailForm.getField("PJT_CODE").setConfig('allowBlank',true);
            }
            
            if(BsaCodeInfo.hiddenCheck_4 == 'Y'){
                Ext.getCmp('orgAccnt').setHidden(false);
                Ext.getCmp('payDate').setHidden(false);
                
//                detailForm.getField("ORG_ACCNT").setConfig('allowBlank',false);
                masterForm.getField("PAY_DATE").setConfig('allowBlank',false);
            }else{
                Ext.getCmp('orgAccnt').setHidden(true);
                Ext.getCmp('payDate').setHidden(true);
                
                detailForm.getField("ORG_ACCNT").setConfig('allowBlank',true);
                masterForm.getField("PAY_DATE").setConfig('allowBlank',true);
            }
            
            if(BsaCodeInfo.hiddenCheck_5 == 'Y'){
                Ext.getCmp('itemCode').setHidden(false);
//                detailForm.getField("ITEM_CODE").setConfig('allowBlank',false);
            }else{
                Ext.getCmp('itemCode').setHidden(true);
//                detailForm.getField("ITEM_CODE").setConfig('allowBlank',true);
            }
            
        	this.setMasterDefault();

            masterForm.setValue('FILE_NO','');
			fileUploadForm.down('#uploadDisabled').disable(true);
            
            masterForm.setValue('APPLICANT_ID', UserInfo.personNumb);
            masterForm.setValue('APPLICANT_NAME', personName);
            
//            Ext.getCmp('attribute2').setHidden(true);
//            Ext.getCmp('conVendorNm').setHidden(true);
//            Ext.getCmp('conVendorSiteCd').setHidden(true);
//            Ext.getCmp('cardNo').setHidden(true);
//            masterForm.getField("CARD_NO").setConfig('allowBlank',true);
//            masterForm.getField("ATTRIBUTE2").setConfig('allowBlank',true);
//            masterForm.getField("CON_VENDOR_NM").setConfig('allowBlank',true);
//            masterForm.getField("CON_VENDOR_SITE_CD").setConfig('allowBlank',true);
//            
            
//            detailForm.setValue('CONF_DRAFTER',UserInfo.personNumb);
            

        },
        
        fileUploadLoad: function(){
        	var fp = fileUploadForm.down('xuploadpanel');                 //mask on
            fp.getEl().mask('로딩중...','loading-indicator');
            var fileNO = masterForm.getValue('FILE_NO');
            aep140ukrService.getFileList({DOC_NO : fileNO},              //파일조회 메서드  호출(param - 파일번호) 
                function(provider, response) {                          
                    fp.loadData(response.result);                       //업로드 파일 load해서 보여주기
                    fp.getEl().unmask();                                //mask off
    //                                UniAppManager.setToolbarButtons('save',false);      //저장버튼 비활성화
                    
//                    ,,,
                }
             )
        },
        
        fnAcctAmtChange1: function(){   //경비처리 금액 계산 관련      
            var detailData = directDetailStore.data.items;
            
            var drAmtISum = 0;
            
            Ext.each(detailData, function(record,i){
                if(record.get('LINE_TYPE_CD') != 'TAX'){
                    drAmtISum = drAmtISum + record.get('DR_AMT_I');
                }
            });
            
            if(masterForm.getValue('AMOUNT_AMT') - drAmtISum == 0){
                detailForm.setValue('ACCT_AMT',0);
            }else{
                detailForm.setValue('ACCT_AMT',masterForm.getValue('AMOUNT_AMT') - drAmtISum);
            }
        },
        fnAcctAmtChange2: function(){  //삭제시 경비처리 금액 계산 관련     
            var detailData = directDetailStore.data.items;
            
            var drAmtISum = 0;
            
            Ext.each(detailData, function(record,i){
                if(record.get('LINE_TYPE_CD') != 'TAX'){
                    drAmtISum = drAmtISum + record.get('DR_AMT_I');
                }
            });
             if(masterForm.getValue('AMOUNT_AMT') + drAmtISum == 0){
                detailForm.setValue('ACCT_AMT',0);
            }else{
                detailForm.setValue('ACCT_AMT',masterForm.getValue('AMOUNT_AMT') - drAmtISum);
            }
        },
        fnSelectAccntData: function(param){
            aep140ukrService.selectAccntData(param, function(provider, response)   {
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
            aep140ukrService.spAccntGetPossibleBudgAmt110(param, function(provider, response)   {
                if(!Ext.isEmpty(provider)){
                    detailForm.setValue('AMTBG',provider[0].BUDG_I);
                    detailForm.setValue('AMTRM',provider[0].BALN_I);
                }else{
                    detailForm.setValue('AMTBG',0);
                    detailForm.setValue('AMTRM',0);
                }
            })
        },
        fnSetCardRestLmt: function(param){
            aep140ukrService.setCardRestLmt(param, function(provider, response)   {
                if(!Ext.isEmpty(provider)){
                    detailForm.setValue('CARD_REST_LMT',provider.CARD_REST_LMT);
                }else{
                    detailForm.setValue('CARD_REST_LMT',0);
                }
            })
        },
        
        fnCreateRow: function(){
             
            var dcDivCd     = 'D';   
            var acctCd      = detailForm.getValue('ACCT_CD');     
            var acctNm      = detailForm.getValue('ACCT_NM');    
            var costDeptCd  = detailForm.getValue('COST_DEPT_CD');
            var costDeptNm  = detailForm.getValue('COST_DEPT_NM');
//                    var attribute2  = detailForm.getValue('ATTRIBUTE2'); 
            
            var crAmtI      = 0; 
            var taxCd       = detailForm.getValue('TAX_CD');
            var itemDescUse    = detailForm.getValue('ITEM_DESC_USE');   
            var itemDesc    = detailForm.getValue('ITEM_DESC'); 
            
            var drAmtI      = detailForm.getValue('ACCT_AMT');    //차변금액으로 DR_AMT_I
//                    var aquiServ    = detailForm.getValue('AQUI_SERV');   
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
//                        ATTRIBUTE2:      attribute2,         
                                                   
                CR_AMT_I:        crAmtI,
                TAX_CD:          taxCd,
                ITEM_DESC_USE:       itemDescUse,           
                ITEM_DESC:       itemDesc,           
                                                    
                DR_AMT_I:        drAmtI,             
//                        AQUI_SERV:       aquiServ,           
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
//                case fieldName:
//                    UniAppManager.setToolbarButtons('save',true);
//                    break;
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