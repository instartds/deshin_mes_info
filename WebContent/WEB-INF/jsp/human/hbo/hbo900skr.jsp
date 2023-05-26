<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hbo900skr"  >
    <t:ExtComboStore comboType="BOR120"    pgmId="hbo900skr"/>      <!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="H032" />             <!-- 상여구분 -->
    <t:ExtComboStore comboType="AU" comboCode="H173" />             <!-- 관리구분 --> 
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
    Unilite.defineModel('Hbo900skrModel', {
        fields: [
            {name: 'COMP_CODE'               ,text:'법인코드'            ,type:'string' },
            {name: 'PERSON_NUMB'             ,text:'사번          '         ,type:'string' },
            {name: 'PERSON_NAME'             ,text:'사원명'            ,type:'string' },
            {name: 'AMT_01'                  ,text:'1월'               ,type:'int' },
            {name: 'AMT_02'                  ,text:'2월'               ,type:'int' },
            {name: 'AMT_03'                  ,text:'3월'               ,type:'int' },
            {name: 'AMT_04'                  ,text:'4월'               ,type:'int' },
            {name: 'AMT_05'                  ,text:'5월'               ,type:'int' },
            {name: 'AMT_06'                  ,text:'6월'               ,type:'int' },
            {name: 'AMT_07'                  ,text:'7월'               ,type:'int' },
            {name: 'AMT_08'                  ,text:'8월'               ,type:'int' },
            {name: 'AMT_09'                  ,text:'9월'               ,type:'int' },
            {name: 'AMT_10'                  ,text:'10월'              ,type:'int' },
            {name: 'AMT_11'                  ,text:'11월'              ,type:'int' },
            {name: 'AMT_TOT'                 ,text:'총합계'             ,type:'int' },
            {name: 'AMT_TOT_AVG'             ,text:'평균기본급'          ,type:'int' },
            {name: 'DUTY_21'                 ,text:'결근계'             ,type:'int' },
            {name: 'DUTY_06'                 ,text:'지조외계'            ,type:'int' },
            {name: 'SUPP_RATE'               ,text:'감율(%)'            ,type:'int' },
            {name: 'BONUS_TAX_I'             ,text:'상여금액'            ,type:'int' }
            
        ]
    });
    
    /**
     * Store 정의(Service 정의)
     * @type 
     */                    
    var directMasterStore1 = Unilite.createStore('hbo910skrMasterStore1',{
            model: 'Hbo900skrModel',
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
                       read: 'hbo900skrServiceImpl.selectList'                    
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
                fieldLabel: '기준일자',
                xtype: 'uniDatefield',
                name: 'DUTY_YYYYMMDD',
                labelWidth:90,
                value: new Date(),
                allowBlank: false,
                listeners: {
                      change: function(field, newValue, oldValue, eOpts) {                                  
                            panelResult.setValue('DUTY_YYYYMMDD', newValue);
                      }
                }
           },
           {
                fieldLabel: '사업장',
                name:'DIV_CODE', 
                xtype: 'uniCombobox',
                typeAhead: false,
                comboType:'BOR120',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                    }
                }
            },
            
            {
                fieldLabel  : '상여구분',
                xtype       : 'uniCombobox',
                name        : 'SUPP_TYPE',
                id          : 'SUPP_TYPE',
                comboType   : 'AU',
                comboCode   : 'H032',
                allowBlank  : false ,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {      
                        panelResult.setValue('SUPP_TYPE', newValue);
                    }
                }           
            },
            
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
            }),
            
            Unilite.popup('Employee',{
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
            })
            
            ]
    });
    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('hbo910skrGrid1', {
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
        columns:  [  { dataIndex: 'COMP_CODE'               , width: 77, hidden:true},                     
                     { dataIndex: 'PERSON_NUMB'               , width: 100},
                     { dataIndex: 'PERSON_NAME'               , width: 150},

                     { dataIndex: 'AMT_01'             , width: 140},
                     { dataIndex: 'AMT_02'             , width: 140},
                     { dataIndex: 'AMT_03'             , width: 140},
                     { dataIndex: 'AMT_04'             , width: 140},
                     { dataIndex: 'AMT_05'             , width: 140},
                     { dataIndex: 'AMT_06'             , width: 140},
                     { dataIndex: 'AMT_07'             , width: 140},
                     { dataIndex: 'AMT_08'             , width: 140},
                     { dataIndex: 'AMT_09'             , width: 140},
                     { dataIndex: 'AMT_10'                , width: 140},
                     { dataIndex: 'AMT_11'          , width: 140},
                     { dataIndex: 'AMT_TOT'            , width: 140},
                     { dataIndex: 'AMT_TOT_AVG'            , width: 140},
                     { dataIndex: 'DUTY_21'                , width: 140},
                     { dataIndex: 'DUTY_06'                , width: 140},
                     { dataIndex: 'SUPP_RATE'                , width: 140},
                     { dataIndex: 'BONUS_TAX_I'          , width: 140}
                     
                     
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
        id  : 'hbo910skrApp',
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
