<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hpa720skr"  >
    <t:ExtComboStore comboType="BOR120"    pgmId="hpa720skr"/>             <!-- 사업장 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {
    
    /**
     *   Model 정의 
     * @type 
     */
    Unilite.defineModel('Hpa720skrModel', {
        fields: [
            {name: 'COMP_CODE'                ,text:'법인코드'          ,type:'string' },
            {name: 'PERSON_NUMB'              ,text:'사번'             ,type:'string' },
            {name: 'SORT_SEQ'                 ,text:'정렬순서'          ,type:'string' },
            {name: 'PERSON_NAME'              ,text:'사원명'           ,type:'string' },
            {name: 'FIELD_01'                 ,text:'1월'             ,type:'int' },
            {name: 'FIELD_02'                 ,text:'2월'             ,type:'int' },
            {name: 'FIELD_03'                 ,text:'3월'             ,type:'int' },
            {name: 'FIELD_04'                 ,text:'4월'             ,type:'int' },
            {name: 'FIELD_05'                 ,text:'5월'             ,type:'int' },
            {name: 'FIELD_06'                 ,text:'6월'             ,type:'int' },
            {name: 'FIELD_07'                 ,text:'7월'             ,type:'int' },
            {name: 'FIELD_08'                 ,text:'8월'             ,type:'int' }, 
            {name: 'FIELD_09'                 ,text:'9월'             ,type:'int' }, 
            {name: 'FIELD_10'                 ,text:'10월'            ,type:'int' }, 
            {name: 'FIELD_11'                 ,text:'11월'            ,type:'int' }, 
            {name: 'FIELD_12'                 ,text:'12월'            ,type:'int' },
            {name: 'WORK_DAY'                 ,text:'결근계'           ,type:'int' },
            {name: 'WORK_YEAR'                ,text:'근속년수'          ,type:'int' },
            {name: 'YEAR_NUM'                 ,text:'연차일수'          ,type:'int' },
            {name: 'YEAR_USE'                 ,text:'휴가일수'          ,type:'int' },
            {name: 'YEAR_TOT'                 ,text:'지급일수'          ,type:'int' },
            {name: 'DAY_AMOUNT_I'             ,text:'일급'             ,type:'int' },
            {name: 'AMOUNT_I'                 ,text:'지급액'            ,type:'int' },
            {name: 'REMARK'                   ,text:'확인'              ,type:'string' }
            
            
        ]
    });
    
    /**
     * Store 정의(Service 정의)
     * @type 
     */                    
    var directMasterStore1 = Unilite.createStore('hpa720skrMasterStore1',{
            model: 'Hpa720skrModel',
            uniOpt : {
                isMaster: true,            // 상위 버튼 연결 
                editable: false,            // 수정 모드 사용 
                deletable:false,            // 삭제 가능 여부 
                useNavi : false            // prev | newxt 버튼 사용
               
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {            
                       read: 'hpa720skrService.selectList'                    
                }
            }
            ,loadStoreRecords : function()    {
                var param= Ext.getCmp('panelResultForm').getValues();            
                console.log( param );
                this.load({
                    params : param
                });
                
            }
    });
    
    var panelResult = Unilite.createSearchForm('panelResultForm', {
        hidden: !UserInfo.appOption.collapseLeftSearch,
        region: 'north',
        layout : {type : 'uniTable', columns : 2},
        padding:'1 1 1 1',
        border:true,
            items: [{
                fieldLabel: '년도', 
                fieldStyle: "text-align:center;",
                value : new Date().getFullYear(),
                name:'YEAR_YYYY', 
                xtype: 'uniYearField', 
                allowBlank:false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelResult.setValue('YEAR_YYYY', newValue);
                    }
                }
            },{
                fieldLabel: '사업장',
                name:'DIV_CODE', 
                xtype: 'uniCombobox',
                typeAhead: false,
                comboType:'BOR120',
                width: 325,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                    }
                }
            },Unilite.popup('Employee',{
                fieldLabel      : '사원',
                valueFieldName  : 'PERSON_NUMB',
                textFieldName   : 'NAME',
                validateBlank   : false,
                autoPopup       : true,
                listeners       : {
                    onSelected: {
                        fn: function(records, type) {
                        },
                        scope: this
                    },
                    onClear: function(type) {
                    },
                    onValueFieldChange: function(field, newValue){
                    },
                    onTextFieldChange: function(field, newValue){
                    }
                }
            }),  
            Unilite.popup('DEPT',{
                fieldLabel      : '부서',
                valueFieldName  : 'DEPT_CODE',
                textFieldName   : 'DEPT_NAME',
                validateBlank   : false,                    
                tdAttrs         : {width: 380},  
                listeners       : {
                    onSelected: {
                        fn: function(records, type) {
//                          dataForm.setValue('S_DEPT_CODE', records[0].DEPT_CODE);
                        },
                        scope: this
                    },
                    onClear: function(type) {
                    },
                    onValueFieldChange: function(field, newValue){
                    },
                    onTextFieldChange: function(field, newValue){
                    }
                }
            })]
    });
    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('hpa720skrGrid1', {
        region: 'center',
        layout: 'fit',
        uniOpt:{    
            expandLastColumn: false,    //마지막 컬럼 * 사용 여부
            useRowNumberer: true,        //첫번째 컬럼 순번 사용 여부
            useLiveSearch: true,        //찾기 버튼 사용 여부
            useRowContext: false,            
            onLoadSelectFirst    : true,
            filter: {                    //필터 사용 여부
                useFilter: true,
                autoCreate: true
            }
        },
         
        features: [ 
            {id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
            {id: 'masterGridTotal',    ftype: 'uniSummary',         showSummaryRow: false} 
        ],
        store: directMasterStore1,
        columns:  [  { dataIndex: 'COMP_CODE'                 , width: 77, hidden:true},                     
                     { dataIndex: 'PERSON_NUMB'               , width: 100},
                     { dataIndex: 'SORT_SEQ'                  , width: 88, hidden:true},
                     { dataIndex: 'PERSON_NAME'               , width: 100},
                     {text:'월별 결근 일수(월 근무일수)',
                        columns:[ 
                                 { dataIndex: 'FIELD_01'                , width: 80},
                                 { dataIndex: 'FIELD_02'                , width: 80},
                                 { dataIndex: 'FIELD_03'                , width: 80},
                                 { dataIndex: 'FIELD_04'                , width: 80},
                                 { dataIndex: 'FIELD_05'                , width: 80},
                                 { dataIndex: 'FIELD_06'                , width: 80},
                                 { dataIndex: 'FIELD_07'                , width: 80},
                                 { dataIndex: 'FIELD_08'                , width: 80},
                                 { dataIndex: 'FIELD_09'                , width: 80},
                                 { dataIndex: 'FIELD_10'                , width: 80},
                                 { dataIndex: 'FIELD_11'                , width: 80},
                                 { dataIndex: 'FIELD_12'                , width: 80},
                                 { dataIndex: 'WORK_DAY'                , width: 100},
                                 { dataIndex: 'WORK_YEAR'               , width: 100},
                                 { dataIndex: 'YEAR_NUM'                , width: 100},
                                 { dataIndex: 'YEAR_USE'                , width: 100},
                                 { dataIndex: 'YEAR_TOT'                , width: 100},
                                 { dataIndex: 'DAY_AMOUNT_I'            , width: 100},
                                 { dataIndex: 'AMOUNT_I'                , width: 100},
                                 { dataIndex: 'REMARK'                  , width: 150}
                     ]}
                     
        ] 
    });   
    
    Unilite.Main({
        borderItems:[{
         region:'center',
         layout: 'border',
         border: false,
         items:[
                masterGrid, panelResult
             ]
         }
        ], 
        id  : 'hpa720skrApp',
        fnInitBinding : function() {
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            
            UniAppManager.setToolbarButtons('detail',false);
            UniAppManager.setToolbarButtons('reset',false);
            UniAppManager.setToolbarButtons('save',false);
        },
        onQueryButtonDown : function()    {
            if(!this.isValidSearchForm()){
                return false;
            }
            masterGrid.getStore().loadStoreRecords();
            
            var viewLocked = masterGrid.getView();
            var viewNormal = masterGrid.getView();
            console.log("viewLocked : ",viewLocked);
            console.log("viewNormal : ",viewNormal);
            viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(false);
            viewLocked.getFeature('masterGridTotal').toggleSummaryRow(false);
            viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(false);
            viewNormal.getFeature('masterGridTotal').toggleSummaryRow(false);
        },
        onResetButtonDown:function() {
            panelResult.clearForm();
            masterGrid.getStore().loadData({});
            
            this.fnInitBinding();
        }
    });
};


</script>