<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_hum290ukr_KOCIS">
    <t:ExtComboStore comboType="BOR120"/>             <!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="H028" /> <!-- 급여지급방식 -->
    <t:ExtComboStore comboType="AU" comboCode="H005" /> <!-- 직위 -->
    <t:ExtComboStore comboType="AU" comboCode="H095" /> <!-- 근무평가 구분 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript">

function appMain() {
	
    var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read    : 's_hum290ukrService_KOCIS.selectList',
            update  : 's_hum290ukrService_KOCIS.updateList',
//            create  : 's_hum290ukrService_KOCIS.insertList',
            destroy : 's_hum290ukrService_KOCIS.deleteList',
            syncAll : 's_hum290ukrService_KOCIS.saveAll'
        }
    }); 
    
    /* Model 정의 
     * @type
     */
    Unilite.defineModel('hum290ukrModel', {
        fields: [
            {name : 'DIV_CODE'          , text : '기관'              , type : 'string', comboType: 'BOR120'},
            {name : 'DIV_NAME'          , text : '기관명'            , type : 'string'},
            {name : 'DEPT_CODE'         , text : '부서코드'           , type : 'string'},
            {name : 'DEPT_NAME'         , text : '부서'              , type : 'string'},
            {name : 'PERSON_NUMB'       , text : '사번'              , type : 'string'},
            {name : 'NAME'              , text : '성명'              , type : 'string'},
            {name : 'GRADE_GUBUN'       , text : '구분'              , type : 'string', comboType: 'AU', comboCode:'H095'},
            {name : 'BASE_YYYY'         , text : '기준년도'           , type : 'string'},
            {name : 'BASE_DATE'         , text : '기준일'             , type : 'uniDate'},
            {name : 'POST_CODE'         , text : '직위코드'           , type : 'string'},
            {name : 'POST_NAME'         , text : '직위'              , type : 'string'},
            
            {name : 'TOT_RATE_SUM'      , text : '합계'              , type : 'int'},  
            {name : 'GRADE'             , text : '등급'              , type : 'string'},
            {name : 'APPRAISER'         , text : '평정자코드'          , type : 'string'},
            {name : 'APPRAISER_NAME'    , text : '평정자명'           , type : 'string'},
            {name : 'REMARK'            , text : '비고'              , type : 'string'},
            {name : 'PERFORM_RATE'      , text : '업무난이도(20점)'    , type : 'int'},
            {name : 'PERFECT_RATE'      , text : '완성도(20점)'       , type : 'int'},
            {name : 'TIMELY_RATE'       , text : '적시성(20점)'       , type : 'int'},
            {name : 'INTEGRITY_RATE'    , text : '성실성(10점)'       , type : 'int'},
            {name : 'CUSTOMER_RATE'     , text : '고객지향성(10점)'    , type : 'int'},
            {name : 'TEAMWORK_RATE'     , text : '팀워크(10점)'       , type : 'int'},
            {name : 'PROFESSION_RATE'   , text : '전문성(10점)'       , type : 'int'}
        ]
    });

    /* Store 정의(Service 정의)
     * @type 
     */
    var masterStore = Unilite.createStore('hum290ukrMasterStore',{
        model: 'hum290ukrModel',
        uniOpt : {                              
            isMaster    : true,         // 상위 버튼 연결
            editable    : true,         // 수정 모드 사용
            deletable   : true,         // 삭제 가능 여부
            useNavi     : false         // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy   : directProxy,
        loadStoreRecords : function()   {
            var param= Ext.getCmp('searchForm').getValues();            
            console.log( param );
            this.load({
                params : param
            });
        },
        saveStore : function()  {
            var inValidRecs = this.getInvalidRecords();
            var toCreate = this.getNewRecords();
            var toUpdate = this.getUpdatedRecords();                
            var toDelete = this.getRemovedRecords();
            
//          폼에서 필요한 조건 가져올 경우
            var paramMaster = Ext.getCmp('searchForm').getValues();
            var rv = true;
            
            if(inValidRecs.length == 0 )    {
                config = {
                    params: [paramMaster],
                    success: function(batch, option) {                              
                        panelResult.resetDirtyStatus();
                        UniAppManager.setToolbarButtons('save', false); 
                    } 
                };
                this.syncAllDirect(config);
                
            }else {
                masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
        },
        
        listeners: {
            load: function(store, records, successful, eOpts) {
                if (this.getCount() > 0) {
                    UniAppManager.setToolbarButtons('deleteAll', true);
                } else {
                    UniAppManager.setToolbarButtons('deleteAll', false);
                }  
            },
            add: function(store, records, index, eOpts) {
            },
            update: function(store, record, operation, modifiedFieldNames, eOpts) {
            },
            remove: function(store, record, index, isMove, eOpts) {
            }
        }
    });
        
    /* 검색조건 (Search Panel)
     * @type 
     */
    var panelSearch = Unilite.createSearchPanel('searchForm', {
        title: '검색조건',      
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
            id: 'search_panel1',
            itemId: 'search_panel1',
            layout: {type: 'uniTable', columns: 1},
            defaultType: 'uniTextfield',
            items: [{
                fieldLabel: '기준년도',
                name:'BASE_YYYY', 
                xtype: 'uniYearField', 
                allowBlank:false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {      
                        panelResult.setValue('BASE_YYYY', newValue);
                    }
                }
            },{
                fieldLabel: '구분',
                name:'GUBUN', 
                xtype: 'uniCombobox', 
                //store:Ext.data.StoreManager.lookup('subject'),
                comboType:'AU',
                comboCode:'H095',
                allowBlank:false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {      
                        panelResult.setValue('GUBUN', newValue);
                    }
                }
            },{
                fieldLabel: '기관',
                name:'DIV_CODE', 
                xtype: 'uniCombobox',
                comboType:'BOR120',
                width: 325,
                colspan:2,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelResult.setValue('DIV_CODE', newValue);
                    }
                }
            },{
                fieldLabel: '급여지급방식',
                name:'PAY_CODE', 
                xtype: 'uniCombobox', 
                comboType:'AU',
                comboCode:'H028',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {      
                        panelResult.setValue('PAY_CODE', newValue);
                    }
                }
            },
            Unilite.popup('Employee',{
                fieldLabel: '직원',
                valueFieldName:'PERSON_NUMB',
                textFieldName:'NAME',
                validateBlank:false,
                autoPopup:true,
                listeners: {
                    onSelected: {
                        fn: function(records, type) {
                            panelResult.setValue('PERSON_NUMB', panelSearch.getValue('PERSON_NUMB'));
                            panelResult.setValue('NAME', panelSearch.getValue('NAME'));                                                                                                         
                        },
                        scope: this
                    },
                    onClear: function(type) {
                        panelResult.setValue('PERSON_NUMB', '');
                        panelResult.setValue('NAME', '');
                    },
                    onValueFieldChange: function(field, newValue){
                        panelResult.setValue('PERSON_NUMB', newValue);                              
                    },
                    onTextFieldChange: function(field, newValue){
                        panelResult.setValue('NAME', newValue);             
                    }
                }
            }),{
                fieldLabel: '직위',
                name:'POST_CODE', 
                xtype: 'uniCombobox', 
                comboType:'AU',
                comboCode:'H005',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {      
                        panelResult.setValue('POST_CODE', newValue);
                    }
                }
            },{
                fieldLabel: '기준일자',
                name:'BASE_DATE', 
                xtype : 'uniDatefield',
                allowBlank:false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {      
                        panelResult.setValue('BASE_DATE', newValue);
                    }
                }
            },
            Unilite.popup('Employee',{
                fieldLabel: '평정자',
                valueFieldName:'APPRAISER',
                textFieldName:'APPRAISER_NAME',
                validateBlank:false,
                autoPopup:true,
                colspan:2,
                allowBlank:false,
                listeners: {
                    onSelected: {
                        fn: function(records, type) {
                            panelResult.setValue('APPRAISER', panelSearch.getValue('APPRAISER'));
                            panelResult.setValue('APPRAISER_NAME', panelSearch.getValue('APPRAISER_NAME'));                                                                                                           
                        },
                        scope: this
                    },
                    onClear: function(type) {
                        panelResult.setValue('APPRAISER', '');
                        panelResult.setValue('APPRAISER_NAME', '');
                    },
                    onValueFieldChange: function(field, newValue){
                        panelResult.setValue('APPRAISER', newValue);                             
                    },
                    onTextFieldChange: function(field, newValue){
                        panelResult.setValue('APPRAISER_NAME', newValue);                
                    }
                }
            })]
        }]
    });//End of var panelSearch = Unilite.createSearchForm('searchForm', {

    var panelResult = Unilite.createSearchForm('resultForm',{
        hidden: !UserInfo.appOption.collapseLeftSearch,
        region: 'north',
        layout : {type : 'uniTable', columns : 3},
        padding:'1 1 1 1',
        border:true,
        items: [{
            fieldLabel: '기준년도',
            name:'BASE_YYYY', 
            xtype: 'uniYearField', 
            allowBlank:false,
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {      
                    panelSearch.setValue('BASE_YYYY', newValue);
                }
            }
        },{
            fieldLabel: '구분',
            name:'GUBUN', 
            xtype: 'uniCombobox', 
            //store:Ext.data.StoreManager.lookup('subject'),
            comboType:'AU',
            comboCode:'H095',
            allowBlank:false,
            listeners: {
                    change: function(field, newValue, oldValue, eOpts) {      
                        panelSearch.setValue('GUBUN', newValue);
                    }
                }
        },{
            fieldLabel: '기관',
            name:'DIV_CODE', 
            xtype: 'uniCombobox',
            comboType:'BOR120',
            width: 325,
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {                        
                    panelSearch.setValue('DIV_CODE', newValue);
                }
            }
        },{
            fieldLabel: '급여지급방식',
            name:'PAY_CODE', 
            xtype: 'uniCombobox', 
            comboType:'AU',
            comboCode:'H028',
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {      
                    panelSearch.setValue('PAY_CODE', newValue);
                }
            }
        },
        Unilite.popup('Employee',{
            fieldLabel: '직원',
            valueFieldName:'PERSON_NUMB',
            textFieldName:'NAME',
            validateBlank:false,
            autoPopup:true,
            listeners: {
                onSelected: {
                    fn: function(records, type) {
                        panelSearch.setValue('PERSON_NUMB', panelResult.getValue('PERSON_NUMB'));
                        panelSearch.setValue('NAME', panelResult.getValue('NAME'));                                                                                                         
                    },
                    scope: this
                },
                onClear: function(type) {
                    panelSearch.setValue('PERSON_NUMB', '');
                    panelSearch.setValue('NAME', '');
                },
                onValueFieldChange: function(field, newValue){
                    panelSearch.setValue('PERSON_NUMB', newValue);                              
                },
                onTextFieldChange: function(field, newValue){
                    panelSearch.setValue('NAME', newValue);             
                }
            }
        }),{
            fieldLabel: '직위',
            name:'POST_CODE', 
            xtype: 'uniCombobox', 
            comboType:'AU',
            comboCode:'H005',
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {      
                    panelSearch.setValue('POST_CODE', newValue);
                }
            }
        },{
            fieldLabel: '기준일자',
            name:'BASE_DATE', 
            xtype : 'uniDatefield',
            allowBlank:false,
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {      
                    panelSearch.setValue('BASE_DATE', newValue);
                }
            }
        },
        Unilite.popup('Employee',{
            fieldLabel: '평정자',
            valueFieldName:'APPRAISER',
            textFieldName:'APPRAISER_NAME',
            validateBlank:false,
            autoPopup:true,
            allowBlank:false,
            listeners: {
                onSelected: {
                    fn: function(records, type) {
                        panelSearch.setValue('APPRAISER', panelResult.getValue('APPRAISER'));
                        panelSearch.setValue('APPRAISER_NAME', panelResult.getValue('APPRAISER_NAME'));                                                                                                           
                    },
                    scope: this
                },
                onClear: function(type) {
                    panelSearch.setValue('APPRAISER', '');
                    panelSearch.setValue('APPRAISER_NAME', '');
                },
                onValueFieldChange: function(field, newValue){
                    panelSearch.setValue('APPRAISER', newValue);                             
                },
                onTextFieldChange: function(field, newValue){
                    panelSearch.setValue('APPRAISER_NAME', newValue);                
                }
            }
        })]
    });
    
    /* Master Grid 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('hum290ukrGrid1', {
        // for tab      
        layout  : 'fit',
        region  : 'center',
        store   : masterStore,
        uniOpt : {                      
            useMultipleSorting  : true,
            useLiveSearch       : false,
            onLoadSelectFirst   : true,     //체크박스모델은 false로 변경     
            dblClickToEdit      : true,
            useGroupSummary     : true,
            useContextMenu      : false,
            useRowNumberer      : true,
            expandLastColumn    : true,
            useRowContext       : false,    // rink 항목이 있을경우만 true      
            copiedRow           : false,
            filter: {                   
                useFilter   : false,
                autoCreate  : true
            }
        },
        columns : [
                { dataIndex: 'DIV_CODE'                     , width: 120, comboType:'BOR120'},
                { dataIndex: 'DEPT_CODE'                    , width: 160, hidden : true},
                { dataIndex: 'DEPT_NAME'                    , width: 160, hidden : true},
                { dataIndex: 'GRADE_GUBUN'                  , width: 160, hidden : true, comboType: 'AU', comboCode:'H095'},
                { dataIndex: 'BASE_YYYY'                    , width: 160, hidden : true},
                { dataIndex: 'PERSON_NUMB'                  , width: 78, hidden: true},
                { dataIndex: 'NAME'                         , width: 120},
//                { dataIndex: 'PERSON_NUMB'                  , width: 78, hidden: true,
//                'editor' : Unilite.popup('Employee_G',{
//                        validateBlank : true,
//                        autoPopup:true,
//                        listeners: {'onSelected': {
//                                        fn: function(records, type) {
//                                            UniAppManager.app.fnHumanCheck(records);    
//                                        },
//                                        scope: this
//                                    },
//                                    'onClear': function(type) {
//                                        var grdRecord = Ext.getCmp('hum290ukrGrid1').uniOpt.currentRecord;
//                                        grdRecord.set('PERSON_NUMB','');
//                                        grdRecord.set('NAME','');
//                                    }
//                        }
//                    })
//                },
//            	{ dataIndex: 'NAME'                         , width: 120,
//                    editor: Unilite.popup('Employee_G', {
//    //                  textFieldName: 'NAME',
//                        validateBlank : true,
//                        autoPopup:true,
//                        listeners: {
//                            'onSelected': {
//                                fn: function(records, type) {
//                                    UniAppManager.app.fnHumanCheck(records);
//                                    },
//                                scope: this
//                                },
//                            'onClear': function(type) {
//                                var grdRecord = masterGrid.getSelectionModel().getSelection()[0];                                      
//                                grdRecord.set('NAME', '');
//                                grdRecord.set('PERSON_NUMB', '');
//                            }
//                        }
//                    })
//                },
                { dataIndex: 'BASE_DATE'                , width: 110},
                //RATE 컬럼들
                { text : '근무실적(60점)',
                    columns : [
                        { dataIndex: 'PERFORM_RATE'             , width: 130, align :'right'},
                        { dataIndex: 'PERFECT_RATE'             , width: 130, align :'right'},
                        { dataIndex: 'TIMELY_RATE'              , width: 130, align :'right'}
                    ]
                },
                { text : '직무수행능력(40점)',
                    columns : [
                        { dataIndex: 'INTEGRITY_RATE'           , width: 130, align :'right'},
                        { dataIndex: 'CUSTOMER_RATE'            , width: 130, align :'right'},
                        { dataIndex: 'TEAMWORK_RATE'            , width: 130, align :'right'},
                        { dataIndex: 'PROFESSION_RATE'          , width: 130, align :'right'}
                    ]
                },
                { dataIndex: 'TOT_RATE_SUM'             , width: 110, align :'right'},
                { dataIndex: 'GRADE'                    , width: 110, align :'left'},
                
                { dataIndex: 'APPRAISER'                  , width: 78, hidden: true,
                'editor' : Unilite.popup('Employee_G',{
                        validateBlank : true,
                        autoPopup:true,
                        listeners: {'onSelected': {
                                        fn: function(records, type) {
                                            UniAppManager.app.fnHumanCheck(records);    
                                        },
                                        scope: this
                                    },
                                    'onClear': function(type) {
                                        var grdRecord = Ext.getCmp('hum290ukrGrid1').uniOpt.currentRecord;
                                        grdRecord.set('APPRAISER','');
                                        grdRecord.set('APPRAISER_NAME','');
                                    }
                        }
                    })
                },
                { dataIndex: 'APPRAISER_NAME'                         , width: 120,
                    editor: Unilite.popup('Employee_G', {
    //                  textFieldName: 'NAME',
                        validateBlank : true,
                        autoPopup:true,
                        listeners: {
                            'onSelected': {
                                fn: function(records, type) {
                                    UniAppManager.app.fnHumanCheck(records);
                                    },
                                scope: this
                                },
                            'onClear': function(type) {
                                var grdRecord = Ext.getCmp('hum290ukrGrid1').uniOpt.currentRecord;
                                grdRecord.set('APPRAISER','');
                                grdRecord.set('APPRAISER_NAME','');
                            }
                        }
                    })
                },
                
                { dataIndex: 'REMARK'                   , width: 220, align :'left'}
            ],
            listeners: {
                beforeedit: function( editor, e, eOpts ) {
                    if(UniUtils.indexOf(e.field, ['DIV_CODE', 'NAME', 'BASE_YYYY', 'GRADE_GUBUN', 'BASE_DATE', 'GRADE', 'TOT_RATE_SUM'])) {
                        return false;
                    }
                }   
            }
    });

    Unilite.Main({
        borderItems:[{
            region  : 'center',
            layout  : 'border',
            border  : false,
            items   : [
                masterGrid, 
                panelResult
            ]
        },
            panelSearch     
        ],  
        id  : 'hum290ukrApp',
        
        fnInitBinding : function(params) {
            UniAppManager.setToolbarButtons('save',     false);
            UniAppManager.setToolbarButtons('reset',    true);
            
            var activeSForm ;
            if(!UserInfo.appOption.collapseLeftSearch)  {
                activeSForm = panelSearch;
            }else {
                activeSForm = panelResult;
            }
            activeSForm.onLoadSelectText('BASE_YYYY');
            
            this.setDefault();
        },
        
        onQueryButtonDown : function()  {
            if(!this.isValidSearchForm()){
                return false;
            }else{
                masterGrid.getStore().loadStoreRecords();
            
            }
        },
        onNewDataButtonDown: function() {
        },
        
        onSaveDataButtonDown: function() {
            masterStore.saveStore();
        },

        onDeleteDataButtonDown : function() {
            var selRow = masterGrid.getSelectedRecord();                        
            console.log("selRow",selRow);
            
            if (selRow.phantom == true) {
                masterGrid.deleteSelectedRow();
            } else if (confirm(Msg.sMB045 + "\n" + Msg.sMB062)) {
                masterGrid.deleteSelectedRow();
                UniAppManager.setToolbarButtons('save'  , true);
            }
        },

        onDeleteAllButtonDown : function() {
            if(confirm(Msg.sMH1353 + "\n" + Msg.sMB064)) {  
                masterGrid.reset();
                UniAppManager.setToolbarButtons('deleteAll', false);
            }
        },

        onResetButtonDown: function() {
            panelSearch.clearForm();
            panelResult.clearForm();
            masterGrid.reset();
            this.fnInitBinding();
        },
        
        setDefault: function() {
            panelSearch.setValue('DIV_CODE', UserInfo.divCode);
            panelResult.setValue('DIV_CODE', UserInfo.divCode);
            panelSearch.setValue('BASE_YYYY', new Date().getFullYear());
            panelResult.setValue('BASE_YYYY', new Date().getFullYear());
            
            if(UserInfo.divCode == "01") {
                panelSearch.getField('DIV_CODE').setReadOnly(false);
                panelResult.getField('DIV_CODE').setReadOnly(false);
            }
            else {
                panelSearch.getField('DIV_CODE').setReadOnly(true);
                panelResult.getField('DIV_CODE').setReadOnly(true);
            }
                
        },
        fnHumanCheck: function(records) {
            grdRecord = masterGrid.getSelectedRecord();
            record = records[0];
            grdRecord.set('APPRAISER', record.PERSON_NUMB);
            grdRecord.set('APPRAISER_NAME', record.NAME);
        }
    });

    Unilite.createValidator('validator01', {        // masterGrid afterEdit
        store: masterStore,
        grid: masterGrid,
        validate: function( type, fieldName, newValue, oldValue, record, eopt) {
            console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
            var rv = true;
            
            switch(fieldName) {
                case "PERFORM_RATE" :
                    if(newValue < 0) {
                        rv = Msg.sMB100;
                        break;
                    }
                    if(newValue > 20){
                        rv = '20점이하로 입력하십시오.'
                        break;
                    }
                    
                    setTotalRate();
                    break;
                    
                case "PERFECT_RATE" :
                    if(newValue < 0) {
                        rv = Msg.sMB100; 
                        break;
                    }
                    if(newValue > 20){
                        rv = '20점이하로 입력하십시오.'
                        break;
                    }
                    
                    setTotalRate();
                    break;

                case "TIMELY_RATE" :
                    if(newValue < 0) {
                        rv = Msg.sMB100; 
                        break;
                    }
                    if(newValue > 20){
                        rv = '20점이하로 입력하십시오.'
                        break;
                    }
                    
                    setTotalRate();
                    break;
                    
                case "INTEGRITY_RATE" :
                    if(newValue < 0) {
                        rv = Msg.sMB100; 
                        break;
                    }
                    if(newValue > 10){
                        rv = '10점이하로 입력하십시오.'
                        break;
                    }
                    
                    setTotalRate();
                    break;
                    
                case "CUSTOMER_RATE" :
                    if(newValue < 0) {
                        rv = Msg.sMB100; 
                        break;
                    }
                    if(newValue > 10){
                        rv = '10점이하로 입력하십시오.'
                        break;
                    }
                    
                    setTotalRate();
                    break;

                case "TEAMWORK_RATE" :
                    if(newValue < 0) {
                        rv = Msg.sMB100; 
                        break;
                    }
                    if(newValue > 10){
                        rv = '10점이하로 입력하십시오.'
                        break;
                    }
                    
                    setTotalRate();
                    break;
                    
                case "PROFESSION_RATE" :
                    if(newValue < 0) {
                        rv = Msg.sMB100; 
                        break;
                    }
                    if(newValue > 10){
                        rv = '10점이하로 입력하십시오.'
                        break;
                    }
                    
                    setTotalRate();
                    break;
                    
            }
            return rv;
        }
    });

    function setTotalRate() {
    	var grdRecord = masterGrid.getSelectedRecord();
    	
    	var sPerformRate = grdRecord.get('PERFORM_RATE');
    	var sPerfectRate = grdRecord.get('PERFECT_RATE');
        var sTimelyRate = grdRecord.get('TIMELY_RATE');
        var sIntegrityRate = grdRecord.get('INTEGRITY_RATE');
        var sCustomerRate = grdRecord.get('CUSTOMER_RATE');
        var sTeamworkRate = grdRecord.get('TEAMWORK_RATE');
        var sProfessionRate = grdRecord.get('PROFESSION_RATE');
        
    	grdRecord.set('TOT_RATE_SUM', sPerformRate + sPerfectRate + sTimelyRate + sIntegrityRate +  
    	                              sCustomerRate+ sTeamworkRate+ sProfessionRate);
    	                              
        if((sPerformRate + sPerfectRate + sTimelyRate + sIntegrityRate + sCustomerRate+ sTeamworkRate+ sProfessionRate) >= 80) {
            grdRecord.set('GRADE', '우수');
        }
        else if((sPerformRate + sPerfectRate + sTimelyRate + sIntegrityRate + sCustomerRate+ sTeamworkRate+ sProfessionRate) >= 60 && (sPerformRate + sPerfectRate + sTimelyRate + sIntegrityRate + sCustomerRate+ sTeamworkRate+ sProfessionRate) < 80){
            grdRecord.set('GRADE', '보통');
        }
        else if((sPerformRate + sPerfectRate + sTimelyRate + sIntegrityRate + sCustomerRate+ sTeamworkRate+ sProfessionRate) >= 50 && (sPerformRate + sPerfectRate + sTimelyRate + sIntegrityRate + sCustomerRate+ sTeamworkRate+ sProfessionRate) < 60){
            grdRecord.set('GRADE', '미흡');
        }
        else if((sPerformRate + sPerfectRate + sTimelyRate + sIntegrityRate + sCustomerRate+ sTeamworkRate+ sProfessionRate) < 50){
            grdRecord.set('GRADE', '불량');
        }
    };
};

</script>