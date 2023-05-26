<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="arc400ukr"  >
    <t:ExtComboStore comboType="AU" comboCode="J504" /> <!-- 관리/수금구분 -->
    <t:ExtComboStore comboType="AU" comboCode="J507" /> <!-- 청구구분 -->
    <t:ExtComboStore comboType="AU" comboCode="A014" /> <!-- 승인상태 -->
    <t:ExtComboStore comboType="AU" comboCode="A207" /> <!-- 확정여부 -->  

</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >


var buttonFlag ='';

var newYN1 = 'N';
var newYN2 = 'N';
function appMain() {

    var directProxyButton = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            create: 'arc400ukrService.insertDetailButton',
            syncAll: 'arc400ukrService.saveAllButton'
        }
    }); 
   /**
    *   Model 정의 
    * @type 
    */

    Unilite.defineModel('arc400ukrModel', {
        fields: [ 
            {name: 'RNUM'               ,text: 'NO'                 ,type: 'string'},
            {name: 'MNG_DATE'           ,text: '수금일자'                   ,type: 'uniDate'},
            {name: 'CHARGE_DATE'        ,text: '청구일자'                   ,type: 'uniDate'},
            {name: 'CHARGE_YN'          ,text: '청구여부'                   ,type: 'string' , comboType:'AU', comboCode:'J507'},
            {name: 'RECE_COMP_CODE'     ,text: '회사코드'                   ,type: 'string'},
            {name: 'RECE_COMP_NAME'     ,text: '회사명'                    ,type: 'string'},
            {name: 'CUSTOM_CODE'        ,text: '거래처코드'                  ,type: 'string'},
            {name: 'CUSTOM_NAME'        ,text: '거래처명'                   ,type: 'string'},
            {name: 'TOP_NAME'           ,text: '대표자명'                   ,type: 'string'},
            {name: 'COLLECT_AMT'        ,text: '수금액'                    ,type: 'uniPrice'},
            {name: 'CHARGE_AMT'         ,text: '청구금액'                   ,type: 'uniPrice'},
            {name: 'MNG_GUBUN'          ,text: '구분'                     ,type: 'string' , comboType:'AU', comboCode:'J504'},
            {name: 'REMARK'             ,text: '내용'                     ,type: 'string'},
            {name: 'CONF_DRAFTER'       ,text: '법무담당코드'                   ,type: 'string'},
            {name: 'DRAFTER_NAME'       ,text: '법무담당'                   ,type: 'string'},
            {name: 'NOTE_NUM'           ,text: '어음번호'                   ,type: 'string'},
            {name: 'EXP_DATE'           ,text: '만기일'                    ,type: 'string'},
            {name: 'CONF_RECE_NO'       ,text: '법무채권번호'             ,type: 'string'},
            {name: 'SEQ'                ,text: '순번'                     ,type: 'string'},
            {name: 'CONF_CHARGE_DATE'   ,text: '청구확정일'                  ,type: 'string'},
            {name: 'CONF_YN'            ,text: '청구확정여부'             ,type: 'string', comboType:'AU', comboCode:'A207'},
            {name: 'CONF_CHARGE_NO'     ,text: '청구확정번호'             ,type: 'string'}
        ]
    });
    
   /**
    * Store 정의(Service 정의)
    * @type 
    */               
    var directDetailStore = Unilite.createStore('arc400ukrDetailStore',{
        model: 'arc400ukrModel',
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
                read: 'arc400ukrService.selectList'                  
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
            if(buttonFlag == 'b1'){ // 청구버튼
            	paramMaster.CHARGE_DATE = UniDate.getDbDateStr(UniDate.get('today'));
            	paramMaster.CONF_CHARGE_DATE = '';
            }else if(buttonFlag == 'b3'){//정구확정버튼
            	paramMaster.CONF_CHARGE_DATE = UniDate.getDbDateStr(subForm.getValue('CONF_CHARGE_DATE'));
            	paramMaster.CHARGE_DATE = '';
            }else{
            	paramMaster.CHARGE_DATE = '';
            	paramMaster.CONF_CHARGE_DATE = '';
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
                var grid = Ext.getCmp('arc400ukrGrid');
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
                fieldLabel: '수금일',
                xtype: 'uniDateRangefield',
                startFieldName: 'MNG_DATE_FR',
                endFieldName: 'MNG_DATE_TO',
                allowBlank: false,                  
//              holdable:'hold',
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelSearch) {
                        panelResult.setValue('MNG_DATE_FR', newValue);
                    }
                },
                onEndDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelSearch) {
                        panelResult.setValue('MNG_DATE_TO', newValue);                          
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
                fieldLabel: '청구일',
                xtype: 'uniDateRangefield',
                startFieldName: 'CHARGE_DATE_FR',
                endFieldName: 'CHARGE_DATE_TO',         
//              holdable:'hold',
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelSearch) {
                        panelResult.setValue('CHARGE_DATE_FR', newValue);
                    }
                },
                onEndDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelSearch) {
                        panelResult.setValue('CHARGE_DATE_TO', newValue);                           
                    }
                }
            },
            Unilite.popup('CUST',{
                extParam : {'CUSTOM_TYPE': ['1','2','3']},
                fieldLabel: '거래처', 
                valueFieldName:'CUSTOM_CODE',
                textFieldName:'CUSTOM_NAME',
                validateBlank: false,
                listeners: {
                    onValueFieldChange: function(field, newValue){
                        panelResult.setValue('CUSTOM_CODE', newValue);                              
                    },
                    onTextFieldChange: function(field, newValue){
                        panelResult.setValue('CUSTOM_NAME', newValue);              
                    }
                }
            }),{
                xtype: 'container',
                layout: {type : 'uniTable', columns : 2},
                width:600,
                items :[{
                    xtype: 'radiogroup',
                    id:'rdoSelect',
                    fieldLabel: '청구여부',
                    items: [{
                        boxLabel: '전체', 
                        width: 70,
                        name: 'CHARGE_YN',
                        inputValue: 'A',
                        checked: true  
                    },{
                        boxLabel: '청구', 
                        width: 70,
                        name: 'CHARGE_YN',
                        inputValue: 'Y' 
                    },{
                        boxLabel: '미청구', 
                        width: 70,
                        name: 'CHARGE_YN',
                        inputValue: 'N'
                    }],
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {        
                            panelResult.getField('CHARGE_YN').setValue(newValue.CHARGE_YN);     
                            
                          /*  if(newValue.CHARGE_YN == 'Y'){
                                Ext.getCmp('apply').setText('청구확정');
                                changeBtn = 'Y';
                            }else{
                                Ext.getCmp('apply').setText('청구확정취소');
                                changeBtn = 'N';
                            }
                            */
                        }
                    }
                }
            ]},
            Unilite.popup('Employee',{
                fieldLabel: '법무담당', 
                valueFieldWidth: 90,
                textFieldWidth: 140,
                valueFieldName:'CONF_DRAFTER',
                textFieldName:'CONF_DRAFTER_NAME',
//                extParam: {
//                    'ADD_QUERY': "Y"
//                },  
                listeners: {
                    onValueFieldChange: function(field, newValue){
                        panelResult.setValue('CONF_DRAFTER', newValue);                              
                    },
                    onTextFieldChange: function(field, newValue){
                        panelResult.setValue('CONF_DRAFTER_NAME', newValue);             
                    },
                    applyextparam: function(popup){
                        popup.setExtParam({'ADD_QUERY': "Y"});                           
                    }
                }
            }),{
                xtype: 'container',
                layout: {type : 'uniTable', columns : 2},
                width:600,
                items :[{
                    xtype: 'radiogroup',                            
                    fieldLabel: '청구확정여부',
                    items: [{
                        boxLabel: '전체', 
                        width: 70,
                        name: 'CONF_YN',
                        inputValue: 'A',
                        checked: true  
                    },{
                        boxLabel: '확정', 
                        width: 70,
                        name: 'CONF_YN',
                        inputValue: 'Y' 
                    },{
                        boxLabel: '미확정', 
                        width: 70,
                        name: 'CONF_YN',
                        inputValue: 'N'
                    }],
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                            panelResult.getField('CONF_YN').setValue(newValue.CONF_YN);     
                            
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
            fieldLabel: '수금일',
            xtype: 'uniDateRangefield',
            startFieldName: 'MNG_DATE_FR',
            endFieldName: 'MNG_DATE_TO',
            allowBlank: false,                  
//              holdable:'hold',
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
                if(panelResult) {
                    panelSearch.setValue('MNG_DATE_FR', newValue);
                }
            },
            onEndDateChange: function(field, newValue, oldValue, eOpts) {
                if(panelResult) {
                    panelSearch.setValue('MNG_DATE_TO', newValue);                          
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
            fieldLabel: '청구일',
            xtype: 'uniDateRangefield',
            startFieldName: 'CHARGE_DATE_FR',
            endFieldName: 'CHARGE_DATE_TO',
//              holdable:'hold',
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
                if(panelResult) {
                    panelSearch.setValue('CHARGE_DATE_FR', newValue);
                }
            },
            onEndDateChange: function(field, newValue, oldValue, eOpts) {
                if(panelResult) {
                    panelSearch.setValue('CHARGE_DATE_TO', newValue);                           
                }
            }
        },
        Unilite.popup('CUST',{
            extParam : {'CUSTOM_TYPE': ['1','2','3']},
            fieldLabel: '거래처', 
            valueFieldName:'CUSTOM_CODE',
            textFieldName:'CUSTOM_NAME',
            validateBlank: false,
            listeners: {
                onValueFieldChange: function(field, newValue){
                    panelSearch.setValue('CUSTOM_CODE', newValue);                              
                },
                onTextFieldChange: function(field, newValue){
                    panelSearch.setValue('CUSTOM_NAME', newValue);              
                }
            }
        }),{
            xtype: 'container',
            layout: {type : 'uniTable', columns : 2},
            width:600,
//          colspan:2,
            items :[{
                xtype: 'radiogroup',                            
                fieldLabel: '청구여부',
//              colspan:2,
//                  id: 'asStatus',
                items: [{
                    boxLabel: '전체', 
                    width: 70,
                    name: 'CHARGE_YN',
                    inputValue: 'A',
                    checked: true  
                },{
                    boxLabel: '청구', 
                    width: 70,
                    name: 'CHARGE_YN',
                    inputValue: 'Y' 
                },{
                    boxLabel: '미청구', 
                    width: 70,
                    name: 'CHARGE_YN',
                    inputValue: 'N'
                }],
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {            
                        panelSearch.getField('CHARGE_YN').setValue(newValue.CHARGE_YN); 
                        
                     /*   if(newValue.CHARGE_YN == 'Y'){
                            Ext.getCmp('apply').setText('청구확정');
                            changeBtn = 'Y';
                        }else{
                            Ext.getCmp('apply').setText('청구확정취소');
                            changeBtn = 'N';
                        }*/
                        if (newYN1 == 'Y'){      //신규버튼 클릭의 경우에는 조회로직 수행하지 않는다
                            newYN1 = 'N';
                            return false;
                        }else {
                            UniAppManager.app.onQueryButtonDown();  
                        }
                    }
                }
            }
        ]},
        Unilite.popup('Employee',{
            fieldLabel: '법무담당', 
            valueFieldWidth: 90,
            textFieldWidth: 140,
            valueFieldName:'CONF_DRAFTER',
            textFieldName:'CONF_DRAFTER_NAME',
//                extParam: {
//                    'ADD_QUERY': "Y"
//                },  
            listeners: {
                onValueFieldChange: function(field, newValue){
                    panelSearch.setValue('CONF_DRAFTER', newValue);                              
                },
                onTextFieldChange: function(field, newValue){
                    panelSearch.setValue('CONF_DRAFTER_NAME', newValue);             
                },
                applyextparam: function(popup){
                    popup.setExtParam({'ADD_QUERY': "Y"});                           
                }
            }
        }),{
            xtype: 'container',
            layout: {type : 'uniTable', columns : 2},
            width:600,
            items :[{
                xtype: 'radiogroup',                            
                fieldLabel: '청구확정여부',
                items: [{
                    boxLabel: '전체', 
                    width: 70,
                    name: 'CONF_YN',
                    inputValue: 'A',
                    checked: true  
                },{
                    boxLabel: '확정', 
                    width: 70,
                    name: 'CONF_YN',
                    inputValue: 'Y' 
                },{
                    boxLabel: '미확정', 
                    width: 70,
                    name: 'CONF_YN',
                    inputValue: 'N'
                }],
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.getField('CONF_YN').setValue(newValue.CONF_YN);
                        
                        if (newYN2 == 'Y'){      //신규버튼 클릭의 경우에는 조회로직 수행하지 않는다
                            newYN2 = 'N';
                            return false;
                        }else {
                            UniAppManager.app.onQueryButtonDown();  
                        }
                    }
                }
            }]
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
            layout : {type : 'uniTable'},
            tdAttrs: {width: 380},    
            items:[{
                fieldLabel: '청구확정일',
                xtype: 'uniDatefield',
                name: 'CONF_CHARGE_DATE',
                value: UniDate.get('today'),
//                readOnly:true,
                allowBlank:false,
                width:220,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                    }
                }
            }]
        },{
            xtype: 'container',
            layout: {
                type: 'hbox',
                align: 'left'
            },
            width:200,
            margin: '0 0 1 0',
//            tdAttrs: {align : 'right'/*,width:'100%',height:'100%'*/},
            items :[{
            	xtype:'component',
            	width:20
        	},{
            	xtype:'button',
                id: 'btn1',
//                itemId: 'btn',
                text: '청구',
                flex : 1,
//                width:100,
                handler: function() {
//                	if(!subForm.getInvalidMessage()) return;
//                	if(panelResult.getField('ACCEPT_STATUS').getValue()
                    var selectedRecords = detailGrid.getSelectedRecords();
                    if(selectedRecords.length > 0){
                    
                        buttonStore.clearData();
                        Ext.each(selectedRecords, function(record,i){
                            record.phantom = true;
                            buttonStore.insert(i, record);
                        });
                        buttonFlag = 'b1';
                        buttonStore.saveStore();
                        
    //                    alert(buttonStore.count());  //임시로 카운트 뽑아 놓음 로그테이블 완성되면 saveStore 호출
                        
                    }else{
                        Ext.Msg.alert('확인','청구 할 데이터를 선택해 주세요.'); 
                    }
                }
            },{
                xtype:'button',
                id: 'btn2',
//                itemId: 'btn',
                text: '미청구',
//                width:100,
                flex : 1,
                handler: function() {
//                    if(!subForm.getInvalidMessage()) return;
//                  if(panelResult.getField('ACCEPT_STATUS').getValue()
                    var selectedRecords = detailGrid.getSelectedRecords();
                    if(selectedRecords.length > 0){
                    
                        buttonStore.clearData();
                        Ext.each(selectedRecords, function(record,i){
                            record.phantom = true;
                            buttonStore.insert(i, record);
                        });
                        buttonFlag = 'b2';
                        buttonStore.saveStore();
                        
    //                    alert(buttonStore.count());  //임시로 카운트 뽑아 놓음 로그테이블 완성되면 saveStore 호출
                        
                    }else{
                        Ext.Msg.alert('확인','미청구 할 데이터를 선택해 주세요.'); 
                    }
                }
            }]
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
                xtype:'button',
                id: 'btn3',
//                itemId: 'btn',
                text: '청구확정',
//                width:100,
                flex : 1,
//                hidden:true,
                handler: function() {
                    if(!subForm.getInvalidMessage()) return;
//                  if(panelResult.getField('ACCEPT_STATUS').getValue()
                    var selectedRecords = detailGrid.getSelectedRecords();
                    if(selectedRecords.length > 0){
                    
                        buttonStore.clearData();
                        Ext.each(selectedRecords, function(record,i){
                            record.phantom = true;
                            buttonStore.insert(i, record);
                        });
                        buttonFlag = 'b3';
                        buttonStore.saveStore();
                        
    //                    alert(buttonStore.count());  //임시로 카운트 뽑아 놓음 로그테이블 완성되면 saveStore 호출
                        
                    }else{
                        Ext.Msg.alert('확인','청구확정 할 데이터를 선택해 주세요.'); 
                    }
                }
            },{
                xtype:'button',
                id: 'btn4',
//                itemId: 'btn',
                text: '청구확정취소',
//                width:100,
                flex : 1,
                handler: function() {
//                    if(!subForm.getInvalidMessage()) return;
//                  if(panelResult.getField('ACCEPT_STATUS').getValue()
                    var selectedRecords = detailGrid.getSelectedRecords();
                    if(selectedRecords.length > 0){
                    
                        buttonStore.clearData();
                        Ext.each(selectedRecords, function(record,i){
                            record.phantom = true;
                            buttonStore.insert(i, record);
                        });
                        buttonFlag = 'b4';
                        buttonStore.saveStore();
                        
    //                    alert(buttonStore.count());  //임시로 카운트 뽑아 놓음 로그테이블 완성되면 saveStore 호출
                        
                    }else{
                        Ext.Msg.alert('확인','청구확정취소 할 데이터를 선택해 주세요.'); 
                    }
                }
            }]
        }]
    });
    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var detailGrid = Unilite.createGrid('arc400ukrGrid', {
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
            { dataIndex: 'RNUM'                         ,width:50, align:'center'},
            { dataIndex: 'MNG_DATE'                 ,width:100},
            { dataIndex: 'CHARGE_DATE'              ,width:100},
            { dataIndex: 'CHARGE_YN'                ,width:70, align:'center'},
            { dataIndex: 'RECE_COMP_CODE'           ,width:80},
            { dataIndex: 'RECE_COMP_NAME'           ,width:150},
            { dataIndex: 'CUSTOM_CODE'              ,width:100},
            { dataIndex: 'CUSTOM_NAME'              ,width:100},
            { dataIndex: 'TOP_NAME'                 ,width:100},
            { dataIndex: 'COLLECT_AMT'              ,width:100},
            { dataIndex: 'CHARGE_AMT'               ,width:100},
            { dataIndex: 'MNG_GUBUN'                ,width:100, align:'center'},
            { dataIndex: 'REMARK'                   ,width:100},
            
            { dataIndex: 'CONF_DRAFTER'             ,width:100,hidden:true},
            { dataIndex: 'DRAFTER_NAME'             ,width:100, align:'center'},
            { dataIndex: 'NOTE_NUM'                 ,width:100},
            { dataIndex: 'EXP_DATE'                 ,width:100},
            { dataIndex: 'CONF_RECE_NO'             ,width:100},
            { dataIndex: 'SEQ'                      ,width:50, align:'center'},
            { dataIndex: 'CONF_CHARGE_DATE'         ,width:100, align:'center'},
            { dataIndex: 'CONF_YN'                  ,width:100, align:'center'},
            { dataIndex: 'CONF_CHARGE_NO'           ,width:100}
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
        id  : 'arc400ukrApp',
        fnInitBinding : function() {
            UniAppManager.setToolbarButtons('reset',true);
            UniAppManager.setToolbarButtons(['newData', 'save', 'delete'], false);
            
            var activeSForm ;
            if(!UserInfo.appOption.collapseLeftSearch)  {
                activeSForm = panelSearch;
            }else {
                activeSForm = panelResult;
            }
            activeSForm.onLoadSelectText('MNG_DATE_FR');
            panelSearch.getField('CHARGE_YN').setValue('A');
            panelResult.getField('CHARGE_YN').setValue('A');
            panelSearch.getField('CONF_YN').setValue('A');
            panelResult.getField('CONF_YN').setValue('A');
            panelSearch.setValue('MNG_DATE_FR' , UniDate.get('startOfMonth'));
            panelSearch.setValue('MNG_DATE_TO' , UniDate.get('today'));
            
            panelResult.setValue('MNG_DATE_FR' , UniDate.get('startOfMonth'));
            panelResult.setValue('MNG_DATE_TO' , UniDate.get('today'));
            subForm.setValue('CONF_CHARGE_DATE', UniDate.get('today'));
            
            
            newYN1 = 'N';
            newYN2 = 'N';
        },
        onQueryButtonDown : function()   {
//            if(!panelResult.getInvalidMessage()) return;   //필수체크
            
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
            newYN1 = 'Y';
            newYN2 = 'Y';
            this.fnInitBinding();
        }
    });
};
</script>