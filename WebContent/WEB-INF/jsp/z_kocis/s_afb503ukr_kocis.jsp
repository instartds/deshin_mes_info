<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_afb503ukr_kocis"  >
	<t:ExtComboStore comboType="AU" comboCode="A390" /> <!-- 회계구분 -->
    <t:ExtComboStore comboType="AU" comboCode="A391" /> <!-- 원인행위 -->
    <t:ExtComboStore comboType="AU" comboCode="HE24" /> <!-- 월 -->
    <t:ExtComboStore items="${COMBO_DEPT_KOCIS}" storeId="deptKocis" /> <!--기관-->
	<t:ExtComboStore items="${COMBO_SAVE_CODE}" storeId="saveCode" /> <!--계좌코드-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	

<script type="text/javascript" >


var SAVE_FLAG = '';
var personName   = '${personName}';

var requestFlag = '';

var BsaCodeInfo = { 
    requestURL: '${appv_popup_url}'
};
var gsWin;
function appMain() {
	
	
	Unilite.defineModel('s_afb503ukr_kocisModel', {
        fields: [
          {name: 'COMP_CODE'        ,text: '법인코드'              ,type: 'string'},
          {name: 'AC_DATE'          ,text: '발의일자'              ,type: 'uniDate'},
          {name: 'DOC_NO'           ,text: '결의번호'              ,type: 'string'},
          {name: 'AC_GUBUN'         ,text: '회계구분'              ,type: 'string',comboType:'AU', comboCode:'A390'},
//          {name: 'AC_TYPE'          ,text: '원인행위'              ,type: 'string',comboType:'AU', comboCode:'A391'},
          {name: 'ACCT_NO'          ,text: '계좌'                 ,type: 'string'},
          {name: 'SAVE_NAME'        ,text: '계좌명'               ,type: 'string'},
          {name: 'BUDG_NAME_1'      ,text: '부문'                 ,type: 'string'},
          {name: 'BUDG_NAME_4'      ,text: '세부사업'              ,type: 'string'},
          {name: 'BUDG_NAME_6'      ,text: '세목'                 ,type: 'string'},
          {name: 'BUDG_CODE'        ,text: '세목코드'              ,type: 'string'},
          {name: 'WON_AMT'          ,text: '금액(현지화)'           ,type: 'uniPrice'},
          {name: 'REMARK'           ,text: '적요'                 ,type: 'string'}
        ]
    });
    
    
    
    
    
    /**
     * KOCIS 예산과목 1 level   (부문 콤보코드 관련)
     * @type String
     */
    var fnGetBudgCodeLevel1Store = Unilite.createStore('fnGetBudgCodeLevel1Store',{
        proxy: {
            type: 'direct',
            api: {          
                read: 'UniliteComboServiceImpl.fnGetBudgCodeLevel1'                   
            }
        },
        loadStoreRecords: function(comboStore) {
            var param= Ext.getCmp('panelResult').getValues();    
//            param.AC_YYYY = UniDate.getDbDateStr(panelResult.getValue('AC_YEAR'));
            param.AC_YYYY = panelResult.getValue('AC_YEAR');
            this.load({
                params : param,
                callback : function(records,options,success)    {
                    var loadDataStore = comboStore;
                    if(success) {
                        if(loadDataStore){
                            loadDataStore.loadData(records.items);
                        }
                    }
                }
            });
        }
    });
    
    /**
     * KOCIS 예산과목 3 level   (세부사업 콤보코드 관련)
     * @type String
     */
    var fnGetBudgCodeLevel3Store = Unilite.createStore('fnGetBudgCodeLevel3Store',{
        proxy: {
            type: 'direct',
            api: {          
                read: 'UniliteComboServiceImpl.fnGetBudgCodeLevel3'                   
            }
        },
        loadStoreRecords: function(comboStore) {
            var param= Ext.getCmp('panelResult').getValues();    
            param.AC_YYYY = panelResult.getValue('AC_YEAR');
            if(!Ext.isEmpty(panelResult.getValue('BUDG_CODE_LV1'))){
                param.BUDG_CODE = panelResult.getValue('BUDG_CODE_LV1');
            }else{
            	param.BUDG_CODE = '9999999';
            }
            this.load({
                params : param,
                callback : function(records,options,success)    {
                    var loadDataStore = comboStore;
                    if(success) {
                        if(loadDataStore){
                            loadDataStore.loadData(records.items);
                        }
                    }
                }
            });
        }
    });
    
    /**
     * KOCIS 예산과목 6 level   (세부사업 콤보코드 관련)
     * @type String
     */
    var fnGetBudgCodeLevel6Store = Unilite.createStore('fnGetBudgCodeLevel6Store',{
        proxy: {
            type: 'direct',
            api: {          
                read: 'UniliteComboServiceImpl.fnGetBudgCodeLevel6'                   
            }
        },
        loadStoreRecords: function(comboStore) {
            var param= Ext.getCmp('panelResult').getValues();    
            param.AC_YYYY = panelResult.getValue('AC_YEAR');
            if(!Ext.isEmpty(panelResult.getValue('BUDG_CODE_LV4'))){
                param.BUDG_CODE = panelResult.getValue('BUDG_CODE_LV4');
            }else{
                param.BUDG_CODE = '9999999';
            }
            this.load({
                params : param,
                callback : function(records,options,success)    {
                    var loadDataStore = comboStore;
                    if(success) {
                        if(loadDataStore){
                            loadDataStore.loadData(records.items);
                        }
                    }
                }
            });
        }
    });
    
    /**
     * KOCIS 예산과목 (예산과목 콤보코드 관련)
     * @type String
     */
    var fnGetBudgCodeStore = Unilite.createStore('fnGetBudgCodeStore',{
        proxy: {
            type: 'direct',
            api: {
                read: 'UniliteComboServiceImpl.fnGetBudgCode'                   
            }
        },
        loadStoreRecords: function(comboStore) {
            var param= Ext.getCmp('resultForm').getValues();
            if(!Ext.isEmpty(detailForm.getValue('AC_DATE'))){
                param.AC_YYYY = UniDate.getDbDateStr(detailForm.getValue('AC_DATE')).substring(0,4);
            }else{
            	param.AC_YYYY = '';
            }
            param.BUDG_TYPE = '2';
            this.load({
                params : param,
                callback : function(records,options,success)    {
                    var loadDataStore = comboStore;
                    if(success) {
                        if(loadDataStore){
                            loadDataStore.loadData(records.items);
                        }
                    }
                }
            });
        }
    });
    /**
     * Store 정의(Service 정의)
     * @type 
     */                 
    var searchStore = Unilite.createStore('s_afb503ukr_kocisSearchStore', {
        model: 's_afb503ukr_kocisModel',
        uniOpt: {
            isMaster: true,         // 상위 버튼 연결 
            editable: false,            // 수정 모드 사용 
            deletable: false,           // 삭제 가능 여부 
            allDeletable:false,
            useNavi : false         // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {
                read: 's_afb503ukrkocisService.selectList'                 
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
        },
        loadStoreRecords: function() {
            var param = Ext.getCmp('panelResult').getValues();
            
   /*         var startField = panelSearch.getField('AC_DATE_FR');
            var startDateValue = startField.getStartDate();
            var endField = panelSearch.getField('AC_DATE_TO');
            var endDateValue = endField.getEndDate(); 
            
            param.AC_DATE_FR = startDateValue;
            param.AC_DATE_TO = endDateValue;*/
            
            console.log( param );
            this.load({
                params: param
            });
        }
    }); 
	
	
	var panelSearch = Unilite.createSearchPanel('panelSearch', {          
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
                xtype: 'uniCombobox',
                fieldLabel: '기관',
                name: 'DEPT_CODE',
                store: Ext.data.StoreManager.lookup('deptKocis'),
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('DEPT_CODE', newValue);
                    }
                }
            },{
                xtype: 'uniCombobox',
                fieldLabel: '회계구분',
                name: 'AC_GUBUN',
                comboType: 'AU',
                comboCode: 'A390',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('AC_GUBUN', newValue);
                    }
                }
            },{
                xtype: 'uniYearField',
                fieldLabel: '회계년도',
                name: 'AC_YEAR',
                allowBlank:false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('AC_YEAR', newValue);
                        
                        panelSearch.setValue('BUDG_CODE_LV1', '');
                        panelResult.setValue('BUDG_CODE_LV1', '');
                        panelSearch.setValue('BUDG_CODE_LV4', '');
                        panelResult.setValue('BUDG_CODE_LV4', '');
                        panelSearch.setValue('BUDG_CODE_LV6', '');
                        panelResult.setValue('BUDG_CODE_LV6', '');
                    }
                }
            },{
                xtype: 'uniCombobox',
                fieldLabel: '발생월',
                name: 'AC_MONTH_FR',
                comboType: 'AU',
                comboCode: 'HE24',
                allowBlank:false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('AC_MONTH_FR', newValue);
                    }
                }
            },{
                xtype: 'uniCombobox',
                fieldLabel: '~',
                name: 'AC_MONTH_TO',
                comboType: 'AU',
                comboCode: 'HE24',
                allowBlank:false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('AC_MONTH_TO', newValue);
                    }
                }
            },
            /*{ 
                fieldLabel: '회계년월',
                xtype: 'uniMonthRangefield',
                startFieldName: 'AC_DATE_FR',
                endFieldName: 'AC_DATE_TO',
                startDD: 'first',
                endDD: 'last',
                allowBlank: false,
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelResult) {
                        panelResult.setValue('AC_DATE_FR',newValue);
                    }
                },
                onEndDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelResult) {
                        panelResult.setValue('AC_DATE_TO',newValue);
                    }
                }
            },
            			*/
            				
         /*   					
            						{
                xtype: 'uniCombobox',
                fieldLabel: '회계년도',
                name: 'AC_YEAR',
                comboType: 'AU',
                comboCode: '',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('AC_YEAR', newValue);
                    }
                }
            },{
                xtype: 'uniCombobox',
                fieldLabel: '발생월',
                name: 'AC_MONTH',
                comboType: 'AU',
                comboCode: '',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('AC_MONTH', newValue);
                    }
                }
            },*/
            	
            		
            			
            				
            	/*				
            						{
                xtype: 'uniCombobox',
                fieldLabel: '원인행위',
                name: 'AC_TYPE',
                comboType: 'AU',
                comboCode: 'A391',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('AC_TYPE', newValue);
                    }
                }
            },*/
            
            

            {   
                xtype: 'uniCombobox',
                fieldLabel: '부문',
                name: 'BUDG_CODE_LV1',
                store:fnGetBudgCodeLevel1Store,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('BUDG_CODE_LV1', newValue);
                        panelSearch.setValue('BUDG_CODE_LV4', '');
                        panelResult.setValue('BUDG_CODE_LV4', '');
                        panelSearch.setValue('BUDG_CODE_LV6', '');
                        panelResult.setValue('BUDG_CODE_LV6', '');
//                        fnGetBudgCodeLevel3Store.loadStoreRecords();
                    },
                    beforequery:function( queryPlan, eOpts )    {
                        fnGetBudgCodeLevel1Store.loadStoreRecords();
                    }
                }
            },
            	
            //화면 처음 오픈 후 첫번째 클릭시 콤보 생성 안되는 현상 두번 클릭 시 생성 되고 그후 부터 한번 클릭시 생성 되는 현상 확인필요  20170425
            {
                xtype: 'uniCombobox',
                fieldLabel: '세부사업',
                name: 'BUDG_CODE_LV4',
                store:fnGetBudgCodeLevel3Store,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('BUDG_CODE_LV4', newValue);
                        
                        panelSearch.setValue('BUDG_CODE_LV6', '');
                        panelResult.setValue('BUDG_CODE_LV6', '');
//                        fnGetBudgCodeLevel6Store.loadStoreRecords();
                    },
                    beforequery:function( queryPlan, eOpts )    {
                        fnGetBudgCodeLevel3Store.loadStoreRecords();
                    }
                }
            },{
                xtype: 'uniCombobox',
                fieldLabel: '목/세목',
                name: 'BUDG_CODE_LV6',
                store:fnGetBudgCodeLevel6Store,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('BUDG_CODE_LV6', newValue);
                    },
                    beforequery:function( queryPlan, eOpts )    {
                        fnGetBudgCodeLevel6Store.loadStoreRecords();
                    }
                }
            },{
                xtype: 'uniTextfield',
                fieldLabel: '검색어',
                name: 'REMARK',
                width:300,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('REMARK', newValue);
                    }
                }
            }]
        }]
	});
	
	var panelResult = Unilite.createSearchForm('panelResult',{
        region: 'north',
        layout : {type : 'uniTable', columns : 4},
        padding:'1 1 1 1',
        border:true,
        hidden: !UserInfo.appOption.collapseLeftSearch,
        items: [{
            xtype: 'uniCombobox',
            fieldLabel: '기관',
            name: 'DEPT_CODE',
            store: Ext.data.StoreManager.lookup('deptKocis'),
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.setValue('DEPT_CODE', newValue);
                }
            }
        },{
            xtype: 'uniCombobox',
            fieldLabel: '회계구분',
            name: 'AC_GUBUN',
            comboType: 'AU',
            comboCode: 'A390',
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.setValue('AC_GUBUN', newValue);
                }
            }
        },
        	
        {
            xtype: 'uniYearField',
            fieldLabel: '회계년도',
            name: 'AC_YEAR',
            allowBlank:false,
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.setValue('AC_YEAR', newValue);
                    
                    panelSearch.setValue('BUDG_CODE_LV1', '');
                    panelResult.setValue('BUDG_CODE_LV1', '');
                    panelSearch.setValue('BUDG_CODE_LV4', '');
                    panelResult.setValue('BUDG_CODE_LV4', '');
                    panelSearch.setValue('BUDG_CODE_LV6', '');
                    panelResult.setValue('BUDG_CODE_LV6', '');
                }
            }
        },{
            xtype: 'container',
            layout: {type: 'uniTable', columns: 3},
            padding:'0 0 0 0',
            items: [{
                xtype: 'uniCombobox',
                fieldLabel: '발생월',
                name: 'AC_MONTH_FR',
                comboType: 'AU',
                comboCode: 'HE24',
                width:200,
                allowBlank:false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelSearch.setValue('AC_MONTH_FR', newValue);
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
                xtype: 'uniCombobox',
                fieldLabel: '',
                name: 'AC_MONTH_TO',
                comboType: 'AU',
                comboCode: 'HE24',
                width:105,
                allowBlank:false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelSearch.setValue('AC_MONTH_TO', newValue);
                    }
                }
            }]
        },
        			
/*        				
		{ 
            fieldLabel: '회계년월',
            xtype: 'uniMonthRangefield',
            startFieldName: 'AC_DATE_FR',
            endFieldName: 'AC_DATE_TO',
            startDD: 'first',
            endDD: 'last',
            allowBlank: false,
            colspan:2,
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
                if(panelSearch) {
                    panelSearch.setValue('AC_DATE_FR',newValue);
                }
            },
            onEndDateChange: function(field, newValue, oldValue, eOpts) {
                if(panelSearch) {
                    panelSearch.setValue('AC_DATE_TO',newValue);
                }
            }
        },	*/
        		
        			
        				
   /*     					{
            xtype: 'uniCombobox',
            fieldLabel: '회계년도',
            name: 'AC_YEAR',
            comboType: 'AU',
            comboCode: '',
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.setValue('AC_YEAR', newValue);
                }
            }
        },{
            xtype: 'uniCombobox',
            fieldLabel: '발생월',
            name: 'AC_MONTH',
            comboType: 'AU',
            comboCode: '',
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.setValue('AC_MONTH', newValue);
                }
            }
        },*/
        	
        		
        			/*
        				{
            xtype: 'uniCombobox',
            fieldLabel: '원인행위',
            name: 'AC_TYPE',
            comboType: 'AU',
            comboCode: 'A391',
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.setValue('AC_TYPE', newValue);
                }
            }
        },*/{
            xtype: 'uniCombobox',
            fieldLabel: '부문',
            name: 'BUDG_CODE_LV1',
            store:fnGetBudgCodeLevel1Store,
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.setValue('BUDG_CODE_LV1', newValue);
                    panelSearch.setValue('BUDG_CODE_LV4', '');
                    panelResult.setValue('BUDG_CODE_LV4', '');
                    panelSearch.setValue('BUDG_CODE_LV6', '');
                    panelResult.setValue('BUDG_CODE_LV6', '');
                },
                beforequery:function( queryPlan, eOpts )    {
                    fnGetBudgCodeLevel1Store.loadStoreRecords();
                }
            }
        },{
            xtype: 'uniCombobox',
            fieldLabel: '세부사업',
            name: 'BUDG_CODE_LV4',
            store:fnGetBudgCodeLevel3Store,
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.setValue('BUDG_CODE_LV4', newValue);
                    panelSearch.setValue('BUDG_CODE_LV6', '');
                    panelResult.setValue('BUDG_CODE_LV6', '');
                },
                beforequery:function( queryPlan, eOpts )    {
                    fnGetBudgCodeLevel3Store.loadStoreRecords();
                }
            }
        },{
            xtype: 'uniCombobox',
            fieldLabel: '목/세목',
            name: 'BUDG_CODE_LV6',
            store:fnGetBudgCodeLevel6Store,
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.setValue('BUDG_CODE_LV6', newValue);
                },
                beforequery:function( queryPlan, eOpts )    {
                    fnGetBudgCodeLevel6Store.loadStoreRecords();
                }
            }
        },{
            xtype: 'uniTextfield',
            fieldLabel: '검색어',
            name: 'REMARK',
            width:350,
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.setValue('REMARK', newValue);
                }
            }
        }/*,{
        	xtype:'uniTextfield',
        	name:'DEPT_CODE',
        	hidden:false
        	
        }*/
        
        ]
    });
	
	
	
	
	
	
	
	var searchGrid = Unilite.createGrid('s_afb503ukr_kocisGrid', {
//      split:true,
        layout: 'fit',
        region: 'center',
        excelTitle: '세출예산등록',
        height:300,
        uniOpt: {
            useGroupSummary: false,
            useLiveSearch: true,
            useContextMenu: false,
            useMultipleSorting: true,
            onLoadSelectFirst: false,
            useRowNumberer: true,
            expandLastColumn: true,
            useRowContext: false,
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
            showSummaryRow: true,
            dock:'bottom'
        }],
        store: searchStore,
        selModel:'rowmodel',
        columns: [
            { dataIndex: 'COMP_CODE'            ,width:100,hidden:true},
            { dataIndex: 'AC_DATE'              ,width:100,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                   return Unilite.renderSummaryRow(summaryData, metaData, '소계', '합계');
                }
            },
            { dataIndex: 'DOC_NO'               ,width:80},
            { dataIndex: 'AC_GUBUN'             ,width:80},
//            { dataIndex: 'AC_TYPE'              ,width:100},
            { dataIndex: 'ACCT_NO'              ,width:150,hidden:true},
            { dataIndex: 'SAVE_NAME'            ,width:150},
            { dataIndex: 'BUDG_NAME_1'          ,width:150},
            { dataIndex: 'BUDG_NAME_4'          ,width:150},
            { dataIndex: 'BUDG_NAME_6'          ,width:150},
            { dataIndex: 'BUDG_CODE'            ,width:200,hidden:true},
            { dataIndex: 'WON_AMT'              ,width:120,summaryType:'sum'},
            { dataIndex: 'REMARK'               ,width:200}
        ],
        listeners: {
            selectionchangerecord:function(selected){
            	detailForm.setValue('AC_DATE',selected.data.AC_DATE);
                detailForm.setValue('DOC_NO',selected.data.DOC_NO);
                detailForm.setValue('AC_GUBUN',selected.data.AC_GUBUN);
                detailForm.setValue('ACCT_NO',selected.data.ACCT_NO);
                detailForm.setValue('BUDG_CODE',selected.data.BUDG_CODE);
                detailForm.setValue('WON_AMT',selected.data.WON_AMT);
                detailForm.setValue('REMARK',selected.data.REMARK);
                
                SAVE_FLAG= 'U';
                
                detailForm.getField('AC_DATE').setReadOnly(true);
                detailForm.getField('AC_GUBUN').setReadOnly(true);
                detailForm.getField('ACCT_NO').setReadOnly(true);
                
                
            }
        }
    });   
	
    
    var detailForm = Unilite.createForm('resultForm',{
        title:'● 예산(수입)결의 수정',
//      split:true,
//      width:750,
//      height:200,
        height:240,
        region: 'center',
        layout : {type : 'uniTable', columns : 2,
        tableAttrs: {width:'100%'}
//            tableAttrs: { /*style: 'border : 1px solid #ced9e7;',*/width: 1000},//'100%'}
//          tdAttrs: {style: 'border : 1px solid #ced9e7;'/*,width: '100%'*/}//width: '100%'/*,align : 'left'*/}
    
        },
        padding:'1 1 1 1',
        border:true,
        disabled:false,
        tbar:[{
            xtype:'button',
            itemId:'resetButton',
            text:'초기화',
            handler: function() {
                detailForm.clearForm();
                UniAppManager.app.fnInitInputFieldsDetailForm();
                SAVE_FLAG = 'N';
                detailForm.getField('AC_DATE').setReadOnly(false);
                detailForm.getField('AC_GUBUN').setReadOnly(false);
                detailForm.getField('ACCT_NO').setReadOnly(false);
            }
        },{
                xtype:'button',
                itemId:'saveButton',
                text:'저장',
                handler: function() {
                    //필수 체크 관련 확인필요
                    if(!detailForm.getInvalidMessage()){
                        return;
                    }/*else{
                            
                    }*/
                    Ext.getCmp('pageAll').getEl().mask('저장 중...','loading-indicator');
                    var param = detailForm.getValues();
                    param.SAVE_FLAG = SAVE_FLAG;
                    detailForm.getForm().submit({
                    params : param,
                        success : function(form, action) {
                            detailForm.getForm().wasDirty = false;
                            detailForm.resetDirtyStatus();
                            UniAppManager.setToolbarButtons('save', false);
                            UniAppManager.updateStatus(Msg.sMB011);// 저장되었습니다
//                            if(SAVE_FLAG == ''){
//                                detailForm.setValue('DOC_NO',action.result.DOC_NO);
//                            }
                            detailForm.setValue('DOC_NO',action.result.DOC_NO);
                            Ext.getCmp('pageAll').getEl().unmask();  
                            UniAppManager.app.onQueryButtonDown();
                            SAVE_FLAG = 'U';
                            
                            detailForm.getField('AC_DATE').setReadOnly(true);
                            detailForm.getField('AC_GUBUN').setReadOnly(true);
                            detailForm.getField('ACCT_NO').setReadOnly(true);
                        },
                        failure: function(){
                            Ext.getCmp('pageAll').getEl().unmask();  
                        }
                    });
                }
            },{
                xtype:'button',
                itemId:'deleteButton',
                text:'삭제',
                handler: function() {
                    if(!Ext.isEmpty(detailForm.getValue('DOC_NO'))){
                        if(confirm('현재 데이터를 삭제 합니다.\n 삭제 하시겠습니까?')) {
                            var param = detailForm.getValues();
                            param.SAVE_FLAG = 'D';
                            detailForm.getForm().submit({
                                params : param,
                                success : function(form, action) {
                                    detailForm.getForm().wasDirty = false;
                                    detailForm.resetDirtyStatus();                                          
            //                      UniAppManager.setToolbarButtons(['delete','save'],false);
                                    UniAppManager.updateStatus(Msg.sMB011);// 저장되었습니다
                                    
                                    detailForm.clearForm();
                                    UniAppManager.app.fnInitInputFieldsDetailForm();
                                    searchStore.loadStoreRecords(); 
                                    
                                    SAVE_FLAG = '';
                                    
                                    detailForm.getField('AC_DATE').setReadOnly(false);
                                    detailForm.getField('AC_GUBUN').setReadOnly(false);
                                    detailForm.getField('ACCT_NO').setReadOnly(false);
                                }   
                            });
                        }
                    }else{
                        alert('삭제할 데이터가 없습니다.');
                    }
                }
            }],
        items: [{
            xtype: 'container',
            layout: {type: 'uniTable', columns: 2},
//            tdAttrs: {align : 'right',style: 'border : 1px solid #FFFFFF;'},
            padding:'0 0 10 0',
            items: [{
                xtype: 'uniDatefield',
                fieldLabel: '발의일자',
                name: 'AC_DATE',
                value: UniDate.get('today'),
                allowBlank:false
                
            },{
                xtype: 'uniCombobox',
                fieldLabel: '회계구분',
                name:'AC_GUBUN',   
                comboType:'AU',
                comboCode:'A390',
                allowBlank:false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        detailForm.setValue('ACCT_NO', '');
                        detailForm.setValue('BUDG_CODE', '');
                        fnGetBudgCodeStore.loadStoreRecords();
                    }
                }
            },{
                xtype: 'uniTextfield',
                fieldLabel:'결의번호', 
                name: 'DOC_NO',
                readOnly:true
                 
            },{
                xtype: 'uniCombobox',
                fieldLabel: '계좌코드',
                name:'ACCT_NO',   
                store: Ext.data.StoreManager.lookup('saveCode'),
                allowBlank:false,
                listeners:{
                    beforequery:function(queryPlan, eOpts){
                        var store = queryPlan.combo.store;
                            store.clearFilter();
                        store.filterBy(function(record){
                            return record.get('refCode1') == detailForm.getValue('AC_GUBUN');
                        })
                        /*if(masterForm.down('#evdeTypeCd').getValue().EVDE_TYPE_CD == '10'){
                            store.filterBy(function(record){
                                return record.get('refCode1') == '10';
                            })
                        }else if(masterForm.down('#evdeTypeCd').getValue().EVDE_TYPE_CD == '20'){
                            store.filterBy(function(record){
                                return record.get('refCode1') == '20';
                            })
                        }else if(masterForm.down('#evdeTypeCd').getValue().EVDE_TYPE_CD == '30'){
                            store.filterBy(function(record){
                                return record.get('refCode1') == '30';
                            })
                        }*/
                    },
                    collapse:function(field, eOpts){
                        field.getStore().clearFilter();
                    },
                    
                    
                    change: function(field, newValue, oldValue, eOpts) {
                        detailForm.setValue('BUDG_CODE', '');
                        fnGetBudgCodeStore.loadStoreRecords();
                    }
                }
    //            allowBlank:false
            },{
                xtype: 'uniCombobox',
                fieldLabel: '예산과목',
                name:'BUDG_CODE',  
                store:fnGetBudgCodeStore,
                width:400,
    //            valueWidth:10,
                allowBlank:false,
                listeners:{
                    beforequery:function(queryPlan, eOpts){
                        var store = queryPlan.combo.store;
                            store.clearFilter();
                        store.filterBy(function(record){
                            if(Ext.isEmpty(detailForm.getValue('AC_GUBUN')) || Ext.isEmpty(detailForm.getValue('ACCT_NO'))){
                            	return '';
                            }else{
                                return record.get('refCode1') == detailForm.getValue('AC_GUBUN');
                            }
                        })
                    },
                    collapse:function(field, eOpts){
                        field.getStore().clearFilter();
                    }
                }
                
                
                
                
               /* listeners: {
                    beforequery:function( queryPlan, eOpts )    {
                        fnGetBudgCodeStore.loadStoreRecords();
                    }
                }*/
            },{
                xtype: 'uniNumberfield',
                fieldLabel:'금액(현지화)',
                name: 'WON_AMT',
                decimalPrecision:2,
                allowBlank:false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        if(newValue < 0){
                            alert('금액이 0보다 작을수 없습니다.');
                            detailForm.setValue('WON_AMT',0);
                        }
                    }
                }
            },{
                xtype: 'uniTextfield',
                fieldLabel:'적요', 
                name: 'REMARK',
                width:650,
                colspan:2,
                allowBlank:false
            },{
                xtype:'uniTextfield',
                name:'DEPT_CODE',
                readOnly:true,
                hidden:true,
                allowBlank:false
                
            }]    
        }],
        api: {
//            load: 's_afb503ukrkocisService.selectForm' ,
            submit: 's_afb503ukrkocisService.syncMaster'    
        },
        listeners : {
            uniOnChange:function( basicForm, dirty, eOpts ) {
                console.log("onDirtyChange");
            
            }
        }
    });
    
    Unilite.Main( {
		/*borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			id:'pageAll',
			items:[
				detailForm, subForm1, subForm2, detailGrid
			]	
		}],*/
    	borderItems:[{
            region: 'center',
            layout: {type: 'vbox', align: 'stretch'},
            border: false,
            autoScroll: true,
            id:'pageAll',
            items: [
            	panelResult, searchGrid,detailForm
            		
          /*  			{
                region: 'north',
                xtype: 'container',
                layout: {type:'vbox', align: 'stretch'},
                items: [panelResult, searchGrid]
            },{
                region: 'center',
                xtype: 'container',
                padding:'5 1 1 1',
                layout: {type: 'vbox', align: 'stretch'},
                items:[detailForm]
            }*/
            
            
            ]
        },
            panelSearch],
		id  : 's_afb503ukr_kocisApp',
		fnInitBinding: function(params){
			var activeSForm ;
            if(!UserInfo.appOption.collapseLeftSearch)  {
                activeSForm = panelSearch;
            }else {
                activeSForm = panelResult;
            }
            UniAppManager.app.fnInitInputFields();
            UniAppManager.app.fnInitInputFieldsDetailForm();
//            activeSForm.onLoadSelectText('GL_DATE_FR');   
			
//			this.setDefault(params);
			UniAppManager.setToolbarButtons(['newData','save','print'], false);
            UniAppManager.setToolbarButtons(['reset'/*,'print'*/], true);
            
//            detailForm.onLoadSelectText('RECE_DATE');
		},
		onQueryButtonDown: function() {
			if(!panelResult.getInvalidMessage()) return;   //필수체크
            searchStore.loadStoreRecords();
			
	/*
				var param= detailForm.getValues();
				
				detailForm.getForm().load({
					params: param,
					success: function(form, action) {
						
						SAVE_FLAG = action.result.data.SAVE_FLAG;
						
						
//						detailForm.unmask();
						
						
						subForm1.getForm().load({
							params: param,
							success: function(form, action) {
						
//								subForm1.unmask();
						
							},
							failure: function(form, action) {
//								subForm1.unmask();
							}
						})
						
						
						
						if(SAVE_FLAG == 'U'){
							UniAppManager.setToolbarButtons('delete',true);	
						}
						detailForm.getField('RECE_DATE').focus();  
					},
					failure: function(form, action) {
//						detailForm.unmask();
//						subForm1.unmask();
					}
				});
				searchStore.loadStoreRecords();	
				
				UniAppManager.setToolbarButtons('reset',true);
//				panelResult.setAllFieldsReadOnly(true);
				
//			}
				
				*/
		},
/*		onNewDataButtonDown: function()	{
			if(!panelResult.getInvalidMessage()) return;	//필수체크
		
//			 var compCode = UserInfo.compCode;
        	 
        	 var r = {
			
//				COMP_CODE: compCode
	        };
			detailGrid.createRow(r);
		},*/
		onResetButtonDown: function() {
//			panelSearch.clearForm();
            panelSearch.clearForm();
            panelResult.clearForm();
			detailForm.clearForm();
			searchGrid.reset();
			searchStore.clearData();
			UniAppManager.app.fnInitInputFields();
            UniAppManager.app.fnInitInputFieldsDetailForm();
			UniAppManager.setToolbarButtons(['newData','save','delete'], false);
			UniAppManager.setToolbarButtons(['reset'], true);
			
			SAVE_FLAG = 'N';
			
		},
		
		
		/*onDeleteAllButtonDown: function() {			
			var records = directDetailStore.data.items;
			var isNewData = false;
			Ext.each(records, function(record,i) {
				if(record.phantom){						//신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				}else{									//신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					if(confirm('전체삭제 하시겠습니까?')) {
						var deletable = true;
						if(deletable){		
							detailGrid.reset();			
							UniAppManager.app.onSaveDataButtonDown();	
						}
						isNewData = false;							
					}
					return false;
				}
			});
			if(isNewData){								//신규 레코드들만 있을시 그리드 리셋		   
				detailGrid.reset();
				UniAppManager.app.onResetButtonDown();	//삭제후 RESET..
			}
		},*/
		setDefault: function(params){
			
			if(!Ext.isEmpty(params.RECE_NO)){
				this.processParams(params);
			}else{
				UniAppManager.app.fnInitInputFields();	
                UniAppManager.app.fnInitInputFieldsDetailForm();				
			}
		},
/*		onPrintButtonDown: function() {
	         //var records = panelSearch.down('#imageList').getSelectionModel().getSelection();
	         var param= Ext.getCmp('resultForm').getValues();
	         
	         var prgId = '';
	         
	         
//	         if(라디오 값에따라){
//	         	prgId = 'arc100rkr';	
//	         }else if{
//	         	prgId = 'abh221rkr';
//	         }
	         
	         
	         var win = Ext.create('widget.PDFPrintWindow', {
	            url: CPATH+'/abh/arc100rkrPrint.do',
//	            prgID:prgId,
	            prgID: 'arc100rkr',
	               extParam: {
	                    COMP_CODE:       	param.COMP_CODE       
//						INOUT_SEQ:  	    param.INOUT_SEQ,  	 
//						INOUT_NUM:          param.INOUT_NUM,      
//						DIV_CODE:           param.DIV_CODE, 
//						INOUT_CODE:         param.INOUT_CODE,      
//						INOUT_DATE:         param.INOUT_DATE,      
//						ITEM_CODE:          param.ITEM_CODE,       
//						INOUT_Q:            param.INOUT_Q,         
//						INOUT_P:            param.INOUT_P,         
//						INOUT_I:            param.INOUT_I,
//						INOUT_DATE_FR:      param.INOUT_DATE_FR,      
//						INOUT_DATE_TO:      param.INOUT_DATE_TO  
	               }
	            });
	            win.center();
	            win.show();
	               
	      }*/
		processParams: function(params) {
			this.uniOpt.appParams = params;
			
			if(params.PGM_ID == 'arc100skr') {
				detailForm.setValue('RECE_NO',params.RECE_NO);
				this.onQueryButtonDown();
			}else if(params.PGM_ID == 'arc110ukr') {
                detailForm.setValue('RECE_NO',params.RECE_NO);
                this.onQueryButtonDown();
			}
		},
		
		fnInitInputFields: function(){
			panelSearch.setValue('DEPT_CODE',UserInfo.deptCode);
			panelResult.setValue('DEPT_CODE',UserInfo.deptCode);
			
			if(!Ext.isEmpty(UserInfo.deptCode)){
				if(UserInfo.deptCode == '01'){
                    panelSearch.getField('DEPT_CODE').setReadOnly(false);
                    panelResult.getField('DEPT_CODE').setReadOnly(false);
                    
                    detailForm.setHidden(true);
				}else{
					panelSearch.getField('DEPT_CODE').setReadOnly(true);
                    panelResult.getField('DEPT_CODE').setReadOnly(true);
                    detailForm.setHidden(false);
				}
			}else{
                panelSearch.getField('DEPT_CODE').setReadOnly(true);
                panelResult.getField('DEPT_CODE').setReadOnly(true);
			}
			
			panelSearch.setValue('AC_YEAR',new Date().getFullYear());
            panelSearch.setValue('AC_MONTH_FR',(new Date().getMonth()+1) < 10 ? '0'+ (new Date().getMonth()+1) : (new Date().getMonth()+1));
            panelSearch.setValue('AC_MONTH_TO',(new Date().getMonth()+1) < 10 ? '0'+ (new Date().getMonth()+1) : (new Date().getMonth()+1));
            panelResult.setValue('AC_YEAR',new Date().getFullYear());
            panelResult.setValue('AC_MONTH_FR',(new Date().getMonth()+1) < 10 ? '0'+ (new Date().getMonth()+1) : (new Date().getMonth()+1));
            panelResult.setValue('AC_MONTH_TO',(new Date().getMonth()+1) < 10 ? '0'+ (new Date().getMonth()+1) : (new Date().getMonth()+1));
			
            fnGetBudgCodeLevel1Store.loadStoreRecords();
            fnGetBudgCodeLevel3Store.loadStoreRecords();
            fnGetBudgCodeLevel6Store.loadStoreRecords();
            
//            fnGetBudgCodeStore.loadStoreRecords();
		/*	panelSearch.setValue('AC_DATE_FR',UniDate.get('today'));
			panelSearch.setValue('AC_DATE_TO',UniDate.get('today'));
			panelResult.setValue('AC_DATE_FR',UniDate.get('today'));
            panelResult.setValue('AC_DATE_TO',UniDate.get('today'));*/
			
			/*
			detailForm.setValue('RECE_DATE',UniDate.get('today'));
			
			detailForm.setValue('DRAFTER',UserInfo.personNumb);
			detailForm.setValue('DRAFTER_NAME',personName);
			
			detailForm.setValue('GW_STATUS','0');*/
		},
		fnInitInputFieldsDetailForm: function(){
            detailForm.setValue('DEPT_CODE',UserInfo.deptCode);
            detailForm.setValue('AC_DATE',UniDate.get('today'));
            
            detailForm.getField('AC_DATE').setReadOnly(false);
            detailForm.getField('AC_GUBUN').setReadOnly(false);
            detailForm.getField('ACCT_NO').setReadOnly(false);
		},
		onPrintButtonDown: function() {
             //var records = panelSearch.down('#imageList').getSelectionModel().getSelection();
            var param = Ext.getCmp('panelResult').getValues();
//    OZPrintWindow
            var win = Ext.create('widget.OZPrintWindow', {
               /* url: CPATH+'/atx/atx550rkrPrint.do',
                prgID: 'atx550rkr',
                extParam: param 
//                    {
//                      COMP_CODE     : UserInfo.compCode,
//                      TERM_DIVI     : param["TERM_DIVI"],
//                      AC_YYYY       : param["AC_YYYY"],
//                      BILL_DIV_CODE : param["BILL_DIV_CODE"]
//                   }
                   */
            	
            /*	loadUserConfigInfo: function() {
                    var me = this;
                    var paramTag = new Array();
             
                     paramTag[paramTag.length] = '<OBJECT id = "OZViewerControl"  CLASSID="CLSID:0DEF32F8-170F-46f8-B1FF-4BF7443F5F25" width = "100%" height = "100%">';
                     paramTag[paramTag.length] = '<param name="viewer.focus_doc_index" value="3">'; 
                     paramTag[paramTag.length] = '<param name="viewer.childcount" value="0">';  
                     paramTag[paramTag.length] = '<param name="viewer.showtree" value="false">'; 
                     paramTag[paramTag.length] = '<param name="print.alldocument" value="true">'; 
                     paramTag[paramTag.length] = '<param name="global.concatpage" value="true">';   
                     paramTag[paramTag.length] = '<param name="connection.servlet" value="http://211.241.199.190:8080/oz70/server">';
                     paramTag[paramTag.length] = '<param name="connection.reportname" value="'+'test'+'.ozr">';
                    // paramTag[paramTag.length] = '<param name="connection.reportname" value="'+<%= request.getParameter("pre") %>+<%= request.getParameter("reportname") %>+'.ozr">';
                     paramTag[paramTag.length] = '<param name="applet.configmode" value="html">';
                     paramTag[paramTag.length] = '<param name="applet.isframe"        value="false">';
                     paramTag[paramTag.length] = '<param name="connection.pcount"     value="1">';
                     paramTag[paramTag.length] = '<param name="connection.args1" value="ciseq=230">';
                     paramTag[paramTag.length] = '<param name="applet.isapplet"       value="false">';
                     paramTag[paramTag.length] = '<param name="odi.odinames" value="'+<%= request.getParameter("reportname") %>+'">'; 
                     paramTag[paramTag.length] = '<param name="odi.REPAIRREQENDVIEW.pcount" value="2">';
                     paramTag[paramTag.length] = '<param name="odi.REPAIRREQENDVIEW.args2" value="owner_name=special">';
                     paramTag[paramTag.length] = '<param name="odi.REPAIRREQENDVIEW.args1" value="args1='+<%= request.getParameter("args1") %>+'">';
                       
                     paramTag[paramTag.length] = '</OBJECT>';
                     me.oz_activex_build(paramTag);
                
                }*/
            });
            win.center();
            win.show();
            
            alert('aaaa');
            
/*             var paramTag = new Array();
 
 paramTag[paramTag.length] = '<OBJECT id = "OZViewerControl"  CLASSID="CLSID:0DEF32F8-170F-46f8-B1FF-4BF7443F5F25" width = "100%" height = "100%">';
 paramTag[paramTag.length] = '<param name="viewer.focus_doc_index" value="3">'; 
 paramTag[paramTag.length] = '<param name="viewer.childcount" value="0">';  
 paramTag[paramTag.length] = '<param name="viewer.showtree" value="false">'; 
 paramTag[paramTag.length] = '<param name="print.alldocument" value="true">'; 
 paramTag[paramTag.length] = '<param name="global.concatpage" value="true">';   
 paramTag[paramTag.length] = '<param name="connection.servlet" value="http://211.241.199.190:8080/oz70/server">';
 paramTag[paramTag.length] = '<param name="connection.reportname" value="'+'test'+'.ozr">';
// paramTag[paramTag.length] = '<param name="connection.reportname" value="'+<%= request.getParameter("pre") %>+<%= request.getParameter("reportname") %>+'.ozr">';
 paramTag[paramTag.length] = '<param name="applet.configmode" value="html">';
 paramTag[paramTag.length] = '<param name="applet.isframe"        value="false">';
 paramTag[paramTag.length] = '<param name="connection.pcount"     value="1">';
 paramTag[paramTag.length] = '<param name="connection.args1" value="ciseq=230">';
 paramTag[paramTag.length] = '<param name="applet.isapplet"       value="false">';
 paramTag[paramTag.length] = '<param name="odi.odinames" value="'+<%= request.getParameter("reportname") %>+'">'; 
 paramTag[paramTag.length] = '<param name="odi.REPAIRREQENDVIEW.pcount" value="2">';
 paramTag[paramTag.length] = '<param name="odi.REPAIRREQENDVIEW.args2" value="owner_name=special">';
 paramTag[paramTag.length] = '<param name="odi.REPAIRREQENDVIEW.args1" value="args1='+<%= request.getParameter("args1") %>+'">';
   
 paramTag[paramTag.length] = '</OBJECT>';
 oz_activex_build(paramTag);
 
 */
        }
	});
/*	Unilite.createValidator('validator01', {
		store: directDetailStore,
		grid: detailGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
			
			}
				return rv;
						}
			});	*/
/*	Unilite.createValidator('validator02', {
		forms: {'formA:':detailForm},
		validate: function( type, fieldName, newValue, lastValidValue, record, form, field) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'lastValidValue':lastValidValue, 'record':record});
			var rv = true;	
			switch(fieldName) {	
				case fieldName:
//				    if(newValue != lastValidValue){
//					   UniAppManager.setToolbarButtons('save',true);
//				    }
					break;
			}
			return rv;
		}
	});		*/
};
window.addEventListener("beforeunload", arc100unload);
function arc100unload(event) {
    if(gsWin != null){
        gsWin.close();
    }
}


function oz_activex_build(paramTag){ 
   for(var i = 0 ; i < paramTag.length; i++){
   document.write(paramTag[i]);
   }
 }


function fn_report_print(args1){
       var opt = {              
           url:"/report.jsp?pre='/special/2012/machine/repair/'&reportname='REPAIRREQENDVIEW'&args1='"+args1+"'"
           , width:1000
           , height:900
           , name:"cable_charger_list" 
       };
           
fn_open_window(opt);
}
</script>

<form id="f1" name="f1" action="" method="post" onSubmit="return false;" >
<input type="hidden" id="loginid" name="loginid" value="superadmin" />
<input type="hidden" id="fmpf" name="fmpf" value="WF_BOND_TR_REQ" />
<input type="hidden" id="fmbd" name="fmbd" runat="server" />
</form>