<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hum910skr"  >
    <t:ExtComboStore comboType="BOR120"    pgmId="hum910skr"/>             <!-- 사업장 -->
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
    Unilite.defineModel('Hum910skrModel', {
        fields: [
            {name: 'COMP_CODE'                ,text:'법인코드'             ,type:'string' },
            {name: 'DEPT_CODE'                ,text:'부서코드'             ,type:'string' },
            {name: 'DEPT_NAME'                ,text:'부서'                ,type:'string' },
            {name: 'PERSON_NUMB'              ,text:'사원번호'             ,type:'string' },
            {name: 'PERSON_NAME'              ,text:'성명'                ,type:'string' },
            {name: 'OUT_FROM_DATE'            ,text:'출발일자'             ,type:'string' },
            {name: 'OUT_TO_DATE'              ,text:'귀국일자'             ,type:'string' },
            {name: 'TERM'                     ,text:'기간'                ,type:'int' },
            {name: 'NATION'                   ,text:'출장지'              ,type:'string' },
            {name: 'PURPOSE'                  ,text:'목적'                ,type:'string' },
            {name: 'REMARK'                   ,text:'비고'                ,type:'string' }
            
        ]
    });
    
    /**
     * Store 정의(Service 정의)
     * @type 
     */                    
    var directMasterStore1 = Unilite.createStore('hum910skrMasterStore1',{
            model: 'Hum910skrModel',
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
                       read: 'hum910skrService.selectList'                    
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
        layout : {type : 'uniTable', columns : 3},
        padding:'1 1 1 1',
        border:true,
            items: [{ 
                fieldLabel      : '출장일',
                xtype           : 'uniDateRangefield',
                startFieldName  : 'OUT_FR_DATE',
                endFieldName    : 'OUT_TO_DATE',
                startDate       : UniDate.get('startOfMonth'),
                endDate         : UniDate.get('today'),
                allowBlank      : false,        
                tdAttrs         : {width: 350}, 
                width           : 315,
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                },
                onEndDateChange: function(field, newValue, oldValue, eOpts) {
                }
            },
            {
                fieldLabel: '사업장',
                name:'DIV_CODE', 
                xtype: 'uniCombobox',
                typeAhead: false,
                comboType:'BOR120',
                width: 300,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                    }
                }
            },
            Unilite.popup('Employee',{
                fieldLabel: '사원',
                valueFieldName:'PERSON_NUMB',
                textFieldName:'NAME',
                colspan:2,
                validateBlank:false,
                autoPopup:true,
                listeners: {
                    onSelected: {
                        fn: function(records, type) {
                            panelResult.setValue('DIV_CODE', records[0].DIV_CODE);
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
    var masterGrid = Unilite.createGrid('hum910skrGrid1', {
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
                     { dataIndex: 'DEPT_CODE'                 , width: 90},
                     { dataIndex: 'DEPT_NAME'                 , width: 130},
                     { dataIndex: 'PERSON_NUMB'               , width: 90},
                     { dataIndex: 'PERSON_NAME'               , width: 90},
                     { dataIndex: 'OUT_FROM_DATE'             , width: 130},
                     { dataIndex: 'OUT_TO_DATE'               , width: 130},
                     { dataIndex: 'TERM'                      , width: 100},
                     { dataIndex: 'NATION'                    , width: 130},
                     { dataIndex: 'PURPOSE'                   , width: 250},
                     { dataIndex: 'REMARK'                    , width: 250}
                     
                     
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
        id  : 'hum910skrApp',
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
