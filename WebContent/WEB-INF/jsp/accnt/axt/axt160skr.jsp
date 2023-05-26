<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="axt160skr"  >
    <t:ExtComboStore comboType="BOR120"    pgmId="axt160skr"/>             <!-- 사업장 -->
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
    Unilite.defineModel('Axt160skrModel', {
        fields: [
            {name: 'COMP_CODE'              ,text:'법인코드'          ,type:'string'},
            {name: 'REG_DATE'               ,text:'일자'              ,type:'string' },
            {name: 'AMT_01'                 ,text:'현금'              ,type:'int'},
            {name: 'AMT_02'                 ,text:'어음'              ,type:'int'},
            {name: 'AMT_03'                 ,text:'합계'              ,type:'int'},
            {name: 'AMT_04'                 ,text:'누계'              ,type:'int'},
            {name: 'AMT_05'                 ,text:'현금'              ,type:'int'},
            {name: 'AMT_06'                 ,text:'어음'              ,type:'int'},
            {name: 'AMT_07'                 ,text:'합계'              ,type:'int'},
            {name: 'AMT_08'                 ,text:'누계'              ,type:'int'},
            {name: 'REMARK_01'              ,text:'확인담당'          ,type:'string'},
            {name: 'REMARK_02'              ,text:'결재이사/사장'     ,type:'string'}
        ]           
    });
    
    /**
     * Store 정의(Service 정의)
     * @type 
     */                    
    var directMasterStore1 = Unilite.createStore('axt160skrMasterStore1',{
            model: 'Axt160skrModel',
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
                       read: 'axt160skrService.selectList'                    
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
                    fieldLabel        : '조회기간',
                    xtype             : 'uniMonthRangefield',
                    startFieldName    : 'FR_DATE',
                    endFieldName      : 'TO_DATE',
                    startDate         : UniDate.get('startOfMonth'),
                    endDate           : UniDate.get('today'),
                    allowBlank        : false        
              },
              {
                    fieldLabel: '사업장',
                    name:'DIV_CODE', 
                    xtype: 'uniCombobox',
                    comboType:'BOR120'
                }
            ]
    });
    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('axt160skrGrid1', {
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
                 { dataIndex: 'REG_DATE'               , width: 80, align:'center'},
                 {text: '입금내역',
                     columns:[
                     {dataIndex: 'AMT_01'               , width: 100 },
                     {dataIndex: 'AMT_02'               , width: 100 },
                     {dataIndex: 'AMT_03'               , width: 100 },
                     {dataIndex: 'AMT_04'               , width: 100 }
                 ]},
                 {text: '출금내역',
                     columns:[
                      {dataIndex: 'AMT_05'              , width: 100 },
                      {dataIndex: 'AMT_06'              , width: 100 },
                      {dataIndex: 'AMT_07'              , width: 100 },
                      {dataIndex: 'AMT_08'              , width: 100 }
                 ]},
                 { dataIndex: 'REMARK_01'               , width: 120},
                 { dataIndex: 'REMARK_02'               , width: 120}
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
        id  : 'axt160skrApp',
        fnInitBinding : function() {
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            panelResult.setValue('FR_DATE', UniDate.get('startOfMonth'));
            panelResult.setValue('TO_DATE', UniDate.get('today'));
            
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
