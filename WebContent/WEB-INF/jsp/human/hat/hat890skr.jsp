<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hat890skr">
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
    //1. 기간별 , 2. 월별
    Unilite.defineModel('hat890skrModel', {
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
    
    
    
    
    /** Store 정의(Service 정의)
     * @type 
     */        
    //1. 기간별
    var masterStore1 = Unilite.createStore('hat890skrmasterStore11',{
        model    : 'hat890skrModel',
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
                    read: 'hat890skrService.selectList'
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
                    //UniAppManager.setToolbarButtons(['print'], true);
                }else{
                    //UniAppManager.setToolbarButtons(['print'], false);
                }

            }
        },
        group: 'DEPT_CODE'
    });
    
    //2. 월별
    var masterStore2 = Unilite.createStore('hat890skrmasterStore12',{
        model    : 'hat890skrModel',
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
                    read: 'hat890skrService.selectList'
            }
        },
        loadStoreRecords : function()    {
            var param= Ext.getCmp('panelResultForm').getValues();
            //1: 월별 flag
            //param.WORK_GB = '1'
            
            //활성화 된 탭에 따른 조회로직
            var activeTab = tab.getActiveTab().getItemId();
            //1: 기간별
            if (activeTab == 'hat890skrTab1'){
                param.WORK_GB = '1'

            //2: 월별
            } else {
                param.WORK_GB = '2'
            }
            
            console.log( param );
            this.load({
                params : param
            });
        },
        listeners: {
            load: function(store, records, successful, eOpts) {
                var count = masterGrid1.getStore().getCount();  
                if(count > 0){
                    //UniAppManager.setToolbarButtons(['print'], true);
                }else{
                    //UniAppManager.setToolbarButtons(['print'], false);
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
                fieldLabel        : '근태월',
                xtype            : 'uniMonthRangefield',
                startFieldName    : 'DUTY_FR_MON',
                endFieldName    : 'DUTY_TO_MON',
                startDate        : UniDate.getDbDateStr(UniDate.get('today')),
                endDate            : UniDate.getDbDateStr(UniDate.get('today')),
                tdAttrs            : {width: 350}, 
                allowBlank        : false,                    
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelResult) {
                        panelResult.setValue('DUTY_TO_MON',newValue);
                    }
                },
                onEndDateChange: function(field, newValue, oldValue, eOpts) {
                }
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
                valueFieldName    : 'PERSON_NUMB',
                textFieldName    : 'NAME',
                validateBlank    : false,
                autoPopup        : true,
                listeners        : {
                    onSelected: {
                        fn: function(records, type) {
                        },
                        scope: this
                    },
                    onClear: function(type)    {
                    },
                    onValueFieldChange: function(field, newValue){
                    },
                    onTextFieldChange: function(field, newValue){
                    }
                }
            }),  
            Unilite.popup('DEPT',{
                fieldLabel        : '부서',
                valueFieldName    : 'DEPT_CODE',
                textFieldName    : 'DEPT_NAME',
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
    var masterGrid1 = Unilite.createGrid('hat890skrGrid1', {
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
        
        features: [ 
            {id: 'masterGrid1SubTotal1'    , ftype: 'uniGroupingsummary'    , showSummaryRow: false},
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
    var masterGrid2 = Unilite.createGrid('hat890skrGrid2', {
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
            { dataIndex: 'WORK_TIME'      , width: 100        },
            { dataIndex: 'WEEK_GIVE'      , width: 100        },
            
            { dataIndex: 'DUTY_01'        , width: 100        },
            { dataIndex: 'DUTY_02'        , width: 100        },
            { dataIndex: 'DUTY_04'        , width: 100        },
            { dataIndex: 'DUTY_05'        , width: 100        },
            { dataIndex: 'DUTY_03'        , width: 100        },
            { dataIndex: 'DUTY_99'        , width: 100        },
            { dataIndex: 'DUTY_91'        , width: 100        },
            { dataIndex: 'DUTY_3354'      , width: 100        },
            { dataIndex: 'DUTY_31'        , width: 100        },
            { dataIndex: 'DUTY_92'        , width: 100        },
            { dataIndex: 'DUTY_61'        , width: 100        },
            { dataIndex: 'DUTY_61TOT'     , width: 100        },
            { dataIndex: 'DUTY_93'        , width: 100        },
            { dataIndex: 'DUTY_2122'      , width: 100        },
            { dataIndex: 'DUTY_2122TIME'  , width: 100        },
            { dataIndex: 'DUTY_52'        , width: 100        },
            { dataIndex: 'DUTY_52TIME'    , width: 100        },
            { dataIndex: 'DUTY_41'        , width: 100        },
            { dataIndex: 'DUTY_51'        , width: 100        },
            { dataIndex: 'DUTY_061'       , width: 100        },
            { dataIndex: 'DUTY_062'       , width: 100        },
            
            { dataIndex: 'DUTY_081'       , width: 100        },
            { dataIndex: 'DUTY_082'       , width: 100        },
            { dataIndex: 'DUTY_071'       , width: 100        },
            { dataIndex: 'DUTY_072'       , width: 100        },
            { dataIndex: 'DUTY_94'        , width: 100        },
            
            { dataIndex: 'DED_DAY'        , width: 100        },
            { dataIndex: 'POST_CODE'      , width: 100, hidden: true   }
        ] ,
        listeners:{
            uniOnChange: function(grid, dirty, eOpts) {
            }
        }
    });    

    
    
    
    var tab = Unilite.createTabPanel('hat890skrTab',{        
        region        : 'center',
        activeTab    : 0,
        border        : false,
        items        : [{
                title    : '기간별',
                xtype    : 'container',
                itemId    : 'hat890skrTab1',
                layout    : {type:'vbox', align:'stretch'},
                items    : [
                    masterGrid1
                ]
            },{
                title    : '월별',
                xtype    : 'container',
                itemId    : 'hat890skrTab2',
                layout    : {type:'vbox', align:'stretch'},
                items:[
                    masterGrid2
                ]
            }
        ],
        listeners:{
            tabchange: function( tabPanel, newCard, oldCard, eOpts )    {
                if(newCard.getItemId() == 'hat890skrTab1')    {
                    
                }else {
                    
                }
            }
        }
    })
 
    
    
    
     Unilite.Main({
        id  : 'hat890skrApp',
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
            panelResult.setValue('DUTY_FR_MON'    , new Date());
            panelResult.setValue('DUTY_TO_MON'    , new Date());
            panelResult.setValue('DIV_CODE'        , UserInfo.divCode);
            
            //초기화 시, 포커스 설정
            panelResult.onLoadSelectText('DUTY_FR_MON');
            //버튼 설정
            UniAppManager.setToolbarButtons('detail',false);
            UniAppManager.setToolbarButtons('reset',false);
            UniAppManager.setToolbarButtons('save',false);
        },
        
        onQueryButtonDown : function()    {
            //필수입력값 체크
            if(!this.isValidSearchForm()){
                return false;
            }
            
            //활성화 된 탭에 따른 조회로직
            var activeTab = tab.getActiveTab().getItemId();
            //1: 기간별
            if (activeTab == 'hat890skrTab1'){
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
        }
        
    });
};
</script>

