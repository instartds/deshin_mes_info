<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="axt140skr"  >
    <t:ExtComboStore comboType="BOR120"    pgmId="axt140skr"/>             <!-- 사업장 -->
<t:ExtComboStore comboType="AU" comboCode="B004" />                 <!--화폐단위-->
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
    Unilite.defineModel('Axt140skrModel', {
        fields: [
            {name: 'COMP_CODE'                      ,text:'법잉코드'            ,type:'string'},
            {name: 'SORT_SEQ'                       ,text:'조회구분'            ,type:'int'},
            {name: 'LOANNO'                         ,text:'차입번호'            ,type:'string'},
            {name: 'LOAN_NAME'                      ,text:'차입금명'            ,type:'string'},
            {name: 'ACCNT'                          ,text:'계정과목'            ,type:'string'},
            {name: 'EXCHG_RATE_O'                   ,text:'차입환율'            ,type:'uniER'},
            {name: 'FG_INT'                         ,text:'조건'                  ,type:'string'},
            {name: 'NOW_INT_RATE'                   ,text:'현이율'                 ,type:'uniER'},
            {name: 'INT_RAT'                        ,text:'계약이율'                ,type:'uniER'},
            {name: 'PUB_DAT'                        ,text:'차입일'                 ,type:'string'},
            {name: 'MONEY_UNIT'                     ,text:'화폐단위'         ,type:'string', comboType: 'AU', comboCode: 'B004'},
            {name: 'AMT_I'                          ,text:'차입원화금액= 당초대출금'            ,type:'uniPrice'},
            {name: 'JAN_AMT_I'                      ,text:'잔액'            ,type:'uniPrice'},
            {name: 'SORT_NAME'                      ,text:'계획'            ,type:'string'},
            {name: 'DATA_MON_01'                    ,text:'월일'            ,type:'string'},
            {name: 'DATA_MON_01_P_PRINCIPAL_AMT'    ,text:'상환액'            ,type:'uniPrice'},
            {name: 'DATA_MON_01_JAN_MAT_I'          ,text:'잔액'            ,type:'uniPrice'},
            {name: 'DATA_MON_02'                    ,text:'월일'            ,type:'string'},
            {name: 'DATA_MON_02_P_PRINCIPAL_AMT'    ,text:'상환액'            ,type:'uniPrice'},
            {name: 'DATA_MON_02_JAN_MAT_I'          ,text:'잔액'            ,type:'uniPrice'},
            {name: 'DATA_MON_03'                    ,text:'월일'            ,type:'string'},
            {name: 'DATA_MON_03_P_PRINCIPAL_AMT'    ,text:'상환액'            ,type:'uniPrice'},
            {name: 'DATA_MON_03_JAN_MAT_I'          ,text:'잔액'            ,type:'uniPrice'},
            {name: 'DATA_MON_04'                    ,text:'월일'            ,type:'string'},
            {name: 'DATA_MON_04_P_PRINCIPAL_AMT'    ,text:'상환액'            ,type:'uniPrice'},
            {name: 'DATA_MON_04_JAN_MAT_I'          ,text:'잔액'            ,type:'uniPrice'}
        ]
    });
    
    /**
     * Store 정의(Service 정의)
     * @type 
     */                    
    var directMasterStore1 = Unilite.createStore('axt140skrMasterStore1',{
            model: 'Axt140skrModel',
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
                       read: 'axt140skrService.selectList'                    
                }
            }
            ,loadStoreRecords : function()    {
                var param= Ext.getCmp('panelResultForm').getValues();            
                console.log( param );
                this.load({
                    params : param
                });
                
            },
            listeners: {
            load: function(store, records, successful, eOpts) {
            }
        }
    });
    

    var panelResult = Unilite.createSearchForm('panelResultForm', {
        hidden: !UserInfo.appOption.collapseLeftSearch,
        region: 'north',
        layout : {type : 'uniTable', columns : 3},
        padding:'1 1 1 1',
        border:true,
            items: [{
                    fieldLabel: '기준일',
                    xtype: 'uniDatefield',
                    name: 'STD_YYYYMMDD',
                    labelWidth:90,
                    value: new Date(),
                    allowBlank: false
               },{
                    fieldLabel: '사업장',
                    name:'DIV_CODE', 
                    xtype: 'uniCombobox',
                    comboType:'BOR120'
               }, 
                Unilite.popup('DEBT_NO',{
                        fieldLabel: '차입금',
                        holdable: 'hold',
                        valueFieldName:'DEBT_NO_CODE',
                        textFieldName:'DEBT_NO_NAME',
                        validateBlank:false,
                        autoPopup:true
                })
          ]
    });
    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('axt140skrGrid1', {
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
        columns:  [  
                 { dataIndex: 'COMP_CODE'                , width: 80, hidden: true},
                 { dataIndex: 'SORT_SEQ'                 , width: 80, hidden: true},
                 { dataIndex: 'LOANNO'                   , width: 100},
                 { dataIndex: 'LOAN_NAME'                , width: 200},
                 { dataIndex: 'ACCNT'                    , width: 100},
                 { dataIndex: 'EXCHG_RATE_O'             , width: 100},
                 { dataIndex: 'FG_INT'                   , width: 80, hidden: true},
                 { dataIndex: 'NOW_INT_RATE'             , width: 80},
                 { dataIndex: 'INT_RAT'                  , width: 80},
                 { dataIndex: 'PUB_DAT'                  , width: 80},
                 { dataIndex: 'MONEY_UNIT'               , width: 80},
                 { dataIndex: 'AMT_I'                    , width: 200},
                 { dataIndex: 'JAN_AMT_I'                , width: 80},
                 { dataIndex: 'SORT_NAME'                , width: 80},
                 {text: '2016년 11월',
                     columns:[
                     {dataIndex: 'DATA_MON_01'                                   , width: 100,align:'center',
                    renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
                        return  val.substring(0,4) + '.' + val.substring(4,6);
                    }
                  },
                     {dataIndex: 'DATA_MON_01_P_PRINCIPAL_AMT'               , width: 100 },
                     {dataIndex: 'DATA_MON_01_JAN_MAT_I'                     , width: 100 }
                 ]},
                 {text: '2016년 12월',
                     columns:[
                     {dataIndex: 'DATA_MON_02'                                   , width: 100,align:'center',
                    renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
                        return  val.substring(0,4) + '.' + val.substring(4,6);
                    }
                  },
                     {dataIndex: 'DATA_MON_02_P_PRINCIPAL_AMT'               , width: 100 },
                     {dataIndex: 'DATA_MON_02_JAN_MAT_I'                     , width: 100 }
                 ]},
                 {text: '2017년 1월',
                     columns:[
                     {dataIndex: 'DATA_MON_03'                                   , width: 100,align:'center',
                    renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
                        return  val.substring(0,4) + '.' + val.substring(4,6);
                    }
                  },
                     {dataIndex: 'DATA_MON_03_P_PRINCIPAL_AMT'               , width: 100 },
                     {dataIndex: 'DATA_MON_03_JAN_MAT_I'                     , width: 100 }
                 ]},
                 {text: '2017년 2월',
                     columns:[
                     {dataIndex: 'DATA_MON_04'                                   , width: 100,align:'center',
                    renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
                        return  val.substring(0,4) + '.' + val.substring(4,6);
                    }
                  },
                     {dataIndex: 'DATA_MON_04_P_PRINCIPAL_AMT'               , width: 100 },
                     {dataIndex: 'DATA_MON_04_JAN_MAT_I'                     , width: 100 }
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
        id  : 'axt140skrApp',
        fnInitBinding : function() {
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            panelResult.setValue('STD_YYYYMMDD',UniDate.get('today'));
            
            var activeSForm = panelResult;
            //activeSForm.onLoadSelectText('PERSON_NUMB');
            
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
        },
        onPrintButtonDown: function() {
               
        }
    });
};


</script>
