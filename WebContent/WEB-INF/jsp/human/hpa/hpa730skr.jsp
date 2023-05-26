<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hpa730skr"  >
    <t:ExtComboStore comboType="BOR120"    pgmId="hpa730skr"/>      <!-- 사업장 -->
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
    Unilite.defineModel('hpa730skrModel', {
        fields: [
            {name: 'COMP_CODE'                ,text:'법인코드'          ,type:'string' },
            {name: 'PERSON_NUMB'              ,text:'사번'             ,type:'string' },
            {name: 'PERSON_NAME'              ,text:'사원명'            ,type:'string' },
            {name: 'DEPT_CODE'                ,text:'부서코드'          ,type:'string' },
            {name: 'DEPT_NAME'                ,text:'부서명'            ,type:'string' },
            {name: 'POST_CODE'                ,text:'직위코드'          ,type:'string' },
            {name: 'POST_NAME'                ,text:'직위명'            ,type:'string' },
            {name: 'YEAR_NUM'                 ,text:'년차일수'          ,type:'int' },
            {name: 'YEAR_USE'                 ,text:'휴가일(년차사용일)'  ,type:'int' },
            {name: 'YEAR_TOT'                 ,text:'남은일수'          ,type:'int' },
            {name: 'WORK_DAY'                 ,text:'무급휴일수'         ,type:'int' },
            {name: 'FIELD_01'                 ,text:'담당'             ,type:'string' },
            {name: 'FIELD_02'                 ,text:'팀장'             ,type:'string' },
            {name: 'FIELD_03'                 ,text:'부서장'            ,type:'string' },
            {name: 'FIELD_04'                 ,text:'사장'             ,type:'string' }
           
            
        ]
    });
    
    /**
     * Store 정의(Service 정의)
     * @type 
     */                    
    var directMasterStore1 = Unilite.createStore('hpa730skrMasterStore1',{
            model: 'hpa730skrModel',
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
                       read: 'hpa730skrService.selectList'                    
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
                xtype: 'uniYearField',
                name: 'DUTY_YYYY',
                labelWidth:90,
                value: new Date().getFullYear(),
                allowBlank: false,
                listeners: {
                      change: function(field, newValue, oldValue, eOpts) {                                  
                            panelResult.setValue('DUTY_YYYY', newValue);
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
            }),
            Unilite.popup('DEPT', { 
                fieldLabel: '부서', 
                valueFieldName: 'DEPT_CODE',
                textFieldName: 'DEPT_NAME',
//              allowBlank: false,
                holdable: 'hold',
                listeners: {
                    onSelected: {
                        fn: function(records, type) {
                            panelResult.setValue('DEPT_CODE', panelResult.getValue('DEPT_CODE'));
                            panelResult.setValue('DEPT_NAME', panelResult.getValue('DEPT_NAME'));
                        },
                        scope: this
                    },
                    onClear: function(type) {
                        panelResult.setValue('DEPT_CODE', '');
                        panelResult.setValue('DEPT_NAME', '');
                    },
                    applyextparam: function(popup){                         
                        var authoInfo = pgmInfo.authoUser;              //권한정보(N-전체,A-자기사업장>5-자기부서)
                        var deptCode = UserInfo.deptCode;   //부서정보
                        var divCode = '';                   //사업장
                        if(authoInfo == "A"){   //자기사업장 
                            popup.setExtParam({'DEPT_CODE': ""});
                            popup.setExtParam({'DIV_CODE': UserInfo.divCode});
                        }else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){   //전체권한
                            popup.setExtParam({'DEPT_CODE': ""});
                            popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
                        }else if(authoInfo == "5"){     //부서권한
                            popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
                            popup.setExtParam({'DIV_CODE': UserInfo.divCode});
                        }
                    }
                }
            })
            ]
    });
    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('hpa730skrGrid1', {
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
                     { dataIndex: 'PERSON_NUMB'             , width: 100},
                     { dataIndex: 'PERSON_NAME'             , width: 140},
                     { dataIndex: 'DEPT_CODE'               , width: 100},
                     { dataIndex: 'DEPT_NAME'               , width: 150},
                     { dataIndex: 'POST_CODE'               , width: 120},
                     { dataIndex: 'POST_NAME'               , width: 150},
                     { dataIndex: 'YEAR_NUM'                , width: 120},
                     { dataIndex: 'YEAR_USE'                , width: 130},
                     { dataIndex: 'YEAR_TOT'                , width: 120},
                     { dataIndex: 'WORK_DAY'                , width: 120},
                     { dataIndex: 'FIELD_01'                , width: 140},
                     { dataIndex: 'FIELD_02'                , width: 140},
                     { dataIndex: 'FIELD_03'                , width: 140},
                     { dataIndex: 'FIELD_04'                , width: 140}
                     
                     
                     
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
        id  : 'hpa730skrApp',
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
