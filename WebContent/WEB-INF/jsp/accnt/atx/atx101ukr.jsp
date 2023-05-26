<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="atx101ukr"  >
    <t:ExtComboStore comboType="AU" comboCode="A110" /> <!-- 휴페업구분 -->

</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >


var buttonFlag ='';

function appMain() {

    var directProxyButton = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            create: 'atx101ukrService.insertDetailButton',
            syncAll: 'atx101ukrService.saveAllButton'
        }
    }); 
   /**
    *   Model 정의 
    * @type 
    */

    Unilite.defineModel('atx101ukrModel', {
        fields: [ 
            {name: 'ROW_NUMBER'             ,text: 'NO'                 ,type: 'string'},
            {name: 'CUSTOM_CODE'            ,text: '거래처'               ,type: 'string'},
            {name: 'CUSTOM_NAME'            ,text: '거래처명'              ,type: 'string'},
            {name: 'COMPANY_NUM'            ,text: '사업자번호'             ,type: 'string'},
            {name: 'R_CUSTOM_GUBUN'         ,text: '휴폐업구분'             ,type: 'string',comboType:'AU', comboCode:'A110'},
            {name: 'CMS_TRANS_YN'           ,text: '전송여부'              ,type: 'string'},
            {name: 'R_RST_YN'               ,text: '결과받기여부'           ,type: 'string'},
            {name: 'R_RESULT_MSG'           ,text: '조회결과'              ,type: 'string'},
            {name: 'R_STATE_NUM'            ,text: '전문번호'              ,type: 'string'},
            {name: 'R_BASE_DATE'            ,text: '조회기준일'             ,type: 'uniDate'}
        ]
    });
    
   /**
    * Store 정의(Service 정의)
    * @type 
    */               
    var directDetailStore = Unilite.createStore('atx101ukrDetailStore',{
        model: 'atx101ukrModel',
        uniOpt : {
            isMaster: true,         // 상위 버튼 연결 
            editable: false,         // 수정 모드 사용 
            deletable:false,         // 삭제 가능 여부 
            useNavi : false         // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {          
                read: 'atx101ukrService.selectList'                  
            }
        },
        loadStoreRecords : function()   {
            var param= Ext.getCmp('searchForm').getValues();            
            console.log( param );
            this.load({
                params : param
            });
        }
   });
   
    var buttonStore = Unilite.createStore('ButtonStore',{     
        uniOpt: {
            isMaster: false,            // 상위 버튼 연결 
            editable: false,            // 수정 모드 사용 
            deletable: false,           // 삭제 가능 여부 
            useNavi : false         // prev | newxt 버튼 사용
        },
        proxy: directProxyButton,
        saveStore: function() {             
            var inValidRecs = this.getInvalidRecords();
            var paramMaster = subForm.getValues();  //syncAll 수정
            
            paramMaster.BUTTON_FLAG = buttonFlag;
            
            if(inValidRecs.length == 0) {
                config = {
                    params: [paramMaster],
                    success: function(batch, option) {
                        var master = batch.operations[0].getResultSet();
                        
                        buttonFlag = '';
                        UniAppManager.app.onQueryButtonDown();
                     },
                     failure: function(batch, option) {
                        buttonFlag = '';
                        
                     }
                };
                this.syncAllDirect(config);
            } else {
                var grid = Ext.getCmp('atx101ukrGrid');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
        },
        listeners: {
            load: function(store, records, successful, eOpts) {
            },
            add: function(store, records, index, eOpts) {
            },
            update: function(store, record, operation, modifiedFieldNames, eOpts) {
            },
            remove: function(store, record, index, isMove, eOpts) {
            }
        }
    });
   
   /**
    * 검색조건 (Search Panel)
    * @type 
    */
    var panelSearch = Unilite.createSearchPanel('searchForm', {     
        title: '검색조건',      
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
            title: '기본정보',  
            itemId: 'search_panel1',
            layout: {type: 'uniTable', columns: 1},
            defaultType: 'uniTextfield',            
            items: [{ 
                fieldLabel: '계산서일',
                xtype: 'uniDateRangefield',
                startFieldName: 'PUB_DATE_FR',
                endFieldName: 'PUB_DATE_TO',
                allowBlank: false,                  
//              holdable:'hold',
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelSearch) {
                        panelResult.setValue('PUB_DATE_FR', newValue);
                    }
                },
                onEndDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelSearch) {
                        panelResult.setValue('PUB_DATE_TO', newValue);                          
                    }
                }
            }]
        }]  
    });
    
    var panelResult = Unilite.createSearchForm('panelResultForm', {
        hidden: !UserInfo.appOption.collapseLeftSearch,
        region: 'north',
        layout : {type : 'uniTable', columns : 1},
        padding:'1 1 1 1',
        border:true,
        items: [{ 
            fieldLabel: '계산서일',
            xtype: 'uniDateRangefield',
            startFieldName: 'PUB_DATE_FR',
            endFieldName: 'PUB_DATE_TO',
            allowBlank: false,                  
//              holdable:'hold',
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
                if(panelResult) {
                    panelSearch.setValue('PUB_DATE_FR', newValue);
                }
            },
            onEndDateChange: function(field, newValue, oldValue, eOpts) {
                if(panelResult) {
                    panelSearch.setValue('PUB_DATE_TO', newValue);                          
                }
            }
        }]
    });
   
    var subForm = Unilite.createForm('subForm', {   //createForm
        layout: {type : 'uniTable', columns : 4, tableAttrs:{width:'100%'},tdAttrs: {width: '100%'}},
        disabled: false,
        border: true,
        padding: '1 1 1 1',
        region: 'north',
        items: [{
            xtype: 'container',
            layout: {type : 'uniTable', columns : 20
//          tdAttrs: {style: 'border : 1px solid #ced9e7;'}
            },
//          id:'branchSend',
            padding: '0 0 5 0',
//          width:1000,
            colspan:3,
            items :[{
                xtype: 'container',
                layout: {type : 'uniTable', columns : 1},
                width:80,
                tdAttrs: {align : 'center'},
                items :[{
                    xtype:'component',
                    html:'[작업순서]',
                    componentCls : 'component-text_second',
                    tdAttrs: {align : 'center'},
                    width: 80
                }]
            },{
                xtype: 'container',
                layout: {type : 'uniTable', columns : 1},
                width:30,
                tdAttrs: {align : 'center'},
                items :[{
                    xtype:'component',
                    html:'조회',
                    //id: '',
                    name: '',
                    width: 30,  
                    tdAttrs: {align : 'center'},
                    componentCls : 'component-text_second'
                }]
            },{
                xtype: 'container',
                layout: {type : 'uniTable', columns : 1},
                width:20,
                tdAttrs: {align : 'center'},
                items :[{
                    xtype:'component',
                    html:'→',
                    componentCls : 'component-text_second',
                    width: 20,
                    tdAttrs: {align : 'center'}
                }]
            },{
                xtype: 'container',
                layout: {type : 'uniTable', columns : 1},
                width:30,
                tdAttrs: {align : 'center'},
                items :[{
                    xtype:'component',
                    html:'체크',
                    //id: '',
                    name: '',
                    width: 30, 
                    tdAttrs: {align : 'center'},
                    componentCls : 'component-text_second'
                }]
            },{
                xtype: 'container',
                layout: {type : 'uniTable', columns : 1},
                width:20,
                tdAttrs: {align : 'center'},
                items :[{
                    xtype:'component',
                    html:'→',
                    tdAttrs: {align : 'center'},
                    componentCls : 'component-text_second',
                    width: 20
                }]
            },{
                xtype: 'container',
                layout: {type : 'uniTable', columns : 1},
                width:90,
                tdAttrs: {align : 'center'},
                items :[{
                    xtype: 'button',
                    text: '휴폐업조회', 
                    //id: '',
                    name: '',
                    width: 90,  
                    tdAttrs: {align : 'center'},
//                  hidden:true,
                    handler : function() {
                    	
                    	var selectedRecords = detailGrid.getSelectedRecords();
                        if(selectedRecords.length > 0){
                        
                            buttonStore.clearData();
                            Ext.each(selectedRecords, function(record,i){
                            	
                                record.phantom = true;
                                buttonStore.insert(i, record);
                            });
                            buttonFlag = 'FNCQ';
                            buttonStore.saveStore();
                                                    
                        }else{
                            Ext.Msg.alert('확인','휴폐업조회 할 데이터를 선택해 주세요.'); 
                        }
                    	
                    	
                    	
                    	
                    	
                    	
                      /* if(!Ext.isEmpty(panelResult.getValue('SEND_NUM'))){
                            var param = {
                                S_SEND_NUM: panelResult.getValue('SEND_NUM')
                            }
                            Ext.getCmp('pageAll').getEl().mask('작업 중...','loading-indicator');
                            
                            abh201ukrService.abh200create(param, function(provider, response)  {                           
                                if(provider){   
                                    UniAppManager.updateStatus(Msg.sMB014);
                                    directDetailStore.loadStoreRecords();
                                }
                                Ext.getCmp('pageAll').getEl().unmask(); 
                            });
                        }
                        */
                        
                        
                        
                        
                    }
                }]
            },{
                xtype: 'container',
                layout: {type : 'uniTable', columns : 1},
                width:20,
                tdAttrs: {align : 'center'},
                items :[{
                    xtype:'component',
                    html:'→',
                    componentCls : 'component-text_second',
                    width: 20,
                    tdAttrs: {align : 'center'}
                }]
            },{
                xtype: 'container',
                layout: {type : 'uniTable', columns : 1},
                width:90,
                tdAttrs: {align : 'center'},
                items :[{
                    xtype: 'button',
                    text: '결과받기', 
                    //id: '',
                    name: '',
                    width: 90,  
                    tdAttrs: {align : 'center'},
//                  hidden:true,
                    handler : function() {
                    	
                    	var selectedRecords = detailGrid.getSelectedRecords();
                        if(selectedRecords.length > 0){
                        
                            buttonStore.clearData();
                            Ext.each(selectedRecords, function(record,i){
                                
                                record.phantom = true;
                                buttonStore.insert(i, record);
                            });
                            buttonFlag = 'FNBN';
                            buttonStore.saveStore();
                                                    
                        }else{
                            Ext.Msg.alert('확인','결과받기 할 데이터를 선택해 주세요.'); 
                        }
                    	
                    	
                /*    	
                       if(!Ext.isEmpty(panelResult.getValue('SEND_NUM'))){
                            var param = {
                                S_SEND_NUM: panelResult.getValue('SEND_NUM'),
                                S_WORK_GB:  '1'
                                
                            }
                            Ext.getCmp('pageAll').getEl().mask('작업 중...','loading-indicator');
                            
                            abh201ukrService.bankNameresult(param, function(provider, response)  {                           
                                if(provider){   
                                    UniAppManager.updateStatus(Msg.sMB014);
                                    directDetailStore.loadStoreRecords();
                                }
                                Ext.getCmp('pageAll').getEl().unmask(); 
                            });
                        }*/
                        
                        
                        
                    }
                }]
            }]
            
        }]
    });
    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var detailGrid = Unilite.createGrid('atx101ukrGrid', {
        region: 'center',
        layout: 'fit',
        uniOpt: {
            useGroupSummary: false,
            useLiveSearch: true,
            useContextMenu: false,
            useMultipleSorting: true,
            onLoadSelectFirst: false,
            useRowNumberer: false,
            expandLastColumn: false,
            useRowContext: true,
            state: {
                useState: true,         
                useStateList: true      
            }
        },
        features: [{
            id: 'detailGridSubTotal',
            ftype: 'uniGroupingsummary',
            showSummaryRow: false                       
        },{
            id: 'detailGridTotal',
            ftype: 'uniSummary',
            showSummaryRow: false
        }],
        store: directDetailStore,
        selModel: Ext.create('Ext.selection.CheckboxModel', {checkOnly: true,
            listeners: {  
                select: function(grid, selectRecord, index, rowIndex, eOpts ){  
                  
                },
                deselect:  function(grid, selectRecord, index, eOpts ){
                	
                }
            }
        }),
        columns: [
            { dataIndex: 'ROW_NUMBER'               ,width:50, align:'center'},
            { dataIndex: 'CUSTOM_CODE'              ,width:100},
            { dataIndex: 'CUSTOM_NAME'              ,width:200},
            { dataIndex: 'COMPANY_NUM'              ,width:100},
            { dataIndex: 'R_CUSTOM_GUBUN'           ,width:100},
            { dataIndex: 'CMS_TRANS_YN'             ,width:100},
            { dataIndex: 'R_RST_YN'                 ,width:100},
            { dataIndex: 'R_RESULT_MSG'             ,width:100},
            { dataIndex: 'R_STATE_NUM'              ,width:100},
            { dataIndex: 'R_BASE_DATE'              ,width:100}
        ],
        listeners: {
            beforeedit: function(editor, e){            
            } 
        }
    });
   
   
    Unilite.Main( {
        borderItems:[{
            region:'center',
            layout: 'border',
            border: false,
            items:[
                panelResult, subForm, detailGrid
            ]
        },
            panelSearch
        ], 
        id  : 'atx101ukrApp',
        fnInitBinding : function(params) {
            UniAppManager.setToolbarButtons('reset',true);
            UniAppManager.setToolbarButtons(['newData', 'save', 'delete'], false);
            UniAppManager.app.setDefault(params);
/*            var activeSForm ;
            if(!UserInfo.appOption.collapseLeftSearch)  {
                activeSForm = panelSearch;
            }else {
                activeSForm = panelResult;
            }
            activeSForm.onLoadSelectText('PUB_DATE_FR');
            
            panelSearch.setValue('PUB_DATE_FR' , UniDate.get('startOfMonth'));
            panelSearch.setValue('PUB_DATE_TO' , UniDate.get('today'));
            
            panelResult.setValue('PUB_DATE_FR' , UniDate.get('startOfMonth'));
            panelResult.setValue('PUB_DATE_TO' , UniDate.get('today'));
            */
        },
        onQueryButtonDown : function()   {
            if(!panelResult.getInvalidMessage()) return;   //필수체크
            
            directDetailStore.loadStoreRecords();
        },
        /*onNewDataButtonDown : function() {            
            var r = {
                JOIN_DATE: UniDate.get('today') 
            };
            detailGrid.createRow(r, '');
        },*/
        onSaveDataButtonDown : function() {
    //          directDetailStore.saveStore();
        },
        /*onDeleteDataButtonDown : function()   {
            var selRow = detailGrid.getSelectedRecord();
            if(selRow.phantom === true) {
                detailGrid.deleteSelectedRow();
            }else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
                detailGrid.deleteSelectedRow();
            }
        },*/
        onResetButtonDown : function() {      
            panelSearch.clearForm();
            panelResult.clearForm();
            subForm.clearForm();
            detailGrid.reset();
            directDetailStore.clearData();
            this.fnInitBinding();
        },
        setDefault: function(params){
            if(!Ext.isEmpty(params.PUB_DATE_FR)){
                this.processParams(params);
            }else{
                var activeSForm ;
                if(!UserInfo.appOption.collapseLeftSearch)  {
                    activeSForm = panelSearch;
                }else {
                    activeSForm = panelResult;
                }
                activeSForm.onLoadSelectText('PUB_DATE_FR');
                
                panelSearch.setValue('PUB_DATE_FR' , UniDate.get('startOfMonth'));
                panelSearch.setValue('PUB_DATE_TO' , UniDate.get('today'));
                
                panelResult.setValue('PUB_DATE_FR' , UniDate.get('startOfMonth'));
                panelResult.setValue('PUB_DATE_TO' , UniDate.get('today')); 
            }
        },
        processParams: function(params) {
            panelResult.uniOpt.inLoading = true;
            this.uniOpt.appParams = params;
            if(params.PGM_ID == 'atx100ukr') {
                panelSearch.setValue('PUB_DATE_FR' , params.PUB_DATE_FR);
                panelSearch.setValue('PUB_DATE_TO' , params.PUB_DATE_TO);
                
                panelResult.setValue('PUB_DATE_FR' , params.PUB_DATE_FR);
                panelResult.setValue('PUB_DATE_TO' , params.PUB_DATE_TO); 
                
                this.onQueryButtonDown();
                //masterGrid1.getStore().loadStoreRecords();
            }
        }
    });
};
</script>