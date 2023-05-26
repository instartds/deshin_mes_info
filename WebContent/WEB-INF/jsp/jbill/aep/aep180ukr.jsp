<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="aep180ukr"  >
    <t:ExtComboStore comboType="AU" comboCode="J501" /> <!-- 채권구분 -->
    <t:ExtComboStore comboType="AU" comboCode="J502" /> <!-- 이관취소사유 -->
    <t:ExtComboStore comboType="AU" comboCode="J504" /> <!-- 진행상태 -->
    <t:ExtComboStore comboType="AU" comboCode="J504" /> <!-- 관리구분 -->
    <t:ExtComboStore comboType="AU" comboCode="J682" /> <!-- 결재상태 -->
    <t:ExtComboStore comboType="AU" comboCode="A177" /> <!-- 경비유형 -->
    <t:ExtComboStore comboType="AU" comboCode="A006" /> <!-- 원가구분 -->
    <t:ExtComboStore comboType="AU" comboCode="J518" /> <!-- 전표유형 -->
    <t:ExtComboStore comboType="AU" comboCode="J668" /> <!-- 지급방법코드 -->
    <t:ExtComboStore comboType="AU" comboCode="J699" /> <!-- 원천세유형 -->
    <t:ExtComboStore comboType="AU" comboCode="J650" /> <!-- 소득자유형 -->  
    <t:ExtComboStore items="${COMBO_INDUS_CODE}" storeId="indusCodeList" />         <!--사업장-->
    <t:ExtComboStore items="${COMBO_BUSINESS_AREA}" storeId="businessAreaList" />   <!--사업영역-->
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
            read: 'aep180ukrService.selectDetailList',
            update: 'aep180ukrService.updateDetail',
            create: 'aep180ukrService.insertDetail',
            destroy: 'aep180ukrService.deleteDetail',
            syncAll: 'aep180ukrService.saveAll'
        }
    }); 
    
    var directButtonProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            create: 'aep180ukrService.insertButton',
            syncAll: 'aep180ukrService.saveButtonAll'
        }
    }); 
    
    var directProxyRequest = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            create: 'aep180ukrService.insertDetailRequest',
            syncAll: 'aep180ukrService.saveAllRequest'
        }
    }); 
    
    Unilite.defineModel('aep180ukrSearchModel', {
        fields: [
            {name: 'SELECT'               ,text: '선택'           , type: 'boolean'},
            {name: 'RNUM'                 ,text: 'NO'            ,type: 'string'},
            {name: 'SLIP_STAT_CD'         ,text: '전표상태'        ,type: 'string',comboType:'AU', comboCode:'J682' },
            {name: 'INVOICE_DATE'         ,text: '증빙일자'        ,type: 'uniDate'},
            {name: 'GL_DATE'              ,text: '회계일자'        ,type: 'uniDate'},
            {name: 'INVOICE_AMT'          ,text: '총금액'         ,type: 'uniPrice'},
            {name: 'VENDOR_NM'            ,text: '거래처'         ,type: 'string'},
            {name: 'SLIP_DESC'            ,text: '사용내역'        ,type: 'string'},
            {name: 'DEPT_NAME'            ,text: '작성부서'        ,type: 'string'},
            {name: 'REG_NM'       ,text: '작성자'         ,type: 'string'},
            {name: 'REG_DT2'              ,text: '작성일자'        ,type: 'uniDate'},
            {name: 'ELEC_SLIP_NO'         ,text: '관리번호'        ,type: 'string'}
        ]
    });
    
    
    Unilite.defineModel('aep180ukrDetailModel', {
        fields: [
            {name: 'ELEC_SLIP_NO'    ,text: '전표관리번호'       ,type: 'string'},
            {name: 'SEQ'             ,text: 'SEQ'            ,type: 'int'},
            {name: 'LINE_TYPE_CD'    ,text: '차변TAX구분'      ,type: 'string'}, 
            {name: 'DC_DIV_CD'       ,text: '유형'            ,type: 'string',comboType:'AU', comboCode:'J518'},
            {name: 'ACCT_CD'         ,text: '계정코드'         ,type: 'string',allowBlank:false},
            {name: 'ACCT_NM'         ,text: '계정명'          ,type: 'string'},
            {name: 'COST_DEPT_CD'    ,text: '귀속부서'         ,type: 'string',allowBlank:false},
            {name: 'COST_DEPT_NM'    ,text: '귀속부서명'        ,type: 'string'},
            {name: 'TAX_CD'          ,text: '세금'            ,type: 'string'},
            {name: 'DR_AMT_I'        ,text: '차변금액'         ,type: 'uniPrice',allowBlank:false},
            {name: 'CR_AMT_I'        ,text: '대변금액'         ,type: 'uniPrice'},
            {name: 'ITEM_DESC_USE'   ,text: '사용내역'         ,type: 'string',allowBlank:false},
            {name: 'PAY_DATE'        ,text: '지급요청일'         ,type: 'uniDate'},   
            
            {name: 'FILE_UPLOAD_FLAG'	,text: '파일업로드관련'           ,type: 'string'}

        ]
    });
    
    var buttonStore = Unilite.createStore('Aep180ukrButtonStore',{      
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
                var grid = Ext.getCmp('aep180ukrSearchGrid');
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

    var requestStore = Unilite.createStore('Aep180ukrRequestStore',{      
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
                    requestMsg = requestMsg + '<subject>'+ '가지급금 가지급신청 결재' +'</subject>';
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
                    
                },
                failure: function(batch, option) {
                 
                    
                }
            };
            this.syncAllDirect(config);
        }
    });
    
    var directSearchStore = Unilite.createStore('aep180ukrSearchStore', {
        model: 'aep180ukrSearchModel',
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
                read: 'aep180ukrService.selectSearchList'                 
            }
        },
        listeners: {
            load: function(store, records, successful, eOpts) {
            /*	if(store.count() == 0) { 
                	detailGrid.disable();
                	fileUploadForm.down('#uploadDisabled').disable();
            	}else{
            		detailGrid.enable();
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
    
    var directDetailStore = Unilite.createStore('aep180ukrDetailStore', {
        model: 'aep180ukrDetailModel',
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
            if(directDetailStore.data.items.length > 0){
                paramMaster.SLIP_DESC = directDetailStore.data.items[0].data.ITEM_DESC_USE;
            }
            if(inValidRecs.length == 0) {
                config = {
                    params: [paramMaster],
                    success: function(batch, option) {
                        var master = batch.operations[0].getResultSet();
                        masterForm.setValue("ELEC_SLIP_NO", master.ELEC_SLIP_NO);
                        masterForm.setValue("FILE_NO", master.ELEC_SLIP_NO);
                        if(masterForm.getValue('ELEC_SLIP_NO') != ''){
                            directDetailStore.loadStoreRecords(); 
                        /*	if(BsaCodeInfo.paySysGubun == '1'){
                                masterForm.getForm().getFields().each(function(field) {
                                    field.setReadOnly(true);
                                });
                            }*/
                            
                        }else{
                            UniAppManager.app.setMasterDefault();	
                        }
                        UniAppManager.app.fileUploadLoad();
                        UniAppManager.setToolbarButtons('save', false);     
                     } 
                };
                this.syncAllDirect(config);
            } else {
                var grid = Ext.getCmp('aep180ukrDetailGrid');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
        },
        listeners: {
            load: function(store, records, successful, eOpts) {
            	if(!Ext.isEmpty(records)){
            		Ext.each(records,function(record, index){
                        if(record.get('DC_DIV_CD') == 'D'){
                            masterForm.setValue('ACCT_CD',record.get('ACCT_CD'));
                            masterForm.setValue('ACCT_NM',record.get('ACCT_NM'));
                            
                            masterForm.setValue('ITEM_DESC_USE',record.get('ITEM_DESC_USE'));
                        }
            		})
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
            defaults: {xtype: 'uniTextfield'},
            layout: {type: 'uniTable' , columns: 3
// tdAttrs: {style: 'border : 1px solid #ced9e7;'}
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
                fieldLabel:'전표관리번호', 
                name: 'ELEC_SLIP_NO', 
    //            labelWidth:165,
                readOnly:true
            },
            Unilite.popup('DEPT', {
                fieldLabel: '발생부서', 
                    labelWidth:110,
                valueFieldName: 'COST_DEPT_CD',
                textFieldName: 'COST_DEPT_NM',
                readOnly:true,
                allowBlank: false
            }),
            {
                xtype:'component'
            },/*{
            	xtype: 'uniTextfield',
            	fieldLabel:'결재상태',
            	name:'SLIP_STAT_NM',
            	readOnly:true
            	
            }*/{
                xtype: 'uniCombobox',
                fieldLabel: '결재상태',
                name:'SLIP_STAT_CD',   
                comboType:'AU',
                comboCode:'J682',
                readOnly:true
            },{
                xtype: 'container',
                layout: {type : 'uniTable', columns : 2},
                width:470,
    //            padding:'10 10 0 10',
                items :[
                Unilite.popup('CUST',{
                    fieldLabel: '지급처', 
                    labelWidth:110,
                    valueFieldWidth: 90,
                    textFieldWidth: 140,
                    valueFieldName:'VENDOR_ID',
                    textFieldName:'VENDOR_NM',
                    allowBlank:false,
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
                    name: 'VENDOR_SITE_CD',
                    width:110,
                    readOnly:true
                }]
            },{
                xtype: 'uniNumberfield',
                fieldLabel:'신청금액',
                name: 'INVOICE_AMT',
                allowBlank:false,
//                colspan:2,
                listeners:{
                }
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
                        },
                        scope: this
                    },
                    onClear: function(type) {
                    }
                }
            }),	
           	{
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
    //            allowBlank:false,
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
            },{
                xtype: 'uniCombobox',
                fieldLabel: '지급방법',
                id:'payMetoCd',
                name:'PAY_METO_CD', 
                allowBlank:false, 
                comboType:'AU',
                comboCode:'J668',
                hidden:false,
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
                }
            },{
                xtype: 'container',
                layout: {type : 'uniTable', columns : 1},
                items :[{ 
                    xtype: 'uniDatefield',
                    fieldLabel: '지급요청일',
                    labelWidth:110,
                    id:'payDate',
                    name: 'PAY_DATE',
                    value: UniDate.get('today'),
                    allowBlank: false,
                    hidden:true
                }]
            },{
                xtype: 'container',
                layout: {type : 'uniTable', columns : 1},
                colspan:2,
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
                    }
                }]
            },
            Unilite.popup('ACCNT',{
                fieldLabel: '계정코드', 
                valueFieldWidth: 90,
                textFieldWidth: 140,
                valueFieldName:'ACCT_CD',
                textFieldName:'ACCT_NM',
                autoPopup:true,
                allowBlank:false,
                labelWidth:110,
    // validateBlank:'text',
                listeners: {
                    onSelected: {
                        fn: function(records, type) {
                        },
                        scope: this
                    },
                    onClear: function(type) {
                    },
                    applyextparam: function(popup){
                    
                    	 popup.setExtParam({'ADD_QUERY': BsaCodeInfo.paySysGubun == '1' ? 
                                        "A.SPEC_DIVI = 'Q1' AND A.SLIP_SW = 'Y' AND A.GROUP_YN = 'N'" :  ""
                        });
                    	
    // popup.setExtParam({'CHARGE_CODE': getChargeCode[0].SUB_CODE});
//                        popup.setExtParam({'ADD_QUERY': Ext.isEmpty(masterForm.getValue('COST_DEPT_CD')) ? 
//                                        "C.KOSTL_CODE = '' AND C.KOSTL_TYPE IN ('ALL', 'C') AND A.SLIP_SW = 'Y' AND A.GROUP_YN = 'N'" :  "C.KOSTL_CODE = " + masterForm.getValue('COST_DEPT_CD') + " AND C.KOSTL_TYPE IN ('ALL', 'C') AND A.SLIP_SW = 'Y' AND A.GROUP_YN = 'N'"
//                        });
//                        popup.setExtParam({'ADD_QUERY2': "Y"});
                    },
                    onValueFieldChange: function(field, newValue){
                    },
                    onTextFieldChange: function(field, newValue){
                    }
                }
            }),	
            {
                xtype:'uniTextfield',
                fieldLabel:'사용내역',
                name:'ITEM_DESC_USE',
                width:570,
                colspan:2,
                allowBlank:false
            },{
                xtype       : 'uniTextfield',
                fieldLabel  : 'FILE_NO',          
                name        : 'FILE_NO',
                value       : '',                       //임시 파일 번호
                readOnly    : true,
                hidden      : true
            },{
                xtype       : 'uniTextfield',
                fieldLabel  : '삭제파일FID',               //삭제 파일번호를 set하기 위한 hidden 필드
                name        : 'DEL_FID',
                readOnly    : true,
                hidden      : true
            },{
                xtype       : 'uniTextfield',
                fieldLabel  : '등록파일FID',               //등록 파일번호를 set하기 위한 hidden 필드
                name        : 'ADD_FID',
                width       : 500,
                readOnly    : true,
                hidden      : true
            }]
        }],
        api: {
            load: 'aep180ukrService.selectMasterForm'  
        }
    });
    
    var fileUploadForm = Unilite.createSimpleForm('fileUploadForm',{
        region: 'center',
        disabled:false,
        items: [{
            xtype: 'container',
            layout: {type : 'uniTable', columns : 1},
            width:1080,
            itemId:'uploadDisabled',
            disabled:false,
            tdAttrs: {align : 'center'},
            items :[{
                xtype:'component',
                html:'[증빙내역]',
                componentCls : 'component-text_green',
                tdAttrs: {align : 'left'},
                width: 1080
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
            load: 'aep180ukrService.getFileList',   // 조회 api
            submit: 'aep180ukrService.saveFile'      // 저장 api
        }
    });  
    var searchGrid = Unilite.createGrid('aep180ukrSearchGrid', {
        region: 'center',
        excelTitle: '가지급내역',
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
            }
        },{
            xtype: 'button',
            text: '전체취소',
            handler: function() {   
                var records = directSearchStore.data.items;  
                Ext.each(records,  function(record, index, records){
                    record.set('SELECT', false);
                });
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
                        if(confirm('선택한 가지급신청내역을 결재요청 처리하시겠습니까?')) { 
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
                                UniAppManager.app.onSaveDataButtonDown();
                            } else if(res === 'no') {
                                focusMove = true;
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
                    detailGrid.reset();
                    directDetailStore.clearData();
                }
                return focusMove;
            },
            selectionchangerecord:function(selected)    {
                masterForm.setValue('ELEC_SLIP_NO',selected.data.ELEC_SLIP_NO);
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
                                if (field.name == 'ACCT_CD' || 
                                    field.name == 'ACCT_NM' || 
                                    field.name == 'ITEM_DESC_USE' 
                                ){
                                    field.setReadOnly(false);
                                }else{
                                    field.setReadOnly(true);
                                }
                            });
                        }
                        loadFlag = '';
                    },
                    failure: function(form, action) {
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
        items: [{
                xtype:'component',
                html:'[가지급신청내역]',
                componentCls : 'component-text_green',
                tdAttrs: {align : 'left'},
                width: 150
            },searchGrid]
        
    }); 
    
    var detailGrid = Unilite.createGrid('aep180ukrDetailGrid', {
    	height:200,
        width:1080,
        region: 'south',
        excelTitle: '가지급신청내역',
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
            items: [/*{
                xtype: 'uniBaseButton',
                text : '신규',
                tooltip : '초기화',
                iconCls: 'icon-reset',
                width: 26, height: 26,
                itemId : 'detail_reset',
                handler : function() { 
//                    detailForm.clearForm();
//                    detailForm.setValue('TAX_CD', 'NA');
//                    UniAppManager.app.fnAcctAmtChange1();
                }
            },*/{
                xtype: 'uniBaseButton',
                text : '추가',
                tooltip : '추가',
                iconCls: 'icon-new',
                width: 26, height: 26,
                itemId : 'detail_newData',
                handler : function() { 
                	if(!masterForm.getInvalidMessage()) return; 
//                    if(!detailForm.getInvalidMessage()) return; 
                	var checkRow = 0;
                	
                	var detailData = directDetailStore.data.items;
                	Ext.each(detailData, function(record,i){
                        if(record.get('DC_DIV_CD') == 'D'){
                        	alert('가지급은 한 건씩만 등록할 수 있습니다.');
                        	checkRow += 1;
                        }
                    });
                	if(checkRow > 0){
                	   return false;	
                	}else{
                        UniAppManager.app.fnCreateRow();
                	}
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
                        }else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
                            detailGrid.deleteSelectedRow();      
                        }   
                    }
                }               
            },{
                xtype: 'button',
                id: 'btnUpdate',
                text: '수정',
                handler: function() {
                    if(!masterForm.getInvalidMessage()) return; 
//                    if(!detailForm.getInvalidMessage()) return; 
                    
                    var detailGridRecord = detailGrid.getSelectedRecord();
                    if(!Ext.isEmpty(detailGridRecord)){
                    	
                    	if(detailGridRecord.get('DC_DIV_CD') == 'D'){
                            detailGridRecord.set('ACCT_CD'      ,masterForm.getValue('ACCT_CD'));
                            detailGridRecord.set('ACCT_NM'      ,masterForm.getValue('ACCT_NM'));
                            detailGridRecord.set('COST_DEPT_CD' ,masterForm.getValue('COST_DEPT_CD'));
                            detailGridRecord.set('COST_DEPT_NM' ,masterForm.getValue('COST_DEPT_NM'));
                            detailGridRecord.set('DR_AMT_I'     ,masterForm.getValue('INVOICE_AMT'));
                            detailGridRecord.set('ITEM_DESC_USE',masterForm.getValue('ITEM_DESC_USE'));
                            
                            detailGridRecord.set('PAY_DATE'     ,masterForm.getValue('PAY_DATE'));
                    	}else{
                    		alert('유형을 확인하여 주십시오.');
                    	}
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
            { dataIndex: 'TAX_CD'                   ,width:40},
            { dataIndex: 'DR_AMT_I'                 ,width:100},
            { dataIndex: 'CR_AMT_I'                 ,width:100},
            { dataIndex: 'ITEM_DESC_USE'            ,width:150},
// 			{ dataIndex: 'ACCT_AMT' ,width:80,hidden:false},
// 			{ dataIndex: 'AQUI_SERV' ,width:80,hidden:true},
            { dataIndex: 'PAY_DATE'                 ,width:80,hidden:true},
            
            { dataIndex: 'FILE_UPLOAD_FLAG'     	,width:80,hidden:true}
        ],
        listeners: { 
            selectionchangerecord:function(selected)    {
            },
            beforeedit : function( editor, e, eOpts ) {
                return false;
            },
            cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {/*
            	
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
            */}
        }
    });   
    
    
    
     var subForm2 = Unilite.createSimpleForm('subForm2',{
        region: 'south',
        items: [{
            xtype: 'container',
            layout: {type : 'uniTable', columns : 1},
            width:1080,
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
                    masterForm, /*detailForm,*/ subForm2
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
        id  : 'aep180ukrApp',
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
// 		    detailForm.clearForm();
        	masterForm.clearForm();
//            detailForm.clearForm();
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
                        field.name == 'COST_DEPT_CD' ||
                        field.name == 'COST_DEPT_NM' 
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
            
//            if(BsaCodeInfo.paySysGubun == '1'){
//                detailForm.setValue('COST_DEPT_CD',UserInfo.deptCode);
//                detailForm.setValue('COST_DEPT_NM',UserInfo.deptName);
//            }
            
           /* if(BsaCodeInfo.paySysGubun == '1'){    //  SAP 일때 가지급금 SET 하고  DISABLE 관련 가지급금 코드 어떻게 가져올 건지  확인 필요 
                
            }else */
            if(BsaCodeInfo.paySysGubun == '2'){
                masterForm.setValue('ACCT_CD','1111601000');
                masterForm.setValue('ACCT_NM','가지급금');	
                masterForm.getField('ACCT_CD').setDisabled(true);
                masterForm.getField('ACCT_NM').setDisabled(true);
            }
            
            masterForm.setValue('GL_DATE', UniDate.get('today'));
            masterForm.setValue('INVOICE_DATE', UniDate.get('today'));
            masterForm.setValue('PAY_DATE', UniDate.get('today'));
// masterForm.setValue('GLOBAL_ATTRIBUTE2',masterForm.getField('GLOBAL_ATTRIBUTE2').getStore().getAt(0).get('value'));
            if(!Ext.isEmpty(masterForm.getField('GLOBAL_ATTRIBUTE3').getStore().data.items)){
                masterForm.setValue('GLOBAL_ATTRIBUTE3',masterForm.getField('GLOBAL_ATTRIBUTE3').getStore().getAt(0).get('value'));
            }
            
            
//            detailForm.setValue('TAX_CD', 'NA');
// masterForm.getField('EVDE_TYPE_CD').setValue('60');
        },
        
        fnInitInputFields: function(){
        	searchForm.setValue('INVOICE_DATE_FR',UniDate.get('twoMonthsAgo'));
            searchForm.setValue('INVOICE_DATE_TO',UniDate.get('today'));
            searchForm.setValue('GL_DATE_FR',UniDate.get('twoMonthsAgo'));
            searchForm.setValue('GL_DATE_TO',UniDate.get('today'));
            searchForm.setValue('INSERT_DB_TIME_FR',UniDate.get('twoMonthsAgo'));
            searchForm.setValue('INSERT_DB_TIME_TO',UniDate.get('today'));
            
            searchForm.setValue('ELEC_SLIP_TYPE_CD','A060');
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
		 * masterForm.setValue('rufwotkdxo','0');
		 */
            
            if(BsaCodeInfo.hiddenCheck_1 == 'Y'){
                Ext.getCmp('globalAttribute2').setHidden(false);
                Ext.getCmp('globalAttribute3').setHidden(false);
                
                Ext.getCmp('payMetoCd').setHidden(false);
                Ext.getCmp('payTermsCd').setHidden(false);
                Ext.getCmp('bankType').setHidden(false);
       
                
                masterForm.getField("GLOBAL_ATTRIBUTE2").setConfig('allowBlank',false);
                masterForm.getField("GLOBAL_ATTRIBUTE3").setConfig('allowBlank',false);
                
                masterForm.getField("PAY_METO_CD").setConfig('allowBlank',false);
                masterForm.getField("PAY_TERMS_CD").setConfig('allowBlank',false);
                masterForm.getField("BANK_TYPE").setConfig('allowBlank',false);
                
            }else{
            	Ext.getCmp('globalAttribute2').setHidden(true);
                Ext.getCmp('globalAttribute3').setHidden(true);
                
                Ext.getCmp('payMetoCd').setHidden(true);
                Ext.getCmp('payTermsCd').setHidden(true);
                Ext.getCmp('bankType').setHidden(true);
                
                masterForm.getField("GLOBAL_ATTRIBUTE2").setConfig('allowBlank',true);
                masterForm.getField("GLOBAL_ATTRIBUTE3").setConfig('allowBlank',true);
                
                masterForm.getField("PAY_METO_CD").setConfig('allowBlank',true);
                masterForm.getField("PAY_TERMS_CD").setConfig('allowBlank',true);
                masterForm.getField("BANK_TYPE").setConfig('allowBlank',true);
                
            }
            
        /*    if(BsaCodeInfo.hiddenCheck_2 == 'Y'){
            	Ext.getCmp('payType').setHidden(false);
                Ext.getCmp('makeSale').setHidden(false);
//                detailForm.getField("PAY_TYPE").setConfig('allowBlank',false);
//                detailForm.getField("MAKE_SALE").setConfig('allowBlank',false);
            }else{
                Ext.getCmp('payType').setHidden(true);
                Ext.getCmp('makeSale').setHidden(true);
//                detailForm.getField("PAY_TYPE").setConfig('allowBlank',true);
//                detailForm.getField("MAKE_SALE").setConfig('allowBlank',true);
                
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
                
//                detailForm.getField("ORG_ACCNT").setConfig('allowBlank',true);
                masterForm.getField("PAY_DATE").setConfig('allowBlank',true);
            }
            
            if(BsaCodeInfo.hiddenCheck_5 == 'Y'){
                Ext.getCmp('itemCode').setHidden(false);
// detailForm.getField("ITEM_CODE").setConfig('allowBlank',false);
            }else{
                Ext.getCmp('itemCode').setHidden(true);
// detailForm.getField("ITEM_CODE").setConfig('allowBlank',true);
            }
            */
            
            if(BsaCodeInfo.hiddenCheck_4 == 'Y'){
//                Ext.getCmp('orgAccnt').setHidden(false);
                Ext.getCmp('payDate').setHidden(false);
                
// detailForm.getField("ORG_ACCNT").setConfig('allowBlank',false);
                masterForm.getField("PAY_DATE").setConfig('allowBlank',false);
            }else{
//                Ext.getCmp('orgAccnt').setHidden(true);
                Ext.getCmp('payDate').setHidden(true);
                
// detailForm.getField("ORG_ACCNT").setConfig('allowBlank',true);
                masterForm.getField("PAY_DATE").setConfig('allowBlank',true);
            }
        	this.setMasterDefault();

            masterForm.setValue('FILE_NO','');
//			fileUploadForm.down('#uploadDisabled').disable(false);
            
            masterForm.setValue('APPLICANT_ID', UserInfo.personNumb);
            masterForm.setValue('APPLICANT_NAME', personName);
        },
/*        
        fnAcctAmtChange1: function(){   // 경비처리 금액 계산 관련
            var detailData = directDetailStore.data.items;
            
            var drAmtISum = 0;
            
            Ext.each(detailData, function(record,i){
                if(record.get('LINE_TYPE_CD') != 'TAX'){
                    drAmtISum = drAmtISum + record.get('DR_AMT_I');
                }
            });
//            if(masterForm.getValue('INVOICE_AMT') - drAmtISum == 0){
//                detailForm.setValue('ACCT_AMT',0);
//            }else{
//                detailForm.setValue('ACCT_AMT',masterForm.getValue('INVOICE_AMT') - drAmtISum);
//            }
            
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
			 
        },*/
        
        fileUploadLoad: function(){
        	var fp = fileUploadForm.down('xuploadpanel');                 //mask on
            fp.getEl().mask('로딩중...','loading-indicator');
            var fileNO = masterForm.getValue('FILE_NO');
            aep180ukrService.getFileList({DOC_NO : fileNO},              //파일조회 메서드  호출(param - 파일번호) 
                function(provider, response) {                          
                    fp.loadData(response.result);                       //업로드 파일 load해서 보여주기
                    fp.getEl().unmask();                                //mask off
                }
             )
        },
/*
        fnAcctAmtChange2: function(){  // 삭제시 경비처리 금액 계산 관련
            var detailData = directDetailStore.data.items;
            
            var drAmtISum = 0;
            
            Ext.each(detailData, function(record,i){
                if(record.get('LINE_TYPE_CD') != 'TAX'){
                    drAmtISum = drAmtISum + record.get('DR_AMT_I');
                }
            });
//             if(masterForm.getValue('INVOICE_AMT') + drAmtISum == 0){
//                detailForm.setValue('ACCT_AMT',0);
//            }else{
//                detailForm.setValue('ACCT_AMT',masterForm.getValue('INVOICE_AMT') - drAmtISum);
//            }
        
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
		         
        },
        */
//        fnSelectAccntData: function(param){
//            aep180ukrService.selectAccntData(param, function(provider, response)   {
//                if(!Ext.isEmpty(provider)){
//                    Ext.each(provider, function(record,i){
//                        
//                        if(Ext.isEmpty(provider[0].ACCNT)){
//                            Ext.Msg.alert(Msg.sMB099,"지출유형과 제조판관구분에 mapping된 계정코드가 존재하지 않습니다. 회계팀에 문의하십시오.");
//                        }else{
//                            detailForm.setValue('ACCT_CD'       ,provider[0].ACCNT);   
//                            detailForm.setValue('ACCT_NM'       ,provider[0].ACCNT_NAME);   
//                        
//                            if(BsaCodeInfo.hiddenCheck_3 == 'Y'){
//                                if(provider[0].PJT_CODE_YN == 'Y'){
//                                    detailForm.getField("PJT_CODE").setConfig('allowBlank',false);                                                 
//                                }else{
//                                    detailForm.getField("PJT_CODE").setConfig('allowBlank',true);
//                                }
//                            }else{
//                                detailForm.getField("PJT_CODE").setConfig('allowBlank',true);
//                            }
//                            if(BsaCodeInfo.hiddenCheck_4 == 'Y'){
//                                if(provider[0].ORG_ACCNT_YN == 'Y'){
//                                    detailForm.getField("ORG_ACCNT").setConfig('allowBlank',false);                                                 
//                                }else{
//                                    detailForm.getField("ORG_ACCNT").setConfig('allowBlank',true);
//                                }
//                            }else{
//                                detailForm.getField("ORG_ACCNT").setConfig('allowBlank',true);
//                            }
//                            if(BsaCodeInfo.hiddenCheck_5 == 'Y'){
//                                if(provider[0].ITEM_CODE_YN == 'Y'){
//                                    detailForm.getField("ITEM_CODE").setConfig('allowBlank',false);                                                 
//                                }else{
//                                    detailForm.getField("ITEM_CODE").setConfig('allowBlank',true);
//                                }
//                            }else{
//                                detailForm.getField("ITEM_CODE").setConfig('allowBlank',true);
//                            }
//                            
//                            detailForm.setValue('ITEM_DESC',UniDate.getDbDateStr(masterForm.getValue('GL_DATE')) + 
//                            '_' + detailForm.getValue('COST_DEPT_NM') + '_' + provider[0].ACCNT_NAME);
//                            
//                            
//                            if(!Ext.isEmpty(provider[0].ACCNT) && !Ext.isEmpty(detailForm.getValue('COST_DEPT_CD'))){  
//                                var param2 = {
//                                    "BUDG_YYYYMM": UniDate.getDbDateStr(masterForm.getValue('GL_DATE')),
//                                    "ACCNT": provider[0].ACCNT,
//                                    "DEPT_CODE": detailForm.getValue('COST_DEPT_CD')
//                                };
//                                UniAppManager.app.fnPossibleBudgAmt110(param2);
//                            
//                            }
//                            
//                        }
//                    })
//                }else{
//                    Ext.Msg.alert(Msg.sMB099,"지출유형과 제조판관구분에 mapping된 계정코드가 존재하지 않습니다. 회계팀에 문의하십시오.");
//                }
//            })
//        },
//        
//        fnPossibleBudgAmt110: function(param){
//            aep180ukrService.spAccntGetPossibleBudgAmt110(param, function(provider, response)   {
//                if(!Ext.isEmpty(provider)){
//                    detailForm.setValue('AMTBG',provider[0].BUDG_I);
//                    detailForm.setValue('AMTRM',provider[0].BALN_I);
//                }else{
//                    detailForm.setValue('AMTBG',0);
//                    detailForm.setValue('AMTRM',0);
//                }
//            })
//        },
        
        fnCreateRow: function(){
            var dcDivCd     = 'D';   
            var acctCd      = masterForm.getValue('ACCT_CD');     
            var acctNm      = masterForm.getValue('ACCT_NM');    
            var costDeptCd  = masterForm.getValue('COST_DEPT_CD');
            var costDeptNm  = masterForm.getValue('COST_DEPT_NM');
            var crAmtI      = 0; 
            var taxCd       = 'NA'
            var itemDescUse    = masterForm.getValue('ITEM_DESC_USE');   
            var drAmtI      = masterForm.getValue('INVOICE_AMT');    // 차변금액으로
            var payDate    = masterForm.getValue('PAY_DATE');
            var elecSlipNo    = masterForm.getValue('ELEC_SLIP_NO');  
            var lineTypeCd  = 'ITEM'
            
            var r = {
                DC_DIV_CD:       dcDivCd,            
                ACCT_CD:         acctCd,             
                ACCT_NM:         acctNm,             
                COST_DEPT_CD:    costDeptCd,         
                COST_DEPT_NM:    costDeptNm, 
                CR_AMT_I:        crAmtI,
                TAX_CD:          taxCd,
                ITEM_DESC_USE:   itemDescUse,                
                DR_AMT_I:        drAmtI,   
                PAY_DATE:        payDate,
                ELEC_SLIP_NO:    elecSlipNo,
                LINE_TYPE_CD:    lineTypeCd
            };
            detailGrid.createRow(r);
        }
        
/*        fnTaxCalc: function(){   // 소득세 , 지방세 , 실지급액 계산 관련
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
        	
        	if(incomeTaxRefCode6 == 'P1'){
                tempCalc = invoiceAmt - incomeTaxRefCode3;
        	}else if(incomeTaxRefCode6 == 'P2'){
        	   	tempCalc = invoiceAmt - invoiceAmt * 0.8;
        	}else{
        		tempCalc = invoiceAmt;
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
        */
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
    
/*            
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
    });     */
};

</script>
<form id="f1" name="f1" action="http://ep.joinsdev.net/WebSite/Approval/FormLinkForLEGACY.aspx" method="post" onSubmit="return false;" >
<input type="hidden" id="loginid" name="loginid" value="superadmin" />
<input type="hidden" id="fmpf" name="fmpf" value="WF_COST_MIS_REQ" />
<input type="hidden" id="fmbd" name="fmbd" runat="server" />
</form>