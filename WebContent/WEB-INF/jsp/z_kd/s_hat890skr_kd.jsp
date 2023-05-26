<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_hat890skr_kd">
    <t:ExtComboStore comboType="BOR120"  />                             <!-- 사업장 -->    
    <t:ExtComboStore comboType="AU" comboCode="H004" />                    <!-- 근무조 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {
    
    /** Model 정의 
     * @type 
     */
    //1. 기간별 
    Unilite.defineModel('s_hat890skr_kdModel1', {
        fields: [
            {name: 'COMP_CODE'        ,text: 'COMP_CODE'            ,type: 'string'},
            {name: 'DEPT_CODE'        ,text: '부서코드'               ,type: 'string'},
            {name: 'DEPT_NAME'        ,text: '부서명'                ,type: 'string'},
            {name: 'PERSON_NUMB'      ,text: '사원번호'              ,type: 'string'},
            {name: 'PERSON_NAME'      ,text: '성명'                 ,type: 'string'},
            {name: 'WORK_TIME'        ,text: '정상근무시간'           ,type: 'string'},
            {name: 'WEEK_GIVE'        ,text: '주휴일수'              ,type: 'string'},
            
            {name: 'DUTY_01'          ,text: '기본연장시간'           ,type: 'string'},
            {name: 'DUTY_02'          ,text: '추가연장시간'           ,type: 'string'},
            {name: 'DUTY_54'          ,text: '휴직일수'              ,type: 'string'},
            {name: 'DUTY_33'          ,text: '청원휴가'              ,type: 'string'},
            {name: 'DUTY_04'          ,text: '야간시간'              ,type: 'string'},
            {name: 'DUTY_90'          ,text: '생리휴가'              ,type: 'string'},
            {name: 'DUTY_31'          ,text: '월차휴가'              ,type: 'string'},
            {name: 'DUTY_91'          ,text: '월차일수'              ,type: 'string'},
            {name: 'DUTY_61'          ,text: '년차휴가'              ,type: 'string'},
            {name: 'DUTY_92'          ,text: '년차일수'              ,type: 'string'},
            {name: 'DUTY_21'          ,text: '유계결근'              ,type: 'string'},
            
            {name: 'DUTY_22'          ,text: '무계결근'              ,type: 'string'},
            {name: 'DUTY_52'          ,text: '무급휴가'              ,type: 'string'},
            {name: 'DUTY_93'          ,text: '토무휴가'              ,type: 'string'},
            {name: 'DUTY_061'         ,text: '지각횟수'              ,type: 'string'},
            {name: 'DUTY_062'         ,text: '지각시간'              ,type: 'string'},
            {name: 'DUTY_081'         ,text: '외출횟수'              ,type: 'string'},
            {name: 'DUTY_082'         ,text: '외출시간'              ,type: 'string'},
            {name: 'DUTY_071'         ,text: '조퇴횟수'              ,type: 'string'},
            {name: 'DUTY_072'         ,text: '조퇴시간'              ,type: 'string'},
            {name: 'DUTY_94'          ,text: '임문조회'              ,type: 'string'},
            {name: 'DED_DAY'          ,text: '공제일수'              ,type: 'string'},
            
            {name: 'DUTY_04'          ,text: '야간시간'              ,type: 'string'},
            {name: 'DUTY_05'          ,text: '특근시간'              ,type: 'string'},
            {name: 'DUTY_03'          ,text: '특근연장'              ,type: 'string'},
            {name: 'DUTY_99'          ,text: '총차감계'              ,type: 'string'},
            {name: 'DUTY_3354'        ,text: '휴직청원'              ,type: 'string'},
            {name: 'DUTY_61TOT'       ,text: '년차사용계'             ,type: 'string'},
            {name: 'DUTY_2122'        ,text: '유계무계'              ,type: 'string'},
            {name: 'DUTY_2122TIME'    ,text: '결근시간'              ,type: 'string'},
            {name: 'DUTY_52TIME'      ,text: '무급휴가시간'           ,type: 'string'},
            {name: 'DUTY_41'          ,text: '훈련'                 ,type: 'string'},
            {name: 'DUTY_51'          ,text: '유급휴가'              ,type: 'string'},
            {name: 'POST_CODE'        ,text: '직위'                 ,type: 'string'}
        ]
    });
    
    /** Model 정의 
     * @type 
     */
    //2. 월별
    Unilite.defineModel('s_hat890skr_kdModel2', {
        fields: [
            {name: 'COMP_CODE'        ,text: 'COMP_CODE'            ,type: 'string'},
            {name: 'DEPT_CODE'        ,text: '부서코드'               ,type: 'string'},
            {name: 'DEPT_NAME'        ,text: '부서명'                ,type: 'string'},
            {name: 'PERSON_NUMB'      ,text: '사원번호'              ,type: 'string'},
            {name: 'PERSON_NAME'      ,text: '성명'                 ,type: 'string'},
            {name: 'WORK_TIME'        ,text: '정상근무시간'           ,type: 'string'},
            {name: 'WEEK_GIVE'        ,text: '주휴일수'              ,type: 'string'},
            
            {name: 'DUTY_01'          ,text: '기본연장시간'           ,type: 'string'},
            {name: 'DUTY_02'          ,text: '추가연장시간'           ,type: 'string'},
            {name: 'DUTY_54'          ,text: '휴직일수'              ,type: 'string'},
            {name: 'DUTY_33'          ,text: '청원휴가'              ,type: 'string'},
            {name: 'DUTY_04'          ,text: '야간시간'              ,type: 'string'},
            {name: 'DUTY_90'          ,text: '생리휴가'              ,type: 'string'},
            {name: 'DUTY_31'          ,text: '월차사용계'              ,type: 'string'},
            {name: 'DUTY_91'          ,text: '월차일수'              ,type: 'string'},
            {name: 'DUTY_61'          ,text: '당월년차사용일수'              ,type: 'string'},
            {name: 'DUTY_92'          ,text: '월차권수계'              ,type: 'string'},
            {name: 'DUTY_21'          ,text: '유계결근'              ,type: 'string'},
            
            {name: 'DUTY_22'          ,text: '무계결근'              ,type: 'string'},
            {name: 'DUTY_52'          ,text: '무급휴가'              ,type: 'string'},
            {name: 'DUTY_93'          ,text: '년차권수계'              ,type: 'string'},
            {name: 'DUTY_061'         ,text: '지각횟수'              ,type: 'string'},
            {name: 'DUTY_062'         ,text: '지각시간'              ,type: 'string'},
            {name: 'DUTY_081'         ,text: '외출횟수'              ,type: 'string'},
            {name: 'DUTY_082'         ,text: '외출시간'              ,type: 'string'},
            {name: 'DUTY_071'         ,text: '조퇴횟수'              ,type: 'string'},
            {name: 'DUTY_072'         ,text: '조퇴시간'              ,type: 'string'},
            {name: 'DUTY_94'          ,text: '임문지연합'              ,type: 'string'},
            {name: 'DED_DAY'          ,text: '공제일수'              ,type: 'string'},
            
            {name: 'DUTY_04'          ,text: '야간시간'              ,type: 'string'},
            {name: 'DUTY_05'          ,text: '특근시간'              ,type: 'string'},
            {name: 'DUTY_03'          ,text: '특근연장'              ,type: 'string'},
            {name: 'DUTY_99'          ,text: '총차감계'              ,type: 'string'},
            {name: 'DUTY_3354'        ,text: '휴직청원'              ,type: 'string'},
            {name: 'DUTY_61TOT'       ,text: '년차사용계'             ,type: 'string'},
            {name: 'DUTY_2122'        ,text: '유계무계'              ,type: 'string'},
            {name: 'DUTY_2122TIME'    ,text: '결근시간'              ,type: 'string'},
            {name: 'DUTY_52TIME'      ,text: '무급휴가시간'           ,type: 'string'},
            {name: 'DUTY_41'          ,text: '훈련'                 ,type: 'string'},
            {name: 'DUTY_51'          ,text: '유급휴가'              ,type: 'string'},
            {name: 'POST_CODE'        ,text: '직위'                 ,type: 'string'}
        ]
    });
    
    
    
    /** Store 정의(Service 정의)
     * @type 
     */        
    //1. 기간별
    var masterStore1 = Unilite.createStore('s_hat890skr_kdmasterStore11',{
        model    : 's_hat890skr_kdModel1',
        uniOpt    : {
            isMaster    : true,                // 상위 버튼 연결 
            editable    : false,            // 수정 모드 사용 
            deletable    : false,            // 삭제 가능 여부 
            useNavi        : false
        },
        autoLoad: false,
        proxy    : {
            type: 'direct',
            api: {            
                    read: 's_hat890skr_kdService.selectList'
            }
        },
        loadStoreRecords : function()    {
            var param= Ext.getCmp('panelResultForm').getValues();
            //1: 기간별 flag
            param.WORK_GB = '1'
            console.log( param );
            	this.load({
                	params : param
            	});
        },
        listeners: {
            load: function(store, records, successful, eOpts) {
                var count = masterGrid1.getStore().getCount();  
                if(count > 0){
                    Ext.getCmp('GW1').setDisabled(false);
                }else{
                    Ext.getCmp('GW1').setDisabled(true);
                }

            }
        },
        group: 'DEPT_CODE'
    });
    
    //2. 월별
    var masterStore2 = Unilite.createStore('s_hat890skr_kdmasterStore12',{
        model    : 's_hat890skr_kdModel2',
        uniOpt    : {
            isMaster    : true,                // 상위 버튼 연결 
            editable    : false,            // 수정 모드 사용 
            deletable    : false,            // 삭제 가능 여부 
            useNavi        : false                // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy    : {
            type: 'direct',
            api: {            
                    read: 's_hat890skr_kdService.selectList'
            }
        },
        loadStoreRecords : function()    {
            var param= Ext.getCmp('panelResultForm').getValues();
            //2: 월별 flag
            param.WORK_GB = '2'
            console.log( param );
            this.load({
                params : param
            });
        },
        listeners: {
            load: function(store, records, successful, eOpts) {
                var count = masterGrid1.getStore().getCount();  
                if(count > 0){
                    Ext.getCmp('GW2').setDisabled(false);
                }else{
                    Ext.getCmp('GW2').setDisabled(true);
                }

            }
        },
        group: 'DEPT_CODE'
    });

     var panelResult = Unilite.createSearchForm('panelResultForm', {
        region    : 'north',
        layout    : {type : 'uniTable', columns : 3
//        , tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/}
//        , tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
        },
        padding    : '1 1 1 1',
        border    : true,
        items    : [{
                fieldLabel      : '근태월',
                xtype           : 'uniMonthRangefield',
                startFieldName  : 'DUTY_MON_FR',
                endFieldName    : 'DUTY_MON_TO',
                name            : 'DUTY_MONTH',
                startDate       : UniDate.getDbDateStr(UniDate.get('today')),
                endDate         : UniDate.getDbDateStr(UniDate.get('today')),
                tdAttrs         : {width: 350},

                allowBlank  : false,
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                },
                onEndDateChange: function(field, newValue, oldValue, eOpts) {
                }
            },{
                fieldLabel        : '근태일자',
                xtype            : 'uniDatefield',
                name             : 'DUTY_DATE',
                allowBlank  : false,
                hidden :true,
                tdAttrs            : {width: 350} 
            },{
                fieldLabel    : '사업장',
                name        : 'DIV_CODE', 
                xtype        : 'uniCombobox',
                comboType    : 'BOR120',
                value        : UserInfo.divCode,
                colspan        : 2,
//                multiSelect    : true, 
//                typeAhead    : false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                    }
                 }
            }, 
            Unilite.popup('Employee',{
                fieldLabel        : '사원',
                valueFieldName    : 'PERSON_NUMB_FR',
                textFieldName    : 'NAME',
                validateBlank    : false,
                autoPopup        : true,
                listeners        : {
                    onSelected: {
                        fn: function(records, type) {
                        	panelResult.setValue('PERSON_NUMB_TO', panelResult.getValue('PERSON_NUMB_FR'));
                            panelResult.setValue('NAME1', panelResult.getValue('NAME'));
                        },
                        scope: this
                    },
                    onClear: function(type)    {
                    	panelResult.setValue('PERSON_NUMB_FR', '');
                        panelResult.setValue('NAME', '');
                    },
                    onValueFieldChange: function(field, newValue){
                    },
                    onTextFieldChange: function(field, newValue){
                    }
                }
            }),
            Unilite.popup('Employee',{
                fieldLabel        : '~',
                valueFieldName    : 'PERSON_NUMB_TO',
                textFieldName    : 'NAME1',
                validateBlank    : false,
                autoPopup        : true,
                colspan        : 2,
                listeners        : {
                    onSelected: {
                        fn: function(records, type) {
                        },
                        scope: this
                    },
                    onClear: function(type)    {
                    	panelResult.setValue('PERSON_NUMB_TO', '');
                        panelResult.setValue('NAME1', '');
                    },
                    onValueFieldChange: function(field, newValue){
                    },
                    onTextFieldChange: function(field, newValue){
                    }
                }
            }), 
            Unilite.popup('DEPT',{
                fieldLabel        : '부서',
                valueFieldName    : 'DEPT_CODE_FR',
                textFieldName    : 'DEPT_NAME',
                validateBlank    : false,                    
                tdAttrs            : {width: 380},  
                listeners        : {
                    onSelected: {
                        fn: function(records, type) {
                            panelResult.setValue('DEPT_CODE_TO', panelResult.getValue('DEPT_CODE_FR'));
                            panelResult.setValue('DEPT_NAME1', panelResult.getValue('DEPT_NAME'));
                        },
                        scope: this
                    },
                    onClear: function(type)    {
                    	panelResult.setValue('DEPT_CODE_FR', '');
                        panelResult.setValue('DEPT_NAME', '');
                    },
                    onValueFieldChange: function(field, newValue){
                    },
                    onTextFieldChange: function(field, newValue){
                    }
                }
            }),Unilite.popup('DEPT',{
                fieldLabel        : '~',
                valueFieldName    : 'DEPT_CODE_TO',
                textFieldName    : 'DEPT_NAME1',
                validateBlank    : false,                    
                tdAttrs            : {width: 380},  
                listeners        : {
                    onSelected: {
                        fn: function(records, type) {
//                            dataForm.setValue('S_DEPT_CODE', records[0].DEPT_CODE);
                        },
                        scope: this
                    },
                    onClear: function(type)    {
                    	panelResult.setValue('DEPT_CODE_TO', '');
                        panelResult.setValue('DEPT_NAME1', '');
                    },
                    onValueFieldChange: function(field, newValue){
                    },
                    onTextFieldChange: function(field, newValue){
                    }
                }
            })
        ]
    });
    
    
    
    /** Master Grid1 정의(Grid Panel)
     * @type 
     */
    //1. 기간별
    var masterGrid1 = Unilite.createGrid('s_hat890skr_kdGrid1', {
        store    : masterStore1,
        region    : 'center',
        layout    : 'fit',
        uniOpt    : {    
            expandLastColumn    : true,            //마지막 컬럼 * 사용 여부
            useRowNumberer        : true,            //첫번째 컬럼 순번 사용 여부
            useLiveSearch        : true,            //찾기 버튼 사용 여부
            useRowContext        : false,            
            onLoadSelectFirst    : true,
            filter: {                            //필터 사용 여부
                useFilter    : true,
                autoCreate    : true
            }
        },
        
        tbar: [{
                itemId : 'GWBtn',
                id:'GW1',
                iconCls : 'icon-referance'  ,
                text:'기안',
                handler: function() {
                    var param = panelResult.getValues();
                    
                    if(!UniAppManager.app.isValidSearchForm()){
                        return false;
                    }
                
                    //param.DRAFT_NO = "0";
                    if(confirm('기안 하시겠습니까?')) {
                       UniAppManager.app.requestApprove();
                    }
                    //UniAppManager.app.onQueryButtonDown();
                }
            }
        ],
        
        features: [ 
            {id: 'masterGrid1SubTotal1'    , ftype: 'uniGroupingsummary'    , showSummaryRow: false},
            {id: 'masterGrid1Total2'    , ftype: 'uniSummary'            , showSummaryRow: false} 
        ],
        columns:  [
            { dataIndex: 'COMP_CODE'      , width: 110    , hidden: true},
            { dataIndex: 'DEPT_CODE'      , width: 110    , locked:true},
            { dataIndex: 'DEPT_NAME'      , width: 140    , locked:true},
            { dataIndex: 'PERSON_NUMB'    , width: 110    , locked:true},
            { dataIndex: 'PERSON_NAME'    , width: 110    , locked:true},
            { dataIndex: 'WORK_TIME'      , width: 100    , align: 'right'},
            { dataIndex: 'WEEK_GIVE'      , width: 100    , align: 'right'},
            
            { dataIndex: 'DUTY_01'        , width: 100    , align: 'right'},
            { dataIndex: 'DUTY_02'        , width: 100    , align: 'right'},
            { dataIndex: 'DUTY_54'        , width: 100    , align: 'right'},
            { dataIndex: 'DUTY_33'        , width: 100    , align: 'right'},
            { dataIndex: 'DUTY_04'        , width: 100    , align: 'right'},
            { dataIndex: 'DUTY_90'        , width: 100    , align: 'right'},
            { dataIndex: 'DUTY_31'        , width: 100    , align: 'right'},
            { dataIndex: 'DUTY_91'        , width: 100    , align: 'right'},
            { dataIndex: 'DUTY_61'        , width: 100    , align: 'right'},
            { dataIndex: 'DUTY_92'        , width: 100    , align: 'right'},
            { dataIndex: 'DUTY_21'        , width: 100    , align: 'right'},
            { dataIndex: 'DUTY_22'        , width: 100    , align: 'right'},
            { dataIndex: 'DUTY_52'        , width: 100    , align: 'right'},
            { dataIndex: 'DUTY_93'        , width: 100    , align: 'right'},
            { dataIndex: 'DUTY_061'       , width: 100    , align: 'right'},
            { dataIndex: 'DUTY_062'       , width: 100    , align: 'right'},
            { dataIndex: 'DUTY_081'       , width: 100    , align: 'right'},
            { dataIndex: 'DUTY_082'       , width: 100    , align: 'right'},
            { dataIndex: 'DUTY_071'       , width: 100    , align: 'right'},
            { dataIndex: 'DUTY_072'       , width: 100    , align: 'right'},
            { dataIndex: 'DUTY_94'        , width: 100    , align: 'right'},
            { dataIndex: 'DED_DAY'        , width: 100    , align: 'right'},
            { dataIndex: 'POST_CODE'      , width: 100, hidden: true  }
        ] ,
        listeners:{
            uniOnChange: function(grid, dirty, eOpts) {
            }
        }
    });    

    //2. 월별
    var masterGrid2 = Unilite.createGrid('s_hat890skr_kdGrid2', {
        store    : masterStore2,
        region    : 'center',
        layout    : 'fit',
        uniOpt    : {    
            expandLastColumn    : true,            //마지막 컬럼 * 사용 여부
            useRowNumberer        : true,            //첫번째 컬럼 순번 사용 여부
            useLiveSearch        : true,            //찾기 버튼 사용 여부
            useRowContext        : false,            
            onLoadSelectFirst    : true,
            filter: {                            //필터 사용 여부
                useFilter    : true,
                autoCreate    : true
            }
        },
        
        tbar: [{
                itemId : 'GWBtn',
                id:'GW2',
                iconCls : 'icon-referance'  ,
                text:'기안',
                handler: function() {
                    var param = panelResult.getValues();
                    
                    if(!UniAppManager.app.isValidSearchForm()){
                        return false;
                    }
                
                    //param.DRAFT_NO = "0";
                    if(confirm('기안 하시겠습니까?')) {
                       UniAppManager.app.requestApprove();
                    }
                    //UniAppManager.app.onQueryButtonDown();
                }
            }
        ],
        
        features: [ 
            {id: 'masterGrid1SubTotal2'    , ftype: 'uniGroupingsummary'    , showSummaryRow: false},
            {id: 'masterGrid1Total2'    , ftype: 'uniSummary'            , showSummaryRow: false} 
        ],
        columns:  [
            { dataIndex: 'COMP_CODE'      , width: 110    , hidden: true},
            { dataIndex: 'DEPT_CODE'      , width: 110    },
            { dataIndex: 'DEPT_NAME'      , width: 140    },
            { dataIndex: 'PERSON_NUMB'    , width: 110    },
            { dataIndex: 'PERSON_NAME'    , width: 110    },
            { dataIndex: 'WORK_TIME'      , width: 100    , align: 'right'},
            { dataIndex: 'WEEK_GIVE'      , width: 100    , align: 'right'},
            
            { dataIndex: 'DUTY_01'        , width: 100    , align: 'right'},
            { dataIndex: 'DUTY_02'        , width: 100    , align: 'right'},
            { dataIndex: 'DUTY_04'        , width: 100    , align: 'right'},
            { dataIndex: 'DUTY_05'        , width: 100    , align: 'right'},
            { dataIndex: 'DUTY_03'        , width: 100    , align: 'right'},
            { dataIndex: 'DUTY_99'        , width: 100    , align: 'right'},
            { dataIndex: 'DUTY_91'        , width: 100    , align: 'right'},
            { dataIndex: 'DUTY_3354'      , width: 100    , align: 'right'},
            { dataIndex: 'DUTY_31'        , width: 100    , align: 'right'},
            { dataIndex: 'DUTY_92'        , width: 100    , align: 'right'},
            { dataIndex: 'DUTY_61'        , width: 100    , align: 'right'},
            { dataIndex: 'DUTY_61TOT'     , width: 100    , align: 'right'},
            { dataIndex: 'DUTY_93'        , width: 100    , align: 'right'},
            { dataIndex: 'DUTY_2122'      , width: 100    , align: 'right'},
            { dataIndex: 'DUTY_2122TIME'  , width: 100    , align: 'right'},
            { dataIndex: 'DUTY_52'        , width: 100    , align: 'right'},
            { dataIndex: 'DUTY_52TIME'    , width: 100    , align: 'right'},
            { dataIndex: 'DUTY_41'        , width: 100    , align: 'right'},
            { dataIndex: 'DUTY_51'        , width: 100    , align: 'right'},
            { dataIndex: 'DUTY_061'       , width: 100    , align: 'right'},
            { dataIndex: 'DUTY_062'       , width: 100    , align: 'right'},
            
            { dataIndex: 'DUTY_081'       , width: 100    , align: 'right'},
            { dataIndex: 'DUTY_082'       , width: 100    , align: 'right'},
            { dataIndex: 'DUTY_071'       , width: 100    , align: 'right'},
            { dataIndex: 'DUTY_072'       , width: 100    , align: 'right'},
            { dataIndex: 'DUTY_94'        , width: 100    , align: 'right'},
            
            { dataIndex: 'DED_DAY'        , width: 100    , align: 'right'},
            { dataIndex: 'POST_CODE'      , width: 100, hidden: true   }
        ] ,
        listeners:{
            uniOnChange: function(grid, dirty, eOpts) {
            }
        }
    });    

    
    
    
    var tab = Unilite.createTabPanel('s_hat890skr_kdTab',{        
        region        : 'center',
        activeTab    : 0,
        border        : false,
        items        : [{
                title    : '기간별',
                xtype    : 'container',
                itemId    : 's_hat890skr_kdTab1',
                layout    : {type:'vbox', align:'stretch'},
                items    : [
                    masterGrid1
                ]
            },{
                title    : '월별',
                hidden   : true,
                xtype    : 'container',
                itemId    : 's_hat890skr_kdTab2',
                layout    : {type:'vbox', align:'stretch'},
                items:[
                    masterGrid2
                ]
            }
        ],
        listeners:{
            tabchange: function( tabPanel, newCard, oldCard, eOpts )    {
                if(newCard.getItemId() == 's_hat890skr_kdTab1')    {
                	panelResult.getField('DUTY_DATE').setHidden(true);
                    panelResult.getField('DUTY_MONTH').setHidden(false);
                    
                }else {
                	panelResult.getField('DUTY_MONTH').setHidden(false);
                    panelResult.getField('DUTY_DATE').setHidden(true);
                }
            }
        }
    })
 
    
    
    
     Unilite.Main({
        id  : 's_hat890skr_kdApp',
        borderItems:[{
          region:'center',
          layout: {type: 'vbox', align: 'stretch'},
          border: false,
          items:[
                 panelResult, tab 
          ]}
        ], 
        fnInitBinding : function() {
        	
        	//초기값 설정
        	panelResult.setValue('DUTY_DATE'    , new Date());
            panelResult.setValue('DUTY_MON_FR'  , new Date());
            panelResult.setValue('DUTY_MON_TO'  , new Date());
            panelResult.setValue('DIV_CODE'     , UserInfo.divCode);
            
            
            //초기화 시, 포커스 설정
            panelResult.onLoadSelectText('DUTY_DATE');
            panelResult.onLoadSelectText('DUTY_MON_FR');
            //버튼 설정
            UniAppManager.setToolbarButtons('detail',false);
            UniAppManager.setToolbarButtons('reset',false);
            UniAppManager.setToolbarButtons('save',false);
            
            Ext.getCmp('GW1').setDisabled(true);
            Ext.getCmp('GW2').setDisabled(true);
        },
        
        onQueryButtonDown : function()    {
            //필수입력값 체크
            if(!this.isValidSearchForm()){
                return false;
            }
            
            //활성화 된 탭에 따른 조회로직
            var activeTab = tab.getActiveTab().getItemId();
            //1: 기간별
            if (activeTab == 's_hat890skr_kdTab1'){
                masterStore1.loadStoreRecords();

            //2: 월별
            } else {
                masterStore2.loadStoreRecords();
            }
            
            //초기화 버튼 활성화
            UniAppManager.setToolbarButtons('reset', true);
        },                
                
        onResetButtonDown: function() {        
   
            panelResult.clearForm();
            masterGrid1.getStore().loadData({});    
            masterGrid2.getStore().loadData({});
            this.fnInitBinding();    
        }, 
        requestApprove: function(){     //결재 요청
            var gsWin = window.open('about:blank','payviewer','width=500,height=500');
            
            var frm         = document.f1;
            var compCode    = UserInfo.compCode;
            var divCode     = panelResult.getValue('DIV_CODE');
            var userId      = UserInfo.userID
            
            var deptcodefr    = panelResult.getValue('DEPT_CODE_FR');
            var deptcodeto    = panelResult.getValue('DEPT_CODE_TO');
            var personnumbfr  = panelResult.getValue('PERSON_NUMB_FR');
            var personnumbto  = panelResult.getValue('PERSON_NUMB_TO');
            
            //var date         = UniDate.getDbDateStr(panelResult.getValue('DUTY_DATE')).substring(0, 6);
            
            var stMonth      = UniDate.getDbDateStr(panelResult.getValue('DUTY_MON_FR')).substring(0, 6);
            var endMonth     = UniDate.getDbDateStr(panelResult.getValue('DUTY_MON_TO')).substring(0, 6);
            
            //var record = masterGrid1.getSelectedRecord();
            var activeTab = tab.getActiveTab().getItemId();
            //1: 기간별
            if (activeTab == 's_hat890skr_kdTab1'){
                var groupUrl = "http://gw.kdg.co.kr:8070/approval/legacyGateway.hi?viewMode=docuDraft&prg_no=hat890skr_1&draft_no=0&sp=EXEC " 
                var gubun    = '1'

            //2: 월별
            } else {
                var groupUrl = "http://gw.kdg.co.kr:8070/approval/legacyGateway.hi?viewMode=docuDraft&prg_no=hat890skr_2&draft_no=0&sp=EXEC " 
                var gubun    = '2'
            }

            //var stDate      = masterGrid1.getValue("JOIN_DATE")
            
            
            //1: 기간별
            if(activeTab == 's_hat890skr_kdTab1'){
                var spText      = 'omegaplus_kdg.unilite.USP_HUMAN_HAT890SKR_fnQuery ' + "'" + compCode + "'" + ', ' + "'" + divCode + "'" 
                                + ', ' + "'" + deptcodefr + "'" + ', ' + "'" + deptcodeto + "'"
                                + ', ' + "'" + personnumbfr + "'" + ', ' + "'" + personnumbto + "'"
                                + ', ' + "'" + stMonth + "'" + ', ' + "'" + endMonth + "'"
                                + ', ' + "'" + gubun +"'" + ', ' + "''" + ', ' + "'" + userId + "'" + ', ' + "'ko'" + ', ' + "''";
                var spCall      = encodeURIComponent(spText); 
            //2: 월별
            }else{   
                var spText      = 'omegaplus_kdg.unilite.USP_HUMAN_HAT890SKR_fnQuery ' + "'" + compCode + "'" + ', ' + "'" + divCode + "'" 
                                + ', ' + "'" + deptcodefr + "'" + ', ' + "'" + deptcodeto + "'"
                                + ', ' + "'" + personnumbfr + "'" + ', ' + "'" + personnumbto + "'"
                                + ', ' + "'" + stMonth + "'" + ', ' + "'" + endMonth + "'"
                                + ', ' + "'" + gubun +"'" + ', ' + "''" + ', ' + "'" + userId + "'" + ', ' + "'ko'" + ', ' + "''";
                var spCall      = encodeURIComponent(spText); 
            }
            
            
            //var groupUrl = "http://58.151.163.201:8070/ClipReport4/sample2.jsp?prg_no=hat890skr&sp=EXEC "

            frm.action   = groupUrl + spCall/* + Base64.encode()*/;
            frm.target   = "payviewer"; 
            frm.method   = "post";
            frm.submit();
        }
        
    });
};
</script>

<form id="f1" name="f1" action="" method="post" onSubmit="return false;" >
<input type="hidden" id="loginid" name="loginid" value="superadmin" />
<input type="hidden" id="fmpf" name="fmpf" value="" />
<input type="hidden" id="fmbd" name="fmbd" runat="server" />
</form>
