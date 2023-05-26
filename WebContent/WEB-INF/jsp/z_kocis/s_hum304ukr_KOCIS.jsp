<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_hum304ukr_KOCIS"  >
    <t:ExtComboStore comboType="BOR120" pgmId="s_hum304ukr_KOCIS"/>     <!-- 사업장  -->
    <t:ExtComboStore comboType="AU" comboCode="H024" />                 <!-- 사원구분 -->
    <t:ExtComboStore comboType="AU" comboCode="H181" />                 <!-- 사원그룹 -->
    <t:ExtComboStore comboType="AU" comboCode="H011" />                 <!-- 고용형태 -->
    <t:ExtComboStore comboType="AU" comboCode="H028" />                 <!-- 급여지급방식 -->
    <t:ExtComboStore comboType="AU" comboCode="H031" />                 <!-- 급여지급차수 -->
    <t:ExtComboStore comboType="AU" comboCode="H005" />                 <!-- 직위 -->
    <t:ExtComboStore comboType="AU" comboCode="H089" />                 <!-- 교육기관 -->
    <t:ExtComboStore comboType="AU" comboCode="H090" />                 <!-- 교육국가 -->
    <t:ExtComboStore comboType="AU" comboCode="H091" />                 <!-- 교육구분 -->
    <t:ExtComboStore items="${COMBO_HUMAN_COST_POOL}" storeId="getHumanCostPool" /> <!--사업명-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

var excelWindow;    // 엑셀참조

function appMain() {
    
    var gsCostPool = '${CostPool}';  // H175 subCode 10의 Y/N 에 따라 값이 바뀜
    
    // 엑셀참조
    Unilite.Excel.defineModel('excel.hum304.sheet01', {
        fields: [
            //{name: 'DOC_ID'                   ,text:'DOC_ID'          ,type:'string' },
            {name: 'COMP_CODE'                  ,text:'법인코드'            ,type:'string' },
            {name: 'PERSON_NUMB'                ,text:'사번'              ,type:'string' },
            {name: 'NAME'                       ,text:'성명'              ,type:'string'  , allowBlank: false},
            
            {name: 'EDU_TITLE'                  ,text:'교육명'         ,type:'string'  ,maxLength:50 , allowBlank: false},
            {name: 'EDU_FR_DATE'                ,text:'교육시작일'           ,type:'uniDate' , allowBlank: false},
            {name: 'EDU_TO_DATE'                ,text:'교육종료일'           ,type:'uniDate' },
            {name: 'EDU_TIME'                   ,text:'교육시간'            ,type:'string' },
            {name: 'EDU_ORGAN'                  ,text:'교육기관'            ,type:'string' , maxLength:99},
            {name: 'EDU_NATION'                 ,text:'교육국가'            ,type:'string' },
            {name: 'EDU_GUBUN'                  ,text:'구분'              ,type:'string' },
            {name: 'EDU_GRADES'                 ,text:'이수점수'            ,type:'string'  ,maxLength:3},
            {name: 'EDU_AMT'                    ,text:'교육비'         ,type:'uniPrice',maxLength:10},
            {name: 'REPORT_YN'                  ,text:'Report 제출여부' ,type:'string' },
            {name: 'GRADE'                      ,text:'고과반영점수'      ,type:'string'  ,maxLength:3},
            
            {name: 'INSERT_DB_USER'             ,text:'입력자'         ,type:'string' },
            {name: 'INSERT_DB_TIME'             ,text:'입력일'         ,type:'uniDate'},
            {name: 'UPDATE_DB_USER'             ,text:'수정자'         ,type:'string' },
            {name: 'UPDATE_DB_TIME'             ,text:'수정일'         ,type:'uniDate'}
        ]
    });
    
    function openExcelWindow() {
        
            var me = this;
            var vParam = {};
            var appName = 'Unilite.com.excel.ExcelUploadWin';

            
            if(!excelWindow) {
                excelWindow =  Ext.WindowMgr.get(appName);
                excelWindow = Ext.create( appName, {
                        modal: false,
                        excelConfigName: 'hum304',
                        grids: [{
                                itemId: 'grid01',
                                title: '교육,연수사항양식',                             
                                useCheckbox: false,
                                model : 'excel.hum304.sheet01',
                                readApi: 's_hum304ukrService_KOCIS.selectExcelUploadSheet1',
                                columns: [        
                                    //{dataIndex: 'DIV_CODE'        , width: 100, hidden: true},                
                                    //{dataIndex: 'DEPT_NAME'       , width: 100, hidden: true},            
                                    //{dataIndex: 'POST_CODE'       , width: 100},              
                                    {dataIndex: 'PERSON_NUMB'   , width: 100},  
                                    {dataIndex: 'NAME'          , width: 100},  
                                    {dataIndex: 'EDU_TITLE'     , width: 120},  
                                    {dataIndex: 'EDU_FR_DATE'   , width: 100},  
                                    {dataIndex: 'EDU_TO_DATE'   , width: 100},  
                                    {dataIndex: 'EDU_TIME'      , width: 100},  
                                    {dataIndex: 'EDU_ORGAN'     , width: 100},  
                                    {dataIndex: 'EDU_NATION'    , width: 100},  
                                    {dataIndex: 'EDU_GUBUN'     , width: 100},  
                                    {dataIndex: 'EDU_GRADES'    , width: 100},  
                                    {dataIndex: 'EDU_AMT'       , width: 100},  
                                    {dataIndex: 'REPORT_YN'     , width: 100},  
                                    {dataIndex: 'GRADE'         , width: 100},  
                                    
                                    {dataIndex: 'UPDATE_DB_USER'    , width: 0, hidden: true},              
                                    {dataIndex: 'UPDATE_DB_TIME'    , width: 0, hidden: true}
                                    
                                ]
                        }],
                        listeners: {
                            close: function() {
                                this.hide();
                            }
                        },
                        onApply:function()  {
                            excelWindow.getEl().mask('로딩중...','loading-indicator');     ///////// 엑셀업로드 최신로직
                            var me = this;
                            var grid = this.down('#grid01');
                            var records = grid.getStore().getAt(0); 
                            var param = {"_EXCEL_JOBID": records.get('_EXCEL_JOBID')};
                            s_hum304ukrService_KOCIS.selectExcelUploadApply(param, function(provider, response){
                                var store = masterGrid.getStore();
                                var records = response.result;
                                
                                store.insert(0, records);
                                console.log("response",response)
                                excelWindow.getEl().unmask();
                                grid.getStore().removeAll();
                                me.hide();
                            });
                        }
                 });
            }
            excelWindow.center();
            excelWindow.show();
    }
    
    
    
    var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read : 's_hum304ukrService_KOCIS.selectList',
            update: 's_hum304ukrService_KOCIS.updateDetail',
            create: 's_hum304ukrService_KOCIS.insertDetail',
            destroy: 's_hum304ukrService_KOCIS.deleteDetail',
            syncAll: 's_hum304ukrService_KOCIS.saveAll'
        }
    });
    
    var ReportYNStore = Unilite.createStore('hum304ukrReportYNStore', {  // 그리드 상 Report 제출여부 Y : 1 , N : 2  
        fields: ['text', 'value'],
        data :  [
                    {'text':'예'     , 'value':'1'},
                    {'text':'아니오'   , 'value':'2'}
                ]
    });
    
    /**
     *   Model 정의 
     * @type 
     */
    Unilite.defineModel('hum304ukrModel', {
        fields: [
            {name: 'DOC_ID'                     ,text:'DOC_ID'          ,type:'string' },
            {name: 'COMP_CODE'                  ,text:'법인코드'            ,type:'string' },
            {name: 'DIV_CODE'                   ,text:'기관'          ,type:'string' , comboType: 'BOR120'},
            {name: 'DEPT_NAME'                  ,text:'부서'              ,type:'string' },
            {name: 'POST_CODE'                  ,text:'직위'              ,type:'string' , comboType:'AU', comboCode:'H005'},
            {name: 'NAME'                       ,text:'성명'              ,type:'string'  , allowBlank: false},
            {name: 'PERSON_NUMB'                ,text:'사번'              ,type:'string'},
            
            {name: 'EDU_TITLE'                  ,text:'교육명'         ,type:'string'  , allowBlank: false},
            {name: 'EDU_FR_DATE'                ,text:'교육시작일'           ,type:'uniDate' , allowBlank: false},
            {name: 'EDU_TO_DATE'                ,text:'교육종료일'           ,type:'uniDate' },
            {name: 'EDU_TIME'                   ,text:'교육시간'            ,type:'string' },
            {name: 'EDU_ORGAN'                  ,text:'교육기관'            ,type:'string' /*, comboType: 'AU', comboCode:'H089'*/},
            {name: 'EDU_NATION'                 ,text:'교욱국가'            ,type:'string' /*, comboType: 'AU', comboCode:'H090'*/},
            {name: 'EDU_GUBUN'                  ,text:'구분'              ,type:'string' , comboType: 'AU', comboCode:'H091'},
            {name: 'EDU_GRADES'                 ,text:'이수점수'            ,type:'string' },
            {name: 'EDU_AMT'                    ,text:'교육비'         ,type:'uniPrice' },
            {name: 'REPORT_YN'                  ,text:'Report 제출여부' ,type:'string' , store: Ext.data.StoreManager.lookup('hum304ukrReportYNStore')},
            {name: 'GRADE'                      ,text:'고과반영점수'      ,type:'string' },
            
            {name: 'INSERT_DB_USER'             ,text:'입력자'         ,type:'string' },
            {name: 'INSERT_DB_TIME'             ,text:'입력일'         ,type:'uniDate'},
            {name: 'UPDATE_DB_USER'             ,text:'수정자'         ,type:'string' },
            {name: 'UPDATE_DB_TIME'             ,text:'수정일'         ,type:'uniDate'}
        ]
    });
    
    /**
     * Store 정의(Service 정의)
     * @type 
     */                 
    var directMasterStore = Unilite.createStore('hum304ukrMasterStore',{
            model: 'hum304ukrModel',
            autoLoad: false,
            uniOpt : {
                isMaster: true,         // 상위 버튼 연결
                editable: true,         // 수정 모드 사용
                deletable:true,         // 삭제 가능 여부
                useNavi : false         // prev | newxt 버튼 사용
            },
            proxy: directProxy                          
            ,loadStoreRecords : function()  {
                var param= panelSearch.getValues();         
                console.log( param );
                this.load({ params : param});
            },
            // 수정/추가/삭제된 내용 DB에 적용 하기
            saveStore : function()  {               
                var inValidRecs = this.getInvalidRecords();
                console.log("inValidRecords : ", inValidRecs);
                
                var toCreate = this.getNewRecords();
                var toUpdate = this.getUpdatedRecords(); 
                
                var list = [].concat(toUpdate, toCreate);
                console.log("list:", list);
                                         
                if(inValidRecs.length == 0 )    {
                    config = {
                        success: function(batch, option) {      
                            panelResult.resetDirtyStatus();
                            UniAppManager.setToolbarButtons('save', false);     
                            masterGrid.getStore().loadStoreRecords();
                         } 
                    };  
                    this.syncAllDirect(config);     
                }else {
                    masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
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
            layout : {type : 'uniTable', columns : 1},
            items:[{
                fieldLabel: '기관',
                name:'DIV_CODE', 
                xtype: 'uniCombobox',
                multiSelect: true, 
                typeAhead: false,
                comboType:'BOR120',
                width: 325,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelResult.setValue('DIV_CODE', newValue);
                    }
                }
            }/*,
            Unilite.treePopup('DEPTTREE',{
                fieldLabel: '부서',
                valueFieldName:'DEPT',
                textFieldName:'DEPT_NAME' ,
                valuesName:'DEPTS' ,
                DBvalueFieldName:'TREE_CODE',
                DBtextFieldName:'TREE_NAME',
                selectChildren:true,
                textFieldWidth:89,
                validateBlank:true,
                width:300,
                autoPopup:true,
                useLike:true,
                listeners: {
                    'onValueFieldChange': function(field, newValue, oldValue  ){
                            panelResult.setValue('DEPT',newValue);
                    },
                    'onTextFieldChange':  function( field, newValue, oldValue  ){
                            panelResult.setValue('DEPT_NAME',newValue);
                    },
                    'onValuesChange':  function( field, records){
                            var tagfield = panelResult.getField('DEPTS') ;
                            tagfield.setStoreData(records)
                    }
                }
            })*/,
                Unilite.popup('Employee',{
                fieldLabel: '직원',
                valueFieldName:'PERSON_NUMB',
                textFieldName:'NAME',
                validateBlank:false,
                autoPopup:true,
                listeners: {
                    /*onSelected: {
                        fn: function(records, type) {
                            panelResult.setValue('PERSON_NUMB', panelSearch.getValue('PERSON_NUMB'));
                            panelResult.setValue('NAME', panelSearch.getValue('NAME'));                                                                                                         
                        },
                        scope: this
                    },
                    onClear: function(type) {
                        panelResult.setValue('PERSON_NUMB', '');
                        panelResult.setValue('NAME', '');
                    }*/
                    onValueFieldChange: function(field, newValue){
                        panelResult.setValue('PERSON_NUMB', newValue);                              
                    },
                    onTextFieldChange: function(field, newValue){
                        panelResult.setValue('NAME', newValue);             
                    }
                }
            }),{
                xtype: 'radiogroup',                            
                fieldLabel: '재직구분',
                items: [{
                    boxLabel: '전체', 
                    width: 70, 
                    name: 'RDO_TYPE',
                    inputValue: '' 
                },{
                    boxLabel : '재직', 
                    width: 70,
                    name: 'RDO_TYPE',
                    inputValue: 'A',
                    checked: true
                    
                },{
                    boxLabel: '퇴사', 
                    width: 70, 
                    name: 'RDO_TYPE',
                    inputValue: 'B' 
                }],
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelResult.getField('RDO_TYPE').setValue(newValue.RDO_TYPE);
                    }
                }
            },{
                fieldLabel: '교육명',
                name:'EDU_TITLE',
                xtype: 'uniTextfield',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelResult.setValue('EDU_TITLE', newValue);
                    }
                }
            },{     
                fieldLabel: '교육기간',
                xtype: 'uniDateRangefield',
                startFieldName: 'EDU_FR_DATE',
                endFieldName: 'EDU_TO_DATE',
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelResult) {
                        panelResult.setValue('EDU_FR_DATE', newValue);                      
                    }
                },
                onEndDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelResult) {
                        panelResult.setValue('EDU_FR_DATE', newValue);                          
                    }
                }
            },{
                fieldLabel: '교육기관',
                name:'EDU_ORGAN',
                xtype: 'uniTextfield',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelResult.setValue('EDU_ORGAN', newValue);
                    }
                }
            },{
                xtype: 'container',
                layout: {type : 'uniTable', columns : 3},
                width:325,
                items :[{
                    fieldLabel:'교육비', 
                    xtype: 'uniNumberfield',
                    name: 'EDU_FR_AMT', 
                    width:195,
                        listeners: {
                        change: function(field, newValue, oldValue, eOpts) {      
                            panelResult.setValue('EDU_FR_AMT', newValue);
                        }
                    }
                },{
                    xtype:'component', 
                    html:'~',
                    style: {
                        marginTop: '3px !important',
                        font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
                    }
                },{
                    fieldLabel:'', 
                    xtype: 'uniNumberfield',
                    name: 'EDU_TO_AMT', 
                    width: 110,
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {      
                            panelResult.setValue('EDU_TO_AMT', newValue);
                        }
                    }
                }]
            }]
        },{
                title:'추가정보',
                id: 'search_panel2',
                itemId:'search_panel2',
                defaultType: 'uniTextfield',
                layout : {type : 'uniTable', columns : 1},
                defaultType: 'uniTextfield',
                
                items:[{
                    fieldLabel: '고용형태',
                    name:'PAY_GUBUN',
                    xtype: 'uniCombobox',
                    comboType:'AU',
                    comboCode:'H011'
                },{
                    fieldLabel: '급여지급방식',
                    name:'PAY_CODE',
                    xtype: 'uniCombobox',
                    comboType:'AU',
                    comboCode:'H028'
                },{
                    fieldLabel: '급여차수',
                    name:'PAY_PROV_FLAG',
                    xtype: 'uniCombobox',
                    comboType:'AU',
                    comboCode:'H031'
                },{
                    fieldLabel: '사원그룹',
                    name:'PERSON_GROUP',
                    xtype: 'uniCombobox',
                    comboType:'AU',
                    comboCode:'H181'
                }]              
        }]
    }); 
    
    var panelResult = Unilite.createSimpleForm('panelResultForm', {
        hidden: !UserInfo.appOption.collapseLeftSearch,
        region: 'north',
        layout : {type : 'uniTable', columns : 3},
        padding:'1 1 1 1',
        border:true,
            items: [{
                fieldLabel: '기관',
                name:'DIV_CODE', 
                xtype: 'uniCombobox',
                multiSelect: true, 
                typeAhead: false,
                comboType:'BOR120',
                width: 325,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.setValue('DIV_CODE', newValue);
                    }
                }
            }/*,
            Unilite.treePopup('DEPTTREE',{
                fieldLabel: '부서',
                valueFieldName:'DEPT',
                textFieldName:'DEPT_NAME' ,
                valuesName:'DEPTS' ,
                selectChildren:true,
                DBvalueFieldName:'TREE_CODE',
                DBtextFieldName:'TREE_NAME',
                textFieldWidth:89,
                validateBlank:true,
                width:300,
                autoPopup:true,
                useLike:true,
                colspan:2,
                listeners: {
                    
                    'onValueFieldChange': function(field, newValue, oldValue  ){
                            panelSearch.setValue('DEPT',newValue);
                    },
                    'onTextFieldChange':  function( field, newValue, oldValue  ){
                            panelSearch.setValue('DEPT_NAME',newValue);
                    },
                    'onValuesChange':  function( field, records){
                            var tagfield = panelSearch.getField('DEPTS') ;
                            tagfield.setStoreData(records)
                    }
                }
            })*/,
            Unilite.popup('Employee',{
                fieldLabel: '직원',
                valueFieldName:'PERSON_NUMB',
                textFieldName:'NAME',
                colspan:2,
                validateBlank:false,
                autoPopup:true,
                listeners: {
                    /*onSelected: {
                        fn: function(records, type) {
                            panelSearch.setValue('PERSON_NUMB', panelResult.getValue('PERSON_NUMB'));
                            panelSearch.setValue('NAME', panelResult.getValue('NAME'));                                                                                                         
                        },
                        scope: this
                    },
                    onClear: function(type) {
                        panelSearch.setValue('PERSON_NUMB', '');
                        panelSearch.setValue('NAME', '');
                    }*/
                    
                    onValueFieldChange: function(field, newValue){
                        panelSearch.setValue('PERSON_NUMB', newValue);                              
                    },
                    onTextFieldChange: function(field, newValue){
                        panelSearch.setValue('NAME', newValue);             
                    }
                }
            }),{
                xtype: 'radiogroup',                            
                fieldLabel: '재직구분',
                items: [{
                    boxLabel: '전체', 
                    width: 70, 
                    name: 'RDO_TYPE',
                    inputValue: '' 
                },{
                    boxLabel : '재직', 
                    width: 70,
                    name: 'RDO_TYPE',
                    inputValue: 'A',
                    checked: true
                    
                },{
                    boxLabel: '퇴사', 
                    width: 70, 
                    name: 'RDO_TYPE',
                    inputValue: 'B' 
                }],
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.getField('RDO_TYPE').setValue(newValue.RDO_TYPE);
                    }
                }
            },{
                fieldLabel: '교육명',
                name:'EDU_TITLE',
                xtype: 'uniTextfield',
                colspan:2,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.setValue('EDU_TITLE', newValue);
                    }
                }
            },{     
                fieldLabel: '교육기간',
                xtype: 'uniDateRangefield',
                startFieldName: 'EDU_FR_DATE',
                endFieldName: 'EDU_TO_DATE',
                width: 350,             
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelSearch) {
                        panelSearch.setValue('EDU_FR_DATE', newValue);                      
                    }
                },
                onEndDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelSearch) {
                        panelSearch.setValue('EDU_TO_DATE', newValue);                          
                    }
                }
            },{
                fieldLabel: '교육기관',
                name:'EDU_ORGAN',
                xtype: 'uniTextfield',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.setValue('EDU_ORGAN', newValue);
                    }
                }
            },{
                xtype: 'container',
                layout: {type : 'uniTable', columns : 3},
                width:325,
                items :[{
                    fieldLabel:'교육비', 
                    xtype: 'uniNumberfield',
                    name: 'EDU_FR_AMT', 
                    width:195,
                        listeners: {
                        change: function(field, newValue, oldValue, eOpts) {      
                            panelSearch.setValue('EDU_FR_AMT', newValue);
                        }
                    }
                },{
                    xtype:'component', 
                    html:'~',
                    style: {
                        marginTop: '3px !important',
                        font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
                    }
                },{
                    fieldLabel:'', 
                    xtype: 'uniNumberfield',
                    name: 'EDU_TO_AMT', 
                    width: 110,
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {      
                            panelSearch.setValue('EDU_TO_AMT', newValue);
                        }
                    }
                }]
            }]
    });
    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('hum304ukrGrid1', {
        region: 'center',
        layout: 'fit',
        uniOpt: {
            expandLastColumn: false,
            copiedRow: true
//          useContextMenu: true,
        },
        features: [{
            id: 'masterGridSubTotal',
            ftype: 'uniGroupingsummary', 
            showSummaryRow: false 
        },{
            id: 'masterGridTotal',  
            ftype: 'uniSummary',      
            showSummaryRow: false
        }],
        tbar: [{
            xtype: 'splitbutton',
            itemId:'refTool',
            text: '참조...',
            iconCls : 'icon-referance',
            menu: Ext.create('Ext.menu.Menu', {
                items: [{
                    itemId: 'excelBtn',
                    text: '엑셀참조',
                    handler: function() {
                        openExcelWindow();
                    }
                }]
            })
        }],
        store: directMasterStore,
        columns:  [  
                //{ dataIndex: 'COMP_CODE'                  , width: 100},
                //{ dataIndex: 'DOC_ID'                     , width: 100},
                { dataIndex: 'DIV_CODE'                     , width: 120},
                { dataIndex: 'DEPT_NAME'                    , width: 160, hidden: true},
                { dataIndex: 'POST_CODE'                    , width: 88},
                { dataIndex: 'NAME'                         , width: 120, 
                'editor' : Unilite.popup('Employee_G',{
                        validateBlank : true,
                        autoPopup:true,
                        listeners: {'onSelected': {
                                            fn: function(records, type) {
                                                UniAppManager.app.fnHumanCheck(records);    
                                            },
                                            scope: this
                                        },
                                        'onClear': function(type) {
                                            var grdRecord = Ext.getCmp('hum304ukrGrid1').uniOpt.currentRecord;
                                            grdRecord.set('PERSON_NUMB','');
                                            grdRecord.set('NAME','');
                                            
                                            grdRecord.set('DIV_CODE','');
                                            grdRecord.set('DEPT_NAME','');
                                            grdRecord.set('POST_CODE','');          
                                        }
                            }
                        })
                },
                { dataIndex: 'PERSON_NUMB'                  , width: 78, hidden : true,
                'editor' : Unilite.popup('Employee_G',{
                        textFieldName:'PERSON_NUMB',
                        DBtextFieldName: 'PERSON_NUMB', 
                        validateBlank : true,
                        autoPopup:true,
                        listeners: {'onSelected': {
                                        fn: function(records, type) {
                                            UniAppManager.app.fnHumanCheck(records);    
                                        },
                                        scope: this
                                    },
                                    'onClear': function(type) {
                                        var grdRecord = Ext.getCmp('hum304ukrGrid1').uniOpt.currentRecord;
                                        grdRecord.set('PERSON_NUMB','');
                                        grdRecord.set('NAME','');
                                        
                                        grdRecord.set('DIV_CODE','');
                                        grdRecord.set('DEPT_NAME','');
                                        grdRecord.set('POST_CODE','');          
                                    }
                        }
                    })
                },
                { dataIndex: 'EDU_TITLE'                    , width: 250},
                { dataIndex: 'EDU_FR_DATE'                  , width: 100},
                { dataIndex: 'EDU_TO_DATE'                  , width: 100},
                { dataIndex: 'EDU_TIME'                     , width: 100},
                { dataIndex: 'EDU_ORGAN'                    , width: 180},
                { dataIndex: 'EDU_NATION'                   , width: 100},
                { dataIndex: 'EDU_GUBUN'                    , width: 100},
                { dataIndex: 'EDU_GRADES'                   , width: 88},
                { dataIndex: 'EDU_AMT'                      , width: 100},
                { dataIndex: 'REPORT_YN'                    , width: 110},
                { dataIndex: 'GRADE'                        , width: 100}
                
                //{ dataIndex: 'INSERT_DB_USER'             , width: 120},
                //{ dataIndex: 'INSERT_DB_TIME'             , width: 120},
                //{ dataIndex: 'UPDATE_DB_USER'             , width: 120},
                //{ dataIndex: 'UPDATE_DB_TIME'             , width: 120}
            ],
            listeners: {
                beforeedit: function( editor, e, eOpts ) {
                    /*if(e.record.phantom == true) {        // 신규일 때
                        if(UniUtils.indexOf(e.field, ['OCCUR_DATE'])) {
                            return false;
                        }
                    }*/
                    if(!e.record.phantom == true) { // 신규가 아닐 때
                        if(UniUtils.indexOf(e.field, ['NAME', 'PERSON_NUMB' ,'EDU_TITLE' ,'EDU_FR_DATE'])) {
                            return false;
                        }
                    }
                    if(!e.record.phantom == true || e.record.phantom == true) {     // 신규이던 아니던
                        if(UniUtils.indexOf(e.field, ['DIV_CODE', 'DEPT_NAME', 'POST_CODE'])) {
                            return false;
                        }
                    }
                }
            }
    });   
    
    Unilite.Main({
        borderItems:[{
         region:'center',
         layout: 'border',
         border: false,
         items:[
                masterGrid, panelResult
            ]
         },
             panelSearch
        ], 
        id  : 'hum304ukrApp',
        fnInitBinding : function() {
            panelSearch.setValue('DIV_CODE',UserInfo.divCode);
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
//            if(!Ext.isEmpty(gsCostPool)){
//                panelSearch.getField('COST_POOL').setFieldLabel(gsCostPool);  
//             }
            var activeSForm ;
            if(!UserInfo.appOption.collapseLeftSearch)  {
                activeSForm = panelSearch;
            }else {
                activeSForm = panelResult;
            }
            activeSForm.onLoadSelectText('PERSON_NUMB');
            
            panelSearch.getField('RDO_TYPE').setValue('A');
            panelResult.getField('RDO_TYPE').setValue('A');
            
            UniAppManager.setToolbarButtons(['reset', 'newData'],true);

            if(UserInfo.divCode == "01") {
                panelSearch.getField('DIV_CODE').setReadOnly(false);
                panelResult.getField('DIV_CODE').setReadOnly(false);
            }
            else {
                panelSearch.getField('DIV_CODE').setReadOnly(true);
                panelResult.getField('DIV_CODE').setReadOnly(true);
            }
        },
        onQueryButtonDown : function()  {
            if(!this.isValidSearchForm()){
                return false;
            }
            masterGrid.getStore().loadStoreRecords();
            UniAppManager.setToolbarButtons('reset', true);
        },
        onNewDataButtonDown: function() {
            var compCode         = UserInfo.compCode;
            
            var r ={
                COMP_CODE           : compCode
            };
            //param = {'SEQ':seq}
            masterGrid.createRow(r , 'NAME');
        },
        onResetButtonDown:function() {
            panelSearch.clearForm();
            panelResult.clearForm();
            masterGrid.getStore().loadData({});

            this.fnInitBinding();
        },
        onSaveDataButtonDown: function (config) {
            directMasterStore.saveStore(config);
        },
        onDeleteDataButtonDown : function() {
            masterGrid.deleteSelectedRow(); 
        },   
        fnHumanCheck: function(records) {
            grdRecord = masterGrid.getSelectedRecord();
            record = records[0];
            grdRecord.set('PERSON_NUMB', record.PERSON_NUMB);
            grdRecord.set('NAME', record.NAME);
            grdRecord.set('DIV_CODE', record.DIV_CODE);
            grdRecord.set('DEPT_NAME', record.DEPT_NAME);
            grdRecord.set('POST_CODE', record.POST_CODE);
            grdRecord.set('NAME', record.NAME);
        }
    });
    Unilite.createValidator('validator01', {
        store: directMasterStore,
        grid: masterGrid,
        validate: function( type, fieldName, newValue, oldValue, record, eopt) {
            console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
            var rv = true;
            
            switch(fieldName) {
                
                case "EDU_FR_DATE" : // 보증보험 시작일
                    if( 18891231 > UniDate.getDbDateStr(newValue) ){
                        rv="연도는 (1900 ~ 2999) 년 범위내의 값만 입력 할 수 있습니다.";
                        break;
                    }
                    if ( UniDate.getDbDateStr(newValue) > 30000101){
                        rv="연도는 (1900 ~ 2999) 년 범위내의 값만 입력 할 수 있습니다.";
                        break;
                    }
                    break;
                
                case "EDU_TO_DATE" : // 보증보험 시작일
                    if( 18891231 > UniDate.getDbDateStr(newValue) ){
                        rv="연도는 (1900 ~ 2999) 년 범위내의 값만 입력 할 수 있습니다.";
                        break;
                    }
                    if ( UniDate.getDbDateStr(newValue) > 30000101){
                        rv="연도는 (1900 ~ 2999) 년 범위내의 값만 입력 할 수 있습니다.";
                        break;
                    }
                    break;
            }
            return rv;
        }
        
    });
};

</script>
