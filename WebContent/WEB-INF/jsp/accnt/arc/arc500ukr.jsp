<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="arc500ukr"  >
    <t:ExtComboStore comboType="AU" comboCode="J504" /> <!-- 관리/수금구분 -->
    <t:ExtComboStore comboType="AU" comboCode="J507" /> <!-- 청구구분 -->
    <t:ExtComboStore comboType="AU" comboCode="A014" /> <!-- 승인상태 -->  

</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >


var buttonFlag ='';

var newYN = 'N';
function appMain() {

    var directProxyAutoSign = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            create: 'arc500ukrService.insertDetailAutoSign',
            syncAll: 'arc500ukrService.saveAllAutoSign'
        }
    }); 
   /**
    *   Model 정의 
    * @type 
    */

    Unilite.defineModel('arc500ukrModel', {
        fields: [ 
            {name: 'RNUM'               ,text: '순번'                 ,type: 'string'},
            {name: 'CONF_RECE_NO'       ,text: '법무채권번호(이관)'       ,type: 'string'},
            {name: 'COMP_CODE'          ,text: '법인명'                ,type: 'string'},
            {name: 'CONF_CHARGE_DATE'   ,text: '청구확정일'              ,type: 'uniDate'},
            {name: 'CONF_CHARGE_NO'     ,text: '청구번호'               ,type: 'string'},
            {name: 'RECE_COMP_CODE'     ,text: '회사코드'               ,type: 'string'},
            {name: 'RECE_COMP_NAME'     ,text: '회사명'                ,type: 'string'},
            {name: 'CUSTOM_CODE'        ,text: '거래처코드'              ,type: 'string'},
            {name: 'CUSTOM_NAME'        ,text: '거래처명'               ,type: 'string'},
            {name: 'CHARGE_TOT_AMT'     ,text: '청구금액'               ,type: 'uniPrice'},
            {name: 'BASE_AMT'           ,text: '기본대행료'              ,type: 'uniPrice'},
            {name: 'SUPPLY_AMT'         ,text: '실청구금액'              ,type: 'uniPrice'},
            {name: 'TAX_AMT'            ,text: '부가세'                ,type: 'uniPrice'},
            {name: 'TOT_SALE_AMT'       ,text: '매출금액'               ,type: 'uniPrice'},
            {name: 'EX_DATE'            ,text: '결의일자'               ,type: 'uniDate'},
            {name: 'EX_NUM'             ,text: '번호'                 ,type: 'string'},
            {name: 'AP_STS'             ,text: '승인여부'               ,type: 'string',comboType:'AU', comboCode:'A014'}
        ]
    });
    
   /**
    * Store 정의(Service 정의)
    * @type 
    */               
    var directDetailStore = Unilite.createStore('arc500ukrDetailStore',{
        model: 'arc500ukrModel',
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
                read: 'arc500ukrService.selectList'                  
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
   
    var autoSignButtonStore = Unilite.createStore('ButtonStore',{     
        uniOpt: {
            isMaster: false,            // 상위 버튼 연결 
            editable: false,            // 수정 모드 사용 
            deletable: false,           // 삭제 가능 여부 
            useNavi : false         // prev | newxt 버튼 사용
        },
        proxy: directProxyAutoSign,
        saveStore: function() {             
            var inValidRecs = this.getInvalidRecords();
            var paramMaster = panelResult.getValues();  //syncAll 수정
            
            paramMaster.BUTTON_FLAG = buttonFlag;
            if(buttonFlag == '1'){
            	paramMaster.WORK_DATE = UniDate.getDbDateStr(subForm.getValue('WORK_DATE'));
            }else{
            	paramMaster.WORK_DATE = '';
            }
            
//          param.FR_INPUT_DATE = UniDate.getDbDateStr(panelSearch.getValue('FR_INPUT_DATE'));
            
//            paramMaster.BUTTON_FLAG = panelResult.getField('ACCEPT_STATUS').getValue();
            
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
                var grid = Ext.getCmp('arc500ukrGrid');
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
                fieldLabel: '청구확정일',
                xtype: 'uniDateRangefield',
                startFieldName: 'CONF_CHARGE_DATE_FR',
                endFieldName: 'CONF_CHARGE_DATE_TO',
                allowBlank: false,                  
//              holdable:'hold',
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelSearch) {
                        panelResult.setValue('CONF_CHARGE_DATE_FR', newValue);
                    }
                },
                onEndDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelSearch) {
                        panelResult.setValue('CONF_CHARGE_DATE_TO', newValue);                          
                    }
                }
            },
            Unilite.popup('COMP',{
                fieldLabel: '회사명', 
                valueFieldName:'RECE_COMP_CODE',
                textFieldName:'RECE_COMP_NAME',
                validateBlank: false,
                listeners: {
                    onValueFieldChange: function(field, newValue){
                        panelResult.setValue('RECE_COMP_CODE', newValue);                                
                    },
                    onTextFieldChange: function(field, newValue){
                        panelResult.setValue('RECE_COMP_NAME', newValue);                
                    }
                }
            }),{
                xtype: 'container',
                layout: {type : 'uniTable', columns : 2},
                width:600,
    //          colspan:2,
                items :[{
                    xtype: 'radiogroup',                            
                    fieldLabel: '작업구분',
    //              colspan:2,
                    id: 'rdoSelect',
                    items: [{
                        boxLabel: '자동기표', 
                        width: 70,
                        name: 'ACCEPT_STATUS',
                        inputValue: '1',
                        checked: true  
                    },{
                        boxLabel: '기표취소', 
                        width: 70,
                        name: 'ACCEPT_STATUS',
                        inputValue: '2'
                    }],
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                            panelResult.getField('ACCEPT_STATUS').setValue(newValue.ACCEPT_STATUS);         
                            
                            if(newValue.ACCEPT_STATUS == '1'){
                                Ext.getCmp('autoSignBtn1').setHidden(false);
                                Ext.getCmp('autoSignBtn2').setHidden(false);
                                Ext.getCmp('autoSignBtn3').setHidden(true);
                                
                            }else if(newValue.ACCEPT_STATUS == '2'){
                                Ext.getCmp('autoSignBtn1').setHidden(true);
                                Ext.getCmp('autoSignBtn2').setHidden(true);
                                Ext.getCmp('autoSignBtn3').setHidden(false);
                            }
                        }
                    }
                }]
            }]
        }]         
    });
    
    var panelResult = Unilite.createSearchForm('panelResultForm', {
        hidden: !UserInfo.appOption.collapseLeftSearch,
        region: 'north',
        layout : {type : 'uniTable', columns : 2},
        padding:'1 1 1 1',
        border:true,
        items: [{ 
                fieldLabel: '청구확정일',
                xtype: 'uniDateRangefield',
                startFieldName: 'CONF_CHARGE_DATE_FR',
                endFieldName: 'CONF_CHARGE_DATE_TO',
                allowBlank: false,                  
//              holdable:'hold',
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelResult) {
                        panelSearch.setValue('CONF_CHARGE_DATE_FR', newValue);
                    }
                },
                onEndDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelResult) {
                        panelSearch.setValue('CONF_CHARGE_DATE_TO', newValue);                          
                    }
                }
            },
            Unilite.popup('COMP',{
                fieldLabel: '회사명', 
                valueFieldName:'RECE_COMP_CODE',
                textFieldName:'RECE_COMP_NAME',
                validateBlank: false,
                listeners: {
                    onValueFieldChange: function(field, newValue){
                        panelSearch.setValue('RECE_COMP_CODE', newValue);                                
                    },
                    onTextFieldChange: function(field, newValue){
                        panelSearch.setValue('RECE_COMP_NAME', newValue);                
                    }
                }
            }),{
                xtype: 'container',
                layout: {type : 'uniTable', columns : 2},
//                width:600,
    //          colspan:2,
                items :[{
                    xtype: 'radiogroup',                            
                    fieldLabel: '작업구분',
    //              colspan:2,
//                  id: 'asStatus',
                    items: [{
                        boxLabel: '자동기표', 
                        width: 70,
                        name: 'ACCEPT_STATUS',
                        inputValue: '1',
                        checked: true  
                    },{
                        boxLabel: '기표취소', 
                        width: 70,
                        name: 'ACCEPT_STATUS',
                        inputValue: '2' 
                    }],
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                            panelSearch.getField('ACCEPT_STATUS').setValue(newValue.ACCEPT_STATUS); 
                            
                            if(newValue.ACCEPT_STATUS == '1'){
                            	Ext.getCmp('autoSignBtn1').setHidden(false);
                            	Ext.getCmp('autoSignBtn2').setHidden(false);
                            	Ext.getCmp('autoSignBtn3').setHidden(true);
                                
                            }else if(newValue.ACCEPT_STATUS == '2'){
                                Ext.getCmp('autoSignBtn1').setHidden(true);
                                Ext.getCmp('autoSignBtn2').setHidden(true);
                                Ext.getCmp('autoSignBtn3').setHidden(false);
                            }
                            if (newYN == 'Y'){      //신규버튼 클릭의 경우에는 조회로직 수행하지 않는다
                                newYN = 'N';
                                return false;
                            }else {
                                UniAppManager.app.onQueryButtonDown();
                            }
                        }
                    }
                }
            ]}
        ]
    });
   
    var subForm = Unilite.createForm('subForm', {   //createForm
        layout: {type : 'uniTable', columns : 4, tableAttrs:{width:'100%'},tdAttrs: {width: '100%'}},
        disabled: false,
        border: true,
        padding: '1 1 1 1',
        region: 'north',
        items: [{
            xtype: 'container',
            layout : {type : 'uniTable'},
            tdAttrs: {width: 380},    
            items:[{
                fieldLabel: '실행일',
                xtype: 'uniDatefield',
                name: 'WORK_DATE',
                value: UniDate.get('today'),
//                readOnly:true,
                allowBlank:false,
                width:220,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                    }
                }
            },{
                xtype: 'radiogroup',                            
                fieldLabel: '',                                         
                id: 'rdoSelect1',
                items: [{
                    boxLabel: '청구확정일', 
                    width: 90, 
                    name: 'WORK_FLAG',
                    inputValue: '1'
                },{
                    boxLabel : '실행일', 
                    width: 70,
                    name: 'WORK_FLAG',
                    inputValue: '2',
                    checked: true  
                }],
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        if(newValue.WORK_FLAG == '1'){
                            subForm.getField('WORK_DATE').setReadOnly(true);
                        }else{
                            subForm.getField('WORK_DATE').setReadOnly(false);
                        }
                    }
                }
            }]
        },{
            fieldLabel: '합계(선택)',
            xtype: 'uniNumberfield',
            name: 'SUM_CHARGE_TOT_AMT',
            readOnly: true,
            tdAttrs: {align : 'right'}
        },{
            fieldLabel: '건수(선택)',
            xtype: 'uniNumberfield',
            name: 'SUM_COUNT',
            readOnly: true,
            tdAttrs: {align : 'right'}
        },{
            xtype: 'container',
            layout: {
                type: 'hbox',
                align: 'right'
            },
            width:200,
            margin: '0 0 1 0',
//            tdAttrs: {align : 'right'/*,width:'100%',height:'100%'*/},
            items :[{
            	xtype:'component',
            	width:20
        	},{
            	xtype:'button',
                id: 'autoSignBtn1',
//                itemId: 'autoSignBtn',
                text: '일괄자동기표',
                flex : 1,
//                width:100,
                handler: function() {
                	if(!subForm.getInvalidMessage()) return;
//                	if(panelResult.getField('ACCEPT_STATUS').getValue()
                    var selectedRecords = detailGrid.getSelectedRecords();
                    if(selectedRecords.length > 0){
                    
                        autoSignButtonStore.clearData();
                        Ext.each(selectedRecords, function(record,i){
                            record.phantom = true;
                            autoSignButtonStore.insert(i, record);
                        });
                        buttonFlag = '1';
                        autoSignButtonStore.saveStore();
                                                
                    }else{
                        Ext.Msg.alert('확인','자동기표 할 데이터를 선택해 주세요.'); 
                    }
                }
            },{
                xtype:'button',
                id: 'autoSignBtn2',
//                itemId: 'autoSignBtn',
                text: '개별자동기표',
//                width:100,
                flex : 1,
                handler: function() {
                    if(!subForm.getInvalidMessage()) return;
//                  if(panelResult.getField('ACCEPT_STATUS').getValue()
                    var selectedRecords = detailGrid.getSelectedRecords();
                    if(selectedRecords.length > 0){
                    
                        autoSignButtonStore.clearData();
                        Ext.each(selectedRecords, function(record,i){
                            record.phantom = true;
                            autoSignButtonStore.insert(i, record);
                        });
                        buttonFlag = '2';
                        autoSignButtonStore.saveStore();
                                                
                    }else{
                        Ext.Msg.alert('확인','자동기표 할 데이터를 선택해 주세요.'); 
                    }
                }
            },{
                xtype:'button',
                id: 'autoSignBtn3',
//                itemId: 'autoSignBtn',
                text: '기표취소',
//                width:100,
                flex : 1,
//                hidden:true,
                handler: function() {
                    if(!subForm.getInvalidMessage()) return;
//                  if(panelResult.getField('ACCEPT_STATUS').getValue()
                    var selectedRecords = detailGrid.getSelectedRecords();
                    if(selectedRecords.length > 0){
                    
                        autoSignButtonStore.clearData();
                        Ext.each(selectedRecords, function(record,i){
                            record.phantom = true;
                            autoSignButtonStore.insert(i, record);
                        });
                        buttonFlag = '3';
                        autoSignButtonStore.saveStore();
                                                
                    }else{
                        Ext.Msg.alert('확인','기표취소 할 데이터를 선택해 주세요.'); 
                    }
                }
            }]
        }]
    });
    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var detailGrid = Unilite.createGrid('arc500ukrGrid', {
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
                    
//                	alert('선택');
//                	CHARGE_TOT_AMT
//                	
//                	
//                	subForm.setValue('CHARGE_TOT_AMT',);
                	var chargeTotAmt = subForm.getValue('SUM_CHARGE_TOT_AMT');
                	
                	subForm.setValue('SUM_CHARGE_TOT_AMT',chargeTotAmt + selectRecord.data.CHARGE_TOT_AMT);
                	
                	subForm.setValue('SUM_COUNT',grid.selected.length);
                },
                deselect:  function(grid, selectRecord, index, eOpts ){
                	var chargeTotAmt = subForm.getValue('SUM_CHARGE_TOT_AMT');
                    
                    subForm.setValue('SUM_CHARGE_TOT_AMT',chargeTotAmt - selectRecord.data.CHARGE_TOT_AMT);
                    
//                	alert('선택해제');
                	subForm.setValue('SUM_COUNT',grid.selected.length);
                }
            }
        }),
        columns: [
            { dataIndex: 'RNUM'                         ,width:50, align:'center'},
            { dataIndex: 'CONF_RECE_NO'                 ,width:100,hidden:true},
            { dataIndex: 'COMP_CODE'                    ,width:100 ,hidden:true},
            { dataIndex: 'CONF_CHARGE_DATE'             ,width:100},
            { dataIndex: 'CONF_CHARGE_NO'               ,width:100/*,
            summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                    return Unilite.renderSummaryRow(summaryData, metaData, '소계', '합계');
            }*/},
            { dataIndex: 'RECE_COMP_CODE'               ,width:100 ,hidden:true},
            { dataIndex: 'RECE_COMP_NAME'               ,width:100},
            { dataIndex: 'CUSTOM_CODE'                  ,width:100},
            { dataIndex: 'CUSTOM_NAME'                  ,width:100},
            { dataIndex: 'CHARGE_TOT_AMT'               ,width:100},//, summaryType: 'sum'},
            { dataIndex: 'BASE_AMT'                     ,width:100},//, summaryType: 'sum'},
            { dataIndex: 'SUPPLY_AMT'                   ,width:100},//, summaryType: 'sum'},
            { dataIndex: 'TAX_AMT'                      ,width:100},//, summaryType: 'sum'},
            { dataIndex: 'TOT_SALE_AMT'                 ,width:100},//, summaryType: 'sum'},
            { dataIndex: 'EX_DATE'                      ,width:100},
            { dataIndex: 'EX_NUM'                       ,width:100},
            { dataIndex: 'AP_STS'                  ,width:100}
        ],
        listeners: {
            listeners: {  
            },
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
    id  : 'arc500ukrApp',
    fnInitBinding : function() {
        UniAppManager.setToolbarButtons('reset',true);
        UniAppManager.setToolbarButtons(['newData', 'save', 'delete'], false);
        
            var activeSForm ;
            if(!UserInfo.appOption.collapseLeftSearch)  {
                activeSForm = panelSearch;
            }else {
                activeSForm = panelResult;
            }
            activeSForm.onLoadSelectText('CONF_CHARGE_DATE_FR');
            
            panelSearch.setValue('CONF_CHARGE_DATE_FR', UniDate.get('startOfMonth'));
            panelResult.setValue('CONF_CHARGE_DATE_FR', UniDate.get('startOfMonth'));
            panelSearch.setValue('CONF_CHARGE_DATE_TO', UniDate.get('today'));
            panelResult.setValue('CONF_CHARGE_DATE_TO', UniDate.get('today'));
            
            
            subForm.setValue('WORK_DATE', UniDate.get('today'));
            subForm.setValue('SUM_COUNT',0);
            subForm.setValue('SUM_CHARGE_TOT_AMT',0);
            
            panelSearch.getField('ACCEPT_STATUS').setValue('1');   
            panelResult.getField('ACCEPT_STATUS').setValue('1');   
            Ext.getCmp('autoSignBtn1').setHidden(false);
            Ext.getCmp('autoSignBtn2').setHidden(false);
            Ext.getCmp('autoSignBtn3').setHidden(true);
            newYN = 'N';
        },
        onQueryButtonDown : function()   {
            if(!panelResult.getInvalidMessage()) return;   //필수체크
            
            
            subForm.setValue('SUM_COUNT',0);
            subForm.setValue('SUM_CHARGE_TOT_AMT',0);
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
            newYN = 'Y';
            this.fnInitBinding();
        }
   });
};
</script>