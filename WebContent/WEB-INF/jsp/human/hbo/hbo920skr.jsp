<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hbo920skr"  >
    <t:ExtComboStore comboType="BOR120"    pgmId="hbo920skr"/>      <!-- 사업장 -->
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
    Unilite.defineModel('Hbo920skrModel', {
        fields: [
            {name: 'COMP_CODE'                ,text:'법인코드'            ,type:'string' },
            {name: 'DEPT_CODE'                ,text:'부서코드'         ,type:'string' },
            {name: 'DEPT_NAME'                ,text:'부서명'            ,type:'string' },
            {name: 'PERSON_NUMB'              ,text:'사번'               ,type:'string' },
            {name: 'PERSON_NAME'              ,text:'사원명'              ,type:'string' },
            {name: 'SPOUSE'                   ,text:'배우자'              ,type:'int' },
            {name: 'SUPP_AGED_NUM'            ,text:'부양자2'             ,type:'int' },
            {name: 'AGED_NUM'                 ,text:'경로자6'             ,type:'int' },
            {name: 'DEFORM_YN'                ,text:'장애인'              ,type:'int' },
            {name: 'AGED_NUM70'               ,text:'경로우대'            ,type:'int' },
            {name: 'WOMAN'                    ,text:'부녀자'              ,type:'int' },
            {name: 'BONUS_I'                  ,text:'상여금액'            ,type:'int' },
            {name: 'BONUS_WAGES_I'            ,text:'상여수당'            ,type:'int' },
            {name: 'BONUS_DED_I1'             ,text:'감봉액'              ,type:'int' },
            {name: 'BONUS_TOT_I'              ,text:'상여총액'            ,type:'int' },
            {name: 'BONUS_DED_I2'             ,text:'상여공제'            ,type:'int' },
            {name: 'INC_AMT'                  ,text:'갑근세'              ,type:'int' },
            {name: 'LOC_AMT'                  ,text:'주민세'              ,type:'int' },
            {name: 'HIR_AMT'                  ,text:'고용보험'            ,type:'int' },
            {name: 'BONUS_DED_TOT'            ,text:'공제합계'            ,type:'int' },
            {name: 'BONUS_REAL_TOT'           ,text:'실지급액'            ,type:'int' }
           
            
        ]
    });
    
    /**
     * Store 정의(Service 정의)
     * @type 
     */                    
    var directMasterStore1 = Unilite.createStore('hbo920skrMasterStore1',{
            model: 'Hbo920skrModel',
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
                       read: 'hbo920skrServiceImpl.selectList'                    
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
                fieldLabel: '지급일자',
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
                    /*onSelected: {
                        fn: function(records, type) {
                            panelResult.setValue('DIV_CODE', records[0].DIV_CODE);
                            panelResult.setValue('DIV_CODE', records[0].DIV_CODE);
                            panelResult.setValue('DIV_CODE', records[0].DIV_CODE);
                            panelResult.setValue('DIV_CODE', records[0].DIV_CODE);
                            panelResult.setValue('DIV_CODE', records[0].DIV_CODE);
                        },
                        scope: this
                    },
                    onClear: function(type)    {
                    },*/
                    onValueFieldChange: function(field, newValue){
                    },
                    onTextFieldChange: function(field, newValue){
                    }
                }
            }),{
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
            {
                fieldLabel  : '관리구분',
                xtype       : 'uniCombobox',
                name        : 'AFFIL_CODE',
                id          : 'AFFIL_CODE',
                comboType   : 'AU',
                comboCode   : 'H173',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {      
                        panelResult.setValue('AFFIL_CODE', newValue);
                    }
                }           
            }
            ]
    });
    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('hbo920skrGrid1', {
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
        columns:  [  { dataIndex: 'COMP_CODE'               , width: 100, hidden:true},                     
                     { dataIndex: 'DEPT_CODE'               , width: 100},
                     { dataIndex: 'DEPT_NAME'               , width: 150},
                     { dataIndex: 'PERSON_NUMB'             , width: 100},
                     { dataIndex: 'PERSON_NAME'             , width: 120},
                     { dataIndex: 'SPOUSE'                  , width: 120},
                     { dataIndex: 'SUPP_AGED_NUM'           , width: 120},
                     { dataIndex: 'AGED_NUM'                , width: 120},
                     { dataIndex: 'DEFORM_YN'               , width: 120},
                     { dataIndex: 'AGED_NUM70'              , width: 120},
                     { dataIndex: 'WOMAN'                   , width: 120},

                     { dataIndex: 'BONUS_I'                 , width: 140},
                     { dataIndex: 'BONUS_WAGES_I'           , width: 140},
                     { dataIndex: 'BONUS_DED_I1'            , width: 140},
                     { dataIndex: 'BONUS_TOT_I'             , width: 140},
                     { dataIndex: 'BONUS_DED_I2'            , width: 140},
                     { dataIndex: 'INC_AMT'                 , width: 140},
                     { dataIndex: 'LOC_AMT'                 , width: 140},
                     { dataIndex: 'HIR_AMT'                 , width: 140}, 
                     { dataIndex: 'BONUS_DED_TOT'           , width: 140},
                     { dataIndex: 'BONUS_REAL_TOT'          , width: 140}
                     
                     
                     
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
        id  : 'hbo920skrApp',
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
