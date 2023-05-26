<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hbo910skr"  >
    <t:ExtComboStore comboType="BOR120"    pgmId="hbo910skr"/>             <!-- 사업장 -->
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
    Unilite.defineModel('Hbo910skrModel', {
        fields: [
            {name: 'COMP_CODE'                ,text:'법인코드'            ,type:'string' },
            {name: 'DEPT_NAME'                ,text:'부서'                ,type:'string' },
            {name: 'DEPT_CODE'                ,text:'부서코드'            ,type:'string' },
            {name: 'AAA'                     ,text:'인원'                ,type:'int' },
            {name: 'BBB'              ,text:'상여금액'                ,type:'int' },
            {name: 'CCC'               ,text:'상여수당'                ,type:'int' },
            {name: 'DDD'                ,text:'상여총액'                ,type:'int' },
            {name: 'EEE'                ,text:'상여공제'                ,type:'int' },
            {name: 'FFF'                ,text:'소득세'                ,type:'int' },
            {name: 'GGG'                ,text:'주민세'                ,type:'int' },
            {name: 'HHH'                ,text:'고용보험'                ,type:'int' },
            {name: 'III'                ,text:'공제합계'                ,type:'int' },
            {name: 'JJJ'                ,text:'실지급액'                ,type:'int' },
            
        ]
    });
    
    /**
     * Store 정의(Service 정의)
     * @type 
     */                    
    var directMasterStore1 = Unilite.createStore('hbo910skrMasterStore1',{
            model: 'Hbo910skrModel',
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
                       read: 'hbo910skrServiceImpl.selectList'                    
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
                multiSelect: true, 
                typeAhead: false,
                comboType:'BOR120',
                width: 325,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                    }
                }
            },
            Unilite.treePopup('DEPTTREE',{
                fieldLabel: '부서',
                valueFieldName:'DEPT',
                textFieldName:'DEPT_NAME' ,
                valuesName:'DEPTS' ,
                DBvalueFieldName:'TREE_CODE',
                DBtextFieldName:'TREE_NAME',
                selectChildren:true,
                textFieldWidth:150,
                validateBlank:true,
                width:300,
                autoPopup:true,
                useLike:true,
                colspan:2,
                listeners: {
                    'onValueFieldChange': function(field, newValue, oldValue  ){
                    },
                    'onTextFieldChange':  function( field, newValue, oldValue  ){
                    },
                    'onValuesChange':  function( field, records){
                    }
                }
            })]
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
        columns:  [  { dataIndex: 'DEPT_CODE'                 , width: 77},                     
                     { dataIndex: 'DEPT_NAME'               , width: 160},

                     { dataIndex: 'AAA'                    , width: 88},
                     { dataIndex: 'BBB'                , width: 77},
                     { dataIndex: 'CCC'                , width: 150},
                     { dataIndex: 'DDD'                , width: 133},
                     { dataIndex: 'EEE'                , width: 100},
                     { dataIndex: 'FFF'                , width: 110},
                     { dataIndex: 'GGG'                , width: 110},
                     { dataIndex: 'HHH'                , width: 88},
                     { dataIndex: 'III'                , width: 88},
                     { dataIndex: 'JJJ'                , width: 88}
                     
                     
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