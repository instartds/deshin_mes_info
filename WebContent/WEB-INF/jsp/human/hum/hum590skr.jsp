<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hum590skr">
    <t:ExtComboStore comboType="BOR120"  />                             <!-- 사업장 -->    
    <t:ExtComboStore comboType="AU" comboCode="H005" />                    <!-- 직위 -->
    <t:ExtComboStore comboType="AU" comboCode="H006" />                    <!-- 직책 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {

    /** Model 정의 
     * @type 
     */
    Unilite.defineModel('hum590skrModel', {
        fields: [
            {name: 'COMP_CODE'          ,text: 'COMP_CODE'           ,type: 'string'},
            {name: 'PERSON_NUMB'        ,text: '사원번호'            ,type: 'string'},
            {name: 'PERSON_NAME'        ,text: '성명'                ,type: 'string'},
            {name: 'POST_CODE'          ,text: '직위'                ,type: 'string'        , comboType: "AU"    , comboCode: "H005"},
            {name: 'DEPT_CODE'          ,text: '부서코드'            ,type: 'string'},
            {name: 'DEPT_NAME'          ,text: '부서명'              ,type: 'string'},
            {name: 'ABIL_CODE'          ,text: '직종'                ,type: 'string'        , comboType: "AU"    , comboCode: "H006"},
            {name: 'REPRE_NUM'          ,text: '주민등록번호'        ,type: 'string'        , defaultValue:'***************'},
            {name: 'EXPIRY_DATE'        ,text: '정년만기일'          ,type: 'uniDate'},
            {name: 'AGE'                ,text: '년령'                ,type: 'uniNumber'},
            {name: 'REMAIN'             ,text: '잔여일'              ,type: 'string'},
            {name: 'REMARK'             ,text: '비고'                ,type: 'string'}
        ]
    });
    
    
    
    
    /** Store 정의(Service 정의)
     * @type 
     */                    
    var masterStore = Unilite.createStore('hum590skrMasterStore1',{
        model    : 'hum590skrModel',
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
                    read: 'hum590skrService.selectList'
            }
        },
        loadStoreRecords : function()    {
            var param= Ext.getCmp('panelResultForm').getValues();
            console.log( param );
            this.load({
                params : param
            });
        },
        listeners: {
            load: function(store, records, successful, eOpts) {
                var count = masterGrid.getStore().getCount();  
                if(count > 0){
                    //UniAppManager.setToolbarButtons(['print'], true);
                }else{
                    //UniAppManager.setToolbarButtons(['print'], false);
                }

            }
        }
    });
    
    
    
    
    var panelResult = Unilite.createSearchForm('panelResultForm', {
        region    : 'north',
        layout    : {type : 'uniTable', columns : 2
//        , tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/}
//        , tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
        },
        padding    : '1 1 1 1',
        border    : true,
        items    : [{
                fieldLabel    : '기준일',    
                name        : 'ST_DATE', 
                xtype        : 'uniDatefield',                
                value        : new Date(),                
                allowBlank    : false,          
                tdAttrs        : {width: 380} 
            },{
                fieldLabel    : '사업장',
                name        : 'DIV_CODE', 
                xtype        : 'uniCombobox',
                comboType    : 'BOR120',
                value        : UserInfo.divCode,
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
    var masterGrid = Unilite.createGrid('hum590skrGrid1', {
        store    : masterStore,
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
            {id: 'masterGridSubTotal'    , ftype: 'uniGroupingsummary'    , showSummaryRow: false},
            {id: 'masterGridTotal'        , ftype: 'uniSummary'            , showSummaryRow: false} 
        ],
        columns:  [
            { dataIndex: 'COMP_CODE'        , width: 110    , hidden: true},
            { dataIndex: 'PERSON_NUMB'        , width: 110    },
            { dataIndex: 'PERSON_NAME'        , width: 110    },
            { dataIndex: 'POST_CODE'        , width: 100    },
            { dataIndex: 'DEPT_CODE'        , width: 110    },
            { dataIndex: 'DEPT_NAME'        , width: 110    },
            { dataIndex: 'ABIL_CODE'        , width: 100    },
            { dataIndex: 'REPRE_NUM'        , width: 120    },
            { dataIndex: 'EXPIRY_DATE'        , width: 100    },
            { dataIndex: 'AGE'                , width: 90        },
            { dataIndex: 'REMAIN'            , width: 90        },
            { dataIndex: 'REMARK'            , width: 200    }
        ] ,
        listeners:{
            uniOnChange: function(grid, dirty, eOpts) {
            }
        }
    });    
 
    
    
    
    Unilite.Main({
        id  : 'hum590skrApp',
        borderItems:[{
          region:'center',
          layout: {type: 'vbox', align: 'stretch'},
          border: false,
          items:[
                panelResult, masterGrid 
          ]}
        ], 
        fnInitBinding : function() {
            //초기값 설정
            panelResult.setValue('ST_DATE'        , new Date());
            panelResult.setValue('DIV_CODE'        , UserInfo.divCode);
            //초기화 시, 포커스 설정
            panelResult.onLoadSelectText('ST_DATE');
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
            
            masterStore.loadStoreRecords();
            //초기화 버튼 활성화
            UniAppManager.setToolbarButtons('reset', true);
        },                
                
        onResetButtonDown: function() {        
            panelResult.clearForm();
            masterGrid.getStore().loadData({});    
            this.fnInitBinding();    
        }
    });
};


</script>