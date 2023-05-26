<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hbo900ukr">
    <t:ExtComboStore items="${BONUS_CODE}"   storeId="bonusCombo" /> <!-- 상여구분 -->
	<t:ExtComboStore comboType="AU" comboCode="H037" /><!--  상여구분자         -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
	
    // 외국인여부
	var togetherYNStore = Unilite.createStore('togetherYNStore', {
        fields: ['text', 'value'],
        data :  [
                     {'text':'예'          , 'value':'Y'},
                     {'text':'아니오'      , 'value':'N'}
                ]
    });

    var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            create    : 'hbo900ukrServiceImpl.insertList',                
            read      : 'hbo900ukrServiceImpl.selectList',
            update    : 'hbo900ukrServiceImpl.updateList',
            destroy   : 'hbo900ukrServiceImpl.deleteList',
            syncAll   : 'hbo900ukrServiceImpl.saveAll'
        }
    });
    
    /** Model 정의 
     * @type 
     */
    Unilite.defineModel('hbo900ukrModel', {
        fields: [
            {name: 'COMP_CODE'             , text: '법인코드'             , type: 'string' },
            {name: 'BONUS_TYPE'            , text: '상여구분'             , type: 'string'    , allowBlank: false ,      store: Ext.data.StoreManager.lookup('bonusCombo')},
            {name: 'FOREIGN_YN'            , text: '외국인여부'            , type: 'string'    , allowBlank: false ,      comboType:'AU', comboCode:'H037'},
            {name: 'DUTY_FR_MM'            , text: '근태반영FROM'         , type: 'string'    , maxLength: 7    },
            {name: 'DUTY_TO_MM'            , text: '근태반영TO'           , type: 'string'    , maxLength: 7    },
            {name: 'BONUS_RATE'            , text: '지급율'               , type: 'int'       , maxLength: 3    },
            {name: 'DUTY_TIME'             , text: '근태기준시'           , type: 'int'       , maxLength: 2    },
            {name: 'DUTY_MINUTE'           , text: '근태기준분'           , type: 'int'       , maxLength: 2    },
            {name: 'REMARK'                , text: '비고'                 , type: 'string'    , maxLength: 4000 }
        ]                                        
    });//End of Unilite.defineModel('hbo900ukrModel', {
    
    /** Store 정의(Service 정의)
     * @type 
     */            
    var masterStore = Unilite.createStore('hbo900ukrMasterStore1', {
        model    : 'hbo900ukrModel',
        proxy    : directProxy,
        uniOpt   : {
            isMaster     : true,            // 상위 버튼 연결
            editable     : true,            // 수정 모드 사용
            deletable    : true,            // 삭제 가능 여부
//            allDeletable : true,            // 전체 삭제 가능 여부
            useNavi      : false            // prev | newxt 버튼 사용
        },
        autoLoad: false,
        loadStoreRecords: function(){
            var param= Ext.getCmp('resultForm').getValues();            
            console.log(param);
            this.load({
                params: param
            });
        },
        saveStore : function()    {                
            var inValidRecs = this.getInvalidRecords();
            
            if(inValidRecs.length == 0 )    {
            	config = {
                    success: function(batch, option) {      
                        UniAppManager.setToolbarButtons('save', false);     
                    } 
                };
                
                this.syncAllDirect(config);                
            } else {                    
                masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
        },
        listeners: {
            load: function(store) {
                if (store.getCount() > 0) {
                    if (store.getCount() > 1) {
                        UniAppManager.setToolbarButtons('deleteAll', true);
                    }
                }
            }
        }
    });
        
    
    /** 검색조건 (Search Panel)
     * @type 
     */
    var panelResult = Unilite.createSearchForm('resultForm',{
        region    : 'north',
        layout    : {type : 'uniTable', columns : 2},
        padding    : '1 1 1 1',
        border    : true,
        items    : [{
                fieldLabel   : '상여구분',
                name         : 'BONUS_TYPE', 
                xtype        : 'uniCombobox',
                //multiSelect    : true, 
                typeAhead    : false,
                comboType    : 'AU',
                store        : Ext.data.StoreManager.lookup('bonusCombo'),
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                    }
                }
            }
        ]
    });
    
    /** Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('hbo900ukrGrid1', {
        store    : masterStore,
        layout    : 'fit',
        region    : 'center',
        uniOpt    : {
            expandLastColumn: true,
             useRowNumberer    : true,
             copiedRow        : true
//             useContextMenu    : true,
        },
        store: masterStore,
        features: [ {id : 'masterGridSubTotal'   , ftype: 'uniGroupingsummary'   , showSummaryRow: false },
                    {id : 'masterGridTotal'      , ftype: 'uniSummary'           , showSummaryRow: false} ],
        columns    : [
            {dataIndex: 'BONUS_TYPE'            , width: 150},
            {dataIndex: 'FOREIGN_YN'            , width: 100},
            {dataIndex: 'DUTY_FR_MM'            , width: 100             , align:'center'            },
            {dataIndex: 'DUTY_TO_MM'            , width: 100             , align:'center'            },
            {dataIndex: 'BONUS_RATE'            , width: 100},
            {dataIndex: 'DUTY_TIME'             , width: 100},
            {dataIndex: 'DUTY_MINUTE'           , width: 100             , hidden:true},
            {dataIndex: 'REMARK'                , width: 300             , hidden:true}
        ], 
        listeners: {
              beforeedit  : function( editor, e, eOpts ) {
              }
        }
    });//End of var masterGrid = Unilite.createGr100id('hbo900ukrGrid1', {    
            
    
    Unilite.Main( {
        id            : 'hbo900ukrApp',
        border        : false,
        borderItems    : [{
            region    : 'center',
            layout    : {type: 'vbox', align: 'stretch'},
            border    : false,
            items    : [
                panelResult, masterGrid 
            ]
        }],
        
        fnInitBinding: function() {
            //초기값 설정
            panelResult.onLoadSelectText('BONUS_TYPE');
            
            UniAppManager.setToolbarButtons('reset', false);
            UniAppManager.setToolbarButtons('newData', true);
        },
        
        onQueryButtonDown: function() {
            //필수입력값 체크
            if(!this.isValidSearchForm()){
                return false;
            }
            
            masterStore.loadStoreRecords();
            UniAppManager.setToolbarButtons('reset', true);
        },
        
        onNewDataButtonDown : function() {
            if(!this.isValidSearchForm()){
                return false;
            }
            
            var payYyyymm        = UniDate.get('today').substring(0,6);
            
            var record = {
            	 FOREIGN_YN: 'N'
            	,DUTY_FR_MM: payYyyymm
                ,DUTY_TO_MM: payYyyymm
                ,BONUS_RATE: 0
            };
            masterGrid.createRow(record, null, masterGrid.getStore().getCount()-1);
            UniAppManager.setToolbarButtons('reset', true);
        },
        onSaveDataButtonDown : function() {
            masterGrid.getStore().saveStore();
        },
        onDeleteDataButtonDown : function()    {
            var selRow = masterGrid.getSelectedRecord();
            if(selRow.phantom === true)    {
                masterGrid.deleteSelectedRow();
            }else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
                masterGrid.deleteSelectedRow();
            }
        },
        onResetButtonDown : function() {
            panelResult.clearForm();
            masterGrid.getStore().loadData({});
            this.fnInitBinding();;
        }
    });//End of Unilite.Main( {
};
</script>
