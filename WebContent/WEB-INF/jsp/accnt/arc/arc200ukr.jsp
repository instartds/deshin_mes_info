<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="arc200ukr"  >
    <t:ExtComboStore comboType="AU" comboCode="J501" /> <!-- 채권구분 -->
    <t:ExtComboStore comboType="AU" comboCode="J502" /> <!-- 이관취소사유 -->
    <t:ExtComboStore comboType="AU" comboCode="J504" /> <!-- 진행상태 -->
    <t:ExtComboStore comboType="AU" comboCode="J504" /> <!-- 관리구분 -->
    <t:ExtComboStore comboType="AU" comboCode="A134" /> <!-- 결재상태 -->
    
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>    
<script type="text/javascript">
  var protocol =   ("https:" == document.location.protocol)  ? "https" : "http"  ;
  if(protocol == "https")	{
	  document.write( unescape( "%3Cscript src='"+ protocol+ "://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js' type='text/javascript' %3E %3C/script%3E")  );
  }else {
  	document.write( unescape( "%3Cscript src='"+ protocol+ "://dmaps.daum.net/map_js_init/postcode.v2.js' type='text/javascript' %3E %3C/script%3E") );
  }
</script><!-- Unilite.popup('ZIP',..) -->

<script type="text/javascript" charset="UTF-8" src='<c:url value="/resources/plupload/plupload.full.js" />' >
//  ↑ 파일uplod용 plupload.full.js파일 include
</script>
<script type="text/javascript" >

//링크로 넘어왔을 때, save버튼 활성화 관련 로직
var buttonFlag = false;
var SAVE_FLAG = '';
var personName   = '${personName}';

function appMain() {
    
    /**
     *   Model 정의 
     * @type 
     */

    Unilite.defineModel('arc200ukrModel', {
        fields: [
//          {name: ''           ,text: 'NO'                 ,type: 'string'},
            {name: 'MNG_DATE'           ,text: '일자'                     ,type: 'string'},
            {name: 'MNG_GUBUN'          ,text: '관리구분'                   ,type: 'string'},
            {name: 'REMARK'             ,text: '내용'                     ,type: 'string'},
            {name: 'RECEIVE_AMT'        ,text: '접수금액'                   ,type: 'uniPrice'},
            {name: 'COLLECT_AMT'        ,text: '수금액'                    ,type: 'uniPrice'},
            {name: 'NOTE_NUM'           ,text: '어음번호'                   ,type: 'string'},
            {name: 'EXP_DATE'           ,text: '만기일'                    ,type: 'uniDate'},
            {name: 'DRAFTER'            ,text: '입력자'                    ,type: 'string'}
        ]
    });
    /**
     * Store 정의(Service 정의)
     * @type 
     */                 
    var directDetailStore = Unilite.createStore('arc200ukrDetailStore', {
        model: 'arc200ukrModel',
        uniOpt: {
            isMaster: true,         // 상위 버튼 연결 
            editable: false,            // 수정 모드 사용 
            deletable: false,           // 삭제 가능 여부 
            allDeletable:false,
            useNavi : false         // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {
                read: 'arc200ukrService.selectList'                 
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
        },
        loadStoreRecords: function(){
            var param= Ext.getCmp('resultForm').getValues();
            console.log( param );
            this.load({
                params: param
            });
        }
    }); 
    
    
    var detailForm = Unilite.createForm('resultForm',{
        region: 'north',
        layout : {type : 'uniTable', columns : 2,
            tableAttrs: { /*style: 'border : 1px solid #ced9e7;',*/width: '100%'}
//          tdAttrs: {/*style: 'border : 1px solid #ced9e7;',*/width: '100%'/*,align : 'left'*/}
    
        },
        padding:'1 1 1 1',
        border:true,
        disabled:false,
        items: [
    	Unilite.popup('COMP',{
            fieldLabel: '이관회사', 
            valueFieldName:'RECE_COMP_CODE',
            textFieldName:'RECE_COMP_NAME',
            allowBlank:false
        }), 
    	{
            xtype: 'uniCombobox',
            fieldLabel: '진행상태',
            name:'MNG_GUBUN',   
            comboType:'AU',
            comboCode:'J504',
            readOnly:true
        },{
            xtype: 'container',
            layout: {type : 'uniTable', columns : 2},
            width:500,
//          id:'tdPayDtlNo',
            tdAttrs: {width:500/*align : 'center'*/},
            items :[{
                xtype:'uniDatefield',
                fieldLabel:'이관일',
                name:'CONF_RECE_DATE',
                value: UniDate.get('today'),
                allowBlank:false
            },{
                xtype: 'uniTextfield',
                fieldLabel:'채권번호', 
                name: 'CONF_RECE_NO', 
                readOnly:true
           }]      
        },{
            xtype: 'container',
            layout: {type : 'uniTable', columns : 2},
            width:500,
//          id:'tdPayDtlNo',
            tdAttrs: {width:500/*align : 'center'*/},
            items :[{
                xtype:'uniNumberfield',
                fieldLabel:'금액',
                name:'RECE_AMT',
                allowBlank:false
            },{
                xtype:'uniNumberfield',
                fieldLabel:'수금액',
                name:'TOT_COLLECT_AMT',
                readOnly:true
            }]
        },
        Unilite.popup('Employee',{
            fieldLabel: '법무담당', 
            valueFieldWidth: 90,
            textFieldWidth: 140,
            valueFieldName:'CONF_DRAFTER',
            textFieldName:'CONF_DRAFTER_NAME',
            readOnly: true
        }),
        {
            xtype: 'container',
            layout: {type : 'uniTable', columns : 2},
            width:500,
//          id:'tdPayDtlNo',
            tdAttrs: {width:500/*align : 'center'*/},
            items :[{
                xtype:'uniNumberfield',
                fieldLabel:'조정',
                name:'TOT_ADJUST_AMT',
                readOnly:true
            },{
                xtype:'uniNumberfield',
                fieldLabel:'잔액',
                name:'TOT_BALANCE_AMT',
                readOnly:true
            }]
        },{
            xtype: 'uniCombobox',
            fieldLabel: '채권구분',
            name:'RECE_GUBUN',  
            comboType:'AU',
            comboCode:'J501',
            allowBlank:false
        },{
            xtype: 'container',
            layout: {type : 'uniTable', columns : 2},
            width:500,
//          id:'tdPayDtlNo',
            tdAttrs: {width:500/*align : 'center'*/},
            items :[{
                xtype:'uniNumberfield',
                fieldLabel:'대손처리',
                name:'TOT_DISPOSAL_AMT',
                readOnly:true
            },{
                xtype:'uniNumberfield',
                fieldLabel:'장부가액',
                name:'TOT_BOOKVALUE_AMT',
                readOnly:true
            }]
        },{
            xtype: 'container',
            layout: {type : 'uniTable', columns : 2},
            width:500,
//          id:'tdPayDtlNo',
            tdAttrs: {width:500/*align : 'center'*/},
            items :[
                Unilite.popup('CUST',{
                    fieldLabel: '거래처', 
                    valueFieldName:'CUSTOM_CODE',
                    textFieldName:'CUSTOM_NAME',
                    allowBlank:false,
                    listeners: {
                        onSelected: {
                            fn: function(records, type) {
                                detailForm.setValue('COMPANY_NUM', records[0]["COMPANY_NUM"]);
                                detailForm.setValue('TOP_NAME', records[0]["TOP_NAME"]);
                                detailForm.setValue('ADDR1', records[0]["ADDR1"]);
                                detailForm.setValue('PHONE_1', records[0]["TELEPHON"]);
                                detailForm.setValue('ZIP_CODE1', records[0]["ZIP_CODE"]);
                                
                            },
                            scope: this
                        },
                        onClear: function(type) {
                            detailForm.setValue('COMPANY_NUM', '');
                            detailForm.setValue('TOP_NAME', '');
                            detailForm.setValue('ADDR', '');
                            detailForm.setValue('PHONE_1', '');
                            detailForm.setValue('ZIP_CODE', '');
                        }
                    }
                }),
            {
                xtype:'uniTextfield',
                name:'COMPANY_NUM',
                width:165,
                readOnly:true
            }]      
        },{
            xtype:'uniTextfield',
            fieldLabel:'대표자',
            name:'TOP_NAME',
            width:490
        },{
            xtype: 'container',
            layout: {type : 'uniTable', columns : 2},
            width:500,
//          id:'tdPayDtlNo',
            tdAttrs: {width:500/*align : 'center'*/},
            items :[
                Unilite.popup('ZIP',{
                    fieldLabel: '주소1',
                    showValue:false,
                    textFieldWidth:130, 
                    textFieldName:'ZIP_CODE1',
                    DBtextFieldName:'ZIP_CODE1',
                    validateBlank:false,
                    popupHeight:570,
                    listeners: { 
                        'onSelected': {
                            fn: function(records, type  ){
                            	detailForm.setValue('ZIP_CODE1', records[0]['ZIP_CODE']);
                                detailForm.setValue('ADDR1', records[0]['ZIP_NAME']+records[0]['ADDR2']);
                            },
                        scope: this
                        },
                        'onClear' : function(type)  {
                        	
                            detailForm.setValue('ADDR1', '');
                        }
                    }
                }),
            {
                xtype:'uniTextfield',
                name:'ADDR1',
                width:265
            }]      
        },{
            xtype:'uniTextfield',
            fieldLabel:'비고',
            name:'REMARK',
            width:490
        },{
            xtype: 'container',
            layout: {type : 'uniTable', columns : 2},
            width:500,
//          id:'tdPayDtlNo',
            tdAttrs: {width:500/*align : 'center'*/},
            items :[
                Unilite.popup('ZIP',{
                    fieldLabel: '주소2',
                    showValue:false,
                    textFieldWidth:130, 
                    textFieldName:'ZIP_CODE2',
                    DBtextFieldName:'ZIP_CODE2',
                    validateBlank:false,
                    popupHeight:570,
                    listeners: { 
                        'onSelected': {
                            fn: function(records, type  ){
                            	detailForm.setValue('ZIP_CODE2', records[0]['ZIP_CODE']);
                                detailForm.setValue('ADDR2', records[0]['ZIP_NAME']+records[0]['ADDR2']);
                            },
                        scope: this
                        },
                        'onClear' : function(type)  {
                            detailForm.setValue('ADDR2', '');
                        }
                    }
                }),
            {
                xtype:'uniTextfield',
                name:'ADDR2',
                width:265
            }]      
        },{
            xtype: 'container',
            layout: {type : 'uniTable', columns : 3},
            width:500,
//          id:'tdPayDtlNo',
            tdAttrs: {width:500/*align : 'center'*/},
            items :[{
                xtype:'uniTextfield',
                fieldLabel:'연락처1/2/3',
                name:'PHONE_1',
                width:230
            },{
                xtype:'uniTextfield',
                name:'PHONE_2',
                width:130
            },{
                xtype:'uniTextfield',
                name:'PHONE_3',
                width:130
            }]      
        },{
            xtype: 'container',
            layout: {type : 'uniTable', columns : 2},
            width:500,
//          id:'tdPayDtlNo',
            tdAttrs: {width:500/*align : 'center'*/},
            items :[
                Unilite.popup('ZIP',{
                    fieldLabel: '주소3',
                    showValue:false,
                    textFieldWidth:130, 
                    textFieldName:'ZIP_CODE3',
                    DBtextFieldName:'ZIP_CODE3',
                    validateBlank:false,
                    popupHeight:570,
                    listeners: { 
                        'onSelected': {
                            fn: function(records, type  ){
                            	detailForm.setValue('ZIP_CODE3', records[0]['ZIP_CODE']);
                                detailForm.setValue('ADDR3', records[0]['ZIP_NAME']+records[0]['ADDR2']);
                            },
                        scope: this
                        },
                        'onClear' : function(type)  {
                            detailForm.setValue('ADDR3', '');
                        }
                    }
                }),
            {
                xtype:'uniTextfield',
                name:'ADDR3',
                width:265
            }]      
        }],
        api: {
            load: 'arc200ukrService.selectForm' ,
            submit: 'arc200ukrService.syncMaster'   
        },
        listeners : {
            uniOnChange:function( basicForm, dirty, eOpts ) {
                console.log("onDirtyChange");
                if(!buttonFlag) {
	                UniAppManager.setToolbarButtons('save', false);

                } else {
	                if(basicForm.isDirty()) {
	                    UniAppManager.setToolbarButtons('save', true);
	                }else {
	                    UniAppManager.setToolbarButtons('save', false);
	                }
                }
                buttonFlag = true;
            }
        }
    });
    var subForm1 = Unilite.createSimpleForm('resultForm2',{
        region: 'north',
        border:true,
        disabled:true,
//      split:true,
        items: [{
            xtype: 'container',
            layout: {type : 'uniTable', columns : 1},
            width:500,
            tdAttrs: {align : 'center'},
            items :[{
                xtype:'component',
                html:'[파일업로드]',
                componentCls : 'component-text_green',
                tdAttrs: {align : 'left'},
                width: 1000
            },{
                xtype: 'xuploadpanel',
                bbar: ['->',{
//                    id: 'aaaaaa',
                    text: '조회',
                    handler: function() {
                    	
                    	UniAppManager.app.fileUploadLoad();
                    	
                   /* 	var fp = subForm1.down('xuploadpanel');                 //mask on
                        fp.getEl().mask('로딩중...','loading-indicator');
                        var fileNO = subForm1.getValue('FILE_NO');
                        arc200ukrService.getFileList({DOC_NO : fileNO},              //파일조회 메서드  호출(param - 파일번호) 
                            function(provider, response) {                          
                                fp.loadData(response.result);                       //업로드 파일 load해서 보여주기
                                fp.getEl().unmask();                                //mask off
//                                UniAppManager.setToolbarButtons('save',false);      //저장버튼 비활성화
                            }
                         )*/
                    }
                },{
//                    id: 'bbbb',
                    text: '저장',
                    handler: function() {
                    	var fp = subForm1.down('xuploadpanel'); 
                        var addFiles = fp.getAddFiles();                
                        var removeFiles = fp.getRemoveFiles();
                        subForm1.setValue('ADD_FID', addFiles);                  //추가 파일 담기
                        subForm1.setValue('DEL_FID', removeFiles);               //삭제 파일 담기
                        var param= subForm1.getValues();
                        subForm1.getEl().mask('로딩중...','loading-indicator'); //mask on
                        subForm1.getForm().submit({                              //폼 submit 함수 호출
                             params : param,
                             success : function(form, action) {
                                UniAppManager.updateStatus(Msg.sMB011);             //저장되었습니다.(message) 
//                                UniAppManager.setToolbarButtons('save',false);      //저장버튼 비활성화
                                subForm1.getEl().unmask();                       //mask off
                             }
                    	});
                    }
                }],
                height: 150,
                flex: 0,
                padding: '0 0 0 0',
                listeners : {
                    change: function() {
//                        UniAppManager.app.setToolbarButtons('save', true);  //파일 추가or삭제시 저장버튼 on
                    }
                }
            },{
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
                readOnly:true,
                hidden:true
            }]
        }],
        api: {
             load: 'arc200ukrService.getFileList',   //조회 api
             submit: 'arc200ukrService.saveFile'      //저장 api
        }
    });  
    var subForm2 = Unilite.createSimpleForm('resultForm3',{
        region: 'north',
        border:false,
//      split:true,
        items: [{
            xtype: 'container',
            layout: {type : 'uniTable', columns : 1},
            width:150,
            tdAttrs: {align : 'center'},
            items :[{
                xtype:'component',
                html:'[관리일지]',
                componentCls : 'component-text_green',
                tdAttrs: {align : 'left'},
                width: 150
            }]
        }]
    });  
    
    var detailGrid = Unilite.createGrid('arc200ukrGrid', {
//      split:true,
        layout: 'fit',
        region: 'center',
        excelTitle: '법무채권등록관리일지',
        uniOpt: {
            useGroupSummary: false,
            useLiveSearch: true,
            useContextMenu: false,
            useMultipleSorting: true,
            onLoadSelectFirst: false,
            useRowNumberer: true,
            expandLastColumn: true,
            useRowContext: true,
            state: {
                useState: true,         
                useStateList: true      
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
        store: directDetailStore,
        columns: [
            { dataIndex: 'MNG_DATE'             ,width:80},
            { dataIndex: 'MNG_GUBUN'            ,width:88},
            { dataIndex: 'REMARK'               ,width:250},
            { dataIndex: 'RECEIVE_AMT'          ,width:100},
            { dataIndex: 'COLLECT_AMT'          ,width:100},
            { dataIndex: 'NOTE_NUM'             ,width:120},
            { dataIndex: 'EXP_DATE'             ,width:88},
            { dataIndex: 'DRAFTER'              ,width:100}
        ]
    });   

    Unilite.Main( {
        borderItems:[{
            region:'center',
            layout: 'border',
            border: false,
            items:[
                detailForm, subForm1, subForm2, detailGrid
            ]   
        }],
        id  : 'arc200ukrApp',
        fnInitBinding: function(params){
            this.setDefault(params);
            
            UniAppManager.setToolbarButtons(['newData','query','save'], false);
            UniAppManager.setToolbarButtons(['reset'], true);
        },
        onQueryButtonDown: function() {      
            var param= detailForm.getValues();
            
            detailForm.getForm().load({
                params: param,
                success: function(form, action) {
                    
                    SAVE_FLAG = action.result.data.SAVE_FLAG;
                                            
                    if(SAVE_FLAG == 'U'){
                        UniAppManager.setToolbarButtons('delete',true); 
                    }
                    detailForm.getField('CONF_RECE_DATE').focus();  
                    detailForm.getField('RECE_COMP_CODE').setReadOnly(true);
                    detailForm.getField('RECE_COMP_NAME').setReadOnly(true);
                    
                    UniAppManager.app.fileUploadLoad();
                },
                failure: function(form, action) {
//                      detailForm.unmask();
//                      subForm1.unmask();
                }
            });
            directDetailStore.loadStoreRecords();   
            
            UniAppManager.setToolbarButtons('reset',true);
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
            detailForm.clearForm();
            subForm1.clearForm();
            subForm1.down('xuploadpanel').reset();
            detailGrid.reset();
            directDetailStore.clearData();
            UniAppManager.app.fnInitInputFields();  
            SAVE_FLAG = '';
            detailForm.getField('RECE_COMP_CODE').setReadOnly(false);
            detailForm.getField('RECE_COMP_NAME').setReadOnly(false);
            UniAppManager.setToolbarButtons(['newData','query','save','delete'], false);
            UniAppManager.setToolbarButtons(['reset'], true);
        },
        
        onSaveDataButtonDown: function(config) { 
        	
            if(!detailForm.getInvalidMessage()) return; 
            
            var param = detailForm.getValues();
            param.SAVE_FLAG = SAVE_FLAG;
            detailForm.getForm().submit({
            params : param,
                success : function(form, action) {
                    detailForm.getForm().wasDirty = false;
                    detailForm.resetDirtyStatus();                                          
                    UniAppManager.setToolbarButtons('save', false); 
                    UniAppManager.updateStatus(Msg.sMB011);// 저장되었습니다
                    if(SAVE_FLAG == ''){
                        detailForm.setValue('CONF_RECE_NO',action.result.CONF_RECE_NO);
                        
                        subForm1.setValue('FILE_NO',action.result.CONF_RECE_NO);
                        subForm1.setDisabled(false);
                    }
                    
                    UniAppManager.app.onQueryButtonDown();
                }   
            });
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
                        subForm1.clearForm();
                        subForm1.down('xuploadpanel').reset();
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
            
            if(!Ext.isEmpty(params.PGM_ID)){
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
//                      DIV_CODE:           param.DIV_CODE, 
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
            detailForm.clearForm();
            subForm1.clearForm();
            subForm1.down('xuploadpanel').reset();
            detailGrid.reset();
            directDetailStore.clearData();
            UniAppManager.setToolbarButtons(['newData','query','save','delete'], false);
            UniAppManager.setToolbarButtons(['reset'], true);
            SAVE_FLAG = '';
            
            this.uniOpt.appParams = params;
            
            if(params.PGM_ID == 'arc200skr' || params.PGM_ID == 'arc210skr') {
                detailForm.setValue('RECE_COMP_CODE'	,params.RECE_COMP_CODE);
                detailForm.setValue('RECE_COMP_NAME'	,params.RECE_COMP_NAME);
                detailForm.setValue('CONF_RECE_DATE'	,params.CONF_RECE_DATE);
                detailForm.setValue('RECE_AMT'			,params.RECE_AMT);
                detailForm.setValue('RECE_GUBUN'		,params.RECE_GUBUN);
                detailForm.setValue('CUSTOM_CODE'		,params.CUSTOM_CODE);
                detailForm.setValue('CUSTOM_NAME'		,params.CUSTOM_NAME);
                detailForm.setValue('CONF_RECE_NO'       ,params.CONF_RECE_NO);                                
                subForm1.setValue('FILE_NO'				,params.CONF_RECE_NO);
                subForm1.setDisabled(false);
            }
            //링크로 넘어왔을 때, save버튼 활성화 관련 로직
            buttonFlag = false;
            var param= detailForm.getValues();
            
            detailForm.getForm().load({
                params: param,
                success: function(form, action) {
                    
                    SAVE_FLAG = action.result.data.SAVE_FLAG;
                                            
                    if(SAVE_FLAG == 'U'){
                        UniAppManager.setToolbarButtons('delete',true); 
                    }
                    detailForm.getField('CONF_RECE_DATE').focus();  
                    
                    
                    UniAppManager.app.fileUploadLoad();
                },
                failure: function(form, action) {
//                      detailForm.unmask();
//                      subForm1.unmask();
                }
            });
            directDetailStore.loadStoreRecords();
//			directDetailStore.commitChanges();  
            UniAppManager.setToolbarButtons('delete',true); 
        },
        
        fnInitInputFields: function(){
            detailForm.setValue('CONF_RECE_DATE',UniDate.get('today'));
            
            detailForm.setValue('CONF_DRAFTER',UserInfo.personNumb);
            detailForm.setValue('CONF_DRAFTER_NAME',personName);
            
            
            subForm1.setValue('FILE_NO','');
            subForm1.setDisabled(true);
//            detailForm.setValue('GW_STATUS','0');
        },
        fileUploadLoad: function(){
        	var fp = subForm1.down('xuploadpanel');                 //mask on
            fp.getEl().mask('로딩중...','loading-indicator');
            var fileNO = subForm1.getValue('FILE_NO');
            arc200ukrService.getFileList({DOC_NO : fileNO},              //파일조회 메서드  호출(param - 파일번호) 
                function(provider, response) {                          
                    fp.loadData(response.result);                       //업로드 파일 load해서 보여주기
                    fp.getEl().unmask();                                //mask off
    //                                UniAppManager.setToolbarButtons('save',false);      //저장버튼 비활성화
                }
             )
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
/*    Unilite.createValidator('validator02', {
        forms: {'formA:':detailForm},
        validate: function( type, fieldName, newValue, lastValidValue, record, form, field) {
            console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'lastValidValue':lastValidValue, 'record':record});
            var rv = true;  
            switch(fieldName) { 
                case fieldName:
                    UniAppManager.setToolbarButtons('save',true);
                    break;
            }
            return rv;
        }
    });     */
};

</script>