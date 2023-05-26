<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="aep100ukr"  >
    <t:ExtComboStore comboType="AU" comboCode="J501" /> <!-- 채권구분 -->
    <t:ExtComboStore comboType="AU" comboCode="J502" /> <!-- 이관취소사유 -->
    <t:ExtComboStore comboType="AU" comboCode="J504" /> <!-- 진행상태 -->
    <t:ExtComboStore comboType="AU" comboCode="J504" /> <!-- 관리구분 -->
    <t:ExtComboStore comboType="AU" comboCode="J682" /> <!-- 결재상태 -->
    <t:ExtComboStore comboType="AU" comboCode="A177" /> <!-- 경비유형 -->
    <t:ExtComboStore comboType="AU" comboCode="A006" /> <!-- 원가구분 -->
    <t:ExtComboStore comboType="AU" comboCode="J518" /> <!-- 전표유형 -->
    <t:ExtComboStore items="${COMBO_CARD_NO}" storeId="cardNoList" />               <!--카드번호-->
    <t:ExtComboStore items="${COMBO_INDUS_CODE}" storeId="indusCodeList" />         <!--사업장-->
    <t:ExtComboStore items="${COMBO_BUSINESS_AREA}" storeId="businessAreaList" />   <!--사업영역-->
    <t:ExtComboStore items="${COMBO_TAX_CD}" storeId="taxCdList" />                 <!--세금코드-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    

</style>    
<script type="text/javascript" charset="UTF-8" src='<c:url value="/resources/plupload/plupload.full.js" />' >
//  ↑ 파일uplod용 plupload.full.js파일 include
</script>
<script type="text/javascript" >

var dataArr = [];

var BsaCodeInfo = { 
	hiddenCheck_1: '${hiddenCheck_1}',
	hiddenCheck_2: '${hiddenCheck_2}',
	hiddenCheck_3: '${hiddenCheck_3}',
	hiddenCheck_4: '${hiddenCheck_4}',
	hiddenCheck_5: '${hiddenCheck_5}',
	
	paySysGubun: '${paySysGubun}'      //MIS , SAP 구분관련
};

var personName   = '${personName}';

var aquiServRemarkWindow; //봉사료반영기준
var elecSlipTransWindow; //전표이관

var detailGridClickFlag = '';

var buttonFlag = '';

var preEmpNo = '';
var nxtEmpNo = '';
var transDesc = '';

var gsCustomCode   = '${gsCustomCode}';     // 지급처코드,지급처명 ,사업자등록번호관련
var gsCustomName   = '${gsCustomName}';
var gsCompanyNum   = '${gsCompanyNum}';

var SAVE_FLAG = '';

var loadFlag = '';

function appMain() {
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 'aep100ukrService.selectDetailList',
            update: 'aep100ukrService.updateDetail',
            create: 'aep100ukrService.insertDetail',
            destroy: 'aep100ukrService.deleteDetail',
            syncAll: 'aep100ukrService.saveAll'
        }
    }); 
    
    var directButtonProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            create: 'aep100ukrService.insertButton',
            syncAll: 'aep100ukrService.saveButtonAll'
        }
    }); 
    
    var directProxyRequest = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            create: 'aep100ukrService.insertDetailRequest',
            syncAll: 'aep100ukrService.saveAllRequest'
        }
    }); 

    /**
     *   Model 정의 
     * @type 
     */

    Unilite.defineModel('aep100ukrSearchModel', {
        fields: [
            {name: 'SELECT'             ,text: '선택'        , type: 'boolean'},
            {name: 'UL_NO'              ,text: 'UL_NO'      ,type: 'string'},
            {name: 'ELEC_SLIP_NO'       ,text: '전표관리번호'   ,type: 'string'},
            {name: 'ROW_NUMBER'         ,text: 'NO'         ,type: 'string'},
            {name: 'UL_CHECK'           ,text: '작성'         ,type: 'string'},
            {name: 'SLIP_STAT_CD'       ,text: '전표상태'      ,type: 'string',comboType:'AU', comboCode:'J682'},
            {name: 'CARD_NO'            ,text: '카드번호'      ,type: 'string'},
            {name: 'CARD_NO2'           ,text: '카드번호'      ,type: 'string'},
			{name: 'CARD_NO_EXPOS'		,text: '카드번호'	   ,type: 'string', defaultValue:'***************'},            
            {name: 'CARD_OWNER_CD'      ,text: '소지자사번'      ,type: 'string'},
            {name: 'CARD_OWNER_NM'      ,text: '소지자'       ,type: 'string'},
            {name: 'APPR_DATE'          ,text: '승인일자'     ,type: 'uniDate'},
            {name: 'APPR_TIME'          ,text: '승인시간'     ,type: 'string'},
            {name: 'AQUI_DATE'          ,text: '전송일'      ,type: 'uniDate'},
            {name: 'AQUI_TIME'          ,text: '전송시간'     ,type: 'string'},
            {name: 'MERC_NM'            ,text: '사용처'      ,type: 'string'},
            {name: 'AQUI_SUM'           ,text: '사용금액'     ,type: 'uniPrice'},
            {name: 'AQUI_TAX'           ,text: '부가세'       ,type: 'uniPrice'},
            {name: 'AQUI_SERV'          ,text: '봉사료'       ,type: 'uniPrice'},
            {name: 'VAT_STAT'           ,text: '과세유형'     ,type: 'string'},
            {name: 'MCC_NM'             ,text: '업종'        ,type: 'string'},
            {name: 'APPR_NO'            ,text: '승인번호'     ,type: 'string'},
            {name: 'MERC_TEL'           ,text: '전화번호'     ,type: 'string'},
            {name: 'MERC_ADDR'          ,text: '주소'        ,type: 'string'},
            {name: 'TRANS_DESC'         ,text: '이관내역'     ,type: 'string'},
            {name: 'AQUI_DATE'          ,text: '매입일자'     ,type: 'uniDate'},
            {name: 'AQUI_TIME'          ,text: '매입시간'     ,type: 'string'}
        ]
    });
    Unilite.defineModel('aep100ukrDetailModel', {
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
            {name: 'AQUI_SERV'       ,text: '봉사료'           ,type: 'uniPrice'},
            {name: 'PAY_TYPE'        ,text: '경비유형'          ,type: 'string'},
            {name: 'MAKE_SALE'       ,text: '원가구분'          ,type: 'string'},
            {name: 'PJT_CODE'        ,text: '사업코드'          ,type: 'string'},
            {name: 'PJT_NAME'        ,text: '사업명'           ,type: 'string'},
            {name: 'ORG_ACCNT'       ,text: '본계정'           ,type: 'string'},
            {name: 'ORG_ACCNT_NM'    ,text: '본계정명'          ,type: 'string'},
            {name: 'PAY_DATE'        ,text: '지급요청일'         ,type: 'uniDate'},
            {name: 'ITEM_CODE'       ,text: '제품코드'          ,type: 'string'},
            {name: 'ITEM_NAME'       ,text: '제품명'           ,type: 'string'},
            
            {name: 'FILE_UPLOAD_FLAG'       ,text: '파일업로드관련'           ,type: 'string'}
        ]
    });
    
    var buttonStore = Unilite.createStore('Aep100ukrButtonStore',{      
        uniOpt: {
            isMaster: false,            // 상위 버튼 연결 
            editable: false,            // 수정 모드 사용 
            deletable: false,           // 삭제 가능 여부 
            useNavi : false         // prev | newxt 버튼 사용
        },
        proxy: directButtonProxy,
        saveStore: function() {             
            var inValidRecs = this.getInvalidRecords();
            var toCreate = this.getNewRecords();
            var toUpdate = this.getUpdatedRecords();                
            var toDelete = this.getRemovedRecords();
            var paramMaster = searchForm.getValues();   
            paramMaster.buttonFlag = buttonFlag;
            if(buttonFlag == 'btnConf'){
            	paramMaster.preEmpNo = preEmpNo;
                paramMaster.nxtEmpNo = nxtEmpNo;
                paramMaster.transDesc = transDesc;
            }
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
                var grid = Ext.getCmp('aep100ukrSearchGrid');
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
    
    var requestStore = Unilite.createStore('Aep100ukrRequestStore',{      
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
                    
                    dataArr.sort();
                    
                    var requestParam = {
                        "ELEC_SLIP_NO": dataArr
                    };
                        
                    aep100ukrService.requestData(requestParam, function(provider, response)   {
                    	if(!Ext.isEmpty(provider)){

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
                            requestMsg = requestMsg + '<subject>'+ '경비처리 법인카드 결재' +'</subject>';
                            requestMsg = requestMsg + '</item>';
                            requestMsg = requestMsg + '<content><![CDATA[';
                            requestMsg = requestMsg + '<table style="border-collapse:collapse; border:1px gray solid; margin:20px 0 20px 0; word-break:break-all;" width= "100%" align="center">';
                            requestMsg = requestMsg + '<tr style="border:1px gray solid;padding: 5px 10px;">';
                            requestMsg = requestMsg + '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6" height= "20", width = "30%">';
                            requestMsg = requestMsg + '계정과목';
                            requestMsg = requestMsg + '</th>';
                            requestMsg = requestMsg + '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6", width = "25%">';
                            requestMsg = requestMsg + '사용금액';
                            requestMsg = requestMsg + '</th>';
                            requestMsg = requestMsg + '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6", width = "25%">';
                            requestMsg = requestMsg + '예산잔액';
                            requestMsg = requestMsg + '</th>';
                            requestMsg = requestMsg + '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6", width = "20%">';
                            requestMsg = requestMsg + '상세리스트보기';
                            requestMsg = requestMsg + '</th>';
                            requestMsg = requestMsg + '</tr>';
        
                            for(var i = 0; i < provider.length; i++){
                                
                                requestMsg = requestMsg + '<tr style="border:1px gray solid;padding: 5px 10px;">';
                                requestMsg = requestMsg + '<td style="border:1px gray solid;padding: 5px 10px;">';
                                requestMsg = requestMsg + provider[i].ACCNT_NAME;
                                requestMsg = requestMsg + '</td>';
                                requestMsg = requestMsg + '<td style="border:1px gray solid;padding: 5px 10px; " align="right">';
                                requestMsg = requestMsg + Ext.util.Format.number(provider[i].AMT,'0,000') + ' 원';
                                requestMsg = requestMsg + '</td>';
                                requestMsg = requestMsg + '<td style="border:1px gray solid;padding: 5px 10px;" align="right">';
                                requestMsg = requestMsg + provider[i].BUDG_AMT + ' 원';
                                requestMsg = requestMsg + '</td>';
                                requestMsg = requestMsg + '<td style="border:1px gray solid;padding: 5px 10px;" align="center">';
                                requestMsg = requestMsg + '<p><a target="_blank" style="color: blue; text-decoration:underline" href="'+ CHOST + CPATH + '/jbill/req/req100skr.do?COMP_CODE='+ UserInfo.compCode + '&KEY_VALUE='+gwKeyValue+'">' + "상세리스트" + '</a></p>';
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
                            
                            dataArr = [];

                    	}
                    })
                },
                failure: function(batch, option) {
                    dataArr = [];
                }
            };
            this.syncAllDirect(config);
        }
    });
    
    /**
     * Store 정의(Service 정의)
     * @type 
     */                 
    var directSearchStore = Unilite.createStore('aep100ukrSearchStore', {
        model: 'aep100ukrSearchModel',
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
                read: 'aep100ukrService.selectSearchList'                 
            }
        },
        listeners: {
            load: function(store, records, successful, eOpts) {
            	if(store.count() == 0) { 
                	detailGrid.disable();
                	subForm1.down('#uploadDisabled').disable();
            	}else{
            		detailGrid.enable();
            		subForm1.down('#uploadDisabled').enable();
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
            param.CARD_NO = searchForm.getField("CARD_NO").rawValue;
            console.log( param );
            this.load({
                params: param
            });
        }
    }); 
    var directDetailStore = Unilite.createStore('aep100ukrDetailStore', {
        model: 'aep100ukrDetailModel',
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
            
            //masterForm의 회계일자와 searchGrid의 승일일자 월이 다르면 저장 안 됨
            var glDate				= UniDate.getDbDateStr(masterForm.getValue('GL_DATE')).substring(0,6);
            var searchGridRecord	= searchGrid.getSelectedRecord();
            var apprDate			= UniDate.getDbDateStr(searchGridRecord.get('APPR_DATE')).substring(0,6);
            if (glDate != apprDate) {
            	alert('회계일자의 월과 승인일자의 월이 일치하지 않습니다. \n ')
            	return false;
            }
            
            var paramMaster= masterForm.getValues();  
            
            if(BsaCodeInfo.paySysGubun == '1'){
            	paramMaster.VENDOR_ID = gsCustomCode;
                paramMaster.VENDOR_NM = gsCustomName;
                paramMaster.VENDOR_SITE_CD = gsCompanyNum;
            }else if(BsaCodeInfo.paySysGubun == '2'){
                paramMaster.VENDOR_ID = UserInfo.personNumb;
                paramMaster.VENDOR_NM = personName;
                paramMaster.VENDOR_SITE_CD = '';
            }
            if(directDetailStore.data.items.length > 0){
                paramMaster.SLIP_DESC = directDetailStore.data.items[0].data.ITEM_DESC;
            }
            if(inValidRecs.length == 0) {
                config = {
                    params: [paramMaster],
                    success: function(batch, option) {
                        var master = batch.operations[0].getResultSet();
                        masterForm.setValue("ELEC_SLIP_NO", master.ELEC_SLIP_NO);
                        masterForm.setValue("FILE_NO", master.ELEC_SLIP_NO);
                        
                        var searchGridSelectedRecord = searchGrid.getSelectedRecord();
                        
                        if(masterForm.getValue('ELEC_SLIP_NO') != ''){
                            searchGridSelectedRecord.set('ELEC_SLIP_NO',master.ELEC_SLIP_NO);
                            searchGridSelectedRecord.set('UL_CHECK','O');
                            searchGridSelectedRecord.set('SLIP_STAT_CD', '10');     //전표상태
                            directSearchStore.commitChanges();  
                            
                            directDetailStore.loadStoreRecords(); 
                            
                        }else{
                            searchGridSelectedRecord.set('ELEC_SLIP_NO','');
                            searchGridSelectedRecord.set('UL_CHECK','X');
                            directSearchStore.commitChanges();  
                            
                            UniAppManager.app.setMasterDefault();
                        }
                        UniAppManager.app.fileUploadLoad();
                        UniAppManager.setToolbarButtons('save', false);     
                     } 
                };
                this.syncAllDirect(config);
            } else {
                var grid = Ext.getCmp('aep100ukrDetailGrid');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
        },
        
        listeners: {
            load: function(store, records, successful, eOpts){
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
        },
        padding:'1 1 1 1',
        disabled:false,
        items: [{ 
            fieldLabel: '사용일자',
            xtype: 'uniDateRangefield',
            startFieldName: 'APPR_DATE_FR',
            endFieldName: 'APPR_DATE_TO',
            allowBlank: false
        },{
            xtype: 'uniCheckboxgroup',  
            fieldLabel: '위임포함',
            items: [{
                boxLabel: '',
                width: 130,
                name: 'MND_STAT_CD',
                inputValue: 'Y',
                checked:true
            }],
            colspan:2
        },
        Unilite.popup('Employee',{
            fieldLabel: '작성자', 
            valueFieldWidth: 90,
            textFieldWidth: 140,
            valueFieldName:'CARD_EXPENSE_ID',
            textFieldName:'CARD_EXPENSE_NAME',
            readOnly:true
        }), 
        {
            xtype: 'uniCombobox',
            fieldLabel: '카드번호',
            name:'CARD_NO',
            store: Ext.data.StoreManager.lookup('cardNoList'),
            valueField: 'text',
            displayField: 'value'
        },{
            xtype: 'container',
            layout: {type : 'uniTable', columns : 2},
            items :[{
                xtype: 'uniCheckboxgroup',  
                fieldLabel: ' ',
                items: [{
                    boxLabel: '봉사료반영',
                    width: 100,
                    name: 'AQUI_SERV_YN',
                    inputValue: 'Y',
                    checked:true,
                    listeners:{
                    	change: function(field, newValue, oldValue, eOpts) {   
                    	   searchForm.setValue('AQUI_SERV_YN',true);
                    	}
                    }
                },{
                    xtype:'component',
                    html:'봉사료반영기준',
                    width: 110, 
                    margin: '5 0 0 0',
                    tdAttrs: {align : 'left'},
                    componentCls : 'component-text_first',
                    listeners:{
                        render: function(component) {
                            component.getEl().on('click', function( event, el ) {
                                openAquiServRemarkWindow();
                            });
                        }
                    }
                },{
                    xtype: 'uniTextfield',
                    fieldLabel:'전표관리번호', 
                    name: 'ELEC_SLIP_NO', 
                    labelWidth:165,
                    readOnly:true,
               		hidden:true
                }]
            }]
        }]
    });
    
    var aquiServRemarkForm = Unilite.createForm('aquiServRemarkForm',{
        region: 'center',
        layout : {type : 'uniTable', columns : 1},
        padding:'1 1 1 1',
        disabled:false,
        items: [{
            xtype: 'container',
            layout: {type : 'uniTable', columns : 1},
            padding:'10 10 10 10',
            items :[{
                xtype:'component',
                html:'1. 세금이 존재해야 한다. (세금코드가 NA가 아니여야 함)</br></br></br>'+' ',
                componentCls: 'component-text_Remark1_bold',
                width:400,
                tdAttrs: {width: '100%',align : 'left'}
            },{
                xtype:'component',
                html:'2. 봉사료 항목에 금액이 있으면 해당 금액을 봉사료로 반영한다.</br></br></br>'+' ',
                componentCls: 'component-text_Remark1_bold',
                width:400,
                tdAttrs: {width: '100%',align : 'left'}
            },{
                xtype:'component',
                html:'3. 봉사료 항목에 금액이 0원이면 아래의 값을 봉사료로 반영한다.</br></br>' +
                	'    봉사료 = 총액 - (세금 * 10 + 세금)</br>' +
                	'    단, 계산된 금액이 10원보다 커야 한다.</br>' +
                	'    (본사, 중앙일보는 100원보다 커야 한다)',
                componentCls: 'component-text_Remark1_bold',
                width:400,
                tdAttrs: {width: '100%',align : 'left'}
            }]
        }]
    });
    
    function openAquiServRemarkWindow() {          
        if(!aquiServRemarkWindow) {
            aquiServRemarkWindow = Ext.create('widget.uniDetailWindow', {
                title: '봉사료반영기준',
                width: 500,                                
                height: 250,
                layout:{type:'vbox', align:'stretch'},
                items: [aquiServRemarkForm],
                tbar:  [
                    '->',{
                        itemId : 'closeBtn',
                        text: '닫기',
                        handler: function() {
                            aquiServRemarkWindow.hide();
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
        aquiServRemarkWindow.center();
        aquiServRemarkWindow.show();
    }
    var elecSlipTransForm = Unilite.createForm('elecSlipTransForm',{
        region: 'center',
        layout : {type : 'uniTable', columns : 1},
        padding:'1 1 1 1',
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
                            elecSlipTransForm.clearForm();
                        },
                        disabled: false
                    },{
                        itemId : 'closeBtn',
                        text: '닫기',
                        handler: function() {
                            elecSlipTransWindow.hide();
                            elecSlipTransForm.clearForm();
                        },
                        disabled: false
                    }
                ],
                listeners : {
                    beforehide: function(me, eOpt) {
                    },
                    beforeclose: function( panel, eOpts ) {
                    },
                    show: function ( panel, eOpts ) {
                    }
                }
            })
        }
        elecSlipTransWindow.center();
        elecSlipTransWindow.show();
    }
    var masterForm = Unilite.createForm('masterForm',{
        region: 'north',
        layout : {type : 'uniTable', columns : 2
        },
        padding:'1 1 1 1',
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
            },
            items: [{
                xtype:'uniTextfield',
                name:'UL_NO',
                hidden:true
            },{
                xtype: 'container',
                layout: {type : 'uniTable', columns : 1},
                items :[
                Unilite.popup('DEPT', {
                    fieldLabel: '발생부서', 
                    valueFieldName: 'COST_DEPT_CD',
                    textFieldName: 'COST_DEPT_NM',
                    readOnly:true,               
                    allowBlank: false
                })]
            },{ 
            	xtype: 'uniDatefield',
                fieldLabel: '회계일자',
                name: 'GL_DATE',
                value: UniDate.get('today'),
                allowBlank: false
            },{
                xtype: 'container',
                layout: {type : 'uniTable', columns : 1},
                width:405,
                items :[{
                    xtype: 'uniTextfield',
                    fieldLabel:'전표관리번호', 
                    name: 'ELEC_SLIP_NO', 
                    labelWidth:165,
                    readOnly:true
                }]
           },{
            	xtype: 'uniCombobox',
                fieldLabel: '사업장',
                id:'globalAttribute2',
                name:'GLOBAL_ATTRIBUTE2', 
                store: Ext.data.StoreManager.lookup('indusCodeList'),
                hidden:true,
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
                hidden:true,
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
                xtype: 'uniNumberfield',
                fieldLabel:'사용금액',
                name: 'INVOICE_AMT',
                readOnly:true
            },{
                xtype: 'uniNumberfield',
                fieldLabel:'부가세액',
                name: 'ATTRIBUTE2',
                readOnly:true
            },{
            	xtype: 'uniCombobox',
                fieldLabel: '결재상태',
                name:'SLIP_STAT_CD',   
                comboType:'AU',
                comboCode:'J682',
                labelWidth:165,
                readOnly:true
            },{
                xtype: 'uniCombobox',
                fieldLabel: '세금코드',
                name:'TAX_CD',   
                store: Ext.data.StoreManager.lookup('taxCdList'),
                allowBlank:false,
                width:325,
                listeners:{
                    change: function(field, newValue, oldValue, eOpts) {   
                    	var searchGridSelectedRecord = searchGrid.getSelectedRecord();
                    	
                    	
                        if(!Ext.isEmpty(newValue) && newValue != 'NA' && !Ext.isEmpty(masterForm.getValue('ATTRIBUTE2')) && masterForm.getValue('ATTRIBUTE2') != 0){
                    	    detailForm.setValue('AQUI_SERV',searchGridSelectedRecord.get('AQUI_SERV'));
                            Ext.getCmp('aquiServ').setHidden(false);
                    	}else{
                    		detailForm.setValue('AQUI_SERV','');
                            Ext.getCmp('aquiServ').setHidden(true);
                    	}

                    	if(loadFlag != 'Y'){
                    	   UniAppManager.app.fnAcctAmtChange1();
                    	}
                    	loadFlag = '';
                    	
//                    	if(BsaCodeInfo.paySysGubun == '1'){
                    		detailForm.setValue('TAX_CD',newValue);
//                    	}
                    }
                }
            },{
                xtype: 'container',
                layout: {type : 'uniTable', columns : 1},
                colspan: 2,
                items :[{ 
                    xtype: 'uniDatefield',
                    fieldLabel: '지급요청일',
                    id:'payDate',
                    name: 'PAY_DATE',
                    value: UniDate.get('today'),
                    allowBlank: false,
                    hidden:true
                }]
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
                        detailForm.setValue('MAKE_SALE','');
                    }
                }
            }),{
                xtype:'uniTextfield',
                fieldLabel: 'FILE_NO',          
                name:'FILE_NO',
                value: '',                //임시 파일 번호
                readOnly:true,
                hidden:true
            } ,{
                xtype:'uniTextfield',
                fieldLabel: '삭제파일FID'   ,       //삭제 파일번호를 set하기 위한 hidden 필드
                name:'DEL_FID',
                readOnly:true,
                hidden:true
            },{
                xtype:'uniTextfield',
                fieldLabel: '등록파일FID'   ,       //등록 파일번호를 set하기 위한 hidden 필드
                name:'ADD_FID',
                width:500,
                readOnly:true,
                hidden:true
            }]  
        }],
        api: {
          load: 'aep100ukrService.selectMasterForm'  
        }
    });
    
    var detailForm = Unilite.createForm('resultForm',{
    	masterGrid: detailGrid,
        region: 'center',
        layout : {type : 'uniTable', columns : 2
        },
        padding:'1 1 1 1',
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
            },
            items: [{
                xtype: 'uniCombobox',
                fieldLabel: '경비유형',
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
            },
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
                        detailForm.setValue('MAKE_SALE',''); 
                    }
                }
            }), 
            Unilite.popup('ACCNT',{
                fieldLabel: '계정코드', 
                valueFieldWidth: 90,
                textFieldWidth: 140,
                valueFieldName:'ACCT_CD',
                textFieldName:'ACCT_NM',
                allowBlank:false,
                autoPopup:false,
                validateBlank:'false',
                listeners: {
                	onSelected: {
                        fn: function(records, type) {
                        	var param = {
                                "ACCT_CD": detailForm.getValue('ACCT_CD')
                            };
                            
                            aep100ukrService.selectAccntYnData(param, function(provider, response)   {
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
                name: 'CARD_REST_LMT',
                readOnly:true
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
            },
            {
                xtype: 'container',
                layout: {type : 'uniTable', columns : 2},
                items :[{
                    xtype: 'uniNumberfield',
                    fieldLabel:'경비처리금액',
                    name: 'ACCT_AMT',
                    width:185,
                    allowBlank:false
               },{
                    xtype: 'container',
                    layout: {type : 'vbox'},
                    items :[{
                        xtype: 'uniNumberfield',
                        fieldLabel:'봉사료',
                        id:'aquiServ',
                        name: 'AQUI_SERV',
                        labelWidth:50,
                        width:140,
                        hidden:true,
                        readOnly:true
                    }]
               }]
            },{
                xtype: 'uniCombobox',
                fieldLabel: '세금코드',
                name:'TAX_CD',   
                store: Ext.data.StoreManager.lookup('taxCdList'),
                width:325,
                allowBlank:false
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
                    listeners: {
                        applyextparam: function(popup){
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
            }]
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
    });
    
    var subForm1 = Unilite.createSimpleForm('subForm1',{
        region: 'center',
        disabled:false,
        items: [{
            xtype: 'container',
            layout: {type : 'uniTable', columns : 1},
            width:1000,
            itemId:'uploadDisabled',
            disabled:true,
            tdAttrs: {align : 'center'},
            items :[{
                xtype:'component',
                html:'[증빙내역]',
                componentCls : 'component-text_green',
                tdAttrs: {align : 'left'},
                width: 1000
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
             load: 'aep100ukrService.getFileList',   //조회 api
             submit: 'aep100ukrService.saveFile'      //저장 api
        }
    });  

    var searchGrid = Unilite.createGrid('aep100ukrSearchGrid', {
        region: 'center',
        excelTitle: '경비처리법인카드이용내역',
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
        bbar: [{
        	xtype: 'button',
            id: 'btnUse',
            text: '개인사용',
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
                        if(confirm('선택한 법인카드 이용내역을 개인사용으로 처리하시겠습니까?\n개인사용으로 변경 후 다시 법인카드로 변경은 재무팀에 문의하셔야 합니다.')) { 
                			buttonStore.clearData();
                            Ext.each(searchRecords, function(record,i){
                                if(record.get('SELECT') == true){
                                	if(record.get('UL_CHECK') == 'O'){
                                        alert("경비처리중인 이용내역이 있습니다.\n개인사용으로 돌리기전 해당 전표내역을 모두 삭제하십시오.");
                                        buttonStore.clearData();
                                        return false;
                                    }
                                    record.phantom = true;
                                    buttonStore.insert(i, record);
                                }
                            });
                            
                            buttonFlag = 'btnUse';
                            
                            buttonStore.saveStore();
                           
                        }else{
                            return false;    
                        }
            		}else{
            		  	Ext.Msg.alert(Msg.sMB099,'개인사용으로 처리할 데이터를 선택해 주세요.');
            		}
            	}else{
            		Ext.Msg.alert(Msg.sMB099,'개인사용으로 처리할 데이터를 선택해 주세요.');
            	}
            }
        },{
        	xtype: 'button',
            id: 'btnConf',
            text: '전표이관',
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
                    	if(confirm('선택한 법인카드 이용내역을 전표이관 처리하시겠습니까?')) { 
                        	Ext.each(searchRecords, function(record,i){
                                if(record.get('SELECT') == true){
                                	if(record.get('UL_CHECK') == 'O'){
                                		alert(record.get('ROW_NUMBER') + "번째 법인카드 이용내역은 미작성 상태가 아닙니다.\n미작성 상태만 전표이관이 가능합니다.");
//                                    		Ext.Msg.alert(Msg.sMB099, record.get('ROW_NUMBER') + "번째 법인카드 이용내역은 미작성 상태가 아닙니다.</br>미작성만 전표이관이 가능합니다.")
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
                        if(confirm('선택한 법인카드 이용내역을 결재요청 처리하시겠습니까?')) { 
                            Ext.each(searchRecords, function(record,i){
                                if(record.get('SELECT') == true){
                                    if(record.get('UL_CHECK') == 'X'){
                                        alert(record.get('ROW_NUMBER') + "번째 법인카드 이용내역은 작성 상태가 아닙니다.\n작성 상태만 결재요청이 가능합니다.");
//                                          Ext.Msg.alert(Msg.sMB099, record.get('ROW_NUMBER') + "번째 법인카드 이용내역은 미작성 상태가 아닙니다.</br>미작성만 전표이관이 가능합니다.")
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
                            	
                            	dataArr = [];
                            	 
                                requestStore.clearData();
                                Ext.each(searchRecords, function(record,i){
                                    if(record.get('SELECT') == true){
                                        record.phantom = true;
                                        requestStore.insert(i, record);
                                        dataArr.push(record.get('ELEC_SLIP_NO'));
                                    }
                                });
                                
                                requestStore.saveStore(); 
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
            {dataIndex: 'SELECT'                         ,width: 40, xtype: 'checkcolumn',align:'center',
                listeners: {    
                	checkchange: function( CheckColumn, rowIndex, checked, eOpts ){
                    }
                }
            },
            { dataIndex: 'UL_NO'                         ,width:60,hidden:true},
            { dataIndex: 'ELEC_SLIP_NO'                  ,width:80,hidden:true},
            { dataIndex: 'ROW_NUMBER'                    ,width:40,align:'center'},
            { dataIndex: 'UL_CHECK'                      ,width:40,align:'center'},
            { dataIndex: 'SLIP_STAT_CD'                  ,width:80,align:'center'},
            { dataIndex: 'CARD_NO'                       ,width:130,hidden:true},
            { dataIndex: 'CARD_NO2'                      ,width:130,hidden:true},
            { dataIndex: 'CARD_NO_EXPOS'                 ,width:140},            
            { dataIndex: 'CARD_OWNER_NM'                 ,width:80,align:'center'},
            { dataIndex: 'APPR_DATE'                     ,width:80},
            { dataIndex: 'APPR_TIME'                     ,width:80,align:'center'},
            { dataIndex: 'AQUI_DATE'                     ,width:80},
            { dataIndex: 'AQUI_TIME'                     ,width:80,align:'center'},
            { dataIndex: 'MERC_NM'                       ,width:200},
            { dataIndex: 'AQUI_SUM'                      ,width:100},
            { dataIndex: 'AQUI_TAX'                      ,width:100},
            { dataIndex: 'AQUI_SERV'                     ,width:80},
            { dataIndex: 'VAT_STAT'                      ,width:80,align:'center'},
            { dataIndex: 'MCC_NM'                        ,width:120},
            { dataIndex: 'APPR_NO'                       ,width:100},
            { dataIndex: 'MERC_TEL'                      ,width:100},
            { dataIndex: 'MERC_ADDR'                     ,width:200},
            { dataIndex: 'TRANS_DESC'                    ,width:150},
            { dataIndex: 'AQUI_DATE'                     ,width:80},
            { dataIndex: 'AQUI_TIME'                     ,width:80,align:'center'}
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
                masterForm.setValue('INVOICE_AMT',selected.data.AQUI_SUM);
                masterForm.setValue('ATTRIBUTE2',selected.data.AQUI_TAX);
                masterForm.setValue('ELEC_SLIP_NO',selected.data.ELEC_SLIP_NO);
                masterForm.setValue('UL_NO',selected.data.UL_NO);
                masterForm.setValue('FILE_NO',selected.data.ELEC_SLIP_NO);
                masterForm.setValue('SLIP_STAT_CD',selected.data.SLIP_STAT_CD);
                //소지자 -> 신청자에 입력
                masterForm.setValue('APPLICANT_ID',selected.data.CARD_OWNER_CD);
                masterForm.setValue('APPLICANT_NAME',selected.data.CARD_OWNER_NM);
                
                masterForm.mask('loading...');
                var param= masterForm.getValues();
                param.ELEC_SLIP_NO = selected.data.ELEC_SLIP_NO;
                loadFlag = 'Y';
                masterForm.getForm().load({
                    params: param,
                    success: function(form, action) {
                        directDetailStore.loadStoreRecords();
                        masterForm.unmask();
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
            	
                var param = {
                    "CARD_NO": selected.data.CARD_NO
                };
                UniAppManager.app.fnSetCardRestLmt(param);
                UniAppManager.app.fileUploadLoad();
                if(BsaCodeInfo.paySysGubun == '1'){
                    if(selected.data.UL_CHECK == 'O'){
                        masterForm.getForm().getFields().each(function(field) {
                            field.setReadOnly(true);
                        });
                    }else{
                        masterForm.getForm().getFields().each(function(field) {
                            if (
                                field.name == 'GL_DATE' || 
                                field.name == 'TAX_CD' || 
                                field.name == 'PAY_DATE' ||
                                field.name == 'APPLICANT_ID' ||
                                field.name == 'APPLICANT_NAME'
                            ){
                                field.setReadOnly(false);
                            }else{
                                field.setReadOnly(true);
                            }
                        });
                    }
                }
            },
            onGridDblClick:function(grid, record, cellIndex, colName, td)	{
				if(colName =="CARD_NO_EXPOS") {
                    grid.ownerGrid.openCryptCardNoPopup(record);                    
				}
			}	            
        },
		openCryptCardNoPopup:function( record )	{
			if(record)	{
				var params = {'CRDT_FULL_NUM': record.get('CARD_NO'), 'GUBUN_FLAG': '1', 'INPUT_YN': 'Y'}
				Unilite.popupCipherComm('grid', record, 'CARD_NO_EXPOS', 'CARD_NO', params);
			}
		} 
    });   
    
    var subForm = Unilite.createSimpleForm('subForm',{
        region: 'north',
        items: [{
            xtype:'component',
            html:'[이용내역]',
            componentCls : 'component-text_green',
            tdAttrs: {align : 'left'},
            width: 150
        },searchGrid]
    }); 
    
    var detailGrid = Unilite.createGrid('aep100ukrDetailGrid', {
    	disabled:true,
    	height:300,
    	width:1000,
        region: 'south',
        excelTitle: '법인카드경비내역',
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
                	if(!masterForm.getInvalidMessage()) return; 
                    if(!detailForm.getInvalidMessage()) return; 
                    var searchGridRecord = searchGrid.getSelectedRecord();
                    var detailData = directDetailStore.data.items;
                    var drAmtISum = 0;
                    var aquiServSum = 0;
                    Ext.each(detailData, function(record,i){
                    	if(record.get('LINE_TYPE_CD') != 'TAX'){
                            drAmtISum = drAmtISum + record.get('DR_AMT_I');
                    	}
                        aquiServSum = aquiServSum + record.get('AQUI_SERV');
                    });
                    
                    var param = {
                        "ACCNT": detailForm.getValue('ACCT_CD')
                    };
                    aep100ukrService.selectBudgctlYn(param, function(provider, response)   {
                        if(!Ext.isEmpty(provider)){
                            if(provider.BUDGCTL_YN == 'Y'){
                            	if(!Ext.isEmpty(detailForm.getValue('AMTRM'))){
                                    if(detailForm.getValue('AMTRM') < detailForm.getValue('ACCT_AMT') + drAmtISum + aquiServSum){
                                        alert("경비금액은 예산잔액을 초과하여 입력할 수 없습니다.");
                                    }else{
                                    	if(!Ext.isEmpty(masterForm.getValue('TAX_CD'))){
                                            if(masterForm.getField("TAX_CD").selection.data.option == 'Y' ){
                                                if(masterForm.getValue('INVOICE_AMT') - masterForm.getValue('ATTRIBUTE2') < detailForm.getValue('ACCT_AMT') + drAmtISum + aquiServSum){
                                                    alert("차변(원화)금액의 총합이 대변금액 보다 클 수 없습니다.");
                                                }else{
                                                    UniAppManager.app.fnCreateRow();
                                                }
                                            }else{
                                            	if(masterForm.getValue('INVOICE_AMT') < detailForm.getValue('ACCT_AMT') + drAmtISum + aquiServSum){
                                                    alert("차변(원화)금액의 총합이 대변금액 보다 클 수 없습니다.");
                                                }else{
                                                    UniAppManager.app.fnCreateRow();
                                                }
                                            }
                                    	}
                                    }
                                }else{
                                    alert("예산잔액이 없습니다.");   
                                }
                            }else{
                            	if(!Ext.isEmpty(masterForm.getValue('TAX_CD'))){
                                    if(masterForm.getField("TAX_CD").selection.data.option == 'Y' ){
                                        if(masterForm.getValue('INVOICE_AMT') - masterForm.getValue('ATTRIBUTE2') < detailForm.getValue('ACCT_AMT') + drAmtISum + aquiServSum){
                                            alert("차변(원화)금액의 총합이 대변금액 보다 클 수 없습니다.");
                                        }else{
                                            UniAppManager.app.fnCreateRow();
                                        }
                                    }else{
                                    	if(masterForm.getValue('INVOICE_AMT') < detailForm.getValue('ACCT_AMT') + drAmtISum + aquiServSum){
                                            alert("차변(원화)금액의 총합이 대변금액 보다 클 수 없습니다.");
                                        }else{
                                            UniAppManager.app.fnCreateRow();
                                        }
                                    }
                            	}
                            }
                        }else{
                        	if(!Ext.isEmpty(masterForm.getValue('TAX_CD'))){
                                if(masterForm.getField("TAX_CD").selection.data.option == 'Y' ){
                                	if(masterForm.getValue('INVOICE_AMT') - masterForm.getValue('ATTRIBUTE2') < detailForm.getValue('ACCT_AMT') + drAmtISum + aquiServSum){
                                        alert("차변(원화)금액의 총합이 대변금액 보다 클 수 없습니다.");
                                    }else{
                                        UniAppManager.app.fnCreateRow();
                                    }
                                }else{
                                	if(masterForm.getValue('INVOICE_AMT') < detailForm.getValue('ACCT_AMT') + drAmtISum + aquiServSum){
                                        alert("차변(원화)금액의 총합이 대변금액 보다 클 수 없습니다.");
                                    }else{
                                        UniAppManager.app.fnCreateRow();
                                    }
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
                        detailGridRecord.set('ITEM_CODE'    ,detailForm.getValue('ITEM_CODE'));
                        detailGridRecord.set('ITEM_NAME'    ,detailForm.getValue('ITEM_NAME'));
                        
                        UniAppManager.app.fnAcctAmtChange1();
                        
                    }
                }
            }]
        }],
        store: directDetailStore,
        columns: [
            { dataIndex: 'SEQ'             ,width:80,hidden:true},
            { dataIndex: 'ELEC_SLIP_NO'    ,width:80,hidden:true},
            { dataIndex: 'LINE_TYPE_CD'       ,width:50,align:'center',hidden:true},
            { dataIndex: 'DC_DIV_CD'       ,width:50,align:'center'},
            { dataIndex: 'ACCT_CD'         ,width:80},
            { dataIndex: 'ACCT_NM'         ,width:150},
            { dataIndex: 'COST_DEPT_CD'    ,width:80},
            { dataIndex: 'COST_DEPT_NM'    ,width:100},
            { dataIndex: 'TAX_CD'          ,width:100},
            { dataIndex: 'DR_AMT_I'        ,width:100},
            { dataIndex: 'CR_AMT_I'        ,width:100},
            { dataIndex: 'ITEM_DESC_USE'   ,width:200},
            { dataIndex: 'ITEM_DESC'       ,width:150},
            { dataIndex: 'AQUI_SERV'       ,width:80,hidden:true},
            { dataIndex: 'PAY_TYPE'        ,width:80,hidden:true},
            { dataIndex: 'MAKE_SALE'       ,width:80,hidden:true},
            { dataIndex: 'PJT_CODE'        ,width:80,hidden:true},
            { dataIndex: 'PJT_NAME'        ,width:80,hidden:true},
            { dataIndex: 'ORG_ACCNT'       ,width:80,hidden:true},
            { dataIndex: 'ORG_ACCNT_NM'    ,width:80,hidden:true},
            { dataIndex: 'PAY_DATE'        ,width:80,hidden:true},
            { dataIndex: 'ITEM_CODE'       ,width:80,hidden:true},
            { dataIndex: 'ITEM_NAME'       ,width:80,hidden:true},
            { dataIndex: 'FILE_UPLOAD_FLAG'       ,width:80,hidden:true}
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
                detailForm.setValue('ITEM_CODE'     ,record.get('ITEM_CODE'));
                detailForm.setValue('ITEM_NAME'     ,record.get('ITEM_NAME')); 
                
                masterForm.setValue('PAY_DATE'      ,record.get('PAY_DATE'));
                
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
        hidden:true,
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
            layout : {type:'vbox', align:'stretch'},
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
                itemId :'aep100ukrvSouthForm',
                hidden:true,
                layout:{type:'vbox', align:'stretch'},
                items:[
                    subForm1
                ]
            }]
        }],
        id  : 'aep100ukrApp',
        fnInitBinding: function(params){
            UniAppManager.setToolbarButtons(['newData'/*,'query'*/], false);
            UniAppManager.setToolbarButtons(['reset'], true);
            
            this.setDefault(params);
        },
        onQueryButtonDown: function() {  
			if(!searchForm.getInvalidMessage()){
				return false;
			}
            directSearchStore.loadStoreRecords();   
            subForm2.show();
            this.down("#aep100ukrvSouthForm").show();
            
        },
        onResetButtonDown: function() {
        	searchGrid.reset();
        	directSearchStore.clearData();
        	masterForm.clearForm();
            detailForm.clearForm();
            subForm1.clearForm();
            subForm1.down('xuploadpanel').reset();
            detailGrid.reset();
            directDetailStore.clearData();
            detailGrid.disable();
            UniAppManager.setToolbarButtons(['newData',/*'query',*/'save','delete'], false);
            UniAppManager.setToolbarButtons(['reset'], true);
            UniAppManager.app.fnInitInputFields();  
            SAVE_FLAG = '';
            
            if(BsaCodeInfo.paySysGubun == '1'){
                masterForm.getForm().getFields().each(function(field) {
                if(
                        field.name == 'GL_DATE' || 
                        field.name == 'TAX_CD' || 
                        field.name == 'PAY_DATE' ||
                        field.name == 'APPLICANT_ID' ||
                        field.name == 'APPLICANT_NAME'
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
            
            /**
             * 파일업로드 관련
             **/
            var fp = subForm1.down('xuploadpanel'); 
            var addFiles = fp.getAddFiles();                
            var removeFiles = fp.getRemoveFiles();
            masterForm.setValue('ADD_FID', addFiles);                  //추가 파일 담기
            masterForm.setValue('DEL_FID', removeFiles);               //삭제 파일 담기

            directDetailStore.saveStore();
        },
        setDefault: function(params){
            if(!Ext.isEmpty(params.ELEC_SLIP_NO)){
            	searchForm.getField("APPR_DATE_FR").setConfig('allowBlank',true);
            	searchForm.getField("APPR_DATE_TO").setConfig('allowBlank',true);
                this.processParams(params);
            }else{
                UniAppManager.app.fnInitInputFields();  
            }
        },
        setMasterDefault: function(){
        	masterForm.setValue('SLIP_STAT_CD','10');
            masterForm.setValue('UL_NO','');
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
            masterForm.setValue('PAY_DATE', UniDate.get('today'));
            
            if(!Ext.isEmpty(masterForm.getField('GLOBAL_ATTRIBUTE2').getStore().data.items)){
                masterForm.setValue('GLOBAL_ATTRIBUTE2',masterForm.getField('GLOBAL_ATTRIBUTE2').getStore().getAt(0).get('value'));
            }
            if(!Ext.isEmpty(masterForm.getField('GLOBAL_ATTRIBUTE3').getStore().data.items)){
                masterForm.setValue('GLOBAL_ATTRIBUTE3',masterForm.getField('GLOBAL_ATTRIBUTE3').getStore().getAt(0).get('value'));
            }
            masterForm.setValue('TAX_CD', '');
        },
        processParams: function(params) {
            this.uniOpt.appParams = params;
            if(params.PGM_ID == 'arc200skr') {
                detailForm.setValue('ELEC_SLIP_NO',params.ELEC_SLIP_NO);
                subForm1.setValue('FILE_NO',params.ELEC_SLIP_NO);
                this.onQueryButtonDown();
            } else if (params.PGM_ID == 'aep200skr') {
                searchForm.setValue('ELEC_SLIP_NO',params.ELEC_SLIP_NO);
                searchForm.setValue('APPR_DATE_FR','');
                searchForm.setValue('APPR_DATE_TO','');
	            masterForm.setValue('COST_DEPT_CD',UserInfo.deptCode);
	            masterForm.setValue('COST_DEPT_NM',UserInfo.deptName);
            	detailForm.setValue('COST_DEPT_CD',UserInfo.deptCode);
                detailForm.setValue('COST_DEPT_NM',UserInfo.deptName);
                this.onQueryButtonDown();
            }
        },
        fnInitInputFields: function(){
        	searchForm.getField("APPR_DATE_FR").setConfig('allowBlank',false);
        	searchForm.getField("APPR_DATE_TO").setConfig('allowBlank',false);
        	searchForm.setValue('APPR_DATE_FR',UniDate.get('twoMonthsAgo'));
            searchForm.setValue('APPR_DATE_TO',UniDate.get('today'));
            searchForm.setValue('ELEC_SLIP_NO','');
        	searchForm.setValue('CARD_EXPENSE_ID',UserInfo.personNumb);
            searchForm.setValue('CARD_EXPENSE_NAME',personName);
            
            if(BsaCodeInfo.hiddenCheck_1 == 'Y'){
                Ext.getCmp('globalAttribute2').setHidden(false);
                Ext.getCmp('globalAttribute3').setHidden(false);
                masterForm.getField("GLOBAL_ATTRIBUTE2").setConfig('allowBlank',false);
                masterForm.getField("GLOBAL_ATTRIBUTE3").setConfig('allowBlank',false);
            }else{
            	Ext.getCmp('globalAttribute2').setHidden(true);
                Ext.getCmp('globalAttribute3').setHidden(true);
                masterForm.getField("GLOBAL_ATTRIBUTE2").setConfig('allowBlank',true);
                masterForm.getField("GLOBAL_ATTRIBUTE3").setConfig('allowBlank',true);
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
            }else{
                Ext.getCmp('pjts').setHidden(true);
            }
            
            if(BsaCodeInfo.hiddenCheck_4 == 'Y'){
                Ext.getCmp('orgAccnt').setHidden(false);
                Ext.getCmp('payDate').setHidden(false);
                masterForm.getField("PAY_DATE").setConfig('allowBlank',false);
            }else{
                Ext.getCmp('orgAccnt').setHidden(true);
                Ext.getCmp('payDate').setHidden(true);
                detailForm.getField("ORG_ACCNT").setConfig('allowBlank',true);
                masterForm.getField("PAY_DATE").setConfig('allowBlank',true);
            }
            
            if(BsaCodeInfo.hiddenCheck_5 == 'Y'){
                Ext.getCmp('itemCode').setHidden(false);
            }else{
                Ext.getCmp('itemCode').setHidden(true);
            }
        	this.setMasterDefault();
            masterForm.setValue('FILE_NO','');
            subForm1.down('#uploadDisabled').disable();
            masterForm.setValue('APPLICANT_ID', UserInfo.personNumb);
            masterForm.setValue('APPLICANT_NAME', personName);
        },
        fileUploadLoad: function(){
        	var fp = subForm1.down('xuploadpanel');                 //mask on
            fp.getEl().mask('로딩중...','loading-indicator');
            var fileNO = masterForm.getValue('FILE_NO');
            aep100ukrService.getFileList({DOC_NO : fileNO},              //파일조회 메서드  호출(param - 파일번호) 
                function(provider, response) {                          
                    fp.loadData(response.result);                       //업로드 파일 load해서 보여주기
                    fp.getEl().unmask();                                //mask off
                }
            )
        },
        fnAcctAmtChange1: function(){   //경비처리 금액 계산 관련
        	var searchGridRecord = searchGrid.getSelectedRecord();
            if(!Ext.isEmpty(searchGridRecord)){        
                var detailData = directDetailStore.data.items;
                var drAmtISum = 0;
                var aquiServSum = 0;
                Ext.each(detailData, function(record,i){
                    if(record.get('LINE_TYPE_CD') != 'TAX'){
                        drAmtISum = drAmtISum + record.get('DR_AMT_I');
                    }
                    aquiServSum = aquiServSum + record.get('AQUI_SERV');
                });
                
                if(!Ext.isEmpty(masterForm.getValue('TAX_CD'))){
                    if(masterForm.getField("TAX_CD").selection.data.option == 'Y' ){
                    	if(searchGridRecord.get('AQUI_SERV') == 0){
                            detailForm.setValue('ACCT_AMT', masterForm.getValue('INVOICE_AMT') - masterForm.getValue('ATTRIBUTE2') - (drAmtISum));
                            detailForm.setValue('AQUI_SERV',0);
                        }else if(searchGridRecord.get('AQUI_SERV') != 0 && masterForm.getValue('INVOICE_AMT') - masterForm.getValue('ATTRIBUTE2') - (drAmtISum + aquiServSum) == 0){
                            detailForm.setValue('ACCT_AMT',0);
                            detailForm.setValue('AQUI_SERV',0);
                        }else{
                            detailForm.setValue('ACCT_AMT',masterForm.getValue('INVOICE_AMT') - masterForm.getValue('ATTRIBUTE2') - (drAmtISum + aquiServSum + searchGridRecord.get('AQUI_SERV')));
                            detailForm.setValue('AQUI_SERV',searchGridRecord.get('AQUI_SERV'));
                        }      
                    }else{
                    	if(searchGridRecord.get('AQUI_SERV') == 0){
                            detailForm.setValue('ACCT_AMT', masterForm.getValue('INVOICE_AMT') - (drAmtISum));
                            detailForm.setValue('AQUI_SERV',0);
                        }else if(searchGridRecord.get('AQUI_SERV') != 0 && masterForm.getValue('INVOICE_AMT') - (drAmtISum + aquiServSum) == 0){
                            detailForm.setValue('ACCT_AMT',0);
                            detailForm.setValue('AQUI_SERV',0);
                        }else{
                            detailForm.setValue('ACCT_AMT',masterForm.getValue('INVOICE_AMT') - (drAmtISum + aquiServSum + searchGridRecord.get('AQUI_SERV')));
                            detailForm.setValue('AQUI_SERV',searchGridRecord.get('AQUI_SERV'));
                        }  
                    }
                }else{
                	detailForm.setValue('ACCT_AMT',0);
                    detailForm.setValue('AQUI_SERV',0);
                }
            }
        },
        fnAcctAmtChange2: function(){  //삭제시 경비처리 금액 계산 관련
            var searchGridRecord = searchGrid.getSelectedRecord();
            if(!Ext.isEmpty(searchGridRecord)){               
                var detailData = directDetailStore.data.items;
                var drAmtISum = 0;
                var aquiServSum = 0;
                Ext.each(detailData, function(record,i){
                    if(record.get('LINE_TYPE_CD') != 'TAX'){
                        drAmtISum = drAmtISum + record.get('DR_AMT_I');
                    }
                    aquiServSum = aquiServSum + record.get('AQUI_SERV');
                });
                if(!Ext.isEmpty(masterForm.getValue('TAX_CD'))){
                    if(masterForm.getField("TAX_CD").selection.data.option == 'Y' ){
                    	if(searchGridRecord.get('AQUI_SERV') == 0){
                            detailForm.setValue('ACCT_AMT', masterForm.getValue('INVOICE_AMT') - masterForm.getValue('ATTRIBUTE2') - (drAmtISum));
                            detailForm.setValue('AQUI_SERV',0);
                        }else if(searchGridRecord.get('AQUI_SERV') != 0 && masterForm.getValue('INVOICE_AMT') - masterForm.getValue('ATTRIBUTE2') - (drAmtISum - aquiServSum) == 0){
                            detailForm.setValue('ACCT_AMT',0);
                            detailForm.setValue('AQUI_SERV',0);
                        }else{
                            detailForm.setValue('ACCT_AMT',masterForm.getValue('INVOICE_AMT') - masterForm.getValue('ATTRIBUTE2') - (drAmtISum + aquiServSum + searchGridRecord.get('AQUI_SERV')));
                            detailForm.setValue('AQUI_SERV',searchGridRecord.get('AQUI_SERV'));
                        }   
                    }else{
                    	if(searchGridRecord.get('AQUI_SERV') == 0){
                            detailForm.setValue('ACCT_AMT', masterForm.getValue('INVOICE_AMT') - (drAmtISum));
                            detailForm.setValue('AQUI_SERV',0);
                        }else if(searchGridRecord.get('AQUI_SERV') != 0 && masterForm.getValue('INVOICE_AMT') - (drAmtISum - aquiServSum) == 0){
                            detailForm.setValue('ACCT_AMT',0);
                            detailForm.setValue('AQUI_SERV',0);
                        }else{
                            detailForm.setValue('ACCT_AMT',masterForm.getValue('INVOICE_AMT') - (drAmtISum + aquiServSum + searchGridRecord.get('AQUI_SERV')));
                            detailForm.setValue('AQUI_SERV',searchGridRecord.get('AQUI_SERV'));
                        }   
                    }
                }else{
                	detailForm.setValue('ACCT_AMT',0);
                    detailForm.setValue('AQUI_SERV',0);
                }
            }
        },
        fnSelectAccntData: function(param){
        	aep100ukrService.selectAccntData(param, function(provider, response)   {
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
        	aep100ukrService.spAccntGetPossibleBudgAmt110(param, function(provider, response)   {
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
            aep100ukrService.setCardRestLmt(param, function(provider, response)   {
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
            var crAmtI      = 0; 
            var taxCd       = detailForm.getValue('TAX_CD');
            var itemDescUse = detailForm.getValue('ITEM_DESC_USE');   
            var itemDesc    = detailForm.getValue('ITEM_DESC'); 
            var drAmtI      = detailForm.getValue('ACCT_AMT');    //차변금액으로 DR_AMT_I
            var aquiServ    = detailForm.getValue('AQUI_SERV');   
            var payType     = detailForm.getValue('PAY_TYPE');    
            var makeSale    = detailForm.getValue('MAKE_SALE');   
            var pjtCode     = detailForm.getValue('PJT_CODE');    
            var pjtName     = detailForm.getValue('PJT_NAME');
            var orgAccnt    = detailForm.getValue('ORG_ACCNT');
            var orgAccntNm  = detailForm.getValue('ORG_ACCNT_NM');
            var itemCode    = detailForm.getValue('ITEM_CODE');
            var itemName    = detailForm.getValue('ITEM_NAME');
            
            var payDate     = masterForm.getValue('PAY_DATE');
            var elecSlipNo  = masterForm.getValue('ELEC_SLIP_NO'); 
            
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
                ITEM_DESC_USE:   itemDescUse,           
                ITEM_DESC:       itemDesc,           
                                                    
                DR_AMT_I:        drAmtI,             
                AQUI_SERV:       aquiServ,           
                PAY_TYPE:        payType,            
                MAKE_SALE:       makeSale,           
                PJT_CODE:        pjtCode,
                PJT_NAME:        pjtName,  
                ORG_ACCNT:       orgAccnt,
                ORG_ACCNT_NM:    orgAccntNm,
                ITEM_CODE:       itemCode,
                ITEM_NAME:       itemName,
                
                PAY_DATE:        payDate,
                ELEC_SLIP_NO:    elecSlipNo,
                
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
