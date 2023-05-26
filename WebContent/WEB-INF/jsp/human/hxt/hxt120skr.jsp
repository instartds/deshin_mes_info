<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hxt120skr"  >
    <t:ExtComboStore comboType="BOR120"    pgmId="hxt120skr"/>             <!-- 사업장 -->
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
    Unilite.defineModel('Hxt120skrModel', {
        fields: [
            {name: 'COMP_CODE'                ,text:'법인코드'            ,type:'string' },
            {name: 'AAA'                 ,text:'순서'                ,type:'string' },
            {name: 'DEPT_NAME'                ,text:'부서'                ,type:'string' },
            {name: 'DEPT_CODE'                ,text:'부서코드'            ,type:'string' },
            {name: 'BBB'                ,text:'사원번호'            ,type:'string' },
            {name: 'CCC'                ,text:'직책'            ,type:'string' },
            {name: 'DDD'                ,text:'성명'            ,type:'string' },
            {name: 'EEE'                ,text:'주민번호'            ,type:'string' },
            {name: 'FFF'              ,text:'금액'                ,type:'int' },
            {name: 'GGG'               ,text:'성금'                ,type:'int' },
            {name: 'BIGO'               ,text:'비고'                ,type:'string' }
            
        ]
    });
    
    /**
     * Store 정의(Service 정의)
     * @type 
     */                    
    var directMasterStore1 = Unilite.createStore('hxt120skrMasterStore1',{
            model: 'Hxt120skrModel',
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
                       read: 'hxt120skrServiceImpl.selectList'                    
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
                fieldLabel: '기준년도',
                name:'ANN_DATE', 
                xtype: 'uniYearField', 
                allowBlank:false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {      
                    }
                }
            },{
                fieldLabel: '사업장',
                name:'DIV_CODE', 
                xtype: 'uniCombobox',
                comboType:'BOR120',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                    }
                }
            },
            Unilite.popup('Employee',{
                fieldLabel: '사원',
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
            Unilite.treePopup('DEPTTREE',{
                fieldLabel: '부서',
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
    var masterGrid = Unilite.createGrid('hxt120skrGrid1', {
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
        columns:  [  { dataIndex: 'AAA'                 , width: 77},
                     { dataIndex: 'DEPT_CODE'                 , width: 77},                     
                     { dataIndex: 'DEPT_NAME'               , width: 160},

                     { dataIndex: 'BBB'                    , width: 88},
                     { dataIndex: 'CCC'                , width: 77},
                     { dataIndex: 'DDD'                , width: 150},
                     { dataIndex: 'EEE'                , width: 133},
                     { dataIndex: 'FFF'                , width: 100},
                     { dataIndex: 'GGG'                , width: 100},
                     { dataIndex: 'BIGO'                , width: 200}
                     
                     
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
        id  : 'hxt120skrApp',
        fnInitBinding : function() {
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            panelResult.setValue('ANN_DATE', new Date().getFullYear());
            
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
