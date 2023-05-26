<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="log901ukr" >
    <t:ExtComboStore items="${COMBO_CODE01}" storeId="BatchCodeStore" />
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>    
<script type="text/javascript" >


function appMain() {

    var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read : 'log901ukrService.selectList'
        }
    });
    
    /**
     *   Model 정의 
     * @type 
     */
    Unilite.defineModel('log901ukrModel', {        
        fields: [         
            {name:'BATCH_CODE'           ,text: '배치명'          ,type: 'string'},
            {name:'BATCH_NAME'           ,text: '배치명'          ,type: 'string'}
        ]
    });        
    
    /**
     * Store 정의(Service 정의)
     * @type 
     */                    
    var directMasterStore1 = Unilite.createStore('log901ukrMasterStore1',{
        model: 'log901ukrModel',
        uniOpt : {
            isMaster: true,            // 상위 버튼 연결 
            editable: false,        // 수정 모드 사용 
            deletable:false,        // 삭제 가능 여부 
            useNavi : false            // prev | next 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
        loadStoreRecords : function()    {
            var param= Ext.getCmp('searchForm').getValues();            
            console.log( param );
            this.load({
                params : param
            });
        }
    });
    
    /**
     * 검색조건 (Search Panel)
     * @type 
     */    
    var panelSearch = Unilite.createSearchPanel('searchForm', {          
        title: '<t:message code="system.label.base.searchconditon" default="검색조건"/>',         
        defaultType: 'uniSearchSubPanel',
        collapsed: UserInfo.appOption.collapseLeftSearch,
        listeners: {
            collapse: function () {
                panelResult.show();
            },
            expand: function() {
                panelResult.hide();
            }
        },
        items: [{    
            title: '<t:message code="system.label.base.basisinfo2" default="기본정보"/>',     
            itemId: 'search_panel1',
            layout: {type: 'uniTable', columns: 1},
            defaultType: 'uniTextfield',
            items : [{
                fieldLabel: '배치명',
                name: 'BATCH_ID',
                xtype: 'uniCombobox',
                store: Ext.data.StoreManager.lookup('BatchCodeStore') ,
                width: 300 ,
                valueWidth:50 ,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {     
                          panelResult.setValue('BATCH_ID', newValue);
                    }
                }
            }]
        }]
    });    
    
    var panelResult = Unilite.createSearchForm('resultForm',{
        region: 'north',
        layout : {type : 'uniTable', columns : 3/*, tdAttrs: {style: 'border : 1px solid #ced9e7;'}*/},
        padding:'1 1 1 1',
        border:true,
        hidden: !UserInfo.appOption.collapseLeftSearch,
        items: [{
            fieldLabel: '배치명',
            name: 'BATCH_ID',
            xtype: 'uniCombobox',
            store: Ext.data.StoreManager.lookup('BatchCodeStore') ,
            width: 300 ,
            valueWidth:50 ,
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {     
                    panelSearch.setValue('BATCH_ID', newValue);
                }
            }
        }]
    });
         
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('log901ukrGrid', {
        // for tab        
        layout : 'fit',
        region:'center',
        store: directMasterStore1,
        uniOpt : {
            useMultipleSorting    : true,             
            useLiveSearch         : false,            
            onLoadSelectFirst     : false,        
            dblClickToEdit        : false,        
            useGroupSummary       : true,            
            useContextMenu        : false,        
            useRowNumberer        : true,            
            expandLastColumn      : true,        
            useRowContext         : false,    // rink 항목이 있을경우만 true            
            filter: {
                useFilter    : false,        
                autoCreate    : true        
            }
        },
        selModel: 'rowmodel',
        features: [
                    {id : 'masterGridSubTotal'           , ftype: 'uniGroupingsummary'       , showSummaryRow: false },
                    {id : 'masterGridTotal'              , ftype: 'uniSummary'               , showSummaryRow: false } 
                  ],
        columns:  [
            { dataIndex: 'BATCH_NAME'   , width:250 },
            {    header: '실행', 
                align:'center',
                width: 40,
                xtype:'actioncolumn',
                items:[
                    {
                        icon:CPATH+'/resources/css/icons/smallViewblue.png',
                        disabled:false,
/*
                        isDisabled: function(view, rowIndex, colIndex, item, record) {
                            var status = record.get("IF_STATUS");
                            return (status == 'V' || status == 'C');
                        },
*/
                        handler: function(view ,rowIndex ,colIndex ,item ,e ,record ,row) { 
                            if(confirm('선택된 배치를 실행합니다.\n실행 하시겠습니까?'))    {
                                Ext.Ajax.request({
                                     url: '/base/runBatch.do',
                                     params:{'BATCH_CODE':record.get('BATCH_CODE')},
                                     success: function(response, opts) {
                                         var rtnJson = Ext.JSON.decode(response.responseText);
                                         if(!Ext.isEmpty(rtnJson["success"]))   {
                                             Unilite.messageBox(rtnJson["returnMsg"]);
                                         }
                                     }
                                 });
                            }
                        } 
                    }
                ]
                
            }
        ]
    });
    
    Unilite.Main( {
        borderItems:[{
            region:'center',
            layout: 'border',
            border: false,
            items:[
                panelResult, masterGrid
            ]
        },
            panelSearch    
        ],
        id  : 'log901ukrApp',
        fnInitBinding : function() {
            if(!UserInfo.appOption.collapseLeftSearch) {
                activeSForm = panelSearch;
            } else {
                activeSForm = panelResult;
            }
            UniAppManager.setToolbarButtons(['detail','save'],false);
            UniAppManager.setToolbarButtons('reset',true);   
        },
        onResetButtonDown: function() {    
            panelSearch.clearForm();
            panelResult.clearForm();
            masterGrid.reset();
            directMasterStore1.clearData();
            this.fnInitBinding();
        },
        onQueryButtonDown : function()    {        
            if(!this.isValidSearchForm()){
                return false;
            }
            directMasterStore1.loadStoreRecords();
        }
    });
};
</script>
