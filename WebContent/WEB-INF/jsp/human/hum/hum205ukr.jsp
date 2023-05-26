<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hum205ukr">
    <t:ExtComboStore comboType="BOR120"  />                     <!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="B010" />         <!-- 사용여부(예/아니오) -->
    <t:ExtComboStore comboType="AU" comboCode="H004" />         <!-- 근무조 --> 
    <t:ExtComboStore comboType="AU" comboCode="H005" />         <!-- 직위구분 --> 
    <t:ExtComboStore comboType="AU" comboCode="H006" />         <!-- 직책구분 --> 
    <t:ExtComboStore comboType="AU" comboCode="H094" />         <!-- 발령코드 --> 
    <t:ExtComboStore comboType="AU" comboCode="H023" />         <!--  퇴사사유         --> 
    <t:ExtComboStore comboType="AU" comboCode="H173" /><!--  직렬             -->
    <t:ExtComboStore comboType="AU" comboCode="H072" /><!--  직종      -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
	
	var excelWindow;
	
    var batchEmployWin;                 //일괄적용 시 사원선택 버튼에 사용되는 팝업
    var payGrdWin;                      //급호봉 / 지급수당 / 기술수당 팝업
    var gsGradeFlag     = '';           //급호봉 / 지급수당 / 기술수당 flag
    var gsGridOrPanel   = '';           //팝업 호출한 곳 구분 (01: dataForm, 02: grid)
    var wageStd         = ${wageStd};   //급호봉 코드 정보
    
    var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            create  : 'hum205ukrService.insertList',                
            read    : 'hum205ukrService.selectList',
            update  : 'hum205ukrService.updateList',
            destroy : 'hum205ukrService.deleteList',
            syncAll : 'hum205ukrService.saveAll'
        }
    });
        
    var directButtonProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            create  : 'hum205ukrService.runProcedure',
            syncAll : 'hum205ukrService.callProcedure'
        }
    });
    
    Unilite.defineModel('hum205ukrModel', {
        fields: [
            {name: 'COMP_CODE'              , text: '<t:message code="system.label.human.workteam" default="근무조"/>'               , type: 'string', comboType:'AU', comboCode:'H004', allowBlank: false},
            {name: 'PERSON_NUMB'            , text: '<t:message code="system.label.human.personnumb" default="사번"/>'              , type: 'string', allowBlank: false},
            {name: 'NAME'                   , text: '<t:message code="system.label.human.employeename" default="사원명"/>'           , type: 'string', allowBlank: false},
            {name: 'DEPT_CODE'              , text: '<t:message code="system.label.human.deptcode" default="부서코드"/>'              , type: 'string', allowBlank: false},
            {name: 'DEPT_NAME'              , text: '<t:message code="system.label.human.deptname" default="부서명"/>'               , type: 'string'},
            {name: 'ANNOUNCE_DATE'          , text: '<t:message code="system.label.human.announcedate" default="발령일자"/>'          , type: 'uniDate', allowBlank: false},
            {name: 'ANNOUNCE_CODE'          , text: '<t:message code="system.label.human.announcecode" default="발령코드"/>'          , type: 'string', comboType:'AU', comboCode:'H094', allowBlank: false},
            {name: 'RETR_RESN'              , text: '<t:message code="system.label.human.retrreson" default="퇴사사유"/>'             , type: 'string', comboType:'AU', comboCode:'H023'},
            {name: 'APPLY_YEAR'             , text: '<t:message code="system.label.human.applyyear" default="적용년"/>'              , type: 'int', defaultValue: 0},
            {name: 'APPLY_YN'               , text: '<t:message code="system.label.human.confirmedpending" default="확정여부"/>'      , type: 'string', comboType:'AU', comboCode:'B010', allowBlank: false},
            {name: 'BE_DIV_CODE'            , text: '<t:message code="system.label.human.bedept" default="발령전"/>'               , type: 'string', comboType:'BOR120'},
            {name: 'AF_DIV_CODE'            , text: '<t:message code="system.label.human.afdept" default="발령후"/>'               , type: 'string', comboType:'BOR120', allowBlank: false},
            {name: 'BE_DEPT_CODE'           , text: '<t:message code="system.label.human.bedept" default="발령전"/>'      	, type: 'string'},
            {name: 'BE_DEPT_NAME'           , text: '<t:message code="system.label.human.bedept" default="발령전"/>'      	, type: 'string'},
            {name: 'AF_DEPT_CODE'           , text: '<t:message code="system.label.human.afdept" default="발령후"/>'      	, type: 'string', allowBlank: false},
            {name: 'AF_DEPT_NAME'           , text: '<t:message code="system.label.human.afdept" default="발령후"/>'      	, type: 'string', allowBlank: false},
            {name: 'POST_CODE'              , text: '<t:message code="system.label.human.bedept" default="발령전"/>'      	, type: 'string', comboType:'AU', comboCode:'H005'},
            {name: 'ABIL_CODE'              , text: '<t:message code="system.label.human.bedept" default="발령전"/>'      	, type: 'string', comboType:'AU', comboCode:'H006'},
            {name: 'AF_POST_CODE'           , text: '<t:message code="system.label.human.afdept" default="발령후"/>'          , type: 'string', comboType:'AU', comboCode:'H005', allowBlank: false},
            {name: 'AF_ABIL_CODE'           , text: '<t:message code="system.label.human.afdept" default="발령후"/>'          , type: 'string', comboType:'AU', comboCode:'H006'},
            {name: 'PAY_GRADE_01'           , text: '<t:message code="system.label.human.bedept" default="발령전"/>'          , type: 'string'},
            {name: 'PAY_GRADE_02'           , text: '<t:message code="system.label.human.bedept" default="발령전"/>'          , type: 'string'},
            {name: 'AF_PAY_GRADE_01'        , text: '<t:message code="system.label.human.afdept" default="발령후"/>'          , type: 'string'},
            {name: 'AF_PAY_GRADE_02'        , text: '<t:message code="system.label.human.afdept" default="발령후"/>'          , type: 'string'},
            {name: 'AFFIL_CODE'             , text: '<t:message code="system.label.human.bedept" default="발령전"/>'          , type: 'string', comboType:'AU', comboCode:'H173'},
            {name: 'AF_AFFIL_CODE'          , text: '<t:message code="system.label.human.afdept" default="발령후"/>'          , type: 'string', comboType:'AU', comboCode:'H173'},
            {name: 'KNOC'            		, text: '<t:message code="system.label.human.bedept" default="발령전"/>'          , type: 'string', comboType:'AU', comboCode:'H072'},
            {name: 'AF_KNOC'            	, text: '<t:message code="system.label.human.afdept" default="발령후"/>'          , type: 'string', comboType:'AU', comboCode:'H072'},
            {name: 'ANNOUNCE_REASON'        , text: '<t:message code="system.label.human.announcereason" default="발령사유"/>' , type: 'string'}
            
        ]                                         
    });
    
    Unilite.Excel.defineModel('excel.hum205ukr.sheet01', {
        fields: [
            {name: 'COMP_CODE'              , text: '법인코드'               , type: 'string', allowBlank: false},
            {name: 'PERSON_NUMB'            , text: '<t:message code="system.label.human.personnumb" default="사번"/>'              , type: 'string', allowBlank: false},
            {name: 'NAME'                   , text: '<t:message code="system.label.human.employeename" default="사원명"/>'           , type: 'string', allowBlank: false},
            {name: 'DEPT_CODE'              , text: '<t:message code="system.label.human.deptcode" default="부서코드"/>'              , type: 'string', allowBlank: false},
            {name: 'DEPT_NAME'              , text: '<t:message code="system.label.human.deptname" default="부서명"/>'               , type: 'string'},
            {name: 'ANNOUNCE_DATE'          , text: '<t:message code="system.label.human.announcedate" default="발령일자"/>'          , type: 'uniDate', allowBlank: false},
            {name: 'ANNOUNCE_CODE'          , text: '<t:message code="system.label.human.announcecode" default="발령코드"/>'          , type: 'string', comboType:'AU', comboCode:'H094', allowBlank: false},
            {name: 'RETR_RESN'         		, text: '<t:message code="system.label.human.retrreson" default="퇴사사유코드"/>'          , type: 'string'},
            {name: 'RETR_RESN_NAME'         , text: '<t:message code="system.label.human.retrreson" default="퇴사사유"/>'             , type: 'string'},
            {name: 'APPLY_YEAR'             , text: '<t:message code="system.label.human.applyyear" default="적용년"/>'              , type: 'int', defaultValue: 0},
            {name: 'APPLY_YN'               , text: '<t:message code="system.label.human.confirmedpending" default="확정여부"/>'      , type: 'string', comboType:'AU', comboCode:'B010', allowBlank: false},
            
            {name: 'BE_DIV_CODE'            , text: '사업장'      , type: 'string', comboType:'BOR120'},
            {name: 'AF_DIV_CODE'            , text: '사업장코드'   , type: 'string'},
            {name: 'AF_DIV_NAME'            , text: '사업장'      , type: 'string'},
            
            {name: 'BE_DEPT_CODE'           , text: '부서코드'     , type: 'string'},
            {name: 'BE_DEPT_NAME'           , text: '부서명'      , type: 'string'},
            {name: 'AF_DEPT_CODE'           , text: '부서코드'     , type: 'string', allowBlank: false},
            {name: 'AF_DEPT_NAME'           , text: '부서명'      , type: 'string', allowBlank: false},
            {name: 'POST_CODE'              , text: '직위'      	 , type: 'string', comboType:'AU', comboCode:'H005'},
            {name: 'ABIL_CODE'              , text: '직책'      	 , type: 'string', comboType:'AU', comboCode:'H006'},
            {name: 'AF_POST_CODE'           , text: '직위코드'     , type: 'string', allowBlank: false},
            {name: 'AF_POST_NAME'           , text: '직위'      , type: 'string'},
            {name: 'AF_ABIL_CODE'           , text: '직책코드'     , type: 'string'},
            {name: 'AF_ABIL_NAME'           , text: '직책'      , type: 'string'},
            {name: 'PAY_GRADE_01'           , text: '급호'       , type: 'string'},
            {name: 'PAY_GRADE_02'           , text: '호봉'       , type: 'string'},
            {name: 'AF_PAY_GRADE_01'        , text: '급호'       , type: 'string'},
            {name: 'AF_PAY_GRADE_02'        , text: '호봉'       , type: 'string'},
            {name: 'AFFIL_CODE'             , text: '직렬'       , type: 'string', comboType:'AU', comboCode:'H173'},
            {name: 'AF_AFFIL_CODE'          , text: '직렬코드'    , type: 'string'},
            {name: 'AF_AFFIL_NAME'          , text: '직렬'       , type: 'string'},
            {name: 'KNOC'           		, text: '직종코드'    , type: 'string'},
            {name: 'AF_KNOC'           		, text: '직종코드'    , type: 'string'},
            {name: 'AF_KNOC_NAME'           , text: '직종'       , type: 'string'},
            {name: 'ANNOUNCE_REASON'        , text: '발령사유' 	, type: 'string'}
            
        ]                                         
    });
    
    
    
    /** Store 정의(Service 정의)
     * @type 
     */         
    var masterStore = Unilite.createStore('hum205ukrMasterStore1', {
        model   : 'hum205ukrModel',
        proxy   : directProxy,
        uniOpt  : {
            isMaster    : true,         // 상위 버튼 연결 
            editable    : true,         // 수정 모드 사용 
            deletable   : true,         // 삭제 가능 여부 
            useNavi     : false         // prev | newxt 버튼 사용
        },
        autoLoad: false,
        loadStoreRecords: function(){
            var param= Ext.getCmp('resultForm').getValues();            
            console.log(param);
            this.load({
                params: param
            });
        },
        saveStore : function()  {               
            var inValidRecs = this.getInvalidRecords();
            if(inValidRecs.length == 0 )    {
                config = {
//                  params: [paramMaster],
                    success: function(batch, option) {
                        
                     } 
                };
                this.syncAllDirect(config);             
            }else {                 
                masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
        }
    });

    var buttonStore = Unilite.createStore('hum205ukrButtonStore',{   
        proxy       : directButtonProxy, 
        uniOpt      : {
            isMaster    : false,            // 상위 버튼 연결 
            editable    : false,            // 수정 모드 사용 
            deletable   : false,           // 삭제 가능 여부 
            useNavi     : false         // prev | newxt 버튼 사용
        },
        saveStore   : function(buttonFlag) {             
            var inValidRecs = this.getInvalidRecords();
            var toCreate = this.getNewRecords();

            var paramMaster         = panelResult.getValues();
            paramMaster.WORK_GB     = buttonFlag;
            paramMaster.LANG_TYPE   = UserInfo.userLang
            
            if (buttonFlag == '2') {
                if(inValidRecs.length == 0) {
                    config = {
                            params: [paramMaster],
                            success: function(batch, option) {
                                //return 값 저장
                            	
                                var master = batch.operations[0].getResultSet();
                                UniAppManager.app.onQueryButtonDown();
                                buttonStore.clearData();
                                Ext.getCmp('buttonBatch').disable();
                                Ext.getCmp('buttonCancel').disable();
                             },
        
                             failure: function(batch, option) {
                             	
                                buttonStore.clearData();
                             }
                        };
                        this.syncAllDirect(config);
                }else{
                	var grid = Ext.getCmp('hum205ukrGrid1');
                    grid.uniSelectInvalidColumnAndAlert(inValidRecs);
                }
                
            } else { 
                if(inValidRecs.length == 0) {
                    config = {
                        params: [paramMaster],
                        success: function(batch, option) {
                            //return 값 저장
                            var master = batch.operations[0].getResultSet();
                            
                            UniAppManager.app.onQueryButtonDown();
                            buttonStore.clearData();
                            Ext.getCmp('buttonBatch').disable();
                            Ext.getCmp('buttonCancel').disable();
                         },
    
                         failure: function(batch, option) {
                            buttonStore.clearData();
                         }
                    };
                    this.syncAllDirect(config);
                } else {
                    var grid = Ext.getCmp('hum205ukrGrid1');
                    grid.uniSelectInvalidColumnAndAlert(inValidRecs);
                }
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

    
    
    /** 검색조건 (Search Panel)
     * @type 
     */
    var panelResult = Unilite.createSearchForm('resultForm',{
        region  : 'north',
        layout  : {type : 'uniTable', columns : 2},
        padding : '1 1 1 1',
        border  : true,
        items   : [{ 
                fieldLabel      : '<t:message code="system.label.human.announcetime" default="발령기간"/>',
                xtype           : 'uniDateRangefield',
                startFieldName  : 'FR_ANNOUNCE_DATE',
                endFieldName    : 'TO_ANNOUNCE_DATE',
                startDate       : UniDate.get('startOfMonth'),
                endDate         : UniDate.get('today'),
                allowBlank      : false,        
                tdAttrs         : {width: 350}, 
                width           : 315
            },{
                fieldLabel  : '<t:message code="system.label.human.division" default="사업장"/>',
                name        : 'DIV_CODE', 
                xtype       : 'uniCombobox',
                multiSelect : true, 
                typeAhead   : false,
                comboType   : 'BOR120'
            },
            Unilite.popup('Employee',{
                fieldLabel      : '<t:message code="system.label.human.employee" default="사원"/>',
                valueFieldName  : 'PERSON_NUMB',
                textFieldName   : 'NAME',
                validateBlank   : true,
                autoPopup       : true
            }),
            Unilite.treePopup('DEPTTREE',{
                fieldLabel      : '<t:message code="system.label.human.department" default="부서"/>',
                valueFieldName  : 'DEPT',
                textFieldName   : 'DEPT_NAME' ,
                valuesName      : 'DEPTS' ,
                DBvalueFieldName: 'TREE_CODE',
                DBtextFieldName : 'TREE_NAME',
                selectChildren  : true,
                validateBlank   : true,
                autoPopup       : true,
                useLike         : true
            })
        ]
    });
    
    var dataForm = Unilite.createSearchForm('panelDetailForm',{
        layout  : {type : 'uniTable', columns : 3, tableAttrs: {width: '100%'}
//      ,tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
        },
        padding : '1 1 1 1',
        border  : true,
        region  : 'center',
        items   : [{
            fieldLabel  : '<t:message code="system.label.human.announcedate" default="발령일자"/>',
            xtype       : 'uniDatefield',
            name        : 'ANNOUNCE_DATE',                  
            value       : UniDate.get('today'),                 
            allowBlank  : false,
            tdAttrs     : {width: 350}
        },{
            fieldLabel  : '<t:message code="system.label.human.announcecode" default="발령코드"/>',
            name        : 'ANNOUNCE_CODE',  
            xtype       : 'uniCombobox',        
            comboType   : 'AU',       
            comboCode   : 'H094',
            allowBlank  : false,
            tdAttrs     : {width: 350}, 
            holdable    : 'hold'
        },{
        	xtype: 'component'
        	
        },{
            fieldLabel  : '<t:message code="system.label.human.announcereason" default="발령사유"/>',
            name        : 'ANNOUNCE_REASON',    
            xtype       : 'uniTextfield',               
            width       : 500,
            holdable    : 'hold'
        },{
            xtype       : 'container',
            layout      : {type : 'uniTable'},
            defaultType : 'uniTextfield',
            items       : [{
                fieldLabel  : '<t:message code="system.label.human.paygrade01" default="호봉(급)"/>',
                name        : 'PAY_GRADE_01',
                width       : 130, 
                listeners   : {
                    render:function(el) {
                        el.getEl().on('dblclick', function(){
                            gsGridOrPanel   = '01';
                            gsGradeFlag     = '02';
                            wageCodePopup();
                        });
                    }
                }
            },{
                fieldLabel  : '<t:message code="system.label.human.paygrade02" default="호봉(호)"/>',
                name        : 'PAY_GRADE_02',
                width       : 70,
                labelWidth  : 30,
                listeners   : {
                    render:function(el) {
                        el.getEl().on('dblclick', function(){
                            gsGridOrPanel   = '01';
                            gsGradeFlag     = '02';
                            wageCodePopup();
                        });
                    }
                }
            }]
        },{
            xtype   : 'container',
            layout  : {type : 'uniTable'},
            tdAttrs : {align: 'right'},
            padding : '0 0 5 0',
            colspan     : 2,
            items   : [{
                xtype   : 'button',
                name    : 'BUTTON_CHOISE',
                id      : 'choisePerson',
                text    : '<t:message code="system.label.human.employeeselect" default="사원선택"/>',
                handler : function() {
                    if(!dataForm.getInvalidMessage()){
                        return false;
                    }
                    openBatchWin()
                }
            },{                 
                xtype   : 'button',
                name    : 'BUTTON_BATCH',
                id      : 'buttonBatch',
                text    : '인사마스터 반영',
                handler : function() {
                    var buttonFlag = '1';
                    fnMakeLogTable(buttonFlag);
                }
            },{                 
                xtype   : 'button',
                name    : 'BUTTON_CANCEL',
                id      : 'buttonCancel',
                text    : '인사마스터 반영취소',
                handler : function() {
                    var buttonFlag = '2';
                    fnMakeLogTable(buttonFlag);
                }
            }]
        }]
    });
    
    var masterGrid = Unilite.createGrid('hum205ukrGrid1', {
        store   : masterStore,
        layout  : 'fit',
        region  : 'center',
        uniOpt  : {
            expandLastColumn    : false,
            useRowNumberer      : true,
            onLoadSelectFirst   : false,
            copiedRow           : true
        },
        
        tbar  : [{
            text    : '발령사항 업로드',
            id  : 'excelBtn',
            width   : 150,
            handler : function() {
                if(!panelResult.getInvalidMessage()) return;   //필수체크
                openExcelWindow();
            }
        }],
        selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: false, toggleOnClick: false,
            listeners: {  
                select: function(grid, selectRecord, index, rowIndex, eOpts ){
                    if (this.selected.getCount() > 0) {
                        Ext.getCmp('buttonBatch').enable();
                        Ext.getCmp('buttonCancel').enable();
                    }
                },
                
                deselect:  function(grid, selectRecord, index, eOpts ){
                    if (this.selected.getCount() <= 0) {            //체크된 데이터가 0개일  때는 버튼 비활성화
                        Ext.getCmp('buttonBatch').disable();
                        Ext.getCmp('buttonCancel').disable();
                    }
                }
            }
        }),
        features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
                    {id : 'masterGridTotal',    ftype: 'uniSummary',      showSummaryRow: false} ],
        columns : [{ 
                xtype   : 'rownumberer', 
                align   : 'center  !important',     
                width   : 35,      
                sortable: false,        
                resizable: true
            },
            {dataIndex: 'PERSON_NUMB'           , width: 90,
                'editor' : Unilite.popup('Employee_G',{
                    validateBlank : true,
                    autoPopup:true,
                    listeners: {
                        'onSelected': {
                            fn: function(records, type) {
                                console.log('records : ', records);
                                console.log(records);
                                var grdRecord = masterGrid.uniOpt.currentRecord;
                                grdRecord.set('DEPT_NAME'            , records[0].DEPT_NAME);
                                grdRecord.set('DEPT_CODE'            , records[0].DEPT_CODE);
                                grdRecord.set('PERSON_NUMB'          , records[0].PERSON_NUMB);
                                grdRecord.set('NAME'                 , records[0].NAME);
                                grdRecord.set('BE_DIV_CODE'          , records[0].DIV_CODE);
                                grdRecord.set('BE_DEPT_CODE'         , records[0].DEPT_CODE);
                                grdRecord.set('BE_DEPT_NAME'         , records[0].DEPT_NAME);
                                grdRecord.set('AF_DIV_CODE'          , records[0].DIV_CODE);
                                grdRecord.set('AF_DIV_NAME'          , records[0].DIV_CODE);
                                grdRecord.set('AF_DEPT_CODE'         , records[0].DEPT_CODE);
                                grdRecord.set('AF_DEPT_NAME'         , records[0].DEPT_NAME);
                                grdRecord.set('POST_CODE'            , records[0].POST_CODE);
                                grdRecord.set('ABIL_CODE'            , records[0].ABIL_CODE);
                                grdRecord.set('AF_POST_CODE'         , records[0].POST_CODE);
                                grdRecord.set('AFFIL_CODE'           , records[0].AFFIL_CODE);
                                grdRecord.set('AF_AFFIL_CODE'        , records[0].AFFIL_CODE);
                                grdRecord.set('KNOC'                 , records[0].KNOC);
                                grdRecord.set('AF_KNOC'              , records[0].KNOC);
                                grdRecord.set('AF_ABIL_CODE'         , records[0].ABIL_CODE);
                                grdRecord.set('PAY_GRADE_01'         , records[0].PAY_GRADE_01);
                                grdRecord.set('PAY_GRADE_02'         , records[0].PAY_GRADE_02);
                                grdRecord.set('AF_PAY_GRADE_01'      , records[0].PAY_GRADE_01);
                                grdRecord.set('AF_PAY_GRADE_02'      , records[0].PAY_GRADE_02);
                            },                                  
                            scope: this
                        },
                        'onClear': function(type) {
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('DEPT_NAME'             , '');
                            grdRecord.set('DEPT_CODE'             , '');
                            grdRecord.set('PERSON_NUMB'           , '');
                            grdRecord.set('NAME'                  , '');
                            grdRecord.set('BE_DIV_CODE'           , '');
                            grdRecord.set('BE_DEPT_CODE'          , '');
                            grdRecord.set('BE_DEPT_NAME'          , '');
                            grdRecord.set('AF_DIV_CODE'           , '');
                            grdRecord.set('AF_DIV_NAME'           , '');
                            grdRecord.set('AF_DEPT_CODE'          , '');
                            grdRecord.set('AF_DEPT_NAME'          , '');
                            grdRecord.set('POST_CODE'             , '');
                            grdRecord.set('ABIL_CODE'             , '');
                            grdRecord.set('AF_POST_CODE'          , '');
                            grdRecord.set('KNOC'                  , '');
                            grdRecord.set('AF_KNOC'               , '');
                            grdRecord.set('AF_ABIL_CODE'          , '');
                            grdRecord.set('AF_POST_CODE'          , '');
                            grdRecord.set('AFFIL_CODE'            , '');
                            grdRecord.set('PAY_GRADE_01'          , '');
                            grdRecord.set('PAY_GRADE_02'          , '');
                            grdRecord.set('AF_PAY_GRADE_01'       , '');
                            grdRecord.set('AF_PAY_GRADE_02'       , '');
                        },
                        applyextparam: function(popup){ 
                        }
                    }
                })
            },
            {dataIndex: 'NAME'                  , width: 100,
                'editor' : Unilite.popup('Employee_G',{
                    validateBlank : true,
                    autoPopup:true,
                    listeners: {
                        'onSelected': {
                            fn: function(records, type) {
                                console.log('records : ', records);
                                console.log(records);
                                var grdRecord = masterGrid.uniOpt.currentRecord;
                                grdRecord.set('DEPT_NAME'            , records[0].DEPT_NAME);
                                grdRecord.set('DEPT_CODE'            , records[0].DEPT_CODE);
                                grdRecord.set('PERSON_NUMB'          , records[0].PERSON_NUMB);
                                grdRecord.set('NAME'                 , records[0].NAME);
                                grdRecord.set('BE_DIV_CODE'          , records[0].DIV_CODE);
                                grdRecord.set('BE_DEPT_CODE'         , records[0].DEPT_CODE);
                                grdRecord.set('BE_DEPT_NAME'         , records[0].DEPT_NAME);
                                grdRecord.set('AF_DIV_CODE'          , records[0].DIV_CODE);
                                grdRecord.set('AF_DIV_NAME'          , records[0].DIV_CODE);
                                grdRecord.set('AF_DEPT_CODE'         , records[0].DEPT_CODE);
                                grdRecord.set('AF_DEPT_NAME'         , records[0].DEPT_NAME);
                                grdRecord.set('POST_CODE'            , records[0].POST_CODE);
                                grdRecord.set('ABIL_CODE'            , records[0].ABIL_CODE);
                                grdRecord.set('AF_POST_CODE'         , records[0].POST_CODE);
                                grdRecord.set('AFFIL_CODE'           , records[0].AFFIL_CODE);
                                grdRecord.set('AF_AFFIL_CODE'        , records[0].AFFIL_CODE);
                                grdRecord.set('KNOC'                 , records[0].KNOC);
                                grdRecord.set('AF_KNOC'              , records[0].KNOC);
                                grdRecord.set('AF_ABIL_CODE'         , records[0].ABIL_CODE);
                                grdRecord.set('PAY_GRADE_01'         , records[0].PAY_GRADE_01);
                                grdRecord.set('PAY_GRADE_02'         , records[0].PAY_GRADE_02);
                                grdRecord.set('AF_PAY_GRADE_01'      , records[0].PAY_GRADE_01);
                                grdRecord.set('AF_PAY_GRADE_02'      , records[0].PAY_GRADE_02);
                            },                                  
                            scope: this
                        },
                        'onClear': function(type) {
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('DEPT_NAME'             , '');
                            grdRecord.set('DEPT_CODE'             , '');
                            grdRecord.set('PERSON_NUMB'           , '');
                            grdRecord.set('NAME'                  , '');
                            grdRecord.set('BE_DIV_CODE'           , '');
                            grdRecord.set('BE_DEPT_CODE'          , '');
                            grdRecord.set('BE_DEPT_NAME'          , '');
                            grdRecord.set('AF_DIV_CODE'           , '');
                            grdRecord.set('AF_DIV_NAME'           , '');
                            grdRecord.set('AF_DEPT_CODE'          , '');
                            grdRecord.set('AF_DEPT_NAME'          , '');
                            grdRecord.set('POST_CODE'             , '');
                            grdRecord.set('ABIL_CODE'             , '');
                            grdRecord.set('AF_POST_CODE'          , '');
                            grdRecord.set('KNOC'                  , '');
                            grdRecord.set('AF_KNOC'               , '');
                            grdRecord.set('AF_ABIL_CODE'          , '');
                            grdRecord.set('AF_POST_CODE'          , '');
                            grdRecord.set('AFFIL_CODE'            , '');
                            grdRecord.set('PAY_GRADE_01'          , '');
                            grdRecord.set('PAY_GRADE_02'          , '');
                            grdRecord.set('AF_PAY_GRADE_01'       , '');
                            grdRecord.set('AF_PAY_GRADE_02'       , '');
                        },
                        applyextparam: function(popup){ 
                        }
                    }
                })
            },
            {dataIndex: 'DEPT_CODE'             , width: 120, hidden:true,
                'editor': Unilite.popup('DEPT_G', {
                    autoPopup: true,
                    listeners: {
                        'onSelected': {
                            fn: function(records, type) {
                                var grdRecord = masterGrid.uniOpt.currentRecord;
                                record = records[0];                                    
                                grdRecord.set('DEPT_CODE'   , record['TREE_CODE']);     
                                grdRecord.set('DEPT_NAME'   , record['TREE_NAME']);
                                grdRecord.set('BE_DEPT_CODE', record['TREE_CODE']);
                                grdRecord.set('BE_DEPT_NAME', record['TREE_NAME']);
                            },
                            scope: this 
                        },
                        'onClear': function(type) {
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('DEPT_CODE'   , '');
                            grdRecord.set('DEPT_NAME'   , '');
                            grdRecord.set('BE_DEPT_CODE', '');  
                            grdRecord.set('BE_DEPT_NAME', '');
                        },
                        applyextparam: function(popup){
                            
                        }                                   
                    }
                })
            },
            {dataIndex: 'DEPT_NAME'             , width: 120,hidden:true,
                'editor': Unilite.popup('DEPT_G', {
                    autoPopup: true,
                    listeners: {
                        'onSelected': {
                            fn: function(records, type) {
                                var grdRecord = masterGrid.uniOpt.currentRecord;
                                record = records[0];                                
                                grdRecord.set('DEPT_CODE'   , record['TREE_CODE']); 
                                grdRecord.set('DEPT_NAME'   , record['TREE_NAME']);
                                grdRecord.set('BE_DEPT_CODE', record['TREE_CODE']);
                                grdRecord.set('BE_DEPT_NAME', record['TREE_NAME']);
                            },
                            scope: this 
                        },
                        'onClear': function(type) {
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('DEPT_CODE'   , '');  
                            grdRecord.set('DEPT_NAME'   , '');
                            grdRecord.set('BE_DEPT_CODE', '');  
                            grdRecord.set('BE_DEPT_NAME', '');
                        },
                        applyextparam: function(popup){
                            
                        }                                   
                    }
                })
            },
            {dataIndex: 'ANNOUNCE_DATE'         , width: 100},
            {dataIndex: 'ANNOUNCE_CODE'         , width: 130},
            
            {dataIndex: 'RETR_RESN'          , width: 80},  //퇴사사유
            
            {dataIndex: 'APPLY_YEAR'            , width: 130 ,hidden:true},
            {dataIndex: 'APPLY_YN'              , width: 80},
            {text: '<t:message code="system.label.human.division" default="사업장"/>', 
                columns:[
                    {dataIndex: 'BE_DIV_CODE'           , width: 130},
                    {dataIndex: 'AF_DIV_CODE'           , width: 130}
            ]},
            {text: '부서', 
                columns:[
                    {dataIndex: 'BE_DEPT_NAME'          , width: 133},
                    {dataIndex: 'AF_DEPT_NAME'          , width: 133,
                        'editor': Unilite.popup('DEPT_G', {
                            autoPopup: true,
                            listeners: {
                                'onSelected': {
                                    fn: function(records, type) {
                                        var grdRecord = masterGrid.uniOpt.currentRecord;
                                        record = records[0];                                
                                        grdRecord.set('AF_DEPT_CODE', record['TREE_CODE']); 
                                        grdRecord.set('AF_DEPT_NAME', record['TREE_NAME']);
                                    },
                                    scope: this 
                                },
                                'onClear': function(type) {
                                    var grdRecord = masterGrid.uniOpt.currentRecord;
                                    grdRecord.set('AF_DEPT_CODE', '');
                                    grdRecord.set('AF_DEPT_NAME', '');
                                },
                                applyextparam: function(popup){
                                    
                                }                                   
                            }
                        })
                    }
            ]},
            
            {text: '직위', 
                columns:[
                    {dataIndex: 'POST_CODE'             , width: 133},
                    {dataIndex: 'AF_POST_CODE'             , width: 133}
            ]},
            
            {text: '직책', 
                columns:[
                    {dataIndex: 'ABIL_CODE'             , width: 133},
                    {dataIndex: 'AF_ABIL_CODE'             , width: 133}
            ]},
            
            {text: '급 호', 
                columns:[
                    {dataIndex: 'PAY_GRADE_01'          , width: 90},
                    {dataIndex: 'PAY_GRADE_02'       , width: 90},
                    {dataIndex: 'AF_PAY_GRADE_01'          , width: 90},
                    {dataIndex: 'AF_PAY_GRADE_02'       , width: 90}
            ]},
//            {text: '호', 
//                columns:[
//                    
//            ]},
            {text: '직렬', 
                columns:[
                    {dataIndex: 'AFFIL_CODE'       , width: 90},
                    {dataIndex: 'AF_AFFIL_CODE'       , width: 90}
            ]},
            {text: '직종', 
                columns:[
                    {dataIndex: 'KNOC'       , width: 90},
                    {dataIndex: 'AF_KNOC'       , width: 90}
            ]},
            {dataIndex: 'ANNOUNCE_REASON'       , width: 200}
        ],
        listeners: {
            beforeedit  : function( editor, e, eOpts ) {
                if (e.record.data.APPLY_YN == 'Y') {
                    return false;
                }
                if(e.record.phantom){
                    if (UniUtils.indexOf(e.field, ['DEPT_NAME', 'DEPT_CODE', 'BE_DIV_CODE', 'BE_DEPT_NAME', 'APPLY_YN', 'POST_CODE', 'ABIL_CODE', 'PAY_GRADE_01', 'PAY_GRADE_02' , 'AFFIL_CODE', 'KNOC'])){
                        return false;
                    }
                } else {
                    if (UniUtils.indexOf(e.field, ['PERSON_NUMB', 'NAME', 'DEPT_NAME', 'DEPT_CODE', 'BE_DIV_CODE', 'BE_DEPT_CODE', 'BE_DEPT_NAME', 'APPLY_YN', 'POST_CODE', 'ABIL_CODE', 'PAY_GRADE_01', 'PAY_GRADE_02' 
                                                  ])){
                        return false;
                    }
                }
            },
            onGridDblClick :function( grid, record, cellIndex, colName ) {
                if (colName == 'AF_PAY_GRADE_01') {
                    gsGridOrPanel   = '02';
                    gsGradeFlag     = '01';
                    wageCodePopup();
                    
                } else if (colName == 'AF_PAY_GRADE_02') {
                    gsGridOrPanel   = '02';
                    gsGradeFlag     = '02';
                    wageCodePopup();
                    
                }
            }
        }
    });
    Unilite.Main( {
        id          : 'hum205ukrApp',
        border      : false,
        borderItems : [{
            region  : 'center',
            layout  : {type: 'vbox', align: 'stretch'},
            border  : false,
            items   : [
                panelResult, dataForm, masterGrid 
            ]
        }],
        
        fnInitBinding: function() {
            //초기값 설정
            panelResult.setValue('FR_ANNOUNCE_DATE' , UniDate.get('startOfMonth'));
            panelResult.setValue('TO_ANNOUNCE_DATE' , UniDate.get('today'));
            panelResult.setValue('PAY_CODE'         , '0');
            dataForm.setValue('ANNOUNCE_DATE'       , UniDate.get('today'));
            Ext.getCmp('buttonBatch').disable();
            Ext.getCmp('buttonCancel').disable();
            
            //버튼 설정
            UniAppManager.setToolbarButtons(['newData']         , true);
            UniAppManager.setToolbarButtons(['reset', 'save']   , false);

            //초기화 시, 포커스 설정
            panelResult.onLoadSelectText('FR_ANNOUNCE_DATE');
        },
        
        onQueryButtonDown: function() {
            //필수입력값 체크
            if(!this.isValidSearchForm()){
                return false;
            }
            
            masterStore.loadStoreRecords();
            UniAppManager.setToolbarButtons('reset', true);
            dataForm.clearForm();
        },
        
        onNewDataButtonDown : function() {
            if(!this.isValidSearchForm()){
                return false;
            }
            if(!dataForm.getInvalidMessage()){
                return false;
            }
            
//            if(dataForm.getValue('ANNOUNCE_CODE') == 96) {
//                if(dataForm.getValue('APPLY_YEAR') == '0'){
//                
//                    alert('<t:message code="system.message.human.message021" default="발령코드가 연봉계약일 경우, 적용년는 필수입력항목입니다."/>');
//                    return false;
//                } else if (Ext.isEmpty(dataForm.getValue('APPLY_YEAR'))) {
//                    alert('<t:message code="system.message.human.message021" default="발령코드가 연봉계약일 경우, 적용년는 필수입력항목입니다."/>');
//                    return false;
//                }
//            }

            var record = {
                COMP_CODE       : UserInfo.compCode,
                ANNOUNCE_DATE   : UniDate.getDbDateStr(dataForm.getValue('ANNOUNCE_DATE')),
                ANNOUNCE_CODE   : dataForm.getValue('ANNOUNCE_CODE'),
                APPLY_YN        : 'N',
                ANNOUNCE_REASON : dataForm.getValue('ANNOUNCE_REASON'),
                RETR_RESN : dataForm.getValue('RETR_RESN'),
                AF_PAY_GRADE_01 : dataForm.getValue('PAY_GRADE_01'),
                AF_PAY_GRADE_02 : dataForm.getValue('PAY_GRADE_02')
            };
            masterGrid.createRow(record, null, masterGrid.getStore().getCount()-1);
            UniAppManager.setToolbarButtons('reset', true);
        },
        
        onSaveDataButtonDown : function() {
            masterGrid.getStore().saveStore();
        },

        onDeleteDataButtonDown : function() {
            var selRow = masterGrid.getSelectedRecord();
            if(selRow && selRow.phantom === true)   {
                masterGrid.deleteSelectedRow();
            }else if(confirm('<t:message code="system.message.human.message008" default="현재행을 삭제 합니다."/>\n <t:message code="system.message.human.message009" default="삭제 하시겠습니까?"/>')) {
                if (selRow && selRow.get('APPLY_YN') == 'Y') {
                    alert('<t:message code="system.message.human.message022" default="이미 확정된 데이터는 삭제할 수 없습니다."/>');
                    return false;
                } else {
                    masterGrid.deleteSelectedRow();
                }
            }
        },
        
        onResetButtonDown : function() {
            panelResult.getForm().getFields().each(function(field) {
                  field.setReadOnly(false);
            });
            panelResult.clearForm();
            dataForm.clearForm();
            masterGrid.getStore().loadData({});
            this.fnInitBinding();;
        }
    });
    
    
    //사원선택 윈도우
    function openBatchWin() { 
        if(!batchEmployWin) {
            //Model 정의
            Unilite.defineModel('batchEmployeePopupModel', {  
	            fields: [    
	            	{name: 'NAME'             ,text:'<t:message code="system.label.human.name" default="성명"/>'          	,type:'string'}
	               ,{name: 'PERSON_NUMB'      ,text:'<t:message code="system.label.human.personnumb" default="사번"/>'       ,type:'string'}
	               ,{name: 'DIV_CODE'         ,text:'<t:message code="system.label.human.division" default="사업장"/>'        ,type:'string'}
	               ,{name: 'POST_CODE'        ,text:'<t:message code="system.label.human.postcode" default="직위"/>CD'        ,type:'string'}
	               ,{name: 'POST_CODE_NAME'   ,text:'<t:message code="system.label.human.postcode" default="직위"/>'          ,type:'string'}
	               ,{name: 'DEPT_CODE'        ,text:'<t:message code="system.label.human.department" default="부서"/>CD'      ,type:'string'}
	               ,{name: 'DEPT_NAME'        ,text:'<t:message code="system.label.human.department" default="부서"/>'        ,type:'string'}
	               ,{name: 'JOIN_DATE'        ,text:'<t:message code="system.label.human.joindate" default="입사일"/>'         ,type:'uniDate'}
	               ,{name: 'ABIL_CODE'        ,text:'<t:message code="system.label.human.abil" default="직책"/>CD'        	 ,type:'string'}
	               ,{name: 'ABIL_NAME'        ,text:'<t:message code="system.label.human.abil" default="직책"/>'          	,type:'string'}
	               ,{name: 'PAY_GRADE_01'     ,text:'<t:message code="system.label.human.paygrade01" default="호봉(급)"/>'    ,type:'string'}
	               ,{name: 'PAY_GRADE_02'     ,text:'<t:message code="system.label.human.paygrade02" default="호봉(호)"/>'    ,type:'string'}
	            ]
            });
            
            //Proxy 생성
            var batchEmployeePopupProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
                api: {
                    read : 'popupService.employeePopup'
                }
            });
            
            //Store 생성
            var batchEmployeeStore = Unilite.createStore('batchEmployeeStore', {
                model   : 'batchEmployeePopupModel' ,
                uniOpt  : {
                    isMaster    : false,            // 상위 버튼 연결 
                    editable    : false,            // 수정 모드 사용 
                    deletable   : false,            // 삭제 가능 여부 
                    useNavi     : false             // prev | newxt 버튼 사용
                },
                proxy   : batchEmployeePopupProxy,          
                loadStoreRecords : function()   {
                    var param= batchEmployWin.down('#search').getValues();
                    
                    this.load({
                        params: param
                    });             
                }
            });
    
            //OPEN할 팝업(Window) 생성
            batchEmployWin = Ext.create('widget.uniDetailWindow', {
                title   : '<t:message code="system.label.human.employeeselect" default="사원선택"/> POPUP',
                width   : 600,                              
                height  : 400,
                layout  : {type:'vbox', align:'stretch'},                   
                items   : [{
                    itemId  : 'search',
                    xtype   : 'uniSearchForm',
                    layout  : {type:'uniTable',columns:2},
                    items   : [{ 
                        fieldLabel  : '<t:message code="system.label.human.basisdate" default="기준일"/>',        
                        name        : 'BASE_DT',           
                        xtype       : 'uniDatefield', 
                        value     : UniDate.get('today')
                    },{
                        fieldLabel  : '<t:message code="system.label.human.department" default="부서"/>',
                        name        : 'DEPT_SEARCH',
                        xtype       : 'uniTextfield'
                    },{
                        fieldLabel  : '<t:message code="system.label.human.inquirycondition" default="조회조건"/>',
                        name        : 'TXT_SEARCH',
                        xtype       : 'uniTextfield' ,
                        listeners   : {
                            specialkey: function(field, e){
                                if (e.getKey() == e.ENTER) {
                                   me.onQueryButtonDown();
                                }
                            }
                        }
                    }]
                },
                    Unilite.createGrid('batchEmployGrd', {
                        store   : batchEmployeeStore,
                        itemId  : 'grid',
                        layout  : 'fit',
                        selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: true, toggleOnClick: false,
                            listeners: {
                                select: function(grid, selectRecord, index, rowIndex, eOpts ){
                                    if (this.selected.getCount() > 0) {
                                    }
                
                                },
                                deselect:  function(grid, selectRecord, index, eOpts ){
                                    if (this.selected.getCount() == 0) {
                                    }
                                }
                            }
                        }),
                        uniOpt  : {
                            expandLastColumn    : false,
                            useRowNumberer      : false,
                            onLoadSelectFirst   : false,
                            userToolbar         : false
                        },
                        columns:  [{
                                xtype   : 'rownumberer', 
                                sortable: false, 
                                width   : 35,
                                align   :'center  !important',
                                resizable: true
                            },
                            {dataIndex: 'NAME'              ,width:90   ,locked:true},
                            {dataIndex: 'PERSON_NUMB'       ,width:100  ,locked:true},
                            {dataIndex: 'DIV_CODE'          ,width:100  ,hidden:true},
                            {dataIndex: 'POST_CODE'         ,width:100  ,hidden:true},
                            {dataIndex: 'POST_CODE_NAME'    ,width:100  },
                            {dataIndex: 'DEPT_CODE'         ,width:100  ,hidden:true},
                            {dataIndex: 'DEPT_NAME'         ,width:130  },
                            {dataIndex: 'JOIN_DATE'         ,width:100  },
                            {dataIndex: 'ABIL_CODE'         ,width:100  ,hidden:true},
                            {dataIndex: 'ABIL_NAME'         ,width:100  },
                            {dataIndex: 'PAY_GRADE_01'      ,width:90  },
                            {dataIndex: 'PAY_GRADE_02'      ,width:90  }
                            
                            
                        ],
                        listeners: {    
                            onGridDblClick:function(grid, record, cellIndex, colName) {
                                grid.ownerGrid.returnData();
                                batchEmployWin.hide();
                            }
                        },
                        returnData: function(record)    {
                            var records = this.sortedSelectedRecords(this);
                            Ext.each(records, function(record, index) {
                                var param = {
                                    PERSON_NUMB    : record.get('PERSON_NUMB')
                                }
                                var r = {
                                    COMP_CODE       : UserInfo.compCode,
                                    ANNOUNCE_DATE   : UniDate.getDbDateStr(dataForm.getValue('ANNOUNCE_DATE')),
                                    ANNOUNCE_CODE   : dataForm.getValue('ANNOUNCE_CODE'),
                                    ANNOUNCE_REASON : dataForm.getValue('ANNOUNCE_REASON'),
                                    APPLY_YEAR : dataForm.getValue('APPLY_YEAR'),
                                    APPLY_YN        : 'N',
                                    RETR_RESN   : dataForm.getValue('RETR_RESN'), //퇴사사유
                                    DEPT_NAME       : record.get('DEPT_NAME'),
                                    DEPT_CODE       : record.get('DEPT_CODE'),
                                    PERSON_NUMB     : record.get('PERSON_NUMB'),
                                    NAME            : record.get('NAME'),
                                    BE_DIV_CODE     : record.get('DIV_CODE'),
                                    BE_DEPT_CODE    : record.get('DEPT_CODE'),
                                    BE_DEPT_NAME    : record.get('DEPT_NAME'),
                                    AF_DIV_CODE     : record.get('DIV_CODE'),
                                    AF_DEPT_CODE    : record.get('DEPT_CODE'),
                                    AF_DEPT_NAME    : record.get('DEPT_NAME'),
                                    POST_CODE       : record.get('POST_CODE'),
                                    ABIL_CODE       : record.get('ABIL_CODE'),
                                    PAY_GRADE_01    : record.get('PAY_GRADE_01'),
                                    PAY_GRADE_02    : record.get('PAY_GRADE_02'),
                                    AF_PAY_GRADE_01 : record.get('PAY_GRADE_01'),
                                    AF_PAY_GRADE_02 : record.get('PAY_GRADE_02')
                                };
                                masterGrid.createRow(r, null, masterGrid.getStore().getCount()-1);
                            })  
                            UniAppManager.setToolbarButtons('reset', true);
                        }
                    })
                ],
                tbar:  ['->',{
                        itemId  : 'searchtBtn',
                        text    : '<t:message code="system.label.human.inquiry" default="조회"/>',
                        handler : function() {
                            var form = batchEmployWin.down('#search');
                            var store = Ext.data.StoreManager.lookup('creditStore')
                            batchEmployeeStore.loadStoreRecords();
                        },
                        disabled: false
                    },
                     {
                        itemId  : 'submitBtn',
                        text    : '<t:message code="system.label.human.confirm" default="확인"/>',
                        handler : function() {
                            batchEmployWin.down('#grid').returnData()
                            batchEmployWin.hide();
                        },
                        disabled: false
                    },{
                        itemId  : 'closeBtn',
                        text    : '<t:message code="system.label.human.close" default="닫기"/>',
                        handler : function() {
                            batchEmployWin.hide();
                        },
                        disabled: false
                    }
                ],
                listeners : {
                    beforehide: function(me, eOpt)  {
                        batchEmployWin.down('#search').clearForm();
                        batchEmployWin.down('#grid').reset();
                        batchEmployeeStore.clearData();
                    },
                    beforeclose: function( panel, eOpts )   {
                        batchEmployWin.down('#search').clearForm();
                        batchEmployWin.down('#grid').reset();
                        batchEmployeeStore.clearData();
                    },
                    show: function( panel, eOpts )  {
                        var form = batchEmployWin.down('#search');
                        form.clearForm();
                        form.setValue('GRADE_FLAG', gsGradeFlag);
                        form.setValue('BASE_DT', UniDate.get('today'));
                        Ext.data.StoreManager.lookup('batchEmployeeStore').loadStoreRecords();
                    }
                }       
            });
        }   
        batchEmployWin.center();        
        batchEmployWin.show();
        return batchEmployWin;
    }
    
    //급호봉 / 지급수당 / 기술수당 팝업
    function wageCodePopup()    { 
        if(!payGrdWin) {
            //Model 정의
            var winfields = [
                {name: 'PAY_GRADE_01'       ,text:'<t:message code="system.label.human.paygrade01" default="호봉(급)"/>'                   ,type:'string'  },
                {name: 'PAY_GRADE_02'       ,text:'<t:message code="system.label.human.paygrade02" default="호봉(호)"/>'                   ,type:'string'  }
            ];
            Ext.each(wageStd, function(stdCode, idx) {
                winfields.push({name: 'CODE'+stdCode.WAGES_CODE     ,text:stdCode.WAGES_NAME+'<t:message code="system.label.human.code" default="코드"/>'       ,type:'string'  });
                winfields.push({name: 'STD'+stdCode.WAGES_CODE      ,text:stdCode.WAGES_NAME            ,type:'uniPrice'});                 
            })
            Unilite.defineModel('WagesCodeModel', {
                fields: winfields
            });
            
            //Proxy 생성
            var wagesCodeDirctProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
                api: {
                    read : 'hum100ukrService.fnHum100P2'
                }
            });
            
            //Store 생성
            var wageCodeStore = Unilite.createStore('wageCodeStore', {
                model   : 'WagesCodeModel' ,
                uniOpt  : {
                    isMaster    : false,            // 상위 버튼 연결 
                    editable    : false,            // 수정 모드 사용 
                    deletable   : false,            // 삭제 가능 여부 
                    useNavi     : false             // prev | newxt 버튼 사용
                },
                proxy   : wagesCodeDirctProxy,          
                loadStoreRecords : function()   {
                    var param= payGrdWin.down('#search').getValues();
                    
                    this.load({
                        params: param
                    });             
                }
            });
    
            //Grid 생성
            var wageColumns = [
                { dataIndex: 'PAY_GRADE_01'             ,width: 40  },
                { dataIndex: 'PAY_GRADE_02'             ,width: 40  }  
            ];
            Ext.each(wageStd, function(stdCode, idx) {
                wageColumns.push({dataIndex: 'CODE'+stdCode.WAGES_CODE      ,width: 50  , hidden:true});
                wageColumns.push({dataIndex: 'STD'+stdCode.WAGES_CODE       ,width: 100  });                    
            });  
            
            
            //OPEN할 팝업(Window) 생성
            payGrdWin = Ext.create('widget.uniDetailWindow', {
                title   : '<t:message code="system.label.human.abaloneinq" default="급호봉조회"/>POPUP',
                width   : 400,                              
                height  : 400,
                layout  : {type:'vbox', align:'stretch'},                   
                items   : [{
                    itemId  : 'search',
                    xtype   : 'uniSearchForm',
                    layout  : {type:'uniTable',columns:2},
                    items   : [{    
                        fieldLabel  : '<t:message code="system.label.human.paygrade01" default="호봉(급)"/>',
                        name        : 'PAY_GRADE_01',
                        labelWidth  : 60,
                        width       : 160
                    },{
                        
                        fieldLabel  : '<t:message code="system.label.human.paygrade02" default="호봉(호)"/>',
                        name        : 'PAY_GRADE_02',
                        labelWidth  : 60,
                        width       : 160
                    },{
                        
                        fieldLabel  : '<t:message code="system.label.human.type" default="구분"/>',
                        name        : 'GRADE_FLAG',
                        labelWidth  : 60,
                        width       : 160,
                        hidden      : true
                    }]
                },
                Unilite.createGrid('payGrd', {
                    store   : wageCodeStore,
                    itemId  : 'grid',
                    layout  : 'fit',
                    selModel: 'rowmodel',
                    uniOpt  : {
                        expandLastColumn    : false,
                        useRowNumberer      : false,
                        onLoadSelectFirst   : true,
                        userToolbar         : false
                    },
                    columns : wageColumns,
                    listeners: {    
                        onGridDblClick:function(grid, record, cellIndex, colName) {
                            grid.ownerGrid.returnData();
                            payGrdWin.hide();
                        }
                    },
                    returnData: function()  {
                        var record = this.getSelectedRecord();  
                        if (gsGridOrPanel == '01') {
                            dataForm.setValue('PAY_GRADE_01', record.get("PAY_GRADE_01"));
                            dataForm.setValue('PAY_GRADE_02', record.get("PAY_GRADE_02"));
                        } else {
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('AF_PAY_GRADE_01', record.get("PAY_GRADE_01"));
                            grdRecord.set('AF_PAY_GRADE_02', record.get("PAY_GRADE_02"));
                        }
                    }
                })
                ],
                tbar:  ['->',{
                        itemId  : 'searchtBtn',
                        text    : '<t:message code="system.label.human.inquiry" default="조회"/>',
                        handler : function() {
                            var form = payGrdWin.down('#search');
                            var store = Ext.data.StoreManager.lookup('creditStore')
                            wageCodeStore.loadStoreRecords();
                        },
                        disabled: false
                    },
                     {
                        itemId  : 'submitBtn',
                        text    : '<t:message code="system.label.human.confirm" default="확인"/>',
                        handler : function() {
                            payGrdWin.down('#grid').returnData()
                            payGrdWin.hide();
                        },
                        disabled: false
                    },{
                        itemId  : 'closeBtn',
                        text    : '<t:message code="system.label.human.close" default="닫기"/>',
                        handler : function() {
                            payGrdWin.hide();
                        },
                        disabled: false
                    }
                ],
                listeners : {
                    beforehide: function(me, eOpt)  {
                        payGrdWin.down('#search').clearForm();
                        payGrdWin.down('#grid').reset();
                        wageCodeStore.clearData();
                    },
                    beforeclose: function( panel, eOpts )   {
                        payGrdWin.down('#search').clearForm();
                        payGrdWin.down('#grid').reset();
                        wageCodeStore.clearData();
                    },
                    show: function( panel, eOpts )  {
                        var form = payGrdWin.down('#search');
                        form.clearForm();
                        form.setValue('GRADE_FLAG', gsGradeFlag);
                        Ext.data.StoreManager.lookup('wageCodeStore').loadStoreRecords();
                    }
                }       
            });
        }   
        payGrdWin.center();     
        payGrdWin.show();
        return payGrdWin;
    }       
    
    
    function fnMakeLogTable(buttonFlag) {
        //조건에 맞는 내용은 적용 되는 로직
        records = masterGrid.getSelectedRecords();
        buttonStore.clearData();                                //buttonStore 클리어
        Ext.each(records, function(record, index) {
            record.phantom      = true;
            record.data.WORK_GB = buttonFlag;
            buttonStore.insert(index, record);
            
            if (records.length == index +1) {
                buttonStore.saveStore(buttonFlag);
            }
        });
        
    }
    
	function openExcelWindow() {
		

        if(!dataForm.getInvalidMessage()){
             return false;
        }
            
	    var me = this;
        var vParam = {};
        //var appName = 'Unilite.com.excel.ExcelUploadWin';
        var appName = 'Unilite.com.excel.ExcelUpload';
        
        var record = masterGrid.getSelectedRecord();
        
        if(!masterStore.isDirty())  {                                   //화면에 저장할 내용이 있을 경우 저장여부 확인
            //masterStore.loadData({});
        } else {
            if(confirm('저장될 내용이 있습니다. '+'\n'+'저장하시겠습니까?')){
                UniAppManager.app.onSaveDataButtonDown();
                return;
            }else {
                masterStore.loadData({});
            }
        }
        if(!Ext.isEmpty(excelWindow)){
            excelWindow.extParam.ANNOUNCE_DATE = UniDate.getDbDateStr(dataForm.getValue('ANNOUNCE_DATE'));
            excelWindow.extParam.ANNOUNCE_CODE = dataForm.getValue('ANNOUNCE_CODE');
        }
        if(!excelWindow) { 
        	excelWindow = Ext.WindowMgr.get(appName);
            excelWindow = Ext.create( appName, {
				modal: false,
            	excelConfigName: 'hum205ukr',
        		extParam: { 
                    'PGM_ID'    : 'hum205ukr',
                    'ANNOUNCE_DATE' : UniDate.getDbDateStr(dataForm.getValue('ANNOUNCE_DATE')),
                    'ANNOUNCE_CODE' : dataForm.getValue('ANNOUNCE_CODE')
        		},
                grids: [{							//팝업창에서 가져오는 그리드
                		itemId		: 'grid01',
                		title		: '발령사항 내역등록',                        		
                		useCheckbox	: false,
                		model		: 'excel.hum205ukr.sheet01',
                		readApi		: 'hum205ukrService.selectExcelUploadSheet',
                		columns		: [	
                			{dataIndex: '_EXCEL_JOBID'		, width: 80,	hidden: true},
							{dataIndex: 'COMP_CODE'  		, width: 120, hidden: true},
							{dataIndex: 'PERSON_NUMB'		, width: 110},
							{dataIndex: 'NAME'				, width: 100},
							
							{dataIndex: 'DEPT_CODE'			, width: 80 , hidden: true},
							{dataIndex: 'DEPT_NAME'			, width: 120, hidden: true},
							
							{dataIndex: 'ANNOUNCE_DATE'		, width: 80,  hidden: true},
							{dataIndex: 'ANNOUNCE_CODE'		, width: 80,  hidden: true},
							{dataIndex: 'RETR_RESN'			, width: 100, hidden: true},
							{dataIndex: 'RETR_RESN_NAME'	, width: 100},
							{dataIndex: 'APPLY_YEAR'		, width: 120, hidden: true},
							{dataIndex: 'APPLY_YN'			, width: 120, hidden: true},
							
							{dataIndex: 'BE_DIV_CODE'		, width: 120, hidden: true},
							{dataIndex: 'AF_DIV_CODE'		, width: 120, hidden: true},
							{dataIndex: 'AF_DIV_NAME'		, width: 140},
							
							{dataIndex: 'BE_DEPT_CODE'		, width: 80 , hidden: true},
							{dataIndex: 'BE_DEPT_NAME'		, width: 140, hidden: true},
							{dataIndex: 'AF_DEPT_CODE'		, width: 80 , hidden: true},
							{dataIndex: 'AF_DEPT_NAME'		, width: 140},
							
							{dataIndex: 'POST_CODE'			, width: 110, hidden: true},
							{dataIndex: 'ABIL_CODE'			, width: 110, hidden: true},
							{dataIndex: 'AF_POST_CODE'		, width: 110, hidden: true},
							{dataIndex: 'AF_POST_NAME'		, width: 130},
							{dataIndex: 'AF_ABIL_CODE'		, width: 110, hidden: true},
							{dataIndex: 'AF_ABIL_NAME'		, width: 130},
							
							{dataIndex: 'PAY_GRADE_01'		, width: 110, hidden: true},
							{dataIndex: 'PAY_GRADE_02'		, width: 90,  hidden: true},
							{dataIndex: 'AF_PAY_GRADE_01'	, width: 110},
							{dataIndex: 'AF_PAY_GRADE_02'	, width: 90},
							
							{dataIndex: 'AFFIL_CODE'		, width: 110, hidden: true},
							{dataIndex: 'AF_AFFIL_CODE'		, width: 110, hidden: true},
							{dataIndex: 'AF_AFFIL_NAME'		, width: 130},
							
							{dataIndex: 'KNOC'				, width: 110, hidden: true},
							{dataIndex: 'AF_KNOC'			, width: 110, hidden: true},
							{dataIndex: 'AF_KNOC_NAME'		, width: 130},
							{dataIndex: 'ANNOUNCE_REASON'	, width: 150}
                		]
                	}
                ],
                listeners: {
                    close: function() {
                        this.hide();
                    }
                },
                onApply:function()	{
                	excelWindow.getEl().mask('로딩중...','loading-indicator');
                	var me		= this;
                	var grid	= this.down('#grid01');
        			var records	= grid.getStore().getAt(0);	
        			if (!Ext.isEmpty(records)) {
			        	var param	= {
			        		"_EXCEL_JOBID" : records.get('_EXCEL_JOBID'),
			        		"ANNOUNCE_DATE": UniDate.getDbDateStr(dataForm.getValue('ANNOUNCE_DATE')),
			        		"ANNOUNCE_CODE": dataForm.getValue('ANNOUNCE_CODE')
			        	};
			        	excelUploadFlag = "Y"
			        	
			        	masterGrid.reset();
						masterStore.clearData();
						
						hum205ukrService.selectExcelUploadSheet(param, function(provider, response){
					    	var store	= masterGrid.getStore();
					    	var records	= response.result;
					    	
					    	store.insert(0, records);
					    	console.log("response",response)
							excelWindow.getEl().unmask();
							grid.getStore().removeAll();
							me.hide();
					    });
						excelUploadFlag = "N"
		        	} else {
		        		alert (Msg.fSbMsgH0284);
		        		this.unmask();  
		        	}
        		}
			});
		}
        excelWindow.center();
        excelWindow.show();
	};
    
    
    Unilite.createValidator('validator01', {
        store: masterStore,
        grid: masterGrid,
        validate: function( type, fieldName, newValue, oldValue, record, eopt) {
        console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
            var rv = true;
            if(newValue != oldValue)    {
                switch(fieldName) {
                    case "AF_POST_CODE" :           
                    break; 
                    
                    case "AF_ABIL_CODE" :            
                    break;
                }
            }
            return rv;
        }
    }); 
    
    

};
</script>
