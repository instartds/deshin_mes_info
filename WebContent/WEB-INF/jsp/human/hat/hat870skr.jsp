<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hat870skr">
    <t:ExtComboStore comboType="BOR120"  />                             <!-- 사업장 -->   
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
    Unilite.defineModel('hat870skrModel', {
        fields: [
			{name: 'COMP_CODE'		 	,text: '사업장'			,type: 'string'},
			{name: 'DEPT_CODE'			,text: '부서코드'					,type: 'string'},
			{name: 'DEPT_NAME'			,text: '부서명'				,type: 'string'},
			{name: 'SORT_SEQ'		      ,text: '순번'				,type: 'string'},
			{name: 'PERSON_NUMB'			,text: '사원번호'					,type: 'string'}, //		, comboType: "AU"	, comboCode: "H005"},
			{name: 'POST_NAME'		        ,text: '직책'					,type: 'string'},
			{name: 'POST_CODE'				,text: '직책코드'					,type: 'string'},
			{name: 'PERSON_NAME'			,text: '성명'					,type: 'string'},
			{name: 'DUTY_FR_TIME'			,text: '출근'					,type: 'string'},
			{name: 'DUTY_TO_TIME'				,text: '퇴근'					,type: 'string'},
			{name: 'OUT_TIME'				,text: '외출'					,type: 'string'},
			{name: 'IN_TIME'				,text: '귀사'				,type: 'string'},
			{name: 'DUTY_CODE1'				,text: '근태1'				,type: 'string'},
			{name: 'DUTY_CODE2'				,text: '근태2'				,type: 'string'},
			{name: 'DUTY_CODE3'				,text: '근태3'				,type: 'string'},
			{name: 'DUTY_CODE4'				,text: '근태4'					,type: 'string'}
        ]
    });

    /** Store 정의(Service 정의)
     * @type 
     */        
    //1. 기간별
    var masterStore1 = Unilite.createStore('hat870skrmasterStore11',{
        model    : 'hat870skrModel',
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
                    read: 'hat870skrService.selectList'
            }
        },
        loadStoreRecords : function()    {
            var param= Ext.getCmp('panelResultForm').getValues();
            //1: 기간별 flag
            param.WORK_GUBUN = '1'
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
    var masterStore2 = Unilite.createStore('hat870skrmasterStore12',{
        model    : 'hat870skrModel',
        uniOpt    : {
//            isMaster    : true,                // 상위 버튼 연결 
            isMaster    : false,                // 상위 버튼 연결 
            editable    : false,            // 수정 모드 사용 
            deletable    : false,            // 삭제 가능 여부 
            useNavi        : false                // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy    : {
            type: 'direct',
            api: {            
                    read: 'hat870skrService.selectList'
            }
        },
        loadStoreRecords : function()    {
            var param= Ext.getCmp('panelResultForm').getValues();
            //1: 월별 flag
            param.WORK_GUBUN = '2'
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
        items    : [
            {
                    fieldLabel: '근태일자',
                    xtype: 'uniDatefield',
                    name: 'DUTY_DATE',
                    labelWidth:90,
                    value: new Date(),
                    allowBlank: false,
                    listeners: {
                          change: function(field, newValue, oldValue, eOpts) {                                  
                          }
                    }
            }, {
                 fieldLabel    : '사업장',
                 name        : 'DIV_CODE', 
                 xtype        : 'uniCombobox',
                 comboType    : 'BOR120',
                 value        : UserInfo.divCode,
                 colspan        : 2,
//                 multiSelect    : true, 
//                 typeAhead    : false,
                 listeners: {
                     change: function(field, newValue, oldValue, eOpts) {
                     }
                  }
            },  
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
    //1. 서울
    var masterGrid1 = Unilite.createGrid('hat870skrGrid1', {
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
        }
        features: [ 
            {id: 'masterGrid1SubTotal1'    , ftype: 'uniGroupingsummary'    , showSummaryRow: false},
            {id: 'masterGrid1Total2'    , ftype: 'uniSummary'            , showSummaryRow: false} 
        ],
        columns:  [
            { dataIndex: 'COMP_CODE'        , width: 110    , hidden: true},
            { dataIndex: 'DEPT_CODE'        , width: 110    },
            { dataIndex: 'DEPT_NAME'        , width: 110    },
            { dataIndex: 'SORT_SEQ'        , width: 110    },
            { dataIndex: 'PERSON_NUMB'        , width: 110    },
            { dataIndex: 'POST_NAME'        , width: 90        },
            { dataIndex: 'POST_CODE'        , width: 90        },
            { dataIndex: 'PERSON_NAME'        , width: 90        },
            { dataIndex: 'DUTY_FR_TIME'        , width: 90        },
            { dataIndex: 'DUTY_TO_TIME'        , width: 90        },
            { dataIndex: 'OUT_TIME'        , width: 90        },
            { dataIndex: 'IN_TIME'        , width: 90        },
            { dataIndex: 'DUTY_CODE1'        , width: 90        },
            { dataIndex: 'DUTY_CODE2'        , width: 90        },
            { dataIndex: 'DUTY_CODE3'        , width: 90        },
            { dataIndex: 'DUTY_CODE4'        , width: 90        }

        ] ,
        listeners:{
            uniOnChange: function(grid, dirty, eOpts) {
            }
        }
    });    

    //2. 인천
    var masterGrid2 = Unilite.createGrid('hat870skrGrid2', {
        store    : masterStore2,
        region    : 'center',
        layout    : 'fit',
        uniOpt    : {    
            expandLastColumn    : true,            //마지막 컬럼 * 사용 여부
            useRowNumberer        : true,          //첫번째 컬럼 순번 사용 여부
            useLiveSearch        : true,           //찾기 버튼 사용 여부
            useRowContext        : false,            
            onLoadSelectFirst    : true,
            filter: {                           //필터 사용 여부
                useFilter    : true,
                autoCreate    : true
            }
        },       
        features: [ 
            {id: 'masterGrid1SubTotal2'    , ftype: 'uniGroupingsummary'    , showSummaryRow: false},
            {id: 'masterGrid1Total2'    , ftype: 'uniSummary'            , showSummaryRow: false} 
        ],
        columns:  [
            { dataIndex: 'COMP_CODE'        , width: 110    , hidden: true},
            { dataIndex: 'DEPT_CODE'        , width: 110    },
            { dataIndex: 'DEPT_NAME'        , width: 110    },
            { dataIndex: 'SORT_SEQ'        , width: 110    },
            { dataIndex: 'PERSON_NUMB'        , width: 110    },
            { dataIndex: 'POST_NAME'        , width: 90        },
            { dataIndex: 'POST_CODE'        , width: 90        },
            { dataIndex: 'PERSON_NAME'        , width: 90        },
            { dataIndex: 'DUTY_FR_TIME'        , width: 90        },
            { dataIndex: 'DUTY_TO_TIME'        , width: 90        },
            { dataIndex: 'OUT_TIME'        , width: 90        },
            { dataIndex: 'IN_TIME'        , width: 90        },
            { dataIndex: 'DUTY_CODE1'        , width: 90        },
            { dataIndex: 'DUTY_CODE2'        , width: 90        },
            { dataIndex: 'DUTY_CODE3'        , width: 90        },
            { dataIndex: 'DUTY_CODE4'        , width: 90        }
        ] ,
        listeners:{
            uniOnChange: function(grid, dirty, eOpts) {
            }
        }
    });    

    
    
    
    var tab = Unilite.createTabPanel('hat870skrTab',{        
        region        : 'center',
        activeTab    : 1,				//초기화 시 인천 탭 오픈
        border        : false,
        items        : [{
                title    : '서울',
                xtype    : 'container',
                itemId    : 'hat870skrTab1',
                layout    : {type:'vbox', align:'stretch'},
                items    : [
                    masterGrid1
                ]
            },{
                title    : '인천',
                xtype    : 'container',
                itemId    : 'hat870skrTab2',
                layout    : {type:'vbox', align:'stretch'},
                items:[
                    masterGrid2
                ]
            }
        ],
        listeners:{
            tabchange: function( tabPanel, newCard, oldCard, eOpts )    {
                if(newCard.getItemId() == 'hat870skrTab1')    {
                    
                }else {
                    
                }
            }
        }
    })
 
    
    
    
     Unilite.Main({
        id  : 'hat870skrApp',
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
            panelResult.setValue('DIV_CODE'        , UserInfo.divCode);
            panelResult.setValue('DUTY_DATE'        , UniDate.get('today'));
            
            //초기화 시, 포커스 설정
            panelResult.onLoadSelectText('DUTY_DATE');
            
            //초기화 시 인천 탭 오픈
            tab.setActiveTab(1);
            
            //버튼 설정
            UniAppManager.setToolbarButtons('detail',false);
            UniAppManager.setToolbarButtons('reset',false);
            UniAppManager.setToolbarButtons('save',false);
        },
        
        onQueryButtonDown : function()    {
        	
            masterStore1.claerData;
            masterStore2.claerData; 
        	
            //필수입력값 체크
            if(!this.isValidSearchForm()){
                return false;
            }
            //활성화 된 탭에 따른 조회로직
            var activeTab = tab.getActiveTab().getItemId();
            //1: 서울
            if (activeTab == 'hat870skrTab1'){
                masterStore1.loadStoreRecords();
            //2: 인천
            } else {
                masterStore2.loadStoreRecords();
            }
            
            //초기화 버튼 활성화
            UniAppManager.setToolbarButtons('reset', true);
            
        },                
                
        onResetButtonDown: function() {        
            panelResult.clearForm();
            masterStore1.claerData;
            masterStore2.claerData; 
            masterGrid1.getStore().loadData({});    
            masterGrid2.getStore().loadData({});
            this.fnInitBinding();    
        }
    });
};
</script>
