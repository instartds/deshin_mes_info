<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="axt170skr"  >
    <t:ExtComboStore comboType="BOR120"    pgmId="axt170skr"/>             <!-- 사업장 -->
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
    Unilite.defineModel('Axt170skrModel', {
        fields: [
            {name: 'COMP_CODE'              ,text:'법인코드'        ,type:'string'},
            {name: 'REG_DATE'               ,text:'월일'          ,type:'string' },
            {name: 'AMT_01'              ,text:'입금'            ,type:'uniPrice'},
            {name: 'AMT_02'              ,text:'출금'            ,type:'uniPrice'},
            {name: 'AMT_03'                   ,text:'보통예금계'            ,type:'uniPrice'},
            {name: 'AMT_05'            ,text:'현금계'            ,type:'uniPrice'},
            {name: 'AMT_11'              ,text:'받을어음수금'            ,type:'uniPrice'},
            {name: 'AMT_12'              ,text:'받을어음당좌'            ,type:'uniPrice'},
            {name: 'AMT_13'                   ,text:'받을어음결재'            ,type:'uniPrice'},
            {name: 'AMT_16'            ,text:'총자금합계'            ,type:'uniPrice'},
            {name: 'AMT_11'               ,text:'발행금액'            ,type:'uniPrice'},
            {name: 'AMT_12'        ,text:'결재금액'    ,type:'uniPrice'},
            {name: 'AMT_13'        ,text:'잔액'    ,type:'uniPrice'},
            {name: 'AMT_21'        ,text:'현금입금'    ,type:'uniPrice'},
            {name: 'AMT_22'        ,text:'받을어음입금'    ,type:'uniPrice'},
            {name: 'AMT_23'        ,text:'당좌발행지급'    ,type:'uniPrice'},
            {name: 'AMT_24'        ,text:'지급어음결재'    ,type:'uniPrice'},
            {name: 'AMT_25'        ,text:'출금대체'    ,type:'uniPrice'},
            {name: 'AMT_26'        ,text:'은행잔고'    ,type:'uniPrice'},
            {name: 'AMT_27'        ,text:'회사잔고'    ,type:'uniPrice'}
        ]
    });
    
    /**
     * Store 정의(Service 정의)
     * @type 
     */                    
    var directMasterStore1 = Unilite.createStore('axt170skrMasterStore1',{
            model: 'Axt170skrModel',
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
                       read: 'axt170skrService.selectList'                    
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
            items: [/*{
                    fieldLabel        : '조회기간',
                    xtype             : 'uniDateRangefield',
                    startFieldName    : 'FR_DATE',
                    endFieldName      : 'TO_DATE',
                    startDate         : UniDate.get('startOfMonth'),
                    endDate           : UniDate.get('today'),
                    allowBlank        : false,          
                    tdAttrs           : {width: 350},
                    width             : 315,
                    onStartDateChange: function(field, newValue, oldValue, eOpts) {
                    },
                    onEndDateChange: function(field, newValue, oldValue, eOpts) {
                    }
              },*/
              	{
	                fieldLabel: '기준 월',
	                xtype: 'uniMonthfield',
	                name: 'ST_DATE',
	                labelWidth:90,
	                value: new Date(),
	                allowBlank: false,
	                listeners: {
	                      change: function(field, newValue, oldValue, eOpts) {                                  
	                            panelResult.setValue('ST_DATE', newValue);
	                      }
	                }
	           },
              {
                    fieldLabel: '사업장',
                    name:'DIV_CODE', 
                    xtype: 'uniCombobox',
//                  multiSelect: true, 
                    typeAhead: false,
                    comboType:'BOR120',
                    width: 325,
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                        }
                    }
                }
            ]
    });
    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('axt170skrGrid1', {
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
                 {dataIndex: 'REG_DATE'               , width: 80},
                 {text: '현금내역',
                     columns:[
                     {dataIndex: 'AMT_01'                   , width: 100 },
                     {dataIndex: 'AMT_02'               , width: 100 },
                     {dataIndex: 'AMT_03'               , width: 100 },
                     {dataIndex: 'AMT_05'               , width: 100 }
                 ]},
                 {text: '받을어음',
                     columns:[
                      {dataIndex: 'AMT_11'                   , width: 100 },
                      {dataIndex: 'AMT_12'               , width: 100 },
                      {dataIndex: 'AMT_13'               , width: 100 }
                 ]},
                 { dataIndex: 'AMT_16'               , width: 120},
                 {text: '지급어음',
                     columns:[
                      {dataIndex: 'AMT_11'                   , width: 100 },
                      {dataIndex: 'AMT_12'               , width: 100 },
                      {dataIndex: 'AMT_13'               , width: 100 }
                 ]},
                 {text: '당좌예금',
                     columns:[
                      {dataIndex: 'AMT_21'                   , width: 100 },
                      {dataIndex: 'AMT_22'               , width: 100 },
                      {dataIndex: 'AMT_23'               , width: 100 },
                      {dataIndex: 'AMT_24'               , width: 100 },
                      {dataIndex: 'AMT_25'               , width: 100 },
                      {dataIndex: 'AMT_26'               , width: 100 },
                      {dataIndex: 'AMT_27'               , width: 100 }
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
        id  : 'axt170skrApp',
        fnInitBinding : function() {
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            
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
